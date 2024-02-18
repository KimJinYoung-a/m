<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 다이어리스토리 2019 메인페이지
' History : 2018-08-30 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/diarystory2019/lib/worker_only_view.asp" -->
<!-- #include virtual="/diarystory2019/lib/classes/diary_class_B.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
    dim gnbflag : gnbflag = RequestCheckVar(request("gnbflag"),1)
    
    If gnbflag <> "" Then '//gnb 숨김 여부
        gnbflag = true 
    Else 
        gnbflag = False
        strHeadTitleName = "다이어리 스토리"
    End if
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/diary2019.css?v=1.01" />
<body class="default-font body-<%=chkiif(gnbflag,"main","sub")%> diary2019">
	<div id="content" class="content diary-search">
        <!-- #include virtual="/diarystory2019/sub/search_items.asp" -->
	</div>
	<!-- #include virtual="/apps/appcom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->