<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
'####################################################
' Description : WAKE UP 이벤트
' History : 2021.12.29 김형태
'####################################################

Dim eCode, moECode

IF application("Svr_Info") = "Dev" THEN
    eCode = "108396"
Else
    eCode = "115629"
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)
%>
<style>
.mEvt115629 {position:relative; overflow:hidden;}
.mEvt115629 .section {position:relative;}
.mEvt115629 .section a {display:inline-block; width:100%;}
.mEvt115629 .desc {line-height:normal;}
.mEvt115629 .desc .wish {display:flex; align-items:flex-start; font-size:1.28rem; color:#ff5373; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.mEvt115629 .desc .wish .icon {display:inline-block; width:1.07rem; height:1.07rem; margin:0.3rem 0.3rem 0 0; background:url(//webimage.10x10.co.kr/fixevent/event/2021/115629/m/icon_wish.png) no-repeat 0 0; background-size:100%;}
.mEvt115629 .desc .wish .counting {margin-top:0.1rem;}
.mEvt115629 .prd01 .item01 {position:absolute; left:0; top:8rem; height:15rem;}
.mEvt115629 .prd01 .item01 .desc {position:absolute; right:5.7rem; top:12.2rem;}
.mEvt115629 .prd01 .item02 {position:absolute; left:0; top:24rem; height:15rem;}
.mEvt115629 .prd01 .item02 .desc {position:absolute; right:1.8rem; top:6.9rem;}
.mEvt115629 .prd01 .item03 {position:absolute; left:0; top:40rem; height:15rem;}
.mEvt115629 .prd01 .item03 .desc {position:absolute; left:1.5rem; top:5.1rem;}

.mEvt115629 .prd02 .item01 {position:absolute; left:0; top:8rem; height:15rem;}
.mEvt115629 .prd02 .item01 .desc {position:absolute; left:2.7rem; top:5.6rem;}
.mEvt115629 .prd02 .item02 {position:absolute; left:0; top:24rem; height:15rem;}
.mEvt115629 .prd02 .item02 .desc {position:absolute; left:18.5rem; top:9.4rem;}
.mEvt115629 .prd02 .item03 {position:absolute; left:0; top:44.5rem; height:15rem;}
.mEvt115629 .prd02 .item03 .desc {position:absolute; left:19.2rem; top:9.45rem;}
.mEvt115629 .prd02 .item04 {position:absolute; left:0; top:59.5rem; height:15rem;}
.mEvt115629 .prd02 .item04 .desc {position:absolute; left:19.5rem; top:7.95rem;}
.mEvt115629 .prd02 .item05 {position:absolute; left:0; top:74.5rem; height:15rem;}
.mEvt115629 .prd02 .item05 .desc {position:absolute; left:10.5rem; top:3.45rem;}

.mEvt115629 .prd03 .item01 {position:absolute; left:0; top:8rem; height:10rem;}
.mEvt115629 .prd03 .item01 .desc {position:absolute; left:3.6rem; top:4.75rem;}
.mEvt115629 .prd03 .item02 {position:absolute; left:0; top:19rem; height:18rem;}
.mEvt115629 .prd03 .item02 .desc {position:absolute; right:10.3rem; top:15.4rem;}
.mEvt115629 .prd03 .item03 {position:absolute; left:0; top:43rem; height:10rem;}
.mEvt115629 .prd03 .item03 .desc {position:absolute; right:18.2rem; top:6.12rem;}

.mEvt115629 .prd04 .item01 {position:absolute; left:0; top:8rem; height:10rem;}
.mEvt115629 .prd04 .item01 .desc {position:absolute; left:8.9rem; top:6.1rem;}
.mEvt115629 .prd04 .item02 {position:absolute; left:0; top:23rem; height:21rem;}
.mEvt115629 .prd04 .item02 .desc {position:absolute; right:8.5rem; top:6.1rem;}
.mEvt115629 .prd04 .item03 {position:absolute; left:0; top:48rem; height:10rem;}
.mEvt115629 .prd04 .item03 .desc {position:absolute; right:19.4rem; top:7rem;}

.mEvt115629 .prd05 a {font-size:0; text-indent:-9999px;}
.mEvt115629 .prd05 .item01 {position:absolute; left:0; top:16rem; height:10rem;}
.mEvt115629 .prd05 .item02 {position:absolute; left:0; top:28rem; height:13rem;}
.mEvt115629 .prd05 .item03 {position:absolute; left:0; top:43rem; height:10rem;}
.mEvt115629 .prd05 .item04 {position:absolute; left:0; top:56rem; height:17rem; margin-left:36%;}
.mEvt115629 .prd05 .item05 {position:absolute; left:0; top:73rem; height:8rem;}
.mEvt115629 .prd05 .item06 {position:absolute; left:0; top:83rem; height:8rem;}
.mEvt115629 .prd05 .item07 {position:absolute; left:0; top:92rem; height:14rem;}
.mEvt115629 .prd05 .item08 {position:absolute; left:0; top:109rem; height:21rem;}
.mEvt115629 .prd05 .item09 {position:absolute; left:0; top:130rem; height:14rem;}
.mEvt115629 .prd05 .item10 {position:absolute; left:0; top:147rem; height:21rem; margin-left:29%;}
.mEvt115629 .prd05 .item11 {position:absolute; left:0; top:168rem; height:8rem;}

.mEvt115629 .comment-area {padding-bottom:4.27rem; background:#6248ff;}
.mEvt115629 .comment-input {position:relative;}
.mEvt115629 .comment-input button {width:100%; height:5rem; position:absolute; left:0; top:8rem; background:transparent; text-indent:-9999px; font-size:0;}
.mEvt115629 .comment-input .co-input {display:flex; position:absolute; left:0; top:0; align-items:center; width:calc(100% - 3.78rem); height:8.49rem; padding:1rem; margin:0 1.89rem; background:#fff; border-radius:1.71rem 1.71rem 0 0;}
.mEvt115629 .comment-input .co-input .placeholder {width:100%; position:absolute; left:50%; top:50%; transform:translate(-50%,-50%); line-height:1.8rem; text-align:center; font-size:1.20rem; color:#c5c5c5; pointer-events:none; user-select:none;}
.mEvt115629 .comment-input .co-input .placeholder.placehidden {display:none;}

.mEvt115629 .comment-input textarea {width:100%; height:auto; min-height:3rem; max-height:5rem; padding:0; border:0; line-height:1.7rem; overflow:hidden; font-size:1.20rem; color:#111; text-align:center; resize:none; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.mEvt115629 .comment-list {height:11.73rem; padding:2.48rem 1.71rem 1.71rem; margin:0 1.92rem 1.28rem; border-radius:1.71rem; background:#ffe385;}
.mEvt115629 .comment-list .top {display:flex; align-items:center; justify-content:flex-start; padding-bottom:1.53rem; border-bottom:0.13rem solid #f1d577;}
.mEvt115629 .comment-list .num {font-size:1.07rem; color:#000;}
.mEvt115629 .comment-list .id {padding-left:0.85rem; font-size:1.30rem; color:#000; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt115629 .comment-list .txt {padding-top:1.53rem; font-size:1.30rem; color:#000; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; line-height:1.7rem; word-break:break-all; overflow: hidden; text-overflow:ellipsis; display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient: vertical;}

.mEvt115629 .page-list {padding-top:0.56rem;}
.mEvt115629 .page-list ul {display:flex; align-items:center; justify-content:center;}
.mEvt115629 .page-list ul li {margin:0 0.64rem;}
.mEvt115629 .page-list ul li a {display:inline-block; width:2.48rem; height:2.48rem; line-height:2.48rem; text-align:center; font-size:1.37rem; color:#fff; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt115629 .page-list ul li.current {background:#4c30f6; border-radius:100%;}
.mEvt115629 .page-list ul li.current a {color:#ffe385;}
.mEvt115629 .page-list ul li.prev a {width:1.45rem; height:0.94rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/115629/m/icon_arrow.png) no-repeat 0 0; font-size:0; background-size:100%; transform: rotate(180deg); vertical-align:middle;}
.mEvt115629 .page-list ul li.next a {width:1.45rem; height:0.94rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/115629/m/icon_arrow.png) no-repeat 0 0; font-size:0; background-size:100%; vertical-align:middle;}

</style>

<div id="app"></div>

<script>
    let isUserLoginOK = false;
    <% IF IsUserLoginOK THEN %>
        isUserLoginOK = true;
    <% END IF %>
</script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/1.7.1/clipboard.min.js"></script>
<% IF application("Svr_Info") = "Dev" THEN %>
    <script src="https://unpkg.com/vue"></script>
    <script src="https://unpkg.com/vuex"></script>
    <script src="/vue/vue.lazyimg.min.js"></script>
<% Else %>
    <script src="/vue/2.5/vue.min.js"></script>
    <script src="/vue/vue.lazyimg.min.js"></script>
    <script src="/vue/vuex.min.js"></script>
<% End If %>

<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>
<script src="/vue/components/common/functions/common.js?v=1.0"></script>

<script src="/vue/event/etc/115629/store.js?v=1.00"></script>
<script src="/vue/event/etc/115629/index.js?v=1.00"></script>
<script>
app.userId = '<%=GetLoginUserid%>';
</script>