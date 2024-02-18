<%@  codepage="65001" language="VBScript" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/login/checkBaguniLogin.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
    response.charset = "utf-8"

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
<!-- #include virtual="/inipay/card/order_real_save_function.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<%

'/////////////////////////////////////////////////////////////////////////////
'///// 1. 변수 초기화 및 POST 인증값 받음                                 ////
'/////////////////////////////////////////////////////////////////////////////
Dim P_STATUS, P_RMESG1, P_TID, P_REQ_URL, P_NOTI
P_STATUS = Request("P_STATUS")			'// 인증 상태
P_RMESG1 = Request("P_RMESG1")			'// 인증 결과 메시지
P_TID = Request("P_TID")				'// 인증 거래번호
P_REQ_URL = Request("P_REQ_URL")		'// 결제요청 URL
P_NOTI = Request("P_NOTI")				'// 기타주문정보



'/////////////////////////////////////////////////////////////////////////////
'///// 2. 상점 아이디 설정 :                                              ////
'/////    결제요청 페이지에서 사용한 MID값과 동일하게 세팅해야 함...      ////
'/////////////////////////////////////////////////////////////////////////////
Dim P_MID
P_MID = "teenxteen9"					'// 상점아이디
IF application("Svr_Info")="Dev" THEN
	P_MID = "INIpayTest"
END IF

''휴대폰 결제 2015/05/14
if InStr(LCASE(P_TID),"teenteen10")>0 THEN P_MID = "teenteen10"
    
'	If P_STATUS = "01" Then '인증결과가 실패일 경우
'		Response.write "<script language='javascript'>alert('01. 이니시스에 인증결과 실패가 발생하였습니다. 다시 시도해 주세요.');</script>"
'		dbget.close()
'		Response.End
'	End If


'/////////////////////////////////////////////////////////////////////////////
'///// 3. 승인요청 :                                                      ////
'/////    인증값을 가지고 P_REQ_URL로 승인요청을 함...                    ////
'/////  - 참조 : http://doevents.egloos.com/296023
'/////////////////////////////////////////////////////////////////////////////


Dim vQuery, vAuthCode, vTID, vIdx, vMessage, vPType, vP_RMESG2, vP_FN_CD1, vP_CARD_ISSUER_CODE, vP_CARD_PRTC_CODE
dim url : url = P_REQ_URL
dim xmlHttp,  postdata

''선저장 //2013/03/14 추가
vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] "
vQuery = vQuery & " SET P_STATUS = convert(varchar(3),'" & CStr(Trim(P_STATUS)) & "')"
vQuery = vQuery & " , P_TID = convert(varchar(50),'" & P_TID & "')"
vQuery = vQuery & " , P_RMESG1 = convert(varchar(500),'" & P_RMESG1 & "')"
vQuery = vQuery & " WHERE temp_idx = '" & P_NOTI & "'"                                  '' P_NOTI is temp_idx
dbget.execute vQuery

