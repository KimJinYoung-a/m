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
<!-- #include virtual="/inipay/naverpay/incNaverpayCommon.asp"-->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/lib/util/rndSerial.asp" -->
<!-- #include virtual="/inipay/common/orderTempFunction.asp" -->
<%
'response.write "<script>alert('죄송합니다. 네이버페이 결제 잠시 점검중입니다.');history.back();</script>"
'response.end


Dim vQuery, vQuery1
Dim sqlStr

'// 앱일경우엔 앱경로 넣어준다.
If isApp="1" Then
	wwwUrl = wwwUrl&"/apps/appCom/wish/web2014/"
End If


Dim vIDx, iErrMsg, ipgGubun
Dim irefPgParam   '' 결제 예약시 필요한 값들.
ipgGubun = "NP"
vIdx 	= ""

vIDx = fnSaveOrderTemp("NP_" & NPay_PartnerID, iErrMsg, ipgGubun, irefPgParam)  '' order_temp 임시저장

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
Dim NPay_ReserveId			'결제예약 ID
''### 1. 네이버페이 결제예약 (임시주문번호, 상품명, 상품수, 결제금액, 과세금액, 배송비, 주문자)
NPay_ReserveId = fnCallNaverPayReserve(vIdx,irefPgParam.Fgoodname,irefPgParam.Fgoodcnt,irefPgParam.FPrice,irefPgParam.FPrice,irefPgParam.FDlvPrice,irefPgParam.FBuyname)

if left(NPay_ReserveId,4)="ERR:" then
	response.write "<script>alert('처리중 오류가 발생했습니다.\n(" & right(NPay_ReserveId,len(NPay_ReserveId)-4) & ")')</script>"
	response.write "<script>location.replace('" & wwwUrl & "/inipay/shoppingbag.asp')</script>"
	response.end
end if

'예약 번호 저장
sqlStr = "UPDATE [db_order].[dbo].[tbl_order_temp] "
sqlStr = sqlStr & " SET P_RMESG2 = '" & NPay_ReserveId & "'" & VbCRLF
sqlStr = sqlStr & " WHERE temp_idx = '" & vIdx & "'"
dbget.execute sqlStr

SET irefPgParam = Nothing

''### 2. 결제 화면 호출
Response.Redirect NPay_SvcMobile_URL & "/payments/" & NPay_ReserveId
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->