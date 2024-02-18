<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : Playing Thing Vol.17 운세자판기
' History : 2017-06-15 원승현 생성
'####################################################
Dim eCode , userid, vDIdx, myresultcnt, totalcnt, commentcount, jnum, pagereload, sqlStr, chkResultVal
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66343
Else
	eCode   =  78498
End If

vDIdx = request("didx")
totalcnt = 0
myresultcnt = 0
userid	= getencLoginUserid()
totalcnt = getevent_subscripttotalcount(eCode,"","","")

chkResultVal = ""

if userid <> "" then 
	myresultcnt = getevent_subscriptexistscount(eCode,userid,"","","")
end If

If userid <> "" then
	commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")
Else
	commentcount = 0
End If 

vDIdx = request("didx")

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop
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

iCPerCnt = 4		'보여지는 페이지 간격
'한 페이지의 보여지는 열의 수
if blnFull then
	iCPageSize = 3		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 3		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
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


sqlstr = "SELECT sub_opt3 FROM [db_event].[dbo].[tbl_event_subscript] WHERE  evt_code = '"& eCode &"' and userid= '"&userid&"' And convert(varchar(10), regdate, 120) = '"&Left(Now(), 10)&"'"
rsget.Open sqlstr, dbget, 1
	If Not(rsget.bof Or rsget.eof) Then
		chkResultVal = rsget("sub_opt3")
	Else
		chkResultVal = ""
	End If
