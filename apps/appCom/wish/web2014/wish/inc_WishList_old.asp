<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
response.charset = "utf-8"
%>

<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/wish/WishCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
Dim vSaleFreeDeliv
Dim vListGubun : vListGubun = requestCheckVar(request("LstGun"),12)
Dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),9))
Dim CurrPage 	: CurrPage = getNumeric(requestCheckVar(request("cpg"),9))
Dim vUserid		: vUserid = GetencLoginUserID()
Dim vCateCode : vCateCode = requestCheckVar(request("catecode"),12)

If CurrPage="" Then CurrPage=0
If PageSize="" Then PageSize = 10

Dim oDoc,iLp, TotalCnt, i, fCnt, mCnt

If Trim(vListGubun)="FollowList" Then
	Set oDoc = new CAutoWish
		oDoc.FPageSize 			= PageSize
		oDoc.FCurrPage 			= CurrPage
		oDoc.FuserID				= vUserid
		oDoc.GetWishFollowingCnt

		fCnt = oDoc.FFollowingCnt

	SET oDoc = Nothing
End If

If Trim(vListGubun)="MateList" Then
	Set oDoc = new CAutoWish
		oDoc.FPageSize 			= PageSize
		oDoc.FCurrPage 			= CurrPage
		oDoc.FuserID				= vUserid
		oDoc.GetWishMatchingCntList

		mCnt = oDoc.FchkResult

	SET oDoc = Nothing
End If


Select Case Trim(vListGubun)
	Case "TrendList"
		Set oDoc = new CAutoWish
			oDoc.FPageSize 			= PageSize
			oDoc.FCurrPage 			= CurrPage
			oDoc.FuserID				= vUserid
			oDoc.GetWishTrendList
	Case "FollowList"
		Set oDoc = new CAutoWish
			oDoc.FPageSize 			= PageSize
			oDoc.FCurrPage 			= CurrPage
			oDoc.FuserID				= vUserid
			oDoc.GetWishFollowList
	Case "MateList"
		Set oDoc = new CAutoWish
			oDoc.FPageSize 			= PageSize
			oDoc.FCurrPage 			= CurrPage
			oDoc.FuserID				= vUserid
			oDoc.GetWishMateList
	Case "CateList"
		Set oDoc = new CAutoWish
			oDoc.FPageSize 			= PageSize
			oDoc.FCurrPage 			= CurrPage
			oDoc.FuserID				= vUserid
			oDoc.FCateCode			= vCateCode
			oDoc.GetWishCategoryList
	Case Else
		Set oDoc = new CAutoWish
			oDoc.FPageSize 			= PageSize
			oDoc.FCurrPage 			= CurrPage
			oDoc.FuserID				= vUserid
			oDoc.GetWishTrendList
End Select
			

TotalCnt = oDoc.FResultCount

%>

