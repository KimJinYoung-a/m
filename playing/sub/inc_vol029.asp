<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'##########################################################################
' Description : 모든 테스트 참여자분들께 텐바이텐 100마일리지를 드립니다!
' History : 2017.12.01 정태훈
'##########################################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->
<%
dim eCode, vUserID, currenttime, subscriptcoun, subscriptcount, systemok, sqlstr, vDIdx, vUserName

IF application("Svr_Info") = "Dev" THEN
	eCode = "67469"
Else
	eCode = "82744"
End If
vDIdx = request("didx")
currenttime = now()

vUserID = GetEncLoginUserID()
vUserName = GetLoginUserName()
subscriptcount=0

'//본인 참여 여부
if vUserID<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, vUserID, "", "" ,"")
End If
%>
<style type="text/css">
.liking .topic {position:relative;}
.btn-start {position:absolute; bottom:8.47%; left:50%; width:62.18%; margin-left:-31.09%;}
.test {display:none; position:relative; width:100%; height:100%; background-color:#f78787;}
.test .question {padding-bottom:6.037%;}
.question, .ly-result {position:absolute; top:0; left:0; width:100%; height:100%;}

.question1 {display:block; background-color:#f78787;}
.question2 {background-color:#96ba47;}
.question3 {background-color:#4eb6d4;}
.question4 {background-color:#e9a23c;}
.question5 {background-color:#bc92cc;}
.question6 {background-color:#6b95d5;}
.question7 {background-color:#66c394;}
.question ul {overflow:hidden; padding:0 2.5%;}
.question li {float:left; width:50%; padding:0 0.625%;}
.question li:nth-child(n+3) {margin-top:1%;}
.question button {overflow:hidden; display:block; position:relative; width:100%; background-color:transparent;}
.question button.on:before {content:' '; position:absolute; top:0; left:0; width:100%; height:100%; background:rgba(0, 0, 0, 0.4) url(http://webimage.10x10.co.kr/playing/thing/vol029/m/bg_border.png?v=1.0) no-repeat 50% 0; background-size:100% auto;}
.question button:after {content:' '; position:absolute; top:0; left:0; width:13.85%; height:100%; background:url(http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_no_a.gif) no-repeat 0 0; background-size:100% auto;}
.question li:nth-child(2) button:after {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_no_b.gif);}
.question li:nth-child(3) button:after {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_no_c.gif);}
.question li:nth-child(4) button:after {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_no_d.gif);}
.question .icon {visibility:hidden; position:absolute; top:0; left:0; width:100%; height:100%; transform:translateY(-30px); transition:transform 0.4s ease-in-out 0s;}
.question .on .icon {visibility:visible; transform:translateY(0);}
.loading {display:none; position:absolute; top:0; left:0; width:100%;}
.loading .bar {position:absolute; top:52.71%; left:38.125%; width:9.4%;}

.ly-result {display:none; z-index:20; background-color:#27c3c6;}
.ly-result .desc {position:relative;}
.ly-result .name {position:absolute; top:22%; left:0; width:100%; color:#000; font-size:1.5rem; text-align:center;}
.article1 .name b, .article1 .sum b {color:#2a00c4;}
.article2 .name b, .article2 .sum b {color:#2c7e00;}
.article3 .name b, .article3 .sum b {color:#003cc4;}
.article4 .name b, .article4 .sum b {color:#dd5c01;}
.article5 .name b, .article5 .sum b {color:#d2357e;}
.btn-item {display:block; width:90.93%; margin:0 auto;}

.my-choice-item {display:none; padding-top:3.465rem; background-color:#b1e8e9;}
.my-choice-item .inner {position:relative; width:29.5rem; margin:0 auto;}
.my-choice-item h3 {position:absolute; top:0.35rem; left:0.2rem; width:14.35rem;}
.my-choice-item ul {overflow:hidden;}
.my-choice-item li {float:left; width:14.35rem; height:14.35rem; margin:0.35rem 0.2rem 0; padding:0.25rem; background-color:#fff;}
.my-choice-item li:first-child {margin-left:15rem;}

.for-you {padding:3.4rem 0 2.7rem; text-align:center;}
.for-you .sum {font-size:1.45rem; line-height:2.2rem;}
.for-you .btn-item {margin-top:1.4rem;}

.sns-liking {display:none; padding:5% 0; background-color:#91bdbe;}
.sns-liking ul {text-align:center;}
.sns-liking li {display:inline-block; width:15.625%; margin:0 4%;}

.shake {animation:shake 5s 1; animation-fill-mode:both;}
@keyframes shake {
	0%, 100% {transform:translateX(0);}
	10%, 30%, 50%, 70%, 90% {transform:translateX(-10px);}
	20%, 40%, 60%, 80% {transform:translateX(10px);}
}

@keyframes flash {
	0%, 50%, 100% {opacity:1;}
	25%, 75% {opacity:0;}
}
.flash {animation: flash 3s 2; animation-fill-mode:both;}
</style>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript">
$(function() {
	var position = $("#liking").offset();
	$('html,body').animate({scrollTop : position.top}, 100);

	$("#btn-restart").on("click", function(e){
		$("#test .question").hide();
		$("#test .question1").show();
		$("#test, #my-choice-item, #sns-liking").hide();
		$("#topic").fadeIn(300);
		$("#result1").hide();
		$("#result2").hide();
		$("#result3").hide();
		$("#result4").hide();
		$("#result5").hide();
		$("#result12").hide();
		$("#result12").hide();
		$("#result13").hide();
		$("#result14").hide();
		$("#result15").hide();
		$("#answerA").val(0);
		$("#answerB").val(0);
		$("#answerC").val(0);
		$("#answerD").val(0);
		$(".for-you>div").removeClass();
		return false;
	});

	/* test */
	$("#test .question").hide();
	$("#test .question:first").show();
	$("#test .question button").on("click", function(e){
		$(".question button").removeClass("on");
		if ($(this).parent("li").parent("ul").parent(".question").hasClass("question7")) {
			$("#test .question6").show();
			$("#loading").fadeIn(200);
			setTimeout(function(){
				$("#test .ly-result, #my-choice-item, #sns-liking").fadeIn();
			},1500);
		} else {
			$(this).addClass("on");
			$("#test .question").delay(150).hide(0);
			$(this).parent("li").parent("ul").parent(".question").next().fadeIn(200);
		}
	});
});

function fnStartCheck(){
	<% If vUserID = "" Then %>
		<% If isApp="1" or isApp="2" Then %>
		calllogin();
		return false;
		<% else %>
		jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
		return false;
		<% end if %>
	<% Else %>
		$("#test").fadeIn(300);
		$("#topic, #lyResult, #loading").hide();
		return false;
	<% End If %>
}

function fnChoiceAnswer(objval,itemid,swich){
	var badge=0;
	if(objval=="A")
	{
		$("#answerA").val(Number($("#answerA").val())+1);
	}
	else if(objval=="B")
	{
		$("#answerB").val(Number($("#answerB").val())+1);
	}
	else if(objval=="C")
	{
		$("#answerC").val(Number($("#answerC").val())+1);
	}
	else if(objval=="D")
	{
		$("#answerD").val(Number($("#answerD").val())+1);
	}
	<% If isApp="1" or isApp="2" Then %>
	$("#resultitem"+swich).empty().html("<a href='javascript:AppsProductLink(" + itemid + ");'><img src='http://webimage.10x10.co.kr/playing/thing/vol029/m/img_item_" + itemid + ".jpg' /></a>");
	<% else %>
	$("#resultitem"+swich).empty().html("<a href='/category/category_itemPrd.asp?itemid=" + itemid + "' target='_blank'><img src='http://webimage.10x10.co.kr/playing/thing/vol029/m/img_item_" + itemid + ".jpg' /></a>");
	<% end if %>

	if(swich==7)
	{
		if($("#answerA").val()>3){
			$("#result1").show();
			$("#result11").show();
			$(".for-you>div").addClass("article2");
			badge=1;
		}
		else if($("#answerB").val()>3){
			$("#result2").show();
			$("#result12").show();
			$(".for-you>div").addClass("article3");
			badge=2;
		}
		else if($("#answerC").val()>3){
			$("#result3").show();
			$("#result13").show();
			$(".for-you>div").addClass("article1");
			badge=3;
		}
		else if($("#answerD").val()>3){
			$("#result4").show();
			$("#result14").show();
			$(".for-you>div").addClass("article4");
			badge=4;
		}
		else
		{
			$("#result5").show();
			$("#result15").show();
			$(".for-you>div").addClass("article5");
			badge=5;
		}
		<% if subscriptcount = "0" then %>
			var reStr;
			var str = $.ajax({
				type: "GET",
				url:"/playing/sub/doEventSubscript82744.asp",
				data: "mode=down&gubunval="+badge,
				dataType: "text",
				async: false
			}).responseText;
				reStr = str.split("|");
				if(reStr[0]=="OK"){
					if(reStr[1] == "dn") {
						//alert('응모가 완료 되었습니다!');
						return false;
					}else{
						alert('오류가 발생했습니다.');
						return false;
					}
				}else{
					errorMsg = reStr[1].replace(">?n", "\n");
					//alert(errorMsg);
					return false;
				}
		<% end if %>
	}
}
function AppsProductLink(itemid){
//	alert("ok");
	fnAPPpopupBrowserURL("상품정보","<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=" + itemid);
}
function tnKakaoLink(title){
	parent_kakaolink(title , 'http://webimage.10x10.co.kr/playing/thing/vol029/m/img_kakao.png' , '200' , '200' , 'http://m.10x10.co.kr/playing/view.asp?didx=178');
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
</head>
<input type="hidden" name="answerA" id="answerA">
<input type="hidden" name="answerB" id="answerB">
<input type="hidden" name="answerC" id="answerC">
<input type="hidden" name="answerD" id="answerD">
					<!-- THING. html 코딩 영역 : 클래스명은 thing+볼륨 예) thingVol001 / 이미지폴더는 볼륨을 따라 vol001 -->
					<!-- Vol.029 쇼핑 패턴 탐구생활 _ 취향편 -->
					<div id="liking" class="thingVol029 liking">
						<div id="topic" class="section topic">
							<p><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/txt_liking.png" alt="장바구니 탐구생활 취향편 취향으로 알아보는 연애 능력 TEST 모든 테스트 참여자분들께 텐바이텐 100 마일리지를 드립니다. 이벤트 기간 12월 4일 월 ~ 12월 11일 월까지며, 마일리지는 12월 12일 이후 일괄 지급" /></p>
							<a href="#test" onClick="fnStartCheck();" id="btn-start" class="btn-start shake"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/btn_test_start.png" alt="TEST START" /></a>
						</div>

						<!-- test -->
						<div id="test" class="section test">
							<div><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/bg_height.png" alt="" /></div>
							<div class="question question1">
								<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/tit_question_01.gif?v=1.0" alt="당신의 취향을 Select 해주세요! 메모지" /></h3>
								<ul>
									<li><button type="button" onclick="fnChoiceAnswer('A',1831165,1);"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/img_item_1831165.jpg?v=1.0" /><span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_check.png?v=1.0" alt="" /></span></button></li>
									<li><button type="button" onclick="fnChoiceAnswer('B',1805630,1);"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/img_item_1805630.jpg?v=1.0" /><span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_check.png?v=1.0" alt="" /></span></button></li>
									<li><button type="button" onclick="fnChoiceAnswer('C',1848189,1);"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/img_item_1848189.jpg?v=1.0" /><span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_check.png?v=1.0" alt="" /></span></button></li>
									<li><button type="button" onclick="fnChoiceAnswer('D',1219392,1);"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/img_item_1219392.jpg?v=1.0" /><span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_check.png?v=1.0" alt="" /></span></button></li>
								</ul>
							</div>
							<div class="question question2">
								<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/tit_question_02.gif" alt="가랜드" /></h3>
								<ul>
									<li><button type="button" onclick="fnChoiceAnswer('A',1216046,2);"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/img_item_1216046.jpg" /><span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_check.png?v=1.0" alt="" /></span></button></li>
									<li><button type="button" onclick="fnChoiceAnswer('B',1779635,2);"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/img_item_1779635.jpg" /><span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_check.png?v=1.0" alt="" /></span></button></li>
									<li><button type="button" onclick="fnChoiceAnswer('C',1847025,2);"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/img_item_1847025.jpg" /><span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_check.png?v=1.0" alt="" /></span></button></li>
									<li><button type="button" onclick="fnChoiceAnswer('D',1778509,2);"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/img_item_1778509.jpg" /><span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_check.png?v=1.0" alt="" /></span></button></li>
								</ul>
							</div>
							<div class="question question3">
								<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/tit_question_03.gif" alt="가습기" /></h3>
								<ul>
									<li><button type="button" onclick="fnChoiceAnswer('A',1629647,3);"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/img_item_1629647.jpg" /><span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_check.png?v=1.0" alt="" /></span></button></li>
									<li><button type="button" onclick="fnChoiceAnswer('B',1852196,3);"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/img_item_1852196.jpg" /><span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_check.png?v=1.0" alt="" /></span></button></li>
									<li><button type="button" onclick="fnChoiceAnswer('C',1400713,3);"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/img_item_1400713.jpg" /><span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_check.png?v=1.0" alt="" /></span></button></li>
									<li><button type="button" onclick="fnChoiceAnswer('D',1846945,3);"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/img_item_1846945.jpg" /><span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_check.png?v=1.0" alt="" /></span></button></li>
								</ul>
							</div>
							<div class="question question4">
								<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/tit_question_04.gif" alt="러그" /></h3>
								<ul>
									<li><button type="button" onclick="fnChoiceAnswer('A',1759915,4);"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/img_item_1759915.jpg" /><span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_check.png?v=1.0" alt="" /></span></button></li>
									<li><button type="button" onclick="fnChoiceAnswer('B',1798987,4);"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/img_item_1798987.jpg" /><span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_check.png?v=1.0" alt="" /></span></button></li>
									<li><button type="button" onclick="fnChoiceAnswer('C',1108383,4);"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/img_item_1108383.jpg" /><span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_check.png?v=1.0" alt="" /></span></button></li>
									<li><button type="button" onclick="fnChoiceAnswer('D',1644215,4);"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/img_item_1644215.jpg" /><span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_check.png?v=1.0" alt="" /></span></button></li>
								</ul>
							</div>
							<div class="question question5">
								<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/tit_question_05.gif" alt="머플러" /></h3>
								<ul>
									<li><button type="button" onclick="fnChoiceAnswer('A',1845266,5);"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/img_item_1845266.jpg" /><span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_check.png?v=1.0" alt="" /></span></button></li>
									<li><button type="button" onclick="fnChoiceAnswer('B',1843854,5);"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/img_item_1843854.jpg" /><span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_check.png?v=1.0" alt="" /></span></button></li>
									<li><button type="button" onclick="fnChoiceAnswer('C',1608586,5);"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/img_item_1608586.jpg" /><span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_check.png?v=1.0" alt="" /></span></button></li>
									<li><button type="button" onclick="fnChoiceAnswer('D',1402474,5);"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/img_item_1402474.jpg" /><span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_check.png?v=1.0" alt="" /></span></button></li>
								</ul>
							</div>
							<div class="question question6">
								<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/tit_question_06.gif" alt="무드등" /></h3>
								<ul>
									<li><button type="button" onclick="fnChoiceAnswer('A',1744727,6);"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/img_item_1744727.jpg" /><span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_check.png?v=1.0" alt="" /></span></button></li>
									<li><button type="button" onclick="fnChoiceAnswer('B',1672963,6);"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/img_item_1672963.jpg" /><span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_check.png?v=1.0" alt="" /></span></button></li>
									<li><button type="button" onclick="fnChoiceAnswer('C',1788201,6);"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/img_item_1788201.jpg" /><span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_check.png?v=1.0" alt="" /></span></button></li>
									<li><button type="button" onclick="fnChoiceAnswer('D',1810014,6);"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/img_item_1810014.jpg" /><span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_check.png?v=1.0" alt="" /></span></button></li>
								</ul>
							</div>
							<div class="question question7">
								<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/tit_question_07.gif" alt="머그컵" /></h3>
								<ul>
									<li><button type="button" onclick="fnChoiceAnswer('A1',1088728,7);"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/img_item_1088728.jpg" /><span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_check.png?v=1.0" alt="" /></span></button></li>
									<li><button type="button" onclick="fnChoiceAnswer('B',1719003,7);"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/img_item_1719003.jpg" /><span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_check.png?v=1.0" alt="" /></span></button></li>
									<li><button type="button" onclick="fnChoiceAnswer('C',890506,7);"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/img_item_890506.jpg" /><span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_check.png?v=1.0" alt="" /></span></button></li>
									<li><button type="button" onclick="fnChoiceAnswer('D',1398608,7);"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/img_item_1398608.jpg" /><span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_check.png?v=1.0" alt="" /></span></button></li>
								</ul>
							</div>
							<p id="loading" class="loading">
								<img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/txt_loading_v1.png" alt="취향 분석중..." />
								<span class="bar flash"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/img_loading_animation.png" alt="" /></span>
							</p>
							<div id="lyResult" class="ly-result">
								<!-- for dev msg : 결과 1 -->
								<div class="article article1" id="result3" style="display:none;">
									<div class="desc">
										<div class="name"><b><%=vUserName%></b>님은</div>
										<p><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/txt_result_01_v1.gif?v=1.0" alt="계산 능력자! 밀당능력 70% 표현력 20% 시력 10% 마음을 잘 읽는 당신은 밀당 능력이 뛰어나네요. 하지만 상대방의 마음을 계산하면서 당신을 맞추고 있지는 않나요? 좀 더 진솔한 연애를 위해, 계산 없이 있는 그대로의 나를 표현해도 괜찮을 것 같습니다. 최종 분석 결과 당신은 멀티태스크, 실용주의 상품이 어울릴 것 같아요." /></p>
									</div>
								</div>

								<!-- for dev msg : 결과 2 -->
								<div class="article article2" id="result1" style="display:none;">
									<div class="desc">
										<div class="name"><b><%=vUserName%></b>님은</div>
										<p><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/txt_result_02_v1.gif" alt="환승 능력자! 밀당능력 65% 표현력 40% 시력 70% 당신은 환승능력자인 걸 알고 있나요? 알고 보면 연애 고수 중에 고수인 당신! 하지만 표현하지 않으면 능력을 발휘하기 어려울 거에요. 마음에 드는 사람이 있다면 조금만 더 적극적으로 다가가보세요! 최종 분석 결과 당신은 화려하고 예쁜 상품이 어울릴 것 같아요." /></p>
									</div>
								</div>

								<!-- for dev msg : 결과 3 -->
								<div class="article article3" id="result2" style="display:none;">
									<div class="desc">
										<div class="name"><b><%=vUserName%></b>님은</div>
										<p><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/txt_result_03_v1.gif" alt="슈퍼노말 능력자! 밀당능력 40% 표현력 50% 시력 42% 가장 보통의 연애를 해온 당신! 기본적인 것을 잘 지키는 재주로 모든 연애 능력을 적당하게 유지하고 있네요. 이번 기회에 밀당 능력을 더 키워 좀 더 화끈한 연애를 해보는 건 어떨까요? 최종 분석 결과 당신은 기본적이고, 모던한 상품이 어울릴 것 같아요." /></p>
									</div>
								</div>

								<!-- for dev msg : 결과 4 -->
								<div class="article article4" id="result4" style="display:none;">
									<div class="desc">
										<div class="name"><b><%=vUserName%></b>님은</div>
										<p><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/txt_result_04_v1.gif" alt="웃음사냥 능력자! 밀당능력 30% 표현력 70% 시력 46% 자유로운 연애를 추구하는 당신은 사람들을 웃게 하는 매력이 있어요. 하지만 자신도 모르게 감정을 어필만 하고 있진 않은 지 생각해 볼 필요가 있습니다. 상대의 마음을 조금만 더 신경 쓴다면 당신의 연애 능력은 Up! 최종 분석 결과 당신은 기본적이고, 모던한 상품이 어울릴 것 같아요." /></p>
									</div>
								</div>

								<!-- for dev msg : 결과 5 -->
								<div class="article article5" id="result5" style="display:none;">
									<div class="desc">
										<div class="name"><b><%=vUserName%></b>님은</div>
										<p><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/txt_result_05_v1.gif" alt="만능 소화 능력자! 밀당능력 10% 표현력 90% 시력 35% 어떤 상대와도 잘 맞는 당신은 많은 이성에게 호감을 얻을 것 같습니다. 하지만 뚜렷한 취향이 없어 끌리는 대로 상대를 만나지 않나요? 밀당 하지 않는 솔직한 매력도 좋지만, 때로는 편식도 필요할 것 같아요. 최종 분석 결과 당신은 취향이 고르게 분산되어 있어 어떤 상품도 잘 어울릴 것 같아요." /></p>
									</div>
								</div>
								<a href="#topic" id="btn-restart" class="btn-restart"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/btn_retest_v1.gif?v=1.0" alt="테스트 다시 하기" /></a>
							</div>
						</div>

						<!-- 내가 선택한 상품 -->
						<div id="my-choice-item" class="my-choice-item">
							<div class="inner">
								<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/tit_my_choice_item.gif" alt="내가 선택한 상품" /></h3>
								<ul>
									<li id="resultitem1"></li>
									<li id="resultitem2"></li>
									<li id="resultitem3"></li>
									<li id="resultitem4"></li>
									<li id="resultitem5"></li>
									<li id="resultitem6"></li>
									<li id="resultitem7"></li>
								</ul>
							</div>
							<!-- for dev msg : 결과에 따라 클래스명 article1 ~ article5붙여주세요 -->
							<div class="for-you">
								<!-- 결과 1 -->
								<div id="result13" style="display:none">
								<p class="sum">계산 능력자 <b><%=vUserName%></b>님을 위한</p>
								<a href="/event/eventmain.asp?eventid=82741" target="_blank" class="btn-item mWeb"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/btn_item.gif" alt="맞춤 상품 보러 가기" /></a>
								<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=82738');" target="_blank" class="btn-item mApp"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/btn_item.gif" alt="맞춤 상품 보러 가기" /></a>
								</div>
								<div id="result11" style="display:none">
								<!-- 결과 2 -->
								<p class="sum">환승 능력자 <b><%=vUserName%></b>님을 위한</p>
								<a href="/event/eventmain.asp?eventid=82739" target="_blank" class="btn-item mWeb"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/btn_item.gif" alt="맞춤 상품 보러 가기" /></a>
								<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=82739');" target="_blank" class="btn-item mApp"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/btn_item.gif" alt="맞춤 상품 보러 가기" /></a>
								</div>
								<div id="result12" style="display:none">
								<!-- 결과 3 -->
								<p class="sum">슈퍼노말 <b><%=vUserName%></b>님을 위한</p>
								<a href="/event/eventmain.asp?eventid=82740" target="_blank" class="btn-item mWeb"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/btn_item.gif" alt="맞춤 상품 보러 가기" /></a>
								<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=82740');" target="_blank" class="btn-item mApp"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/btn_item.gif" alt="맞춤 상품 보러 가기" /></a>
								</div>
								<div id="result14" style="display:none">
								<!-- 결과 4 -->
								<p class="sum">웃음사냥 능력자 <b><%=vUserName%></b>님을 위한</p>
								<a href="/event/eventmain.asp?eventid=82741" target="_blank" class="btn-item mWeb"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/btn_item.gif" alt="맞춤 상품 보러 가기" /></a>
								<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=82741');" target="_blank" class="btn-item mApp"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/btn_item.gif" alt="맞춤 상품 보러 가기" /></a>
								</div>
								<div id="result15" style="display:none">
								<!-- 결과 5 -->
								<p class="sum">만능 소화 능력자 <b><%=vUserName%></b>님을 위한</p>
								<a href="/event/eventmain.asp?eventid=82742" target="_blank" class="btn-item mWeb"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/btn_item.gif" alt="맞춤 상품 보러 가기" /></a>
								<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=82742');" target="_blank" class="btn-item mApp"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/btn_item.gif" alt="맞춤 상품 보러 가기" /></a>
								</div>
							</div>
						</div>
<%
'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg, vAppLink, vAdrVer, vLink, vTitle
snpTitle = Server.URLEncode("취향으로 알아보는 연애능력 test")
snpLink = Server.URLEncode("http://m.10x10.co.kr/playing/view.asp?didx=178")
snpPre = Server.URLEncode("텐바이텐 Playing")
snpTag = Server.URLEncode("텐바이텐 Playing")
snpTag2 = Server.URLEncode("#10x10")
snpImg = "http://webimage.10x10.co.kr/playing/thing/vol029/m/img_kakao.png"	'상단에서 생성
vLink = "http://m.10x10.co.kr/playing/view.asp?didx=178"
vTitle = "취향으로 알아보는 연애능력 test"
if inStr(lcase(vLink),"appcom")>0 then
	vAppLink = vLink
else
	vAppLink = replace(vLink,"m.10x10.co.kr/","m.10x10.co.kr/apps/appcom/wish/web2014/")
end If
	'APP 버전 접수
	vAdrVer = mid(uAgent,instr(uAgent,"tenapp")+8,5)
	if Not(isNumeric(vAdrVer)) then vAdrVer=1.0
%>
						<div id="sns-liking" class="sns-liking">
							<ul>
								<li><a href="javascript:popSNSPost2('fb','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_facebook.png" alt="취향으로 알아보는 연애 능력 테스트 페이스북으로 공유하기" /></a></li>
								<% if isApp=1 then %>
								<li><a href="#" onClick="return false;" id="kakaoa"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_kakao.png" alt="카카오톡으로 공유하기" /></a></li>
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
								<li><a href="javascript:tnKakaoLink('취향으로 알아보는 연애능력 test');"><img src="http://webimage.10x10.co.kr/playing/thing/vol029/m/ico_kakao.png" alt="카카오톡으로 공유하기" /></a></li>
								<% End If %>
							</ul>
						</div>
					</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->