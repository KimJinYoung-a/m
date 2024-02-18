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
'#### 2014-05-23 이종화 작성 play_sub ###################
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  21257
Else
	eCode   =  54127
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

	iCPageSize = 4		'한 페이지의 보여지는 열의 수
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

	Dim rencolor
	 
	randomize

	rencolor=int(Rnd*4)+1

%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > PLAY #11 Bag_무인도로 가는 가방</title>
<style type="text/css">
.mEvt54107 {position:relative;}
.mEvt54107 img {vertical-align:top; width:100%;}
.mEvt54107 p {max-width:100%;}
.desertIsland .section, .desertIsland .section h3 {margin:0; padding:0;}
.desertIsland .sectionA {position:relative;}
.desertIsland .sectionA .topic {position:absolute; top:8%; left:0; width:100%;}
.desertIsland .sectionA .topic span {display:block; margin-top:2%;}
.desertIsland .sectionB {padding:30px 0 50px;}
.desertIsland .swiper {position:relative; width:480px; height:380px; margin:0 auto; text-align:center;}
.desertIsland .swiper .swiper-container {overflow:hidden; width:100%; height:380px;}
.desertIsland .swiper .swiper-slide {float:left;}
.desertIsland .swiper .swiper-slide a {display:block; width:100%;}
.desertIsland .swiper .swiper-slide img {width:100%; vertical-align:top;}
.desertIsland .swiper button {border:0; background:none;}
.desertIsland .swiper .btnArrow {display:block; position:absolute; top:50%; z-index:10; width:34px; height:34px; margin-top:-17px; background-repeat:no-repeat; background-position:0 0; background-size:34px auto; text-indent:-999em;}
.desertIsland .swiper .arrow-left {left:0; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/54128/btn_nav_prev.png);}
.desertIsland .swiper .arrow-right {right:0; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/54128/btn_nav_next.png);}
.desertIsland .swiper .pagination {position:absolute; bottom:-30px; left:0; width:100%;}
.desertIsland .swiper .pagination span {display:inline-block; position:relative; width:8px; height:8px; margin:0 4px; border-radius:12px; background:#d0d0d0;}
.desertIsland .swiper .pagination .swiper-active-switch {background:#000;}
@media all and (max-width:480px){
	.desertIsland .swiper {width:320px; height:253px;}
	.desertIsland .swiper .swiper-container {height:253px;}
}
.desertIsland .sectionC .item {padding:0 7.3% 5%; background-color:#f3f3f3;}
.desertIsland .sectionC .item legend {visibility:hidden; width:0; height:0; overflow:hidden; position:absolute; top:-1000%; line-height:0;}
.desertIsland .sectionC .item input[type=text] {display:block; width:100%; height:60px; margin-bottom:8px; border:1px solid #000; box-sizing:border-box; -moz-box-sizing:border-box; -webkit-box-sizing:border-box; color:#a3a3a3; font-size:15px; font-weight:bold; line-height:60px; text-align:center;}
@media all and (max-width:480px){
	.desertIsland .sectionC .item input[type=text] {height:40px; font-size:12px; line-height:40px;}
}
.desertIsland .sectionC .item input[type=image] {margin-top:15px; width:100%;}
.desertIsland .comment {padding:5% 0;}
.bagList {overflow:hidden; padding:0 2%;}
.bagList .bag {position:relative; float:left; width:44%; margin:20px 3% 0; height:130px; box-sizing:border-box; -moz-box-sizing:border-box; background-repeat:no-repeat; background-position:50% 0; background-size:60px auto;}
.bagList .bag1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/54128/bg_bag_red.gif);}
.bagList .bag2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/54128/bg_bag_brown.gif);}
.bagList .bag3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/54128/bg_bag_yellow.gif);}
.bagList .bag4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/54128/bg_bag_green.gif);}
.bagList .bag > div {margin-top:16px; border-radius:10px; padding:12px 15px 8px;}
.bagList .bag1 > div {border:2px solid #ff0000;}
.bagList .bag2 > div {border:2px solid #8b2d10;}
.bagList .bag3 > div {border:2px solid #ff8a00;}
.bagList .bag4 > div {border:2px solid #00c03f;}
.bagList .bag ul {margin-top:5px;}
.bagList .bag ul li {font-size:15px; color:#000; font-weight:bold; text-align:left;}
.bagList .bag .writer {margin-top:10px; color:#8a8a8a; font-size:12px; font-family:'Dotum', 'Verdana'; line-height:1.25em; text-align:right;}
.bagList .bag .writer img {width:8px; margin-right:3px; vertical-align:middle;}
.bagList .bag .btnDel {position:absolute; bottom:28px; right:17px; padding:1px 5px; border:0; background-color:#bcbcbc; color:#fff; font-size:11px; line-height:1.25em; font-weight:normal; cursor:pointer; text-align:center;}
.desertIsland .comment .paging {margin-top:30px;}
@media all and (max-width:480px){
	.bagList .bag {height:121px; background-size:43px auto;}
	.bagList .bag > div {margin-top:12px; padding:12px 6px 8px;}
	.bagList .bag ul li {font-size:12px;}
	.bagList .bag .writer {font-size:10px;}
	.bagList .bag .btnDel {bottom:24px; right:8px; font-size:10px;}
}
</style>
<script src="/lib/js/swiper-1.8.min.js"></script>
<script type="text/javascript">
$(function(){
	showSwiper= new Swiper('.swiper1',{
		loop:false,
		resizeReInit:true,
		calculateHeight:true,
		pagination:'.pagination',
		paginationClickable:true,
		speed:180
	});
	$('.swiper .arrow-left').on('click', function(e){
		e.preventDefault()
		showSwiper.swipePrev()
	});
	$('.swiper .arrow-right').on('click', function(e){
		e.preventDefault()
		showSwiper.swipeNext()
	});

	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
		showSwiper.reInit();
		clearInterval(oTm);
		}, 1);
	});
});
</script>
<script type="text/javascript">
<!--
 	function jsGoComPage(iP){
		document.frmcom.iCC.value = iP;
		document.frmcom.iCTot.value = "<%=iCTotCnt%>";
		document.frmcom.submit();
	}

	function jsSubmitComment(frm){
		<% if Not(IsUserLoginOK) then %>
		    jsChklogin('<%=IsUserLoginOK%>');
		    return false;
		<% end if %>

	   if(!frm.qtext1.value||frm.qtext1.value=="1번째"){
	    alert("가방에 넣을 것을 입력해주세요");
		document.frmcom.qtext1.value="";
	    frm.qtext1.focus();
	    return false;
	   }

	   	if(GetByteLength(frm.qtext1.value)>21){
			alert('10자 까지 가능합니다.');
	    frm.qtext1.focus();
	    return false;
		}

	   if(!frm.qtext2.value||frm.qtext2.value=="2번째"){
	    alert("가방에 넣을 것을 입력해주세요");
		document.frmcom.qtext2.value="";
	    frm.qtext2.focus();
	    return false;
	   }

	   	if(GetByteLength(frm.qtext2.value)>21){
			alert('10자 까지 가능합니다.');
	    frm.qtext2.focus();
	    return false;
		}

	   if(!frm.qtext3.value||frm.qtext3.value=="3번째"){
	    alert("가방에 넣을 것을 입력해주세요");
		document.frmcom.qtext3.value="";
	    frm.qtext3.focus();
	    return false;
	   }

	   	if(GetByteLength(frm.qtext3.value)>21){
			alert('10자 까지 가능합니다.');
	    frm.qtext3.focus();
	    return false;
		}

	   frm.action = "doEventSubscript54128.asp";
	   return true;
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
			if(document.frmcom.qtext1.value =="1번째"){
				document.frmcom.qtext1.value="";
			}
			return true;
		} else {
			parent.jsevtlogin();
		}

		return false;
	}

	function jsChklogin22(blnLogin)
	{
		if (blnLogin == "True"){
			if(document.frmcom.qtext2.value =="2번째"){
				document.frmcom.qtext2.value="";
			}
			return true;
		} else {
			parent.jsevtlogin();
		}

		return false;
	}

	function jsChklogin33(blnLogin)
	{
		if (blnLogin == "True"){
			if(document.frmcom.qtext3.value =="3번째"){
				document.frmcom.qtext3.value="";
			}
			return true;
		} else {
			parent.jsevtlogin();
		}

		return false;
	}

	function jsChkUnblur11()
	{
		if(document.frmcom.qtext1.value ==""){
			document.frmcom.qtext1.value="1번째";
		}
	}

	function jsChkUnblur22()
	{
		if(document.frmcom.qtext2.value ==""){
			document.frmcom.qtext2.value="2번째";
		}
	}

	function jsChkUnblur33()
	{
		if(document.frmcom.qtext3.value ==""){
			document.frmcom.qtext3.value="3번째";
		}
	}

//-->
</script>
</head>
<body>
<div class="mEvt54107">
	<div class="desertIsland">
		<div class="section sectionA">
			<p class="topic">
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/54128/tit_desert_island.png" alt="무인도로 가는 가방" />
				<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/54128/txt_only_three_items.png" alt="당신은 곧 무인도로 가게 됩니다. 허락된 것은 가방 하나와 그 안에 넣어갈 세 가지의 어떤 것뿐!" /></span>
			</p>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/54128/img_main_visual.jpg" alt="" /></div>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54128/txt_put_your_bag_01.gif" alt="PLAY 에서는 모두에게 주어진 똑같은 가방이지만, 사람마다 무인도로 가는 이 가방 안에 어떤 것들을 담아갈지 궁금해졌습니다. 똑같은 가방이지만, 담는 것에 따라 똑같지 않은 가방! 다양한 직업과 나이의 60여명의 사람들에게 들어 본, 무인도로 가는 가방에 담긴 이야기 그리고 당신에게 듣고 싶은 이야기! " /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54128/txt_put_your_bag_02.gif" alt="무인도로 가는 이 가방안에 딱 세 가지만 담아갈 수 있다면, 어떤 것을 담아 가시겠어요?" /></p>
		</div>

		<div class="section sectionB">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54128/tit_60_peoples.gif" alt="60명의 사람들에게 들어 본, 무인도로 가는 가방에 담긴 이야기" /></h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54128/txt_more_story.gif" alt="더 많은 이야기는 텐바이텐 웹사이트에서 PLAY GROUND코너에서 확인 가능합니다." /></p>
			<div class="swiper">
				<div class="swiper-container swiper1">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54128/img_slide_01.gif" alt="랜턴, 모기장 텐트, 스노쿨링 장비세트" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54128/img_slide_02.gif" alt="영어문법책 기초, 라면스프, 정말 좋은 담요" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54128/img_slide_03.gif" alt="타임머신, 순간이동기술, 캠핑용품" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54128/img_slide_04.gif" alt="튜브, 연필과 스케치북 세트, 극세사 이불" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54128/img_slide_05.gif" alt="라디오, 영화 테이큰에 나오는 아빠, 영어책" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54128/img_slide_06.gif" alt="고양이, 마법의 양탄자, 초코케익" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54128/img_slide_07.gif" alt="오늘 처음 본 남자, 마법지팡이, 순간이동 리모콘" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54128/img_slide_08.gif" alt="스노쿨링 장비, 암탉, 김병만" /></div>
					</div>
					<div class="pagination"></div>
				</div>
				<button type="button" class="btnArrow arrow-left">Previous</button>
				<button type="button" class="btnArrow arrow-right">Next</button>
			</div>
		</div>

		<!-- comment event -->
		<div class="section sectionC">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54128/tit_commnet_event.gif" alt="코멘트 이벤트" /></h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54128/txt_put_three_items.gif" alt="무인도로 가는 가방에 넣을 세 가지를 담아 보세요!" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54128/txt_gift_bag.gif" alt="재치 있는 답변을 남겨주신 3분을 추첨해 지구를 한 바퀴 도는 여행을 위한 어스백(랜덤)을 선물로 드립니다." /></p>
			<div><a href="/category/category_itemPrd.asp?itemid=374734" target="_blank" title="새창"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54128/img_gift_bag.jpg" alt="어스백 상품 보러가기" /></a></div>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54128/txt_date.gif" alt="이벤트 기간은 2014년 8월 11일부터 17일까지이며, 당첨자 발표는 2014년 8월 19일 입니다." /></p>

			<!-- for dev msg : 가방에 넣을 세 가지 쓰기 -->
			<div class="item">
				<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
				<input type="hidden" name="eventid" value="<%=eCode%>">
				<input type="hidden" name="bidx" value="<%=bidx%>">
				<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
				<input type="hidden" name="iCTot" value="">
				<input type="hidden" name="mode" value="add">
				<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
				<input type="hidden" name="spoint" value="<%=rencolor%>">
					<fieldset>
					<legend>가방에 넣을 세가지 아이템 작성하기</legend>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54128/txt_wirte_tenwords.gif" alt="※ 각각 10자 이내로 작성해 주세요 :)" /></p>
						<!-- for dev msg : 최대 10자 띄어쓰기 포함 -->
						<input type="text" title="첫번째 아이템 입력" maxlength="10" placeholder="첫번째" class="iText" name="qtext1" value="" onClick="jsChklogin11('<%=IsUserLoginOK%>');"/>
						<input type="text" title="두번째 아이템 입력" maxlength="10" placeholder="두번째" class="iText" name="qtext2" value="" onClick="jsChklogin22('<%=IsUserLoginOK%>');"/>
						<input type="text" title="세번째 아이템 입력" maxlength="10" placeholder="세번째" class="iText" name="qtext3" value="" onClick="jsChklogin33('<%=IsUserLoginOK%>');"/>
						<div class="btnSubmit"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/54128/btn_submit.gif" alt="가방에 담기" /></div>
					</fieldset>
				</form>
				<form name="frmdelcom" method="post" action="doEventSubscript54128.asp" style="margin:0px;">
				<input type="hidden" name="eventid" value="<%=eCode%>">
				<input type="hidden" name="bidx" value="<%=bidx%>">
				<input type="hidden" name="Cidx" value="">
				<input type="hidden" name="mode" value="del">
				<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
				</form>
			</div>

			<!-- for dev msg : commnet list -->
			<% IF isArray(arrCList) THEN %>
			<div class="comment">
				<div class="bagList">
					<!-- for dev msg : 가방색 클래스명 bag1~bag4 순서대로 반복되게 해주세요 -->
					<% 
						Dim opt1 , opt2 , opt3
						For intCLoop = 0 To UBound(arrCList,2)

						If arrCList(1,intCLoop) <> "" then
							opt1 = SplitValue(arrCList(1,intCLoop),"//",0)
							opt2 = SplitValue(arrCList(1,intCLoop),"//",1)
							opt3 = SplitValue(arrCList(1,intCLoop),"//",2)
						End If 
					%>
					<div class="bag bag<%=arrCList(3,intCLoop)%>">
						<div>
							<ul>
								<li><%=opt1%></li>
								<li><%=opt2%></li>
								<li><%=opt3%></li>
							</ul>
							<div class="writer"><% If arrCList(8,intCLoop) = "M"  then%><img src="http://webimage.10x10.co.kr/play/ground/20140811/ico_mobile.gif" alt="모바일에서 작성" /><% End If %><span><%=printUserId(arrCList(2,intCLoop),2,"*")%></span>님 <span>No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></span></div>
							<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
							<button type="button" class="btnDel" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>');return false;">삭제</button>
							<% end if %>
						</div>
					</div>
					<% Next %>
				</div>
				<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
				<% End If %>
			</div>
		</div>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->