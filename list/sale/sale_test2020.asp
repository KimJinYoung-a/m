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

<!-- Header 차후 include -->
<style>
#header {position:fixed; top:0; left:0; z-index:100; width:100%;}
    .srch_kwd_list.type3 {display: block;}

.v-enter-active, .v-leave-active, .v-move {
  transition: opacity 0.5s, transform 0.1s;
}
.v-enter {
  opacity: 0;
  transform: translateY(40px);
}
.v-leave-to {
  opacity: 0;
  transform: translateY(20px);
}
</style>
<style>
    .helper_item {display:flex; justify-content:center; align-items:center; width:50%; font-size:1.2em; color:white; background:purple;}
</style>
<header id="header" style="display:flex; align-items:center; justify-content:center; height:4.1rem; background-color:var(--c_111); color:var(--white);">Temp Header</header>

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
<script src="/vue/components/common/functions/item_mixins.js?v=1.0"></script>
<script src="/vue/components/common/wish.js?v=1.0"></script>
<script src="/vue/components/common/tab_type1.js?v=1.0"></script>
<!-- //Common Components -->

<script src="/vue/components/product/prd_list_grid2_test.js?v=1.0"></script>
<script src="/vue/components/product/prd_img.js?v=1.0"></script>

<!-- Core -->
<script src="/vue/sale/Test/store.js?v=1.0"></script>
<script src="/vue/sale/Test/index.js?v=1.0"></script>
<!-- //Core -->