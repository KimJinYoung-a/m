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
' Description : 첫구매&연속구매 진입 페이지 로그
' History : 2016.03.11 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim mode, eCode, refer, sqlstr
	mode = requestcheckvar(request("mode"),5)
	ecode = requestcheckvar(request("ecode"),5)
	refer = request.ServerVariables("HTTP_REFERER")

	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "01||잘못된 접속입니다."
		dbget.close() : Response.End
	end If

	if mode="evtgo" then
		sqlstr = "update db_temp.[dbo].[tbl_event_69627]" & vbcrlf
		sqlstr = sqlstr & " set cnt = cnt+1 where" & vbcrlf
		sqlstr = sqlstr & " evt_code="& eCode &""
	
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr
	
		Response.Write "11||이벤트페이지로 이동합니다."
		dbget.close() : Response.End
	else
		Response.Write "00||정상적인 경로가 아닙니다."
		dbget.close() : Response.End
	end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->


