<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 잠자는 사자를 깨워라! 휴먼계정 고객 대상 event
' History : 2015.08.06 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
Dim vTotalCount , vTotalCount2 , vQuery , allcnt, buttongubun
dim userid, sqlstr, refer , mode , preCode, eCode, currenttime
Dim reqname , reqhp1 , reqhp2 , reqhp3 , txZip1 ,  txZip2 , txAddr1 , txAddr2
Dim zipcode , usercell
	mode	= requestcheckvar(request("mode"),4)
	buttongubun	= requestcheckvar(request("buttongubun"),1)
	reqname	= requestcheckvar(request("reqname"),32)
	reqhp1	= requestcheckvar(request("reqhp1"),3)
	reqhp2	= requestcheckvar(request("reqhp2"),4)
	reqhp3	= requestcheckvar(request("reqhp3"),4)
	txZip1	= requestcheckvar(request("txZip1"),3)
	txZip2	= requestcheckvar(request("txZip2"),3)
	txAddr1	= requestcheckvar(request("txAddr1"),100)
	txAddr2	= requestcheckvar(request("txAddr2"),100)
	isApp = requestcheckvar(request("isapp"),1)

Select Case cStr(isApp)
	Case "2"
		appUrlPath = "/apps/appcom/wish/webview"
	Case "1"
		appUrlPath = "/apps/appcom/wish/web2014"
	Case Else
		appUrlPath = ""
End Select
zipcode = txZip1 &"-"& txZip2
usercell = reqhp1 &"-"& reqhp2 &"-"& reqhp3 
if buttongubun="" then buttongubun=1

IF application("Svr_Info") = "Dev" THEN
	eCode = "64845"
Else
	eCode = "65299"
End If
userid	= getloginuserid()

currenttime = now()
'currenttime = #08/10/2015 14:05:00#

dim getlimitcnt
getlimitcnt = 690

refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end If

If not( left(currenttime,10)>="2015-08-10" and left(currenttime,10)<"2015-08-15" ) Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF
If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF

'// 로그인후 휴먼고객 체크
dim totcnt
If userid <> "" Then
	vQuery = "SELECT count(*) FROM [db_user_hold].[dbo].[tbl_UHold_Target] "
	vQuery = vQuery & " WHERE userid = '"& userid &"'"

	'response.write vQuery & "<br>"
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		totcnt = rsget(0)
	End If
	rsget.close()
End If

'//태스트 계정
dim vadminconfirmyn
	vadminconfirmyn="N"
if userid="tozzinet" or userid="jinyeonmi" or userid="cogusdk" or userid="helele223" then
	vadminconfirmyn="Y"
	totcnt=1
end if

If totcnt < 1 Then
	if vadminconfirmyn="N" then
		Response.Write "<script type='text/javascript'>alert('텐바이텐에 2014년 8월 1일 부터 로그인하지 않아 휴면고객으로 분류되신 고객님들만 참여 가능합니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if
End If

If vTotalCount2 > 0 Then
	Response.Write "<script type='text/javascript'>alert('이벤트는 1회만 참여할 수 있습니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End If

'// 응모 확인
vQuery = "SELECT count(*) FROM [db_temp].[dbo].[tbl_temp_event_addr] WHERE evt_code='"&eCode&"' and userid = '" & userid & "'"

'response.write vQuery & "<br>"
rsget.Open vQuery,dbget,1
IF Not rsget.Eof Then
	vTotalCount2 = rsget(0)
End If
rsget.close()

If vTotalCount2 > 0 Then
	Response.Write "<script type='text/javascript'>alert('이벤트는 1회만 참여할 수 있습니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End If
	
'// 전체 인원수 확인
vQuery = "SELECT count(*) FROM [db_temp].[dbo].[tbl_temp_event_addr] WHERE evt_code='"&eCode&"' "

'response.write vQuery & "<br>"
rsget.Open vQuery,dbget,1
IF Not rsget.Eof Then
	allcnt = rsget(0)
End If
rsget.close()

if mode="inst" Then
	If allcnt < getlimitcnt Then
		sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_temp_event_addr](evt_code, userid, username , usercell, zipcode, addr1, addr2, device, etc1, etc2)" + vbcrlf

		if isApp=1 then
			sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '" & reqname & "' , '" & usercell & "' , '"& zipcode &"', '"& txAddr1 &"' , '"& txAddr2 &"','A','"& buttongubun &"','')" + vbcrlf
		else
			sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '" & reqname & "' , '" & usercell & "' , '"& zipcode &"', '"& txAddr1 &"' , '"& txAddr2 &"','M','"& buttongubun &"','')" + vbcrlf
		end if

		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr

		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf

		if isApp=1 then
			sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& left(currenttime,10) &"', 0, '', 'A')" + vbcrlf
		else
			sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& left(currenttime,10) &"', 0, '', 'M')" + vbcrlf
		end if

		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr

		Response.Write "<script type='text/javascript'>alert('신청이 완료되었습니다.\n사은품은 8월 14일부터 순차배송됩니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	Else
		response.write "<script type='text/javascript'>alert('죄송합니다\n본 이벤트는 한정수량으로 조기에 선착순 마감되었습니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close()
		response.end
	End If 
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->