<%
	'// [E Type] 디자인 핑거스
	'# 파일이 없거나 존재하더라도 하루에 한번 신규 XML 생성!!(로드밸런싱 1차 서버에서만, 1시간에 한번 생성)
	''Application("chk_main_fingers_update")="2008-12-12 05:00:00"
	if (application("Svr_Info")="137" or application("Svr_Info")="082" or application("Svr_Info")="Dev") then
		Set fso = CreateObject("Scripting.FileSystemObject")
		if not(fso.FileExists(server.MapPath(sFolder & "sub_fingers.xml"))) or dateDiff("h",Application("chk_main_fingers_update"),now())>1 then
			Server.Execute("/chtml/make_main_fingersXML.asp")
			if selDate=replace(date,"-","") then
				Application("chk_main_fingers_update")=now
			end if
		end if
		set fso = Nothing
	end if

	'현재시각 표시 없음
	strTime = ""


	on Error Resume Next
	fileCont = ""
	'서브 파일 로드
	sMainXmlUrl = server.MapPath(sFolder & "sub_fingers.xml")	'// 접수 파일
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
				<p class="tit"><span class="box1 bgWt rdBox2 inner"><%=chkIIF(mainTitle="","디자인 핑거스",mainTitle)%></span><em class="elmBg"></em></p>
				<p class="time"><span><%=strTime%></span></p>
			</h2>
			<div class="box1 bgWt tMar10">
		<% else %>
			<div class="box1 bgWt">
		<% end if %>
				<% if chkBlind then %><div class="blindWrap"><div><span></span></div></div><% end if %>
				<div class="templateI">
				<%
					i = 1
					for each subNodes in cSub
				%>
					<a href="/designfingers/fingers.asp?fingerid=<%=subNodes.getElementsByTagName("fid").item(0).text%>&sort=1">
					<div class="ftLt">
						<p class="ftSmall2">매주 2회의 새로운 즐거움</p>
						<p class="tMar05 c445fa7 ftBigMid b">DESIGN FINGERS</p>
						<p class="ftSmall2 tPad03 c888"><%=Replace(subNodes.getElementsByTagName("title").item(0).text,"""","")%></p>
					</div>
					<p class="ftRt"><img src="<%=subNodes.getElementsByTagName("image").item(0).text%>" alt="<%=Replace(subNodes.getElementsByTagName("title").item(0).text,"""","")%>" style="width:75px;" /></p>
					</a>
				<%
						i=i+1
						if i>1 then Exit For
					next
				%>
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