<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : app 70671 선물포장 랜딩페이지
' History : 2016.05.04 유태욱 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
		if isapp then
			response.redirect("/apps/appcom/wish/web2014/shoppingtoday/gift_recommend.asp")
		else
			response.redirect("/shoppingtoday/gift_recommend.asp")
		end if
%>
