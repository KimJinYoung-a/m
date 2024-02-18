<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : PLAY 29-4 M/A
' History : 2016-04-22 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
Dim eCode , userid , strSql , totcnt , pagereload , totcntall
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66113
Else
	eCode   =  70358
End If

	pagereload	= requestCheckVar(request("pagereload"),2)
	userid = GetEncLoginUserID()

	'// 이벤트 진행 여부
	strSql = "select "
	strSql = strSql & " count(*) "
	strSql = strSql & " from db_event.dbo.tbl_event_subscript"
	strSql = strSql & "	where evt_code = '"& eCode &"' " 
	rsget.Open strSql,dbget,1
	IF Not rsget.Eof Then
		totcntall = rsget(0)
	End IF
	rsget.close()

If IsUserLoginOK Then 
	'// 이벤트 진행 여부
	strSql = "select "
	strSql = strSql & " count(*) "
	strSql = strSql & " from db_event.dbo.tbl_event_subscript"
	strSql = strSql & "	where userid = '"& userid &"' and evt_code = '"& eCode &"' " 
	rsget.Open strSql,dbget,1
	IF Not rsget.Eof Then
		totcnt = rsget(0)
	End IF
	rsget.close()
End If

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg

dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle = Server.URLEncode("오분 분양중 5분의 여유가 필요한 당신에게,오분을 분양해드립니다.")
snpLink = Server.URLEncode("bit.ly/PLAY29_")
snpPre = Server.URLEncode("텐바이텐")

'기본 태그
snpTag = Server.URLEncode("텐바이텐")
snpTag2 = Server.URLEncode("#10x10")

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐] 오분 분양중\n\n오늘 아침도 밥대신 잠을 선택해\n5분 더 자고 오셨나요?\n\n5분의 여유가 필요한 당신에게,\n오분을 분양해드립니다.\n\n오분 분양권으로 하루를\n더 오-분하게 보내세요!\n\n지금 바로 확인해보세요!\n오직,텐바이텐에서!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/playmo/ground/20160425/img_kakao.jpg"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url
	If isapp = "1" Then '앱일경우
		kakaolink_url = "http://m.10x10.co.kr/play/playGround.asp?idx=1394&contentsidx=121"
	Else '앱이 아닐경우
		kakaolink_url = "http://m.10x10.co.kr/play/playGround.asp?idx=1394&contentsidx=121"
	end If

%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

img {vertical-align:top;}

.fiveMinutes button {background-color:transparent;}

.topic {position:relative;}
.topic h2 {position:absolute; top:16.34%; left:15.4%; width:41.4%;}
.topic .letter1, .topic .letter3 {position:absolute; left:0; width:100%;}
.topic .letter1 {top:0;}
.topic .letter3 {bottom:0;}
.topic .underline {animation-name:underline; animation-iteration-count:1; animation-duration:1s; animation-fill-mode:both; animation-delay:1.2s; -webkit-animation-name:underline; -webkit-animation-iteration-count:1; -webkit-animation-duration:1s; -webkit-animation-fill-mode:both; -webkit-animation-delay:1.2s;}
@keyframes underline {
	0% {transform:scaleX(0);}
	100% {transform:scaleX(1);}
}
@-webkit-keyframes underline {
	0% {-webkit-transform:scaleX(0);}
	100% {-webkit-transform:scaleX(1);}
}
.topic p {position:absolute; top:21.65%; right:16.56%; width:12.5%;}

.kit {position:relative; padding-top:15%;}
.kit h3 {position:absolute; top:0; left:0; z-index:5; width:100%;}
.kit h3 .btnArrow {position:absolute; left:50%; bottom:2%; width:6%; margin-left:-3%;}
.bounce {animation-name:bounce; animation-iteration-count:5; animation-duration:1s; -webkit-animation-name:bounce; -webkit-animation-iteration-count:5; -webkit-animation-duration:1s;}
@keyframes bounce {
	from, to{margin-bottom:5px; animation-timing-function:ease-out;}
	50% {margin-bottom:0; animation-timing-function:ease-in;}
}
@-webkit-keyframes bounce {
	from, to{margin-bottom:5px; animation-timing-function:ease-out;}
	50% {margin-bottom:0; animation-timing-function:ease-in;}
}

