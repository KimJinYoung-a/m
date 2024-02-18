<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<%
'###############################################
' Discription : 쿠폰 발급 처리
' History : 2017.09.27 허진원 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "application/json"

Dim idx, arridx, stype, arrstype, i,userid, oJson
idx = requestCheckVar(Request("idx"),120)
stype = requestCheckVar(Request("stype"),240)
arridx = split(idx,",")
arrstype = split(stype,",")
userid  = GetLoginUserID

'// json객체 선언
Set oJson = jsObject()

if userid="" THEN
	oJson("response") = "Error"
	oJson("message") = "로그인이 필요합니다."
	oJson.flush
	Set oJson = Nothing
	dbget.close()	:	response.End
End IF

IF idx = "" or stype = "" THEN
	oJson("response") = "Error"
	oJson("message") = "유입경로에 문제가 발생하였습니다."
	oJson.flush
	Set oJson = Nothing
	dbget.close()	:	response.End
END IF

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

'## 이벤트쿠폰 다운	함수
	Function fnSetEventCouponDown(ByVal userid, ByVal idx)
		dim sqlStr
		Dim objCmd
		Set objCmd = Server.CreateObject("ADODB.COMMAND")
		With objCmd
			.ActiveConnection = dbget
			.CommandType = adCmdText
			.CommandText = "{?= call [db_user].[dbo].sp_Ten_eventcoupon_down("&idx&",'"&userid&"')}"
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

'## 데이터 처리
	dim rvalue, oldrvalue
	'dbget.beginTrans

	For i = 0 To UBound(arridx)

		IF Cstr(arrstype(i)) = "event" THEN '이벤트함수일때 다운처리
			rvalue = fnSetEventCouponDown(userid,arridx(i))
		ELSEIF Cstr(arrstype(i)) = "evtsel" THEN '선택이벤트함수일때 다운처리
			rvalue = fnSetSelectCouponDown(userid,arridx(i))
		ELSEIF 	Cstr(arrstype(i)) = "prd" THEN '상품함수일때 다운처리
			rvalue = fnSetItemCouponDown(userid,arridx(i))
		END IF

		if rvalue = 0 then 	'문제 발생시 롤백처리
			exit for
		elseif rvalue = 1 then	'정상처리
			oldrvalue = 1
		elseif (rvalue = 2 or  rvalue = 3) then	'유효하지 않은 쿠폰또는 이미받은 쿠폰 제외하고 다른 쿠폰 다운처리
			if oldrvalue = 1 then 	rvalue = 1
		end if
	Next

	SELECT CASE  rvalue
		CASE 0
			'dbget.RollBackTrans
			oJson("response") = "Error"
			oJson("message") = "데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해주십시오"
		CASE 1
			'dbget.CommitTrans
			oJson("response") = "Ok"
			oJson("message") = "쿠폰이 발급되었습니다. 주문시 사용가능합니다."
		CASE 2
			'dbget.RollBackTrans
			oJson("response") = "Error"
			oJson("message") = "기간이 종료되었거나 유효하지 않은 쿠폰입니다."
		CASE 3
			'dbget.RollBackTrans
			oJson("response") = "Error"
			oJson("message") = "이미 다운로드 받으셨습니다."
	END SELECT

	'// 결과 출력
	oJson.flush
	Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
