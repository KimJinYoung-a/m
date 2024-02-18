<%@ language=vbscript %>
<% option Explicit %>
<% Response.CharSet = "euc-kr" %>
<%
'###########################################################
' Description :  크리스마스 이벤트
' History : 2014.11.26 한용민 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/event/etc/event57480Cls.asp" -->
<%
dim mode, eCode, userid, txtcomm, com_egCode, bidx, spoint, txtcommURL, Cidx, evtcom_idx, dispcodeeCode
	mode = requestcheckvar(request("mode"),32)
	txtcomm = request("txtcomm")
	com_egCode=requestCheckVar(request("com_egC"),10)
	bidx = requestCheckVar(request("bidx"),10)
	spoint = requestCheckVar(request("spoint"),10)
	txtcommURL = requestCheckVar(request("SelCrdPic"),128)
	Cidx=requestCheckVar(request("Cidx"),10)
'	txtcommURL = html2db(txtcommURL)
	userid = getloginuserid()

eCode   =  getevt_code()
dispcodeeCode = getevt_dispcode
	
IF bidx = "" THEN bidx = 0
IF com_egCode = "" THEN com_egCode = 0
IF spoint = "" THEN spoint = 0

dim commentexistscount, kakaotalksubscriptcount
commentexistscount=0
kakaotalksubscriptcount=0

dim referer
referer = request.ServerVariables("HTTP_REFERER")
if InStr(referer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

dim refip
refip = request.ServerVariables("REMOTE_ADDR")

dim sqlStr, returnValue, objCmd

If userid = "" Then
	Response.Write "99"
	dbget.close() : Response.End
End IF
If not( getnowdate>="2014-12-08" and getnowdate<"2014-12-31") Then
	Response.Write "02"
	dbget.close() : Response.End
End IF

if mode="add" then
	'// 본인 응모수
	commentexistscount=getcommentexistscount(userid, eCode, "", "", "", "Y")
	if commentexistscount>=5 then
		Response.Write "06"
		dbget.close() : Response.End
	end if
	
	Set objCmd = Server.CreateObject("ADODB.COMMAND")
		if checkNotValidTxt(txtcomm) then
			'Alert_move "내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.","about:blank"
			response.write "03"
			dbget.close()	:	response.End
		end if
		txtcomm = html2db(txtcomm)

		With objCmd
		.ActiveConnection = dbget
		.CommandType = adCmdText
		.CommandText = "{?= call [db_event].[dbo].sp_Ten_event_comment_insert("&eCode&","&com_egCode&",'"&userid&"','"&txtcomm&"',"&spoint&","&bidx&",'"&refip&"','"&txtcommURL&"')}"
		
		.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
		.Execute, , adExecuteNoRecords
		End With	
	    returnValue = objCmd(0).Value		    
	
	Set objCmd = Nothing

	sqlstr = "select IDENT_CURRENT('[db_event].[dbo].[tbl_event_comment]') as evtcom_idx"

	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		evtcom_idx = rsget("evtcom_idx")
	END IF
	rsget.close

	IF returnValue = 1 THEN	
		'response.write "<script>alert('응모 해주셔서 감사합니다.');</script>"
		Response.Write "01|" & evtcom_idx
		dbget.close()	:	response.End
	ELSEIF returnValue = 2 THEN	
		'response.write "<script>alert('한번에 5회 이상 연속 등록 불가능합니다.');</script>"
		Response.Write "04"
		dbget.close()	:	response.End
	ELSE
		'response.write "<script>alert('데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해 주십시오.');</script>"
		Response.Write "05"
		dbget.close()	:	response.End
	END IF 

elseif mode="del" then
	Set objCmd = Server.CreateObject("ADODB.COMMAND")
		With objCmd
		.ActiveConnection = dbget
		.CommandType = adCmdText
		.CommandText = "{?= call [db_event].[dbo].sp_Ten_event_comment_delete ("&Cidx&",'"&userid&"',"&bidx&","&com_egCode&")}"		
		.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
		.Execute, , adExecuteNoRecords
		End With	
	    returnValue = objCmd(0).Value		    	
	Set objCmd = Nothing
		
	IF returnValue = 1 THEN	
		Response.Write "01"
		dbget.close()	:	response.End
	ELSE
		'response.write "<script>alert('데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해 주십시오.');</script>"
		response.write "03"
		dbget.close()	:	response.End
	END IF

elseif mode="invitereg" then
	'//카카오톡 본인 응모수
	kakaotalksubscriptcount = getevent_subscriptexistscount(eCode, userid, "kakaotalk", "", "")
	if kakaotalksubscriptcount>=5 then
		Response.Write "03"
		dbget.close() : Response.End
	end if

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', 'kakaotalk', 0, '" & txtcommURL & "', 'M')" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	response.write "01"
	dbget.close() : Response.End

else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.');</script>"
	dbget.close() : Response.End
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->