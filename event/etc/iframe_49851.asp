<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 텐바이텐을 깨워주세요!
' History : 2014.02.27 허진원 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
	dim eCode, mECd

	IF application("Svr_Info") = "Dev" THEN
		eCode = "21102"
		mECd = "21103"
	Else
		eCode = "49850"
		mECd = "49851"
	End If

	dim strSql, isFirstOrder, isSubscript
	isSubscript = false
	isFirstOrder = false

	'// 오렌지 회원일 경우 첫구매 확인
	if IsUserLoginOK then
		if GetLoginUserLevel="5" then
			'응모여부 확인
			strSql = "select count(*) cnt " &_
					"from db_event.dbo.tbl_event_subscript " &_
					"where evt_code=" & eCode &_
					"	and userid='" & GetLoginUserID & "' "
			rsget.Open strSql,dbget,1
			if rsget(0)>0 then isSubscript = true		'응모여부
			rsget.Close

			'첫구매확인
			if Not(isSubscript) then
				strSql = "select count(*) cnt " &_
						"from db_order.dbo.tbl_order_master " &_
						"where ipkumdiv>3 " &_
						"	and sitename='10x10' " &_
						"	and jumundiv<>'9' " &_
						"	and cancelyn='N' " &_
						"	and userid='" & GetLoginUserID & "' " &_
						"	and regdate between '2014-03-03' and '2014-03-10'"
				rsget.Open strSql,dbget,1
				if rsget(0)>0 then isFirstOrder = true		'이벤트 기간동안 첫구매여부
				rsget.Close
			end if
		end if
	end if
%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 텐바이텐을 깨워주세요</title>
<style type="text/css">
.mEvt49851 img {vertical-align:top;}
.mEvt49851 p {max-width:100%;}
.myFirstBuy img {width:100%;}
.myFirstBuy .entryFirstBuy .btnEntry {cursor:pointer;}
</style>
<script type="text/javascript">
function fnSubmit() {
<%
	If IsUserLoginOK Then
		if GetLoginUserLevel="5" then
			if isSubscript then
				Response.Write "alert('이미 응모하셨습니다.');" &vbCrLf
		    	Response.Write "return;"
			else
				if isFirstOrder then
					Response.Write "document.frmSub.submit();"
				else
					Response.Write "alert('첫 구매 후 응모가 가능합니다.');" &vbCrLf
			    	Response.Write "return;"
				end if
			end if
		else
			Response.Write "alert('첫 구매 대상자가 아닙니다.');" &vbCrLf
	    	Response.Write "return;"
		end if
	else
		Response.Write "alert('로그인 후에 응모하실 수 있습니다.');" &vbCrLf
		Response.Write "top.location.href='" & M_SSLUrl & "/login/login.asp?backpath=%2Fevent%2Feventmain%2Easp%3Feventid%3D" & mECd & "';" &vbCrLf
    	Response.Write "return;"
	end if
%>
}
</script>
</head>
<body>
<div class="content" id="contentArea">
	<div class="mEvt49851">
		<div class="myFirstBuy">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49851/txt_start_up_msg.jpg" alt="이제 진짜 시작이야! 텐바이텐 START UP : 3월 둘째주 위시리시트 이벤트 - 아직까지 위시리스트가 없으시다고요? 위시리스트에 담기만 하면 선물로 온다! Coming Soon" /></p>
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/49851/tit_first_buy.jpg" alt="텐바이텐 행운의 새를 잡아라! 첫 구 매" /></h2>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49851/txt_first_buy.jpg" alt="날마다 오는 기회가 아니에요, 쉽게 잡을 수 없는 첫 구매가 나타났어요! 지금 가입하고 처음 구매 하시는 고객님 중 300분을 추첨해 10,000마일리지를 드립니다! 이벤트 기간 : 2014.03.03 - 03.09 당첨자 발표 : 2014.03.14" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49851/txt_wanted.jpg" alt="10,000 MILEAGE 300분께 드립니다!" /></p>
			<div class="entryFirstBuy">
				<span class="btnEntry" onclick="fnSubmit(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49851/btn_entry.jpg" alt="첫 구매 후 응모하기" /></span>
			</div>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49851/tit_guide.jpg" alt="첫 구매 사냥법 ※ 구매기준은 [결제완료]입니다. / 1. 결제금액과 상관없이 처음 구매하신 고객님은 이벤트 응모가 가능합니다. 2. 첫 구매자가 아니신 고객은 이벤트에서 대상에서 제외됩니다. 3. 이벤트 기간 중 고의적으로 결제취소를 하는 경우 이벤트 응모취소 됩니다. 4. 당첨자 발표 및 마일리지 지급은 3월 14일 진행됩니다." /></p>
			<div><a href="/event/eventmain.asp?eventid=49809" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49851/txt_banner_event_wake_up.jpg" alt="ONLY 모바일 전용 이벤트 매일 아침 8시~10시! 텐바이텐을 깨우면, 아침식사를 드려요! - 이벤트 참여하기" /></a></div>
		</div>
	</div>
<form name="frmSub" method="post" action="/event/lib/doEventSubscript.asp" style="margin:0px;" target="prociframe">
<input type="hidden" name="evt_code" value="<%=eCode%>">
</form>
<iframe name="prociframe" id="prociframe" frameborder="0" width="0" height="0" src="about:blank"></iframe>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->