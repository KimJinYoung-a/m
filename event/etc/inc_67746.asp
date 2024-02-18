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
' Description : 텐바이텐 X 영화 <스누피: 더 피너츠 무비>
' History : 2015.11.30 원승현
'###########################################################

dim eCode, cnt, sqlStr, couponkey, regdate, gubun, arrList, i, totalsum, linkeCode, imgLoop, imgLoopVal, irdsite20, arrRdSite, vUserID
	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "65963"
	Else
		eCode 		= "67746"
	End If

	vUserID = GetEncLoginUserID

	If IsUserLoginOK Then
		'// 총 응모횟수, 개인별 응모횟수값 가져온다.
		sqlstr = "Select count(sub_idx) as totcnt" &_
				" From db_event.dbo.tbl_event_subscript" &_
				" WHERE evt_code='" & eCode & "' and userid='" & vUserID & "' And convert(varchar(10), regdate, 120) = '"&Left(now(),10) &"' "
				'response.write sqlstr
		rsget.Open sqlStr,dbget,1
			totalsum = rsget(0)
		rsget.Close
	End If
%>
<style type="text/css">
img {vertical-align:top;}

.mEvt67746 h2 {visibility:hidden; width:0; height:0;}
.mEvt67746 button {background-color:transparent;}
.hug h3, .gift h3, .down h3, .movie h3 {visibility:hidden; width:0; height:0;}

.hug {position:relative;}
.hug .btnHugme {position:absolute; top:-10%; left:6.25%; width:37%;}
.bounce {-webkit-animation-name:bounce; -webkit-animation-iteration-count:5; -webkit-animation-duration:1s; -moz-animation-name:bounce; -moz-animation-iteration-count:5; -moz-animation-duration:1s; -ms-animation-name:bounce; -ms-animation-iteration-count:infinite; -ms-animation-duration:1s;}
@-webkit-keyframes bounce {
	from, to{margin-top:10px; -webkit-animation-timing-function:ease-out;}
	50% {margin-top:0px; -webkit-animation-timing-function:ease-in;}
}
.heySomething @keyframes bounce {
	from, to{margin-top:10px; animation-timing-function:ease-out;}
	50% {margin-top:0px; animation-timing-function:ease-in;}
}

.lyDone {display:none; position:absolute; top:18.2%; left:50%; z-index:60; width:96.8%; margin-left:-48.4%;}
.lyDone .btnClose {position:absolute; top:6.5%; right:4%; width:8.8%;}

#mask {display:none; position:absolute; top:0; left:0; z-index:55; width:100%; height:100%; background:rgba(0,0,0,.6);}

