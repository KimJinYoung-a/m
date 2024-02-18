<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
	'####################################################
	'### 티켓킹-모바일
	'### 2015-05-29 유태욱
	'####################################################

	Dim DayName, cnt, realcnt, evtimagenum
	Dim eCode, vDisp, sqlstr, mycouponkey, mygienee, totalcnt
	Dim userid
	Dim nowdate

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  63772
	Else
		eCode   =  62985
	End If
	
	nowdate = now()
'	nowdate = "2015-06-01 10:00:00"

	dim LoginUserid
	LoginUserid = getLoginUserid()

	''1주차,2주차 구분
	If left(nowdate,10)<"2015-06-06" Then
		DayName = "mon_01"
	else
		DayName = "mon_02"
	end if

	''5일치 구분(1주차5일,2주차5일)
	If left(nowdate,10)<"2015-06-02" or left(nowdate,10)="2015-06-06" or left(nowdate,10)="2015-06-07" or left(nowdate,10)="2015-06-08" Then
		evtimagenum	=	"01"
	elseif left(nowdate,10)="2015-06-02" or left(nowdate,10)="2015-06-09" Then
		evtimagenum	=	"02"
	elseif left(nowdate,10)="2015-06-03" or left(nowdate,10)="2015-06-10" Then
		evtimagenum	=	"03"
	elseif left(nowdate,10)="2015-06-04" or left(nowdate,10)="2015-06-11" Then
		evtimagenum	=	"04"
	elseif left(nowdate,10)="2015-06-05" or left(nowdate,10)>="2015-06-12" Then
		evtimagenum	=	"05"
	end if


	'// 남은 티켓 수량(기프트카드 제외)
	sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' And sub_opt2<>0 And sub_opt2<>'5555555'"
	rsget.Open sqlstr, dbget, 1
		cnt = rsget(0)
	rsget.close
	realcnt = 3000-Cint(cnt)
	
	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "[텐바이텐] 티켓킹!\n당신의 여름휴가를 도와드릴\n놀라운 선물을 갖고 텐바이텐이\n돌아왔습니다.\n하루 3,000명 티켓만 잘 뽑아도\n놀라운 선물이 당신을 찾아갑니다!\n지금 도전하세요!\n오직 텐바이텐 APP에서!"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2015/62985/img_ticket_king_kakao.gif"
	Dim kakaoimg_width : kakaoimg_width = "200"
	Dim kakaoimg_height : kakaoimg_height = "200"
	Dim kakaolink_url
		If isapp = "1" Then '앱일경우
			kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=62985"
		Else '앱이 아닐경우
			kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid=62986"
		end if
%>
<style type="text/css">
img {vertical-align:top;}
.topic p {visibility:hidden; width:0; height:0;}

