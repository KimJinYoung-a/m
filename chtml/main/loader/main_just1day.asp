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
		<a href="<%=extraurl%>"><img src="<%=extraimg%>" alt="주말/휴일대체용 이미지" width="100%"/></a>
<%
			else
%>
		<div class="justInnerBox" onclick="location.href='/category/category_itemPrd.asp?itemid=<%=itemid%>'">
			<span class="pointer"></span>
			<div>
				<p class="justSale"><%=saleper%><span>%</span></p>
				<dl>
					<dt><img src="http://fiximage.10x10.co.kr/m/2013/common/main_just_tit.png" alt="JUST 1DAY" /></dt>
					<dd class="justTime"><!-- 13:43:05 --></dd>
					<dd class="justPdt"><%=onairtitle%></dd>
					<dd class="justPrice"><%=FormatNumber(saleprice,0)%> 원</dd>
				</dl>
				<p class="justPic">
					<img src="<%=image%>" alt="<%=itemname%>" />
				</p>
			</div>
		</div>
<%
			End If
		End If
	Next
	Set cTmpl = Nothing
End If
on Error Goto 0
%>