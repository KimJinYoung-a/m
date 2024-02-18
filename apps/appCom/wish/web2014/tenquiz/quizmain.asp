<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 텐퀴즈
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
	dim nowChasu, nowMonthGroup, tenquizObj, currenttime, i, vIsAdmin, adminChckChasu
	dim totalParticipants, totalWinner, userid, isSolvedChasu, isChallengeable, isEndTime

	adminChckChasu = request("adminChckChasu")	'admin 테스트용

	dim idx
	dim chasu
	dim TopTitle
	dim QuizDescription
	dim BackGroundImage
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
	dim endAlertTxt
	dim waitingAlertTxt

	'테스트 얼러트 문구

	nowChasu = replace(FormatDateTime(now(), 2), "-","")  
	if adminChckChasu <> "" then
		nowChasu = adminChckChasu
	end if
	
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
		endAlertTxt			= tenquizObj.FoneItem.FEndAlertTxt		
		waitingAlertTxt		= tenquizObj.FoneItem.FWaitingAlertTxt		
	else 		
		'DEFAULT값
		QuizDescription		= ""
		BackGroundImage		= "http://fiximage.10x10.co.kr/m/2018/tenquiz/tit_tenquiz_1.jpg"		
		QuizStatus			= "1"
		waitingAlertTxt	 	= "퀴즈 참여 시간이 아닙니다."
	end if

    totalParticipants = tenquizObj.GetNumberOfParticipants(nowChasu)
    totalWinner       = tenquizObj.GetNumberOfWinner(nowChasu, TotalQuestionCount)
	isSolvedChasu     = tenquizObj.isSolvedQuizChasu(userid, nowChasu)
	isChallengeable   = (QuizStatus = 2 and (currenttime > QuizStartDate and currenttime < QuizEndDate)) 'QuizStatus - 1 : 등록 대기,  2 : 오픈, 3 : 종료
	isEndTime		  = (currenttime > QuizEndDate and currenttime < FormatDateTime(QuizEndDate,2) and QuizEndDate <> "")
	vIsAdmin 		  = tenquizObj.isAdmin(userid)	
	vIsAdmin = chkIIF(vIsAdmin = "", false, vIsAdmin)
	if adminChckChasu <> "" then
		isChallengeable = true
		isSolvedChasu = false
	end if						
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
	});

	function startChallenge() {		
		<% if isSolvedChasu then %> //풀었던 차수이거나 퀴즈 상태가 종료, 등록 대기 상태라면		
		alert("다음에 또 도전해주세요!");
		return false;
		<% end if %>

		<% If isChallengeable Then %> 				
		<% Elseif isEndTime then %>
			alert("<%=endAlertTxt%>");
			return false;
		<% else %>
			alert("<%=waitingAlertTxt%>");
			return false;
		<% End if %>			

		<% If not(IsUserLoginOK) and application("Svr_Info") <> "Dev" and adminChckChasu = "" Then %>
			parent.calllogin();
			return false;
		<% end if %>

		$(".rules").show();
		window.parent.$('html,body').animate({scrollTop:$(".rules").offset().top},500);
	}
	
	function moveQuiz()
	{	
		$.ajax({
			type:"GET",
			url:"/apps/appCom/wish/web2014/tenquiz/quizprechk.asp",
			data: "isadmin=<%=vIsAdmin%>&chasu=<%=nowChasu%>&adminChckChasu=<%=adminChckChasu%>",
			dataType: "text", 
			async:false,
			cache:true,
			success : function(Data, textStatus, jqXHR){
				if (jqXHR.readyState == 4) {
					if (jqXHR.status == 200) {
						if(Data!="") {
							var str;
							for(var i in Data)
							{
								 if(Data.hasOwnProperty(i))
								{
									str += Data[i];
								}
							}
							//str = str.replace("undefined","");
							res = Data.split("|");
							if (res[0]=="OK")
							{
								$(".start").show();
								startSwipe = new Swiper('.start .swiper-container',{
									loop:false,
									<% if adminChckChasu <> "" then %>
									autoplay:100,
									<% else%>
									autoplay:500,
									<% end if %>									
									speed:50,
									effect:'fade'
								});
								setTimeout(function(){
									startSwipe.destroy();
									//$(".start").hide();
									document.tenQuizMainFrm.submit();
								},
								<% if adminChckChasu <> "" then %>
								650
								<% else%>
								3250
								<% end if %>																	
								);
							}
							else
							{
								errorMsg = res[1].replace(">?n", "\n");
								alert(errorMsg);
								document.location.reload();
								return false;
							}
						} else {
							alert("잘못된 접근 입니다.");
							document.location.reload();
							return false;
						}
					}
				}
			},
			error:function(jqXHR, textStatus, errorThrown){
					alert("잘못된 접근 입니다.");
					var str;
					for(var i in jqXHR)
					{
						 if(jqXHR.hasOwnProperty(i))
						{
							str += jqXHR[i];
						}
					}
					alert(str);
					document.location.reload();
					return false;
			}
		});
	}	
