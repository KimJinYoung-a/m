<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/apps/appCom/wish/protoV2/inc_constVar.asp"-->
<!-- #include virtual="/apps/appCom/wish/protoV2/wishCls.asp"-->
<!-- #include virtual="/apps/appCom/wish/protoV2/searchItemCls.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
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
Dim sortMtd, priceMin, priceMax, colorCd, dispCate, keyword, makerid, delitp
Dim sData : sData = Request("json")
Dim oJson

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = oResult.type
	sOffset = getNumeric(requestCheckVar(oResult.offset,8))		'페이지 시작지점
	sSize = getNumeric(requestCheckVar(oResult.size,8))			'페이지당 출력수

	'검색 필터 분해
	call getParseFilterV2(oResult.filter,sortMtd, priceMin, priceMax, colorCd, dispCate, keyword, makerid, delitp)
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
	'검색 유형 설정
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

	'#검색엔진에서 상품검색
	set oDoc = new SearchItemCls
	oDoc.FListDiv = listDiv
	oDoc.FRectSearchTxt = keyword
	oDoc.FRectSortMethod	= sortMtd
	oDoc.FRectSearchFlag = ""
	oDoc.FRectSearchItemDiv = SearchItemDiv		'기본카테고리 검색 여부
	oDoc.FRectSearchCateDep = "T"		'하위 카테고리 검색 여부
	oDoc.FRectCateCode	= dispCate
	oDoc.FRectMakerid	= makerid
	if priceMin>0 then oDoc.FminPrice	= priceMin
	if priceMax>0 then oDoc.FmaxPrice	= priceMax
	oDoc.StartNum = sOffset			'검색 시작 지점
	oDoc.FPageSize = sSize			'검색 페이지 단위
	oDoc.FLogsAccept = false		'로그 없음
	oDoc.FcolorCode = colorCd
    oDoc.FdeliType = delitp         '' 배송구분 V2 추가
    
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
  

'            ''NextCategory
'            if sDep>4 then ''3뎁쓰 까지만 사용.
'                Set oJson("nextcategory") = jsArray()
'            else
'				oDoc.FRectCateCode = left(dispCate,(sDep-1)*3)
'				oDoc.FGroupScope = sDep
'				Set oJson("nextcategory") = oDoc.getGroupbyCategoryListJson()
'			end if	
				
			'// 키워드검색, 브랜드검색, 3depth은 검색엔진, 그렇지 않으면 모두 DB사용
			if sDep>4 or (keyword="" and makerid="") then
				'1st 카테고리
				'oItemList.FRectCateCd = left(dispCate,(sDep-2)*3)
				'Set oJson("firstcategorylist") = oItemList.getDispCategoryListJson(sDep-1)

				'2nd 카테고리
				'oItemList.FRectCateCd = dispCate
				'Set oJson("secondcategorylist") = oItemList.getDispCategoryListJson(sDep)
				
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
					oDoc.FGroupScope = sDep
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
			''Set oJson("firstcategorylist") = oItemList.getDispCategoryListJson("1")
			''oDoc.FGroupScope = 1
			''Set oJson("firstcategorylist") = oDoc.getGroupbyCategoryListJson()
			''Set oJson("secondcategorylist") = jsArray()
			oDoc.FGroupScope = 1
			Set oJson("nextcategory") = oDoc.getGroupbyCategoryListJson()
			Set oJson("lastcategory") = jsArray()
		end if
	
		Set oItemList = Nothing
	else
		'카테고리 출력 안함
''		Set oJson("firstcategorylist") = jsArray()
''		Set oJson("secondcategorylist") = jsArray()
        
        Set oJson("nextcategory") = jsArray()
        Set oJson("lastcategory") = jsArray()
	end if

	'// 선택된 FirstCatogory명 출력 //삭제
	''oJson("firstcategory") = CategoryNameUseLeftMenuDB(dispCate)
''필요시 이걸 사용
	if (dispCate<>"") then
        Set oJson("prevcategory") = getCurrentCateListJson(dispCate,p_numofproduct)
    else
        Set oJson("prevcategory") = getCurrentCateListHomeOnly() ''jsArray()
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
    	oGrBrn.FRectSearchTxt = keyword
    	oGrBrn.FRectSortMethod = sortMtd
    	oGrBrn.FRectSearchItemDiv = SearchItemDiv
    	oDoc.StartNum = sOffset			'검색 시작 지점
    	oGrBrn.FPageSize = 50                               ''갯수.
    	oGrBrn.FListDiv = ListDiv
    	oGrBrn.FLogsAccept = False
    	Set oJson("relatedbrands") = oGrBrn.getGroupbyBrandListJson
    	
    	Set oGrBrn=Nothing
    else
        Set oJson("relatedbrands") = jsArray()
    end if   
	

	set oDoc = Nothing
end if

if ERR then Call OnErrNoti()
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->