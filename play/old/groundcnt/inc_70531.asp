<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : PLAY [ 텐바이텐 X BML2016 ] 함께, 봄 
' History : 2016-04-29 유태욱 생성
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
Dim hotsing, hotsing1, hotsing2, hotsing3
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66115
Else
	eCode   =  70531
End If

	pagereload	= requestCheckVar(request("pagereload"),2)
	userid = GetEncLoginUserID()

	'// 투표 top3
'	strSql = "select top 3 sub_opt1"
'	strSql = strSql & " from db_event.dbo.tbl_event_subscript"
'	strSql = strSql & "	where evt_code = '"& eCode &"' " 
'	strSql = strSql & "	group by sub_opt1 " 
'	strSql = strSql & "	order by count(sub_opt1) desc "
'	rsget.Open strSql,dbget,1
'	IF Not rsget.Eof Then
'		hotsing  = rsget.getRows()
'	End IF
'	rsget.close()
'
'	hotsing1 =  hotsing( 0 , 0 )
'	hotsing2 =  hotsing( 0 , 1 )
'	hotsing3 =  hotsing( 0 , 2 )

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
snpTitle = Server.URLEncode("BML2016과 함께 하는 '함께, 봄' 프로젝트에 초대합니다♩ 봄날의 페스티벌을 텐바이텐에서 느껴보세요!")
snpLink = Server.URLEncode("http://bit.ly/1NEZZgJ")
snpPre = Server.URLEncode("텐바이텐")

'기본 태그
snpTag = Server.URLEncode("텐바이텐")
snpTag2 = Server.URLEncode("#텐바이텐 #10x10 #뷰티풀민트라이프")

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐 X BML2016]\n\n함께, 봄 프로젝트를 제안합니다.\n텐바이텐 그리고 뷰티풀민트라이프와 함께 기분좋은 일상을 만들어 보세요!\n\n런칭 기념 10% 할인이벤트와\nBML2016 초대이벤트도 진행 중!\n\n오직 텐바이텐에서 ♩\n http://bit.ly/bml2016goods"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/playmo/ground/20160502/img_kakao.jpg"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url
	If isapp = "1" Then '앱일경우
		kakaolink_url = "http://m.10x10.co.kr/play/playGround.asp?idx=1395&contentsidx=122"
	Else '앱이 아닐경우
		kakaolink_url = "http://m.10x10.co.kr/play/playGround.asp?idx=1395&contentsidx=122"
	end If


if userid="baboytw" then
	totcnt=0
end if

%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

img {vertical-align:top;}

.hidden {visibility:hidden; width:0; height:0;}

.rolling .swiper {position:relative;}
.rolling .swiper .swiper-container {width:100%;}
.rolling .swiper .swiper-slide {position:relative;}
.rolling .swiper .swiper-slide .deco {position:absolute; top:0; left:0; width:100%;}
#rolling01 .swiper .swiper-slide h2 {position:absolute; top:9.375%; left:0; width:100%;}
#rolling01 .swiper .swiper-slide-01 p {position:absolute; top:39.45%; left:0; width:100%;}
.swiper-slide .item {position:absolute; top:0; left:0; width:100%; height:100%;}
#rolling01 .swiper-slide .item li {width:100%; height:50%;}
#rolling01 .swiper-slide .item li a {position:relative; display:block; width:100%; height:100%;}
#rolling01 .swiper-slide .desc {position:absolute; top:26%; width:34.06%;}
#rolling01 .swiper-slide-02 .item li:nth-child(1) .desc {right:7.8125%;}
#rolling01 .swiper-slide-02 .item li:nth-child(2) .desc {left:9.06%; width:27.65%;}
#rolling01 .swiper-slide-03 .desc {width:37.65%; top:21.73%;}
#rolling01 .swiper-slide-03 .item li:nth-child(1) .desc {right:6.71%;}
#rolling01 .swiper-slide-03 .item li:nth-child(2) .desc {top:22.82%; left:9.06%; width:34.21%;}

