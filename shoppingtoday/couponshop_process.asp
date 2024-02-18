<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->

<%
 Dim idx, arridx, stype, arrstype, i,userid , reval, pdiv, backurl
 idx = Request("idx")
 stype = Request("stype")
 reval = Request("reval")
 arridx = split(idx,",")
 arrstype = split(stype,",")
 userid  = GetLoginUserID
 pdiv = Request("pdiv")
IF idx = "" or stype = "" THEN
	Alert_return ("유입경로에 문제가 발생하였습니다. 관리자에게 문의해주십시오") 
	dbget.close()	:	response.End	
END IF	

'## 상품Secret 쿠폰(재구매쿠폰) 다운함수
	Function fnSetSecretItemCouponDown(ByVal userid, ByVal downidx, byref iexpdatetime)
		dim sqlStr
		Dim objCmd
		Set objCmd = Server.CreateObject("ADODB.COMMAND")
		With objCmd
			.ActiveConnection = dbget
			.CommandText = "[db_item].[dbo].[sp_Ten_itemcoupon_secretTarget_down]"
			.CommandType = adCmdStoredProc
			
			.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
			.Parameters.Append .CreateParameter("@downidx", adInteger, adParamInput, , downidx) 
			.Parameters.Append .CreateParameter("@userid", adVarchar, adParamInput, 32, userid) 
			.Parameters.Append .CreateParameter("@retExpireDT", adVarchar, adParamOutput, 19, "") 
			.Execute, , adExecuteNoRecords
			End With
		    fnSetSecretItemCouponDown = objCmd.Parameters("RETURN_VALUE").Value
			iexpdatetime = objCmd.Parameters("@retExpireDT").Value
			if isNULL(iexpdatetime) then iexpdatetime=""
		Set objCmd = Nothing
	END Function

'## 상품쿠폰 다운 함수
	Function fnSetItemCouponDown(ByVal userid, ByVal idx, byref iexpdatetime)
		dim sqlStr
		Dim objCmd
		Set objCmd = Server.CreateObject("ADODB.COMMAND")

		''신규방식 : expiredate를 표시하자. (네이버 쿠폰인경우 +6시간 정도.)
		objCmd.ActiveConnection = dbget
		objCmd.CommandText = "[db_item].[dbo].sp_Ten_itemcoupon_down_RetExpireDT"
		objCmd.CommandType = adCmdStoredProc
		objCmd.Parameters.Append objCmd.CreateParameter("returnValue", adInteger, adParamReturnValue)
		objCmd.Parameters.Append objCmd.CreateParameter("@itemcouponidx", adInteger, adParamInput, , idx) 
		objCmd.Parameters.Append objCmd.CreateParameter("@userid", adVarchar, adParamInput, 32, userid) 
		objCmd.Parameters.Append objCmd.CreateParameter("@retExpireDT", adVarchar, adParamOutput, 19, "") 
		objCmd.Execute
		fnSetItemCouponDown = objCmd.Parameters("returnValue").Value
		iexpdatetime = objCmd.Parameters("@retExpireDT").Value

		if isNULL(iexpdatetime) then iexpdatetime=""

		'' 기존방식
		' With objCmd
		' 	.ActiveConnection = dbget
		' 	.CommandType = adCmdText
		' 	.CommandText = "{?= call [db_item].[dbo].sp_Ten_itemcoupon_down("&idx&",'"&userid&"')}"
		' 	.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
		' 	.Execute, , adExecuteNoRecords
		' 	End With	
		'     fnSetItemCouponDown = objCmd(0).Value	
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

'## 여러 상품쿠폰 다운 함수
	Function fnSetItemCouponDownArray(ByVal userid, ByVal idxArr)
		dim sqlStr
		Dim objCmd
		Set objCmd = Server.CreateObject("ADODB.COMMAND")
		With objCmd
			.ActiveConnection = dbget
			.CommandType = adCmdText
			.CommandText = "{?= call [db_item].[dbo].sp_Ten_itemcoupon_down_Array('"&idxArr&"','"&userid&"')}"
			.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
			.Execute, , adExecuteNoRecords
			End With
		    fnSetItemCouponDownArray = objCmd(0).Value
		Set objCmd = Nothing
	END Function
	
