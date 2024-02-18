<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbCTopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
 '' 2차서버로 변경 2014/09/30 dbopen.asp => dbCTopen.asp, dbclose.asp =>dbCTclose.asp, fnPopularList => fnPopularList_CT
	Dim cPopular, vDisp, vSort, vCurrPage, i, j, vArrEval , PageSize , vSaleFreeDeliv
	vDisp = RequestCheckVar(Request("disp"),18)
	vSort = NullFillWith(RequestCheckVar(Request("sort"),1),"1")
	vCurrPage = RequestCheckVar(Request("cpg"),5)
	PageSize = getNumeric(requestCheckVar(request("psz"),9))

	If vCurrPage = "" Then vCurrPage = 1
	
	SET cPopular = New CMyFavorite
	cPopular.FPageSize = PageSize
	cPopular.FCurrpage = vCurrPage
	cPopular.FRectDisp = vDisp
	cPopular.FRectSortMethod = vSort
	cPopular.FRectUserID = GetLoginUserID()
	cPopular.fnPopularList_CT
%>

<% If (cPopular.FResultCount > 0) Then %>
	<% For i = 0 To cPopular.FResultCount-1 %>
		<li>
			<div class="wishPdtWrapV15a">
				<div class="wishPicV15a">
					<a href="" onclick="fnAPPpopupProduct('<%=cPopular.FItemList(i).FItemID%>');return false;" id="Hlink"><img src="<% = cPopular.FItemList(i).FImageBasic %>" alt="<%= cPopular.FItemList(i).FItemName %>"></a>

					<% ''// 세일 마커 redCpn , grnCpn %>
					<% if cPopular.FItemList(i).IsSaleItem or cPopular.FItemList(i).isCouponItem Then %>
						<%
						dim getcouponSalePro	''세일+쿠폰세일
						getcouponSalePro = CLng((cPopular.FItemList(i).FOrgPrice-cPopular.FItemList(i).GetCouponAssignPrice)*100/cPopular.FItemList(i).FOrgPrice)& "%"

						IF cPopular.FItemList(i).IsFreeBeasongCoupon() AND cPopular.FItemList(i).IsSaleItem then
							vSaleFreeDeliv = "+무료배송"
						End IF 
						%>

						<% IF cPopular.FItemList(i).IsSaleItem then %>
							<div class="wishCpnV15a redCpn"><span><%=cPopular.FItemList(i).getSalePro%><%= vSaleFreeDeliv %></span></div>
						<% End If %>

						<% IF cPopular.FItemList(i).IsCouponItem AND vSaleFreeDeliv = ""  Then %>
							<% if getcouponSalePro <> "0%" then %>
								<div class="wishCpnV15a grnCpn">
									<span><%= getcouponSalePro %></span>
								</div>
							<% else %>
								<div class="wishCpnV15a grnCpn">
									<span>무료배송</span>
								</div>
							<% end if %>
						<% end if %>

					<% end if %>

					<div class="wishViewV15a <% If cPopular.FItemList(i).FisMyWishChk="1" Then %>wishOn<% end if %>" onclick="goWishPop('<%= cPopular.FItemList(i).FItemID %>','<%=cPopular.FItemList(i).FisMyWishChk%>');" id="Hlink2<%=cPopular.FItemList(i).FItemID%>">
						<span id="wish<%=cPopular.FItemList(i).FItemID%>"><%=cPopular.FItemList(i).FFavCount%></span>
					</div>

				</div>
				<div class="wishContV15a">
					<p class="name"><% = cPopular.FItemList(i).FItemName %></p>
					<% if cPopular.FItemList(i).IsSaleItem or cPopular.FItemList(i).isCouponItem Then %>
						<% IF cPopular.FItemList(i).IsSaleItem and cPopular.FItemList(i).isCouponItem then %>
							<p class="price" onclick="fnAPPpopupProduct('<%=cPopular.FItemList(i).FItemID %>');"><%=FormatNumber(cPopular.FItemList(i).GetCouponAssignPrice,0)%>원</p>
						<% elseif cPopular.FItemList(i).IsSaleItem then %>
							<p class="price" onclick="fnAPPpopupProduct('<%=cPopular.FItemList(i).FItemID %>');"><%=FormatNumber(cPopular.FItemList(i).getRealPrice,0)%>원</p>
						<% else %>
							<p class="price" onclick="fnAPPpopupProduct('<%=cPopular.FItemList(i).FItemID %>');"><%=FormatNumber(cPopular.FItemList(i).GetCouponAssignPrice,0)%>원</p>
						<% End If %>
					<% else %>
						<p class="price"><%=FormatNumber(cPopular.FItemList(i).getRealPrice,0)%>원</p>
					<% end if %>
					<!--<p class="wisher" onclick="fnAPPpopupBrowserURL('위시 프로필','<%=wwwUrl%>/apps/appcom/wish/web2014/my10x10/myWish/myWish.asp?ucid=<%=Server.UrlEncode(tenEnc(cPopular.FItemList(i).Fuserid))%>');" id="Hlink3"><%=printUserId(cPopular.FItemList(i).Fuserid,2,"*")%></p>-->
				</div>
			</div>
		</li>
	<% Next %>
<% end if %>
<%
SET cPopular = Nothing
%>
<!-- #include virtual="/lib/db/dbCTclose.asp" -->