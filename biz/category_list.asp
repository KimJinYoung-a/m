<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : Biz 카테고리 상품 리스트
' History : 2021-06-28 이전도 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
	Dim categoryCode, sortMethod, page, viewType
    categoryCode = requestCheckVar(request("disp"),6) '' 카테고리코드
    If categoryCode = "" Then
        categoryCode = "0"
    End If

    viewType = request("viewType") '' 뷰타입
    If viewType = "" Then
        viewType = "detail"
    End If

    sortMethod = RequestCheckVar(request("sortMethod"),4) '' 정렬
    If sortMethod = "" THen
        sortMethod = getDefaultSortMethod(categoryCode)
    End If

    page = request("page")
    If page = "" Then
        page = 1
    End If

    '' 꼼꼼하게 찾기 파라미터
    Dim deliType : deliType = request("deliType") '' 배송/기타
    Dim makerIds : makerIds = request("makerIds") '' 브랜드 리스트
    Dim maxPrice : maxPrice = request("maxPrice") '' 최고가
    Dim minPrice : minPrice = request("minPrice") '' 최저가

    '// Get 기본 정렬값
    Function getDefaultSortMethod(categoryCode)
        If Left(categoryCode,3) = "101" Then
            getDefaultSortMethod = "new"
        Else
            getDefaultSortMethod = "best"
        End If
    End Function

	dim gnbflag
	gnbflag = RequestCheckVar(request("gnbflag"),1)

	If gnbflag <> "" Then '//gnb 숨김 여부
		gnbflag = true
	Else
		gnbflag = False
		strHeadTitleName = "헤더"
	End if
%>

<script src="/vue/components/common/functions/search.js?v=1.0"></script>
<script>
    const parameter = {
            disp: '<%=categoryCode%>',
            view_type : '<%=viewType%>', // 뷰 타입
            sort_method: '<%=sortMethod%>',
            page: Number('<%=page%>'),
            deliType : get_parameter_array('<%=deliType%>'), // 배송/기타 - 꼼꼼하게 찾기
            makerIds : get_parameter_array('<%=makerIds%>'), // 브랜드 - 꼼꼼하게 찾기
            minPrice: '<%=minPrice%>', // 최저가
            maxPrice: '<%=maxPrice%>' // 최고가
    };
</script>

<!-- #include virtual="/lib/inc/incHeader.asp" -->
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
	<script src="/vue/components/common/wish.js?v=1.0"></script>
	<script src="/vue/components/common/sortbar.js?v=1.0"></script>
	<script src="/vue/components/common/tab_view_type.js?v=1.0"></script>
	<script src="/vue/components/common/modal2.js?v=1.0"></script>
	<script src="/vue/components/common/pagination.js?v=1.0"></script>
	<script src="/vue/components/common/no_data.js?v=1.0"></script>
    <script src="/vue/components/common/btn_top.js?v=1.0"></script>
	<script src="/vue/components/common/functions/item_mixins.js?v=1.1"></script>
	<script src="/vue/components/common/functions/modal_mixins.js?v=1.0"></script>
	<script src="/vue/components/common/functions/search_mixins.js?v=1.0"></script>
	<script src="/vue/components/common/functions/common_mixins.js?v=1.0"></script>
<!-- //Common Component -->

<!-- Product Component -->
	<script src="/vue/components/product/prd_list_photo2.js?v=1.0"></script>
    <script src="/vue/components/product/prd_big_sale.js?v=1.0"></script>
	<script src="/vue/components/product/prd_item_basic_product.js?v=1.0"></script>
	<script src="/vue/components/product/prd_item_photo2.js?v=1.0"></script>
    <script src="/vue/components/product/prd_time.js?v=1.0"></script>
    <script src="/vue/components/product/prd_rank.js?v=1.0"></script>
    <script src="/vue/components/product/prd_img.js?v=1.0"></script>
    <script src="/vue/components/product/prd_price.js?v=1.0"></script>
    <script src="/vue/components/product/prd_name.js?v=1.0"></script>
    <script src="/vue/components/product/prd_brand.js?v=1.0"></script>
    <script src="/vue/components/product/prd_badge.js?v=1.0"></script>
    <script src="/vue/components/product/prd_evaluate.js?v=1.0"></script>
    <script src="/vue/components/product/prd_more_button.js?v=1.0"></script>
    <script src="/vue/components/product/modal_filter.js?v=1.0"></script>
<!-- //Product Component -->

<!-- Etc Component -->
	<script src="/vue/components/biz/cate_swiper.js?v=1.0"></script>
	<script src="/vue/components/biz/cate_swiper2.js?v=1.0"></script>
	<script src="/vue/components/search/modal_sorting.js?v=1.0"></script>
<!-- //Etc Component -->

<!-- 핵심 JS -->
<script src="/vue/biz/Category/store.js?v=1.000"></script>
<script src="/vue/biz/Category/index.js?v=1.001"></script>
<!-- //핵심 JS -->
<!-- #include virtual="/lib/db/dbclose.asp" -->