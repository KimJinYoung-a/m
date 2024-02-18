<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 벗꽃을 찍어요 팡팡팡
' History : 2017-04-07 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim resultcnt, sqlstrcnt, resultaftercnt
Dim refer, eCode, LoginUserid, mode, sqlStr, device, cLayerValue, currenttime
	
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66302
Else
	eCode   =  77393
End If

currenttime = date()

if isapp then
	device = "A"
else
	device = "M"
end if
resultcnt = 0
resultaftercnt = 0
LoginUserid		= getencLoginUserid()
mode			= requestcheckvar(request("mode"),32)
refer 			= request.ServerVariables("HTTP_REFERER")

'// 바로 접속시엔 오류 표시
If InStr(refer, "10x10.co.kr") < 1 Then
	Response.Write "Err|잘못된 접속입니다."
	Response.End
End If

if mode<>"result" then		
	Response.Write "Err|잘못된 접속입니다."
	dbget.close: Response.End
end If

If Not(IsUserLoginOK) Then
	Response.Write "Err|로그인 후 참여하실 수 있습니다."
	response.End
End If

if Not(currenttime >= "2017-04-10" and currenttime <= "2017-04-23") then		
	Response.Write "Err|이벤트 기간이 아닙니다."
	dbget.close: Response.End
end If

if mode="result" then
	sqlstr = ""
	sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE  evt_code = '"& eCode &"' and userid= '"&LoginUserid&"' "
	rsget.Open sqlstr, dbget, 1
		resultcnt = rsget("cnt")
	rsget.close

	If resultcnt > 0 Then
		Response.Write "Err|이미 신청 하셨습니다."
		dbget.close()	:	response.End
	Else
		sqlStr = ""
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid, device)" & vbCrlf
		sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '"&device&"')"
		dbget.execute sqlstr

		sqlstrcnt = ""
		sqlstrcnt = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE  evt_code = '"& eCode &"'  "
		rsget.Open sqlstrcnt, dbget, 1
			resultaftercnt = rsget("cnt")
		rsget.close

		cLayerValue = ""
		cLayerValue = cLayerValue & " 		<img src='http://webimage.10x10.co.kr/playing/thing/vol012/m/btn_get_done.png' alt='Blossom Pang Kit 신청완료' /> "

		Response.write "OK|"&resultaftercnt&"|"&cLayerValue
		dbget.close()	:	response.End
	end if
else
	Response.Write "Err|잘못된 접속입니다.E05"
	dbget.close: Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->