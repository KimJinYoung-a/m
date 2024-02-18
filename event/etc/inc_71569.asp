<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'###########################################################
' Description : [텐바이텐 X 월드비전] Waterful Christimas, 그 세번째 이야기.
' History : 2016.07.25 유태욱
'###########################################################
Dim eCode, cnt, sqlStr, i, vUserID, subsctiptcnt


If application("Svr_Info") = "Dev" Then
	eCode 		= "66174"
Else
	eCode 		= "71569"
End If

vUserID		= GetEncLoginUserID

'총 응모 횟수
sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &" "
rsget.Open sqlstr, dbget, 1
	subsctiptcnt = rsget("cnt")
rsget.close

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle	= Server.URLEncode("[텐바이텐] Waterful Christmas!")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode)
snpPre		= Server.URLEncode("10x10 이벤트")
'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐] 기분 좋은 쇼핑이 시원한 물이 되어\n방글라데시 아이들에게 선물이 됩니다.\n\n텐바이텐과 월드비전이 함께 만든\n식수기부 캠페인\n<Waterful Christmas>에\n당신의 마음도 함께 해주세요."
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/71569/m/img_kakao.jpg"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url 
If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
End If
%>
<style type="text/css">
img {vertical-align:top;}

#rolling .app {display:none;}

