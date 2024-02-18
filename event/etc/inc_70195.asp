<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 텐바이텐 X 영화 <캡틴 아메리카: 시빌 워>  MA
' History : 2016.04.20 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, currenttime, subscriptcount, tcapcnt, tironcnt, totalcnt
	IF application("Svr_Info") = "Dev" THEN
		eCode = "66112"
	Else
		eCode = "70195"
	end if

currenttime = now()
'															currenttime = #03/14/2016 10:05:00#

userid = GetEncLoginUserID()

subscriptcount=0
'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", left(currenttime,10))
end if

totalcnt = getevent_subscripttotalcount(eCode, "", "", "")
tcapcnt = getevent_subscripttotalcount(eCode, "1", "", "")
tironcnt = getevent_subscripttotalcount(eCode, "2", "", "")

dim tcapgraph, tirongraph, tcapNum, tironpNum, tcapdonationCost, tirondonationCost

tcapgraph = 0
tirongraph = 0
IF tcapcnt="" then tcapcnt=0
IF tironcnt="" then tironcnt=0
IF isNull(totalcnt) then totalcnt=0

if totalcnt = 0 then totalcnt = 1

tcapgraph = Int( tcapcnt / totalcnt * 100  )	'게이지바 % 계산
tirongraph = Int( tironcnt / totalcnt * 100  )	'게이지바 % 계산

if tcapgraph > 100 then tcapgraph = 100
if tirongraph > 100 then tirongraph = 100
	
'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg

dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle = Server.URLEncode("[텐바이텐] 캡틴 아메리카: 시빌 워")
snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode)
snpPre = Server.URLEncode("10x10 이벤트")

'기본 태그
snpTag = Server.URLEncode("텐바이텐")
snpTag2 = Server.URLEncode("#10x10")

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "영화 <캡틴 아메리카: 시빌 워>\n텐바이텐에서 미리 만나자!\n\n원하는 히어로에 투표해주세요.\n영화 예매권부터 오리지널 경품까지 놀라운 선물의 기회가 가득!\n\n지금 바로 확인해보세요.\n오직, 텐바이텐에서!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/70195/m/img_kakao.jpg"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url
	If isapp = "1" Then '앱일경우
		kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
	Else '앱이 아닐경우
		kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
	end if

%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

