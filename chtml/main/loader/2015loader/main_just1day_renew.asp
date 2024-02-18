<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/main/main_just1day.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
response.charset = "utf-8"
'#######################################################
' Discription : mobile_just1day // cache DB경유
' History : 2015-10-02 이종화 생성
'#######################################################

Dim itemid , itemname ,  sellcash , orgPrice ,  makerid , brandname , sellyn , saleyn , limityn , limitno , limitsold 
Dim couponYn , couponvalue , coupontype , imagebasic , itemdiv , ldv , label , templdv , vis1day , intI , vIdx , vTitle , tentenimage400
Dim cPk
Dim gaParam : gaParam = "&gaparam=todaymain2_b" '//GA 체크 변수

ReDim itemrate(3) , itemimg(3) , itemalt(3)
SET cPk = New CPick
	cPk.GetPickOne()
	
	If cPk.FTotalCount > 0 Then
		vIdx = cPk.FItemOne.Fidx
		vTitle = cPk.FItemOne.Ftitle
		vis1day = cPk.FItemOne.Fis1day
	End IF
	
	If vIdx <> "" Then
		cPk.FPageSize = 3
		cPk.FCurrPage = 1
		cPk.FRectIdx = vIdx
		cPk.FRectSort = 1
		cPk.GetPickItemList()
	End If

'##################################################################
'// 원 판매 가격  '!
public Function getOrgPrice()
	if OrgPrice=0 then
		getOrgPrice = Sellcash
	else
		getOrgPrice = OrgPrice
	end if
end Function
'// 세일포함 실제가격  '!
public Function getRealPrice()
	getRealPrice = SellCash
end Function
'// 상품 쿠폰 여부  '!
public Function IsCouponItem()
	IsCouponItem = (couponYn="Y")
end Function
'// 할인가
public Function getDiscountPrice() 
	dim tmp
	if (CLng((OrgPrice-SellCash)/OrgPrice*100)<>1) then
		tmp = cstr(Sellcash * CLng((OrgPrice-SellCash)/OrgPrice*100))
		getDiscountPrice = round(tmp / 100) * 100
	else
		getDiscountPrice = Sellcash
	end if
end Function
'// 할인율 '!
public Function getSalePro() 
	if Orgprice=0 then
		getSalePro = 0 & "%"
	else
		getSalePro = CLng((OrgPrice-getRealPrice)/OrgPrice*100) & "%"
	end if
end Function
'// 쿠폰 적용가
public Function GetCouponAssignPrice() '!
	if (IsCouponItem) then
		GetCouponAssignPrice = getRealPrice - GetCouponDiscountPrice
	else
		GetCouponAssignPrice = getRealPrice
	end if
end Function
'// 쿠폰 할인가 '?
public Function GetCouponDiscountPrice() 
	Select case coupontype
		case "1" ''% 쿠폰
			GetCouponDiscountPrice = CLng(couponvalue*getRealPrice/100)
		case "2" ''원 쿠폰
			GetCouponDiscountPrice = couponvalue
		case "3" ''무료배송 쿠폰
			GetCouponDiscountPrice = 0
		case else
			GetCouponDiscountPrice = 0
	end Select
end Function
'##################################################################
	
if cPk.fresultcount > 0 Then
%>
	<% If vis1day ="Y" Then %>
	<h2><img src="http://fiximage.10x10.co.kr/m/2015/today/tit_justday.png" alt="JUST 1DAY" /></h2>
	<% Else %>
	<h2><img src="http://fiximage.10x10.co.kr/m/2015/today/tit_dontmiss.png" alt="DONT`MISS" /></h2>
	<% End If %>
	<div class="justSwipeV15a">
			<span class="maskLt"></span><span class="maskRt"></span>
			<a class="arrow-left" href="#"></a>
			<a class="arrow-right" href="#"></a>
			<div class="swiper-container noswipe swiper2">
				<div class="swiper-wrapper">
<%
	
	Dim i : i = 0
	for intI = 0 to cPk.fresultcount

		itemid			= cPk.FCategoryPrdList(intI).FItemID
		itemname		= cPk.FCategoryPrdList(intI).FItemName
		sellcash		= cPk.FCategoryPrdList(intI).FSellcash
		orgPrice		= cPk.FCategoryPrdList(intI).FOrgPrice
		makerid			= cPk.FCategoryPrdList(intI).FMakerId
		brandname		= cPk.FCategoryPrdList(intI).FBrandName
		sellyn			= cPk.FCategoryPrdList(intI).FSellYn
		saleyn			= cPk.FCategoryPrdList(intI).FSaleYn
		limityn			= cPk.FCategoryPrdList(intI).FLimitYn
		limitno			= cPk.FCategoryPrdList(intI).FLimitNo
		limitsold		= cPk.FCategoryPrdList(intI).FLimitSold
		couponYn		= cPk.FCategoryPrdList(intI).Fitemcouponyn
		couponvalue		= cPk.FCategoryPrdList(intI).FItemCouponValue
		coupontype		= cPk.FCategoryPrdList(intI).Fitemcoupontype
		imagebasic		= cPk.FCategoryPrdList(intI).FImageBasic
		itemdiv			= cPk.FCategoryPrdList(intI).Fitemdiv
		ldv				= cPk.FCategoryPrdList(intI).Fldv
		label			= cPk.FCategoryPrdList(intI).Flabel
		templdv			= cPk.FCategoryPrdList(intI).Fldv
		tentenimage400	= cPk.FCategoryPrdList(intI).Ftentenimage400

		'If label <> "5" Then '//today가 아닌것
