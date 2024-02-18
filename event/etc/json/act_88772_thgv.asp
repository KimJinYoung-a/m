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
<%
'###############################################
' Discription : 2018 추석기획전
' History : 2018.09.04 최종원
'###############################################

dim itemid, oJson, pageDiv


pageDiv = requestCheckVar(Request("pdv"),6)		'// 현재 페이지 구분(only:단독, tradit:전통, new:신상)

'//헤더 출력
Response.ContentType = "application/json"

'// json객체 선언
Set oJson = jsObject()

'=========== 오늘의 특가 선물 ======================

Dim baseDt: baseDt = date & " " & Num2Str(Hour(now),2,"0","R") & ":" & Num2Str(Minute(now),2,"0","R") & ":" & Num2Str(Second(now),2,"0","R")

'// 날짜별 원데이 상품 지정
Select Case left(baseDt,10)
	Case "2018-09-04": itemid=2077214	'구름이가 추천하는 꿀 선물, 하루벌꿀 단 하루 특가!
	Case "2018-09-05": itemid=2077214	'구름이가 추천하는 꿀 선물, 하루벌꿀 단 하루 특가!
	Case "2018-09-06": itemid=2077215	'남녀노소 누구나 좋아하는 슈퍼잼 무료배송 특가!
	Case "2018-09-07": itemid=2068534	'벌집꿀 + 건강수제청 선물세트
	Case "2018-09-08": itemid=2077216	'새콤달콤 오미베리가 듬뿍! 효종원 단 하루 특가!
	Case "2018-09-09": itemid=2066524	'[꽃을담다]한가위 꽃차선물세트  
	Case "2018-09-10": itemid=2077225	'사랑받는 추석 선물, 인테이크 선물세트 단 하루 특가!
	Case "2018-09-11": itemid=2077217	'정성 가득한 소하동 고방 한과 선물세트 단 하루 특가!
	Case "2018-09-12": itemid=2077218	'건강하고 달콤한 꿀건달 선물세트 단 하루 특가!
	Case "2018-09-13": itemid=2077219	'마이빈스 더치커피 선물세트 단 하루 특가!
	Case "2018-09-14": itemid=2088221	'인시즌 생강 5종 선물세트 -> 건강을 담은 인시즌 선물세트       //2018-09-12 상품 변경
	Case "2018-09-15": itemid=2077220	'바닐라의 풍미를 그대로, 매드바닐라 선물세트 단 하루 특가!
	Case "2018-09-16": itemid=2077221	'요리가 맛있어지는 부엉이곳간 단 하루 특가!
	Case "2018-09-17": itemid=2077222	'사랑받는 추석 선물, 당산나무벌꿀 단 하루 특가!
	Case "2018-09-18": itemid=2079438	'나만의 특별한 담금주 키트, 살룻 단 하루 특가!
	Case "2018-09-19": itemid=2095000	'사랑받는 추석 선물, 어반약과 단 하루 특가! -> 인테이크 선물세트 마지막 원데이특가!	 //2018-09-18 재고 소진으로 인해 상품 변경
	Case "2018-09-20": itemid=2077224	'6년근 홍삼이 그대로, 진1937 단 하루 특가!
	Case "2018-09-21": itemid=1780968	'힘내! 멀티비타민 오렌지구미 3개입세트 -> 간편한 아침 모닝죽 3주 선물패키지 		//2018-09-12 재고 소진으로 인해 상품 변경
	Case "2018-09-22": itemid=1780968	'힘내! 멀티비타민 오렌지구미 3개입세트 -> 간편한 아침 모닝죽 3주 선물패키지 		//2018-09-12 재고 소진으로 인해 상품 변경
	Case "2018-09-23": itemid=1780968	'힘내! 멀티비타민 오렌지구미 3개입세트 -> 간편한 아침 모닝죽 3주 선물패키지 		//2018-09-12 재고 소진으로 인해 상품 변경
	Case "2018-09-24": itemid=2071650	'한끼커리 배달가방
	Case "2018-09-25": itemid=2071650	'한끼커리 배달가방
	Case "2018-09-26": itemid=2071650	'한끼커리 배달가방		
	Case Else
		itemid=0
		baseDt=""
end Select

If itemid=0 then
	'// 기간 종료
	oJson("today") = ""
