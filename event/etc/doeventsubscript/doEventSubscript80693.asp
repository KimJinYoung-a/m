<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'#############################################################
' Description : 모바일 APP 유입 이벤트
' History : 2017-09-22 허진원 생성
'#############################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
	dim referer, apgubun, nowDate
	Dim UserAppearChk, vPid, vUuid
	referer = request.ServerVariables("HTTP_REFERER")

	Dim eCode, userid
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  66434
	Else
		eCode   =  80693
	End If

	nowDate = date
	'nowdate = "2017-09-25"

	vPid = RequestCheckVar(request("pid"),256)		'푸시ID
	vUuid = RequestCheckVar(request("uid"),40)		'UUID

	'// 아이디
	userid = getEncLoginUserid()

	'// 모바일웹&앱전용
	If isApp="1" Then
		apgubun = "A"
	Else
		apgubun = "M"
	End If

	if InStr(referer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		dbget.close() : Response.End
	end If

	If not(nowdate >= "2017-09-25" and nowdate < "2017-10-01") Then
		Response.Write "Err|이벤트 응모기간이 아닙니다."
		dbget.close() : Response.End
	End If

	'// 푸시ID 파라메터 확인
	if vPid="" and vUuid="" then
		Response.Write "Err|단말기 정보를 확인할 수가 없습니다.>?n앱 종료 후 다시 구동해주세요."
		dbget.close() : Response.End
	end if

	if Not(chkPushAgree(vPid,vUuid)) then
		Response.Write "Err|앱 푸시 알림 수신에 동의해주세요!"
		dbget.close() : Response.End
	end if

	'// 로그인시에만 응모가능
	If not(IsUserLoginOK()) Then
		Response.Write "Err|로그인을 하셔야>?n설문에 참아하실 수 있습니다."
		dbget.close() : Response.End
	End If

	'과거 응모 확인
	if userid <> "" then 
		UserAppearChk = getevent_subscriptexistscount(eCode,userid,"","","")
	else
		UserAppearChk=1
	end if
	
	if UserAppearChk > 0 then
		Response.Write "Err|이미 응모 하셨습니다.>?n당첨자 발표일을 기다려주세요."
		dbget.close() : Response.End
	end if

	

	'// 이벤트 참여(참여 데이터를 넣는다.)
	Call InsAppearData(eCode, userid, apgubun, "", "", "")
	Response.Write "OK|1"
	dbget.close() : Response.End


	Function InsAppearData(evt_code, uid, device, sub_opt1, sub_opt2, sub_opt3)
		Dim vQuery
		vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid, device, sub_opt1, sub_opt2, sub_opt3, regdate)" & vbCrlf
		vQuery = vQuery & " VALUES ("& evt_code &", '"& uid &"', '"&device&"','"&sub_opt1&"','"&sub_opt2&"', '"&sub_opt3&"', getdate())"
		dbget.execute vQuery
	End Function

	Function chkPushAgree(pid,uuid)
		Dim vQuery
		vQuery = "select top 1 pushyn from db_log.dbo.tbl_APP_pushYN_log " & vbCrLf
		if pid<>"" and uuid="" then
			vQuery = vQuery & " where deviceid='" & pid & "' " & vbCrLf
		elseif pid="" and uuid<>"" then
			vQuery = vQuery & " where uuId='" & uuid & "' " & vbCrLf
		else
			vQuery = vQuery & " where deviceid='" & pid & "' " & vbCrLf
			vQuery = vQuery & " 	or uuId='" & uuid & "' " & vbCrLf
		end if
		vQuery = vQuery & " order by idx desc"
		rsget.CursorLocation = adUseClient
        rsget.Open vQuery,dbget,adOpenForwardOnly, adLockReadOnly
		if Not(rsget.EOF or rsget.BOF) then
			chkPushAgree = (rsget("pushyn")="Y")
		else
			chkPushAgree = false
		end if
		rsget.Close	
	end Function
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->


