<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/instagrameventCls.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : 플레이띵 Vol.16 슬기로운 생활
' History : 2017-06-02 원승현
'####################################################
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66334
Else
	eCode   =  78257
End If

dim userid, commentcount, i, vDIdx, vQuery
	userid = GetEncLoginUserID()

commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")
vDIdx = request("didx")

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop, pagereload
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)
	pagereload	= requestCheckVar(request("pagereload"),2)

IF blnFull = "" THEN blnFull = True
IF blnBlogURL = "" THEN blnBlogURL = False

IF iCCurrpage = "" THEN
	iCCurrpage = 1
END IF
IF iCTotCnt = "" THEN
	iCTotCnt = -1
END IF

iCPerCnt = 10		'보여지는 페이지 간격
'한 페이지의 보여지는 열의 수
if blnFull then
	iCPageSize = 5		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 5		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
end if

'데이터 가져오기
set cEComment = new ClsEvtComment
	cEComment.FECode 		= eCode
	cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	if isMyComm="Y" then cEComment.FUserID = userid
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수
	
	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
set cEComment = nothing

iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1

Dim q1val, q2val, q3val, q4val, q5val, q6val
Dim qtotalval, qUserTotalScore, qusercomment
Dim testchk, tmpTotalVal, pagingURL, tmpPagingURL

testchk = False
'// 로그인 했을경우 응모데이터가 있으면 가져온다.
If IsUserLoginOK() Then
	vQuery = "SELECT sub_opt1, sub_opt2, sub_opt3 FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' And evt_code='"&eCode&"' "
	rsget.Open vQuery,dbget,1
	If Not(rsget.bof Or rsget.eof) Then
		testchk = True
		qtotalval = rsget("sub_opt1")
		qUserTotalScore = rsget("sub_opt2")
		qusercomment = rsget("sub_opt3")
		tmpTotalVal = Split(qtotalval,"|")
		q1val = tmpTotalVal(0)
		q2val = tmpTotalVal(1)
		q3val = tmpTotalVal(2)
		q4val = tmpTotalVal(3)
		q5val = tmpTotalVal(4)
		q6val = qusercomment
	End If
	rsget.close
End If

pagingURL = Request.ServerVariables("PATH_INFO") &"?"& Request.ServerVariables("QUERY_STRING")

If InStr(pagingURL, "#")>0 Then
	tmpPagingURL = Split(pagingURL, "#")
	pagingURL = tmpPagingURL(0)
End If

%>

