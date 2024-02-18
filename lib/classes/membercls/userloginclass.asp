<%
class CTenUserItem
	public FUserID
	public FUserDiv
	public FUserLevel
	public FUserName
	public FUserEmail
	public FUserIcon
	public FUserIconNo
	public FLoginTime
	public FCouponCnt
	public FCurrentMileage
	public FCurrentTenCash		'// 예치금
	public FCurrentTenGiftCard	'// 기프트카드
	public FRealNameCheck
	Public FUserSeq				'// 회원 고유seq값
	public FBizConfirm			'// Biz회원 승인 여부
	
	''200907추가
	public FSexFlag 
    public FAge     

    public FBaguniCount		''201004추가
	public ForderCount		''201409추가

	Private Sub Class_Initialize()
		FBaguniCount = 0
		ForderCount = 0
		FBizConfirm = "N"
	End Sub

	Private Sub Class_Terminate()

	End Sub
end Class

class CTenUser
	public FOneUser

	public FRectUserID
	public FRectPassWord
	public FRectEnc
	public FRectAppPass

	'sns 로그인 유태욱
	public FRectsns
	public FRectsnsgb

	private FPassOk
    private FNotUsingSite
    
    public FConfirmUser
    
	public function IsPassOk()
		IsPassOk = FPassOk
	end function

	public FchkFingersAllow

    public function IsRequireUsingSite
        IsRequireUsingSite = (FNotUsingSite=true)
    end function

	public Sub LoginProc()
		dim sqlStr
		dim tmpuserpass
		dim tmpuserdiv, tmplevel, tmpuserid, tmpuserlevel, tmplogintime
        dim tmpEnc_userpass, tmpEnc_userpass64, EncedPassWord, EncedPassWord64, tmprealnamecheck
        dim tmpsexflag, tmpage, tmpuseq
		Dim objCmd , vRs
        
		FPassOk = false
		FConfirmUser = "Y"		'(Y: 승인회원, N:승인대기, E:기간만료, O:기존회원, X:정지회원, 0:회원정보없음)

		'유태욱
		dim snslogincnt : snslogincnt = 0
		if FRectsns <>"" and FRectsnsgb <> "" then
			dim snstenbytenid
			sqlStr = " select top 1 tenbytenid" + VbCrlf
			sqlStr = sqlStr + " from db_user.dbo.tbl_user_sns with(nolock)" + vbCrlf
			sqlStr = sqlStr + " where snsid='" + FRectsns + "' and isusing='Y' and snsgubun='" + FRectsnsgb + "'" + vbCrlf

	        rsget.CursorLocation = adUseClient
			rsget.Open sqlStr,dbget, adOpenForwardOnly, adLockReadOnly
			if Not rsget.Eof then
				snstenbytenid = rsget(0)
				FRectUserID = snstenbytenid
			end if
			rsget.Close

			sqlStr = " select count(*)" + VbCrlf
			sqlStr = sqlStr + " from db_user.dbo.tbl_user_sns with(nolock)" + vbCrlf
			sqlStr = sqlStr + " where tenbytenid='" + snstenbytenid + "' and snsid='" + FRectsns + "' and isusing='Y' " + vbCrlf

	        rsget.CursorLocation = adUseClient
			rsget.Open sqlStr,dbget, adOpenForwardOnly, adLockReadOnly
			if Not rsget.Eof then
				snslogincnt = rsget(0)
				if snslogincnt > 0 then
					FPassOk    = true
				end if
			end if
			rsget.Close
		end if

		if snslogincnt < 1 then	'유태욱
			if (FRectUserID="") or (FRectPassWord="" and FRectAppPass="") then Exit Sub
	        
	        if FRectEnc then
	        	EncedPassWord 		= FRectPassWord
	        	EncedPassWord64		= FRectPassWord
	        else
	        	EncedPassWord 		= Md5(FRectPassWord)
	        	EncedPassWord64		= SHA256(Md5(FRectPassWord))
	        end if
		end if

		sqlStr = " select top 1 userid, userdiv, IsNULL(userlevel,5) as userlevel," & VbCrlf
		sqlStr = sqlStr & " userpass, Enc_userpass, Enc_userpass64, " & VbCrlf
		sqlStr = sqlStr & " convert(varchar(19),getdate(),20) as logintime, useq " & VbCrlf
		sqlStr = sqlStr & " from [db_user].[dbo].[tbl_logindata] with(nolock) " & vbCrlf
		sqlStr = sqlStr & " where userid= ? " & vbCrlf
		sqlStr = sqlStr & " and userid<>''"

		Set objCmd = Server.CreateObject("ADODB.COMMAND")
		With objCmd
			.ActiveConnection = dbget
			.CommandType = adCmdText
			.CommandText = sqlStr
			.Prepared = true
			.Parameters.Append .CreateParameter("userid", adVarChar, adParamInput, Len(FRectUserID), FRectUserID)
			SET vRs = objCmd.Execute
				If Not(vRs.EOF or vRs.BOF) Then
					tmpuserid = vRs("userid")
					tmpuserdiv = vRs("userdiv")
					tmpuserpass = vRs("userpass")
					tmpuserlevel = vRs("userlevel")
					tmplogintime = vRs("logintime")
					tmpEnc_userpass = vRs("Enc_userpass")
					tmpEnc_userpass64 = vRs("Enc_userpass64")
					tmpuseq = vRs("useq")*3

					FPassOk	= true
				else
					FPassOk	= false
				end if
			SET vRs = nothing
		End With
		Set objCmd = Nothing

        if Not FPassOk then Exit Sub ''2015/01/22 추가
            
        ''암호화 사용
        ''################################ 비번 체크 ################################
	        'APP에서 넘어온값 비교
	        if FRectAppPass<>"" then
	        	'//MD5 Ver
	        	'FPassOk = FPassOk and (UCASE(md5(lcase(FRectUserID) & ucase(sha256(tmpEnc_userpass))))=UCASE(FRectAppPass))
	        	'//SHA256 Ver
	        	''FPassOk = FPassOk and (UCASE(md5(lcase(FRectUserID) & ucase(tmpEnc_userpass64)))=UCASE(FRectAppPass))  ''2015/01/22 아래로 변경
	        	if (UCASE(md5(lcase(FRectUserID) & ucase(tmpEnc_userpass64)))=UCASE(FRectAppPass)) then
	        	    FPassOk = FPassOk and TRUE
	        	else
	        	    FPassOk = FPassOk and (UCASE(md5(lcase(FRectUserID) & " " & ucase(tmpEnc_userpass64)))=UCASE(FRectAppPass)) ''2015/01/22 추가 안드로이드 일부 단말기 암호화값 sha256 앞에 빈문자열
	            end if
	        else
	        	'//MD5 Ver
	        	'FPassOk = FPassOk and (UCASE(EncedPassWord)=UCASE(tmpEnc_userpass))
	        	'//SHA256 Ver
        		if snslogincnt < 1 then	'유태욱
	        		FPassOk = FPassOk and (UCASE(EncedPassWord64)=UCASE(tmpEnc_userpass64))
	        	end if
	        end if
    	''################################ 비번 체크 ################################

		if Not FPassOk then Exit Sub


		'// 실명확인 체크 여부 접수 (사용안함 제외)
		if (tmpuserdiv="01") or (tmpuserdiv="05") or (tmpuserdiv="99") then
