<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 2018 Playing TenQuizQuestion
' History : 2018-05-02 원승현 생성
' 주의사항
'   - 이벤트 기간 : 2018-05-08 ~ 2018-05-10
'   - 오픈시간 : 오전10시~오후10시
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/playing/playingCls.asp" -->
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js?v=2.4359"></script>
<%

	Dim vUserScore, vUserTotal, vRightUser, masterIdx, userid, vChasu, vTestCheck, arrUserAnswerQuiz, currenttime, vQuery, tmpArrUserAnswerQuiz, answerQuiz, arrAnswerQuiz, i

	userid = GetEncLoginUserID()
	vChasu = requestcheckvar(request("chasu"),20)

	'// 현재시간
	currenttime = now()
'	currenttime = "2018-05-08 오전 10:03:35"

	vTestCheck = False

	If Trim(vChasu) <> "" Then
		Select Case Trim(vChasu)
			Case "20180508"
				If IsUserLoginOK() Then
					'// 해당 차수를 응모한 회원만 문제 확인 가능
					vQuery = "SELECT * FROM [db_temp].[dbo].[tbl_PlayingTenQuizUserMasterData] WITH (NOLOCK) WHERE userid='"&userid&"' And chasu='"&vChasu&"' "
					rsget.CursorLocation = adUseClient
					rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
						If Not(rsget.bof Or rsget.eof) Then
							vTestCheck = True
							vUserScore = rsget("score")
						End If
					rsget.close
				End If

				If Not(vTestCheck) Then
					Response.write "<script>alert('오늘의 문제는 퀴즈를 응모하신 분들만 확인가능합니다.');fnAPPclosePopup();</script>"
					Response.End
				Else
					vQuery = "SELECT * FROM [db_temp].[dbo].[tbl_PlayingTenQuizUserDetailData] WITH (NOLOCK) WHERE userid='"&userid&"' And chasu='"&vChasu&"' ORDER BY detailidx "
					rsget.CursorLocation = adUseClient
					rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
						If Not(rsget.bof Or rsget.eof) Then
							Do Until rsget.eof
								tmpArrUserAnswerQuiz = tmpArrUserAnswerQuiz&","&rsget("useranswer")
							rsget.movenext
							Loop
						End If
					rsget.close
				End If

			Case "20180509"
				If IsUserLoginOK() Then
					'// 해당 차수를 응모한 회원만 문제 확인 가능
					vQuery = "SELECT * FROM [db_temp].[dbo].[tbl_PlayingTenQuizUserMasterData] WITH (NOLOCK) WHERE userid='"&userid&"' And chasu='"&vChasu&"' "
					rsget.CursorLocation = adUseClient
					rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
						If Not(rsget.bof Or rsget.eof) Then
							vTestCheck = True
							vUserScore = rsget("score")
						End If
					rsget.close
				End If

				If Not(vTestCheck) Then
					Response.write "<script>alert('오늘의 문제는 퀴즈를 응모하신 분들만 확인가능합니다.');fnAPPclosePopup();</script>"
					Response.End
				Else
					vQuery = "SELECT * FROM [db_temp].[dbo].[tbl_PlayingTenQuizUserDetailData] WITH (NOLOCK) WHERE userid='"&userid&"' And chasu='"&vChasu&"' ORDER BY detailidx "
					rsget.CursorLocation = adUseClient
					rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
						If Not(rsget.bof Or rsget.eof) Then
							Do Until rsget.eof
								tmpArrUserAnswerQuiz = tmpArrUserAnswerQuiz&","&rsget("useranswer")
							rsget.movenext
							Loop
						End If
					rsget.close
				End If

			Case "20180510"
				If IsUserLoginOK() Then
					'// 5월 10일이 넘지 않으면 해당 차수를 응모한 회원만 문제 확인 가능
					vQuery = "SELECT * FROM [db_temp].[dbo].[tbl_PlayingTenQuizUserMasterData] WITH (NOLOCK) WHERE userid='"&userid&"' And chasu='"&vChasu&"' "
					rsget.CursorLocation = adUseClient
					rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
						If Not(rsget.bof Or rsget.eof) Then
							vTestCheck = True
							vUserScore = rsget("score")
						End If
					rsget.close
				End If

				If Not(vTestCheck) Then
					Response.write "<script>alert('오늘의 문제는 퀴즈를 응모하신 분들만 확인가능합니다.');fnAPPclosePopup();</script>"
					Response.End
				Else
					vQuery = "SELECT * FROM [db_temp].[dbo].[tbl_PlayingTenQuizUserDetailData] WITH (NOLOCK) WHERE userid='"&userid&"' And chasu='"&vChasu&"' ORDER BY detailidx "
					rsget.CursorLocation = adUseClient
					rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
						If Not(rsget.bof Or rsget.eof) Then
							Do Until rsget.eof
								tmpArrUserAnswerQuiz = tmpArrUserAnswerQuiz&","&rsget("useranswer")
							rsget.movenext
							Loop
						End If
					rsget.close
				End If
			Case Else
				Response.write "<script>alert('정상적인 경로로 접근해주세요.');fnAPPclosePopup();</script>"
				Response.End
		End Select
	Else
		Response.write "<script>alert('정상적인 경로로 접근해주세요.');fnAPPclosePopup();</script>"
		Response.End
	End If

	If tmpArrUserAnswerQuiz <> "" Then
		tmpArrUserAnswerQuiz = Right(tmpArrUserAnswerQuiz, Len(tmpArrUserAnswerQuiz)-1)

		If ubound(Split(tmpArrUserAnswerQuiz, ",")) <> 9 Then
			For i=1 To 9-ubound(Split(tmpArrUserAnswerQuiz, ","))
				tmpArrUserAnswerQuiz = tmpArrUserAnswerQuiz&",0"
			Next
			arrUserAnswerQuiz = Split(tmpArrUserAnswerQuiz, ",")
		Else
			arrUserAnswerQuiz = Split(tmpArrUserAnswerQuiz, ",")
		End If
	Else
		tmpArrUserAnswerQuiz = "0,0,0,0,0,0,0,0,0,0"
		arrUserAnswerQuiz = Split(tmpArrUserAnswerQuiz, ",")
	End If

	Select Case Trim(vChasu)
		Case "20180508"
			answerQuiz = "2,2,4,4,4,1,1,4,1,4"
		Case "20180509"
			answerQuiz = "3,2,4,4,3,2,4,4,1,1"
		Case "20180510"
			answerQuiz = "4,3,2,1,2,4,2,2,4,3"
	End Select

	'// 답안 확인을 위해 split로 쪼갬
	arrAnswerQuiz = Split(answerQuiz, ",")

