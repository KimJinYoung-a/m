<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	Description : 상품상세
'	History	: 2014.01.08 한용민 생성
'             2014.09.18 허진원 2014 리뉴얼
'             2015.02.24 허진원 2015 리뉴얼
'             2016.05.06 이종화 2016 리뉴얼
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/web2014/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/wishCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->
<!-- #include virtual="/lib/classes/item/sp_evaluatesearchercls.asp" -->
<!-- #include virtual="/lib/classes/item/sp_item_qnacls.asp" -->
<!-- #include virtual="/lib/classes/item/PlusSaleItemCls.asp" -->
<!-- #include virtual="/lib/classes/diarystory/diary_class.asp" -->
<!-- #include virtual="/lib/classes/award/newawardcls.asp" -->
<!-- #include virtual="/lib/classes/gift/gifttalkCls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<%
	dim itemid	: itemid = requestCheckVar(request("itemid"),9)
	Dim page, vDisp, cpid, vDepth, vMakerid

	if page="" then page=1

	if itemid="" or itemid="0" then
		Call Alert_AppClose("상품번호가 없습니다.")
		response.End
	elseif Not(isNumeric(itemid)) then
		Call Alert_AppClose("잘못된 상품번호입니다.")
		response.End
	else
		'정수형태로 변환
		itemid=CLng(getNumeric(itemid))
	end if

	dim LoginUserid
	LoginUserid = getLoginUserid()

	dim flag : flag = request("flag")

	dim oItem, ItemContent
	set oItem = new CatePrdCls
	oItem.GetItemData itemid

	if oItem.FResultCount=0 then
		Call Alert_AppClose("존재하지 않는 상품입니다.")
		response.End
	end if

	if oItem.Prd.Fisusing="N" then
		Call Alert_AppClose("판매가 종료되었거나 삭제된 상품입니다.")
		response.End
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
	oADD.getAddImage itemid

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

	'// 티켓팅
	Dim IsTicketItem, oTicket
	IsTicketItem = (oItem.Prd.FItemDiv = "08")
	If IsTicketItem Then
		set oTicket = new CTicketItem
		oTicket.FRectItemID = itemid
		oTicket.GetOneTicketItem
	End if

	'// Present상품
	Dim IsPresentItem
	IsPresentItem = (oItem.Prd.FItemDiv = "09")

	'// 스페셜 항공권 상품 (ex 진에어 이벤트)
	Dim IsSpcTravelItem
	IsSpcTravelItem = oitem.Prd.IsTravelItem and oItem.Prd.Fmakerid = "10x10Jinair"

	'// 공유 제한 상품 (프리젠트 상품 또는 특수한 브랜드)
	Dim isSpCtlIem
	isSpCtlIem = (IsPresentItem or oItem.Prd.FMakerid="10x10present")

	'// 현장수령 상품
	Dim IsReceiveSiteItem
	IsReceiveSiteItem = (oItem.Prd.FDeliverytype="6")

	'=============================== 이메일특가 번호 접수 및 특가 계산 (base64사용) =================================
	cpid = requestCheckVar(request("ldv"),12)
	if Not(cpid="" or isNull(cpid)) then
		cpid = trim(Base64decode(cpid))
		if isNumeric(cpid) then
			oItem.getTargetCoupon cpid, itemid
		end if
	end if

	'//옵션 HTML생성
	dim ioptionBoxHtml
	IF (oitem.Prd.FOptionCnt>0) then
		if (IsReceiveSiteItem) or (IsPresentItem) or (IsTicketItem) or (oItem.Prd.Flimitdispyn="N") then
			ioptionBoxHtml = GetOptionBoxDpLimit2017(itemid, oitem.Prd.IsSoldOut,Not(IsReceiveSiteItem) and Not(IsPresentItem and oItem.Prd.FRemainCount>200) and Not(IsTicketItem and oItem.Prd.FRemainCount>100 ) and Not(oItem.Prd.Flimitdispyn="N"))
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
		isMyFavItem = getIsMyFavItem(LoginUserid,itemid)
	end if

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

    '### 상품 상세 캡쳐이미지 (APP용) 2015/12/02 추가.
    Dim vItemDtlViewType
    if (flgDevice="A") then
        if (fnIsItemDtlCaptureExists(itemid)) then
            vItemDtlViewType = "1"                  '' 앱에서 보여줌.
        end if
    end if
    ''-----------------------------------------------
    
	'// 페이지 타이틀
	strPageTitle = "10X10: " & oItem.Prd.FItemName

	'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
	dim snpTitle, snpLink, snpPre, snpImg, snpTag
	snpTitle = Server.URLEncode(oItem.Prd.FItemName)
	snpLink = Server.URLEncode("http://m.10x10.co.kr/category/category_itemprd.asp?itemid=" & itemid)
	snpPre = Server.URLEncode("텐바이텐 HOT ITEM!")
	snpImg = Server.URLEncode(oItem.Prd.FImageBasic)
	snpTag = Server.URLEncode("#10x10")


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
			Call fnUserLogCheck("item", LoginUserid, itemid, "", "", "app")
		End If
	End If