''장바구니 금액체크 //2014/01/28
'''-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Dim vUserID, vGuestSeKey, vCountryCode, vEmsPrice, vRdsite, vSailcoupon, vCouponmoney, vPacktype, vSpendmileage, vSpendtencash, vSpendgiftmoney, vPrice, vCheckitemcouponlist
vQuery = "SELECT TOP 1 * FROM [db_order].[dbo].[tbl_order_temp] WHERE temp_idx = '" & P_NOTI & "'"
rsget.Open vQuery,dbget,1
IF Not rsget.EOF THEN
	vUserID 		= rsget("userid")
	vGuestSeKey 	= rsget("guestSessionID")
	vCountryCode	= rsget("countryCode")
	vEmsPrice		= rsget("emsPrice")
	vRdsite			= rsget("rdsite")
	vSailcoupon		= rsget("sailcoupon")
	vCouponmoney	= rsget("couponmoney")
	vPacktype		= rsget("packtype")
	vSpendmileage	= rsget("spendmileage")
	vSpendtencash	= rsget("spendtencash")
	vSpendgiftmoney	= rsget("spendgiftmoney")
	vPrice			= rsget("price")
	vCheckitemcouponlist	= rsget("checkitemcouponlist")
END IF
rsget.close

Dim vAppLink, device
SELECT CASE vRdsite
	Case "app_wish2" : vAppLink = "/apps/appCom/wish/web2014"
	Case "app_wish" : vAppLink = "/apps/appCom/wish/webview"
	Case "app_cal" : vAppLink = "/apps/appCom/wish/webview"
End SELECT
if instr(vRdsite,"app") > 0 then
	device="A"
else
	device="M"
end if
if device="" then device="M"

If P_STATUS = "01" Then '인증결과가 실패일 경우
	Response.write "<script language='javascript'>alert('01. 이니시스에 인증결과 실패가 발생하였습니다. 다시 시도해 주세요.');</script>"
	Response.write "<script language='javascript'>location.replace('"&M_SSLUrl&vAppLink&"/inipay/UserInfo.asp');</script>"  ''추가 2015/08/03
	dbget.close()
	Response.End
End If

'''장바구니 금액 후Check===================================================================================================
'''' ########### 마일리지 사용 체크 - ################################
dim oMileage, availtotalMile
set oMileage = new TenPoint
oMileage.FRectUserID = vUserID
if (vUserID<>"") then
    oMileage.getTotalMileage
    availtotalMile = oMileage.FTotalMileage
end if
set oMileage = Nothing

''예치금 추가
Dim oTenCash, availtotalTenCash
set oTenCash = new CTenCash
oTenCash.FRectUserID = vUserID
if (vUserID<>"") then
    oTenCash.getUserCurrentTenCash
    availtotalTenCash = oTenCash.Fcurrentdeposit
end if
set oTenCash = Nothing

''Gift카드 추가
Dim oGiftCard, availTotalGiftMoney
availTotalGiftMoney = 0
set oGiftCard = new myGiftCard
oGiftCard.FRectUserID = vUserID
if (vUserID<>"") then
    availTotalGiftMoney = oGiftCard.myGiftCardCurrentCash
end if
set oGiftCard = Nothing

if (availtotalMile<1) then availtotalMile=0
if (availtotalTenCash<1) then availtotalTenCash=0
if (availTotalGiftMoney<1) then availTotalGiftMoney=0

if (CLng(vSpendmileage)>CLng(availtotalMile)) then
    response.write "<script>alert('장바구니 금액 오류 (사용가능 마일리지 부족) - 다시계산해 주세요.')</script>"
	response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp')</script>"
	response.end
end if

if (CLng(vSpendtencash)>CLng(availtotalTenCash)) then
    response.write "<script>alert('장바구니 금액 오류 (사용가능 예치금 부족) - 다시계산해 주세요.')</script>"
	response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp')</script>"
	response.end
end if

if (CLng(vSpendgiftmoney)>CLng(availTotalGiftMoney)) then
    response.write "<script>alert('장바구니 금액 오류 (사용가능 Gift카드 잔액 부족) - 다시계산해 주세요.')</script>"
	response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp')</script>"
	response.end
end if

''장바구니
dim oshoppingbag,goodname
set oshoppingbag = new CShoppingBag
	oshoppingbag.FRectUserID = vUserID
	oshoppingbag.FRectSessionID = vGuestSeKey
	oShoppingBag.FRectSiteName  = "10x10"
	oShoppingBag.FcountryCode = vCountryCode
	oshoppingbag.GetShoppingBagDataDB_Checked

if (oshoppingbag.IsShoppingBagVoid) then
	response.write "<script>alert('쇼핑백이 비었습니다. - 결제는 이루어지지 않았습니다.');</script>"
	response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp');</script>"
	response.end
end if

''품절상품체크::임시.연아다이어리
if (oshoppingbag.IsSoldOutSangpumExists) then
    response.write "<script>alert('죄송합니다. 품절된 상품은 구매하실 수 없습니다.');</script>"
	response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp');</script>"
	response.end
end if

''업체 개별 배송비 상품이 있는경우
if (oshoppingbag.IsUpcheParticleBeasongInclude)  then
    oshoppingbag.GetParticleBeasongInfoDB_Checked
end if

goodname = oshoppingbag.getGoodsName

dim tmpitemcoupon, tmp, i
tmpitemcoupon = split(vCheckitemcouponlist,",")

'상품쿠폰 적용
for i=LBound(tmpitemcoupon) to UBound(tmpitemcoupon)
	tmp = trim(tmpitemcoupon(i))

	if oshoppingbag.IsCouponItemExistsByCouponIdx(tmp) then
		oshoppingbag.AssignItemCoupon(tmp)
	end if
next

''보너스 쿠폰 적용
if (vSailcoupon<>"") and (vSailcoupon<>"0") then
    oshoppingbag.AssignBonusCoupon(vSailcoupon)
end if

''Ems 금액 적용
oshoppingbag.FemsPrice = vEmsPrice

''20120202 EMS 금액 체크(해외배송)
if (vCountryCode<>"") and (vCountryCode<>"KR") and (vCountryCode<>"ZZ") and (vEmsPrice<1) then
    response.write "<script>alert('장바구니 금액 오류 - EMS 금액오류.')</script>"
	response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp')</script>"
	response.end
end if

''보너스쿠폰 금액 체크 ''2012/11/28-----------------------------------------------------------------
dim mayBCpnDiscountPrc
if (vCouponmoney<>0) then
    mayBCpnDiscountPrc = oshoppingbag.getBonusCouponMayDiscountPrice

    if (CLNG(mayBCpnDiscountPrc)<CLNG(vCouponmoney)) then
        'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg )"
		'sqlStr = sqlStr + " values( '010-6324-9110', '1644-6030', '1', getdate(), "
		'sqlStr = sqlStr + " convert(varchar(250),'쿠폰 금액오류 moRnext :"&vSailcoupon&":"&mayBCpnDiscountPrc&"::"&vCouponmoney&"'))"

		'dbget.Execute sqlStr

        response.write "<script>alert('장바구니 금액 오류 - 다시계산해 주세요.')</script>"
        response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp')</script>"
	    response.end
    end if
end if
'''-------------------------------------------------------------------------------------------------

