<%
	'// 카카오톡 주문 메지시 발송 (HTTP통신)
	Sub fnKakaoChkSendMsg(ordsn)
		dim strSql, chkMsg, oXML
		if ordsn="" then Exit Sub

		'발송건 여부 확인
		strSql = "Select Count(*) from db_sms.dbo.tbl_kakao_chkSend Where orderserial='" & ordsn & "'"
		rsget.Open strSql,dbget,1
		if rsget(0)>0 then
			chkMsg = true
		else
			chkMsg = false
		end if
		rsget.Close

		'// HTTP통신으로 메시지 발송
		if chkMsg then
			Set oXML = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")
	
			oXML.open "POST", web1URL & "/apps/kakaotalk/DBSendKakaoMsg.asp", false
			oXML.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
			oXML.send "ordsn=" & ordsn
	
			Set oXML = Nothing
		end if
	End Sub

	'// 텐바이텐 휴대폰번호 변경시 신청해제 처리(HTTP통신)
	Sub fnKakaoChkModiClear(hpnum)
		dim strSql, userid, oXML
		userid = GetLoginUserID
		if hpnum="" then Exit Sub

		'발송건 여부 확인
		strSql = "Select phoneNum from db_sms.dbo.tbl_kakaoUser Where userid='" & userid & "'"
		rsget.Open strSql,dbget,1
		if Not(rsget.EOF or rsget.BOF) then

			'수정된 번호가 카카톡인증 목록과 다르면 해제
			if trim(hpnum)<>tranKorNrmPNo(rsget("phoneNum")) then

				'// HTTP통신으로 해제 처리
				Set oXML = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")
		
				oXML.open "POST", web1URL & "/apps/kakaotalk/actClearKakaoUser.asp", false
				oXML.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
				oXML.send "uid=" & userid & "&clearChk=Y"
		
				Set oXML = Nothing
			end if

		end if
		rsget.Close
	End Sub

	'// 국제번호를 국내번호로 변환
	Function tranKorNrmPNo(pno)
		Dim nNo1, nNo2, nNo3
		if len(pno)<11 then Exit Function
		if left(pno,2)<>"82" then  Exit Function

		nNo1 = "0" & right(left(pno,4),2)
		nNo3 = right(pno,4)
		nNo2 = replace(replace(pno,left(pno,4),""),right(pno,4),"")

		tranKorNrmPNo = nNo1 & "-" & nNo2 & "-" & nNo3
	End Function
%>