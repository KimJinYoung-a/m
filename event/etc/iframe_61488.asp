<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
	Dim vUserID, eCode
	vUserID = GetLoginUserID
	IF application("Svr_Info") = "Dev" THEN
		eCode = "60739"
	Else
		eCode = "61488"
	End If
%>
<style type="text/css">
.aprilHoney {position:relative; margin-bottom:-50px;}
.aprilHoney img {vertical-align:top;}
.aprilHoney .evtItem {position:relative;}
.aprilHoney .evtItem a {display:none; position:absolute; color:transparent; z-index:20;}
.aprilHoney .mainEvt {padding-bottom:8px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/60829/m/bg_wave.gif) left bottom repeat-x #ffd34b; background-size:50px auto;}
.aprilHoney .mainEvt .couponDown {position:absolute; left:3%; top:7%; width:94%; height:22%; color:transparent; cursor:pointer;}
.aprilHoney .mainEvt .e02 a {left:3%; top:40%; width:45.5%; height:49.5%;}
.aprilHoney .mainEvt .e03 a {right:3%; top:40%; width:45.5%; height:49.5%;}
.aprilHoney .onlyAppEvt .e01 {position:relative;}
.aprilHoney .onlyAppEvt .e01 a {left:3%; top:11%; width:94%; height:82%;}
.aprilHoney .onlyAppEvt .e02 {position:relative;}
.aprilHoney .onlyAppEvt .e02 a {left:3%; top:15%; width:94%; height:62%;}
.aprilHoney .otherEvt {padding-top:18px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/60829/m/bg_wave02.gif) left top repeat-x #fff; background-size:50px auto;}
.aprilHoney .otherEvt .e01 a {left:3%; top:21%; width:45.5%; height:62%;}
.aprilHoney .otherEvt .e02 a {right:3%; top:21%; width:45.5%; height:62%;}
.honeyCouponLyr {display:none; position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.5);}
.honeyCouponLyr .closeLyr {color:#fff; font-size:16px; cursor:pointer;}
</style>
<script type="text/javascript">
$(function(){
	$('.mainEvt .couponDown').click(function(){
		<% If vUserID = "" Then %>
		jsLoginLogin();
		<% Else %>
		jsDownCoupon('prd,prd,prd,prd','10144,10147,10148,10149'); return false;
		<% End If %>
	});
	$('.closeLyr').click(function(){
		$('.honeyCouponLyr').hide();
	});

	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		$('a.ma').css('display','block');
	}else{
		$('a.mw').css('display','block');
	}
});

function jsLoginLogin(){
	<% if isApp=1 then %>
		parent.calllogin();
		return false;
	<% else %>
		parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
		return false;
	<% end if %>
}

