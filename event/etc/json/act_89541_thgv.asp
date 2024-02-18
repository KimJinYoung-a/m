<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/inc_const.asp"-->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<!-- #include virtual="/lib/classes/item/dealCls.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<%
'###############################################
' Discription : 17주년 특가이벤트
' History : 2018.10.12 최종원
'###############################################
Class brandObjCls
	Public brandName
	public brandKoreanName	
	Public brandCopy
	Public brandItemCode
	Public brandUrl
	Public brandImg
	public evtcode
	public brandEvtImg	
	public brandSalePer
	public linktype '//1 - itemid , 2 - eventid
End Class

dim testdate
dim itemid, oJson, pageDiv, i, itemImgArr(), specialItemImg, specialItemMainImg
dim specialItemCode, landingUrl, brandList(), brandObj, specialItemName, specialItemSellPrice
dim specialItemDealSalePer, specialItemDealsellPrice, specialItemDealSalePrice

Redim preserve itemImgArr(13)
Redim preserve brandList(3)

testdate = request("testdate")

'brand
set brandList(0) = new brandObjCls
set brandList(1) = new brandObjCls
set brandList(2) = new brandObjCls

'deal schedule
itemImgArr(0) = "http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/img_pop_1015.png"	'15일
itemImgArr(1) = "http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/img_pop_1016.png?v=0.01"	'16일
itemImgArr(2) = "http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/img_pop_1017.png"	'17일
itemImgArr(3) = "http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/img_pop_1018.png"	'18일
itemImgArr(4) = "http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/img_pop_1019.png"	'19일
itemImgArr(5) = "http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/img_pop_1022.png"	'22일 http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/img_pop_1022.png
itemImgArr(6) = "http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/img_pop_1023.png"	'23일 http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/img_pop_1023.png
itemImgArr(7) = "http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/img_pop_soon.png"	'24일 http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/img_pop_1024.png
itemImgArr(8) = "http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/img_pop_soon.png"	'25일 http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/img_pop_1025.png
itemImgArr(9) = "http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/img_pop_soon.png"	'26일 http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/img_pop_1026.png
itemImgArr(10) = "http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/img_pop_soon.png"	'29일 http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/img_pop_1020.png
itemImgArr(11) = "http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/img_pop_soon.png"	'30일 http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/img_pop_1020.png
itemImgArr(12) = "http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/img_pop_soon.png"	'31일 http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/img_pop_1020.png


'//헤더 출력
Response.ContentType = "application/json"

'// json객체 선언
Set oJson = jsObject()

'=========== 오늘의 특가 선물 ======================

Dim baseDt: baseDt = date & " " & Num2Str(Hour(now),2,"0","R") & ":" & Num2Str(Minute(now),2,"0","R") & ":" & Num2Str(Second(now),2,"0","R")
if testdate <> "" then
	baseDt = testdate
end if

