<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#################################################################
' Description : 플레잉 Thing 여러분은 다이어트할 때 어떤 성향 인가요?
' History : 2018-02-13 이종화
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
	eCode = "84592"
End If

vDIdx = request("didx")
vUserID = getEncLoginUserID
myselect = 0

'참여했는지 체크
myevt = getevent_subscriptexistscount(eCode, vUserID,"","","")

sqlStr = ""
sqlStr = sqlStr & " SELECT isnull([1],0) AS '1',isnull([2],0) AS '2',isnull([3],0) AS '3',isnull([4],0) AS '4'" & vbCrlf
sqlStr = sqlStr & " FROM  " & vbCrlf
sqlStr = sqlStr & " ( " & vbCrlf
sqlStr = sqlStr & "		SELECT  sub_opt2 AS so2, COUNT(*) AS cnt " & vbCrlf
sqlStr = sqlStr & "			FROM db_event.[dbo].[tbl_event_subscript]  " & vbCrlf
sqlStr = sqlStr & "				WHERE evt_code = '"& eCode &"' " & vbCrlf
sqlStr = sqlStr & "				GROUP BY sub_opt2 " & vbCrlf
sqlStr = sqlStr & " ) AS a " & vbCrlf
sqlStr = sqlStr & " PIVOT " & vbCrlf
sqlStr = sqlStr & " ( " & vbCrlf
sqlStr = sqlStr & "		sum(cnt) FOR so2 IN ([1],[2],[3],[4]) " & vbCrlf
sqlStr = sqlStr & " ) AS tp "
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
%>
<style type="text/css">
.topic {position:relative;}
.topic h2 {position:absolute; left:0; top:19%; z-index:40; width:100%;}
.topic .desp {position:absolute; left:0; top:40.4%; width:100%; margin-top:8px; opacity:0; transition:all .8s 0.5s;}
.topic .viewTag {position:absolute; left:0; top:50.18%; width:100%; margin-top:10px; z-index:20; opacity:0; transition:all .6s 1.2s;}
.topic .rank {position:absolute; left:0; bottom:24.8%; width:50%; margin-top:30px; opacity:0; transition:all 1s 1.5s;}
.topic .rank > div {position:relative; width:100%;}
.topic .rank > div span {display:block; position:absolute; left:0; top:-5.2%; animation:blink 1.7s 50 2s; animation-fill-mode:both;}
.topic.animation .desp {margin-top:0; opacity:1;}
.topic.animation .viewTag {margin-top:0; opacity:1;}
.topic.animation .rank {margin-top:0; opacity:1;}
.section {position:relative;}
.section1 p {position:absolute; left:50%; top:57%; height:8.8%; opacity:1; display:inline-block; background:url(http://webimage.10x10.co.kr/playing/thing/vol035/m/txt_what_question.png) 0 0 no-repeat; background-size:cover; text-indent:-900em;}
.section3 .conclusion {position:absolute; left:10%; top:72%; width:80%;}
.section4 {background-color:#f8e5e1;}
.section4 .vote ul {overflow:hidden; width:100%;}
.section4 .vote ul li {position:relative; float:left; width:50%; padding-top:60%;}
.section4 .vote ul li div {position:absolute; left:0; top:0; width:100%; height:100%;}
.section4 .vote ul li p {position:absolute; left:0; bottom:5%; width:100%; font-size:1.11rem; text-align:center; font-weight:bold; color:#5e5e5e;}
.section4 .vote ul li p span {color:#f2403c;}
.section4 .vote ul li input {visibility:hidden; position:absolute; left:0; top:0; width:0; height:0;}
.section4 .vote ul li label {overflow:hidden; display:block; position:relative; width:100%; height:100%; cursor:pointer; text-indent:-999em; background-image:url(http://webimage.10x10.co.kr/playing/thing/vol035/m/img_vote.png); background-repeat:no-repeat; background-position:0 0; background-size:200% 200%;}
.section4 .vote ul li + li input + label {background-position:100% 0;}
.section4 .vote ul li + li + li input + label {background-position:0% 100%;}
.section4 .vote ul li + li + li + li input + label {background-position:100% 100%;}
.section4 .vote ul li input[type=radio]:checked + label {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol035/m/img_vote_check.png);}
.blink {animation:blink 1.7s 50 3.8s; animation-fill-mode:both;}
@keyframes  blink {
	0%, 100% {opacity:0;}
	10%, 30%, 50%, 70%, 90% {opacity:1;}
	20%, 40%, 60%, 80% {opacity:0;}
}
.typing {width:62%; margin-left:-31%; animation:typing .6s steps(10, end);}
@keyframes typing {
	from {width:0; margin-left:0;}
	to {width:62%; margin-left:-31%;}
}
</style>
<script type="text/javascript">
$(function(){
	var position = $('.thingVol035').offset(); // 위치값
	//$('html,body').animate({ scrollTop : position.top },300); // 이동

	titleAnimation();
	$(".topic h2").css({"margin-top":"10px","opacity":"0"});
	function titleAnimation() {
		$(".topic h2").delay(100).animate({"margin-top":"-5px","opacity":"1"},600).animate({"margin-top":"0"},400);
	}
	$(".topic").addClass("animation");

    function typingAnimation() {
        var window_top = $(window).scrollTop();
        var div_top = ($(".section1").offset().top)-222;
        if (window_top > div_top){
            $(".section1 p").addClass("typing");
        }
    }

    $(function() {
        $(window).scroll(typingAnimation);
        typingAnimation();
    });

	/* vote */
	$(".vote li").click(function(){
		$("#stype").val($(this).find("input").val());
	});
});


function fnBadge(){
	var badgeval = $("#stype").val();
	<% If vUserID = "" Then %>
		<% If isApp="1" or isApp="2" Then %>
		calllogin();
		return false;
		<% else %>
		jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
		return false;
		<% end if %>
	<% else %>

	if(badgeval == ""){
		alert('어떤 유형인지 선택해 주세요.');
		return false;
	}

	var reStr;
	var str = $.ajax({
		type: "GET",
		url:"/playing/sub/sub_proc.asp",
		data: "mode=act&eventid=<%=eCode%>&subopt2="+badgeval,
		dataType: "text",
		async: false
	}).responseText;
		reStr = str.split("|");
		if(reStr[0]=="OK"){
			if(reStr[1] == "ok") {
				$("#badgebtn").hide();
				$("#badgehd").show();
				$("#cnt"+badgeval).html(parseInt($("#cnt"+badgeval).text())+1);
				alert('투표가 완료 되었습니다.');
				return false;
			}else{
				alert('오류가 발생했습니다.');
				return false;
			}
		}else{
			errorMsg = reStr[1].replace(">?n", "\n");
			alert(errorMsg);
			return false;
		}
	<% End If %>
}
</script>
<div class="thingVol035">
	<div class="topic">
		<h2><img src="http://webimage.10x10.co.kr/playing/thing/vol035/m/tit_diet.png" alt="명절에 이 소리 또 들었다 살쪘니?" /></h2>
		<p class="desp"><img src="http://webimage.10x10.co.kr/playing/thing/vol035/m/tit_diet_desp.png" alt="Feat. 나 오늘부터 다이어트 한다" /></p>
		<p class="viewTag"><img src="http://webimage.10x10.co.kr/playing/thing/vol035/m/tag_view.png" alt="다이어트를 결심하는 순간4" /></p>
		<div class="rank">
			<div>
				<span class="deco"><img src="http://webimage.10x10.co.kr/playing/thing/vol035/m/line_dot.png" alt="" /></span>
				<img src="http://webimage.10x10.co.kr/playing/thing/vol035/m/img_grade.png" alt="1위 명절이 끝난 후 / 2위 1월, 새해 / 3위 여름휴가 D-30 /4위 365일 항상" />
			</div>
		</div>
		<div><img src="http://webimage.10x10.co.kr/playing/thing/vol035/m/img_topic.jpg" alt="" /></div>
	</div>
	<div class="section section1">
		<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol035/m/txt_what.png" alt="덕담 대신 받은 잔소리때문에 오늘부터 다이어트를 결심하신 분 있나요? 다이어트를 결심하고 실패하기를 반복하는 우리. 다이어트에 성공한 플레잉 위원들의 경험을 들어보았습니다." /></h3>
		<p>어떻게 해야 성공할까?</p>
	</div>
	<div class="section section2">
		<ul>
			<li class="story1"><p><img src="http://webimage.10x10.co.kr/playing/thing/vol035/m/img_talk1.jpg" alt="길고 확실하게 A유형" /></p></li>
			<li class="story2"><p><img src="http://webimage.10x10.co.kr/playing/thing/vol035/m/img_talk2.jpg" alt="먹고 운동하자 B유형" /></p></li>
			<li class="story3"><p><img src="http://webimage.10x10.co.kr/playing/thing/vol035/m/img_talk3.jpg" alt="단기 다이어트 C유형" /></p></li>
			<li class="story4"><p><img src="http://webimage.10x10.co.kr/playing/thing/vol035/m/img_talk4.jpg" alt="다이어트 못해 D유형" /></p></li>
		</ul>
	</div>
	<div class="section section3">
		<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol035/m/txt_conclusion.png" alt="나의 성향과 비슷한 다이어트 추천 방법으로 이번 다이어트! 성공해보시면 어떨까요?" /></h3>
		<% If isapp="1" Then %>
		<a href="/apps/appcom/wish/web2014/event/eventmain.asp?eventid=84592" target="_blank"><img src="http://webimage.10x10.co.kr/playing/thing/vol035/m/btn_item.png" alt="다이어트 추천 아이템 보기"  class="conclusion" /></a>
		<% Else %>
		<a href="/event/eventmain.asp?eventid=84592" target="_blank"><img src="http://webimage.10x10.co.kr/playing/thing/vol035/m/btn_item.png" alt="다이어트 추천 아이템 보기"  class="conclusion" /></a>
		<% End If %>
	</div>
	<input type="hidden" name="stype" id="stype" value=""/>
	<div class="section section4">
		<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol035/m/tit_vote.png" alt="여러분은 다이어트할 때 어떤 성향인가요?" /></h3>
		<div class="vote">
			<ul>
				<li>
					<div><input type="radio" id="type1" value="1" name="evtopt1"/><label for="type1">A타입 - 길고 확실하게 유형</label></div>
					<p><span id="cnt1"><%= thisfield(0) %></span>명의 선택</p>
				</li>
				<li>
					<div><input type="radio" id="type2" value="2" name="evtopt1"/><label for="type2">B타입 - 먹고 운동하자 유형</label></div>
					<p><span id="cnt2"><%= thisfield(1) %></span>명의 선택</p>
				</li>
				<li>
					<div><input type="radio" id="type3" value="3" name="evtopt1"/><label for="type3">C타입 - 단기 다이어트 유형</label></div>
					<p><span id="cnt3"><%= thisfield(2) %></span>명의 선택</p>
				</li>
				<li>
					<div><input type="radio" id="type4" value="4" name="evtopt1"/><label for="type4">D타입 - 다이어트 못해 유형</label></div>
					<p><span id="cnt4"><%= thisfield(3) %></span>명의 선택</p>
				</li>
			</ul>
			<% If vUserID = "" Then %>
			<button class="submit" onClick="fnBadge();return false;" id="badgebtn"><img src="http://webimage.10x10.co.kr/playing/thing/vol035/m/btn_vote.png" alt="투표하기" /></button>
			<% Else %>
			<% if myevt = "0" then %>
			<button class="submit" onClick="fnBadge();return false;" id="badgebtn"><img src="http://webimage.10x10.co.kr/playing/thing/vol035/m/btn_vote.png" alt="투표하기" /></button>
			<p class="submit" id="badgehd" style="display:none"><img src="http://webimage.10x10.co.kr/playing/thing/vol035/m/btn_vote_ok.png" alt="투표완료" /></p>
			<% Else %>
			<p class="submit" id="badgehd"><img src="http://webimage.10x10.co.kr/playing/thing/vol035/m/btn_vote_ok.png" alt="투표완료" /></p>
			<% End If %>
			<% End If %>
			<p><img src="http://webimage.10x10.co.kr/playing/thing/vol035/m/txt_vote_once.png" alt="한 ID당 1회 투표" /></p>
		</div>
	</div>
	<div class="epilogue">
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol035/m/txt_epilogue.png" alt="이번 플레잉 이벤트 당첨확률이 높은 고객 - 1. 텐바이텐에서 최근에 구매한 고객 / 2. 눈에 확 끌만한 재미있는 코멘트를 남겨주신 고객 / 3. 플레잉 컨텐츠들을 많이 응모했던 고객" /></p>
	</div>
</div>
<!-- //THING. html 코딩 영역 -->
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->