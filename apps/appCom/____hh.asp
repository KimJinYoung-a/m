<% @language=vbscript %>
<% Option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/htmllib.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/lib/classes/appmanage/util.asp"-->
<!-- #include virtual="/lib/classes/appmanage/hitchhiker.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<%
Dim sMethod : sMethod = Request("method")
Dim sJSON : sJSON = ""

If sMethod = "GetBookList" Then
'	sJSON = API_GetBookList()
	sJSON = "[{""bookid"":5,""vol"":35,""rev"":2},{""bookid"":4,""vol"":36,""rev"":3},{""bookid"":4,""vol"":37,""rev"":10}]"
ElseIf sMethod = "login" Then
	Dim sUserId : sUserId = Request("userid")
	Dim sPassword : sPassword = Request("password")
	sPassword = hhPasswordHash(sUserId, sPassword)
	sJSON = "{""result"":true, ""userid"":""" & sUserId & """, ""password"":""" & sPassword & """}"
ElseIf sMethod = "GetBook" Then
	Dim sBookId : sBookId = Request("bookid")
	sJSON = API_GetBook(sBookId)
End If

' UTF-8 문서
Response.ContentType = "application/json"
Response.Write sJSON
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->