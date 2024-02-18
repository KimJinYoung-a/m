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
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim eCode, userid, referer,refip, returnurl, vQuery, vVoteTour, totalVoteCnt, refererURL, refererQueryString

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  "64878"
	Else
		eCode   =  "66035"
	End If

	userid = GetEncLoginUserID
	referer = request.ServerVariables("HTTP_REFERER")
	refip = request.ServerVariables("REMOTE_ADDR")

	If IsUserLoginOK() Then
	else
		response.write "<script>alert('로그인 후에 응모 하실 수 있습니다.');history.back(-1);</script>"
		dbget.close() : Response.End
	End If

	If referer="" Or Len(referer)=0 Then
		response.write "<script>alert('정상적인 경로로 접근해주시기 바랍니다.');</script>"
	 	response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
		response.End
	End If

	referer = request.ServerVariables("HTTP_REFERER")

	If IsUserLoginOK() Then 
		'// 5회 이상 참여여부 체크한다.
		vQuery = " Select count(userid) From [db_event].dbo.tbl_event_subscript Where evt_code='"&eCode&"' And userid='"&userid&"' "
		rsget.Open vQuery,dbget,1
		IF Not rsget.Eof Then
			totalVoteCnt = rsget(0)
		End IF
		rsget.close	

		If totalVoteCnt > 4 Then
			response.write "<script>alert('5회까지만 신청 가능합니다.');</script>"
			response.write "<script>location.replace('" + Cstr(referer) + "#mystudioEvt');</script>"
			response.End
		End If


		'// 해당 투표내역 집어넣는다.
		vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, device) VALUES('" & eCode & "', '" & userid & "', 'm')"
		dbget.Execute vQuery
		response.write "<script>alert('스튜디오 신청이 완료되었습니다.');location.replace('" + Cstr(referer) + "#mystudioEvt');</script>"
		dbget.close()
		response.End
	End If 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->