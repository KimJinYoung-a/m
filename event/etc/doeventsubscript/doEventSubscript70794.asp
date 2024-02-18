<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 방가방가 첫 구매! 처리 MA
' History : 2016.03.11 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
Dim mode, sqlstr, rvalue, cLayerValue, device
mode	= requestcheckvar(request("mode"),32)
isapp	= requestcheckvar(request("isapp"),1)

Dim eCode, userid, currenttime, i, couponidx
If application("Svr_Info") = "Dev" Then
	eCode		= "66133"
	couponidx	= "11135"
Else
	eCode		= "70794"
	couponidx	= "11649"
End If

If isapp = 1 Then
	device = "A"
Else
	device = "M"
End If

currenttime	= now()
userid		= GetEncLoginUserID()

Dim subscriptcount, itemcouponcount
subscriptcount	= 0
itemcouponcount	= 0

'response.write GetUserStrlarge(GetLoginUserLevel) & "/" & GetLoginUserLevel
Dim administrator
	administrator = FALSE

If GetLoginUserID = "greenteenz" or GetLoginUserID = "djjung" or GetLoginUserID = "bborami" or GetLoginUserID = "kyungae13" or GetLoginUserID = "jinyeonmi" or GetLoginUserID = "thensi7" or GetLoginUserID = "baboytw" or GetLoginUserID = "kobula" or GetLoginUserID = "kjy8517" Then
	administrator = TRUE
End If

Dim refer
refer = request.ServerVariables("HTTP_REFERER")

If InStr(refer,"10x10.co.kr") < 1 Then
	Response.Write "01||잘못된 접속입니다."
	dbget.close() : Response.End
End If

If mode="coupondown" Then
	If userid = "" Then
		Response.Write "02||로그인을 해주세요."
		dbget.close() : Response.End
	End IF
	If not( left(currenttime,10)>="2016-05-18" and left(currenttime,10)<"2016-05-30" ) Then
		Response.Write "03||이벤트 응모 기간이 아닙니다."
		dbget.close() : Response.End
	End IF

	'//본인 참여 여부
	If userid <> "" Then
		subscriptcount	= getevent_subscriptexistscount(eCode, userid, "", "", "")
		itemcouponcount = getitemcouponexistscount(userid, couponidx, "", "")
	End If

	'//결과페이지 만듬
	cLayerValue = ""
	cLayerValue = cLayerValue & " <a href='' onclick='goDirOrdItem();return false;'> "
	if subscriptcount>0 or itemcouponcount>0 then
		''// <!-- 이미 발급 받은 경우 -->
		cLayerValue = cLayerValue & " <p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70794/m/txt_coupon_02_v1.png' alt='이미 쿠폰이 발급 되었습니다. 구매하러 가기! 마이 텐바이텐의 쿠폰/상품 쿠폰에서 확인하세요! 상품 쿠폰은 하나의 주문 건에서 중복 사용이 불가합니다!' /></p> "
	Else
		cLayerValue = cLayerValue & " <p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70794/m/txt_coupon_01_v1.png' alt='쿠폰이 발급 되었습니다. 구매하러 가기! 마이 텐바이텐의 쿠폰/상품 쿠폰에서 확인하세요! 상품 쿠폰은 하나의 주문 건에서 중복 사용이 불가합니다!' /></p> "
	End If
	cLayerValue = cLayerValue & " </a> "
	cLayerValue = cLayerValue & " <button type='button' class='btnClose' onclick='poplayerclose();return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2016/70794/m/btn_close.png' alt='레이어팝업 닫기' /></button> "
	If subscriptcount > 0 or itemcouponcount > 0 Then
		Response.Write "04||"&cLayerValue		''이미 쿠폰이 발급 되었습니다
		dbget.close() : Response.End
	End If
	If GetLoginUserLevel <> "5" and not(administrator) Then
		Response.Write "05||고객님은 쿠폰발급 대상이 아닙니다."
		dbget.close() : Response.End
	End If

	rvalue = fnSetItemCouponDown(userid, couponidx)
	SELECT CASE  rvalue 
		CASE 0
			Response.Write "07||데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해주십시오."
			dbget.close() : Response.End		
		CASE 1
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& left(currenttime,10) &"', 1, '', '" & device & "')" + vbcrlf
			dbget.execute sqlstr

			Response.Write "11||"&cLayerValue		''응모 및 쿠폰 발급
			dbget.close() : Response.End
		CASE 2
			Response.Write "08||기간이 종료되었거나 유효하지 않은 쿠폰입니다."
			dbget.close() : Response.End
		CASE 3
			Response.Write "09||"&cLayerValue
			dbget.close() : Response.End
		case else
			Response.Write "10||데이터 처리에 예외 상황이 발생하였습니다. 관리자에게 문의해주십시오."
			dbget.close() : Response.End
	END SELECT

Else
	Response.Write "00||정상적인 경로가 아닙니다."
	dbget.close() : Response.End
end if

''## 상품쿠폰 다운 함수
Function fnSetItemCouponDown(ByVal userid, ByVal idx)
	dim sqlStr
	Dim objCmd
	Set objCmd = Server.CreateObject("ADODB.COMMAND")
	With objCmd
		.ActiveConnection = dbget
		.CommandType = adCmdText
		.CommandText = "{?= call [db_item].[dbo].sp_Ten_itemcoupon_down("&idx&",'"&userid&"')}"
		.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
		.Execute, , adExecuteNoRecords
		End With	
	    fnSetItemCouponDown = objCmd(0).Value	
	Set objCmd = Nothing	
END Function
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->


