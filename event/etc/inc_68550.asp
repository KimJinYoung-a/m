<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 서른의 설
' History : 2016-01-08 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
dim oItem, pagereload, classboxcol
dim vTotalCount, currenttime, sqlstr
	currenttime =  now()
	'currenttime = #10/07/2015 09:00:00#

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66000
Else
	eCode   =  68550
End If

dim userid, commentcount, i
	userid = GetEncLoginUserID()

commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop, ecc
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)
	pagereload	= requestCheckVar(request("pagereload"),10)

IF blnFull = "" THEN blnFull = True
IF blnBlogURL = "" THEN blnBlogURL = False

IF iCCurrpage = "" THEN
	iCCurrpage = 1
END IF
IF iCTotCnt = "" THEN
	iCTotCnt = -1
END IF

iCPerCnt = 4		'보여지는 페이지 간격
'한 페이지의 보여지는 열의 수
if blnFull then
	iCPageSize = 6		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 6		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
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

'// 총 카운트
sqlstr = "select count(*) "
sqlstr = sqlstr & " from db_event.[dbo].[tbl_event_subscript]"
sqlstr = sqlstr & " where evt_code='"& eCode &"' and sub_opt1='book' "
rsget.Open sqlstr, dbget, 1

If Not rsget.Eof Then
	vTotalCount = rsget(0)
End IF
rsget.close

%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:21px;}}

img {vertical-align:top;}

.mEvt68550 button {background-color:transparent;}

.topic {position:relative;}
.topic h2 {position:absolute; top:11%; left:33%; width:13.125%;}

.navigator {overflow:hidden; position:absolute; top:10%; right:10%; width:32%; z-index:10;}
.navigator li {width:100%; margin-bottom:15%;}
.navigator li a {overflow:hidden; display:block; position:relative; height:0; padding-bottom:100%; color:transparent; font-size:1.1rem; line-height:11em; text-align:center;}
.navigator li span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter:alpha(opacity=0); cursor:pointer;}
.navigator li a i {position:absolute; top:6%; right:3%; width:16%;}
.navigator li.nav2 a i {top:15%;}
.navigator li a i {animation-name:bounce; animation-iteration-count:5; animation-duration:0.7s; -webkit-animation-name:bounce; -webkit-animation-iteration-count:5; -webkit-animation-duration:0.7s;}
@keyframes bounce {
	from, to{margin-top:0; animation-timing-function:ease-out;}
	50% {margin-top:5px; animation-timing-function:ease-in;}
}
@-webkit-keyframes bounce {
	from, to{margin-top:0; -webkit-animation-timing-function:ease-out;}
	50% {margin-top:5px; -webkit-animation-timing-function:ease-in;}
}

.rolling .swiper {position:relative;}
.rolling .swiper button {position:absolute; top:42.5%; z-index:150; width:4.53%; background:transparent;}
.rolling .swiper .prev {left:8%;}
.rolling .swiper .next {right:8%;}