<% IF oDoc.FResultCount >0 then %>
	<%
	For i=0 To TotalCnt-1

	IF (i <= TotalCnt-1) Then

	dim imgmod
	imgmod = (i+5) mod 5
	%>

		<li>
			<div class="wishPdtWrapV15a">
				<div class="wishPicV15a">
					<a href="" onclick="fnAPPpopupProduct('<%=oDoc.FWishPrdList(i).FItemID%>');return false;" id="Hlink">
						<% if imgmod = 0 then %>
								<img src="<% = oDoc.FWishPrdList(i).FImageBasic %>" alt="<% = oDoc.FWishPrdList(i).FItemName %>">
						<% else %>
							<img src="<% = oDoc.FWishPrdList(i).FImageList %>" alt="<% = oDoc.FWishPrdList(i).FItemName %>">
						<% end if %>
					</a>
					<% If oDoc.FWishPrdList(i).IsSoldOut Then %>
						<% ''// 품절 %>
					<% End if %>

					<% ''// 세일 마커 redCpn , grnCpn %>
					<% if oDoc.FWishPrdList(i).IsSaleItem or oDoc.FWishPrdList(i).isCouponItem Then %>
						<%
						dim getcouponSalePro	''세일+쿠폰세일
						getcouponSalePro = CLng((oDoc.FWishPrdList(i).FOrgPrice-oDoc.FWishPrdList(i).GetCouponAssignPrice)*100/oDoc.FWishPrdList(i).FOrgPrice)& "%"

						IF oDoc.FWishPrdList(i).IsFreeBeasongCoupon() AND oDoc.FWishPrdList(i).IsSaleItem then
							vSaleFreeDeliv = "+무료배송"
						End IF 
						%>

						<% IF oDoc.FWishPrdList(i).IsSaleItem then %>
							<div class="wishCpnV15a redCpn"><span><%=oDoc.FWishPrdList(i).getSalePro%><%= vSaleFreeDeliv %></span></div>
						<% End If %>

						<% IF oDoc.FWishPrdList(i).IsCouponItem AND vSaleFreeDeliv = ""  Then %>
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

					<div class="wishViewV15a <% If oDoc.FWishPrdList(i).FisMyWishChk="1" Then %>wishOn<% end if %>" onclick="goWishPop('<%= oDoc.FWishPrdList(i).FItemID %>','<%=oDoc.FWishPrdList(i).FisMyWishChk%>');" id="Hlink2<%=oDoc.FWishPrdList(i).FItemID%>">
						<span id="wish<%=oDoc.FWishPrdList(i).FItemID%>"><%=oDoc.FWishPrdList(i).FFavCount%></span>
					</div>

				</div>
				<div class="wishContV15a">
					<p class="name"><% = oDoc.FWishPrdList(i).FItemName %></p>
					<% if oDoc.FWishPrdList(i).IsSaleItem or oDoc.FWishPrdList(i).isCouponItem Then %>
						<% IF oDoc.FWishPrdList(i).IsSaleItem and oDoc.FWishPrdList(i).isCouponItem then %>
							<p class="price" onclick="fnAPPpopupProduct('<%=oDoc.FWishPrdList(i).FItemID %>');"><%=FormatNumber(oDoc.FWishPrdList(i).GetCouponAssignPrice,0)%>원</p>
						<% elseif oDoc.FWishPrdList(i).IsSaleItem then %>
							<p class="price" onclick="fnAPPpopupProduct('<%=oDoc.FWishPrdList(i).FItemID %>');"><%=FormatNumber(oDoc.FWishPrdList(i).getRealPrice,0)%>원</p>
						<% else %>
							<p class="price" onclick="fnAPPpopupProduct('<%=oDoc.FWishPrdList(i).FItemID %>');"><%=FormatNumber(oDoc.FWishPrdList(i).GetCouponAssignPrice,0)%>원</p>
						<% End If %>
					<% else %>
						<p class="price"><%=FormatNumber(oDoc.FWishPrdList(i).getRealPrice,0) & chkIIF(oDoc.FWishPrdList(i).IsMileShopitem,"Point","원")%></p>
					<% end if %>
					<p class="wisher" onclick="fnAPPpopupBrowserURL('위시 프로필','<%=wwwUrl%>/apps/appcom/wish/web2014/my10x10/myWish/myWish.asp?ucid=<%=Server.UrlEncode(tenEnc(oDoc.FWishPrdList(i).Fuserid))%>');" id="Hlink3"><%=printUserId(oDoc.FWishPrdList(i).Fuserid,2,"*")%></p><!-- 아이디는 **포함 10자까지만 노출됩니다 -->
				</div>
			</div>
		</li>
	<% End IF %>
	<% Next %>
<% end if %>
<%
SET oDoc = Nothing
%>

<% If fCnt = 0 And Trim(vListGubun)="FollowList" Then %>
	<script>
		$(function() {
			fnAPPpopupBrowserURL('우리 팔로우 친구 맺을래요?','<%=wwwUrl%>/apps/appcom/wish/web2014/wish/popFollowList.asp','','followfriend'); return false;
		});			
	</script>
<% response.End %>
<% End If %>

<% If mCnt = 0 And Trim(vListGubun)="MateList" Then %>
	<script>
		$(function() {			
			fnAPPpopupBrowserURL('취향이 비슷한 친구 찾기','<%=wwwUrl%>/apps/appcom/wish/web2014/wish/popMateList.asp','','matefriend'); return false;
		});			
	</script>
<% response.End %>
<% End If %>

<!-- #include virtual="/lib/db/dbclose.asp" -->