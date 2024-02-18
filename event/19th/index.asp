<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'###########################################################
' Description : 19주년 10월 이벤트 메인
' History : 2020-09-14 원승현
'###########################################################
%>
<%
    Dim gnbflag : gnbflag = RequestCheckVar(request("gnbflag"),1) '// gnb사용여부

    If gnbflag = "" Then '// gnb 표시여부
        gnbflag = False
        strHeadTitleName = "이벤트"	
    Else
        gnbflag = true
        strHeadTitleName = ""
    End if        
%>
<!-- #include virtual="/lib/inc/head.asp" -->
</head>
<body class="default-font body-<%=chkiif(gnbflag,"main","sub")%> bg-grey">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->	
	<div id="content" class="content">
		<div class="evtContV15">
            <% server.Execute("/event/19th/index_exc.asp") %>
        </div>
	</div>	
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->