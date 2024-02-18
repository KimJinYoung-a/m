<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : PLAYing 용돈을 부탁해
' History : 2017-01-24 유태욱 생성
'####################################################
Dim eCode , LoginUserid, vQuery, myKitgubun, vDIdx
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66268
Else
	eCode   =  75805
End If

vDIdx = request("didx")
LoginUserid		= getencLoginUserid()

%>
<style type="text/css">
.pocketMny {overflow:hidden; background-color:#fff;}
.pocketMny button {background-color:transparent;}
.pocketMny .vol007 {padding-top:1rem;}
.pocketMny .start {position:relative;}
.pocketMny .start .btnStart {position:absolute; bottom:7.5%; left:21.6%; width:55.93%; margin:0 auto; animation:bounce 1s infinite;}
.pocketMny .test {position:relative;}
.pocketMny .test .question {padding-bottom:5%; background-color:#3a87ab;}
.pocketMny .test .question2 {background-color:#54bd8d;}
.pocketMny .test .question3 {background-color:#ff923a;}
.pocketMny .test .question4 {background-color:#f69ba6;}
.pocketMny .test .question5 {background-color:#9dc53c;}
.pocketMny .test .question .btnGroup {position:relative; overflow:hidden; width:90%; margin:0 auto;}
.pocketMny .test .question .btnGroup button {float:left; position:relative; width:48.3%; }
.pocketMny .test .question .btnGroup .btnA img {animation:buttonUp 0.5s 1;}
.pocketMny .test .question .btnGroup .btnB img {animation:buttonUp 1s 1;}
.pocketMny .test .question .btnGroup .btnB {float:right; position:relative; width:48.3%;}
.pocketMny .test .question .btnGroup p{position:absolute; top:43.4%; left:44.34%;width:11.82%; }
.pocketMny .test .lyResult {position:absolute; top:0%; left:50%; width:100%; margin-left:-50%;}
.pocketMny .result {position:relative; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/playing/thing/vol007/m/img_result.jpg) no-repeat 50% 50%; background-size:100%;}
.pocketMny .result .grouping a {display:block; position:relative; width:67.18%; height:78.12%;  margin:0 auto;  padding-bottom:35%; animation:resultDown 1s 1;}
.pocketMny .result .btnMore {display:block; position:absolute; bottom:8.2%; left:26.52%; width:50.62%; z-index:20;}
.pocketMny .result .thumb {position:absolute; top:27.5%; width:100%; z-index:10;}

/* css3 animation */
@keyframes bounce {
from, to{transform:translateY(8%);}
50% {transform:translateY(0);}
}
@keyframes buttonUp {
from {transform:translateY(100px); opacity:0;}
to {transform:translateY(0); opacity:1;}
}
@keyframes resultDown {
from {transform:translateY(-60%);}
to {transform:translateY(0);}
}

</style>
<script type="text/javascript">
$(function(){

	var position = $('.pocketMny').offset(); // 위치값
	$('html,body').animate({ scrollTop : position.top }, 100); // 이동

	/* test hide */
	$("#test").hide();
	$("#result").hide();

	/* test start */
	$("#btnStart a").on("click", function(e){
		$(".start").hide();
		$(".test").show();
		$("#test .lyResult").hide();
		$("#test .question").hide();
		$("#test .question:first").show();
	});

	/* test
	$("#test .question button").on("click", function(e){
		if ( $(this).parent(".btnGroup").parent(".question").hasClass("question5")) {
			$("#test .question5").show();
			$("#test .lyResult").show();
		} else {
			$("#test .question").hide();
			$(this).parent(".btnGroup").parent(".question").next().show();
		}
	}); */
	$("#lyResult a").on("click", function(e){
		$(".test").hide();
		$(".result").show();
	});

	/* restart
	$(".btnMore").on("click", function(e){
		$(".result").hide();
		$(".start").show();
	});*/

});

function restart(){
	$("#resultviewbtn").hide();
	$("#test").hide();
	$("#lyResult").hide();
	$("#result").empty();
	$("#result").hide();
	$("#question2").hide();
	$("#question3").hide();
	$("#question4").hide();
	$("#question5").hide();
	$("#question1").show();
	$("#test").show();
	window.parent.$('html,body').animate({scrollTop:$("#question1").offset().top},700);
}

function jsplayingthing(num,sel){
<% If IsUserLoginOK() Then %>
	$.ajax({
		type: "GET",
		url: "/playing/sub/doEventSubscript75805.asp",
		data: "mode=add&num="+num+"&sel="+sel,
		cache: false,
		success: function(str) {
			str = str.replace("undefined","");
			res = str.split("|");
			if (res[0]=="OK") {
				if(num==1){
					$("#test .question").hide();
					$("#question2").show();
				}else if(num==2){
					$("#test .question").hide();
					$("#question3").show();
				}else if(num==3){
					$("#test .question").hide();
					$("#question4").show();
				}else if(num==4){
					$("#test .question").hide();
					$("#question5").show();
				}else if(num==5){
					$("#test .question5").show();
					$("#test .lyResult").show();
					$("#lyResult").show();
				}else{
					alert('잘못된 접속 입니다.1');
					parent.location.reload();
				}
			} else {
				errorMsg = res[1].replace(">?n", "\n");
				alert(errorMsg );
				return false;
			}
		}
		,error: function(err) {
			console.log(err.responseText);
			alert("통신중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
		}
	});
<% else %>
	<% If isApp="1" or isApp="2" Then %>
	calllogin();
	return false;
	<% else %>
	jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
	return false;
	<% end if %>	
<% end if %>
}

function jsplayingthingresult(){
<% If IsUserLoginOK() Then %>
	$.ajax({
		type: "GET",
		url: "/playing/sub/doEventSubscript75805.asp",
		data: "mode=result",
		cache: false,
		success: function(str) {
			str = str.replace("undefined","");
			res = str.split("|");
			if (res[0]=="OK") {
				if (res[1]=="1") {
					$("#result").empty().html(res[2]);
					$("#result").show();
					window.parent.$('html,body').animate({scrollTop:$("#result").offset().top},700);
				}else if(res[1]=="2") {
					$("#result").empty().html(res[2]);
					$("#result").show();
					window.parent.$('html,body').animate({scrollTop:$("#result").offset().top},700);
				}else if(res[1]=="3") {
					$("#result").empty().html(res[2]);
					$("#result").show();
					window.parent.$('html,body').animate({scrollTop:$("#result").offset().top},700);
				}else if(res[1]=="4") {
					$("#result").empty().html(res[2]);
					$("#result").show();
					window.parent.$('html,body').animate({scrollTop:$("#result").offset().top},700);
				}else{
					parent.location.reload();
				}
			} else {
				errorMsg = res[1].replace(">?n", "\n");
				alert(errorMsg );
				return false;
			}
		}
		,error: function(err) {
			console.log(err.responseText);
			alert("통신중 오류가 발생했습니다. 잠시 후 다시 시도해주세요..");
		}
	});
<% else %>
	<% If isApp="1" or isApp="2" Then %>
	calllogin();
	return false;
	<% else %>
	jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
	return false;
	<% end if %>	
<% end if %>
}
</script>
	<%'' THING. html 코딩 영역 : 클래스명은 thing+볼륨 예) thingVol001 / 이미지폴더는 볼륨을 따라 vol001 %>
	<div class="thingVol007 pocketMny">
		<div class="start" id="start">
			<h3 ><img src="http://webimage.10x10.co.kr/playing/thing/vol007/m/img_tit_01.jpg" alt="나의 용돈을 부탁해" /></h3> 
			<div id="btnStart" class="btnStart"><a href="#test"><img src="http://webimage.10x10.co.kr/playing/thing/vol007/m/btn_go_test.png" alt="테스트 스타트" /></a></div>
		</div>
		<div id="test" class="section test">
			<div class="question question1" id="question1" style="display:none;">
				<p><img src="http://webimage.10x10.co.kr/playing/thing/vol007/m/txt_test_01_v2.gif" alt="마트에서 장볼 때 나의 모습은?" /></p>
				<div class="btnGroup">
					<button type="button" onclick="jsplayingthing('1','A'); return false;" class="btnA"><img src="http://webimage.10x10.co.kr/playing/thing/vol007/m/btn_choice_01_a.png" alt="A 미리 적어둔 리스트를 토대로 물건을 고른다" /></button>
					<button type="button" onclick="jsplayingthing('1','B'); return false;" class="btnB"><img src="http://webimage.10x10.co.kr/playing/thing/vol007/m/btn_choice_01_b.png" alt="B 내키는 대로 이것 저것 물건을 고른다" /></button>
					<p><img src="http://webimage.10x10.co.kr/playing/thing/vol007/m/txt_verse.png" alt="vs" /></p>
				</div>
			</div>
			<div class="question question2" id="question2" style="display:none;">
				<p><img src="http://webimage.10x10.co.kr/playing/thing/vol007/m/txt_test_02.gif" alt="30만원의 공돈이 들어왔다 나는 어떻게 쓸까?" /></p>
				<div class="btnGroup">
					<button type="button" onclick="jsplayingthing('2','A'); return false;" class="btnA"><img src="http://webimage.10x10.co.kr/playing/thing/vol007/m/btn_choice_02_a.png" alt="A 비싸서 못 샀던 물건을 고민 없이 주문한다 " /></button>
					<button type="button" onclick="jsplayingthing('2','B'); return false;" class="btnB"><img src="http://webimage.10x10.co.kr/playing/thing/vol007/m/btn_choice_02_b.png" alt="B 소심하게 조금씩 작게 작게 산다 " /></button>
					<p><img src="http://webimage.10x10.co.kr/playing/thing/vol007/m/txt_verse.png" alt="vs" /></p>
				</div>
			</div>
			<div class="question question3" id="question3" style="display:none;">
				<p><img src="http://webimage.10x10.co.kr/playing/thing/vol007/m/txt_test_03.gif" alt="나의 지갑속은?" /></p>
				<div class="btnGroup">
					<button type="button" onclick="jsplayingthing('3','A'); return false;" class="btnA"><img src="http://webimage.10x10.co.kr/playing/thing/vol007/m/btn_choice_03_a.png" alt="A 모아둔 쿠폰들과 다양한 카드들" /></button>
					<button type="button" onclick="jsplayingthing('3','B'); return false;" class="btnB"><img src="http://webimage.10x10.co.kr/playing/thing/vol007/m/btn_choice_03_b.png" alt="B 심플하게 카드만 2-3장 " /></button>
					<p><img src="http://webimage.10x10.co.kr/playing/thing/vol007/m/txt_verse.png" alt="vs" /></p>
				</div>
			</div>
			<div class="question question4" id="question4" style="display:none;">
				<p><img src="http://webimage.10x10.co.kr/playing/thing/vol007/m/txt_test_04_v2.gif" alt="평소 메모습관은?" /></p>
				<div class="btnGroup">
					<button type="button" onclick="jsplayingthing('4','A'); return false;" class="btnA"><img src="http://webimage.10x10.co.kr/playing/thing/vol007/m/btn_choice_04_a.png" alt="A 중요한 메모 외에는 잘 하지 않는다" /></button>
					<button type="button" onclick="jsplayingthing('4','B'); return false;" class="btnB"><img src="http://webimage.10x10.co.kr/playing/thing/vol007/m/btn_choice_04_b.png" alt="B 매일 다이어리에 이것저것 메모한다 " /></button>
					<p><img src="http://webimage.10x10.co.kr/playing/thing/vol007/m/txt_verse.png" alt="vs" /></p>
				</div>
			</div>
			<div class="question question5" id="question5" style="display:none;">
				<p><img src="http://webimage.10x10.co.kr/playing/thing/vol007/m/txt_test_05.gif" alt="평소 나의 책상모습은?" /></p>
				<div class="btnGroup">
					<button type="button" onclick="jsplayingthing('5','A'); return false;" class="btnA"><img src="http://webimage.10x10.co.kr/playing/thing/vol007/m/btn_choice_05_a.png" alt="A 잘 어지르는 타입 '정리는 나중에 몰아서'" /></button>
					<button type="button" onclick="jsplayingthing('5','B'); return false;" class="btnB"><img src="http://webimage.10x10.co.kr/playing/thing/vol007/m/btn_choice_05_b.png" alt="B 잘 정리하는 타입 '모든 것은 제자리로'" /></button>
					<p><img src="http://webimage.10x10.co.kr/playing/thing/vol007/m/txt_verse.png" alt="vs" /></p>
				</div>
			</div>
			<div id="lyResult" class="lyResult" style="display:none;">
				<div class="btnView">
					<a href="" onclick="jsplayingthingresult(); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol007/m/btn_result_view.png" alt="모-두 선택하셨습니다! 결과 영수증을 확인하러 갈까요? 결과보기" /></a>
				</div>
			</div>
		</div>
		
		<% If IsUserLoginOK() Then %>
		<!-- result -->
		<div id="result" class="section result">
		</div>
		<% end if %>

		<div class="vol007"><img src="http://webimage.10x10.co.kr/playing/thing/vol007/m/txt_vol007.png" alt="" /></div>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->