else
	'// 상품 정보 접수
	dim oItem
	dim orgprice, sellprice, saleyn
	set oItem = new CatePrdCls
		oItem.GetItemData2 itemid

		If oItem.FResultCount > 0 Then
			Set oJson("today") = jsObject()
			oJson("today")("date") = replace(baseDt,"-","/")
			oJson("today")("itemid") = cStr(itemid)
			oJson("today")("itemname") = cStr(oItem.Prd.Fitemname)
			oJson("today")("imgurl") = cStr(oItem.Prd.FImageicon1)		'150px icon image
			oJson("today")("itemdiv") = cStr(oItem.Prd.FItemDiv)		'itemdiv
			if cStr(oItem.Prd.FItemDiv) = 21 then ' 딜 상품일 경우 
				Dim oDeal, ArrDealItem
				Set oDeal = New DealCls
				oDeal.GetIDealInfo itemid

				ArrDealItem = oDeal.GetDealItemList(oDeal.Prd.FDealCode)

				orgprice = ArrDealItem(11,0) 
				sellprice =  ArrDealItem(2,0)
				saleyn = cStr(ArrDealItem(10,0)) 'saleyn

				oJson("today")("orgprice") = FormatNumber(FiX(orgprice),0) & "원"
				oJson("today")("sellprice") = FormatNumber(FiX(sellprice),0) & "원"
				oJson("today")("saleyn") = saleyn
			else
				orgprice = oItem.Prd.FOrgPrice
				sellprice =  oItem.Prd.FSellCash
				saleyn = cStr(oItem.Prd.FSaleYn)	

				oJson("today")("orgprice") = FormatNumber(FiX(orgprice),0) & "원"
				oJson("today")("sellprice") = FormatNumber(FiX(sellprice),0) & "원"
				oJson("today")("saleyn") = saleyn
			end if

			If (saleyn="Y") and (int(orgprice) - int(sellprice) > 0) THEN
				oJson("today")("saleper") = cStr(int((orgprice-sellprice)/orgprice*100)) & "%"
			else
				oJson("today")("saleper") = ""
			end if			
		else
			oJson("today") = ""
		end if
end if


'=========== 페이지별 선물 목록 ======================
dim arrItem, strSort

if pageDiv = "m" then
arrItem = "2069160,1781962,1638559,1549037,1544880,2049907,2073519,1285004,2065379,1515948,1943802,2076005,2076011,1792350,1468740,2068534,2063632,1549045,2032482,2071652,1199665,2066844,1780968,1421167"
else
arrItem = "2069160,1781962,2049907,1544880,1638559,1616984,1549037,2073519,1285004,1943802,1515948,2065379,2076005,1959277,2076011,1792350,2063632,1549045,1468740,2068534,1879148,2032482,2071652,2066844,1199665,1421167,1926845,1780968"
end if 

if arrItem<>"" then
	'정렬순서 쿼리
	dim srt, lp
	for each srt in split(arrItem,",")
		lp = lp +1
		strSort = strSort & "When itemid=" & srt & " then " & lp & " "
	next

	dim sqlStr
	sqlStr = "Select itemid, itemname, orgprice, sellcash, sailyn, itemdiv "
	sqlStr = sqlStr & "from db_item.dbo.tbl_item "
	sqlStr = sqlStr & "where itemid in (" & arrItem & ")"
	sqlStr = sqlStr & "order by case " & strSort & " end"
	rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
	
	if Not(rsget.EOF or rsget.BOF) then
		Set oJson("giftlist") = jsArray()
		
		Do Until rsget.EOF
			Set oJson("giftlist")(null) = jsObject()
			oJson("giftlist")(null)("itemid") = cStr(rsget("itemid"))
			oJson("giftlist")(null)("itemname") = cStr(rsget("itemname"))
			oJson("giftlist")(null)("orgprice") = FormatNumber(rsget("orgprice"),0) & chkIIF(rsget("itemdiv")="82","Pt","원")
			oJson("giftlist")(null)("sellprice") = FormatNumber(rsget("sellcash"),0) & chkIIF(rsget("itemdiv")="82","Pt","원")

			If (rsget("sailyn")="Y") and (rsget("orgprice") - rsget("sellcash") > 0) THEN
				oJson("giftlist")(null)("saleper") = cStr(int((rsget("orgprice")-rsget("sellcash"))/rsget("orgprice")*100)) & "%"
			else
				oJson("giftlist")(null)("saleper") = ""
			end if

			rsget.MoveNext
		loop
	else
		oJson("giftlist") = ""
	end if
	rsget.Close
else
	oJson("giftlist") = ""
end if

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
