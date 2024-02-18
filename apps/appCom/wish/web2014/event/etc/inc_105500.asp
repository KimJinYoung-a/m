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
dim eCode, moECode, userid, currentDate , subscriptcount , eventStartDate , eventEndDate
IF application("Svr_Info") = "Dev" THEN
	eCode = "102221"
	moECode = "102220"
Else
	eCode = "105500"
	moECode = "105499"
End If

eventStartDate = cdate("2020-09-07")	'이벤트 시작일
eventEndDate = cdate("2020-09-21")		'이벤트 종료일
currentDate = date()

userid = GetEncLoginUserID()

'if userid="ley330" or userid="greenteenz" or userid="rnldusgpfla" or userid="cjw0515" or userid="thensi7" or userid = "motions" or userid = "jj999a" or userid = "phsman1" or userid = "jjia94" or userid = "seojb1983" or userid = "kny9480" or userid = "bestksy0527" or userid = "mame234" or userid = "corpse2" or userid = "bora2116" or userid = "tozzinet" then
'	currentDate = #09/07/2020 09:00:00#
'end if

if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
end if

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("[달님이 소원을 들어드립니다]")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/105500/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = " [달님이 소원을 들어드립니다]"
Dim kakaodescription : kakaodescription = "장바구니에 100만원 이상 담으면 달님이 대신 결제해드립니다! 서둘러 참여하세요."
Dim kakaooldver : kakaooldver = "장바구니에 100만원 이상 담으면 달님이 대신 결제해드립니다! 서둘러 참여하세요."
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/105500/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink 
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& moECode
%>
<style>
.mEvt105500 button {background-color:transparent;}

