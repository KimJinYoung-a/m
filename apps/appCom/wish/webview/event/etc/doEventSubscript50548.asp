<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description :  텐바이텐 위시 APP 런칭이벤트 1차
' History : 2014.03.27 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/event/etc/event50548Cls.asp" -->
<!-- #include virtual="/apps/appCom/wish/webview/lib/classes/Apps_eventCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->

<%
dim eCode, userid, wishsubscriptcount, wishfolder50548count,  mode, sqlstr, refer, myfavorite, vFidx
	mode = requestcheckvar(request("mode"),32)
	eCode=getevt_code
	userid = getloginuserid()

wishsubscriptcount=0
wishfolder50548count=0

refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF
If not(getnowdate>="2014-04-01" and getnowdate<"2014-04-15") Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF

if mode="addwish" then
	wishsubscriptcount = getevent_subscriptexistscount(eCode, userid, "WISH_A", "", "")
	wishfolder50548count = getwishfolder50548(userid)

	if wishsubscriptcount > 0 or wishfolder50548count > 0 then
		Response.Write "<script type='text/javascript'>alert('이미 응모하셨습니다.'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if

	'# 이벤트 폴더 생성
	set myfavorite = new CMyFavorite	
		myfavorite.FRectUserID = userid
		myfavorite.FFolderName = "[wish 이벤트]"
		myfavorite.fviewisusing = "Y"
		vFidx = myfavorite.fnSetFolder
	set myfavorite = nothing
	
	IF vFidx > 0  THEN
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', 'WISH_A', 0, '')" + vbcrlf
	
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr

		Response.Write "<script type='text/javascript'>alert('이벤트 폴더가 생성되었습니다.'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	ELSEIF 	vFidx =-1 THEN
		Response.Write "<script type='text/javascript'>alert('위시리스트는 최대 10개까지만 생성이 가능합니다.\n이벤트에 참여를 원하시면 위시리스트를 정리해주세요.'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	ELSE
		Response.Write "<script type='text/javascript'>alert('처리중 오류가 발생했습니다.'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End if
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->