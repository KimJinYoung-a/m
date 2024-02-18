<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 상품 검색 결과 페이지 메인
' History : 2020-10-16 이전도 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
    '' 기본 파라미터
	dim keyword, view_type, sort_method, page
	keyword = requestCheckVar(request("keyword"), 100) '' 검색 키워드
	view_type = request("view_type")
	if( isNull(view_type) or len(trim(view_type)) = 0 ) then
	    view_type = "detail"
	end if
	sort_method = request("sort_method") '' 검색 정렬
	if( isNull(sort_method) or len(trim(sort_method)) = 0 ) then
	    sort_method = "best"
	end if
	page = request("page") '' 페이지
	if( isNull(page) or len(trim(page)) = 0 ) then
	    page = "1"
	end if

    '' 꼼꼼하게 찾기 파라미터
	dim deliType : deliType = request("deliType") '' 배송/기타
	dim dispCategories : dispCategories = request("dispCategories") '' 전시 카테고리 리스트
	dim makerIds : makerIds = request("makerIds") '' 브랜드 리스트
	dim maxPrice : maxPrice = request("maxPrice") '' 최고가
	dim minPrice : minPrice = request("minPrice") '' 최저가

	' 교정무시 키워드
	Dim correct_keyword : correct_keyword = request("correct_keyword")
	

	dim gnbflag , testmode, defaultAPIURL
	gnbflag = RequestCheckVar(request("gnbflag"),1)
	testmode = RequestCheckVar(request("testmode"),1)

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

	'// Git Test - exc_search_product.asp
%>
<script src="/vue/components/common/functions/search.js?v=1.0"></script>
<script>
    // 파라미터
    const parameter = {
        keyword : '<%=keyword%>', // 키워드
        sort_method : '<%=sort_method%>', // 정렬
        view_type : '<%=view_type%>', // 뷰 타입
        deliType : get_parameter_array('<%=deliType%>'), // 배송/기타 - 꼼꼼하게 찾기
        dispCategories : get_parameter_array('<%=dispCategories%>'), // 카테고리 - 꼼꼼하게 찾기
        makerIds : get_parameter_array('<%=makerIds%>'), // 브랜드 - 꼼꼼하게 찾기
        maxPrice : '<%=maxPrice%>', // 최고가
        minPrice : '<%=minPrice%>', // 최저가
        page : '<%=page%>', // 페이지
		correct_keyword : '<%=correct_keyword%>' // 교정무시 키워드
	};
    const criteo_user_mail_md5 = '<%=CriteoUserMailMD5%>';
    const is_user_adult = '<%=ChkIif(Session("isAdult"), "Y", "N")%>';
</script>
<%' 최근검색어 저장 & JS변수(tenRecentKeywords)로 할당 %>
<!-- #include virtual="/search/recent_keywords.asp" -->

<%' 키워드 검색결과 페이지 %>
<!-- #include virtual="/lib/inc/incHeader.asp" -->
<div id="app"></div>
<svg xmlns="http://www.w3.org/2000/svg" class="defs">
	<defs>
		<mask id="shape1"><circle cx="375" cy="375" r="375"/></mask>
		<mask id="shape2"><path d="M750 375c-42.453 183.663-191.341 332.547-375 375C191.337 707.547 42.453 558.663 0 375 42.453 191.337 191.337 42.453 375 0c183.659 42.453 332.547 191.337 375 375"/></mask>
		<mask id="shape3"><path d="M508.333 695.001c-73.335 73.332-193.332 73.332-266.667 0L55 508.332C-18.334 435-18.334 315 55.001 241.668l186.665-186.67c73.335-73.33 193.332-73.33 266.667 0l186.668 186.67c73.332 73.332 73.332 193.332 0 266.664l-186.668 186.67z"/></mask>
		<mask id="shape4"><path d="M0 375c0-91.371 112.35-142.897 172.228-202.772C232.103 112.349 283.628 0 375 0c91.371 0 142.897 112.35 202.772 172.228C637.651 232.103 750 283.628 750 375c0 91.371-112.35 142.897-172.228 202.772C517.897 637.651 466.372 750 375 750c-91.371 0-142.897-112.35-202.772-172.228C112.349 517.897 0 466.372 0 375"/></mask>
		<mask id="shape5"><path d="M375 0C167.893 0 0 167.893 0 375v296.533C0 714.869 35.131 750 78.467 750H375c207.107 0 375-167.893 375-375S582.107 0 375 0z"/></mask>
		<mask id="shape6"><path d="M150.84 599.158c-201.12-101.497-201.12-346.818 0-448.319 101.5-201.119 346.821-201.119 448.318 0 201.123 101.5 201.123 346.822 0 448.319-101.497 201.123-346.818 201.123-448.319 0z"/></mask>
		<mask id="shape7"><path d="M750 375c0 28.366-27.8 53.152-33.7 79.677-6.087 27.407 8.3 62.036-3.362 86.758-11.863 25.132-47.425 35.154-64.275 56.731-16.938 21.693-18.638 59.352-39.85 76.673-21.1 17.231-57.363 10.597-81.925 22.715-24.176 11.94-41.638 45.176-68.426 51.401-25.95 6.034-55.724-16.03-83.462-16.03-27.738 0-57.512 22.064-83.462 16.03-26.788-6.225-44.25-39.461-68.425-51.4-24.576-12.119-60.838-5.485-81.938-22.716-21.2-17.321-22.9-54.993-39.838-76.673-16.85-21.59-52.412-31.612-64.275-56.73-11.662-24.723 2.738-59.352-3.362-86.76C27.8 428.153 0 403.367 0 375s27.8-53.152 33.7-79.677c6.087-27.407-8.3-62.036 3.362-86.758 11.863-25.132 47.425-35.154 64.276-56.731 16.937-21.693 18.637-59.352 39.85-76.673 21.1-17.231 57.362-10.597 81.925-22.715 24.174-11.94 41.637-45.176 68.425-51.401 25.95-6.034 55.724 16.03 83.462 16.03 27.738 0 57.512-22.064 83.462-16.03 26.788 6.225 44.25 39.461 68.426 51.4 24.574 12.119 60.837 5.485 81.937 22.716 21.2 17.321 22.9 54.993 39.837 76.673 16.85 21.59 52.413 31.612 64.275 56.73 11.663 24.723-2.737 59.352 3.363 86.76 5.9 26.524 33.7 51.31 33.7 79.676"/></mask>
	</defs>
