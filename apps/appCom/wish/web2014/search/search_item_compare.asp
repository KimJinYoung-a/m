<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<%
	Dim vItemID, lp, i, vWishArr, vSearchItemID, vUserID
	dim adultChkFlag, linkUrl

	vUserID = GetLoginUserID()
	vItemID = requestCheckVar(request("itemid"),50)
	vItemID = Replace(vItemID, "i", "")
	vItemID = Replace(vItemID, " ", "")
	'vItemID = "551155,1230916"
	If vItemID <> "" Then
		If Left(vItemID,1) = "," Then
			vItemID = Right(vItemID,Len(vItemID)-1)
		End If
		If Right(vItemID,1) = "," Then
			vItemID = Left(vItemID,Len(vItemID)-1)
		End If
	
		For i = LBound(Split(vItemID,",")) To UBound(Split(vItemID,","))
			If Split(vItemID,",")(i) <> "" Then
				If vSearchItemID <> "" Then
					vSearchItemID = vSearchItemID & " or "
				End If
				vSearchItemID = vSearchItemID & "idx_itemid = " & Split(vItemID,",")(i)
			End If
		Next
		
		If vSearchItemID <> "" Then
			vSearchItemID = " (" & vSearchItemID & ") "
		End IF
	Else
		Response.End
	End If

	'// 상품검색
	dim oDoc,iLp
	set oDoc = new SearchItemCls
	oDoc.FCurrPage = 1
	oDoc.FPageSize = 10
	oDoc.FScrollCount = 10
	oDoc.FListDiv = "fulllist"
	oDoc.FLogsAccept = false
	oDoc.FAddLogRemove = true			'추가로그 기록안함
	oDoc.FSellScope = "N"
	oDoc.FRectSortMethod	= "ne"
	oDoc.FRectItemID = vSearchItemID
	oDoc.getSearchList


	'// 검색결과 내위시 표시정보 접수
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
	
	Dim vItem(2), vPrice(2), vBrand(2), vDelivery(2), vOptCnt(2), vEval(2), vWish(2), vItemBtn(2)
	
	For i=0 To oDoc.FResultCount-1
	
		'### 상품 ###

		adultChkFlag = session("isAdult") <> true and oDoc.FItemList(i).FadultType = 1
		if adultChkFlag then
			vItem(i) = "<td><div class=""thumbnail""><img src=""http://fiximage.10x10.co.kr/m/2019/common/img_adult_300.gif"" alt="""" />"
		else
			vItem(i) = "<td><div class=""thumbnail""><img src=""" & getThumbImgFromURL(oDoc.FItemList(i).FImageBasic,300,300,"true","false") & """ alt="""" />"
		end if
		
		If oDoc.FItemList(i).isSoldOut Then
		vItem(i) = vItem(i) & "<b class=""soldout"">일시 품절</b>"
		End If
		vItem(i) = vItem(i) & "</div><p class=""name"">" & oDoc.FItemList(i).FItemName & "</p></td>"
		
		
		'### 가격 ###
		vPrice(i) = "<td>"
		IF oDoc.FItemList(i).IsSaleItem or oDoc.FItemList(i).isCouponItem Then
			IF oDoc.FItemList(i).IsSaleItem Then
				vPrice(i) = vPrice(i) & "<div class=""unit""><b class=""sum"">" & FormatNumber(oDoc.FItemList(i).getRealPrice,0) & "<span class=""won"">원</span></b> <b class=""discount red"">" & oDoc.FItemList(i).getSalePro & "</b></div>"
			End IF
			IF oDoc.FItemList(i).IsCouponItem AND oDoc.FItemList(i).GetCouponDiscountStr <> "무료배송" Then
				vPrice(i) = vPrice(i) & "<div class=""unit""><b class=""sum"">" & FormatNumber(oDoc.FItemList(i).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b> <b class=""discount green"">" & oDoc.FItemList(i).GetCouponDiscountStr & "</b></div>"
			End IF
		Else
			vPrice(i) = vPrice(i) & "<div class=""unit""><b class=""sum"">" & FormatNumber(oDoc.FItemList(i).getRealPrice,0) & "<span class=""won"">" & CHKIIF(oDoc.FItemList(i).IsMileShopitem," Point"," 원") & "</span></b></div>"
		End if
		vPrice(i) = vPrice(i) & "</td>"
		
		
		'### 브랜드 ###
		vBrand(i) = "<td>" & oDoc.FItemList(i).FBrandName & "</td>"
		
		
		'### 배송 ###
		If oDoc.FItemList(i).FDeliverytype = "1" OR  oDoc.FItemList(i).FDeliverytype = "4" Then
			vDelivery(i) = "<td>텐바이텐</td>"
		Else
			vDelivery(i) = "<td>업체배송</td>"
		End IF
		
		
		'### 옵션유무 ###
		If oDoc.FItemList(i).FOptionCnt > 0 Then
			vOptCnt(i) = "<td>○</td>"
		Else
			vOptCnt(i) = "<td>X</td>"
		End IF
		
		
		'### 후기 ###
		vEval(i) = "<td>"
		vEval(i) = vEval(i) & "<div class=""tag review""><span class=""icon icon-rating"">"
		vEval(i) = vEval(i) & "<i style=""width:" & fnEvalTotalPointAVG(oDoc.FItemList(i).FPoints,"search") & "%;"">"
		vEval(i) = vEval(i) & fnEvalTotalPointAVG(oDoc.FItemList(i).FPoints,"search") & "점</i></span>"
		vEval(i) = vEval(i) & "<span class=""counting"">" & FormatNumber(oDoc.FItemList(i).FEvalCnt,0) & "</span></div>"
		vEval(i) = vEval(i) & "</td>"
		
		
		'### 위시 ###
		vWish(i) = "<td><div class=""tag wish btn-wish"">"
		If fnIsMyFavItem(vWishArr,oDoc.FItemList(i).FItemID) Then
			vWish(i) = vWish(i) & "<span class=""icon icon-wish on""><i class=""hidden""> wish</i></span><span class=""counting"">"
			vWish(i) = vWish(i) & formatNumber(oDoc.FItemList(i).FfavCount,0) & "</span>"
		Else
			vWish(i) = vWish(i) & "<span class=""icon icon-wish""><i class=""hidden""> wish</i></span><span class=""counting"">"
			vWish(i) = vWish(i) & formatNumber(oDoc.FItemList(i).FfavCount,0) & "</span>"
		End If
		vWish(i) = vWish(i) & "</div></td>"
		
		
		'### 상품코드 ###
		vItemBtn(i) = "<td><a href="""" onClick=""fnAPPpopupProduct('" & oDoc.FItemList(i).FItemID & "'); return false;"" class=""btn-get"">구매하기</a></td>"
	Next
	
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
</head>
<body class="default-font">
<table class="table table-compare items">
	<caption class="hidden">상품, 가격, 브랜드, 배송, 옵션, 후기, 위시를 비교하여 정보를 제공하는 표</caption>
	<tbody>
	<tr class="item">
		<th scope="row">상품<br />(<%=oDoc.FResultCount%>개)</th>
		<%=vItem(0)%>
		<%=vItem(1)%>
		<%=vItem(2)%>
	</tr>
	<tr class="price">
		<th scope="row">가격<br />(원)</th>
		<%=vPrice(0)%>
		<%=vPrice(1)%>
		<%=vPrice(2)%>
	</tr>
	<tr class="brand">
		<th scope="row">브랜드</th>
		<%=vBrand(0)%>
		<%=vBrand(1)%>
		<%=vBrand(2)%>
	</tr>
	<tr class="shipping">
		<th scope="row">배송</th>
		<%=vDelivery(0)%>
		<%=vDelivery(1)%>
		<%=vDelivery(2)%>
	</tr>
	<tr class="option">
		<th scope="row">옵션</th>
		<%=vOptCnt(0)%>
		<%=vOptCnt(1)%>
		<%=vOptCnt(2)%>
	</tr>
	<tr class="review">
		<th scope="row">후기</th>
		<%=vEval(0)%>
		<%=vEval(1)%>
		<%=vEval(2)%>
	</tr>
	<tr class="wish">
		<th scope="row">위시</th>
		<%=vWish(0)%>
		<%=vWish(1)%>
		<%=vWish(2)%>
	</tr>
	<tr class="get">
		<th scope="row"></th>
		<%=vItemBtn(0)%>
		<%=vItemBtn(1)%>
		<%=vItemBtn(2)%>
	</tr>
	</tbody>
</table>
</body>
</html>
<%
Dim userid, nowtime, sqlStr
userid = GetLoginUserid()
If userid = "" Then
	userid = "guest"
End If

sqlStr = ""
nowtime = date() & " " & TwoNumber(hour(now)) & ":" & TwoNumber(minute(now)) & ":" & TwoNumber(second(now)) & "." & right("000" & (timer * 1000) Mod 1000, 3)
For i = LBound(Split(vItemID,",")) To UBound(Split(vItemID,","))
	If Split(vItemID,",")(i) <> "" Then
		sqlStr = sqlStr & "insert into db_log.dbo.tbl_item_Compare_log(itemid,userid,regdate) values('" & Split(vItemID,",")(i) & "','"&userid&"','"&nowtime&"');"
	End If
Next
dbget.Execute sqlStr

set oDoc = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->