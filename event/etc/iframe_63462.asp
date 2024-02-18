<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : [연속구매] 퐁당퐁당 
' History : 2015-06-10 원승현
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
'Dim prveCode
dim eCode, vUserID, userid, myuserLevel, vPageSize, vPage, sqlStr, vTotalCount, vTotalSum, eLinkCode, prvCount, prvTotalcount
	vUserID = GetLoginUserID()
	myuserLevel = GetLoginUserLevel
	userid = vUserID

	IF application("Svr_Info") = "Dev" THEN
		eCode = "63785"
'		prveCode = "60693"
	Else
		eCode = "63462"
'		prveCode = "60693"
	End If

	If vUserID = "" Then
		If isapp = "1" Then 
			response.write "<script>parent.calllogin();</script>"
		Else
			response.write "<script>parent.jsevtlogin();</script>"
		End If 
		dbget.close()
	    response.end
	End If

Dim vQuery, vCount
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' AND evt_code = '" & eCode & "' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		vCount = rsget(0)
	End IF
	rsget.close

	'//6월 구매 내역 체킹 (응모는 6월 구매고객만 가능)
	sqlStr = " EXEC [db_order].[dbo].[sp_Ten_MyOrderList_SUM] '" & userid & "', '', '', '2015-06-01', '2015-07-01', '10x10', '', 'issue' "
	rsget.CursorLocation = adUseClient
	rsget.CursorType = adOpenStatic
	rsget.LockType = adLockOptimistic
	rsget.Open sqlStr,dbget,1
		vTotalCount = rsget("cnt")
		vTotalSum   = CHKIIF(isNull(rsget("tsum")),0,rsget("tsum"))
	rsget.Close

	'// 기존 이벤트에 응모 하였는지 확인
'	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' AND evt_code = '"&prveCode&"' "
'	rsget.Open vQuery,dbget,1
'	IF Not rsget.Eof Then
'		prvCount = rsget(0)
'	End IF
'	rsget.close

