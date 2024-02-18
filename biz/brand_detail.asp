<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : B2B 브랜드 상세 페이지
' History : 2021-06-28 김형태 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/inc/head.asp" -->
<%
	'' 기본 파라미터
    dim brand_id, view_type, sort_method
	brand_id = request("brandid") '' 브랜드ID
    view_type = request("view_type")
    if( isNull(view_type) or len(trim(view_type)) = 0 ) then
        view_type = "detail"
    end if
    sort_method = request("sort_method") '' 검색 정렬
    if( isNull(sort_method) or len(trim(sort_method)) = 0 ) then
        sort_method = "best"
    end if

    '' 꼼꼼하게 찾기 파라미터
    dim deliType : deliType = request("deliType") '' 배송/기타
    dim dispCategories : dispCategories = request("dispCategories") '' 전시 카테고리 리스트
    dim maxPrice : maxPrice = request("maxPrice") '' 최고가
    dim minPrice : minPrice = request("minPrice") '' 최저가

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
    const get_parameter_array = function(value) {
        if( value !== undefined && value !== null && value !== '' ) {
            return value.split(', ');
        } else {
            return [];
        }
    }
    // 파라미터
    const parameter = {
        brand_id : '<%=brand_id%>', // 키워드
        sort_method : '<%=sort_method%>', // 정렬
        view_type : '<%=view_type%>', // 뷰 타입
        deliType : get_parameter_array('<%=deliType%>'), // 배송/기타 - 꼼꼼하게 찾기
        dispCategories : get_parameter_array('<%=dispCategories%>'), // 카테고리 - 꼼꼼하게 찾기
        maxPrice : '<%=maxPrice%>', // 최고가
        minPrice : '<%=minPrice%>' // 최저가
    };
</script>

<%' 브랜드 상세 페이지 %>
<!-- #include virtual="/lib/inc/incHeader.asp" -->
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

<!-- Common Component -->
	<script src="/vue/components/common/functions/common.js?v=1.0"></script>
	<script src="/vue/components/common/wish.js?v=1.0"></script>
	<script src="/vue/components/common/sortbar.js?v=1.0"></script>
	<script src="/vue/components/common/tab_view_type.js?v=1.0"></script>
	<script src="/vue/components/common/item_module_header.js?v=1.0"></script>
	<script src="/vue/components/common/modal.js?v=1.0"></script>
	<script src="/vue/components/common/no_data.js?v=1.0"></script>
    <script src="/vue/components/common/btn_top.js?v=1.0"></script>
	<script src="/vue/components/common/functions/item_mixins.js?v=1.1"></script>
	<script src="/vue/components/common/functions/modal_mixins.js?v=1.0"></script>
	<script src="/vue/components/common/functions/common_mixins.js?v=1.0"></script>
<!-- //Common Component -->

<!-- Search Component -->
    <script src="/vue/components/search/modal_sorting.js?v=1.1"></script>
<!-- //Search Component -->

<!-- Product Component -->
    <script src="/vue/components/biz/product/modal_filter.js?v=1.0"></script>
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
    <script src="/vue/components/biz/product/prd_item_photo2.js?v=1.0"></script>
    <script src="/vue/components/biz/product/prd_list_photo2.js?v=1.0"></script>
<!-- //Product Component -->

<!-- 핵심 JS -->
    <script src="/vue/biz/Brand/store.js?v=1.0"></script>
    <script src="/vue/biz/Brand/index.js?v=1.01"></script>
<!-- //핵심 JS -->