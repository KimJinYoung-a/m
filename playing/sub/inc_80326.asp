<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<style type="text/css">
.topic {position:relative;border:solid 1px white;}
.topic span , .topic p, .topic button, .topic .mainHt{position:absolute; left:0;}
.topic span {display:inline-block;}
.topic h2 { border:solid 1px white;}
.topic h2 .t1 {width:17.18%; top:32.20%; left:31.71%; animation:bounce .2s .5s 1;}
.topic h2 .t2 {width:15.15%; top:31.25%; left:52.81%; animation:bounce .2s 1 .8s;}
.topic h2 .t3 {width:68.90%; top:44.80%; left:15.93%;}
.topic .mainHt{display:inline-block; width:16.40%; top:23.21%; left:42.18%; }
.topic .subcopy {top:56.07%; left:30.93%; width:38.28%;}
.topic .btnStart {width:51.40%; bottom:10.81%; left:24.68%; background-color:transparent; outline:none;}
.test {position:relative;}
.test .question .btnGroup {overflow:hidden;}
.test .question .btnGroup button {float:left; width:50%; outline:none;}
.test .lyLoading {position:absolute; top:0; left:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/playing/thing/vol022/m/bg_light_black.png) repeat;}
.test .lyLoading > img {display:block; padding-top:69.3%; width:16.88%; margin:0 auto;}
.test .lyLoading p {width:36.40%; margin:0 auto; padding-top:2.1%;}
.result {background-color:#ffeae7;}
.btnMore {width:100%;}
.snsShare {position:relative;}
.snsShare ul {overflow:hidden; position:absolute; top:0; right:3.8rem; width:31.25%; height:100%;}
.snsShare ul li {float:left; width:50%; height:100%;}
.snsShare ul li a {display:inline-block; width:100%; height:100%;  text-indent:-999em;}
@keyframes bounce{
	from,to {transform:translateY(0);}
	50% {transform:translateY(10px);}
}
</style>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript">
$(function(){
	var position = $('.thingVol022').offset(); // 위치값
	$('html,body').animate({scrollTop : position.top },300); // 이동

	/* test */
	$(".test .question").hide();
	$(".test").hide();
	$(".result").hide();
	$(".btnStart").on("click", function(e){
		$(".topic").hide();
		$(".test").show();
		$(".test .question").hide();
		$(".test .question:first").show();
		$(".test .lyLoading").hide();
	});
	$(".test .question button").on("click", function(e){
		if ( $(this).parent(".btnGroup").parent(".question").hasClass("q7")) {
			$(".test .q7").show();
			$(".test .lyLoading").show();
			$(".test").delay(2000).slideUp(800).fadeOut();
			$(".result").delay(2000).fadeIn()
		} else {
			$(".test .question").hide();
			$(this).parent(".btnGroup").parent(".question").next().show();
		}
	});

	/* test 다시하기 */
	$(".result .btnMore").on("click", function(e){
		$(".test .lyLoading").hide();
		$(".result").hide();
		$(".test .q7").hide();
		$(".test .q1").show();
		$(".topic").show();
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(".topic").offset().top},300);
	});

	/* 애니메이션 */
	titleAnimation();
	 $(".topic .t3").css({"margin-left":"-10px","opacity":"0"});
	 $(".topic .subcopy").css({"margin-left":"10px","opacity":"0"});
	function titleAnimation() {
		$(".topic .t3").delay(900).animate({"margin-left":"0","opacity":"1"},300);
		$(".topic .subcopy").delay(1200).animate({"margin-left":"0","opacity":"1"},500);
	}
});

