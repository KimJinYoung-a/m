<%
Class CSMSClass
	public function CheckHpOk(byval irechp)
		CheckHpOk = false
		if Len(irechp)<3 then exit function
		if (Left(irechp,3)="013") or (Left(irechp,3)="011") or (Left(irechp,3)="016") or (Left(irechp,3)="017") or (Left(irechp,3)="018") or (Left(irechp,3)="019") or (Left(irechp,3)="010") then
			CheckHpOk = true
		end if
	end function

	'// 카카오톡 발송 여부 확인(주문건)
	public function CheckSendKakaoTalk(byval iordsn, byref uid, byref ukey)
		dim sqlStr
		CheckSendKakaoTalk = false
		if Len(iordsn)<11 then exit function

		sqlStr = "[db_sms].[dbo].sp_Ten_kakaoTalkCheckOrderMsg('" & iordsn & "')"
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc

		IF Not (rsget.EOF OR rsget.BOF) THEN
			CheckSendKakaoTalk = true
			uid = rsget("userid")
			ukey = rsget("kakaoUserKey")
		End IF
		rsget.Close
	end function

	public Sub SendJumunOkMsg(byval irechp, byval iorderserial)
		dim sqlStr, userid, userKey
		dim delivercoper, smsmsg, itemCnt, itemName, reqzipcode, reqzipaddr, reqaddress, subtotalPrice
			itemCnt=0
			subtotalPrice=0
			itemName = ""
			reqzipcode=""
			reqzipaddr=""
			reqaddress=""

		if Not CheckHpOk(irechp) then Exit sub

		sqlStr =" SELECT m.reqzipcode, m.reqzipaddr, m.reqaddress, m.subtotalPrice, m.sumpaymentEtc "
		sqlStr = sqlStr & " FROM [db_order].[dbo].tbl_order_master m with (nolock)"
		sqlStr = sqlStr & " WHERE m.orderserial = '" & iorderserial & "'"
		sqlStr = sqlStr & " and m.cancelyn='N'"

		'response.write sqlStr & "<Br>"
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

		IF not rsget.EOF THEN
			rsget.Movefirst
			Do until rsget.eof
				reqzipcode = db2html(rsget("reqzipcode"))
				reqzipaddr = replace(replace(db2html(rsget("reqzipaddr")),"'",""),"""","")
				reqaddress = replace(replace(db2html(rsget("reqaddress")),"'",""),"""","")
				subtotalPrice = rsget("subtotalPrice")
			rsget.movenext
			loop
		END IF
		rsget.close

		sqlStr =" SELECT a.itemid, a.itemoptionname, a.itemname,a.makerid, "
		sqlStr = sqlStr & " a.itemcost as sellcash, a.itemno, a.isupchebeasong, a.songjangdiv, replace(isnull(a.songjangno,''),'-','') as songjangno, a.currstate"
		sqlStr = sqlStr & " FROM [db_order].[dbo].tbl_order_detail a with (nolock)"
		sqlStr = sqlStr & " WHERE a.orderserial = '" & iorderserial & "'"
		sqlStr = sqlStr & " and a.itemid not in ('0','100')"
		sqlStr = sqlStr & " and (a.cancelyn<>'Y')"
		sqlStr = sqlStr & " ORDER BY a.isupchebeasong asc"

		'response.write sqlStr & "<Br>"
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

		IF not rsget.EOF THEN
			rsget.Movefirst
			Do until rsget.eof
			itemCnt = itemCnt + 1

			if itemName = "" then
				itemName = replace(db2html(rsget("itemname")),vbcrlf,"")
			end if
			rsget.movenext
			loop
		END IF
		rsget.close

		if itemCnt > 1 then
			itemName = itemName & " 외 " & (itemCnt - 1) & "종"
		end if

		if Not CheckSendKakaoTalk(iorderserial, userid, userKey) then
			smsmsg = "[텐바이텐]정상적으로 결제완료 되었습니다. 주문번호 : " & iorderserial
			'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg ) "
			'sqlStr = sqlStr + " values('" + irechp + "',"
			'sqlStr = sqlStr + " '1644-6030',"
			'sqlStr = sqlStr + " '1',"
			'sqlStr = sqlStr + " getdate(),"
			'sqlStr = sqlStr + " '[텐바이텐]정상적으로 결제완료 되었습니다. 주문번호 : " + iorderserial + "')"
			
			''2015/08/16 수정
			'sqlStr = " exec [db_sms].[dbo].[usp_SendSMS] '"+irechp+"','1644-6030','[텐바이텐]정상적으로 결제완료 되었습니다. 주문번호 : " + iorderserial + "'"
			'dbget.execute(sqlStr)

			'// 카카오 알림톡 발송 (2018.01.24 추가)
			dim fullText, failText, btnJson
			' fullText = "정상적으로 결제 완료되었습니다." & vbCrLf &_
			' 		"주문해주셔서 감사합니다." & vbCrLf & vbCrLf &_
			' 		"▶주문번호 : " & iorderserial & vbCrLf & vbCrLf &_
			' 		"주문내역 및 배송정보는" & vbCrLf &_
			' 		"마이 텐바이텐에서 확인 가능합니다." & vbCrLf & vbCrLf &_
			' 		"즐거운 하루 되세요.  :D"
			fullText = "[10x10] 주문완료안내" & vbCrLf & vbCrLf
			fullText = fullText & "고객님의 주문이 결제완료되었습니다." & vbCrLf
			fullText = fullText & "주문해주셔서 감사합니다." & vbCrLf & vbCrLf
			fullText = fullText & "■ 주문번호 : "& iorderserial &"" & vbCrLf
			fullText = fullText & "■ 결제금액 : "& FormatNumber(subtotalPrice,0) &"원" & vbCrLf & vbCrLf
			fullText = fullText & "정확한 배송을 위해" & vbCrLf
			fullText = fullText & "아래 정보를 확인해주세요." & vbCrLf & vbCrLf
			fullText = fullText & "■ 배송지 : "& reqzipaddr &" (이하생략)" & vbCrLf	' reqaddress
			fullText = fullText & "■ 상품명 : "& itemName &""
			failText = smsmsg
			'btnJson = "{""button"":[{""name"":""주문배송조회 바로 가기"",""type"":""WL"", ""url_mobile"":""https://tenten.app.link/F0AnH8TPE0""}]}"
			btnJson = "{""button"":[{""name"":""주문배송조회 바로 가기"",""type"":""WL"", ""url_mobile"":""https://tenten.app.link/L1izHiDBdjb""}]}"
			'Call SendKakaoMsg_LINK(irechp,"1644-6030","P-0006",fullText,"SMS","",failText,btnJson)
			call SendKakaoCSMsg_LINK("", irechp,"1644-6030","KC-0014",fullText,"SMS","",failText,btnJson,iorderserial,"")
		else
			if userKey<>"" then
				sqlStr = "Insert into db_sms.dbo.tbl_kakao_tran (tr_userid, tr_kakaoUsrKey, tr_info1, tr_msg) values "
				sqlStr = sqlStr & " ('" & userid & "',"
				sqlStr = sqlStr & " '" & userKey & "',"
				sqlStr = sqlStr & " '" & iorderserial & "',"
				sqlStr = sqlStr & " '[텐바이텐] 정상적으로 결제 완료 되었습니다. 주문해주셔서 감사합니다.(최고)" & vbCrLf & vbCrLf
				sqlStr = sqlStr & "주문번호 : " & iorderserial & vbCrLf & vbCrLf
				sqlStr = sqlStr & "주문내역 및 배송정보는 마이텐바이텐에서 확인가능합니다." & vbCrLf & vbCrLf
				sqlStr = sqlStr & "주문배송조회 바로가기>>" & vbCrLf
				'sqlStr = sqlStr & " http://m.10x10.co.kr/my10x10/order/myorderdetail.asp?idx=" & iorderserial & "')"
				sqlStr = sqlStr & "http://m.10x10.co.kr/my10x10/order/myorderlist.asp?rdsite=kakaotms')"
				dbget.execute(sqlStr)
			end if
		end if
	end Sub

	public sub SendAcctJumunOkMsg2(byval irechp, byval iorderserial, byval iacct, byval iprice)
		dim sqlStr

		if Not CheckHpOk(irechp) then Exit sub

		'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg ) "
		'sqlStr = sqlStr + " values('" + irechp + "',"
		'sqlStr = sqlStr + " '1644-6030',"
		'sqlStr = sqlStr + " '1',"
		'sqlStr = sqlStr + " getdate(),"
		'sqlStr = sqlStr + " '[텐바이텐]주문접수 되었습니다. 계좌:" + iacct + " 금액:" + iprice + "원')"

        '// SMS 발송 (2015.08.16 수정)
        'sqlStr = " exec [db_sms].[dbo].[usp_SendSMS] '"+irechp+"','1644-6030','[텐바이텐]주문접수 되었습니다. 계좌:" + iacct + " 금액:" + iprice + "원'"
		'rsget.Open sqlStr,dbget,1

		'// 카카오 알림톡 발송 (2017.11.30 추가)
		dim fullText, failText, btnJson
		fullText = "[텐바이텐] 주문접수가 완료되었습니다." & vbCrLf &_
				"주문해주셔서 감사합니다." & vbCrLf & vbCrLf &_
				iacct & "  예금주 : (주)텐바이텐" & vbCrLf &_
				iprice & "원 입금 바랍니다." & vbCrLf & vbCrLf &_
				"즐거운 하루 되세요.  :D"
		failText = "[텐바이텐]주문접수 되었습니다. 계좌:" + iacct + " 금액:" + iprice + "원"
		btnJson = "{""button"":[{""name"":""주문배송조회 바로 가기"",""type"":""WL"", ""url_mobile"":""https://tenten.app.link/F0AnH8TPE0""}]}"
		Call SendKakaoMsg_LINK(irechp,"1644-6030","P-0004",fullText,"SMS","",failText,btnJson)
	end sub

	public Sub SendAcctJumunOkMsg(byval irechp, byval iorderserial)
		dim sqlStr

		if Not CheckHpOk(irechp) then Exit sub

		'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg ) "
		'sqlStr = sqlStr + " values('" + irechp + "',"
		'sqlStr = sqlStr + " '',"
		'sqlStr = sqlStr + " '1',"
		'sqlStr = sqlStr + " getdate(),"
		'sqlStr = sqlStr + " '[텐바이텐]주문접수후 입금대기중입니다.계좌안내:조흥은행534-01-016039.㈜텐바이텐')"

        ''2015/08/16 수정
		sqlStr = " exec [db_sms].[dbo].[usp_SendSMS] '"+irechp+"','1644-6030','[텐바이텐]주문접수후 입금대기중입니다.계좌안내:조흥은행534-01-016039.㈜텐바이텐'"
		rsget.Open sqlStr,dbget,1
	end Sub

	public Sub SendAcctIpkumOkMsg(byval irechp, byval iorderserial)
		dim sqlStr

		if Not CheckHpOk(irechp) then Exit sub

		'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg ) "
		'sqlStr = sqlStr + " values('" + irechp + "',"
		'sqlStr = sqlStr + " '1644-6030',"
		'sqlStr = sqlStr + " '1',"
		'sqlStr = sqlStr + " getdate(),"
		'sqlStr = sqlStr + " '[텐바이텐]입금확인 되었습니다. 주문번호는 " + iorderserial + "입니다.감사합니다.')"

        ''2015/08/16 수정
		sqlStr = " exec [db_sms].[dbo].[usp_SendSMS] '"+irechp+"','1644-6030','[텐바이텐]입금확인 되었습니다. 주문번호는 " + iorderserial + "입니다.감사합니다.'"
		rsget.Open sqlStr,dbget,1
	end Sub

	public Sub SendBeaSongOkMsg(byval irechp, byval isongjangno)
		dim sqlStr
		dim delivercoper

		if Not CheckHpOk(irechp) then Exit sub

        delivercoper = "CJ택배"
        'if Left(isongjangno,1)="6" then
        '	delivercoper = "CJ택배"
        'end if

		'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg ) "
		'sqlStr = sqlStr + " values('" + irechp + "',"
		'sqlStr = sqlStr + " '',"
		'sqlStr = sqlStr + " '1',"
		'sqlStr = sqlStr + " getdate(),"
		'sqlStr = sqlStr + " '[텐바이텐]상품이 출고되었습니다." + delivercoper + " 송장번호 " + isongjangno + " 야간 부터 조회가능')"
        
        ''2015/08/16 수정
		sqlStr = " exec [db_sms].[dbo].[usp_SendSMS] '"+irechp+"','1644-6030','[텐바이텐]상품이 출고되었습니다." + delivercoper + " 송장번호 " + isongjangno + " 야간 부터 조회가능'"
		rsget.Open sqlStr,dbget,1
	end Sub

	public Sub SendJikjupWaitMsg(byval irechp)
		dim sqlStr

		if Not CheckHpOk(irechp) then Exit sub

		'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg ) "
		'sqlStr = sqlStr + " values('" + irechp + "',"
		'sqlStr = sqlStr + " '',"
		'sqlStr = sqlStr + " '1',"
		'sqlStr = sqlStr + " getdate(),"
		'sqlStr = sqlStr + " '[텐바이텐]주문한 상품이 준비되었습니다.직접수령 약도는 홈페이지 를 참고해주세요.')"

        ''2015/08/16 수정
		sqlStr = " exec [db_sms].[dbo].[usp_SendSMS] '"+irechp+"','1644-6030','[텐바이텐]주문한 상품이 준비되었습니다.직접수령 약도는 홈페이지 를 참고해주세요.'"
		rsget.Open sqlStr,dbget,1
	end Sub

	public Sub SendAcctCancelMsg(byval irechp, byval iorderserial)
		dim sqlStr, userid, userKey

		if Not CheckHpOk(irechp) then Exit sub

		if Not CheckSendKakaoTalk(iorderserial, userid, userKey) then
			'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg ) "
			'sqlStr = sqlStr + " values('" + irechp + "',"
			'sqlStr = sqlStr + " '1644-6030',"
			'sqlStr = sqlStr + " '1',"
			'sqlStr = sqlStr + " getdate(),"
			'sqlStr = sqlStr + " '[텐바이텐]승인 취소 되었습니다. 주문번호 : " + iorderserial + "')"
			
			''2015/08/16 수정
		    sqlStr = " exec [db_sms].[dbo].[usp_SendSMS] '"+irechp+"','1644-6030','[텐바이텐]승인 취소 되었습니다. 주문번호 : " + iorderserial + "'"
			dbget.execute(sqlStr)
		else
			if userKey<>"" then
				sqlStr = "Insert into db_sms.dbo.tbl_kakao_tran (tr_userid, tr_kakaoUsrKey, tr_info1, tr_msg) values "
				sqlStr = sqlStr & " ('" & userid & "',"
				sqlStr = sqlStr & " '" & userKey & "',"
				sqlStr = sqlStr & " '" & iorderserial & "',"
				sqlStr = sqlStr & " '[텐바이텐] 주문이 승인취소 되었습니다." & vbCrLf & vbCrLf
				sqlStr = sqlStr & "주문번호 : " & iorderserial & vbCrLf & vbCrLf
				sqlStr = sqlStr & "앞으로도 많은 이용 바랍니다. 감사합니다.(미소)')"
				dbget.execute(sqlStr)
			end if
		end if
	end Sub

	public Sub SendNormalMsg(byval imsg,byval irechp)
		dim sqlStr

		if Not CheckHpOk(irechp) then Exit sub

		'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg ) "
		'sqlStr = sqlStr + " values('" + irechp + "',"
		'sqlStr = sqlStr + " '',"
		'sqlStr = sqlStr + " '1',"
		'sqlStr = sqlStr + " getdate(),"
		'sqlStr = sqlStr + " '" + imsg + "')"
        
        ''2015/08/16 수정
		sqlStr = " exec [db_sms].[dbo].[usp_SendSMS] '"+irechp+"','1644-6030','"&replace(imsg,"'","")&"'"
		rsget.Open sqlStr,dbget,1
	end Sub

	public Sub SendCollegeLectureMsg(byval irechp)
		dim sqlStr

		if Not CheckHpOk(irechp) then Exit sub

		'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg ) "
		'sqlStr = sqlStr + " values('" + irechp + "',"
		'sqlStr = sqlStr + " '',"
		'sqlStr = sqlStr + " '1',"
		'sqlStr = sqlStr + " getdate(),"
		'sqlStr = sqlStr + " '[컬리지]" + name + "님께서 등록하신 컬리지 강좌시작은 " + mon + "월 " + day + "일 " + time + "입니다.')"
        
        ''2015/08/16 수정
		sqlStr = " exec [db_sms].[dbo].[usp_SendSMS] '"+irechp+"','','[컬리지]" + name + "님께서 등록하신 컬리지 강좌시작은 " + mon + "월 " + day + "일 " + time + "입니다.'"
		rsget.Open sqlStr,dbget,1
	end Sub

	public Sub sendSMSUserPassword(byval irechp,sPwd)
		dim sqlStr

		if Not CheckHpOk(irechp) then Exit sub

		'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg ) "
		'sqlStr = sqlStr + " values('" + irechp + "',"
		'sqlStr = sqlStr + " '1644-6030',"
		'sqlStr = sqlStr + " '1',"
		'sqlStr = sqlStr + " getdate(),"
		'sqlStr = sqlStr + " '[텐바이텐]고객님의 임시 비밀번호는 " & sPwd & "입니다.')"

        ''2015/08/16 수정
		sqlStr = " exec [db_sms].[dbo].[usp_SendSMS] '"+irechp+"','1644-6030','[텐바이텐]고객님의 임시 비밀번호는 " & sPwd & "입니다.'"
		rsget.Open sqlStr,dbget,1
	end Sub

	Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub
