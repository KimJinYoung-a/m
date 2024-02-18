<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  2015오픈이벤트 vipGift
' History : 2015-04-10 이종화
'###########################################################
%>
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
Dim vTotalCount, vQuery , allcnt
dim eCode, userid, sqlstr, refer , mode
Dim reqname , reqhp1 , reqhp2 , reqhp3 , txZip1 ,  txZip2 , txAddr1 , txAddr2
Dim sub_opt1 , sub_opt2 , sub_opt3

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  60744
	Else
		eCode   =  60833
	End If
	userid	= getloginuserid()
	mode	= requestcheckvar(request("mode"),4)

	reqname	= requestcheckvar(request("reqname"),32)
	reqhp1	= requestcheckvar(request("reqhp1"),3)
	reqhp2	= requestcheckvar(request("reqhp2"),4)
	reqhp3	= requestcheckvar(request("reqhp3"),4)
	txZip1	= requestcheckvar(request("txZip1"),3)
	txZip2	= requestcheckvar(request("txZip2"),3)
	txAddr1	= requestcheckvar(request("txAddr1"),100)
	txAddr2	= requestcheckvar(request("txAddr2"),100)

	sub_opt1 = reqname '//이름

	sub_opt2 = GetLoginUserLevel() '//회원등급

	sub_opt3 = reqhp1 &"-"& reqhp2 &"-"& reqhp3 &" "& txZip1 &"-"& txZip2&" "& txAddr1 &" "& txAddr2 '//주소


	refer = request.ServerVariables("HTTP_REFERER")
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "잘못된 접속입니다."
		dbget.close() : Response.End
	end if

	If userid = "" Then
		Response.Write "<script type='text/javascript'>alert('로그인을 하셔야 참여가 가능 합니다.'); parent.top.location.href='/event/eventmain.asp?eventid=61493'</script>"
		dbget.close() : Response.End
	End If

	if not(Date()>="2015-04-13" and Date()<"2015-04-25" ) then
		Response.Write "<script type='text/javascript'>alert('이벤트가 종료 되었습니다.'); parent.top.location.href='/event/eventmain.asp?eventid=61493'</script>"
		dbget.close() : Response.End
	End If

	If Not(GetLoginUserLevel = 3 Or GetLoginUserLevel = 4 ) Then
		Response.write "<script>alert('VIP 등급만 참여 하실 수 있습니다.'); parent.top.location.href='/event/eventmain.asp?eventid=61493'</script>"
		dbget.close() : Response.End
	End If

	'// 응모 확인
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' And evt_code='"&eCode&"' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		vTotalCount = rsget(0)
	End If
	rsget.close()
	
	If vTotalCount > 0 Then
		response.write "<script>alert('이벤트는 ID당 1회만 참여할 수 있습니다.'); parent.top.location.href='/event/eventmain.asp?eventid=61493'</script>"
		dbget.close()
		response.end
	End If 
	
	'// 전체 인원수 확인
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code='"&eCode&"' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		allcnt = rsget(0)
	End If
	rsget.close()

	if mode="inst" Then
		If allcnt < 7001 Then '// 7000명 제한
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '" & sub_opt1 & "' , "& sub_opt2 &" ,'"& sub_opt3 &"' , 'M')" + vbcrlf
			'response.write sqlstr & "<Br>"
			dbget.execute sqlstr

			Response.Write "<script>alert('신청이 완료 되었습니다.\n4월 27일부터 순차 발송 됩니다.'); parent.top.location.href='/event/eventmain.asp?eventid=61493'</script>"
			dbget.close() : Response.End
		Else
			response.write "<script>alert('죄송합니다\n본 이벤트는 한정수량으로 조기에 선착순 마감되었습니다.'); parent.top.location.href='/event/eventmain.asp?eventid=61493'</script>"
			dbget.close()
			response.end
		End If 
	else
		Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid=61493'</script>"
		dbget.close() : Response.End
	end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->