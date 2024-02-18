<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
	Dim vUserID, eCode, vQuery, vCheck
	vUserID = GetLoginUserID

	IF application("Svr_Info") = "Dev" THEN
		eCode = "21525"
	Else
		eCode = "60777"
	End If

	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & vUserID & "' And evt_code='"&eCode&"' "
	rsget.Open vQuery,dbget,1
	If rsget(0) > 0 Then
		vCheck = "2"
	End IF
	rsget.close()
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {width:100%; vertical-align:top;}
.couponDownload {position:relative; border-bottom:1px solid #beddf3;}
.couponDownload .soldout {position:absolute; left:0; top:0; width:100%;}
.article {padding:20px 0; background:#e9f7ff;}
.noti {padding:25px 10px 0;}
.noti h2 {color:#dc0610; font-size:14px; color:#222; font-weight:bold; line-height:1; padding-left:10px;}
.noti h2 span {display:inline-block; padding-bottom:1px; border-bottom:2px solid #222;}
.noti ul {margin-top:15px;}
.noti ul li {position:relative; margin-top:2px; padding-left:10px; color:#333; font-size:11px; line-height:1.438em; letter-spacing:-0.013em;}
.noti ul li:after {content:' '; display:block; position:absolute; top:4px; left:0; z-index:5; width:3px; height:3px; border-radius:50%; background-color:#aaa;}
@media all and (min-width:480px) {
	.article {padding:38px 0;}
	.noti {padding:30px 15px 0;}
	.noti h2 {font-size:21px; padding-left:15px;}
	.noti h2 span {padding-bottom:2px;}
	.noti ul {margin-top:23px;}
	.noti ul li {margin-top:3px; padding-left:15px; font-size:17px;}
	.noti ul li:after {top:7px; width:5px; height:5px;}
}
</style>
<script type="text/javascript">
	$(function(){
		var chkapp = navigator.userAgent.match('tenapp');
		if ( chkapp ){
			$("#mo").hide();
		}else{
			$("#mo").show();
		}
});

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
			alert("이미 마일리지를 받으셨습니다.");
		<% Else %>
			frmGubun2.mode.value = "mileage";
			frmGubun2.action = "/event/etc/doEventSubscript60777.asp";
			frmGubun2.submit();
	   <% End If %>
	<% End If %>
}

function jsSoldOut(){
	$(".soldout").show();
}
</script>
</head>
<body>
	<div class="mEvt60777">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/60777/tit_favor_mileage.gif" alt="마일리지를 부탁해!" /></h2>
		<div class="couponDownload">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60777/img_mileage.gif" alt="선착순 10,000명 한정 5000마일리지 다운받기" /></p>
			<a href="" onClick="jsSubmitC(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60777/btn_mileage.gif" alt="마일리지 다운받기" /></a>
			<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60777/img_soldout03.png" alt="쿠폰이 모두 소진되었어요!" /></p>
		</div>
		
		<% if isApp=1 then %>
		<% Else %>
			<div class="article"><div id="mo" class="app"><a href="http://bit.ly/1m1OOyE" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60777/btn_app_download.png" alt="텐바이텐 앱 다운받기" /></a></div></div>
		<% End If %>
		<% If vUserID = "" Then %>
			<% if isApp=1 then %>
				<div class="article"><div class="join"><a href="" onClick="fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60777/btn_join.png" alt="회원가입하고 구매하러 가기" /></a></div></div>
			<% Else %>
			<div class="article"><div class="join"><a href="/member/join.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60777/btn_join.png" alt="회원가입하고 구매하러 가기" /></a></div></div>
			<% End If %>
		<% End If %>
		
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60777/txt_tip.gif" alt="마일리지는 결제 시, 현금처럼 사용할 수 있습니다." /></p>
		<div class="noti">
			<h2><span>사용전 꼭꼭 읽어보세요!</span></h2>
			<ul>
				<li>본 이벤트는 로그인 후에 참여할 수 있습니다.</li>
				<li>이벤트는 ID당 1회만 참여할 수 있습니다.</li>
				<li>주문하시는 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
				<li>지급된 마일리지는 3만원 이상 구매 시 현금처럼 사용 가능합니다.</li>
				<li>기간 내에 사용하지 않은 마일리지는 사전 통보 없이 자동 소멸합니다.</li>
				<li>이벤트는 조기 마감 될 수 있습니다.</li>
			</ul>
		</div>
	</div>
	<form name="frmGubun2" method="post" action="/event/etc/doEventSubscript60777.asp" style="margin:0px;" target="evtFrmProc">
	<input type="hidden" name="mode" value="">
	</form>
	<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->