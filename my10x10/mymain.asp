<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 마이텐바이텐
' History : 2014.09.19 한용민 생성
'			2015-04-21 이종화 - 멤버십 카드 추가
'			2017-08-31 이종화 - 메인 리뉴얼
'			2019-01-15 최종원 - 메인 리뉴얼
'####################################################
%>
<!-- #include virtual="/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_tenCashCls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<!-- #include virtual="/lib/util/badgelibUTF8.asp" -->
<!-- #include virtual="/offshop/lib/classes/offshopCls.asp" -->

<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_mileage_logcls.asp" -->

<!-- #include virtual="/lib/classes/shopping/sp_couponcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_itemcouponcls.asp" -->
<!-- #include virtual="/lib/classes/my10x10/mymaincls.asp" -->

<!-- #include virtual="/lib/classes/shopping/sp_evaluatesearchercls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myTenbytenInfoCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<%
dim userid, page, i
	userid = getEncLoginUserID

'####### 회원등급 재조정 #######
Call getDBUserLevel2Cookie()
'####### 회원등급 재조정 #######

'// 예치금
dim oTenCash
set oTenCash = new CTenCash
	oTenCash.FRectUserID = userid
	if (userid<>"") then
		oTenCash.getUserCurrentTenCash
	end If

'// 기프트카드 잔액 확인
dim oGiftcard, currentCash : currentCash =0
set oGiftcard = new myGiftCard
	oGiftcard.FRectUserid = userid

	if (userid<>"") then
		currentCash = oGiftcard.myGiftCardCurrentCash
	end If
set oGiftcard = Nothing

'// 멤버십카드 
Dim ClsOSPoint , cardno 
set ClsOSPoint = new COffshopPoint1010
	ClsOSPoint.fnGetMyMemberCard
	cardno = ClsOSPoint.Fcardno
set ClsOSPoint = Nothing


'---------------------------------------------------------------------
'//온라인 total-mileage
dim myMileage
set myMileage = new TenPoint
myMileage.FRectUserID = getloginuserid
if (getloginuserid<>"") then
	myMileage.getTotalMileage

	Call SetLoginCurrentMileage(myMileage.FTotalmileage)
end If

'//오프라인 total-mileage
dim myOffMileage
set myOffMileage = new TenPoint
myOffMileage.FGubun = "my10x10"
myOffMileage.FRectUserID = getloginuserid
if (getloginuserid<>"") then
	myOffMileage.getOffShopMileagePop
end If
'---------------------------------------------------------------------
'// 쿠폰
dim osailcoupon
set osailcoupon = new CCoupon
osailcoupon.FRectUserID = userid
osailcoupon.FPageSize=100
osailcoupon.FGubun = "mweb" '모바일웹용 쿠폰(일반+모바일) / monly:모바일+app,mweb:모바일웹용,mapp:APP쿠폰만

if userid<>"" then
	osailcoupon.getValidCouponList
end If

dim oitemcoupon
set oitemcoupon = new CUserItemCoupon
oitemcoupon.FRectUserID = userid

if userid<>"" then
	oitemcoupon.getValidCouponList
end if
'---------------------------------------------------------------------
'// 기본정보 카운트
dim mymainClass , mi
Dim mygubun(4) , mycount(4)
set mymainClass = new CMyMain
	If IsGuestLoginOK Then 
		mymainClass.FRectOrderserial = GetGuestLoginOrderserial
	Else
		mymainClass.FRectUserID = userid
	End If 
	mymainClass.GetMyinfoCount

	if mymainClass.FResultCount > 0 Then
		for mi = 0 to (mymainClass.FResultCount - 1) 
			mygubun(mi) = mymainClass.FItemList(mi).Fgubun '// 구분 0: 배송주문조회 , 1: 상품후기 , 2: 상품QnA , 3 : 1:1 상담
			mycount(mi) = mymainClass.FItemList(mi).Fcount
		Next 	
	End If 

'// 주문배송 배너 1개
set mymainClass = new CMyMain
	If IsGuestLoginOK Then 
		mymainClass.FRectOrderserial = GetGuestLoginOrderserial
	Else
		mymainClass.FRectUserID = userid
	End If 
	mymainClass.GetMyDeliveryTop1()

'// 나의 위시 상품
Dim mymainWishitem
set mymainWishitem = new CMyMain
	mymainWishitem.FRectUserID = userid
	mymainWishitem.My10x10MywishTop10()

