<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 다이어리스토리 M Mdpick
' History : 2017-09-26 유태욱 생성
'####################################################
%>
<%
dim awardlistMdpick
Set awardlistMdpick = new cdiary_list
'	awardlistMdpick.FPageSize = 10
'	awardlistMdpick.FCurrPage = 1
'	awardlistMdpick.fmdpick = "o"
'	awardlistMdpick.ftectSortMet = SortMet
'	awardlistMdpick.Fbestgubun = bestgubun
	awardlistMdpick.getDiaryMdpick

If awardlistMdpick.FResultCount > 0 Then
	For i = 0 To awardlistMdpick.FResultCount - 1

		IF application("Svr_Info") = "Dev" THEN
'			awardlistMdpick.FItemList(i).FDiaryBasicImg = left(awardlistMdpick.FItemList(i).FDiaryBasicImg,7)&mid(awardlistMdpick.FItemList(i).FDiaryBasicImg,12)
'			awardlistMdpick.FItemList(i).FDiaryBasicImg2 = left(awardlistMdpick.FItemList(i).FDiaryBasicImg2,7)&mid(awardlistMdpick.FItemList(i).FDiaryBasicImg2,12)
'			response.write awardlistMdpick.FItemList(i).FDiaryBasicImg
		end if
		'awardlistMdpick.FItemList(i).FDiaryBasicImg
		'awardlistMdpick.FItemList(i).FImageList
'		awardlistMdpick.FItemList(i).FImageList120
'		awardlistMdpick.FItemList(i).FImageIcon1
		
%>
		<li>
			<a href="" onclick="fnAPPpopupProduct('<%=awardlistMdpick.FItemList(i).FItemID%>'); return false;">
				<div class="thumbnail"><img src="<%=awardlistMdpick.FItemList(i).FDiaryBasicImg%>" alt="<%=awardlistMdpick.FItemList(i).FItemName%>" /></div>
				<div class="desc">
					<p class="name"><%= chrbyte(awardlistMdpick.FItemList(i).FItemName,30,"Y") %></p>
					<div class="price">
						<% if awardlistMdpick.FItemList(i).IsSaleItem or awardlistMdpick.FItemList(i).isCouponItem Then %>
							<% IF awardlistMdpick.FItemList(i).IsSaleItem then %>
								<b class="discount color-red"><%=awardlistMdpick.FItemList(i).getSalePro%></b>
								<b class="sum"><%=FormatNumber(awardlistMdpick.FItemList(i).getRealPrice,0)%><span class="won">원</span></b>
							<% End If %>
							<% IF awardlistMdpick.FItemList(i).IsCouponItem Then %>
								<b class="sum"><%=FormatNumber(awardlistMdpick.FItemList(i).GetCouponAssignPrice,0)%><span class="won">원</span></b>
							<% end if %>
						<% else %>
							<b class="sum"><%=FormatNumber(awardlistMdpick.FItemList(i).getRealPrice,0) %><span class="won"><%= chkIIF(awardlistMdpick.FItemList(i).IsMileShopitem,"Point","원")%></span></b>
						<% end if %>
					</div>
				</div>
			</a>
		</li>
<%
	next
end if
set awardlistMdpick = nothing
%>