<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : MDPICK 상품 상세 (공통)
' History : 2020-10-22 이종화
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
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
		strHeadTitleName = "MDPICK 상품 상세"
	End if
%>
<style>[v-cloak] { display: none; }</style>

<%' 상품 리스트 %>
<div id="app"></div>

<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/babel-core/5.8.34/browser.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.auto.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bodymovin/5.7.4/lottie_svg.min.js"></script>
<% IF application("Svr_Info") = "Dev" or testmode = "1" THEN %>
<script src="/vue/vue_dev.js"></script>
<% Else %>
<script src="/vue/2.5/vue.min.js"></script>
<% End If %>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>
<%'!-- common component --%>
<script src="/vue/components/common/functions/common.js?v=1.0"></script>
<script src="/vue/components/common/functions/item_mixins.js?v=1.0"></script>
<script src="/vue/components/common/functions/common_mixins.js?v=1.1"></script>
<script src="/vue/components/common/functions/modal_mixins.js?v=1.3"></script>
<script src="/vue/components/common/sortbar.js?v=1.1"></script>
<script src="/vue/components/common/wish.js?v=1.0"></script>
<script src="/vue/components/common/no_data.js?v=1.0"></script>
<script src="/vue/components/common/btn_top.js?v=1.0"></script>
<%'!-- common component --%>

<%'!-- share component --%>
<script src="/vue/components/product/prd_badge.js?v=1.0"></script>
<script src="/vue/components/product/prd_brand.js?v=1.0"></script>
<script src="/vue/components/product/prd_evaluate.js?v=1.0"></script>
<script src="/vue/components/product/prd_name.js?v=1.0"></script>
<script src="/vue/components/product/prd_price.js?v=1.0"></script>
<script src="/vue/components/product/prd_rank.js?v=1.0"></script>
<script src="/vue/components/product/prd_img.js?v=1.0"></script>
<script src="/vue/components/product/prd_more_button.js?v=1.0"></script>
<script src="/vue/components/product/prd_big_sale.js?v=1.0"></script>
<script src="/vue/components/product/prd_item_basic_product.js?v=1.0"></script>
<%'!-- share component --%>

<%'!-- ui component --%>
<script src="/vue/components/category/ctgr_nav_type2.js?v=1.0"></script>
<script src="/vue/components/search/modal_sorting.js?v=1.2"></script>
<%'!-- ui component --%>

<%'!-- store component--%>
<script src="/vue/list/store/store.js?v=1.0"></script>
<%'!-- store component--%>

<%'!-- main component--%>
<script src="/vue/list/sale/sale_detail.js?v=1.2"></script>
<%'!-- main component--%>

