<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : ##추석특선영화
' History : 2015-09-18 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim eCode, userid, sqlstr, mode, vLinkECode , vTotalCount, md5userid, eCouponID, RvchrNum, LoginUserid
Dim evtUserCell, refer, refip, device, vQuery, strsql, nowdate

	
	refip = Request.ServerVariables("REMOTE_ADDR")
	refer = request.ServerVariables("HTTP_REFERER")
	LoginUserid = getEncLoginUserID
	mode = requestcheckvar(request("mode"),32)

	nowdate = Date()

	IF application("Svr_Info") = "Dev" THEN
		eCode = "64889"
	Else
		eCode = "66246"
	End If

	if isapp="1" then
		device = "A"
	else
		device = "M"
	end if


	'// 바로 접속시엔 오류 표시
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		Response.End
	end If


	'// expiredate
	If not(left(Now(),10)>="2015-09-19" and left(Now(),10)<"2015-09-21") Then
		Response.Write "Err|이벤트 응모 기간이 아닙니다."
		Response.End
	End If


	'// 로그인 여부 체크
	If Not(IsUserLoginOK) Then
		Response.Write "Err|로그인 후 참여하실 수 있습니다."
		response.End
	End If


	'// 이벤트 응모 내역 확인
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & LoginUserid & "' And evt_code='"&eCode&"' "
	rsget.Open vQuery,dbget,adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		vTotalCount = rsget(0)
	End If
	rsget.close()

	If mode="add" Then
		If vTotalCount > 0 Then
			Response.Write "Err|이미 참여하셨습니다."
			dbget.close()
			response.End
		Else
			'// 이벤트 테이블에 내역을 남긴다.
			vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt3, device) VALUES('" & eCode & "', '" & LoginUserid & "','탐정더비기닝응모', '" & device & "')"
			dbget.Execute vQuery

			'// 해당 유저의 로그값 집어넣는다.
			Call fnCautionEventLog(eCode,LoginUserid,nowdate,"","",device)

			Response.Write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2015/66246/img_layer_finish.png' alt='응모가 완료되었습니다.' /></p><button type='button' class='btnConfirm' onclick='fnClosemask();return false;'>확인</button>"
			response.End

		End If
	Else
		Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End If

%>

<!-- #include virtual="/lib/db/dbclose.asp" -->