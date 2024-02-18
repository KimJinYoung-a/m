<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->

<%
dim backurl, userid , makerid, mode
	makerid = request.Form("makerid")
	mode       = request.Form("mode")
	userid = getEncLoginUserID	
	backurl = request.ServerVariables("HTTP_REFERER")
	If backurl = "" Then
		backurl = "http://www.10x10.co.kr"
	End IF

	if InStr(LCase(backurl),"10x10.co.kr") < 0 then response.redirect backurl
	if makerid="" then response.redirect backurl
		

if Not(IsUserLoginOK) then
	Call Alert_return("로그인하셔야 사용할 수 있습니다.")
	Response.End
end if


'makerid = left(makerid,len(makerid)-1)
makerid =  replace(makerid,",","','")
makerid = "'"&makerid&"'"

dim sqlStr

if mode="del" then
    
    sqlStr = "DELETE FROM [db_my10x10].[dbo].[tbl_mybrand] " + VbCrlf
    sqlStr = sqlStr + " WHERE userid='"& userid &"'" + VbCrlf
    sqlStr = sqlStr + " and makerid in ("& makerid &")" + VbCrlf
    
    'response.write sqlStr&"<br>"
    dbget.execute sqlStr
end if	

%>
<script language="javascript">
	alert('삭제되었습니다');
	parent.location.reload()
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->