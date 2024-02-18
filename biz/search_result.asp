<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 검색 상품 리스트
' History : 2021-06-29 이전도 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/inc/head.asp" -->
<%
	Dim keyword, sortMethod, page, viewType
    keyword = request("keyword") '' 키워드
    If keyword = "" Then
        Response.Redirect "/"
    End If

    sortMethod = RequestCheckVar(request("sortMethod"),4) '' 정렬
    If sortMethod = "" THen
        sortMethod = "best"
    End If

    page = request("page")
    If page = "" Then
        page = 1
    End If

    '' 꼼꼼하게 찾기 파라미터
    Dim deliType : deliType = request("deliType") '' 배송/기타
	dim dispCategories : dispCategories = request("dispCategories") '' 전시 카테고리 리스트
    Dim makerIds : makerIds = request("makerIds") '' 브랜드 리스트
    Dim maxPrice : maxPrice = request("maxPrice") '' 최고가
    Dim minPrice : minPrice = request("minPrice") '' 최저가

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
    // 파라미터
    const parameter = {
        keyword : '<%=keyword%>', // 키워드
        sort_method : '<%=sortMethod%>', // 정렬
        deliType : get_parameter_array('<%=deliType%>'), // 배송/기타 - 꼼꼼하게 찾기
        dispCategories : get_parameter_array('<%=dispCategories%>'), // 카테고리 - 꼼꼼하게 찾기
        makerIds : get_parameter_array('<%=makerIds%>'), // 브랜드 - 꼼꼼하게 찾기
        maxPrice : '<%=maxPrice%>', // 최고가
        minPrice : '<%=minPrice%>', // 최저가
        page : '<%=page%>' // 페이지
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

<!-- Common Components -->
<script src="/vue/components/common/functions/common.js?v=1.0"></script>
<script src="/vue/components/common/functions/common_mixins.js?v=1.0"></script>
<script src="/vue/components/common/functions/item_mixins.js?v=1.1"></script>
<script src="/vue/components/common/functions/search_mixins.js?v=1.0"></script>
<script src="/vue/components/common/functions/modal_mixins.js?v=1.0"></script>

<script src="/vue/components/common/modal.js?v=1.0"></script>
<script src="/vue/components/common/sortbar.js?v=1.0"></script>
<script src="/vue/components/common/wish.js?v=1.0"></script>
<script src="/vue/components/common/pagination.js?v=1.0"></script>
<script src="/vue/components/common/no_data.js?v=1.0"></script>
<!-- //Common Components -->

<!-- Search Components -->
<script src="/vue/components/search/searchbar.js?v=1.0"></script>
<script src="/vue/components/search/modal_sorting.js?v=1.0"></script>
<!-- //Search Components -->

<!-- Product Components -->
<script src="/vue/components/product/prd_big_sale.js?v=1.0"></script>
<script src="/vue/components/product/prd_item_basic_product.js?v=1.0"></script>
<script src="/vue/components/product/prd_rank.js?v=1.0"></script>
<script src="/vue/components/product/prd_img.js?v=1.0"></script>
<script src="/vue/components/product/prd_price.js?v=1.0"></script>
<script src="/vue/components/product/prd_name.js?v=1.0"></script>
<script src="/vue/components/product/prd_brand.js?v=1.0"></script>
<script src="/vue/components/product/prd_badge.js?v=1.0"></script>
<script src="/vue/components/product/prd_evaluate.js?v=1.0"></script>
<script src="/vue/components/product/prd_more_button.js?v=1.0"></script>
<script src="/vue/components/product/modal_filter.js?v=1.0"></script>
<!-- //Product Components -->

<!-- Core -->
<script src="/vue/biz/Search/store.js?v=1.00"></script>
<script src="/vue/biz/Search/index.js?v=1.01"></script>
<!-- //Core -->
<!-- #include virtual="/lib/db/dbclose.asp" -->