<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : 2020 랜선 송년회 : 쓸데없는 선물하기 이벤트
' History : 2020-12-08 이전도
'####################################################
Dim eCode, userid

IF application("Svr_Info") = "Dev" THEN
	eCode = 104280
Else
	eCode = 108614
End If

userid = GetEncLoginUserID()
'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("2020 랜선 송년회 : 쓸데없는 선물하기 이벤트")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/105778/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "2020 랜선 송년회 : 쓸데없는 선물하기 이벤트"
Dim kakaodescription : kakaodescription = "당첨자는 총 50명! 재치있는 선물을 찾아주세요."
Dim kakaooldver : kakaooldver = "당첨자는 총 50명! 재치있는 선물을 찾아주세요."
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/105778/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode
%>
<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.auto.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bodymovin/5.7.4/lottie_svg.min.js"></script>
<% IF application("Svr_Info") = "Dev" THEN %>
<script src="https://unpkg.com/vue"></script>
<script src="https://unpkg.com/vuex"></script>
<script src="/vue/vue.lazyimg.min.js"></script>
<% Else %>
<script src="/vue/2.5/vue.min.js"></script>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>
<% End If %>

<style type="text/css">
.mEvt108614 {position:relative;}
.mEvt108614 .topic {position:relative;}
.mEvt108614 .section-01 {position:relative;}
.mEvt108614 .section-01 .number {width:6.52rem; position:absolute; left:50%; top:49%; transform:translate(149%,0); background:transparent; animation: updown .6s ease-in-out alternate infinite;}
.mEvt108614 .section-02 {text-align:center; background:#7a3efe;}
.mEvt108614 .section-02 .hidden-txt {display:none; position:relative;}
.mEvt108614 .section-02 .hidden-txt .btn-apply {width:100%; height:7rem; position:absolute; left:50%; bottom:6%; transform:translate(-50%,0); background:transparent;}
.mEvt108614 .section-02 .btn-simple {position:relative; padding-bottom:3rem; background:#7a3efe;}
.mEvt108614 .section-02 .btn-simple:before {content:""; width:0.91rem; height:0.60rem; position:absolute; right:20%; top:51%; background:url(//webimage.10x10.co.kr/fixevent/event/2020/108614/m/img_arrow.png) no-repeat 0 0; background-size:100%; transform:rotate(180deg); transition: .3s ease-in-out;}
.mEvt108614 .section-02 .btn-simple.on::before {content:""; transform:rotate(0);}
.mEvt108614 .section-04 .tit {position:relative;}
.mEvt108614 .section-04 .count {width:100%; position:absolute; left:50%; top:41%; transform: translate(-50%,0); text-align:center;}
.mEvt108614 .section-04 .count p {font-size:2.95rem; color:#fff;}
.mEvt108614 .section-04 .count .num {padding-top:1rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt108614 .view-wish {padding:0 1rem; background:#fd4e19;}
.mEvt108614 .view-wish ul {display:flex; flex-wrap:wrap;}
.mEvt108614 .view-wish ul li {width:calc(100% / 3 - 0.42rem); margin:0 0.21rem 2.34rem;}
.mEvt108614 .view-wish ul li a {display:inline-block; width:100%;}
.mEvt108614 .view-wish ul li .thum {width:100%; height:100%; background:#fff;}
.mEvt108614 .view-wish ul li .thum img {width:100%;}
.mEvt108614 .view-wish ul li .id {padding:0.43rem 0 0.86rem; font-size:0.86rem; color:#fff; text-align:right; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;}
.mEvt108614 .view-wish ul li .name {height:2.8rem; font-size:1.13rem; color:#fff; line-height:1.5rem; overflow:hidden;}
.mEvt108614 .item-area {position:absolute; left:50%; top:29%; transform:translate(-50%,0);}
.mEvt108614 .item-area .thumb .item1,
.mEvt108614 .item-area .thumb .item2,
.mEvt108614 .item-area .thumb .item3,
.mEvt108614 .item-area .thumb .item4,
.mEvt108614 .item-area .thumb .item5 {width:20.83rem; transition: .5s ease-in;}
.mEvt108614 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(0, 0, 0,0.702); z-index:150; overflow-y: scroll;}
.mEvt108614 .pop-container .pop-inner {position:relative; width:100%; padding:2.17rem 1.73rem 4.17rem;}
.mEvt108614 .pop-container .pop-inner a {display:inline-block;}
.mEvt108614 .pop-container .pop-inner .btn-close {position:absolute; right:3.73rem; top:4rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/108614/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;}
@keyframes updown {
    0% {top:48%;}
    100% {top:50%;}
}
</style>
<script type="text/javascript">
$(function(){
    /* 참여방법 노출 */
    $('.mEvt108614 .btn-simple').click(function(){
        $('.hidden-txt').slideToggle();
        $(this).toggleClass("on");
    })
});
function sharesns(snsnum) {
<% if isapp then %>
	fnAPPshareKakao('etc','<%=kakaotitle%>','<%=kakaoWebLink%>','<%=kakaoMobileLink%>','<%="url="&kakaoAppLink%>','<%=kakaoimage%>','','','','<%=kakaodescription%>');
<% else %>
	event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaoMobileLink%>' );
<% end if %>
}
</script>
<div id="app"></div>
<script src="/vue/components/common/functions/common.js?v=1.0"></script>
<script src="/vue/components/common/functions/item_mixins.js?v=1.0"></script>
<script src="/vue/event/etc/vue_108614.js?v=1.0"></script>