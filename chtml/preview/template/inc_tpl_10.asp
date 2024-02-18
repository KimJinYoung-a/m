<%
	'// [G Type] 동영상 이벤트

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
		<%
			i = 1
			for each subNodes in cSub
				'비디오 링크가 있는 경우
				if subNodes.getElementsByTagName("video").item(0).text<>"" then
		%>
		<% if mainTitleYn="Y" then %>
			<h2>
				<p class="tit"><span class="box1 bgWt rdBox2 inner">
					<%
						if subNodes.getElementsByTagName("text1").item(0).text<>"" then
							Response.Write subNodes.getElementsByTagName("text1").item(0).text
						else
							Response.Write mainTitle
						end if
					%>
					<% if subNodes.getElementsByTagName("link").item(0).text<>"" then %><br /><a href="<%=subNodes.getElementsByTagName("link").item(0).text%>" class="cC40">참여하기&gt;&gt;</a><% end if %>
				</span><em class="elmBg"></em></p>
				<p class="time"><span><%=strTime%></span></p>
			</h2>
			<div class="box1 bgWt tMar10">
		<% else %>
			<div class="box1 bgWt">
		<% end if %>
				<% if chkBlind then %><div class="blindWrap"><div><span></span></div></div><% end if %>
				<div class="templateG">
					<iframe width="100%" height="240px" src="<%=subNodes.getElementsByTagName("video").item(0).text%>" frameborder="0" allowfullscreen></iframe>
				</div>
			</div>
		<%
				i=i+1
				end if
				if i>1 then Exit For	'1개 표시
			next
		%>
		</section>
	</div>
	<hr />
<%
		Set cSub = Nothing
	else
		tmpOrder = tmpOrder-1
	end if
%>