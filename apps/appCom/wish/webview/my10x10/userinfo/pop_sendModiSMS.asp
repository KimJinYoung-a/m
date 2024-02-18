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
'	History	:  2014.01.08 한용민 생성
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
dim refer
	refer = request.ServerVariables("HTTP_REFERER")

if InStr(refer,"10x10.co.kr")<1 then
	response.write "<script type='text/javascript'>alert('유효하지 못한 접근입니다.');</script>'"	'--유효하지 못한 접근
	dbget.close(): response.End
end if

' -------------------------------------------------
'  아이디를 받아 유효한 정보인지 확인 후 SMS 발송
' -------------------------------------------------
dim txUserId, txUserHP, chkStat, joinDt, sqlStr, sRndKey
	txUserId = requestCheckVar(Request("id"),32)		' 사용자 아이디 입력 받음
	txUserHP = requestCheckVar(Request("phone"),18)	' 사용자 휴대폰 입력 받음

	If txUserId="" or txUserHP="" Then 
		response.write "<script type='text/javascript'>alert('잘못된 접근입니다.');</script>'"
		dbget.close(): response.End
	end if

	'// 회원 여부 확인
	sqlStr = "Select userStat, regdate From db_user.dbo.tbl_user_n Where userid='" & txUserid & "'"
	
	'response.write sqlStr & "<Br>"
	rsget.Open sqlStr,dbget,1
	if Not(rsget.EOF or rsget.BOF) then
		chkStat = rsget("userStat")
		joinDt = rsget("regdate")
	end if
	rsget.close

	if joinDt="" or (chkStat="N" and datediff("h",joinDt,now())>12) then
		'# 회원정보 없음(또는 유효기간 종료 고객)
		response.write "<script type='text/javascript'>alert('회원 정보가 존재하지 않습니다.');</script>'"
		dbget.close(): response.End
	end if	

	'# 연속발송 제한 확인 (6시간동안 5회까지만 허용;이메일,휴대폰 총발송수)
	Dim chkSendCnt
	sqlStr = "Select count(*) From db_log.dbo.tbl_userConfirm Where userid='" & txUserid & "' and datediff(hh,regdate,getdate())<6 "
	
	'response.write sqlStr & "<Br>"
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
	
	'response.write sqlStr & "<Br>"
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
		
		'response.write sqlStr & "<Br>"
		dbget.execute(sqlStr)
		
		'# 인증 SMS 발송
		sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg ) values " &_
				" ('" & txUserHP & "'" &_
				" ,'1644-6030','1',getdate()" &_
				" ,'인증번호 [" & sRndKey & "]"& vbCrLf & "입력창에 넣으시면 진행이 완료됩니다. -텐바이텐')"
		
		'response.write sqlStr & "<Br>"
		dbget.execute(sqlStr)
	end if
%>

<script type="text/javascript">
 
 //인증 처리
 function refnConfirmSMS() {
	var tmpcrtfyNo = $("#crtfyNo")

 	if( $("#crtfyNo").val().length <6) {
 		alert("휴대폰으로 받으신 인증번호를 정확히 입력해주세요.");
 		$("#crtfyNo").focus();
 		return;
 	}

	var rstStr = $.ajax({
		type: "POST",
		url: "/member/ajaxCheckConfirmSMS.asp",
		data: "id=<%=txUserId%>&key="+$("#crtfyNo").val(),
		dataType: "text",
		async: false
	}).responseText;

	if (rstStr == "1"){
		alert("인증이 완료되었습니다.");
	}else if (rstStr == "2"){
		alert("인증번호가 정확하지 않습니다.");
		return;
	}else{
		alert("처리중 오류가 발생했습니다.");
		return;
	}

	$("#modalCont").fadeOut();
	$('body').css({'overflow':'auto'});
	clearInterval(loop);
	loop = null;
 }
 
</script>

<!-- modal#resendAuthcode  -->
<div class="modal popup" id="resendAuthcode">
    <div class="box" style="top:50%;margin-top:-160px;">
        <header class="modal-header">
            <h1 class="modal-title">인증번호 재발송</h1>
            <a href="#resendAuthcode" class="btn-close">&times;</a>
        </header>
        <div class="modal-body">
            <div class="inner">
                <div class="t-c inner">
                    <div class="number bordered-title inline"><%=txUserHP%></div>
                    <p>위 번호로 SMS를 이용해 인증번호를  재발송 하였습니다.<br>꼭 확인해 주세요. </p>
                </div>
                <div class="input-block no-label">
                    <label class="input-label" for="authCode2">인증번호</label>
                    <div class="input-controls">
                        <input type="text" id="crtfyNo" name="crtfyNo" pattern="[0-9]*" maxlength="6" class="form full-size">
                        <button onclick="refnConfirmSMS();" class="btn type-b side-btn">인증번호확인</button>
                    </div>
                </div>
                <em class="em red">* 인증번호 6자리를 입력해주세요.</em>
            </div>
        </div>
        <footer class="modal-footer">
            <small>
                * 인증번호가 계속 도착하지 않는다면 스팸문자함 또는 차단 설정을 확인하여 주세요. 
            </small>
        </footer>
    </div>
</div><!-- modal#resendAuthcode  -->

<!-- #include virtual="/lib/db/dbclose.asp" -->