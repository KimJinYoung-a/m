<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/apps/appCom/wish/protoV3/inc_constVar.asp"-->
<!-- #include virtual="/apps/appCom/wish/protoV3/wishCls.asp"-->
<!-- #include virtual="/apps/appCom/wish/protoV3/searchItemCls.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/shoppingchanceCls_B.asp" -->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/searchItemProc.asp
' Discription : Wish APP 상품 검색 목록 출력 (검색엔진 사용)
' Request : json > type, offset, size, filter, OS, versioncode, versionname, verserion
' Response : response > 결과, requestoffset, requestsize, numofproduct, product(array), firstcategorylist(array), secondcategorylist(array)
' History : 2014.01.14 허진원 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "text/html"

Dim sType, sKind, sUId, sOffset, sSize, sFDesc, i, j
Dim sortMtd, priceMin, priceMax, colorCd, dispCate, keyword, makerid, delitp, SellScope
Dim rstxt ''결과내 재검색어.
Dim DocSearchText
Dim sData : sData = Request("json")
Dim oJson
Dim sflag, sscp

'// 전송결과 파징
'on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = oResult.type
	sOffset = getNumeric(requestCheckVar(oResult.offset,8))		'페이지 시작지점
	sSize = getNumeric(requestCheckVar(oResult.size,8))			'페이지당 출력수

	'검색 필터 분해  // getParseFilterV3 로 변경.
	''call getParseFilterV3(oResult.filter,sortMtd, priceMin, priceMax, colorCd, dispCate, keyword, makerid, delitp, rstxt)
	call getParseFilterV31(oResult.filter,sortMtd, priceMin, priceMax, colorCd, dispCate, keyword, makerid, delitp, rstxt,sflag,sscp)
set oResult = Nothing

