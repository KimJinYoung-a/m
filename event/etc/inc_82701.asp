<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 케이스팔레트
' History : 2017-12-01 조경애 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.collection-chip {padding-bottom:2.5rem; background-color:#fff;}
.collection-chip .inner {width:27.74rem; margin:0 auto;}
.collection-chip .list li {margin-bottom:2.13rem;}
.collection-chip .list li > a {display:block;}
.collection-chip .list li p {padding-top:1.11rem; color:#252525; font-size:1.3em; line-height:1; font-weight:600;}
</style>
<script type="text/javascript">
function goEventLink(evt) {
	<% if isApp then %>
		fnAPPpopupEvent(evt);
	<% else %>
		parent.location.href='/event/eventmain.asp?eventid='+evt;
	<% end if %>
	return false;
}
</script>
<div class="mEvt82701 collection-chip">
	<a href="" onclick="goEventLink('82700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82701/m/bnr_palette.jpg" alt="Phone case Palette" /></a>
	<div class="inner">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/82701/m/tit_collection_chip.png" alt="Collection Chip" /></h2>
		<ul class="list">
			<li>
				<a href="" onclick="goEventLink('82662'); return false;">
					<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82701/m/bnr_event_1.jpg" alt="" /></div>
					<p>바나나 좋아하는 미니언즈 컬렉션</p>
				</a>
			</li>
			<li>
				<a href="" onclick="goEventLink('82728'); return false;">
					<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82701/m/bnr_event_2.jpg" alt="" /></div>
					<p>당신만을 위한 프리미엄 케이스</p>
				</a>
			</li>
			<li>
				<a href="" onclick="goEventLink('82754'); return false;">
					<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82701/m/bnr_event_3.jpg" alt="" /></div>
					<p>아트를 입은 케이스</p>
				</a>
			</li>
			<li>
				<a href="" onclick="goEventLink('82535'); return false;">
					<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82701/m/bnr_event_4.jpg" alt="" /></div>
					<p>부들부들 털찐 케이스</p>
				</a>
			</li>
			<li>
				<a href="" onclick="goEventLink('82672'); return false;">
					<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82701/m/bnr_event_5.jpg" alt="" /></div>
					<p>슬림함과 깔끔함을 원하는 당신에게</p>
				</a>
			</li>
			<li>
				<a href="" onclick="goEventLink('82664'); return false;">
					<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82701/m/bnr_event_6.jpg" alt="" /></div>
					<p>손안에 가득한, 귀여운 동물 친구들</p>
				</a>
			</li>
			<li>
				<a href="" onclick="goEventLink('82667'); return false;">
					<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82701/m/bnr_event_7.jpg" alt="" /></div>
					<p>디테일한 질감이 매력적인 케이스</p>
				</a>
			</li>
			<li>
				<a href="" onclick="goEventLink('82668'); return false;">
					<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82701/m/bnr_event_8.jpg?v=1" alt="" /></div>
					<p>덕후들을 위한 케이스 모음</p>
				</a>
			</li>
			<li>
				<a href="" onclick="goEventLink('82666'); return false;">
					<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82701/m/bnr_event_9.jpg" alt="" /></div>
					<p>패턴 성애자 모이세요~</p>
				</a>
			</li>
			<li>
				<a href="" onclick="goEventLink('82665'); return false;">
					<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82701/m/bnr_event_10.jpg" alt="" /></div>
					<p>카드지갑과 폰케이스를 하나로!</p>
				</a>
			</li>
			<li>
				<a href="" onclick="goEventLink('82663'); return false;">
					<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82701/m/bnr_event_11.jpg" alt="" /></div>
					<p>꿈과 희망의 디즈니 라인</p>
				</a>
			</li>
			<li>
				<a href="" onclick="goEventLink('82670'); return false;">
					<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82701/m/bnr_event_12.jpg" alt="" /></div>
					<p>은은한 달빛을 갖고 싶은 밤</p>
				</a>
			</li>
			<li>
				<a href="" onclick="goEventLink('82536'); return false;">
					<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82701/m/bnr_event_13.jpg" alt="" /></div>
					<p>남들과는 다른 커스텀 케이스</p>
				</a>
			</li>
			<li>
				<a href="" onclick="goEventLink('82671'); return false;">
					<div class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82701/m/bnr_event_14.jpg" alt="" /></div>
					<p>겨울엔 가죽이죠! Leather &amp; Fabric</p>
				</a>
			</li>
		</ul>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->