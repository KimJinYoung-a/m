<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->

<%
Dim eCode, userid, mode, sqlstr, vQuery, vTotalCount, vItemID, vtemp, k, itemcnt, EventTotalChk, vDevice
	userid = getloginuserid()
	if isApp=1 then
		vDevice = "A"
	else
		vDevice = "M"
	end if
	
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21525"
	Else
		eCode = "60777"
	End If

	'// 텐바이텐 페이지를 통해 들어왔는지 확인
	if InStr(request.ServerVariables("HTTP_REFERER"),"10x10.co.kr")<1 then
		response.write "<script language='javascript'>alert('잘못된 접근입니다.'); history.go(-1);</script>"
		dbget.close()
	    response.end
	end if

	'// 로그인 확인
	If userid = "" Then
		response.write "<script language='javascript'>alert('잘못된 접근입니다.'); history.go(-1);</script>"
		dbget.close()
	    response.end
	End If


	'// 해당 이벤트 토탈 참여갯수
	sqlStr = "SELECT count(sub_idx) FROM db_event.dbo.tbl_event_subscript WHERE evt_code='"&eCode&"'"
	rsget.Open sqlStr, dbget, 1
		EventTotalChk = rsget(0) '// 현재 이벤트 토탈 참여갯수
	rsget.Close
	If EventTotalChk >= 19000 Then 
		response.write "<script language='javascript'>parent.jsSoldOut();</script>"
		dbget.close()
	    response.end
	End If


	'// 해당 이벤트에 참여했는지 확인(아이디당 1회만 참여할 수 있음)
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' And evt_code='"&eCode&"' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		vTotalCount = rsget(0)
	End IF
	rsget.close
	If vTotalCount > 0 Then
		response.write "<script language='javascript'>alert('이미 마일리지를 받으셨습니다.');top.location.reload();</script>"
		dbget.close()
		response.end
	End If


	'// 마일리지 테이블에 넣는다.
	vQuery = " update [db_user].[dbo].[tbl_user_current_mileage] set bonusmileage = bonusmileage + 5000, lastupdate=getdate() Where userid='"&userid&"' "
	'dbget.Execute vQuery

	'// 마일리지 로그 테이블에 넣는다.
	vQuery = " insert into db_user.dbo.tbl_mileagelog(userid , mileage , jukyocd , jukyo , deleteyn) values ('"&userid&"', '+5000','"&eCode&"', '마일리지를 부탁해! 5000마일리지 지급','N') "
	'dbget.Execute vQuery

	'// 이벤트 테이블에 내역을 남긴다.
	vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, device) VALUES('" & eCode & "', '" & userid & "', 'x', '" & vDevice & "')"
	'dbget.Execute vQuery
	
	'response.write "<script language='javascript'>alert('마일리지 지급 완료\n현금처럼 사용 가능한 마일리지!\n31일까지 꼭 사용하세요!');top.location.reload();</script>"
	dbget.close()
	response.end
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->