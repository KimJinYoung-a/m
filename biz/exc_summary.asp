<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : B2B 서머리 페이지
' History : 2021-07-01 김형태 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	dim gnbflag , testmode
	gnbflag = RequestCheckVar(request("gnbflag"),1)
	testmode = RequestCheckVar(request("testmode"),1)

	If gnbflag <> "" Then '//gnb 숨김 여부
    	gnbflag = true
    Else
    	gnbflag = False
    	strHeadTitleName = "Biz Summary"
    End if
%>

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
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js"></script>

<!-- Common Component -->
	<script src="/vue/components/common/functions/common.js?v=1.0"></script>
	<script src="/vue/components/common/tab_view_type.js?v=1.0"></script>
	<script src="/vue/components/common/item_module_header.js?v=1.0"></script>
	<script src="/vue/components/common/modal.js?v=1.0"></script>
	<script src="/vue/components/common/no_data.js?v=1.0"></script>
    <script src="/vue/components/common/btn_top.js?v=1.0"></script>
	<script src="/vue/components/common/functions/item_mixins.js?v=1.0"></script>
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
    <script src="/vue/bizSummary/store.js?v=1.0"></script>
    <script src="/vue/bizSummary/index.js?v=1.0"></script>
<!-- //핵심 JS -->

<!-- #include virtual="/lib/db/dbclose.asp" -->