<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	dim eCode
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  21028
	Else
		eCode   =  47364
	End If

'응모 확인
Dim sqlStr
Dim chkSub: chkSub=false
dim loginid: loginid = GetLoginUserID()
if IsUserLoginOK then
	sqlStr = "Select count(sub_idx) " &_
			" From db_event.dbo.tbl_event_subscript " &_
			" WHERE evt_code=" & eCode &_
			" and userid='" & loginid & "'"
	rsget.Open sqlStr,dbget,1
	if rsget(0)>0 then
		chkSub=true
	end if
	rsget.Close
end if
%>
<!doctype html>
<html lang="ko">
<head>
	<title>생활감성채널, 텐바이텐 > 이벤트 > 크리스마스 소원</title>
	<style type="text/css">
	.mEvt47365 {}
	.mEvt47365 img {vertical-align:top;}
	.mEvt47365 p {max-width:100%;}
	.mEvt47365 .mystic89Concert {position:relative;}
	.mEvt47365 .mystic89Concert .applyBtn {position:absolute; left:5%; top:18%; width:90%;}
	</style>
<script type="text/javascript">
function putSubscript() {
	var frm = document.subForm;
	frm.submit();
}
</script>
</head>
<body>
<!-- content area -->
<div class="content" id="contentArea">
	<div class="mEvt47365">
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/47365/47365_head.png" alt="크리스마스 소원" style="width:100%;" /></div>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/47365/47365_img01.png" alt="텐바이텐과 미스틱89 가수들이 함께하는 크리스마스 콘서트에 여러분을 초대합니다. 네이버 뮤직 생방송으로 진행될 이색 콘서트! 음악과 설렘이 있는 특별한 추억을 선물합니다." style="width:100%;" /></div>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/47365/47365_img02.png" alt="미스틱89 이미지" style="width:100%;" /></div>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/47365/47365_img03.png" alt="NAVER MUSIC 음악감상회 LIVE 겨울특집" style="width:100%;" /></div>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/47365/47365_img04.png" alt="미스틱89 이미지" style="width:100%;" /></div>
		<!-- 응모하기 -->
		<div class="mystic89Concert">
			<p class="applyBtn">
				<% if chkSub then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2013/47365/47365_txt_apply_finish.png" alt="크리스마스 소원" style="width:100%;" />
				<% else %>
				<input type="image" onclick="putSubscript()" src="http://webimage.10x10.co.kr/eventIMG/2013/47365/47365_btn_apply.png" alt="콘서트 응모하기" style="width:100%;" />
				<% end if%>
			</p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47365/47365_bg01.png" alt="" style="width:100%;" /></p>
		</div>
		<!--// 응모하기 -->
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/47365/47365_img05.png" alt="12월 12일! MERRY MERRY CHRISTMAS 이벤트02 오픈예정!" style="width:100%;" /></div>
	</div>
	<form name="subForm" method="POST" action="/event/lib/doEventSubscript.asp" target="ifrSmt" style="margin:0;">
	<input type="hidden" name="evt_code" value="<%=eCode%>">
	<input type="hidden" name="returl" value="/event/eventmain.asp?eventid=47365">
	</form>
	<iframe align="center" name="ifrSmt" id="ifrSmt" src="" frameborder="0" height="0" width="0" ></iframe>
</div>
<!-- //content area -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
