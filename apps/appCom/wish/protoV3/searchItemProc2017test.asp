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
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/searchItemProc2017.asp
' Discription : 검색용 상품 목록 출력 (검색엔진 사용)
' Request : json > type, offset, size, filter, OS, versioncode, versionname, verserion
' Response : response > 결과, 
' History : 2017.08.31 강준구 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "application/json"


Dim sData : sData = Request("json")
Dim oJson
dim DocSearchText, sType, sSize, sFDesc
dim SearchText : SearchText = requestCheckVar(request("rect"),100) '현재 입력된 검색어
dim SellScope 	: SellScope=requestCheckVar(request("sscp"),1)			'품절상품 제외여부
dim deliType : deliType = requestCheckVar(request("deliType"),2)
dim SearchFlag : SearchFlag = requestCheckVar(request("sflag"),2)
dim pojangok : pojangok = requestCheckVar(request("pojangok"),1)
Dim mode : mode = requestCheckVar(request("mode"),1) ''리스트형 썸네일형
dim SortMet		: SortMet = requestCheckVar(request("srm"),2)
dim dispCate : dispCate = getNumeric(requestCheckVar(request("dispCate"),18))
dim makerid : makerid = ReplaceRequestSpecialChar(request("mkr"))
dim styleCD : styleCD = CStr(ReplaceRequestSpecialChar(request("styleCd")))
dim colorCD : colorCD = CStr(requestCheckVar(request("iccd"),128))
dim minPrice : minPrice = getNumeric(requestCheckVar(Replace(request("minPrc"),",",""),8))
dim maxPrice : maxPrice = getNumeric(requestCheckVar(Replace(request("maxPrc"),",",""),8))
dim ReSearchText : ReSearchText=requestCheckVar(request("rstxt"),100) '결과내 재검색용
dim offset : offset = requestCheckVar(request("offset"),10)
dim vListOption : vListOption = requestCheckVar(request("listoption"),10)
dim vSearchGubun : vSearchGubun = requestCheckVar(request("searchgubun"),30)
dim vSearchGubunKWD : vSearchGubunKWD = requestCheckVar(request("searchgubunkwd"),100)
'// 전송결과 파징
'on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = oResult.type
	vSearchGubun = oResult.searchgubun
	vSearchGubunKWD = oResult.searchgubunkwd
	'sSize = getNumeric(requestCheckVar(oResult.size,8))			'페이지당 출력수

	'검색 필터 분해
	call getParseFilterV32(oResult.filter, SearchText, SellScope, deliType, SearchFlag, pojangok, mode, SortMet, dispCate, makerid, styleCD, colorCD, minPrice, maxPrice, ReSearchText, offset, vListOption)
set oResult = Nothing

If vListOption = "" Then
	vListOption = "all"
