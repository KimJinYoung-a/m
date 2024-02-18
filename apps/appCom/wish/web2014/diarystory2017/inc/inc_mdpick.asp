<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 다이어리스토리 M Mdpick
' History : 2016-09-20 유태욱 생성
'####################################################
%>
<%
'dim SortMet
'	bestgubun = requestcheckvar(request("bestgubun"),1)

'if bestgubun="" then bestgubun="b"

'if bestgubun="b" then
'	SortMet="dbest"
'end if

dim awardlistMdpick
Set awardlistMdpick = new cdiary_list
'	awardlistMdpick.FPageSize = 10
'	awardlistMdpick.FCurrPage = 1
'	awardlistMdpick.fmdpick = "o"
'	awardlistMdpick.ftectSortMet = SortMet
'	awardlistMdpick.Fbestgubun = bestgubun
	awardlistMdpick.getDiaryMdpick

%>
	<h2><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/tit_md_choice.png" alt="md's choice" /></h2>
	<div class="diaryList">
		<div class="swiper-container">
			<div class="swiper-wrapper">
			<%
			If awardlistMdpick.FResultCount > 0 Then
				For i = 0 To awardlistMdpick.FResultCount - 1
	
				IF application("Svr_Info") = "Dev" THEN
'					awardlistMdpick.FItemList(i).FDiaryBasicImg = left(awardlistMdpick.FItemList(i).FDiaryBasicImg,7)&mid(awardlistMdpick.FItemList(i).FDiaryBasicImg,12)
'					awardlistMdpick.FItemList(i).FDiaryBasicImg2 = left(awardlistMdpick.FItemList(i).FDiaryBasicImg2,7)&mid(awardlistMdpick.FItemList(i).FDiaryBasicImg2,12)
					'response.write PrdBrandList.FItemList(i).FDiaryBasicImg
				end if
			%>
					<div class="swiper-slide">
						<a href="" onclick="fnAPPpopupProduct('<%=awardlistMdpick.FItemList(i).FItemID %>'); return false;">
							<div class="pPhoto"><img src="<%=awardlistMdpick.FItemList(i).FDiaryBasicImg%>" alt="<%=awardlistMdpick.FItemList(i).FItemName%>" /></div>
							<div class="pdtCont">
								<p class="pName"><%= chrbyte(awardlistMdpick.FItemList(i).FItemName,30,"Y") %></p>
								<!-- 할인상품일경우 클래스 cRd1 -->
								<% if awardlistMdpick.FItemList(i).IsSaleItem or awardlistMdpick.FItemList(i).isCouponItem Then %>
									<% IF awardlistMdpick.FItemList(i).IsSaleItem then %>
										<div class="pPrice <% if awardlistMdpick.FItemList(i).Flimited = "o" then %> cRd1<% end if %>"><%=FormatNumber(awardlistMdpick.FItemList(i).getRealPrice,0)%>원</div>
									<% End If %>
									<% IF awardlistMdpick.FItemList(i).IsCouponItem Then %>
										<div class="pPrice"><%=FormatNumber(awardlistMdpick.FItemList(i).GetCouponAssignPrice,0)%>원</div>
									<% end if %>
								<% else %>
									<div class="pPrice <% if awardlistMdpick.FItemList(i).Flimited = "o" then %> cRd1<% end if %>"><%=FormatNumber(awardlistMdpick.FItemList(i).getRealPrice,0) & chkIIF(awardlistMdpick.FItemList(i).IsMileShopitem,"Point","원")%></div>
								<% end if %>
							</div>
							<!-- 할인상품일경우 -->
							<% IF awardlistMdpick.FItemList(i).IsSaleItem then %>
								<div class="label"><span><%=awardlistMdpick.FItemList(i).getSalePro%></span></div>
							<% end if %>
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
set awardlistMdpick = nothing
%>