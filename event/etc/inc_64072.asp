<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
'#######################################################
'	History	: 2015.06.26 유태욱 생성
'	Description : (초)능력자들-M
'#######################################################

	Dim DayName, evtimagenum, eCode, userid, nowdate
	Dim sqlstr, cnt
	dim tempcnt

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  63802
	Else
		eCode   =  64072
	End If
	
	nowdate = now()
'	nowdate = "2015-07-06 10:00:00"

	dim LoginUserid
	LoginUserid = getLoginUserid()

	''1주차,2주차 구분
	If left(nowdate,10)<"2015-07-06" Then
		DayName = "01"
	else
		DayName = "02"
	end if

	''5일치 구분(1주차5일,2주차5일)
	If left(nowdate,10)<"2015-06-30" or left(nowdate,10)="2015-07-06" Then
		evtimagenum	=	"01"
	elseif left(nowdate,10)="2015-06-30" or left(nowdate,10)="2015-07-07" Then
		evtimagenum	=	"02"
	elseif left(nowdate,10)="2015-07-01" or left(nowdate,10)="2015-07-08" Then
		evtimagenum	=	"03"
	elseif left(nowdate,10)="2015-07-02" or left(nowdate,10)="2015-07-09" Then
		evtimagenum	=	"04"
	elseif left(nowdate,10)="2015-07-03"  or left(nowdate,10)="2015-07-04" or left(nowdate,10)="2015-07-05" or left(nowdate,10)>="2015-07-10" Then
		evtimagenum	=	"05"
	end if

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "[텐바이텐] (초)능력자들\n당신의 더위를 우주로 날려 보낼\n초능력을 갖고 텐바이텐이\n돌아왔습니다.\n\n손가락을 올려보세요!\n하루 3,000명에게 초능력을 가져다 줄\n놀라운 선물이 당신을 찾아갑니다.!\n\n지금 도전하세요!\n오직 텐바이텐 APP에서!"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2015/64071/img_kakao.png"
	Dim kakaoimg_width : kakaoimg_width = "200"
	Dim kakaoimg_height : kakaoimg_height = "200"
	Dim kakaolink_url
		If isapp = "1" Then '앱일경우
			kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=64071"
		Else '앱이 아닐경우
			'kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid=64072"
			kakaolink_url = "http://m.10x10.co.kr/apps/link/?7620150626"
		end if

	'// 남은 티켓 수량
	sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' And sub_opt2<>0"
	rsget.Open sqlstr, dbget, 1
		cnt = rsget(0)
	rsget.close
'	cnt=3000

	if left(nowdate,10)="2015-07-06" then
		tempcnt=2991
	else
		tempcnt=3000
	end if
%>
<style type="text/css">
img {vertical-align:top;}

.topic p {visibility:hidden; width:0; height:0;}

.item {position:relative;}
.item .soldout {position:absolute; top:0; left:0; width:100%;}

.fingerprint {position:relative;}
.fingerprint .btnapp {position:absolute; bottom:7%; left:50%; width:75.4%; margin-left:-37.7%;}

