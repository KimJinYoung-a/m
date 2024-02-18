<div class="inner5 tabArea tMar20">
	<div class="subNaviWrap swiper-nav">
		<ul class="tabList">
			<li class="active-nav" name="tab01">MD'S PICK</li>
			<li name="tab02">SALE</li>
			<li name="tab03">BEST</li>
		</ul>
	</div>
	<div class="pdtListWrap box1 swiper-container">
		<div class="tabCont swiper-wrapper">
			<%
				dim oMdpick , mdTotalCnt , intloop
				set oMdpick = new CCateClass
				oMdpick.Fdisp1		= vDisp
				oMdpick.GetCateMdPick()

				mdTotalCnt = oMdpick.FResultCount

				IF oMdpick.FResultCount >0 then
			%>
					<ul class="simpleList tabMds swiper-slide" id="tab01">
			<%
					For intloop=0 To mdTotalCnt-1
			%>
						<li>
							<a href="#" onclick="fnAPPpopupProduct('<%= oMdpick.FItemList(intloop).FItemID %>');return false;">
								<p><img src="<%= getStonThumbImgURL(oMdpick.FItemList(intloop).FImageBasic,150,150,"true","false") %>" alt="<% = oMdpick.FItemList(intloop).FItemName %>" /></p>
								<span><% = oMdpick.FItemList(intloop).FItemName %></span>
								<% If oMdpick.FItemList(intloop).FsailYN = "N" and oMdpick.FItemList(intloop).FitemcouponYn = "N" then %>
								<span class="price"><%=formatNumber(oMdpick.FItemList(intloop).ForgPrice,0)%>원</span>
								<% End If 
									 If oMdpick.FItemList(intloop).FsailYN = "Y" and oMdpick.FItemList(intloop).FitemcouponYn = "N" Then %>
								<span class="price"><%=formatNumber(oMdpick.FItemList(intloop).FsellCash,0)%>원 <em class="cRd1"><% If CLng((oMdpick.FItemList(intloop).ForgPrice-oMdpick.FItemList(intloop).FsellCash)/oMdpick.FItemList(intloop).ForgPrice*100)> 0 Then  %>[<%=CLng((oMdpick.FItemList(intloop).ForgPrice-oMdpick.FItemList(intloop).FsellCash)/oMdpick.FItemList(intloop).ForgPrice*100)%>%]<% End If %></em></span>					
								<% End If 
									if oMdpick.FItemList(intloop).FitemcouponYn = "Y" And oMdpick.FItemList(intloop).Fitemcouponvalue>0 then%>
								<span class="price">
									<%If oMdpick.FItemList(intloop).Fitemcoupontype = "1" Then
										response.write formatNumber(oMdpick.FItemList(intloop).FsellCash - CLng(oMdpick.FItemList(intloop).Fitemcouponvalue*oMdpick.FItemList(intloop).FsellCash/100),0)
									ElseIf oMdpick.FItemList(intloop).Fitemcoupontype = "2" Then
										response.write formatNumber(oMdpick.FItemList(intloop).FsellCash - oMdpick.FItemList(intloop).Fitemcouponvalue,0)
									ElseIf oMdpick.FItemList(intloop).Fitemcoupontype = "3" Then
										response.write formatNumber(oMdpick.FItemList(intloop).FsellCash,0)
									Else
										response.write formatNumber(oMdpick.FItemList(intloop).FsellCash,0)
									End If%>원 <em class="cGr1">[<%If oMdpick.FItemList(intloop).Fitemcoupontype = "1" Then
										response.write CStr(oMdpick.FItemList(intloop).Fitemcouponvalue) & "%"
									ElseIf oMdpick.FItemList(intloop).Fitemcoupontype = "2" Then
										response.write formatNumber(oMdpick.FItemList(intloop).Fitemcouponvalue,0) & "원 할인"
									ElseIf oMdpick.FItemList(intloop).Fitemcoupontype = "3" Then
										response.write "무료배송"
									Else
										response.write oMdpick.FItemList(intloop).Fitemcouponvalue
									End If %>]</em></span>
								<% End If %>

							</a>
						</li>
			<%
						Next 
				Response.Write "</ul>"
				End If
				set oMdpick = Nothing
			%>
			<%
				dim oDoc, TotalCnt , i
				set oDoc = new SearchItemCls
				oDoc.FListDiv 			= "salelist" 'sale아이템
				oDoc.FRectSortMethod	= "ne"
				oDoc.FRectSearchFlag 	= "sale"
				oDoc.FPageSize 			= "6"
				oDoc.FRectCateCode		= vDisp
				oDoc.FCurrPage 			= "1"
				oDoc.FSellScope 		= "Y"
				oDoc.FScrollCount 		= 1
				oDoc.getSearchList

				TotalCnt = oDoc.FResultCount

				IF oDoc.FResultCount >0 then
			%>
					<ul class="simpleList tabSale swiper-slide" id="tab02">
			<%
						For i=0 To TotalCnt-1
			%>
						<li>
							<a href="#" onclick="fnAPPpopupProduct('<%= oDoc.FItemList(i).FItemID %>');return false;">
								<p><img src="<%= getStonThumbImgURL(oDoc.FItemList(i).FImageBasic,150,150,"true","false") %>" alt="<% = oDoc.FItemList(i).FItemName %>" /></p>
								<span><% = oDoc.FItemList(i).FItemName %></span>
								<%
								If oDoc.FItemList(i).IsSaleItem or oDoc.FItemList(i).isCouponItem Then
									IF oDoc.FItemList(i).IsSaleItem Then
										Response.Write "<span class=""price"">" & FormatNumber(oDoc.FItemList(i).getRealPrice,0) & "원"
										Response.Write "<em class=""cRd1"">[" & oDoc.FItemList(i).getSalePro & "]</em></span>"
									elseif oDoc.FItemList(i).IsCouponItem Then
										Response.Write "<span class=""price"">" & FormatNumber(oDoc.FItemList(i).GetCouponAssignPrice,0) & "원"
										Response.Write "<em class=""cRd1"">[" & oDoc.FItemList(i).GetCouponDiscountStr & "]</em></span>"
									End IF
								Else
									Response.Write "<span class=""price"">" & FormatNumber(oDoc.FItemList(i).getRealPrice,0) & "원</span>"
								End If
								%>
							</a>
						</li>
			<%
						Next 
				Response.Write "</ul>"
				End If
				set oDoc = Nothing
			%>
			<%
				Dim oaward, iCb
				set oaward = new CAWard
				oaward.FPageSize = 6
				oaward.FRectDisp1 = vDisp
				oaward.FRectAwardgubun = "b"	'BEST셀러
				oaward.GetNormalItemList
				
				If oaward.FResultCount > 0 Then
			%>
				<ul class="simpleList tabBest swiper-slide" id="tab03">
			<%
						For iCb=0 To oaward.FResultCount-1
			%>	
							<li>
								<a href="#" onclick="fnAPPpopupProduct('<%= oaward.FItemList(iCb).Fitemid %>');return false;">
									<p>
										<span class="bestFlag"><em><%=iCb+1%></em></span>
										<img src="<%= getStonThumbImgURL(oaward.FItemList(iCb).FImageBasic,150,150,"true","false") %>" alt="<%=oaward.FItemList(iCb).FitemName%>" />
									</p>
									<span><%=oaward.FItemList(iCb).FitemName%></span>
									<%
										If oaward.FItemList(iCb).IsSaleItem or oaward.FItemList(iCb).isCouponItem Then
											IF oaward.FItemList(iCb).IsSaleItem Then
												Response.Write "<span class=""price"">" & FormatNumber(oaward.FItemList(iCb).getRealPrice,0) & "원<em class=""cRd1"">[" & oaward.FItemList(iCb).getSalePro & "]</em></span>"
											elseif oaward.FItemList(iCb).IsCouponItem Then
												Response.Write "<span class=""price"">" & FormatNumber(oaward.FItemList(iCb).GetCouponAssignPrice,0) & "원<em class=""cRd1"">[" & oaward.FItemList(iCb).GetCouponDiscountStr & "]</em></span>"
											End IF
										Else
											Response.Write "<span class=""price"">" & FormatNumber(oaward.FItemList(iCb).getRealPrice,0) & "원</span>"
										End If
									%>
								</a>
							</li>
			<%
						Next
				Response.Write "</ul>"
				End If
				set oaward = Nothing
			%>
		</div>
	</div>
</div>