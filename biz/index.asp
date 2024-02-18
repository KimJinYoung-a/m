<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : B2B 메인 페이지
' History : 2021-07-01 김형태 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->

<!-- #INCLUDE Virtual="/lib/inc/head.asp" -->
<%' 메인 페이지 %>
<!-- #include virtual="/lib/inc/incHeader.asp" -->
<%
    DIM is_confirm

    is_confirm = session("ssnuserbizconfirm")
%>
<script>
    const is_confirm = "<%= is_confirm %>";
</script>
<div id="app"></div>

<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.auto.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bodymovin/5.7.4/lottie_svg.min.js"></script>
<% IF application("Svr_Info") = "Dev" THEN %>
<script src="/vue/vue_dev.js"></script>
<% Else %>
<script src="/vue/2.5/vue.min.js"></script>
<% End If %>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>

<!-- Common Component -->
	<script src="/vue/components/common/functions/common.js?v=1.0"></script>
	<script src="/vue/components/common/tab_view_type.js?v=1.0"></script>
	<script src="/vue/components/common/item_module_header.js?v=1.0"></script>
	<script src="/vue/components/common/modal.js?v=1.0"></script>
	<script src="/vue/components/common/no_data.js?v=1.0"></script>
    <script src="/vue/components/common/btn_top.js?v=1.0"></script>
	<script src="/vue/components/common/functions/item_mixins.js?v=1.1"></script>
	<script src="/vue/components/common/functions/common_mixins.js?v=1.0"></script>
<!-- //Common Component -->

<!-- Product Component -->
    <script src="/vue/components/product/prd_badge.js?v=1.0"></script>
    <script src="/vue/components/product/prd_brand.js?v=1.0"></script>
    <script src="/vue/components/product/prd_evaluate.js?v=1.0"></script>
    <script src="/vue/components/product/prd_name.js?v=1.0"></script>
    <script src="/vue/components/product/prd_price.js?v=1.0"></script>
    <script src="/vue/components/product/prd_rank.js?v=1.0"></script>
    <script src="/vue/components/product/prd_img.js?v=1.0"></script>
    <script src="/vue/components/product/prd_more_button.js?v=1.0"></script>
    <script src="/vue/components/product/prd_time.js?v=1.0"></script>
    <script src="/vue/components/product/prd_big_sale.js?v=1.0"></script>
    <script src="/vue/components/product/prd_item_basic_product.js?v=1.0"></script>
<!-- //Product Component -->

<!-- 핵심 JS -->
    <script src="/vue/biz/Home/store.js?v=1.0"></script>
    <script src="/vue/biz/Home/index.js?v=1.01"></script>
<!-- //핵심 JS -->