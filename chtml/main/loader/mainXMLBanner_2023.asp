<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
response.charset = "utf-8"
Dim sFolder, mainFile
Dim fso, sMainXmlUrl, oFile, fileCont
Dim xmlDOM, CtrlDate, i, existsidx, idx, existscnt, needcnt
Dim image, link, startdate, enddate, altname
sFolder = "/chtml/main/xml/main_banner/"
mainFile = "main_2023.xml"
CtrlDate = Date()
existscnt = 0
needcnt = 0
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
		startdate	= CDate(replace(tplNodes.getElementsByTagName("startdate").item(0).text, ",", "-"))
		enddate		= CDate(replace(tplNodes.getElementsByTagName("enddate").item(0).text, ",", "-"))
		altname		= tplNodes.getElementsByTagName("altname").item(0).text
		idx			= tplNodes.getElementsByTagName("idx").item(0).text

		If CtrlDate >= startdate AND CtrlDate <= enddate Then
%>
				<div class="mainChannel" style="background-image:url(<%= image %>);">
<%
			existsidx = existsidx + idx + ","		'/등록된 이미지의 IDX를 저장
			
			i = i + 1
		End If
	Next

	existscnt = ubound(split(existsidx,","))
	needcnt = 1-existscnt
	i = 0

	'//만약 등록을 안했을경우 종료 이전꺼를 가져옴
	For each tplNodes in cTmpl
		if i>=needcnt then exit for	'//모자란 이미지수 만큼만 뿌린다
		if existscnt<0 then needcnt = 1
		'변수 저장
		image		= tplNodes.getElementsByTagName("img").item(0).text
		link		= tplNodes.getElementsByTagName("link").item(0).text
		startdate	= CDate(replace(tplNodes.getElementsByTagName("startdate").item(0).text, ",", "-"))
		enddate		= CDate(replace(tplNodes.getElementsByTagName("enddate").item(0).text, ",", "-"))
		altname		= tplNodes.getElementsByTagName("altname").item(0).text
		idx			= tplNodes.getElementsByTagName("idx").item(0).text
			
		'//종료 인것중에, 위에서 노출시킨거 빼고 뿌린다
		If CtrlDate >= startdate AND instr(existsidx,idx)=0 Then
%>
				<div class="mainChannel" style="background-image:url(<%= image %>);">
<%
			i = i + 1
		End If
	Next
	Set cTmpl = Nothing
End If
%>