<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"

%>
<%
'####################################################
' Description : [13주년] 즐겨라,텐바이텐_ 쌓여라 스페셜 혜택 마일리지 제공
' History : 2014.10.05 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%

	dim userid, subscriptcount, totalsubscriptcount, bonuscouponcount, totalbonuscouponcount, sqlstr, mode, eCode, evtcount, evttotalCnt, vQuery, mlogchk, getevt_codeprint
	userid = getloginuserid()

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  21234
		getevt_codeprint = 21234
	Else
		eCode   =  55502
		getevt_codeprint = 55502
	End If

	If userid="" or isNull(userid) Then
		Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&getevt_codeprint&"'</script>"
		dbget.close() : Response.End
	End IF

	sqlstr = " Select count(*) as cnt From db_event.dbo.tbl_event_subscript Where userid='" & userid & "' And evt_code='" & eCode & "' "
	rsget.Open sqlstr,dbget,1
		evtcount = rsget("cnt")
	rsget.Close

	vQuery = " SELECT count(*) as cnt From db_event.dbo.tbl_event_subscript Where evt_code='"&eCode&"' "
	rsget.Open vQuery, dbget, 1
	evttotalCnt = rsget(0)
	rsget.close


	vQuery = " Select userid From db_user.dbo.tbl_mileagelog Where userid='"&userid&"' And jukyo='13주년 쌓여라 스페셜 혜택 마일리지 500 제공' "
	rsget.Open vQuery, dbget, 1
	If Not rsget.Eof Then
		mlogchk = 1
	Else
		mlogchk = 0
	End If
	rsget.close



	dim refer
		refer = request.ServerVariables("HTTP_REFERER")
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "잘못된 접속입니다."
		dbget.close() : Response.End
	end if

	If not( left(Now(),10)>="2014-10-05" and left(Now(),10)<"2014-10-21" ) Then
		Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&getevt_codeprint&"'</script>"
		dbget.close() : Response.End
	End IF


'	if request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW
'		Response.Write "<script type='text/javascript'>alert('텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)'); parent.top.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&getevt_codeprint&"'</script>"
'		dbget.close() : Response.End
'	end If


	If evtcount <> 0 Then
		Response.Write "<script type='text/javascript'>alert('이미 마일리지를 발급받으셨습니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&getevt_codeprint&"'</script>"
		dbget.close() : Response.End
	End If

	If evttotalCnt > 20000 Then
		Response.Write "<script type='text/javascript'>alert('죄송합니다.\n선착순 20,000명의 회원분들에게\n마일리지 지급이 완료되었습니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&getevt_codeprint&"'</script>"
		dbget.close() : Response.End
	End If

	If mlogchk <> 0 Then
		Response.Write "<script type='text/javascript'>alert('이미 마일리지를 발급받으셨습니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&getevt_codeprint&"'</script>"
		dbget.close() : Response.End
	End If


	'// 이벤트 테이블에 마일리지 제공 내역 남긴다.
	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '', 500, '13주년 쌓여라 스페셜 혜택 마일리지 500 제공', 'A')" + vbcrlf
	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr


	'// 현 유저가 보유하고 있는 마일리지 포인트에 500포인트 +시킨다.
	sqlstr = " update [db_user].[dbo].[tbl_user_current_mileage] " + vbcrlf
	sqlstr = sqlstr & " set bonusmileage = bonusmileage + 500 " + vbcrlf
	sqlstr = sqlstr & " where userid = '"&userid&"' "
	dbget.execute sqlstr


	'// 마일리지 로그 테이블에 500포인트 지급 내역 담는다.
	sqlstr = " insert into db_user.dbo.tbl_mileagelog(userid , mileage , jukyocd , jukyo , deleteyn) " + vbcrlf
	sqlstr = sqlstr & " SELECT '"&userid&"', 500, 1000, '13주년 쌓여라 스페셜 혜택 마일리지 500 제공','N' "
	dbget.execute sqlstr

	Response.Write "<script type='text/javascript'>alert('마일리지가 적립되었습니다.!');</script>"
	'Response.Write "<script type='text/javaScript'>parent.location.href='/apps/appcom/wish/web2014/category/category_itemPrd.asp?itemid="&dateitemval(left(currenttime,10)) &"'</script>"
	Response.Write "<script type='text/javaScript'>parent.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&getevt_codeprint&"';</script>"
	dbget.close() : Response.End
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->