End If

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
	If SellScope = "" Then
		SellScope = "Y"
	End If
	
	if dispCate<>"" then
		listDiv = "list"
		SearchItemDiv = "n"
	elseif SearchText<>"" then
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
    if SearchText<>"" then
		listDiv = "search"
		SearchItemDiv = "y"
	end if
	
    if makerid<>"" then
		listDiv = "brand"
		SearchItemDiv = "y"
		SellScope = ""
	end if
	
	If mode = "" Then
		If SearchText = "" AND dispCate <> "" Then	'### 카테고리
			mode = "S"
		ElseIf SearchText = "" AND makerid <> "" Then	'### 브랜드
			mode = "S"
		Else
			mode = "L"
		End If
	End If
	
	If offset = "" Then offset = 0
	if SortMet="" then SortMet="be"		'베스트:be, 신상:ne
		
	If mode = "L" Then
		sSize = "15"
	Else
		sSize = "30"
	End If
	
	'' 2015/09/23 추가 V3 // 결과내 재검색
	if (SearchText<>"") then
		SearchText = RepWord(SearchText,"[^ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9.&%\-\_\s]","")
	    if (Trim(ReSearchText)<>"") then
	    	 ReSearchText = RepWord(ReSearchText,"[^ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9.&%\-\_\s]","")
	        DocSearchText = ReSearchText & " " & SearchText
	    else
	        DocSearchText = SearchText
	    end if
    end if

	'특정 단어 삭제
	DocSearchText = Trim(Replace(DocSearchText,"상품",""))
    
    '페이징넘버
    Dim CurrPage
    If offset = 0 Then
    	CurrPage = 1
	Else
	    If vListOption = "all" or vListOption = "item" Then
			If mode = "L" Then
				CurrPage = (offset/15)+1
			Else
				CurrPage = (offset/30)+1
			End If
		ElseIf vListOption = "event" Then	'### 이벤트 만
			CurrPage = (offset/16)+1
		ElseIf vListOption = "playing" Then	'### 플레잉 만
			CurrPage = (offset/16)+1
		End If
	End If

	'#검색엔진에서 상품검색
	set oDoc = new SearchItemCls
	oDoc.FListDiv = listDiv
	oDoc.FRectSearchTxt = DocSearchText
	if ((dispCate<>"") or (makerid<>"")) and (ReSearchText<>"") and (DocSearchText="") then  ''카테고리 결과내 검색.
	    oDoc.FRectSearchTxt = ReSearchText
	end if
	oDoc.FRectSortMethod	= SortMet
	oDoc.FRectSearchFlag = fnSalePojang(searchFlag,pojangok)
	oDoc.FRectSearchItemDiv = SearchItemDiv		'기본카테고리 검색 여부
	oDoc.FRectSearchCateDep = "T"		'하위 카테고리 검색 여부
	oDoc.FRectCateCode	= dispCate
	oDoc.FRectMakerid	= makerid
	if minPrice>0 then oDoc.FminPrice	= minPrice
	if maxPrice>0 then oDoc.FmaxPrice	= maxPrice
	oDoc.StartNum = offset			'검색 시작 지점
	oDoc.FPageSize = sSize			'검색 페이지 단위
	oDoc.FLogsAccept = true		'로그 없음 //2015/03/04 로그생성
	oDoc.FcolorCode = colorCd
	oDoc.FstyleCd = styleCd
    oDoc.FdeliType = deliType         '' 배송구분 V2 추가
    oDoc.FSellScope = SellScope
    oDoc.FRectColsSize = 6
    oDoc.FSearchGubun = vSearchGubun
    oDoc.FSearchGubunKWD = vSearchGubunKWD
    
	'// 결과 출력
	oJson("response") = getErrMsg("1000",sFDesc)
	oJson("requestoffset") = offset			'시작지점
	oJson("requestsize") = sSize				'페이지당 수
	oJson("replacement") = fnGetReplacementKeyword(DocSearchText)
	
	Dim oGrEvt, oDocPl
	If vListOption = "all" or vListOption = "item" Then	'### 전체검색, 상품검색 만
		Set oJson("product") = oDoc.getSearchListJson2017()	'상품목록(array) 반환
		
		If vListOption = "all" and (SearchText<>"") Then
			Dim oMktEvt, oPlanEvt, vEnm, oPlaying
			'// 이벤트 검색결과
			set oGrEvt = new SearchEventCls
			oGrEvt.FRectSearchTxt = DocSearchText
			oGrEvt.FRectChannel = "A"		'검색 채널 (W:isWeb, M:isMobile, A:isApp)
			oGrEvt.FCurrPage = CurrPage
			oGrEvt.FPageSize = 1
			oGrEvt.FScrollCount =10
			oGrEvt.FRectGubun = "mktevt"
			oGrEvt.getEventList
			
			If oGrEvt.FResultCount > 0 Then
				vEnm = db2html(oGrEvt.FItemList(0).Fevt_name)
				Set oMktEvt = jsObject()
				oMktEvt("evtgubun") = cStr("이벤트")
				oMktEvt("evtcode") = b64encode(mDomain &"/apps/appCom/wish/web2014/event/eventmain.asp?eventid="&oGrEvt.FItemList(0).Fevt_code&"&pNtr=re_"&server.URLEncode(DocSearchText))
				oMktEvt("evtname") = stripHTML(fnEventNameSplit(cStr(vEnm),"name"))
				oMktEvt("evtsubcopy") = cStr(db2html(oGrEvt.FItemList(0).Fevt_subcopyK))
				
				If oGrEvt.FItemList(0).Fetc_itemimg = "" Then
					oMktEvt("evtimg") = b64encode("http://webimage.10x10.co.kr/image/icon1/" & GetImageSubFolderByItemid(itemid) & "/" & oGrEvt.FItemList(0).Ficon1image & "")
				Else
					oMktEvt("evtimg") = b64encode(oGrEvt.FItemList(0).Fetc_itemimg)
				End If
				
				if ubound(Split(vEnm,"|"))> 0 Then
					If oGrEvt.FItemList(0).Fissale Or (oGrEvt.FItemList(0).Fissale And oGrEvt.FItemList(0).Fiscoupon) then
						oMktEvt("evtdiscountgubun") = cStr("sale")
						oMktEvt("evtdiscount") = cStr(Split(vEnm,"|")(1))
					ElseIf oGrEvt.FItemList(0).Fiscoupon Then
						oMktEvt("evtdiscountgubun") = cStr("coupon")
						oMktEvt("evtdiscount") = cStr(Split(vEnm,"|")(1) & "쿠폰")
					End If
				else
					oMktEvt("evtdiscountgubun") = cStr("")
					oMktEvt("evtdiscount") = cStr("")
				end If
				
				set oJson("mktevt") = oMktEvt
				Set oMktEvt = Nothing
			End If
			
			oGrEvt.FRectGubun = "planevt"
			oGrEvt.getEventList
			
			If oGrEvt.FResultCount > 0 Then
				vEnm = db2html(oGrEvt.FItemList(0).Fevt_name)
				Set oPlanEvt = jsObject()
				oPlanEvt("evtgubun") = cStr("기획전")
				oPlanEvt("evtcode") = b64encode(mDomain &"/apps/appCom/wish/web2014/event/eventmain.asp?eventid="&oGrEvt.FItemList(0).Fevt_code&"&pNtr=re_"&server.URLEncode(DocSearchText))
				oPlanEvt("evtname") = stripHTML(fnEventNameSplit(cStr(vEnm),"name"))
				oPlanEvt("evtsubcopy") = cStr(db2html(oGrEvt.FItemList(0).Fevt_subcopyK))
				
				If oGrEvt.FItemList(0).Fetc_itemimg = "" Then
					oPlanEvt("evtimg") = b64encode("http://webimage.10x10.co.kr/image/icon1/" & GetImageSubFolderByItemid(oGrEvt.FItemList(0).Fetc_itemid) & "/" & oGrEvt.FItemList(0).Ficon1image & "")
				Else
					oPlanEvt("evtimg") = b64encode(oGrEvt.FItemList(0).Fetc_itemimg)
				End If
				
				if ubound(Split(vEnm,"|"))> 0 Then
					If oGrEvt.FItemList(0).Fissale Or (oGrEvt.FItemList(0).Fissale And oGrEvt.FItemList(0).Fiscoupon) then
						oPlanEvt("evtdiscountgubun") = cStr("sale")
						oPlanEvt("evtdiscount") = cStr(Split(vEnm,"|")(1))
					ElseIf oGrEvt.FItemList(0).Fiscoupon Then
						oPlanEvt("evtdiscountgubun") = cStr("coupon")
						oPlanEvt("evtdiscount") = cStr(Split(vEnm,"|")(1) & "쿠폰")
					End If
				else
					oPlanEvt("evtdiscountgubun") = cStr("")
					oPlanEvt("evtdiscount") = cStr("")
				end If
				
				set oJson("planevt") = oPlanEvt
				Set oPlanEvt = Nothing
			End If
			
			set oGrEvt = nothing
			
			
			'// 플레잉 검색결과
			set oDocPl = new SearchPlayingCls
			oDocPl.FRectSearchTxt = DocSearchText
			oDocPl.FCurrPage = CurrPage
			oDocPl.FPageSize = 1
			oDocPl.FScrollCount =10
			oDocPl.getPlayingList2017
			
			If oDocPl.FResultCount > 0 Then
				Set oPlaying = jsObject()
				oPlaying("didx") = cStr(oDocPl.FItemList(0).Fdidx)
				oPlaying("linkurl") = b64encode(mDomain &"/apps/appCom/wish/web2014/playing/view.asp?didx="&oDocPl.FItemList(0).Fdidx&"&pNtr=rp_"&server.URLEncode(DocSearchText))
				oPlaying("title") = cStr(db2html(oDocPl.FItemList(0).Ftitle))
				If oDocPl.FItemList(0).Fimg28 <> "" Then
					oPlaying("bggubun") = cStr("i")
					oPlaying("background") = b64encode(oDocPl.FItemList(0).Fimg28)
				Else
					oPlaying("bggubun") = cStr("c")
					If oDocPl.FItemList(0).Fmo_bgcolor <> "" Then
						oPlaying("background") = cStr(oDocPl.FItemList(0).Fmo_bgcolor)
					Else
						oPlaying("background") = cStr("ffdddb")
					End If
				End IF
				set oJson("playing") = oPlaying
				Set oPlaying = Nothing
			End If
			set oDocPl = nothing
			
		End If
	End If
	oJson("numofproduct") = cStr(oDoc.FTotalCount)		'전체 검색수
    p_numofproduct = oDoc.FTotalCount
	if offset="" or offset="0" then
		'첫페이지만 카테고리 목록 출력
		Set oItemList = new CWish

		'// 검색 로그 사용여부(2017.01.12)
		Dim LogUsingCustomChk
		If getLoginUserId="thensi7" Then
			LogUsingCustomChk = True
		Else
			LogUsingCustomChk = True
		End If
		
		'// 검색 로그저장(2017.01.11 원승현)
		If LogUsingCustomChk Then
			If IsUserLoginOK() Then
				If Trim(DocSearchText)<>"" Then
					Call fnUserLogCheck("rect", getEncLoginUserId, "", "", DocSearchText, "app")
				End If
			End If
		End If
	
		if dispCate<>"" then
			dim sDep
			sDep = cStr(len(dispCate)\3)+1			'하위 뎁스

				
			'// 키워드검색, 브랜드검색, 3depth은 검색엔진, 그렇지 않으면 모두 DB사용
			if sDep>4 or (SearchText="" and makerid="") then
				
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
	    if (SearchText="") and (makerid="") then ''카테고리라면
            Set oJson("prevcategory") = getCurrentCateListJson(dispCate,p_numofproduct,false)
        else
            Set oJson("prevcategory") = getCurrentCateListJson(dispCate,p_numofproduct,true)
        end if
    else
        Set oJson("prevcategory") = getCurrentCateListHomeOnly() ''jsArray() ''전체 없애려면 jsArray
    end if


	'// 첫페이지만.
	if (offset="" or offset="0") and (SearchText<>"") and (vListOption = "all") then
		'### 퀵링크
		Dim cQ, vArrQ, vQuickCnt, vQuickType, oQuick, vQLinkGubun, vQCode, vQBLinkGubun, vQBCode, vQTitle, vQBTitle
		Set cQ = New CDBSearch
		cQ.FRectKeyword = SearchText
		cQ.FRectIDX = 0
		vArrQ = cQ.fnSearchQuickLink()
		vQuickCnt = cQ.FResultCount
		Set cQ = Nothing
		
		If vQuickCnt > 0 Then
			If isArray(vArrQ) Then
				'type:1, name:2, brandid:3, subcopy:4, url_m:6, btnname:10, btn_mlink:12, btn_color:13, bggubun:14, bgcolor:15, bgimgm:17, qimg_useyn:18, qimgm:20, htmlcont:21
				vQLinkGubun = fnURLTypeGB(vArrQ(6,0))
				vQBLinkGubun = fnURLTypeGB(vArrQ(12,0))
				
				Set oQuick = jsObject()
				oQuick("type") = cStr(vArrQ(1,0))
				oQuick("title") = cStr(db2html(vArrQ(2,0)))
				oQuick("subcopy") = cStr(db2html(vArrQ(4,0)))
				oQuick("quicklinktype") = cStr(vQLinkGubun)
				If vQLinkGubun = "etc" or vQLinkGubun = "prd" Then
					oQuick("quickurl") = b64encode(mDomain & "/apps/appCom/wish/web2014/" & fnMoAppDifferentURL(vArrQ(6,0)) & CHKIIF(InStr(vArrQ(6,0),"?")>0,"&pNtr=qq_"&server.URLEncode(SearchText)&"&rc=qlnk_1_0","?pNtr=qq_"&server.URLEncode(SearchText)&"&rc=qlnk_1_0"))
					oQuick("quickcode") = ""
					If vQLinkGubun = "prd" Then
						oQuick("quicktitle") = CStr("상품정보")
					Else
						oQuick("quicktitle") = cStr(db2html(vArrQ(2,0)))
					End If
				Else
					'### category, street, search, event
					vQCode = CStr(Replace(Split(vArrQ(6,0),"=")(1)," ",""))
					If vQLinkGubun = "category" Then
						vQTitle = fnGetDispName(vQCode)
						oQuick("quickurl") = ""
						oQuick("quickcode") = CStr(vQCode)
						oQuick("quicktitle") = CStr(vQTitle)
					ElseIf vQLinkGubun = "brand" Then
						oQuick("quickurl") = ""
						oQuick("quickcode") = CStr(vQCode)
						oQuick("quicktitle") = CStr("브랜드")
					ElseIf vQLinkGubun = "search" Then
						oQuick("quickurl") = ""
						oQuick("quickcode") = CStr(vQCode)
						oQuick("quicktitle") = ""
					ElseIf vQLinkGubun = "event" Then
						oQuick("quickurl") = b64encode(mDomain & "/apps/appCom/wish/web2014/" & vArrQ(6,0) & CHKIIF(InStr(vArrQ(6,0),"?")>0,"&pNtr=qq_"&server.URLEncode(SearchText)&"&rc=qlnk_1_0","?pNtr=qq_"&server.URLEncode(SearchText)&"&rc=qlnk_1_0"))
						oQuick("quickcode") = ""
						oQuick("quicktitle") = CStr("기획전")
					End If
				End If
					
				oQuick("quickimg") = b64encode(vArrQ(20,0))
				oQuick("btnlinktype") = cStr(vQBLinkGubun)
				oQuick("btnname") = cStr(db2html(vArrQ(10,0)))
				If vQBLinkGubun = "etc" or vQBLinkGubun = "prd" Then
					oQuick("btnurl") = b64encode(mDomain & "/apps/appCom/wish/web2014/" & fnMoAppDifferentURL(vArrQ(12,0)) & CHKIIF(InStr(vArrQ(12,0),"?")>0,"&pNtr=qq_"&server.URLEncode(SearchText)&"&rc=qlnk_1_0","?pNtr=qq_"&server.URLEncode(SearchText)&"&rc=qlnk_1_0"))
					oQuick("btncode") = ""
					If vQBLinkGubun = "prd" Then
						oQuick("btntitle") = CStr("상품정보")
					Else
						oQuick("btntitle") = cStr(db2html(vArrQ(2,0)))
					End If
				Else
					'### category, street, search, event
					vQBCode = CStr(Replace(Split(vArrQ(12,0),"=")(1)," ",""))
					If vQBLinkGubun = "category" Then
						vQBTitle = fnGetDispName(vQBCode)
						oQuick("btnurl") = ""
						oQuick("btncode") = CStr(vQBCode)
						oQuick("btntitle") = CStr(vQBTitle)
					ElseIf vQBLinkGubun = "brand" Then
						oQuick("btnurl") = ""
						oQuick("btncode") = CStr(vQBCode)
						oQuick("btntitle") = CStr("브랜드")
					ElseIf vQBLinkGubun = "search" Then
						oQuick("btnurl") = ""
						oQuick("btncode") = CStr(vQBCode)
						oQuick("btntitle") = ""
					ElseIf vQBLinkGubun = "event" Then
						oQuick("btnurl") = b64encode(mDomain & "/apps/appCom/wish/web2014/" & vArrQ(12,0) & CHKIIF(InStr(vArrQ(12,0),"?")>0,"&pNtr=qq_"&server.URLEncode(SearchText)&"&rc=qlnk_1_0","?pNtr=qq_"&server.URLEncode(SearchText)&"&rc=qlnk_1_0"))
						oQuick("btncode") = ""
						oQuick("btntitle") = CStr("기획전")
					End If
				End If
				
				oQuick("btncolor") = cStr(vArrQ(13,0))
				oQuick("bggubun") = cStr(vArrQ(14,0))
				oQuick("bgcolor") = cStr(vArrQ(15,0))
				oQuick("bgimg") = b64encode(vArrQ(17,0))
				oQuick("brandid") = cStr(vArrQ(3,0))
				set oJson("quicklink") = oQuick
				Set oQuick = Nothing
			End If
		Else
			
		End If
	Else
		
	End If
	
	
	'// 첫페이지만.
	'### 큐레이션
	if (offset="" or offset="0") and (SearchText<>"") and (vListOption = "all") then
		Dim cCu, vCuLink, oCuration, oList, oCuItem, i
		Set cCu = New CDBSearch
		cCu.FRectKeyword = SearchText
		cCu.fnSearchCuratorList()
		
		If cCu.FResultCount > 0 Then
			Set oCuration = jsObject()
			oCuration("title") = cStr(cCu.FItemList(0).Ftitle)
			If cCu.FItemList(0).Fbgclass = "brown" Then
				oCuration("bgcolor") = cStr("9c7c6b")
			ElseIf cCu.FItemList(0).Fbgclass = "sky" Then
				oCuration("bgcolor") = cStr("84adc2")
			ElseIf cCu.FItemList(0).Fbgclass = "violet" Then
				oCuration("bgcolor") = cStr("7a88b8")
			End If
			
			set oList = jsArray()
			For i = 0 To cCu.FResultCount - 1
				Set oCuItem = jsObject()
					If cCu.FItemList(i).Fitemgubun = "item" Then
						oCuItem("itemgubun") = cStr("상품")
						oCuItem("itemcode") = b64encode(mDomain &"/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid="&cCu.FItemList(i).FItemID&"&pRtr="&server.URLEncode(SearchText)&"&rc=qrt_1_"&(i)&"")
					ElseIf cCu.FItemList(i).Fitemgubun = "event" Then
						If cCu.FItemList(i).Fevt_kind = "28" Then
							oCuItem("itemgubun") = cStr("이벤트")
						Else
							oCuItem("itemgubun") = cStr("기획전")
						End If
						oCuItem("itemcode") = b64encode(mDomain &"/apps/appCom/wish/web2014/event/eventmain.asp?eventid="&cCu.FItemList(i).FItemID&"&pNtr=qr_"&server.URLEncode(SearchText)&"&rc=qrt_1_"&(i)&"")
					End If

					oCuItem("itemname") = fnEventNameSplit(cStr(cCu.FItemList(i).FItemName),"name")
					
					If cCu.FItemList(i).FImageBasic <> "" Then
						oCuItem("itemimg") = b64encode(cCu.FItemList(i).FImageBasic)
					Else
						oCuItem("itemimg") = cStr("")
					End If
					
					If cCu.FItemList(i).Fitemgubun = "item" Then
						IF cCu.FItemList(i).IsSaleItem or cCu.FItemList(i).isCouponItem Then
							IF cCu.FItemList(i).IsSaleItem AND Not (cCu.FItemList(i).isCouponItem) Then
								oCuItem("itemprice") = cStr(cCu.FItemList(i).getRealPrice)
								oCuItem("itemsalevalue") = cStr(cCu.FItemList(i).getSalePro)
								oCuItem("itemcouponvalue") = cStr("")
								oCuItem("itemcurrency") = cStr("원")
							End IF
							IF cCu.FItemList(i).IsCouponItem AND Not (cCu.FItemList(i).IsSaleItem) AND cCu.FItemList(i).GetCouponDiscountStr <> "무료배송" Then
								oCuItem("itemprice") = cStr(cCu.FItemList(i).GetCouponAssignPrice)
								oCuItem("itemsalevalue") = cStr("")
								oCuItem("itemcouponvalue") = cStr(cCu.FItemList(i).GetCouponDiscountStr)
								oCuItem("itemcurrency") = cStr("원")
							End IF
							IF cCu.FItemList(i).IsCouponItem AND cCu.FItemList(i).IsSaleItem AND cCu.FItemList(i).GetCouponDiscountStr <> "무료배송" Then
								oCuItem("itemprice") = cStr(cCu.FItemList(i).GetCouponAssignPrice)
								oCuItem("itemsalevalue") = cStr(cCu.FItemList(i).getSalePro)
								If cCu.FItemList(i).Fitemcoupontype = "1" Then
									oCuItem("itemcouponvalue") = cStr(cCu.FItemList(i).GetCouponDiscountStr)
								Else
									oCuItem("itemcouponvalue") = cStr("쿠폰")
								End If
								oCuItem("itemcurrency") = cStr("원")
							End IF
						Else
							oCuItem("itemprice") = cStr(cCu.FItemList(i).getRealPrice)
							oCuItem("itemsalevalue") = cStr("")
							oCuItem("itemcouponvalue") = cStr("")
							oCuItem("itemcurrency") = CHKIIF(cCu.FItemList(i).IsMileShopitem,cStr(" Point"),cStr("원"))
						End if
					Else
						oCuItem("itemprice") = cStr("")
						oCuItem("itemsalevalue") = cStr("")
						oCuItem("itemcouponvalue") = cStr("")
						oCuItem("itemcurrency") = cStr("")
					End If
				set oList(null) = oCuItem
				Set oCuItem = Nothing
			Next
			
			set oCuration("items") = oList
			set oJson("curation") = oCuration
			Set oCuration = Nothing
		Else
			
		End If
		Set cCu = Nothing
	Else
		
	End If
	
	
	'### 
	
	
