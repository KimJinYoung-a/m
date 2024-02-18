<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description : 쿠폰이벤트용 처리페이지
' History : 2016-05-17 유태욱
'####################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->

<%
Dim sub_opt1, sub_opt2, sub_opt3, strSql
Dim idx, arridx, stype, arrstype, i, userid, mode, reval, eCode
	sub_opt2 = 0
	idx = Request("idx")			'쿠폰 idx
	stype = Request("stype")	'발급 종류
	reval = Request("reval")
	mode = requestcheckvar(request("mode"),32)
	eCode = requestcheckvar(request("eCode"),32)
	sub_opt1 = requestcheckvar(request("sub_opt1"),32)
	sub_opt2 = requestcheckvar(request("sub_opt2"),32)
	sub_opt3 = requestcheckvar(request("sub_opt3"),32)
	arridx = split(idx,",")
	arrstype = split(stype,",")
	userid  = GetencLoginUserID

IF idx = "" or stype = "" THEN
	Response.Write "01||유입경로에 문제가 발생하였습니다. 관리자에게 문의해주십시오"
	dbget.close() : Response.End
END IF

'// 로그인 여부 체크
If Not(IsUserLoginOK) Then
	Response.Write "02|로그인 후 참여하실 수 있습니다."
	response.End
End If

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

'## 이벤트쿠폰 다운	함수(전체고객,중복발급 가능)
	Function fnSetEventCouponDown(ByVal userid, ByVal idx)
		dim sqlStr
		Dim objCmd
		Set objCmd = Server.CreateObject("ADODB.COMMAND")
		With objCmd
			.ActiveConnection = dbget
			.CommandType = adCmdText
			.CommandText = "{?= call [db_user].[dbo].[sp_Ten_mobile_eventcoupon_down]("&idx&",'"&userid&"')}"
			.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
			.Execute, , adExecuteNoRecords
			End With	
		    fnSetEventCouponDown = objCmd(0).Value	
		Set objCmd = Nothing	
	END Function	

'## 이벤트쿠폰 다운	함수(선택고객,중복발급 불가)
	Function fnSetSelectCouponDown(ByVal userid, ByVal idx)
		dim sqlStr
		Dim objCmd
		Set objCmd = Server.CreateObject("ADODB.COMMAND")
		With objCmd
			.ActiveConnection = dbget
			.CommandType = adCmdText
			.CommandText = "{?= call [db_user].[dbo].sp_Ten_eventcoupon_down_selected("&idx&",'"&userid&"')}"
			.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
			.Execute, , adExecuteNoRecords
			End With
		    fnSetSelectCouponDown = objCmd(0).Value
		Set objCmd = Nothing
	END Function

'## 이벤트쿠폰 다운	함수(선택고객,중복발급 불가)
	Function fnSetSelectTodayCouponDown(ByVal userid, ByVal idx)
		dim sqlStr
		Dim objCmd
		Set objCmd = Server.CreateObject("ADODB.COMMAND")
		With objCmd
			.ActiveConnection = dbget
			.CommandType = adCmdText
			.CommandText = "{?= call [db_user].[dbo].sp_Ten_eventcoupon_down_selected_today("&idx&",'"&userid&"')}"
			.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
			.Execute, , adExecuteNoRecords
			End With
		    fnSetSelectTodayCouponDown = objCmd(0).Value
		Set objCmd = Nothing
	END Function

'## 이벤트쿠폰 다운	함수(선택고객,중복발급 불가 + 발행 24시간이내)
	Function fnSetSelect24HourCouponDown(ByVal userid, ByVal idx)
		dim sqlStr
		Dim objCmd
		Set objCmd = Server.CreateObject("ADODB.COMMAND")
		With objCmd
			.ActiveConnection = dbget
			.CommandType = adCmdText
			.CommandText = "{?= call [db_user].[dbo].[usp_Ten_EventCoupondown_Selected_Limit24Hour]("&idx&",'"&userid&"')}"
			.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
			.Execute, , adExecuteNoRecords
			End With
		    fnSetSelect24HourCouponDown = objCmd(0).Value
		Set objCmd = Nothing
	END Function