%>
					<div class="swiper-slide">
						<a href="/category/category_itemPrd.asp?itemid=<%=itemid%>&ldv=<%=templdv%><%=gaParam%>">
							<div class="pdtCont">
								<p class="pName"><%=itemname%></p>
								<p class="pPrice">
									<span class="del"><%=formatNumber(orgPrice,0)%></span>
									<% IF saleyn = "Y" or couponYn = "Y" Then %>
										<% IF (saleyn="Y") and (OrgPrice-SellCash>0) And couponYn <> "Y" THEN %><span><%=FormatNumber(SellCash,0)%> 원</span><% end if %>
										<% if couponYn = "Y" Then %><span><%=FormatNumber(GetCouponAssignPrice,0)%>원</span><% end if %>
									<% End If %>
								</p>
								<p class="rate <%=chkiif(couponYn = "Y"," cpRate","")%>">
									<% iF (saleyn="Y") and (OrgPrice-SellCash>0) And couponYn <> "Y" Then %>
									<strong><% If OrgPrice = 0 Then	Response.Write "" Else Response.Write "" & CLng((OrgPrice-SellCash)/OrgPrice*100) & "" End If %></strong>%
									<% Else %>
									<strong><% If OrgPrice = 0 Then	Response.Write "" Else Response.Write "" & fix((OrgPrice-GetCouponAssignPrice)/OrgPrice*100) & "" End If %></strong>%
									<% End If %>
								</p>
							</div>
							<div class="pPhoto"><p><span><em>품절</em></span></p><img src="<%=chkiif(Not(isnull(tentenimage400) Or tentenimage400 = ""),tentenimage400,getThumbImgFromURL(imagebasic,400,400,"true","false"))%>" alt="<%=itemname%>" /></div>
						</a>
					</div>
<%
		If couponYn = "Y" Then 
		itemrate(i) = Fix((OrgPrice-GetCouponAssignPrice)/OrgPrice*100) '//소숫점 버림
		Else
		itemrate(i) = CLng((OrgPrice-SellCash)/OrgPrice*100) 
		End If 

		If Not(isnull(tentenimage400) Or tentenimage400 = "") Then ' 텐텐이미지
			itemimg(i) = tentenimage400 '//thumbnail 용
		else
			itemimg(i) = imagebasic '//thumbnail 용
		End If 
		
		itemalt(i) = itemname '//thumbnail 용
		i = i + 1
		'End If 
	Next
	set cPk = Nothing
%>
					</div>
						<div class="swiper-pagination paging2"></div>
						<ul class="justThumbV15a">
							<li><img src="<%= getThumbImgFromURL(itemimg(0),200,200,"true","false") %>" alt="<%=itemalt(0)%>" /></li>
							<li><img src="<%= getThumbImgFromURL(itemimg(1),200,200,"true","false") %>" alt="<%=itemalt(1)%>" /></li>
							<li><img src="<%= getThumbImgFromURL(itemimg(2),200,200,"true","false") %>" alt="<%=itemalt(2)%>" /></li>
						</ul>
					</div>
				</div>
<%
end If
%>
<script>
$(function(){
	// just 1day
	var swiperJ = new Swiper('.swiper2', {
		pagination:'.paging2',
		paginationClickable:true,
		resizeReInit:true,
		calculateHeight:true,
		loop:true,
		nextButton:'.arrow-right',
		prevButton:'.arrow-left',
		noSwipingClass:'.noswipe',
		noSwiping:true,
		paginationBulletRender: function (index, className) {
			var cnt
			if (index == 0){
				cnt = "<%=itemrate(0)%>";
			}else if (index == 1){
				cnt = "<%=itemrate(1)%>";
			}else if (index == 2){
				cnt = "<%=itemrate(2)%>";
			}			
			return '<span class="' + className + '">' + '<strong>' + cnt + '</strong>' + '%</span>';
		}
	});

	$('.arrow-left').on('click', function(e){
		e.preventDefault()
		swiperJ.swipePrev()
	});
	$('.arrow-right').on('click', function(e){
		e.preventDefault()
		swiperJ.swipeNext()
	});
});
</script>