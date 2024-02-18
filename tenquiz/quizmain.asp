<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 텐퀴즈 랜딩 페이지
' History : 2018-09-13 최종원 생성
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
	dim nowChasu, nowMonthGroup, tenquizObj, currenttime, i 
	dim totalParticipants, totalWinner, userid, isSolvedChasu, isChallengeable

	dim idx
	dim chasu
	dim TopTitle
	dim QuizDescription
	dim BackGroundImage
	dim popupBackGroundImage
	dim QuestionHintNumber
	dim TotalMileage
	dim QuizStartDate
	dim QuizEndDate
	dim TotalQuestionCount
	dim StartDescription
	dim AdminRegister
	dim AdminName
	dim AdminModifyer
	dim AdminModifyerName
	dim RegistDate
	dim LastUpDate
	dim QuizStatus

	nowChasu = replace(FormatDateTime(now(), 2), "-","")  
	nowMonthGroup = left(now(),4) & mid(now(), 6, 2)		
	userid = GetEncLoginUserID()    
	currenttime = now()	

	set tenquizObj = new TenQuiz
	
	tenquizObj.FRectChasu = nowChasu 
	tenquizObj.FmonthGroupOption = nowMonthGroup
	tenquizObj.GetOneQuiz()
	tenquizObj.GetQuizList()	

	if tenquizObj.FoneItem.Fidx <> "" then 
		idx					= tenquizObj.FoneItem.Fidx											
		chasu				= tenquizObj.FoneItem.Fchasu								
		TopTitle			= tenquizObj.FoneItem.FTopTitle				
		QuizDescription		= tenquizObj.FoneItem.FQuizDescription					
		BackGroundImage		= tenquizObj.FoneItem.FBackGroundImage					
		popupBackGroundImage= tenquizObj.FoneItem.FMWBackGroundImage					
		QuestionHintNumber	= tenquizObj.FoneItem.FQuestionHintNumber					
		TotalMileage		= tenquizObj.FoneItem.FTotalMileage								
		QuizStartDate		= tenquizObj.FoneItem.FQuizStartDate					
		QuizEndDate			= tenquizObj.FoneItem.FQuizEndDate						
		TotalQuestionCount	= tenquizObj.FoneItem.FTotalQuestionCount			
		StartDescription	= tenquizObj.FoneItem.FStartDescription
		AdminRegister		= tenquizObj.FoneItem.FAdminRegister	
		AdminName			= tenquizObj.FoneItem.FAdminName
		AdminModifyer		= tenquizObj.FoneItem.FAdminModifyer		
		AdminModifyerName	= tenquizObj.FoneItem.FAdminModifyerName	
		RegistDate			= tenquizObj.FoneItem.FRegistDate	
		LastUpDate			= tenquizObj.FoneItem.FLastUpDate	
		QuizStatus			= tenquizObj.FoneItem.FQuizStatus		
	else 		
		QuizDescription		= ""
		BackGroundImage		= "http://fiximage.10x10.co.kr/m/2018/tenquiz/tit_tenquiz_1.jpg"		
		popupBackGroundImage= "http://fiximage.10x10.co.kr/m/2018/tenquiz/txt_go_app.png"							   
		QuizStatus			= "1"
	end if

    totalParticipants = tenquizObj.GetNumberOfParticipants(nowChasu)
    totalWinner = tenquizObj.GetNumberOfWinner(nowChasu, TotalQuestionCount)
	isSolvedChasu = tenquizObj.isSolvedQuizChasu(userid, nowChasu)
	isChallengeable = (QuizStatus = 2 and (currenttime > QuizStartDate and currenttime < QuizEndDate)) 'QuizStatus - 1 : 등록 대기,  2 : 오픈, 3 : 종료
		
	popupBackGroundImage= "http://fiximage.10x10.co.kr/m/2018/tenquiz/txt_go_app.png"							   		
