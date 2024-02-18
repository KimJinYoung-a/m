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
' Description : 오렌지족
' History : 2016.01.14 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim mode, sqlstr, rvalue
	mode = requestcheckvar(request("mode"),32)
	isapp = requestcheckvar(request("isapp"),1)

dim eCode, userid, currenttime, i
	IF application("Svr_Info") = "Dev" THEN
		eCode = "66002"
	Else
		eCode = "68588"
	End If

currenttime = now()
'currenttime = #01/18/2016 10:05:00#

userid = GetEncLoginUserID()

dim couponidx
	IF application("Svr_Info") = "Dev" THEN
		couponidx = "11116"
	Else
		couponidx = "11429"
	End If

dim subscriptcount, itemcouponcount
subscriptcount=0
itemcouponcount=0

'response.write GetUserStrlarge(GetLoginUserLevel) & "/" & GetLoginUserLevel

dim administrator
	administrator=FALSE

if GetLoginUserID="greenteenz" or GetLoginUserID="djjung" or GetLoginUserID="bborami" or GetLoginUserID="kyungae13" or GetLoginUserID="tozzinet" then
	administrator=TRUE
end if

dim refer
	refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "01||잘못된 접속입니다."
	dbget.close() : Response.End
end If

if mode="coupondown" then
	If userid = "" Then
		Response.Write "02||로그인을 해주세요."
		dbget.close() : Response.End
	End IF
	If not( left(currenttime,10)>="2016-01-18" and left(currenttime,10)<"2016-01-23" ) Then
		Response.Write "03||이벤트 응모 기간이 아닙니다."
		dbget.close() : Response.End
	End IF

	'//본인 참여 여부
	if userid<>"" then
		subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
		itemcouponcount = getitemcouponexistscount(userid, couponidx, "", "")
	end if

	if subscriptcount>0 or itemcouponcount>0 then
		Response.Write "04||한 개의 아이디당 한 번만 응모가 가능 합니다."
		dbget.close() : Response.End
	end if
	if GetLoginUserLevel<>"5" and not(administrator) then
		Response.Write "05||고객님은 쿠폰발급 대상이 아닙니다."
		dbget.close() : Response.End
	end if
	if Hour(currenttime) < 10 then
		Response.Write "06||쿠폰은 오전 10시부터 다운 받으실수 있습니다."
		dbget.close() : Response.End
	end if

	rvalue = fnSetItemCouponDown(userid, couponidx)
	SELECT CASE  rvalue 
		CASE 0
			Response.Write "07||데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해주십시오."
			dbget.close() : Response.End		
		CASE 1
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
			
			if isApp="1" then
				sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& left(currenttime,10) &"', 1, '', 'A')" + vbcrlf
			else
				sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& left(currenttime,10) &"', 1, '', 'M')" + vbcrlf
			end if
		
			'response.write sqlstr & "<Br>"
			dbget.execute sqlstr

			Response.Write "11||쿠폰이 발급되었습니다.\nMy10x10에서 확인이 가능하며 주문시 사용하실 수 있습니다."
			dbget.close() : Response.End
		CASE 2
			Response.Write "08||기간이 종료되었거나 유효하지 않은 쿠폰입니다."
			dbget.close() : Response.End
		CASE 3
			Response.Write "09||이미 쿠폰을 받으셨습니다."
			dbget.close() : Response.End
		case else
			Response.Write "10||데이터 처리에 예외 상황이 발생하였습니다. 관리자에게 문의해주십시오."
			dbget.close() : Response.End
	END SELECT

Else
	Response.Write "00||정상적인 경로가 아닙니다."
	dbget.close() : Response.End
end if

'## 상품쿠폰 다운 함수
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
