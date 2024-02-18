<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/main/main_just1day.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
response.charset = "utf-8"
'#######################################################
' Discription : mobile_just1day_json // cache DB경유
' History : 2016-04-29 이종화 생성
'#######################################################

Dim itemid , itemname ,  sellcash , orgPrice ,  makerid , brandname , sellyn , saleyn , limityn , limitno , limitsold 
Dim couponYn , couponvalue , coupontype , imagebasic , itemdiv , ldv , label , templdv , vis1day , intI , vIdx , vTitle , tentenimage400
Dim vtodayban , vextraurl '//주말용
Dim cPk
Dim gaParam : gaParam = "&gaparam=today_just1day_1" '//GA 체크 변수
Dim tmpjson : tmpjson = ""
Dim dataList(0)
Dim json

SET cPk = New CPick
	cPk.GetPickOne()
	
	If cPk.FTotalCount > 0 Then
		vIdx = cPk.FItemOne.Fidx
		vTitle = cPk.FItemOne.Ftitle
		vis1day = cPk.FItemOne.Fis1day
		vtodayban = cPk.FItemOne.Ftodayban '//주말용 배너
		vextraurl = cPk.FItemOne.Fextraurl '//주말용 URL
	End IF
	
	If vIdx <> "" Then
		cPk.FPageSize = 1
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

on Error Resume Next
If vis1day = "Y" Then '// 평일용
	if cPk.fresultcount >= 0 Then
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


			Set tmpjson =  jsObject()
				'//app 스크립트 펑션은 angularjs 에서 처리
				tmpjson("link") = "/category/category_itemPrd.asp?itemid="& itemid &"&ldv="& templdv & gaParam &""
				iF (saleyn="Y") and (OrgPrice-SellCash>0) And couponYn <> "Y" Then
					If OrgPrice = 0 Then 
						tmpjson("discount") = "" 
					Else  	
						tmpjson("discount") = ""& CLng((OrgPrice-SellCash)/OrgPrice*100) &"%" 
					End If 
				Else
					If OrgPrice = 0 Then 
						tmpjson("discount") = "" 
					Else  	
						tmpjson("discount") = ""& fix((OrgPrice-GetCouponAssignPrice)/OrgPrice*100) &"%" 
					End If 
				End If 
					tmpjson("name") = ""& itemname &""
					tmpjson("nosaleprice") = ""& formatNumber(orgPrice,0) &""
				IF saleyn = "Y" or couponYn = "Y" Then
					IF (saleyn="Y") and (OrgPrice-SellCash>0) And couponYn <> "Y" Then tmpjson("saleprice") = ""& FormatNumber(SellCash,0) &""
					if couponYn = "Y" Then tmpjson("saleprice") = ""& FormatNumber(GetCouponAssignPrice,0) &""
				End If 

				If application("Svr_Info") = "Dev" Then	
					tmpjson("imgsrc") = ""& chkiif(Not(isnull(tentenimage400) Or tentenimage400 = ""),tentenimage400,imagebasic) &""
				Else
					tmpjson("imgsrc") = ""& chkiif(Not(isnull(tentenimage400) Or tentenimage400 = ""),tentenimage400,getThumbImgFromURL(imagebasic,400,400,"true","false")) &""
				End if
					tmpjson("alts") = ""& itemname &""
					tmpjson("is1day") = ""& vis1day &""		
					
			Set dataList(intI) = tmpjson

		Next
		Response.write toJSON(dataList)
	end If
	set cPk = Nothing
'##################################################################
Else '//주말용
	Set tmpjson =  jsObject()
		tmpjson("link") = vextraurl
		tmpjson("imgsrc") = vtodayban
		tmpjson("is1day") = vis1day
	Set dataList(0) = tmpjson

	Response.write toJSON(dataList)
'##################################################################
End If 
on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->