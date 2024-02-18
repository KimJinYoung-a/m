<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<% Response.CharSet = "UTF-8" %>
<%
'####################################################
' Description :  QR 코드 찍고 응답하라1994 공식MD받자 
' History : 2013.12.24 한용민 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/classes/enjoy/event47921Cls.asp" -->
<%
dim eCode, stats
	eCode   =  getevt_code

dim existscount
	existscount=0

if IsUserLoginOK then
	existscount = getexistscount(eCode, GetLoginUserID(), "")
end if

%>

<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 응답하라1994 OST 구매하고 공식MD 선물받자!</title>
<script type="text/javascript">

$(function(){
	$('.mEvt47921 .winCheck').click(function(){
		//$('.winResult10000coupon').show();
		//return false;
	});
});

function jsCheck(){
	<% If not(getnowdate>="2013-12-26" and getnowdate<"2014-02-01") Then %>
		alert("이벤트 응모 기간이 아닙니다.");
		return;
	<% End IF %>
	
	<% If IsUserLoginOK() Then %>
		<% If Now() > #1/31/2014 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% if existscount="0" then %>
				evtFrm1.mode.value="evtinsert";
				evtFrm1.submit();
			<% else %>
				alert('이미 참여 하셨습니다.');
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
<style type="text/css">
	.mEvt47921 img {vertical-align:top;}
	.mEvt47921 p {max-width:100%;}
	.mEvt47921 .applyEvt {position:relative;}
	.mEvt47921 .winCheck {position:absolute; left:50%; bottom:5%; width:56%; margin-left:-28%;}
	.mEvt47921 .winResult {display:none; position:relative;}
	.mEvt47921 .winResult4000coupon {display:none; position:relative;}
	.mEvt47921 .winResult10000coupon {display:none; position:relative;}
	.mEvt47921 .addrCheck {position:absolute; left:0; bottom:11%; width:100%; text-align:center;}
	.mEvt47921 .addrCheck a {display:inline-block; color:#fff; padding:3% 6%; font-weight:bold; text-align:center; background:#393939;}
</style>
</head>
<body>

<div class="mEvt47921">
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47921/47921_head.png" alt="응답하라1994 OST 구매하고 공식MD 선물받자!" width="100%" /></p>
	<div class="applyEvt"><a href="/event/etc/iframe_47896.asp" onClick="jsCheck('day23',''); return false;" class="click">
		<p class="winCheck">
			<a href="/event/etc/iframe_47921.asp" onClick="jsCheck(); return false;">
			<img src="http://webimage.10x10.co.kr/eventIMG/2013/47921/47921_btn_win.png" alt="이벤트 당첨 확인하기" width="100%" /></a>
		</p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47921/47921_img01.png" alt="이벤트 사은품" width="100%" /></p>
	</div>
	
	<%' 문구세트 당첨 시 노출 %>
	<div class="winResult">
		<p class="addrCheck"><a href="/my10x10/userinfo/membermodify.asp" target="_top">배송 주소 확인하러 가기</a></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47921/47921_txt_win01.png" alt="이벤트 사은품" width="100%" /></p>
	</div>

	<%' 쿠폰 4천원 당첨 시 노출 %>
	<div class="winResult4000coupon">
		<p class="addrCheck"><a href="/my10x10/couponbook.asp" target="_top">쿠폰 확인하러 가기</a></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47921/47921_txt_win02.png" alt="쿠폰 확인하러 가기" width="100%" /></p>
	</div>
	
	<%' 쿠폰 1만원 당첨 시 노출 %>
	<div class="winResult10000coupon">
		<p class="addrCheck"><a href="/my10x10/couponbook.asp" target="_top">쿠폰 확인하러 가기</a></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47921/47921_txt_win03.png" alt="쿠폰 확인하러 가기" width="100%" /></p>
	</div>
	
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47921/47921_img03.png" alt="이벤트 사은품" width="100%" /></p>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47921/47921_notice.png" alt="이벤트 유의사항" width="100%" /></p>
</div>
<form name="evtFrm1" action="/event/etc/doEventSubscript47921.asp" method="post" target="evtFrmProc" style="margin:0px;">
	<input type="hidden" name="mode">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width="0" height="0"></iframe>
</div>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->