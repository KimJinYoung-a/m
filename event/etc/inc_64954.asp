<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : vip 전용 단지널 사랑해 2차 연장 for mobile & app
' History : 2015-07-21 이종화
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<%
	Dim eCode , vQuery , allcnt
	IF application("Svr_Info") = "Dev" THEN
		eCode		=  64835
	Else
		eCode		=  64954
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
.vipGift .topic p {visibility:hidden; width:0; height:0;}
.swiperWrap {position:relative; padding-bottom:7.5%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/62225/bg_slide.gif) no-repeat left top; background-size:100% 100%;}
.swiperWrap .hPagination {position:absolute; bottom:0; left:0; width:100%; height:10px; text-align:center; z-index:100;}
.swiperWrap .hPagination span {display:inline-block; position:relative; width:10px; height:10px; margin:0 4px; border-radius:50%; background:#fff; cursor:pointer; vertical-align:top;}
.swiperWrap .hPagination .swiper-active-switch {background:#703f26;}
.swiper {position:relative; margin:0 3.125%; padding:5px; background:#fff; box-shadow:0 0 3px rgba(0,0,0,.25);}
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
.noti {padding:14% 0 10%;}
.noti h3 {color:#444; margin-bottom:15px;}
.noti h3 span {padding:0 10px; font-size:13px; line-height:1; font-weight:bold; border-left:2px solid #fef8e1; border-right:2px solid #fef8e1; vertical-align:top;}
.noti ul li {position:relative; color:#444; font-size:11px; line-height:1.3; padding-left:13px; margin-top:4px;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:inline-block; position:absolute; left:0; top:3px; width:2px; height:2px; border:2px solid #ffc101; border-radius:50%;}

@media all and (min-width:360px){
	.swiper {padding:6px;}
}
@media all and (min-width:480px){
	.swiper { padding:7px;}
	.vipCont .sectionB .tit {padding:42px 0 30px;}
	.vipCont .checkAddr {padding-top:30px; font-size:18px;}
	.vipCont .checkAddr label {padding-left:7px; margin-top:3px;}
	.vipCont .checkAddr ul {padding:30px 23px 0;}
	.vipCont .checkAddr li {padding-bottom:24px;}
	.vipCont .checkAddr li strong {line-height:55px;}
	.vipCont .checkAddr li input {line-height:18px;}
	.vipCont .checkAddr .button a {padding-left:7px; padding-right:7px;}
	.vipCont .tip p {font-size:17px; padding:0 0 4px 18px; text-indent:-18px;}
	.noti h3{margin-bottom:23px;}
	.noti h3 span {padding:0 15px; font-size:20px; border-left:3px solid #fef8e1; border-right:3px solid #fef8e1;}
	.noti ul li {font-size:17px; padding-left:20px; margin-top:6px;}
	.noti ul li:after {top:5px; width:3px; height:3px; border:3px solid #ffc101;}
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
	frm.action = "/event/etc/doeventsubscript/doEventSubscript64954.asp";
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
<div class="vipGift">
	<div class="topic">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/64954/tit_vip_honey.png" alt="단지 널 사랑해" /></h2>
		<p>VIP 가 처음이라면, 놓치지 말고 신청하세요! 달콤 가득한 선물을 보내드립니다.</p>
		<p>주소 입력 기간은 7월 23일부터 7월 31일까지며, 배송일은 8월 1일부터 순차적으로 배송됩니다. 한정 수량으로 조기 소진될 수 있습니다.</p>
	</div>
	<div class="swiperWrap">
		<div class="swiper">
			<div class="swiper-container swiper1">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64954/img_slide_01.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64954/img_slide_02.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64954/img_slide_03.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64954/img_slide_04.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64954/img_slide_05.jpg" alt="" /></div>
				</div>
			</div>
			<button type="button" class="btnNav arrowPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64954/btn_prev.png" alt="이전" /></button>
			<button type="button" class="btnNav arrowNext"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64954/btn_next.png" alt="다음" /></button>
		</div>
		<div class="hPagination"></div>
	</div>
	<div class="vipGiftContainer">
		<div class="vipCont">
			<div class="vipArea">
				<% If allcnt < 500 Then %>
				<div class="sectionA">
					<p class="vipBox"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64954/txt_greeting_v1.png" alt="VIP 고객님 안녕하세요! 정성스럽게 준비한 선물과 함께 인사를 전합니다. 우리의 일상이 더욱 달콤해 지기를, 일상 속 꿀맛 같은 텐바이텐이 되기를 바랍니다. 늘 텐바이텐을 사랑해 주셔서 감사합니다." /></p>
					<p class="goBtn" onclick="jsvipgo();"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64954/btn_enter.png" alt="VIP고객 입장하기" /></p>
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
						<p class="tit"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64954/txt_check_address.png" alt="배송지 주소 확인" /></p>
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
					<p class="goBtn" onclick="jsSubmitComment();return false;"><span><img src="http://webimage.10x10.co.kr/eventIMG/2015/64954/btn_submit.png" alt="VIP GIFT 받기" /></span></p>
					</form>
					<% End If %>
				</div>
				<% Else %>
				<div class="sectionC">
					<p class="vipBox"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64954/txt_greeting_v1.png" alt="VIP 고객님 안녕하세요! 정성스럽게 준비한 선물과 함께 인사를 전합니다. 우리의 일상이 더욱 달콤해 지기를, 일상 속 꿀맛 같은 텐바이텐이 되기를 바랍니다. 늘 텐바이텐을 사랑해 주셔서 감사합니다." /></p>
					<p class="tPad15"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64954/txt_soldout.png" alt="사은품이 모두 소진되었습니다. 감사합니다." /></p>
				</div>
				<% End If %>
			</div>
		</div>
		<div class="noti">
			<h3><span>이벤트 유의사항</span></h3>
			<ul>
				<li>ID당 1회만 신청이 가능해요!</li>
				<li>사은품 신청 후에는 주소지 변경이 불가해요!</li>
				<li>VIP SILVER, VIP GOLD 고객만 신청이 가능해요!</li>
			</ul>
		</div>
	</div>
</div>
<%
	Set oUserInfo = nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->