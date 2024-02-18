<!-- #include virtual="/apps/nateon/lib/coticket.asp"-->
<%
'// 상수 지정
dim tenEncKey	'암/복호화 키(Nateon 제공)
tenEncKey = "$#10X10*!"

'// 클래스 아이템
class CNateonAlarmItem
	Private Sub Class_Initialize()
	End Sub

	Private Sub Class_Terminate()
	End Sub
end Class

'// 네이트온 알림 클래스
class CNateonAlarm
	public FRectUserID
	public FRectNateID

	'// 연동된 회원의 비번 접수
	public function getLinkUserTenPass()
		dim sqlStr

		sqlStr = "select Enc_userpass64 " &_
				" from db_my10x10.dbo.tbl_nateon_sync as N " &_
				" 	join db_user.dbo.tbl_logindata as L " &_
				" 		on N.ten_userid=L.userid " &_
				" where [status]='1' " &_
				" 	and N.nateon_id='" & FRectNateID & "' " &_
				" 	and N.ten_userid='" & FRectUserID & "'"
		rsget.Open sqlStr,dbget,1

		if Not rsget.Eof then
			getLinkUserTenPass = rsget("Enc_userpass64")
		end if
		rsget.Close
	End function

	'// 텐바이텐 회원인지 확인
	public function getTenUserCheck()
		dim sqlStr

		sqlStr = "select count(userid) as cnt " &_
				" from db_user.dbo.tbl_logindata " &_
				" where userid='" & FRectUserID & "'"
		rsget.Open sqlStr,dbget,1

		if rsget("cnt")>0 then
			getTenUserCheck = true
		else
			getTenUserCheck = false
		end if

		rsget.Close
	End function

	'// 연동 회원인지 확인
	public function getRelateUserCheck()
		dim sqlStr

		sqlStr = "select count(ten_userid) as cnt " &_
				" from db_my10x10.dbo.tbl_nateon_sync " &_
				" where ten_userid='" & FRectUserID & "'" &_
				"	and nateon_id='" & FRectNateID & "'"
		rsget.Open sqlStr,dbget,1

		if rsget("cnt")>0 then
			getRelateUserCheck = true
		else
			getRelateUserCheck = false
		end if

		rsget.Close
	End function

	Private Sub Class_Initialize()
	End Sub

	Private Sub Class_Terminate()
	End Sub
end Class

'// 날짜형식 변환(yyyymmddhhmiss -> 날짜형)
Function covDatetime(dt)
	if Not(dt="" or isNull(dt)) then
		if len(dt)=14 and isNumeric(dt) then
			covDatetime = dateserial(left(dt,4),mid(dt,5,2),mid(dt,7,2)) & " " & mid(dt,9,2) & ":" & mid(dt,11,2) & ":" & right(dt,2) & ".000"
		else
			covDatetime = ""
			exit function
		end if
	else
		covDatetime = ""
		exit function
	end if
End Function

'// 네이트온 알리미 확인 및 알림발송
Sub NateonAlarmCheckMsgSend(uid,arid,ordsn)
	dim sqlStr, strChk
	'네이트온 연동 확인
	sqlStr = "Select t1.nateon_id " &_
			" from db_my10x10.dbo.tbl_nateon_sync as t1 " &_
			" 	Join db_my10x10.dbo.tbl_nateon_alarm as t2 " &_
			" 		on t1.ten_userid=t2.ten_userid " &_
			" 			and t1.nateon_id=t2.nateon_id " &_
			" where t1.ten_userid='" & uid & "' " &_
			" 	and t2.alarm_id=" & arid &_
			" 	and t1.[status]=1 "
	rsget.Open sqlStr,dbget,1

	if Not(rsget.EOF or rsget.BOF) then
		Do Until rsget.EOF
			call transNateAlarmMsg(rsget("nateon_id"), arid, ordsn)
			rsget.MoveNext
		Loop
	end if

	rsget.Close
End Sub

'// 네이트온 알리미 확인 및 연동해제
Sub NateonAlarmCheckTerminate(uid)
	dim sqlStr, strChk
	'네이트온 연동 확인
	sqlStr = "Select nateon_id from db_my10x10.dbo.tbl_nateon_sync " &_
			" where ten_userid='" & uid & "'"
	rsget.Open sqlStr,dbget,1

	if Not(rsget.EOF or rsget.BOF) then
		Do Until rsget.EOF
			call transNateTerminate(rsget("nateon_id"), uid)
		rsget.MoveNext
		Loop
	end if

	rsget.Close
End Sub


'// 네이트온 페이지에 알림 메시지 POST값 전송
Sub transNateAlarmMsg(cmn,arid,ordsn)
	dim ticket, ticketVal, oXML
	dim strSubject, strCont, rUrl

	'// 알람 종류에 따른 구분
	Select Case arid
		Case "165"			'배송정보 알림
			strSubject = "배송정보 도착"
			strCont = "텐바이텐에서 배송이 시작되었습니다."
		Case "166"			'결제정보 알림
			strSubject = "결제정보 알림"
			strCont = "텐바이텐에서 결제가 완료되었습니다."
		Case Else
			Exit Sub
	End Select

	'이동 URL 지정
	if ordsn="" then
		rUrl = wwwUrl & "/my10x10/order/myorderlist.asp"
	else
		rUrl = wwwUrl & "/my10x10/order/myorderdetail.asp?idx=" & ordsn
	end if

	'// 암호화 처리
	Set ticket = New CoTicket
	ticket("alarm_id") = arid
	ticket("receiver") = cmn
	ticket("flag_all") = "N"
	ticket("subject") = strSubject
	ticket("content") = strCont
	ticket("r_url") = rUrl
	ticketVal = ticket.GetTicket(tenEncKey, 120)		'암호키 설정
	Set ticket = Nothing

	'// POST로 전송
	'네이트온측 알림정보 전달
	set oXML = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")	'xmlHTTP컨퍼넌트 선언
	oXML.open "POST", "http://nateonalarm.nate.com/interface/send_alarm.php", false
	oXML.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
	oXML.send "service_id=30&value=" & ticketVal	'파라메터 전송
	'Response.write oXML.responseText & "<br>"
	Set oXML = Nothing	'컨퍼넌트 해제
End Sub


'// 페이지에 탈퇴 POST값 전송
Sub transNateTerminate(cmn,uid)
	dim ticket, ticketVal, oXML

	'// 암호화 처리
	Set ticket = New CoTicket
	ticket("cmn") = cmn
	ticket("unique_key") = uid
	ticketVal = ticket.GetTicket(tenEncKey, 120)		'암호키 설정
	Set ticket = Nothing

	'// POST로 전송
	'네이트온측 해제정보 전달
	set oXML = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")	'xmlHTTP컨퍼넌트 선언
	oXML.open "POST", "http://nateonalarm.nate.com/interface/terminate_relation.php", false
	oXML.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
	oXML.send "service_id=30&value=" & ticketVal	'파라메터 전송
	'Response.write oXML.responseText & "<br>"
	Set oXML = Nothing	'컨퍼넌트 해제
End Sub

%>