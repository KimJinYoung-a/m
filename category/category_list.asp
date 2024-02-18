<%@  codepage="65001" language="VBScript" %>
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
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
	Dim vDisp : vDisp = getNumeric(requestCheckVar(request("disp"),15))
	Dim isShowSumamry : isShowSumamry = false  ''탭별 검색 갯수 표시 여부 : 느릴경우 FALSE 로
	dim SearchItemDiv : SearchItemDiv="n"	'기본 카테고리만
	dim SearchCateDep : SearchCateDep= "T"	'하위카테고리 모두 검색
	dim SearchText : SearchText = requestCheckVar(request("rect"),100) '현재 입력된 검색어
	dim SortMet		: SortMet = requestCheckVar(request("srm"),2)
	dim SearchFlag : SearchFlag = NullfillWith(requestCheckVar(request("sflag"),2),"n")
	dim pojangok : pojangok = requestCheckVar(request("pojangok"),1)
	
	dim ListDiv : ListDiv = "list" '카테고리/검색 구분용
	dim minPrice : minPrice = getNumeric(requestCheckVar(Replace(request("minPrc"),",",""),8))
	dim maxPrice : maxPrice = getNumeric(requestCheckVar(Replace(request("maxPrc"),",",""),8))
	dim deliType : deliType = requestCheckVar(request("deliType"),2)
	dim colorCD : colorCD = requestCheckVar(request("iccd"),128)
	dim CurrPage : CurrPage = getNumeric(requestCheckVar(request("cpg"),6))
	dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),5))
	dim LogsAccept : LogsAccept = true
	dim dispCate : dispCate = getNumeric(requestCheckVar(request("dispCate"),18))
	if vDisp <> "" then dispCate = vDisp

	dim makerid : makerid = ReplaceRequestSpecialChar(request("mkr"))
	dim lp, i
	Dim mode : mode = requestCheckVar(request("mode"),1) ''리스트형 썸네일형
	Dim retUrl : retUrl = requestCheckVar(request("burl"),256)
	If retUrl = "" Then retUrl = wwwUrl End If

	dim SellScope 	: SellScope=requestCheckVar(request("sscp"),1)			'품절상품 제외여부
	if SellScope = "" then
		if left(vDisp,6)="104119" Then
			SellScope = "N"                                  ''취미/강좌 카테고리는 기본 품절 포함
		Else
			SellScope = "Y"                                  ''기본 품절제외(eastone)
		end if
	end if
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

	If mode = "" Then mode = "S"

	dim ScrollCount : ScrollCount = 4
	if CurrPage="" then CurrPage=1
	If mode = "L" then
		'### 1줄에 1개
		PageSize=15
	'	if PageSize="" then PageSize=15
	Else
		'### 1줄에 2개
		PageSize=30
	'	if PageSize="" then PageSize=30
	End If

	'if colorCD="" then colorCD="0"
	if SortMet="" then
		If vDisp="101" Then '디자인문구 제외한 모든 카테고리 인기순
			SortMet="ne"
		else
			SortMet="be"		
		end If
	end if

	if CheckResearch="undefined" then CheckResearch=""
	if len(CheckResearch)>5 then CheckResearch=""
	IF CheckResearch="" then CheckResearch=false
	if CheckExcept="undefined" then CheckExcept=""
	if len(CheckExcept)>5 then CheckExcept=""
	IF CheckExcept="" then CheckExcept=false

    ''2018/02/19 injection 유효성 검사
    if (inStr(LCASE(colorCD),"**")>0 and inStr(LCASE(colorCD),"convert")>0) then
        dbget.close()
        response.end    
    end if
    
    if (inStr(LCASE(styleCD),"**")>0 and inStr(LCASE(styleCD),"convert")>0) then
        dbget.close()
        response.end    
    end if
    
	SearchText = RepWord(SearchText,"[^가-힣a-zA-Z0-9.&%\-\_\s]","")
	ExceptText = RepWord(ExceptText,"[^가-힣a-zA-Z0-9.&%\-\_\s]","")

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


	dim oDoc, iLp, objCmd, returnValue, vTotalCount
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
	End If

	if isSaveSearchKeyword and (tmpCurrSearchKeyword <> tmpPrevSearchKeyword) then
		'// 내검색어 쿠키 저장
		call procMySearchKeyword(tmpCurrSearchKeyword)
	End If

	'//logparam
