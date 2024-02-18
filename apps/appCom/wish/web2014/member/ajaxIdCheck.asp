<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"

' -------------------------------------------------
'   ID의 중복 여부를 확인
'    추후 ID중복인 경우 ID입력 화면을 추가 시킴
' -------------------------------------------------

Dim strId
Dim strSql
Dim	bIsExist
Dim vLeftUserIDCheck

	strId = requestCheckVar(Request("id"),32)	' 사용자 ID를 입력 받음
	
	'####### 가상계좌로 인한 아이디 자리수 체크 ####### //불필요 2015/04/15
	''If Len(strId) > 12 Then
	''	vLeftUserIDCheck = "Left(userid,13) = '" & Left(strId,13) & "' "
	''Else
	''	vLeftUserIDCheck = "userid = '" & strId & "' "
	''End If
    
    vLeftUserIDCheck = "userid = '" & strId & "' "
    
	strSql = "select userid from [db_user].[dbo].tbl_logindata where " & vLeftUserIDCheck & " "

	rsget.Open strSql, dbget, 1


	'동일한 아이디 없음
	If rsget.EOF = True Then
		bIsExist = False
	'동일한 아이디 존재
	Else
		bIsExist = True
	End If
	rsget.Close

	strSql = "select userid from [db_user].[dbo].tbl_deluser where userid = '" + strId + "'"

	rsget.Open strSql, dbget, 1
	bIsExist = bIsExist or (Not rsget.Eof)
	rsget.Close
'----------------------------------
' 10x10에서 한문/특수문자 체크
'----------------------------------

Function ls10x10( pGamepopId 	)

	Dim i, MyArray, Check


	i=1

	DO until i>len( pGamepopId)

		MyArray=mid(pGamepopid,i,cint(1))

		If MyArray >= "a" and MyArray <= "z" Then

			ls10x10=False

		Elseif MyArray >= "A" and MyArray <= "Z" Then

			ls10x10=False

		ElseIf  MyArray >= "0" and MyArray <= "9" Then

			ls10x10=False

		Else

			ls10x10=True
			exit function

		End If

		i = i + 1

	loop


end Function

Dim returnValue
If ls10x10(strId)=True Then 
	returnValue = "3"	'--부적합문자사용
elseIf bIsExist Then
	returnValue = "2"	'--이미 등록된 아이디
else
	returnValue = "1"	'--이용가능
end if			

	response.write returnValue
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->