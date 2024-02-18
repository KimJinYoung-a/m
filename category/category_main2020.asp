<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 카테고리 메인 페이지
' History : 2020-10-21 이전도 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
	Dim categoryCode, sortMethod, page, viewType
	categoryCode = RequestCheckVar(request("disp"),3) '' 카테고리코드
	viewType = request("viewType")
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

	dim gnbflag , testmode, defaultAPIURL
	gnbflag = RequestCheckVar(request("gnbflag"),1)
	testmode = RequestCheckVar(request("testmode"),1)

	'// pc일경우 m -> pc 리다이렉트
	Dim redirect_url : redirect_url = fnRedirectToPc()
	If redirect_url <> "" Then
		Response.redirect redirect_url & "/shopping/category_list.asp?disp=" + categoryCode
		Response.end
	End If

	If gnbflag <> "" Then '//gnb 숨김 여부
		gnbflag = true
	Else
		gnbflag = False
		strHeadTitleName = "헤더"
	End if

    '//크리테오에 보낼 md5 유저 이메일값
    If Trim(session("ssnuseremail")) <> "" Then
        CriteoUserMailMD5 = MD5(Trim(session("ssnuseremail")))
    Else
        CriteoUserMailMD5 = ""
    End If
%>
<script src="/vue/components/common/functions/search.js?v=1.0"></script>
<script>
    const parameter = {
            category_code: '<%=categoryCode%>',
            view_type : '<%=viewType%>', // 뷰 타입
            sort_method: '<%=sortMethod%>',
            page: <%=page%>,
            deliType : get_parameter_array('<%=deliType%>'), // 배송/기타 - 꼼꼼하게 찾기
            makerIds : get_parameter_array('<%=makerIds%>'), // 브랜드 - 꼼꼼하게 찾기
            minPrice: '<%=minPrice%>', // 최저가
            maxPrice: '<%=maxPrice%>' // 최고가
    };
    const criteo_user_mail_md5 = '<%=CriteoUserMailMD5%>';
</script>

<%' 키워드 검색결과 페이지 %>
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

<!-- Criteo 카테고리/리스팅 태그 -->
<script type="text/javascript" src="//static.criteo.net/js/ld/ld.js" async="true"></script>
<!-- END 카테고리/리스팅 태그 -->

<!-- Common Component -->
	<script src="/vue/components/common/functions/common.js?v=1.1"></script>
	<script src="/vue/components/common/wish.js?v=1.0"></script>
	<script src="/vue/components/common/tab_type1.js?v=1.0"></script>
	<script src="/vue/components/common/modal2.js?v=1.0"></script>
	<script src="/vue/components/common/btn_top.js?v=1.0"></script>
	<script src="/vue/components/common/sortbar.js?v=1.0"></script>
	<script src="/vue/components/common/tab_view_type.js?v=1.0"></script>
	<script src="/vue/components/common/pagination.js?v=1.0"></script>
	<script src="/vue/components/common/no_data.js?v=1.0"></script>
	<script src="/vue/components/common/functions/item_mixins.js?v=1.3"></script>
	<script src="/vue/components/common/functions/modal_mixins.js?v=1.0"></script>
	<script src="/vue/components/common/functions/common_mixins.js?v=1.1"></script>
<!-- //Common Component -->

<!-- Category Component -->
	<script src="/vue/components/category/ctgr_nav_type1.js?v=1.2"></script>
	<script src="/vue/components/category/row_category.js?v=1.0"></script>
	<script src="/vue/components/category/explorer.js?v=1.1"></script>
	<script src="/vue/components/category/contents/contents.js?v=1.0"></script>
	<script src="/vue/components/category/contents/banners.js?v=1.0"></script>
	<script src="/vue/components/category/contents/exhibitions.js?v=1.0"></script>
	<script src="/vue/components/category/contents/brand.js?v=1.0"></script>
	<script src="/vue/components/category/contents/viewer.js?v=1.1"></script>
<!-- //Category Component -->

<!-- Event Component -->
	<script src="/vue/components/event/evt_list_md.js?v=1.0"></script>
	<script src="/vue/components/event/evt_img.js?v=1.0"></script>
	<script src="/vue/components/event/evt_info.js?v=1.0"></script>
<!-- //Event Component -->

<!-- Brand Component -->
	<script src="/vue/components/brand/brd_set_type1.js?v=1.1"></script>
<!-- //Brand Component -->

<!-- Product Component -->
	<script src="/vue/components/product/prd_list_photo2.js?v=1.0"></script>
    <script src="/vue/components/product/prd_big_sale.js?v=1.0"></script>
	<script src="/vue/components/product/prd_item_basic_product.js?v=1.0"></script>
	<script src="/vue/components/product/prd_item_photo.js?v=1.0"></script>
	<script src="/vue/components/product/prd_item_photo2.js?v=1.0"></script>
	<script src="/vue/components/product/prd_img.js?v=1.0"></script>
	<script src="/vue/components/product/prd_list_grid2.js?v=1.1"></script>
	<script src="/vue/components/product/modal_filter.js?v=1.0"></script>
	<script src="/vue/components/product/prd_time.js?v=1.0"></script>
    <script src="/vue/components/product/prd_rank.js?v=1.0"></script>
    <script src="/vue/components/product/prd_price.js?v=1.0"></script>
    <script src="/vue/components/product/prd_name.js?v=1.0"></script>
    <script src="/vue/components/product/prd_brand.js?v=1.0"></script>
    <script src="/vue/components/product/prd_badge.js?v=1.0"></script>
    <script src="/vue/components/product/prd_evaluate.js?v=1.0"></script>
    <script src="/vue/components/product/prd_more_button.js?v=1.0"></script>
<!-- //Product Component -->

<!-- Search Component -->
	<script src="/vue/components/search/modal_sorting.js?v=1.0"></script>
<!-- //Search Component -->

<!-- 핵심 JS -->
<script src="/vue/category/Main/wonder.js?v=1.02"></script>
<script src="/vue/category/Main/store.js?v=1.17"></script>
<script src="/vue/category/Main/index.js?v=1.28"></script>
<!-- //핵심 JS -->