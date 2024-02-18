<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/instagrameventCls.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : 2017 세일- 반짝반짝 스티커
' History : 2017-03-30 유태욱 생성
'####################################################
Dim eCode, userid, pagereload, i
dim iCCurrpage, iCTotCnt, eCC, iCPageSize, iCTotalPage
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66295
Else
	eCode   =  77064
End If

iCCurrpage = requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	
IF iCCurrpage = "" THEN iCCurrpage = 1
IF iCTotCnt = "" THEN iCTotCnt = -1

eCC = requestCheckVar(Request("eCC"), 1)
pagereload	= requestCheckVar(request("pagereload"),2)
userid		= GetEncLoginUserID()

iCPageSize = 4		'한 페이지의 보여지는 열의 수

dim oinstagramevent
set oinstagramevent = new Cinstagrameventlist
	oinstagramevent.FPageSize	= iCPageSize
	oinstagramevent.FCurrPage	= iCCurrpage
	oinstagramevent.FTotalCount		= iCTotCnt  '전체 레코드 수
	oinstagramevent.FrectIsusing = "Y"
	oinstagramevent.FrectEcode = eCode
	oinstagramevent.fnGetinstagrameventList

	iCTotCnt = oinstagramevent.FTotalCount '리스트 총 갯수
	iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
	IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1

