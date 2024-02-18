<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 리뉴얼 안내 페이지
' History : 2021-03-15 정태훈 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/event/renewal/mediaCls.asp"-->
<%
dim totalLikeCount, myLikeCount, ObjMedia, LoginUserid, vCidx, Device
vCidx = 1
LoginUserid = getencLoginUserid()
set ObjMedia = new MediaCls
totalLikeCount = ObjMedia.getContentsLikeCount(vCidx)
myLikeCount = ObjMedia.getMylikeCount(LoginUserid, vCidx)
Device = flgDevice
dim ckAgent : ckAgent = Lcase(Request.ServerVariables("HTTP_USER_AGENT"))
%>
<link rel="stylesheet" type="text/css" href="/lib/css/renew.css?v=1.21">
<script>
$(function() {
    getVoteInfo();
	// 타이틀 deco 순차 등장
	$('.renew .topic .deco').each(function(i, el) {
		window.setTimeout(function() {
			$(el).css('opacity',1);
		}, 500*i + 2000);
	});
	// 리스트패키지 안내 롤링
	var swiper = new Swiper('.renew .slider .swiper-container', {
		slidesPerView: 'auto'
	});
	// 위시 버튼 로티(lottie)
	var aniWish = bodymovin.loadAnimation({
		container: document.querySelector('.renew .btn-wish'),
		loop: false,
		autoplay: false,
		path: 'https://assets4.lottiefiles.com/private_files/lf30_n9czk9v0.json'
	});
	var wishFlag = true;
	$('.renew .wish .btn-wish').on('click', function(e) {
		if ($(this).hasClass('active')) {
			aniWish.playSegments([18,30], true);
		} else {
			aniWish.playSegments([0,18], true);
		}
		$(this).toggleClass('active');
		if (wishFlag) {
			$('.renew .wish .txt2').addClass('on');
			wishFlag = false;
		}
	});
	// 스크롤 시 노출 인터랙션
	$(window).on('scroll', function() {
		$('.renew .section, .renew .section .con, .renew .intro, .renew .quick').each(function(i, el) {
			if ($(window).scrollTop() + $(window).height() * 0.5 > $(el).offset().top) {
				$(el).addClass('on');
			} else if($(window).scrollTop() + $(window).height() < $(el).offset().top) {
				$(el).removeClass('on');
			}
		});
	});
	
	// for dev msg : 박수 카운트
	var totalCnt = "<%=totalLikeCount%>"; // 초기 전체 박수 카운트
	var myCnt = "<%=myLikeCount%>";	// 초기 나의 박수 카운트
	<% If IsUserLoginOK Then %>
	$('.renew .clap .btn-clap').on('click', function(e) {
		var myCntEl = '<div class="my-cnt">' + myCnt + '</div>';
		var particleEl = '<div class="particle"><span></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span></div>';
		if (myCnt < 30) { // 30번째
			myCnt++;
			totalCnt++;
			$(this).find('.cnt').text(totalCnt);
			myCntEl = '<div class="my-cnt">'+myCnt+'</div>';
			if (myCnt === 30) {
				timeout = window.setTimeout(function() {
					$('.ly-clap').delay(100).fadeIn(100).delay(1800).fadeOut(100);
				}, 500);
			}
		}
		$(this).children(".my-cnt").remove();
		$(this).prepend(myCntEl);
		$(this).children(".particle").remove();
		$(this).append(particleEl);
	});
	<% end if %>
});
function eventTry(vselect){
	<% If Not(IsUserLoginOK) Then %>
        alert("투표에 참여하시려면 로그인이 필요해요!");
        <% if isApp="1" then %>
            calllogin();
        <% else %>
            jsChklogin_mobile('','<%=Server.URLencode("/event/renewal/renewal_1st.asp")%>');
        <% end if %>
		return false;
	<% else %>
		var returnCode, itemid, data
		var data={
			mode: "add",
            vote: vselect
		}
		$.ajax({
			type:"POST",
			url:"/event/renewal/dovote.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
					if(res!="") {
						if(res.response == "C"){
							$("#vote"+vselect).addClass('active');
                            getVoteInfo();
							return false;
						}else if(res.response == "B"){
							alert("투표는 한 번만 가능해요!");
							return false;
						}else{
							alert(res.faildesc);
							return false;
						}
					} else {
						alert("잘못된 접근 입니다.");
						document.location.reload();
						return false;
					}
			},
			error:function(err){
				console.log(err)
				alert("잘못된 접근 입니다.");
				return false;
			}
		});
	<% End If %>
}
function getVoteInfo(){
	$.ajax({
		type:"GET",
		url:"/event/renewal/dovote.asp",
		dataType: "JSON",
		data: 
		{
			mode: "votecnt"
		},
		success : function(res){		
			$("#votecnt1").html(res.votecnt1);
            $("#votecnt2").html(res.votecnt2);
            if(res.myvote==1){
                $('.vote').addClass('on');
                $("#vote1").addClass('active');
                $('.renew .bbl-search').fadeIn('slow');
				$("#vote1").attr("disabled",true);
            }else if(res.myvote==2){
                $('.vote').addClass('on');
                $("#vote2").addClass('active');
                $('.renew .bbl-category').fadeIn('slow');
				$("#vote2").attr("disabled",true);
            }
		},
		error:function(err){
			//console.log(err)
			alert("잘못된 접근 입니다.");
			return false;
		}
	});
}

