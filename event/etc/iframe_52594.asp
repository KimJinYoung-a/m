<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  [10x10 오감충족 마지막 이벤트] This is My Bottle!(M)
' History : 2014.06.13 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/etc/event52594Cls.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->

<%
dim eCode, userid, sub_idx, i, subscriptcount
	eCode=getevt_code
	userid = getloginuserid()

dim iCPerCnt, iCPageSize, iCCurrpage
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호

subscriptcount=0
subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")

IF iCCurrpage = "" THEN iCCurrpage = 1
iCPageSize = 6
iCPerCnt = 4		'보여지는 페이지 간격1,2,3,4,5...
	
dim ccomment
set ccomment = new Cevent_etc_common_list
	ccomment.FPageSize        = iCPageSize
	ccomment.FCurrpage        = iCCurrpage
	ccomment.FScrollCount     = iCPerCnt
	ccomment.frectordertype="new"
	ccomment.frectevt_code      	= eCode
	ccomment.event_subscript_paging
%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > This is My Bottle!</title>
<style type="text/css">
.mEvt52595 {}
.mEvt52595 img {vertical-align:top; width:100%;}
.mEvt52595 p {max-width:100%;}
.mEvt52595 .buyGift {position:relative;}
.mEvt52595 .buyGift a {position:absolute; left:0; top:0;}
.mEvt52595 .myBottle {background:#53b8f2;}
.mEvt52595 .swiper {position:relative; width:430px; height:279px; padding:6px 6px 34px; margin:0 auto; background:#3d9fdf;}
.mEvt52595 .swiper .swiper-container {overflow:hidden; height:279px;}
.mEvt52595 .swiper .swiper-slide {float:left;}
.mEvt52595 .swiper .swiper-slide a {display:block; width:100%;}
.mEvt52595 .swiper .swiper-slide img {width:100%; vertical-align:top;}
.mEvt52595 .swiper .btnArrow {display:block; position:absolute; top:50%; margin-top:-34px; z-index:10; width:38px; height:38px; text-indent:-9999px; background-repeat:no-repeat; background-position:left top; background-size:100% auto;}
.mEvt52595 .swiper .arrow-left {left:12px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/52595/btn_prev.png);}
.mEvt52595 .swiper .arrow-right {right:12px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/52595/btn_next.png);}
.mEvt52595 .swiper .pagination {position:absolute; left:0; bottom:8px; width:100%; text-align:center;}
.mEvt52595 .swiper .pagination span {position:relative; display:inline-block; width:12px; height:12px; margin:0 7px; cursor:pointer; border-radius:12px; background:#fff;}
.mEvt52595 .swiper .pagination .swiper-active-switch {background:#d6ff8e;}
.mEvt52595 .gift {position:relative;}
.mEvt52595 .gift a {position:absolute; left:3%; top:30%; display:block; width:42%; height:60%; text-indent:-9999px; background:rgba(0,0,0,.00001);}
.mEvt52595 .makeMyBottle {padding-bottom:38px; background:#c8eff6;}
.mEvt52595 .makeMyBottle .writeWords {display:inline-block; width:80%; height:15px; font-size:11px; line-height:1; padding:7% 0; text-align:center; margin:0 auto 6px; color:#444; border:1px solid #a7ced5; background:#fff; -webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box;}
.mEvt52595 .makeMyBottle .enroll {width:80%; margin:0 auto; -webkit-border-radius:0;}
.mEvt52595 .bottleList {padding:8px 0 35px; background:#fff;}
.mEvt52595 .bottleList ul {overflow:hidden; padding:0 8px;}
.mEvt52595 .bottleList li {position:relative; float:left; width:33%; font-size:11px; line-height:1; margin-top:24px; padding:0 8px; -webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box;}
.mEvt52595 .bottleList li span {position:absolute; left:11%; display:block; width:78%;}
.mEvt52595 .bottleList li .num { top:1.5%; color:#fff;}
.mEvt52595 .bottleList li .writer {bottom:10%; }
.mEvt52595 .bottleList li p {position:absolute; left:15%; top:20%; width:70%; height:62%; font-size:12px; line-height:16px; padding-top:45%; font-weight:bold; text-align:center; word-break:break-all; -webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box;}
.mEvt52595 .evtNoti {overflow:hidden; padding:24px 20px 25px 8px; background:#c8eff6;}
.mEvt52595 .evtNoti dl {text-align:left;}
.mEvt52595 .evtNoti dt {padding:0 0 12px 12px;}
.mEvt52595 .evtNoti li {color:#444; font-size:11px; line-height:15px; padding:0 0 5px 12px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/52595/blt_arrow.png) left 3px no-repeat; background-size:6px 7px;}
.mEvt52595 .evtNoti li strong {color:#d50c0c;}
@media all and (max-width:480px){
	.mEvt52595 .swiper {width:287px; height:186px;}
	.mEvt52595 .swiper .swiper-container {height:246px;}
}
</style>
<script src="/lib/js/swiper-1.8.min.js"></script>
<script type="text/javascript">
$(function(){
	var mySwiper = new Swiper('.swiper-container',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		pagination:'.pagination',
		paginationClickable:true,
		speed:180
	})
	$('.swiper .arrow-left').on('click', function(e){
		e.preventDefault()
		mySwiper.swipePrev()
	});
	$('.swiper .arrow-right').on('click', function(e){
		e.preventDefault()
		mySwiper.swipeNext()
	});

	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
	var oTm = setInterval(function () {
		mySwiper.reInit();
			clearInterval(oTm);
		}, 1);
	});

	$('.writeWords').each(function() {
		var defaultVal = this.value;
		$(this).focus(function() {
			if(this.value == defaultVal){
				this.value = '';
			}
		});
		$(this).blur(function(){
			if(this.value == ''){
				this.value = defaultVal;
			}
		});
	});
	$('.bottleList li').each( function (){
		var rdNum = Math.round(Math.random()*5);
		var rdClass = ['b01','b02','b03','b04','b05','b06'];
		$(this).addClass(rdClass[rdNum]);
	});
	$('.bottleList li.b01').append('<img src="http://webimage.10x10.co.kr/eventIMG/2014/52595/bg_bottle01.png" alt="" />');
	$('.bottleList li.b02').append('<img src="http://webimage.10x10.co.kr/eventIMG/2014/52595/bg_bottle02.png" alt="" />');
	$('.bottleList li.b03').append('<img src="http://webimage.10x10.co.kr/eventIMG/2014/52595/bg_bottle03.png" alt="" />');
	$('.bottleList li.b04').append('<img src="http://webimage.10x10.co.kr/eventIMG/2014/52595/bg_bottle04.png" alt="" />');
	$('.bottleList li.b05').append('<img src="http://webimage.10x10.co.kr/eventIMG/2014/52595/bg_bottle05.png" alt="" />');
	$('.bottleList li.b06').append('<img src="http://webimage.10x10.co.kr/eventIMG/2014/52595/bg_bottle06.png" alt="" />');
});

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If Now() > #06/20/2014 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If getnowdate>="2014-06-16" and getnowdate<"2014-06-21" Then %>
				<% if subscriptcount<5 then %>
					if(frm.txtcomm.value =="로그인 후 글을 남길 수 있습니다."){
						jsChklogin('<%=IsUserLoginOK%>');
						return false;
					}
					if (frm.txtcomm.value == '' || GetByteLength(frm.txtcomm.value) > 20 || frm.txtcomm.value == '최대 10글자 이내로 작성해 주세요.'){
						alert("코맨트가 없거나 제한길이를 초과하였습니다. 10자 까지 작성 가능합니다.");
						frm.txtcomm.focus();
						return;
					}
	
			   		frm.mode.value="addcomment";
					frm.action="/event/etc/doEventSubscript52594.asp";
					frm.target="evtFrmProc";
					frm.submit();
					return;
				<% else %>
					alert("5번만 등록하실 수 있습니다.");
					return;
				<% end if %>
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% end if %>				
		<% End If %>
	<% Else %>
		alert('로그인을 하셔야 참여가 가능 합니다');
		return;
		//if(confirm("로그인을 하셔야 참여가 가능 합니다. 로그인 하시겠습니까?")){
		//	var winLogin = window.open('/login/PopLoginPage.asp','popLogin','width=400,height=300');
		//	winLogin.focus();
		//	return;
		//}
	<% End IF %>
}
function jsGoComPage(iP){
	document.frmcomm.iCC.value = iP;
	document.frmcomm.submit();
}
function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		jsChklogin('<%=IsUserLoginOK%>');
	}
	
	if (frmcomm.txtcomm.value == '최대 10글자 이내로 작성해 주세요.'){
		frmcomm.txtcomm.value='';
	}
}
</script>
</head>
<body>
	<div class="evtView tMar15" style="padding:0;">
		<!-- //THIS IS MY BOTTLE -->
		<div class="mEvt52595">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52595/tit_sense_ver04.png" alt="10X10 오감충족 마지막 사은이벤트" /></p>
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/52595/tit_my_bottle.png" alt="THIS IS MY BOTTLE" /></h3>
			<div class="myBottle">
				<div class="swiper">
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52595/img_slide_bottle01.png" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52595/img_slide_bottle02.png" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52595/img_slide_bottle03.png" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52595/img_slide_bottle04.png" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52595/img_slide_bottle05.png" alt="" /></div>
						</div>
						<div class="pagination"></div>
					</div>
					<a class="btnArrow arrow-left" href="">Previous</a>
					<a class="btnArrow arrow-right" href="">Next</a>
				</div>
			</div>
			<div class="gift">
				<a href="" onclick="TnGotoProduct(1074410);return false;">my bottle 월머그 리유즈 보틀</a>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52595/img_gift.png" alt="" />
			</div>
			<!-- 문구 작성하기 -->
			<form name="frmcomm" action="" onsubmit="return false;" method="post" style="margin:0px;">
			<input type="hidden" name="mode">
			<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
			<input type="hidden" name="sub_idx">
			<div class="makeMyBottle">
				<h4><img src="http://webimage.10x10.co.kr/eventIMG/2014/52595/tit_bottle_words.png" alt="나만의 My Bottle에 넣고 싶은 문구를 적어주세요! 재치 있는 문구를 적어주신 분들 중 10분을 추첨해 텐바이텐 GIFT 카드를 드립니다!" /></h4>
				<p>
					<input type="text" name="txtcomm" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> value= <%IF NOT IsUserLoginOK THEN%>"로그인 후 글을 남길 수 있습니다." <% else %> "최대 10글자 이내로 작성해 주세요." <%END IF%> class="writeWords" />
					<input type="image" onclick="jsSubmitComment(frmcomm); return false;" src="http://webimage.10x10.co.kr/eventIMG/2014/52595/btn_enroll.png" class="enroll" alt="등록하기" />
				</p>
			</div>
			
			<% IF ccomment.ftotalcount>0 THEN %>
			<div class="bottleList">
				<ul>
					<!-- for dev msg : 리스트는 6개씩 노출됩니다. -->
					<% for i = 0 to ccomment.fresultcount - 1 %>
					<li>
						<span class="num">no.<%=ccomment.FTotalCount-i-(ccomment.FPageSize*(ccomment.FCurrPage-1))%></span>
						<p><%=ReplaceBracket(ccomment.FItemList(i).fsub_opt3)%></p>
						<span class="writer"><%=printUserId(ccomment.FItemList(i).fuserid,2,"*")%></span>
						<p class="bg"></p>
					</li>
					<% next %>
				</ul>
				<%= fnDisplayPaging_New(ccomment.FCurrpage, ccomment.ftotalcount, ccomment.FPageSize, ccomment.FScrollCount,"jsGoComPage") %>
			</div>
			<% end if %>
			</form>
			
			
			<!--// 문구 작성하기 -->
			<div class="evtNoti">
				<dl>
					<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/52595/tit_noti.png" alt="이벤트 유의사항" style="width:74px;" /></dt>
					<dd>
						<ul>
							<li>텐바이텐 사은 이벤트는 텐바이텐 회원님을 위한 혜택입니다. (비회원 구매 증정 불가)</li>
							<li>사은품은 한정수량이므로, 수량이 모두 소진 될 경우에는 이벤트가 자동 종료됩니다</li>
							<li>상품 쿠폰, 보너스 쿠폰, 할인카드 등의 사용 후 <strong>구매확정 금액이 7만원</strong> 이어야 합니다.</li>
							<li>7만원 구매 시, 텐바이텐 배송상품을 반드시 포함해야 사은품을 받을 수 있습니다.</li>
							<li>마일리지, 예치금, GIFT 카드를 사용하신 경우는 구매확정금액에 포함되어 사은품을 받으실 수 있습니다.</li>
							<li>한 주문 건이 구매금액 기준 이상일 때 증정하며 다른 주문에 대한 누적적용이 되지 않습니다.</li>
							<li>사은품의 경우 구매하신 텐바이텐 배송 상품과 함께 배송됩니다</li>
							<li>3,000원 할인 쿠폰은 7월7일 오전 10시에 일괄 발송되며, 사용기간은 7월 20일까지 입니다.</li>
							<li>GIFT 카드를 구매하신 경우는 사은품과 사은 쿠폰이 증정되지 않습니다.</li>
							<li>환불이나 교환 시, 최종 구매 가격이 사은품 수령 가능 금액 미만이 될 경우, 사은품과 함께 반품해야 합니다.</li>
							<li>스페셜 보너스 이벤트는 6월 30일 당첨자 발표를 하며, GIFT카드(3만원권)는 해당 ID로 자동 발급 될 예정입니다.</li>
						</ul>
					</dd>
				</dl>
			</div>
		</div>
		<!-- //THIS IS MY BOTTLE -->
	</div>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->