<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : [투표 이벤트] 우리는 모두 박스테이프 크리에이터! 
' History : 2016-01-14 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
dim repcmt
dim typeval, ceventetc
dim eCode, currenttime, userid, i
	currenttime =  now()
	'currenttime = #10/07/2015 09:00:00#

	userid = GetEncLoginUserID()

dim subscriptcount
	subscriptcount=0

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  66003
	Else
		eCode   =  68694
	End If

set ceventetc = new Cevent_etc_common_list
	ceventetc.frectevt_code=eCode

'//본인 참여 여부
if userid<>"" then
	'//본인참여수
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")

	'//초기값셋팅
	if typeval="" then
		'//처음참여일경우 첫번째탭으로
		if subscriptcount=0 then
			typeval=1
			
		'//참여완료일경우 결과로
		elseif subscriptcount>=5 then
			typeval=5

		'//나머지 그다음탭으로
		else
			typeval=subscriptcount+1
		end if
	end if

	if subscriptcount>0 then
		ceventetc.frectevt_code = eCode
		ceventetc.frectsub_opt1 = typeval
		ceventetc.frectuserid = userid
		ceventetc.event_subscript_one()
		
		if ceventetc.ftotalcount>0 then
			sub_opt2=ceventetc.FOneItem.fsub_opt2
		end if
	end if
end if
'response.write subscriptcount
'response.end
if typeval="" then typeval=1

dim sqlstr, numbertemp
sqlstr = "SELECT top 10 event_code, userid, itemid, couponidx, bigo"
sqlstr = sqlstr & " FROM db_temp.dbo.tbl_event_etc_yongman"
sqlstr = sqlstr & " where event_code="& eCode &" and isusing='Y' and couponidx=" & typeval & ""
sqlstr = sqlstr & " order by newid()"

''itemid : 글 번호
''couponidx : 탭 번호
''bigo : 코멘트

'response.write sqlstr & "<Br>"
rsget.Open sqlstr,dbget
IF not rsget.EOF THEN
	numbertemp = rsget.getrows()
END IF
rsget.close

dim ranktemp
sqlstr = "SELECT top 3 usercell, userid, bigo"
sqlstr = sqlstr & " FROM db_temp.dbo.tbl_event_etc_yongman"
sqlstr = sqlstr & " where event_code="& eCode &" and isusing='Y' "
sqlstr = sqlstr & " order by usercell+0 desc"

''itemid : 글 번호
''couponidx : 탭 번호
''bigo : 코멘트

'response.write sqlstr & "<Br>"
rsget.Open sqlstr,dbget
IF not rsget.EOF THEN
	ranktemp = rsget.getrows()
END IF
rsget.close
%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:21px;}}

img {vertical-align:top;}

@font-face {
	font-family:'SDGdGulim';
	src:url('http://www.10x10.co.kr/webfont/SDGdGulim.eot');
	src:url('http://www.10x10.co.kr/webfont/SDGdGulim.eot?#iefix') format('embedded-opentype'), url('http://www.10x10.co.kr/webfont/SDGdGulim.woff') format('woff'),url('http://www.10x10.co.kr/webfont/SDGdGulim.ttf') format('truetype');
	font-style:normal;
	font-weight:normal;
}

.mEvt68694 .hidden {visibility:hidden; width:0; height:0;}
.mEvt68694 button {background-color:transparent;}
.mEvt68694 .word {font-family:'SDGdGulim', 'Gulim' sans-serif;}

.topic {position:relative;}
.topic .tape {position:absolute; top:0; right:1%; width:48.75%;}

