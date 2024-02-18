<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 텐텐단독 상품상세
' History : 2021-09-27 김형태 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->

<%
    dim gnbflag, vGaparam

    If gnbflag <> "" Then '//gnb 숨김 여부
        gnbflag = true
    Else
        gnbflag = False
        strHeadTitleName = "텐텐단독 상점"
    End if
%>

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<div id="app"></div>

<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js" ></script>
<script>
    let isUserLoginOK = false;
    <% IF IsUserLoginOK THEN %>
        isUserLoginOK = true;
    <% END IF %>

    const loginUserLevel = "<%= GetLoginUserLevel %>";
    const rd_sitename = "<%= session("rd_sitename") %>";
    const loginUserID = "<%= GetLoginUserID %>";
    const server_info = "<%= application("Svr_Info") %>";

    $(document).ready(function(){
        setTimeout(setSwiper, 1000);
    });

    function setSwiper(){
        var gage = {
            init: function(){
                // restart used for demo purposes - change to $('.gage').each(function(i){
                $('.chart span').css({"width" : "0"}).parent().each(function(i){
                    // Loop through .gage elements
                    $('p', this).html($(this).attr("data-label"));
                });
            }
        }
        // Call gage init function
        gage.init();
        // Interval used for demo purposes - remove if using
        $(function() {
            gage.init();
        },);
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
<script src="/vue/components/common/functions/common.js?v=1.0"></script>
<script src="/vue/components/common/item_module_header.js?v=1.0"></script>
<script src="/vue/components/common/modal2.js?v=1.0"></script>
<script src="/vue/components/common/no_data.js?v=1.0"></script>
<script src="/vue/components/common/functions/item_mixins.js?v=1.0"></script>
<script src="/vue/components/common/functions/modal_mixins.js?v=1.0"></script>
<script src="/vue/components/common/functions/common_mixins.js?v=1.0"></script>
<script src="/vue/components/common/btn_top.js?v=1.0"></script>
<!-- //Common Components -->

<link href="https://cdnjs.cloudflare.com/ajax/libs/Swiper/4.0.7/css/swiper.min.css" rel="stylesheet">
<!--<script src="https://cdnjs.cloudflare.com/ajax/libs/Swiper/4.0.7/js/swiper.min.js"></script>-->
<script src="https://cdn.jsdelivr.net/npm/vue-awesome-swiper@3.0.4/dist/vue-awesome-swiper.js"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/1.7.1/clipboard.min.js"></script>

<!-- Core -->
<script src="/vue/tenten_exclusive/item_store.js?v=1.00"></script>
<script src="/vue/tenten_exclusive/item_index.js?v=1.00"></script>
<!-- //Core -->