</script>
<style>
.body-sub .content {padding-bottom:0;}
</style>
</head>
<body class="default-font body-sub">
	<!-- contents -->
	<div id="content" class="content tenquiz" style="min-height:100%;">
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
			<span class="month"><%=FormatNumber(right(nowMonthGroup, 2), 0)%>월</span> <!-- for dev msg 이벤트 올라가는 날짜의 '달(month)를 입력해주세요.-->
			<div class="inner">
				<p class="sub"><%=QuizDescription%></p>
				<button class="btn-challenge" onclick="startChallenge();">
					<%'<!-- for dev msg <em class="mileage">..<em> 태그는 '도전하기'이미지가 보여질 때만 노출되게 해주세요.-->%>				
					<% If isChallengeable Then %> 
						<% if isSolvedChasu then%>
							<img src="http://fiximage.10x10.co.kr/m/2018/tenquiz/btn_challenge_comp_2.png" alt="도전완료">
						<% else %>
							<em class="mileage">
							<% if TotalMileage <> "" then%>
							<img src="http://fiximage.10x10.co.kr/m/2018/tenquiz/img_<%=left(TotalMileage, len(TotalMileage) - 4)%>mlig.png" alt="<%=left(TotalMileage, len(TotalMileage) - 4)%>만">												
							<% end if %>							
							</em>						
							<img src="http://fiximage.10x10.co.kr/m/2018/tenquiz/btn_challenge.png" alt="도전하기">
						<% end if %>
					<% Elseif isEndTime then %>
						<img src="http://fiximage.10x10.co.kr/m/2018/tenquiz/btn_challenge_comp.png" alt="종료">
					<% else %>
						<img src="http://fiximage.10x10.co.kr/m/2018/tenquiz/btn_challenge_pre.png" alt="대기중">							
					<% End if %>	
				</button>
				<% If isChallengeable Then %> 
				<p class="winner">현재까지 <%=FormatNumber(totalParticipants, 0)%>명 중 <strong><%=FormatNumber(totalWinner, 0)%>명 성공</strong></p>
				<% end if %>
			</div>
		</div>
		<!--// 텐퀴즈 TOP -->

		<!-- 퀴즈 히스토리 -->
		<div class="quiz-history">
			<ul>
				<!-- for dev msg 
					- 최대 5개 까지 노출 
					- 진행상태에 따라 <li>...</li>에 지난 퀴즈: end클래스 / 진행중 퀴즈 : today / 끝난 퀴즈 : end 붙여주세요
				-->			
				<%
					dim tempDate
					dim tempMileage
					dim tempParticipants, tempWinners, tempChasu
				%>	
				<% If tenquizObj.FTotalCount > 0 Then %>				
				<% 
				for i=0 to tenquizObj.FResultCount-1	
					tempDate 		 = FormatNumber(mid(tenquizObj.FItemList(i).Fchasu,5 ,2),0) & "월 " & FormatNumber(mid(tenquizObj.FItemList(i).Fchasu,7 ,2),0) & "일"				
					tempMileage		 = left(tenquizObj.FItemList(i).FTotalMileage, len(tenquizObj.FItemList(i).FTotalMileage) - 4) & "만"
					tempParticipants = FormatNumber(tenquizObj.GetNumberOfParticipants(tenquizObj.FItemList(i).Fchasu), 0)
					tempWinners 	 = FormatNumber(tenquizObj.GetNumberOfWinner(tenquizObj.FItemList(i).Fchasu, tenquizObj.FItemList(i).FTotalQuestionCount), 0) 					
					tempChasu 		 = tenquizObj.FItemList(i).Fchasu
				 %> 
					<% If nowChasu = tenquizObj.FItemList(i).Fchasu Then 'today%>
						<% if isSolvedChasu then %>
							<% if adminChckChasu <>"" then %>							
							<li class="today" onclick="location.href='quizanswersheet.asp?chasu=<%=tempChasu%>'">
							<% else %>	
							<li class="today" onclick="fnAPPpopupBrowserURL('TenQuiz','<%=wwwUrl%>/apps/appCom/wish/web2014/tenquiz/quizanswersheet.asp?chasu=<%=tempChasu%>');return false;">							
							<% end if %>
								<span class="progress">TODAY</span>
								<span class="date">
									<%= tempDate%>						
								</span>																				
								<span><a href="">제출문제보기</a></span>							
							</li>							
						<% else %>
							<li class="today">
								<span class="progress">TODAY</span>
								<span class="date">
									<%= tempDate%>						
								</span>
								<span><%=tempMileage%></span>
							</li>											
						<% end if %>
					<% Elseif nowChasu > tenquizObj.FItemList(i).Fchasu then 'end%>				
						<li class="end">
							<span class="progress">END</span>
							<span class="date">
								<%=tempDate%><br>							
								<em class="record"><%=tempParticipants%>명 중 <%=tempWinners%>명 성공</em>																		
							</span>					
							<% if adminChckChasu <>"" then %>							
								<span><a href="quizanswersheet.asp?chasu=<%=tempChasu%>">지난문제보기</a></span>							
							<% else %>
								<span><a href="" onclick="fnAPPpopupBrowserURL('TenQuiz','<%=wwwUrl%>/apps/appCom/wish/web2014/tenquiz/quizanswersheet.asp?chasu=<%=tempChasu%>');return false;">지난문제보기</a></span>
							<% end if %>
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
		<!--// 퀴즈 히스토리 -->

		<!-- 룰 레이어 : '도전하기' 버튼 클릭시 팝업됨-->
		<div class="rules">
			<div class="inner">
				<img src="http://fiximage.10x10.co.kr/m/2018/tenquiz/txt_rule.png?v=1.01" alt="rules" />
				<button class="btn-close"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/btn_close.png" alt="닫기" /></button>
				<a href="javascript:moveQuiz();" class="btn-start"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/btn_start.png?v=1.1" alt="START!" /></a>
			</div>
		</div>
		<!--// 룰 레이어 -->

		<!-- 17주년 메인으로 이동 (10/10~10/31 노출)-->
		<% if now() < #10/31/2018 00:00:00# then %>
		<a href="javascript:fnAPPpopupBrowserURL('슬기로운 텐텐생활','<%=wwwUrl%>/apps/appcom/wish/web2014/event/17th/index.asp');"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_bnr_main.jpg" alt="텐텐 슬기로운 생활 17주년 메인으로 이동" /></a>		
		<% end if %>
	</div>
	<form name="tenQuizMainFrm" id="tenQuizMainFrm" method="post" action="quizaction.asp">
		<input type="hidden" name="isadmin" value="<%=vIsAdmin%>">
		<input type="hidden" name="tenquizreferer" value="">
		<input type="hidden" name="TotalQuestionCount" value="<%=TotalQuestionCount%>">							
		<input type="hidden" name="chasu" value="<%=nowChasu%>">
		<input type="hidden" name="adminChckChasu" value="<%=adminChckChasu%>">
	</form>	
	<!-- //contents -->	
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incfooter.asp" -->    
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->