function fnChoiceAnswer(objval,f){
	var answerval = $("#answerval").val();
	$("#answerval").val(answerval+objval);
	answerval = $("#answerval").val();
	//alert(answerval);
	if(f=="F")
	{
		if(answerval=="BAAAAAA" || answerval=="BAABBBB" || answerval=="BABBBAB" || answerval=="BABABBB" || answerval=="BAABBBB" || answerval=="BAAABBB" || answerval=="BAABBAB" || answerval=="BAABABB" || answerval=="BAAAABB" || answerval=="BAAABBA" || answerval=="BAAABAB" || answerval=="BAAAAAB" || answerval=="BAAAAAA")
		{
			//alert("#dog");
			$("#dog").show();
			$("#cat").hide();
			$("#bear").hide();
			$("#fox").hide();
		}
		else if(answerval=="BBBBBBB" || answerval=="BBAAAAA" || answerval=="BBBAAAA" || answerval=="BAAAABB" || answerval=="BBBBBAB" || answerval=="BBBBABB" || answerval=="BBBABBB" || answerval=="BBABBBB" || answerval=="BABBBBB" || answerval=="BABBBBA" || answerval=="BABBABB" || answerval=="BAABBBA")
		{
			//alert("#cat");
			$("#dog").hide();
			$("#cat").show();
			$("#bear").hide();
			$("#fox").hide();
		}
		else if(answerval=="AAAAABA" || answerval=="AAAABAA" || answerval=="AAAAABB" || answerval=="AAAABBA" || answerval=="AAABBAA" || answerval=="AAAABBB" || answerval=="AAABBBA" || answerval=="AAABBBB" || answerval=="AABBBBA" || answerval=="AABBBBB" || answerval=="ABBBBBA" || answerval=="ABBBBBB")
		{
			//alert("#bear");
			$("#dog").hide();
			$("#cat").hide();
			$("#bear").show();
			$("#fox").hide();
		}
		else if(answerval=="AAAAAAA" || answerval=="AAAAAAB" || answerval=="AAABAAA" || answerval=="AABAAAA" || answerval=="ABAAAAA" || answerval=="AABBAAA" || answerval=="ABBAAAA" || answerval=="AABBBAA" || answerval=="ABBBAAA" || answerval=="ABBBBAA" || answerval=="BBBBBBA")
		{
			//alert("#fox");
			$("#dog").hide();
			$("#cat").hide();
			$("#bear").hide();
			$("#fox").show();
		}
		else{
			$("#dog").show();
			$("#cat").hide();
			$("#bear").hide();
			$("#fox").hide();
		}
	}
}

function fnResetTest(){
	$("#answerval").val("");
}

function tnKakaoLink(title){
	parent_kakaolink(title , 'http://webimage.10x10.co.kr/play2016/2017/11/20170901105056_0e566.jpg' , '200' , '200' , 'http://m.10x10.co.kr/playing/view.asp?didx=138');
	return false;
}

