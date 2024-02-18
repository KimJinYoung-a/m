<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 2018 Playing TenQuizResult
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
	Dim clistmore, vListMoreArr, limo

	Dim vUserScore, vUserTotal, vRightUser, masterIdx

	userid = GetEncLoginUserID()

	'// 현재시간
	currenttime = now()
'	currenttime = "2018-05-08 오전 10:03:35"

	vEventStartDate = "2018-05-08"
	vEventEndDate = "2018-05-10"

	vChasu = Replace(Left(Trim(currenttime), 10), "-", "")

	If IsUserLoginOK() Then
		'// 해당차수 점수확인
		vQuery = "SELECT * FROM [db_temp].[dbo].[tbl_PlayingTenQuizUserMasterData] WITH (NOLOCK) WHERE userid='"&userid&"' And chasu='"&vChasu&"' "
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
			If Not(rsget.bof Or rsget.eof) Then
				vUserScore = rsget("score")
				masterIdx = rsget("idx")
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
		kakaolink_url = "http://m.10x10.co.kr/playing/view.asp?didx="&vDIdx
	Else '앱이 아닐경우
		kakaolink_url = "http://m.10x10.co.kr/playing/view.asp?didx="&vDIdx
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
	});

	function getsnscnt() {
		<% If IsUserLoginOK() Then %>
			var str = $.ajax({
				type: "GET",
				url: "/apps/appcom/wish/web2014/playing/sub/vol040Check.asp",
				data: "mode=sns&masterIdx=<%=masterIdx%>",
				dataType: "text",
				async: false
			}).responseText;
			fnAPPshareKakao('etc','<%=kakaotitle%>','<%=kakaolink_url%>','<%=kakaolink_url%>','<%="url="&kakaolink_url%>','<%=kakaoimage%>','','','','');
			$("#lyrHint").show();
			window.parent.$('html,body').animate({scrollTop:$("#lyrHint").offset().top},500);
		<% Else %>
			calllogin();
			return false;
		<% End If %>
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
						<%' Playing Vol.40 TenQuizResult %>
						<%' THING. html 코딩 영역 : 클래스명은 thing+볼륨 예) thingVol001 / 이미지폴더는 볼륨을 따라 vol001 %>
						<%' 텐퀴즈 : 결과 %>
						<%' 결과 %>
						<div class="thingVol040 tenquiz">
							<div class="result <% If vUserScore = 10 Then %>win<% End If %>">
								<div class="inner <% If vUserScore = 10 Then %>win<% End If %>">
									<% If vUserScore >= 10 Then %>
										<strong>축하합니다!</strong>
									<% Else %>
										<% If Left(currenttime, 10) = "2018-05-10" Then %>
											<strong>이런, 아쉽군요ㅠ.ㅠ</strong>
										<% Else %>
											<strong>아쉽군요. 내일 다시 도전하세요!</strong>
										<% End If %>
									<% End If %>
									<div class="score">
										<div>
											<p>
												10문제 중
												<strong><%=vUserScore%>점</strong>
												<% If vUserScore >= 10 Then %>
													<em>최종 상금과 자세한 내용은<br />내일 개별적으로 전달됩니다.</em>
												<% End If %>
											</p>
										</div>
									</div>
									<div class="success">
										<p>현재까지</p>
										<p>도전 성공 <%=FormatNumber(vRightUser, 0)%>명</p>
										<p>참여자 <%=FormatNumber(vUserTotal, 0)%>명</p>
									</div>
									<div><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/bg_result.jpg?v=1" alt="" /></div>
								</div>
								<ul>
									<li><a href="" onclick="fnAPPpopupBrowserURL('TenQuiz','<%=wwwUrl%>/apps/appCom/wish/web2014/playing/sub/vol040question.asp?chasu=<%=vChasu%>');return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/btn_wrong.png?v=1.0" alt="오늘의 정담 확인하기" /></a></li>
									<% If Left(currenttime, 10) = "2018-05-08" Or Left(currenttime, 10)="2018-05-09" Then %>
										<li><a href="#lyrHint" onclick="getsnscnt();return false;" class="btn-hint"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/btn_share.png" alt="공유하고 내일 문제 힌트 얻기" /></a></li>
									<% End If %>
									<% Select Case Trim(Left(currenttime, 10)) %>
										<% Case "2018-05-08" %>
											<li><a href="" onclick="fnAPPpopupEvent('86365');return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/btn_item.png" alt="문제에 나온 상품 보러가기" /></a></li>
										<% Case "2018-05-09" %>
											<li><a href="" onclick="fnAPPpopupEvent('86366');return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/btn_item.png" alt="문제에 나온 상품 보러가기" /></a></li>
										<% Case "2018-05-10" %>
											<li><a href="" onclick="fnAPPpopupEvent('86368');return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/btn_item.png" alt="문제에 나온 상품 보러가기" /></a></li>
										<% Case Else %>
											<li><a href="" onclick="fnAPPpopupEvent('86365');return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/btn_item.png" alt="문제에 나온 상품 보러가기" /></a></li>
									<% End Select %>
								</ul>
							</div>
							<%'// 결과 %>

							<%' 힌트 레이어 %>
							<div id="lyrHint">
								<div class="inner">
									<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/tit_hint.png" alt="HINT - 미리보는 기출문제" /></h3>
									<ul class="q-list">
										<%' 9일 문제 힌트 %>
										<% If Left(currenttime, 10) = "2018-05-08" Then %>
											<li class="q5 type1">
												<div class="txt"><p>이 피규어의  브랜드는 어디일까요?</p></div>
												<div class="image-cont">
													<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/192/B001921172.jpg" alt="" /></div>
												</div>
												<div class="answer">
													<div class="choice">
														<span>뽀로로</span>
													</div>
													<div class="choice">
														<span>핑크퐁</span>
													</div>
													<div class="choice">
														<span>플레이모빌</span>
													</div>
													<div class="choice">
														<span>콩순이</span>
													</div>
												</div>
											</li>
										<% End If %>

										<% If Left(currenttime, 10) = "2018-05-09" Then %>
										<%' 10일 문제 힌트 %>
										<li class="q1 type4">
											<div class="txt"><p>브랜드와 이름의 연결이 알맞은 것은?</p></div>
											<div class="answer">
												<div class="choice">
													<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/59/B000596959-1.jpg" alt="" /></div>
													<span>서커스걸밴드</span>
												</div>
												<div class="choice">
													<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/181/B001812564-2.jpg" alt="" /></div>
													<span>모나비</span>
												</div>
												<div class="choice">
													<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/96/B000969515.jpg" alt="" /></div>
													<span>긴팔</span>
												</div>
												<div class="choice">
													<div class="thumbnail"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic600/151/B001517552.jpg" alt="" /></div>
													<span>I'MMEME (아임미미)</span>
												</div>
											</div>
										</li>
										<% End If %>
									</ul>
									<button class="btn-close"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/btn_close.png" alt="닫기" /></button>
								</div>
							</div>
							<%'// 힌트 레이어 %>
						</div>
						<%' //THING. html 코딩 영역 %>
					</div>
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