<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
%>
<%
'####################################################
' Description : 텐바이텐 카드 발급
' History : 2015-06-03 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_tenCardCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
	dim userid
		userid = getEncLoginUserID
	
	If userid <> "" Then 
		call fnGetTenTenCardNo(userid)
	End If 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->



