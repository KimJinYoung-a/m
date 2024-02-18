<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
'	Description : 카카오톡
'	History	:  2014.01.08 한용민 생성
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/apps/kakaotalk/lib/kakaotalk_config.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->

<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>

<%
Dim mode, usrHp, certifyNo, tmpUserKey, chkMsgRst, strhp, strData, jsData, strResult, oResult, strUserKey, sqlStr
Dim userid, chkCp
	mode = requestCheckVar(Request("mode"),6)
	usrHp = requestCheckVar(Request("hpNo1"),4) & "-" & requestCheckVar(Request("hpNo2"),4) & "-" & requestCheckVar(Request("hpNo3"),4)
	certifyNo = requestCheckVar(Request("certifyNo"),4)
	tmpUserKey = requestCheckVar(Request("tmpUserKey"),32)
	userid = getEncLoginUserID

if userid="" then
	response.write "9999"		'//로그인을 해주세요
    dbget.close()	:	response.end
end if

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
		'response.write "1000"
		'dbget.close()	:	response.end

		'// 카카오톡 회원 인증번호 받기
		if Len(usrHp)<10 then
			chkMsgRst = "잘못된 휴대폰번호입니다."
							
			response.write "2"
			dbget.close()	:	response.end
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
					response.write "1000"
					dbget.close()	:	response.end
			
					'// 성공! 다음단계로 이동
				Case "3009"
					chkMsgRst = "이전에 받으신 인증번호가 아직 유효합니다.\n먼저 받으신 번호를 입력해주세요."
					
					response.write "3009"
					dbget.close()	:	response.end
				Case "2103"
					chkMsgRst = "본 서비스는 스마트폰에 카카오톡이 설치되어 있어야 이용이 가능합니다.\n카카오톡이 설치 되어있지 않다면 설치 후 이용해주시기 바랍니다."
					
					response.write "2103"
					dbget.close()	:	response.end
				Case Else
					chkMsgRst = getErrCodeNm(strResult) & "입니다."
					
					response.write chkMsgRst
					dbget.close()	:	response.end
			end Select
		end if

	Case "step2"
		'response.write "1000"
		'dbget.close()	:	response.end

		'// 인증번호 확인 및 친구 맺기
		if Len(certifyNo)<4 or Not(isNumeric(certifyNo)) then
			chkMsgRst = "잘못된 인증번호입니다."

			response.write "2"
			dbget.close()	:	response.end
		elseif len(replace(usrHp,"-",""))<10 or Not(isNumeric(replace(usrHp,"-",""))) then
			chkMsgRst = "잘못된 휴대폰번호입니다."

			response.write "3"
			dbget.close()	:	response.end
		else
			strhp = tranPhoneNo(usrHp,"82")
						
			'JSON데이터 생성
			Set strData = jsObject()
				strData("plus_key") = TentenId
				strData("phone_number") = strhp
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
					
					'response.write sqlStr & "<Br>"
					dbget.execute(sqlStr)
				end if

				sqlStr = "Insert into db_sms.dbo.tbl_kakaoUser (userid,kakaoUserKey,phoneNum) values " &_
						" ('" & userid & "'" &_
						" ,'" & strUserKey & "'" &_
						" ,'" & strhp & "')"
				
				'response.write sqlStr & "<Br>"
				dbget.execute(sqlStr)

				'개인정보 수정(휴대폰번호 변경)
				if tranKorNrmPNo(strhp)<>"" then
					sqlStr = "if Not Exists (select usercell " &_
							"	from db_user.dbo.tbl_user_n " &_
							"	where userid='" & userid & "' " &_
							"		and usercell='" & tranKorNrmPNo(strhp) & "') " &_
							" begin " &_
							"	Update db_user.dbo.tbl_user_n " &_
							"	Set usercell='" & tranKorNrmPNo(strhp) & "'" &_
							"	Where userid='" & userid & "'" &_
							" end"
							
					'response.write sqlStr & "<Br>"
					''dbget.execute(sqlStr)		''카톡 정보가 정확하지 않을 수 있음 (→회원 정보 변경 안함;20150630_허진원)
				end if

				'Log 저장 (N:PC추가/M:모바일추가)
				Call putKakaoAuthLog(userid, strUserKey, "M")

				'오픈이벤트 - 쿠폰발급
				if date<="2012-09-15" then
					chkCp = fnIssueTMSCoupon()
				end if

				response.write "1000"
				dbget.close()	:	response.end
			
			elseif cStr(strResult)="3008" then
				response.write "3008"
				dbget.close()	:	response.end
			else
				chkMsgRst = getErrCodeNm(strResult) & "입니다."

				response.write chkMsgRst
				dbget.close()	:	response.end
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
					
					'response.write sqlStr & "<Br>"
					dbget.execute(sqlStr)
				end if

				sqlStr = "Insert into db_sms.dbo.tbl_kakaoUser (userid,kakaoUserKey,phoneNum) values " &_
						" ('" & userid & "'" &_
						" ,'" & strUserKey & "'" &_
						" ,'" & strhp & "')"
				
				'response.write sqlStr & "<Br>"
				dbget.execute(sqlStr)

				'Log 저장 (N:PC추가/M:모바일추가)
				Call putKakaoAuthLog(userid, strUserKey, "M")

				response.Write "<script type='text/javascript'>" &_
							"parent.document.frm.target='';" &_
							"parent.document.frm.action='/apps/appCom/wish/web2014/my10x10/kakaotalk/layer_step3.asp';" &_
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
			chkMsgRst = "회원님은 텐바이텐의 카카오톡 맞춤정보 서비스가 신청되어있지 않습니다."

			response.write "2"
			dbget.close()	:	response.end
		end if

		'관계정보 접수
		sqlStr = "Select top 1 kakaoUserKey From db_sms.dbo.tbl_kakaoUser Where userid='" & userid & "'"
		
		'response.write sqlStr & "<Br>"
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

					response.write "1"
					dbget.close()	:	response.end
				Case else
					chkMsgRst = getErrCodeNm(strResult) & "입니다."

					response.write chkMsgRst
					dbget.close()	:	response.end
			end Select
		else
			chkMsgRst = "카카오톡 서비스를 이용하고 계시지 않습니다."

			response.write "3"
			dbget.close()	:	response.end
		end if

	Case Else
		chkMsgRst = "잘못된 접근입니다."
End Select

response.write chkMsgRst
dbget.close()	:	response.end

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