<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
response.charset = "utf-8"
Dim sFolder, mainFile
Dim fso, sMainXmlUrl, oFile, fileCont
Dim xmlDOM, CtrlDate
Dim idx, textname, linkinfo
sFolder = "/chtml/main/xml/textissue/"
mainFile = "main_textissue.xml"
CtrlDate = Date()
sMainXmlUrl = server.MapPath(sFolder & mainFile)	'// 접수 파일

on Error Resume Next
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

If fileCont<>"" Then
	'// XML 파싱
	Set xmlDOM = Server.CreateObject("MSXML2.DomDocument.3.0")
	xmlDOM.async = False
	xmlDOM.LoadXML fileCont

	'// 하위 항목이 여러개일 때
	Dim cTmpl, tplNodes
	Set cTmpl = xmlDOM.getElementsByTagName("item")
	Set xmlDOM = Nothing

	For each tplNodes in cTmpl
		idx			= tplNodes.getElementsByTagName("idx").item(0).text
		textname	= tplNodes.getElementsByTagName("textname").item(0).text
		linkinfo	= tplNodes.getElementsByTagName("linkinfo").item(0).text
%>
						<li><a href="<%= linkinfo %>"><div><%= textname %></div></a></li>
<%
	Next
	Set cTmpl = Nothing
End If
on Error Goto 0
%>