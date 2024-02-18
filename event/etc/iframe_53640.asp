<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'###########################################################
' Description : ## 텐바이텐 X 도돌런처 브랜드 테마 런칭 참여이벤트
' History : 2014.07.18 김진영
'###########################################################
Dim eCode, cnt, sqlStr
response.write "HTTP_REFFERER = "&request.ServerVariables("HTTP_REFERER")
If application("Svr_Info") = "Dev" Then
	eCode   =  21244
Else
	eCode   =  53640
End If

If IsUserLoginOK Then
	sqlStr = ""
	sqlStr = sqlStr & " SELECT count(sub_idx) " &VBCRLF
	sqlStr = sqlStr & " FROM db_event.dbo.tbl_event_subscript " &VBCRLF
	sqlStr = sqlStr & " WHERE evt_code='" & eCode & "'" &VBCRLF
	sqlStr = sqlStr & " and userid='" & GetLoginUserID() & "'"
	rsget.Open sqlStr, dbget, 1
		cnt = rsget(0)
	rsget.Close
End If
%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 텐바이텐 X 도돌런처 브랜드 테마 런칭</title>
<style type="text/css">
.mEvt53640 {position:relative;}
.mEvt53640 img {vertical-align:top; width:100%;}
.mEvt53640 p {max-width:100%;}
.dodol .section, .dodol .section h3 {margin:0; padding:0;}
.dodol .section2 {padding-top:8%; background-color:#ffc000; text-align:center;}
.dodol .section2 .btnEnter img {width:86.875%;}
.dodol .section3 {position:relative;}
.dodol .section3 .btnJoin {position:absolute; top:27%; right:6.77083%; width:36.66666%;}
.dodol .section4 {padding-bottom:10%; background-color:#e7e7e7;}
</style>
<script>
<!--
	function checkform() {
<%
	If date >= "2014-07-18" and date <= "2014-08-21" Then
		If IsUserLoginOK Then
			If cnt > 0 Then
%>
				alert('1회만 응모 가능 합니다.');
				return false;
<%			Else %>
				document.efrm.action = "doEventSubscript53640.asp";
				document.efrm.submit();
				return true;
<%			End If
		Else
%>
   			parent.jsevtlogin();
<%		End If
	Else
%>
			alert('이벤트가 종료되었습니다.');
			return;
<%	End If %>
	}	
//-->
</script>
</head>
<body>
<div class="mEvt53640">
	<div class="dodol">
		<div class="section section1">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53640/txt_dodol.gif" alt="폰을 꾸미는 도돌런처, 일상을 꾸미는 텐바이텐!" /></p>
			<p>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/53640/txt_dodol_copy.jpg" alt="" />
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/53640/txt_dodol_event.jpg" alt="텐바이텐 브랜드 테마 런칭 이벤트 도돌런처 텐바이텐 테마를 다운받으신 100분에게 텐바이텐의 특별한 키트를 선물로 드립니다! 이벤트기간은 2014년 8월 7일부터 8월 21일까지입니다." />
			</p>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/53640/img_dodol_visual.jpg" alt="" /></div>
		</div>
		<form name="efrm" method="POST" style="margin:0px;">
		<div class="section section2">
			<div class="btnEnter"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53640/btn_enter_event.gif" onclick="checkform();" alt="응모하기" style="cursor:pointer;" /></div>
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/53640/tit_event_gift.gif" alt="이벤트 상품" /></h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53640/txt_event_gift.gif" alt="라인 캐릭터 인형 시즌 2 20명, 인스탁스 미니 8 카메라 10명, 텐바이텐 키트를 70명께 드립니다." /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53640/txt_gift_random.gif" alt="모든 사은품의 컬러 및 디자인은 랜덤으로 발송됩니다." /></p>
		</div>
		</form>
		<div class="section section3">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53640/txt_member_join.gif" alt="텐바이텐 회원이 아니신가요?" /></p>
			<div class="btnJoin"><a href="/member/join.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53640/btn_join.gif" alt="텐바이텐 회원가입" /></a></div>
		</div>
		<div class="section section4">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/53640/tit_noti.gif" alt="이벤트 유의사항" /></h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53640/txt_noti_new.gif" alt="텐바이텐 로그인 후 참여할 수 있습니다. 당첨자 발표는 2014년 8월 28일입니다. 사은품 발송 및 세무 신고를 위해 개인정보를 요청할 수 있습니다. 당첨자 발표 후 사은품의 교환 및 양도, 현금화는 불가합니다." /></p>
		</div>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->