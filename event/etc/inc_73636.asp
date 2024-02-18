<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description :  다이어리 이벤트 팝업용
' History : 2016.10.10 유태욱
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
dim diaryurl
if isapp then
	diaryurl = "/apps/appcom/wish/web2014/"
else
	diaryurl = ""
end if
response.redirect(diaryurl&"/diarystory2017/index.asp")
%>