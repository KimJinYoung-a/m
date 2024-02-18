<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
response.charset = "utf-8"
Dim sFolder, mainFile
Dim fso, sMainXmlUrl, oFile, fileCont
Dim xmlDOM, CtrlDate, i
Dim image , itemname , itemid , startdate , enddate 
Dim sellCash , orgPrice , sailYN , couponYn , couponvalue , LimitYn , coupontype , itemurlmo
Dim dealtitle , gubun1 , gubun2 , itemurl
sFolder = "/chtml/main/xml/main_banner/"
mainFile = "main_todaydeal.xml"
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
<section class="todayDeal">
	<span class="icoTime"></span>
<%
	For each tplNodes in cTmpl
		image				= tplNodes.getElementsByTagName("basicimage").item(0).text
		itemname			= tplNodes.getElementsByTagName("itemname").item(0).text
		itemid				= tplNodes.getElementsByTagName("itemid").item(0).text
		startdate			= CDate(replace(tplNodes.getElementsByTagName("startdate").item(0).text, ",", "-"))
		enddate				= CDate(replace(tplNodes.getElementsByTagName("enddate").item(0).text, ",", "-"))
		dealtitle			= tplNodes.getElementsByTagName("dealtitle").item(0).Text
		gubun1				= tplNodes.getElementsByTagName("gubun1").item(0).Text
		gubun2				= tplNodes.getElementsByTagName("gubun2").item(0).Text
		itemurl				= tplNodes.getElementsByTagName("itemurl").item(0).Text
						
		sellCash			= tplNodes.getElementsByTagName("sellCash").item(0).text
		orgPrice			= tplNodes.getElementsByTagName("orgPrice").item(0).text
		sailYN				= tplNodes.getElementsByTagName("sailYN").item(0).text
		couponYn			= tplNodes.getElementsByTagName("itemcouponYn").item(0).text
		couponvalue			= tplNodes.getElementsByTagName("itemcouponvalue").item(0).text
		LimitYn				= tplNodes.getElementsByTagName("LimitYn").item(0).text
		coupontype			= tplNodes.getElementsByTagName("itemcoupontype").item(0).text
		itemurlmo			= tplNodes.getElementsByTagName("itemurlmo").item(0).text

		If CDate(CtrlDate) >= CDate(startdate) AND CDate(CtrlDate) <= CDate(enddate) Then
%>
		<h2><% If gubun1 = "1" Then %>TIME SALE<% End If %><% If gubun1 = "2" Then %>WISH No.1<% End If %><% If gubun1 = "3" Then %>ISSUE ITEM<% End If %></h2>
		<p class="fs12"><%=dealtitle%></p>
		<div class="dealPdt" onclick="fnAPPpopupProduct_URL('<%=itemurl%>');">
			<div class="pic">
				<img src="<%= getThumbImgFromURL(image,420,420,"true","false") %>" alt="<%=itemname%>" />
			</div>
			<% If gubun1 = "3" Then %>
				<% If gubun2 = "1" Then %><span class="limit">한정<br />재입고</span><% End If %>
				<% If gubun2 = "2" Then %><span class="limit">HOT<br />ITEM</span><% End If %>
				<% If gubun2 = "3" Then %><span class="limit">SPECIAL<br />EDITION</span><% End If %>
				<% If gubun2 = "4" Then %><span class="limit">10X10<br />ONLY</span><% End If %>
			<% Else %>
				<% If cInt(datediff("h", now() , enddate)) < 1 Then %>
				<span class="limit">마감<br />임박!</span>
				<% Else %>
				<span class="limit"><%=cInt(datediff("h", now() , enddate))%>시간<br />남음</span>
				<% End If %>
			<% End If %>
		</div>
		<div class="pdtCont">
			<p class="pName"><%=itemname%></p>
			<% If sailYN = "N" and couponYn = "N" then %>
			<p class="pPrice"><%=formatNumber(orgPrice,0)%>원 </p>
			<% End If 
				 If sailYN = "Y" And couponYn = "N" Then %>
			<p class="pPrice"><%=formatNumber(sellCash,0)%>원 <span class="cRd1"><% If CLng((orgPrice-sellCash)/orgPrice*100)> 0 Then  %>[<%=CLng((orgPrice-sellCash)/orgPrice*100)%>%]<% End If %></span></p>							
			<% End If 
				if couponYn = "Y" And couponvalue>0 then%>
			<p class="pPrice">
				<%If coupontype = "1" Then
					response.write formatNumber(sellCash - CLng(couponvalue*sellCash/100),0) & "원"
					response.write " <span class=""cGr1"">[" & couponvalue & "%]</span>"
				ElseIf coupontype = "2" Then
					response.write formatNumber(sellCash - couponvalue,0) & "원"
					response.write " <span class=""cGr1"">[" & couponvalue & "원 할인]</span>"
				ElseIf coupontype = "3" Then
					response.write formatNumber(sellCash,0) & "원"
					response.write " <span class=""cGr1"">[무료배송]</span>"
				Else
					response.write formatNumber(sellCash,0) & "원"
				End If%>
			</p>
			<% End If %>
		</div>
<%
			i = i + 1
		End If
		if i>=1 then exit for	'//1개씩만 노출 이상이면 강종 대신 if문에서 날짜 체크함 
	Next
%>
</section>
<%
	Set cTmpl = Nothing
End If
on Error Goto 0
%>