'			'// 일반회원
'			sqlStr = " select top 1 isNull(realnamecheck,'N') as [realnamecheck]" + VbCrlf
'			sqlStr = sqlStr + " , sexflag, (convert(varchar(4),getdate(),21)-(Left(jumin1,2)+1900)) as age " + VbCrlf
'			sqlStr = sqlStr + " from [db_user].[dbo].[tbl_user_n]" + vbCrlf
'			sqlStr = sqlStr + " where userid='" + FRectUserID + "'"
'			
'			rsget.CursorLocation = adUseClient
'			rsget.Open sqlStr,dbget, adOpenForwardOnly, adLockReadOnly
'			if Not rsget.Eof then
'				tmprealnamecheck = rsget("realnamecheck")
'				tmpsexflag = rsget("sexflag")
'				tmpage = rsget("age")
'			else
				tmprealnamecheck = "N"
'			end if
'			rsget.Close
		else
'			'// 기업회원 (기업회원은 실명인증을 받은 것으로 간주)
			tmprealnamecheck = "Y"
		end if

        
        ''#### 사용 사이트 Check ( 텐바이텐 이용안함 원하는 고객.) ######
        sqlStr = "select "
        sqlStr = sqlStr & " 	isNull(sum(Case when sitegubun='10x10' and siteusing='N' then 1 else 0 end),0) as [noTen] "					'텐바이텐 사이트 이용안함
        sqlStr = sqlStr & " 	,isNull(sum(Case when sitegubun='academy' and siteusing='N' then 1 else 0 end),0) as [noAcademy] "			'더핑거스 사이트 이용안함
        sqlStr = sqlStr & " 	,isNull(max(Case when sitegubun='10x10' then allowdate else '' end),'1900-01-01') as [tenALD] "		'텐바이텐 이용 허용일자
        sqlStr = sqlStr & " 	,isNull(max(Case when sitegubun='academy' then allowdate else '' end),'1900-01-01') as [finALD] "		'더핑거스 이용 허용일자
        sqlStr = sqlStr & " from db_user.dbo.tbl_user_allow_site "
        sqlStr = sqlStr & " where userid = ? "

		Set objCmd = Server.CreateObject("ADODB.COMMAND")
		With objCmd
			.ActiveConnection = dbget
			.CommandType = adCmdText
			.CommandText = sqlStr
			.Prepared = true
			.Parameters.Append .CreateParameter("userid", adVarChar, adParamInput, Len(FRectUserID), FRectUserID)
			SET vRs = objCmd.Execute
				FPassOk	= vRs("noTen") = 0

			    if vRs("finALD")<"2016-09-05" then
			    	FchkFingersAllow = true
				end if
			SET vRs = nothing
		End With
		Set objCmd = Nothing

		if (Not FPassOk) then
            FNotUsingSite = true
            Exit Sub
        end if

		'// 휴면 회원 확인 (일반회원만 적용 2015.08.13; 허진원)
		dim chkHoldUser: chkHoldUser=false
		if (tmpuserdiv="01") or (tmpuserdiv="05") or (tmpuserdiv="99") then
			sqlStr = " select count(*) " & VbCrlf
			sqlStr = sqlStr & " from [db_user].[dbo].[tbl_user_n]" & vbCrlf
			sqlStr = sqlStr & " where userid = ? "

			Set objCmd = Server.CreateObject("ADODB.COMMAND")
			With objCmd
				.ActiveConnection = dbget
				.CommandType = adCmdText
				.CommandText = sqlStr
				.Prepared = true
				.Parameters.Append .CreateParameter("userid", adVarChar, adParamInput, Len(FRectUserID), FRectUserID)
				SET vRs = objCmd.Execute
					if vRs(0) <= 0 then
						chkHoldUser = true
					end if
				SET vRs = nothing
			End With
			Set objCmd = Nothing

			if chkHoldUser then
				'회원정보가 없으면 휴면 복구 처리
				sqlStr = "db_user_hold.dbo.sp_Ten_HoldUserRevive ('" & FRectUserID & "','" & chkIIF(FRectAppPass<>"","A","M") & "')"
	            ''Response.Write sqlStr: response.End
				rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
				if Not rsget.Eof then
					FPassOk = rsget(0)>0
				end if
				rsget.Close	
				if Not FPassOk then Exit Sub
			end if
		end if


        ''###############################################################
        
		set FOneUser = new CTenUserItem
		FOneUser.FUserID = tmpuserid
		FOneUser.FUserDiv = tmpuserdiv
		FOneUser.FUserLevel = tmpuserlevel
		FOneUser.FLoginTime = tmplogintime
		FOneUser.FRealNameCheck = tmprealnamecheck
		FOneUser.FUserSeq = tmpuseq
        
        FOneUser.FSexFlag = tmpsexflag
        FOneUser.FAge     = tmpage
        
		'FOneUser.FUserLevel = tmplevel
		if (tmpuserdiv="01") or (tmpuserdiv="05") or (tmpuserdiv="99") then
		    
			''#####일반회원####

			'// 월 정기 회원 서비스 쿠폰 확인 및 발급 (2007.08.31; 허진원)
			
			'회원등급 변경처리로 인해 매월1일 0~3시까지는 쿠폰 확인 및 발급 안함 =>4시로 변경
			if DateDiff("h",DateSerial(Year(date),Month(date),1), now) >= 4 then
				sqlStr = "Select isnull(count(idx),0) " & VbCrlf
				sqlStr = sqlStr & " From db_user.dbo.tbl_user_coupon " & VbCrlf
				sqlStr = sqlStr & " Where userid = ? " & VbCrlf
				sqlStr = sqlStr & "		and useLevel = ? " & VbCrlf
				sqlStr = sqlStr & "		and isnull(validsitename,'')<>'academy' " & VbCrlf
				sqlStr = sqlStr & "		and dateDiff(m,startdate,getdate()) = 0 "

				Set objCmd = Server.CreateObject("ADODB.COMMAND")
				With objCmd
					.ActiveConnection = dbget
					.CommandType = adCmdText
					.CommandText = sqlStr
					.Prepared = true
					.Parameters.Append .CreateParameter("userid", adVarChar, adParamInput, Len(FRectUserID), FRectUserID)
					.Parameters.Append .CreateParameter("useLevel", adInteger, adParamInput, Len(tmpuserlevel), tmpuserlevel)
					SET vRs = objCmd.Execute
						if vRs(0) = 0 then
						'금월에 발급된 쿠폰이 없으므로 회원등급에 맞는 쿠폰 발급
							Select Case tmpuserlevel
								'// 2018 회원등급 개편
								Case 0 'WHITE 등급 (2만원 이상 구매시 무료배송*1, 5만원 이상 구매 시 2000원할인*1)
									'// 텐텐배송 2500으로 변경
									If (Left(Now, 10) >= "2019-01-01") Then
										publishBonusCoupon FRectUserID,3,2500,"[화이트] 무료배송(텐텐배송상품 2만원이상 구매시)",20000,tmpuserlevel,0
									Else
										publishBonusCoupon FRectUserID,3,2000,"[화이트] 무료배송(텐텐배송상품 2만원이상 구매시)",20000,tmpuserlevel,0
									End If
									publishBonusCoupon FRectUserID,2,2000,"[화이트] 2,000원 할인(5만원이상 구매시)",50000,tmpuserlevel,0

								Case 5 'WHITE(오렌지) 등급  (2만원 이상 구매시 무료배송*1, 5만원 이상 구매 시 2000원할인*1) 신규 회원등급 개편에선 없어지지만 혹시 모르니 남겨둠.
									'// 텐텐배송 2500으로 변경
									If (Left(Now, 10) >= "2019-01-01") Then							
										publishBonusCoupon FRectUserID,3,2500,"[화이트] 무료배송(텐텐배송상품 2만원이상 구매시)",20000,tmpuserlevel,0
									Else
										publishBonusCoupon FRectUserID,3,2000,"[화이트] 무료배송(텐텐배송상품 2만원이상 구매시)",20000,tmpuserlevel,0
									End If
									publishBonusCoupon FRectUserID,2,2000,"[화이트] 2,000원 할인(5만원이상 구매시)",50000,tmpuserlevel,0

								Case 1 'RED 등급(5% 쿠폰 최대 1만원 할인*2, 1만원 이상 구매시 무료배송*1)
									'// 텐텐배송 2500으로 변경
									If (Left(Now, 10) >= "2019-01-01") Then							
										publishBonusCoupon FRectUserID,3,2500,"[레드] 무료배송(텐텐배송상품 1만원이상 구매시)",10000,tmpuserlevel,0
									Else
										publishBonusCoupon FRectUserID,3,2000,"[레드] 무료배송(텐텐배송상품 1만원이상 구매시)",10000,tmpuserlevel,0
									End If
									publishBonusCoupon FRectUserID,1,5,"[레드] 5% 할인(최대 1만원 할인)",30000,tmpuserlevel,10000
									publishBonusCoupon FRectUserID,1,5,"[레드] 5% 할인(최대 1만원 할인)",30000,tmpuserlevel,10000

								Case 2 'VIP 등급(5% 쿠폰 최대 1만원 할인*1, 3%쿠폰 최대 1만원 할인*1, 5만원 이상 구매시 3000원 할인*1, 1만원 이상 구매시 무료배송*2)
									'// 텐텐배송 2500으로 변경
									If (Left(Now, 10) >= "2019-01-01") Then							
										publishBonusCoupon FRectUserID,3,2500,"[VIP] 무료배송(텐텐배송상품 1만원이상 구매시)",10000,tmpuserlevel,0
										publishBonusCoupon FRectUserID,3,2500,"[VIP] 무료배송(텐텐배송상품 1만원이상 구매시)",10000,tmpuserlevel,0
									Else
										publishBonusCoupon FRectUserID,3,2000,"[VIP] 무료배송(텐텐배송상품 1만원이상 구매시)",10000,tmpuserlevel,0
										publishBonusCoupon FRectUserID,3,2000,"[VIP] 무료배송(텐텐배송상품 1만원이상 구매시)",10000,tmpuserlevel,0
									End If
									publishBonusCoupon FRectUserID,1,5,"[VIP] 5% 할인(최대 1만원 할인)",30000,tmpuserlevel,10000
									publishBonusCoupon FRectUserID,1,3,"[VIP] 3% 할인(최대 1만원 할인)",30000,tmpuserlevel,10000
									publishBonusCoupon FRectUserID,2,3000,"[VIP] 3,000원 할인(5만원이상 구매시)",50000,tmpuserlevel,0

								Case 3 'VIP GOLD 등급(10% 쿠폰 최대 2만원 할인*1, 5% 쿠폰 최대 1만원 할인*1, 7만원 이상 구매시 5000원 할인*1, 무료배송*2)
									'// 텐텐배송 2500으로 변경
									If (Left(Now, 10) >= "2019-01-01") Then							
										publishBonusCoupon FRectUserID,3,2500,"[VIPGOLD] 무료배송(텐텐배송상품 구매시)",100,tmpuserlevel,0
										publishBonusCoupon FRectUserID,3,2500,"[VIPGOLD] 무료배송(텐텐배송상품 구매시)",100,tmpuserlevel,0
									Else
										publishBonusCoupon FRectUserID,3,2000,"[VIPGOLD] 무료배송(텐텐배송상품 구매시)",100,tmpuserlevel,0
										publishBonusCoupon FRectUserID,3,2000,"[VIPGOLD] 무료배송(텐텐배송상품 구매시)",100,tmpuserlevel,0
									End If
									publishBonusCoupon FRectUserID,1,10,"[VIPGOLD] 10% 할인(최대 2만원 할인)",30000,tmpuserlevel,20000
									publishBonusCoupon FRectUserID,1,5,"[VIPGOLD] 5% 할인(최대 1만원 할인)",30000,tmpuserlevel,10000
									publishBonusCoupon FRectUserID,2,5000,"[VIPGOLD] 5,000원 할인(7만원이상 구매시)",70000,tmpuserlevel,0

								Case 4 'VVIP 등급(10% 쿠폰*2, 5% 쿠폰 최대 2만원 할인*2, 20만원 이상 구매시 30000원 할인*1, 10만원 이상 구매시 10000원 할인*1)
									publishBonusCoupon FRectUserID,1,10,"[VVIP] 10% 할인(3만원이상 구매시)",30000,tmpuserlevel,0
									publishBonusCoupon FRectUserID,1,10,"[VVIP] 10% 할인(3만원이상 구매시)",30000,tmpuserlevel,0
									publishBonusCoupon FRectUserID,1,5,"[VVIP] 5% 할인(최대 2만원 할인)",30000,tmpuserlevel,20000
									publishBonusCoupon FRectUserID,1,5,"[VVIP] 5% 할인(최대 2만원 할인)",30000,tmpuserlevel,20000
									publishBonusCoupon FRectUserID,2,30000,"[VVIP] 30,000원 할인(20만원이상 구매시)",200000,tmpuserlevel,0
									publishBonusCoupon FRectUserID,2,10000,"[VVIP] 10,000원 할인(10만원이상 구매시)",100000,tmpuserlevel,0
							End Select
						end if
					SET vRs = nothing
				End With
				Set objCmd = Nothing
			end if
            
            '//이벤트 쿠폰=============================================
            call CheckEventCouponProcess(FRectUserID)
            ''//===========================================================
            
            sqlStr = " exec [db_user].[dbo].[sp_Ten_User_Login_AddInfo] '"&FRectUserID&"'"  ''2014/12/23 변경
            
            rsget.CursorLocation = adUseClient
			rsget.Open sqlStr,dbget, adOpenForwardOnly, adLockReadOnly
				if Not rsget.Eof then
					FOneUser.FUserName = db2html(rsget("username"))
					FOneUser.FUserEmail = db2html(rsget("usermail"))
					FOneUser.FUserIcon = rsget("usericon")
					FOneUser.FUserIconNo = rsget("usericonNo")
					IF isNull(FOneUser.FUserIcon) then FOneUser.FUserIcon = ""
					FOneUser.FCouponCnt = rsget("couponCnt")
					
					FOneUser.FCurrentMileage = rsget("currentmileage")
					FOneUser.FCurrentTenCash 		= rsget("currenttencash")
					FOneUser.FCurrentTenGiftCard 	= rsget("currenttengiftcard")

				    '// 가입대기 확인
				    if isNull(rsget("userStat")) then
				    	FConfirmUser = "O"
				    elseif (rsget("userStat")="N") then
				    	FPassOk = false
				    	if (datediff("h",rsget("regdate"),now())<=12) then
			    			FConfirmUser = "N"
			    		else
			    			FConfirmUser = "E"
			    		end if
				    end if

				end if
			rsget.Close

            '' 장바구니 갯수. [sp_Ten_GetBaguniCount]
            sqlStr = "select Count(*) as CNT"
    		sqlStr = sqlStr + " from [db_my10x10].[dbo].tbl_my_baguni b"
    		sqlStr = sqlStr + " 	Join [db_item].[dbo].tbl_item i"
    		sqlStr = sqlStr + " 	on b.itemid=i.itemid"
			sqlStr = sqlStr + "			and (i.sellyn='Y' or (i.limityn='Y' and (i.limitno-i.limitsold>0)))"
    		sqlStr = sqlStr + " where b.userKey='" + FRectUserID + "'"
    		sqlStr = sqlStr + " and b.isLoginUser='Y'"
    		
    		rsget.CursorLocation = adUseClient
    		rsget.Open sqlStr,dbget, adOpenForwardOnly, adLockReadOnly
			if Not rsget.Eof then
                FOneUser.FBaguniCount = rsget("CNT")
            end if
			rsget.Close

            '' 최근 3주간 주문/배송 갯수. (주문대기 이상, 정상건) 서머리 테이블로 변경. 2015/08/13
            FOneUser.ForderCount = 0
            
            sqlStr = " exec [db_order].dbo.sp_Ten_get_His_recent_OrderCNT '"&FRectUserID&"'" 
            rsget.CursorLocation = adUseClient
            rsget.Open sqlStr,dbget, adOpenForwardOnly, adLockReadOnly
            if Not rsget.Eof then
                FOneUser.ForderCount = rsget("CNT")
            end if
        	rsget.Close
        	
		ElseIf (tmpuserdiv="95") or (tmpuserdiv="96") then
			'### 일시정지 회원 (사용안함, 외부 기타요인에 의한 회원 정지처리)
			FPassOk = false
			FConfirmUser = "X"
			Exit Sub

		else
			sqlStr = " select top 1 uc.socname, uc.socmail, ISNULL(ua.isconfirm, 'N') as isconfirm " + vbCrlf
			sqlStr = sqlStr + " from [db_user].dbo.[tbl_user_c] uc " + vbCrlf
			sqlStr = sqlStr + " left join [db_user].[dbo].[tbl_user_c_auth] ua ON uc.userid = ua.userid " + vbCrlf
			sqlStr = sqlStr + " where uc.userid='" + FRectUserID + "'" + vbCrlf
			sqlStr = sqlStr + " and uc.userid<>''" + vbCrlf
            
            rsget.CursorLocation = adUseClient
			rsget.Open sqlStr,dbget, adOpenForwardOnly, adLockReadOnly
				if Not rsget.Eof then
					FOneUser.FUserName = db2html(rsget("socname"))
					FOneUser.FUserEmail = db2html(rsget("socmail"))
					FOneUser.FBizConfirm = db2html(rsget("isconfirm"))
				end if
			rsget.Close
		end if

		'// STAFF회원 Biz승인여부 무조건 Y
		If FOneUser.FUserLevel = "7" Then
			FOneUser.FBizConfirm = "Y"
		End If

	    '// 로그인 카운터 및 기타 정보 저장
	    dim lastrefip
	    lastrefip = Left(request.ServerVariables("REMOTE_ADDR"),32)
	
		sqlStr = " update [db_user].dbo.[tbl_logindata]" & vbCrlf
		sqlStr = sqlStr & " set lastlogin=getdate()," & vbCrlf
		sqlStr = sqlStr & " counter=counter+1," & vbCrlf
		sqlStr = sqlStr & " lastrefip= ? "  & vbCrlf
		sqlStr = sqlStr & " where userid= ? "
		Set objCmd = Server.CreateObject("ADODB.COMMAND")
		With objCmd
			.ActiveConnection = dbget
			.CommandType = adCmdText
			.CommandText = sqlStr
			.Prepared = true
			.Parameters.Append .CreateParameter("lastrefip", adVarChar, adParamInput, Len(lastrefip), lastrefip)
			.Parameters.Append .CreateParameter("userid", adVarChar, adParamInput, Len(FRectUserID), FRectUserID)
			.Execute, , adExecuteNoRecords
		End With
		Set objCmd = Nothing
        
        ''2017/08/11 비회원 식별관련.
        sqlStr = "db_user.[dbo].[usp_TEN_User_LastGUID_ADD] '"&FRectUserID&"','"&fn_getGgsnCookie()&"'"
        dbget.execute sqlStr

	end Sub

	'// Biz회원 로그인
	public Sub BizLoginProc()

		Dim sqlStr, objCmd, vRs
		Dim EncedPassWord, EncedPassWord64
		Dim tmpuserid, tmpuserdiv, tmpuserpass, tmpuserlevel, tmplogintime, tmpEnc_userpass, tmpEnc_userpass64, tmpuseq
		
		FPassOk = false
		FConfirmUser = "Y"		'(Y: 승인회원, N:승인대기, E:기간만료, O:기존회원, X:정지회원)

		If (FRectUserID="") or (FRectPassWord="") Then Exit Sub

		EncedPassWord = Md5(FRectPassWord)
		EncedPassWord64 = SHA256(Md5(FRectPassWord))

		sqlStr = " SELECT TOP 1 L.userid, L.userdiv, IsNULL(L.userlevel,5) as userlevel," & VbCrlf
		sqlStr = sqlStr & " L.userpass, L.Enc_userpass, L.Enc_userpass64, " & VbCrlf
		sqlStr = sqlStr & " CONVERT(VARCHAR(19), GETDATE(),20) as logintime, L.useq " & VbCrlf
		sqlStr = sqlStr & " FROM [db_user].[dbo].[tbl_logindata] L with(nolock) " & vbCrlf
		sqlStr = sqlStr & " INNER JOIN [db_user].[dbo].[tbl_user_c] C with(nolock) ON L.userid = C.userid " & vbCrlf
		sqlStr = sqlStr & " WHERE L.userid = ? " & vbCrlf
		sqlStr = sqlStr & " AND L.userid <> ''"
        
		Set objCmd = Server.CreateObject("ADODB.COMMAND")
		With objCmd
			.ActiveConnection = dbget
			.CommandType = adCmdText
			.CommandText = sqlStr
			.Prepared = true
			.Parameters.Append .CreateParameter("userid", adVarChar, adParamInput, Len(FRectUserID), FRectUserID)
			SET vRs = objCmd.Execute
				If Not(vRs.EOF or vRs.BOF) Then
					tmpuserid = vRs("userid")
					tmpuserdiv = vRs("userdiv")
					tmpuserpass = vRs("userpass")
					tmpuserlevel = vRs("userlevel")
					tmplogintime = vRs("logintime")
					tmpEnc_userpass = vRs("Enc_userpass")
					tmpEnc_userpass64 = vRs("Enc_userpass64")
					tmpuseq = vRs("useq")*3

					FPassOk	= true
				else
					FPassOk	= false
				end if
			SET vRs = nothing
		End With
		Set objCmd = Nothing

		FPassOk = FPassOk and (UCASE(EncedPassWord64)=UCASE(tmpEnc_userpass64))
		If Not FPassOk Then Exit Sub

		set FOneUser = new CTenUserItem
		FOneUser.FUserID = tmpuserid
		FOneUser.FUserDiv = tmpuserdiv
		FOneUser.FUserLevel = tmpuserlevel
		FOneUser.FLoginTime = tmplogintime
		FOneUser.FRealNameCheck = "Y" '// 기업회원은 실명인증을 받은 것으로 간주
		FOneUser.FUserSeq = tmpuseq

		sqlStr = " select top 1 uc.socname, uc.socmail, ISNULL(ua.isconfirm, 'N') as isconfirm " + vbCrlf
		sqlStr = sqlStr + " from [db_user].dbo.[tbl_user_c] uc " + vbCrlf
		sqlStr = sqlStr + " left join [db_user].[dbo].[tbl_user_c_auth] ua ON uc.userid = ua.userid " + vbCrlf
		sqlStr = sqlStr + " where uc.userid='" + FRectUserID + "'" + vbCrlf
		sqlStr = sqlStr + " and uc.userid<>''" + vbCrlf
		
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget, adOpenForwardOnly, adLockReadOnly
			if Not rsget.Eof then
				FOneUser.FUserName = db2html(rsget("socname"))
				FOneUser.FUserEmail = db2html(rsget("socmail"))
				FOneUser.FBizConfirm = db2html(rsget("isconfirm"))
			end if
		rsget.Close

		'// 로그인 카운터 및 기타 정보 저장
	    dim lastrefip
	    lastrefip = Left(request.ServerVariables("REMOTE_ADDR"),32)
	
		sqlStr = " update [db_user].dbo.[tbl_logindata]" & vbCrlf
		sqlStr = sqlStr & " set lastlogin=getdate()," & vbCrlf
		sqlStr = sqlStr & " counter=counter+1," & vbCrlf
		sqlStr = sqlStr & " lastrefip= ? "  & vbCrlf
		sqlStr = sqlStr & " where userid= ? "
		Set objCmd = Server.CreateObject("ADODB.COMMAND")
		With objCmd
			.ActiveConnection = dbget
			.CommandType = adCmdText
			.CommandText = sqlStr
			.Prepared = true
			.Parameters.Append .CreateParameter("lastrefip", adVarChar, adParamInput, Len(lastrefip), lastrefip)
			.Parameters.Append .CreateParameter("userid", adVarChar, adParamInput, Len(FRectUserID), FRectUserID)
			.Execute, , adExecuteNoRecords
		End With
		Set objCmd = Nothing
        
        ''2017/08/11 비회원 식별관련.
        sqlStr = "db_user.[dbo].[usp_TEN_User_LastGUID_ADD] '"&FRectUserID&"','"&fn_getGgsnCookie()&"'"
        dbget.execute sqlStr

	End Sub

	Private Sub Class_Initialize()
        FNotUsingSite = false
        FchkFingersAllow = false
	End Sub

	Private Sub Class_Terminate()

	End Sub

	'// 2018 회원등급 개편
	'// 정기 보너스 쿠폰 발급
	Sub publishBonusCoupon(uID,cType,cValue,cName,minPrice,uLv,maxDiscount)
		dim strSql, sDt, eDt
		sDt = DateSerial(Year(date),Month(date),1)		'쿠폰시작일
		eDt = DateSerial(Year(date),Month(date)+1,1)	'종료일 : 다음달 1일로 변경
	
		'트랜젝션 시작
		dbget.beginTrans
	
		strSql =	" Insert into [db_user].dbo.tbl_user_coupon " &_
					" (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice " &_
					"	,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid, uselevel, mxCpnDiscount) values " &_
					" (0,'" + uID + "','" & cType & "','" & cValue & "','" & cName & "','" & minPrice & "'" &_
					",'" & sDt & " 00:00:00','" & eDt & " 23:59:59','',0,'system'," & uLv & "," & maxDiscount & ") "
		dbget.Execute(strSql)
	
		If Err.Number = 0 Then   
			dbget.CommitTrans
		Else
		    dbget.RollBackTrans	
		end if
	end Sub
	
	'//2012년 8월 1Day 이벤트 쿠폰=============================================
	Sub CheckEventCouponProcess(userid)
	    const MasterIDX=352
	    
	    const StDt = "2012-08-31 00:00:00"
	    const EdDt = "2012-08-31 23:59:59"

	    dim sqlStr
    	dim eventCouponCount, IsNewCustomer
        eventCouponCount = 0
        IsNewCustomer = false

  
        if ((now()> CDate(StDt)) and (now()< CDate(EdDt))) then

            sqlStr = "select count(idx) as cnt "
            sqlStr = sqlStr & " From db_user.dbo.tbl_user_coupon "
            sqlStr = sqlStr & " where userid='" & userid & "'"
            sqlStr = sqlStr & " and masteridx in (" & CStr(MasterIDX) & ")"
            sqlStr = sqlStr & " and deleteyn='N'"
            
            rsget.Open sqlStr,dbget,1
                eventCouponCount = rsget("cnt")
            rsget.close

            if (eventCouponCount<1) then
                sqlStr =	" Insert into [db_user].dbo.tbl_user_coupon " &_
        					" (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice " &_
        					"	,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid) values " &_
        					" (" & CStr(MasterIDX) & ",'" + userid + "',1,10,'1 day coupon - 10%',30000" &_
        					",'" & StDt & "','" & EdDt & "','',0,'system') "
        		dbget.Execute(sqlStr)
            end if
        end if
        
    end Sub

	'// 지정 기간중 Staff 비밀번호 변경여부 확인 (2010.06.29; 허진원)
	Function checkStaffPasswordChange(uid,sdt,edt)
		if edt="" then edt=date
		'기간중에만 확인
		if datediff("d",sdt,date)>=0 and datediff("d",date,edt)>=0 then
			dim sqlStr, rstCnt

			sqlStr = "select count(idx) " &_
					" From db_log.dbo.tbl_user_updateLog " &_
					" Where userid='" & uid & "'" &_
					"	and updateDiv='P' " &_
					"	and regdate between '" & sdt & "' and '" & dateAdd("d",1,edt) & "'"
            rsget.Open sqlStr,dbget,1
                rstCnt = rsget(0)
            rsget.close

            if rstCnt>0 then
            	'변경내역 있음
            	checkStaffPasswordChange = true
            else
            	'변경내역 없음
            	checkStaffPasswordChange = false
            end if
		else
			checkStaffPasswordChange = true
		end if
	end Function
