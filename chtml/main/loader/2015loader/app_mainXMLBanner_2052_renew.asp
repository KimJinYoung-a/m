<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
response.charset = "utf-8"

Dim sFolder, mainFile
Dim fso, sMainXmlUrl, oFile, fileCont , fileCont2 , fileCont3 , sMainXmlUrl2 , sMainXmlUrl3
Dim addcls '//롤링배너 페이징 디자인
Dim gaParam : gaParam = "&gaparam=todaymain2_a_1" '//GA 체크 변수

'//플레이등 기타 배너
Dim sFolder3, mainFile3
Dim xmlDOM3, CtrlDate3, i3
Dim image3, link3, startdate3, enddate3, altname3 , jsurl

sFolder3 = "/chtml/main/xml/main_banner/"
mainFile3 = "main_2061.xml"
CtrlDate3 = now()
sMainXmlUrl3 = server.MapPath(sFolder3 & mainFile3)	'// 접수 파일

on Error Resume Next
Set oFile = CreateObject("ADODB.Stream")
With oFile
	.Charset = "UTF-8"
	.Type=2
	.mode=3
	.Open
	.loadfromfile sMainXmlUrl3
	fileCont3=.readtext
	.Close
End With
Set oFile = Nothing
on Error Goto 0

Dim playYn , playHtml 'playHtml 하단에 복붓

If fileCont3 <> "" Then

	Set xmlDOM = Server.CreateObject("MSXML2.DomDocument.3.0")
	xmlDOM.async = False
	xmlDOM.LoadXML fileCont3

	'// 하위 항목이 여러개일 때
	Dim cTmpl3, tplNodes3
	Set cTmpl3 = xmlDOM.getElementsByTagName("item")
	Set xmlDOM = Nothing
	i = 0
	
	For each tplNodes3 in cTmpl3
		image3		= tplNodes3.getElementsByTagName("img").item(0).text
		link3		= tplNodes3.getElementsByTagName("link").item(0).text
		startdate3	= tplNodes3.getElementsByTagName("startdate").item(0).text
		enddate3	= tplNodes3.getElementsByTagName("enddate").item(0).text
		altname3	= tplNodes3.getElementsByTagName("altname").item(0).Text

		If CDate(CtrlDate3) >= CDate(startdate3) AND CDate(CtrlDate3) <= CDate(enddate3) Then

			'//링크별 열리는 팝업 주소
			If inStr(link3,"/culturestation/")>0 Then
				jsurl = "fnAPPpopupCulture_URL"
			ElseIf inStr(link3,"/play/")>0 Then
				jsurl = "fnAPPpopupPlay_URL"
			ElseIf inStr(link3,"/gift/")>0 Then
				jsurl = "fnAPPpopupGift_URL"
			ElseIf inStr(link3,"/wish/")>0 Then
				jsurl = "fnAPPpopupWish_URL"
			ElseIf inStr(link3,"/event/")>0 Then
				jsurl = "fnAPPpopupEvent_URL"
			End If 
			
			playYn = "ok"
			playHtml = "<div class=""swiper-slide""><a href="""" onclick="""&jsurl&"('http://m.10x10.co.kr/apps/appcom/wish/web2014"& link3 & gaParam &"');return false;""><img src="""& image3 &""" alt="""& altname3 &"""></a></div>"

			i = i + 1
		End If
		if i>=1 then exit for	'//1개씩만 노출 이상이면 강종 대신 if문에서 날짜 체크함 
	Next
Else
	playYn = ""
End If 

'//마케팅 배너
Dim sFolder2, mainFile2
Dim xmlDOM2, CtrlDate2, i2
Dim image2, link2, startdate2, enddate2, altname2

sFolder2 = "/chtml/main/xml/main_banner/"
mainFile2 = "main_2054.xml"
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
			
			issueYN = "ok"
			issueHtml = "<div class=""swiper-slide""><a href="""" onclick=""fnAPPpopupAutoUrl('"& link2 & gaParam &"');return false;""><img src="""& image2 &""" alt="""& altname2 &"""></a></div>"

			i = i + 1
		End If
		if i>=1 then exit for	'//1개씩만 노출 이상이면 강종 대신 if문에서 날짜 체크함 
	Next
Else
	issueYN = ""
End If 


'//롤링 배너
Dim xmlDOM, CtrlDate, i
Dim image, link, startdate, enddate, altname

sFolder = "/chtml/main/xml/main_banner/"
mainFile = "main_2052.xml"
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
	i2 = 6 '//마케팅 배너 자리
	i = 0

	If issueYN = "" And playYn = "" Then '// 없음
		addcls = ""
	ElseIf (issueYN = "" And playYn <> "") Or (issueYN <> "" And playYn = "") Then
		addcls = "spcBnr1"
	ElseIf issueYN <> "" and playYn <> "" Then
		addcls = "spcBnr2"
	End If 
%>
	<div class="swiper-container swiper1 <%=addcls%>"><%'선택적%>
		<div class="swiper-wrapper">
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

			'//링크별 열리는 팝업 주소
			If inStr(link,"/clearancesale/")>0 Then
				jsurl = "fnAPPpopupClearance_URL"
			Else
				jsurl = "fnAPPpopupAutoUrl"
			End If 
%>
			<div class="swiper-slide"><a href="" onclick="<%=jsurl%>('<%= link %><%=gaParam%>');return false;"><img src="<%= image %>" alt="<%= altname %>"></a></div>
<%
			i = i + 1
		End If
	Next

	If playYn <> "" Then
		Response.write playHtml '//기본 5번 or 6번 배너 후에 고정 배너
	End If 

	If issueYN <> "" And i = i2 Then '마케팅 배너가 있으면 6번째꺼 무시하고 6번째 자리로 마케팅 배너가 들어감 - 기본 롤링이 5개 이상이 되어야함
		Response.write issueHtml
	End If 
		
%>
		</div>
		<div class="swiper-pagination paging1"></div>
	</div>
<%
	Set cTmpl = Nothing
End If
%>