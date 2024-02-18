<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/membercls/userloginclass.asp" -->
<!-- #include virtual="/lib/classes/membercls/clsMyAnniversary.asp" -->
<!-- #include virtual="/lib/classes/cscenter/eventprizeCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<!-- #include virtual="/lib/util/jwtLib.asp" -->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/snsloginProc.asp
' Discription : SNS 로그인 처리
' Request : json > type, userno, gubun, email, code
' Response : response > 결과, type, userid, cart, newfollower, newproductzzim, myiconid, ulevelstr, ucouponcnt, umile, recentordercnt
' History : 2017.06.02 허진원 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "text/html"

Dim sFDesc
Dim sTenToken, sKey, bTkVerify, sUserid, sOS, snID, sDeviceId, sAppKey, sVerCd
dim sCartNo, sUlvStr, sUsrCpCnt, sUsrMile, sUserOrdCnt
Dim sType, sUserNo, sGubun, sEmail, sSnsToken, sGender
Dim sData : sData = Request.form("json")
Dim oJson


'// HEADER 데이터 접수
sTenToken = request.ServerVariables("HTTP_Authorization")
if instr(lcase(sTenToken),"bearer ")>0 then
	sTenToken = right(sTenToken,len(sTenToken)-instr(sTenToken," "))
else
	Set oJson = jsObject()
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "잘못된 접근입니다.[E01]"
	oJson.flush
	Set oJson = Nothing
	response.End
end if

'=========================================================
'// 토큰키 !!!
sKey = "ThBxhdcEeCThSeJNSkJAwYRkbYSMkSwtELmScn"

'// JWT 확인
Dim jwt
Set jwt = new cJwt
bTkVerify = jwt.verify(sTenToken,sKey)
Set jwt = Nothing

if Not(bTkVerify) then
	Set oJson = jsObject()
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "토큰 인증이 실패했습니다.[E02]"
	oJson.flush
	Set oJson = Nothing
	response.End
end if
'=========================================================


'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = requestCheckVar(oResult.type,6)
	sUserNo = requestCheckVar(oResult.userno,64)
	sGubun = lCase(requestCheckVar(oResult.gubun,2))
	sEmail = requestCheckVar(oResult.email,128)
	sSnsToken = requestCheckVar(oResult.code,256)
	sDeviceId = requestCheckVar(oResult.pushid,256)
	sVerCd = requestCheckVar(oResult.versioncode,20)
	sOS = requestCheckVar(oResult.OS,10)

	'DeviceID 정보 업데이트
	sAppKey = getWishAppKey(sOS)

    if Not ERR THEN
	    sUserid = requestCheckVar(oResult.userid,32)
	    sGender = requestCheckVar(oResult.gender,1)
	    if ERR THEN Err.Clear ''회원id 프로토콜 없음
    END IF

    if Not ERR THEN
	    snID = requestCheckVar(oResult.nid,40)
	    if ERR THEN Err.Clear ''nid 프로토콜 없음
    END IF
set oResult = Nothing


'// json객체 선언
Set oJson = jsObject()

If Not(sType="login" or sType="conn" or sType="disc") then
	'// 잘못된 콜싸인 아님
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "잘못된 접근입니다.[E03]"

elseif sUserNo="" then
	'// 필수 파라메터 없음
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "파라메터 정보가 잘못됐습니다.[E04]"

elseif Not(sGubun="nv" or sGubun="fb" or sGubun="gl" or sGubun="ka" or sGubun="ap") then
	'// SNS 구분 파라메터 잘못됨
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "파라메터 정보가 잘못됐습니다.[E05]"

elseif sSnsToken="" then
	'// SNS 인증 토큰 없음
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "파라메터 정보가 잘못됐습니다.[E06]"

elseif (sType="conn" or sType="disc") and sUserid="" then
	'// SNS 인증 토큰 없음
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "파라메터 정보가 잘못됐습니다.[E07]"

