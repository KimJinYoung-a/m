<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 브랜드 검색 결과 페이지 메인
' History : 2020-10-20 이전도 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/vue/test/head.asp" -->
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
<script src="/vue/components/common/functions/common_mixins.js?v=1.0"></script>
<script src="/vue/components/common/functions/modal_mixins.js?v=1.0"></script>
<script src="/vue/components/common/functions/search_mixins.js?v=1.0"></script>
<script src="/vue/components/search/modal_sorting.js?v=1.1"></script>
<!-- //Search Components -->

<script>

var app = new Vue({
    el: '#app',
    mixins : [search_mixin, modal_mixin, common_mixin],
    template: `
        <div id="content" class="content search_detail">

            <button @click="open_pop('modal_sorting')">테스트</button>

            <Modal-Sorting
                :is_groups_show="true"
                :groups_count="groups_count"
                :search_keyword="parameter.keyword"
                :sort_option="parameter.sort_method"
                search_type="product"
            ></Modal-Sorting>

        </div>
    </div>
    `,
    data() {return {
        groups_count : {
            total: 34654,
            product: 18350,
            review: 16262,
            exhibition: 39,
            event: 0,
            brand: 0
        },
        parameter : {
            keyword : '크리스마스',
            sort_method : 'new'
        }
    }}
});
</script>