<style type="text/css">
.intro {background:#f9e4d3;}
.intro .btnGoTest .after {display:none;}
.viewResult .intro .btnGoTest .before {display:none;}
.viewResult .intro .btnGoTest .after {display:block;}
.test .info {position:relative;}
.test .info .inner {position:absolute; left:43%; top:45%;}
.test .info .inner > div:after {content:' '; display:block; clear:both;}
.test .info .inner p {float:left; padding-right:0.8rem; font-size:1.1rem; line-height:1.6; color:#000;}
.test .info .inner p  span {color:#666;}
.test .info .inner p.score {position:relative;}
.test .info .inner p.score span {position:absolute; left:0.5rem; top:-1rem; z-index:40; width:8.7rem;}

.test .question {position:relative; padding-bottom:2.5rem;}
.test .question .inner {position:relative;}
.test .question .answer {position:absolute; left:5%; top:40%; width:90%; height:52%;}
.test .question .answer li {position:relative; float:left; width:50%; height:100%; color:transparent; font-size:0; line-height:0;}
.test .question .answer li i {display:none; position:absolute; left:50%; bottom:0.5rem; z-index:40; width:2.1rem; height:1.85rem; margin-left:-3.3rem; background:url(http://webimage.10x10.co.kr/playing/thing/vol016/m/ico_check.png) 0 0 no-repeat; background-size:100%;}
.test .question .answer li.current i {display:block; animation:bounce1 .4s;}
.test .question .desc {display:none;}
.test .question .txt em {display:none; position:absolute; left:11%; top:17%; width:6.6rem; height:5rem;}
.test .question2 .txt em {left:4%; top:15%;}
.test .question3 .txt em {top:22%;}
.test .question4 .txt em {left:8%; top:14%;}
.test .question5 .txt em {top:23%;}
.test .question6 .txt {margin:0;}
.test .question6 .txt em {left:11%;}
.test .question.correct .txt em {display:block; background:url(http://webimage.10x10.co.kr/playing/thing/vol016/m/img_correct.png) 0 0 no-repeat; background-size:100%;}
.test .question.wrong .txt em {display:block; background:url(http://webimage.10x10.co.kr/playing/thing/vol016/m/img_wrong.png) 0 0 no-repeat; background-size:100%;}

.test .question2 {background-color:#f8f8f8;}
.test .question2 .answer {top:29%; height:35.5%;}
.test .question2 .answer li i {bottom:2rem; margin-left:-2.2rem;}
.test .question3 .answer {top:92%; height:8%;}
.test .question3 .answer li {width:25%;}
.test .question3 .answer li i {margin-left:-1.7rem;}
.test .question3 .answer li:nth-child(1) i,
.test .question3 .answer li:nth-child(2) i {margin-left:-2.3rem;}
.test .question4 {background-color:#f8f8f8;}
.test .question4 .answer {top:24%; height:38%;}
.test .question4 .answer li i {bottom:2rem; margin-left:-2.4rem;}
.test .question4 .answer li:nth-child(3) i {margin-left:-3rem;}
.test .question5 .answer {top:55%; height:45%;}
.test .question5 .answer li {width:33.33333%;}
.test .question5 .answer li i {margin-left:-2rem;}
.test .question6 {padding-bottom:4rem; background-color:#f8f8f8;}
.test .question6 .writeCont {position:relative; color:#000; font-size:2.2rem; line-height:3.1rem; text-align:center;}
.test .question6 .writeCont:after {content:''; display:inline-block; position:absolute; left:12.5%; top:17%; z-index:20; width:0.1rem; height:60%; background:url(http://webimage.10x10.co.kr/playing/thing/vol016/img_cursor.gif) 0 0 no-repeat; background-size:100% 100%;}
.test .question6 .focusOn.writeCont:after {display:none;}
.test .question6 .writeCont input {width:80%; height:3rem; color:#000; font-weight:bold; font-size:1.4rem; line-height:2.8rem; border:0; background:transparent; vertical-align:top;}
.test .question6 .good {display:none; margin-top:-3rem; padding-bottom:2rem;}
.test .question6 .btnSubmit {animation:bounce2 1s 100;}
.test .question6 .goEvt {display:none;}
.test .question6.correct .txt em {left:16%; top:12%; height:5.4rem; background:url(http://webimage.10x10.co.kr/playing/thing/vol016/m/img_correct2.png) 0 0 no-repeat; background-size:100%;}

.viewResult .test .question1 .answer li.q1a1 i,
.viewResult .test .question2 .answer li.q2a4 i,
.viewResult .test .question3 .answer li.q3a4 i,
.viewResult .test .question4 .answer li.q4a4 i,
.viewResult .test .question5 .answer li.q5a3 i {display:block; background-image:url(http://webimage.10x10.co.kr/playing/thing/vol016/ico_check2.png);}
.viewResult .test .question .desc {display:block; padding:1rem 0 1.5rem;}
.viewResult .test .question6 .good {display:block;}
.viewResult .test .question6 .btnSubmit {display:none;}
.viewResult .test .question6 .goEvt {display:block; animation:bounce2 1s 100;}

.loading {display:none; position:fixed; left:0; top:0; z-index:100; width:100%; height:100%; padding-top:55%; background:rgba(0,0,0,.6); text-align:center;}
.loading span {display:inline-block; width:19.68%;}
.loading p {width:19.68%; margin:0 auto;}
.test.loadOn .loading {display:block;}
.test.loadOn .loading span { animation:movePen 1.5s 3;}

.answerList {padding-bottom:3.5rem; background:#8eddda;}
.answerList ul {padding:0 9%;}
.answerList li {margin-bottom:1.2rem; padding:4px; font-size:1rem; font-weight:bold; text-align:left; border:0.15rem solid #19908b; background:#fff; border-radius:1rem;}
.answerList li > div {position:relative; padding:1.4rem; border:0.1rem solid #705fbd; border-radius:0.7rem;}
.answerList li .writer {color:#504098;}
.answerList li .writer i {display:inline-block; width:1rem; height:1.4rem; margin-right:0.5rem; background:url(http://webimage.10x10.co.kr/playing/thing/vol016/m/ico_mobile.png) 0 0 no-repeat; background-size:100%; vertical-align:middle; text-indent:-999em;}
.answerList li p {padding:1rem 0; color:#666; font-size:14px;}
.answerList li .num {color:#19908b;}
.pagingV15a span {color:#3c716f;}
.pagingV15a .current {color:#5b44bc;}
.pagingV15a .arrow a:after {background-position:-5.8rem -9.56rem;}
/*.answerList .pagingV15a span {overflow:hidden; display:inline-block; width:3rem; height:3rem; border:0; border-radius:50%;}
.answerList .pagingV15a span a {padding-top:0; color:#8f8f8f; font-size:1.2rem; line-height:3rem; font-weight:normal;}
.answerList .pagingV15a span.current {background-color:#504098;}
.answerList .pagingV15a span.current a {color:#fff;}
.answerList .pagingV15a span.arrow {margin:0; background-size:100%; background-position:0 0; background-repeat:no-repeat;}
.answerList .pagingV15a span.prevBtn {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol016/m/btn_prev.png);}
.answerList .pagingV15a span.nextBtn {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol016/m/btn_next.png);}*/
@keyframes bounce1 {
	from,to {transform:translateY(0);}
	50% {transform:translateY(5px);}
}
@keyframes bounce2 {
	from, to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(10px); animation-timing-function:ease-in;}
}
@keyframes movePen {
	from,to {transform:translateX(0);}
	50% {transform:translateX(20px);}
}
</style>
<script type="text/javascript">
$(function(){
	<% if pagereload = "ON" then %>
		window.$('html,body').animate({scrollTop:$("#SecAnswerList").offset().top}, 0);
//		setTimeout("pagedown()",100);
	<% end if %>

	$(".btnGoTest").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top},800);
	});

	$(".question li").click(function(){
		$(this).siblings("li").removeClass("current");
		$(this).addClass("current");
	});

	$(".viewResult .question li").click(function(){
		$(this).removeClass("current");
	});

	$(".writeCont input").click(function(){
		$(".writeCont").addClass("focusOn");
	});

	<% if testchk then %>
		$("#q1a"+<%=q1val%>).addClass("current")
		$("#q2a"+<%=q2val%>).addClass("current")
		$("#q3a"+<%=q3val%>).addClass("current")
		$("#q4a"+<%=q4val%>).addClass("current")
		$("#q5a"+<%=q5val%>).addClass("current")
	<% end if %>
});

function gowiseLifeTest()
{
	<% If IsUserLoginOK() Then %>
		$("#q6val").val($("#q6text").val());

		if ($("#q1val").val()=="")
		{
			alert("시험지를 모두 다 풀어야 채점(응모)이 됩니다.");
			return false;
		}
		if ($("#q2val").val()=="")
		{
			alert("시험지를 모두 다 풀어야 채점(응모)이 됩니다.");
			return false;
		}
		if ($("#q3val").val()=="")
		{
			alert("시험지를 모두 다 풀어야 채점(응모)이 됩니다.");
			return false;
		}
		if ($("#q4val").val()=="")
		{
			alert("시험지를 모두 다 풀어야 채점(응모)이 됩니다.");
			return false;
		}
		if ($("#q5val").val()=="")
		{
			alert("시험지를 모두 다 풀어야 채점(응모)이 됩니다.");
			return false;
		}
		if ($("#q6val").val()=="")
		{
			alert("시험지를 모두 다 풀어야 채점(응모)이 됩니다.");
			return false;
		}

		$(".loading").show();
		setTimeout("wiseTestAjax();",1000);

	<% else %>
		<% If isApp Then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
			return false;
		<% end if %>	
	<% end if %>
}

function jsGoComPage(iP){
	document.frmwiseLife.iCC.value = iP;
	document.frmwiseLife.iCTot.value = "<%=iCTotCnt%>";
	document.frmwiseLife.action="<%=pagingURL%>";
	document.frmwiseLife.submit();
}

function wAnswerVal(q, a)
{
	$("#"+q).val(a);
}

function wiseTestAjax()
{
	$.ajax({
		type:"GET",
		url:"/playing/sub/doEventSubscript78257.asp",
		data: $("#frmwiseLife").serialize(),
		dataType: "text",
		async:false,
		cache:true,
		success : function(Data, textStatus, jqXHR){
				//$str = $(Data);
				res = Data.split("||");
				if (jqXHR.readyState == 4) {
					if (jqXHR.status == 200) {
						if(Data!="") {
							if (res[0]=="ok")
							{
								document.location.reload();document.location.href=res[1];
							}
							else
							{
								alert(res[1]);
								document.location.reload();
							}
						} else {

						}
					}
				}
		},
		error:function(jqXHR, textStatus, errorThrown){
			alert("잘못된 접근 입니다.");
			//var str;
			//for(var i in jqXHR)
			//{
			//	 if(jqXHR.hasOwnProperty(i))
			//	{
			//		str += jqXHR[i];
			//	}
			//}
			//alert(str);
			//document.location.reload();
			return false;
		}
	});
}
</script>
<%' 채점 후 viewResult 클래스 추가해주세요 %>
<div class="thingVol016 wiseLife <% If testchk Then %>viewResult<% End If %>">
	<div class="section intro">
		<h2><img src="http://webimage.10x10.co.kr/playing/thing/vol016/m/tit_test.png" alt="슬기로운 생활" /></h2>
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol016/m/txt_intro.png" alt="안녕하세요, 여러분 6월5일 오늘은 세계 환경의 날입니다. 평소에 환경을 얼마나 아끼고 슬기로운 생활을 했는지 칭찬해주기 위해 플레잉에서 슬기로운 생활 시험을 준비했습니다. 시험에서 점수가 높은 고객들 중 추첨을 통해 20명에게 슬기로운 생활 노트를 드립니다." /></p>
		<div><img src="http://webimage.10x10.co.kr/playing/thing/vol016/m/img_gift.png" alt="시험 점수가 높은 고객들 중 20분께 슬기로운 생활 노트를 드립니다. 응모기간 : 2017. 6.5 ~ 6.18" /></div>
		<% If isUserLoginOK Then %>
			<a href="#testStart" class="btnGoTest">
		<% Else %>
			<% If isApp Then %>
				<a href="" class="btnGoTest" onclick="calllogin();return false;">
			<% else %>
				<a href="" class="btnGoTest" onclick="jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');return false;">
			<% end if %>
		<% End If %>
			<img src="http://webimage.10x10.co.kr/playing/thing/vol016/m/btn_go_test.png" alt="시험 보기" class="before" />
			<img src="http://webimage.10x10.co.kr/playing/thing/vol016/m/btn_result.png" alt="시험 결과 확인하기" class="after" />
		</a>
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol016/m/txt_tip.png" alt="본 시험은 1회만 볼 수 있습니다." /></p>
	</div>

	<%' 문제 풀기 %>
	<form name="frmwiseLife" id="frmwiseLife" method="post" style="margin:0px;">
		<input type="hidden" name="eventid" value="<%=eCode%>">
		<input type="hidden" name="com_egC" value="<%=com_egCode%>">
		<input type="hidden" name="bidx" value="<%=bidx%>">
		<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
		<input type="hidden" name="iCTot" value="">
		<input type="hidden" name="mode" value="add">
		<input type="hidden" name="spoint">
		<input type="hidden" name="isMC" value="<%=isMyComm%>">
		<input type="hidden" name="pagereload" value="ON">
		<input type="hidden" name="gubunval">
		<input type="hidden" name="q1val" id="q1val">
		<input type="hidden" name="q2val" id="q2val">
		<input type="hidden" name="q3val" id="q3val">
		<input type="hidden" name="q4val" id="q4val">
		<input type="hidden" name="q5val" id="q5val">
		<input type="hidden" name="q6val" id="q6val">
	</form>
	<div id="testStart" class="section test">
		<div class="info">
			<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol016/m/txt_info.png" alt="2017년도 1학기 전교생 슬기로운 생활" /></h3>
			<div class="inner">
				<div>
					<p><span>텐텐</span> 초등학교</p>
					<p><span>플레잉</span> 반</p>
					<p><span>1010</span> 번</p>
				</div>
				<div>
					<p>이름: <span><%=printUserId(userid,2,"*")%></span></p>
					<% If testchk Then %>
						<p class="score">점수:
							<span>
								<img src="http://webimage.10x10.co.kr/playing/thing/vol016/txt_score_<%=qUserTotalScore%>.png" alt="<%=qUserTotalScore%>점" />
							</span>
						</p>
					<% End If %>
				</div>
			</div>
		</div>
		<%' for dev msg: 채점하기 버튼 클릭후 정답:correct 오답:wrong 클래스 붙여주세요 %>
		<%' 1학년 %>
		<div id="question1" class="question question1 <%If testchk Then %><% If q1val="1" Then %>correct<%Else%>wrong<% End If %><% End If %>">
			<div class="inner">
				<p class="txt"><em></em><img src="http://webimage.10x10.co.kr/playing/thing/vol016/m/txt_question1.png" alt="1. 마트에서 장 볼 때, 환경을 위해 어디에 물건을 담아야 할까요?" /></p>
				<ul class="answer">
					<li id="q1a1" class="q1a1" onclick="wAnswerVal('q1val', '1');return false;"><i></i>장바구니</li>
					<li id="q1a2" class="q1a2" onclick="wAnswerVal('q1val', '2');return false;"><i></i>비닐봉투</li>
				</ul>
			</div>
			<p class="desc"><img src="http://webimage.10x10.co.kr/playing/thing/vol016/m/txt_desc_1.png" alt="무심결에 사용하는 비닐이 생활 쓰레기의 17% 이상을 차지하고 있다고 합니다. 비닐 대신 장바구니를 이용하는 것만으로도 환경을 보호 할 수 있어요!" /></p>
		</div>
		<%' 2학년 %>
		<div id="question2" class="question question2 <%If testchk Then %><% If q2val="4" Then %>correct<%Else%>wrong<% End If %><% End If %>">
			<div class="inner">
				<p class="txt"><em></em><img src="http://webimage.10x10.co.kr/playing/thing/vol016/m/txt_question2.png" alt="2. 뜨거운 여름, 실내에서 에어컨을 켜뒀습니다. 환경을 위해 우리가 닫아야 할 것은 무엇일까요?" /></p>
				<ul class="answer">
					<li id="q2a1" class="q2a1" onclick="wAnswerVal('q2val', '1');return false;"><i></i>지퍼</li>
					<li id="q2a2" class="q2a2" onclick="wAnswerVal('q2val', '2');return false;"><i></i>마음</li>
					<li id="q2a3" class="q2a3" onclick="wAnswerVal('q2val', '3');return false;"><i></i>병뚜껑</li>
					<li id="q2a4" class="q2a4" onclick="wAnswerVal('q2val', '4');return false;"><i></i>창문</li>
				</ul>
			</div>
			<p class="desc"><img src="http://webimage.10x10.co.kr/playing/thing/vol016/m/txt_desc_2.png" alt="에어컨을 킬 땐 창문을 닫는 것만으로도 연료를 줄일 수 있고, 전기료도 절약이 되요.작은 습관이 돈도 아끼고 환경도 아낄 수 있어요!" /></p>
		</div>
		<%' 3학년 %>
		<div id="question3" class="question question3 <%If testchk Then %><% If q3val="4" Then %>correct<%Else%>wrong<% End If %><% End If %>">
			<div class="inner">
				<p class="txt"><em></em><img src="http://webimage.10x10.co.kr/playing/thing/vol016/m/txt_question3.png" alt="3. 다음 중 올바른 슬기로운 생활은?" /></p>
				<ul class="answer">
					<li id="q3a1" class="q3a1" onclick="wAnswerVal('q3val', '1');return false;"><i></i>철수:에어컨 빵빵하게 켜놓고 이불 덮는 게 최고야!</li>
					<li id="q3a2" class="q3a2" onclick="wAnswerVal('q3val', '2');return false;"><i></i>영희:라면은 일회용 나무 젓가락으로 먹어야 맛있지. 라면 먹고 갈래?</li>
					<li id="q3a3" class="q3a3" onclick="wAnswerVal('q3val', '3');return false;"><i></i>찬희:더 시켜, 더시켜! 모자란 것보다 남는 게 나아!</li>
					<li id="q3a4" class="q3a4" onclick="wAnswerVal('q3val', '4');return false;"><i></i>기호:분리수거 할 때 씻어서 분리수거 해야 해</li>
				</ul>
			</div>
			<p class="desc"><img src="http://webimage.10x10.co.kr/playing/thing/vol016/m/txt_desc_3.png" alt="여름철 실내온도는 26-28℃ 로 적정온도 유지하는 것만으로도 온실 가스를 줄일 수 있어요. 평소 쓰레기만 10% 줄여도 연간 18kg의 CO₂감축한다고 해요! 우리의 작은 습관이 환경을 보호할 수 있어요!" /></p>
		</div>
		<%' 4학년 %>
		<div id="question4" class="question question4 <%If testchk Then %><% If q4val="4" Then %>correct<%Else%>wrong<% End If %><% End If %>">
			<div class="inner">
				<p class="txt"><em></em><img src="http://webimage.10x10.co.kr/playing/thing/vol016/m/txt_question4.png" alt="4. 외출할 때 뽑아야 할 것은 무엇일까요?" /></p>
				<ul class="answer">
					<li id="q4a1" class="q4a1" onclick="wAnswerVal('q4val', '1');return false;"><i></i>사랑니</li>
					<li id="q4a2" class="q4a2" onclick="wAnswerVal('q4val', '2');return false;"><i></i>반장</li>
					<li id="q4a3" class="q4a3" onclick="wAnswerVal('q4val', '3');return false;"><i></i>제비뽑기</li>
					<li id="q4a4" class="q4a4" onclick="wAnswerVal('q4val', '4');return false;"><i></i>콘센트</li>
				</ul>
			</div>
			<p class="desc"><img src="http://webimage.10x10.co.kr/playing/thing/vol016/m/txt_desc_4.png" alt="쓰지 않는 콘센트를 꼽아 놓을 때, 꽂는 것만으로도 많은 양의 전기가 소모 된다고 해요! 외출 전에 콘센트를 뽑기만 해도 환경을 아낄 수 있어요." /></p>
		</div>
		<%' 5학년 %>
		<div id="question5" class="question question5 <%If testchk Then %><% If q5val="3" Then %>correct<%Else%>wrong<% End If %><% End If %>">
			<div class="inner">
				<p class="txt"><em></em><img src="http://webimage.10x10.co.kr/playing/thing/vol016/m/txt_question5.png" alt="5. 철수, 영희, 민수가 분리수거를 하고 있습니다. 엄마(경비아저씨)에게 꾸중을 들을 사람은 누구일까요?" /></p>
				<ul class="answer">
					<li id="q5a1" class="q5a1" onclick="wAnswerVal('q5val', '1');return false;"><i></i>철수</li>
					<li id="q5a2" class="q5a2" onclick="wAnswerVal('q5val', '2');return false;"><i></i>영희</li>
					<li id="q5a3" class="q5a3" onclick="wAnswerVal('q5val', '3');return false;"><i></i>민수</li>
				</ul>
			</div>
			<p class="desc"><img src="http://webimage.10x10.co.kr/playing/thing/vol016/m/txt_desc_5.png" alt="계란과 양파는 음식물 쓰레기가 안 된다는 것 알고 계셨나요? 계란, 양파, 대파, 마늘, 생선 뼈, 동물 뼈 등은 일반 쓰레기로 버려야 해요!" /></p>
		</div>
		<%' 6학년 %>
		<div id="question6" class="question question6 <% If testchk Then %>correct<% End If %>">
			<p class="txt"><em></em><img src="http://webimage.10x10.co.kr/playing/thing/vol016/m/txt_question6.png" alt="6. 민수가 꽃을 꺾고 있습니다. 민수에게 뭐라고 따끔하게 말해줄까요?" /></p>
			<div class="writeCont">(<input type="text" placeholder="이런 개나리가! 너도 꺾여 볼래?" maxlength="20" id="q6text" value="<%=q6val%>" />)</div>
			<p><img src="http://webimage.10x10.co.kr/playing/thing/vol016/m/txt_tip2.png" alt="20자 이내로 입력해주세요." /></p>
			<p class="good"><img src="http://webimage.10x10.co.kr/playing/thing/vol016/m/txt_good.png" alt="6월 5일 환경의 날입니다. 여러분도 앞으로 환경을 조금 더 아끼고 사랑해주세요!" /></p>
			<button type="button" class="btnSubmit" onclick="gowiseLifeTest();return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol016/m/btn_marking.png" alt="채점하기" /></button>
			<div class="goEvt">
				<a href="/event/eventmain.asp?eventid=78257" class="mWeb btnMore"><img src="http://webimage.10x10.co.kr/playing/thing/vol016/m/btn_go_event.png" alt="보충학습 하러가기" /></a>
				<a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=78257" onclick="fnAPPpopupEvent('78257'); return false;" class="mApp btnMore"><img src="http://webimage.10x10.co.kr/playing/thing/vol016/m/btn_go_event.png" alt="보충학습 하러가기" /></a>
			</div>
		</div>
		<%' 채점중 %>
		<div class="loading">
			<div>
				<span><img src="http://webimage.10x10.co.kr/playing/thing/vol016/m/img_pen.png" alt="" /></span>
				<p><img src="http://webimage.10x10.co.kr/playing/thing/vol016/m/txt_marking.png" alt="채점중..." /></p>
			</div>
		</div>
	</div>

	<%' 답변 리스트 %>
	<% IF isArray(arrCList) THEN %>
		<div class="section answerList" id="SecAnswerList">
			<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol016/m/tit_reply.png" alt="센스있는 6학년 답변" /></h3>
			<ul>
				<%' 리스트 5개씩 노출 %>
				<% For intCLoop = 0 To UBound(arrCList,2) %>
				<li>
					<div>
						<span class="writer"><% If arrCList(8,intCLoop) <> "W" Then %><i>모바일에서 작성</i><% End If %><%=chrbyte(printUserId(arrCList(2,intCLoop),2,"*"),10,"Y")%></span>
						<p><%=arrCList(1,intCLoop)%></p>
						<span class="num">NO.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></span>
					</div>
				</li>
				<% Next %>
			</ul>
			<div class="paging pagingV15a">
				<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
			</div>
		<% End If %>
	</div>
	<!--// 답변 리스트 -->

	<!-- volume -->
	<div class="volume">
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol016/m/txt_vol016.png" alt="vol.016 6월 5일 환경의 날입니다. 여러분도 앞으로 환경을 조금 더 아끼고 사랑해주세요!" /></p>
	</div>
</div>
<!-- //THING. html 코딩 영역 -->

<!-- #include virtual="/lib/db/dbclose.asp" -->