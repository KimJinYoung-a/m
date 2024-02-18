<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  감사선물 VIP GIFT
' History : 2017-12-18 정태훈 생성
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
dim eCode, userid, sqlstr, refer , mode , preCode
Dim reqname , reqhp1 , reqhp2 , reqhp3 , txZip , txAddr1 , txAddr2
Dim zipcode , usercell, CheckUserid
Dim urlchg

	IF application("Svr_Info") = "Dev" THEN
		preCode		=  0 '//지난 이벤트
		eCode		=  68516
	Else
		preCode		=  0 '//지난 이벤트
		eCode		=  85916
	End If

	userid	= GetEncLoginUserID()
	mode	= requestcheckvar(request("mode"),4)

	reqname	= requestcheckvar(request("reqname"),32)
	reqhp1	= requestcheckvar(request("reqhp1"),3)
	reqhp2	= requestcheckvar(request("reqhp2"),4)
	reqhp3	= requestcheckvar(request("reqhp3"),4)
	txZip	= requestcheckvar(request("txZip"),10)
	txAddr1	= requestcheckvar(request("txAddr1"),100)
	txAddr2	= requestcheckvar(request("txAddr2"),100)

	zipcode = txZip
	usercell = reqhp1 &"-"& reqhp2 &"-"& reqhp3 

	If isApp="1" Then
		vDeviceGn = "A"
	Else
		vDeviceGn = "M"
	End If

	refer = request.ServerVariables("HTTP_REFERER")
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "잘못된 접속입니다."
		dbget.close() : Response.End
	end If

	If isapp = "1" Then
		urlchg = "top.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode &""
	Else
		urlchg = "parent.top.location.href='/event/eventmain.asp?eventid="& eCode &""
	End If 
	
	If Not(Now() > #04/16/2018 00:00:00# And Now() < #12/31/2018 23:59:59#) Then
		Response.Write "<script>alert('이벤트가 종료 되었습니다.'); "& urlchg &"'</script>"
		dbget.close() : Response.End
	End If

	If userid = "" Then
		Response.Write "<script>alert('로그인을 해야 이벤트에 참여할 수 있어요.'); "& urlchg &"'</script>"
		dbget.close() : Response.End
	End If

	'//대상자 확인
	vQuery = "SELECT userid FROM [db_temp].[dbo].[tbl_event_85916] WHERE userid = '" & GetEncLoginUserID & "'"
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		CheckUserid = rsget(0)
	End If
	rsget.close()

	If (CheckUserid <> userid) Then
		Response.write "<script>alert('이벤트는 대상이 아닙니다.\n텐바이텐 체크카드 발급 후 3만원 이상 결제한 고객만 참여하실 수 있습니다.'); "& urlchg &"'</script>"
		dbget.close() : Response.End
	End If

	'// 응모 확인 - 이번 회차
	vQuery = "SELECT count(*) FROM [db_temp].[dbo].[tbl_temp_event_addr] WHERE userid = '" & userid & "' And evt_code = '"& eCode & "'"
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		vTotalCount2 = rsget(0)
	End If
	rsget.close()

	If vTotalCount2 > 0 Then
		response.write "<script>alert('이벤트는 ID당 1회만 참여할 수 있습니다.'); "& urlchg &"'</script>"
		dbget.close()
		response.end
	End If 

	'// 전체 인원수 확인
	vQuery = "SELECT count(*) FROM [db_temp].[dbo].[tbl_temp_event_addr] WHERE evt_code='"& eCode &"'"
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		allcnt = rsget(0)
	End If
	rsget.close()

	if mode="inst" Then
		If allcnt < 1000 Then '// 4000 제한
			sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_temp_event_addr](evt_code, userid, username , usercell, zipcode, addr1, addr2, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '" & reqname & "' , '" & usercell & "' , '"& zipcode &"', '"& txAddr1 &"' , '"& txAddr2 &"', '"&vDeviceGn&"')" + vbcrlf
			'response.write sqlstr & "<Br>"
			dbget.execute sqlstr

			Response.Write "<script>alert('신청이 완료 되었습니다.'); "& urlchg &"'</script>"
			dbget.close() : Response.End
		Else
			response.write "<script>alert('한정 수량으로 조기 소진되었습니다.'); "& urlchg &"'</script>"
			dbget.close()
			response.end
		End If 
	else
		Response.Write "<script>alert('정상적인 경로가 아닙니다.'); "& urlchg &"'</script>"
		dbget.close() : Response.End
	end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->