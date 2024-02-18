<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 오벤져스 M 랜딩페이지
' History : 2016.05.12 허진원 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->

<style type="text/css">
img {vertical-align:top;}
button {outline:none; background-color:transparent;}
.item ul {overflow:hidden;}
.item ul li {float:left; width:50%;}
.btnApply {width:100%;}
.shareSns {position:relative;}
.shareSns ul {position:absolute; left:15%; top:46%; width:70%; height:38%;}
.shareSns ul li {float:left; width:33%; height:100%; padding:0 2%;}
.shareSns ul li a {display:block; width:100%; height:100%; text-indent:-9999px;}
.evtNoti {color:#fff; padding:2rem 4% 2.5rem; background:#30363a;}
.evtNoti h3 {padding-bottom:1.2rem;}
.evtNoti h3 strong {display:inline-block; font-size:1.4rem; line-height:2rem; padding-left:2.5rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/70686/m/ico_mark.png) no-repeat 0 0; background-size:1.9rem 1.9rem;}
.evtNoti li {position:relative; padding-left:1rem; font-size:1rem; line-height:1.4; letter-spacing:-0.003em;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.5rem; width:0.4rem; height:1px; background:#fff;}
</style>
<script type="text/javascript">
function gotoDownload(){
	parent.top.location.href='http://m.10x10.co.kr/apps/link/?9420160512';
	return false;
};
</script>

<div class="mEvt70686">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/70686/m/tit_5venzers.png" alt="텐바이텐 오벤져스 - 앱에서 처음 로그인한 분께 드리는 5천원의 행복" /></h2>
	<div class="item">
		<ul>
			<li><a href="/category/category_itemPrd.asp?itemid=1487846&amp;pEtr=70686"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70686/m/img_5venzers_item1.png" alt="인스탁스 카메라" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1487924&amp;pEtr=70686"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70686/m/img_5venzers_item2.png" alt="스티키몬스터 보틀" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1487939&amp;pEtr=70686"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70686/m/img_5venzers_item3.png" alt="스파이더맨 탁상 선풍기" /></a></li>
			<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/70686/m/img_5venzers_item4.png" alt="500 마일리지" /></a></li>
		</ul>
	</div>
	<p>
		<button type="button" class="btnApply" onclick="gotoDownload();"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70686/m/btn_5venzers.png" alt="APP에서 확인하기" /></button>
	</p>
	<%
		'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
		dim snpTitle, snpLink
		snpTitle = Server.URLEncode("[텐바이텐] 오벤져스")
		snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=70686")

		'// 카카오링크 변수
		Dim kakaotitle : kakaotitle = "[텐바이텐] 오벤져스\n\n신규 앱 설치자에게 드리는\n엄청난 혜택을 준비했습니다.\n\n텐바이텐에서 잘나가는 하나의 상품을 5천원에 만나볼 수 있는 기회!\n\n지금 APP 설치하고 확인해보세요!\n오직 텐바이텐 APP에서!"
		Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/70686/etcitemban20160512185825.jpeg"
		Dim kakaoimg_width : kakaoimg_width = "200"
		Dim kakaoimg_height : kakaoimg_height = "200"
		Dim kakaolink_url : kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=70686"
	%>
	<div class="shareSns">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70686/m/sns_5venzers.png" alt="" /></p>
		<ul>
			<li><a href="#" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','',''); return false;">facebook</a></li>
			<li><a href="#" onclick="parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>');return false;">kakaotalk</a></li>
			<li><a href="#" onclick="popSNSPost('ln','<%=snpTitle%>','<%=snpLink%>','',''); return false;">line</a></li>
		</ul>
	</div>
	<div class="evtNoti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<li>본 이벤트는 앱에서 로그인 이력이 한번도 없는 고객님을 위한 이벤트입니다.</li>
			<li>ID당 1회만 구매가 가능합니다.</li>
			<li>이벤트는 상품 품절 시 조기 마감 될 수 있습니다.</li>
			<li>이벤트는 즉시결제로만 구매가 가능하며, 배송 후 반품/교환/구매취소가 불가능합니다.</li>
		</ul>
	</div>
</div>
