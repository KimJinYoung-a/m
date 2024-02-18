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

dim eCode, userid, referer,refip, returnurl, vQuery, totalVoteCnt, mode, enterCnt, cContents, i, totalCnt

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  "63791"
	Else
		eCode   =  "63798"
	End If

	cContents = ""
	i = 0

	userid = GetLoginUserID
	referer = request.ServerVariables("HTTP_REFERER")
	refip = request.ServerVariables("REMOTE_ADDR")
	mode = requestcheckvar(request("mode"),32)

	If referer="" Or Len(referer)=0 Then
		response.write "99!/!정상적인 경로로 접근해주시기 바랍니다."
		dbget.close()	:	response.End
	End If

	'// 5회 이상 참여여부 체크한다.
	vQuery = " Select count(userid) From [db_event].dbo.tbl_event_subscript Where evt_code='"&eCode&"' and userid = '" & userid & "' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		totalVoteCnt = rsget(0)
	End IF
	rsget.close	

	If totalVoteCnt > 4 Then
		response.write "99!/!5회까지만 참여 가능합니다."
		dbget.close()	:	response.End
	End If

	'// 응모하기
	vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "', '" & eCode & "', 'm')"
	dbget.Execute vQuery


	vQuery = "Select count(sub_idx) From [db_event].dbo.tbl_event_subscript Where evt_code='"&eCode&"' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		enterCnt = rsget(0)
	End IF
	rsget.close

	vQuery = "Select count(userid) From [db_event].dbo.tbl_event_subscript Where evt_code='"&eCode&"' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		totalCnt = rsget(0)
	End IF
	rsget.close

	vQuery = " Select top 3 * From [db_event].dbo.tbl_event_subscript Where evt_code='"&eCode&"' order by sub_idx desc "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		Do Until rsget.eof
			cContents = cContents & " <li> <div> "
			cContents = cContents & " <p class='num'>NO."&enterCnt-i&"</p> "
			cContents = cContents & " <p class='writer'><strong>"&chrbyte(printUserId(rsget("userid"),2,"*"), 12, """N""")&"</strong>님의 빨래</p> "
			cContents = cContents & " <p class='bg'><img src='http://webimage.10x10.co.kr/playmo/ground/20150622/bg_blank.png' alt='' /></p> "
			cContents = cContents & " </div></li> "
		i = i + 1
		rsget.movenext
		Loop
	End If
	rsget.close
	
	Response.write "01!/!"&totalCnt&"!/!"&cContents
	dbget.close()	:	response.End

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->