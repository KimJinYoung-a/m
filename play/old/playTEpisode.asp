<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  play tepisode
' History : 2014.10.24 원승현 생성
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


playcode = 7 '메뉴상단 번호를 지정


if idx="" then
	response.write "<script type='text/javascript'>alert('T-episode 번호가 없습니다.'); location.history.back();</script>"
	dbget.close() : response.end
end if
if contentsidx="" then
	response.write "<script type='text/javascript'>alert('T-episode 상세번호가 없습니다.'); location.history.back();</script>"
	dbget.close() : response.end
end if

dim oTepisodeClip
set oTepisodeClip = new CPlay
	oTepisodeClip.frectcontentsidx = contentsidx
	oTepisodeClip.FRectIdx = idx
	oTepisodeClip.FRectType = playcode
	oTepisodeClip.FRectUserID = getloginuserid
	oTepisodeClip.GetOneRowTepisodeContent()
	'oTepisodeClip.GetRowTagContent()


	dim oPlayTepisodeItem
	Set oPlayTepisodeItem = new CPlay
		oPlayTepisodeItem.frectcontentsidx = contentsidx
		oPlayTepisodeItem.FPageSize=50
		oPlayTepisodeItem.FCurrPage=1
		oPlayTepisodeItem.getplayTepisodeplusitem()

dim oplaydetail
	set oplaydetail = new CPlay
	oplaydetail.FPageSize = 1
	oplaydetail.FRectIdx = idx
	oplaydetail.fnPlaydetail_one

If idx <> "" Then
	Call fnViewCountPlus(idx)
End If



%>

<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content tEpisode bgGry" id="contentArea">
				<div class="photoPicCont">
					<%=oTepisodeClip.FOneItem.fstyle_html_m%>
				</div>
				<div class="playCont">
					<span class="type" onclick="location.href='/play/index.asp?type=<%= playcode %>'; return false;">T-episode</span>
					<p class="tit"><strong><%= oplaydetail.FOneItem.ftitle %></strong><!--span><%=oplaydetail.FOneItem.Fviewno%>.&nbsp;<%=oplaydetail.FOneItem.Fviewnotxt%></span--></p>
					<p id="mywish<%=oTepisodeClip.FOneItem.fidx%>" class="circleBox wishView <%=chkiif(oTepisodeClip.FOneItem.Fchkfav > 0 ,"wishActive","")%>" <% If getloginuserid <> "" Then %>onclick="TnAddPlaymywish('<%=playcode%>','<%=oTepisodeClip.FOneItem.fidx%>','<%= oplaydetail.FOneItem.Fviewno %>');"<% Else %>onclick="jsChklogin_mobile('','<%=Server.URLencode(CurrURLQ())%>');"<% End If %>><span>찜하기</span></p>
					<ul class="tagList">
						<%=fngetTagList(playcode, contentsidx, "mobile") %>
					</ul>
				</div>

				<% if oPlayTepisodeItem.fresultcount>0 then %>
					<div class="inner10">
						<!--h2 class="tit02 tMar30"><span>관련 상품</span></h2-->
						<div class="pdtListWrap">
							<ul class="pdtList">
								<% for i = 0 to oPlayTepisodeItem.fresultcount -1 %>
								<li onclick="" <% if oPlayTepisodeItem.FItemList(i).IsSoldOut then %>class='soldOut'<% end if %>>									
									<div class="pPhoto">
										<% if oPlayTepisodeItem.FItemList(i).IsSoldOut then %><p><span><em>품절</em></span></p><% end if %>
										<img src="<%= oPlayTepisodeItem.FItemList(i).FImageicon1 %>" onclick="TnGotoProduct('<%=oPlayTepisodeItem.FItemList(i).FItemid%>'); return false;" alt="<%= chrbyte(oPlayTepisodeItem.FItemList(i).FItemName,30,"Y") %>">
									</div>
									<div class="pdtCont">
										<p class="pBrand" onclick="TnGotoProduct('<%=oPlayTepisodeItem.FItemList(i).FItemid%>'); return false;"><%= oPlayTepisodeItem.FItemList(i).Fsocname %></p>
										<p class="pName" onclick="TnGotoProduct('<%=oPlayTepisodeItem.FItemList(i).FItemid%>'); return false;"><%= chrbyte(oPlayTepisodeItem.FItemList(i).FItemName,30,"Y") %></p>
										<p class="pPrice" onclick="TnGotoProduct('<%=oPlayTepisodeItem.FItemList(i).FItemid%>'); return false;">
											<%
												IF oPlayTepisodeItem.FItemList(i).IsSaleItem or oPlayTepisodeItem.FItemList(i).isCouponItem Then
													If  oPlayTepisodeItem.FItemList(i).getRealPrice <> oPlayTepisodeItem.FItemList(i).FSellCash then
														IF oPlayTepisodeItem.FItemList(i).IsSaleItem then
											%>
														<%=FormatNumber(oPlayTepisodeItem.FItemList(i).getRealPrice,0) %>원
											<%
														End If
														IF oPlayTepisodeItem.FItemList(i).IsCouponItem then
											%>
														<%= FormatNumber(oPlayTepisodeItem.FItemList(i).GetCouponAssignPrice,0)%>원
											<%
														End If
													Else
											%>
														<%= FormatNumber(oPlayTepisodeItem.FItemList(i).GetCouponAssignPrice,0)%>원
											<%
													End If
												ELSE
											%>
													<%= FormatNumber(oPlayTepisodeItem.FItemList(i).FSellCash,0)%>원
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
				<% End If %>
				<!-- RECENT CONTENT -->
					<!-- #include virtual="/play/incRecentContents.asp" -->
				<!--// RECENT CONTENT -->
			</div>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
<%
set oTepisodeClip=nothing
set oplaydetail=nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->