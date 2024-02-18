<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet="UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/login/checkBaguniLogin.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	'# 현재 페이지명 접수
	dim nowViewPage
	nowViewPage = request.ServerVariables("SCRIPT_NAME")
%>
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbhelper.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<!-- #INCLUDE Virtual="/lib/email/maillib2.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_tenCashCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<!-- #include virtual="/inipay/kakao/incKakaopayCommon.asp"-->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/inipay/common/orderTempFunction.asp" -->
<%
Dim vQuery, vRdsite

dim vIdx : vIdx = Request.Form("merchantTxnNumIn")
dim txnId : txnId = Request.Form("txnId")
dim P_resultCode : P_resultCode = Request.Form("resultCode")

''선저장 
vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] "
vQuery = vQuery & " SET P_TID = convert(varchar(50),'" & txnId & "')" & VbCRLF
vQuery = vQuery & " , Tn_paymethod = '100'"                           & VbCRLF       '' 카드로 치환.
IF (P_resultCode<>"00") then
    vQuery = vQuery & " , P_STATUS = convert(varchar(3),'" & CStr(Trim(P_resultCode)) & "')" & VbCRLF
end if
vQuery = vQuery & " WHERE temp_idx = '" & vIdx & "'"                                  '' P_NOTI is temp_idx
dbget.execute vQuery





'// 임시주문 정보 접수 rdsite 별로 분기.=======================================
vQuery = "SELECT TOP 1 * FROM [db_order].[dbo].[tbl_order_temp] WHERE temp_idx = '" & vIdx & "'"
rsget.CursorLocation = adUseClient
rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
IF Not rsget.EOF THEN
	vRdsite			= rsget("rdsite")
END IF
rsget.close

Dim vAppLink
SELECT CASE vRdsite
	Case "app_wish2" : vAppLink = "/apps/appCom/wish/web2014"
	Case "app_wish" : vAppLink = "/apps/appCom/wish/webview"
	Case "app_cal" : vAppLink = "/apps/appCom/wish/webview"
End SELECT


'' 유효성 검사
Dim retChkOK, oshoppingbag, iErrStr, ireserveParam 
iErrStr = ""
retChkOK = fnCheckOrderTemp(vIdx, oshoppingbag,iErrStr, ireserveParam, "KA")

if NOT(retChkOK) then
    response.write "<script>alert('처리중 오류가 발생하였습니다.\r\n- "&replace(iErrStr,"'","")&"');</script>"
    response.write "<script>opener.location.replace('" & M_SSLUrl&vAppLink & "/inipay/shoppingbag.asp');self.close();</script>"
    dbget.close()
    response.end
end if

if (oshoppingbag is Nothing) then
    response.write "<script>alert('처리중 오류가 발생하였습니다..\r\n- "&replace(iErrStr,"'","")&"');</script>"
    response.write "<script>opener.location.replace('" & M_SSLUrl&vAppLink & "/inipay/shoppingbag.asp');self.close();</script>"
    dbget.close()
    response.end
end if


''201712 임시장바구니 변경. :: 결제수단 저장 필요..
dim iorderserial
iErrStr = ""
iorderserial = oshoppingbag.SaveOrderDefaultDB_TmpBaguni(vIdx, iErrStr)

if (iErrStr<>"") then
    response.write iErrStr
    response.write "<script language='javascript'>alert('결제는 이루어 지지 않았습니다. \n\n: 오류 -" & replace(iErrStr,"'","") & "');</script>"

    ''2015/08/16 수정
	'vQuery = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','주문저장중오류(승인이전_moKA) :" + vIdx +":"+ replace(iErrStr,"'","") + "'"
	'dbget.Execute vQuery

	response.end
end if

''======================================================================================================================

Dim objKMPay, k
Dim buyerName, goodsName, nonRepToken
Dim resultCode, resultMsg, authDate, authCode, payMethod, resMerchantId
Dim tid, moid, amt, cardCode, cardName, cardQuota, cardInterest, cardCl, cardBin, cardPoint, paySuccess
Dim DiscountAmt, CcPartCl, PromotionCcPartCl, partialCancelAvail : partialCancelAvail = "0"

'1) 객체 생성
Set objKMPay = Server.CreateObject("LGCNS.CNSPayService.CnsPayWebConnector")
objKMPay.RequestUrl = CNSPAY_DEAL_REQUEST_URL
  
'2) 로그 정보
objKMPay.SetCnsPayLogging KMPAY_LOG_DIR, KMPAY_LOG_LEVEL	'-1:로그 사용 안함, 0:Error, 1:Info, 2:Debug

'3) 요청 페이지 파라메터 셋팅
For Each k In Request.Form
	objKMPay.AddRequestData k, Request.Form(k)
	
