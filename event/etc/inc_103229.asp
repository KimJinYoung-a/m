<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 인스타그램 팔로우 이벤트
' History : 2020.06.09 정태훈
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
	eCode = "102181"
Else
	eCode = "103229"
End If

eventStartDate = cdate("2020-06-10")	'이벤트 시작일
eventEndDate = cdate("2020-06-28")		'이벤트 종료일
currentDate = date()

userid = GetEncLoginUserID()

if userid="ley330" or userid="greenteenz" or userid="rnldusgpfla" or userid="cjw0515" or userid="thensi7" or userid = "motions" or userid = "jj999a" or userid = "phsman1" or userid = "jjia94" or userid = "seojb1983" or userid = "kny9480" or userid = "bestksy0527" or userid = "mame234" or userid = "corpse2" or userid = "starsun726" then
	currentDate = #06/10/2020 09:00:00#
end if

if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
end if
%>
<style>
.mEvt103229 {position:relative; overflow:hidden; background:#fff;}
.mEvt103229 .best .items-wrap {position:relative;}
.mEvt103229 .best .item-list {display:flex; flex-wrap:wrap; justify-content:center; position:absolute; left:0; top:0; width:100%; height:100%;}
.mEvt103229 .best .item-list li {position:relative; width:29.3%; height:50%;}
.mEvt103229 .best .item-list li a {display:block; width:100%; height:100%;}
.mEvt103229 .best .like {display:flex; align-items:center; justify-content:center; position:absolute; top:0; left:50%; transform:translateX(-50%); height:5.3vw; padding:0 1.5vw 0 0.5vw; background:#ff1c77; border-radius:1vw; transition:1s;}
.mEvt103229 .best .like .ico-like {position:relative; width:5.3vw; height:5.3vw; background:url(//webimage.10x10.co.kr/fixevent/event/2020/103229/m/ico_like.png) 50% no-repeat; background-size:contain;}
.mEvt103229 .best .like .ico-like:before,
.mEvt103229 .best .like .ico-like:after {content:' '; position:absolute; background:url(//webimage.10x10.co.kr/fixevent/event/2020/103229/m/ico_like.png) 50% no-repeat; background-size:contain; opacity:0; animation:hearts 3s 10 ease-in;}
.mEvt103229 .best .like .ico-like:before {left:0; top:50%; width:2vw; height:2vw;}
.mEvt103229 .best .like .ico-like:after {right:0; top:50%; width:3vw; height:3vw;}
@keyframes hearts {
	0% {opacity:0; transform:translate(0,0%);}
	20% {opacity:0.8; transform:translate(0,-20%);}
	100% {opacity:0; transform:translate(0,-200%);}
}
.mEvt103229 .best .like .num {position:relative; padding-top:0.8vw; font-size:3.2vw; color:#fff;}
.mEvt103229 .best .like:before {content:' '; position:absolute; top:100%; left:50%; width:1.5vw; height:1.5vw; transform:translate(-50%,-50%) rotate(45deg); background:#ff1c77; border-radius:0 0 0.3vw;}
.mEvt103229 .apply {position:relative;}
.mEvt103229 .apply .input {position:absolute; top:40%; left:15%; width:52%; height:24%; padding:0 4%; font-size:4.2vw; border:0; background:none;}
.mEvt103229 .apply .input::placeholder {color:#999;}
.mEvt103229 .apply .btn-apply {position:absolute; top:40%; right:14%; width:19%; height:24%; font-size:0; color:transparent; background:none;}
.mEvt103229 .link .items-wrap {position:relative;}
.mEvt103229 .link .item-list {display:flex; flex-wrap:wrap; position:absolute; left:0; top:0; width:100%; height:100%;}
.mEvt103229 .link .item-list li {width:33.3%; height:25%;}
.mEvt103229 .link .item-list li a {display:block; width:100%; height:100%;}
.mEvt103229 .info {position:relative; padding-bottom:8%; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; background:#ffe7b8;}
.mEvt103229 .info .tab {display:flex; padding:2% 11%;}
.mEvt103229 .info .tab li {margin-right:2vw;}
.mEvt103229 .info .tab button {height:6.4vw; padding:0.6vw 3.6vw; font-size:3.5vw; line-height:5.8vw; color:#999; border:1px solid #999; background:none;}
.mEvt103229 .info .tab li.on button {color:#ff8400; border-color:#ff8400;}
.mEvt103229 .info .copy {padding:3% 11%; font-size:3.7vw; color:#111;}
.mEvt103229 .slider {position:relative;}
.mEvt103229 .slider .swiper-slide {width:100%;}
.mEvt103229 .slider button {position:absolute; top:0; z-index:5; width:12%; height:100%; padding-left:1%; font-size:0; color:transparent; background:none;}
.mEvt103229 .slider .btn-prev {left:0; transform:scaleX(-1);}
.mEvt103229 .slider .btn-next {right:0;}
.mEvt103229 .slider button:after {content:' '; display:block; width:5vw; height:5vw; border:solid #000; border-width:1px 1px 0 0; transform:rotate(45deg);}
.mEvt103229 .slider .swiper-button-disabled:after {border-color:#b2b2b2;}
.mEvt103229 .btn-follow {position:fixed; left:0; bottom:-8vw; z-index:10; width:100%; background:#ffe7b8;}
</style>
<script src="/lib/js/jquery-1.9.1.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-browser/0.1.0/jquery.browser.min.js"></script>
<script>
$(function(){
	var deb = true;
	$(window).on('scroll', function(){
		var wt = $(window).scrollTop(),
			wh = $(window).height(),
			bt = $('.best .items-wrap').offset().top,
			bh = $('.best .items-wrap').height(),
			eb = $('.mEvt103229').offset().top + $('.mEvt103229').height();
		if (wt+wh > bt+bh/2 && deb) {
			countLike();
			deb = false;
		}
		if (wt+wh > eb) {
			$('.btn-follow').fadeOut('fast');
		} else {
			$('.btn-follow').fadeIn('fast');
		}
	});
	var copy = ["최저가 상품 정보를 누구보다 빠르게!", "혜택이 가득한 이벤트 소식!", "귀엽고 트렌디한 신상 소개!"];
	$('.info .tab button').on('click', function(e){
		var idx = $(this).parent('li').index();
		$('.info .tab').find('li').removeClass('on');
		$('.info .tab').find('li').eq(idx).addClass('on');
		$('.info .copy').text(copy[idx]);
		swiper.slideTo(idx+1);
	});
	var swiper = new Swiper('.info .swiper-container', {
		speed: 700,
		autoplay: 3000,
		loop: true,
		prevButton: '.info .btn-prev',
		nextButton: '.info .btn-next',
		onSlideChangeStart: function(swiper) {
			var activeIndex = swiper.activeIndex;
			var realIndex = parseInt(swiper.slides.eq(activeIndex).attr('data-swiper-slide-index') || activeIndex, 10);
			$('.info .tab').find('li').removeClass('on');
			$('.info .tab').find('li').eq(realIndex).addClass('on');
			$('.info .copy').text(copy[realIndex]);
		}
	});
});

function countLike() {
	$('.best .like .num').each(function(i, el) {
		var $this = $(el),
			countTo = $this.attr('data-count');
		$( { countNum: $this.text() } ).animate(
			{ countNum: countTo },
			{
				duration: Math.abs(i-6)*500,
				easing: 'linear',
				step: function() {
					var num = Math.floor(this.countNum);
					if (num > 999) num = num.toLocaleString();
					$this.text(num);
				},
				complete: function() {
					var num = this.countNum;
					if (num > 999) num = num.toLocaleString();
					$this.text(num);
				}
			}
		);
	});
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
        if($("#instaID").val()==""){
            alert("ID를 입력해주세요.");
            return false;
        }

        $.ajax({
            type: "POST",
            url:"/event/etc/doeventsubscript/doEventSubScript103229.asp",
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
			<div class="mEvt103229">
				<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/103229/m/tit_insta.jpg?v=1.0" alt="인스타그램 팔로우 이벤트"></h2>
				<div class="best">
					<h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/103229/m/tit_best.jpg?v=1.0" alt="인스타 인기상품"></h3>
					<div class="items-wrap">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/103229/m/img_best.jpg" alt="">
						<ul class="item-list">
							<li>
								<a href="/category/category_itemPrd.asp?itemid=2820343&pEtr=103229" onclick="TnGotoProduct('2820343');return false;"></a>
								<div class="like"><span class="ico-like"></span><span class="num" data-count="10011">9950</span></div>
							</li>
							<li>
								<a href="/category/category_itemPrd.asp?itemid=2646023&pEtr=103229" onclick="TnGotoProduct('2646023');return false;"></a>
								<div class="like"><span class="ico-like"></span><span class="num" data-count="7354">7304</span></div>
							</li>
							<li>
								<a href="/category/category_itemPrd.asp?itemid=2703852&pEtr=103229" onclick="TnGotoProduct('2703852');return false;"></a>
								<div class="like"><span class="ico-like"></span><span class="num" data-count="6338">6300</span></div>
							</li>
							<li>
								<a href="/category/category_itemPrd.asp?itemid=2662083&pEtr=103229" onclick="TnGotoProduct('2662083');return false;"></a>
								<div class="like"><span class="ico-like"></span><span class="num" data-count="5906">5876</span></div>
							</li>
							<li>
								<a href="/category/category_itemPrd.asp?itemid=2788824&pEtr=103229" onclick="TnGotoProduct('2788824');return false;"></a>
								<div class="like"><span class="ico-like"></span><span class="num" data-count="5128">5108</span></div>
							</li>
							<li>
								<a href="/category/category_itemPrd.asp?itemid=2808770&pEtr=103229" onclick="TnGotoProduct('2808770');return false;"></a>
								<div class="like"><span class="ico-like"></span><span class="num" data-count="4713">4703</span></div>
							</li>
						</ul>
					</div>
					<div class="apply">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/103229/m/txt_apply.jpg?v=1.0" alt="">
						<input type="text" name="instaID" id="instaID" placeholder="ID를 입력해주세요." class="input">
						<button type="button" onclick="doAction();return false;" class="btn-apply">등록</button>
					</div>
				</div>
				<div class="info">
					<h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/103229/m/tit_info.png?v=1.0" alt="텐바이텐 인스타그램은요"></h3>
					<ol class="tab">
						<li class="on"><button type="button">#하나</button></li>
						<li><button type="button">#둘</button></li>
						<li><button type="button">#셋</button></li>
					</ol>
					<div class="copy">최저가 상품 정보를 누구보다 빠르게!</div>
					<div class="slider">
						<div class="swiper-container">
							<div class="swiper-wrapper">
								<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103229/m/img_slide_01.png?v=1.0" alt=""></div>
								<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103229/m/img_slide_02.png" alt=""></div>
								<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103229/m/img_slide_03.png" alt=""></div>
							</div>
							<button type="button" class="btn-prev">이전</button>
							<button type="button" class="btn-next">다음</button>
						</div>
					</div>
					<a href="https://tenten.app.link/e/PMbHHKzqS6" class="btn-follow"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103229/m/btn_follow.png" alt="팔로우 하러 가기"></a>
				</div>
				<div class="link">
					<h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/103229/m/tit_link.jpg" alt="인기 상품 구경하기"></h3>
					<div class="items-wrap">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/103229/m/img_link.jpg" alt="">
						<ul class="item-list">
							<li><a href="/category/category_itemPrd.asp?itemid=2878040&pEtr=103229" onclick="TnGotoProduct('2878040');return false;"></a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=2886718&pEtr=103229" onclick="TnGotoProduct('2886718');return false;"></a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=2784155&pEtr=103229" onclick="TnGotoProduct('2784155');return false;"></a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=2543514&pEtr=103229" onclick="TnGotoProduct('2543514');return false;"></a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=2813234&pEtr=103229" onclick="TnGotoProduct('2813234');return false;"></a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=2824973&pEtr=103229" onclick="TnGotoProduct('2824973');return false;"></a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=2856992&pEtr=103229" onclick="TnGotoProduct('2856992');return false;"></a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=2785591&pEtr=103229" onclick="TnGotoProduct('2785591');return false;"></a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=2777555&pEtr=103229" onclick="TnGotoProduct('2777555');return false;"></a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=2805630&pEtr=103229" onclick="TnGotoProduct('2805630');return false;"></a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=2778607&pEtr=103229" onclick="TnGotoProduct('2778607');return false;"></a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=2595914&pEtr=103229" onclick="TnGotoProduct('2595914');return false;"></a></li>
						</ul>
					</div>
				</div>
				<div class="noti"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103229/m/txt_noti.jpg" alt="유의사항"></div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->