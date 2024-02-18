<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  [2월 스페셜 쿠폰] 신이 텐바이텐 쿠폰을 만들 때
' History : 2014.02.14 한용민 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event49384Cls.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->

<%
dim eCode, userid, eventnewexists, couponnewcount, subscriptcount
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

<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 썸만 타다 끝낼 건가요?!</title>
<style type="text/css">
.mEvt49385 img {vertical-align:top;}
.mEvt49385 p {max-width:100%;}
.godMakeCoupon ul {overflow:hidden;}
.godMakeCoupon ul li {float:left; width:50%;}
.godMakeCoupon ul li img {width:100%;}
</style>

<script type="text/javascript">

function jscoupion(coupongubun){
	if (coupongubun==''){
		alert('쿠폰구분이 없습니다.');
		return;
	}
	
	<% If IsUserLoginOK() Then %>
		<% If Now() > #02/23/2014 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			evtFrm1.coupongubun.value=coupongubun;
			evtFrm1.mode.value="couponinsert";
			evtFrm1.submit();
		<% End If %>
	<% Else %>
		alert('로그인을 하셔야 참여가 가능 합니다');
		return;
		//if(confirm("로그인을 하셔야 참여가 가능 합니다. 로그인 하시겠습니까?")){
		//	var winLogin = window.open('/login/PopLoginPage.asp','popLogin','width=400,height=300');
		//	winLogin.focus();
		//	return;
		//}
	<% End IF %>
}

function jsnewcoupion(){
	<% If IsUserLoginOK() Then %>
		<% If Now() > #02/23/2014 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% if eventnewexists then %>
				<% if couponnewcount=0 and subscriptcount=0 then %>
					evtFrm1.mode.value="couponnewinsert";
					evtFrm1.submit();
				<% else %>				
					alert("쿠폰이 이미 발급 되었습니다! \n발급된 쿠폰은 마이텐바이텐 에서\n확인 가능합니다!");
					return;
				<% end if %>
			<% else %>
				alert("쿠폰 다운로드 대상자가 아닙니다.");
				return;
			<% end if %>
		<% End If %>
	<% Else %>
		alert('로그인을 하셔야 참여가 가능 합니다');
		return;
		//if(confirm("로그인을 하셔야 참여가 가능 합니다. 로그인 하시겠습니까?")){
		//	var winLogin = window.open('/login/PopLoginPage.asp','popLogin','width=400,height=300');
		//	winLogin.focus();
		//	return;
		//}
	<% End IF %>
}

</script>

</head>
<body>

<div class="mEvt49385">
	<div class="godMake">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49385/txt_god_make_coupon_only.jpg" alt="[텐바이텐 회원혜택] 2월 SPECIAL COUPON" style="width:100%;" /></p>
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/49385/tit_god_make_coupon.jpg" alt="신이 텐바이텐 쿠폰을 만들 때" style="width:100%;" /></h2>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49385/txt_god_make_coupon_date.jpg" alt="조물 조물 텐바이텐 2월의 쿠폰을 만들어 볼게요. 사랑 한 스푼, 감사 한 컵.. 2014. 02. 17 ~ 02. 23 (단, 7일간)" style="width:100%;" /></p>

		<!-- 쿠폰 다운 받기 -->
		<div class="godMakeCoupon">
			<ul>
				<li class="god01">
					<a href="" onclick="jsnewcoupion(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49385/img_god_make_coupon_01.jpg" alt="첫 구매 쿠폰 4천원 (3만원 이상 구매시) 다운 받기 : 첫 구매 고객님만 받을 수 있는 쿠폰입니다." /></a>
				</li>
				<li class="god02">
					<a href="" onclick="jscoupion('8'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49385/img_god_make_coupon_02.jpg" alt="2월에 쇼핑하는 회원님은 고마운 마음 담아서 쿠폰 한 컵 : 8% 할인 쿠폰 (5만원 이상 구매시)" /></a>
				</li>
				<li class="god03">
					<a href="" onclick="jscoupion('10'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49385/img_god_make_coupon_03.jpg" alt="이것 저것 담으신 고객님은 아이쿠 손이 미끄러졌... : 10% 할인 쿠폰 (10만원 이상 구매시)" /></a>
				</li>
				<li class="god04">
					<a href="" onclick="jscoupion('13'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49385/img_god_make_coupon_04.jpg" alt="쇼핑 많이 한 고객님은 어..어푸..푸..어푸.. : 13% 할인 쿠폰 (15만원 이상 구매시)" /></a>
				</li>
			</ul>
			<div>
				<a href="" onclick="jscoupion('all'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49385/btn_download.jpg" alt="쿠폰 한 번에 다운받기 " style="width:100%;" /></a>
			</div>
		</div>
		<!-- //쿠폰 다운 받기 -->
		<div class="godMakeNote">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/49385/tit_god_make_note.jpg" alt="신님이 말하길.." style="width:100%;" /></h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49385/txt_god_make_note.jpg" alt="텐바이텐 회원을 대상으로한 혜택입니다. (비회원 발급 불가) 다운받은 쿠폰은 마이텐바이텐에서 확인할 수 있습니다. 첫 구매 쿠폰은 가입 후 구매 경험이 없는 고객분들만 다운이 가능합니다. ·모든 쿠폰의 사용 기간은 2014년 3월 2일 일요일까지 입니다." style="width:100%;" /></p>
		</div>
	</div>
</div>
<form name="evtFrm1" action="/event/etc/doEventSubscript49384.asp" method="post" target="evtFrmProc" style="margin:0px;">
	<input type="hidden" name="mode">
	<input type="hidden" name="coupongubun">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->