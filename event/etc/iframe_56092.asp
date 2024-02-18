<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 결정해줘 app쿠폰
' History : 2014.11.03 원승현 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/event/etc/event56092Cls.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->

<%
dim eCode, userid, subscriptcount, bonuscouponcount, totalsubscriptcount, totalbonuscouponcount
dim ename, cEvent, emimg, smssubscriptcount, usercell, folderimgselect
	eCode=getevt_code
	userid = getloginuserid()


'// 11월 4일 쿠폰과 5일 쿠폰 배경 이미지가 틀리기땜에..
If left(Trim(currenttime),10)>="2014-11-04" And left(Trim(currenttime),10) < "2014-11-05" Then
	folderimgselect = "56092"
ElseIf left(Trim(currenttime),10)>="2014-11-05" And left(Trim(currenttime),10) < "2014-11-06" Then
	folderimgselect = "56094"
Else
	folderimgselect = "56092"
End If

bonuscouponcount=0
subscriptcount=0
totalsubscriptcount=0
totalbonuscouponcount=0
smssubscriptcount=0
usercell=""

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, left(currenttime,10), "2", "")
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
<style type="text/css">
.mEvt56092 {position:relative;}
.mEvt56092 img {vertical-align:top;}
.mEvt56092 .couponDownload a {display:block; position:absolute; left:26%; bottom:16%; width:48%;}
.mEvt56092 .couponDownload span {display:block; position:absolute; left:14%; bottom:14%; width:72%;}
.mEvt56092 .appDownload a {display:block; position:absolute; left:10%; bottom:18%; width:80%;}
.mEvt56092 .evtNoti {padding:27px 14px; background:#fff; margin-bottom:-50px;}
.mEvt56092 .evtNoti dt {display:inline-block; font-size:14px; font-weight:bold; color:#222; padding-bottom:1px; margin-bottom:13px; border-bottom:2px solid #222;}
.mEvt56092 .evtNoti li {position:relative; color:#444; font-size:11px; line-height:1.4; padding-left:11px;}
.mEvt56092 .evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:3px; width:0; height:0; border-style:solid; border-width:3.5px 0 3.5px 5px; border-color:transparent transparent transparent #5c5c5c;}
@media all and (min-width:480px){
	.mEvt56092 .evtNoti {padding:40px 21px;}
	.mEvt56092 .evtNoti dt {font-size:21px; margin-bottom:20px;}
	.mEvt56092 .evtNoti li {font-size:17px; padding-left:17px;}
	.mEvt56092 .evtNoti li:after {top:4px; border-width:5px 0 5px 7px;}
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
			<% If left(currenttime,10)>="2014-11-04" and left(currenttime,10)<"2014-11-06" Then %>
				<% if subscriptcount=0 and bonuscouponcount=0 then %>
					<% if totalsubscriptcount>=getlimitcnt or totalbonuscouponcount>=getlimitcnt then %>
						alert("종료 되었습니다.");
						return;
					<% else %>
						<% if Hour(currenttime) < 09 then %>
							alert("쿠폰은 오전 9시부터 다운 받으실수 있습니다.");
							return;
						<% else %>
							frm.action="/event/etc/doEventSubscript56092.asp";
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
			if(confirm("로그인후 쿠폰 발급이 가능 합니다. 로그인 하시겠습니까?") == true) {
				top.location.href = "/login/login.asp?backpath=/event/eventmain.asp?eventid=56092";
			 }
			return  ;
		<% End IF %>
	}

var userAgent = navigator.userAgent.toLowerCase();
function gotoDownload(){
	// 모바일 홈페이지 바로가기 링크 생성
	if(userAgent.match('iphone')) { //아이폰
		document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011"
	} else if(userAgent.match('ipad')) { //아이패드
		document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011"
	} else if(userAgent.match('ipod')) { //아이팟
		document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011"
	} else if(userAgent.match('android')) { //안드로이드 기기
		document.location="market://details?id=kr.tenbyten.shopping"
	} else { //그 외
		document.location="https://play.google.com/store/apps/details?id=kr.tenbyten.shopping"
	}
};
</script>
</head>
<body>
<% 
	If subscriptcount="0" And bonuscouponcount="0" Then
'		response.write "aa"
	Else
'		response.write "bb"
	End If 

%>
<div class="evtCont">
	<!-- 결정해줘! App쿠폰(M) -->
	<div class="mEvt56092">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/<%=folderimgselect%>/tit_app_coupon.png" alt="결정해줘! APP쿠폰" /></h3>
		<div class="couponDownload posRel">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/<%=folderimgselect%>/img_coupon.png" alt="텐바이텐 APP설치하고 쿠폰쓰러가자!" /></p>
			<% if subscriptcount=0 and bonuscouponcount=0 then %>
				<%' 다운로드 전 %>
				<a href="" onclick="jseventSubmit(evtFrm1); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/<%=folderimgselect%>/btn_coupon_download.png" alt="쿠폰 다운받기" /></a>
			<% Else %>
				<%' 다운로드 후%>
				<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/<%=folderimgselect%>/txt_finish.png" alt="다운이 완료되었습니다.(자정까지 사용) 쉿! 내일의 쿠폰도 기대해 주세요!" /></span>
			<% End If %>

		</div>
		<div class="appDownload posRel">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/<%=folderimgselect%>/txt_install.png" alt="텐바이텐 APP설치하고 쿠폰쓰러가자!" /></p>
			<a href="http://bit.ly/1m1OOyE" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2014/<%=folderimgselect%>/btn_app_download.png" alt="APP 다운받기" /></a>
		</div>
		<% If IsUserLoginOK() Then %>
			<p><a href="" onclick="alert('이미 회원가입이 되어 있습니다.'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/<%=folderimgselect%>/txt_join_10x10.png" alt="어머! 텐바이텐에 처음오셨나요? 가입하고 첫 구매 하러가기" /></a></p>
		<% else %>						
			<p><a href="/member/join.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/<%=folderimgselect%>/txt_join_10x10.png" alt="어머! 텐바이텐에 처음오셨나요? 가입하고 첫 구매 하러가기" /></a></p>					
		<% End If %>
		<dl class="evtNoti">
			<dt>이벤트 유의사항</dt>
			<dd>
				<ul>
					<li>텐바이텐 APP에서만 사용가능 합니다.</li>
					<li>한 ID당 1일 1회 발급, 1회 사용 할 수 있습니다.</li>
					<% If folderimgselect="56092" Then %>
						<li>쿠폰은 금일 11/4(화) 23시59분 종료됩니다.</li>
					<% ElseIf folderimgselect="56094" Then %>
						<li>쿠폰은 금일 11/5(수) 23시59분 종료됩니다.</li>
					<% End If %>
					<li>주문하시는 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
					<li>이벤트는 조기 마감 될 수 있습니다.</li>
				</ul>
			</dd>
		</dl>
	</div>
	<!--// 결정해줘! App쿠폰(M) -->
</div>
<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
	<input type="hidden" name="mode">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->