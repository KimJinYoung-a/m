<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
'#######################################################
'	Description : 한국신용정보 Ping 정보 접수 (커넥션 정보)
'	History	:  2016.06.27 허진원 - 생성
'#######################################################
%>
<!-- #include virtual="/member/iPin/nice.nuguya.oivs.asp" -->
<%
	Response.Write getPingInfo()
%>