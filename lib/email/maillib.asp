<%

''// SendMail   - 일반적인 메일 발송
''		-- SendMail(mailfrom, mailto, mailtitle, mailcontent)

''// sendmailnewuser
''		-- sendmailnewuser(mailto,userName)  -가입 축하 메일

''// sendmailorder
''		-- sendmailorder(orderserial,mailfrom) 주문이 정상적으로 접수되었습니다!

''// sendmailbankok - 134..
''		-- sendmailbankok(mailto,userName,orderserial) ' 무통장 입금이 정상적으로 처리 되었습니다!

''// sendmailfinish - 134..
''		-- sendmailfinish(orderserial,deliverno)  --주문하신 상품에 대한 텐바이텐 배송안내입니다

''// sendmailsearchpass
''		-- sendmailsearchpass(mailto,userName,imsipass) --임시 비밀번호 발송


sub sendmail_Local(mailfrom, mailto, mailtitle, mailcontent)
        dim mailobject

        set mailobject=server.createobject("CDONTS.NewMail")
        mailobject.from = mailfrom
        mailobject.to = mailto
        mailobject.subject = mailtitle

        'html style
        mailobject.bodyformat = 0
        mailobject.mailformat = 0

        mailobject.body = mailcontent
        mailobject.send
        set mailobject = nothing
end sub


sub SendMail(mailfrom, mailto, mailtitle, mailcontent)

		dim cdoMessage,cdoConfig

On Error Resume Next

		Set cdoConfig = CreateObject("CDO.Configuration")

		'-> 서버 접근방법을 설정합니다
		cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2 '1 - (cdoSendUsingPickUp)  2 - (cdoSendUsingPort)

		'-> 서버 주소를 설정합니다
		if (application("Svr_Info")	= "Dev") then
			cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "192.168.50.2"
		else
			cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "110.93.128.94"
		end if

		'-> 접근할 포트번호를 설정합니다
		cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25

		'-> 접속시도할 제한시간을 설정합니다
		cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 10

		'-> SMTP 접속 인증방법을 설정합니다
		cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1

		'-> SMTP 서버에 인증할 ID를 입력합니다
		cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = "MailSendUser"

		'-> SMTP 서버에 인증할 암호를 입력합니다
		cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "wjddlswjddls"

		cdoConfig.Fields.Update

		Set cdoMessage = CreateObject("CDO.Message")

		Set cdoMessage.Configuration = cdoConfig

		cdoMessage.To 				= mailto
		cdoMessage.From 			= mailfrom
		cdoMessage.SubJect 	= mailtitle
		'메일 내용이 텍스트일 경우 cdoMessage.TextBody, html일 경우 cdoMessage.HTMLBody
		cdoMessage.HTMLBody	= mailcontent

		cdoMessage.BodyPart.Charset="ks_c_5601-1987"         '/// 한글을 위해선 꼭 넣어 주어야 합니다.
        cdoMessage.HTMLBodyPart.Charset="ks_c_5601-1987"     '/// 한글을 위해선 꼭 넣어 주어야 합니다.

		if (application("Svr_Info")	= "Dev") then
            ''테스트 환경
        	if ((InStr(mailto,"10x10.co.kr")>0) or (mailto="archilee@shinbiro.com")) then
        	    cdoMessage.Send
            end if
        else
            cdoMessage.Send
        end if

		Set cdoMessage = nothing
		Set cdoConfig = nothing

On Error Goto 0
end sub

'// 회원가입인증 메일
function SendMailJoinConfirm(mailto,sUserid,dExpire,sCnfUrl)
        dim mailfrom, mailtitle, mailcontent,dirPath,fileName, i
        dim fs,objFile

        mailfrom = "텐바이텐<customer@10x10.co.kr>"
        mailtitle = "[텐바이텐] 본인인증 확인 메일입니다."

        Set fs = Server.CreateObject("Scripting.FileSystemObject")
        dirPath = server.mappath("/lib/email")
        fileName = dirPath&"\\email_join_confirm.htm"
        Set objFile = fs.OpenTextFile(fileName,1)
        mailcontent = objFile.readall

        mailcontent = replace(mailcontent,"::CONFIRMURL::",sCnfUrl)
        mailcontent = replace(mailcontent,"::USERID::",sUserid)
        mailcontent = replace(mailcontent,"::USERMAIL::",mailto)
        mailcontent = replace(mailcontent,"::EXPIREDATE::",dExpire)

        call sendmail(mailfrom, mailto, mailtitle, mailcontent)
        ''SendMailNewUser = mailcontent
end function

'// 회원정보수정 이메일 인증 메일	'/2017.06.01 한용민
function SendMailReConfirm(mailto,sUserid,dExpire,sCnfUrl)
    dim mailfrom, mailtitle, mailcontent,dirPath,fileName, i
    dim fs,objFile

    mailfrom = "텐바이텐<customer@10x10.co.kr>"
    mailtitle = "[텐바이텐] 본인인증 확인 메일입니다."

    Set fs = Server.CreateObject("Scripting.FileSystemObject")
    dirPath = server.mappath("/lib/email")
    'fileName = dirPath&"\\email_usermail_confirm.htm"
    fileName = dirPath&"\\email_user_confirm.html"
    Set objFile = fs.OpenTextFile(fileName,1)
    mailcontent = objFile.readall

    mailcontent = replace(mailcontent,"::CONFIRMURL::",sCnfUrl)
    mailcontent = replace(mailcontent,"::USERID::",sUserid)
    mailcontent = replace(mailcontent,"::USERMAIL::",mailto)
    mailcontent = replace(mailcontent,"::EXPIREDATE::",dExpire)

    dim oMail
    set oMail = New MailCls         '' mailLib2
        oMail.AddrType		= "string"
        oMail.ReceiverMail	= mailto
        oMail.MailTitles	= mailtitle
        oMail.MailConts 	= mailcontent
        oMail.MailerMailGubun = 12		' 메일러 자동메일 번호
        oMail.Send_TMSMailer()		'TMS메일러
        'oMail.Send_Mailer()
    SET oMail = nothing
    'call sendmail(mailfrom, mailto, mailtitle, mailcontent)
end function

'/회원가입 축하 이메일	'/2017.03.03 한용민(메일 수신거부 암호화 적용후 a메일러 우회해서 웹서버로 들어감)
function SendMailNewUser(mailto,iuserid)
    dim mailfrom, mailtitle, mailcontent,dirPath,fileName, i
    dim fs,objFile

    mailfrom = "텐바이텐<customer@10x10.co.kr>"
    mailtitle = "[텐바이텐] 가입을 축하 드립니다."

    Set fs = Server.CreateObject("Scripting.FileSystemObject")
    dirPath = server.mappath("/lib/email")

    if date()>="2018-08-01" then
        fileName = dirPath&"\\mail_welcome.html"
    else
        fileName = dirPath&"\\mail_membership_welcome.html"
    end if

    Set objFile = fs.OpenTextFile(fileName,1)
    mailcontent = objFile.readall
	'mailcontent = replace(mailcontent,"::USERID::",iuserid)
    mailcontent = replace(mailcontent,"::YYYY::",Year(date()))
    mailcontent = replace(mailcontent,"::MM::",Month(date()))
    mailcontent = replace(mailcontent,"::DD::",Day(date()))
    mailcontent = replace(mailcontent, "::USERMAIL::", trim(strAnsi2Unicode(Base64encode(strUnicode2Ansi(trim("M_ID="&mailto))))) )

    dim oMail
    set oMail = New MailCls         '' mailLib2
        oMail.AddrType		= "string"
        oMail.ReceiverMail	= mailto
        oMail.MailTitles	= mailtitle
        oMail.MailConts 	= mailcontent
        oMail.MailerMailGubun = 12		' 메일러 자동메일 번호
        oMail.Send_TMSMailer()		'TMS메일러
        'oMail.Send_Mailer()
    SET oMail = nothing
end function

'// 010-111-3333 => 010-***-3333
function AstarPhoneNumber(phoneNumber)
	Dim regEx, result
	Set regEx = New RegExp

	With regEx
		.Pattern = "([0-9]+)-([0-9]+)-([0-9]+)"
		.IgnoreCase = True
		.Global = True
	End With

	result = regEx.Replace(phoneNumber,"$1-***-$3")

	if (result = phoneNumber) then
		if (Len(phoneNumber) >= 4) then
			result = Left(phoneNumber, (Len(phoneNumber) - 4)) & "****"
		end if
	end if

	set regEx = nothing

	AstarPhoneNumber = result
end Function

'// 홍길동 => 홍*동
function AstarUserName(userName)
	Dim result

	Select Case Len(userName)
		Case 0
			''
		Case 1
			result = "*"
		Case 2
			result = Left(userName,1) & "*"
		Case Else
			''3이상
			result = Left(userName,1) & "*" & Right(userName,1)
	End Select

	AstarUserName = result
end function

