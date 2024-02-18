<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description : 애플전용관
' History : 2020-04-20 이종화 생성
'####################################################
dim gnbflag : gnbflag = RequestCheckVar(request("gnbflag"),1)
dim category : category = RequestCheckVar(request("category"),2)
If gnbflag = "1" Then '//gnb 숨김 여부
	gnbflag = true 
Else 
	gnbflag = False
    strHeadTitleName = "Apple"
End if
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script>
setTimeout(function() {
    fnAPPchangPopCaption('<%=strHeadTitleName%>');
},300)

var isApp = true;
var categoryId = "<%=category%>";
</script>
<body class="default-font body-<%=chkiif(gnbflag,"main","sub")%>">
    <% server.Execute("/event/apple/exc_list.asp") %>
    <!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>