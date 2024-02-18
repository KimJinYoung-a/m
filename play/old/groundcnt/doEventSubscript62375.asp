<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
'### PLAY #20 FLOWER _ FIND MY SCENT
'### 2015-05-08 유태욱
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, mode, sqlstr, refer, myscent, mycomcnt, vQuery, enterCnt
Dim refip
dim nowdate
	nowdate = date()
'	nowdate = "2015-05-11"

	refip = Request.ServerVariables("REMOTE_ADDR")

	userid = getloginuserid()
	mode = requestcheckvar(request("mode"),32)
	myscent = requestcheckvar(request("myscent"),1)

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  61782
	Else
		eCode   =  62375
	End If

	refer = request.ServerVariables("HTTP_REFERER")
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "잘못된 접속입니다."
		dbget.close() : Response.End
	end If

	'// 이벤트 응모기간 확인
	If not(nowdate>="2015-05-11" and nowdate < "2015-05-21") Then
		Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.location.reload();</script>"
		dbget.close() : Response.End
	End If

	If mode = "add" Then '//응모하기 버튼 클릭
		''응모 이력 있는지 체크
		sqlstr = "select count(userid) as cnt "
		sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
		sqlstr = sqlstr & " where evt_code="& eCode &""
		sqlstr = sqlstr & " and userid='"& userid &"' "
		rsget.Open sqlstr, dbget, 1
	
		If Not rsget.Eof Then
			mycomcnt = rsget(0)
		End IF
		rsget.close

		If mycomcnt < 1 Then '//응모 내역이 없음
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device, regdate)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '"& myscent &"', '0', 'M','"& nowdate &"' )" + vbcrlf
			dbget.execute sqlstr

			sqlstr = "select top 1 sub_opt1"
			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
			sqlstr = sqlstr & " where evt_code="& eCode &""
			sqlstr = sqlstr & " and userid='"& userid &"' "
			rsget.Open sqlstr, dbget, 1
				If Not rsget.Eof Then
					myscent = rsget(0)
				End IF
			rsget.close
			
			vQuery = " Select count(sub_idx) From [db_event].dbo.tbl_event_subscript Where evt_code='"&eCode&"' "
			rsget.Open vQuery,dbget,1
				IF Not rsget.Eof Then
					enterCnt = rsget(0)
				End IF
			rsget.close

			Response.write "SUCCESS1" &"!/!"&myscent&"!/!"&enterCnt
			dbget.close()	:	response.End
		Else '//이미 이벤트에 참여했음
			Response.write "END"
			Response.end
		End if
	Else
		Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.location.reload();</script>"
		dbget.close() : Response.End
	end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->