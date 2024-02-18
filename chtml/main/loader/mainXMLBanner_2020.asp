<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
response.charset = "utf-8"
Dim sFolder, mainFile
Dim fso, sMainXmlUrl, oFile, fileCont
Dim xmlDOM, CtrlDate, i
Dim image, link, startdate, enddate, altname
sFolder = "/chtml/main/xml/main_banner/"
mainFile = "main_2020.xml"
CtrlDate = now()
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
		if i>0 then exit for
		image		= tplNodes.getElementsByTagName("img").item(0).text
		link		= tplNodes.getElementsByTagName("link").item(0).text
		startdate	= tplNodes.getElementsByTagName("startdate").item(0).text
		enddate		= tplNodes.getElementsByTagName("enddate").item(0).text
		altname		= tplNodes.getElementsByTagName("altname").item(0).Text
		
		If CDate(CtrlDate) >= CDate(startdate) AND CDate(CtrlDate) <= CDate(enddate) Then
%>
		<a href="<%= link %>"><img src="<%= image %>" alt="<%= altname %>" /></a>
<%
			i = i + 1
		End If
	Next
	Set cTmpl = Nothing
End If
%>