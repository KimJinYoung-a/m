<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#############################################################
'	Description : 클리어런스 세일 M
'	History		: 2016.01.18 유태욱 생성
'	History		: 2017 리뉴얼 : 
'#############################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/clearancesale/clearancesaleCls.asp"-->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->

<%
''dim soldoutyn	''품절상품 포함,제외
dim i
dim catecode, SortMet , vSaleFreeDeliv
dim PageSize, CurrPage
dim classStr, adultChkFlag, adultPopupLink, linkUrl

dim flo1, flo2, flo3
dim Price, minPrice, maxPrice

	SortMet = requestCheckVar(request("atype"),7)
	catecode = getNumeric(requestCheckVar(Request("disp"),3))
	PageSize = getNumeric(requestCheckVar(request("psz"),9))
	CurrPage = getNumeric(requestCheckVar(request("cpg"),9))

	price =	requestCheckVar(Request("price"),3)
	flo1 =	requestCheckVar(Request("flo1"),4) '// 무료배송
	flo2 =	requestCheckVar(Request("flo2"),6) '// 텐바이텐 배송
	flo3 =	requestCheckVar(Request("flo3"),8) '// 포장상품여부

	if CurrPage="" then CurrPage=1
	if PageSize ="" then PageSize =20
	
	If isNumeric(CurrPage) = False Then
		Response.Write "<script>alert('잘못된 경로입니다.');location.href='/';</script>"
		dbget.close()
		Response.End
	End If
	
	if SortMet="" then SortMet="be"		''기본 인기순 정렬
	if price = "" then price = "all"	''가격대별 정렬

	'가격대별
	Select Case price
		Case "0"
			minPrice = "1"
			maxPrice = "9999"
		Case "1"
			minPrice = "10000"
			maxPrice = "29999"
		Case "3"
			minPrice = "30000"
			maxPrice = "49999"
		Case "5"
			minPrice = "50000"
			maxPrice = "99999"
		Case "10"
			minPrice = "100000"
			maxPrice = "10000000"
	end Select
	
	''클리어런스 상품 리스트
	dim oclearancelist,iLp, vWishArr
	set oclearancelist = new CClearancesalelist
		oclearancelist.FPageSize = PageSize
		oclearancelist.FCurrPage = CurrPage
		oclearancelist.FdeliType1 = flo1
		oclearancelist.FdeliType2 = flo2
		oclearancelist.Fpojangok  = flo3
		oclearancelist.FRectSortMethod=SortMet	''정렬기준
		oclearancelist.FRectCateCode = catecode	''카테고리
		oclearancelist.FminPrice = minPrice	''최소금액
		oclearancelist.FmaxPrice = maxPrice	''최대금액
		oclearancelist.fnGetClearancesaleList

	if IsUserLoginOK then
		'// 검색결과 상품목록 작성
		dim rstArrItemid: rstArrItemid=""
		IF oclearancelist.FResultCount >0 then
			For iLp=0 To oclearancelist.FResultCount -1
				rstArrItemid = rstArrItemid & chkIIF(rstArrItemid="","",",") & oclearancelist.FItemList(iLp).FItemID
			Next
		End if
		'// 위시결과 상품목록 작성
		if rstArrItemid<>"" then
			Call getMyFavItemList(getLoginUserid(),rstArrItemid,vWishArr)
		end if
	end if	
%>
<% IF oclearancelist.FResultCount > 0 THEN %>
	<% 
		For i=0 To oclearancelist.FResultCount-1 
			classStr = ""
			linkUrl = "/category/category_itemPrd.asp?itemid="& oclearancelist.FItemList(i).FItemID 
			adultChkFlag = session("isAdult") <> true and oclearancelist.FItemList(i).FadultType = 1																	
			
			if adultChkFlag then
				classStr = addClassStr(classStr,"adult-item")								
			end if																	
	%>
	<li class="<%=classStr%>" <%=chkIIF(adultChkFlag, "onclick=""confirmAdultAuth('"&linkUrl&"');""","")%>>
		<a href="/category/category_itemPrd.asp?itemid=<%= oclearancelist.FItemList(i).FItemID %>">
			<%'// 해외직구배송작업추가 %>
			<% If oclearancelist.FItemList(i).IsDirectPurchase Then %>
				<span class="abroad-badge">해외직구</span>
			<% End If %>
			<div class="thumbnail">
				<img src="<%= getThumbImgFromURL(oclearancelist.FItemList(i).FImageBasic,286,286,"true","false") %>" alt="" />
				<% if adultChkFlag then %>									
				<div class="adult-hide">
					<p>19세 이상만 <br />구매 가능한 상품입니다</p>
				</div>
				<% end if %>											
				<%=CHKIIF(oclearancelist.FItemList(i).isSoldOut,"<b class='soldout'>일시 품절</b>","")%>
			</div>
			<div class="desc">
				<span class="brand"><% = oclearancelist.FItemList(i).FBrandName %></span>
				<p class="name"><% = oclearancelist.FItemList(i).FItemName %></p>
				<div class="price">
					<%
