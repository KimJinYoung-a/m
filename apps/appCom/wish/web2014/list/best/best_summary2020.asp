<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description : 베스트 서머리 페이지 메인
' History : 2020-10-26 이전도 생성
'####################################################
dim gnbflag : gnbflag = RequestCheckVar(request("gnbflag"),1)
If gnbflag = "1" Then '//gnb 숨김 여부
	gnbflag = true
Else
	gnbflag = False
	strHeadTitleName = "베스트 서머리"
End if
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<style>
<% If gnbflag = true Then %>
.modal_type4 .modal_wrap {height:calc(93vh - 40px);}
<% End If %>
</style>
</head>
<body class="default-font body-<%=chkiif(gnbflag,"main","sub")%>">
	<% server.Execute("/list/best/exc_best_summary.asp") %>
</body>
</html>