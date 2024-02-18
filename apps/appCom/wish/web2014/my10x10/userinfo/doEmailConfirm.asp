<%@ Language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/tenEncUtil.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"

Dim strKey, rstKey, txUserid, cnfIdx, sqlStr
Dim cfmChk, cfmRdt, cfmEmail
'전송된 인증키
strKey = requestCheckVar(Request("strKey"),128)

On Error Resume Next
	rstKey = tenDec(strKey)
	rstKey = split(rstKey,"||")

	txUserid = rstKey(0)
	cnfIdx = rstKey(1)

	If Err.Number Then
		Call Alert_Move("잘못된 키값입니다.","/")
		dbget.close(): response.End
	end if
on error Goto 0

'// 인증기록 접수
	sqlStr = "Select isConfirm, regdate, usermail From db_log.dbo.tbl_userConfirm Where idx='" & getNumeric(cnfIdx) & "' and userid='" & txUserid & "'"
	rsget.Open sqlStr,dbget,1
	if Not(rsget.EOF or rsget.BOF) then
		cfmChk = rsget("isConfirm")
		cfmRdt = rsget("regdate")
		cfmEmail = rsget("usermail")
	end if
	rsget.close

	'## 유효값 확인
	if cfmChk="Y" then
		'인증을 이미 받았음
		Call Alert_Move("승인이 완료되었습니다.","/")
		dbget.close(): response.End
	end if

	'## 승인유효기간 종료
	if datediff("h",cfmRdt,now())>12 then
		Call Alert_Move("승인 유효시간이 경과되었습니다.\n다시 승인 요청해주세요.","/")
		dbget.close(): response.End
	end if

On Error Resume Next
dbget.beginTrans
'// 회원 정보 변경(인증처리)
	'# 인증기록 변경
	sqlStr = "Update db_log.dbo.tbl_userConfirm Set isConfirm='Y', confDate=getdate() Where idx=" & CnfIdx
	dbget.execute(sqlStr)

	'# 회원정보 변경
	sqlStr = "Update db_user.dbo.tbl_user_n "
	sqlStr = sqlStr & " Set usermail='" & cfmEmail & "', userStat='Y', isEmailChk='Y' "			'회원정보변경(이메일)
	''sqlStr = sqlStr & " 	,dupeInfo=null, connInfo=null, realnamecheck='N', iPinCheck='N' "	'실명회원정보 삭제 > 제휴업체와 중복검사를 위하여 유지(2015.02.06; 허진원)
	sqlStr = sqlStr & " Where userid='" & txUserid & "'"
	dbget.execute(sqlStr)

	If Err.Number = 0 Then
		'// 처리 완료
		dbget.CommitTrans
	
		'# 인증완료
		'기존회원 승인시
		Call Alert_Move("승인이 완료되었습니다.","/")

	Else
		'//오류가 발생했으므로 롤백
		dbget.RollBackTrans
		Call Alert_Move("처리중 오류가 발생했습니다.\n다시 시도해주세요.","/")
	End If
on error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->