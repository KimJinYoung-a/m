<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 사진찍냥? 투표하개! MA
' History : 2017-08-22 유태욱
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, vUserID, sqlstr
dim votecnt1, votecnt2, votecnt3, votecnt4, votecnt5, votecnt6, votecnt7, votecnt8, votecnt9

IF application("Svr_Info") = "Dev" THEN
	eCode = "66415"
Else
	eCode = "79941"
End If

vUserID = getEncLoginUserID

'투표 카운터
sqlstr = "SELECT " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '1' then 1 else 0 end),0) as vote1, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '2' then 1 else 0 end),0) as vote2, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '3' then 1 else 0 end),0) as vote3, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '4' then 1 else 0 end),0) as vote4, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '5' then 1 else 0 end),0) as vote5, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '6' then 1 else 0 end),0) as vote6, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '7' then 1 else 0 end),0) as vote7, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '8' then 1 else 0 end),0) as vote8, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '9' then 1 else 0 end),0) as vote9 " + vbcrlf
sqlstr = sqlstr & " from db_event.dbo.tbl_event_subscript where evt_code = '"& eCode &"'  " 
rsget.Open sqlstr,dbget,1
IF Not rsget.Eof Then
	votecnt1 = rsget("vote1")
	votecnt2 = rsget("vote2")
	votecnt3 = rsget("vote3")
	votecnt4 = rsget("vote4")
	votecnt5 = rsget("vote5")
	votecnt6 = rsget("vote6")
	votecnt7 = rsget("vote7")
	votecnt8 = rsget("vote8")
	votecnt9 = rsget("vote9")
End If
rsget.close()
	
