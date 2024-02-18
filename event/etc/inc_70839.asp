<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 스냅스 사진을 보다가 MA
' History : 2016.05.20 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, currenttime, subscriptcoun, totalcnt, subscriptcount, systemok, evtUserCell
	IF application("Svr_Info") = "Dev" THEN
		eCode = "66135"
	Else
		eCode = "70839"
	end if

currenttime = now()
'															currenttime = #05/20/2016 10:05:00#

userid = GetEncLoginUserID()
evtUserCell = get10x10onlineusercell(userid) '// 참여한 회원 핸드폰번호


subscriptcount=0
'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
end if

totalcnt = getevent_subscripttotalcount(eCode, "", "", "")

''응모 차단시 X로 변경
	'systemok="X"
	systemok="O"

if left(currenttime,10)<"2016-05-23" then
	systemok="X"
	if userid = "baboytw" or userid = "greenteenz" then
		systemok="O"
	end if
end if

%>
<style type="text/css">
img {vertical-align:top;}

html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

.snaps button {background-color:transparent;}

.rolling {position:relative; background-color:#eee;}
.rolling .swiper {position:relative;}
.rolling .swiper .swiper-container {width:100%;}
.rolling button {position:absolute; top:31.8%; z-index:10; width:15.625%;}
.rolling .swiper .btn-prev {left:0;}
.rolling .swiper .btn-next {right:0;}
.rolling .swiper .pagination {position:absolute; top:63%; left:0; z-index:10; width:100%; height:auto; padding-top:0; text-align:center;}
.rolling .swiper .pagination .swiper-pagination-switch {display:inline-block; width:6px; height:6px; margin:0 4px; background-color:#fff; cursor:pointer; transition:background-color 0.7s ease;}
.rolling .swiper .pagination .swiper-active-switch {background-color:#48210e;}

@media all and (min-width:360px){
	.rolling .swiper .pagination .swiper-pagination-switch {width:8px; height:8px;}
}
@media all and (min-width:480px){
	.rolling .swiper .pagination .swiper-pagination-switch {width:10px; height:10px; margin:0 6px;}
}
@media all and (min-width:768px){
	.rolling .swiper .pagination .swiper-pagination-switch {width:16px; height:16px; margin:0 10px;}
}

.btnView {display:block; position:absolute; top:43.5%; right:8.59%; z-index:10; width:16.25%;}
.btnGet {display:block; width:74.68%; margin:0 auto;}

.lyView {display:none; position:absolute; top:11%; left:50%; z-index:30; width:81.56%; margin-left:-40.48%;}
.lyView .btnClose {position:absolute; top:0; right:1%; width:19.15%;}
.lyView .phone {position:absolute; bottom:13.5%; left:50%; width:76.67%; margin-left:-38.335%;}
.lyView .phone div {position:relative; width:100%; padding-right:60px;}
.lyView .phone span {display:block; width:100%; height:27px; background-color:#f8f8f8; color:#000; font-size:14px; line-height:28px; text-align:center;}
.lyView .phone .btnmodify {position:absolute; top:0; right:0; width:54px;}
#dimmed {display:none; position:absolute; top:0; left:0; z-index:20; width:100%; height:100%; background:rgba(0,0,0,.6);}

.noti {padding-bottom:5%; background-color:#384669;}
.noti ul {padding:0 12% 0 4.68%;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#f8f8f8; font-size:1rem; line-height:1.5em;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.5rem; left:0; width:0.4rem; height:0.1rem; background-color:#f8f8f8;}
</style>
<script type="text/javascript">
$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt70839").offset().top}, 0);
	/* swiper js */
	mySwiper = new Swiper("#rolling .swiper",{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		autoplay:3000,
		speed:800,
		pagination:"#rolling .pagination",
		paginationClickable:true,
		autoplayDisableOnInteraction:false,
		nextButton:"#rolling .btn-next",
		prevButton:"#rolling .btn-prev",
		effect:"fade"
	});

	$("#lyView .btnClose").click(function(){
		$("#lyView").hide();
		$("#dimmed").fadeOut();
	});
});


function jsevtgo(e){
<% if systemok = "O" then %>
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2016-05-20" and left(currenttime,10)<"2016-05-30" ) then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if subscriptcount > 0 then %>
				alert('이미 신청 하셨습니다.');
				return;
			<% else %>
				var str = $.ajax({
					type: "POST",
					url: "/event/etc/doeventsubscript/doEventSubscript70839.asp",
					data: "mode=evtgo",
					dataType: "text",
					async: false
				}).responseText;
				var str1 = str.split("||")
				if (str1[0] == "11"){
					$("#lyView").show();
					$("#dimmed").show();
					window.$('html,body').animate({scrollTop:100}, 200);
					return false;
				}else if (str1[0] == "01"){
					alert('잘못된 접속입니다.');
					return false;
				}else if (str1[0] == "02"){
					alert('로그인을 해야\n이벤트에 참여할 수 있어요.');
					return false;
				}else if (str1[0] == "03"){
					alert('이벤트 기간이 아닙니다.');
					return false;		
				}else if (str1[0] == "04"){
					alert('이미 신청 하셨습니다.');
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
<% else %>
	alert('잠시 후 다시 시도해 주세요!!');
	return;
<% end if %>
}
</script>
	<div class="mEvt70839 snaps">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70839/m/txt_snaps_v2.jpg" alt="텐바이텐과 스냅스의 콜라보레이션 스냅스 포토북을 무료로 이용할 수 있는 쿠폰을 선착순으로 드립니다!" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70839/m/txt_desc.png" alt="스마트폰 사진으로 만드는 포토북, 아날로그로 남기는 우리의 일상, 감동이 있는 특별한 선물" /></p>

		<div id="rolling" class="rolling">
			<div class="swiper">
				<div class="swiper-container swiper">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70839/m/img_slide_01.jpg" alt="스냅스 포토북 11,900원이 0원! 선착순 한정수량" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70839/m/img_slide_02.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70839/m/img_slide_03.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70839/m/img_slide_04.jpg" alt="" /></div>
					</div>
				</div>
				<div class="pagination"></div>
				<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70839/m/btn_prev.png" alt="이전" /></button>
				<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70839/m/btn_next.png" alt="다음" /></button>
			</div>

			<% If isapp Then %>
				<a href=""  id="btnView" class="btnView" onclick="fnAPPpopupBrowserURL('스냅스 포토북','<%= wwwUrl %>/event/etc/inc_70839_item.asp'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70839/m/btn_view.png" alt="스냅스 포토북 자세히 보기" /></a>
			<% Else %>
				<a href="/event/etc/inc_70839_item.asp" target="_blank" id="btnView" class="btnView"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70839/m/btn_view.png" alt="스냅스 포토북 자세히 보기" /></a>
			<% End If %>

			<!-- for dev msg : 포토북 신청하기 -->
			<a href="#lyView" id="btnGet" onclick="jsevtgo(); return false;" class="btnGet"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70839/m/btn_get.png" alt="포토북 신청하기" /></a>
		</div>

		<!-- for dev msg : 레이어 팝업 -->
		<div id="lyView" class="lyView">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70839/m/txt_done.png" alt="스냅스 포토북 신청이 완료되었습니다! * 쿠폰은 다음날 SMS를 통해 발송될 예정입니다. * 개인정보에 있는 휴대폰 번호를 확인해 주세요!" /></p>
			<div class="phone">
				<div>
					<span><%= evtUserCell %></span>
					<% if isapp then %>
						<a href="" onclick="fnAPPpopupBrowserURL('마이텐바이텐','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/confirmuser.asp'); return false;" class="btnmodify"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70839/m/btn_modify.png" alt="수정" /></a>
					<% else %>
						<a href="/my10x10/userinfo/confirmuser.asp" class="btnmodify"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70839/m/btn_modify.png" alt="수정" /></a>
					<% end if %>
				</div>
			</div>
			<button type="button" class="btnClose"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70839/m/btn_close.png" alt="레이어팝업 닫기" /></button>
		</div>

		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70839/m/txt_way_v1.png" alt="이벤트 참여 방법은 포토북 신청한 후 다음날 SMS를 확인하신 후 스냅스에서 쿠폰을 사용하세요" /></p>

		<div class="noti">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/70839/m/tit_noti.png" alt="이벤트 유의사항" /></h3>
			<ul>
				<li>본 이벤트는 ID 당 1회만 신청이 가능하며, 발급받은 쿠폰은 모바일 기기당 1개만 사용 가능합니다.</li>
				<li>이벤트는 상품 품절 시 조기 마감 될 수 있습니다.<br /> (이용권 유효기간 : 2016. 6. 5까지 )</li>
				<li>스냅스 앱에서 쿠폰번호 등록 후 바로 사용 가능합니다.</li>
				<li>6X6 포토북 이용권은 모바일 전용상품으로 스냅스 앱에서만 사용 가능합니다.</li>
				<li>본 이용권은 포토북 6X6/소프트커버/기본21p 무료 이용권이며, 페이지 추가 및 커버 변경 시, 추가 비용이 발생됩니다.</li>
				<li>5만원 미만 상품 주문 시, 별도의 배송료가 추가 됩니다.</li>
			</ul>
		</div>

		<div id="dimmed"></div>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
