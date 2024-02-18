<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/apps/appcom/wish/webview/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->

<%
Dim idx, arridx, stype, arrstype, i,userid , reval
	idx = Request("idx")
	stype = Request("stype")
	reval = Request("reval")
	arridx = split(idx,",")
	arrstype = split(stype,",")
	userid  = GetLoginUserID

IF idx = "" or stype = "" THEN
	Alert_return ("유입경로에 문제가 발생하였습니다. 관리자에게 문의해주십시오") 
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
			.CommandText = "{?= call [db_user].[dbo].[sp_Ten_mobile_eventcoupon_down]("&idx&",'"&userid&"')}"
			.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
			.Execute, , adExecuteNoRecords
			End With	
		    fnSetEventCouponDown = objCmd(0).Value	
		Set objCmd = Nothing	
	END Function	

'## 데이터 처리	
	dim rvalue, oldrvalue
	'dbget.beginTrans
	
	For i = 0 To UBound(arridx)
		IF Cstr(arrstype(i)) = "event" THEN '이벤트함수일때 다운처리
			rvalue = fnSetEventCouponDown(userid,arridx(i))
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
			If reval = "S" Then
			response.write  "<script>alert('데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해주십시오');self.location='/apps/appCom/wish/webview/inipay/ShoppingBag.asp';</script>"
			else
			Alert_return ("데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해주십시오") 
			End If 
			dbget.close()	:	response.End			
		CASE 1
			'dbget.CommitTrans			
			If reval = "S" Then
			response.write  "<script>alert('쿠폰이 발급되었습니다.\nMy10x10에서 확인이 가능하며 주문시 사용하실 수 있습니다.');self.location='/apps/appCom/wish/webview/inipay/ShoppingBag.asp';</script>"
			else
			Alert_return ("쿠폰이 발급되었습니다.\nMy10x10에서 확인이 가능하며 주문시 사용하실 수 있습니다.")
			End If 
			dbget.close()	:	response.End
		CASE 2
			'dbget.RollBackTrans	 
			If reval = "S" Then
			response.write  "<script>alert('기간이 종료되었거나 유효하지 않은 쿠폰입니다.');self.location='/apps/appCom/wish/webview/inipay/ShoppingBag.asp';</script>"
			else
			Alert_return ("기간이 종료되었거나 유효하지 않은 쿠폰입니다.") 
			End If 
			dbget.close()	:	response.End
		CASE 3
			'dbget.RollBackTrans	  
			If reval = "S" Then
			response.write  "<script>alert('이미 쿠폰을 받으셨습니다.');self.location='/apps/appCom/wish/webview/inipay/ShoppingBag.asp';</script>"
			else
			Alert_return ("이미 쿠폰을 받으셨습니다.") 
			End If 
			dbget.close()	:	response.End		
	END SELECT
dbget.close()	:	response.End
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->

