<%
If (oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut) Then
	dim oCBDoc , ichk
	set oCBDoc = new SearchItemCls
		oCBDoc.FRectSearchTxt = ""
		oCBDoc.FRectPrevSearchTxt = ""
		oCBDoc.FRectExceptText = ""
		oCBDoc.FRectSortMethod	= "be"		'인기상품
		oCBDoc.FRectSearchFlag = "n"			'일반상품
		oCBDoc.FRectSearchItemDiv = "n"		'기본 카테고리만
		oCBDoc.FRectSearchCateDep = "T"		'하위 카테고리 포함
		oCBDoc.FRectCateCode	= CHKIIF(Len(vDisp)>8,Left(vDisp,9),vDisp) 
		oCBDoc.FminPrice	= ""
		oCBDoc.FmaxPrice	= ""
		oCBDoc.FdeliType	= ""
		oCBDoc.FCurrPage = 1
		oCBDoc.FPageSize = 37					'9개 접수
		oCBDoc.FScrollCount = 5
		oCBDoc.FListDiv = "list"				'상품목록
		oCBDoc.FLogsAccept = False			'로그 기록안함
		oCBDoc.FAddLogRemove = true			'추가로그 기록안함
		oCBDoc.FcolorCode = "0"				'전체컬러
		oCBDoc.FSellScope= "Y"				'판매중인 상품만
		oCBDoc.getSearchList

	If oCBDoc.FResultCount > 0 Then
		ichk = 1
%>
<aside id="soldoutSwiper" class="recommend-item recommend-soldout">
	<h2>대신 이런 상품은 어때요?</h2>
	<div class="items type-card">
		<div class="swiper-container">
			<ul class="swiper-wrapper">
<%
			For i=0 To oCBDoc.FResultCount-1
				if cStr(oCBDoc.FItemList(i).Fitemid)<>cStr(itemid) then	'현재보는 상품이 아니면 표시
