<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
response.charset = "utf-8"
Dim sFolder, mainFile
Dim fso, sMainXmlUrl, oFile, fileCont
Dim xmlDOM, CtrlDate, i
Dim evtimg , evtalt , linkurl , linktype , evttitle , issalecoupon , evtstdate , evteddate , startdate , enddate , issalecoupontxt , evt_todaybanner
sFolder = "/chtml/main/xml/main_banner/"
mainFile = "main_todayenjoy.xml"
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

%>
	<ul class="enjoyEventList">
<%

	For each tplNodes in cTmpl
		evtimg				= tplNodes.getElementsByTagName("evtimg").item(0).text
		evtalt				= tplNodes.getElementsByTagName("evtalt").item(0).text
		linkurl				= tplNodes.getElementsByTagName("linkurl").item(0).text
		linktype			= tplNodes.getElementsByTagName("linktype").item(0).text
		evttitle			= tplNodes.getElementsByTagName("evttitle").item(0).text
		issalecoupon		= tplNodes.getElementsByTagName("issalecoupon").item(0).text
		evtstdate			= CDate(replace(tplNodes.getElementsByTagName("evtstdate").item(0).text, ",", "-"))
		evteddate			= CDate(replace(tplNodes.getElementsByTagName("evteddate").item(0).text, ",", "-"))
		startdate			= tplNodes.getElementsByTagName("startdate").item(0).text
		enddate				= tplNodes.getElementsByTagName("enddate").item(0).text
		issalecoupontxt		= tplNodes.getElementsByTagName("issalecoupontxt").item(0).text
		evt_todaybanner		= tplNodes.getElementsByTagName("evt_todaybanner").item(0).Text

		If CDate(CtrlDate) >= CDate(startdate) AND CDate(CtrlDate) <= CDate(enddate) Then
%>
		<li>
			<a href="/apps/appcom/wish/webview<%=linkurl%>">
				<div class="eventTitWrap">
					<p class="evtTit"><%=evttitle%> <span class="<%=chkiif(issalecoupon="1","cRed","cGrn")%>"><%=issalecoupontxt%></span></p>
					<p class="evtTerm">~<%=evteddate%></p>
				</div>
				<img src="<%=chkiif(linktype="1",evt_todaybanner,evtimg)%>" alt="<%=evtalt%>" />
			</a>
		</li>
<%
			i = i + 1
		End If
	Next
%>
	</ul>
<%
	Set cTmpl = Nothing
End If
%>