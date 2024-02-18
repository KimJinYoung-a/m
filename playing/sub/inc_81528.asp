<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#################################################################
' Description : 플레잉 왜 우리는 다이어리를 끝까지 써 본적이 없을까?
' History : 2017.10.26 정태훈
'#################################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim eCode, vUserID, myevt, vDIdx, myselect
dim arrList, sqlStr

IF application("Svr_Info") = "Dev" THEN
	eCode = "67443"
Else
	eCode = "81528"
End If

vDIdx = request("didx")
vUserID = getEncLoginUserID
myselect = 0

'참여했는지 체크
myevt = getevent_subscriptexistscount(eCode, vUserID,"","","")

sqlStr = ""
sqlStr = sqlStr & " select isnull([1],0) as '1',isnull([2],0) as '2',isnull([3],0) as '3',isnull([4],0) as '4'" & vbCrlf
sqlStr = sqlStr & " from  " & vbCrlf
sqlStr = sqlStr & " ( " & vbCrlf
sqlStr = sqlStr & "		SELECT  sub_opt2 as so2, COUNT(*) as cnt " & vbCrlf
sqlStr = sqlStr & "			FROM db_event.[dbo].[tbl_event_subscript]  " & vbCrlf
sqlStr = sqlStr & "				where evt_code = '"& eCode &"' " & vbCrlf
sqlStr = sqlStr & "				group by sub_opt2 " & vbCrlf
sqlStr = sqlStr & " ) as a " & vbCrlf
sqlStr = sqlStr & " pivot " & vbCrlf
sqlStr = sqlStr & " ( " & vbCrlf
sqlStr = sqlStr & "		sum(cnt) for so2 in ([1],[2],[3],[4]) " & vbCrlf
sqlStr = sqlStr & " ) as tp "
rsget.Open sqlStr,dbget,1
If not rsget.EOF Then
	arrList = rsget.getRows()
End If
rsget.close

dim numcols, rowcounter, colcounter, thisfield(3)
if isArray(arrList) then
	numcols=ubound(arrList,1)
		FOR colcounter=0 to numcols
			thisfield(colcounter)=arrList(colcounter,0)
			if isnull(thisfield(colcounter)) or trim(thisfield(colcounter))=""then
				thisfield(colcounter)="0"
			end if
		Next
Else
		thisfield(0)="0"
		thisfield(1)="0"
		thisfield(2)="0"
		thisfield(3)="0"
end if
'response.write thisfield(8)

sqlstr = "select top 1 sub_opt2 " &_
		"  from db_event.dbo.tbl_event_subscript where evt_code = '" & eCode & "' and userid = '" & vUserID & "' "
		'response.write sqlstr
rsget.Open sqlStr,dbget,1
	IF Not rsget.Eof Then
		myselect = rsget(0)
	end if