img {vertical-align:top;}
.selectTeam {position:relative;}
.selectTeam button {display:block; position:absolute; top:0; width:29%; background-repeat:no-repeat; background-position:0 0; background-size:200% 100%; color:transparent;}
.selectTeam .btnCaptain {left:9%; background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/70195/m/btn_captain.png);}
.selectTeam .btnIron {right:9%; background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/70195/m/btn_iron.png);}
.selectTeam button.current {background-position:100% 0;}
.viewResult {background:url(http://webimage.10x10.co.kr/eventIMG/2016/70195/m/bg_vote.png) 0 0 no-repeat; background-size:100% 100%;}
.viewResult .txt {overflow:hidden; width:84%; height:2rem; margin:0 auto; color:#b1b1b1; font-size:1rem; line-height:2.2rem; font-weight:600; text-align:center; background-color:#434242; border-radius:1.2rem;}
.viewResult .bar {overflow:hidden; width:84%; height:2rem; margin:0 auto; background-color:#2055cd; border-radius:1.2rem;}
.viewResult .bar p {height:2rem;}
.viewResult .bar .teamCt {float:left;}
.viewResult .bar .teamIr {float:right; background-color:#e61921; border-radius:0 1.2rem 1.2rem 0;}
.viewResult .count {overflow:hidden; width:84%; margin:0 auto; line-height:1.4; padding:1.5rem 0 2.2rem;}
.viewResult .count div {color:#b1b1b1; font-size:1rem;}
.viewResult .count .teamCt {text-align:left; padding-left:0.8rem;}
.viewResult .count .teamIr {text-align:right; padding-right:0.8rem;}
.viewResult .count .teamCt em {color:#2055cd;}
.viewResult .count .teamIr em {color:#e61921;}
.shareSns {position:relative;}
.shareSns ul {overflow:hidden; position:absolute; left:43%; top:40%; width:46%; height:47%;}
.shareSns li {float:left; width:33%; height:100%;}
.shareSns li a {display:block; width:100%; height:100%; text-indent:-9999em;}
.selectGift {background:url(http://webimage.10x10.co.kr/eventIMG/2016/70195/m/bg_gift.png) 0 0 no-repeat; background-size:100% 100%;}
.selectGift ul {overflow:hidden; padding:0 7.8% 1.7rem;}
.selectGift li {position:relative; float:left; width:33.33333%; background:#fff;}
.selectGift li input {display:inline-block; position:absolute; left:0; top:7%; z-index:30; width:100%; height:54%; background:transparent; border:0;}
.selectGift li input[type=radio]:checked {width:100%; height:54%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/70195/m/ico_check.png) 0 0 no-repeat; background-size:100% 100%; border:0;}
.swiper {position:relative; padding:0 4.68%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/70195/m/bg_slide.png) 0 0 no-repeat; background-size:100% 100%;}
.swiper button {display:block; position:absolute; top:40%; z-index:30; width:4.4%; background:transparent;}
.swiper button.btnPrev {left:8%;}
.swiper button.btnNext {right:8%;}
.swiper .pagination {position:absolute; left:0; bottom:-2.4rem; z-index:30; width:100%; height:auto; padding-top:0;}
.swiper .pagination span {display:inline-block; width:1.2rem; height:1.2rem; background:transparent url(http://webimage.10x10.co.kr/eventIMG/2016/70195/m/btn_pagination.png) 0 0 no-repeat; background-size:2.4rem auto;}
.swiper .pagination span.swiper-active-switch {background-position:100% 0;}
.swiper .video {width:100%; height:100%;}
.swiper .video .youtube {overflow:hidden; position:relative; height:0; padding-bottom:60.25%; background:#000;}
.swiper .video .youtube iframe {position:absolute; top:0; left:0; width:100%; height:100%}
.swiper .mask {position:absolute; left:0; z-index:30; width:100%; height:33%; background:transparent;}
.swiper .mask.top {top:0;}
.swiper .mask.bottom {bottom:0;}
.evtNoti {padding:2.6rem 6%; background:#efefef;}
.evtNoti h3 {width:6.7rem;}
.evtNoti ul {padding-top:1rem;}
.evtNoti li {position:relative; color:#909090; padding:0 0 0.7rem 0.7rem; font-size:1rem;}
.evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:0.2rem; width:0.2rem; height:0.2rem; background:#909090; border-radius:50%;}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper(".swiper1",{
		loop:false,
		autoplay:false,
		speed:800,
		pagination:".pagination",
		autoplayDisableOnInteraction:false,
		nextButton:".btnNext",
		prevButton:".btnPrev"
	});
	$(".selectTeam button").click(function(){
		$(".selectTeam button").removeClass("current");
		$(this).addClass("current");
		$("#selectGiftshow").show();
		frmcom.gubunval.value = $(this).val()
		window.parent.$('html,body').animate({scrollTop:$("#vote").offset().top},400);
	});
});

function jsevtgo(e){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2016-04-20" and left(currenttime,10)<"2016-04-27" ) then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if subscriptcount > 0 then %>
				<% if left(currenttime,10)="2016-04-26" then %>
					alert('하루 한 번만 응모할 수 있습니다.\n감사합니다.');
				<% else %>
					alert('하루 한 번만 응모할 수 있습니다.\n내일 또 응모해주세요.');
				<% end if %>
				return;
			<% else %>
				var giftgubun = $(":input:radio[name=giftitem]:checked").val();
				var teamgubun = frmcom.gubunval.value;

				if (teamgubun == ""){
					alert('팀을 선택해 주세요!');
					return false;
				}
	
				if (giftgubun == null){
					alert('상품을 선택해 주세요!');
					return false;
				}
	
				var str = $.ajax({
					type: "POST",
					url: "/event/etc/doeventsubscript/doEventSubscript70195.asp",
					data: "mode=evtgo",
					data: "mode=evtgo&teamgubun="+teamgubun+"&itemgubun="+giftgubun,
					dataType: "text",
					async: false
				}).responseText;
				var str1 = str.split("||")
				if (str1[0] == "11"){
					<% if left(currenttime,10)="2016-04-26" then %>
						alert('응모해주셔서 감사합니다.\n드디어 내일이 개봉이에요!');
					<% else %>
						alert('응모해주셔서 감사합니다.\n내일 또 응모해주세요!');
					<% end if %>
					parent.location.reload();
					return false;
				}else if (str1[0] == "01"){
					alert('잘못된 접속입니다.');
					return false;
				}else if (str1[0] == "02"){
					alert('텐바이텐 로그인 후\n응모하실 수 있습니다.');
					return false;
				}else if (str1[0] == "03"){
					alert('이벤트 기간이 아닙니다.');
					return false;		
				}else if (str1[0] == "04"){
					<% if left(currenttime,10)="2016-04-26" then %>
						alert('하루 한 번만 응모할 수 있습니다.\n감사합니다.');
					<% else %>
						alert('하루 한 번만 응모할 수 있습니다.\n내일 또 응모해주세요.');
					<% end if %>
					return false;
				}else if (str1[0] == "00"){
					alert('정상적인 경로가 아닙니다.');
					return false;
				}else{
					alert('오류가 발생했습니다.');
					return false;
				}
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End IF %>
}
</script>
	<!-- 텐바이텐X시빌워 -->
	<div class="mEvt70195">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/70195/m/tit_civil_war.jpg" alt="투표는 시작되었다" /></h2>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70195/m/txt_vote.jpg" alt="응원하는 팀에 투표하세요" /></p>
		<div class="vote" id="vote">
			<div class="selectTeam">
				<button type="button" value="1" class="btnCaptain"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70195/m/btn_vote.png" alt="팀 캡틴 선택하기" /></button>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70195/m/txt_vs.png" alt="vs" /></p>
				<button type="button"  value="2" class="btnIron"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70195/m/btn_vote.png" alt="팀 아이언맨 선택하기" /></button>
			</div>
			<div class="viewResult">
				<% if subscriptcount < 1 then %>
					<p class="txt">득표율은 최종 응모 후 확인할 수 있습니다.</p>
				<% else %>
					<div class="bar">
						<p class="teamCt" style="width:<%= tcapgraph %>%;"></p>
						<p class="teamIr" style="width:<%= tirongraph %>%;"></p>
					</div>
				<% end if %>
				
				<% if subscriptcount < 1 then %>
				<% else %>
					<div class="count">
						<div class="teamCt ftLt">
							<p>팀 캡틴</p>
							<p><em><%= tcapcnt %></em>표 (<em><%= tcapgraph %></em>%)</p>
						</div>
						<div class="teamIr ftRt">
							<p>팀 아이언맨</p>
							<p><em><%= tironcnt %></em>표 (<em><%= tirongraph %></em>%)</p>
						</div>
					</div>
				<% end if %>
				<div class="selectGift" id="selectGiftshow" style="display:none">
					<ul>
						<li>
							<input type="radio" id="gift1" name="giftitem" value="1" checked />
							<label for="gift1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70195/m/img_gift_01.jpg" alt="오리지널 무선스피커 6명" /></label>
						</li>
						<li>
							<input type="radio" id="gift2" name="giftitem" value="2" />
							<label for="gift2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70195/m/img_gift_02.jpg" alt="오리지널 USB 8GB 6명" /></label>
						</li>
						<li>
							<input type="radio" id="gift3" name="giftitem"  value="3" />
							<label for="gift3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70195/m/img_gift_03.jpg" alt="오리지널 핸드폰 충전기 6명" /></label>
						</li>
						<li>
							<input type="radio" id="gift4" name="giftitem"  value="4" />
							<label for="gift4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70195/m/img_gift_04.jpg" alt="오리지널 반팔 티셔츠 6명" /></label>
						</li>
						<li>
							<input type="radio" id="gift5" name="giftitem"  value="5" />
							<label for="gift5"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70195/m/img_gift_05.jpg" alt="영화 예매권 50명" /></label>
						</li>
						<li>
							<input type="radio" id="gift6" name="giftitem"  value="6" />
							<label for="gift6"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70195/m/img_gift_06.jpg" alt="그래픽노블" /></label>
						</li>
					</ul>
					<button type="button" onclick="jsevtgo(); return false;" class="btnSubmit"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70195/m/btn_apply.png" alt="경품 응모하기" /></button>
				</div>
				<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
					<input type="hidden" name="gubunval">
				</form>
			</div>
		</div>

		<!-- 공유하기 -->
		<div class="shareSns">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70195/m/txt_share.png" alt="친구들에게 소문내면 당첨확률이 올라간다!" /></p>
			<ul>
				<li><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');return false;">페이스북</a></li>
				<li><a href="" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');return false;">트위터</a></li>
				<li><a href="" onclick="parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>');return false;">카카오톡</a></li>
					
			</ul>
		</div>
		<!--// 공유하기 -->
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/70195/m/tit_preview.png" alt="영화 미리보기" /></h3>
		<div class="swiper">
			<div class="swiper-container swiper1">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<div class="mask top"></div>
						<div class="mask bottom"></div>
						<div class="video"><div class="youtube"><iframe src="https://www.youtube.com/embed/EDfBPe3URhU" frameborder="0" allowfullscreen></iframe></div></div>
					</div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70195/m/img_slide_01.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70195/m/img_slide_02.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70195/m/img_slide_03.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70195/m/img_slide_04.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70195/m/img_slide_05.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70195/m/img_slide_06.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70195/m/img_slide_07.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70195/m/img_slide_08.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70195/m/img_slide_09.jpg" alt="" /></div>
				</div>
			</div>
			<div class="pagination"></div>
			<button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70195/m/btn_prev.png" alt="이전" /></button>
			<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70195/m/btn_next.png" alt="다음" /></button>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70195/m/txt_synopsis.png" alt="어벤져스 VS 어벤져스 분열은 시작되었다! 어벤져스와 관련된 사고로 부수적인 피해가 일어나자 정부는 어벤져스를 관리하고 감독하는 시스템인 일명‘슈퍼히어로 등록제’를 내놓는다. 어벤져스 내부는 정부의 입장을 지지하는 찬성파(팀 아이언맨)와 이전처럼 정부의 개입 없이 자유롭게 인류를 보호해야 한다는 반대파(팀 캡틴)로 나뉘어 대립하기 시작하는데..." /></p>
		<div class="evtNoti">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/70195/m/tit_noti.png" alt="유의사항" /></h3>
			<ul>
				<li>텐바이텐 ID로 로그인 후 응모 가능합니다.</li>
				<li>당첨자는 2016년 4월 27일 수요일에 텐바이텐 홈페이지에서 발표합니다.</li>
				<li>당첨 경품은  선택한 상품에서 변경될 수 있습니다.</li>
				<li>당첨자와 수령자는 동일해야 하며, 당첨 상품 양도는 불가합니다.</li>
				<li>정확한 발표 및 공지를 위해 마이텐바이텐의 개인정보를 업데이트 해주세요.</li>
				<li>이벤트 종료 후 경품 변경은 불가합니다.</li>
			</ul>
		<div>
	</div>
	<!--// 텐바이텐X시빌워 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->
