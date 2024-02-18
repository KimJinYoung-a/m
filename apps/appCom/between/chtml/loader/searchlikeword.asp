<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/commFunc.asp" -->
<%
response.charset = "utf-8"
Dim sFolder, mainFile, i
Dim fso, sMainXmlUrl, oFile, fileCont
Dim xmlDOM
Dim rank, likeword
sFolder = "/apps/appCom/between/chtml/xml/"
mainFile = "search_likeword.xml"

on Error Resume Next
sMainXmlUrl = server.MapPath(sFolder & mainFile)	'// 접수 파일
Set oFile = CreateObject("ADODB.Stream")
With oFile
	.Charset = "UTF-8"
	.Type=2
	.mode=3
	.Open
	.loadfromfile sMainXmlUrl
	fileCont=.readtext
	.Close
End With
Set oFile = Nothing
on Error Goto 0

If fileCont<>"" Then
	'// XML 파싱
	Set xmlDOM = Server.CreateObject("MSXML2.DomDocument.3.0")
		xmlDOM.async = False
		xmlDOM.LoadXML fileCont

	'// 하위 항목이 여러개일 때
	Dim cTmpl, tplNodes
	Set cTmpl = xmlDOM.getElementsByTagName("item")
	Set xmlDOM = Nothing

	i = 0
	For each tplNodes in cTmpl
		rank	 = tplNodes.getElementsByTagName("rank").item(0).text
		likeword = Trim(tplNodes.getElementsByTagName("likeword").item(0).text)
%>
							<li><a href="/apps/appCom/between/search/result.asp?rect=<%=Server.URLEncode(likeword) %>&exkw=1"><span><%= rank %></span> <%= likeword %></a></li>
<%
	Next
End If
%>