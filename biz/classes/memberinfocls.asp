<%

'// Biz유저 정보
Class CBizUserInfo
    public FUserID          '// ID
    public FUserPassword    '// Password

    public FUserName        '// 이름
    public FUserMail        '// 이메일(Ex. dlwjseh2@10x10.co.kr)
    public FPreUserMail     '// 이메일 앞부분(Ex. dlwjseh2)
    public FUserMailSite    '// 이메일 사이트(Ex. 10x10.com)
    public FZipCode         '// 우편번호
    public FAddress1        '// 기본 주소
    public FAddress2        '// 상세 주소
    public FUserPhone       '// 전화번호
    public FUserCell        '// 휴대전화번호
    public FBirthDay        '// 생년월일
    public FEmailOk         '// 이메일 수신동의 여부
    public FSmsOk           '// SMS 수신동의 여부
    public FIsEmailChk      '// 이메일 승인 여부
    public FIsMobileChk     '// 휴대전화 승인 여부

    public FPhoneAreaCodeArr    '// 전화 지역번호 배열
    public FEmailSiteArr        '// 이메일 사이트 배열

    
    '// 패스워드 다시 체크
    Public Sub ReCheckPassword()
        Dim sqlStr
        Dim userdiv, encUserPass, encUserPass64
        Dim EcChk : EcChk = TenDec(request.Cookies("tinfo")("EcChk"))
        Dim isPass : isPass = False

        If ( LCase(Session("InfoConfirmFlag"))<>LCase(FUserID)) or (LCase(EcChk)<>LCase(FUserID) ) Then

            '// 패스워드 없이 쿠키로만 들어온 경우
            If FUserPassword = "" Then
                Response.Redirect SSLUrl & "/my10x10/userinfo/confirmuser.asp"
                Response.End
            End If

            encUserPass = MD5(CStr(FUserPassword))
            encUserPass64 = SHA256(MD5(CStr(FUserPassword)))

            sqlStr = "SELECT userid, ISNULL(userdiv,'99') as userdiv "
            sqlStr = sqlStr + " FROM [db_user].[dbo].[tbl_logindata] "
            sqlStr = sqlStr + " WHERE userid='" & userid & "' "
            sqlStr = sqlStr + " AND Enc_userpass64='" & Enc_userpass64 & "'"

            rsget.Open sqlStr, dbget, 1
            if Not rsget.Eof then
                isPass = True
                userdiv = rsget("userdiv")
            end if
            rsget.close

            '// 패스워드 올바르지 않음
            If Not isPass Then
                Response.Redirect SSLUrl & "/my10x10/userinfo/confirmuser.asp?errcode=1"
                Response.End
            End If

            '업체회원이 아닌 경우 일반 회원정보 수정페이지로 이동
            If (userdiv <> "02") and (userdiv <> "03") and (userdiv <> "09") Then
                Response.Redirect SSLUrl & "/my10x10/userinfo/membermodify.asp"
                Response.End
            end if

        End If

    End Sub

    '// Biz유저 정보 테이블 있는지 체크 후 없으면 Insert
    Public Sub CheckAndInsertBizUserInfo()
        Dim sqlStr
        sqlStr = "SELECT COUNT(1) FROM [db_user].[dbo].[tbl_user_c_addinfo] WHERE userid='" & FUserId & "'"
        rsget.Open sqlStr,dbget,1
        If rsget(0) = 0 Then
            sqlStr = "INSERT INTO [db_user].[dbo].[tbl_user_c_addinfo] "
            sqlStr = sqlStr & " (userid, zipcode, useraddr, emailok, smsok, isEmailChk, isMobileChk) "
            sqlStr = sqlStr & " VALUES ('" & FUserId & "', '', '', 'N', 'N', 'N', 'N') "
            dbget.execute(sqlStr)
        End If
        rsget.close
    End Sub

	'// Get Biz유저 Data
	Public Sub GetBizUserData()

		Dim sqlStr, arrEmail
		sqlStr = "SELECT c.userid, c.prcname, c.socmail, ca.zipcode"
		sqlStr = sqlStr + ", ca.zipaddr, ca.useraddr, ca.userphone, c.soccell, c.birthday"
		sqlStr = sqlStr + ", ISNULL(ca.emailok, 'N') as emailok, ISNULL(ca.smsok, 'N') as smsok"
		sqlStr = sqlStr + ", ISNULL(ca.isEmailChk, 'N') as isEmailChk, ISNULL(ca.isMobileChk, 'N') as isMobileChk"
		sqlStr = sqlStr + " FROM [db_user].[dbo].[tbl_user_c] c WITH(NOLOCK) "
		sqlStr = sqlStr + " LEFT JOIN [db_user].[dbo].[tbl_user_c_addinfo] ca WITH(NOLOCK) ON c.userid = ca.userid "
		sqlStr = sqlStr + " WHERE c.userid = '" + FUserID + "'"

		rsget.Open sqlStr,dbget,1

		If Not rsget.Eof Then

			FUserID         = db2html(rsget("userid"))
			FUserName	    = db2html(rsget("prcname"))
			FUserMail	    = db2html(rsget("socmail"))
            If FUserMail <> "" Then
                arrEmail = Split(FUserMail,"@")
                If Ubound(arrEmail)>0 Then
                    FPreUserMail = arrEmail(0)
                    FUserMailSite = arrEmail(1)
                End If
            End If

			FZipCode 	    = rsget("zipcode")
			FAddress1 	    = rsget("zipaddr")
			FAddress2	    = db2html(rsget("useraddr"))
			FUserPhone   	= rsget("userphone")
			FUserCell       = rsget("soccell")
			FBirthDay       = rsget("birthday")

            FEmailOk	    = rsget("emailok")
            FSmsOk          = rsget("smsok")

            FIsEmailChk	    = rsget("isEmailChk")
            FIsMobileChk	= rsget("isMobileChk")

		End If
		rsget.close

	End Sub


    Private Sub Class_Initialize()
        FPhoneAreaCodeArr = Split("02,051,053,032,062,042,052,0474,031,033,043,041,063,061,054,055,064,070,0502,0505,0506,0130,0303", ",")
        FEmailSiteArr = Split("hanmail.net/naver.com/hotmail.com/yahoo.co.kr/hanmir.com/paran.com/lycos.co.kr/nate.com/dreamwiz.com/korea.com/empal.com/netian.com/freechal.com/msn.com/gmail.com", "/")
	End Sub

	Private Sub Class_Terminate()
	End Sub
end Class


%>