end Class

// LMS발송(1000byte문자)
function SendNormalLMS(reqhp, title, callback, smstext)
    dim sqlStr, RetRows
    if callback="" then callback=CNORMALCALLBAKC

    ' if LenB(smstext) > 2000 then
    ' 	smstext = LeftB(smstext, 2000)
    ' end if

	' IF application("Svr_Info") = "Dev" THEN
    ' 	sqlStr = " insert into [ACADEMYDB].db_LgSMS.dbo.mms_msg( "
    ' else
    ' 	sqlStr = " insert into [SMSDB].db_LgSMS.dbo.mms_msg( "
    ' end if

	' sqlStr = sqlStr + " 	subject "
	' sqlStr = sqlStr + " 	, phone "
	' sqlStr = sqlStr + " 	, callback "
	' sqlStr = sqlStr + " 	, status "
	' sqlStr = sqlStr + " 	, reqdate "
	' sqlStr = sqlStr + " 	, msg "
	' sqlStr = sqlStr + " 	, file_cnt "
	' sqlStr = sqlStr + " 	, file_path1 "
	' sqlStr = sqlStr + " 	, expiretime) "
	' sqlStr = sqlStr + " values( "
	' sqlStr = sqlStr + " 	'" + html2db(title) + "' "
	' sqlStr = sqlStr + " 	, '" + CStr(reqhp) + "' "
	' sqlStr = sqlStr + " 	, '" + callback + "' "
	' sqlStr = sqlStr + " 	, '0' "
	' sqlStr = sqlStr + " 	, getdate() "
	' sqlStr = sqlStr + " 	, '" + html2db(smstext) + "' "
	' sqlStr = sqlStr + " 	, 0 "
	' sqlStr = sqlStr + " 	, null "
	' sqlStr = sqlStr + " 	, '43200' "
	' sqlStr = sqlStr + " ) "

	sqlStr = "INSERT INTO SMSDB.[db_kakaoSMS].[dbo].MMS_MSG ( REQDATE, STATUS, TYPE, PHONE, CALLBACK, SUBJECT, MSG, FILE_CNT )"
	sqlStr = sqlStr & "		select"
	sqlStr = sqlStr & "		getdate(), '1' , '0', '"& reqhp &"', '"& callback &"', N'"& html2db(title) &"', convert(nvarchar(4000),N'"& html2db(smstext) &"'), '1'"

	'response.write sqlStr &"<Br>"
	dbget.Execute sqlStr, RetRows

	SendNormalLMS = (RetRows=1)
