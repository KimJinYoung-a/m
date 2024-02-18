<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
response.charset = "utf-8"
Dim sFolder, mainFile
Dim fso, sMainXmlUrl, oFile, fileCont
Dim xmlDOM, CtrlDate
Dim bgimg, limg, rimg, lalt, ralt, lurl, rurl, startdate, enddate , bgalt , bgurl
sFolder = "/chtml/main/xml/tpobanner/"
mainFile = "main_tpobanner.xml"
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
		bgimg		= tplNodes.getElementsByTagName("bgimg").item(0).text
		limg		= tplNodes.getElementsByTagName("limg").item(0).text
		rimg		= tplNodes.getElementsByTagName("rimg").item(0).text
		lalt		= tplNodes.getElementsByTagName("lalt").item(0).text
		ralt		= tplNodes.getElementsByTagName("ralt").item(0).text
		lurl		= tplNodes.getElementsByTagName("lurl").item(0).text
		rurl		= tplNodes.getElementsByTagName("rurl").item(0).text
		startdate	= CDate(replace(tplNodes.getElementsByTagName("startdate").item(0).text, ",", "-"))
		enddate		= CDate(replace(tplNodes.getElementsByTagName("enddate").item(0).text, ",", "-"))
		If CtrlDate >= startdate AND CtrlDate <= enddate Then
%>
							<div class="swiper-slide">
								<div style="background-image:url(<%= bgimg %>);">
									<p class="overHidden">
										<span><a href="<%= lurl %>"><img src="<%= limg %>" alt="<%= lalt %>" /></a></span>
										<span><a href="<%= rurl %>"><img src="<%= rimg %>" alt="<%= ralt %>" /></a></span>
									</p>
								</div>
							</div>
<%
		End If
	Next
	Set cTmpl = Nothing
End If
on Error Goto 0
%>