'/주문접수완료안내메일.	'/2017.12.12 한용민
function SendMailOrder(orderserial,mailfrom)
        dim sql,discountrate,paymethod, i, pggubun, mailheader, mailfooter
        dim mailto, mailtitle, mailcontent,itemHtml,itemHtmlOri
        dim fs,objFile,dirPath,fileName,beforeItemHtml,afterItemHtml,itemHtmlTotal, ttlsumHTML
		dim vIsPojangcompleteExists, pojangcash, pojangcnt, tmpitemcnt, tmpitemnosum
			vIsPojangcompleteExists=FALSE
			pojangcash=0
			pojangcnt=0
			tmpitemcnt=0
			tmpitemnosum=0
        '// 이니렌탈 관련 변수
        dim iniRentalInfoDataForMail, tmpRentalInfoDataForMail, iniRentalMonthLengthForMail, iniRentalMonthPriceForMail            

        mailtitle = "주문이 정상적으로 접수되었습니다!"

        dim myorder
        set myorder = new CMyOrder
        myorder.FRectOrderserial = orderserial
        myorder.GetOneOrder

        if (myorder.FResultCount<1) then Exit function

        dim myorderdetail
        set myorderdetail = new CMyOrder
        myorderdetail.FRectOrderserial = orderserial
        myorderdetail.FRectUserID = myorder.FOneItem.Fuserid
        myorderdetail.GetOrderDetail

        ' 파일을 불러와서 ---------------------------------------------------------------------------
        Set fs = Server.CreateObject("Scripting.FileSystemObject")
        dirPath = server.mappath("/lib/email")

        fileName = dirPath&"\\email_header_1.html"

        Set objFile = fs.OpenTextFile(fileName,1)
        mailheader = objFile.readall	' 헤더

        ' 파일을 불러와서 ---------------------------------------------------------------------------
        Set fs = Server.CreateObject("Scripting.FileSystemObject")
        dirPath = server.mappath("/lib/email")

        'fileName = dirPath&"\\email_order.htm"
        fileName = dirPath&"\\email_new_order.html"

        Set objFile = fs.OpenTextFile(fileName,1)
        mailcontent = objFile.readall	' 본문

        ' 파일을 불러와서 ---------------------------------------------------------------------------
        Set fs = Server.CreateObject("Scripting.FileSystemObject")
        dirPath = server.mappath("/lib/email")

        fileName = dirPath&"\\email_footer_1.html"

        Set objFile = fs.OpenTextFile(fileName,1)
        mailfooter = objFile.readall	' 푸터

		'/ 헤더와 본문과 푸터를 전부 이어 붙인다.
		mailcontent = mailheader & mailcontent & mailfooter

