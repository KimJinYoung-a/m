<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 
' History : 2016.12.02 유태욱
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
if isapp then
	response.redirect("/apps/appcom/wish/web2014/event/eventmain.asp?eventid=74704")
else
	response.redirect("/event/eventmain.asp?eventid=74704")
end if
%>
