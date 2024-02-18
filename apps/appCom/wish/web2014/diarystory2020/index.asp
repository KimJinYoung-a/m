<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 다이어리스토리 2020 메인페이지
' History : 2019-08-29 최종원 생성
'####################################################
%>
<%
dim i, weekDate, imglink, gnbflag

gnbflag = RequestCheckVar(request("gnbflag"),1)

If gnbflag = "1" Then '//gnb 숨김 여부
	gnbflag = true 
Else 
	gnbflag = False
	strHeadTitleName = "2020 다이어리"
End if
	
IF application("Svr_Info") = "Dev" THEN
	imglink = "testimgstatic"
Else
	imglink = "imgstatic"
End If
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<body class="default-font body-<%=chkiif(gnbflag,"main","sub")%> diary2020">
    <% server.Execute("/diarystory2020/inc/main/main_exec.asp") %>
    <!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->