.ticket {position:relative;}
.ticket .soldout {position:absolute; top:0; left:0; z-index:10; width:100%;}
.booth {position:relative;}
.booth strong {position:absolute; top:36%; left:0; width:100%; text-align:center; color:#222d38; font-size:60px; line-height:60px;}
.ticket .btnapp {position:absolute; bottom:11%; left:50%; width:78%; margin-left:-39%; background-color:transparent;}
.ticket .btnnext {position:absolute; bottom:7.5%; left:50%; width:45.4%; margin-left:-22.7%;}
.ticket em {display:none; position:absolute; top:21.1%; right:16%; width:20.8%;}

.noti {padding:25px 25px 25px 10px; background-color:#f4f7f7;}
.noti h2 {color:#29a19e; font-size:14px;}
.noti h2 strong {padding-bottom:2px; border-bottom:2px solid #4fc1be;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; margin-top:2px; padding-left:10px; color:#444; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:5px; left:0; width:4px; height:4px; border-radius:50%; background-color:#4fc1be;}

.animated {-webkit-animation-duration:5s; animation-duration:5s; -webkit-animation-fill-mode:both; animation-fill-mode:both; -webkit-animation-iteration-count:infinite;animation-iteration-count:infinite;}
/* flash animation */
@-webkit-keyframes flash {
	0% {opacity:0;}
	100% {opacity:1;}
}
@keyframes flash {
	0% {opacity:0;}
	100% {opacity:1;}
}
.flash {-webkit-animation-duration:1s; animation-duration:1s; -webkit-animation-name:flash; animation-name:flash; -webkit-animation-iteration-count:infinite; animation-iteration-count:infinite;}

@media all and (min-width:480px){
	.booth strong {font-size:85px; line-height:85px;}
	.noti {padding:25px 15px;}
	.noti ul {margin-top:16px;}
	.noti h2 {font-size:17px;}
	.noti ul li {margin-top:4px; font-size:13px;}
}

@media all and (min-width:600px){
	.booth strong {font-size:96px; line-height:96px;}
	.noti h2 {font-size:20px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:6px; font-size:16px;}
	.noti ul li:after {top:9px;}
}

@media all and (min-width:768px){
	.booth strong {font-size:120px; line-height:120px;}
	.winner ul li div {font-size:20px;}
	.winner ul li div strong {font-size:24px;}
}
</style>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script language="javascript">
<!--
	var userAgent = navigator.userAgent.toLowerCase();
	function gotoDownload(){
		parent.top.location.href='http://m.10x10.co.kr/apps/link/?7220150529';
		return false;
	};

	$(function(){
		var chkapp = navigator.userAgent.match('tenapp');
		if ( chkapp ){
			$("#mo").hide();
		}else{
			$("#mo").show();
		}
	});
//-->
</script>
</head>
<body>
<!-- [M] 티켓 KING -->
<div class="mEvt62986">
	<div class="topic">
		<% If left(nowdate,10)<"2015-06-06" Then %>
			<h1><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/01/tit_ticket_king.png" alt="텐아비텐 여름 휴가 지원 프로젝트 티켓킹!" /></h1>
		<% else %>
			<h1><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/02/tit_ticket_king.png" alt="텐아비텐 여름 휴가 지원 프로젝트 티켓킹!" /></h1>
		<% end if %>
		<p>티켓을 뽑아보세요! 하루에 3,000명! 여름휴가를 도와드릴 놀라운 선물이 찾아갑니다! 이벤트 기간은 6월 1일부터 6월 12일까지 입니다.</p>
	</div>

	<div class="place">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/img_place_<%=DayName%>_<%=evtimagenum%>v1.jpg" alt="오늘의 휴가지 니뽕! 일본 여행상품권 백만원 및 에다스 25형 수화물용 캐리어, 에어프레임 도쿄, 포카리스웨트 캔 250ml" /></p>
																	 
	</div>

	<div class="ticket">
		<p class="booth">
			<% If left(nowdate,10)<"2015-06-06" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/01/txt_welcome_v1.png" alt="어서 오세요, 고객님! 티켓을 발급받고, 당첨을 확인해 보세요." />
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/62986/01/img_booth.png" alt="" />
			<% else %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/02/txt_welcome.png" alt="어서 오세요, 고객님! 티켓을 발급받고, 당첨을 확인해 보세요." />
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/62986/02/img_booth.png" alt="" />
			<% end if %>
			<strong title="남은 티켓수량"><%= realcnt %></strong>
			<% if realcnt <= 500 then %>
				<em class="animated flash" style="display:block;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/ico_neart_soldout.png" alt="매진 임박" /></em>
			<% end if %>
		</p>

		<% if left(nowdate,10)>="2015-06-05" and left(nowdate,10)<"2015-06-08" then %>
			<% If cnt >= 3000 then %>
				<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/txt_soldout_weekend.png" alt="오늘의 티켓이 매진 되었습니다. 다음주 월요일, 새로운 휴가지가 찾아옵니다." /></p>
			<% end if %>
		<% else %>
			<% If cnt >= 3000 then %>
				<p class="soldout" style="display:none;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/txt_soldout.png" alt="오늘의 티켓이 매진 되었습니다. 오전 12시, 새로운 휴가지가 찾아옵니다." /></p>
			<% end if %>
		<% end if %>

		<!-- for dev msg : 텐바이텐 앱으로 가기 -->
		<a href="" onclick="gotoDownload();return false;" class="btnapp"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62986/btn_app.png" alt="텐바이텐 앱으로 가기" /></a>
	</div>

	<!-- for dev msg : 카카오톡 -->
	<!-- for dev msg : 이미지 변경 -->
	<div class="kakao">
		<% If left(nowdate,10)<"2015-06-06" Then %>
			<a href="" onclick="parent.parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>'); return false;" id="kakao-link-btn" title="카카오톡으로 티켓킹 알려주기"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62986/01/btn_kakao_v1.png" alt="친구와 티켓킹 함께하기! 친구에세 티켓킹을 알려주고, 놀라운 선물에 함께 도전해 보세요!" /></a>
		<% else %>
			<a href="" onclick="parent.parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>'); return false;" id="kakao-link-btn" title="카카오톡으로 티켓킹 알려주기"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62986/02/btn_kakao.png" alt="친구와 티켓킹 함께하기! 친구에세 티켓킹을 알려주고, 놀라운 선물에 함께 도전해 보세요!" /></a>
		<% end if %>
	</div>

	<div class="noti">
		<h2><strong>이벤트 주의사항</strong></h2>
		<ul>
			<li> 본 이벤트는 텐바이텐 app에서만 참여 가능합니다.</li>
			<li> 본 이벤트는 ID당 1회만 응모가능하며, 친구 초대 시 한 번 더 응모기회가 주어집니다.</li>
			<li> 5만원 이상의 상품을 받으신 분께는 세무신고를 위해 개인정보를 요청할 수 있습니다. 제세공과금은 텐바이텐 부담입니다.</li>
			<li> 본 이벤트의 1등 상품에 대한 제세공과금은 고객부담입니다.</li>
			<li> 무료배송쿠폰은 ID당 하루에 최대 2회까지 발행되며, 발급 당일 자정 기준으로 자동 소멸됩니다.(1만원 이상 구매 시 사용 가능)</li>
			<li> 당첨된 고객께는 익일 당첨안내 문자가 전송될 예정입니다.</li>
			<li> 당첨된 상품은 당첨안내 확인 후에 발송됩니다! 마이텐바이텐에서 당첨안내를 확인해주세요.</li>
			<li> 당첨된 기프티콘은 익일 오후 1시에 발송됩니다! 마이텐바이텐에서 연락처를 확인해주세요.</li>
			<li> 이벤트 내 모든 상품의 컬러는 랜덤으로 발송되며, 선택이 불가능합니다.</li>
			<li> 본 이벤트의 1등 당첨자는 금일 2~4등 당첨자 중 추첨을 통해 익일 발표합니다.공지사항을 확인해주세요.</li>
			<li> 본 이벤트는 주말(토,일)에는 진행되지 않습니다.</li>
		</ul>
	</div>
	<div class="bnr" style="padding-top:2.5%;">
		<a href="/event/eventmain.asp?eventid=63082" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/img_bnr.png" alt="쿨 썸머 오감꽁꽁 프로젝트 보러가기" /></a>
	</div>
	<div class="mask"></div>
</div>
<!-- //티켓 KING -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->