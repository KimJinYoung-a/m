<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 방금 판매된 상품 리스트
' History : 2020-05-07 이종화 생성
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
		strHeadTitleName = "가정의달 기획전"
	End if
%>
<style>[v-cloak] { display: none; }</style>
<link rel="stylesheet" type="text/css" href="/lib/css/apple.css?v=1.2">
<%' 상품 리스트 %>
<h2 style="padding-bottom:3.67rem;">방금<br>판매되었어요!</h2>
<div id="app"></div>
<script>
$(function() {
	fnAmplitudeEventMultiPropertiesAction('view_justsold','','');
})
</script>
<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.auto.min.js"></script>
<% IF application("Svr_Info") = "Dev" or testmode = "1" THEN %>
<script src="/vue/vue_dev.js"></script>
<% Else %>
<script src="/vue/vue.min.js"></script>
<% End If %>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>
<script src="/vue/components/common/functions/common.js"></script>
<script src="/vue/components/common/no_data.js"></script>
<script src="/vue/item/components/itemlist.js?v=1.00"></script>
<script src="/vue/item/main/justsold/filter.js?v=1.01"></script>
<script src="/vue/item/modules/store.js?v=1.00"></script>
<script src="/vue/item/main/justsold/index.js?v=1.01"></script>

