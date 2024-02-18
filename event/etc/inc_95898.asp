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
	eCode = "95898"
	couponIdx = "1174"
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
.diaryVod .vod-story {padding-bottom:9.47%; background-color:#ffe94c;}
.diaryVod .vod-story .vod {width:86.67%; margin:0 auto;}
.diaryVod .vod-story .inner {position:relative; padding-bottom:61.54%; background:#000;}
.diaryVod .vod-story .inner iframe {position:absolute; top:0; left:0; width:100%; height:100%;}
.diaryVod .swiper {position:relative;}
.diaryVod .pagination {position:absolute; left:0; bottom:1.6rem; z-index:50; width:100%; height:auto; padding-top:0; text-align:center;}
.diaryVod .pagination span {display:inline-block; width:10px; height:10px; margin:0 0.6rem; border:0.18rem solid #fff; border-radius:50%; cursor:pointer; background-color:rgba(0,0,0,.1); box-shadow:0 0 0.4rem 0 rgba(0,0,0,.25);}
.diaryVod .pagination span.swiper-active-switch {width:2rem; margin:0 0.3rem; border-radius:0.4rem; background-color:#fff;}
.diaryVod .slideNav {display:inline-block; position:absolute; top:25%; z-index:50; width:9.4%; height:50%; background-color:transparent; background-repeat:no-repeat; background-position:50% 50%; background-size:66% auto; text-indent:-999em;}
.diaryVod .btnPrev {left:0; background-image:url(//fiximage.10x10.co.kr/m/2015/event/btn_slide_prev.png);}
.diaryVod .btnNext {right:0; background-image:url(//fiximage.10x10.co.kr/m/2015/event/btn_slide_next.png);}
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
	<div class="diaryVod mEvt95898">
		<a href="/diarystory2019/" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2018/89423/m/bnr_diarystory.png" alt="2019 DIARY STORY"></a>
		<a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '다이어리스토리', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2019/');return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2018/89423/m/bnr_diarystory.png" alt="2019 DIARY STORY"></a>
		<div class="serise">
			<iframe id="iframe_diaryvod" src="/event/etc/group/iframe_diaryvod.asp?eventid=95898" frameborder="0" scrolling="no" title="다꾸 채널"></iframe>
		</div>
		<h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/95898/m/tit_daccu.jpg" alt="텐플루언서 보쨘's 상큼달큼 다꾸의 정석!"></h2>
		<div class="vod-story">
			<a href="/tenfluencer/" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95898/m/btn_tenfluencer.jpg" alt="더 많은 텐플루언서 보러가기"></a>
			<a href="" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '텐플루언서', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/tenfluencer/');return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95898/m/btn_tenfluencer.jpg" alt="더 많은 텐플루언서 보러가기"></a>
			<div class="vod">
				<div class="inner"><iframe src="https://www.youtube.com/embed/82b8INw5RZw" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe></div>
			</div>
		</div>
		<!-- 쿠폰 -->
		<%'<!-- for dev msg : 플로팅 배너 클릭시 쿠폰 1174 지급'마이텐바이텐에서 쿠폰을 확인해주세요!' 얼럿2019-07-24 (수) 00:00:00 ~ 2019-08-06 (화) 23:59:59 동안만 노출 -->%>
		<% if date() <= Cdate("2019-08-20") then %>
		<a href="javascript:cstJsDownCoupon('event','<%=couponIdx%>')"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95898/m/bnr_coupon.jpg" alt="보쨘 쿠폰"></a>
		<% end if %>
		<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/95898/m/txt_artist.jpg" alt="유튜버 보쨘"></p>
		<div class="swiper">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=2312151&pEtr=95898" onclick="TnGotoProduct('2312151');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95898/m/img_item_1.jpg" alt="JUJUBE O-ssum for deco 8종"></a></div>
					<div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=2125874&pEtr=95898" onclick="TnGotoProduct('2125874');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95898/m/img_item_2.jpg" alt="LEEGONG 사각사각 메모지"></a></div>
					<div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=2369957&pEtr=95898" onclick="TnGotoProduct('2369957');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95898/m/img_item_3.jpg" alt="메종드알로하 Big Heart Sticker"></a></div>
					<div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=2268759&pEtr=95898" onclick="TnGotoProduct('2268759');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95898/m/img_item_4.jpg" alt="데일리라이크 리무버 스티커"></a></div>
					<div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=2240911&pEtr=95898" onclick="TnGotoProduct('2240911');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95898/m/img_item_5.jpg" alt="루카랩 A5 육공 리필 속지 타일 노트"></a></div>
				</div>
				<div class="pagination"></div>
				<button type="button" class="slideNav btnPrev">이전</button>
				<button type="button" class="slideNav btnNext">다음</button>
			</div>
		</div>
		<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/95898/m/txt_noti.jpg" alt="유의사항"></p>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->