end function

'' E-gift카드 전송
function sendGiftCardLMSMsg(iorderserial)
    Dim sqlStr
    Dim mmsTitle, mmsContent
    Dim sendhp, reqhp
    sendGiftCardLMSMsg = FALSE
    mmsContent = ""
    
    On Error Resume Next
    sqlStr = " select mmsTitle, mmsContent"
	sqlStr = sqlStr & " , sendhp, reqhp "
	sqlStr = sqlStr & " , (substring(masterCardCode,1,4)+'-'+substring(masterCardCode,5,4)+'-'+substring(masterCardCode,9,4)+'-'+substring(masterCardCode,13,4)) as masterCardCode "
	sqlStr = sqlStr & " from db_order.dbo.tbl_giftcard_order M"
	sqlStr = sqlStr & " where M.GiftOrderSerial='"&iorderserial&"'"

    rsget.Open sqlStr,dbget,1
    if (Not rsget.Eof) then
        mmsTitle	= db2html(rsget("mmsTitle"))
        sendhp		= rsget("sendhp")
        reqhp		= rsget("reqhp")

		'# 메시지 작성
		if Not(rsget("mmsContent")="" or isNull(rsget("mmsContent"))) then
			mmsContent = mmsContent & db2html(rsget("mmsContent")) & vbCrLf
			mmsContent = mmsContent & "------------------------" & vbCrLf
		end if
		mmsContent = mmsContent & "* 인증번호 : " & vbCrLf & rsget("masterCardCode") & vbCrLf & vbCrLf
		mmsContent = mmsContent & "* 오프라인 이용안내 : 인증번호 제시 후 상품 구매" & vbCrLf
		mmsContent = mmsContent & "(오프라인매장은 11월 중 사용가능합니다.)" & vbCrLf
		mmsContent = mmsContent & "* 온라인 이용안내 : 텐바이텐(www.10x10.co.kr) 접속→로그인→마이텐바이텐→MY쇼핑혜택>Gift카드→온라인 사용등록 및 내역→인증번호 등록→ 등록완료 후 상품 구매 시 사용 " & vbCrLf& vbCrLf
		mmsContent = mmsContent & "* 고객행복센터 : 1644-6030" & vbCrLf
		mmsContent = mmsContent & "평일 AM09:00~PM06:00/점심시간 PM12:00~01:00" & vbCrLf

    end if
    rsget.Close
    
    ''' 이곳에서 검증.
    IF (mmsContent="") then Exit function
    
    call SendNormalLMS(reqhp,mmsTitle,sendhp,mmsContent)
    
    On Error Goto 0
    IF Err Then
        sendGiftCardLMSMsg = FALSE
    ELSE
        sendGiftCardLMSMsg = TRUE
    END IF
    
end function

function sendGiftCardLMSMsg2016(iorderserial)
    Dim sqlStr
    Dim mmsTitle, mmsContent
    Dim sendhp, reqhp, buyname, cardcoderdm
    sendGiftCardLMSMsg2016 = FALSE
    mmsContent = ""
    
    On Error Resume Next
    sqlStr = " select mmsTitle, mmsContent"
	sqlStr = sqlStr & " , sendhp, reqhp, masterCardCode "
	'sqlStr = sqlStr & " , (substring(masterCardCode,1,4)+'-'+substring(masterCardCode,5,4)+'-'+substring(masterCardCode,9,4)+'-'+substring(masterCardCode,13,4)) as masterCardCode "
	sqlStr = sqlStr & " ,buyname"
	sqlStr = sqlStr & " from db_order.dbo.tbl_giftcard_order M"
	sqlStr = sqlStr & " where M.GiftOrderSerial='"&iorderserial&"'"

    rsget.Open sqlStr,dbget,1
    if (Not rsget.Eof) then
        reqhp		= rsget("reqhp")
        buyname		= db2html(rsget("buyname"))
        sendhp		= rsget("sendhp")
        mmsTitle	= buyname & "님이 텐바이텐 기프트카드를 보내셨습니다."
        cardcoderdm	= rdmSerialEnc(rsget("masterCardCode"))

		mmsContent = mmsContent & "" & buyname & "님(" & sendhp & ")이 텐바이텐 기프트카드를 보내셨습니다." & vbCrLf
		mmsContent = mmsContent & "-----" & vbCrLf & vbCrLf
		mmsContent = mmsContent & "#. 온라인 등록" & vbCrLf
		mmsContent = mmsContent & "http://m.10x10.co.kr/giftcard/view.asp?gc=" & cardcoderdm & "" & vbCrLf & vbCrLf
		mmsContent = mmsContent & "-----" & vbCrLf
	
    end if
    rsget.Close
    
    ''' 이곳에서 검증.
    IF (mmsContent="") then Exit function
    
    call SendNormalLMS(reqhp,mmsTitle,"1644-6030",mmsContent)
    
    On Error Goto 0
    IF Err Then
        sendGiftCardLMSMsg2016 = FALSE
    ELSE
        sendGiftCardLMSMsg2016 = TRUE
    END IF
    