'// 날짜별 원데이 상품 지정
Select Case left(baseDt,10)		 	
	Case "2018-10-23": 
	'특가
		specialItemCode = 2116053'   테스트2082383 '2116053
		specialItemName = "추울때 필요한건 마틸라"
		specialItemSellPrice = 176000
	'특가 딜
		specialItemDealSalePer	= "~48%"
		specialItemDealsellPrice= "59900"
		specialItemDealSalePrice= "7900"
	'브랜드	
	'1
		brandList(0).brandName = "DODOT"
		brandList(0).brandKoreanName = "두닷"
		brandList(0).brandCopy = "자취생 필수가구"
		brandList(0).brandSalePer = "~68%"
		brandList(0).evtcode = "89904"
	'2
		brandList(1).brandName = "SNEAKERS BEST 7 "
		brandList(1).brandKoreanName = "스니커즈 TOP7"		
		brandList(1).brandCopy = "편하고 이쁜 신발"
		brandList(1).brandSalePer = "~80%"
		brandList(1).evtcode = "89839"
	'3	
		brandList(2).brandName = "HOME GALLERY 5"
		brandList(2).brandKoreanName = "홈갤러리 TOP 5"		
		brandList(2).brandCopy = "MD가 추천하는 그림"
		brandList(2).brandSalePer = "~40%"		
		brandList(2).evtcode = "89968"		
	Case "2018-10-24": 
	'특가
		specialItemCode = 2116700'   테스트2082383 '2116700
		specialItemName = "드레텍 스탑워치 3종"
		specialItemSellPrice = 176000
	'특가 딜
		specialItemDealSalePer	= "~40%"
		specialItemDealsellPrice= "12900"
		specialItemDealSalePrice= "7700"
	'브랜드	
	'1
		brandList(0).brandName = "DODDESIGNERSROOMOT"
		brandList(0).brandKoreanName = "디자이너스룸"
		brandList(0).brandCopy = "실용성 만점인 가구"
		brandList(0).brandSalePer = "~89%"
		brandList(0).evtcode = "89902"
	'2
		brandList(1).brandName = "BAG BEST BRAND 7"
		brandList(1).brandKoreanName = "가방 베스트7"		
		brandList(1).brandCopy = "매일 들고 다닐래"
		brandList(1).brandSalePer = "~57%"
		brandList(1).evtcode = "89869"
	'3	
		brandList(2).brandName = "Recolte"
		brandList(2).brandKoreanName = "레꼴뜨"		
		brandList(2).brandCopy = "작지만 알찬 가전"
		brandList(2).brandSalePer = "~35%"		
		brandList(2).evtcode = "89981"			
	Case "2018-10-25": 
	'특가
		specialItemCode = 2117048'   테스트2082383 '2116700
		specialItemName = "뷰티 기초 보습대전"
		specialItemSellPrice = 176000
	'특가 딜
		specialItemDealSalePer	= "~72%"
		specialItemDealsellPrice= "112100"
		specialItemDealSalePrice= "1600"
	'브랜드	
	'1
		brandList(0).brandName = "CUP&TUMBLER HOT 10"
		brandList(0).brandKoreanName = "보틀 TOP10"
		brandList(0).brandCopy = "마음까지 따뜻하게"
		brandList(0).brandSalePer = "~74%"
		brandList(0).evtcode = "89949"
	'2
		brandList(1).brandName = "Dyson"
		brandList(1).brandKoreanName = "다이슨"		
		brandList(1).brandCopy = "강력한 흡입을 위해"
		brandList(1).brandSalePer = "~43%"
		brandList(1).evtcode = "89977"
	'3	
		brandList(2).brandName = "travelus"
		brandList(2).brandKoreanName = "트래블러스"		
		brandList(2).brandCopy = "일상과 여행을 위해"
		brandList(2).brandSalePer = "~25%"		
		brandList(2).evtcode = "89982"				
	Case "2018-10-26": 
	'특가
		specialItemCode = 2117264'   테스트2082383 '2116700
		specialItemName = "가습기 모음딜"
		specialItemSellPrice = 176000
	'특가 딜
		specialItemDealSalePer	= "~80%"
		specialItemDealsellPrice= "759000"
		specialItemDealSalePrice= "15900"
	'브랜드	
	'1
		brandList(0).brandName = "TANGLE TEEZER"
		brandList(0).brandKoreanName = "탱글티저"
		brandList(0).brandCopy = "손맛 나는 헤어 빗"
		brandList(0).brandSalePer = "~30%"
		brandList(0).evtcode = "89975"
	'2
		brandList(1).brandName = "FASHION BEST 100"
		brandList(1).brandKoreanName = "상의 베스트"		
		brandList(1).brandCopy = "쌀쌀할 때 필수 상의"
		brandList(1).brandSalePer = "~80%"
		brandList(1).evtcode = "89965"
	'3	
		brandList(2).brandName = "MD'S CANDLE&DIFFUSER"
		brandList(2).brandKoreanName = "엠디추천캔들"		
		brandList(2).brandCopy = "내 공간을 향기롭게"
		brandList(2).brandSalePer = "~62%"		
		brandList(2).evtcode = "89969"		
	Case "2018-10-27", "2018-10-28", "2018-10-29": 
	'특가
		specialItemCode = 2124425'   테스트2082383 '2116700
		specialItemName = "드롱기 외 커피용품"
		specialItemSellPrice = 176000
	'특가 딜
		specialItemDealSalePer	= "~50%"
		specialItemDealsellPrice= "599000"
		specialItemDealSalePrice= "3000"
	'브랜드	
	'1
		brandList(0).brandName = "APPLE"
		brandList(0).brandKoreanName = "애플"
		brandList(0).brandCopy = "에어팟, 최저가"
		brandList(0).brandSalePer = "32%"
		brandList(0).evtcode = "1885168"
		brandList(0).linktype = "1"
	'2
		brandList(1).brandName = "BO WELL"
		brandList(1).brandKoreanName = "보웰"		
		brandList(1).brandCopy = "공간을 위한 패브릭"
		brandList(1).brandSalePer = "~35%"
		brandList(1).evtcode = "89957"
		brandList(1).linktype = "2"
	'3	
		brandList(2).brandName = "cocodo'r"
		brandList(2).brandKoreanName = "코코도르"		
		brandList(2).brandCopy = "국민 디퓨저래요"
		brandList(2).brandSalePer = "~70%"		
		brandList(2).evtcode = "90065"	
		brandList(2).linktype = "2"		
	Case "2018-10-30": 
	'특가
		specialItemCode = 2126580'   테스트2082383 '2116700
		specialItemName = "슬로우 매트리스"
		specialItemSellPrice = 176000
	'특가 딜
		specialItemDealSalePer	= "~29%"
		specialItemDealsellPrice= "690000"
		specialItemDealSalePrice= "355000"
	'브랜드	
	'1
		brandList(0).brandName = "CAT&DOG BEST 100"
		brandList(0).brandKoreanName = "캣앤독 베스트"
		brandList(0).brandCopy = "댕댕'S PICK"
		brandList(0).brandSalePer = "~63%"
		brandList(0).evtcode = "90036"
		brandList(0).linktype = "2"
	'2
		brandList(1).brandName = "MARKETB"
		brandList(1).brandKoreanName = "마켓비"		
		brandList(1).brandCopy = "자취방 필수 가구"
		brandList(1).brandSalePer = "~42%"
		brandList(1).evtcode = "90057"
		brandList(1).linktype = "2"
	'3	
		brandList(2).brandName = "FOOD BEST 10"
		brandList(2).brandKoreanName = "푸드 TOP 10"		
		brandList(2).brandCopy = "요즘 핫한 푸드는?"
		brandList(2).brandSalePer = "~73%"		
		brandList(2).evtcode = "90078"	
		brandList(2).linktype = "2"			
	Case "2018-10-31":
	'특가
		specialItemCode = 1948944'   테스트2082383 '2116700
		specialItemName = "진리상점X닥터리브"
		specialItemSellPrice = 9900
	'특가 딜
