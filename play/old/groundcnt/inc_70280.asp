<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : PLAY 30 M/A
' History : 2016-04-15 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
Dim eCode , userid , strSql , totcnt , pagereload
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66108
Else
	eCode   =  70280
End If

	pagereload	= requestCheckVar(request("pagereload"),2)
	userid = GetEncLoginUserID()

Dim prize1 : prize1 = 0
Dim prize2 : prize2 = 0 
Dim prize3 : prize3 = 0 
Dim prize4 : prize4 = 0 
Dim prize5 : prize5 = 0 
Dim prize6 : prize6 = 0

'// 응모 여부
strSql = " select "
strSql = strSql & "	isnull(sum(case when sub_opt1 = 1 then 1 else 0 end),0) as prize1 , "
strSql = strSql & "	isnull(sum(case when sub_opt1 = 2 then 1 else 0 end),0) as prize2 , "
strSql = strSql & "	isnull(sum(case when sub_opt1 = 3 then 1 else 0 end),0) as prize3 , "
strSql = strSql & "	isnull(sum(case when sub_opt1 = 4 then 1 else 0 end),0) as prize4 , "
strSql = strSql & "	isnull(sum(case when sub_opt1 = 5 then 1 else 0 end),0) as prize5 , "
strSql = strSql & "	isnull(sum(case when sub_opt1 = 6 then 1 else 0 end),0) as prize6  "
strSql = strSql & "	from db_event.dbo.tbl_event_subscript "
strSql = strSql & "	where evt_code = '"& eCode &"' "
rsget.Open strSql,dbget,1
IF Not rsget.Eof Then
	prize1	= rsget("prize1")
	prize2	= rsget("prize2")
	prize3	= rsget("prize3")
	prize4	= rsget("prize4")
	prize5	= rsget("prize5")
	prize6	= rsget("prize6")
End IF
rsget.close()

If IsUserLoginOK Then 
	'// 이벤트 진행 여부
	strSql = "select "
	strSql = strSql & " count(*) "
	strSql = strSql & " from db_event.dbo.tbl_event_subscript"
	strSql = strSql & "	where userid = '"& userid &"' and evt_code = '"& eCode &"' " 
	rsget.Open strSql,dbget,1
	IF Not rsget.Eof Then
		totcnt = rsget(0)
	End IF
	rsget.close()
End If

%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

