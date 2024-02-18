<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/realtimeevent/RealtimeEventCls.asp" -->
<%
'################################################################
' Description : [텐바이텐X오리온 마이구미JAM] 매일 매일 쫄깃 쫄KIT
' History : 2020-10-26 정태훈
'################################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent
dim mktTest, itemsearch

mktTest = False

IF application("Svr_Info") = "Dev" THEN
	eCode = "103248"
	moECode = "103238"
Else
	eCode = "106538"
	moECode = "105097"
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)
itemsearch = requestCheckVar(request("itemsearch"),1)

If isapp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2020-11-04")		'이벤트 시작일
eventEndDate 	= cdate("2020-11-17")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" or LoginUserid = "starsun726" or LoginUserid = "bora2116" then
	mktTest = True
end if

if mktTest then
    currentDate = cdate("2020-11-04")
else
    currentDate 	= date()
end if

dim isFirstTried
dim triedNum : triedNum = 0

if LoginUserid <> "" then
	set pwdEvent = new RealtimeEventCls
	pwdEvent.evtCode = eCode
	pwdEvent.userid = LoginUserid
	isFirstTried = pwdEvent.isParticipationDayBase(1)
end if

triedNum = chkIIF(isFirstTried, 1, 0)

%>
<style>
.bnr-anniv18 {display:none;}
.mEvt106538 {position:relative; overflow:hidden; background:#fff;}
.mEvt106538 .topic {position:relative; background:#761b86;}
.mEvt106538 .topic h2 {width:14.26rem; padding-top:2.87rem; margin:0 auto; opacity:0; transform:translateY(5%); transition:all 1s; transition-delay:.5s;}
.mEvt106538 .topic h2.on {opacity:1; transform:translateY(0);}
.mEvt106538 .topic .tit-sub01 {width:26.91rem; padding-top:1.52rem; margin:0 auto; opacity:0; transform:translateY(5%); transition:all 1s; transition-delay:1s;}
.mEvt106538 .topic .tit-sub01.on {opacity:1; transform:translateY(0);}
.mEvt106538 .topic .tit-sub02 {width:24.61rem; padding-top:2.39rem; padding-bottom:4.56rem; margin:0 auto;}
.mEvt106538 .topic .item-01 {position:relative; width:27.7rem; padding-top:1.04rem; margin:0 auto;}
.mEvt106538 .topic .item-01 span {position:absolute; right:0; top:0; display:inline-block; width:9.52rem; margin:0 auto; animation:.6s updown ease-in-out infinite alternate;}
.mEvt106538 .section-01 {position:relative;}
.mEvt106538 .section-01 button {width:16.26rem; position:absolute; left:50%; top:62%; transform:translate(-50%,0);}
.mEvt106538 .section-02 {padding:0 2rem 4.26rem; background:#ffd3ab; text-align:center;}
.mEvt106538 .section-02 h3 {width:13.7rem; margin:0 auto; padding-top:4.52rem;}
.mEvt106538 .section-02 .slide-area {padding-top:1.91rem;}
.mEvt106538 .section-02 button.btn-hint {width:24.04rem; margin:2.87rem 0 1.21rem; background:#ffd3ab;}
.mEvt106538 .section-02 button.btn-try {width:24.04rem; background:#ffd3ab;}
.mEvt106538 .section-02 button.btn-try.active {animation:shake 2s 1s 10;}
@keyframes shake {
	0%,40% {-webkit-transform:translate3d(0,0,0); transform:translate3d(0,0,0)}
	5%,15%,25%,35% {-webkit-transform:translate3d(-.5em,0,0);transform:translate3d(-.5em,0,0)}
	10%,20%,30% {-webkit-transform:translate3d(.5em,0,0);transform:translate3d(.5em,0,0)}
}
.mEvt106538 .section-02 .pagination {height:auto; padding-top:1.21rem; line-height:inherit;}
.mEvt106538 .section-02 .pagination .swiper-pagination-switch {width:0.78rem; height:0.78rem; margin:0 0.52rem; background:#fff;}
.mEvt106538 .section-02 .pagination .swiper-pagination-switch.swiper-active-switch {background:#8d2e9e;}
.mEvt106538 .section-03 {padding-top:4.52rem; background:#fff;}
.mEvt106538 .section-03 h3 {width:21.43rem; margin:0 auto;}
.mEvt106538 .section-03 .item-01 .inner {width:31rem; padding-top:4.39rem; float:right;}
.mEvt106538 .section-03 .item-01:after {content:""; display:block; clear:both;}
.mEvt106538 .section-03 .item-02 {padding-top:7.82rem;}
.mEvt106538 .section-03 .item-03 .inner {width:25.09rem; padding:1.21rem 1.87rem 0 0; float:right;}
.mEvt106538 .section-03 .item-03:after {content:""; display:block; clear:both;}
.mEvt106538 .section-03 .item-04 .inner {width:30.87rem; padding-top:7.82rem; float:left;}
.mEvt106538 .section-03 .item-04:after {content:""; display:block; clear:both;}
.mEvt106538 .section-03 .item-05 {padding-top:7.82rem;}
.mEvt106538 .section-03 .inner {opacity:0;}
.mEvt106538 .section-04 {padding-top:5.21rem;}
@keyframes updown {
	0% {transform:translateY(5%);}
	100% {transform:translateY(-3%);}
}
.pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(118,27,134,0.949); z-index:150;}
.pop-container .pop-inner {position:relative; width:100%; height:100%; overflow-y:scroll;}
.pop-container .pop-inner .btn-close {position:absolute; right:1.73rem; top:1.73rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/106538/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;} 
.pop-container .pop-inner.fail,
.pop-container .pop-inner.hint {padding-top:5.30rem; text-align:center;}
.pop-container .pop-inner.win {padding-top:1.43rem; text-align:center;}
.pop-container .pop-inner.fail img {width:21.48rem;}
.pop-container .pop-inner.hint img {width:27.83rem;}
.pop-container .pop-inner.win img {width:30.7rem;}
.pop-container .pop-inner.hint .btn-find,
.pop-container .pop-inner.win .btn-find {display:inline-block; padding-top:2.47rem;}
.pop-container .pop-inner.hint .btn-find img,
.pop-container .pop-inner.win .btn-find img {width:24.04rem;}
.pop-container .pop-inner.fail .btn-close,
.pop-container .pop-inner.hint .btn-close,
.pop-container .pop-inner.win .btn-close {position:absolute; right:1.73rem; top:1.73rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/106538/m/icon_close02.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;} 
</style>
<script>
var numOfTry = "<%=triedNum%>";
$(function(){
	// slide
	var swiper = new Swiper('.mEvt106538 .swiper-container', {
		loop:true,
		autoplay:1000,
		speed:900,
		pagination:".pagination",
		paginationClickable:true,
		effect:'fade'
	});
	// 상단 title 슥슥 올라오기
	$('.mEvt106538 .topic h2').addClass('on');
	$('.mEvt106538 .topic .tit-sub01').addClass('on');
	// scroll event
	$(window).scroll( function(){
		$('.inner').each( function(i){
				var bottom_of_object = $(this).offset().top + $(this).outerHeight();
				var bottom_of_window = $(window).scrollTop() + $(window).height();
				if( bottom_of_window > bottom_of_object){
						$(this).animate({'opacity':'1'},500);
				}
		}); 
	});
	// 마이구미 소개 팝업 호출
	$(".mEvt106538 .btn-more").on("click", function(){
		$(".pop-container.more").fadeIn();
	});
	// 힌트 팝업 호출
	$(".mEvt106538 .btn-hint").on("click", function(){
		$(".pop-container.hint").fadeIn();
	});
	// 응모 결과 팝업 호출
	$(".mEvt106538 .btn-try").on("click", function(){
		
	});
	// 팝업 닫기
	$(".mEvt106538 .btn-close").on("click", function(){
		$(".pop-container").fadeOut();
	});
	// for dev msg : 상품 찾고 돌아온 경우 스크롤 이동
	if ($('.btn-try').hasClass('active')) {
		var target = $('.section-02').offset().top + $('.section-02').outerHeight() / 2;
		$('html,body').animate({ scrollTop : target });
	}
});

function eventTry(s){
	<% If Not(IsUserLoginOK) Then %>
		calllogin();
		return false;
	<% else %>
		<% If (currentDate >= eventStartDate And currentDate <= eventEndDate) or mktTest Then %>
		if(numOfTry == '1'){
			// 한번 시도
			alert("이미 1회 응모하였습니다");
			return false;
		}
		var returnCode, itemid, data
		var data={
			mode: "add",
			selectedPdt: s
		}
		$.ajax({
			type:"POST",
			url:"/event/etc/realtimeevent/realtimeEvent106538Proc.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
				fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|option1','<%=eCode%>|' + s)
					if(res!="") {
						// console.log(res)
						if(res.response == "ok"){
							popResult(res.returnCode, res.winItemid, res.selectedPdt);
							return false;
						}else{
							alert(res.faildesc);
							return false;
						}
					} else {
						alert("잘못된 접근 입니다1.");
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
		<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% End If %>
	<% End If %>
}

function popResult(returnCode, itemid, selectedPdt){
	numOfTry++
	if(returnCode[0] == "B"){		
		$('#fail').eq(0).delay(500).fadeIn();
		return false;
	}else if(returnCode[0] == "C"){
        $("#itemid").val(itemid);
		$("#winnerPopup").eq(0).delay(500).fadeIn();
	}else if(returnCode == "A02"){
		numOfTry = 2
		$('#resultover').eq(0).delay(500).fadeIn();
	}else if(returnCode == "A03"){
		alert("오픈된 상품이 아닙니다.");
	}
}

function goDirOrdItem(){
<% If IsUserLoginOK() Then %>
	<% If (currentDate >= eventStartDate And currentDate <= eventEndDate) or mktTest Then %>		
		document.directOrd.submit();
	<% else %>
		alert("이벤트 응모 기간이 아닙니다.");
		return;
	<% end if %>
<% End IF %>
}
</script>
<%
if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" or LoginUserid = "starsun726" then
	dim vQuery 
	vQuery = "select convert(varchar(10),regdate,120), count(userid) from [db_event].[dbo].[tbl_event_subscript]" & vbCrLf
	vQuery = vQuery & "  where evt_code=" & eCode & vbCrLf
	vQuery = vQuery & "  and sub_opt1='1'" & vbCrLf
	vQuery = vQuery & "  group by convert(varchar(10),regdate,120)"
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		Do Until rsget.EOF
			response.write rsget(0) & " : " & rsget(1) & "<br>"
			rsget.MoveNext
		loop
	End IF
	rsget.close
end if
%>
			<div class="mEvt106538">
				<div class="topic">
					<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/106538/m/img_tit01.png" alt="tenbyten x 마이구미"></h2>
					<p class="tit-sub01"><img src="//webimage.10x10.co.kr/fixevent/event/2020/106538/m/img_tit02.png" alt="매일 매일 쫄깃 쫄kit!"></p>
					<div class="item-01">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/106538/m/img_item01.png" alt="마이구미">
						<span class="num"><img src="//webimage.10x10.co.kr/fixevent/event/2020/106538/m/img_item02.png" alt="당첨자 500명"></span>
					</div>
					<p class="tit-sub02"><img src="//webimage.10x10.co.kr/fixevent/event/2020/106538/m/img_sub_txt01.png" alt="우리의 집콕 일상이 좀 더 쫄깃해지도록 텐바이텐과 오리온이 ‘쫄깃 쫄KIT’을 만들었어요! 지금 텐바이텐에서 ‘쫄깃 쫄KIT’을 찾고 행운의 주인공이 되어보세요!* 배송비 별도"></p>
				</div>
				<div class="section-01">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/106538/m/img_section02.jpg" alt="마이구미 한정판 쫄깃 쫄kit 구성">
					<button type="button" class="btn-more"><img src="//webimage.10x10.co.kr/fixevent/event/2020/106538/m/img_btn03.png" alt="마이구미 jam 더 알아보기"></button>
				</div>
				<div class="section-02" id="try">
					<h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/106538/m/img_tit03.png" alt="02 이벤트 응모 방법"></h3>
					<div class="slide-area">
						<div class="swiper-container">
							<div class="swiper-wrapper">
								<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/106538/m/img_slide01.png" alt="slide image01"></div>
								<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/106538/m/img_slide02.png" alt="slide image02"></div>
								<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/106538/m/img_slide03.png" alt="slide image03"></div>
								<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/106538/m/img_slide04.png" alt="slide image04"></div>
							</div>
							<!-- Add Pagination -->
							<div class="pagination"></div>
						</div>
					</div>
					<button type="button" class="btn-hint"><img src="//webimage.10x10.co.kr/fixevent/event/2020/106538/m/img_btn01.png" alt="쫄깃 쫄kit 찾으로 가기"></button>
					<button type="button" class="btn-try<% if itemsearch="Y" then %> active<% end if %>" onClick="eventTry(1);"><img src="//webimage.10x10.co.kr/fixevent/event/2020/106538/m/img_btn02.png" alt="응모하기"></button>
				</div>
				<div class="section-03">
					<h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/106538/m/img_tit04.png" alt="한정판 쫄깃 쫄kit 활용법"></h3>
					<div class="item-01">
						<div class="inner"> 
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/106538/m/img_sub_txt02.png" alt="집콕하면서 영화볼때 팝콘 대시 마이구매 잼과 대왕 마이구미 잼 쿠션과 함께 영화 즐기기"></div>
						</div>
					<div class="item-02"><img src="//webimage.10x10.co.kr/fixevent/event/2020/106538/m/img_item.gif" alt="마이구미 쿠션"></div>
					<div class="item-03">
						<div class="inner">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/106538/m/img_sub_txt03.png" alt="스트레스 받을 때 스트레스 받는 일이 있다면 대왕 마우구미 잼 쿠션 으로 스트레스 해소"></div>
						</div>
					<div class="item-04">
						<div class="inner">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/106538/m/img_sub_txt04.png" alt="달달한 낮잠이 필요할 땐 대왕 마이구미 잼 쿠션과 함께!"></div>
						</div>
					<div class="item-05">
						<div class="inner">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/106538/m/img_sub_txt05.png" alt="인싸가 되고 싶을 때 sns에 '쫄깃 쫄kit' 인증하고 친구들과 함께 나눠 먹어보세요!"></div>
						</div>
				</div>
				<div class="section-04">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/106538/m/img_notice.png" alt="유의사항">
				</div>
				<!-- 마이구미 소개 팝업 -->
				<div class="pop-container more">
					<div class="pop-inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/106538/m/img_pop_intro.png" alt="100% 과즙 상큼폭탄 마이구매 jam">
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<!-- for dev msg : 힌트 팝업 -->
				<div class="pop-container hint">
					<div class="pop-inner hint">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/106538/m/img_pop_hint.png" alt="쫄깃 쫄kit 위치 힌트 home>디자인문구>데코레이션>스티커">
						<button type="button" class="btn-close">닫기</button>
						<a href="#" onclick="fnAPPpopupCategory('101107102','ne');return false;" class="btn-find"><img src="//webimage.10x10.co.kr/fixevent/event/2020/106538/m/img_btn04.png" alt="찾으러 가기"></a>
					</div>
				</div>
				<!-- for dev msg : 꽝 팝업 -->
				<div class="pop-container fail" id="fail">
					<div class="pop-inner fail">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/106538/m/img_pop_fail.png" alt="아쉽게동 꽝! 내일 또 응모해주세요! 꿀팁! 이벤트 종료 후, 이벤트 미당첨자 중 추첨을 통해 50명에게 마이구미잼 8개를 드려요!">
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<!-- for dev msg : 당첨 팝업 -->
				<div class="pop-container win" id="winnerPopup">
					<div class="pop-inner win">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/106538/m/img_pop_in.png" alt="축하드립니다! 배송비만 내고 한정판 쫄깃 쫄kit 받아가세요!">
						<button type="button" class="btn-close">닫기</button>
						<!-- for dev msg : 구매하러 가기 링크 -->
						<a href="#" class="btn-find" onclick="goDirOrdItem();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/106538/m/img_btn05.png" alt="쫄깃 쫄kit 구매하기"></a>
					</div>
				</div>
			</div>

<% If IsUserLoginOK() Then %>
    <form method="post" name="directOrd" action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp">
        <input type="hidden" name="itemid" id="itemid" value="">
        <input type="hidden" name="itemoption" value="0000">
        <input type="hidden" name="itemea" readonly value="1">
        <input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
        <input type="hidden" name="isPresentItem" value="" />
        <input type="hidden" name="mode" value="DO3">
    </form>
<% end if %>
<!-- #include virtual="/lib/db/dbclose.asp" -->