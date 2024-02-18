<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("[텐바이텐 17주년]\n잘 사고 잘 받자")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/17th/gift.asp")
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/eventIMG/2018/88942/etcitemban20180921085050.JPEG")
appfblink	= "http://m.10x10.co.kr/event/17th/gift.asp"

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐 17주년]\n잘 사고 잘 받자!"
Dim kakaodescription : kakaodescription = "텐바이텐에서 즐겁게 쇼핑하고\n슬기로운 사은품 받으세요!"
Dim kakaooldver : kakaooldver = "텐바이텐에서 즐겁게 쇼핑하고\n슬기로운 사은품 받으세요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2018/88942/etcitemban20180921085050.JPEG"
Dim kakaolink_url 

kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/17th/gift.asp"

	'=============================== 품절 여부
dim isGiftSoldOutArr(), strSql, i	
redim preserve isGiftSoldOutArr(2)	
	isGiftSoldOutArr(0) = 0
	isGiftSoldOutArr(1) = 0
	
	'17451 : 마켓비 사이트 테이블 	  index-0
	'17448 : 모즈 에스프레소 커피머신 index-1

	strSql = " SELECT CASE 													"	
	strSql = strSql & "		WHEN GIFTKIND_LIMIT = GIFTKIND_GIVECNT THEN 1	"
	strSql = strSql & "		ELSE 0											"		
	strSql = strSql & "		END AS RESULT									"	
	strSql = strSql & "  FROM DB_EVENT.DBO.TBL_GIFT							"		
	strSql = strSql & " WHERE 1 = 1								"				
	strSql = strSql & " and EVT_CODE = 88942								"			
	'strSql = strSql & "   AND GIFT_CODE IN (17412, 17409)					"		'테스트
	strSql = strSql & "   AND GIFT_CODE IN (17451, 17448)					"		
	strSql = strSql & " ORDER BY GIFT_CODE DESC								"				
	
	rsget.CursorLocation = adUseClient
	rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly
	
	if Not rsget.Eof Then
		    i = 0			
			do until rsget.eof
				isGiftSoldOutArr(i)	= rsget("result")
				i=i+1
				rsget.moveNext
			loop
	End If
	rsget.close

