<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 다이어리스토리
' History : 2014-10-13 한용민 생성
'####################################################
%>
<%
dim bestgubun
	bestgubun = requestcheckvar(request("bestgubun"),1)

if bestgubun="" then bestgubun="b"

dim awardlist
Set awardlist = new cdiary_list
	awardlist.FPageSize = 6
	awardlist.FCurrPage = 1

	if bestgubun="p" then
		awardlist.fmdpick="o"
		awardlist.getDiaryAwardBest
	else
		awardlist.Fbestgubun = bestgubun
		awardlist.getDiaryAwardBest
	end if

%>
<% if lcase(nowViewPage)="/apps/appcom/wish/webview/diarystory2015/index.asp" then %>
	<ul class="tab-nav">
		<li><a href="/apps/appCom/wish/webview/diarystory2015/index.asp?bestgubun=b#abest" <% if bestgubun="b" then %>class='on'<% end if %>>BEST</a></li>
		<li><a href="/apps/appCom/wish/webview/diarystory2015/index.asp?bestgubun=p#abest" <% if bestgubun="p" then %>class='on'<% end if %>>PICK</a></li>
	</ul>
<% end if %>

<% if awardlist.fresultcount>0 then %>
	<% if bestgubun="p" then %>
		<div id="diaryPick">
			<h2 class="hide">PICK</h2>
	<% else %>
		<div id="diaryBest">
			<h2 class="hide">BEST</h2>
	<% end if %>
		<div class="pdtListWrap">
			<ul class="pdtList">
				<%
				for i = 0 to awardlist.fresultcount -1
				%>
				<li <% if awardlist.FItemList(i).IsSoldOut then %>class='soldOut'<% end if %>>
					<% ' for dev msg : 웹 다이어리 스토리 리스트와 동일한 이미지 호출해주세요 %>
					<div class="pPhoto">
						<% if awardlist.FItemList(i).IsSoldOut then %><p><span><em>품절</em></span></p><% end if %>
						<img src="<%= awardlist.FItemList(i).FDiaryBasicImg %>" onclick="TnGotoProduct('<%=awardlist.FItemList(i).FItemid%>'); return false;" alt="<%= chrbyte(awardlist.FItemList(i).FItemName,30,"Y") %>">
					</div>
					<div class="pdtCont">
						<p class="pBrand" onclick="TnGotoProduct('<%=awardlist.FItemList(i).FItemid%>'); return false;"><%= awardlist.FItemList(i).Fsocname %></p>
						<p class="pName" onclick="TnGotoProduct('<%=awardlist.FItemList(i).FItemid%>'); return false;"><%= chrbyte(awardlist.FItemList(i).FItemName,30,"Y") %></p>
						<p class="pPrice" onclick="TnGotoProduct('<%=awardlist.FItemList(i).FItemid%>'); return false;">
							<%
								IF awardlist.FItemList(i).IsSaleItem or awardlist.FItemList(i).isCouponItem Then
									If  awardlist.FItemList(i).getRealPrice <> awardlist.FItemList(i).FSellCash then
										IF awardlist.FItemList(i).IsSaleItem then
							%>
										<%=FormatNumber(awardlist.FItemList(i).getRealPrice,0) %>원
							<%
										End If
										IF awardlist.FItemList(i).IsCouponItem then
							%>
										<%= FormatNumber(awardlist.FItemList(i).GetCouponAssignPrice,0)%>원
							<%
										End If
									Else
							%>
										<%= FormatNumber(awardlist.FItemList(i).GetCouponAssignPrice,0)%>원
							<%
									End If
								ELSE
							%>
									<%= FormatNumber(awardlist.FItemList(i).FSellCash,0)%>원
							<%
								End If
							%>								
						</p>
						<p class="pShare">
							<span class="cmtView"><%=awardlist.FItemList(i).FEvalCnt%></span>
							<span class="wishView" onclick="TnAddFavoritePrd('<%=awardlist.FItemList(i).FItemID%>'); return false;"><%=FormatNumber(awardlist.FItemList(i).FFavCount,0)%></span>
						</p>
					</div>
				</li>
				<% next %>
			</ul>
		</div>
		
		<% if lcase(nowViewPage)="/apps/appcom/wish/webview/diarystory2015/index.asp" then %>
			<% if bestgubun="b" then %>
				<div class="more"><a href="/apps/appCom/wish/webview/diarystory2015/list.asp?srm=best" title="베스트 다이어리 더보기">more</a></div>
			<% end if %>
		<% end if %>
	</div>
<% end if %>

<%
set awardlist = nothing
%>