<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  2015오픈이벤트
' History : 2015.04.08 한용민 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event60830Cls.asp" -->
<%
dim eCode, userid, mode
	eCode=getevt_code
	userid = getloginuserid()
	mode = requestcheckvar(request("mode"),32)

dim refer
	refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end If

dim wishcount, talkcount, bagunicount, subscriptcountclear, totalsubscriptcountclear, mileagescount, totalmileagescount, sqlstr
	wishcount=0
	talkcount=0
	bagunicount=0
	subscriptcountclear=0
	totalsubscriptcountclear=0
	mileagescount=0
	totalmileagescount=0

If mode = "wish" Then
	if userid="" then
		Response.Write "99"
		dbget.close() : Response.End
	End If
	if not( getnowdate>="2015-04-13" and getnowdate<"2015-04-25" ) then
		Response.Write "12"
		dbget.close() : Response.End
	End If
	if staffconfirm and request.cookies("tinfo")("userlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("tinfo")("userlevel")		'/WWW
		Response.write "98"
		dbget.close() : Response.End
	end if
	
'	subscriptcountclear = getevent_subscriptexistscount(eCode, userid, "", "4", "")
'	'mileagescount = getmileageexistscount(userid, eCode, "[사월의 꿀맛]삼시세번 3,000 마일리지 적립", "", "N")
'	'if clng(subscriptcountclear) > 0 or clng(mileagescount) > 0 then
'	if clng(subscriptcountclear) > 0 then
'		Response.write "11"
'		dbget.close() : Response.End
'	end if

'	totalsubscriptcountclear = getevent_subscripttotalcount(eCode, getnowdate, "4", "")
'	'totalmileagescount = getmileageexiststotalcount(eCode, "[사월의 꿀맛]삼시세번 3,000 마일리지 적립", getnowdate, "N")
'	'if clng(totalsubscriptcountclear) > clng(getmileagelimit) or clng(totalmileagescount) > clng(getmileagelimit) then
'	if clng(totalsubscriptcountclear) > clng(getmileagelimit) then
'		Response.write "14"
'		dbget.close() : Response.End
'	end if

	wishcount = getwishcount(userid)
	if clng(wishcount) >= 10 then
		Response.write "01"&"!@#"&wishcount
		dbget.close() : Response.End
	else
		Response.write "02"&"!@#"&wishcount
		dbget.close() : Response.End
	end if
	
	dbget.close() : Response.End

elseIf mode = "talk" Then
	if userid="" then
		Response.Write "99"
		dbget.close() : Response.End
	End If
	if not( getnowdate>="2015-04-13" and getnowdate<"2015-04-25" ) then
		Response.Write "12"
		dbget.close() : Response.End
	End If
	if staffconfirm and request.cookies("tinfo")("userlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("tinfo")("userlevel")		'/WWW
		Response.write "98"
		dbget.close() : Response.End
	end if
	
'	subscriptcountclear = getevent_subscriptexistscount(eCode, userid, "", "4", "")
'	'mileagescount = getmileageexistscount(userid, eCode, "", "", "N")
'	'if clng(subscriptcountclear) > 0 or clng(mileagescount) > 0 then
'	if clng(subscriptcountclear) > 0 then
'		Response.write "11"
'		dbget.close() : Response.End
'	end if

'	totalsubscriptcountclear = getevent_subscripttotalcount(eCode, getnowdate, "4", "")
'	'totalmileagescount = getmileageexiststotalcount(eCode, "", getnowdate, "N")
'	'if clng(totalsubscriptcountclear) > clng(getmileagelimit) or clng(totalmileagescount) > clng(getmileagelimit) then
'	if clng(totalsubscriptcountclear) > clng(getmileagelimit) then
'		Response.write "14"
'		dbget.close() : Response.End
'	end if

	wishcount = getwishcount(userid)
	if clng(wishcount) < 10 then
		Response.write "13"
		dbget.close() : Response.End
	end if

	talkcount = gettalkcount(userid)
	if clng(talkcount) >= 3 then
		Response.write "01"&"!@#"&talkcount
		dbget.close() : Response.End
	else
		Response.write "02"&"!@#"&talkcount
		dbget.close() : Response.End
	end if

	dbget.close() : Response.End

elseIf mode = "baguni" Then
	if userid="" then
		Response.Write "99"
		dbget.close() : Response.End
	End If
	if not( getnowdate>="2015-04-13" and getnowdate<"2015-04-25" ) then
		Response.Write "12"
		dbget.close() : Response.End
	End If
	if staffconfirm and request.cookies("tinfo")("userlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("tinfo")("userlevel")		'/WWW
		Response.write "98"
		dbget.close() : Response.End
	end if
	
'	subscriptcountclear = getevent_subscriptexistscount(eCode, userid, "", "4", "")
'	'mileagescount = getmileageexistscount(userid, eCode, "", "", "N")
'	'if clng(subscriptcountclear) > 0 or clng(mileagescount) > 0 then
'	if clng(subscriptcountclear) > 0 then
'		Response.write "11"
'		dbget.close() : Response.End
'	end if

'	totalsubscriptcountclear = getevent_subscripttotalcount(eCode, getnowdate, "4", "")
'	'totalmileagescount = getmileageexiststotalcount(eCode, "", getnowdate, "N")
'	'if clng(totalsubscriptcountclear) > clng(getmileagelimit) or clng(totalmileagescount) > clng(getmileagelimit) then
'	if clng(totalsubscriptcountclear) > clng(getmileagelimit) then
'		Response.write "14"
'		dbget.close() : Response.End
'	end if

	wishcount = getwishcount(userid)
	if clng(wishcount) < 10 then
		Response.write "13"
		dbget.close() : Response.End
	end if

	talkcount = gettalkcount(userid)
	if clng(talkcount) < 3 then
		Response.write "15"
		dbget.close() : Response.End
	end if

	bagunicount = getbagunicount(userid)
	if clng(bagunicount) >= 5 then
		Response.write "01"&"!@#"&bagunicount
		dbget.close() : Response.End
	else
		Response.write "02"&"!@#"&bagunicount
		dbget.close() : Response.End
	end if

	dbget.close() : Response.End
	
elseIf mode = "mileage" Then
	if userid="" then
		Response.Write "99"
		dbget.close() : Response.End
	End If
	if not( getnowdate>="2015-04-13" and getnowdate<"2015-04-25" ) then
		Response.Write "12"
		dbget.close() : Response.End
	End If
	if staffconfirm and request.cookies("tinfo")("userlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("tinfo")("userlevel")		'/WWW
		Response.write "98"
		dbget.close() : Response.End
	end if

	if Hour(now()) < 10 then
		Response.Write "17"
		dbget.close() : Response.End
	end if

	subscriptcountclear = getevent_subscriptexistscount(eCode, userid, "", "4", "")
	'mileagescount = getmileageexistscount(userid, eCode, "", "", "N")
	'if clng(subscriptcountclear) > 0 or clng(mileagescount) > 0 then
	if clng(subscriptcountclear) > 0 then
		Response.write "11"
		dbget.close() : Response.End
	end if

	totalsubscriptcountclear = getevent_subscripttotalcount(eCode, getnowdate, "4", "")
	'totalmileagescount = getmileageexiststotalcount(eCode, "", getnowdate, "N")
	'if clng(totalsubscriptcountclear) > clng(getmileagelimit) or clng(totalmileagescount) > clng(getmileagelimit) then
	if clng(totalsubscriptcountclear) > clng(getmileagelimit) then
		Response.write "14"
		dbget.close() : Response.End
	end if

	wishcount = getwishcount(userid)
	if clng(wishcount) < 10 then
		Response.write "13"
		dbget.close() : Response.End
	end if

	talkcount = gettalkcount(userid)
	if clng(talkcount) < 3 then
		Response.write "15"
		dbget.close() : Response.End
	end if

	bagunicount = getbagunicount(userid)
	if clng(bagunicount) < 5 then
		Response.write "16"
		dbget.close() : Response.End
	end if

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & "VALUES("& eCode &", '" & userid & "', '"& getnowdate &"', '4', '', 'M')"

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr
	
	sqlstr = "update db_user.dbo.tbl_user_current_mileage" + vbcrlf
	sqlstr = sqlstr & " set bonusmileage = bonusmileage+3000" + vbcrlf
	sqlstr = sqlstr & " where userid = '" & userid & "'"

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr
	
	sqlstr = "insert into db_user.dbo.tbl_mileagelog(userid , mileage , jukyocd , jukyo , deleteyn)" + vbcrlf
	sqlstr = sqlstr & " values('" & userid & "', '+3000', "& eCode &", '[사월의 꿀맛]삼시세번 3,000 마일리지 적립','N')"

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Response.write "01"
	dbget.close() : Response.End
Else
	Response.Write "정상적인 경로가 아닙니다."
	dbget.close() : Response.End
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->
