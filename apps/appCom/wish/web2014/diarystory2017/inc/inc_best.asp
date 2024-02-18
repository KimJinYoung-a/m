<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 다이어리스토리 M best
' History : 2016-09-20 유태욱 생성
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
%>
	<h2><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/tit_best_diary.png" alt="best diary" /></h2>
	<a href="" onclick="fnAPPpopupBrowserURL('다이어리상품','<%=wwwUrl%>/apps/appCom/wish/web2014/diarystory2017/list.asp?srm=best'); return false;" class="btnMore"><span>More</span></a>
	<div class="diaryList">
		<div class="swiper-container">
			<div class="swiper-wrapper">
			<%
			If awardlist.FResultCount > 0 Then
				For i = 0 To awardlist.FResultCount - 1
		
				IF application("Svr_Info") = "Dev" THEN
					awardlist.FItemList(i).FDiaryBasicImg = left(awardlist.FItemList(i).FDiaryBasicImg,7)&mid(awardlist.FItemList(i).FDiaryBasicImg,12)
					awardlist.FItemList(i).FDiaryBasicImg2 = left(awardlist.FItemList(i).FDiaryBasicImg2,7)&mid(awardlist.FItemList(i).FDiaryBasicImg2,12)
					'response.write PrdBrandList.FItemList(i).FDiaryBasicImg
				end if
			%>
				<div class="swiper-slide">
					<a href="" onclick="fnAPPpopupProduct('<%=awardlist.FItemList(i).FItemID %>'); return false;">
						<div class="pPhoto"><img src="<%=awardlist.FItemList(i).FDiaryBasicImg%>" alt="<%=awardlist.FItemList(i).FItemName%>" /></div>
						<div class="pdtCont">
							<p class="pName"><%= chrbyte(awardlist.FItemList(i).FItemName,30,"Y") %></p>
							<% if awardlist.FItemList(i).IsSaleItem or awardlist.FItemList(i).isCouponItem Then %>
								<% IF awardlist.FItemList(i).IsSaleItem then %>
									<div class="pPrice"><%=FormatNumber(awardlist.FItemList(i).getRealPrice,0)%>원</div>
								<% End If %>
								<% IF awardlist.FItemList(i).IsCouponItem Then %>
									<div class="pPrice"><%=FormatNumber(awardlist.FItemList(i).GetCouponAssignPrice,0)%>원</div>
								<% end if %>
							<% else %>
								<div class="pPrice"><%=FormatNumber(awardlist.FItemList(i).getRealPrice,0) & chkIIF(awardlist.FItemList(i).IsMileShopitem,"Point","원")%></div>
							<% end if %>
						</div>
					</a>
				</div>
			<%
				next
			end if
			%>
			</div>
		</div>
	</div>
<%
set awardlist = nothing
%>