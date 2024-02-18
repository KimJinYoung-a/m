<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : SALE 서머리 페이지 메인
' History : 2020-10-28 이전도 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	dim gnbflag , testmode, defaultAPIURL
	gnbflag = RequestCheckVar(request("gnbflag"),1)
	testmode = RequestCheckVar(request("testmode"),1)

	If gnbflag <> "" Then '//gnb 숨김 여부
		gnbflag = true
	Else
		gnbflag = False
		strHeadTitleName = "헤더"
	End if

%>

<script>
    const user_name = '<%=GetLoginUserName%>';
</script>
<style>[v-cloak] { display: none; }</style>

<div id="app"></div>

<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
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

<!-- Common Components -->
<script src="/vue/components/common/functions/common.js?v=1.0"></script>
<script src="/vue/components/common/functions/item_mixins.js?v=1.0"></script>
<script src="/vue/components/common/functions/common_mixins.js?v=1.1"></script>
<script src="/vue/components/common/wish.js?v=1.1"></script>
<script src="/vue/components/common/btn_top.js?v=1.0"></script>
<!-- //Common Components -->

<!-- Category Components -->
<script src="/vue/components/category/ctgr_nav_type2.js?v=1.0"></script>
<!-- //Category Components -->

<!-- Product Components -->
<script src="/vue/components/product/prd_slider_type3.js?v=1.0"></script>
<script src="/vue/components/product/prd_slider_type1.js?v=1.0"></script>
<script src="/vue/components/product/prd_list_basic.js?v=1.0"></script>
<script src="/vue/components/product/prd_item_basic.js?v=1.0"></script>
<script src="/vue/components/product/prd_time.js?v=1.0"></script>
<script src="/vue/components/product/prd_rank.js?v=1.0"></script>
<script src="/vue/components/product/prd_price.js?v=1.0"></script>
<script src="/vue/components/product/prd_name.js?v=1.0"></script>
<script src="/vue/components/product/prd_brand.js?v=1.0"></script>
<script src="/vue/components/product/prd_badge.js?v=1.0"></script>
<script src="/vue/components/product/prd_evaluate.js?v=1.0"></script>
<script src="/vue/components/product/prd_more_button.js?v=1.0"></script>
<script src="/vue/components/product/prd_img.js?v=1.0"></script>
<script src="/vue/components/product/prd_list_grid1.js?v=1.0"></script>
<script src="/vue/components/product/prd_item_photo.js?v=1.0"></script>
<!-- //Product Components -->

<!-- Core -->
<script src="/vue/list/sale/summary_store.js?v=1.0"></script>
<script src="/vue/list/sale/summary.js?v=1.5"></script>
<!-- //Core -->