// 쇼셜네트워크로 글보내기
function popSNSPost2(svc,tit,link,pre,tag) {
    // tit 및 link는 반드시 UTF8로 변환하여 호출요망!
	//alert("OK ");
    var popwin = window.open("/apps/snsPost/goSNSposts.asp?svc=" + svc + "&link="+link + "&tit="+tit + "&pre="+pre + "&tag="+tag,'popSNSpost');
    popwin.focus();
}
</script>

							<div class="thingVol022 howShopping">
								<div class="section topic">
									<h2>
										<span class="t1"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/tit_t1.png" alt="쇼" /></span>
										<span class="t2" ><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/tit_t2.png" alt="핑" /></span>
										<span class="t3"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/tit_t3.png" alt="어떻게 하세요?" /></span>
									</h2>
									<img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/txt_shopping_pattern.png" alt="장바구니 탐구생활 - 쇼핑 패턴편" />
									<span class="mainHt"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/img_main_heart.gif" alt="" /></span>
									<p class="subcopy"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/txt_subcopy.png" alt="나의 연애 스타일을 찾고 친구들과 공유해보세요!" /></p>
									<button class="btnStart"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/btn_start.png" alt="재미로 보는 연애 유형 TEST 테스트 스타트" /></button></a>
								</div>
								<!-- test -->
								<div class="section test">
									<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/tit_test.png" alt="재미로 보는 TEST 쇼핑 패턴 탐구생활 _ 연애 유형편" /></h3>
									<!-- question1 -->
									<div class="question q1">
										<p class="ques"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/txt_q1.png" alt="미리 쇼핑목록을 정하고 쇼핑한다.충동적으로 주문하는 물건은 별로 없다." /></p>
										<div class="btnGroup">
											<button type="button" class="btnY" onClick="fnChoiceAnswer('A','');"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/txt_yes.png" alt="맞아요" /></button>
											<button type="button" class="btnN" onClick="fnChoiceAnswer('B','');"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/txt_no.png" alt="아니요" /></button>
										</div>
										<div class="progressBar"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/img_progressbar1.png" alt="" /></div>
									</div>
									<!-- question2 -->
									<div class="question q2">
										<p class="ques"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/txt_q2.png" alt="일상이 쇼핑이다. 하루에 한번은 꼭 쇼핑몰을 방문한다." /></p>
										<div class="btnGroup">
											<button type="button" class="btnY" onClick="fnChoiceAnswer('A','');"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/txt_yes.png" alt="맞아요" /></button>
											<button type="button" class="btnN" onClick="fnChoiceAnswer('B','');"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/txt_no.png" alt="아니요" /></button>
										</div>
										<div class="progressBar"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/img_progressbar2.png" alt="" /></div>
									</div>
									<!-- question3 -->
									<div class="question q3">
										<p class="ques"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/txt_q3.png" alt="가능한,한 쇼핑몰에서 몰아서 주문한다. All in!" /></p>
										<div class="btnGroup">
											<button type="button" class="btnY" onClick="fnChoiceAnswer('A','');"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/txt_yes.png" alt="맞아요" /></button>
											<button type="button" class="btnN" onClick="fnChoiceAnswer('B','');"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/txt_no.png" alt="아니요" /></button>
										</div>
										<div class="progressBar"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/img_progressbar3.png" alt="" /></div>
									</div>
									<!-- question4 -->
									<div class="question q4">
										<p class="ques"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/txt_q4.png" alt="베스트셀러 상품들은 무조건 탐방! 많은 사람들이 산 상품을 주로 산다!" /></p>
										<div class="btnGroup">
											<button type="button" class="btnY" onClick="fnChoiceAnswer('A','');"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/txt_yes.png" alt="맞아요" /></button>
											<button type="button" class="btnN" onClick="fnChoiceAnswer('B','');"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/txt_no.png" alt="아니요" /></button>
										</div>
										<div class="progressBar"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/img_progressbar4.png" alt="" /></div>
									</div>
									<!-- question5 -->
									<div class="question q5">
										<p class="ques"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/txt_q5.png" alt="사도 사도 부족하다.옷장이 꽉 차있어도 입을 옷이 없다." /></p>
										<div class="btnGroup">
											<button type="button" class="btnY" onClick="fnChoiceAnswer('A','');"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/txt_yes.png" alt="맞아요" /></button>
											<button type="button" class="btnN" onClick="fnChoiceAnswer('B','');"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/txt_no.png" alt="아니요" /></button>
										</div>
										<div class="progressBar"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/img_progressbar5.png" alt="" /></div>
									</div>
									<!-- question6 -->
									<div class="question q6">
										<p class="ques"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/txt_q6.png" alt="한 번 찜한 물건은무슨 일이 있어도 꼭 산다!" /></p>
										<div class="btnGroup">
											<button type="button" class="btnY" onClick="fnChoiceAnswer('A','');"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/txt_yes.png" alt="맞아요" /></button>
											<button type="button" class="btnN" onClick="fnChoiceAnswer('B','');"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/txt_no.png" alt="아니요" /></button>
										</div>
										<div class="progressBar"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/img_progressbar6.png" alt="" /></div>
									</div>
									<!-- question7 -->
									<div class="question q7">
										<p class="ques"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/txt_q7.png" alt="당장 사고 싶은 물건이라도 몇 날 며칠을 고민한다." /></p>
										<div class="btnGroup">
											<button type="button" class="btnY" onClick="fnChoiceAnswer('A','F');"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/txt_yes.png" alt="맞아요" /></button>
											<button type="button" class="btnN" onClick="fnChoiceAnswer('B','F');"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/txt_no.png" alt="아니요" /></button>
										</div>
										<div class="progressBar"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/img_progressbar7.png" alt="" /></div>
									</div>
									<div class="lyLoading">
										<img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/img_load_heart.gif" alt="" />
										<p><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/txt_loading.png" alt="연애유형 분석중..." /></p>
									</div>
								</div>

								<!-- result -->
								<div class="section result">
									<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/tit_test_result.png" alt="" /></h3>
									<!-- 유형1 (강아지) -->
									<div class="grouping result1" style="display:none" id="dog">
									<div class="type"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/txt_result1.png" alt="강아지 유형 하루라도 연락하지 않으면 답답하지 않나요? 온종일 기다리고 잘 따르는 강아지 같은 연애 스타일! 자기감정에 솔직하고 애정 표현에 익숙한 당신, 밀고 당기기보단 감정 표현을 솔직히 하는 성향으로 내숭이 없네요. 하지만! 작은 일에 감정 기복이 큰 성향을 갖고 있으니, 이런 유형일 수록 자신의 의사를 확실하게 말하는 게 중요해요. 너무 사교적인 나머지 상대방이 질투로 인한 다툼이 있을 수 있으니, 언제나 조심하세요!" /></div>
									</div>
									<!-- 유형2 (고양이) -->
									<div class="grouping result2" style="display:none" id="cat">
										<div class="type"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/txt_result2.png" alt="고양이 유형 나만의 공간과 시간이 필요하지 않으세요? 자유로운 생활을 추구하는 고양이 같은 연애 스타일! 혼자만의 시간을 좋아하고, 누군가에게 기대지 않아도 혼자서도 잘 해결해내는 당신, 상대방에게 기대하지도, 애정을 구걸하지도 않는 성향이네요. 하지만! 그만큼 상대를 잘 믿지 않기 때문에, 상대가 마음을 열고 다가가기 힘들어할 수도 있을 것 같아요. 상대가 마음을 열 수 있도록 조금 더 친근하게 대하는 것도 좋을 것 같습니다. " /></div>
									</div>
									<!-- 유형3 (여우)-->
									<div class="grouping result3" style="display:none" id="fox">
										<div class="type"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/txt_result3.png" alt="여우 유형 나도 모르게 상대방의 반응에계산하고 있지 않나요? 천성적인 밀당의 고수 타입! 눈치가 빠른 스타일로, 상대방의 반응에 따라 빠르게 변화하는 연애 스타일 밀고 당기기를 일부러 하지 않아도 자연스럽게몸에 배어 있어 주변 이성들에게 인기가 좋네요. 하지만! 즉흥적인 감정이 아닌, 계산된 행동으로 상대에게 들켜, 서운하게 할 수 있을 것 같네요. 지나친 계산 대신, 가끔은 끌리는 대로 행동해보면어떨까요?" /></div>
									</div>
									<!-- 유형4 (곰)-->
									<div class="grouping result4" style="display:none" id="bear">
										<div class="type"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/txt_result4.png" alt="곰 유형1 단순하다는 이야기 많이 듣지 않나요? 깊이 생각하는걸 별로 좋아하지 않고, 편한 걸 추구하는 친구 같은 연애 스타일!상대방의 이야기를 잘 들어주는 성향이네요.겉보기로는 소심해 보이지만 한번 마음 먹고 움직이면실행력, 적극성 최고인 스타일입니다.그래서, 가끔 꽂히는 상대가 나타나면 적극적으로 변하기도 해서 곰 유형의 사람들은 연상연하 커플이 많습니다." /></div>
									</div>
									<button class="btnMore" onClick="fnResetTest();"><img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/btn_restart.png" alt="다시테스트하기" /></button>
