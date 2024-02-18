<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/lib/classes/award/newawardcls_B.asp" -->
<%
	Dim isShowSumamry : isShowSumamry = true  ''탭별 검색 갯수 표시 여부 : 느릴경우 FALSE 로
	dim SearchItemDiv : SearchItemDiv="y"	'기본 카테고리만
	dim SearchCateDep : SearchCateDep= "T"	'하위카테고리 모두 검색
	dim SearchText : SearchText = requestCheckVar(request("rect"),100) '현재 입력된 검색어
	dim SortMet		: SortMet = requestCheckVar(request("srm"),2)
	dim SearchFlag : SearchFlag = NullfillWith(requestCheckVar(request("sflag"),2),"n")
	dim pojangok : pojangok = requestCheckVar(request("pojangok"),1)
	
	dim ListDiv : ListDiv = "search" '카테고리/검색 구분용
	dim minPrice : minPrice = getNumeric(requestCheckVar(Replace(request("minPrc"),",",""),8))
	dim maxPrice : maxPrice = getNumeric(requestCheckVar(Replace(request("maxPrc"),",",""),8))
	dim deliType : deliType = requestCheckVar(request("deliType"),2)
	dim colorCD : colorCD = requestCheckVar(request("iccd"),128)
	dim CurrPage : CurrPage = getNumeric(requestCheckVar(request("cpg"),6))
	dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),5))
	dim LogsAccept : LogsAccept = true
	dim dispCate : dispCate = getNumeric(requestCheckVar(request("dispCate"),18))
	dim makerid : makerid = ReplaceRequestSpecialChar(request("mkr"))
	dim lp, i
	Dim mode : mode = requestCheckVar(request("mode"),1) ''리스트형 썸네일형
	Dim retUrl : retUrl = requestCheckVar(request("burl"),256)
	If retUrl = "" Then retUrl = wwwUrl End If

	dim SellScope 	: SellScope=requestCheckVar(request("sscp"),1)			'품절상품 제외여부
	if SellScope = "" then SellScope = "Y"
	dim arrCate : arrCate = ReplaceRequestSpecialChar(request("arrCate"))
	dim styleCD : styleCD = ReplaceRequestSpecialChar(request("styleCd"))
	dim attribCd : attribCd = ReplaceRequestSpecialChar(request("attribCd"))

	dim CheckResearch : CheckResearch= request("chkr")
	dim CheckExcept : CheckExcept= request("chke")
	dim ReSearchText : ReSearchText=requestCheckVar(request("rstxt"),100) '결과내 재검색용
	dim ExceptText : ExceptText=requestCheckVar(request("extxt"),100) '결과내 제외어
	dim DocSearchText

	Dim tmpPrevSearchKeyword , tmpCurrSearchKeyword
	Dim PrevSearchText : PrevSearchText = requestCheckVar(request("prvtxt"),100) '이전 검색어
	Dim isSaveSearchKeyword : isSaveSearchKeyword = true  ''검색어 DB에 저장 여부 X => procMySearchKeyword(쿠키)
	
	Dim vCateDepth, vWishArr, search_on, vListOption, vRealResearch

	search_on = requestCheckVar(request("search_on"),2)
	vListOption = NullFillwith(requestCheckVar(request("listoption"),10),"all")

	if dispCate<>"" then
		vCateDepth = cStr(len(dispCate)\3)+1			'하위 뎁스
	else
		vCateDepth = "1"
	end if
	if vCateDepth>3 then vCateDepth=3

	If mode = "" Then mode = "L"

	dim ScrollCount : ScrollCount = 4
	if CurrPage="" then CurrPage=1
	If mode = "L" then
		'### 1줄에 1개
		PageSize=15
	Else
		'### 1줄에 2개
		PageSize=30
	End If

	'if colorCD="" then colorCD="0"
	if SortMet="" then SortMet="be"		'베스트:be, 신상:ne


	if CheckResearch="undefined" then CheckResearch=""
	if len(CheckResearch)>5 then CheckResearch=""
	IF CheckResearch="" then CheckResearch=false
	if CheckExcept="undefined" then CheckExcept=""
	if len(CheckExcept)>5 then CheckExcept=""
	IF CheckExcept="" then CheckExcept=false

	''SearchText = RepWord(SearchText,"[^가-힣a-zA-Z0-9.&%\-\_\s]","")
	''ExceptText = RepWord(ExceptText,"[^가-힣a-zA-Z0-9.&%\-\_\s]","")

    SearchText = RepWord(SearchText,"[^ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9.&%\-\_\s]","")
    ExceptText = RepWord(ExceptText,"[^ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9.&%\-\_\s]","")
    
	IF CheckReSearch Then
		''ReSearchText = ReSearchText & " " & SearchText

		ReSearchText = RepWord(ReSearchText,SearchText,"")
		ReSearchText = RepWord(ReSearchText,"[\s]{2,}"," ")
		ReSearchText = RepWord(ReSearchText,"^[+\s]","")
		vRealResearch = ReSearchText
		ReSearchText = ReSearchText & " " & SearchText
		DocSearchText = ReSearchText
	Else
		'ReSearchText  =	SearchText
		DocSearchText = SearchText
	End if

	if CheckExcept then
		ReSearchText  =	ReSearchText
		DocSearchText = ReSearchText
		SearchText = ExceptText
	end if
	
	'### 실제 입력한 결과내검색어
	ReSearchText = vRealResearch

	'특정 단어 삭제
	DocSearchText = Trim(Replace(DocSearchText,"상품",""))

	IF Len(DocSearchText)<>0 and isNumeric(DocSearchText) THEN
		If Left(DocSearchText,1) <> "0" Then
			DocSearchText = Cdbl(DocSearchText)
		End If
	'	DocSearchText = Cdbl(DocSearchText)
	END IF

	'// 검색어 DB저장
	tmpPrevSearchKeyword = PrevSearchText
	tmpCurrSearchKeyword = SearchText

	dim oGrCat,rowCnt ''//카테고리
	Dim oGrEvt ''//이벤트

	'검색 로그 저장 여부
	IF CStr(SearchText)=CStr(PrevSearchText) Then
		LogsAccept = false
	End if

    '// 검색 조건 재설정 //2015/03/12 추가 (기존에 없었음)
    PrevSearchText = SearchText


	dim oDoc, iLp, objCmd, returnValue, vTotalCount, vItemTotalCount, vItemResultCount
	If vListOption = "all" or vListOption = "item" Then	'### 전체검색, 상품검색 만

			'// 상품검색
			set oDoc = new SearchItemCls
			oDoc.FRectSearchTxt = DocSearchText
			oDoc.FRectSortMethod	= SortMet
			oDoc.FRectSearchFlag = fnSalePojang(searchFlag,pojangok)
			oDoc.FRectSearchItemDiv = SearchItemDiv
			oDoc.FRectCateCode	= dispCate
			oDoc.FRectSearchCateDep = SearchCateDep
			oDoc.FRectMakerid	= fnCleanSearchValue(makerid)
			oDoc.FminPrice	= minPrice
			oDoc.FmaxPrice	= maxPrice
			oDoc.FdeliType	= deliType
			oDoc.FCurrPage = CurrPage
			oDoc.FPageSize = PageSize
			oDoc.FScrollCount = ScrollCount
			oDoc.FListDiv = ListDiv
			oDoc.FLogsAccept = LogsAccept
			oDoc.FRectColsSize = 6
			oDoc.FcolorCode = fnCleanSearchValue(colorCD)
			oDoc.FSellScope=SellScope
			oDoc.FstyleCd = fnCleanSearchValue(styleCd)
			oDoc.getSearchList
			
			vTotalCount = oDoc.FTotalCount
            vItemResultCount = oDoc.FResultCount
            vItemTotalCount = vTotalCount
			'// 숫자만 입력될경우 체크후 상품페이지로 넘기기
			IF oDoc.FTotalCount=1 and isNumeric(SearchText) Then
				on Error Resume Next

				'// 존재하는 상품인지 검사
				Set objCmd = Server.CreateObject("ADODB.Command")

				objCmd.ActiveConnection = dbget
				objCmd.CommandType = adCmdStoredProc
				objCmd.CommandText = "[db_item].[dbo].sp_Ten_PrdExists"

				objCmd.Parameters.Append objCmd.CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
				objCmd.Parameters.Append objCmd.CreateParameter("@@vItemID",adVarWChar,adParamInput,10,CLng(DocSearchText))

				objCmd.Execute

				returnValue = objCmd("RETURN_VALUE").value

				Set objCmd = Nothing
				IF returnValue=1 Then
					response.redirect "/category/category_itemprd.asp?itemid=" & CLng(DocSearchText)
					dbget.close()	:	response.End
				End IF

				on Error Goto 0

			End if

	ElseIf vListOption = "event" Then	'### 이벤트 만
			set oDoc = new SearchEventCls
			oDoc.FRectSearchTxt = DocSearchText
			oDoc.FRectChannel = "M"		'검색 채널 (W:isWeb, M:isMobile, A:isApp)
			oDoc.FCurrPage = CurrPage
			oDoc.FPageSize = 16
			oDoc.FScrollCount =10
			oDoc.getEventList
			
			vTotalCount = oDoc.FTotalCount
	ElseIf vListOption = "playing" Then	'### 플레잉 만
			set oDoc = new SearchPlayingCls
			oDoc.FRectSearchTxt = DocSearchText
			oDoc.FCurrPage = CurrPage
			oDoc.FPageSize = 16
			oDoc.FScrollCount =10
			oDoc.getPlayingList2017
			
			vTotalCount = oDoc.FTotalCount
	End If


	Dim moreYn

	if isSaveSearchKeyword and (tmpCurrSearchKeyword <> tmpPrevSearchKeyword) then
		'// 내검색어 쿠키 저장
		call procMySearchKeyword(tmpCurrSearchKeyword)
	End If

	'//logparam
	Dim logparam : logparam = "&pRtr="& server.URLEncode(SearchText)

	'Metatag 추가
	strPageKeyword = SearchText

	'// 구글 ADS 스크립트 관련(2017.05.29 원승현 추가)
	googleADSCRIPT = " <script type='text/javascript'> "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & " var google_tag_params = { "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "		ecomm_prodid: '', "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "		ecomm_pagetype: 'searchresults', "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "		ecomm_totalvalue: '' "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "	}; "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "	</script> "
	

	If vListOption = "all" Then	'### 상품,이벤트, 플레잉 중 전체 다 볼때 에만 나타남. 검색하면 사라짐.
			'####### PLAYing, 기획전/이벤트 만들어 넣을 곳
			Dim vEventBody, vPlayingBody, vExhibiBody, vEnm, oDocPl, isFewItem
			
			isFewItem = CurrPage=1 and cInt(vItemResultCount) < cInt(PageSize)
			if isFewItem Then
				Response.Write "<script>window.onload = function(){isloading=true;}</script>"
			end If
			
			'// 이벤트 검색결과
			set oGrEvt = new SearchEventCls
			oGrEvt.FRectSearchTxt = DocSearchText
			oGrEvt.FRectChannel = "M"		'검색 채널 (W:isWeb, M:isMobile, A:isApp)
			oGrEvt.FCurrPage = CurrPage
			oGrEvt.FPageSize = chkIIF(isFewItem,30,1)
			oGrEvt.FScrollCount =10
			oGrEvt.FRectGubun = "mktevt"
			oGrEvt.getEventList
			
			If oGrEvt.FResultCount > 0 Then
				vEventBody = ""
				For iRows=0 to oGrEvt.FResultCount-1
					vEnm = db2html(oGrEvt.FItemList(iRows).Fevt_name)
					vEventBody = vEventBody& "<li class=""exhibition " & CHKIIF(oGrEvt.FItemList(iRows).Fetc_itemimg<>"","","nothumbnail") & " type-color-blue"">"
					IF oGrEvt.FItemList(iRows).Fevt_LinkType="I" and oGrEvt.FItemList(iRows).Fevt_bannerLink<>"" THEN		'#별도 링크타입
						vEventBody = vEventBody & "<a href = """" onClick=""top.location.href='" & oGrEvt.FItemList(iRows).Fevt_bannerLink & "'; return false;"">"
					Else
						vEventBody = vEventBody & "<a href = """" onClick=""top.location.href='/event/eventmain.asp?eventid=" & oGrEvt.FItemList(iRows).Fevt_code & "&pNtr=re_"&server.UrlEncode(DocSearchText)&"'; return false;"">"
					End If
					If oGrEvt.FItemList(iRows).Fetc_itemimg = "" Then
					    If oGrEvt.FItemList(iRows).Fetc_itemid <> "" AND oGrEvt.FItemList(iRows).Fetc_itemid <> "0" Then
							vEventBody = vEventBody & "<div class=""thumbnail""><img src=""http://webimage.10x10.co.kr/image/icon1/" & GetImageSubFolderByItemid(oGrEvt.FItemList(iRows).Fetc_itemid) & "/" & oGrEvt.FItemList(iRows).Ficon1image & """ alt="""" /></div>"
						Else
							vEventBody = vEventBody & ""
						End If
					Else
						vEventBody = vEventBody & "<div class=""thumbnail""><img src=""" & oGrEvt.FItemList(iRows).Fetc_itemimg & """ alt="""" /></div>"
					End If
					vEventBody = vEventBody & "<div class=""desc""><span class=""label"">이벤트</span>"
					vEventBody = vEventBody & "<p class=""name"">" & fnEventNameSplit(vEnm,"name") & "</p>"
					vEventBody = vEventBody & "<p class=""subcopy"">" & db2html(oGrEvt.FItemList(iRows).Fevt_subcopyK) & "</p>"
					vEventBody = vEventBody & "<div class=""price"">"
					if ubound(Split(vEnm,"|"))> 0 Then
						If oGrEvt.FItemList(iRows).Fissale Or (oGrEvt.FItemList(iRows).Fissale And oGrEvt.FItemList(iRows).Fiscoupon) then
							vEventBody = vEventBody & "<b class=""discount color-red"">"&cStr(Split(vEnm,"|")(1))&"</b>"
						ElseIf oGrEvt.FItemList(iRows).Fiscoupon Then
							vEventBody = vEventBody & "<b class=""discount color-green"">"&cStr(Split(vEnm,"|")(1))&"<small>쿠폰</small></b>"
						End If
					end If
					vEventBody = vEventBody & "</div></div></a></li>"
				Next

				vTotalCount = vTotalCount + oGrEvt.FTotalCount			'// 전체일때 결과수 추가
			End If

			oGrEvt.FRectGubun = "planevt"
			oGrEvt.getEventList
			
			If oGrEvt.FResultCount > 0 Then
				vExhibiBody = ""
				For iRows=0 to oGrEvt.FResultCount-1
					vEnm = db2html(oGrEvt.FItemList(iRows).Fevt_name)
					vExhibiBody = vExhibiBody & "<li class=""exhibition " & CHKIIF(oGrEvt.FItemList(iRows).Fetc_itemimg<>"","","nothumbnail") & " type-color-pink"">"
					IF oGrEvt.FItemList(iRows).Fevt_LinkType="I" and oGrEvt.FItemList(iRows).Fevt_bannerLink<>"" THEN		'#별도 링크타입
						vExhibiBody = vExhibiBody & "<a href = """" onClick=""top.location.href='" & oGrEvt.FItemList(iRows).Fevt_bannerLink & "'; return false;"">"
					Else
						vExhibiBody = vExhibiBody & "<a href = """" onClick=""top.location.href='/event/eventmain.asp?eventid=" & oGrEvt.FItemList(iRows).Fevt_code & "&pNtr=re_"&server.UrlEncode(DocSearchText)&"'; return false;"">"
					End If
					If oGrEvt.FItemList(iRows).Fetc_itemimg = "" Then
						vExhibiBody = vExhibiBody & "<div class=""thumbnail""><img src=""http://webimage.10x10.co.kr/image/icon1/" & GetImageSubFolderByItemid(oGrEvt.FItemList(iRows).Fetc_itemid) & "/" & oGrEvt.FItemList(iRows).Ficon1image & """ alt="""" /></div>"
					Else
						vExhibiBody = vExhibiBody & "<div class=""thumbnail""><img src=""" & oGrEvt.FItemList(iRows).Fetc_itemimg & """ alt="""" /></div>"
					End If
					vExhibiBody = vExhibiBody & "<div class=""desc""><span class=""label"">기획전</span>"
					vExhibiBody = vExhibiBody & "<p class=""name"">" & fnEventNameSplit(vEnm,"name") & "</p>"
					vExhibiBody = vExhibiBody & "<p class=""subcopy"">" & db2html(oGrEvt.FItemList(iRows).Fevt_subcopyK) & "</p>"
					vExhibiBody = vExhibiBody & "<div class=""price"">"
					if ubound(Split(vEnm,"|"))> 0 Then
						If oGrEvt.FItemList(iRows).Fissale Or (oGrEvt.FItemList(iRows).Fissale And oGrEvt.FItemList(iRows).Fiscoupon) then
							vExhibiBody = vExhibiBody & "<b class=""discount color-red"">"&cStr(Split(vEnm,"|")(1))&"</b>"
						ElseIf oGrEvt.FItemList(iRows).Fiscoupon Then
							vExhibiBody = vExhibiBody & "<b class=""discount color-green"">"&cStr(Split(vEnm,"|")(1))&"<small>쿠폰</small></b>"
						End If
					end If
					vExhibiBody = vExhibiBody & "</div></div></a></li>"
				Next

				vTotalCount = vTotalCount + oGrEvt.FTotalCount			'// 전체일때 결과수 추가
			End If
			
			set oGrEvt = nothing
			
			'// 플레잉 검색결과
			set oDocPl = new SearchPlayingCls
			oDocPl.FRectSearchTxt = DocSearchText
			oDocPl.FCurrPage = CurrPage
			oDocPl.FPageSize = chkIIF(isFewItem,30,1)
			oDocPl.FScrollCount =10
			oDocPl.getPlayingList2017
			
			If oDocPl.FResultCount > 0 Then
				vPlayingBody = ""
				For iRows=0 to oDocPl.FResultCount-1
					vPlayingBody = vPlayingBody & "<li class=""playing"">"
					If oDocPl.FItemList(iRows).Fimg28 <> "" Then
						vPlayingBody = vPlayingBody & "<a href=""/playing/view.asp?didx="&oDocPl.FItemList(iRows).Fdidx&"&pNtr=rp_"&server.UrlEncode(DocSearchText)&""" style=""background-image:url(" & oDocPl.FItemList(iRows).Fimg28 & ");"">"
					Else
						If oDocPl.FItemList(iRows).Fmo_bgcolor <> "" Then
							vPlayingBody = vPlayingBody & "<a href=""/playing/view.asp?didx="&oDocPl.FItemList(iRows).Fdidx&"&pNtr=rp_"&server.UrlEncode(DocSearchText)&""" style=""background-color:#" & oDocPl.FItemList(iRows).Fmo_bgcolor & ";"">"
						Else
							vPlayingBody = vPlayingBody & "<a href=""/playing/view.asp?didx="&oDocPl.FItemList(iRows).Fdidx&"&pNtr=rp_"&server.UrlEncode(DocSearchText)&""" style=""background-color:#ffdddb;"">"
						End If
					End IF
					vPlayingBody = vPlayingBody & "<div class=""desc""><span class=""label"">플레잉</span><p class=""name"">" & db2html(oDocPl.FItemList(iRows).Ftitle) & "</p></div></a></li>"
				Next

				vTotalCount = vTotalCount + oDocPl.FTotalCount			'// 전체일때 결과수 추가
			End If
			set oDocPl = nothing
	End If


	'####### 연관검색어 #######
	dim oRckDoc, arrList, tempcount, iRows
	set oRckDoc = new SearchItemCls
		oRckDoc.FRectSearchTxt = DocSearchText
		arrList = oRckDoc.getRecommendKeyWords()
	Set oRckDoc = nothing
	'####### 연관검색어 #######
	
	'// 검색결과 내위시 표시정보 접수
	If vListOption = "all" or vListOption = "item" Then
		if IsUserLoginOK then
			'// 검색결과 상품목록 작성
			dim rstArrItemid: rstArrItemid=""
			IF oDoc.FResultCount >0 then
				For iLp=0 To oDoc.FResultCount -1
					rstArrItemid = rstArrItemid & chkIIF(rstArrItemid="","",",") & oDoc.FItemList(iLp).FItemID
				Next
			End if
			'// 위시결과 상품목록 작성
			if rstArrItemid<>"" then
				Call getMyFavItemList(getLoginUserid(),rstArrItemid,vWishArr)
			end if
		end if
	end if
	
	'####### 내 상품비교 데이터 #######
	Dim vMyCArr, vMyCItem, vMyCBody, c
	If IsUserLoginOK() Then
		vMyCArr = fnGetCompareItem("list",getLoginUserid())
		vMyCItem = ""
		
		If isArray(vMyCArr) Then
			vMyCBody = ""
			For c=0 To UBound(vMyCArr,2)
				If c > 0 Then
					vMyCItem = vMyCItem & ","
				End If
				vMyCItem = vMyCItem & "item" & vMyCArr(0,c)
				
				vMyCBody = vMyCBody & "<li id=""compareitem"&vMyCArr(0,c)&"""><div class=""thumbnail"">"
				vMyCBody = vMyCBody & "<img src=""http://webimage.10x10.co.kr/image/basic/" & GetImageSubFolderByItemid(vMyCArr(0,c)) & "/" & vMyCArr(1,c) &""" alt="""" /></div>"
				vMyCBody = vMyCBody & "<button type=""button"" class=""btn-del"" onclick=""jsCompareItem('set','"&vMyCArr(0,c)&"');"">삭제</button></li>"
			Next
		End If
	End If
