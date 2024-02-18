<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/login/checklogin.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
    dim tab : tab = request("tab")
    if tab = "" then tab = "1"
%>
<body class="default-font body-sub">    
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">			
            <!-- contents -->
            <div id="content" class="content <%=chkIIF(tab = 2, "giftcard-history", "")%>">
                <div class="nav nav-stripe nav-stripe-default nav-stripe-red">
                    <ul class="grid2">
                        <li><a href="?tab=1" class="<%=chkIIF(tab = 1, "on","" )%>">주문 내역</a></li>
                        <li><a href="?tab=2" class="<%=chkIIF(tab = 2, "on","" )%>">등록 내역</a></li>
                    </ul>
                </div>
                <% 
                if tab = "1" then 
                    server.Execute("/my10x10/giftcard/exec/orderList_exec.asp")    
                else 
                    server.Execute("/my10x10/giftcard/exec/regList_exec.asp")    
                end if 
                %>
            </div>            
		</div>
	</div>
</div>
    <!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>