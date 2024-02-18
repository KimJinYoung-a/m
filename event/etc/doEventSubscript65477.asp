<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 비밀의방 초대권
' History : 2015.08.14 원승현 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%	
dim eCode, userid, getbonuscoupon, currenttime, getlimitcnt, vmode, apgubun, vprocdate, strSql, sqlstr, totcnt, refer, vchasu, vQuery, refip
	IF application("Svr_Info") = "Dev" THEN
		eCode = "64854"
	Else
		eCode = "65477"
	End If

	userid = getloginuserid()
	refer = request.ServerVariables("HTTP_REFERER")
	vmode = requestcheckvar(request("mode"),32)
	vprocdate = requestcheckvar(request("procdate"),32)
	vchasu = requestcheckvar(request("chasu"),32)
	refip = Request.ServerVariables("REMOTE_ADDR")

	If isApp="1" Then
		apgubun = "A"
	Else
		apgubun = "M"
	End If


	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		dbget.close() : Response.End
	end if

	If not( left(now(),10)>="2015-08-14" and left(now(),10)<"2015-08-29" ) Then
		Response.Write "Err|이벤트 응모 기간이 아닙니다."
		dbget.close() : Response.End
	End If

	If userid = "" Then
		Response.Write "Err|로그인이 필요한 서비스 입니다."
		dbget.close() : Response.End
	End If

	'// app_reg_info에 deviceid값이 없으면 등록이 안되므로 체크한다.
	strSql = "select * from db_contents.dbo.tbl_app_regInfo where userid = '"& UserID &"' And  deviceid<>'' " 
	rsget.Open strSql,dbget,1
	IF (rsget.bof Or rsget.Eof) Then
		Response.Write "Err|푸시 설정을 허용으로 변경해주세요."
		dbget.close() : Response.End		
	End IF
	rsget.close()



	Select Case Trim(vmode)

		Case "kakao"
			'// 로그 넣음
			vQuery = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value3, device)" + vbcrlf
			vQuery = vQuery & " VALUES("& eCode &", '"& userid &"', '"&refip&"', '비밀의방 카카오톡 클릭 카운트', '"&apgubun&"')"
			dbget.execute vQuery
			Response.write "99"
			Response.End

		Case "appdown"
			'// 로그 넣음
			vQuery = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value3, device)" + vbcrlf
			vQuery = vQuery & " VALUES("& eCode &", '"& userid &"', '"&refip&"', '비밀의방 앱다운로드 카운트', '"&apgubun&"')"
			dbget.execute vQuery
			Response.write "OK"
			Response.End

		Case "invite"
			If userid = "" Then
				Response.Write "Err|로그인을 해야>?n이벤트에 참여할 수 있어요."
				dbget.close() : Response.End
			End If

			'// 신청여부 확인
			strSql = "select count(*) from db_event.dbo.tbl_event_subscript where userid = '"& UserID &"' and evt_code = '"& ecode &"' And sub_opt1 = '"&Trim(vprocdate)&"' " 
			rsget.Open strSql,dbget,1
			IF Not rsget.Eof Then
				totcnt = rsget(0)
			End IF
			rsget.close()

			If totcnt > 0 Then
				Response.Write "Err|이미 초대권을 신청하셨습니다."
				dbget.close() : Response.End
			Else
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& vprocdate &"', '"&vchasu&"', '', '"&apgubun&"')" + vbcrlf
				'response.write sqlstr & "<Br>"
				dbget.execute sqlstr

				Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2015/65477/txt_invite_letter.png' alt='초대장이 신청되었습니다 초대권을 받기 위해선 PUSH(알림) 수신동의를 하셔야 합니다. app의 알림설정을 확인해주세요.' /></p><button type='button' class='btnclose' onclick=fnlaclose();return false;><img src='http://webimage.10x10.co.kr/eventIMG/2015/65477/btn_close.png' alt='초대장 발송 레이어 팝업 닫기' /></button>"
				dbget.close()	:	response.End
			End If

		Case Else
			If userid = "" Then
				Response.Write "Err|로그인을 해야>?n이벤트에 참여할 수 있어요."
				dbget.close() : Response.End
			End If
			
			Response.Write "Err|잘못된 접속입니다."
			dbget.close() : Response.End

	End Select


	


%>
<!-- #include virtual="/lib/db/dbclose.asp" -->