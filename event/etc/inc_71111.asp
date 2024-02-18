<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : tab2 : [참여이벤트] 도리를 찾아서
' History : 2016.06.10 김진영 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
Dim eCode, vUserID, irdsite20, winItemChk, winItemStr
Dim tab1eCode, tab2eCode, tab3eCode
Dim vSQL
irdsite20	= requestCheckVar(request("rdsite"), 32)
vUserID		= GetLoginUserID
IF application("Svr_Info") = "Dev" THEN
	eCode = "66148"
Else
	eCode = "71111"
end if

vSQL = ""
vSQL = vSQL & " SELECT TOP 1 sub_opt2 FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &" and userid = '"&vUserID&"' and sub_opt2 in ('11111', '22222', '33333') "
rsget.Open vSQL, dbget, 1
If Not(rsget.bof Or rsget.Eof) Then
	winItemChk = rsget("sub_opt2")
Else
	winItemChk = ""
End IF
rsget.close

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle	= Server.URLEncode("매일 ‘도리를 찾아서’ 응모하면 시사회 초대권, 휴대폰케이스 등 선물이 가득! 까먹지 말고 꼭 만나요.")
snpLink		= Server.URLEncode("http://bit.ly/dori10x10_2")
snpPre		= Server.URLEncode("텐바이텐")
snpTag		= Server.URLEncode("텐바이텐")
snpTag2		= Server.URLEncode("#텐바이텐 #도리를찾아서")

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐] 으로 도리를 찾아서!\n\n도리와 함께 하는 어드벤쳐!\n텐바이텐에 숨어 있는 ‘도리’를\n하루에 한 번 찾아 주세요\n\n시사회 초대권, 트럼프 카드,\n폰 케이스 등 선물이 가득!\n깜빡하지 말아요. :)\n\n텐바이텐으로 도리 찾으러 가기\nbit.ly/dori10x10_2"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/71111/m/img_kakao.jpg"
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
img {vertical-align:top;}

