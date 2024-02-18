<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
	Dim vUserID, eCode, cMil, vMileValue, vMileArr
	vUserID = GetLoginUserID
	'vUserID = "10x10yellow"
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21455"
	Else
		eCode = "58875"
	End If
	
%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>[app전용] 놀랐다면서?! 이게바로 쿠폰이야</title>
<style type="text/css">
img {width:100%; vertical-align:top;}
.down {padding:8% 0; background:url(http://webimage.10x10.co.kr/eventIMG/2015/58875/bg_mint.png) repeat-y 50% 0; background-size:100% auto;}
.down img {display:block; width:91.7%; margin:0 auto;}
.noti {padding-top:7%; background-color:#ededed;}
.noti h2 {color:#000; font-size:15px; font-weight:bold; line-height:1.438em; text-align:center;}
.noti h2 span {display:inline-block; padding-bottom:1px; border-bottom:2px solid #000;}
.noti ul {margin-top:20px; margin-bottom:25px; padding:0 15px;}
.noti ul li {position:relative; margin-top:2px; padding-left:12px; color:#333; font-size:11px; line-height:1.438em;}
.noti ul li:after {content:' '; display:block; position:absolute; top:4px; left:0; z-index:5; width:4px; height:4px; border-radius:50%; background-color:#aaa;}
.noti ul li:first-child:after {background-color:#dc0610;}
.noti ul li em {color:#dc0610;}
@media all and (min-width:480px) {
	.noti h2 {font-size:23px;}
	.noti ul {margin-top:35px; margin-bottom:37px; padding:0 22px;}
	.noti ul li {margin-top:3px; padding-left:18px; font-size:16px;}
	.noti ul li:after {top:7px; width:6px; height:6px;}
}
</style>
<% if isApp=1 then %>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js"></script>
<% end if %>

<script type="text/javascript">
<%
	Dim vQuery, vCheck
	
	vQuery = "select count(*) from [db_user].dbo.tbl_user_coupon where masteridx = '691' and userid = '" & vUserID & "'"
	rsget.Open vQuery,dbget,1
	If rsget(0) > 0 Then
		vCheck = "2"
	End IF
	rsget.close()
%>
function jsSubmitC(){
	<% If vUserID = "" Then %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End If %>

	<% If now() >= #01/28/2015 09:00:00# and now() < #01/29/2015 00:00:00# Then %>
		<% If vUserID <> "" Then %>
			<% If vCheck = "2" then %>
				alert("이미 다운받으셨습니다.");
			<% Else %>
			   frmGubun2.mode.value = "coupon";
			   frmGubun2.action = "/event/etc/doEventSubscript58875.asp";
			   frmGubun2.submit();
		   <% End If %>
		<% End If %>
	<% else %>
		alert("오전 9시부터 다운받으실 수 있습니다.");
		return false;
	<% end if %>
}
</script>
</head>
<body>
<div class="content" id="contentArea">
	<div class="mEvt58875">
		<h1><img src="http://webimage.10x10.co.kr/eventIMG/2015/58875/txt_thisis_coupon.gif" alt="놀랐다면서?! 이게바로 쿠폰이야 1월이 얼마남지 않았다! 지나가는 1월에 놀란 당신께 마지막 쿠폰을 드립니다." /></h1>
		<div class="down">


			<% If vUserID = "" Then %>
				<a href="" onclick="jsSubmitC(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58875/btn_down_coupon.png" alt="1만원 이상 구매시 1월 28일 수요일 하루 앱에서만 사용 가능한 앱 전용쿠폰 5천원 쿠폰 다운 받기" /></a>
			<% End If %>

			<% If vUserID <> "" Then %>
				<% If vCheck = "2" then %>
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/58875/btn_down_coupon_end.png" alt="1만원 이상 구매시 1월 28일 수요일 하루 앱에서만 사용 가능한 앱 전용쿠폰 5천원 쿠폰이 발급 되었습니다." />
				<% Else %>
					<a href="" onclick="jsSubmitC(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58875/btn_down_coupon.png" alt="1만원 이상 구매시 1월 28일 수요일 하루 앱에서만 사용 가능한 앱 전용쿠폰 5천원 쿠폰 다운 받기" /></a>
			   <% End If %>
			<% End If %>
		</div>

		<%' for dev msg : 앱 다운받기는 모바일에서만 보이게 작업해 두었습니다. 스크립트는 하단 body 끝나기전에 있어요! %>
		<% if isApp=1 then %>
		<% Else %>
			<div id="mo" class="app"><a href="http://bit.ly/1m1OOyE" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58875/btn_down_app.png" alt="아직이신가요? 텐바이텐 앱 다운받기" /></a></div>
		<% End If %>

		<%' for dev msg : 로그인이 되어있을 경우 숨겨주세요. %>
		<% If vUserID = "" Then %>
			<% if isApp=1 then %>
				<p><a href="" onClick="fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58875/btn_join.png" alt="텐바이텐에 처음오셨나요? 회원가입하고 구매하러 가기" /></a></p>
			<% Else %>
				<a href="/member/join.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58875/btn_join.png" alt="텐바이텐에 처음오셨나요? 회원가입하고 구매하러 가기" /></a>
			<% End If %>
		<% End If %>

		<div class="noti">
			<h2><span>사용전 꼭꼭 읽어보세요!</span></h2>
			<ul>
				<li><em>텐바이텐 APP에서만 사용 가능합니다.</em></li>
				<li>한 ID당 1일 1회 발급, 1회 사용 할 수 있습니다.</li>
				<li>쿠폰은 금일 1/28(수) 23시59분 종료됩니다.</li>
				<li>주문상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
				<li>이벤트는 조기 마감 될 수 있습니다. </li>
			</ul>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58875/txt_ex.png" alt="주문시 모바일 쿠폰에서 해당 쿠폰을 확인 하실 수 있습니다." /></p>
		</div>
	</div>
	<form name="frmGubun2" method="post" action="/event/etc/doEventSubscript58875.asp" style="margin:0px;" target="evtFrmProc">
	<input type="hidden" name="mode" value="">
	</form>
	<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</div>
<script type="text/javascript">
	$(function(){
		var chkapp = navigator.userAgent.match('tenapp');
		if ( chkapp ){
			$("#mo").hide();
		}else{
			$("#mo").show();
		}
});
</script>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->