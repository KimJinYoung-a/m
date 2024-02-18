<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.contentType = "text/html; charset=UTF-8"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	dim sqlStr, loginid, evt_code, releaseDate, kakaomsg , refip , mode , masteridx
	evt_code = requestCheckVar(Request("eventid"),32)		'이벤트 코드
	kakaomsg = requestCheckVar(Request("kakaomsg"),200)		'이벤트 코드
	loginid = GetLoginUserID()
	releaseDate = requestCheckVar(Request("releaseDate"),42)
	mode = requestCheckVar(Request("mode"),5)		'이벤트 코드
	if releaseDate="" then releaseDate = "8월 23일에"
	refip = request.ServerVariables("REMOTE_ADDR")

	IF application("Svr_Info") = "Dev" THEN
		masteridx = 266
	Else
		masteridx = 447
	End If

	
	'// 이벤트 기간 확인 //
	sqlStr = "Select evt_startdate, evt_enddate " &_
			" From db_event.dbo.tbl_event " &_
			" WHERE evt_code='" & evt_code & "'"
	rsget.Open sqlStr,dbget,1
	if rsget.EOF or rsget.BOF then
		Response.Write	"<script language='javascript'>" &_
						"alert('존재하지 않는 이벤트입니다.');" &_
						"</script>"
		dbget.close()	:	response.End
	elseif date<rsget("evt_startdate") or date>rsget("evt_enddate") then
		Response.Write	"<script language='javascript'>" &_
						"alert('죄송합니다. 이벤트 기간이 아닙니다.');" &_
						"</script>"
		dbget.close()	:	response.End
	end if
	rsget.Close

	'// 로그인 여부 확인 //
	if loginid="" or isNull(loginid) then
		Response.Write	"<script language='javascript'>" &_
						"alert('이벤트에 응모를 하려면 로그인이 필요합니다.');" &_
						"top.location.href='/login/login.asp?backpath=" & RefURLQ() & "';" &_
						"</script>"
		dbget.close()	:	response.End
	end If
	
	If mode = "enter" then
		'응모하기
		dim mysum , strSql
		strSql="select count(*) from db_event.dbo.tbl_event_subscript where evt_code='" & evt_code & "' and userid='" & loginid & "' and datepart(hh,regdate) = datepart(hh,getdate()) and datepart(dd,regdate) = datepart(dd,getdate())"
		rsget.Open strSql,dbget,1
		mysum = rsget(0)
		rsget.Close

'		response.write strSql &"<br>"
'		response.write mysum &"<br>"
'		response.end

		if mysum > 0 then
				response.write "<script>alert('한시간에 한번 응모가능합니다.');</script>"
				response.write "<script>parent.history.go(0);</script>"
				dbget.close()	:	response.End
		End If

		'입력 프로세스
		strSql = ""
		strSql = strSql & "Insert into db_event.dbo.tbl_event_subscript " & vbcrlf
		strSql = strSql & "(evt_code, userid, regdate) " & vbcrlf
		strSql = strSql & "VALUES " & vbcrlf
		strSql = strSql & "('"& evt_code &"','"&loginid&"', getdate()) "

		dbget.execute(strSql)
		Response.Write  "<script>" &_
						"alert('응모되었습니다.');" &_
						"parent.history.go(0);" &_
						"</script>"

	ElseIf mode = "free" Then '무료배송쿠폰
	
		Dim cnt, addsql, addinsert

		If (hour(time) >= 12 AND hour(time) <= 24) Then
			addsql = "and convert(varchar(10),startdate,120) = convert(varchar(10),getdate(),120) and convert(varchar(10),expiredate,120) = convert(varchar(10),dateadd(d,1,getdate()),120)"
			addinsert = ",convert(varchar(10),getdate(),21) + ' 12:00:00',convert(varchar(10),dateadd(d,1,getdate()),21) + ' 11:59:59','',0,'system'"
		Else
			addsql = "and convert(varchar(10),expiredate,120) = convert(varchar(10),getdate(),120) and convert(varchar(10),startdate,120) = convert(varchar(10),dateadd(d,-1,getdate()),120)"
			addinsert = ",convert(varchar(10),dateadd(d,-1,getdate()),21) + ' 12:00:00', convert(varchar(10),getdate(),21) + ' 11:59:59','',0,'system'"
		End If

		sqlStr = "Select count(idx) " &_
				" From db_user.dbo.tbl_user_coupon " &_
				" WHERE masteridx='" & masteridx & "'" &_
				" and userid='" & loginid & "'" & addsql
		rsget.Open sqlStr,dbget,1

		cnt = rsget(0)
		rsget.Close
		If cnt >= 1 Then
			response.write "<script type='text/javascript'>" &_
							"alert('쿠폰 다운은 한 번만 가능합니다.');" &_
							"top.location.href='/event/eventmain.asp?eventid="&evt_code&"';" &_
							"</script>"
		else
			sqlStr = "insert into db_user.dbo.tbl_user_coupon " &_
					" (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid) " &_
					" select '"& masteridx &"','" & loginid & "','3','2000','8월 또닥 이벤트 무료배송권','10000'" & addinsert

			dbget.execute(sqlStr)
				response.write "<script type='text/javascript'>" &_
					"alert('쿠폰 다운이 완료 되었습니다..\n8월 21일 오후12시부터 8월 22일 오후 12시까지만 사용 가능 합니다.');" &_
					"top.location.href='/event/eventmain.asp?eventid="&evt_code&"';" &_
					"</script>"
			dbget.close()	:	response.End
		End If

	Else
			'카카오메시지 발송응모
		sqlStr = "Insert into [db_event].[dbo].[tbl_event_comment] " &_
				" (evt_code, userid, evtcom_txt , refip) values " &_
				" (" & evt_code &_
				",'" & loginid & "'" &_
				",'" & kakaomsg & "'" &_
				",'" & refip & "')"
		dbget.execute(sqlStr)
		Response.Write	"<script>" &_	
						"alert('이벤트에 응모되었습니다.\n\n※당첨자는 " & releaseDate & " 발표합니다.');" &_
						"parent.history.go(0);" &_
						"</script>" &_
						"<div id='suc' value='Y'></div>"
	End If 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->