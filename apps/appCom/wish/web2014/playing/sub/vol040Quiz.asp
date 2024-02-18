<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 2018 Playing TenQuiz
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
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/playing/playingCls.asp" -->
<%
	Dim cPl, i, vIsAdmin, vStartDate, vState, vDIdx, vIsMine
	vStartDate = "getdate()"
	vState = "7"

	vIsAdmin = RequestCheckVar(request("isadmin"),1)
	If vIsAdmin = "o" Then
		vStartDate = "''" & RequestCheckVar(request("sdate"),10) & "''"
		vState = RequestCheckVar(request("state"),1)
	End If

	vDIdx = RequestCheckVar(request("didx"),10)
	
	If vDIdx = "" Then
		Response.Write "<script>alert('잘못된 경로입니다.');top.location.href='/playing/';</script>"
		dbget.close()
		Response.End
	Else
		If Not isNumeric(vDidx) Then
			Response.Write "<script>alert('잘못된 경로입니다.');top.location.href='/playing/';</script>"
			dbget.close()
			Response.End
		End If
	End If
	
	SET cPl = New CPlay
	cPl.FRectDIdx			= vDIdx
	cPl.FRectStartdate 	= vStartDate
	cPl.FRectState 		= vState
	cPl.sbPlayCornerDetail()
	
	If cPl.FResultCount < 1 Then
		Response.Write "<script>alert('없는 코너 번호입니다.');top.location.href='/playing/';</script>"
		dbget.close()
		Response.End
	End If
	
	Dim vCate, vCateName, vTitle, vSubCopy, vContents, vIsExec, vExecFile, vBGColor, vImageList, vItemList, vSquareImg, vRectangleImg, vTitleStyle
	Dim vViewCntW, vViewCntM, vViewCntA, vTagAnnounce, vTagSDate, vTagEDate
	vCate 		= cPl.FOneItem.Fcate
	'vCateName 	= cPl.FOneItem.Fcatename
	vTitle 	= cPl.FOneItem.Ftitle
	vTitleStyle= cPl.FOneItem.Ftitlestyle
	vSubCopy	= cPl.FOneItem.Fsubcopy
	vStartDate	= cPl.FOneItem.Fstartdate
	vContents	= cPl.FOneItem.Fcontents
	vIsExec	= cPl.FOneItem.FisExec
	vExecFile	= cPl.FOneItem.Fexecfile
	vBGColor	= cPl.FOneItem.Fbgcolor
	vViewCntW	= cPl.FOneItem.FViewCnt_W
	vViewCntM	= cPl.FOneItem.FViewCnt_M
	vViewCntA	= cPl.FOneItem.FViewCnt_A
	vTagSDate	= cPl.FOneItem.FtagSDate
	vTagEDate	= cPl.FOneItem.FtagEDate
	vTagAnnounce = cPl.FOneItem.Ftag_announcedate
	
	vImageList 	= cPl.FImgArr
	vSquareImg		= fnPlayImageSelect(vImageList,vCate,"11","i")
	vRectangleImg	= fnPlayImageSelect(vImageList,vCate,"1","i")
	
	
	'### 뷰 카운트 w,m,a. 미리보기 체크 X.
	If vIsAdmin <> "o" Then
		If cPl.FOneItem.Fstartdate <= date() Then
			Call fnPlayViewCount(vDIdx,"a")
		End If
	End If
	SET cPl = Nothing


	Dim userid, vQuery, currenttime, vEventStartDate, vEventEndDate, vChasu
	Dim numTimes, TodayCount, TotalMileage, TodayDateCheck, vTestCheck
	'### SNS 변수선언
	Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg, kakaotitle, kakaoimage, kakaoimg_width, kakaoimg_height, kakaolink_url
	Dim tenQuizreferer
	
	'### 다른 코너 보기 변수선언
	Dim clistmore, vListMoreArr, limo, tenQuizNowPage

	userid = GetEncLoginUserID()

	'// 현재시간
	currenttime = now()
	'// 오픈전까지 테스트를 위한 시간 셋팅
