<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : ##10원의 마술상(app)
' History : 2016-03-24 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim eCode, userid, sqlstr, mode, vLinkECode , vTotalCount, md5userid, RvchrNum, LoginUserid
Dim evtUserCell, refer, refip, device, vQuery, strsql, toDayDate, eventitemid, couponidx, snsno, vPstNum, vRvConNumSt, vRvConNumEd, result1, result2, RvConNum
	
	refip = Request.ServerVariables("REMOTE_ADDR")
	refer = request.ServerVariables("HTTP_REFERER")
	userid = getEncLoginUserID
	mode = requestcheckvar(request("mode"),32)
	snsno = requestcheckvar(request("snsno"),32)
	evtUserCell = get10x10onlineusercell(userid) '// 참여한 회원 핸드폰번호

	'// 해당일자
	toDayDate = Left(now(), 10)


	device = "M"


	'// 바로 접속시엔 오류 표시
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		Response.End
	end If

	'// expiredate
	If not(toDayDate>="2016-03-28" and toDayDate<"2016-04-02") Then
		Response.Write "Err|이벤트 응모 기간이 아닙니다."
		Response.End
	End If

	'// 3월 28일만 10시부터 응모 가능함, 그 이후에는 0시 기준으로 응모가능
	If Left(Now(), 10) = "2016-03-28" Then
		If Not(TimeSerial(Hour(Now()), minute(Now()), second(Now())) >= TimeSerial(10, 00, 00) And TimeSerial(Hour(Now()), minute(Now()), second(Now())) < TimeSerial(23, 59, 59)) Then
			Response.Write "Err|오전 10시부터 응모하실 수 있습니다."
			Response.End
		End If
	End If


	If mode="S" Then
		sqlstr = "insert into db_log.[dbo].[tbl_caution_event_log] (evt_code, userid, refip, value1 , value2, value3, device ) values " &_
			" ('69883' " &_
			", '"& userid &"' " &_
			", '"& Left(request.ServerVariables("REMOTE_ADDR"),32) & "' " &_
			", '4' " &_
			", '"& snsno &"' " &_
			", '' " &_
			", 'A') "
		dbget.Execute sqlstr
		if snsno = "tw" then
			Response.write "tw"
		elseif snsno = "fb" then
			Response.write "fb"
		elseif snsno = "ka" then
			Response.write "ka"
		elseif snsno = "ln" then
			Response.write "ln"
		else
			Response.write "99"
		end if
		Response.End
	Else
		Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End If

%>

<!-- #include virtual="/lib/db/dbclose.asp" -->