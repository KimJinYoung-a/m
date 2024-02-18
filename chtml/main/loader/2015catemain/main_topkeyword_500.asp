<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
response.charset = "utf-8"
Dim sFolder, mainFile
Dim fso, sMainXmlUrl, oFile, fileCont, vHotKeyImg
Dim xmlDOM, CtrlDate, i
Dim kwimg , kword , ktitle , kcontents , kurl_mo , kurl_app , appdiv , appcate , startdate , enddate , itemid , itemname , basicimage
Dim existscnt , needcnt , existsidx
Dim gaParam : gaParam = "&gaparam=catemain_b" '//GA 체크 변수

sFolder = "/chtml/main/xml/main_banner/"
mainFile = "500topkeyword.xml"
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

%>
	<ul>
<%

	For each tplNodes in cTmpl
		kwimg				= tplNodes.getElementsByTagName("kwimg").item(0).text
		kword				= tplNodes.getElementsByTagName("kword").item(0).text
		ktitle				= tplNodes.getElementsByTagName("ktitle").item(0).text
		kcontents			= tplNodes.getElementsByTagName("kcontents").item(0).text
		kurl_mo				= tplNodes.getElementsByTagName("kurl_mo").item(0).text
		kurl_app			= tplNodes.getElementsByTagName("kurl_app").item(0).text
		appdiv				= tplNodes.getElementsByTagName("appdiv").item(0).text
		appcate				= tplNodes.getElementsByTagName("appcate").item(0).Text
		startdate			= tplNodes.getElementsByTagName("startdate").item(0).text
		enddate				= tplNodes.getElementsByTagName("enddate").item(0).text
		itemid				= tplNodes.getElementsByTagName("itemid").item(0).text
		itemname			= tplNodes.getElementsByTagName("itemname").item(0).text
		basicimage			= tplNodes.getElementsByTagName("basicimage").item(0).text
		
		'### 무조건 이미지가 1순위, 이미지가 없는 경우 상품이미지
		vHotKeyImg = kwimg
		If vHotKeyImg = (staticImgUrl & "/mobile/topkeyword") Then
			vHotKeyImg = basicimage
		End If

		If CDate(CtrlDate) >= CDate(startdate) AND CDate(CtrlDate) <= CDate(enddate) Then
			If i > 3 Then
				Exit for
			End If 
%>
		<li>
			<a href="<%=kurl_mo%><%=gaParam%>">
				<div class="pPhoto"><img src="<%=getThumbImgFromURL(vHotKeyImg,300,300,"true","false")%>" alt="<%=ktitle%>" /></div>
				<p><span>#<%=ktitle%></span></p>
			</a>
		</li>
<%
			i = i + 1

			existsidx = existsidx & chkIIF(existsidx<>"",",","") & kurl_mo		'/등록된 이미지의 IDX를 저장
		End If
	Next

	existscnt = ubound(split(existsidx,","))	'//위에서 등록된 이미지수
	needcnt = 1 - (existscnt-1)					'//모자란 이미지수

	i = 0
	'//만약 등록을 안했을경우 종료 이전꺼를 가져옴
	For each tplNodes in cTmpl

		if i > needcnt then exit for	'//모자란 이미지수 만큼만 뿌린다
		
		kwimg				= tplNodes.getElementsByTagName("kwimg").item(0).text
		kword				= tplNodes.getElementsByTagName("kword").item(0).text
		ktitle				= tplNodes.getElementsByTagName("ktitle").item(0).text
		kcontents			= tplNodes.getElementsByTagName("kcontents").item(0).text
		kurl_mo				= tplNodes.getElementsByTagName("kurl_mo").item(0).text
		kurl_app			= tplNodes.getElementsByTagName("kurl_app").item(0).text
		appdiv				= tplNodes.getElementsByTagName("appdiv").item(0).text
		appcate				= tplNodes.getElementsByTagName("appcate").item(0).Text
		startdate			= tplNodes.getElementsByTagName("startdate").item(0).text
		enddate				= tplNodes.getElementsByTagName("enddate").item(0).text
		itemid				= tplNodes.getElementsByTagName("itemid").item(0).text
		itemname			= tplNodes.getElementsByTagName("itemname").item(0).text
		basicimage			= tplNodes.getElementsByTagName("basicimage").item(0).text
		
		'### 무조건 이미지가 1순위, 이미지가 없는 경우 상품이미지
		vHotKeyImg = kwimg
		If vHotKeyImg = (staticImgUrl & "/mobile/topkeyword") Then
			vHotKeyImg = basicimage
		End If

		If CDate(CtrlDate) >= CDate(startdate) AND instr(existsidx,kurl_mo)=0 Then
%>
		<li>
			<a href="<%=kurl_mo%><%=gaParam%>">
				<div class="pPhoto"><img src="<%=getThumbImgFromURL(vHotKeyImg,300,300,"true","false")%>" alt="<%=ktitle%>" /></div>
				<p><span>#<%=ktitle%></span></p>
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
on Error Goto 0
%>