<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
Dim due , gubun , chklog, snsrdsite
due = request("due")

gubun = request("gubun")
chklog = request("chklog")
snsrdsite = request("snsrdsite")

'//모달레이어 쿠키
If due = "one" Or due = "applyr" Then
	response.Cookies(snsrdsite).domain = "10x10.co.kr"
	response.Cookies(snsrdsite)("mode") = "x"
	response.Cookies(snsrdsite).Expires = dateadd("d",365,Now())
End If

If chklog = "nvlevt" Then
	Dim strSql
'	strSql = "insert into db_temp.dbo.tbl_Snslayer_clicklog (rdsite) values ('"& gubun &"')"
'	dbget.Execute strSql
	response.write "NV||회원가입"
	response.End
End if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->