<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<%
'###############################################
' Discription : 이벤트 상세 상품 리스트 페이지
' History : 2019.04.04 이종화
'###############################################
dim eCode , egCode , cEvent , arrGroup
dim strSql , arrList , rsMem , oJson
Dim oJsonStringCache : oJsonStringCache = NULL
Dim cTime , dummyName , jcnt , intI
dim cEventItem 
dim itemlimitcnt : itemlimitcnt = 100
dim eitemsort , iTotCnt
dim eItemListType , ThemeBarColorCode

dim classStr
dim adultChkFlag
dim isDeal , linkurl , groupIndex
dim thumbSize , ekind , eventtype , pNtr
dim itemcount
dim itemTotalCount : itemTotalCount = 0

eCode = requestCheckVar(Request("eventid"),10)	'// 이벤트 코드
egCode = requestCheckVar(Request("eGC"),10)	'// 이벤트 그룹코드
eitemsort = requestCheckVar(Request("itemsort"),10) '// 상품정렬
eItemListType = requestCheckVar(Request("listtype"),1) '// 리스트타입
ThemeBarColorCode = requestCheckVar(Request("themebarcolor"),10) '// 컬러띠
ekind = requestCheckVar(Request("ekind"),10) '// ekind
eventtype = requestCheckVar(Request("eventtype"),10) '// eventtype

pNtr = requestCheckVar(request("pNtr"),20)

Dim logparam : logparam = "&pEtr="&eCode
Dim addparam : addparam = chkiif(pNtr<>"","&pNtr="& server.URLEncode(pNtr),"")

if egCode = "" then egCode = 0
if eitemsort = "" then eitemsort = 0

'//헤더 출력
Response.ContentType = "application/json"
Response.charset = "utf-8"

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
If timer > 10 And Cint(timer/60) < 6 Then
	cTime = 60*1
	dummyName = "EVTITEMLIST_" & egCode & "_"&Cint(timer/60)
Else
	cTime = 60*5
	dummyName = "EVTITEMLIST_" & egCode
End If

'//이벤트 상품리스트 DB Cache를 사용할지 여부
function isCacheableEventItemList(itemTotalCount)
	if itemTotalCount > 100 then 
        isCacheableEventItemList = true
	else
        isCacheableEventItemList = false
    end if
END function

'// 그룹형 타입별 class
function designclass(eItemListType)
	select case eItemListType
		case "1"
			designclass = "type-grid"
		case "2"
			designclass = "type-list"
		case "3"
			designclass = "type-big"
		case else
			designclass = "type-grid"
	end select
end function

'//DB Cache를 사용하는 이벤트 상품리스트이고, DB Cache에 json 스트링이 존재하면 oJsonStringCache에 입력
IF (getDBCacheTxtVal(fnDBCacheHashKey("EVENT_JSON", Cstr(eCode)&Cstr(egCode)), oJsonStringCache)) THEN
ELSE
	'// '##### 그룹 목록 모바일 전용 ######
	strSql ="EXEC [db_event].[dbo].sp_Ten_eventitem_group_mo "&eCode&","&egCode&""

	set rsMem = getDBCacheSQL(dbget, rsget, dummyName, strSql, cTime)
	IF Not (rsMem.EOF OR rsMem.BOF) THEN
		arrList = rsMem.GetRows
	END IF
	rsMem.close
	set rsMem = nothing

	'// json객체 선언
	Set oJson = jsObject()
	on Error Resume Next

	If IsArray(arrList) Then
		oJson("listType")	= ""& designclass(eItemListType) &""
		oJson("themebarColor") = ""& chkiif(ThemeBarColorCode<>"","#"&ThemeBarColorCode,"") &""
		'// 그룹목록 별도 리스트
		Set oJson("grouplist") = jsArray()
		For jcnt = 0 to ubound(arrList,2)
		Set oJson("grouplist")(null) = jsObject()
			oJson("grouplist")(null)("groupCode") = ""& arrList(0,jcnt) &""
			oJson("grouplist")(null)("groupName") = ""& arrList(1,jcnt) &""
		Next
		'// 그룹 목록이 있을 경우 (그룹형 , MD등록 이벤트(3타입)) case 3 , 9
		Set oJson("itemlist") = jsArray()
		For jcnt = 0 to ubound(arrList,2)
			'// 그룹명 , 그룹코드
			Set oJson("itemlist")(null) = jsObject()
				oJson("itemlist")(null)("groupCode") = ""& arrList(0,jcnt) &""
				oJson("itemlist")(null)("groupName") = ""& arrList(1,jcnt) &""
				
				'// 그룹코드 치환
				egCode = arrList(0,jcnt)
				'## 상품 정보
				CALL getEventItemList(eCode,egCode,itemlimitcnt,eitemsort,itemcount)
				oJson("itemlist")(null)("itemcount") = ""& itemcount + 1 &""

				groupIndex = groupIndex + 1
				itemTotalCount = itemTotalCount + itemcount
		Next
	ELSE
		oJson("listType")	= ""& designclass(eItemListType) &""
		oJson("themebarColor") = ""& chkiif(ThemeBarColorCode<>"","#"&ThemeBarColorCode,"") &""
		'// 그룹리스트 초기값
		Set oJson("grouplist") = jsArray()
		'// 최상위 그룹만 있을 경우 (수작업 + 상품목록 , 기본형 : 메인이미지 + 상품목록) CASE 6 , NO CASE
		Set oJson("itemlist") = jsArray()
		Set oJson("itemlist")(null) = jsObject()
			oJson("itemlist")(null)("groupCode") = ""& egCode &""
			oJson("itemlist")(null)("groupName") = ""
			'## 상품 정보
			CALL getEventItemList(eCode,egCode,itemlimitcnt+600,eitemsort,itemcount)
			oJson("itemlist")(null)("itemcount") = ""& itemcount + 1 &""

			itemTotalCount = itemTotalCount + itemcount
	END IF
	'//Json 스트링 DB Cache 입력
    IF (isCacheableEventItemList(itemTotalCount)) THEN
        SetDBCacheTxtVal fnDBCacheHashKey("EVENT_JSON", eCode), oJson.jsString, "", cTime               
    END IF
