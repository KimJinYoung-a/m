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
' Description : 어벤져카드뽑기
' History : 2015.05.04 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
Dim eCode, userid, mode, sqlstr, refer, smssubscriptcount, subscriptcount, bonuscouponcount, totalsubscriptcount, totalbonuscouponcount, preveCode, vStarGift, vGiftName, vChkWishSelect, vLinkECode, procAccessUser, vQuery, vTotalCount, nowDate
Dim vItemID, vtemp, k, itemcnt, EventTotalChk
	userid = getloginuserid()
	refer = request.ServerVariables("HTTP_REFERER")

	nowDate = Left(Now(), 10)
'	nowDate = "2015-05-06"

	dim evtnum '이벤트 차수(1차,2차)
	Select Case Trim(nowDate)

		Case "2015-05-06"
			evtnum = "1"
		Case "2015-05-07"
			evtnum = "2"
		Case "2015-05-08"
			evtnum = "3"
		Case Else
			evtnum = "0"
	End Select

	
	IF application("Svr_Info") = "Dev" THEN
		eCode = "61774"
	Else
		eCode = "62061"
	End If

	'// 텐바이텐 페이지를 통해 들어왔는지 확인
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "99" '// 잘못된 접속
		Response.End
	end if

	'// 로그인 확인
	If userid = "" Then
		Response.Write "88" '// 로그인 확인
		Response.End
	End If

	'// 이벤트 기간 확인
	If nowDate >= "2015-05-06" and nowDate < "2015-05-09" Then
	Else
		Response.Write "77" '// 이벤트 기간 확인
		Response.End
	End If

	
	'// 해당 이벤트 토탈 참여갯수
	sqlStr = ""
	sqlStr = sqlStr & " SELECT count(sub_idx) " &VBCRLF
	sqlStr = sqlStr & " FROM db_event.dbo.tbl_event_subscript " &VBCRLF
	sqlStr = sqlStr & " WHERE evt_code='"&eCode&"' and sub_opt1='"&nowDate&"'"
	rsget.Open sqlStr, dbget, 1
		EventTotalChk = rsget(0) '// 현재 이벤트 토탈 참여갯수
	rsget.Close
	If EventTotalChk >= 7000 Then 
		Response.Write "66" '// 7000개 제한, 모두 소진 메시지 출력
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
	vQuery = " update [db_user].[dbo].[tbl_user_current_mileage] set bonusmileage = bonusmileage + 5000, lastupdate=getdate() Where userid='"&userid&"' "
	dbget.Execute vQuery

	'// 마일리지 로그 테이블에 넣는다.
	vQuery = " insert into db_user.dbo.tbl_mileagelog(userid , mileage , jukyocd , jukyo , deleteyn) values ('"&userid&"', '+5000','"&eCode&"', '어벤져카드 뽑기 5000마일리지 지급','N') "
	dbget.Execute vQuery

	'// 이벤트 테이블에 내역을 남긴다.
	vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "', '" & nowDate & "', '" & evtnum & "','어벤져카드 뽑기 5000마일리지 지급', 'A')"
	dbget.Execute vQuery
	
	response.write "00"
	dbget.close
	response.End
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->