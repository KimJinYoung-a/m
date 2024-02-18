<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 고마운건 꼭 선물로 표현할게!
' History : 2015-03-24 원승현
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<% if isApp=1 then %>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js"></script>
<% end if %>
<%
dim eCode, vUserID, userid, myuserLevel, vPageSize, vPage, sqlStr, vTotalCount, vTotalSum, eLinkCode, prveCode, prvCount, prvTotalcount
	vUserID = GetLoginUserID()
	myuserLevel = GetLoginUserLevel
	userid = vUserID

	IF application("Svr_Info") = "Dev" THEN
		eCode = "21516"
	Else
		eCode = "60693"
	End If

	If vUserID = "" Then
		If isApp="1" Then
			response.write "<script language='javascript'>parent.calllogin();</script>"
			dbget.close()
			response.end
		Else 
			response.write "<script language='javascript'>top.location.href = '/login/login.asp?backpath=%2Fevent%2Feventmain%2Easp%3Feventid%3D59602';</script>"
			dbget.close()
			response.end
		End If
	End If

Dim vQuery, vCount
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' AND evt_code = '" & eCode & "' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		vCount = rsget(0)
	End IF
	rsget.close

	'//2월 구매 내역 체킹 (해당 이벤트 페이지뷰는 2월 구매내역이 있는자만)
	sqlStr = " EXEC [db_order].[dbo].[sp_Ten_MyOrderList_SUM] '" & userid & "', '', '', '2015-02-01', '2015-03-01', '10x10', '', 'issue' "
	rsget.CursorLocation = adUseClient
	rsget.CursorType = adOpenStatic
	rsget.LockType = adLockOptimistic
	rsget.Open sqlStr,dbget,1
		prvTotalcount = rsget("cnt")
	rsget.Close

	'//3월 구매 내역 체킹 (응모는 3월 구매고객만 가능)
	sqlStr = " EXEC [db_order].[dbo].[sp_Ten_MyOrderList_SUM] '" & userid & "', '', '', '2015-03-01', '2015-04-01', '10x10', '', 'issue' "
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


'	If prvTotalcount < 1 Then 
'		response.write "<script>alert('이벤트 대상자가 아닙니다.');parent.top.location.href='/shoppingtoday/shoppingchance_allevent.asp';</script>"
'		response.End
'	End If