dim ipojangcnt, ipojangcash
	ipojangcnt=0
	ipojangcash=0

'선물포장서비스 노출		'/2015.11.11 한용민 생성
if G_IsPojangok then
	ipojangcnt = oshoppingbag.FPojangBoxCNT		'/포장박스갯수
	ipojangcash = oshoppingbag.FPojangBoxCASH		'/포장비
end if

'''금액일치확인 ***
if (CLng(oshoppingbag.getTotalCouponAssignPrice(vPacktype) + ipojangcash - vSpendmileage-vCouponmoney-vSpendtencash-vSpendgiftmoney) <> CLng(vPrice)) then
    'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg )"
	'sqlStr = sqlStr + " values( '010-6324-9110', '1644-6030', '1', getdate(), "
	'sqlStr = sqlStr + " convert(varchar(250),'장바구니 금액오류 moRnext :"&CStr(vIdx)&":"&oshoppingbag.getTotalCouponAssignPrice(vPacktype) + ipojangcash - vSpendmileage-vCouponmoney-vSpendtencash-vSpendgiftmoney&"::"&vPrice&"'))"

	'dbget.Execute sqlStr

	'####### 카드결제 오류 로그 전송
	sqlStr = "INSERT INTO [db_order].[dbo].[tbl_order_mobilecard_errReport]("
	sqlStr = sqlStr & " gubun, temp_idx, userid, guestSessionID, totCouponAssignPrice, spendmileage, couponmoney, spendtencash, spendgiftmoney, subtotalprice, sailcoupon, checkitemcouponlist) VALUES( "
	sqlStr = sqlStr & " 'rnext','" & vIdx & "','" & vUserID & "','" & vGuestSeKey & "','" & oshoppingbag.getTotalCouponAssignPrice(vPacktype) + ipojangcash & "','" & vSpendmileage & "','" & vCouponmoney & "','" & vSpendtencash & "', "
	sqlStr = sqlStr & " '" & vSpendgiftmoney & "','" & vPrice & "','" & vSailcoupon & "','" & vCheckitemcouponlist & "') "
	dbget.execute sqlStr

	response.write "<script>alert('장바구니 금액 오류 - 다시계산해 주세요.')</script>"
	response.write "<script>location.replace('" & wwwUrl & vAppLink & "/inipay/shoppingbag.asp')</script>"
	response.end
end if
set oshoppingbag = Nothing
''======================================================================================================================

'''-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

''이니시스 승인요청
Dim useXMLHTTP
''useXMLHTTP = (application("Svr_Info")="Dev") or (application("Svr_Info")="138") or (application("Svr_Info")="084") or (application("Svr_Info")="085") or (application("Svr_Info")="086") or (application("Svr_Info")="088") or (application("Svr_Info")="089") or (application("Svr_Info")="091")
''useXMLHTTP = true
''if (application("Svr_Info")="137") or (application("Svr_Info")="083") or (application("Svr_Info")="085") or (application("Svr_Info")="084") or (application("Svr_Info")="089") or (application("Svr_Info")="088") or (application("Svr_Info")="087") or (application("Svr_Info")="086") then ''win2008 / iis7 응용프로그램 풀 재생후 SSL 최초접속 안됨. ServerXMLHTTP 은 됨..
''    useXMLHTTP = false
''end if

'' useXMLHTTP = false  :: ServerXMLHTTP
useXMLHTTP = false

