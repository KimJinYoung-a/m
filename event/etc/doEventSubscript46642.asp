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
		eCode 		= "21002"
	Else
		eCode 		= "46611"
	End If

	result = requestCheckVar(Request("result"),1)		'�̺�Ʈ �ڵ�
	loginid = GetLoginUserID()
	If result= "" then result=0

	'// �̺�Ʈ �Ⱓ Ȯ�� //
'	sqlStr = "Select evt_startdate, evt_enddate " &_
'			" From db_event.dbo.tbl_event " &_
'			" WHERE evt_code='" & eCode & "'"
'	rsget.Open sqlStr,dbget,1
'	if rsget.EOF or rsget.BOF then
'		Response.Write	"<script language='javascript'>" &_
'						"alert('�������� �ʴ� �̺�Ʈ�Դϴ�.');" &_
'						"</script>"
'		dbget.close()	:	response.End
'	elseif date<rsget("evt_startdate") or date>rsget("evt_enddate") then
'		Response.Write	"<script language='javascript'>" &_
'						"alert('�˼��մϴ�. �̺�Ʈ �Ⱓ�� �ƴմϴ�.');" &_
'						"</script>"
'		dbget.close()	:	response.End
'	end if
'	rsget.Close

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
	If result = 1 then	'���ã�� �߰��� 3000�� ��������
		if ((date()>="2013-11-08") and (date()=<"2013-11-24")) Then
			sqlStr = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & loginid & "' AND masteridx = '488') " & vbCrlf
			sqlStr = sqlStr & "BEGIN " & vbCrlf
			sqlStr = sqlStr & "insert into [db_user].[dbo].tbl_user_coupon" + vbCrlf
			sqlStr = sqlStr + " (masteridx,userid,couponvalue,coupontype,couponname,minbuyprice," + vbCrlf
			sqlStr = sqlStr + " targetitemlist,startdate,expiredate)" + vbCrlf
			sqlStr = sqlStr + " values(488,'" + loginid + "',3000,'2','[���Ի���� �Ǽ��� ���� �̺�Ʈ] ��������',20000," + vbCrlf
			sqlStr = sqlStr + " '','2013-11-13 00:00:00' ,'2013-11-24 23:59:59')" + vbCrlf
			sqlStr = sqlStr & "END " & vbCrlf

			dbget.execute(sqlStr)


		end If
	elseif result = 2 then	'���̽��� ��ũ 5000�� ��������
		if ((date()>="2013-11-08") and (date()=<"2013-11-24")) Then
			sqlStr = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & loginid & "' AND masteridx = '489') " & vbCrlf
			sqlStr = sqlStr & "BEGIN " & vbCrlf
			sqlStr = sqlStr & "insert into [db_user].[dbo].tbl_user_coupon" + vbCrlf
			sqlStr = sqlStr + " (masteridx,userid,couponvalue,coupontype,couponname,minbuyprice," + vbCrlf
			sqlStr = sqlStr + " targetitemlist,startdate,expiredate)" + vbCrlf
			sqlStr = sqlStr + " values(489,'" + loginid + "',5000,'2','[���Ի���� �Ǽ��� ���� �̺�Ʈ] ��������',40000," + vbCrlf
			sqlStr = sqlStr + " '','2013-11-13 00:00:00' ,'2013-11-24 23:59:59')" + vbCrlf
			sqlStr = sqlStr & "END " & vbCrlf

			dbget.execute(sqlStr)

			resulthtml = "<img src='http://webimage.10x10.co.kr/eventIMG/2013/46611/46611_evt_cont01_click.png' alt='���� ���� �����Űſ���?' />"

		end If
	elseif result = 3 then

	elseif result = 4 then

	else
		response.write "<script>location.href='/event/eventmain.asp?eventid=21007'</script>"

	End If

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

If int(opt1) + int(opt2) + int(opt3) + int(opt4) = 10 then
response.write "<script>parent.document.getElementById('resultok').style.display='block';"
response.write "parent.document.getElementById('resultno').style.display='none';"
response.write "</script>"

	 'response.write "<script>parent.location.replace('/event/etc/iframe_46611.asp');</script>"
	 'response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->