rsget.close
%>
<style type="text/css">
.section {position:relative;}
.thingVol017 .pagination {position:absolute; left:0; bottom:3.8rem; width:100%; height:0.9rem; padding-top:0;}
.thingVol017 .pagination span {width:0.9rem; height:0.9rem; border:0.2rem solid #fff; margin:0 0.45rem; background:transparent;}
.thingVol017 .pagination span.swiper-active-switch {background:#fff;}

.thingVol017 button {background:transparent;}
.thingVol017 button.hover {position:relative;}
.thingVol017 button.hover span {position:absolute; left:0; top:0; opacity:0;}
.thingVol017 button.hover.active span {opacity:1;}

.intro span {position:absolute; left:50%; top:12.5%; width:43%; margin-left:-21.5%;}
.intro h2 {position:absolute; left:50%; top:22%; width:44%; margin-left:-22%; animation:flip 1s;}
.intro .btnDown {position:absolute; left:50%; bottom:6%; width:7.5%; margin-left:-3.75%; animation:bounce1 1s 50; -webkit-animation:bounce1 1s 50;}
.todayPick .selectWord {position:relative;}
.todayPick .selectWord ul {position:absolute; left:0; top:33%; width:100%; height:50.96%;}
.todayPick .selectWord li {position:absolute; cursor:pointer;}
.todayPick .selectWord li.pick1 {left:10.15%; top:0; z-index:10; width:33.12%;}
.todayPick .selectWord li.pick2 {right:9.3%; top:0; z-index:10; width:34.37%;}
.todayPick .selectWord li.pick3 {right:7.5%; top:49%; z-index:10; width:33.43%;}
.todayPick .selectWord li.pick4 {left:8%; top:46.7%; z-index:10; width:34.06%;}
.todayPick .selectWord li.pick5 {left:33%; top:21%; z-index:20; width:34.21%;}
.todayPick .selectWord li.pick6 {left:29%; top:65.7%; z-index:20; width:35.31%;}
.todayPick .selectWord li:after {content:''; display:none; position:absolute; left:0; top:0; width:100%; height:100%; background-repeat:no-repeat; background-position:0 0; background-size:100% 100%;}
.todayPick .selectWord li.on {z-index:40;}
.todayPick .selectWord li.on:after {display:block;}
.todayPick .selectWord li.pick1:after {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol017/m/img_pick_1_on.png);}
.todayPick .selectWord li.pick2:after {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol017/m/img_pick_2_on.png);}
.todayPick .selectWord li.pick3:after {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol017/m/img_pick_3_on.png);}
.todayPick .selectWord li.pick4:after {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol017/m/img_pick_4_on.png);}
.todayPick .selectWord li.pick5:after {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol017/m/img_pick_5_on.png);}
.todayPick .selectWord li.pick6:after {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol017/m/img_pick_6_on.png);}
.todayPick .selectWord .btnPick {position:absolute; left:50%; bottom:5.5%; width:58%; margin-left:-29%;}
.todayPick .result {display:none; position:relative;}
.todayPick .result h3 {position:absolute; left:0; top:9.2%; width:100%; text-align:center;}
.todayPick .result h3 span {display:inline-block; padding:0.5rem 0.5rem 0 0; font-size:2rem; line-height:2rem; color:#3e2f1f; font-weight:600;  vertical-align:middle;}
.todayPick .result h3 img {display:inline-block; width:13.5rem; vertical-align:middle;}
.todayPick .result div {display:none;}
.todayPick .result div.on {display:block;}
.todayPick .loading {display:none; position:fixed; left:0; top:0; z-index:1000; width:100%; height:100%; padding-top:50%; background:rgba(0,0,0,.6);}
.todayPick .loading p {position:relative; width:30%; margin:0 auto;}
.todayPick.loadOn .loading {display:block;}
.todayPick.loadOn .loading p:after {content:''; display:inline-block; position:absolute; left:50%; top:15.5%; width:26%; height:27%; margin-left:-12.5%;background:url(http://webimage.10x10.co.kr/playing/thing/vol017/m/img_ball.png) 0 0 no-repeat; background-size:100% auto; animation:spin 1.5s 3;}

.howto button.btnHow {position:absolute; left:50%; bottom:15%; width:60%; margin-left:-30%;}
.howtoLayer {display:none; position:fixed; left:0; top:0; z-index:1000; width:100%; height:100%; padding-top:4rem; background:rgba(0,0,0,.6);}
.howtoLayer .btnClose {position:absolute; right:5%; top:1rem; width:9.375%;}
.howtoLayer .rolling {position:relative; width:90%; margin:0 auto;}
.howtoLayer .rolling .pagination {bottom:-2.4rem;}
.howtoLayer .rolling button {display:block; position:absolute; left:15%; bottom:5%; width:70%; height:15%; text-indent:-999em;}
.event1 {position:relative; padding-bottom:6.1rem; background-color:#40d6db;}
.event1 .swiper-container:before,.event1 .swiper-container:after {content:'';display:inline-block; position:absolute; top:0; width:11.5%; height:100%; z-index:10; background-color:rgba(0,0,0,.4);}
.event1 .swiper-container:before {left:0;}
.event1 .swiper-container:after {right:0;}
.event1 .swiper-slide {width:72%; padding:0 2.5%;}
.event1 .pagination {bottom:3.8rem;}
.event1 button {position:absolute; top:40%; width:12.5%; z-index:20;}
.event1 .btnPrev {left:0;}
.event1 .btnNext {right:0;}
.event2 {padding-bottom:4.3rem; background:#30cbd1;}
.event2 .commentWrite {overflow:hidden; width:90%; margin:0 auto; padding-bottom:2rem; border-radius:1.2rem; background-color:#fff;}
.event2 .commentWrite ul {margin:0 auto; padding:1.7rem 0 0.8rem 4%; background-color:#ebf8f9;}
.event2 .commentWrite ul:after {content:' '; display:block; clear:both;}
.event2 .commentWrite li {float:left; width:33.33333%; margin-right:-0.5rem;}
.event2 .commentWrite li label {display:block; position:relative;}
.event2 .commentWrite li label:after {content:''; display:none; position:absolute; left:0; top:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/playing/thing/vol017/m/ico_type_select.png) 0 0 no-repeat; background-size:100% 100%;}
.event2 .commentWrite li input[type=radio] {display:none;}
.event2 .commentWrite li input[type=radio]:checked + label:after {display:block;}
.event2 .commentWrite textarea {display:block; width:82%; height:11rem; line-height:2.7rem; margin:2.2rem auto 0; background:url(http://webimage.10x10.co.kr/playing/thing/vol017/m/bg_line.png) 0 0 repeat; background-size:auto 2.7rem; border:0;}
.event2 .commentWrite .btnSubmit {display:block; width:70%; margin:1.6rem auto 0;}
.event2 .commentList ul {padding:2.2rem 5.3% 0;}
.event2 .commentList li {position:relative; margin-top:1.8rem; font-size:1.1rem; background-repeat:no-repeat; background-position:0 0; background-size:100% 100%;}
.event2 .commentList li.bg01 {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol017/m/bg_cmt_type_1.png);}
.event2 .commentList li.bg02 {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol017/m/bg_cmt_type_2.png);}
.event2 .commentList li.bg03 {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol017/m/bg_cmt_type_3.png);}
.event2 .commentList li.bg04 {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol017/m/bg_cmt_type_4.png);}
.event2 .commentList li.bg05 {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol017/m/bg_cmt_type_5.png);}
.event2 .commentList li.bg06 {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol017/m/bg_cmt_type_6.png);}
.event2 .commentList li p {position:absolute; left:13%; top:22%; width:70%; height:50%; line-height:1.4;}
.event2 .commentList li span {position:absolute;}
.event2 .commentList li .writer {left:13%; bottom:12%;}
.event2 .commentList li .writer i {display:inline-block; width:0.85rem; height:1.25rem; margin-right:0.5rem; background:url(http://webimage.10x10.co.kr/playing/thing/vol017/m/ico_mobile.png) 0 0 no-repeat; background-size:100% 100%; text-indent:-999em; vertical-align:middle;}
.event2 .commentList li .no {right:18%; bottom:12%; color:#72abad;}
.event2 .commentList li .btnDel {display:block; position:absolute; right:6%; top:-5%; width:14%; background:transparent;}
.pagingV15a span {color:#0a575a;}
.pagingV15a .current {color:#fff;}
.pagingV15a .arrow a:after {background-position:-5.8rem -9.56rem;}
/*.event2 .paging {margin-top:2.5rem;}
.event2 .paging span {border:0; width:3rem; height:3rem; border-radius:50%; color:#e9f6f7;}
.event2 .paging span a {padding-top:0; font-size:1.2rem; line-height:3rem; color:#e9f6f7; font-weight:600 !important;}
.event2 .paging span.arrow {position:relative; background:none; color:#00666c;}
.event2 .paging span.arrow:after {content:''; display:inline-block; position:absolute; left:50%; top:50%; width:0; height:0; margin:-0.32rem 0 0 -0.3rem; border-style:solid;}
.event2 .paging span.prevBtn:after {border-width:0.4rem 0.5rem 0.4rem 0; border-color:transparent #00666c transparent transparent;}
.event2 .paging span.nextBtn:after {margin-left:-0.1rem; border-width:0.4rem 0 0.4rem 0.5rem; border-color:transparent transparent transparent #00666c;}
.event2 .paging span.current {background:#00666c;}
.event2 .paging span.current a {color:#fff;}*/

@keyframes bounce1 {
	from,to {transform:translateY(0);}
	50% {transform:translateY(5px);}
}
@keyframes spin {
	from {transform:rotate(0deg);} 
	to { transform:rotate(-360deg);}
}
@keyframes flip {
	from {transform: perspective(400px) rotate3d(1, 0, 0, 90deg); animation-timing-function: ease-in; opacity: 0;}
	40% {transform: perspective(400px) rotate3d(1, 0, 0, -20deg); opacity: 1;}
	60% {transform: perspective(400px) rotate3d(1, 0, 0, 20deg);}
	80% {transform: perspective(400px) rotate3d(1, 0, 0, -5deg);}
	to {transform: perspective(400px);}
}
</style>
<script type="text/javascript">
$(function(){
	$(".btnGo").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top},800);
	});

	mySwiper = new Swiper(".event1 .swiper-container",{
		loop:true,
		autoplay:2500,
		speed:900,
		slidesPerView:'auto',
		centeredSlides:true,
		pagination:".event1 .pagination",
		paginationClickable:true,
		prevButton:'.event1 .btnPrev',
		nextButton:'.event1 .btnNext'
	});
	function howtoSlide() {
		mySwiper2 = new Swiper(".howtoLayer .swiper-container",{
			speed:600,
			effect:'fade',
			pagination:".howtoLayer .pagination",
			paginationClickable:true,
			nextButton:'.howtoLayer .btnNext'
		});
	}
	$(".howtoLayer .btnClose").click(function(){
		$(".howtoLayer").hide();
	});

	$(".btnHow").click(function(){
		//window.parent.$('html,body').animate({scrollTop:$(".fortuneMachine").offset().top},700);
		$(".howtoLayer").fadeIn();
		howtoSlide();
		howtoSlide.slideTo(1);
	});

	$('button.hover').on({
		'touchstart':function (){
			$(this).addClass('active');
		},
		'touchend': function () {
			$(this).removeClass('active');
		}
	});

	<% if chkResultVal <> "" then %>
		$(".result").show();
	<% end if %>

	// 운세뽑기
	// 단어선택
	$(".selectWord li").click(function(){
		$(".selectWord li").removeClass("on");
		$(this).addClass("on");
	});
	// 뽑기 돌리기 클릭
	$('.selectWord .btnPick').click(function(){
		if ($(".selectWord .pick1").hasClass("on")) {
			$("#pickSelectVal").val('pickResultTxt1');
		}
		if ($(".selectWord .pick2").hasClass("on")) {
			$("#pickSelectVal").val('pickResultTxt2');
		}
		if ($(".selectWord .pick3").hasClass("on")) {
			$("#pickSelectVal").val('pickResultTxt3');
		}
		if ($(".selectWord .pick4").hasClass("on")) {
			$("#pickSelectVal").val('pickResultTxt4');
		}
		if ($(".selectWord .pick5").hasClass("on")) {
			$("#pickSelectVal").val('pickResultTxt5');
		}
		if ($(".selectWord .pick6").hasClass("on")) {
			$("#pickSelectVal").val('pickResultTxt6');
		}
	});

	<% if pagereload<>"" then %>
		//pagedown();
		setTimeout("pagedown()",500);
	<% end if %>

	$("#commentWrite li label").on("click", function(e){
		frmcom.spoint.value = $(this).attr("val");
	});
});

function jsplayingthingresult(){
	<% If IsUserLoginOK() Then %>
		$.ajax({
			type: "GET",
			url: "/playing/sub/doEventSubscript78498.asp",
			data: "mode=result&pickVal="+$("#pickSelectVal").val(),
			cache: false,
			success: function(str) {
				var str = str.replace("undefined","");
				var res = str.split("|");
				if (res[0]=="OK") {
					$(".result div").removeClass("on");
					$(".todayPick").addClass("loadOn");
					$(".todayPick .loading").delay(2000).fadeOut(300);
					setTimeout(function(){
						$(".result").show();
						window.parent.$('html,body').animate({scrollTop:$(".result").offset().top},500);
					},1800);
					$(".result ."+res[2]).addClass("on");
				} else {
					errorMsg = res[1].replace(">?n", "\n");
					alert(errorMsg );
					return false;
				}
			}
			,error: function(err) {
				console.log(err.responseText);
				alert("통신중 오류가 발생했습니다. 잠시 후 다시 시도해주세요..");
			}
		});
	<% else %>
		<% If isApp="1" or isApp="2" Then %>
		calllogin();
		return false;
		<% else %>
		jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
		return false;
		<% end if %>			
	<% end if %>
}

function thingSelectRound()
{
	<% if trim(chkResultVal)="" then %>
		<% If IsUserLoginOK() Then %>
			$.ajax({
				type: "GET",
				url: "/playing/sub/doEventSubscript78498.asp",
				data: "mode=evtchk",
				cache: false,
				success: function(str) {
					var str = str.replace("undefined","");
					var res = str.split("|");
					if (res[0]=="OK") {
						if (res[1]=="0")
						{
							setTimeout(function(){
								window.parent.$('html,body').animate({scrollTop:$(".pick .loading").offset().top+100},300);
							})
							$(".pick ul li").addClass("shake");
							$(".pick .loading").show();
							$(".pick .loading").delay(2000).fadeOut(100);
							setTimeout("jsplayingthingresult()", 400);
						}
						else
						{
							alert("하루에 하나만 볼 수 있습니다.\n내일 또 뽑아주세요!");
							return false;
						}

					} else {
						errorMsg = res[1].replace(">?n", "\n");
						alert(errorMsg );
						return false;
					}
				}
				,error: function(err) {
					console.log(err.responseText);
					alert("통신중 오류가 발생했습니다. 잠시 후 다시 시도해주세요..");
				}
			});
		<% else %>
			<% If isApp="1" or isApp="2" Then %>
			calllogin();
			return false;
			<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
			return false;
			<% end if %>			
		<% end if %>
	<% else %>
		alert("하루에 하나만 볼 수 있습니다.\n내일 또 뽑아주세요!");
		return false;
	<% end if %>
}


function pagedown(){
	window.$('html,body').animate({scrollTop:$(".commentList").offset().top}, 0);
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% if date() >="2017-06-15" and date() < "2017-07-04" then %>
			<% if commentcount>4 then %>
				alert("이벤트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
				if (!frm.spoint.value){
					alert('원하는 장르를 선택해 주세요.');
					return false;
				}
			
				if(!frm.txtcomm.value){
					alert("기대평을 남겨주세요!");
					document.frmcom.txtcomm.value="";
					frm.txtcomm.focus();
					return false;
				}

				if (GetByteLength(frm.txtcomm.value) > 160){
					alert("제한길이를 초과하였습니다. 80자 까지 작성 가능합니다.");
					frm.txtcomm.focus();
					return false;
				}
				frm.action = "/event/lib/doEventComment.asp";
				frm.submit();
			<% end if %>
		<% else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% end if %>
	<% Else %>
		<% If isApp="1" or isApp="2" Then %>
		calllogin();
		return false;
		<% else %>
		jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
		return false;
		<% end if %>			
	<% End IF %>
}

function jsDelComment(cidx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmactNew.Cidx.value = cidx;
   		document.frmactNew.submit();
	}
}

function jsChklogin22(blnLogin)
{
	if (blnLogin == "True"){
		return true;
	} else {
		<% If isApp="1" or isApp="2" Then %>
		calllogin();
		return false;
		<% else %>
		jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
		return false;
		<% end if %>			
	}
	return false;
}
</script>

<div class="thingVol017 fortuneMachine">
	<div class="section intro">
		<span><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/tit_my_lick.png" alt="이번달 나의 행운은?" /></span>
		<h2><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/tit_fortune_machine.png" alt="운세자판기" /></h2>
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/txt_intro.png" alt="어서오세요. PLAYing 운세 자판기에 오신걸 환영합니다. 원하는 단어를 선택하고 뽑으면 여러분의 행운의 메세지를 만날 수 있어요. 오늘의운세를 책잇아웃-!" /></p>
		<a href="#todayPick" class="btnGo btnDown"><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/btn_down.png" alt="" /></a>
	</div>

	<%' 오늘의 운세 자판기 %>
	<div id="todayPick" class="section todayPick">
		<%' 단어 선택 %>
		<form name="SelectRound" id="SelectRound" method="get">
			<input type="hidden" name="pickSelectVal" id="pickSelectVal" value="pickResultTxt1">
		</form>
		<div class="selectWord">
			<p><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/txt_today_luck.png" alt="오늘의 운세 자판기" /></p>
			<ul>
				<li class="pick1 <% If Trim(chkResultVal)="pickResultTxt1" Or Trim(chkResultVal)="" Then %> on<% End If %>"><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/img_pick_1.png" alt="감성" /></li>
				<li class="pick2 <% If Trim(chkResultVal)="pickResultTxt2" Then %> on<% End If %>"><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/img_pick_2.png" alt="위로" /></li>
				<li class="pick3 <% If Trim(chkResultVal)="pickResultTxt3" Then %> on<% End If %>"><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/img_pick_3.png" alt="열정" /></li>
				<li class="pick4 <% If Trim(chkResultVal)="pickResultTxt4" Then %> on<% End If %>"><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/img_pick_4.png" alt="생각" /></li>
				<li class="pick5 <% If Trim(chkResultVal)="pickResultTxt5" Then %> on<% End If %>"><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/img_pick_5.png" alt="목표" /></li>
				<li class="pick6 <% If Trim(chkResultVal)="pickResultTxt6" Then %> on<% End If %>"><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/img_pick_6.png" alt="기회" /></li>
			</ul>
			<button type="button" class="btnPick hover" onclick="thingSelectRound();return false;">
				<img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/btn_pick.png" alt="뽑기 돌리기" />
				<span><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/btn_pick_on.png" alt="" /></span>
			</button>
			<div class="loading">
				<p><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/txt_loading.png" alt="뽑는중" /></p>
			</div>
		</div>
		<%' 운세 결과 %>
		<div class="result">
			<h3><span><%=printUserId(userid,2,"*")%></span><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/txt_result.png" alt="님의 운세 결과" /></h3>
			<div class="pickResultTxt1 <% If Trim(chkResultVal)="pickResultTxt1" Then %>on<% End If %>""><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/txt_pick_result_1.png" alt="감성 결과" /></div>
			<div class="pickResultTxt2 <% If Trim(chkResultVal)="pickResultTxt2" Then %>on<% End If %>""><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/txt_pick_result_2.png" alt="위로 결과" /></div>
			<div class="pickResultTxt3 <% If Trim(chkResultVal)="pickResultTxt3" Then %>on<% End If %>""><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/txt_pick_result_3.png" alt="열정 결과" /></div>
			<div class="pickResultTxt4 <% If Trim(chkResultVal)="pickResultTxt4" Then %>on<% End If %>""><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/txt_pick_result_4.png" alt="생각 결과" /></div>
			<div class="pickResultTxt5 <% If Trim(chkResultVal)="pickResultTxt5" Then %>on<% End If %>""><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/txt_pick_result_5.png" alt="목표 결과" /></div>
			<div class="pickResultTxt6 <% If Trim(chkResultVal)="pickResultTxt6" Then %>on<% End If %>""><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/txt_pick_result_6.png" alt="기회 결과" /></div>
		</div>
	</div>
	<%'// 오늘의 운세 자판기 %>

	<%' 설렘자판기를 아시나요 %>
	<div class="section howto">
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/txt_luck_machine.png" alt="설렘자판기를 아시나요?" /></p>
		<button type="button" class="btnHow hover">
			<img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/btn_howto.png" alt="설렘자판기 사용법" />
			<span><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/btn_howto_on.png" alt="" /></span>
		</button>
	</div>
	<div class="howtoLayer">
		<button type="button" class="btnClose"><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/btn_layer_close.png" alt="닫기" /></button>
		<div class="rolling">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/txt_info_1.png" alt="" /><button type="button" class="btnNext">설렘자판기 이용방법</button></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/txt_info_2.png" alt="" /></div>
				</div>
			</div>
			<div class="pagination"></div>
		</div>
	</div>
	<%'// 설렘자판기를 아시나요 %>

	<%' event1 %>
	<div class="section event1">
		<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/tit_event1.png" alt="대학로 매장에서 설렘 자판기를 이용해보세요!" /></h3>
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/img_slide_3.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/img_slide_1.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/img_slide_2.jpg" alt="" /></div>
			</div>
			<button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/btn_prev.png" alt="" /></button>
			<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/btn_next.png" alt="" /></button>
		</div>
		<div class="pagination"></div>
	</div>
	<%'// event1 %>

	<%' event2 %>
	<div class="section event2">
		<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/tit_event2.png" alt="내가 원하는 장르를 선택하고 설렘자판기에 대한 간단한 기대평을 남겨주세요! 남겨주신 분들에게 추첨을 통해 30분에게 책 한 권과 책가방(에코백)을 집으로 배달해드립니다." /></h3>
		<%' 코멘트 작성 %>
		<div class="commentWrite" id="commentWrite">
			<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
			<input type="hidden" name="mode" value="add">
			<input type="hidden" name="pagereload" value="ON">
			<input type="hidden" name="iCC" value="1">
			<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
			<input type="hidden" name="eventid" value="<%= eCode %>">
			<input type="hidden" name="linkevt" value="<%= eCode %>">
			<input type="hidden" name="blnB" value="">
			<input type="hidden" name="returnurl" value="<%= appUrlPath %>/playing/view.asp?didx=<%=vDIdx%>&pagereload=ON">
			<input type="hidden" name="isApp" value="<%= isApp %>">	
			<input type="hidden" name="spoint"/>
			<ul>
				<li>
					<input type="radio" id="genre01" name="genre" />
					<label for="genre01" val="1"><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/btn_type_1.png" alt="" /></label>
				</li>
				<li>
					<input type="radio" id="genre02" name="genre" />
					<label for="genre02" val="2"><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/btn_type_2.png" alt="" /></label>
				</li>
				<li>
					<input type="radio" id="genre03" name="genre" />
					<label for="genre03" val="3"><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/btn_type_3.png" alt="" /></label>
				</li>
				<li>
					<input type="radio" id="genre04" name="genre" />
					<label for="genre04" val="4"><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/btn_type_4.png" alt="" /></label>
				</li>
				<li>
					<input type="radio" id="genre05" name="genre" />
					<label for="genre05" val="5"><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/btn_type_5.png" alt="" /></label>
				</li>
				<li>
					<input type="radio" id="genre06" name="genre" />
					<label for="genre06" val="6"><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/btn_type_6.png" alt="" /></label>
				</li>
			</ul>
			<textarea cols="20" rows="5" placeholder="80자 이내로 입력해주세요." id="txtcomm" name="txtcomm" onClick="jsChklogin22('<%=IsUserLoginOK%>');"></textarea>
			<button type="button" class="btnSubmit hover" onclick="jsSubmitComment(document.frmcom);return false;">
				<img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/btn_submit.png" alt="기대평 남기기" />
				<span><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/btn_submit_on.png" alt="" /></span>
			</button>
			</form>

			<form name="frmactNew" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
			<input type="hidden" name="mode" value="del">
			<input type="hidden" name="pagereload" value="ON">
			<input type="hidden" name="Cidx" value="">
			<input type="hidden" name="returnurl" value="<%= appUrlPath %>/playing/view.asp?didx=<%=vDIdx%>&pagereload=ON">
			<input type="hidden" name="eventid" value="<%= eCode %>">
			<input type="hidden" name="linkevt" value="<%= eCode %>">
			<input type="hidden" name="isApp" value="<%= isApp %>">
			</form>
		</div>
		<%' 코멘트 목록 / 3개씩 노출 %>
		<% IF isArray(arrCList) THEN %>
		<div class="commentList">
			<ul>
				<%' for dev msg : 선택한 카드에 따라 클래스 bg01 ~ bg6 %>
				<% For intCLoop = 0 To UBound(arrCList,2) %>
				<li class="bg<%=chkiif(arrCList(3,intCLoop)<10,"0","")%><%=arrCList(3,intCLoop)%>">
					<p><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></p>
					<span class="writer"><% If arrCList(8,intCLoop) <> "W" Then %><i>모바일에서 작성</i><% End If %><%=printUserId(arrCList(2,intCLoop),4,"*")%></span>
					<span class="no">no.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></span>
					<%' 내가 쓴 글일경우 %>
					<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
					<button type="button" class="btnDel" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/btn_del.png" alt="내 글 삭제하기" /></button>
					<% End If %>
					<div class="bg"><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/bg_cmt.png" alt="" /></div>
				</li>
				<% Next %>
			</ul>
			<div class="paging pagingV15a">
				<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
			</div>
		</div>
		<% End If %>
	</div>
	<%'// event2 %>

	<%' volume %>
	<div class="volume">
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol017/m/txt_vol017.png" alt="vol.017 오늘의 운세를 뽑듯, 책으로 운세를 뽑으세요!" /></p>
	</div>
</div>

<!-- #include virtual="/lib/db/dbclose.asp" -->