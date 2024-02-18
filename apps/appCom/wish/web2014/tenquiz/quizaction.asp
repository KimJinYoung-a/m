<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : TenQuiz 문항페이지
' History : 2018-09-10 최종원 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/tenquiz/TenQuizCls.asp" -->

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->		
<%
dim nowQuizNumber, i, adminChckChasu, vStartDate, vState, vChasu, userid, isTimeout
dim TotalQuestionCount, prevQuizNumber, prevQuizUserAnswer, prevQuizAnswer, tmpUserScore, quizAnswer

dim tenQuizQuestion
set tenQuizQuestion = new TenQuiz

vChasu = replace(FormatDateTime(now(), 2), "-","") 
userid = GetEncLoginUserID()

TotalQuestionCount 	= request("TotalQuestionCount")
prevQuizNumber		= request("prevQuizNumber")
prevQuizUserAnswer	= request("prevQuizUserAnswer")
prevQuizAnswer		= request("prevQuizAnswer")
vChasu 				= request("chasu")
adminChckChasu 		= request("adminChckChasu")
isTimeout			= request("timeout")

if isTimeout = "Y" then
	prevQuizUserAnswer = -1
end if

if adminChckChasu <> "" then
	vChasu = adminChckChasu
end if

If prevQuizNumber = "" Then'And InStr(LCase(tenQuizreferer),LCase("10x10.co.kr/apps/appCom/wish/web2014/playing/sub/vol040main.asp")) > 0 Then
	nowQuizNumber = 1
	prevQuizNumber = 0
else
	nowQuizNumber = prevQuizNumber + 1
end if

tenQuizQuestion.FRectChasu = vChasu
tenQuizQuestion.FRectQuestionNumber = nowQuizNumber
tenQuizQuestion.GetQuestion()

dim questionType, questionNumber, question, questionType1Image1, questionType1Image2, questionType1Image3, questionType1Image4 
dim questionExample1, questionExample2, questionExample3, questionExample4, answer, IsUsing, NumOfType1Image
dim questionExample1img, questionExample2img, questionExample3img, questionExample4img, type1imageArr()
dim type2TextExample1, type2TextExample2, type2TextExample3, type2TextExample4

questionType		= tenQuizQuestion.FoneItem.FItype
questionNumber		= tenQuizQuestion.FoneItem.FIquestionNumber
question			= tenQuizQuestion.FoneItem.FIquestion
questionType1Image1	= tenQuizQuestion.FoneItem.FIquestionType1Image1
questionType1Image2	= tenQuizQuestion.FoneItem.FIquestionType1Image2
questionType1Image3	= tenQuizQuestion.FoneItem.FIquestionType1Image3
questionType1Image4	= tenQuizQuestion.FoneItem.FIquestionType1Image4

questionExample1	= tenQuizQuestion.FoneItem.FIquestionExample1
questionExample2	= tenQuizQuestion.FoneItem.FIquestionExample2
questionExample3	= tenQuizQuestion.FoneItem.FIquestionExample3
questionExample4	= tenQuizQuestion.FoneItem.FIquestionExample4	

type2TextExample1   = tenQuizQuestion.FoneItem.FItype2TextExample1            
type2TextExample2   = tenQuizQuestion.FoneItem.FItype2TextExample2           
type2TextExample3   = tenQuizQuestion.FoneItem.FItype2TextExample3            
type2TextExample4   = tenQuizQuestion.FoneItem.FItype2TextExample4            

questionExample1img	= tenQuizQuestion.FoneItem.FIquestionExample1
questionExample2img	= tenQuizQuestion.FoneItem.FIquestionExample2
questionExample3img	= tenQuizQuestion.FoneItem.FIquestionExample3
questionExample4img	= tenQuizQuestion.FoneItem.FIquestionExample4	

quizAnswer			= tenQuizQuestion.FoneItem.FIanswer
isusing				= tenQuizQuestion.FoneItem.FIIsUsing
numOfType1Image		= tenQuizQuestion.FoneItem.FINumofType1Image   

redim preserve type1imageArr(4)

type1imageArr(0) = questionType1Image1
type1imageArr(1) = questionType1Image2
type1imageArr(2) = questionType1Image3
type1imageArr(3) = questionType1Image4

%>
<%'퀴즈 유효성 체크%>
<% if adminChckChasu = "" then %>
<!-- #include virtual="/apps/appCom/wish/web2014/tenquiz/quizchk.asp" -->
<% end if %>
<script type="text/javascript">
$(function(){
	//뒤로가기 방지
	history.pushState(null, null, location.href);
		window.onpopstate = function () {
			history.go(1);
	};	

	var position = $('.tenquiz-question').offset();	
	$('html,body').animate({ scrollTop : position.top },300);

	// quiz
	 $(".result").hide();

//============================
	var clickChk = false;
	var counter = 10;
	setInterval(function() {
			<%If adminChckChasu <> "" and (cint(prevQuizNumber) + 1 = cint(TotalQuestionCount)) Then %>
			return false;
			<% end if %>		
		counter--;
		if (counter > 0)
		{
			$("#countdown").empty().html(counter);			
		}
		if (counter === 0)
		{
			clearInterval(counter);
			QuizNextTimeOutStep("Y");
		}
	}, 1000);
	function QuizNextTimeOutStep(isTimeout)
	{	
		if(clickChk) return false;
		var timeOutPram = "";
		if(isTimeout == "Y"){
			timeOutPram = "?timeout=Y"
		}
		clickChk=true;
		document.playingQuizFrm.action="quizaction.asp"+timeOutPram;
		document.playingQuizFrm.submit();		
	}
	$(".quiz .answer .choice").click(function(){
		<%If adminChckChasu <> "" and (cint(prevQuizNumber) + 1 = cint(TotalQuestionCount)) Then %>
		return false;
		<% end if %>		
		if(clickChk) return false;
		clickChk=true;
		$(this).addClass("on");
		document.playingQuizFrm.prevQuizUserAnswer.value = $(this).index()+1;
		document.playingQuizFrm.action="quizaction.asp";
		document.playingQuizFrm.submit();
	});
});
</script>
</head>
<body class="default-font body-sub bg-grey">
	<!-- contents -->	
	<div id="content" class="content tenquiz-question">	
		<%'//퀴즈 문항 페이지%>
		<!-- #include virtual="/apps/appCom/wish/web2014/tenquiz/questions.asp" -->
		<%'//퀴즈 문항 페이지%>		
	</div>
	<!-- //contents -->
	<form method="post" name="playingQuizFrm" id="playingQuizFrm">
		<input type="hidden" name="adminChckChasu" value="<%=adminChckChasu%>">		
		<input type="hidden" name="chasu" value="<%=vChasu%>">
		<input type="hidden" name="prevQuizNumber" value="<%=prevQuizNumber+1%>">
		<input type="hidden" name="TotalQuestionCount" value="<%=TotalQuestionCount%>">		
		<input type="hidden" name="prevQuizUserAnswer" value="">
		<input type="hidden" name="prevQuizAnswer" value="<%=quizAnswer%>">		
		<input type="hidden" name="tenquizreferer" value="">		
	</form>	
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incfooter.asp" -->    
</body>
</html>

