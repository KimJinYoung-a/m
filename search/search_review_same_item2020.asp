<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 이 상품의 후기 더보기 페이지
' History : 2020-10-22 이전도 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/inc/head.asp" -->
<%
	dim item_id
	item_id = request("item_id") '' 상품ID

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
<script>
    const parameter = {
        item_id : '<%=item_id%>'
    };
</script>

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
<script src="/vue/components/common/tab_view_type.js?v=1.0"></script>
<script src="/vue/components/common/wish.js?v=1.0"></script>
<!-- //Common Components -->

<!-- Product Components -->
<script src="/vue/components/product/prd_img.js?v=1.0"></script>
<script src="/vue/components/product/prd_name.js?v=1.0"></script>
<script src="/vue/components/product/prd_price.js?v=1.0"></script>
<!-- //Product Components -->

<!-- Review Components -->
<script src="/vue/components/review/rv_list_type2.js?v=1.0"></script>
<script src="/vue/components/review/rv_list_type2_photo.js?v=1.0"></script>
<script src="/vue/components/review/rv_info.js?v=1.0"></script>
<!-- //Review Components -->

<!-- Core -->
<script src="/vue/search/Result/review_same_store.js?v=1.0"></script>
<script src="/vue/search/Result/review_same_result.js?v=1.0"></script>
<!-- //Core -->