%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title></title>
<style type="text/css">
img {vertical-align:top;}
.app {display:none;}
.buyHistory .welcome {position:relative;}
.buyHistory .welcome ul {position:absolute; top:32%; left:40%; width:50%; height:27%; padding-top:3%; border-top:1px solid #8f8f8f; border-bottom:1px solid #8f8f8f;}
.buyHistory .welcome ul li {padding-top:4%;}
.buyHistory .welcome ul li:after {content:' '; display:block; clear:both;}
.buyHistory .welcome ul li span {vertical-align:top;}
.buyHistory .welcome ul li img {vertical-align:top;}
.buyHistory .welcome ul li strong {display:inline-block; min-width:10px; height:10px; text-align:right; font-size:12px; line-height:13px; vertical-align:top; background:url(http://webimage.10x10.co.kr/eventIMG/2015/58924/ico_star.gif) right top no-repeat; background-size:150px auto;}
.buyHistory .welcome ul li strong em {color:#e33840; padding-left:10px; background:#fff;}
.buyHistory .welcome ul li .ftLt img {width:46px;}
.buyHistory .welcome ul li .ftRt img {width:9px; margin-left:5px;}
.buyHistory .welcome .btnconfirm {position:absolute; bottom:17%; left:50%; width:74%; margin-left:-37%;}
.buyHistory .welcome .btnconfirm span {overflow:hidden; width:0; height:0; font-size:0; line-height:0; text-indent:-9999px;}
.giftBox {position:relative;}
.giftBox li {position:absolute; top:0; height:70%;}
.giftBox li:nth-child(1) {left:0; width:39%;}
.giftBox li:nth-child(2) {right:0; width:61%;}
.giftBox li span {display:block; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55406/blank.png) left top repeat; background-size:100% 100%; text-indent:-9999em;}
.giftBox li strong {position:absolute; top:-15%; right:0; width:27%;}
.rolling {padding:5% 0; background-color:#fff;}
.swiper {position:relative; width:320px; margin:0 auto;}
.swiper .swiper-container {overflow:hidden; position:relative; width:320px;}
.swiper .swiper-wrapper {overflow:hidden;}
.swiper .swiper .swiper-slide {float:left;}
.pagination {position:absolute; bottom:25px; left:0; width:100%;}
.pagination .swiper-pagination-switch {width:10px; height:10px; margin:0 2px; background-color:#fff; cursor:pointer;}
.pagination .swiper-active-switch {background-color:#e33840;}
.swiper button {position:absolute; top:50%; width:19px; margin-top:-15px; background-color:transparent;}
.swiper button span {overflow:hidden; width:0; height:0; font-size:0; line-height:0; text-indent:-9999px;}
.swiper .prev {left:10px;}
.swiper .next {right:10px;}
.rolling .desc {width:320px; margin:0 auto;}

.apply {padding:7% 0 8%; background:#fff1e6 url(http://webimage.10x10.co.kr/eventIMG/2015/60693/bg_flower.png) no-repeat 0 0; background-size:100% auto; text-align:center;}
.apply button {width:289px; height:53px; background:#d60000 url(http://webimage.10x10.co.kr/eventIMG/2015/60693/btn_apply.png) no-repeat 0 0; background-size:100% auto; text-indent:-999em;}
.noti {padding:25px 15px 30px; font-size:12px; background:#fff;}
.noti strong {display:inline-block; font-size:14px; font-weight:bold; color:#222; padding-bottom:1px; margin-bottom:13px; border-bottom:2px solid #222;}
.noti ul li {position:relative; color:#000; font-size:11px; line-height:1.3; padding-left:7px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/58924/blt_arrow.gif) 0 4px no-repeat; background-size:3px auto;}

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
	.buyHistory .welcome ul li strong {min-width:15px; height:15px; font-size:18px; line-height:20px; background-size:230px auto;}
	.buyHistory .welcome ul li strong em {padding-left:15px;}
	.buyHistory .welcome ul li .ftLt img {width:69px;}
	.buyHistory .welcome ul li .ftRt img {width:14px; margin-left:7px;}
	.apply button {width:434px; height:80px;}
	.noti {padding:38px 23px 45px; font-size:18px;}
	.noti strong {margin-bottom:20px; font-size:21px;}
	.noti ul li {background-position:0 7px; background-size:6px auto; padding-left:17px; font-size:17px;}
}
@media all and (min-width:768px){
	.pagination .swiper-pagination-switch {width:12px; height:12px; margin:0 5px;}
}
</style>
<script>
$(function(){
	$("#mo").hide();
	$("#app").hide();
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		$('#mo').show();
	}else{
		$('#app').show();
	}
});

function jsSubmitComment(){
	var frm = document.frmGubun2;

	<% If vUserID = "" Then %>
	jsChklogin('<%=IsUserLoginOK%>');
	return;
	<% End If %>

	<% If Now() > #03/31/2015 23:59:59# Then %>
		alert("이벤트가 종료되었습니다.");
		return;
	<% Elseif Now() < #03/26/2015 00:00:00# Then %>
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
					frm.action = "doEventSubscript60693.asp";
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
		url: "/event/etc/doEventSubscript60693.asp",
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
<div class="evtCont">
	<%' 고마운건 선물로 표현할게(M/A) %>
	<div class="mEvt59602">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60693/txt_give_flower.png" alt ="꽃을 드립니다. 꽃이 피는 3월 선물을 확인하고, 4월을 기다려주세요! 3월과 4월 두번 모두 응모해주신 분들께 추첨을 통해 200분께 선물을 드립니다!" /></p>
		<!-- 구매내역 확인 -->
		<div class="buyHistory">
			<div class="welcome">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60693/txt_history.png" alt ="3월 고객님의 구매내역을 확인하세요!" /></p>
				<ul>
					<li>
						<span class="ftLt"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58924/txt_count.gif" alt ="구매횟수" /></span>
						<span class="ftRt"><strong><%' for dev msg : 확인하기 클릭하면 노출%><em id="totcnt" style="display:none;">0</em></strong><img src="http://webimage.10x10.co.kr/eventIMG/2015/58924/txt_num.gif" alt ="회" /></span>
					</li>
					<li>
						<span class="ftLt"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58924/txt_price.gif" alt ="구매금액" /></span>
						<span class="ftRt"><strong><%' for dev msg : 확인하기 클릭하면 노출%><em id="totsum" style="display:none;">0</em></strong><img src="http://webimage.10x10.co.kr/eventIMG/2015/58924/txt_won.gif" alt ="원" /></span>
					</li>
				</ul>
				<button type="button" class="btnconfirm" onclick="chkmyorder();return false;"><span>확인하기</span><img src="http://webimage.10x10.co.kr/eventIMG/2015/60693/btn_confirm.png" alt="" /></button>
			</div>
			<p class="present"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60693/txt_present.png" alt ="2월의 PRESENT 확인하고 응모하세요! 구매내역이 있으시면 선물을 확인하고, 하단의 응모하기를 누르세요! 3월 11일 당첨자가 발표됩니다!" /></p>
		</div>
		<!--// 구매내역 확인 -->
		<div class="giftBox">
			<ul>
				<li><span>3월의 선물</span></li>
				<li><span>4월의 선물</span> <strong><img src="http://webimage.10x10.co.kr/eventIMG/2015/60693/ioc_comming_soon.png" alt ="" /></strong></li>
			</ul>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/60693/tab_present.png" alt ="" /></div>
		</div>

		<div class="rolling">
			<div class="swiper">
				<div class="swiper-container swiper1">
					<div class="swiper-wrapper">
						<div class="swiper-slide">
							<% If IsApp="1" Then %>
								<a href="" onclick="parent.fnAPPpopupProduct('1214305');return false;" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60693/img_slide_01.jpg" alt="" /></a>
							<% Else %>
								<a href="/category/category_itemprd.asp?itemid=1214305" target="_top" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60693/img_slide_01.jpg" alt="" /></a>
							<% End If %>
						</div>
						<div class="swiper-slide">
							<% If isapp="1" Then %>
								<a href="" onclick="parent.fnAPPpopupProduct('1214305');return false;" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60693/img_slide_02.jpg" alt="" /></a>
							<% Else %>
								<a href="/category/category_itemprd.asp?itemid=1214305" target="_top" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60693/img_slide_02.jpg" alt="" /></a>
							<% End If %>
						</div>
						<div class="swiper-slide">
							<% If isapp="1" Then %>
								<a href="" onclick="parent.fnAPPpopupProduct('1214305');return false;" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60693/img_slide_03.jpg" alt="" /></a>
							<% Else %>
								<a href="/category/category_itemprd.asp?itemid=1214305" target="_top" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60693/img_slide_03.jpg" alt="" /></a>
							<% End If %>
						</div>
						<div class="swiper-slide">
							<% If isapp="1" Then %>
								<a href="" onclick="parent.fnAPPpopupProduct('1214305');return false;" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60693/img_slide_04.jpg" alt="" /></a>
							<% Else %>
								<a href="/category/category_itemprd.asp?itemid=1214305" target="_top" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60693/img_slide_04.jpg" alt="" /></a>
							<% End If %>
						</div>
						<div class="swiper-slide">
							<% If isapp="1" Then %>
								<a href="" onclick="parent.fnAPPpopupProduct('1214305');return false;" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60693/img_slide_05.jpg" alt="" /></a>
							<% Else %>
								<a href="/category/category_itemprd.asp?itemid=1214305" target="_top" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60693/img_slide_05.jpg" alt="" /></a>
							<% End If %>
						</div>
					</div>
					<div class="pagination"></div>
				</div>
				<button type="button" class="prev"><span>이전</span><img src="http://webimage.10x10.co.kr/eventIMG/2015/60693/btn_prev.png" alt="이전" /></button>
				<button type="button" class="next"><span>다음</span><img src="http://webimage.10x10.co.kr/eventIMG/2015/60693/btn_next.png" alt="다음" /></button>
			</div>
			<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60693/txt_slide.png" alt="365DAY 카멜리아 석고 오너먼트 (향은 랜덤으로 발송됩니다)" /></p>
		</div>

		<!-- 응모하기 -->
		<form name="frmGubun2" method="post" style="margin:0px;" target="prociframe">
		<input type="hidden" name="mode" value="add"  />
		<div class="apply" onClick="jsSubmitComment(); return false;">
			<button type="button">응모하기</button>
		</div>
		</form>
		<!--// 응모하기 -->

		<div class="noti">
			<strong>이벤트 유의사항</strong>
			<ul>
				<li>이벤트는 이메일또는 SMS로 이벤트 안내를 받으신 회원님만을 위한 헤택입니다.</li>
				<li>응모하기는 이벤트 기간 중 1회만 가능합니다.</li>
				<li>3월 구매내역이 있어야 응모하기가 가능합니다.</li>
				<li>4월 이벤트까지 응모가 완료되면, 5월 13일 당첨자가 발표 됩니다.</li>
				<li>환불이나 교환으로 인해 구매횟수나 구매금액이 충족되지 않을 경우 응모는 자동 취소 됩니다.</li>
				<li>이벤트는 조기 종료 될 수 있습니다.</li>
			</ul>
		</div>
	</div>
	<%'// 고마운건 선물로 표현할게(M/A) %>
	<div id="tempdiv"></div>
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