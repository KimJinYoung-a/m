<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 2018 Playing TenQuizMain
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
	
	'### 다른 코너 보기 변수선언
	Dim clistmore, vListMoreArr, limo, tenQuizNowPage
	Dim vTestCheck20180508, vTestCheck20180509, vTestCheck20180510
	Dim vUserTotal, vRightUser

	userid = GetEncLoginUserID()

	'// 현재시간
	currenttime = now()
'	currenttime = "2018-05-08 오전 10:03:35"

	vEventStartDate = "2018-05-08"
	vEventEndDate = "2018-05-10"

	vChasu = Replace(Left(Trim(currenttime), 10), "-", "")
	vTestCheck = False
	vTestCheck20180508 = False
	vTestCheck20180509 = False
	vTestCheck20180510 = False

	If IsUserLoginOK() Then
		'// 해당차수 문제풀었는지 확인
		vQuery = "SELECT * FROM [db_temp].[dbo].[tbl_PlayingTenQuizUserMasterData] WITH (NOLOCK) WHERE userid='"&userid&"' And chasu='"&vChasu&"' "
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
			If Not(rsget.bof Or rsget.eof) Then
				vTestCheck = True
			End If
		rsget.close

		'// 20180508차수 문제풀었는지 확인
		vQuery = "SELECT * FROM [db_temp].[dbo].[tbl_PlayingTenQuizUserMasterData] WITH (NOLOCK) WHERE userid='"&userid&"' And chasu='20180508' "
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
			If Not(rsget.bof Or rsget.eof) Then
				vTestCheck20180508 = True
			End If
		rsget.close

		'// 20180509차수 문제풀었는지 확인
		vQuery = "SELECT * FROM [db_temp].[dbo].[tbl_PlayingTenQuizUserMasterData] WITH (NOLOCK) WHERE userid='"&userid&"' And chasu='20180509' "
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
			If Not(rsget.bof Or rsget.eof) Then
				vTestCheck20180509 = True
			End If
		rsget.close

		'// 20180510차수 문제풀었는지 확인
		vQuery = "SELECT * FROM [db_temp].[dbo].[tbl_PlayingTenQuizUserMasterData] WITH (NOLOCK) WHERE userid='"&userid&"' And chasu='20180510' "
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
			If Not(rsget.bof Or rsget.eof) Then
				vTestCheck20180510 = True
			End If
		rsget.close
	End If

	vQuery = "SELECT count(userid) FROM [db_temp].[dbo].[tbl_PlayingTenQuizUserMasterData] WITH (NOLOCK) WHERE chasu='"&vChasu&"' "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
		If Not(rsget.bof Or rsget.eof) Then
			vUserTotal = rsget(0)
		End If
	rsget.close

	vQuery = "SELECT count(userid) FROM [db_temp].[dbo].[tbl_PlayingTenQuizUserMasterData] WITH (NOLOCK) WHERE chasu='"&vChasu&"' And score=10 "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
		If Not(rsget.bof Or rsget.eof) Then
			vRightUser = rsget(0)
		End If
	rsget.close

	tenQuizNowPage = Request.ServerVariables("SERVER_NAME")&Request.ServerVariables("PATH_INFO")
	If Request.ServerVariables("QUERY_STRING") <> "" Then
		tenQuizNowPage = tenQuizNowPage&"?"&Request.ServerVariables("QUERY_STRING")
	End If
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<title>10x10: PLAYing - TenQuiz</title>
<!-- #include virtual="/apps/appCom/wish/web2014/playing/inc_cssscript.asp" -->
<style type="text/css">
.tenquiz-intro {position:relative; padding-bottom:5.12rem; color:#000; font-size:1.2rem; font-weight:600; text-align:center; background:#ffc3dc;}
.tenquiz-intro .navigation {position:relative;}
.tenquiz-intro .navigation ol {position:absolute; left:0; top:0; width:100%; height:100%;}
.tenquiz-intro .navigation li {position:relative; float:left; width:33.33333%; height:100%; background-repeat:no-repeat; background-position:0 0; background-size:300% auto;}
.tenquiz-intro .navigation li em {display:block; text-indent:-999em;}
.tenquiz-intro .navigation li a {display:block; position:absolute; left:0; bottom:10%; width:100%; padding:5% 0;}
.tenquiz-intro .navigation li:nth-child(1) {background-position:0 0;}
.tenquiz-intro .navigation li:nth-child(2) {background-position:50% 0;}
.tenquiz-intro .navigation li:nth-child(3) {background-position:100% 0;}
.tenquiz-intro .navigation li.today {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol040/m/txt_date_today.png?v=1.0);}
.tenquiz-intro .navigation li.end {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol040/m/txt_date_end.png?v=1.0);}
.tenquiz-intro .btn-challenge {animation:animation1 1.2s 50;}
.tenquiz-intro .rules {display:none; position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.4);}
.tenquiz-intro .rules .inner {position:absolute; left:0; top:2%; z-index:99; width:100%;}
.tenquiz-intro .rules .btn-close {position:absolute; right:8%; top:0%; z-index:100; width:11.46%; background:transparent;}
.tenquiz-intro .rules .btn-start {position:absolute; left:50%; bottom:8%; z-index:100; width:72%; margin-left:-36%;}
.start {display:none; position:fixed; left:0; top:0; z-index:100; width:100%; height:100%; background:#f5f5f5;}
.start .swiper-container {margin-top:7rem;}
@keyframes animation1 {
	from, to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(-10px); animation-timing-function:ease-in;}
}
@keyframes animation2 {
	from,to {transform:scale(1); animation-timing-function:ease-out;}
	50% {transform:scale(1.15); animation-timing-function:ease-in;}
}

