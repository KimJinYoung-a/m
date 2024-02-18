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
		eCode = "21442"
	Else
		eCode = "58559"
	End If
	
%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>고민하지마 app쿠폰!</title>
<style type="text/css">
img {vertical-align:top;}
.coupon {padding-top:4%; padding-bottom:12%; background:#ede0cd url(http://webimage.10x10.co.kr/eventIMG/2015/58559/bg_con.png) no-repeat 50% 0; background-size:100% auto;}
.coupon a, .coupon span {display:block; width:87.7%; margin:0 auto;}
.btnwrap {padding:0 4.8%; background-color:#ede0cd;}
.btnwrap a {display:block; padding-bottom:10%;}
.noti {background-color:#fbf4ec;}
.noti ul {margin-top:5%; margin-bottom:6%; padding:0 4.8%}
.noti ul li {position:relative; margin-top:2px; padding-left:10px; color:#333; font-size:11px; line-height:1.375em;}
.noti ul li:after {content:' '; display:block; position:absolute; top:4px; left:0; width:4px; height:4px; border-radius:10px; background-color:#aaa;}
.noti ul li em {color:#dc0610;}
@media all and (min-width:480px) {
	.noti ul li {padding-left:15px; font-size:16px;}
	.noti ul li:after {top:7px; width:6px; height:6px;}
}
</style>
<% if isApp=1 then %>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js"></script>
<% end if %>

<script type="text/javascript">
<%
	Dim vQuery, vCheck
	
	vQuery = "select count(*) from [db_user].dbo.tbl_user_coupon where masteridx = '690' and userid = '" & vUserID & "'"
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

	<% If vUserID <> "" Then %>
		<% If vCheck = "2" then %>
			alert("이미 다운받으셨습니다.");
		<% Else %>
			frmGubun2.mode.value = "coupon";
		   frmGubun2.action = "/event/etc/doEventSubscript58559.asp";
		   frmGubun2.submit();
	   <% End If %>
	<% End If %>

}
</script>
</head>
<body>
<div class="content" id="contentArea">
	<div class="mEvt58559">
		<h1><img src="http://webimage.10x10.co.kr/eventIMG/2015/58559/tit_thank_u.png" alt="고마워요 앱쿠폰" /></h1>
		<p class="coupon">
		<% If vUserID = "" Then %>
			<a href="" onclick="jsSubmitC(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58559/img_coupon.png" alt="앱 전용 만원쿠폰 다운받기! 삼만원 이상 구매시, 1월 20일 화요일 하루 앱에서만 사용가능합니다." /></a>
		<% End If %>
		
		
		<% If vUserID <> "" Then %>
			<% If vCheck = "2" then %>
				<span><img src="http://webimage.10x10.co.kr/eventIMG/2015/58559/img_coupon_end.png" alt="다운로드가 완료되었습니다. 12.30일 자정까지 APP에서 사용하세요!"></span>
			<% Else %>
				<a href="" onclick="jsSubmitC(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58559/img_coupon.png" alt="앱 전용 만원쿠폰 다운받기! 삼만원 이상 구매시, 1월 20일 화요일 하루 앱에서만 사용가능합니다." /></a>
		   <% End If %>
		<% End If %>
		</p>
		
		
		<div class="btnwrap">
			<% if isApp=1 then %>
			<% Else %>
			<a href="http://bit.ly/1m1OOyE" id="mo" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58559/btn_down.png" alt="텐바이텐 앱을 설치하세요! 텐바이텐 앱 다운받기" /></a>
			<% End If %>
			
			<% If vUserID = "" Then %>
				<% if isApp=1 then %>
				<p><a href="" onClick="fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58559/btn_join.png" alt="텐바이텐에 처음 오셨나요? 회원가입하고 구매하러 가기" /></a></p>
				<% Else %>
				<a href="/member/join.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58559/btn_join.png" alt="텐바이텐에 처음 오셨나요? 회원가입하고 구매하러 가기" /></a>
				<% End If %>
			<% End If %>
		</div>
		<div class="noti">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58559/tit_noti.png" alt="사용전 꼭꼭 읽어보세요!" /></h2>
			<ul>
				<li><em>텐바이텐 APP에서만 사용 가능합니다.</em></li>
				<li>한 ID당 1회 발급, 1회 사용할 수 있습니다.</li>
				<li>쿠폰은 금일 1/20(화) 23시59분 종료됩니다. </li>
				<li>주문상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
				<li>이벤트는 조기 마감될 수 있습니다.</li>
			</ul>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58559/img_guide.png" alt="주문시 할인정보의 모바일 쿠폰에서 해당 쿠폰을 확인 하실 수 있습니다." /></p>
		</div>
	</div>

	<form name="frmGubun2" method="post" action="/event/etc/doEventSubscript58559.asp" style="margin:0px;" target="evtFrmProc">
	<input type="hidden" name="mode" value="">
	</form>
	<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->