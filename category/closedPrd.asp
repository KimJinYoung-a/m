<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/lib/classes/award/newawardcls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->
<%
	Dim itemid
	itemid = requestCheckVar(request("itemid"),9)

	if itemid="" or itemid="0" then
		Call Alert_Return("상품번호가 없습니다.")
		response.End
	elseif Not(isNumeric(itemid)) then
		Call Alert_Return("잘못된 상품번호입니다.")
		response.End
	else
		'정수형태로 변환
		itemid=CLng(getNumeric(itemid))
	end if

	'// 에코마케팅용 레코벨 스크립트 용(2016.12.21) 
	Dim vPrtr
	vPrtr = requestCheckVar(request("pRtr"),200)
	
	Dim oItem , catecode
	set oItem = new CatePrdCls
	oItem.GetItemData itemid

	'// 구글 에널리틱스용
	function ImageExists(byval iimg)
		if (IsNull(iimg)) or (trim(iimg)="") or (Right(trim(iimg),1)="\") or (Right(trim(iimg),1)="/") then
			ImageExists = false
		else
			ImageExists = true
		end if
	end Function
	

	Dim viTentenimg, viTententmb
	if ImageExists(oitem.Prd.Ftentenimage1000) Then
		viTentenimg = oitem.Prd.Ftentenimage1000
	ElseIf ImageExists(oitem.Prd.Ftentenimage600) Then
		viTentenimg = oitem.Prd.Ftentenimage600
	ElseIf ImageExists(oitem.Prd.Ftentenimage) Then
		viTentenimg = oitem.Prd.Ftentenimage
	End If

	If viTentenimg<>"" Then
		viTententmb = oitem.Prd.Ftentenimage50
	End If
	
	'//카테코드
	catecode = oItem.Prd.FcateCode
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<meta name="robots" content="noindex">
</head>
<style type="text/css">
</style>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="closedPrdWrap">
					<div class="closedPrd">
						<p>죄송합니다.<br><span class="cRd1">판매가 종료</span>된 상품입니다.</p>
						<a href="/" class="btnV16a btnRed2V16a">쇼핑하러 가기</a>
					</div>
				</div>
				<%'!-- 이런 상품은 어때요?--%>
				<%
					'// 카테고리 베스트
					dim oCBDoc,iLp, ichk
					set oCBDoc = new SearchItemCls
						oCBDoc.FRectSortMethod	= "be"		'인기상품
						oCBDoc.FRectSearchFlag = "n"			'일반상품
						oCBDoc.FRectSearchItemDiv = "n"		'기본 카테고리만
						oCBDoc.FRectSearchCateDep = "T"		'하위 카테고리 포함
						oCBDoc.FRectCateCode	= catecode
						oCBDoc.FCurrPage = 1
						oCBDoc.FPageSize = 3					'3개 접수
						oCBDoc.FScrollCount = 3
						oCBDoc.FListDiv = "list"				'상품목록
						oCBDoc.FLogsAccept = False			'로그 기록안함
						oCBDoc.FAddLogRemove = true			'추가로그 기록안함
						oCBDoc.FSellScope= "Y"				'판매중인 상품만
						oCBDoc.getSearchList

					dim icoSize	: icoSize="M"	'상품 아이콘 기본(중간)
					dim imgSz	: imgSz = chkIIF(icoSize="M",240,150)

				'//카테코드 있을경우
				Dim TFflag 
				If oCBDoc.FResultCount > 0 Then
					TFflag = True
				Else
					TFflag = False
				End If

				If TFflag Then
					ichk = 1
				%>
				<div class="rcmPdtListV17">
					<h3>이런 상품은 어때요?</h3>
					<a href="" class="morePrd">더보기 ></a>
					<div class="pdtListWrapV15a">
						<ul class="pdtListV15a">
							<%
							For iLp=0 To oCBDoc.FResultCount-1
								if cStr(oCBDoc.FItemList(iLp).Fitemid)<>cStr(itemid) then	'현재보는 상품이 아니면 표시
							%>
							<li>
								<a href="/category/category_itemprd.asp?itemid=<%= oCBDoc.FItemList(iLp).Fitemid %>&rc=item_cate_<%=ichk%>">
									<div class="pPhoto"><p><span><em>품절</em></span></p><img src="<%=oCBDoc.FItemList(iLp).FImageIcon2%>" alt="<%=Replace(oCBDoc.FItemList(iLp).FitemName,"""","")%>"></div>
									<div class="pdtCont">
										<p class="pBrand"><% = oCBDoc.FItemList(iLp).FBrandName %></p>
										<p class="pName"><% = oCBDoc.FItemList(iLp).FItemName %></p>
										<% IF oCBDoc.FItemList(iLp).IsSaleItem or oCBDoc.FItemList(iLp).isCouponItem Then %>
											<% IF oCBDoc.FItemList(iLp).IsSaleItem Then %>
												<p class="pPrice"><% = FormatNumber(oCBDoc.FItemList(iLp).getRealPrice,0) %>원 <span class="cRd1">[<% = oCBDoc.FItemList(iLp).getSalePro %>]</span></p>
											<% End IF %>
											<% IF oCBDoc.FItemList(iLp).IsCouponItem Then %>
												<p class="pPrice"><% = FormatNumber(oCBDoc.FItemList(iLp).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = oCBDoc.FItemList(iLp).GetCouponDiscountStr %>]</span></p>
											<% End IF %>
										<% Else %>
											<p class="pPrice"><% = FormatNumber(oCBDoc.FItemList(iLp).getRealPrice,0) %><% if oCBDoc.FItemList(iLp).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
										<% End if %>
									
										<p class="pShare">
											<span class="cmtView"><%=FormatNumber(oCBDoc.FItemList(iLp).FEvalcnt,0)%></span>
											<span class="wishView"><%=FormatNumber(oCBDoc.FItemList(iLp).FFavCount,0)%></span>
										</p>
									</div>
								</a>
							</li>
							<%
									ichk = ichk+1
									end if
									if ichk>3 then Exit For
								Next
							%>
						</ul>
					</div>
				</div>
				<%
				Else
					'//카테코드 없을경우
					Dim oaward , atype , i

					atype="b" '2015-09-17 b -> f 변경 기본b

					set oaward = new CAWard
					oaward.FPageSize = 3

					oaward.FRectAwardgubun = atype
					oaward.GetNormalItemList
				%>
				<div class="rcmPdtListV17">
					<h3>이런 상품은 어때요?</h3>
					<a href="/award/awarditem.asp" class="morePrd">더보기 ></a>
						<div class="pdtListWrapV15a">
							<ul class="pdtListV15a">
							<%
								for i=0 to oaward.FPageSize
									If oaward.FResultCount>0 AND oaward.FResultCount > i Then
							%>
							<li>
								<a href="/category/category_itemprd.asp?itemid=<%= oaward.FItemList(i).Fitemid %>&rc=item_cate_<%=ichk%>">
									<div class="pPhoto"><p><span><em>품절</em></span></p><img src="<%=oaward.FItemList(i).FImageBasic%>" alt="<%=Replace(oaward.FItemList(i).FitemName,"""","")%>"></div>
									<div class="pdtCont">
										<p class="pBrand"><% = oaward.FItemList(i).FBrandName %></p>
										<p class="pName"><% = oaward.FItemList(i).FItemName %></p>
										<% IF oaward.FItemList(i).IsSaleItem or oaward.FItemList(i).isCouponItem Then %>
											<% IF oaward.FItemList(i).IsSaleItem Then %>
												<p class="pPrice"><% = FormatNumber(oaward.FItemList(i).getRealPrice,0) %>원 <span class="cRd1">[<% = oaward.FItemList(i).getSalePro %>]</span></p>
											<% End IF %>
											<% IF oaward.FItemList(i).IsCouponItem Then %>
												<p class="pPrice"><% = FormatNumber(oaward.FItemList(i).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = oaward.FItemList(i).GetCouponDiscountStr %>]</span></p>
											<% End IF %>
										<% Else %>
											<p class="pPrice"><% = FormatNumber(oaward.FItemList(i).getRealPrice,0) %><% if oaward.FItemList(i).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
										<% End if %>
									
										<p class="pShare">
											<span class="cmtView"><%=FormatNumber(oaward.FItemList(i).FEvalcnt,0)%></span>
											<span class="wishView"><%=FormatNumber(oaward.FItemList(i).FFavCount,0)%></span>
										</p>
									</div>
								</a>
							</li>
							<%
									End If
								Next
							%>
						</ul>
					</div>
				</div>
				<% 
					Set oaward = Nothing
				End If 
				%>
			</div>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
<script type="application/ld+json">
{
	"@context": "http://schema.org/",
	"@type": "Product",
	"name": "<%= Replace(oItem.Prd.FItemName,"""","") %>",
	"image": "<%= getThumbImgFromURL(oItem.Prd.FImageBasic,400,400,"true","false") %>",
	"mpn": "<%= itemid %>",
	"brand": {
		"@type": "Brand",
    	"name": "<%= Replace(UCase(oItem.Prd.FBrandName),"""","") %>"
	}<%
	 if (oItem.Prd.FEvalCnt > 0) then
		 dim avgEvalPoint : avgEvalPoint = getEvaluateAvgPoint(itemid)
		 if (avgEvalPoint > 0) then
	 %>,
	"aggregateRating": {
		"@type": "AggregateRating",
		"ratingValue": "<%= avgEvalPoint %>",
		"reviewCount": "<%= oItem.Prd.FEvalCnt %>"
	}<%
	 	end if
	 end if
	 %>
}
</script>

<%' 에코마케팅용 레코벨 스크립트 삽입(2016.12.21) %>
<script type="text/javascript">
  window._rblq = window._rblq || [];
  _rblq.push(['setVar','cuid','0f8265c6-6457-4b4a-b557-905d58f9f216']);
  _rblq.push(['setVar','device','MW']);
  _rblq.push(['setVar','itemId','<%=itemid%>']);
//  _rblq.push(['setVar','userId','{$userId}']); // optional
  _rblq.push(['setVar','searchTerm','<%=vPrtr%>']);
  _rblq.push(['track','view']);
  (function(s,x){s=document.createElement('script');s.type='text/javascript';
  s.async=true;s.defer=true;s.src=(('https:'==document.location.protocol)?'https':'http')+
  '://assets.recobell.io/rblc/js/rblc-apne1.min.js';
  x=document.getElementsByTagName('script')[0];x.parentNode.insertBefore(s, x);})();
</script>
</body>
</html>
<%
	Set oItem = Nothing
	'Set oaward = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->