function jsDownCoupon(stype,idx){
<% IF IsUserLoginOK THEN %>
var frm;
	frm = document.frmC;
	frm.action = "/shoppingtoday/couponshop_process.asp";
	frm.stype.value = stype;	
	frm.idx.value = idx;	
	frm.submit();
<%ELSE%>
	if(confirm("로그인하시겠습니까?")) {
		parent.location="/login/loginpage.asp?backpath=/event/2015openevent/";
	}
<%END IF%>
}
</script>
<% if isApp=1 then %>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js"></script>
<% end if %>
</head>
<body>
<div class="evtCont">
	<div class="aprilHoney">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/60829/m/tit_april_honey.gif" alt="사월의 꿀맛" /></h2>

		<%
		'//앱
		if isApp=1 then
		%>
			<div class="evtItem mainEvt">
				<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/60829/m/img_main_event.gif" alt="" /></div>
				<div class="e01 couponDown">쿠폰 다운로드</div>
				<div class="e02"><a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=61489" class="ma" target="_top">삼시세번 이벤트 바로가기(APP)</a></div>
				<div class="e03"><a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=61490" class="ma" target="_top">덤&amp;MOOMIN 이벤트 바로가기(APP)</a></div>
			</div>
			<div class="evtItem onlyAppEvt">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/60829/m/tit_mobile_honey.gif" alt="사월의 꿀맛" /></h3>
				<div class="e01">
					<a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=61491" class="ma" target="_top">쫄깃한 득템 이벤트 바로가기(APP)</a>
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/60829/m/bnr_app_brand04<%= Format00(2,day(now())) %>.gif" alt="" /></div>
				</div>
				<div class="e02">
				<% If Now() > #04/12/2015 00:00:00# AND Now() < #04/17/2015 00:00:00# Then	'### 지니 %>
					<a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=60930" class="ma" target="_top">셋콤달콤 이벤트 바로가기(APP)</a>
				<% ElseIf Now() > #04/17/2015 00:00:00# AND Now() < #04/21/2015 00:00:00# Then	'### 요기요 %>
					<a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=60931" class="ma" target="_top">셋콤달콤 이벤트 바로가기(APP)</a>
				<% ElseIf Now() > #04/21/2015 00:00:00# AND Now() < #04/25/2015 00:00:00# Then	'### 메가박스 %>
					<a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=60932" class="ma" target="_top">셋콤달콤 이벤트 바로가기(APP)</a>
				<% End If %>
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/60829/m/bnr_three_lucky.gif" alt="" /></div>
				</div>
			</div>
			<div class="evtItem otherEvt">
				<div class="e01"><a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=61494" class="ma" target="_top">일상다반사 이벤트 바로가기(APP)</a></div>
				<div class="e02"><a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=61493" class="ma" target="_top">단지 널 사랑해 이벤트 바로가기(APP)</a></div>
				<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/60829/m/img_other_event.gif" alt="" /></div>
			</div>
		<% 
		'/모바일웹
		else
		%>
		<div class="evtItem mainEvt">
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/60829/m/img_main_event.gif" alt="" /></div>
			<div class="e01 couponDown">쿠폰 다운로드</div>
			<div class="e02"><a href="/event/eventmain.asp?eventid=61489" target="_top" class="mw">삼시세번 이벤트 바로가기(M)</a></div>
			<div class="e03"><a href="/event/eventmain.asp?eventid=61490" target="_top" class="mw">덤&amp;MOOMIN 이벤트 바로가기(M)</a></div>
		</div>
		<div class="evtItem onlyAppEvt">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/60829/m/tit_mobile_honey.gif" alt="사월의 꿀맛" /></h3>
			<div class="e01">
				<a href="/event/eventmain.asp?eventid=61491" target="_top" class="mw">쫄깃한 득템 이벤트 바로가기(M)</a>
				<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/60829/m/bnr_app_brand04<%= Format00(2,day(now())) %>.gif" alt="" /></div>
			</div>
			<div class="e02">
				<a href="/event/eventmain.asp?eventid=60933" target="_top" class="mw">셋콤달콤 이벤트 바로가기(M)</a>
				<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/60829/m/bnr_three_lucky.gif" alt="" /></div>
			</div>
		</div>
		<div class="evtItem otherEvt">
			<div class="e01"><a href="/event/eventmain.asp?eventid=61494" target="_top" class="mw">일상다반사 이벤트 바로가기(M)</a></div>
			<div class="e02"><a href="/event/eventmain.asp?eventid=61493" target="_top" class="mw">단지 널 사랑해 이벤트 바로가기(M)</a></div>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/60829/m/img_other_event.gif" alt="" /></div>
		</div>
		<% end if %>

	</div>
	<div class="honeyCouponLyr">
		<p style="color:#fff;">쿠폰 다운로드</p>
		<p class="closeLyr">레이어닫기</p>
	</div>
</div>
<form name="frmC" method="get" action="/shoppingtoday/couponshop_process.asp" style="margin:0px;">
<input type="hidden" name="stype" value="">
<input type="hidden" name="idx" value="">
</form>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->