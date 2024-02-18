<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 설날맞이 손금보기
' History : 2016.01.20 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->

<%
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66006
Else
	eCode   =  68806
End If

dim currenttime
currenttime = now()
'currenttime = #02/01/2016 10:05:00#

Dim ename, emimg, cEvent, blnitempriceyn
set cEvent = new ClsEvtCont
	cEvent.FECode = eCode
	cEvent.fnGetEvent
	
	eCode		= cEvent.FECode	
	ename		= cEvent.FEName
	emimg		= cEvent.FEMimg
	blnitempriceyn = cEvent.FItempriceYN
set cEvent = nothing
%>

<% '<!-- #include virtual="/lib/inc/head.asp" --> %>

<style type="text/css">
.mEvt59413 {}
.mEvt59413 img {vertical-align:top;}
.mEvt59413 .likeTenten {position:relative;}
.mEvt59413 .palm {background:url(http://webimage.10x10.co.kr/eventIMG/2015/59413/bg_event_cont.gif) left top repeat-y; background-size:100% auto;}
.mEvt59413 .palm dl {overflow:hidden;}
.mEvt59413 .palm dt {}
.mEvt59413 .palm dd {overflow:hidden;}
/*.mEvt59413 .palm dd ul {overflow:hidden; padding:0 22px;}
.mEvt59413 .palm dd li {float:left; width:50%; padding:0 4px 12px; text-align:center;}*/
.mEvt59413 .palm dd ul {overflow:hidden; padding:0 5%;}
.mEvt59413 .palm dd li {float:left; width:50%; padding:0 3% 3%; text-align:center;}
.mEvt59413 .palm dd li label {display:block; width:100%;}
.mEvt59413 .palm dd li input {margin-top:3px;}
/*.mEvt59413 .palm .btnResult {display:inline-block;}*/
.mEvt59413 .shareSns {position:relative;}
.mEvt59413 .shareSns a {display:block; position:absolute; top:56%; width:15%; height:26%; color:transparent;}
.mEvt59413 .shareSns a.twitter {left:22%;}
.mEvt59413 .shareSns a.facebook {left:42%;}
.mEvt59413 .shareSns a.kakao {left:62%;}

 /* 레이어팝업 */
.mEvt59413 .openLayer {position:absolute; left:0; top:0; width:100%; height:100%; z-index:20; background:rgba(0,0,0,.6);}
.mEvt59413 .palmLyCont {position:relative;}
.mEvt59413 .viewResult {position:absolute; left:0; top:20%; z-index:30;}
.mEvt59413 .myPalm {overflow:hidden; text-align:left; }
.mEvt59413 .myPalm dl {padding:0 10%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/59413/bg_result.png) left top repeat-y; background-size:100% auto;}
.mEvt59413 .myPalm dd {font-size:11px; color:#000; line-height:1.3;}
.mEvt59413 .btnFb {display:block; position:absolute; z-index:40; color:transparent;}
.mEvt59413 .fbLogin {position:absolute; left:0; top:2.5%;  width:100%;}
.mEvt59413 .fbLogin .btnFb {left:15%; top:36%; width:70%; height:17%;}
.mEvt59413 .mateTenten {position:absolute; left:0; top:2.5%; width:100%;}
.mEvt59413 .mateTenten .btnFb {left:10%; top:33.5%; width:80%; height:25.5%;}
.mEvt59413 .viewMyPalm {display:none;}
.reCheck {position:relative;}
.reCheck a {display:block; position:absolute; left:25%; top:27.5%; width:50%; height:40%; color:transparent;}

@media all and (min-width:480px){
	/*.mEvt59413 .palm dd ul {padding:0 33px;}
	.mEvt59413 .palm dd li {padding:0 6px 18px;}*/
	.mEvt59413 .palm dd li input {margin-top:5px;}
	.mEvt59413 .myPalm dd {font-size:17px;}
}
</style>
<script type="text/javascript">

function tenten_sns(){
	//로그인 체크
	FB.login(function(response) {
		if (response.status == "connected"){
				$("#loginlayer").css("display","none");
				$("#likeitlayer").css("display","block");
		}else{
			alert("이벤트 참가를 위해 로그인을 해주세요");
		}
	});
}

function eventGo(){
	tenten_sns();
	return;
}

function likeiturl(){
	window.open ("https://m.facebook.com/your10x10","_blank");
	$("#likeitlayer").css("display","none");
	$(".openLayer").css("display","none");
}

</script>

<div id="fb-root"></div>
<script type="text/javascript">

window.fbAsyncInit = function() {
	//신버전	
	FB.init({
		appId      : '417711631728635',
		cookie     : true,  // enable cookies to allow the server to access 
							// the session
		xfbml      : true,  // parse social plugins on this page
		version    : 'v2.1' // use version 2.1
	});

	//Additional initialization code here
	FB.getLoginStatus(function(response) {
		if (response.status === 'connected') {
			// facebook 회원 정보 조회
			getinfo();
		} else if (response.status === 'not_authorized') {
			// facebook 회원 정보 조회
			getinfo();
		} else {
			// facebook 회원 정보 조회
			getinfo();
		}
	});

	//facebook height auto resize
	FB.Canvas.setAutoGrow();
};

//Load the SDK Asynchronously

(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/ko_KR/sdk.js#xfbml=1&appId=417711631728635&version=v2.1";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));

function getinfo() {
	//사용자 정보 받아오시오
	FB.api('me/',
	function(response) {
		 fbuid = response.id;
		 fbname = response.name;
		 fbemail = response.email;
		 fbuphoto = "https://graph.facebook.com/"+response.id+"/picture";
		 }
		 //,{scope: 'user_likes,public_profile,email'}
	);
}

</script>
<script type="text/javascript">

function jsSubmit(){
	<% ' If not( left(currenttime,10)>="2016-02-01" and left(currenttime,10)<"2016-03-01" ) Then %>
		//alert("이벤트 응모 기간이 아닙니다.");
		//return;
	<% ' else %>
		var frm = document.frm;
	
		if(!(document.getElementsByName("spoint1")[0].checked||document.getElementsByName("spoint1")[1].checked||document.getElementsByName("spoint1")[2].checked||document.getElementsByName("spoint1")[3].checked)){
			alert("감정선을 선택해주세요");
			return false;
		}
	
		if(!(document.getElementsByName("spoint2")[0].checked||document.getElementsByName("spoint2")[1].checked||document.getElementsByName("spoint2")[2].checked||document.getElementsByName("spoint2")[3].checked)){
			alert("운명선을 선택해주세요");
			return false;
		}
	
		if(!(document.getElementsByName("spoint3")[0].checked||document.getElementsByName("spoint3")[1].checked||document.getElementsByName("spoint3")[2].checked||document.getElementsByName("spoint3")[3].checked)){
			alert("두뇌선을 선택해주세요");
			return false;
		}
	
		if(!(document.getElementsByName("spoint4")[0].checked||document.getElementsByName("spoint4")[1].checked||document.getElementsByName("spoint4")[2].checked||document.getElementsByName("spoint4")[3].checked)){
			alert("생명선을 선택해주세요");
			return false;
		}
	
		// 결과
		$('.viewMyPalm').show();
		$("#viewResult").css("display","block");
		$('html,body').animate({scrollTop: $("#emotionval").offset().top},'slow');
	
		frm.action = "/event/etc/sns/doEventSubscript68806.asp";
		frm.target="evtFrmProc";
		frm.submit();
		return false;
	<% ' end if %>
}

// 손금 영역
var result1 = "";
var result2 = "";
var result3 = "";
var result4 = "";
function select_line(q,a){
	var line_num = q;
	var select_num = a;
	var resulttext // 결과 텍스트

	switch (q)
	{
	//감정선
	case 1:
	  switch (a)
	  {
		  case 1:
			result1 = "이해와 배려를 잘 하는 인간중심적인 마인드를 갖고 있군요. 그리고 당신은 사랑에 정열적인 성향을 갖고 있는 로맨티스트랍니다. 단. 금방 사랑에 빠지거나 흥분을 잘 하는 편일 수도 있으니 조심하세요."
			break;
		  case 2:
			result1 = "감정적으로 인간적이기보다는 냉철한 부분이 많은 성격인 것 같아요. 대인관계 보다는 권력이나 명예, 성공 등에 대한 욕구가 강한 편이고요. 또한 합리적이고 업무 중심적인 사고를 가지고 있네요."
			break;
		  case 3:
			result1 = "인정도 많고 지성과 매너를 갖춘 당신! 게다가 의리와 애정이 넘치지 대인관계는 100점 만점이겠군요. 어디서나 사랑 받는 당신은 욕심쟁이! 우후훗!"
			break;
		  case 4:
			result1 = "애정을 비롯한 감정선이 매우 풍부한 당신!  그러다 보니 대인관계도 좋지만 사랑을 하게 되면 깊게 빠지는 편이네요.  당신의 열정으로 갖고 있는 재능을 잘 살린다면 저명한 인사가 될 수 도 있어요"
			break;
		  default:
			result1 = ""
	  }
	  break;
	//운명선
	case 2:
	  switch (a)
	  {
		  case 1:
			result2 = "손바닥부터 부자의 운명을 타고 났네요. 물려 받은 유산이 많거나 젊어서 크게 성공할 확률이 높아요.  노력하는 것보다 더 큰 성과를 만지게 될 운명이에요."
			break;
		  case 2:
			result2 = "타고난 재력이 있지만 자기 관리를 어떻게 하냐에 따라서 성공과 실패가 달려 있네요. 누구나 그렇겠지만 잘만 한다면 누구보다도 더 성공할 수 있는 손금을 갖고 있어요"
			break;
		  case 3:
			result2 = "30대 이후에 본인의 노력에 따른 빛을 볼 수 있어요. 영리하고 성실해서 일 잘한다는 소리를 많이 들었겠군요!"
			break;
		  case 4:
			result2 = "오래도록 열심히 성실히 일하는 편입니다. 젊은 나이에 조금 고단한 인생을 살 수도 있겠지만 노후에는 누구보다도 안락하고 평온한 삶을 살게 될 거에요."
			break;
		  default:
			result2 = ""
	  }		  
	  break;
	//두뇌선
	case 3 : 
	  switch (a)
	  {
		  case 1:
			result3 = "착실하고 평범한 성격으로 과한 행동을 하지는 않네요. 활발하게 사회생활을 할 때 갖고 있는 재능을 맘껏 발휘하게 될 거에요. 일반 회사원의 직업이 잘 맞는 편인 것 같아요."
			break;
		  case 2:
			result3 = "아티스트 성향이 있거나 사업자로서의 마인드를 가졌어요. 이상과 현실의 두 가지를 가진 비범한 성향이 당신의 큰 장점이고요, 창의력도 높고 논리적인 사고도 가졌지만, 우유부단한 편이네요."
			break;
		  case 3:
			result3 = "깔끔하고 냉철한 완벽주의자인 당신! 머리 회전도 엄청 빠르네요. 알고 있는 지식도 많고 공부를 하면 흡수도 참 잘하는 편이에요."
			break;
		  case 4:
			result3 = "갖고 있는 능력은 좋은 편인데 조직 생활을 하기엔 어려움이 있을 것 같아요. 스스로 채찍질하고 자기 관리를 뚜렷하게 하는 편이라 주변에서 다가가기 어려울 수 있으니 조금만 더 너그러워지는 건 어때요?"
			break;
		  default:
			result3 = ""
	  }		  
	  break;
	//생명선
	case 4 : 
		switch (a)
	  {
		  case 1:
			result4 = "오래오래 아프지 않고 건강하게 잘 살 운명!"
			break;
		  case 2:
			result4 = "어디론가 이동을 할 때 주의를 기울이세요. 이동수가 많기도 하지만 덤벙대는 성격도 문제가 될 수 있어요. 조금만 더 조심스럽게 행동한다면 좋아질거에요"
			break;
		  case 3:
			result4 = "각별히 몸 조심 해야 해요! 건강 상에 문제가 있을 수도 있어요. 건강검진도 정기적으로 받고, 운동도 열심히 해야 해요"
			break;
		  case 4:
			result4 = "어려서부터 잔병치레가 많은 편이었나 봐요. 손금에는 쇠약의 기운이 보이는데요, 손금은 변하는거니까! 운동도 많이 하고 건강한 음식도 챙겨 먹어요."
			break;
		  default:
			result4 = ""
	  }		  
	  break;
	//디폴트
	default:
		alert("모두 선택 해주세요");
	}
	resulttext = result1 + result2 + result3 + result4;
	$("#resulttxt").text(resulttext);
}

function evt_reset(){
	$(".openLayer").css("display","none");
	$("#loginlayer").css("display","none");
	$("#likeitlayer").css("display","none");
	$("#viewResult").css("display","none");

	document.getElementsByName("spoint1")[0].checked = false;
	document.getElementsByName("spoint1")[1].checked = false;
	document.getElementsByName("spoint1")[2].checked = false;
	document.getElementsByName("spoint1")[3].checked = false;

	document.getElementsByName("spoint2")[0].checked = false;
	document.getElementsByName("spoint2")[1].checked = false;
	document.getElementsByName("spoint2")[2].checked = false;
	document.getElementsByName("spoint2")[3].checked = false;

	document.getElementsByName("spoint3")[0].checked = false;
	document.getElementsByName("spoint3")[1].checked = false;
	document.getElementsByName("spoint3")[2].checked = false;
	document.getElementsByName("spoint3")[3].checked = false;

	document.getElementsByName("spoint4")[0].checked = false;
	document.getElementsByName("spoint4")[1].checked = false;
	document.getElementsByName("spoint4")[2].checked = false;
	document.getElementsByName("spoint4")[3].checked = false;
}

</script>

<!-- 그 손 참 곱다 (M) -->
<div class="mEvt59413">
	<div class="likeTenten">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/59413/tit_like_tenten_v1.gif" alt="텐바이텐을 좋아요한 그 손 참 곱다~" /></h2>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59413/tit_your_palm.gif" alt="신중하게 손을 들여다 보고 일치하는 손금의 모양을 골라주세요." /></p>
		<div class="palm">
			<!-- 감정선 -->
			<dl>
				<dt><img src="http://webimage.10x10.co.kr/eventIMG/2015/59413/tit_palm_emotion.png" alt="감정선" /></dt>
				<dd id="emotionval">
					<ul>
						<li>
							<label for="emotion01"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59413/img_palm_emotion01.png" alt="끝 부분이 위로 향하는 선" /></label>
							<input type="radio" id="emotion01" onclick="select_line(1,1);" name="spoint1"/>
						</li>
						<li>
							<label for="emotion02"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59413/img_palm_emotion02.png" alt="직선으로 뻗어가는 선" /></label>
							<input type="radio" id="emotion02" onclick="select_line(1,2);" name="spoint1"/>
						</li>
						<li>
							<label for="emotion03"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59413/img_palm_emotion03.png" alt="끝 부분이 여러갈래로 흩어지는 선" /></label>
							<input type="radio" id="emotion03" onclick="select_line(1,3);" name="spoint1"/>
						</li>
						<li>
							<label for="emotion04"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59413/img_palm_emotion04.png" alt="중반 부분에서 두개 또는 세개로 갈라지는 선" /></label>
							<input type="radio" id="emotion04" onclick="select_line(1,4);" name="spoint1"/>
						</li>
					</ul>
				</dd>
			</dl>
			<!--// 감정선 -->

			<!-- 운명선 -->
			<dl>
				<dt><img src="http://webimage.10x10.co.kr/eventIMG/2015/59413/tit_palm_fate.png" alt="운명선" /></dt>
				<dd>
					<ul>
						<li>
							<label for="fate01"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59413/img_palm_fate01.png" alt="손바닥부터 올라가는 선" /></label>
							<input type="radio" id="fate01" onclick="select_line(2,1);" name="spoint2"/>
						</li>
						<li>
							<label for="fate02"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59413/img_palm_fate02.png" alt="두뇌선과 감정선에 걸쳐있는 선" /></label>
							<input type="radio" id="fate02" onclick="select_line(2,2);" name="spoint2"/>
						</li>
						<li>
							<label for="fate03"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59413/img_palm_fate03.png" alt="감정선에 걸쳐있는 선" /></label>
							<input type="radio" id="fate03" onclick="select_line(2,3);" name="spoint2"/>
						</li>
						<li>
							<label for="fate04"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59413/img_palm_fate04.png" alt="감정선 위로 올라가있는 선" /></label>
							<input type="radio" id="fate04" onclick="select_line(2,4);" name="spoint2"/>
						</li>
					</ul>
				</dd>
			</dl>
			<!--// 운명선 -->

			<!-- 두뇌선 -->
			<dl>
				<dt><img src="http://webimage.10x10.co.kr/eventIMG/2015/59413/tit_palm_brain.png" alt="두뇌선" /></dt>
				<dd>
					<ul>
						<li>
							<label for="brain01"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59413/img_palm_brain01.png" alt="두 갈래로 갈라지는 선" /></label>
							<input type="radio" id="brain01" onclick="select_line(3,1);" name="spoint3"/>
						</li>
						<li>
							<label for="brain02"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59413/img_palm_brain02.png" alt="손 끝에서 짧게 끊어지는 선" /></label>
							<input type="radio" id="brain02" onclick="select_line(3,2);" name="spoint3"/>
						</li>
						<li>
							<label for="brain03"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59413/img_palm_brain03.png" alt="새끼 손가락으로 끝이 올라간 선" /></label>
							<input type="radio" id="brain03" onclick="select_line(3,3);" name="spoint3"/>
						</li>
						<li>
							<label for="brain04"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59413/img_palm_brain04.png" alt="밑 부분을 향하고 곧게 하나로 뻗은 선" /></label>
							<input type="radio" id="brain04" onclick="select_line(3,4);" name="spoint3"/>
						</li>
					</ul>
				</dd>
			</dl>
			<!--// 두뇌선 -->

			<!-- 생명선 -->
			<dl class="bPad15">
				<dt><img src="http://webimage.10x10.co.kr/eventIMG/2015/59413/tit_palm_life.png" alt="생명선" /></dt>
				<dd>
					<ul>
						<li>
							<label for="life01"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59413/img_palm_life01.png" alt="두 갈래로 갈라지는 선" /></label>
							<input type="radio" id="life01" onclick="select_line(4,1);" name="spoint4"/>
						</li>
						<li>
							<label for="life02"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59413/img_palm_life02.png" alt="손 끝에서 짧게 끊어지는 선" /></label>
							<input type="radio" id="life02" onclick="select_line(4,2);" name="spoint4"/>
						</li>
						<li>
							<label for="life03"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59413/img_palm_life03.png" alt="새끼 손가락으로 끝이 올라간 선" /></label>
							<input type="radio" id="life03" onclick="select_line(4,3);" name="spoint4"/>
						</li>
						<li>
							<label for="life04"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59413/img_palm_life04.png" alt="밑 부분을 향하고 곧게 하나로 뻗은 선" /></label>
							<input type="radio" id="life04" onclick="select_line(4,4);" name="spoint4"/>
						</li>
					</ul>
				</dd>
			</dl>
			<!--// 생명선 -->
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59413/bg_paper.gif" alt="" /></p>

			<span class="btnResult">
				<a href="#viewResult" onclick="jsSubmit(); return false;">
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/59413/btn_view_result.gif" alt="결과확인" /></a>
			</span>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59413/txt_caution.gif" alt="주의:운세나 미신에 일희일비 하지 마시고, 가벼운 마음으로 테스트해주시기 바랍니다." /></p>
		</div>

		<!-- 레이어팝업(페이스북 로그인,좋아요) -->
		<div class="openLayer" style="display:none">
			<!-- 페이스북 로그인 -->
			<div class="fbLogin" id="loginlayer" style="display:none">
				<div class="palmLyCont">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59413/txt_layer_fb_login.gif" alt="텐바이텐을 좋아요 한 고운 손! 텐바이텐이 손금을 봐드립니다." /></p>
					<a href="javascript:eventGo(); return false;" class="btnFb">페이스북 로그인하기</a>
				</div>
			</div>

			<!-- 텐바이텐 좋아요 -->
			<div class="mateTenten" id="likeitlayer" style="display:none">
				<div class="palmLyCont">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59413/txt_layer_10x10_like.gif" alt="아직도 텐바이텐과 친구가 아니라고요?" /></p>
					<a href="" onclick="likeiturl(); return false;" target="_blank" class="btnFb">텐바이텐 좋아요</a>
				</div>
			</div>

		</div>
		<!--// 레이어팝업(페이스북 로그인,좋아요) -->

		<!-- 레이어팝업(결과보기) -->
		<div class="openLayer viewMyPalm">
			<div class="viewResult" id="viewResult">
				<div class="myPalmWrap">
					<div class="myPalm">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59413/img_layer_palm.png" alt="" /></p>
						<dl>
							<dt><img src="http://webimage.10x10.co.kr/eventIMG/2015/59413/tit_result.png" alt="손금결과" /></dt>
							<dd id="resulttxt"></dd>
						</dl>
					</div>
					<p class="reCheck">
						<a href="" onclick="evt_reset(); return false;">손금 다시보기</a>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/59413/btn_view_palm.png" alt="" />
					</p>
				</div>
			</div>
		</div>
		<!--// 레이어팝업(결과보기) -->
	</div>
	<!-- sns 공유 -->
	<%
		'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
		dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
		snpTitle = Server.URLEncode(ename)
		snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=" & ecode)
		snpPre = Server.URLEncode("텐바이텐 이벤트")
		snpTag = Server.URLEncode("텐바이텐 " & Replace(ename," ",""))
		snpTag2 = Server.URLEncode("#10x10")
		snpImg = Server.URLEncode(emimg)

		'// 카카오링크 변수
		Dim kakaotitle : kakaotitle = "[텐바이텐]설날맞이 손금보기"
		Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2015/59413/kakao_200x200.jpg"
		Dim kakaoimg_width : kakaoimg_width = "200"
		Dim kakaoimg_height : kakaoimg_height = "200"
		Dim kakaolink_url
			If isapp = "1" Then '앱일경우
				kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=" & eCode
			Else '앱이 아닐경우
				kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid=" & eCode
			end if 
	%>
	<div class="shareSns">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59413/img_share_sns.gif" alt="친구들도 고운 손을 가질 수 있게 텐바이텐을 널리 알려주세요!" /></p>
		<a href="" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>'); return false;" class="twitter">twitter</a>
		<a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','',''); return false;" class="facebook">facebook</a>
		<a href="" onclick="parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>'); return false;" class="kakao">kakao talk</a>
	</div>
	<!--// sns 공유 -->
</div>
<form name="frm" method="post">
<input type="hidden" name="isapp" value="<%= isapp %>">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width="0" height="0"></iframe>

<!-- #include virtual="/lib/db/dbclose.asp" -->