<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 히치하이커 메인
' History : 2021-01-12 임보라 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	dim gnbflag , testmode
	gnbflag = RequestCheckVar(request("gnbflag"),1)
	testmode = RequestCheckVar(request("testmode"),1)

	If gnbflag <> "" Then '//gnb 숨김 여부
		gnbflag = true
	Else
		gnbflag = False
		strHeadTitleName = "히치하이커"
	End if
%>
<script>
let current_user_id
<% If getLoginUserID="dlwjseh" OR getLoginUserID="bora2116" OR getLoginUserID="qpark99" OR getLoginUserID="ysys1418" OR getLoginUserID="kjh951116" OR getLoginUserID="sse1022" OR getLoginUserID="madebyash" OR getLoginUserID="integerkim" Then %>
    current_user_id = '<%=getLoginUserID%>';
<% End If %>
</script>
<style>[v-cloak] { display: none; }</style>
<div id="app"></div>

<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/babel-core/5.8.34/browser.js"></script>
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
<script src="/vue/components/common/item_module_header.js?v=1.0"></script>
<script src="/vue/components/common/modal2.js?v=1.0"></script>
<script src="/vue/components/common/no_data.js?v=1.0"></script>
<script src="/vue/components/common/functions/item_mixins.js?v=1.0"></script>
<script src="/vue/components/common/functions/modal_mixins.js?v=1.0"></script>
<script src="/vue/components/common/functions/common_mixins.js?v=1.3"></script>
<script src="/vue/components/common/btn_top.js?v=1.0"></script>
<!-- //Common Components -->

<!-- Core -->
<script src="/vue/hitchhiker/prd_list_magazine.js?v=1.1"></script>
<script src="/vue/hitchhiker/prd_list_goods.js?v=1.1"></script>
<script src="/vue/hitchhiker/vod_list.js?v=1.1"></script>
<script src="/vue/hitchhiker/address.js?v=1.72"></script>
<script src="/vue/hitchhiker/zipcode.js?v=1.1"></script>
<script src="/vue/hitchhiker/extra.js?v=1.1"></script>
<script src="/vue/hitchhiker/banner.js?v=1.1"></script>
<script src="/vue/hitchhiker/store.js?v=1.12"></script>
<script src="/vue/hitchhiker/index.js?v=1.15"></script>
<!-- //Core -->