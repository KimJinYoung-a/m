<% option Explicit %>
<% Response.CharSet = "euc-kr" %>
<%
	Response.Expires = -1
	Response.CacheControl = "no-cache"
	Response.AddHeader "Pragma", "no-cahce"
	Response.AddHeader "cache-Control", "no-cache"
%>
<!-- include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	dim sqlStr, loginid, eCode, releaseDate , result, opt1, opt2, opt3, opt4, opt
	Dim resulthtml

	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "21030"
	Else
		eCode 		= "47654"
	End If

	result = requestCheckVar(Request("result"),1)		'�̺�Ʈ �ڵ�
	loginid = GetLoginUserID()

	// �̺�Ʈ �Ⱓ Ȯ�� //
	sqlStr = "Select evt_startdate, evt_enddate " &_
			" From db_event.dbo.tbl_event " &_
			" WHERE evt_code='" & eCode & "'"
	rsget.Open sqlStr,dbget,1
	if rsget.EOF or rsget.BOF then
		Response.Write	"<script language='javascript'>" &_
						"alert('�������� �ʴ� �̺�Ʈ�Դϴ�.');" &_
						"</script>"
		dbget.close()	:	response.End
	elseif date<rsget("evt_startdate") or date>rsget("evt_enddate") then
		Response.Write	"<script language='javascript'>" &_
						"alert('�˼��մϴ�. �̺�Ʈ �Ⱓ�� �ƴմϴ�.');" &_
						"</script>"
		dbget.close()	:	response.End
	end if
	rsget.Close

	'// �α��� ���� Ȯ�� //
	if loginid="" or isNull(loginid) then
		Response.Write	"<script type='text/javascript'>" &_
						"alert('�̺�Ʈ�� ���� �Ϸ��� �α����� �ʿ��մϴ�.');" &_
						"</script>"
		dbget.close()	:	response.End
	end If

	'������ ���� Ȯ��
	Dim chknum
	sqlStr = "Select count(sub_idx) " &_
			" From db_event.dbo.tbl_event_subscript " &_
			" WHERE evt_code='" & eCode & "'" &_
			" and userid='" & loginid & "'"

	rsget.Open sqlStr,dbget,1
	chknum = rsget(0)
	rsget.Close

	If chknum = 0 then		'ó�� ����� insert

		sqlStr = "Insert into db_event.dbo.tbl_event_subscript " &_
		" (evt_code, userid, sub_opt3) values " &_
		" (" & eCode &_
		",'" & loginid & "'" &_
		",'" & result & "//')"
		dbget.execute(sqlStr)
 	'Response.write  "<script>alert('"& result&"�� ����Ϸ�');</script>"
	else			'������ ������ ������ update

		dim cc
		sqlStr = "Select sub_opt3 from db_event.dbo.tbl_event_subscript" &_
				" where evt_code='" & eCode & "' and userid='" & loginid & "' "
		rsget.Open sqlStr,dbget,1
		cc = rsget(0)
		rsget.Close


		sqlStr = "Update db_event.dbo.tbl_event_subscript set sub_opt3='"& cc & result & "//' " &_
				" where evt_code='" & eCode & "' and userid='" & loginid & "' "
		dbget.execute(sqlStr)
		'Response.write  "<script>alert('"& result&"�� ����Ϸ�');</script>"
	end If

		sqlstr = "Select " &_
				" sub_opt3" &_
				" From db_event.dbo.tbl_event_subscript" &_
				" WHERE evt_code='" & eCode & "' and userid='" & GetLoginUserID() & "' "
				'response.write sqlstr
		rsget.Open sqlStr,dbget,1
		if Not(rsget.EOF or rsget.BOF) then
			opt = rsget(0)
		End If
		rsget.Close

		opt1 = SplitValue(opt,"//",0)
		opt2 = SplitValue(opt,"//",1)
		opt3 = SplitValue(opt,"//",2)
		opt4 = SplitValue(opt,"//",3)

		If opt1="" then opt1=0
		If opt2="" then opt2=0
		If opt3="" then opt3=0
		If opt4="" then opt4=0

		Dim chgnum '// �ٲ��̹���

		If result = "1" Then chgnum = "1"
		If result = "2" Then chgnum = "2"
		If result = "3" Then chgnum = "3"
		If result = "4" Then chgnum = "4"

		If opt1 > 0 And opt2 = 0 And opt3 = 0 And opt4 = 0 Then '//1������
			response.write "<script>parent.document.getElementById('result1').style.display='block';</script>"
			response.write "<script>parent.chgpic('"& chgnum &"');</script>"
		ElseIf opt1 > 0 And opt2 > 0  And opt3 = 0 And opt4 = 0 Then '// 2������
			response.write "<script>parent.document.getElementById('result2').style.display='block';</script>"
			response.write "<script>parent.chgpic('"& chgnum &"');</script>"
		ElseIf opt1 > 0 And opt2 > 0  And opt3 > 0 And opt4 = 0 Then '//3������
			response.write "<script>parent.document.getElementById('result3').style.display='block';</script>"
			response.write "<script>parent.chgpic('"& chgnum &"');</script>"
		ElseIf int(opt1) + int(opt2) + int(opt3) + int(opt4) = 10 Then '//���� ����
			response.write "<script>parent.document.getElementById('result4').style.display='block';</script>"
			response.write "<script>parent.chgpic('"& chgnum &"');</script>"
		End if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->