'	currenttime = "2018-05-08 오전 10:03:35"

	'// 이벤트 시작, 종료일
	vEventStartDate = "2018-05-08"
	vEventEndDate = "2018-05-10"

	'// 정상적인 경로로 접속했는지 확인하기 위한 레퍼러값
	tenQuizreferer = RequestCheckVar(request("tenquizreferer"),2500)

	'// 다음 문제로 넘기기위해 현재 출력되는 URL값 필요
	tenQuizNowPage = Request.ServerVariables("SERVER_NAME")&Request.ServerVariables("PATH_INFO")
	If Request.ServerVariables("QUERY_STRING") <> "" Then
		tenQuizNowPage = tenQuizNowPage&"?"&Request.ServerVariables("QUERY_STRING")
	End If

	'// TenQuiz를 통해 넘어왔는지 확인한다.
	if InStr(LCase(tenQuizreferer),LCase("10x10.co.kr/apps/appCom/wish/web2014/playing/sub"))<1 Then
		'// playing 시스템상 해당 오픈일자가 아니면 뒤에 파라미터가 붙고 관리자가 로그인 해야만 접근 가능하여 분기처리함.
		if now() < "2018-05-08" then
			Response.Write "<script>alert('정상적인 경로로 접속해주세요.');fnAPPopenerJsCallClose('TenQuizmainReload()');</script>"
			Response.End
		Else
			Response.Write "<script>alert('정상적인 경로로 접속해주세요.');location.href='/apps/appCom/wish/web2014/playing/sub/vol040Main.asp?didx="&vdidx&"';</script>"
			Response.End
		End If
	end If

	'// TenQuiz 이벤트 기간인지 확인한다.
	If not( left(trim(currenttime),10)>=trim(vEventStartDate) and left(trim(currenttime),10) < trim(DateAdd("d", 1, trim(vEventEndDate))) ) Then
		'// playing 시스템상 해당 오픈일자가 아니면 뒤에 파라미터가 붙고 관리자가 로그인 해야만 접근 가능하여 분기처리함.
		if now() < "2018-05-08" then
			Response.Write "<script>alert('TenQuiz 참여기간이 아닙니다.');location.href='/apps/appCom/wish/web2014/playing/sub/vol040Main.asp?isadmin="&visAdmin&"&didx="&vdidx&"&state="&vstate&"&sdate="&vStartDate&"';</script>"
			Response.End
		Else
			Response.Write "<script>alert('TenQuiz 참여기간이 아닙니다.');location.href='/apps/appCom/wish/web2014/playing/sub/vol040Main.asp?didx="&vdidx&"';</script>"
			Response.End
		End If
	End If

	'// TenQuiz 참여가능시간인지 확인한다.
	If Not(TimeSerial(Hour(currenttime), minute(currenttime), second(currenttime)) >= TimeSerial(10, 00, 00) And TimeSerial(Hour(currenttime), minute(currenttime), second(currenttime)) < TimeSerial(21, 59, 59)) Then
		'// playing 시스템상 해당 오픈일자가 아니면 뒤에 파라미터가 붙고 관리자가 로그인 해야만 접근 가능하여 분기처리함.
		if now() < "2018-05-08" then
			Response.Write "<script>alert('TenQuiz는 오전 10시부터 오후 10시까지만\n참여가능합니다.');location.href='/apps/appCom/wish/web2014/playing/sub/vol040Main.asp?isadmin="&visAdmin&"&didx="&vdidx&"&state="&vstate&"&sdate="&vStartDate&"';</script>"
			Response.End
		Else
			Response.Write "<script>alert('TenQuiz는 오전 10시부터 오후 10시까지만\n참여가능합니다.');location.href='/apps/appCom/wish/web2014/playing/sub/vol040Main.asp?didx="&vdidx&"';</script>"
			Response.End
		End If
	End If

	Dim prevQuizNumber, nowQuizNumber, masterIdx
	Dim prevQuizAnswer, prevQuizUserAnswer
	Dim answerQuiz, arrAnswerQuiz, tmpUserScore

	'// 차수값(최초 진입시엔 없지만 풀이도중엔 chasu값이 있으므로 request로 받음)
	vChasu = request.form("chasu")
	'// 지난퀴즈넘버(즉 사용자가 푼 퀴즈번호)
	prevQuizNumber = request.Form("prevQuizNumber")
	'// 지난퀴즈넘버(즉 사용자가 푼 퀴즈번호의 사용자 답안)
	prevQuizUserAnswer = request.Form("prevQuizUserAnswer")
	'// 최초접속이 아니면 masterIdx는 문제푸는동안엔 항상 같음
	masterIdx = request.Form("masterIdx")

	If Trim(vChasu) = "" Then
		'// 차수값(해당일자의 "-"값을뺀 년월일값)
		vChasu = Replace(Left(Trim(currenttime), 10), "-", "")
	End If

	vTestCheck = False
	If IsUserLoginOK() Then
		'// 해당차수 문제풀었는지 확인
		vQuery = "SELECT * FROM [db_temp].[dbo].[tbl_PlayingTenQuizUserMasterData] WITH (NOLOCK) WHERE userid='"&userid&"' And chasu='"&vChasu&"' "
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
			If Not(rsget.bof Or rsget.eof) Then
				vTestCheck = True
			End If
		rsget.close
	End If

	'// 일자별 TenQuiz 답안
	Select Case Left(Trim(currenttime), 10)
		Case "2018-05-08"
			answerQuiz = ",2,2,4,4,4,1,1,4,1,4"
		Case "2018-05-09"
			answerQuiz = ",3,2,4,4,3,2,4,4,1,1"
		Case "2018-05-10"
			answerQuiz = ",4,3,2,1,2,4,2,2,4,3"
		Case Else
			if now() < "2018-05-08" then
				Response.Write "<script>alert('TenQuiz 참여기간이 아닙니다.');location.href='/apps/appCom/wish/web2014/playing/sub/vol040Main.asp?isadmin="&visAdmin&"&didx="&vdidx&"&state="&vstate&"&sdate="&vStartDate&"';</script>"
				Response.End
			Else
				Response.Write "<script>alert('TenQuiz 참여기간이 아닙니다.');location.href='/apps/appCom/wish/web2014/playing/sub/vol040Main.asp?didx="&vdidx&"';</script>"
				Response.End
			End If
	End Select

	'// 답안 확인을 위해 split로 쪼갬
	arrAnswerQuiz = Split(answerQuiz, ",")

	'// 기존 퀴즈넘버가 없고 TenQuizMain을 통해 넘어왔으면..
	If prevQuizNumber = "" And InStr(LCase(tenQuizreferer),LCase("10x10.co.kr/apps/appCom/wish/web2014/playing/sub/vol040main.asp")) > 0 Then
		'// 최초 진입이기때문에 기존 퀴즈 진입 내역이 있으면 안됨
		If vTestCheck Then
			if now() < "2018-05-08" then
				Response.Write "<script>alert('해당일자 퀴즈는 이미 참여하셨습니다.');location.href='/apps/appCom/wish/web2014/playing/sub/vol040Main.asp?isadmin="&visAdmin&"&didx="&vdidx&"&state="&vstate&"&sdate="&vStartDate&"';</script>"
				Response.End
			Else
				Response.Write "<script>alert('해당일자 퀴즈는 이미 참여하셨습니다.');location.href='/apps/appCom/wish/web2014/playing/sub/vol040Main.asp?didx="&vdidx&"';</script>"
				Response.End
			End If
		End If
		nowQuizNumber = 1
		prevQuizNumber = 0
		vQuery = "INSERT INTO [db_temp].[dbo].[tbl_PlayingTenQuizUserMasterData](userid, chasu, answercount, score, snscheck, regdate, lastupdate) VALUES('" & userid & "', '" & vChasu & "', 0, 0, 'N', getdate(), getdate())"
		dbget.Execute vQuery

		'// MasterIdx값을 가져온다.
		vQuery = "SELECT top 1 idx FROM [db_temp].[dbo].[tbl_PlayingTenQuizUserMasterData] WITH (NOLOCK) WHERE userid='"&userid&"' And chasu='"&vChasu&"' "
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
			If Not(rsget.bof Or rsget.eof) Then
				masterIdx = rsget(0)
			End If
		rsget.close
	Else
		'// 최초 시작 이외에는 반드시 기존 퀴즈 넘버가있어야됨.
		If prevQuizNumber<>"" Then
			'// 지난 퀴즈 넘버가 있기 때문에 기존 퀴즈 진입 내역이 있어야됨
			If Not(vTestCheck) Then
				if now() < "2018-05-08" then
					Response.Write "<script>alert('정상적인 경로로 접속해주세요.');location.href='/apps/appCom/wish/web2014/playing/sub/vol040Main.asp?isadmin="&visAdmin&"&didx="&vdidx&"&state="&vstate&"&sdate="&vStartDate&"';</script>"
					Response.End
				Else
					Response.Write "<script>alert('정상적인 경로로 접속해주세요.');location.href='/apps/appCom/wish/web2014/playing/sub/vol040Main.asp?didx="&vdidx&"';</script>"
					Response.End
				End If
			End If

			'// 기존문제 풀었던 내역이 있으면 안됨.(뒤로가기 방지)
			vQuery = "SELECT * FROM [db_temp].[dbo].[tbl_PlayingTenQuizUserDetailData] WITH (NOLOCK) WHERE userid='"&userid&"' And chasu='"&vChasu&"' And questionnumber='"&prevQuizNumber&"' "
			rsget.CursorLocation = adUseClient
			rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
				If Not(rsget.bof Or rsget.eof) Then
					if now() < "2018-05-08" then
						Response.Write "<script>alert('이미 풀었던 문제입니다.');location.href='/apps/appCom/wish/web2014/playing/sub/vol040Main.asp?isadmin="&visAdmin&"&didx="&vdidx&"&state="&vstate&"&sdate="&vStartDate&"';</script>"
						Response.End
					Else
						Response.Write "<script>alert('이미 풀었던 문제입니다.');location.href='/apps/appCom/wish/web2014/playing/sub/vol040Main.asp?didx="&vdidx&"';</script>"
						Response.End
					End If
				End If
			rsget.close

			'// 마지막으로 풀었던 문제와 현재 푼 문제의 시간값이 러프하게 12초 이상 차이나면 튕겨냄
			vQuery = "SELECT TOP 1 regdate FROM [db_temp].[dbo].[tbl_PlayingTenQuizUserDetailData] WITH (NOLOCK) WHERE userid='"&userid&"' And chasu='"&vChasu&"' ORDER BY detailidx desc "
			rsget.CursorLocation = adUseClient
			rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
				If Not(rsget.bof Or rsget.eof) Then
					If datediff("s", rsget("regdate"), now()) >= 12 Then
						if now() < "2018-05-08" then
							Response.Write "<script>alert('문제풀이 시간이 초과되었습니다.');location.href='/apps/appCom/wish/web2014/playing/sub/vol040Main.asp?isadmin="&visAdmin&"&didx="&vdidx&"&state="&vstate&"&sdate="&vStartDate&"';</script>"
							Response.End
						Else
							Response.Write "<script>alert('문제풀이 시간이 초과되었습니다.');location.href='/apps/appCom/wish/web2014/playing/sub/vol040Main.asp?didx="&vdidx&"';</script>"
							Response.End
						End If
					End If
				End If
			rsget.close

			nowQuizNumber = prevQuizNumber + 1

			If arrAnswerQuiz(prevQuizNumber) = prevQuizUserAnswer Then
				tmpUserScore = 1
			Else
				tmpUserScore = 0
			End If

			vQuery = "UPDATE [db_temp].[dbo].[tbl_PlayingTenQuizUserMasterData] SET answercount = answercount + 1, score = score + "&tmpUserScore&", lastupdate = getdate() WHERE userid='"&userid&"' And chasu='"&vChasu&"' "
			dbget.Execute vQuery

			vQuery = "INSERT INTO [db_temp].[dbo].[tbl_PlayingTenQuizUserDetailData](userid, masteridx, chasu, questionnumber, useranswer, answer, regdate) VALUES('" & userid & "', '"&masterIdx&"', '" & vChasu & "', '"&prevQuizNumber&"', '"&prevQuizUserAnswer&"', '"&arrAnswerQuiz(prevQuizNumber)&"', getdate())"
			dbget.Execute vQuery

			If Trim(prevQuizNumber) = 10 Then
				if now() < "2018-05-08" then
					Response.redirect "/apps/appCom/wish/web2014/playing/sub/vol040Result.asp?isadmin="&visAdmin&"&didx="&vdidx&"&state="&vstate&"&sdate="&vStartDate
					Response.End
				Else
					Response.redirect "/apps/appCom/wish/web2014/playing/sub/vol040Result.asp?didx="&vdidx
					Response.End
				End If
			End If
		Else
			'// playing 시스템상 해당 오픈일자가 아니면 뒤에 파라미터가 붙고 관리자가 로그인 해야만 접근 가능하여 분기처리함.
			if now() < "2018-05-08" then
				Response.Write "<script>alert('정상적인 경로로 접속해주세요.');location.href='/apps/appCom/wish/web2014/playing/sub/vol040Main.asp?isadmin="&visAdmin&"&didx="&vdidx&"&state="&vstate&"&sdate="&vStartDate&"';</script>"
				Response.End
			Else
				Response.Write "<script>alert('정상적인 경로로 접속해주세요.');location.href='/apps/appCom/wish/web2014/playing/sub/vol040Main.asp?didx="&vdidx&"';</script>"
				Response.End
			End If
		End If
	End If
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<title>10x10: PLAYing - TenQuiz</title>
<!-- #include virtual="/apps/appCom/wish/web2014/playing/inc_cssscript.asp" -->
<style type="text/css">
.tenquiz {position:relative; text-align:center; background:#f5f5f5;}
.q-list li {padding:1.8rem 0; text-align:center;}
.q-list .page {padding-top:1.5rem;}
.q-list .num {width:5.55rem; height:5.55rem; margin:0 auto 1.5rem; font-size:2rem; line-height:5.6rem; color:#d91066; background:url(http://webimage.10x10.co.kr/playing/thing/vol040/m/bg_num.gif?v=1) 0 0 no-repeat; background-size:100% auto;}
.q-list .txt {display:table; width:100%; margin-bottom:1.2rem; font-size:1.62rem; line-height:1.4; color:#000;}
.q-list .txt p {display:table-cell; height:4.7rem; vertical-align:middle;}
.q-list .image-cont {overflow:hidden; margin:0 auto;}
.q-list .thumbnail {position:relative;}
.q-list .thumbnail:after {content:''; display:inline-block; position:absolute; left:0; top:0; z-index:5; width:100%; height:100%; background:rgba(0,0,0,.02);}
.q-list .answer {overflow:hidden; width:27rem; margin:0 auto;}
.q-list .answer .choice {float:left; width:12.6rem; height:3.84rem; margin-top:1.37rem; font-size:1.2rem; line-height:3.9rem; color:#666; border:1px solid #666; border-radius:2rem; cursor:pointer;}
.q-list .answer .choice:nth-child(even) {float:right;}
.q-list .type1 .image-cont {width:18.8rem; margin-bottom:0.3rem;}
.q-list .type2 .image-cont {width:18.8rem;}
.q-list .type2 .image-cont > div {float:left; width:50%;}
.q-list .type3 .image-cont {width:27rem; margin-top:2.7rem; margin-bottom:2.7rem;}
.q-list .type3 .image-cont > div {float:left; width:50%;}
.q-list .type4 .answer {min-height:29rem; margin-top:1.3rem;}
.q-list .type4 .choice {height:auto; padding:1.05rem 0; line-height:1; border-radius:0.8rem; background:#fff;}
.q-list .type4 .choice span {display:inline-block; padding-top:0.4rem; font-size:1.1rem; line-height:1; color:#333; vertical-align:top;}
.q-list .type4 .choice .thumbnail {overflow:hidden; width:9rem; height:9rem; margin:0 auto; border-radius:50%;}

.result {text-align:center; color:#000; background-color:#ffcbd8;}
.result .inner {position:relative;}
.result .inner > strong {display:block; position:absolute; left:0; top:11%; width:100%; font-size:2rem;}
.result .inner.win:after {content:''; position:absolute; left:0; top:0; width:100%; height:60%; background:url(http://webimage.10x10.co.kr/playing/thing/vol040/m/bg_win.png) 0 0 no-repeat; background-size:100% auto;}
.result .inner .score {position:absolute; left:21%; top:22%; width:58%; height:50%; text-align:center; color:#fff;}
.result .inner .score div {display:table; width:100%; height:100%;}
.result .inner .score p {display:table-cell; font-size:1.5rem;  vertical-align:middle;}
.result .inner .score strong {display:block; padding-top:1.28rem; font-size:6rem; font-weight:600;}
.result .inner .score em {display:inline-block; padding-top:1.5rem; font-size:1.02rem; line-height:1.4; color:rgba(255,255,255,.9);}
.result .inner .success {position:absolute; left:0; bottom:6.7%; width:100%; font-size:1.1rem;}
.result .inner .success p:nth-child(2) {display:inline-block; height:2.73rem; margin:0.5rem 0 0.7rem; padding:0 2.56rem; font-size:1.37rem; font-weight:bold; line-height:2.8rem; background:rgba(255,255,255,.5); border-radius:1.5rem;}

#lyrHint {display:none; position:absolute; left:0; top:0; z-index:100; width:100%; height:100%; padding-top:1rem; background:rgba(0,0,0,.4);}
#lyrHint .inner {width:92%; margin:0 auto; background:#fff; border-radius:1.3rem;}
#lyrHint .q-list li {padding:0 0 2.7rem;}
#lyrHint .q-list .txt {display:block;}
#lyrHint .q-list .txt p {display:block; height:auto; padding-top:0;}
#lyrHint .q-list .answer {width:24.24rem;}
#lyrHint .q-list .answer .choice {width:11.78rem;}
#lyrHint .q-list .type4 .answer {margin-top:0;}
#lyrHint .btn-close {position:absolute; right:3%; top:1.5%; width:12.46%; background:transparent;}
</style>
<script type="text/javascript">
	$(function(){
		var position = $('.thingVol040').offset(); // 위치값
		$('html,body').animate({ scrollTop : position.top },300); // 이동

		// 레이어 닫기
		$("#lyrHint .btn-close").click(function(){
			$("#lyrHint").hide();
		});

		var counter = 10;
		setInterval(function() {
			counter--;
			if (counter > 0)
			{
				<% Select Case Left(Trim(currenttime), 10) %>
					<% Case "2018-05-08" %>
						$("#day1num<%=nowQuizNumber%>").empty().html(counter);
					<% Case "2018-05-09" %>
						$("#day2num<%=nowQuizNumber%>").empty().html(counter);
					<% Case "2018-05-10" %>
						$("#day3num<%=nowQuizNumber%>").empty().html(counter);
				<% end select %>
			}
			if (counter === 0)
			{
				clearInterval(counter);
				QuizNextTimeOutStep();
			}
		}, 1000);

		$(".quiz .answer .choice").click(function(){
			$(this).addClass("on");
			document.playingQuizFrm.prevQuizUserAnswer.value = $(this).index()+1;
			document.playingQuizFrm.action="/apps/appCom/wish/web2014/playing/sub/vol040Quiz.asp";
			document.playingQuizFrm.submit();
		});
	});

	function QuizNextTimeOutStep()
	{
		document.playingQuizFrm.action="/apps/appCom/wish/web2014/playing/sub/vol040Quiz.asp";
		document.playingQuizFrm.submit();
	}
</script>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content playV16" id="contentArea">
			<article class="playDetailV16 thing">
				<div class="hgroup">
					<div>
						<a href="list.asp?cate=thing" class="corner">THING.</a>
						<h2><%=vTitle%></h2>
					</div>
				</div>
				<div class="cont">
					<div class="detail">
						<%' THING. html 코딩 영역 : 클래스명은 thing+볼륨 예) thingVol001 / 이미지폴더는 볼륨을 따라 vol001 %>
						<%' 텐퀴즈 : 퀴즈,결과 %>
						<div class="thingVol040 tenquiz">
							<%' 퀴즈 %>
								<!-- #include virtual="/apps/appCom/wish/web2014/playing/sub/inc_QuizList.asp" -->
							<%'// 퀴즈 %>
						</div>
						<!-- //THING. html 코딩 영역 -->
					</div>
					<form method="post" name="playingQuizFrm" id="playingQuizFrm">
						<input type="hidden" name="isadmin" value="<%=vIsAdmin%>">
						<input type="hidden" name="sdate" value="<%=vStartDate%>">
						<input type="hidden" name="state" value="<%=vState%>">
						<input type="hidden" name="didx" value="<%=vDIdx%>">
						<input type="hidden" name="chasu" value="<%=vChasu%>">
						<input type="hidden" name="prevQuizNumber" value="<%=prevQuizNumber+1%>">
						<input type="hidden" name="prevQuizUserAnswer" value="<%=prevQuizUserAnswer%>">
						<input type="hidden" name="masterIdx" value="<%=masterIdx%>">
						<input type="hidden" name="tenquizreferer" value="<%=tenQuizNowPage%>">
					</form>
					<%
					snpTitle	= vTitle
					snpLink		= wwwUrl&"/playing/view.asp?didx="&vDIdx&"" '### PC주소
					snpPre		= "10x10 PLAYing"
					snpTag 		= "텐바이텐 " & Replace(vTitle," ","")
					snpTag2 	= "#10x10"

					'// 카카오링크 변수
					kakaotitle = "[텐바이텐] PLAYing - " & Replace(vTitle," ","") & ""
					kakaoimage = vSquareImg
					kakaoimg_width = "200"
					kakaoimg_height = "200"
					snpImg=kakaoimage
					If isapp = "1" Then '앱일경우
						kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/playing/view.asp?didx="&vDIdx
					Else '앱이 아닐경우
						kakaolink_url = "http://m.10x10.co.kr/playing/view.asp?didx="&vDIdx
					End If
					%>
					<script>
					// SNS 공유 팝업
					function fnAPPRCVpopSNS(){
						//fnAPPpopupBrowserURL("공유","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popShare.asp?sTit=<%=snpTitle%>&sLnk=<%=snpLink%>&sPre=<%=snpPre%>&sImg=<%=vSquareImg%>");
						$("#lySns").show();
						$("#lySns .inner").removeClass("lySlideDown").addClass("lySlideUp");
						return false;
					}
					</script>
				</div>
			</article>
		</div>
		<!-- //content area -->
	</div>
</div>
<!-- #include virtual="/apps/appCom/wish/web2014/common/LayerShare.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->