<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 0원의 기적
' History : 2015.02.09 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/web2014/event/etc/event59405Cls.asp" -->

<%
dim eCode, userid, subscriptcount, totalsubscriptcount, bonuscouponcount, totalbonuscouponcount, limitbounscoupon
	eCode   = getevt_code
	userid = getloginuserid()

subscriptcount = 0
bonuscouponcount = 0
totalsubscriptcount = 0
totalbonuscouponcount = 0
limitbounscoupon = 0

limitbounscoupon=datecouponlimit(left(currenttime,10))

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
	bonuscouponcount = getbonuscouponexistscount(userid, datecouponval(), "", "", "")
end if

'//전체 참여수
totalsubscriptcount = getevent_subscripttotalcount(eCode, left(currenttime,10), "", "")
totalbonuscouponcount = getbonuscoupontotalcount(datecouponval(), "", "", left(currenttime,10))

%>

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->

<style type="text/css">
.mEvt59405 {position:relative; margin-bottom:-50px;}
.mEvt59405 img {vertical-align:top;}
.mEvt59405 .evtNoti {padding:27px 10px; border-top:1px solid #e7e9e9; background:#f4f7f7;}
.mEvt59405 .evtNoti dt {display:inline-block; font-size:14px; font-weight:bold; color:#222; padding-bottom:1px; margin-bottom:13px; border-bottom:2px solid #222;}
.mEvt59405 .evtNoti li {position:relative; color:#444; font-size:11px; line-height:1.4; padding-left:10px;}
.mEvt59405 .evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:5px; width:0; height:0; width:4px; height:1px; background:#444;}
.couponDownload {position:relative;}
.couponDownload .downBtn {position:absolute; left:17%; bottom:6.5%; display:block; width:66%; height:10%; color:transparent; z-index:30;}
.couponDownload .soldout {position:absolute; left:0; top:0; width:100%; z-index:40;}
@media all and (min-width:480px){
	.mEvt59405 .evtNoti {padding:40px 15px;}
	.mEvt59405 .evtNoti dt {font-size:21px; margin-bottom:20px;}
	.mEvt59405 .evtNoti li {font-size:17px; padding-left:15px;}
	.mEvt59405 .evtNoti li:after {top:6px; border-width:5px 0 5px 7px;}
}
</style>
<script type="text/javascript">

function jseventSubmit(frm){
	<% If not( IsUserLoginOK() ) Then %>
		//alert('로그인을 하셔야 참여가 가능 합니다');
		parent.calllogin();
		return;
	<% Else %>
		<% If not( left(currenttime,10)>="2015-02-10" and left(currenttime,10)<"2015-02-18" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if subscriptcount>0 or bonuscouponcount>0 then %>
				alert("한 개의 아이디당 한 번만 응모하실 수 있습니다.");
				return false;
			<% else %>
				<% if totalsubscriptcount>=limitbounscoupon or totalbonuscouponcount>=limitbounscoupon then %>
					alert("앗, 오늘의 쿠폰이 모두 소진되었어요!");
					return;
				<% else %>
					<% if staffconfirm and  request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW %>
						alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
						return;
					<% else %>
						<% if dateopenyn(currenttime)<>"Y" then %>
							alert("오늘의 0원의 기적은 아직 오픈전입니다!");
							return;
						<% else %>
							frm.action="doEventSubscript59405.asp";
							frm.target="evtFrmProc";
							frm.mode.value='iteminsert';
							frm.submit();
						<% end if %>
					<% end if %>
				<% end if %>
			<% end if %>
		<% end if %>
	<% End IF %>
}

</script>
</head>
<body>

<!-- 0원의 기적(APP) -->
<div class="mEvt59405">
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59405/txt_caution.gif" alt="CAUTION - 본 이벤트 페이지는 나가면, 다시 돌아 올 수 없어요!" /></p>
	<div class="couponDownload">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/59405/img_zero_miracle.gif" alt="0원의 기적" /></h2>
		
		<% if totalsubscriptcount>=limitbounscoupon or totalbonuscouponcount>=limitbounscoupon then %>
			<p onclick="alert('오늘의 쿠폰이 모두 소진되었어요!'); return false;" class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59405/txt_soldout.png" alt="오늘의 쿠폰이 모두 소진되었어요!" /></p>
		<% else %>
			<a href="#" onclick="jseventSubmit(evtFrm1); return false;" class="downBtn">순수한 쿠폰 다운받기</a>
		<% end if %>
	</div>
	<dl class="evtNoti">
		<dt>이벤트 주의사항</dt>
		<dd>
			<ul>
				<li>본 이벤트는 로그인 후에 참여가 가능합니다.</li>
				<li>본 이벤트는 신규 앱 설치한 고객을 대상으로 한 시크릿 이벤트입니다.</li>
				<li>ID 당 1회만 쿠폰 다운이 가능합니다.</li>
				<li>지급된 쿠폰은 자정 기준으로 자동 소멸되며, 구매제한이 없습니다. 단, APP에서 만 사용이 가능합니다. (PC, 모바일웹에서 사용불가)</li>
				<li>다른 쿠폰과 함께 사용 수 없습니다.</li>
			</ul>
		</dd>
	</dl>
	<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
	<input type="hidden" name="mode">
	</form>
	<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</div>
<!--// 0원의 기적(APP) -->

</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->