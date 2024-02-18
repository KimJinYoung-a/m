<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : B2B 서머리 페이지
' History : 2021-07-01 김형태 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%

dim gnbflag
gnbflag = RequestCheckVar(request("gnbflag"),1)

If gnbflag <> "" Then '//gnb 숨김 여부
	gnbflag = true
Else
	gnbflag = False
	strHeadTitleName = "Biz Summary"
End if

%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<style>
<% If gnbflag = true Then %>
.modal_type4 .modal_wrap {height:calc(93vh - 40px);}
<% End If %>
</style>
<body class="default-font body-<%=chkiif(gnbflag,"main","sub")%>">
	<% server.Execute("/biz/exc_summary.asp") %>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>