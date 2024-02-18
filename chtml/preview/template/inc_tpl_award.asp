<%
	'// [E Type] 베스트 어워드
	'# 파일이 없으면
	if (application("Svr_Info")="137" or application("Svr_Info")="082" or application("Svr_Info")="Dev") then
		Set fso = CreateObject("Scripting.FileSystemObject")
		if not(fso.FileExists(server.MapPath(sFolder & "sub_award.xml"))) or dateDiff("h",Application("chk_main_award_update"),now())>0 then
			Server.Execute("/chtml/preview/make_main_awardXML.asp")
		end if
		set fso = Nothing
	end if

	'현재시각 표시
	if dateDiff("d",selFullTime,date)=0 then
		mainModiDate = Application("chk_main_award_update")
		strTime = Num2Str(chkIIF(hour(mainModiDate)>12,hour(mainModiDate)-12,hour(mainModiDate)),2,"0","R") & ":00 " & chkIIF(hour(mainModiDate)>=12,"PM","AM")
	end if

	on Error Resume Next
	fileCont = ""
	'서브 파일 로드
	sMainXmlUrl = server.MapPath(sFolder & "sub_award.xml")	'// 접수 파일
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
				<p class="tit"><span class="box1 bgWt rdBox2 inner"><%=chkIIF(mainTitle="","텐바이텐의 인기상품",mainTitle)%></span><em class="elmBg"></em></p>
				<p class="time"><span><%=strTime%></span></p>
			</h2>
			<div class="box1 bgWt tMar10">
		<% else %>
			<div class="box1 bgWt">
		<% end if %>
				<div class="templateD">
					<table>
						<colgroup><col width="10%" /><col width="65px" /><col width="" /><col width="20%" /></colgroup>
						<%
							i = 1
							for each subNodes in cSub
						%>
						<tr onclick="location.href='/category/category_itemPrd.asp?itemid=<%=subNodes.getElementsByTagName("itemid").item(0).text%>';">
							<td><span class="ftBasic b cAaa"><%=i%></span></td>
							<td><img src="<%=subNodes.getElementsByTagName("itemImg200").item(0).text%>" alt="<%=subNodes.getElementsByTagName("itemname").item(0).text%>" style="width:65px;" /></td>
							<td class="lt">
								<p class="ftMid"><%=subNodes.getElementsByTagName("itemname").item(0).text%></p>
								<p class="ftMidSm cAaa tPad05"><%=subNodes.getElementsByTagName("cateLarge").item(0).text%> &gt; <br /><%=subNodes.getElementsByTagName("cateMid").item(0).text%></p>
							</td>
							<td>
							<%
								if subNodes.getElementsByTagName("rank").item(0).text>"0" then
									Response.Write "<p class=""elmBg bestUp"">" & subNodes.getElementsByTagName("rank").item(0).text & "</p>"
								elseif subNodes.getElementsByTagName("rank").item(0).text<"0" then
									Response.Write "<p class=""elmBg bestDown"">" & subNodes.getElementsByTagName("rank").item(0).text * -1 & "</p>"
								else
									Response.Write "<p class=""elmBg bestMid"">0</p>"
								end if
							%>
							</td>
						</tr>
						<%
								i=i+1
							next
						%>
					</table>
					<div class="moreB"><a href="/award/awardItem.asp"><span class="elmBg">MORE</span></a></div>
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