%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.app {display:none;}
.mEvt61957 h1 {visibility:hidden; width:0; height:0;}
.buyHistory .welcome {position:relative;}
.buyHistory .welcome ul {position:absolute; top:26%; left:42%; width:45%; height:27%; padding-top:3%; border-top:1px solid #8f8f8f; border-bottom:1px solid #8f8f8f;}
.buyHistory .welcome ul li {padding-top:4%;}
.buyHistory .welcome ul li:after {content:' '; display:block; clear:both;}
.buyHistory .welcome ul li span {vertical-align:top;}
.buyHistory .welcome ul li img {vertical-align:top;}
.buyHistory .welcome ul li strong {display:inline-block; min-width:10px; height:10px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/58924/ico_star.gif) right top no-repeat; background-size:150px auto; font-size:12px; line-height:13px; text-align:right; vertical-align:top; }
.buyHistory .welcome ul li strong em {padding-left:10px; background:#fff; color:#e33840;}
.buyHistory .welcome ul li .ftLt img {width:46px;}
.buyHistory .welcome ul li .ftRt img {width:9px; margin-left:5px;}
.buyHistory .welcome .btnconfirm {position:absolute; bottom:17%; left:50%; width:74%; margin-left:-37%;}
.buyHistory .welcome .btnconfirm span {overflow:hidden; width:0; height:0; font-size:0; line-height:0; text-indent:-9999px;}

.rolling {padding-top:8%; background-color:#fff;}
.swiper {position:relative; width:320px; margin:0 auto;}
.swiper .swiper-container {overflow:hidden; position:relative; width:320px;}
.swiper .swiper-wrapper {overflow:hidden;}
.swiper .swiper .swiper-slide {float:left;}
.pagination {position:absolute; bottom:25px; left:0; width:100%;}
.pagination .swiper-pagination-switch {width:10px; height:10px; margin:0 4px; background-color:#fff; cursor:pointer;}
.pagination .swiper-active-switch {background-color:#e33840;}
.swiper button {position:absolute; top:50%; width:36px; margin-top:-18px; background-color:transparent;}
.swiper button span {overflow:hidden; width:0; height:0; font-size:0; line-height:0; text-indent:-9999px;}
.swiper .prev {left:10px;}
.swiper .next {right:10px;}
.rolling .desc {width:320px; margin:0 auto;}

.apply {padding:8% 0 7%; background:#fdff7b url(http://webimage.10x10.co.kr/eventIMG/2015/63462/bg_yellow.png) no-repeat 50% 0; background-size:100% auto; text-align:center;}
.apply button {width:289px; height:53px; background:#d60000 url(http://webimage.10x10.co.kr/eventIMG/2015/60693/btn_apply.png) no-repeat 0 0; background-size:100% auto; text-indent:-999em;}
.noti {padding:25px 15px 30px; background:#fff; font-size:12px;}
.noti strong {display:inline-block; margin-bottom:13px; padding-bottom:1px; border-bottom:2px solid #222; color:#222; font-size:14px; font-weight:bold;}
.noti ul li {position:relative; margin-top:3px; padding-left:7px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/58924/blt_arrow.gif) 0 4px no-repeat; background-size:3px auto; color:#000; font-size:11px; line-height:1.5em; }

@media all and (min-width:360px){
	.swiper {width:360px;}
	.swiper .swiper-container {width:360px;}
	.rolling .desc {width:360px;}
}

@media all and (min-width:480px){
	.swiper {width:480px;}
	.swiper .swiper-container {width:480px;}
	.rolling .desc {width:480px;}
	.buyHistory .welcome ul li {padding-top:6%;}
	.buyHistory .welcome ul li strong {min-width:15px; height:15px; background-size:230px auto; font-size:18px; line-height:20px;}
	.buyHistory .welcome ul li strong em {padding-left:15px;}
	.buyHistory .welcome ul li .ftLt img {width:69px;}
	.buyHistory .welcome ul li .ftRt img {width:14px; margin-left:7px;}
	.apply button {width:434px; height:80px;}
	.noti {padding:38px 23px 45px; font-size:18px;}
	.noti strong {margin-bottom:20px; font-size:21px;}
	.noti ul li {padding-left:17px; background-position:0 7px; background-size:6px auto; font-size:17px;}
}
@media all and (min-width:768px){
	.buyHistory .welcome ul {border-top:2px solid #8f8f8f; border-bottom:2px solid #8f8f8f;}
	.swiper button {width:54px; margin-top:-27px;}
	.pagination .swiper-pagination-switch {width:12px; height:12px; margin:0 5px;}
}
</style>
<script>
	function jsSubmitComment(){
	var frm = document.frmGubun2;

	<% If vUserID = "" Then %>
		<% If isapp="1" Then %>
		parent.calllogin();
		return;
		<% else %>
		parent.jsevtlogin();
		return;
		<% End If %>
	<% End If %>

	<% If Now() > #06/21/2015 23:59:59# Then %>
		alert("이벤트가 종료되었습니다.");
		return;
	<% Elseif Now() < #06/10/2015 00:00:00# Then %>
		alert("이벤트 기간이 아닙니다.");
		return;
	<% else %>
		<% If vUserID <> "" Then %>
			<% if vTotalCount > 0 and vTotalSum > 0 then %>
				<% if vCount = 0 then %>
				var totcnt , totsum
				totcnt = $("#totcnt").text();
				totsum = $("#totsum").text();

				if (totcnt == "0" && totcnt == "0" ){
					alert('먼저 구매 내역 확인버튼을 눌러주세요');
					return;
				}else{
					frm.action = "/event/etc/doeventsubscript/doEventSubscript63462.asp";
					frm.submit();
				}
				<% else %>
				alert("이미 응모 하셨습니다.");
				return;
				<% End If %>
			<% else %>
				alert("응모 대상자가 아닙니다.");
				return;
			<% End If %>
		<% End If %>
	<% End if %>
}

function chkmyorder(){
	var rstStr = $.ajax({
		type: "POST",
		url: "/event/etc/doeventsubscript/doEventSubscript63462.asp",
		data: "mode=myorder",
		dataType: "text",
		async: false
	}).responseText;
		$("#tempdiv").empty().append(rstStr);
		$("#totcnt").css("display","block");
		$("#totsum").css("display","block");
		$("#totcnt").text($("div#tcnt").text());
		$("#totsum").text($("div#tsum").text());
}
</script>
</head>
<body>

<div class="mEvt61957">
	<h1>퐁당퐁당</h1>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/63462/tit_pongdang_v2.png" alt ="6워의 구매내역을 확인하세요! 추첨울 통해 100명에세 치즈퐁당 초코퐁당 퐁듀세트를 보내드립니다. 이벤트 기간은 6월 11일부터 6월 17일까지며, 당첨자 발표는 7월 1일입니다." /></p>
	<!-- 구매내역 확인 -->
	<div class="buyHistory">
		<div class="welcome">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/63462/txt_history.png" alt ="6월 고객님의 구매내역을 확인하세요!" /></p>
			<ul>
				<li>
					<span class="ftLt"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58924/txt_count.gif" alt ="구매횟수" /></span>
					<span class="ftRt"><strong><em id="totcnt" style="display:none;">0</em></strong><img src="http://webimage.10x10.co.kr/eventIMG/2015/58924/txt_num.gif" alt ="회" /></span>
				</li>
				<li>
					<span class="ftLt"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58924/txt_price.gif" alt ="구매금액" /></span>
					<span class="ftRt"><strong><em id="totsum" style="display:none;">0</em></strong><img src="http://webimage.10x10.co.kr/eventIMG/2015/58924/txt_won.gif" alt ="원" /></span>
				</li>
			</ul>
			<button type="button" class="btnconfirm" onclick="chkmyorder();return false;"><span>확인하기</span><img src="http://webimage.10x10.co.kr/eventIMG/2015/63462/btn_confirm.png" alt="" /></button>
		</div>
		<p class="present"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63462/txt_present.png" alt ="6월의 PRESENT 확인하고 응모하세요! 구매내역이 있으시면 선물을 확인하고, 하단의 응모하기를 누르세요! 7월 1일 당첨자가 발표됩니다!" /></p>
	</div>
	<!--// 구매내역 확인 -->

	<div class="rolling">
		<div class="swiper">
			<div class="swiper-container swiper1">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<a href="/category/category_itemprd.asp?itemid=256985" target="_top" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63462/img_slide_01.jpg" alt="퐁당퐁당 퐁듀세트" /></a>
						<a href="" onclick="parent.fnAPPpopupProduct('256985');return false;" target="_top" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63462/img_slide_01.jpg" alt="퐁당퐁당 퐁듀세트" /></a>
					</div>
					<div class="swiper-slide">
						<a href="/category/category_itemprd.asp?itemid=256985" target="_top" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63462/img_slide_02.jpg" alt="" /></a>
						<a href="" onclick="parent.fnAPPpopupProduct('256985');return false;" target="_top" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63462/img_slide_02.jpg" alt="" /></a>
					</div>
					<div class="swiper-slide">
						<a href="/category/category_itemprd.asp?itemid=256985" target="_top" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63462/img_slide_03.jpg" alt="" /></a>
						<a href="" onclick="parent.fnAPPpopupProduct('256985');return false;" target="_top" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63462/img_slide_03.jpg" alt="" /></a>
					</div>
				</div>
				<div class="pagination"></div>
			</div>
			<button type="button" class="prev"><span>이전</span><img src="http://webimage.10x10.co.kr/eventIMG/2015/63462/btn_prev.png" alt="이전" /></button>
			<button type="button" class="next"><span>다음</span><img src="http://webimage.10x10.co.kr/eventIMG/2015/63462/btn_next.png" alt="다음" /></button>
		</div>
		<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63462/txt_slide.png" alt="퐁당퐁당 퐁듀세트" /></p>
	</div>

	<!-- 응모하기 -->
	<form name="frmGubun2" method="post" style="margin:0px;" target="prociframe">
	<input type="hidden" name="mode" value="add"  />
		<div class="apply" onClick="jsSubmitComment(); return false;">
			<button type="button">응 모 하 기</button>
		</div>
	</form>
	<!--// 응모하기 -->

	<div class="noti">
		<strong>이벤트 유의사항</strong>
		<ul>
			<li>이벤트는 app푸쉬 또는 SMS로 이벤트 안내를 받으신 회원님만을 위한 헤택입니다.</li>
			<li>응모하기는 이벤트 기간 중 1회만 가능합니다.</li>
			<li>6월 구매내역이 있어야 응모하기가 가능합니다.</li>
			<li>환불이나 교환으로 인해 구매횟수나 구매금액이 충족되지 않을 경우 응모는 자동 취소 됩니다.</li>
			<li>이벤트는 조기종료 될 수 있습니다.</li>
		</ul>
	</div>
	<div id="tempdiv" style="display:none;"></div>
	<iframe name="prociframe" id="prociframe" frameborder="0" width="0px" height="0px"></iframe>
</div>
<script type="text/javascript" src="/lib/js/jquery.swiper-2.1.min.js"></script>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		pagination:'.pagination',
		paginationClickable:true,
		speed:1000,
		autoplay:5000,
		autoplayDisableOnInteraction: true,
	});
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

	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
			$(".app").show();
			$(".mo").hide();
	}else{
			$(".app").hide();
			$(".mo").show();
	}
});
</script>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->