<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
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
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'####################################################
' Description : 정기세일 BEST 기간별
' History : 2020-03-20 이종화
'####################################################
Dim flag, atype, vDisp, vSaleFreeDeliv
dim Dategubun : Dategubun = RequestCheckVar(request("dategubun"),1)	'기간별 검색 w:주간, m:월간 , d:일간
dim CurrPage : CurrPage = getNumeric(request("cpg"))
Dim gaparam, userid
dim classStr, adultChkFlag, adultPopupLink, linkUrl
dim minPrice '검색 최저가

vDisp = RequestCheckVar(request("vdisp"),3)
flag = RequestCheckVar(request("flag"),1)
atype = RequestCheckVar(request("atype"),2)
userid = getLoginUserid()

if CurrPage="" then CurrPage=1
if atype="" then atype="dt"		'fnATYPErandom()

Dim oaward, i, iLp, sNo, eNo, tPg, chgtype, vWishArr, vZzimArr

'// 정렬방법 통일로 인한 코드 변환
Select Case atype
	Case "ne":
		chgtype = "n"
		minPrice=4500		'신상품
		gaparam = "&gaparam=tbest_new_"
	Case "st":
		chgtype = "t"
		minPrice=4500		'스테디셀러
		gaparam = "&gaparam=tbest_steady_"
	Case "vi":
		chgtype = "i"
		minPrice=10000		'후기
		gaparam = "&gaparam=tbest_vip_"
	Case "dt": 
		chgtype = "d" 
		minPrice=5000		'기간별 베스트
		gaparam = "&gaparam=tbest_date_"
	Case Else:
		chgtype = "b"
		minPrice=4500		'기본값(인기순)
End Select

if chgtype="n" then
    ''신상품 베스트
    set oaward = new SearchItemCls
	    oaward.FListDiv 		= "newlist"
	    oaward.FRectSortMethod	= "be"
	    oaward.FRectSearchFlag 	= "newitem"
	    oaward.FPageSize 		= 200
	    oaward.FCurrPage 		= 1
	    oaward.FSellScope		= "Y"
	    oaward.FScrollCount 	= 1
	    oaward.FRectSearchItemDiv ="D"
	    oaward.FRectCateCode	  = vDisp
	    oaward.FminPrice	= minPrice
	    oaward.FSalePercentLow = 0.89
	    oaward.getSearchList
ElseIf chgtype = "t" Then  '//스테디 베스트
	set oaward = new CAWard
		oaward.FPageSize = 200
		oaward.FRectCateCode		= vDisp
		oaward.GetSteadyItemList_2017

	If (oaward.FResultCount < 3) Then
		set oaward = Nothing
		set oaward = new SearchItemCls
			oaward.FListDiv 			= "bestlist"
			oaward.FRectSortMethod	    = "be"
			''oaward.FRectSearchFlag 	= "newitem"  ''검색범위
			oaward.FPageSize 			= 200
			oaward.FCurrPage 			= 1
			oaward.FSellScope			= "Y"
			oaward.FScrollCount 		= 1
			oaward.FRectSearchItemDiv   ="D"
			oaward.FRectCateCode		= vDisp
			oaward.FminPrice	= minPrice
			oaward.getSearchList
	End if
ElseIf chgtype = "i" Then
	Dim chkCnt
	set oaward = new CAWard
	oaward.FPageSize = 200
	oaward.FRectCateCode		= vDisp
	oaward.GetVIPItemList_2017

	'// 3개 이하일 경우엔 하단 상품후기 부분 가려야 되므로 체킹함
	chkCnt = oaward.FResultCount

	If (oaward.FResultCount < 3) Then
		set oaward = Nothing
		set oaward = new SearchItemCls
			oaward.FListDiv 			= "bestlist"
			oaward.FRectSortMethod	    = "be"
			''oaward.FRectSearchFlag 	= "newitem"  ''검색범위
			oaward.FPageSize 			= 200
			oaward.FCurrPage 			= 1
			oaward.FSellScope			= "Y"
			oaward.FScrollCount 		= 1
			oaward.FRectSearchItemDiv   ="D"
			oaward.FRectCateCode		= vDisp
			oaward.FminPrice	= minPrice
			oaward.getSearchList
	End if
