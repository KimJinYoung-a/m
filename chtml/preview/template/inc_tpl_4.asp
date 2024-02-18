<%
	'// [D Type] 할인 및 신상품 #1 (큰사이즈 - ico : Today Hot)

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
				<div class="templateC">
					<div class="type1">
						<p class="moveBtn prevMove"><a href="#" id="btn1Tpl<%=mainIdx%>" class="elmBg arrow-left1">이전 내용</a></p>
						<p class="moveBtn nextMove"><a href="#" id="btn2Tpl<%=mainIdx%>" class="elmBg arrow-right1">다음 내용</a></p>
						<div class="swiper-main">
							<div id="swpTpl<%=mainIdx%>" class="swiper-container swiper1">
								<div class="swiper-wrapper">
								<%
									i = 1
									for each subNodes in cSub
										'상품코드와 가격정보가 있는 경우
										if subNodes.getElementsByTagName("itemid").item(0).text<>"" and subNodes.getElementsByTagName("orgPrice").item(0).text<>"" then
								%>
									<div class="swiper-slide">
										<p>
											<a href="/category/category_itemPrd.asp?itemid=<%=subNodes.getElementsByTagName("itemid").item(0).text%>">
												<% if mainIconCd="T" then %>
												<em><img src="http://fiximage.10x10.co.kr/m/2013/common/tag_todayhot.png" alt="TODAY HOT" style="width:80px;" /></em>
												<% end if %>
												<img src="<%=subNodes.getElementsByTagName("itemImg400").item(0).text%>" alt="<%=replace(subNodes.getElementsByTagName("itemname").item(0).text,"""","")%>" style="width:200px;" />
											</a>
										</p>
										<p><strong>판매가</strong><span><%=formatNumber(subNodes.getElementsByTagName("orgPrice").item(0).text,0)%> 원</span></p>
										<% if (subNodes.getElementsByTagName("saleYn").item(0).text="Y" or subNodes.getElementsByTagName("couponYn").item(0).text="Y") and (replace(subNodes.getElementsByTagName("salePer").item(0).text,"%","")>0) then %>
										<p><strong>할인판매가</strong><span class="cC40">[<%=subNodes.getElementsByTagName("salePer").item(0).text%>] <%=formatNumber(subNodes.getElementsByTagName("sellCash").item(0).text,0)%> 원</span></p>
										<% end if %>
									</div>
								<%
										i=i+1
										end if
									next
								%>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</section>
		<script type="text/javascript">
		$(function(){
			<% if i>2 then %>
			swpTpl<%=mainIdx%> = new Swiper('#swpTpl<%=mainIdx%>', {loop:true});
			$('#btn1Tpl<%=mainIdx%>').click(function(e) {
				e.preventDefault()
				swpTpl<%=mainIdx%>.swipePrev()
			});
			$('#btn2Tpl<%=mainIdx%>').click(function(e) {
				e.preventDefault()
				swpTpl<%=mainIdx%>.swipeNext()
			});
			<% else %>
			$('#btn1Tpl<%=mainIdx%>').hide();
			$('#btn2Tpl<%=mainIdx%>').hide();
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