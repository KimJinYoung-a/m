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
' Description : 도와줘요! 히어로
' History : 2015.05.04 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
Dim eCode, userid, mode, sqlstr, refer, smssubscriptcount, subscriptcount, bonuscouponcount, totalsubscriptcount, totalbonuscouponcount, preveCode, vStarGift, vGiftName, vChkWishSelect, vLinkECode, procAccessUser, vQuery, vTotalCount, nowDate
Dim vItemID, vtemp, k, itemcnt, EventTotalChk
	userid = GetLoginUserID()
	refer = request.ServerVariables("HTTP_REFERER")

	nowDate = Left(Now(), 10)

	
	IF application("Svr_Info") = "Dev" THEN
		eCode = "61775"
	Else
		eCode = "62117"
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
	If nowDate >= "2015-05-06" and nowDate < "2015-05-13" Then
	Else
		Response.Write "77" '// 이벤트 기간 확인
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
	rsget.close

	'// 구매내역 있는지 확인(이벤트 기간중 구매내역 있는 사람만 참여할 수 있음)
	sqlStr = ""
	sqlStr = sqlStr & " select count(m.userid) from db_order.dbo.tbl_order_master as m " &VBCRLF
	sqlStr = sqlStr & " 	inner join db_order.dbo.tbl_order_detail as d " &VBCRLF
	sqlStr = sqlStr & " 	on m.orderserial=d.orderserial " &VBCRLF
	sqlStr = sqlStr & " 	where m.jumundiv<>'9' and m.ipkumdiv > 3 and m.cancelyn = 'N' " &VBCRLF
	sqlStr = sqlStr & " 	and d.cancelyn<>'Y' and d.itemid<>'0' And m.userid='"&UserID&"' " &VBCRLF
	sqlStr = sqlStr & " 	and m.regdate between '2015-05-06 00:00:00' and '2015-05-12 23:59:59' " &VBCRLF
	rsget.Open sqlStr, dbget, 1
	If rsget(0) > 0 Then

	Else
		response.write "66" '// 이벤트 참여 관련 메시지 출력
		response.end		
	End If
	rsget.Close

	'// 이벤트 테이블에 내역을 남긴다.
	vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "', '도와줘요 히어로 응모', 'A')"
	dbget.Execute vQuery
	
	response.write "00"
	dbget.close
	response.End
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->