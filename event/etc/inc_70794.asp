<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 바람이 불어왕 MA
' History : 2016.05.19 김진영 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<% '<!-- #include virtual="/lib/inc/head.asp" --> %>
<%
Dim eCode, userid, currenttime, i, couponidx, selectitemid
currenttime	= now()
userid		= GetEncLoginUserID()

If application("Svr_Info") = "Dev" Then
	eCode			= "66133"
	couponidx		= "11135"
	selectitemid	= "1238955"
Else
	eCode			= "70794"
	couponidx		= "11649"
	selectitemid	= "1492386"
End If

Dim subscriptcount, itemcouponcount
subscriptcount	= 0
itemcouponcount	= 0

'//본인 참여 여부
If userid <> "" Then
	subscriptcount	= getevent_subscriptexistscount(eCode, userid, "", "", "")
	itemcouponcount = getitemcouponexistscount(userid, couponidx, "", "")
End If
'response.write GetUserStrlarge(GetLoginUserLevel) & "/" & GetLoginUserLevel

Dim administrator
	administrator = FALSE

If GetLoginUserID = "greenteenz" or GetLoginUserID = "djjung" or GetLoginUserID = "bborami" or GetLoginUserID = "kyungae13" or GetLoginUserID = "jinyeonmi" or GetLoginUserID = "thensi7" or GetLoginUserID = "baboytw" or GetLoginUserID = "kobula" or GetLoginUserID = "kjy8517" Then
	administrator = TRUE
End If
%>
<style type="text/css">
img {vertical-align:top;}

html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

.mEvt70794 button {background-color:transparent;}