%>
<style type="text/css">
.start {display:none; position:fixed; left:0; top:0; z-index:100; width:100%; height:100%; background:#f5f5f5;}
.start .swiper-container {margin-top:7rem;}
</style>
<script type="text/javascript">
	$(function(){
		var position = $('.tenquiz').offset();
		$('html,body').animate({ scrollTop : position.top },300);

		// close rull layer
		$(".rules .btn-close").click(function(){
			$(".rules").hide();
		});
        // close mw layer
        $(".go-app .btn-close").click(function(){
            $(".go-app").hide();
        });        
	});

	function startChallenge() {		
        $(".go-app").show();            
	}
</script>
</head>
<body class="default-font body-sub">
	<%'<!-- //contents -->	%>
	<div id="content" class="content tenquiz">	
		<div class="start" style="display:none;">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/txt_start_1.png" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/txt_start_2.png" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/txt_start_3.png" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/txt_start_4.png" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/txt_start_5.png" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/txt_start_6.png" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/txt_start_6.png" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/txt_start_6.png" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/txt_start_6.png" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/txt_start_6.png" alt="" /></div>
				</div>
			</div>
		</div>		
		<!-- 텐퀴즈 TOP -->
		<div class="topic">
			<h2><img src="<%=BackGroundImage%>" alt="10시부터 10시까지 TEN QUIZ"></h2>
			<span class="month"><%=FormatNumber(right(nowMonthGroup, 2), 0)%>월</span> 
			<div class="inner">
				<p class="sub"><%=QuizDescription%></p>
				<button class="btn-challenge" onclick="startChallenge();">					
					<% If isChallengeable Then %> 
						<% if isSolvedChasu then%>
							<img src="http://fiximage.10x10.co.kr/m/2018/tenquiz/btn_challenge_comp_2.png" alt="도전완료">
						<% else %>
							<em class="mileage">
							<img src="http://fiximage.10x10.co.kr/m/2018/tenquiz/img_<%=left(TotalMileage, len(TotalMileage) - 4)%>mlig.png" alt="<%=left(TotalMileage, len(TotalMileage) - 4)%>만">												
							</em>						
							<img src="http://fiximage.10x10.co.kr/m/2018/tenquiz/btn_challenge.png" alt="도전하기">
						<% end if %>
					<% Else %>
						<img src="http://fiximage.10x10.co.kr/m/2018/tenquiz/btn_challenge_pre.png" alt="대기중">							
					<% End if %>	
				</button>
				<% If isChallengeable Then %> 
				<p class="winner">현재까지 <%=FormatNumber(totalParticipants, 0)%>명 중 <strong><%=FormatNumber(totalWinner, 0)%>명 성공</strong></p>
				<% end if %>
			</div>
		</div>
		<div class="quiz-history">
			<ul>					
				<%
					dim tempDate
					dim tempMileage
					dim tempParticipants, tempWinners, tempChasu
				%>	
				<% If tenquizObj.FTotalCount > 0 Then %>				
				<% 
				for i=0 to tenquizObj.FResultCount-1	
					tempDate 		 = FormatNumber(mid(tenquizObj.FItemList(i).Fchasu,5 ,2),0) & "월" & FormatNumber(mid(tenquizObj.FItemList(i).Fchasu,7 ,2),0) & "일"				
					tempMileage		 = left(tenquizObj.FItemList(i).FTotalMileage, len(tenquizObj.FItemList(i).FTotalMileage) - 4) & "만"
					tempParticipants = FormatNumber(tenquizObj.GetNumberOfParticipants(tenquizObj.FItemList(i).Fchasu), 0)
					tempWinners 	 = FormatNumber(tenquizObj.GetNumberOfWinner(tenquizObj.FItemList(i).Fchasu, tenquizObj.FItemList(i).FTotalQuestionCount), 0) 					
					tempChasu 		 = tenquizObj.FItemList(i).Fchasu
				 %> 
					<% If nowChasu = tenquizObj.FItemList(i).Fchasu Then %>
						<li class="today">
							<span class="progress">TODAY</span>
							<span class="date">
								<%= tempDate%>						
							</span>
							<span><%=tempMileage%></span>
						</li>					
					<% Elseif nowChasu > tenquizObj.FItemList(i).Fchasu then %>
						<li class="end">
							<span class="progress">END</span>
							<span class="date">
								<%= tempDate%><br/>
								<em class="record"><%=tempParticipants%>명 중 <%=tempWinners%>명 성공</em>
							</span>														
						</li>									
					<% else %>	
						<li class="coming">
							<span class="progress">COMING</span>
							<span class="date">
								<%= tempDate%>						
							</span>
							<span><%=tempMileage%></span>
						</li>								
					<% End if %>
				<% next %>
				<% end if %>
			</ul>
		</div>		
		<!-- 17주년 메인으로 이동 (10/10~10/31 노출)-->
		<% if now() < #10/31/2018 00:00:00# then %>
		<a href="/event/17th/index.asp"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_bnr_main.jpg" alt="텐텐 슬기로운 생활 17주년 메인으로 이동" /></a>		
		<% end if %>
		<%'<!-- 앱으로 이동 팝업 -->%>
		<div class="go-app" style="display:none">
			<div class="inner">
				<div><img src="<%=popupBackGroundImage%>" alt="텐바이텐 APP에서만 TEN QUIZ를 참여할 수 있습니다" /></div>
				<a href="/event/appdown/" class="btn-go" target="_blank"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/btn_app.png" alt="APP 바로가기" /></a>
				<button class="btn-close"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/btn_close_2.png" alt="닫기" /></button>
			</div>
		</div>
		<%'<!-- 앱으로 이동 팝업 -->%>     
	</div>
	<%'<!-- //contents -->	%>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incfooter.asp" -->    
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->