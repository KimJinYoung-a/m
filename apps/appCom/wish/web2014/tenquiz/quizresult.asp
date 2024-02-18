<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : TenQuiz 퀴즈 결과 페이지
' History : 2018-09-10 최종원 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/tenquiz/TenQuizCls.asp" -->
<%
	dim userid, i, vUserid, vChasu, answerCount, userScore, TotalQuestionCount, totalParticipants, totalWinner, quizHint, nextChasu, nextChasuHint, referer, isShare
    dim isWinner, hintType1imageArr(), adminChckChasu

	dim hintQuestionType, hintQuestion, hintQuestionType1Image1, hintQuestionType1Image2, hintQuestionType1Image3, hintQuestionType1Image4, hintQuestionExample1, hintQuestionExample2, hintQuestionExample3, hintQuestionExample4, hintNumOfType1Image, productEvtNum
    userid = GetEncLoginUserID()    

	referer = request.ServerVariables("HTTP_REFERER")
    TotalQuestionCount = request("TotalQuestionCount")
    vChasu             = request("chasu")
	vUserid			   = request("userid")
	isShare			   = request("share")
	adminChckChasu 	   = request("adminChckChasu")

	if isShare = "" then
		isShare = 100 '임의 값 
	end if		
	if vUserid <> "" then
		userid = vUserid
	end if		
	if vChasu = "" then
		vChasu = replace(FormatDateTime(now(), 2), "-","")
	end if

    dim userMasterData
    set userMasterData = new TenQuiz
    userMasterData.FRectChasu = vChasu 
    userMasterData.FRectUserId = userid 
    userMasterData.GetUserMasterData()
	productEvtNum = userMasterData.getProductEvtNum(vChasu)

    answerCount = userMasterData.FoneItem.FManswerCount
    userScore   = userMasterData.FoneItem.FMuserScore    

    totalParticipants = userMasterData.GetNumberOfParticipants(vChasu)
    totalWinner = userMasterData.GetNumberOfWinner(vChasu, TotalQuestionCount)

    isWinner = (cint(userScore) = cint(TotalQuestionCount))
	
	nextChasu = userMasterData.getNextChasu(vChasu) 
	userMasterData.FRectChasu = nextChasu
	nextChasuHint = userMasterData.getChasuHint(vChasu)		
	userMasterData.FRectQuestionNumber = nextChasuHint
	userMasterData.GetQuestion()

	hintQuestionType		 = userMasterData.FOneItem.FItype					 	
	hintQuestion			 = userMasterData.FOneItem.FIquestion				 		
	hintQuestionType1Image1	 = userMasterData.FOneItem.FIquestionType1Image1	 					
	hintQuestionType1Image2	 = userMasterData.FOneItem.FIquestionType1Image2	 					
	hintQuestionType1Image3	 = userMasterData.FOneItem.FIquestionType1Image3	 					
	hintQuestionType1Image4	 = userMasterData.FOneItem.FIquestionType1Image4	 					
	hintQuestionExample1	 = userMasterData.FOneItem.FIquestionExample1		 				
	hintQuestionExample2	 = userMasterData.FOneItem.FIquestionExample2		 				
	hintQuestionExample3	 = userMasterData.FOneItem.FIquestionExample3		 				
	hintQuestionExample4	 = userMasterData.FOneItem.FIquestionExample4		 				
	hintNumOfType1Image		 = userMasterData.FOneItem.FINumOfType1Image		 		

	redim preserve hintType1imageArr(4)				

	hintType1imageArr(0) = hintQuestionType1Image1
	hintType1imageArr(1) = hintQuestionType1Image2
	hintType1imageArr(2) = hintQuestionType1Image3
	hintType1imageArr(3) = hintQuestionType1Image4			
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type="text/javascript">	
$(function(){
	//뒤로가기 방지
	history.pushState(null, null, location.href);
		window.onpopstate = function () {
			history.go(1);
	};		    
	var position = $('.tenquiz-question').offset();
	$('html,body').animate({ scrollTop : position.top },300);

	// close hint layer
	$("#lyrHint .btn-close").click(function(){
		$("#lyrHint").hide();
    });
});
function popupHint(){
	// open hint layer
	<% If nextChasu <> "" Then %>
		$("#lyrHint").show();
		window.parent.$('html,body').animate({scrollTop:$("#lyrHint").offset().top},500);				
	<% end if %>
	fnAPPRCVpopSNS();
}
// SNS 공유 팝업
function fnAPPRCVpopSNS(){
	//fnAPPpopupBrowserURL("공유","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popShare.asp?sTit=<%=snpTitle%>&sLnk=<%=snpLink%>&sPre=<%=snpPre%>&sImg=<%=snpImg%>");
	$("#lySns").show();
	$("#lySns .inner").removeClass("lySlideDown").addClass("lySlideUp");
	return false;
}

