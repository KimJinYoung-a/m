<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
response.charset = "utf-8"
Dim sFolder, mainFile
Dim fso, sMainXmlUrl, oFile, fileCont
Dim xmlDOM, CtrlDate
Dim img1, img2, img3 , img4
Dim img1alt, img2alt, img3alt , img4alt
Dim img2url , img3url , img4url , img1url
Dim img2text , img3text , img4text , img1text
Dim img2sale , img3sale , img4sale , img1sale
Dim img2stdate , img3stdate , img4stdate , img1stdate
Dim img2eddate , img3eddate , img4eddate , img1eddate
Dim img2sc , img3sc , img4sc , img1sc
sFolder = "/chtml/main/xml/enjoyevent/" & Replace(Date(),"-","") &"/"
CtrlDate = Date()
mainFile = "main_enjoyevent_"&CtrlDate&".xml"
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
%>
	<ul class="enjoyEventList">
<%

	For each tplNodes in cTmpl
		img1		= tplNodes.getElementsByTagName("img1").item(0).text
		img2		= tplNodes.getElementsByTagName("img2").item(0).text
		img3		= tplNodes.getElementsByTagName("img3").item(0).text
		img4		= tplNodes.getElementsByTagName("img4").item(0).Text
		
		img1alt		= tplNodes.getElementsByTagName("img1alt").item(0).text
		img2alt		= tplNodes.getElementsByTagName("img2alt").item(0).text
		img3alt		= tplNodes.getElementsByTagName("img3alt").item(0).text
		img4alt		= tplNodes.getElementsByTagName("img4alt").item(0).Text
		
		img1url		= tplNodes.getElementsByTagName("img1url").item(0).text
		img2url		= tplNodes.getElementsByTagName("img2url").item(0).text
		img3url		= tplNodes.getElementsByTagName("img3url").item(0).text
		img4url		= tplNodes.getElementsByTagName("img4url").item(0).Text

		img1text		= tplNodes.getElementsByTagName("img1text").item(0).text
		img2text		= tplNodes.getElementsByTagName("img2text").item(0).text
		img3text		= tplNodes.getElementsByTagName("img3text").item(0).text
		img4text		= tplNodes.getElementsByTagName("img4text").item(0).Text

		img1sale		= tplNodes.getElementsByTagName("img1sale").item(0).text
		img2sale		= tplNodes.getElementsByTagName("img2sale").item(0).text
		img3sale		= tplNodes.getElementsByTagName("img3sale").item(0).text
		img4sale		= tplNodes.getElementsByTagName("img4sale").item(0).Text

		img1stdate		= tplNodes.getElementsByTagName("img1stdate").item(0).text
		img2stdate		= tplNodes.getElementsByTagName("img2stdate").item(0).text
		img3stdate		= tplNodes.getElementsByTagName("img3stdate").item(0).text
		img4stdate		= tplNodes.getElementsByTagName("img4stdate").item(0).Text

		img1eddate		= tplNodes.getElementsByTagName("img1eddate").item(0).text
		img2eddate		= tplNodes.getElementsByTagName("img2eddate").item(0).text
		img3eddate		= tplNodes.getElementsByTagName("img3eddate").item(0).text
		img4eddate		= tplNodes.getElementsByTagName("img4eddate").item(0).Text

		img1sc			= tplNodes.getElementsByTagName("img1sc").item(0).text
		img2sc			= tplNodes.getElementsByTagName("img2sc").item(0).text
		img3sc			= tplNodes.getElementsByTagName("img3sc").item(0).text
		img4sc			= tplNodes.getElementsByTagName("img4sc").item(0).Text
		
		startdate	= CDate(replace(tplNodes.getElementsByTagName("startdate").item(0).text, ",", "-"))
		enddate		= CDate(replace(tplNodes.getElementsByTagName("enddate").item(0).text, ",", "-"))

		If CtrlDate >= startdate AND CtrlDate <= enddate Then
%>
		<li>
			<a href="/apps/appcom/wish/webview<%=img1url%>">
				<div class="eventTitWrap">
					<p class="evtTit"><%=img1text%> <span class="<%=chkiif(img1sc="1","cRed","cGrn")%>"><%=img1sale%></span></p>
					<p class="evtTerm">~<%=img1eddate%></p>
				</div>
				<img src="<%=img1%>" alt="<%=img1alt%>" />
			</a>
		</li>
		<li>
			<a href="/apps/appcom/wish/webview<%=img2url%>">
				<div class="eventTitWrap">
					<p class="evtTit"><%=img2text%> <span class="<%=chkiif(img2sc="1","cRed","cGrn")%>"><%=img2sale%></span></p>
					<p class="evtTerm">~<%=img2eddate%></p>
				</div>
				<img src="<%=img2%>" alt="<%=img2alt%>" />
			</a>
		</li>
		<li>
			<a href="/apps/appcom/wish/webview<%=img3url%>">
				<div class="eventTitWrap">
					<p class="evtTit"><%=img3text%> <span class="<%=chkiif(img3sc="1","cRed","cGrn")%>"><%=img3sale%></span></p>
					<p class="evtTerm">~<%=img3eddate%></p>
				</div>
				<img src="<%=img3%>" alt="<%=img3alt%>" />
			</a>
		</li>
<%
		End If
	Next
%>
	</ul>
<%
	Set cTmpl = Nothing
End If
on Error Goto 0
%>
