<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 텐텐단독 오픈 상품 리스트
' History : 2021-09-27 전제현 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->

<%

	dim exclusiveIdx	:  exclusiveIdx = requestCheckVar(request("exclusiveIdx"),9)
	if exclusiveIdx="" then
		Call Alert_AppClose("상품번호가 없습니다.")
		response.End
	elseif Not(isNumeric(exclusiveIdx)) then
		Call Alert_AppClose("잘못된 상품번호입니다.")
		response.End
	end if

    dim gnbflag, vGaparam

    gnbflag = RequestCheckVar(request("gnbflag"),1)
    vGaparam = request("gaparam")

    If gnbflag <> "" Then '//gnb 숨김 여부
        gnbflag = true
    Else
        gnbflag = False
        strHeadTitleName = "텐텐단독 상점"
    End if
%>
<!-- #INCLUDE Virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/inc/incHeader.asp" -->

<div id="app"></div>

<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js" ></script>
<script>
    const isUserLoginOK = "<%= exclusiveIdx %>";
    const loginUserLevel = "<%= GetLoginUserLevel %>";
    const rd_sitename = "<%= session("rd_sitename") %>";
    const loginUserID = "<%= GetLoginUserID %>";
    const server_info = "<%= application("Svr_Info") %>";

    const exclusiveIdx = "<%= exclusiveIdx %>";
</script>
 <script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
 <script src="https://cdnjs.cloudflare.com/ajax/libs/babel-core/5.8.34/browser.js"></script>
 <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.min.js"></script>
 <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.auto.min.js"></script>
<!-- <% IF application("Svr_Info") = "Dev" THEN %> -->
 <script src="/vue/vue_dev.js"></script>
<!-- <% Else %> -->
 <script src="/vue/2.5/vue.min.js"></script>
<!-- <% End If %> -->
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>

<!-- Common Components -->
 <script src="/vue/components/common/functions/common.js?v=1.1"></script>
 <script src="/vue/components/common/item_module_header.js?v=1.110"></script>
 <script src="/vue/components/common/modal2.js?v=1.0"></script>
 <script src="/vue/components/common/no_data.js?v=1.0"></script>
 <script src="/vue/components/common/functions/item_mixins.js?v=110.0"></script>
 <script src="/vue/components/common/functions/modal_mixins.js?v=1.110"></script>
 <script src="/vue/components/common/functions/common_mixins.js?v=1.100"></script>
 <script src="/vue/components/common/btn_top.js?v=1.0"></script>
<!-- //Common Components -->

<script src="/vue/components/tenten_exclusive/comment.js?v=1.3"></script>

<!-- Core -->
 <script src="/vue/tenten_exclusive/store.js?v=1.00"></script>
 <script src="/vue/tenten_exclusive/commnet.js?v=1.00"></script>
<!-- //Core -->

<script>
	var apps = new Vue({
		el: '#app',
		template: `
			<div>
				<Exclusive-Commnet
				    :exclusiveIdx="exclusiveIdx"
                ></Exclusive-Commnet>
			</div>
		`
        ,computed : {
			exclusiveIdx : function() {
				return '<%= exclusiveIdx %>';
			}
		}
	});
</script>

Comment-List