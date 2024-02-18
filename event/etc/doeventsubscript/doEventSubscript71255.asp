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
' Description : 플레이, 첫 구매! MA
' History : 2016-06-16 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim mode, sqlstr, rvalue, cLayerValue, device
	mode = requestcheckvar(request("mode"),32)
	isapp = requestcheckvar(request("isapp"),1)

dim eCode, userid, currenttime, i
	IF application("Svr_Info") = "Dev" THEN
		eCode = "66154"
	Else
		eCode = "71255"
	End If

	if isapp = 1 then
		device = "A"
	else
		device = "M"
	end if

currenttime = now()
'															currenttime = #03/14/2016 10:05:00#

userid = GetEncLoginUserID()

dim couponidx
	IF application("Svr_Info") = "Dev" THEN
		couponidx = "10104"
	Else
		'couponidx = "11715"
		couponidx = "11848"
	End If

dim subscriptcount, itemcouponcount
subscriptcount=0
itemcouponcount=0

'response.write GetUserStrlarge(GetLoginUserLevel) & "/" & GetLoginUserLevel

dim administrator
	administrator=FALSE

if GetLoginUserID="greenteenz" or GetLoginUserID="djjung" or GetLoginUserID="okkang77" or GetLoginUserID="kyungae13" or GetLoginUserID="tozzinet" or GetLoginUserID="thensi7" or GetLoginUserID="baboytw" or GetLoginUserID="motions" then
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
	If Now() > #08/15/2016 23:59:59# Then
		Response.Write "03||이벤트 응모 기간이 아닙니다."
		dbget.close() : Response.End
	End IF

	''// 3월 14일만 오전 10시부터 응모 가능함 그다음은 0시부터 응모가능
'	If Left(currenttime, 10) = "2016-03-14" Then
'		If Not(TimeSerial(Hour(currenttime), minute(currenttime), second(currenttime)) >= TimeSerial(10, 00, 00) And TimeSerial(Hour(currenttime), minute(currenttime), second(currenttime)) < TimeSerial(23, 59, 59)) Then
'			Response.Write "12||오전 10시부터 응모하실 수 있습니다."
'			dbget.close() : Response.End
'		End If
'	End If

	'//본인 참여 여부
	if userid<>"" then
		subscriptcount = getevent_subscriptexistscount11(eCode, userid, "", "", "")
		itemcouponcount = getitemcouponexistscount(userid, couponidx, "", "")
	end if

	'//결과페이지 만듬
	cLayerValue = ""
	cLayerValue = cLayerValue & " <div class='layerCont'> "
	cLayerValue = cLayerValue & " <a href='' onclick='goDirOrdItem();return false;'> "
	if subscriptcount>0 or itemcouponcount>0 then
		''// <!-- 이미 발급 받은 경우 -->
		cLayerValue = cLayerValue & " <img src='http://webimage.10x10.co.kr/eventIMG/2016/71225/m/img_layer_buy_02a.png' alt='이미 쿠폰이 발급되었습니다' />"
	Else
		cLayerValue = cLayerValue & " <img src='http://webimage.10x10.co.kr/eventIMG/2016/71225/m/img_layer_buy_01a.png' alt='쿠폰이 발급되었습니다' />"
	End If
	cLayerValue = cLayerValue & " </a>"
	cLayerValue = cLayerValue & " <button class='btnClose' onclick='poplayerclose();return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71225/m/btn_close.png' alt='닫기' /></button> "
	cLayerValue = cLayerValue & " </div>"

	if subscriptcount>0 or itemcouponcount>0 Then
		Response.Write "04||"&cLayerValue		''이미 쿠폰이 발급 되었습니다
		dbget.close() : Response.End
	end if
	if GetLoginUserLevel<>"5" and not(administrator) then
		Response.Write "05||고객님은 쿠폰발급 대상이 아닙니다."
		dbget.close() : Response.End
	end If

	rvalue = fnSetItemCouponDown(userid, couponidx)
	SELECT CASE  rvalue 
		CASE 0
			Response.Write "07||데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해주십시오."
			dbget.close() : Response.End		
		CASE 1
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& left(currenttime,10) &"', 1, '', '" & device & "')" + vbcrlf

			'response.write sqlstr & "<Br>"
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


function getevent_subscriptexistscount11(evt_code, userid, sub_opt1, sub_opt2, sub_opt3)
	dim sqlstr, tmevent_subscriptexistscount
	
	if evt_code="" or userid="" then
		getevent_subscriptexistscount11=99999
		exit function
	end if
	
	sqlstr = "select count(*) as cnt"
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript] sc"
	sqlstr = sqlstr & " where sc.sub_idx > '8003642' and sc.evt_code="& evt_code &""
	sqlstr = sqlstr & " and sc.userid='"& userid &"'"
	
	if sub_opt1<>"" then
		sqlstr = sqlstr & " and isnull(sc.sub_opt1,'') = '"& sub_opt1 &"'"
	end if
	if sub_opt2<>"" then
		sqlstr = sqlstr & " and isnull(sc.sub_opt2,'') = '"& sub_opt2 &"'"
	end if
	if sub_opt3<>"" then
		sqlstr = sqlstr & " and isnull(sc.sub_opt3,'') = '"& sub_opt3 &"'"
	end if
	
	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		tmevent_subscriptexistscount = rsget("cnt")
	END IF
	rsget.close
	
	getevent_subscriptexistscount11 = tmevent_subscriptexistscount
end function
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->