'	Response.write arrUserAnswerQuiz(0)

%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<title>10x10: PLAYing - TenQuiz</title>
<style type="text/css">
.tenquiz-result {background:#f5f5f5;}
.tenquiz-result .topic {position:relative;}
.tenquiz-result .topic .history {position:absolute; left:0; bottom:10.5%; width:100%; text-align:center; color:#fff; font-size:1.2rem;}
.tenquiz-result .topic .history strong {display:block; font-size:3rem; font-weight:600; padding-top:.6rem;}
.q-list li {padding:3.4rem 0; text-align:center;}
.q-list li:nth-child(even) {background-color:#e5e5e5;}
.q-list .page {padding-top:1.5rem;}
.q-list .num {width:5.55rem; height:5.55rem; margin:0 auto 1.5rem; font-size:2rem; line-height:5.6rem; color:#d91066; background:url(http://webimage.10x10.co.kr/playing/thing/vol040/m/bg_num.gif?v=1) 0 0 no-repeat; background-size:100% auto;}
.q-list .txt {position:relative; width:27rem; margin:0 auto 1.7rem; padding-left:2.7rem; text-indent:-2.7rem; font-size:1.62rem; line-height:1.4; text-align:left; color:#000;}
.q-list .txt:after {content:''; display:inline-block; position:absolute; left:-.8rem; top:-.8rem; width:3.58rem; height:3.58rem; background-position:0 0; background-repeat:no-repeat;}
.q-list .answerY .txt:after {background:url(http://webimage.10x10.co.kr/playing/thing/vol040/m/bg_o.png); background-size:100% 100%;}
.q-list .answerN .txt:after {background:url(http://webimage.10x10.co.kr/playing/thing/vol040/m/bg_x.png); background-size:100% 100%;}
.q-list .image-cont {overflow:hidden; margin:0 auto;}
.q-list .thumbnail {position:relative;}
.q-list .thumbnail:after {content:''; display:inline-block; position:absolute; left:0; top:0; z-index:5; width:100%; height:100%; background:rgba(0,0,0,.02);}
.q-list .answer {overflow:hidden; width:24.24rem; margin:0 auto;}
.q-list .answer .choice {float:left; width:11.7rem; height:3.84rem; margin-top:0.9rem; font-size:1.2rem; line-height:3.9rem; color:#666; border:1px solid #666; border-radius:2rem; cursor:pointer;}
.q-list .answer .choice.my { border-color:#666; background:#666;}
.q-list .answer .choice.my span {color:#fff;}
.q-list .answer .choice.correct { border-color:#f96498; background:#f96498;}
.q-list .answer .choice.correct span {color:#fff;}
.q-list .answer .choice:nth-child(even) {float:right;}
.q-list .type1 .image-cont {width:15.36rem; margin-bottom:0.3rem;}
.q-list .type2 .image-cont {width:15.36rem;}
.q-list .type2 .image-cont > div {float:left; width:50%;}
.q-list .type3 .image-cont {width:24.24rem; margin-top:2.7rem; margin-bottom:2.7rem;}
.q-list .type3 .image-cont > div {float:left; width:50%;}
.q-list .type4 .choice {height:auto; padding:1.05rem 0; line-height:1; border-radius:0.8rem; background:#fff;}
.q-list .type4 .choice span {display:inline-block; padding-top:0.4rem; font-size:1.1rem; line-height:1; color:#333; vertical-align:top;}
.q-list .type4 .choice .thumbnail {overflow:hidden; width:9rem; height:9rem; margin:0 auto; border-radius:50%;}
</style>
<script type="text/javascript">
$(function(){
	var position = $('.thingVol040').offset(); // 위치값
	$('html,body').animate({ scrollTop : position.top },300); // 이동
});
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content playV16" id="contentArea">
			<!-- contents -->
			<div class="cont">
				<div class="detail">
					<div class="thingVol040 tenquiz-result">

						<div class="topic">
							<h2><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/tit_ten_quiz_2.png" alt="TEN QUIZ" /></h2>
							<% If vTestCheck Then %>
								<% Select Case Trim(vChasu) %>
									<% Case "20180508" %>
										<div class="history">1DAY : 5월 8일<strong><%=vUserScore%>점</strong></div>
									<% Case "20180509" %>
										<div class="history">2DAY : 5월 9일<strong><%=vUserScore%>점</strong></div>
									<% Case "20180510" %>
										<div class="history">3DAY : 5월 10일<strong><%=vUserScore%>점</strong></div>
								<% End Select %>
							<% Else %>
								<% Select Case Trim(vChasu) %>
									<% Case "20180508" %>
										<div class="history">5월 8일<strong>1DAY</strong></div>
									<% Case "20180509" %>
										<div class="history">5월 9일<strong>2DAY</strong></div>
									<% Case "20180510" %>
										<div class="history">5월 10일<strong>3DAY</strong></div>
								<% End Select %>
							<% End If %>
						</div>
						<% Select Case Trim(vChasu) %>
							<% Case "20180508" %>
								<ol class="q-list">
									<%' 정답일 경우 answerY 오답일경우 answerN %>
									<!-- 1 -->
									<li id="day1q1" class="q1 type1 <% If vTestCheck Then %><% If arrUserAnswerQuiz(0) = arrAnswerQuiz(0) Then %>answerY<% Else %>answerN<% End If %><% End If %>">
										<div class="txt"><p>01. 이 수저/젓가락 받침상품에서<br />오리는 총 몇 마리 일까요?</p></div>
										<div class="image-cont">
											<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/117/B001178538.jpg" alt="" /></div>
										</div>
										<div class="answer">
											<%' 내가 선택한 답 my %>
											<div class="choice" <% If arrUserAnswerQuiz(0) = 1 Then %>my<% End If %>>
												<span>5마리</span>
											</div>
											<div class="choice correct">
												<span>6마리</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(0) = 3 Then %>my<% End If %>">
												<span>1마리</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(0) = 4 Then %>my<% End If %>">
												<span>7마리</span>
											</div>
										</div>
									</li>
									<!-- 2 -->
									<li id="day1q2" class="q2 type1 <% If vTestCheck Then %><% If arrUserAnswerQuiz(1) = arrAnswerQuiz(1) Then %>answerY<% Else %>answerN<% End If %><% End If %>">
										<div class="txt"><p>02. 이 분홍 캐릭터의 이름은 무엇일까요?</p></div>
										<div class="image-cont">
											<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/167/B001678341.jpg" alt="" /></div>
										</div>
										<div class="answer">
											<div class="choice <% If arrUserAnswerQuiz(1) = 1 Then %>my<% End If %>">
												<span>바바마마</span>
											</div>
											<div class="choice correct">
												<span>바바파파</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(1) = 3 Then %>my<% End If %>">
												<span>바보파파</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(1) = 4 Then %>my<% End If %>">
												<span>파파바바</span>
											</div>
										</div>
									</li>
									<!-- 3 -->
									<li id="day1q3" class="q3 type4 <% If vTestCheck Then %><% If arrUserAnswerQuiz(2) = arrAnswerQuiz(2) Then %>answerY<% Else %>answerN<% End If %><% End If %>">
										<div class="txt"><p>03. 다음 중 다이어트 식품이 아닌 것은?</p></div>
										<div class="answer">
											<div class="choice <% If arrUserAnswerQuiz(2) = 1 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/add2_600/192/A001924029_02.jpg" alt="" /></div>
												<span>밀스</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(2) = 2 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/add1_600/192/A001921112_01.jpg" alt="" /></div>
												<span>소소생활</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(2) = 3 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/add1_600/177/A001774239_01-4.jpg" alt="" /></div>
												<span>칼로리컷</span>
											</div>
											<div class="choice correct">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/191/B001913547.jpg" alt="" /></div>
												<span>라비퀸 떡볶이</span>
											</div>
										</div>
									</li>
									<!-- 4 -->
									<li id="day1q4" class="q4 type4 <% If vTestCheck Then %><% If arrUserAnswerQuiz(3) = arrAnswerQuiz(3) Then %>answerY<% Else %>answerN<% End If %><% End If %>">
										<div class="txt"><p>04. 다음 중 1만원 초반 혹은 이하 상품이<br />아닌 것은?</p></div>
										<div class="answer">
											<div class="choice <% If arrUserAnswerQuiz(3) = 1 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/151/B001515843.jpg" alt="" /></div>
												<span>누디LED조명(M)</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(3) = 2 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/168/B001689964.jpg" alt="" /></div>
												<span>플랫 플레이트-브레드</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(3) = 3 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/181/B001812571-5.jpg" alt="" /></div>
												<span>모나미 36색</span>
											</div>
											<div class="choice correct">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/179/B001796388.jpg" alt="" /></div>
												<span>다이슨 V8 카본 파이버</span>
											</div>
										</div>
									</li>
									<!-- 5 -->
									<li id="day1q5" class="q5 type1 <% If vTestCheck Then %><% If arrUserAnswerQuiz(4) = arrAnswerQuiz(4) Then %>answerY<% Else %>answerN<% End If %><% End If %>">
										<div class="txt"><p>05. 이 못난이 캐릭터의 브랜드는 어디일까요?</p></div>
										<div class="image-cont">
											<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/193/B001931760.jpg" alt="" /></div>
										</div>
										<div class="answer">
											<div class="choice <% If arrUserAnswerQuiz(4) = 1 Then %>my<% End If %>">
												<span>오롤리팝</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(4) = 2 Then %>my<% End If %>">
												<span>오잉또잉</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(4) = 3 Then %>my<% End If %>">
												<span>오놀래라</span>
											</div>
											<div class="choice correct">
												<span>오롤리데이</span>
											</div>
										</div>
									</li>
									<!-- 6 -->
									<li id="day1q6" class="q6 type1 <% If vTestCheck Then %><% If arrUserAnswerQuiz(5) = arrAnswerQuiz(5) Then %>answerY<% Else %>answerN<% End If %><% End If %>">
										<div class="txt"><p>06. 이 상품은 어떤 용도의 상품일까요?</p></div>
										<div class="image-cont">
											<div class="thumbnail"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/img_1_6_1.jpg" alt="" /></div>
										</div>
										<div class="answer">
											<div class="choice correct">
												<span>케이블바이트</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(5) = 2 Then %>my<% End If %>">
												<span>충전기</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(5) = 3 Then %>my<% End If %>">
												<span>책갈피</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(5) = 4 Then %>my<% End If %>">
												<span>애착인형</span>
											</div>
										</div>
									</li>
									<!-- 7 -->
									<li id="day1q7" class="q7 type4 <% If vTestCheck Then %><% If arrUserAnswerQuiz(6) = arrAnswerQuiz(6) Then %>answerY<% Else %>answerN<% End If %><% End If %>">
										<div class="txt"><p>07. 다음 중 먹을 수 없는 것은?</p></div>
										<div class="answer">
											<div class="choice correct">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/190/B001904980.jpg" alt="" /></div>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(6) = 2 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/img_1_7_2.jpg" alt="" /></div>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(6) = 3 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/191/B001913550.jpg" alt="" /></div>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(6) = 4 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/img_1_7_4.jpg" alt="" /></div>
											</div>
										</div>
									</li>
									<!-- 8 -->
									<li id="day1q8" class="q8 type4 <% If vTestCheck Then %><% If arrUserAnswerQuiz(7) = arrAnswerQuiz(7) Then %>answerY<% Else %>answerN<% End If %><% End If %>">
										<div class="txt"><p>08. 다음 중 브랜드 [키티버니포니]<br />상품이 아닌 것은?</p></div>
										<div class="answer">
											<div class="choice <% If arrUserAnswerQuiz(7) = 1 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/176/B001767906.jpg" alt="" /></div>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(7) = 2 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/161/B001613587.jpg" alt="" /></div>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(7) = 3 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/104/B001046389-1.jpg" alt="" /></div>
											</div>
											<div class="choice correct">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/179/B001792670.jpg" alt="" /></div>
											</div>
										</div>
									</li>
									<!-- 9 -->
									<li id="day1q9" class="q9 type2 <% If vTestCheck Then %><% If arrUserAnswerQuiz(8) = arrAnswerQuiz(8) Then %>answerY<% Else %>answerN<% End If %><% End If %>">
										<div class="txt"><p>09. 이 상품들을 보고 연상되는 상황은?</p></div>
										<div class="image-cont">
											<div><div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/191/B001915823.jpg" alt="" /></div></div>
											<div><div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/191/B001915816.jpg" alt="" /></div></div>
											<div><div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/168/B001682365-1.jpg" alt="" /></div></div>
											<div><div class="thumbnail"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/img_1_9_4.jpg" alt="" /></div></div>
										</div>
										<div class="answer">
											<div class="choice correct">
												<span>소풍</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(8) = 2 Then %>my<% End If %>">
												<span>회사야근</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(8) = 3 Then %>my<% End If %>">
												<span>상견례</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(8) = 4 Then %>my<% End If %>">
												<span>헬스장</span>
											</div>
										</div>
									</li>
									<!-- 10 -->
									<li id="day1q10" class="q10 type3 <% If vTestCheck Then %><% If arrUserAnswerQuiz(9) = arrAnswerQuiz(9) Then %>answerY<% Else %>answerN<% End If %><% End If %>">
										<div class="txt"><p>10. 총 하트는 몇 개 일까요?</p></div>
										<div class="image-cont">
											<div><div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/189/B001894434.jpg" alt="" /></div></div>
											<div><div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/185/B001859662.jpg" alt="" /></div></div>
										</div>
										<div class="answer">
											<div class="choice <% If arrUserAnswerQuiz(9) = 1 Then %>my<% End If %>">
												<span>1개</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(9) = 2 Then %>my<% End If %>">
												<span>4개</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(9) = 3 Then %>my<% End If %>">
												<span>10개</span>
											</div>
											<div class="choice correct">
												<span>18개</span>
											</div>
										</div>
									</li>
								</ol>
							<% Case "20180509" %>
								<ol class="q-list">
									<%' 정답일 경우 answerY 오답일경우 answerN %>
									<!-- 1 -->
									<li id="day2q1" class="q1 type1 <% If vTestCheck Then %><% If arrUserAnswerQuiz(0) = arrAnswerQuiz(0) Then %>answerY<% Else %>answerN<% End If %><% End If %>">
										<div class="txt"><p>01. 지금 이 시계는 몇 시 몇 분일까요?</p></div>
										<div class="image-cont">
											<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/187/B001874632.jpg" alt="" /></div>
										</div>
										<div class="answer">
											<%' 내가 선택한 답 my %>
											<div class="choice <% If arrUserAnswerQuiz(0) = 1 Then %>my<% End If %>">
												<span>10시 2분</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(0) = 2 Then %>my<% End If %>">
												<span>10시 22분</span>
											</div>
											<div class="choice correct">
												<span>10시 10분</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(0) = 4 Then %>my<% End If %>">
												<span>2시 10분</span>
											</div>
										</div>
									</li>
									<!-- 2 -->
									<li id="day2q2" class="q2 type1 <% If vTestCheck Then %><% If arrUserAnswerQuiz(1) = arrAnswerQuiz(1) Then %>answerY<% Else %>answerN<% End If %><% End If %>">
										<div class="txt"><p>02. 엑소 멤버 중 한 명이 착용한 이 가방,<br />누가 착용했을까요? </p></div>
										<div class="image-cont">
											<div><div class="thumbnail"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/img_2_2_1.jpg" alt="" /></div></div>
										</div>
										<div class="answer">
											<div class="choice <% If arrUserAnswerQuiz(1) = 1 Then %>my<% End If %>">
												<span>찬희</span>
											</div>
											<div class="choice correct">
												<span>찬열</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(1) = 3 Then %>my<% End If %>">
												<span>찬우</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(1) = 4 Then %>my<% End If %>">
												<span>이열</span>
											</div>
										</div>
									</li>
									<!-- 3 -->
									<li id="day2q3" class="q3 type4 <% If vTestCheck Then %><% If arrUserAnswerQuiz(2) = arrAnswerQuiz(2) Then %>answerY<% Else %>answerN<% End If %><% End If %>">
										<div class="txt"><p>03. 다음 중 성격이 다른 상품은?</p></div>
										<div class="answer">
											<div class="choice <% If arrUserAnswerQuiz(2) = 1 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/img_2_3_1.jpg" alt="" /></div>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(2) = 2 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/img_2_3_2.jpg" alt="" /></div>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(2) = 3 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/174/B001741292-4.jpg" alt="" /></div>
											</div>
											<div class="choice correct">
												<div class="thumbnail"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/img_2_3_4.jpg" alt="" /></div>
											</div>
										</div>
									</li>
									<!-- 4 -->
									<li id="day2q4" class="q4 type4 <% If vTestCheck Then %><% If arrUserAnswerQuiz(3) = arrAnswerQuiz(3) Then %>answerY<% Else %>answerN<% End If %><% End If %>">
										<div class="txt"><p>04. 다음 중 수납/정리아이템이 아닌 것은?</p></div>
										<div class="answer">
											<div class="choice <% If arrUserAnswerQuiz(3) = 1 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/192/B001926960.jpg" alt="" /></div>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(3) = 2 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/161/B001616261.jpg" alt="" /></div>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(3) = 3 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/add1_600/184/A001840773_01.jpg" alt="" /></div>
											</div>
											<div class="choice correct">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/193/B001934277.jpg" alt="" /></div>
											</div>
										</div>
									</li>
									<!-- 5 -->
									<li id="day2q5" class="q5 type1 <% If vTestCheck Then %><% If arrUserAnswerQuiz(4) = arrAnswerQuiz(4) Then %>answerY<% Else %>answerN<% End If %><% End If %>">
										<div class="txt"><p>05. 이 피규어의  브랜드는 어디일까요?</p></div>
										<div class="image-cont">
											<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/192/B001921172.jpg" alt="" /></div>
										</div>
										<div class="answer">
											<div class="choice <% If arrUserAnswerQuiz(4) = 1 Then %>my<% End If %>">
												<span>뽀로로</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(4) = 2 Then %>my<% End If %>">
												<span>핑크퐁</span>
											</div>
											<div class="choice correct">
												<span>플레이모빌</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(4) = 4 Then %>my<% End If %>">
												<span>콩순이</span>
											</div>
										</div>
									</li>
									<!-- 6 -->
									<li id="day2q6" class="q6 type1 <% If vTestCheck Then %><% If arrUserAnswerQuiz(5) = arrAnswerQuiz(5) Then %>answerY<% Else %>answerN<% End If %><% End If %>">
										<div class="txt"><p>06. 이 상품은 어떤 기구과 합쳐진 상품일까요?</p></div>
										<div class="image-cont">
											<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/187/B001872544.jpg" alt="" /></div>
										</div>
										<div class="answer">
											<div class="choice <% If arrUserAnswerQuiz(5) = 1 Then %>my<% End If %>">
												<span>탁구+골프</span>
											</div>
											<div class="choice correct">
												<span>탁구+배드민턴</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(5) = 3 Then %>my<% End If %>">
												<span>배드민턴+골프</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(5) = 4 Then %>my<% End If %>">
												<span>골프+낚시</span>
											</div>
										</div>
									</li>
									<!-- 7 -->
									<li id="day2q7" class="q7 type4 <% If vTestCheck Then %><% If arrUserAnswerQuiz(6) = arrAnswerQuiz(6) Then %>answerY<% Else %>answerN<% End If %><% End If %>">
										<div class="txt"><p>07. 다음 중 미세먼지에 도움이 되지 않는 것은?</p></div>
										<div class="answer">
											<div class="choice <% If arrUserAnswerQuiz(6) = 1 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/189/B001899889.jpg" alt="" /></div>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(6) = 2 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/192/B001922261.jpg" alt="" /></div>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(6) = 3 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/166/B001665813.jpg" alt="" /></div>
											</div>
											<div class="choice correct">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/180/B001801165.jpg" alt="" /></div>
											</div>
										</div>
									</li>
									<!-- 8 -->
									<li id="day2q8" class="q8 type4 <% If vTestCheck Then %><% If arrUserAnswerQuiz(7) = arrAnswerQuiz(7) Then %>answerY<% Else %>answerN<% End If %><% End If %>">
										<div class="txt"><p>08. 다음 중 가장 섹시한 강아지는?<br />(옷을 걸치지 않은 강아지)</p></div>
										<div class="answer">
											<div class="choice <% If arrUserAnswerQuiz(7) = 1 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/193/B001936102.jpg" alt="" /></div>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(7) = 2 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/193/B001933287.jpg" alt="" /></div>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(7) = 3 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/193/B001931859.jpg" alt="" /></div>
											</div>
											<div class="choice correct">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/186/B001863272-1.jpg" alt="" /></div>
											</div>
										</div>
									</li>
									<!-- 9 -->
									<li id="day2q9" class="q9 type2 <% If vTestCheck Then %><% If arrUserAnswerQuiz(8) = arrAnswerQuiz(8) Then %>answerY<% Else %>answerN<% End If %><% End If %>">
										<div class="txt"><p>09. 이 상품들을 보고 연상되는 상황은?</p></div>
										<div class="image-cont">
											<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/129/B001292620.jpg" alt="" /></div>
											<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/176/B001761315.jpg" alt="" /></div>
											<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/176/B001764510-1.jpg" alt="" /></div>
											<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/188/B001883488.jpg" alt="" /></div>
										</div>
										<div class="answer">
											<div class="choice correct">
												<span>휴양</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(8) = 2 Then %>my<% End If %>">
												<span>이사</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(8) = 3 Then %>my<% End If %>">
												<span>학교</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(8) = 4 Then %>my<% End If %>">
												<span>마트</span>
											</div>
										</div>
									</li>
									<!-- 10 -->
									<li id="day2q10" class="q10 type1 <% If vTestCheck Then %><% If arrUserAnswerQuiz(9) = arrAnswerQuiz(9) Then %>answerY<% Else %>answerN<% End If %><% End If %>">
										<div class="txt"><p>10. 무엇에 쓰는 용도 일까요?</p></div>
										<div class="image-cont">
											<div class="thumbnail"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/img_2_10_1.jpg" alt="" /></div>
										</div>
										<div class="answer">
											<div class="choice correct">
												<span>립스틱</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(9) = 2 Then %>my<% End If %>">
												<span>색연필</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(9) = 3 Then %>my<% End If %>">
												<span>크레파스</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(9) = 4 Then %>my<% End If %>">
												<span>쉐도우</span>
											</div>
										</div>
									</li>
								</ol>
							<% Case "20180510" %>
								<ol class="q-list">
									<%' 정답일 경우 answerY 오답일경우 answerN %>
									<!-- 1 -->
									<li id="day3q1" class="q1 type4 <% If vTestCheck Then %><% If arrUserAnswerQuiz(0) = arrAnswerQuiz(0) Then %>answerY<% Else %>answerN<% End If %><% End If %>">
										<div class="txt"><p>01. 브랜드와 이름의 연결이 알맞은 것은?</p></div>
										<div class="answer">
											<%' 내가 선택한 답 my %>
											<div class="choice <% If arrUserAnswerQuiz(0) = 1 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/59/B000596959-1.jpg" alt="" /></div>
												<span>서커스걸밴드</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(0) = 2 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/181/B001812564-2.jpg" alt="" /></div>
												<span>모나비</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(0) = 3 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/96/B000969515.jpg" alt="" /></div>
												<span>긴팔</span>
											</div>
											<div class="choice correct">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/151/B001517552.jpg" alt="" /></div>
												<span>I'MMEME (아임미미)</span>
											</div>
										</div>
									</li>
									<!-- 2 -->
									<li id="day3q2" class="q2 type4 <% If vTestCheck Then %><% If arrUserAnswerQuiz(1) = arrAnswerQuiz(1) Then %>answerY<% Else %>answerN<% End If %><% End If %>">
										<div class="txt"><p>02. 다음 중 다른 종류의 아우터를 입은 사람은?</p></div>
										<div class="answer">
											<div class="choice <% If arrUserAnswerQuiz(1) = 1 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/190/B001909450.jpg" alt="" /></div>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(1) = 2 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/193/B001937364.jpg" alt="" /></div>
											</div>
											<div class="choice correct">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/194/B001948899.jpg" alt="" /></div>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(1) = 4 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/188/B001887749.jpg" alt="" /></div>
											</div>
										</div>
									</li>
									<!-- 3 -->
									<li id="day3q3" class="q3 type4 <% If vTestCheck Then %><% If arrUserAnswerQuiz(2) = arrAnswerQuiz(2) Then %>answerY<% Else %>answerN<% End If %><% End If %>">
										<div class="txt"><p>03. 귀여운 강아지들 중<br />살아있는 강아지가 아닌 것은?</p></div>
										<div class="answer">
											<div class="choice <% If arrUserAnswerQuiz(2) = 1 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/193/B001937450.jpg" alt="" /></div>
											</div>
											<div class="choice correct">
												<div class="thumbnail"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/img_3_3_2.jpg" alt="" /></div>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(2) = 3 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/160/B001609989.jpg" alt="" /></div>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(2) = 4 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/192/B001926762.jpg" alt="" /></div>
											</div>
										</div>
									</li>
									<!-- 4 -->
									<li id="day3q4" class="q4 type4 <% If vTestCheck Then %><% If arrUserAnswerQuiz(3) = arrAnswerQuiz(3) Then %>answerY<% Else %>answerN<% End If %><% End If %>">
										<div class="txt"><p>04. 다음 중 여행갈 때 챙겨가기 가장 어려운 것은?</p></div>
										<div class="answer">
											<div class="choice correct">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/189/B001892850.jpg" alt="" /></div>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(3) = 2 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/183/B001833978.jpg" alt="" /></div>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(3) = 3 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/155/B001551254-3.jpg" alt="" /></div>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(3) = 4 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/195/B001951678.jpg" alt="" /></div>
											</div>
										</div>
									</li>
									<!-- 5 -->
									<li id="day3q5" class="q5 type4 <% If vTestCheck Then %><% If arrUserAnswerQuiz(4) = arrAnswerQuiz(4) Then %>answerY<% Else %>answerN<% End If %><% End If %>">
										<div class="txt"><p>05. 다음 중 디즈니캐릭터가 아닌 것은?</p></div>
										<div class="answer">
											<div class="choice <% If arrUserAnswerQuiz(4) = 1 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/173/B001736459-1.jpg" alt="" /></div>
											</div>
											<div class="choice correct">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/177/B001773154-1.jpg" alt="" /></div>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(4) = 3 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/193/B001930181.jpg" alt="" /></div>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(4) = 4 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/add4_600/148/A001488140_04-1.jpg" alt="" /></div>
											</div>
										</div>
									</li>
									<!-- 6 -->
									<li id="day3q6" class="q6 type4 <% If vTestCheck Then %><% If arrUserAnswerQuiz(5) = arrAnswerQuiz(5) Then %>answerY<% Else %>answerN<% End If %><% End If %>">
										<div class="txt"><p>06. 다음 중 다른 동물은 누구인가요?</p></div>
										<div class="answer">
											<div class="choice <% If arrUserAnswerQuiz(5) = 1 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/176/B001768119-1.jpg" alt="" /></div>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(5) = 2 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/185/B001850331.jpg" alt="" /></div>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(5) = 3 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/img_3_6_3.jpg" alt="" /></div>
											</div>
											<div class="choice correct">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic/114/B001141032.jpg" alt="" /></div>
											</div>
										</div>
									</li>
									<!-- 7 -->
									<li id="day3q7" class="q7 type3 <% If vTestCheck Then %><% If arrUserAnswerQuiz(6) = arrAnswerQuiz(6) Then %>answerY<% Else %>answerN<% End If %><% End If %>">
										<div class="txt"><p>07. 다음 옷을 입기 좋은 계절은?</p></div>
										<div class="image-cont">
											<div><div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/194/B001945472.jpg" alt="" /></div></div>
											<div><div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/175/B001754507.jpg" alt="" /></div></div>
										</div>
										<div class="answer">
											<div class="choice <% If arrUserAnswerQuiz(6) = 1 Then %>my<% End If %>">
												<span>봄</span>
											</div>
											<div class="choice correct">
												<span>여름</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(6) = 3 Then %>my<% End If %>">
												<span>가을</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(6) = 4 Then %>my<% End If %>">
												<span>겨울</span>
											</div>
										</div>
									</li>
									<!-- 8 -->
									<li id="day3q8" class="q8 type1 <% If vTestCheck Then %><% If arrUserAnswerQuiz(7) = arrAnswerQuiz(7) Then %>answerY<% Else %>answerN<% End If %><% End If %>">
										<div class="txt"><p>08. 브런치 약속에 모인 사람은 모두 몇 명 인가요?</p></div>
										<div class="image-cont">
											<div class="thumbnail"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/img_3_8_1.jpg" alt="" /></div>
										</div>
										<div class="answer">
											<div class="choice <% If arrUserAnswerQuiz(7) = 1 Then %>my<% End If %>">
												<span>1명</span>
											</div>
											<div class="choice correct">
												<span>4명</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(7) = 3 Then %>my<% End If %>">
												<span>100명</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(7) = 4 Then %>my<% End If %>">
												<span>10명</span>
											</div>
										</div>
									</li>
									<!-- 9 -->
									<li id="day3q9" class="q9 type1 <% If vTestCheck Then %><% If arrUserAnswerQuiz(8) = arrAnswerQuiz(8) Then %>answerY<% Else %>answerN<% End If %><% End If %>">
										<div class="txt"><p>09. 한글 블록으로 만든 단어는 무엇인가요?</p></div>
										<div class="image-cont">
											<div class="thumbnail"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/img_3_9_1.jpg" alt="" /></div>
										</div>
										<div class="answer">
											<div class="choice <% If arrUserAnswerQuiz(8) = 1 Then %>my<% End If %>">
												<span>초코렛운동장</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(8) = 2 Then %>my<% End If %>">
												<span>초코렛공방</span>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(8) = 3 Then %>my<% End If %>">
												<span>사탕공장</span>
											</div>
											<div class="choice correct">
												<span>초콜렛공장</span>
											</div>
										</div>
									</li>
									<!-- 10 -->
									<li id="day3q10" class="q10 type4 <% If vTestCheck Then %><% If arrUserAnswerQuiz(9) = arrAnswerQuiz(9) Then %>answerY<% Else %>answerN<% End If %><% End If %>">
										<div class="txt"><p>10. 다음 중 달리기 가장 편한 신발은?</p></div>
										<div class="answer">
											<div class="choice <% If arrUserAnswerQuiz(9) = 1 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/189/B001897215.jpg" alt="" /></div>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(9) = 2 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/193/B001938296.jpg" alt="" /></div>
											</div>
											<div class="choice correct">
												<div class="thumbnail"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/img_3_10_3.jpg" alt="" /></div>
											</div>
											<div class="choice <% If arrUserAnswerQuiz(9) = 4 Then %>my<% End If %>">
												<div class="thumbnail"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/img_3_10_4.jpg" alt="" /></div>
											</div>
										</div>
									</li>
								</ol>
						<% End Select %>
						<ul>
							<% Select Case Trim(vChasu) %>
								<% Case "20180508" %>
									<li><a href="" onclick="fnAPPpopupEvent('86365');return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/btn_item.png" alt="문제에 나온 상품 보러가기" /></a></li>
								<% Case "20180509" %>
									<li><a href="" onclick="fnAPPpopupEvent('86366');return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/btn_item.png" alt="문제에 나온 상품 보러가기" /></a></li>
								<% Case "20180510" %>
									<li><a href="" onclick="fnAPPpopupEvent('86368');return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/btn_item.png" alt="문제에 나온 상품 보러가기" /></a></li>
								<% Case Else %>
									<li><a href="" onclick="fnAPPpopupEvent('86365');return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/btn_item.png" alt="문제에 나온 상품 보러가기" /></a></li>
							<% End Select %>
						</ul>
					</div>
				</div>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->