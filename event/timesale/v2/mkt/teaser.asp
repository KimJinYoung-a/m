<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 마케팅팀 타임세일 티저 페이지
' History : 2021-12-13 김형태 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->

<style>
.mEvt116051 .topic {position:relative;}
.mEvt116051 .topic .number {position:absolute; right:1.52rem; top:45%; width:8.91rem; background:transparent; z-index:10;}
.mEvt116051 .section-01,
.mEvt116051 .section-02 {position:relative;}
.mEvt116051 .section-01 .go-link {position:absolute; left:50%; bottom:22%; transform:translate(-50%,0); width:25.57rem; background:transparent;}
.mEvt116051 .section-01 .go-link a {display:inline-block;}
.mEvt116051 .section-02 .go-link {position:absolute; right:2.82rem; bottom:15%; width:13.35rem; background:transparent;}
.mEvt116051 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; min-height:45.52rem; background-color:rgba(0, 0, 0,0.902); z-index:150;}
.mEvt116051 .pop-container .pop-inner {position:relative; width:100%; padding:8.47rem 1.73rem 4.17rem;}
.mEvt116051 .pop-container .pop-inner a {display:inline-block;}
.mEvt116051 .pop-container .pop-inner .btn-close {position:absolute; right:2.73rem; top:2.60rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116051/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;}
.mEvt116051 .pop-container .pop-contents {position:relative;}
.mEvt116051 .pop-container .pop-contents .link-kakao {width:calc(100% - 4.80rem); position:absolute; left:50%; top:57%; transform:translate(-50%, 0);}
.mEvt116051 .pop-container .pop-contents .tit {padding-right:7.87rem;}
.mEvt116051 .pop-container .pop-contents .pop-input {display:flex; align-items:center; justify-content:flex-start; padding:6.82rem 0 2.17rem;}
.mEvt116051 .pop-container .pop-contents .pop-input button {height:3rem; padding-left:2rem; border-bottom:2px solid #54ff00; border-radius:0; font-size:1.43rem; color:#54ff00; background:none; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.mEvt116051 .pop-container .pop-contents .pop-input input {width:17.83rem; height:3rem; padding-left:0; border:0; font-size:1.43rem; color:#cbcbcb; background:none; border-bottom:2px solid #54ff00; border-radius:0;}
.mEvt116051 .slide-area {position:absolute; left:50%; bottom:31%; transform: translate(-50%,0); width:100%;}
.mEvt116051 .slide-area .swiper-wrapper {transition-timing-function:linear;}
.mEvt116051 .swiper-wrapper .swiper-slide {width:13.61rem; padding:0 0.56rem;}
</style>
<style>[v-cloak] { display: none; }</style>
<div id="app"></div>

<script>
    const server_info = "<%= application("Svr_Info") %>";
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
<script src="https://cdn.jsdelivr.net/npm/vue-awesome-swiper@4.1.1/dist/vue-awesome-swiper.min.js"></script>

<!-- Core -->
<script src="/vue/event/timesale/mkt/teaser/index.js?v=1.00"></script>
<!-- //Core -->