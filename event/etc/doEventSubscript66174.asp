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
' Description :  러브하우스
' History : 2015.09.17 유태욱
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event66174Cls.asp" -->

<%
dim mode, refer, idx, div, eCode, isapp
dim opt, imgfile2, imgfile3, imgfile4, imgfile5, optText, imgContent
	mode	= requestcheckvar(request("mode"),32)
	idx		= requestcheckvar(request("idx"),10)
	div		= requestcheckvar(request("div"),10)
	eCode	= requestcheckvar(request("ecode"),10)
	userid 	= GetEncLoginUserID
	opt 		= requestCheckVar(request("age"),1)
	imgfile2	= html2db(requestCheckVar(request("myArea"),12))
	imgfile3	= requestCheckVar(request("wedding"),1)
	imgfile4	= requestCheckVar(request("pyongsu"),12)
	imgfile5	= requestCheckVar(request("home"),100)
	optText 	= requestCheckVar(request("optText"),100)
	imgContent 	= html2db(request("imgContent"))
	isApp = requestcheckvar(request("isapp"),1)

	
	IF userid = "" THEN
		Alert_return("유입 경로에 문제가 있습니다. 관리자에게 문의해 주십시오.")
		response.end
	END IF
	If idx = "" Then
		Response.Write "<script type='text/javascript'>alert('구분자가 없습니다.'); history.back();</script>"
		dbget.close() : Response.End
	End IF

refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

dim appUrlPath
	Select Case cStr(isApp)
		Case "2"
			appUrlPath = "/apps/appcom/wish/webview"
		Case "1"
			appUrlPath = "/apps/appcom/wish/web2014"
		Case Else
			appUrlPath = ""
	End Select

if mode="del" then
	sqlstr = "UPDATE [db_event].[dbo].[tbl_contest_entry]  " + vbcrlf
	sqlstr = sqlstr & " set userid='dd' where " + vbcrlf
	sqlstr = sqlstr & "  idx='"& idx &"' and userid='"& userid &"' and div='"& div &"'"
	
	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr
	Response.Write "<script type='text/javascript'>alert('삭제되었습니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"

elseif mode="edit" then
	sqlstr = "UPDATE [db_event].[dbo].[tbl_contest_entry]  " + vbcrlf
	sqlstr = sqlstr & " set imgFile2='"& imgfile2 &"', imgFile3='"& imgFile3 &"', imgFile4='"& imgFile4 &"', imgFile5='"& imgFile5 &"', opt='"& opt &"', imgContent='"& imgContent &"'  where " + vbcrlf
	sqlstr = sqlstr & "  idx='"& idx &"' and userid='"& userid &"' and div='"& div &"'"
	
	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr
'	Response.Write "<script type='text/javascript'>alert('수정되었습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	Response.Write "<script type='text/javascript'>alert('수정되었습니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
else
	Alert_return("유입 경로에 문제가 있습니다. 관리자에게 문의해 주십시오.")
	Response.Write "<script type='text/javascript'>alert('구분자가 없습니다.'); history.back();</script>"
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->