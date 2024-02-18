<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->

<%
	Dim renloop
	randomize
	renloop = int(Rnd*100)+1
	
	If (renloop mod 2) = 1 Then
		renloop = 7
	Else
		renloop = 0
	End If
	
	dim sqlStr, loginid, evt_code, releaseDate, evt_option, evt_option2, strsql, vPreTime, vNowDate, vNowHour, vNowTime, vCount, vLinkCode, vTime(4)
	Dim kit , coupon3 , coupon5 , arrList , i, mylist, vSelectValue
	dim usermail, couponkey
	loginid = GetLoginUserID()
	vSelectValue = requestCheckVar(Request("selectvalue"),1)
	vPreTime = requestCheckVar(Request("nowtime"),2)


	IF application("Svr_Info") = "Dev" THEN
		evt_code	= "20954"
		vLinkCode	= "20955"
	Else
		evt_code	= "45262"
		vLinkCode	= "45263"
	End If

	vNowDate = date
	vNowHour = hour(now)
	
	If 0 <= vNowHour AND vNowHour <= 5 Then
		vNowTime = "1"
	ElseIf 6 <= vNowHour AND vNowHour <= 11 Then
		vNowTime = "2"
	ElseIf 12 <= vNowHour AND vNowHour <= 17 Then
		vNowTime = "3"
	ElseIf 18 <= vNowHour AND vNowHour <= 23 Then
		vNowTime = "4"
	End IF


	If vNowTime = "2" OR vNowTime = "4" Then
		Response.Write	"<script language='javascript'>top.location.href = '/event/eventmain.asp?eventid=" & vLinkCode& "';</script>"
		dbget.close()	:	response.End
	End IF

	IF CStr(vPreTime) <> CStr(vNowTime) Then
		Response.Write	"<script language='javascript'>top.location.href = '/event/eventmain.asp?eventid=" & vLinkCode& "';</script>"
		dbget.close()	:	response.End
	End IF

	'// 로그인 여부 확인 //
	if loginid="" or isNull(loginid) then
		Response.Write	"<script language='javascript'>" &_
						"alert('이벤트에 응모를 하려면 로그인이 필요합니다.');" &_
						"top.location.href='/login/login.asp?backpath=" & RefURLQ() & "';" &_
						"</script>"
		dbget.close()	:	response.End
	else
		sqlstr = "Select nowtime From db_temp.dbo.tbl_event_45262 WHERE userid='" & GetLoginUserID() & "' and isClear = 'x' "
		rsget.Open sqlStr,dbget,1
		vCount = rsget.RecordCount
	
		i = 1
		Do Until rsget.Eof
			vTime(rsget("nowtime")) = rsget("nowtime")
		i = i + 1
		rsget.MoveNext
		Loop
		rsget.Close
		
		
		'### 마일리지 4번 넘으면 더 지급 안됨.
		sqlstr = "Select count(idx) From db_temp.dbo.tbl_event_45262 WHERE userid='" & GetLoginUserID() & "' and Left(value,1) = '7' "
		rsget.Open sqlStr,dbget,1
		If rsget(0) > 3 Then
			renloop = 0
		End IF
		rsget.Close
	end If


	'응모 처리
	'중복 응모 확인
	If vTime(vNowTime) <> "" Then
		response.write "<script type='text/javascript'>" &_
					"alert('이미 미션을 완료하였습니다.\n다음 미션 타임도 잊지마세요!');" &_
					"top.location.href='/event/eventmain.asp?eventid=" & vLinkCode& "';" &_
					"</script>"
	else
		sqlStr = "Insert into db_temp.dbo.tbl_event_45262(userid, nowtime, isClear, value) values('" & loginid & "', '" & vNowTime & "', 'x', '" & CHKIIF(CStr(renloop)="7","7-"&vSelectValue,vSelectValue) & "') "
		dbget.execute(sqlStr)
		
		If vCount > 2 Then
			sqlStr = "Insert into db_event.dbo.tbl_event_subscript " &_
					" (evt_code, userid) values " &_
					" (" & evt_code &_
					",'" & loginid & "'" &_
					")"
			dbget.execute(sqlStr)
			
			sqlStr = "update db_temp.dbo.tbl_event_45262 set isClear = 'o' where userid = '" & loginid & "'"
			dbget.execute(sqlStr)
		End If
		
		If CStr(renloop) = "7" Then
			sqlStr = "update db_user.dbo.tbl_user_current_mileage " & _
					 "set bonusmileage = bonusmileage+100 " & _
					 "where userid = '" & loginid & "'" & vbCrLf & _
					 "insert into db_user.dbo.tbl_mileagelog(userid , mileage , jukyocd , jukyo , deleteyn) " & _
					 "values('" & loginid & "', '+100', 1000, '24시간이 모자라 100 마일리지 적립','N')"
			dbget.execute(sqlStr)
			
			response.write "<script type='text/javascript'>"
			If vCount > 2 Then
			response.write "alert('미션 성공! 100마일리에 당첨되셨어요!\n짝짝짝! 4가지 미션을 모두 완료하셨군요!\n한번 더 도전해볼까요?\n많이 응모할 수록 5만원 Gift 카드에 당첨될 확률도 올라가요!');"
			Else
			response.write "alert('미션 성공! 100마일리에 당첨되셨어요!\n다음 타임도 행운을 빌게요!');"
			End If
			response.write "top.location.href='/event/eventmain.asp?eventid=" & vLinkCode& "';"
			response.write "</script>"
			dbget.close()	:	response.End
		Else
			response.write "<script type='text/javascript'>"
			If vCount > 2 Then
			response.write "alert('짝짝짝! 4가지 미션을 모두 완료하셨군요!\n한번 더 도전해볼까요?\n많이 응모할 수록 5만원 Gift 카드에 당첨될 확률도 올라가요!');"
			Else
			response.write "alert('미션 성공!\n다음 미션 타임도 잊지 마세요.');"
			End If
			response.write "top.location.href='/event/eventmain.asp?eventid=" & vLinkCode& "';"
			response.write "</script>"
			dbget.close()	:	response.End
		End If
		
	End If

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->