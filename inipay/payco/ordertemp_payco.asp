<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet="UTF-8"
%>
<!-- #include virtual="/login/checkBaguniLogin.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbhelper.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<!-- #INCLUDE Virtual="/lib/email/maillib2.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_tenCashCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<!-- #include virtual="/inipay/payco/payco_defaultSet.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/inipay/common/orderTempFunction.asp" -->
<%
'response.write "<script>alert('죄송합니다. PAYCO 결제 잠시 점검중입니다.');history.back();</script>"
'response.end

Dim vQuery, vQuery1
Dim sqlStr

'// 앱일경우엔 앱경로 넣어준다.
If isApp="1" Then
	wwwUrl = wwwUrl&"/apps/appCom/wish/web2014/"
End If


Dim vIDx, iErrMsg, ipgGubun
Dim irefPgParam   '' 결제 예약시 필요한 값들.
ipgGubun = "PY"
vIdx 	= ""

vIDx = fnSaveOrderTemp("PY_" & cpId, iErrMsg, ipgGubun, irefPgParam)  '' order_temp 임시저장

if (vIDx<1) then
    response.write "ERR2:처리중 오류가 발생하였습니다.- "&iErrMsg&""
    response.write "<script>alert('처리중 오류가 발생했습니다.\n(" & replace(iErrMsg,"'","") & ")')</script>"
	response.write "<script>location.replace('" & wwwUrl & "/inipay/shoppingbag.asp');</script>"
    dbget.close()
    response.end
end if

if (irefPgParam is Nothing) then
    response.write "ERR2:처리중 오류가 발생하였습니다"
    response.write "<script>alert('처리중 오류가 발생했습니다.\n(ERR2)')</script>"
	response.write "<script>location.replace('" & wwwUrl & "/inipay/shoppingbag.asp');</script>"
    dbget.close()
    response.end
end if

''======================================================================================================================
'' PAYCO 전송 처리
''======================================================================================================================
	Dim jsonOrder, OrderNumber, returnUrlParam, extraData
	OrderNumber = 1			'상품 일련 번호

	'---------------------------------------------------------------------------------
	' 구매 상품을 변수에 셋팅 ( JSON 문자열을 생성 )
	'---------------------------------------------------------------------------------
	Set jsonOrder = New aspJson			'JSON 을 작성할 OBJECT 선언

	With jsonOrder.data
		.Add "orderProducts", jsonOrder.Collection()						' (필수) 주문서에 담길 상품 목록 생성

		'---------------------------------------------------------------------------------
		' 상품값으로 읽은 변수들로 Json String 을 작성합니다. (간편결제는 대표상품 1개와 총합산으로 전달)
		'---------------------------------------------------------------------------------
		With jsonOrder.data("orderProducts")
			.Add OrderNumber-1, jsonOrder.Collection()
			With .item(OrderNumber-1)
				.add "cpId",  CStr(cpId)
				.add "productId", CStr(productId)						'페이코 상품 관리 코드(payco_DefaultSet.asp에서 선언)
				.add "productAmt", irefPgParam.FPrice
				.add "productPaymentAmt", irefPgParam.FPrice
				.add "orderQuantity", irefPgParam.Fgoodcnt
				.add "option", ""
				.add "sortOrdering", 0
				.add "productName", CStr(irefPgParam.Fgoodname)
				.add "orderConfirmUrl", ""
				.add "orderConfirmMobileUrl", ""
				.add "productImageUrl", CStr(irefPgParam.Fgoodimg)					'대표상품 Image URL (필수)
				.add "sellerOrderProductReferenceKey", CStr(irefPgParam.Fgoodiid)	'대표 상품코드
				.add "taxationType", "TAXATION"							'과세타입(기본값 : 과세). DUTYFREE :면세, COMBINE : 결합상품, TAXATION : 과세
			End With
		End With

		Set returnUrlParam = New aspJson										' 주문완료 후 Redirect 되는 Url 에 함께 전달되어야 하는 파라미터

'		--------------------------------------------------------------------------------
'		주문완료 후 Reditect 될 때 파라메터 (뭘 보내 수 있을까나~)
'		--------------------------------------------------------------------------------
		With returnUrlParam.data
'			.add "taxationType",     "TAXATION"
'			.add "totalTaxfreeAmt",  "0"
'			.add "totalTaxableAmt",  CStr(vPrice)
'			.add "totalVatAmt",      CStr(vPrice)
			.add "temp_idx",      CStr(vIdx)
		End With

		'---------------------------------------------------------------------------------
		' 주문서에 담길 부가 정보( extraData ) 를 JSON 으로 작성
		'---------------------------------------------------------------------------------
		Set extraData = New aspJson
		With extraData.data
			''If InStr(LCase(WebMode),"iphone") = 0 Then
			If (isApp="1") then ''2018/02/23 수정
				.add "appUrl", CStr("tenwishapp://")'IOS 인앱 결제시 ISP 모바일 등의 앱에서 결제를 처리한 뒤 복귀할 앱 URL (app일 경우 deep link 입력. ex) tenwishapp://url)
			End If
