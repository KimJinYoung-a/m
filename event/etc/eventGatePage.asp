<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'###########################################################
' Description : ## 텐바이텐 X 도돌런처 게이트 페이지
' History : 2014.07.18 김진영
'###########################################################
Dim eCode, cnt, sqlStr

If application("Svr_Info") = "Dev" Then
	eCode   =  21244
Else
	eCode   =  53640
End If

'response.redirect wwwURL&"/event/eventmain.asp?eventid="&eCode
%>
<script>
location.replace('<%=wwwURL%>/event/eventmain.asp?eventid=<%=eCode%>');	
</script>

<!-- #include virtual="/lib/db/dbclose.asp" -->