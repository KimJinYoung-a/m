<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 보름달 장바구니 이벤트
' History : 2019-09-04 이종화
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, currentDate , subscriptcount , eventStartDate , eventEndDate
IF application("Svr_Info") = "Dev" THEN
	eCode = "90381"
Else
	eCode = "97105"
End If

eventStartDate = cdate("2019-09-05")	'이벤트 시작일
eventEndDate = cdate("2019-09-18")		'이벤트 종료일
currentDate = date()

userid = GetEncLoginUserID()

if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
end if

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("[달님 소원을 들어주세요!]")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2019/97105/m/img_bnr_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = " [달님 소원을 들어주세요!]"
Dim kakaodescription : kakaodescription = "100만원 이상 상품을 장바구니에 담으면 달님이 대신 결제해드립니다!"
Dim kakaooldver : kakaooldver = "100만원 이상 상품을 장바구니에 담으면 달님이 대신 결제해드립니다!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2019/97105/m/img_bnr_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink 
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode

%>
<style type="text/css">
[v-cloak] { display: none; }
.mEvt97105 {position:relative; z-index:0; background-color:#282c5b;}
.mEvt97105 button {background-color:transparent;}
.top {position:relative; width:32rem; margin:0 auto; text-align:center;}
.top h2 {position:absolute; top:0; left:0; z-index:-1;}
.top .thumb-moon {overflow:hidden; display:inline-block; width:27.77rem; height:27.77rem; margin:2.69rem auto 0;}
.top .thumb-moon img {margin-top:27.77rem; transition:all 1.2s ease-in-out;}
.top .thumb-moon.rise img {margin-top:0;}
.top .num {display:inline-block; position:absolute; top:26.79rem; right:.8rem; width:5.9rem; height:4.2rem; animation:.5s swing ease-in-out infinite alternate; transform-origin:50% 100%;}
.top .bg-star {position:absolute; top:0; left:0; width:100%; height:26.97rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/97105/m/img_star1.png) repeat-x 50% 0; background-size:32rem auto; opacity:0; animation-name:twinkle1; animation-duration:1.5s; animation-delay:1s; animation-iteration-count:infinite;}
.top .bg-star:after,
.top .bg-star:before {display:inline-block;position:absolute; top:0; left:0; width:100%; height:100%; background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/97105/m/img_star2.png); background-repeat:repeat-x; background-position:50% 0; background-size:32rem auto; opacity:0; content:''; animation-name:twinkle1; animation-duration:.8s; animation-delay:1s; animation-iteration-count:infinite;}
.top .bg-star:after {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/97105/m/img_star3.png); animation-delay:1.2s;}
@keyframes pulse { 0% {transform:scale(1);} 50% {transform:scale(0.8);} 100% {transform:scale(1);} }
@keyframes twinkle1 { from,to {opacity:.2;} 50% {opacity:1;} }
@keyframes swing { 0% {transform:rotate(7deg);} 100% {transform:rotate(-7deg);} }
.top .btn-apply {margin-top:9.4rem; animation-name:pulse; animation-duration:1.2s; animation-fill-mode:both; animation-iteration-count:infinite;}
.evt {position:relative;}
.evt ul {position:absolute; top:0; left:0; display:flex; width:100%; height:100%;}
.evt ul li {flex-basis:50%;}
.evt ul li a {display:block; width:100%; height:100%; text-indent:-999em;}
.sns {position:relative;}
.sns ul {display:flex; position:absolute; bottom:0; right:7.6%; width:44.27%; height:85%;}
.sns ul li {width:50%; height:100%;}
.sns ul li a {display:block; width:100%; height:100%; text-indent:-999em;}
.noti {background-color:#c2caea;}
.noti ul {padding:0 1.7rem 4.26rem;}
.noti ul li {margin-top:.85rem; padding-left:.7rem; font-size:1rem; line-height:2; text-indent:-.7rem; font-family:'AvenirNext-Medium', 'AppleSDGothicNeo-Medium';}
.noti ul li strong {text-decoration:underline;}
.wish-list {background-color:#f6f7fc;}
.wish-list ul {display:flex; flex-wrap:wrap; width:29.87rem; margin:0 auto; padding-top:.43rem;}
.wish-list li {flex-basis:50%; padding:0 .64rem; margin-top:1.28rem;}
.wish-list .thumbnail {width:13.65rem;}
.wish-list .desc {padding:.77rem .77rem 0 .77rem; background-color:#fff; color:#222;}
.wish-list .name {overflow:hidden; display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; height:3.3rem; padding-right:0; font-size:1.1rem; line-height:1.5; text-overflow:ellipsis;}
.wish-list .price {margin:.77rem 0 .85rem; font-size:1.28rem; font-family:'roboto', 'AvenirNext-Medium', 'AppleSDGothicNeo-Medium'; font-weight:bold;}
.wish-list .unit {display:inline-block; margin:0 .54rem 0 .17rem; font-size:1.03rem;}
.wish-list  .sale {color:#ff3232;}
.wish-list .btn-bag {position:relative; width:100%; padding:.94rem 1.28rem 1.07rem 0; border-top:solid #ccc .043rem; background-color:transparent; color:#999;}
.wish-list .btn-bag:after {display:inline-block; position:absolute; top:50%; right:2.43rem; width:.55rem; height:.55rem; margin-top:-.3rem; border-width:0 .043rem .043rem 0; border-color:#999; border-style:solid; transform:rotate(-45deg); content:'';}
.lyrComp {display:flex; justify-content:center; align-items:center; position:fixed; top:0; left:0; width:100vw; height:100vh; background-color:rgba(0,0,0,.6);}
.lyrComp .layer {position:relative; width:27.52rem; margin:0 auto; background-color:#fff;}
.lyrComp .btn-close {position:absolute; top:.7rem; right:.7rem; width:3.58rem;}
</style>
<script>
var isApp = "<%=isapp%>"
$(function() {
    $('.thumb-moon').addClass('rise');
});

function closeLyr() {
    $('.lyrComp').hide();
}

function jsEventLogin() {
	<% if isApp="1" then %>
		calllogin();
	<% else %>
		jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
	<% end if %>
	return;
}

function doAction() {
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
    <% end if %>
    <% If IsUserLoginOK() Then %>
        <% if subscriptcount > 0 then %>
            alert('이미 참여 하셨습니다.\n장바구니에 100만원 이상 상품을 채워주세요.\n당첨자 발표일은 9월 20일 입니다.');
            return false;
        <% else %>
            var str = $.ajax({
                type: "GET",
                url:"/event/etc/doeventsubscript/doEventSubscript97105.asp",
                data: "",
                dataType: "text",
                async: false
            }).responseText;	
            if(!str){alert("시스템 오류입니다."); return false;}
            var reStr = str.split("|");
            if(reStr[0]=="OK"){
                fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode','<%=eCode%>')
                $('.lyrComp').show();		
                return false;
            }else{
                var errorMsg = reStr[1].replace(">?n", "\n");
                alert(errorMsg);
                return false;
            }
        <% end if %>
    <% else %>
        jsEventLogin();
    <% end if %>
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
</script>
<div class="mEvt97105">
    <div class="top">
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/97105/m/tit_moon.png?v=1.01" alt="달님 소원을 들어주세요!"></h2>
        <span class="thumb-moon"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97105/m/img_moon.png" alt=""></span>
        <span class="num"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97105/m/txt_num.png" alt="10명"></span>
        <%'!-- 참여하기 버튼 --%>
        <button type="button" class="btn-apply" onclick="doAction()"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97105/m/btn_apply.png?v=1.01" alt="참여하기"></button>
        <span class="bg-star"></span>
        <%'!-- 응모 완료 레이어 --%>
        <div id="lyrComp" class="lyrComp" onclick="closeLyr();" style="display:none;">
            <div class="layer">
                <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/97105/m/txt_comp.png?v=1.01" alt="신청되었습니다! 이제 장바구니를 채우면 자동 응모됩니다. 100만원이상 장바구니에 상품을 담아주세요!" /></p>
                <div class="tip">
                    <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/97105/m/tit_tip2.png" alt="장바구니 간단하게 채우는 방법! " /></p>
                    <div class="evt">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/97105/m/img_evt2.png" alt="">
                        <ul>
                            <li><a href="/event/eventmain.asp?eventid=91839" onclick="jsEventlinkURL(91839);return false;">텐바이텐은 처음이지?</a></li>
                            <li><a href="/event/eventmain.asp?eventid=97011" onclick="jsEventlinkURL(97011);return false;">두근두근 새출발 집꾸미기</a></li>
                        </ul>
                    </div>
                </div>
                <button type="button" class="btn-close" onclick="closeLyr();"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97105/m/btn_close.png" alt="닫기"></button>
            </div>
        </div>
        <%'!--// 응모 완료 레이어 --%>
    </div>
    <div class="conts">
        <div class="way"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97105/m/txt_way.png?v=1.01" alt="참여 방법  신청하기 버튼을 클릭한 후 상품을 100만 원 이상 장바구니에 담는다 당첨일 9월 20일을 기다린다!"></div>
        <div class="prize"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97105/m/txt_prize.png?v=1.02" alt="소원을 들어주는 기프트카드 100만 원 권 (10명)"></div>
        <div class="tip">
            <p class="tit"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97105/m/tit_tip.png" alt="장바구니를 쉽게 채우는 방법"></p>
            <div class="evt">
                <img src="//webimage.10x10.co.kr/fixevent/event/2019/97105/m/img_evt.png" alt="">
                <ul>
                    <li><a href="/event/eventmain.asp?eventid=91839" onclick="jsEventlinkURL(91839);return false;">텐바이텐은 처음이지?</a></li>
                    <li><a href="/event/eventmain.asp?eventid=97011" onclick="jsEventlinkURL(97011);return false;">두근두근 새출발 집꾸미기</a></li>
                </ul>
            </div>
        </div>
        <%'!-- sns 공유 --%>
        <div class="sns">
            <img src="//webimage.10x10.co.kr/fixevent/event/2019/97105/m/img_sns.png" alt="친구들에게 이벤트 소문내기">
            <ul>
                <li><a href="javascript:snschk('fb');">페이스북 공유</a></li>
                <li><a href="javascript:snschk('kk');">카카오톡 공유</a></li>
            </ul>
        </div>
        <%'!--// sns 공유 --%>
    </div>
    <div class="noti">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/97105/m/tit_noti.png" alt="유의사항"></h3>
        <ul>
            <li>- 모바일에서 장바구니 버튼은 상품 '구매하기' 버튼을 클릭했을 때 확인할 수 있습니다.</li>
            <li>- 이벤트 기간은 9월 6일(금)부터 9월 18일(수) 자정까지입니다.</li>
            <li>- 장바구니에 담은 모든 상품의 결제 금액(상품 총금액 + 배송비)이 <strong>1,000,000원 이상이면 자동 응모되며, 최대 금액은 제한이 없습니다.</strong></li>
            <li>- <strong>9월 18일 자정 기준</strong>으로 1,000,000원 이상이어야 합니다.</li>
            <li>- 당첨자는 9월 20일 공지사항에 기재 및 개별 연락드릴 예정입니다.</li>
            <li>- 당첨자 10분에게는 텐바이텐에서 사용 가능한 기프트카드 1,000,000원 권이 지급됩니다.</li>
            <li>- 당첨자에게는 세무신고를 위해 개인정보를 요청할 예정이며, 제세공과금은 텐바이텐 부담입니다.</li>
        </ul>
    </div>
    <div id="wishlist" v-cloak></div>
</div>
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
<script src="/vue/wish/components/wishlist.js?v=1.01"></script>
<script src="/vue/wish/view/index.js?v=1.01"></script>
<!-- #include virtual="/lib/db/dbclose.asp" -->