'//상품 후기 마일리지
Dim cMil , vMileArr
Dim vMileValue : vMileValue = 100
If isdoubleMileage Then
	vMileValue = 200
End If 

Set cMil = New CEvaluateSearcher
	cMil.FRectUserID = Userid
	cMil.FRectMileage = vMileValue
	vMileArr = cMil.getEvaluatedTotalMileCnt
Set cMil = Nothing

'########################################################################
'등급 그래프 관련
'########################################################################
dim BuyCount, BuySum , userlevel
'// 다음달 기준
dim oMyInfo
set oMyInfo = new CMyTenByTenInfo
oMyInfo.FRectUserID = userid
oMyInfo.getNextUserBaseInfoData
	userlevel		= oMyInfo.FOneItem.Fuserlevel
	BuyCount		= oMyInfo.FOneItem.FBuyCount
	BuySum			= oMyInfo.FOneItem.FBuySum
set oMyInfo = Nothing

'// 등급별로 클래스 
dim tmpCSLeftMenuUserLevel : tmpCSLeftMenuUserLevel = GetUserStrlarge(GetLoginUserLevel)
Dim stroke1
Dim compare1 , compare2
Dim NextuserLevel2
Dim NextuserLevel : NextuserLevel = getUserLevelByQual(BuyCount,BuySum)			'조건으로 회원등급 확인

	NextuserLevel2 = getNextMayLevel(NextuserLevel)

	if cStr(userlevel)="5" and cStr(NextuserLevel)="0" then NextuserLevel="5"	'오렌지회원
	if cStr(userlevel)="7" then NextuserLevel="7"								'STAFF

	'// 등급업까지 남은 횟수 및 금액 비교
	compare1 = getRequireLevelUpBuyCountPercent(NextuserLevel,BuyCount) '// 횟수
	compare2 = getRequireLevelUpBuySumPercent(NextuserLevel,BuySum) '// 원

If GetLoginUserLevel = 7 Then
	stroke1 = 100
Else
	stroke1 = chkiif(compare1>=compare2,compare1,compare2)
End If 
'########################################################################
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.bounce {-webkit-animation:3s bounce 3; -webkit-animation-fill-mode:both; animation:3s bounce 3; animation-fill-mode:both;}
@-webkit-keyframes bounce {
	0%, 20%, 50%, 80%, 100% {-webkit-transform:translateY(0);}
	40% {-webkit-transform:translateY(-10px);}
	60% {-webkit-transform:translateY(-5px);}
}
@keyframes bounce {
	0%, 20%, 50%, 80%, 100% {transform:translateY(0);}
	40% {transform:translateY(-10px);}
	60% {transform:translateY(-5px);}
}
.lightSpeedIn {-webkit-animation:lightSpeedIn 2s ease-out 1; -webkit-animation-fill-mode:both; animation:lightSpeedIn 2s ease-out 1; animation-fill-mode:both;}
@-webkit-keyframes lightSpeedIn {
	0% {-webkit-transform:translateX(50%);}
	60% {-webkit-transform:translateX(-20%);}
	80% {-webkit-transform:translateX(0%);}
	100% {-webkit-transform:translateX(0%);}
}
@keyframes lightSpeedIn {
	0% {transform:translateX(50%);}
	60% {transform:translateX(-20%);}
	80% {transform:translateX(0%);}
	100% {transform:translateX(0%);}
}

</style>
<script type="text/javascript">
function pop_Benefit(){
	fnOpenModal("/my10x10/userinfo/act_popBenefit.asp");
}

$(function(){
	cardH = $(".cardBrowse").height();
	$('.cardOpener').click(function(){
		if ($(this).parent().hasClass('cardAllView')){
			$(".cardBrowse").stop().animate({"height":cardH},50);
			$(this).parent().removeClass('cardAllView');
		} else {
			$(".cardBrowse").stop().animate({"height":"100%"},300);
			$(this).parent().addClass('cardAllView');
		}
		
	});
});

function tencardreg(){
	//'카드 발급
	if (confirm('포인트카드를 발급 받으시겠습니까?')){
		var rstStr = $.ajax({
			type: "POST",
			url: "dotentencard.asp",
			dataType: "text",
			async: false
		}).responseText;
		if (rstStr == "0000"){
			alert('포인트카드 발급이 완료 되었습니다');
			document.location.reload();
		}else if (rstStr == "0009"){
			alert('현재는 사용이 불가능한 카드를 가지고 계십니다.\nCS에 문의 해주세요');
			document.location.reload();
		}
	}
}