ElseIf chgtype = "d" Then 	'기간별 검색
	if Dategubun <> "d" then
		set oaward = new CAWard
			oaward.FPageSize = 200
			oaward.FRectDategubun 		= Dategubun
			oaward.FRectCateCode		= vDisp
			oaward.GetDateItemList
	else
		set oaward = Nothing
		set oaward = new SearchItemCls
			oaward.FListDiv 			= "bestlist"
			oaward.FRectSortMethod	    = "be"
			''oaward.FRectSearchFlag 	= "newitem"  ''검색범위
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
	If (oaward.FResultCount < 3) Then
		set oaward = Nothing
		set oaward = new SearchItemCls
			oaward.FListDiv 			= "bestlist"
			oaward.FRectSortMethod	    = "be"
			''oaward.FRectSearchFlag 	= "newitem"  ''검색범위
			oaward.FPageSize 			= 200
			oaward.FCurrPage 			= 1
			oaward.FSellScope			= "Y"
			oaward.FScrollCount 		= 1
			oaward.FRectSearchItemDiv   ="D"
			oaward.FRectCateCode		= vDisp
			oaward.FminPrice			= minPrice
			oaward.FawardType			= "period"
			oaward.getSearchList
	End if
else
    set oaward = new CAWard
	    oaward.FPageSize = 200
	    oaward.FRectDisp1   = vDisp
		oaward.FRectAwardgubun = chgtype
		oaward.GetNormalItemList

	If (oaward.FResultCount < 3) Then
		set oaward = Nothing
		set oaward = new SearchItemCls
	        oaward.FListDiv 			= "bestlist"
	        oaward.FRectSortMethod	    = "be"
	        ''oaward.FRectSearchFlag 	= "newitem"  ''검색범위
	        oaward.FPageSize 			= 200
	        oaward.FCurrPage 			= 1
	        oaward.FSellScope			= "Y"
	        oaward.FScrollCount 		= 1
	        oaward.FRectSearchItemDiv   ="D"
	        oaward.FRectCateCode		= vDisp
	        oaward.FminPrice	= minPrice
	        oaward.getSearchList
	End if
end If

if IsUserLoginOK then
	'// 검색결과 상품목록 작성
	dim rstArrItemid: rstArrItemid=""	'위시체크
	dim rstArrBrand: rstArrBrand=""		'찜브랜드체크
	IF oaward.FResultCount >0 then
		For iLp=0 To oaward.FResultCount -1
			rstArrItemid = rstArrItemid & chkIIF(rstArrItemid="","",",") & oaward.FItemList(iLp).FItemID
			rstArrBrand = rstArrBrand & chkIIF(rstArrBrand="","","|,|") & oaward.FItemList(iLp).FMakerid
		Next
	End if
	'// 위시결과 상품목록 작성
	if rstArrItemid<>"" then
		Call getMyFavItemList(getLoginUserid(),rstArrItemid,vWishArr)
	end if
	'// 찜브랜드결과 상품목록 작성
	if rstArrBrand<>"" then
		rstArrBrand = "|"&rstArrBrand&"|"
		Call getMyZzimBrandList(getLoginUserid(),rstArrBrand,vZzimArr)
	end if
end if	

'//기본형 
If atype = "ne" Or atype = "be" Or atype = "ws" Or atype = "hs" Or atype = "st" Or atype = "dt" Or atype = "lv" Or atype = "ag"  Or atype = "mz" Or atype = "fo" Then
	if CurrPage=1 then
		sNo=0
		eNo=19
	else
		sNo=(CurrPage-1) * 20
		eNo=(CurrPage * 20)-1
	end if

	if (oaward.FResultCount-1)<eNo then eNo = oaward.FResultCount-1

	tPg = (oaward.FResultCount\20)
	if (tPg<>(oaward.FResultCount/20)) then tPg = tPg +1

	If oaward.FResultCount > sNo Then
		If oaward.FResultCount Then
			For i=sNo to eNo
				classStr = ""
				linkUrl = "/category/category_itemPrd.asp?itemid="& oaward.FItemList(i).FItemID & gaparam & i+1
				adultChkFlag = session("isAdult") <> true and oaward.FItemList(i).FadultType = 1																	
				
				if adultChkFlag then
					classStr = addClassStr(classStr,"adult-item")								
				end if					
