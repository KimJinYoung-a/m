<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description : 가정의달 2021
' History : 2020-04-06 김형태 생성
'####################################################
dim gnbflag : gnbflag = RequestCheckVar(request("gnbflag"),1)
If gnbflag = "1" Then '//gnb 숨김 여부
	gnbflag = true 
Else 
	gnbflag = False
	strHeadTitleName = "가정의 달"
End if
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script>
    $(function() {
        $(window).on('scroll', function(e) {
            var st = $(window).scrollTop();
            var tit = $('.family2021 .tab-wrap h3');
            if (st + $(window).height() * .5 >= tit.offset().top) {
                tit.addClass('on');
            }
        });
    });
</script>
</head>
<body class="default-font body-<%=chkiif(gnbflag,"main","sub")%>">
    <!-- contents -->
    <div id="content" class="content">
        <% server.Execute("/event/family2021/exec.asp") %>
    </div>
    <!-- //contents -->
</body>
</html>