'## 데이터 처리	
	dim rvalue, oldrvalue, iexpdateStr
	'dbget.beginTrans
	
	''----------------------------------------------------------------------------
	Dim isPrdCpnArrayLarge : isPrdCpnArrayLarge = false ''상품쿠폰이 많을경우
	Dim multiRetValue : multiRetValue = -1
	Dim prdCpnArrayString : prdCpnArrayString =""

	if UBound(arridx)>=20 then
		For i = 0 To UBound(arridx)
			if (arrstype(i)="prd") then
				prdCpnArrayString = prdCpnArrayString&arridx(i)&","
			end if
		Next
	end if

	if (prdCpnArrayString<>"") then
		isPrdCpnArrayLarge = true 
		if Right(prdCpnArrayString,1)="," then prdCpnArrayString=LEFT(prdCpnArrayString,LEN(prdCpnArrayString)-1)
		multiRetValue = fnSetItemCouponDownArray(userid,prdCpnArrayString)
	end if
	''----------------------------------------------------------------------------


	For i = 0 To UBound(arridx)
		IF Cstr(arrstype(i)) = "event" THEN '이벤트함수일때 다운처리
			rvalue = fnSetEventCouponDown(userid,arridx(i))
		ELSEIF Cstr(arrstype(i)) = "evtsel" THEN '선택이벤트함수일때 다운처리
			rvalue = fnSetSelectCouponDown(userid,arridx(i))
		ELSEIF 	Cstr(arrstype(i)) = "prd" THEN '상품함수일때 다운처리
			if (isPrdCpnArrayLarge) then
				rvalue = multiRetValue
			else
				rvalue = fnSetItemCouponDown(userid,arridx(i),iexpdateStr)
			end if

			if (iexpdateStr<>"") then
				iexpdateStr = replace(RIGHT(LEFT(iexpdateStr,13),8),"-","/")&"시 까지 사용가능한 "
			end if
		ELSEIF Cstr(arrstype(i)) = "prdsecret" THEN '상품secret쿠폰일때 다운처리
			rvalue = fnSetSecretItemCouponDown(userid,arridx(i),iexpdateStr)

			if (iexpdateStr<>"") then
				iexpdateStr = replace(RIGHT(LEFT(iexpdateStr,13),8),"-","/")&"시 까지 사용가능한 "
			end if
		END IF

		if rvalue = 0 then 	'문제 발생시 롤백처리
			exit for
		elseif rvalue = 1 then	'정상처리
			oldrvalue = 1
		elseif (rvalue = 2 or  rvalue = 3) then	'유효하지 않은 쿠폰또는 이미받은 쿠폰 제외하고 다른 쿠폰 다운처리
			if oldrvalue = 1 then 	rvalue = 1
		end if		
	Next
	
	if pdiv = "userinfo" then
		backurl = "/inipay/UserInfo.asp"
	else
		backurl = "/inipay/ShoppingBag.asp"
	end if

	SELECT CASE  rvalue 
		CASE 0	
			'dbget.RollBackTrans	  	
			If reval = "S" Then
			response.write  "<script>alert('데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해주십시오');self.location='" & backurl & "';</script>"
			else
			Alert_return ("데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해주십시오") 
			End If 
			dbget.close()	:	response.End			
		CASE 1
			'dbget.CommitTrans			
			If reval = "S" Then
			response.write  "<script>alert('쿠폰받기 완료! 결제 시 사용해주세요.');self.location='" & backurl & "';</script>"
			else
			Alert_return (""&iexpdateStr&" 쿠폰받기 완료! 결제 시 사용해주세요.")
			End If 
			dbget.close()	:	response.End
		CASE 2
			'dbget.RollBackTrans	 
			If reval = "S" Then
			response.write  "<script>alert('기간이 종료되었거나 유효하지 않은 쿠폰입니다.');self.location='" & backurl & "';</script>"
			else
			Alert_return ("기간이 종료되었거나 유효하지 않은 쿠폰입니다.") 
			End If 
			dbget.close()	:	response.End
		CASE 3
			'dbget.RollBackTrans	  
			If reval = "S" Then
			response.write  "<script>alert('이미 다운로드 받으셨습니다.');self.location='" & backurl & "';</script>"
			else
			Alert_return ("이미 다운로드 받으셨습니다.") 
			End If 
			dbget.close()	:	response.End		
	END SELECT
dbget.close()	:	response.End
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->

