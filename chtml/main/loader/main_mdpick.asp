<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
'#######################################################
' Discription : 모바일 메인 페이지 mdpick 로더
' History : 2013.12.13 한용민 생성
'#######################################################
%>
<%
	dim vRstCont, vXmlUrl, xmlDOM
	dim oFile, cSub, subNodes
	dim vItem(3), lp, i
	dim mx, my, startNo

	on Error Resume Next
	vRstCont = ""
	vXmlUrl = server.MapPath("/chtml/main/xml/mdpick/main_mdpick.xml")
	Set oFile = CreateObject("ADODB.Stream")
	With oFile
		.Charset = "UTF-8"
		.Type=2
		.mode=3
		.Open
		.loadfromfile vXmlUrl
		vRstCont=.readtext
		.Close
	End With
	Set oFile = Nothing

	If vRstCont<>"" Then
		Set xmlDOM = Server.CreateObject("MSXML2.DomDocument.3.0")
		xmlDOM.async = False
		xmlDOM.LoadXML vRstCont

		'// 하위 항목이 여러개일 때
		Set cSub = xmlDOM.getElementsByTagName("item")
		Set xmlDOM = Nothing
		
		lp = 0: i=0

		For each subNodes in cSub
			vItem(lp) = vItem(lp) & "<li>" & vbCrLf
			vItem(lp) = vItem(lp) & "	<div onclick=""location.href='/category/category_itemPrd.asp?itemid="&subNodes.getElementsByTagName("itemid").item(0).text&"'"">" & vbCrLf
			vItem(lp) = vItem(lp) & "		<p><img src="""&subNodes.getElementsByTagName("basicimage").item(0).text&""" alt="""&subNodes.getElementsByTagName("itemname").item(0).text&""" /></p>" & vbCrLf
			vItem(lp) = vItem(lp) & "		<span>"& chrbyte(subNodes.getElementsByTagName("itemname").item(0).text,"25","Y")&"</span>" & vbCrLf
			vItem(lp) = vItem(lp) & "	</div>" & vbCrLf
			vItem(lp) = vItem(lp) & "</li>" & vbCrLf
			
			i = i + 1
			if (i mod 6)=0 then lp = lp+1
		Next
		
		Set cSub = Nothing

		randomize
		startNo=int(Rnd*(lp))+1
%>
	<div class="swiper-slide">
		<ul class="mdpickList">
			<%=vItem(0)%>
		</ul>
	</div>
	<div class="swiper-slide">
		<ul class="mdpickList">
			<%=vItem(1)%>
		</ul>
	</div>
	<div class="swiper-slide">
		<ul class="mdpickList">
			<%=vItem(2)%>
		</ul>
	</div>	
<%
	End If

	on Error Goto 0
%>