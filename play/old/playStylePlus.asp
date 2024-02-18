<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  play
' History : 2014.10.23 한용민 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/classes/play/playCls.asp" -->
<%
Dim idx, i, contentsidx, playcode, arrlist
	idx = getNumeric(requestCheckVar(request("idx"),10))
	contentsidx = getNumeric(requestCheckVar(request("contentsidx"),10))

playcode = 2 '메뉴상단 번호를 지정

if idx="" then
	response.write "<script type='text/javascript'>alert('스타일플러스 번호가 없습니다.'); location.history.back();</script>"
	dbget.close() : response.end
end if
if contentsidx="" then
	response.write "<script type='text/javascript'>alert('스타일플러스 상세번호가 없습니다.'); location.history.back();</script>"
	dbget.close() : response.end
end if

dim oStylePlus
set oStylePlus = new CPlay
	oStylePlus.frectcontentsidx = contentsidx
	oStylePlus.FRectIdx = idx
	oStylePlus.FRectType = playcode
	oStylePlus.FRectUserID = getloginuserid
	oStylePlus.getplaystyleplus_one()

dim oStylePlusItem
Set oStylePlusItem = new CPlay
	oStylePlusItem.frectcontentsidx = contentsidx
	oStylePlusItem.FPageSize=50
	oStylePlusItem.FCurrPage=1
	oStylePlusItem.getplaystyleplusitem()

dim oplaydetail
set oplaydetail = new CPlay
	oplaydetail.FPageSize = 1
	oplaydetail.FRectIdx = idx
	oplaydetail.fnPlaydetail_one

If idx <> "" Then
	Call fnViewCountPlus(idx)
End If

%>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content styleP bgGry" id="contentArea">
				<% ' 수작업 영역 %>
				<div class="stylePCont">
					<%=oStylePlus.FOneItem.fstyle_html_m%>
				</div>

				<div class="playCont">
					<span class="type" onclick="location.href='/play/index.asp?type=<%= playcode %>'; return false;">STYLE +</span>
					<p class="tit"><strong><%= oplaydetail.FOneItem.ftitle %></strong></p>
					<p id="mywish<%=oStylePlus.FOneItem.fstyleidx%>" class="circleBox wishView <%=chkiif(oStylePlus.FOneItem.Fchkfav > 0 ,"wishActive","")%>" <% If getloginuserid <> "" Then %>onclick="TnAddPlaymywish('<%=playcode%>','<%=oStylePlus.FOneItem.fstyleidx%>','<%= oplaydetail.FOneItem.Fviewno %>');"<% Else %>onclick="jsChklogin_mobile('','<%=Server.URLencode(CurrURLQ())%>');"<% End If %>><span>찜하기</span></p>
				</div>
				
				<% if oStylePlusItem.fresultcount>0 then %>
					<div class="inner10">
						<div class="pdtListWrap">
							<ul class="pdtList">
								<% for i = 0 to oStylePlusItem.fresultcount -1 %>
								<li onclick="" <% if oStylePlusItem.FItemList(i).IsSoldOut then %>class='soldOut'<% end if %>>									
									<div class="pPhoto">
										<% if oStylePlusItem.FItemList(i).IsSoldOut then %><p><span><em>품절</em></span></p><% end if %>
										<img src="<%= oStylePlusItem.FItemList(i).FImageicon1 %>" onclick="TnGotoProduct('<%=oStylePlusItem.FItemList(i).FItemid%>'); return false;" alt="<%= chrbyte(oStylePlusItem.FItemList(i).FItemName,30,"Y") %>">
									</div>
									<div class="pdtCont">
										<p class="pBrand" onclick="TnGotoProduct('<%=oStylePlusItem.FItemList(i).FItemid%>'); return false;"><%= oStylePlusItem.FItemList(i).Fsocname %></p>
										<p class="pName" onclick="TnGotoProduct('<%=oStylePlusItem.FItemList(i).FItemid%>'); return false;"><%= chrbyte(oStylePlusItem.FItemList(i).FItemName,30,"Y") %></p>
										<p class="pPrice" onclick="TnGotoProduct('<%=oStylePlusItem.FItemList(i).FItemid%>'); return false;">
											<%
												IF oStylePlusItem.FItemList(i).IsSaleItem or oStylePlusItem.FItemList(i).isCouponItem Then
													If  oStylePlusItem.FItemList(i).getRealPrice <> oStylePlusItem.FItemList(i).FSellCash then
														IF oStylePlusItem.FItemList(i).IsSaleItem then
											%>
														<%=FormatNumber(oStylePlusItem.FItemList(i).getRealPrice,0) %>원
											<%
														End If
														IF oStylePlusItem.FItemList(i).IsCouponItem then
											%>
														<%= FormatNumber(oStylePlusItem.FItemList(i).GetCouponAssignPrice,0)%>원
											<%
														End If
													Else
											%>
														<%= FormatNumber(oStylePlusItem.FItemList(i).GetCouponAssignPrice,0)%>원
											<%
													End If
												ELSE
											%>
													<%= FormatNumber(oStylePlusItem.FItemList(i).FSellCash,0)%>원
											<%
												End If
											%>								
										</p>
									</div>
								</li>
								<% next %>	
							</ul>
						</div>
					</div>
				<% end if %>

				<div class="inner10">
					<ul class="tagList">
						<%=fngetTagList(playcode, contentsidx, "mobile") %>
					</ul>
				</div>

				<!-- RECENT CONTENT -->
				<!-- #include virtual="/play/incRecentContents.asp" -->
				<!--// RECENT CONTENT -->
				<div id="tempdiv" style="display:none" ></div>
			</div>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>

<%
set oStylePlus=nothing
set oStylePlusItem=nothing
set oplaydetail=nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->