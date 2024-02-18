<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
	'#############################
	' Description : 마일리지 뽑기
	' History : 2017.06.22 원승현
	'#############################

	Dim eCode, nowDate, userid, evtChkCnt, appchk
	Dim evtStartDate, evtEndDate, sqlstr, refip, refer, mode
	Dim vStadProb, RvConNum
	Dim mil50stv, mil50edv
	Dim mil100stv, mil100edv
	Dim mil200stv, mil200edv
	Dim mil300stv, mil300edv
	Dim mil500stv, mil500edv
	Dim vWonMil, md5userid

	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "66351"
	Else
		eCode 		= "78638"
	End If

	If isapp="1" Then
		appchk = "A"
	Else
		appchk = "M"
	End If

	'//현재 일자
	nowDate = Now()

	'//회원아이디
	userid = GetEncLoginUserID

	'//이벤트 응모시작일자
	evtStartDate = #06/26/2017 10:00:00#

	'//이벤트 응모종료일자
	evtEndDate = #07/01/2017 00:00:00#

	'// 확률기준값
	vStadProb = 10000

	'// 50마일리지 당첨확률 87.5%
	mil50stv = 1
	mil50edv = 8750

	'// 100마일리지 당첨확률 7%
	mil100stv = 8751
	mil100edv = 9450

	'// 200마일리지 당첨확률 3.75%
	mil200stv = 9451
	mil200edv = 9825

	'// 300마일리지 당첨확률 1.5%
	mil300stv = 9826
	mil300edv = 9975
	
	'// 500마일리지 당첨확률 0.25%
	mil500stv = 9976
	mil500edv = 10000
	
	refip = Request.ServerVariables("REMOTE_ADDR")
	refer = request.ServerVariables("HTTP_REFERER")
	mode = requestcheckvar(request("mode"),32)
	userid = GetEncLoginUserID


	'// 바로 접속시엔 오류 표시
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		Response.End
	end If

	'// expiredate
	If not(nowDate>=evtStartDate and nowDate<evtEndDate) Then
		Response.Write "Err|이벤트 응모 기간이 아닙니다."
		Response.End
	End If

	'// 로그인 여부 체크
	If Not(IsUserLoginOK) Then
		Response.Write "Err|로그인 후 참여하실 수 있습니다."
		response.End
	End If

	'// 참여여부 확인(하루에 한번씩 참여 가능)
	sqlstr = "Select count(*)" &_
			" From db_event.dbo.tbl_event_subscript" &_
			" WHERE evt_code='" & eCode & "' and userid='" & userid & "' And convert(varchar(10), regdate, 120) = '"&Left(nowDate, 10)&"' "
			'response.write sqlstr
	rsget.Open sqlStr,dbget,1
	If rsget(0) > 0 Then
		Response.Write "Err|하루에 한 번씩만 참여 가능합니다."
		response.End
	End If
	rsget.Close

	randomize
	RvConNum=int(Rnd*CInt(vStadProb))+1 '100%

	'// 블랙리스트 회원은 무조건 50마일리지 당첨처리
	If userBlackListCheck(userid) Then
		vWonMil = 50
	Else
		'// 50마일리지 당첨
		If RvConNum >= mil50stv And RvConNum <= mil50edv Then
			vWonMil = 50
		'// 100마일리지 당첨
		ElseIf RvConNum >= mil100stv And RvConNum <= mil100edv Then
			vWonMil = 100
		'// 200마일리지 당첨
		ElseIf RvConNum >= mil200stv And RvConNum <= mil200edv Then
			vWonMil = 200
		'// 300마일리지 당첨
		ElseIf RvConNum >= mil300stv And RvConNum <= mil300edv Then
			vWonMil = 300
		'// 500마일리지 당첨
		ElseIf RvConNum >= mil500stv And RvConNum <= mil500edv Then
			vWonMil = 500
		Else
			Response.Write "Err|정상적인 경로로 참여해주세요."
			response.End
		End If
	End If

	'// 해당유저가 어뷰징 할 수도 있으므로..
	md5userid = md5(userid&CStr(vWonMil))


	'// 해당 회원이 당첨된 마일리지 값 저장(sub_opt1에는 당첨을 위해 랜덤으로 해당 유저가 받은 RvConNum값을 넣고 sub_opt2에는 마일리지 당첨된 값을 넣는다. sub_opt3에는 유저아이디+해당마일리지당첨금액으로 생성된 md5값을 넣는다.
	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '"&RvConNum&"', '"&vWonMil&"', '"&md5userid&"', getdate(), '"&appchk&"')"
	dbget.execute sqlstr

	Response.write "OK|<img src='http://webimage.10x10.co.kr/eventIMG/2017/78638/m/txt_mileage_"&vWonMil&".png' alt='"&vWonMil&"마일리지 당첨' /><p class='hiddenCode'>"&md5userid&"</p><button type='button' class='btnClose' onclick='layerPopClose();return false;'>닫기</button>"
	dbget.close()	:	response.End
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->


