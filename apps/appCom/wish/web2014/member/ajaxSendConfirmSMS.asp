<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"

'// 유효 접근 주소 검사 //
dim refer
refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	response.write "-ERR.01"	'--유효하지 못한 접근
	dbget.close(): response.End
end if

' -------------------------------------------------
'  아이디를 받아 유효한 정보인지 확인 후 SMS 발송
' -------------------------------------------------
dim txUserId, txUserHP, chkStat, joinDt, sqlStr
dim sRndKey

	txUserId = requestCheckVar(Request.form("id"),32)	' 사용자 아이디 입력 받음

	If txUserId="" Then 
		response.write "<script type='text/javascript'>alert('잘못된 접근입니다.');</script>'"
		dbget.close(): response.End
	end if

	'// 회원 여부 확인
	sqlStr = "Select usercell, userStat, regdate From db_user.dbo.tbl_user_n Where userid='" & txUserid & "'"
	rsget.Open sqlStr,dbget,1
	if Not(rsget.EOF or rsget.BOF) then
		txUserHP = rsget("usercell")
		chkStat = rsget("userStat")
		joinDt = rsget("regdate")
	end if
	rsget.close

	if txUserHP="" or (chkStat="N" and datediff("h",joinDt,now())>12) then
		'# 회원정보 없음(또는 유효기간 종료 고객)
		response.write "2"
		dbget.close(): response.End
	elseif (chkStat="Y" and datediff("h",joinDt,now())<=12) then
		'# 이미 가입 처리 완료
		response.write "4"
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
		response.write "3"
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
		sqlStr = " exec [db_sms].[dbo].[usp_SendSMS] '" & txUserHP & "','1644-6030','인증번호 [" & sRndKey & "]"& vbCrLf & "입력창에 넣으시면 진행이 완료됩니다. -텐바이텐'"
		dbget.execute(sqlStr)
		response.write "1"
	end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->