//2017 리뉴얼
$(function(){
	$(".nav-stripe a").on("click", function(e){
		$(".nav-stripe a").removeClass("on");
		$(this).addClass("on");
		return false;
	});

	$(".nav-stripe li:nth-child(1) a").on("click", function(e){
		myownSwiper.slideTo(0);
	});
	$(".nav-stripe li:nth-child(2) a").on("click", function(e){
		myownSwiper.slideTo(1);
	});
	$(".nav-stripe li:nth-child(3) a").on("click", function(e){
		myownSwiper.slideTo(2);
	});
	$(".nav-stripe li:nth-child(4) a").on("click", function(e){
		myownSwiper.slideTo(3);
	});

	var myownSwiper = new Swiper("#myownSwiper", {
		slidesPerView:"auto",
		speed:800,
		onSlideChangeStart: function (myownSwiper) {
			$(".nav-stripe a").removeClass("on");
			if ($(".swiper-slide-active").is(".mileage")) {
				$(".nav-stripe").find("li:nth-child(1) a").addClass("on");
			}
			if ($(".swiper-slide-active").is(".coupon")) {
				$(".nav-stripe").find("li:nth-child(2) a").addClass("on");
			}
			if ($(".swiper-slide-active").is(".balance")) {
				$(".nav-stripe").find("li:nth-child(3) a").addClass("on");
			}
			if ($(".swiper-slide-active").is(".giftcard")) {
				$(".nav-stripe").find("li:nth-child(4) a").addClass("on");
			}
		}
	});

	function anislideX() {
		var window_top = $(window).scrollTop();
		var div_top = $("#bnrNotification").offset().top-300;
		if (window_top > div_top){
			$("#bnrNotification .swiper-slide:first .icon:first").addClass("lightSpeedIn");
		} else {
			$("#bnrNotification .swiper-slide:first .icon:first").removeClass("lightSpeedIn");
		}
	}

	/* notification swiper */
	if ($("#bnrNotification .swiper-container .swiper-slide").length > 1) {
		var bnrNotificationSwiper = new Swiper("#bnrNotification .swiper-container", {
			pagination:"#bnrNotification .pagination-dot",
			paginationClickable:true,
			onSlideChangeStart: function (bnrNotificationSwiper) {
				$(".swiper-slide").find(".icon:first").removeClass("lightSpeedIn");
				$(".swiper-slide-active").find(".icon:first").addClass("lightSpeedIn");
			}
		});
	}

	$(function() {
		$(window).scroll(anislideX);
	});

	/* my wish swiper */
	if ($("#mywishSwiper .swiper-container .swiper-slide").length > 4) {
		var mywishSwiper = new Swiper("#mywishSwiper .swiper-container", {
			slidesPerView:"auto",
			freeMode:true,
			freeModeMomentumRatio:0.5
		});
	} else {
		$("#mywishSwiper .swiper-container").hide();
	}
});
</script>
</head>
<body class="default-font body-sub body-1depth bg-grey">
<!-- #include virtual="/lib/inc/incHeader.asp" -->
<div id="content" class="content">
	<% If IsGuestLoginOK Then %>
	<div class="order-no">
		<p>비회원 주문번호 <b class="color-red"><%=GetGuestLoginOrderserial%></b></p>
	</div>

	<div class="my10x10-menu column-2">
		<ul>
			<li>
				<a href="/my10x10/order/myorderlist.asp">
					<span class="icon icon-order"></span>
					<span class="name">주문/배송조회</span>
				</a>
			</li>
			<li>
				<a href="/my10x10/qna/myqnalist.asp">
					<span class="icon icon-cs"></span>
					<span class="name">1:1 상담</span>
				</a>
			</li>
		</ul>
	</div>

	<div class="my10x10-menu type-row">
		<ul>
			<li>
				<a href="/cscenter/">
					<span class="name">고객행복센터</span>
					<!-- for dev msg: 주말/공휴일, 평일 점심시간 12:00~13:00에는 현재1:1 상담만이용하실수있습니다. 메시지 넣어주세요 -->
				<!--<p class="state">현재 운영중입니다</p> -->
				</a>
			</li>
		</ul>
	</div>

	<div class="my10x10-menu column-3 member-benefit">
		<h3 class="headline">텐바이텐 회원 혜택</h3>
		<ul>
			<li>
				<span class="icon icon-coupon"></span>
				<p class="desc">신규 고객에게<br /> 무료배송/2천원 쿠폰</p>
			</li>
			<li>
				<span class="icon icon-mileage"></span>
				<p class="desc">회원 등급별<br /> 쿠폰/마일리지 혜택</p>
			</li>
			<li>
				<span class="icon icon-present"></span>
				<p class="desc">다양한 이벤트<br /> 참여 및 사은품 혜택</p>
			</li>
		</ul>

		<div class="btn-group">
			<a href="<%=M_SSLUrl%>/member/join.asp" class="btn btn-red btn-large btn-block">텐바이텐 회원가입</a>
		</div>
	</div>
	<% else %>
	<div id="myProfile" class="my-profile">
		<div onclick="openProfileWriteModal();" class="my-info">
			<div class="pro-img">
				<button type="button" class="img">
					<img src="//fiximage.10x10.co.kr/web2021/anniv2021/m/profile_default.png" alt="default image">
				</button>
				<span class="icon"></span>
			</div>

			<div class="desc">
				<p class="glade"></p>
				<p class="nick-name"></p>
			</div>
		</div>

		<a href="" onclick="cfmLoginout();return false;" class="btn-logout">로그아웃</a>
	</div>

	<div class="my-profile-glade">
		<!-- 등급별 class 전과 동일 -->
		<div class="my-glade <%=GetUserStr(GetLoginUserLevel)%>">
			<P><%=tmpCSLeftMenuUserLevel%></P>
			<div class="bar-container"><span class="bar" style="width:<%=stroke1%>%"></span></div>
		</div>
		<div class="my-profile">
			<% If Not(isBizMode) Then %>
				<a href="/my10x10/userinfo/mygrade.asp" class="btn-arrow">등급 혜택보기</a>
			<% End If %>
		</div>
	</div>

	<div class="my-own">
		<div class="nav nav-stripe nav-stripe-large nav-stripe-red">
			<ul class="grid4">
				<li><a href="" class="on"><span class="name">마일리지</span><b class="no"><%=FormatNumber(getLoginCurrentMileage(),0)%></b></a></li>
				<li><a href=""><span class="name">보유쿠폰</span><b class="no"><%=GetLoginCouponCount%></b></a></li>
				<li><a href=""><span class="name">예치금</span><b class="no"><%= FormatNumber(oTenCash.Fcurrentdeposit,0) %></b></a></li>
				<li><a href=""><span class="name">기프트카드</span><b class="no"><%=formatNumber(currentCash,0)%></b></a></li>
			</ul>
		</div>

		<div id="myownSwiper" class="swiper-container my-own-list">
			<div class="swiper-wrapper">
				<section class="swiper-slide mileage">
					<div class="article">
						<% If cardno <> "" Then %>
						<%'!-- for dev msg : 카드를 발급 받은 회원일 경우 --%>
						<a href="/offshop/point/mileagelist.asp" class="linkarea"><!-- for dev msg : 마일리지 내역으로 링크 -->
							<h2 class="headline">마일리지 내역확인</h2>
							<div class="no"><b class="sum"><%=FormatNumber(getLoginCurrentMileage(),0)%><span lang="en" class="won">P</span></b></div>
							<ul class="detail-list">
								<li><span class="name">온라인</span> <b class="sum"><%=FormatNumber(myMileage.FTotalMileage,0)%><span lang="en" class="won">P</span></b></li>
								<li><span class="name">오프라인</span> <b class="sum"><%=FormatNumber(myOffMileage.FOffShopMileage,0)%><span lang="en" class="won">P</span></b></li>
							</ul>
						</a>
						<div class="btn-membership-card"><a href="/offshop/point/popbarcode.asp">텐바이텐 맴버십카드 보기</a></div>
						<% Else %>
						<%'!-- for dev msg : 카드를 발급 받지 않은 회원일 경우 --%>
						<button type="button" class="btn-membership-card-get" onclick="tencardreg();">
							<span class="headline">멤버십카드 신규 발급</span><span class="icon-plus icon-plus-white"></span>
						</button>
						<% End If %>
						<div class="btn-group">
							<a href="/offshop/point/popcardBenefit.asp" class="btn-half">멤버십 마일리지 안내</a>
							<a href="/offshop/point/popmileagechange.asp" class="btn-half">마일리지 전환</a>				
						</div>
					</div>
				</section>
				<section class="swiper-slide coupon">
					<div class="article">
						<% If left(now(),10) >= "2021-10-05" And left(now(),10) < "2021-11-01" Then %>
							<a href="/my10x10/couponbook.asp?tab=1" class="linkarea">						
						<% Else %>
							<a href="/my10x10/couponbook.asp?tab=2" class="linkarea">
						<% End If %>
							<h2 class="headline">내 쿠폰확인</h2>
							<div class="no"><b class="sum"><%=GetLoginCouponCount%></b><span lang="ko" class="won">장</span></div>
							<ul class="detail-list">
								<li><span class="name">보너스쿠폰</span> <b class="sum"><%= osailcoupon.FTotalCount %><span lang="ko" class="won">장</span></b></li>
								<li><span class="name">상품쿠폰</span> <b class="sum"><%= oitemcoupon.FTotalCount %><span lang="ko" class="won">장</span></b></li>
							</ul>
						</a>
						<a href="/my10x10/changecoupon.asp" class="btn-more-plus">쿠폰등록</a>
						<div class="btn-group">
							<% If left(now(),10) >= "2020-10-05" And left(now(),10) < "2020-10-30" Then %>						
								<a href="/my10x10/couponbook.asp?tab=3" class="btn-half">사용가능한 쿠폰</a>
							<% Else %>
								<a href="/my10x10/couponbook.asp" class="btn-half">사용가능한 쿠폰</a>
							<% End If %>
							<a href="/shoppingtoday/couponshop.asp" class="btn-half">쿠폰북</a>
						</div>
					</div>
				</section>
				<section class="swiper-slide balance">
					<div class="article">
						<a href="/my10x10/deposit/mydepositlist.asp">
							<h2 class="headline">예치금 내역확인</h2>
							<div class="no"><b class="sum"><%= FormatNumber(oTenCash.Fcurrentdeposit,0) %></b><span lang="ko" class="won">원</span></div>
						</a>
						<div class="btn-group">
							<a href="/my10x10/popDeposit.asp" class="btn-half">예치금 안내</a>
							<a href="" onclick="fnOpenModal('/my10x10/deposit/depositapply.asp');return false;" class="btn-half">예치금 반환 신청</a>
						</div>
					</div>
				</section>
				<section class="swiper-slide giftcard">
					<div class="article">
						<a href="/my10x10/giftcard/giftcardUseHistory.asp" class="linkarea">
							<h2 class="headline">기프트카드 사용 내역확인</h2>
							<div class="no"><b class="sum"><%=formatNumber(currentCash,0)%></b><span lang="ko" class="won">원</span></div>
						</a>							
						<div class="btn-giftcard"><a href="/my10x10/giftcard/giftcardBarcode.asp">텐바이텐 기프트카드 보기</a></div>
						<div class="btn-group">
							<a href="/my10x10/giftcard/usageNotice.asp" class="btn-half">기프트카드 안내</a>
							<a href="/my10x10/giftcard/giftCardList.asp" class="btn-half">주문/등록 내역</a>
						</div>
					</div>
				</section>				
