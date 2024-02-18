<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim eCode, cnt, sqlStr, couponkey, regdate, gubun, arrList, i, totalsum

	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "21039"
	Else
		eCode 		= "47798"
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
	<title>생활감성채널, 텐바이텐 > 이벤트 > 응모자들</title>
	<style type="text/css">
		.mEvt47798 {}
		.mEvt47798 img {vertical-align:top;}
		.mEvt47798 p {max-width:100%;}
		.mEvt47798 .applicants {background:url('http://webimage.10x10.co.kr/eventIMG/2013/47798/47798_bg_body.png') left top no-repeat; background-size:100% auto;}
		.mEvt47798 .selectGift { overflow:hidden; width:100%; padding-top:5%;}
		.mEvt47798 .selectGift li {float:left; width:50%; text-align:center;}
		.mEvt47798 .selectGift li label {display:block; padding-bottom:8px;}
		.mEvt47798 .applyBtn {padding:5% 18% 8%; width:64%;}
		.mEvt47798 .inputNumber {position:relative; padding-top:5%;}
		.mEvt47798 .inputNumber .tel {position:absolute; left:13%; top:23%; width:74%; height:26px; font-size:16px; line-height:26px;text-align:center; color:#444; display:block; font-weight:bold; border:3px solid #ffc807; background:#fff;}
	</style>
	<script type="text/javascript">
		function checkform(frm) {
		<% if datediff("d",date(),"2013-12-29")>=0 then %>
			<% If IsUserLoginOK Then %>
				<% if cnt >= 1 then %>
				alert('하루에 한 번 응모 가능합니다.\n\n내일 다시 응모해주세요.');
				return;
				<% else %>
					if (!(frm.spoint[0].checked||frm.spoint[1].checked))
					{
						alert("상품을 선택 하세요");
						return false;
					}
					
					if (frm.spoint[1].checked){
						if (!frm.uphone.value||frm.uphone.value=="휴대전화번호를 입력하세요")
						{
							alert("휴대전화번호를 입력하세요");
							frm.uphone.focus();
							document.frm.uphone.value = "";
							return false;
						}
					}

					frm.action = "doEventSubscript47798.asp?evt_code=<%=eCode%>";
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
		function telonoff(v){
			if (v == 1)	{
				$(".inputNumber").css("display","none");
			}else{
				$(".inputNumber").css("display","block");
			}
		}
	</script>
</head>
<body>
<!-- content area -->
<div class="content" id="contentArea">
	<form name="frm" method="POST" style="margin:0px;" onSubmit="return checkform(this);">
	<input type="hidden" name="evt_code" value="<%=eCode%>">
	<input type="hidden" name="returl" value="/event/eventmain.asp?eventid=47798">
	<div class="mEvt47798">
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/47798/47798_head.png" alt="추위를 이기려는 자, 그 배고픔을 견뎌라! 응모자들" style="width:100%;" /></div>
		<div class="applicants">
			<!-- 상품 선택 -->
			<ul class="selectGift">
				<li>
					<label for="gift01"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47798/47798_img_gift01.png" alt="추위극복 패키지" style="width:100%;" /></label>
					<input type="radio" id="gift01" name="spoint" value="1" onclick="telonoff(1);"/>
				</li>
				<li>
					<label for="gift02"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47798/47798_img_gift02.png" alt="추위극복 패키지" style="width:100%;" /></label>
					<input type="radio" id="gift02" name="spoint" value="2" onclick="telonoff(2);"/>
				</li>
			</ul>
			<!--// 상품 선택 -->

			<!-- 연락처 입력 (베스킨라빈스 선택 시 노출) -->
			<div class="inputNumber" style="display:none;">
				<input type="tel" class="tel" value="휴대전화번호를 입력하세요" name="uphone" pattern="[0-9]*" onblur="jsChkUnblur2()" onkeyup="jsChkVal2();isNum();" onclick="jsChkVal2();" maxlength="11"/>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47798/47798_img_tel.png" alt="당첨 시, 기프티콘을 받으실 연락처를 입력해주세요 (회원가입 시 작성한 연락처와 동일하여도 꼭 작성해 주세요)" style="width:100%;" /></p>
			</div>
			<!--// 연락처 입력 -->
			<p class="applyBtn"><input type="image" alt="응모하기" src="http://webimage.10x10.co.kr/eventIMG/2013/47798/47798_btn_apply.png" style="width:100%;" /></p>
		</div>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/47798/47798_notice.png" alt="이벤트 안내" style="width:100%;" /></div>
	</div>
	</form>
</div>
<!-- //content area -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
