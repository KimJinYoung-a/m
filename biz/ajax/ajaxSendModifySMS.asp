<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
'	Description : sms 인증
'	History	:  2021.07.02 정태훈 생성
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/tenEncUtil.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
'// 유효 접근 주소 검사 //
dim refer
refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	response.write "<script type='text/javascript'>alert('유효하지 못한 접근입니다.');</script>'"	'--유효하지 못한 접근
	dbget.close(): response.End
end if

' -------------------------------------------------
'  아이디를 받아 유효한 정보인지 확인 후 SMS 발송
' -------------------------------------------------
dim txUserId, txUserHP, chkStat, joinDt, sqlStr
dim sRndKey

	txUserId = requestCheckVar(Request("id"),32)		' 사용자 아이디 입력 받음
	txUserHP = requestCheckVar(Request("phone"),18)	' 사용자 휴대폰 입력 받음

	If txUserId="" or txUserHP="" Then 
		response.write "<script type='text/javascript'>alert('잘못된 접근입니다.');</script>'"
		dbget.close(): response.End
	end if

	sqlStr = " SELECT regdate FROM db_user.dbo.tbl_user_c "
	sqlStr = sqlStr + " WHERE userid='" + txUserId + "' AND isusing = 'Y'"
	rsget.Open sqlStr,dbget,1
	
	If rsget.EOF Then
		response.write "<script type='text/javascript'>alert('회원 정보가 존재하지 않습니다.');</script>'"
		dbget.close(): response.End
	End If
	rsget.close

	'# 연속발송 제한 확인 (6시간동안 5회까지만 허용;이메일,휴대폰 총발송수)
	Dim chkSendCnt
	sqlStr = "Select count(*) From db_log.dbo.tbl_userConfirm Where userid='" & txUserid & "' and datediff(hh,regdate,getdate())<6 "
	rsget.Open sqlStr,dbget,1
	if Not(rsget.EOF or rsget.BOF) then
		chkSendCnt = rsget(0)
	end if
	rsget.close

	if chkSendCnt>5 then
		response.write "<script type='text/javascript'>alert('단기간에 많은 인증요청으로 더이상 인증을 할 수 없습니다.\n잠시 후 다시 시도해주세요.');</script>'"
		dbget.close(): response.End
	end if

	'# 유효 인증 대기값이 있는지 확인(100초 이내 / 확인은 120초까지 유효)
	sqlStr = "Select top 1 smsCD From db_log.dbo.tbl_userConfirm Where userid='" & txUserid & "' and confDiv='S' and isConfirm='N' and datediff(s,regdate,getdate())<=120 order by idx desc "
	rsget.Open sqlStr,dbget,1
	if Not(rsget.EOF or rsget.BOF) then
		sRndKey = rsget("smsCD")
	end if
	rsget.close

	if sRndKey<>"" then
		'// 2분 이내에는 재발송 없음(SPAM 등에 걸리지 않는 이상 거의 대부분 늦게라도 전송됨)
	else
		'//신규발송

		'# sRndKey값 생성
		randomize(time())
		sRndKey=Num2Str(left(round(rnd*(1000000)),6),6,"0","R")

		'# 인증 로그에 저장
		sqlStr = "insert into db_log.dbo.tbl_userConfirm (userid, confDiv, usercell, smsCD, pFlag, evtFlag) values ("
		sqlStr = sqlStr + " '" & txuserid & "'"
		sqlStr = sqlStr + " ,'S'"
		sqlStr = sqlStr + " ,'" & txUserHP & "'"
		sqlStr = sqlStr + " ,'" & sRndKey & "'"
		sqlStr = sqlStr + " ,'T','N'"
		sqlStr = sqlStr + " )"
		dbget.execute(sqlStr)
		
		'# 인증 SMS 발송
		'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg ) values " &_
		'		" ('" & txUserHP & "'" &_
		'		" ,'1644-6030','1',getdate()" &_
		'		" ,'인증번호 [" & sRndKey & "]"& vbCrLf & "입력창에 넣으시면 진행이 완료됩니다. -텐바이텐')"
		
		''2015/08/16 수정
		'sqlStr = " exec [db_sms].[dbo].[usp_SendSMS] '" & txUserHP & "','1644-6030','인증번호 [" & sRndKey & "]"& vbCrLf & "입력창에 넣으시면 진행이 완료됩니다. -텐바이텐'"
		'dbget.execute(sqlStr)

		''2018/01/22 수정; 허진원 카카오 알림톡으로 전송
		Call SendKakaoMsg_LINK(txUserHP,"1644-6030","S0001","[텐바이텐] 고객님의 인증번호는 [" & sRndKey & "]입니다.","SMS","","인증번호 [" & sRndKey & "]"& vbCrLf & "입력창에 넣으시면 진행이 완료됩니다. -텐바이텐","")
	end if
%>

<script type="text/javascript">

//인증 처리
function fnConfirmSMS() {
	var frm = document.cnfSMSForm;
	if(frm.crtfyNo.value.length<6) {
		alert("휴대폰으로 받으신 인증번호를 정확히 입력해주세요.");
		frm.crtfyNo.focus();
		return;
	}
	
	var rstStr = $.ajax({
		type: "POST",
		url: "/biz/ajax/ajaxCheckConfirmSMS.asp",
		data: "id=<%=txUserId%>&key="+frm.crtfyNo.value,
		dataType: "text",
		async: false
	}).responseText;
	
	if (rstStr == "1"){
		alert("인증이 완료되었습니다.");
		//페이지 새로고침
		location.replace('/biz/membermodify.asp');
		return false;
	}else if (rstStr == "2"){
		alert("인증번호가 정확하지 않습니다.");
		return false;
	}else{
		alert("처리중 오류가 발생했습니다.");
		return false;
	}
}

</script>

<div class="layerPopup">
	<div class="popWin">
		<div class="header">
			<h1>휴대폰 인증번호 발송</h1>
			<p class="btnPopClose"><button type="button" class="pButton" onclick="fnCloseModal();">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content certPhone" id="layerScroll">
			<div id="scrollarea">
				<form name="cnfSMSForm" action="" onsubmit="return false;" style="margin:0px;">
				<div class="inner5 tMar15">
					<div class="box1">
						<span class="userNum"><%=txUserHP%></span>
						<p class="t01">위 번호로 인증번호를 발송하였습니다.<br /><span class="cRd1">꼭 확인해주세요!</span></p>
						<p class="t02">(인증번호 6자리를 입력해주세요.)</p>
						<div class="enterNum">
							<input type="number" name="crtfyNo" maxlength="6" placeholder="인증번호 입력" />
							<span class="button btB2 btRed cWh1 w25p"><a href="" onclick="fnConfirmSMS(); return false;">확인</a></span>
						</div>
					</div>
					<p class="fs11">인증번호가 계속 도착하지 않는다면 스팸문자함 또는<br />차단 설정을 확인하여 주세요.</p>
				</div>
			</form>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>

<!-- #include virtual="/lib/db/dbclose.asp" -->