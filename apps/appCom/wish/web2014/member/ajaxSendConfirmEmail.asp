<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/tenEncUtil.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"

'// 유효 접근 주소 검사 //
dim refer
refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	response.write "ERR"	'--유효하지 못한 접근
	dbget.close(): response.End
end if

' -------------------------------------------------
'  아이디를 받아 유효한 정보인지 확인 후 메일 발송
' -------------------------------------------------
dim txUserId, txUsermail, chkStat, joinDt, CnfIdx, CnfDate, sqlStr
dim sRUrl, dExp

	txUserId = requestCheckVar(Request.form("id"),32)	' 사용자 아이디 입력 받음

	If txUserId="" Then 
		response.write "-ERR.02"
		dbget.close(): response.End
	end if

	'// 회원 여부 확인
	sqlStr = "Select usermail, userStat, regdate From db_user.dbo.tbl_user_n Where userid='" & txUserid & "'"
	rsget.Open sqlStr,dbget,1
	if Not(rsget.EOF or rsget.BOF) then
		txUsermail = rsget("usermail")
		chkStat = rsget("userStat")
		joinDt = rsget("regdate")
	end if
	rsget.close

	if txUsermail="" or (chkStat="N" and datediff("h",joinDt,now())>12) then
		'# 회원정보 없음(또는 유효기간 종료 고객)
		response.write "3"
		dbget.close(): response.End
	elseif (chkStat="Y" and datediff("h",joinDt,now())<=12) then
		'# 이미 가입 처리 완료
		response.write "4"
		dbget.close(): response.End
	end if

	'# 유효 인증 대기값이 있는지 확인
	sqlStr = "Select top 1 idx, regdate From db_log.dbo.tbl_userConfirm Where userid='" & txUserid & "' and confDiv='E' and isConfirm='N' and datediff(hh,regdate,getdate())<12 order by idx desc "
	rsget.Open sqlStr,dbget,1
	if Not(rsget.EOF or rsget.BOF) then
		CnfIdx = rsget("idx")
		CnfDate = rsget("regdate")
	end if
	rsget.close

	if CnfIdx<>"" then
		'// 재발송

		'# 인증확인 URL
		sRUrl = wwwUrl & "/apps/appcom/wish/web2014/member/confirmjoin_step3.asp?strkey=" & server.URLEncode(tenEnc(txuserid & "||" & CnfIdx))
		'# 인증 종료일
		dExp = cStr(dateadd("h",12,CnfDate))
		'# 인증 메일 발송
		Call SendMailJoinConfirm(txUsermail,txuserid,dExp,sRUrl)
		response.write "1"
	else
		'//신규발송
		'# 인증 로그에 저장
		On Error Resume Next
		dbget.beginTrans

		sqlStr = "insert into db_log.dbo.tbl_userConfirm (userid, confDiv, usermail, pFlag, evtFlag) values ("
		sqlStr = sqlStr + " '" & txuserid & "'"
		sqlStr = sqlStr + " ,'E'"
		sqlStr = sqlStr + " ,'" & txUsermail & "'"
		sqlStr = sqlStr + " ,'T','N'"
		sqlStr = sqlStr + " )"
		dbget.execute(sqlStr)
		
		sqlStr = "Select IDENT_CURRENT('db_log.dbo.tbl_userConfirm') as maxIdx "
		rsget.Open sqlStr,dbget,1
			CnfIdx = rsget("maxIdx")
		rsget.close

		If Err.Number = 0 Then
		        '// 처리 완료
		        dbget.CommitTrans
		Else
		        '//오류가 발생했으므로 롤백
		        dbget.RollBackTrans
				response.write "-ERR.03"
				dbget.close(): response.End
		End If
		on error Goto 0

		'# 인증확인 URL
		sRUrl = wwwUrl & "/apps/appcom/wish/web2014/member/confirmjoin_step3.asp?strkey=" & server.URLEncode(tenEnc(txuserid & "||" & CnfIdx))
		'# 인증 종료일
		dExp = cStr(dateadd("h",12,now()))
		'# 인증 메일 발송
		Call SendMailJoinConfirm(txUsermail,txuserid,dExp,sRUrl)
		response.write "2"
	end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->