end function

'// 카카오 알림톡으로 문자 발송 (2017.08.29; 허진원 - 링크드 SMS 서버에서 발송)
Sub SendKakaoMsg_LINK(reqhp,callback,tmpcd,ttext,fsendtp,ftit,ftext,btnJson)
	'알림톡 템플릿에 등록 후 승인 받은 형태로만 카카오톡으로 전송가능 (안그러면 무조건 SMS로 발송)
	'2017.11.30: v4 모듈로 판올림, Button_JSON 추가
    dim sqlStr, RetRows
    if callback="" then callback = CNORMALCALLBAKC
    if fsendtp="" then fsendtp="SMS"
    if ftext="" and ttext<>"" then ftext = ttext

    sqlStr = "INSERT INTO [SMSDB].[db_kakaomsg_v4].dbo.KKO_MSG (REQDATE, STATUS, PHONE, CALLBACK, MSG, TEMPLATE_CODE, FAILED_TYPE, FAILED_SUBJECT, FAILED_MSG, BUTTON_JSON) VALUES "
	sqlStr = sqlStr + " (getdate(),'1', "
	sqlStr = sqlStr + " '" & reqhp & "', "				'-- 수신자 휴대폰 번호
	sqlStr = sqlStr + " '" & callback & "', "			'-- 발신자 번호
	sqlStr = sqlStr + " '" & html2db(ttext) & "', "		'-- 알림톡 내용
	sqlStr = sqlStr + " '" & tmpcd & "', "				'-- 알림톡 템플릿 번호
	sqlStr = sqlStr + " '" & fsendtp & "', "			'-- 알림톡 실패시 문자 형식 > SMS / LMS
	sqlStr = sqlStr + " '" & html2db(ftit) & "', "		'-- 실패시 문자 제목 (LMS 전송시에만 필요)
	sqlStr = sqlStr + " '" & html2db(ftext) & "', "		'-- 실패시 문자 내용
	sqlStr = sqlStr + " '" & html2db(btnJson) & "') "	'-- 버튼 구성 내용 (버튼타입에만 필요 / v4 메뉴얼 참고)

	dbget.Execute sqlStr
