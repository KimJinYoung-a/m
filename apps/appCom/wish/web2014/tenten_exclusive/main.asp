<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description : [텐텐단독] 판매중 상품 리스트
' History : 2021-10-01 전제현 생성
'####################################################
dim gnbflag : gnbflag = RequestCheckVar(request("gnbflag"),1)
If gnbflag = "1" Then '//gnb 숨김 여부
	gnbflag = true
Else
	gnbflag = False
	strHeadTitleName = "텐텐단독"
End if
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->

<body class="default-font body-<%=chkiif(gnbflag,"main","sub")%>">
    <div id="app"></div>
</body>

<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js" ></script>
<script>
    const isUserLoginOK = "<%= IsUserLoginOK %>";
    const loginUserLevel = "<%= GetLoginUserLevel %>";
    const rd_sitename = "<%= session("rd_sitename") %>";
    const loginUserID = "<%= GetLoginUserID %>";
    const server_info = "<%= application("Svr_Info") %>";
    var exIdx = '';

    function fnAPPRCVpopSNS(){
        $("#lySns").show();
        $("#lySns .inner").removeClass("lySlideDown").addClass("lySlideUp");
        return false;
    }
</script>
<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/babel-core/5.8.34/browser.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.auto.min.js"></script>
<% IF application("Svr_Info") = "Dev" THEN %>
<script src="/vue/vue_dev.js"></script>
<% Else %>
<script src="/vue/2.5/vue.min.js"></script>
<% End If %>
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

<!-- Components -->
<script src="/vue/components/tenten_exclusive/main_item_list.js?v=1.0"></script>
<script src="/vue/components/tenten_exclusive/vote.js?v=1.0"></script>
<script src="/vue/components/tenten_exclusive/item_footer.js?v=1.0"></script>
<!-- //Components -->

<script src="https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/1.7.1/clipboard.min.js"></script>

<!-- Core -->
<script src="/vue/tenten_exclusive/store.js?v=1.00"></script>
<script src="/vue/tenten_exclusive/main.js?v=1.00"></script>
<!-- //Core -->