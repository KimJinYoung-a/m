<% @language=vbscript %>
<% Option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbAppNotiopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/htmllib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/lib/classes/appmanage/util.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<%
' http://www.csidata.com/custserv/onlinehelp/vbsdocs/vbs3.htm






' Class DataStore ''''''''''''''''''''''''''''''''''''''''''''''''''''''''

	Function addApp(appkey, clientType, description, allowed_role)

		Dim sql, AssignedRow

		sql = " INSERT into tbl_tbtpns_app" & VbCRLF
		sql = sql & "     (clienttype, appkey, description, allowed_role)" & VbCRLF
		sql = sql & "     VALUES('" & clientType & "'" & VbCRLF
		sql = sql & "     ,'" & appkey & "'" & VbCRLF
		sql = sql & "     ,'" & description & "'" & VbCRLF
		sql = sql & "     ,'" & allowed_role & "'" & VbCRLF
		sql = sql & "     )"  & VbCRLF

		dbAppNotiget.Execute sql, AssignedRow

	End Function

	Function register(appid, regkey, userid, role)

		'*********************************************************
		'
		' ���� :	a
		'
		' �Է� :	a
		'
		' ��� : 	a
		'
		' ���� :	1. ���� ����ڰ� ���� ����̽��� ���� �� ��ġ ����
		'			2. ���� ����̽����� ���� ����� �α��� ����
		'
		'*********************************************************

		dim sql, AssignedRow
		sql = sql & "IF EXISTS (SELECT NULL FROM db_AppNoti.dbo.tbl_tbtpns_register WHERE regkey='" & regkey & "')" & VbCRLF
		sql = sql & "	UPDATE db_AppNoti.dbo.tbl_tbtpns_register SET userid='" & userid & "' WHERE regkey='" & regkey & "'" & VbCRLF
		sql = sql & "ELSE" & VbCRLF
		sql = sql & "	INSERT INTO db_AppNoti.dbo.tbl_tbtpns_register" & VbCRLF
		sql = sql & "	(appid, regkey, userid, role)" & VbCRLF
		sql = sql & "	VALUES(" & VbCRLF
		sql = sql & "		 '" & appid & "'" & VbCRLF
		sql = sql & "		,'" & regkey & "'" & VbCRLF
		sql = sql & "		,'" & userid & "'" & VbCRLF
		sql = sql & "		,'" & role & "'" & VbCRLF
		sql = sql & "	)"

		dbAppNotiget.Execute sql, AssignedRow

	End Function

	Const ROLE_UNKNOWN = -1
	Const ROLE_MEMBER = 10
	Const ROLE_STAFF = 20

	'/Ǫ�þ˸� �޼����� ����ϴ� �Լ�
	Function sendMessage(appkey, sender, receiver, message, url)
		' (����)
		' Ư�� ����ڿ��� �޼��� ������
		' sendMessage "admin", Array("tozzinet", "20"), Array("icommang", 20), "�޼���"
		' ������� �޼��� ������
		' sendMessage "admin", Array("tozzinet", "20"), "*", "�޼���"
			
		Dim multipleMessage : multipleMessage = False
	'	If ( IsArray(receiver) ) Then
	'		If ( ubound(receiver) > 2 ) Then
	'			multipleMessage = True
	'		End If
	'	End If
		If ( TypeName(receiver) = "String" ) Then
			If ( receiver = "*" ) Then
				multipleMessage = True
			End If
		End If

		' sender
		Dim sender_regid : sender_regid = -1
		Dim sender_userid : sender_userid = ""
		Dim sender_role : sender_role = -1
		If ( IsArray(sender) ) Then
			Dim senderRow : Set senderRow = getRegisterRowByTenUserIDAndType(sender(0), sender(1))
			sender_regid = senderRow("regid")
			sender_userid = senderRow("userid")
			sender_role = senderRow("role")
		End If
		
		' receiver
		dim condition : condition = ""
		if ( isArray(receiver) ) then
			dim list : set list = CreateObject("System.Collections.ArrayList")
			dim i : for i = lbound(receiver) to ubound(receiver) step 2
				list.Add "SELECT regid FROM tbl_tbtpns_register WHERE userid = '" & receiver(i) & "' AND role = " & receiver(i + 1)			
			Next
			condition = condition & " AND REG.regid IN ("
			condition = condition & join(list.toArray, " UNION ")
			condition = condition & ")"
		end If

		dim sql, AssignedRow, msggroup_id

		msggroup_id = -1
		If ( multipleMessage ) Then
			sql = "INSERT INTO tbl_tbtpns_msggroup (complete, message, url) VALUES (0, '" & message & "' , '" & url & "')"
			'response.write sql & "<Br>"		
			dbAppNotiget.Execute sql, AssignedRow

			Dim lsSQL : lsSQL = "SELECT @@IDENTITY AS NewID"
			Dim loRs : Set loRs = dbAppNotiget.Execute(lsSQL)
			Dim llID : llID = loRs.Fields("NewID").value
			msggroup_id = llID
		End If

		sql = "INSERT INTO tbl_tbtpns_msgitem (msggroup_id, sender_regid, sender_userid, sender_role" + vbcrlf
		sql = sql & " , receiver_regid, receiver_userid, receiver_role, message, url, resultcode, resultmessage, resultdate)" + vbcrlf
		sql = sql & " 		SELECT " & msggroup_id & ", " & sender_regid & ", '" & sender_userid & "'" + vbcrlf
		sql = sql & " 		, " & sender_role & ", REG.regid, REG.userid, REG.role, '" & message & "', '" & url & "'" + vbcrlf
		sql = sql & " 		, 100, '����', getdate()" + vbcrlf
		sql = sql & " 		FROM tbl_tbtpns_app AS APP, tbl_tbtpns_register AS REG" + vbcrlf
		sql = sql & " 		WHERE APP.appid = REG.appid AND APP.appkey = '" & appkey & "'" & condition
		'response.write sql & "<Br>"
		dbAppNotiget.Execute sql, AssignedRow

	End Function

	Function getRegisterRowByTenUserIDAndType(userid, role)

		Dim sql : sql = ""
		sql = sql & "SELECT regid, userid, role" & VbCRLF
		sql = sql & "	FROM db_AppNoti.dbo.tbl_tbtpns_register" & VbCRLF
		sql = sql & "	WHERE userid = '" & userid & "'" & VbCRLF
		sql = sql & "	AND role = '" & role & "'" & VbCRLF

		Dim ret : Set ret = CreateObject("Scripting.Dictionary")
		ret.Item("regid") = -1
		ret.Item("userid") = ""
		ret.Item("role") = -1
		rsAppNotiget.open sql, dbAppNotiget, 1
		if not ( rsAppNotiget.Eof ) Then
			ret.Item("regid") = rsAppNotiget("regid")
			ret.Item("userid") = rsAppNotiget("userid")
			ret.Item("role") = rsAppNotiget("role")
		end if
		rsAppNotiget.close

		Set getRegisterRowByTenUserIDAndType = ret

	End Function

	Function getAppIDByAppKeyNType(appkey, clienttype)

		'*********************************************************
		'
		' ���� :	clienttype �� appkey�� appid �� ��� �Լ�
		'
		' �Է� :	appkey, clienttype
		'
		' ��� :	return param AAA|BBB
		'			AAA : S_OK, S_ERR, S_NONE
		'			BBB : ret Text
		'
		'*********************************************************

		Dim sql : sql = ""
		sql = sql & "SELECT appid" & VbCRLF
		sql = sql & "	FROM db_AppNoti.dbo.tbl_tbtpns_app" & VbCRLF
		sql = sql & "	WHERE appkey = '" & appkey & "'" & VbCRLF
		sql = sql & "	AND clienttype = '" & clienttype & "'" & VbCRLF

		Dim ret : ret = ""
		rsAppNotiget.open sql, dbAppNotiget, 1
		if not ( rsAppNotiget.Eof ) then
			ret = rsAppNotiget("appid")
		end if
		rsAppNotiget.close

		getAppIDByAppKeyNType = ret

	End Function

	Function getRegKey(appid, userid)

		'*********************************************************
		'
		' ���� :	a
		'
		' �Է� :	a
		'
		' ��� :	a
		'
		'*********************************************************

		Dim ret : ret = ""
		Dim sql
		sql = "SELECT regkey" & VbCRLF
		sql = sql & " FROM dbo.tbl_tbtpns_register" & VbCRLF
		sql = sql & " WHERE appid = '" & appid & "'" & VbCRLF
		sql = sql & " AND userid = '" & userid & "'" & VbCRLF

		rsAppNotiget.open sql, dbAppNotiget, 1
		if not ( rsAppNotiget.Eof ) then
			ret = rsAppNotiget("regkey")
		end if
		rsAppNotiget.close

		getRegKey = ret

	End Function

