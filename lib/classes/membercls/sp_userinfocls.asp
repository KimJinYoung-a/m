<%
''로그인 유저레벨 새로 세팅.
public sub getDBUserLevel2Cookie()
    dim userid : userid = getEncLoginUserID()
    if (userid="") then Exit Sub

    Dim sqlStr
    Dim userlevel : userlevel = -1

    sqlStr = "exec db_user.[dbo].[sp_Ten_userCurentLevel] '"&userid&"'"

    rsget.CursorLocation = adUseClient
	rsget.Open sqlStr,dbget, adOpenForwardOnly, adLockReadOnly
    if  not rsget.EOF  then
        userlevel = rsget("userlevel")
    end if
    rsget.Close

    if (userlevel<0) then Exit Sub

    response.Cookies("uinfo").domain = "10x10.co.kr"
    response.cookies("uinfo")("muserlevel") = userlevel

	''2018/08/17 쿠키세션변경 ..require include tenSessionLib.asp
	if (CStr(session("ssnuserlevel"))<>CStr(userlevel)) then
		session("ssnuserlevel") = CStr(userlevel)
		Call fnEtcSessionChangedToDBSessionUpdate()
	end if
end Sub

Class CUserInfoItem
    public FLevel
	public FUserID
	public FUserName
	public FUsermail
	public FJuminNo
	public FZipCode
	public FAddress1
	public FAddress2
	public Fuserphone
	public Fusercell
	public FBirthDay
    public Femailok
	public Femail_10x10
	public Femail_way2way
	public Fipincheck
	public FisEmailChk
	public FisMobileChk
	
    public FIsSolar
    
    ''2007-12-26 SMS 추가 서동석
    public Fsmsok
    public Fsmsok_fingers
    ''간편로그인수정;허진원 2018.04.24
    public Fgender
    
''  비밀번호 질문/답 삭제
'	public FUserPw_q
'	public FUserPw_a

	
	
	Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub
end Class


Class CAllowSiteItem
    public Fuserid
    public Fsitegubun
    public Fsiteusing
    public Fregdate
    public Fallowdate
    public Fdisallowdate

    Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub
end Class

class CUserInfo
    public FOneItem
	public FItemList()

	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount
    
    public FRectUserID
    public FRectJuminno
    public FRectSiteGubun
    
	Public Sub GetUserData()
		dim sqlStr

'		sqlStr = "select top 1 n.*, (ad.Addr_Si + ' ' + ad.Addr_Gu) as sigu"
		sqlStr = "select top 1 n.*, n.zipaddr as sigu"
		sqlStr = sqlStr + " from [db_user].[dbo].tbl_user_n n"
'		sqlStr = sqlStr + " left join [db_zipcode].dbo.ADDR080TL ad "
'		sqlStr = sqlStr + "     on Left(n.zipcode,3)=ad.Addr_Zip1 "
'		sqlStr = sqlStr + "     and Right(n.zipcode,3)=ad.Addr_Zip2"
		sqlStr = sqlStr + " where n.userid='" + FRectUserID + "'"

		rsget.Open sqlStr,dbget,1
		
		FResultCount = rsget.RecordCount
		
		if Not rsget.Eof then
		    set FOneItem    = new CUserInfoItem
			FOneItem.FUserID 	    = rsget("userid")
			FOneItem.FUserName	    = db2html(rsget("username"))
			FOneItem.Fusermail	    = db2html(rsget("usermail"))
			FOneItem.FJuminNo 	    = rsget("juminno")
			FOneItem.FZipCode 	    = rsget("zipcode")
			FOneItem.FAddress1 	    = rsget("sigu")
			FOneItem.FAddress2	    = db2html(rsget("useraddr"))
			FOneItem.Fuserphone   	= rsget("userphone")
			FOneItem.Fusercell      	= rsget("usercell")
			FOneItem.FBirthDay      = rsget("birthday")
            
            FOneItem.Femailok	    = rsget("emailok")
            FOneItem.Femail_10x10   = rsget("email_10x10")
            FOneItem.Femail_way2way = rsget("email_way2way")
            
            FOneItem.FIsSolar       = rsget("issolar")
            if isNULL(FOneItem.FIsSolar) then FOneItem.FIsSolar="Y"
            
            FOneItem.Fsmsok         = rsget("smsok")
            FOneItem.Fsmsok_fingers = rsget("smsok_fingers")
            if IsNULL(FOneItem.Fsmsok) then FOneItem.Fsmsok = "N"
            if IsNULL(FOneItem.Fsmsok_fingers) then FOneItem.Fsmsok_fingers = "N"
            
            FOneItem.Fipincheck		= rsget("iPinCheck")

            FOneItem.FisEmailChk	= rsget("isEmailChk")
            FOneItem.FisMobileChk	= rsget("isMobileChk")
            ''간편로그인수정;허진원 2018.04.24
			If Trim(rsget("sexflag"))<>"" Then
				if rsget("sexflag")>0 and (rsget("sexflag") mod 2)=0 then
					FOneItem.Fgender		= "F"
				elseif (rsget("sexflag") mod 2)=1 then
					FOneItem.Fgender		= "M"
				end If
			End If

'			FOneItem.FUserPw_q	    = rsget("userpw_q")
'			FOneItem.FUserPw_a	    = db2html(rsget("userpw_a"))
            
		end if
		rsget.close

		Call getDBUserLevel2Cookie
	End Sub

    public Sub GetOneAllowSite()
        dim sqlStr
        sqlStr = " select * from db_user.dbo.tbl_user_allow_site" & VbCrlf
        sqlStr = sqlStr & " where userid='" & FRectUserID & "'" & VbCrlf
        sqlStr = sqlStr & " and sitegubun='" & FRectSiteGubun & "'"
        
        rsget.Open sqlStr,dbget,1
        
        FResultCount = rsget.RecordCount
        set FOneItem    = new CAllowSiteItem
        
		if Not rsget.Eof then
		    FOneItem.Fuserid       = rsget("userid")
            FOneItem.Fsitegubun    = rsget("sitegubun")
            FOneItem.Fsiteusing    = rsget("siteusing")
            FOneItem.Fregdate      = rsget("regdate")
            FOneItem.Fallowdate    = rsget("allowdate")
            FOneItem.Fdisallowdate = rsget("disallowdate")
		end if
		rsget.Close
		
    end Sub

    '// 카카오톡 인증여부 확인
    public Function chkKakaoAuthUser()

        dim sqlStr
        sqlStr = " select count(*) from db_sms.dbo.tbl_kakaoUser " & VbCrlf
        sqlStr = sqlStr & " where userid='" & FRectUserID & "'"
        rsget.Open sqlStr,dbget,1
        
		if rsget(0)>0 then
		    chkKakaoAuthUser = true
		else
			chkKakaoAuthUser = false
		end if
		rsget.Close
		
    end Function

    Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

    End Sub


end Class
%>
