<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
	Dim sqlStr, loginid, vDown1Chk, vDown2Chk, vDown3Chk, vOrderCnt, vDown1Cnt, vCoupon1Idx, vDown2Cnt, vCoupon2Idx, vDown3Cnt, vCoupon3Idx
	loginid = GetLoginUserID()
	IF application("Svr_Info") = "Dev" THEN
		vCoupon1Idx = "282"
		vCoupon2Idx = "283"
		vCoupon3Idx = "284"
	Else
		vCoupon1Idx = "499"
		vCoupon2Idx = "500"
		vCoupon3Idx = "501"
	End If
	
	If loginid <> "" Then
		sqlStr = "SELECT count(orderserial) FROM [db_order].[dbo].[tbl_order_master] WHERE userid = '" & loginid & "' AND regdate > '2013-12-01 00:00:00'"
		rsget.Open sqlStr,dbget,1
		IF Not rsget.Eof Then
			vOrderCnt = rsget(0)
		End IF
		rsget.close
		
		If CStr(vOrderCnt) = CStr(0) Then	'### 주문데이터 없음.
			sqlStr = "SELECT count(masteridx) FROM [db_user].dbo.tbl_user_coupon WHERE userid = '" & loginid & "' AND masteridx = '" & vCoupon1Idx & "'"
			rsget.Open sqlStr,dbget,1
			IF Not rsget.Eof Then
				vDown1Cnt = rsget(0)
			End IF
			rsget.close
			
			If vDown1Cnt > 0 Then	'### 다운받았음.
				vDown1Chk = "o"
			Else
				vDown1Chk = "downok"'### 받을 수 있음.
			End IF
		Else
			If vOrderCnt > 0 Then	'### 주문데이터 있음.
				vDown1Chk = "n"
			End IF
		End IF
		
		
		sqlStr = "SELECT count(masteridx) FROM [db_user].dbo.tbl_user_coupon WHERE userid = '" & loginid & "' AND masteridx = '" & vCoupon2Idx & "' AND isusing = 'N'"
		rsget.Open sqlStr,dbget,1
		IF Not rsget.Eof Then
			vDown2Cnt = rsget(0)
		End IF
		rsget.close
		
		If vDown2Cnt > 0 Then	'### 다운받았음.
			vDown2Chk = "o"
		Else
			vDown2Chk = "downok"'### 받을 수 있음.
		End IF
		
		
		sqlStr = "SELECT count(masteridx) FROM [db_user].dbo.tbl_user_coupon WHERE userid = '" & loginid & "' AND masteridx = '" & vCoupon3Idx & "' AND isusing = 'N'"
		rsget.Open sqlStr,dbget,1
		IF Not rsget.Eof Then
			vDown3Cnt = rsget(0)
		End IF
		rsget.close
		
		If vDown3Cnt > 0 Then	'### 다운받았음.
			vDown3Chk = "o"
		Else
			vDown3Chk = "downok"'### 받을 수 있음.
		End IF
	End IF
%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > [12월 쿠폰 이벤트] 찰떡쿵 쿠폰</title>
<style>
  .mEvt47872, .mEvt47872 p {width:100%; max-width:100%;}
  .mEvt47872 img {vertical-align:top;}
</style>
<script type="text/javascript">
function couponAlldown(){
<% If loginid <> "" Then %>
	frm1.gb.value = "a";
	frm1.submit();
<% Else %>
	alert("로그인을 해주세요.");
	return;
<% End IF %>
}
function coupon1down(){
<% If loginid <> "" Then %>
	<% If vDown1Chk = "o" Then %>
		alert("이미 다운 받으셨습니다.");
		return;
	<% End IF %>
	<% If vDown1Chk = "n" Then %>
		alert("첫 구매 쿠폰 다운 대상자가 아닙니다.\n이벤트 안내를 참고해 주세요.");
		return;
	<% End IF %>
	<% If vDown1Chk = "downok" Then %>
		frm1.gb.value = "1";
		frm1.submit();
	<% End IF %>
<% Else %>
	alert("로그인을 해주세요.");
	return;
<% End IF %>
}
function coupon2down(){
<% If loginid <> "" Then %>
	<% If vDown2Chk = "o" Then %>
		alert("이미 다운 받으셨습니다.");
		return;
	<% End IF %>
	<% If vDown2Chk = "downok" Then %>
		frm1.gb.value = "2";
		frm1.submit();
	<% End IF %>
<% Else %>
	alert("로그인을 해주세요.");
	return;
<% End IF %>
}
function coupon3down(){
<% If loginid <> "" Then %>
	<% If vDown3Chk = "o" Then %>
		alert("이미 다운 받으셨습니다.");
		return;
	<% End IF %>
	<% If vDown3Chk = "downok" Then %>
		frm1.gb.value = "3";
		frm1.submit();
	<% End IF %>
<% Else %>
	alert("로그인을 해주세요.");
	return;
<% End IF %>
}
</script>
</head>
<body>
<div class="mEvt47872">
  <p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47872/47872_01.png" alt="찰!떡!쿵! COUPON" width="100%" /></p>
  <p><a href="javascript:coupon1down();"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47872/47872_02.png" alt="5,000원 할인쿠폰 다운받기" width="100%" /></a></p>
  <p><a href="javascript:coupon2down();"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47872/47872_03.png" alt="10% 할인쿠폰 다운받기" width="100%" /></a></p>
  <p><a href="javascript:coupon3down();"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47872/47872_04.png" alt="20,000원 할인쿠폰 다운받기" width="100%" /></a></p>
  <p><a href="javascript:couponAlldown();"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47872/47872_05.png" alt="모든 쿠폰 다운받기" width="100%" /></a></p>
  <p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47872/47872_06.png" alt="이벤트 안내" width="100%" /></p>
</div>
<form name="frm1" method="post" action="doEventSubscript47871.asp" style="margin:0px;" target="evtFrmProc">
<input type="hidden" name="gb" value="">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width="0" height="0"></iframe>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->