' End Class ''''''''''''''''''''''''''''''''''''''''''''''''''''''''










'Class Util ''''''''''''''''''''''''''''''''''''''''''''''''''''''''

	Function fnCheckHash(regkey, ihash)

		'*********************************************************
		'
		' ���� :	����
		'
		' �Է� :	source ��Ʈ���� hash ��Ʈ��
		'
		' ��� :	��������
		'
		'*********************************************************

		fnCheckHash = (UCASE(MD5(regkey & "10")) = UCASE(ihash))

	End Function
	
	Function showSQL(sql, title)
		
		'*********************************************************
		'
		' ���� :	SQL ���� ����� HTML�� �����ش�
		'
		' �Է� :	SQL ����
		'
		' ��� :	HTML ���̺� ���
		'
		'*********************************************************

		rsAppNotiget.open sql, dbAppNotiget, 1

		response.write "<table border='1'>"
		response.write "	<tr><td colspan='" & rsAppNotiget.Fields.count & "'><b>" & title & "</b></td></tr>"
		response.write "	<tr><td colspan='" & rsAppNotiget.Fields.count & "'><b>" & sql & "</b></td></tr>"
		response.write "	<tr>"
		Dim field
		For Each field In rsAppNotiget.Fields
			response.write "<td style='padding: 5px'><b>"
			response.write field.name
			response.write "</b></td>"
		Next
		response.write "	</tr>"
		Do While Not ( rsAppNotiget.Eof )
			response.write "<tr>"
			For Each field In rsAppNotiget.Fields
				response.write "<td style='padding: 5px'>"
				response.write rsAppNotiget(field.name)
				response.write "</td>"
			Next
			response.write "</tr>"
			rsAppNotiget.MoveNext
		Loop
		rsAppNotiget.close
		response.write "</table><br/>"

	End Function

	Function describeTables
	
		'*********************************************************
		'
		' ���� :	���õ� DB�� ��� table�� field�� ���� ���
		'
		'*********************************************************

		Dim sql : sql = ""
		sql = sql & "SELECT  	u.name + '.' + t.name AS [table],"  & VbCRLF
		sql = sql & "					td.value AS [table_desc],"  & VbCRLF
		sql = sql & "					c.name AS [column],"  & VbCRLF
		sql = sql & "					cd.value AS [column_desc]"  & VbCRLF
		sql = sql & "		FROM    	sysobjects t"  & VbCRLF
		sql = sql & "		INNER JOIN  sysusers u"  & VbCRLF
		sql = sql & "			ON		u.uid = t.uid"  & VbCRLF
		sql = sql & "		LEFT OUTER JOIN sys.extended_properties td"  & VbCRLF
		sql = sql & "			ON		td.major_id = t.id"  & VbCRLF
		sql = sql & "			AND 	td.minor_id = 0"  & VbCRLF
		sql = sql & "			AND		td.name = 'MS_Description'"  & VbCRLF
		sql = sql & "		INNER JOIN  syscolumns c"  & VbCRLF
		sql = sql & "			ON		c.id = t.id"  & VbCRLF
		sql = sql & "		LEFT OUTER JOIN sys.extended_properties cd"  & VbCRLF
		sql = sql & "			ON		cd.major_id = c.id"  & VbCRLF
		sql = sql & "			AND		cd.minor_id = c.colid"  & VbCRLF
		sql = sql & "			AND		cd.name = 'MS_Description'"  & VbCRLF
		sql = sql & "		WHERE t.type = 'u'"  & VbCRLF
		sql = sql & "		ORDER BY    t.name, c.colorder"   & VbCRLF

		showSQL sql, "�ʵ� ����"

	End Function

	Function truncateTable(tableName)

		'*********************************************************
		'
		' ���� :	Table�� truncate �Ѵ�
		'
		'*********************************************************

		Dim canAccess : canAccess = false
		If ( tableName = "tbl_tbtpns_app" ) Or ( tableName = "tbl_tbtpns_register" ) Or ( tableName = "tbl_tbtpns_msgitem" ) Or ( tableName = "tbl_tbtpns_msggroup" ) Then
			canAccess = true
		End If
		If Not ( canAccess ) Then
			rw "���� �� ���� ���̺�"
			Exit Function
		End If

		Dim sql, AssignedRow
		sql = "TRUNCATE TABLE " & tableName
		dbAppNotiget.Execute sql, AssignedRow

	End Function

