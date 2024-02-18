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
' Description : 3월 up! 등업
' History : 2016.03.28 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, currenttime, mode, sqlstr, totalcnt, subtotalprice, selval
	mode = requestcheckvar(request("mode"),32)
	isapp = requestcheckvar(request("isapp"),1)
'	selval = getNumeric(requestcheckvar(request("selval"),2))

	IF application("Svr_Info") = "Dev" THEN
		eCode = "66095"
	Else
		eCode = "69959"
	End If

	currenttime = now()
	'currenttime = #12/23/2015 10:05:00#

	userid = GetEncLoginUserID()

dim subscriptcount
subscriptcount=0
totalcnt = 0
subtotalprice = 0

dim refer
	refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "01||잘못된 접속입니다."
	dbget.close() : Response.End
end If

If userid = "" Then
	Response.Write "02||로그인을 해주세요."
	dbget.close() : Response.End
End IF
If not( left(currenttime,10)>="2016-03-28" and left(currenttime,10)<"2016-04-01" ) Then
	Response.Write "03||이벤트 응모 기간이 아닙니다."
	dbget.close() : Response.End
End IF

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
end if

if mode="order" then
	sqlstr = " select count(*) as totalcnt, isnull(sum(subtotalprice),0) as subtotalprice"
	sqlstr = sqlstr & " from db_order.dbo.tbl_order_master m"
	sqlstr = sqlstr & " where m.regdate >= '2016-03-01'"
	sqlstr = sqlstr & " and m.jumundiv not in (6,9)"
	sqlstr = sqlstr & " and m.ipkumdiv>3"
	sqlstr = sqlstr & " and m.userid='"& userid &"'"
	sqlstr = sqlstr & " and m.cancelyn='N'"

	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		totalcnt = rsget("totalcnt")
		subtotalprice = rsget("subtotalprice")
	END IF
	rsget.close

	'Response.Write "04||"& FormatNumber(totalcnt,0) &"||"& FormatNumber(subtotalprice,0) &""
	Response.Write "04||"& totalcnt &"||"& subtotalprice &""
	dbget.close()	:	response.end

elseif mode="giftinsert" then
	if subscriptcount>0 then
		Response.Write "05||한 개의 아이디당 한 번만 응모가 가능 합니다."
		dbget.close() : Response.End
	end if

'	if selval="" then
'		Response.Write "06||사은품을 선택해 주세요."
'		dbget.close() : Response.End
'	end if

	sqlstr = " select count(*) as totalcnt, isnull(sum(subtotalprice),0) as subtotalprice"
	sqlstr = sqlstr & " from db_order.dbo.tbl_order_master m"
	sqlstr = sqlstr & " where m.regdate >= '2016-03-01'"
	sqlstr = sqlstr & " and m.jumundiv not in (6,9)"
	sqlstr = sqlstr & " and m.ipkumdiv>3"
	sqlstr = sqlstr & " and m.userid='"& userid &"'"
	sqlstr = sqlstr & " and m.cancelyn='N'"

	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		totalcnt = rsget("totalcnt")
		subtotalprice = rsget("subtotalprice")
	END IF
	rsget.close

	if totalcnt=0 and subtotalprice=0 then
		Response.Write "07||3월 구매내역이 있어야 응모할수 있습니다."
		dbget.close() : Response.End
	end if

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt3, device)" + vbcrlf
	
	if isApp="1" then
		sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& left(currenttime,10) &"', 'OK', 'A')" + vbcrlf
	else
		sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& left(currenttime,10) &"', 'OK', 'M')" + vbcrlf
	end if

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Response.Write "08||OK"
	dbget.close() : Response.End
Else
	Response.Write "00||정상적인 경로가 아닙니다."
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