%>
<style type="text/css">
/* 공통 */
.sns-share {position:relative; background-color:#4753c9;}
.sns-share ul {display:flex; position:absolute; top:0; right:0; height:100%;justify-content:flex-end; align-items:center; margin-right:2.21rem; }
.sns-share li {width:4.05rem; margin-left:.77rem;}

.mEvt88942 .inner-wrap{background:url('http://webimage.10x10.co.kr/fixevent/event/2018/17th/88942/bg_jal.png') center top /cover no-repeat;position:relative;}
.mEvt88942 .inner-wrap:before,.mEvt88942 .inner-wrap:after{width:100%;min-height:375px;position:absolute;top:0;content:'';display:block;animation: twinkle 4s both ease-in-out infinite;background-size:contain}
@keyframes twinkle{
    0%{opacity:1}
    50%{opacity:0}
    80%{opacity:1}
}
.mEvt88942 .inner-wrap:before{background-image:url('http://webimage.10x10.co.kr/fixevent/event/2018/17th/88942/m/bg_star_02.png')}
.mEvt88942 .inner-wrap:after{background-image:url('http://webimage.10x10.co.kr/fixevent/event/2018/17th/88942/m/bg_star_03.png');animation-delay: 2s;background-position-y:-10px}
.mEvt88942 h2{padding-top:18%;position:relative;margin-bottom:9.5%;}
.mEvt88942 h2:before,.mEvt88942 h2:after{position:absolute;content:'';display:block;height:25px;width:4%;background:url('http://webimage.10x10.co.kr/fixevent/event/2018/17th/88942/m/bg_star_01.png') right center /100% auto no-repeat;animation: twinkle 3s both cubic-bezier(0.79, -0.15, 0.1, 1.07) infinite;}
.mEvt88942 h2:before{top:65%;left:6%}
.mEvt88942 h2:after{top:28%;right:20%;animation-delay: 1.5s;}
.mEvt88942 .swiper-container,
.mEvt88942 .swiper-wrapper{width:85%;}
.mEvt88942 .swiper-container{overflow:unset;}
.mEvt88942 .swiper-button-next,.mEvt88942 .swiper-button-prev{z-index:10; width:6.5%; margin-top:-1.5rem; }
.mEvt88942 .swiper-button-prev{left:calc(-6.5% + 4px)}
.mEvt88942 .swiper-button-next{right:calc(-6.5% + 4px);}
.mEvt88942 .slide,.mEvt88942 .slidesjs-container{position:relative;height:602px !important;margin:0 auto;}
.mEvt88942 .swiper-slide{border-radius:2rem;overflow:hidden;border:4px solid #4a0093;}
.mEvt88942 span{padding: 1.5rem 0 4.5rem;display: block;}
.mEvt88942 .prd{padding-bottom:1.7rem}
.mEvt88942 .prd img{width:100%;margin-bottom: 1rem;}
.mEvt88942 .noti {background:#1f0d4d;padding-bottom:5rem}
.mEvt88942 .noti .inner{width:1140px;margin:0 auto;}
.mEvt88942 .noti h3{width:25%;margin:0 auto;padding:5rem 0 3rem}
.mEvt88942 .noti ul{padding:0 3rem}
.mEvt88942 .noti ul li{color:#fff;text-align:left;line-height: 2em;font-family: 'malgunGothic', '맑은고딕', sans-serif;letter-spacing: -1px;position:relative}
.mEvt88942 .noti ul li:before{content:'-';display:inline-block;width:10px;position:absolute;left:-10px}
.mEvt88942 .noti ul li b{font-weight:bold}
.mEvt88942 .noti ul li a{background-color:#b124c2;display:inline-block;line-height: 22px;color: #f8ebff;padding: 0 7px;}
.mEvt88942 .noti ul li a:hover{text-decoration:none}
</style>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>	
<script type="text/javascript">
$(function(){
	fnAmplitudeEventMultiPropertiesAction('view_17th_gift','','');
	titSwiper = new Swiper("#slide",{
        loop:true,
		autoplay:1600,
		speed:1000,
		effect:'fade',
		nextButton:'.swiper-button-next',
		prevButton:'.swiper-button-prev'
	});
    
});
function snschk(snsnum) {
	if(snsnum=="fb"){
		popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','');		
	}else if(snsnum=="pt"){
		popSNSPost('pt','<%=snpTitle%>','<%=snpLink%>','','<%=snpImg%>');
	}else if(snsnum=="ka"){
		fnAPPshareKakao('etc','<%=kakaotitle%>\n<%=kakaodescription%>','<%=kakaolink_url%>','<%=kakaolink_url%>','<%="url="&kakaolink_url%>','<%=kakaoimage%>','','','','');
		return false;	
	}
}
function parent_kakaolink(label , imageurl , width , height , linkurl ){
	//카카오 SNS 공유
	Kakao.init('c967f6e67b0492478080bcf386390fdd');

	Kakao.Link.sendTalkLink({
		label: label,
		image: {
		src: imageurl,
		width: width,
		height: height
		},
		webButton: {
			text: '10x10 바로가기',
			url: linkurl
		}
	});
}

//카카오 SNS 공유 v2.0
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
</head>
<body class="default-font body-sub bg-grey"><!-- for dev msg : GNB메뉴에서 들어갈때만 body-main클래스가 붙습니다. 그 이외의 페이지에서는 body-sub가 붙습니다. -->	
	<!-- contents -->
	<div id="content" class="content">		
		<div class="evtContV15">
			<!-- 잘 사고 잘 받자 -->
			<div class="mEvt88942 ">
				<div class="inner-wrap">
					<h2><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88942/m/tit_evt88942.png" alt="잘 사고 잘 받자" /></h2>
                    <div id="slide" class="swiper-container">
						<div class="swiper-wrapper">
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88942/m/img_slide_01.png?v=1.01" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88942/m/img_slide_02.png?v=1.01" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88942/m/img_slide_03.png?v=1.01" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88942/m/img_slide_04.png?v=1.01" alt="" /></div>
						</div>
                        <div class="swiper-button-prev"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88942/m/img_slide_prev.png" alt="이전" /></div>
                        <div class="swiper-button-next" style="z-index:10"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88942/m/img_slide_next.png" alt="다음" /></div>
					</div>
                    <span><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88942/m/txt_01.png" alt="텐바이텐 배송상품을 포함하여야 사은품 선택이 가능합니다" /></span>
                    <div class="prd">
                        <img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88942/m/img_prd_01.png" alt="5만원 이상 구매 시" />                                                
						<% if isGiftSoldOutArr(0) = 0 then %>
                       		<a href="#" onclick="TnGotoProduct('1730435');return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88942/m/img_prd_02.png" alt="20만원 이상 구매 시" /></a>
						<% else %>
                     	    <img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88942/m/img_prd_02_soldout.png?v=1.01" alt="20만원 이상 구매 시" />						
						<% end if %>
						<% if isGiftSoldOutArr(1) = 0 then %>
							<a href="#" onclick="TnGotoProduct('2051029');return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88942/m/img_prd_03.png" alt="100만원 이상 구매 시" /></a>
						<% else %>
                  	        <img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88942/m/img_prd_03_soldout.png?v=1.01" alt="100만원 이상 구매 시" />						
						<% end if %>							
                    </div>
				</div>
				<!-- 유의사항 -->
				<div class="noti">
					<h3><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88942/m/tit_notice.png" alt="유의사항" /></h3>
					<ul>
						<li>본 이벤트는 텐바이텐 회원님을 위한 혜택입니다. <br />(비회원 구매 시, 증정 불가)</li>
                        <li><b>텐바이텐 배송상품을 포함하여야 사은품 선택이 가능합니다.</b><br /><a href="javascript:fnAPPpopupBrowserURL('텐바이텐 배송상품','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=89269');">텐바이텐 배송상품 보러가기 ></a></li>
                        <li>쿠폰, 할인카드 등을 적용한 후 구매확정 금액이 5 / 20 / 100만원 이상이어야 합니다. (단일주문건 구매 확정액)</li>
                        <li>마일리지, 예치금, 기프트카드를 사용하신 경우는 구매확정 금액에 포함되어 사은품을 받으실 수 있습니다.</li>
                        <li>텐바이텐 기프트카드를 구매하신 경우는 사은품 증정이 되지 않습니다.</li>
                        <li>마일리지는 차후 일괄 지급입니다. <br />1차 : 10월 24일 (~17일까지 주문내역 기준)<br />2차 : 10월 31일 (~24일까지 주문내역 기준)<br />3차 : 11월 7일 (~31까지 주문내역 기준)</li>
                        <li>환불이나 교환 시 최종 구매 가격이 사은품 수량 가능금액 미만이 될 경우, 사은품과 함께 반품해야 합니다.</li>
                        <li>각 상품별 한정 수량이므로 조기에 소진될 수 있습니다.</li>
					</ul>
				</div>
		<% If Now() > #10/10/2018 00:00:00# AND Now() < #10/31/2018 23:59:59# Then  %>		
			<% if isApp = 1 then %>		
			<a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/17th/');"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_bnr_main.jpg" alt="텐텐 슬기로운 생활 17주년 메인으로 이동" /></a>				
			<% else %>
			<a href="/event/17th/index.asp"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_bnr_main.jpg" alt="텐텐 슬기로운 생활 17주년 메인으로 이동" /></a>				
			<% end if %>				
		<% end if %>				
				<!-- SNS공유 -->
				<div class="sns-share">
					<img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/m/tit_share.png" alt="즐거운 공유생활 친구들과 혜택을 나누세요!" />
					<ul>
						<li class="fb"><a href="#" onclick="snschk('fb'); return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/m/img_fb.png" alt="페이스북으로 공유" /></a></li>
						<li class="kakao"><a href="#" onclick="snschk('ka'); return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/m/img_kakao.png" alt="카카오톡으로 공유" /></a></li>
					</ul>
				</div>			
			</div>
		</div>
		<!--// 이벤트 배너 등록 영역 -->
	</div>
	<!-- //contents -->	
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->