Next

'response.end

'4) 추가 파라메터 셋팅
objKMPay.AddRequestData "actionType", "PY0"  							' actionType : CL0 취소, PY0 승인, CI0 조회
objKMPay.AddRequestData "MallIP", Request.ServerVariables("LOCAL_ADDR")	' 가맹점 고유 ip
objKMPay.AddRequestData "CancelPwd", KMPAY_CANCEL_PWD					' 취소 비밀번호 설정

'5) 가맹점키 셋팅 (MID 별로 틀림)
objKMPay.AddRequestData "EncodeKey", KMPAY_MERCHANT_KEY

'6) CNSPAY Lite 서버 접속하여 처리
objKMPay.RequestAction

'7) 결과 처리
buyerName = Request.Form("BuyerName")   							' 구매자명
goodsName = Request.Form("GoodsName") 								' 상품명
nonRepToken =Request.Form("NON_REP_TOKEN")

resultCode = objKMPay.GetResultData("ResultCode") 		' 결과코드 (정상 :3001 , 그 외 에러)
resultMsg = objKMPay.GetResultData("ResultMsg")   		' 결과메시지
authDate = objKMPay.GetResultData("AuthDate")   			' 승인일시 YYMMDDHH24mmss
authCode = objKMPay.GetResultData("AuthCode")   			' 승인번호
payMethod = objKMPay.GetResultData("PayMethod")  			' 결제수단
resMerchantId = objKMPay.GetResultData("MID")  				' 가맹점ID
tid = objKMPay.GetResultData("TID")  						' 거래ID
moid = objKMPay.GetResultData("Moid")  						' 주문번호
amt = objKMPay.GetResultData("Amt")  						' 금액
cardCode = objKMPay.GetResultData("CardCode")				' 카드사 코드
cardName = objKMPay.GetResultData("CardName")  	 			' 결제카드사명
cardQuota = objKMPay.GetResultData("CardQuota") 			' 00:일시불,02:2개월
cardInterest = objKMPay.GetResultData("CardInterest")       ' 무이자 여부 (0:일반, 1:무이자)
cardCl = objKMPay.GetResultData("CardCl")                   ' 체크카드여부 (0:일반, 1:체크카드)
cardBin = objKMPay.GetResultData("CardBin")                 ' 카드BIN번호
cardPoint = objKMPay.GetResultData("CardPoint")             ' 카드사포인트사용여부 (0:미사용, 1:포인트사용, 2:세이브포인트사용)

DiscountAmt = objKMPay.GetResultData("DiscountAmt")                 '' PG사 프로모션 할인금액
CcPartCl = objKMPay.GetResultData("CcPartCl")                       '': 부분취소 가능여부. (0:부분취소불가, 1:부분취소가능))
PromotionCcPartCl = objKMPay.GetResultData("PromotionCcPartCl")     ''( Y: 가능, N: 불가능) ,NULL (프로모션 적용안할시)
if isNULL(PromotionCcPartCl) then
    PromotionCcPartCl="Y"
end if

paySuccess = false																		' 결제 성공 여부

if ((CcPartCl<>"0") and (PromotionCcPartCl<>"N")) then      '' 부분취소 가능여부
    partialCancelAvail = "1"
end if
if (DiscountAmt="") then DiscountAmt=0

if (DiscountAmt<>0) then partialCancelAvail="0"

'위의 응답 데이터 외에도 전문 Header와 개별부 데이터 Get 가능
if payMethod = "CARD" then	'신용카드
	if resultCode = "3001" then paySuccess = true				' 결과코드 (정상 :3001 , 그 외 에러) :: 카드
end if


if (paySuccess) then
   '결제 성공시 DB처리 하세요.              
    ''(WWW) PayEtcResult               = LEFT(CardCode&"|"&CardIssuerCode&"|"&CardQuota&"|"&PrtcCode,16)
    ''(MOB) iorderParams.FPayEtcResult = LEFT(vP_FN_CD1&"|"&vP_CARD_ISSUER_CODE&"|"&vP_RMESG2&"|"&vP_CARD_PRTC_CODE,16)
    resultMsg = "["&resultCode&"]"&resultMsg
    
    vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] " &VBCRLF
    vQuery = vQuery & " SET P_STATUS = '00'" &VBCRLF
    vQuery = vQuery & " , P_TID = convert(varchar(50),'" & tid & "')" &VBCRLF
    vQuery = vQuery & " , P_AUTH_NO = convert(varchar(50),'" & authCode & "')" &VBCRLF                      ''승인번호.
    vQuery = vQuery & " , P_RMESG1 = convert(varchar(500),'" & resultMsg & "') " &VBCRLF                    ''결제 결과메세지
    vQuery = vQuery & " , P_RMESG2 = convert(varchar(500),'" & CardQuota & "')" &VBCRLF                     ''할부개월수로사용.
    vQuery = vQuery & " , P_FN_CD1 = convert(varchar(5),'" & cardCode & "')" &VBCRLF                        ''신용카드코드
    vQuery = vQuery & " , P_CARD_ISSUER_CODE = convert(varchar(3),'" & cardCode & "')" &VBCRLF              ''카드발급사코드
    vQuery = vQuery & " , P_CARD_PRTC_CODE = convert(varchar(10),'" & partialCancelAvail & "') " &VBCRLF     ''부분취소 가능여부('0':불가, '1':가능)
    vQuery = vQuery & " , pDiscount="&DiscountAmt&"" &VBCRLF
    vQuery = vQuery & " , Tn_paymethod = '100'"  
    vQuery = vQuery & " WHERE temp_idx = '" & vIdx & "'"
	dbget.execute vQuery
   
