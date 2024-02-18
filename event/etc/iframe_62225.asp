<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  2015오픈이벤트 - vipGift - 이벤트 연장
' History : 2015-04-10 이종화
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
	Dim eCode , vQuery , allcnt
	IF application("Svr_Info") = "Dev" THEN
		eCode		=  61776
	Else
		eCode		=  62224
	End If

	dim oUserInfo
	set oUserInfo = new CUserInfo
		oUserInfo.FRectUserID = GetLoginUserID
	if (GetLoginUserid<>"") then
		oUserInfo.GetUserData
	end If
	
	vQuery = "SELECT count(*) FROM [db_temp].[dbo].[tbl_temp_event_addr] WHERE evt_code='"&eCode&"' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		allcnt = rsget(0)
	End If
	rsget.close()
%>
<style type="text/css">
.vipGift img {vertical-align:top;}
.swiperWrap {position:relative; padding-bottom:7.5%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/62225/bg_slide.gif) no-repeat left top; background-size:100% 100%;}
.swiperWrap .hPagination {position:absolute; bottom:0; left:0; width:100%; height:10px; text-align:center; z-index:100;}
.swiperWrap .hPagination span {display:inline-block; position:relative; width:10px; height:10px; margin:0 4px; border-radius:50%; background:#fff; cursor:pointer; vertical-align:top;}
.swiperWrap .hPagination .swiper-active-switch {background:#703f26;}
.swiper {position:relative; width:302px; margin:0 auto; padding:5px; background:#fff; box-shadow:0 0 3px rgba(0,0,0,.25);}
.swiper .swiper-container {overflow:hidden;}
.swiper .swiper-slide {float:left;}
.swiper button {border:0; background:none;}
.swiper .btnNav {display:block; position:absolute; top:40%; width:10%; z-index:10; color:#fff; }
.swiper .arrowPrev {left:0;}
.swiper .arrowNext {right:0;}
.vipGiftContainer{padding:7.8% 3.125% 0; background:url(http://webimage.10x10.co.kr/eventIMG/2015/61493/bg_vip_content.gif) no-repeat left top #fde1b4; background-size:100% auto;}
.vipCont .vipBox {box-shadow:0 0 3px #cbb591; background:#fef8e1; text-align:left; }
.vipCont .vipArea .goBtn {padding-top:4.6%;}
.vipCont .vipArea .goBtn span {cursor:pointer;}
.vipCont .sectionB .vipBox {padding:0 3.125% 6%;}
.vipCont .sectionB .tit {width:43%; margin:0 auto; padding:28px 0 20px;}
.vipCont .checkAddr {padding-top:20px; font-size:12px; color:#888; border-top:1px solid #cbcbcb;}
.vipCont .checkAddr label,
.vipCont .checkAddr input {display:inline-block; vertical-align:middle;}
.vipCont .checkAddr label {padding-left:5px; margin-top:2px;}
.vipCont .checkAddr ul {padding:20px 15px 0;}
.vipCont .checkAddr li {overflow:hidden; padding-bottom:16px;}
.vipCont .checkAddr li strong {display:block; float:left; width:18%; line-height:37px; color:#555;}
.vipCont .checkAddr li div {float:left; width:82%;}
.vipCont .checkAddr li input {width:100%; color:#666; border:1px solid #ccc; line-height:12px; vertical-align:middle;}
.vipCont .checkAddr li input.ct {padding-left:0; padding-right:0;}
.vipCont .checkAddr .button a {padding-left:5px; padding-right:5px; font-weight:500;}
.vipCont .tip {padding-left:20.5%;}
.vipCont .tip p {font-size:11px; color:#555; line-height:1.4; letter-spacing:-0.045em; padding:0 0 3px 12px; text-indent:-12px;}
.evtNoti {padding:14% 0 10%;}
.evtNoti dt {color:#444; margin-bottom:15px;}
.evtNoti dt span {padding:0 10px; font-size:13px; line-height:1; font-weight:bold; border-left:2px solid #fef8e1; border-right:2px solid #fef8e1; vertical-align:top;}
.evtNoti li {position:relative; color:#444; font-size:11px; line-height:1.3; padding-left:13px; margin-top:4px;}
.evtNoti li:first-child {margin-top:0;}
.evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:3px; width:2px; height:2px; border:2px solid #ffc101; border-radius:50%;}
@media all and (min-width:360px){
	.swiper {width:342px; padding:6px;}
}
@media all and (min-width:480px){
	.swiper {width:462px; padding:7px;}
	.vipCont .sectionB .tit {padding:42px 0 30px;}
	.vipCont .checkAddr {padding-top:30px; font-size:18px;}
	.vipCont .checkAddr label {padding-left:7px; margin-top:3px;}
	.vipCont .checkAddr ul {padding:30px 23px 0;}
	.vipCont .checkAddr li {padding-bottom:24px;}
	.vipCont .checkAddr li strong {line-height:55px;}
	.vipCont .checkAddr li input {line-height:18px;}
	.vipCont .checkAddr .button a {padding-left:7px; padding-right:7px;}
	.vipCont .tip p {font-size:17px; padding:0 0 4px 18px; text-indent:-18px;}
	.evtNoti dt {margin-bottom:23px;}
	.evtNoti dt span {padding:0 15px; font-size:20px; border-left:3px solid #fef8e1; border-right:3px solid #fef8e1;}
	.evtNoti li {font-size:17px; padding-left:20px; margin-top:6px;}
	.evtNoti li:after {top:5px; width:3px; height:3px; border:3px solid #ffc101;}
}
</style>
<script>
$(function(){
	showSwiper= new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		pagination:'.hPagination',
		paginationClickable:true,
		speed:180
	});
	$('.swiper .arrowPrev').on('click', function(e){
		e.preventDefault()
		showSwiper.swipePrev()
	});
	$('.swiper .arrowNext').on('click', function(e){
		e.preventDefault()
		showSwiper.swipeNext()
	});
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
		showSwiper.reInit();
		clearInterval(oTm);
		}, 1);
	});

	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		$('a.ma').css('display','block');
	}else{
		$('a.mw').css('display','block');
	}
});

function jsvipgo(){
	<% if Not(IsUserLoginOK) then %>
		jsChklogin('<%=IsUserLoginOK%>');
		return false;
	<% else %>
		<% if GetLoginUserLevel() = 3 or GetLoginUserLevel() = 4 then %>
			$(".sectionA").css("display","none");
			$(".sectionB").css("display","block");
		<% else %>
			alert('VIP 등급만 참여 하실 수 있습니다.');
		<% end if %>
	<% end if %>
}

function jsSubmitComment(){
	var frm = document.frmorder
	<% if Not(IsUserLoginOK) then %>
		jsChklogin('<%=IsUserLoginOK%>');
		return false;
	<% end if %>

	if(!frm.reqname.value){
		alert("이름을 입력 해 주세요");
		frm.reqname.focus();
		return false;
	}

	if(!frm.reqhp1.value){
		alert("휴대폰번호를 입력 해주세요");
		frm.reqhp1.focus();
		return false;
	}

	if(!frm.reqhp2.value){
		alert("휴대폰번호를 입력 해주세요");
		frm.reqhp2.focus();
		return false;
	}

	if(!frm.reqhp3.value){
		alert("휴대폰번호를 입력 해주세요");
		frm.reqhp3.focus();
		return false;
	}

	if(!frm.txZip1.value){
		alert("우편번호를 입력 해주세요");
		frm.txZip1.focus();
		return false;
	}

	if(!frm.txZip2.value){
		alert("우편번호를 입력 해주세요");
		frm.txZip2.focus();
		return false;
	}

	if (frm.txAddr1.value.length<1){
        alert('수령지 도시 및 주를  입력하세요.');
        frm.txAddr1.focus();
        return false;
    }

    if (frm.txAddr2.value.length<1){
        alert('수령지 상세 주소를  입력하세요.');
        frm.txAddr2.focus();
        return false;
    }

	frm.mode.value = "inst";
	frm.action = "/event/etc/doeventsubscript/doEventSubscript62225.asp";
	frm.submit();
	return;
}

function chgaddr(v){
	var frm = document.frmorder

	if (v == "N")
	{
		frm.reqname.value = "";
		frm.reqhp1.value = "";
		frm.reqhp2.value = "";
		frm.reqhp3.value = "";
		frm.txZip1.value = "";
		frm.txZip2.value = "";
		frm.txAddr1.value = "";
		frm.txAddr2.value = "";
	}else if (v == "R"){
		frm.reqname.value = frm.tmp_reqname.value;
		frm.reqhp1.value = frm.tmp_reqhp1.value;
		frm.reqhp2.value = frm.tmp_reqhp2.value;
		frm.reqhp3.value = frm.tmp_reqhp3.value;
		frm.txZip1.value = frm.tmp_txZip1.value;
		frm.txZip2.value = frm.tmp_txZip2.value;
		frm.txAddr1.value = frm.tmp_txAddr1.value;
		frm.txAddr2.value = frm.tmp_txAddr2.value;
	}

}

</script>
<% if isApp=1 then %>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js"></script>
<% end if %>
</head>
<body>
<div class="vipGift">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/62225/tit_vip_honey.gif" alt="단지 널 사랑해" /></h2>
	<div class="swiperWrap">
		<div class="swiper">
			<div class="swiper-container swiper1">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62225/img_slide01.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62225/img_slide02.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62225/img_slide03.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62225/img_slide04.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62225/img_slide05.jpg" alt="" /></div>
				</div>
			</div>
			<button type="button" class="btnNav arrowPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62225/btn_prev.png" alt="이전" /></button>
			<button type="button" class="btnNav arrowNext"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62225/btn_next.png" alt="다음" /></button>
		</div>
		<div class="hPagination"></div>
	</div>
	<div class="vipGiftContainer">
		<div class="vipCont">
			<div class="vipArea">
				<% If allcnt < 3900 Then %>
				<div class="sectionA">
					<p class="vipBox"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61493/txt_greeting.png" alt="VIP 고객님 안녕하세요!" /></p>
					<p class="goBtn" onclick="jsvipgo();"><span><img src="http://webimage.10x10.co.kr/eventIMG/2015/61493/btn_enter.png" alt="VIP고객 입장하기" /></span></p>
				</div>
				<div class="sectionB" style="display:none;">
					<%If oUserInfo.FresultCount >0 Then %>
					<form name="frmorder" method="post">
					<input type="hidden" name="reqphone1"/>
					<input type="hidden" name="reqphone2"/>
					<input type="hidden" name="reqphone3"/>
					<input type="hidden" name="mode"/>
					<input type="hidden" name="tmp_reqname" value="<%=oUserInfo.FOneItem.FUserName%>"/>
					<input type="hidden" name="tmp_reqhp1" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",0) %>"/>
					<input type="hidden" name="tmp_reqhp2" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",1) %>"/>
					<input type="hidden" name="tmp_reqhp3" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",2) %>"/>
					<input type="hidden" name="tmp_txZip1" value="<%= Splitvalue(oUserInfo.FOneItem.FZipCode,"-",0) %>"/>
					<input type="hidden" name="tmp_txZip2" value="<%= Splitvalue(oUserInfo.FOneItem.FZipCode,"-",1) %>"/>
					<input type="hidden" name="tmp_txAddr1" value="<%= doubleQuote(oUserInfo.FOneItem.FAddress1) %>"/>
					<input type="hidden" name="tmp_txAddr2" value="<%= doubleQuote(oUserInfo.FOneItem.FAddress2) %>"/>
					<div class="vipBox">
						<p class="tit"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61493/txt_check_address.png" alt="배송지 주소 확인" /></p>
						<div class="checkAddr">
							<p class="ct">
								<span><input type="radio" id="addr01" name="addr" value="1" onclick="chgaddr('R');"  checked/> <label for="addr01">기본 주소</label></span>
								<span class="lPad10"><input type="radio" id="addr02" name="addr" value="2" onclick="chgaddr('N');"/> <label for="addr02"> 새로운 주소</label></span>
							</p>
							<ul>
								<li>
									<strong>이름</strong>
									<div><input type="text" value="<%=oUserInfo.FOneItem.FUserName%>" name="reqname"/></div>
								</li>
								<li>
									<strong>휴대폰</strong>
									<div>
										<input type="tel" class="w25p ct" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",0) %>" name="reqhp1"/> -
										<input type="tel" class="w25p ct" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",1) %>" name="reqhp2"/> -
										<input type="tel" class="w25p ct" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",2) %>" name="reqhp3"/>
									</div>
								</li>
								<li>
									<strong>주소</strong>
									<div>
										<input type="text" class="w25p ct" value="<%= Splitvalue(oUserInfo.FOneItem.FZipCode,"-",0) %>" name="txZip1" ReadOnly/> - <input type="text" class="w25p ct" value="<%= Splitvalue(oUserInfo.FOneItem.FZipCode,"-",1) %>" name="txZip2" ReadOnly/> 
										<span class="button btB2 btGry cBk1 lMar05"><a href="" <% If isapp <> "1" Then %>onclick="fnOpenModal('/lib/pop_searchzip.asp?target=frmorder&gb=3'); return false;"<% Else %>onclick="TnFindZip('frmorder','1'); return false;"<% End If %>>우편번호 찾기</a></span>
										<p class="tMar05"><input type="text" name="txAddr1" value="<%= doubleQuote(oUserInfo.FOneItem.FAddress1) %>"/></p>
										<p class="tMar05"><input type="text" name="txAddr2" value="<%= doubleQuote(oUserInfo.FOneItem.FAddress2) %>"/></p>
									</div>
								</li>
							</ul>
						</div>
						<div class="tip">
							<p>★ 위 주소는 기본 회원 정보 주소이며, 수정가능합니다.</p>
							<p>★ [VIP GIFT 받기]를 클릭하셔야 신청이 완료되며,<br />완료된 후에는 주소를 변경하실 수 없습니다.</p>
						</div>
					</div>
					<p class="goBtn" onclick="jsSubmitComment();return false;"><span><img src="http://webimage.10x10.co.kr/eventIMG/2015/61493/btn_submit.png" alt="VIP GIFT 받기" /></span></p>
					</form>
					<% End If %>
				</div>
				<% Else %>
				<div class="sectionC">
					<p class="vipBox"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61493/txt_greeting.png" alt="VIP 고객님 안녕하세요!" /></p>
					<p class="tPad15"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61493/txt_soldout.png" alt="사은품이 모두 소진되었습니다. 감사합니다." /></p>
				</div>
				<% End If %>
			</div>
		</div>
		<dl class="evtNoti">
			<dt><span>이벤트 유의사항</span></dt>
			<dd>
				<ul>
					<li>텐바이텐 VIP SILVER, VIP GOLD 고객만 신청이 가능합니다.</li>
					<li>경품 신청 후에는 주소지 변경이 불가합니다.</li>
					<li>본 사은품은 한정수량으로 조기에 선착순 마감 될 수 있으며,<br />1차 : 5월 14일(목) 2차 : 5월 21(목) 배송 될 예정입니다.</li>
					<li>경품은 현금성 환불 및 옵션 선택이 불가합니다.</li>
				</ul>
			</dd>
		</dl>
	</div>
</div>
<form name="frmC" method="get" action="/shoppingtoday/couponshop_process.asp" style="margin:0px;">
<input type="hidden" name="stype" value="">
<input type="hidden" name="idx" value="">
</form>
</body>
</html>
<%
	Set oUserInfo = nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->