'        mailcontent = replace(mailcontent,":USERNAME:",userName)

		dim SpendMile, tencardspend
		dim IsForeighDeliver : IsForeighDeliver = false
        '주문정보 확인.---------------------------------------------------------------------------

		'선물포장서비스 노출		'/2015.11.11 한용민 생성
		IF myorderdetail.FResultCount>0 then
			for i=0 to myorderdetail.FResultCount - 1
				'/선물포장비 있을경우
				If myorderdetail.FItemList(i).FItemid = 100 Then
					'/선물포장완료상품존재
					vIsPojangcompleteExists=TRUE
					pojangcash = pojangcash + myorderdetail.FItemList(i).FItemCost * myorderdetail.FItemList(i).Fitemno		'/포장비
					pojangcnt = pojangcnt + myorderdetail.FItemList(i).Fitemno		'/포장박스갯수
				end if
			next
		end if

        mailto = myorder.FOneItem.Fbuyemail
        paymethod = trim(myorder.FOneItem.Faccountdiv)
        pggubun   = myorder.FOneItem.Fpggubun                   ''2016/08/04 추가

		mailcontent = replace(mailcontent,":mailtitle:", "주문 접수 완료 안내 메일")		' 이메일제목

        if paymethod = "7" then    ' 무통장
            if myorder.FOneItem.TotalMajorPaymentPrice>0 then
                mailcontent = replace(mailcontent,":ACCOUNTDIVNAME:", "무통장입금")
                mailcontent = replace(mailcontent,":IPKUMSTATUS:", "입금전 상태")
                '// 입금 마감일 2021년 11월 24일 오전 10시 이후 부터 10일에서 3일로 변경
                If now() >= #2021-11-24 10:00:00# Then                
                    mailcontent = replace(mailcontent,":IPKUMLIMITDATE:", Left(dateadd("d",3,now()),10)&" 까지")
                Else
                    mailcontent = replace(mailcontent,":IPKUMLIMITDATE:", Left(dateadd("d",10,now()),10)&" 까지")
                End If                
            else
                mailcontent = replace(mailcontent,":ACCOUNTDIVNAME:", "기타결제수단")
                mailcontent = replace(mailcontent,":IPKUMSTATUS:", "결제완료")
            end if
        elseif paymethod = "100" then   ' 신용카드
            if (pggubun="NP") then
                mailcontent = replace(mailcontent,":ACCOUNTDIVNAME:", "네이버페이")
            elseif pggubun="PY" then
                mailcontent = replace(mailcontent,":ACCOUNTDIVNAME:", "페이코")            
            elseif pggubun="KK" then
                mailcontent = replace(mailcontent,":ACCOUNTDIVNAME:", "카카오페이(카드결제)")
            else
                mailcontent = replace(mailcontent,":ACCOUNTDIVNAME:", "신용카드")
            end if
            mailcontent = replace(mailcontent,":IPKUMSTATUS:", "결제완료")
        elseif paymethod = "20" then   ' 실시간이체
            if (pggubun="NP") then
                mailcontent = replace(mailcontent,":ACCOUNTDIVNAME:", "네이버페이")
            elseif pggubun="PY" then
                mailcontent = replace(mailcontent,":ACCOUNTDIVNAME:", "페이코")            
            elseif pggubun="KK" then
                mailcontent = replace(mailcontent,":ACCOUNTDIVNAME:", "카카오페이(머니)")                
            else
                mailcontent = replace(mailcontent,":ACCOUNTDIVNAME:", "실시간이체")
            end if
            mailcontent = replace(mailcontent,":IPKUMSTATUS:", "결제완료")
        elseif paymethod = "80" then   ' 올앳
            mailcontent = replace(mailcontent,":ACCOUNTDIVNAME:", "올앳카드")
            mailcontent = replace(mailcontent,":IPKUMSTATUS:", "결제완료")
        elseif paymethod = "110" then   ' OKCashbag+신용카드
            mailcontent = replace(mailcontent,":ACCOUNTDIVNAME:", "OKCashbag+신용카드")
            mailcontent = replace(mailcontent,":IPKUMSTATUS:", "결제완료")
        elseif paymethod = "400" then   ' 핸드폰결제
            mailcontent = replace(mailcontent,":ACCOUNTDIVNAME:", "핸드폰")
            mailcontent = replace(mailcontent,":IPKUMSTATUS:", "결제완료")
        elseif paymethod = "550" then   ' 기프팅
            mailcontent = replace(mailcontent,":ACCOUNTDIVNAME:", "기프팅")
            mailcontent = replace(mailcontent,":IPKUMSTATUS:", "결제완료")
        elseif paymethod = "560" then   ' 기프티콘
            mailcontent = replace(mailcontent,":ACCOUNTDIVNAME:", "기프티콘")
            mailcontent = replace(mailcontent,":IPKUMSTATUS:", "결제완료")
        elseif paymethod = "150" then   ' 이니렌탈
            mailcontent = replace(mailcontent,":ACCOUNTDIVNAME:", "이니렌탈")
            mailcontent = replace(mailcontent,":IPKUMSTATUS:", "결제완료")
            '// 이니렌탈은 추가 데이터 필요(월 납입금액, 개월 수)
            iniRentalInfoDataForMail = fnGetIniRentalOrderInfo(orderserial)
            If instr(lcase(iniRentalInfoDataForMail),"|") > 0 Then
                tmpRentalInfoDataForMail = split(iniRentalInfoDataForMail,"|")
                iniRentalMonthLengthForMail = tmpRentalInfoDataForMail(0)
                iniRentalMonthPriceForMail = tmpRentalInfoDataForMail(1)
            Else
                iniRentalMonthLengthForMail = ""
                iniRentalMonthPriceForMail = ""
            End If
        else
        	mailcontent = replace(mailcontent,":ACCOUNTDIVNAME:", "")
        end if

        if (paymethod<>"7") or (paymethod="7" and myorder.FOneItem.TotalMajorPaymentPrice=0) then
            mailcontent = ReplaceText(mailcontent,"(<!-----bankinfo------>)[\s\S]*(<!-----/bankinfo------>)","")
            mailcontent = ReplaceText(mailcontent,"(<!-----banknotiinfo------>)[\s\S]*(<!-----/banknotiinfo------>)","")
        end if

        IsForeighDeliver = myorder.FOneItem.IsForeignDeliver

		'// 개인정보 모두 별표처리
		if IsNull(myorder.FOneItem.Freqhp) then myorder.FOneItem.Freqhp = ""
		if IsNull(myorder.FOneItem.Fbuyname) then myorder.FOneItem.Fbuyname = ""
		if IsNull(myorder.FOneItem.Freqname) then myorder.FOneItem.Freqname = ""
		if IsNull(myorder.FOneItem.Freqaddress) then myorder.FOneItem.Freqaddress = ""
		if IsNull(myorder.FOneItem.Freqphone) then myorder.FOneItem.Freqphone = ""
		if IsNull(myorder.FOneItem.Fcomment) then myorder.FOneItem.Fcomment = ""

		myorder.FOneItem.Freqhp = AstarPhoneNumber(myorder.FOneItem.Freqhp)
		myorder.FOneItem.Fbuyname = AstarUserName(myorder.FOneItem.Fbuyname)
		myorder.FOneItem.Freqname = AstarUserName(myorder.FOneItem.Freqname)
		myorder.FOneItem.Freqaddress = "(이하생략)"
		myorder.FOneItem.Freqphone = AstarPhoneNumber(myorder.FOneItem.Freqphone)
		myorder.FOneItem.Fcomment = "(생략)"

        if (IsForeighDeliver) then
            mailcontent = replace(mailcontent,":REQHPORREQEMAIL:", "이메일") ' 수령인 이메일
            mailcontent = replace(mailcontent,":REQHP:", myorder.FOneItem.Freqemail) ' 수령인 전화번호=>이메일로
            mailcontent = replace(mailcontent,":COUNTRYNAME:", myorder.FOneItem.FDlvcountryName) ' 국가.
            mailcontent = replace(mailcontent,":REQZIPCODE:", myorder.FOneItem.FemsZipCode) ' 배송우편번호
        else
            mailcontent = replace(mailcontent,":REQHPORREQEMAIL:", "휴대폰번호") ' 휴대폰번호
            mailcontent = replace(mailcontent,":REQHP:", myorder.FOneItem.Freqhp) ' 수령인 전화번호
            mailcontent = replace(mailcontent,":REQZIPCODE:", myorder.FOneItem.Freqzipcode) ' 배송우편번호
            mailcontent = ReplaceText(mailcontent,"(<!-- foreigndelivery -->)[\s\S]*(<!--/foreigndelivery -->)","")
        end if

        'mailcontent = replace(mailcontent,":BUYNAME:", myorder.FOneItem.Fbuyname) ' 주문자 이름
        mailcontent = replace(mailcontent,":ORDERSERIAL:", orderserial) ' 주문번호
        mailcontent = replace(mailcontent,":REQNAME:", myorder.FOneItem.Freqname) ' 수령인 이름
        mailcontent = replace(mailcontent,":REQALLADDRESS:", myorder.FOneItem.FreqZipaddr + " " + myorder.FOneItem.Freqaddress) ' 배송주소
        mailcontent = replace(mailcontent,":REQPHONE:", myorder.FOneItem.Freqphone) ' 수령인 전화번호

        mailcontent = replace(mailcontent,":BEASONGMEMO:", myorder.FOneItem.Fcomment) ' 배송메모

        ''현장수령
        IF (myorder.FOneItem.IsReceiveSiteOrder) then
            mailcontent = replace(mailcontent,"텐바이텐을 이용해주셔서 진심으로 감사드립니다.<br />감사의 마음을 담아 빠른 배송이 이루어질 수 있도록 노력하겠습니다.<br/>주문 내역 및 배송정보는 마이텐바이텐에서 확인 가능합니다.","<img src='http://company.10x10.co.kr/barcode/barcode.asp?image=3&type=23&data="&orderserial&"&height=50&barwidth=1'>")
            mailcontent = replace(mailcontent,"주문후 7일이내에","주문후 3일이내에")
            mailcontent = replace(mailcontent,"배송지 정보","수령인 정보")
    	    mailcontent = ReplaceText(mailcontent,"(<!-- dlvaddressNinfo -->)[\s\S]*(<!--/dlvaddressNinfo -->)","")
        end if

    	if (paymethod="110") then
    	    mailcontent = replace(mailcontent,":MAJORTOTALPRICE:", formatNumber(myorder.FOneItem.TotalMajorPaymentPrice,0) & " (신용카드:" &FormatNumber(myorder.FOneItem.TotalMajorPaymentPrice-myorder.FOneItem.FokcashbagSpend,0)& ",  OKCashbag:" &FormatNumber(myorder.FOneItem.FokcashbagSpend,0) &")") ' 결제총액
    	elseif (paymethod="150") then
            '// 이니렌탈용 금액 표시
    	    mailcontent = replace(mailcontent,":MAJORTOTALPRICE:", iniRentalMonthLengthForMail&"개월간 월"&formatNumber(iniRentalMonthPriceForMail,0))
        else
    	    mailcontent = replace(mailcontent,":MAJORTOTALPRICE:", formatNumber(myorder.FOneItem.TotalMajorPaymentPrice,0)) ' 결제총액
        end if

        mailcontent = replace(mailcontent,":ACCOUNTNO:", myorder.FOneItem.Faccountno) ' 입금계좌

		' 예치금사용금액
        if (myorder.FOneItem.FspendTenCash<>0) then
            mailcontent = replace(mailcontent,":SPENDTENCASH:", FormatNumber(myorder.FOneItem.FspendTenCash,0))
        else
            mailcontent = ReplaceText(mailcontent,"(<!-----spendtencash------>)[\s\S]*(<!-----/spendtencash------>)","")
        end if

		' Gift카드사용금액
        if (myorder.FOneItem.FspendGiftMoney<>0) then
            mailcontent = replace(mailcontent,":SPENDGIFTMONEY:", FormatNumber(myorder.FOneItem.FspendGiftMoney,0))
        else
            mailcontent = ReplaceText(mailcontent,"(<!-----spendgiftmoney------>)[\s\S]*(<!-----/spendgiftmoney------>)","")
        end if

		'주문아이템 정보 확인.-----------------------------------------------------------------------------

		itemHtml = itemHtml & "<table border='0' cellpadding='0' cellspacing='0' style='width:100%; font-size:12px; font-family:dotum, ""돋움"", sans-serif; color:#707070;'>" & vbcrlf
		itemHtml = itemHtml & "	<tr>" & vbcrlf
		itemHtml = itemHtml & "		<th style='width:50px; height:44px; margin:0; padding:0; border-bottom:solid 1px #eaeaea; background:#f8f8f8; color:#707070; font-size:12px; line-height:12px; font-family:dotum, ""돋움"", sans-serif; text-align:center;'>상품</th>" & vbcrlf
		itemHtml = itemHtml & "		<th style='width:100px; height:44px; margin:0; padding:0; border-bottom:solid 1px #eaeaea; background:#f8f8f8; color:#707070; font-size:12px; line-height:12px; text-align:center; font-family:dotum, ""돋움"", sans-serif;'>상품코드</th>" & vbcrlf
		itemHtml = itemHtml & "		<th style='width:240px; height:44px; margin:0; padding:0; border-bottom:solid 1px #eaeaea; background:#f8f8f8; color:#707070; font-size:12px; line-height:12px; text-align:center; font-family:dotum, ""돋움"", sans-serif;'>상품명[옵션]</th>" & vbcrlf
        If (paymethod<>"150") Then
		    itemHtml = itemHtml & "		<th style='width:85px; height:44px; margin:0; padding:0; border-bottom:solid 1px #eaeaea; background:#f8f8f8; color:#707070; font-size:12px; line-height:12px; text-align:right; font-family:dotum, ""돋움"", sans-serif;'>판매가격</th>" & vbcrlf
        End If
		itemHtml = itemHtml & "		<th style='width:22px; height:44px; border-bottom:solid 1px #eaeaea; background:#f8f8f8; color:#707070; font-size:12px; font-family:dotum, ""돋움"", sans-serif;'>&nbsp;</th>" & vbcrlf
		itemHtml = itemHtml & "		<th style='width:35px; height:44px; margin:0; padding:0; border-bottom:solid 1px #eaeaea; background:#f8f8f8; color:#707070; font-size:12px; line-height:12px; text-align:center; font-family:dotum, ""돋움"", sans-serif;'>수량</th>" & vbcrlf
        If (paymethod<>"150") Then		
            itemHtml = itemHtml & "		<th style='width:85px; height:44px; margin:0; padding:0; border-bottom:solid 1px #eaeaea; background:#f8f8f8; color:#707070; font-size:12px; line-height:12px; text-align:right; font-family:dotum, ""돋움"", sans-serif;'>주문금액</th>" & vbcrlf
        End If
		itemHtml = itemHtml & "		<th style='width:23px; border-bottom:solid 1px #eaeaea; background:#f8f8f8;'>&nbsp;</th>" & vbcrlf
		itemHtml = itemHtml & "	</tr>" & vbcrlf

        for i=0 to myorderdetail.FResultCount-1

			'/선물포장 일경우 포장비 안뿌림
			If myorderdetail.FItemList(i).FItemid <> 100 Then

				itemHtml = itemHtml & "	<tr>" & vbcrlf
				itemHtml = itemHtml & "		<td style='width:50px; padding:6px 0; border-bottom:solid 1px #eaeaea;'><img src='" &  myorderdetail.FItemList(i).FImageSmall & "' alt='" + myorderdetail.FItemList(i).FItemName + "' /></td>" & vbcrlf
				itemHtml = itemHtml & "		<td style='width:100px; margin:0; padding:6px 0; border-bottom:solid 1px #eaeaea; text-align:center; color:#707070; font-size:11px; line-height:11px; font-family:dotum, ""돋움"", sans-serif;'>"& myorderdetail.FItemList(i).FItemID&"</td>" & vbcrlf
				itemHtml = itemHtml & "		<td style='width:240px; margin:0; padding:6px 0; border-bottom:solid 1px #eaeaea; text-align:left; color:#707070; font-size:11px; line-height:17px; font-family:dotum, ""돋움"", sans-serif;'>["&myorderdetail.FItemList(i).Fbrandname& "]<br />" & vbcrlf
				itemHtml = itemHtml & "			" + myorderdetail.FItemList(i).FItemName + "" & vbcrlf

				if ( myorderdetail.FItemList(i).FItemOptionName <>"") then
					itemHtml = itemHtml & "			["&myorderdetail.FItemList(i).FItemOptionName&"]" & vbcrlf
				end if

				itemHtml = itemHtml & "		</td>" & vbcrlf

                If (paymethod<>"150") Then
                    itemHtml = itemHtml & "		<td style='width:85px; margin:0; padding:6px 0; border-bottom:solid 1px #eaeaea; text-align:right; line-height:17px; font-family:dotum, ""돋움"", sans-serif; text-align:right;'>" & vbcrlf

                    if (myorderdetail.FItemList(i).IsSaleItem) then
                        itemHtml = itemHtml & "			<span style='margin:0; padding:6px 0; font-size:11px; line-height:16px; color:#707070; font-family:dotum, ""돋움"", sans-serif; text-decoration:line-through; text-align:right;'>"&FormatNumber(myorderdetail.FItemList(i).Forgitemcost,0)& CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원")&"</span><br />" & vbcrlf
                        itemHtml = itemHtml & "			<span style='margin:0; padding:6px 0; color:#c20a0a; font-size:12px; line-height:16px; font-weight:bold; font-family:dotum, ""돋움"", sans-serif; text-align:right;'>"&FormatNumber(myorderdetail.FItemList(i).getItemcostCouponNotApplied,0)& CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원") &"</span><br />" & vbcrlf
                    else
                        if (myorderdetail.FItemList(i).IsItemCouponAssignedItem) then
                            itemHtml = itemHtml & "			<span style='margin:0; padding:6px 0; font-size:11px; line-height:16px; color:#707070; font-family:dotum, ""돋움"", sans-serif; text-decoration:line-through; text-align:right;'>"&FormatNumber(myorderdetail.FItemList(i).getItemcostCouponNotApplied,0)& CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원")&"</span><br />" & vbcrlf
                        else
                            itemHtml = itemHtml & "			<span style='margin:0; padding:0; font-weight:bold; color:#707070; font-size:12px; line-height:17px; font-family:dotum, ""돋움"", sans-serif; text-align:right;'>"&FormatNumber(myorderdetail.FItemList(i).getItemcostCouponNotApplied,0)& CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원")&"</span><br />" & vbcrlf
                        end if
                    end if

                    if (myorderdetail.FItemList(i).IsItemCouponAssignedItem) then
                        itemHtml = itemHtml & "			<span style='margin:0; padding:6px 0; color:#438938; font-size:12px; line-height:16px; font-weight:bold; font-family:dotum, ""돋움"", sans-serif; text-align:right;'>"&FormatNumber(myorderdetail.FItemList(i).FItemCost,0)& CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원") &"</span><br />" & vbcrlf
                    end if

                    if (myorderdetail.FItemList(i).IsSaleBonusCouponAssignedItem) then
                        itemHtml = itemHtml & "			<span style='margin:0; padding:6px 0; color:#c20a0a; font-size:11px; line-height:16px;  font-family:dotum, ""돋움"", sans-serif; text-align:right;'><img src='http://mailzine.10x10.co.kr/2017/ico_coupon.png' alt='쿠폰적용' style='vertical-align:-2px; padding-right:2px;'/>"&FormatNumber(myorderdetail.FItemList(i).getReducedPrice,0) & CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원") &"</span>" & vbcrlf
                    end if

                    itemHtml = itemHtml & "		</td>" & vbcrlf
                End If

				itemHtml = itemHtml & "		<td style='width:22px; border-bottom:solid 1px #eaeaea;'>&nbsp;</td>" & vbcrlf
				itemHtml = itemHtml & "		<td style='width:35px; margin:0; padding:6px 0; border-bottom:solid 1px #eaeaea; font-size:13px; line-height:13px; color:#707070; text-align:center; font-weight:bold; font-family:dotum, ""돋움"", sans-serif;'>" & vbcrlf
				itemHtml = itemHtml & "			"&myorderdetail.FItemList(i).FItemNo&"" & vbcrlf

				'/선물포장 완료
				If myorderdetail.FItemList(i).FIsPacked="Y" Then
					itemHtml = itemHtml & "			<span style='margin:0; padding:6px 0; color:#c20a0a; font-size:12px; line-height:16px; font-weight:bold; font-family:dotum, ""돋움"", sans-serif; text-align:right;'>(포장상품 "& fnGetPojangItemCount(myorderdetail.FItemList(i).FOrderSerial, myorderdetail.FItemList(i).FItemid, myorderdetail.FItemList(i).FItemoption) &")</span><br />" & vbcrlf
				end if	
												
				itemHtml = itemHtml & "		</td>" & vbcrlf

                If (paymethod<>"150") Then
                    itemHtml = itemHtml & "		<td style='width:85px; margin:0; padding:6px 0; border-bottom:solid 1px #eaeaea; text-align:right; color:#707070; line-height:17px; font-family:dotum, ""돋움"", sans-serif;'>" & vbcrlf
                    itemHtml = itemHtml & "			<span style='margin:0; padding:0; font-weight:bold; color:#707070; font-size:12px; line-height:17px; font-family:dotum, ""돋움"", sans-serif; text-align:right;'>" &FormatNumber(myorderdetail.FItemList(i).FItemCost*myorderdetail.FItemList(i).FItemNo,0) & CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원") & "</span><br />" & vbcrlf

                    if (myorderdetail.FItemList(i).IsSaleBonusCouponAssignedItem) then
                        itemHtml = itemHtml & "			<span style='margin:0; padding:6px 0; color:#c20a0a; font-size:11px; line-height:17px; text-align:right; font-family:dotum, ""돋움"", sans-serif;'><img src='http://mailzine.10x10.co.kr/2017/ico_coupon.png' alt='쿠폰적용' style='margin:0; vertical-align:-2px; padding-right:2px; font-size:11px; line-height:17px; text-align:right; font-family:dotum, ""돋움"", sans-serif;'/>"&FormatNumber(myorderdetail.FItemList(i).getReducedPrice*myorderdetail.FItemList(i).FItemNo,0) & CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원") &"</span>" & vbcrlf
                    end if

                    itemHtml = itemHtml & "		</td>" & vbcrlf
                End If
                
				itemHtml = itemHtml & "		<td style='width:23px; border-bottom:solid 1px #eaeaea;'>&nbsp;</td>" & vbcrlf
				itemHtml = itemHtml & "	</tr>" & vbcrlf

				tmpitemcnt = tmpitemcnt + 1
				tmpitemnosum = tmpitemnosum + myorderdetail.FItemList(i).FItemNo
			end if
        next

		itemHtml = itemHtml & "</table>"

		itemHtmlTotal = replace(mailcontent,":INNERORDERTABLE:", itemHtml) ' 주문정보테이블 넣기

        mailcontent = itemHtmlTotal

        If (paymethod="150") Then
            ttlsumHTML = ""
            ttlsumHTML = ttlsumHTML & " <table border='0' cellpadding='0' cellspacing='0' style='width:100%;'>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "	<tr>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "		<td style='border:solid 5px #eaeaea;'>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "			<table border='0' cellpadding='0' cellspacing='0' style='width:100%;'>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "				<tr>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "					<td style='border-bottom:1px solid #eaeaea;'>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "						<table border='0' cellpadding='0' cellspacing='0' style='width:100%;'>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "							<tr>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "								<th style='padding:15px 24px; font-size:14px; font-weight:bold; font-family:dotum, ""돋움"", sans-serif; text-align:left; color:#000;'>렌탈금액</th>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "								<td style='padding:15px 24px; font-size:17px; font-weight:bold; font-family:verdana, dotum, ""돋움"", sans-serif; text-align:right; color:#000;'>"& iniRentalMonthLengthForMail&"개월간 월"&formatNumber(iniRentalMonthPriceForMail,0) &"<span style='font-weight:normal; font-family:dotum, ""돋움"", sans-serif;'>원</span></td>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "							</tr>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "						</table>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "					</td>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "				</tr>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "		    </table>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "		</td>" & vbcrlf            
            ttlsumHTML = ttlsumHTML & " </tr>" & vbcrlf                        
            ttlsumHTML = ttlsumHTML & "	<tr>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "		<td style='padding-top:9px; text-align:right; font-size:11px; line-height:11px; color:#808080; font-family:dotum, ""돋움"", sans-serif;'>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "			주문상품수 <span style='color:#dd5555; font-weight:bold;'>"& tmpitemcnt &"종 ("& FormatNumber(tmpitemnosum,0) &"개) </span>&nbsp;적립마일리지 <span style='color:#dd5555; font-weight:bold;'>"& FormatNumber(myorder.FOneItem.Ftotalmileage,0) &"P</span>&nbsp;렌탈금액 <span style='color:#dd5555; font-weight:bold;'>"& iniRentalMonthLengthForMail&"개월간 월"&formatNumber(iniRentalMonthPriceForMail,0) &"원</span>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "		</td>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "	</tr>" & vbcrlf
            ttlsumHTML = ttlsumHTML & " </table>" & vbcrlf
        Else
            ttlsumHTML = ""
            ttlsumHTML = ttlsumHTML & " <table border='0' cellpadding='0' cellspacing='0' style='width:100%;'>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "	<tr>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "		<td style='border:solid 5px #eaeaea;'>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "			<table border='0' cellpadding='0' cellspacing='0' style='width:100%;'>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "				<tr>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "					<td style='border-bottom:1px solid #eaeaea;'>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "						<table border='0' cellpadding='0' cellspacing='0' style='width:100%;'>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "							<tr>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "								<th style='padding:15px 24px; font-size:14px; font-weight:bold; font-family:dotum, ""돋움"", sans-serif; text-align:left; color:#000;'>총 주문 금액</th>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "								<td style='padding:15px 24px; font-size:17px; font-weight:bold; font-family:verdana, dotum, ""돋움"", sans-serif; text-align:right; color:#000;'>"& FormatNumber((myorder.FOneItem.FTotalSum-myorder.FOneItem.FDeliverPrice - pojangcash),0) &"<span style='font-weight:normal; font-family:dotum, ""돋움"", sans-serif;'>원</span></td>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "							</tr>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "						</table>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "					</td>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "				</tr>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "				<tr>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "					<td style='padding:15px 0;'>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "						<table border='0' cellpadding='0' cellspacing='0' style='width:100%;'>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "							<tr>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "								<th style='width:50px; padding:5px 25px 4px 25px; font-size:12px; font-weight:bold; font-family:dotum, ""돋움"", sans-serif; text-align:left; color:#707070;'>배송비</th>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "								<td style='padding:5px 25px 4px 25px; font-size:11px; font-weight:normal; font-family:dotum, ""돋움"", sans-serif; text-align:left; color:#707070;'>배송비</td>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "								<td style='padding:5px 25px 4px 25px; font-size:13px; font-weight:normal; font-family:dotum, ""돋움"", sans-serif; text-align:right; color:#707070;'>+</td>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "								<td style='width:80px; padding:4px 25px 4px 0; font-size:13px; font-weight:bold; font-family:verdana, dotum, ""돋움"", sans-serif; text-align:right; color:#707070;'>"& FormatNumber(myorder.FOneItem.FDeliverpriceCouponNotApplied,0) &"<span style='font-weight:normal; font-size:12px; font-family:dotum, ""돋움"", sans-serif;'>원</span></td>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "							</tr>" & vbcrlf

            if myorder.FOneItem.FArriveDeliverCnt > 0 then
                ttlsumHTML = ttlsumHTML & "							<tr>" & vbcrlf
                ttlsumHTML = ttlsumHTML & "								<th style='width:50px; padding:5px 25px 4px 25px; font-size:12px; font-weight:bold; font-family:dotum, ""돋움"", sans-serif; text-align:left; color:#707070;'></th>" & vbcrlf
                ttlsumHTML = ttlsumHTML & "								<td style='padding:5px 25px 4px 25px; font-size:11px; font-weight:normal; font-family:dotum, ""돋움"", sans-serif; text-align:left; color:#707070;'>착불 배송비</td>" & vbcrlf
                ttlsumHTML = ttlsumHTML & "								<td style='padding:5px 25px 4px 25px; font-size:13px; font-weight:normal; font-family:dotum, ""돋움"", sans-serif; text-align:right; color:#707070;'>+</td>" & vbcrlf
                ttlsumHTML = ttlsumHTML & "								<td style='width:80px; padding:4px 25px 4px 0; font-size:13px; font-weight:bold; font-family:verdana, dotum, ""돋움"", sans-serif; text-align:right; color:#707070;'>별도</td>" & vbcrlf
                ttlsumHTML = ttlsumHTML & "							</tr>" & vbcrlf
            end if

            '/선물포장완료상품존재
            if pojangcnt>0 then
                ttlsumHTML = ttlsumHTML & "							<tr>" & vbcrlf
                ttlsumHTML = ttlsumHTML & "								<th style='width:50px; padding:10px 25px 9px 25px; font-size:12px; font-weight:bold; font-family:dotum, ""돋움"", sans-serif; text-align:left; color:#707070;'>선물포장</th>" & vbcrlf
                ttlsumHTML = ttlsumHTML & "								<td style='padding:10px 25px 9px 25px; font-size:11px; font-weight:normal; font-family:dotum, ""돋움"", sans-serif; text-align:left; color:#707070;'></td>" & vbcrlf
                ttlsumHTML = ttlsumHTML & "								<td style='padding:10px 25px 9px 25px; font-size:13px; font-weight:normal; font-family:dotum, ""돋움"", sans-serif; text-align:right; color:#707070;'>+</td>" & vbcrlf
                ttlsumHTML = ttlsumHTML & "								<td style='width:80px; padding:4px 25px 4px 0; font-size:13px; font-weight:bold; font-family:verdana, dotum, ""돋움"", sans-serif; text-align:right; color:#707070;'>("& pojangcnt &"건) "& FormatNumber(pojangcash,0) &"<span style='font-weight:normal; font-size:12px; font-family:dotum, ""돋움"", sans-serif;'>원</span></td>" & vbcrlf
                ttlsumHTML = ttlsumHTML & "							</tr>" & vbcrlf
            end if

            ttlsumHTML = ttlsumHTML & "							<tr>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "								<th style='width:50px; padding:5px 25px 4px 25px; font-size:12px; font-weight:bold; font-family:dotum, ""돋움"", sans-serif; text-align:left; color:#707070;'>할인</th>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "								<td style='padding:5px 25px 4px 25px; font-size:11px; font-weight:normal; font-family:dotum, ""돋움"", sans-serif; text-align:left; color:#707070;'>마일리지</td>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "								<td style='padding:5px 25px 4px 25px; font-size:13px; font-weight:normal; font-family:dotum, ""돋움"", sans-serif; text-align:right; color:#707070;'>-</td>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "								<td style='width:80px; padding:4px 25px 4px 0; font-size:13px; font-weight:bold; font-family:verdana, dotum, ""돋움"", sans-serif; text-align:right; color:#707070;'>"& FormatNumber(myorder.FOneItem.Fmiletotalprice,0) &"<span style='font-weight:normal; font-size:12px; font-family:dotum, ""돋움"", sans-serif;'>원</span></td>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "							</tr>" & vbcrlf

            IF (myorder.FOneItem.Ftencardspend<>0) then
                ttlsumHTML = ttlsumHTML & "							<tr>" & vbcrlf
                ttlsumHTML = ttlsumHTML & "								<th style='width:50px; padding:5px 25px 4px 25px; font-size:12px; font-weight:bold; font-family:dotum, ""돋움"", sans-serif; text-align:left; color:#707070;'></th>" & vbcrlf
                ttlsumHTML = ttlsumHTML & "								<td style='padding:5px 25px 4px 25px; font-size:11px; font-weight:normal; font-family:dotum, ""돋움"", sans-serif; text-align:left; color:#707070;'>보너스쿠폰</td>" & vbcrlf
                ttlsumHTML = ttlsumHTML & "								<td style='padding:5px 25px 4px 25px; font-size:13px; font-weight:normal; font-family:dotum, ""돋움"", sans-serif; text-align:right; color:#707070;'>-</td>" & vbcrlf
                ttlsumHTML = ttlsumHTML & "								<td style='width:80px; padding:4px 25px 4px 0; font-size:13px; font-weight:bold; font-family:verdana, dotum, ""돋움"", sans-serif; text-align:right; color:#707070;'>"&FormatNumber(myorder.FOneItem.Ftencardspend,0) &"<span style='font-weight:normal; font-size:12px; font-family:dotum, ""돋움"", sans-serif;'>원</span></td>" & vbcrlf
                ttlsumHTML = ttlsumHTML & "							</tr>" & vbcrlf
            end if

            if (myorder.FOneItem.FDeliverpriceCouponNotApplied>myorder.FOneItem.FDeliverprice) then
                ttlsumHTML = ttlsumHTML & "							<tr>" & vbcrlf
                ttlsumHTML = ttlsumHTML & "								<th style='width:50px; padding:5px 25px 4px 25px; font-size:12px; font-weight:bold; font-family:dotum, ""돋움"", sans-serif; text-align:left; color:#707070;'></th>" & vbcrlf
                ttlsumHTML = ttlsumHTML & "								<td style='padding:5px 25px 4px 25px; font-size:11px; font-weight:normal; font-family:dotum, ""돋움"", sans-serif; text-align:left; color:#707070;'>배송비쿠폰</td>" & vbcrlf
                ttlsumHTML = ttlsumHTML & "								<td style='padding:5px 25px 4px 25px; font-size:13px; font-weight:normal; font-family:dotum, ""돋움"", sans-serif; text-align:right; color:#707070;'>-</td>" & vbcrlf
                ttlsumHTML = ttlsumHTML & "								<td style='width:80px; padding:4px 25px 4px 0; font-size:13px; font-weight:bold; font-family:verdana, dotum, ""돋움"", sans-serif; text-align:right; color:#707070;'>"& FormatNumber(myorder.FOneItem.FDeliverpriceCouponNotApplied-myorder.FOneItem.FDeliverprice,0) &"<span style='font-weight:normal; font-size:12px; font-family:dotum, ""돋움"", sans-serif;'>원</span></td>" & vbcrlf
                ttlsumHTML = ttlsumHTML & "							</tr>" & vbcrlf
            end if

            if (myorder.FOneItem.Fallatdiscountprice + myorder.FOneItem.Fspendmembership<>0) then
                ttlsumHTML = ttlsumHTML & "							<tr>" & vbcrlf
                ttlsumHTML = ttlsumHTML & "								<th style='width:50px; padding:5px 25px 4px 25px; font-size:12px; font-weight:bold; font-family:dotum, ""돋움"", sans-serif; text-align:left; color:#707070;'></th>" & vbcrlf
                ttlsumHTML = ttlsumHTML & "								<td style='padding:5px 25px 4px 25px; font-size:11px; font-weight:normal; font-family:dotum, ""돋움"", sans-serif; text-align:left; color:#707070;'>기타할인</td>" & vbcrlf
                ttlsumHTML = ttlsumHTML & "								<td style='padding:5px 25px 4px 25px; font-size:13px; font-weight:normal; font-family:dotum, ""돋움"", sans-serif; text-align:right; color:#707070;'>-</td>" & vbcrlf
                ttlsumHTML = ttlsumHTML & "								<td style='width:80px; padding:4px 25px 4px 0; font-size:13px; font-weight:bold; font-family:verdana, dotum, ""돋움"", sans-serif; text-align:right; color:#707070;'>"& FormatNumber((myorder.FOneItem.Fallatdiscountprice + myorder.FOneItem.Fspendmembership),0) &"<span style='font-weight:normal; font-size:12px; font-family:dotum, ""돋움"", sans-serif;'>원</span></td>" & vbcrlf
                ttlsumHTML = ttlsumHTML & "							</tr>" & vbcrlf
            end if

            ttlsumHTML = ttlsumHTML & "							</table>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "						</td>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "					</tr>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "					<tr>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "						<td style='background-color:#fafafa;'>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "							<table border='0' cellpadding='0' cellspacing='0' style='width:100%;'>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "								<tr>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "									<th style='padding:15px 24px; font-size:14px; font-weight:bold; font-family:dotum, ""돋움"", sans-serif; text-align:left; color:#dd5555;'>최종 결제 금액</th>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "									<td style='padding:15px 24px; font-size:23px; font-weight:bold; font-family:verdana, dotum, ""돋움"", sans-serif; text-align:right; color:#dd5555;'>"& FormatNumber(myorder.FOneItem.FsubtotalPrice,0) &"<span style='font-weight:normal; font-family:dotum, ""돋움"", sans-serif;'>원</span></td>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "								</tr>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "							</table>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "						</td>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "					</tr>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "				</table>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "			</td>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "		</tr>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "	<tr>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "		<td style='padding-top:9px; text-align:right; font-size:11px; line-height:11px; color:#808080; font-family:dotum, ""돋움"", sans-serif;'>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "			주문상품수 <span style='color:#dd5555; font-weight:bold;'>"& tmpitemcnt &"종 ("& FormatNumber(tmpitemnosum,0) &"개) </span>&nbsp;적립마일리지 <span style='color:#dd5555; font-weight:bold;'>"& FormatNumber(myorder.FOneItem.Ftotalmileage,0) &"P</span>&nbsp;상품구매총액 <span style='color:#dd5555; font-weight:bold;'>"& FormatNumber(myorder.FOneItem.FTotalSum-myorder.FOneItem.FDeliverPrice - pojangcash,0) &"원</span>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "		</td>" & vbcrlf
            ttlsumHTML = ttlsumHTML & "	</tr>" & vbcrlf
            ttlsumHTML = ttlsumHTML & " </table>" & vbcrlf
        End If

        mailcontent = replace(mailcontent,":ORDERPRICESUMMARY:", ttlsumHTML) ' 주문 합계금액

        set myorder = Nothing
        set myorderDetail = Nothing

        dim oMail
        set oMail = New MailCls         '' mailLib2
            oMail.AddrType		= "string"
            oMail.ReceiverMail	= mailto
            oMail.MailTitles	= mailtitle
            oMail.MailConts 	= mailcontent
            oMail.MailerMailGubun = 4		' 메일러 자동메일 번호
            oMail.Send_TMSMailer()		'TMS메일러
            'oMail.Send_Mailer()
        SET oMail = nothing
        'call sendmail(mailfrom, mailto, mailtitle, mailcontent)
