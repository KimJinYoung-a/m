<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->
<!-- #include virtual="/lib/classes/item/sp_evaluatesearchercls.asp" -->
<!-- #include virtual="/lib/classes/item/sp_item_qnacls.asp" -->
<!-- #include virtual="/lib/classes/item/dealCls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_itemcouponcls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/diarystory/diary_class.asp" -->
<!-- #include virtual="/lib/classes/award/newawardcls.asp" -->
<!-- #include virtual="/lib/classes/gift/gifttalkCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/apps/appcom/wish/wishCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<%
	dim itemid	: itemid = requestCheckVar(request("itemid"),9)
	Dim page, vDisp, cpid, vDepth, vMakerid
	Dim DealCouponYn, DealItemEvalTotalCNT, DealItemQnaTotalCNT, DealBrandCheck, DealBrandName

	DealItemEvalTotalCNT=0
	DealItemQnaTotalCNT=0
	DealCouponYn="N"
	DealBrandCheck="Y"
	DealBrandName=""
	if page="" then page=1

	if itemid="" or itemid="0" then
		Call Alert_Return("상품번호가 없습니다.")
		response.End
	elseif Not(isNumeric(itemid)) then
		Call Alert_Return("잘못된 상품번호입니다.")
		response.End
	else
		'정수형태로 변환
		itemid=CLng(getNumeric(itemid))
	end if

	dim LoginUserid
	LoginUserid = getLoginUserid()

	dim flag : flag = request("flag")

	'// 에코마케팅용 레코벨 스크립트 용(2016.12.21) 
	Dim vPrtr
	vPrtr = requestCheckVar(request("pRtr"),200)

	dim oItem, ItemContent
	set oItem = new CatePrdCls
	oItem.GetItemData itemid

	'=============================== 딜 추가 정보 ==========================================
	Dim oDeal, ArrDealItem
	Set oDeal = New DealCls
	oDeal.GetIDealInfo itemid
	If oDeal.Prd.FDealCode="" Then
		Response.write "<script>alert('딜 상품 정보가 부족합니다.');history.back();</script>"
		Response.End
	End If
	ArrDealItem=oDeal.GetDealItemList(oDeal.Prd.FDealCode)

	If isArray(ArrDealItem) Then
	Else
		Call Alert_Return("존재하지 않는 상품입니다.")
		response.End
	End If

	'//	한정 여부 (표시여부와 상관없는 실제 상품 한정여부)
	Function IsLimitItemReal(ByVal LimitYn)
			IsLimitItemReal= (LimitYn="Y")
	end Function

	Function ZeroTime(hs)
		If hs<10 Then
			ZeroTime="0"+hs
		Else
			ZeroTime=hs
		End If
	End Function

	'//일시품절 여부 '2008/07/07 추가 '!
	Function isTempSoldOut(ByVal SellYn)
		isTempSoldOut = (SellYn="S")
	End Function

	Function IsSoldOut(ByVal SellYn, ByVal LimitNo, ByVal LimitSold, ByVal LimitYn)
		IF LimitNo<>"" and LimitSold<>"" Then
			isSoldOut = (SellYn<>"Y") or ((LimitYn = "Y") and (clng(LimitNo)-clng(LimitSold)<1))
		Else
			isSoldOut = (SellYn<>"Y")
		End If
	End Function
	Dim intLoop

	if oDeal.Prd.FMasterItemCode="" Or oDeal.Prd.FMasterItemCode=0 Or isnull(oDeal.Prd.FMasterItemCode) then
		Call Alert_Return("존재하지 않는 상품입니다.")
		response.End
	end if

	if oItem.Prd.Fisusing="N" Then
		if GetLoginUserLevel()=7 then
			'STAFF는 종료상품도 표시
			Response.Write "<script>alert('판매가 종료되었거나 삭제된 상품입니다.');</script>"
		else
			'// 수정 2017-03-09 이종화 - 종료 상품일시 - page redirect
			'Call Alert_Return("판매가 종료되었거나 삭제된 상품입니다.")
			'response.End
			Response.redirect("/category/closedprd.asp?"&request.servervariables("QUERY_STRING"))
		end if
	end if

	'// 파라메터 접수
	vDisp = requestCheckVar(getNumeric(Request("disp")),18)
	if vDisp="" or (len(vDisp) mod 3)<>0 then vDisp = oItem.Prd.FcateCode

	'// 브랜드ID 접수
	vMakerid = oItem.Prd.Fmakerid

	'### 현재 위치 ###
	Dim vCateNavi, vCateItemCount, vIsLastDepth, vCateCnt
	vIsLastDepth = true		'최하단 여부
	vCateNavi = printCategoryHistorymultiApp(vDisp,vIsLastDepth,false,vCateCnt)

	'// 추가 이미지
	dim oADD
	set oADD = new CatePrdCls
	oADD.getAddImage oDeal.Prd.FMasterItemCode

	'//상품 후기
	dim oEval,i,j,ix
	set oEval = new CEvaluateSearcher
	oEval.FPageSize = 8
	oEval.FScrollCount = 5
	oEval.FCurrpage = page
	oEval.FRectItemID = itemid

		'상품 후기가 있을때만 쿼리.
		if oItem.Prd.FEvalCnt>0 and cFlgDBUse then
			oEval.getItemEvalList
		end if

	'//상품 문의
	Dim oQna
	set oQna = new CItemQna

	''스페셜 브랜드일경우 상품 문의 불러오기
	If (oItem.Prd.IsSpecialBrand and oItem.Prd.FQnaCnt>0 and cFlgDBUse) Then
		oQna.FRectItemID = itemid
		oQna.FPageSize = 5
		oQna.ItemQnaList
	End If

	'// Present상품
	Dim IsPresentItem
	'// 공유 제한 상품 (프리젠트 상품 또는 특수한 브랜드)
	Dim isSpCtlIem
	isSpCtlIem = (IsPresentItem or oItem.Prd.FMakerid="10x10present")

	'2015 APP전용 상품 안내
	if IsPresentItem or oItem.Prd.FOrgMakerid="10x10present" or itemid=1250336 then
		Call Alert_Move("본 상품은 텐바이텐 APP에서만 보실 수 있습니다.","/")
		dbget.Close: Response.End
	end if

	'// 현장수령 상품
	Dim IsReceiveSiteItem
	IsReceiveSiteItem = (oItem.Prd.FDeliverytype="6")

	'=============================== 이메일특가 번호 접수 및 특가 계산 (base64사용) =================================
	cpid = requestCheckVar(request("ldv"),12)
	'2017-09-18 김진영 추가
	Dim RequestRdsite
	If requestCheckVar(request("rdsite"),32) <> "" Then
		RequestRdsite = requestCheckVar(request("rdsite"),32)
	End If
	''''''''''''''''''''''''

	if Not(cpid="" or isNull(cpid)) then
		cpid = trim(Base64decode(cpid))
		if isNumeric(cpid) then
			oItem.getTargetCoupon cpid, itemid
		end if
	ElseIf (Left(request.Cookies("rdsite"), 13) = "mobile_nvshop") OR (LEFT(RequestRdsite, 13) = "mobile_nvshop") Then
		Dim naverSpecialcpID
		if (application("Svr_Info")<>"Dev") then
			naverSpecialcpID = 12785
		Else
			naverSpecialcpID = 11151
		End If

		if isNumeric(naverSpecialcpID) then
			oItem.getTargetCoupon naverSpecialcpID, itemid
		end if
	end if

	'//옵션 HTML생성
	dim ioptionBoxHtml
	IF (oitem.Prd.FOptionCnt>0) then
		if (IsReceiveSiteItem) or (oItem.Prd.Flimitdispyn="N") then
			ioptionBoxHtml = GetOptionBoxDpLimit2017(itemid, oitem.Prd.IsSoldOut,Not(IsReceiveSiteItem) and Not(IsPresentItem and oItem.Prd.FRemainCount>200) and Not(oItem.Prd.Flimitdispyn="N"))
		else
		    ioptionBoxHtml = GetOptionBox2017(itemid, oitem.Prd.IsSoldOut)
		end if
	End IF

	function ImageExists(byval iimg)
		if (IsNull(iimg)) or (trim(iimg)="") or (Right(trim(iimg),1)="\") or (Right(trim(iimg),1)="/") then
			ImageExists = false
		else
			ImageExists = true
		end if
	end function

	'// 추가 이미지-메인 이미지
	Function getFirstAddimage()
		if ImageExists(oitem.Prd.FImageBasic) then
			getFirstAddimage= oitem.Prd.FImageBasic
		elseif ImageExists(oitem.Prd.FImageMask) then
			getFirstAddimage= oitem.Prd.FImageMask
		elseif (oAdd.FResultCount>0) then
			if ImageExists(oAdd.FADD(0).FAddimage) then
				getFirstAddimage= oAdd.FADD(0).FAddimage
			end if
		else
			getFirstAddimage= oitem.Prd.FImageMain
		end if
	end Function

	'2013 다이어리 상품 체크 유무
	Dim clsDiaryPrdCheck, GiftSu
	set clsDiaryPrdCheck = new cdiary_list
		clsDiaryPrdCheck.FItemID = itemid
		clsDiaryPrdCheck.DiaryStoryProdCheck
		If clsDiaryPrdCheck.FResultCount  > 0 then
			GiftSu = clsDiaryPrdCheck.getGiftDiaryExists(itemid)	'다이어리 상은품 남은수량
		end If

	'//상품설명 추가
	dim addEx
	set addEx = new CatePrdCls
		addEx.getItemAddExplain itemid

	Dim tempsource , tempsize

	tempsource = oItem.Prd.FItemSource
	tempsize = oItem.Prd.FItemSize

	'//내 위시 상품 여부
	dim isMyFavItem: isMyFavItem=false
	if IsUserLoginOK then
		isMyFavItem = getIsMyFavItem(LoginUserid, oDeal.Prd.FMasterItemCode)
	end if

	'대표상품 위시 카운트 가져오기
	Dim ofavItem
	set ofavItem = new CatePrdCls
	ofavItem.GetItemData oDeal.Prd.FMasterItemCode

	'### 쇼핑톡 카운트.
	Dim cTalk, vTalkCount, vTIItemID1, vTIItemName1, vTIItemID2, vTIItemName2, vTICount
	SET cTalk = New CGiftTalk
	cTalk.FPageSize = 5
	cTalk.FCurrpage = 1
	cTalk.FRectItemId = itemid
	cTalk.FRectUseYN = "y"
	cTalk.FRectOnlyCount = "o"
	''cTalk.sbGiftTalkList
	''vTalkCount = cTalk.FTotalCount ''않쓰임? //부하 많음.
	vTICount = 0

	If IsUserLoginOK and cFlgDBUse Then
		cTalk.FPageSize = 2
		cTalk.FRectUserId = GetLoginUserID()
		cTalk.fnGiftTalkMyItemList
		vTICount = cTalk.FTotalCount
		If vTICount > 0 Then
			vTIItemID1		= cTalk.FItemList(0).FItemID
			vTIItemName1	= cTalk.FItemList(0).FItemName
		End If
		If vTICount > 1 Then
			vTIItemID2		= cTalk.FItemList(1).FItemID
			vTIItemName2	= "B. " & cTalk.FItemList(1).FItemName
			vTIItemID1		= cTalk.FItemList(0).FItemID
			vTIItemName1	= "A. " & cTalk.FItemList(0).FItemName
		End If
	End If
	SET cTalk = Nothing

'// 상품 쿠폰 내용  '!
	Function GetCouponDiscount(itemcoupontype, itemcouponvalue)

		Select Case itemcoupontype
			Case "1"
				GetCouponDiscount =CStr(itemcouponvalue) + "%"
			Case "2"
				GetCouponDiscount = formatNumber(itemcouponvalue,0) + "원 할인"
			Case "3"
				GetCouponDiscount ="무료배송"
			Case Else
				GetCouponDiscount = itemcoupontype
		End Select

	End Function

	'// 상품 가격 계산
	Function GetDealCouponPrice(sellcash, itemcouponvalue, itemcoupontype)
		Dim tmp
		Select case itemcoupontype
			case "1" ''% 쿠폰
				tmp = CLng(itemcouponvalue*sellcash/100)
			case "2" ''원 쿠폰
				tmp = itemcouponvalue
			case "3" ''무료배송 쿠폰
				tmp = 0
			case else
				tmp = 0
		end Select
		GetDealCouponPrice = sellcash - tmp
	End Function

	'// 상품상세 로그 사용여부(2017.01.12)
	Dim LogUsingCustomChk
	If LoginUserId="thensi7" Then
		LogUsingCustomChk = True
	Else
		LogUsingCustomChk = True
	End If

	'// 상품상세 로그저장(2017.01.11 원승현)
	If LogUsingCustomChk Then
		If IsUserLoginOK() Then
			'// 검색을 통해서 들어왔을경우
			If Trim(vPrtr)<>"" Then
				Call fnUserLogCheck("itemrect", LoginUserid, itemid, "", Trim(vPrtr), "mw")
			Else
				Call fnUserLogCheck("item", LoginUserid, itemid, "", "", "mw")
			End If
		End If
	End If

	'// 구글 ADS 스크립트 관련(2018.09.21 신규버전 추가)
	googleADSCRIPT = " <script> "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "   gtag('event', 'page_view', { "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "     'send_to': 'AW-851282978', "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "     'ecomm_pagetype': 'product', "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "     'ecomm_prodid': '"&itemid&"', "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "     'ecomm_totalvalue': "&oItem.Prd.FSellCash&" "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "   }); "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & " </script> "

	'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
	dim snpTitle, snpLink, snpPre, snpImg, snpTag, snpTag2
	snpTitle = oItem.Prd.FItemName
	snpLink = "http://m.10x10.co.kr/deal/deal.asp?itemid=" & itemid
	snpPre = "텐바이텐 HOT ITEM!"
	snpImg = oItem.Prd.FImageBasic
	snpTag = "#10x10"

	'// 비회원일경우 회원가입 이후 페이지 이동을 위해 현재 페이지 주소를 쿠키에 저장해놓는다.
	If Not(IsUserLoginOK) Then
		response.cookies("sToMUA") = tenEnc(replace(Request.ServerVariables("url")&"?"&Request.ServerVariables("QUERY_STRING"),"index.asp",""))
		Response.Cookies("sToMUA").expires = dateadd("d",1,now())
	End If
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<link rel="canonical" href="http://m.10x10.co.kr/deal/deal.asp?itemid=<%= itemid %>" />
<title>10x10: <%= oItem.Prd.FItemName %></title>
<script type="application/x-javascript" src="/apps/appCom/wish/web2014/deal/itemPrdDetail.js?v=1.1"></script>
<script type="application/x-javascript" src="/lib/js/jquery.numspinner_m.js"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<style>
.lyDropdown2 .btnClose,
.lyDropdown2 .btnClose:after,
.lyDropdown2 {display:none; position:fixed; bottom:0; left:0; z-index:100010; width:100%; height:32.25rem; padding:1.25rem 1.25rem 0; border-top:1px solid #dcdcdc; background-color:#f9f9f9;}
.lyDropdown2 .btnClose {position:absolute; top:-1.88rem; left:50%; width:5.29rem; height:1.88rem; border:0; border-radius:0; margin-left:-2.65rem; background-color:transparent; background-position:0 -29.38rem; text-indent:-999em;}
.lyDropdown2 .btnDrop {padding:0.1rem 2rem 0.2rem 0.6rem; border-color:#ff3131; border-bottom:0;}
.lyDropdown2 .btnDrop.on {border-bottom:1px solid #efefef; background-color:#fff; color:rgba(13, 13, 13, 0.5);}
.lyDropdown2 .btnDrop:after {right:0.85rem; margin-top:-0.26rem; border-width:0.51rem 0.38rem 0 0.38rem; border-color:#ff3131 transparent transparent transparent;}
.lyDropdown2 .swiper-container {z-index:5; height:29rem; margin-top:-1px; border:1px solid #ff3131; border-top:0; border-bottom:0; background-color:#fff;}
.lyDropdown2 .swiper-container .swiper-slide {width:100%; height:auto;}
.lyDropdown2 .swiper-container-vertical > .swiper-scrollbar {width:2px;}
.lyDropdown2 .dropDown {background-color:#fff;}
.lyDropdown2 .dropBox li {padding:0.7rem 0.6rem; color:#0d0d0d; cursor:pointer;}
.lyDropdown2 .dropBox .soldout .option {padding:0;}
.lyDropdown2 .dropBox.multi .soldout .option {padding-right:35.5%;}
.disableClick {pointer-events: none;}

/* iphoneX */
@media only screen and (device-width : 375px) and (device-height : 812px) and (-webkit-device-pixel-ratio : 3) {
	.lyDropdown2 .swiper-container {padding-bottom:2.56rem;}
}
</style>
<script type="text/javascript">
<!--

// SNS 공유 팝업
function fnAPPRCVpopSNS(){
	//fnAPPpopupBrowserURL("공유","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popShare.asp?sTit=<%=snpTitle%>&sLnk=<%=snpLink%>&sPre=<%=snpPre%>&sImg=<%=snpImg%>");
	$("#lySns").show();
	$("#lySns .inner").removeClass("lySlideDown").addClass("lySlideUp");
	return false;
}
$(function() {
	/* breadcrumbs */
	var breadcrumbsSwiper = new Swiper("#breadcrumbs .swiper-container",{
		freeMode:true,
		slidesPerView:"auto"
	});

	//창 타이틀 변경
	setTimeout(function(){
		fnAPPchangPopCaption("상품정보");
	}, 100);

	/* item swiper */
	if ($("#itemSwiper .swiper-container .swiper-slide").length > 1) {
		var rollingSwiper = new Swiper("#itemSwiper .swiper-container", {
			loop:true,
			speed:1000,
			autoplay: 2000,
			onSlideChangeStart: function (rollingSwiper) {
				var vActIdx = parseInt(rollingSwiper.activeIndex);
				if (vActIdx<=0) {
					vActIdx = rollingSwiper.slides.length-2;
				} else if(vActIdx>(rollingSwiper.slides.length-2)) {
					vActIdx = 1;
				}
				$(".pagination-no b").text(vActIdx);
			}
		});
		$(".pagination-no").show();
		$(".pagination-no b").text(1);
		$(".pagination-no span").text(rollingSwiper.slides.length-2);
	}

	/* coupon layer popup swipe */
	lyCouponScroll = new Swiper('#lyCoupon .swiper-container', {
		scrollbar:'#lyCoupon .swiper-scrollbar',
		direction:'vertical',
		slidesPerView:'auto',
		mousewheelControl:true,
		freeMode:true,
		resistanceRatio:0
	});

	/* coupon download layer */
	checkHeight();
	function checkHeight() {
		var boxHeight = $("#lyCoupon").height();
		$("#lyCoupon").css({"height":boxHeight, margin:"-"+($("#lyCoupon").height() / 2) + "px 0 0 -12.97rem"});
	}
	$(window).resize(function() {
		checkHeight();
	});

	/* dropdown */
	$(".dropdwon-box .btnDrop:not(.review)").on("click", function(e){
		e.stopPropagation();
		$(".btnDrop:not(.review) + .dropBox:not(.reviewBox)").hide();
		$(this).next().show();
		$(this).toggleClass("on");
		$(this).next().toggleClass("on");
		return false;
	});
	$(".dropdwon-box .dropBox:not(.reviewBox) ul li a").on("click", function(e){
		$(this).parent().parent().parent().prev(".btnDrop:not(.review)").removeClass("on")
		$(this).parent().parent().parent().removeClass("on").prev(".btnDrop:not(.review)").text($(this).text());
		return false;
	});
	$(document).on("click", function(e){
		$(".dropdwon-box .dropBox:not(.reviewBox) + .dropBox:not(.reviewBox)").hide();
		$(".dropdwon-box .btnDrop:not(.review)").removeClass("on");
		$(".dropdwon-box .dropBox:not(.reviewBox)").removeClass("on");
	});

	// floating area swipe
	floatScroll = new Swiper('.itemOptV16a .swiper-container', {
		scrollbar:'.itemOptV16a .swiper-scrollbar',
		direction:'vertical',
		slidesPerView:'auto',
		mousewheelControl:true,
		freeMode:true,
		resistanceRatio:0
	});

	// floating area height calculate
	function hCalc() {
		var optH = $('.itemOptV16a').outerHeight();
		$('.itemOptV16a').css('height',optH+'px');
	}

	// floating area control
	$('.controller, .actBuy').click(function(){
		if($('.itemFloatingV16a').hasClass('opening16a')){
			$('.itemFloatingV16a').removeClass('opening16a');
			$('.actBuy').css('display','table-cell');
			$('.actCart, .actNow').hide();
		} else {
			$('.itemFloatingV16a').addClass('opening16a');
			hCalc();
			$('.actBuy').hide();
			$('.actCart, .actNow').css('display','table-cell');
		}
		floatScroll.update();
	});

	// navi - hide show
	$("#breadcrumbs").hide();
	$(window).scroll(function() {
		var window_top = $(window).scrollTop();
		var div_top = $(".itemDeatilV16a").offset().top;
		var div_nav = $("#breadcrumbs").offset().top;

		if (window_top >= div_top) {
			$(".commonTabV16a").addClass('sticky');
		} else {
			$(".commonTabV16a").removeClass('sticky');
		}

		if (window_top <= div_nav) {
			$("#breadcrumbs").show();
		}
	});

	/* product detail tab control */
	$(".itemDeatilV16a .itemDetailContV16a > div:first").show();
	$('.itemDeatilV16a .commonTabV16a li').click(function(){
		$(".itemDeatilV16a .itemDetailContV16a > div").hide();
		$('.itemDeatilV16a .commonTabV16a li').removeClass('current');
		$(this).addClass('current');
		var tabView = $(this).attr('name');
		$(".itemDeatilV16a .itemDetailContV16a div[id|='"+ tabView +"']").show();
		$('html, body').animate({scrollTop: $(".itemDeatilV16a").offset().top}, 500);
	});

	$(".qnaListV16a li .a").hide();
	$(".qnaListV16a li").each(function(){
		if ($(this).children(".a").length > 0) {
			$(this).children('.q').addClass("hasA");
		}
	});

	$(".qnaListV16a li .q").click(function(){
		$(".qnaListV16a li .a").hide();
		if($(this).next().is(":hidden")){
			$(this).parent().children('.a').show();
		}else{
			$(this).parent().children('.a').hide();
		};
	});

	$('.pdtDetailListV16a li').find('dd').hide();
	$('.pdtDetailListV16a li:first-child').find('dd').show();
	$('.pdtDetailListV16a li:first-child').find('dt').addClass('selected');
	$('.pdtDetailListV16a li .accordTab > dt').click(function(){
		$('.pdtDetailListV16a li .accordTab > dd:visible').hide();
		$('.pdtDetailListV16a li .accordTab > dt').removeClass('selected');
		$(this).parents("dl").parents("li").find('dd').show();
		$(this).addClass('selected');
	});

	/* layer popup for dropdown */
	$.fn.layerOpen = function(options) {
		return this.each(function() {
			var $this = $(this);
			var $layer = $($this.attr("href") || null);
			$this.click(function() {
				$layer.attr("tabindex",0).show().focus();
				//lyCouponScroll.update();
				$layer.find(".btnClose, .btn-close, .btnDrop").one("click",function () {
					$layer.hide();
					$this.focus();
					$("#mask").hide();
				});
				if ($this.attr("href") == "#lyCoupon"){
					lyCouponScroll.update();
					$("#mask").show();
				} else if ($this.attr("href") == "#lyDropdown") {
					$('#opbtn').removeClass("on");
					$('#itembtn').addClass("on");
					dropdownScrollLayer.update();
				} else if ($this.attr("href") == "#lyDropdownOpt") {
					$('#itembtn').removeClass("on");
					$('#opbtn').addClass("on");
					dropdownScrollLayer2.update();
				}
			});
		});
	}
	$(".layer").layerOpen();
	$('#opbtn').hide();

	/* swipe scroll for dropdown layer */
	var dropdownScrollLayer = new Swiper('.lyDropdown .swiper-container', {
		scrollbar:'.lyDropdown .swiper-scrollbar',
		direction:'vertical',
		slidesPerView:'auto',
		mousewheelControl:true,
		freeMode:true
	});
	/* swipe scroll for dropdown layer */
	var dropdownScrollLayer2 = new Swiper('.lyDropdown2 .swiper-container', {
		scrollbar:'.lyDropdown2 .swiper-scrollbar',
		direction:'vertical',
		slidesPerView:'auto',
		mousewheelControl:true,
		freeMode:true
	});

});
//-->
</script>

<% IF application("Svr_Info") = "Dev" THEN %>
<script src="/vue/vue_dev.js"></script>
<% Else %>
<script src="/vue/2.5/vue.min.js"></script>
<% End If %>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>
</head>
<body class="default-font body-sub bg-grey deal-item">
	<!-- contents -->
	<div id="content" class="content">
		<% If vDisp <> "111" and vDisp<>"0" Then %> 
		<div id="breadcrumbs" class="breadcrumbs">
			<div class="swiper-container">
				<ol class="swiper-wrapper"><%= vCateNavi %></ol>
			</div>
		</div>
		<% End If %>
		<%If oItem.Prd.FAdultType <> 0 then%>
			<div class="alert-text adult-text">
				<div class="inner">
					<p>관계법령에 따라 미성년자는 구매할 수 없으며, 성인인증을 하셔야 구매 가능한 상품입니다.</p>
				</div>
			</div>
		<%End IF%>

		<!-- item rolling -->
		<div id="itemSwiper" class="item-detail-swiper">
			<span class="deal-badge">텐텐<i>DEAL</i></span>
			<div class="swiper-container">
				<div class="swiper-wrapper">
				<%
					'//기본 이미지
					Response.Write "<div class=""swiper-slide""><img src=""" & getThumbImgFromURL(oItem.Prd.FImageBasic,400,400,"true","false") & """ alt=""" & replace(oItem.Prd.FItemName,"""","") & """ style=""width:100%;"" /></div>"
					'//누끼 이미지
					if Not(isNull(oItem.Prd.FImageMask) or oItem.Prd.FImageMask="") then
						Response.Write "<div class=""swiper-slide""><img src=""" & getThumbImgFromURL(oItem.Prd.FImageMask,400,400,"true","false") & """ alt=""" & replace(oItem.Prd.FItemName,"""","") & """ style=""width:100%;"" /></div>"
					end If
					'//추가 이미지
					IF oAdd.FResultCount > 0 THEN
						FOR i= 0 to oAdd.FResultCount-1
							'If i >= 3 Then Exit For
							IF oAdd.FADD(i).FAddImageType=0 THEN
								Response.Write "<div class=""swiper-slide""><img src=""" & getThumbImgFromURL(oAdd.FADD(i).FAddimage,400,400,"true","false") & """ alt=""" & replace(oItem.Prd.FItemName,"""","") & """ style=""width:100%;"" /></div>"
							End IF
						NEXT
					END If

					'// 텐바이텐 기본이미지 추가(이미지 올렸을시 생성되는 50*50사이즈 이미지 추가노출)
					If Not(isNull(oitem.Prd.Ftentenimage) Or oitem.Prd.Ftentenimage = "") Then
						Dim viTentenimg, viTententmb
						if ImageExists(oitem.Prd.Ftentenimage1000) Then
							viTentenimg = oitem.Prd.Ftentenimage1000
						ElseIf ImageExists(oitem.Prd.Ftentenimage600) Then
							viTentenimg = oitem.Prd.Ftentenimage600
						ElseIf ImageExists(oitem.Prd.Ftentenimage) Then
							viTentenimg = oitem.Prd.Ftentenimage
						End If

						If viTentenimg<>"" Then
							viTententmb = oitem.Prd.Ftentenimage50
						End If
						Response.Write "<div class=""swiper-slide""><img src=""" & viTentenimg & """ alt=""" & replace(oItem.Prd.FItemName,"""","") & """ style=""width:100%;"" /></div>"
					End If
				%>
				</div>
			</div>
			<div class="pagination-no"><b></b>/<span></span></div>
		</div>
		<% if oDeal.Prd.FisJust1Day then %>
		<div class="timer" id="lyrjust1day"></div>
		<script type="text/javascript">
			$.ajax({
				type: "get",
				url: "act_just1day.asp?itemid=<%=itemid%>",
				success: function(message) {
					if(message) {
						$("#lyrjust1day").empty().html(message);
					}
				}
			});
		</script>
		<% end if %>
		<% If oDeal.Prd.FViewDIV="2" And oDeal.Prd.FisJust1Day<>"1" Then %>
		<div class="timer deal-timer">
			<% If DateDiff("s",now(),oDeal.Prd.FEndDate) < 1 Then %>
			<p><span class="icon icon-clock"></span>판매 종료된 상품입니다.</p>
			<% Else %>
			<p><span class="icon icon-clock"></span>남은 시간 <% If DateDiff("s",now(),oDeal.Prd.FEndDate) < 86400 Then %><%= ZeroTime(CStr(Fix(DateDiff("s",now(),oDeal.Prd.FEndDate)/3600) Mod 60)) %>:<% =ZeroTime(CStr(Fix(DateDiff("s",now(),oDeal.Prd.FEndDate)/60) Mod 60)) %></b><% Else %><% =DateDiff("d",now(),oDeal.Prd.FEndDate) %></b>일<% End If %></p>
			<% End If %>
		</div>
		<% End If %>

		<!-- item info -->
		<section class="items item-detail">
			<div class="desc">
				<!-- for dev msg : 단일 브랜드 상품으로 구성될 경우에만 노출해주세요 -->
				<span class="brand" id="brandshow" style="display:none"><a href="" onclick="fnAPPpopupBrand('<%= oItem.Prd.FMakerid %>'); return false;"><%=oItem.Prd.FBrandName%></a></span>
				<h2 class="name"><%= oItem.Prd.FItemName %></h2>
				<div class="price">
					<h3 class="tenten">텐바이텐가</h3>
					<div class="unit">
						<b class="sum"><%=FormatNumber(oDeal.Prd.FMasterSellCash,0)%><span class="won">원~</span></b>
					</div>
				</div>
			</div>
			<div class="btn-group" style="display:none" id="coupondl">
				<% If IsUserLoginOK Then %>
				<a href="#lyCoupon" class="layer">할인쿠폰 받기<span class="icon icon-download"></span></a>
				<% else %>
				<a href="" onClick="if(confirm('로그인이 필요한 서비스입니다.\n로그인 하시겠습니까?') == true){location.href = '<%=M_SSLUrl%>/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>';}; return false;" class="layer">할인쿠폰 받기<span class="icon icon-download"></span></a>
				<% end if %>
			</div>
		</section>

		<div id="mask" style="overflow:hidden; display:none; position:fixed; top:0; left:0; z-index:35; width:100%; height:100%; background:rgba(0, 0, 0, 0.5);"></div>

		<!-- item etc info -->
		<div class="item-etc-info">
			<p>※ 배송비 / 마일리지는 상품 상세에서 확인해주세요</p>
			<%' 마케팅 쿠폰다운 배너 %>
			<% 
			' 18주년 세일 기간 동안은 이 위치에 배너를 보여주지 않고 상품 기타 정보 하단으로 이동
			'If date() < "2019-09-26" OR date() > "2019-09-30" Then 
			If date() < "2019-10-01" OR date() > "2019-10-31" Then
				server.Execute("/chtml/main/loader/banner/exc_itemprd_banner_coupon.asp") 
			End if
			%>
			<%' 마케팅 쿠폰다운 배너 %>
		</div>

		<% 
		' 마케팅 쿠폰다운 배너 : 18주년 세일 기간 동안 이 위치에 띠배너를 보여줌
		'If date() > "2019-09-25" AND date() < "2019-10-01" Then 
		If date() > "2019-09-30" AND date() < "2019-11-01" Then
			server.Execute("/chtml/main/loader/banner/exc_itemprd_banner_coupon.asp") 
		End if
		%>

<script type="text/javascript">
<!--
function fnDealOtherItemView(itemid,viewnum){
	fnAPPpopupBrowser(OpenType.FROM_BOTTOM, [], '상품상세 보기', [], "<%=wwwUrl%>/apps/appCom/wish/web2014/deal/deal_view.asp?itemid=" + itemid + "&viewnum="+viewnum+"&dealitemid=<%=itemid%>");
}
//-->
</script>
		<!-- for dev msg : 20170718 skin change 클래스명 itemPrdV17 붙여주세요! -->
		<div class="itemPrdV16a itemPrdV17">
			<!-- tab -->
			<div class="itemDeatilV16a">
				
				<ul class="commonTabV16a">
				
					<% If oItem.Prd.IsSpecialBrand Then %>
					<li class="current" name="tab01" style="width:25%;">상품설명</li>
					<li class="" name="tab02" style="width:25%;">기본정보</li>
					<li class="" name="tab03" style="width:25%;">상품후기<span id="evalTotal">(0)</span></li>
					<li class="" name="tab04" style="width:25%;">Q&amp;A<span id="qnaTotal">(0)</span></li>
					<% Else %>
					<li class="current" name="tab01" style="width:33.3%;">상품설명</li>
					<li class="" name="tab02" style="width:33.3%;">기본정보</li>
					<li class="" name="tab03" style="width:33.3%;">상품후기<span id="evalTotal">(0)</span></li>
					<% End If %>
				</ul>
				<div class="itemDetailContV16a">
					<div id="tab01" class="pdtExplainV16a">
						<div class="items type-deal">
							<% If isArray(ArrDealItem) Then %>
							<ul>
								<% For intLoop = 0 To UBound(ArrDealItem,2) %>
								<%
									If ArrDealItem(9,intLoop)="Y" And DealCouponYn="N" Then DealCouponYn="Y" End If '쿠폰 가능상품 체크
									If intLoop=0 Then DealBrandName=ArrDealItem(7,intLoop)  '브랜드 통일 상품 체크
								%>
								<% If (UBound(ArrDealItem,2) Mod 2) = 0 Then %>
								<li class="full">
								<% Else %>
								<li class="half">
								<% End If %>
									<a href="" onClick="fnDealOtherItemView(<%=ArrDealItem(0,intLoop)%>,<%=intLoop+1%>);return false;">
										<% If IsSoldOut(ArrDealItem(3,intLoop),ArrDealItem(5,intLoop),ArrDealItem(6,intLoop),ArrDealItem(4,intLoop)) Or isTempSoldOut(ArrDealItem(3,intLoop)) Then %>
										<b class="soldout">일시 품절</b>
										<% End If %>
										<div class="thumbnail"><img src="<%=oDeal.IsImageBasic(ArrDealItem(0,intLoop),ArrDealItem(8,intLoop))%>" alt="<%=ArrDealItem(1,intLoop)%>" /></div>
										<div class="desc">
											<b class="no">상품 <%=intLoop+1%></b>
											<span class="brand"><%=ArrDealItem(7,intLoop)%></span>
											<p class="name"><%=ArrDealItem(1,intLoop)%></p>
											<div class="price">
												<% If ArrDealItem(10,intLoop)="Y" And ArrDealItem(9,intLoop)="Y" Then %>
												<div class="unit"><b class="sum"><% If ArrDealItem(9,intLoop)="Y" Then %><%=FormatNumber(GetDealCouponPrice(ArrDealItem(2,intLoop),ArrDealItem(13,intLoop),ArrDealItem(12,intLoop)),0)%><% Else %><%=FormatNumber(ArrDealItem(2,intLoop),0)%><% End If %><span class="won">원</span></b> <b class="discount color-red"><%=CLng((ArrDealItem(11,intLoop)-ArrDealItem(2,intLoop))/ArrDealItem(11,intLoop)*100)%>%</b><b class="discount color-green"><%= GetCouponDiscount(ArrDealItem(12,intLoop),ArrDealItem(13,intLoop)) %><small>쿠폰</small></b></div>
												<% ElseIf ArrDealItem(10,intLoop)="Y" Then %>
												<div class="unit"><b class="sum"><%=FormatNumber(ArrDealItem(2,intLoop),0)%><span class="won">원</span></b> <b class="discount color-red"><%=CLng((ArrDealItem(11,intLoop)-ArrDealItem(2,intLoop))/ArrDealItem(11,intLoop)*100)%>%</b></div>
												<% ElseIf ArrDealItem(9,intLoop)="Y" Then %>
												<div class="unit"><b class="sum"><% If ArrDealItem(9,intLoop)="Y" Then %><%=FormatNumber(GetDealCouponPrice(ArrDealItem(2,intLoop),ArrDealItem(13,intLoop),ArrDealItem(12,intLoop)),0)%><% Else %><%=FormatNumber(ArrDealItem(2,intLoop),0)%><% End If %><span class="won">원</span></b> <b class="discount color-green"><%= GetCouponDiscount(ArrDealItem(12,intLoop),ArrDealItem(13,intLoop)) %><small>쿠폰</small></b></div>
												<% Else %>
												<div class="unit"><b class="sum"><%=FormatNumber(ArrDealItem(2,intLoop),0)%><span class="won">원</span></b></div>
												<% End If %>
											</div>
										</div>
										<div class="btn-more">자세히 보기<span class="icon icon-arrow"></span></div>
									</a>
								</li>
								<%
									If ArrDealItem(7,intLoop) <> DealBrandName Then
										DealBrandCheck="N"
									End If
								%>
								<% Next %>
							</ul>
							<% End If %>
						</div>
					</div>
<%
If DealCouponYn="Y" Then
'=============================== 딜 쿠폰 정보 ==========================================
dim dealcode, oitemcoupon, tmpNum, ArrDealCouponItem, oDealCP, couponidxarr, stypearr
couponidxarr=""
stypearr=""
Set oDealCP = New DealCls
ArrDealCouponItem=oDealCP.GetDealItemCouponList(oDeal.Prd.FDealCode)
Set oDealCP = Nothing
Set oitemcoupon = New CItemCouponMaster
%>
		<!-- 쿠폰 다운받기 layer popup -->
		<div id="lyCoupon" class="ly-modal ly-coupon">
			<div class="tenten-header header-popup">
				<div class="title-wrap">
					<p class="headline">할인쿠폰 (<%=UBound(ArrDealCouponItem,2)+1%>)</p>
					<button type="button" class="btn-close">닫기</button>
				</div>
			</div>
			<div class="content">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide">
							<div class="deal-coupon-list">
								<% If isArray(ArrDealCouponItem) Then %>
								<ul>
									<% For intLoop = 0 To UBound(ArrDealCouponItem,2) %>
									<%
										oitemcoupon.FRectItemCouponIdx = ArrDealCouponItem(0,intLoop)
										oitemcoupon.GetOneItemCouponMaster
									if oitemcoupon.FOneItem.IsOpenAvailCoupon Then
									%>
									<li>
										<p class="name"><%= oitemcoupon.FOneItem.Fitemcouponname %></p>
										<p class="date"><%= formatDate(oitemcoupon.FOneItem.Fitemcouponstartdate,"0000.00.00") & " ~ " & formatDate(oitemcoupon.FOneItem.Fitemcouponexpiredate,"00.00") %></p>
										<b class="discount color-green"><%= oitemcoupon.FOneItem.Fitemcouponvalue %><% If oitemcoupon.FOneItem.Fitemcouponvalue < 100 Then %>%<% Else %>원<% End If %></b>
										<button type="button" class="btn-down" onclick="CouponDownload('<%= oitemcoupon.FOneItem.Fitemcouponidx %>','prd');"><span class="icon icon-download"></span>쿠폰다운</button>
									</li>
									<%
										If oitemcoupon.FOneItem.Fitemcouponidx <> "" Then
										couponidxarr = Trim(couponidxarr) & Trim(oitemcoupon.FOneItem.Fitemcouponidx) & ","
										stypearr = Trim(stypearr) & "prd,"
										End If
									%>
									<% End If %>
									<% Next %>
									<%
										If couponidxarr<>"" Then
										couponidxarr = left(couponidxarr,Len(couponidxarr)-1)
										stypearr = left(stypearr,Len(stypearr)-1)
										End If
									%>
								</ul>
								<% End If %>
							</div>
							<form name="couponFrm" method="get" action="/shoppingtoday/couponshop_process.asp" style="margin:0px;">
							<input type="hidden" name="idx">
							<input type="hidden" name="stype">
							</form>
							<div class="list-bullet-hypen">
								<ul>
									<li>발행된 쿠폰은 [마이텐바이텐]에서 확인 가능합니다.</li>
									<li>발행된 쿠폰은 사용 후 재발행이 가능합니다.</li>
									<li>각 쿠폰은 할인되는 해당 상품이 있습니다.</li>
								</ul>
							</div>
						</div>
					</div>
					<div class="swiper-scrollbar"></div>
				</div>
			</div>
			<div class="ly-footer">
				<div class="btn-group">
					<a href="" onclick="CouponDownload('<%=couponidxarr %>','<%=stypearr %>');return false;" class="btn btn-red btn-large btn-block">전체 다운<span class="icon icon-download"></span></a>
				</div>
			</div>
		</div>
<% Set oitemcoupon = Nothing %>
<script type="text/javascript">
<!--
	function CouponDownload(couponidx,stype){
	document.couponFrm.idx.value=couponidx;
	document.couponFrm.stype.value=stype;
	document.couponFrm.submit();
}


//-->
</script>
<% End If %>
<script>
	<% If DealCouponYn="Y" Then ' 쿠폰이 있을 시 쿠폰 다운로드 버튼 활성화 %>
		$("#coupondl").show();
	<% End If %>
	<% If DealBrandCheck="Y" Then %>
		$("#brandshow").show();
	<% End If %>
</script>
					<div id="tab02" class="pdtBasicInfoV16a" style="display:none;">
						<div class="dropdwon-box">
							<div class="dropDown">
								<!-- for dev msg : 첫번째 상품을 디폴트로 해주세요 -->
								<button type="button" class="btnDrop">[상품1] <%=ArrDealItem(1,0)%></button>
								<div class="dropBox">
									<% If isArray(ArrDealItem) Then %>
									<ul>
										<% For intLoop = 0 To UBound(ArrDealItem,2) %>
										<% If IsSoldOut(ArrDealItem(3,intLoop),ArrDealItem(5,intLoop),ArrDealItem(6,intLoop),ArrDealItem(4,intLoop)) Or isTempSoldOut(ArrDealItem(3,intLoop)) Then %>
										<li class="soldout"><div class="option">[상품<%=intLoop+1%>] <%=ArrDealItem(1,intLoop)%></div></li>
										<% Else %>
										<li><a href="" onclick="fnDealItemBasicInfoView(<%=ArrDealItem(0,intLoop)%>);return false;"><div class="option">[상품<%=intLoop+1%>] <%=ArrDealItem(1,intLoop)%></div></a></li>
										<% End If %>
										<% Next %>
									</ul>
									<% End If %>
								</div>
							</div>
						</div>
<script type="text/javascript">
<!--
function fnDealItemBasicInfoView(itemid){
	$.ajax({
		url: "/apps/appCom/wish/web2014/deal/act_itembasicinfo.asp?itemid="+itemid,
		cache: false,
		async: false,
		success: function(message) {
			//alert(message);
			if(message!="") {
				$str = $(message);
				$('#basicinfo').empty();
				$('#basicinfo').append($str);
			} else {
				alert("제공 할 정보가 없습니다.");
			}
		}
	});
}
$(function() {
	fnDealItemBasicInfoView(<%=ArrDealItem(0,0)%>);
});
//-->
</script>
						<ul class="pdtDetailListV16a">
							<li>
								<dl class="accordTab">
									<dt><p>상품 필수 정보</p></dt>
									<dd id="basicinfo">
									</dd>
								</dl>
							</li>
							<li>
								<dl class="accordTab">
									<dt><p>배송정보</p></dt>
									<dd>
										<ul class="prdEtcInfoV16a">
											<li>- 배송기간은 주문일(무통장입금은 결제완료일)로부터 1일 (24시간) ~ 5일정도 걸립니다.</li>
											<li>- 업체배송 상품은 무료배송 되며, 업체조건배송 상품은 특정 브랜드 배송기준으로 배송비가 부여되며 업체착불배송은 특정 브랜드 배송기준으로 고객님의 배송지에 따라 배송비가 착불로 부과됩니다.</li>
											<li>- 해외배송 표시가 되어 있는 상품은 해외 주소로 바로 배송이 가능한 상품입니다.</li>
											<li>- 지정일 배송이 가능한 플라워 상품의 경우에는 상품설명에 있는 제작기간과 배송시기를 숙지해 주시기 바랍니다.</li>
											<li>- 제작기간이 별도로 소요되는 상품의 경우에는 상품설명에 있는 제작기간과 배송시기를 숙지해 주시기 바랍니다.</li>
											<li>- 가구 및 플라워 등의 상품의 경우에는 지역에 따라 추가 배송비용이 발생할 수 있음을 알려드립니다.</li>
										</ul>
									</dd>
								</dl>
							</li>
							<li>
								<dl class="accordTab">
									<dt><p>교환/환불</p></dt>
									<dd>
										<ul class="prdEtcInfoV16a">
											<li>- 상품 수령일로부터 7일 이내 반품/환불 가능합니다.</li>
											<li>- 변심 반품의 경우 왕복배송비를 차감한 금액이 환불되며, 제품 및 포장상태가 재판매 가능하여야 합니다.</li>
											<li>- 상품 불량인 경우는 배송비를 포함한 전액이 환불됩니다.</li>
											<li>- 출고 이후 환불요청 시 상품 회수 후 처리됩니다.</li>
											<li>- 주문제작(쥬얼리 포함) /카메라 / 밀봉포장상품 / 플라워 등은 변심으로반품/환불 불가합니다.</li>
											<li>- 완제품으로 수입된 상품의 경우 A/S가 불가합니다.</li>
											<li>- 특정브랜드의 교환/환불/AS에 대한 개별기준이 상품페이지에있는 경우 브랜드의 개별기준이 우선 적용 됩니다.</li>
										</ul>
									</dd>
								</dl>
							</li>
							<li>
								<dl class="accordTab">
									<dt><p>기타 기준 사항</p></dt>
									<dd>
										<ul class="prdEtcInfoV16a">
											<li>- 구매자가 미성년자인 경우에는 상품 구입시 법정대리인이 동의하지 아니하면 미성년자 본인 또는 법정대리인이 구매취소 할 수 있습니다.</li>
										</ul>
									</dd>
								</dl>
							</li>
						</ul>
					</div>

                    <!-- 상품후기 -->
					<script>
						const dealReviewMasterIdx = '<%=oDeal.Prd.FDealCode%>';
						const dealReviewUserId = `<%=GetLoginUserID%>`;
					</script>
					<div id="dealReviewVue"></div>
					<script src="/vue/components/common/functions/common.js?v=1.00"></script>
                    <script src="/vue/components/deal/select_product.js?v=1.01"></script>
                    <script src="/vue/components/deal/button_write.js?v=1.00"></script>
                    <script src="/vue/components/deal/tab_review_type.js?v=1.00"></script>
                    <script src="/vue/components/deal/review_list.js?v=1.01"></script>
                    <script src="/vue/components/deal/review_v2.js?v=1.00"></script>
                    <script src="/vue/components/review/product_detail/modal_post_report_review_v2.js?v=1.02"></script>
                    <script src="/vue/deal/Detail/store.js?v=1.00"></script>
                    <script src="/vue/deal/Detail/index_v2.js?v=1.00"></script>
					<!-- Q&A -->
                    <%
                        Dim oDealQNA, ArrDealItemQNA
                        Set oDealQNA = New DealCls
                        ArrDealItemQNA=oDealQNA.GetDealItemQNAList(oDeal.Prd.FDealCode)
                        Set oDealQNA = Nothing
                    %>
					<div id="tab04" class="pdtQnaV16a" style="display:none;">
						<div class="dropdwon-box">
							<div class="dropDown">
								<button type="button" class="btnDrop">[상품1] <%=ArrDealItemQNA(1,0)%></button>
								<div class="dropBox">
									<% If isArray(ArrDealItemQNA) Then %>
									<ul>
										<% For intLoop = 0 To UBound(ArrDealItemQNA,2) %>
										<% DealItemQnaTotalCNT = DealItemQnaTotalCNT + ArrDealItemQNA(2,intLoop) %>
										<li><a href="" onclick="fnDealItemQnaView(<%=ArrDealItemQNA(0,intLoop)%>);return false;"><div class="option">[상품<%=intLoop+1%>] <%=ArrDealItemQNA(1,intLoop)%> <em class="value"><%=FormatNumber(ArrDealItemQNA(2,intLoop),0)%>건</em></div></a></li>
										<% Next %>
									</ul>
									<% End If %>
								</div>
							</div>
							<div id="itemqna"></div>
						</div>
                        <script>
                        function fnDealItemQnaView(itemid){
                            $.ajax({
                                url: "act_itemQna.asp?itemid="+itemid+"&dealitemid=<%=itemid%>&tcnt=<%=formatNumber(DealItemQnaTotalCNT,0)%>",
                                cache: false,
                                async: false,
                                success: function(message) {
                                    //alert(message);
                                    if(message!="") {
                                        $str = $(message);
                                        $('#itemqna').empty();
                                        $('#itemqna').append($str);
                                    } else {
                                        alert("제공 할 정보가 없습니다.");
                                    }
                                }
                            });
                        }
                        $(function(){
                            fnDealItemQnaView(<%=ArrDealItemQNA(0,0)%>);
                            $("#qnaTotal").empty().append("(<%=formatNumber(DealItemQnaTotalCNT,0)%>)");
                        });
                        </script>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- //contents -->
	<%' 주문 영역 %>
	<!-- for dev msg : 20170718 skin change 클래스명 itemFloatingV17 붙여주세요! -->
	<div class="itemFloatingV16a itemFloatingV17"><!-- opening16a -->
		<form name="sbagfrm" method="post" action="" style="margin:0px;">
		<input type="hidden" name="mode" value="add" />
		<input type="hidden" name="itemid" value="<% = oitem.Prd.FItemid %>" />
		<input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
		<input type="hidden" name="itemoption" value="" />
		<input type="hidden" name="userid" value="<%= LoginUserid %>" />
		<input type="hidden" name="itemPrice" value="<%= oItem.Prd.getRealPrice %>">
		<input type="hidden" name="itemea" readonly value="1" />
		<input type="hidden" name="itemRemain" id="itemRamainLimit" value="<%=chkIIF(oItem.Prd.IsLimitItemReal,CHKIIF(oItem.Prd.FRemainCount<=oItem.Prd.ForderMaxNum,oItem.Prd.FRemainCount,oItem.Prd.ForderMaxNum),oItem.Prd.ForderMaxNum)%>">
		<input type="hidden" name="itemName">
		<span class="controller"></span>
		<div class="itemOptWrapV16a">
			<div class="itemOptV16a">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide">
							<div class="itemoption">
								<a href="#lyDropdown" class="btnDrop layer on" id="itembtn">상품을 선택해주세요.</a>
								<a href="#lyDropdownOpt" class="btnDrop layer disableClick" id="opbtn">옵션을 선택해주세요.</a>
								<!-- <button onclick="#lyDropdown" class="btnDrop layer on" id="itembtn" disabled="true">상품을 선택해주세요.</button>
								<button onclick="#lyDropdownOpt" class="btnDrop layer" id="opbtn" disabled="true">옵션을 선택해주세요.</button> -->
							</div>
							<ul class="optContListV16a" id="lySpBagList"></ul>
						</div>
					</div>
					<div class="swiper-scrollbar"></div>
				</div>
			</div>
			<div class="pdtPriceV16a">
				<p>
					<span>상품 합계</span>
				</p>
				<p class="rt"><strong id="spTotalPrc">0</strong>원</p>
			</div>
		</div>
		<div class="btnAreaV16a">
			<p>
                <button type="button" id="btnWishV21" class="btn-wishV21" data-flag="<%=chkIIF(isMyFavItem,"on","off")%>">
                    <figure id="icoWishV21" class="ico"></figure>
                    <span id="wishCountV21" class="cnt"><%=FormatNumber(ofavItem.Prd.FfavCount,0)%></span>
                </button>
            </p>
			<% If  now() < oDeal.Prd.FStartDate Then	'### 시작일이 아닐때 %>
				<p><button type="button" class="btnV16a btnRed2V16a" disabled="disabled">판매종료</button></p>
			<% Else %>
				<% If oDeal.Prd.FViewDIV="2" And (oDeal.Prd.FEndDate < now()) Then %>
					<p><button type="button" class="btnV16a btnRed2V16a" disabled="disabled">판매종료</button></p>
				<% Else %>
					<p class="actBuy"><button type="button" class="btnV16a btnRed2V16a">구매하기</button></p>
					<%If oItem.Prd.FAdultType = 0 Or session("isAdult") = true then%>
						<p class="actCart"><button type="button" class="btnV16a btnRed1V16a" disabled="disabled" onclick="FnAddShoppingBag(true);">장바구니</button></p>
					<%else%>
						<p class="actCart"><button type="button" class="btnV16a btnRed1V16a" onclick="confirmAdultAuth('<%=Server.URLencode(CurrURLQ())%>', <%=chkiif(IsUserLoginOK, "true", "false")%>);" disabled="disabled">장바구니</button></p>
					<%End if%>
					<%If oItem.Prd.FAdultType = 0 Or session("isAdult") = True then%>
						<p class="actNow"><button type="button" class="btnV16a btnRed2V16a" disabled="disabled" onclick="FnAddShoppingBag();">바로구매</button></p>
					<%else%>
						<p class="actNow"><button type="button" class="btnV16a btnRed2V16a" onclick="confirmAdultAuth('<%=Server.URLencode(CurrURLQ())%>', <%=chkiif(IsUserLoginOK, "true", "false")%>);" disabled="disabled">바로구매</button></p>
					<%End if%>
				<% End If %>
			<% End If %>
		</div>
		</form>
		<form name="BagArrFrm" method="post" action="" onsubmit="return false;" >
		<input type="hidden" name="mode" value="arr">
		<input type="hidden" name="bagarr" value="">
		</form>
	</div>

	<!-- dropdown layer popup -->
	<!-- for dev msg : 20170718 skin change 클래스명 lyDropdownV17 붙여주세요! -->
	<div id="lyDropdown" class="lyDropdown lyDropdownV17">
		<button type="button" class="btnClose">닫기</button>
		<div class="dropDown">
			<p class="btnDrop on">상품을 선택해주세요.</p>
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<!-- 상품 선택 -->
						<div class="dropBox multi" id="itembox">
							<% If isArray(ArrDealItem) Then %>
							<ul>
								<% For intLoop = 0 To UBound(ArrDealItem,2) %>
								<% If IsSoldOut(ArrDealItem(3,intLoop),ArrDealItem(5,intLoop),ArrDealItem(6,intLoop),ArrDealItem(4,intLoop)) Or isTempSoldOut(ArrDealItem(3,intLoop)) Then %>
								<li class="soldout"><a href="#"><div class="option">[상품<%=intLoop+1%>] <%=ArrDealItem(1,intLoop)%> <em class="value"><%=FormatNumber(ArrDealItem(2,intLoop),0)%>원</em></div></a></li>
								<% Else %>
								<li><a href="#" onclick="fnDealItemOptionView(<%=ArrDealItem(0,intLoop)%>,<%=ArrDealItem(2,intLoop)%>,'[상품<%=intLoop+1%>] <%=ArrDealItem(1,intLoop)%>');return false;"><div class="option">[상품<%=intLoop+1%>] <%=ArrDealItem(1,intLoop)%> <em class="value"><% If ArrDealItem(9,intLoop)="Y" Then %><%=FormatNumber(GetDealCouponPrice(ArrDealItem(2,intLoop),ArrDealItem(13,intLoop),ArrDealItem(12,intLoop)),0)%><% Else %><%=FormatNumber(ArrDealItem(2,intLoop),0)%><% End If %>원</em></div></a></li>
								<% End If %>
								<% Next %>
							</ul>
							<% End If %>
						</div>
					</div>
				</div>
				<div class="swiper-scrollbar"></div>
			</div>
		</div>
	</div>
	<div id="lyDropdownOpt" class="lyDropdown2 lyDropdownV17">
		<button type="button" class="btnClose">닫기</button>
		<div class="dropDown">
			<p class="btnDrop on">옵션을 선택해주세요.</p>
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<div class="dropBox" id="optbox">
							<ul id="oplist">
							</ul>
						</div>
					</div>
				</div>
				<div class="swiper-scrollbar"></div>
			</div>
		</div>
	</div>
	<div class="alertBoxV17a" style="display:none" id="alertBoxV17a">
		<div>
			<p class="alertCart" id="sbaglayerx" style="display:none"><span>장바구니에 상품이 담겼습니다.</span></p>
			<p id="sbaglayero" style="display:none"><span>장바구니에 이미 같은 상품이 있습니다.</span></p>
			<p class="tMar1-1r"><button type="button" onClick="fnAPPpopupBaguni();" class="btnV16a btnRed2V16a">장바구니 가기 <img src="http://fiximage.10x10.co.kr/m/2016/common/blt_arrow_white.png" alt="" /></button></p>
		</div>
	</div>
<iframe src="" name="iiBagWin" frameborder="0" width="0" height="0"></iframe>
<div id="modalLayer" style="display:none;"></div>
<div id="modalLayer2" style="display:none;"><div id="modalLayer2Contents"></div><div id="dimed"></div></div>
<!-- #include virtual="/apps/appcom/wish/web2014/lib/incLogScript.asp" -->
<script language="JavaScript" type="text/javascript" SRC="/lib/js/todayview.js"></script>

<script type="application/ld+json">
{
	"@context": "http://schema.org/",
	"@type": "Product",
	"name": "<%= Replace(oItem.Prd.FItemName,"""","") %>",
	"image": "<%= getThumbImgFromURL(oItem.Prd.FImageBasic,400,400,"true","false") %>",
	"mpn": "<%= itemid %>",
	"brand": {
		"@type": "Brand",
    	"name": "<%= Replace(UCase(oItem.Prd.FBrandName),"""","") %>"
	}<%
	 if (oItem.Prd.FEvalCnt > 0) then
		 dim avgEvalPoint : avgEvalPoint = getEvaluateAvgPoint(itemid)
		 if (avgEvalPoint > 0) then
	 %>,
	"aggregateRating": {
		"@type": "AggregateRating",
		"ratingValue": "<%= avgEvalPoint %>",
		"reviewCount": "<%= oItem.Prd.FEvalCnt %>"
	}<%
	 	end if
	 end if
	 %>
}
</script>

<script type="text/javascript">
// 위시
const wish_button = document.getElementById('btnWishV21');
const ani_wish = bodymovin.loadAnimation({
    container: document.getElementById('icoWishV21'),
    loop: false,
    autoplay: false,
    path: 'https://assets2.lottiefiles.com/private_files/lf30_jgta4mcw.json'
});
ani_wish.addEventListener('DOMLoaded', () => {
    if (wish_button.dataset.flag === 'off') {
        ani_wish.goToAndStop(0, true);
    } else {
        ani_wish.goToAndStop(18, true);
    }
});
wish_button.addEventListener('click', () => {
    <% If IsUserLoginOK() Then %>
        const is_current_on = wish_button.dataset.flag === 'on';
        ajaxPostWish('<%=oDeal.Prd.FMasterItemCode%>', !is_current_on, data => {
            if ( is_current_on ) {
                wish_button.dataset.flag = 'off';
                ani_wish.playSegments([18,30], true);
                modifyWishCount(-1);
            } else {
                wish_button.dataset.flag = 'on';
                ani_wish.playSegments([0,18], true);
                modifyWishCount(1);
            }
        });
    <% Else %>
        calllogin();
    <% End If %>
});
// call 위시 api
function ajaxPostWish(item_id, flag, callback) {
    let front_api_url = '//fapi.10x10.co.kr/api/web/v1';
    if( '<%=application("Svr_Info")%>'.toLowerCase() === 'dev' ) {
        front_api_url = '//testfapi.10x10.co.kr/api/web/v1';
    }

    $.ajax({
        type : 'POST',
        url: front_api_url + '/wish/item',
        data: {
            'item_id' : item_id,
            'method' : flag ? 'post' : 'delete'
        },
        ContentType : "json",
        crossDomain: true,
        async: false,
        xhrFields: {
            withCredentials: true
        },
        success: callback,
        error: function (xhr) {
            console.log(xhr);
            const error = JSON.parse(xhr.responseText);
            if( error.code === -10 ) {
                top.location.href = "<%=M_SSLUrl%>/login/login.asp?backpath=<%=Server.URLencode(CurrURLQ())%>";
            }
        }
    });
}
// 위시 수 변경
function modifyWishCount(count) {
    const wish_count_span = document.getElementById('wishCountV21');
    let wish_count = Number(wish_count_span.innerText.replace(/,/gi, '')) + count;
    if( isNaN(wish_count) || wish_count < 0 )
        return false;
    wish_count_span.innerText = wish_count.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

<%' 에코마케팅용 레코벨 스크립트 삽입(2016.12.21) %>
  window._rblq = window._rblq || [];
  _rblq.push(['setVar','cuid','0f8265c6-6457-4b4a-b557-905d58f9f216']);
  _rblq.push(['setVar','device','MW']);
  _rblq.push(['setVar','itemId','<%=itemid%>']);
//  _rblq.push(['setVar','userId','{$userId}']); // optional
  _rblq.push(['setVar','searchTerm','<%=vPrtr%>']);
  _rblq.push(['track','view']);
  (function(s,x){s=document.createElement('script');s.type='text/javascript';
  s.async=true;s.defer=true;s.src=(('https:'==document.location.protocol)?'https':'http')+
  '://assets.recobell.io/rblc/js/rblc-apne1.min.js';
  x=document.getElementsByTagName('script')[0];x.parentNode.insertBefore(s, x);})();
</script>

<!-- datadive 전송용 -->
<input type="hidden" id="layerKind" value="product">
<input type="hidden" id="layerItemId" value="<%=oDeal.Prd.FMasterItemCode%>">
<input type="hidden" id="layerItemName" value="<%=oItem.Prd.FItemName%>">
<!-- #include virtual="/apps/appCom/wish/web2014/common/LayerShare.asp" -->
</body>
</html>
<%
	Set oItem = Nothing
	Set ofavItem = Nothing
	set clsDiaryPrdCheck = Nothing
	Set addEx = Nothing

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->