<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description :  브랜드
' History : 2017.09.05 유태욱 생성
'####################################################
%>
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
<!-- #INCLUDE Virtual="/lib/classes/street/BrandStreetCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
	dim snsimg
	dim classStr, adultChkFlag, adultPopupLink, linkUrl
	Dim vDisp : vDisp = getNumeric(requestCheckVar(request("disp"),15))
	dim oldmakerid : oldmakerid = requestCheckVar(Request("makerid"),32)
	Dim isShowSumamry : isShowSumamry = false  ''탭별 검색 갯수 표시 여부 : 느릴경우 FALSE 로
	dim SearchItemDiv : SearchItemDiv="y"	'기본 카테고리만
	dim SearchCateDep : SearchCateDep= "T"	'하위카테고리 모두 검색
	dim SearchText : SearchText = requestCheckVar(request("rect"),100) '현재 입력된 검색어
	dim SortMet		: SortMet = requestCheckVar(request("srm"),2)
	dim SearchFlag : SearchFlag = NullfillWith(requestCheckVar(request("sflag"),2),"n")
	dim pojangok : pojangok = requestCheckVar(request("pojangok"),1)
	
	dim ListDiv : ListDiv = "brand" '카테고리/검색 구분용
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
	if oldmakerid <> "" then makerid = oldmakerid

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

	If mode = "" Then mode = "S"

	dim ScrollCount : ScrollCount = 4
	if CurrPage="" then CurrPage=1
	If mode = "L" then
		'### 1줄에 1개
		PageSize=15
		if PageSize="" then PageSize=15
	Else
		'### 1줄에 2개
		PageSize=30
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

	'// 나의 찜 브랜드
	Dim LoginUserid
	Dim isMyFavBrand: isMyFavBrand=false
	LoginUserid = getLoginUserid()
	If IsUserLoginOK then
		isMyFavBrand = getIsMyFavBrand(LoginUserid, makerid)
	End If
	
	dim oStreet
	Set oStreet = New CStreet
		oStreet.FRectMakerid = makerid
		oStreet.GetBrandstreetInfo
	
	If oStreet.FResultCount=0 then
		Call Alert_Return("존재하지 않는 브랜드입니다.")
		dbget.close()	:	response.End
	End If

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

	Dim moreYn

	if isSaveSearchKeyword and (tmpCurrSearchKeyword <> tmpPrevSearchKeyword) then
		'// 내검색어 쿠키 저장
		call procMySearchKeyword(tmpCurrSearchKeyword)
	End If

	'//logparam
	Dim logparam : logparam = "&pRtr="& server.URLEncode(SearchText)
	'//2017 추가 버전 검색에서 넘어 왔는지 유무
	Dim searchback_Param : searchback_Param = requestCheckVar(request("pNtr"),20)
	Dim addparam
	If searchback_Param <> "" Then
		addparam = "&pNtr="& server.URLEncode(searchback_Param)
	End If

	'Metatag 추가
	strPageKeyword = "브랜드 스트리트, " & replace(oStreet.FOneItem.Fsocname,"""","") & ", " & replace(oStreet.FOneItem.Fsocname_kor,"""","")

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

	Dim vArrIssue, vLink, cEvent, veventcnt
		veventcnt=0
	
	set cEvent = new ClsEvtCont
		cEvent.FECode = 0
		cEvent.FEKind = "19,26"	'모바일전용,모바일+APP공용
		cEvent.FDevice = "M" 'device
		cEvent.FBrand = makerid
		cEvent.FEDispCate = ""
		vArrIssue = cEvent.fnEventISSUEList
	set cEvent = nothing

	'### 현재 위치 ###
	Dim vCateNavi, vCateItemCount, vIsLastDepth, vCateCnt
	if dispCate<>"" then
		vIsLastDepth = fnIsLastDepth(dispCate)
		vCateNavi = fnPrnCategoryHistorymultiV17(dispCate,"A",vCateCnt,"goCategoryList")

		If (searchFlag="n") Then
			vCateItemCount = FormatNumber(oDoc.FTotalCount,0)
		ElseIf (isShowSumamry) Then
			vCateItemCount = FormatNumber(getCateListCount(searchFlag,SearchItemDiv,SearchCateDep,dispCate,arrCate,makerid,colorCD,styleCd,attribCd,deliType,ListDiv,DocSearchText,ExceptText,SellScope),0)
		End If
		vCateNavi = replace(vCateNavi,"()","(" & vCateItemCount & ")")	
	end if

	dim filterttpg
	filterttpg = -(Int(-((oDoc.FTotalCount/PageSize))))

	'// amplitude로 전송할 데이터
	Dim vAmplitudeCategoryDepth, vAmplitudeSortMet, vAmplitudeFilterQuickMenuValue, vAmplitudeModeValue, vAmplitudeColorCodeValue, vAmplitudeStyleCodeValue
	Dim VAmplitudeDeliveryType, vAmplitudeMinPriceValue, vAmplitudeMaxPriceValue, vAmplitudeReSearchTxt, vAmplitudeCategorycode, vAmplitudeCategoryName

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

	If Trim(dispcate)="" Then
		vAmplitudeCategorycode = "0"
		vAmplitudeCategoryDepth = "0"
		vAmplitudeCategoryName = "none"
	Else
		vAmplitudeCategorycode = dispcate
		vAmplitudeCategoryDepth = Len(dispcate)/3
		vAmplitudeCategoryName = CategoryNameUseLeftMenuDB(Left(dispCate, 3))
	End If

	'// 바로배송 표시여부
	Dim showQuickDivStatus
	showQuickDivStatus = FALSE
	If now() > #07/31/2019 12:00:00# Then
		showQuickDivStatus = FALSE
	Else
		showQuickDivStatus = TRUE
	End If

	'// 19주년 프랜드 브랜드일 경우 최대 할인율 표시(2020년 10월 29일까지)
	Dim sqlStr, maxSalePercent, chkMaxSalePercent
	sqlStr = " SELECT top 1 idx, makerid, socname, socname_kor, frontcategory, makerimageurl, maxsalepercent, orderby "
    sqlStr = sqlStr & " FROM db_temp.dbo.tbl_brandMaxSalePercent WITH(NOLOCK) Where makerid='"&makerid&"'"
	rsget.Open sqlStr,dbget, adOpenForwardOnly, adLockReadOnly
	if Not(rsget.EOF or rsget.BOF) then
        maxSalePercent = rsget("maxsalepercent")
        chkMaxSalePercent = true
    Else
        chkMaxSalePercent = false
	End if
	rsget.close
	If Left(now(),10) >= "2020-10-30" Then
		chkMaxSalePercent = false
	End If	
%>
<title>10x10: 브랜드: <%=oStreet.FOneItem.Fsocname_kor%></title>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript">
//필터관련 스크립트
var itemSwiper;
var isloading=false;

$(function(){
	/* floating button control */
	var didScroll;
	var lastScrollTop = 0;
	var delta = 5;
	var floatingbuttonHeight = $(".btn-floating").outerHeight();
	
	$(window).scroll(function () {
		didScroll = true;

		setInterval(function() {
			if (didScroll) {
				hasScrolled();
				didScroll = false;
			}
		}, 250);

		function hasScrolled() {
			var st = $(this).scrollTop();

			if(Math.abs(lastScrollTop - st) <= delta)
				return;

			if (st > lastScrollTop && st > floatingbuttonHeight){
				$(".btn-floating").removeClass('nav-down').addClass('nav-up');
			} else {
				if(st + $(window).height() < $(document).height()) {
					$(".btn-floating").removeClass('nav-up').addClass('nav-down');
				}
			}
			lastScrollTop = st;
		}
		
		if ($(window).scrollTop() >= ($(document).height()-$(window).height())-350){
			if (isloading==false){
				isloading=true;
				
				$("#lyLoading").show();
				
				var pg = $("#listSFrm input[name='cpg']").val();

				pg++;
				$("#listSFrm input[name='cpg']").val(pg);
				jsSearchListAjax();
				
				if(!$("#lyCompare").is(":hidden")){
					$(".items .btn-compare-add").show();
				}
				
				$("#lyLoading").hide();
				
				<% If vListOption = "all" or vListOption = "item" Then	%>
			//	jsCompareBtnSetting();
				<% End If %>
			}
		}
	});

	/* relate keyword */
	var relatedKeywordSwiper = new Swiper("#relatedKeyword .swiper-container", {
		slidesPerView:"auto"
	});

	/* keyword curator */
	var keywordCuratorSwiper = new Swiper("#keywordCurator .swiper-container", {
		slidesPerView:"auto"
	});

	/* filiter list */
	var filterSwiper = new Swiper("#filterList .swiper-container", {
		slidesPerView:"auto"
	});

	$("#filterList .btn-del").on("click", function(e){
		$(this).parent().remove();
	});

	/* view option */
	$(".viewoption .value button").on("click", function(){
		$(".viewoption .value button").removeClass("on");
		if ($(this).hasClass("on")){
			$(this).removeClass("on");
		} else {
			$(this).addClass("on");
		}
	});
	
	/* price */
	$(".price .textfield .itext input").on("keyup", function(){
		$(this).next().show();
	});
	$(".price .textfield .itext .btn-reset").on("click", function(){
		$(this).parent().find("input").val('');
	});

	<%' amplitude 이벤트 로깅 %>
	<% if trim(makerid) <> "" then %>
		fnAmplitudeEventMultiPropertiesAction("view_brand", "brand_id|category_code|category_depth|sort|category_name", "<%=makerid%>|<%=vAmplitudeCategorycode%>|<%=vAmplitudeCategoryDepth%>|<%=vAmplitudeSortMet%>|<%=vAmplitudeCategoryName%>");
		<% if vAmplitudeModeValue <> "none" then %>
			fnAmplitudeEventMultiPropertiesAction('click_brand_productlist_setfilter','brand_id|category_code|quick_menu|list_style|style|color|delivery|low_price|high_price|in_search_keyword','<%=makerid%>|<%=vAmplitudeCategorycode%>|<%=vAmplitudeFilterQuickMenuValue%>|<%=replace(replace(vAmplitudeModeValue, "L","list"),"S","tile")%>|<%=vAmplitudeStyleCodeValue%>|<%=vAmplitudeColorCodeValue%>|<%=VAmplitudeDeliveryType%>|<%=vAmplitudeMinPriceValue%>|<%=vAmplitudeMaxPriceValue%>|<%=vAmplitudeReSearchTxt%>');
		<% else %>
			if ($("#selectedfilter").html()!="")
			{
				fnAmplitudeEventMultiPropertiesAction('click_brand_productlist_setfilter','brand_id|category_code|quick_menu|list_style|style|color|delivery|low_price|high_price|in_search_keyword','<%=makerid%>|<%=vAmplitudeCategorycode%>|<%=vAmplitudeFilterQuickMenuValue%>|<%=vAmplitudeModeValue%>|<%=vAmplitudeStyleCodeValue%>|<%=vAmplitudeColorCodeValue%>|<%=VAmplitudeDeliveryType%>|<%=vAmplitudeMinPriceValue%>|<%=vAmplitudeMaxPriceValue%>|<%=vAmplitudeReSearchTxt%>');
			}
		<% end if %>
	<% end if %>
});


function jsSwiperReset(){
	if ($("#itemSwiper .swiper-slide").length > 1) {
		itemSwiper = new Swiper("#itemSwiper.swiper-container", {
			loop:true,
			pagination:"#itemSwiper .pagination-dot"
		});
	}
}

function jsSelectFilterSomething(gubun,thing,title,realvalue){
	var m = $("#"+realvalue+"").val();
	var t = "";

	if($("#"+thing+"").hasClass("on")){	//이미선택된것
		$("#"+thing+"").removeClass("on");
		t = m.replace(","+title+",", ",");
		
		if(t == ","){
			t = "";
		}
		
		$("#"+realvalue+"").val(t);
	}else{
		$("#"+thing+"").addClass("on");
		if(m == ""){
			$("#"+realvalue+"").val(","+title+",");
		}else{
			$("#"+realvalue+"").val(m+title+",");
		}
	}
	
	var l = $("#filter"+gubun+"list li").length;
	var a = $("#filter"+gubun+"list li a");
	var tit = "";
	var tit2 = "";
	var titcnt = 0;
	for(var i=0; i<l; i++){
		if(a.eq(i).hasClass("on")){
			if(tit == ""){
				tit = $("#filter"+gubun+"list li a").eq(i).text();
			}
			titcnt = titcnt + 1;
		}
	}
	
	if(titcnt > 1){
		tit2 = " 외 " + (titcnt-1) + "건";
	}
	
	tit = tit.replace(" BEST","")
	
	$("#filter"+gubun+"title").text(tit+tit2);
	
	jsResultTotalCount();
}

//결과내검색
function jsResearchTxt(){
	$("#rstxt").val($("#sMtxt").val());
	$("#chkr").val("true");
	$("#cpg").val("1");
	$("#listSFrm").submit();
}

//빠른메뉴 구분에 따라 값 저장
function jsFastSearch(g){
	if(g == "pum"){ //품절상품 포함
		if($("#sscp").val() == "N"){
			$("#sscp").val("");
		}else{
			$("#sscp").val("N");
		}
	}else if(g == "tendeli"){ //텐바이텐 배송
		if($("#deliType").val() == "TN"){
			$("#deliType").val("");
		}else{
			$("#deliType").val("TN");
		}
	}else if(g == "sale"){ //세일중인 상품
		if($("#sflag").val() == "sc"){
			$("#sflag").val("");
		}else{
			$("#sflag").val("sc");
		}
	}else if(g == "pojang"){ //선물포장 가능
		if($("#pojangok").val() == "o"){
			$("#pojangok").val("");
		}else{
			$("#pojangok").val("o");
		}
	}
}

//빠른메뉴 버튼 온오프. 값 저장하고 css on off
function jsFastOnOff(v){
	jsFastSearch(v);
	if($("#fast"+v+"").hasClass("on")){
		$("#fast"+v+"").removeClass("on");
	}else{
		$("#fast"+v+"").addClass("on");
	}
	
	jsResultTotalCount();
}

//배송필터액션
function jsDeliverySearch(v,title){
	if($("#deliType").val() == v){
		$("#deliType").val("");
		jsDeliOff();
		$("#deliverytitle").text("");
	}else{
		if(v == "TN"){
			if($("#fasttendeli").hasClass("on")){
				$("#deliType").val("");
				jsDeliOff();
			}else{
				$("#deliType").val("TN");
				jsDeliOff();
				$("#deli_TN").addClass("on");
				$("#fasttendeli").addClass("on");
			}
		}else{
			jsDeliOff();
			$("#deliType").val(v);
			$("#deli_"+v+"").addClass("on");
		}
		
		$("#deliverytitle").text(title);
	}
	
	jsResultTotalCount();
}

//배송필터 버튼 클릭시 css on off
function jsDeliOff(){
	$("#deli_FD").removeClass("on");
	$("#deli_TN").removeClass("on");
	$("#deli_FT").removeClass("on");
	$("#deli_WD").removeClass("on");
	<%'// 해외직구배송작업추가 %>
	$("#deli_QT").removeClass("on");
	$("#deli_DT").removeClass("on");
	$("#fasttendeli").removeClass("on");
}

//가격검색
function jsPriceSearch(){
	if($("#minprice").val() == "" || isNaN($("#minprice").val().replace(/,/gi, ""))){
		alert("가격대 범위 최저가를 숫자만로 입력해주세요.");
		$("#minprice").focus();
		return;
	}
	if($("#maxprice").val() == "" || isNaN($("#maxprice").val().replace(/,/gi, ""))){
		alert("가격대 범위 최고가를 숫자만로 입력해주세요.");
		$("#maxprice").focus();
		return;
	}
	$("#minPrc").val($("#minprice").val());
	$("#maxPrc").val($("#maxprice").val());
	
	$("#listSFrm").submit();
}

function jsPriceComma(g,p){
	var v = $("#"+p+"price").val();

	if(!IsDigit(v.replace(/,/gi, "")) || v == ""){
		alert("금액은 숫자로만 입력하셔야 합니다.");
		$("#"+p+"price").val($("#"+p+"pricehidden").val());
		return;
	}

	if(g == "up"){
		v = v.replace(/,/gi, "");
		$("#"+p+"price").val(v);
	}else if(g == "down"){
		v = getMoneyFormat(v);
		$("#"+p+"price").val(v);
	}
}

function getMoneyFormat(m){
	var a,b;

	if(m.toString().indexOf('.') != -1) {
		var nums = m.toString().split('.');
		a = nums[0];
		b = '.' + nums[1];
	} else {
		a = m;
		b = "";
	}

	return a.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + b;
}

//보기옵션. 리스트형 격자형
function jsViewoption(m){
	$("#mode").val(m);
}

//필터 액션에 따라 즉시 결과카운트 표시
function jsResultTotalCount(){
	var formData = $("#listSFrm").serialize().replace(/=(.[^&]*)/g,
		function($0,$1){ 
		return "="+escape(decodeURIComponent($1)).replace('%26','&').replace('%3D','=')
	});
	
	var rstr = $.ajax({
			type: "GET",
	        url: "/category/act_search_item_totalcount.asp",
	        data: formData,
	        dataType: "text",
	        async: false
	}).responseText;
	if(rstr!="") {
		$("#resulttotalcount").text(rstr);
    }
}

//필터 펼치기
function jsFilterShow(f){
	if($("#filter"+f+" .panelcont").is(":hidden")){
		$("#filter"+f+" .panelcont").show();
	}else{
		$("#filter"+f+" .panelcont").hide();
	}
	
	if(f != "Category"){
		$("#filterCategory .panelcont").hide();
	}
	if(f != "Brand"){
		$("#filterBrand .panelcont").hide();
	}
	if(f != "Style"){
		$("#filterStyle .panelcont").hide();
	}
	if(f != "Color"){
		$("#filterColor .panelcont").hide();
	}
	if(f != "Shipping"){
		$("#filterShipping .panelcont").hide();
	}

	return false;
}


//필터 검색한 값들 클릭시 초기값변경
function jsSelectedFilter(g){
	if(g == "pum"){
		$("#sscp").val("");
	}else if(g == "TN" || g == "FD" || g == "FT" || g == "WD" ){
		$("#deliType").val("");
	}else if(g == "sale"){
		$("#sflag").val("");
	}else if(g == "pojang"){
		$("#pojangok").val("");
	}else if(g == "disp"){
		$("#dispCate").val("");
	}else if(g == "brand"){
		$("#mkr").val("");
	}else if(g == "style"){
		$("#styleCd").val("");
	}else if(g == "color"){
		$("#iccd").val("");
	}else if(g == "price"){
		$("#minPrc").val("");
		$("#maxPrc").val("");
	}else if(g == "researchtxt"){
		$("#rstxt").val("");
	}
	
	$("#listSFrm").submit();
}

function jsSearchLayerClose(v){
	$("#"+v+"").hide();
	$("#mask").hide().css({"z-index":"10"});
}

function jsSearchListAjax(){
	var formData = $("#listSFrm").serialize().replace(/=(.[^&]*)/g,
		function($0,$1){ 
		return "="+escape(decodeURIComponent($1)).replace('%26','&').replace('%3D','=')
	});
	var str = $.ajax({
			type: "GET",
			<% If vListOption = "all" or vListOption = "item" Then %>
	        url: "/street/act_street_brand.asp",
	       <% ElseIf vListOption = "event" Then %>
	        url: "/search/act_search_event.asp",
	       <% ElseIf vListOption = "playing" Then %>
	        url: "/search/act_search_playing.asp",
	   		<% End If %>
	        data: formData,
	        dataType: "text",
	        async: false
	}).responseText;

	if(str!="") {
    	if($("#listSFrm input[name='cpg']").val()=="1") {
			isloading=false;
        } else {
       		$str = $(str)
       		$('#lyrSrcpdtList').append($str);
			fnAmplitudeEventMultiPropertiesAction('view_brand_productlist_paging','paging_index|list_style|sort|category_code|brand_id',$("#listSFrm input[name='cpg']").val()+'|<%=Replace(Replace(mode, "S", "tile"), "L", "list")%>|<%=vAmplitudeSortMet%>|<%=vAmplitudeCategorycode%>|<%=makerid%>');
        }
        isloading=false;
    } else {
    	//$(window).unbind("scroll");
    }
}
																							
function goWishPop(i){
<% If IsUserLoginOK() Then ''ErBValue.value -> 공통파일의 구분값 (cate는 1) %>
	var wishpop = window.open('/common/popWishFolder.asp?gb=search2017&itemid='+i+'','wishpop','')
<% Else %>
	top.location.href = "/login/login.asp?backpath=<%=fnBackPathURLChange(CurrURLQ())%>";
<% End If %>
}

function jsAfterWishBtn(i){
	if($("#wish"+i+"").hasClass("on")){
		
	}else{
		$("#wish"+i+"").addClass("on");
		
		var cnt = $("#cnt"+i+"").text();

		if(cnt == ""){
			$("#wish"+i+"").empty();
			$("#cnt"+i+"").empty().text("1");
		}else{
			cnt = parseInt(cnt) + 1;
			if(cnt > 999){
				$("#cnt"+i+"").empty().text("999+");
			}else{
				$("#cnt"+i+"").empty().text(cnt);
			}
		}
	}
}

function jsGoSort(a){
	document.sFrm.cpg.value = "1";
	document.sFrm.srm.value = a;
	document.sFrm.action = "/street/street_brand.asp";
	sFrm.submit();
}

function jsGoListOption(a){
	document.sFrm.cpg.value = "1";
	document.sFrm.listoption.value = a;
	document.sFrm.action = "/street/street_brand.asp";
	sFrm.submit();
}

///////////////////////////////////////

$(function() {
	
	/* event */
	$("div.evtnIsu h2").click(function(){
		if($("div.evtnIsu ul").is(":hidden")){
			$(this).parent().children('ul').show();
			$(this).children('em').hide();
		}else{
			$(this).parent().children('ul').hide();
			$(this).children('em').show();
		};
	});

	/* breadcrumbs */
	var breadcrumbsSwiper = new Swiper("#breadcrumbs .swiper-container",{
		freeMode:true,
		initialSlide:3, //for dev msg : swiper 갯수(-1)만큼 적용되도록 처리해주세요
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

	/* sub contents show, hide 
	$("#searchFilter .panel .hgroup a").on("click", function(){
		$(".panel .panelcont").hide();
		$(this).parent().next().toggle();
	});
*/
	/* one select
	$(".depth1.one-select a").on("click", function(){
		$(".depth1.one-select a").removeClass("on");
		if ($(this).hasClass("on")){
			$(this).removeClass("on");
			return false;
		} else {
			$(this).addClass("on");
			return false;
		}
	});
 */
	/* multi select
	$(".depth1.multi-select a").on("click", function(){
		$(this).toggleClass("on");
		return false;
	});
 */
	/* quick menu
	$(".quickmenu .value button").on("click", function(){
		$(this).toggleClass("on");
	});
 */
	$(".panel .hgroup a").on("keyup", function(){
		var position = $("#"+v+"").offset();
		$('html, body').animate({scrollTop : position.top}, 500);
	});

/*
	$("#mask, #searchFilter .ly-header").on('scroll touchmove mousewheel', function(event) {
		event.preventDefault();
		event.stopPropagation();
		return false;
	});
 */
});


/* layer popup */
function showLayer(v) {
	var $layer = $("#"+v+"");
	
	$layer.show();
	$layer.find(".btn-close").one("click",function () {
		$("#cpg").val("1");
		$("#listSFrm").submit();
		$layer.hide();
		$("#mask").hide().css({"z-index":"10"});
		if(v == "searchFilter"){
			$("body").css({"overflow":"auto"});
		}
	});
	
	$layer.find(".btn-close-down").one("click",function () {
		$layer.hide();
		$("#mask").hide().css({"z-index":"10"});
		if(v == "searchFilter"){
			$("body").css({"overflow":"auto"});
		}
	});

	$("#mask").on("click",function () {
		$layer.hide();
		$(this).hide().css({"z-index":"10"});
		if(v == "searchFilter"){
			$("body").css({"overflow":"auto"});
		}
	});

	if(v == "searchFilter"){
		$("#mask").show().css({"z-index":"25"});
		$("body").css({"overflow":"hidden"});
	}
	
}

//빠른이동 작업중
function jsGoPage(){
	var filterpagego = $("#filterpage").val();
	var maxoffset = $("#maxfilterpage").val();
	if(filterpagego < 1){
		$("#filterpage").val("1");
		filterpagego = "1"
	}else if(filterpagego > maxoffset){
		$("#filterpage").val(maxoffset);
		filterpagego = maxoffset
	}
	document.sFrm.cpg.value = filterpagego;
	document.sFrm.action = "/street/street_brand.asp";
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
	document.sFrm.action = "/street/street_brand.asp";
	sFrm.submit();
}

function TnMyBrandZZim(){
	<% If IsUserLoginOK() Then %>
		jjimfrm.action = "/street/domybrandjjim.asp";
		jjimfrm.submit();
	<% Else %>
		alert("찜브랜드 추가는 로그인이 필요한 서비스입니다.\로그인 하시겠습니까?");
		top.location.href = "<%=M_SSLUrl%>/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>";
	<% End If %>
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
	<!-- #include virtual="/lib/inc/incheader.asp" -->

	<!-- contents -->
	<div id="content" class="content">

		<%' <!-- for dev msg : 19주년 10월 정기세일 배너 --> %>
		<% If chkMaxSalePercent	Then %>
			<style>
			.go-19th {position:fixed; top:43%; right:-11rem; z-index:30; width:11rem; height:11.86rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/brand/m/bg.png) no-repeat center / contain; transform:translateY(-50%); transition:.8s ease-in-out;}
			.go-19th.show {right:3.2%;}
			.go-19th .inner {position:relative; padding:1.5rem .6rem 0 0; text-align:center; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; font-size:1.1rem; color:#fff;}
			.go-19th span {display:block; margin:0 auto;}
			.go-19th .txt-1 {width:4.5rem;}
			.go-19th .txt-2 {width:7rem;}
			.go-19th .ani {margin-bottom:.3em; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; font-size:1.2rem; color:#ffe676;}
			.go-19th.show .ani {animation:flash .8s .8s;}
			@keyframes flash{0%,100%,50%{opacity:1}25%,75%{opacity:0}}
			.go-19th .ani b {font-size:1.28rem;}
			.go-19th .link {position:absolute; left:0; top:0; width:100%; height:100%; font-size:0; color:transparent;}
			.go-19th .btn-close {position:absolute; right:0; top:0; width:3rem; height:3rem; font-size:0; color:transparent; background:none;}
			</style>
			<script>
			$(function() {
				var flag = true;
				$('.go-19th').addClass('show');
				$('.go-19th .btn-close').on('click', function() {
					flag = false;
					$('.go-19th').removeClass('show');
				});
				var listTop = $('.sortingbar').offset().top;
				$(window).on('scroll', function() {
					var st = $(window).scrollTop() + $(window).height() / 2;
					if (flag) {
						if (st > listTop) $('.go-19th').removeClass('show');
						else $('.go-19th').addClass('show');
					}
				});
			});
			</script>
			<div class="go-19th">
				<div class="inner">
					<span class="txt-1"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/brand/m/txt_01.png" alt="19주년"></span>
					<div class="ani">
						<span class="txt-2"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/brand/m/txt_02.png" alt="세일프렌드"></span>
						<span>최대 <b><%=Formatnumber(maxSalePercent,0)%>%</b></span>
					</div>
					<span>할인중!</span>
					<a href="/event/19th/" target="_blank" class="link">19주년 메인으로 이동</a>
					<button type="button" class="btn-close">배너 닫기</button>
				</div>
			</div>
		<% End If %>
		<%'<!-- //19주년 10월 정기세일 배너 --> %>

		<!-- for dev msg : 요기부터 -->
		<%'' for dev msg : 브랜드가 속한 대표카테고리별로 클래스 적용해주세요 (뒤의 숫자는 카테고리 코드) %>
		<% If oStreet.FOneItem.FBgImageURL = "" Then %>
			<%
			Select Case oStreet.FOneItem.FCatecode
				Case "101"		response.write "<div class='brandTitWrap ctgyBg01'>"
				Case "102"		response.write "<div class='brandTitWrap ctgyBg02'>"
				Case "103"		response.write "<div class='brandTitWrap ctgyBg03'>"
				Case "104"		response.write "<div class='brandTitWrap ctgyBg04'>"
				Case "114"		response.write "<div class='brandTitWrap ctgyBg14'>"
				Case "106"		response.write "<div class='brandTitWrap ctgyBg06'>"
				Case "112"		response.write "<div class='brandTitWrap ctgyBg12'>"
				Case "113"		response.write "<div class='brandTitWrap ctgyBg13'>"
				Case "115"		response.write "<div class='brandTitWrap ctgyBg15'>"
				Case "110"		response.write "<div class='brandTitWrap ctgyBg10'>"
				Case "111"		response.write "<div class='brandTitWrap ctgyBg11'>"
				Case "117"		response.write "<div class='brandTitWrap ctgyBg17'>"
				Case "116"		response.write "<div class='brandTitWrap ctgyBg16'>"
				Case "118"		response.write "<div class='brandTitWrap ctgyBg18'>"
				Case "121"		response.write "<div class='brandTitWrap ctgyBg21'>"	'/가구/조명
				Case "122"		response.write "<div class='brandTitWrap ctgyBg22'>"	'/데코/플라워
				Case "120"		response.write "<div class='brandTitWrap ctgyBg20'>"	'/패브릭/수납
				Case else 		response.write "<div class='brandTitWrap ctgyBg00'>"
			End Select
			%>
		<% elseIf oStreet.FOneItem.FBgImageURL <> "" Then %>
			<div class='brandTitWrap ctgyBg00'>
		<% else %>
			<div class='brandTitWrap ctgyBg00'>
		<% end if %>
			<div class="brandTitBox">
				<div class="brandTit">
					<div>
						<h2>
							<p><%=oStreet.FOneItem.Fsocname%></p>
							<span><%=oStreet.FOneItem.Fsocname_kor%></span>
						</h2>
						<span class="zzimBrView <%=chkIIF(isMyFavBrand,"myZzimBr","")%>">
							<a href="" onclick="TnMyBrandZZim(); return false;"><em><%=CurrFormat(oStreet.FOneItem.FRecommendcount)%></em></a>
						</span>
						<span class="zzimBrView brShare">
							<%
							if oStreet.FOneItem.FImageBasic<>"" and oStreet.FOneItem.fitemid<>"" then
								snsimg = getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic/" & GetImageSubFolderByItemid(oStreet.FOneItem.fitemid) & "/" & oStreet.FOneItem.FImageBasic,"300","200","true","false")
							else
								snsimg = oStreet.FOneItem.Fsoclogo
							end if
							%>
							<a href="" onClick="popSNSShare('<%=oStreet.FOneItem.Fsocname_kor%>','<%=wwwUrl&CurrURLQ()%>','10x10 브랜드','<%= snsimg %>'); return false;"><img src="http://fiximage.10x10.co.kr/m/2014/brand/ico_brand_share.png" alt="공유" /></a>
						</span>
					</div>
				</div>
			</div>
			<span class="bkMask"></span>
			<% if oStreet.FOneItem.FBgImageURL<>"" then %>
				<% ' for dev msg : 브랜드 이미지 없는 경우 아예 노출안되게 해주세요 / alt값 속성에는 브랜드 명 넣어주세요 %>
				<img src="<%=getThumbImgFromURL(staticImgUrl &"/brandstreet/hello/"&oStreet.FOneItem.FBgImageURL,"480","225","true","false")%>" alt="<%=oStreet.FOneItem.Fsocname%>" />
			<% end if %>
		</div>

		<% if oStreet.FOneItem.FDesignis<>"" then %>
			<% ' for dev msg : design is 내용이 없는 브랜드인경우 통째로 노출안되게 해주세요 %>
			<div class="brandMsg">
				<dl>
					<dt>Design is</dt>
					<dd><%= oStreet.FOneItem.FDesignis %></dd>
				</dl>
			</div>
		<% end if %>

		<%
		if isArray(vArrIssue) THEN
		
			For i = 0 To UBound(vArrIssue,2)
				veventcnt = veventcnt + 1
			Next
		%>
			<% ' for dev msg : 이벤트 없는경우 통째로 노출안되게 해주세요 %>
			<div class="evtnIsuWrap">
				<div class="evtnIsu box1">
					<h2><span>EVENT &amp; ISSUE</span> <em class="cRd1">(<%= veventcnt %>)</em></h2>
					<ul class="list01">
						<%
						For i = 0 To UBound(vArrIssue,2)
							IF vArrIssue(2,i)="I" and vArrIssue(3,i)<>"" THEN '링크타입 체크
								vLink = "location.href='" & vArrIssue(3,i) & "';"
							ELSE
								vLink = """ onClick=""TnGotoEventMain('" & vArrIssue(0,i) & "'); return false;"
							END IF
						%>							
							<li><a href="<%=vLink%>"><%=db2html(vArrIssue(1,i))%></a></li>
						<% Next %>
					</ul>
				</div>
			</div>
		<% End If %>

		<%
			'카테고리가 있을때만 표시
			if len(dispCate)>=3 then
		%>
			<!-- breadcrumbs -->
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
				'정렬상자 호출; sMakerid:브랜드ID, sDisp:전시카테고리, sCallback:콜백함수명 (via BrandStreetCls.asp)
				Call fnStreetDispCateNaviV17(makerid, dispCate,"goCategoryList")
			%>
			<div class="btn-group">
				<button type="button">전체 보기<span class="icon icon-arrow"></span></button>
			</div>
		</div>

		<form name="sFrm" id="listSFrm" method="get" action="street_brand.asp" style="margin:0px;">
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
		<input type="hidden" name="pNtr" value="<%=searchback_Param%>" />
		</form>
		
		<!-- 선택/입력된필터목록 -->
		<div id="filterList" class="filter-list">
			<div class="swiper-container">
				<ul class="swiper-wrapper list-roundbox" id="selectedfilter">
				</ul>
			</div>
		</div>

		
		<!-- 검색 결과 건수 및 정렬 옵션 셀렉트박스 -->
		<div class="sortingbar">
			<div class="option-left">
				<p class="total"><b><%= FormatNumber(vTotalCount,0) %></b>건</p>
			</div>
			<div class="option-right">
				<div class="styled-selectbox styled-selectbox-default">
					<select class="select" id="srm" name="srm" onChange="jsGoSort(this.value);" title="검색결과 리스트 정렬 선택옵션">
						<option value="ne" <%=CHKIIF(SortMet="ne","selected","")%>>신규순</option>
						<option value="bs" <%=CHKIIF(SortMet="bs","selected","")%>>판매량순</option>
						<option value="be" <%=CHKIIF(SortMet="be","selected","")%>>인기순</option>						
						<option value="ws" <%=CHKIIF(SortMet="ws","selected","")%>>위시등록순</option>
						<option value="hs" <%=CHKIIF(SortMet="hs","selected","")%>>할인율순</option>
						<option value="hp" <%=CHKIIF(SortMet="hp","selected","")%>>높은가격순</option>
						<option value="lp" <%=CHKIIF(SortMet="lp","selected","")%>>낮은가격순</option>
					</select>
				</div>
			</div>
		</div>

		<!-- 필터 버튼 -->
		<div class="fixed-bottom btn-floating btn-roundshadow-single">
			<a href="#searchFilter" id="filterbtn" class="btn-filter <%=CHKIIF(search_on="on","on","")%>" onclick="showLayer('searchFilter'); fnAmplitudeEventMultiPropertiesAction('click_brand_productlist_filter','brand_id|category_code|list_style|sort','<%=makerid%>|<%=vAmplitudeCategorycode%>|<%=CHKIIF(mode="L","list","tile")%>|<%=vAmplitudeSortMet%>'); return false;">필터</a>
		</div>

		<% If vTotalCount > 0 Then %>
			<!-- item list :격자형 (클래스명 : type-grid)-->
			<div class="items type-<%=CHKIIF(mode="L","list","grid")%>" id="itemWrapV17a">
				<ul id="lyrSrcpdtList">
					<%
					Dim rcParam
					For i=0 To oDoc.FResultCount-1
					'클릭 위치 Parameter 추가
					rcParam = "&rc=brand_" & fix((i)/2)+1 &"_" & ((i) mod 2)+1

					classStr = ""
					linkUrl = "/category/category_itemPrd.asp?itemid="& oDoc.FItemList(i).FItemID & "&dispCate=" & oDoc.FItemList(i).FCateCode & logparam & addparam & "&pBtr=" & makerid
					adultChkFlag = session("isAdult") <> true and oDoc.FItemList(i).FadultType = 1																	
					If oDoc.FItemList(i).FItemDiv="21" Then
						classStr = addClassStr(classStr,"deal-item")							
					end if
					if adultChkFlag then
						classStr = addClassStr(classStr,"adult-item")								
					end if																				
					%>
						<li class="<%=classStr%>" <%=chkIIF(adultChkFlag, "onclick=""confirmAdultAuth('"&linkUrl&"');""","")%>>
							<a href="/category/category_itemPrd.asp?itemid=<%= oDoc.FItemList(i).FItemID %>&dispCate=<%= oDoc.FItemList(i).FCateCode %><%=logparam%><%=addparam%>&pBtr=<%=makerid%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_brand_productlist_item','item_index|list_style|sort|category_code|brand_id','<%=i+1%>|<%=CHKIIF(mode="L","list","tile")%>|<%=vAmplitudeSortMet%>|<%=vAmplitudeCategorycode%>|<%=makerid%>');">
								<% If oDoc.FItemList(i).FItemDiv="21" Then %>
									<span class="deal-badge">텐텐<i>DEAL</i></span>
								<% End If %>
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
											Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oDoc.FItemList(i).getRealPrice,0) & "<span class=""won"">" & CHKIIF(oDoc.FItemList(i).IsMileShopitem," Point"," 원") & "</span></b></div>" &  vbCrLf
										End If
									%>
									</div>
								</div>
							</a>
							<div class="etc">								
								<div class="tag review"><span class="icon icon-rating"><i style="width:<%=fnEvalTotalPointAVG(oDoc.FItemList(i).FPoints,"search")%>%;"><%=fnEvalTotalPointAVG(oDoc.FItemList(i).FPoints,"search")%>점</i></span><span class="counting"><%=CHKIIF(oDoc.FItemList(i).FEvalCnt>999,"999+",oDoc.FItemList(i).FEvalCnt)%></span></div>
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
					<%
					Next
					%>
				</ul>
			</div>
		<% Else %>
			<div class="nodata nodata-brand">
				<p><b>해당되는 내용이 없습니다.</b></p>
				<p>품절 또는 종료된 경우에는 노출되지 않을 수 있습니다.</p>
			</div>
		<% end if %>
	</div>
	<!-- //contents -->

	<!-- filter for category -->
	<%
	Dim vSelectedFilter, vSelectedPreHtml
	vSelectedPreHtml = "<li class=swiper-slide><button type=button class=btn-del"
	%>
		<div id="mask" style="overflow:hidden; display:none; position:fixed; top:0; left:0; z-index:25; width:100%; height:100%; background:rgba(0, 0, 0, 0.5);"></div>
		<div id="searchFilter" class="search-filter fixed-bottom" style="display:none;">
			<div class="ly-header">
				<h2>필터</h2>
				<button type="reset" class="btn-reset" onClick="location.href='/street/street_brand.asp?mkr=<%=makerid%>';">초기화</button>
			</div>
			<div class="inner">
				<div class="ly-contents">
					<div class="scrollwrap">
						<!-- 빠른 이동 -->
						<div class="panel quickmove">
							<div class="hgroup">
								<h3>빠른이동</h3>
							</div>
							<div class="form">
								<fieldset>
								<legend class="hidden">결과 내 빠른이동</legend>
									<input type="hidden" id="maxfilterpage" value="<%=filterttpg%>" />
									<input type="number" id="filterpage" oninput="maxLengthCheck(this)" maxlength="4" title="페이지 넘버 입력" placeholder="<%= CurrPage %>" /> <span class="page-no"><span class="slash">/</span> <b><%= FormatNumber(filterttpg,0) %> </b>페이지</span>
									<button type="button" onclick="jsGoPage();" class="btn-submit">이동</button>
								</fieldset>
							</div>
						</div>
		
						<!-- 빠른 메뉴 -->
						<div class="panel quickmenu">
							<div class="hgroup">
								<h3>빠른메뉴</h3>
								<div class="option">
									<ul class="value">
										<li><button type="button" <%=CHKIIF(SellScope="N","class=""on""","")%> id="fastpum" onClick="jsFastOnOff('pum');">품절상품 포함</button></li>
										<li><button type="button" <%=CHKIIF(deliType="TN","class=""on""","")%> id="fasttendeli" onClick="jsDeliverySearch('TN');">텐바이텐 배송</button></li>
										<li><button type="button" <%=CHKIIF(SearchFlag="sc","class=""on""","")%> id="fastsale" onClick="jsFastOnOff('sale');">세일중인 상품</button></li>
										<li><button type="button" <%=CHKIIF(pojangok="o","class=""on""","")%> id="fastpojang" onClick="jsFastOnOff('pojang');">선물포장 가능</button></li>
									</ul>
								</div>
							</div>
						</div>
						<%
						If SellScope = "N" Then
							vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('pum');>품절상품 포함</button></li>"
						End If
						If deliType = "TN" Then
							vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('TN');>텐바이텐 배송</button></li>"
						End If
						If SearchFlag = "sc" Then
							vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('sale');>세일중인 상품</button></li>"
						End If
						If pojangok = "o" Then
							vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('pojang');>선물포장 가능</button></li>"
						End If
						%>
						<!-- 보기 옵션 -->
						<div class="panel viewoption">
							<div class="hgroup">
								<h3>보기 옵션</h3>
								<div class="option">
									<ul class="value">
										<li><button type="button" class="icon-list <%=CHKIIF(mode="L","on","")%>" onClick="jsViewoption('L');">리스트형</button></li>
										<li><button type="button" class="icon-grid <%=CHKIIF(mode="S","on","")%>" onClick="jsViewoption('S');">격자형</button></li>
									</ul>
								</div>
							</div>
						</div>
		
						<%
						Dim y, y1, y2, y3, vArrD1, vArrD2, vArrD3, vCa1, vTmp1, vCa2, vTmp2, vCa3, vTmp3, vDispTitle
						'//스타일 검색결과
						dim oGrStl, vStyleTitle, vStyleList, vTitleCnt
						vTitleCnt = 0
						set oGrStl = new SearchItemCls
						oGrStl.FRectSearchTxt = DocSearchText
						oGrStl.FRectSearchFlag = "n"
						oGrStl.FRectSearchItemDiv = SearchItemDiv
						oGrStl.FRectSearchCateDep = SearchCateDep
						oGrStl.FRectMakerid = fnCleanSearchValue(makerid)
						oGrStl.FCurrPage = 1
						oGrStl.FPageSize = 10
						oGrStl.FScrollCount =10
						oGrStl.FListDiv = ListDiv
						oGrStl.FSellScope="Y"			'판매/품절상품 포함 여부
						oGrStl.FLogsAccept = False
					
						oGrStl.FRectCateCode = dispCate
						oGrStl.FarrCate=arrCate

						oGrStl.getGroupbyStyleList
						If oGrStl.FResultCount>0 Then
						%>
							<div id="filterStyle" class="panel style">
								<div class="hgroup" onclick="jsFilterShow('Style');">
									<a href="#filterStyle">
										<h3>스타일</h3>
										<div class="option">
											<p class="value" id="filterstyletitle"></p>
										</div>
									</a>
								</div>
								<div class="panelcont">
									<ul class="depth1 multi-select" id="filterstylelist">
									<%
									FOR lp = 0 to oGrStl.FResultCount-1
										vStyleList = vStyleList & "<li><a href="""" id=""filterstyle"&lp&""" "
										If chkArrValue(styleCd,oGrStl.FItemList(lp).FStyleCd) Then
											vStyleList = vStyleList & " class=""on"" "
											vTitleCnt = vTitleCnt + 1
											If vTitleCnt = 1 Then
												vStyleTitle = getStyleKor(oGrStl.FItemList(lp).FStyleCd)
											End If
										End If
										vStyleList = vStyleList & "onclick=""jsSelectFilterSomething('style','filterstyle"&lp&"','"&oGrStl.FItemList(lp).FStyleCd&"','styleCd'); return false;"">" & getStyleKor(oGrStl.FItemList(lp).FStyleCd)
										vStyleList = vStyleList & "</a></li>"
									Next
									
									Response.Write vStyleList
									
									vStyleTitle = vStyleTitle & CHKIIF(vTitleCnt>1," 외 " & vTitleCnt-1 & "건","")
									%>
									</ul>
								</div>
							</div>
						<%
							'### 스타일 선택된거 타이틀과, 선택된항목버튼 셋팅
							If vStyleTitle <> "" Then
								vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('style');>" & vStyleTitle & "</button></li>"
								vStyleTitle = "$(""#filterstyletitle"").text(""" & vStyleTitle & """);"
							End If
						end if
						set oGrStl = nothing
			
						function getStyleKor(scd)
							dim arrSnm
							if isNumeric(scd) then
								if cInt(scd)>90 then 
									getStyleKor = "all"
									exit function
								end if
					            
					            ''2015/04/22 추가 //벌크작업시 오류 있을수 있음.
					            if cInt(scd)<10 then 
									getStyleKor = "all"
									exit function
								end if
								
								'컬러명 배열로 세팅 (코드순으로 나열)
								arrSnm = split("클래식,큐티,댄디,모던,내추럴,오리엔탈,팝,로맨틱,빈티지",",")
					
								'반환
								getStyleKor = arrSnm(cInt(scd)/10-1)
							else
								getStyleKor = "all"
							end if
						end function
			
						'// 컬러칩 //
						dim oGrClr, vColorList, vColorTitle, vExcludeColor
						vTitleCnt = 0
						vExcludeColor = " AND idx_colorCd!='023' AND idx_colorCd!='010' AND idx_colorCd!='021' AND idx_colorCd!='004' AND idx_colorCd!='024' AND idx_colorCd!='019' AND idx_colorCd!='006' "
						vExcludeColor = vExcludeColor & " AND idx_colorCd!='018' AND idx_colorCd!='017' AND idx_colorCd!='022' AND idx_colorCd!='014' AND idx_colorCd!='015' AND idx_colorCd!='015' AND idx_colorCd!='028' "
						vExcludeColor = vExcludeColor & " AND idx_colorCd!='029' AND idx_colorCd!='030' AND idx_colorCd!='031' "
						
						set oGrClr = new SearchItemCls
						oGrClr.FRectSearchTxt = SearchText
						oGrClr.FRectSearchFlag = "n"
						oGrClr.FRectSearchItemDiv = SearchItemDiv
						oGrClr.FRectSearchCateDep = SearchCateDep
						oGrClr.FRectColorExclude = vExcludeColor
						oGrClr.FRectMakerid = fnCleanSearchValue(makerid)
						oGrClr.FCurrPage = 1
						oGrClr.FPageSize = 31
						oGrClr.FScrollCount =10
						oGrClr.FListDiv = ListDiv
						oGrClr.FSellScope="Y"			'판매/품절상품 포함 여부
						oGrClr.FLogsAccept = False
					
						oGrClr.FRectCateCode = dispCate
						oGrClr.FarrCate=arrCate
					
						oGrClr.getTotalItemColorCount
						
						If oGrClr.FResultCount>0 Then
						%>
							<div id="filterColor" class="panel color">
								<div class="hgroup" onclick="jsFilterShow('Color');">
									<a href="#filterColor">
										<h3>컬러</h3>
										<div class="option">
											<p class="value" id="filtercolortitle"></p>
										</div>
									</a>
								</div>
								<div class="panelcont">
									<ul class="depth1 multi-select" id="filtercolorlist">
									<%
									FOR lp = 0 to oGrClr.FResultCount-1
										vColorList = vColorList & "<li class=""" & LCase(getColorEng(oGrClr.FItemList(lp).FcolorCode)) & """><a href="""" id=""filtercolor"&lp&""" "
										If chkArrValue(colorCD,oGrClr.FItemList(lp).FcolorCode) Then
											vColorList = vColorList & " class=""on"" "
											vTitleCnt = vTitleCnt + 1
											If vTitleCnt = 1 Then
												vColorTitle = getColorEng(oGrClr.FItemList(lp).FcolorCode)
											End If
										End If
										vColorList = vColorList & "onclick=""jsSelectFilterSomething('color','filtercolor"&lp&"','"&oGrClr.FItemList(lp).FcolorCode&"','iccd'); return false;"">" & getColorEng(oGrClr.FItemList(lp).FcolorCode)
										vColorList = vColorList & "</a></li>"
									Next
									
									Response.Write vColorList
									
									vColorTitle = vColorTitle & CHKIIF(vTitleCnt>1," 외 " & vTitleCnt-1 & "건","")
									%>
									</ul>
								</div>
							</div>
						<%
							'### 컬러 선택된거 타이틀과, 선택된항목버튼 셋팅
							If vColorTitle <> "" Then
								vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('color');>" & vColorTitle & "</button></li>"
								vColorTitle = "$(""#filtercolortitle"").text(""" & vColorTitle & """);"
							End If
						end if
			
						set oGrClr = Nothing
		
						function getColorEng(ccd)
							dim arrCnm
							if isNumeric(ccd) then
								if cInt(ccd)>31 then 
									getColorEng = "all"
									exit function
								end if
					
								'컬러명 배열로 세팅 (코드순으로 나열)
								arrCnm = split("Red,Orange,Yellow,Beige,Green,Skyblue,Blue,Violet,Pink,Brown,White,Grey,Black,Silver,Gold,Mint,Babypink,Lilac,Khaki,Navy,Camel,Charcoal,Wine,Ivory,Check,Stripe,Dot,Flower,Drawing,Animal,Geometric",",")
					
								'반환
								getColorEng = arrCnm(cInt(ccd)-1)
							else
								getColorEng = "all"
							end if
						end function
			
						Dim vDeliveryTitle
						SELECT CASE deliType
							Case "FD" : vDeliveryTitle = "무료배송"
							Case "TN" : vDeliveryTitle = "텐바이텐 배송"
							Case "FT" : vDeliveryTitle = "무료+텐바이텐 배송"
							Case "WD" : vDeliveryTitle = "해외배송"
							'// 해외직구배송작업추가
							Case "QT" : If showQuickDivStatus Then vDeliveryTitle = "바로배송" Else vDeliveryTitle = "" End If
							Case "DT" : vDeliveryTitle = "해외직구"
						END SELECT
						%>
							<!-- 배송방법 -->
							<div id="filterShipping" class="panel shipping">
								<div class="hgroup" onClick="jsFilterShow('Shipping');">
									<a href="#filterShipping">
										<h3>배송방법</h3>
										<div class="option">
											<p class="value" id="deliverytitle"><%=vDeliveryTitle%></p>
										</div>
									</a>
								</div>
								<div class="panelcont">
									<ul class="depth1 one-select" id="filterdeliverylist">
										<li><a href="" <%=CHKIIF(deliType="FD","class=""on""","")%> id="deli_FD" onClick="jsDeliverySearch('FD','무료배송'); return false;">무료배송</a></li>
										<li><a href="" <%=CHKIIF(deliType="TN","class=""on""","")%> id="deli_TN" onClick="jsDeliverySearch('TN','텐바이텐 배송'); return false;">텐바이텐 배송</a></li>
										<li><a href="" <%=CHKIIF(deliType="FT","class=""on""","")%> id="deli_FT" onClick="jsDeliverySearch('FT','무료+텐바이텐 배송'); return false;">무료+텐바이텐 배송</a></li>
										<% '// 해외직구배송작업추가 %>
										<% If showQuickDivStatus Then %>
											<li><a href="" <%=CHKIIF(deliType="QT","class=""on""","")%> id="deli_QT" onClick="jsDeliverySearch('QT','바로배송'); return false;">바로배송</a></li>
										<% End If %>
										<li><a href="" <%=CHKIIF(deliType="DT","class=""on""","")%> id="deli_DT" onClick="jsDeliverySearch('DT','해외직구'); return false;">해외직구</a></li>
										<li><a href="" <%=CHKIIF(deliType="WD","class=""on""","")%> id="deli_WD" onClick="jsDeliverySearch('WD','해외배송'); return false;">해외배송</a></li>
									</ul>
								</div>
							</div>
						<%
						If deliType = "FD" Then
							vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('FD');>무료배송</button></li>"
						End If
						If deliType = "FT" Then
							vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('FT');>무료+텐바이텐 배송</button></li>"
						End If
						If deliType = "WD" Then
							vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('WD');>해외배송</button></li>"
						End If
						'// 해외직구배송작업추가
						If deliType = "QT" Then
							If showQuickDivStatus Then
								vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('QT');>바로배송</button></li>"
							End If 
						End If
						If deliType = "DT" Then
							vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('DT');>해외직구</button></li>"
						End If

						'// 가격범위 표시 //
						dim oGrPrc, vMinPrice, vMaxPrice, vMinRange, vMaxRange
						set oGrPrc = new SearchItemCls
						oGrPrc.FRectSearchTxt = SearchText
						oGrPrc.FRectMakerid = fnCleanSearchValue(makerid)
						oGrPrc.FRectSearchItemDiv = SearchItemDiv
						oGrPrc.FRectSearchCateDep = SearchCateDep
						oGrPrc.FCurrPage = 1
						oGrPrc.FPageSize = 1
						oGrPrc.FScrollCount =10
						oGrPrc.FListDiv = ListDiv
						oGrPrc.FSellScope="Y"			'판매/품절상품 포함 여부
						oGrPrc.FLogsAccept = False
						oGrPrc.FRectCateCode = dispCate
						oGrPrc.FarrCate=arrCate
						oGrPrc.getItemPriceRange
						
						If oGrPrc.FResultCount>0 Then
							vMinPrice = chkIIF(minPrice>0,minPrice,oGrPrc.FItemList(0).FminPrice)
							vMaxPrice = chkIIF(maxPrice>0,maxPrice,oGrPrc.FItemList(0).FmaxPrice)
							vMinRange = oGrPrc.FItemList(0).FminPrice
							vMaxRange = oGrPrc.FItemList(0).FmaxPrice
						Else
							vMinPrice = 10000
							vMaxPrice = 300000
							vMinRange = 10000
							vMaxRange = 300000
						End If
						
						set oGrPrc = Nothing
						%>
							<!-- 가격대 -->
							<div class="panel price">
								<div class="hgroup">
									<h3>가격대</h3>
								</div>
								<div class="form">
									<fieldset>
									<legend class="hidden">가격대 검색</legend>
										<div class="textfield">
											<span class="itext"><input type="text" title="최소 가격" id="minprice" value="<%=FormatNumber(vMinPrice,0)%>" onClick="jsPriceComma('up','min');" onFocusOut="jsPriceComma('down','min');" autocomplete="off" /><button type="reset" class="btn-reset">리셋</button></span>
											<span>~</span>
											<span class="itext"><input type="text" title="최대 가격" id="maxprice" value="<%=FormatNumber(vMaxPrice,0)%>" onClick="jsPriceComma('up','max');" onFocusOut="jsPriceComma('down','max');" autocomplete="off" /><button type="reset" class="btn-reset">리셋</button></span>
										</div>
										<button type="button" class="btn-submit" onClick="jsPriceSearch();">입력</button>
									</fieldset>
									<input type="hidden" id="minpricehidden" value="<%=FormatNumber(vMinPrice,0)%>">
									<input type="hidden" id="maxpricehidden" value="<%=FormatNumber(vMaxPrice,0)%>">
								</div>
							</div>
	
							<!-- 결과 내 검색 -->
							<div class="panel searching">
								<div class="hgroup">
									<h3>결과 내 검색</h3>
								</div>
								<div class="form">
									<fieldset>
									<legend class="hidden">결과 내 검색</legend>
										<input type="search" name="sMtxt" id="sMtxt" maxlength="50" value="<%=ReSearchText%>" placeholder="검색어를 입력해주세요" />
										<button type="button" class="btn-submit" onClick="jsResearchTxt();">입력</button>
									</fieldset>
								</div>
							</div>
						<%
							If ReSearchText <> "" Then
								vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('researchtxt');>" & ReSearchText & "</button></li>"
							End If
						%>
					</div>
				</div>
			</div>
			<div class="ly-footer">
				<button type="button" class="btn-close"><b id="resulttotalcount"><%=FormatNumber(vTotalCount,0)%></b>건의 결과보기</button>
			</div>
			<button type="button" class="btn-close-down" onClick="jsSearchLayerClose('searchFilter');">닫기</button>
		</div>
		<div id="mask" style="overflow:hidden; display:none; position:fixed; top:0; left:0; z-index:10; width:100%; height:100%; background:rgba(0, 0, 0, 0.5);"></div>
		<div id="lyLoading" style="display:none;position:relative;text-align:center; padding:20px 0;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
	<!-- #include virtual="/lib/inc/incfooter.asp" -->
<form method="post" name="jjimfrm" style="margin:0px;" target="ifrm">
	<input type="hidden" name="makerid" value="<%=makerid%>">
</form>
<iframe name="ifrm" frameborder="0" width="0" height="0"></iframe>
</body>
<script>
$("#selectedfilter").html("<%=vSelectedFilter%>");

if($("#selectedfilter").html() == ""){
	$("#filterbtn").removeClass("on");
}
</script>
</html>
<%
	Set oStreet = nothing
	Set oDoc = nothing
%>
<!-- #INCLUDE Virtual="/lib/db/dbclose.asp" -->