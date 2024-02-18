<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 다이어리스토리 2019 검색페이지
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
    strHeadTitleName = "다이어리 찾기"
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/diary2019.css?v=1.04" /> 
<script type="text/javascript">
$(document).ready(function(){
	fnAmplitudeEventMultiPropertiesAction('view_diary_search','','');		
});
</script>
<body class="default-font body-sub diary2019">
    <!-- #include virtual="/lib/inc/incHeader.asp" -->
	<div id="content" class="content diary-search">
        <!-- #include virtual="/diarystory2019/sub/search_items.asp" -->
	</div>
	<!-- #include virtual="/lib/inc/incfooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->