.form {position:relative;}
.form legend {visibility:hidden; width:0; height:0;}
.form .field {overflow:hidden; position:absolute; top:33%; left:0; width:100%; padding-left:16%;}
.form .field .itext {overflow:hidden; float:left; position:relative; z-index:10; width:17%; margin-right:2%;padding-bottom:17%;}
.form .field .itext input {position:absolute; top:0; left:0; width:100%; height:100%; border:0; border-radius:0; background-color:transparent; /*background-color:#000; opacity:0.3;*/ color:#2b2c29; font-size:2rem; font-weight:bold; line-height:1.3rem; text-align:center;}
.form .btnGet {position:absolute; bottom:9%; left:50%; width:72.96%; margin-left:-36.48%;}
.form .btnGet input {width:100%;}

.commentlist {min-width:320px; padding:2rem 0 3.5rem; background:#f0efe5 url(http://webimage.10x10.co.kr/eventIMG/2015/68550/bg_paper_ivory.png) repeat-y 50% 0; background-size:100% auto;}
.commentlist ul {overflow:hidden; padding:0 1.2rem 1rem;}
.commentlist ul li {float:left; position:relative; width:45%; margin:1rem 2.5% 0;}
.commentlist ul li div {position:absolute; top:0; left:0; width:100%; height:100%; padding:0.7rem 0.9rem;}
.commentlist ul li p {margin-top:1.3rem; color:#fff; font-size:1.2rem; font-weight:bold; line-height:1.5em; text-align:center;}
.commentlist ul li .no {display:inline-block; padding:0.2rem 0.6rem 0.08rem; border-radius:10px; font-size:1rem; line-height:1em;}
.commentlist ul li .id {position:absolute; right:0.9rem; bottom:1rem; color:#fff;  font-size:1.1rem; text-align:right; text-decoration:underline;}
.commentlist ul li .btnDel {position:absolute; top:0.7rem; right:0.5rem; width:1rem;}
.commentlist ul li.bgcolor1 {background:url(http://webimage.10x10.co.kr/eventIMG/2015/68550/bg_box_black.png) no-repeat 50% 0; background-size:100% auto;}
.commentlist ul li.bgcolor1 .no {background-color:#bd9760; color:#2b2c29;}
.commentlist ul li.bgcolor2 {background:url(http://webimage.10x10.co.kr/eventIMG/2015/68550/bg_box_brown.png) no-repeat 50% 0; background-size:100% auto;}
.commentlist ul li.bgcolor2 .no {background-color:#2b2c29; color:#bd9760;}

.book {position:relative;}
.book ul {position:absolute; top:0; left:50%; width:90%; margin-left:-45%;}
.book ul:after {content:' '; display:block; clear:both;}
.book ul li {position:relative; float:left; width:50%; margin-bottom:3.6%; padding:0 1.8%;}
.book ul li button {display:block; position:relative; width:100%; height:0; padding-bottom:140%; color:transparent; font-size:11px; line-height:11px; text-align:center;}
.book ul li span {position:absolute; top:0; left:0; width:96%; height:100%; background-color:black; opacity:0; filter:alpha(opacity=0); cursor:pointer;}
.book ul li button i {display:none; position:absolute; top:-3%; left:0; z-index:55; width:100%;}
.book ul li button i img {width:92%; margin:0 auto;}
.book ul li button.on i {display:block;}
.book ul li:nth-child(1) button i, .book ul li:nth-child(2) button i {top:-1.2%;}
.book ul li:nth-child(5) button i, .book ul li:nth-child(6) button i {top:-5%;}
.book .btnGet {position:absolute; bottom:9%; left:50%; width:72.96%; margin-left:-36.48%;}
.book .count {position:absolute; bottom:4%; left:0; width:100%; text-align:center;}
.book .count .letter1 img {width:1.35rem;}
.book .count .letter2 img {width:10.7rem;}
.book .count b {color:#bd9760; font-size:1.2rem; line-height:1.6em;}

.noti {padding:2.5rem 2rem; background:#e5e5e5 url(http://webimage.10x10.co.kr/eventIMG/2015/68550/bg_paper_grey.png) repeat-y 50% 0; background-size:100% auto;}
.noti h3 {color:#3f3f3f; font-size:1.4rem;}
.noti h3 strong {border-bottom:2px solid #3f3f3f;}
.noti ul {margin-top:1.6rem;}
.noti ul li {position:relative; padding-left:1rem; color:#7b7b7b; font-size:1.1rem; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:0.6rem; left:0; width:4px; height:4px; border-radius:50%; background-color:#7b7b7b;}

.bnr a {display:block; margin-top:7%;}
</style>
<script type="text/javascript">
$(function(){
	<% if pagereload<>"" then %>
		//pagedown();
		setTimeout("pagedown()",300);
	<% else %>
		setTimeout("pagup()",300);
	<% end if %>
});

function pagup(){
	window.$('html,body').animate({scrollTop:$(".mEvt68254").offset().top}, 0);
}

function pagedown(){
	//document.getElementById('commentlist').scrollIntoView();
	window.$('html,body').animate({scrollTop:$("#commentevt").offset().top}, 0);
}
	
$(function(){
	/* tab */
	/* tab */
	$("#tabcontainer .tabcont").hide();
	$("#tabcontainer .tabcont:first").show();
	$("#navigator li a").click(function(){
		var thisCont = $(this).attr("href");
		$("#tabcontainer").find(".tabcont").hide();
		$("#tabcontainer").find(thisCont).show();
		return false;
	});

	$("#navigator li.nav2 a").one("click",function(){
		rolling2();
	});

	/* swiper */
	mySwiper1 = new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		autoplay:3000,
		speed:500,
		autoplayDisableOnInteraction:false,
		nextButton:'.rolling1 .next',
		prevButton:'.rolling1 .prev',
		effect:'fade'
	});
	$('.rolling1 .prev').on('click', function(e){
		e.preventDefault()
		mySwiper1.swipePrev()
	});
	$('.rolling1 .next').on('click', function(e){
		e.preventDefault()
		mySwiper1.swipeNext()
	});

	function rolling2() {
		mySwiper2 = new Swiper('.swiper2',{
			loop:true,
			resizeReInit:true,
			calculateHeight:true,
			autoplay:3000,
			speed:500,
			autoplayDisableOnInteraction:false,
			nextButton:'.rolling2 .next',
			prevButton:'.rolling2 .prev',
			effect:'fade'
		});
		$('.rolling2 .prev').on('click', function(e){
			e.preventDefault()
			mySwiper2.swipePrev()
		});
		$('.rolling2 .next').on('click', function(e){
			e.preventDefault()
			mySwiper2.swipeNext()
		});
	}
	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			mySwiper1.reInit();
			mySwiper2.reInit();
				clearInterval(oTm);
		}, 500);
	});

	/* book select */
	$("#book ul li:first button").addClass("on");
	$("#book ul li button").click(function(){
		$("#book ul li button").removeClass("on");
		if ( $(this).hasClass("on")) {
			$(this).removeClass("on");
		} else {
			$(this).addClass("on");
		}
	});
});


function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}


//코멘트 응모
function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2016-01-11" and left(currenttime,10)<"2016-01-25" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>2 then %>
				alert("한 ID당 최대 3번까지 참여할 수 있습니다.");
				return false;
			<% else %>
				if (frm.txtcomm1.value == ''){
					alert("빈칸을 채워주세요.");
					frm.txtcomm1.focus();
					return false;
				}
				if (frm.txtcomm2.value == ''){
					alert("빈칸을 채워주세요.");
					frm.txtcomm2.focus();
					return false;
				}
				if (frm.txtcomm3.value == ''){
					alert("빈칸을 채워주세요.");
					frm.txtcomm3.focus();
					return false;
				}
				if (frm.txtcomm4.value == ''){
					alert("빈칸을 채워주세요.");
					frm.txtcomm4.focus();
					return false;
				}
				frm.txtcomm.value = frm.txtcomm1.value+frm.txtcomm2.value+frm.txtcomm3.value+frm.txtcomm4.value
				frm.action = "/event/lib/doEventComment.asp";
				frm.submit();
			<% end if %>
		<% end if %>
	<% Else %>
		<% If isapp="1" Then %>
			parent.calllogin();
			return;
		<% else %>
			parent.jsevtlogin();
			return;
		<% End If %>
	<% End IF %>
}

function jsDelComment(cidx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmdelcom.Cidx.value = cidx;
   		document.frmdelcom.submit();
	}
}

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		<% If isapp="1" Then %>
			parent.calllogin();
			return;
		<% else %>
			parent.jsevtlogin();
			return;
		<% End If %>
	}
}

//책 선택 응모
function jsevtchk(){
	<% if Date() < "2016-01-11" or Date() > "2016-01-24" then %>
		alert('이벤트 응모 기간이 아닙니다.');
		return;
	<% else %>
		//책 선택
		var selectvaluebook
		if($("#cont1").attr("class") == "on"){
			selectvaluebook = "1";
		}else if ($("#cont2").attr("class") == "on"){
			selectvaluebook = "2";
		}else if ($("#cont3").attr("class") == "on"){
			selectvaluebook = "3";
		}else if ($("#cont4").attr("class") == "on"){
			selectvaluebook = "4";
		}else if ($("#cont5").attr("class") == "on"){
			selectvaluebook = "5";
		}else if ($("#cont6").attr("class") == "on"){
			selectvaluebook = "6";
		}else{
			selectvaluebook = "1";
		}

		var result;
			$.ajax({
				type:"GET",
				url:"/event/etc/doeventsubscript/doEventSubscript68550.asp",
				data: "mode=book&selectvaluebook="+selectvaluebook,
				dataType: "text",
				async:false,
				cache:false,
				success : function(Data){
					result = jQuery.parseJSON(Data);
					if (result.resultcode=="11")
					{
						$("#allcount").text(<%= vTotalCount+1 %>);
						alert("응모가 완료되었습니다.");
						return;
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
						alert("이미 응모 하셨습니다.");
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
	<div class="mEvt68550">
		<article>
			<div id="tabcontainer" class="tabcontainer">
				<%'' 댓글이 기대되는 설 %>
				<div id="tabcont1" class="tabcont">
					<div class="topic">
						<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/tit_30_years_old.png" alt="서른의 설" /></h2>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/txt_good_time_01_v1.png" alt="명절은 즐거워야 한다 나이가 들 수록 즐거워야 한다" /></p>
						<ul id="navigator" class="navigator">
							<li class="nav1"><a href="#tabcont1"><span></span>댓글이 기대되는 설</a>
							</li>
							<li class="nav2"><a href="#tabcont2"><span></span>심심하지 않은 설<i><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/img_arrow.png" alt="" /></i></a></li>
						</ul>
					</div>

					<div class="rolling rolling1">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/txt_leave_msg.png" alt="여러분의 설은 어떤 모습인가요? 여러분이 경험한 또는 상상하는 서른의 설을 남겨주세요." /></p>
						<div class="swiper">
							<div class="swiper-container swiper1">
								<div class="swiper-wrapper">
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/img_slide_01_01.png" alt="어이구 졸리다" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/img_slide_01_02.png" alt="직장 없는데요 네 일해야죠 일 해야되는데 일하는게 너무 싫어요 예 그러니까요" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/img_slide_01_03.png" alt="지금도 충분히 수고 있지만 좀 더 완벽하고 체계적으로 쉬고 싶다" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/img_slide_01_04.png" alt="으휴 다음달 결혼식 세개잖아 젠장" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/img_slide_01_05.png" alt="아 생각하는 거도 귀찮다" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/img_slide_01_06.png" alt="자매 나를 왜 낳았어? 음 그냥 한번 살아보라고" /></div>
								</div>
							</div>
							<button type="button" class="prev"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/btn_prev.png" alt="이전" /></button>
							<button type="button" class="next"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/btn_next.png" alt="다음" /></button>
						</div>

						<!-- for dev msg : 링크 -->
						<div class="btnPreview"><a href="/culturestation/culturestation_event.asp?evt_code=3244"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/btn_preview.png" alt="작가 이랑의 내가 30代가 됐다 미리보기" /></a></div>
					</div>

					<div class="form">
						<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
						<input type="hidden" name="mode" value="add">
						<input type="hidden" name="pagereload" value="ON">
						<input type="hidden" name="iCC" value="1">
						<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
						<input type="hidden" name="eventid" value="<%= eCode %>">
						<input type="hidden" name="linkevt" value="<%= eCode %>">
						<input type="hidden" name="blnB" value="<%= blnBlogURL %>">
						<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
						<input type="hidden" name="txtcomm">
						<input type="hidden" name="gubunval">
						<input type="hidden" name="isApp" value="<%= isApp %>">	
							<fieldset>
							<legend>빈칸을 채워주세요</legend>
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/txt_question.png" alt="내 서른의 설날은 땡땡땡땡 다" /></p>
								<div class="field">
									<span class="itext"><input type="text" name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" maxlength="1" title="첫번째 글자 입력" /></span>
									<span class="itext"><input type="text" name="txtcomm2" id="txtcomm2" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" maxlength="1" title="두번째 글자 입력" /></span>
									<span class="itext"><input type="text" name="txtcomm3" id="txtcomm3" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" maxlength="1" title="세번째 글자 입력" /></span>
									<span class="itext"><input type="text" name="txtcomm4" id="txtcomm4" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" maxlength="1" title="네번째 글자 입력" /></span>
								</div>
								<div class="btnGet"><input type="image" onclick="jsSubmitComment(document.frmcom); return false;" src="http://webimage.10x10.co.kr/eventIMG/2015/68550/btn_submit.png" alt="응모하기" /></div>
							</fieldset>
						</form>
						<form name="frmdelcom" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
						<input type="hidden" name="mode" value="del">
						<input type="hidden" name="pagereload" value="ON">
						<input type="hidden" name="Cidx" value="">
						<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
						<input type="hidden" name="eventid" value="<%= eCode %>">
						<input type="hidden" name="linkevt" value="<%= eCode %>">
						<input type="hidden" name="isApp" value="<%= isApp %>">
						</form>
					</div>

					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/txt_gift.jpg" alt="리리스팩토리 원피스 한복과 설날기념 저렴이 앞치마를 각각 5분, 100분께 드립니다." /></p>

					<% IF isArray(arrCList) THEN %>
					<div class="commentlist" id="commentevt">
						<ul>
						<% For intCLoop = 0 To UBound(arrCList,2) %>
						<% if intCLoop = 0 or intCLoop = 3 or intCLoop = 4 or intCLoop = 7 then classboxcol="bgcolor1" else classboxcol="bgcolor2" end if %>
							<!-- for dev msg : 1페이지당 6개씩 보여주세요 -->
							<li class="<%= classboxcol %>">
								<div>
									<span class="no">NO.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1))%></span>
									<p>내 서른의 설날은<br /> <%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%>다.</p>
									<span class="id"><%=printUserId(arrCList(2,intCLoop),2,"*")%></span>
									<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
										<button type="button" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;" class="btnDel"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/btn_delete.png" alt="작성한글 삭제하기" /></button>
									<% end if %>
								</div>
								<span><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/bg_box_white.png" alt="" /></span>
							</li>
						<% next %>
						</ul>

						<%''  paging %>
						<%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
					</div>
					<% end if %>

					<div class="noti">
						<h3><strong>이벤트 유의사항</strong></h3>
						<ul>
							<li>텐바이텐 고객 대상 이벤트 입니다.</li>
							<li>댓글은 총 3번까지 참여할 수 있습니다.</li>
							<li>30대 이하 또는 그 이상도 얼마든지 참여하실 수 있습니다.</li>
							<li>당첨자 발표는 2016년 1월 21일 목요일입니다.</li>
							<li>향후 경품지급을 위해 개인정보를 요청할 수 있습니다.</li>
							<li>부적절한 댓글은 관리자에 의해 자동 삭제됩니다.</li>
						</ul>
					</div>
				</div>

				<%'' 심심하지 않은 설 %>
				<div id="tabcont2" class="tabcont">
					<div class="topic">
						<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/tit_30_years_old.png" alt="서른의 설" /></h2>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/txt_good_time_02_v1.png" alt="명절은 즐거워야 한다 나이가 들 수록 즐거워야 한다" /></p>
						<ul id="navigator" class="navigator">
							<li class="nav1"><a href="#tabcont1"><span></span>댓글이 기대되는 설<i><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/img_arrow.png" alt="" /></i></a>
							</li>
							<li class="nav2"><a href="#tabcont2"><span></span>심심하지 않은 설</a></li>
						</ul>
					</div>

					<div class="rolling rolling2">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/txt_book.png" alt="설에는 마음의 양식도 가득 쌓으세요. 읽고 싶은 책을 선택하시면 총 100분께 선물로 드립니다." /></p>
						<div class="swiper">
							<div class="swiper-container swiper2">
								<div class="swiper-wrapper">
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/img_slide_02_01.png" alt="내가 30代가 됐다" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/img_slide_02_02.png" alt="뜻밖의 위로" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/img_slide_02_03.png" alt="사랑이 아니면 아무것도 아닌 것" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/img_slide_02_04.png" alt="너에게 하고 싶은 말" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/img_slide_02_05.png" alt="마음의 눈에만 보이는 것들" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/img_slide_02_06.png" alt="지혜로운 생활" /></div>
								</div>
							</div>
							<button type="button" class="prev"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/btn_prev.png" alt="이전" /></button>
							<button type="button" class="next"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/btn_next.png" alt="다음" /></button>
						</div>
					</div>

					<div id="book" class="book">
						<ul>
							<li>
								<button type="button" id="cont1"><span></span>작가 이랑의 내가 30代가 됐다
								<i><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/btn_check.png" alt="" /></i></button>
							</li>
							<li>
								<button type="button" id="cont2"><span></span>작가 박정은의 뜻밖의 위로
								<i><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/btn_check.png" alt="" /></i></button>
							</li>
							<li>
								<button type="button" id="cont3"><span></span>작가 송정림의 사랑이 아니면 아무것도 아닌 것
								<i><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/btn_check.png" alt="" /></i></button>
							</li>
							<li>
								<button type="button" id="cont4"><span></span>작가 김수민의 너에게 하고 싶은 말
								<i><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/btn_check.png" alt="" /></i></button>
							</li>
							<li>
								<button type="button" id="cont5"><span></span>작가 정여울의 마음의 눈에만 보이는 것들
								<i><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/btn_check.png" alt="" /></i></button>
							</li>
							<li>
								<button type="button" id="cont6"><span></span>작가 오지혜의 지혜로운 생활
								<i><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/btn_check.png" alt="" /></i></button>
							</li>
						</ul>
						<button type="button" class="btnGet" onclick="jsevtchk(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/btn_submit.png" alt="응모하기" /></button>
						
						<%''  for dev msg : 응모자수 카운트 %>
						<p class="count">
							<span class="letter1"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/txt_count_01.png" alt="총" /></span>
							<b id="allcount"><%= vTotalCount %></b>
							<span class="letter2"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/txt_count_02.png" alt="명이 참여 중입니다." /></span>
						</p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/img_item_book_v2.jpg" alt="" />
					</div>

					<div class="noti">
						<h3><strong>이벤트 유의사항</strong></h3>
						<ul>
							<li>텐바이텐 고객 대상 이벤트 입니다.</li>
							<li>30대 이하 또는 그 이상도 얼마든지 참여하실 수 있습니다.</li>
							<li>당첨자 발표는 2016년 1월 21일 목요일입니다.</li>
							<li>향후 경품지급을 위해 개인정보를 요청할 수 있습니다.</li>
						</ul>
					</div>
				</div>
			</div>

			<div class="bnr">
				<a href="eventmain.asp?eventid=68524"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/img_bnr_01.jpg" alt="방방곡곡 야무진 설선물" /></a>
				<a href="eventmain.asp?eventid=68570"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68550/img_bnr_02.jpg" alt="서른까지 살아보니 좀 살만 합디까?" /></a>
			</div>
		</article>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->