.rolling .swiper .pagination {position:absolute; right:5.625%; bottom:4.34%; z-index:50; width:5%; height:4.347%; padding-top:0; background-repeat:no-repeat; background-position:0 0; background-size:100% 100%;}
.rolling .swiper .pagination .swiper-pagination-switch {background-color:transparent;}
.rolling .swiper .pagination01 {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160502/txt_pagination_no_01.png);}
.rolling .swiper .pagination02 {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160502/txt_pagination_no_02.png);}
.rolling .swiper .pagination03 {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160502/txt_pagination_no_03.png);}

.rolling .swiper button {position:absolute; top:44.5%; z-index:10; width:10.15%; background:transparent;}
.rolling .swiper .btn-prev {left:0;}
.rolling .swiper .btn-next {right:0;}

#rolling02 {position:relative;}
#rolling02 h3 {position:absolute; top:6.853%; left:0; z-index:10; width:100%;}
#rolling02 h3 span {display:block; position:absolute;}
#rolling02 h3 .logo {top:6.853%; left:7.81%; width:14.53%;}
#rolling02 h3 .word {top:8%; left:25%; width:56.09%;}
#rolling02 .item li {position:absolute; top:20.5%; left:33%; width:23.43%;}
#rolling02 .item li.item2 {top:32.5%; left:61%;}
#rolling02 .item li.item3 {top:70%; left:45%;}
#rolling02 .item li.item4 {top:22%; left:39%;}
#rolling02 .item li.item5 {top:68%; left:65%;}

