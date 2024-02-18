<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
'##############################################################
'[만원의 행복] 쿠폰. 득템. 성공적!
'2015-03-05 이종화
'##############################################################
	Dim vUserID, eCode, cMil, vMileValue, vMileArr
	vUserID = GetLoginUserID
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21481"
	Else
		eCode = "59981"
	End If

	Dim strSql , totcnt
	'// 응모여부
	strSql = "select count(*) from db_event.dbo.tbl_event_subscript where userid = '"& vUserID &"' and convert(varchar(10),regdate,120) = '"& Date() &"' and evt_code = '"& ecode &"' " 
	rsget.Open strSql,dbget,1
	IF Not rsget.Eof Then
		totcnt = rsget(0)
	End IF
	rsget.close()
%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title></title>
<style type="text/css">
img {vertical-align:top;}
.coupon {position:relative;}
.coupon a {display:block; position:absolute; left:25%; bottom:9.5%; width:50%; height:17%; color:transparent;}
.btnwrap {padding-top:25px; background-color:#f4f7f7;}
.btnwrap a {display:block; padding-bottom:25px;}
.noti {background:url(http://webimage.10x10.co.kr/eventIMG/2015/59981/bg_dash.gif) left top no-repeat; background-size:100% auto;}
.noti h2 {text-align:center; padding:20px 0 15px;}
.noti h2 span {padding:0 5px; color:#dc0610; font-size:14px; font-weight:bold; border-bottom:2px solid #dc0610;}
.noti ul {margin-bottom:6%; padding:0 4.8%}
.noti ul li {position:relative; margin-top:2px; padding-left:10px; color:#444; font-size:11px; line-height:1.3;}
.noti ul li:after {content:' '; display:block; position:absolute; top:4px; left:0; width:4px; height:4px; border-radius:50%; background-color:#aaa;}
.noti ul li:first-child:after {background-color:#dc0610;}
.noti ul li em {color:#dc0610;}
@media all and (min-width:480px) {
	.btnwrap {padding-top:38px;}
	.btnwrap a {padding-bottom:38px;}
	.noti h2 {padding:30px 0 23px;}
	.noti h2 span {padding:0 7px; font-size:21px; border-bottom:3px solid #dc0610;}
	.noti ul li {margin-top:3px; padding-left:15px;font-size:17px;}
	.noti ul li:after {top:6px; width:6px; height:6px;}
}
</style>
<% if isApp=1 then %>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js"></script>
<% end if %>
<script type="text/javascript">
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
		<% If totcnt > 1 then %>
			alert("이미 다운받으셨습니다.");
		<% Else %>
			frmGubun2.mode.value = "go";
			frmGubun2.action = "/event/etc/doEventSubscript59981.asp";
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
<div class="mEvt59981">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/59981/tit_today_coupon.gif" alt="오늘도! 득템! 성공적!" /></h2>
	<p class="coupon">
		<img src="http://webimage.10x10.co.kr/eventIMG/2015/59981/btn_download.gif" alt="다운받기를 누르면 10,000쿠폰, 10,000마일리지 둘 중 하나가 지급됩니다!" />
		<a href="" onclick="jsSubmitC(); return false;">다운받기</a>
	</p>
	<div class="btnwrap">
		<% if isApp <> 1 then %>
			<a href="" onclick="gotoDownload();return false;" id="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59981/btn_app_down.gif" alt="텐바이텐 앱을 설치하세요! 텐바이텐 앱 다운받기" /></a>
		<% End If %>

		<% If vUserID = "" Then %>
			<% if isApp=1 then %>
			<a href="" onClick="fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59981/btn_join.gif" alt="텐바이텐에 처음 오셨나요? 회원가입하고 구매하러 가기" /></a>
			<% Else %>
			<a href="/member/join.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59981/btn_join.gif" alt="텐바이텐에 처음 오셨나요? 회원가입하고 구매하러 가기" /></a>
			<% End If %>
		<% End If %>
	</div>
	<div class="noti">
		<h2><span>사용전 꼭꼭 읽어보세요!</span></h2>
		<ul>
			<li><em>지급된 쿠폰은 텐바이텐 APP에서만 사용가능 합니다.</em></li>
			<li>이벤트는 ID 당 1일 1회만 참여할 수 있습니다. </li>
			<li>쿠폰은 금일 3/11(수) 23시59분 종료됩니다.</li>
			<li>지급된 마일리지는 3만원 이상 구매 시 현금처럼 사용 가능합니다.</li>
			<li>주문하시는 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
			<li>이벤트는 조기 마감 될 수 있습니다.</li>
		</ul>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59981/img_ex.gif" alt="주문시 할인정보의 모바일 쿠폰에서 해당 쿠폰을 확인 하실 수 있습니다." /></p>
	</div>
</div>
<form name="frmGubun2" method="post" action="/event/etc/doEventSubscript59981.asp" style="margin:0px;" target="evtFrmProc">
<input type="hidden" name="mode" value="">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->