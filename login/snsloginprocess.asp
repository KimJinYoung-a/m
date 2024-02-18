<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  snslogin
' History : 2017-05-15 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<!-- #include virtual="/lib/util/md5.asp" -->
<%

dim refer, sqlstr, crip
dim snsid, tokenval, mode
dim nickname, usermail, sexflag, age, isusing, tenbytenid, snsgubun, tkcnt, mysns
dim loginuserid, snscnt, snsusermail, mysnsuserid, snsmycnt, snsgubunname, snsjoingubun
Dim oJson
	'// json객체 선언
	Set oJson = jsObject()

	age			= requestcheckvar(request("age"),7)
	mode		= requestCheckVar(Request("mode"),4)
	mysns		= requestCheckVar(Request("mysns"),2)
	sexflag	= requestcheckvar(request("sexflag"),6)
	isusing	= requestcheckvar(request("isusing"),1)
	snsid		= requestcheckvar(request("snsid"),128)
	snsgubun	= requestcheckvar(request("snsgubun"),2)
	nickname	= requestcheckvar(request("nickname"),31)
	usermail	= requestcheckvar(request("usermail"),128)
	tenbytenid	= requestcheckvar(request("tenbytenid"),32)
	snsusermail= requestCheckVar(Request("snsusermail"),128)
	tokenval	= URLDecodeUTF8( html2db(request("tokenval")))
	snsjoingubun = requestcheckvar(request("snsjoingubun"),2)

	loginuserid = getEncLoginUserID()
	if snsgubun = "nv" and mysns = "my" then
		loginuserid = requestCheckVar(Request("mysnsuserid"),32)
	end if

	if snsgubun = "nv" then
		snsgubunname = "네이버"
	elseif snsgubun = "fb" then
		snsgubunname = "페이스북"
	elseif snsgubun = "ka" then
		snsgubunname = "카카오"
	elseif snsgubun = "gl" then
		snsgubunname = "구글"
	end if

	refer = request.ServerVariables("HTTP_REFERER")
	crip = request.ServerVariables("REMOTE_ADDR")
	if Not(InStr(refer,"10x10.co.kr")>0 OR crip="61.252.133.2" OR crip="110.93.128.82" OR crip="110.93.128.83" OR crip="110.93.128.84" OR crip="110.93.128.85" OR crip="110.93.128.86" OR crip="110.93.128.87" OR crip="110.93.128.88" OR crip="110.93.128.89" OR crip="110.93.128.90") then		'or crip <> "61.252.133.2" 나중에 실서버주소 다 넣어서 변경
		oJson("response") = "fail"
		oJson("faildesc") = "잘못된 접근입니다."
		oJson.flush
		dbget.close(): response.end
	end If

	if mode = "disc" then
		if loginuserid <> "" or snsgubun <> "" then
			sqlstr = "delete from [db_user].[dbo].[tbl_user_sns] where tenbytenid='"&loginuserid&"' and snsgubun='"&snsgubun&"' and isusing='Y' " + vbcrlf
	'		response.write "Err|"& sqlstr
			dbget.execute sqlstr

			'마이텐바이텐 연동 해제
			oJson("response") = "Disc"
			oJson("faildesc") = "01"
			oJson.flush
			dbget.close(): response.end
		else
			oJson("response") = "fail"
			oJson("faildesc") = "정상적인 경로로 접속해주세요."
			oJson.flush
			dbget.close(): response.end
		end if
	else
		sqlstr = "select count(*) From [db_user].[dbo].[tbl_user_sns_token] where snsid='"&snsid&"' and snsgubun='"&snsgubun&"' and snstoken='"&tokenval&"' "
		rsget.Open sqlstr, dbget, 1
			tkcnt = rsget(0)
		rsget.close

		if tkcnt = 0 then
			sqlstr = "delete from [db_user].[dbo].[tbl_user_sns_token] where snsid='"&snsid&"' and snsgubun='"&snsgubun&"'; " & vbCrLf
			sqlstr = sqlstr & "INSERT INTO [db_user].[dbo].[tbl_user_sns_token](snsid, snstoken, snsgubun)" + vbcrlf
			sqlstr = sqlstr & " VALUES( '"& snsid &"', '" & tokenval & "', '" & snsgubun & "')" + vbcrlf	
			dbget.execute sqlstr
		end if

		if mysns = "my" then
			if loginuserid <> "" then
				sqlstr = "select count(*) From [db_user].[dbo].[tbl_user_sns] Where snsid='"& snsid &"' And snsgubun='"& snsgubun &"' And isusing='Y' "	'and 	tenbytenid='"& loginuserid &"'
				rsget.Open sqlstr, dbget, 1
					snscnt = rsget(0)
				rsget.close

				if snscnt > 0 then
					oJson("response") = "fail"
