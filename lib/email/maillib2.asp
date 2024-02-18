<%

CLASS MailCls

	dim MailTitles		'메일 제목
	dim MailConts		'메일 내용 			(text/html)
	dim SenderMail		'메일 발송자 주소 	(customer@10x10.co.kr,mailzine@10x10.co.kr)
	dim SenderNm		'메일 발송자이름 	(텐바이텐)

	dim MailType		'템플릿 번호 		([4],5,6,7,8,9)

	dim ReceiverNm		'메일 수신자 이름 	($1)
	dim ReceiverMail	'메일 수신자 주소 	(xxxx@aaa.com..)


	dim AddrType				'메일수집 방식 (event,userid)
	dim arrUserId 				'AddrType ="userid" 일경우 사용

	dim AddrString				'메일주소 수집에 쓰일 정보
	dim EvtCode,EvtGroupCode 	'AddrType ="event" 일경우 사용
	dim MailerMailGubun		' 메일러 자동메일 번호

	dim strQuery 		'이메일 정보 수집 쿼리
	dim EmailDataType	'이메일 정보 수집 방식 (Enum : string - 직접 입력,sql - 쿼리 이용)
	Dim DB_ID 			'선더메일 디비연결 번호 - 고정 (실서버- 4 ; 테스트- 5)


	Private Sub Class_Initialize()
		EvtCode =0
		EvtGroupCode =0
		EmailDataType = "sql"
		MailType = 5
		MailerMailGubun = 2		' 메일러 자동메일 번호 기본발송 2번

		IF application("Svr_Info")="Dev" THEN
			DB_ID = "5" '//(실서버- 4 ; 테스트- 5)
		ELSE
			DB_ID = "4"
		END IF
		SenderMail	= "mailzine@10x10.co.kr"
		SenderNm	= "텐바이텐"

	End Sub

	Private Sub Class_Terminate()

	End Sub

    '//+++	TMS메일러 메일발송	' 2020.09.29 한용민 생성
    Public Function Send_TMSMailer()
        Dim sqlStr

		'response.write MailerMailGubun & "<br>"
		'response.write replace(ReceiverMail,"'","") & "<br>"
		'response.write replace(MailTitles,"'","") & "<br>"
		'response.write newhtml2db(MailConts) & "<br>"
		'response.end

        IF (AddrType<>"string") or (ReceiverMail="") Then '// 이름 주소 하나만 처리
		    Err.Number = Err.Number - 1
        ENd IF

        sqlStr =  " exec db_cs.dbo.usp_TEN_TMS_SendAutoMail '"&replace(ReceiverMail,"'","")&"','','"&replace(MailTitles,"'","")&"','"&newhtml2db(MailConts)&"',"& MailerMailGubun &""
        dbget.Execute sqlStr
    end Function

    '//+++	EMS 에이 메일러 메일발송 2014/04/28	+++//
    Public Function Send_Mailer()
        Dim sqlStr

		'response.write MailerMailGubun & "<br>"
		'response.write replace(ReceiverMail,"'","") & "<br>"
		'response.write replace(MailTitles,"'","") & "<br>"
		'response.write newhtml2db(MailConts) & "<br>"
		'response.end

        IF (AddrType<>"string") or (ReceiverMail="") Then '// 이름 주소 하나만 처리
		    'Err.Number = Err.Number - 1
            exit Function
        ENd IF

        sqlStr =  " exec db_cs.[dbo].[sp_Ten_SendAutoMail_Amailer] '"&replace(ReceiverMail,"'","")&"','','"&replace(MailTitles,"'","")&"','"&newhtml2db(MailConts)&"',"& MailerMailGubun &""
        dbget.Execute sqlStr
    end Function

End CLASS
%>