.noti {padding:7% 7.8%; background-color:#fff;}
.noti h3 {color:#000; font-size:13px;}
.noti h3 strong {display:inline-block; padding-bottom:1px; border-bottom:2px solid #000; line-height:1.25em;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; margin-top:2px; padding-left:12px; color:#464646; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:2px; left:0; width:0; height:0; border-top:4px solid transparent; border-bottom:4px solid transparent; border-left:6px solid #d60000;}

.movie {overflow:hidden; position:relative;}
.movie .youtube {overflow:hidden; position:relative; height:0; padding-bottom:56.25%; background:#000;}
.movie .youtube iframe {position:absolute; top:0; left:0; width:100%; height:100%}

.rolling {position:absolute; top:37%; left:50%; width:84%; margin-left:-42%;}
.rolling .swiper {position:relative; padding:4px; background-color:#fff;}
.rolling .swiper .swiper-container {width:100%;}
.rolling .swiper-slide {position:relative;}
.rolling .swiper .pagination {position:absolute; bottom:-15%; left:0; width:100%; height:auto; z-index:50; padding-top:0; text-align:center;}
.rolling .swiper .pagination .swiper-pagination-switch {display:inline-block; width:10px; height:10px; margin:0 4px; border-radius:50%; background-color:#fff; cursor:pointer; transition:background-color 1s ease;}
.rolling .swiper .pagination .swiper-active-switch {width:22px; border-radius:22px; background-color:#000;}
.rolling .swiper button {position:absolute; top:40%; z-index:150; width:8%; background:transparent;}
.rolling .swiper .prev {left:-10.2%;}
.rolling .swiper .next {right:-10.2%;}

@media all and (min-width:360px){
	.noti h3 {font-size:15px;}
	.noti ul li {font-size:12px;}
	.noti ul li:after {top:3px;}
}

@media all and (min-width:480px){
	.rolling .swiper .pagination .swiper-pagination-switch {width:16px; height:16px; margin:0 6px; }
	.rolling .swiper .pagination .swiper-active-switch {width:36px;}

	.noti h3 {font-size:17px;}
	.noti ul {margin-top:16px;}
	.noti ul li {margin-top:4px; font-size:13px;}
}

@media all and (min-width:600px){
	.noti h3 {font-size:20px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:6px; padding-left:15px; font-size:16px;}
	.noti ul li:after {top:9px;}
}
</style>


<script type="text/javascript">

	function checkform(){
		<% If vUserID = "" Then %>
			if ("<%=IsUserLoginOK%>"=="False") {
				<% if isApp=1 then %>
					parent.calllogin();
					return false;
				<% else %>
					parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
					return false;
				<% end if %>
				return false;
			}
		<% End If %>
		<% If vUserID <> "" Then %>
			<% If Now() >= #11/30/2015 10:00:00# And now() < #12/10/2015 00:00:00# Then %>
				$.ajax({
					type:"GET",
					url:"/event/etc/doEventSubscript67746.asp?mode=add",
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
										$('#lyDone').show();
										$('#mask').show();
										var tt = $('.hug').offset();
										$('html,body').animate({scrollTop:tt.top},200);
										$("#chgImgArea").empty().html("<div class='after'><img src='http://webimage.10x10.co.kr/eventIMG/2015/67746/img_hug_me_after.jpg' alt='' /></div>");
										$('#lyDone').empty().html(res[1]);
									}
									else
									{
										errorMsg = res[1].replace(">?n", "\n");
										alert(errorMsg);
										document.location.reload();
										return false;
									}
								} else {
									alert("잘못된 접근 입니다.");
									document.location.reload();
									return false;
								}
							}
						}
					},
					error:function(jqXHR, textStatus, errorThrown){
						alert("잘못된 접근 입니다.");
						//var str;
						//for(var i in jqXHR)
						//{
						//	 if(jqXHR.hasOwnProperty(i))
						//	{
						//		str += jqXHR[i];
						//	}
						//}
						//alert(str);
						document.location.reload();
						return false;
					}
				});
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;				
			<% end if %>
		<% End If %>
	}


	function fnSnoopyClose()
	{
		$("#lyDone").slideUp();
		$("#mask").fadeOut();
	}
</script>



<div class="mEvt67746">
	<article>
		<h2>스누피 안아줘</h2>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67746/txt_snoopy.png" alt="위로가 필요한 우리를 꼬옥 안아줄 스누피! 매일 와서 안아주기만 하면 선물도 가득 안깁니다. 행운의 주인공이 되어 보세요! 이벤트 기간은 11월 30일부터 12월 9일까지 입니다." /></p>

		<%' for dev msg : 참여 %>
		<section class="hug">
			<h3>이벤트 참여하기</h3>
			<div id="chgImgArea">
				<%' for dev msg : 참여 후에 안아주세요! 버튼 숨겨주고, 이미지 img_hug_me_after.png로 바꿔주세요! %>
				<% If totalsum > 0 Then %>
					<div class="after"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67746/img_hug_me_after.jpg" alt="" /></div>
				<% Else %>
					<div class="before"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67746/img_hug_me_before.jpg" alt="" /></div>
					<button type="button" id="btnHugme" class="btnHugme bounce" onclick="checkform();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67746/btn_hug_me.png" alt="안아주세요! 클릭" /></button>
				<% End If %>
			</div>
		</section>

		<%' for dev msg : 응모완료 layer %>
		<div id="lyDone" class="lyDone"></div>

		<section class="gift">
			<h3>선물 둘러보기</h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67746/txt_gift.jpg" alt="영화 전용 예매권 1인 2매, 시사회 초대권 1인 2매, 스누피 오리지널 티셔츠가 준비 되어 있습니다." /></p>
		</section>

		<%' for dev msg : 앱 다운로드 %>
		<% If isApp="1" Then %>
		<% Else %>
			<section class="down">
				<h3>텐바이텐 앱 다운 받자</h3>
				<p><a href="/event/appdown/" title="텐바이텐 앱 다운로드 받기" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67746/btn_down_app_v3.jpg" alt="텐바이텐 APP을 다운 받고, 더 즐거운 소식 만나러가자!" /></a></p>
			</section>
		<% End If %>

		<section class="noti">
			<h3><strong>이벤트 유의사항</strong></h3>
			<ul>
				<li>텐바이텐 ID 로그인 후 참여할 수 있습니다.</li>
				<li>매일 1회만 참여할 수 있습니다.</li>
				<li>당첨된 내역은 즉시 확인할 수 있습니다.</li>
				<li>당첨자 안내는 12월 10일 목요일에 공지됩니다.</li>
			</ul>
		</section>

		<section class="movie">
			<h3>스누피 더피너츠 무비</h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67746/txt_movie.png" alt="12월 24일, 3D 대개봉" /></p>
			<div class="rolling">
				<div class="swiper">
					<div class="swiper-container swiper1">
						<div class="swiper-wrapper">
							<div class="swiper-slide">
								<div class="youtube">
									<iframe src="https://www.youtube.com/embed/gNzyBwaFN94" frameborder="0" title="스누피 더 피너츠 무비 예고편" allowfullscreen></iframe>
								</div>
							</div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67746/img_slide_02.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67746/img_slide_03.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67746/img_slide_04.jpg" alt="" /></div>
						</div>
					</div>
					<button type="button" class="prev"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67746/btn_prev.png" alt="이전" /></button>
					<button type="button" class="next"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67746/btn_next.png" alt="다음" /></button>
					<div class="pagination"></div>
				</div>
			</div>
		</section>

		<div id="mask"></div>
	</article>
</div>
<script type="text/javascript">
$(function(){
	/* layer */

	$("#btnClose").click(function(){
		$("#lyDone").slideUp();
		$("#mask").fadeOut();
	});

	$("#mask").click(function(){
		$("#lyDone").hide();
		$("#mask").fadeOut();
	});

	/* swipe */
	mySwiper = new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		autoplay:false,
		speed:800,
		pagination:".pagination",
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