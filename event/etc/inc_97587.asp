<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<% '// 해당 이벤트 페이지는 사용하지 않고 리다이렉트 시킨다. %>
<script>
$(function(){
    <% If isapp="1" Then %>
        document.location.href='<%=wwwUrl%>/apps/appCom/wish/web2014/event/18th/?gnbflag=1';
        return false;
    <% Else %>
        document.location.href='<%=wwwUrl%>/event/18th/?gnbflag=1';
        return false;
    <% End If %>
});
</script>
</head>
<%
    If isApp="1" Then
        response.redirect wwwUrl&"/apps/appCom/wish/web2014/event/18th/?gnbflag=1"
        response.end
    Else
        response.redirect wwwUrl&"/event/18th/?gnbflag=1"
        response.end
    End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->