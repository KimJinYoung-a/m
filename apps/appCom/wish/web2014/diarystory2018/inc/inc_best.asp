<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 다이어리스토리 M best
' History : 2017-09-26 유태욱 생성
'####################################################
%>
<%
dim bestgubun, SortMet
	bestgubun = requestcheckvar(request("bestgubun"),1)

if bestgubun="" then bestgubun="b"

if bestgubun="b" then
	SortMet="dbest"
end if

dim awardlist
Set awardlist = new cdiary_list
	awardlist.FPageSize = 10
	awardlist.FCurrPage = 1
	awardlist.ftectSortMet = SortMet
	awardlist.Fbestgubun = bestgubun
	awardlist.getDiaryAwardBest


If awardlist.FResultCount > 0 Then
	For i = 0 To awardlist.FResultCount - 1

	IF application("Svr_Info") = "Dev" THEN
		awardlist.FItemList(i).FDiaryBasicImg = left(awardlist.FItemList(i).FDiaryBasicImg,7)&mid(awardlist.FItemList(i).FDiaryBasicImg,12)
		awardlist.FItemList(i).FDiaryBasicImg2 = left(awardlist.FItemList(i).FDiaryBasicImg2,7)&mid(awardlist.FItemList(i).FDiaryBasicImg2,12)
		'response.write PrdBrandList.FItemList(i).FDiaryBasicImg
	end if
%>
	<li>
		<a href="" onclick="fnAPPpopupProduct('<%=awardlist.FItemList(i).FItemID%>'); return false;">
			<b class="no"><span class="rank"><%= i+1 %></span><%' <span class="icon icon-up">급상승</span>%></b>
			<div class="thumbnail"><img src="<%=awardlist.FItemList(i).FDiaryBasicImg%>" alt="<%=awardlist.FItemList(i).FItemName%>" /></div>
			<div class="desc">
				<span class="brand"><%= awardlist.FItemList(i).FBrandName %></span>
				<p class="name"><%= chrbyte(awardlist.FItemList(i).FItemName,30,"Y") %></p>
				<div class="price">
					<% if awardlist.FItemList(i).IsSaleItem or awardlist.FItemList(i).isCouponItem Then %>
						<% IF awardlist.FItemList(i).IsSaleItem then %>
							<div class="unit"><b class="sum"><%=FormatNumber(awardlist.FItemList(i).getRealPrice,0)%><span class="won">원</span></b> <b class="discount color-red"><%=awardlist.FItemList(i).getSalePro%></b></div>
						<% End If %>
						<% IF awardlist.FItemList(i).IsCouponItem Then %>
							<div class="unit"><b class="sum"><%=FormatNumber(awardlist.FItemList(i).GetCouponAssignPrice,0)%><span class="won">원</span></b> <b class="discount color-green"><%= awardlist.FItemList(i).GetCouponDiscountStr %><small>쿠폰</small></b></div>
						<% end if %>
					<% else %>
						<div class="unit"><b class="sum"><%=FormatNumber(awardlist.FItemList(i).getRealPrice,0) %><span class="won"><%= chkIIF(awardlist.FItemList(i).IsMileShopitem,"Point","원") %></span></b></div>
					<% end if %>	
				</div>
			</div>
		</a>
	</li>
<%
	next
end if
set awardlist = nothing
%>