img {vertical-align:top;}
.mPlay20160418 {-webkit-text-size-adjust:none;}
.intro {position:relative; background:#2e396f url(http://webimage.10x10.co.kr/playmo/ground/20160418/bg_title.png) no-repeat 0 0; background-size:100% auto;}
.intro .copy {padding:9.9rem 0 3rem; width:64.8%; margin:0 auto;}
.intro .copy img {display:block; -webkit-transform: rotateY(-360deg); transform: rotateY(-360deg);}
.intro .copy.flipped img {-webkit-transform: rotateY(0deg); transform: rotateY(0deg); -webkit-transition: -webkit-transform 1.5s; transition: transform 1.5s;}
.intro .title {overflow:hidden; width:65.15%; margin:0 auto;}
.intro h2 {position:relative;}
.intro h2 span {position:relative; display:block; padding-bottom:1rem;}
.intro .purpose {padding:4.1rem 0 7.7rem;}
.myClock {padding-bottom:5rem; background-color:#37437e;}
.myClock ul {overflow:hidden; padding:0 4.375% 2.2rem;}
.myClock li {float:left; width:33.33333%; padding:0 1.7% 1.8rem; text-align:center; font-weight:bold;}
.myClock li .selectItem {cursor:pointer;}
.myClock li .selectItem span {display:block; overflow:hidden; width:100%; border-radius:50%;}
.myClock li .selectItem span img {width:200.6%;}
.myClock li .selectItem p {padding-top:1rem; font-size:1.2rem; color:#c7f2ff;}
.myClock li .selectItem.current span img {margin-left:-100%;}
.myClock li .count span {display:inline-block; padding-left:1.2rem; margin-top:0.5rem; color:#fff; font:bold 1.1rem/1 arial; background:url(http://webimage.10x10.co.kr/playmo/ground/20160418/ico_heart.png) no-repeat 0 48%; background-size:0.8rem 0.7rem;}
.myClock button {display:block; width:51.72%; margin:0 auto; background-color:transparent; vertical-align:top;}
.worryList li {position:relative; font-size:1.3rem; text-align:center;}
.worryList .story01 {color:#6f5a2e; background-color:#f5c665;}
.worryList .story02 {color:#6f5a2e; background-color:#f5d947;}
.worryList .story03 {color:#5c6925; background-color:#cbe651;}
.worryList .story04 {color:#33516e; background-color:#70b2f1;}
.worryList .story05 {color:#60486b; background-color:#d49feb;}
.worryList .story06 {color:#744f4c; background-color:#feada8;}
.worryList .arrow {display:block; position:absolute; left:50%; bottom:-1.75rem; z-index:30; width:3.5rem; height:1.75rem; margin-left:-1.75rem; border-radius:0 0 1.75rem 1.75rem;background:url(http://webimage.10x10.co.kr/playmo/ground/20160418/blt_arrow.png) no-repeat 50% 40%; background-size:1.3rem auto;}
.worryList .story01 .arrow {background-color:#f5c665;}
.worryList .story02 .arrow {background-color:#f5d947;}
.worryList .story03 .arrow {background-color:#cbe651;}
.worryList .story04 .arrow {background-color:#70b2f1;}
.worryList .story05 .arrow {background-color:#d49feb;}
.worryList .story06 .arrow {background-color:#feada8;}
.worryList .worry {overflow:hidden; padding:2.8rem 0 2.4rem; cursor:pointer; }
.worryList .solution {display:none;}
.worryList .solution .txt {padding:3.4rem 0 3.2rem; line-height:1.4; background-position:0 0; background-repeat:no-repeat; background-size:100 100%;}
.worryList .story01 .solution .txt {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160418/bg_solution_01.png);}
.worryList .story02 .solution .txt {background-color:#f5d947;}
.worryList .story03 .solution .txt {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160418/bg_solution_03.png);}
.worryList .story04 .solution .txt {background-color:#79c0fa;}
.worryList .story05 .solution .txt {background-color:#d49feb;}
.worryList .story06 .solution .txt {background-color:#feafa9;}
</style>
<script type="text/javascript">
$(function(){
	<% if pagereload<>"" then %>
		setTimeout("pagedown()",500);
	<% end if %>
});

function pagedown(){
	window.$('html,body').animate({scrollTop:$("#vote").offset().top}, 0);
}

$(function(){
	$(".worryList li .worry").click(function(event){
		$(this).hide();
		$(this).next(".solution").slideDown();
		$(this).parents("li").find(".arrow").hide();
		var position = $(this).closest("li");
		window.parent.$('html,body').animate({scrollTop:$(position).offset().top}, 300);
	});

	$(".myClock li .selectItem").click(function() {
		$(".myClock li .selectItem").removeClass("current");
		$(this).addClass("current");
		var j = $(".myClock li .selectItem").index(this) + 1;
		$("#sub_opt1").val(j);
	});

	titleAnimation()
	$(".title h2").css({"top":"7%","opacity":"0"});
	function titleAnimation() {
		$(".title h2").delay(800).animate({"top":"0", "opacity":"1"},600);
		$(".title .blank .left,.title .blank .right").delay(1400).animate({"height":"100%"},900);
		$(".title .blank .top,.title .blank .bottom").delay(1400).animate({"width":"100%"},900);
		$(".title .t03").delay(2200).animate({"margin-left":"0", "opacity":"1"},800);
		$(".intro .copy").addClass("flipped");
	}

	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
			$(".ma").show();
			$(".mw").hide();
	}else{
			$(".ma").hide();
			$(".mw").show();
	}
});

function vote_play(){
	var frm = document.frm;
	<% if Not(IsUserLoginOK) then %>
		<% if isApp then %>
			calllogin();
			return false;
		<% else %>
			jsevtlogin();
			return false;
		<% end if %>
	<% end if %>

	<% If not(left(now(),10)>="2016-04-18" and left(now(),10)<"2016-04-25" ) Then %>
		alert("이벤트 응모 기간이 아닙니다.");
		return;
	<% else %>
		<% if totcnt>4 then %>
			alert("한 개의 아이디당 한 번만 응모가 가능 합니다.");
			return;
		<% else %>
			if(!frm.sub_opt1.value){
				alert("시계를 선택 해주세요");
				return false;
			}

			frm.action = "/play/groundcnt/doEventSubscript70280.asp";
			frm.target="frmproc";
			frm.submit();
			return;
		<% end if %>
	<% end if %>
}
</script>
<div class="mPlay20160418">
	<article>
		<div class="intro">
			<p class="copy"><img src="http://webimage.10x10.co.kr/playmo/ground/20160418/txt_answer.png" alt="시계는 답을 알고 있다!"></p>
			<div class="title">
				<h2>
					<span class="t01"><img src="http://webimage.10x10.co.kr/playmo/ground/20160418/tit_clock.png" alt="시계에게"></span>
					<span class="t02"><img src="http://webimage.10x10.co.kr/playmo/ground/20160418/tit_question.png" alt="물으시게"></span>
				</h2>
			</div>
			<p class="purpose"><img src="http://webimage.10x10.co.kr/playmo/ground/20160418/txt_purpose.png" alt="매일 우리는 일상 속에서 시계와 함께 합니다. 우리가 항상 만나던 시계가 일상의 이야기에 답해준다면 어떨까요? 시계의 기능과 모양에 따라 일상을 이야기하는‘시계에게 물으시계’ 를 통해 하루를 새로운 시각으로 바라보세요!"></p>
		</div>
		<ul class="worryList">
			<li class="story01">
				<p class="worry">물렁한 나의 마음, 더 <strong>단단해지고 싶어.</strong></p>
				<div class="solution">
					<p class="txt">물렁물렁 우유부단한 성격이<br /><strong>가끔은 나도 잘 모르겠어.</strong></p>
					<p>
						<a href="/category/category_itemPrd.asp?itemid=1050471" class="mw"><img src="http://webimage.10x10.co.kr/playmo/ground/20160418/img_solution_01.gif" alt="단단해지시계"></a>
						<a href="/category/category_itemPrd.asp?itemid=1050471" onclick="fnAPPpopupProduct('1050471');return false;" class="ma"><img src="http://webimage.10x10.co.kr/playmo/ground/20160418/img_solution_01.gif" alt="단단해지시계"></a>
					</p>
				</div>
				<span class="arrow"></span>
			</li>
			<li class="story02">
				<p class="worry">책상이든 뭐든 <strong>뒤집어 엎고 싶다!</strong></p>
				<div class="solution">
					<p class="txt">밀린 기획서, 쌓인 업무량에<br /><strong>책상이든 뭐든 뒤집에 엎고 싶다!</strong></p>
					<p>
						<a href="/category/category_itemPrd.asp?itemid=1272175" class="mw"><img src="http://webimage.10x10.co.kr/playmo/ground/20160418/img_solution_02.gif" alt="잠시만 쉬시계"></a>
						<a href="/category/category_itemPrd.asp?itemid=1272175" onclick="fnAPPpopupProduct('1272175');return false;" class="ma"><img src="http://webimage.10x10.co.kr/playmo/ground/20160418/img_solution_02.gif" alt="잠시만 쉬시계"></a>
					</p>
				</div>
				<span class="arrow"></span>
			</li>
			<li class="story03">
				<p class="worry">행복한 이 순간, 이대로 <strong>멈췄으면...</strong></p>
				<div class="solution">
					<p class="txt">너와 함께 하는 행복한 이 순간,<br /><strong>시간이 가는게 아까워.</strong></p>
					<p>
						<a href="/category/category_itemPrd.asp?itemid=1441711" class="mw"><img src="http://webimage.10x10.co.kr/playmo/ground/20160418/img_solution_03.gif" alt="타임! 멈추시계"></a>
						<a href="/category/category_itemPrd.asp?itemid=1441711" onclick="fnAPPpopupProduct('1441711');return false;" class="ma"><img src="http://webimage.10x10.co.kr/playmo/ground/20160418/img_solution_03.gif" alt="타임! 멈추시계"></a>
					</p>
				</div>
				<span class="arrow"></span>
			</li>
			<li class="story04">
				<p class="worry">오늘도 한 단계 더 <strong>성장하고 싶어!</strong></p>
				<div class="solution">
					<p class="txt">모두 잘 하고 싶다!<br /><strong>더 멋진 내가 되고 싶어!</strong></p>
					<p>
						<a href="/category/category_itemPrd.asp?itemid=1019450" class="mw"><img src="http://webimage.10x10.co.kr/playmo/ground/20160418/img_solution_04.gif" alt="날아오르시계"></a>
						<a href="/category/category_itemPrd.asp?itemid=1019450" onclick="fnAPPpopupProduct('1019450');return false;" class="ma"><img src="http://webimage.10x10.co.kr/playmo/ground/20160418/img_solution_04.gif" alt="날아오르시계"></a>
					</p>
				</div>
				<span class="arrow"></span>
			</li>
			<li class="story05">
				<p class="worry">열번째 고백, 이제 그만 <strong>넘어와주길...</strong></p>
				<div class="solution">
					<p class="txt">마음을 아는지 모르는지<br /><strong>자꾸만 밀고 당기는 야속한 그 사람</strong></p>
					<p>
						<a href="/category/category_itemPrd.asp?itemid=255243" class="mw"><img src="http://webimage.10x10.co.kr/playmo/ground/20160418/img_solution_05.gif" alt="이쯤되면 넘어오시계"></a>
						<a href="/category/category_itemPrd.asp?itemid=255243" onclick="fnAPPpopupProduct('255243');return false;" class="ma"><img src="http://webimage.10x10.co.kr/playmo/ground/20160418/img_solution_05.gif" alt="이쯤되면 넘어오시계"></a>
					</p>
				</div>
				<span class="arrow"></span>
			</li>
			<li class="story06">
				<p class="worry">울고 싶은 하루, 속 시원하게 <strong>울고싶다!</strong></p>
				<div class="solution">
					<p class="txt">되는 일은 없고 답답하기 만한 오늘.<br /><strong>나, 이대로 괜찮은 걸까?</strong></p>
					<p>
						<a href="/category/category_itemPrd.asp?itemid=747525" class="mw"><img src="http://webimage.10x10.co.kr/playmo/ground/20160418/img_solution_06.gif" alt="대신 울어줄테니, 그만 우시계"></a>
						<a href="/category/category_itemPrd.asp?itemid=747525" onclick="fnAPPpopupProduct('747525');return false;" class="ma"><img src="http://webimage.10x10.co.kr/playmo/ground/20160418/img_solution_06.gif" alt="대신 울어줄테니, 그만 우시계"></a>
					</p>
				</div>
				<span class="arrow"></span>
			</li>
		</ul>

		<div class="myClock" id="vote">
			<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20160418/tit_vote_clock.png" alt="나에게 맞는 시계를 투표해주세요!"></h3>
			<ul>
				<li>
					<div class="selectItem">
						<span><img src="http://webimage.10x10.co.kr/playmo/ground/20160418/img_clock_01.jpg" alt=""></span>
						<p>잠시만쉬시계</p>
					</div>
					<p class="count"><span><%=prize1%></span></p>
				</li>
				<li>
					<div class="selectItem">
						<span><img src="http://webimage.10x10.co.kr/playmo/ground/20160418/img_clock_02.jpg" alt=""></span>
						<p>날아오르시계</p>
					</div>
					<p class="count"><span><%=prize2%></span></p>
				</li>
				<li>
					<div class="selectItem">
						<span><img src="http://webimage.10x10.co.kr/playmo/ground/20160418/img_clock_03.jpg" alt=""></span>
						<p>그만우시계</p>
					</div>
					<p class="count"><span><%=prize3%></span></p>
				</li>
				<li>
					<div class="selectItem">
						<span><img src="http://webimage.10x10.co.kr/playmo/ground/20160418/img_clock_04.jpg" alt=""></span>
						<p>단단해지시계</p>
					</div>
					<p class="count"><span><%=prize4%></span></p>
				</li>
				<li>
					<div class="selectItem">
						<span><img src="http://webimage.10x10.co.kr/playmo/ground/20160418/img_clock_05.jpg" alt=""></span>
						<p>넘어오시계</p>
					</div>
					<p class="count"><span><%=prize5%></span></p>
				</li>
				<li>
					<div class="selectItem">
						<span><img src="http://webimage.10x10.co.kr/playmo/ground/20160418/img_clock_06.jpg" alt=""></span>
						<p>타임멈추시계</p>
					</div>
					<p class="count"><span><%=prize6%></span></p>
				</li>
			</ul>
			<button type="button" class="btnVote" onclick="vote_play();"><img src="http://webimage.10x10.co.kr/playmo/ground/20160418/btn_vote.png" alt="투표하기"></button>
		</div>
	</article>
</div>
<form name="frm" method="post">
<input type="hidden" name="mode" value="add"/>
<input type="hidden" name="sub_opt1" id="sub_opt1" value=""/>
<input type="hidden" name="pagereload" value="ON"/>
</form>
<iframe id="frmproc" name="frmproc" frameborder="0" width=0 height=0></iframe>
<!-- #include virtual="/lib/db/dbclose.asp" -->