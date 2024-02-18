<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/util/tenSessionLib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
'####################################################
' Description :  부모님 모의고사 결과 페이지
' History : 2019-04-29 원승현
'          2020-04-22 정태훈
'####################################################

dim eCode, userid, currenttime, several
IF application("Svr_Info") = "Dev" THEN
	eCode = "102151"
    several=2 '회차 정보
Else
	eCode = "102078"
    several=2
End If

currenttime = now()
userid = requestcheckvar(request("userid"),1000)

on error resume next

Dim vQuery, examCheck, masterIdx
Dim userNm, parentNm, parentAge, sltvalue, sltyear, sltmonth, sltday, blood, clothsize, footsize, fafood, fadrama, facolor, fahobby, faentertainer
examCheck = FALSE
'// 해당 이벤트를 참여했는지 확인한다.
vQuery = "SELECT idx, userid, userName, parentName FROM [db_temp].[dbo].[tbl_event_parentdayexam_master] WITH (NOLOCK) WHERE several=" & several & " and userid = '" & Server.URLEncode(tenDec(userid)) & "' "
rsget.CursorLocation = adUseClient
rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
IF Not rsget.Eof Then
    examCheck = TRUE
    userNm = rsget("userName")
    parentNm = rsget("parentName")
    masterIdx = rsget("idx")
Else
    response.write "<script>alert('모의고사 참여 정보가 없습니다.');location.href='https://m.10x10.co.kr/apps/appCom/wish/web2014/event/etc/parentmocktest.asp';</script>"
    response.end
End If
rsget.close

If Err.Number <> 0 then 
    response.write "<script>alert('모의고사 참여 정보가 없습니다.');location.href='https://m.10x10.co.kr/apps/appCom/wish/web2014/event/etc/parentmocktest.asp';</script>"
    response.end
End If
On Error Goto 0

Dim c1Result, c2Result, c3Result, c4Result, c5Result, c6Result, c7Result, c8Result, c9Result, c10Result, c11Result
Dim parentGradeRightCount, parentGradeScore
parentGradeRightCount = 0
If examCheck Then
    vQuery = "SELECT idx, masterIdx, userid, questionNumber, Answer, ISNULL(marking,'') as marking FROM [db_temp].[dbo].[tbl_event_parentdayexam_detail] WITH (NOLOCK) WHERE userid = '" & Server.URLEncode(tenDec(userid)) & "' And masterIdx ='"&masterIdx&"' "
    rsget.CursorLocation = adUseClient
    rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
    IF Not rsget.Eof Then
        do until rsget.Eof
            If Trim(rsget("questionNumber")) = 1 Then
                parentAge = rsget("answer")
                c1Result = rsget("marking")
                If Trim(rsget("marking")) = "O" Then
                    parentGradeRightCount = parentGradeRightCount + 1
                End If
            End If
            If Trim(rsget("questionNumber")) = 2 Then
                sltvalue = split(rsget("answer"),"-")(0)
                sltyear = split(rsget("answer"),"-")(1)
                sltmonth = split(rsget("answer"),"-")(2)
                sltday = split(rsget("answer"),"-")(3)
                c2Result = rsget("marking")
                If Trim(rsget("marking")) = "O" Then
                    parentGradeRightCount = parentGradeRightCount + 1
                End If                
            End If
            If Trim(rsget("questionNumber")) = 3 Then
                blood = rsget("answer")
                c3Result = rsget("marking")
                If Trim(rsget("marking")) = "O" Then
                    parentGradeRightCount = parentGradeRightCount + 1
                End If
            End If
            If Trim(rsget("questionNumber")) = 4 Then
                clothsize = rsget("answer")
                c4Result = rsget("marking")
                If Trim(rsget("marking")) = "O" Then
                    parentGradeRightCount = parentGradeRightCount + 1
                End If
            End If
            If Trim(rsget("questionNumber")) = 5 Then
                footsize = rsget("answer")
                c5Result = rsget("marking")
                If Trim(rsget("marking")) = "O" Then
                    parentGradeRightCount = parentGradeRightCount + 1
                End If
            End If
            If Trim(rsget("questionNumber")) = 6 Then
                fafood = rsget("answer")
                c6Result = rsget("marking")
                If Trim(rsget("marking")) = "O" Then
                    parentGradeRightCount = parentGradeRightCount + 1
                End If
            End If
            If Trim(rsget("questionNumber")) = 7 Then
                fadrama = rsget("answer")
                c7Result = rsget("marking")
                If Trim(rsget("marking")) = "O" Then
                    parentGradeRightCount = parentGradeRightCount + 1
                End If
            End If
			If Trim(rsget("questionNumber")) = 8 Then
                facolor = rsget("answer")
                c8Result = rsget("marking")
                If Trim(rsget("marking")) = "O" Then
                    parentGradeRightCount = parentGradeRightCount + 1
                End If
            End If
			If Trim(rsget("questionNumber")) = 9 Then
                fahobby = rsget("answer")
                c9Result = rsget("marking")
                If Trim(rsget("marking")) = "O" Then
                    parentGradeRightCount = parentGradeRightCount + 1
                End If
            End If
			If Trim(rsget("questionNumber")) = 10 Then
                faentertainer = rsget("answer")
                c10Result = rsget("marking")
                If Trim(rsget("marking")) = "O" Then
                    parentGradeRightCount = parentGradeRightCount + 1
                End If
            End If
			If Trim(rsget("questionNumber")) = 11 Then
                c11Result = rsget("marking")
            End If
        rsget.movenext
        loop
    End If
    rsget.close
