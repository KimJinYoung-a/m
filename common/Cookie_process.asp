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
Dim due , gubun , chklog
due = request("due")

gubun = request("gubun")
chklog = request("chklog")

'//모달레이어 쿠키
If due = "one" Or due = "applyr" Then
	response.Cookies("appdown").domain = "10x10.co.kr"
	response.Cookies("appdown")("mode") = "x"
	response.Cookies("appdown").Expires = Date() + 7
End If

If chklog = "chk" Then
	Dim strSql
	strSql = "insert into db_temp.dbo.tbl_applayer_clicklog (rdsite) values ('"& gubun &"')"
	dbget.Execute strSql
	response.write "OK||등록완료"
	response.End
End if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->