<%
	'// [D Type] 실시간 추천상품

	on Error Resume Next
	fileCont = ""
	'서브 파일 로드
	sMainXmlUrl = server.MapPath(sFolder & "sub_" & mainIdx & ".xml")	'// 접수 파일
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
				<div class="templateJ">
					<div class="swiper-main">
						<div id="swpTpl<%=mainIdx%>" class="swiper-container swiper3">
							<div class="swiper-wrapper">
								<div class="swiper-slide">
									<div class="thumbList2">
										<ul>
								<%
									i = 1
									for each subNodes in cSub
										'상품명이 있는 경우
										if subNodes.getElementsByTagName("itemname").item(0).text<>"" then
								%>
											<li>
												<a href="/category/category_itemPrd.asp?itemid=<%=subNodes.getElementsByTagName("itemid").item(0).text%>">
												<p><img src="<%=subNodes.getElementsByTagName("itemImg400").item(0).text%>" alt="<%=replace(subNodes.getElementsByTagName("itemname").item(0).text,"""","")%>" style="width:100%;" /></p>
												<span><%=subNodes.getElementsByTagName("itemname").item(0).text%></span>
												</a>
											</li>
								<%
											'그룹구분
											if (i mod 3)=0 and i<cSub.length then
												Response.write "</ul></div></div><div class=""swiper-slide""><div class=""thumbList2""><ul>"
											end if
											i=i+1
										end if
									next
								%>
										</ul>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div id="pgTpl<%=mainIdx%>" class="slidePage pagination pagination3"></div>
				</div>
			</div>
		</section>
		<script type="text/javascript">
		$(function(){
			<% if i>4 then %>
			swpTpl<%=mainIdx%> = new Swiper('#swpTpl<%=mainIdx%>', {
				pagination : '#pgTpl<%=mainIdx%>',
				loop:true
			});
			<% end if %>
		});
		</script>
	</div>
	<hr />
<%
		Set cSub = Nothing
	else
		tmpOrder = tmpOrder-1
	end if
%>