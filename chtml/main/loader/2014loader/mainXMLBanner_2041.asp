<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
response.charset = "utf-8"

'//마케팅 배너
Dim sFolder2, mainFile2
Dim xmlDOM2, CtrlDate2, i2
Dim image2, link2, startdate2, enddate2, altname2

sFolder2 = "/chtml/main/xml/main_banner/"
mainFile2 = "main_2042.xml"
CtrlDate2 = now()
sMainXmlUrl2 = server.MapPath(sFolder2 & mainFile2)	'// 접수 파일

on Error Resume Next
Set oFile = CreateObject("ADODB.Stream")
With oFile
	.Charset = "UTF-8"
	.Type=2
	.mode=3
	.Open
	.loadfromfile sMainXmlUrl2
	fileCont2=.readtext
	.Close
End With
Set oFile = Nothing
on Error Goto 0

Dim issueYn , issueHtml 'issuehtml 하단에 복붓

If fileCont2 <> "" Then

	Set xmlDOM = Server.CreateObject("MSXML2.DomDocument.3.0")
	xmlDOM.async = False
	xmlDOM.LoadXML fileCont2

	'// 하위 항목이 여러개일 때
	Dim cTmpl2, tplNodes2
	Set cTmpl2 = xmlDOM.getElementsByTagName("item")
	Set xmlDOM = Nothing
	i = 0
	
	For each tplNodes2 in cTmpl2
		image2		= tplNodes2.getElementsByTagName("img").item(0).text
		link2		= tplNodes2.getElementsByTagName("link").item(0).text
		startdate2	= tplNodes2.getElementsByTagName("startdate").item(0).text
		enddate2		= tplNodes2.getElementsByTagName("enddate").item(0).text
		altname2	= tplNodes2.getElementsByTagName("altname").item(0).Text
		
		If CDate(CtrlDate2) >= CDate(startdate2) AND CDate(CtrlDate2) <= CDate(enddate2) Then
			
			issueYN = "issue"
			issueHtml = "<div class=""swiper-slide""><a href="""& link2 &"""><img src="""& image2 &""" alt="""& altname2 &""" /></a></div>"

			i = i + 1
		End If
		if i>=1 then exit for	'//1개씩만 노출 이상이면 강종 대신 if문에서 날짜 체크함 
	Next
Else
	issueYN = ""
End If 


'//롤링 배너
Dim sFolder, mainFile
Dim fso, sMainXmlUrl, oFile, fileCont , fileCont2 , sMainXmlUrl2
Dim xmlDOM, CtrlDate, i
Dim image, link, startdate, enddate, altname

sFolder = "/chtml/main/xml/main_banner/"
mainFile = "main_2041.xml"
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
	i2 = 5 '//마케팅 배너 자리
	i = 0

%>
	<div class="swiper-container swiper1 <%=issueYN%>"><!-- issue 선택적 -->
		<div class="swiper-wrapper swiper-no-swiping">
<%

	For each tplNodes in cTmpl
		image		= tplNodes.getElementsByTagName("img").item(0).text
		link		= tplNodes.getElementsByTagName("link").item(0).text
		startdate	= tplNodes.getElementsByTagName("startdate").item(0).text
		enddate		= tplNodes.getElementsByTagName("enddate").item(0).text
		altname		= tplNodes.getElementsByTagName("altname").item(0).Text
		
		If CDate(CtrlDate) >= CDate(startdate) AND CDate(CtrlDate) <= CDate(enddate) Then
			If issueYN <> "" Then '//이슈배너 있을때
				If i = i2 Then '//배너가 5개까지만 노출
					Exit For
				End If 
			Else '//없을때
				If i = i2+1 Then '//없으면 6개까지만 노출
					Exit For
				End If 
			End If 
%>
			<div class="swiper-slide">
				<a href="<%= link %>"><img src="<%= image %>" alt="<%= altname %>" /></a>
			</div>
<%
			i = i + 1
		End If
	Next

	If issueYN <> "" And i = i2 Then '마케팅 배너가 있으면 6번째꺼 무시하고 6번째 자리로 마케팅 배너가 들어감 - 기본 롤링이 5개 이상이 되어야함
		Response.write issueHtml
	End If 
		
%>
		</div>
		<div class="bnrPaging"></div>
	</div>
<%
	Set cTmpl = Nothing
End If
%>