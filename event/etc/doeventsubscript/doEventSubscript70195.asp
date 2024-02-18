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
' Description : 텐바이텐 X 영화 <캡틴 아메리카: 시빌 워>  MA
' History : 2016.04.20 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim mode, sqlstr, rvalue, cLayerValue, teamgubun, itemgubun, device
	mode = requestcheckvar(request("mode"),5)
	teamgubun = requestcheckvar(request("teamgubun"),2)
	itemgubun = requestcheckvar(request("itemgubun"),2)

dim eCode, userid, currenttime, i
	IF application("Svr_Info") = "Dev" THEN
		eCode = "66112"
	Else
		eCode = "70195"
	end if

	if isapp then
		device = "A"
	else
		device = "M"
	end if

currenttime = now()
'															currenttime = #03/14/2016 10:05:00#

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

	If not( left(currenttime,10)>="2016-04-20" and left(currenttime,10)<"2016-04-27" ) Then
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

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '" & teamgubun & "', '" & itemgubun & "', '" & left(currenttime,10) & "', '" & device & "')" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Response.Write "11||응모 완료"
	dbget.close() : Response.End
Else
	Response.Write "00||정상적인 경로가 아닙니다."
	dbget.close() : Response.End
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->