'// json객체 선언
Set oJson = jsObject()

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."
elseif sType<>"searchlist" then
	'// 페이지 타입 아님
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "잘못된 접근입니다."
else
	dim oItemList, oDoc, listDiv, SearchItemDiv
    dim p_numofproduct
    
    ''V3 오류 2015/10/09
    dispCate = replace(dispCate,"(HOME)","")
    
	'검색 유형 설정
	SellScope = "Y"
	if dispCate<>"" then
		listDiv = "list"
		SearchItemDiv = "n"
	elseif keyword<>"" then
		listDiv = "search"
		SearchItemDiv = "y"
	elseif makerid<>"" then
		listDiv = "brand"
		SearchItemDiv = "y"
	elseif colorCd<>"" then
		listDiv = "colorlist"
		SearchItemDiv = "y"
	else
		listDiv = "list"
		SearchItemDiv = "y"
	end if
    
    '' 2014/10/06 수정
    if keyword<>"" then
		listDiv = "search"
		SearchItemDiv = "y"
	end if
	
    if makerid<>"" then
		listDiv = "brand"
		SearchItemDiv = "y"
		SellScope = ""
	end if
	
	'' 2015/09/23 추가 V3 // 결과내 재검색
	if (keyword<>"") then
	    if (Trim(rstxt)<>"") then
	        DocSearchText = rstxt & " " & keyword
	    else
	        DocSearchText = keyword
	    end if
    end if
    
    ''2015/12/10 추가 품절제외 및 포장
	if (sscp<>"") then
	    SellScope = sscp
	end if
	
	if (sflag<>"pk") then
	    sflag = ""
	end if
	
	'#검색엔진에서 상품검색
	set oDoc = new SearchItemCls
	oDoc.FListDiv = listDiv
	oDoc.FRectSearchTxt = DocSearchText
	if ((dispCate<>"") or (makerid<>"")) and (rstxt<>"") and (DocSearchText="") then  ''카테고리 결과내 검색.
	    oDoc.FRectSearchTxt = rstxt
	end if
	oDoc.FRectSortMethod	= sortMtd
	oDoc.FRectSearchFlag = sflag
	oDoc.FRectSearchItemDiv = SearchItemDiv		'기본카테고리 검색 여부
	oDoc.FRectSearchCateDep = "T"		'하위 카테고리 검색 여부
	oDoc.FRectCateCode	= dispCate
	oDoc.FRectMakerid	= makerid
	if priceMin>0 then oDoc.FminPrice	= priceMin
	if priceMax>0 then oDoc.FmaxPrice	= priceMax
	oDoc.StartNum = sOffset			'검색 시작 지점
	oDoc.FPageSize = sSize			'검색 페이지 단위
	oDoc.FLogsAccept = true		'로그 없음 //2015/03/04 로그생성
	oDoc.FcolorCode = colorCd
    oDoc.FdeliType = delitp         '' 배송구분 V2 추가
    oDoc.FSellScope = SellScope
    
	'// 결과 출력
	oJson("response") = getErrMsg("1000",sFDesc)
	oJson("requestoffset") = sOffset			'시작지점
	oJson("requestsize") = sSize				'페이지당 수

	Set oJson("product") = oDoc.getSearchListJson()	'상품목록(array) 반환
	oJson("numofproduct") = cStr(oDoc.FTotalCount)		'전체 검색수
    p_numofproduct = oDoc.FTotalCount
	if sOffset="" or sOffset="0" then
		'첫페이지만 카테고리 목록 출력
		Set oItemList = new CWish
	
		if dispCate<>"" then
			dim sDep
			sDep = cStr(len(dispCate)\3)+1			'하위 뎁스

				
			'// 키워드검색, 브랜드검색, 3depth은 검색엔진, 그렇지 않으면 모두 DB사용
			if sDep>4 or (keyword="" and makerid="") then
				
				oItemList.FRectCateCd = dispCate
				Set oJson("nextcategory") = oItemList.getDispCategoryListJson(sDep)
				
				''마지막 카테고리라면 2014/10/02
				if (toJSON(oJson("nextcategory"))="[]") then
				    oItemList.FRectCateCd = left(dispCate,(sDep-2)*3)
				        Set oJson("lastcategory") = oItemList.getDispCategoryListJson(sDep-1)
				else
				    Set oJson("lastcategory") = jsArray()
				end if
			else
				'1st 카테고리
				if sDep<2 then sDep=2
				if sDep>2 then
					oDoc.FRectCateCode = left(dispCate,(sDep-2)*3)
				else
					oDoc.FRectCateCode = " "
				end if
				'oDoc.FGroupScope = sDep-1
				'Set oJson("firstcategorylist") = oDoc.getGroupbyCategoryListJson()

				'2nd 카테고리
				if sDep>3 then
					'Set oJson("secondcategorylist") = jsArray()			'4뎁스 이상은 표시안함(2014.02.11;허진원)
					Set oJson("nextcategory") = jsArray()
					
					''마지막 카테고리라면
					oDoc.FGroupScope = sDep-1
					Set oJson("lastcategory") = oDoc.getGroupbyCategoryListJson()
				else
					oDoc.FRectCateCode = left(dispCate,(sDep-1)*3)
					'oDoc.FRectCateCode = dispCate
					oDoc.FGroupScope = sDep
					oDoc.FRectSearchItemDiv="y"
					oDoc.FLogsAccept = False
					
					'Set oJson("secondcategorylist") = oDoc.getGroupbyCategoryListJson()
					Set oJson("nextcategory") = oDoc.getGroupbyCategoryListJson()
					
					''마지막 카테고리라면
					if (toJSON(oJson("nextcategory"))="[]") then
					    oDoc.FGroupScope = sDep-1
					    Set oJson("lastcategory") = oDoc.getGroupbyCategoryListJson()
					else
					    Set oJson("lastcategory") = jsArray()
					end if
				end if
			end if
		else
			oDoc.FGroupScope = 1
			Set oJson("nextcategory") = oDoc.getGroupbyCategoryListJson()
			Set oJson("lastcategory") = jsArray()
		end if
	
		Set oItemList = Nothing
	else
		'카테고리 출력 안함
        
        Set oJson("nextcategory") = jsArray()
        Set oJson("lastcategory") = jsArray()
	end if

	'// 선택된 FirstCatogory명 출력 //삭제
	''oJson("firstcategory") = CategoryNameUseLeftMenuDB(dispCate)
