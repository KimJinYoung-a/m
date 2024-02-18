<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  5월, MAY I HELP YOU
' History : 2014.05.22 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/event/etc/event52028Cls.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->

<%
dim cEvent, ename, eCode, userid
dim couponcount4000, couponcountfree, couponcount10000
	eCode   =  getevt_code

set cEvent = new ClsEvtCont
	cEvent.FECode = eCode
	cEvent.fnGetEvent
	
	eCode		= cEvent.FECode	
	ename		= cEvent.FEName
set cEvent = nothing

couponcount4000 = 0
couponcountfree = 0
couponcountfree = 0
userid = getloginuserid()

if IsUserLoginOK then
	couponcount4000 = getbonuscouponexistscount(userid, getcouponid4000, "", "", "")
	couponcountfree = getbonuscouponexistscount(userid, getcouponidfree, "", "", "")
	couponcount10000 = getbonuscouponexistscount(userid, getcouponid10000, "", "", "")
end if

%>

<head>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<style type="text/css">
.mEvt52028 {}
.mEvt52028 img {vertical-align:top; width:100%;}
.mEvt52028 p {max-width:100%;}
.mEvt52028 .joinCoupon {padding-bottom:11%; background:#fbeddd;}
.mEvt52028 .shareSns {position:relative;}
.mEvt52028 .shareSns ul {position:absolute; left:29%; top:47%; overflow:hidden; width:60%;}
.mEvt52028 .shareSns li {float:left; width:33%;}
.mEvt52028 .shareSns li a {display:block; margin:0 5px;}
</style>
<script src="/lib/js/kakao.Link.js"></script>
<script type="text/javascript">
	
function jscoupionCheck4000(){
	<% If IsUserLoginOK() Then %>
		<% If Now() > #06/01/2014 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% if couponcount4000=0 then %>
				evtFrm1.mode.value="coupon4000";
				evtFrm1.submit();
			<% else %>
				alert("쿠폰이 이미 발급 되었습니다! \n발급된 쿠폰은 마이텐바이텐 에서\n확인 가능합니다!");
				return;
			<% end if %>
		<% End If %>
	<% Else %>
		//alert('로그인을 하셔야 참여가 가능 합니다');
		calllogin();
		//return;
	<% End IF %>
}

function jscoupionCheckfree(){
	<% If IsUserLoginOK() Then %>
		<% If Now() > #06/01/2014 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% if couponcountfree=0 then %>
				evtFrm1.mode.value="couponfree";
				evtFrm1.submit();
			<% else %>
				alert("쿠폰이 이미 발급 되었습니다! \n발급된 쿠폰은 마이텐바이텐 에서\n확인 가능합니다!");
				return;
			<% end if %>
		<% End If %>
	<% Else %>
		//alert('로그인을 하셔야 참여가 가능 합니다');
		calllogin();
		//return;
	<% End IF %>
}

function jscoupionCheck10000(){
	<% If IsUserLoginOK() Then %>
		<% If Now() > #06/01/2014 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% if couponcount10000=0 then %>
				evtFrm1.mode.value="coupon10000";
				evtFrm1.submit();
			<% else %>
				alert("쿠폰이 이미 발급 되었습니다! \n발급된 쿠폰은 마이텐바이텐 에서\n확인 가능합니다!");
				return;
			<% end if %>
		<% End If %>
	<% Else %>
		//alert('로그인을 하셔야 참여가 가능 합니다');
		calllogin();
		//return;
	<% End IF %>
}

function kakaosendcall(){
	kakaosend52028();
}

function kakaosend52028(){
	var url =  '<%= getkakaolink %>';
	kakao.link("talk").send({
		msg : "여러분의 5월,\nWISH APP이 도와드립니다.\n텐바이텐 모바일에서만 누릴 수 있는 착한 APP 쿠폰을 만나보세요!",
		url : url,
		appid : "m.10x10.co.kr",
		appver : "2.0",
		appname : "MAY I HELP YOU ",
		type : "link"
	});
}
</script>

</head>
<body>
<!-- May I HELP YOU -->
<div class="mEvt52028">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/52028/tit_may_coupon.png" alt="여러분의 5월, WISH APP이 도와드립니다. May I HELP YOU" /></h2>
	<ul class="mayCoupon">
		<li><a href="" onclick="jscoupionCheck4000(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52028/img_app_coupon01.png" alt="4,000원 쿠폰-3만원 이상 구매 시 사용가능" /></a></li>
		<li><a href=""  onclick="jscoupionCheckfree(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52028/img_app_coupon02.png" alt="무료배송 쿠폰-3만원 이상 구매 시 사용가능" /></a></li>
		<li><a href=""  onclick="jscoupionCheck10000(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52028/img_app_coupon03.png" alt="10,000원 쿠폰-10만원 이상 구매 시 사용가능" /></a></li>
	</ul>
	<div class="joinCoupon">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52028/txt_join.png" alt="지금 텐바이텐 회원 가입하면 4천원 할인쿠폰 추가 증정(3만원 이상 구매 시 사용가능)" /></p>
		<% If IsUserLoginOK() Then %>
			<a href=""  onclick="alert('이미 가입이 되어 있습니다.'); return;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52028/btn_join.png" alt="회원가입 하러가기" /></a>
		<% else %>
			<a href="http://<%=realtest_url%>m.10x10.co.kr/apps/appcom/wish/webview/member/join.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52028/btn_join.png" alt="회원가입 하러가기" /></a>
		<% end if %>
	</div>
	<div class="shareSns">
		<img src="http://webimage.10x10.co.kr/eventIMG/2014/52028/img_share.png" alt="친구야, 너도 텐바이텐의 도움이 필요하니? - sns로 이벤트 공유하기" />
		<%
			Public Function URLEncodeUTF8(byVal szSource)
				Dim szChar, WideChar, nLength, i, result
				nLength = Len(szSource)
			
				For i = 1 To nLength
					szChar = Mid(szSource, i, 1)
			
					If Asc(szChar) < 0 Then
						WideChar = CLng(AscB(MidB(szChar, 2, 1))) * 256 + AscB(MidB(szChar, 1, 1))
			
						If (WideChar And &HFF80) = 0 Then
							result = result & "%" & Hex(WideChar)
						ElseIf (WideChar And &HF000) = 0 Then
							result = result & _
								"%" & Hex(CInt((WideChar And &HFFC0) / 64) Or &HC0) & _
								"%" & Hex(WideChar And &H3F Or &H80)
						Else
							result = result & _
								"%" & Hex(CInt((WideChar And &HF000) / 4096) Or &HE0) & _
								"%" & Hex(CInt((WideChar And &HFFC0) / 64) And &H3F Or &H80) & _
								"%" & Hex(WideChar And &H3F Or &H80)
						End If
					Else
						if (Asc(szChar)>=48 and Asc(szChar)<=57) or (Asc(szChar)>=65 and Asc(szChar)<=90) or (Asc(szChar)>=97 and Asc(szChar)<=122) then
							result = result + szChar
						else
							if Asc(szChar)=32 then
								result = result & "+"
							else
								result = result & "%" & Hex(AscB(MidB(szChar, 1, 1)))
							end if
						end if
					End If
				Next
				URLEncodeUTF8 = result
			End Function

			'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
			dim snpTitle, strTitle2, snpLink, snpLink2, snpPre, snpPre2, snpTag, snpTag2, snpImg
			snpTitle = URLEncodeUTF8(ename)
			strTitle2 = Server.URLEncode(ename)
			snpLink = URLEncodeUTF8("http://m.10x10.co.kr/event/eventmain.asp?eventid=" & ecode)
			snpLink2 = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=" & ecode)
			snpPre = URLEncodeUTF8("텐바이텐 이벤트")
			snpPre2 = Server.URLEncode("텐바이텐 이벤트")
			snpTag = URLEncodeUTF8("텐바이텐 " & Replace(ename," ",""))
			snpTag2 = URLEncodeUTF8("#10x10")
		%>
		<ul>
			<li><a href="" onclick="popSNSPost('tw','<%=strTitle2%>','<%=snpLink2%>','<%=snpPre2%>','<%=snpTag2%>');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52027/btn_sns_twitter.png" alt="twitter" /></a></li>
			<li><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52027/btn_sns_facebook.png" alt="face book" /></a></li>
			<li><a href="" onclick="kakaosendcall(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52027/btn_sns_kakaotalk.png" alt="kakao talk" /></a></li>
		</ul>
	</div>
</div>
<!-- //May I HELP YOU -->

<form name="evtFrm1" action="/apps/appcom/wish/webview/event/etc/doEventSubscript52028.asp" method="post" target="evtFrmProc" style="margin:0px;">
	<input type="hidden" name="mode">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->