<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  APP 스페셜 브랜드
' History : 2019-08-09 최종원 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
</head>
<%
dim debugMode

debugMode = request("debugMode")
%>
<link rel="stylesheet" type="text/css" href="/lib/css/pb.css?v=1.05">
    <script>    
    function playBrandRolling() {
        var brandRolling = new Swiper(".brand-rolling .swiper-container", {
            paginationClickable:true,
            pagination:'.brand-rolling .pagination',
            autoplay:3000,
            loop:true,
            speed:1000
        });
    }    
    </script>
<script type="text/javascript">
var isapp = '<%=isapp%>'
var debugMode = '<%=debugMode%>'    
</script>
<body class="default-font body-sub pbV19">
	<!-- contents -->
	<div id="content" class="content">
        <div id="app"></div>
	</div>
    <!-- //contents -->
    <!-- 뷰 -->
	<% IF application("Svr_Info") = "Dev" or debugMode = 1 THEN %>
	<script src="/vue/vue_dev.js"></script>
	<% Else %>
	<script src="/vue/vue.min.js"></script>
	<% End If %>
	<script src="/vue/vue.lazyimg.min.js"></script>
    <!--컴포넌트-->
    <script src="/vue/specialbrand/pb-brand-container.js"></script>     
    <script src="/vue/specialbrand/pb-brand-list.js?v=1.01"></script>     
    <script src="/vue/specialbrand/pb-event-list.js"></script>    
    <script src="/vue/specialbrand/pb-main-rolling.js?v=1.03"></script>    
    <script src="/vue/specialbrand/pb-items.js?v=1.01"></script>    
    <script src="/vue/specialbrand/pb-reviews.js"></script>    
    <script src="/vue/specialbrand/pb-contents-container.js"></script>        
    <!-- 뷰 인스턴스 -->
    <script src="/vue/specialbrand/index.js"></script>    
    <!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->