%>
<script type="text/javascript">
<!-- #include file="./search_item_script.asp" -->
</script>
<script type="text/javascript" src="/lib/js/SearchAutoComplete2017.js?v=1.1"></script>
</head>
<body class="default-font">
	<!-- #include file="./inc_searchform.asp" -->
	<div class="search-content">
		<% If vTotalCount < 1 Then %>
		<!-- #include file="./inc_search_item_replacement.asp" -->
		<%
			End If
If vTotalCount > 0 AND search_on = "" Then
		IF isArray(arrList) THEN
			if Ubound(arrList)>0 then
		%>
		<div id="relatedKeyword" class="related-keyword">
			<h2 class="hidden">연관검색어</h2>
			<div class="swiper-container">
				<ul class="swiper-wrapper">
				<%
					If Ubound(arrList) > 5 Then
						tempcount  = Ubound(arrList) - 2
					Else
						tempcount  = Ubound(arrList)
					End if
					For iRows=0 To tempcount
						Response.Write "<li class=""swiper-slide""><a href=""/search/search_item.asp?rect=" & Server.URLEncode(arrList(iRows)) & "&exkw=1&burl=" & Server.URLEncode(retUrl) & """>" & arrList(iRows) & "</a></li>"
					Next
				%>
				</ul>
			</div>
		</div>
		<%
			end if
		end if
		%>

		<!-- #INCLUDE file="./inc_search_item_quickcu.asp" -->
<% End If %>
		<!-- 선택/입력된필터목록 -->
		<div id="filterList" class="filter-list">
			<div class="swiper-container">
				<ul class="swiper-wrapper list-roundbox" id="selectedfilter">
				</ul>
			</div>
		</div>
		<div class="sortingbar">
			<div class="option-left"><p class="total"><b><%=FormatNumber(vTotalCount,0)%></b>건의 검색결과</p></div>
			<div class="option-right">
				<div class="styled-selectbox styled-selectbox-default">
					<select class="select" id="listoption" name="listoption" onChange="jsGoListOption(this.value);" title="검색결과 리스트 선택옵션">
						<option value="all" <%=CHKIIF(vListOption="all","selected","")%>>전체</option>
						<option value="item" <%=CHKIIF(vListOption="item","selected","")%>>상품</option>
						<option value="event" <%=CHKIIF(vListOption="event","selected","")%>>기획전/이벤트</option>
						<option value="playing" <%=CHKIIF(vListOption="playing","selected","")%>>플레잉</option>
					</select>
				</div>
				<% If vListOption = "all" or vListOption = "item" Then	'### 전체검색, 상품검색 만 %>
				<div class="styled-selectbox styled-selectbox-default">
					<select class="select" id="srm" name="srm" onChange="jsGoSort(this.value);" title="검색결과 리스트 정렬 선택옵션">
						<option value="ne" <%=CHKIIF(SortMet="ne","selected","")%>>신규순</option>
						<option value="be" <%=CHKIIF(SortMet="be","selected","")%>>인기순</option>
						<option value="ws" <%=CHKIIF(SortMet="ws","selected","")%>>위시등록순</option>
						<option value="hs" <%=CHKIIF(SortMet="hs","selected","")%>>할인율순</option>
						<option value="hp" <%=CHKIIF(SortMet="hp","selected","")%>>높은가격순</option>
						<option value="lp" <%=CHKIIF(SortMet="lp","selected","")%>>낮은가격순</option>
					</select>
				</div>
				<% End If %>
			</div>
		</div>

		<% If vListOption = "all" or vListOption = "item" Then	'### 전체검색, 상품검색 만 %>
		<!-- 비교/필터 버튼 -->
		<div class="fixed-bottom btn-floating btn-roundshadow-twin">
			<a href="#lyCompare" class="btn-half btn-compare" onclick="showLayer('lyCompare'); return false;">비교</a>
			<a href="#searchFilter" id="filterbtn" class="btn-half btn-filter layer <%=CHKIIF(search_on="on","on","")%>" onclick="showLayer('searchFilter'); return false;">필터</a>
		</div>
		<% End If %>
<% If vTotalCount > 0 Then %>
		<div class="items type-<%=CHKIIF(mode="L","list","grid")%>">
			<ul id="lyrSrcpdtList">
			<%
				Dim rcParam
				For i=0 To oDoc.FResultCount-1
				'클릭 위치 Parameter 추가
				rcParam = "&rc=rpos_" & CurrPage &"_" & (i+1)
				
				If vListOption = "all" or vListOption = "item" Then
			%>
				<% If oDoc.FItemList(i).FItemDiv="21" Then %>
					<li class="deal-item">
						<a href="/category/category_itemPrd.asp?itemid=<%= oDoc.FItemList(i).FItemID %>&disp=<%= oDoc.FItemList(i).FCateCode %><%=logparam&rcParam%>">
							<span class="deal-badge">텐텐<i>DEAL</i></span>
							<div class="thumbnail"><img src="<%= getThumbImgFromURL(oDoc.FItemList(i).FImageBasic,300,300,"true","false") %>" alt="" /><% If oDoc.FItemList(i).isSoldOut Then Response.Write "<b class=""soldout"">일시 품절</b>" End If %></div>
							<div class="desc">
								<span class="brand"><% = oDoc.FItemList(i).FBrandName %></span>
								<p class="name"><% = oDoc.FItemList(i).FItemName %></p>
								<div class="price">
								<%
									If oDoc.FItemList(i).FOptionCnt="" Or oDoc.FItemList(i).FOptionCnt="0" Then	'### 쿠폰 X 세일 O
										Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oDoc.FItemList(i).getOrgPrice,0) & "<span class=""won"">" & CHKIIF(oDoc.FItemList(i).IsMileShopitem," Point","원") & "</span></b></div>" &  vbCrLf
									Else
										Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oDoc.FItemList(i).getOrgPrice,0) & "<span class=""won"">원</span></b>"
										Response.Write "&nbsp;<b class=""discount color-red"">" & oDoc.FItemList(i).FOptionCnt & "%</b>"
										Response.Write "</div>" &  vbCrLf
									End If
								%>
								</div>
							</div>
						</a>
						<div class="etc">
							<% IF oDoc.FItemList(i).IsCouponItem AND oDoc.FItemList(i).GetCouponDiscountStr = "무료배송" Then %>
							<div class="tag shipping"><span class="icon icon-shipping"><i>무료배송</i></span> FREE</div>
							<% End If %>
						</div>
					</li>
				<% Else %>
					<li>
						<a href="/category/category_itemPrd.asp?itemid=<%= oDoc.FItemList(i).FItemID %>&disp=<%= oDoc.FItemList(i).FCateCode %><%=logparam&rcParam%>">
							<div class="thumbnail"><img src="<%= getThumbImgFromURL(oDoc.FItemList(i).FImageBasic,300,300,"true","false") %>" alt="" /><% If oDoc.FItemList(i).isSoldOut Then Response.Write "<b class=""soldout"">일시 품절</b>" End If %></div>
							<div class="desc">
								<span class="brand"><% = oDoc.FItemList(i).FBrandName %></span>
								<p class="name"><% = oDoc.FItemList(i).FItemName %></p>
								<div class="price">
								<%
									If oDoc.FItemList(i).IsSaleItem AND oDoc.FItemList(i).isCouponItem Then	'### 쿠폰 O 세일 O
										Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oDoc.FItemList(i).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
										Response.Write "&nbsp;<b class=""discount color-red"">" & oDoc.FItemList(i).getSalePro & "</b>"
										If oDoc.FItemList(i).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
											If InStr(oDoc.FItemList(i).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
												Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
											Else
												Response.Write "&nbsp;<b class=""discount color-green"">" & oDoc.FItemList(i).GetCouponDiscountStr & "<small>쿠폰</small></b>"
											End If
										End If
										Response.Write "</div>" &  vbCrLf
									ElseIf oDoc.FItemList(i).IsSaleItem AND (Not oDoc.FItemList(i).isCouponItem) Then	'### 쿠폰 X 세일 O
										Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oDoc.FItemList(i).getRealPrice,0) & "<span class=""won"">원</span></b>"
										Response.Write "&nbsp;<b class=""discount color-red"">" & oDoc.FItemList(i).getSalePro & "</b>"
										Response.Write "</div>" &  vbCrLf
									ElseIf oDoc.FItemList(i).isCouponItem AND (NOT oDoc.FItemList(i).IsSaleItem) Then	'### 쿠폰 O 세일 X
										Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oDoc.FItemList(i).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
										If oDoc.FItemList(i).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
											If InStr(oDoc.FItemList(i).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
												Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
											Else
												Response.Write "&nbsp;<b class=""discount color-green"">" & oDoc.FItemList(i).GetCouponDiscountStr & "<small>쿠폰</small></b>"
											End If
										End If
										Response.Write "</div>" &  vbCrLf
									Else
										Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oDoc.FItemList(i).getRealPrice,0) & "<span class=""won"">" & CHKIIF(oDoc.FItemList(i).IsMileShopitem,"Point","원") & "</span></b></div>" &  vbCrLf
									End If
								%>
								</div>
							</div>
						</a>
						<div class="etc">
							<% If oDoc.FItemList(i).FEvalCnt > 0 Then %>
							<div class="tag review"><span class="icon icon-rating"><i style="width:<%=fnEvalTotalPointAVG(oDoc.FItemList(i).FPoints,"search")%>%;"><%=fnEvalTotalPointAVG(oDoc.FItemList(i).FPoints,"search")%>점</i></span><span class="counting"><%=CHKIIF(oDoc.FItemList(i).FEvalCnt>999,"999+",oDoc.FItemList(i).FEvalCnt)%></span></div>
							<% End If %>
							<button class="tag wish btn-wish" onclick="goWishPop('<%=oDoc.FItemList(i).FItemid%>');">
								<%
								If oDoc.FItemList(i).FfavCount > 0 Then
									If fnIsMyFavItem(vWishArr,oDoc.FItemList(i).FItemID) Then
										Response.Write "<span class=""icon icon-wish on"" id=""wish"&oDoc.FItemList(i).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&oDoc.FItemList(i).FItemID&""">"
										Response.Write CHKIIF(oDoc.FItemList(i).FfavCount>999,"999+",formatNumber(oDoc.FItemList(i).FfavCount,0)) & "</span>"
									Else
										Response.Write "<span class=""icon icon-wish"" id=""wish"&oDoc.FItemList(i).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&oDoc.FItemList(i).FItemID&""">"
										Response.Write CHKIIF(oDoc.FItemList(i).FfavCount>999,"999+",formatNumber(oDoc.FItemList(i).FfavCount,0)) & "</span>"
									End If
								Else
									Response.Write "<span class=""icon icon-wish"" id=""wish"&oDoc.FItemList(i).FItemID&"""><i> wish</i></span><span class=""counting"" id=""cnt"&oDoc.FItemList(i).FItemID&"""></span>"
								End If
								%>
							</button>
							<% IF oDoc.FItemList(i).IsCouponItem AND oDoc.FItemList(i).GetCouponDiscountStr = "무료배송" Then %>
							<div class="tag shipping"><span class="icon icon-shipping"><i>무료배송</i></span> FREE</div>
							<% End If %>
						</div>
						<a href="#quickview" class="btn-view" onclick="jsQuickViewItem('<%= oDoc.FItemList(i).FItemID %>'); return false;">상품 퀵뷰</a>
						<button type="button" class="btn-compare-add <%=CHKIIF(InStr(vMyCItem,"item"&oDoc.FItemList(i).FItemID)>0,"on","")%>" id="comparebtn<%=oDoc.FItemList(i).FItemID%>" onClick="jsCompareItem('set','<%=oDoc.FItemList(i).FItemID%>');">비교할 상품에 추가하기</button>
					</li>
				<% End If %>
			<%
					If mode = "L" Then
						If i = 4 Then
							Response.Write CHKIIF((CurrPage mod 2)=0,Replace(vEventBody,"type-color-blue","type-color-green"),vEventBody)
							vEventBody = ""
						ElseIf i = 9 Then
							Response.Write vPlayingBody
							vPlayingBody = ""
						ElseIf i = 14 Then
							Response.Write CHKIIF((CurrPage mod 2)=0,Replace(vExhibiBody,"type-color-pink","type-color-yellow"),vExhibiBody)
							vExhibiBody = ""
						End If
					Else
						If i = 9 Then
							Response.Write CHKIIF((CurrPage mod 2)=0,Replace(vEventBody,"type-color-blue","type-color-green"),vEventBody)
							vEventBody = ""
						ElseIf i = 19 Then
							Response.Write vPlayingBody
							vPlayingBody = ""
						ElseIf i = 29 Then
							Response.Write CHKIIF((CurrPage mod 2)=0,Replace(vExhibiBody,"type-color-pink","type-color-yellow"),vExhibiBody)
							vExhibiBody = ""
						End If
					End IF
						
				ElseIf vListOption = "event" Then
					vEnm = db2html(oDoc.FItemList(i).Fevt_name)
					vEventBody = "<li class=""exhibition " & CHKIIF(oDoc.FItemList(i).Fetc_itemimg<>"","","nothumbnail") & " type-color-"&fnGetSearchEventClass(i)&""">"
					IF oDoc.FItemList(i).Fevt_LinkType="I" and oDoc.FItemList(i).Fevt_bannerLink<>"" THEN		'#별도 링크타입
						vEventBody = vEventBody & "<a href = """" onClick=""top.location.href='" & oDoc.FItemList(i).Fevt_bannerLink & "'; return false;"">"
					Else
						vEventBody = vEventBody & "<a href = """" onClick=""top.location.href='/event/eventmain.asp?eventid=" & oDoc.FItemList(i).Fevt_code &logparam&rcParam&"'; return false;"">"
					End If
					If oDoc.FItemList(i).Fetc_itemimg = "" Then
						vEventBody = vEventBody & "<div class=""thumbnail""><img src=""http://webimage.10x10.co.kr/image/icon1/" & GetImageSubFolderByItemid(oDoc.FItemList(i).Fetc_itemid) & "/" & oDoc.FItemList(i).Ficon1image & """ alt="""" /></div>"
					Else
						vEventBody = vEventBody & "<div class=""thumbnail""><img src=""" & oDoc.FItemList(i).Fetc_itemimg & """ alt="""" /></div>"
					End If
					vEventBody = vEventBody & "<div class=""desc""><span class=""label"">"
					If oDoc.FItemList(i).Fevt_kind = "28" Then
						vEventBody = vEventBody & "이벤트"
					Else
						vEventBody = vEventBody & "기획전"
					End If
					vEventBody = vEventBody & "</span>"
					vEventBody = vEventBody & "<p class=""name"">" & fnEventNameSplit(vEnm,"name") & "</p>"
					vEventBody = vEventBody & "<p class=""subcopy"">" & db2html(oDoc.FItemList(i).Fevt_subcopyK) & "</p>"
					vEventBody = vEventBody & "<div class=""price"">"
					if ubound(Split(vEnm,"|"))> 0 Then
						If oDoc.FItemList(i).Fissale Or (oDoc.FItemList(i).Fissale And oDoc.FItemList(i).Fiscoupon) then
							vEventBody = vEventBody & "<b class=""discount color-red"">"&cStr(Split(vEnm,"|")(1))&"</b>"
						ElseIf oDoc.FItemList(i).Fiscoupon Then
							vEventBody = vEventBody & "<b class=""discount color-green"">"&cStr(Split(vEnm,"|")(1))&"<small>쿠폰</small></b>"
						End If
					end If
					vEventBody = vEventBody & "</div></div></a></li>"
					
					Response.Write vEventBody
				ElseIf vListOption = "playing" Then
					vPlayingBody = "<li class=""playing"">"
					If oDoc.FItemList(i).Fimg28 <> "" Then
						vPlayingBody = vPlayingBody & "<a href=""/playing/view.asp?didx="&oDoc.FItemList(i).Fdidx&logparam&rcParam&""" style=""background-image:url(" & oDoc.FItemList(i).Fimg28 & ");"">"
					Else
						If oDoc.FItemList(i).Fmo_bgcolor <> "" Then
							vPlayingBody = vPlayingBody & "<a href=""/playing/view.asp?didx="&oDoc.FItemList(i).Fdidx&logparam&rcParam&""" style=""background-color:#" & oDoc.FItemList(i).Fmo_bgcolor & ";"">"
						Else
							vPlayingBody = vPlayingBody & "<a href=""/playing/view.asp?didx="&oDoc.FItemList(i).Fdidx&logparam&rcParam&""" style=""background-color:#ffdddb;"">"
						End If
					End IF
					vPlayingBody = vPlayingBody & "<div class=""desc""><span class=""label"">플레잉</span><p class=""name"">" & db2html(oDoc.FItemList(i).Ftitle) & "</p></div></a></li>"
					
					Response.Write vPlayingBody
				End If
					
				Next
				
				If vListOption = "all" Then
				Response.Write vEventBody
				Response.Write vPlayingBody
				Response.Write vExhibiBody
				End If
			%>
			</ul>
		</div>
<% Else %>
		<div class="nodata nodata-search">
			<p><b>아쉽게도 일치하는 내용이 없습니다</b></p>
			<p>품절 또는 종료된 경우에는 검색되지 않습니다</p>
		</div>
		
		<section class="searching-keyword">
			<h2>혹시 이런건 어떠세요?</h2>
			<div class="list-roundbox">
<%
		'// 인기검색어
		DIM oPpkDoc, arrPpk, arrTg
		SET oPpkDoc = New SearchItemCls
			oPpkDoc.FPageSize = 8
			'arrPpk = oPpkDoc.getPopularKeyWords()			'일반형태
			oPpkDoc.getPopularKeyWords2 arrPpk,arrTg		'순위정보 포함
		SET oPpkDoc = NOTHING
		
		If isArray(arrPpk)  THEN
			If Ubound(arrPpk)>0 then
				For mykeywordloop=0 To UBOUND(arrPpk)
					if trim(arrPpk(mykeywordloop))<>"" then
						Response.Write "<a href=""/search/search_item.asp?rect=" & Server.URLEncode(arrPpk(mykeywordloop)) & "&burl=" & Server.URLEncode(retUrl) & """>"
						Response.Write arrPpk(mykeywordloop) & "</a>" & vbCrLf
					end if
				Next
			End If
		End If
