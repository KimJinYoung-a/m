<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
	Dim vDisp : vDisp = getNumeric(requestCheckVar(request("disp"),15))
	Dim vDepth, i,TotalCnt,vSaleFreeDeliv
		vDepth = "1"
	dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),9))
	dim searchFlag 	: searchFlag = "newlist"
	dim CurrPage 	: CurrPage = getNumeric(requestCheckVar(request("cpg"),9))
	dim SortMet		: SortMet = requestCheckVar(request("srm"),2)
	dim classStr, adultChkFlag, adultPopupLink, linkUrl

	if (CurrPage*PageSize)>1000 then
		'1,000개까지만 표시
		dbget.Close: Response.End
	end if

	dim LoginUserid
	LoginUserid = getLoginUserid()

	dim ListDiv,ScrollCount
	ListDiv="newlist"
	ScrollCount = 5

	if CurrPage="" then CurrPage=1
	PageSize = 20

	If SortMet = "" Then SortMet = "be"

	dim oDoc,iLp, vWishArr
	set oDoc = new SearchItemCls
		oDoc.FListDiv 			= ListDiv
		oDoc.FRectSortMethod	= SortMet
		oDoc.FRectSearchFlag 	= searchFlag
		oDoc.FPageSize 			= PageSize
		oDoc.FRectCateCode			= vDisp
		oDoc.FCurrPage 			= CurrPage
		oDoc.FSellScope 		= "Y"
		oDoc.FScrollCount 		= ScrollCount
		oDoc.getSearchList
		
	TotalCnt = oDoc.FResultCount

	if IsUserLoginOK then
		'// 검색결과 상품목록 작성
		dim rstArrItemid: rstArrItemid=""
		IF oDoc.FResultCount >0 then
			For iLp=0 To oDoc.FResultCount -1
				rstArrItemid = rstArrItemid & chkIIF(rstArrItemid="","",",") & oDoc.FItemList(iLp).FItemID
			Next
		End if
		'// 위시결과 상품목록 작성
		if rstArrItemid<>"" then
			Call getMyFavItemList(getLoginUserid(),rstArrItemid,vWishArr)
		end if
	end if
%>
<% 
	For i=0 To oDoc.FResultCount-1 

		classStr = ""		
		linkUrl = replace(Request.ServerVariables("PATH_INFO"), "act_newitem.asp","newitem.asp") & "?" & GetParam("adtprdid=" & oDoc.FItemList(i).FItemID & "&cpg=")								
		adultChkFlag = session("isAdult") <> true and oDoc.FItemList(i).FadultType = 1																					

		if oDoc.FItemList(i).isSoldOut then
			classStr = addClassStr(classStr,"class=soldOut")								
		end if
		if adultChkFlag then
			classStr = addClassStr(classStr,"adult-item")								
		end if																							
%>
<li class="<%=classStr%>" <%=chkIIF(adultChkFlag, "onclick=""confirmAdultAuth('"& linkUrl &"', "& chkiif(IsUserLoginOK, "true", "false") &");""","")%>>				
	<a href="" onclick="fnAPPpopupProduct('<%=oDoc.FItemList(i).FItemID%>');return false;">
		<%'// 해외직구배송작업추가 %>
		<% If oDoc.FItemList(i).IsDirectPurchase Then %>
			<span class="abroad-badge">해외직구</span>
		<% End If %>
		<div class="thumbnail">
			<img src="<%= getThumbImgFromURL(oDoc.FItemList(i).FImageBasic,286,286,"true","false") %>" alt="" />
			<% if adultChkFlag then %>									
			<div class="adult-hide">
				<p>19세 이상만 <br />구매 가능한 상품입니다</p>
			</div>
			<% end if %>												
			<%=CHKIIF(oDoc.FItemList(i).isSoldOut,"<b class='soldout'>일시 품절</b>","")%>
		</div>
		<div class="desc">
			<span class="brand"><% = oDoc.FItemList(i).FBrandName %></span>
			<p class="name"><% = oDoc.FItemList(i).FItemName %></p>
			<div class="price">
				<%
