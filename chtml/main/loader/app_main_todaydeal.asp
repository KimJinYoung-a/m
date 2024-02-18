<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
response.charset = "utf-8"
Dim sFolder, mainFile
Dim fso, sMainXmlUrl, oFile, fileCont
Dim xmlDOM, CtrlDate, i
Dim image , itemname , itemid , startdate , enddate 
Dim sellCash , orgPrice , sailYN , couponYn , couponvalue , LimitYn , coupontype
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

		If CDate(CtrlDate) >= CDate(startdate) AND CDate(CtrlDate) <= CDate(enddate) Then
%>
		<h2><% If gubun1 = "1" Then %>TIME SALE<% End If %><% If gubun1 = "2" Then %>WISH No.1<% End If %><% If gubun1 = "3" Then %>ISSUE ITEM<% End If %></h2>
		<h3><%=dealtitle%></h3>
		<div class="todayWrap">
			<p class="tag"><% If gubun1 = "3" Then %><% If gubun2 = "1" Then %>한정재입고<% End If %><% If gubun2 = "2" Then %>HOT ITEM<% End If %><% If gubun2 = "3" Then %>Special Edition<% End If %><% If gubun2 = "4" Then %>10x10 ONLY<% End If %><% Else %><% If cInt(datediff("h", now() , enddate)) < 1 Then %>마감임박!<% Else %><%=cInt(datediff("h", now() , enddate))%>시간 남음<% End If %><% End If %></p>
			<a href="<%=itemurl%>">
				<div class="thumbNail"><img src="<%= getThumbImgFromURL(image,420,420,"true","false") %>" alt="<%=itemname%>" /></div>
				<p class="todayPdt"><%=itemname%></p>
				<% If sailYN = "N" and couponYn = "N" then %>
				<p class="todayPrice"><%=formatNumber(orgPrice,0)%>원 </p>
				<% End If 
					 If sailYN = "Y" and couponYn = "N" Then %>
				<p class="todayPrice"><%=formatNumber(sellCash,0)%>원 <span class="cRed"><% If CLng((orgPrice-sellCash)/orgPrice*100)> 0 Then  %>[<%=CLng((orgPrice-sellCash)/orgPrice*100)%>%]<% End If %></span></p>							
				<% End If 
					if couponYn = "Y" And couponvalue>0 then%>
				<p class="todayPrice">
					<%If coupontype = "1" Then
						response.write formatNumber(sellCash - CLng(couponvalue*sellCash/100),0)& "원"
						response.write " <span class=""cGrn"">[" & couponvalue & "%]</span>"
					ElseIf coupontype = "2" Then
						response.write formatNumber(sellCash - couponvalue,0)& "원"
						response.write " <span class=""cGrn"">[" & couponvalue & "원 할인]</span>"
					ElseIf coupontype = "3" Then
						response.write formatNumber(sellCash,0)& "원"
						response.write " <span class=""cGrn"">[무료배송]</span>"
					Else
						response.write formatNumber(sellCash,0)& "원"
					End If%>
				</p>
				<% End If %>
			</a>
		</div>
<%
			i = i + 1
		End If
		if i>=1 then exit for	'//1개씩만 노출 이상이면 강종 대신 if문에서 날짜 체크함 
	Next

	Set cTmpl = Nothing
End If
on Error Goto 0
%>