<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : [연속구매] 텐바이텐을 #Tag 하다 
' History : 2015-05-18 유태욱
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
		eCode = "61789"
'		prveCode = "60693"
	Else
		eCode = "62566"
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

	'//5월 구매 내역 체킹 (응모는 5월 구매고객만 가능)
	sqlStr = " EXEC [db_order].[dbo].[sp_Ten_MyOrderList_SUM] '" & userid & "', '', '', '2015-05-01', '2015-06-01', '10x10', '', 'issue' "
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
.buyHistory .welcome {position:relative;}
.buyHistory .welcome ul {position:absolute; top:32%; left:42%; width:45%; height:27%; padding-top:3%; border-top:1px solid #8f8f8f; border-bottom:1px solid #8f8f8f;}
.buyHistory .welcome ul li {padding-top:4%;}
.buyHistory .welcome ul li:after {content:' '; display:block; clear:both;}
.buyHistory .welcome ul li span {vertical-align:top;}
.buyHistory .welcome ul li img {vertical-align:top;}
.buyHistory .welcome ul li strong {display:inline-block; min-width:10px; height:10px; text-align:right; font-size:12px; line-height:13px; vertical-align:top; background:url(http://webimage.10x10.co.kr/eventIMG/2015/58924/ico_star.gif) right top no-repeat; background-size:150px auto;}
.buyHistory .welcome ul li strong em {color:#e33840; padding-left:10px; background:#fff;}
.buyHistory .welcome ul li .ftLt img {width:46px;}
.buyHistory .welcome ul li .ftRt img {width:9px; margin-left:5px;}
.buyHistory .welcome .btnconfirm {position:absolute; bottom:14.47%; left:50%; width:74%; margin-left:-37%;height:17.59%; background-color:#424242; color:#fff; font-weight:bold; font-size:15px;}
.rolling {padding-top:4.91%; background-color:#cafdff;}
.swiper {position:relative; width:295px; margin:0 auto; border:1px solid #bef2fa; padding:8px; background-color:#fff;}
.swiper:before {display:block; clear:both; position:absolute; left:-4px; top:-4px; content:''; width:18px; height:18px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/62566/slide_deco.png) no-repeat 0 0; background-size:100% auto; z-index:10;}
.swiper:after {display:block; clear:both; position:absolute; right:-4px; bottom:-4px; content:''; width:18px; height:18px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/62566/slide_deco.png) no-repeat 0 0; background-size:100% auto; z-index:10;}
.swiper .swiper-container {overflow:hidden; position:relative;}
.swiper .swiper-wrapper {overflow:hidden;}
.swiper .swiper .swiper-slide {float:left;}
.pagination {position:absolute; bottom:10px; left:0; width:100%;}
.pagination .swiper-pagination-switch {width:6px; height:6px; margin:0 3px; background-color:#fff; cursor:pointer;}
.pagination .swiper-active-switch {background-color:#ff9532;}
.swiper button {position:absolute; top:50%; width:27px; height:33px; margin-top:-12px; background-color:transparent;}
.swiper button span {display:block; overflow:hidden; width:27px; height:33px; font-size:0; line-height:0; text-indent:-9999px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/62566/slide_navi.png); background-repeat:no-repeat; background-size:271px 33px;}
.swiper .prev {left:14px;}
.swiper .prev span {background-position:0 50%;}
.swiper .next {right:10px;}
.swiper .next span {background-position:100% 50%;}
.rolling .desc {padding-top:3.68%;}
.apply {position:relative; padding-bottom:30.46%; background:#fff1e6 url(http://webimage.10x10.co.kr/eventIMG/2015/62566/btn_bg.png) no-repeat 0 0; background-size:100% auto; text-align:center;}
.apply button {position:absolute; width:90.6%; height:54.35%; left:4.6875%; top:17.43%; background:#d60000; color:#fff; font-weight:bold; font-size:16px;}
.noti {padding:25px 15px 30px; font-size:12px; background:#fff;}
.noti strong {display:inline-block; font-size:14px; font-weight:bold; color:#222; padding-bottom:1px; margin-bottom:13px; border-bottom:2px solid #222;}
.noti ul li {position:relative; color:#000; font-size:11px; line-height:1.3; padding-left:7px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/58924/blt_arrow.gif) 0 4px no-repeat; background-size:3px auto;}
@media all and (min-width:375px){
	.swiper {width:344px;}
}
@media all and (min-width:480px){
	.buyHistory .welcome ul li strong {min-width:15px; height:15px; font-size:18px; line-height:20px; background-size:220px auto;}
	.buyHistory .welcome ul li strong em {padding-left:15px;}
	.buyHistory .welcome ul li .ftLt img {width:69px;}
	.buyHistory .welcome ul li .ftRt img {width:13px; margin-left:7px;}
	.buyHistory .welcome .btnconfirm {font-size:22px;}
	.swiper {width:442px; padding:12px;}
	.swiper:before {left:-6px; top:-6px; width:27px; height:27px;}
	.swiper:after {right:-6px; bottom:-6px; width:27px; height:27px;}
	.pagination {bottom:15px;}
	.pagination .swiper-pagination-switch {width:9px; height:9px; margin:0 4px;}
	.swiper button {width:40px; height:49px; margin-top:-18px;}
	.swiper button span {width:40px; height:49px; background-size:406px 49px;}
	.swiper .prev {left:21px;}
	.swiper .next {right:14px;}
	.apply button {font-size:24px;}
	.noti {padding:38px 23px 45px; font-size:18px;}
	.noti strong {margin-bottom:20px; font-size:21px;}
	.noti ul li {background-position:0 7px; background-size:6px auto; padding-left:17px; font-size:17px;}
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

	<% If Now() > #05/31/2015 23:59:59# Then %>
		alert("이벤트가 종료되었습니다.");
		return;
	<% Elseif Now() < #05/21/2015 00:00:00# Then %>
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
					frm.action = "/event/etc/doeventsubscript/doEventSubscript62566.asp";
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
		url: "/event/etc/doeventsubscript/doEventSubscript62566.asp",
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
	<div class="mEvt62566">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/62566/tit_tenten_tag02.png" alt ="텐바이텐을 #Tag하다" /></h2>
		<div class="rolling">
			<div class="swiper">
				<div class="swiper-container swiper1">
					<div class="swiper-wrapper">
						<div class="swiper-slide">
							<a href="/category/category_itemprd.asp?itemid=882547" target="_top" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62566/may_present_img01.png" alt="" /></a>
							<a href="" onclick="parent.fnAPPpopupProduct('882547');return false;" target="_top" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62566/may_present_img01.png" alt="" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemprd.asp?itemid=882547" target="_top" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62566/may_present_img02.png" alt="" /></a>
							<a href="" onclick="parent.fnAPPpopupProduct('882547');return false;" target="_top" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62566/may_present_img02.png" alt="" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemprd.asp?itemid=882547" target="_top" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62566/may_present_img03.png" alt="" /></a>
							<a href="" onclick="parent.fnAPPpopupProduct('882547');return false;" target="_top" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62566/may_present_img03.png" alt="" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemprd.asp?itemid=882547" target="_top" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62566/may_present_img04.png" alt="" /></a>
							<a href="" onclick="parent.fnAPPpopupProduct('882547');return false;" target="_top" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62566/may_present_img04.png" alt="" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemprd.asp?itemid=882547" target="_top" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62566/may_present_img05.png" alt="" /></a>
							<a href="" onclick="parent.fnAPPpopupProduct('882547');return false;" target="_top" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62566/may_present_img05.png" alt="" /></a>
						</div>
					</div>
					<div class="pagination"></div>
				</div>
				<button type="button" class="prev"><span>이전</span></button>
				<button type="button" class="next"><span>다음</span></button>
			</div>
			<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62566/may_present_txt.png" alt="MAY : PRESENT - SPECIAL GIFT TAG SET(옵션랜덤)" /></p>
		</div>

		<!-- 구매내역 확인 -->
		<div class="buyHistory">
			<div class="welcome">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/62566/may_order_history.png" alt ="5월 고객님의 구매내역을 확인하세요!" /></p>
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
				<button type="button" class="btnconfirm" onclick="chkmyorder();return false;">확 인 하 기</button>
			</div>
			<p class="present"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62566/may_present_check.png" alt ="5월의 PRESENT 확인하고 응모하세요! 구매내역이 있으시면 선물을 확인하고, 하단의 응모하기를 누르세요! 6월 11일 당첨자 발표(200명 추첨)" /></p>
		</div>
		<!--// 구매내역 확인 -->

		<form name="frmGubun2" method="post" style="margin:0px;" target="prociframe">
		<input type="hidden" name="mode" value="add"  />
			<div class="apply" onClick="jsSubmitComment(); return false;">
				<button type="button">응 모 하 기</button>
			</div>
		</form>

		<div class="noti">
			<strong>이벤트 유의사항</strong>
			<ul>
				<li>이벤트는 APP푸쉬 또는 SMS로 이벤트 안내를 받으신 회원님만을 위한 혜택입니다.</li>
				<li>응모하기는 이벤트 기간 중 1회만 가능합니다.</li>
				<li>5월 구매내역이 있어야 응모하기가 가능합니다.</li>
				<li>환불이나 교환으로 인해 구매횟수나 구매금액이 충족되지 않을 경우 응모는 자동 취소 됩니다.</li>
				<li>이벤트는 조기종료 될 수 있습니다.</li>
			</ul>
		</div>
	<div id="tempdiv" style="display:none;"></div>
	<iframe name="prociframe" id="prociframe" frameborder="0" width="0px" height="0px"></iframe>
	</div>
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