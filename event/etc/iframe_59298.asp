<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
'####################################################
' Description : 만원의 행복 1월
' History : 2015-02-03 이종화
'####################################################
	Dim vUserID, eCode, cMil, vMileValue, vMileArr
	vUserID = GetLoginUserID
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21464"
	Else
		eCode = "59298"
	End If
	
%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>[app쿠폰] 만원의 행복</title>
<style type="text/css">
.mEvt59298 {background:#ffdeb4;}
img {width:100%; vertical-align:top;}
.btnGroup {padding-bottom:30px;}
.btnGroup div {padding-top:27px;}
.noti {padding-top:7%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/59298/bg_dash.gif) left top no-repeat #fff2e4; background-size:100% auto;}
.noti h3 {color:#dc0610; font-size:15px; font-weight:bold; line-height:1.438em; text-align:center;}
.noti h3 span {display:inline-block; padding-bottom:1px; border-bottom:2px solid #dc0610;}
.noti ul {margin:18px 0 13px; padding:0 15px;}
.noti ul li {position:relative; margin-top:2px; padding-left:12px; color:#333; font-size:11px; line-height:1.438em;}
.noti ul li:after {content:' '; display:block; position:absolute; top:4px; left:0; z-index:5; width:4px; height:4px; border-radius:50%; background-color:#aaa;}
.noti ul li:first-child:after {background-color:#dc0610;}
.noti ul li em {color:#dc0610;}
@media all and (min-width:480px) {
	.btnGroup {padding-bottom:45px;}
	.btnGroup div {padding-top:40px;}
	.noti h3 {font-size:23px;}
	.noti ul {margin:27px 0 20px; padding:0 22px;}
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
	
	vQuery = "select count(*) from [db_user].dbo.tbl_user_coupon where masteridx = '701' and userid = '" & vUserID & "'"
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
			frmGubun2.action = "/event/etc/doEventSubscript59298.asp";
			frmGubun2.submit();
	   <% End If %>
	<% End If %>

}

$(function(){
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		$("#mo").hide();
	}else{
		$("#mo").show();
	}
});
</script>
</head>
<body>
<!-- 어머! APP쿠폰! 웬일이니? -->
<div class="mEvt59298">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/59298/tit_app_coupon.gif" alt="어머! APP쿠폰! 웬일이니?" /></h2>
	<div class="down">
		<% If vUserID = "" Then %>
			<a href="" onclick="jsSubmitC(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59298/btn_down_coupon.gif" alt="APP 전용 쿠폰  - 10,000원 다운로드" /></a>
		<% End If %>

		<% If vUserID <> "" Then %>
			<% If vCheck = "2" then %>
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/59298/btn_down_coupon_end.gif" alt="다운로드 완료" />
			<% Else %>
			<a href="" onclick="jsSubmitC(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59298/btn_down_coupon.gif" alt="APP 전용 쿠폰  - 10,000원 다운로드" /></a>
			<% End If %>
		<% End If %>
	</div>

	<div class="btnGroup">
		<div id="mo" class="app"><a href="http://m.10x10.co.kr/event/appdown/" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59298/btn_down_app.gif" alt="아직이신가요? 텐바이텐 앱 다운받기" /></a></div>
		<% If vUserID = "" Then %>
		<div class="join">
			<% if isApp=1 then %>
			<a href="" onClick="fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp');return false;">
			<% Else %>
			<a href="/member/join.asp" target="_top">
			<% End If %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/59298/btn_join.gif" alt="텐바이텐에 처음오셨나요? 회원가입하고 구매하러 가기" />
			</a>
		</div>
		<% End If %>
	</div>

	<div class="noti">
		<h3><span>사용전 꼭꼭 읽어보세요!</span></h3>
		<ul>
			<li><em>텐바이텐 APP에서만 사용 가능합니다.</em></li>
			<li>한 ID당 1일 1회 발급, 1회 사용 할 수 있습니다.</li>
			<li>쿠폰은 금일 2월 4일(수) 23시59분에 종료됩니다.</li>
			<li>주문상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
			<li>이벤트는 조기 마감 될 수 있습니다. </li>
		</ul>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59298/img_ex.gif" alt="주문시 모바일 쿠폰에서 해당 쿠폰을 확인 하실 수 있습니다." /></p>
	</div>
</div>
<!-- //어머! APP쿠폰! 웬일이니? -->
<form name="frmGubun2" method="post" action="/event/etc/doEventSubscript59298.asp" style="margin:0px;" target="evtFrmProc">
<input type="hidden" name="mode" value="">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->