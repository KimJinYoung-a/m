<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : [베페베이비페어] 나는 엄마니깐! 
' History : 2014.08.26 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	Dim eCode, cnt, sqlStr, regdate, gubun,  i, totalsum
	Dim iCTotCnt , iCPageSize

	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "21275"
	Else
		eCode 		= "54372"
	End If
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<style type="text/css">
.mEvt54372 {position:relative;}
.mEvt54372 img {vertical-align:top; width:100%;}
.mEvt54372 p {max-width:100%;}
.iam-mom .section-a {position:relative;}
.iam-mom .section-a .big {position:absolute; left:0; top:7%; width:100%;}
.iam-mom .section-a .heart {position:absolute; left:40%; top:21%; width:20%;}
.iam-mom .section-b {position:relative; padding-bottom:8%; background-color:#ffedc3;}
.iam-mom .section-b h2 {position:absolute; left:15%; top:-6%; width:72%;}
.iam-mom .section-b .benefit {margin:0 5.5%; padding:5% 0; border:2px solid #ff9f41; border-radius:20px; background-color:#fff2d5;}
.iam-mom .section-b .benefit .btnJoin {margin:0 11%;}
.iam-mom .section-b .entry {position:relative; margin-top:8%;}
.iam-mom .section-b .entry legend {visibility:hidden; width:0; height:0; overflow:hidden; position:absolute; top:-1000%; line-height:0;}
.iam-mom .section-b .entry fieldset {border:0;}
.iam-mom .section-b .entry .email-form {position:absolute; left:5%; top:0; width:79%; padding:7% 5% 10%;}
.iam-mom .section-b .entry .email-form label img {width:65%;}
.iam-mom .section-b .entry .email-form input[type=email] {display:block; width:58%; height:77px; margin:3% 2% 0; padding:2% 2%; border:0; border-radius:5px; box-shadow: inset 3px 3px 5px #e5e5e5; font-size:16px; font-weight:bold;}
.iam-mom .section-b .entry .email-form .btn-entry {position:absolute; top:12%; right:5%; width:28.33333%;}
.iam-mom .section-b .entry .email-form .btn-entry input {width:100%;}
@media all and (max-width:767px){
	.iam-mom .section-b .entry .email-form input[type=email] {height:38px; font-size:14px; font-weight:normal;}
}
@media all and (max-width:480px){
	.iam-mom .section-b .entry .email-form input[type=email] {height:25px; font-size:12px;}
}
.animated {-webkit-animation-fill-mode:both; animation-fill-mode:both;}
/* Flash animation */
@-webkit-keyframes flash {
	0%, 50%, 100% {opacity: 1;}
	25%, 75% {opacity:0.7;}
}
@keyframes flash {
	0%, 50%, 100% {opacity: 1;}
	25%, 75% {opacity:0.7;}
}
.flash {-webkit-animation-name:flash; animation-name:flash; -webkit-animation-duration:2s; animation-duration:2s; -webkit-animation-iteration-count:infinite; animation-iteration-count:infinite;}
</style>

<script type="text/javascript">

function checkform(frm) {
	<% if datediff("d",date(),"2014-09-01")>=0 then %>
		<% If IsUserLoginOK Then %>
			if (frm.evtopt3.value == "")
			{
				alert("베이비페어 회원 ID(이메일)를 입력해주세요");
				frm.evtopt3.focus();
				document.frm.evtopt3.value = "";
				return false;
			}
			if (confirm("베페 회원ID를 잘 입력하셨나요? 확인 버튼을 누르면, 수정이 불가능합니다. 응모 완료하시겠습니까?") == true){    //확인
				frm.action = "/apps/appcom/wish/webview/event/etc/doEventSubscript54372.asp";
			}else{   //취소
			return true;
			}
		<% Else %>
			alert('로그인을 하시고 참여해 주세요.');
			parent.calllogin();
		<% End If %>
	<% else %>
			alert('이벤트가 종료되었습니다.');
			return;
	<% end if %>
	}
	
function joinchk() {
	<% If IsUserLoginOK Then %>
		alert('이미 가입 되어있습니다.');
		return;
	<% ELSE %>
		top.location.href="http://m.10x10.co.kr/apps/appcom/wish/webview/member/join.asp"
	<% END IF %>
}
</script>

</head>
<body class="event">
	<!-- 나는 엄마니깐! -->
	<div class="mEvt54372">
		<div class="iam-mom">
			<div class="section-a">
				<p class="big"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54372/txt_big.png" alt="베페와 함께하는 BIG 혜택 이벤트" /></p>
				<span class="heart animated flash"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54372/ico_heart.png" alt="" /></span>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54372/txt_for_mom.gif" alt="나는 엄마니까! 베페페어에 오신 모든 엄마들을 위해 바칩니다!" /></p>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54372/txt_date.gif" alt="이벤트 기간은 2014년 8월 28일부터 8월 31일까지이며, 당첨자 발표 및 포인트 지급일은 2014년 9월 4일 입니다." /></p>
			</div>

			<section class="section-b">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/54372/tit_benefit.png" alt="100% 증정 혜택" /></h2>
				<div class="benefit">
					<ul>
						<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/54372/txt_benefit_01.gif" alt="혜택 하나, 베페 회원 인증한 모든 분들께 1,000포인트 적립 현금처럼 사용 가능" /></li>
						<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/54372/txt_benefit_02.gif" alt="헤택 둘, 인증한 분들 중, 추첨을 통해 10분께 타요 플레이 볼텐트 증정!" /></li>
						<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/54372/txt_benefit_03.gif" alt="헤택 셋, 텐바이텐 베이비/키즈 5,000원 할인 쿠폰 증정!" /></li>
					</ul>
					<!-- for dev msg : -->
					<div class="btnJoin"><a href="" onclick="joinchk(); return false;" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54372/btn_join.gif" alt="텐바이텐 회원가입 하기" /></a></div>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54372/txt_codition.gif" alt="이벤트 기간 동안, 텐바이텐 회원가입을 하신 분들에게 즉시 지급되며, 4만원 이상 구매 시 사용 가능합니다." /></p>
				</div>
				
				<!-- for dev msg : 베페 회원 ID (이메일) 입력하기 -->
				<div class="entry">
					<div class="email-form">
						<form name="frm" method="POST" style="margin:0px;" onSubmit="return checkform(this);">
						<input type="hidden" name="eventid" value="<%=eCode%>">
						<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
						<input type="hidden" name="page" value="">
							<fieldset>
							<legend>베페 회원 이메일 입력 폼</legend>
								<label for="youremail"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54372/txt_label_id.png" alt="베페 회원 ID (이메일) 입력하기" /></label>
								<input type="email" id="youremail" name="evtopt3" />
								<span class="btn-entry"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/54372/btn_entry.png" alt="이벤트 응모하기" /></span>
							</fieldset>
						</form>
					</div>
					<img src="http://webimage.10x10.co.kr/eventIMG/2014/54372/img_pink_box.gif" alt="" />
				</div>
			</section>

			<div class="section-c">
				<p><a href="http://m.10x10.co.kr/apps/appcom/wish/webview/event/eventmain.asp?eventid=54095&rdsite=BEFE" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54372/btn_event.jpg" alt="뽀로로부터 타요까지 올여름 텐바이텐이 추천하는 베이비 치즈 할인 기획전 지금 확인하러 가기" /></a></p>
				<p><a href=""><img src="http://webimage.10x10.co.kr/eventIMG/2014/54372/txt_noti.gif" alt=" 이벤트 안내 본 이벤트는 회원가입 후, 참여가 가능합니다. 텐바이텐 앱에서 베페 회원 ID(이메일)를 입력하고 이벤트 응모하기 버튼을 누르면 이벤트 참여가 완료됩니다. 텐바이텐 5,000원 할인쿠폰은 회원가입시, 즉시 지급되며 유효기간은 8월 28일부터 9월 7일까지입니다. 베페 1,000 포인트는 이벤트 종료 후 9월 4일에 일괄 지급됩니다. 타요 텐트 당첨자에게는 세무신고를 위해 개인정보를 요청할 수 있습니다. 이벤트 관련 문의는 텐바이텐 CS 1644-6030로 주시기 바랍니다." /></a></p>
			</div>
		</div>
	</div>
	<!-- //나는 엄마니깐! -->
</body>
</html>