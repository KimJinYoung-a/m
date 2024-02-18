<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
dim eCode, userid, referer,refip, returnurl, vQuery, vVoteTour, totalVoteCnt, refererURL, refererQueryString, tempReferer

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  64847
	Else
		eCode   =  65349
	End If

	userid = GetLoginUserID
	referer = request.ServerVariables("HTTP_REFERER")
	refip = request.ServerVariables("REMOTE_ADDR")
	vVoteTour=requestCheckVar(request.Form("votetour"),20)


	If referer="" Or Len(referer)=0 Then
		response.write "<script>alert('정상적인 경로로 접근해주시기 바랍니다.');</script>"
	 	response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
		response.End
	End If


	tempReferer = Split(referer,"?")

	If isArray(tempReferer) Then
		refererURL = tempReferer(0)
		refererQueryString = Replace(tempReferer(1), "&ga=1","")
		referer = refererURL &"?"&refererQueryString
	Else
		referer = request.ServerVariables("HTTP_REFERER")
	End If


	'// 5회 이상 참여여부 체크한다.
	vQuery = " Select count(userid) From [db_event].dbo.tbl_event_subscript Where evt_code='"&eCode&"' And userid='"&userid&"' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		totalVoteCnt = rsget(0)
	End IF
	rsget.close	

	If totalVoteCnt > 4 Then
		response.write "<script>alert('5회까지만 투표 가능합니다.');</script>"
	 	response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
		response.End
	End If


	'// 해당 투표내역 집어넣는다.
	vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "', '" & vVoteTour & "', 'm')"
	dbget.Execute vQuery
 	response.write "<script>location.replace('" + Cstr(referer) + "&ga=1');</script>"
	dbget.close()
    response.end

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->