<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 비밀의방 초대권 신청 페이지
' History : 2016.05.11 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<%
dim mode, sqlstr, device
	mode = requestcheckvar(request("mode"),5)

dim eCode, userid, currenttime, i
	IF application("Svr_Info") = "Dev" THEN
		eCode = "66125"
	Else
		eCode = "70715"
	end if

	if isapp then
		device = "A"
	else
		device = "M"
	end if

currenttime = now()
'															currenttime = #05/20/2016 10:05:00#

userid = GetEncLoginUserID()

dim subscriptcount
subscriptcount=0

dim refer
	refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "01||잘못된 접속입니다."
	dbget.close() : Response.End
end If

if mode="evtgo" then
	If userid = "" Then
		Response.Write "02||로그인을 해주세요."
		dbget.close() : Response.End
	End IF

	If not( left(currenttime,10)>="2016-05-16" and left(currenttime,10)<"2016-05-23" ) Then
		Response.Write "03||이벤트 응모 기간이 아닙니다."
		dbget.close() : Response.End
	End IF

	'//본인 참여 여부
	if userid<>"" then
		subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", left(currenttime,10))
	end if

	if subscriptcount>0 Then
		Response.Write "04||이미 참여함"		''이미  참여함
		dbget.close() : Response.End
	end if

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '" & left(currenttime,10) & "', '" & device & "')" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Response.Write "11||응모 완료"
	dbget.close() : Response.End

ElseIf mode="S" Then
	''카카오톡 초대
	Call fnCautionEventLog(eCode,userid,"kakao","","",device)
	Response.write "ka"
	Response.End
Else
	Response.Write "00||정상적인 경로가 아닙니다."
	dbget.close() : Response.End
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->


