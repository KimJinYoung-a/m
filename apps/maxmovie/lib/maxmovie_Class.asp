<%
'// 맥스무비 경유시 맥스무비 정보 저장
Sub MaxmovieSavePara(uid,ordsn,scd)
	dim sqlStr, tempDec, maxId

	if scd<>"" then
		'맥스무비 회원ID 접수
		tempDec = Base64decode(scd)
		if instr(tempDec,";")>0 then
			'구분값을 사용한 전송일때
			tempDec = split(tempDec,";")
			maxId = tempDec(0)
		elseif len(tempDec)>=54 then
			'자릿수를 사용한 전송일때
			maxId = mid(tempDec,25,10)
		else
			'전송값 오류
			Exit Sub
		end if

		'주문정보 저장
		if maxId<>"" then
			'중복검사
			sqlStr  = "Select count(*) from db_temp.dbo.tbl_maxmovieOrderInfo Where orderserial=" & ordsn
			rsget.Open sqlStr,dbget,1
			if rsget(0)=0 then
				'저장
				sqlStr = "Insert into db_temp.dbo.tbl_maxmovieOrderInfo " &_
					"	(sCode, MaxmovieID, userid, orderserial) values " &_
					"	('" & scd & "'" &_
					"	,'" & maxId & "'" &_
					"	,'" & uid & "'" &_
					"	,'" & ordsn & "')"
				dbget.Execute(sqlStr)
			end if
			rsget.Close
		end if
	end if
end Sub

'// 상태변경(사용안함)
Sub MaxmovieStateUpdate(scd,ordsn,st)
	dim sqlStr
	sqlStr = "Update db_temp.dbo.tbl_maxmovieOrderInfo " &_
		"	Set [state]='" & st & "'" &_
		"	Where sCode='" & scd & "'" &_
		"		and orderserial='" & ordsn & "'"
	dbget.Execute(sqlStr)
end Sub

'// 맥스무비 강냉이 지급(사용안함)
Function MaxmovieGiveCorn(ordsn)
	dim sqlStr
	'맥스무비 주문건 확인
	sqlStr = "Select Top 1 sCode, userid, totalOrderPrice " &_
			" From db_temp.dbo.tbl_maxmovieOrderInfo " &_
			" Where orderserial='" & ordsn & "'" &_
			"	and [state]=0 "
	rsget.Open sqlStr,dbget,1

	if Not(rsget.EOF or rsget.BOF) then
		MaxmovieGiveCorn = transMaxmovieCorn(rsget("sCode"),rsget("userid"),ordsn,rsget("totalOrderPrice"))
	end if

	rsget.Close
End Function


'// 맥스무비 페이지에 강냉이 지급요청 POST값 전송(사용안함)
Function transMaxmovieCorn(scd,uid,ordsn,ordprice)
	dim oXML, rcd

	rcd = uid & ";" & ordsn & ";" & ordprice
	rcd = Base64encode(rcd)

	'// POST로 전송
	'네이트온측 알림정보 전달
	set oXML = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")	'xmlHTTP컨퍼넌트 선언
	oXML.open "POST", "http://www.maxmovie.com/event/corn_save_proc.asp", false
	oXML.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
	oXML.send "sCode=" & scd & "&rCode=" & rcd		'파라메터 전송

	'결과값에 따른 처리
	Select Case oXML.responseText
		Case "MSG = COMMIT<Br>"
			'성공
			Call MaxmovieStateUpdate(scd,ordsn,"1")
			transMaxmovieCorn = "1"
		Case "MSG = ALREADY_ID<Br>"
			'이미 등록된 주문번호
			Call MaxmovieStateUpdate(scd,ordsn,"2")
			transMaxmovieCorn = "2"
		Case Else
			' "PARAMETER_ERROR" - 파라메터 부족
			' "PARAMETER_NULL" - 파마메터에 Null 전송
			' "KEY_FAIL" - 키값없음
			transMaxmovieCorn = "0"
	End Select

	Set oXML = Nothing	'컨퍼넌트 해제
End Function
%>