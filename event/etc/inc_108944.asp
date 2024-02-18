<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 인스타그램 팔로우 이벤트
' History : 2021.01.19 정태훈
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, currentDate, eventStartDate, eventEndDate
IF application("Svr_Info") = "Dev" THEN
	eCode = "104300"
Else
	eCode = "108944"
End If

eventStartDate = cdate("2021-01-21")	'이벤트 시작일
eventEndDate = cdate("2021-02-21")		'이벤트 종료일
currentDate = date()

userid = GetEncLoginUserID()

if userid="ley330" or userid="greenteenz" or userid="rnldusgpfla" or userid="cjw0515" or userid="thensi7" or userid = "motions" or userid = "jj999a" or userid = "phsman1" or userid = "jjia94" or userid = "seojb1983" or userid = "kny9480" or userid = "bestksy0527" or userid = "mame234" or userid = "corpse2" or userid = "starsun726" then
	currentDate = #01/21/2021 09:00:00#
end if
%>
<style>
.bnr-anniv18 {display:none;}
.mEvt108944 {position:relative; overflow:hidden; background:#fff;}
.mEvt108944 .best .items-wrap {position:relative;}
.mEvt108944 .best .item-list {display:flex; flex-wrap:wrap; justify-content:center; position:absolute; left:0; top:0; width:100%; height:100%;}
.mEvt108944 .best .item-list li {position:relative; width:29.3%; height:50%;}
.mEvt108944 .best .item-list li a {display:block; width:100%; height:100%;}
.mEvt108944 .best .like {display:flex; align-items:center; justify-content:center; position:absolute; top:0; left:50%; transform:translateX(-50%); height:5.3vw; padding:0 1.5vw 0 0.5vw; background:#ff1c77; border-radius:1vw; animation:bounce 1s 10;}
.mEvt108944 .best li:nth-child(3n+1) .like {left:28%;}
.mEvt108944 .best li:nth-child(3n) .like {left:72%;}
.mEvt108944 .best .like::before {position:absolute; top:100%; left:50%; width:1.5vw; height:1.5vw; transform:translate(-50%,-50%) rotate(45deg); background:#ff1c77; border-radius:0 0 0.3vw; content:' ';}
.mEvt108944 .best .like .ico-like {position:relative; width:5.3vw; height:5.3vw; background:url(//webimage.10x10.co.kr/fixevent/event/2021/108944/m/ico_like.png) 50% no-repeat; background-size:contain;}
.mEvt108944 .best .like .ico-like::before,
.mEvt108944 .best .like .ico-like::after {position:absolute; background:url(//webimage.10x10.co.kr/fixevent/event/2021/108944/m/ico_like.png) 50% no-repeat; background-size:contain; opacity:0; animation:hearts 3s 10 ease-in; content:' ';}
.mEvt108944 .best .like .ico-like::before {left:0; top:50%; width:2vw; height:2vw;}
.mEvt108944 .best .like .ico-like::after {right:0; top:50%; width:3vw; height:3vw;}
.mEvt108944 .best .like .num {position:relative; padding-top:0.8vw; font-size:3.2vw; color:#fff;}
.mEvt108944 .apply {position:relative;}
.mEvt108944 .apply .input {position:absolute; top:40%; left:15%; width:52%; height:24%; padding:0 4%; font-size:4.2vw; border:0; background:none;}
.mEvt108944 .apply .input::placeholder {color:#999;}
.mEvt108944 .apply .btn-apply {position:absolute; top:40%; right:14%; width:19%; height:24%; font-size:0; color:transparent; background:none;}
.mEvt108944 .info {position:relative; padding-bottom:7%; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; background:#783ec2;}
.mEvt108944 .info .tab {display:flex; padding:0 11%;}
.mEvt108944 .info .tab li {margin-right:2vw;}
.mEvt108944 .info .tab button {min-width:4.5rem; padding:.1em .3em; font-size:1.2rem; color:#999; border:1px solid #999; background:none;}
.mEvt108944 .info .tab li.active button {color:#ff8400; border-color:#ff8400;}
.mEvt108944 .info .txt {padding:1.5rem 11% 1rem; font-size:3.7vw; color:#fff;}
.mEvt108944 .slider {position:relative;}
.mEvt108944 .slider .swiper-slide {width:100%;}
.mEvt108944 .slider button {position:absolute; top:0; z-index:5; width:12%; height:100%; padding-left:1%; font-size:0; color:transparent; background:none;}
.mEvt108944 .slider .btn-prev {left:0; transform:scaleX(-1);}
.mEvt108944 .slider .btn-next {right:0;}
.mEvt108944 .slider button::after {display:block; width:5vw; height:5vw; border:solid #b2b2b2; border-width:1px 1px 0 0; transform:rotate(45deg); content:' ';}
.mEvt108944 .btn-follow {display:block; position:fixed; left:0; bottom:-1px; z-index:10; width:100%; padding:8vw 0; background:#783ec2;}
.mEvt108944 .link .items-wrap {position:relative;}
.mEvt108944 .link .item-list {display:flex; flex-wrap:wrap; position:absolute; left:0; top:0; width:100%; height:100%;}
.mEvt108944 .link .item-list li {width:33.3%; height:25%;}
.mEvt108944 .link .item-list li a {display:block; width:100%; height:100%;}
@keyframes bounce {
	0%,100% {transform:translate(-50%,0); animation-timing-function:ease-out;}
	50% {transform:translate(-50%,-5px); animation-timing-function:ease-in;}
}
@keyframes hearts {
	0% {opacity:0; transform:translate(0,0%);}
	20% {opacity:0.8; transform:translate(0,-20%);}
	100% {opacity:0; transform:translate(0,-200%);}
}
</style>
<script>
$(function() {
	$('.best .like .num').each(function(i, el) {
		$({ val : 0 }).animate({ val : $(el).attr('data-count') }, {
			duration: 2000,
			step: function() {
				var num = numberWithCommas(Math.floor(this.val));
				$(el).text(num);
			},
			complete: function() {
				var num = numberWithCommas(Math.floor(this.val));
				$(el).text(num);
			}
		});
	});
	function numberWithCommas(x) {
		return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
	var infoSwiper = new Swiper('.info .swiper-container', {
		speed: 700,
		autoplay: 3500,
		prevButton: '.info .btn-prev',
		nextButton: '.info .btn-next',
		onSlideChangeStart: function(swiper) {
			$('.info .tab li').eq(swiper.activeIndex).addClass('active').siblings().removeClass('active');
			$('.info .txt').text($(swiper.slides[swiper.activeIndex]).attr('data-copy'));
		}
	});
	$('.info .tab button').on('click', function(e) {
		infoSwiper.slideTo($(this).parent('li').index());
	});
});

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
        if($("#instaID").val()==""){
            alert("ID를 입력해주세요.");
            return false;
        }

        $.ajax({
            type: "POST",
            url:"/event/etc/doeventsubscript/doEventSubScript108944.asp",
            data: {
                mode : 'add',
                id : $("#instaID").val()
            },
            success: function(data){
                if(data.response == 'ok'){
                    fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode','<%=eCode%>')                        
                    alert('신청 되었습니다.');		
                }else{
                    alert(data.message);
                }
            },
            error: function(data){
                alert('시스템 오류입니다.');
            }
        });
    <% else %>
        jsEventLogin();
    <% end if %>
}
</script>
			<div class="mEvt108944">
				<h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/108944/m/tit_instagram.jpg" alt="인스타그램 팔로우 이벤트"></h2>
				<div class="best">
					<div class="items-wrap">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/108944/m/img_best.jpg" alt="">
						<ul class="item-list">
							<li>
								<a href="/category/category_itemPrd.asp?itemid=2215252&pEtr=108944" onclick="TnGotoProduct('2215252');return false;"></a>
								<div class="like"><span class="ico-like"></span><span class="num" data-count="4877">4,877</span></div>
							</li>
							<li>
								<a href="/category/category_itemPrd.asp?itemid=3453503&pEtr=108944" onclick="TnGotoProduct('3453503');return false;"></a>
								<div class="like"><span class="ico-like"></span><span class="num" data-count="4414">4,414</span></div>
							</li>
							<li>
								<a href="/category/category_itemPrd.asp?itemid=2784156&pEtr=108944" onclick="TnGotoProduct('2784156');return false;"></a>
								<div class="like"><span class="ico-like"></span><span class="num" data-count="2637">2,637</span></div>
							</li>
							<li>
								<a href="/category/category_itemPrd.asp?itemid=2698218&pEtr=108944" onclick="TnGotoProduct('2698218');return false;"></a>
								<div class="like"><span class="ico-like"></span><span class="num" data-count="3820">3,820</span></div>
							</li>
							<li>
								<a href="/category/category_itemPrd.asp?itemid=3404599&pEtr=108944" onclick="TnGotoProduct('3404599');return false;"></a>
								<div class="like"><span class="ico-like"></span><span class="num" data-count="8189">8,189</span></div>
							</li>
							<li>
								<a href="/category/category_itemPrd.asp?itemid=3505933&pEtr=108944" onclick="TnGotoProduct('3505933');return false;"></a>
								<div class="like"><span class="ico-like"></span><span class="num" data-count="4377">4,377</span></div>
							</li>
						</ul>
					</div>
					<div class="apply">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/108944/m/txt_apply.jpg" alt="">
						<input type="text" name="instaID" id="instaID" placeholder="ID를 입력해주세요." class="input">
						<button type="button" onclick="doAction();return false;" class="btn-apply">등록</button>
					</div>
				</div>
				<div class="info">
					<h3><img src="//webimage.10x10.co.kr/fixevent/event/2021/108944/m/tit_info.png" alt="텐바이텐 인스타그램은요"></h3>
					<ol class="tab">
						<li class="active"><button type="button">#하나</button></li>
						<li><button type="button">#둘</button></li>
						<li><button type="button">#셋</button></li>
					</ol>
					<div class="txt">최저가 상품 정보를 누구보다 빠르게!</div>
					<div class="slider">
						<div class="swiper-container">
							<div class="swiper-wrapper">
								<div class="swiper-slide" data-copy="최저가 상품 정보를 누구보다 빠르게!"><img src="//webimage.10x10.co.kr/fixevent/event/2021/108944/m/img_info_01.jpg" alt=""></div>
								<div class="swiper-slide" data-copy="혜택이 가득한 이벤트 소식!"><img src="//webimage.10x10.co.kr/fixevent/event/2021/108944/m/img_info_02.jpg" alt=""></div>
								<div class="swiper-slide" data-copy="귀엽고 트렌디한 신상 소개!"><img src="//webimage.10x10.co.kr/fixevent/event/2021/108944/m/img_info_03.jpg" alt=""></div>
							</div>
							<button type="button" class="btn-prev">이전</button>
							<button type="button" class="btn-next">다음</button>
						</div>
					</div>
					<a href="https://tenten.app.link/e/H8qXiNvaQcb?%24deeplink_no_attribution=true" class="btn-follow"><img src="//webimage.10x10.co.kr/fixevent/event/2021/108944/m/btn_follow.png" alt="팔로우 하러 가기"></a>
				</div>
				<div class="link">
					<h3><img src="//webimage.10x10.co.kr/fixevent/event/2021/108944/m/txt_instagram.jpg" alt="인기 상품 구경하기"></h3>
					<div class="items-wrap">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/108944/m/img_feed.jpg" alt="">
						<ul class="item-list">
							<li><a href="/category/category_itemPrd.asp?itemid=3444003&pEtr=108944" onclick="TnGotoProduct('3444003');return false;"></a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=3471203&pEtr=108944" onclick="TnGotoProduct('3471203');return false;"></a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=3370092&pEtr=108944" onclick="TnGotoProduct('3370092');return false;"></a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=3391677&pEtr=108944" onclick="TnGotoProduct('3391677');return false;"></a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=3377820&pEtr=108944" onclick="TnGotoProduct('3377820');return false;"></a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=2805630&pEtr=108944" onclick="TnGotoProduct('2805630');return false;"></a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=3477166&pEtr=108944" onclick="TnGotoProduct('3477166');return false;"></a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=3203180&pEtr=108944" onclick="TnGotoProduct('3203180');return false;"></a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=1658911&pEtr=108944" onclick="TnGotoProduct('1658911');return false;"></a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=3144080&pEtr=108944" onclick="TnGotoProduct('3144080');return false;"></a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=3019218&pEtr=108944" onclick="TnGotoProduct('3019218');return false;"></a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=3000161&pEtr=108944" onclick="TnGotoProduct('3000161');return false;"></a></li>
						</ul>
					</div>
				</div>
				<p><img src="//webimage.10x10.co.kr/fixevent/event/2021/108944/m/txt_notice.jpg" alt="유의사항"></p>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->