''TEST
if (useXMLHTTP) then 
    Set xmlHttp = server.CreateObject("Microsoft.XMLHTTP")
    
    postdata = "P_TID=" & P_TID & "&P_MID=" & P_MID '보낼 데이터 <!-- //-->
    
    On Error Resume Next
    xmlHttp.Open "POST", url, False
	xmlHttp.SetRequestHeader "Content-Type", "application/x-www-form-urlencoded"
	xmlHttp.Send postdata
	
    
    IF Err.Number <> 0 then
        'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg )"
		'sqlStr = sqlStr + " values( '010-6324-9110', '1644-6030', '1', getdate(), "
        'sqlStr = sqlStr + " convert(varchar(250),'xmlhttp :"&application("Svr_Info")&"-"&P_NOTI&":"&replace(err.Description,"'","")&"'))"
        
		'dbget.Execute sqlStr
		
		Response.write "<script language='javascript'>alert('02. 이니시스에 승인요청 중 오류가 발생하였습니다. ');</script>"
		dbget.close()
		Response.End
	End If
	
	On Error Goto 0
	
	vntPostedData = BinaryToText(xmlHttp.responseBody, "UTF-8")
	''vntPostedData = (xmlHttp.responseText)
	
	Set xmlHttp = nothing
else
	Set xmlHttp = CreateObject("Msxml2.ServerXMLHTTP.3.0")

	postdata = "P_TID=" & P_TID & "&P_MID=" & P_MID '보낼 데이터 <!-- //-->
    
    On Error Resume Next
	xmlHttp.open "POST",url, False
    xmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
    xmlHttp.setTimeouts 30000,90000,90000,90000 ''2013/03/14 추가
	xmlHttp.Send postdata	'post data send

    
	IF Err.Number <> 0 then
	    'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg )"
		'sqlStr = sqlStr + " values( '010-6324-9110', '1644-6030', '1', getdate(), "
        'sqlStr = sqlStr + " convert(varchar(250),'SvrXmlhttp :"&application("Svr_Info")&"-"&P_NOTI&":"&replace(err.Description&":"&url,"'","")&"'))"
        
		'dbget.Execute sqlStr
		
		Response.write "<script language='javascript'>alert('02. 이니시스에 승인요청 중 오류가 발생하였습니다. ');</script>"
		dbget.close()
		Response.End
	End If
    
    On Error Goto 0
    
	vntPostedData = BinaryToText(xmlHttp.responseBody, "UTF-8")
	
	Set xmlHttp = nothing
end if

strData = vntPostedData

arr = Split(strData , "&")
k = 0
for i = 0 to UBound(arr)
k = k +1
next

for i = 0 to k-1
	'response.write "["&i+1&"] "&arr(i)
	'response.write "<br>"
	' asp 연관배열 http://www.shop-wiz.com/board/main/view/root/asp2/60

	If instr(1, arr(i), "P_AUTH_NO") <> "0" Then
		vAuthCode = Split(arr(i),"=")(1)
	End If

	If instr(1, arr(i), "P_TID") <> "0" Then
		vTID = Split(arr(i),"=")(1)
	End If

	If instr(1, arr(i), "P_NOTI") <> "0" Then
		vIdx = Split(arr(i),"=")(1)
	End If

	If instr(1, arr(i), "P_RMESG1") <> "0" Then
		vMessage = Split(arr(i),"=")(1)
	End If

	If instr(1, arr(i), "P_TYPE") <> "0" Then
		vPType = Split(arr(i),"=")(1)
	End If

	If instr(1, arr(i), "P_RMESG2") <> "0" Then
		vP_RMESG2 = Split(arr(i),"=")(1)
	End If

	If instr(1, arr(i), "P_FN_CD1") <> "0" Then
		vP_FN_CD1 = Split(arr(i),"=")(1)
	End If

	If instr(1, arr(i), "P_CARD_ISSUER_CODE") <> "0" Then
		vP_CARD_ISSUER_CODE = Split(arr(i),"=")(1)
	End If

	If instr(1, arr(i), "P_CARD_PRTC_CODE") <> "0" Then
		vP_CARD_PRTC_CODE = Split(arr(i),"=")(1)
	End If
	
	IF (vPType="MOBILE") then  '2015/04/22 추가
		If instr(1, arr(i), "P_HPP_NUM") <> "0" Then  
			vAuthCode = Split(arr(i),"=")(1)
		End If
	end if
next

vMessage = "[" & vPType & "_" & vMessage & "]"