<%
'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg, vAppLink, vAdrVer, vLink, vTitle
snpTitle = Server.URLEncode("재미로 보는 연애 유형 test")
snpLink = Server.URLEncode("http://m.10x10.co.kr/playing/view.asp?didx=138")
snpPre = Server.URLEncode("텐바이텐 Playing")
snpTag = Server.URLEncode("텐바이텐 Playing")
snpTag2 = Server.URLEncode("#10x10")
snpImg = "http://webimage.10x10.co.kr/play2016/2017/11/20170901105056_0e566.jpg"	'상단에서 생성
vLink = "http://m.10x10.co.kr/playing/view.asp?didx=138"
vTitle = "재미로 보는 연애 유형 test"
if inStr(lcase(vLink),"appcom")>0 then
	vAppLink = vLink
else
	vAppLink = replace(vLink,"m.10x10.co.kr/","m.10x10.co.kr/apps/appcom/wish/web2014/")
end If
	'APP 버전 접수
	vAdrVer = mid(uAgent,instr(uAgent,"tenapp")+8,5)
	if Not(isNumeric(vAdrVer)) then vAdrVer=1.0
%>

									<div class="snsShare">
										<img src="http://webimage.10x10.co.kr/playing/thing/vol022/m/txt_share.png" alt="친구에게 테스트 추천하기" usemap="#shareMap"/>
										<ul>
											<li><a href="javascript:popSNSPost2('fb','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');">페이스북 공유</a></li>
											<% if isApp=1 then %>
											<li><a href="#" onClick="return false;" id="kakaoa">카카오톡 공유</a></li>
											<script>
												//카카오 SNS 공유
										<%
											'// 아이폰 1.998, 안드로이드 1.92 이상부터는 카카오링크 APPID 변경 (2017.07.12; 허진원)
											if (flgDevice="I" and vAdrVer>="1.998") or (flgDevice="A" and vAdrVer>="1.92") then
										%>
												Kakao.init('b4e7e01a2ade8ecedc5c6944941ffbd4');
										<%	else %>
												Kakao.init('c967f6e67b0492478080bcf386390fdd');
										<%	end if %>

												// 카카오톡 링크 버튼을 생성합니다. 처음 한번만 호출하면 됩니다.
												Kakao.Link.createTalkLinkButton({
												  //1000자 이상일경우 , 1000자까지만 전송 
												  //메시지에 표시할 라벨
												  container: '#kakaoa',
												  label: '<%=vTitle%>',
												  <% if snpImg <>"" then %>
												  image: {
													//500kb 이하 이미지만 표시됨
													src: '<%=snpImg%>',
													width: '200',
													height: '200'
												  },
												  <% end if %>
												  appButton: {
													text: '10x10 바로가기',
													webUrl : '<%=vLink%>',
													execParams :{
														android : {"url":"<%=Server.URLEncode(vAppLink)%>"},
														iphone : {"url":"<%=vAppLink%>"}
													}
												  }
												  //,
												  //installTalk : true
												});
											</script>
											<% Else %>
											<li><a href="javascript:tnKakaoLink('재미로 보는 연애 유형 test');">카카오톡 공유</a></li>
											<% End If %>
										</ul>
									</div>
								</div>
							<!-- //THING. html 코딩 영역 -->
							</div>
							<input type="hidden" name="answerval" id="answerval">