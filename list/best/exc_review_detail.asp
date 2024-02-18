<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 베스트셀러 상품 상세 (공통)
' History : 2020-10-15 이종화
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
		strHeadTitleName = "베스트 셀러"
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
<script src="/vue/components/common/functions/modal_mixins.js?v=1.0"></script>
<script src="/vue/components/common/functions/common_mixins.js?v=1.1"></script>
<script src="/vue/components/common/no_data.js?v=1.0"></script>
<script src="/vue/components/common/wish.js?v=1.0"></script>
<script src="/vue/components/common/tgl_type1.js?v=1.0"></script>
<script src="/vue/components/common/tab_view_type.js?v=1.0"></script>
<script src="/vue/components/common/btn_top.js?v=1.0"></script>
<%'!-- common component --%>

<!-- Product Components -->
<script src="/vue/components/product/prd_img.js?v=1.0"></script>
<script src="/vue/components/product/prd_price.js?v=1.0"></script>
<script src="/vue/components/product/prd_name.js?v=1.0"></script>
<script src="/vue/components/product/prd_list_grid1.js?v=1.0"></script>
<script src="/vue/components/product/prd_item_photo.js?v=1.0"></script>
<script src="/vue/components/product/prd_slider_type1.js?v=1.0"></script>
<!-- //Product Components -->

<%'!-- share component --%>
<script src="/vue/components/review/rv_list_type1.js?v=1.0"></script>
<script src="/vue/components/review/rv_info.js?v=1.0"></script>
<script src="/vue/components/review/rv_list_this_item.js?v=1.0"></script>
<script src="/vue/components/review/rv_list_type2.js?v=1.0"></script>
<script src="/vue/components/review/rv_list_type2_photo.js?v=1.0"></script>
<%'!-- share component --%>

<%'!-- ui component --%>
<script src="/vue/components/category/ctgr_nav_type2.js?v=1.0"></script>
<%'!-- ui component --%>

<%'!-- store component--%>
<script src="/vue/list/store/store.js?v=1.0"></script>
<%'!-- store component--%>

<%'!-- main component--%>
<script src="/vue/list/best/review_detail.js?v=1.0"></script>
<%'!-- main component--%>