'	vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] SET P_STATUS = '" & CStr(Trim(Split(arr(0),"=")(1))) & "', P_TID = '" & vTID & "', P_AUTH_NO = '" & vAuthCode & "' , P_RMESG1 = '" & vMessage & "' "
'	vQuery = vQuery & ", P_RMESG2 = '" & vP_RMESG2 & "', P_FN_CD1 = '" & vP_FN_CD1 & "', P_CARD_ISSUER_CODE = '" & vP_CARD_ISSUER_CODE & "', P_CARD_PRTC_CODE = '" & vP_CARD_PRTC_CODE & "' "
'	vQuery = vQuery & "WHERE temp_idx = '" & vIdx & "'"
'	dbget.execute vQuery

vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] "
vQuery = vQuery & " SET P_STATUS = convert(varchar(3),'" & CStr(Trim(Split(arr(0),"=")(1))) & "')"
vQuery = vQuery & " , P_TID = convert(varchar(50),'" & vTID & "')"
vQuery = vQuery & " , P_AUTH_NO = convert(varchar(50),'" & vAuthCode & "')"
vQuery = vQuery & " , P_RMESG1 = convert(varchar(500),'" & vMessage & "') "
vQuery = vQuery & " , P_RMESG2 = convert(varchar(500),'" & vP_RMESG2 & "')"
vQuery = vQuery & " , P_FN_CD1 = convert(varchar(5),'" & vP_FN_CD1 & "')"
vQuery = vQuery & " , P_CARD_ISSUER_CODE = convert(varchar(3),'" & vP_CARD_ISSUER_CODE & "')"
vQuery = vQuery & " , P_CARD_PRTC_CODE = convert(varchar(10),'" & vP_CARD_PRTC_CODE & "') "
vQuery = vQuery & " WHERE temp_idx = '" & vIdx & "'"
dbget.execute vQuery

Dim vTemp, vResult, vIOrder, vIsSuccess
vTemp 		= OrderRealSaveProc(vIdx)

vResult		= Split(vTemp,"|")(0)
vIOrder		= Split(vTemp,"|")(1)
vIsSuccess	= Split(vTemp,"|")(2)

IF vResult = "ok" Then
	vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] SET IsPay = 'Y', PayResultCode = '" & vResult & "', orderserial = '" & vIOrder & "', IsSuccess = '" & vIsSuccess & "' WHERE temp_idx = '" & vIdx & "'"
	dbget.execute vQuery
Else
	vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] SET IsPay = 'N', PayResultCode = '" & vResult & "' WHERE temp_idx = '" & vIdx & "'"
	dbget.execute vQuery
End If

'' 결제 실패는 00이 아님 주석처리:2014/09/24
'If CStr(Trim(Split(arr(0),"=")(1))) <> CStr("00") Then
'	Response.write "<script language='javascript'>alert('이니시스에서 승인요청 결과 오류가 발생하였습니다. 고객센터로 문의해 주세요.');</script>"
'	dbget.close()
'	Response.End
'End IF

''2013/01/28 추가
if (vResult<>"ok") then
    Response.write "<script language='javascript'>alert('주문 처리 과정중 오류가 발생하였습니다. 고객센터로 문의해 주세요.');</script>"
	dbget.close()
	Response.End
end if

dim dumi : dumi=TenOrderSerialHash(vIOrder)

''비회원인 경우 orderserial-uk 값 저장. 2017/10/23 require commlib
IF (vIsSuccess="True") and (vUserID="") then
    Call fnUserLogCheck_AddGuestOrderserial_UK(vIOrder,request.Cookies("shoppingbag")("GSSN")) 
end if
%>

<%
	'//바이너리 데이터 TEXT형태로 변환
	Function  BinaryToText(BinaryData, CharSet)
		 Const adTypeText = 2
		 Const adTypeBinary = 1

		 Dim BinaryStream
		 Set BinaryStream = CreateObject("ADODB.Stream")

		'원본 데이터 타입
		 BinaryStream.Type = adTypeBinary

		 BinaryStream.Open
		 BinaryStream.Write BinaryData
		 ' binary -> text
		 BinaryStream.Position = 0
		 BinaryStream.Type = adTypeText

		' 변환할 데이터 캐릭터셋
		 BinaryStream.CharSet = CharSet

		'변환한 데이터 반환
		 BinaryToText = BinaryStream.ReadText

		 Set BinaryStream = Nothing
	End Function

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->

<script language="javascript">
    setTimeout(function(){
        try{
            window.location.replace("<%=wwwUrl&vAppLink%>/inipay/DisplayOrder.asp?dumi=<%=dumi%>");
        }catch(ss){
            location.href="<%=vAppLink%>/inipay/DisplayOrder.asp?dumi=<%=dumi%>";
        }
    },200);
	//document.location.href = "<%=wwwUrl&vAppLink%>/inipay/DisplayOrder.asp?dumi=<%=dumi%>";  //캐시 먹음. post or dumi
</script>
