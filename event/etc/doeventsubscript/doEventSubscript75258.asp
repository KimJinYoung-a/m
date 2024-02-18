<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : [1월 신규가입이벤트] 해피뉴이어 Coupon!
' History : 2016.12.30 유태욱
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<%
Dim eCode, sqlstr, cnt
Dim currenttime, refer, LoginUserid
Dim result, mode, mysubsctiptcnt
Dim device

If isapp Then
	device = "A"
Else
	device = "M"
End If

currenttime = date()

LoginUserid = getLoginUserid()
refer		= request.ServerVariables("HTTP_REFERER")
mode		= requestcheckvar(request("mode"),5)

IF application("Svr_Info") = "Dev" THEN
	eCode = "66261"
Else
	eCode = "75258"
End If

'// 바로 접속시엔 오류 표시
If InStr(refer, "10x10.co.kr") < 1 Then
	Response.Write "Err|잘못된 접속입니다.E01"
	dbget.close: Response.End
End If

'// 로그인 여부 체크
If Not(IsUserLoginOK) Then
	Response.Write "Err|로그인 후 참여하실 수 있습니다."
	dbget.close: response.End
End If

'// 로그인 여부 체크
If Not(IsUserLoginOK) Then
	Response.Write "Err|로그인 후 참여하실 수 있습니다."
	response.End
End If

'// expiredate
If not(currenttime >= "2017-01-01" and currenttime <= "2017-01-31") Then
	Response.Write "Err|이벤트 응모 기간이 아닙니다."
	Response.End
End If

If mode = "down" Then
	'1월 신규 회원가입인지 확인
	sqlstr = "SELECT COUNT(*) as cnt FROM db_user.dbo.tbl_user_n WHERE userid= '"&LoginUserid&"' and regdate between '2017-01-01 00:00:00' and '2017-01-31 23:59:59' "
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

			sqlStr = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & LoginUserid & "' AND masteridx = '944') " & vbCrlf
			sqlStr = sqlStr & "BEGIN " & vbCrlf
			sqlStr = sqlStr & "	INSERT INTO [db_user].[dbo].tbl_user_coupon" & vbCrlf
			sqlStr = sqlStr & " (masteridx, userid, couponvalue, coupontype, couponname, minbuyprice, " & vbCrlf
			sqlStr = sqlStr & " targetitemlist, startdate, expiredate)" & vbCrlf
			sqlStr = sqlStr & " values(944,'" & LoginUserid & "',10000,'2','1월신규가입쿠폰(10,000원)',60000," & vbCrlf
			sqlStr = sqlStr & " '',getdate() ,dateadd(hh, +24, getdate()))" & vbCrlf
			sqlStr = sqlStr & "END " & vbCrlf
			dbget.execute(sqlStr)

			sqlStr = "IF NOT EXISTS(select userid FROM [db_user].[dbo].[tbl_user_coupon] WHERE userid = '" & LoginUserid & "' AND masteridx = '945') " & vbCrlf
			sqlStr = sqlStr & "BEGIN " & vbCrlf
			sqlStr = sqlStr & "	INSERT INTO [db_user].[dbo].tbl_user_coupon" & vbCrlf
			sqlStr = sqlStr & " (masteridx, userid, couponvalue, coupontype, couponname, minbuyprice, " & vbCrlf
			sqlStr = sqlStr & " targetitemlist, startdate, expiredate)" & vbCrlf
			sqlStr = sqlStr & " values(945,'" & LoginUserid & "',15000,'2','1월신규가입쿠폰(15,000원)',100000," & vbCrlf
			sqlStr = sqlStr & " '',getdate() ,dateadd(hh, +24, getdate()))" & vbCrlf
			sqlStr = sqlStr & "END " & vbCrlf
			dbget.execute(sqlStr)
			Response.write "OK|dn"
			dbget.close()	:	response.End
		ElseIf mysubsctiptcnt > 0 Then
			Response.Write "Err|이미 쿠폰을 다운받으셨습니다."
			dbget.close()	:	response.End
		Else
			Response.write "Err|정상적인 경로로 참여해주시기 바랍니다."
			dbget.close()	:	response.End
		End If
	Else
		Response.write "Err|이벤트 대상이 아닙니다!"
		dbget.close()	:	response.End
	End If
Else
	Response.Write "Err|정상적인 경로로 참여해주시기 바랍니다."
	dbget.close() : Response.End
End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->