end Class

Function MLoginLogSave(vUserID,vIsSuccess,vSiteDiv,vDevice)
	'####### 수정후 웹쪽 WWWLoginLogSave, 핑거스 WWWLoginLogSave 확인 및 수정필.
	Dim vQuery, vIP, ilgnGuid
	vIP = Request.ServerVariables("REMOTE_ADDR")
	if (vIsSuccess="Y") then
	    ilgnGuid = LEFT(fn_getGgsnCookie(),40) ''2017/08/11 추가 성공시에만 저장.
    end if
	vQuery = "INSERT INTO [db_log].[dbo].[tbl_loginLog_IDX](userid, isSuccess, referIP, siteDiv, chkDevice, lgnGuid) VALUES('" & vUserID & "', '" & vIsSuccess & "', '" & vIP & "', '" & vSiteDiv & "', '" & vDevice & "','"&ilgnGuid&"')"
	dbget.Execute vQuery
End Function

Function CheckMyTalkNewComm(vUserID)
	Dim vQuery, vCnt
	vCnt = 0
	vQuery = "EXECUTE [db_board].[dbo].[sp_Ten_ShoppingTalk_MyTalkCommCheck] '" & vUserID & "'"
	rsget.Open vQuery,dbget,1
	If Not rsget.Eof Then
		vCnt = rsget(0)
	End IF
	rsget.close()
	If vCnt > 0 Then
		response.Cookies("uinfo")("isnewcomm") = "o"
	End If
