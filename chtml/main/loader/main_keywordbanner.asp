<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
response.charset = "utf-8"
Dim sFolder, mainFile
Dim fso, sMainXmlUrl, oFile, fileCont
Dim xmlDOM, CtrlDate
Dim keywordtype, imagepath, keyword, linkpath, orderno
sFolder = "/chtml/main/xml/keywordbanner/"
mainFile = "main_keywordbanner.xml"
CtrlDate = Date()
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
	Set xmlDOM = Server.CreateObject("MSXML2.DomDocument.3.0")
		xmlDOM.async = False
		xmlDOM.LoadXML fileCont

		Dim keyword0, imagepath0, linkpath0, imgalt0
		Dim keyword1, imagepath1, linkpath1, imgalt1
		Dim keyword2, imagepath2, linkpath2, imgalt2
		Dim keyword3, imagepath3, linkpath3, imgalt3
		Dim keyword4, imagepath4, linkpath4, imgalt4
		Dim keyword5, imagepath5, linkpath5, imgalt5
		Dim keyword6, imagepath6, linkpath6, imgalt6
		keyword0	= xmlDOM.getElementsByTagName("keyword0").item(0).text
		imagepath0	= xmlDOM.getElementsByTagName("imagepath0").item(0).text
		linkpath0	= xmlDOM.getElementsByTagName("linkpath0").item(0).text
		imgalt0		= xmlDOM.getElementsByTagName("imgalt0").item(0).text
	
		keyword1	= xmlDOM.getElementsByTagName("keyword1").item(0).text
		imagepath1	= xmlDOM.getElementsByTagName("imagepath1").item(0).text
		linkpath1	= xmlDOM.getElementsByTagName("linkpath1").item(0).text
		imgalt1		= xmlDOM.getElementsByTagName("imgalt1").item(0).text
	
		keyword2	= xmlDOM.getElementsByTagName("keyword2").item(0).text
		imagepath2	= xmlDOM.getElementsByTagName("imagepath2").item(0).text
		linkpath2	= xmlDOM.getElementsByTagName("linkpath2").item(0).text
		imgalt2		= xmlDOM.getElementsByTagName("imgalt2").item(0).text
	
		keyword3	= xmlDOM.getElementsByTagName("keyword3").item(0).text
		imagepath3	= xmlDOM.getElementsByTagName("imagepath3").item(0).text
		linkpath3	= xmlDOM.getElementsByTagName("linkpath3").item(0).text
		imgalt3		= xmlDOM.getElementsByTagName("imgalt3").item(0).text
	
		keyword4	= xmlDOM.getElementsByTagName("keyword4").item(0).text
		imagepath4	= xmlDOM.getElementsByTagName("imagepath4").item(0).text
		linkpath4	= xmlDOM.getElementsByTagName("linkpath4").item(0).text
		imgalt4		= xmlDOM.getElementsByTagName("imgalt4").item(0).text
	
		keyword5	= xmlDOM.getElementsByTagName("keyword5").item(0).text
		imagepath5	= xmlDOM.getElementsByTagName("imagepath5").item(0).text
		linkpath5	= xmlDOM.getElementsByTagName("linkpath5").item(0).text
		imgalt5		= xmlDOM.getElementsByTagName("imgalt5").item(0).text
		
		keyword6	= xmlDOM.getElementsByTagName("keyword6").item(0).text
		imagepath6	= xmlDOM.getElementsByTagName("imagepath6").item(0).text
		linkpath6	= xmlDOM.getElementsByTagName("linkpath6").item(0).text
		imgalt6		= xmlDOM.getElementsByTagName("imgalt6").item(0).text
	Set xmlDOM = Nothing
End If
%>
					<table cellspacing="0" cellpadding="0" border="0" width="100%">
						<tbody>
							<tr>
								<td><a href="<%= linkpath0 %>"><img src="<%= imagepath0 %>" alt="<%= imgalt0 %>" /></a></td>
								<td>
									<table cellspacing="0" cellpadding="0" border="0" width="100%">
									<thead>
										<tr>
											<th>
												<div>
													<p><%= keyword3 %></p>
													<img src="http://fiximage.10x10.co.kr/m/2013/common/keyword_2nd_bg1.png" alt="keywordSubject" />
												</div>
											</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td>
												<div>
													<p><span>01.</span> <a href="<%= linkpath4 %>"><%= keyword4 %></a></p>
													<img src="http://fiximage.10x10.co.kr/m/2013/common/keyword_2nd_bg2.png" alt="keyword01" />
												</div>
											</td>
										</tr>
										<tr>
											<td>
												<div>
													<p><span>02.</span> <a href="<%= linkpath5 %>"><%= keyword5 %></a></p>
													<img src="http://fiximage.10x10.co.kr/m/2013/common/keyword_2nd_bg2.png" alt="keyword02" />
												</div>
											</td>
										</tr>
										<tr>
											<td>
												<div>
													<p><span>03.</span> <a href="<%= linkpath6 %>"><%= keyword6 %></a></p>
													<img src="http://fiximage.10x10.co.kr/m/2013/common/keyword_2nd_bg2.png" alt="keyword03" />
												</div>
											</td>
										</tr>
									</tbody>
									</table>
								</td>
							</tr>
							<tr>
								<td><a href="<%= linkpath1 %>"><img src="<%= imagepath1 %>" alt="<%= imgalt1 %>" /></a></td>
								<td><a href="<%= linkpath2 %>"><img src="<%= imagepath2 %>" alt="<%= imgalt2 %>" /></a></td>
							</tr>
						</tbody>
					</table>
<%
on Error Goto 0
%>