end Sub

'// 카카오톡 고객센터알림톡 발송. 링크드 SMS 서버에서 발송		' 2021.09.07 한용민 생성
Sub SendKakaoCSMsg_LINK(REQDATE, reqhp,callback,tmpcd,ttext,fsendtp,ftit,ftext,btnJson,TEMPLATE_TITLE,userid)
    dim sqlStr, RetRows

    if callback="" then callback = CNORMALCALLBAKC
    if fsendtp="" then fsendtp="SMS"
    if ftext="" and ttext<>"" then ftext = ttext
	if REQDATE="" or isnull(REQDATE) then
		REQDATE="getdate()"
	else
		REQDATE="N'"& REQDATE &"'"
	end if
	if TEMPLATE_TITLE="" or isnull(TEMPLATE_TITLE) then
		TEMPLATE_TITLE="NULL"
	else
		TEMPLATE_TITLE="N'"& TEMPLATE_TITLE &"'"
	end if
	if userid="" or isnull(userid) then
		userid="NULL"
	else
		userid="N'"& userid &"'"
	end if

    sqlStr = "INSERT INTO [SMSDB].[db_kakaomsg_v4_cs].dbo.KKO_MSG (REQDATE, STATUS, PHONE, CALLBACK, MSG, TEMPLATE_CODE, FAILED_TYPE, FAILED_SUBJECT, FAILED_MSG, BUTTON_JSON, TEMPLATE_TITLE, ETC1)"
	sqlStr = sqlStr & "		SELECT"
	sqlStr = sqlStr & "		"& REQDATE &" as REQDATE, '1' as STATUS"
	sqlStr = sqlStr & "		, '" & reqhp & "' as PHONE"		' 수신자 휴대폰 번호
	sqlStr = sqlStr & "		, '" & callback & "' as CALLBACK"	' 발신자 번호
	sqlStr = sqlStr & "		, N'" & html2db(ttext) & "' as MSG"	' 알림톡 내용
	sqlStr = sqlStr & "		, '" & tmpcd & "' as TEMPLATE_CODE"		' 알림톡 템플릿 번호
	sqlStr = sqlStr & "		, '" & fsendtp & "' as FAILED_TYPE"		' 알림톡 실패시 문자 형식 > SMS / LMS
	sqlStr = sqlStr & "		, N'" & html2db(ftit) & "' as FAILED_SUBJECT"      ' 실패시 문자 제목 (LMS 전송시에만 필요)
	sqlStr = sqlStr & "		, N'" & html2db(ftext) & "' as FAILED_MSG"		' 실패시 문자 내용
	sqlStr = sqlStr & "		, N'" & html2db(btnJson) & "' as BUTTON_JSON"		' 버튼 구성 내용 (버튼타입에만 필요 / v4 메뉴얼 참고)
	sqlStr = sqlStr & "		, "& TEMPLATE_TITLE &" as [TEMPLATE_TITLE]"
	sqlStr = sqlStr & "		, "& userid &""

	'response.write sqlStr & "<Br>"
	dbget.Execute sqlStr
