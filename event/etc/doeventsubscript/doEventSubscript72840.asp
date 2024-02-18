<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  2016 VVIP-GIFT 이벤트 연장
' History : 2016-08-31 이종화
'###########################################################
%>
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
Dim vTotalCount , vTotalCount2 , vQuery , allcnt
dim eCode, userid, sqlstr, refer , mode , preCode
Dim reqname , reqhp1 , reqhp2 , reqhp3 , txZip , txAddr1 , txAddr2
Dim zipcode , usercell , device
Dim urlchg

	IF application("Svr_Info") = "Dev" THEN
		eCode		=  66192
	Else
		eCode		=  72840
	End If

	userid	= GetEncLoginUserID()
	mode	= requestcheckvar(request("mode"),4)

	reqname	= requestcheckvar(request("reqname"),32)
	reqhp1	= requestcheckvar(request("reqhp1"),3)
	reqhp2	= requestcheckvar(request("reqhp2"),4)
	reqhp3	= requestcheckvar(request("reqhp3"),4)
	txZip	= requestcheckvar(request("txZip"),7)
	txAddr1	= requestcheckvar(request("txAddr1"),100)
	txAddr2	= requestcheckvar(request("txAddr2"),100)

	zipcode = txZip
	usercell = reqhp1 &"-"& reqhp2 &"-"& reqhp3 

	If isapp = "1" Then 
		device = "A"
	Else
		device = "M"
	End If 

	refer = request.ServerVariables("HTTP_REFERER")
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "잘못된 접속입니다."
		dbget.close() : Response.End
	end If

	If isapp = "1" Then
		urlchg = "parent.top.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode &""
	Else
		urlchg = "parent.top.location.href='/event/eventmain.asp?eventid="& eCode &""
	End If

	Dim chkcnt , chkyn
	if userid <> "" Then
		sqlstr = "select count(userid) as cnt from db_log.[dbo].[tbl_vip_user_log] where ulevel=6 and yyyymm >= '2016-08' and userid = '"& userid &"' "
		rsget.Open sqlstr,dbget,1
			chkcnt = rsget("cnt")
		rsget.Close
	End If

	If chkcnt > 0 Then
		chkyn = True
	Else
		chkyn = False
	End If

	'//테스트용
	If userid = "helele223" Or userid = "motions" Then
		chkyn = true
	End If 
	
	if Not(Now() > #08/30/2016 00:00:00# And Now() < #09/08/2016 23:59:59#) then
		Response.Write "<script>alert('이벤트가 종료 되었습니다.1'); "& urlchg &"'</script>"
		dbget.close() : Response.End
	End If

	If userid = "" Then
		Response.Write "<script>alert('로그인을 하셔야 참여가 가능 합니다.'); "& urlchg &"'</script>"
		dbget.close() : Response.End
	End If

	If Not(chkyn = true or GetLoginUserLevel() = 6) Then
		Response.write "<script>alert('VVIP 등급만 참여 하실 수 있습니다.'); "& urlchg &"'</script>"
		dbget.close() : Response.End
	End If

	'// 응모 확인 - 이번 회차
	vQuery = "SELECT count(*) FROM [db_temp].[dbo].[tbl_temp_event_addr] WHERE userid = '" & userid & "' And evt_code='"&eCode&"' "
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
	vQuery = "SELECT count(*) FROM [db_temp].[dbo].[tbl_temp_event_addr] WHERE evt_code='"&eCode&"' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		allcnt = rsget(0)
	End If
	rsget.close()

	if mode="inst" Then
		If allcnt < 400 Then '// 400 제한
			sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_temp_event_addr](evt_code, userid, username , usercell, zipcode, addr1, addr2 , device, etc1)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '" & reqname & "' , '" & usercell & "' , '"& zipcode &"', '"& txAddr1 &"' , '"& txAddr2 &"', '"& device &"' ,'"& GetLoginUserLevel &"')" + vbcrlf
			'response.write sqlstr & "<Br>"
			dbget.execute sqlstr

			Response.Write "<script>alert('신청이 완료 되었습니다.'); "& urlchg &"'</script>"
			dbget.close() : Response.End
		Else
			response.write "<script>alert('죄송합니다\n본 이벤트는 한정수량으로 조기에 선착순 마감되었습니다.'); "& urlchg &"'</script>"
			dbget.close()
			response.end
		End If 
	else
		Response.Write "<script>alert('정상적인 경로가 아닙니다.'); "& urlchg &"'</script>"
		dbget.close() : Response.End
	end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->