.noti {padding:22px 16px;}
.noti h2 {color:#377183; font-size:14px;}
.noti h2 strong {padding-bottom:2px; border-bottom:2px solid #377183;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; margin-top:2px; padding-left:8px; color:#444; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:4px; left:0; width:4px; height:4px; border-radius:50%; background-color:#377183;}

@media all and (min-width:480px){
	.serialnumber strong {font-size:15px;}

	.winner ul li div {font-size:13px;}
	.winner ul li div strong {font-size:16px;}
	.noWinner strong {font-size:18px;}

	.noti {padding:40px 35px;}
	.noti ul {margin-top:16px;}
	.noti h2 {font-size:17px;}
	.noti ul li {margin-top:4px; padding-left:12px; font-size:13px;}
	.noti ul li:after {top:5px; width:5px; height:5px;}
}

@media all and (min-width:600px){
	.serialnumber {bottom:1.8%;}
	.serialnumber strong {font-size:16px;}

	.winner ul li div {font-size:18px;}
	.winner ul li div strong {font-size:22px;}
	.noWinner strong {font-size:24px;}

	.noti h2 {font-size:20px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:6px; padding-left:20px; font-size:16px;}
	.noti ul li:after {top:9px;}
}

@media all and (min-width:768px){
	.noWinner strong {font-size:36px;}
	.winner ul li div {font-size:20px;}
	.winner ul li div strong {font-size:24px;}
}
</style>
<script language="javascript">
<!--
	var userAgent = navigator.userAgent.toLowerCase();
	function gotoDownload(){
		parent.top.location.href='http://m.10x10.co.kr/apps/link/?7620150626';
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

	function evtsub(){
		alert('텐바이텐 앱에서만 참여가 가능합니다!');
	}
</script>
	<!-- [모바일전용] 초능력자들 -->
	<div class="mEvt64071">
		<%'' for dev msg : 이미지 폴더 6/29~7/5까지는 /01/ 폴더, 7/6~7/10까지는 /02/ 폴더입니다. %>
		<section>
			<div class="topic">
				<h1><img src="http://webimage.10x10.co.kr/eventIMG/2015/64071/<%=DayName%>/tit_super_hamans.png" alt="더위를 우주로 날려보내는 초능력자들" /></h1>
				<p>손가락을 올려보세요! 초능력을 가져다 줄 선물이 당신을 찾아갑니다! 이벤트 기간은 6월 29일부터 7월 10일까지 진행됩니다.</p>
			</div>

			<div class="item">
				<%'' for dev msg :  6/29~7/3일까지 상품 img_today_item_01~05까지입니다. %>
				<div>
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/64071/<%=DayName%>/img_today_item_<%=evtimagenum%>.jpg" alt="오늘의 초능력자 공중부양 삼천명!" />
				</div>
				<%'' for dev msg : 솔드아웃  %>
				<% if cnt >= tempcnt then %>
					<% If left(nowdate,10) > "2015-07-05" and left(nowdate,10) < "2015-07-10" or left(nowdate,10) < "2015-07-03" then %>
						<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64071/01/txt_solid_out.png" alt="SOLD OUT 초능력을 가져다 줄 선물이 매진되었습니다. 오전 12시를 기다려주세요!" /></p>
					<% elseif left(nowdate,10) > "2015-07-02" and left(nowdate,10) < "2015-07-06" then %>
						<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64071/01/txt_solid_out_weekend.png" alt="SOLD OUT 초능력을 가져다 줄 선물이 매진 되었습니다. 다음주 월요일 오전 10시를 기다려주세요!" /></p>
					<% elseif left(nowdate,10) > "2015-07-09" then %>
						<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64071/01/txt_end.png" alt="THE END 재밌는 이벤트로 기억되고 싶습니다. 참여해주신 모든 분들께 감사드립니다" /></p>
					<% end if %>
				<% end if %>
			</div>

			<%''  지문인식 %>
			<div class="fingerprint">
				<p onclick="evtsub();"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_fingerprint.png" alt="화면을 터치 후, 초능력을 확인하세요!" /></p>
				<%''  for dev msg : 앱으로 가기 %>
				<a href="" onclick="gotoDownload();return false;" class="btnapp"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64072/02/btn_app.png" alt="텐바이텐 앱으로 가기" /></a>
			</div>

			<%''   for dev msg : 카카오톡 %>
			<div class="kakao">
				<a href="" onclick="parent.parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>'); return false;" id="kakao-link-btn" title="카카오톡으로 초능력자들 알려주기"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64072/01/btn_kakao.png" alt="친구와 능력자들 함께하기! 친구에게 능력자들을 알려주고, 놀라운 선물에 함께 도전해 보세요" /></a>
			</div>

			<div class="noti">
				<h2><strong>이벤트 유의사항</strong></h2>
				<ul>
					<li>본 이벤트는 텐바이텐 app에서만 참여 가능합니다.</li>
					<li>본 이벤트는 ID당 1일 1회만 응모가능하며, 친구 초대 시 한 번 더 응모기회가 주어집니다.</li>
					<li>5만원 이상의 상품을 받으신 분께는 세무신고를 위해 개인정보를 요청할 수 있습니다. 제세공과금은 텐바이텐 부담입니다.</li>
					<li>본 이벤트의 1등 상품에 대한 제세공과금은 고객부담입니다.</li>
					<li>무료배송쿠폰은 ID당 하루에 최대 2회까지 발행되며, 발급 당일 자정 기준으로 자동 소멸됩니다. (1만원 이상 구매 시 사용 가능)</li>
					<li>당첨된 고객께는 마이텐바이텐에 기재된 연락처로 익일 당첨안내 문자가 전송될 예정이며, 연락처 변경 혹은 미 기입시 당첨이 취소될 수 있습니다.</li>
					<li>당첨된 상품은 기본정보에 입력된 주소로 발송됩니다! 마이텐바이텐에서 당첨안내를 확인해주세요.</li>
					<li>당첨된 기프티콘은 익일 발송됩니다! 마이텐바이텐에서 연락처를 확인해주세요.</li>
					<li>이벤트 내 모든 상품의 컬러는 랜덤으로 발송되며, 선택이 불가능합니다.</li>
					<li>본 이벤트는 주말(토, 일)에는 진행되지 않습니다.</li>
				</ul>
			</div>
			<div class="mask"></div>
		</section>
	</div>

<script type="text/javascript">
$(function(){
	$(".btnFingerprint").click(function(){
		$("#rtp").show();
		$(".mask").show();
	});

	$(".btnNext").click(function(){
		$("#lyPreview").show();
		$(".mask").show();
	});

	/* layer */
	$(".mask, #rtp .btnclose").click(function(){
		$("#rtp").hide();
		$(".mask").hide();
	});

	$(".mask, #lyPreview .btnclose").click(function(){
		$("#lyPreview").hide();
		$(".mask").hide();
	});

	$("#winner ul li").hide();
	$("#winner ul li:first").show();
	$("#winner ul li:first").addClass("first");

	if ($("#winner ul li").length > 1) {
		$("#winner .btnmore").click(function(){
			$("#winner .btnmore").hide();
			$("#winner ul li:first").removeClass("first");
			$("#winner ul li").slideDown();
			$("#winner .btnlast").show();
		});

		$("#winner .btnlast").click(function(){
			$("#winner .btnlast").hide();
			$("#winner ul li:first").addClass("first");
			$("#winner ul li").hide();
			$("#winner ul li:first").show();
			$("#winner .btnmore").show();
		});
	} else {
		$("#winner .btnmore").hide();
	}
	
});
</script>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->