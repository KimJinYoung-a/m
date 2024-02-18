<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
response.charset = "utf-8"
Dim sFolder, mainFile
Dim fso, sMainXmlUrl, oFile, fileCont
Dim xmlDOM
Dim gubun
Dim ctitle , cper , cnum
Dim image , itemname , itemid , startdate , enddate 
Dim sellCash , orgPrice , sailYN , couponYn , couponvalue , LimitYn , coupontype
Dim ndate , refip , CtrlDate
Dim maintitle , subtitle

sFolder = "/chtml/main/xml/todaytheme/" & Replace(Date(),"-","") &"/"
CtrlDate = Date()
mainFile = "main_todaytheme_"&CtrlDate&".xml"

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
	<h2 class="todayHead"><%=maintitle%></h2>
	<div class="todayWrap">
		<h3 class="todayTit"><span></span><%=subtitle%></h3>
		<div class="goodsSwiper">
			<div class="swiper-container swiper3">
				<div class="swiper-wrapper">

<%
	For each tplNodes in cTmpl
		image				= tplNodes.getElementsByTagName("basicimage").item(0).text
		itemname			= tplNodes.getElementsByTagName("itemname").item(0).text
		itemid				= tplNodes.getElementsByTagName("itemid").item(0).text
		startdate			= CDate(replace(tplNodes.getElementsByTagName("startdate").item(0).text, ",", "-"))
		enddate			= CDate(replace(tplNodes.getElementsByTagName("enddate").item(0).text, ",", "-"))


		sellCash			= tplNodes.getElementsByTagName("sellCash").item(0).text
		orgPrice			= tplNodes.getElementsByTagName("orgPrice").item(0).text
		sailYN				= tplNodes.getElementsByTagName("sailYN").item(0).text
		couponYn			= tplNodes.getElementsByTagName("itemcouponYn").item(0).text
		couponvalue		= tplNodes.getElementsByTagName("itemcouponvalue").item(0).text
		LimitYn				= tplNodes.getElementsByTagName("LimitYn").item(0).text
		coupontype		= tplNodes.getElementsByTagName("itemcoupontype").item(0).text



%>
					<div class="swiper-slide">
						<a href="/category/category_itemPrd.asp?itemid=<%=itemid%>">
							<div class="thumbNail"><img src="<%=image%>" alt="<%=itemname%>" /></div>
							<strong class="name"><%=itemname%></strong>
							<% If sailYN = "N" and couponYn = "N" then %>
							<p class="price"><%=formatNumber(orgPrice,0)%>원 </p>
							<% End If 
								 If sailYN = "Y" Then %>
							<p class="price"><%=formatNumber(sellCash,0)%>원 <span class="cC40">[<%=CLng((orgPrice-sellCash)/orgPrice*100)%>%]</span></p>							
							<% End If 
								if couponYn = "Y" And couponvalue>0 then%>
							<p class="price"><%If coupontype = "1" Then
									response.write formatNumber(sellCash - CLng(couponvalue*sellCash/100),0)
								ElseIf coupontype = "2" Then
									response.write formatNumber(sellCash - couponvalue,0)
								ElseIf coupontype = "3" Then
									response.write formatNumber(sellCash,0)
								Else
									response.write formatNumber(sellCash,0)
								End If%>원 <span class="c2c9336">[<%If coupontype = "1" Then
									response.write CStr(couponvalue) & "%"
								ElseIf coupontype = "2" Then
									response.write formatNumber(couponvalue,0) & "원 할인"
								ElseIf coupontype = "3" Then
									response.write "무료배송"
								Else
									response.write couponvalue
								End If %>]</span></p>
							<% End If %>
						</a>
					</div>
<%
	Next
%>
				</div>
			</div>
			<a class="btnArrow arrow-left" href="">이전</a>
			<a class="btnArrow arrow-right" href="">다음</a>
		</div>
	</div>
<%
	Set cTmpl = Nothing
End If
on Error Goto 0
%>