' End Class ''''''''''''''''''''''''''''''''''''''''''''''''''''''''







' Class WebMethod ''''''''''''''''''''''''''''''''''''''''''''''''''''''''

	Function WEB_METHOD_register

		'*********************************************************
		'
		' ���� :	��ġ ���
		'
		' �Է� : http://testm.10x10.co.kr/apps/appCom/pushCom.asp?method=regpns&clienttype=ios&regkey=signkey111&appkey=hitchhiker&userid=haha&ihash=013DA16E373E32D68E2558D96B5F2740
		'
		' ��� : ��ġ ��� ��� �޼���
		'
		'*********************************************************

		Dim appkey, clienttype, regkey, userid, ihash
		appkey     = requestCheckvar(Request("appkey"), 32)
		clienttype  = requestCheckvar(Request("clienttype"), 32)
		regkey     = requestCheckvar(Request("regkey"), 2000)
		userid  = requestCheckvar(Request("userid"), 32)
		ihash       = requestCheckvar(Request("ihash"), 100)

'rw md5(regkey & "10")
'rw regkey
'rw ihash
'rw fnCheckHash(regkey, ihash)

		if ( appkey = "" ) or ( clienttype = "" ) or ( regkey = "" ) or ( ihash = "" ) then
			response.write "S_ERR|����� ������ �߻��Ͽ����ϴ�.(1)"
			dbAppNotiget.close : response.end
		end If

		if not fnCheckHash(regkey, ihash) then
			response.write "S_ERR|����� ������ �߻��Ͽ����ϴ�.(2)"
			dbAppNotiget.close : response.end
		end if

		Dim appid : appid = getAppIDByAppKeyNType(appkey, clienttype)
		if ( appid = "" ) then
			response.write "S_ERR|����� ������ �߻��Ͽ����ϴ�.(3)"
			dbAppNotiget.close : response.end
		end if

		register appid, regkey, userid, ROLE_MEMBER

		response.write "S_OK|����"
		dbAppNotiget.close : response.End

	end function

	Function WEB_METHOD_regmsg

		'*********************************************************
		'
		' ���� :	Ǫ�þ˸��� ������ ���޼ҵ�
		'			sendMessage �Լ� �׽�Ʈ ����
		'			���߿� �ּ�ó�� �Ѵ�
		'
		' �Է� : http://testm.10x10.co.kr/apps/appCom/pushCom.asp?method=regmsg&userid=wef&message=woifjowiej_wefoiwjeof_ergewrg
		'
		' ��� : �޼��� ���
		'
		'*********************************************************

		dim userid : userid = requestCheckvar(Request("userid"), 32)
		dim message : message = requestCheckvar(Request("message"), 100)

		if ( userid = "" ) or ( message = "" ) then
			response.write "S_ERR|����� ������ �߻��Ͽ����ϴ�.(1)"
			dbAppNotiget.close : response.end
		end if

		' Ư�� ����ڿ��� �޼��� ������
		'sendMessage "hitchhiker", Array("koojunho", ROLE_STAFF), Array(userid, ROLE_MEMBER), message
		' ������� �޼��� ������
		sendMessage "hitchhiker", "SYSTEM", "*", message

		response.write "S_OK|����"
		dbAppNotiget.close : response.end

	end Function
	
	Function WEB_METHOD_error
		
		'*********************************************************
		'
		' ���� :	Web method ������ ��Ȯ���� ������ ���� ���
		'
		' �Է� : http://testm.10x10.co.kr/apps/appCom/pushCom.asp
		'
		'*********************************************************

		response.write "S_ERR|����� ������ �߻��Ͽ����ϴ�.(-1)"
		dbAppNotiget.close : response.End
		
	End Function

	Function WEB_METHOD_test
		
		'*********************************************************
		'
		' ���� :	�׽�Ʈ
		'
		' �Է� : http://testm.10x10.co.kr/apps/appCom/pushCom.asp?method=test
		'
		'*********************************************************

		'WEB_METHOD_truncate

		'response.end

		'addApp "hitchhiker", "ios", "��ġ����Ŀ", ROLE_MEMBER
		'addApp "hitchhiker", "android", "��ġ����Ŀ", ROLE_MEMBER
		'addApp "admin_app", "ios", "admin ��", ROLE_STAFF
		'addApp "admin_app", "android", "admin ��", ROLE_STAFF
		'addApp "tenbyten", "ios", "�ٹ����� ��", ROLE_MEMBER
		'addApp "tenbyten", "android", "�ٹ����� ��", ROLE_MEMBER

		' register ù ��° appid �� appkey�� �ٲ���
