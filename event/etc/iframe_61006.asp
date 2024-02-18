<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  위시리스트를 부탁해
' History : 2015.04.03 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/event/etc/event61006Cls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%

	dim eCode, linkeCode, subscriptcount, userid
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  "21536"
		linkeCode   =  "21537"
	Else
		eCode   =  "61006"
		linkeCode   =  "61007"
	End If

	Dim ename, emimg, cEvent, blnitempriceyn
	set cEvent = new ClsEvtCont
	cEvent.FECode = eCode
	cEvent.fnGetEvent
	
	eCode		= cEvent.FECode	
	ename		= cEvent.FEName
	emimg		= cEvent.FEMimg
	blnitempriceyn = cEvent.FItempriceYN	
set cEvent = nothing

userid = getloginuserid()

Dim ifr, page, i, y
page = request("page")

If page = "" Then page = 1

set ifr = new evt_wishfolder
	ifr.FPageSize = 4
	ifr.FCurrPage = page
	ifr.FeCode = eCode
	
	ifr.Frectuserid = userid
	
	'if eCode<>"" and userid<>"" then
		ifr.evt_wishfolder_list
	'end if

%>
<!-- #include virtual="/lib/inc/head.asp" -->

<style type="text/css">
img {vertical-align:top;}
.topic {padding-top:8%; background:#fdf5d6 url(http://webimage.10x10.co.kr/eventIMG/2015/61006/bg_pattern.png) repeat-y 50% 0; background-size:100% auto;}
.topic .btnwish {width:89%; margin:5% auto 0;}
.hint {background-color:#fff;}
.swiper {position:relative; width:320px; margin:0 auto;}
.swiper .swiper-container {overflow:hidden; position:relative;}
.swiper .swiper-wrapper {overflow:hidden;}
.swiper .swiper .swiper-slide {float:left;}
.pagination {position:absolute; bottom:25px; left:0; width:100%;}
.pagination .swiper-pagination-switch {width:10px; height:10px; margin:0 2px; background-color:#fff; cursor:pointer;}
.pagination .swiper-active-switch {background-color:#e33840;}
.swiper button {position:absolute; top:6%; z-index:50; width:33px; background-color:transparent;}
.swiper button span {overflow:hidden; width:0; height:0; font-size:0; line-height:0; text-indent:-9999px;}
.swiper .prev {left:10px;}
.swiper .next {right:10px;}
.item {margin-top:-10px; padding-bottom:9px; background-color:#fff;}
.item .folder {padding:20px 0 10px; background-color:#a2cef6; text-align:center;}
.item .folder .ico img {width:21px;}
.item .folder .letter img {width:169px;}
.item .folder img {vertical-align:middle;}
.item .folder strong {color:#336491; font-size:14px;}
.item ul {overflow:hidden; width:303px; height:200px; margin:9px auto 0; background:#fff url(http://webimage.10x10.co.kr/eventIMG/2015/61007/bg_smile.png) no-repeat 50% 0; background-size:303px 200px;}
.item ul li {float:left; width:98px; height:98px; margin-top:1px; margin-bottom:2px; margin-right:4px;}
.item ul li:nth-child(1) {margin-left:1px;}
.item ul li:nth-child(3) {margin-right:0;}
.item ul li:nth-child(4) {margin-left:1px;}
.item ul li:nth-child(6) {margin-right:0;}
.item ul li img {width:98px; height:98px;}
.item +.way {margin-top:0;}
.way {margin-top:-10px; padding-top:10px; background-color:#d5f8ff;}
.noti {padding:20px 10px; background-color:#eee;}
.noti h2 {color:#222; font-size:14px;}
.noti h2 strong {margin:0 3px; padding-bottom:2px; border-bottom:2px solid #000;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; padding-left:10px; color:#444; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:8px; left:0; width:4px; height:1px; background-color:#444;}
@media all and (min-width:360px){
	.swiper {width:360px;}
}
@media all and (min-width:480px){
	.swiper {width:480px;}
	.swiper button {width:50px;}
	.item {margin-top:-20px;}
	.item .folder {padding:40px 0 20px;}
	.item .folder .ico img {width:31px;}
	.item .folder .letter img {width:253px;}
	.item .folder strong {font-size:21px;}
	.item {padding-bottom:15px;}
	.item ul {overflow:hidden; width:411px; height:271px; margin:15px auto 0; background:#fff url(http://webimage.10x10.co.kr/eventIMG/2015/61007/bg_smile.png) no-repeat 50% 0; background-size:411px 271px;}
	.item ul li {float:left; width:133px; height:133px; margin-bottom:2px; margin-right:5px;}
	.item ul li:nth-child(3) {margin-right:0;}
	.item ul li:nth-child(6) {margin-right:0;}
	.item ul li img {width:133px; height:133px;}
	.way {margin-top:-20px; padding-top:20px;}
	.noti {padding:25px 15px;}
	.noti ul {margin-top:16px;}
	.noti h2 {font-size:17px;}
	.noti ul li {margin-top:2px; font-size:13px;}
	.noti ul li:after {top:8px;}
}
@media all and (min-width:768px){
	.swiper {width:640px;}
	.noti h2 {font-size:20px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:4px; font-size:16px;}
	.noti ul li:after {top:12px;}
}
</style>
<script type="text/javascript">

function jsGoPage(iP){
	document.pageFrm.page.value = iP;
	document.pageFrm.submit();
}

function jsSubmit(){
	<% If IsUserLoginOK() Then %>
		<% If Now() > #04/12/2015 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If getnowdate>="2015-04-06" and getnowdate<"2015-04-13" Then %>
				var frm = document.frm;
				frm.action="/my10x10/event/myfavorite_folderProc.asp";
				frm.hidM.value='Z';
				frm.submit();
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% end if %>
		<% end if %>
	<% else %>
		<% if isApp then %>
			parent.calllogin();
		<% else %>
			parent.jsevtlogin();
		<% end if %>
	<% end if %>
}

function jsViewItem(i){
	<% if isApp=1 then %>
		parent.fnAPPpopupProduct(i);
		return false;
	<% else %>
		top.location.href = "/category/category_itemprd.asp?itemid="+i+"";
		return false;
	<% end if %>
}

function jsmywishlist(){
	<% if isApp=1 then %>
		parent.fnAPPpopupBrowserURL('마이텐바이텐','<%=wwwUrl%>/<%=appUrlPath%>/my10x10/myWish/myWish.asp');
		return false;
	<% else %>
		top.location.href = "/my10x10/myWish/myWish.asp";
		return false;
	<% end if %>
}

function jsmycoupon(){
	<% if isApp=1 then %>
		parent.fnAPPpopupBrowserURL('마이텐바이텐','<%=wwwUrl%>/<%=appUrlPath%>/my10x10/couponbook.asp');
		return false;
	<% else %>
		top.location.href = "/my10x10/couponbook.asp";
		return false;
	<% end if %>
}

</script>
<%
Dim sp, spitemid, spimg
Dim arrCnt, foldername

	foldername = "위시리스트를 부탁해"
	Dim strSql, vCount, vFolderName, vViewIsUsing
	vCount = 0

	strSql = "Select COUNT(fidx) From [db_my10x10].[dbo].[tbl_myfavorite_folder]  WHERE foldername = '" & trim(foldername) & "' and userid='" & userid & "' "
	'response.write strSql
	rsget.Open strSql,dbget,1
	IF Not rsget.Eof Then
		vCount = rsget(0)
	else
		vCount = 0
	END IF
	rsget.Close

%>
</head>
<body>
<form name="frm" method="post">
<input type="hidden" name="hidM" value="Z">
	<div class="mEvt61007">
		<div class="topic">
			<h1><img src="http://webimage.10x10.co.kr/eventIMG/2015/61007/tit_whis_list.png" alt="본격 위시리스트 담는 이벤트! 위시리스트를 부탁해!" /></h1>
			<div class="btnwish"><a href="" onclick="jsSubmit(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61007/btn_wish.png" alt="" /></a></div>
		</div>

		<div class="hint">
			<div class="swiper">
				<div class="swiper-container swiper1">
					<div class="swiper-wrapper">
						<!-- for dev msg : 해당 날짜나 이전 힌트만 보여주세요! -->
						<div class="swiper-slide">
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/61007/img_hint_01.png" alt="MONDAY 다음 힌트에 맞는 상품 1개를 찾아서 담아 주세요. 홈 인테리어 &gt; 조명 카테고리 속 인기 상품, 텐바이텐의 동그란 로고와 같은 컬러 코를 올리면 불이 켜지면서 SMILE" />
						</div>
						<% If getnowdate>="2015-04-07" Then %>
							<div class="swiper-slide">
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/61007/img_hint_02.png" alt="TUESDAY 갖고 싶었던 상품을 10개만 담아 주세요. 3개 이상의 카테고리에서 골라 보기, 컬러만 다른 같은 상품은 댓츠 노노!, 아쉽지만 품절된 상품은 아웃 오브 위시!" />
							</div>
						<% end if %>
						<% If getnowdate>="2015-04-08" Then %>
							<div class="swiper-slide">
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/61007/img_hint_03.png" alt="WEDNESDAY 푸드 카테고리 상품을 3개만 담아 주세요. 평소 당신이 자주 먹을 수 없지만 먹어보고 싶은 것, 푸드 카테고리의 BEST 상품들을 강력추천!, 비슷한 상품보단 전혀 다른 상품으로 다양하게 담기" />
							</div>
						<% end if %>
						<% If getnowdate>="2015-04-09" Then %>
							<div class="swiper-slide">
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/61007/img_hint_04.png" alt="THURSDAY 애인이 생기면 사주고 싶은 선물로 3가지를 담아 주세요. 없어도 있는 것처럼 고심해서 정성스럽게 고르기, 금액은 상관없이 일단 고르고 나서 슬퍼하기, 내가 갖고 싶은 건 참아주세요. 상상 속 애인을 위해서!" />
							</div>
						<% end if %>
						<% If getnowdate>="2015-04-10" Then %>
							<div class="swiper-slide">
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/61007/img_hint_05.png" alt="FRIDAY 단 하나만 가질 수 있다면 갖고 싶은 상품 1개만 담아 주세요. 누군가에게 선물 할 생각은 말고 오직 당신을 위해서!, 갖고 싶어서 장바구니에 까지 담았던 상품, 3개월 안에 결제할 것 같은 상품으로 쏙!" />
							</div>
						<% end if %>
						<% If getnowdate>="2015-04-11" Then %>
							<div class="swiper-slide">
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/61007/img_hint_06.png" alt="STA&amp;SUN 다음 힌트에 맞는 상품 2개를 찾아서 담아 주세요. 텐바이텐 PLAY Ground에서 만날 수 있는 상품, 열 여덟번째 주제 PLATE를 테마로 만든 텐바이텐 상품, 음식을 담고 재미있게 놀 수 있는 특별한 상품" />
							</div>
						<% end if %>
					</div>
					<div class="pagination"></div>
				</div>
				<button type="button" class="prev"><span>이전</span><img src="http://webimage.10x10.co.kr/eventIMG/2015/61007/btn_prev.png" alt="이전" /></button>
				<button type="button" class="next"><span>다음</span><img src="http://webimage.10x10.co.kr/eventIMG/2015/61007/btn_next.png" alt="다음" /></button>
			</div>
		</div>

		<!-- for dev msg : 개인위시 -->
		<% If IsUserLoginOK() Then %>
			<% if vCount > 0 then %>
				<div class="item">
					<p class="folder">
						<span class="ico"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61007/ico_cart.png" alt="" /></span>
						<strong><%= userid %></strong>
						<span class="letter"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61007/txt_folder.png" alt="<%= userid %>님의 위시리스트를 부탁해 위시 폴더" /></span>
					</p>
					<ul>
					<% if ifr.FmyTotalCount > 0 then %>
						<%
							if isarray(Split(ifr.Fmylist,",")) then
								arrCnt = Ubound(Split(ifr.Fmylist,","))
							else
								arrCnt=0
							end if

							If ifr.FmyTotalCount > 5 Then
								arrCnt = 6
							Else
								arrCnt = ifr.FmyTotalCount
							End IF

							For y = 0 to CInt(arrCnt) - 1
								sp = Split(ifr.Fmylist,",")(y)
								spitemid = Split(sp,"|")(0)
								spimg	 = Split(sp,"|")(1)
						%>
						<li><a href="" onClick="jsViewItem('<%=spitemid%>'); return false;"><img src="http://webimage.10x10.co.kr/image/icon2/<%=GetImageSubFolderByItemid(spitemid)%>/<%=spimg%>" alt="" /></a></li>
						<%
							Next
						%>
					<% end if %>
					</ul>
				</div>
			<% else %>
				<div class="way">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/61007/txt_way.png" alt="이벤트 참여 방법은 이벤트 페이지에서 미션을 확인 후 텐바이텐 미션에 맞는 상품을 고르고 위시리스트를 부탁해 폴더에 담으면 됩니다. 매일 담아야하는 미션이 달라지며, 본 페이지에서 폴더 생성 후 담아야합니다. 전일의 미션을 수행할 수 있지만 요일의 순차로 담아야 하며, 2015년 4월 16일 오전 10시까지 담겨져 있는 상품을 기준으로 합니다." /></p>
				</div>
			<% end if %>
		<% else %>
			<div class="way">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/61007/txt_way.png" alt="이벤트 참여 방법은 이벤트 페이지에서 미션을 확인 후 텐바이텐 미션에 맞는 상품을 고르고 위시리스트를 부탁해 폴더에 담으면 됩니다. 매일 담아야하는 미션이 달라지며, 본 페이지에서 폴더 생성 후 담아야합니다. 전일의 미션을 수행할 수 있지만 요일의 순차로 담아야 하며, 2015년 4월 16일 오전 10시까지 담겨져 있는 상품을 기준으로 합니다." /></p>
			</div>
		<% end if %>

		<div class="noti">
			<h2><strong>이벤트 안내</strong></h2>
			<ul>
				<li>참여하기 클릭 시, 위시리스트에 &lt;위시리스트를 부탁해&gt; 폴더가 자동 생성됩니다.</li>
				<li>본 이벤트에서 참여하기를 클릭하셔야만 이벤트 참여가 가능합니다.</li>
				<li>수동으로 생성하시거나 기존에 있던 폴더의 이름을 수정하면 이벤트 참여가 불가합니다.</li>
				<li>위시리스트에 &lt;위시리스트를 부탁해&gt; 폴더는 한 ID당 1개만 생성할 수 있습니다.</li>
				<li>최소 5개 이상의 상품을 담아주셔야 당첨이 됩니다.</li>
				<li>해당 폴더 외에 다른 폴더명에 담으시는 상품은 참여 및 증정 대상에서 제외됩니다.</li>
				<li>당첨자에 한해 개인정보를 요청하게 되며, 개인정보 확인 후 경품이 지급됩니다.</li>
				<li>본 이벤트는 종료일인 4월 16일 오전 10시까지 담겨있는 상품을 기준으로 선정합니다.</li>
			</ul>
		</div>
	</div>
</form>
<!-- for dev msg : body 끝나기전에 js 넣어주세요 -->
<script type="text/javascript" src="/lib/js/jquery.swiper-2.1.min.js"></script>
<script type="text/javascript">
$(function(){
	$('.prev').hide();
	if ($('.swiper1 .swiper-wrapper .swiper-slide').length > 1) {
		mySwiper = new Swiper('.swiper1',{
			loop:false,
			resizeReInit:true,
			calculateHeight:true,
			pagination:false,
			paginationClickable:true,
			speed:1000,
			autoplay:false,
			autoplayDisableOnInteraction: true,
			allowSwipeToPrev:true,
			onSlideChangeEnd: function () {
				$('.prev').show()
				$('.next').show()
				if(mySwiper.activeIndex==0){
					$('.prev').hide()
				}
				if(mySwiper.activeIndex==mySwiper.slides.length-1){
					$('.next').hide()
				}
			}
		});
	} else {
		$('.prev').hide();
		$('.next').hide();
	}

	
	$('.prev').on('click', function(e){
		e.preventDefault()
		mySwiper.swipePrev()
	});
	$('.next').on('click', function(e){
		e.preventDefault()
		mySwiper.swipeNext()
	});

	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			mySwiper.reInit();
				clearInterval(oTm);
			}, 500);
	});

});
</script>
</body>
</html>
<form name="pageFrm" method="get" action="<%=CurrURL()%>">
<input type="hidden" name="page" value="">
</form>
<!-- #include virtual="/lib/db/dbclose.asp" -->
