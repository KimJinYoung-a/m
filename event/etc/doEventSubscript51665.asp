<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.contentType = "text/html; charset=UTF-8"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim eCode, com_egCode, bidx,Cidx
dim userid, txtcomm, txtcommURL, mode, spoint, usrname, usrphone, couponcode, rvalue, reval
mode=requestCheckVar(request.Form("mode"),4)
eCode =requestCheckVar(request.Form("eventid"),10)
couponcode =requestCheckVar(request.Form("cpcode"),10)
com_egCode=requestCheckVar(request.Form("com_egC"),10)
bidx = requestCheckVar(request.Form("bidx"),10)
Cidx = requestCheckVar(request.Form("Cidx"),10)
userid = GetLoginUserID
spoint = requestCheckVar(request.Form("spoint"),10)
txtcommURL = requestCheckVar(request.Form("txtcommURL"),128)
txtcommURL = html2db(txtcommURL)
usrname = requestCheckVar(request.Form("usrname"),20)
usrphone = requestCheckVar(request.Form("usrphone"),15)


IF spoint = "" THEN spoint = 0
IF bidx = "" THEN bidx = 0
IF com_egCode = "" THEN com_egCode = 0

dim referer,refip, returnurl
referer = request.ServerVariables("HTTP_REFERER")
refip = request.ServerVariables("REMOTE_ADDR")
returnurl = requestCheckVar(request.Form("returnurl"),100)

Dim vGubun
vGubun = requestCheckVar(request.Form("gubun"),10)

dim sqlStr, returnValue
Dim objCmd
Set objCmd = Server.CreateObject("ADODB.COMMAND")
if mode="add" then

	txtcomm = request.Form("txtcomm")

	if checkNotValidTxt(txtcomm) then
		Alert_move "내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.","about:blank"
		dbget.close()	:	response.End
	end if
	txtcomm = html2db(txtcomm)


	If userid <> "" Then
		strSql = ""
		strSql = strSql & "select count(*) as cnt from " & vbcrlf
		strSql = strSql & "db_etcmall.dbo.tbl_between_event_comment " & vbcrlf
		strSql = strSql & "where evt_code='"&eCode&"' " & vbcrlf
		strSql = strSql & "and userid = '"&userid&"' and evtcom_using = 'Y' " & vbcrlf
		rsget.Open strSql, dbget, 1
		If rsget("cnt") >= 3 Then
			Response.Write  "<script language='javascript'>" &_
							"	alert('ID당 3회 응모 가능합니다');" &_
							"</script>"
			response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
			dbget.close()	:	response.End
		ELSE

			'// 쿠폰발급
			rvalue = fnSetEventCouponDown(userid,couponcode)

			SELECT CASE  rvalue 
				CASE 0	
					'dbget.RollBackTrans	  	
					If reval = "S" Then
					response.write  "<script>alert('데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해주십시오');history.back();</script>"
					else
					Alert_return ("데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해주십시오") 
					End If 
				CASE 1
					'dbget.CommitTrans			
					If reval = "S" Then
'					response.write  "<script>alert('쿠폰이 발급되었습니다.\nMy10x10에서 확인이 가능하며 주문시 사용하실 수 있습니다.');self.location='/inipay/ShoppingBag.asp';</script>"
					else
'					Alert_return ("쿠폰이 발급되었습니다.\nMy10x10에서 확인이 가능하며 주문시 사용하실 수 있습니다.")
					End If 
				CASE 2
					'dbget.RollBackTrans	 
					If reval = "S" Then
					response.write  "<script>alert('기간이 종료되었거나 유효하지 않은 쿠폰입니다.');history.back();</script>"
					else
					Alert_return ("기간이 종료되었거나 유효하지 않은 쿠폰입니다.") 
					End If 
				CASE 3
					'dbget.RollBackTrans	  
					If reval = "S" Then
'					response.write  "<script>alert('이미 쿠폰을 받으셨습니다.');self.location='/inipay/ShoppingBag.asp';</script>"
					else