%>
			</div>
		</section>
		<!-- #include virtual="/search/inc_bestItemList2017.asp" -->
<% End If %>
	<%
    ''2017/09/18 검색결과 count수 by eastone
    if CStr(vItemTotalCount)<>"" then 
    call fn_AddIISAppendToLOG("rectcnt="&vItemTotalCount&CHKIIF(request.ServerVariables("QUERY_STRING")="","&","")) '' footer에 addlog가 또 잇으므로.
    end if
    %>
	</div>
	<!-- //contents -->

	<div id="quickview" class="quickview">
	</div>
	
	<div id="modalLayer" style="display:none;"></div>

	<!-- #include file="./inc_search_item_compare.asp" -->
	<!-- #include file="./inc_search_item_filter.asp" -->
	
	<form name="sFrm" id="listSFrm" method="get" action="/search/search_item.asp" style="margin:0px;">
	<input type="hidden" name="search_on" value="on">
	<input type="hidden" name="rect" value="<%= SearchText %>">
	<input type="hidden" name="prvtxt" value="<%= PrevSearchText %>">
	<input type="hidden" id="rstxt" name="rstxt" value="<%= ReSearchText %>">
	<input type="hidden" name="extxt" value="<%= ExceptText %>">
	<input type="hidden" id="sflag" name="sflag" value="<%= SearchFlag  %>">
	<input type="hidden" id="dispCate" name="dispCate" value="<%= dispCate %>">
	<input type="hidden" id="cpg" name="cpg" value="<%=CurrPage%>">
	<input type="hidden" id="chkr" name="chkr" value="<%= CheckResearch %>">
	<input type="hidden" name="chke" value="<%= CheckExcept %>">
	<input type="hidden" id="mkr" name="mkr" value="<%= makerid %>">
	<input type="hidden" id="sscp" name="sscp" value="<%= SellScope %>">
	<input type="hidden" name="psz" value="<%= PageSize %>">
	<input type="hidden" name="srm" value="<%= SortMet %>">
	<input type="hidden" id="iccd" name="iccd" value="<%=colorCD%>">
	<input type="hidden" id="styleCd" name="styleCd" value="<%=styleCd%>">
	<input type="hidden" name="attribCd" value="<%=attribCd%>">
	<input type="hidden" name="mode" id="mode" value="<%=mode%>">
	<input type="hidden" name="arrCate" value="<%=arrCate%>">
	<input type="hidden" id="deliType" name="deliType" value="<%=deliType%>">
	<input type="hidden" id="minPrc" name="minPrc" value="<%=minPrice%>">
	<input type="hidden" id="maxPrc" name="maxPrc" value="<%=maxPrice%>">
	<input type="hidden" name="lstDiv" value="<%=ListDiv%>">
	<input type="hidden" name="burl" value="<%=retUrl%>">
	<input type="hidden" name="itemid" value="">
	<input type="hidden" name="ErBValue" value="99">
	<input type="hidden" name="listoption" value="<%=vListOption%>">
	<input type="hidden" id="pojangok" name="pojangok" value="<%= pojangok %>">
	</form>

	<div id="gotop" class="btn-top"><button type="button">맨위로</button></div>
	<div id="mask" style="overflow:hidden; display:none; position:fixed; top:0; left:0; z-index:10; width:100%; height:100%; background:rgba(0, 0, 0, 0.5);"></div>
	<div id="lyLoading" style="display:none;position:relative;text-align:center; padding:20px 0;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
	<!-- #include virtual="/lib/inc/incLogScript.asp" -->
</body>
</html>
<%
	set oDoc = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->