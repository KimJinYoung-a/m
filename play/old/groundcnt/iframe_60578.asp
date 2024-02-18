<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<%
'########################################################
' PLAY #18 PLATE
' 2015-03-17 이종화 작성
'########################################################
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  21506
Else
	eCode   =  60578
End If

dim com_egCode, bidx
	Dim cEComment
	Dim iCTotCnt, arrCList,intCLoop, iSelTotCnt
	Dim iCPageSize, iCCurrpage
	Dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	Dim timeTern, totComCnt

	'파라미터값 받기 & 기본 변수 값 세팅
	iCCurrpage = requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	com_egCode = requestCheckVar(Request("eGC"),1)	

	IF iCCurrpage = "" THEN iCCurrpage = 1
	IF iCTotCnt = "" THEN iCTotCnt = -1

	'// 그룹번호 랜덤으로 지정

	iCPageSize = 2		'한 페이지의 보여지는 열의 수
	iCPerCnt = 4		'보여지는 페이지 간격

	'선택범위 리플개수 접수
	set cEComment = new ClsEvtComment

	cEComment.FECode 		= eCode
	cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iSelTotCnt = cEComment.FTotCnt '리스트 총 갯수
	set cEComment = nothing

	'코멘트 데이터 가져오기
	set cEComment = new ClsEvtComment

	cEComment.FECode 		= eCode
	'cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
	set cEComment = nothing

	iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
	IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1