'						IF oclearancelist.FItemList(i).IsFreeBeasongCoupon() AND oclearancelist.FItemList(i).IsSaleItem then
'							vSaleFreeDeliv = "<div class=""tag shipping""><span class=""icon icon-shipping""><i>무료배송</i></span> FREE</div>"
'						End IF

						If oclearancelist.FItemList(i).IsSaleItem AND oclearancelist.FItemList(i).isCouponItem Then	'### 쿠폰 O 세일 O
							Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oclearancelist.FItemList(i).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
							Response.Write "&nbsp;<b class=""discount color-red"">" & oclearancelist.FItemList(i).getSalePro & "</b>"
							If oclearancelist.FItemList(i).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
								If InStr(oclearancelist.FItemList(i).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
									Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
								Else
									Response.Write "&nbsp;<b class=""discount color-green"">" & oclearancelist.FItemList(i).GetCouponDiscountStr & "<small>쿠폰</small></b>"
								End If
							End If
							Response.Write "</div>" &  vbCrLf
						ElseIf oclearancelist.FItemList(i).IsSaleItem AND (Not oclearancelist.FItemList(i).isCouponItem) Then	'### 쿠폰 X 세일 O
							Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oclearancelist.FItemList(i).getRealPrice,0) & "<span class=""won"">원</span></b>"
							Response.Write "&nbsp;<b class=""discount color-red"">" & oclearancelist.FItemList(i).getSalePro & "</b>"
							Response.Write "</div>" &  vbCrLf
						ElseIf oclearancelist.FItemList(i).isCouponItem AND (NOT oclearancelist.FItemList(i).IsSaleItem) Then	'### 쿠폰 O 세일 X
							Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oclearancelist.FItemList(i).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
							If oclearancelist.FItemList(i).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
								If InStr(oclearancelist.FItemList(i).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
									Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
								Else
									Response.Write "&nbsp;<b class=""discount color-green"">" & oclearancelist.FItemList(i).GetCouponDiscountStr & "<small>쿠폰</small></b>"
								End If
							End If
							Response.Write "</div>" &  vbCrLf
						Else
							Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oclearancelist.FItemList(i).getRealPrice,0) & "<span class=""won"">" & CHKIIF(oclearancelist.FItemList(i).IsMileShopitem," Point","원") & "</span></b></div>" &  vbCrLf
						End If
					%>
				</div>
			</div>
		</a>
		<div class="etc">
			<!-- for dev msg : 리뷰
				1. 리뷰수와 wish수가 1,000건 이상이면 999+로 표시해주세요
				2. 리뷰는 총 평점으로 퍼센트로 표현해주세요. <i style="width:50%;">...</i>
			--> 
			<% if oclearancelist.FItemList(i).FEvalcnt > 0 then %>
				<div class="tag review"><span class="icon icon-rating"><i style="width:<%=fnEvalTotalPointAVG(oclearancelist.FItemList(i).FPoints,"search")%>%;">리뷰 종합 별점</i></span><span class="counting" title="리뷰 갯수"><%=chkIIF(oclearancelist.FItemList(i).FEvalcnt>999,"999+",oclearancelist.FItemList(i).FEvalcnt)%></span></div>
			<% end if %>
			<button class="tag wish btn-wish" onclick="goWishPop('<%=oclearancelist.FItemList(i).FItemid%>','');">
			<%
			If oclearancelist.FItemList(i).FFavCount > 0 Then
				If fnIsMyFavItem(vWishArr,oclearancelist.FItemList(i).FItemID) Then
					Response.Write "<span class=""icon icon-wish on"" id=""wish"&oclearancelist.FItemList(i).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&oclearancelist.FItemList(i).FItemID&""">"
					Response.Write CHKIIF(oclearancelist.FItemList(i).FFavCount>999,"999+",formatNumber(oclearancelist.FItemList(i).FFavCount,0)) & "</span>"
				Else
					Response.Write "<span class=""icon icon-wish"" id=""wish"&oclearancelist.FItemList(i).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&oclearancelist.FItemList(i).FItemID&""">"
					Response.Write CHKIIF(oclearancelist.FItemList(i).FFavCount>999,"999+",formatNumber(oclearancelist.FItemList(i).FFavCount,0)) & "</span>"
				End If
			Else
				Response.Write "<span class=""icon icon-wish"" id=""wish"&oclearancelist.FItemList(i).FItemID&"""><i> wish</i></span><span class=""counting"" id=""cnt"&oclearancelist.FItemList(i).FItemID&"""></span>"
			End If
			%>
			</button>
			<% IF oclearancelist.FItemList(i).IsCouponItem AND oclearancelist.FItemList(i).GetCouponDiscountStr = "무료배송" Then %>
				<div class="tag shipping"><span class="icon icon-shipping"><i>무료배송</i></span> FREE</div>
			<% End If %>
		</div>
	</li>
	<% Next %>
<% end if %>
<% set oclearancelist = nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->