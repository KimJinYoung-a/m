<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/playing/playingCls.asp" -->
<%
	Dim cPl, i, intLoop, vVolArr, vCoArr, vStartDate, vState
	vStartDate = "getdate()"
	vState = "7"
	
	SET cPl = New CPlay
	cPl.FPageSize 		= 5
	cPl.FRectStartdate 	= vStartDate
	cPl.FRectState 		= vState
	
	'### m.midx, m.volnum, m.title, m.mo_bgcolor
	vVolArr = cPl.fnPlayMainVolList()
	
	
	strOGMeta = strOGMeta & "<meta property=""og:title"" content=""[텐바이텐] PLAYing"">" & vbCrLf
	strOGMeta = strOGMeta & "<meta property=""og:type"" content=""website"" />" & vbCrLf
	strOGMeta = strOGMeta & "<meta property=""og:url"" content=""http://m.10x10.co.kr/playing/"" />" & vbCrLf
	strOGMeta = strOGMeta & "<meta property=""og:image"" content=""http://webimage.10x10.co.kr/eventIMG/2016/74503/Plaing_th.jpg"">" & vbCrLf
	strOGMeta = strOGMeta & "<meta property=""og:description"" content=""[텐바이텐] PLAYing"">" & vbCrLf
	'strHeadTitleName = "PLAYing"
%>
<!-- #include virtual="/lib/inc/head.asp" -->
</head>
<body class="body-main">
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<div class="content playV16" id="contentArea">
				<article class="playMainV16">
					<h2><span><i>PLAY ing</i> 당신의 감성을 플레이하다</span></h2>
					<div class="listPlay">
						<%
						IF isArray(vVolArr) THEN
							For intLoop=0 To UBound(vVolArr,2)
						%>
							<section style="background-color:#<%=vVolArr(3,intLoop)%>;">
								<div class="hgroup">
									<h3>Vol.<%=vVolArr(1,intLoop)%></h3>
									<p class="date"><%=vVolArr(2,intLoop)%></p>
								</div>

								<ul>
									<%
									cPl.FRectIsMain = True
									cPl.FRectTop	= "100"
									cPl.FRectMIdx 	= vVolArr(0,intLoop)
									vCoArr = cPl.fnPlayMainCornerList()
									'### d.didx, d.title, d.cate, ca.catename, d.startdate, imgurl
									
									IF isArray(vCoArr) THEN
										For i=0 To UBound(vCoArr,2)
									%>
										<li class="<%=LCase(fnClassNameToCate(vCoArr(2,i)))%>">
											<a href="view.asp?didx=<%=vCoArr(0,i)%>">
												<%
												If DateDiff("d",vCoArr(4,i),Now()) < 4 Then	'### 오픈후 3일동안
													Response.Write "<span class=""label""><em>NEW</em></span>"
												End If
												
												If vCoArr(2,i) <> "5" Then	'### comma 제외
													Response.Write "<div class=""figure"">"
													Response.Write "	<img src=""" & vCoArr(5,i) & """ alt="""" />"
													If vCoArr(2,i) = "1" OR vCoArr(2,i) = "3" OR vCoArr(2,i) = "6" Then
														If vCoArr(2,i) = "3" Then
															Response.Write "<span class=""ico""><img src="""&vCoArr(7,i)&""" alt= """"/></span>"
														Else
															Response.Write "<span class=""ico""><img src=""http://fiximage.10x10.co.kr/m/2016/play/ico_pictogram_00"&vCoArr(2,i)&".png"" alt= """"/></span>"
														End If
													End If
													Response.Write "</div>"
												End If
												%>
												<p class="desc">
													<b><%=db2html(vCoArr(1,i))%></b>
													<span><%=fnPlayingCateVer2("topname",vCoArr(2,i))%></span>
												</p>
											</a>
										</li>
									<%
										Next
									End IF
									%>
								</ul>
							</section>
						<%
							Next
						End IF
						%>
					</div>
					<div class="btnMore">
						<a href="list.asp"><span>more</span></a>
					</div>
				</article>
			</div>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
			<!--div class="btnTouch">
				<a href="/">여기를 터치하면<br /> <b>'TODAY'</b>로 이동합니다</a>
			</div-->
		</div>
	</div>
</div>
</body>
</html>
<% SET cPl = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->