END IF

'// 상품 목록 가저오기
SUB getEventItemList(eCode,egCode,itemlimitcnt,eitemsort,byref itemcount)
	Set cEventItem = new ClsEvtItem
		cEventItem.FECode 	= eCode
		cEventItem.FEGCode 	= egCode
		cEventItem.FEItemCnt= itemlimitcnt
		cEventItem.FItemsort= eitemsort
		cEventItem.fnGetEventItem_v2
		iTotCnt = cEventItem.FTotCnt

		itemcount = iTotCnt
		
		'// 상품 목록
		Set oJson("itemlist")(null)("itemlists") = jsArray()
		For intI = 0 To iTotCnt
			Set oJson("itemlist")(null)("itemlists")(null) = jsObject()

			'// init
			classStr = ""
			isDeal = false
			'// 성인인증여부
			adultChkFlag = session("isAdult") <> true and cEventItem.FCategoryPrdList(intI).FadultType = 1
			'// li 추가 클래스
			if adultChkFlag then classStr = addClassStr(classStr,"adult-item")
			if cEventItem.FCategoryPrdList(intI).FItemDiv="21" then classStr = addClassStr(classStr,"deal-item")
			'// deal 여부
			isDeal = chkiif(cEventItem.FCategoryPrdList(intI).FItemDiv="21",true,false)
			'// 격자형 리스트형 썸네일 크기 조절
			thumbSize = chkiif((eItemListType = "1") or (eItemListType = "2"),"300","400")

				oJson("itemlist")(null)("itemlists")(null)("isLogin") = IsUserLoginOK
				oJson("itemlist")(null)("itemlists")(null)("addClass") = ""& classStr &""
				oJson("itemlist")(null)("itemlists")(null)("isAdult") = adultChkFlag
				oJson("itemlist")(null)("itemlists")(null)("isDeal") = isDeal
				oJson("itemlist")(null)("itemlists")(null)("IsDirectPurchase") = cEventItem.FCategoryPrdList(intI).IsDirectPurchase
				oJson("itemlist")(null)("itemlists")(null)("itemID") = ""& cEventItem.FCategoryPrdList(intI).Fitemid &""
				oJson("itemlist")(null)("itemlists")(null)("brandName") = ""& cEventItem.FCategoryPrdList(intI).FBrandName &""
				oJson("itemlist")(null)("itemlists")(null)("itemName") = ""& cEventItem.FCategoryPrdList(intI).FItemName &""
				oJson("itemlist")(null)("itemlists")(null)("isSoldOut") = chkiif(cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut,true,false)
				oJson("itemlist")(null)("itemlists")(null)("imageURL") = ""& chkiif(Not(cEventItem.FCategoryPrdList(intI).Ftentenimage400="" Or isnull(cEventItem.FCategoryPrdList(intI).Ftentenimage400)),cEventItem.FCategoryPrdList(intI).Ftentenimage400,getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,thumbSize,thumbSize,"true","false")) &""

				if isDeal then '// deal 상품 가격 정보
					oJson("itemlist")(null)("itemlists")(null)("price") = ""& FormatNumber(cEventItem.FCategoryPrdList(intI).getOrgPrice,0) &""
					oJson("itemlist")(null)("itemlists")(null)("priceType") = ""& CHKIIF(cEventItem.FCategoryPrdList(intI).IsMileShopitem," Point","원") &""
					if not(cEventItem.FCategoryPrdList(intI).FItemOptionCnt="" Or cEventItem.FCategoryPrdList(intI).FItemOptionCnt="0") then
						oJson("itemlist")(null)("itemlists")(null)("salePer") = ""& "~" & cEventItem.FCategoryPrdList(intI).FItemOptionCnt & "%" &""
					end if 
				else '// 일반 상품 가격 정보
					if cEventItem.FCategoryPrdList(intI).IsSaleItem AND cEventItem.FCategoryPrdList(intI).isCouponItem then '### 쿠폰 O 세일 O
						oJson("itemlist")(null)("itemlists")(null)("price") = ""& FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) &""
						oJson("itemlist")(null)("itemlists")(null)("priceType") = ""& CHKIIF(cEventItem.FCategoryPrdList(intI).IsMileShopitem," Point","원") &""
						oJson("itemlist")(null)("itemlists")(null)("salePer") = ""& cEventItem.FCategoryPrdList(intI).getSalePro &""
						If cEventItem.FCategoryPrdList(intI).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
							If InStr(cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
								oJson("itemlist")(null)("itemlists")(null)("couponType") = ""
							Else
								oJson("itemlist")(null)("itemlists")(null)("couponType") = ""& cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr &""
							end if
						end if
					elseif cEventItem.FCategoryPrdList(intI).IsSaleItem AND (Not cEventItem.FCategoryPrdList(intI).isCouponItem) Then	'### 쿠폰 X 세일 O
						oJson("itemlist")(null)("itemlists")(null)("price") = ""& FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) &""
						oJson("itemlist")(null)("itemlists")(null)("priceType") = ""& CHKIIF(cEventItem.FCategoryPrdList(intI).IsMileShopitem," Point","원") &""
						oJson("itemlist")(null)("itemlists")(null)("salePer") = ""& cEventItem.FCategoryPrdList(intI).getSalePro &""
					elseIf cEventItem.FCategoryPrdList(intI).isCouponItem AND (NOT cEventItem.FCategoryPrdList(intI).IsSaleItem) Then '### 쿠폰 O 세일 X
						oJson("itemlist")(null)("itemlists")(null)("price") = ""& FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) &""
						oJson("itemlist")(null)("itemlists")(null)("priceType") = ""& CHKIIF(cEventItem.FCategoryPrdList(intI).IsMileShopitem," Point","원") &""
						If cEventItem.FCategoryPrdList(intI).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
							If InStr(cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
								oJson("itemlist")(null)("itemlists")(null)("couponType") = ""
							Else
								oJson("itemlist")(null)("itemlists")(null)("couponType") = ""& cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr &""
							end if
						end if
					else
						oJson("itemlist")(null)("itemlists")(null)("price") = ""& FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) &""
						oJson("itemlist")(null)("itemlists")(null)("priceType") = ""& CHKIIF(cEventItem.FCategoryPrdList(intI).IsMileShopitem," Point","원") &""
					end if

					'// etc 영역
					oJson("itemlist")(null)("itemlists")(null)("evalPoint") = ""& fnEvalTotalPointAVG(cEventItem.FCategoryPrdList(intI).FPoints,"search") &""
					oJson("itemlist")(null)("itemlists")(null)("reviewCount") = ""& chkIIF(cEventItem.FCategoryPrdList(intI).FEvalcnt>999,"999",cEventItem.FCategoryPrdList(intI).FEvalcnt) &""
					oJson("itemlist")(null)("itemlists")(null)("wishCount") = ""& CHKIIF(cEventItem.FCategoryPrdList(intI).FFavCount>999,"999",formatNumber(cEventItem.FCategoryPrdList(intI).FFavCount,0)) &""

					'// 무료배송
					oJson("itemlist")(null)("itemlists")(null)("freeShipping") = chkiif(cEventItem.FCategoryPrdList(intI).IsCouponItem AND cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr = "무료배송",true,false)
				end if

				oJson("itemlist")(null)("itemlists")(null)("totalcount")	= ""& logparam &""

				oJson("itemlist")(null)("itemlists")(null)("logparam")	= ""& logparam &""
				oJson("itemlist")(null)("itemlists")(null)("addparam")	= ""& addparam &""
				'// amplitude 추가 영역
				oJson("itemlist")(null)("itemlists")(null)("amplitude_eventkind") = ""& ekind &""
				oJson("itemlist")(null)("itemlists")(null)("amplitude_eventcode") = ""& eCode &""
				oJson("itemlist")(null)("itemlists")(null)("amplitude_eventtype") = ""& eventtype &""
				oJson("itemlist")(null)("itemlists")(null)("amplitude_categoryname") = ""& fnCateCodeToCategory1DepthName(cEventItem.FCategoryPrdList(intI).FCateCode) &""
				oJson("itemlist")(null)("itemlists")(null)("amplitude_brandname") = ""& Replace(Replace(cEventItem.FCategoryPrdList(intI).FBrandName," ",""),"'","") &""
				oJson("itemlist")(null)("itemlists")(null)("amplitude_groupnumber") = ""& groupIndex &""
				oJson("itemlist")(null)("itemlists")(null)("amplitude_itemindex") = ""& intI+1 &""
				oJson("itemlist")(null)("itemlists")(null)("amplitude_listtype") = ""& replace(designclass(eItemListType),"type-","") &""
		NEXT 

	Set cEventItem = nothing
END SUB
on Error Goto 0
'//Json 출력(JSON)
If IsNull(oJsonStringCache) Then
    oJson.flush
    Set oJson = Nothing
ELSE
    response.write(oJsonStringCache)
End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->