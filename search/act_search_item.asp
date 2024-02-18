<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<%
	Dim isShowSumamry : isShowSumamry = true  ''탭별 검색 갯수 표시 여부 : 느릴경우 FALSE 로
	dim SearchItemDiv : SearchItemDiv="y"	'기본 카테고리만
	dim SearchCateDep : SearchCateDep= "T"	'하위카테고리 모두 검색
	dim SearchText : SearchText = requestCheckVar(request("rect"),100) '현재 입력된 검색어
	dim SortMet		: SortMet = requestCheckVar(request("srm"),2)
	dim SearchFlag : SearchFlag = NullFillWith(requestCheckVar(request("sflag"),2),"n")
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
	dim classStr, adultChkFlag, adultPopupLink, linkUrl

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
		if PageSize="" then PageSize=15
	Else
		'### 1줄에 2개
		if PageSize="" then PageSize=30
	End If

	'if colorCD="" then colorCD="0"
	if SortMet="" then SortMet="be"		'베스트:be, 신상:ne


	if CheckResearch="undefined" then CheckResearch=""
	if len(CheckResearch)>5 then CheckResearch=""
	IF CheckResearch="" then CheckResearch=false
	if CheckExcept="undefined" then CheckExcept=""
	if len(CheckExcept)>5 then CheckExcept=""
	IF CheckExcept="" then CheckExcept=false

	'SearchText = RepWord(SearchText,"[^가-힣a-zA-Z0-9.&%\-\_\s]","")
	'ExceptText = RepWord(ExceptText,"[^가-힣a-zA-Z0-9.&%\-\_\s]","")

	SearchText = RepWord(SearchText,"[^ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9.&%+\-\_\(\)\/\\\[\]\~\s]","")
    ExceptText = RepWord(ExceptText,"[^ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9.&%+\-\_\(\)\/\\\[\]\~\s]","")

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

	'검색 로그 저장 여부
	IF CStr(SearchText)=CStr(PrevSearchText) Then
		LogsAccept = false
	End if

    '// 검색 조건 재설정 //2015/03/12 추가 (기존에 없었음)
    PrevSearchText = SearchText

    ''2018/03/20 AB TEST  ============================================================
    Dim is_AbTestTarget : is_AbTestTarget=FALSE     ''AB종료 2018/03/26
    Dim ab_targetGroup : ab_targetGroup=""
    if (SortMet<>"be") then is_AbTestTarget=FALSE
    if (is_AbTestTarget) then
        if (session.sessionid mod 2=0) then
            ab_targetGroup="a"
        else
            ab_targetGroup="b"
        end if
    end if

	'// 상품검색
	dim oDoc,iLp
	set oDoc = new SearchItemCls
	oDoc.FRectSearchTxt = DocSearchText
	
	if (is_AbTestTarget) and (ab_targetGroup="b") then  '' 2018/03/20 AB TEST 분기
        if (SortMet="be") then
            oDoc.FRectSortMethod	= "vv"
        else
            oDoc.FRectSortMethod	= SortMet
        end if
    else
        oDoc.FRectSortMethod	= SortMet
    end if
    
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

	'//logparam
	Dim logparam : logparam = "&pRtr="& server.URLEncode(SearchText)
    if (is_AbTestTarget) then
        logparam=logparam&"&ab=023_"&ab_targetGroup
    end if

	'// amplitude로 전송할 데이터
	Dim vAmplitudeCategoryDepth, vAmplitudeSortMet, vAmplitudeFilterQuickMenuValue, vAmplitudeModeValue, vAmplitudeColorCodeValue, vAmplitudeStyleCodeValue
	Dim VAmplitudeDeliveryType, vAmplitudeMinPriceValue, vAmplitudeMaxPriceValue, vAmplitudeReSearchTxt
	If dispcate <> "" Then
		vAmplitudeCategoryDepth = Len(dispcate)/3
	Else
		vAmplitudeCategoryDepth = "1"
	End If

	Select Case Trim(sortMet)
		Case "ne"
			vAmplitudeSortMet = "new"
		Case "be"
			vAmplitudeSortMet = "best"
		Case "ws"
			vAmplitudeSortMet = "wish"
		Case "hs"
			vAmplitudeSortMet = "sale"
		Case "hp"
			vAmplitudeSortMet = "highprice"
		Case "lp"
			vAmplitudeSortMet = "lowprice"
		Case "br"
			vAmplitudeSortMet = "review"
	End Select
	vAmplitudeFilterQuickMenuValue = ""

	If SellScope="N" Then
		vAmplitudeFilterQuickMenuValue = vAmplitudeFilterQuickMenuValue&",soldout"
	End If
	If deliType="TN" Then
		vAmplitudeFilterQuickMenuValue = vAmplitudeFilterQuickMenuValue&",tenbyten_delivery"
	End If
	If searchflag="sc" Then
		vAmplitudeFilterQuickMenuValue = vAmplitudeFilterQuickMenuValue&",on_sale"
	End If
	If pojangok="o" Then
		vAmplitudeFilterQuickMenuValue = vAmplitudeFilterQuickMenuValue&",packing"
	End If
	If 	vAmplitudeFilterQuickMenuValue = "" Then
		vAmplitudeFilterQuickMenuValue = "none"
	End If
	If vAmplitudeFilterQuickMenuValue <> "none" Then
		vAmplitudeFilterQuickMenuValue = Right(vAmplitudeFilterQuickMenuValue, Len(vAmplitudeFilterQuickMenuValue)-1)
	End If

	Dim prevmode : prevmode = requestCheckVar(request("prevmode"),1) ''기존 리스트 썸네일형 값
	If prevmode = "" Then
		prevmode = mode
	End If
	If prevmode <> mode Then
		vAmplitudeModeValue = mode
		prevmode = mode
	Else
		vAmplitudeModeValue = "none"
	End If

	If Trim(minPrice)="" Then
		vAmplitudeMinPriceValue = "none"
	Else
		vAmplitudeMinPriceValue = minPrice
	End If

	If Trim(maxPrice)="" Then
		vAmplitudeMaxPriceValue = "none"
	Else
		vAmplitudeMaxPriceValue = maxPrice
	End If

	If Trim(colorCD)="" Then
		vAmplitudeColorCodeValue = "none"
	Else
		vAmplitudeColorCodeValue = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(colorCD, "001", "red"), "002","orange"), "003","yellow"), "005", "green"), "016", "mint"),"007","blue"),"020","navy"),"008","violet"),"009","pink"),"011","white"),"012","grey"),"013","black"),"025","check"),"026","stripe"),"027","dot")

		vAmplitudeColorCodeValue = Left(vAmplitudeColorCodeValue, Len(vAmplitudeColorCodeValue)-1)
		vAmplitudeColorCodeValue = Right(vAmplitudeColorCodeValue, Len(vAmplitudeColorCodeValue)-1)
	End If

	If Trim(stylecd)="" Then
		vAmplitudeStyleCodeValue = "none"
	Else
		vAmplitudeStyleCodeValue = replace(replace(replace(replace(replace(replace(replace(replace(replace(stylecd, "010", "classic"), "020","cutie"), "030","dandy"), "040", "modern"), "050", "natural"),"060","oriental"),"070","pop"),"080","romantic"),"090","vintage")

		vAmplitudeStyleCodeValue = Left(vAmplitudeStyleCodeValue, Len(vAmplitudeStyleCodeValue)-1)
		vAmplitudeStyleCodeValue = Right(vAmplitudeStyleCodeValue, Len(vAmplitudeStyleCodeValue)-1)
	End If

	Select Case Trim(deliType)
		Case "TN"
			VAmplitudeDeliveryType = "tenbyten"
		Case "WD"
			VAmplitudeDeliveryType = "global"
		Case "FD"
			VAmplitudeDeliveryType = "free"
		Case "FT"
			VAmplitudeDeliveryType = "free_tenbyten"
		Case Else
			VAmplitudeDeliveryType = "none"
	End Select

	If Trim(ReSearchText) <> "" Then
		vAmplitudeReSearchTxt = ReSearchText
	Else
		vAmplitudeReSearchTxt = ""
	End If

	If vListOption = "all" Then	'### 상품,이벤트, 플레잉 중 전체 다 볼때 에만 나타남. 검색하면 사라짐.
		'####### PLAYing, 기획전/이벤트 만들어 넣을 곳
		Dim vEventBody, vPlayingBody, vExhibiBody, vEnm, oDocPl, oGrEvt
		
		'// 이벤트 검색결과
		set oGrEvt = new SearchEventCls
		oGrEvt.FRectSearchTxt = DocSearchText
		oGrEvt.FRectChannel = "M"		'검색 채널 (W:isWeb, M:isMobile, A:isApp)
		oGrEvt.FCurrPage = CurrPage
		oGrEvt.FPageSize = 1
		oGrEvt.FScrollCount =10
		oGrEvt.FRectGubun = "mktevt"
		oGrEvt.getEventList
		
		If oGrEvt.FResultCount > 0 Then
			vEnm = db2html(oGrEvt.FItemList(0).Fevt_name)

			'// 검색결과 이벤트 배너영역 수정
			If oGrEvt.FItemList(0).Fetc_itemimg = "" Then
				If oGrEvt.FItemList(0).Fevt_bannerimg = "" Then
					If oGrEvt.FItemList(0).Fetc_itemid = "" Then
						vEventBody = vEventBody & "<li class=""exhibition nothumbnail type-color-blue"">"
					End If
				Else
					vEventBody = vEventBody & "<li class=""exhibition type-color-pink"">"
				End If
			Else
				vEventBody = vEventBody & "<li class=""exhibition type-color-pink"">"
			End If

			IF oGrEvt.FItemList(0).Fevt_LinkType="I" and oGrEvt.FItemList(0).Fevt_bannerLink<>"" THEN		'#별도 링크타입
				vEventBody = vEventBody & "<a href = """" onClick=""top.location.href='" & oGrEvt.FItemList(0).Fevt_bannerLink & "'; fnAmplitudeEventMultiPropertiesAction('click_search_result_item','item_index|item_type|list_style|sort|keyword|list_type','1|event|"&CHKIIF(mode="L","list","tile")&"|"&vAmplitudeSortMet&"|"&Replace(SearchText," ","")&"|"&vListOption&"'); return false;"">"
			Else
				vEventBody = vEventBody & "<a href = """" onClick=""top.location.href='/event/eventmain.asp?eventid=" & oGrEvt.FItemList(0).Fevt_code & "&pNtr=re_"&server.UrlEncode(DocSearchText)&"'; fnAmplitudeEventMultiPropertiesAction('click_search_result_item','item_index|item_type|list_style|sort|keyword|list_type','1|event|"&CHKIIF(mode="L","list","tile")&"|"&vAmplitudeSortMet&"|"&Replace(SearchText," ","")&"|"&vListOption&"'); return false;"">"
			End If

			'// 검색결과 이벤트 배너영역 수정
			If oGrEvt.FItemList(0).Fetc_itemimg = "" Then
				If oGrEvt.FItemList(0).Fevt_bannerimg = "" Then
					If oGrEvt.FItemList(0).Fetc_itemid <> "" Then
						vEventBody = vEventBody & "<div class=""thumbnail""><img src=""http://webimage.10x10.co.kr/image/icon1/" & GetImageSubFolderByItemid(oGrEvt.FItemList(0).Fetc_itemid) & "/" & oGrEvt.FItemList(0).Ficon1image & """ alt="""" /></div>"
					End If
				Else
					vEventBody = vEventBody & "<div class=""thumbnail""><img src=""" & oGrEvt.FItemList(0).Fevt_bannerimg & """ alt="""" /></div>"
				End If
			Else
				vEventBody = vEventBody & "<div class=""thumbnail""><img src=""" & oGrEvt.FItemList(0).Fetc_itemimg & """ alt="""" /></div>"
			End If

			vEventBody = vEventBody & "<div class=""desc""><span class=""label"">이벤트</span>"
			vEventBody = vEventBody & "<p class=""name"">" & fnEventNameSplit(vEnm,"name") & "</p>"
			vEventBody = vEventBody & "<p class=""subcopy"">" & db2html(oGrEvt.FItemList(0).Fevt_subname) & "</p>"
			vEventBody = vEventBody & "<div class=""price"">"
			if ubound(Split(vEnm,"|"))> 0 Then
				If oGrEvt.FItemList(0).Fissale Or (oGrEvt.FItemList(0).Fissale And oGrEvt.FItemList(0).Fiscoupon) then
					vEventBody = vEventBody & "<b class=""discount color-red"">"&cStr(Split(vEnm,"|")(1))&"</b>"
				ElseIf oGrEvt.FItemList(0).Fiscoupon Then
					vEventBody = vEventBody & "<b class=""discount color-green"">"&cStr(Split(vEnm,"|")(1))&"<small>쿠폰</small></b>"
				End If
			end If
			vEventBody = vEventBody & "</div></div></a></li>"
		End If

		oGrEvt.FRectGubun = "planevt"
		oGrEvt.getEventList
		
		If oGrEvt.FResultCount > 0 Then
			vEnm = db2html(oGrEvt.FItemList(0).Fevt_name)

			'// 검색결과 이벤트 배너영역 수정
			If oGrEvt.FItemList(0).Fetc_itemimg = "" Then
				If oGrEvt.FItemList(0).Fevt_bannerimg = "" Then
					If oGrEvt.FItemList(0).Fetc_itemid = "" Then
						vExhibiBody = vExhibiBody & "<li class=""exhibition nothumbnail type-color-pink"">"
					End If
				Else
					vExhibiBody = vExhibiBody & "<li class=""exhibition type-color-pink"">"
				End If
			Else
				vExhibiBody = vExhibiBody & "<li class=""exhibition type-color-pink"">"
			End If

			IF oGrEvt.FItemList(0).Fevt_LinkType="I" and oGrEvt.FItemList(0).Fevt_bannerLink<>"" THEN		'#별도 링크타입
				vExhibiBody = vExhibiBody & "<a href = """" onClick=""top.location.href='" & oGrEvt.FItemList(0).Fevt_bannerLink & "'; fnAmplitudeEventMultiPropertiesAction('click_search_result_item','item_index|item_type|list_style|sort|keyword|list_type','1|planning|"&CHKIIF(mode="L","list","tile")&"|"&vAmplitudeSortMet&"|"&Replace(SearchText," ","")&"|"&vListOption&"'); return false;"">"
			Else
				vExhibiBody = vExhibiBody & "<a href = """" onClick=""top.location.href='/event/eventmain.asp?eventid=" & oGrEvt.FItemList(0).Fevt_code & "&pNtr=re_"&server.UrlEncode(DocSearchText)&"'; fnAmplitudeEventMultiPropertiesAction('click_search_result_item','item_index|item_type|list_style|sort|keyword|list_type','1|planning|"&CHKIIF(mode="L","list","tile")&"|"&vAmplitudeSortMet&"|"&Replace(SearchText," ","")&"|"&vListOption&"'); return false;"">"
			End If

			'// 검색결과 이벤트 배너영역 수정
			If oGrEvt.FItemList(0).Fetc_itemimg = "" Then
				If oGrEvt.FItemList(0).Fevt_bannerimg = "" Then
					If oGrEvt.FItemList(0).Fetc_itemid <> "" Then
						vExhibiBody = vExhibiBody & "<div class=""thumbnail""><img src=""http://webimage.10x10.co.kr/image/icon1/" & GetImageSubFolderByItemid(oGrEvt.FItemList(0).Fetc_itemid) & "/" & oGrEvt.FItemList(0).Ficon1image & """ alt="""" /></div>"
					End If
				Else
					vExhibiBody = vExhibiBody & "<div class=""thumbnail""><img src=""" & oGrEvt.FItemList(0).Fevt_bannerimg & """ alt="""" /></div>"
				End If
			Else
				vExhibiBody = vExhibiBody & "<div class=""thumbnail""><img src=""" & oGrEvt.FItemList(0).Fetc_itemimg & """ alt="""" /></div>"
			End If

			vExhibiBody = vExhibiBody & "<div class=""desc""><span class=""label"">기획전</span>"
			vExhibiBody = vExhibiBody & "<p class=""name"">" & fnEventNameSplit(vEnm,"name") & "</p>"
			vExhibiBody = vExhibiBody & "<p class=""subcopy"">" & db2html(oGrEvt.FItemList(0).Fevt_subname) & "</p>"
			vExhibiBody = vExhibiBody & "<div class=""price"">"
			if ubound(Split(vEnm,"|"))> 0 Then
				If oGrEvt.FItemList(0).Fissale Or (oGrEvt.FItemList(0).Fissale And oGrEvt.FItemList(0).Fiscoupon) then
					vExhibiBody = vExhibiBody & "<b class=""discount color-red"">"&cStr(Split(vEnm,"|")(1))&"</b>"
				ElseIf oGrEvt.FItemList(0).Fiscoupon Then
					vExhibiBody = vExhibiBody & "<b class=""discount color-green"">"&cStr(Split(vEnm,"|")(1))&"<small>쿠폰</small></b>"
				End If
			end If
			vExhibiBody = vExhibiBody & "</div></div></a></li>"
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
			vPlayingBody = "<li class=""playing"">"
			If oDocPl.FItemList(0).Fimg28 <> "" Then
				vPlayingBody = vPlayingBody & "<a href=""/playing/view.asp?didx="&oDocPl.FItemList(0).Fdidx&"&pNtr=rp_"&server.UrlEncode(DocSearchText)&""" onclick=fnAmplitudeEventMultiPropertiesAction('click_search_result_item','item_index|item_type|list_style|sort|keyword|list_type','1|playing|"&CHKIIF(mode="L","list","tile")&"|"&vAmplitudeSortMet&"|"&Replace(SearchText," ","")&"|"&vListOption&"'); style=""background-image:url(" & oDocPl.FItemList(0).Fimg28 & ");"">"
			Else
				If oDocPl.FItemList(0).Fmo_bgcolor <> "" Then
					vPlayingBody = vPlayingBody & "<a href=""/playing/view.asp?didx="&oDocPl.FItemList(0).Fdidx&"&pNtr=rp_"&server.UrlEncode(DocSearchText)&""" onclick=fnAmplitudeEventMultiPropertiesAction('click_search_result_item','item_index|item_type|list_style|sort|keyword|list_type','1|playing|"&CHKIIF(mode="L","list","tile")&"|"&vAmplitudeSortMet&"|"&Replace(SearchText," ","")&"|"&vListOption&"'); style=""background-color:#" & oDocPl.FItemList(0).Fmo_bgcolor & ";"">"
				Else
					vPlayingBody = vPlayingBody & "<a href=""/playing/view.asp?didx="&oDocPl.FItemList(0).Fdidx&"&pNtr=rp_"&server.UrlEncode(DocSearchText)&""" onclick=fnAmplitudeEventMultiPropertiesAction('click_search_result_item','item_index|item_type|list_style|sort|keyword|list_type','1|playing|"&CHKIIF(mode="L","list","tile")&"|"&vAmplitudeSortMet&"|"&Replace(SearchText," ","")&"|"&vListOption&"'); style=""background-color:#ffdddb;"">"
				End If
			End IF
			vPlayingBody = vPlayingBody & "<div class=""desc""><p class=""name"">" & db2html(oDocPl.FItemList(0).Ftitle) & "</p></div></a></li>"
		End If
		set oDocPl = nothing
	End If
	

	'// 검색결과 내위시 표시정보 접수
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
			Next
		End If
	End If
	
Dim rcParam, ampItemIndex
For i=0 To oDoc.FResultCount-1
'클릭 위치 Parameter 추가
rcParam = "&rc=rpos_" & CurrPage &"_" & (i+1)
ampItemIndex = (CurrPage*PageSize)-(PageSize-(i+1))
classStr = ""
linkUrl = "/category/category_itemPrd.asp?itemid="& oDoc.FItemList(i).FItemID & "&disp=" & oDoc.FItemList(i).FCateCode & logparam & rcParam				
adultChkFlag = session("isAdult") <> true and oDoc.FItemList(i).FadultType = 1								

If oDoc.FItemList(i).FItemDiv="21" Then
	classStr = addClassStr(classStr,"deal-item")							
end if
if adultChkFlag then
	classStr = addClassStr(classStr,"adult-item")								
end if						
%>
<% If oDoc.FItemList(i).FItemDiv="21" Then %>
<li class="<%=classStr%>" <%=chkIIF(adultChkFlag, "onclick=""confirmAdultAuth('"&linkUrl&"');""","")%>>
	<a href="/category/category_itemPrd.asp?itemid=<%= oDoc.FItemList(i).FItemID %>&disp=<%= oDoc.FItemList(i).FCateCode %><%=logparam&rcParam%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_search_result_item','item_index|item_type|list_style|sort|keyword|list_type','<%=ampItemIndex%>|product|<%=CHKIIF(mode="L","list","tile")%>|<%=vAmplitudeSortMet%>|<%=Replace(SearchText," ","")%>|<%=vListOption%>');">
		<span class="deal-badge">텐텐<i>DEAL</i></span>
		<div class="thumbnail">
			<img src="<%= getThumbImgFromURL(oDoc.FItemList(i).FImageBasic,300,300,"true","false") %>" alt="" />
				<% If oDoc.FItemList(i).isSoldOut Then Response.Write "<b class=""soldout"">일시 품절</b>" End If %>
				<% if adultChkFlag then %>									
				<div class="adult-hide">
					<p>19세 이상만 <br />구매 가능한 상품입니다</p>
				</div>
				<% end if %>												
		</div>
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
				'// 무료배송 추가( class=""hidden"" , wish )
				Response.Write "<span class=""icon icon-wish"" id=""wish"&oDoc.FItemList(i).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&oDoc.FItemList(i).FItemID&""">wish</span>"
			End If
			%>
		</button>	
		<%'// 무료배송 %>
		<% If oDoc.FItemList(i).FDeliverFixDay <> "L" Then %>
			<% IF oDoc.FItemList(i).FFreeDeliveryYN="Y" Then %>
			<div class="tag free-shipping">무료배송</div>
			<% End If %>
		<% End If %>
	</div>
</li>
<% Else %>
<li class="<%=classStr%>" <%=chkIIF(adultChkFlag, "onclick=""confirmAdultAuth('"&linkUrl&"');""","")%>>
	<a href="/category/category_itemPrd.asp?itemid=<%= oDoc.FItemList(i).FItemID %>&disp=<%= oDoc.FItemList(i).FCateCode %><%=logparam&rcParam%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_search_result_item','item_index|item_type|list_style|sort|keyword|list_type','<%=ampItemIndex%>|product|<%=CHKIIF(mode="L","list","tile")%>|<%=vAmplitudeSortMet%>|<%=Replace(SearchText," ","")%>|<%=vListOption%>');">
		<%'// 해외직구배송작업추가 %>
		<% If oDoc.FItemList(i).IsDirectPurchase Then %>
			<span class="abroad-badge">해외직구</span>
		<% End If %>
		<%'// 클래스 아이콘 추가 %>
		<% If oDoc.FItemList(i).FDeliverFixDay = "L" Then %>
			<span class="class-badge">텐텐<i>클래스</i></span>
		<% End If %>
		<div class="thumbnail">
		<img src="<%= getThumbImgFromURL(oDoc.FItemList(i).FImageBasic,300,300,"true","false") %>" alt="" />
		<% if adultChkFlag then %>									
		<div class="adult-hide">
			<p>19세 이상만 <br />구매 가능한 상품입니다</p>
		</div>
		<% end if %>										
		<% If oDoc.FItemList(i).isSoldOut Then Response.Write "<b class=""soldout"">일시 품절</b>" End If %>		
		</div>
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
				'// 무료배송 추가( class=""hidden"" , wish )
				Response.Write "<span class=""icon icon-wish"" id=""wish"&oDoc.FItemList(i).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&oDoc.FItemList(i).FItemID&""">wish</span>"
			End If
			%>
		</button>
		<%'// 무료배송 %>
		<% If oDoc.FItemList(i).FDeliverFixDay <> "L" Then %>
			<% IF oDoc.FItemList(i).FFreeDeliveryYN="Y" Then %>
			<div class="tag free-shipping">무료배송</div>
			<% End If %>
		<% End If %>
	</div>
	<a href="#quickview" class="btn-view" onclick="showLayer('quickview'); jsQuickViewItem('<%= oDoc.FItemList(i).FItemID %>'); return false;">상품 퀵뷰</a>
	<button type="button" class="btn-compare-add <%=CHKIIF(InStr(vMyCItem,"item"&oDoc.FItemList(i).FItemID)>0,"on","")%>" id="comparebtn<%=oDoc.FItemList(i).FItemID%>" onClick="jsCompareItem('set','<%=oDoc.FItemList(i).FItemID%>');">비교할 상품에 추가하기</button>
</li>
<% End if %>
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
Next

If vListOption = "all" Then
Response.Write vEventBody
Response.Write vPlayingBody
Response.Write vExhibiBody
End IF

set oDoc = Nothing

if (is_AbTestTarget) then  '' 2018/03/20 AB TEST 분기
    call fn_AddIISAppendToLOG("ab=023_"&ab_targetGroup&CHKIIF(request.ServerVariables("QUERY_STRING")="","&","")) '' footer에 addlog가 또 잇으므로.
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->