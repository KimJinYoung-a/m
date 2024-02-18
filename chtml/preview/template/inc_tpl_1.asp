<%
	'// [A Type] 키워드 이슈 #1 (복합)

	on Error Resume Next
	fileCont = ""
	'서브 파일 로드
	sMainXmlUrl = server.MapPath(sFolder & "sub_" & chkDt & "_" & mainIdx & ".xml")	'// 접수 파일
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
		Set cSub = xmlDOM.getElementsByTagName("item")
		Set xmlDOM = Nothing
%>
	<div class="<%=chkIIF((tmpOrder mod 2)=1,"timelineRt","timelineLt")%>">
		<section>
		<% if mainTitleYn="Y" then %>
			<h2>
				<p class="tit"><span class="box1 bgWt rdBox2 inner"><%=mainTitle%></span><em class="elmBg"></em></p>
				<p class="time"><span><%=strTime%></span></p>
			</h2>
			<div class="box1 bgWt tMar10">
		<% else %>
			<div class="box1 bgWt">
		<% end if %>
				<% if chkBlind then %><div class="blindWrap"><div><span></span></div></div><% end if %>
				<div class="templateA">
					<ul>
						<%
							i = 1
							for each subNodes in cSub
								'이미지가 있는 경우
								if subNodes.getElementsByTagName("image1").item(0).text<>"" then
						%>
						<li>
							<p><a href="<%=subNodes.getElementsByTagName("link").item(0).text%>"><img src="<%=subNodes.getElementsByTagName("image1").item(0).text%>" alt="<%=subNodes.getElementsByTagName("imgdesc").item(0).text%>" style="width:100%;" /></a></p>
						</li>
						<%
								i=i+1
								end if
								if i>1 then Exit For	'1개 표시
							next
						%>
						<li>
							<ul class="keywordList">
							<%
								i = 1
								for each subNodes in cSub
									'텍스트만 있는 경우
									if subNodes.getElementsByTagName("image1").item(0).text="" and subNodes.getElementsByTagName("text1").item(0).text<>"" then
							%>
								<li><a href="<%=subNodes.getElementsByTagName("link").item(0).text%>"><span><%=Num2Str(i,2,"0","4")%>.</span> <%=subNodes.getElementsByTagName("text1").item(0).text%></a></li>
							<%
									i=i+1
									end if
									if i>4 then Exit For	'4개 까지만 표시
								next
							%>
							</ul>
						</li>
						<%
							i = 1
							for each subNodes in cSub
								'이미지가 있는 경우
								if subNodes.getElementsByTagName("image1").item(0).text<>"" then
									if i>1 then
						%>
						<li>
							<p><a href="<%=subNodes.getElementsByTagName("link").item(0).text%>"><img src="<%=subNodes.getElementsByTagName("image1").item(0).text%>" alt="<%=subNodes.getElementsByTagName("imgdesc").item(0).text%>" style="width:100%;" /></a></p>
						</li>
						<%
									end if
								i=i+1
								end if
								if i>5 then Exit For	'5개 까지만 표시
							next
						%>
					</ul>
				</div>
			</div>
		</section>
	</div>
	<hr />
<%
		Set cSub = Nothing
	else
		tmpOrder = tmpOrder-1
	end if
%>