'					Alert_return ("이미 쿠폰을 받으셨습니다.") 
					End If 
			END SELECT
			

			strSql = ""
			strSql = strSql & "INSERT INTO [db_etcmall].[dbo].[tbl_between_event_comment] (evt_code,evtgroup_code, userid, evtcom_txt, evtcom_point, evtbbs_idx, refip, blogurl, device, username, userphone)"
			strSql = strSql & "VALUES ("&eCode&","&com_egCode&",'"&userid&"','"&txtcomm&"',"&spoint&","&bidx&",'"&refip&"','"&txtcommURL&"','M','"&usrname&"','"&usrphone&"')"
			dbget.execute strSql
			response.write "<script>alert('응모 완료되었습니다.\n당첨자 발표는 5/29이며, 당첨자 확인은\n비트윈 기프트샵 공지사항에서 가능합니다.');location.replace('" + Cstr(referer) + "');</script>"
			dbget.close()	:	response.End
		End If
	Else
		strSql = ""
		strSql = strSql & "INSERT INTO [db_etcmall].[dbo].[tbl_between_event_comment] (evt_code,evtgroup_code, userid, evtcom_txt, evtcom_point, evtbbs_idx, refip, blogurl, device, username, userphone)"
		strSql = strSql & "VALUES ("&eCode&","&com_egCode&",'"&userid&"','"&txtcomm&"',"&spoint&","&bidx&",'"&refip&"','"&txtcommURL&"','M','"&usrname&"','"&usrphone&"')"
		dbget.execute strSql
		response.write "<script>alert('응모 완료되었습니다.\n당첨자 발표는 5/29이며, 당첨자 확인은\n비트윈 기프트샵 공지사항에서 가능합니다.');location.replace('" + Cstr(referer) + "');</script>"
		dbget.close()	:	response.End
	End If


elseif mode="del" Then
	Cidx=requestCheckVar(request.Form("Cidx"),10)

		With objCmd
		.ActiveConnection = dbget
		.CommandType = adCmdText
		.CommandText = "{?= call [db_etcmall].[dbo].sp_Between_event_comment_delete ("&Cidx&",'"&userid&"',"&bidx&","&com_egCode&")}"
		.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
		.Execute, , adExecuteNoRecords
		End With
	    returnValue = objCmd(0).Value
	Set objCmd = Nothing

   IF returnValue = 1 THEN
		response.redirect(referer)
		dbget.close()	:	response.End
   ELSE
     response.write "<script>alert('데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해 주십시오.');</script>"
	 response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
	 dbget.close()	:	response.End
   END IF

elseif mode="edit" then
	Cidx=requestCheckVar(request.Form("Cidx"),10)

	If vGubun = "red" Then
		txtcomm = request.Form("txtcomm_top") & "|^!1!0x1!0!W!k!d!^|" & request.Form("txtcomm")
	Else
		txtcomm = request.Form("txtcomm")
	End If

	Dim strSql
	strSql ="[db_event].[dbo].sp_Ten_event_comment_update ('U','"&userid&"','"&Cidx&"','"&txtcomm&"','"&txtcommURL&"','"&spoint&"')"
	rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			returnValue = rsget(0)
		ELSE
			returnValue = null
		END IF
	rsget.close

   IF returnValue = 1 THEN
   		If returnurl <> "" Then
   			referer = returnurl
		End If
	response.redirect(referer)
	dbget.close()	:	response.End
   ELSE
     response.write "<script>alert('데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해 주십시오.');</script>"
	 response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
	 dbget.close()	:	response.End
   END IF

end if


Function fnSetEventCouponDown(ByVal userid, ByVal idx)
	dim sqlStr
	Dim objCmd
	Set objCmd = Server.CreateObject("ADODB.COMMAND")
	With objCmd
		.ActiveConnection = dbget
		.CommandType = adCmdText
		.CommandText = "{?= call [db_etcmall].[dbo].[sp_Ten_Between_mobile_eventcoupon_down]("&idx&",'"&userid&"')}"
		.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
		.Execute, , adExecuteNoRecords
		End With	
		fnSetEventCouponDown = objCmd(0).Value	
	Set objCmd = Nothing	
END Function	

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->