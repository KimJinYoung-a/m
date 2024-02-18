<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/playing/playingCls.asp" -->
<%
'#################################################################
' Description : PLAYing 텐퀴즈
' History : 2018-05-03
'#################################################################
%>

<%
	If isApp="1" Then
		If now() < "2018-05-08" Then
			Response.redirect "/apps/appCom/wish/web2014/playing/sub/vol040Main.asp?isadmin=o&didx=237&state=7&sdate=2018-05-08"
			Response.End
		Else
			Response.redirect "/apps/appCom/wish/web2014/playing/sub/vol040Main.asp?didx=237"
			Response.End
		End If
	End If

	Dim vUserTotal, vRightUser, vChasu, vQuery

	vChasu = Replace(Left(now(), 10), "-", "")

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
%>

<style type="text/css">
.tenquiz-mw {position:relative; padding-bottom:5.12rem; color:#000; font-size:1.2rem; font-weight:600; text-align:center; background:#ffc3dc;}
.tenquiz-mw .navigation {overflow:hidden; position:relative; padding:1.45rem 0 1.37rem}
.tenquiz-mw .navigation li {float:left; width:33.33333%; min-height:3rem; padding-top:0.43rem; font-size:1.1rem; line-height:1.3; color:#72344e; letter-spacing:-0.03rem;}
.tenquiz-mw .go-app {display:none; position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.4);}
.tenquiz-mw .go-app .inner {position:absolute; left:0; top:4%; z-index:99; width:100%;}
.tenquiz-mw .go-app .btn-go {position:absolute; left:20%; bottom:17%; width:60%;}
.tenquiz-mw .go-app .btn-close {position:absolute; right:8.5%; top:3%; z-index:100; width:11.2%; background:transparent;}

.topic {position:relative;}
.count {position:absolute; left:57%; bottom:9%; width:33%;}
.count p {position:absolute; left:0; top:10%; width:100%; height:80%; padding-top:1.7rem; text-align:center; color:#fff; font-size:1.11rem;}
.count p strong {display:block; padding:0.3rem 0 0.4rem; font-size:1.8rem; font-weight:600; letter-spacing:-0.05rem;}
.count p span {font-size:.9rem;}
</style>
<script type="text/javascript">
$(function(){
	// 앱다운 레이어 열기
	$(".btn-challenge").click(function(){
		$(".go-app").show();
		window.parent.$('html,body').animate({scrollTop:$(".go-app").offset().top},500);
	});

	// 레이어 닫기
	$(".go-app .btn-close").click(function(){
		$(".go-app").hide();
	});

});
</script>
<div class="thingVol040 tenquiz-mw">
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
		<div><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/tab_date_0.png" alt="" /></div>
		<ol>
			<li><%'515 / 2,200명<br />상금 획득%></li>
			<li><!--515 / 2,200명<br />상금 획득--></li>
			<li><!--515 / 2,200명<br />상금 획득--></li>
		</ol>
	</div>
	<button class="btn-challenge"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/btn_challenge_2.png" alt="도전하기" /></button>
	<p>완료된 이벤트입니다.<br />다음에 기회가 된다면 다시 도전해주세요!</p>
	<!-- 앱으로 이동 팝업 -->
	<div class="go-app">
		<div class="inner">
			<div><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/txt_go_app.png?v=1" alt="잠깐! 모바일에서만 텐퀴즈를 참여할 수 잇습니다. 텐바이텐 APP에 접속해주세요!" /></div>
			<a href="/apps/link/?11620180508" class="btn-go" target="_blank"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/btn_app.png" alt="APP 바로가기" /></a>
			<button class="btn-close"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/btn_close_2.png" alt="닫기" /></button>
		</div>
	</div>
	<!--// 앱으로 이동 팝업 -->
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->