end function

function ReSendmailorder(orderserial,mailfrom)
        sendmailorder orderserial,mailfrom
end function


function SendMailFinish(orderserial,deliverno)
        dim sql,discountrate,paymethod
        dim mailfrom, mailto, mailtitle, mailcontent,itemHtml,itemHtmlOri
        dim fs,objFile,dirPath,fileName,beforeItemHtml,afterItemHtml,itemHtmlTotal
        dim subtotalprice
        mailfrom = "customer@10x10.co.kr"
        mailtitle = "[텐바이텐]상품이 출고되었습니다."


        ' 파일을 불러와서
        Set fs = Server.CreateObject("Scripting.FileSystemObject")
        dirPath = server.mappath("/lib/email")
        fileName = dirPath&"\\email_chulgo.htm"

        Set objFile = fs.OpenTextFile(fileName,1)
        mailcontent = objFile.readall

		sql = "select top 1 buyname, buyemail, reqname, reqzipcode, (reqzipaddr + ' ' + reqaddress) as reqalladdress, reqphone, reqhp, comment, subtotalprice from [db_order].[dbo].tbl_order_master"
		sql = sql + " where orderserial = '" + orderserial + "'"
		rsget.Open sql,dbget,1
		if  not rsget.EOF  then
			mailto = rsget("buyemail")
			subtotalprice = rsget("subtotalprice")
			mailcontent = replace(mailcontent,":BUYNAME:", db2html(rsget("buyname"))) ' 주문자 이름
            mailcontent = replace(mailcontent,":ORDERSERIAL:", orderserial) ' 주문번호
            mailcontent = replace(mailcontent,":REQNAME:", rsget("reqname")) ' 수령인 이름
            mailcontent = replace(mailcontent,":REQZIPCODE:", rsget("reqzipcode")) ' 배송우편번호
            mailcontent = replace(mailcontent,":REQALLADDRESS:", rsget("reqalladdress")) ' 배송주소
            mailcontent = replace(mailcontent,":REQPHONE:", rsget("reqphone")) ' 주문자 전화번호
            mailcontent = replace(mailcontent,":REQHP:", rsget("reqhp")) ' 주문자 전화번호
            mailcontent = replace(mailcontent,":BEASONGMEMO:", rsget("comment")) ' 배송메모

			'if Left(deliverno,1)="6" then
			'	mailcontent = replace(mailcontent,":DELIVERNOWITHSRC:",  "http://www.cjgls.co.kr/contents/gls/gls004/gls004_06_01.asp?slipno=" + CStr(deliverno) ) ' 운송장번호
			'else
				mailcontent = replace(mailcontent,":DELIVERNOWITHSRC:",  "http://www.hydex.net/ehydex/jsp/home/distribution/tracking/trackingViewCus.jsp?InvNo=" + CStr(deliverno) ) ' 운송장번호
			'end if

			mailcontent = replace(mailcontent,":ORDERSERIAL:", orderserial) ' 주문번호
		else
			exit function
		end if
		rsget.close



        'item 루프 앞뒤부분 짜르기
