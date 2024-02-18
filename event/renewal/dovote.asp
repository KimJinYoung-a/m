<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'##############################################################
' Description : 리뉴얼 안내 투표 저장
' History : 2021-03-15 정태훈 생성
'##############################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<!-- #include virtual="/lib/classes/event/realtimeevent/renewalInfoCls.asp" -->
<%
	Response.ContentType = "application/json"
	response.charset = "utf-8"
	dim refer, LoginUserid, oJson, vQuery, mode, vote, renew, votecnt1, votecnt2, myvote
	refer = request.ServerVariables("HTTP_REFERER") '// 레퍼러

	Set oJson = jsObject()

	IF application("Svr_Info") <> "Dev" THEN
		If InStr(refer, "10x10.co.kr") < 1 Then
			oJson("response") = "err"
			oJson("faildesc") = "잘못된 접속입니다."
			oJson.flush
			Set oJson = Nothing
			dbget.close() : Response.End
		End If
	End If
	LoginUserid = getencLoginUserid()
	mode = request("mode")
    vote = request("vote")

if mode = "add" then
	if Not(IsUserLoginOK) Then
		oJson("response") = "err"
		oJson("faildesc") = "로그인 후 참여하실 수 있습니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if

	'// 다음날 푸쉬 신청을 했는지 확인한다.
	vQuery = "SELECT count(*) FROM [db_temp].[dbo].[tbl_renewal_vote] WITH (NOLOCK) WHERE userid='"&LoginUserid&"'"
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		If rsget(0) > 0 Then
			oJson("response") = "B"
			oJson.flush
			Set oJson = Nothing
			dbget.close() : Response.End
		End If
	End IF
	rsget.close

    vQuery = " INSERT INTO [db_temp].[dbo].[tbl_renewal_vote](userid, vote) VALUES('" & LoginUserid & "', "&vote&")"
	dbget.Execute vQuery
	oJson("response") = "C"
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
elseif mode = "votecnt" then
	set renew = new ClsRenewal
	renew.FRectUserID = LoginUserid
	votecnt1 = renew.fnRenewVote(1)
    votecnt2 = renew.fnRenewVote(2)
    if LoginUserid<>"" then
    myvote = renew.fnRenewMyVote()
    else
    myvote = 0
    end if
	oJson("response") = "ok"
    oJson("votecnt1") = formatnumber(votecnt1,0)
    oJson("votecnt2") = formatnumber(votecnt2,0)
    oJson("myvote") = myvote
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->