%>
<!-- #include virtual="/event/props/sns.asp" -->
<style type="text/css">
.rolling .swiper {position:relative; background-color:#ffe684;}
.twinkle {position:absolute; top:8.31%; left:13.125%; z-index:5; width:3.75%; animation-fill-mode:both; -webkit-animation-fill-mode:both;}
.twinkle1 {width:4.5%; animation:twinkle 5 4s;  animation-delay:2s; -webkit-animation:twinkle 5 4s; -webkit-animation-delay:2s;}
.twinkle2 {top:21.36%; left:37.65%; animation:twinkle2 5 3s; -webkit-animation:twinkle2 5 3s;}
.twinkle3 {top:15.02%; left:85.15%; animation:twinkle3 5 3s; -webkit-animation:twinkle3 5 3s;}

@keyframes twinkle {
	0% {opacity:0.1;}
	50% {opacity:1;}
	100% {opacity:0.1;}
}
@-webkit-keyframes twinkle {
	0% {opacity:0.1;}
	50% {opacity:1;}
	100% {opacity:0.1;}
}
@keyframes twinkle2 {
	0% {opacity:1;}
	50% {opacity:0.1;}
	100% {opacity:2;}
}
@-webkit-keyframes twinkle2 {
	0% {opacity:1;}
	50% {opacity:0.1;}
	100% {opacity:2;}
}
@keyframes twinkle3 {
	0% {opacity:0;}
	50% {opacity:1;}
	100% {opacity:0;}
}
@-webkit-keyframes twinkle3 {
	0% {opacity:0;}
	50% {opacity:1;}
	100% {opacity:0;}
}

.rolling p {position:absolute; top:0; left:0; width:100%; z-index:5;}
.rolling .swiper .swiper-container {width:100%;}
.rolling .pagination {position:absolute; bottom:4.72%; left:0; z-index:10; width:100%; height:auto; padding-top:0; text-align:center;}
.rolling .pagination .swiper-pagination-switch {display:inline-block; position:relative; width:6px; height:6px; margin:0 0.6rem; border:2px solid #fff; background-color:rgba(174, 132, 205, 0.4); box-shadow:0 0 2px 2px rgba(174, 132, 205, 0.4); cursor:pointer;}
.rolling .pagination .swiper-pagination-switch {transform-style:preserve-3d; transition:transform 0.6s ease, opacity 0.6s ease; -webkit-transform-style:preserve-3d; -webkit-transition:-webkit-transform 0.6s ease, opacity 0.6s ease;}
.rolling .pagination .swiper-active-switch {background-color:#fff; transform: rotateY(180deg); -webkit-transform:rotateY(180deg);}
@media all and (min-width:360px){
	.rolling .pagination .swiper-pagination-switch {width:8px; height:8px;}
}
@media all and (min-width:768px){
	.rolling .pagination .swiper-pagination-switch {width:10px; height:10px;}
}

.sticker .event {position:relative;}
.sticker .btnGo {position:absolute; top:48.6%; left:4.84%; width:22.96%;}

.instagram {padding-bottom:3.1rem; background-color:#fff;}
.instagram ul {overflow:hidden; width:29.2rem; margin:0 auto;}
.instagram ul li {float:left; width:13.1rem; margin:0.75rem;}
.instagram ul li img {width:13.1rem; height:13.1rem;}
.instagram ul li .id {display:block; height:1.2rem; margin-top:0.6rem; padding:0 0.5rem; color:#707070; font-size:1rem; line-height:1.313em; text-align:center;}
.instagram ul li .id span {overflow:hidden; display:inline-block; max-width:40%; text-overflow:ellipsis; white-space:nowrap; color:#954fc2; vertical-align:top;}

.pagingV15a {margin-top:2.1rem; width:100%;}
/*.pagingV15a span {width:2.3rem; height:2.3rem; margin:0 0.2rem; border:0; border-radius:50%;}
.pagingV15a span a {padding-top:0.7rem; color:#b9b9b9; font-size:1.2rem; font-weight:bold; line-height:1rem;}
.pagingV15a span.current {background-color:#8b44b8;}
.pagingV15a span.current a {color:#fff;}
.pagingV15a span.arrow {border:0; background:url(http://webimage.10x10.co.kr/eventIMG/2017/sopum/77064/m/btn_pagination_nav.png) 0 0 no-repeat; background-size:10rem auto;}
.pagingV15a span.nextBtn {background-position:100% 0; background-size:10rem auto;}*/

.noti {padding:2.5rem 2.5rem 2.4rem; border-top:1rem solid #a678d1; background-color:#eee;}
.noti h3 {position:relative; color:#7d3db9; font-size:1.3rem; font-weight:bold; line-height:1em;}
.noti h3:after {content:' '; display:block; position:absolute; top:50%; left:-1rem; width:0.4rem; height:1rem; margin-top:-0.3rem; background:url(http://webimage.10x10.co.kr/eventIMG/2017/sopum/77064/m/blt_arrow.png) 50% 0 no-repeat; background-size:100% auto;}
.noti ul {margin-top:1.3rem;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#333; font-size:1rem; line-height:1.5em;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.5rem; left:0; width:0.4rem; height:0.1rem; background-color:#333;}
.noti li .btnEvent {display:inline-block; margin-top:0.1rem; position:relative; height:1.6rem; padding:0.2rem 1.3rem 0 0.7rem; border-radius:1rem; background-color:#7d3db9; color:#fff; line-height:1.5rem;}
.noti li .btnEvent:after {content:'>'; display:block; position:absolute; top:50%; right:0.5rem; height:1.6rem; margin-top:-0.72rem; color:#fff; line-height:1.5rem;}

.sns {position:relative;}
.sns ul {width:33.75%; position:absolute; top:31%; right:3.43%;}

.bnr {background-color:#f4f7f7;}
.bnr ul li {margin-top:1rem;}
.bnr ul li:first-child {margin-top:0;}
</style>
<script type="text/javascript">
$(function(){
	<% if Request("eCC")<>"" then %>
		setTimeout("pagedown()",300);
	<% end if %>
});

$(function(){
	mySwiper = new Swiper('#rolling .swiper-container',{
		loop:true,
		autoplay:3000,
		speed:600,
		pagination:"#rolling .pagination",
		paginationClickable:true,
		effect:"fade"
	});
});


function pagedown(){
	window.$('html,body').animate({scrollTop:$("#instagramlist").offset().top}, 0);
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}
</script>
	<!-- 4월 정기세일 소품전 [77064] 반짝반짝 내친구 -->
	<div class="sopum sticker">
		<div id="rolling" class="rolling">
			<div class="swiper">
				<span class="twinkle twinkle1"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77064/m/img_twinkle_01.png" alt="" /></span>
				<span class="twinkle twinkle2"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77064/m/img_twinkle_02.png" alt="" /></span>
				<span class="twinkle twinkle3"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77064/m/img_twinkle_02.png" alt="" /></span>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77064/m/txt_sticker.png" alt="일상 속에 스티커를 붙이면 1만원 기프트카드가! 당첨자 총 50명, 발표 4월 25일" /></p>
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77064/m/img_slide_01.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77064/m/img_slide_02.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77064/m/img_slide_03.jpg" alt="" /></div>
					</div>
				</div>
				<div class="pagination"></div>
			</div>
		</div>

		<div class="event">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77064/m/txt_guide.gif" alt="인증샷 이벤트 참여 방법 텐텐 배송 쇼핑하고 반짝반짝 눈 스티커 일상 소품에 붙인 후 필수 해시태그 붙여 인스타그램에 업로드! 필수 해시태그 #텐바이텐 #텐바이텐소품전" /></p>
			<div class="btnGo"><a href="eventmain.asp?eventid=65618" title="사은품을 받기 위한 필수템 기획전으로 이동"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77064/m/btn_get.gif" alt="쇼핑하기" /></a></div>
			<div class="btnInstagram">
				<a href="https://www.instagram.com/your10x10/" title="텐바이텐 공식 인스타그램으로 이동" target="_blank" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77064/m/btn_instagram.gif" alt="텐바이텐 인스타그램 바로가기" /></a>
				<a href="https://www.instagram.com/your10x10/" class="mApp" onclick="fnAPPpopupExternalBrowser('https://www.instagram.com/your10x10/'); return false;" title="텐바이텐 공식 인스타그램으로 이동" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77064/m/btn_instagram.gif" alt="텐바이텐 인스타그램 바로가기" /></a>
			</div>
		</div>

		<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
		<input type="hidden" name="iCC" value="<%=iCCurrpage%>"/>
		<input type="hidden" name="iCTot" value=""/>
		<input type="hidden" name="eCC" value="1">
		</form>

		<!-- instagram -->
		<% if oinstagramevent.fresultcount > 0 then %>
			<div class="instagram" id="instagramlist" >
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77064/m/tit_instagram.gif" alt="고객님의 반짝반짝 인증샷" /></h3>
				<ul>
					<% for i = 0 to oinstagramevent.fresultcount-1 %>
						<li>
							<img src="<%= oinstagramevent.FItemList(i).Fimgurl %>" alt="" />
							<span class="id"><span><%=printUserId(left(oinstagramevent.FItemList(i).Fuserid,10),2,"*")%></span>님의 반짝반짝</span>
						</li>
					<% next %>
				</ul>

				<!-- pagination -->
				<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
			</div>
		<% end if %>

		<div class="noti">
			<h3>이벤트 유의사항</h3>
			<ul>
				<li>반짝반짝 눈 스티커는 텐바이텐 배송상품과 함께 배송됩니다.<br /> <a href="eventmain.asp?eventid=65618" title="사은품을 받기 위한 필수템 기획전으로 이동" class="btnEvent">텐바이텐 배송상품 보러가기</a></li>
				<li>선착순 한정수량으로 발송되며, 소진 시 미포함될 수 있습니다.</li>
				<li>인스타그램 계정이 비공개 일 경우 이벤트 참여에 제외됩니다.</li>
				<li>이벤트에 참여한 인증샷은 고객 동의 없이 이벤트 페이지 내에 노출될 수 있습니다.</li>
				<li>이벤트 페이지 내에 노출되는 SNS인증샷은 실시간 적용되지 않습니다.</li>
				<li>SNS 이벤트에 참여하였더라도 이벤트 페이지 내에 노출되지 않을 수 있습니다.</li>
				<li>이벤트 페이지 내에 SNS인증샷 노출여부는 이벤트 당첨 여부와 관합니다.</li>
			</ul>
		</div>

		<div class="sns">
			<%=snsHtml%>
		</div>

		<div class="bnr">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/common/m/tit_event_more.gif" alt="이벤트 더보기" /></h3>
			<ul>
				<li><a href="eventmain.asp?eventid=77059"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/common/m/img_bnr_index.jpg" alt="소품전 이벤트 메인페이지 가기" /></a></li>
				<li><a href="eventmain.asp?eventid=77061"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/common/m/img_bnr_friend.jpg" alt="출석체크 하고 15가지 피규어에 도전!" /></a></li>
				<li><a href="eventmain.asp?eventid=77060"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/common/m/img_bnr_sopumland.jpg" alt="매일 만나는 다양한 테마기획전" /></a></li>
			</ul>
		</div>
	</div>
<% set oinstagramevent = nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->