'		register 1, "1AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", "koojunho", ROLE_STAFF
'		register 1, "2AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", "koojunho", ROLE_STAFF
'		register 1, "3AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", "koojunho", ROLE_MEMBER
'		register 1, "4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", "parkjs", ROLE_MEMBER
'		register 1, "5AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", "kimtaehee", ROLE_MEMBER
'		register 2, "6AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", "koojunho", ROLE_STAFF
'		register 2, "7AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", "koojunho", ROLE_STAFF
'		register 2, "8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", "koojunho", ROLE_MEMBER
'		register 2, "9AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", "parkjs", ROLE_MEMBER
'		register 2, "10AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", "kimtaehee", ROLE_MEMBER
'		register 2, "11AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", "junjihyun", ROLE_MEMBER
'		register 3, "12AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", "koomiho", ROLE_MEMBER

		'sendMessage "admin_app", "SYSTEM", "*", "Did you do your homework?", "http://testm.10x10.co.kr/mAPPAdmin/test.asp"
		sendMessage "admin_app", "SYSTEM", "*", "�ȳ� test rev 3", "http://testm.10x10.co.kr/mAPPAdmin/test.asp"
		'sendMessage "hitchhiker", Array("koojunho", ROLE_STAFF), Array("parkjs", ROLE_MEMBER), "koojunho�� parkjs����"
		'sendMessage "hitchhiker", Array("koojunho", ROLE_STAFF), Array("parkjs", ROLE_MEMBER, "koojunho", ROLE_STAFF), "koojunho�� parkjs, koojunho ����"
		'sendMessage "hitchhiker", "SYSTEM", "*", "��ü����"
		'sendMessage "admin", "SYSTEM", "*", "���� �޼���"
		'sendMessage "tenbyten", "SYSTEM", "*", "����ڰ� ���� �ۿ� �޼��� ������!!!"

		WEB_METHOD_show

	End Function

	Function WEB_METHOD_show

		rw "<meta http-equiv='Content-Type' content='text/html; charset=euc-kr' />"

