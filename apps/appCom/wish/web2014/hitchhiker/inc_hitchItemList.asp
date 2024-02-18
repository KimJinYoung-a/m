<%
'#############################################################
'	Description : 모바일 HITCHHIKER ItemList
'	History		: 2015.01.26 유태욱 생성
'#############################################################
%>
<%
dim makerid, soldoutyn, sortno, rstArrItemid, rstWishItem, rstWishCnt, i, sBadges, page
	page=requestcheckvar(request("page"),10)
	soldoutyn=requestcheckvar(request("soldoutyn"),1)
	sortno=requestcheckvar(request("sortno"),4)

if soldoutyn="" then soldoutyn="N"
if page="" then page=1
rstArrItemid=""
rstWishItem=""
rstWishCnt=""
makerid="hitchhiker"

dim ohitlist
set ohitlist = new CHitchhikerlist
	ohitlist.frectmakerid=makerid
	ohitlist.frectsoldoutyn=soldoutyn
	ohitlist.frectsortno=sortno
	ohitlist.FPageSize = 50
	ohitlist.FCurrPage = page
	ohitlist.fnGetHitList

	rstArrItemid=""

	IF (ohitlist.FResultCount >= 0) THEN
		'// 검색결과 내위시 표시정보 접수
		if IsUserLoginOK then
			'// 검색결과 상품목록 작성
			rstArrItemid=""
			IF ohitlist.FTotCnt >0 then 
				For i=0 To ohitlist.FTotCnt -1
					rstArrItemid = rstArrItemid & chkIIF(rstArrItemid="","",",") & ohitlist.FItemList(i).FItemID
				Next
			End if
			'// 위시결과 상품목록 작성
			rstWishItem=""
			rstWishCnt=""
			if rstArrItemid<>"" then
				Call getMyFavItemList(getLoginUserid(),rstArrItemid,rstWishItem, rstWishCnt)
			end if
		end if
	END IF
%>
<div class="hitchhikerPdt">
<% IF ohitlist.FResultCount > 0 THEN %>
	<div class="items type-grid">
		<ul>
		<% FOR i = 0 to ohitlist.FResultCount-1 %>
			<li>
				<a href="javascript:jsViewItem('<%= ohitlist.FItemList(i).FItemID %>');">
				<div class="thumbnail"><img src="<%=ohitlist.FItemList(i).FImageBasic%>" alt="<%= ohitlist.FItemList(i).FItemName %>" /><% if ohitlist.FItemList(i).IsSoldOut then %><b class="soldout">일시 품절</b><% end if %></div>
				<div class="desc">
					<p class="brand"><%=ohitlist.FItemList(i).FBrandName %></p>
					<p class="name"><%=ohitlist.FItemList(i).FItemName %></p>
					<% IF ohitlist.FItemList(i).IsSaleItem or ohitlist.FItemList(i).isCouponItem Then %>
					<div class="price">
						<% IF ohitlist.FItemList(i).IsSaleItem then %>
						<div class="unit"><b class="sum"><% = FormatNumber(ohitlist.FItemList(i).getRealPrice,0) %><% If ohitlist.FItemList(i).IsMileShopitem Then %><span class="won" lang="en">Point</span><% Else %><span class="won">원</span><% End If %></b> <b class="discount color-red"><%=ohitlist.FItemList(i).getSalePro%></b></div>
						<% End if %>
						<% IF ohitlist.FItemList(i).IsCouponItem Then %>
						<div class="unit"><b class="sum"><% = FormatNumber(ohitlist.FItemList(i).GetCouponAssignPrice,0) %><% If ohitlist.FItemList(i).IsMileShopitem Then %><span class="won" lang="en">Point</span><% Else %><span class="won">원</span><% End If %></b> <b class="discount color-green"><%=ohitlist.FItemList(i).getSalePro%><small>쿠폰</small></b></div>
						<% End if %>
					</div>
					<% Else %>
					<div class="price">
						<div class="unit"><b class="sum"><% = FormatNumber(ohitlist.FItemList(i).getRealPrice,0) %><% If ohitlist.FItemList(i).IsMileShopitem Then %><span class="won" lang="en">Point</span><% Else %><span class="won">원</span><% End If %></b></div>
					</div>
					<% End if %>
				</div>
				</a>
				<div class="etc">
					<div class="tag review"><span class="icon icon-rating"><i style="width:<%=fnEvalTotalPointAVG(ohitlist.FItemList(i).FPoints,"search")%>%;">리뷰 종합 별점 90점</i></span><span class="counting"><%=ohitlist.FItemList(i).Fevalcnt%>+</span></div>
					<button class="tag wish btn-wish" onclick="TnAddFavoritePrd('<%=ohitlist.FItemList(i).FItemid%>');"><span class="icon icon-wish"><i class="hidden"> wish</i></span><%=FormatNumber(ohitlist.FItemList(i).FfavCount,0)%>+</span></button>
				</div>
			</li>
		<% NEXT %>
		</ul>
	</div>
<% End if %>
</div>
<%
set ohitlist=nothing
%>