<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description :  찜브랜드
' History : 2014.10.01 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->

<%
'// 로그인 체크 //
if Not(IsUserLoginOK) then
	Call Alert_return("로그인하셔야 사용할 수 있습니다.")
	dbget.close()	:	response.End
end if

dim backurl,userid
userid = GetLoginUserID
backurl = request.ServerVariables("HTTP_REFERER")

If backurl = "" Then
	backurl = "http://m.10x10.co.kr"
End If

if InStr(LCase(backurl),"10x10.co.kr") < 0 then response.redirect backurl

dim makerid, sqlStr, sMode, bestpg
	makerid = request.Form("makerid")
	bestpg = request.Form("bestpg")

if makerid="" then response.End

sqlStr = "SELECT COUNT(makerid) FROM [db_my10x10].[dbo].tbl_mybrand WHERE userid = '" & userid & "' AND makerid = '" & makerid & "'"

'response.write sqlStr & "<br>"
rsget.Open sqlStr, dbget, 1
If rsget(0) > 0 Then
	sMode = "D"
Else
	sMode = "I"
End If
rsget.close

if sMode = "I" then
	sqlStr = "exec [db_my10x10].[dbo].sp_Ten_AddZzimBrand '" & userid & "','" & makerid & "'"

	'response.write sqlStr & "<br>"
	dbget.Execute sqlStr

	sqlStr = " Update db_user.dbo.tbl_user_c SET recommendcount = recommendcount + 1 WHERE userid = '"&makerid&"' "

	'response.write sqlStr & "<br>"
	dbget.Execute sqlStr

	if bestpg <> "1" then
		response.write "<script type='text/javascript'>"
		response.write "	alert('찜브랜드에 추가 되었습니다!'); parent.location.reload();"
		response.write "</script>"
	end if
	dbget.close()	:	response.end

elseif sMode = "D" then
    sqlStr = "DELETE FROM [db_my10x10].[dbo].[tbl_mybrand] WHERE" + VbCrlf
    sqlStr = sqlStr + " userid='"& userid &"'" + VbCrlf
    sqlStr = sqlStr + " and makerid ='"& makerid &"'"
    
    'response.write sqlStr & "<br>"
    dbget.execute sqlStr

	sqlStr = " Update db_user.dbo.tbl_user_c SET recommendcount = recommendcount - 1 WHERE userid = '"&makerid&"' "

	'response.write sqlStr & "<br>"
	dbget.Execute sqlStr

	if bestpg <> "1" then
		response.write "<script type='text/javascript'>"
		response.write "	alert('찜브랜드가 삭제 되었습니다!'); parent.location.reload();"
		response.write "</script>"
	end if
	dbget.close()	:	response.end
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->