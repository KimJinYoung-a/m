<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
	'해더 타이틀
	strHeadTitleName = "기프트카드"

    dim tab : tab = request("tab")
    if tab = "" then tab = "1"
%>
<script type="text/javascript">

</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
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
            <!-- //contents -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>