'			.add "payExpiryYmdt",  ""
			.add "cancelMobileUrl", chkIIF(WebMode="MOBILE",CStr(wwwUrl & "/inipay/UserInfo.asp"),"")		' (모바일이면 필수) 모바일 결제페이지에서 취소 버튼 클릭시 이동할 URL ( 결제창 이전 URL등 ).
			.add "viewOptions", extraData.Collection()
			With extraData.data("viewOptions")
				.add "showMobileTopGnbYn", CStr("N")								' 모바일 상단 GNB 노출여부
				.add "iframeYn", CStr("N")											' Iframe 으로 호출 여부
			End with
		End With

		'---------------------------------------------------------------------------------
		' 설정한 주문정보들을 Json String 을 작성합니다.
		'---------------------------------------------------------------------------------
		.Add "sellerKey", CStr(sellerKey)
		.Add "sellerOrderReferenceKey", CStr("10x10")			'임시주문번호 (추후 변경 가능한지 확인 필요)
		.Add "sellerOrderReferenceKeyType", "DUPLICATE_KEY"	'외부가맹점의 주문번호 타입(String 50) UNIQUE_KEY 유니크 키 - 기본값, DUPLICATE_KEY 중복 가능한 키( 외부가맹점의 주문번호가 중복 가능한 경우 사용)
		.Add "currency", "KRW"
		.Add "totalPaymentAmt", irefPgParam.FPrice						'총 결제금액
		
		'---------------------------------------------------------------------------------
		' 세금 정보 입력
		'---------------------------------------------------------------------------------
		dim unitTaxfreeAmt, unitTaxableAmt, unitVatAmt
		unitTaxfreeAmt = 0									' 개별상품단위 면세 금액은 0 원으로 설정
		unitTaxableAmt = Round(irefPgParam.FPrice / 1.1, 0)				' 개별상품단위 상품금액으로 공급가액 계산
		unitVatAmt = irefPgParam.FPrice - unitTaxableAmt				' 개별상품단위 상품금액으로 부가세액 계산

		.Add "totalTaxfreeAmt", CStr(unitTaxfreeAmt)
		.Add "totalTaxableAmt", CStr(unitTaxableAmt)
		.Add "totalVatAmt", CStr(unitVatAmt)

		If irefPgParam.Fgoodcnt > 1 Then
			.Add "orderTitle", CStr(irefPgParam.Fgoodname)&" 외 "&CStr(CInt(irefPgParam.Fgoodcnt-1))&"건"
		Else
			.Add "orderTitle", CStr(irefPgParam.Fgoodname)
		End If
		.Add "returnUrl", CStr(AppWebPath & "/ordertemp_paycoResult.asp")		'승인처리 페이지 URL
		.Add "returnUrlParam", CStr(returnUrlParam.JSONoutput())

''		.Add "nonBankbookDepositInformUrl", CStr("")				'무통장입금 진행시 입금완료 처리 URL

		.Add "orderMethod", CStr(orderMethod)						'간편구매형 : CHECKOUT / 간편결제형 : EASYPAY
		.Add "orderChannel", CStr(WebMode)							'주문채널 ( default : PC / MOBILE )

		If isApp="1" Then
			.Add "inAppYn", "Y"											'인앱결제 여부( Y/N ) ( default = N )
		Else
			.Add "inAppYn", "N"											'인앱결제 여부( Y/N ) ( default = N )
		End If

''		.Add "individualCustomNoInputYn", "N"						'개인통관고유번호 입력 여부 ( Y/N ) ( default = N )
		.Add "orderSheetUiType", CStr("RED")						'주문서 UI 타입 선택 ( 선택 가능값 : RED / GRAY )
		.Add "payMode", CStr(payMode)								'결제모드 ( PAY1 - 결제인증, 승인통합 / PAY2 - 결제인증, 승인분리 )

		.Add "extraData", CStr(extraData.JSONoutput())

	End With

	'---------------------------------------------------------------------------------
	' 주문 예약 함수 호출 ( JSON 데이터를 String 형태로 전달 )
	'---------------------------------------------------------------------------------
	Dim rstJson, conResult, Payco_ReserveId, Payco_orderSheetUrl
	conResult = payco_reserve(jsonOrder.JSONoutput())

	'// 결과 파징
	Set rstJson = New aspJson
	rstJson.loadJSON(conResult)

	'Response.Write rstJson.data("code") & " / " & rstJson.data("message") & " / " & rstJson.data("result").item("reserveOrderNo") & " / " & rstJson.data("result").item("orderSheetUrl")
	'Response.End

if rstJson.data("code")=0 then
	Payco_ReserveId = rstJson.data("result").item("reserveOrderNo")			'페이코 주문번호
	Payco_orderSheetUrl = rstJson.data("result").item("orderSheetUrl")		'결제팝업 호출 URL
else
	response.write "<script>alert('처리중 오류가 발생했습니다.\n(" & rstJson.data("message") & ")')</script>"
	response.write "<script>location.replace('" & wwwUrl & "/inipay/shoppingbag.asp');</script>"
	dbget.close()
	response.end
end If

'예약 번호 저장
sqlStr = "UPDATE [db_order].[dbo].[tbl_order_temp] "
sqlStr = sqlStr & " SET P_RMESG2 = '" & Payco_ReserveId & "'" & VbCRLF
sqlStr = sqlStr & " WHERE temp_idx = '" & vIdx & "'"
dbget.execute sqlStr

SET irefPgParam = Nothing

''### 2. 결제 화면 호출
Response.Redirect Payco_orderSheetUrl
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->