End If
parentGradeScore = cInt((parentGradeRightCount/10)*100)

'// SNS 공유용
    Dim vTitle, vLink, vPre, vImg
    Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

    snpTitle    = Server.URLEncode("[부모님 모의고사]")
    snpLink        = Server.URLEncode("https://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode)
    snpPre        = Server.URLEncode("10x10 이벤트")
    snpImg        = Server.URLEncode("https://webimage.10x10.co.kr/fixevent/event/2020/102078/m/img_kakao.jpg")
    appfblink     = "https://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode

    '// 카카오링크 변수
    Dim kakaotitle : kakaotitle = " [부모님 모의고사]"
    Dim kakaodescription : kakaodescription = "나는 부모님에 대해서 얼마나 알고 있을까? 지금 1분 만에 테스트해보세요!"
    Dim kakaooldver : kakaooldver = "나는 부모님에 대해서 얼마나 알고 있을까? 지금 1분 만에 테스트해보세요!"
    Dim kakaoimage : kakaoimage = "https://webimage.10x10.co.kr/fixevent/event/2020/102078/m/img_kakao.jpg"
    Dim kakaolink_url 
    If isapp = "1" Then '앱일경우
        kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
    Else '앱이 아닐경우
        kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
    End If

%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/1.7.1/clipboard.min.js"></script>
<script>

function snschk(snsnum) {
	if(snsnum=="fb"){
		// fnAPPShareSNS('fb','<%=replace(appfblink,"m.10x10.co.kr/","m.10x10.co.kr/apps/appcom/wish/web2014/")%>');
		popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','');				
	}else if(snsnum=="pt"){
		popSNSPost('pt','<%=snpTitle%>','<%=snpLink%>','','<%=snpImg%>');
	}else if(snsnum=="ka"){
        <% if isapp = "1" then %>
			fnAPPshareKakao('etc','<%=kakaotitle%>\n<%=kakaodescription%>','<%=kakaolink_url%>','<%=kakaolink_url%>','<%="url="&kakaolink_url%>','<%=kakaoimage%>','','','','');
        <% else %>
			event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaolink_url%>' );	
        <% end if %>
	}else if(snsnum=="urlcopy"){
        var clipboard = new Clipboard('.urlcopyclip');
        clipboard.on('success', function(e) {
            alert('링크 복사가 완료되었습니다.');
            console.log(e);
        });
        clipboard.on('error', function(e) {
            console.log(e);
        });
    }
}

//카카오 SNS 공유 v2.0
function event_sendkakao(label , description , imageurl , linkurl){	
    Kakao.init('c967f6e67b0492478080bcf386390fdd');
	Kakao.Link.sendDefault({
		objectType: 'feed',
		content: {
			title: label,
			description : description,
			imageUrl: imageurl,
			link: {
			mobileWebUrl: linkurl
			}
		},
		buttons: [
			{
			title: '웹으로 보기',
			link: {
				mobileWebUrl: linkurl
			}
			}
		]
	});
}
</script>
<style type="text/css">
.mEvt102078 button {width:100%; background:transparent;}
.mEvt102078 input[type=text],
.mEvt102078 input[type=number],
.mEvt102078 select {display:block; padding:0 .8rem; height:4.5vh; font-size:4.2vw;  font-family:'CoreSansCMedium','NotoSansKRMedium'; letter-spacing:-0.02rem; border:0; background-color:transparent; border-radius:0; color:#000;}
.mEvt102078 .lyr-inner {position:relative; top:50%; transform:translateY(-60%);}
.topic {position:relative;}	
.topic h2 img {position:absolute; left:0; width:100%; top:21.12%;}
.topic h2 img:nth-child(2) {top:29%;}
.topic h2 img:nth-child(3) {top:45.57%;}
.mock-test {position:relative; padding-bottom:5.12rem; background:#ffdb73 url(//webimage.10x10.co.kr/fixevent/event/2020/102078/m/bg_base.png?v=2) repeat-x 0 0 / 3.6% auto;}
.test-inner {position:relative; width:88%; margin:0 auto; background:url(//webimage.10x10.co.kr/fixevent/event/2020/102078/m/bg_paper.png?v=2) repeat 0 0 / 100% auto; box-shadow:0 1.32rem 2.176rem rgba(144,79,47,.2);}
.test-inner .num {position:absolute; right:-2%; top:0; width:46.21%;}
.deco div {position:absolute; z-index:10;}
.deco .d1 {right:0; top:14%; width:18.4%;}
.deco .d2 {right:0; top:39%; width:16.53%;}
.deco .d3 {left:0; top:57%; width:11.33%;}
.deco .d4 {left:0; top:87%; width:11.2%;}
.deco .d5 {right:0; top:85%; width:12.4%;}
.deco .d6 {width:12.93%;}
.step1 {width:85.8%; margin:0 auto;}
.step1 .name {position:relative;}
.step1 .name input {position:absolute; left:35%; top:30%; width:61%; height:45%; padding:0; color:#000;}
.step1 li {position:relative; padding-bottom:5vh;}
.step1 li:after {content:''; position:absolute; left:-6%; top:-28%; width:37.77%; height:100%; background:url(//webimage.10x10.co.kr/fixevent/event/2020/102078/m/ico_o.png) no-repeat 0 0 / 100% auto;}
.step1 li.wrong:after {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/102078/m/ico_x.png);}
.step1 li.q0:after,
.step1 li.q11:after {display:none;}
.step1 li > img {display:inline-block; margin-bottom:1vh;}
.step1 li input[type=text],
.step1 li input[type=number]  {width:65%; color:#000; border-bottom:1px solid #767676;}
.step1 input[type=radio] {position:relative; border-color:#a5a4a0; background-image:none; background:#fff; border-radius:50%;}
.step1 input[type=radio]:checked {border:0; background:#e04a4a;}
.step1 input[type=radio]:checked:after {content:''; position:absolute; left:50%; top:50%; width:44%; height:44%; margin:-22% 0 0 -22%; background:#fff; border-radius:50%;}
.step1 li .flex {display:flex; margin-top:1vh;}
.step1 li .flex label {width:25%;}
.step1 li .flex label img {width:46%; margin-left:.5rem; vertical-align:middle;}
.step1 li .flex input:nth-child(2) {margin:0 1.1rem;}
.step1 li.q1 input[type=text] {padding-right:12%; background:url(//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q1_1.png) no-repeat 95% 50% / auto 50%; }
.step1 li.q2 img {width:34%; margin-bottom:0; vertical-align:middle;}
.step1 li.q2 select {display:inline-block; width:29.8%; border-bottom:1px solid #767676; background:transparent url(//webimage.10x10.co.kr/fixevent/event/2019/94152/m/ico_arr.png) 95% 50% no-repeat; background-size:0.64rem;}
.step1 li.q3 .flex {padding:0 .8rem;}
.step1 li.q5 input[type=text] {padding-right:12%; background:url(//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q5_1.png) no-repeat 95% 50% / auto 50%; }
.step1 li.q11 {position:relative; padding-bottom:0;}
.step1 li.q11 a {position:absolute; left:10%; bottom:10%; width:80%; height:15.5%; font-size:0; color:transparent;}
.step1 li.q11 .answer {position:absolute; left:0; top:45.5%; width:100%; height:21%;}
.step1 li.q11 .answer input[type=radio] {position:absolute; border:0; width:8%; height:24%; background:transparent;}
.step1 li.q11 .answer input[type=radio]:checked { background:url(//webimage.10x10.co.kr/fixevent/event/2020/102078/m/ico_check.png) no-repeat 0 0 / 100% auto; opacity:1 !important;}
.step1 li.q11 .answer input[type=radio]:checked:after {display:none;}
.step1 li.q11 .answer input:nth-child(1) {left:2%; top:-5%;}
.step1 li.q11 .answer input:nth-child(2) {left:62%; top:-5%;}
.step1 li.q11 .answer input:nth-child(3) {left:2%; top:64%;}
.step1 li.q11 .answer input:nth-child(4) {left:62%; top:64%;}
.step2 {padding-bottom:3.2rem; border-top:1px solid #ffca52; background:#ffefcb;}
.step2 h3 {width:114%; margin-left:-7%;}
.step2 button {display:block; width:86.36%; margin:0 auto .9rem;}
.lyr-love {position:fixed; left:0; top:0; z-index:30; width:100vw; height:100vh; background:rgba(0,0,0,.6);}
.lyr-love .btn-close {position:absolute; right:8.5%; top:12.5%; width:13%; height:12%; font-size:0; color:transparent;}
@media all and (min-width:480px){
	.mEvt102078 .lyr-inner {transform:translateY(-50%);}
}
</style>
<script>
 $(function(){
	// 부모님과 식사 팝업
	$(".lyr-love .btn-close").click(function(){
		$(".lyr-love").hide();
	});
});
</script>
</head>
<body class="default-font body-sub bg-grey">
	<!-- contents -->
	<div id="content" class="content">
			<%' mEvt102078 부모님 모의고사 %>
			<div class="mEvt102078">
				<div class="topic">
					<h2>
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/tit1.png" alt="제 2회 부모님 모의고사">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/tit2.png" alt="">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/tit3.png" alt="">
					</h2>
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_copy.png" alt="내가 좋아하는 음식까지 알고 계시는 부모님. 나는 부모님에 대해 얼마나 알고 있나요? 문제를 풀고 부모님께 채점을 받아보세요!"></p>
				</div>
				<div class="mock-test">
					<div class="deco">
						<div class="d1"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/bg_deco1.png" alt=""></div>
						<div class="d2"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/bg_deco2.png" alt=""></div>
						<div class="d3"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/bg_deco3.png" alt=""></div>
						<div class="d5"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/bg_deco5.png" alt=""></div>
					</div>
					<div class="test-inner">
						<!-- 점수 -->
						<div class="num">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_score_<%=parentGradeScore%>.png" alt="">
						</div>
						<!-- STEP1. 정답확인 -->
						<div class="step step1">
							<div class="quiz">
								<div class="name">
									<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_name.png" alt="작성자">
									<input type="text" value="<%=userNm%>" readonly>
								</div>
								<h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/tit_step1.png" alt="부모님에 대해 얼마큼 알고 있나요?"></h3>
								<ol>
									<li class="q0">
										<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q0.png" alt="부모님 성함">
										<input type="text" value="<%=parentNm%>" readonly>
									</li>
									<li class="q1 <% If Trim(c1Result)="O" Then %>correct<% End If %><% If Trim(c1Result)="X" Then %>wrong<% End If %>">
										<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q1.png" alt="연세">
										<input type="number" value="<%=parentAge%>" readonly>
									</li>
									<li class="q2 <% If Trim(c2Result)="O" Then %>correct<% End If %><% If Trim(c2Result)="X" Then %>wrong<% End If %>">
										<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q2.png" alt="생년월일">
										<select disabled>
											<option selected><%=sltvalue%></option>
										</select>
										<div class="flex">
											<input type="number" value="<%=sltyear%>" readonly>
											<input type="number" value="<%=sltmonth%>" readonly>
											<input type="number" value="<%=sltday%>" readonly>
										</div>
									</li>
									<li class="q3 <% If Trim(c3Result)="O" Then %>correct<% End If %><% If Trim(c3Result)="X" Then %>wrong<% End If %>">
										<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q3.png" alt="혈액형">
										<div class="flex">
											<label for="typeA"><input type="radio" name="blood" id="typeA" disabled<% If Trim(blood)="A" Then %> checked<% End If %>><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q3_1.png" alt="A형"></label>
											<label for="typeB"><input type="radio" name="blood" id="typeB" disabled<% If Trim(blood)="B" Then %> checked<% End If %>><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q3_2.png" alt="B형"></label>
											<label for="typeO"><input type="radio" name="blood" id="typeO" disabled<% If Trim(blood)="O" Then %> checked<% End If %>><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q3_3.png" alt="O형"></label>
											<label for="typeAB"><input type="radio" name="blood" id="typeAB" disabled<% If Trim(blood)="AB" Then %> checked<% End If %>><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q3_4.png" alt="AB형"></label>
										</div>
									</li>
									<li class="q4 <% If Trim(c4Result)="O" Then %>correct<% End If %><% If Trim(c4Result)="X" Then %>wrong<% End If %>">
										<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q4.png" alt="옷 사이즈">
										<input type="text" value="<%=clothsize%>" readonly>
									</li>
									<li class="q5 <% If Trim(c5Result)="O" Then %>correct<% End If %><% If Trim(c5Result)="X" Then %>wrong<% End If %>">
										<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q5.png" alt="발 사이즈">
										<input type="number" value="<%=footsize%>" readonly>
									</li>
									<li class="q6 <% If Trim(c6Result)="O" Then %>correct<% End If %><% If Trim(c6Result)="X" Then %>wrong<% End If %>">
										<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q6.png" alt="가장 좋아하는 음식">
										<input type="text" value="<%=fafood%>" readonly>
									</li>
									<li class="q7 <% If Trim(c7Result)="O" Then %>correct<% End If %><% If Trim(c7Result)="X" Then %>wrong<% End If %>">
										<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q7.png" alt="요새 즐겨보시는 드라마">
										<input type="text" value="<%=fadrama%>" readonly>
									</li>
									<li class="q8 <% If Trim(c8Result)="O" Then %>correct<% End If %><% If Trim(c8Result)="X" Then %>wrong<% End If %>">
										<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q8.png" alt="좋아하시는 색상">
										<input type="text" value="<%=facolor%>" readonly>
									</li>
									<li class="q9 <% If Trim(c9Result)="O" Then %>correct<% End If %><% If Trim(c9Result)="X" Then %>wrong<% End If %>">
										<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q9.png" alt="즐겨하시는 취미">
										<input type="text" value="<%=fahobby%>" readonly>
									</li>
									<li class="q10 <% If Trim(c10Result)="O" Then %>correct<% End If %><% If Trim(c10Result)="X" Then %>wrong<% End If %>">
										<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q10.png" alt="좋아하시는 연예인">
										<input type="text" value="<%=faentertainer%>" readonly>
									</li>
									<li class="q11">
										<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q11.png?v=2" alt="부모님께서 선택해주신 어버이날 받고싶은 선물이에요!">
										<div class="answer">
											<input type="radio" id="c11_1" disabled<% If Trim(c11Result)="1" Then %> checked<% End If %>>
											<input type="radio" id="c11_2" disabled<% If Trim(c11Result)="2" Then %> checked<% End If %>>
											<input type="radio" id="c11_3" disabled<% If Trim(c11Result)="3" Then %> checked<% End If %>>
											<input type="radio" id="c11_4" disabled<% If Trim(c11Result)="4" Then %> checked<% End If %>>
										</div>
										<a href="/event/family2020/" class="mWeb" target="_blank">부모님 선물 구경하기</a>
										<a href="" class="mApp" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/family2020/');" target="_blank">s부모님 선물 구경하기</a>
									</li>
								</ol>
							</div>
						</div>					

						<div class="step step2">
							<h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/tit_share.png" alt="친구들에게도 부모님 모의고사를 공유해보세요!"></h3>
							<button onclick="snschk('ka');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/btn_share_kakao.png" alt="카카오톡으로 공유"></button>
							<button onclick="snschk('fb');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/btn_share_fb.png" alt="페이스북으로 공유"></button>
							<button onclick="snschk('urlcopy');return false;" class="urlcopyclip" data-clipboard-text="https://m.10x10.co.kr/event/eventmain.asp?eventid=<%=eCode%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/btn_share_url.png" alt="링크 복사해서 공유"></button>
						</div>
					</div>

					<!-- 완료 레이어 -->
					<div class="lyr-love">
						<div class="lyr-inner">
							<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_love.png?v=2" alt="부모님 모의고사를 통해 사랑하는 부모님을 더 알아가는 기회가 되셨으면 좋겠습니다."></p>
							<button class="btn-close">닫기</button>
						</div>
					</div>
				</div>
				<div class="evt-banner">
					<a href="" class="mApp" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/family2020/');" target="_blank"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/bnr1.jpg" alt="5월의 크리스마스를 준비하세요"></a>
					<a href="" class="mApp" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=102084');" target="_blank"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/bnr2.jpg" alt="진짜 꽃을 보내준다구요? 그럼요, 도전해보세요!"></a>
				</div>
			</div>
			<!-- //mEvt102078 부모님 모의고사 -->
		</div>
	</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->