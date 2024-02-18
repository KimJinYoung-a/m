<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/commFunc.asp" -->
<%
response.charset = "utf-8"
Dim sFolder, mainFile, i, idx, existsidx
Dim fso, sMainXmlUrl, oFile, fileCont
Dim xmlDOM, CtrlDate, existscnt, needcnt
Dim imgurl, imglink, startdate, enddate
sFolder = "/apps/appCom/between/chtml/xml/"
If fnGetUserInfo("sex") = "M" Then
	mainFile = "main3BannerM.xml"
Else
	mainFile = "main3BannerF.xml"
End If

CtrlDate = Date()
sMainXmlUrl = server.MapPath(sFolder & mainFile)	'// 접수 파일

existscnt = 0
needcnt = 0

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

	i = 0
	For each tplNodes in cTmpl
		if i>2 then exit for	'//이미지 갯수가 3장일경우 그만뿌림
		idx			= tplNodes.getElementsByTagName("idx").item(0).text
		imgurl		= tplNodes.getElementsByTagName("imgurl").item(0).text
		imglink		= tplNodes.getElementsByTagName("imglink").item(0).text
		startdate	= CDate(replace(tplNodes.getElementsByTagName("startdate").item(0).text, ",", "-"))
		enddate		= CDate(replace(tplNodes.getElementsByTagName("enddate").item(0).text, ",", "-"))

		If CtrlDate >= startdate AND CtrlDate <= enddate Then
			If imglink <> "" Then
%>
							<p class="swiper-slide"><a href="<%= imglink %>"><img src="<%= imgurl%>" alt="기획전<%= i+1 %>" /></a></p>
<%
			Else
%>
							<p class="swiper-slide"><img src="<%= imgurl%>" alt="기획전<%= i+1 %>" /></p>
<%
			End If
			existsidx = existsidx & idx & ","		'/등록된 이미지의 IDX를 저장
			i = i + 1
		End If
	Next

	existscnt = ubound(split(existsidx,","))	'//위에서 등록된 이미지수
	needcnt = 3-existscnt						'//모자란 이미지수

	i = 0
	'//만약 등록을 안했을경우 종료 이전꺼를 가져옴
	For each tplNodes in cTmpl
	
		if i>=needcnt then exit for	'//모자란 이미지수 만큼만 뿌린다
			
		'변수 저장
		imgurl		= tplNodes.getElementsByTagName("imgurl").item(0).text
		imglink		= tplNodes.getElementsByTagName("imglink").item(0).text
		startdate	= CDate(replace(tplNodes.getElementsByTagName("startdate").item(0).text, ",", "-"))
		enddate		= CDate(replace(tplNodes.getElementsByTagName("enddate").item(0).text, ",", "-"))
			
		'//종료 인것중에, 위에서 노출시킨거 빼고 뿌린다
		If CtrlDate >= startdate AND instr(existsidx,idx)=0 Then
			If imglink <> "" Then
%>
							<p class="swiper-slide"><a href="<%= imglink %>"><img src="<%= imgurl%>" alt="기획전<%= i+1 %>" /></a></p>
<%
			Else
%>
							<p class="swiper-slide"><img src="<%= imgurl%>" alt="기획전<%= i+1 %>" /></p>
<%
			End If
			i = i + 1
		End If
	Next
	Set cTmpl = Nothing
End If
on Error Goto 0
%>