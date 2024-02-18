<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
response.charset = "utf-8"
Dim sFolder, mainFile
Dim fso, sMainXmlUrl, oFile, fileCont, vHotKeyImg
Dim xmlDOM, CtrlDate, i , i1 , i2
Dim pimg , gubun , title , subtitle , url_mo , url_app , appdiv , appcate , startdate , enddate , itemid , itemname , basicimage
Dim existscnt , needcnt , existsidx
sFolder = "/chtml/main/xml/main_banner/"
mainFile = "main_play.xml"
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
	i1 = 0

Function playname(v)
	Select Case v
	Case "1"
		Response.write "<strong>GROUND</strong>"
	Case "2"
		Response.write "<strong>STYLE+</strong>"
	Case "3"
		Response.write "<span>DESIGN</span><strong>FINGERS</strong>"
	Case "4"
		Response.write "<strong>T-EPISODE</strong>"
	Case "5"
		Response.write "<strong>GIFT</strong>"
	Case Else
		Response.write ""
	End Select
End Function

Function playcls(v)
	Select Case v
	Case "1"
		Response.write "pGround"
	Case "2"
		Response.write "pStyle"
	Case "3"
		Response.write "pFingers"
	Case "4"
		Response.write "pEpisode"
	Case "5"
		Response.write "pGift"
	Case Else
		Response.write ""
	End Select
End function
%>
	<section class="todayPlayV15">
		<h2 class="tit01"><span>LET'S 10X10</span></h2>
		<ul>
<%

	For each tplNodes in cTmpl
		pimg				= tplNodes.getElementsByTagName("pimg").item(0).text
		gubun				= tplNodes.getElementsByTagName("gubun").item(0).text
		title				= tplNodes.getElementsByTagName("title").item(0).text
		subtitle			= tplNodes.getElementsByTagName("subtitle").item(0).text
		url_mo				= tplNodes.getElementsByTagName("url_mo").item(0).text
		url_app				= tplNodes.getElementsByTagName("url_app").item(0).text
		appdiv				= tplNodes.getElementsByTagName("appdiv").item(0).text
		appcate				= tplNodes.getElementsByTagName("appcate").item(0).Text
		startdate			= tplNodes.getElementsByTagName("startdate").item(0).text
		enddate				= tplNodes.getElementsByTagName("enddate").item(0).Text
		
		'### 무조건 이미지가 1순위, 이미지가 없는 경우 상품이미지
		vHotKeyImg = pimg
		If vHotKeyImg = (staticImgUrl & "/mobile/play") Then
			vHotKeyImg = basicimage
		End If

		If CDate(CtrlDate) >= CDate(startdate) AND CDate(CtrlDate) <= CDate(enddate) Then
			If i > 2 Then
				Exit for
			End If 
%>
		<li class="<%=playcls(gubun)%>">
			<a href="" onclick="fnAPPpopupCustomUrl('<% If appdiv = "4" Then Response.write appcate Else Response.write url_app End If %>','<%=appdiv%>');return false;">
				<div class="pic"><img src="<%=vHotKeyImg%>" alt="<%=title%>" /></div>
				<div class="theme">
					<h2><%=playname(gubun)%></h2>
					<p><%=title%></p>
				</div>
			</a>
		</li>
<%
			i = i + 1
			i1 = i1 + 1
			existsidx = existsidx & chkIIF(existsidx<>"",",","") & url_mo		'/등록된 이미지의 IDX를 저장
		End If
	Next

	existscnt = ubound(split(existsidx,","))	'//위에서 등록된 이미지수
	needcnt = 1 - existscnt						'//모자란 이미지수

	i = 0
	i2 = 0
	'//만약 등록을 안했을경우 종료 이전꺼를 가져옴
	For each tplNodes in cTmpl

		if i > needcnt then exit for	'//모자란 이미지수 만큼만 뿌린다
		
		pimg				= tplNodes.getElementsByTagName("pimg").item(0).text
		gubun				= tplNodes.getElementsByTagName("gubun").item(0).text
		title				= tplNodes.getElementsByTagName("title").item(0).text
		subtitle			= tplNodes.getElementsByTagName("subtitle").item(0).text
		url_mo				= tplNodes.getElementsByTagName("url_mo").item(0).text
		url_app				= tplNodes.getElementsByTagName("url_app").item(0).text
		appdiv				= tplNodes.getElementsByTagName("appdiv").item(0).text
		appcate				= tplNodes.getElementsByTagName("appcate").item(0).Text
		startdate			= tplNodes.getElementsByTagName("startdate").item(0).text
		enddate				= tplNodes.getElementsByTagName("enddate").item(0).Text
		itemid				= tplNodes.getElementsByTagName("itemid").item(0).text
		itemname			= tplNodes.getElementsByTagName("itemname").item(0).text
		basicimage			= tplNodes.getElementsByTagName("basicimage").item(0).text
		
		'### 무조건 이미지가 1순위, 이미지가 없는 경우 상품이미지
		vHotKeyImg = pimg
		If vHotKeyImg = (staticImgUrl & "/mobile/play") Then
			vHotKeyImg = basicimage
		End If

		If CDate(CtrlDate) >= CDate(startdate) AND instr(existsidx,url_mo)=0 Then
%>
		<li class="<%=playcls(gubun)%>">
			<a href="" onclick="fnAPPpopupCustomUrl('<% If appdiv = "4" Then Response.write appcate Else Response.write url_app End If %>','<%=appdiv%>');return false;">
				<div class="pic"><img src="<%= getThumbImgFromURL(vHotKeyImg,400,400,"true","false") %>" alt="<%=title%>" /></div>
				<div class="theme">
					<h2><%=playname(gubun)%></h2>
					<p><%=title%></p>
				</div>
			</a>
		</li>
<%
			i = i + 1
			i2 = i2 + 1
		End If
	Next
%>
	</ul>
	<!--div class="playPagingV15"></div>
	<button class="btnNav prev" onclick="showThumb('prev'); return false;">이전</button>
	<button class="btnNav next" onclick="showThumb('next'); return false;">다음</button-->
</section>
<%
	Set cTmpl = Nothing
End If
on Error Goto 0

Dim renview

randomize
renview=int(Rnd*(i1+i2))
%>
<script>
$(function(){
	// play
	$('.todayPlayV15 li:nth-child(1)').addClass('bnr01');
	$('.todayPlayV15 li:nth-child(2)').addClass('bnr02');
	$('.todayPlayV15 li:nth-child(3)').addClass('bnr03');
});
</script>