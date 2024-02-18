<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 설문조사
' History : 2017-01-20 이종화 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, currenttime
IF application("Svr_Info") = "Dev" THEN
	eCode = "66267"
Else
	eCode = "75840"
End If

currenttime = now()
userid = GetEncLoginUserID()

dim subscriptcountend
subscriptcountend=0

'//본인 참여 여부
if userid<>"" then
	subscriptcountend = getevent_subscriptexistscount(eCode, userid, "", "2", "")
end If
%>
<style type="text/css">
@import url(//fonts.googleapis.com/earlyaccess/nanumgothic.css);

.survey button {background-color:transparent;}

.survey .research {position:relative; padding-bottom:0.1rem; background:#f3f3f3 url(http://webimage.10x10.co.kr/eventIMG/2017/75840/m/bg_pattern_light_grey.png) repeat-y 50% 0; background-size:100% auto;}
.survey legend {overflow:hidden; visibility:hidden; position:absolute; top:-1000%; width:0; height:0; line-height:0;}
.survey .page {position:relative; width:31.5rem; height:38.8rem; margin:0 auto; padding:5.8rem 4.3rem 0; background:url(http://webimage.10x10.co.kr/eventIMG/2017/75840/m/bg_board.png) no-repeat 50% 0; background-size:100% auto;}
.survey .page2 {padding-top:10rem;}
.survey .page3 {padding-top:9.05rem;}
.survey .page4 {padding-top:4.8rem;}
.survey .page5 {padding-top:8.95rem;}
.survey .page6 {padding-top:8rem;}
.survey .page7 {padding-top:8rem;}
.survey .page8 {padding-top:10.2rem; background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/75840/m/bg_board_pink.png);}
.survey .page h3 {width:22.8rem; text-align:center;}
.survey .page .pagination {position:absolute; top:0.6rem; right:3.6rem; width:3.1rem; height:35.5rem;}
.survey .question {margin-top:2.75rem;}
.survey .page .pagination + .question {margin-top:0;}
.survey .page4 .question {margin-top:1.85rem;}
.survey .question input {font-family:'Nanum Gothic', 'Helvetica Neue', 'Helvetica', 'Arial', 'sans-serif'; font-size:1.1rem; vertical-align:top;}
.survey .question input[type=radio] {width:12px; height:12px; border-radius:50%;}
.survey .question input[type=radio]:checked {background:url(http://webimage.10x10.co.kr/eventIMG/2017/75840/m/bg_input_radio.png) no-repeat 50% 50%; background-size:0.6rem;}
.survey .question input[type=checkbox] {width:12px; height:12px; border:1px solid #444; border-radius:0;}
.survey .question input[type=checkbox]:checked {background-size:8px;}
.survey .question input[type=text] {width:100%; height:2rem; border:0; border-bottom:1px solid #044400; border-radius:0; line-height:2rem;}
.survey .question .itext {padding:0 0.5rem 0 3rem;}
.survey .page4 input,
.survey .page5 input {margin-top:1rem;}

.survey .question ul {overflow:hidden; margin-top:1.4rem;}
.survey .question ul li {float:left; width:25%; margin-top:1rem; color:#444; font-family:'Nanum Gothic', 'Helvetica Neue', 'Helvetica', 'Arial', 'sans-serif'; font-size:1.1rem;}
.survey .question1 ul li.last {overflow:hidden; width:100%; margin-top:0.5rem;}
.survey .question1 ul li.last .etc,
.survey .question1 ul li.last .itext {float:left; width:4.1rem;}
.survey .question1 ul li.last .etc {height:2rem; line-height:2rem;}
.survey .question1 ul li.last .etc input {vertical-align:middle;}
.survey .question1 ul li.last .itext {width:6.4rem; margin-top:-0.3rem; padding-left:0;}
.survey .question2 ul li,
.survey .question3 ul li {width:33.333%;}
.survey .question4 ul li {width:50%;}
.survey .question10 ul {display:table;}
.survey .question10 ul li {display:table-cell; width:auto; padding-right:2.2rem;}

.survey .question textarea {width:19.5rem; height:8rem; margin:1.2rem 0 0 3rem; border:1px solid #444; border-radius:0; font-family:'Nanum Gothic', 'Helvetica Neue', 'Helvetica', 'Arial', 'sans-serif'; font-size:1.1rem;}
.survey .page8 p {width:20.4rem; margin:0 auto;}
.survey .page8 .btnGo {width:16.2rem; margin:3.5rem auto 0;}

.survey .research .btnNext,
.survey .research .btnSubmit {position:absolute; bottom:4.5rem; left:50%; width:14.7rem; margin-left:-7.35rem;}

.noti {padding:1.5rem 0 1.7rem; background:#e3e3e3 url(http://webimage.10x10.co.kr/eventIMG/2017/75840/m/bg_pattern_grey.png) repeat-y 50% 0; background-size:100% auto;}
.noti .inner {padding:0 3.6rem;}
.noti h3 {color:#666; font-size:1.5rem; font-weight:bold; text-align:center;}
.noti h3 span {display:inline-block; width:1.65rem; height:1.65rem; margin:0 0.6rem 0.1rem 0; background:url(http://webimage.10x10.co.kr/eventIMG/2017/75840/m/blt_exclamation_mark.png) 50% 50% no-repeat; background-size:100%; vertical-align:bottom;}
.noti ul {margin-top:1.2rem;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#666; font-size:1rem; line-height:1.5em;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.5rem; left:0; width:0.4rem; height:0.1rem; background-color:#666;}
.noti p {margin-top:7%;}
</style>
<script type="text/javascript">
$(function(){
	$("#research .page").hide();
	<% IF subscriptcountend > 0 THEN %>
	$("#research .page:last").show();
	<% ELSE %>
	$("#research .page:first").show();
	<% END IF %>
});

function chkevt(v){
	<% If not(IsUserLoginOK()) Then %>
		<% If isapp="1" Then %>
			calllogin();
			return;
		<% else %>
			jsevtlogin();
			return;
		<% End If %>
	<% End IF %>
	var frm =  document.frm;
	if (v == 1){
		if(!jsChkNull("radio",frm.ex1,"Q1.어느 지역에 사시나요?")){
			return;
		}

		if(!jsChkNull("radio",frm.ex2,"Q2.고객님의 연령대가 궁금해요!")){
			return;
		}
		$(".page1").hide();
		$(".page2").show();
	}else if (v == 2){
		if(!jsChkNull("radio",frm.ex3,"Q3.텐바이텐은 어떤 느낌을 주는 서비스인가요? (중복선택가능)")){
			return;
		}

		$(".page2").hide();
		$(".page3").show();
	}else if (v == 3){

		if(!jsChkNull("radio",frm.ex4,"Q4.텐바이텐 서비스를 이용하면 어떤 생각이 드나요? (중복선택가능)")){
			return;
		}

		$(".page3").hide();
		$(".page4").show();
	}else if (v == 4){
		if(!jsChkNull("text",frm.ex5,"Q5.텐바이텐과 어울리는 연예인은 누구일까요?")){
			frm.ex5.focus();
			return;
		}

		if (GetByteLength(frm.ex5.value) > 150){
			alert("150자 까지 작성 가능합니다.");
			frm.ex5.focus();
			return;
		}

		if(!jsChkNull("text",frm.ex6,"Q6.텐바이텐과 어울리는 자동차는 어떤 브랜드의 어떤 차종일까요?\n자동차가 아닌 이동수단도 좋아요!")){
			frm.ex6.focus();
			return;
		}

		if (GetByteLength(frm.ex6.value) > 150){
			alert("150자 까지 작성 가능합니다.");
			frm.ex6.focus();
			return;
		}

		if(!jsChkNull("text",frm.ex7,"Q7.텐바이텐과 어울리는 화장품 브랜드는 무엇일까요?")){
			frm.ex7.focus();
			return;
		}

		if (GetByteLength(frm.ex7.value) > 150){
			alert("150자 까지 작성 가능합니다.");
			frm.ex7.focus();
			return;
		}

		$(".page4").hide();
		$(".page5").show();
	}else if (v == 5){

		if(!jsChkNull("text",frm.ex8,"Q8.텐바이텐과 어울리는 의류 브랜드는 무엇일까요?")){
			frm.ex8.focus();
			return;
		}

		if (GetByteLength(frm.ex8.value) > 150){
			alert("150자 까지 작성 가능합니다.");
			frm.ex8.focus();
			return;
		}

		if(!jsChkNull("text",frm.ex9,"Q9.텐바이텐이 오프라인 매장을 신규 오픈한다면,\n어떤 동네와 어울릴까요?")){
			frm.ex9.focus();
			return;
		}

		if (GetByteLength(frm.ex9.value) > 150){
			alert("150자 까지 작성 가능합니다.");
			frm.ex9.focus();
			return;
		}

		$(".page5").hide();
		$(".page6").show();
	}else if (v == 6){

		if(!jsChkNull("radio",frm.ex10,"Q10.어떤 아이템을 사려고 할때 텐바이텐이 떠오르나요? (중복선택가능)")){
			return;
		}

		$(".page6").hide();
		$(".page7").show();
	}else if (v == 7){

		if (GetByteLength(frm.etc.value) > 150){
			alert("150자 까지 작성 가능합니다.");
			frm.etc.focus();
			return;
		}

		jsEventSubmit();
	}
}

function jsEventSubmit(){
	<% If IsUserLoginOK() Then %>
		<% If now() > #01/31/2017 23:59:59# then %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% else %>
			var str = $.ajax({
				type: "POST",
				url: "/event/etc/survey/do_75840.asp",
				data: $("#frm").serialize(),
				dataType: "text",
				async: false
			}).responseText;
			console.log(str);
			var str1 = str.split("||")
			console.log(str);
			if (str1[0] == "01"){
				alert(str1[1]);
				return false;
			}else if (str1[0] == "02"){
				alert(str1[1]);
				return false;
			}else if (str1[0] == "03"){
				alert(str1[1]);
				return false;
			}else if (str1[0] == "05"){
				$(".page7").hide();
				$(".page8").show();
				return false;
			}else{
				alert('오류가 발생했습니다.');
				return false;
			}
		<% end if %>
	<% Else %>
		<% If isapp="1" Then %>
			calllogin();
			return;
		<% else %>
			jsevtlogin();
			return;
		<% End If %>
	<% End IF %>
}
</script>
<div class="evt75840 survey">
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/75840/m/txt_survey.png" alt="고객님, 질문 있어요! 텐바이텐에 애정 가득한 의견을 남겨주세요! 응답해주신 모든 고객님께 마일리지를 드립니다" /></p>

	<div id="research" class="research">
		<form name="frm" id="frm" method="post">
			<fieldset>
			<legend>설문조사 입력 폼</legend>
				<!-- page 1 -->
				<div class="page page1">
					<div class="inner">
						<div class="pagination"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75840/m/txt_pagination_01.png" alt="page 1 of 7" /></div>

						<div class="question question1">
							<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/75840/m/tit_question_01.png" alt="어느 지역에 사시나요?" /></h3>
							<ul>
								<li><input type="radio" id="city01" name="ex1" value="서울"/> <label for="city01">서울</label></li>
								<li><input type="radio" id="city02" name="ex1" value="경기도"/> <label for="city02">경기도</label></li>
								<li><input type="radio" id="city03" name="ex1" value="충청도"/> <label for="city03">충청도</label></li>
								<li><input type="radio" id="city04" name="ex1" value="전라도"/> <label for="city04">전라도</label></li>
								<li><input type="radio" id="city05" name="ex1" value="경상도"/> <label for="city05">경상도</label></li>
								<li><input type="radio" id="city06" name="ex1" value="강원도"/> <label for="city06">강원도</label></li>
								<li><input type="radio" id="city07" name="ex1" value="제주도"/> <label for="city07">제주도</label></li>
								<li><input type="radio" id="city08" name="ex1" value="해외"/> <label for="city08">해외</label></li>
								<li class="last">
									<span class="etc"><input type="radio" id="city09" name="ex1" value="99"/> <label for="city09">기타</label></span>
									<span class="itext"><input type="text" title="기타 사는 지역 입력" name="ex1text"/></span>
								</li>
							</ul>
						</div>

						<div class="question question2">
							<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/75840/m/tit_question_02.png" alt="고객님의 연령대가 궁금해요!" /></h3>
							<ul>
								<li><input type="radio" id="age01" name="ex2" value="14~20세"/> <label for="age01">14~20세</label></li>
								<li><input type="radio" id="age02" name="ex2" value="21~25세"/> <label for="age02">21~25세</label></li>
								<li><input type="radio" id="age03" name="ex2" value="26~30세"/> <label for="age03">26~30세</label></li>
								<li><input type="radio" id="age04" name="ex2" value="31~35세"/> <label for="age04">31~35세</label></li>
								<li><input type="radio" id="age05" name="ex2" value="35~40세"/> <label for="age05">35~40세</label></li>
								<li><input type="radio" id="age06" name="ex2" value="40대"/> <label for="age06">40대</label></li>
								<li><input type="radio" id="age07" name="ex2" value="50대 이상"/> <label for="age07">50대 이상</label></li>
							</ul>
						</div>
					</div>
					<button type="button" class="btnNext" onclick="chkevt(1);"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75840/m/btn_next.gif" alt="다음" /></button>
				</div>

				<!-- page 2 -->
				<div class="page page2">
					<div class="inner">
						<div class="pagination"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75840/m/txt_pagination_02.png" alt="page 2 of 7" /></div>

						<div class="question question3">
							<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/75840/m/tit_question_03.png" alt="텐바이텐은 어떤 느낌을 주는 서비스인가요? 중복선택가능" /></h3>
							<ul>
								<li><input type="checkbox" id="feeling01" name="ex3" value="예쁘다"/> <label for="feeling01">예쁘다</label></li>
								<li><input type="checkbox" id="feeling02" name="ex3" value="평범하다"/> <label for="feeling02">평범하다</label></li>
								<li><input type="checkbox" id="feeling03" name="ex3" value="유니크하다"/> <label for="feeling03">유니크하다</label></li>
								<li><input type="checkbox" id="feeling04" name="ex3" value="센스있다"/> <label for="feeling04">센스있다</label></li>
								<li><input type="checkbox" id="feeling05" name="ex3" value="재미있다"/> <label for="feeling05">재미있다</label></li>
								<li><input type="checkbox" id="feeling06" name="ex3" value="감성적이다"/> <label for="feeling06">감성적이다</label></li>
								<li><input type="checkbox" id="feeling07" name="ex3" value="귀엽다"/> <label for="feeling07">귀엽다</label></li>
								<li><input type="checkbox" id="feeling08" name="ex3" value="기대된다"/> <label for="feeling08">기대된다</label></li>
								<li><input type="checkbox" id="feeling09" name="ex3" value="올드하다"/> <label for="feeling09">올드하다</label></li>
								<li><input type="checkbox" id="feeling10" name="ex3" value="지루하다"/> <label for="feeling10">지루하다</label></li>
								<li><input type="checkbox" id="feeling11" name="ex3" value="실망스럽다"/> <label for="feeling11">실망스럽다</label></li>
							</ul>
						</div>
					</div>
					<button type="button" class="btnNext" onclick="chkevt(2);"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75840/m/btn_next.gif" alt="다음" /></button>
				</div>

				<!-- page 3 -->
				<div class="page page3">
					<div class="inner">
						<div class="pagination"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75840/m/txt_pagination_03.png" alt="page 3 of 7" /></div>

						<div class="question question4">
							<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/75840/m/tit_question_04.png" alt="텐바이텐 서비스를 이용하면 어떤 생각이 드나요? 중복선택가능" /></h3>
							<ul>
								<li><input type="checkbox" id="think01" name="ex4" value="편리하다"/> <label for="think01">편리하다</label></li>
								<li><input type="checkbox" id="think02" name="ex4" value="가격이 합리적이다"/> <label for="think02">가격이 합리적이다</label></li>
								<li><input type="checkbox" id="think03" name="ex4" value="깔끔하다"/> <label for="think03">깔끔하다</label></li>
								<li><input type="checkbox" id="think04" name="ex4" value="물건이 많다"/> <label for="think04">물건이 많다</label></li>
								<li><input type="checkbox" id="think05" name="ex4" value="명확하다"/> <label for="think05">명확하다</label></li>
								<li><input type="checkbox" id="think06" name="ex4" value="불편하다"/> <label for="think06">불편하다</label></li>
								<li><input type="checkbox" id="think07" name="ex4" value="가격이 비싸다"/> <label for="think07">가격이 비싸다</label></li>
								<li><input type="checkbox" id="think08" name="ex4" value="복잡하다"/> <label for="think08">복잡하다</label></li>
								<li><input type="checkbox" id="think09" name="ex4" value="물건이 적다"/> <label for="think09">물건이 적다</label></li>
								<li><input type="checkbox" id="think10" name="ex4" value="헷갈린다"/> <label for="think10">헷갈린다</label></li>
							</ul>
						</div>
					</div>
					<button type="button" class="btnNext" onclick="chkevt(3);"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75840/m/btn_next.gif" alt="다음" /></button>
				</div>

				<!-- page 4 -->
				<div class="page page4">
					<div class="inner">
						<div class="pagination"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75840/m/txt_pagination_04.png" alt="page 4 of 7" /></div>

						<div class="question question5">
							<h3><label for="entertainer"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75840/m/tit_question_05.png" alt="텐바이텐과 어울리는 연예인은 누구일까요?" /></label></h3>
							<div class="itext"><input type="text" name="ex5" id="entertainer" placeholder="30자 이내로 입력해주세요" maxlength="150"/></div>
						</div>

						<div class="question question6">
							<h3><label for="car"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75840/m/tit_question_06.png" alt="텐바이텐과 어울리는 자동차는 어떤 브랜드의 어떤 차종일까요? 자동차가 아닌 이동수단도 좋아요!" /></label></h3>
							<div class="itext"><input type="text" name="ex6" id="car" placeholder="30자 이내로 입력해주세요" maxlength="150"/></div>
						</div>

						<div class="question question7">
							<h3><label for="cosmetic"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75840/m/tit_question_07_v1.png" alt="텐바이텐과 어울리는 화장품 브랜드는 무엇일까요?" /></label></h3>
							<div class="itext"><input type="text" name="ex7" id="cosmetic" placeholder="30자 이내로 입력해주세요" maxlength="150"/></div>
						</div>
					</div>
					<button type="button" class="btnNext" onclick="chkevt(4);"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75840/m/btn_next.gif" alt="다음" /></button>
				</div>

				<!-- page 5 -->
				<div class="page page5">
					<div class="inner">
						<div class="pagination"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75840/m/txt_pagination_05.png" alt="page 5 of 7" /></div>

						<div class="question question8">
							<h3><label for="clothes"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75840/m/tit_question_08.png" alt="텐바이텐과 어울리는 의류 브랜드는 무엇일까요?" /></label></h3>
							<div class="itext"><input type="text" name="ex8" id="clothes" placeholder="30자 이내로 입력해주세요" maxlength="150"/></div>
						</div>

						<div class="question question9">
							<h3><label for="town"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75840/m/tit_question_09.png" alt="텐바이텐이 오프라인 매장을 신규 오픈한다면, 어떤 동네와 어울릴까요?" /></label></h3>
							<div class="itext"><input type="text" name="ex9" id="town" placeholder="30자 이내로 입력해주세요" maxlength="150"/></div>
						</div>
					</div>
					<button type="button" class="btnNext" onclick="chkevt(5);"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75840/m/btn_next.gif" alt="다음" /></button>
				</div>

				<!-- page 6 -->
				<div class="page page6">
					<div class="inner">
						<div class="pagination"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75840/m/txt_pagination_06.png" alt="page 6 of 7" /></div>

						<div class="question question10">
							<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/75840/m/tit_question_10.png" alt="어떤 아이템을 사려고 할때 텐바이텐이 떠오르나요? 중복선택가능" /></h3>
							<ul>
								<li><input type="checkbox" id="item01" name="ex10" value="문구류"/> <label for="item01">문구류</label></li>
								<li><input type="checkbox" id="item02" name="ex10" value="다이어리"/> <label for="item02">다이어리</label></li>
								<li><input type="checkbox" id="item03" name="ex10" value="가구/조명"/> <label for="item03">가구/조명</label></li>
								<li><input type="checkbox" id="item04" name="ex10" value="인테리어 아이템"/> <label for="item04">인테리어 아이템</label></li>
								<li><input type="checkbox" id="item05" name="ex10" value="키덜트 아이템"/> <label for="item05">키덜트 아이템</label></li>
								<li><input type="checkbox" id="item06" name="ex10" value="디지털 아이템"/> <label for="item06">디지털 아이템</label></li>
								<li><input type="checkbox" id="item07" name="ex10" value="의류"/> <label for="item07">의류</label></li>
								<li><input type="checkbox" id="item08" name="ex10" value="가방, 악세서리 등 패션잡화"/> <label for="item08">가방, 악세서리 등 패션잡화</label></li>
								<li><input type="checkbox" id="item09" name="ex10" value="휴대폰 케이스"/> <label for="item09">휴대폰 케이스</label></li>
								<li><input type="checkbox" id="item10" name="ex10" value="반려동물 아이템"/> <label for="item10">반려동물 아이템</label></li>
								<li><input type="checkbox" id="item11" name="ex10" value="캠핑, 여행 아이템"/> <label for="item11">캠핑, 여행 아이템</label></li>
								<li><input type="checkbox" id="item12" name="ex10" value="베이비/키즈 아이템"/> <label for="item12">베이비/키즈 아이템</label></li>
							</ul>
						</div>
					</div>
					<button type="button" class="btnNext" onclick="chkevt(6);"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75840/m/btn_next.gif" alt="다음" /></button>
				</div>

				<!-- page 7 -->
				<div class="page page7">
					<div class="inner">
						<div class="pagination"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75840/m/txt_pagination_07.png" alt="page 7 of 7" /></div>

						<div class="question question11">
							<h3><label for="story"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75840/m/tit_question_11.png" alt="답변해주셔서 감사합니다. 텐바이텐에게 전하고 싶은 이야기가 있으면 편하게 작성해주세요. 건의사항, 불만 토로, 칭찬과 응원 모두 좋습니다!" /></label></h3>
							<textarea cols="60" rows="5" name="etc" id="story" placeholder="150자 이내로 입력해주세요"></textarea>
						</div>
					</div>
					<button type="button" class="btnNext" onclick="chkevt(7);"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75840/m/btn_submit.png" alt="응답 저장하기" /></button>
				</div>

				<!-- page 8 -->
				<div class="page page8">
					<div class="inner">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/75840/m/txt_finish.gif" alt="짝짝짝! 모든 응답을 완료 하셨습니다 더욱 더 발전하는 텐바이텐이 되겠습니다!" /></p>
					</div>
				</div>
			</fieldset>
		</form>
	</div>

	<div class="mileage">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/75840/m/txt_mileage.gif" alt="여러분의 다양한 목소리에 귀 기울이겠습니다 응답을 완료하신 모든 고객님께 300 마일리지를 드립니다. 2월 1일 일괄지급" /></p>
	</div>

	<div class="noti">
		<div class="inner">
			<h3><span></span>이벤트 유의사항</h3>
			<ul>
				<li>이벤트는 ID당 1회만 참여할 수 있습니다.</li>
				<li>응답 중간에 페이지 이탈 시, 응답은 임시저장 되지 않습니다.</li>
				<li>이벤트는 조기 종료될 수 있습니다.</li>
			</ul>
		</div>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->