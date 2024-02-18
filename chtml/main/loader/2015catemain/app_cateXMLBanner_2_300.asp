<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
response.charset = "utf-8"
Dim sFolder, mainFile
Dim fso, sMainXmlUrl, oFile, fileCont
Dim xmlDOM, CtrlDate, i
Dim image, link, startdate, enddate, altname
Dim texttitle1 , texttitle2 , saleflag , saletext
Dim existscnt , needcnt , existsidx
Dim gaParam : gaParam = "&gaparam=catemain_b" '//GA 체크 변수

sFolder = "/chtml/main/xml/main_banner/"
mainFile = "main_cate_2_300.xml"
CtrlDate = now()
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

existscnt = 0
needcnt = 0

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
		image		= tplNodes.getElementsByTagName("img").item(0).text
		link		= tplNodes.getElementsByTagName("link").item(0).text
		startdate	= tplNodes.getElementsByTagName("startdate").item(0).text
		enddate		= tplNodes.getElementsByTagName("enddate").item(0).text
		altname		= tplNodes.getElementsByTagName("altname").item(0).Text

		texttitle1		= tplNodes.getElementsByTagName("texttitle1").item(0).Text
		texttitle2		= tplNodes.getElementsByTagName("texttitle2").item(0).Text
		saleflag		= tplNodes.getElementsByTagName("saleflag").item(0).Text
		saletext		= tplNodes.getElementsByTagName("saletext").item(0).Text
		
		If CDate(CtrlDate) >= CDate(startdate) AND CDate(CtrlDate) <= CDate(enddate) Then
			If i = 1 Then
				Exit For 
			End If
%>
		<p><a href="" onclick="fnAPPpopupAutoUrl('<%= link %><%=gaParam%>');return false;"><img src="<%= image %>" alt="<%= altname %>" /></a></p>
<%
			i = i + 1
			existsidx = existsidx & chkIIF(existsidx<>"",",","") & link		'/등록된 이미지의 IDX를 저장
		End If
	Next

	existscnt = ubound(split(existsidx,","))	'//위에서 등록된 이미지수
	needcnt = 0 - existscnt						'//모자란 이미지수

	i = 0
	For each tplNodes in cTmpl

		if i >= needcnt then exit for	'//모자란 이미지수 만큼만 뿌린다

		image		= tplNodes.getElementsByTagName("img").item(0).text
		link		= tplNodes.getElementsByTagName("link").item(0).text
		startdate	= tplNodes.getElementsByTagName("startdate").item(0).text
		enddate		= tplNodes.getElementsByTagName("enddate").item(0).text
		altname		= tplNodes.getElementsByTagName("altname").item(0).Text

		texttitle1		= tplNodes.getElementsByTagName("texttitle1").item(0).Text
		texttitle2		= tplNodes.getElementsByTagName("texttitle2").item(0).Text
		saleflag		= tplNodes.getElementsByTagName("saleflag").item(0).Text
		saletext		= tplNodes.getElementsByTagName("saletext").item(0).Text
		
		If CDate(CtrlDate) >= CDate(startdate) AND instr(existsidx,link)=0 Then
			If i = 1 Then
				Exit For 
			End If
%>
		<p><a href="" onclick="fnAPPpopupAutoUrl('<%= link %><%=gaParam%>');return false;"><img src="<%= image %>" alt="<%= altname %>" /></a></p>
<%
			i = i + 1
		End If
	Next

	Set cTmpl = Nothing
End If
on Error Goto 0
%>