.topic {position:relative; overflow:hidden;}
.topic .moon {position:absolute; left:-40%; top:-40%; z-index:10; width:81.73%; animation:bounce2 1.2s 30; transition:all 2s;}
.topic .num {position:absolute; left:63%; top:2.7%;  z-index:5; width:18.4%; animation:bounce 1.2s 2s 30; transition:all 3s .5s; opacity:0;}
.topic.on .moon {left:-23%; top:-10%;}
.topic.on .num {opacity:1;}
.topic .btn-apply {position:absolute; left:0; bottom:2%; width:100%;}
.topic .my-cart {position:absolute; left:6.4%; top:60.57%; width:87.07%; text-align:center; color:#fff;}
.topic .my-cart div {height:20.33%;}
.topic .my-cart p {padding-top:10.67vw; font:normal 5.4vw/1.1 'CoreSansCBold','NotoSansKRBold';}
.topic .my-cart b {color:#fedc1d;}
.topic .my-cart p.price {display:inline-block; margin-top:3.73vw; padding:0 5.7vw 0 0; font-size:9.7vw; background:url(//webimage.10x10.co.kr/fixevent/event/2020/105500/m/blt_arrow_1.png) no-repeat 100% 36%/2.4vw auto;}
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
.others-list .items {margin-top:-2.77rem; padding-bottom:3rem; border-top:none;}
.others-list .items ul {padding:0 .85rem; margin-bottom:1.71rem;}
.others-list .items li {padding-top:2.77rem;}
.others-list .items .thumbnail {width:14.29rem; height:14.29rem; border-radius:.68rem;}
.others-list .items .desc {height:6.4rem; margin:0; padding-top:0.98rem;}
.others-list .items .desc .name {height:3.22rem; margin:.5rem .2rem; font-size:1.15rem; line-height:1.4;}
.others-list .items .desc .price {margin-top:0;}
.others-list .items .desc .price b {font-size:1.37rem; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.others-list .items .desc .price .discount {color:#ff2b74; font-size:1.15rem; margin-left:.4rem; font-family:'CoreSansCMedium';}
.others-list .items .desc .price .color-green {color:#00cfcb;}
.others-list .items .desc .won {display:none;}
.lyrComp {display:flex; justify-content:center; align-items:center; position:fixed; top:0; left:0; z-index:100; width:100vw; height:100vh; background-color:rgba(40,42,67,.98);}
.lyrComp .layer {position:relative;}
.lyrComp .btn-close {position:absolute; top:-1.5%; right:4%; width:4rem; height:4rem; color:transparent;}
.lyrComp .evt {position:absolute; left:0; bottom:0; width:100%; height:23%; color:transparent;}
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
 function closeLyr() {$('.lyrComp').hide();}
 //function openLyr() {$('.lyrComp').show();}
$(function(){
    $('.topic').addClass('on');

    // winner slider
	if ( $('#winner_slider').find('.swiper-slide').length > 0 ) {
		var swiper = new Swiper('#winner_slider', {
			slidesPerView: 'auto'
		});
	} else {
        $('#winner_slider').prepend('<p class="no-winner">당첨자가 없습니다.</p>');
	}

    $('#btnNoti').click(function (e) { 
        e.preventDefault();
        $('.noti').toggleClass('on');
    });
});

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
function doAction() {
    if(isApply) return false;
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
    <% end if %>
    <% If IsUserLoginOK() Then %>
            $.ajax({
                type: "POST",
                url:"/event/etc/doeventsubscript/doEventSubScript105500.asp",
                data: {
                    mode: 'add'
                },
                success: function(data){
                    if(data.response == 'ok'){
                        fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode','<%=eCode%>')                        
                        isApply = true
                        $("#btnImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2020/105500/m/btn_finish.png")
                        $('.lyrComp').show();		
                    }else{
                        alert(data.message);
                    }
                },
                error: function(data){
                    alert('시스템 오류입니다.');
                }
            })
    <% else %>
        jsEventLogin();
    <% end if %>
}
function getCartTotalAmount(){
    $.ajax({
        type: "GET",
        url:"/event/etc/doeventsubscript/doEventSubScript105500.asp",
        data: {
            mode: 'cart'
        },
        success: function(data){
            if(data.response == 'ok'){
                $("#totalAmount").text(data.cartTotalAmount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","))
            }else{
                alert(data.message)
            }
        },
        error: function(data){
            alert('시스템 오류입니다.')
        }
    })    
}
function snschk(snsnum) {		
    if(snsnum=="fb"){
        <% if isapp then %>
        fnAPPShareSNS('fb','<%=appfblink%>');
        return false;
        <% else %>
        popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
        <% end if %>
    }else{
        <% if isapp then %>		
            fnAPPshareKakao('etc','<%=kakaotitle%>','<%=kakaoWebLink%>','<%=kakaoMobileLink%>','<%="url="&kakaoAppLink%>','<%=kakaoimage%>','','','','<%=kakaodescription%>');
            return false;
        <% else %>
            event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaoMobileLink%>' );	
        <% end if %>
    }		
}
function fnsbagly(){
    
}

// 카카오 SNS 공유 v2.0
function event_sendkakao(label , description , imageurl , linkurl){	
    Kakao.Link.sendDefault({
        objectType: 'feed',
        content: {
            title: label,
            description : description,
            imageUrl: imageurl,
            link: {
            mobileWebUrl: linkurl
            }
        },
        buttons: [
            {
            title: '웹으로 보기',
            link: {
                mobileWebUrl: linkurl
            }
            }
        ]
    });
}

function gotoCart() {
    location.href = "/inipay/ShoppingBag.asp"
}
</script>

			<% '<!-- 105500 보름달 --> %>
			<div class="mEvt105500">
                <div class="topic">
                    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/105500/m/tit_moon.png" alt="달님 소원을 들어주세요!"></h2>
                    <div class="moon"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105500/m/img_moon.png" alt=""></div>
                    <div class="num"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105500/m/txt_number.png" alt="10명"></div>

                    <% '<!-- 나의 장바구니 금액 확인하기 --> %>
                    <div class="my-cart">
                        <% if not IsUserLoginOK() then %>
                            <a href="" onclick="jsEventLogin(); return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105500/m/btn_login.png" alt="달님 소원을 들어주세요!"></a>
                        <% else %>
                            
                                <div onclick=<%=chkiif(isapp,"fnAPPpopupBaguni(); return false;","gotoCart(); return false;")%>>
                                    <p><b><%=GetLoginUserName()%></b>님의 장바구니 금액</p>
                                    <p class="price" id="totalAmount"><%= FormatNumber(getCartTotalAmount(userid), 0) %>원</p>
                                </div>
                            
                        <% end if %>
                    </div>

                    <% '<!-- 참여버튼 --> %>
                    <% if subscriptcount > 0 then %>
                        <div class="btn-apply"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105500/m/btn_finish.png" alt="참여완료"></div>
                    <% else %>
                        <button type="button" class="btn-apply" onclick="doAction();"><img id="btnImg" src="//webimage.10x10.co.kr/fixevent/event/2020/105500/m/btn_apply.png" alt="참여하기"></button>
                    <% end if %>

                    <% '<!-- 응모 완료 레이어 --> %>
                    <div id="lyrComp" class="lyrComp" onclick="closeLyr();" style="display:none;">
                        <div class="layer">
                            <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/105500/m/img_pop.png?v=2" alt="100만원 담기 성공! 이벤트 참여가 완료되었습니다" /></p>
                            <button type="button" class="btn-close" onclick="closeLyr();">닫기</button>
                            <a class="evt" href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=105176');return false;">추석 선물세트 추천 기획전</a>
                        </div>
                    </div>
                    <% '<!--// 응모 완료 레이어 --> %>
                </div>
                <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/105500/m/txt_way.png?v=2" alt=""></div>
                <% '<!-- 당첨자 리스트 --> %>
                <div id="winner_list" class="winner-list">
                    <p>
                        <% if currentDate<"2020-09-08" then %>
                            <% '<!-- 9/7 노출 --> %>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2020/105500/m/txt_winner_1.png" alt="">
                        <% else %>
                            <% '<!-- 9/8부터 %>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2020/105500/m/txt_winner_2.png" alt="">
                        <% end if %>
                    </p>
                    <div id="winner_slider" class="winner-slider swiper-container">
                        <ul class="swiper-wrapper">
                            <% '<!-- for dev msg : 당첨자 리스트 - 회원등급 ( 이미지 파일명 ico_ white red vip gold vvip ) --> %>
                            <% If Now() > #09/21/2020 14:00:00# Then %>
                                <li class="swiper-slide">
                                    <div class="user-info">
                                        <span class="user-grade"><img src="//fiximage.10x10.co.kr/m/2018/common/ico_white.png" alt=""></span>
                                        <span class="user-id"><%= printUserId("yybin072400",2,"**") %></span>
                                        <span class="user-name"><%= printUserId("양유빈",1,"*") %></span>
                                    </div>
                                </li>
                            <% end if %>
                            <% If Now() > #09/18/2020 14:00:00# Then %>
                                <li class="swiper-slide">
                                    <div class="user-info">
                                        <span class="user-grade"><img src="//fiximage.10x10.co.kr/m/2018/common/ico_red.png" alt=""></span>
                                        <span class="user-id"><%= printUserId("neosj05",2,"**") %></span>
                                        <span class="user-name"><%= printUserId("이수진",1,"*") %></span>
                                    </div>
                                </li>
                            <% end if %>
                            <% If Now() > #09/17/2020 14:00:00# Then %>
                                <li class="swiper-slide">
                                    <div class="user-info">
                                        <span class="user-grade"><img src="//fiximage.10x10.co.kr/m/2018/common/ico_vip.png" alt=""></span>
                                        <span class="user-id"><%= printUserId("chlajd0153",2,"**") %></span>
                                        <span class="user-name"><%= printUserId("최수지",1,"*") %></span>
                                    </div>
                                </li>
                            <% end if %>
                            <% If Now() > #09/16/2020 14:00:00# Then %>
                                <li class="swiper-slide">
                                    <div class="user-info">
                                        <span class="user-grade"><img src="//fiximage.10x10.co.kr/m/2018/common/ico_red.png" alt=""></span>
                                        <span class="user-id"><%= printUserId("moonyh96",2,"**") %></span>
                                        <span class="user-name"><%= printUserId("문소정",1,"*") %></span>
                                    </div>
                                </li>
                            <% end if %>
                            <% If Now() > #09/15/2020 14:00:00# Then %>
                                <li class="swiper-slide">
                                    <div class="user-info">
                                        <span class="user-grade"><img src="//fiximage.10x10.co.kr/m/2018/common/ico_white.png" alt=""></span>
                                        <span class="user-id"><%= printUserId("shyoona",2,"**") %></span>
                                        <span class="user-name"><%= printUserId("윤상훈",1,"*") %></span>
                                    </div>
                                </li>
                            <% end if %>
                            <% If Now() > #09/14/2020 14:00:00# Then %>
                                <li class="swiper-slide">
                                    <div class="user-info">
                                        <span class="user-grade"><img src="//fiximage.10x10.co.kr/m/2018/common/ico_red.png" alt=""></span>
                                        <span class="user-id"><%= printUserId("qr1324",2,"**") %></span>
                                        <span class="user-name"><%= printUserId("황예지",1,"*") %></span>
                                    </div>
                                </li>
                            <% end if %>
                            <% If Now() > #09/11/2020 14:00:00# Then %>
                                <li class="swiper-slide">
                                    <div class="user-info">
                                        <span class="user-grade"><img src="//fiximage.10x10.co.kr/m/2018/common/ico_white.png" alt=""></span>
                                        <span class="user-id"><%= printUserId("hoso0906",2,"**") %></span>
                                        <span class="user-name"><%= printUserId("정주희",1,"*") %></span>
                                    </div>
                                </li>
                            <% end if %>
                            <% If Now() > #09/10/2020 14:00:00# Then %>
                                <li class="swiper-slide">
                                    <div class="user-info">
                                        <span class="user-grade"><img src="//fiximage.10x10.co.kr/m/2018/common/ico_white.png" alt=""></span>
                                        <span class="user-id"><%= printUserId("gpwewepg",2,"**") %></span>
                                        <span class="user-name"><%= printUserId("최주영",1,"*") %></span>
                                    </div>
                                </li>
                            <% end if %>
                            <% If Now() > #09/09/2020 14:00:00# Then %>
                                <li class="swiper-slide">
                                    <div class="user-info">
                                        <span class="user-grade"><img src="//fiximage.10x10.co.kr/m/2018/common/ico_gold.png" alt=""></span>
                                        <span class="user-id"><%= printUserId("insyang22",2,"**") %></span>
                                        <span class="user-name"><%= printUserId("연진경",1,"*") %></span>
                                    </div>
                                </li>
                            <% end if %>
                            <% If Now() > #09/08/2020 14:00:00# Then %>
                                <li class="swiper-slide">
                                    <div class="user-info">
                                        <span class="user-grade"><img src="//fiximage.10x10.co.kr/m/2018/common/ico_gold.png" alt=""></span>
                                        <span class="user-id"><%= printUserId("happy4028",2,"**") %></span>
                                        <span class="user-name"><%= printUserId("유승례",1,"*") %></span>
                                    </div>
                                </li>
                            <% end if %>
                            <%
                            '//fiximage.10x10.co.kr/m/2018/common/ico_vvip.png
                            '//fiximage.10x10.co.kr/m/2018/common/ico_red.png
                            '//fiximage.10x10.co.kr/m/2018/common/ico_white.png
                            '//fiximage.10x10.co.kr/m/2018/common/ico_vip.png
                            '//fiximage.10x10.co.kr/m/2018/common/ico_gold.png
                            %>
                        </ul>
                    </div>
                </div>

                <% '<!-- 카카오 공유 --> %>
                <div class="sns">
                    <a href="" onclick="snschk('ka'); return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105500/m/btn_kakao.png" alt="친구들에게도 빨리 알려주세요!"></a>
                    <% '<!-- 카카오 공유 이미지 http://webimage.10x10.co.kr/fixevent/event/2020/105500/m/img_kakao.jpg --> %>
                </div>

                <a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=105176');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105500/m/img_event.png" alt="장바구니 쉽게 채우는 법!"></a>

                <div class="noti on">
                    <button id="btnNoti"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105500/m/btn_noti.png" alt="유의사항"></button>
                    <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/105500/m/txt_noti.png" alt=""></div>
                </div>

                <% '<!-- 다른 사람들은.. --> %>
                <div class="others-list">
                    <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/105500/m/tit_others.png" alt="다른 사람들은 어떤 상품을 담았을까?"></p>
                    <div class="items type-grid" id="wishlist" v-cloak></div>
                </div>
			</div>
			<% '<!--// 105500 보름달 --> %>

<form name="sbagfrm" method="post" action="" style="margin:0px;">
    <input type="hidden" name="mode" value="add" />
    <input type="hidden" name="itemid" value="" />
    <input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
    <input type="hidden" name="itemoption" value="0000" />
    <input type="hidden" name="itemea" readonly value="1" />    
</form>
<iframe src="" name="iiBagWin" frameborder="0" width="0" height="0" style="display:none"></iframe>
<% IF application("Svr_Info") = "Dev" THEN %>
<script src="https://unpkg.com/vue"></script>
<% Else %>
<script src="/vue/vue.min.js"></script>
<script src="/vue/vue.lazyimg.min.js"></script>
<% End If %>
<script src="/vue/wish/components/wishlist_105500.js?v=1.01"></script>
<script src="/vue/wish/view/index_105500.js?v=1.01"></script>
<!-- #include virtual="/lib/db/dbclose.asp" -->
