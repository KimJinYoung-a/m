<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description :  급상승
' History : 2018-04-23 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbCTopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'// disp 117 : 패션의류 , 116 : 패션잡화 , 125 : 주얼리/시계 , 118 : 뷰티
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
						catename = "패션의류"
						cateurl  = "/wish/?sort=3&disp=117"
						disp = "117"
						gaparam  = "&gaparam=fashion_up_117_0"
						minprice = 15000
					Case 1 
						catename = "패션잡화"
						cateurl  = "/wish/?sort=3&disp=116"
						disp = "116"
						gaparam  = "&gaparam=fashion_up_116_0"
						minprice = 10000
					Case 2 
						catename = "주얼리/시계"
						cateurl  = "/wish/?sort=3&disp=125"
						disp = "125"
						gaparam  = "&gaparam=fashion_up_125_0"
						minprice = 10000
					Case 3 
						catename = "뷰티"
						cateurl  = "/wish/?sort=3&disp=118"
						disp = "118"
						gaparam  = "&gaparam=fashion_up_118_0"
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
							cPopular.FRectSortMethod = 3
							cPopular.fnPopularList_CT

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
	var ctgy = ['패션의류', '패션잡화', '주얼리/시계', '뷰티']
	var itemSwiper = new Swiper(".fashion-items #hot .swiper-container", {
		loop:true,
		autoplay:3000,
		speed:300,
		effect:'fade',
		disableOnInteraction:false,
		pagination:'.fashion-items #hot .cate-list',
		paginationClickable:true,
		paginationBulletRender: function (index, className) {
			return '<span class="' + className + '">' + (ctgy[index]) + '</span>';
		}
	});
});
</script>
<!-- #include virtual="/lib/db/dbCTclose.asp" -->