.rolling .swiper {position:relative;}
.rolling .swiper .swiper-container {width:100%;}
.rolling button {position:absolute; top:30%; z-index:10; width:16.09%;}
.rolling .swiper .btn-prev {left:0;}
.rolling .swiper .btn-next {right:0;}
.rolling .swiper .pagination {position:absolute; top:63%; left:0; z-index:10; width:100%; height:auto; padding-top:0; text-align:center;}
.rolling .swiper .pagination .swiper-pagination-switch {display:inline-block; width:6px; height:6px; margin:0 4px; background-color:#fff; cursor:pointer; transition:background-color 0.7s ease; box-shadow:0 0 5px rgba(0,0,0,0.2);}
.rolling .swiper .pagination .swiper-active-switch {background-color:#52c8df;}

@media all and (min-width:360px){
	.rolling .swiper .pagination .swiper-pagination-switch {width:8px; height:8px;}
}
@media all and (min-width:480px){
	.rolling .swiper .pagination .swiper-pagination-switch {width:10px; height:10px; margin:0 6px;}
}
@media all and (min-width:768px){
	.rolling .swiper .pagination .swiper-pagination-switch {width:16px; height:16px; margin:0 10px;}
}

.guide {position:relative;}
.guide .btnGet {position:absolute; bottom:12%; left:50%; width:73.43%; margin-left:-37.215%;}

.lyView {display:none; position:absolute; top:11%; left:50%; z-index:30; width:88.125%; margin-left:-44.0625%;}
.lyView .btnClose {position:absolute; top:3%; right:3%; width:14.18%;}
#dimmed {display:none; position:absolute; top:0; left:0; z-index:20; width:100%; height:100%; background:rgba(0,0,0,.6);}

.noti {background-color:#8eca59;}
.noti ul {padding:0 4.68%;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#f8f8f8; font-size:1rem; line-height:1.5em;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.5rem; left:0; width:0.4rem; height:0.1rem; background-color:#f8f8f8;}
.noti p {margin-top:7%;}
.noti .btnGrade {display:block; width:10.5rem; margin:0.3rem 0 0.7rem;}
</style>
<script type="text/javascript">
$(function(){
	/* swiper js */
	mySwiper = new Swiper("#rolling .swiper",{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		autoplay:3000,
		speed:800,
		pagination:"#rolling .pagination",
		paginationClickable:true,
		autoplayDisableOnInteraction:false,
		nextButton:"#rolling .btn-next",
		prevButton:"#rolling .btn-prev",
		effect:"fade"
	});
});

function pop_Benefit(){
	var pop_Benefit = window.open('/my10x10/userinfo/pop_Benefit.asp','addreg','width=400,height=400,scrollbars=yes,resizable=yes');
	pop_Benefit.focus();
}

function jscoupondown(){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2016-05-18" and left(currenttime,10)<"2016-05-30" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if GetLoginUserLevel<>"5" and not(administrator) then %>
				alert("고객님은 쿠폰발급 대상이 아닙니다.");
				return;
			<% else %>
				<% if administrator then %>
					alert("[관리자] 특별히 관리자님이니까 오렌지 등급이 아니여도 다음 단계로 진행 시켜 드릴께요!");
				<% end if %>
				var str = $.ajax({
					type: "POST",
					url: "/event/etc/doeventsubscript/doEventSubscript70794.asp",
					data: "mode=coupondown&isapp=<%= isapp %>",
					dataType: "text",
					async: false
				}).responseText;
				var str1 = str.split("||")
				if (str1[0] == "11"){
					$("#lyView").empty().html(str1[1]);
					$("#lyView").show();
					$("#dimmed").show();
					window.$('html,body').animate({scrollTop:100}, 500);
					return false;
				}else if (str1[0] == "10"){
					alert('데이터 처리에 예외 상황이 발생하였습니다. 관리자에게 문의해주십시오.');
					return false;
				}else if (str1[0] == "09"){
					$("#lyView").empty().html(str1[1]);
					$("#lyView").show();
					window.$('html,body').animate({scrollTop:100}, 500);
					//$('html,body').animate({scrollTop: $("#title").offset().top},'slow');
					return false;
				}else if (str1[0] == "08"){
					alert('기간이 종료되었거나 유효하지 않은 쿠폰입니다.');
					return false;
				}else if (str1[0] == "07"){
					alert('데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해주십시오.');
					return false;
				}else if (str1[0] == "06"){
					alert('쿠폰은 오전 10시부터 다운 받으실수 있습니다.');
					return false;
				}else if (str1[0] == "05"){
					alert('고객님은 쿠폰발급 대상이 아닙니다.');
					return false;
				}else if (str1[0] == "04"){
					$("#lyView").empty().html(str1[1]);
					$("#lyView").show();
					$("#dimmed").show();
					window.$('html,body').animate({scrollTop:100}, 500);
					return false;
				}else if (str1[0] == "03"){
					alert('이벤트 응모 기간이 아닙니다.');
					return false;
				}else if (str1[0] == "03"){
					alert('이벤트 응모 기간이 아닙니다.');
					return false;
				}else if (str1[0] == "02"){
					alert('로그인을 해주세요.');
					return false;
				}else if (str1[0] == "01"){
					alert('잘못된 접속입니다.');
					return false;
				}else if (str1[0] == "00"){
					alert('정상적인 경로가 아닙니다.');
					return false;
				}else{
					alert('오류가 발생했습니다.');
					return false;
				}
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End IF %>
}
function goDirOrdItem()
{
	<% if isapp="1" then %>
        document.directOrd.target = "iiBagWin";
	<% end if %>
	document.directOrd.submit();
}

function poplayerclose(){
	$("#lyView").hide();
	$("#dimmed").fadeOut();
}
</script>
<%' [M/A] 70794 첫구매 이벤트 - 바람이 불어왕 %>
<div class="mEvt70794">
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70794/m/txt_wind.gif" alt="아직 한번도 구매하지 않은 당신에게 귀여운 미니선풍기를 소개합니다!" /></p>

	<div id="rolling" class="rolling">
		<div class="swiper">
			<div class="swiper-container swiper">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70794/m/img_slide_01.jpg" alt="아이리뷰 USB 선풍기" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70794/m/img_slide_02.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70794/m/img_slide_03.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70794/m/img_slide_04.jpg" alt="" /></div>
				</div>
			</div>
			<div class="pagination"></div>
			<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70794/m/btn_prev.png" alt="이전" /></button>
			<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70794/m/btn_next.png" alt="다음" /></button>
		</div>
	</div>
	<div class="guide">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70794/m/txt_guide.jpg" alt="먼저 쿠폰을 발급 받고 구매하러 가기 후 쿠폰을 사용하여 결제합니다. 오늘 당신만을 위한 엄청난 쿠폰으로 첫 구매에 도전하세요!" /></p>
		<a href="" id="btnGet" class="btnGet" onclick="jscoupondown(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70794/m/btn_get.png" alt="쿠폰 받고 구매하러 가기" /></a>
	</div>
	<%' for dev msg : 레이어 팝업 %>
	<div id="lyView" class="lyView" style="display:none;"></div>
	<div class="noti">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/70794/m/tit_noti.png" alt="이벤트 유의사항" /></h3>
		<ul>
			<li>텐바이텐에서 한번도 구매이력이 없는 오렌지등급 고객님을 위한 이벤트입니다.
				<% If isapp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('10X10 등급혜택','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/userinfo/pop_Benefit.asp');return false;" class="btnGrade"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70794/m/btn_grade.png" alt="회원등급 보러가기" /></a>
				<% Else %>
					<a href="" onclick="window.open('/my10x10/userinfo/pop_Benefit.asp','addreg','width=400,height=400,scrollbars=yes,resizable=yes');return false;" class="btnGrade"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70794/m/btn_grade.png" alt="회원등급 보러가기" /></a>
				<% End If %>
			</li>
			<li>본 이벤트는 로그인 후에 참여가 가능합니다.</li>
			<li>ID 당 1회만 구매가 가능합니다.</li>
			<li>이벤트는 조기 마감 될 수 있습니다.</li>
			<li>이벤트틑 즉시결제로만 구매가 가능하며, 배송 후 반품/교환/구매취소가 불가능합니다.</li>
		</ul>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70794/m/img_ex.png" alt="주문결제 화면에서 할인정보에서 상품 쿠폰 선택 상자에서 바람이 불어왕 쿠폰을 선택해주세요" /></p>
	</div>
	<div id="dimmed"></div>
</div>
<% If isapp="1" Then %>
	<form method="post" name="directOrd" action="/apps/appCom/wish/web2014/inipay/shoppingbag_process.asp">
<% Else %>
	<form method="post" name="directOrd" action="/inipay/shoppingbag_process.asp">
<% End If %>
	<input type="hidden" name="itemid" value="<%=selectitemid%>">
	<input type="hidden" name="itemoption" value="0000">
	<input type="hidden" name="itemea" value="1">
<% If isapp="1" Then %>
	<input type="hidden" name="mode" value="DO3">
<% Else %>
	<input type="hidden" name="mode" value="DO1">
<% End If %>
</form>
<iframe src="" name="iiBagWin" frameborder="0" width="0" height="0"></iframe>
<!-- #include virtual="/lib/db/dbclose.asp" -->