<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
response.charset = "utf-8"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/apps/kakaotalk/lib/kakaotalk_config.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
	Dim mode, usrHp, fullhp, certifyNo, tmpUserKey
	Dim chkMsgRst
	Dim strhp, strData, jsData, strResult, oResult, strUserKey, sqlStr
	Dim userid, chkCp

	mode = requestCheckVar(Request("mode"),6)
	usrHp = requestCheckVar(Request.form("hpNo1"),4) & "-" & requestCheckVar(Request.form("hpNo2"),4) & "-" & requestCheckVar(Request.form("hpNo3"),4)
	fullhp = requestCheckVar(Request.form("fullhp"),12)
	certifyNo = requestCheckVar(Request.form("certifyNo"),4)
	tmpUserKey = requestCheckVar(Request("tmpUserKey"),32)
	userid = GetLoginUserID

	dim myUserInfo, chkKakao
	chkKakao = false
	set myUserInfo = new CUserInfo
	myUserInfo.FRectUserID = userid
	if (userid<>"") then
	    chkKakao = myUserInfo.chkKakaoAuthUser	'// 카카오톡 인증여부
	    if usrHp<>"" then
			'myUserInfo.GetUserData
			'usrHp = myUserInfo.FOneItem.Fusercell
		end if
	end if
	set myUserInfo = Nothing

	Select Case mode
		Case "step1"
			'// 카카오톡 회원 인증번호 받기
			if Len(usrHp)<10 then
				chkMsgRst = "잘못된 휴대폰번호입니다."
			else
				strhp = tranPhoneNo(usrHp,"82")
				'JSON데이터 생성
				Set strData = jsObject()
					strData("plus_key") = TentenId
					strData("phone_number") = strhp
					jsData = strData.jsString
				Set strData = Nothing

				'// 카카오톡에 전송/결과 접수
				strResult = fnSendKakaotalk("cert",jsData)

				'// 전송결과 파징
				on Error Resume Next
				set oResult = JSON.parse(strResult)
					strResult = oResult.result_code
				set oResult = Nothing
				On Error Goto 0

				'// 완료 처리, 인증번호 받기 페이지로 이동
				Select Case cStr(strResult)
					Case "1000"
						'// 성공! 다음단계로 이동
						response.Write "<script type='text/javascript'>" &_
									"parent.document.frm.target='';" &_
									"parent.document.frm.fullhp.value='" & strhp & "';" &_
									"parent.document.frm.action='step2.asp';" &_
									"parent.document.frm.submit();" &_
									"</script>"
						response.End
					Case "3009"
						'// 인증 받은지 3분이내 - 안내문 출력 후 다음단계로 이동
						response.Write "<script type='text/javascript'>" &_
									"alert('이전에 받으신 인증번호가 아직 유효합니다.\n먼저 받으신 번호를 입력해주세요.');" &_
									"parent.document.frm.target='';" &_
									"parent.document.frm.fullhp.value='" & strhp & "';" &_
									"parent.document.frm.action='step2.asp';" &_
									"parent.document.frm.submit();" &_
									"</script>"
						response.End
					Case "2103"
						chkMsgRst = "본 서비스는 스마트폰에 카카오톡이 설치되어 있어야 이용이 가능합니다.\n카카오톡이 설치 되어있지 않다면 설치 후 이용해주시기 바랍니다."
					Case Else
						chkMsgRst = getErrCodeNm(strResult) & "입니다."
				end Select

			end if

		Case "step2"
			'// 인증번호 확인 및 친구 맺기
			if Len(certifyNo)<4 or Not(isNumeric(certifyNo)) then
				chkMsgRst = "잘못된 인증번호입니다."
			elseif len(fullhp)<11 or Not(isNumeric(fullhp)) then
				chkMsgRst = "잘못된 휴대폰번호입니다."
			else
				'JSON데이터 생성
				Set strData = jsObject()
					strData("plus_key") = TentenId
					strData("phone_number") = fullhp
					strData("cert_code") = certifyNo
					jsData = strData.jsString
				Set strData = Nothing

				'// 카카오톡에 전송/결과 접수
				strResult = fnSendKakaotalk("usr",jsData)

				'// 전송결과 파징
				on Error Resume Next
				set oResult = JSON.parse(strResult)
					strResult = oResult.result_code
					if cStr(strResult)="1000" then
						strUserKey = oResult.user_key
					end if
				set oResult = Nothing
				On Error Goto 0

				'// 친구관계 저장 처리
				if cStr(strResult)="1000" then
					if chkKakao then
						'이미 신청된 회원은 기존 정보 삭제(재인증이되면 카카오측에서는 이미 해제되어있음)
						sqlStr = "Delete from db_sms.dbo.tbl_kakaoUser Where userid='" & userid & "'"
						dbget.execute(sqlStr)
					end if

					sqlStr = "Insert into db_sms.dbo.tbl_kakaoUser (userid,kakaoUserKey,phoneNum) values " &_
							" ('" & userid & "'" &_
							" ,'" & strUserKey & "'" &_
							" ,'" & fullhp & "')"
					dbget.execute(sqlStr)

					'개인정보 수정(휴대폰번호 변경)
					if tranKorNrmPNo(fullhp)<>"" then
						sqlStr = "if Not Exists (select usercell " &_
								"	from db_user.dbo.tbl_user_n " &_
								"	where userid='" & userid & "' " &_
								"		and usercell='" & tranKorNrmPNo(fullhp) & "') " &_
								" begin " &_
								"	Update db_user.dbo.tbl_user_n " &_
								"	Set usercell='" & tranKorNrmPNo(fullhp) & "'" &_
								"	Where userid='" & userid & "'" &_
								" end"
						''dbget.execute(sqlStr)		''카톡 정보가 정확하지 않을 수 있음 (→회원 정보 변경 안함;20150630_허진원)
					end if

					'Log 저장 (N:PC추가/M:모바일추가)
					Call putKakaoAuthLog(userid, strUserKey, "M")

					'오픈이벤트 - 쿠폰발급
					if date<="2012-09-15" then
						chkCp = fnIssueTMSCoupon()
					end if

					response.Write "<script type='text/javascript'>" &_
								"parent.document.frm.target='';" &_
								"parent.document.frm.action='step3.asp';" &_
								"parent.document.frm.cp.value='" & chkCp & "';" &_
								"parent.document.frm.submit();" &_
								"</script>"
					response.End
				elseif cStr(strResult)="3008" then
					response.Write "<script type='text/javascript'>" &_
								"alert('인증번호가 만료되었습니다.\n새로운 인증번호를 받아주세요.');" &_
								"parent.document.frm.target='';" &_
								"parent.document.frm.action='step1.asp';" &_
								"parent.document.frm.submit();" &_
								"</script>"
					response.End
				else
					chkMsgRst = getErrCodeNm(strResult) & "입니다."
				end if
			end if

		Case "AddTmp"
			'// 임시인증번호 확인 및 친구 맺기
			if Len(certifyNo)<16 or Not(isNumeric(certifyNo)) then
				chkMsgRst = "잘못된 인증번호입니다."
			else
				'JSON데이터 생성
				Set strData = jsObject()
					strData("plus_key") = TentenId
					strData("temp_user_key") = tmpUserKey
					jsData = strData.jsString
				Set strData = Nothing

				'// 카카오톡에 전송/결과 접수
				strResult = fnSendKakaotalk("usrTmp",jsData)

				'// 전송결과 파징
				on Error Resume Next
				set oResult = JSON.parse(strResult)
					strResult = oResult.result_code
					if cStr(strResult)="1000" then
						strUserKey = oResult.user_key
					end if
				set oResult = Nothing
				On Error Goto 0

				'// 친구관계 저장 처리
				if cStr(strResult)="1000" then
					if chkKakao then
						'이미 신청된 회원은 기존 정보 삭제(재인증이되면 카카오측에서는 이미 해제되어있음)
						sqlStr = "Delete from db_sms.dbo.tbl_kakaoUser Where userid='" & userid & "'"
						dbget.execute(sqlStr)
					end if

					sqlStr = "Insert into db_sms.dbo.tbl_kakaoUser (userid,kakaoUserKey,phoneNum) values " &_
							" ('" & userid & "'" &_
							" ,'" & strUserKey & "'" &_
							" ,'" & fullhp & "')"
					dbget.execute(sqlStr)

					'Log 저장 (N:PC추가/M:모바일추가)
					Call putKakaoAuthLog(userid, strUserKey, "M")

					response.Write "<script type='text/javascript'>" &_
								"parent.document.frm.target='';" &_
								"parent.document.frm.action='step3.asp';" &_
								"parent.document.frm.submit();" &_
								"</script>"
					response.End
				else
					chkMsgRst = getErrCodeNm(strResult) & "입니다."
				end if
			end if

		Case "clear"
			'// 친구관계 해제
			if Not(chkKakao) then
				Call Alert_Move("회원님은 텐바이텐의 카카오톡 맞춤정보 서비스가 신청되어있지 않습니다.","about:blank")
				Response.End
			end if

			'관계정보 접수
			sqlStr = "Select top 1 kakaoUserKey From db_sms.dbo.tbl_kakaoUser Where userid='" & userid & "'"
			rsget.Open sqlStr,dbget,1
			if Not(rsget.EOF or rsget.BOF) then
				strUserKey = rsget(0)
			end if
			rsget.Close

			if strUserKey<>"" then
				'JSON데이터 생성
				Set strData = jsObject()
					strData("plus_key") = TentenId
					strData("user_key") = strUserKey
					jsData = strData.jsString
				Set strData = Nothing

				'// 카카오톡에 전송/결과 접수
				strResult = fnSendKakaotalk("delUsr",jsData)

				'// 전송결과 파징
				on Error Resume Next
				set oResult = JSON.parse(strResult)
					strResult = oResult.result_code
				set oResult = Nothing
				On Error Goto 0

				'// 친구관계 정리 처리
				Select Case cStr(strResult)
					Case "1000", "2101", "2102"
						sqlStr = "Delete From db_sms.dbo.tbl_kakaoUser " &_
								" Where userid='" & userid & "'"
						dbget.execute(sqlStr)

						'Log 저장 (D:PC삭제/E:모바일삭제)
						Call putKakaoAuthLog(userid, strUserKey, "E")

						response.Write "<script type='text/javascript'>" &_
									"	alert('카카오톡 맞춤정보 서비스가 해제되었습니다.');" &_
									"	parent.opener.location.reload();" &_
									"	parent.close();" &_
									"</script>"
						response.End
					Case else
						chkMsgRst = getErrCodeNm(strResult) & "입니다."
				end Select
			else
				chkMsgRst = "카카오톡 서비스를 이용하고 계시지 않습니다."
			end if

		Case Else
			chkMsgRst = "잘못된 접근입니다."
	End Select

	if chkMsgRst<>"" then
		Call Alert_Move(chkMsgRst,"about:blank")
	end if

	'// 감사 쿠폰 발급 함수(쿠폰프로모션: 333)
	Function fnIssueTMSCoupon()
		dim strSql
		strSql = "Select Count(*) from db_user.dbo.tbl_user_coupon " &_
				"	where userid='" & userid & "' " &_
				"		and masteridx=333"
		rsget.Open strSql,dbget,1
		if rsget(0)=0 then
			strSql = "insert into [db_user].dbo.tbl_user_coupon " &_
				"		(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice " &_
				"		,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid) " &_
				"		select 333,userid,'2','3000','카카오톡 맞춤정보 서비스 감사쿠폰','30000' " &_
				"			,'2012-07-26 00:00:00','2012-09-15 23:59:59','',0,'system' " &_
				"		from db_user.dbo.tbl_user_n " &_
				"		where userid='" & userid & "'"
			dbget.Execute(strSql)
			fnIssueTMSCoupon = "Y"
		else
			fnIssueTMSCoupon = "N"
		end if
		rsget.Close
	end Function
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->