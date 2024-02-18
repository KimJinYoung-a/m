<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 제휴몰 쿠차(coocha) 타고 들어 올경우 레이어 처리
' History : 2015.09.01 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
Dim mode, gourl, sqlStr, AssignedRow
	mode = requestcheckvar(request("mode"),32)
	gourl = requestcheckvar(request("gourl"),256)

If mode = "expires_y" Then
	response.Cookies("coocha").domain = "10x10.co.kr"
	response.cookies("coocha")("mode") = "expires_y"
	response.cookies("coocha").Expires = Date + 1

End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->