%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.app {display:none;}
.mPlay20150323 {background-color:#fff;}
.intro {padding-bottom:10%; background-color:#f0efed;}
.intro .btnwrap {width:81.25%; margin:0 auto;}
.intro .btnwrap a {display:block; margin-bottom:1.2%;}
.rolling {background-color:#f0efed;}
.swiper {position:relative; width:320px; margin:0 auto;}
.swiper .swiper-container {overflow:hidden; position:relative; width:320px;}
.swiper .swiper-wrapper {overflow:hidden;}
.swiper .swiper .swiper-slide {float:left;}
.pagination {position:absolute; bottom:25px; left:0; width:100%;}
.pagination .swiper-pagination-switch {width:10px; height:10px; margin:0 5px; background-color:transparent; border:3px solid #fff;}
.pagination .swiper-active-switch {border-color:#db2424;}
.field {padding:9.4%; background-color:#f0f0f0; background-image:url(http://webimage.10x10.co.kr/playmo/ground/20150323/bg_car.png); background-repeat:no-repeat; background-position:0 23%; background-size:100% auto;}
.field legend {visibility:hidden; width:0; height:0;}
.field label {display:inline-block; width:55%;}
.field input[type=text] {height:32px; margin-top:3%; margin-bottom:5%; border:0; border-radius:0; color:#474747; font-size:12px; }
.who input[type=text] {width:68%;}
.person label {display:block;}
.person input[type=text] {width:22%;}
.person input[type=text] + img {width:32px; margin-top:2.5%;}
.field textarea {width:100%; height:110px; margin-top:3%; padding:15px; border:0; border-radius:0; color:#474747; font-size:12px; line-height:1.5em;}
.field .btnsubmit {margin-top:3%;}
.field .btnsubmit input {width:100%;}

.commentlistWrap {padding-bottom:40px;}
.commentlist {padding:5% 0; background-color:#fff;}
.commentlist .box {position:relative; width:260px; height:205px; margin:20px auto 0; background:url(http://webimage.10x10.co.kr/playmo/ground/20150323/bg_comment.png) no-repeat 50% 0; background-size:260px 205px;}
.commentlist .box .no {position:absolute; top:33px; left:32px; width:36px; height:30px; color:#2d2d2d; font-size:10px;}
.commentlist .box .with {overflow:hidden; position:absolute; top:85px; left:20px; width:48px; height:70px; color:#7f4f2e; font-size:10px; line-height:1.25em;}
.commentlist .box .word {width:132px; margin-left:100px; padding-top:65px;}
.commentlist .box .word .id {position:relative; color:#a0a0a0; font-size:10px; line-height:1.25em;}
.commentlist .box .word .id em {color:#c28842;}
.commentlist .box .word .id img {width:5px; vertical-align:middle;}
.commentlist .box .word .id span {position:absolute; top:0; right:0;}
.commentlist .box .word p {overflow:auto; -webkit-overflow-scrolling:touch; width:132px; height:90px; margin-top:12px; padding:0 5px 5px 0; color:#474747; font-size:11px; line-height:1.5em;}
.commentlist .box .btndel {position:absolute; top:0; right:0; width:15px; height:15px; background:url(http://webimage.10x10.co.kr/playmo/ground/20150323/btn_del.png) no-repeat 50% 0; background-size:100% 100%; text-indent:-999em;}
@media all and (min-width:360px){
	.swiper {width:360px;}
	.swiper .swiper-container {width:360px;}
	.rolling .gif {margin-top:0;}
	.commentlist .box {width:300px; height:236px; background-size:300px 236px;}
	.commentlist .box .no {position:absolute; top:36px; left:34px; width:36px; height:30px; font-size:11px;}
	.commentlist .box .with {top:100px; left:25px; width:55px; height:70px; font-size:11px;}
	.commentlist .box .word {width:150px; margin-left:120px; padding-top:75px;}
	.commentlist .box .word p {width:150px; height:102px; margin-top:15px;}
}
@media all and (min-width:480px){
	.swiper {width:480px;}
	.swiper .swiper-container {width:480px;}
	.commentlist .box {width:300px; height:236px; background-size:300px 236px;}
	.commentlist .box .no {position:absolute; top:36px; left:34px; width:36px; height:30px; font-size:11px;}
	.commentlist .box .with {top:100px; left:25px; width:55px; height:70px; font-size:11px;}
	.commentlist .box .word {width:150px; margin-left:120px; padding-top:75px;}
	.commentlist .box .word p {width:150px; height:102px; margin-top:15px;}
}
@media all and (min-width:600px){
	.commentlist .box {width:435px; height:307px; margin-top:35px; background-size:435px 307px;}
	.commentlist .box .no {top:50px; left:48px; width:54px; height:45px; font-size:15px;}
	.commentlist .box .with {top:127px; left:35px; width:72px; height:105px; font-size:15px;}
	.commentlist .box .word {width:224px; margin-left:167px; padding-top:97px;}
	.commentlist .box .word .id {font-size:15px;}
	.commentlist .box .word .id img {width:7px;}
	.commentlist .box .word p {width:224px; height:135px; margin-top:18px; padding:0 7px 7px 0; font-size:16px;}
	.commentlist .box .btndel {width:25px; height:25px;}
}
@media all and (min-width:768px){
	.field input[type=text] {height:48px; font-size:16px;}
	.person input[type=text] + img {width:48px;}
	.field textarea {height:165px; font-size:16px;}
	.rolling .gif {margin-top:10%;}
	.pagination .swiper-pagination-switch {width:15px; height:15px; margin:0 7px;}
}
</style>
<script type="text/javascript">
<!--
 	function jsGoComPage(iP){
		document.frmcom.iCC.value = iP;
		document.frmcom.iCTot.value = "<%=iCTotCnt%>";
		document.frmcom.submit();
	}

	function jsSubmitComment(frm){
		<% if Not(IsUserLoginOK) then %>
			<% If isApp="1" or isApp="2" Then %>
			parent.calllogin();
			return false;
			<% else %>
			parent.jsevtlogin();
			return;
			<% end if %>			
		<% end if %>


	   if(!frm.qtext1.value){
			alert("아침을 함께 하고픈 사람을 적어주세요");
			document.frmcom.qtext1.value="";
			frm.qtext1.focus();
			return false;
	   }
	   
	   if(!frm.qtext2.value){
			alert("인원을 적어주세요");
			document.frmcom.qtext2.value="";
			frm.qtext2.focus();
			return false;
	   }

		if(!frm.qtext3.value || frm.qtext3.value == "150자 이내로 적어주세요"){
			alert("내용을 입력해주세요");
			document.frmcom.qtext3.value="";
			frm.qtext3.focus();
			return false;
		}

		if (GetByteLength(frm.qtext3.value) > 151){
			alert("제한길이를 초과하였습니다. 150자 까지 작성 가능합니다.");
			frm.qtext3.focus();
			return false;
		}

	   frm.action = "/play/groundcnt/doEventSubscript60578.asp";
	   return true;
	}

	//'글자수 제한
	function checkLength(comment) {
		if (comment.value.length > 151 ) {
			comment.blur();
			comment.value = comment.value.substring(0, 150);
			alert('150자 이내로 입력');
			comment.focus();
			return false;
		}
	}

	function jsDelComment(cidx)	{
		if(confirm("삭제하시겠습니까?")){
			document.frmdelcom.Cidx.value = cidx;
	   		document.frmdelcom.submit();
		}
	}

	function jsChklogin11(blnLogin)
	{
		if (blnLogin == "True"){
			document.frmcom.qtext1.value="";
			return true;
		} else {
			jsChklogin('<%=IsUserLoginOK%>');
		}

		return false;
	}

	function jsChklogin22(blnLogin)
	{
		if (blnLogin == "True"){
			document.frmcom.qtext2.value="";
			return true;
		} else {
			jsChklogin('<%=IsUserLoginOK%>');
		}

		return false;
	}

	function jsChklogin33(blnLogin)
	{
		if (blnLogin == "True"){
			if(document.frmcom.qtext3.value =="150자 이내로 적어주세요"){
				document.frmcom.qtext3.value="";
			}
			return true;
		} else {
			jsChklogin('<%=IsUserLoginOK%>');
		}

		return false;
	}
//-->
</script>
</head>
<body>
<!-- iframe -->
<div class="mPlay20150323">
	<div class="section topic">
		<h1><img src="http://webimage.10x10.co.kr/playmo/ground/20150323/tit_good_morning.png" alt="행복한 아침을 열어줄! GOOD MORNING PLATE" /></h1>
		<% If isApp="1" Then %>
		<a href="" onclick="parent.fnAPPpopupProduct(1238040);return false;" target="_top" class="app"><img src="http://webimage.10x10.co.kr/playmo/ground/20150323/img_plate_main.jpg" alt="" /></a>
		<% Else %>
		<a href="/category/category_itemprd.asp?itemid=1238040" target="_top" class="mo"><img src="http://webimage.10x10.co.kr/playmo/ground/20150323/img_plate_main.jpg" alt="" /></a>
		<% End If %>
		<img src="http://webimage.10x10.co.kr/playmo/ground/20150323/img_good_morning.jpg" alt="" />
	</div>

	<div class="section breakfast">
		<p>
			<img src="http://webimage.10x10.co.kr/playmo/ground/20150323/txt_have_breakfast.gif" alt="아침, 드셨어요?" />
			<img src="http://webimage.10x10.co.kr/playmo/ground/20150323/img_have_breakfast.jpg" alt="" />
		</p>
		
	</div>

	<div class="section intro">
		<% If isApp="1" Then %>
		<h2 class="app"><a href="" onclick="parent.fnAPPpopupProduct(1238040);return false;" target="_top"><img src="http://webimage.10x10.co.kr/playmo/ground/20150323/tit_good_morning_plate.jpg" alt="GOOD MORNING PLATE" /></a></h2>
		<% Else %>
		<h2 class="mo"><a href="/category/category_itemprd.asp?itemid=1238040" target="_top"><img src="http://webimage.10x10.co.kr/playmo/ground/20150323/tit_good_morning_plate.jpg" alt="GOOD MORNING PLATE" /></a></h2>
		<% End If %>
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150323/txt_good_morning_plate.png" alt="텐바이텐 PLAY는 당신의 아침이 더욱 소중해 지기를 바라는 마음에 굿모닝 플레이트 세트를 선보입니다. 든든한 아침을 접시 안에 담고, 건강에 좋은 음료를 유리잔에 담고 이 트레이에 담아 기분 좋은 아침을 시작하세요. * Good morning PLATE Set는 원형 접시, 유리컵, 그리고 트레이로 구성되어 있습니다" /></p>
		<div class="btnwrap">
			<% If isApp="1" Then %>
			<a href="" onclick="parent.fnAPPpopupProduct(1238040);return false;" class="app"><img src="http://webimage.10x10.co.kr/playmo/ground/20150323/btn_get.png" alt="Good Morning PLATE 구매하러 가기" /></a><br />
			<% Else %>
			<a href="/category/category_itemPrd.asp?itemid=1238040" target="_top" class="mo"><img src="http://webimage.10x10.co.kr/playmo/ground/20150323/btn_get.png" alt="Good Morning PLATE 구매하러 가기" /></a><br />
			<% End If %>
			<a href="#commentwrite" class="move"><img src="http://webimage.10x10.co.kr/playmo/ground/20150323/btn_want.png" alt="아침을 배달해드립니다 신청하러 가기" /></a>
		</div>
	</div>

	<div class="section rolling">
		<div class="swiper">
			<div class="swiper-container swiper1">
				<div class="swiper-wrapper">

					<div class="swiper-slide"><% If isApp="1" Then %><a href="" onclick="parent.fnAPPpopupProduct(1238040);return false;"><% Else %><a href="/category/category_itemPrd.asp?itemid=1238040" target="_top"><% End If %><img src="http://webimage.10x10.co.kr/playmo/ground/20150323/img_slide_01.jpg" alt="" /></a></div>
					<div class="swiper-slide"><% If isApp="1" Then %><a href="" onclick="parent.fnAPPpopupProduct(1238040);return false;"><% Else %><a href="/category/category_itemPrd.asp?itemid=1238040" target="_top"><% End If %><img src="http://webimage.10x10.co.kr/playmo/ground/20150323/img_slide_02.jpg" alt="" /></a></div>
					<div class="swiper-slide"><% If isApp="1" Then %><a href="" onclick="parent.fnAPPpopupProduct(1238040);return false;"><% Else %><a href="/category/category_itemPrd.asp?itemid=1238040" target="_top"><% End If %><img src="http://webimage.10x10.co.kr/playmo/ground/20150323/img_slide_03.jpg" alt="" /></a></div>
					<div class="swiper-slide"><% If isApp="1" Then %><a href="" onclick="parent.fnAPPpopupProduct(1238040);return false;"><% Else %><a href="/category/category_itemPrd.asp?itemid=1238040" target="_top"><% End If %><img src="http://webimage.10x10.co.kr/playmo/ground/20150323/img_slide_04.jpg" alt="" /></a></div>
				</div>
				<div class="pagination"></div>
			</div>
		</div>

		<div class="gif"><% If isApp="1" Then %><a href="" onclick="parent.fnAPPpopupProduct(1238040);return false;"><% Else %><a href="/shopping/category_prd.asp?itemid=1238040" target="_top"><% End If %><img src="http://webimage.10x10.co.kr/playmo/ground/20150323/img_animation.jpg" alt="" /></a></div>
	</div>

	<div id="commentwrite" class="commentwrite">
		<div class="hgroup">
			<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150323/tit_delivery.png" alt="GOOD MORNING PLATE 런칭 기념, 아침 산타 프로젝트! 텐바이텐이 아침을 배달해드립니다!" /></h2>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150323/txt_delivery.png" alt="아침을 함께 하고픈 사람들을 적고 아침을 신청하세요! 응모해 주신 분들중 3팀을 추첨해 맛있는 아침식사와 Good morning PLATE Set(1인 1 set)를 함께 배달해드립니다. 신청기간은 2015년 3월 23일부터 4월 5일까지며, 당첨자 발표는 2015년 4월 7일입니다." /></p>
		</div>

		<!-- comment write -->
		<div class="field">
			<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;" action="#commentlist">
			<input type="hidden" name="eventid" value="<%=eCode%>"/>
			<input type="hidden" name="bidx" value="<%=bidx%>"/>
			<input type="hidden" name="iCC" value="<%=iCCurrpage%>"/>
			<input type="hidden" name="iCTot" value=""/>
			<input type="hidden" name="mode" value="add"/>
			<input type="hidden" name="userid" value="<%=GetLoginUserID%>"/>
				<fieldset>
				<legend>아침 식사 신청하기</legend>
					<p class="who">
						<label for="labelwho"><img src="http://webimage.10x10.co.kr/playmo/ground/20150323/txt_who.png" alt="아침을 함께 하고픈 사람(들)은?" /></label>
						<input type="text" id="labelwho" value="" name="qtext1" onClick="jsChklogin11('<%=IsUserLoginOK%>');" maxlength="30"/>
					</p>
					<p class="person">
						<label for="labelperson"><img src="http://webimage.10x10.co.kr/playmo/ground/20150323/txt_no.png" alt="인원 (최대 5명)" /></label>
						<input type="text" id="labelperson" value="" name="qtext2" onClick="jsChklogin22('<%=IsUserLoginOK%>');" maxlength="1"/> <img src="http://webimage.10x10.co.kr/playmo/ground/20150323/txt_count.png" alt="명" />
					</p>
					<p class="reason"><label for="labelreason"><img src="http://webimage.10x10.co.kr/playmo/ground/20150323/txt_reason.png" alt="그 이유도 함께 들려주세요" /></label></p>
					<textarea id="labelreason" name="qtext3" onClick="jsChklogin33('<%=IsUserLoginOK%>');" onKeyUp="checkLength(this);">150자 이내로 적어주세요</textarea>
					<div class="btnsubmit"><input type="image" src="http://webimage.10x10.co.kr/playmo/ground/20150323/btn_submit.png" alt="아침 신청하기" /></div>
				</fieldset>
			</form>
			<form name="frmdelcom" method="post" action="/event/lib/comment_process.asp" style="margin:0px;">
			<input type="hidden" name="eventid" value="<%=eCode%>">
			<input type="hidden" name="bidx" value="<%=bidx%>">
			<input type="hidden" name="Cidx" value="">
			<input type="hidden" name="mode" value="del">
			<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
			</form>
		</div>
	</div>

	<!-- comment list -->
	<% IF isArray(arrCList) THEN %>
	<div class="commentlistWrap" id="commentlist">
		<div class="commentlist">
			<!-- for dev msg : <div class="box">...</div> 1페이지당 2개 보여주세요 -->
			<% For intCLoop = 0 To UBound(arrCList,2) %>
			<% 
					Dim opt1 , opt2 , opt3
					If arrCList(1,intCLoop) <> "" then
						opt1 = SplitValue(arrCList(1,intCLoop),"//",0)
						opt2 = SplitValue(arrCList(1,intCLoop),"//",1)
						opt3 = SplitValue(arrCList(1,intCLoop),"//",2)
					End If 
			%>
			<div class="box">
				<span class="no">no.<br /> <%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></span>
				<p class="with"><%=opt2%>명의 <%=opt1%></p>
				<div class="word">
					<div class="id">
						<em><%=printUserId(arrCList(2,intCLoop),2,"*")%> <% If arrCList(8,intCLoop) = "M"  then%><img src="http://webimage.10x10.co.kr/playmo/ground/20150323/ico_mobile.png" alt="모바일에서 작성" /><% End If %></em>
						<span><%=Left(arrCList(4,intCLoop),10)%></span>
					</div>
					<p><%=opt3%></p>
				</div>
				<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
				<button type="button" class="btndel" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>');return false;">삭제</button>
				<% end if %>
			</div>
			<% Next %>
		</div>

		<div class="paging">
			<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
		</div>
	</div>
	<% End If %>
</div>
<!--// iframe -->
<script type="text/javascript" src="/lib/js/jquery.swiper-2.1.min.js"></script>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		pagination:'.pagination',
		paginationClickable:true,
		speed:1000,
		autoplay:5000,
		autoplayDisableOnInteraction: true,
	});

	/* move to comment */
	$(".move").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top}, 500);
	});

	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
			$(".app").show();
			$(".mo").hide();
	}else{
			$(".app").hide();
			$(".mo").show();
	}
});
</script>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->