%>
<style type="text/css">
.vote {padding-bottom:6rem; text-align:center; background:#fff;}
.vote .txt1 {padding-bottom:0.8rem; font-size:2.1rem; line-height:1.3; font-weight:200; color:#333;}
.vote .txt1 strong {color:#d92631;}
.vote .txt2 {font-size:1rem; color:#666;}
.vote .txt2 i {position:relative; top:0.2rem;}
.vote ul {overflow:hidden; padding:3.5rem 4.6% 0.5rem;}
.vote li {float:left; width:50%; height:23rem; font-size:1rem; line-height:1.3; color:#666; letter-spacing:-0.03em;}
.vote li:last-child {margin-left:25%;}
.vote li .photo {position:relative; width:86%; margin:0 auto;}
.vote li .photo .check {display:block; position:absolute; right:0; bottom:0; padding:0.3rem; background:#fff; border-radius:50%;}
.vote li .photo .check i {display:block; position:relative; width:2.7rem; height:2.7rem; border:1px solid #999; border-radius:50%;}
.vote li .photo .check i:after {content:''; display:inline-block; position:absolute; left:50%; top:50%; width:1rem; height:1rem; margin:-0.5rem 0 0 -0.5rem; background:url(http://webimage.10x10.co.kr/eventIMG/2017/79941/m/ico_check.png) no-repeat 0 0; background-size:100% auto;}
.vote li .name {padding:1.5rem 0 0.3rem; color:#333;}
.vote li .name em {padding-right:0.6rem; font-weight:bold; font-size:1.4rem;}
.vote li .count {display:block; padding-top:0.8rem; font-family:arial;}
.vote li .count i {display:inline-block; width:1.05rem; height:0.95rem; margin-right:0.3rem; background:url(http://webimage.10x10.co.kr/eventIMG/2017/79941/m/ico_heart.png) no-repeat 0 0; background-size:100% auto; vertical-align:middle;}
.vote li.current .photo .check i {border-color:#d92631; background:#d92631;}
.vote li.current .photo .check i:after {background-position:0 100%;}
.vote li.current .count {color:#d92631;}
.vote li.current .count i {background-position:0 100%;}
.vote .btnVote {display:block; width:68.75%; height:5rem; margin:0 auto 1rem; color:#fff; font-size:1.6rem; letter-spacing:0.4rem; background:#d92631; vertical-align:top;}
.evtNoti {padding:3rem 0; background:#3c3c3c;}
.evtNoti h3 {padding-bottom:1.6rem; font-size:1.6rem; font-weight:bold; color:#fff; text-align:center;}
.evtNoti h3 span {border-bottom:0.15rem solid #fff;}
.evtNoti ul {padding:0 7.8%;}
.evtNoti li {position:relative; font-size:1rem; line-height:1.5; color:#fff; padding:0 0 0.3rem 1.5rem;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.55rem; width:0.6rem; height:0.15rem; background-color:#fff;}
</style>
<script>
$(function(){
	$(".vote li").click(function(){
		$(".vote li").removeClass("current");
		$(this).addClass("current");
	});
});

function fnVote() {
	<% If vUserID = "" Then %>
		if ("<%=IsUserLoginOK%>"=="False") {
			<% If isapp="1" Then %>
				parent.calllogin();
				return;
			<% else %>
				parent.jsevtlogin();
				return;
			<% End If %>
		}
	<% End If %>
	<% If vUserID <> "" Then %>
	var reStr;
	var voteval = $("#voteval").val();
		if(voteval > 0 && voteval < 10 ){
		}else{
			alert('투표할 친구를 선택해 주세요.');
			return;
		}
	var str = $.ajax({
		type: "GET",
		url:"/event/etc/doeventsubscript/doEventSubscript79941.asp",
		data: "mode=vote&voteval="+voteval,
		dataType: "text",
		async: false
	}).responseText;
		reStr = str.split("|");
		if(reStr[0]=="OK"){
			if(reStr[1] == "vt") {
				<% if date() = "2017-08-30" then %>
					alert('이벤트에 응모하셨습니다.\n당첨일을 기대해 주세요!');
					$("#votecnt1").empty().html("<i></i>"+reStr[2]);
					$("#votecnt2").empty().html("<i></i>"+reStr[3]);
					$("#votecnt3").empty().html("<i></i>"+reStr[4]);
					$("#votecnt4").empty().html("<i></i>"+reStr[5]);
					$("#votecnt5").empty().html("<i></i>"+reStr[6]);
					$("#votecnt6").empty().html("<i></i>"+reStr[7]);
					$("#votecnt7").empty().html("<i></i>"+reStr[8]);
					$("#votecnt8").empty().html("<i></i>"+reStr[9]);
					$("#votecnt9").empty().html("<i></i>"+reStr[10]);
				<% else %>
					alert('소중한 한 표 감사합니다!\n내일 또 투표해주세요!');
					$("#votecnt1").empty().html("<i></i>"+reStr[2]);
					$("#votecnt2").empty().html("<i></i>"+reStr[3]);
					$("#votecnt3").empty().html("<i></i>"+reStr[4]);
					$("#votecnt4").empty().html("<i></i>"+reStr[5]);
					$("#votecnt5").empty().html("<i></i>"+reStr[6]);
					$("#votecnt6").empty().html("<i></i>"+reStr[7]);
					$("#votecnt7").empty().html("<i></i>"+reStr[8]);
					$("#votecnt8").empty().html("<i></i>"+reStr[9]);
					$("#votecnt9").empty().html("<i></i>"+reStr[10]);
				<% end if %>
				return false;
			}else{
				alert('오류가 발생했습니다.');
				return false;
			}
		}else{
			errorMsg = reStr[1].replace(">?n", "\n");
			alert(errorMsg);
			document.location.reload();
			return false;
		}
	<% End If %>
}

function fnVoteval(vval){
	if(vval > 0 && vval < 10 ){
		$("#voteval").val(vval);
	}else{
		$("#voteval").val(1);
	}
}

</script>
	<!-- 사진찍냥? 투표하개! -->
	<div class="mEvt79941">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/79941/m/tit_cat_dog.jpg" alt="사진찍냥? 투표하개!" /></h2>
		<!-- 투표하기 -->
		<div class="vote">
			<p class="txt1">당신의 마음을 사로잡는<br />친구에게 <strong>투표해주세요</strong></p>
			<p class="txt2"><i>*</i> 후보는 SNS 사전 이벤트를 통해 선정되었습니다</p>
			<ul>
				<li onclick="fnVoteval(1);">
					<div class="photo">
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/79941/img_candidate_1.jpg" alt="" />
						<span class="check"><i></i></span>
					</div>
					<p class="name"><em>두부</em>(3살)</p>
					<span class="count" id="votecnt1"><i></i><%=votecnt1%></span>
				</li>
				<li onclick="fnVoteval(2);">
					<div class="photo">
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/79941/img_candidate_2.jpg" alt="" />
						<span class="check"><i></i></span>
					</div>
					<p class="name"><em>무무</em>(2살)</p>
					<span class="count" id="votecnt2"><i></i><%=votecnt2%></span>
				</li>
				<li onclick="fnVoteval(3);">
					<div class="photo">
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/79941/img_candidate_3.jpg" alt="" />
						<span class="check"><i></i></span>
					</div>
					<p class="name"><em>복댕이</em>(4살)</p>
					<span class="count" id="votecnt3"><i></i><%=votecnt3%></span>
				</li>
				<li onclick="fnVoteval(4);">
					<div class="photo">
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/79941/img_candidate_4.jpg" alt="" />
						<span class="check"><i></i></span>
					</div>
					<p class="name"><em>샤로</em>(5살)</p>
					<span class="count" id="votecnt4"><i></i><%=votecnt4%></span>
				</li>
				<li onclick="fnVoteval(5);">
					<div class="photo">
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/79941/img_candidate_5.jpg" alt="" />
						<span class="check"><i></i></span>
					</div>
					<p class="name"><em>수수</em>(3살)</p>
					<span class="count" id="votecnt5"><i></i><%=votecnt5%></span>
				</li>
				<li onclick="fnVoteval(6);">
					<div class="photo">
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/79941/img_candidate_6.jpg" alt="" />
						<span class="check"><i></i></span>
					</div>
					<p class="name"><em>지봉이</em>(9개월)</p>
					<span class="count" id="votecnt6"><i></i><%=votecnt6%></span>
				</li>
				<li onclick="fnVoteval(7);">
					<div class="photo">
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/79941/img_candidate_7.jpg" alt="" />
						<span class="check"><i></i></span>
					</div>
					<p class="name"><em>앵두</em>(2살)</p>
					<span class="count" id="votecnt7"><i></i><%=votecnt7%></span>
				</li>
				<li onclick="fnVoteval(8);">
					<div class="photo">
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/79941/img_candidate_8.jpg" alt="" />
						<span class="check"><i></i></span>
					</div>
					<p class="name"><em>시월</em>(10개월)</p>
					<span class="count" id="votecnt8"><i></i><%=votecnt8%></span>
				</li>
				<li onclick="fnVoteval(9);">
					<div class="photo">
						<img src="http://webimage.10x10.co.kr/eventIMG/2017/79941/img_candidate_9.jpg" alt="" />
						<span class="check"><i></i></span>
					</div>
					<p class="name"><em>이하윤</em>(2살)</p>
					<span class="count" id="votecnt9"><i></i><%=votecnt9%></span>
				</li>
			</ul>
			<input type="hidden" name="voteval" id="voteval" value="" >
			<button type="button" onclick="fnVote(); return false;" class="btnVote">투표하기</button>
			<p class="txt2"><i>*</i> ID당 1일 1회 참여가능</p>
		</div>
		<!--// 투표하기 -->
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/79941/m/txt_gift_1.jpg" alt="투표에 참여해주신 분들 중 추첨을 통해 텐바이텐 기프트카드 1만원권 증정" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/79941/m/txt_gift_2.jpg" alt="선택받은 9마리 반려동물 1,2,3등 - 땡큐 스튜디오 촬영권/4~9등 반려동물 쿠션 증정" /></p>
		<div class="evtNoti">
			<h3><span>이벤트 유의사항</span></h3>
			<ul>
				<li>오직 텐바이텐 회원님을 위한 이벤트 입니다.<br />(로그인 후 참여가능, 비회원 참여 불가)</li>
				<li>한 ID당 하루에 한 번만 참여할 수 있습니다.</li>
				<li>이벤트 당첨 상품 중 ‘땡큐스튜디오 촬영권’의 구성은 다음과 같습니다. (전문 리터칭 6장 이미지 파일, 5x7 4장 프린트, 찍은 사진이 담긴 커스텀 휴대폰 케이스, 원본파일 제공)</li>
				<li>[땡큐스튜디오 촬영권] 사용방법은 이벤트 당첨시에 공지 예정입니다.</li>
				<li>이벤트 경품은 내부 사정에 의해 변경될 수 있습니다.</li>
				<li>당첨자와 수령자는 동일해야 하며, 양도는 불가합니다.</li>
				<li>정확한 발표를 위해 마이텐바이텐의 개인정보를 업데이트 해주세요.</li>
				<li>이벤트 종료 후 당첨된 경품의 교환 및 변경은 불가 합니다.</li>
			</ul>
		</div>
	</div>
	<!--// 사진찍냥? 투표하개! -->
<!-- #include virtual="/lib/db/dbclose.asp" -->