'        beforeItemHtml = Left(mailcontent,InStr(mailcontent,":ITEMSTART:")-1)
'        afterItemHtml = Mid(mailcontent,InStr(mailcontent,":ITEMEND:")+11)

        'item 루프를 돌릴부분 자르기
'        itemHtmlOri = Left(mailcontent,InStr(mailcontent,":ITEMEND:")-1)
'        itemHtmlOri = Mid(itemHtmlOri,InStr(itemHtmlOri,":ITEMSTART:")+11)

        '주문아이템 정보 확인.
        dim itemserial,inx,sinx,einx
		  dim BaesongState
		  dim transco,transurl,songjangstr
'        sql = " select d.itemid, d.itemoptionname, m.imglist, d.itemname,"
'		   sql = sql + " d.itemcost, d.makerid, d.itemno"
'		   sql = sql + " from [db_order].[dbo].tbl_order_detail d"
'		   sql = sql + " left join [db_item].[dbo].tbl_item_image m on d.itemid=m.itemid"
'        sql = sql + " where d.orderserial = '" + orderserial + "'"
'        sql = sql + " and d.itemid <>0"
'        sql = sql + " and d.cancelyn<>'Y'"

				sql = " SELECT a.itemid, a.itemoptionname, c.smallimage, c.itemname, " &_
							" a.itemcost as sellcash, a.itemno, a.isupchebeasong, a.songjangdiv, replace(isnull(a.songjangno,''),'-','') as songjangno, a.currstate" &_
							" ,s.divname,s.findurl" &_
							" FROM [db_order].[dbo].tbl_order_detail a" &_
							" JOIN [db_item].[dbo].tbl_item c" &_
							" 	on c.itemid = a.itemid" &_
							" JOIN db_order.[dbo].tbl_songjang_div s" &_
							" 	on a.songjangdiv=s.divcd" &_
							" WHERE a.orderserial = '" & orderserial & "'" &_
							" and a.itemid <> '0'" &_
							" and (a.cancelyn<>'Y')" &_
							" ORDER BY a.isupchebeasong asc"

        'sql = " select a.itemid, a.itemoptionname, c.smallimage, c.itemname," + vbcrlf
        'sql = sql + " a.itemcost as sellcash, a.itemno, a.isupchebeasong, a.songjangdiv, isnull(a.songjangno,'') as songjangno, a.currstate" + vbcrlf
        'sql = sql + " from [db_order].[dbo].tbl_order_detail a," + vbcrlf
        'sql = sql + " [db_item].[dbo].tbl_item c" + vbcrlf
        'sql = sql + " where a.orderserial = '" + orderserial + "'" + vbcrlf
        'sql = sql + " and a.itemid <> '0'" + vbcrlf
        'sql = sql + " and c.itemid = a.itemid" + vbcrlf
        'sql = sql + " and (a.cancelyn<>'Y')" + vbcrlf
        'sql = sql + " order by a.isupchebeasong asc" + vbcrlf

        inx = 0
		  sinx = 1
		  einx = 0
