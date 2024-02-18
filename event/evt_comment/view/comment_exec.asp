<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  미디어 플랫폼 상세 실행페이지
' History : 2019-05-21 최종원 생성
'####################################################
dim testMode

testMode = request("testMode")
%>
<!-- #include virtual="/lib/inc_const.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/platform.css?v=2.00">
<script>
$(function() {
	$(".header-sub h1").text("댓글");
});
isapp = '<%=isapp%>'
</script>
<!-- content area -->
<div id="content" class="content pop-reply">
    <div id="app"></div>
</div>
<% IF application("Svr_Info") = "Dev" or testMode = 1 THEN %>
<script src="/vue/vue_dev.js"></script>
<% Else %>
<script src="/vue/vue.min.js"></script>
<% End If %>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/event/evt_comment/script/comment-form.js"></script>
<script src="/event/evt_comment/script/comment-list.js"></script>
<script src="/event/evt_comment/script/index.js"></script>
<!-- //content area -->
