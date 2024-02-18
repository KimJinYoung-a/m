<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 검색 결과 페이지 메인
' History : 2020-08-19 원승현 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
	dim keyword, view_type, sort_method
	keyword = requestCheckVar(request("keyword"), 100) '' 검색 키워드
	view_type = request("view_type") '' 뷰 타입
	if( isNull(view_type) or len(trim(view_type)) = 0 ) then
	    view_type = "detail"
	end if
	sort_method = request("sort_method") '' 정렬
	if( isNull(sort_method) or len(trim(sort_method)) = 0 ) then
	    sort_method = "rc"
	end if

    '' 꼼꼼하게 찾기 파라미터
	dim deliType : deliType = request("deliType") '' 배송/기타
	dim dispCategories : dispCategories = request("dispCategories") '' 전시 카테고리 리스트
	dim makerIds : makerIds = request("makerIds") '' 브랜드 리스트
	dim maxPrice : maxPrice = request("maxPrice") '' 최고가
	dim minPrice : minPrice = request("minPrice") '' 최저가

	dim gnbflag , testmode, defaultAPIURL
	gnbflag = RequestCheckVar(request("gnbflag"),1)
	testmode = RequestCheckVar(request("testmode"),1)

	' 교정무시 키워드
	Dim correct_keyword : correct_keyword = request("correct_keyword")

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
        keyword : '<%=keyword%>',
        sort_method : '<%=sort_method%>',
        view_type : '<%=view_type%>',
        deliType : get_parameter_array('<%=deliType%>'), // 배송/기타 - 꼼꼼하게 찾기
        dispCategories : get_parameter_array('<%=dispCategories%>'), // 카테고리 - 꼼꼼하게 찾기
        makerIds : get_parameter_array('<%=makerIds%>'), // 브랜드 - 꼼꼼하게 찾기
        maxPrice : '<%=maxPrice%>', // 최고가
        minPrice : '<%=minPrice%>', // 최저가
		correct_keyword : '<%=correct_keyword%>' // 교정무시 키워드
    };
    const criteo_user_mail_md5 = '<%=CriteoUserMailMD5%>';
</script>
<%' 최근검색어 저장 & JS변수(tenRecentKeywords)로 할당 %>
<!-- #include virtual="/search/recent_keywords.asp" -->

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

<!-- Common Components -->
<script src="/vue/components/common/functions/common.js?v=1.0"></script>
<script src="/vue/components/common/item_module_header.js?v=1.0"></script>
<script src="/vue/components/common/item_module_footer_btn.js?v=1.0"></script>
<script src="/vue/components/common/wish.js?v=1.0"></script>
<script src="/vue/components/common/tgl_type1.js?v=1.0"></script>
<script src="/vue/components/common/quicklink.js?v=1.0"></script>
<script src="/vue/components/common/no_data.js?v=1.1"></script>
<script src="/vue/components/common/tab_type1.js?v=1.0"></script>
<script src="/vue/components/common/modal.js?v=1.0"></script>
<script src="/vue/components/common/tab_view_type.js?v=1.0"></script>
<script src="/vue/components/common/btn_top.js?v=1.0"></script>
<!-- //Common Components -->

<!-- Search Components -->
<script src="/vue/components/search/searchbar.js?v=1.0"></script>
<script src="/vue/components/search/srch_cate.js?v=1.0"></script>
<script src="/vue/components/search/result_nodata.js?v=1.0"></script>
<script src="/vue/components/search/lyr_add_kwd.js?v=1.0"></script>
<script src="/vue/components/search/alternative_keyword.js?v=1.0"></script>
<script src="/vue/components/search/recommend_keywords.js?v=1.0"></script>
<script src="/vue/components/search/correct_typos.js?v=1.1"></script>
<!-- //Search Components -->

<!-- Product Components -->
<script src="/vue/components/product/prd_big_sale.js?v=1.0"></script>
<script src="/vue/components/product/prd_item_basic_product.js?v=1.1"></script>
<script src="/vue/components/product/prd_time.js?v=1.0"></script>
<script src="/vue/components/product/prd_rank.js?v=1.0"></script>
<script src="/vue/components/product/prd_img.js?v=1.0"></script>
<script src="/vue/components/product/prd_price.js?v=1.0"></script>
<script src="/vue/components/product/prd_name.js?v=1.0"></script>
<script src="/vue/components/product/prd_brand.js?v=1.0"></script>
<script src="/vue/components/product/prd_badge.js?v=1.0"></script>
<script src="/vue/components/product/prd_evaluate.js?v=1.0"></script>
<script src="/vue/components/product/prd_more_button.js?v=1.0"></script>
<script src="/vue/components/product/prd_list_grid1.js?v=1.0"></script>
<script src="/vue/components/product/prd_item_photo.js?v=1.0"></script>
<!-- //Product Components -->

<!-- Review Components -->
<script src="/vue/components/review/rv_list_type1.js?v=1.0"></script>
<script src="/vue/components/review/rv_list_type2.js?v=1.0"></script>
<script src="/vue/components/review/rv_list_type2_photo.js?v=1.0"></script>
<script src="/vue/components/review/rv_info.js?v=1.0"></script>
<script src="/vue/components/review/rv_list_this_item.js?v=1.0"></script>
<!-- //Review Components -->

<!-- Event Components -->
<script src="/vue/components/event/evt_list_md.js?v=1.0"></script>
<script src="/vue/components/event/evt_list_mkt.js?v=1.0"></script>
<script src="/vue/components/event/evt_img.js?v=1.0"></script>
<script src="/vue/components/event/evt_info.js?v=1.0"></script>
<!-- //Event Components -->

<!-- Brand Components -->
<script src="/vue/components/brand/brd_list.js?v=1.0"></script>
<script src="/vue/components/brand/brd_img.js?v=1.0"></script>
<script src="/vue/components/brand/brd_info.js?v=1.0"></script>
<!-- //Brand Components -->

<!-- Core -->
<script src="/vue/components/common/functions/search_mixins.js?v=1.1"></script>
<script src="/vue/components/common/functions/item_mixins.js?v=1.1"></script>
<script src="/vue/components/common/functions/modal_mixins.js?v=1.0"></script>
<script src="/vue/components/common/functions/common_mixins.js?v=1.0"></script>
<script src="/vue/search/Result/overall_store.js?v=1.12"></script>
<script src="/vue/search/Result/overall_result.js?v=1.2"></script>
<!-- //Core -->