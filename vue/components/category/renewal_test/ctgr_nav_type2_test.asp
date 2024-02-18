<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 카테고리 필터 슬라이더 테스트 페이지
' History : 2020-10-13 이전도 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/inc/head.asp" -->
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

<div id="app"></div>

<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/babel-core/5.8.34/browser.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.auto.min.js"></script>
<% IF application("Svr_Info") = "Dev" or testmode = "1" THEN %>
<script src="https://unpkg.com/vue"></script>
<script src="https://unpkg.com/vuex"></script>
<script src="/vue/vue.lazyimg.min.js"></script>
<% Else %>
<script src="/vue/vue.min.js"></script>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>
<% End If %>

<script src="/vue/components/common/functions/common.js?v=1.0"></script>

<!-- Category Component -->
<script src="../ctgr_nav_type2.js?v=1.0"></script>
<script src="./store_ctgr_nav_type2_test.js?v=1.0"></script>
<!-- //Category Component -->

<script>
	var app = new Vue({
		el: '#app',
		store: store,
		template: `
			<div>
				<Category-Nav-Type2
                    @click_category="click_category"
				    :active_code="active_code"
				    :categories="categories"
                ></Category-Nav-Type2>
			</div>
		`,
		computed : {
		    active_code : function() { // 활성화할 카테고리 코드
		        return 0;
		    },
            categories : function() { // 카테고리 리스트
                return this.$store.getters.categories;
            }
		},
		created : function() {
            // 카테고리 리스트 불러오기
            this.$store.dispatch('GET_CATEGORIES');
		},
		methods : {
		    click_category(category_code) {
		        console.log('click ' + category_code);
		    }
		}
	});
</script>
