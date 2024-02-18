<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : PLAY #31-2
' History : 2016-06-10 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
Dim pagereload
	pagereload	= requestCheckVar(request("pagereload"),2)

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg

dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle = Server.URLEncode("물의 현재진행형을 담은 화보,Water-ing")
snpLink = Server.URLEncode("http://m.10x10.co.kr/play/playGround.asp?idx=1400&contentsidx=127")
snpPre = Server.URLEncode("텐바이텐")

'기본 태그
snpTag = Server.URLEncode("텐바이텐")
snpTag2 = Server.URLEncode("#10x10")

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐]WATER-ing\n\n투명한 물이 일상의 다양한 재료와 만났을 때, 펼쳐지는 색색의 향연!\n\n투명한 물의 변신!\n\n물의 잠재력을 화보에 담았습니다.\n당신의 일상에서도 water-ing을 즐겨보세요."
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/playmo/ground/20160613/img_kakao.jpg"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url
	If isapp = "1" Then '앱일경우
		kakaolink_url = "http://m.10x10.co.kr/play/playGround.asp?idx=1400&contentsidx=127"
	Else '앱이 아닐경우
		kakaolink_url = "http://m.10x10.co.kr/play/playGround.asp?idx=1400&contentsidx=127"
	end If

%>
<style type="text/css">
img {vertical-align:top;}
.mPlay20160613 {-webkit-text-size-adjust:none;}
.intro {position:relative; background:#8dcde8;}
.intro h2 {position:absolute; left:0; top:19%; z-index:30; width:100%;}
.intro .bar {position:absolute; left:30%; top:32.6%; z-index:20; width:0; height:0.9%; background:#ff92b8;}
.intro .purpose p {position:absolute; left:0; width:100%; z-index:20; margin-top:10px; opacity:0;}
.intro .purpose p.p01 {top:47.8%;}
.intro .purpose p.p02 {top:56%;}
.intro .purpose p.p03 {top:64.5%;}
.intro .purpose p.p04 {top:73%;}
.intro .purpose p.dot {left:50%; top:86%; width:0.6%; margin-left:-0.3%;}
.intro .bg {position:absolute; left:0; top:0; width:100%; height:100%; z-index:10; background:url(http://webimage.10x10.co.kr/playmo/ground/20160613/bg_intro.png) no-repeat 50% 50%; background-size:200%;}
.watering .item {position:relative;}
.watering .item .txt {position:absolute; top:16%; width:35.3%; opacity:0;}
.watering #fruit .txt {left:8.75%; margin-left:8px;}
.watering #soap .txt {right:5.15%; margin-right:-8px;}
.watering #ink .txt {left:8.75%; margin-left:8px;}
.watering #light .txt {right:5.15%; margin-right:-8px;}
.watering #oil .txt {left:8.75%; margin-left:8px;}
.watering #draw .txt {right:5.15%; margin-right:-8px;}
.download {position:relative;}
.download h3 {position:relative; z-index:1; margin-bottom:-2.4%;}
.download > div {position:relative;}
.download ul {position:absolute; top:33.33333%; width:40%; height:45%;}
.download .photo1 ul {right:10%;}
.download .photo2 ul {left:10%;}
.download li {height:33%;}
.download li a {display:block; width:100%; height:100%; background:transparent; text-indent:-999em;}
.share {position:relative;}
.share a {display:block; position:absolute; top:19%; width:18%; height:62%; text-indent:-999em;}
.share a.facebook {left:50%;}
.share a.kakaotalk {left:72%;}
</style>
<script type="text/javascript">
$(function(){
	<% if pagereload<>"" then %>
		setTimeout("pagedown()",500);
	<% end if %>
});

function pagedown(){
	window.$('html,body').animate({scrollTop:$("#apply").offset().top}, 0);
}

$(function(){
	function titleAnimation() {
		$(".intro .bg").delay(100).animate({backgroundSize:'100%','opacity':'1'},2300);
		$(".intro .bar").delay(500).animate({"width":"40%"},800);
		$(".intro .purpose .p01").delay(1200).animate({"margin-top":"0",'opacity':'1'},500);
		$(".intro .purpose .p02").delay(1400).animate({"margin-top":"0",'opacity':'1'},500);
		$(".intro .purpose .p03").delay(1600).animate({"margin-top":"0",'opacity':'1'},500);
		$(".intro .purpose .p04").delay(1800).animate({"margin-top":"0",'opacity':'1'},500);
		$(".intro .purpose .dot").delay(2000).animate({"margin-top":"0",'opacity':'1'},500);
	}
	titleAnimation()
	$(window.parent).scroll(function(){
		var scrollTop = $(window.parent).scrollTop();
		if (scrollTop > 500) {
			$(".watering #fruit .txt").delay(100).animate({"margin-left":"0",'opacity':'1'},400);
		}
		if (scrollTop > 900) {
			$(".watering #soap .txt").delay(100).animate({"margin-right":"0",'opacity':'1'},400);
		}
		if (scrollTop > 1500) {
			$(".watering #ink .txt").delay(100).animate({"margin-left":"0",'opacity':'1'},400);
		}
		if (scrollTop > 2000) {
			$(".watering #light .txt").delay(100).animate({"margin-right":"0",'opacity':'1'},400);
		}
		if (scrollTop > 2300) {
			$(".watering #oil .txt").delay(100).animate({"margin-left":"0",'opacity':'1'},400);
		}
		if (scrollTop > 3000) {
			$(".watering #draw .txt").delay(100).animate({"margin-right":"0",'opacity':'1'},400);
		}
	});
});
</script>
<div class="mPlay20160613">
	<article>
		<!-- intro -->
		<div class="intro">
			<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20160613/tit_watering.png" alt="WATERING" /></h2>
			<p class="bar"></p>
			<div class="purpose">
				<p class="p01"><img src="http://webimage.10x10.co.kr/playmo/ground/20160613/txt_purpose_01.png" alt="투명한 물이 다른 성격의 재료와 만났을 때 우리는 새로운 움직임을 확인할 수 있습니다" /></p>
				<p class="p02"><img src="http://webimage.10x10.co.kr/playmo/ground/20160613/txt_purpose_02.png" alt="스며들거나 퍼지거나 혹은 아예 분리가 되기도 하고 온도에 따라 연기가 되었다가 얼음이 되기도 합니다" /></p>
				<p class="p03"><img src="http://webimage.10x10.co.kr/playmo/ground/20160613/txt_purpose_03.png" alt="우리는 그런 물의 현재진행형을 화보로 담았고 이를 watering이라고 표현했습니다" /></p>
				<p class="p04"><img src="http://webimage.10x10.co.kr/playmo/ground/20160613/txt_purpose_04.png" alt="놀라운 잠재력을 담고 있는 물과 함께 당신의 일상 속에서 워터링을 즐겨 보세요" /></p>
				<p class="dot"><img src="http://webimage.10x10.co.kr/playmo/ground/20160613/img_dot.png" alt="" /></p>
			</div>
			<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160613/bg_intro_blank.png" alt="" /></div>
			<div class="bg"></div>
		</div>

		<!-- watering -->
		<div class="watering">
			<div id="fruit" class="item">
				<p class="txt"><img src="http://webimage.10x10.co.kr/playmo/ground/20160613/txt_fruit.png" alt="건강한 느낌, 상큼한 상상" /></p>
				<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160613/img_fruit.jpg" alt="" /></div>
			</div>
			<div id="soap" class="item">
				<p class="txt"><img src="http://webimage.10x10.co.kr/playmo/ground/20160613/txt_soap.png" alt="머릿속이 온통 하얘질 때" /></p>
				<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160613/img_soap.gif" alt="" /></div>
			</div>
			<div id="ink" class="item">
				<p class="txt"><img src="http://webimage.10x10.co.kr/playmo/ground/20160613/txt_ink.png" alt="물 속에 퐁당 그림 그리는 날" /></p>
				<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160613/img_ink.gif" alt="" /></div>
			</div>
			<div id="light" class="item">
				<p class="txt"><img src="http://webimage.10x10.co.kr/playmo/ground/20160613/txt_light.png" alt="언제나 비 온 뒤 맑음" /></p>
				<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160613/img_light.jpg" alt="" /></div>
			</div>
			<div id="oil" class="item">
				<p class="txt"><img src="http://webimage.10x10.co.kr/playmo/ground/20160613/txt_oil.png" alt="우리는 물과 기름 같은 사이" /></p>
				<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160613/img_oil.jpg" alt="" /></div>
			</div>
			<div id="draw" class="item">
				<p class="txt"><img src="http://webimage.10x10.co.kr/playmo/ground/20160613/txt_draw.png" alt="물 한 방울의 호소력" /></p>
				<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160613/img_draw.gif" alt="" /></div>
			</div>
		</div>

		<!-- download -->
		<div class="download">
			<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20160613/tit_download.png" alt="무료한 일상을 화려하게 만들어 줄 사진을 핸드폰에 담아 일상을 WATERING 하세요!" /></h3>
			<div class="photo1">
				<ul>
					<li><a href="javascript:fileDownload(3781);">iPhone</a></li>
					<li><a href="javascript:fileDownload(3782);">iPhone+</a></li>
					<li><a href="javascript:fileDownload(3783);">Galaxy</a></li>
				</ul>
				<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160613/img_photo_01.jpg" alt="" /></div>
			</div>
			<div class="photo2">
				<ul>
					<li><a href="javascript:fileDownload(3784);">iPhone</a></li>
					<li><a href="javascript:fileDownload(3785);">iPhone+</a></li>
					<li><a href="javascript:fileDownload(3786);">Galaxy</a></li>
				</ul>
				<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160613/img_photo_02.jpg" alt="" /></div>
			</div>
		</div>
		<div class="share">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160613/txt_share.png" alt="친구들에게 공유하기" /></p>
			<a href="#" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');return false;" class="facebook">페이스북</a>
			<a href="#" onclick="parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>');return false;" class="kakaotalk">카카오톡</a>
		</div>
	</article>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->