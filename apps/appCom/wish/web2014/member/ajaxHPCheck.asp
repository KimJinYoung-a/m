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
'   휴대전화 번호의 중복 여부를 확인
' -------------------------------------------------
Dim strHP
Dim strSql
Dim	bIsExist
	strHP = requestCheckVar(Request.form("hp"),128)	' 사용자 휴대전화 번호을 입력 받음

	If chkHPForm(strHP)=False Then 
		response.write "3"	'--잘못된 휴대전화 번호 형태
		dbget.close(): response.End
	end if

	'// 오늘 중 인증기록에서 중복확인
	strSql = "select top 1 userid from db_log.dbo.tbl_userConfirm " &_
			" where usercell='" & strHP & "' " &_
			" 	and isConfirm='Y' " &_
			"	and datediff(d,regdate,getdate())>0 "
	rsget.Open strSql, dbget, 1

	'동일한 휴대전화 번호 없음
	If rsget.EOF = True Then
		bIsExist = False
	'동일한 휴대전화 번호 존재
	Else
		bIsExist = True
	End If
	rsget.Close

Dim returnValue
If Not(bIsExist) Then
	returnValue = "1"	'--이용가능
else
	returnValue = "2"	'--이미 등록된 휴대전화 번호
end if

	response.write returnValue

'----------------------------------
' 휴대전화 번호 형태 검사
'----------------------------------
Function chkHPForm(strHP)
	dim isValidE, regEx

	isValidE = True
	set regEx = New RegExp

	regEx.IgnoreCase = False

		regEx.Pattern = "^\d{3}-\d{3,4}-\d{4}$"
	isValidE = regEx.Test(strHP)

	chkHPForm = isValidE
end Function
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->