'####### 이번에는 안쓰는거 같음.
    ''연관검색어 protocol v2 추가 // 키워드검색/ 첫페이지만.
    dim oRckDoc
    If oDoc.FTotalCount = 0 Then
	    if (offset="" or offset="0") and (SearchText<>"") then
	        set oRckDoc = new SearchItemCls
	        	oRckDoc.FRectIs2017 = "o"
	        	oRckDoc.FRectSearchTxt = SearchText
	        	Set oJson("relatedkeywords") = oRckDoc.getRecommendKeyWordsJson()
	        Set oRckDoc = nothing
	    end if
    end if
'    
'    
'    ''연관브랜드 protocol v2 추가 // 키워드검색/ 첫페이지만.
'    dim oGrBrn
'    if (offset="" or offset="0") and (SearchText<>"") then
'        set oGrBrn = new SearchItemCls
'    	oGrBrn.FRectSearchTxt = DocSearchText
'    	oGrBrn.FRectSortMethod = SortMet
'    	oGrBrn.FRectSearchItemDiv = SearchItemDiv
'    	oGrBrn.StartNum = offset			'검색 시작 지점
'    	oGrBrn.FPageSize = 50                               ''갯수.
'    	oGrBrn.FListDiv = ListDiv
'    	oGrBrn.FLogsAccept = False
'    	Set oJson("relatedbrands") = oGrBrn.getGroupbyBrandListJson
'    	
'    	Set oGrBrn=Nothing
'    else
'        Set oJson("relatedbrands") = jsArray()
'    end if   
'	
'    ''연관 이벤트
'    dim oGrEvt
'    if (offset="" or offset="0") and (SearchText<>"")  then
'        set oGrEvt = new SearchItemCls
'    	oGrEvt.FRectSearchTxt = DocSearchText
'    	''oGrEvt.FRectExceptText = ExceptText
'    	oGrEvt.FRectChannel = "A"		'검색 채널 (W:isWeb, M:isMobile, A:isApp)
'    	oGrEvt.StartNum = offset
'    	oGrEvt.FPageSize = 20  ''
'    	oGrEvt.FLogsAccept = False
'    	Set oJson("relatedevents") = oGrEvt.getEventListJson
'	else
'        Set oJson("relatedevents") = jsArray()
'    end if 
	
	set oDoc = Nothing


	'### Filter 정보 그대로 줌.
	Dim oFilList
	Set oFilList = jsObject()
	oFilList("keyword") = cStr(DocSearchText)
	oFilList("sscp") = cStr(SellScope)
	oFilList("delitp") = cStr(deliType)
	oFilList("sflag") = cStr(SearchFlag)
	oFilList("pojangok") = cStr(pojangok)
	oFilList("mode") = cStr(mode)
	oFilList("displaytype") = cStr(SortMet)
	oFilList("categoryid") = cStr(dispCate)
	oFilList("brandid") = cStr(makerid)
	oFilList("pricelimitlow") = cStr(minPrice)
	oFilList("pricelimithigh") = cStr(maxPrice)
	oFilList("rstxt") = cStr(ReSearchText)
	oFilList("stylecd") = cStr(styleCD)
	oFilList("colorcd") = cStr(colorCD)
	oFilList("offset") = cStr(offset)
	oFilList("listoption") = cStr(vListOption)
	set oJson("filter") = oFilList
	Set oFilList = Nothing

    ''2017/03/28
    'if (GetLoginUserLevel="7") or (application("Svr_Info")="090") then
        Call addIIsLog(SearchText,ReSearchText,makerid,dispCate,CLNG(offset/sSize)+1,SortMet,p_numofproduct)
    'end if
