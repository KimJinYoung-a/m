<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/commFunc.asp" -->
<%
response.charset = "utf-8"
Dim sFolder, mainFile, i
Dim fso, sMainXmlUrl, oFile, fileCont
Dim xmlDOM
Dim imgurl, linkurl, itemname, sellcash, salepro
sFolder = "/apps/appCom/between/chtml/xml/"
If fnGetUserInfo("sex") = "M" Then
	mainFile = "mainMdpickM.xml"
Else
	mainFile = "mainMdpickF.xml"
End If

on Error Resume Next
sMainXmlUrl = server.MapPath(sFolder & mainFile)	'// 접수 파일
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

	i = 0
	For each tplNodes in cTmpl
		imgurl		= tplNodes.getElementsByTagName("imgurl").item(0).text
		linkurl		= tplNodes.getElementsByTagName("linkurl").item(0).text
		itemname	= tplNodes.getElementsByTagName("itemname").item(0).text
		sellcash	= tplNodes.getElementsByTagName("sellcash").item(0).text
		salepro		= tplNodes.getElementsByTagName("salepro").item(0).text
%>
						<li>
							<div <%= ChkIIF(salepro <> "NotSale", "class='sale'", "") %> >
								<a href="/apps/appCom/between/category/category_itemPrd.asp?itemid=<%= linkurl %>">
									<p class="pdtPic"><img src="<%= imgurl %>" alt="<%= itemname %>" /></p>
									<p class="pdtName"><%= itemname %></p>
									<p class="price"><%= sellcash %>원</p>
								<% If salepro <> "NotSale" Then %>
									<p class="pdtTag saleRed"><%= salepro %></p>
								<% End If %>
								</a>
							</div>
						</li>
<%
	Next
End If
%>