'					oJson("faildesc") = "이 SNS계정은 이미 연동 되어 있습니다."
					oJson("faildesc") = "이미 다른 텐바이텐 아이디와 연동된 "&snsgubunname&" 계정입니다."
					oJson.flush
					dbget.close(): response.end
				else
					sqlstr = "select count(*) From [db_user].[dbo].[tbl_user_sns] Where tenbytenid='"& loginuserid &"' And snsgubun='"& snsgubun &"' And isusing='Y' "	'and snsid="& snsid &"
					rsget.Open sqlstr, dbget, 1
						snsmycnt = rsget(0)
					rsget.close

					if snsmycnt > 0 then
						oJson("response") = "fail"
'						oJson("faildesc") = "이 텐바이텐ID는 이미 "&snsgubunname&"계정과 연동 되어 있습니다."
						oJson("faildesc") = "이미 다른 "&snsgubunname&" 계정과 연동된 아이디입니다."
						oJson.flush
						dbget.close(): response.end
					else
						sqlstr = "insert into [db_user].[dbo].[tbl_user_sns]  (snsgubun, tenbytenid, snsid, usermail, isusing ) values " & vbCrlf
						sqlstr = sqlstr & " ( '"& snsgubun &"' " & vbCrlf
						sqlstr = sqlstr & " , '"& loginuserid &"' " & vbCrlf
						sqlstr = sqlstr & " , '"& snsid & "' " & vbCrlf
						sqlstr = sqlstr & " , '"& snsusermail &"' " & vbCrlf
						sqlstr = sqlstr & " , 'Y') " & vbCrlf
						dbget.Execute(sqlStr)

						'마이텐바이텐 연동하기
						oJson("response") = "My"
						oJson("faildesc") = "02"
						oJson.flush
						dbget.close(): response.end
					end if 
				end if
			else
				oJson("response") = "fail"
				oJson("faildesc") = "정상적인 경로로 접속해주세요."
				oJson.flush
				dbget.close(): response.end
			end if
		else
			'sns연동 설정이 되어있는경우 로그인시킴
			dim snslogincnt
			sqlStr = " select count(*)" + VbCrlf
			sqlStr = sqlStr + " from db_user.dbo.tbl_user_sns with(nolock)" + vbCrlf
			sqlStr = sqlStr + " where snsid='" + snsid + "' and isusing='Y' " + vbCrlf

			rsget.CursorLocation = adUseClient
			rsget.Open sqlStr,dbget, adOpenForwardOnly, adLockReadOnly
			if Not rsget.Eof then
				snslogincnt = rsget(0)
				if snslogincnt > 0 then
					'sns연동되있는 상태에선 걍 로그인 시킴
					oJson("response") = "Sns"
					oJson("faildesc") = "03"
					oJson.flush
					dbget.close(): response.end
				end if
			end if
			rsget.Close
		end if

		if snsjoingubun = "ji" then
			'회원가입
			oJson("response") = "Join2"
			oJson("faildesc") = "05"
			oJson.flush
			dbget.close(): response.end
		else
			'회원가입 혹은 연동하기
			oJson("response") = "Join"
			oJson("faildesc") = "04"
			oJson.flush
			dbget.close(): response.end
		end if
	end if
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->