'		specialItemDealSalePer	= "~29%"
'		specialItemDealsellPrice= "690000"
'		specialItemDealSalePrice= "355000"
	'브랜드	
	'1
		brandList(0).brandName = "MONDAYHOUSE"
		brandList(0).brandKoreanName = "먼데이하우스"
		brandList(0).brandCopy = "원목의 아늑함"
		brandList(0).brandSalePer = "~76%"
		brandList(0).evtcode = "89991"
		brandList(0).linktype = "2"
	'2
		brandList(1).brandName = "HOT WINTER"
		brandList(1).brandKoreanName = "보온 ITEM"		
		brandList(1).brandCopy = "월동준비 특가"
		brandList(1).brandSalePer = "~83%"
		brandList(1).evtcode = "90071"
		brandList(1).linktype = "2"
	'3	
		brandList(2).brandName = "KODAK"
		brandList(2).brandKoreanName = "코닥"		
		brandList(2).brandCopy = "찍고 뽑고! 바로~"
		brandList(2).brandSalePer = "~36%"		
		brandList(2).evtcode = "90154"	
		brandList(2).linktype = "2"				 
	Case Else
		specialItemCode=0
		baseDt=""
end Select

dim isSoldOut, strSql

isSoldOut = 0

	strSql = " SELECT SELLYN "
	strSql = strSql & "	FROM DB_ITEM.DBO.TBL_ITEM "
	strSql = strSql & "	WHERE ITEMID =  '"&specialItemCode&"'"
	
	rsget.CursorLocation = adUseClient
	rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly
	
	if Not rsget.Eof Then
	isSoldOut = rsget("SELLYN")
	End If
	rsget.close

