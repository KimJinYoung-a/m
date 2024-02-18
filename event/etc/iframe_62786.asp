<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	History	: 2015.05.20 유태욱 생성
'	Description : 푸드파이터
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%

	Dim nowdate, LoginUserid, eCode, result1, result2, result3
	Dim sqlstr

	nowdate = now()
'	nowdate = "2015-05-21 10:00:00"
	LoginUserid = getLoginUserid()

	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "62771"
	Else
		eCode 		= "62786"
	End If

	'// 응모내역 검색
	sqlstr = "select top 1 sub_opt1, sub_opt2, sub_opt3 "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
	rsget.Open sqlstr, dbget, 1
	If Not(rsget.bof Or rsget.Eof) Then
		result1 = rsget(0) '//응모여부(1-응모)
		result2 = rsget(0) '//라운드여부(1,2,3)
		result3 = rsget(0) '//선택여부(1,2)
	End IF
	rsget.close

%>

<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.mEvt62786 {position:relative;}
.foodFighter .round1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/62786/bg_purple.gif);}
.foodFighter .round2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/62786/bg_blue.gif);}
.foodFighter .round3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/62786/bg_green.gif);}
.foodFighter .todayFood {padding:0 2.5%; background-position:0 0; background-repeat:no-repeat; background-size:100% auto;}
.foodFighter .round1 .todayFood {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/62786/bg_slash_purple.gif);}
.foodFighter .round2 .todayFood  {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/62786/bg_slash_blue.gif);}
.foodFighter .round3 .todayFood  {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/62786/bg_slash_green.gif);}
.foodFighter .selectFood {overflow:hidden; width:95%; padding-bottom:2%; margin:0 auto;}
.foodFighter .selectFood .cadidate {position:relative; float:left; width:50%;}
.foodFighter .selectFood .selectBtn {display:block; position:absolute; left:29%; bottom:7%; width:42%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/62786/btn_select_off.png) 0 0 no-repeat; background-color:transparent; background-size:100% 100%; z-index:30;}
.foodFighter .selectFood .selectBtn.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/62786/btn_select_on.png);}
.foodFighter .selectFood {background-position:0 0; background-repeat:repeat-y; background-size:100% auto;}
.foodFighter .btnVote input {width:100%;}
.foodLayer {position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.7); z-index:40;}
.foodLayer .viewResult {position:absolute; left:5%; top:10px; width:90%; z-index:50;}
.foodLayer .viewResult .btnChkPhone,
.foodLayer .viewResult .btnClose {display:block; position:absolute; background-color:transparent; color:transparent;}
.foodLayer .viewResult .btnChkPhone {left:22%; bottom:27.5%; width:56%; height:9%;}
.foodLayer .viewResult .btnClose {left:15%; bottom:5.5%; width:70%; height:14%;}
.evtNoti {padding:24px 10px;}
.evtNoti h3 {padding:0 0 12px 10px;}
.evtNoti h3 span {font-size:14px; font-weight:bold; color:#222; border-bottom:2px solid #333;}
.evtNoti li {position:relative; padding:0 0 4px 10px; color:#444; font-size:11px; line-height:1.3;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:4px; width:3px; height:3px; background:#8c9ace; border-radius:50%;}
@media all and (min-width:480px){
	.evtNoti {padding:36px 15px;}
	.evtNoti h3 {padding:0 0 18px 15px;}
	.evtNoti h3 span {font-size:21px; border-bottom:3px solid #333;}
	.evtNoti li {padding:0 0 6px 15px; font-size:17px;}
	.evtNoti li:after {top:6px; width:5px; height:5px;}
}
</style>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript">
$(function(){
	// layer popup
	$('#foodLayer').hide();
//	$('.btnVote').click(function(){
//		$('#foodLayer').show();
//		window.parent.$('html,body').animate({scrollTop:80}, 300);
//	});
	$('.btnClose').click(function(){
		$('#foodLayer').hide();
	});

	// select food
	$('.selectBtn').click(function(){
		$('.selectBtn').removeClass('on');
		$(this).addClass('on');
	});
	$('.cadidate p').click(function(){
		$('.selectBtn').removeClass('on');
		$(this).next('.selectBtn').addClass('on');
	});

	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		$(".anotherEvt").show();
	}else{
		$(".anotherEvt").hide();
	}
});

function checkform(gubun) {
<% If left(nowdate,10)>="2015-05-21" and left(nowdate,10)<"2015-05-30" Then %>//////////////////////////////////////////////////////////
	<% If IsUserLoginOK Then %>
		<% if result1>0 then %>
			alert('한 아이디당 하루 한번 참여할 수 있습니다.');
			return;
		<% end if %>
			var selectvalue
			if($("#selectBtn1").attr("class") == "selectBtn on"){
				selectvalue = "1";
			}else if ($("#selectBtn2").attr("class") == "selectBtn on"){
				selectvalue = "2";
			}else{
				alert("음식을 선택해 주세요.");
				return false;
			}
			var str = $.ajax({
				type: "GET",
				url: "/event/etc/doeventsubscript/doEventSubscript62786.asp",
				data: "mode=add&gubun="+gubun+"&selectvalue="+selectvalue,
				dataType: "text",
				async: false
			}).responseText;
			if (str==''){
				alert('정상적인 경로가 아닙니다.');
				return;
			}else if (str=='99'){
				alert('정상적인 경로가 아닙니다.');
				return;
			}else if (str=='02'){
				alert('이벤트 응모 기간이 아닙니다.');
				return;
			}else if (str=='03'){
				alert('이벤트가 종료 되었습니다.');
				return;
			}else if (str=='04'){
				alert('로그인을 해주세요.');
				return;
			}else if (str=='05'){
				alert('오늘은 이미 응모 하셨습니다.');
				return;
			}else if (str=='01'){
				$('#foodLayer').show();
				window.parent.$('html,body').animate({scrollTop:70}, 300);
			}else{
				alert('정상적인 경로가 아닙니다');
				return;
			}
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
		alert('이벤트 기간이 아닙니다.');
		return;
<% end if %>
}

function jsmytenbyten(){
	<% if isApp=1 then %>
		parent.fnAPPpopupBrowserURL('마이텐바이텐','<%=wwwUrl%>/<%=appUrlPath%>/my10x10/mymain.asp');
		return false;
	<% else %>
		top.location.href = "/my10x10/mymain.asp";
		return false;
	<% end if %>
}


function kakaosendcall(){
	<% If IsUserLoginOK Then %>
		<% If left(nowdate,10)>="2015-05-24" and left(nowdate,10)<"2015-05-27" Then %>
			parent.parent_kakaolink('[텐바이텐] 푸드파이터!\n친구야! 같이 투표하고 야식 선물받자!\n\n투표한 파이터가 승리하면,\n매일 300명을 추첨해 선물로 드려요!\n\n2 Round : 빙수편\n카페베네 VS 투썸플레이스\n\n오직 텐바이텐 에서만!', 'http://webimage.10x10.co.kr/eventIMG/2015/62786/img_kakao02.jpg' , '200' , '200' , 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=62786' );
			return false;
		<% end if %>
		<% If left(nowdate,10)>="2015-05-27" Then %>
			parent.parent_kakaolink('[텐바이텐] 푸드파이터!\n친구야! 같이 투표하고 야식 선물받자!\n\n투표한 파이터가 승리하면,\n매일 100명을 추첨해 선물로 드려요!\n\n2 Round : 피자편\n미스터피자 VS 도미노피자\n\n오직 텐바이텐 에서만!', 'http://webimage.10x10.co.kr/eventIMG/2015/62786/img_kakao02.jpg' , '200' , '200' , 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=62786' );
			return false;
		<% end if %>
	<% Else %>
		parent.calllogin();
		return;
	<% End If %>
}

</script>
</head>
<body>
	<!-- 푸드 파이터(M/A) -->
	<div class="mEvt62786">
		<div class="foodFighter">
		<% If left(nowdate,10)>="2015-05-20" and left(nowdate,10)<"2015-05-24" Then %>
			<!-- 1라운드(21일~23일) -->
			<div class="match round1">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/62786/tit_food_fighter_round1_v2.png" alt="푸드파이터" /></h2>
				<p class="todayFood"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62786/txt_round1.png" alt="1ROUND 치킨편" /></p>
				<!-- 음식 선택하기 -->
				<div class="selectFood">
					<div class="cadidate">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/62786/txt_round1_candidate1.jpg" alt="지현씨도 반한 그 맛 BHC 뿌링클 치킨" /></p>
						<button id="selectBtn1" class="selectBtn" ><img src="http://webimage.10x10.co.kr/eventIMG/2015/62786/btn_select.png" alt="선택" /></button>
					</div>
					<div class="cadidate">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/62786/txt_round1_candidate2.jpg" alt="격렬하게 먹고 싶다 또래오래 치킨" /></p>
						<button id="selectBtn2" class="selectBtn"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62786/btn_select.png" alt="선택" /></button>
					</div>
				</div>
				<p class="btnVote"><input type="image" onclick="checkform('1'); return fasle;" src="http://webimage.10x10.co.kr/eventIMG/2015/62786/btn_vote_round1.png" alt="투표하기" /></p>
				<!--// 음식 선택하기 -->
			</div>
			<!--// 1라운드 -->
		<% end if %>

		<% If left(nowdate,10)>="2015-05-24" and left(nowdate,10)<"2015-05-27" Then %>
			<!-- 2라운드(24일~26일) -->
			<div class="match round2">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/62786/tit_food_fighter_round2.png" alt="푸드파이터" /></h2>
				<p class="todayFood"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62786/txt_round2.png" alt="2ROUND 빙수편" /></p>
				<!-- 음식 선택하기 -->
				<div class="selectFood">
					<div class="cadidate">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/62786/txt_round2_candidate1.jpg" alt="빙수에 모든걸 걸었다 카페베네 딸기빙수" /></p>
						<button id="selectBtn1" class="selectBtn"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62786/btn_select.png" alt="선택" /></button>
					</div>
					<div class="cadidate">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/62786/txt_round2_candidate2.jpg" alt="혀 끝에서 망고가 춤을! 투썸 플레이스 망고치즈케익크빙수" /></p>
						<button id="selectBtn2" class="selectBtn"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62786/btn_select.png" alt="선택" /></button>
					</div>
				</div>
				<p class="btnVote"><input type="image" onclick="checkform('2'); return fasle;" src="http://webimage.10x10.co.kr/eventIMG/2015/62786/btn_vote_round1.png" alt="투표하기" /></p>
				<!--// 음식 선택하기 -->
			</div>
			<!--// 2라운드 -->
		<% end if %>

		<% If left(nowdate,10)>="2015-05-27" and left(nowdate,10)<"2015-05-30" Then %>
			<!-- 3라운드(27일~29일) -->
			<div class="match round3">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/62786/tit_food_fighter_round3.png" alt="푸드파이터" /></h2>
				<p class="todayFood"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62786/txt_round3.png" alt="3ROUND 피자편" /></p>
				<!-- 음식 선택하기 -->
				<div class="selectFood">
					<div class="cadidate">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/62786/txt_round3_candidate1.jpg" alt="쉬림프 피자의 원조 미스터피자" /></p>
						<button id="selectBtn1" class="selectBtn"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62786/btn_select.png" alt="선택" /></button>
					</div>
					<div class="cadidate">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/62786/txt_round3_candidate2.jpg" alt="쉬림프피자의 신흥 강자 도미노피자" /></p>
						<button id="selectBtn2" class="selectBtn"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62786/btn_select.png" alt="선택" /></button>
					</div>
				</div>
				<p class="btnVote"><input type="image" onclick="checkform('3'); return fasle;" src="http://webimage.10x10.co.kr/eventIMG/2015/62786/btn_vote_round1.png" alt="투표하기" /></p>
				<!--// 음식 선택하기 -->
			</div>
			<!--// 3라운드 -->
		<% end if %>
			<!-- 투표완료(레이어팝업) -->
			<div id="foodLayer" class="foodLayer">
				<div class="viewResult">
				<% If left(nowdate,10)>="2015-05-20" and left(nowdate,10)<"2015-05-24" Then %>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/62786/pop_round1_finish.png" alt="투표완료! 당첨자발표 시간을 기다려주세요. 당첨 시 개인정보에 있는 핸드폰 번호로 기프티콘이 발송됩니다. 받으실 핸드폰 번호를 미리 확인해주세요." /></p>
				<% end if %>
				<% If left(nowdate,10)>="2015-05-24" and left(nowdate,10)<"2015-05-27" Then %>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/62786/pop_round1_finish.png" alt="투표완료! 당첨자발표 시간을 기다려주세요. 당첨 시 개인정보에 있는 핸드폰 번호로 기프티콘이 발송됩니다. 받으실 핸드폰 번호를 미리 확인해주세요." /></p>
				<% end if %>
				<% If left(nowdate,10)>="2015-05-27" and left(nowdate,10)<"2015-05-30" Then %>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/62786/pop_round1_finish.png" alt="투표완료! 당첨자발표 시간을 기다려주세요. 당첨 시 개인정보에 있는 핸드폰 번호로 기프티콘이 발송됩니다. 받으실 핸드폰 번호를 미리 확인해주세요." /></p>
				<% end if %>
					<a href="" onClick="jsmytenbyten(); return false;" class="btnChkPhone">핸드폰 번호 확인하기</a>
					<button class="btnClose">창닫기</button>
				</div>
			</div>
			<!--// 투표완료(레이어팝업) -->
		</div>

<%
'// 카카오링크 변수
Dim kakaotitle
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2015/62786/img_kakao02.jpg"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url

	If left(nowdate,10)>="2015-05-24" and left(nowdate,10)<"2015-05-27" Then
		kakaotitle = "[텐바이텐] 푸드파이터!\n친구야! 같이 투표하고 야식 선물받자!\n\n투표한 파이터가 승리하면,\n매일 300명을 추첨해 선물로 드려요!\n\n2 Round : 빙수편\n카페베네 VS 투썸플레이스\n\n오직 텐바이텐 에서만!"
	else
		kakaotitle = "[텐바이텐] 푸드파이터!\n친구야! 같이 투표하고 야식 선물받자!\n\n투표한 파이터가 승리하면,\n매일 100명을 추첨해 선물로 드려요!\n\n2 Round : 피자편\n미스터피자 VS 도미노피자\n\n오직 텐바이텐 에서만!"
	end if

	If isapp = "1" Then '앱일경우
		kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
	Else '앱이 아닐경우
		kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
	end if
%>
<% if isapp = 1 then %>
	<p><a href="" onclick="kakaosendcall();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62786/btn_share_kakao.gif" alt="카카오톡으로 푸드파이터 알려주기" /></a></p>
<% else %>
		<% If left(nowdate,10)>="2015-05-20" and left(nowdate,10)<"2015-05-30" Then %>
			<p><a href="" onclick="parent.parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>'); return false;" id="kakao-link-btn"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62786/btn_share_kakao.gif" alt="카카오톡으로 푸드파이터 알려주기" /></a></p>
		<% end if %>
<% end if %>



		<div class="evtNoti">
			<h3><span>이벤트 주의사항</span></h3>
			<ul>
				<li>본 이벤트는 텐바이텐 모바일웹과 APP에서만 참여 가능합니다.</li>
				<li>ID당 하루에 한 번씩 응모가 가능합니다.</li>
				<li>당첨자 발표와 투표결과는 익일 오전 10시에 텐바이텐 공지사항에서 확인할 수 있습니다.</li>
				<li>투표한 파이터가 승리하면, 해당 상품을 기프티콘(모바일 상품권)으로 증정하며, 승리한 파이터에 투표한 고객들 중에서 랜덤으로 당첨자를 선정합니다.</li>
				<li>기프티콘(모바일 상품권)은 개인정보에 있는 핸드폰 번호로 발송되므로, 투표 후에는 꼭 마이텐바이텐에서 핸드폰 번호를 확인해주세요.</li>
				<li>핸드폰 번호 오입력에 따른 미수신 시, 재발송은 불가능함을 알려드립니다.</li>
				<li>기프티콘 발송일 및 시간은 당첨자 발표 공지사항에서 알려드립니다.</li>
			</ul>
		</div>
		<div class="anotherEvt">
			<a href="#" onclick="parent.fnAPPpopupEvent('62086'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62786/bnr_go_discount.gif" alt="디스전 바로가기" /></a>
		</div>
	</div>
	<!--// 푸드 파이터(M/A) -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->