end Sub

'// 카카오 알림톡 문자 발송 (2019.10.22; 이종화 - 링크드 SMS 서버에서 발송) '// 발송일 시간 추가
Sub SendKakaoMsg_LINKForMaketing(reqhp,requestDate,callback,tmpcd,ttext,fsendtp,ftit,ftext,btnJson)
	'알림톡 템플릿에 등록 후 승인 받은 형태로만 카카오톡으로 전송가능 (안그러면 무조건 SMS로 발송)
	'2017.11.30: v4 모듈로 판올림, Button_JSON 추가
    dim sqlStr, RetRows
    if callback="" then callback = CNORMALCALLBAKC
    if fsendtp="" then fsendtp="SMS"
    if ftext="" and ttext<>"" then ftext = ttext

    sqlStr = "INSERT INTO [SMSDB].[db_kakaomsg_v4_mkt].dbo.KKO_MSG (REQDATE, STATUS, PHONE, CALLBACK, MSG, TEMPLATE_CODE, FAILED_TYPE, FAILED_SUBJECT, FAILED_MSG, BUTTON_JSON) VALUES "
	sqlStr = sqlStr + " ('"& requestDate &"','1', "		'-- 발신 요청일 
	sqlStr = sqlStr + " '" & reqhp & "', "				'-- 수신자 휴대폰 번호
	sqlStr = sqlStr + " '" & callback & "', "			'-- 발신자 번호
	sqlStr = sqlStr + " '" & html2db(ttext) & "', "		'-- 알림톡 내용
	sqlStr = sqlStr + " '" & tmpcd & "', "				'-- 알림톡 템플릿 번호
	sqlStr = sqlStr + " '" & fsendtp & "', "			'-- 알림톡 실패시 문자 형식 > SMS / LMS
	sqlStr = sqlStr + " '" & html2db(ftit) & "', "		'-- 실패시 문자 제목 (LMS 전송시에만 필요)
	sqlStr = sqlStr + " '" & html2db(ftext) & "', "		'-- 실패시 문자 내용
	sqlStr = sqlStr + " '" & html2db(btnJson) & "') "	'-- 버튼 구성 내용 (버튼타입에만 필요 / v4 메뉴얼 참고)

	dbget.Execute sqlStr
end Sub
%>