itemHtml = "<table border='0' cellpadding='0' cellspacing='0'>"

        rsget.Open sql,dbget,1
        if  not rsget.EOF  then
                rsget.Movefirst
                do until rsget.eof

						  if inx = 0 then
								if rsget("isupchebeasong") = "N" then
									sinx = 0' 텐바이텐배송이 처음실행될때
									einx = 1
								elseif rsget("isupchebeasong") = "Y" then
									sinx = 0'업체배송이 처음실행될때
								end if
						  elseif einx = 1 and (rsget("isupchebeasong") = "Y") then
									einx = 0
									sinx = 0'텐바이텐배송 뿌려준후 업체배송 처음 뿌려줄때
						  end if
'response.write sinx & "<br>"
'response.write einx
'response.end
if sinx = 0 then
itemHtml = itemHtml + "<tr>"
itemHtml = itemHtml + "<td>"
itemHtml = itemHtml + "<table width='550' border='0' cellspacing='1' cellpadding='0'>"
itemHtml = itemHtml + "<tr>"
if rsget("isupchebeasong") = "N" then
itemHtml = itemHtml + "<td align='left' valign='top'><img src='http://www.10x10.co.kr/lib/email/images/deliver_ten_t.gif' width='121' height='30'></td>"
else
itemHtml = itemHtml + "<td align='left' valign='top'><img src='http://www.10x10.co.kr/lib/email/images/deliver_upche_t.gif' width='121' height='30'></td>"
end if
itemHtml = itemHtml + "<td>&nbsp;</td>"
itemHtml = itemHtml + "</tr>"
itemHtml = itemHtml + "</table>"
itemHtml = itemHtml + "</td>"
itemHtml = itemHtml + "</tr>"
itemHtml = itemHtml + "<tr>"
itemHtml = itemHtml + "<td>"
itemHtml = itemHtml + "<table style='border-top: 1px solid #aaaaaa' border='0' cellpadding='0' cellspacing='0' height='4' bgcolor='ECECEC'width='550'>"
itemHtml = itemHtml + "<tr>"
itemHtml = itemHtml + "<td><img src='http://www.10x10.co.kr/lib/email/images/spacer.gif' width='550' height='4' align='center'></td>"
itemHtml = itemHtml + "</tr>"
itemHtml = itemHtml + "</table>"
itemHtml = itemHtml + "<table style='border-bottom: 1px solid #555555;'width='550' border='0' height='23' cellpadding='2' cellspacing='0'>"
itemHtml = itemHtml + "<tr>"
itemHtml = itemHtml + "<td width='50' class='p11' align='center'>상품</td>"
itemHtml = itemHtml + "<td width='50' class='p11' align='center'>상품코드</td>"
itemHtml = itemHtml + "<td class='p11' align='center'>상품명<font color='blue'>[옵션]</font></td>"
itemHtml = itemHtml + "<td width='30' class='p11' align='center'>수량</td>"
itemHtml = itemHtml + "<td width='60' class='p11' align='center'>주문상태</td>"
itemHtml = itemHtml + "<td width='100' class='p11' align='center'>운송장</td>"
itemHtml = itemHtml + "</tr>"
itemHtml = itemHtml + "</table>"
itemHtml = itemHtml + "</td>"
itemHtml = itemHtml + "</tr>"
end if

