<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description :  급상승
' History : 2018-06-28 정태훈 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbCTopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->
<%
'// disp 121 : 가구/수납 , 122 : 데코/조명 , 112 : 키친 , 120 : 패브릭/생활
%>
<div id="hot" class="tab-content current">
	<h2 class="hidden">급상승</h2>
	<div class="swiper-container">
		<div class="cate-list"></div>
		<div class="swiper-wrapper">
			<%
				Dim gaparam
				Dim cPopular
				Dim i, ii , catename , cateurl , disp , minprice
				For ii = 0 To 3
				
				Select Case ii
					Case 0 
						catename = "가구/수납"
						cateurl  = "/wish/?sort=3&disp=121"
						disp = "121"
						gaparam  = "&gaparam=living_up_121_0"
						minprice = 20000
					Case 1 
						catename = "데코/조명"
						cateurl  = "/wish/?sort=3&disp=122"
						disp = "122"
						gaparam  = "&gaparam=living_up_122_0"
						minprice = 10000
					Case 2 
						catename = "키친"
						cateurl  = "/wish/?sort=3&disp=112"
						disp = "112"
						gaparam  = "&gaparam=living_up_112_0"
						minprice = 8000
					Case 3 
						catename = "패브릭/생활"
						cateurl  = "/wish/?sort=3&disp=120"
						disp = "120"
						gaparam  = "&gaparam=living_up_120_0"
						minprice = 10000
					Case Else
						catename = ""
						cateurl  = ""
				End Select 

			%>
			<div class="swiper-slide">
				<div class="items">
					<ul>
						<%
							'' 2차서버로 변경 2014/09/30 dbopen.asp => dbCTopen.asp, dbclose.asp =>dbCTclose.asp, fnPopularList => fnPopularList_CT
							SET cPopular = New CMyFavorite
							cPopular.FPageSize = 6
							cPopular.FCurrpage = 1
							cPopular.FRectDisp = disp
							cPopular.FRectMinprice = minprice
							cPopular.fnPopularLivingList_CT

							If (cPopular.FResultCount > 0) Then
							For i = 0 To cPopular.FResultCount-1 
						%>
						<li>
							<% If isapp = "1" Then %>
							<a href="" onclick="fnAPPpopupProduct('<%=cPopular.FItemList(i).FItemID%>');return false;">
							<% Else %>
							<a href="/category/category_itemprd.asp?itemid=<%=cPopular.FItemList(i).FItemID%><%=gaparam & (i+1) %>">
							<% End If %>
								<div class="thumbnail"><img src="<% = cPopular.FItemList(i).FImageBasic %>" alt="<%= cPopular.FItemList(i).FItemName %>"></div>
								<div class="desc">
									<div class="price">
										<% if cPopular.FItemList(i).IsSaleItem or cPopular.FItemList(i).isCouponItem Then %>
											<% IF cPopular.FItemList(i).IsSaleItem and cPopular.FItemList(i).isCouponItem then %>
												<b class="discount color-red"><%=cPopular.FItemList(i).getSalePro%></b>
												<span class="sum"><%=FormatNumber(cPopular.FItemList(i).GetCouponAssignPrice,0)%>원</span>
											<% elseif cPopular.FItemList(i).IsSaleItem then %>
												<b class="discount color-red"><%=cPopular.FItemList(i).getSalePro%></b>
												<span class="sum"><%=FormatNumber(cPopular.FItemList(i).getRealPrice,0)%>원</span>
											<% else %>
												<b class="discount color-green"><%=chkiif(InStr(cPopular.FItemList(i).GetCouponDiscountStr,"%") >0,cPopular.FItemList(i).GetCouponDiscountStr,"쿠폰")%></b>
												<span class="sum"><%=FormatNumber(cPopular.FItemList(i).GetCouponAssignPrice,0)%>원</span>
											<% End If %>
										<% else %>
											<span class="sum"><%=FormatNumber(cPopular.FItemList(i).getRealPrice,0)%>원</span>
										<% end if %>
									</div>
								</div>
							</a>
						</li>
						<%
							Next
							End If 
							SET cPopular = Nothing
						%>
					</ul>
				</div>
				<div class="btn-group">
					<% If isapp Then %>
					<a href="" onclick="fnAPPpopupWish_URL('<%=wwwUrl%>/apps/appCom/wish/web2014<%=cateurl%><%=gaparam%>0');return false;" class="btn-plus">
					<% Else %>
					<a href="<%=cateurl%><%=gaparam%>0" class="btn-plus">
					<% End If %>
					<span class="icon icon-plus icon-plus-black"></span> <%=catename%> 더보기</a>
				</div>
			</div>
			<%
				Next 
			%>
		</div>
	</div>
</div>
<script>
$(function(){
	/* new, hot, best */
	var ctgy = ['가구/수납', '데코/조명', '키친', '패브릭/생활']
	var itemSwiper = new Swiper(".ctgy-items #hot .swiper-container", {
		loop:true,
		autoplay:3000,
		speed:300,
		effect:'fade',
		disableOnInteraction:false,
		pagination:'.ctgy-items #hot .cate-list',
		paginationClickable:true,
		paginationBulletRender: function (index, className) {
			return '<span class="' + className + '">' + (ctgy[index]) + '</span>';
		}
	});
});
</script>
<!-- #include virtual="/lib/db/dbCTclose.asp" -->