<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description :  [설 명절엔 쇼핑] 쿠폰도 넣어둬 넣어둬
' History : 2015.02.16 유태욱 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event59606Cls.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->

<%
dim eCode, userid, eventnewexists, couponnewcount, subscriptcount, getnewcouponid
	eCode=getevt_code
	userid = getloginuserid()

couponnewcount=0
subscriptcount=0
eventnewexists=getnewuser(userid)
subscriptcount = getevent_subscriptexistscount(eCode, userid, "2", "", "")
couponnewcount = getbonuscouponexistscount(userid, getnewcouponid, "", "", "")

dim cEvent, emimg, ename
set cEvent = new ClsEvtCont
	cEvent.FECode = eCode
	cEvent.fnGetEvent

	ename		= cEvent.FEName
	emimg		= cEvent.FEMimg
set cEvent = nothing
%>

<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.mEvt59605 {}
.mEvt59605 img {width:100%; vertical-align:top;}
.viewOthers {position:relative;}
.viewOthers dd {position:absolute; left:7%; bottom:20%; width:86%;}
.viewOthers dd ul {overflow:hidden;}
.viewOthers dd li {float:left; width:25%; padding:0 1px;}
.putMyWish {padding:0 3% 25px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/59605/bg_stripe.gif) left top repeat-y; background-size:100% auto;}
.putMyWish .putListWrap {background:url(http://webimage.10x10.co.kr/eventIMG/2015/59605/bg_box.gif) left top no-repeat; background-size:100% auto;}
.putMyWish .myFolder {position:relative; text-align:center; }
.putMyWish .myFolder p {padding:20px 0 15px;}
.putMyWish .myFolder p span {display:inline-block; padding:4px 4px 2px 28px; color:#2bb58d; font-size:14px; vertical-align:middle; background:url(http://webimage.10x10.co.kr/eventIMG/2015/59605/ico_cart.gif) left top no-repeat; background-size:20px auto;}
.putMyWish .myFolder p img {width:172px; vertical-align:middle;}
.putMyWish .putList {padding-bottom:7px;}
.putMyWish .putList ul {overflow:hidden; width:292px; height:292px; margin:0 auto; background:url(http://webimage.10x10.co.kr/eventIMG/2015/59605/bg_item01_.png) left top no-repeat; background-size:100% 100%;}
.putMyWish .putList li {float:left; width:50%; padding:3px;}
.evtNoti {padding:22px 10px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/59605/bg_notice.gif) left top repeat-y; background-size:100% auto;}
.evtNoti dt {display:inline-block; margin:0 0 10px 10px;  border-bottom:2px solid #222; color:#222; font-size:13px; line-height:1; padding-bottom:2px; font-weight:bold;}
.evtNoti dd li {position:relative; padding:0 0 5px 10px; font-size:11px; line-height:1.2; color:#444;}
.evtNoti dd li:after {content:' '; display:inline-block; position:absolute; left:0; top:4px; width:4px; height:1px; background:#444;}
.goEvent a {display:none;}
.shareSns {position:relative;}
.shareSns li {position:absolute; top:29%; width:10%; height:46%;}
.shareSns li a {display:block; width:100%;  height:100%; color:transparent;}
.shareSns li.twitter {right:29%;}
.shareSns li.facebook {right:15.5%; width:12%;}
.shareSns li.kakao {right:4%;}
@media all and (min-width:480px){
	.putMyWish {padding:0 3% 38px;}
	.putMyWish .myFolder p {padding:30px 0 23px;}
	.putMyWish .myFolder p span {padding:6px 6px 3px 42px; font-size:21px; background-size:30px auto;}
	.putMyWish .myFolder p img {width:258px;}
	.putMyWish .putList {padding-bottom:11px;}
	.putMyWish .putList ul {width:436px; height:436px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/59605/bg_item02.png)}
	.putMyWish .putList li {padding:4px;}
	.evtNoti {padding:33px 15px;}
	.evtNoti dt {margin:0 0 15px 15px; border-bottom:3px solid #222; font-size:20px; padding-bottom:3px;}
	.evtNoti dd li {padding:0 0 7px 15px; font-size:17px;}
	.evtNoti dd li:after {top:7px; width:5px; height:2px;}
}
</style>
<script type="text/javascript">
$(function(){
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		$('a.ma').css('display','block');
	}else{
		$('a.mw').css('display','block');
	}
});

function jscoupion(coupongubun){
	if (coupongubun==''){
		alert('쿠폰구분이 없습니다.');
		return;
	}

	<% If IsUserLoginOK() Then %>
		<% If Now() > #02/22/2015 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			evtFrm1.coupongubun.value=coupongubun;
			evtFrm1.mode.value="couponinsert";
			evtFrm1.submit();
		<% End If %>
	<% Else %>
		<% if isApp then %>
			parent.calllogin();
		<% else %>
			parent.jsevtlogin();
		<% end if %>
	<% End IF %>
}
</script>
</head>
<body>

	<!-- 이벤트 배너 등록 영역 -->
	<div class="evtCont">

		<!-- 넣어둬 넣어둬 쿠폰 (M) -->
		<div class="mEvt59605">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/59607/tit_coupon.gif" alt="넣어둬 넣어둬" /></h2>
			<p><a href="" onclick="jscoupion('all'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59607/btn_all_download.gif" alt="쿠폰 한번에 넣어두기" /></a></p>
			<p><a href="" onclick="jscoupion('1'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59607/btn_coupon01.gif" alt="1만원이상 구매 시 10% 할인 쿠폰" /></a></p>
			<p><a href="" onclick="jscoupion('3'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59607/btn_coupon02.gif" alt="3만원이상 구매 시 5,000원 할인 쿠폰" /></a></p>
			<p><a href="" onclick="jscoupion('7'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59607/btn_coupon03.gif" alt="7만원이상 구매 시 10,000원 할인 쿠폰" /></a></p>
			<div class="goEvent">
				<% if isApp then %>
					<a href="/event/eventmain.asp?eventid=59605" target="_top" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59607/btn_go_event.gif" alt="넣어둬 넣어둬 이벤트 바로가기" /></a>
				<% else %>
					<a href="/event/eventmain.asp?eventid=59605" target="_top" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59607/btn_go_event.gif" alt="넣어둬 넣어둬 이벤트 바로가기" /></a>
				<% end if %>
			</div>
		</div>
		<!--// 넣어둬 넣어둬 쿠폰 (M) -->
	</div>
	<!--// 이벤트 배너 등록 영역 -->
<form name="evtFrm1" action="/event/etc/doEventSubscript59606.asp" method="post" target="evtFrmProc" style="margin:0px;">
	<input type="hidden" name="mode">
	<input type="hidden" name="coupongubun">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->