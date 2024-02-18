<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	Description : 상품상세
'	History	: 2014.01.08 한용민 생성
'             2014.09.18 허진원 2014 리뉴얼
'             2015.02.24 허진원 2015 리뉴얼
'             2016.05.06 이종화 2016 리뉴얼
'#######################################################

Session.Codepage = 65001
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/web2014/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/wishCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->
<!-- #include virtual="/lib/classes/item/sp_evaluatesearchercls.asp" -->
<!-- #include virtual="/lib/classes/item/sp_item_qnacls.asp" -->
<!-- #include virtual="/lib/classes/item/PlusSaleItemCls.asp" -->
<!-- #include virtual="/lib/classes/diarystory/diary_class.asp" -->
<!-- #include virtual="/lib/classes/award/newawardcls.asp" -->
<!-- #include virtual="/lib/classes/gift/gifttalkCls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_itemcouponcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/order_card_discountcls.asp" -->
<%
	dim itemid	: itemid = requestCheckVar(request("itemid"),9)
	Dim page, vDisp, cpid, vDepth, vMakerid, GiftNotice
	Dim oItemOptionMultiple, oItemOption, isAlarmOptionPushChk, oItemOptionMultipleType, strSql, multiOptionValue
	dim pNtr	: pNtr = requestCheckVar(request("pNtr"),30)
	dim isQuickDlv, NewDeliveryName, ItemDeliveryTime, DeliveryInfoNum
	dim adultChkFlag, adultcb, IsRentalItem

	''facebook 예외처리 2019/06/04 ex)?itemid=123123&targeturl=...&itemid=123123
	if InStr(itemid,",")>0 then
		itemid = LEFT(itemid,InStr(itemid,",")-1)
	end if