end if

if ERR then Call OnErrNoti()
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing

'' IIS 로그 추가  2017/03/28
function addIIsLog(SearchText,rstxt,makerid,dispCate,ipage,isortMtd,rectcnt)
    dim svrInfo : svrInfo = application("Svr_Info")
    ''if NOT ((svrInfo="Dev") or (svrInfo="083") or (svrInfo="087")) then Exit function
    
    Dim iAddLogs 
    iAddLogs = ""
    if (SearchText<>"") then 
        iAddLogs = iAddLogs&"rect="&server.UrlEncode(SearchText)  ''검색어
    end if
    
    if (rstxt<>"") then 
        if (iAddLogs<>"") then iAddLogs = iAddLogs&"&"
        iAddLogs = iAddLogs&"rstxt="&server.UrlEncode(rstxt)    ''결과내 재검색
    end if
    
    if (makerid<>"") then 
        if (iAddLogs<>"") then iAddLogs = iAddLogs&"&"
        iAddLogs = iAddLogs&"makerid="&server.UrlEncode(makerid)    ''브랜드검색
    end if
    
    if (dispCate<>"") then 
        if (iAddLogs<>"") then iAddLogs = iAddLogs&"&"
        iAddLogs = iAddLogs&"disp="&server.UrlEncode(dispCate)    ''카테고리
    end if
    
    if (iAddLogs<>"") then
        if (ipage<>"") then
            if (iAddLogs<>"") then iAddLogs = iAddLogs&"&"
            iAddLogs = iAddLogs&"cpg="&ipage    ''페이징.
        end if
        
        if (isortMtd<>"") then
            if (iAddLogs<>"") then iAddLogs = iAddLogs&"&"
            iAddLogs = iAddLogs&"srm="&isortMtd    ''소팅
        end if
        
        ''2017/09/04 검색결과 count수 by eastone
        if (ipage="1") then
            if (iAddLogs<>"") then iAddLogs = iAddLogs&"&"
            iAddLogs = iAddLogs&"rectcnt="&rectcnt    ''검색결과수
        end if
        
        if (request.ServerVariables("QUERY_STRING")<>"") then  '' POST라 없음.
            iAddLogs="&"&iAddLogs
        end if
        Response.AppendToLog iAddLogs
    end if
end function

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