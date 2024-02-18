<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 핑크다꾸의 모든것
' History : 2019-07-09 최종원
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, couponIdx
IF application("Svr_Info") = "Dev" THEN
	eCode = "90321"
	couponIdx = "2903"     
Else
	eCode = "95779"
	couponIdx = "1169"
End If

userid = GetEncLoginUserID()

dim eventEndDate, currentDate, eventStartDate
dim subscriptcount, totalsubscriptcount 
dim evtinfo : evtinfo = getEventDate(eCode)

if not isArray(evtinfo) then
	Call Alert_Return("잘못된 이벤트번호입니다.")
	dbget.close()	:	response.End
end if

'변수 초기화
eventStartDate = cdate(evtinfo(0,0))
eventEndDate = cdate(evtinfo(1,0))
currentDate = date()
'currentDate = Cdate("2019-05-04")
eventStartDate = cdate("2019-05-10")
%>
<style type="text/css">
.diaryVod .serise {position:relative; height:4rem;}
.diaryVod .serise iframe {position:absolute; top:0; left:0; right:0; width:100%; height:5.5rem;}
.diaryVod .vod-story {position:relative; background-color:#ffa3bb;}
.diaryVod .vod-story .vod {position:absolute; left:50%; width:86%; margin-left:-43%;}
.diaryVod .vod-story .vod-01 {top:0;}
.diaryVod .vod-story div.inner {position:relative; padding-bottom:61.54%; background:#000;}
.diaryVod .vod-story div.inner iframe {position:absolute; left:0; width:100%; height:100%;}
.diaryVod .swiper {position:relative;}
.diaryVod .pagination {position:absolute; left:0; bottom:1.6rem; z-index:50; width:100%; height:auto; padding-top:0; text-align:center;}
.diaryVod .pagination span {display:inline-block; width:10px; height:10px; margin:0 0.6rem; border:0.18rem solid #fff; border-radius:50%; cursor:pointer; background-color:rgba(0,0,0,.1); box-shadow:0 0 0.4rem 0 rgba(0,0,0,.25);}
.diaryVod .pagination span.swiper-active-switch {width:2rem; margin:0 0.3rem; border-radius:0.4rem; background-color:#fff;}
.diaryVod .slideNav {display:inline-block; position:absolute; top:25%; z-index:50; width:9.4%; height:50%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50%; background-size:66% auto; text-indent:-999em;}
.diaryVod .btnPrev {left:0; background-image:url(http://fiximage.10x10.co.kr/m/2015/event/btn_slide_prev.png);}
.diaryVod .btnNext {right:0; background-image:url(http://fiximage.10x10.co.kr/m/2015/event/btn_slide_next.png);}
</style>
<script type="text/javascript">
$(function(){
	// slide template
	slideTemplate = new Swiper('.diaryVod .swiper-container',{
		loop:true,
		autoplay:3000,
		autoplayDisableOnInteraction:false,
		speed:800,
		pagination:".diaryVod .pagination",
		paginationClickable:true,
		nextButton:'.diaryVod .btnNext',
		prevButton:'.diaryVod .btnPrev'
	});
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			slideTemplate.reInit();
				clearInterval(oTm);
		}, 500);
	});
});
</script>
<script>
function cstJsDownCoupon(stype,idx){		
	<% if Not(IsUserLoginOK) then %>
		jsEventLogin();
	<% else %>
	$.ajax({
		type: "post",
		url: "/shoppingtoday/act_couponshop_process.asp",
		data: "idx="+idx+"&stype="+stype,
		cache: false,
		success: function(message) {
			if(typeof(message)=="object") {
				if(message.response == "Ok"){
					alert("쿠폰이 발급되었습니다.\n마이텐바이텐에서 쿠폰을 확인해주세요!")
				}else{
					alert(message.message)
				}
			} else {
				alert("처리중 오류가 발생했습니다.");
			}
		},
		error: function(err) {
			console.log(err.responseText);
		}
	});
	<% end if %>
}

function jsEventLogin(){
<% if isApp="1" then %>
	calllogin();
<% else %>
	jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=?" & eCode)%>');
<% end if %>
	return;
}
</script>
</head>
<body> 
			<!-- 다이어리 스토리 -->
			<div class="mEvt95779 diaryVod">
				<a href="/diarystory2019/" class="mWeb"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/89423/m/bnr_diarystory.png" alt="2019 DIARY STORY" /></a>
				<a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '다이어리스토리', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2019/');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/89423/m/bnr_diarystory.png" alt="2019 DIARY STORY" /></a>
				<div class="serise">
					<iframe id="iframe_diaryvod" src="/event/etc/group/iframe_diaryvod.asp?eventid=95779" frameborder="0" scrolling="no" title="다꾸 채널"></iframe>
				</div>
                <h2><img src="http://webimage.10x10.co.kr/fixevent/event/2019/95779/m/tit_diary_vod.jpg" alt="텐플루언서 밥팅’s 핑크 다꾸의 모든 것!" /></h2>
                <div>
                    <a href="/tenfluencer/" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95779/m/btn_tenfluencer.jpg" alt="텐바이텐만의 인플루언서로 유튜버와 인스타그래머로 구성되어 있습니다."></a>
                    <a href="" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '텐플루언서', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/tenfluencer/');return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95779/m/btn_tenfluencer.jpg" alt="텐바이텐만의 인플루언서로 유튜버와 인스타그래머로 구성되어 있습니다."></a>
                </div>
				<div class="vod-story">
					<p><img src="http://webimage.10x10.co.kr/fixevent/event/2019/95779/m/bg_vod.jpg" alt="" /></p>
					<div class="vod vod-01">
						<div class="inner"><iframe src="https://www.youtube.com/embed/kfZQuV7Q2MI" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe></div>
					</div>
                </div>
                <!-- 쿠폰 -->
                
				<% if date() <= Cdate("2019-07-23") then %>
                <a href="javascript:cstJsDownCoupon('event','<%=couponIdx%>')"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/95779/m/bnr_coupon.jpg" alt="영상을 본 분들께 드리는 밥팅쿠폰!" /></a>
				<% end if %>
				<p><img src="http://webimage.10x10.co.kr/fixevent/event/2019/95779/m/tit_artist.jpg" alt="유튜버 소개 밥팅" /></p>
				<div class="swiper">
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=2268480&pEtr=95779" onclick="TnGotoProduct('2268480');return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/95779/m/img_slide_1.jpg" alt="루카랩 A5 하드 육공 모눈 노트" /></a></div>
							<div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=2111471&pEtr=95779" onclick="TnGotoProduct('2111471');return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/95779/m/img_slide_2.jpg" alt="텐텐문방구 A5 컬러 Half 리필속지" /></a></div>
							<div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=2381233&pEtr=95779" onclick="TnGotoProduct('2381233');return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/95779/m/img_slide_3.jpg" alt="스탠다드러브댄스 메모패드_핑크가든" /></a></div>
							<div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=2014296&pEtr=95779" onclick="TnGotoProduct('2014296');return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/95779/m/img_slide_4.jpg" alt="비온뒤 마스킹테이프" /></a></div>
							<div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=2369958&pEtr=95779" onclick="TnGotoProduct('2369958');return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/95779/m/img_slide_5.jpg" alt="메종드알로하 Check Heart Sticker" /></a></div>
                       </div>
						<div class="pagination"></div>
						<button type="button" class="slideNav btnPrev">이전</button>
						<button type="button" class="slideNav btnNext">다음</button>
					</div>
				</div>
                <p><img src="http://webimage.10x10.co.kr/fixevent/event/2019/95779/m/txt_noti.jpg?v=1.01" alt="해당 이벤트 내 밥팅 쿠폰’은  3만 원 구매 시, 2,000원 할인 쿠폰이며, 2019년 7월 23일까지 사용 가능합니다. 이벤트는 내부 사정으로 인하여 조기 종료될 수 있습니다." /></p>
			</div>
			<!-- 다이어리 스토리 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->