.letsgo {position:relative;}
.letsgo p {position:absolute; top:82.61%; left:0; width:100%; text-align:center;}
.letsgo p strong {padding:0 0.8rem 0.1rem; border-bottom:1px solid #ff8a72; color:#ff8b73; font-size:1rem;}
.letsgo p img {width:10.85rem;}

.listCard {position:relative; padding:3.6% 0 6%; background:url(http://webimage.10x10.co.kr/playmo/ground/20160502/bg_pattern_blue.png) repeat-y 50% 0; background-size:100% auto;}
.listCard .leaf {position:absolute; top:0; right:8.593%; width:26.25%;}
.listCard ul {width:85.46%; margin:0 auto;}
.listCard ul li {padding-top:7%;}

.giftEvt {position:relative;}
.giftEvt legend {visibility:hidden; width:0; height:0;}
.giftEvt select {position:absolute; top:56.52%; left:50%; width:84.375%; margin-left:-42.1875%;}
.giftEvt .onlyOne {position:absolute; top:72.81%; left:0; width:100%;}
.giftEvt .btnsubmit {position:absolute; bottom:10.22%; left:50%; width:35.62%; margin-left:-17.81%;}
.giftEvt .btnsubmit input {width:100%;}

.sns {position:relative;}
.sns ul {overflow:hidden; position:absolute; bottom:12%; left:0; width:100%; padding:0 13%;}
.sns ul li {float:left; width:33.333%;}
.sns ul li a {overflow:hidden; display:block; position:relative; height:0; margin:0 6%; padding-bottom:92%; color:transparent; font-size:12px; line-height:12px; text-align:center;}
.sns ul li a span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter:alpha(opacity=0); cursor:pointer;}

.bounce {animation-name:bounce; animation-iteration-count:2; animation-duration:1s; -webkit-animation-name:bounce; -webkit-animation-iteration-count:2; -webkit-animation-duration:1s;}
@keyframes bounce {
	from, to{margin-top:0; animation-timing-function:linear;}
	50% {margin-top:5px; animation-timing-function:linear;}
}

@-webkit-keyframes bounce {
	from, to{margin-top:0; -webkit-animation-timing-function:linear;}
	50% {margin-top:5px; -webkit-animation-timing-function:linear;}
}
</style>
<script type="text/javascript">
$(function(){
	/* swiper js */
	mySwiper1 = new Swiper('#rolling01 .swiper',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		speed:700,
		pagination:"#rolling01 .pagination",
		paginationClickable:false,
		nextButton:".btn-next",
		prevButton:".btn-prev",
		onSlideChangeStart: function (mySwiper) {
			if ($(".swiper-slide-active").is(".swiper-slide-01")) {
				$(".pagination").removeClass("pagination02");
				$(".pagination").removeClass("pagination03");
				$(".pagination").addClass("pagination01");
			}
			if ($(".swiper-slide-active").is(".swiper-slide-02")) {
				$(".pagination").removeClass("pagination01");
				$(".pagination").removeClass("pagination03");
				$(".pagination").addClass("pagination02");
			}
			if ($(".swiper-slide-active").is(".swiper-slide-03")) {
				$(".pagination").removeClass("pagination01");
				$(".pagination").removeClass("pagination02");
				$(".pagination").addClass("pagination03");
			}

			/*$("#rolling01 .swiper-slide.swiper-slide-01").find("h2").delay(100).animate({"margin-top":"2%", "opacity":"0"},200);
			$("#rolling01 .swiper-slide-active.swiper-slide-01").find("h2").delay(300).animate({"margin-top":"0", "opacity":"1"},400);
			$("#rolling01 .swiper-slide.swiper-slide-01").find("p").delay(100).animate({"margin-top":"3%", "opacity":"0"},300);
			$("#rolling01 .swiper-slide-active.swiper-slide-01").find("p").delay(600).animate({"margin-top":"0", "opacity":"1"},500);

			$("#rolling01 .swiper-slide").find(".item1 .desc").delay(100).animate({"margin-right":"2%", "opacity":"0"},300);
			$("#rolling01 .swiper-slide").find(".item2 .desc").delay(100).animate({"margin-left":"2%", "opacity":"0"},300);
			$("#rolling01 .swiper-slide-active.swiper-slide-02").find(".item1 .desc").delay(50).animate({"margin-right":"0", "opacity":"1"},400);
			$("#rolling01 .swiper-slide-active.swiper-slide-02").find(".item2 .desc").delay(100).animate({"margin-left":"0", "opacity":"1"},400);
			$("#rolling01 .swiper-slide-active.swiper-slide-03").find(".item1 .desc").delay(50).animate({"margin-right":"0", "opacity":"1"},400);
			$("#rolling01 .swiper-slide-active.swiper-slide-03").find(".item2 .desc").delay(100).animate({"margin-left":"0", "opacity":"1"},400);*/
		}
	});

	mySwiper2 = new Swiper('#rolling02 .swiper',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		speed:700,
		onSlideChangeStart: function (mySwiper) {
			$("#rolling02 .swiper-slide").find(".item li a img").removeClass("bounce");
			$("#rolling02 .swiper-slide-active").find(".item li a img").addClass("bounce");
		}
	});
});
</script>
<script type="text/javascript">
$(function(){
	<% if pagereload<>"" then %>
		setTimeout("pagedown()",500);
	<% end if %>
});

function pagedown(){
	window.$('html,body').animate({scrollTop:$("#apply").offset().top}, 0);
}

function vote_play(){
	var frm = document.frm;
	var st = frm.singer.value

	<% if Not(IsUserLoginOK) then %>
		<% if isApp then %>
			calllogin();
			return false;
		<% else %>
			jsevtlogin();
			return false;
		<% end if %>
	<% end if %>

	<% If not(left(now(),10)>="2016-04-29" and left(now(),10)<"2016-05-09" ) Then %>
		alert("이벤트 응모 기간이 아닙니다.");
		return;
	<% else %>
		<% if totcnt > 0 then %>
			alert("한 개의 아이디당 한 번만 응모가 가능 합니다.");
			return;
		<% else %>
			if(st==0){
				alert('가장 만나보고 싶은\n아티스트를 선택해 주세요!');
				frm.singer.focus();
				return;
			}

			alert("응모가 완료 되었습니다.");
			frm.action = "/play/groundcnt/doEventSubscript70531.asp";
			frm.target="frmproc";
			frm.submit();
			return;
		<% end if %>
	<% end if %>
}