/* Finding Dory common */
.findingDory button {background-color:transparent;}
.noti {padding:8% 7% 10%; background-color:#05274c;}
.noti h3 {color:#75c9e3; font-size:1.2rem;}
.noti h3 strong {display:inline-block; padding-bottom:1px; border-bottom:2px solid #75c9e3; line-height:1.25em;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; margin-top:2px; padding-left:1rem; color:#fff; font-size:1rem; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:0.4rem; left:0; width:4px; height:4px; border-radius:50%; background-color:#75c9e3;}

.sns {position:relative;}
.sns ul {overflow:hidden; position:absolute; top:22%; right:7.8%; width:45%;}
.sns ul li {float:left; width:33.333%;}
.sns ul li a {overflow:hidden; display:block; position:relative; height:0; margin-left:13%; padding-bottom:86%; color:transparent; font-size:12px; line-height:12px; text-align:center;}
.sns ul li a span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter:alpha(opacity=0); cursor:pointer;}

.bnr {padding-top:4%; background-color:#e8ffff;}
.bnr ul li {margin-top:4%;}
.bnr ul li:first-child {margin-top:0;}

.intro {position:relative;}
.rolling {position:absolute; top:26.92%; left:50%; width:87.5%; margin-left:-43.75%;}
.rolling .swiper {position:relative;}
.rolling .swiper .swiper-container {width:100%;}
.rolling .swiper-slide {position:relative;}
.rolling .swiper .pagination {position:absolute; bottom:-10%; left:0; width:100%; height:auto; z-index:50; padding-top:0; text-align:center;}
.rolling .swiper .pagination .swiper-pagination-switch {display:inline-block; width:8px; height:8px; margin:0 0.5rem; border-radius:50%; background-color:#fff; cursor:pointer; transition:background-color 0.5s ease;}
.rolling .swiper .pagination .swiper-active-switch {background-color:#50dcff;}
.rolling .swiper button {position:absolute; top:40%; z-index:20; width:8.92%; background:transparent;}
.rolling .swiper .btn-prev {left:0;}
.rolling .swiper .btn-next {right:0;}
.rolling .mask {display:none; position:absolute; left:0; width:100%; height:36%;}
.rolling .mask-top {top:0;}
.rolling .mask-btm {bottom:0;}

.video {overflow:hidden; position:relative; width:100%; height:0; padding-bottom:62.45%; background:#000;}
.video iframe {position:absolute; top:0; left:0; width:100%; height:100%}

@media all and (min-width:480px){
	.rolling .swiper .pagination .swiper-pagination-switch {width:10px; height:10px;}
}

/* 71111 */
.find {overflow:hidden;}
.find .sea {position:relative;}
.find .sea ul li {position:absolute;}
.find .sea ul li {animation-iteration-count:5; animation-fill-mode:both; animation-direction:alternate; animation-play-state:running; animation-delay:1s;
-webkit-animation-iteration-count:5; -webkit-animation-fill-mode:both; -webkit-animation-direction:alternate; -webkit-animation-play-state:running; -webkit-animation-delay:1s;}
.find .sea ul li button {display:block; width:100%;}
.find .sea ul li.clownfish {top:57.08%; left:5.46%; width:22.03%;}
.find .sea ul li.seaturtle {top:39.39%; left:-20%; z-index:5; width:47.1875%;}
.find .sea ul li.seaturtleKid {top:49.55%; right:-7%; width:42.03%;}
.find .sea ul li.dory {top:19.48%; left:9.8%; width:15.625%;}
.find .sea ul li.whale {top:26.33%; left:16.09%; width:35.15%;}
.find .sea ul li.shark {top:32.619%; left:65.93%; width:24.53%;}
.find .sea ul li.bluetang {top:47.33%; left:49.68%; width:27.03%;}
.find .sea ul li.stingray {top:18.59%; right:0; width:34.21%;}
.find .sea ul li.octopus {top:64.61%; left:15.15%; z-index:5; width:55%;}
.find .sea ul li.otter {top:87.07%; right:-18%; width:50%;}
.find .sea ul li.seal {top:80.4%; left:-25%; width:46%;}

.position1 .sea ul li.dory {animation-name:moveDory; animation-duration:2s; animation-iteration-count:5; -webkit-animation-name:moveDory; -webkit-animation-duration:2s; -webkit-animation-iteration-count:5;}
@keyframes moveDory {
	0% {top:19.48%; left:9.8%; animation-timing-function:linear;}
	100% {top:22%; left:20%; animation-timing-function:linear;}
}
@-webkit-keyframes moveDory {
	0% {top:19.48%; left:9.8%; animation-timing-function:linear;}
	100% {top:22%; left:20%; animation-timing-function:linear;}
}
.position1 .sea ul li.seaturtle {animation-name:moveSeaturtle; animation-duration:3s; -webkit-animation-name:moveSeaturtle; -webkit-animation-duration:3s;}
@keyframes moveSeaturtle {
	0% {left:-35%; animation-timing-function:linear;}
	100% {left:-20%; animation-timing-function:linear;}
}
@-webkit-keyframes moveSeaturtle {
	0% {left:-35%; animation-timing-function:linear;}
	100% {left:-20%; animation-timing-function:linear;}
}
.position1 .sea ul li.seaturtleKid {animation-name:moveSeaturtleKid; animation-duration:2.5s; -webkit-animation-name:moveSeaturtleKid; -webkit-animation-duration:2.5s;}
@keyframes moveSeaturtleKid {
	0% {top:43%; right:-40%; animation-timing-function:ease-out;}
	100% {top:49.55%; right:-7%; animation-timing-function:ease-out;}
}
@-webkit-keyframes moveSeaturtleKid {
	0% {top:43%; right:-40%; -webkit-animation-timing-function:ease-out;}
	100% {top:49.55%; right:-7%; -webkit-animation-timing-function:ease-out;}
}
.position1 .sea ul li.stingray {animation-name:moveStingray; animation-duration:3s; -webkit-animation-name:moveStingray; -webkit-animation-duration:3s;}
@keyframes moveStingray {
	0% {top:18.59%; animation-timing-function:ease;}
	100% {top:13%; animation-timing-function:ease-out;}
}
@-webkit-keyframes moveStingray {
	0% {top:18.59%; -webkit-animation-timing-function:ease;}
	100% {top:13%; -webkit-animation-timing-function:ease-out;}
}
.position1 .sea ul li.octopus {animation-name:moveOctopus; animation-duration:2.5s; animation-delay:3s; -webkit-animation-name:moveOctopus; -webkit-animation-duration:2.5s; -webkit-animation-delay:3s;}
@keyframes moveOctopus {
	0% {left:15.15%; animation-timing-function:linear;}
	100% {left:18%; animation-timing-function:linear;}
}
@-webkit-keyframes moveOctopus {
	0% {left:15.15%; animation-timing-function:linear;}
	100% {left:20%; animation-timing-function:linear;}
}

.position2 .sea ul li.dory {top:47.33%; left:45.68%;}
.position2 .sea ul li.shark {top:61.6%; left:65.93%;}
.position2 .sea ul li.seaturtleKid {top:18.59%; right:0;}
.position2 .sea ul li.stingray {top:49.55%; left:65.93%;}
.position2 .sea ul li.bluetang {top:19.48%; left:9.8%;}
.position2 .sea ul li.otter {top:87.07%; right:61%;}
.position2 .sea ul li.seal {top:86.4%; left:65%;}
.position2 .sea ul li.dory {animation-name:moveDory2; animation-duration:2s; animation-delay:2s; -webkit-animation-name:moveDory2; -webkit-animation-duration:2s; -webkit-animation-delay:2s;}
@keyframes moveDory2 {
	0% {top:47.33%; animation-timing-function:linear;}
	100% {top:52%; animation-timing-function:linear;}
}
@-webkit-keyframes moveDory2 {
	0% {top:47.33%; animation-timing-function:linear;}
	100% {top:52%; animation-timing-function:linear;}
}
.position2 .sea ul li.seaturtleKid {animation-name:moveSeaturtleKid2; animation-duration:2.5s; animation-delay:1s; -webkit-animation-name:moveSeaturtleKid2; -webkit-animation-duration:2.5s; -webkit-animation-delay:1s;}
@keyframes moveSeaturtleKid2 {
	0% {top:13%; right:-5%; animation-timing-function:ease-out;}
	100% {top:18.59%; right:0; animation-timing-function:ease-out;}
}
@-webkit-keyframes moveSeaturtleKid2 {
	0% {top:13%; right:-5%; -webkit-animation-timing-function:ease-out;}
	100% {top:18.59%; right:0; -webkit-animation-timing-function:ease-out;}
}
.position2 .sea ul li.shark {animation-name:moveShark2; animation-duration:3.5s; -webkit-animation-name:moveShark2; -webkit-animation-duration:3.5s;}
@keyframes moveShark2 {
	0% {top:58.6%; left:65.93%; animation-timing-function:linear;}
	100% {top:61.6%; left:60.93%; animation-timing-function:linear;}
}
@-webkit-keyframes moveShark2 {
	0% {top:58.6%; left:65.93%; animation-timing-function:linear;}
	100% {top:61.6%; left:60.93%; animation-timing-function:linear;}
}
.position2 .sea ul li.whale {animation-name:moveWhale2; animation-duration:2.5s; -webkit-animation-name:moveWhale2; -webkit-animation-duration:2.5s;}
@keyframes moveWhale2 {
	0% {top:26.33%; left:20%; animation-timing-function:linear;}
	100% {top:30%; left:16.09%; animation-timing-function:linear;}
}
@-webkit-keyframes moveWhale2 {
	0% {top:26.33%; left:20%; -webkit-animation-timing-function:linear;}
	100% {top:30%; left:16.09%; -webkit-animation-timing-function:linear;}
}

.position3 .sea ul li.dory {top:57.08%; left:5.46%;}
.position3 .sea ul li.clownfish {top:61.6%; left:65.93%;}
.position3 .sea ul li.seaturtleKid {top:16%; right:0;}
.position3 .sea ul li.whale {top:28%;}
.position3 .sea ul li.shark {top:40%; left:55%;}
.position3 .sea ul li.stingray {top:19.48%; left:9.8%;}
.position3 .sea ul li.bluetang {top:49.55%; left:65.93%;}
.position3 .sea ul li.otter {top:87.07%; right:61%;}
.position3 .sea ul li.seal {top:86.4%; left:65%;}
.position3 .sea ul li.seaturtleKid {animation-name:moveSeaturtleKid3; animation-duration:2.5s; -webkit-animation-name:moveSeaturtleKid3; -webkit-animation-duration:2.5s;}
.position3 .sea ul li.dory {animation-name:moveDory3; animation-duration:1s; -webkit-animation-name:moveDory3; -webkit-animation-duration:1s;}
@keyframes moveDory3 {
	0% {left:5.46%; animation-timing-function:ease-out;}
	100% {left:10%; animation-timing-function:ease-out;}
}
@-webkit-keyframes moveDory3 {
	0% {left:5.46%; -webkit-animation-timing-function:ease-out;}
	100% {left:10%; -webkit-animation-timing-function:ease-out;}
}
@keyframes moveSeaturtleKid3 {
	0% {top:16%; right:0; animation-timing-function:ease-out;}
	100% {top:10%; right:-20%; animation-timing-function:ease-out;}
}
@-webkit-keyframes moveSeaturtleKid3 {
	0% {top:16%; right:0; -webkit-animation-timing-function:ease-out;}
	100% {top:10%; right:-20%; -webkit-animation-timing-function:ease-out;}
}
.position3 .sea ul li.clownfish {animation-name:moveClownfish3; animation-duration:1.5s; animation-delay:1s; -webkit-animation-name:moveClownfish3; -webkit-animation-duration:1.5s; -webkit-animation-delay:1s;}
@keyframes movehale3 {
	0% {left:65.93%; animation-timing-function:ease-out;}
	100% {left:60.93%; animation-timing-function:ease-out;}
}
@-webkit-keyframes movehale3 {
	0% {left:65.93%; -webkit-animation-timing-function:ease-out;}
	100% {left:60.93%; -webkit-animation-timing-function:ease-out;}
}
.position3 .sea ul li.whale {animation-name:moveWhale3; animation-duration:1.5s; animation-delay:2s; -webkit-animation-name:moveWhale3; -webkit-animation-duration:1.5s; -webkit-animation-delay:2s;}
@keyframes moveWhale3 {
	0% {top:28%; animation-timing-function:ease;}
	100% {top:32%; animation-timing-function:ease-out;}
}
@-webkit-keyframes moveWhale3 {
	0% {top:28%; -webkit-animation-timing-function:ease;}
	100% {top:32%; -webkit-animation-timing-function:ease-out;}
}
.position3 .sea ul li.shark {animation-name:moveShark3; animation-duration:2s; animation-delay:1s; -webkit-animation-name:moveShark3; -webkit-animation-duration:2s; -webkit-animation-delay:1s;}
@keyframes moveShark3 {
	0% {left:55%; animation-timing-function:linear;}
	100% {left:70%; animation-timing-function:linear;}
}
@-webkit-keyframes moveShark3 {
	0% {left:55%; -webkit-animation-timing-function:linear;}
	100% {left:70%; -webkit-animation-timing-function:linear;}
}

.position4 .sea ul li.dory {top:64.61%; left:66%;}
.position4 .sea ul li.whale {top:38%; left:35%;}
.position4 .sea ul li.shark {top:18%; left:30%;}
.position4 .sea ul li.seaturtleKid {top:18.59%; right:0;}
.position4 .sea ul li.stingray {top:49.55%; left:65.93%;}
.position4 .sea ul li.bluetang {top:31%; left:9.8%;}
.position4 .sea ul li.otter {top:87.07%; right:61%;}
.position4 .sea ul li.seal {top:86.4%; left:65%;}
.position4 .sea ul li.dory {animation-name:moveDory4; animation-duration:1.5s; -webkit-animation-name:moveDory4; -webkit-animation-duration:1.5s;}
@keyframes moveDory4 {
	0% {top:64.61%; animation-timing-function:ease-out;}
	100% {top:60.61%; animation-timing-function:ease-out;}
}
@-webkit-keyframes moveDory4 {
	0% {top:64.61%; -webkit-animation-timing-function:ease-out;}
	100% {top:60.61%; -webkit-animation-timing-function:ease-out;}
}
.position4 .sea ul li.shark {animation-name:moveShark4; animation-duration:1.5s; -webkit-animation-name:moveShark4; -webkit-animation-duration:1.5s;}
@keyframes moveShark4 {
	0% {left:30%; animation-timing-function:ease-out;}
	100% {left:20%; animation-timing-function:ease-out;}
}
@-webkit-keyframes moveShark4 {
	0% {left:30%; -webkit-animation-timing-function:ease-out;}
	100% {left:20%; -webkit-animation-timing-function:ease-out;}
}
.position4 .sea ul li.seaturtle {animation-name:moveSeaturtle; animation-duration:3s; animation-delay:2s; -webkit-animation-name:moveSeaturtle; -webkit-animation-duration:3s; -webkit-animation-delay:2s;}
.position4 .sea ul li.whale {animation-name:moveWhale4; animation-duration:1.5s;}
@keyframes moveWhale4 {
	0% {top:34%; left:35%; animation-timing-function:ease-out;}
	100% {top:38%; left:30%; animation-timing-function:ease-out;}
}
@-webkit-keyframes moveWhale4 {
	0% {top:34%; left:35%; -webkit-animation-timing-function:ease-out;}
	100% {top:38%; left:30%; -webkit-animation-timing-function:ease-out;}
}

.position5 .sea ul li.dory {top:28%; left:59%;}
.position5 .sea ul li.clownfish {top:20%; left:75%;}
.position5 .sea ul li.seaturtleKid {top:48%; right:0;}
.position5 .sea ul li.whale {top:30%;}
.position5 .sea ul li.shark {top:40%; left:55%;}
.position5 .sea ul li.stingray {top:19.48%; left:9.8%;}
.position5 .sea ul li.bluetang {top:61%; left:6%;}
.position5 .sea ul li.octopus {top:87%; left:-2%;}
.position5 .sea ul li.otter {top:64.61%; right:28%; z-index:5;}
.position5 .sea ul li.seal {top:86.4%; left:65%;}

.position5 .sea ul li.dory {animation-name:moveDory5; animation-duration:2s; -webkit-animation-name:moveDory5; -webkit-animation-duration:2s;}
@keyframes moveDory5 {
	0% {left:59%; animation-timing-function:linear;}
	100% {left:63%; animation-timing-function:linear;}
}
@-webkit-keyframes moveDory5 {
	0% {left:59%; animation-timing-function:linear;}
	100% {left:63%; animation-timing-function:linear;}
}
.position5 .sea ul li.stingray {animation-name:moveStingray5; animation-duration:2s; -webkit-animation-name:moveStingray5; -webkit-animation-duration:2s;}
@keyframes moveStingray5 {
	0% {top:15%; left:15%; animation-timing-function:ease;}
	100% {top:19.48%; left:9.8%; animation-timing-function:ease-out;}
}
@-webkit-keyframes moveStingray5 {
	0% {top:15%; left:15%; animation-timing-function:ease;}
	100% {top:19.48%; left:9.8%; animation-timing-function:ease-out;}
}
.position5 .sea ul li.clownfish {animation-name:moveClownfish5; animation-duration:1.5s; animation-delay:2s; -webkit-animation-name:moveClownfish5; -webkit-animation-duration:1.5s; -webkit-animation-delay:2s;}
@keyframes moveClownfish5 {
	0% {top:20%; left:75%; animation-timing-function:linear;}
	100% {top:15%; left:80%; animation-timing-function:linear;}
}
@-webkit-keyframes moveClownfish5 {
	0% {top:20%; left:75%; animation-timing-function:linear;}
	100% {top:15%; left:80%; animation-timing-function:linear;}
}
.position5 .sea ul li.seaturtleKid {animation-name:moveSeaturtleKid5; animation-duration:2.5s; -webkit-animation-name:moveSeaturtleKid5; -webkit-animation-duration:2.5s;}
@keyframes moveSeaturtleKid5 {
	0% {top:48%; right:0; animation-timing-function:ease-out;}
	100% {top:45%; right:-20%; animation-timing-function:ease-out;}
}
@-webkit-keyframes moveSeaturtleKid5 {
	0% {top:48%; right:0; animation-timing-function:ease-out;}
	100% {top:45%; right:-20%; animation-timing-function:ease-out;}
}

.find .win {position:absolute; bottom:6.9%; left:50%; width:60.15%; margin-left:-30.075%; text-align:center;}
.find .win p {position:absolute; top:0; left:0; width:100%; padding:7% 1% 0; color:#2d2d2d; font-size:1rem; font-weight:bold; line-height:1.8em; letter-spacing:-0.05em;}
.find .win p span {color:#0b27b5;}

.lyWin {display:none; position:absolute; top:5%; left:50%; z-index:30; width:73.75%; margin-left:-36.875%;}
.lyWin .btnClose {position:absolute; top:0.5%; right:2%; width:16.94%;}
#dimmed {display:none; position:absolute; top:0; left:0; z-index:20; width:100%; height:100%; background:rgba(0,0,0,.6);}

#gift .app {display:none;}
.gift {position:relative;}
.gift ul {overflow:hidden; position:absolute; top:0; left:0; width:100%; padding:0 6%;}
.gift ul li {float:left; width:50%; margin-bottom:7%;}
.gift ul li:first-child {margin-left:50%;}
.gift ul li a {display:block; height:80%; margin:0 5%; /*background-color:#000; opacity:0.2;*/}
</style>
<script type="text/javascript">
$(function(){
	/* swipe */
	mySwiperMovie = new Swiper('#rollingMovie .swiper1',{
		loop:true,
		autoplay:false,
		speed:800,
		pagination:"#rollingMovie .pagination",
		paginationClickable:true,
		nextButton:'#rollingMovie .btn-next',
		prevButton:'#rollingMovie .btn-prev'
	});

	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
			$("#gift .app").show();
			$("#gift .mo").hide();
	}else{
			$("#gift .app").hide();
			$("#gift .mo").show();
	}

	/* find random position */
	var classes = ["position1", "position2", "position3", "position4", "position5"];
	$("#find").each(function(){
		$(this).addClass(classes[~~(Math.random()*classes.length)]);
	});
});


function btnClose(){
	$("#lyWin").hide();
	$("#dimmed").fadeOut();
}

function NotFindDory(){
	<% If vUserID = "" Then %>
		if ("<%=IsUserLoginOK%>"=="False") {
			<% If isApp = 1 Then %>
				parent.calllogin();
				return false;
			<% Else %>
				parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
				return false;
			<% End If %>
			return false;
		}
	<% Else %>
		alert('앗! 저는 도리가 아니에요!');	
	<% End If %>
}

function checkform(){
	<% If vUserID = "" Then %>
		if ("<%=IsUserLoginOK%>"=="False") {
			<% If isApp = 1 Then %>
				parent.calllogin();
				return false;
			<% Else %>
				parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
				return false;
			<% End If %>
			return false;
		}
	<% End If %>
	<% If vUserID <> "" Then %>
		// 오픈시 바꿔야됨
		<% If Now() >= #06/10/2016 10:00:00# And now() < #06/22/2016 23:59:59# Then %>
			$.ajax({
				type:"GET",
				url:"/event/etc/doEventSubscript71111.asp",
				dataType: "text",
				async:false,
				cache:false,
				success : function(Data, textStatus, jqXHR){
					if (jqXHR.readyState == 4) {
						if (jqXHR.status == 200) {
							if(Data!="") {
								var str;
								for(var i in Data){
									 if(Data.hasOwnProperty(i)){
										str += Data[i];
									}
								}
								str = str.replace("undefined","");
								res = str.split("|");
								if (res[0]=="OK"){
									$("#lyWin").empty().html(res[1]);
									$("#lyWin").show();
									$("#dimmed").show();
									window.$('html,body').animate({scrollTop:100}, 500);
								} else {
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
		<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;				
		<% End If %>
	<% End If %>
}
</script>
<div class="mEvt71111 findingDory">
	<article>
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/tit_finding_dory.png" alt="텐바이텐과 도리를 찾아서 텐바이텢 어드벤쳐" /></h2>

		<section id="find" class="find">
			<div class="sea">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/71111/m/tit_find.jpg" alt="도리를 찾아서 매일매일 터지는 도리의 선물~! 이벤트 페이지에서 숨은 도리를 찾아 클릭해주세요! 선물이 짜잔~ 찾아갑니다." /></h3>
				<ul>
					<li class="clownfish"><button type="button" onclick="NotFindDory();"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71111/img_find_clown_fish.png" alt="니모 부자" /></button></li>
					<li class="seaturtle"><button type="button" onclick="NotFindDory();"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71111/img_find_sea_turtle.png" alt="바다거북" /></button></li>
					<li class="seaturtleKid"><button type="button" onclick="NotFindDory();"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71111/img_find_sea_turtle_kid.png" alt="아기 바다 거북" /></button></li>
					<li class="shark"><button type="button" onclick="NotFindDory();"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71111/img_find_shark.png" alt="상어" /></button></li>
					<li class="whale"><button type="button" onclick="NotFindDory();"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71111/img_find_whale.png" alt="고래" /></button></li>
					<li class="stingray"><button type="button" onclick="NotFindDory();"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71111/img_find_stingray.png" alt="가오리" /></button></li>
					<li class="bluetang"><button type="button" onclick="NotFindDory();"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71111/img_find_blue_tang.png" alt="불루탱" /></button></li>
					<li class="dory"><button type="button" onclick="checkform();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71111/img_find_dory.png" alt="도리" /></button></li>
					<li class="otter"><button type="button" onclick="NotFindDory();"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71111/img_find_otter.png" alt="수달" /></button></li>
					<li class="octopus"><button type="button" onclick="NotFindDory();"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71111/img_find_octopus.png" alt="문어" /></button></li>
					<li class="seal"><button type="button" onclick="NotFindDory();"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71111/img_find_seal.png" alt="물개" /></button></li>
				</ul>
			<% If winItemChk <> "" Then %>
			<%
				Select Case winItemChk
					Case "11111"		winItemStr = "시사회 초대권"
					Case "22222"		winItemStr = "트럼프 카드"
					Case "33333"		winItemStr = "아이폰6 케이스"
				End Select
			%>
				<div class="win">
					<p>
						<span><%= vUserID %></span>님은 <span><%= winItemStr %></span>에<br /> 당첨되셨습니다. (당첨일: <span>6</span>월 <span>15</span>일) <br />※ 무료배송쿠폰은 마이텐바이텐에서 확인
					</p>
					<img src="http://webimage.10x10.co.kr/eventIMG/2016/71111/m/bg_sign.png" alt="" />
				</div>
			<% End If %>
			</div>

			<%' for dev msg : 레이어 팝업 %>
			<div id="lyWin" class="lyWin" style="display:none"></div>

			<div id="gift" class="gift">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/71111/m/txt_gift_v1.jpg" alt="숨은 도리를 찾아서 이벤트에 참여해주신 분께 텐바이텐 전용관 시사외 초대권 2매를 150분께, 도리를 찾아서 트럼프 카드 1개를 30분께, 도리를 찾아서 아이폰 케이스 1개를 30분께 컬러는 랜덤이며, 참여자 전원께 텐바이텐 무료배송 쿠폰을 드립니다." /></p>
				<ul class="mo">
					<li><a href="/category/category_itemPrd.asp?itemid=1507612&amp;pEtr=71111"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71111/m/img_item_white.png" alt="Finding Dory Playing cards" /></a></li>
					<li><a href="eventmain.asp?eventid=71112"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71111/m/img_item_white.png" alt="도리를 찾아서 MD 상품 런칭 이벤트 보러 가기" /></a></li>
					<li><a href="/my10x10/couponbook.asp"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71111/m/img_item_white.png" alt="텐텐 배송을 찾아서" /></a></li>
				</ul>
				<ul class="app">
					<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1507612&amp;pEtr=71111" onclick="fnAPPpopupProduct('1507612&amp;pEtr=71111');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71111/m/img_item_white.png" alt="Finding Dory Playing cards" /></a></li>
					<li><a href="eventmain.asp?eventid=71112"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71111/m/img_item_white.png" alt="도리를 찾아서 MD 상품 런칭 이벤트 보러 가기" /></a></li>
					<li><a href="" onclick="fnAPPpopupBrowserURL('마이텐바이텐','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71111/m/img_item_white.png" alt="텐텐 배송을 찾아서" /></a></li>
				</ul>
			</div>
		</section>
		
		<section class="noti">
			<h3><strong>이벤트 유의사항</strong></h3>
			<ul>
				<li>텐바이텐 회원님을 위한 이벤트 입니다. (비회원 참여 불가)</li>
				<li>로그인 후 응모하실 수 있습니다.</li>
				<li>한 ID당 하루에 한 번만 참여할 수 있습니다.</li>
				<li>당첨자 안내는 2016년 6월 24일 홈페이지에서 공지됩니다.</li>
				<li>이벤트 경품은 내부 사정에 의해 변경될 수 있습니다.</li>
				<li>당첨자와 수령자는 동일해야 하며, 양도는 불가합니다.</li>
				<li>정확한 발표를 위해 개인정보를 업데이트 해주세요.</li>
				<li>이벤트 종료 후 경품 변경은 불가 합니다.</li>
				<li><b style="font-weight:bold;">시사회 일정은 2016년 7월 2일 (토) 3시이며, 롯데시네마 월드타워점에서 진행됩니다.</b></li>
			</ul>
		</section>

		<section class="intro">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/tit_intro.png" alt="도리를 찾아서 2016년 7월 7일 개봉" /></h3>
			<div id="rollingMovie" class="rolling">
				<div class="swiper">
					<div class="swiper-container swiper1">
						<div class="swiper-wrapper">
							<div class="swiper-slide">
								<div class="video">
									<iframe src="http://serviceapi.rmcnmv.naver.com/flash/outKeyPlayer.nhn?vid=776B75C9F93DD7C13D1FE75DA69B38681D3C&outKey=V128342fa5823e4a2d0a3994d9e29bba102c37f54388cb6d2c188994d9e29bba102c3&controlBarMovable=true&jsCallable=true&isAutoPlay=false&skinName=tvcast_white" frameborder="0" title="도리를 찾아서 예고편" allowfullscreen></iframe>
								</div>
								<div class="mask mask-top"></div>
								<div class="mask mask-btm"></div>
							</div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/img_slide_movie_02.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/img_slide_movie_03.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/img_slide_movie_04.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/img_slide_movie_05.jpg" alt="도리를 찾아서! 내가 누구라고? 도리? 도리! 무엇을 상상하든 그 이상을 까먹는 도리의 어드벤쳐가 시작된다! 니모를 함께 찾으면서 베스트 프렌드가 된 도리와 말린은 우여곡절 끝에 다시 고향으로 돌아가 평화로운 일상을 보내고 있다. 모태 건망증 도리가 기억이라는 것을 하기 전까지! 도리는 깊은 기억 속에 숨어 있던 가족의 존재를 떠올리고 니모와 말린과 함께 가족을 찾아 대책 없는 어드벤쳐를 떠나게 되는데… 깊은 바다도 막을 수 없는 스펙터클한 어드벤쳐가 펼쳐진다!" /></div>
						</div>
					</div>
					<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/btn_prev.png" alt="이전" /></button>
					<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/btn_next.png" alt="다음" /></button>
					<div class="pagination"></div>
				</div>
			</div>
		</section>

		<section class="sns">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/tit_sns.png" alt="도리를 찾아서 이벤트! 친구에게도 놀라운 사실을 알려주자!" /></h3>
			<ul>
				<li class="facebook"><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');return false;"><span></span>페이스북으로 공유하기</a></li>
				<li class="twitter"><a href="" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');return false;"><span></span>트위터로 공유하기</a></li>
				<li class="kakao"><a href="" onclick="parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>');return false;"><span></span>카카오톡으로 공유하기</a></li>
			</ul>
		</section>

		<div class="bnr">
			<ul>
				<!--li><a href="/event/eventmain.asp?eventid=71110"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/img_bnr_71110.jpg" alt="구매 사은 이벤트 선물은 비치볼" /></a></li-->
				<li><a href="eventmain.asp?eventid=71112"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/img_bnr_71112.jpg" alt="텐바이텐과 디즈니 굿즈 런칭 도리를 내 품에!" /></a></li>
			</ul>
		</div>
		<div id="dimmed"></div>
	</article>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->