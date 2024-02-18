<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 미안하다 생색이다 1차 & 2차 합본
' History : 2014-12-04 이종화 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/apps/appcom/wish/web2014/event/etc/event57030Cls.asp" -->

<%
dim eCode, userid, subscriptcount, bonuscouponcount, totalsubscriptcount, totalbonuscouponcount
dim ename, cEvent, emimg, smssubscriptcount, usercell, folderimgselect , folderimgselect2 , noticetxt
	eCode=getevt_code
	userid = getloginuserid()


'// 12월 5일 쿠폰과 10일 쿠폰 배경 이미지가 틀리기땜에..
If left(Trim(currenttime),10)>="2014-12-05" And left(Trim(currenttime),10) < "2014-12-06" Then
	folderimgselect = "57030"
	folderimgselect2 = "57029"
	noticetxt = "12/5(금)"
ElseIf left(Trim(currenttime),10)>="2014-12-10" And left(Trim(currenttime),10) < "2014-12-11" Then
	folderimgselect = "57247"
	folderimgselect2 = "57246"
	noticetxt = "12/10(수)"
Else
	folderimgselect = "57030"
	folderimgselect2 = "57029"
	noticetxt = "12/5(금)"
End If

bonuscouponcount=0
subscriptcount=0
totalsubscriptcount=0
totalbonuscouponcount=0
smssubscriptcount=0
usercell=""

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "2", "")
	bonuscouponcount = getbonuscouponexistscount(userid, getbonuscoupon, "", "", "")
end if

'//전체 참여수
totalsubscriptcount = getevent_subscripttotalcount(eCode, left(currenttime,10), "2", "")
'//전체 쿠폰 발행수량
totalbonuscouponcount = getbonuscoupontotalcount(getbonuscoupon, "", "", left(currenttime,10))

set cEvent = new ClsEvtCont
	cEvent.FECode = eCode
	cEvent.fnGetEvent
	
	eCode		= cEvent.FECode	
	ename		= cEvent.FEName
	emimg		= cEvent.FEMimg
set cEvent = nothing

smssubscriptcount = getevent_subscriptexistscount(eCode, userid, "", "1", "")
usercell = getusercell(userid)
%>

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<style type="text/css">
.mEvt<%=folderimgselect%> {position:relative;}
.mEvt<%=folderimgselect%> img {vertical-align:top;}
.mEvt<%=folderimgselect%> .appCoupon {position:relative;}
.mEvt<%=folderimgselect%> .appCoupon a {position:absolute; left:27%; bottom:18%; display:block; width:46%;}
.mEvt<%=folderimgselect%> .appInstall {position:relative;}
.mEvt<%=folderimgselect%> .appInstall a {position:absolute; left:11%; bottom:20%; display:block; width:78%;}
.mEvt<%=folderimgselect%> .evtNoti {padding:27px 0; background:#fff; margin-bottom:-50px;}
.mEvt<%=folderimgselect%> .evtNoti dl {padding:0 14px 15px;}
.mEvt<%=folderimgselect%> .evtNoti dt {display:inline-block; font-size:14px; font-weight:bold; color:#222; padding-bottom:1px; margin-bottom:13px; border-bottom:2px solid #222;}
.mEvt<%=folderimgselect%> .evtNoti li {position:relative; color:#444; font-size:11px; line-height:1.4; padding-left:11px;}
.mEvt<%=folderimgselect%> .evtNoti li span {color:#ff0000;}
.mEvt<%=folderimgselect%> .evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:3px; width:0; height:0; border-style:solid; border-width:3.5px 0 3.5px 5px; border-color:transparent transparent transparent #5c5c5c;}
@media all and (min-width:480px){
	.mEvt<%=folderimgselect%> .evtNoti {padding:40px 0;}
	.mEvt<%=folderimgselect%> .evtNoti dl {padding:0 21px 23px;}
	.mEvt<%=folderimgselect%> .evtNoti dt {font-size:21px; margin-bottom:20px;}
	.mEvt<%=folderimgselect%> .evtNoti li {font-size:17px; padding-left:17px;}
	.mEvt<%=folderimgselect%> .evtNoti li:after {top:4px; border-width:5px 0 5px 7px;}
}
</style>
<script type="text/javascript">

	function jsCheckLimit() {
		if ("<%=IsUserLoginOK%>"=="False") {
			jsChklogin('<%=IsUserLoginOK%>');
		}
	}

	function jseventSubmit(frm){
		<% if not(geteventisusingyn) then %>
			alert("종료 되었습니다.");
			return;
		<% end if %>

		<% If IsUserLoginOK() Then %>
			<% If left(currenttime,10)>="2014-12-05" and left(currenttime,10)<"2014-12-06" or left(currenttime,10)>="2014-12-10" and left(currenttime,10)<"2014-12-11" Then %>
				<% if subscriptcount=0 and bonuscouponcount=0 then %>
					<% if totalsubscriptcount>=getlimitcnt or totalbonuscouponcount>=getlimitcnt then %>
						alert("종료 되었습니다.");
						return;
					<% else %>
						<% if Hour(currenttime) < 09 then %>
							alert("쿠폰은 오전 9시부터 다운 받으실수 있습니다.");
							return;
						<% else %>
							frm.action="/apps/appcom/wish/web2014/event/etc/doEventSubscript57030.asp";
							frm.target="evtFrmProc";
							frm.mode.value='couponreg';
							frm.submit();
						<% end if %>
					<% end if %>
				<% else %>
					alert("쿠폰은 한 개의 아이디당 한 번만 다운 받으실 수 있습니다.");
					return;
				<% end if %>
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% end if %>
		<% Else %>
			parent.calllogin();
			return;
		<% End IF %>
	}
</script>
</head>
<body>
<div class="evtCont">
	<!-- 미안하다 생색이다(APP) -->
	<div class="mEvt<%=folderimgselect%>">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/<%=folderimgselect2%>/tit_sorry.png" alt="미안하다 생색이다 - 센스있는 연말선물 걱정마세요~ 텐바이텐이 있잖아요! 오늘 하루 생색나는 APP쿠폰을 자신있게 쏩니다" /></h2>
		<div class="appCoupon">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/<%=folderimgselect2%>/img_app_coupon.png" alt="오늘 하루 APP에서 5,000원 쿠폰" /></p>
			<a href="" onclick="jseventSubmit(evtFrm1); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/<%=folderimgselect2%>/btn_coupon_download.png" alt="쿠폰 다운받기" /></a>
		</div>
		<p><a href="" onclick="<% If IsUserLoginOK() Then %>alert('이미 회원가입이 되어 있습니다.'); return false;<% Else %>fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp');return false;<% End If %>"><img src="http://webimage.10x10.co.kr/eventIMG/2014/<%=folderimgselect2%>/btn_join02.png" alt="텐바이텐 가입하고 첫구매 하러가기" /></a></p>
		<div class="evtNoti">
			<dl>
				<dt>이벤트 유의사항</dt>
				<dd>
					<ul>
						<li>텐바이텐 APP에서만 사용가능 합니다.</li>
						<li>한 ID당 1회 발급, 1회 사용할 수 있습니다.</li>
						<li>쿠폰은 금일 <%=noticetxt%> 23시 59분 종료됩니다.</li>
						<li>주문하시는 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
						<li>이벤트는 조기 마감 될 수 있습니다.</li>
					</ul>
				</dd>
			</dl>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57029/img_ex.png" alt="" /></p>
		</div>
	</div>
	<!-- 미안하다 생색이다(APP) -->
</div>
<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
	<input type="hidden" name="mode">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->