</svg>

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

<!-- Common Components -->
<script src="/vue/components/common/functions/common.js?v=1.0"></script>
<script src="/vue/components/common/functions/common_mixins.js?v=1.0"></script>
<script src="/vue/components/common/functions/item_mixins.js?v=1.21"></script>
<script src="/vue/components/common/functions/search_mixins.js?v=1.0"></script>
<script src="/vue/components/common/functions/modal_mixins.js?v=1.0"></script>
<script src="/vue/components/common/wish.js?v=1.0"></script>
<script src="/vue/components/common/no_data.js?v=1.0"></script>
<script src="/vue/components/common/sortbar.js?v=1.0"></script>
<script src="/vue/components/common/tab_view_type.js?v=1.0"></script>
<script src="/vue/components/common/quicklink.js?v=1.0"></script>
<script src="/vue/components/common/tab_type1.js?v=1.0"></script>
<script src="/vue/components/common/modal.js?v=1.0"></script>
<script src="/vue/components/common/item_module_footer_btn.js?v=1.0"></script>
<script src="/vue/components/common/btn_top.js?v=1.0"></script>
<script src="/vue/components/common/pagination.js?v=1.0"></script>
<!-- //Common Components -->

<!-- Search Components -->
<script src="/vue/components/search/searchbar.js?v=1.0"></script>
<script src="/vue/components/search/result_nodata.js?v=1.2"></script>
<script src="/vue/components/search/srch_cate.js?v=1.0"></script>
<script src="/vue/components/search/lyr_add_kwd.js?v=1.0"></script>
<script src="/vue/components/search/modal_sorting.js?v=1.1"></script>
<script src="/vue/components/search/alternative_keyword.js?v=1.0"></script>
<script src="/vue/components/search/recommend_keywords.js?v=1.0"></script>
<script src="/vue/components/search/correct_typos.js?v=1.1"></script>
<!-- //Search Components -->

<!-- Product Components -->
<script src="/vue/components/product/prd_list_basic.js?v=1.1"></script>
<script src="/vue/components/product/prd_list_photo2.js?v=1.2"></script>
<script src="/vue/components/product/prd_big_sale.js?v=1.0"></script>
<script src="/vue/components/product/prd_item_basic_product.js?v=1.3"></script>
<script src="/vue/components/product/prd_item_photo.js?v=1.0"></script>
<script src="/vue/components/product/prd_item_photo2.js?v=1.0"></script>
<script src="/vue/components/product/prd_rank.js?v=1.0"></script>
<script src="/vue/components/product/prd_img.js?v=1.0"></script>
<script src="/vue/components/product/prd_price.js?v=1.0"></script>
<script src="/vue/components/product/prd_name.js?v=1.0"></script>
<script src="/vue/components/product/prd_brand.js?v=1.0"></script>
<script src="/vue/components/product/prd_badge.js?v=1.0"></script>
<script src="/vue/components/product/prd_evaluate.js?v=1.0"></script>
<script src="/vue/components/product/prd_more_button.js?v=1.0"></script>
<script src="/vue/components/product/prd_list_grid1.js?v=1.0"></script>
<script src="/vue/components/product/prd_item_type3.js?v=1.0"></script>
<script src="/vue/components/product/helper.js?v=1.0"></script>
<script src="/vue/components/product/prd_img_svg.js?v=1.0"></script>
<script src="/vue/components/product/modal_filter.js?v=2.2"></script>
<!-- //Product Components -->

<!-- Core -->
<script src="/vue/search/Result/product_store.js?v=1.17"></script>
<script src="/vue/search/Result/product_result.js?v=1.27"></script>
<!-- //Core -->