'					IF oDoc.FItemList(i).IsFreeBeasongCoupon() AND oDoc.FItemList(i).IsSaleItem then
'						vSaleFreeDeliv = "<div class=""tag shipping""><span class=""icon icon-shipping""><i>무료배송</i></span> FREE</div>"
'					End IF

					If oDoc.FItemList(i).IsSaleItem AND oDoc.FItemList(i).isCouponItem Then	'### 쿠폰 O 세일 O
						Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oDoc.FItemList(i).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
						Response.Write "&nbsp;<b class=""discount color-red"">" & oDoc.FItemList(i).getSalePro & "</b>"
						If oDoc.FItemList(i).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
							If InStr(oDoc.FItemList(i).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
								Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
							Else
								Response.Write "&nbsp;<b class=""discount color-green"">" & oDoc.FItemList(i).GetCouponDiscountStr & "<small>쿠폰</small></b>"
							End If
						End If
						Response.Write "</div>" &  vbCrLf
					ElseIf oDoc.FItemList(i).IsSaleItem AND (Not oDoc.FItemList(i).isCouponItem) Then	'### 쿠폰 X 세일 O
						Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oDoc.FItemList(i).getRealPrice,0) & "<span class=""won"">원</span></b>"
						Response.Write "&nbsp;<b class=""discount color-red"">" & oDoc.FItemList(i).getSalePro & "</b>"
						Response.Write "</div>" &  vbCrLf
					ElseIf oDoc.FItemList(i).isCouponItem AND (NOT oDoc.FItemList(i).IsSaleItem) Then	'### 쿠폰 O 세일 X
						Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oDoc.FItemList(i).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
						If oDoc.FItemList(i).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
							If InStr(oDoc.FItemList(i).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
								Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
							Else
								Response.Write "&nbsp;<b class=""discount color-green"">" & oDoc.FItemList(i).GetCouponDiscountStr & "<small>쿠폰</small></b>"
							End If
						End If
						Response.Write "</div>" &  vbCrLf
					Else
						Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oDoc.FItemList(i).getRealPrice,0) & "<span class=""won"">" & CHKIIF(oDoc.FItemList(i).IsMileShopitem," Point","원") & "</span></b></div>" &  vbCrLf
					End If
				%>
			</div>
		</div>
	</a>
	<div class="etc">
		<% if oDoc.FItemList(i).FEvalcnt > 0 then %>
			<div class="tag review"><span class="icon icon-rating"><i style="width:<%=fnEvalTotalPointAVG(oDoc.FItemList(i).FPoints,"search")%>%;">리뷰 종합 별점</i></span><span class="counting" title="리뷰 갯수"><%=chkIIF(oDoc.FItemList(i).FEvalcnt>999,"999+",oDoc.FItemList(i).FEvalcnt)%></span></div>
		<% end if %>
		<button class="tag wish btn-wish" onclick="goWishPop('<%=oDoc.FItemList(i).FItemid%>','');">
		<%
		If oDoc.FItemList(i).FFavCount > 0 Then
			If fnIsMyFavItem(vWishArr,oDoc.FItemList(i).FItemID) Then
				Response.Write "<span class=""icon icon-wish on"" id=""wish"&oDoc.FItemList(i).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&oDoc.FItemList(i).FItemID&""">"
				Response.Write CHKIIF(oDoc.FItemList(i).FFavCount>999,"999+",formatNumber(oDoc.FItemList(i).FFavCount,0)) & "</span>"
			Else
				Response.Write "<span class=""icon icon-wish"" id=""wish"&oDoc.FItemList(i).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&oDoc.FItemList(i).FItemID&""">"
				Response.Write CHKIIF(oDoc.FItemList(i).FFavCount>999,"999+",formatNumber(oDoc.FItemList(i).FFavCount,0)) & "</span>"
			End If
		Else
			Response.Write "<span class=""icon icon-wish"" id=""wish"&oDoc.FItemList(i).FItemID&"""><i> wish</i></span><span class=""counting"" id=""cnt"&oDoc.FItemList(i).FItemID&"""></span>"
		End If
		%>
		</button>
		<% IF oDoc.FItemList(i).IsCouponItem AND oDoc.FItemList(i).GetCouponDiscountStr = "무료배송" Then %>
			<div class="tag shipping"><span class="icon icon-shipping"><i>무료배송</i></span> FREE</div>
		<% End If %>
	</div>
</li>
<% Next %>
<%
set oDoc = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->