var userAgent = navigator.userAgent.toLowerCase();
function fnGetAppVersion() {
	if(userAgent.match('iphone')) { //아이폰
		fnAPPpopupExternalBrowser('https://apps.apple.com/kr/app/텐바이텐- 디자인 쇼핑몰 10x10/id864817011');
	} else if(userAgent.match('ipad')) { //아이패드
		fnAPPpopupExternalBrowser('https://apps.apple.com/kr/app/텐바이텐- 디자인 쇼핑몰 10x10/id864817011');
	} else if(userAgent.match('ipod')) { //아이팟
		fnAPPpopupExternalBrowser('https://apps.apple.com/kr/app/텐바이텐- 디자인 쇼핑몰 10x10/id864817011');
	} else if(userAgent.match('android')) { //안드로이드 기기
		fnAPPpopupExternalBrowser('https://play.google.com/store/apps/details?id=kr.tenbyten.shopping');
	} else { //그 외
		fnAPPpopupExternalBrowser('https://play.google.com/store/apps/details?id=kr.tenbyten.shopping');
	}
}


function fnWebUpdate(){
    if(confirm("웹 브라우저에서는 업데이트하지 않아도 돼요!\n앱을 업데이트 하시겠어요?")){
        if(userAgent.match('iphone')) { //아이폰
            window.parent.top.document.location="https://apps.apple.com/kr/app/텐바이텐- 디자인 쇼핑몰 10x10/id864817011";
        } else if(userAgent.match('ipad')) { //아이패드
            window.parent.top.document.location="https://apps.apple.com/kr/app/텐바이텐- 디자인 쇼핑몰 10x10/id864817011";
        } else if(userAgent.match('ipod')) { //아이팟
            window.parent.top.document.location="https://apps.apple.com/kr/app/텐바이텐- 디자인 쇼핑몰 10x10/id864817011";
        } else if(userAgent.match('android')) { //안드로이드 기기
            window.parent.top.document.location= 'https://play.google.com/store/apps/details?id=kr.tenbyten.shopping';
        } else { //그 외
            window.parent.top.document.location= 'https://play.google.com/store/apps/details?id=kr.tenbyten.shopping';
        }
    }
}

function fnClapSet(){
	<% If Not(IsUserLoginOK) Then %>
        <% if isApp="1" then %>
            calllogin();
        <% else %>
            jsChklogin_mobile('','<%=Server.URLencode("/event/renewal/renewal_1st.asp")%>');
        <% end if %>
		return false;
	<% else %>
		$.ajax({
			type:"GET",
			url:"/event/renewal/setRenewalContentsLikeCountProc.asp",
			dataType: "JSON",
			data: 
			{
				cIdx: "<%=vCidx%>",
				device: "<%=Device%>",
				likeCount: "1"
			},
			success : function(res){
				return false;
			},
			error:function(err){
				//console.log(err)
				alert("잘못된 접근 입니다.");
				return false;
			}
		});
	<% End If %>
}

function fnMovePage(mUrl){
	location.href=mUrl;
}

