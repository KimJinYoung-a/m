<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
Dim strSql, mode
Dim eCode, blogurl, evtcom_txt, userid, evtcom_idx, evtgroup_code, vOrder
mode		= request("mode")							'��� I:����
eCode 		= request("eCode")							'�̺�Ʈ�ڵ�
blogurl 	= requestCheckVar(request("blogurl"),20)	'Ű����
evtcom_txt 	= requestCheckVar(request("txtcomm"),100)	'Ű���忡 ���� ����
userid 		= request("userid")							'�α��� ID
evtcom_idx	= request("Cidx")							'�Խñ� ���� ��ȣ
evtgroup_code =  request("evtgroup_code")
'vOrder = request("vOrder")

Dim keyupdate, keydelete
If mode = "U" Then
	Set keyupdate = new ClsKeyWord
		keyupdate.FECode 		= eCode
		keyupdate.FEvtcom_idx	= cidx
		keyupdate.FUserID		= userid
		keyupdate.KeyWordUpdate
	Set keyupdate = nothing
ElseIf mode = "D" Then
	Set keydelete = new ClsKeyWord
		keydelete.FEvtcom_idx	= cidx
		keydelete.KeyWordDelete
	Set keydelete = nothing
End If

If mode = "I" Then
	'�Ϸ翡 �ϳ��� ��ϰ���
	strSql = ""
	strSql = strSql & "select count(*) as cnt from " & vbcrlf
	strSql = strSql & "db_event.dbo.tbl_event_comment " & vbcrlf
	strSql = strSql & "where evt_code='"&eCode&"' " & vbcrlf
	strSql = strSql & "and userid = '"&userid&"' and evtcom_using = 'Y' " & vbcrlf
	strSql = strSql & "and convert(varchar, evtcom_regdate,23) = convert(varchar, getdate(),23) " & vbcrlf
	rsget.Open strSql, dbget, 1
	If rsget("cnt") >= 1 Then
		Response.Write  "<script language='javascript'>" &_
						"	alert('�Ϸ翡 �Ѱ��� ��ϰ����մϴ�');" &_
						"</script>"
		dbget.close()	:	response.End
	End If
	rsget.Close

	'�Է� ���μ���
	strSql = ""
	strSql = strSql & "Insert into db_event.dbo.tbl_event_comment " & vbcrlf
	strSql = strSql & "(evt_code, userid, evtcom_txt, blogurl, evtcom_regdate, evtgroup_code) " & vbcrlf
	strSql = strSql & "VALUES " & vbcrlf
	strSql = strSql & "('"&eCode&"','"&userid&"','"&evtcom_txt&"','"&blogurl&"', getdate(),'" & evtgroup_code &"') "
	dbget.execute strSql

End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->