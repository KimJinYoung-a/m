<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
response.charset = "utf-8"
Dim sFolder, mainFile
Dim fso, sMainXmlUrl, oFile, fileCont
Dim xmlDOM, CtrlDate
Dim image, link, startdate, enddate, altname , itemname , itemid , extraimg , extraurl , saleper , onairtitle , saleprice
sFolder = "/chtml/main/xml/justoneday/" & Replace(Date(),"-","") &"/"
CtrlDate = Date()
mainFile = "main_justoneday_"&CtrlDate&".xml"

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
%>
<%
	'// XML 파싱
	Set xmlDOM = Server.CreateObject("MSXML2.DomDocument.3.0")
	xmlDOM.async = False
	xmlDOM.LoadXML fileCont

	'// 하위 항목이 여러개일 때
	Dim cTmpl, tplNodes
	Set cTmpl = xmlDOM.getElementsByTagName("item")
	Set xmlDOM = Nothing

	For each tplNodes in cTmpl
		image		= tplNodes.getElementsByTagName("basicimage").item(0).text
		itemname		= tplNodes.getElementsByTagName("itemname").item(0).text
		itemid		= tplNodes.getElementsByTagName("itemid").item(0).text
		extraimg		= tplNodes.getElementsByTagName("extraimg").item(0).text
		extraurl		= tplNodes.getElementsByTagName("extraurl").item(0).text
		saleper		= tplNodes.getElementsByTagName("saleper").item(0).text
		startdate	= CDate(replace(tplNodes.getElementsByTagName("startdate").item(0).text, ",", "-"))
		enddate		= CDate(replace(tplNodes.getElementsByTagName("enddate").item(0).text, ",", "-"))
		onairtitle		= tplNodes.getElementsByTagName("onairtitle").item(0).Text
		saleprice		= tplNodes.getElementsByTagName("saleprice").item(0).text
		If CtrlDate >= startdate AND CtrlDate <= enddate Then
			If itemid = "" then
%>
		<section class="just1Day pad0">
		<img src="<%=extraimg%>" alt="주말/휴일대체용 이미지" width="100%" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014<%= extraurl %>');"/>
<%
			else
%>
		<section class="just1Day">
		<div onclick="fnAPPpopupProduct('<%=itemid%>');">
			<h2>JUST <span class="cRd1">1 DAY</span></h2>
			<div class="justPdtInfo">
				<p><%=onairtitle%></p>
				<p class="cBk1"><strong><%=FormatNumber(saleprice,0)%> 원</strong></p>
			</div>
			<div class="justPdt">
				<div class="pic"><img src="<%=image%>" alt="<%=itemname%>" /></div>
				<span class="discount"><strong><%=saleper%></strong>%</span>
			</div>
		</div>
<%
			End If
		End If
	Next
%>
</section>
<%
	Set cTmpl = Nothing
End If
on Error Goto 0
%>