<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
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
'   이메일의 중복 여부를 확인
' -------------------------------------------------
Dim strEmail
Dim strSql
Dim	bIsExist
	strEmail = requestCheckVar(Request.form("email"),128)	' 사용자 이메일을 입력 받음

	If chkEmailForm(strEmail)=False Then 
		response.write "3"	'--잘못된 이메일 형태
		dbget.close(): response.End
	end if

	'// 회원정보에서 인증기록이 있는 정보만 확인(userStat N:인증전, Y:인증완료, Null:기존고객)
	strSql = "select top 1 userid from [db_user].[dbo].tbl_user_n " &_
			" where usermail='" & strEmail & "' " &_
			" and (userStat='Y' or (userStat='N' and datediff(hh,regdate,getdate())<12)) "
	rsget.Open strSql, dbget, 1

	'동일한 이메일 없음
	If rsget.EOF = True Then
		bIsExist = False
	'동일한 이메일 존재
	Else
		bIsExist = True
	End If
	rsget.Close

Dim returnValue
If Not(bIsExist) Then
	returnValue = "1"	'--이용가능
else
	returnValue = "2"	'--이미 등록된 이메일
end if

	response.write returnValue

'----------------------------------
' 이메일 형태 검사
'----------------------------------
Function chkEmailForm(strEmail)
	dim isValidE, regEx

	isValidE = True
	set regEx = New RegExp

	regEx.IgnoreCase = False

	'regEx.Pattern = "^[a-zA-Z0-9][\w\.-_]*[a-zA-Z0-9][\w\.-_]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$"
	regEx.Pattern = "^([a-z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-z0-9_\-]+\.)+))([a-z]{2,4}|[0-9]{1,3})(\]?)$"
	isValidE = regEx.Test(strEmail)

	chkEmailForm = isValidE
end Function
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->