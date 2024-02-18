<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	History	: 2015.11.04 유태욱 생성
'	Description : 주말 데이트 1
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
	dim nowdate, LoginUserid
	Dim eCode, sqlstr, cnt, i
	Dim result1
	
	nowdate = now()
'	nowdate = "2015-11-07 00:00:00"

	LoginUserid = GetEncLoginUserID()

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  65943
	Else
		eCode   =  67124
	End If

	'// 응모내역 검색
	sqlstr = "select top 1 sub_opt1"
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
	rsget.Open sqlstr, dbget, 1
	If Not(rsget.bof Or rsget.Eof) Then
		'// 기존에 응모 했을때 값 1
		result1 = rsget(0)
	Else
		'// 최초응모
		result1 = ""
	End IF
	rsget.close

	'// 나간 수량
	''//and datediff(day,regdate,getdate()) = 0
	sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And sub_opt2<>0 "
	rsget.Open sqlstr, dbget, 1
		cnt = rsget(0)
	rsget.close
	
%>
<style type="text/css">
img {vertical-align:top;}

.mEvt67124 .hidden {visibility:hidden; width:0; height:0;}
.mEvt67124 button {background-color:transparent;}

.topic {position:relative;}
.topic .heart {position:absolute; top:20%; left:43%; width:2.968%;}

.pulse {animation-name:pulse; animation-duration:3s; animation-fill-mode:both; animation-iteration-count:5; transition:all 1s; }
.pulse {-webkit-animation-name:pulse; -webkit-animation-duration:3s; -webkit-animation-fill-mode:both; -webkit-animation-iteration-count:5; -webkit-transition:all 1s;}
@keyframes pulse {
	0% {transform:scale(1);}
	50% {transform:scale(1.5);}
	100% {transform:scale(1);}
}

@-webkit-keyframes pulse {
	0% {-webkit-transform:scale(1);}
	50% {-webkit-transform:scale(1.5);}
	100% {-webkit-transform:scale(1);}
}

.present {position:relative;}
.present .btnEnter {position:absolute; bottom:3.5%; left:50%; width:77.656%; margin-left:-38.818%;}

.lyWin {display:none; position:absolute; top:19.8%; left:50%; z-index:50; width:81.875%; margin-left:-40.9375%;}
.lyWin .btnClose {position:absolute; top:3%; right:4.3%; width:8%; height:5%; text-indent:-9999em;}

