<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 검색 진입 페이지
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
<script>
    String.prototype.replaceAll = function(searchStr, replaceStr) {
        return this.split(searchStr).join(replaceStr);
    }

    const tenRecentKeywords = [];
    <% Dim temp_idx
        for temp_idx=0 to 3 %>
        <% if "" <> request.Cookies("tenRecentKeywords")("k" & temp_idx) Then %>
            tenRecentKeywords.push('<%=request.Cookies("tenRecentKeywords")("k" & temp_idx)%>');
        <% else Exit For end if %>
    <% next %>
    tenRecentKeywords.reverse();
</script>

<!-- #include virtual="/lib/inc/incHeader.asp" -->
<div id="content" class="content search_entrance">
    <div id="app"></div>
</div>

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



<script src="/vue/components/common/functions/common.js?v=2.0"></script>
<script src="/vue/components/common/functions/search_mixins.js?v=2.0"></script>
<script src="/vue/search/Entry/store.js?v=1.01"></script>
<script src="/vue/search/Entry/index.js?v=2.02"></script>