<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 2016 마일리지
' History : 2016.01.08 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim eCode, userid, currenttime
	IF application("Svr_Info") = "Dev" THEN
		eCode = "65999"
	Else
		eCode = "68504"
	End If

	currenttime = now()
	'currenttime = #01/11/2016 10:06:00#

	userid = GetEncLoginUserID()

dim subscriptcount, totalsubscriptcount
subscriptcount=0
totalsubscriptcount=0

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "1", "")

end if

'//전체 참여수
totalsubscriptcount = getevent_subscripttotalcount(eCode, left(currenttime,10), "1", "")

dim limitcnt, currentcnt
limitcnt = 2016
currentcnt = limitcnt - totalsubscriptcount
if currentcnt < 1 then currentcnt=0
%>

<% '<!-- #include virtual="/lib/inc/head.asp" --> %>

<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:21px;}}

img {vertical-align:top;}
.mEvt68504 {text-align:center; background:#89a6db;}
.title {position:relative;}
.title .every {position:absolute; left:0; top:17.2%; width:100%; z-index:50; opacity:0;}
.title h2 p {opacity:0;}
.title h2 p.t01 {-webkit-transform: rotateY(180deg); transform: rotateY(180deg);}
.title h2 p.t02 {-webkit-transform: rotateY(480deg); transform: rotateY(480deg); position:absolute; left:0; top:0; width:100%; z-index:50;}
.title h2 p.flipped {-webkit-transform: rotateY(0deg); transform: rotateY(0deg); -webkit-transition: -webkit-transform 1s; transition: transform 1s;}

.mileage2016 .getMg {position:relative;}
.mileage2016 .getMg .count {position:absolute; left:0; bottom:17.5%; width:100%; font-size:1.1rem; font-weight:bold; color:#dd7980; text-align:center; z-index:40;}
.mileage2016 .getMg .soldout {position:absolute; left:0; top:0; width:100%; z-index:50;}
.mileage2016 .myMg {font-size:1.5rem; line-height:1.4; padding-bottom:2.5rem; color:#57709f; font-weight:bold;}
.mileage2016 .myMg strong {color:#fff; padding-right:0.2rem;}

.evtNoti {text-align:left; padding:2.4rem 7.5% 0; background:#566f9f;}
.evtNoti h3 {margin-bottom:1.8rem;}
.evtNoti h3 strong {display:inline-block; color:#fff; font-size:1.5rem; border-bottom:2px solid #fff;}
.evtNoti li {position:relative; color:#dbe4f4; font-size:1.1rem; line-height:1.4; padding:0 0 0.4rem 1.3rem;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.5rem; width:0.5rem; height:0.15rem; background:#dbe4f4;}
</style>
<script type="text/javascript">

function jseventSubmit(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2016-01-11" and left(currenttime,10)<"2016-01-16" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if subscriptcount>0 then %>
				alert("이미 마일리지를 받으셨습니다.");
				return;
			<% else %>
				<% if currentcnt<1 then %>
					alert("오늘의 마일리지가 모두 소진 되었습니다!.");
					return;
				<% else %>
					<%' if Hour(currenttime) < 10 then %>
					//	alert("마일리지는 오전 10시부터 받으실수 있습니다.");
					//	return;
					<%' else %>
						frm.action="/event/etc/doeventsubscript/doEventSubscript68504.asp";
						frm.target="evtFrmProc";
						frm.mode.value='regmillage';
						frm.submit();
					<%' end if %>
				<% end if %>
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End IF %>
}

</script>
</head>
<body>

<!-- 2016 마일리지 -->
<div class="mEvt68504">
	<div class="title">
		<p class="every"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68504/m/txt_every_10am.png" alt="매일 오전 10시" /></p>
		<h2>
			<p class="t01"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68504/m/tit_2016.png" alt="2016" /></p>
			<p class="t02"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68504/m/tit_mileage.png" alt="마일리지" /></p>
		</h2>
	</div>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/68504/m/txt_shopping.png" alt="2016명에게만 쇼핑지원금을 드려요! 새해에는 망설임없이 쇼핑하세요!" /></p>
	<% '<!-- 마일리지 받기/현재 마일리지 확인 --> %>
	<div class="mileage2016">
		<div class="getMg">
			<button onclick="jseventSubmit(evtFrm1); return false;" class="btnMg"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68504/m/btn_get_mileage.png" alt="2016 마일리지" /></button>
			<p class="count">현재 남은수량 : <em><%= currentcnt %></em></p>
			
			<% if currentcnt<1 then %>
				<% '<!-- 소진 시 --> %>
				<div class="soldout">
					<% if left(currenttime,10)>="2016-01-15" then %>
						<% '<!-- 금 --> %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/68504/m/txt_soldout_02.png" alt="오늘의 마일리지가 모두 소진되었습니다. 감사합니다." />
					<% else %>
						<% '<!-- 월~목 --> %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/68504/m/txt_soldout_01.png" alt="오늘의 마일리지가 모두 소진되었습니다. 내일 아침 10시를 기다려주세요!" />
					<% end if %>
				</div>
			<% end if %>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/68504/m/txt_tip.png" alt="본 마일리지는 미사용 시 소멸되는 스페셜 마일리지 입니다." /></p>
		
		<% if userid <> "" then %>
			<div class="myMg">
				<p><strong><%= printUserId(userid,2,"*") %></strong>님의 현재 마일리지는<br /><strong><%=FormatNumber(GetLoginCurrentMileage,0)%></strong>M 입니다.</p>
			</div>
		<% end if %>
	</div>

	<% if not(isApp=1) then %>
		<a href="/event/appdown/" target="_blank" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68504/m/btn_app_down.png" alt="텐바이텐 APP 다운받고 더 핫한 이벤트와 할인 기회가 듬뿍!" /></a>
	<% end if %>

	<div class="evtNoti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<li>본 이벤트는 로그인 후에 참여할 수 있습니다.</li>
			<li>이벤트는 ID당 1회만 참여할 수 있습니다.</li>
			<li>주문하시는 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
			<li>지급된 마일리지는 3만원 이상 구매 시 현금처럼 사용 가능합니다.</li>
			<li>기간 내에 사용하지 않은 마일리지는 1월 18일 월요일 오전 내에 사전 통보 없이 자동 소멸합니다.</li>
			<li>이벤트는 조기 마감될 수 있습니다.</li>
		</ul>
	</div>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/68504/m/txt_benefit.png" alt="마일리지는 결제 시 현금처럼 사용할 수 있습니다. 일반 쿠폰과 차원이 다른 혜택을 경험하세요!" /></p>

	<% if left(currenttime,10)>"2016-01-11" then %>
		<% '<!-- 배너추가--> %>
		<div>
			<% if isApp then %>
				<a href="" onclick="fnAPPpopupEvent('68620'); return false;">
			<% else %>
				<a href="/event/eventmain.asp?eventid=68620" target="_blank">
			<% end if %>
			
			<img src="http://webimage.10x10.co.kr/eventIMG/2016/68504/m/bnr_shopping.png" alt="마일리지로 쇼핑하러 Go!" /></a>
		</div>
	<% end if %>
</div>
<!--// 2016 마일리지 -->

<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
<input type="hidden" name="mode">
<input type="hidden" name="isapp" value="<%= isApp %>">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>

<script type="text/javascript">
$(function(){
	$('.title .every').animate({"margin-top":"8px","opacity":"1"},500).animate({"margin-top":"0"},600);
	$(".title h2 p").animate({"opacity":"1"},1200).addClass("flipped");

	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
			$(".ma").show();
			$(".mw").hide();
	}else{
			$(".ma").hide();
			$(".mw").show();
	}
});
</script>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->