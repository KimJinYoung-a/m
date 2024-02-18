<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description : [10x10 오감충족 이벤트 3탄] 밤이면, 밤마다! - mobile
' History : 2014.06.05 이종화 생성
'####################################################
	dim eCode, cnt, sqlStr, regdate , totalsum
	
	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "21193"
	Else
		eCode 		= "52391"
	End If

	If IsUserLoginOK Then
		'하루 1회 중복 응모 확인
		sqlStr="Select count(sub_idx) " &_
				" From db_event.dbo.tbl_event_subscript " &_
				" WHERE evt_code='" & eCode & "'" &_
				" and userid='" & GetLoginUserID() & "' and convert(varchar(10),regdate,120) = '" &  Left(now(),10) & "'"
		rsget.Open sqlStr,dbget,1
		cnt=rsget(0)
		rsget.Close

		'토탈 3회 중복 응모 확인
		sqlStr="Select count(sub_idx) " &_
				" From db_event.dbo.tbl_event_subscript " &_
				" WHERE evt_code='" & eCode & "'" &_
				" and userid='" & GetLoginUserID() & "'"
		rsget.Open sqlStr,dbget,1
		totalsum=rsget(0)
		rsget.Close
	End If
%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 밤이면 밤마다!</title>
<style type="text/css">
.mEvt52392 {background:#2390c8;}
.mEvt52392 img {vertical-align:top; width:100%;}
.mEvt52392 p {max-width:100%;}
.realNutsRecipe {padding-bottom:45px; }
.mEvt52392 .swiper {position:relative; border:4px solid #ffe432; width:486px; margin:0 auto;}
.mEvt52392 .swiper .swiper-container {overflow:hidden;}
.mEvt52392 .swiper .swiper-slide {float:left;}
.mEvt52392 .swiper .swiper-slide a {display:block; width:100%;}
.mEvt52392 .swiper .swiper-slide img {width:100%; vertical-align:top;}
.mEvt52392 .swiper .btnArrow {display:block; position:absolute; bottom:-45px; z-index:10; width:30px; height:30px; text-indent:-9999px; background-repeat:no-repeat; background-position:left top; background-size:100% auto;}
.mEvt52392 .swiper .arrow-left {left:27px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/52392/btn_prev.png);}
.mEvt52392 .swiper .arrow-right {right:27px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/52392/btn_next.png);}
.mEvt52392 .swiper .pagination {position:absolute; left:0; bottom:-40px; width:100%; text-align:center;}
.mEvt52392 .swiper .pagination span {position:relative; display:inline-block; width:12px; height:12px; margin:0 4px; cursor:pointer; border-radius:12px; background:#fff;}
.mEvt52392 .swiper .pagination .swiper-active-switch {background:#ffe432;}

.lateNightMeal {padding-bottom:33px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/52392/bg_select_meal.png) left top no-repeat; background-size:100% auto;}
.lateNightMeal .topBdr {width:92%; margin:0 auto; height:15px; border-radius:10px 10px 0 0; background:#ffef40;}
.lateNightMeal .selectMeal {width:92%; margin:0 auto; padding-bottom:40px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/52392/bg_pattern.png) left bottom no-repeat #fff; background-size:100% auto;}
.mEvt52392 .lateNightMeal .selectMeal ul {overflow:hidden; padding:0 5px;}
.mEvt52392 .lateNightMeal .selectMeal li {float:left; text-align:center; width:33%; padding-bottom:12px;}
.mEvt52392 .lateNightMeal .selectMeal li.m01 {padding-left:16.5%;}
.mEvt52392 .lateNightMeal .selectMeal li.m02 {}
.mEvt52392 .lateNightMeal .selectMeal li input {display:inline-block; margin-top:12px;}
.mEvt52392 .lateNightMeal .applyBtn {display:block; width:47%; margin:0 auto; padding:10px 0;}
.mEvt52392 .lateNightMeal .applyBtn input {width:100%;}

.mEvt52392 .giftNoti {position:relative; padding:24px 20px 25px 8px; background:#9dd1ec;}
.mEvt52392 .giftNoti .ball {position:absolute; right:0; top:-30%; width:165px;}
.mEvt52392 .giftNoti dl {text-align:left;}
.mEvt52392 .giftNoti dt {padding:0 0 12px 12px;}
.mEvt52392 .giftNoti li {color:#444; font-size:11px; line-height:15px; padding:0 0 5px 12px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/52392/blt_arrow.png) left 3px no-repeat; background-size:6px 7px;}
.mEvt52392 .giftNoti li strong {color:#d50c0c;}
@media all and (max-width:480px){
	.mEvt52392 .swiper {width:286px;}
	.mEvt52392 .giftNoti .ball {width:130px; top:-22%;}
}
</style>
<script src="/lib/js/swiper-2.1.min.js"></script>
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

	$("label img").on("click", function() {
		$("#" + $(this).parents("label").attr("for")).click();
	});
});
</script>
<script>
	function checkform(frm) {
	<% if datediff("d",date(),"2014-06-13")>=0 then %>
		<% If IsUserLoginOK Then %>
			<% If cnt > 0 Then %>
					alert('하루에 1회 응모 가능 합니다.');
					return false;
			<% else %>
				<% If totalsum = 3 Then %>
					alert('최대 3회 응모 가능합니다.');
					return false;
				<% else %>
					if(!(frm.spoint[0].checked||frm.spoint[1].checked||frm.spoint[2].checked||frm.spoint[3].checked||frm.spoint[4].checked))
					{
						alert("야식을 골라주세요!");
						return false;
					}

					frm.action = "doEventSubscript52391.asp";
					return true;
				<% end if %>
			<% end if %>
		<% Else %>
			parent.jsevtlogin();
		<% End If %>
	<% else %>
			alert('이벤트가 종료되었습니다.');
			return;
	<% end if %>
	}
</script>
</head>
<body>
<div class="mEvt52392">
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52392/tit_sense_ver03.png" alt="10X10 오감충족 사은이벤트 3탄" /></p>
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/52392/tit_night_meal.png" alt="밤이면 밤마다! - 브라질에서의 승전보를 기다리며! 밤이면, 밤마다! 텐바이텐의 야식파티가 열립니다!" /></h2>
	<dl class="realNutsRecipe">
		<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/52392/tit_night_party.png" alt="오직 5일동안만 열리는 텐바이텐의 심야파티! 텐바이텐에서 쇼핑하고, 야식선물 받으세요!" /></dt>
		<dd>
			<div class="swiper">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52392/img_realnuts_slide01.png" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52392/img_realnuts_slide02.png" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52392/img_realnuts_slide03.png" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52392/img_realnuts_slide04.png" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52392/img_realnuts_slide05.png" alt="" /></div>
					</div>
					<div class="pagination"></div>
				</div>
				<a class="btnArrow arrow-left" href="">Previous</a>
				<a class="btnArrow arrow-right" href="">Next</a>
			</div>
		</dd>
	</dl>
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/52392/img_gift.png" alt="20만원 이상 구매 시 더 리얼너츠 두번째 에디션 or 15,000원 할인 쿠폰 택1" /></div>
	<!-- 야식 응모하기 -->
	<div class="lateNightMeal">
		<p class="topBdr"></p>
		<form name="frm" method="POST" style="margin:0px;" onSubmit="return checkform(this);">
		<input type="hidden" name="eventid" value="<%=eCode%>">
		<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
		<input type="hidden" name="page" value="">
		<div class="selectMeal">
			<p class="tit"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52392/tit_win_news.png" alt="아니, 브라질에서의 승전보를 공복으로 기다릴 건가요? 6월 18일 첫승을 기원하며! 618명에게 야식을 쏩니다!" /></p>
			<ul>
				<li class="m01">
					<label for="meal01"><a href="/category/category_itemPrd.asp?itemid=1063797" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52392/img_meal01.png" alt="푸드트랩" /></a></label>
					<input type="radio" id="meal01" name="spoint" value="1" />
				</li>
				<li class="m02">
					<label for="meal02"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52392/img_meal02.png" alt="도미노피자" /></label>
					<input type="radio" id="meal02" name="spoint" value="1" />
				</li>
				<li class="m03">
					<label for="meal03"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52392/img_meal03.png" alt="KFC" /></label>
					<input type="radio" id="meal03" name="spoint" value="1" />
				</li>
				<li class="m04">
					<label for="meal04"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52392/img_meal04.png" alt="롯데리아" /></label>
					<input type="radio" id="meal04" name="spoint" value="1" />
				</li>
				<li class="m05">
					<label for="meal05"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52392/img_meal05.png" alt="세븐일레븐/바이더웨이" /></label>
					<input type="radio" id="meal05" name="spoint" value="1" />
				</li>
			</ul>
			<span class="applyBtn"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/52392/btn_apply.png" alt="야식 응모하기" /></span>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52392/txt_cmt.png" alt="하루에 1번, 아이디당 최대 3회 응모가능" /></p>
		</div>
		</form>
	</div>
	<!--// 야식 응모하기 -->
	<div class="giftNoti">
		<p class="ball"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52392/bg_ball.png" alt="" /></p>
		<dl>
			<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/52392/tit_noti.png" alt="사은품 선택 시 유의사항" style="width:74px;" /></dt>
			<dd>
				<ul>
					<li>텐바이텐 사은 이벤트는 텐바이텐 회원님을 위한 혜택입니다. (비회원 구매 증정 불가)</li>
					<li>사은품은 한정수량이므로, 수량이 모두 소진 될 경우에는 이벤트가 자동 종료됩니다</li>
					<li>상품 쿠폰, 보너스 쿠폰, 할인카드 등의 사용 후 <strong>구매확정 금액이 20만원</strong> 이어야 합니다.</li>
					<li>20만원/ 25만원 구매 시, 텐바이텐 배송상품을 반드시 포함해야 사은품을 받을 수 있습니다.</li>
					<li>마일리지, 예치금, GIFT 카드를 사용하신 경우는 구매확정금액에 포함되어 사은품을 받으실 수 있습니다.</li>
					<li>한 주문 건이 구매금액 기준 이상일 때 증정하며 다른 주문에 대한 누적적용이 되지 않습니다.</li>
					<li>사은품의 경우 구매하신 텐바이텐 배송 상품과 함께 배송됩니다</li>
					<li>7,000원 할인 쿠폰은 6월30일 오전 10시에 일괄 발송되며, 사용기간은 7월 13일까지 입니다.</li>
					<li>GIFT 카드를 구매하신 경우는 사은품과 사은 쿠폰이 증정되지 않습니다.</li>
					<li>환불이나 교환 시, 최종 구매 가격이 사은품 수령 가능 금액 미만이 될 경우, 사은품과 함께 반품해야 합니다.</li>
					<li>응모이벤트는 6월16일 당첨자 발표를 하며, 기프티콘은 6월17일 오후 3시 전후에 일괄 발송될 예정입니다.</li>
				</ul>
			</dd>
		</dl>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->