<%
	'// [E Type] Just 1 Day

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
				<p class="tit"><span class="box1 bgWt rdBox2 inner"><%=chkIIF(mainTitle<>"",mainTitle,"하루하루의 즐거움")%></span><em class="elmBg"></em></p>
				<p class="time"><span><%=strTime%></span></p>
			</h2>
			<div class="box1 bgWt tMar10">
		<% else %>
			<div class="box1 bgWt">
		<% end if %>
				<% if chkBlind then %><div class="blindWrap"><div><span></span></div></div><% end if %>
				<div class="templateF">
					<%
						i = 1
						for each subNodes in cSub
							'상품코드가 있는 경우
							if subNodes.getElementsByTagName("itemid").item(0).text<>"" then
					%>
					<dl onclick="location.href='/category/category_itemPrd.asp?itemid=<%=subNodes.getElementsByTagName("itemid").item(0).text%>';">
						<dt>JUST <span class="cC40">1 DAY</span></dt>
						<dd>
						<%
							if Not(subNodes.getElementsByTagName("text1").item(0).text="") then
								Response.Write subNodes.getElementsByTagName("text1").item(0).text
							else
								Response.Write subNodes.getElementsByTagName("itemname").item(0).text
							end if
						%>
						</dd>
						<dd class="saleRate"><% if datediff("d",startDt,selFullTime)<=0 then %><p><%=subNodes.getElementsByTagName("text2").item(0).text%></p><% end if %></dd>
					</dl>
					<p><img src="<%=subNodes.getElementsByTagName("itemImg400").item(0).text%>" alt="<%=replace(subNodes.getElementsByTagName("itemname").item(0).text,"""","")%>" style="width:120px;" /></p>
					<%
							i=i+1
							end if
							if i>1 then Exit For	'1개만 표시
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