%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type="application/x-javascript" src="/lib/js/itemPrdDetail.js?v=1.115"></script>
<script type="application/x-javascript" src="/apps/appCom/wish/web2014/lib/js/shoppingbag_script.js?v=1.219"></script>
<script type="application/x-javascript" src="/lib/js/jquery.numspinner_m.js"></script>
<script type="text/javascript">
$(function() {

	//플로팅 밀림방지 앱전용
	<% if (flgDevice="I") then %>
	var saveh = 0;
	$('.itemoption select[name="item_option"] , .rqtxt textarea').focus(function() {
		saveh = $(document).scrollTop();
		var userH = document.documentElement.clientHeight;
		$(".itemFloatingV16a").css('position','absolute');
		$(".container").css('height', userH+'px');
		$(".container").css('overflow', 'hidden');
	}).blur(function(){
		$(document).scrollTop(saveh);
		$(".itemFloatingV16a").css('position','fixed');
		$(".container").css('height', 'auto');
		$(".container").css('overflow', 'auto');
	});
	<% end if %>

	//창 타이틀 변경
	setTimeout(function(){
		fnAPPchangPopCaption("상품정보");
	}, 100);

	// 로딩후 스크롤 다운
//	setTimeout(function(){
//		$('html, body').animate({scrollTop:$(".itemPrdV16a").offset().top}, 'fast');
//	}, 300);

	// Top버튼 위치 이동
	$(".goTop").addClass("topHigh");

	$(window).scroll(function() {
		var window_top = $(window).scrollTop();
		var div_top = $(".itemDeatilV16a").offset().top;

		if (window_top >= div_top) {
			$(".commonTabV16a").addClass('sticky');
		} else {
			$(".commonTabV16a").removeClass('sticky');
		}
	});

	// product detail tab control
	$(".itemDeatilV16a .tabCont > div:first").show();
	$('.itemDeatilV16a .commonTabV16a li').click(function(){
		$(".itemDeatilV16a .tabCont > div").hide();
		$('.itemDeatilV16a .commonTabV16a li').removeClass('current');
		$(this).addClass('current');
		var tabView = $(".itemDeatilV16a .tabCont div[id|='"+ $(this).attr('name') +"']");
		var tabNum = $(this).attr('tno');
		//탭내용 넣기
		if($(tabView).html()=="") {
			var tabFile = "/apps/appcom/wish/web2014/category/category_itemprd_ajax.asp?itemid=<%=itemid%>&tabno="+tabNum+"&tnm="+$(this).attr('name');
			if(tabFile!="") {
				$.ajax({
					type: "get",
					url: tabFile,
					cache: false,
					success: function(message) {
						$(tabView).empty().html(message);
					}
				});
			}
		}
		$(tabView).show();
		$('html, body').animate({scrollTop: $(".itemDeatilV16a").offset().top}, 500);
	});

	// 로딩중 표시
	$("#lyLoading").ajaxStart(function(){
		$(this).show();
	}).ajaxStop(function(){
		$(this).hide();
	});

	/* item swiper */
	if ($("#itemSwiper .swiper-container .swiper-slide").length > 1) {
		var rollingSwiper = new Swiper("#itemSwiper .swiper-container", {
			loop:true,
			speed:800,
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

	// plus slae swipe
	if ($("#plussaleSwiper .swiper-container .swiper-slide").length > 1) {
		var plussaleSwiper = new Swiper("#plussaleSwiper .swiper-container", {
			//loop:true,
			slidesPerView:"auto"
		});
	}

	//제작 문구만 있는 경우
	if (!$('.itemoption #opttag a:first').hasClass('on')){
		$('.txtBoxV16a').addClass('current');
	}

	// product detail tab control
	$(".postContV16a:first").show();
	$('.postTxtV16a .btnBarV16a li').click(function(){
		$(".postContV16a").hide();
		$('.postTxtV16a .btnBarV16a li').removeClass('current');
		$(this).addClass('current');
		var postTabView = $(this).attr('name');
		$("div[class|='postContV16a'][id|='"+ postTabView +"']").show();
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

	//2016/09/22 추가 mint 구매추적 
	//동시에 여러customAPI 먹는지 확인필요. 
	//track을 마지막으로 호출(2016.09.22 facebook ads 관련 원승현 수정)
	var isMobile = {
			Android: function () {
					 return (/Android/i).test(navigator.userAgent);
			},
			BlackBerry: function () {
					 return (/BlackBerry/i).test(navigator.userAgent);
			},
			iOS: function () {
					 return (/iPhone|iPad|iPod/i).test(navigator.userAgent);
			},
			Opera: function () {
					 return (/Opera Mini/i).test(navigator.userAgent);
			},
			Windows: function () {
					 return (/IEMobile/i).test(navigator.userAgent);
			},
			any: function () {
					 return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
			}
	};
	callNativeFunction('getDeviceInfo', {"callback": function(deviceInfo) {
		if (isMobile.iOS())
		{
			if (deviceInfo.version >= 1.991)
			{
				setTimeout("fnAPPsetTrackLog(\"view\",\"['<%=itemid%>']\",\"<%=oItem.Prd.GetCouponAssignPrice%>\");",1200);
			}
		}
		if (isMobile.Android())
		{
			if (deviceInfo.version >= 1.88)
			{
				setTimeout("fnAPPsetTrackLog(\"view\",\"['<%=itemid%>']\",\"<%=oItem.Prd.GetCouponAssignPrice%>\");",1200);
			}
		}
	}});

	amplitude.getInstance().init('accf99428106843efdd88df080edd82e');
	amplitude.getInstance().logEvent('itemprd');
});

	//옵션 없는 단일 상품일 경우에만
	function jsItemea(plusminus)
	{
		var vmin = parseInt(<%=chkIIF(oItem.Prd.IsLimitItemReal and oItem.Prd.FRemainCount<=0,"0",oItem.Prd.ForderMinNum)%>);
		var vmax = parseInt(<%=chkIIF(oItem.Prd.IsLimitItemReal,CHKIIF(oItem.Prd.FRemainCount<=oItem.Prd.ForderMaxNum,oItem.Prd.FRemainCount,oItem.Prd.ForderMaxNum),oItem.Prd.ForderMaxNum)%>);
		
		var v = parseInt(sbagfrm.itemea.value);

		if(plusminus == "+") {
			v++;
			if(v > vmax) v--;
		}
		else if(plusminus == "-") {
			if(v > 1) {
				v--;
			} else {
				v = 1;
			}
			if(v < vmin) v++;
		}
		sbagfrm.itemea.value = v;
		sbagfrm.optItemEa.value = v;

		var p = parseInt(sbagfrm.itemPrice.value);

		$("#spTotalPrc").text(plusComma(parseInt(v * p)));
		$("#subtot").text(plusComma(parseInt(v * p))+"원");
	}

	// 관심 품목 담기 - 상품 페이지 전용 : 상품 코드로 변경
	function TnAddFavoritePrd(iitemid){
	<% If IsUserLoginOK() Then %>
		fnAPPpopupBrowserURL("위시폴더","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popWishFolder.asp?itemid="+iitemid+"&ErBValue=3");
	<% Else %>
		calllogin();
	<% End If %>
	}

	// SNS 공유 팝업
	function fnAPPRCVpopSNS(){
	    fnAPPpopupBrowserURL("공유","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popShare.asp?sTit=<%=snpTitle%>&sLnk=<%=snpLink%>&sPre=<%=snpPre%>&sImg=<%=snpImg%>");
	    return false;
	}

	//기프트톡 입력창
	function writeShoppingTalk(v) {
		fnAPPpopupBrowserURL("쓰기","<%=wwwUrl%>/apps/appcom/wish/web2014/gift/gifttalk/talk_write.asp?itemid="+v);
	}

	//상품상세 기프트쓰기 빠른 상품찾기 팝업(팝업 닫으면서 js 호출)
	function goitemReturn(){
		fnAPPpopupBrowserURL("상품 찾기","<%=wwwUrl%>/apps/appCom/wish/web2014/gift/gifttalk/write_right_ajax.asp");
		return false;
	}
	//상품상세 기프트쓰기 선택한 상품 집어넣기(팝업 닫으면서 js 호출)
	function TalkItemSelect(v){
		fnAPPpopupBrowserURL("톡 쓰기","<%=wwwUrl%>/apps/appCom/wish/web2014/gift/gifttalk/talk_write.asp?itemid="+v);
	}
	// 선물포장 js
	function jsGoPojangList(){
		location.replace('http://m.10x10.co.kr/apps/appCom/wish/web2014/shoppingtoday/gift_recommend.asp');
	}

	//장바구니 레이어
	function fnsbagly(v) {
		if (v=="x"){
			$("#sbaglayerx").show();
			$("#alertBoxV17a").show();
		}else if(v=="o"){
			$("#sbaglayero").show();
			$("#alertBoxV17a").show();
		}
		setTimeout(function() {
			$("#alertBoxV17a").fadeOut(1000);
		}, 2500);
	}


	//2017-07-05 플로팅 2017ver
	$(function(){
		// floating area option select control
		$('.itemOptV16a select').focus(function(){
			if($(this).hasClass('current')){
				$(this).removeClass('current');
			} else {
				$('.itemOptV16a select').removeClass('current');
				$(this).addClass('current');
			}
		});
		$('.itemOptV16a select').focusout(function(){
			$('.itemOptV16a select').removeClass('current');
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

			<% if Not(oItem.Prd.FOptionCnt>0) And Not(IsPresentItem) and Not(IsSpcTravelItem) then %>
				$(".btnAreaV16a .actCart .btnRed1V16a").attr("disabled",false);
				$(".btnAreaV16a .actNow .btnRed2V16a").attr("disabled",false);
			<% end if %>

			floatScroll.update();
		});

		/* layer popup for dropdown */
		$.fn.layerOpen = function(options) {
			return this.each(function() {
				var $this = $(this);
				var $layer = $($this.attr("href") || null);
				$this.click(function() {
					if ($this.attr('disabled') != "disabled"){
						$layer.attr("tabindex",0).show().focus();
						$layer.find(".btnClose, .btnDrop").one("click",function () {
							$layer.hide();
							$this.focus();

							<%'레이어 닫은후 클래스 처리 %>
							var $opttag = $("#opttag a");
							$opttag.each(function(index){
								if ($this.index() == $(this).index()){
									$(this).addClass("on");
								}else{
									$(this).removeClass("on");
								}
							});
							$('.txtBoxV16a').removeClass('current');
						});

						<%'DB에서 받아온 옵션 노출 %>
						var $dropBoxs = $(".dropBox ul");
						$dropBoxs.each(function(index){
							if ($this.index() == $(this).index()-1){
								$(this).show();
							}else{
								$(this).hide();
							}
						});
						dropdownScrollLayer.onResize(); //ul 초기화
						dropdownScrollLayer.update(); //ul update
					}
				});
			});
		}
		$(".layer").layerOpen();

		/* swipe scroll for dropdown layer */
		var dropdownScrollLayer = new Swiper('.lyDropdown .swiper-container', {
			scrollbar:'.lyDropdown .swiper-scrollbar',
			direction:'vertical',
			slidesPerView:'auto',
			mousewheelControl:true,
			freeMode:true
		});
	});
	//2017-07-05 플로팅 2017ver

	//2017 추가
	$(function(){
		/* breadcrumbs */
		var breadcrumbsSwiper = new Swiper("#breadcrumbs .swiper-container",{
			slidesPerView:"auto"
		});

		/* 상품가격 더보기 */
		$(".item-detail .btn-more").on("click", function(){
			var thisCont = $(this).attr("href");
			$(thisCont).slideToggle();
			return false;
		});

	});
</script>
</head>
<body class="default-font body-sub bg-grey category-item">
	<div class="content" id="contentArea" style="padding-bottom:6rem;">
	<%="1-" & Session.Codepage %>
		<% '' 2017 정기세일-숨은 보물을 찾아라(4/3~4/17) %>
		<!-- #include virtual="/event/etc/2017props_77062.asp" -->
		<% If vDisp <> "111" and vDisp<>"0" Then %>
		<div id="breadcrumbs" class="breadcrumbs">
			<div class="swiper-container">
				<ol class="swiper-wrapper">
				<%
					if vDisp="123" then
						'클리어런스 세일이면 클리어런스 페이지로 이동
						response.Write "<li class=""swiper-slide""><a href=""#"" onclick=""fnAPPpopupBrowserURL('CLEARANCE SALE','" & wwwUrl & "/apps/appCom/wish/web2014/clearancesale/');return false;"" class=""cBk1"">클리어런스</a></li>"
					else
						response.Write vCateNavi
					end if
				%>
				</ol>
			</div>
		</div>
		<% End If %>

		<%' 상품이벤트 노출 배너입니다. %>
		<div style="display:none;" id="itemevent"></div>

		<% If clsDiaryPrdCheck.FResultCount > 0 then %>
			<% If Left(Now(), 10) > "2016-10-03" and Left(Now(), 10) < "2017-01-01" Then %>
				<%'다이어리 배너 추가(10/04)%>
				<div style="padding:1rem;"><a href="" onclick="fnAPPpopupBrowserURL('다이어리','<%=wwwUrl%>/apps/appCom/wish/web2014/diarystory2017/'); return false;"><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/bnr_detail_diary.png" alt="2017 DIARY STORY" /></a></div>
			<% end if %>
		<% end if %>

		<div id="itemSwiper" class="item-detail-swiper">
			<% IF (oItem.Prd.isLimitItem) and (not (oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut)) and (Not IsReceiveSiteItem) and Not(IsPresentItem and oItem.Prd.FRemainCount>200 ) and Not(IsTicketItem and oItem.Prd.FRemainCount>100 ) Then %>
			<span class="label label-box">한정 <% = oItem.Prd.FRemainCount %>개</span>
			<% end if %>
			<%
			Dim vOneAndOne, vOneAndOneSDate
			vOneAndOne = getDiaryoneandonegubun2(itemid)
			If vOneAndOne <> "" Then
				vOneAndOneSDate = Split(vOneAndOne,"||")(1)
				vOneAndOne = Split(vOneAndOne,"||")(0)
			End If

			If GiftSu > 0 Then %>
				<span class="label label-box">
					<%
						if vOneAndOne="" then
							response.write "사은품"
						else
							if vOneAndOne="1" then
								response.write "Gift"	'"1+1"
							elseif vOneAndOne="2" then
								response.write "Gift"	'"1:1"
							else
								response.write "사은품"
							end if
						end if
					%> 남은수량 <% = GiftSu %>개</span>
			<% else %>
				<%
				If date() = CDate(vOneAndOneSDate) Then
					if vOneAndOne <> "" then %>
					<span class="label label-box">
						<span>
						<%
							if vOneAndOne="" then
								response.write "사은품"
							else
								if vOneAndOne="1" then
									response.write "1+1"
								elseif vOneAndOne="2" then
									response.write "1:1"
								else
									response.write "사은품"
								end if
							end if
						%> 남은수량 0개</span>
				<% end if
				end if
				%>
			<% end if %>
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

		<% if oItem.Prd.FisJust1Day then %>
		<div id="lyrjust1day" class="timer"></div>
		<script type="text/javascript">
			$.ajax({
				type: "get",
				url: "/category/act_just1day.asp?itemid=<%=itemid%>",
				success: function(message) {
					if(message) {
						$("#lyrjust1day").empty().html(message);
					}
				}
			});
		</script>
		<% end if %>

		<section class="items item-detail">
			<div class="desc">
			<%="2-" & Session.Codepage %>
				<span class="brand"><a href="" onClick="fnAPPpopupBrand('<%=oItem.Prd.Fmakerid%>');return false;"><%=oItem.Prd.FBrandName%><em>브랜드</em></a></span>
				<h2 class="name"><%= oItem.Prd.FItemName %></h2>
				<% '혹시 몰라서주석 처리함 2017-08-10 이종화%>
				<%' IF oItem.Prd.IsSoldOut Then %>
					<!--<span class="fgSoldout">품절</span> -->
				<%' Else %>
					<%' if oItem.Prd.IsTenOnlyitem then %><!--<span class="fgOnly">ONLY</span>--> <%' end if %>
					<%' IF oItem.Prd.isNewItem Then %><!--<span class="fgNew">NEW</span>--> <%' End If %>
					<%' IF oItem.Prd.IsSaleItem THEN %><!--<span class="fgSale">SALE</span>--> <%' End If %>
					<%' if oitem.Prd.isCouponItem Then %><!--<span class="fgCoupon">쿠폰</span>--> <%' End If %>
					<%' IF oItem.Prd.isLimitItem Then %><!--<span class="fgLimit">한정</span>--> <%' End If %>
					<%' if oItem.getGiftExists(itemid) then %><!--<span class="fgPlus">1+1</span>--> <%' end if %>
					<%' IF oItem.Prd.IsFreeBeasong Then %><!--<span class="fgFree">무료배송</span>--> <%' End If %>
					<%' IF oItem.Prd.IsSoldOut Then %><!--<span class="fgSoldout">품절</span>--> <%' End if %>
				<%' End if %>
				<div class="price">
					<h3 class="tenten">텐바이텐가</h3>
					<!-- 할인일 경우 -->
					<div class="unit">
						<% IF ((oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0)) or (oItem.Prd.IsSaleItem and oItem.Prd.IsSpecialUserItem) or (oitem.Prd.isCouponItem) THEN %>
						<s><%=FormatNumber(oItem.Prd.getOrgPrice,0)%></s>
						<b class="sum color-red"><%= FormatNumber(oItem.Prd.GetCouponAssignPrice,0) %><span class="won"><%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></span></b>
						<% Else %>
						<b class="sum"><%=FormatNumber(oItem.Prd.getOrgPrice,0)%><span class="won">원</span></b>
						<% End If %>
					</div>
					<% IF ((oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0)) or (oItem.Prd.IsSaleItem and oItem.Prd.IsSpecialUserItem) or (oitem.Prd.isCouponItem) THEN %>
					<a href="#priceList" class="btn-more">상세 가격 정보 보기</a>
					<% End If %>
				</div>
			</div>
			<dl id="priceList" class="price-list">
				<% IF ((oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0)) or (oItem.Prd.IsSaleItem and oItem.Prd.IsSpecialUserItem) or (oitem.Prd.isCouponItem) THEN %>
						<dt><%=chkIIF(Not(IsTicketItem),"판매가","티켓기본가")%></dt>
						<dd><div class="price"><b class="sum"><%=FormatNumber(oItem.Prd.getOrgPrice,0)%><span class="won"><%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></span></b></div></dd>
					<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
						<dt>할인판매가</dt>
						<dd><div class="price"><b class="discount color-red"><%=chkiif(oItem.Prd.FOrgprice = 0,"0",CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100))%>%</b> <b class="sum"><%=FormatNumber(oItem.Prd.FSellCash,0)%><span class="won"><%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></span></b></div></dd>
					<% end if %>
					<% if oItem.Prd.IsSaleItem and oItem.Prd.IsSpecialUserItem then %>
						<dt>우수회원가<span class="icoHot"><a href="" onclick="fnAPPpopupBrowserURL('우수회원샵','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/special_shop.asp'); return false;"><em class="rdBtn2">우수회원샵</em></a></span></dt>
						<dd><div class="price"><b class="discount color-red"><% = getSpecialShopPercent() %>%</b><b class="sum"><%=FormatNumber(oItem.Prd.getRealPrice,0)%><span class="won"><%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></span></b></div></dd>
					<% end if %>
					<% if oitem.Prd.isCouponItem Then %>
						<dt>쿠폰적용가</dt>
						<dd><div class="price"><b class="discount color-green"><%= oItem.Prd.GetCouponDiscountStr %></b> <b class="sum"><%=FormatNumber(oItem.Prd.GetCouponAssignPrice,0)%><span class="won"><%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></span></b></div></dd>
					<% end if %>
				<% end if %>
			</dl>
			<% if oitem.Prd.isCouponItem Then %>
			<div class="btn-group">
				<button type="button" onclick="jsDownCoupon('prd','<%= oitem.Prd.FCurrItemCouponIdx %>'); return false;"><%= oItem.Prd.GetCouponDiscountStr %> 쿠폰<span class="icon icon-download"></span></button>
				<form name="frmC" method="get" action="/apps/appcom/wish/web2014/shoppingtoday/couponshop_process.asp" style="margin:0px;">
				<input type="hidden" name="stype" value="" />
				<input type="hidden" name="idx" value="" />
				</form>
			</div>
			<% end if %>
		</section>


		<div class="item-etc-info">
			<ul>
				<%
					if oItem.Prd.IsAboardBeasong then
						if oItem.Prd.IsFreeBeasong then
							Response.Write "<li><span class=""icon icon-shipping""></span>텐텐 무료배송 + 해외배송</li>"
						else
							Response.Write "<li><span class=""icon icon-shipping""></span>텐텐배송 + 해외배송</li>"
						end if
					else
						Response.Write "<li><span class=""icon icon-shipping""></span>"& oItem.Prd.GetDeliveryName
						if Not(oItem.Prd.IsFreeBeasong) and (oItem.Prd.IsUpcheParticleDeliverItem or oItem.Prd.IsUpcheReceivePayDeliverItem) Then
							Response.write "<a href="""" onClick=""fnAPPpopupBrand('"& oItem.Prd.Fmakerid &"');return false;"">배송비 절약 상품</a>"
						Else
							response.write 	"</li>"
						End If 
					end if
				%>
				<% If G_IsPojangok Then %>
				<% If oItem.Prd.IsPojangitem Then %>
				<li><span class="icon icon-wrapping"></span>선물포장가능 <a href="" onClick="fnAPPpopupBrowserURL('선물포장안내','<%=wwwUrl%>/apps/appCom/wish/web2014/category/popPkgIntro.asp?itemid=<%=itemid%>'); return false;">텐바이텐 선물 포장</a></li>
				<% End If %>
				<% End If %>
				<% If IsUserLoginOK Then %>
				<li><span class="icon icon-gifttalk"></span>선물 골라주세요! <a href="" onclick="writeShoppingTalk('<%=itemid%>'); return false;">기프트톡 쓰기</a></li>
				<% else %>
				<li><span class="icon icon-gifttalk"></span>선물 골라주세요! <a href="" onClick="if(confirm('로그인이 필요한 서비스입니다.\n로그인 하시겠습니까?') == true){location.href = '<%=M_SSLUrl%>/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>&mode=wr';}; return false;">기프트톡 쓰기</a></li>
				<% end if %>
			</ul>
		</div>

		<!-- #Include virtual="/apps/appCom/wish/web2014/category/inc_PlusSaleList.asp" -->
		
		<!--// Category Best //-->
		<!--#include virtual="/apps/appCom/wish/web2014/category/inc_category_best.asp" -->
		
		<% If (now() >  #09/18/2017 00:00:00# And now() <= #09/19/2017 23:59:59#) then %>
		<!-- 한수위 쿠폰 배너 2017.06.26~ 07.05 -->
		<div class="bnr" style="margin-bottom:1rem;">
			<a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=80384');return false;" title="한수위 쿠폰 페이지로 이동"><img src="http://imgstatic.10x10.co.kr/event/eventetc/2017/evt_80384_m2.jpg" alt="한수위 쿠폰" /></a>
		</div>
		<% end if %>
		<%
			'2017년 봄정기세일 안내 배너 노출
			if date>="2017-04-03" and date<="2017-04-17" then
		%>
		<div class="bnr" style="margin-bottom:1rem;">
			<a href="/apps/appcom/wish/web2014/event/eventmain.asp?eventid=77059&gaparam=item_banner_0" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=77059&gaparam=item_banner_0');return false;" title="소품전 메인 페이지로 이동"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77059/m/img_bnr_sopum.png" alt="텐바이텐 봄 정기세일 진행 중! 최대 30% coupon 4월 17일까지" /></a>
		</div>
		<%	end if %>

		<div class="itemPrdV16a itemPrdV17">
			<%' 상품상세설명 영역 %>
			<div class="itemDeatilV16a">
				<!-- #include virtual="/apps/appCom/wish/web2014/category/category_itemprd_detail_new.asp" -->
			</div>

			<% ''If (Not IsTicketItem) Then '티켓아닌경우 - 일반상품 %>
				<% If False Then %>
					<% ' 레코벨 서비스 오픈 150728 원승현 %>
					<script type="text/javascript">
						//var vIId='<%=itemid%>', vDisp='<%=vDisp%>';
					</script>
					<% if cFlgDBUse then %>
						<!--<script type="text/javascript" src="./inc_happyTogether.js"></script>-->
					<% end if %>
					<!--// 함께구매하면 좋은상품 -->
					<!--<div id="lyrHPTgr"></div>-->

				<% End If %>

				<% if cFlgDBUse then %>
					<script type="text/javascript">
						$.ajax({
							url: "act_happyTogetherNew.asp?itemid=<%=itemid%>&disp=<%=vDisp%>",
							cache: false,
							async: true,
							success: function(vRst) {
								if(vRst!="") {
									$("#lyrHappyTogetherCol").empty().html(vRst);
								}
								else
								{
									$('#lyrHappyTogetherCol').hide();
								}
							}
							,error: function(err) {
								//alert(err.responseText);
								$('#lyrHappyTogetherCol').hide();
							}
						});
					</script>
					<div id="lyrHappyTogetherCol"></div>
				<% End If %>
				<!--// Event Item //-->
				<!-- #Include virtual="/apps/appCom/wish/web2014/category/inc_ItemEventList.asp" -->
			<% ''end if %>
		</div>
	</div>

	<div class="alertBoxV17a" style="display:none" id="alertBoxV17a">
		<div>
			<p class="alertCart" id="sbaglayerx" style="display:none"><span>장바구니에 상품이 담겼습니다.</span></p>
			<p id="sbaglayero" style="display:none"><span>장바구니에 이미 같은 상품이 있습니다.</span></p>
			<p class="tMar1-1r"><button type="button" onClick="fnAPPpopupBaguni();" class="btnV16a btnRed2V16a">장바구니 가기 <img src="http://fiximage.10x10.co.kr/m/2016/common/blt_arrow_white.png" alt="" /></button></p>
		</div>
	</div>

<%' 2017 정기세일 이벤트(4/3~4/17 - 숨은 보물찾기 상품은 주문영역 삭제 - 유태욱 %>
<% if itemid = 1676126 or itemid = 1676180 or itemid = 1676207 or itemid = 1676225 or itemid = 1676272 or itemid = 1676297 or itemid = 1676411 or itemid = 1676426 or itemid = 1676481 or itemid = 1676486 or itemid = 1676503 or itemid = 1676514 or itemid = 1676654 or itemid = 1676596 or itemid = 1676597 then %>
<% else %>
	<%' 주문 영역 %>
	<div class="itemFloatingV16a itemFloatingV17">
		<form name="sbagfrm" method="post" action="" style="margin:0px;">
		<input type="hidden" name="mode" value="add" />
		<input type="hidden" name="itemid" value="<% = oitem.Prd.FItemid %>" />
		<input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
		<input type="hidden" name="itemoption" value="" />
		<input type="hidden" name="userid" value="<%= LoginUserid %>" />
		<input type="hidden" name="itemPrice" value="<%= oItem.Prd.getRealPrice %>">
		<input type="hidden" name="isPresentItem" value="<%= isPresentItem %>" />
		<input type="hidden" name="IsSpcTravelItem" value="<%= IsSpcTravelItem %>">
		<input type="hidden" name="itemea" readonly value="1" />
		<span class="controller"></span>
		<div class="itemOptWrapV16a">
			<div class="itemOptV16a">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide">
							<% IF oItem.Prd.FOptionCnt>0 then %>
								<div class="itemoption">
									<div id="opttag"></div>
								</div>
							<% end if %>
							<% if oItem.Prd.FItemDiv = "06" then %>
								<div class="rqtxt <%=chkiif(oItem.Prd.FOptionCnt>0," tPad0-9r"," onlyTxt")%>">
									<div class="txtBoxV16a requiredetail">
										<textarea name="requiredetail" id="requiredetail" placeholder="[문구입력란] 문구를 입력해 주세요!" onclick="chkopt();"></textarea>
										<% If oItem.Prd.FOptionCnt > 0 Then %>
										<button type="button" class="btnV16a btnMGryV16a" onclick="requireTxt();return false;">완료</button>
										<% End If %>
									</div>
								</div>
							<% end if %>
							<%'간이 장바구니%>
							<ul id="lySpBagList" class="optContListV16a">
								<% If Not(oItem.Prd.FOptionCnt>0) And Not(IsPresentItem) Then %>
								<li>
									<div class="optQuantityV16a tMar0-5r">
										<p class="odrNumV16a">
											<button type="button" class="btnV16a minusQty" onclick="jsItemea('-');">감소</button>
											<input type="text" value="1" id='optItemEa' name='optItemEa' readonly/>
											<button type="button" class="btnV16a plusQty" onclick="jsItemea('+');">증가</button>
										</p>
										<p class="rt" id="subtot"><%=chkiif(Not(oItem.Prd.FOptionCnt>0) And Not(IsPresentItem),FormatNumber(oItem.Prd.getRealPrice,0),"0")%>원</p>
									</div>
								</li>
								<% End If %>
							</ul>
							<%'간이 장바구니%>
						</div>
					</div>
					<div class="swiper-scrollbar"></div>
				</div>
			</div>
			<% if Not(IsPresentItem) and Not(IsSpcTravelItem) then %>
			<div class="pdtPriceV16a">
				<p>
					<span>상품 합계</span>
				</p>
				<p class="rt"><strong id="spTotalPrc"><%=chkiif(Not(oItem.Prd.FOptionCnt>0) And Not(IsPresentItem),FormatNumber(oItem.Prd.getRealPrice,0),"0")%></strong>원</p>
			</div>
			<% end if %>
		</div>
		</form>
		<form name="BagArrFrm" method="post" action="" onsubmit="return false;" >
		<input type="hidden" name="mode" value="arr">
		<input type="hidden" name="bagarr" value="">
		</form>
		<div class="btnAreaV16a">
			<% if Not(isSpCtlIem) then%>
			<p><button type="button" class="btnV16a btnWishV16a <%=chkIIF(isMyFavItem,"actWish","")%>" onclick="TnAddFavoritePrd('<% = oItem.Prd.Fitemid %>');return false;"><%=FormatNumber(oItem.Prd.FFavCount,0)%></button></p>
			<% end if %>
			<%
				if IsPresentItem then	'## Present상품
					IF Not(oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut) Then
						If IsUserLoginOK() Then		'# 로그인한 경우
			%>
				<p class="actBuy"><button type="button" class="btnV16a btnRed2V16a" onclick="<%=chkiif(oItem.Prd.FOptionCnt>0 or oItem.Prd.FItemDiv = "06","FnAddShoppingBag(true)","TnAddShoppingBag(true)")%>;">바로신청</button></p>
			<%			else %>
				<p class="actBuy"><button type="button" class="btnV16a btnRed2V16a" onclick="alert('회원 구매만 가능합니다. 로그인 후 구매해 주세요.');">바로신청</button></p>
			<%
						end if
					else
			%>
				<p><button type="button" class="btnV16a btnRed2V16a" disabled="disabled">품절</button></p>
			<%
					end if
				elseif IsSpcTravelItem then	'## 스페셜 항공권 상품
					IF Not(oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut) Then
						If IsUserLoginOK() Then		'# 로그인한 경우
			%>
				<p class="actBuy"><button type="button" class="btnV16a btnRed2V16a" onclick="TnAddShoppingBag()">바로구매</button></p>
				<p class="actCart"><button type="button" class="btnV16a btnRed2V16a" onclick="TnAddShoppingBag()">바로구매</button></p>
			<%			else %>
				<p class="actBuy"><button type="button" class="btnV16a btnRed2V16a" onclick="alert('회원 구매만 가능합니다. 로그인 후 구매해 주세요.');">바로구매</button></p>
				<p class="actCart"><button type="button" class="btnV16a btnRed2V16a" onclick="alert('회원 구매만 가능합니다. 로그인 후 구매해 주세요.');">바로구매</button></p>
			<%
						end if
					else
			%>
				<p><button type="button" class="btnV16a btnRed2V16a" disabled="disabled">품절</button></p>
			<%
					end if
				else	'## 일반상품
			%>
				<% IF Not(oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut) Then %>
					<p class="actBuy"><button type="button" class="btnV16a btnRed2V16a">구매하기</button></p>
					<% If Not(oItem.Prd.IsReserveItem) then %>
					<p class="actCart"><button type="button" class="btnV16a btnRed1V16a" onclick="<%=chkiif(oItem.Prd.FOptionCnt>0,"FnAddShoppingBag(true)","TnAddShoppingBag(true)")%>;" disabled="disabled">장바구니</button></p>
					<% End If %>
				<% else %>
					<p><button type="button" class="btnV16a btnRed2V16a" disabled="disabled">품절</button></p>
				<% end if %>
				<% IF Not(oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut or oItem.Prd.IsMileShopitem) Then %>
					<p class="actNow"><button type="button" class="btnV16a btnRed2V16a" onclick="<%=chkiif(oItem.Prd.FOptionCnt>0,"FnAddShoppingBag()","TnAddShoppingBag()")%>;" disabled="disabled">바로구매</button></p>
				<% end if %>
			<% end if %>
			<!--<p class="actBuy"><button type="button" class="btnV16a btnRed2V16a">구매하기</button></p> -->
			<!--<p class="actCart"><button type="button" class="btnV16a btnRed1V16a" disabled="disabled">장바구니</button></p> for dev msg : 구매하기옵션 선택후 disabled 해제 / 옵션 없는 경우 처음부터 disabled 아님 -->
			<!--<p class="actNow"><button type="button" class="btnV16a btnRed2V16a" disabled="disabled">바로구매</button></p> -->
		</div>
	</div>
	<%' 주문 영역 %>
<% end if %>
	<form name="qnaform" method="post" action="/apps/appCom/wish/web2014/my10x10/doitemqna.asp" target="iiBagWin" style="margin:0px;">
	<input type="hidden" name="id" value="" />
	<input type="hidden" name="itemid" value="<% = itemid %>" />
	<input type="hidden" name="mode" value="del" />
	<input type="hidden" name="flag" value="fd" />
	</form>
	<iframe src="" name="iiBagWin" frameborder="0" width="0" height="0"></iframe>
	<script>
	$(function(){
		$('.btnZoomV16a').hide();
		$(window).scroll(function(){
			var s_position = $(".itemInfoV16a").outerHeight();
			var e_position1 = $(".itemDeatilV16a").outerHeight();
			var e_position2 = $("#lyrHPTgr").outerHeight();
			var position = $(window).scrollTop();
			if (position > s_position && position < parseInt(e_position1+e_position2)){
				if($('.btnZoomV16a').css("display")=="none"){
					$('.btnZoomV16a').fadeIn();
				}
			} else {
				$('.btnZoomV16a').hide();
			}
		});
	});
	</script>
	<a href="" class="btn-zoom" onclick="fnAPPpopupBrowserURL('상품상세 보기','<%=wwwUrl%>/apps/appCom/wish/web2014/category/pop_category_itemPrd_detail.asp?itemid=<%=itemid%>&viewtype=<%=vItemDtlViewType%>'); return false;">상품 확대보기</a>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
	<!--button type="button" class="goTop" id="gotop">TOP으로 이동</button-->

	<div id="tmpopt" style="display:none;"></div>
	<div id="tmpopLimit" style="display:none;"></div>
	<div id="tmpitemCnt" style="display:none;"></div>

	<%' dropdown layer popup 2017-07-05 신규 버전%>
	<div id="lyDropdown" class="lyDropdown lyDropdownV17">
		<button type="button" class="btnClose">닫기</button>
		<div class="dropDown">
			<p class="btnDrop on">옵션을 선택하세요.</p>
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<div class="dropBox">
							<%' DB에서 옵션들 가저올 부분 %>
							<%=ioptionBoxHtml %>
							<%' DB에서 옵션들 가저올 부분 %>
						</div>
					</div>
				</div>
				<div class="swiper-scrollbar"></div>
			</div>
		</div>
	</div>
	<%' dropdown layer popup 2017-07-05 신규 버전%>
<script type="text/javascript">setTimeout("fnAPPaddRecentlyViewedProduct('<%=itemid%>');",300);</script>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/incLogScript.asp" -->
</body>
</html>
<%
	Set oItem = Nothing
	set clsDiaryPrdCheck = Nothing
	Set addEx = Nothing
	If IsTicketItem Then
		set oTicket = Nothing
	end If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->