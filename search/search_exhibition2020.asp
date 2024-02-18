<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 기획전 검색 결과 페이지 메인
' History : 2020-10-20 이전도 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/inc/head.asp" -->
<%
	dim keyword, sort_method
	keyword = requestCheckVar(request("keyword"), 100) '' 검색 키워드
	sort_method = request("sort_method") '' 정렬
	if( isNull(sort_method) or len(trim(sort_method)) = 0 ) then
	    sort_method = "best"
	end if

    '' 꼼꼼하게 찾기 파라미터
	dim view_type : view_type = request("view_type") '' 뷰 타입
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

%>
<script src="/vue/components/common/functions/search.js?v=1.0"></script>
<script>
    const parameter = {
        keyword : '<%=keyword%>',
        sort_method : '<%=sort_method%>',
        view_type : '<%=view_type%>', // 뷰 타입
        deliType : get_parameter_array('<%=deliType%>'), // 배송/기타 - 꼼꼼하게 찾기
        dispCategories : get_parameter_array('<%=dispCategories%>'), // 카테고리 - 꼼꼼하게 찾기
        makerIds : get_parameter_array('<%=makerIds%>'), // 브랜드 - 꼼꼼하게 찾기
        maxPrice : '<%=maxPrice%>', // 최고가
        minPrice : '<%=minPrice%>', // 최저가
		correct_keyword : '<%=correct_keyword%>' // 교정무시 키워드
    };
</script>
<%' 최근검색어 저장 & JS변수(tenRecentKeywords)로 할당 %>
<!-- #include virtual="/search/recent_keywords.asp" -->

<%' 키워드 검색결과 페이지 %>
<!-- #include virtual="/lib/inc/incHeader.asp" -->
<div id="app"></div>

<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.auto.min.js"></script>
<% IF application("Svr_Info") = "Dev" or testmode = "1" THEN %>
<script src="/vue/vue_dev.js"></script>
<% Else %>
<script src="/vue/2.5/vue.min.js"></script>
<% End If %>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>

<!-- Common Components -->
<script src="/vue/components/common/functions/common.js?v=1.0"></script>
<script src="/vue/components/common/functions/search_mixins.js?v=1.0"></script>
<script src="/vue/components/common/functions/modal_mixins.js?v=1.0"></script>
<script src="/vue/components/common/no_data.js?v=1.0"></script>
<script src="/vue/components/common/sortbar.js?v=1.0"></script>
<script src="/vue/components/common/quicklink.js?v=1.0"></script>
<script src="/vue/components/common/modal.js?v=1.0"></script>
<script src="/vue/components/common/btn_top.js?v=1.0"></script>
<!-- //Common Components -->

<!-- Search Components -->
<script src="/vue/components/search/searchbar.js?v=1.0"></script>
<script src="/vue/components/search/result_nodata.js?v=1.0"></script>
<script src="/vue/components/search/srch_cate.js?v=1.0"></script>
<script src="/vue/components/search/lyr_add_kwd.js?v=1.0"></script>
<script src="/vue/components/search/modal_sorting.js?v=1.1"></script>
<script src="/vue/components/search/alternative_keyword.js?v=1.0"></script>
<script src="/vue/components/search/recommend_keywords.js?v=1.0"></script>
<script src="/vue/components/search/correct_typos.js?v=1.1"></script>
<!-- //Search Components -->

<!-- Exhibition Components -->
<script src="/vue/components/event/evt_list_md.js?v=1.1"></script>
<script src="/vue/components/event/evt_img.js?v=1.0"></script>
<script src="/vue/components/event/evt_info.js?v=1.0"></script>
<!-- //Exhibition Components -->

<!-- Core -->
<script src="/vue/search/Result/exhibition_store.js?v=1.1"></script>
<script src="/vue/search/Result/exhibition_result.js?v=1.01"></script>
<!-- //Core -->