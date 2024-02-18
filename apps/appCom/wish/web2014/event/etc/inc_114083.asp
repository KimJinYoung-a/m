<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 텐텐마인드 페이지
' History : 2021-11-02 김형태 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<style>
    .mEvt114083 section{position:relative;}

    /* section01 */
    .mEvt114083 .section01 .next{width:87vw;height:5.4rem;position:absolute;top:31.4rem;left:50%;margin-left:-43.5vw;background:transparent;}

    /* section02 */
    .mEvt114083 .section02{height:127vh;}
    .mEvt114083 .section02 .quiz{position:absolute;top:1.2rem;}
    /*.mEvt114083 .section02 .quiz02{display:none}
    .mEvt114083 .section02 .quiz03{display:none}
    .mEvt114083 .section02 .quiz04{display:none}
    .mEvt114083 .section02 .quiz05{display:none}*/
    .mEvt114083 .section02 .quiz .quiz_wrap{position:absolute;top:24rem;width:80.3vw;left:50%;margin-left:-40.15vw;}
    .mEvt114083 .section02 .quiz .quiz_wrap p{width:39.5vw;float:left;}
    .mEvt114083 .section02 .quiz .quiz_wrap p.q01, .mEvt114083 .section02 .quiz .quiz_wrap p.q03{margin-right:1.3vw;}
    .mEvt114083 .section02 .quiz .quiz_wrap p.q01, .mEvt114083 .section02 .quiz .quiz_wrap p.q02{margin-bottom:1rem;}
    .mEvt114083 .section02 .quiz .quiz_wrap p.on{position:relative;}
    .mEvt114083 .section02 .quiz .quiz_wrap p.on::after{position:absolute;top:0;left:0;content:'';display:block;background:url(//webimage.10x10.co.kr/fixevent/event/2021/114083/m/quiz_on.png)no-repeat 0 0;background-size:100%;width:39.5vw;height:12.65rem;}
    .mEvt114083 .section02 .quiz .submit{width:84vw;height:5rem;display:block;background:transparent;position:absolute;bottom:4.5rem;left:50%;margin-left:-42vw;}
    /*.mEvt114083 .section02 .popup{display:none;}*/
    .mEvt114083 .section02 .popup .bg_dim{position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.6);z-index:9999;}
    .mEvt114083 .section02 .popup .pop{width:39.5vw;position:absolute;top:20rem;left:50%;margin-left:-19.75vw;z-index:9999;}


    /* section03 */
    .mEvt114083 .section03 a.btn_close{position:absolute;top:0;right:0;width:20vw;height:20vw;display:block;}

    /* section04 */
    /*.mEvt114083 .section04 .result02{display:none;}
    .mEvt114083 .section04 .result03{display:none;}
    .mEvt114083 .section04 .result04{display:none;}
    .mEvt114083 .section04 .result05{display:none;}
    .mEvt114083 .section04 .result06{display:none;}*/
    .mEvt114083 .section04 a.share{position:absolute;top:40rem;width:80vw;height:5.5rem;left:50%;margin-left:-40vw;}
    .mEvt114083 .section04 a.shopping{position:absolute;top:46.3rem;width:80vw;height:5.5rem;left:50%;margin-left:-40vw;}

    /* sns share layer */
    .ly-sns {display:none;}
    .ly-sns .inner,.ly-sns .tenten-header,.ly-sns .title-wrap {border-radius:.68rem .68rem 0 0;}
    .ly-sns .inner {z-index:100001; width:100%; background-color:#fff;}
    .ly-sns .tenten-header {display:block !important; position:static;}
    .ly-sns .tenten-header:after {display:none;}
    .ly-sns .title-wrap {height:4.35rem; padding:1.71rem 0 0;}
    .ly-sns h2 {width:29.26rem; padding-bottom:.99rem; padding-top:0; padding-left:.68rem; margin:0 auto; border-bottom:solid #f5f5f5 .09rem; font-size:1.37rem; line-height:1.22; text-align:left;}
    .ly-sns .btn-close {position:absolute; top:.23rem; right:0; width:4.43rem; height:100%; margin-top:0; background:transparent none; color:transparent;}
    .ly-sns .btn-close:after {content:' '; position:absolute; top:50%; left:50%; width:1.37rem; height:1.37rem; margin:-0.68rem 0 0 -0.68rem; background-position:-13.78rem 0;}
    .ly-sns .sns-list ul {display:flex; flex-wrap:wrap; margin-top:.68rem; margin-bottom:4.35rem;}
    .ly-sns .sns-list li {width:33.333%; margin:2.05rem 0 0;}
    .ly-sns .icon {width:4.78rem; height:4.78rem; margin:0 auto; background-image:url(http://fiximage.10x10.co.kr/m/2020/common/ico_sns.png); background-size:15.64rem 18.49rem; background-color:#eee; text-indent:-999em;}
    .ly-sns .icon-url {background-position:0 -10.41rem}
    .ly-sns .icon-kakao {background-position:-10.41rem 0;}
    .ly-sns .icon-line {background-position:0 -5.21rem;}
    .ly-sns .icon-insta {background-position:-5.21rem 0;}
    .ly-sns .icon-facebook {background-position:0 0;}
    .ly-sns .icon-pinterest {background-position:-5.21rem -5.21rem;}
    .ly-sns .icon-twitter {background-position:-10.41rem -5.21rem;}
    .ly-sns .icon-url:after {background-position:0 -10.41rem;}
    .ly-sns .icon:after {display:none;}
    /* app 전용 */
    .ly-sns .sns-list .share-url {display:flex; width:80.93%; height:2.73rem; margin:2.05rem auto 0;}
    .ly-sns .sns-list .share-url .ellipsis {overflow:hidden; width:72.63%; height:100%; padding:0 1.11rem; color:#999; font-size:1.11rem; line-height:2.83rem; font-family:'CoreSansCLight', 'AppleSDGothicNeo-Light', 'NotoSansKRLight'; border:solid .085rem #eee; border-radius:.34rem 0 0 .34rem; text-overflow:ellipsis;}
    .ly-sns .sns-list .share-url .btn-url {width:27.37%; height:100%; background-color:#00be91; border-radius:0 .34rem .34rem 0; color:#fff; font-size:1.19rem; line-height:3.03rem; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
    .lySlideUp {animation:lySlideUp 0.5s cubic-bezier(.17,.67,.62,.88);}
    @keyframes lySlideUp {
        0% {bottom:-20.82rem;}
        100% {bottom:0;}
    }
    .lySlideDown {animation:lySlideDown 0.5s cubic-bezier(.17,.67,.62,.88);}
    @keyframes lySlideDown {
        0% {bottom:0;}
        100% {bottom:-20.82rem;}
    }
</style>

<div id="app"></div>

<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js" ></script>
<script>
    const loginUserLevel = "<%= GetLoginUserLevel %>";
    const loginUserID = "<%= GetLoginUserID %>";
    const server_info = "<%= application("Svr_Info") %>";

    let isUserLoginOK = false;
    <% IF IsUserLoginOK THEN %>
        isUserLoginOK = true;
    <% END IF %>
</script>
<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/babel-core/5.8.34/browser.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.auto.min.js"></script>
<% IF application("Svr_Info") = "Dev" THEN %>
<script src="https://unpkg.com/vue"></script>
<script src="https://unpkg.com/vuex"></script>
<script src="/vue/vue.lazyimg.min.js"></script>
<% Else %>
<script src="/vue/2.5/vue.min.js"></script>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>
<% End If %>

<!-- Common Components -->
<script src="/vue/components/common/functions/common.js?v=1.0"></script>
<script src="/vue/components/common/functions/event_common.js?v=1.0"></script>
<!--<script src="/vue/components/common/item_module_header.js?v=1.0"></script>-->
<script src="/vue/components/common/modal2.js?v=1.0"></script>
<!--<script src="/vue/components/common/no_data.js?v=1.0"></script>
<script src="/vue/components/common/functions/item_mixins.js?v=1.0"></script>-->
<script src="/vue/components/common/functions/modal_mixins.js?v=1.0"></script>
<!--<script src="/vue/components/common/functions/common_mixins.js?v=1.0"></script>-->
<!-- //Common Components -->

<script type="text/javascript" src="/event/etc/json/js_applyItemInfo_110063.js"></script>

<!-- Core -->
<script src="/vue/event/etc/114083/index_app.js?v=1.00"></script>
<!-- //Core -->