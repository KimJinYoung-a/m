<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 	쿨링을 부탁해
' History : 2017.07.10 유태욱
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim eCode, vUserID, itemid, itemcnt

IF application("Svr_Info") = "Dev" THEN
	eCode = "66384"
	itemid = 523796
Else
	eCode = "78942"
	itemid = 1745595
End If

itemcnt = getitemlimitcnt(itemid)

vUserID = getEncLoginUserID
%>
<style type="text/css">
.mEvt78942 {position:relative;}
.mEvt78942 button {background-color:transparent;}
.swiper {position:relative; background:#1f88e1 url(http://webimage.10x10.co.kr/eventIMG/2017/78942/m/bg_rolling.png) no-repeat 0 0; background-size:100% auto;} 
.swiper .pagination {position:absolute; left:0; bottom:1rem; z-index:30; width:100%; height:auto; padding-top:0; text-align:center;}
.swiper .pagination span {display:inline-block; width:0.6rem; height:0.6rem; margin:0 0.5rem; border:0; background-color:#8fc4f0; transition:all .2s; border-radius:50%; box-shadow:0 0 0.3rem 0.2rem rgba(24,107,177,.8);}
.swiper .pagination .swiper-active-switch {background-color:#fff; transform:scale(1.8);}
.swiper .limit {position:absolute; right:6%; top:12%; width:21.25%; z-index:30;}
.enterCode { background:#1f88e1;}
.enterCode div {padding:0 4.68% 3.5rem;}
.enterCode input {width:100%; height:4.8rem; font-size:1.5rem; font-weight:600; color:#000; text-align:center; border:0; background:#fff; border-radius:0;}
.enterCode .btnSubmit {width:100%;}
.evtNoti {padding:3.5em 4.6%; text-align:left; background:#737373;}
.evtNoti h3 {padding-bottom:0.5rem; font-size:1.6rem; font-weight:600; color:#efefef;}
.evtNoti li {position:relative; font-size:1rem; line-height:1.5rem; color:#d8d8d8; padding-left:1.1rem; margin-top:0.8rem;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.5rem; width:0.25rem; height:0.25rem; background-color:#d8d8d8; border-radius:50%;}
.buyLayer {position:fixed; left:0; top:0; z-index:1000; width:100%; height:100%; padding:5rem 6.5% 0; background-color:rgba(0,0,0,.7);}
.buyLayer .layerCont {position:relative;}
.buyLayer .layerCont .btnClose {position:absolute; right:0; top:0; width:13%;}
</style>
<script type="text/javascript">
$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt78942").offset().top}, 0);
});

$(function(){
	mySwiper = new Swiper('.swiper .swiper-container',{
		loop:true,
		autoplay:2700,
		speed:600,
		effect:"fade",
		pagination:".pagination"
	});

	// 쿠폰레이어
	$(".buyLayer").hide();
	$(".btnClose").click(function(){
		$(".buyLayer").hide();
	});
});

function fnCouponDownload() {
	<% If vUserID = "" Then %>
		<% if isApp then %>
			parent.calllogin();
		<% else %>
			parent.jsevtlogin();
		<% end if %>
	<% End If %>
	<% If vUserID <> "" Then %>
	var reStr;
	var cpn = $("#couponnum").val();
	if (cpn == '' || GetByteLength(cpn) > 16){
		alert("Error05:쿠폰번호를 확인해 주세요.");
		document.location.reload();
		return false;
	}
	var str = $.ajax({
		type: "GET",
		url:"/event/etc/doeventsubscript/doEventSubscript78942.asp",
		data: "mode=down&couponnum="+cpn,
		dataType: "text",
		async: false
	}).responseText;
		reStr = str.split("||");
		if(reStr[0]=="11"){
			$("#buyLayer").fadeIn();
			return false;
		}else if(reStr[0]=="12"){
			alert(reStr[1]);
			document.location.reload();
			return false;
		}else if(reStr[0]=="00"){
			alert(reStr[1]);
			return false;
		}else if(reStr[0]=="13"){
			alert(reStr[1]);
			document.location.reload();
			return false;
		}else{
			errorMsg = reStr[1].replace(">?n", "\n");
			alert(errorMsg);
			document.location.reload();
			return false;
		}
	<% End If %>
}
</script>

	<!-- 쿨링을 부탁해 -->
	<div class="mEvt78942">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/78942/m/tit_cooling.png" alt="바캉스 쿠폰팩" /></h2>
		<div class="swiper">
			<% if isapp then %>
				<a href="" onclick="fnAPPpopupProduct('1745595&pEtr=78942'); return false;">
			<% else %>
				<a href="/category/category_itemprd.asp?itemid=1745595&pEtr=78942">
			<% end if %>
				
				<%'' 판매중(품절시 .swiper-container 영역 노출되지 않음 %>
				<% if itemcnt > 0 then %>
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78942/m/img_item_1.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78942/m/img_item_2.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78942/m/img_item_3.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78942/m/img_item_4.jpg" alt="" /></div>
						</div>
						<div class="pagination"></div>
						<p class="limit"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78942/m/txt_limit.png" alt="선착순 5천명" /></p>
					</div>
				<% else %>
					<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78942/m/txt_soldout.jpg" alt="수량이 모두 소진되었습니다!" /></p>
				<% end if %>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/78942/m/txt_item.png" alt="마기쏘 쿨링 세라믹 텀블러 (2개) 쿠폰할인가 25,000원" /></p>
			</a>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/78942/m/txt_tip.png" alt="할인가에 구매하려면? 하나멤버스 or 시럽에서 쿠폰 번호 확인 → 텐바이텐에서 쿠폰 번호 입력 후 등록 → 결제페이지에서 쿠폰 선택하여 결제하면 완료!" /></p>

		<%'' 쿠폰번호 입력 %>
		<div class="enterCode">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/78942/m/txt_num.png" alt="쿠폰 번호를 입력해주세요" /></p>
			<div>
				<input type="text" name="couponnum" id="couponnum" value="" maxlength = "16" placeholder="쿠폰번호 입력" />
				<button type="button" onclick="fnCouponDownload(); return false;" class="btnSubmit"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78942/m/btn_submit.png" alt="등록하기" /></button>
			</div>
		</div>

		<%' 발급완료 레이어 %>
		<div class="buyLayer" id="buyLayer" style="display:none">
			<div class="layerCont">
				<a href="/category/category_itemPrd.asp?itemid=1745595&amp;pEtr=78942" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78942/m/img_enroll.jpg" alt="쿠폰이 등록되었습니다. 할인가에 구매해보세요!" /></a>
				<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1745595&pEtr=78942" onclick="fnAPPpopupProduct('1745595&amp;pEtr=78942');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78942/m/img_enroll.jpg" alt="쿠폰이 등록되었습니다. 할인가에 구매해보세요!" /></a>
				<button type="button" class="btnClose"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78942/m/btn_close.png" alt="닫기" /></button>
			</div>
		</div>

		<div class="evtNoti">
			<h3>유의사항</h3>
			<ul>
				<li>본 이벤트는 텐바이텐과 하나멤버스, 그리고 시럽회원님을 대상으로 진행됩니다. (비회원 구매 불가)</li>
				<li>ID당 한 세트(2개입)씩만 구매가 가능합니다.</li>
				<li>상품은 즉시결제로만 결제가 가능하며, 배송 후에는 반품/교환/구매 취소가 불가능합니다.</li>
				<li>이벤트는 쿠폰 소지 여부와는 상관없이 재고 소진 시 마감됩니다.</li>
			</ul>
		</div>
	</div>
	<!--// 쿨링을 부탁해 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->
