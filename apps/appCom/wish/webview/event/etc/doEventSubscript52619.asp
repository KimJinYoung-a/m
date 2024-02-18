<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 만원 팔이피플
' History : 2014.06.11 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/event/etc/event52619Cls.asp" -->

<%
dim eCode, userid, mode, sqlstr, refer, totalsubscriptcount, subscriptcount, dateitemlimitcnt, winox, rvalue, k
dim totalitemcouponexistscount
	mode = requestcheckvar(request("mode"),32)
	eCode=getevt_code
	userid = getloginuserid()

winox="x"
totalitemcouponexistscount=0
totalsubscriptcount=0
subscriptcount=0
dateitemlimitcnt=0

refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF
If not(left(currenttime,10)>="2014-06-16" and left(currenttime,10)<"2014-06-21") Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF

if mode="iteminsert" then
	if staffconfirm and request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW
		Response.Write "<script type='text/javascript'>alert('텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if
	if not (Hour(currenttime) > 12 and Hour(currenttime) < 17) then
		Response.Write "<script type='text/javascript'>alert('오후 1시부터 5시까지만 응모가 가능합니다.'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if
	'//본인 참여 여부
	subscriptcount = getevent_subscriptexistscount(eCode, userid, left(currenttime,10), "1", "")
	if subscriptcount <> 0 then
		Response.Write "<script type='text/javascript'>alert('한 개의 아이디당 하루 한 번만 응모하실 수 있습니다.'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if

'	On Error Resume Next
'	dbget.beginTrans

	'/상품 제한수량
	dateitemlimitcnt=itemlimitcnt( dateitemval(left(currenttime,10)) )
	'//전체 참여수
	totalsubscriptcount = getevent_subscripttotalcount(eCode, left(currenttime,10), "1", "1")
	if totalsubscriptcount>=dateitemlimitcnt then
'		dbget.RollBackTrans
'		on error goto 0
		
		Response.Write "<script type='text/javascript'>alert('오늘의 만원 팔이피플 상품이 전부 소진되었습니다. 다음 기회에 다시 도전해주세요!'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if
	'//전체 상품 쿠폰 발행수량
	totalitemcouponexistscount=getitemcouponexistscount("", datecouponval(left(currenttime,10)), "", "")
	if totalitemcouponexistscount>=dateitemlimitcnt then
'		dbget.RollBackTrans
'		on error goto 0

		Response.Write "<script type='text/javascript'>alert('오늘의 만원 팔이피플 상품이 전부 소진되었습니다. 다음 기회에 다시 도전해주세요!'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if

	winox="x"
	'//1부터 100 까지 난수 생성
	Randomize
	k = Int(100 * Rnd)
	if k < 2 then		'/1% 당첨
		winox="o"
		
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"&left(currenttime,10)&"', 1, '1', 'A')" + vbcrlf

		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr
		
		rvalue = fnSetItemCouponDown(userid,datecouponval(left(currenttime,10)))	'/itemcoupon 처리
	else
		winox="x"

		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"&left(currenttime,10)&"', 1, '2', 'A')" + vbcrlf
	
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr
	end if
	
'	If Err.Number = 0 Then
'	    dbget.CommitTrans
'	    'dbget.RollBackTrans
'	Else
'	    dbget.RollBackTrans
'	End If
'	on error goto 0

	'//당첨
	if winox="o" then
		Response.Write "<script type='text/javascript'>alert('축하합니다!\n지금 바로 만원의 쇼핑혜택을 누리세요!\n(한정수량으로 조기소진될 수 있습니다.)');</script>"
		Response.Write "<script type='text/javaScript'>parent.top.location.href='/apps/appcom/wish/webview/category/category_itemPrd.asp?itemid="&dateitemval(left(currenttime,10))& dateitemlinkval(left(currenttime,10))&"'</script>"

	'//꽝
	else
		Response.Write "<script type='text/javascript'>alert('아쉽네요.\n만원 팔이피플을 사랑해주셔서 감사합니다.\n다음에 또 찾아볼게요! :)'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
	end if
	dbget.close() : Response.End
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
end if

'## 상품쿠폰 다운 함수
Function fnSetItemCouponDown(ByVal userid, ByVal idx)
	dim sqlStr
	Dim objCmd
	Set objCmd = Server.CreateObject("ADODB.COMMAND")
	With objCmd
		.ActiveConnection = dbget
		.CommandType = adCmdText
		.CommandText = "{?= call [db_item].[dbo].sp_Ten_itemcoupon_down("&idx&",'"&userid&"')}"
		.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
		.Execute, , adExecuteNoRecords
		End With	
	    fnSetItemCouponDown = objCmd(0).Value	
	Set objCmd = Nothing	
END Function
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->