function fnPreVerAlert(){
	if(confirm("아직 업데이트를 하지 않으셨어요.\n새로워진 기능을 만나보시겠어요?")){
        if(userAgent.match('iphone')) { //아이폰
            fnAPPpopupExternalBrowser('https://apps.apple.com/kr/app/텐바이텐- 디자인 쇼핑몰 10x10/id864817011');
        } else if(userAgent.match('ipad')) { //아이패드
            fnAPPpopupExternalBrowser('https://apps.apple.com/kr/app/텐바이텐- 디자인 쇼핑몰 10x10/id864817011');
        } else if(userAgent.match('ipod')) { //아이팟
            fnAPPpopupExternalBrowser('https://apps.apple.com/kr/app/텐바이텐- 디자인 쇼핑몰 10x10/id864817011');
        } else if(userAgent.match('android')) { //안드로이드 기기
            fnAPPpopupExternalBrowser('https://play.google.com/store/apps/details?id=kr.tenbyten.shopping');
        } else { //그 외
            fnAPPpopupExternalBrowser('https://play.google.com/store/apps/details?id=kr.tenbyten.shopping');
        }
	}
}
</script>
	<div id="content" class="content renew">
		<section class="topic">
			<h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/renew/bg_topic.gif?v=1.1" alt="텐바이텐 리뉴얼"></h2>
			<i class="deco"></i><i class="deco"></i><i class="deco"></i>
		</section>
		<section class="intro">
			<p class="txt">작고 사소한 물건이라도<br>더 멋지고, 더 예쁜 물건을 만나기 위해<br>텐바이텐을 찾은 텐텐이들!<br><br>그런 텐텐이들의 즐거운 쇼핑을 돕기 위한<br>첫 번째 리모델링이 완료되었어요.</p>
			<p class="txt">지금, 그 첫 번째 이야기를<br>들려드릴게요!</p>
			<figure class="area">
				<span class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/renew/img_intro_01.png" alt=""></span>
				<span class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/renew/img_intro_02.png" alt=""></span>
			</figure>
		</section>

		<!-- 투표 -->
		<section class="vote">
			<h3 class="headline">여러분은 상품을<br>어떻게 탐색하나요?</h3>
			<button class="bt bt-search" id="vote1" onclick="eventTry(1);">
				<span class="txt">키워드로 찾는다</span><em class="num" id="votecnt1"></em>
			</button>
			<button class="bt bt-category" id="vote2" onclick="eventTry(2);">
				<span class="txt">카테고리로 찾는다</span><em class="num" id="votecnt2"></em>
			</button>
			<div class="bbl bbl-search">
				<p class="txt">하나의 키워드로 빠르게<br>검색하는 것을 선호하시는군요!<br>그런 텐텐이라면 바로<br>아래 내용을 주목해주세요 :)</p>
			</div>
			<div class="bbl bbl-category">
				<p class="txt">카테고리를 선택해서 꼼꼼하게<br>찾는 것을 선호하시는군요!<br>그렇다면 리모델링 내용 중<br>카테고리 개선 부분을<br>주목해서 살펴봐 주세요 :)</p>
			</div>
		</section>
		<!-- //투표 -->

		<section class="section s1">
			<div class="tit">
				<span class="num">1</span>
				<p class="txt">당신의 검색을<br><em>더 빠르고 꼼꼼하게</em></p>
			</div>
			<div class="con a">
				<div class="txt1">이제 모든 것을<br>빠르게 검색할 수 있어요</div>
				<figure class="area">
					<span class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/renew/s1a_img1.png" alt=""></span>
					<span class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/renew/s1a_img2.png" alt=""></span>
				</figure>
				<div class="txt2">키워드 하나로 다양한 상품과 기획전, 이벤트,<br>브랜드, 그리고 텐텐이들의 생생한 이야기가 담긴<br>상품 후기까지 빠르게 만나보세요!</div>
			</div>
			<div class="con b">
				<div class="txt1">원하는 건 무엇이든<br>꼼꼼히 찾아줄게요</div>
				<figure class="area">
					<span class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/renew/s1b_img1.png" alt=""></span>
					<span class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/renew/s1b_img2.png" alt=""></span>
				</figure>
				<div class="txt2"><em>꼼꼼하게 찾기</em> 에서<br>원하는 조건을 골라보세요!</div>
			</div>
			<div class="con c">
				<div class="txt1">뭐 살지 고민될 땐,<br>남의 장바구니를 보고싶은 법</div>
				<figure class="area">
					<span class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/renew/s1c_img1.jpg" alt=""></span>
					<span class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/renew/s1c_img2.png?v=1.0" alt=""></span>
				</figure>
				<div class="txt2">상품 검색 결과 속에<br>숨어있는 버튼을 찾아보세요</div>
			</div>
		</section>

		<section class="section s2">
			<div class="tit">
				<span class="num">2</span>
				<p class="txt">더 쉽고 편리해진<br><em>카테고리 탐색</em></p>
			</div>
			<div class="con a">
				<div class="txt1">더이상 헤매지 마세요<br>한눈에 보여줄게요</div>
				<figure class="area">
					<span class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/renew/s2a_img1.png" alt=""></span>
					<span class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/renew/s2a_img2.png" alt=""></span>
					<span class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/renew/s2a_img3.png" alt=""></span>
				</figure>
				<div class="txt2">카테고리 간 이동이 더 쉬워졌어요!</div>
			</div>
			<div class="con b">
				<div class="txt1">탐색이 지칠 땐<br>추천을 받아보세요</div>
				<figure class="area">
					<span class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/renew/s2b_img1.png?v=1.1" alt=""></span>
					<span class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/renew/s2b_img2.png?v=1.0" alt=""></span>
				</figure>
				<div class="txt2">딱 맞는 상품들만 쏙쏙 골라주는 피키가<br>여러분의 선택을 도와줄 거예요</div>
			</div>
		</section>

		<section class="wish">
			<h3 class="headline">마음에 쏙 드는<br>상품을 만나면<br>언제 어디서나 위시해요</h3>
			<p class="txt1">♥ 하트를 눌러보세요!</p>
			<p><img src="//webimage.10x10.co.kr/fixevent/event/2021/renew/img_wish.png" alt=""></p>
			<button class="btn-wish"></button>
			<div class="txt2">이제 리스트에서도 바로 위시할 수 있어요!</div>
		</section>

		<section class="section s3">
			<div class="tit">
				<span class="num">3</span>
				<p class="txt">쇼핑몰이<br><em>이렇게 재밌다니</em></p>
			</div>
			<div class="con a">
				<div class="txt1">매일매일 새로운 이야기가<br>여러분을 기다려요</div>
				<div class="slider">
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<div class="swiper-slide"><span class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/renew/s3a_img1.png" alt=""></span></div>
							<div class="swiper-slide"><span class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/renew/s3a_img2.png" alt=""></span></div>
							<div class="swiper-slide"><span class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/renew/s3a_img3.png" alt=""></span></div>
							<div class="swiper-slide"><span class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/renew/s3a_img4.png" alt=""></span></div>
							<div class="swiper-slide"><span class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/renew/s3a_img5.png" alt=""></span></div>
						</div>
					</div>
				</div>
			</div>
			<div class="con b">
				<div class="txt1">잊고 있던 기쁜 소식도<br>함께 들려줄게요</div>
				<figure class="area">
					<span class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/renew/s3b_img1.png" alt=""></span>
					<span class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/renew/s3b_img2.png" alt=""></span>
				</figure>
				<div class="txt2">위시한 상품의 할인 소식과<br>좋아하는 브랜드의 신상품을 알려드려요!</div>
			</div>
			<div class="con c">
				<div class="txt1">이 곳에서<br>만날 수 있어요</div>
				<figure class="area">
					<span class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/renew/s3c_img1.png" alt=""></span>
					<span class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/renew/s3c_img2.png" alt=""></span>
					<span class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/renew/s3c_img3.png" alt=""></span>
				</figure>
			</div>
		</section>

		<!-- 업데이트 -->
		<!-- for dev msg : M/A, 앱 설치 여부/버전에 따른 처리 -->
		<section class="update">
			<p><img src="//webimage.10x10.co.kr/fixevent/event/2021/renew/bg_update.jpg" alt=""></p>
			<h3 class="headline">이제, 새로운 텐바이텐을<br>만나볼까요?</h3>
            <% if isApp="1" then %>
				<% if (InStr(ckAgent ,"tenapp i4.")>0) Or (InStr(ckAgent ,"tenapp a4.")>0) Then %>
					<button class="btn-update" onclick="alert('이미 업데이트 하셨어요!\n아래에서 리뉴얼 페이지를 만나보세요!');">업데이트 하러가기</button>
				<% else %>
					<button class="btn-update" onclick="fnGetAppVersion();">업데이트 하러가기</button>
				<% end if %>
            <% else %>
            <button class="btn-update" onclick="fnWebUpdate();">업데이트 하러가기</button>
            <% end if %>
		</section>
		<!-- //업데이트 -->

		<!-- 리뉴얼 링크 -->
		<!-- for dev msg : M/A, 앱 설치 여부/버전에 따른 처리 -->
		<section class="quick">
			<h3 class="headline">이미 업데이트 했다면<br><b>바로 만나보세요!</b></h3>
			<% if isApp="1" then %>
				<% if (InStr(ckAgent ,"tenapp i4.")>0) Or (InStr(ckAgent ,"tenapp a4.")>0) Then %>
					<button class="bt bt-search" onclick="fnAPPpopupInit();return false;">키워드로 탐색하고 싶다면<b>검색하러 가기</b></button>
					<button class="bt bt-category" onclick="fnAPPpopupCategory('101','ne');return false;">분류별로 탐색하고 싶다면<b>카테고리 구경하기</b></button>
					<div class="btn-group">
						<button class="bt" onclick="fnAPPpopupBrowserRenewal('push', 'BEST', '<%=wwwUrl%>/apps/appcom/wish/web2014/list/best/best_summary2020.asp');return false;">텐텐 베스트</button>
						<button class="bt" onclick="fnAPPpopupBrowserRenewal('push', 'NEW', '<%=wwwUrl%>/apps/appcom/wish/web2014/list/new/new_summary2020.asp');return false;">따끈한 신상</button>
						<button class="bt" onclick="fnAPPpopupBrowserRenewal('push', 'SALE', '<%=wwwUrl%>/apps/appcom/wish/web2014/list/sale/sale_summary2020.asp');return false;">할인 소식</button>
						<button class="bt" onclick="fnAPPpopupBrowserRenewal('push', 'CLEARANCE', '<%=wwwUrl%>/apps/appcom/wish/web2014/list/mdpick/mdpick_summary2020.asp');return false;">MD의 선택</button>
						<button class="bt" onclick="fnAPPpopupBrowserRenewal('push', 'CLEARANCE', '<%=wwwUrl%>/apps/appcom/wish/web2014/list/clearance/clearance_summary2020.asp');return false;">심봤다!</button>
					</div>
				<% Else %>
					<button class="bt bt-search" onclick="fnPreVerAlert();">키워드로 탐색하고 싶다면<b>검색하러 가기</b></button>
					<button class="bt bt-category" onclick="fnPreVerAlert();">분류별로 탐색하고 싶다면<b>카테고리 구경하기</b></button>
					<div class="btn-group">
						<button class="bt" onclick="fnPreVerAlert();">텐텐 베스트</button>
						<button class="bt" onclick="fnPreVerAlert();">따끈한 신상</button>
						<button class="bt" onclick="fnPreVerAlert();">할인 소식</button>
						<button class="bt" onclick="fnPreVerAlert();">MD의 선택</button>
						<button class="bt" onclick="fnPreVerAlert();">심봤다!</button>
					</div>
				<% end if %>
			<% else %>
				<button class="bt bt-search" onclick="fnMovePage('/search/search_entry2020.asp');">키워드로 탐색하고 싶다면<b>검색하러 가기</b></button>
				<button class="bt bt-category" onclick="fnMovePage('/category/category_main2020.asp?disp=101');">분류별로 탐색하고 싶다면<b>카테고리 구경하기</b></button>
				<div class="btn-group">
					<button class="bt" onclick="fnMovePage('/list/best/best_summary2020.asp');">텐텐 베스트</button>
					<button class="bt" onclick="fnMovePage('/list/new/new_summary2020.asp');">따끈한 신상</button>
					<button class="bt" onclick="fnMovePage('/list/sale/sale_summary2020.asp');">할인 소식</button>
					<button class="bt" onclick="fnMovePage('/list/mdpick/md_summary2020.asp');">MD의 선택</button>
					<button class="bt" onclick="fnMovePage('/list/clearance/clearance_summary2020.asp');">심봤다!</button>
				</div>
			<% end if %>
		</section>
		<!-- //리뉴얼 링크 -->

		<!-- 박수 -->
		<section class="clap">
			<p class="txt1">좀 더 새로워진 텐바이텐,<br>잘 만나보셨나요?<br><br>앞으로도 텐바이텐은<br>텐텐이들의 즐거운 쇼핑을 돕기 위해<br>더 편리하고 재미난 공간을 만들어 나갈게요.<br><br>여러분의 따뜻한 관심과 응원을 보내주세요 :)</p>
			<button class="btn-clap" onclick="fnClapSet()">
				<span class="ico"></span><em class="cnt"><%=totalLikeCount%></em>
			</button>
			<p class="txt2">응원해요!</p>
			<div class="ly-clap"><div class="inner"></div></div>
		</section>
		<!-- //박수 -->
	</div>
<script>
	// for dev msg : 박수 카운트

	$('.renew .clap .btn-clap').on('click', function(e) {

	});
</script>

<!-- #include virtual="/lib/db/dbclose.asp" -->