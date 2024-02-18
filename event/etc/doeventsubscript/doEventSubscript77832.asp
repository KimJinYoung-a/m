<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 장미쿠폰 서브이벤트 마일리지 신청 MA
' History : 2017.05.12 유태욱
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim mysubsctiptcnt, totalsubsctiptcnt, currenttime, refer
Dim eCode, LoginUserid, mode, sqlStr, device, cnt
		
IF application("Svr_Info") = "Dev" THEN
	eCode = 66326
Else
	eCode = 77832
End If

currenttime = date()
mode			= requestcheckvar(request("mode"),32)
LoginUserid		= getencLoginUserid()
refer 			= request.ServerVariables("HTTP_REFERER")

'// 바로 접속시엔 오류 표시
If InStr(refer, "10x10.co.kr") < 1 Then
	Response.Write "01||유입경로에 문제가 발생하였습니다. 관리자에게 문의해주십시오"
	dbget.close() : Response.End
End If

if Not(Now() > #05/15/2017 00:00:00# And Now() < #05/16/2017 01:00:00#) then
	Response.Write "15||이벤트 기간이 아닙니다."
	dbget.close() : Response.End
end if

'// 로그인 여부 체크
If Not(IsUserLoginOK) Then
	Response.Write "02|로그인 후 신청할 수 있습니다."
	response.End
End If

if isapp then
	device = "A"
Else
	device = "M"
end if

If mode = "mile" Then
	sqlstr = "SELECT COUNT(*) as cnt FROM [db_order].[dbo].[tbl_order_master] WHERE userid= '"&LoginUserid&"' and miletotalprice > 0 and cancelyn='N' and ipkumdiv>1 and beadaldiv<>'90' and jumundiv not in(6,9) and ipkumdate >= '2017-05-15 00:00:00' and ipkumdate <= '2017-05-15 23:59:59' "
	rsget.Open sqlstr, dbget, 1
		cnt = rsget("cnt")
	rsget.close

	If cnt > 0 Then
		sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '"& eCode &"' and userid= '"&LoginUserid&"' "
		rsget.Open sqlstr, dbget, 1
			mysubsctiptcnt = rsget("cnt")
		rsget.close

		If mysubsctiptcnt < 1 Then
			sqlStr = ""
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , device)" & vbCrlf
			sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '"&device&"')"
			dbget.execute sqlstr

			Response.Write "11||신청이 완료 되었습니다."
			dbget.close() : Response.End
		ElseIf mysubsctiptcnt > 0 Then
			Response.Write "13||이미 신청 하셨습니다."
			dbget.close() : Response.End
		Else
			Response.Write "00||정상적인 경로가 아닙니다."
			dbget.close() : Response.End
		End If
	Else
		if currenttime > "2017-05-15" then
			Response.Write "16||본 이벤트는 5월 15일에 결제한 고객 대상으로 진행하는 이벤트입니다. 다음 기회에 참여해주세요 :)"
			dbget.close() : Response.End
		Else
			Response.Write "14||마일리지로 결제한 후에 신청해주세요!"
			dbget.close() : Response.End
		end if
	End If
Else
	Response.Write "00||정상적인 경로가 아닙니다."
	dbget.close() : Response.End
End If	
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->