''필요시 이걸 사용
	if (dispCate<>"") then
	    if (keyword="") and (makerid="") then ''카테고리라면
            Set oJson("prevcategory") = getCurrentCateListJson(dispCate,p_numofproduct,false)
        else
            Set oJson("prevcategory") = getCurrentCateListJson(dispCate,p_numofproduct,true)
        end if
    else
        Set oJson("prevcategory") = getCurrentCateListHomeOnly() ''jsArray() ''전체 없애려면 jsArray
    end if


    ''연관검색어 protocol v2 추가 // 키워드검색/ 첫페이지만.
    dim oRckDoc
    if (sOffset="" or sOffset="0") and (keyword<>"") then
        set oRckDoc = new SearchItemCls
        	oRckDoc.FRectSearchTxt = keyword
        	Set oJson("relatedkeywords") = oRckDoc.getRecommendKeyWordsJson()
        Set oRckDoc = nothing
    else
        Set oJson("relatedkeywords") = jsArray()
    end if
    
    
    ''연관브랜드 protocol v2 추가 // 키워드검색/ 첫페이지만.
    dim oGrBrn
    if (sOffset="" or sOffset="0") and (keyword<>"") then
        set oGrBrn = new SearchItemCls
    	oGrBrn.FRectSearchTxt = DocSearchText
    	oGrBrn.FRectSortMethod = sortMtd
    	oGrBrn.FRectSearchItemDiv = SearchItemDiv
    	oGrBrn.StartNum = sOffset			'검색 시작 지점
    	oGrBrn.FPageSize = 50                               ''갯수.
    	oGrBrn.FListDiv = ListDiv
    	oGrBrn.FLogsAccept = False
    	Set oJson("relatedbrands") = oGrBrn.getGroupbyBrandListJson
    	
    	Set oGrBrn=Nothing
    else
        Set oJson("relatedbrands") = jsArray()
    end if   
	
    ''연관 이벤트
    dim oGrEvt
    if (sOffset="" or sOffset="0") and (keyword<>"")  then
        set oGrEvt = new SearchItemCls
    	oGrEvt.FRectSearchTxt = DocSearchText
    	''oGrEvt.FRectExceptText = ExceptText
    	oGrEvt.FRectChannel = "A"		'검색 채널 (W:isWeb, M:isMobile, A:isApp)
    	oGrEvt.StartNum = sOffset
    	oGrEvt.FPageSize = 20  ''
    	oGrEvt.FLogsAccept = False
    	Set oJson("relatedevents") = oGrEvt.getEventListJson
	else
        Set oJson("relatedevents") = jsArray()
    end if 
	
	''카테고리메인 스와이프영역
	if (sOffset="" or sOffset="0") and (keyword="") and (makerid="") and (LEN(dispCate)=3) then
	    Set oJson("catebanner") = getCateBannerJson(dispCate)
	else
	    Set oJson("catebanner") = jsArray()
    end if
	set oDoc = Nothing

end if

if ERR then Call OnErrNoti()
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing

function getCateBannerJson(idispCate)
    Dim arrEBList, vEBName, vEBLink, vEBImg
	Dim intLoop
    Dim strSql
    
	'이벤트 데이터 가져오기
	strSql = "[db_event].[dbo].sp_Ten_event_BanListCate_TopN_APP (3,'"&LEFT(idispCate,3)&"')"
	
	Dim rsMem
	set rsMem = getDBCacheSQL(dbget,rsget,"CABA_AC",strSql,60*10)  ''10분
	if NOT (rsMem is Nothing) then 
    	IF Not (rsMem.EOF OR rsMem.BOF) THEN
    		arrEBList = rsMem.GetRows()
    	END IF
	    rsMem.close
	end if
	set rsMem = Nothing
	
	dim retObj : SET retObj= jsArray()
    IF isArray(arrEBList) THEN
        For intLoop =0 To UBound(arrEBList,2)
        
    		vEBLink = "http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid="&arrEBList(0,intLoop)
            vEBImg  = arrEBList(2,intLoop)
            if arrEBList(2,intLoop)="" then vEBImg=arrEBList(1,intLoop)
            
            if (vEBImg<>"") and (vEBLink<>"") then
                Set retObj(Null) = jsObject()
                retObj(Null)("imgurl") = vEBImg
                retObj(Null)("linkurl") = vEBLink
                
                retObj(Null)("openType") = "OPEN_TYPE__FROM_RIGHT"
                retObj(Null)("ltbs") = array()
                retObj(Null)("title") = "이벤트"
                retObj(Null)("rtbs") = array("BTN_TYPE__SHARE","BTN_TYPE__CART")
                
                retObj(Null)("pageType") = "event"
            end if
        Next
        
    END IF
    Set getCateBannerJson = retObj
end function


%>
<!-- #include virtual="/lib/db/dbclose.asp" -->