.rolling {background-color:#dffbff;}
.rolling .swiper {position:relative;}
.rolling .swiper .swiper-container {width:100%;}
.rolling button {position:absolute; top:28%; z-index:5; width:11%; padding:2%; background-color:transparent;}
.rolling .swiper .btn-prev {left:0;}
.rolling .swiper .btn-next {right:0;}

.withYou {padding-bottom:7%; background-color:#89e1e5;}
.withYou ul {overflow:hidden; width:48%; margin:1% auto;}
.withYou ul li {float:left; width:33.333%;}
.withYou ul li a {display:block; margin:0 8%;}
.withYou ul li a:hover img, .withYou ul li a:active img {animation-name:pulse; animation-duration:1s; -webkit-animation-name:pulse; -webkit-animation-duration:1s;}
@keyframes pulse {
	0% {transform:scale(1);}
	50% {transform:scale(0.9);}
	100% {transform:scale(1);}
}
@-webkit-keyframes pulse {
	0% {-webkit-transform:scale(1);}
	50% {-webkit-transform:scale(0.9);}
	100% {-webkit-transform:scale(1);}
}
.withYou .count {overflow:hidden; width:27.8rem; margin:5% auto 0;}
.withYou .count .desc {float:left; width:13.15rem; margin:0 0.375rem; padding:0.9rem; border-radius:0.9rem; background-color:#fff; text-align:center;}
.withYou .count .desc h4 {width:9.5rem; margin:0 auto;}
.withYou .count .desc p {margin-top:0.5rem;}
.withYou .count .desc p img {width:1.1rem;}
.withYou .count .desc p b {margin:0 0.2rem; color:#55b5dc; font-size:1.3rem; font-weight:bold; line-height:1.125em;}

.noti {padding-bottom:7%; background-color:#f0f0f0;}
.noti ul {padding:0 7.5%;}
.noti ul li {position:relative; margin-top:0.3rem; padding-left:1rem; color:#444; font-size:1rem; line-height:1.688em;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.7rem; left:0; width:0.4rem; height:0.1rem; background-color:#444;}
</style>
<script type="text/javascript">
$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt72088").offset().top}, 0);
});

$(function(){
	mySwiper = new Swiper('#rolling .swiper',{
		loop:true,
		autoplay:2000,
		speed:800,
		paginationClickable:true,
		nextButton:'#rolling .btn-next',
		prevButton:'#rolling .btn-prev'
	});

	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
			$("#item .app, #rolling .app").show();
			$("#item .mo, #rolling .mo").hide();
	}else{
			$("#item .app, #rolling .app").hide();
			$("#item .mo, #rolling .mo").show();
	}
});

function snschk(snsnum) {
	<% If vUserID = "" Then %>
		if ("<%=IsUserLoginOK%>"=="False") {
			<% If isApp = 1 Then %>
				parent.calllogin();
				return false;
			<% Else %>
				parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
				return false;
			<% End If %>
			return false;
		}
	<% End If %>
	<% If vUserID <> "" Then %>
	var reStr;
	var str = $.ajax({
		type: "GET",
		url:"/event/etc/doeventsubscript/doEventSubscript71569.asp",
		data: "mode=snschk&snsnum="+snsnum,
		dataType: "text",
		async: false
	}).responseText;
		reStr = str.split("|");
		if(reStr[0]=="OK"){
			if(reStr[1] == "tw") {
				popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');
				$("#ttcnt").empty().html(reStr[2]);
				$("#ttprice").empty().html(reStr[2]*100);
			}else if(reStr[1]=="fb"){
				popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
				$("#ttcnt").empty().html(reStr[2]);
				$("#ttprice").empty().html(reStr[2]*100);
			}else if(reStr[1]=="ka"){
				<% If isApp = "1" Then %>
					parent_kakaolink('[텐바이텐] 기분 좋은 쇼핑이 시원한 물이 되어\n방글라데시 아이들에게 선물이 됩니다.\n\n텐바이텐과 월드비전이 함께 만든\n식수기부 캠페인\n<Waterful Christmas>에\n당신의 마음도 함께 해주세요.', 'http://webimage.10x10.co.kr/eventIMG/2016/71569/m/img_kakao.jpg' , '200' , '200' , 'http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=71569' );
				<% Else %>
					parent_kakaolink('[텐바이텐] 기분 좋은 쇼핑이 시원한 물이 되어\n방글라데시 아이들에게 선물이 됩니다.\n\n텐바이텐과 월드비전이 함께 만든\n식수기부 캠페인\n<Waterful Christmas>에\n당신의 마음도 함께 해주세요.' , 'http://webimage.10x10.co.kr/eventIMG/2016/71569/m/img_kakao.jpg' , '200' , '200' , 'http://m.10x10.co.kr/event/eventmain.asp?eventid=71569' );
				<% End If %>
				return false;
			}else if(reStr[1] == "end"){
				alert('한 ID당 한번만 참여하실 수 있습니다.');
				return false;
			}else{
				alert('오류가 발생했습니다.');
				return false;
			}
		}else{
			errorMsg = reStr[1].replace(">?n", "\n");
			alert(errorMsg);
			document.location.reload();
			return false;
		}
	<% End If %>
}
</script>
	<!-- [M/A] 71569 Waterful Christimas -->
	<div class="mEvt72088 waterfulChristimas">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/71569/m/txt_waterful_christmas_v1.gif" alt="텐바이텐과 월드비전이 함께 합니다. 깨끗한 물이 필요한 곳에 당신의 마음을 전하세요! 구매금액의 일부가 기부됩니다. 2016 S/S 캠페인 런칭기념 20% 할인!" /></p>

		<div id="rolling" class="rolling">
			<div class="swiper">
				<div class="swiper-container swiper">
					<div class="swiper-wrapper">
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=1519374&amp;pEtr=71569" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71569/m/img_slide_01_v2.jpg" alt="스마트폰 케이스 스티커, 워터풀" /></a>
							<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1519374&amp;pEtr=71569" onclick="fnAPPpopupProduct('1519374&amp;pEtr=71569');return false;" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71569/m/img_slide_01_v2.jpg" alt="스마트폰 케이스 스티커, 워터풀" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=1519372&amp;pEtr=71569" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71569/m/img_slide_02.jpg" alt="에코백" /></a>
							<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1519372&amp;pEtr=71569" onclick="fnAPPpopupProduct('1519372&amp;pEtr=71569');return false;" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71569/m/img_slide_02.jpg" alt="에코백" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=1519375&amp;pEtr=71569" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71569/m/img_slide_03.jpg" alt="크림 글라스 우산, 나뭇잎" /></a>
							<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1519375&amp;pEtr=71569" onclick="fnAPPpopupProduct('1519375&amp;pEtr=71569');return false;" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71569/m/img_slide_03.jpg" alt="크림 글라스 우산, 나뭇잎" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=1519373&amp;pEtr=71569" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71569/m/img_slide_04.jpg" alt="파우치" /></a>
							<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1519373&amp;pEtr=71569" onclick="fnAPPpopupProduct('1519373&amp;pEtr=71569');return false;" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71569/m/img_slide_04.jpg" alt="파우치" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=1519376&amp;pEtr=71569" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71569/m/img_slide_05.jpg" alt="사인 스티커" /></a>
							<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1519376&amp;pEtr=71569" onclick="fnAPPpopupProduct('1519376&amp;pEtr=71569');return false;" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71569/m/img_slide_05.jpg" alt="사인 스티커" /></a>
						</div>
					</div>
				</div>
				<div class="pagination"></div>
				<button type="button" class="btn-prev"><img src="http://fiximage.10x10.co.kr/m/2015/event/btn_slide_prev.png" alt="이전" /></button>
				<button type="button" class="btn-next"><img src="http://fiximage.10x10.co.kr/m/2015/event/btn_slide_next.png" alt="다음" /></button>
			</div>
		</div>

		<div class="intro">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/71569/m/txt_intro_01.png" alt="Waterful Christimas 캠페인은 더러운 물과 비위생적인 환경 때문에 목숨을 잃는 아이들에게 깨끗한 물과 내일의 희망을 선물하고자 기획되었습니다. 매일매일 우리 모두에게 특별한 크리스마스를 만들어주고 싶은 텐바이텐과 월드비전, 서커스보이밴들의 마음을 가득 담았죠. 본 프로젝트를 통해 런칭하는 상품 판매 수익금 중 일부는 월드비전을 통해 방글라데시 식수 사업에 지원됩니다. 여러분의 기분 좋은 실천으로 Waterful 기적을 만들어 주세요!" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/71569/m/txt_intro_02.png" alt="함께 해주세요! 마음을 담아 Waterful Christmas 굿즈 구매하시면 텐바이텐을 통해 판매 수익금 중 일부를 월드비전에 전달 하여, 방글라데시의 식수가 필요한 마을에 식수펌프 설치 되어 아이들이 보다 쉽게 깨끗한 물을 마실 수 있어요!" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/71569/m/txt_intro_03.jpg" alt="이렇게 좋아져요! 식수를 얻기 위해 20km씩 걸어 다니던 시간이 줄어 아이들의 학교 출석률이 높아져요. 농작물도 건강하게 자라기 때문에 수확이 가능하고 아이들 가정의 소득도 증대돼요. 건강하게 클 수 있어요 수인성 질병의 발생이 줄어 유아 사망률이 낮아지고 영양 개선에도 도움이 돼요." /></p>
		</div>

		<div class="withYou">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/71569/m/tit_event_with_you.png" alt="Event With You Waterful Christmas 캠페인을 여러분의 친구들에게도 소개해주세요! SNS에 공유된 횟수들 만큼 100원씩 기부금으로 적립됩니다." /></h3>

			<!-- for dev msg: sns 공유 -->
			<ul>
				<li><a href="" onclick="snschk('fb'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71569/m/ico_facebook.png" alt="페이스북에 공유하기" /></a></li>
				<li><a href="" onclick="snschk('tw'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71569/m/ico_twitter.png" alt="트위터에 공유하기" /></a></li>
				<li><a href="" onclick="snschk('ka'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71569/m/ico_kakao.png" alt="카카오톡으로 공유하기" /></a></li>
			</ul>

			<!-- for dev msg: 카운트 -->
			<div class="count">
				<div class="desc">
					<h4><img src="http://webimage.10x10.co.kr/eventIMG/2016/71569/m/tit_count_heart.png" alt="현재 공유된 따뜻한 마음" /></h4>
					<p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/71569/m/txt_total.png" alt="총" />
						<b id="ttcnt"><%= subsctiptcnt %></b>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/71569/m/txt_no.png" alt="분" />
					</p>
				</div>
				<div class="desc">
					<h4><img src="http://webimage.10x10.co.kr/eventIMG/2016/71569/m/tit_count_amount.png" alt="현재 적립된 금액" /></h4>
					<p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/71569/m/txt_total.png" alt="총" />
						<b id="ttprice"><%= subsctiptcnt*100 %></b>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/71569/m/txt_won.png" alt="원" />
					</p>
				</div>
			</div>
		</div>

		<div class="noti">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/71569/m/tit_noti.png" alt="이벤트 유의사항" /></h3>
			<ul>
				<li>2016년 8월 15일 (월) 자정까지 공유된 횟수를 기준으로 합니다.</li>
				<li>한 ID당 한번만 참여하실 수 있습니다.</li>
				<li>카카오톡을 이용한 공유는 모바일 웹 또는 APP에서 참여하실 수 있습니다.</li>
				<li>모인 기부금은 판매 수익금과 합해 월드비전에 전달됩니다.</li>
				<li>본 이벤트는 상황에 따라 조기종료 될 수 있습니다.</li>
			</ul>
		</div>
	</div>
	<!--// Waterful Christimas -->
<!-- #include virtual="/lib/db/dbclose.asp" -->