itemserial = CStr(rsget("itemid")) ' 아이템번호

'배송상태 지정
if rsget("isupchebeasong") = "N" then
		 BaesongState = "<font color='red'>출고완료</font>"
else
	 if rsget("currstate") = 7 then
		 BaesongState = "<font color='red'>출고완료</font>"
	 else
		 BaesongState = "<font color='#004080'>상품준비중</font>"
	 end if
end if

'택배/송장 설정

if ((Not isnull(rsget("songjangno"))) and  (rsget("songjangno")<>"") ) then
	songjangstr = db2html(rsget("divname")) & "<br />( <a href='" & db2html(rsget("findurl")) & rsget("songjangno") & "' target='_blank'>" & rsget("songjangno") & "</a> )"
else
	songjangstr="-"
end if

itemHtml = itemHtml + "<tr>"
itemHtml = itemHtml + "<td>"
itemHtml = itemHtml + "<table style='border-bottom: 1px solid #c8c8c8' width='550' border='0' height='57' cellpadding='2' cellspacing='0'>"
itemHtml = itemHtml + "<tr>"
itemHtml = itemHtml + "<td width='50'><img src='http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("smallimage") + "' width='50' height='50'></td>"
itemHtml = itemHtml + "<td width='50' align='center'>" + itemserial + "</td>"
itemHtml = itemHtml + "<td>" + db2html(rsget("itemname")) + "<br><font color='blue'>" + rsget("itemoptionname") + "</font></td>"
itemHtml = itemHtml + "<td width='30' align='center'>" + Cstr(rsget("itemno")) + "</td>"
itemHtml = itemHtml + "<td width='60' align='center'>" + BaesongState + "</td>"
itemHtml = itemHtml + "<td width='100' align='center'>" + songjangstr + "</td>"
itemHtml = itemHtml + "</tr>"
itemHtml = itemHtml + "</table>"
itemHtml = itemHtml + "</td>"
itemHtml = itemHtml + "</tr>"


                inx = inx + 1
                sinx = sinx + 1
                rsget.movenext
                loop
        else
                exit function
        end if
        rsget.close

		itemHtml = itemHtml + "</table>"

		itemHtmlTotal = replace(mailcontent,":INNERORDERTABLE:", itemHtml) ' 주문정보테이블 넣기

      mailcontent = itemHtmlTotal

        call sendmail(mailfrom, mailto, mailtitle, mailcontent)

        'call sendmail(mailfrom, "yanbest@naver.com", mailtitle, mailcontent)

        sendmailfinish = mailcontent
end function