If specialItemCode=0 then
	'// 기간 종료
	oJson("today") = ""
else
	'// 상품 정보 접수
	dim oItem
	dim orgprice, sellprice, saleyn
	set oItem = new CatePrdCls
		oItem.GetItemData specialItemCode

		If oItem.FResultCount > 0 Then
			Set oJson("today") = jsObject()
			oJson("today")("date") = replace(baseDt,"-","/")
			oJson("today")("itemid") = cStr(specialItemCode)
			oJson("today")("itemname") = specialItemName
			oJson("today")("imgurl") = cStr(oItem.Prd.FImageicon1)		'150px icon image
			oJson("today")("itemdiv") = cStr(oItem.Prd.FItemDiv)		'itemdiv
			oJson("today")("landingUrl") = landingUrl
			oJson("today")("specialItemImg") = specialItemImg
			oJson("today")("specialItemMainImg") = specialItemMainImg			
			oJson("today")("specialItemCode") = specialItemCode
			
			if cStr(oItem.Prd.FItemDiv) = 21 then ' 딜 상품일 경우 
				Dim oDeal, ArrDealItem
				Set oDeal = New DealCls
				oDeal.GetIDealInfo specialItemCode

				ArrDealItem = oDeal.GetDealItemList(oDeal.Prd.FDealCode)

				orgprice = ArrDealItem(11,0) 
				sellprice =  ArrDealItem(2,0)
				saleyn = cStr(ArrDealItem(10,0)) 'saleyn

				oJson("today")("orgprice") = FormatNumber(FiX(orgprice),0) & "원"
				oJson("today")("sellprice") = FormatNumber(FiX(sellprice),0) & "원"
				oJson("today")("saleyn") = saleyn
				oJson("today")("specialItemDealSalePer") = specialItemDealSalePer
				oJson("today")("specialItemDealsellPrice") = FormatNumber(FiX(specialItemDealsellPrice),0) & "원"
				oJson("today")("specialItemDealSalePrice") = FormatNumber(FiX(specialItemDealSalePrice),0) & "원"
			else
				orgprice = oItem.Prd.FOrgPrice
				sellprice =  specialItemSellPrice
				saleyn = cStr(oItem.Prd.FSaleYn)	

				oJson("today")("orgprice") = FormatNumber(FiX(orgprice),0) & "원"
				oJson("today")("sellprice") = FormatNumber(FiX(sellprice),0) & "원"
				oJson("today")("isSoldOut") = isSoldOut
				oJson("today")("saleyn") = saleyn
			end if

'			If (saleyn="Y") and (int(orgprice) - int(sellprice) > 0) THEN
				oJson("today")("saleper") = cStr(int( round((orgprice-sellprice)/orgprice*100) )) & "%"
'			else
'				oJson("today")("saleper") = ""
'			end if			
		else
			oJson("today") = ""
		end if
end if

	Set oJson("brandList") = jsArray()
	For i = 0 To UBound(brandList) - 1
		Set oJson("brandList")(null) = jsObject()
		oJson("brandList")(null)("brandName") = brandList(i).brandName
		oJson("brandList")(null)("brandKoreanName") = brandList(i).brandKoreanName
		oJson("brandList")(null)("brandSalePer") = brandList(i).brandSalePer
		oJson("brandList")(null)("brandCopy") = brandList(i).brandCopy
		oJson("brandList")(null)("brandItemCode") = brandList(i).brandItemCode
		oJson("brandList")(null)("brandUrl") = brandList(i).brandUrl
		oJson("brandList")(null)("brandImg") = brandList(i).brandImg
		oJson("brandList")(null)("brandEvtImg") = brandList(i).brandEvtImg
		oJson("brandList")(null)("evtcode") = brandList(i).evtcode
		oJson("brandList")(null)("linktype") = brandList(i).linktype
	next

	Set oJson("itemImgList") = jsArray()
	For i = 0 To UBound(itemImgArr) - 1
		Set oJson("itemImgList")(null) = jsObject()
		oJson("itemImgList")(null)("itemImg") = itemImgArr(i)
	next

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
