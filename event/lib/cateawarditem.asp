<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/enjoy/shoppingchanceCls.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/award/newawardcls_B.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%

Dim atype, vDisp, vSaleFreeDeliv
dim Dategubun : Dategubun = RequestCheckVar(request("dategubun"),1)	'기간별 검색 w:주간, m:월간
vDisp = RequestCheckVar(request("disp"),6)
atype = RequestCheckVar(request("atype"),2)
dim CurrPage : CurrPage = getNumeric(request("cpg"))
Dim gaparam, userid
dim classStr, adultChkFlag, adultPopupLink, linkUrl
userid = getLoginUserid()

if Dategubun="" then Dategubun="d"
if CurrPage="" then CurrPage=1
if atype="" then atype="dt"		'fnATYPErandom()

Dim minPrice '검색 최저가
Dim oaward, i, iLp, sNo, eNo, tPg, chgtype, vWishArr, vZzimArr

chgtype = "d" 
minPrice=5000		'//기간별 베스트
gaparam = "&gaparam=tbest_date_"

if Dategubun <> "d" then
	set oaward = new CAWard
		oaward.FPageSize = 200
		oaward.FRectDategubun 		= Dategubun
		oaward.FRectCateCode		= vDisp
		oaward.GetCategoryBestItemList
else
	set oaward = Nothing
	set oaward = new SearchItemCls
		oaward.FListDiv 			= "bestlist"
		oaward.FRectSortMethod	    = "be"
		oaward.FPageSize 			= 200
		oaward.FCurrPage 			= 1
		oaward.FSellScope			= "Y"
		oaward.FScrollCount 		= 1
		oaward.FRectSearchItemDiv   ="D"
		oaward.FRectCateCode		= vDisp
		oaward.FminPrice			= minPrice
		oaward.FawardType			= "period"
		oaward.getSearchList
end if

'//기본형 
If atype = "dt" Then

	if CurrPage=1 then
		sNo=0
		eNo=5
	else
		sNo=(CurrPage-1) * 6
		eNo=(CurrPage * 6)-1
	end if

	if (oaward.FResultCount-1)<eNo then eNo = oaward.FResultCount-1

	tPg = (oaward.FResultCount\6)
	if (tPg<>(oaward.FResultCount/6)) then tPg = tPg +1

	If oaward.FResultCount > sNo Then
		If oaward.FResultCount Then
			For i=sNo to eNo
				classStr = ""
				if isapp then 
					linkUrl = "javascript:fnAPPpopupAutoUrl('/category/category_itemPrd.asp?itemid="& oaward.FItemList(i).FItemID &"');"
				else
					linkUrl = "/category/category_itemPrd.asp?itemid="& oaward.FItemList(i).FItemID & gaparam & i+1
				end if 
				adultChkFlag = session("isAdult") <> true and oaward.FItemList(i).FadultType = 1																	
				
				if adultChkFlag then
					classStr = addClassStr(classStr,"adult-item")								
				end if					
%>
				<li>				
					<a href="<%=linkUrl%>">
						<div class="thumbnail">
							<img src="<%=getThumbImgFromURL(oaward.FItemList(i).FImageBasic,"286","286","true","false") %>" alt="" />
							<% if adultChkFlag then %>									
							<div class="adult-hide">
								<p>19세 이상만 <br />구매 가능한 상품입니다</p>
							</div>
							<% end if %>								
						</div>
						<div class="desc">
							<div class="price">
							<%
								If oaward.FItemList(i).IsSaleItem AND oaward.FItemList(i).isCouponItem Then	'### 쿠폰 O 세일 O
									Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oaward.FItemList(i).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
									Response.Write "&nbsp;<b class=""discount color-red"">" & oaward.FItemList(i).getSalePro & "</b>"
									If oaward.FItemList(i).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
										If InStr(oaward.FItemList(i).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
											Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
										Else
											Response.Write "&nbsp;<b class=""discount color-green"">" & oaward.FItemList(i).GetCouponDiscountStr & "</b>"
										End If
									End If
									Response.Write "</div>" &  vbCrLf
								ElseIf oaward.FItemList(i).IsSaleItem AND (Not oaward.FItemList(i).isCouponItem) Then	'### 쿠폰 X 세일 O
									Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oaward.FItemList(i).getRealPrice,0) & "<span class=""won"">원</span></b>"
									Response.Write "&nbsp;<b class=""discount color-red"">" & oaward.FItemList(i).getSalePro & "</b>"
									Response.Write "</div>" &  vbCrLf
								ElseIf oaward.FItemList(i).isCouponItem AND (NOT oaward.FItemList(i).IsSaleItem) Then	'### 쿠폰 O 세일 X
									Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oaward.FItemList(i).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
									If oaward.FItemList(i).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
										If InStr(oaward.FItemList(i).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
											Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
										Else
											Response.Write "&nbsp;<b class=""discount color-green"">" & oaward.FItemList(i).GetCouponDiscountStr & "</b>"
										End If
									End If
									Response.Write "</div>" &  vbCrLf
								Else
									Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oaward.FItemList(i).getRealPrice,0) & "<span class=""won"">" & CHKIIF(oaward.FItemList(i).IsMileShopitem," Point"," 원") & "</span></b></div>" &  vbCrLf
								End If
							%>
							</div>
							<p class="name"><%=oaward.FItemList(i).FItemName %></p>
						</div>
					</a>
				</li>
<% 
			vSaleFreeDeliv = ""
			Next 
		End If
	End If
End If 
set oaward = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->