elseif (sType="conn" or sType="disc") and (getEncLoginUserID="" or lcase(getEncLoginUserID)<>lcase(sUserid)) then
	'// 로그인 여부 확인
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "로그인이 실패했습니다. [E08]"

else
	dim sqlStr, addSql, chkMode

	'// 실행 타입별 분기
	Select Case sType
		Case "login"		'// 로그인 처리
			'// SNS토큰 저장
			dim tkcnt
			sqlStr = "select count(*) From [db_user].[dbo].[tbl_user_sns_token] where snsid='"&sUserNo&"' and snsgubun='"&sGubun&"' and snstoken='"&sSnsToken&"' "
			rsget.CursorLocation = adUseClient
			rsget.Open sqlStr,dbget, adOpenForwardOnly, adLockReadOnly
				tkcnt = rsget(0)
			rsget.close

			if tkcnt = 0 then
				sqlstr = "delete from [db_user].[dbo].[tbl_user_sns_token] where snsid='"&sUserNo&"' and snsgubun='"&sGubun&"'; " & vbCrLf
				sqlstr = sqlstr & "INSERT INTO [db_user].[dbo].[tbl_user_sns_token](snsid, snstoken, snsgubun)" + vbcrlf
				sqlstr = sqlstr & " VALUES( '"& sUserNo &"', '" & sSnsToken & "', '" & sGubun & "')" + vbcrlf	
				dbget.execute sqlstr
			end if

			'// SNS:텐바이텐 연동 여부 확인
			sqlStr = " select top 1 tenbytenid " + VbCrlf
			sqlStr = sqlStr + " from db_user.dbo.tbl_user_sns with(nolock)" + vbCrlf
			sqlStr = sqlStr + " where snsid='" & sUserNo & "' and snsgubun='" & sGubun & "' and isusing='Y' " + vbCrlf
			rsget.CursorLocation = adUseClient
			rsget.Open sqlStr,dbget, adOpenForwardOnly, adLockReadOnly
			if Not rsget.Eof then
				chkMode = "loginok"
				sUserid = rsget("tenbytenid")
			else
				chkMode = "notConn"
			end if
			rsget.Close

		Case "conn"		'// SNS 연동 처리
			'연동 여부 화인
			sqlStr = " select top 1 tenbytenid, snsid " + VbCrlf
			sqlStr = sqlStr + " from db_user.dbo.tbl_user_sns with(nolock)" + vbCrlf
			sqlStr = sqlStr + " where (tenbytenid='" & sUserid & "' or snsid='" & sUserNo & "') and snsgubun='" & sGubun & "' and isusing='Y' " + vbCrlf
			rsget.CursorLocation = adUseClient
			rsget.Open sqlStr,dbget, adOpenForwardOnly, adLockReadOnly
			if Not rsget.Eof then
				if cStr(rsget("snsid"))=cStr(sUserNo) and cStr(rsget("tenbytenid"))<>cStr(sUserid) then
					'다른 텐바이텐 아이디 아이디가 있는경우
					chkMode = "errConn2"
				elseif cStr(rsget("snsid"))<>cStr(sUserNo) and cStr(rsget("tenbytenid"))=cStr(sUserid) then
					'다른 소셜 아이디가 있는 경우
					chkMode = "errConn3"
				else
					'이미 등록됨
					chkMode = "errConn1"
				end if
				rsget.Close
			end if

			'연동 처리
			if chkMode="" then
				sqlstr = "insert into [db_user].[dbo].[tbl_user_sns]  (snsgubun, tenbytenid, snsid, usermail, sexflag, isusing ) values " & vbCrlf
				sqlstr = sqlstr & " ( '"& sGubun &"' " & vbCrlf
				sqlstr = sqlstr & " , '"& sUserid &"' " & vbCrlf
				sqlstr = sqlstr & " , '"& sUserNo & "' " & vbCrlf
				sqlstr = sqlstr & " , '"& sEmail &"' " & vbCrlf
				sqlstr = sqlstr & " , '"& sGender &"' " & vbCrlf
				sqlstr = sqlstr & " , 'Y') " & vbCrlf
				dbget.Execute(sqlStr)

				IF Not(Err) then chkMode = "procOk"
			end if

		Case "disc"		'// SNS 연동 해제 처리
			'연동 여부 화인
			sqlStr = " select count(*) cnt " + VbCrlf
			sqlStr = sqlStr + " from db_user.dbo.tbl_user_sns with(nolock)" + vbCrlf
			sqlStr = sqlStr + " where tenbytenid='" & sUserid & "' and snsgubun='" & sGubun & "' and isusing='Y' " + vbCrlf
			'' sqlStr = sqlStr + " and snsid='" & sUserNo & "' "		'SNS 회원번호까지 고려했을때(다계정 중복 허용 일 때)
			rsget.CursorLocation = adUseClient
			rsget.Open sqlStr,dbget, adOpenForwardOnly, adLockReadOnly
			if rsget("cnt")<=0 then
				chkMode = "errConn4"
			end if
			rsget.Close

			'연동 해제 처리
			if chkMode="" then
				sqlstr = "delete from [db_user].[dbo].[tbl_user_sns] where tenbytenid='" & sUserid & "' and snsgubun='"&sGubun&"' and isusing='Y' " + vbcrlf
				dbget.execute sqlstr

				IF Not(Err) then chkMode = "procOk"
			end if
	End Select

	'-------------------------------------

	'// 결과데이터 생성
	Select Case chkMode
		Case "loginok"
			'// 이미 연동 되어있는 경우 성공시 (요청 type: login)
			oJson("response") = getErrMsg("1000",sFDesc)
			oJson("type") = cStr("login")
			oJson("userid") = cStr(sUserid)

		Case "notConn"
			'// 연동이 안되어있는 경우 성공시 (요청 type: login)
			oJson("response") = getErrMsg("1000",sFDesc)
			oJson("type") = "join"

		Case "procOk"
			'// 처리 요청 성공시 (요청 type: conn/disc)
			oJson("response") = getErrMsg("1000",sFDesc)
			oJson("type") = "complete"

		Case "errConn1"
			'// 이미 연동되어있음(오류)
			oJson("response") = getErrMsg("9999",sFDesc)
			oJson("faildesc") = "이미 텐바이텐 계정에 로그인 연동이 되어있습니다. 다시 로그인해주세요."

		Case "errConn2"
			'// 이미 연동되어있음(다른 텐텐계정)
			oJson("response") = getErrMsg("9999",sFDesc)
			oJson("faildesc") = fnGetSnsGubunName(sGubun) & " 계정이 다른 텐바이텐 계정과 연동 되어있습니다."

		Case "errConn3"
			'// 이미 연동되어있음(다른 소셜계정)
			oJson("response") = getErrMsg("9999",sFDesc)
			oJson("faildesc") = "이미 다른 " & fnGetSnsGubunName(sGubun) & " 계정과 연동 되어있습니다." & vbCrLf & "※ 변경을 원하시면 마이텐바이텐>개인정보수정에서 연결 해제 후 다시 시도해주세요!"

		Case "errConn4"
			'// 연동이 안되어있음
			oJson("response") = getErrMsg("9999",sFDesc)
			oJson("faildesc") = fnGetSnsGubunName(sGubun) & " 계정과 로그인 연동이 필요합니다."
	End Select
end if

IF (Err) then
	Set oJson = jsObject()
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."
End if

if ERR then Call OnErrNoti()		'// 오류 이메일로 발송
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing

'// 쇼셜 서비스명 변환
function fnGetSnsGubunName(sb)
	Select Case sb
		Case "nv"
			fnGetSnsGubunName = "네이버"
		Case "fb"
			fnGetSnsGubunName = "페이스북"
		Case "gl"
			fnGetSnsGubunName = "구글"
		Case "ka"
			fnGetSnsGubunName = "카카오"
		Case "ap"
			fnGetSnsGubunName = "애플"
	End Select
end function
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->