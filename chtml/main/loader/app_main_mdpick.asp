<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'#######################################################
' Discription : app_mdpick
' History : 2013.12.13 이종화 생성
'#######################################################
%>
<%
response.charset = "utf-8"
Dim sFolder, mainFile
Dim fso, sMainXmlUrl, oFile, fileCont
Dim xmlDOM
Dim gubun
Dim ctitle , cper , cnum
Dim image , itemname , itemid , startdate , enddate 
Dim sellCash , orgPrice , sailYN , couponYn , couponvalue , LimitYn , coupontype , newyn , limitno , limitdispyn
Dim ndate , refip , CtrlDate
Dim maintitle , subtitle , CtrlTime

sFolder = "/chtml/main/xml/mdpick/" & Replace(Date(),"-","") &"/"
CtrlDate = Date()
CtrlTime = hour(time)
mainFile = "main_mdpick_"&CtrlDate&".xml"

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

	maintitle	= xmlDOM.getElementsByTagName("maintitle").item(0).text
	subtitle	 	= xmlDOM.getElementsByTagName("subtitle").item(0).text

	'// 하위 항목이 여러개일 때
	Dim cTmpl, tplNodes
	Set cTmpl = xmlDOM.getElementsByTagName("item")
	Set xmlDOM = Nothing


%>
		<ul class="mdPickList">
<%
	For each tplNodes in cTmpl
		image				= tplNodes.getElementsByTagName("basicimage").item(0).text
		itemname			= tplNodes.getElementsByTagName("itemname").item(0).text
		itemid				= tplNodes.getElementsByTagName("itemid").item(0).text

		sellCash			= tplNodes.getElementsByTagName("sellCash").item(0).text
		orgPrice			= tplNodes.getElementsByTagName("orgPrice").item(0).text
		sailYN				= tplNodes.getElementsByTagName("sailYN").item(0).text
		couponYn			= tplNodes.getElementsByTagName("itemcouponYn").item(0).text
		couponvalue			= tplNodes.getElementsByTagName("itemcouponvalue").item(0).text
		LimitYn				= tplNodes.getElementsByTagName("LimitYn").item(0).text
		coupontype			= tplNodes.getElementsByTagName("itemcoupontype").item(0).text
		newyn				= tplNodes.getElementsByTagName("newyn").item(0).text
		limitno				= tplNodes.getElementsByTagName("limitno").item(0).text
		limitdispyn			= tplNodes.getElementsByTagName("limitdispyn").item(0).Text
		
		If CDate(CtrlTime) >= CDate(tplNodes.getElementsByTagName("starttime").item(0).text) AND CDate(CtrlTime) <= CDate(tplNodes.getElementsByTagName("endtime").item(0).text) Then
%>
			<li>
				<a href="/apps/appcom/wish/webview/category/category_itemPrd.asp?itemid=<%=itemid%>">
					<div class="picArea">
						<p class="<% If LimitYn="Y" And limitno <= 10 And limitdispyn = "Y" Then %>limitTag<% Else %><% If (sailYN = "Y" And newyn = "Y") Or (sailYN = "Y" And newyn = "N") Then %>tag saleTag<% ElseIf newyn = "Y" And sailYN="N" then %>tag newTag<% End If %><% End If %>"><%=chkiif(LimitYn="Y" And limitno <= 10 And limitdispyn = "Y" ,"HURRY UP!","")%></p>
						<img src="<%= getThumbImgFromURL(image,400,400,"true","false") %>" alt="<%=itemname%>" />
					</div>
					<p class="mdPickPdt"><%=itemname%></p>
					<% If sailYN = "N" and couponYn = "N" then %>
					<p class="mdPickPrice"><%=formatNumber(orgPrice,0)%>원 </p>
					<% End If 
						 If sailYN = "Y" and couponYn = "N" Then %>
					<p class="mdPickPrice"><%=formatNumber(sellCash,0)%>원 <span class="cRed"><% If CLng((orgPrice-sellCash)/orgPrice*100)> 0 Then  %>[<%=CLng((orgPrice-sellCash)/orgPrice*100)%>%]<% End If %></span></p>							
					<% End If 
						if couponYn = "Y" And couponvalue>0 then%>
					<p class="mdPickPrice">
						<%If coupontype = "1" Then
							response.write formatNumber(sellCash - CLng(couponvalue*sellCash/100),0)
						ElseIf coupontype = "2" Then
							response.write formatNumber(sellCash - couponvalue,0)
						ElseIf coupontype = "3" Then
							response.write formatNumber(sellCash,0)
						Else
							response.write formatNumber(sellCash,0)
						End If%>원 <span class="cGrn">[<%If coupontype = "1" Then
							response.write CStr(couponvalue) & "%"
						ElseIf coupontype = "2" Then
							response.write formatNumber(couponvalue,0) & "원 할인"
						ElseIf coupontype = "3" Then
							response.write "무료배송"
						Else
							response.write couponvalue
						End If %>]
					</p>
					<% End If %>
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