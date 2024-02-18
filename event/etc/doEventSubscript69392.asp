<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 백지수표
' History : 2016-02-29 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66052
Else
	eCode   =  69392
End If

dim currenttime
	currenttime =  now()
	'currenttime = #09/25/2015 09:00:00#

dim userid
	userid = GetEncLoginUserID()

dim mode , sqlStr
Dim vQuery, vTotalCount , vTotalSum, evtLimitCnt, apgubun


dim referer,refip, userMilVal
referer = request.ServerVariables("HTTP_REFERER")
refip = request.ServerVariables("REMOTE_ADDR")
userMilVal = request("milval")


If isApp="1" Then
	apgubun = "A"
Else
	apgubun = "M"
End If


Dim vCount, vTCount
'나의 참여수
vCount = getevent_subscriptexistscount(eCode, userid, "", "", "")

'이벤트 전체 참여수
vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE convert(varchar(10), regdate, 120) = '" & Left(Trim(currenttime), 10) & "' AND evt_code = '" & eCode & "' "
rsget.CursorLocation = adUseClient
rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
IF Not rsget.Eof Then
	vTCount = rsget(0)
End IF
rsget.close

'//구매 내역 체킹 (응모는 3월 2일부터 4일까지 구매고객만 가능)
sqlStr = " EXEC [db_order].[dbo].[sp_Ten_MyOrderList_SUM] '" & userid & "', '', '', '2016-03-02', '2016-03-05', '10x10', '', 'issue' "

'response.write sqlStr & "<br>"
rsget.CursorLocation = adUseClient
rsget.CursorType = adOpenStatic
rsget.LockType = adLockOptimistic
rsget.Open sqlStr,dbget,1
	vTotalCount = rsget("cnt")
	vTotalSum   = CHKIIF(isNull(rsget("tsum")),0,rsget("tsum"))
rsget.Close

'// 일자별 응모횟수제한
Select Case Left(Trim(currenttime), 10)
	Case "2016-03-02"
		evtLimitCnt = 100

	Case "2016-03-03"
		evtLimitCnt = 150

	Case "2016-03-04"
		evtLimitCnt = 100

	Case Else
		evtLimitCnt = 0
End Select


if InStr(referer,"10x10.co.kr")<1 then
	Response.Write "Err|잘못된 접속입니다."
	dbget.close() : Response.End
end If

If GetencLoginUserID() = "" Then
	Response.Write "Err|로그인을 해야>?n이벤트에 참여할 수 있습니다."
	dbget.close() : Response.End
End If

If not( left(Now(),10)>="2016-03-02" and left(Now(),10)<"2016-03-05" ) Then
	Response.Write "Err|이벤트 기간이 아닙니다."
	dbget.close() : Response.End
End If

If vCount > 0 Then 
	Response.Write "Err|이미 응모하셨습니다."
	dbget.close() : Response.End
End If

If vTCount >= evtLimitCnt Then
	Response.Write "Err|금일 신청이 마감되었습니다."
	dbget.close() : Response.End
End If

If Not(vTotalSum >= 100000) Then
	Response.Write "Err|본 이벤트는 3월 2일 이후>?n10만원이상 구매이력이 있는>?n고객대상으로 참여가 가능합니다."
	dbget.close() : Response.End
End If

'// 유저가 입력한 마일리지 값은 4자리 이상이 되어선 안된다.
If len(Trim(userMilVal)) > 4 Then
	Response.Write "Err|정상적인 마일리지 값을 입력해주세요."
	dbget.close() : Response.End
End If

'// 유저가 입력한 마일리지 값은 숫자형이어야 한다.
if Not(IsNumeric(Trim(userMilVal))) then 
	Response.Write "Err|마일리지 값은 숫자만 가능합니다."
	dbget.close() : Response.End
end If

'// 최대 마일리지 금액은 9,999원임 그보다 크면 안됨
If Trim(userMilVal) > 9999 Then
	Response.Write "Err|정상적인 마일리지 값을 입력해주세요."
	dbget.close() : Response.End
End If


'// 이벤트 테이블에 남긴다.
vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, device) VALUES('" & eCode & "', '" & userid & "', '" & userMilVal & "', '"&apgubun&"')"
dbget.Execute vQuery

Response.Write "OK|신청되었습니다!>?n>?n>마일리지는 구매 완료된 고객분에 한하여?n>3월15일에 발급될 예정입니다."
dbget.close() : Response.End

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->