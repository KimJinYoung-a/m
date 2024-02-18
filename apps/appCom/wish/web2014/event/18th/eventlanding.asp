<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 18주년 메인 취향 이벤트 랜딩 페이지
' History : 2019-09-23 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script>
    $(function(){
        setTimeout(function () {
            callmain();
            fnAPPselectGNBMenuWithTop('taste');
        }, 1000);        
    });
</script>