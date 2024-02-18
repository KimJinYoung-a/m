<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
'####################################################
' Description : 가격이 구구구, 구구구! for app
' History : 2015-06-05 이종화 생성
'####################################################
	Dim userid, eCode

	userid = GetLoginUserID
	IF application("Svr_Info") = "Dev" THEN
		eCode = "63781"
	Else
		eCode = "63373"
	End If

	Dim strSql , totcnt
'	'// 응모여부
'	strSql = "select count(*) from db_event.dbo.tbl_event_subscript where userid = '"& userid &"' and evt_code = '"& ecode &"' and convert(varchar(10),regdate,120) = '"& Date() &"' " 
'	rsget.Open strSql,dbget,1
'	IF Not rsget.Eof Then
'		totcnt = rsget(0)
'	End IF
'	rsget.close()

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "[텐바이텐] 비둘기 마켓 오픈!\n\n구구구, 가격이 떨어진다!\n\n텐바이텐에서 가장 사랑받는\n상품을 저렴한 가격에 만나세요.\n\n한정수량 / 선착순판매\n비둘기마켓에서 기다릴게요!"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2015/63373/kakao_dove2.gif"
	Dim kakaoimg_width : kakaoimg_width = "200"
	Dim kakaoimg_height : kakaoimg_height = "200"
	Dim kakaolink_url : kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=63373"
%>
<html lang="ko">
<head>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<title></title>
<style type="text/css">
img {vertical-align:top;}

.mEvt63373 .gift {position:relative;}
.mEvt63373 .gift .btnpush {position:absolute; top:29%; left:50%; width:60%; margin-left:-30%;}

