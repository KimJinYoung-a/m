<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  구매금액별 사은이벤트 선물 못받을까바 오빠가 오다 주웠다
' History : 2015.01.30 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event59066Cls.asp" -->

<%
dim mode, sqlstr, orderserial
	mode = requestcheckvar(request("mode"),32)
	orderserial=getNumeric(requestcheckvar(request("orderserial"),11))

dim eCode, userid, i
	eCode=getevt_code
	userid = getloginuserid()

dim subscriptorderserialcount, subscriptcount
	subscriptorderserialcount=0
	subscriptcount=0

dim refer
	refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

if mode="valinsert" then
	If not(getnowdate>="2015-02-02" and getnowdate<"2015-02-13") Then
		Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&getevt_codedisp&"'</script>"
		dbget.close() : Response.End
	End IF
	If userid = "" Then
		Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&getevt_codedisp&"'</script>"
		dbget.close() : Response.End
	End IF
	if staffconfirm and request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW
		Response.Write "<script type='text/javascript'>alert('텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&getevt_codedisp&"'</script>"
		dbget.close() : Response.End
	end if
	If orderserial = "" Then
		Response.Write "<script type='text/javascript'>alert('선택하신 주문이 없습니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&getevt_codedisp&"'</script>"
		dbget.close() : Response.End
	End IF

	sqlstr = sqlstr & " select count(m.orderserial) as cnt"
	sqlstr = sqlstr & " from db_order.dbo.tbl_order_master m"
	sqlstr = sqlstr & " where m.regdate >= '2015-02-02' and m.regdate < '2015-02-13'"
	sqlstr = sqlstr & " and m.jumundiv<>9"
	sqlstr = sqlstr & " and m.ipkumdiv>3"
	sqlstr = sqlstr & " and m.orderserial='"& trim(orderserial) &"'"
	sqlstr = sqlstr & " and m.userid='"& userid &"'"
	sqlstr = sqlstr & " and m.cancelyn='N'"
	
	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		subscriptorderserialcount = rsget("cnt")
	END IF
	rsget.close
	
	If subscriptorderserialcount < 1 Then
		Response.Write "<script type='text/javascript'>alert('주문건이 존재 하지 않습니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&getevt_codedisp&"'</script>"
		dbget.close() : Response.End
	End IF

	'//본인참여수
	subscriptcount = getevent_subscriptexistscount(eCode, userid, trim(orderserial), "", "")
	if subscriptcount > 0 then
		Response.Write "<script type='text/javascript'>alert('이미 응모하신 주문건 입니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&getevt_codedisp&"'</script>"
		dbget.close() : Response.End
	end if

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& trim(orderserial) &"', 0, '', 'M')" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr
	
	Response.Write "<script type='text/javascript'>alert('응모가 완료되었습니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&getevt_codedisp&"'</script>"
	dbget.close() : Response.End

else
	Response.Write "정상적인 경로가 아닙니다."
	dbget.close() : Response.End
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->