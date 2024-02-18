<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim eCode, cnt, sqlStr, couponkey, regdate, gubun, arrList, i, totalsum

	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "20979"
	Else
		eCode 		= "46012"
	End If

	If IsUserLoginOK Then
		'중복 응모 확인
		sqlStr="Select count(sub_idx) " &_
				" From db_event.dbo.tbl_event_subscript " &_
				" WHERE evt_code='" & eCode & "'" &_
				" and userid='" & GetLoginUserID() & "' and convert(varchar(10),regdate,120) = '" &  Left(now(),10) & "'"
		rsget.Open sqlStr,dbget,1
		cnt=rsget(0)
		rsget.Close
	End If

%>
<!doctype html>
<html lang="ko">
<head>
	<!-- #include virtual="/lib/inc/head.asp" -->
	<title>생활감성채널, 텐바이텐 > 이벤트 > 밥은 먹고 다니냐?</title>
	<style type="text/css">
		.mEvt46012 img {vertical-align:top;}
		.mEvt46012 .applyEvt {position:relative;}
		.mEvt46012 .applyEvt .inpNum {display:block; position:absolute; left:12%; top:7%; width:76%; color:#878787; text-align:center; margin-left:-3px; border:3px solid #fff261; font-size:12px; font-weight:bold;}
		.mEvt46012 .applyEvt .applyBtn {display:block; position:absolute; left:25%; top:26%; width:50%;}
	</style>
	<script type="text/javascript">
		function checkform(frm) {
		<% if datediff("d",date(),"2013-10-21")>=0 then %>
			<% If IsUserLoginOK Then %>
				<% if cnt >= 1 then %>
				alert('하루에 한 번 응모 가능합니다.\n\n내일 다시 응모해주세요.');
				return;
				<% else %>
					if (!frm.uphone.value||frm.uphone.value=="휴대전화번호를 입력하세요")
					{
						alert("휴대전화번호를 입력하세요");
						frm.uphone.focus();
						document.frm.uphone.value = "";
						return false;
					}
					frm.action = "doEventSubscript46012.asp?evt_code=<%=eCode%>";
					return true;
				<% end if %>
			<% Else %>
				alert('로그인 후에 응모하실 수 있습니다.');
				return;
			<% End If %>
		<% else %>
				alert('이벤트가 종료되었습니다.');
				return;
		<% end if %>
		}
		function jsChkVal2()
		{
			if (document.frm.uphone.value == "휴대전화번호를 입력하세요"){
				document.frm.uphone.value = "";
			}
		}
		function isNum()
		 { 
			var frm = document.frm;
			val = frm.uphone.value;
			new_val = "";

			for(i=0;i<val.length;i++) {
				char = val.substring(i,i+1);
				if(char<'0' || char>'9') {
					frm.uphone.value = new_val;
					return;
				} else {
					new_val = new_val + char;
				}
			}
		}
		function jsChkUnblur2()
		{
			if(document.frm.uphone.value ==""){
				document.frm.uphone.value="휴대전화번호를 입력하세요";
			}
		}
	</script>
</head>
<body>
<div class="mEvt46012">
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/46012/46012_head.png" alt="밥은 먹고 다니냐?" style="width:100%;" /></p>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/46012/46012_img01.png" alt="먹방 기프티콘" style="width:100%;" /></p>
	<form name="frm" method="POST" style="margin:0px;" onSubmit="return checkform(this);">
	<input type="hidden" name="eventid" value="<%=eCode%>">
	<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
	<div class="applyEvt">
		<img src="http://webimage.10x10.co.kr/eventIMG/2013/46012/46012_img02.png" alt="당첨시 기프티콘을 받으실 핸드폰 번호를 정확하게 입력해주세요." style="width:100%;" />
		<input type="tel" class="inpNum" name="uphone" value="휴대전화번호를 입력하세요" title="휴대전화번호를 입력하세요" pattern="[0-9]*" onblur="jsChkUnblur2()" onkeyup="jsChkVal2();isNum();" onclick="jsChkVal2();" maxlength="11"/>
		<input type="image" class="applyBtn" src="http://webimage.10x10.co.kr/eventIMG/2013/46012/46012_btn_apply.png" alt="응모하기" />
	</div>
	</form>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/46012/46012_img03.png" alt="이벤트안내" style="width:100%;" /></p>
	<p><a href="/event/12th/"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46012/46012_img04.png" alt="텐바이텐 12주년 이벤트 가을운동회 바로가기" style="width:100%;" /></a></p>
</div>
</body>
</html>