/* layer */
.layer {display:none; position:absolute; top:30%; left:50%; z-index:250; width:80%; margin-left:-40%;}
.layer .inner {position:relative; padding-top:4%;}
.layer .no {position:absolute; top:17.5%; left:0; width:100%; padding-left:5%; color:#003e62; font-size:16px; line-height:16px; text-align:center; letter-spacing:-0.05em;}
.layer .btnclose {position:absolute; top:0; right:-4%; width:10%; background-color:transparent;}

.mask {display:none; position:absolute; top:0; left:0; z-index:200; width:100%; height:100%; background:rgba(0,0,0,.6);}

.item {margin-top:3px;}
.item .navigator {width:100%;}
.item .navigator:after {content:' '; display:block; clear:both;}
.item .navigator {}
.item .navigator li {float:left; width:25%; text-align:center;}
.item .navigator li a {display:block; position:relative; height:0; padding:20% 0 68%; border-left:1px solid #f4f7f7; background-color:#0fba84; color:#fff; font-size:12px; line-height:1.5em;}
.item .navigator li:first-child a {border-left:1px solid #2db7da;}
.item .navigator li a em {display:block; padding-top:4.5%; font-size:16px; font-weight:bold;}
.item .navigator li a span {position:absolute; top:0; left:0; width:100%; height:100%;}
.item .navigator li a img {display:none; position:absolute; bottom:-12px; left:50%; width:23px; margin-left:-11px;}
.item .navigator li a.on {background-color:#ffc514; color:#333;}
.item .navigator li:first-child a.on {border-left:1px solid #ffc514;}
.item .navigator li a.on img {display:block;}

#lyrTabItemList {padding:6% 3% 0;}

.noti {padding:30px 20px; background:#16ae7e url(http://webimage.10x10.co.kr/eventIMG/2015/63373/bg_green.png) repeat-x 50% 0; background-size:100% auto;}
.noti h2 {color:#16ad7d; font-size:13px;}
.noti h2 strong {display:inline-block; padding:5px 12px 2px; border-radius:20px; background-color:#fff; line-height:1.25em;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; margin-top:2px; padding-left:15px; color:#fff; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:4px; left:0; width:2px; height:2px; border:2px solid #eee57b; border-radius:50%; background-color:transparent;}

@media all and (min-width:480px){
	.item .navigator li a {font-size:18px;}
	.item .navigator li a em {font-size:24px;}
	.item .navigator li a img {bottom:-17px; width:34px; margin-left:-17px;}
	.noti {padding:40px 35px;}
	.noti ul {margin-top:16px;}
	.noti h2 {font-size:17px;}
	.noti ul li {margin-top:4px; font-size:13px;}
}

@media all and (min-width:600px){
	.noti h2 {font-size:20px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:6px; padding-left:20px; font-size:16px;}
	.noti ul li:after {top:9px;}
}
</style>
<script type="text/javascript">
$(function(){
	//오구구 5,990 원 default loading
	getEvtItemList('nav01',<%=chkIIF(application("Svr_Info")="Dev","135354","147290")%>);

	/* layer */
	$(".mask, #lyGift .btnclose").click(function(){
		$("#lyGift").hide();
		$(".mask").hide();
	});
});
function checkform(){
	<% If userid = "" Then %>
		if ("<%=IsUserLoginOK%>"=="False") {
			parent.calllogin();
			return false;
		}
	<% End If %>
	<% If userid <> "" Then %>
		<% If totcnt > 1 then %>
			alert("오늘은 이미 참여 하셨습니다.");
		<% Else %>
			var result;
			$.ajax({
				type:"GET",
				url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript63373.asp",
				dataType: "text",
				async:false,
				cache:true,
				success : function(Data){
					result = jQuery.parseJSON(Data);
					if (result.resultcode=="11")
					{
						$("#lyGift").show();
						$(".mask").show();
						$("#item1").css("display","block");
						return;
					}
					else if (result.resultcode=="22")
					{
						$("#lyGift").show();
						$(".mask").show();
						$("#item2").css("display","block");
						return;
					}
					else if (result.resultcode=="33")
					{
						$("#lyGift").show();
						$(".mask").show();
						$("#item3").css("display","block");
						return;
					}
					else if (result.resultcode=="99")
					{
						alert('에러 관리자 요청 요망');
						return;
					}
					else if (result.resultcode=="00")
					{
						alert('하루에 1번만 참여 가능 합니다.');
						return;
					}
					else if (result.resultcode=="01")
					{
						alert('이벤트 기간이 아니거나 종료 되었습니다.');
						return;
					}
					else if (result.resultcode=="02")
					{
						alert('로그인을 하셔야 참여가 가능 합니다.');
						return;
					}
					else if (result.resultcode=="03")
					{
						alert('잘못된 접근입니다.');
						return;
					}
				}
			});
		 <% End If %>
	<% End If %>
}
// 상품 목록 출력
function getEvtItemList(no,egc) {
	$(".navigator li a").removeClass("on");
	$("#"+no).addClass("on");

	$("#lyrTabItemList").empty();

	$.ajax({
		type:"POST",
		url: "/apps/appcom/wish/web2014/event/etc/evt_63373_itemlist.asp",
		data: "eGC="+egc,
		cache: false,
		success: function(message) {
			$("#lyrTabItemList").html(message);
		}
		,error: function(err) {
			alert(err.responseText);
		}
	});
}
</script>
</head>
<body>
<div class="evtCont">
	<!-- [APP전용] 가격이 구구구, 구구구 [ 비둘기마켓 ] -->
	<div class="mEvt63373">
		<div class="topic">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/63373/txt_welcome_v2.jpg" alt="단 5일간, 텐바이텐 APP에서만 만나는 특별한 기회! 어서오세요! 비둘기 마켓입니다." /></p>
		</div>

		<!-- <div class="gift">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/63373/txt_gift.png" alt="비둘기마켓에 방문해주신 여러분에게 하루 한 번! 행운을 드립니다. 아래 비둘기를 눌러주세요! 한 ID당 하루 한 번 참여 가능합니다." /></p>
			<div class="btnpush"><a href="" onclick="checkform();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63373/btn_push.png" alt="응모하기" /></a></div>

			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/63373/img_gift_preview.jpg" alt="바이빔 새장스탠드 10명, 텐바이텐 마일리지 500명 900 포인트, 3만원 이상 구매시 사용가능한 앱전용 9%할인 쿠폰" /></p>
		</div>

		<div id="lyGift" class="layer">
			<div class="inner">
				<p id="item1" style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63373/img_gift_bird_lamp.jpg" alt="축하합니다! 바이빔 새장 스탠드에 당첨되었습니다. 경품 배송지 등록은 2015년 6월 16일 화요일이며, 발송은 6월 18일 목요일부터 순차적으로 진행됩니다." /></p>
				<p id="item2" style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63373/img_gift_mileage.jpg" alt="축하합니다! 900포인트 마일리지에 당첨되었습니다. 마일리지는 2015년 6월 16일 화요일에 당첨된 ID로 일괄 발급됩니다." /></p>
				<p id="item3" style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63373/img_gift_coupon.jpg" alt="축하합니다! 9% 할인쿠폰에 당첨되었습니다. 바로 지급된 쿠폰과 함께 쇼핑을 더 알뜰하게 즐겨보세요. 본 쿠폰은 앱에서 구매시에만 적용가능합니다." /></p>
				<button type="button" class="btnclose"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63373/btn_close.png" alt="닫기" /></button>
			</div>
		</div> -->

		
		<div class="item">
			<ul class="navigator">
				<!--  for dev msg : 선택된 탭에 클래스 on 붙여주세요 -->
				<li><a href="" id="nav01" onclick="getEvtItemList('nav01',<%=chkIIF(application("Svr_Info")="Dev","135354","147290")%>); return false;"><span></span>오구오구<em>5,990원</em> <img src="http://webimage.10x10.co.kr/eventIMG/2015/63373/bg_tab_on.png" alt="" /></a></li>
				<li><a href="" id="nav02" onclick="getEvtItemList('nav02',<%=chkIIF(application("Svr_Info")="Dev","135355","147291")%>); return false;"><span></span>구구구<em>9,990원</em> <img src="http://webimage.10x10.co.kr/eventIMG/2015/63373/bg_tab_on.png" alt="" /></a></li>
				<li><a href="" id="nav03" onclick="getEvtItemList('nav03',<%=chkIIF(application("Svr_Info")="Dev","135356","147292")%>); return false;"><span></span>이런구구<em>15,990원</em> <img src="http://webimage.10x10.co.kr/eventIMG/2015/63373/bg_tab_on.png" alt="" /></a></li>
				<li><a href="" id="nav04" onclick="getEvtItemList('nav04',<%=chkIIF(application("Svr_Info")="Dev","135357","147293")%>); return false;"><span></span>이구구구<em>19,990원</em> <img src="http://webimage.10x10.co.kr/eventIMG/2015/63373/bg_tab_on.png" alt="" /></a></li>
			</ul>

			<% '상품 리스트 %>
			<div id="lyrTabItemList"></div>
		</div>

		<div class="noti">
			<h2><strong>유의사항</strong></h2>
			<ul>
				<li>텐바이텐 회원 대상 이벤트 입니다.</li>
				<!--li>발급되는 할인쿠폰은 APP에서 3만원 이상 구매시 사용 가능합니다.</li>
				<li>할인쿠폰 유효기간은 2015년 6월 15일 자정까지 입니다.</li>
				<li>경품 수령지 등록은 2015년 6월 16일, 발송은 6월 18일부터 진행됩니다.</li>
				<li>마일리지는 2015년 6월 16일 (화)에 일괄 발급됩니다. (한 ID당 최대 900point 발급)</li-->
				<li>비둘기마켓 상품의 상세 정보 및 교환/환불 정책은 각 상세페이지에서 확인해주세요.</li>
			</ul>
		</div>

		<!-- for dev msg : 카카오톡 -->
		<div class="kakao">
			<a href="" onclick="parent.parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>'); return false;" id="kakao-link-btn" title="카카오톡으로 비둘기마켓 알려주기"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63373/btn_kakao.png" alt="카카오톡으로 비둘기마켓을 널리 알려주세요 ! 마켓이 흥하면 더 멋지게 돌아올게요!" /></a>
		</div>
		<div class="mask"></div>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->