%>
				<li class="<%=classStr%>" <%=chkIIF(adultChkFlag, "onclick=""confirmAdultAuth('"&linkUrl&"');""","")%>>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupAutoUrl('/category/category_itemPrd.asp?itemid=<%=oaward.FItemList(i).FItemID%>');return false;">
				<% Else %>
					<a href="/category/category_itemprd.asp?itemid=<%=oaward.FItemList(i).FItemId%>">
				<% End If %>
						<div class="thumbnail">
							<img src="<%=getThumbImgFromURL(oaward.FItemList(i).FImageBasic,"286","286","true","false") %>" alt="" />
							<% if adultChkFlag then %>									
							<div class="adult-hide">
								<p>19세 이상만 <br />구매 가능한 상품입니다</p>
							</div>
							<% end if %>
							<div class="badge"><%= i+1 %></div>
							<% IF oaward.FItemList(i).IsCouponItem AND oaward.FItemList(i).GetCouponDiscountStr = "무료배송" Then %>
							<div class="badge-group">
								<div class="badge-item badge-delivery">무료배송</div>
							</div>
							<% End If %>
						</div>
						<div class="desc">
							<div class="price-area">
								<%
									If oaward.FItemList(i).IsSaleItem AND oaward.FItemList(i).isCouponItem Then	'### 쿠폰 O 세일 O
										Response.Write "<span class=""price"">" & FormatNumber(oaward.FItemList(i).GetCouponAssignPrice,0) & "</span>"
										Response.Write "<b class=""discount sale"">" & oaward.FItemList(i).getSalePro & "</b>"
										If oaward.FItemList(i).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
											If InStr(oaward.FItemList(i).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
												Response.Write "<b class=""discount coupon""><small>쿠폰</small></b>"
											Else
												Response.Write "<b class=""discount coupon"">" & oaward.FItemList(i).GetCouponDiscountStr & "</b>"
											End If
										End If
										
									ElseIf oaward.FItemList(i).IsSaleItem AND (Not oaward.FItemList(i).isCouponItem) Then	'### 쿠폰 X 세일 O
										Response.Write "<span class=""price"">" & FormatNumber(oaward.FItemList(i).getRealPrice,0) & "</b>"
										Response.Write "<b class=""discount sale"">" & oaward.FItemList(i).getSalePro & "</b>"
										
									ElseIf oaward.FItemList(i).isCouponItem AND (NOT oaward.FItemList(i).IsSaleItem) Then	'### 쿠폰 O 세일 X
										Response.Write "<span class=""price"">" & FormatNumber(oaward.FItemList(i).GetCouponAssignPrice,0) & "</b>"
										If oaward.FItemList(i).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
											If InStr(oaward.FItemList(i).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
												Response.Write "<b class=""discount coupon""><small>쿠폰</small></b>"
											Else
												Response.Write "<b class=""discount coupon"">" & oaward.FItemList(i).GetCouponDiscountStr & "</b>"
											End If
										End If
									Else
										Response.Write "<span class=""price"">" & FormatNumber(oaward.FItemList(i).getRealPrice,0) & "</span>" &  vbCrLf
									End If
								%>
							</div>
							<p class="name"><%=oaward.FItemList(i).FItemName %></p>
							<span class="brand"><%=oaward.FItemList(i).FBrandName %></span>
						</div>
						<div class="etc">								
							<% if oaward.FItemList(i).FEvalcnt > 0 then %>
								<div class="tag review"><span class="icon icon-rating"><i style="width:<%=fnEvalTotalPointAVG(oaward.FItemList(i).FPoints,"search")%>%;">리뷰 종합 별점</i></span><span class="counting" title="리뷰 갯수"><%=chkIIF(oaward.FItemList(i).FEvalcnt>999,"999+",oaward.FItemList(i).FEvalcnt)%></span></div>
							<% end if %>
							<button class="tag wish btn-wish">
							<%
							If oaward.FItemList(i).FFavCount > 0 Then
								If fnIsMyFavItem(vWishArr,oaward.FItemList(i).FItemID) Then
									Response.Write "<span class=""icon icon-wish on"" id=""wish"&oaward.FItemList(i).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&oaward.FItemList(i).FItemID&""">"
									Response.Write CHKIIF(oaward.FItemList(i).FFavCount>999,"999+",formatNumber(oaward.FItemList(i).FFavCount,0)) & "</span>"
								Else
									Response.Write "<span class=""icon icon-wish"" id=""wish"&oaward.FItemList(i).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&oaward.FItemList(i).FItemID&""">"
									Response.Write CHKIIF(oaward.FItemList(i).FFavCount>999,"999+",formatNumber(oaward.FItemList(i).FFavCount,0)) & "</span>"
								End If
							Else
								Response.Write "<span class=""icon icon-wish"" id=""wish"&oaward.FItemList(i).FItemID&"""><i> wish</i></span><span class=""counting"" id=""cnt"&oaward.FItemList(i).FItemID&"""></span>"
							End If
							%>
							</button>
						</div>
					</a>
				</li>
	<% 
			vSaleFreeDeliv = ""
			Next 
		End If
	End If
End If
' 후기
If atype = "vi" Then
	if CurrPage=1 then
		sNo=0
		eNo=9
	else
		sNo=(CurrPage-1) * 10
		eNo=(CurrPage * 10)-1
	end if

	if (oaward.FResultCount-1)<eNo then eNo = oaward.FResultCount-1

	tPg = (oaward.FResultCount\10)
	if (tPg<>(oaward.FResultCount/10)) then tPg = tPg +1

	If oaward.FResultCount > sNo Then
		If oaward.FResultCount Then
			For i=sNo to eNo
				classStr = ""
				linkUrl = "/category/category_itemPrd.asp?itemid="& oaward.FItemList(i).FItemID & gaparam & i+1
				adultChkFlag = session("isAdult") <> true and oaward.FItemList(i).FadultType = 1																	
				
				if adultChkFlag then
					classStr = addClassStr(classStr,"adult-item")								
				end if														
	%>
				<li class="<%=classStr%>" <%=chkIIF(adultChkFlag, "onclick=""confirmAdultAuth('"&linkUrl&"');""","")%>>
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupAutoUrl('/category/category_itemPrd.asp?itemid=<%=oaward.FItemList(i).FItemID%>');return false;">
				<% Else %>
					<a href="/category/category_itemprd.asp?itemid=<%=oaward.FItemList(i).FItemID%>">
				<% End If %>
						<b class="no"><span class="rank"><%= i+1 %></span></b>
						<div class="thumbnail">
							<img src="<%=getThumbImgFromURL(oaward.FItemList(i).FImageBasic,"200","200","true","false") %>" alt="" />
							<% if adultChkFlag then %>
							<div class="adult-hide">
								<p>19세 이상만 <br />구매 가능한 상품입니다</p>
							</div>
							<% end if %>
						</div>
						<div class="desc">
							<span class="brand"><%=oaward.FItemList(i).FBrandName %></span>
							<p class="name"><%=oaward.FItemList(i).FItemName %></p>
							<div class="price">
							<%
								If oaward.FItemList(i).IsSaleItem AND oaward.FItemList(i).isCouponItem Then	'### 쿠폰 O 세일 O
									Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oaward.FItemList(i).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
									Response.Write "&nbsp;<b class=""discount color-red"">" & oaward.FItemList(i).getSalePro & "</b>"
									If oaward.FItemList(i).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
										If InStr(oaward.FItemList(i).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
											Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
										Else
											Response.Write "&nbsp;<b class=""discount color-green"">" & oaward.FItemList(i).GetCouponDiscountStr & "<small>쿠폰</small></b>"
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
											Response.Write "&nbsp;<b class=""discount color-green"">" & oaward.FItemList(i).GetCouponDiscountStr & "<small>쿠폰</small></b>"
										End If
									End If
									Response.Write "</div>" &  vbCrLf
								Else
									Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oaward.FItemList(i).getRealPrice,0) & "<span class=""won"">" & CHKIIF(oaward.FItemList(i).IsMileShopitem," Point"," 원") & "</span></b></div>" &  vbCrLf
								End If
							%>
							</div>
						</div>
						<% If chkCnt > 2 Then %>
							<% If oaward.FItemList(i).FevaContents <> "" Then %>
								<div class="review-desc">
									<p><%=chrbyte(oaward.FItemList(i).FevaContents, "140","Y")%></p>
									<div class="review">
										<span class="id"><%= printUserId(oaward.FItemList(i).FevaUserid,2,"*") %></span>
										<span class="icon icon-rating"><i style="width:<%=oaward.FItemList(i).FevaTotalpoint*20%>%;"><%=oaward.FItemList(i).FevaTotalpoint*20%>점</i></span>
									</div>
								</div>
							<% End If %>
						<% End If %>
					</a>
					<div class="etc">
						<button class="tag wish btn-wish" onclick="goWishPop('<%=oaward.FItemList(i).FItemid%>','');">
						<%
						If oaward.FItemList(i).FFavCount > 0 Then
							If fnIsMyFavItem(vWishArr,oaward.FItemList(i).FItemID) Then
								Response.Write "<span class=""icon icon-wish on"" id=""wish"&oaward.FItemList(i).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&oaward.FItemList(i).FItemID&""">"
								Response.Write CHKIIF(oaward.FItemList(i).FFavCount>999,"999+",formatNumber(oaward.FItemList(i).FFavCount,0)) & "</span>"
							Else
								Response.Write "<span class=""icon icon-wish"" id=""wish"&oaward.FItemList(i).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&oaward.FItemList(i).FItemID&""">"
								Response.Write CHKIIF(oaward.FItemList(i).FFavCount>999,"999+",formatNumber(oaward.FItemList(i).FFavCount,0)) & "</span>"
							End If
						Else
							Response.Write "<span class=""icon icon-wish"" id=""wish"&oaward.FItemList(i).FItemID&"""><i> wish</i></span><span class=""counting"" id=""cnt"&oaward.FItemList(i).FItemID&"""></span>"
						End If
						%>
						</button>
					</div>
				</li>
	<%
			Next
		End If
	End If
End If
set oaward = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->