rsget.Close
%>
<style type="text/css">
.diary .topic {background-color:#ecd7c2;}
.diary .title-wrap {position:relative;}
.diary .title-wrap h2 {position:absolute; top:10.61%; left:0; width:100%;}
.diary .letter {display:block; /*opacity:0;*/}
.diary .letter1 {animation-delay:0.1s; -webkit-animation-delay:0.1s;}
.diary .letter2 {animation-delay:0.7s; -webkit-animation-delay:0.7s;}
.opacity {animation:opacity 2s cubic-bezier(0.1, 1, 0.2, 1) forwards; -webkit-animation:opacity 2s cubic-bezier(0.1, 1, 0.2, 1) forwards;}
@keyframes opacity {
	0% {transform:translateY(8%); opacity:0;}
	100% {transform:translateY(0); opacity:1;}
}
@-webkit-keyframes opacity {
	0% {-webkit-transform:translateY(8%); opacity:0;}
	100% {-webkit-transform:translateY(0); opacity:1;}
}
.diary .graph {padding-bottom:15%;}
.diary .graph ol {margin-top:5%;}
.graph p, .graph li {/*opacity:0;*/}
.graph p {animation-delay:1.2s;}
.graph li:nth-child(1) {animation-delay:1.6s;}
.graph li:nth-child(2) {animation-delay:1.9s;}
.graph li:nth-child(3) {animation-delay:2.2s;}
.graph li:nth-child(4) {animation-delay:2.6s;}
.effect {animation:effect 2.5s cubic-bezier(0.2, 1, 0, 1) forwards; -webkit-animation:effect 2.5s cubic-bezier(0.2, 1, 0, 1) forwards;}
@keyframes effect {
	0% {transform:translateX(-25px); opacity:0;}
	100% {transform:translateX(0); opacity:1;}
}
@-webkit-keyframes effect {
	0% {-webkit-transform:translateX(-25px); opacity:0;}
	100% {-webkit-transform:translateX(0); opacity:1;}
}

.no1 {position:relative;}
.no1 .typing {position:absolute; top:29.83%; left:0; width:100%; animation-fill-mode:both;}
.flash {animation:flash 2.5s 5;}
@keyframes flash {
	0%, 50%, 100% {opacity:1;}
	25%, 75% {opacity:0;}
}
.conclusion {position:relative; background-color:#2b3541;}
.conclusion .btn-item {position:absolute; bottom:15%; left:50%; width:79.73%; margin-left:-39.865%;}

.vote {background-color:#f7ede5;}
.choice {background:url(http://webimage.10x10.co.kr/playing/thing/vol026/m/bg_paper.jpg) 50% 0 repeat-y; background-size:100% auto;}
.choice ul {margin-top:-13%;}
.choice ul:after {content:' '; display:block; clear:both;}
.choice li {float:left; width:50%; margin-top:13%; text-align:center;}
.choice button {position:relative; background-color:transparent; outline:none;}
.choice li:nth-child(odd) .bg {margin-left:12.53%}
.choice li:nth-child(even) .bg {margin-left:5.86%}
.choice .bg {display:block; width:88.8%; background:url(http://webimage.10x10.co.kr/playing/thing/vol026/m/btn_choice_01.png) 50% 0 no-repeat; background-size:100% auto;}
.choice .on .bg {background-position:50% 100%;}
.choice .type2 .bg {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol026/m/btn_choice_02.png);}
.choice .type3 .bg {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol026/m/btn_choice_03.png);}
.choice .type4 .bg {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol026/m/btn_choice_04.png);}
.choice .icon {position:absolute; top:-25.5%; width:26.86%; opacity:0; transition:all 0.3s;}
.choice .on .icon {opacity:1; top:-18.5%;}
.choice li:nth-child(odd) .icon {left:41%;}
.choice li:nth-child(even) .icon {left:36%;}
.choice .btn-vote {display:block; width:64%; margin:10% auto 0;}
.choice .counting {margin-top:-1%; color:#2f2f2f; font:1.11rem 'AvenirNext-Regular', 'AppleSDGothicNeo-Regular', 'RobotoRegular', 'Noto Sans', sans-serif;}
.choice .counting b {color:#f23934;}
</style>
<script type="text/javascript">
$(function(){
	/* vote */
	$(".choice li button").click(function(){
		$(".choice li button").removeClass("on");
		if ( $(this).hasClass("on")) {
			$(this).removeClass("on");
		} else {
			$(this).addClass("on");
			$("#stype").val($(this).val());
		}
	});

	/*$(window).scroll(function(){
		var position = $(window).scrollTop();
		console.log(position)
		if(position>=1){
			$("#titleAnimation .letter").addClass("opacity");
			$("#titleAnimation .graph p").addClass("effect");
			$("#titleAnimation .graph li").addClass("effect");
		}else{
			$("#titleAnimation .letter").removeClass("opacity");
			$("#titleAnimation .graph p").removeClass("effect");
			$("#titleAnimation .graph li").removeClass("effect");
		}
	});*/

	function flash() {
		var window_top = $(window).scrollTop();
		var div_top = $(".graph").offset().top;
		if (window_top > div_top){
			$(".typing").addClass("flash");
		} else {
			$(".typing").removeClass("flash");
		}
	}

	$(function() {
		$(window).scroll(flash);
	});
});
function fnBadge() {
	var badgeval = $("#stype").val();
	<% If vUserID = "" Then %>
		<% If isApp="1" or isApp="2" Then %>
		calllogin();
		return false;
		<% else %>
		jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
		return false;
		<% end if %>
	<% End If %>
	<% If vUserID <> "" Then %>
	
	if(!badgeval > 0 && !badgeval < 10){
		alert('어떤 유형인지 선택해 주세요.');
		return false;
	}
	
	var reStr;
	var str = $.ajax({
		type: "GET",
		url:"/playing/sub/doEventSubscript81528.asp",
		data: "mode=down&stype="+badgeval,
		dataType: "text",
		async: false
	}).responseText;
		reStr = str.split("|");
		if(reStr[0]=="OK"){
			if(reStr[1] == "dn") {
				$("#badgebtn").hide();
				$("#badgehd").show();
				$("#cnt"+badgeval).html(Number($("#count"+badgeval).val())+1);
				alert('투표가 완료 되었습니다.');
				//document.location.reload();
				return false;
			}else{
				alert('오류가 발생했습니다.');
				//document.location.reload();
				return false;
			}
		}else{
			errorMsg = reStr[1].replace(">?n", "\n");
			alert(errorMsg);
			
			//document.location.reload();
			return false;
		}
	<% End If %>
}

function fnBadgeok() {
	alert('투표가 완료 되었습니다.');
	return false;
}

function fnaftalt() {
	alert('이미 투표 하셨습니다.');
	return false;
}
</script>
					<div class="thingVol026 diary">
						<div id="titleAnimation" class="section topic">
							<div class="title-wrap">
								<h2>
									<span class="letter letter1"><img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/tit_diary_01.png" alt="장바구니 탐구생활 다이어리편" /></span>
									<span class="letter letter2"><img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/tit_diary_02.png" alt="왜 우리는 다이어리를 끝까지 써 본적이 없을까?" /></span>
								</h2>
								<img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/img_diary.jpg" alt="" />
							</div>
							<div class="graph">
								<p><img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/txt_graph.png" alt="나는 다이어리를 몇 월 까지 써봤다." /></p>
								<ol>
									<li><img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/img_graph_01.png" alt="57% 8월" /></li>
									<li><img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/img_graph_02.png?v=1.0" alt="25% 10월" /></li>
									<li><img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/img_graph_03.png" alt="12% 6월" /></li>
									<li><img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/img_graph_04.png" alt="6% 기타" /></li>
								</ol>
							</div>
						</div>
						<div class="section story">
							<div class="question">
								<div class="no1">
									<p class="typing"><img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/txt_no_one.png" alt="1위는 8월" /></p>
									<p><img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/txt_question_v1.jpg" alt="Question 왜, 한 해를 다 채우지 못하고 다이어리를 마무리하는 걸까? 플레잉 프로 고민 자문 위원단이 여러 유형의 다이어리 덕후들을 만나 함께 고민해 보았습니다." /></p>
								</div>
								<p style="background-color:#f5f5f5;"><img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/txt_interview_01.png" alt="예쁜 다이어리 모으기 전문 박○○ 한가지 디자인만 쓰는게 지루해, 계속 다른 제품을 구매하고 쓰길 반복해서 그런 게 아닐까요? 다이어리 꾸미기 전문 문○○ 자서전처럼 완성되는 기분이 좋아서 한 권을 예쁘게 꾸며 꽉 채워요. 하지만 눈에 보이는 손상이 생기면 새로 구매해서 사용해요." /></p>
								<p style="background-color:#f5f5f5;"><img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/txt_interview_02.png" alt="체계적으로 쓰기 전문 정○○ 용도에 맞게 사용하는 것을 좋아해서 모든 다이어리를 끝까지 다 못쓰죠. 저 같은 유형의 사람들이 많지 않을까요? 자유롭게 쓰기 전문 한○○ 칸칸이 나누어져 있는 페이지가 조금 불편해서 무지 노트처럼 편하게 사용하다 보니 한 권을 다 못채워요." /></p>
								<p style="background-color:#f5f5f5;"><img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/txt_interview_03.png" alt="다이어리 덕후들도 한 권을 다 쓰는것은 아니라는 결과와 함께 자신에게 맞는 다이어리를 찾으면 끝까지 쓸 것 같다는 의견이 나왔습니다." /></p>
							</div>
							<div class="conclusion">
								<p><img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/txt_conclusion.png" alt="Conclusion 그래서 내린 결론! 플레잉에서 유형에 맞게 추천한 다이어리로 2018년을 꽉 채워보자!" /></p>
								<div class="btn-item">
									<a href="/event/eventmain.asp?eventid=81528" class="mWeb"><img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/btn_item.gif" alt="각 유형별 다이어리 추천 아이템 보기" /></a>
									<a href="" onclick="fnAPPpopupBrowserURL('이벤트','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=81528');" target="_blank" class="mApp"><img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/btn_item.gif" alt="각 유형별 다이어리 추천 아이템 보기" /></a>
								</div>
							</div>
						</div>

						<div class="section vote">
							<p><img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/txt_vote.jpg" alt="Vote 다이어리를 쓸때 어떤 유형인지 체크 후 투표해주세요! 투표해주신 고객분들 중 추첨을 통하여 20분께 유형에 맞는 다이어리를 증정합니다. 응모기간 2017.10.30 ~ 11.13, 발표 11.14" /><input type="hidden" id="stype"></p>
							<div class="choice">
								<ul>
									<li class="type1">
										<button type="button" value="1"<% If myselect="1" Then Response.write " class='on'" %>>
											<span class="bg"><img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/btn_choice.png" alt="A 예쁜 다이어리를 모으는 유형" /></span>
											<span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/ico_check.png" alt="" /></span>
										</button>
										<div class="counting"><b id="cnt1"><%= thisfield(0) %><input type="hidden" id="count1" value="<%= thisfield(0) %>"></b>명의 선택</div>
									</li>
									<li class="type2">
										<button type="button" value="2"<% If myselect="2" Then Response.write " class='on'" %>>
											<span class="bg"><img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/btn_choice.png" alt="B 용도에 따라 다양한 다이어리를 쓰는 유형" /></span>
											<span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/ico_check.png" alt="" /></span>
										</button>
										<div class="counting"><b id="cnt2"><%= thisfield(1) %><input type="hidden" id="count2" value="<%= thisfield(1) %>"></b>명의 선택</div>
									</li>
									<li class="type3">
										<button type="button" value="3"<% If myselect="3" Then Response.write " class='on'" %>>
											<span class="bg"><img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/btn_choice.png" alt="C 꾸며서 한 권을 완성하는 유형" /></span>
											<span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/ico_check.png" alt="" /></span>
										</button>
										<div class="counting"><b id="cnt3"><%= thisfield(2) %><input type="hidden" id="count3" value="<%= thisfield(2) %>"></b>명의 선택</div>
									</li>
									<li class="type4">
										<button type="button" value="4"<% If myselect="4" Then Response.write " class='on'" %>>
											<span class="bg"><img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/btn_choice.png" alt="D 자유롭게 쓰는 유형" /></span>
											<span class="icon"><img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/ico_check.png" alt="" /></span>
										</button>
										<div class="counting"><b id="cnt4"><%= thisfield(3) %><input type="hidden" id="count4" value="<%= thisfield(3) %>"></b>명의 선택</div>
									</li>
								</ul>
								<% If vUserID = "" Then %>
								<button type="button" class="btn-vote"onClick="fnBadge();return false;" id="badgebtn"><img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/btn_vote.gif" alt="투표하기" /></button>
								<% Else %>
								<% if myevt = "0" then %>
								<button type="button" class="btn-vote"onClick="fnBadge();return false;" id="badgebtn"><img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/btn_vote.gif" alt="투표하기" /></button>
								<div class="btn-vote" id="badgehd" style="display:none"><img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/btn_vote_done.gif" alt="투표완료" /></div>
								<% Else %>
								<div class="btn-vote" id="badgehd"><img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/btn_vote_done.gif" alt="투표완료" /></div>
								<% End If %>
								<% End If %>
								<p><img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/txt_limited.png" alt="" /></p>
							</div>
						</div>

						<div class="section epilogue">
							<p><img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/txt_epilogue_01.jpg" alt="Epilogue 지금, 다이어리 쓰고 있나요? 인스타그램에 예전에 쓴, 혹은 지금 쓰고 있는 다이어리를 #텐바이텐플레잉과 함께 자랑해주세요! 다이어리 끝까지 쓰기 팁 + 사진 인스타에 게시 추첨을 통해 5분께 다이어리 선물 증정 종류 랜덤 " /></p>
							<p><img src="http://webimage.10x10.co.kr/playing/thing/vol026/m/txt_epilogue_02.jpg" alt="유의사항 인스타그램 계정이 비공개인 경우, 집계가 되지 않습니다. 당첨자 발표는 Direct Message로 개별 통보됩니다. 플레잉 인스타그램 @10X10PLAYING" /></p>
						</div>
					</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->