<!--
				<section class="swiper-slide giftcard">
					<div class="article">
						<%'!-- for dev msg : 기프트카드 > 사용내역 탭으로 링크 --%>
						<a href="/my10x10/giftcard/giftcardUselist.asp" class="linkarea">
							<h2 class="headline">기프트카드 내역확인</h2>
							<div class="no"><b class="sum"><%=formatNumber(currentCash,0)%></b><span lang="ko" class="won">원</span></div>
						</a>
						<%'!-- for dev msg : 기프트카드 > 카드등록 탭으로 링크 --%>
						<a href="/my10x10/giftcard/giftcardRegist.asp" class="btn-more-plus">기프트카드 &gt; 카드등록</a>
						<div class="btn-group">
							<a href="" onclick="fnOpenModal('/giftcard/act_usageNotice.asp');return false;" class="btn-half">이용안내</a>
							<a href="/giftcard/" class="btn-half">기프트카드 선물</a>
						</div>
					</div>
				</section>
-->				
			</div>
		</div>
	</div>

	<%'!-- for dev msg : 주문/배송조회 및 상품후기 관련 알림 배너 --%>
	<div id="bnrNotification" class="bnr bnr-notification">
		<div class="swiper-container">
			<div class="swiper-wrapper">
			<% If request.cookies("uinfo")("isTester") Then %>
				<div class="swiper-slide tester">
					<a href="/my10x10//mytester/"><p><span class="icon icon-tester"></span><b>테스터 후기</b>를 작성해주세요<span class="icon icon-arrow"></span></p></a>
				</div>
			<% End If %>
				<%'!-- for dev msg : 주문/배송조회 알림 배너 --%>
				<% If mymainClass.FOneItem.FOrderSerial <> "" Then %>
				<div class="swiper-slide order">
					<a href="/my10x10/order/myorderdetail.asp?idx=<%=mymainClass.FOneItem.FOrderSerial%>"><p><span class="icon icon-car"></span>주문하신 <b><span class="ellipsis"><%=mymainClass.FOneItem.FOrderItemNames%></span>
					<%=chkiif(mymainClass.FOneItem.FOrderitemCount > 1,"외 "& mymainClass.FOneItem.FOrderitemCount-1 &"건","")%></b>의 배송이 시작되었습니다<span class="icon icon-arrow"></span></p></a>
				</div>
				<% End If %>
			<% If vMileArr(0,0) > 0 Then %>
				<div class="swiper-slide review review-event">
					<a href="/my10x10/goodsusing.asp"><p><span class="icon icon-mileage<%=chkiif(isdoubleMileage,"x2","")%>"></span><%=chkiif(isdoubleMileage,"[더블 마일리지 이벤트]<br /> ","")%>모든 후기를 작성하면 <b><%=FormatNumber(vMileArr(1,0),0)%>p </b> 적립!<span class="icon icon-arrow"></span></p></a>
				</div>
			<% End If %>
			</div>
			<div class="pagination-dot block-dot"></div>
		</div>
	</div>

	<div class="my10x10-menu column-2">
		<ul>
			<li>
				<a href="/my10x10/order/myorderlist.asp">
					<span class="icon icon-order"></span>
					<span class="name">주문/배송조회</span>
					<% If mycount(0) > 0 Then %>
					<span class="badge"><%=mycount(0)%></span>
					<% End If %>
				</a>
			</li>
			<% if IsUserLoginOK then %>
			<li>
				<a href="/my10x10/goodsusing.asp">
					<span class="icon icon-review"></span>
					<span class="name">상품 후기</span>
					<% If mycount(1) > 0 Then %>
					<span class="badge"><%=mycount(1)%></span>
					<% End If %>
				</a>
			</li>
			<% end if %>
		</ul>
	</div>
	<div class="my10x10-menu type-row">
		<ul>
			<li>
				<a href="/my10x10/qna/myqnalist.asp">
					<span class="icon icon-cs"></span>
					<span class="name">1:1 상담</span>
					<% If mycount(3) > 0 Then %>
					<p class="state">답변이 등록되었습니다</p>
					<% End If %>
				</a>
			</li>
			<li>
				<a href="/my10x10/myitemqna.asp">
					<span class="icon icon-qna"></span>
					<span class="name">상품 Q&amp;A</span>
					<% If mycount(2) > 0 Then %>
					<p class="state">답변이 등록되었습니다</p>
					<% End If %>
				</a>
			</li>
			<li>
				<a href="/my10x10/order/myorder_return_step1.asp">
					<span class="icon icon-ret"></span>
					<span class="name">반품 / 환불</span>
				</a>
			</li>
			<li>
				<a href="/my10x10/order/order_cslist.asp">
					<span class="icon icon-myret"></span>
					<span class="name">내가 신청한 서비스</span>
				</a>
			</li>
			<li>
				<a href="/my10x10/MyAlarmHistory.asp">
					<span class="icon icon-warehousing"></span>
					<span class="name">입고 알림 신청내역</span>
				</a>
			</li>	
			<li>
				<a href="/my10x10/myeventmaster.asp">
					<span class="icon icon-win"></span>
					<span class="name">이벤트 당첨안내</span>
				</a>
			</li>		
			<li>
				<a href="/gift/gifticon/">
					<span class="icon icon-giftchange"></span>
					<span class="name">기프티콘 상품 교환하기</span>
				</a>
			</li>				
			<% if IsUserLoginOK then %>
			<li>
				<a href="/my10x10/myzzimbrand.asp">
					<span class="icon icon-zzim"></span>
					<span class="name">찜브랜드</span>
				</a>
			</li>
			<% end if %>
		</ul>
	</div>

	<% if IsUserLoginOK then %>
	<section id="mywishSwiper" class="my10x10-menu item-carousel-4">
		<h3 class="headline"><a href="/my10x10/myWish/myWish.asp">나의 위시상품</a></h3>
		<% if mymainWishitem.FResultCount > 0 Then %>
		<div class="items swiper-container">
			<ul class="swiper-wrapper">
				<% 
					Dim wi 
					For wi = 0 To (mymainWishitem.FResultCount - 1) 
				%>
				<li class="swiper-slide">
					<a href="<%=chkiif(wi = (mymainWishitem.FResultCount - 1),"/my10x10/mywish/mywish.asp","/category/category_itemprd.asp?itemid="& mymainWishitem.FItemList(wi).Fitemid &"")%>">
						<div class="thumbnail"><img src="<%=mymainWishitem.FItemList(wi).Fbasicimage%>" alt="<%=mymainWishitem.FItemList(wi).Fitemname%>" /></div>
						<%
							If mymainWishitem.FItemList(wi).Fsailyn = "Y" And mymainWishitem.FItemList(wi).FitemcouponYN = "Y" Then
								If mymainWishitem.FItemList(wi).Fitemcoupontype = "1" Then
									'//할인 + %쿠폰
									response.write "<span class=""label label-box bg-green""><b class=""discount"">"& CLng((mymainWishitem.FItemList(wi).Forgprice-(mymainWishitem.FItemList(wi).Fsellcash - CLng(mymainWishitem.FItemList(wi).Fitemcouponvalue*mymainWishitem.FItemList(wi).Fsellcash/100)))/mymainWishitem.FItemList(wi).Forgprice*100)&"%</b></span>"
								ElseIf mymainWishitem.FItemList(wi).Fitemcoupontype = "2" Then
									'//할인 + 원쿠폰
									response.write "<span class=""label label-box bg-red""><b class=""discount"">"& CLng((mymainWishitem.FItemList(wi).Forgprice-(mymainWishitem.FItemList(wi).Fsellcash - mymainWishitem.FItemList(wi).Fitemcouponvalue))/mymainWishitem.FItemList(wi).Forgprice*100)&"%</b></span>"
								Else
									'//할인 + 무배쿠폰
									response.write "<span class=""label label-box bg-green""><b class=""discount"">"& CLng((mymainWishitem.FItemList(wi).Forgprice-mymainWishitem.FItemList(wi).Fsellcash)/mymainWishitem.FItemList(wi).Forgprice*100)&"%</b></span>"
								End If 
							ElseIf mymainWishitem.FItemList(wi).Fsailyn = "Y" and mymainWishitem.FItemList(wi).FitemcouponYN = "N" Then
								If CLng((mymainWishitem.FItemList(wi).Forgprice-mymainWishitem.FItemList(wi).Fsellcash)/mymainWishitem.FItemList(wi).Forgprice*100)> 0 Then
									response.write "<span class=""label label-box bg-red""><b class=""discount"">"& CLng((mymainWishitem.FItemList(wi).Forgprice-mymainWishitem.FItemList(wi).Fsellcash)/mymainWishitem.FItemList(wi).Forgprice*100)&"%</b></span>"
								End If
							elseif mymainWishitem.FItemList(wi).Fsailyn = "N" And mymainWishitem.FItemList(wi).FitemcouponYN = "Y" And mymainWishitem.FItemList(wi).Fitemcouponvalue>0 Then
								If mymainWishitem.FItemList(wi).Fitemcoupontype = "1" Then
									response.write "<span class=""label label-box bg-green""><b class=""discount"">"& CStr(mymainWishitem.FItemList(wi).Fitemcouponvalue) & "%</b></span>"
								End If
							End If
						%>
						<% If wi = (mymainWishitem.FResultCount - 1) Then %>
						<span class="btn-more"><span class="icon-plus icon-plus-white"></span>더보기</span>
						<% End If %>
					</a>
				</li>
				<%
					Next 
				%>
			</ul>
		</div>
		<% End If %>
	</section>
	<% End if%>

	<div class="my10x10-menu column-3">
		<h3 class="headline">나의 정보 관리</h3>
		<ul>
			<% if IsUserLoginOK then %>
			<li>
				<a href="<%=M_SSLUrl%>/my10x10/userinfo/membermodify.asp">
					<span class="icon icon-my"></span>
					<span class="name">개인정보관리</span>
				</a>
			</li>
			<% end if %>
			<li>
				<a href="/my10x10/MyAddress/MyAddressList.asp">
					<span class="icon icon-address"></span>
					<span class="name">주소록 관리</span>
				</a>
			</li>
			<li>
				<a href="/my10x10/MyAnniversary/MyAnniversaryList.asp">
					<span class="icon icon-anniversary"></span>
					<span class="name">기념일 관리</span>
				</a>
			</li>
		</ul>
	</div>

	<div class="customs-center type02">
        <a href="/cscenter/" class="mWeb">
            <div class="tit type02"><span class="txt">고객센터</span> <span class="arrow"></span></div>
            <div class="info-open">
                <div class="info-time">
                    <div class="time">
                        <p class="txt">운영시간</p>
                        <p class="num">10:00 ~ 17:00 <span class="day-off">(주말, 공휴일 휴무)</span></p>
                    </div>
                    <div class="time type02">
                        <p class="txt">점심시간</p>
                        <p class="num02">12:30 ~ 13:30</p>
                    </div>
                </div>
            </div>
        </a>
    </div>
	<% end if %>

	<div id="profileModalArea"></div>
