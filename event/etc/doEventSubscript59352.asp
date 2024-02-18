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
' Description : 텐바이텐 처음이라면서요(!)
' History : 2015.02.06 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
Dim eCode, userid, sqlstr, refer, procAccessUser, vQuery, vTotalCount, EventTotalChk
	userid = getloginuserid()
	refer = request.ServerVariables("HTTP_REFERER")

	IF application("Svr_Info") = "Dev" Then
		eCode = "21467"
	Else
		eCode = "59352"
	End If

	procAccessUser=0
	vTotalCount=0
	EventTotalChk = 0

	'// 텐바이텐 페이지를 통해 들어왔는지 확인
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "99" '// 잘못된 접속
		dbget.close() : Response.End
	end if

	'// 로그인 확인
	If userid = "" Then
		Response.Write "88" '// 로그인 확인
		dbget.close() : Response.End
	End If

	'// 이벤트 기간 확인
	If not(left(Now(),10)>="2015-02-09" and left(Now(),10)<"2015-02-10") Then
		Response.Write "77" '// 이벤트 기간 확인
		dbget.close() : Response.End
	End If

	'// 해당 이벤트 토탈 참여갯수
	sqlStr = ""
	sqlStr = sqlStr & " SELECT count(sub_idx) " &VBCRLF
	sqlStr = sqlStr & " FROM db_event.dbo.tbl_event_subscript " &VBCRLF
	sqlStr = sqlStr & " WHERE evt_code='"&eCode&"' "
	rsget.Open sqlStr, dbget, 1
		EventTotalChk = rsget(0) '// 현재 이벤트 토탈 참여갯수
	rsget.Close
	If EventTotalChk > 1000 Then
		Response.Write "66" '// 1000 제한, 마일리지 소진 메시지 출력
		rsget.close
		Response.End
	End If

	'// 해당 이벤트 대상자인지 확인(12월 신규가입자 중 2월현재까지 구매이력없는 고객 and 문자수신동의 고객)

	sqlStr = ""
	sqlStr = sqlStr & " select count(u.userid) " &VBCRLF
	sqlStr = sqlStr & " from db_user.dbo.tbl_user_n as u" &VBCRLF		'/user정보
	sqlStr = sqlStr & " left join ( " &VBCRLF
	sqlStr = sqlStr & " 	select " &VBCRLF
	sqlStr = sqlStr & " 	m.userid " &VBCRLF
	sqlStr = sqlStr & " 	from db_order.dbo.tbl_order_master m " &VBCRLF
	sqlStr = sqlStr & " 	where m.userid<>'' " &VBCRLF
	sqlStr = sqlStr & " 	and m.ipkumdiv>3 " &VBCRLF
	sqlStr = sqlStr & " 	and m.cancelyn='N' " &VBCRLF
	sqlStr = sqlStr & " 	and m.jumundiv<>9 " &VBCRLF
	sqlStr = sqlStr & " 	and m.regdate >= '2014-12-01' and m.regdate <= getdate() " &VBCRLF
	sqlStr = sqlStr & " 	group by m.userid " &VBCRLF
	sqlStr = sqlStr & " ) as t " &VBCRLF
	sqlStr = sqlStr & " 	on u.userid = t.userid " &VBCRLF
	sqlStr = sqlStr & " where u.regdate >= '2014-12-01' and u.regdate< '2015-01-01' and u.smsok='Y' and t.userid is null and u.userid='"&userid&"' "
	rsget.Open sqlStr, dbget, 1
		procAccessUser = rsget(0) '// 이벤트 대상자인지 확인
	rsget.Close
	If procAccessUser < 1 Then
		Response.Write "55" '// 이벤트 대상자 아님 출력
		dbget.close
		Response.End
	End If

	'// 해당 이벤트에 참여했는지 확인(아이디당 1회만 참여할 수 있음)
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' And evt_code='"&eCode&"' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		vTotalCount = rsget(0)
	End IF
	If vTotalCount > 0 Then
		response.write "44" '// 이벤트 참여 관련 메시지 출력
		rsget.close
		response.end
	End If

	'// 마일리지 테이블에 넣는다.
	vQuery = " update [db_user].[dbo].[tbl_user_current_mileage] set bonusmileage = bonusmileage + 3000, lastupdate=getdate() Where userid='"&userid&"' "
	dbget.Execute vQuery

	'// 마일리지 로그 테이블에 넣는다.
	vQuery = " insert into db_user.dbo.tbl_mileagelog(userid , mileage , jukyocd , jukyo , deleteyn) values ('"&userid&"', '+3000','"&eCode&"', '텐바이텐 처음이라면서요 3000마일리지 지급','N') "
	dbget.Execute vQuery

	'// 이벤트 테이블에 내역을 남긴다.
	vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "','3000마일리지 지급', 'M')"
	dbget.Execute vQuery

	response.write "00"
	dbget.close() : response.End
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->