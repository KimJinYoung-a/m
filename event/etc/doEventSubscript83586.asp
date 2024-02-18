<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description : [valentine’s day] HOW TO SAY LOVE
' History : 2018-01-29 정태훈
'####################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->

<%
Dim strSql, userid, mode, apgubun, eCode
mode = requestcheckvar(request("mode"),3)
eCode = requestcheckvar(request("eCode"),10)
userid  = GetencLoginUserID
apgubun = "M"

IF eCode = "" THEN
	Response.Write "01||유입경로에 문제가 발생하였습니다. 관리자에게 문의해주십시오"
	dbget.close() : Response.End
END IF

'// 로그인 여부 체크
If Not(IsUserLoginOK) Then
	Response.Write "02|로그인 후 참여하실 수 있습니다."
	response.End
End If

If now() > #01/29/2018 00:00:00# and now() < #02/14/2018 23:59:59# then
Else
	Response.Write "12|이벤트 기간이 아닙니다."
	response.End
End If

'2. 2018-01-17 ~ 2018-02-14 구매중 해당 카테고리 수량 가져오기
Dim NowBuyCount, sqlStr
sqlStr = "select count(m.orderserial) as cnt" & vbcrlf
sqlStr = sqlStr + " from [db_order].[dbo].[tbl_order_master] AS M with (noLock)" & vbcrlf
sqlStr = sqlStr + " JOIN [db_order].[dbo].[tbl_order_detail] AS D with (noLock) ON D.orderserial=M.orderserial" & vbcrlf
sqlStr = sqlStr + " LEFT JOIN [db_item].[dbo].[tbl_display_cate_item] AS I with (noLock) ON I.itemid=D.itemid" & vbcrlf
sqlStr = sqlStr + " where M.ipkumdiv>3" & vbcrlf
sqlStr = sqlStr + " and M.jumundiv<>'6'" & vbcrlf
sqlStr = sqlStr + " and M.sitename='10x10'" & vbcrlf
sqlStr = sqlStr + " and M.cancelyn='N'" & vbcrlf
sqlStr = sqlStr + " and M.userid='" & Cstr(userid) & "'" & vbcrlf
sqlStr = sqlStr + " and M.regdate between '2018-01-17' and '2018-02-14'" & vbcrlf
sqlStr = sqlStr + " and d.itemid not in (0,100)" & vbcrlf
sqlStr = sqlStr + " and D.cancelyn<>'Y'" & vbcrlf
sqlStr = sqlStr + " and left(I.catecode,6) in (119103,119104)" & vbcrlf
sqlStr = sqlStr + " group by m.orderserial" & vbcrlf

rsget.Open sqlStr,dbget,1
If not rsget.EOF Then
	NowBuyCount = rsget(0)
Else
	NowBuyCount=0
End If
rsget.close
'// 이벤트 대상 카테고리 구매 내역 체크
If NowBuyCount < 1 Then
	Response.Write "03|이벤트 대상 카테고리 구매 내역이 없습니다."
	response.End
End If

'// 해당이벤트 참여했는지 확인
Function UserAppearChk()
	Dim vQuery
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' And userid='"&userid&"'"
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		UserAppearChk = rsget(0)
	End IF
	rsget.close
End Function

'// 참여 데이터 ins
Function InsAppearData(evt_code, uid, device, sub_opt1)
	Dim vQuery
	vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid, device, sub_opt1, regdate)" & vbCrlf
	vQuery = vQuery & " VALUES ("& evt_code &", '"& uid &"', '"&device&"','"&sub_opt1&"',getdate())"
	dbget.execute vQuery
End Function

if mode = "add" then
	If UserAppearChk() > 0 Then
		Response.Write "13|이미 이벤트에 응모하셨습니다."
		dbget.close() : Response.End
	Else
		'// 참여 데이터를 넣는다.
		Call InsAppearData(eCode, userid, apgubun, "ins")
		Response.Write "11|OK"
		dbget.close() : Response.End
	End If
else
	Response.Write "00||정상적인 경로가 아닙니다."
	dbget.close() : Response.End	
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