else
   '결제 실패시 DB처리 하세요.
    resultMsg = "["&resultCode&"]"&resultMsg
   
    vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] " &VBCRLF
    vQuery = vQuery & " SET P_STATUS = convert(varchar(3),'"&resultCode&"')"  '' &VBCRLF 
    vQuery = vQuery & " , P_TID = convert(varchar(50),'" & tid & "')" &VBCRLF
    vQuery = vQuery & " , P_AUTH_NO = convert(varchar(50),'" & authCode & "')" &VBCRLF
    vQuery = vQuery & " , P_RMESG1 = convert(varchar(500),'" & resultMsg & "') " &VBCRLF
    vQuery = vQuery & " , P_RMESG2 = convert(varchar(500),'" & CardQuota & "')" &VBCRLF
    vQuery = vQuery & " , P_FN_CD1 = convert(varchar(5),'" & cardCode & "')" &VBCRLF
    vQuery = vQuery & " , P_CARD_ISSUER_CODE = convert(varchar(3),'" & cardCode & "')" &VBCRLF
    vQuery = vQuery & " , P_CARD_PRTC_CODE = convert(varchar(10),'"&partialCancelAvail&"') " &VBCRLF
    vQuery = vQuery & " , pDiscount="&DiscountAmt&"" &VBCRLF
    vQuery = vQuery & " , Tn_paymethod = '100'"  
    vQuery = vQuery & " WHERE temp_idx = '" & vIdx & "'"
	dbget.execute vQuery
end if


'' 3. 실 주문정보 저장 
Dim vResult, vIsSuccess
iErrStr = ""
Call oshoppingbag.SaveOrderResultDB_TmpBaguni(vIdx, "", iErrStr, vResult, vIsSuccess)


if (iErrStr<>"") then
    response.write iErrStr
    Response.write "<script type='text/javascript'>alert('04. 주문 처리 과정중 오류가 발생하였습니다. 고객센터로 문의해 주세요.');</script>"
    response.write "<script>location.replace('"&M_SSLUrl&vAppLink&"/inipay/shoppingbag.asp');</script>"
	dbget.close()
    response.end
end if

On Error resume Next
dim osms, helpmail
helpmail = oshoppingbag.GetHelpMailURL

IF (vIsSuccess) THEN
    call sendmailorder(iorderserial,helpmail)

    set osms = new CSMSClass
	osms.SendJumunOkMsg ireserveParam.FBuyhp, iorderserial
    set osms = Nothing

end if
on Error Goto 0

response.Cookies("shoppingbag").domain = "10x10.co.kr"
response.Cookies("shoppingbag")("before_orderserial") = iorderserial

if (vIsSuccess) then
	response.Cookies("shoppingbag")("before_issuccess") = "true"
else
	response.Cookies("shoppingbag")("before_issuccess") = "false"
end if


dim dumi : dumi=TenOrderSerialHash(iorderserial)

''비회원인 경우 orderserial-uk 값 저장. 2017/10/23 require commlib
IF (vResult = "ok") and (ireserveParam.FUserID="") then
    Call fnUserLogCheck_AddGuestOrderserial_UK(iorderserial,request.Cookies("shoppingbag")("GSSN")) 
end if

SET ireserveParam = Nothing
SET oshoppingbag  = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->

<script type="text/javascript">
    setTimeout(function(){
        try{
            window.location.replace("<%=wwwUrl&vAppLink%>/inipay/DisplayOrder.asp?dumi=<%=dumi%>");
        }catch(ss){
            location.href="<%=vAppLink%>/inipay/DisplayOrder.asp?dumi=<%=dumi%>";
        }
    },200);
	//document.location.href = "<%=wwwUrl&vAppLink%>/inipay/DisplayOrder.asp?dumi=<%=dumi%>"
</script>
