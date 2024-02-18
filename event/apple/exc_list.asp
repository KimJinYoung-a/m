<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 애플 전용관 상품 리스트
' History : 2020-05-15 이종화 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<style>[v-cloak] { display: none; }</style>
<link rel="stylesheet" type="text/css" href="/lib/css/apple.css">

<%' 상품 리스트 %>
<div id="app"></div>

<form name="sbagfrm" method="post" action="" style="margin:0px;">
	<input type="hidden" name="mode" value="add" />
	<input type="hidden" name="itemid" value="" />
	<input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
	<input type="hidden" name="itemoption" value="0000" />
	<input type="hidden" name="itemea" readonly value="1" />    
</form>
<iframe src="" name="iiBagWin" frameborder="0" width="0" height="0" style="display:none"></iframe>

<script>
//장바구니 레이어
function fnsbagly(v) {
    if (v=="x"){
		$("#sbaglayerx").show();
        $("#alertBoxV17a").show();
    }else if(v=="o"){
		$("#sbaglayero").show();
        $("#alertBoxV17a").show();
	}
	setTimeout(function() {
        $("#alertBoxV17a").fadeOut(1000);
    }, 2500);
    setTimeout(function() {    
        $("#sbaglayerx").hide();
        $("#sbaglayero").hide();
    }, 3500);
}
</script>

<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.auto.min.js"></script>
<% IF application("Svr_Info") = "Dev" THEN %>
<script src="/vue/vue_dev.js"></script>
<% Else %>
<script src="/vue/vue.min.js"></script>
<% End If %>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>
<script src="/vue/exhibition/components/shoppingbag-button.js?v=1.1"></script>
<script src="/vue/exhibition/components/item/item-list.js?v=1.1"></script>
<script src="/vue/exhibition/modules/store.js?v=1.1"></script>
<script src="/vue/exhibition/main/apple2020/morelist.js?v=1.1"></script>