.emailbox {position:absolute; bottom:7%; left:50%; width:86.45%; margin-left:-43.225%;}
.emailbox .email {overflow:hidden; display:block; position:relative; z-index:20; width:71%; height:0; padding-bottom:14%;}
.emailbox .email div {position:absolute; top:0; left:0; width:100%; height:100%; border:2px solid #000; color:#b8b8b8; font-size:11px; text-align:center;}
.emailbox .email p {display:table; width:100%; height:100%; background-color:#fff;}
.emailbox .email p span {display:table-cell; width:100%; height:100%; vertical-align:middle;}
.emailbox a {position:absolute; top:0; right:0; width:27.4%;}

#mask {display:none; position:absolute; top:0; left:0; z-index:45; width:100%; height:100%; background:rgba(0,0,0,.6);}

.rolling {padding:0 9.843% 10%; background:#1a181e url(http://webimage.10x10.co.kr/eventIMG/2015/67124/bg_black.png) repeat-y 50% 0; background-size:100% auto;}
.rolling .swiper {position:relative;}
.rolling .swiper .swiper-container {width:100%;}
.rolling .swiper-slide {position:relative;}
.rolling .swiper button {position:absolute; top:43%; z-index:40; width:4.47%; background:transparent;}
.rolling .swiper .prev {left:-8%;}
.rolling .swiper .next {right:-8%;}

.noti {padding:6% 4.375% 5%; background-color:#f6f6f6;}
.noti h3 {color:#000; font-size:15px; font-weight:bold;}
.noti h3 span {border-bottom:2px solid #000;}
.noti ul {margin-top:15px;}
.noti ul li {position:relative; margin-top:2px; padding-left:10px; color:#444; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:4px; left:0; width:4px; height:4px; border-radius:50%; background-color:#000;}

@media all and (min-width:360px){
	.emailbox .email span {font-size:12px;}

	.noti ul li {font-size:12px;}
	.noti ul li:after {top:6px;}
}

@media all and (min-width:480px){
	.emailbox .email span {font-size:16px;}

	.noti h3 {font-size:18px;}
	.noti ul li {margin-top:4px; font-size:13px;}
	.noti ul li:after {top:8px;}
}

@media all and (min-width:600px){
	.emailbox .email span {font-size:20px;}

	.noti h3 {font-size:22px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:6px; padding-left:15px; font-size:16px;}
}

@media all and (min-width:768px){
	.emailbox .email span {font-size:24px;}
}
</style>
<script type="text/javascript">
function fnClosemask(){
	$("#lyWin").hide();
	$("#lyWin").empty();
	$("#mask").fadeOut();
	<% If isapp="1" Then %>
		document.location.href = "/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= eCode %>&ref=ok";
	<% else %>
		document.location.href = "/event/eventmain.asp?eventid=<%= eCode %>&ref=ok";
	<% end if %>
}

function fnConfirmuser(){
	<% If isapp="1" Then %>
		fnAPPpopupBrowserURL("마이텐바이텐","http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/confirmuser.asp");
		return false;
	<% else %>
		document.location.href = "/my10x10/userinfo/confirmuser.asp";
		return false;
	<% end if %>
}

function goLostFound(){
//alert("시스템 오류 입니다");
//return false;
<% If left(nowdate,10)>="2015-11-06" and left(nowdate,10)<"2015-11-09" Then %>
	<% If IsUserLoginOK Then %>
		<% if result1 <> "" then %>
			alert('이미 응모 되었습니다.');
			return false;
		<% else %>
			$.ajax({
				type:"POST",
				url:"/event/etc/doeventsubscript/doEventSubscript67124.asp",
		        data: $("#frmEvt").serialize(),
		        dataType: "text",
				async:false,
				cache:true,
				success : function(Data, textStatus, jqXHR){
					if (jqXHR.readyState == 4) {
						if (jqXHR.status == 200) {
							if(Data!="") {
								var str;
								for(var i in Data)
								{
									 if(Data.hasOwnProperty(i))
									{
										str += Data[i];
									}
								}
								str = str.replace("undefined","");
								res = str.split("|");
								if (res[0]=="OK")
								{
									$("#lyWin").empty().html(res[1]);
									$('#lyWin').show();
									var val = $('#lyWin').offset();
									$('html,body').animate({scrollTop:val.top},100);
								}
								else if (res[0]=="NO")
								{
									<% If left(nowdate,10)="2015-11-06" or left(nowdate,10)="2015-11-07" then %>
										alert('아쉬워요!\n내일 또 도전해주세요!');
									<% else %>
										alert('아쉬워요!\n실망하지 마세요!\n다음주 주말 데이트를 기대해 주세요.');
									<% end if %>
									$("#lyWin").hide();
									$("#lyWin").empty();
									$("#mask").fadeOut();
								//	document.location.reload();
									<% If isapp="1" Then %>
										document.location.href = "/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= eCode %>&ref=ok";
									<% else %>
										document.location.href = "/event/eventmain.asp?eventid=<%= eCode %>&ref=ok";
									<% end if %>
								}
								else
								{
									errorMsg = res[1].replace(">?n", "\n");
									alert(errorMsg );
									$("#mask").hide();
									//document.location.reload();
									<% If isapp="1" Then %>
										document.location.href = "/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= eCode %>";
									<% else %>
										document.location.href = "/event/eventmain.asp?eventid=<%= eCode %>";
									<% end if %>
									return false;
								}
							} else {
								alert("잘못된 접근 입니다.");
								//document.location.reload();
								<% If isapp="1" Then %>
									document.location.href = "/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= eCode %>";
								<% else %>
									document.location.href = "/event/eventmain.asp?eventid=<%= eCode %>";
								<% end if %>
								return false;
							}
						}
					}
				},
				error:function(jqXHR, textStatus, errorThrown){
					alert("잘못된 접근 입니다!");
					//document.location.reload();
					<% If isapp="1" Then %>
						document.location.href = "/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= eCode %>";
					<% else %>
						document.location.href = "/event/eventmain.asp?eventid=<%= eCode %>";
					<% end if %>
					return false;
				}
			});
		<% end if %>
	<% Else %>
		<% If isapp="1" Then %>
			parent.calllogin();
			return;
		<% else %>
			parent.jsevtlogin();
			return;
		<% End If %>
	<% End If %>
<% else %>
	alert('이벤트 기간이 아닙니다!');
	return;
<% end if %>
}
</script>
	<!-- [M/A] 주말 데이트 -->
	<div class="mEvt67124">
		<article>
			<div class="topic">
				<h2 class="hidden">주말 데이트</h2>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67124/txt_weekend_date.png" alt="외로운 주말, 집에만 있지 말고, 텐바이텐과 함께 문화데이트를 즐기세요!" /></p>
				<span class="heart pulse"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67124/img_heart.png" alt="" /></span>
			</div>

			<section class="present">
				<h3 class="hidden">헨릭 빕스코브 주말 데이트권 응모하기</h3>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67124/txt_present_v1.jpg" alt="추첨을 통해 1000명에게 대림미술관 입장권을 드립니다! 1인 2매이며, 관람 기간 11월 13일 금요일 부터 12월 13일 일요일 중 하루 택" /></p>
				<a href="" id="btnEnter" onclick="goLostFound();return false;" class="btnEnter"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67124/btn_enter.png" alt="헨릭 빕스코브 응모하기" /></a>
			</section>

			<div id="lyWin" class="lyWin">
			</div>

			<section class="intro">
				<h3 class="hidden">전시 소개</h3>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67124/txt_intro.png" alt="헨릭 빕스코브는 독창적이고 실험적인 디자인으로 주목 받고 있는 패션 디자이너입니다. 패션뿐만 아니라 사진, 설치, 영상, 퍼포먼스 등 순수 예술의 영역 에서 꾸준히 창작 활동을 진행해오고 있으며, 뉴욕 현대미술관 PS1, 파리 팔레 드 도쿄 등 세계 유수의 미술관에서 다수의 전시를 개최하여 이미 아티스트로서의 무한한 가능성을 인정받았습니다." /></p>
			</section>

			<section class="preview">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/67124/tit_preview.png" alt="작품 미리보기" /></h3>
				<div class="rolling">
					<div class="swiper">
						<div class="swiper-container swiper1">
							<div class="swiper-wrapper">
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67124/img_slide_01.jpg" alt="" /></div>
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67124/img_slide_02.jpg" alt="" /></div>
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67124/img_slide_03.jpg" alt="" /></div>
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67124/img_slide_04.jpg" alt="" /></div>
							</div>
						</div>
						<button type="button" class="prev"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67124/btn_prev.png" alt="이전" /></button>
						<button type="button" class="next"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67124/btn_next.png" alt="다음" /></button>
					</div>
				</div>
			</section>

			<section class="noti">
				<h3><span>이벤트 안내</span></h3>
				<ul>
					<li>텐바이텐 고객님을 위한 이벤트 입니다. 비회원이신 경우 회원가입 후 참여해 주세요.</li>
					<li>본 이벤트는 텐바이텐 모바일에서만 참여 가능합니다.</li>
					<li>본 이벤트는 ID당 1일 1회만 응모가능 합니다.</li>
					<li>당첨자 분들은는 11월 06일 공지사항과 이메일을 통해 관람 안내를 드릴 예정입니다.</li>
					<li>당첨 시 초대 관람 기간 중 하루 방문하여 미술관 1F 인포데스크에서 본인확인후 입장 가능합니다. (초대 관람기간 11월 13일 금요일 ~ 12월 13일 일요일/ 월요일 휴관, 목,토 저녁 8시까지 야간개관)</li>
				</ul>
			</section>
		</article>
		<div id="mask"></div>
	</div>
	<!--// 주말 데이트 -->
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		autoplay:3000,
		speed:800,
		pagination:false,
		paginationClickable:true,
		autoplayDisableOnInteraction:false,
		nextButton:'.next',
		prevButton:'.prev'
	});
	$('.prev').on('click', function(e){
		e.preventDefault()
		mySwiper.swipePrev()
	});
	$('.next').on('click', function(e){
		e.preventDefault()
		mySwiper.swipeNext()
	});
	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			mySwiper.reInit();
				clearInterval(oTm);
		}, 500);
	});
});
</script>
<%
	if LoginUserid = "greenteenz" or LoginUserid = "bjh2546" or LoginUserid = "baboytw" then
		response.write cnt
	end if
%>
<form method="post" name="frmEvt" id="frmEvt">
	<input type="hidden" name="mode" id="mode" value="add">
</form>
<!-- #include virtual="/lib/db/dbclose.asp" -->