End Function


Sub ClearLoginFailInfo(vUserID)
	'## 로그인 실패기록 삭제 (로그인 성공시)
	Dim vQuery
	if vUserID<>"" then
		vQuery = "Delete from [db_log].[dbo].[tbl_login_failInfo] Where userid='" & vUserID & "'"
		dbget.Execute vQuery
	end if
End Sub

Function ChkLoginFailInfo(vUserID, vChkOpt)
	'## 로그인 실패기록 검사 및 추가
	Dim vQuery, vIP, failCnt, failDate
	vIP = Request.ServerVariables("REMOTE_ADDR")
	if vUserID="" then Exit Function

	'// 실패정보 접수
	failCnt = 0
	'// 실패정보 접수
	Dim objCmd , vRs
	Set objCmd = Server.CreateObject("ADODB.COMMAND")
	With objCmd
		.ActiveConnection = dbget
		.CommandType = adCmdText
		.CommandText = "Select failCnt, failDate From [db_log].[dbo].[tbl_login_failInfo] Where userid= ?"
		.Prepared = true
		.Parameters.Append .CreateParameter("userid", adVarChar, adParamInput, Len(vUserID), vUserID)
		SET vRs = objCmd.Execute
			If Not(vRs.EOF or vRs.BOF) Then
				failCnt = vRs("failCnt")
				failDate = vRs("failDate")
			else
				failCnt = 0
			end if
		SET vRs = nothing
	End With
	Set objCmd = Nothing

	if vChkOpt="Add" then
		'// 실패정보 저장 (로그인 실패시 정보 저장)
		if failCnt>0 then
			'실패정보 업데이트
			failCnt = failCnt +1
			vQuery = "Update [db_log].[dbo].[tbl_login_failInfo] Set refip='" & vIP & "', failCnt='" & failCnt & "', failDate=getdate() Where userid='" & vUserID & "'"
			dbget.Execute vQuery
			ChkLoginFailInfo = failCnt
		else
			'실패정보 추가
			vQuery = "Insert into [db_log].[dbo].[tbl_login_failInfo] values ('" & vUserID & "','" & vIP & "', 1, getdate())"
			dbget.Execute vQuery
			ChkLoginFailInfo = 1
		end if

	elseif vChkOpt="Chk" then
		'// 실패정보 확인 (로그인 전 화인)
		if failCnt>0 then
			'제학시간이 지났는지 확인
			if DateDiff("n",failDate,now())>=5 then
				ClearLoginFailInfo(vUserID)		'삭제
				ChkLoginFailInfo = 0
			else
				ChkLoginFailInfo = failCnt
			end if
		else
			ChkLoginFailInfo = 0
		end if
	else
		ChkLoginFailInfo = 0
	end if
End Function
%>