'		sendMessage "hitchhiker", "SYSTEM", Array("ipadnew", ROLE_MEMBER), "new �޾ƶ�~"
'		sendMessage "hitchhiker", "SYSTEM", Array("ipadold", ROLE_MEMBER), "old �޾ƶ�~"

		showSQL "SELECT TOP 1 msggroup_id FROM dbo.tbl_tbtpns_msggroup WHERE complete = 0 ORDER BY msggroup_id ASC", "ddd"

		showSQL "SELECT TOP 1000 ITEM.*, APP.clienttype, REG.appid, REG.regkey FROM dbo.tbl_tbtpns_msgitem AS ITEM INNER JOIN dbo.tbl_tbtpns_register AS REG ON ITEM.receiver_regid = REG.regid AND ITEM.receiver_userid = REG.userid AND ITEM.receiver_role = REG.role INNER JOIN dbo.tbl_tbtpns_app AS APP ON REG.appid = APP.appid INNER JOIN dbo.tbl_tbtpns_msggroup AS GRP ON ITEM.msggroup_id = GRP.msggroup_id WHERE APP.clienttype = 'android' AND ITEM.resultcode < 200 AND ITEM.msggroup_id = -1", "ffff"

		showSQL "SELECT * FROM tbl_tbtpns_app", "APP ���̺�"
		showSQL "SELECT * FROM tbl_tbtpns_register", "REG ���̺�"
		showSQL "SELECT * FROM tbl_tbtpns_msggroup", "MSG GROUP ���̺�"
		showSQL "SELECT * FROM tbl_tbtpns_msgitem", "MSG ITEM ���̺�"

		showSQL "SELECT TOP 1000 ITEM.*, APP.clienttype, REG.appid, REG.regkey FROM dbo.tbl_tbtpns_msgitem AS ITEM INNER JOIN dbo.tbl_tbtpns_register AS REG ON ITEM.receiver_regid = REG.regid AND ITEM.receiver_userid = REG.userid AND ITEM.receiver_role = REG.role INNER JOIN dbo.tbl_tbtpns_app AS APP ON REG.appid = APP.appid WHERE APP.clienttype = 'ios' AND ITEM.resultcode < 200 AND ITEM.msggroup_id = -1", "iOS, ����MSG ���"

		showSQL "SELECT TOP 1000 ITEM.*, APP.clienttype, REG.appid, REG.regkey FROM dbo.tbl_tbtpns_msgitem AS ITEM INNER JOIN dbo.tbl_tbtpns_register AS REG ON ITEM.receiver_regid = REG.regid AND ITEM.receiver_userid = REG.userid AND ITEM.receiver_role = REG.role INNER JOIN dbo.tbl_tbtpns_app AS APP ON REG.appid = APP.appid WHERE APP.clienttype = 'android' AND ITEM.resultcode < 200 AND ITEM.msggroup_id = -1", "Android, ����MSG ���"

		showSQL "SELECT TOP 1000 ITEM.*, APP.clienttype, REG.appid, REG.regkey FROM dbo.tbl_tbtpns_msgitem AS ITEM INNER JOIN dbo.tbl_tbtpns_register AS REG ON ITEM.receiver_regid = REG.regid AND ITEM.receiver_userid = REG.userid AND ITEM.receiver_role = REG.role INNER JOIN dbo.tbl_tbtpns_app AS APP ON REG.appid = APP.appid INNER JOIN dbo.tbl_tbtpns_msggroup AS GRP ON ITEM.msggroup_id = GRP.msggroup_id WHERE APP.clienttype = 'ios' AND ITEM.resultcode < 200 AND ITEM.msggroup_id = 1", "iOS, �׷�MSG(id=1) ���"
		showSQL "SELECT TOP 1000 ITEM.*, APP.clienttype, REG.appid, REG.regkey FROM dbo.tbl_tbtpns_msgitem AS ITEM INNER JOIN dbo.tbl_tbtpns_register AS REG ON ITEM.receiver_regid = REG.regid AND ITEM.receiver_userid = REG.userid AND ITEM.receiver_role = REG.role INNER JOIN dbo.tbl_tbtpns_app AS APP ON REG.appid = APP.appid INNER JOIN dbo.tbl_tbtpns_msggroup AS GRP ON ITEM.msggroup_id = GRP.msggroup_id WHERE APP.clienttype = 'android' AND ITEM.resultcode < 200 AND ITEM.msggroup_id = 1", "Android, �׷�MSG(id=1) ���"
		showSQL "SELECT TOP 1000 ITEM.*, APP.clienttype, REG.appid, REG.regkey FROM dbo.tbl_tbtpns_msgitem AS ITEM INNER JOIN dbo.tbl_tbtpns_register AS REG ON ITEM.receiver_regid = REG.regid AND ITEM.receiver_userid = REG.userid AND ITEM.receiver_role = REG.role INNER JOIN dbo.tbl_tbtpns_app AS APP ON REG.appid = APP.appid INNER JOIN dbo.tbl_tbtpns_msggroup AS GRP ON ITEM.msggroup_id = GRP.msggroup_id WHERE APP.clienttype = 'ios' AND ITEM.resultcode < 200 AND ITEM.msggroup_id = 2", "iOS, �׷�MSG(id=2) ���"
		showSQL "SELECT TOP 1000 ITEM.*, APP.clienttype, REG.appid, REG.regkey FROM dbo.tbl_tbtpns_msgitem AS ITEM INNER JOIN dbo.tbl_tbtpns_register AS REG ON ITEM.receiver_regid = REG.regid AND ITEM.receiver_userid = REG.userid AND ITEM.receiver_role = REG.role INNER JOIN dbo.tbl_tbtpns_app AS APP ON REG.appid = APP.appid INNER JOIN dbo.tbl_tbtpns_msggroup AS GRP ON ITEM.msggroup_id = GRP.msggroup_id WHERE APP.clienttype = 'android' AND ITEM.resultcode < 200 AND ITEM.msggroup_id = 2", "Android, �׷�MSG(id=2) ���"

		describeTables

	End Function

	Function WEB_METHOD_truncate

		'truncateTable "tbl_tbtpns_app"
		'truncateTable "tbl_tbtpns_register"
		truncateTable "tbl_tbtpns_msggroup"
		truncateTable "tbl_tbtpns_msgitem"

	End Function

' End Class  ''''''''''''''''''''''''''''''''''''''''''''''''''''''''






dim refIP : refIP = Request.ServerVariables("REMOTE_ADDR")
dim method : method = requestCheckvar(Request("method"), 100)
if ( method = "" ) then
	WEB_METHOD_error
elseif ( method = "register" ) then
	WEB_METHOD_register
elseif ( method = "regmsg" ) then
	WEB_METHOD_regmsg
elseIf ( method = "test" ) Then
	WEB_METHOD_test
ElseIf ( method = "show" ) Then
	WEB_METHOD_show
ElseIf ( method = "truncate" ) Then
	WEB_METHOD_truncate
end If




%>



<!-- #include virtual="/lib/db/dbAppNoticlose.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->
