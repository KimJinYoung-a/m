<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
dim eCode, com_egCode, bidx,Cidx, linkeCode
dim userid, txtcomm, txtcommURL, mode, spoint
mode=requestCheckVar(request.Form("mode"),4)
eCode =requestCheckVar(request.Form("eventid"),10)
linkeCode =requestCheckVar(request.Form("eventidlink"),10)
com_egCode=requestCheckVar(request.Form("com_egC"),10)
bidx = requestCheckVar(request.Form("bidx"),10)
Cidx = requestCheckVar(request.Form("Cidx"),10)
userid = GetLoginUserID

IF spoint = "" THEN spoint = 0
IF bidx = "" THEN bidx = 0
IF com_egCode = "" THEN com_egCode = 0

dim referer,refip, returnurl
dim dcost, availtotalMile
referer = request.ServerVariables("HTTP_REFERER")
refip = request.ServerVariables("REMOTE_ADDR")
returnurl = requestCheckVar(request.Form("returnurl"),100)
dcost = requestCheckVar(Request("dcost"),100)
availtotalMile= requestCheckVar(Request("availtotalMile"),100)

'	response.write "<script type='text/javascript'>"
'	response.write "alert('"&eCode&"');"
'	response.write "</script>"
'	response.end

dim sqlStr

If int(availtotalMile) < 1 then
	response.write "<script type='text/javascript'>"
	response.write "history.back();"
	response.write "</script>"
	dbget.close()	:	response.End
End if

If int(dcost) > int(availtotalMile) then
	response.write "<script type='text/javascript'>"
	response.write "alert('최대 " & availtotalMile & "원 기부 가능합니다');"
	'response.write "top.location.href='/play/playGround.asp?gidx=13&gcidx=52';"
	response.write "history.back();"
	response.write "</script>"
	dbget.close()	:	response.End
end If

	sqlStr = "update db_user.dbo.tbl_user_current_mileage " & _
			 "set spendmileage = spendmileage+"& dcost & " " & _
			 "where userid = '" & userid & "';" & vbCrLf & _
			 "insert into db_user.dbo.tbl_mileagelog(userid , mileage , jukyocd , jukyo , deleteyn) " & _
			 "values('" & userid & "', '-"& dcost &"', 1000, '마일리지 기부','N');" & vbCrLf & _
			 "insert into db_event.dbo.tbl_event_subscript(evt_code, userid, sub_opt2) " & _
			 "values('" & eCode & "','" & userid & "','" & dcost & "');"

	dbget.execute(sqlStr)

	response.write "<script>"
	response.write "alert('마일리지가 기부되었습니다.');"
	response.write "</script>"
	response.write "<script>location.replace('" + Cstr(referer) + "');</script>"
	dbget.close()	:	response.End
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->