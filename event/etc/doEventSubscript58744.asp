<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  도라에몽 고민상담소
' History : 2015.01.20 한용민 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event58744Cls.asp" -->

<%
dim mode, eCode, userid, txtcomm, com_egCode, bidx, spoint, txtcommURL, Cidx, evtcom_idx
dim tmpcomment, tmpcommentgubun , tmpcommenttext, gubun
	mode = requestcheckvar(request("mode"),32)
	txtcomm = request("txtcomm")
	com_egCode=requestCheckVar(request("com_egC"),10)
	bidx = getNumeric(requestCheckVar(request("bidx"),10))
	spoint = getNumeric(requestCheckVar(request("spoint"),10))
	txtcommURL = requestCheckVar(request("txtcommURL"),128)
	Cidx= getNumeric(requestCheckVar(request("Cidx"),10))
	gubun= getNumeric(requestCheckVar(request("gubun"),1))
	txtcommURL = html2db(txtcommURL)
	userid = getloginuserid()

eCode   =  getevt_code()

IF bidx = "" THEN bidx = 0
IF com_egCode = "" THEN com_egCode = 0
IF spoint = "" THEN spoint = 0

dim commentexistscount
commentexistscount=0

dim referer
referer = request.ServerVariables("HTTP_REFERER")
if InStr(referer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	'dbget.close() : Response.End
end if

dim refip
refip = request.ServerVariables("REMOTE_ADDR")

dim sqlStr, returnValue, objCmd

If not( getnowdate>="2015-01-21" and getnowdate<"2015-02-11") Then
	'Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="& getevt_codedisp &"'</script>"
	Response.Write "02"
	dbget.close() : Response.End
End IF
If userid = "" Then
	'Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="& getevt_codedisp &"'</script>"
	Response.Write "99"
	dbget.close() : Response.End
End IF

if mode="add" then	
	'// 본인 응모수
	commentexistscount=getcommentexistscount(userid, eCode, "", "", "", "Y")
	if commentexistscount>=3 then
		'Response.Write "<script type='text/javascript'>alert('한 아이디당 3회까지만 참여할 수 있습니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="& getevt_codedisp &"'</script>"
		Response.Write "06"
		dbget.close() : Response.End
	end if
	if gubun="" then
		'Response.Write "<script type='text/javascript'>alert('마법도구 네 가지 중 한 개를 선택해주세요.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="& getevt_codedisp &"'</script>"
		Response.Write "07"
		dbget.close() : Response.End
	end if

	Set objCmd = Server.CreateObject("ADODB.COMMAND")
		if checkNotValidTxt(txtcomm) then
			'Response.Write "<script type='text/javascript'>alert('내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="& getevt_codedisp &"'</script>"
			response.write "03"
			dbget.close() : Response.End
		end if
		txtcomm = gubun&"!@#"&html2db(txtcomm)
		
		With objCmd
		.ActiveConnection = dbget
		.CommandType = adCmdText
		.CommandText = "{?= call [db_event].[dbo].sp_Ten_event_comment_insert("&eCode&","&com_egCode&",'"&userid&"','"&txtcomm&"',"&spoint&","&bidx&",'"&refip&"','"&txtcommURL&"','M')}"
		
		.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
		.Execute, , adExecuteNoRecords
		End With	
	    returnValue = objCmd(0).Value		    
	
	Set objCmd = Nothing
	
	IF returnValue = 1 THEN
		'Response.Write "<script type='text/javascript'>"
		'Response.Write "	alert('응모완료! 도라에몽이 여러분을 응원합니다! :)');"
		'Response.Write " 	parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="& getevt_codedisp &"'"
		'Response.Write "</script>"
		Response.Write "01"
		dbget.close() : Response.End
	ELSEIF returnValue = 2 THEN	
		'Response.Write "<script type='text/javascript'>alert('한번에 5회 이상 연속 등록 불가능합니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="& getevt_codedisp &"'</script>"
		Response.Write "04"
		dbget.close() : Response.End
	ELSE
		'Response.Write "<script type='text/javascript'>alert('데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해 주십시오.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="& getevt_codedisp &"'</script>"
		Response.Write "05"
		dbget.close() : Response.End
	END IF

elseif mode="del" then
	if Cidx="" then
		Response.Write "<script type='text/javascript'>alert('글번호가 없습니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="& getevt_codedisp &"'</script>"
		dbget.close() : Response.End
	end if

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
		Response.Write "<script type='text/javascript'>parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="& getevt_codedisp &"'</script>"
		dbget.close() : Response.End
   ELSE
		Response.Write "<script type='text/javascript'>alert('데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해 주십시오.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="& getevt_codedisp &"'</script>"
		dbget.close() : Response.End
   END IF 

elseif mode="edit" then
	if Cidx="" then
		Response.Write "<script type='text/javascript'>alert('글번호가 없습니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="& getevt_codedisp &"'</script>"
		dbget.close() : Response.End
	end if

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
		Response.Write "<script type='text/javascript'>parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="& getevt_codedisp &"'</script>"
		dbget.close() : Response.End
   ELSE
		Response.Write "<script type='text/javascript'>alert('데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해 주십시오.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="& getevt_codedisp &"'</script>"
		dbget.close() : Response.End
   END IF
   
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="& getevt_codedisp &"'</script>"
	dbget.close() : Response.End
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->