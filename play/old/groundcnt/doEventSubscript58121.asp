<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'###########################################################
' Description :  play ��¦��¦ ������ 2015
' History : 2014.12.26 �ѿ�� ����
'###########################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/play/groundcnt/event58121Cls.asp" -->
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
	Response.Write "�߸��� �����Դϴ�."
	'dbget.close() : Response.End
end if

dim refip
refip = request.ServerVariables("REMOTE_ADDR")

dim sqlStr, returnValue, objCmd

If userid = "" Then
     response.write "<script>alert('�α��� �� ���� ���� �� �ֽ��ϴ�.');</script>"
	 response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
	dbget.close() : Response.End
End IF
If not( getnowdate>="2014-12-29" and getnowdate<"2015-01-08") Then
     response.write "<script>alert('�̺�Ʈ ���� �Ⱓ�� �ƴմϴ�.');</script>"
	 response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
	dbget.close() : Response.End
End IF
						
if mode="add" then
	'// ���� �����
	commentexistscount=getcommentexistscount(userid, eCode, "", "", "", "Y")
	if commentexistscount>=5 then
	     response.write "<script>alert('�Ѿ��̵�� 5ȸ ������ ������ ���� �մϴ�.');</script>"
		 response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
	end if

	if gubun="" then
	     response.write "<script>alert('���� ������ �ּ���.');</script>"
		 response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
	end if

	Set objCmd = Server.CreateObject("ADODB.COMMAND")
		if checkNotValidTxt(txtcomm) then
			response.write "<script>alert('���뿡 ��ȿ���� ���� ���ڰ� ���ԵǾ� �ֽ��ϴ�. �ٽ� �ۼ� ���ּ���.');</script>"
			response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
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
		'response.write "<script>alert('���� ���ּż� �����մϴ�.');</script>"
		response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
		dbget.close()	:	response.End
	ELSEIF returnValue = 2 THEN	
		response.write "<script>alert('�ѹ��� 5ȸ �̻� ���� ��� �Ұ����մϴ�.');</script>"
	 	response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
	 	dbget.close()	:	response.End
   ELSE
     response.write "<script>alert('������ ó���� ������ �߻��Ͽ����ϴ�. �����ڿ��� ������ �ֽʽÿ�.');</script>"
	 response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
	 dbget.close()	:	response.End
   END IF 

elseif mode="del" then
	if Cidx="" then
	     response.write "<script>alert('�۹�ȣ�� �����ϴ�.');</script>"
		 response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
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
		response.redirect(referer)
		dbget.close()	:	response.End
   ELSE
     response.write "<script>alert('������ ó���� ������ �߻��Ͽ����ϴ�. �����ڿ��� ������ �ֽʽÿ�.');</script>"
	 response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
	 dbget.close()	:	response.End
   END IF 


elseif mode="edit" then
	if Cidx="" then
	     response.write "<script>alert('�۹�ȣ�� �����ϴ�.');</script>"
		 response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
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
   		If returnurl <> "" Then
   			referer = returnurl
		End If
	response.redirect(referer)	
	dbget.close()	:	response.End
   ELSE
     response.write "<script>alert('������ ó���� ������ �߻��Ͽ����ϴ�. �����ڿ��� ������ �ֽʽÿ�.');</script>"
	 response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
	 dbget.close()	:	response.End
   END IF 
   
else
	Response.Write "<script type='text/javascript'>alert('�������� ��ΰ� �ƴմϴ�.');</script>"
	dbget.close() : Response.End
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->