'## 이벤트 쿠폰 다운 로그 - app 쿠폰만
	Function fncheckcoupondownlog(ByVal evt_code ,  ByVal device)
		dim sqlStr
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& evt_code &",'" & userid & "','"& device &"')" + vbcrlf
		dbget.execute sqlstr
	End Function

	Function fnSetMonthlyCouponDown(ByVal userid, ByVal idx)
		dim sqlStr
		Dim objCmd
		Set objCmd = Server.CreateObject("ADODB.COMMAND")
		With objCmd
			.ActiveConnection = dbget
			.CommandType = adCmdText
			.CommandText = "{?= call [db_user].[dbo].sp_Ten_monthlycoupon_down_selected("&idx&",'"&userid&"')}"
			.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
			.Execute, , adExecuteNoRecords
			End With
		    fnSetMonthlyCouponDown = objCmd(0).Value
		Set objCmd = Nothing
	END Function

if mode = "cpok" then
	'## 데이터 처리
		dim rvalue, oldrvalue
		dbget.beginTrans
	
		For i = 0 To UBound(arridx)
	
			IF Cstr(arrstype(i)) = "event" THEN '이벤트함수일때 다운처리
				rvalue = fnSetEventCouponDown(userid,arridx(i))
			ELSEIF Cstr(arrstype(i)) = "evtsel" THEN '선택이벤트함수일때 다운처리
				rvalue = fnSetSelectCouponDown(userid,arridx(i))
			ELSEIF Cstr(arrstype(i)) = "evttosel" THEN '선택이벤트함수일때 다운처리
				rvalue = fnSetSelectTodayCouponDown(userid,arridx(i))
			ELSEIF Cstr(arrstype(i)) = "evttosel24" THEN '선택이벤트함수일때 다운처리
				rvalue = fnSetSelect24HourCouponDown(userid,arridx(i))
			ELSEIF 	Cstr(arrstype(i)) = "prd" THEN '상품함수일때 다운처리
				rvalue = fnSetItemCouponDown(userid,arridx(i))
			ELSEIF 	Cstr(arrstype(i)) = "month" THEN '월쿠폰 다운
				rvalue = fnSetMonthlyCouponDown(userid,arridx(i))
			END IF
	
			if rvalue = 0 then 	'문제 발생시 롤백처리
				exit for
			elseif rvalue = 1 then	'정상처리
				If idx = "1028" Then '// 쿠폰다운용 로그
					Call fncheckcoupondownlog("83960",chkiif(isapp,"A","M"))
				End If
				oldrvalue = 1
			elseif (rvalue = 2 or  rvalue = 3) then	'유효하지 않은 쿠폰또는 이미받은 쿠폰 제외하고 다른 쿠폰 다운처리
				if oldrvalue = 1 then 	rvalue = 1
			end if
		Next

		SELECT CASE  rvalue
			CASE 0
				dbget.RollBackTrans
				Response.Write "00||정상적인 경로가 아닙니다."
				dbget.close() : Response.End	
			CASE 1
				dbget.CommitTrans
				Response.Write "11||쿠폰이 발급되었습니다."
				dbget.close() : Response.End				
			CASE 2
				dbget.RollBackTrans
				Response.Write "12||기간이 종료되었거나 유효하지 않은 쿠폰입니다."
				dbget.close() : Response.End
			CASE 3
				dbget.RollBackTrans
				Response.Write "13||이미 쿠폰을 받으셨습니다."
				dbget.close() : Response.End
		END SELECT
	dbget.close()	:	response.End
else
	Response.Write "00||정상적인 경로가 아닙니다."
	dbget.close() : Response.End	
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