.voteList {padding-bottom:10%; background:#462f2a url(http://webimage.10x10.co.kr/eventIMG/2016/68694/bg_paper.jpg) repeat-y 50% 0; background-size:100% auto;}
.voteList ul {width:28rem; margin:0 auto;}
.voteList ul:after {content:' '; display:block; clear:both;}
.voteList ul li {float:left; width:12rem; margin:0 1rem; padding-top:1.5rem;}
.voteList ul li button {display:block; position:relative; width:12rem; height:8.75rem; background-color:#ba1e24; color:#fff; box-shadow:0.7rem 0.7rem 0.7rem 0 rgba(53,28,24,0.5);}
.voteList ul li:nth-child(2) button,
.voteList ul li:nth-child(3) button,
.voteList ul li:nth-child(6) button,
.voteList ul li:nth-child(7) button,
.voteList ul li:nth-child(10) button {background-color:#b48763;}
.voteList ul li .word {display:block; margin-top:1.6rem; font-size:1.2rem; line-height:1.5em;}
.voteList ul li .id {position:absolute; top:10px; right:8px; font-size:0.9rem; font-weight:bold; text-decoration:underline;}
.voteList ul li .heart {position:absolute; top:7px; left:8px; width:23px; height:19px; background:url(http://webimage.10x10.co.kr/eventIMG/2016/68694/bg_btn_vote.png) no-repeat 50% 0; background-size:23px auto;}
.voteList ul li button .mask {display:none; position:absolute; top:0; left:0; width:100%; height:100%; background-color:rgba(0,0,0,0.5);}
.voteList ul li button.on .mask {display:block;}
.voteList ul li button.on .heart {background-position:50% 100%;}
.voteList .btnNext {display:block; width:56.56%; margin:8% auto 0;}
.voteList .btnSubmit {display:block; width:86.25%; margin:8% auto 0;}

.ranking {padding-bottom:10%; background:#462f2a url(http://webimage.10x10.co.kr/eventIMG/2016/68694/bg_paper.jpg) repeat-y 50% 0; background-size:100% auto;}
.ranking ol li {margin-top:1.7rem; color:#fff;}
.ranking ol li:first-child {margin-top:0;}
.ranking ol li div {position:relative; padding:1rem 0 1.5rem 2.8rem; background-color:#b48763;}
.ranking ol li:nth-child(1) {padding-left:2.5rem;}
.ranking ol li:nth-child(1) div {padding:1.5rem 0 2.5rem 3.5rem; background-color:#ba1e24;}
.ranking ol li:nth-child(1) .word {font-size:1.6rem;}
.ranking ol li:nth-child(2) {padding-left:6.3rem;}
.ranking ol li:nth-child(3) {padding-left:9.35rem;}
.ranking ol li span {display:block;}
.ranking ol li .no {position:absolute; top:50%; left:-1.475rem; width:2.95rem; height:2.4rem; margin-top:-1.2rem;}
.ranking ol li:nth-child(1) .no {left:-1.85rem; width:3.7rem; height:3rem; margin-top:-1.5rem;}
.ranking ol li .id, .ranking ol li .count {font-size:0.9rem; font-weight:bold;}
.ranking ol li .id {text-decoration:underline;}
.ranking ol li .word {margin-top:1rem; font-size:1.2rem;}
.ranking ol li .count {margin-top:0.7rem; margin-right:1.5rem; text-align:right;}
.no {transition:2s ease-in-out; transform-origin:60% 0%; transform:rotateY(200deg); opacity:0;
	-webkit-transition:2s ease-in-out; -webkit-transform-origin:60% 0%; -webkit-transform:rotateY(200deg);
}
.no.rotate {transform:rotateY(360deg); -webkit-transform:rotateY(360deg); opacity:1;}

.noti {padding:5% 0; background-color:#efefef;}
.noti ul {padding:0 4.7%;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#9e9e9e; font-size:1rem; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:0.6rem; left:0; width:0.5rem; height:0.1rem; background-color:#9e9e9e;}

@media (min-width:480px) {
	.voteList ul li .id {top:15px; right:12px;}
	.voteList ul li .heart {top:10px; left:12px; width:34px; height:28px; background-size:34px auto;}
}
</style>
<script type="text/javascript">
<% if typeval > "1" then %>
	$(function(){
		setTimeout("pagedown()",300);
	});
<% end if %>

function pagedown(){
	<% if typeval > 1 and typeval < 5 then %>
		window.$('html,body').animate({scrollTop:$("#stepnum").offset().top}, 0);
	<% else %>
		window.$('html,body').animate({scrollTop:$("#rankingdisplay").offset().top}, 0);
	<% end if %>
}

$(function(){
	/* vote */
	$(".voteList li button").click(function(){
		$(".voteList li button").removeClass("on");
		if ( $(this).hasClass("on")) {
			$(this).removeClass("on");
		} else {
			$(this).addClass("on");
		}
	});

	/* animation */
	$(".btnSubmit").click(function(){
		animation();
	});

	function animation() {
		$(".no").delay(50).addClass("rotate");
	}
<% if typeval >= "5" then %>
	$("#votedisplay").hide();
	$("#rankingdisplay").show();
	animation();
<% end if %>
});

function jsevtchk(){
	<% if Date() < "2016-01-18" or Date() > "2016-01-24" then %>
		alert('이벤트 응모 기간이 아닙니다.');
		return;
	<% else %>
		//선택
		var selectvaluecmt

		if($("#1").attr("class") == "on"){
			selectvaluecmt = "1";
		}else if ($("#2").attr("class") == "on"){
			selectvaluecmt = "2";
		}else if ($("#3").attr("class") == "on"){
			selectvaluecmt = "3";
		}else if ($("#4").attr("class") == "on"){
			selectvaluecmt = "4";
		}else if ($("#5").attr("class") == "on"){
			selectvaluecmt = "5";
		}else if ($("#6").attr("class") == "on"){
			selectvaluecmt = "6";
		}else if ($("#7").attr("class") == "on"){
			selectvaluecmt = "7";
		}else if ($("#8").attr("class") == "on"){
			selectvaluecmt = "8";
		}else if ($("#9").attr("class") == "on"){
			selectvaluecmt = "9";
		}else if ($("#10").attr("class") == "on"){
			selectvaluecmt = "10";
		}else if ($("#11").attr("class") == "on"){
			selectvaluecmt = "11";
		}else if ($("#12").attr("class") == "on"){
			selectvaluecmt = "12";
		}else if ($("#13").attr("class") == "on"){
			selectvaluecmt = "13";
		}else if ($("#14").attr("class") == "on"){
			selectvaluecmt = "14";
		}else if ($("#15").attr("class") == "on"){
			selectvaluecmt = "15";
		}else if ($("#16").attr("class") == "on"){
			selectvaluecmt = "16";
		}else if ($("#17").attr("class") == "on"){
			selectvaluecmt = "17";
		}else if ($("#18").attr("class") == "on"){
			selectvaluecmt = "18";
		}else if ($("#19").attr("class") == "on"){
			selectvaluecmt = "19";
		}else if ($("#20").attr("class") == "on"){
			selectvaluecmt = "20";
		}else if ($("#21").attr("class") == "on"){
			selectvaluecmt = "21";
		}else if ($("#22").attr("class") == "on"){
			selectvaluecmt = "22";
		}else if ($("#23").attr("class") == "on"){
			selectvaluecmt = "23";
		}else if ($("#24").attr("class") == "on"){
			selectvaluecmt = "24";
		}else if ($("#25").attr("class") == "on"){
			selectvaluecmt = "25";
		}else if ($("#26").attr("class") == "on"){
			selectvaluecmt = "26";
		}else if ($("#27").attr("class") == "on"){
			selectvaluecmt = "27";
		}else if ($("#28").attr("class") == "on"){
			selectvaluecmt = "28";
		}else if ($("#29").attr("class") == "on"){
			selectvaluecmt = "29";
		}else if ($("#30").attr("class") == "on"){
			selectvaluecmt = "30";
		}else if ($("#31").attr("class") == "on"){
			selectvaluecmt = "31";
		}else if ($("#32").attr("class") == "on"){
			selectvaluecmt = "32";
		}else if ($("#33").attr("class") == "on"){
			selectvaluecmt = "33";
		}else if ($("#34").attr("class") == "on"){
			selectvaluecmt = "34";
		}else if ($("#35").attr("class") == "on"){
			selectvaluecmt = "35";
		}else if ($("#36").attr("class") == "on"){
			selectvaluecmt = "36";
		}else if ($("#37").attr("class") == "on"){
			selectvaluecmt = "37";
		}else if ($("#38").attr("class") == "on"){
			selectvaluecmt = "38";
		}else if ($("#39").attr("class") == "on"){
			selectvaluecmt = "39";
		}else if ($("#40").attr("class") == "on"){
			selectvaluecmt = "40";
		}else{
			alert('마음에 드는 박스테이프 카피를 선택해주세요.');
			return;
		}

		var result;
			$.ajax({
				type:"GET",
				url:"/event/etc/doEventSubscript68694.asp",
				data: "mode=cmtsel&selectvaluecmt="+selectvaluecmt,
				dataType: "text",
				async:false,
				cache:false,
				success : function(Data){
					result = jQuery.parseJSON(Data);
					if (result.resultcode=="11")
					{
						 parent.location.reload();
					//	alert("응모가 완료되었습니다.");
					//	return;
					}
					else if (result.resultcode=="44")
					{
						<% If isapp="1" Then %>
							calllogin();
							return;
						<% else %>
							jsevtlogin();
							return;
						<% End If %>
					}
					else if (result.resultcode=="33")
					{
						alert("이미 투표 하셨습니다.");
						return;
					}
					else if (result.resultcode=="88")
					{
						alert("이벤트 기간이 아닙니다.");
						return;
					}
				}
			});
	<% end if %>
}

</script>
	<div class="mEvt68694">
		<article>
			<div class="topic">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/68694/tit_box_tape.png" alt="널리 박스테이를 이롭게 하다" /></h2>
				<p class="hidden">텐바이텐에서 기발한 카피를 찾습니다 투표 기간은 2016년 1월 18일 월요일부터 1월 24일 입요일까지며, 최종 발표는 1월 27일 수요일입니다.</p>
				<span class="tape"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68694/img_tape.png" alt="" /></span>
			</div>

			<div class="vote" id="votedisplay">
				<div class="voteList step0<%= typeval %>">
					<h3 class="hidden">스텝<%= typeval %></h3>
					<p id="stepnum"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68694/txt_step_0<%= typeval %>.gif" alt="가장 마음에 드는 박스테이프 카피를 스텝별 1개씩 하트를 클릭해주세요!" /></p>
					<ul>
					<%
					'	numbertemp(0,i) ''이벤트코드
					'	numbertemp(1,i) ''id
					'	numbertemp(2,i) ''글번호
					'	numbertemp(3,i) ''탭번호
					'	numbertemp(4,i) ''코멘트
					%>
					<% if isarray(numbertemp) then %>
						<% for i = 0 to ubound(numbertemp,2) %>
							<li id="vote<%= Format00(2,numbertemp(2,i)) %>">
								<button type="button" id="<%= numbertemp(2,i) %>">
									<span class="word"><%=numbertemp(4,i) %></span>
									<span class="id"><%= numbertemp(1,i) %></span><span class="heart"></span><span class="mask"></span>
								</button>
							</li>
						<% next %>
					<% end if %>
					</ul>

					<% if typeval >= 4 then %>
						<button type="button" onclick="jsevtchk(); return false;" class="btnSubmit"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68694/btn_submit.png" alt="제출하기" /></button>
					<% else %>
						<button type="button" onclick="jsevtchk(); return false;" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68694/btn_next.png" alt="다음단계로" /></button>
					<% end if %>
				</div>
			</div>

			<section class="ranking"  id="rankingdisplay" style="display:none;">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/68694/tit_ranking.jpg" alt="지금 현재 순위는??" /></h3>
				<ol>
				<% if isarray(ranktemp) then %>
					<% for i = 0 to ubound(ranktemp,2) %>
					<% repcmt = replace(ranktemp(2,i),"<br />","") %>
						<li>
							<div>
								<span class="no"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68694/txt_no_0<%= i+1 %>.png" alt="<%= i+1 %>등" /></span>
								<span class="id"><%=ranktemp(1,i) %></span>
								<span class="word"><%=repcmt %></span>
							</div>
							
						</li>
					<% next %>
				<% end if %>
				</ol>
			</section>

			<section class="noti">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/68694/tit_noti.png" alt="이벤트 유의사항" /></h3>
				<ul>
					<li>로그인 후 투표에 참여하실 수 있습니다.</li>
					<li>각 STEP 별로 1개씩만 선택, 총 4개를 선택할 수 있습니다.</li>
					<li>투표 후 취소 및 변경이 불가하므로 신중히 선택해주세요.</li>
					<li>모든 응모작의 저작권을 포함한 일체 권리는 텐바이텐에 귀속됩니다.</li>
					<li>투표결과와 실제 제작상품이 달라질 수 있습니다.</li>
					<li>실제 상품 제작 시, 일부분 수정될 가능성이 있습니다.</li>
					<li>비슷한 응모작은 최초 응모작을 당첨자로 선정하였습니다.</li>
					<li>새로운 박스테이프는 3월부터 만나보실 수 있습니다.</li>
				</ul>
			</section>
		</article>
	</div>
<% set ceventetc=nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->