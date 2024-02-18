<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  꽃을 든 무민(하나은행제휴 이벤트)
' History : 2017-05-11 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
Dim vTotalCount , vTotalCount2 , vQuery , allcnt, vDeviceGn
dim eCode, userid, sqlstr, refer , mode
Dim reqname , reqhp1 , reqhp2 , reqhp3 , txZip , txAddr1 , txAddr2, hanacode, hanacodeCount, l1hanacode ,r2hanacode
Dim zipcode , usercell, myaddridx, amode
Dim urlchg

	IF application("Svr_Info") = "Dev" THEN
		eCode		=  66323
	Else
		eCode		=  77767
	End If

	userid	= GetEncLoginUserID()
	mode	= requestcheckvar(request("mode"),4)
	amode	= requestcheckvar(request("amode"),4)
	reqname	= requestcheckvar(request("reqname"),32)
	reqhp1	= requestcheckvar(request("reqhp1"),3)
	reqhp2	= requestcheckvar(request("reqhp2"),4)
	reqhp3	= requestcheckvar(request("reqhp3"),4)
	txZip	= requestcheckvar(request("txZip"),10)
	txAddr1	= requestcheckvar(request("txAddr1"),100)
	txAddr2	= requestcheckvar(request("txAddr2"),100)
	hanacode= requestcheckvar(request("hanacode"),11)
	myaddridx = requestcheckvar(request("myaddridx"),6)

	l1hanacode = trim(left(hanacode,1))
	r2hanacode = trim(right(hanacode,2))

	zipcode = txZip
	usercell = reqhp1 &"-"& reqhp2 &"-"& reqhp3 

	If isApp="1" Then
		vDeviceGn = "A"
	Else
		vDeviceGn = "M"
	End If

	refer = request.ServerVariables("HTTP_REFERER")
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		dbget.close() : Response.End
	end If

	if Not(Now() > #05/15/2017 00:00:00# And Now() < #07/30/2017 23:59:59#) then											'''''''''''''''''''''''''''날짜 체크
		Response.Write "Err|이벤트 기간이 아닙니다."
		dbget.close() : Response.End
	End If

	If userid = "" Then
		Response.Write "Err|로그인 후 참여하실 수 있습니다."
		dbget.close() : Response.End
	End If

	if amode <> "edit" then
		''ID당 1회 신청 제한
		vQuery = ""
		vQuery = "SELECT count(*) FROM [db_temp].[dbo].[tbl_temp_event_addr] WHERE userid = '" & userid & "' And evt_code ="& eCode &" "
		rsget.Open vQuery,dbget,1
		IF Not rsget.Eof Then
			vTotalCount2 = rsget(0)
		End If
		rsget.close()

		if l1hanacode <> "9" Then
			Response.Write "Err|정확한 코드를 입력해 주세요."
			dbget.close() : Response.End
		end if

		if r2hanacode <> "21" and r2hanacode <> "22" and r2hanacode <> "23" and r2hanacode <> "24" and r2hanacode <> "25"  Then
			Response.Write "Err|정확한 코드를 입력해 주세요."
			dbget.close() : Response.End
		end if

		If vTotalCount2 > 0 Then
			Response.Write "Err|이벤트는 ID당 1회만 참여할 수 있습니다."
			dbget.close() : Response.End
		End If 

		''신청된 하나코드인지 체크
		vQuery = ""
		vQuery = "SELECT count(*) FROM [db_temp].[dbo].[tbl_temp_event_addr] WHERE etc2 ='"& hanacode &"' "
		rsget.Open vQuery,dbget,1
		IF Not rsget.Eof Then
			hanacodeCount = rsget(0)
		End If
		rsget.close()

		If hanacodeCount > 0 Then
			Response.Write "Err|정확한 코드를 입력해 주세요."
			dbget.close() : Response.End
		End If

		'// 전체 인원수 확인
		vQuery = "SELECT count(*) FROM [db_temp].[dbo].[tbl_temp_event_addr] WHERE evt_code ="& eCode &" "
		rsget.Open vQuery,dbget,1
		IF Not rsget.Eof Then
			allcnt = rsget(0)
		End If
		rsget.close()
	end if

	if mode="inst" Then
		If zipcode = ""  or isNull(zipcode) Then
			Response.Write "Err|주소를 다시 확인해 주세요"
			dbget.close() : Response.End
		End If

		If txAddr1 = ""  or isNull(txAddr1) Then
			Response.Write "Err|주소를 다시 확인해 주세요"
			dbget.close() : Response.End
		End If
		
		If txAddr2 = ""  or isNull(txAddr2) Then
			Response.Write "Err|주소를 다시 확인해 주세요"
			dbget.close() : Response.End
		End If

		if amode = "edit" then
			if myaddridx <> "" then

				sqlstr = ""
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1 , sub_opt2, sub_opt3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '" & hanacode & "', '" & myaddridx & "', '" & amode & "' , '" & vDeviceGn & "' )" + vbcrlf	
	'			response.write "Err|"& sqlstr
				dbget.execute sqlstr

				sqlStr = "update [db_temp].[dbo].[tbl_temp_event_addr] set username = '"& reqname & "' ,usercell = '"& usercell & "' ,zipcode = '"& zipcode & "' ,addr1 = '"& txAddr1 & "' ,addr2 = '"& txAddr2 & "' where userid = '" & userid & "' and evt_code = " & eCode & " and idx = " & myaddridx & " "
				dbget.execute sqlstr

				Response.write "OK|dn"
				dbget.close()	:	response.End
			Else
				Response.Write "Err|입력한 데이터가 없습니다. 고객센터에 문의해 주세요."
				dbget.close()	:	response.End
			end if
		Else
			If allcnt < 27946 Then '// 27946 제한
				sqlstr = ""
				sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_temp_event_addr](evt_code, userid, username , usercell, zipcode, addr1, addr2 , etc2, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '" & reqname & "' , '" & usercell & "' , '"& zipcode &"', '"& txAddr1 &"' , '"& txAddr2 &"', '"& hanacode &"' , '"& vDeviceGn&"')" + vbcrlf	
	'			response.write "Err|"& sqlstr
				dbget.execute sqlstr

				sqlstr = ""
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1 , device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '" & hanacode & "' , '" & vDeviceGn & "' )" + vbcrlf	
	'			response.write "Err|"& sqlstr
				dbget.execute sqlstr

				sqlstr = ""
				sqlstr = " UPDATE [db_user].[dbo].tbl_user_n" & VbCrlf
				sqlstr = sqlstr & " SET " & VbCrlf
				sqlstr = sqlstr & " zipcode='" + zipcode + "'" & VbCrlf
				sqlstr = sqlstr & " ,useraddr='" + txAddr2 + "'" & VbCrlf
				sqlstr = sqlstr & " ,zipaddr='" + txAddr1 + "'" & VbCrlf
				sqlstr = sqlstr & " where userid='" + userid + "'"
				dbget.execute sqlstr

				Response.write "OK|dn"
				dbget.close()	:	response.End
			Else
				Response.Write "Err|한정수량으로 조기 소진되었습니다."
				dbget.close()	:	response.End
			End If
		End If

	elseif mode="frin" Then
		If allcnt < 27946 Then '// 27946 제한
			Response.write "OK|frin"
			dbget.close()	:	response.End
		Else
			Response.Write "Err|한정수량으로 조기 소진되었습니다."
			dbget.close()	:	response.End
		End If
	else
		Response.write "Err|정상적인 경로로 참여해주시기 바랍니다."
		dbget.close()	:	response.End
	end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->