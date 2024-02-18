<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, currentDate , eventStartDate , eventEndDate
IF application("Svr_Info") = "Dev" THEN
	eCode = "102220"
Else
	eCode = "105499"
End If

eventStartDate = cdate("2020-09-07")	'이벤트 시작일
eventEndDate = cdate("2020-09-21")		'이벤트 종료일
currentDate = date()

userid = GetEncLoginUserID()

%>
<style>
.topic {position:relative; overflow:hidden;}
.topic .moon {position:absolute; left:-40%; top:-40%; z-index:10; width:81.73%; animation:bounce2 1.2s 30; transition:all 2s;}
.topic .num {position:absolute; left:63%; top:2.7%;  z-index:5; width:18.4%; animation:bounce 1.2s 2s 30; transition:all 3s .8s; opacity:0;}
.topic.on .moon {left:-23%; top:-10%;}
.topic.on .num {opacity:1;}
.topic .btn-apply {position:absolute; left:0; bottom:2%; width:100%;}
.topic .my-cart {position:absolute; left:6.4%; top:60.57%; width:87.07%; text-align:center; color:#fff;}
.topic .my-cart div {height:20.33%;}
.topic .my-cart p {padding-top:10.67vw; font:normal 5.4vw/1.1 'CoreSansCBold','NotoSansKRBold';}
.topic .my-cart b {color:#fedc1d;}
.topic .my-cart p.price {display:inline-block; margin-top:3.73vw; padding:0 5.7vw 0 0; font-size:9.7vw; background:url(//webimage.10x10.co.kr/fixevent/event/2020/105500/m/blt_arrow_1.png) no-repeat 100% 36%/2.4vw auto; }
.winner-list {position:relative; padding-bottom:9.6vw; color:#8a9a93; background-color:#284338;}
.winner-list .no-winner {display:flex; justify-content:center; align-items:center; font-size:4vw; padding-top:2vw;}
.winner-list .winner-slider {padding:0 6.4%;}
.winner-list .swiper-slide {width:6.74rem; padding:0 .512rem;}
.winner-list .user-info {text-align:center; font-size:1rem; line-height:1.4;}
.winner-list .user-info > span {display:block;}
.winner-list .user-info .user-grade {margin-bottom:.5rem;}
.winner-list .user-info .user-id {font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;}
.noti {padding-bottom:10.67vw; background-color:#232323;}
.noti button {display:block; position:relative; width:100%; background-color:#232323;}
.noti button:after {content:''; position:absolute; left:50%; top:12.5vw; width:2.67vw; height:1.74vw; margin-left:5%; background:url(//webimage.10x10.co.kr/fixevent/event/2020/105500/m/blt_arrow_2.png) no-repeat 50% 50%/100% auto; transition:all .3s;}
.noti.on button:after {transform: rotate(180deg);}
.noti div {display:none;}
.noti.on div {display:block;}
@keyframes bounce {
    from, to {transform:translate(0,0); animation-timing-function:ease-in;}
    50% {transform:translate(-.5rem,.5rem); animation-timing-function:ease-out;}
}
@keyframes bounce2 {
    from, to {transform:scale(1); animation-timing-function:ease-in;}
    50% {transform:scale(1.01); animation-timing-function:ease-out;}
}
</style>
<script>

var isApp = "<%=isapp%>"
var isApply = false
function jsEventLogin() {
	<% if isApp="1" then %>
		calllogin();
	<% else %>
		jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
	<% end if %>
	return;
}

$(function(){
    $('.topic').addClass('on');

    $('#btnNoti').click(function (e) { 
        e.preventDefault();
        $('.noti').toggleClass('on');
    });
});

function gotoCart() {
    location.href = "/inipay/ShoppingBag.asp"
}

</script>

			<% '<!-- 105499 보름달 --> %>
			<div class="mEvt105499">
                <div class="topic">
                    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/105500/m/tit_moon.png" alt="달님 소원을 들어주세요!"></h2>
                    <div class="moon"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105500/m/img_moon.png" alt=""></div>
                    <div class="num"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105500/m/txt_app.png" alt="APP 전용"></div>

                    <% '<!-- 나의 장바구니 금액 확인하기 --> %>
                    <div class="my-cart">
                        <% if not IsUserLoginOK() then %>
                            <a href="" onclick="jsEventLogin(); return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105500/m/btn_login.png" alt="달님 소원을 들어주세요!"></a>
                        <% else %>
                            <a href="" onclick=<%=chkiif(isapp,"fnAPPpopupBaguni()","gotoCart()")%>>
                                <div>
                                    <p><b><%=GetLoginUserName()%></b>님의 장바구니 금액</p>
                                    <p class="price"><%= FormatNumber(getCartTotalAmount(userid), 0) %>원</p>
                                </div>
                            </a>
                        <% end if %>
                    </div>

                    <!-- 참여버튼 -->
                    <a href="https://tenten.app.link/YJd9CI6aj9?%24deeplink_no_attribution=t" class="btn-apply"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105500/m/btn_down.png" alt="앱 다운받고 참여하기"></a>
                </div>
                <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/105500/m/txt_way_m.png" alt=""></div>
                <div class="noti on">
                    <button id="btnNoti"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105500/m/btn_noti.png" alt="유의사항"></button>
                    <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/105500/m/txt_noti.png" alt=""></div>
                </div>
			</div>
			<% '<!--// 105499 보름달 --> %>

<% IF application("Svr_Info") = "Dev" THEN %>
<script src="https://unpkg.com/vue"></script>
<% Else %>
<script src="/vue/vue.min.js"></script>
<script src="/vue/vue.lazyimg.min.js"></script>
<% End If %>
<script src="/vue/wish/components/wishlist_98974.js?v=1.01"></script>
<script src="/vue/wish/view/index_98974.js?v=1.01"></script>
<!-- #include virtual="/lib/db/dbclose.asp" -->