function jslike(sublike){
	<% If IsUserLoginOK() Then %>
		<% If not(left(now(),10)>="2016-04-29" and left(now(),10)<"2016-05-09" ) Then %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% else %>
			var str = $.ajax({
				type: "POST",
				url: "/play/groundcnt/doEventSubscript70531.asp",
				data: "mode=addok&sublike="+sublike,
				dataType: "text",
				async: false
			}).responseText;
			var str1 = str.split("||")

			if (str1[0] == "11"){
				$("#btheart").addClass("on");
				$("#btheartcnt").text(str1[1]);
				$("#btheart").text("좋아요 선택됨");

			}else if (str1[0] == "12"){
				$("#btheart").removeClass("on");
				$("#btheartcnt").text(str1[1]);
				$("#btheart").text("좋아요 해제됨");

			}else if (str1[0] == "03"){
				alert('이벤트 응모 기간이 아닙니다.');
				return false;
			}else if (str1[0] == "02"){
				alert('로그인을 해주세요.');
				return false;
			}else if (str1[0] == "01"){
				alert('잘못된 접속입니다.');
				return false;
			}else if (str1[0] == "00"){
				alert('정상적인 경로가 아닙니다.');
				return false;
			}else{
				alert('오류가 발생했습니다.');
				return false;
			}
		<% end if %>
	<% Else %>
		<% if isApp then %>
			calllogin();
			return false;
		<% else %>
			jsevtlogin();
			return false;
		<% end if %>
	<% End IF %>
}
</script>
<!-- FESTIVAL #1 이벤트 코드 : 70531 -->
<div class="mPlay20160502 togetherBom">
	<article>
		<div id="rolling01" class="rolling">
			<div class="swiper">
				<div class="swiper-container swiper">
					<div class="swiper-wrapper">
						<div class="swiper-slide swiper-slide-01">
							<span class="deco"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/img_deco_animation.gif" alt="" /></span>
							<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/tit_together_bom.png" alt="설레는 봄 햇살, 그리고 음악축제 함께, 봄" /></h2>
							<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/txt_together_bom.png" alt="기분 좋은 일상을 만드는 텐바이텐과 봄날의 페스티벌 Beautiful Mint Life 가 함께 함께, 봄 프로젝트를 준비했습니다. 꽃이 만발하는 사랑스러운 상품들과 함께 매일을 페스티벌인 것처럼 즐겨 보세요." /></p>
							<img src="http://webimage.10x10.co.kr/playmo/ground/20160502/img_slide_story_01.jpg" alt="" />
						</div>
						<div class="swiper-slide swiper-slide-02">
							<% If isapp = "1" Then %>
							<ul class="item">
								<li class="item1">
									<a href="/category/category_itemPrd.asp?itemid=1466664&amp;pEtr=70531" onclick="fnAPPpopupProduct(1466664);return false;">
										<p class="desc"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/txt_item_story_01.png" alt="아침부터 부산스럽게 거울 앞에서 이 옷 저 옷을 대보고 무얼 입을까 고민하는 것도  마냥 즐거운, 오늘은 페스티벌 가는 날" /></p>
									</a>
								</li>
								<li class="item2">
									<a href="/category/category_itemPrd.asp?itemid=1466665&amp;pEtr=70531" onclick="fnAPPpopupProduct(1466665);return false;">
										<p class="desc"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/txt_item_story_02.png" alt="직접 만든 샌드위치, 깨끗한 플랫슈즈 추억을 찍어줄 카메라. 넉넉한 에코백 안에 설렘까지 가득 담아 볼래요" /></p>
									</a>
								</li>
							</ul>
							<% Else %>
							<ul class="item">
								<li class="item1">
									<a href="/category/category_itemPrd.asp?itemid=1466664&amp;pEtr=70531">
										<p class="desc"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/txt_item_story_01.png" alt="아침부터 부산스럽게 거울 앞에서 이 옷 저 옷을 대보고 무얼 입을까 고민하는 것도  마냥 즐거운, 오늘은 페스티벌 가는 날" /></p>
									</a>
								</li>
								<li class="item2">
									<a href="/category/category_itemPrd.asp?itemid=1466665&amp;pEtr=70531">
										<p class="desc"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/txt_item_story_02.png" alt="직접 만든 샌드위치, 깨끗한 플랫슈즈 추억을 찍어줄 카메라. 넉넉한 에코백 안에 설렘까지 가득 담아 볼래요" /></p>
									</a>
								</li>
							</ul>
							<% End If %>
							<img src="http://webimage.10x10.co.kr/playmo/ground/20160502/img_slide_story_02.jpg" alt="" />
						</div>
						<div class="swiper-slide swiper-slide-03">
							<% If isapp = "1" Then %>
							<ul class="item">
								<li class="item1">
									<a href="/category/category_itemPrd.asp?itemid=1466666&amp;pEtr=70531" onclick="fnAPPpopupProduct(1466666);return false;">
										<p class="desc"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/txt_item_story_03.png" alt="아, 잊으면 안돼요! 페스티벌 티켓과 타임 테이블, 요긴하게 쓰일 손수건도 오늘을 기념할 브로치까지 꼭 챙겨 주세요. 예쁜 파우치 속에 쏙쏙!" /></p>
									</a>
								</li>
								<li class="item2">
									<a href="/category/category_itemPrd.asp?itemid=1466667&amp;pEtr=70531" onclick="fnAPPpopupProduct(1466667);return false;">
										<p class="desc"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/txt_item_story_04.png" alt="마지막으로 예뻐지는 아이템 장착! 우리를 페스티벌 레이디로 만들어 줄 트윌리 리본을 머리에, 손목에 둘러 주세요. 오늘은 우리가 주인공!" /></p>
									</a>
								</li>
							</ul>
							<% Else %>
							<ul class="item">
								<li class="item1">
									<a href="/category/category_itemPrd.asp?itemid=1466666&amp;pEtr=70531">
										<p class="desc"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/txt_item_story_03.png" alt="아, 잊으면 안돼요! 페스티벌 티켓과 타임 테이블, 요긴하게 쓰일 손수건도 오늘을 기념할 브로치까지 꼭 챙겨 주세요. 예쁜 파우치 속에 쏙쏙!" /></p>
									</a>
								</li>
								<li class="item2">
									<a href="/category/category_itemPrd.asp?itemid=1466667&amp;pEtr=70531">
										<p class="desc"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/txt_item_story_04.png" alt="마지막으로 예뻐지는 아이템 장착! 우리를 페스티벌 레이디로 만들어 줄 트윌리 리본을 머리에, 손목에 둘러 주세요. 오늘은 우리가 주인공!" /></p>
									</a>
								</li>
							</ul>
							<% End If %>
							<img src="http://webimage.10x10.co.kr/playmo/ground/20160502/img_slide_story_03.jpg" alt="" />
						</div>
					</div>
				</div>
				<div class="pagination"></div>
				<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/btn_prev.png" alt="이전" /></button>
				<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/btn_next.png" alt="다음" /></button>
			</div>
		</div>

		<section class="letsgo">
			<h4><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/tit_lets_go.jpg" alt="자, 이제 출발 할까요? 페스티벌 즐기러!" /></h4>
			<!-- for dev msg : id 넣어주세요 로그인전에는 "당신" -->
			<p><strong><% If IsUserLoginOK Then response.write userid else response.write "당신" end if %></strong> <img src="http://webimage.10x10.co.kr/playmo/ground/20160502/txt_with.png" alt="과 함께 페스티벌을 봄" /></p>
		</section>

		<div class="listCard">
			<span class="leaf"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/img_leaf_animation_v1.gif" alt="" /></span>
			<% If isapp = "1" Then %>
			<ul>
				<li><a href="/category/category_itemPrd.asp?itemid=1466667&amp;pEtr=70531" onclick="fnAPPpopupProduct(1466667);return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/img_item_twilly_ribon.png" alt="트윌리 즐겨 듣던 노래를 귀를 쫑긋 세우고  듣는 기분은 정말 최고!" /></a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=1466664&amp;pEtr=70531" onclick="fnAPPpopupProduct(1466664);return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/img_item_tshirt.png" alt="자수 티셔츠 꽃 선물은 언제나 옳다! 오랜만에 만나는 친구에게  #뷰티풀 하게 인사나누기  " /></a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=1466669&amp;pEtr=70531" onclick="fnAPPpopupProduct(1466669);return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/img_item_pinbutton.png" alt="핀버튼 현장에서만 판매하는 에디션 득템! 리스모양의 버튼이 너무나도 상콤해!" /></a></li>
			</ul>
			<% Else %>
			<ul>
				<li><a href="/category/category_itemPrd.asp?itemid=1466667&amp;pEtr=70531"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/img_item_twilly_ribon.png" alt="트윌리 즐겨 듣던 노래를 귀를 쫑긋 세우고  듣는 기분은 정말 최고!" /></a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=1466664&amp;pEtr=70531"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/img_item_tshirt.png" alt="자수 티셔츠 꽃 선물은 언제나 옳다! 오랜만에 만나는 친구에게  #뷰티풀 하게 인사나누기  " /></a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=1466669&amp;pEtr=70531"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/img_item_pinbutton.png" alt="핀버튼 현장에서만 판매하는 에디션 득템! 리스모양의 버튼이 너무나도 상콤해!" /></a></li>
			</ul>
			<% End If %>
		</div>

		<section id="rolling02" class="rolling">
			<h3>
				<span class="logo"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/img_logo_bml.png" alt="" /></span>
				<span class="word"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/tit_bml.png" alt="" /></span>
			</h3>
			<div class="swiper">
				<div class="swiper-container swiper">
					<div class="swiper-wrapper">
						<div class="swiper-slide swiper-slide-01">
							<% If isapp = "1" Then %>
							<ul class="item">
								<li class="item1"><a href="/category/category_itemPrd.asp?itemid=1466664&amp;pEtr=70531" onclick="fnAPPpopupProduct(1466664);return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/btn_plus.png" alt="자수 티셔츠" /></a></li>
								<li class="item2"><a href="/category/category_itemPrd.asp?itemid=1466668&amp;pEtr=70531" onclick="fnAPPpopupProduct(1466668);return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/btn_plus.png" alt="브로치" /></a></li>
								<li class="item3"><a href="/category/category_itemPrd.asp?itemid=1466666&amp;pEtr=70531" onclick="fnAPPpopupProduct(1466666);return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/btn_plus.png" alt="파우치" /></a></li>
							</ul>
							<% Else %>
							<ul class="item">
								<li class="item1"><a href="/category/category_itemPrd.asp?itemid=1466664&amp;pEtr=70531"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/btn_plus.png" alt="자수 티셔츠" /></a></li>
								<li class="item2"><a href="/category/category_itemPrd.asp?itemid=1466668&amp;pEtr=70531"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/btn_plus.png" alt="브로치" /></a></li>
								<li class="item3"><a href="/category/category_itemPrd.asp?itemid=1466666&amp;pEtr=70531"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/btn_plus.png" alt="파우치" /></a></li>
							</ul>
							<% End If %>
							<img src="http://webimage.10x10.co.kr/playmo/ground/20160502/img_slide_item_01.jpg" alt="" />
						</div>
						<div class="swiper-slide swiper-slide-02">
							<% If isapp = "1" Then %>
							<ul class="item">
								<li class="item4"><a href="/category/category_itemPrd.asp?itemid=1466667&amp;pEtr=70531" onclick="fnAPPpopupProduct(1466667);return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/btn_plus.png" alt="트윌리" /></a></li>
								<li class="item5"><a href="/category/category_itemPrd.asp?itemid=1466665&amp;pEtr=70531" onclick="fnAPPpopupProduct(1466665);return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/btn_plus.png" alt="에코백" /></a></li>
							</ul>
							<% Else %>
							<ul class="item">
								<li class="item4"><a href="/category/category_itemPrd.asp?itemid=1466667&amp;pEtr=70531"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/btn_plus.png" alt="트윌리" /></a></li>
								<li class="item5"><a href="/category/category_itemPrd.asp?itemid=1466665&amp;pEtr=70531"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/btn_plus.png" alt="에코백" /></a></li>
							</ul>
							<% End If %>
							<img src="http://webimage.10x10.co.kr/playmo/ground/20160502/img_slide_item_02.jpg" alt="" />
						</div>
					</div>
				</div>
			</div>
		</section>

		<!-- gift event -->
		<section class="giftEvt">
			<h3 class="hidden">gift event</h3>
			<form name="frm" method="post">
			<input type="hidden" name="mode" value="add"/>
			<input type="hidden" name="pagereload" value="ON"/>
				<fieldset>
					<legend>가장 만나 보고 싶은 아티스트 선택하기</legend>
					<p class="choice" id="apply"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/txt_gift_event.png" alt="가장 만나 보고 싶은 아티스트를 선택해 주세요! 추첨을 통해 총 10분께 원하는 팀이 출연하는 날짜의 BML 2016 티켓 1일권, 2매를 선물로 드립니다. 응모 기간은 5월 2일부터 8일까지며 당첨일은 5월 9일입니다." /></p>
					<p class="onlyOne"><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/txt_only_one.png" alt="" /></p>

					<select name="singer" title="가장 만나 보고 싶은 아티스트 선택">
						<option value="0">라인업 확인 후 선택하기</option>
						<option value="0">-- 5월 14일(토) 라인업--</option>
						<option value="1">노리플라이</option>
						<option value="2">김사월</option>
						<option value="3">롱디</option>
						<option value="4">로이킴</option>
						<option value="5">랄라스윗</option>
						<option value="6">멜로망스</option>
						<option value="7">브로콜리너마저</option>
						<option value="8">안녕하신가영</option>
						<option value="9">수란</option>
						<option value="10">빌리어코스티</option>
						<option value="11">옥상달빛</option>
						<option value="12">위아더나잇</option>
						<option value="13">선우정아</option>
						<option value="14">임헌일</option>
						<option value="15">플레이모드</option>
						<option value="16">제이레빗</option>
						<option value="17">치즈</option>
						<option value="18">호소</option>
						<option value="19">피터팬 컴플렉스</option>
						<option value="20">페퍼톤스</option>
						<option value="0">-- 5월 15일(일) 라인업--</option>
						<option value="21">10cm</option>
						<option value="22">마이큐</option>
						<option value="23">신세하</option>
						<option value="24">글렌체크</option>
						<option value="25">몽니</option>
						<option value="26">신현희와 김루트</option>
						<option value="27">데이브레이크</option>
						<option value="28">샘김</option>
						<option value="29">유근호</option>
						<option value="30">소란</option>
						<option value="31">소심한 오빠들</option>
						<option value="32">전자양</option>
						<option value="33">스탠딩 에그</option>
						<option value="34">쏜애플</option>
						<option value="35">타루</option>
						<option value="36">어쿠스틱 콜라보</option>
						<option value="37">정재원</option>
						<option value="38">페이퍼컷 프로젝트</option>
						<option value="39">이지형</option>
						<option value="40">정준일</option>
					</select>

					<div class="btnsubmit" onclick="vote_play(); return false;"><input type="image" src="http://webimage.10x10.co.kr/playmo/ground/20160502/btn_submit.png" alt="응모하기" /></div>
				</fieldset>
			</form>
		</section>

		<!-- sns -->
		<section id="sns" class="sns">
			<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20160502/tit_sns.png" alt="함께, 봄 당첨확률 높이기" /></h3>
			<ul>
				<li class="kakao"><a href="#" onclick="parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>');return false;"><span></span>카카오톡으로 공유하기</a></li>
				<li class="facebook"><a href="#" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');return false;"><span></span>페이스북으로 공유하기</a></li>
				<li class="twitter"><a href="#" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');return false;"><span></span>트위터로 공유하기</a></li>
			</ul>
		</section>
	</article>
</div>
<!-- //FESTIVAL #1 -->
<iframe id="frmproc" name="frmproc" frameborder="0" width=0 height=0></iframe>
<!-- #include virtual="/lib/db/dbclose.asp" -->