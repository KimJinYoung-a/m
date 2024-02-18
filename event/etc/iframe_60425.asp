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
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21505"
	Else
		eCode = "60425"
	End If
	
%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>[app쿠폰] 만원의 기적</title>
<style type="text/css">
img {vertical-align:top;}
.mEvt60425 .coupon {position:relative;}
.mEvt60425 .coupon .btndown {position:absolute; top:67%; left:50%; width:47.6%; margin-left:-23.8%; background-color:transparent;}
.mEvt60425 .coupon .btndown span {overflow:hidden; visibility:hidden; position:absolute; top:-1000%; width:0; height:0; line-height:0;}
.mEvt60425 .coupon .done {position:absolute; top:63%; left:50%; width:72.4%; margin-left:-36.2%;}
.noti {padding:20px 15px; background-color:#fff;}
.noti h2 {color:#222; font-size:14px; line-height:1.5em;}
.noti h2 span {display:inline-block; padding-bottom:1px; border-bottom:2px solid #222;}
.noti ul {margin-top:15px;}
.noti ul li {position:relative; margin-top:2px; padding-left:12px; color:#434444; font-size:11px; line-height:1.375em;}
.noti ul li em {color:#d60703;}
.noti ul li:after {content:' '; position:absolute; top:3px; left:0; z-index:5; width:0; height:0; border-top:6px solid #5c5c5c; border-left:6px solid transparent; transform:rotate(45deg); -moz-transform:rotate(45deg); -webkit-transform:rotate(45deg);}
.bnr {margin-top:20px;}
@media all and (min-width:480px){
	.noti {padding:30px 22px;}
	.noti h2 {font-size:21px;}
	.noti ul {margin-top:22px;}
	.noti ul li {margin-top:3px; padding-left:18px; font-size:16px; }
	.noti ul li:after {top:6px; border-top:9px solid #5c5c5c; border-left:9px solid transparent;}
}
</style>
<% if isApp=1 then %>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js"></script>
<% end if %>

<script type="text/javascript">
<%
	Dim vQuery, vCheck, vnCnt
	
	vQuery = "select count(*) from [db_user].dbo.tbl_user_coupon where masteridx = '713' and userid = '" & vUserID & "'"
	rsget.Open vQuery,dbget,1
	If rsget(0) > 0 Then
		vCheck = "2"
	End IF
	rsget.close()

	vQuery = "select count(*) from [db_user].dbo.tbl_user_coupon where masteridx = '713' "
	rsget.Open vQuery,dbget,1
	If rsget(0) > 0 Then
		vnCnt = rsget(0)
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

	<% If vUserID <> "" Then %>
		<% If vCheck = "2" then %>
			alert("이미 다운받으셨습니다.");
		<% Else %>
			frmGubun2.mode.value = "coupon";
		   frmGubun2.action = "/event/etc/doEventSubscript60425.asp";
		   frmGubun2.submit();
	   <% End If %>
	<% End If %>
}

var userAgent = navigator.userAgent.toLowerCase();
function gotoDownload(){
	// 모바일 홈페이지 바로가기 링크 생성
	if(userAgent.match('iphone')) { //아이폰
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('ipad')) { //아이패드
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('ipod')) { //아이팟
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('android')) { //안드로이드 기기
		window.parent.top.document.location= 'market://details?id=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401<%=request("ref")%>';
	} else { //그 외
		window.parent.top.document.location= 'https://play.google.com/store/apps/details?id=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401<%=request("ref")%>';
	}
};
</script>
</head>
<body>
<div class="content" id="contentArea">

	<%' iframe 만원의 기적 %>
	<div class="mEvt60425">
		<h1><img src="http://webimage.10x10.co.kr/eventIMG/2015/60425/tit_miracle.png" alt="만원의 기적 오늘하루 앱쿠폰으로 기적의 쇼핑혜택을 드립니다." /></h1>

		<div class="coupon">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60425/img_coupon.png" alt="오늘 하루 앱에서 만원 쿠폰을 드립니다. 3만원 이상 구매시 사용가능하며 사용기간은 3월 18일 하루 앱에서만 사용가능합니다." /></p>

			<% If vnCnt > 30000 Then %>
				<p class="soldout" style="position:absolute; top:0; left:0; width:100%;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60425/txt_soldout.png" alt="오늘의 쿠폰이 모두 소진되었어요!" /></p>
			<% Else %>
				<%' for dev msg : 쿠폰 다운받기 전 %>
				<% If vUserID = "" Then %>
					<button type="button" class="btndown" onclick="jsSubmitC(); return false;"><span>쿠폰 다운받기</span><img src="http://webimage.10x10.co.kr/eventIMG/2015/60425/btn_down.png" alt="" /></button>
				<% End If %>

				<% If vUserID <> "" Then %>
					<% If vCheck = "2" then %>
						<%' for dev msg : 쿠폰 다운받기 후 %>
						<p class="done"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60425/txt_down_finish.png" alt="다운이 완료되었습니다. 오늘 자정까지 사용가능합니다." /></p>
					<% Else %>	
						<button type="button" class="btndown" onclick="jsSubmitC(); return false;"><span>쿠폰 다운받기</span><img src="http://webimage.10x10.co.kr/eventIMG/2015/60425/btn_down.png" alt="" /></button>
					<% End If %>
				<% End If %>

			<% End If %>


		</div>



		<%' for dev msg : 모바일에서만 보여주세요. 앱에서는 숨기기 %>
		<% if isApp=1 then %>
		<% Else %>
			<div class="join">
				<a href="" onclick="gotoDownload();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60425/btn_dow_app.png" alt="텐바이텐 앱 설치하고 쿠폰쓰러 가자!" /></a>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/60425/bg_pattern.png" alt="" />
			</div>
		<% End If %>

		<%' for dev msg : 로그인 전 / 로그인후나 로그인이 되어있으면 숨겨주세요 %>
		<% If vUserID = "" Then %>
			<div class="join">
				<% if isApp=1 then %>
					<a href="" onClick="fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60425/btn_join.png" alt="어머 텐바이텐에 처음 오셨나요? 가입하고 첫구매 하러 가기" /></a>
				<% Else %>
					<a href="/member/join.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60425/btn_join.png" alt="어머 텐바이텐에 처음 오셨나요? 가입하고 첫구매 하러 가기" /></a>
				<% End If %>
			</div>
		<% End If %>

		<div class="noti">
			<h2><span>이벤트 유의사항</span></h2>
			<ul>
				<li>이벤트는 ID 당 1일 1회만 참여할 수 있습니다.</li>
				<li>지급된 쿠폰은 텐바이텐 APP에서만 사용가능 합니다.</li>
				<li>쿠폰은 금일 3/18 (수) 23시59분 종료됩니다.</li>
				<li>주문하시는 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다. 이벤트는 조기 마감 될 수 있습니다.</li>
			</ul>
			<div class="bnr">
				<% if isApp=1 then %>
					<a href="" onclick="fnAPPpopupEvent('60537');return false;">
				<% Else %>
					<a href="/event/eventmain.asp?eventid=60537" target="_top">
				<% End If %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/60425/img_bnr.jpg" alt="털털한 그녀의 디지털 악세사리 단 하루만!" /></a>
			</div>
		</div>
	</div>
	<%' //iframe 만원의 기적 %>
	<form name="frmGubun2" method="post" action="/event/etc/doEventSubscript60425.asp" style="margin:0px;" target="evtFrmProc">
	<input type="hidden" name="mode" value="">
	</form>
	<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->