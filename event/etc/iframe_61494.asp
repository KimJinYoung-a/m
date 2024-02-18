<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<style type="text/css">
.aprilHoney img {vertical-align:top;}
.aprilHoney button {background-color:transparent;}

.honeyDaily .topic {background-color:#fff;}
.honeyDaily .topic h1 {visibility:hidden; width:0; height:0;}
.honeyDaily .topic .btnmore {width:68.75%; margin:0 auto;}
.photolist {padding-top:30px;}
.honeyDaily .photo {padding:8% 0; background-color:#fffdf8;}

.noti {padding:30px 10px; border-top:3px solid #ffde9f; background-color:#fffce9;}
.noti h2 {color:#444; font-size:13px; line-height:1.25em;}
.noti h2 span {position:relative; padding:0 10px;}
.noti h2 span:after, .noti h2 span:before {content:' '; position:absolute; top:50%; width:2px; height:12px; margin-top:-6px; background-color:#ffcd70;}
.noti h2 span:after {left:0;}
.noti h2 span:before {right:0;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; margin-top:2px; padding-left:10px; color:#555; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:4px; left:0; width:2px; height:2px; border:2px solid #ffb69c; border-radius:50%; background-color:transparent;}

.bnr {border-top:3px solid #fff;}
@media all and (min-width:480px){
	.noti {padding:45px 15px;}
	.noti h2 {font-size:20px;}
	.noti h2 span {padding:0 15px;}
	.noti h2 span:after, .noti h2 span:before {width:3px; height:18px; margin-top:-9px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:4px; padding-left:15px; font-size:16px;}
	.noti ul li:after {top:6px; width:3px; height:3px; border:3px solid #ffb69c;}
}
</style>
</head>
<body>
<div class="evtCont">
	<div class="aprilHoney">
		<div class="honeyDaily">
			<div class="topic">
				<h1>일상다반사</h1>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60834/m/txt_daily.png" alt="당신의 일상 속에 붙여 주세요! 이벤트 기간 동안 텐바이텐를 받는 모두에게 꿀맛스티커를 선물로 드립니다 선착순, 소진 시 완료" /></p>
				<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/60834/m/img_item.jpg" alt="" /></div>
				<% if isApp then %>
				<div class="btnmore app">
					<a href="" onclick="parent.fnAPPpopupPlay_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/play/playGround.asp?idx=180&contentsidx=79');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60834/m/btn_more.png" alt="PLAY GROUND에서 더 자세히 보세요" /></a>
				</div>
				<% else %>
				<div class="btnmore mo">
					<a href="/play/playGround.asp?idx=180&amp;contentsidx=79" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60834/m/btn_more.png" alt="PLAY GROUND에서 더 자세히 보세요" /></a>
				</div>
				<% end if %>
			</div>

			<div class="put">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60834/m/txt_put.png" alt="꿀맛 스티커를 당신의 일상에 붙여주세요! 배송상자에 담긴 꿀맛 스티커를 인스타그램에 #텐바이텐꿀맛 해시태그와 함께 예쁜 인증샷으로 남겨주시면 총 50분을 추첨해 10,000원 GIFT카드 를 선물로 드립니다." /></p>
				<a href="https://instagram.com/your10x10/" target="_blank" title="새창"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60834/m/txt_account.png" alt="텐바이텐의 인스타그램 계정과 친구가 되어 주세요! @your10x10" /></a>
			</div>

			<div class="photo">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/60834/m/tit_photo.png" alt="꿀맛 스티커 인증샷" /></h2>
				<div class="photolist">
					<div id="pixlee_container"></div><script type="text/javascript">window.PixleeAsyncInit = function() {Pixlee.init({apiKey:"fv6psNyfsxP24pP6d9WM"});Pixlee.addSimpleWidget({albumId:148534,recipeId:216,displayOptionsId:4996,type:"photowall",accountId:728,setMetaTags:true});};</script><script src="//assets.pixlee.com/assets/pixlee_widget_1_0_0.js"></script>
				</div>
			</div>

			<div class="noti">
				<h2><span>이벤트 유의사항</span></h2>
				<ul>
					<li>본 이벤트는 인스타그램과 본 페이지를 통해서만 참여할 수 있습니다.</li>
					<li>SNS 포스팅 시에는 <strong>#텐바이텐꿀맛</strong>이라는 해시태그를 꼭 입력해주셔야 합니다.</li>
					<li>텐바이텐 계정 (@your10x10)이 올려주신 글에 '좋아요'를 눌러야만 최종 접수됩니다.<br /> 당첨자는 <strong>2015년 4월 28일 화요일에 발표</strong>합니다.</li>
					<li><strong>#텐바이텐</strong> 해시태그가 입력된 포스팅에 한해 별도의 동의없이 리스트에 보여집니다.</li>
					<li>본 이벤트 페이지에서 보여지는 것과 당첨여부는 관계가 없을 수 있습니다.</li>
					<li>계정과 응모한 포스팅은 공개로 설정해야 하며, 비공개 시 응모가 되지 않습니다.</li>
				</ul>
			</div>

			<% if isApp then %>
			<div class="bnr app"><a href="" onclick="parent.fnAPPpopupEvent('61488'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_event_bnr_main.png" alt="사월의 꿀맛 메인으로 가기" /></a></div>
			<% else %>
			<div class="bnr mo"><a href="/event/eventmain.asp?eventid=61488" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_event_bnr_main.png" alt="사월의 꿀맛 메인으로 가기" /></a></div>
			<% end if %>
		</div>
	</div>
</div>
<script type="text/javascript">
$(function(){
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		$(".app").show();
		$(".mo").hide();
	}else{
		$(".mo").show();
		$(".app").hide();
	}
});
</script>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->