.rolling .swiper {position:relative;}
.rolling .swiper .swiper-container {width:100%;}
.rolling .swiper .swiper-slide {position:relative;}
.rolling .swiper .swiper-slide .desc {position:absolute; width:13.59%;}
.rolling .swiper .swiper-slide .desc1 {top:31.25%; left:10%;}
.rolling .swiper .swiper-slide .desc2 {top:34%; left:43.75%;}
.rolling .swiper .swiper-slide .desc3 {top:40.62%; left:10%;}
.rolling .swiper .swiper-slide .desc4 {top:29.68%; left:75.31%;}
.rolling .swiper .swiper-slide .desc5 {top:30.8%; left:43.75%;}
.rolling .swiper .swiper-slide .desc6 {top:33.12%; left:10%;}
.rolling .swiper .swiper-slide .desc7 {top:34.68%; left:10%;}
.rolling .swiper .pagination {position:absolute; bottom:8%; left:0; z-index:20; width:100%; height:auto; z-index:50; padding-top:0; text-align:center;}
.rolling .swiper .pagination .swiper-pagination-switch {display:inline-block; width:6px; height:6px; margin:0 5px; background-color:#cfcfcf; cursor:pointer;}
.rolling .swiper .pagination .swiper-active-switch {background-color:#f26e61;}

@media all and (min-width:360px){
	.rolling .swiper .pagination .swiper-pagination-switch {width:8px; height:8px;}
}
@media all and (min-width:480px){
	.rolling .swiper .pagination .swiper-pagination-switch {width:10px; height:10px; margin:0 10px;}
}
@media all and (min-width:768px){
	.rolling .swiper .pagination .swiper-pagination-switch {width:16px; height:16px; margin:0 12px;}
}

.find {position:relative;}
.find h3 {position:absolute; top:7.71%; left:9.53%; width:45.15%;}
.find ul {position:absolute; top:25%; left:0; width:100%; height:50%;}
.find ul li {position:absolute; width:40%; height:27%;}
.find ul li a {display:block; width:100%; height:100%; background-color:black; color:transparent; opacity:0; filter:alpha(opacity=0); cursor:pointer;}
.find ul li.item1 {top:7%; left:20%;}
.find ul li.item2 {top:17%; right:5%; width:30%; height:15%;}
.find ul li.item3 {top:33%; right:18%; width:20%; height:12%;}
.find ul li.item4 {top:35%; left:11%; width:20%; height:42%;}
.find ul li.item5 {top:37%; left:37%; width:20%; height:26%;}
.find ul li.item6 {top:46%; right:10%; width:30%; height:50%;}
.find ul li.item7 {top:65%; left:33%; width:20%; height:20%;}

.apply {position:relative;}
.apply .btnApply {position:absolute; top:42.375%; left:50%; width:80.93%; margin-left:-40.465%;}
.apply .applyAfter span {position:absolute; top:0; left:0; width:100%;}
.apply .applyAfter span {animation-name:twinkle; animation-iteration-count:5; animation-duration:1s; animation-fill-mode:both; -webkit-animation-name:twinkle; -webkit-animation-iteration-count:5; -webkit-animation-duration:1.2s; -webkit-animation-fill-mode:both;}
@keyframes twinkle {
	0% {opacity:0;}
	100% {opacity:1;}
}
@-webkit-keyframes twinkle {
	0% {opacity:0;}
	100% {opacity:1;}
}

.apply .count {position:absolute; top:84%; left:0; width:100%; color:#000; font-size:1.7rem; text-align:center;}
.apply .count strong {color:#f36e61;}

.sns {position:relative;}
.sns ul {overflow:hidden; position:absolute; bottom:9%; left:0; width:100%; padding:0 13%;}
.sns ul li {float:left; width:33.333%;}
.sns ul li a {overflow:hidden; display:block; position:relative; height:0; margin:0 6%; padding-bottom:88%; color:transparent; font-size:12px; line-height:12px; text-align:center;}
.sns ul li a span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter:alpha(opacity=0); cursor:pointer;}
</style>
<script type="text/javascript">
$(function(){
	<% if pagereload<>"" then %>
		setTimeout("pagedown()",500);
	<% end if %>
});

$(function(){
	animation();
	$("#animation .letter2 img").css({"width":"110%", "opacity":"0"});
	$("#animation p").css({"right":"13%", "opacity":"0"});
	function animation () {
		$("#animation .letter2 img").delay(10).animate({"width":"100%", "opacity":"1"},600);
		$("#animation p").delay(800).animate({"right":"16.56%", "opacity":"1"},700);
	}

	$(window.parent).scroll(function(){
		var scrollTop = $(window.parent).scrollTop();
		if (scrollTop > 500 ) {
			$("#kit h3 .btnArrow").addClass("bounce");
		}
	});

	/* swiper js */
	mySwiper = new Swiper('#rolling .swiper',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		autoplay:3000,
		speed:700,
		pagination:"#rolling .pagination",
		paginationClickable:true,
		onSlideChangeStart: function (mySwiper) {
			$("#rolling .swiper-slide").find(".desc").delay(100).animate({"margin-left":"5%", "opacity":"0"},300)
			$("#rolling .swiper-slide-active.swiper-slide-01").find(".desc").delay(50).animate({"margin-left":"0", "opacity":"1"},400);
			$("#rolling .swiper-slide-active.swiper-slide-02").find(".desc").delay(50).animate({"margin-left":"0", "opacity":"1"},400);
			$("#rolling .swiper-slide-active.swiper-slide-03").find(".desc").delay(50).animate({"margin-left":"0", "opacity":"1"},400);
			$("#rolling .swiper-slide-active.swiper-slide-04").find(".desc").delay(50).animate({"margin-left":"0", "opacity":"1"},400);
			$("#rolling .swiper-slide-active.swiper-slide-05").find(".desc").delay(50).animate({"margin-left":"0", "opacity":"1"},400);
			$("#rolling .swiper-slide-active.swiper-slide-06").find(".desc").delay(50).animate({"margin-left":"0", "opacity":"1"},400);
			$("#rolling .swiper-slide-active.swiper-slide-07").find(".desc").delay(50).animate({"margin-left":"0", "opacity":"1"},400);
		}
	});
});


function pagedown(){
	window.$('html,body').animate({scrollTop:$("#apply").offset().top}, 0);
}

function vote_play(){
	var frm = document.frm;
	<% if Not(IsUserLoginOK) then %>
		<% if isApp then %>
			calllogin();
			return false;
		<% else %>
			jsevtlogin();
			return false;
		<% end if %>
	<% end if %>

	<% If not(left(now(),10)>="2016-04-25" and left(now(),10)<"2016-05-04" ) Then %>
		alert("이벤트 응모 기간이 아닙니다.");
		return;
	<% else %>
		<% if totcnt > 0 then %>
			alert("한 개의 아이디당 한 번만 응모가 가능 합니다.");
			return;
		<% else %>
			alert("분양이 완료 되었습니다.");
			frm.action = "/play/groundcnt/doEventSubscript70358.asp";
			frm.target="frmproc";
			frm.submit();
			return;
		<% end if %>
	<% end if %>
}
</script>
<div class="mPlay20160425 fiveMinutes">
	<article>
		<div id="animation" class="topic">
			<h2>
				<span class="letter1 underline"><img src="http://webimage.10x10.co.kr/playmo/ground/20160425/bg_line_bar.png" alt="" /></span>
				<span class="letter2"><img src="http://webimage.10x10.co.kr/playmo/ground/20160425/tit_5_minutes.png" alt="오분분양" /></span>
				<span class="letter3 underline"><img src="http://webimage.10x10.co.kr/playmo/ground/20160425/bg_line_bar.png" alt="" /></span>
			</h2>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160425/txt_need_time.png" alt="절찬리에 오 분분 양 중 시간이 더 필요한 당신에게" /></p>
			<img src="http://webimage.10x10.co.kr/playmo/ground/20160425/bg_pattern.png" alt="" />
		</div>

		<section class="recommend">
			<h3 class="hidden">이런 분에게 추천합니다!</h3>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160425/txt_recommend.png" alt="밥먹는 시간도 아껴서 5분이라도 더 자고 싶은 분, 에스컬레이터 속도가 답답해 기어이 걸어서 올라가는 분 가끔은 감쪽같이 앞머리만 감고 머리 감고 온 척 하는 분" /></p>
		</section>

		<section id="kit" class="kit">
			<h3>
				<img src="http://webimage.10x10.co.kr/playmo/ground/20160425/tit_kit_v1.png" alt="오분분양키드 7가지 아이템 보기" />
				<span class="btnArrow"><img src="http://webimage.10x10.co.kr/playmo/ground/20160425/btn_arrow.png" alt="" /></span>
			</h3>
			<div id="rolling" class="rolling">
				<div class="swiper">
					<div class="swiper-container swiper">
						<div class="swiper-wrapper">
							<div class="swiper-slide swiper-slide-01">
								<% If isapp = "1" Then %>
								<a href="#" onclick="fnAPPpopupProduct(1450684);return false;">
								<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1450684&amp;pEtr=70358">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/playmo/ground/20160425/img_slide_01.jpg" alt="간편한 식사, 랩노쉬" />
									<p class="desc desc1"><img src="http://webimage.10x10.co.kr/playmo/ground/20160425/txt_desc_01.png" alt="밥 먹는 시간이라도 다이어트" /></p>
								</a>
							</div>
							<div class="swiper-slide swiper-slide-02">
								<% If isapp = "1" Then %>
								<a href="#" onclick="fnAPPpopupProduct(724721);return false;">
								<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=724721&amp;pEtr=70358">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/playmo/ground/20160425/img_slide_02.jpg" alt="프린시페샤 노트 브리즈 드라이샴푸" />
									<p class="desc desc2"><img src="http://webimage.10x10.co.kr/playmo/ground/20160425/txt_desc_02.png" alt="머리 감는 시간도 아까워. 드라이 샴푸" /></p>
								</a>
							</div>
							<div class="swiper-slide swiper-slide-03">
								<% If isapp = "1" Then %>
								<a href="#" onclick="fnAPPpopupProduct(1256190);return false;">
								<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1256190&amp;pEtr=70358">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/playmo/ground/20160425/img_slide_03.jpg" alt="샤오미 보조배터리" />
									<p class="desc desc3"><img src="http://webimage.10x10.co.kr/playmo/ground/20160425/txt_desc_03.png" alt="오가는 길에 충전 100%" /></p>
								</a>
							</div>
							<div class="swiper-slide swiper-slide-04">
								<% If isapp = "1" Then %>
								<a href="#" onclick="fnAPPpopupProduct(1456177);return false;">
								<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1456177&amp;pEtr=70358">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/playmo/ground/20160425/img_slide_04.jpg" alt="머리를 빨리 말려주는 아임굿즈 3분 장갑" />
									<p class="desc desc4"><img src="http://webimage.10x10.co.kr/playmo/ground/20160425/txt_desc_04.png" alt="누구보다 빠르게 남들과는 다르게" /></p>
								</a>
							</div>
							<div class="swiper-slide swiper-slide-05">
								<% If isapp = "1" Then %>
								<a href="#" onclick="fnAPPpopupProduct(1013727);return false;">
								<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1013727&amp;pEtr=70358">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/playmo/ground/20160425/img_slide_05.jpg" alt="자일리톨이 함유된 1회용 씹는 칫솔 4개입" />
									<p class="desc desc5"><img src="http://webimage.10x10.co.kr/playmo/ground/20160425/txt_desc_05.png" alt="입안에만 넣으면 양치질 끝 !" /></p>
								</a>
							</div>
							<div class="swiper-slide swiper-slide-06">
								<% If isapp = "1" Then %>
								<a href="#" onclick="fnAPPpopupProduct(1438033);return false;">
								<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1438033&amp;pEtr=70358">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/playmo/ground/20160425/img_slide_06.jpg" alt="파켈만 사과조각기" />
									<p class="desc desc6"><img src="http://webimage.10x10.co.kr/playmo/ground/20160425/txt_desc_06.png" alt="한번에 사과 나누고 시간도 나누고!" /></p>
								</a>
							</div>
							<div class="swiper-slide swiper-slide-07">
								<% If isapp = "1" Then %>
								<a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT,[],'기프트카드',[BtnType.SHARE],'<%=wwwUrl%>/apps/appCom/wish/web2014/giftcard/','giftcard');return false;">
								<% Else %>
								<a href="/giftcard/index.asp">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/playmo/ground/20160425/img_slide_07.jpg" alt="" />
									<p class="desc desc7"><img src="http://webimage.10x10.co.kr/playmo/ground/20160425/txt_desc_07.png" alt="고르기만 하면 되, 스피드한 결제!" /></p>
								</a>
							</div>
						</div>
					</div>
					<div class="pagination"></div>
				</div>
			</div>
		</section>

		<section class="find">
			<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20160425/tit_find.png" alt="24시간이 모자란 당신께 오분의 여유를 찾아드립니다." /></h3>
			<% If isapp = "1" Then %>
			<ul>
				<li class="item1"><a href="#" onclick="fnAPPpopupProduct(1438033);return false;">1. 파켈만 사과조각기</a></li>
				<li class="item2"><a href="#" onclick="fnAPPpopupProduct(1013727);return false;">2. 퍼지브러쉬 씹는 칫솔 4개입</a></li>
				<li class="item3"><a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT,[],'기프트카드',[BtnType.SHARE],'<%=wwwUrl%>/apps/appCom/wish/web2014/giftcard/','giftcard');return false;">3. 텐바이텐 기프트카드 3만원 권</a></li>
				<li class="item4"><a href="#" onclick="fnAPPpopupProduct(1450684);return false;">4. 랩노쉬 쉐이크</a></li>
				<li class="item5"><a href="#" onclick="fnAPPpopupProduct(1256190);return false;">5. 샤오미 보조배터리 5000mAh</a></li>
				<li class="item6"><a href="#" onclick="fnAPPpopupProduct(1456177);return false;">6. 아임굿즈 3분 헤어 장갑</a></li>
				<li class="item7"><a href="#" onclick="fnAPPpopupProduct(724721);return false;">7. 프린시페샤 드라이 샴푸</a></li>
			</ul>
			<% Else %>
			<ul>
				<li class="item1"><a href="/category/category_itemPrd.asp?itemid=1438033&amp;pEtr=70358">1. 파켈만 사과조각기</a></li>
				<li class="item2"><a href="/category/category_itemPrd.asp?itemid=1013727&amp;pEtr=70358">2. 퍼지브러쉬 씹는 칫솔 4개입</a></li>
				<li class="item3"><a href="/giftcard/index.asp">3. 텐바이텐 기프트카드 3만원 권</a></li>
				<li class="item4"><a href="/category/category_itemPrd.asp?itemid=1450684&amp;pEtr=70358">4. 랩노쉬 쉐이크</a></li>
				<li class="item5"><a href="/category/category_itemPrd.asp?itemid=1256190&amp;pEtr=70358">5. 샤오미 보조배터리 5000mAh</a></li>
				<li class="item6"><a href="/category/category_itemPrd.asp?itemid=1456177&amp;pEtr=70358">6. 아임굿즈 3분 헤어 장갑</a></li>
				<li class="item7"><a href="/category/category_itemPrd.asp?itemid=724721&amp;pEtr=70358">7. 프린시페샤 드라이 샴푸</a></li>
			</ul>
			<% End If %>
			<img src="http://webimage.10x10.co.kr/playmo/ground/20160425/img_item.jpg" alt="" />
		</section>

		<section id="apply" class="apply">
			<h3 class="hidden">오분분양 기트 신청</h3>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160425/txt_now_apply_v1.png" alt="지금 바로 신청하세요! 단 오분에게만 드리는 오분 분양권! 소중한 시간을 세이브- 해드립니다. 신청기간은 4월 25일부터 5월 3일까지며, 당첨자 발표는 5월 4일입니다." /></p>
			<% If totcnt > 0 Then %>
			<p class="btnApply applyAfter">
				<img src="http://webimage.10x10.co.kr/playmo/ground/20160425/btn_apply_done.png" alt="" />
				<span><img src="http://webimage.10x10.co.kr/playmo/ground/20160425/txt_apply_done.png" alt="분양이 신청되었습니다" /></span>
			</p>
			<% Else %>
			<button type="button" class="btnApply applyBefore" onclick="vote_play();"><img src="http://webimage.10x10.co.kr/playmo/ground/20160425/btn_apply.png" alt="오분분양 키트 신청하기" /></button>
			<% End If %>
			<p class="count">총 <strong><%=FormatNumber(totcntall,0)%></strong> 명 분양 중</p>
		</section>

		<section id="sns" class="sns">
			<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20160425/txt_sns.png" alt="오분분양 소식을 공유해주세요! 친구에게 공유하면 분양의 기회가 두배" /></h3>
			<ul>
				<li class="kakao"><a href="#" onclick="parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>');return false;"><span></span>카카오톡으로 공유하기</a></li>
				<li class="facebook"><a href="#" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');return false;"><span></span>페이스북으로 공유하기</a></li>
				<li class="twitter"><a href="#" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');return false;"><span></span>트위터로 공유하기</a></li>
			</ul>
		</section>
	</article>
</div>
<form name="frm" method="post">
<input type="hidden" name="mode" value="add"/>
<input type="hidden" name="pagereload" value="ON"/>
</form>
<iframe id="frmproc" name="frmproc" frameborder="0" width=0 height=0></iframe>
<!-- #include virtual="/lib/db/dbclose.asp" -->