%>
				<li class="swiper-slide">
					<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%= oCBDoc.FItemList(i).Fitemid %>&rc=item_cate_<%=ichk%>">
						<div class="thumbnail"><img src="<%=getStonThumbImgURL(oCBDoc.FItemList(i).FImageBasic,200,200,"true","false")%>" alt="" /></div>
						<div class="desc">
							<p class="name"><%=oCBDoc.FItemList(i).FitemName%></p>
							<div class="price">
								<div class="unit">
									<%
										If oCBDoc.FItemList(i).FSaleyn = "N" and oCBDoc.FItemList(i).FItemcouponyn = "N" Then
											Response.Write "<b class=""sum"">" & formatNumber(oCBDoc.FItemList(i).FOrgPrice,0) & "<span class=""won"">원</span></b>"
										End If
										If oCBDoc.FItemList(i).FSaleyn = "Y" and oCBDoc.FItemList(i).FItemcouponyn = "N" Then
											Response.Write "<b class=""sum"">" & formatNumber(oCBDoc.FItemList(i).FSellCash,0) & "<span class=""won"">원</span></b>"
										End If
										if oCBDoc.FItemList(i).FItemcouponyn = "Y" And oCBDoc.FItemList(i).FItemCouponValue>0 Then
											If oCBDoc.FItemList(i).FItemCouponType = "1" Then
												Response.Write "<b class=""sum"">" & formatNumber(oCBDoc.FItemList(i).FSellCash - CLng(oCBDoc.FItemList(i).FItemCouponValue*oCBDoc.FItemList(i).FSellCash/100),0) & "<span class=""won"">원</span></b>"
											ElseIf oCBDoc.FItemList(i).FItemCouponType = "2" Then
												Response.Write "<b class=""sum"">" & formatNumber(oCBDoc.FItemList(i).FSellCash - oCBDoc.FItemList(i).FItemCouponValue,0) & "<span class=""won"">원</span></b>"
											ElseIf oCBDoc.FItemList(i).FItemCouponType = "3" Then
												Response.Write "<b class=""sum"">" & formatNumber(oCBDoc.FItemList(i).FSellCash,0) & "<span class=""won"">원</span></b>"
											Else
												Response.Write "<b class=""sum"">" & formatNumber(oCBDoc.FItemList(i).FSellCash,0) & "<span class=""won"">원</span></b>"
											End If
										End If

										If oCBDoc.FItemList(i).FSaleyn = "Y" And oCBDoc.FItemList(i).FItemcouponyn = "Y" Then
											If oCBDoc.FItemList(i).FItemCouponType = "1" Then
												'//할인 + %쿠폰
												Response.Write "<b class=""discount color-red"">" & CLng((oCBDoc.FItemList(i).FOrgPrice-(oCBDoc.FItemList(i).FSellCash - CLng(oCBDoc.FItemList(i).FItemCouponValue*oCBDoc.FItemList(i).FSellCash/100)))/oCBDoc.FItemList(i).FOrgPrice*100)&"%</b>"
											ElseIf oCBDoc.FItemList(i).FItemCouponType = "2" Then
												'//할인 + 원쿠폰
												Response.Write "<b class=""discount color-red"">" & CLng((oCBDoc.FItemList(i).FOrgPrice-(oCBDoc.FItemList(i).FSellCash - oCBDoc.FItemList(i).FItemCouponValue))/oCBDoc.FItemList(i).FOrgPrice*100)&"%</b>"
											Else
												'//할인 + 무배쿠폰
												Response.Write "<b class=""discount color-red"">" & CLng((oCBDoc.FItemList(i).FOrgPrice-oCBDoc.FItemList(i).FSellCash)/oCBDoc.FItemList(i).FOrgPrice*100)&"%</b>"
											End If
										ElseIf oCBDoc.FItemList(i).FSaleyn = "Y" and oCBDoc.FItemList(i).FItemcouponyn = "N" Then
											If CLng((oCBDoc.FItemList(i).FOrgPrice-oCBDoc.FItemList(i).FSellCash)/oCBDoc.FItemList(i).FOrgPrice*100)> 0 Then
												Response.Write "<b class=""discount color-red"">" & CLng((oCBDoc.FItemList(i).FOrgPrice-oCBDoc.FItemList(i).FSellCash)/oCBDoc.FItemList(i).FOrgPrice*100)&"%</b>"
											End If
										ElseIf oCBDoc.FItemList(i).FSaleyn = "N" And oCBDoc.FItemList(i).FItemcouponyn = "Y" And oCBDoc.FItemList(i).FItemCouponValue>0 Then
											If oCBDoc.FItemList(i).FItemCouponType = "1" Then
												Response.Write "<b class=""discount color-green"">" & CStr(oCBDoc.FItemList(i).FItemCouponValue) & "%</b>"
											ElseIf oCBDoc.FItemList(i).FItemCouponType = "2" Then
												Response.Write "<b class=""discount color-green"">쿠폰</b>"
											ElseIf oCBDoc.FItemList(i).FItemCouponType = "3" Then
												Response.Write "<b class=""discount color-green"">쿠폰</b>"
											Else
												Response.Write "<b class=""discount color-green"">" & oCBDoc.FItemList(i).FItemCouponValue &"%</b>"
											End If
										End If
									%>
								</div>
							</div>
						</div>
					</a>
				</li>
<%
				ichk = ichk+1
				end if
				if ichk>36 then Exit For
			Next
%>
			</ul>
		</div>
	</div>
</aside>
<%
	End if

	set oCBDoc = Nothing
End if
%>
<script>
	/* soldout item swiper - recommend */
	if ($("#soldoutSwiper .swiper-container .swiper-slide").length > 3) {
		var soldoutSwiper = new Swiper("#soldoutSwiper .swiper-container", {
			//loop:true,
			slidesPerView:"auto",
			freeMode:true,
			freeModeMomentumRatio:0.5
		});
	}

</script>