function parent_kakaolink(label , imageurl , width , height , linkurl ){
	//카카오 SNS 공유
	Kakao.init('c967f6e67b0492478080bcf386390fdd');

	Kakao.Link.sendTalkLink({
		label: label,
		image: {
			src: imageurl,
			width: width,
			height: height
			},
		appButton: {
			text: '10X10 앱으로 이동',
			execParams :{
				android: { url: linkurl},
				iphone: { url: linkurl}
			}
		}
  });
}
</script>    
<body class="default-font body-sub"><!-- for dev msg : GNB메뉴에서 들어갈때만 body-main클래스가 붙습니다. 그 이외의 페이지에서는 body-sub가 붙습니다. -->
	<!-- contents -->	
	<div id="content" class="content tenquiz-question">			
		<!-- 결과 -->
		<div class="result win">
			<!-- 10문제 모두 맞췄을 경우 클래스 win -->
			<div class="inner <%=chkIIF(isWinner, "win", "")%>">
                <% If isWinner Then %>
                    <strong>축하합니다!</strong>
                <% Else %>
                    <strong>아쉽군요. 다음에 다시 도전하세요!</strong>
                <% End if %>
				<div class="score">
					<div>
						<p>
							<%=TotalQuestionCount%>문제 중
							<strong><%=userScore%>점</strong>
							<% If isWinner Then %>
							<em>최종상금은 텐퀴즈 익일 자동 지급됩니다.<br />마이 텐바이텐을 확인해주세요.</em>							 
							<% end if %>							
						</p>
					</div>
				</div>
				<div class="success">
					<p>현재까지</p>
					<p>도전 성공 <%=FormatNumber(totalWinner ,0)%>명</p>
					<p>참여자 <%=FormatNumber(totalParticipants ,0)%>명</p>
				</div>
				<div><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/bg_result.jpg?v=1" alt="" /></div>
			</div>			
			<ul>
				<% if adminChckChasu = "" then %>
					<li><a href="" onclick="fnAPPpopupBrowserURL('TenQuiz','<%=wwwUrl%>/apps/appCom/wish/web2014/tenquiz/quizanswersheet.asp?chasu=<%=vChasu%>&userid=<%=userid%>');return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/btn_wrong.png" alt="오늘의 오답 확인하기" /></a></li>				
				<% else %>
					<li><a href="quizanswersheet.asp?chasu=<%=vChasu%>&userid=<%=userid%>"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/btn_wrong.png" alt="오늘의 오답 확인하기" /></a></li>
				<% end if %>								
				<% if isShare = 100 then %>
				<li><a href="javascript:void(0)" onclick="popupHint()" class="btn-hint"><img src="<%=chkIIF(nextChasu <> "","http://fiximage.10x10.co.kr/m/2018/tenquiz/img_bnr_share_1.png?v=1.00", "http://fiximage.10x10.co.kr/m/2018/tenquiz/img_bnr_share_2.png?v=1.00")%>" alt="공유하고 내일 문제 힌트 얻기" /></a></li>					
				<% end if %>
				<li><a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%=productEvtNum%>');" ><img src="http://fiximage.10x10.co.kr/m/2018/tenquiz/img_bnr_item.png" alt="문제에 나온 상품 보러가기" /></a></li>
			</ul>						
		</div>
		<!--// 결과 -->

		<!-- 힌트 레이어 -->
		<!-- for dev msg : 문제 타입별로 typeA-1/ typeA-2 / typeA-3 / typeB 클래스 추가 -->
		<div id="lyrHint">
			<div class="inner">
				<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/tit_hint.png" alt="HINT - 미리보는 기출문제" /></h3>
				<ul class="q-list">
				<% if hintQuestionType = 1 then %>
					<li class="typeA-<%=hintNumOfType1Image%>">
						<div class="txt"><p><%=hintQuestion%></p></div>
						<div class="image-cont">
                            <% For i=0 To hintNumOfType1Image - 1 %>
                            <div class="thumbnail"><img src="<%=hintType1imageArr(i)%>" alt="" /></div>        
                            <% Next %>  													
						</div>						
						<div class="answer">
							<div class="choice">
								<span><%=hintQuestionExample1%></span>
							</div>
							<div class="choice">
								<span><%=hintQuestionExample2%></span>
							</div>
							<div class="choice">
								<span><%=hintQuestionExample3%></span>
							</div>
							<div class="choice">
								<span><%=hintQuestionExample4%></span>
							</div>
						</div>
					</li>				
				<% else %>
					<li class="typeB">
						<div class="txt"><p><%=hintQuestion%></p></div>
						<div class="answer">
							<div class="choice">
								<div class="thumbnail"><img src="<%=hintQuestionExample1%>" alt="" /></div>								
							</div>
							<div class="choice">
								<div class="thumbnail"><img src="<%=hintQuestionExample2%>" alt="" /></div>								
							</div>
							<div class="choice">
								<div class="thumbnail"><img src="<%=hintQuestionExample3%>" alt="" /></div>
							</div>
							<div class="choice">
								<div class="thumbnail"><img src="<%=hintQuestionExample4%>" alt="" /></div>
							</div>
						</div>
					</li>				
				<% end if %>					
				</ul>
				<button class="btn-close"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/btn_close.png" alt="닫기" /></button>
			</div>
		</div>
		<!--// 힌트 레이어 -->
	</div>
	<!-- //contents -->
<%
	'//	SNS 공유 관련 HEADER 포함
	Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg, eOnlyName
	eOnlyName = "[텐바이텐에서 진행하는 10퀴즈쇼!]"
	snpTitle = eOnlyName	
	'snpLink = wwwUrl & "/apps/appCom/wish/web2014/tenquiz/quizresult.asp?TotalQuestionCount="&TotalQuestionCount&"&chasu="&vChasu&"&userid="&userid&"&share=1"
	snpLink = wwwUrl & "/apps/appCom/wish/web2014/tenquiz/quizmain.asp"
	snpPre = "[텐바이텐에서 진행하는 10퀴즈쇼!]"
	'//이벤트 명 할인이나 쿠폰시
	'// sns공유용 이미지
	snpImg = "http://fiximage.10x10.co.kr/m/2018/tenquiz/img_bnr_share.jpg"
%>
	<!-- #include virtual="/apps/appCom/wish/web2014/common/LayerShare.asp" -->	
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incfooter.asp" -->    
</body>