@keyframes hide {
	from {opacity:1;}
	to {opacity:0;}
}

.topic {position:relative;}
.count {position:absolute; left:57%; bottom:9%; width:33%;}
.count p {position:absolute; left:0; top:10%; width:100%; height:80%; padding-top:1.7rem; text-align:center; color:#fff; font-size:1.11rem;}
.count p strong {display:block; padding:0.3rem 0 0.4rem; font-size:1.8rem; font-weight:600; letter-spacing:-0.05rem;}
.count p span {font-size:.9rem;}
</style>
<script type="text/javascript">
	$(function(){
		var position = $('.thingVol040').offset(); // 위치값
		$('html,body').animate({ scrollTop : position.top },300); // 이동

		// 레이어 닫기
		$(".rules .btn-close").click(function(){
			$(".rules").hide();
		});

	});

	function startChallenge() {
		<% If not(IsUserLoginOK) Then %>
			parent.calllogin();
			return false;
		<% end if %>
		<% If not( left(trim(currenttime),10)>=trim(vEventStartDate) and left(trim(currenttime),10) < trim(DateAdd("d", 1, trim(vEventEndDate))) ) Then %>
			alert("TenQuiz 참여기간이 아닙니다.");
			return false;
		<% end if %>
		$.ajax({
			type:"GET",
			url:"/apps/appCom/wish/web2014/playing/sub/vol040Check.asp",
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
								$(".rules").show();
								window.parent.$('html,body').animate({scrollTop:$(".rules").offset().top},500);
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


	function moveQuiz()
	{
		$.ajax({
			type:"GET",
			url:"/apps/appCom/wish/web2014/playing/sub/vol040Check.asp",
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
								// START
								$(".start").show();
								startSwipe = new Swiper('.start .swiper-container',{
									loop:false,
									autoplay:500,
									speed:50,
									effect:'fade'
								});
								setTimeout(function(){
									startSwipe.destroy();
									//$(".start").hide();
									document.tenQuizMainFrm.submit();
									<% if now() < "2018-05-08" then %>
										//fnAPPpopupBrowserURL('TenQuiz','<%=wwwUrl%>/apps/appCom/wish/web2014/playing/sub/vol040Quiz.asp?isadmin=o&sdate=2018-05-08&state=7&didx=237&tenquizreferer=<%=Server.URLEncode(tenQuizNowPage)%>&chasu=<%=vChasu%>');
										//return false;									
									<% else %>
										//fnAPPpopupBrowserURL('TenQuiz','<%=wwwUrl%>/apps/appCom/wish/web2014/playing/sub/vol040Quiz.asp?&tenquizreferer=<%=Server.URLEncode(tenQuizNowPage)%>&chasu=<%=vChasu%>');
										//return false;
									<% end if %>
								},3250);
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

	function TenQuizmainReload()
	{
		document.location.reload();
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
						<%' Playing Vol.40 TenQuiz %>
						<%' THING. html 코딩 영역 : 클래스명은 thing+볼륨 예) thingVol001 / 이미지폴더는 볼륨을 따라 vol001 %>
						<%' 텐퀴즈 : 인트로 %>
						<div class="thingVol040 tenquiz-intro">
							<div class="start">
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
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/txt_start_6.png" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/txt_start_6.png" alt="" /></div>
										<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/txt_start_6.png" alt="" /></div>
									</div>
								</div>
							</div>
							<div class="topic">
								<h2><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/tit_ten_quiz.png" alt="TEN QUIZ - 3일간 진행하는 TEN QUIZ! 하루에 10문제 풀고 상금(마일리지) 받아가세요!" /></h2>
								<div class="count">
									<p>
										현재 성공 <strong><%=FormatNumber(vRightUser, 0)%> 명</strong>
										<span>참여 <%=FormatNumber(vUserTotal, 0)%>명</span>
									</p>
									<div><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/bg_count.png" alt="지난 문제 보기" /></div>
								</div>
							</div>
							<div class="navigation">
								<ol>
									<%' for dev msg : 오늘:today / 종료:end 클래스 붙여주세요 %>
									<li 
										<% If Left(currenttime, 10)="2018-05-08" Then%>
											class="today" 
										<% Else %>
											<% If Left(currenttime, 10) > "2018-05-08" Then %>
												class="end"
											<% End If %>
										<% End If %>><em>1DAY 5월 8일</em> 
										<% If vTestCheck20180508 Then %>
											<a href="" onclick="fnAPPpopupBrowserURL('TenQuiz','<%=wwwUrl%>/apps/appCom/wish/web2014/playing/sub/vol040question.asp?chasu=20180508');return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/btn_result.png" alt="지난 문제 보기" /></a>
										<% End If %></li>

									<li 
										<% If Left(currenttime, 10)="2018-05-09" Then%>
											class="today" 
										<% Else %>
											<% If Left(currenttime, 10) > "2018-05-09" Then %>
												class="end"
											<% End If %>
										<% End If %>><em>2DAY 5월 9일</em> 
										<% If vTestCheck20180509 Then %>
											<a href="" onclick="fnAPPpopupBrowserURL('TenQuiz','<%=wwwUrl%>/apps/appCom/wish/web2014/playing/sub/vol040question.asp?chasu=20180509');return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/btn_result.png" alt="지난 문제 보기" /></a>
										<% End If %></li>

									<li 
										<% If Left(currenttime, 10)="2018-05-10" Then%>
											class="today" 
										<% Else %>
											<% If Left(currenttime, 10) > "2018-05-10" Then %>
												class="end"
											<% End If %>
										<% End If %>><em>3DAY 5월 10일</em> 
										<% If vTestCheck20180510 Then %>
											<a href="" onclick="fnAPPpopupBrowserURL('TenQuiz','<%=wwwUrl%>/apps/appCom/wish/web2014/playing/sub/vol040question.asp?chasu=20180510');return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/btn_result.png" alt="지난 문제 보기" /></a>
										<% End If %></li>
								</ol>
								<div><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/txt_date.png" alt="" /></div>
							</div>
							<% If Left(Trim(currenttime),10) >= Trim(vEventStartDate) and Left(Trim(currenttime),10) < Trim(DateAdd("d", 1, Trim(vEventEndDate))) Then %>
								<% If Left(Trim(currenttime), 10) >= "2018-05-10" And TimeSerial(Hour(currenttime), minute(currenttime), second(currenttime)) >= TimeSerial(22, 00, 00) Then %>
								<% Else %>
									<% If Not(TimeSerial(Hour(currenttime), minute(currenttime), second(currenttime)) >= TimeSerial(10, 00, 00) And TimeSerial(Hour(currenttime), minute(currenttime), second(currenttime)) < TimeSerial(21, 59, 59)) Then %>
										<button class="btn-challenge">
											<img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/btn_challenge_1.png" alt="대기중" />
										</button>
									<% Else %>
										<% If vTestCheck Then %>
											<button class="btn-challenge">
												<img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/btn_challenge_3.png" alt="도전완료" />
											</button>
										<% Else %>
											<button class="btn-challenge" onclick="startChallenge();return false;" >
												<img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/btn_challenge_2.png" alt="도전하기" />
											</button>
										<% End If %>
									<% End If %>
									<p>오늘 단 한번 뿐인 도전이 시작됩니다.</p>
								<% End If %>
							<% Else %>
								<button class="btn-challenge">
									<img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/btn_challenge_1.png" alt="대기중" />
								</button>
							<% End If %>

							<%' 스타트 레이어 %>
							<div class="rules">
								<div class="inner">
									<div><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/txt_rules.png" alt="rules" /></div>
									<button class="btn-close"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/btn_close.png" alt="닫기" /></button>
									<a href="" onclick="moveQuiz();return false;" class="btn-start"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/btn_start.png?v=1.0" alt="START!" /></a>
								</div>
							</div>
							<%'// 스타트 레이어 %>
						</div>
						<%' //THING. html 코딩 영역 %>
					</div>
					<form name="tenQuizMainFrm" id="tenQuizMainFrm" method="post" action="/apps/appCom/wish/web2014/playing/sub/vol040quiz.asp">
						<input type="hidden" name="isadmin" value="<%=vIsAdmin%>">
						<input type="hidden" name="sdate" value="<%=vStartDate%>">
						<input type="hidden" name="state" value="<%=vState%>">
						<input type="hidden" name="didx" value="<%=vDIdx%>">
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
					<div class="listMore">
						<div class="more">
							<h2>다른 THING. 보기</h2>
							<a href="/apps/appCom/wish/web2014/playing/list.asp?cate=thing">more</a>
						</div>
						<ul>
						<%
						SET clistmore = New CPlay
						clistmore.FRectTop		= "3"
						clistmore.FRectStartdate	= "getdate()"
						clistmore.FRectState		= "7"
						clistmore.FRectCate		= fnPlayingCateVer2("topcode",vCate)
						clistmore.FRectDIdx		= vDIdx
						vListMoreArr = clistmore.fnPlayCornerMoreList
						SET clistmore = Nothing

						'd.didx, d.title, imgurl
						IF isArray(vListMoreArr) THEN
							For limo=0 To UBound(vListMoreArr,2)
						%>
							<li>
								<a href="/apps/appCom/wish/web2014/playing/view.asp?didx=<%=vListMoreArr(0,limo)%>">
									<div class="desc"><span><i><%=db2html(vListMoreArr(1,limo))%></i></span></div>
									<img src="<%=vListMoreArr(2,limo)%>" alt="" />
								</a>
							</li>
						<%
							Next
						End If
						%>
						</ul>
					</div>
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