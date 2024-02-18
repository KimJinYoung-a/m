<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
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

dim txUserId, crtfyNo, sqlStr
dim CnfIdx, CnfCell, isMobile, chkStat, joinDt, UserMail, email_10x10, chkFlag

txUserId = requestCheckVar(Request.form("id"),32)		' 사용자 아이디 입력 받음
crtfyNo = requestCheckVar(Request.form("key"),6)		' 휴대폰에 전송된 인증키
chkFlag = requestCheckVar(Request.form("chkFlag"),1)	' 신규가입 여부(N만 유효)

If txUserId="" Then 
	response.write "-ERR.02"	'--파라메터 없음
	dbget.close(): response.End
end if

'// 인증기록 검사(2분이내)
	sqlStr = "Select top 1 idx, usercell From db_log.dbo.tbl_userConfirm Where userid='" & txUserid & "' and smsCD='" & crtfyNo & "' and confDiv='S' and isConfirm='N' and datediff(s,regdate,getdate())<=120 order by idx desc "
	rsget.Open sqlStr,dbget,1
	if Not(rsget.EOF or rsget.BOF) then
		CnfIdx = rsget("idx")
		CnfCell = rsget("usercell")
	end if
	rsget.close

	if CnfIdx="" then
		response.write "2"	'--유효한 인증번호 없음
		dbget.close(): response.End
	end if

'// 회원상태 검사
'	sqlStr = "Select isNull(isMobileChk,'N') as isMobile, usermail, email_10x10, userStat, regdate From db_user.dbo.tbl_user_n Where userid='" & txUserid & "'"
'	rsget.Open sqlStr,dbget,1
'	if Not(rsget.EOF or rsget.BOF) then
'		isMobile = rsget("isMobile")
'		chkStat = rsget("userStat")
'		joinDt = rsget("regdate")
'		UserMail = rsget("usermail")
'		email_10x10 = rsget("email_10x10")
'	end if
'	rsget.close
'
'	'# 회원정보 없음(또는 유효기간 종료 고객)
'	if isMobile="" or (chkStat="N" and datediff("h",joinDt,now())>12) then
'		response.write "-ERR.03"
'		dbget.close(): response.End
'	end if	

On Error Resume Next
dbget.beginTrans
'// 회원 정보 변경(인증처리)
	'# 인증기록 변경
	sqlStr = "Update db_log.dbo.tbl_userConfirm Set isConfirm='Y', confDate=getdate() Where idx=" & CnfIdx
	dbget.execute(sqlStr)

	If Err.Number = 0 Then
	        '// 처리 완료
	        dbget.CommitTrans
	
	        '# 인증완료
	        response.write "1"
	Else
	        '//오류가 발생했으므로 롤백
	        dbget.RollBackTrans
	        response.write "-ERR.04"
	End If
	
on error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->