</div>
<% IF application("Svr_Info") = "Dev" THEN %>
<script src="/vue/vue_dev.js"></script>
<% Else %>
<script src="/vue/2.5/vue.min.js"></script>
<% End If %>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>
<script src="/vue/components/common/functions/common.js"></script>
<script src="/vue/components/linker/modal_profile_write.js"></script>
<script>
    const staticImgUpUrl = "<%= staticImgUpUrl %>";
    var userAgent = navigator.userAgent.toLowerCase();

    const profileApp = new Vue({
        el : '#profileModalArea',
        template : /*html*/`
            <MODAL-PROFILE-WRITE v-if="showProfileModal"
                    :myProfile="myProfile" :userId="userId"
                    @closeModal="closeProfileModal" @completePostProfile="completePostProfile"/>
        `,
        data() {return {
            showProfileModal : false, // 프로필 작성 모달 노출 여부
            isLogin : false, // 로그인 여부
            userId : '<%=GetLoginUserID%>', // 유저 ID
            myProfile : {}, // 프로필 데이터
        }},
		methods : {
			completePostProfile() {
				getMyProfile()
			},
			openProfileModal() {
			    document.querySelector('body').classList.add('noscroll');
			    this.showProfileModal = true;
			},
			closeProfileModal() {
			    document.querySelector('body').classList.remove('noscroll');
			    this.showProfileModal = false;
			},
		}
    });

    let myProfile;
	function getMyProfile() {
		const success = function(data) {
			myProfile = $('#myProfile');
			profileApp.myProfile = data;
			if( data.auth !== 'N' && data.description != null ) {
			    myProfile.find('.glade').text(data.description);
			}
			if( data.registration ) {
			    myProfile.find('.nick-name').text(data.nickName);
			    if( data.image ) {
			        myProfile.find('img').attr('src', data.image);
			    } else {
			        myProfile.find('img').attr('src',`//fiximage.10x10.co.kr/web2015/common/img_profile_${data.avataNo < 10 ? '0' : ''}${data.avataNo}.png`);
			    }
			} else {
			    myProfile.find('.nick-name').text('프로필 입력하기');
			}

			profileApp.closeProfileModal();
		}
		getFrontApiData('GET', '/user/profile', null, success);
	}

	function openProfileWriteModal() {
	    profileApp.openProfileModal();
	}

	getMyProfile();
</script>
<!-- #include virtual="/lib/inc/incfooter.asp" -->
</body>
</html>
<%
	set oTenCash = Nothing
	Set myMileage = Nothing
	Set myOffMileage = Nothing
	set osailcoupon = Nothing
	set oitemcoupon = Nothing
	Set mymainClass = Nothing 
	Set mymainWishitem = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->