''' gift카드 주문 완료 메일
function SendMailGiftOrder(userid,giftorderserial,mailfrom)
    dim sql,discountrate,paymethod, i
    dim mailto, mailtitle, mailcontent,itemHtml,itemHtmlOri
    dim fs,objFile,dirPath,fileName,beforeItemHtml,afterItemHtml,itemHtmlTotal, ttlsumHTML

    mailtitle = "Gift카드 주문이 정상적으로 접수되었습니다!"

    dim myorder
    set myorder = new cGiftcardOrder
    myorder.FUserID = userid
    myorder.Fgiftorderserial = giftorderserial
    myorder.getGiftcardOrderDetail

    if (myorder.FResultCount<1) then Exit function

    ' 파일을 불러와서 ---------------------------------------------------------------------------
    Set fs = Server.CreateObject("Scripting.FileSystemObject")
    dirPath = server.mappath("/lib/email")

    fileName = dirPath&"\\email_order_giftCard.htm"


    Set objFile = fs.OpenTextFile(fileName,1)
    mailcontent = objFile.readall
'       mailcontent = replace(mailcontent,":USERNAME:",userName)


	dim SpendMile, tencardspend
    '주문정보 확인.---------------------------------------------------------------------------

    mailto = myorder.FOneItem.Fbuyemail
    paymethod = trim(myorder.FOneItem.Faccountdiv)

    mailcontent = replace(mailcontent,":ACCOUNTDIVNAME:", myorder.FOneItem.GetAccountdivName)

    if paymethod = "7" then    ' 무통장
        mailcontent = replace(mailcontent,":IPKUMSTATUS:", "입금전 상태")
        mailcontent = replace(mailcontent,":IPKUMDATE:", "입금이전")

        mailcontent = ReplaceText(mailcontent,"(<!-----smssenddate------>)[\s\S]*(<!-----/smssenddate------>)","")

    elseif paymethod = "100" then   ' 신용카드
        mailcontent = replace(mailcontent,":IPKUMSTATUS:", "결제완료")
    elseif paymethod = "20" then   ' 실시간이체
        mailcontent = replace(mailcontent,":IPKUMSTATUS:", "결제완료")
    elseif paymethod = "80" then   ' 올앳
        mailcontent = replace(mailcontent,":IPKUMSTATUS:", "결제완료")
    elseif paymethod = "110" then   ' OKCashbag+신용카드
        mailcontent = replace(mailcontent,":IPKUMSTATUS:", "결제완료")
    elseif paymethod = "400" then   ' 핸드폰결제
        mailcontent = replace(mailcontent,":IPKUMSTATUS:", "결제완료")
    elseif paymethod = "550" then   ' 기프팅
        mailcontent = replace(mailcontent,":IPKUMSTATUS:", "기프팅")
    elseif paymethod = "560" then   ' 기프티콘
        mailcontent = replace(mailcontent,":IPKUMSTATUS:", "기프티콘")
    else
    	mailcontent = replace(mailcontent,":ACCOUNTDIVNAME:", "")
    end if

    if (myorder.FOneItem.Freqemail="") or isNull(myorder.FOneItem.Freqemail) then
        mailcontent = ReplaceText(mailcontent,"(<!-----reqmailinfo------>)[\s\S]*(<!-----/reqmailinfo------>)","")
    end if

    if (myorder.FOneItem.FbookingYn<>"Y") then
        mailcontent = ReplaceText(mailcontent,"(<!-----bookinginfo------>)[\s\S]*(<!-----/bookinginfo------>)","")
    end if

    if (myorder.FOneItem.FsendDate="") or isNull(myorder.FOneItem.FsendDate) then
        mailcontent = ReplaceText(mailcontent,"(<!-----smssenddate------>)[\s\S]*(<!-----/smssenddate------>)","")
    end if

    mailcontent = replace(mailcontent,":ORDERSERIAL:", giftorderserial) ' 주문번호
    mailcontent = replace(mailcontent,":BUYNAME:", myorder.FOneItem.Fbuyname) ' 주문자 이름
    mailcontent = replace(mailcontent,":REQHP:", myorder.FOneItem.Freqhp) ' 수령인 HP
    mailcontent = replace(mailcontent,":REQEMAIL:", myorder.FOneItem.Freqemail) ' 수령인 HP
    mailcontent = replace(mailcontent,":MAJORTOTALPRICE:", formatNumber(myorder.FOneItem.FsubtotalPrice,0)) ' 결제총액
    mailcontent = replace(mailcontent,":ACCOUNTNO:", null2blank(myorder.FOneItem.Faccountno)) ' 입금계좌


    mailcontent = replace(mailcontent,":BUYHP:", myorder.FOneItem.FbuyHp) ' FbuyHp
    mailcontent = replace(mailcontent,":BUYEMAIL:", myorder.FOneItem.FBuyEmail) ' FBuyEmail.

    mailcontent = replace(mailcontent,":ACCOUNTNAME:", myorder.FOneItem.FAccountName) ' FAccountName.
    If IsNULL(myorder.FOneItem.FIpkumdate) then
        mailcontent = replace(mailcontent,":IPKUMDATE:", "입금이전") ' FIpkumdate.
    ELSE
        mailcontent = replace(mailcontent,":IPKUMDATE:", myorder.FOneItem.FIpkumdate) ' FIpkumdate.
    END IF

    mailcontent = replace(mailcontent,":BUYPHONE:", myorder.FOneItem.Fbuyphone) ' Fbuyphone.

    if myorder.FOneItem.FbookingYn="Y" then
        mailcontent = replace(mailcontent,":BOOKINGDATETIME:", formatDateTime(myorder.FOneItem.FbookingDate,1) & " " & hour(myorder.FOneItem.FbookingDate) & "시") ' booking.
    end if

    if Not((myorder.FOneItem.FsendDate="") or isNull(myorder.FOneItem.FsendDate)) then
        mailcontent = replace(mailcontent,":SENDDATE:", myorder.FOneItem.FsendDate) ' FsendDate.
    end if


	'주문아이템 정보 확인.-----------------------------------------------------------------------------
itemHtml = ""
itemHtml = itemHtml + "<table width='100%' border='0' cellspacing='0' cellpadding='0'>"
itemHtml = itemHtml + "<tr>"
itemHtml = itemHtml + "	<td>"
itemHtml = itemHtml + "		<table width='100%' border='0' cellspacing='0' cellpadding='0'>"
itemHtml = itemHtml + "		<tr bgcolor='#fcf6f6'>"
itemHtml = itemHtml + "			<td height='30' style='border-top:3px solid #be0808;border-bottom:1px solid #eaeaea;padding-top:3px;'>"
itemHtml = itemHtml + "				<table width='100%' border='0' cellspacing='0' cellpadding='0'>"
itemHtml = itemHtml + "				<tr>"
itemHtml = itemHtml + "					<td class='bbstxt01' width='160' align='center' style='padding-left:5px;'>상품</td>"
itemHtml = itemHtml + "					<td class='bbstxt01' align='center'>상품명 [옵션]</td>"
itemHtml = itemHtml + "					<td class='bbstxt01' width='130' align='center'>판매가</td>"
itemHtml = itemHtml + "					<td class='bbstxt01' width='130' align='center'>전송방법</td>"
itemHtml = itemHtml + "				</tr>"
itemHtml = itemHtml + "				</table>"
itemHtml = itemHtml + "			</td>"
itemHtml = itemHtml + "		</tr>"
itemHtml = itemHtml + "		<tr>"
itemHtml = itemHtml + "			<td height='78' style='border-bottom:1px solid #eaeaea;'>"
itemHtml = itemHtml + "				<table width='100%' border='0' cellspacing='0' cellpadding='0'>"
itemHtml = itemHtml + "				<tr>"
itemHtml = itemHtml + "					<td class='bbstxt01' width='160' align='center' style='padding-left:5px;'><img src='"&myorder.FOneItem.FsmallImage&"' width='50' height='50'></td>"
itemHtml = itemHtml + "					<td class='bbstxt01' align='center' style='padding:3px 0 0 5px;line-height:17px;'>"&myorder.FOneItem.FCarditemname
if ( myorder.FOneItem.FcardOptionName <>"") then
itemHtml = itemHtml + "				[" & myorder.FOneItem.FcardOptionName & "]"
end if
itemHtml = itemHtml + "					</td>"
itemHtml = itemHtml + "					<td class='bbstxt01' width='130' align='center' style='padding-top:3px;'>"&formatNumber(myorder.FOneItem.Ftotalsum,0)&"원</td>"
itemHtml = itemHtml + "					<td class='bbstxt01' width='130' align='center' style='padding-top:3px;'>"&myorder.FOneItem.getSendDivName&"</td>"
itemHtml = itemHtml + "				</tr>"
itemHtml = itemHtml + "				</table>"
itemHtml = itemHtml + "			</td>"
itemHtml = itemHtml + "		</tr>"
itemHtml = itemHtml + "		</table>"
itemHtml = itemHtml + "	</td>"
itemHtml = itemHtml + "</tr>"
itemHtml = itemHtml + "</table>"


	itemHtmlTotal = replace(mailcontent,":INNERORDERTABLE:", itemHtml) ' 주문정보테이블 넣기

    mailcontent = itemHtmlTotal



    set myorder = Nothing

    call sendmail(mailfrom, mailto, mailtitle, mailcontent)


end function


'' E-gift카드 전송
function sendGiftCardEmail_SMTP(iorderserial)
    Dim sqlStr
    Dim emailTitle, mailcontents
    Dim sendemail, sender_alias, reqemail, receiver_alias, SendDiv
    sendGiftCardEmail_SMTP = FALSE

    On Error Resume Next
    sqlStr = " select emailTitle"
	sqlStr = sqlStr & " , sendemail"
	sqlStr = sqlStr & " , buyname as sender_alias"
	sqlStr = sqlStr & " , reqemail"
	sqlStr = sqlStr & " , reqemail as receiver_alias"
	sqlStr = sqlStr & " , SendDiv"
	sqlStr = sqlStr & " , db_order.dbo.[sp_Ten_Make_GiftCardEmailMSG]('"&iorderserial&"') as mailcontents"
	sqlStr = sqlStr & " from db_order.dbo.tbl_giftcard_order M"
	sqlStr = sqlStr & " where M.GiftOrderSerial='"&iorderserial&"'"

    rsget.Open sqlStr,dbget,1
    if (Not rsget.Eof) then
        emailTitle      = rsget("emailTitle")
        mailcontents    = rsget("mailcontents")
        sendemail       = rsget("sendemail")
        sender_alias    = rsget("sender_alias")
        reqemail        = rsget("reqemail")
        receiver_alias  = rsget("receiver_alias")
        SendDiv         = rsget("SendDiv")
    end if
    rsget.Close

    ''' 이곳에서 검증.
    IF (mailcontents="") then Exit function
    IF (SendDiv<>"E") then Exit function

    call SendMail(sender_alias&"<"&sendemail&">", receiver_alias&"<"&reqemail&">", emailTitle, mailcontents)

    On Error Goto 0
    IF Err Then
        sendGiftCardEmail_SMTP = FALSE
    ELSE
        sendGiftCardEmail_SMTP = TRUE
    END IF

end function

'/회원 패스워드 찾기 이메일 발송.	'/2017.06.01 한용민
function sendmailsearchpass(mailto,userName,imsipass)
    dim mailfrom, mailtitle, mailcontent,dirPath,fileName
    dim fs,objFile

    mailfrom = "customer@10x10.co.kr"
    mailtitle = "[10x10] " + userName + "님의 임시비밀번호 입니다."

    Set fs = Server.CreateObject("Scripting.FileSystemObject")
    dirPath = server.mappath("/lib/email")
    'fileName = dirPath&"\\email_searchpass2013.htm"
	fileName = dirPath&"\\email_searchpass.html"
    Set objFile = fs.OpenTextFile(fileName,1)
    mailcontent = objFile.readall
    mailcontent = replace(mailcontent,":USERNAME:",userName)
    mailcontent = replace(mailcontent,":IMSIPASS:",imsipass)

    dim oMail
    set oMail = New MailCls         '' mailLib2
        oMail.AddrType		= "string"
        oMail.ReceiverMail	= sEmail
        oMail.MailTitles	= mailtitle
        oMail.MailConts 	= mailcontent
        oMail.MailerMailGubun = 12		' 메일러 자동메일 번호
		oMail.Send_TMSMailer()		'TMS메일러
        'oMail.Send_Mailer()
    SET oMail = nothing
    'call sendmail(mailfrom, mailto, mailtitle, mailcontent)
    sendmailsearchpass = mailcontent
end function

function sendmailbankok(mailto,userName,orderserial) ' 입금확인
        dim sql,discountrate
        dim mailfrom, mailtitle, mailcontent
        dim fs,objFile,dirPath,fileName

        mailfrom = "customer@10x10.co.kr"
        mailtitle = "무통장 입금이 정상적으로 처리 되었습니다!"

        ' 파일을 불러와서
        Set fs = Server.CreateObject("Scripting.FileSystemObject")
        dirPath = server.mappath("/lib/email")
        'fileName = dirPath&"\\email_bank2.htm"
        fileName = dirPath&"\\email_new_bank.html"
        Set objFile = fs.OpenTextFile(fileName,1)
        mailcontent = objFile.readall
        mailcontent = replace(mailcontent,":USERNAME:",userName)
        mailcontent = replace(mailcontent,":ORDERSERIAL:",orderserial)

        call sendmail(mailfrom, mailto, mailtitle, mailcontent)
end function

' 정규식 함수
Function ReplaceText(str, patrn, repStr)
	Dim regEx
	Set regEx = New RegExp
	with regEx
		.Pattern = patrn
		.IgnoreCase = True
		.Global = True
	End with
	ReplaceText = regEx.Replace(str, repStr)
End Function
%>
