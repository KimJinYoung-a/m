<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : PLAY 32-2 M/A
' History : 2016-07-08 원승현 생성
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
Dim eCode , userid , strSql , totcnt , pagereload , totcntall
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66167
Else
	eCode   =  71791
End If

dim com_egCode, bidx , commentcount
	Dim cEComment
	Dim iCTotCnt, arrCList,intCLoop, iSelTotCnt
	Dim iCPageSize, iCCurrpage
	Dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	Dim timeTern, totComCnt, eCC

	'파라미터값 받기 & 기본 변수 값 세팅
	iCCurrpage = requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	com_egCode = requestCheckVar(Request("eGC"),1)
	eCC = requestCheckVar(Request("eCC"), 1) 

	IF iCCurrpage = "" THEN iCCurrpage = 1
	IF iCTotCnt = "" THEN iCTotCnt = -1

	'// 그룹번호 랜덤으로 지정

	iCPageSize = 6		'한 페이지의 보여지는 열의 수
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
<style type="text/css">
img {vertical-align:top;}
.goTop {display:none !important;}
.mPlay20160711 {-webkit-text-size-adjust:none;}
.intro {position:relative;}
.intro .valuable {position:absolute; left:0; top:26.5%; width:100%;}
.intro .box {position:absolute; left:0; top:63.22%; width:100%;}
.intro h2 p {position:absolute; left:0; top:35.2%; width:100%}
.intro h2 span {display:block; position:absolute; top:43.6%;}
.intro h2 span.t1 {left:19.2%; width:8.6%;}
.intro h2 span.t2 {left:28%; width:30.8%; height:16.8%; background:url(http://webimage.10x10.co.kr/playmo/ground/20160711/tit_jewelry_02.png) 50% 0 no-repeat; background-size:auto 100%;}
.intro h2 span.t3 {left:59.9%; width:23.5%;}
.purpose {position:relative;}
.purpose .heart {position:absolute; left:50%; top:0; width:5.5%; margin-left:-2.75%; animation:move .8s ease-in-out 1s 50 alternate;}
.floatMenu {position:fixed; right:4%; bottom:3%; width:21.25%; z-index:10000;}
.jewelryBox {background:#f9e9cc;}
.jewelryBox .tabNav{position:relative; padding:0 6%;}
.jewelryBox .tabNav li {position:absolute; width:44%;}
.jewelryBox .tabNav li a {display:block; width:100%; height:100%;}
.jewelryBox .tabNav li a span {display:none;}
.jewelryBox .tabNav li.current a span {display:block;}
.jewelryBox .tabNav li.jBox1 {left:6%; top:0; height:45%;}
.jewelryBox .tabNav li.jBox2 {right:6%; top:0; height:54.4%;}
.jewelryBox .tabNav li.jBox3 {left:6%; bottom:0; height:55.1%;}
.jewelryBox .tabNav li.jBox4 {right:6%; bottom:0; height:45.8%;}
.jewelryBox .jContent {position:relative; border-bottom:2px solid #fff; background-position:50% 50%; background-repeat:no-repeat; background-size:150%;}
.jewelryBox .jContent .arrow {position:absolute; left:50%; top:0; width:4.06%; margin-left:-2.03%;}
.jewelryBox .jContent .txt {position:absolute; left:50%; top:15.7%; width:50%; margin-left:-25%; margin-top:10px; opacity:0;}
.jewelryBox .jContent .txt:after {content:''; display:inline-block; position:absolute; left:50%; top:12rem; width:10%; height:0.2rem; margin-left:-5%; background:#fff; box-shadow:0 0 3px rgba(0,0,0,.1);}
.jewelryBox #tab1 {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160711/img_cont_01.jpg);}
.jewelryBox #tab2 {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160711/img_cont_02.jpg);}
.jewelryBox #tab3 {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160711/img_cont_03.jpg);}
.jewelryBox #tab4 {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160711/img_cont_04.jpg);}
.yourItem {position:relative;}
.yourItem li {position:absolute;}
.yourItem li a {display:block; width:100%; height:100%; text-indent:-999em;}
.yourItem li.item1 {right:2%; top:12.5%; width:45%; height:12.5%;}
.yourItem li.item2 {left:7%; top:26%; width:47%; height:32%;}
.yourItem li.item3 {right:11%; top:44%; width:28%; height:16%;}
.yourItem li.item4 {left:16%; top:62%; width:30%; height:14.5%;}
.jewelryWrite .writeBox {padding:0 5.15% 6rem; background:url(http://webimage.10x10.co.kr/playmo/ground/20160711/bg_comment.png) 0 0 repeat-y; background-size:100% 100%;}
.jewelryWrite .writeBox .inner {overflow:hidden; position:relative; background:#f8f8f8;}
.jewelryWrite .writeBox .myJewelryIs {float:left; width:71%; padding:1.5rem 0 0 8%;}
.jewelryWrite .writeBox .myJewelryIs input {width:13.5rem; font-size:1.3rem; border-radius:0; margin-right:0.5rem;}
.jewelryWrite .writeBox .btnApply {float:right; width:28.5%;}
.jewelryList {padding:3.2rem 0; background:#e0e0e0;}
.jewelryList .total {padding:0 9.4% 1.2rem; font-size:1.25rem; color:#777; font-family:arial; text-align:right;}
.jewelryList ul {padding:0 9.4%;}
.jewelryList li {position:relative; height:8rem; padding:0 1.2rem; margin-bottom:1.1rem; background:#fff; box-shadow:0.2rem 0.2rem 0.6rem rgba(0,0,0,.1);}
.jewelryList li p {padding:2.4rem 1.2rem 1.6rem; font-size:1.3rem; color:#505050; font-weight:bold;}
.jewelryList li p em {color:#e9a33a;}
.jewelryList li div {overflow:hidden;padding:0.6rem 0.9rem 0; color:#b3b3b3; border-top:1px solid #e0e0e0;}
.jewelryList li .writer {float:left;}
.jewelryList li .writer img {width:0.55rem; margin-right:0.5rem;}
.jewelryList li .num {float:right; text-align:right;}
.jewelryList .delete {display:inline-block; position:absolute; right:0; top:0; width:3rem;}
.jewelryList .paging {margin-top:20px;}
.jewelryList .paging span {width:3.1rem; height:3.1rem; border-radius:50%; margin:0 0.4rem; border:1px solid #cd8e2e;}
.jewelryList .paging span a {font-size:1.2rem; line-height:3.1rem; font-weight:bold; text-align:center; padding-top:0; color:#cd8e2e;}
.jewelryList .paging span.current {background-color:#cd8e2e;}
.jewelryList .paging span.current a {color:#fff;}
.jewelryList .paging span.arrow {margin:0; background-color:transparent; border:0; background-position:50% 50%; background-repeat:no-repeat; background-size:3.1rem auto;}
.jewelryList .paging span.prevBtn {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160711/btn_prev.png);}
.jewelryList .paging span.nextBtn {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160711/btn_next.png);}
@keyframes move {from {transform:translate(0,-10px);} to {transform:translate(0,0);}}
</style>
<script type="text/javascript">
$(function(){
	<% if ecc<>"" then %>
		setTimeout("pagedown()",500);
	<% end if %>
});

$(function(){
	// intro
	$(".intro h2 p").css({"margin-top":"5px","opacity":"0"});
	$(".intro h2 span.t1").css({"margin-left":"12%","opacity":"0"});
	$(".intro h2 span.t2").css({"left":"38%","width":"0"});
	$(".intro h2 span.t3").css({"margin-left":"-15%","opacity":"0"});
	function titleAnimation() {
		$(".intro h2 p").delay(100).animate({"margin-top":"0",'opacity':'1'},1000);
		$(".intro h2 span.t1").delay(1000).animate({"margin-left":"0",'opacity':'1'},1200);
		$(".intro h2 span.t2").delay(1000).animate({"left":"28%","width":"30.8%"},1200);
		$(".intro h2 span.t3").delay(1000).animate({"margin-left":"0",'opacity':'1'},1200);
	}
	titleAnimation()
	$(window.parent).scroll(function(){
		var scrollTop = $(window.parent).scrollTop();
		if (scrollTop > 500) {
			$(".watering #fruit .txt").delay(100).animate({"margin-left":"0",'opacity':'1'},400);
		}
	});

	// tab
	$(".jewelryBox .tabNav li a").click(function(event){
		var currentTab = $(this).attr('name');
		$('.jewelryBox #'+currentTab).delay(50).animate({backgroundSize:'100%', "opacity":"1"},1500);
		$('.jewelryBox #'+currentTab).find('.txt').delay(800).animate({"margin-top":"0","opacity":"1"},800);
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top}, 800);
	});

	// go tab
	$(".floatMenu a").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top}, 800);
	});
	$('.floatMenu').hide();
	$(window).scroll(function(){
		var scrollTop = $(window.parent).scrollTop();
		if (scrollTop > 350){
			if($('.floatMenu').css("display")=="none"){
				$('.floatMenu').fadeIn();
			}
		} else {
			$('.floatMenu').hide();
		}
		if (scrollTop > 1450) {
			$('.jewelryBox #tab1').delay(50).animate({backgroundSize:'100%', "opacity":"1"},1600);
			$('.jewelryBox #tab1 .txt').delay(500).animate({"margin-top":"0","opacity":"1"},1000);
		}
		if (scrollTop > 2050) {
			$('.jewelryBox #tab2').delay(50).animate({backgroundSize:'100%', "opacity":"1"},1600);
			$('.jewelryBox #tab2 .txt').delay(500).animate({"margin-top":"0","opacity":"1"},1000);
		}
		if (scrollTop > 2650) {
			$('.jewelryBox #tab3').delay(50).animate({backgroundSize:'100%', "opacity":"1"},1600);
			$('.jewelryBox #tab3 .txt').delay(500).animate({"margin-top":"0","opacity":"1"},1000);
		}
		if (scrollTop > 3250) {
			$('.jewelryBox #tab4').delay(50).animate({backgroundSize:'100%', "opacity":"1"},1600);
			$('.jewelryBox #tab4 .txt').delay(500).animate({"margin-top":"0","opacity":"1"},1000);
		}
	});
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		$(".ma").show();
		$(".mw").hide();
	}else{
		$(".ma").hide();
		$(".mw").show();
	}
});


function pagedown(){
	window.$('html,body').animate({scrollTop:$("#commentlist").offset().top}, 0);
}

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


	if(!frm.txtcomm.value){
		alert("여러분의 보석함은 어떤 모습인가요?");
		document.frmcom.txtcomm.value="";
		frm.txtcomm.focus();
		return false;
	}

	if (GetByteLength(frm.txtcomm.value) > 14){
		alert("제한길이를 초과하였습니다. 7자 까지 작성 가능합니다.");
		frm.txtcomm.focus();
		return;
	}

	frm.action = "/play/groundcnt/doEventSubscript71791.asp";
	frm.submit();
}

function jsDelComment(cidx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmdelcom.Cidx.value = cidx;
		document.frmdelcom.submit();
	}
}

function jsChklogin22(blnLogin)
{
	if (blnLogin == "True"){
		if(document.frmcom.txtcomm.value =="7자 이내로 입력"){
			document.frmcom.txtcomm.value="";
		}
		return true;
	} else {
		<% If isApp="1" or isApp="2" Then %>
		calllogin();
		return false;
		<% else %>
		jsevtlogin();
		return;
		<% end if %>			
	}
	return false;
}

function fnOverNumberCut(){
	var t = $("#txtcomm").val();
	if($("#txtcomm").val().length >= 7){
		$("#txtcomm").val(t.substr(0, 7));
	}
}
</script>

<div class="mPlay20160711">
	<article>
		<%' intro %>
		<div class="intro">
			<p class="valuable"><img src="http://webimage.10x10.co.kr/playmo/ground/20160711/txt_valuable.png" alt="VALUABLE" /></p>
			<p class="box"><img src="http://webimage.10x10.co.kr/playmo/ground/20160711/txt_box.png" alt="VALUABLE" /></p>
			<h2>
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160711/tit_precious.png" alt="소중함을 담은" /></p>
				<span class="t1"><img src="http://webimage.10x10.co.kr/playmo/ground/20160711/tit_jewelry_01.png" alt="보석함" /></span>
				<span class="t2"><img src="http://webimage.10x10.co.kr/playmo/ground/20160711/tit_jewelry_blank.png" alt="" /></span>
				<span class="t3"><img src="http://webimage.10x10.co.kr/playmo/ground/20160711/tit_jewelry_03.png" alt="" /></span>
			</h2>
			<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160711/img_intro.jpg" alt="" /></div>
		</div>
		<div class="purpose">
			<span class="heart"><img src="http://webimage.10x10.co.kr/playmo/ground/20160711/bg_heart.png" alt="" /></span>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160711/txt_purpose_v2.png" alt="여러분의 보석함은 어떤 모습인가요? 어렸을 적 엄마와 함께 찍었던 사진이 담긴 앨범, 별보며 들었던 설렘 가득한 그 노래 리스트, 우리는 각자 자신만의 보석함에 소중한 것을 담곤 합니다. 여러분의 보석함은 어떤 것인가요? 어떤 것을 담느냐에 따라 달라지는 보석함의 모습! 여러분의 보석함에 소중한 것을 담아보세요!" /></p>
		</div>

		<%' 보석함 %>
		<div class="jewelryBox" id="jewelryBox">
			<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160711/bg_arrow.png" alt="" /></div>
			<p class="floatMenu"><a href="#jewelryBox"><img src="http://webimage.10x10.co.kr/playmo/ground/20160711/btn_go.png" alt="" /></a></p>
			<div class="tabNav" id="tabNav">
				<ul>
					<li class="jBox1 current"><a href="#tab3" name="tab3"><span><img src="http://webimage.10x10.co.kr/playmo/ground/20160711/tab_01.png" alt="추억함" /><span></a></li>
					<li class="jBox2"><a href="#tab2" name="tab2"><span><img src="http://webimage.10x10.co.kr/playmo/ground/20160711/tab_02.png" alt="노래함" /><span></a></li>
					<li class="jBox3"><a href="#tab1" name="tab1"><span><img src="http://webimage.10x10.co.kr/playmo/ground/20160711/tab_03.png" alt="기억함" /><span></a></li>
					<li class="jBox4"><a href="#tab4" name="tab4"><span><img src="http://webimage.10x10.co.kr/playmo/ground/20160711/tab_04.png" alt="보관함" /><span></a></li>
				</ul>
				<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160711/img_box.jpg" alt="" /></div>
			</div>
			<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160711/bg_slash.png" alt="" /></div>
			<div id="tab1" class="jContent">
				<span class="arrow"><img src="http://webimage.10x10.co.kr/playmo/ground/20160711/blt_triangle.png" alt="" /></span>
				<p class="txt"><img src="http://webimage.10x10.co.kr/playmo/ground/20160711/txt_cont_01.png" alt="기억함 - 그때 그 추억을 고스란히 담아 미래에 꺼내볼 수 있는 보석함" /></p>
				<img src="http://webimage.10x10.co.kr/playmo/ground/20160711/img_cont_00.png" alt="" />
			</div>
			<div id="tab2" class="jContent">
				<p class="txt"><img src="http://webimage.10x10.co.kr/playmo/ground/20160711/txt_cont_02.png" alt="노래함 -함께 별보며 들었던 노래를 생생하게 들을 수 있는 보석함" /></p>
				<img src="http://webimage.10x10.co.kr/playmo/ground/20160711/img_cont_00.png" alt="" />
			</div>
			<div id="tab3" class="jContent">
				<p class="txt"><img src="http://webimage.10x10.co.kr/playmo/ground/20160711/txt_cont_03.png" alt="추억함 - 여행에서 만난 반짝였던 순간, 기억을 담은 보석함 " /></p>
				<img src="http://webimage.10x10.co.kr/playmo/ground/20160711/img_cont_00.png" alt="" />
			</div>
			<div id="tab4" class="jContent">
				<p class="txt"><img src="http://webimage.10x10.co.kr/playmo/ground/20160711/txt_cont_04.png" alt="보관함 - 나의 이야기와 작업물들을 꾹꾹 담은 보석함 " /></p>
				<img src="http://webimage.10x10.co.kr/playmo/ground/20160711/img_cont_00.png" alt="" />
			</div>
		</div>

		<%' 여러분 %>
		<div class="yourItem">
			<ul class="mw">
				<li class="item1"><a href="/category/category_itemPrd.asp?itemid=851761&amp;pEtr=71791">유에너스 카드형 USB메모리 16GB</a></li>
				<li class="item2"><a href="/category/category_itemPrd.asp?itemid=917509&amp;pEtr=71791">아이코닉 포토인 포토앨범</a></li>
				<li class="item3"><a href="/category/category_itemPrd.asp?itemid=1427082&amp;pEtr=71791">에그 타임 캡슐</a></li>
				<li class="item4"><a href="/category/category_itemPrd.asp?itemid=1091239&amp;pEtr=71791">아이리버 스피커</a></li>
			</ul>
			<ul class="ma">
				<li class="item1"><a href="" onclick="fnAPPpopupProduct('851761&amp;pEtr=71791');return false;">유에너스 카드형 USB메모리 16GB</a></li>
				<li class="item2"><a href="" onclick="fnAPPpopupProduct('917509&amp;pEtr=71791');return false;">아이코닉 포토인 포토앨범</a></li>
				<li class="item3"><a href="" onclick="fnAPPpopupProduct('1427082&amp;pEtr=71791');return false;">에그 타임 캡슐</a></li>
				<li class="item4"><a href="" onclick="fnAPPpopupProduct('1091239&amp;pEtr=71791');return false;">아이리버 스피커</a></li>
			</ul>
			<div><img src="http://webimage.10x10.co.kr/playmo/ground/20160711/img_item.jpg" alt="4가지의 보석함에 소중한 것들을 담아주세요" /></div>
		</div>

		<%' 코멘트 작성 %>
		<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
		<input type="hidden" name="eventid" value="<%=eCode%>"/>
		<input type="hidden" name="bidx" value="<%=bidx%>"/>
		<input type="hidden" name="iCC" value="<%=iCCurrpage%>"/>
		<input type="hidden" name="iCTot" value=""/>
		<input type="hidden" name="mode" value="add"/>
		<input type="hidden" name="userid" value="<%=GetEncLoginUserID%>"/>
		<input type="hidden" name="eCC" value="1">
		<div class="jewelryWrite">
			<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20160711/txt_apply.png" alt="여러분의 보석함은 어떤 모습인가요? 여러분의 보석함을 소개해주세요! 추첨을 통해 5분에게 소중함을 담은 보석함Kit를 드립니다." /></h3>
			<div class="writeBox">
				<div class="inner">
					<div class="myJewelryIs">
						<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160711/txt_my_01.png" alt="나의 보석함은" style="width:11rem;" /></p>
						<p><input type="text" placeholder="7자 이내로 입력" id="txtcomm" name="txtcomm" onkeyup="fnOverNumberCut();" onClick="jsChklogin22('<%=IsUserLoginOK%>');" maxlength="7" /><img src="http://webimage.10x10.co.kr/playmo/ground/20160711/txt_my_02.png" alt="다." style="width:1.9rem;" /></p>
					</div>
					<button type="submit" class="btnApply" onclick="jsSubmitComment(document.frmcom);"><img src="http://webimage.10x10.co.kr/playmo/ground/20160711/btn_apply.png" alt="응모하기" /></button>
				</div>
			</div>
		</div>
		</form>
		<form name="frmdelcom" method="post" action="/event/lib/comment_process.asp" style="margin:0px;">
		<input type="hidden" name="eventid" value="<%=eCode%>">
		<input type="hidden" name="bidx" value="<%=bidx%>">
		<input type="hidden" name="Cidx" value="">
		<input type="hidden" name="mode" value="del">
		<input type="hidden" name="userid" value="<%=GetEncLoginUserID%>">
		</form>

		<%' 코멘트 리스트 %>
		<% IF isArray(arrCList) THEN %>
			<div class="jewelryList" id="commentlist">
				<p class="total">Total.<%=FormatNumber(iCTotCnt,0)%></p>
				<ul>
					<!-- 리스트 5개씩 노출 -->
					<% For intCLoop = 0 To UBound(arrCList,2) %>
						<li>
							<p>나의 보석함은 <em><%=arrCList(1,intCLoop)%></em>다.</p>
							<div>
								<span class="writer"><% If arrCList(8,intCLoop) = "M" Then %><img src="http://webimage.10x10.co.kr/playmo/ground/20160711/ico_mobile.png" alt="모바일에서 작성" /><% End If %><%=printUserId(arrCList(2,intCLoop),2,"*")%></span>
								<span class="num">No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></span>
							</div>
							<% if ((GetEncLoginUserID = arrCList(2,intCLoop)) or (GetEncLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
								<a href="" class="delete" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>');return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20160711/btn_delete.png" alt="삭제" /></a>
							<% End If %>						
						</li>
					<% Next %>
				</ul>
				<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
			</div>
		<% End If %>
	</article>
</div>

<!-- #include virtual="/lib/db/dbclose.asp" -->