'	Dim logparam : logparam = "&pRtr="& server.URLEncode(SearchText)
	Dim logparam : logparam = "&pCtr="&dispCate

	'//2017 추가 버전 검색에서 넘어 왔는지 유무
	Dim searchback_Param : searchback_Param = requestCheckVar(request("pNtr"),20)
	Dim addparam
	If searchback_Param <> "" Then
		addparam = "&pNtr="& server.URLEncode(searchback_Param)
	End If 

	'//페이지 타이틀
	strHeadTitleName = getDisplayCateNameDB(dispCate)
	strPageKeyword = CategoryNameUseLeftMenuDB(left(dispCate,3)) & ", " & replace(strHeadTitleName,"""","")

	'Metatag 추가
	strPageKeyword = SearchText

	'// 구글 ADS 스크립트 관련(2018.09.21 신규버전 추가)
	googleADSCRIPT = " <script> "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "   gtag('event', 'page_view', { "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "     'send_to': 'AW-851282978', "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "     'ecomm_pagetype': 'searchresults', "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "     'ecomm_prodid': '', "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "     'ecomm_totalvalue': '' "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "   }); "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & " </script> "
	
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
'			response.write getLoginUserid() &"//"& rstArrItemid &"//"&vWishArr
'			response.end
			Call getMyFavItemList(getLoginUserid(),rstArrItemid,vWishArr)
		end if
	end if

	'### 현재 위치 ###
	Dim vCateNavi, vCateItemCount, vIsLastDepth, vCateCnt
	vIsLastDepth = fnIsLastDepth(dispCate)
	vCateNavi = fnPrnCategoryHistorymultiV17(dispCate,"X",vCateCnt,"goCategoryList")

	If (searchFlag="n") Then
		vCateItemCount = FormatNumber(oDoc.FTotalCount,0)
	ElseIf (isShowSumamry) Then
		vCateItemCount = FormatNumber(getCateListCount(searchFlag,SearchItemDiv,SearchCateDep,dispCate,arrCate,makerid,colorCD,styleCd,attribCd,deliType,ListDiv,DocSearchText,ExceptText,SellScope),0)
	End If
	vCateNavi = replace(vCateNavi,"()","(" & vCateItemCount & ")")

dim filterttpg
filterttpg = -(Int(-((oDoc.FTotalCount/PageSize))))

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
%>
<title>10x10: <%=getDisplayCateNameDB(dispCate)%></title>
<script type="text/javascript">
<!-- #include file="./search_item_script.asp" -->
</script>
<script type="text/javascript" src="/lib/js/SearchAutoComplete2017.js?v=1.1"></script>
<script type="text/javascript">
$(function() {
	/* breadcrumbs */
	var breadcrumbsSwiper = new Swiper("#breadcrumbs .swiper-container",{
		freeMode:true,
		initialSlide:<%=vCateCnt-1%>, //for dev msg : swiper 갯수(-1)만큼 적용되도록 처리해주세요
		slidesPerView:"auto"
	});

	$(".filter-category").each(function(){
		var itemCheck = $(this).children("ul").children("li").length;
		if (itemCheck > 9) {
			$(".filter-category ul li:gt(8)").hide();
			$(".filter-category .btn-group").show();
		}
	});

	$(".filter-category .btn-group").on("click", function(){
		$(".filter-category ul li:gt(8)").show();
		$(this).hide();
	});

	$(".panel .hgroup a").on("keyup", function(){
		var position = $("#"+v+"").offset();
		$('html, body').animate({scrollTop : position.top}, 500);
	});

	$("#mask, #searchFilter .ly-header").on('scroll touchmove mousewheel', function(event) {
		event.preventDefault();
		event.stopPropagation();
		return false;
	});

	<%' amplitude 이벤트 로깅 %>
	<% if trim(dispCate)<>"" then %>
		fnAmplitudeEventMultiPropertiesAction("view_category", "category_name|category_code|category_depth|sort", "<%=CategoryNameUseLeftMenuDB(Left(dispCate, 3))%>|<%=dispcate%>|<%=vAmplitudeCategoryDepth%>|<%=vAmplitudeSortMet%>");
		<% if vAmplitudeModeValue <> "none" then %>
			fnAmplitudeEventMultiPropertiesAction('click_category_productlist_setfilter','category_code|quick_menu|list_style|style|color|delivery|low_price|high_price|in_search_keyword','<%=dispCate%>|<%=vAmplitudeFilterQuickMenuValue%>|<%=replace(replace(vAmplitudeModeValue, "L","list"),"S","tile")%>|<%=vAmplitudeStyleCodeValue%>|<%=vAmplitudeColorCodeValue%>|<%=VAmplitudeDeliveryType%>|<%=vAmplitudeMinPriceValue%>|<%=vAmplitudeMaxPriceValue%>|<%=vAmplitudeReSearchTxt%>');
		<% else %>
			if ($("#selectedfilter").html()!="")
			{
				fnAmplitudeEventMultiPropertiesAction('click_category_productlist_setfilter','category_code|quick_menu|list_style|style|color|delivery|low_price|high_price|in_search_keyword','<%=dispCate%>|<%=vAmplitudeFilterQuickMenuValue%>|<%=vAmplitudeModeValue%>|<%=vAmplitudeStyleCodeValue%>|<%=vAmplitudeColorCodeValue%>|<%=VAmplitudeDeliveryType%>|<%=vAmplitudeMinPriceValue%>|<%=vAmplitudeMaxPriceValue%>|<%=vAmplitudeReSearchTxt%>');
			}
		<% end if %>
	<% end if %>
	<%'// amplitude 이벤트 로깅 %>

	/* category exhibition */
	var eventSwiper = new Swiper(".category-exhibition .swiper-container", {
		slidesPerView:"auto",
		freeMode:true
	});
	$(".category-exhibition .view-all-ex a").css({"opacity":"0","left":"-25px"});
	eventSwiper.on('reachEnd', function() {
		$(".category-exhibition .view-all-ex a").css({"opacity":"1","left":"0"});
	});
});


function jsGoPage(){
	var filterpagego = parseInt($("#filterpage").val());
	var maxoffset = parseInt($("#maxfilterpage").val());
	if(filterpagego < 1){
		$("#filterpage").val("1");
		filterpagego = "1"
	}else if(filterpagego > maxoffset){
		$("#filterpage").val(maxoffset);
		filterpagego = maxoffset
	}
	document.sFrm.cpg.value = filterpagego;
	document.sFrm.action = "category_list.asp";
	sFrm.submit();
}

function maxLengthCheck(object){
	var maxpglen = maxfilterpage.value.length;
	if (object.value.length > maxpglen)
	  object.value = object.value.slice(0, maxpglen)
}

function goCategoryList(dispCate){
	document.sFrm.cpg.value = 1;
	document.sFrm.dispCate.value=dispCate;
	document.sFrm.action = "category_list.asp";
	sFrm.submit();
}

function amplitudeChangeSortSend(a)
{
	var sendsortvalue;
	switch(a) {
		case "ne":
			sendsortvalue = "new";
			break;
		case "be":
			sendsortvalue = "best";
			break;
		case "ws":
			sendsortvalue = "wish";
			break;
		case "hs":
			sendsortvalue = "sale";
			break;
		case "hp":
			sendsortvalue = "highprice";
			break;
		case "lp":
			sendsortvalue = "lowprice";
			break;
		case "br":
			sendsortvalue = "review";
			break;
	}
	fnAmplitudeEventMultiPropertiesAction('click_category_productlist_change_sort','now_sort|change_sort|category_code','<%=vAmplitudeSortMet%>|'+sendsortvalue+'|<%=dispcate%>');
}
function confirmAdultAuth(cPath){
	if(confirm('이 상품은 성인 인증이 필요한 상품입니다. 성인 확인을 위해 성인 인증을 진행합니다.')){
		var url = '/login/login_adult.asp?backpath='+ cPath;
		location.href = url;
	}
}
</script>
</head>
<body class="default-font body-sub bg-grey">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->

	<!-- contents -->
	<div id="content" class="content">
		<%'// 카테고리 배너 %>
		<% server.Execute("/category/include_category_banner.asp") %>
		<!-- breadcrumbs -->
		<% if vCateDepth = 3 then %>
			<div id="breadcrumbs" class="breadcrumbs">
				<div class="swiper-container">
					<ol class="swiper-wrapper">
						<%= vCateNavi %>
					</ol>
				</div>
			</div>
		<% end if %>

		<div class="filter-category">
			<%
				'정렬상자 호출; sDisp:전시카테고리, sType:확장여부, sCallback:콜백함수명 (via functions.asp)
				Call fnPrntDispCateNaviV17(dispCate,"E","goCategoryList")
			%>
			<div class="btn-group">
				<button type="button">전체 보기<span class="icon icon-arrow"></span></button>
			</div>
		</div>

		<%
			If vCateDepth = "2" Then
				'// 카테고리 이벤트 top 5
				'Call fnCategoryBestEvent(Left(dispCate,3) , strHeadTitleName)
				Call fnCategoryBestEventPcSync(Left(dispCate,3) , strHeadTitleName)
			End If 
		%>

		<form name="sFrm" id="listSFrm" method="get" action="category_list.asp" style="margin:0px;">
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
		<input type="hidden" name="pNtr" value="<%= searchback_Param %>">
		</form>
		
		<%' 선택/입력된필터목록 %>
		<div id="filterList" class="filter-list">
			<div class="swiper-container">
				<ul class="swiper-wrapper list-roundbox" id="selectedfilter">
				</ul>
			</div>
		</div>

		
		<div class="sortingbar">
			<div class="option-left">
				<p class="total"><b><%= FormatNumber(vTotalCount,0) %></b>건</p>
			</div>
			<div class="option-right">
				<div class="styled-selectbox styled-selectbox-default">
					<select class="select" id="srm" name="srm" onChange="jsGoSort(this.value);amplitudeChangeSortSend(this.value);" title="검색결과 리스트 정렬 선택옵션">
						<option value="ne" <%=CHKIIF(SortMet="ne","selected","")%>>신규순</option>
						<option value="bs" <%=CHKIIF(SortMet="bs","selected","")%>>판매량순</option>						
						<option value="be" <%=CHKIIF(SortMet="be","selected","")%>>인기순</option>
						<option value="ws" <%=CHKIIF(SortMet="ws","selected","")%>>위시등록순</option>
						<option value="hs" <%=CHKIIF(SortMet="hs","selected","")%>>할인율순</option>
						<option value="hp" <%=CHKIIF(SortMet="hp","selected","")%>>높은가격순</option>
						<option value="lp" <%=CHKIIF(SortMet="lp","selected","")%>>낮은가격순</option>
						<option value="br" <%=CHKIIF(SortMet="br","selected","")%>>리뷰등록순</option>
					</select>
					<%
						'정렬상자 호출; sType:정렬방법, sUse:사용처 구분, sCallback:콜백함수명 (via functions.asp)
					'	Call fnPrntSortNaviV17(SortMet,"abcgdef", "jsGoSort")
					%>
				</div>
			</div>
		</div>

		<%' 필터 버튼 %>
		<div class="fixed-bottom btn-floating btn-roundshadow-single">
			<a href="#searchFilter" id="filterbtn" class="btn-filter <%=CHKIIF(search_on="on","on","")%>" onclick="showLayer('searchFilter'); fnAmplitudeEventMultiPropertiesAction('click_category_productlist_filter','category_code|list_style|sort','<%=dispCate%>|<%=CHKIIF(mode="L","list","tile")%>|<%=vAmplitudeSortMet%>'); return false;">필터</a>
		</div>

		<% If vTotalCount > 0 Then %>	
			<%' item list :격자형 (클래스명 : type-grid)%>
			<div class="items type-<%=CHKIIF(mode="L","list","grid")%>" id="itemWrapV17a">
				<ul id="lyrSrcpdtList"><%'  id="lyrEvtList" %>
					<%
					Dim rcParam
					For i=0 To oDoc.FResultCount-1
					'클릭 위치 Parameter 추가
					rcParam = "&rc=category_" & fix((i)/2)+1 &"_" & ((i) mod 2)+1

					classStr = ""
					linkUrl = "/category/category_itemPrd.asp?itemid="& oDoc.FItemList(i).FItemID & "&dispCate=" & oDoc.FItemList(i).FCateCode & logparam & rcParam				
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
							<a href="/deal/deal.asp?itemid=<%= oDoc.FItemList(i).FItemID %>&dispCate=<%= oDoc.FItemList(i).FCateCode %><%=logparam %><%=addparam%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_category_productlist_item','item_index|list_style|sort|category_code','<%=i+1%>|<%=CHKIIF(mode="L","list","tile")%>|<%=vAmplitudeSortMet%>|<%=dispCate%>');">
							<span class="deal-badge">텐텐<i>DEAL</i></span>
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
								<% end if %>
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
								<%'// 무료배송 추가 %>
								<% If oDoc.FItemList(i).FDeliverFixDay <> "L" Then %>
									<% IF oDoc.FItemList(i).FFreeDeliveryYN="Y" Then %>
									<div class="tag free-shipping">무료배송</div>
									<% End If %>
								<% End If %>
							</div>
						</li>
						<% Else %>
						<li class="<%=classStr%>" <%=chkIIF(adultChkFlag, "onclick=""confirmAdultAuth('"&linkUrl&"');""","")%>>
							<a href="/category/category_itemPrd.asp?itemid=<%= oDoc.FItemList(i).FItemID %>&dispCate=<%= oDoc.FItemList(i).FCateCode %><%=logparam %><%=addparam%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_category_productlist_item','item_index|list_style|sort|category_code','<%=i+1%>|<%=CHKIIF(mode="L","list","tile")%>|<%=vAmplitudeSortMet%>|<%=dispCate%>');">
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
											Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oDoc.FItemList(i).getRealPrice,0) & "<span class=""won"">" & CHKIIF(oDoc.FItemList(i).IsMileShopitem," Point","원") & "</span></b></div>" &  vbCrLf
										End If
									%>
									</div>
								</div>
							</a>
							<div class="etc">
								<% If oDoc.FItemList(i).FEvalCnt > 0 Then %>
									<div class="tag review"><span class="icon icon-rating"><i style="width:<%=fnEvalTotalPointAVG(oDoc.FItemList(i).FPoints,"search")%>%;"><%=fnEvalTotalPointAVG(oDoc.FItemList(i).FPoints,"search")%>점</i></span><span class="counting"><%=CHKIIF(oDoc.FItemList(i).FEvalCnt>999,"999+",oDoc.FItemList(i).FEvalCnt)%></span></div>
								<% end if %>
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
								<%'// 무료배송 추가 %>
								<% If oDoc.FItemList(i).FDeliverFixDay <> "L" Then %>
									<% IF oDoc.FItemList(i).FFreeDeliveryYN="Y" Then %>
									<div class="tag free-shipping">무료배송</div>
									<% End If %>
								<% End If %>
							</div>
						</li>
						<% End If %>
					<%
					Next
					%>
				</ul>
			</div>
		<% Else %>
			<div class="nodata nodata-category">
				<p><b>해당되는 내용이 없습니다.</b></p>
				<p>품절 또는 종료된 경우에는 노출되지 않을 수 있습니다.</p>
			</div>
		<% End If %>
	</div>
	<!-- //contents -->

	<%' 필터 %>
	<!-- #include virtual="/category/inc_search_item_filter.asp" -->

	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<%
	set oDoc = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->