'	If pNtr <> "" Then
'		pNtr = URLDecodeUTF8(pNtr)
'	End If

	if page="" then page=1

	if itemid="" or itemid="0" then
		Call Alert_AppClose("상품번호가 없습니다.")
		response.End
	elseif Not(isNumeric(itemid)) then
		Call Alert_AppClose("잘못된 상품번호입니다.")
		response.End
	else
		'정수형태로 변환
		itemid=CLng(getNumeric(itemid))
	end if

	if itemid=0 then
		Call Alert_AppClose("상품번호가 없습니다.")
		response.End
	end if

	dim LoginUserid
	LoginUserid = getLoginUserid()

    If Not (LEFT(Request.ServerVariables("HTTP_HOST"),1) = "m" And application("Svr_Info")="staging") Then
        If Request.ServerVariables("SERVER_PORT") = "443" Then
            Response.Redirect "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("PATH_INFO") & "?" & Request.ServerVariables("QUERY_STRING")
        End If
    End If

	dim flag : flag = request("flag")

	Dim vPrtr
	vPrtr = requestCheckVar(request("pRtr"),200)
	'// 검색어 개행문자 처리
	vPrtr = replace(vPrtr, chr(13),"")
	vPrtr = replace(vPrtr, chr(10),"")

	dim oItem, ItemContent
	set oItem = new CatePrdCls
	oItem.GetItemData itemid

	if oItem.FResultCount=0 then
		Call Alert_AppClose("존재하지 않는 상품입니다.")
		response.End
	end If

	'//2021-06-01 마케팅 전용 상품 접근 불가 정태훈
	if (oItem.Prd.FItemDiv = "17") Then
		Response.redirect("/category/closedprd.asp?"&request.servervariables("QUERY_STRING"))
	End If

	'// amplitude를 통한 데이터 확인을 위해 gaparam으로 넘어오는값 체크
	Dim gaparamChkVal
	gaparamChkVal = requestCheckVar(request("gaparam"),30)

	if (oItem.Prd.FItemDiv = "21") Then
		'딜상품 딜 페이지로 이동
		Response.redirect("/apps/appCom/wish/web2014/deal/deal.asp?itemid="&Cstr(itemid)&"&gaparam="&gaparamChkVal)

    '// Biz상품은 앱에서 접근 불가
	ElseIf (oItem.Prd.FItemDiv = "23") Then
		Call Alert_Return("잘못된 상품번호입니다.")
        response.End
	End If

	'// 이벤트 상품 접근 제한 (첫구매샵, 타임특가)
	Select Case cStr(itemid)
		Case "3420917","3421394","3421395","3680472","3687012","3733042","3742097","3760104","3758040"
			Response.redirect("/category/closedprd.asp?"&request.servervariables("QUERY_STRING"))
		Case "3424997","3424998","3418284","3424999","3425011","3418290","3425012","3425021","3425022"
			Response.redirect("/category/closedprd.asp?"&request.servervariables("QUERY_STRING"))
		Case "3465575","3465576","3465577","3465583","3465584","3465585","3465586","3458651","3675389"
			Response.redirect("/category/closedprd.asp?"&request.servervariables("QUERY_STRING"))
		Case "3493942","3493958","3493962","3493976","3493993","3493994","3493998","3494000","3494001"
			Response.redirect("/category/closedprd.asp?"&request.servervariables("QUERY_STRING"))
		Case "3527551","3554837","3570847","3568687","3589288","3628565","3654550","3654634","3654662"
			Response.redirect("/category/closedprd.asp?"&request.servervariables("QUERY_STRING"))
		Case "3577689","3573760","3573757","3577707","3577713","3573758","3573761","3577718","3573759"
			Response.redirect("/category/closedprd.asp?"&request.servervariables("QUERY_STRING"))
		Case "3713161","3715297","3708341","3690021","3714968","3715334","3713169","3715328","3715002","3701844"
			Response.redirect("/category/closedprd.asp?"&request.servervariables("QUERY_STRING"))
		Case "3713643","3717297","3708348","3715298","3714963","3715197","3709143","3713170","3715332","3717425","3731023"
			Response.redirect("/category/closedprd.asp?"&request.servervariables("QUERY_STRING"))
		Case "3707491","3707496","3707497","3707498","3707499","3707500","3721834","3770922","3770926"
			Response.redirect("/category/closedprd.asp?"&request.servervariables("QUERY_STRING"))
		Case "3718849","3686950","3709144","3721795","3725107","3721797","3718165","3722309","3730632","3725215"
			Response.redirect("/category/closedprd.asp?"&request.servervariables("QUERY_STRING"))
		Case "3741794","3717297","3741793","3731934","3738663","3742256","3738635","3742255","3738453"
			Response.redirect("/category/closedprd.asp?"&request.servervariables("QUERY_STRING"))
		Case "3746914","3746908","3722405","3752141","3454935","3742749","3742229","3747691","3747692","3738455"
			Response.redirect("/category/closedprd.asp?"&request.servervariables("QUERY_STRING"))
		Case "3753079","3748354","3731940","3739018","3753051","3752204","3754681","3699585","3752630","3738469"
			Response.redirect("/category/closedprd.asp?"&request.servervariables("QUERY_STRING"))
		Case "3797904","3810958","3810962","3810961","3810963","3810964","3810966","3810970","3830803","3855665"
			Response.redirect("/category/closedprd.asp?"&request.servervariables("QUERY_STRING"))
	End Select

	'// 특정상품 쿠폰가격 노출 안함 : 적용 범위 - (텐바이텐가 , 쿠폰적용가)
	dim isCouponPriceDisplay : isCouponPriceDisplay = true
	Select Case cStr(itemid)
		Case "2624996", "2624995"
			isCouponPriceDisplay = false
	End Select

    '//2022 2월 빅세일 뱃지 노출 체크
    'dim bigSaleItemCheck
    'bigSaleItemCheck = fnGetBigSaleItemCheck(itemid)

	if oItem.Prd.Fisusing="N" then
		Call Alert_AppClose("판매가 종료되었거나 삭제된 상품입니다.")
		response.End
	end if

	'// 파라메터 접수
	vDisp = requestCheckVar(getNumeric(Request("disp")),18)
	if vDisp="" or (len(vDisp) mod 3)<>0 then vDisp = oItem.Prd.FcateCode

	'// 브랜드ID 접수
	vMakerid = oItem.Prd.Fmakerid

	'### 현재 위치 ###
	Dim vCateNavi, vCateItemCount, vIsLastDepth, vCateCnt
	vIsLastDepth = true		'최하단 여부
	vCateNavi = printCategoryHistorymultiApp(vDisp,vIsLastDepth,false,vCateCnt)

	'// 추가 이미지
	dim oADD
	set oADD = new CatePrdCls
	oADD.getAddImage itemid

	'//상품 후기
	dim oEval,i,j,ix
	set oEval = new CEvaluateSearcher
	oEval.FPageSize = 8
	oEval.FScrollCount = 5
	oEval.FCurrpage = page
	oEval.FRectItemID = itemid

		'상품 후기가 있을때만 쿼리.
		if oItem.Prd.FEvalCnt>0 and cFlgDBUse then
			oEval.getItemEvalList
		end if

	'//상품 문의
	Dim oQna
	set oQna = new CItemQna

	''스페셜 브랜드일경우 상품 문의 불러오기
	If (oItem.Prd.IsSpecialBrand and oItem.Prd.FQnaCnt>0 and cFlgDBUse) Then
		oQna.FRectItemID = itemid
		oQna.FPageSize = 5
		oQna.ItemQnaList
	End If

	'// 티켓팅
	Dim IsTicketItem, oTicket
	IsTicketItem = (oItem.Prd.FItemDiv = "08")
	If IsTicketItem Then
		set oTicket = new CTicketItem
		oTicket.FRectItemID = itemid
		oTicket.GetOneTicketItem
	End if

	'// Present상품
	Dim IsPresentItem
	IsPresentItem = (oItem.Prd.FItemDiv = "09")

	'// 스페셜 항공권 상품 (ex 진에어 이벤트)
	Dim IsSpcTravelItem
	IsSpcTravelItem = oitem.Prd.IsTravelItem and oItem.Prd.Fmakerid = "10x10Jinair"

	'// 공유 제한 상품 (프리젠트 상품 또는 특수한 브랜드)
	Dim isSpCtlIem
	isSpCtlIem = (IsPresentItem or oItem.Prd.FMakerid="10x10present")

	'// 렌탈상품
	IsRentalItem = (oItem.Prd.FItemDiv = "30")

	'판매 매장 정보
	dim arrOffShopList
	arrOffShopList = oItem.GetSellOffShopList(itemid,2)

	'// 현장수령 상품
	Dim IsReceiveSiteItem
	IsReceiveSiteItem = (oItem.Prd.FDeliverytype="6")

	'=============================== 이메일특가 번호 접수 및 특가 계산 (base64사용) =================================
	cpid = requestCheckVar(request("ldv"),12)
	if Not(cpid="" or isNull(cpid)) then
		cpid = trim(Base64decode(cpid))
		if isNumeric(cpid) then
			oItem.getTargetCoupon cpid, itemid
		end if
	end if

	' ''발행 받은 타겟 쿠폰 존재여부 //2019/05/29 //2019/05/29  제거(2019/06/11)
	' dim idRecevedTargetCpnExists : idRecevedTargetCpnExists = FALSE
	' if (IsUserLoginOK) then
	' 	idRecevedTargetCpnExists = oItem.getReceivedValidTargetItemCouponExists(LoginUserid, itemid)
	' end if

	''시크릿 쿠폰 존재여부 //2019/06/10
	dim isValidSecretItemcouponExists : isValidSecretItemcouponExists = FALSE
	dim secretcouponidx : secretcouponidx=-1
	if (IsUserLoginOK) then
		secretcouponidx = oItem.getValidSecretItemCouponDownIdx(LoginUserid, itemid)
		isValidSecretItemcouponExists =(secretcouponidx>0)
	end if

	'//옵션 HTML생성
	dim ioptionBoxHtml
	IF (oitem.Prd.FOptionCnt>0) then
		if (IsReceiveSiteItem) or (IsPresentItem) or (IsTicketItem) or (oItem.Prd.Flimitdispyn="N") then
			ioptionBoxHtml = GetOptionBoxDpLimit2017(itemid, oitem.Prd.IsSoldOut,Not(IsReceiveSiteItem) and Not(IsPresentItem and oItem.Prd.FRemainCount>200) and Not(IsTicketItem and oItem.Prd.FRemainCount>100 ) and Not(oItem.Prd.Flimitdispyn="N"))
		else
		    ioptionBoxHtml = GetOptionBox2017(itemid, oitem.Prd.IsSoldOut)
		end if
	End IF

	function ImageExists(byval iimg)
		if (IsNull(iimg)) or (trim(iimg)="") or (Right(trim(iimg),1)="\") or (Right(trim(iimg),1)="/") then
			ImageExists = false
		else
			ImageExists = true
		end if
	end function

	'// 추가 이미지-메인 이미지
	Function getFirstAddimage()
		if ImageExists(oitem.Prd.FImageBasic) then
			getFirstAddimage= oitem.Prd.FImageBasic
		elseif ImageExists(oitem.Prd.FImageMask) then
			getFirstAddimage= oitem.Prd.FImageMask
		elseif (oAdd.FResultCount>0) then
			if ImageExists(oAdd.FADD(0).FAddimage) then
				getFirstAddimage= oAdd.FADD(0).FAddimage
			end if
		else
			getFirstAddimage= oitem.Prd.FImageMain
		end if
	end Function

	'2013 다이어리 상품 체크 유무
	Dim clsDiaryPrdCheck, GiftSu
	set clsDiaryPrdCheck = new cdiary_list
		clsDiaryPrdCheck.FItemID = itemid
		clsDiaryPrdCheck.DiaryStoryProdCheck
		If clsDiaryPrdCheck.FResultCount  > 0 then
			GiftSu = clsDiaryPrdCheck.getGiftDiaryExists(itemid)	'다이어리 상은품 남은수량
		end If
		GiftNotice=False '사은품 소진 노티
	dim giftCheck : giftCheck = False '사은품 표기 온오프

	'//상품설명 추가
	dim addEx
	set addEx = new CatePrdCls
		addEx.getItemAddExplain itemid

	Dim tempsource , tempsize

	tempsource = oItem.Prd.FItemSource
	tempsize = oItem.Prd.FItemSize

	'//내 위시 상품 여부
	dim isMyFavItem: isMyFavItem=false
	if IsUserLoginOK then
		isMyFavItem = getIsMyFavItem(LoginUserid,itemid)
	end if

	'### 쇼핑톡 카운트.
	Dim cTalk, vTalkCount, vTIItemID1, vTIItemName1, vTIItemID2, vTIItemName2, vTICount
	SET cTalk = New CGiftTalk
	cTalk.FPageSize = 5
	cTalk.FCurrpage = 1
	cTalk.FRectItemId = itemid
	cTalk.FRectUseYN = "y"
	cTalk.FRectOnlyCount = "o"
	''cTalk.sbGiftTalkList
	''vTalkCount = cTalk.FTotalCount ''않쓰임? //부하 많음.
	vTICount = 0

	If IsUserLoginOK and cFlgDBUse Then
		cTalk.FPageSize = 2
		cTalk.FRectUserId = GetLoginUserID()
		cTalk.fnGiftTalkMyItemList
		vTICount = cTalk.FTotalCount
		If vTICount > 0 Then
			vTIItemID1		= cTalk.FItemList(0).FItemID
			vTIItemName1	= cTalk.FItemList(0).FItemName
		End If
		If vTICount > 1 Then
			vTIItemID2		= cTalk.FItemList(1).FItemID
			vTIItemName2	= "B. " & cTalk.FItemList(1).FItemName
			vTIItemID1		= cTalk.FItemList(0).FItemID
			vTIItemName1	= "A. " & cTalk.FItemList(0).FItemName
		End If
	End If
	SET cTalk = Nothing

    '### 상품 상세 캡쳐이미지 (APP용) 2015/12/02 추가.
    Dim vItemDtlViewType
    if (flgDevice="A") then
        if (fnIsItemDtlCaptureExists(itemid)) then
            vItemDtlViewType = "1"                  '' 앱에서 보여줌.
        end if
    end if
    ''-----------------------------------------------

	'// 페이지 타이틀
	strPageTitle = "10X10: " & oItem.Prd.FItemName

	'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
	dim snpTitle, snpLink, snpPre, snpImg, snpTag, orgTitle, snpTag2
	snpTitle = oItem.Prd.FItemName
	snpLink = "http://m.10x10.co.kr/category/category_itemprd.asp?itemid=" & itemid
	snpPre = "텐바이텐 HOT ITEM!"
	snpImg = oItem.Prd.FImageBasic
	snpTag = "#10x10"


	'// 상품상세 로그 사용여부(2017.01.12)
	Dim LogUsingCustomChk
	If LoginUserId="thensi7" Then
		LogUsingCustomChk = True
	Else
		LogUsingCustomChk = True
	End If

	'// 상품상세 로그저장(2017.01.11 원승현)
	If LogUsingCustomChk Then
		If IsUserLoginOK() Then
			Call fnUserLogCheck("item", LoginUserid, itemid, "", "", "app")
		End If
	End If

	'// 구글 ADS 스크립트 관련(2018.09.21 신규버전 추가)
	googleADSCRIPT = " <script> "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "   gtag('event', 'page_view', { "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "     'send_to': 'AW-851282978', "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "     'ecomm_pagetype': 'product', "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "     'ecomm_prodid': '"&itemid&"', "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "     'ecomm_totalvalue': "&oItem.Prd.FSellCash&" "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "   }); "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & " </script> "

	'// appBoy CustomEvent
	appBoyCustomEvent = "userProductView"

	'// 옵션이 있는 상품중 단일 또는 복합옵션일 경우 해당 옵션의 품절여부를 가져온다.
	If trim(oItem.Prd.FSellYn) = "Y" Then
		isAlarmOptionPushChk = False
		'// 옵션정보를 가져온다.
		set oItemOption = new CItemOption
		oItemOption.FRectItemID = itemid
		oItemOption.FRectIsUsing = "Y"
		oItemOption.GetOptionList

		If oItemOption.FResultCount>0 Then
			set oItemOptionMultiple = new CItemOption
			oItemOptionMultiple.FRectItemID = itemid
			oItemOptionMultiple.GetOptionMultipleList

			If oItemOptionMultiple.FResultCount>0 Then
				'// 멀티옵션일 경우
				set oItemOptionMultipleType = new CItemOption
				oItemOptionMultipleType.FRectItemId = itemid
				oItemOptionMultipleType.GetOptionMultipleTypeList

				strSql = " Select top 1 "
				strSql = strSql & "	itemid, "
				strSql = strSql & "		stuff( "
				strSql = strSql & "				( "
				strSql = strSql & "					Select ','''+substring(itemoption, 1, "&oItemOptionMultipleType.FResultCount&")+'''' "
				strSql = strSql & "					From db_item.[dbo].[tbl_item_option] "
				strSql = strSql & "					Where itemid = o.itemid And optsellyn='Y' "
				strSql = strSql & "					group by itemid, substring(itemoption, 1, "&oItemOptionMultipleType.FResultCount&")  "
				strSql = strSql & "					FOR XML PATH('') "
				strSql = strSql & "				),1,1,'' "
				strSql = strSql & "			 ) as availableOpt  "
				strSql = strSql & "	From db_item.[dbo].[tbl_item_option] o Where itemid='"&itemid&"' And optsellyn='Y' "
				strSql = strSql & "	group by itemid "
				rsget.Open strSql, dbget, 1
				if Not rsget.Eof Then
					multiOptionValue = rsget("availableOpt")
				End If
				rsget.close

				strSql = " Select * From db_item.dbo.tbl_item_option Where itemid='"&itemid&"' And substring(itemoption, 1, "&oItemOptionMultipleType.FResultCount&") in ("&multiOptionValue&") And "
				strSql = strSql & "		case when optlimityn='N' then  "
				strSql = strSql & "			case when optsellyn='N' then 0 "
				strSql = strSql & "			else 1 end "
				strSql = strSql & "		else (optlimitno-optlimitsold) end < 1 "
				rsget.Open strSql, dbget, 1
				if Not rsget.Eof Then
					Do Until rsget.eof
						isAlarmOptionPushChk = True
					rsget.movenext
					Loop
				End If
				rsget.close
			Else
				'// 단일옵션일 경우
				for i=0 to oItemOption.FResultCount-1
					If ((oitem.Prd.IsSoldOut) or (oItemOption.FItemList(i).IsOptionSoldOut)) Then
						isAlarmOptionPushChk = True
					End If
				Next
			End If

			Set oItemOptionMultiple = Nothing
		End If

		Set oItemOption = Nothing
	End If

	'=============================== 바로 배송 상품 여부 2018/06/15 최종원
	isQuickDlv = 0
	' If NOT (itemid="" or itemid="0") Then
	' 	if(oitem.Prd.FDeliverytype="1" or oitem.Prd.FDeliverytype="4") then
	' 		strSql = " SELECT COUNT(*) AS RESULT"
	' 		strSql = strSql & "	FROM DB_ITEM.DBO.TBL_ITEM_QUICKDLV "
	' 		strSql = strSql & "	WHERE ITEMID = '"&itemid&"'"

	' 		rsget.CursorLocation = adUseClient
	' 		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly

	' 		if Not rsget.Eof Then
	' 		isQuickDlv = rsget("RESULT")
	' 		End If
	' 		rsget.close
	' 	end if
	' End If

	'// 바로배송 종료에 따른 처리
	' If now() > #07/31/2019 12:00:00# Then
	' 	isQuickDlv = 0
	' End If
'==================================아리따움 이벤트 상품=========================================================
	dim isAritaumItem
	isAritaumItem = false
	If Now() > #09/01/2018 00:00:00# AND Now() < #09/30/2018 23:59:59# Then
		If NOT (itemid="" or itemid="0") Then
			if itemid = 2075053 or itemid = 2075052 or itemid = 2075051 or itemid = 2075050 or itemid = 2075019 or itemid = 2075018 or itemid = 2075016 or itemid = 2074968 or itemid = 2074965 or itemid = 2074962 or itemid = 2074914 or itemid = 2074907 or itemid = 2074859 or itemid = 2074737 or itemid = 2074432 or itemid = 2074445 or itemid = 2074465 or itemid = 2074453 then
				isAritaumItem = true
			end if
		end if
	end if
	'// 하나 텐바이텐 체크카드로만 구매되는 상품인지 확인.
	'// 하나체크 전용상품 관련
	Dim IsOnlyHanaTenPayValidItemInPrd
	IsOnlyHanaTenPayValidItemInPrd = False
	Select Case Trim(itemid)
		Case "1967223","2014099"
			IsOnlyHanaTenPayValidItemInPrd = True
		Case Else
			IsOnlyHanaTenPayValidItemInPrd = False
	End Select

	'// URLEncode 히스토리용 임시
	function b64encodeprd(str)
		str = base64encode(str)
		str = replace(str,"+","-")
		str = replace(str,"/","_")
		b64encodeprd = str
	end function

	''카테브랜드 쿠폰 관련
	dim cateBrandCpnArr, isCateBrandCpnExists : isCateBrandCpnExists = FALSE
	cateBrandCpnArr = oitem.getCatebrandCPnTop1(itemid)
	isCateBrandCpnExists = IsArray(cateBrandCpnArr)

	'// 2018년 11월 5일부터 7일까지 진행된 아이폰 구매 이벤트(천원의기적) 관련 상품상세로 들어오면 튕긴다.
	'// 2018년 11월 19일 부터 21일까지 진행된 에어팟 구매 이벤트(천원의기적2) 관련 상품상세로 들어오면 튕긴다.
	'// 2018년 12월 3일 부터 5일까지 진행된 하와이 여행 상품권 이벤트(천원의기적3) 관련 상품상세로 들어오면 튕긴다.
	'// 2018년 12월 17일 부터 19일까지 진행된 아이패드프로 이벤트(천원의기적4) 관련 상품상세로 들어오면 튕긴다.
	if (trim(itemid)="2135191") Or (trim(itemid)="2145838") Or (trim(itemid)="2145984") Or (trim(itemid)="2146034") Or (trim(itemid)="2165571") Or (trim(itemid)="2181366") Or (trim(itemid)="2199320") then
		Call Alert_AppClose("본 상품은 이벤트 페이지에서만 확인하실 수 있습니다.")
		response.End
	end if
	'//호로요이
	if (trim(itemid)="2191082") then
		Call Alert_AppClose("본 상품은 이벤트 페이지에서만 확인하실 수 있습니다.")
		response.End
	end if
	'// 2019-03-27 100원의 기적 상품
	if (trim(itemid)="2290327") or (trim(itemid)="2292048") or (trim(itemid)="2292964") or (trim(itemid)="2292057") or (trim(itemid)="2292077") or (trim(itemid)="2292085") or (trim(itemid)="2292103") or (trim(itemid)="2292160") or (trim(itemid)="2292200") or (trim(itemid)="2292207") or (trim(itemid)="2292988") or (trim(itemid)="2293045") or (trim(itemid)="2293047") or (trim(itemid)="2293053") or (trim(itemid)="2293059") or (trim(itemid)="2293060") or (trim(itemid)="2292208") then
		Call Alert_AppClose("본 상품은 이벤트 페이지에서만 확인하실 수 있습니다.")
		response.End
	end if
	'// 2019-06-17 100원 자판기 상품
	if (trim(itemid)="2394974") or (trim(itemid)="2394975") or (trim(itemid)="2395008") or (trim(itemid)="2395002") or (trim(itemid)="2395009") or (trim(itemid)="2395062") or (trim(itemid)="2394978") then
		Call Alert_AppClose("본 상품은 이벤트 페이지에서만 확인하실 수 있습니다.")
		response.End
	end if
	'// 2019-09-26 18주년 - 100원 자판기 상품
	if (trim(itemid)="2521744") or (trim(itemid)="2521751") or (trim(itemid)="2521754") or (trim(itemid)="2521803") or (trim(itemid)="2521842") or (trim(itemid)="2521860") or (trim(itemid)="2521861") or (trim(itemid)="2521862") then
		response.write "<script>alert('본 상품은 이벤트 페이지에서만 확인하실 수 있습니다.');history.back();</script>"
		response.End
	end if

	'// 2019-11-20 메리라이트 , 크리스박스
	if trim(itemid)="2574336" or trim(itemid)="2618838" then
		response.write "<script>alert('본 상품은 이벤트 페이지에서만 확인하실 수 있습니다.');history.back();</script>"
		response.End
	end if

	'//후기 A/B 테스트
'	Dim mAbTestReviewApp
'	If request.Cookies("mAbTestReviewApp")="" Then
'		mAbTestReviewApp = session.sessionid Mod 2
'		response.Cookies("mAbTestReviewApp") = mAbTestReviewApp
'		response.Cookies("mAbTestReviewApp").expires = DateAdd("ww",2,Now())
'	Else
'		mAbTestReviewApp = request.Cookies("mAbTestReviewApp")
'	End If

	'// 비회원일경우 회원가입 이후 페이지 이동을 위해 현재 페이지 주소를 쿠키에 저장해놓는다.
	If Not(IsUserLoginOK) Then
		response.cookies("sToMUA") = tenEnc(replace(Request.ServerVariables("url")&"?"&Request.ServerVariables("QUERY_STRING"),"index.asp",""))
		Response.Cookies("sToMUA").expires = dateadd("d",1,now())
	End If
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/temp_a.css?v=1.72" />
<script type="application/x-javascript" src="/lib/js/itemPrdDetail.js?v=1.116"></script>
<script type="application/x-javascript" src="/apps/appCom/wish/web2014/lib/js/shoppingbag_script.js?v=1.223"></script>
<script type="application/x-javascript" src="/lib/js/jquery.numspinner_m.js"></script>
<script src="https://unpkg.com/@lottiefiles/lottie-player@latest/dist/lottie-player.js"></script>
<script type="text/javascript">
    let cate1_name = "<%= replace(getCateName(oItem.Prd.FcateCode, 1),"'","") %>";
    let cate2_name = "<%= replace(getCateName(oItem.Prd.FcateCode, 2),"'","") %>";

    let reviewVue;

    var remaskW;
    var remaskH;
    $(function() {
        remaskW = $(document).width();
        remaskH = $(document).height();
        var fired = false;

        <% If isRentalItem Then %>
            <%'// 테스트용으로 4월 19일 부터 셋팅 실서버 배포시에는 5월 3일 10시로 바꿔야됨%>
            <% If now() >= #2021-05-03 09:00:00# and now() < #2021-06-01 00:00:00# Then %>
                <%'// 이니렌탈 이벤트(2021년 5월 3일~2021년 5월 31일)%>
                iniRentalPriceCalculation('12');
                $("#rentalmonth").val('12');
            <% Else %>
                iniRentalPriceCalculation('12');
                $("#rentalmonth").val('12');
            <% End If %>
        <% End If %>

        //플로팅 밀림방지 앱전용
        <% if (flgDevice="I") then %>
        var saveh = 0;
        $('.itemoption select[name="item_option"] , .rqtxt textarea').focus(function() {
            saveh = $(document).scrollTop();
            var userH = document.documentElement.clientHeight;
            $(".itemFloatingV16a").css('position','absolute');
            $(".container").css('height', userH+'px');
            $(".container").css('overflow', 'hidden');
        }).blur(function(){
            $(document).scrollTop(saveh);
            $(".itemFloatingV16a").css('position','fixed');
            $(".container").css('height', 'auto');
            $(".container").css('overflow', 'auto');
        });
        <% end if %>

        //창 타이틀 변경
        setTimeout(function(){
            fnAPPchangPopCaption("상품정보");
        }, 100);

        // 로딩후 스크롤 다운
    //	setTimeout(function(){
    //		$('html, body').animate({scrollTop:$(".itemPrdV16a").offset().top}, 'fast');
    //	}, 300);

        // Top버튼 위치 이동
        $(".goTop").addClass("topHigh");

        // navi - hide show
        $("#breadcrumbs").hide();
        $(window).scroll(function() {
            var window_top = $(window).scrollTop();
            var div_top = $(".itemDeatilV16a").offset().top;
            var div_nav = $("#breadcrumbs").offset().top;

            if (window_top >= div_top) {
                $(".commonTabV16a").addClass('sticky');
            } else {
                $(".commonTabV16a").removeClass('sticky');
            }

            if (window_top <= div_nav) {
                $("#breadcrumbs").show();
                breadcrumbsSwiper();
            }
        });

        // product detail tab control
        $(".itemDeatilV16a .tabCont > div:first").show();
        $('.itemDeatilV16a .commonTabV16a li').click(function(){
            $(".itemDeatilV16a .tabCont > div").hide();
            $('.itemDeatilV16a .commonTabV16a li').removeClass('current');
            $(this).addClass('current');
            var tabView = $(".itemDeatilV16a .tabCont div[id|='"+ $(this).attr('name') +"']");
            var tabNum = $(this).attr('tno');

            // 후기는 Vuejs
            if( tabNum != 3 ) {
                //탭내용 넣기
                if($(tabView).html()=="") {
                    var tabFile = "/apps/appcom/wish/web2014/category/category_itemprd_ajax.asp?itemid=<%=itemid%>&tabno="+tabNum+"&tnm="+$(this).attr('name');
                    if(tabFile!="") {
                        $.ajax({
                            type: "get",
                            url: tabFile,
                            cache: false,
                            success: function(message) {
                                $(tabView).empty().html(message);
                            }
                        });
                    }
                }
            }
            $(tabView).show();
            $('html, body').animate({scrollTop: $(".itemDeatilV16a").offset().top}, 500);
            if( reviewVue.$refs.reviewGallery )
                reviewVue.$refs.reviewGallery.setSwiper(); // 후기 갤러리 스와이퍼 set
        });

        // 로딩중 표시
        $("#lyLoading").ajaxStart(function(){
            $(this).show();
        }).ajaxStop(function(){
            $(this).hide();
        });

        /* item swiper */
        if ($("#itemSwiper .swiper-container .swiper-slide").length > 1) {
            var rollingSwiper = new Swiper("#itemSwiper .swiper-container", {
                loop:true,
                speed:1000,
                autoplay: 2000,
                parallax:true,
                onSlideChangeStart: function (rollingSwiper) {
                    var vActIdx = parseInt(rollingSwiper.activeIndex);
                    if (vActIdx<=0) {
                        vActIdx = rollingSwiper.slides.length-2;
                    } else if(vActIdx>(rollingSwiper.slides.length-2)) {
                        vActIdx = 1;
                    }
                    $(".pagination-no b").text(vActIdx);
                }
            });
            $(".pagination-no").show();
            $(".pagination-no b").text(1);
            $(".pagination-no span").text(rollingSwiper.slides.length-2);
        }

        // plus slae swipe
        if ($("#plussaleSwiper .swiper-container .swiper-slide").length > 1) {
            var plussaleSwiper = new Swiper("#plussaleSwiper .swiper-container", {
                //loop:true,
                slidesPerView:"auto"
            });
        }

        //제작 문구만 있는 경우
        if (!$('.itemoption #opttag a:first').hasClass('on')){
            $('.txtBoxV16a').addClass('current');
        }

        $(".qnaListV16a li .a").hide();
        $(".qnaListV16a li").each(function(){
            if ($(this).children(".a").length > 0) {
                $(this).children('.q').addClass("hasA");
            }
        });

        $(".qnaListV16a li .q").click(function(){
            $(".qnaListV16a li .a").hide();
            if($(this).next().is(":hidden")){
                $(this).parent().children('.a').show();
            }else{
                $(this).parent().children('.a').hide();
            };
        });

        //2016/09/22 추가 mint 구매추적
        //동시에 여러customAPI 먹는지 확인필요.
        //track을 마지막으로 호출(2016.09.22 facebook ads 관련 원승현 수정)
        setTimeout("fnAPPsetTrackLog(\"view\",\"['<%=itemid%>']\",\"<%=oItem.Prd.GetCouponAssignPrice%>\");",1200);

    });

    /*
    *  Start of Function About Amplitude
    * */
    function click_shoppingbag_in_product(type){
        let view_product_data = {
            itemid : "<%=itemid%>"
            , category_name_depth1  : cate1_name
            , category_name_depth2  : cate2_name
            , product_name : "<%=Server.URLEncode(replace(oitem.Prd.FItemName,"'",""))%>"
            , price : "<%=oItem.Prd.FSellCash%>"
            , category_code : "<%=vDisp%>"
            , brand_id : "<%=oItem.Prd.Fmakerid%>"
            , brand_name : "<%=Server.URLEncode(replace(oItem.Prd.FBrandName,"'",""))%>"
            , reviewpoints : "<%=round(oItem.Prd.Fpoints,2)%>"
            , reviewcount : "<%=oItem.Prd.FEvalCnt%>"
            , quantity : document.sbagfrm.itemea.value
        };
        fnAmplitudeEventActionJsonData(
            'click_shoppingbag_in_product'
            , JSON.stringify(view_product_data)
            , function(bool){
                if(bool) {
                    switch (type){
                        case "addShoppingBag" : TnAddShoppingBag(); break;
                        case "addShoppingBagOption" :
                            setTimeout(function() {
                                <%=chkiif(oItem.Prd.FOptionCnt>0,"FnAddShoppingBag(true)","TnAddShoppingBag(true)")%>
                            },10);
                            setTimeout(function() {
                                branchAddToCartEventLoging();
                            }, 30);
                            setTimeout(function(){
                                appierProductFunction("product_added_to_cart");
                            }, 50);
                            break;
                        case "addShoppingBagAdult" :
                            setTimeout(function() {
                                confirmAdultAuth('<%=Server.URLencode(CurrURLQ())%>', <%=chkiif(IsUserLoginOK, "true", "false")%>)
                            },10);
                    }
                }
            }
        );
    }

    function amplitude_click_wish_in_product(){
        let view_product_data = {
            action : "on"
            , brand_id  : "<%=oItem.Prd.Fmakerid%>"
            , brand_name  : "<%=oItem.Prd.FBrandName%>"
            , category_name_depth1  : cate1_name
            , category_name_depth2  : cate2_name
            , item_id  : "<%=itemid%>"
            , product_name  : "<%=replace(oItem.Prd.FItemName,"""","")%>"
        };

        fnAmplitudeEventActionJsonData('click_wish_in_product', JSON.stringify(view_product_data));
    }
    /*
    * End of Function About Amplitude
    * */

    /*
    * Start of Function About Appier
    * */
    let Advertisement_image_url = "<%=getThumbImgFromURL(oItem.Prd.FImageBasic,400,400,"true","false")%>";
    let appier_product_list = new Array();

    function appierProductFunction(caller_name) {
        let appier_product_data = {
            "category_name_depth1" : cate1_name
            , "category_name_depth2" : cate2_name
            , "brand_id" : "<%=oItem.Prd.Fmakerid%>"
            , "brand_name" : "<%=oItem.Prd.FBrandName%>"
            , "product_id" : "<%=itemid%>"
            , "product_name" : "<%=oItem.Prd.FItemName%>"
            , "product_image_url" : Advertisement_image_url
            , "product_url" : " tenwishapp://http://m.10x10.co.kr/apps/appcom/wish/web2014/category/category_itemPrd.asp?itemid=<%=itemid%>"
            , "product_price" : parseInt("<%=oItem.Prd.getOrgPrice%>")
        };

        switch (caller_name){
            case "product_viewed" : case "product_added_to_wishlist" :
                appier_product_data.keyword = "<%=oitem.Prd.FKeywords%>";
                fnAppierLogEventProperties(caller_name, appier_product_data);
                break;
            case "product_added_to_cart" : case "click_directorder_in_product" :
                appier_product_list = new Array();
                <%
                    IF oItem.Prd.FOptionCnt>0 THEN
                %>
                    $("#lySpBagList").find("li").each(function () {
                        appier_product_data = {
                            "category_name_depth1" : cate1_name
                            , "category_name_depth2" : cate2_name
                            , "brand_id" : "<%=oItem.Prd.Fmakerid%>"
                            , "brand_name" : "<%=oItem.Prd.FBrandName%>"
                            , "product_id" : "<%=itemid%>"
                            , "product_name" : "<%=oItem.Prd.FItemName%>"
                            , "product_image_url" : Advertisement_image_url
                            , "product_url" : "http://m.10x10.co.kr/apps/appcom/wish/web2014/category/category_itemPrd.asp?itemid=<%=itemid%>"
                        };
                        appier_product_data.quantity =  parseInt($(this).find("[name='optItemEa']").val());
                        appier_product_data.product_price =  parseInt($(this).find("[name='optItemPrc']").val());
                        appier_product_data.product_variant =  $(this).find(".optContV16a p").html();

                        appier_product_list.push(appier_product_data);
                    });
                <%
                    ELSE
                %>
                    appier_product_data.quantity =  document.sbagfrm.itemea.value;
                    appier_product_data.product_variant = null;

                    appier_product_list.push(appier_product_data);
                <%
                    END IF
                %>

                fnAppierProductsLogEventProperties(caller_name, appier_product_list);
                break;
        }
    }

    /*
    * End of Function About Appier
    * */

	//옵션 없는 단일 상품일 경우에만
	function jsItemea(plusminus)
	{
		var vmin = parseInt(<%=chkIIF(oItem.Prd.IsLimitItemReal and oItem.Prd.FRemainCount<=0,"0",oItem.Prd.ForderMinNum)%>);
		var vmax = parseInt(<%=chkIIF(oItem.Prd.IsLimitItemReal,CHKIIF(oItem.Prd.FRemainCount<=oItem.Prd.ForderMaxNum,oItem.Prd.FRemainCount,oItem.Prd.ForderMaxNum),oItem.Prd.ForderMaxNum)%>);

		var v = parseInt(sbagfrm.itemea.value);

		if(plusminus == "+") {
			v++;
			if(v > vmax) v--;
		}
		else if(plusminus == "-") {
			if(v > 1) {
				v--;
			} else {
				v = 1;
			}
			if(v < vmin) v++;
		}
		sbagfrm.itemea.value = v;
		sbagfrm.optItemEa.value = v;

		var p = parseInt(sbagfrm.itemPrice.value);

		$("#spTotalPrc").text(plusComma(parseInt(v * p)));
		$("#subtot").text(plusComma(parseInt(v * p))+"<%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%>");
	}

	// SNS 공유 팝업
	function fnAPPRCVpopSNS(){
	    //fnAPPpopupBrowserURL("공유","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popShare.asp?sTit=<%=snpTitle%>&sLnk=<%=snpLink%>&sPre=<%=snpPre%>&sImg=<%=snpImg%>");
		$("#lySns").show();
		$("#lySns .inner").removeClass("lySlideDown").addClass("lySlideUp");
	    return false;
	}

	//기프트톡 입력창
	function writeShoppingTalk(v) {
		fnAPPpopupBrowserURL("쓰기","<%=wwwUrl%>/apps/appcom/wish/web2014/gift/gifttalk/talk_write.asp?itemid="+v);
	}

	//상품상세 기프트쓰기 빠른 상품찾기 팝업(팝업 닫으면서 js 호출)
	function goitemReturn(){
		fnAPPpopupBrowserURL("상품 찾기","<%=wwwUrl%>/apps/appCom/wish/web2014/gift/gifttalk/write_right_ajax.asp");
		return false;
	}
	//상품상세 기프트쓰기 선택한 상품 집어넣기(팝업 닫으면서 js 호출)
	function TalkItemSelect(v){
		fnAPPpopupBrowserURL("톡 쓰기","<%=wwwUrl%>/apps/appCom/wish/web2014/gift/gifttalk/talk_write.asp?itemid="+v);
	}
	// 선물포장 js
	function jsGoPojangList(){
		location.replace('http://m.10x10.co.kr/apps/appCom/wish/web2014/shoppingtoday/gift_recommend.asp');
	}
	//바로배송 퀵 리스트
	function quickList(){
    location.replace('<%=wwwUrl%>/apps/appCom/wish/web2014/shoppingtoday/quick_list.asp');
	}

	//장바구니 레이어
	function fnsbagly(v) {
		if (v=="x"){
			$("#sbaglayerx").show();
			$("#alertBoxV17a").show();
		}else if(v=="o"){
			$("#sbaglayero").show();
			$("#alertBoxV17a").show();
		}
		setTimeout(function() {
			$("#alertBoxV17a").fadeOut(1000);
		}, 2500);
	}


	//2017-07-05 플로팅 2017ver
	$(function(){
		// floating area option select control
		$('.itemOptV16a select').focus(function(){
			if($(this).hasClass('current')){
				$(this).removeClass('current');
			} else {
				$('.itemOptV16a select').removeClass('current');
				$(this).addClass('current');
			}
		});
		$('.itemOptV16a select').focusout(function(){
			$('.itemOptV16a select').removeClass('current');
		});

		// floating area swipe
		floatScroll = new Swiper('.itemOptV16a .swiper-container', {
			scrollbar:'.itemOptV16a .swiper-scrollbar',
			direction:'vertical',
			slidesPerView:'auto',
			mousewheelControl:true,
			freeMode:true,
			resistanceRatio:0
		});

		// floating area height calculate
		function hCalc() {
			var optH = $('.itemOptV16a').outerHeight();
			$('.itemOptV16a').css('height',optH+'px');
		}

		// floating area control
		$('.controller, .actBuy').click(function(){
			if($('.itemFloatingV16a').hasClass('opening16a')){
				$('.itemFloatingV16a').removeClass('opening16a');
				$('.actBuy').css('display','table-cell');
				$('.actCart, .actNow, .actStock').hide();
			} else {
				$('.itemFloatingV16a').addClass('opening16a');
				hCalc();
				$('.actBuy').hide();
				$('.actCart, .actNow').css('display','table-cell');
				<% if isAlarmOptionPushChk then %>
					$('.actStock').css('display','table-cell');
				<% end if %>
			}

			<% if Not(oItem.Prd.FOptionCnt>0) And Not(IsPresentItem) and Not(IsSpcTravelItem) then %>
				$(".btnAreaV16a .actCart .btnRed1V16a").attr("disabled",false);
				$(".btnAreaV16a .actNow .btnRed2V16a").attr("disabled",false);
			<% end if %>

			floatScroll.update();
		});

		/* layer popup for dropdown */
		$.fn.layerOpen = function(options) {
			return this.each(function() {
				var $this = $(this);
				var $layer = $($this.attr("href") || null);
				$this.click(function() {
					if ($this.attr('disabled') != "disabled"){
						$layer.attr("tabindex",0).show().focus();
						$layer.find(".btnClose, .btnDrop").one("click",function () {
							$layer.hide();
							$this.focus();

							<%'레이어 닫은후 클래스 처리 %>
							var $opttag = $("#opttag a");
							$opttag.each(function(index){
								if ($this.index() == $(this).index()){
									$(this).addClass("on");
								}else{
									$(this).removeClass("on");
								}
							});
							$('.txtBoxV16a').removeClass('current');
						});

						<%'DB에서 받아온 옵션 노출 %>
						var $dropBoxs = $(".dropBox ul");
						$dropBoxs.each(function(index){
							if ($this.index() == $(this).index()-1){
								$(this).show();
							}else{
								$(this).hide();
							}
						});
						dropdownScrollLayer.onResize(); //ul 초기화
						dropdownScrollLayer.update(); //ul update
					}
				});
			});
		}
		$(".layer").layerOpen();

		/* swipe scroll for dropdown layer */
		var dropdownScrollLayer = new Swiper('.lyDropdown .swiper-container', {
			scrollbar:'.lyDropdown .swiper-scrollbar',
			direction:'vertical',
			slidesPerView:'auto',
			mousewheelControl:true,
			freeMode:true
		});
	});
	//2017-07-05 플로팅 2017ver

	//2017 추가
	/* breadcrumbs */
	function breadcrumbsSwiper () {
		new Swiper("#breadcrumbs .swiper-container",{
			freeMode:true,
			slidesPerView:"auto"
		});
	}
	$(function(){
		/* 상품가격 더보기 */
		$(".item-detail .btn-more").on("click", function(){
			var thisCont = $(this).attr("href");
			$(this).toggleClass("on");
			$(thisCont).toggle();
			return false;
		});
		setTimeout(function(){
			//fnAmplitudeEventActionJsonData('view_product','{"itemid":"<%=itemid%>","keyword":"<%=vPrtr%>","reviewpoints":"<%=round(oItem.Prd.Fpoints,2)%>","reviewcount":"<%=oItem.Prd.FEvalCnt%>","product_name":"<%=Server.URLEncode(replace(oItem.Prd.FItemName,"'",""))%>","productkeywords":["<%=Replace(Replace(oitem.Prd.FKeywords,",",""","""),"'","")%>"],"price":"<%=oItem.Prd.FSellCash%>","category_code":"<%=vDisp%>","category_name":"<%=fnItemIdToCategory1DepthName(itemid)%>","brand_id":"<%=oItem.Prd.Fmakerid%>","brand_name":"<%=Server.URLEncode(replace(oItem.Prd.FBrandName,"'",""))%>"}');

			let view_product_data = {
                itemid : "<%=itemid%>"
                , keyword : "<%=vPrtr%>"
                , productkeywords : ["<%=Replace(Replace(Replace(oitem.Prd.FKeywords,",",""","""), "'",""), """","")%>"]
                , reviewpoints  : "<%=round(oItem.Prd.Fpoints,2)%>"
                , reviewcount  : "<%=oItem.Prd.FEvalCnt%>"
                , product_name  : "<%=Server.URLEncode(replace(oItem.Prd.FItemName,"'",""))%>"
                , price  : "<%=oItem.Prd.FSellCash%>"
                , category_code  : "<%=vDisp%>"
                , brand_id  : "<%=oItem.Prd.Fmakerid%>"
                , brand_name  : "<%=Server.URLEncode(replace(oItem.Prd.FBrandName,"'",""))%>"
                , category_name_depth1  : cate1_name
                , category_name_depth2  : cate2_name
            };
            fnAmplitudeEventActionJsonData("view_product", JSON.stringify(view_product_data));

			if( getParameter('hAmpt') != null ) { // 히치하이커 Amplitude
			    setTimeout(function() {
                    const hAmpt = getParameter('hAmpt').split('_');
                    let event_name, data;
                    switch(hAmpt[0]) {
                        case 'sub' : // 정기구독
                            event_name = 'click_hitchhiker_subscribe';
                            data = {};
                            break;
                        case 'mgz' : // 매거진
                            event_name = 'click_hitchhiker_magazine';
                            data = {
                                item_index : hAmpt[1],
                                itemid : '<%=itemid%>'
                            };
                            break;
                        case 'gd' : // 굿즈
                            event_name = 'click_hitchhiker_goods';
                            data = {
                                item_index : hAmpt[1],
                                itemid : '<%=itemid%>'
                            };
                            break;
                    }
                    fnAmplitudeEventActionJsonData(event_name, JSON.stringify(data));
			    }, 1500);
			}
		}, 1500);

		/* 브랜치 데이터 전송용 */
		fnViewProduct('<%=itemid%>','<%=oItem.Prd.FSellCash%>','<%=Server.URLEncode(replace(oItem.Prd.FItemName,"'",""))%>','1','KRW','<%=Server.URLEncode(fnItemIdToCategory1DepthName(itemid))%>');

		/* 연관 상품 더보기 */
		var relatedItem = new Swiper('.related1 .swiper-container', {
			slidesPerView:'auto',
			freeMode:true
		});
		var relatedItem = new Swiper('.related2 .swiper-container', {
			slidesPerView:'auto',
			freeMode:true
		});
	});

	// 상품후기 탭으로 이동
	function btnGoReviewClick(){
		$(".itemDeatilV16a .itemDetailContV16a div#tab01").hide();
		$(".itemDeatilV16a .itemDetailContV16a div#tab03").show();
		$('.itemDeatilV16a .commonTabV16a li:first-child').removeClass('current');
		$('.itemDeatilV16a .commonTabV16a li:nth-child(3)').addClass('current');
		var tabView = $(".itemDeatilV16a .tabCont div[id|='tab03']");
		$(tabView).show();
		$('html, body').animate({scrollTop: $(".itemDeatilV16a").offset().top}, 500);
		if( reviewVue.$refs.reviewGallery )
            reviewVue.$refs.reviewGallery.setSwiper(); // 후기 갤러리 스와이퍼 set
	}

	function branchAddToCartEventLoging() {
		var frm = document.sbagfrm;
		var branchQuantity;
		if (frm.itemea.value===undefined || frm.itemea.value=="") {
			branchQuantity = 1;
		} else {
			branchQuantity = frm.itemea.value;
		}
		fnAddToCart('<%=itemid%>', '<%=oItem.Prd.FSellCash%>', '<%=Server.URLEncode(replace(oItem.Prd.FItemName,"'",""))%>', branchQuantity, 'KRW','<%=Server.URLEncode(fnItemIdToCategory1DepthName(itemid))%>');
	}

	function countAni(memberCountConTxt){
		$({ val : 0 }).animate({ val : memberCountConTxt }, {
			duration: 1000,
			step: function() {
				var num = numberWithCommas(Math.floor(this.val));
				$(".memberCountCon").text(num);
			},
			complete: function() {
				var num = numberWithCommas(Math.floor(this.val));
				$(".memberCountCon").text(num);
			}
		});
		function numberWithCommas(x) {
			return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		}
		fired = true;
	}

	function iniRentalPriceCalculation(period) {
		var inirentalPrice = 0;
		var iniRentalTmpValuePrd;
		if (period!="") {
			<%'// 테스트용으로 4월 19일 부터 셋팅 실서버 배포시에는 5월 3일 10시로 바꿔야됨%>
			<% If now() >= #2021-05-03 09:00:00# and now() < #2021-06-01 00:00:00# Then %>
				<%'// 이니렌탈 이벤트(2021년 5월 3일~2021년 5월 31일)%>			
				inirentalPrice = getIniRentalMonthPriceCalculationForEvent('<%=oItem.Prd.FSellCash%>', period);
			<% Else %>
				inirentalPrice = getIniRentalMonthPriceCalculation('<%=oItem.Prd.FSellCash%>', period);
			<% End If %>
			iniRentalTmpValuePrd = inirentalPrice.split('|');
			if (iniRentalTmpValuePrd[0]=="error") {
				inirentalPrice = 0;
				return;
			} else if (iniRentalTmpValuePrd[0]=="ok") {
				inirentalPrice = iniRentalTmpValuePrd[1]
			} else {
				inirentalPrice = 0;
				return;
			}
			$("#rentalmonth").val(period);
		} else {
			<%'// 테스트용으로 4월 19일 부터 셋팅 실서버 배포시에는 5월 3일 10시로 바꿔야됨%>
			<% If now() >= #2021-05-03 09:00:00# and now() < #2021-06-01 00:00:00# Then %>
				<%'// 이니렌탈 이벤트(2021년 5월 3일~2021년 5월 31일)%>
				inirentalPrice = getIniRentalMonthPriceCalculationForEvent('<%=oItem.Prd.FSellCash%>', '12');
			<% Else %>
				inirentalPrice = getIniRentalMonthPriceCalculation('<%=oItem.Prd.FSellCash%>', '12');
			<% End If %>
			iniRentalTmpValuePrd = inirentalPrice.split('|');
			if (iniRentalTmpValuePrd[0]=="error") {
				inirentalPrice = 0;
				return;
			} else if (iniRentalTmpValuePrd[0]=="ok") {
				inirentalPrice = iniRentalTmpValuePrd[1]
			} else {
				inirentalPrice = 0;
				return;
			}
			<%'// 테스트용으로 4월 19일 부터 셋팅 실서버 배포시에는 5월 3일 10시로 바꿔야됨%>
			<% If now() >= #2021-05-03 09:00:00# and now() < #2021-06-01 00:00:00# Then %>
				<%'// 이니렌탈 이벤트(2021년 5월 3일~2021년 5월 31일)%>			
				$("#rentalmonth").val('12');
			<% Else %>
				$("#rentalmonth").val('12');
			<% End If %>
		}
		//inirentalPrice = inirentalPrice.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
		//$("#rentalMonthPrice").empty().html(" "+inirentalPrice);
		countAni(inirentalPrice);
		<%' 간이 장바구니 월 납입금액 표시 %>
		$("#subtotRental").empty().html("<span class='month'>월</span>"+inirentalPrice.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+"원");
		<%' 최종 결제액 영역 표시 %>
		$("#spTotalPrcRental").empty().html("<span class='rental-num'><span>"+period+"</span>개월 간 월</span><strong>"+inirentalPrice.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+"</strong>원");
	}

	function go_subscribe(){
        fnAPPpopupHitchhikerSubscribe();
    }
    function go_tenten_exclusive(){
        location.href="/apps/appCom/wish/web2014/tenten_exclusive/main.asp";
    }
</script>
<!-- #include virtual="/chtml/main/loader/banner/inc_banner_assets.asp" -->
<% IF application("Svr_Info") = "Dev" THEN %>
<script src="/vue/vue_dev.js"></script>
<% Else %>
<script src="/vue/2.5/vue.min.js"></script>
<% End If %>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>
</head>
<%
    adultChkFlag = session("isAdult") <> true and oItem.Prd.FAdultType <> 0
	adultcb = request("adultcb")
    If adultChkFlag then
        response.write "<script>confirmAdultAuth('"&Server.URLencode(CurrURLQ())&"', "& chkiif(IsUserLoginOK, "true", "false") & ");</script>"
    elseif adultChkFlag <> true and adultcb = "Y" then
%>
	<script>
	$(document).ready(function(){
		console.log('성인인증 확인')
		setTimeout(function(){
			callNativeFunction('closeParentBrowserPopup', {
				"validationAdult" : '<%=chkIIF(session("isAdult"), "1", "0")%>' // 성인 인증 상태
			});
			//fnAPPcloseParentBrowserPopup('');
		}, 1200);
	});
	</script>
<%
	end if
%>
<body class="default-font body-sub bg-grey category-item">
<!-- 후기 컴포넌트 -->
    <script src="/vue/components/common/functions/common.js?v=1.00"></script>
    <script src="/vue/components/review/product_detail/gallery.js?v=1.00"></script>
    <script src="/vue/components/review/product_detail/modal_post_report_review_v2.js?v=1.03"></script>
    <script src="/vue/components/review/product_detail/gallery_modal.js?v=1.01"></script>
    <script src="/vue/components/review/product_detail/review_v2.js?v=1.05"></script>
    <script src="/vue/components/review/product_detail/review_tester.js?v=1.00"></script>
    <script src="/vue/components/review/product_detail/review_write.js?v=1.00"></script>
    <script src="/vue/components/review/product_detail/review_total_info.js?v=1.00"></script>
    <script src="/vue/components/review/product_detail/review_sort_bar.js?v=1.00"></script>
    <script src="/vue/components/review/product_detail/review_type_tab.js?v=1.00"></script>
    <script>
        $(document).ready(function() {
            fnSetLoadingIndicator(false); // 로딩바 끔
        });
    </script>
	<div class="content" id="contentArea" style="padding-bottom:6rem;">
		<% '' 2017 정기세일-숨은 보물을 찾아라(4/3~4/17) %>
		<!-- #include virtual="/event/etc/2017props_77062.asp" -->
		<% If IsRentalItem Then %>
			<style>
			.item-bnr-rental {position:relative;}
			.item-bnr-rental a {position:absolute; height:100%; font-size:0; color:transparent;}
			.item-bnr-rental .link1 {left:0; width:66%;}
			.item-bnr-rental .link2 {right:0; width:34%;}
			</style>
			<div class="item-bnr-rental">
				<img src="//fiximage.10x10.co.kr/m/2021/category/bnr_rental.png" alt="이니렌탈">
				<!-- 이니렌탈 안내 팝업 --> <a href="" onclick="fnAPPpopupBrowserURL('이니렌탈 안내','<%=wwwUrl%>/apps/appcom/wish/web2014/category/pop_inirental_guide.asp'); return false;" class="link1">이니렌탈이 뭐예요?</a>
				<!-- 이니렌탈 기획전 107600 --> <a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=107600');" class="link2">렌탈상품 전체보기</a>
			</div>
		<% End If %>		

		<% If vDisp <> "111" and vDisp<>"0" Then %>
		<div id="breadcrumbs" class="breadcrumbs">
			<div class="swiper-container">
				<ol class="swiper-wrapper">
				<%
					if vDisp="123" then
						'클리어런스 세일이면 클리어런스 페이지로 이동
						response.Write "<li class=""swiper-slide""><a href=""#"" onclick=""fnAPPpopupBrowserURL('CLEARANCE SALE','" & wwwUrl & "/apps/appCom/wish/web2014/clearancesale/');return false;"" class=""cBk1"">클리어런스</a></li>"
					else
						response.Write vCateNavi
					end if
				%>
				</ol>
			</div>
		</div>
		<% End If %>

		<%If oItem.Prd.FAdultType <> 0 then%>
			<div class="alert-text adult-text">
				<div class="inner">
					<p>관계법령에 따라 미성년자는 구매할 수 없으며, 성인인증을 하셔야 구매 가능한 상품입니다.</p>
				</div>
			</div>
		<%End IF%>

		<% if itemid=2014099 then %>
		<!-- for dev msg : 텐텐 체크카드 신청하러가기 -->
		<a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=85155');"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87447/m/bnr_detail.jpg" class="vTop" alt="텐바이텐 체크카드 신청하러가기"></a>
		<% end if %>

		<% if isAritaumItem then %>
		<a onclick="jsEventlinkURL('88637');return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88637/m/bnr_aritaum.png" class="vTop" alt="아리따움 10주년 기념 프로모션 상품을 1,000원에 만나보세요!"></a>
		<% end if %>

		<%' 웨딩 관련 이벤트 상품 배너 노출. %>
		<div style="display:none;" id="weddingbanner"><a href="" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '웨딩바이블', [BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/wedding/');return false;"><img src="http://fiximage.10x10.co.kr/m/2018/wedding2018/bnr_wedding.jpg" class="vTop" alt="all about wedding"></a></div>

		<%' 상품이벤트 노출 배너입니다. %>
		<div style="display:none;" id="itemevent"></div>

		<%' 상품상세 광고배너(토스트 팝업 포함) %>
		<%' 이니렌탈 상품일 경우 배너 표시 안함 %>
		<% If Not(IsRentalItem) Then %>
			<% if LoginUserid <> "" then %>
				<% 'server.Execute("/chtml/main/loader/banner/exc_itemprd_banner_app.asp") %>
			<% Else %>
				<% 'server.Execute("/chtml/main/loader/banner/exc_itemprd_nomember_banner_app.asp") %>
			<% End If %>
		<% End If %>

		<div id="itemSwiper" class="item-detail-swiper">
			<% IF (oItem.Prd.isLimitItem) and (not (oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut)) and (Not IsReceiveSiteItem) and Not(IsPresentItem and oItem.Prd.FRemainCount>200 ) and Not(IsTicketItem and oItem.Prd.FRemainCount>100 ) Then %>
			<span class="label label-box">한정 <% = oItem.Prd.FRemainCount %>개</span>
			<% end if %>
			<%
			Dim vOneAndOne, vOneAndOneSDate
			vOneAndOne = ""
			If vOneAndOne <> "" Then
				vOneAndOneSDate = Split(vOneAndOne,"||")(1)
				vOneAndOne = Split(vOneAndOne,"||")(0)
			End If

			If GiftSu > 0 Then %>
				<span class="label label-box" style="right:0; left:auto;">
					<%
						if vOneAndOne="" then
							response.write "사은품"
						else
							if vOneAndOne="1" then
								response.write "Gift"	'"1+1"
							elseif vOneAndOne="2" then
								response.write "Gift"	'"1:1"
							else
								response.write "사은품"
							end if
						end if
					%> 남은수량 <% = GiftSu %>개</span>
			<% else %>
				<%
				If date() = CDate(vOneAndOneSDate) Then
					if vOneAndOne <> "" then %>
					<span class="label label-box" style="right:0; left:auto;">
						<%
							if vOneAndOne="" then
								response.write "사은품"
							else
								if vOneAndOne="1" then
									response.write "Gift"	'"1+1"
								elseif vOneAndOne="2" then
									response.write "Gift"	'"1:1"
								else
									response.write "사은품"
								end if
							end if
						%> 남은수량 0개</span>
				<%
					GiftNotice=True '사은품 소진 노티
					end if
				end if
				%>
			<% end if %>
			<%' 다스배너 %>
			<% if (oItem.Prd.FDeliverytype="1" Or oItem.Prd.FDeliverytype="4") and (oItem.Prd.FOrgPrice >= 8800) and (date() > "2020-09-06") and giftCheck then %>
				<%'// 사은품 소진시 해당 배너 나오지 않게 수정해야됨 2020-04-14 %>
				<%  If clsDiaryPrdCheck.isDiaryStoryItem Then %>
					<!--span class="badge-diarygift" >
					<a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '2020 다이어리', [BtnType.SEARCH, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2020/index.asp')" class="mApp">
					<img src="//fiximage.10x10.co.kr/m/2019/diary2020/badge_prd.png" alt="다이어리 사은품증정"></a></span-->
					<span class="badge-diarygift" >
						<a href="javascript:fnAPPpopupBrowserURL('다이어리 스토리','<%=M_SSLUrl%>/apps/appCom/wish/web2014/diarystory2022/index.asp');"><img src="http://fiximage.10x10.co.kr/m/2020/diary2021/bnr_dr_bnf_v2.png" alt="다이어리 사은품증정"></a>
					</span>
				<% End If %>
			<% end if %>
			<% if ((oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0)) or (oItem.Prd.IsSaleItem and oItem.Prd.IsSpecialUserItem) or (oitem.Prd.isCouponItem) then %>
			<span class="badge-diarygift" >
				<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=116957');return false;"><img src="//fiximage.10x10.co.kr/m/2021/banner/bnr_big_sale.png?v=2" alt="가장큰 세일"></a>
			</span>
			<% end if %>
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<%
						Dim moreItemImage '// 상품상세 해피투게더 연결 더보기
						Dim moreItemImageNumber : moreItemImageNumber = Session.SessionID Mod 2 '// 세션 나눔

						'//기본 이미지
						Response.Write "<div class=""swiper-slide""><img src=""" & getThumbImgFromURL(oItem.Prd.FImageBasic,400,400,"true","false") & """ alt=""" & replace(oItem.Prd.FItemName,"""","") & """ style=""width:100%;"" /></div>"
						moreItemImage = getThumbImgFromURL(oItem.Prd.FImageBasic,400,400,"true","false")

						'//누끼 이미지
						if Not(isNull(oItem.Prd.FImageMask) or oItem.Prd.FImageMask="") then
							Response.Write "<div class=""swiper-slide""><img src=""" & getThumbImgFromURL(oItem.Prd.FImageMask,400,400,"true","false") & """ alt=""" & replace(oItem.Prd.FItemName,"""","") & """ style=""width:100%;"" /></div>"
							moreItemImage = getThumbImgFromURL(oItem.Prd.FImageMask,400,400,"true","false")
						end If
						'//추가 이미지
						IF oAdd.FResultCount > 0 THEN
							FOR i= 0 to oAdd.FResultCount-1
								'If i >= 3 Then Exit For
								IF oAdd.FADD(i).FAddImageType=0 THEN
									Response.Write "<div class=""swiper-slide""><img src=""" & getThumbImgFromURL(oAdd.FADD(i).FAddimage,400,400,"true","false") & """ alt=""" & replace(oItem.Prd.FItemName,"""","") & """ style=""width:100%;"" /></div>"
								End If

								If i = oAdd.FResultCount-1 Then
									moreItemImage = getThumbImgFromURL(oAdd.FADD(i).FAddimage,400,400,"true","false")
								End If
							NEXT
						END If

						'// 텐바이텐 기본이미지 추가(이미지 올렸을시 생성되는 50*50사이즈 이미지 추가노출)
						If Not(isNull(oitem.Prd.Ftentenimage) Or oitem.Prd.Ftentenimage = "") Then
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
							Response.Write "<div class=""swiper-slide""><img src=""" & viTentenimg & """ alt=""" & replace(oItem.Prd.FItemName,"""","") & """ style=""width:100%;"" /></div>"
						End If

						'Response.write "<div class=""swiper-slide""><div class=""more-rec""><div class=""inner""><div><p>더 많은 상품이 궁금하다면?</p><p class=""btn-group"" data-swiper-parallax=""-200""><button type=""button"" onclick=""fnAmplitudeEventMultiPropertiesAction('click_moreimage_in_product','','',function(bool){ if(bool) { $('html , body').animate({scrollTop : $('#lyrHappyTogetherCol').offset().top-120 },400);}});return false;"">관련 상품 더 보기</button></p></div></div></div><img src="""& moreItemImage &""" alt="""" /></div>"
					%>
				</div>
			</div>
			<div class="pagination-no"><b></b>/<span></span></div>
		</div>

		<% if oItem.Prd.FisJust1Day then %>
		<div id="lyrjust1day" class="timer"></div>
		<script type="text/javascript">
			$.ajax({
				type: "get",
				url: "/category/act_just1day.asp?itemid=<%=itemid%>",
				success: function(message) {
					if(message) {
						$("#lyrjust1day").empty().html(message);
					}
				}
			});
		</script>
		<% end if %>

		<section class="item-detail item-detailV21">
			<div class="desc">
				<span class="brand no-br"><a href="" onClick="fnAPPpopupBrand('<%=oItem.Prd.Fmakerid%>');return false;"><%=oItem.Prd.FBrandName%></a></span>
				<h2 class="name"><%= oItem.Prd.FItemName %></h2>
				<% If Not(IsRentalItem) Then %>
				<div class="flex-wrap<% If oItem.Prd.FEvalCnt >= 1 Then %> ar<% end if %>">
					<%'<!-- 모바일 고도화 프로젝트 평점노출 -->%>
					<% If oItem.Prd.FEvalCnt >= 1 Then %>
						<div class="review">
							<!-- for dev msg : 클릭시 하단 후기 탭으로 이동 (20190307) -->
							<a href="" onclick="btnGoReviewClick();return false;" class="btn-arrow">
								<span class="icon-rating2"><i style="width:<%=fnEvalTotalPointAVG(oItem.Prd.Fpoints,"")%>%;"><%=fnEvalTotalPointAVG(oItem.Prd.Fpoints,"")%>점</i></span>
								<span class="counting"><%=FormatNumber(oItem.Prd.FEvalCnt,0)%></span>
							</a>
						</div>
					<% End If %>
					<div class="price<% If ((oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0)) or (oItem.Prd.IsSaleItem and oItem.Prd.IsSpecialUserItem) or (oitem.Prd.isCouponItem) Then %> sale<% end if %>">
						<div class="unit">
							<% IF ((oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0)) or (oItem.Prd.IsSaleItem and oItem.Prd.IsSpecialUserItem) or (oitem.Prd.isCouponItem) and isCouponPriceDisplay THEN %>
							<s><%=FormatNumber(oItem.Prd.getOrgPrice,0)%></s>
							<b class="sum"><%= FormatNumber(oItem.Prd.GetCouponAssignPrice,0) %><span class="won"><%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></span></b>
							<% Else %>
								<% if oItem.Prd.FSellCash>oItem.Prd.getOrgPrice then ''이상한 CASE %>
								<b class="sum"><%=FormatNumber(oItem.Prd.FSellCash,0)%><span class="won"><%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></span></b>
								<% else %>
								<b class="sum"><%=FormatNumber(oItem.Prd.getOrgPrice,0)%><span class="won"><%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></span></b>
								<% end if %>
							<% End If %>
						</div>
						<% IF ((oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0)) or (oItem.Prd.IsSaleItem and oItem.Prd.IsSpecialUserItem) or (oitem.Prd.isCouponItem) THEN %>
						<a href="#priceList" class="btn-more">상세 가격 정보 보기</a>
						<% End If %>
					</div>
					<!-- 할인일 경우 노출 : 3. 상세 가격정보 -->
					<div id="priceList" class="price-list">
				<% IF ((oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0)) or (oItem.Prd.IsSaleItem and oItem.Prd.IsSpecialUserItem) or (oitem.Prd.isCouponItem) THEN %>
						<dl>
						<dt><%=chkIIF(Not(IsTicketItem),"판매가","티켓기본가")%></dt>
						<dd><div class="price"><b class="sum"><%=FormatNumber(oItem.Prd.getOrgPrice,0)%><span class="won"><%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></span></b></div></dd>
						</dl>
					<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
						<dl>
						<dt>할인판매가</dt>
						<dd><div class="price"><b class="discount"><%=chkiif(oItem.Prd.FOrgprice = 0,"0",CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100))%>%</b> <b class="sum"><%=FormatNumber(oItem.Prd.FSellCash,0)%><span class="won"><%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></span></b></div></dd>
						</dl>
					<% End If %>

					<% If IsOnlyHanaTenPayValidItemInPrd Then %>
						<dl>
						<dt>텐카 즉시 할인가</dt>
						<dd><div class="price"><b class="discount">5%</b> <b class="sum"><%=FormatNumber(Fix(oItem.Prd.FSellCash*0.95),0)%><span class="won"><%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></span></b></div></dd>
						</dl>
						<script>
						(function($){
							var priceList = $("#priceList");
							priceList.show();
						})(jQuery);
						</script>
					<% End If %>

					<% if oItem.Prd.IsSaleItem and oItem.Prd.IsSpecialUserItem then %>
						<dl>
						<dt>우수회원가<span class="icoHot"><a href="" onclick="fnAPPpopupBrowserURL('우수회원샵','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/special_shop.asp'); return false;"><em class="rdBtn2">우수회원샵</em></a></span></dt>
						<dd><div class="price"><b class="discount"><% = getSpecialShopPercent() %>%</b><b class="sum"><%=FormatNumber(oItem.Prd.getRealPrice,0)%><span class="won"><%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></span></b></div></dd>
						</dl>
					<% end if %>

					<% if oitem.Prd.isCouponItem and isCouponPriceDisplay Then %>
						<dl>
						<dt>쿠폰적용가</dt>
						<dd><div class="price"><b class="discount"><%= oItem.Prd.GetCouponDiscountStr %></b> <b class="sum"><%=FormatNumber(oItem.Prd.GetCouponAssignPrice,0)%><span class="won"><%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></span></b></div></dd>
						</dl>
					<% end if %>
				<% End If %>
					</div>
					<!-- // price-list -->
				</div>
				<!-- // flex-wrap -->
					<%
                        '21년 6월 14일까지 상품쿠폰이 없으며 가격범위(최소7만원이상)를 만족하면 출력
                        dim isAvailBonusCoupon
                        isAvailBonusCoupon = oItem.getIsAvailableBonusCoupon(itemid, vMakerid)
                        IF date<="2021-06-14" and Not(oitem.Prd.isCouponItem) and oItem.Prd.GetCouponAssignPrice>=70000 and isAvailBonusCoupon THEN
                            dim bonusCouponValue
                            if oItem.Prd.GetCouponAssignPrice>=70000 and oItem.Prd.GetCouponAssignPrice<150000 then
                                bonusCouponValue = 5000
                            elseif oItem.Prd.GetCouponAssignPrice>=150000 and oItem.Prd.GetCouponAssignPrice<300000 then
                                bonusCouponValue = 10000
                            elseif oItem.Prd.GetCouponAssignPrice>=300000 then
                                bonusCouponValue = 30000
                            end if
                    %>
                    <div class="couPrice">
                        <div class="txt">가입쿠폰 <%=FormatNumber(bonusCouponValue,0)%>원 사용시</div>
                        <div class="cPrice"><%=FormatNumber(oItem.Prd.GetCouponAssignPrice-bonusCouponValue,0)%><span><%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></span></div>
                    </div>
                    <ul class="couNoti">
                        <li>쿠폰은 회원가입 후 24시간 내 1회만 사용하실 수 있으며, 여러 조건에 따라 최종 결제 금액이 변동될 수 있습니다.</li>
					</ul>
                    <% End If %>
				<% else %>
				<div class="flex-wrap<% If oItem.Prd.FEvalCnt >= 1 Then %> ar<% end if %>">
					<%'<!-- 모바일 고도화 프로젝트 평점노출 -->%>
					<% If oItem.Prd.FEvalCnt >= 1 Then %>
						<div class="review">
							<a href="" onclick="btnGoReviewClick();return false;" class="btn-arrow">
								<span class="icon-rating2"><i style="width:<%=fnEvalTotalPointAVG(oItem.Prd.Fpoints,"")%>%;"><%=fnEvalTotalPointAVG(oItem.Prd.Fpoints,"")%>점</i></span>
								<span class="counting"><%=oItem.Prd.FEvalCnt%></span>
							</a>
						</div>
					<% End If %>
					<%' <!-- for dev msg : 이니시스 렌탈 상품상세 이니렌탈 가격 정보 노출 --> %>
					<div class="price rental">
						<select id="select-rolling" title="렌탈/납부기간 선택" onchange="iniRentalPriceCalculation(this.value);">
							<%'// 테스트용으로 4월 19일 부터 셋팅 실서버 배포시에는 5월 3일 10시로 바꿔야됨%>
							<% If now() >= #2021-05-03 09:00:00# and now() < #2021-06-01 00:00:00# Then %>
								<%'// 이니렌탈 이벤트(2021년 5월 3일~2021년 5월 31일)%>	 
								<option value="12">12개월 간</option>
								<option value="24">24개월 간</option>
								<option value="36">36개월 간</option>
								<% If oItem.Prd.FSellCash > 1000000 Then %>
									<option value="48">48개월 간</option>
								<% End If %>								
							<% Else %>
								<option value="12">12개월 간</option>
								<option value="24">24개월 간</option>
								<option value="36">36개월 간</option>
                                <%'// 아래 기간동안 48개월 간 표시 안함%>
                                <% If now() >= #2021-07-27 00:00:00# and now() < #2022-01-10 00:00:00# Then %>
                                <% Else %>								
									<% If oItem.Prd.FSellCash > 1000000 Then %>
										<option value="48">48개월 간</option>
									<% End If %>
								<% End If %>
							<% End If %>
						</select>
						<div class="unit">
							<b class="sum"><span>월</span><em class="memberCountCon"></em><span class="won">원</span></b>
						</div>
					</div>
					<%' <!-- // 이니시스 렌탈 상품상세 이니렌탈 가격 정보 노출 --> %>
				</div>
				<!-- // flex-wrap -->
				<% end if %>
			</div>
			<% If Not(IsRentalItem) Then %>
			<% else %>
			<dl id="priceList" class="price-list">
				<% IF ((oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0)) or (oItem.Prd.IsSaleItem and oItem.Prd.IsSpecialUserItem) or (oitem.Prd.isCouponItem) THEN %>
						<dt><%=chkIIF(Not(IsTicketItem),"판매가","티켓기본가")%></dt>
						<dd><div class="price"><b class="sum"><%=FormatNumber(oItem.Prd.getOrgPrice,0)%><span class="won"><%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></span></b></div></dd>
					<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
						<dt>할인판매가</dt>
						<dd><div class="price"><b class="discount color-red"><%=chkiif(oItem.Prd.FOrgprice = 0,"0",CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100))%>%</b> <b class="sum"><%=FormatNumber(oItem.Prd.FSellCash,0)%><span class="won"><%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></span></b></div></dd>
					<% end if %>

					<% If IsOnlyHanaTenPayValidItemInPrd Then %>
						<dt>텐카 즉시 할인가</dt>
						<dd><div class="price"><b class="discount color-red">5%</b> <b class="sum"><%=FormatNumber(Fix(oItem.Prd.FSellCash*0.95),0)%><span class="won"><%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></span></b></div></dd>
						<script>
						(function($){
							var priceList = $("#priceList");
							priceList.show();
						})(jQuery);
						</script>
					<% End If %>

					<% if oItem.Prd.IsSaleItem and oItem.Prd.IsSpecialUserItem then %>
						<dt>우수회원가<span class="icoHot"><a href="" onclick="fnAPPpopupBrowserURL('우수회원샵','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/special_shop.asp'); return false;"><em class="rdBtn2">우수회원샵</em></a></span></dt>
						<dd><div class="price"><b class="discount color-red"><% = getSpecialShopPercent() %>%</b><b class="sum"><%=FormatNumber(oItem.Prd.getRealPrice,0)%><span class="won"><%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></span></b></div></dd>
					<% end if %>
					<% if oitem.Prd.isCouponItem and isCouponPriceDisplay Then %>
						<dt>쿠폰적용가</dt>
						<dd><div class="price"><b class="discount color-green"><%= oItem.Prd.GetCouponDiscountStr %></b> <b class="sum"><%=FormatNumber(oItem.Prd.GetCouponAssignPrice,0)%><span class="won"><%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></span></b></div></dd>
					<% end if %>
				<% end if %>
			</dl>
			<% end if %>
			<% if oitem.Prd.isCouponItem Then %>
			<%
				dim oitemcoupon, couponCheck
				couponCheck=0
				if LoginUserid <> "" then
					set oitemcoupon = new CUserItemCoupon
					oitemcoupon.FRectUserID = LoginUserid
					oitemcoupon.FRectItemID = itemid
					oitemcoupon.FRectItemCouponIdx = oitem.Prd.FCurrItemCouponIdx
					couponCheck = oitemcoupon.IsItemCouponDownCheck
				end if
			%>
			<div class="coupon">
				<% if (isValidSecretItemcouponExists) then %>
				<% if couponCheck<1 then %>
				<p id="coupon_info">
					<b><%= oItem.Prd.GetCouponDiscountStr %> 시크릿 쿠폰</b>이 있어요!
				</p>
				<% else %>
				<p>
					쿠폰받기 완료! 결제 시 사용해주세요.
				</p>
				<% end if%>
				<button id="btnDown" class="btn-down" <% if couponCheck<1 then %>onclick="jsDownCouponNew('prdsecret','<%= secretcouponidx %>');return false;"<% else %>disabled<% end if%>>
					<figure id="icoCoupon" class="ico"></figure><span id="txtCoupon" class="txt">쿠폰받기</span>
				</button>
				<% else %>
				<% if couponCheck<1 then %>
				<p id="coupon_info">
					<% if oitem.Prd.FCurrItemCouponIdx="154678" or oitem.Prd.FCurrItemCouponIdx="154677" or oitem.Prd.FCurrItemCouponIdx="154676" or oitem.Prd.FCurrItemCouponIdx="154675" or oitem.Prd.FCurrItemCouponIdx="154674" or oitem.Prd.FCurrItemCouponIdx="154673" or oitem.Prd.FCurrItemCouponIdx="154672" or oitem.Prd.FCurrItemCouponIdx="154671" then %>20주년 <% end if %><b><%= oItem.Prd.GetCouponDiscountStr %> 쿠폰</b>이 있어요!
				</p>
				<% else %>
				<p>
					쿠폰받기 완료! 결제 시 사용해주세요.
				</p>
				<% end if%>
				<button id="btnDown" class="btn-down" <% if couponCheck<1 then %>onclick="jsDownCouponNew('prd','<%= oitem.Prd.FCurrItemCouponIdx %>');return false;"<% else %>disabled<% end if%>>
					<figure id="icoCoupon" class="ico"></figure><span id="txtCoupon" class="txt">쿠폰받기</span>
				</button>
				<% end if%>
				<form name="frmC" method="get" action="/apps/appcom/wish/web2014/shoppingtoday/couponshop_process.asp" style="margin:0px;">
				<input type="hidden" name="stype" value="" />
				<input type="hidden" name="idx" value="" />
				</form>
			</div>
			<% elseif (isCateBrandCpnExists) Then %>
				<% if isArray(cateBrandCpnArr) then %>
				<div class="coupon">
					<% if couponCheck<1 then %>
					<p id="coupon_info">
						<b><%=FormatNumber(cateBrandCpnArr(2,0),0) %> <%=chkiif(cateBrandCpnArr(1,0) = 1,"%","원")%> 쿠폰</b>이 있어요!
						<%=replace(cateBrandCpnArr(11,0),"^^","&gt;")%> <b><%=replace(FormatNumber(cateBrandCpnArr(4,0),0),"0,000","만") %>원이상 구매 시</b>
					</p>
					<% else %>
					<p>
						쿠폰받기 완료! 결제 시 사용해주세요.
					</p>
					<% end if%>
					<button id="btnDown" class="btn-down" <% if couponCheck<1 then %>onclick="jsDownCouponPrd('event','<%=cateBrandCpnArr(0,0)%>'); return false;"<% else %>disabled<% end if%>>
						<figure id="icoCoupon" class="ico"></figure><span id="txtCoupon" class="txt">쿠폰받기</span>
					</button>
					<form name="frmCpn" method="post" action="/shoppingtoday/couponshop_process.asp" style="margin:0px;">
					<input type="hidden" name="stype" value="">
					<input type="hidden" name="idx" value="">
					</form>
				</div>
				<% end if %>
			<% end if %>
				<script>
					<% if couponCheck<1 then %>
					// 배송 CX 개선 : 쿠폰 로티 lottie
					var aniCoupon = bodymovin.loadAnimation({
						container: document.getElementById('icoCoupon'),
						loop: false,
						autoplay: false,
						path: 'https://assets9.lottiefiles.com/private_files/lf30_zzke0fxn.json'
					});
					aniCoupon.addEventListener('DOMLoaded', function(e) {
						aniCoupon.playSegments([0,75], true);
						$('#txtCoupon').addClass('on');
					});
					<% end if %>
					// 쿠폰 받기
					function jsDownCouponNew(stype,idx){
						<% if (NOT IsUserLoginOK) then %>
							if(confirm("로그인이 필요한 서비스 입니다. 로그인 하시겠습니까?")) {
								calllogin();
								return;
							}
							return;
						<% else %>
							aniCoupon.playSegments([75,130], true);
							$('#txtCoupon').removeClass('on');
							$('#btnDown').attr('disabled', true);
							$('#coupon_info').empty().html("쿠폰받기 완료! 결제 시 사용해주세요.");
							var frm;
							frm = document.frmC;
							setTimeout(function(){
								frm.stype.value = stype;
								frm.idx.value = idx;	
								frm.submit();
							}, 2000);
						<% end if %>
					}
				</script>
<% 
Select Case oItem.Prd.FDeliverytype
	Case "2"
		if oItem.Prd.FMakerid="goodovening" then
			NewDeliveryName="배송"
		else
			NewDeliveryName="무료배송"
		end if
	Case "5"
			NewDeliveryName="무료배송" 
	Case "6"
			NewDeliveryName="현장수령" 
	Case "7"
		NewDeliveryName="착불배송"
	Case "9"
		if Not oItem.Prd.IsFreeBeasong then
			NewDeliveryName="배송"
		else
			NewDeliveryName="무료배송" 
		end if
	Case Else
		NewDeliveryName="배송"
End Select
'상품별 평균 배송 시간
ItemDeliveryTime = Cint(oItem.GetItemDeliveryTime(itemid, oItem.Prd.FMakerid))
if Cint(WeekDay(CDate(now())))=7 Or Cint(WeekDay(CDate(now())))=1 then '주말 안내 제외
	DeliveryInfoNum=99
else
	if (ItemDeliveryTime>0) then
		if hour(now()) < 15 and (ItemDeliveryTime<=24) then
			DeliveryInfoNum = 0
		elseif hour(now()) >= 15 and (ItemDeliveryTime<=24) then
			DeliveryInfoNum = 1
		elseif (ItemDeliveryTime>=24 and ItemDeliveryTime<49) then
			DeliveryInfoNum = 1
		elseif (ItemDeliveryTime>=48 and ItemDeliveryTime<73) then
			DeliveryInfoNum = 2
		elseif (ItemDeliveryTime>72) then
			DeliveryInfoNum = 3
		end if
	else
		DeliveryInfoNum=99
	end if
end if

'텐배송 당일 출고 대상 상품 확인 (2021-04-15 정태훈 추가)
dim cmd, deliveryRewardYn, deliveryRewardTime
deliveryRewardYn="N"
deliveryRewardTime=3
if oItem.Prd.IsAboardBeasong or oItem.Prd.IsTenBeasong then
	Set cmd = Server.CreateObject("ADODB.COMMAND")
	sqlStr = "[db_item].[dbo].[usp_WWW_DayDelivery_ItemCheck_Get]" 
	cmd.ActiveConnection = dbget
	cmd.CommandText = sqlStr
	cmd.CommandType = adCmdStoredProc
	cmd.Parameters.Append cmd.CreateParameter("@itemid", adInteger, adParamInput, 4, itemid)
	cmd.Parameters.Append cmd.CreateParameter("@deliveryRewardYn", adChar, adParamOutput, 1, "")
	cmd.Execute
	deliveryRewardYn = cmd.Parameters("@deliveryRewardYn").Value
	Set cmd = Nothing
	if Cint(WeekDay(CDate(now())))=7 then '토요일 1시이전 결제 안내
		deliveryRewardTime = 1
	else
		deliveryRewardTime = 3
	end if
end if
%>
<% If Not(IsRentalItem) Then %>
<%
'카드할인 정보 가져오기 (2022.01.28 정태훈)
dim oCardDisInfo, cardName, salePrice, CardminPrice, first_section
set oCardDisInfo = new CCardDiscount
oCardDisInfo.ItemCardDiscountInfo
cardName = oCardDisInfo.FOneItem.FcardName
salePrice = oCardDisInfo.FOneItem.FsalePrice
CardminPrice = oCardDisInfo.FOneItem.FminPrice
set oCardDisInfo = nothing
dim DiscountCash, DiscountInfo
DiscountCash = 0
DiscountInfo = False
if oitem.Prd.isCouponItem and isCouponPriceDisplay Then
    if (oItem.Prd.GetCouponAssignPrice >= 30000) then
        if Clng(GetLoginCurrentMileage()) >= 100 then
			if Clng(GetLoginCurrentMileage()) >= oItem.Prd.GetCouponAssignPrice then
                DiscountCash = oItem.Prd.GetCouponAssignPrice
			else
				DiscountCash = oItem.Prd.GetCouponAssignPrice-GetLoginCurrentMileage()
			end if
            DiscountInfo = True
		else
			DiscountCash = oItem.Prd.GetCouponAssignPrice
        end if
	else
		DiscountCash = oItem.Prd.GetCouponAssignPrice
    end if
else
    if (oItem.Prd.FSellCash >= 30000) then
        if Clng(GetLoginCurrentMileage()) >= 100 then
			if Clng(GetLoginCurrentMileage()) >= oItem.Prd.FSellCash then
                DiscountCash = oItem.Prd.FSellCash
			else
				DiscountCash = oItem.Prd.FSellCash-GetLoginCurrentMileage()
			end if
            DiscountInfo = True
		else
			DiscountCash = oItem.Prd.FSellCash
        end if
	else
		DiscountCash = oItem.Prd.FSellCash
    end if
end if
if cardName <> "" then
    if DiscountCash >= CardminPrice then
        DiscountInfo = True
    end if
end if
if DiscountCash >=50000 then
    DiscountInfo = True
end if
if DiscountInfo then
    first_section = " two_prd"
else
    first_section = " first_section"
end if
%>
			<% if DiscountInfo then %>
			<div class="delivery22 discount first_section">
				<p class="tit">할인의 참견</p>
                <% if oitem.Prd.isCouponItem and isCouponPriceDisplay Then '쿠폰할인시(더블할인 포함) %>
                    <% if (oItem.Prd.GetCouponAssignPrice >= 30000) then %>
                        <% if Clng(GetLoginCurrentMileage()) >= 100 then %>
                            <% if Clng(GetLoginCurrentMileage()) >= oItem.Prd.GetCouponAssignPrice then '상품가격보다 마일리지가 더 많을 시 %>
                                <p class="txt1">내 마일리지를 전부 사용하면 <span>0원 </span></p>
                            <% else %>
                                <% DiscountCash = oItem.Prd.GetCouponAssignPrice-GetLoginCurrentMileage() %>
                                <p class="txt1">내 마일리지를 전부 사용하면 <span><%=FormatNumber(oItem.Prd.GetCouponAssignPrice-GetLoginCurrentMileage(),0)%>원</span></p>
                            <% end if %>
						<% else %>
							<% DiscountCash = oItem.Prd.GetCouponAssignPrice %>
                        <% end if %>
					<% else %>
						<% DiscountCash = oItem.Prd.GetCouponAssignPrice %>
                    <% end if %>
                <% else '할인시 또는 비 할인시 %>
                    <% if (oItem.Prd.FSellCash >= 30000) then %>
                        <% if Clng(GetLoginCurrentMileage()) >= 100 then %>
                            <% if Clng(GetLoginCurrentMileage()) >= oItem.Prd.FSellCash then '상품가격보다 마일리지가 더 많을 시 %>
                                <p class="txt1">내 마일리지를 전부 사용하면 <span>0원</span></p>
                            <% else %>
                                <% DiscountCash = oItem.Prd.FSellCash-GetLoginCurrentMileage() %>
                                <p class="txt1">내 마일리지를 전부 사용하면 <span><%=FormatNumber(oItem.Prd.FSellCash-GetLoginCurrentMileage(),0)%>원</span></p>
                            <% end if %>
						<% else %>
							<% DiscountCash = oItem.Prd.FSellCash %>
                        <% end if %>
					<% else %>
						<% DiscountCash = oItem.Prd.FSellCash %>
                    <% end if %>
                <% end if %>
                <% if cardName <> "" then %>
                    <% if DiscountCash >= CardminPrice then %>
                        <% if DiscountCash-salePrice > 0 then %>
                            <p class="txt2"><%=cardName%>&nbsp;<%=FormatNumber(salePrice,0)%>원 추가할인 시<span><%=FormatNumber(DiscountCash-salePrice,0)%>원</span></p>
                        <% else %>
                            <p class="txt2"><%=cardName%>&nbsp;<%=FormatNumber(salePrice,0)%>원 추가할인 시<span>0원</span></p>
                        <% end if %>
                    <% end if %>
                <% end if %>
                <% if DiscountCash >=50000 then %>
				<p class="txt3"><a href="" onclick="fnAPPpopupBrowserURL('무이자 6개월 할부 안내','<%=wwwUrl%>/apps/appcom/wish/web2014/category/pop_card_MIP.asp');return false;">무이자 6개월 할부 시<i class="i_arw_d2"></i></a> <span>월 <%=FormatNumber(Fix(DiscountCash/6),0)%>원</span></p>
                <% end if %>
			</div>
			<% end if %>
			<%'// 해외직구 %>
			<% If oItem.Prd.IsOverseasDirectPurchase Then %>
			<div class="delivery22 overseas<%=first_section%>">
				<p class="tit">해외직구</p>
				<!--<p class="txt1">해외에서 국내로 배송되는 상품입니다</p>-->
				<p class="txt_b no_margin"><a href="" onclick="fnAPPpopupBrowserURL('해외직구 안내','<%=wwwUrl%>/apps/appcom/wish/web2014/category/pop_abroad_guide.asp'); return false;" class="link">배송 유의사항 확인하기<i class="i_arw_r2"></i></a></p>
			</div>
			<% Else %>
				<%'// 텐텐배송 %>
				<% if oItem.Prd.IsAboardBeasong or oItem.Prd.IsTenBeasong then %>
					<% if oItem.Prd.IsFreeBeasong then %>
						<div class="delivery22 ten_deli<%=first_section%>">
							<p class="tit">텐바이텐 무료배송</p>
							<% if deliveryRewardYn="Y" then %>
							<p class="txt_b">오후 <%=deliveryRewardTime%>시 이전 결제완료 시 오늘 출고<i class="i_arw_r2"></i></p>
							<!--<p class="txt2"><a href="" onclick="fnAPPpopupBrowserURL('배송 안내','<%=wwwUrl%>/apps/appcom/wish/web2014/category/pop_delivery_guide.asp?deliverydiv=D'); return false;" class="link">오늘 출고가 안되면 어쩌죠?<i class="ico-arrow"></i></a></p> -->
							<% else %>
							<p class="txt_b no_margin"><a href="" onclick="fnAPPpopupBrowserURL('배송 안내','<%=wwwUrl%>/apps/appcom/wish/web2014/category/pop_delivery_guide.asp'); return false;" class="link">배송 유의사항 확인하기<i class="i_arw_r2"></i></a></p>
							<% end if %>
						</div>
					<% else %>
						<div class="delivery22 ten_deli<%=first_section%>">
							<p class="tit">텐바이텐 배송</p>
							<% if deliveryRewardYn="Y" then %>
							<p class="txt_b">오후 <%=deliveryRewardTime%>시 이전 결제완료 시 오늘 출고<i class="i_arw_r2"></i></p>
							<!--<p class="txt2"><a href="" onclick="fnAPPpopupBrowserURL('배송 안내','<%=wwwUrl%>/apps/appcom/wish/web2014/category/pop_delivery_guide.asp?deliverydiv=D'); return false;" class="link">오늘 출고가 안되면 어쩌죠?<i class="ico-arrow"></i></a></p>-->
							<% else %>
							<p class="txt_b"><a href="" onclick="fnAPPpopupBrowserURL('배송 안내','<%=wwwUrl%>/apps/appcom/wish/web2014/category/pop_delivery_guide.asp'); return false;" class="link">배송 유의사항 확인하기</a><i class="i_arw_r2"></i></p>
							<% end if %>
							<div class="delivery-etc">텐바이텐 배송 상품 <%=formatNumber(oItem.Prd.getFreeBeasongLimitByUserLevel,0)%>원 이상 구매 시 무료배송<br><a href="" onclick="fnAPPpopupSearchOnNormal('텐바이텐배송','product');return false;">배송비 2,500원 절약하기<i class="ico-arrow"></i></a></div>
						</div>
					<% end if %>
				<% else %>
					<%'// 업체배송 %>
					<div class="delivery22 kiosk<%=first_section%>">
						<p class="tit"><% =oItem.Prd.FBrandName %>&nbsp;<%=NewDeliveryName%></p>
						<% if oItem.Prd.IsManufactureItem then %>
						<p class="txt1"><%=oItem.Prd.FRequireMakeDay%>일 내 출고되는 주문/제작 상품입니다</p>
						<% end if %>
						<% if Not(oItem.Prd.IsFreeBeasong) and (oItem.Prd.IsUpcheParticleDeliverItem or oItem.Prd.IsUpcheReceivePayDeliverItem) Then %>
							<%'// 업체배송 %>
							<% if oItem.Prd.FDeliverytype <> "7" then %>
								<p class="txt_b"><a href="" onclick="fnAPPpopupBrowserURL('배송 안내','<%=wwwUrl%>/apps/appcom/wish/web2014/category/pop_delivery_guide.asp'); return false;" class="link">배송 유의사항 확인하기<i class="i_arw_r2"></i></a></p>
								<div class="delivery-etc"><% =oItem.Prd.FBrandName %> 상품 <%=FormatNumber(oItem.Prd.FDefaultFreeBeasongLimit,0)%>원 이상 구매 시 무료배송<br><a href="" onclick="fnAPPpopupBrand('<% =oItem.Prd.FMakerid %>');return false;">배송비 <%=FormatNumber(oItem.Prd.FDefaultDeliverPay,0)%>원 절약하기<i class="ico-arrow"></i></a></div>
							<% end if %>
						<% else %>
						<p class="txt_b no_margin"><a href="" onclick="fnAPPpopupBrowserURL('배송 안내','<%=wwwUrl%>/apps/appcom/wish/web2014/category/pop_delivery_guide.asp'); return false;" class="link">배송 유의사항 확인하기<i class="i_arw_r2"></i></a></p>
						<% end if %>
					</div>
				<% end if %>
			<% end if %>
			<!-- 선물포장 / 기프트톡 / 오프라인 매장 -->
			<div class="quick">
				<ul>
					<% If G_IsPojangok Then %>
					<% If oItem.Prd.IsPojangitem Then %>
					<li class="giftwrap"><a href="" onClick="fnAPPpopupBrowserURL('선물포장안내','<%=wwwUrl%>/apps/appCom/wish/web2014/category/popPkgIntro.asp?itemid=<%=itemid%>'); return false;">선물포장가능</a></li>
					<% End If %>
					<% End If %>
					<% If IsUserLoginOK Then %>
					<li class="gifttalk"><a href="" onclick="writeShoppingTalk('<%=itemid%>'); return false;">뭐사지? 골라주세요!</a></li>
					<% else %>
					<li class="gifttalk"><a href="" onClick="if(confirm('로그인이 필요한 서비스입니다.\n로그인 하시겠습니까?') == true){location.href = '<%=M_SSLUrl%>/apps/appCom/wish/web2014/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>&mode=wr';}; return false;">뭐사지? 골라주세요!</a></li>
					<% End If %>
					<% if isArray(arrOffShopList) then %>
					<li class="offline"><a href="" onclick="fnAPPpopupBrowserURL('매장안내','<%=wwwUrl%>/apps/appcom/wish/web2014/category/pop_SaleStoreList.asp?itemid=<%=itemid%>'); return false;"><%=arrOffShopList(1,0) & chkIIF(ubound(arrOffShopList,2)>0," 외 " & ubound(arrOffShopList,2) & "곳","")%></a></li>
					<% End If %>
				</ul>
			</div>
			<!-- 브랜드 정보 표기 -->
			<div class="brandshop">
				<strong class="tit"><span><%=oItem.Prd.FBrandName%></span> 상품 더보기<i class="i_arw_r2"></i></strong> 
				<a href="" onClick="fnAPPpopupBrand('<%=oItem.Prd.Fmakerid%>');return false;" class="link"></a>
			</div>
		</section>
<% else %>
			<%'// 해외직구 %>
			<% If oItem.Prd.IsOverseasDirectPurchase Then %>
			<div class="delivery22 overseas<%=first_section%>">
				<p class="tit">해외직구</p>
				<!--<p class="txt1">해외에서 국내로 배송되는 상품입니다</p>-->
				<p class="txt_b no_margin"><a href="" onclick="fnAPPpopupBrowserURL('해외직구 안내','<%=wwwUrl%>/apps/appcom/wish/web2014/category/pop_abroad_guide.asp'); return false;" class="link">배송 유의사항 확인하기<i class="i_arw_r2"></i></a></p>
			</div>
			<% Else %>
				<%'// 텐텐배송 %>
				<% if oItem.Prd.IsAboardBeasong or oItem.Prd.IsTenBeasong then %>
					<% if oItem.Prd.IsFreeBeasong then %>
						<div class="delivery22 ten_deli<%=first_section%>">
							<p class="tit">텐바이텐 무료배송</p>
							<% if deliveryRewardYn="Y" then %>
							<p class="txt_b">오후 <%=deliveryRewardTime%>시 이전 결제완료 시 오늘 출고<i class="i_arw_r2"></i></p>
							<!--<p class="txt2"><a href="" onclick="fnAPPpopupBrowserURL('배송 안내','<%=wwwUrl%>/apps/appcom/wish/web2014/category/pop_delivery_guide.asp?deliverydiv=D'); return false;" class="link">오늘 출고가 안되면 어쩌죠?<i class="ico-arrow"></i></a></p> -->
							<% else %>
							<p class="txt_b no_margin"><a href="" onclick="fnAPPpopupBrowserURL('배송 안내','<%=wwwUrl%>/apps/appcom/wish/web2014/category/pop_delivery_guide.asp'); return false;" class="link">배송 유의사항 확인하기<i class="i_arw_r2"></i></a></p>
							<% end if %>
						</div>
					<% else %>
						<div class="delivery22 ten_deli<%=first_section%>">
							<p class="tit">텐바이텐 배송</p>
							<% if deliveryRewardYn="Y" then %>
							<p class="txt_b">오후 <%=deliveryRewardTime%>시 이전 결제완료 시 오늘 출고<i class="i_arw_r2"></i></p>
							<!--<p class="txt2"><a href="" onclick="fnAPPpopupBrowserURL('배송 안내','<%=wwwUrl%>/apps/appcom/wish/web2014/category/pop_delivery_guide.asp?deliverydiv=D'); return false;" class="link">오늘 출고가 안되면 어쩌죠?<i class="ico-arrow"></i></a></p> -->
							<% else %>
							<p class="txt_b"><a href="" onclick="fnAPPpopupBrowserURL('배송 안내','<%=wwwUrl%>/apps/appcom/wish/web2014/category/pop_delivery_guide.asp'); return false;" class="link">배송 유의사항 확인하기<i class="i_arw_r2"></i></a></p>
							<% end if %>
							<div class="delivery-etc">텐바이텐 배송 상품 <%=formatNumber(oItem.Prd.getFreeBeasongLimitByUserLevel,0)%>원 이상 구매 시 무료배송<br><a href="" onclick="fnAPPpopupSearchOnNormal('텐바이텐배송','product');return false;">배송비 2,500원 절약하기<i class="ico-arrow"></i></a></div>
						</div>
					<% end if %>
				<% else %>
					<%'// 업체배송 %>
					<div class="delivery22 kiosk<%=first_section%>">
						<p class="tit"><% =oItem.Prd.FBrandName %>&nbsp;<%=NewDeliveryName%></p>
						<% if oItem.Prd.IsManufactureItem then %>
						<p class="txt1"><%=oItem.Prd.FRequireMakeDay%>일 내 출고되는 주문/제작 상품입니다</p>
						<% end if %>
						<% if Not(oItem.Prd.IsFreeBeasong) and (oItem.Prd.IsUpcheParticleDeliverItem or oItem.Prd.IsUpcheReceivePayDeliverItem) Then %>
							<%'// 업체배송 %>
							<% if oItem.Prd.FDeliverytype <> "7" then %>
							<p class="txt_b"><a href="" onclick="fnAPPpopupBrowserURL('배송 안내','<%=wwwUrl%>/apps/appcom/wish/web2014/category/pop_delivery_guide.asp'); return false;" class="link">배송 유의사항 확인하기<i class="i_arw_r2"></i></a></p>
							<div class="delivery-etc"><% =oItem.Prd.FBrandName %> 상품 <%=FormatNumber(oItem.Prd.FDefaultFreeBeasongLimit,0)%>원 이상 구매 시 무료배송<br><a href="" onclick="fnAPPpopupBrand('<% =oItem.Prd.FMakerid %>');return false;">배송비 <%=FormatNumber(oItem.Prd.FDefaultDeliverPay,0)%>원 절약하기<i class="ico-arrow"></i></a></div>
							<% end if %>
						<% else %>
						<p class="txt_b no_margin"><a href="" onclick="fnAPPpopupBrowserURL('배송 안내','<%=wwwUrl%>/apps/appcom/wish/web2014/category/pop_delivery_guide.asp'); return false;" class="link">배송 유의사항 확인하기<i class="i_arw_r2"></i></a></p>
						<% end if %>
					</div>
				<% end if %>
			<% end if %>
			<!-- 선물포장 / 기프트톡 / 오프라인 매장 -->
			<div class="quick">
				<ul>
					<% If G_IsPojangok Then %>
					<% If oItem.Prd.IsPojangitem Then %>
					<li class="giftwrap"><a href="" onClick="fnAPPpopupBrowserURL('선물포장안내','<%=wwwUrl%>/apps/appCom/wish/web2014/category/popPkgIntro.asp?itemid=<%=itemid%>'); return false;">선물포장가능</a></li>
					<% End If %>
					<% End If %>
					<% If IsUserLoginOK Then %>
					<li class="gifttalk"><a href="" onclick="writeShoppingTalk('<%=itemid%>'); return false;">뭐사지? 골라주세요!</a></li>
					<% else %>
					<li class="gifttalk"><a href="" onClick="if(confirm('로그인이 필요한 서비스입니다.\n로그인 하시겠습니까?') == true){location.href = '<%=M_SSLUrl%>/apps/appCom/wish/web2014/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>&mode=wr';}; return false;">뭐사지? 골라주세요!</a></li>
					<% End If %>
					<% if isArray(arrOffShopList) then %>
					<li class="offline"><a href="" onclick="fnAPPpopupBrowserURL('매장안내','<%=wwwUrl%>/apps/appcom/wish/web2014/category/pop_SaleStoreList.asp?itemid=<%=itemid%>'); return false;"><%=arrOffShopList(1,0) & chkIIF(ubound(arrOffShopList,2)>0," 외 " & ubound(arrOffShopList,2) & "곳","")%></a></li>
					<% End If %>
				</ul>
			</div>
			<!-- 브랜드 정보 표기 -->
			<div class="brandshop">
				<strong class="tit"><span><%=oItem.Prd.FBrandName%></span> 상품 더보기<i class="i_arw_r2"></i></strong> 
				<a href="" onClick="fnAPPpopupBrand('<%=oItem.Prd.Fmakerid%>');return false;" class="link"></a>
			</div>
		</section>
<% end if %>
		<% if (oitem.Prd.isCouponItem) or (isCateBrandCpnExists) Then %>
		<script>
			function jsDownCouponPrd(stype,idx){
			<% if (NOT IsUserLoginOK) then %>
				if(confirm("로그인이 필요한 서비스 입니다. 로그인 하시겠습니까?")) {
					calllogin();
					return;
				}
				return;
			<% else %>
				aniCoupon.playSegments([75,130], true);
				$('#txtCoupon').removeClass('on');
				$('#btnDown').attr('disabled', true);
				$('#coupon_info').empty().html("쿠폰받기 완료! 결제 시 사용해주세요.");
				var frm;
				frm = document.frmCpn;
				setTimeout(function(){
					frm.stype.value = stype;
					frm.idx.value = idx;
					frm.submit();
				}, 2000);
			<% end if %>
			}
		</script>
		<% end if %>

		<%
		' 마케팅 쿠폰다운 배너 : 18주년 세일 기간 동안 이 위치에 띠배너를 보여줌
		'If date() > "2019-09-25" AND date() < "2019-10-01" Then
		If date() > "2019-09-30" AND date() < "2019-11-01" Then
			server.Execute("/chtml/main/loader/banner/exc_itemprd_banner_coupon.asp")
		End if
		%>

		<!-- #Include virtual="/apps/appCom/wish/web2014/category/inc_PlusSaleList.asp" -->

		<!--// Category Best //-->
		<!--#include virtual="/apps/appCom/wish/web2014/category/inc_category_best.asp" -->

		<% ' 비로그인시 보여주는 배너 상세 페이지 기획 오류로 잠시 보류 2018-12-14 이종화 %>
		<%' if LoginUserid <> "" then %>

		<div class="itemPrdV16a itemPrdV17">
			<%' 상품상세설명 영역 %>
			<div class="itemDeatilV16a itemDetailV18a">
				<!-- #include virtual="/apps/appCom/wish/web2014/category/category_itemprd_detail_new.asp" -->
			</div>

			<% ''If (Not IsTicketItem) Then '티켓아닌경우 - 일반상품 %>
				<% If False Then %>
					<% ' 레코벨 서비스 오픈 150728 원승현 %>
					<script type="text/javascript">
						//var vIId='<%=itemid%>', vDisp='<%=vDisp%>';
					</script>
					<% if cFlgDBUse then %>
						<!--<script type="text/javascript" src="./inc_happyTogether.js"></script>-->
					<% end if %>
					<!--// 함께구매하면 좋은상품 -->
					<!--<div id="lyrHPTgr"></div>-->

				<% End If %>

				<% if cFlgDBUse then %>
					<script type="text/javascript">
						$.ajax({
							url: "act_happyTogetherNew.asp?itemid=<%=itemid%>&disp=<%=vDisp%>",
							cache: false,
							async: true,
							success: function(vRst) {
								if(vRst!="") {
									$("#lyrHappyTogetherCol").empty().html(vRst);
								}
								else
								{
									$('#lyrHappyTogetherCol').hide();
								}
							}
							,error: function(err) {
								//alert(err.responseText);
								$('#lyrHappyTogetherCol').hide();
							}
						});
					</script>
					<div id="lyrHappyTogetherCol"></div>
				<% End If %>
				<%' 마케팅 쿠폰다운 배너 %>
				<%
				'2021.04.14 CX변경으로 하단 이동 (정태훈)
				'이니렌탈 상품일 경우 해당 배너 보여주지 않음
				If Not(IsRentalItem) Then
					If date() < "2019-10-01" OR date() > "2019-10-31" Then
						server.Execute("/chtml/main/loader/banner/exc_itemprd_banner_coupon.asp")
					End if
				End If
				%>
				<%' 마케팅 쿠폰다운 배너 %>
				<!--// Event Item //-->
				<!-- #Include virtual="/apps/appCom/wish/web2014/category/inc_ItemEventList.asp" -->
			<% ''end if %>
		</div>
	</div>

	<div class="alertBoxV17a" style="display:none" id="alertBoxV17a">
		<div>
			<p class="alertCart" id="sbaglayerx" style="display:none"><span>장바구니에 상품이 담겼습니다.</span></p>
			<p id="sbaglayero" style="display:none"><span>장바구니에 이미 같은 상품이 있습니다.</span></p>
			<p class="tMar1-1r"><button type="button" onClick="fnAPPpopupBaguni();" class="btnV16a btnRed2V16a">장바구니 가기 <img src="http://fiximage.10x10.co.kr/m/2016/common/blt_arrow_white.png" alt="" /></button></p>
		</div>
	</div>

<%' 2017 정기세일 이벤트(4/3~4/17 - 숨은 보물찾기 상품은 주문영역 삭제 - 유태욱 %>
<% if itemid = 1676126 or itemid = 1676180 or itemid = 1676207 or itemid = 1676225 or itemid = 1676272 or itemid = 1676297 or itemid = 1676411 or itemid = 1676426 or itemid = 1676481 or itemid = 1676486 or itemid = 1676503 or itemid = 1676514 or itemid = 1676654 or itemid = 1676596 or itemid = 1676597 then %>
<% else %>
	<%' 주문 영역 %>
	<div class="itemFloatingV16a itemFloatingV17">
		<form name="sbagfrm" method="post" action="" style="margin:0px;">
		<input type="hidden" name="mode" value="add" />
		<input type="hidden" name="itemid" value="<% = oitem.Prd.FItemid %>" />
		<input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
		<input type="hidden" name="itemoption" value="" />
		<input type="hidden" name="userid" value="<%= LoginUserid %>" />
		<input type="hidden" name="itemPrice" value="<%= oItem.Prd.getRealPrice %>">
		<input type="hidden" name="isPresentItem" value="<%= isPresentItem %>" />
		<input type="hidden" name="IsSpcTravelItem" value="<%= IsSpcTravelItem %>">
		<input type="hidden" name="itemea" readonly value="1" />
		<input type="hidden" name="itemRemain" id="itemRamainLimit" value="<%=chkIIF(oItem.Prd.IsLimitItemReal,CHKIIF(oItem.Prd.FRemainCount<=oItem.Prd.ForderMaxNum,oItem.Prd.FRemainCount,oItem.Prd.ForderMaxNum),oItem.Prd.ForderMaxNum)%>">
		<input type="hidden" name="rentalmonth" id="rentalmonth" value="">
		<span class="controller"></span>
		<div class="itemOptWrapV16a">
			<div class="itemOptV16a">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide">
							<% IF oItem.Prd.FOptionCnt>0 then %>
								<div class="itemoption">
									<div id="opttag"></div>
								</div>
							<% end if %>
							<% if oItem.Prd.FItemDiv = "06" then %>
								<div class="rqtxt <%=chkiif(oItem.Prd.FOptionCnt>0," tPad0-9r"," onlyTxt")%>">
									<div class="txtBoxV16a requiredetail">
										<textarea name="requiredetail" id="requiredetail" placeholder="[문구입력란] 문구를 입력해 주세요!" onclick="chkopt();"></textarea>
										<% If oItem.Prd.FOptionCnt > 0 Then %>
										<button type="button" class="btnV16a btnMGryV16a" onclick="requireTxt();return false;">완료</button>
										<% End If %>
									</div>
								</div>
							<% end if %>
							<%'간이 장바구니%>
							<ul id="lySpBagList" class="optContListV16a">
								<% If Not(oItem.Prd.FOptionCnt>0) And Not(IsPresentItem) Then %>
								<li>
									<div class="optQuantityV16a tMar0-5r">
										<% If isRentalItem Then %>
											<p class="odrNumV16a">
												<button type="button" class="btnV16a minusQty" onclick="alert('이니렌탈 상품은 수량변경이 불가 합니다.');return false;">감소</button>
												<input type="text" value="1" id='optItemEa' name='optItemEa' readonly/>
												<button type="button" class="btnV16a plusQty" onclick="alert('이니렌탈 상품은 수량변경이 불가 합니다.');return false;">증가</button>
											</p>
											<p class="rt" id="subtotRental"></p>
										<% Else %>
											<p class="odrNumV16a">
												<button type="button" class="btnV16a minusQty" onclick="jsItemea('-');">감소</button>
												<input type="text" value="1" id='optItemEa' name='optItemEa' readonly/>
												<button type="button" class="btnV16a plusQty" onclick="jsItemea('+');">증가</button>
											</p>
											<p class="rt" id="subtot"><%=chkiif(Not(oItem.Prd.FOptionCnt>0) And Not(IsPresentItem),FormatNumber(oItem.Prd.getRealPrice,0),"0")%><%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></p>
										<% End If %>
									</div>
								</li>
								<% End If %>
							</ul>
							<%'간이 장바구니%>
						</div>
					</div>
					<div class="swiper-scrollbar"></div>
				</div>
			</div>
			<% if Not(IsPresentItem) and Not(IsSpcTravelItem) then %>
			<div class="pdtPriceV16a">
				<% If isRentalItem Then %>
					<p>
						<span>렌탈료 합계</span>
					</p>
					<p class="rt" id="spTotalPrcRental"></p>
				<% Else %>
					<p>
						<span>상품 합계</span>
					</p>
					<p class="rt"><strong id="spTotalPrc"><%=chkiif(Not(oItem.Prd.FOptionCnt>0) And Not(IsPresentItem),FormatNumber(oItem.Prd.getRealPrice,0),"0")%></strong><%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></p>
				<% End If %>
			</div>
			<% end if %>
		</div>
		</form>
		<form name="BagArrFrm" method="post" action="" onsubmit="return false;" >
		<input type="hidden" name="mode" value="arr">
		<input type="hidden" name="bagarr" value="">
		<input type="hidden" name="giftnotice" value="<%=GiftNotice%>">
		</form>
		<div class="btnAreaV16a">
			<% if Not(isSpCtlIem) then%>
			    <p>
                    <button id="btnWishV21" class="btn-wishV21" data-flag="<%=chkIIF(isMyFavItem,"on","off")%>">
                        <figure id="icoWishV21" class="ico"></figure>
                        <span id="wishCountV21" class="cnt"><%=FormatNumber(oItem.Prd.FFavCount,0)%></span>
                    </button>
                </p>
			<% end if %>
			<%
				if IsPresentItem then	'## Present상품
					IF Not(oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut) Then
						If IsUserLoginOK() Then		'# 로그인한 경우
			%>
				<p class="actBuy"><button type="button" class="btnV16a btnRed2V16a" onclick="<%=chkiif(oItem.Prd.FOptionCnt>0 or oItem.Prd.FItemDiv = "06","FnAddShoppingBag(true)","TnAddShoppingBag(true)")%>;">바로신청</button></p>
			<%			else %>
				<p class="actBuy"><button type="button" class="btnV16a btnRed2V16a" onclick="alert('회원 구매만 가능합니다. 로그인 후 구매해 주세요.');">바로신청</button></p>
			<%
						end if
					else
			%>
				<p><button type="button" class="btnV16a btnRed2V16a" disabled="disabled">품절</button></p>
			<%
					end if
				elseif IsSpcTravelItem then	'## 스페셜 항공권 상품
					IF Not(oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut) Then
						If IsUserLoginOK() Then		'# 로그인한 경우
			%>
				<p class="actBuy"><button type="button" class="btnV16a btnRed2V16a" onclick="click_shoppingbag_in_product('addShoppingBag');">바로구매</button></p>
				<p class="actCart"><button type="button" class="btnV16a btnRed2V16a" onclick="click_shoppingbag_in_product('addShoppingBag');">바로구매</button></p>
			<%			else %>
				<p class="actBuy"><button type="button" class="btnV16a btnRed2V16a" onclick="alert('회원 구매만 가능합니다. 로그인 후 구매해 주세요.');">바로구매</button></p>
				<p class="actCart"><button type="button" class="btnV16a btnRed2V16a" onclick="alert('회원 구매만 가능합니다. 로그인 후 구매해 주세요.');">바로구매</button></p>
			<%
						end if
					else
			%>
				<p><button type="button" class="btnV16a btnRed2V16a" disabled="disabled">품절</button></p>
			<%
					end if
				else	'## 일반상품
			%>
				<% IF Not(oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut) Then %>
					<% If isRentalItem Then %>
						<p class="actBuy"><button type="button" class="btnV16a btnRed2V16a" onclick="fnAmplitudeEventMultiPropertiesAction('click_order_in_product','itemid','<%=itemid%>','');">렌탈하기</button></p>
					<% Else %>
						<p class="actBuy"><button type="button" class="btnV16a btnRed2V16a" onclick="fnAmplitudeEventMultiPropertiesAction('click_order_in_product','itemid','<%=itemid%>','');">구매하기</button></p>
					<% End If %>
					<p class="actStock"><button type="button" onclick="fnAPPpopupBrowserURL('입고알림신청','<%=wwwUrl%>/apps/appCom/wish/web2014/category/pop_stock.asp?itemid=<%=itemid%>'); return false;" class="btnV16a btn-line-blue" >입고알림</button></p>
					<% If Not(oItem.Prd.IsReserveItem) then %>
					<%If oItem.Prd.FAdultType = 0 Or session("isAdult") then%>
							<p class="actCart"><button type="button" class="btnV16a btnRed1V16a" onclick="click_shoppingbag_in_product('addShoppingBagOption');" disabled="disabled">장바구니</button></p>
						<%else%>
							<p class="actCart"><button type="button" class="btnV16a btnRed1V16a" onclick="click_shoppingbag_in_product('addShoppingBagAdult')" disabled="disabled">장바구니</button></p>
						<%End if%>
					<% End If %>
				<% else %>
					<button type="button" onclick="fnAPPpopupBrowserURL('입고알림신청','<%=wwwUrl%>/apps/appCom/wish/web2014/category/pop_stock.asp?itemid=<%=itemid%>'); return false;" class="btnV16a btn-line-blue">입고알림</button>
					<!--p><button type="button" class="btnV16a btnRed2V16a" disabled="disabled">품절</button></p-->
				<% end if %>
				<% IF Not(oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut or oItem.Prd.IsMileShopitem) Then %>
					<%If oItem.Prd.FAdultType = 0 Or session("isAdult") = True then%>
						<% If isRentalItem Then %>
							<p class="actNow"><button type="button" class="btnV16a btnRed2V16a" onclick="fnAmplitudeEventMultiPropertiesAction('click_directorder_in_product','itemid','<%=itemid%>', function(bool){ if(bool) {setTimeout(function() {<%=chkiif(oItem.Prd.FOptionCnt>0,"FnAddShoppingBag()","TnAddShoppingBag()")%>},10);setTimeout(function() {branchAddToCartEventLoging();}, 30);}});" disabled="disabled">렌탈하기</button></p>
						<% Else %>
							<p class="actNow"><button type="button" class="btnV16a btnRed2V16a" onclick="fnAmplitudeEventMultiPropertiesAction('click_directorder_in_product','itemid','<%=itemid%>', function(bool){ if(bool) {setTimeout(function() {<%=chkiif(oItem.Prd.FOptionCnt>0,"FnAddShoppingBag()","TnAddShoppingBag()")%>},10);setTimeout(function() {branchAddToCartEventLoging();}, 30);setTimeout(function(){appierProductFunction('click_directorder_in_product');}, 50)}});" disabled="disabled">바로구매</button></p>
						<% End If %>
					<%else%>
						<% If isRentalItem Then %>
							<p class="actNow"><button type="button" class="btnV16a btnRed2V16a" onclick="fnAmplitudeEventMultiPropertiesAction('click_directorder_in_product','itemid','<%=itemid%>',function(bool){ if(bool) {setTimeout(function() {confirmAdultAuth('<%=Server.URLencode(CurrURLQ())%>', <%=chkiif(IsUserLoginOK, "true", "false")%>)},10);}});" disabled="disabled">렌탈하기</button></p>
						<% Else %>
							<p class="actNow"><button type="button" class="btnV16a btnRed2V16a" onclick="fnAmplitudeEventMultiPropertiesAction('click_directorder_in_product','itemid','<%=itemid%>',function(bool){ if(bool) {setTimeout(function() {confirmAdultAuth('<%=Server.URLencode(CurrURLQ())%>', <%=chkiif(IsUserLoginOK, "true", "false")%>)},10);setTimeout(function(){appierProductFunction('click_directorder_in_product');}, 30)}});" disabled="disabled">바로구매</button></p>
						<% End If %>
					<%End if%>
				<% end if %>
			<% end if %>
			<!--<p class="actBuy"><button type="button" class="btnV16a btnRed2V16a">구매하기</button></p> -->
			<!--<p class="actCart"><button type="button" class="btnV16a btnRed1V16a" disabled="disabled">장바구니</button></p> for dev msg : 구매하기옵션 선택후 disabled 해제 / 옵션 없는 경우 처음부터 disabled 아님 -->
			<!--<p class="actNow"><button type="button" class="btnV16a btnRed2V16a" disabled="disabled">바로구매</button></p> -->
		</div>
	</div>
	<%' 주문 영역 %>
<% end if %>
	<%
	'<!-- for dev msg : MKT 오리온 마이구미 106538 (A) -->
	if itemid="3371142" then
	'if itemid="3914" then
		dim currentDate, eventStartDate, eventEndDate
		eventStartDate  = cdate("2020-11-04")		'이벤트 시작일
		eventEndDate 	= cdate("2020-11-17")		'이벤트 종료일
		if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" or LoginUserid = "starsun726" or LoginUserid = "bora2116" then
			currentDate = cdate("2020-11-04")
		else
			currentDate = date()
		end if
	%>
	<style>
	.bnr-anniv18 {display:none;}
	.btn_106538 {position:fixed; bottom:0; left:0; width:100%; background:#f96d2b; z-index:110000;}
	.btn_106538 a {display:block; height:5.3rem; text-align:center;}
	.btn_106538 img {width:auto; height:100%;}
	@media only screen and (device-width : 375px) and (device-height : 812px) and (-webkit-device-pixel-ratio : 3) {
		.btn_106538 {padding-bottom:1.71rem;}
	}
	@media only screen and (device-width : 414px) and (device-height : 896px) {
		.btn_106538 {padding-bottom:1.71rem;}
	}
	</style>
	<script>
		function searchItem(){
			<% If Not(IsUserLoginOK) Then %>
				calllogin();
				return false;
			<% else %>
				<% If (currentDate >= eventStartDate And currentDate <= eventEndDate) Then %>
				var returnCode, itemid, data
				var data={
					mode: "searchitem"
				}
				$.ajax({
					type:"POST",
					url:"/event/etc/realtimeevent/realtimeEvent106538Proc.asp",
					data: data,
					dataType: "JSON",
					success : function(res){
						if(res!="") {
							// console.log(res)
							if(res.response == "ok"){
								fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=106538&itemsearch=Y');
								return false;
							}else{
								alert(res.faildesc);
								return false;
							}
						} else {
							alert("잘못된 접근 입니다.");
							document.location.reload();
							return false;
						}
					},
					error:function(err){
						console.log(err)
						alert("잘못된 접근 입니다.");
						return false;
					}
				});
				<% Else %>
					alert("이벤트 응모 기간이 아닙니다.");
					return;
				<% End If %>
			<% End If %>
		}
	</script>
	<div class="btn_106538">
		<a href="#" onClick="searchItem();"><img src="//webimage.10x10.co.kr/fixevent/event/2020/106538/m/img_btn06.png" alt="찾았다!"></a>
	</div>
	<%
	end if
	'<!-- //for dev msg : MKT 오리온 마이구미 106538 (A) -->
	%>
	<form name="qnaform" method="post" action="/apps/appCom/wish/web2014/my10x10/doitemqna.asp" target="iiBagWin" style="margin:0px;">
	<input type="hidden" name="id" value="" />
	<input type="hidden" name="itemid" value="<% = itemid %>" />
	<input type="hidden" name="mode" value="del" />
	<input type="hidden" name="flag" value="fd" />
	</form>
	<iframe src="" name="iiBagWin" frameborder="0" width="0" height="0"></iframe>
	<script>
	$(function(){
		$('.btnZoomV16a').hide();
		$(window).scroll(function(){
			var s_position = $(".itemInfoV16a").outerHeight();
			var e_position1 = $(".itemDeatilV16a").outerHeight();
			var e_position2 = $("#lyrHPTgr").outerHeight();
			var position = $(window).scrollTop();
			if (position > s_position && position < parseInt(e_position1+e_position2)){
				if($('.btnZoomV16a').css("display")=="none"){
					$('.btnZoomV16a').fadeIn();
				}
			} else {
				$('.btnZoomV16a').hide();
			}
		});
	});

	// 위시
    const wish_button = document.getElementById('btnWishV21');
    const ani_wish = bodymovin.loadAnimation({
        container: document.getElementById('icoWishV21'),
        loop: false,
        autoplay: false,
        path: 'https://assets2.lottiefiles.com/private_files/lf30_jgta4mcw.json'
    });
    ani_wish.addEventListener('DOMLoaded', () => {
        if (wish_button.dataset.flag === 'off') {
            ani_wish.goToAndStop(0, true);
        } else {
            ani_wish.goToAndStop(18, true);
        }
    });
    wish_button.addEventListener('click', () => {
        <% If IsUserLoginOK() Then %>
            const item_id = '<%=itemid%>';
            const is_current_on = wish_button.dataset.flag === 'on';
            ajaxPostWish(item_id, !is_current_on, data => {
                if ( is_current_on ) {
                    wish_button.dataset.flag = 'off';
                    ani_wish.playSegments([18,30], true);
                    modifyWishCount(-1);
                } else {
                    wish_button.dataset.flag = 'on';
                    ani_wish.playSegments([0,18], true);
                    modifyWishCount(1);
                    amplitude_click_wish_in_product();
                    setTimeout(function(){
                        appierProductFunction("product_added_to_wishlist");
                    }, 200);
                }
            });
        <% Else %>
            calllogin();
        <% End If %>
    });
    // call 위시 api
    function ajaxPostWish(item_id, flag, callback) {
        let front_api_url = '//fapi.10x10.co.kr/api/web/v1';
        if( '<%=application("Svr_Info")%>'.toLowerCase() === 'dev' ) {
            //front_api_url = '//testfapi.10x10.co.kr/api/web/v1';
            front_api_url = '//localhost:8080/api/web/v1';
        }

        $.ajax({
            type : 'POST',
            url: front_api_url + '/wish/item',
            data: {
                'item_id' : item_id,
                'method' : flag ? 'post' : 'delete'
            },
            ContentType : "json",
            crossDomain: true,
            async: false,
            xhrFields: {
                withCredentials: true
            },
            success: callback,
            error: function (xhr) {
                console.log(xhr);
                const error = JSON.parse(xhr.responseText);
                if( error.code === -10 ) {
                    top.location.href = "<%=M_SSLUrl%>/login/login.asp?backpath=<%=Server.URLencode(CurrURLQ())%>";
                }
            }
        });
    }
    // 위시 수 변경
    function modifyWishCount(count) {
        const wish_count_span = document.getElementById('wishCountV21');
        let wish_count = Number(wish_count_span.innerText.replace(/,/gi, '')) + count;
        if( isNaN(wish_count) || wish_count < 0 )
            return false;
        wish_count_span.innerText = wish_count.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }
	</script>
	<a href="" class="btn-zoom" onclick="fnAPPpopupBrowserURL('상품상세 보기','<%=wwwUrl%>/apps/appCom/wish/web2014/category/pop_category_itemPrd_detail.asp?itemid=<%=itemid%>&viewtype=<%=vItemDtlViewType%>'); return false;">상품 확대보기</a>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
	<!--button type="button" class="goTop" id="gotop">TOP으로 이동</button-->

	<div id="tmpopt" style="display:none;"></div>
	<div id="tmpopLimit" style="display:none;"></div>
	<div id="tmpitemCnt" style="display:none;"></div>

	<%' dropdown layer popup 2017-07-05 신규 버전%>
	<div id="lyDropdown" class="lyDropdown lyDropdownV17">
		<button type="button" class="btnClose">닫기</button>
		<div class="dropDown">
			<p class="btnDrop on">옵션을 선택하세요.</p>
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<div class="dropBox">
							<%' DB에서 옵션들 가저올 부분 %>
							<%=ioptionBoxHtml %>
							<%' DB에서 옵션들 가저올 부분 %>
						</div>
					</div>
				</div>
				<div class="swiper-scrollbar"></div>
			</div>
		</div>
	</div>
	<%' dropdown layer popup 2017-07-05 신규 버전%>

<!-- datadive 전송용 -->
<input type="hidden" id="layerKind" value="product">
<input type="hidden" id="layerItemId" value="<%=itemid%>">
<input type="hidden" id="layerItemName" value="<%=oItem.Prd.FItemName%>">
<!-- #include virtual="/apps/appCom/wish/web2014/common/LayerShare.asp" -->
<script type="text/javascript">
    setTimeout("fnAPPaddRecentlyViewedProduct('<%=itemid%>');",300);
    // 상품 상세 메인 이미지 callnative 전달
    setTimeout(function(){
        fnRecentItemImage('<%=b64encodeprd(getThumbImgFromURL(oItem.Prd.FImageBasic,400,400,"true","false"))%>');
    }, 500);

    setTimeout(function(){
        appierProductFunction("product_viewed");
    }, 700);

</script>
</body>
</html>
<%
	Set oItem = Nothing
	set clsDiaryPrdCheck = Nothing
	Set addEx = Nothing
	If IsTicketItem Then
		set oTicket = Nothing
	end If

	''검색추가로그
	Call AddSearchAddLogItemClickWithChannel("a")
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
