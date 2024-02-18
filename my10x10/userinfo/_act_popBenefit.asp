<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	Description : 나의 회원등급 정보(Modal Popup)
'	History	:  2016.07.22 허진원 생성
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<script type='text/javascript'>
var benefitScroll;
$(function(){
	var myGrade = $('.gradeBenefitV16a').attr('id');
	$('.gradeBenefitV16a .mGrade').addClass(myGrade);

	$('.gradeListV16a .showHideV16a').find('.tglContV16a').hide();
	$('.gradeListV16a').children('.'+myGrade).find('.tglContV16a').show(); /* 로딩시 회원 본인 등급 안내가 열려있도록 제어 */

	benefitScroll = new Swiper('.gradeBenefitWrapV16a .swiper-container', {
		scrollbar:'.gradeBenefitWrapV16a .swiper-scrollbar',
		direction:'vertical',
		slidesPerView:'auto',
		mousewheelControl:true,
		freeMode:true,
		resistanceRatio:0
	});

	$('.mVVIP .grTxtV16a').text('VVIP');
	$('.mVIPGOLD .grTxtV16a').text('VIP GOLD');
	$('.mVIPSILVER .grTxtV16a').text('VIP SILVER');
	$('.mBLUE .grTxtV16a').text('BLUE');
	$('.mGREEN .grTxtV16a').text('GREEN');
	$('.mYELLOW .grTxtV16a').text('YELLOW');
	$('.mORANGE .grTxtV16a').text('ORANGE');
	$('.mSTAFF .grTxtV16a').text('STAFF'); 
	$('.mFAMILY .grTxtV16a').text('FAMILY');

	/* show-hide */
	$('.showHideV16a .tglBtnV16a').click(function(){
		if($(this).parent().parent().hasClass('gradeListV16a')) {
			$('.gradeListV16a .showHideV16a .tglContV16a').hide();
			$('.gradeListV16a .showHideV16a .tglBtnV16a').addClass('showToggle');
		}
		if ($(this).hasClass('showToggle')) {
			$(this).removeClass('showToggle');
			$(this).parents('.showHideV16a').find('.tglContV16a').show();
		} else {
			$(this).addClass('showToggle');
			$(this).parents('.showHideV16a').find('.tglContV16a').hide();
		}
		$('.gradeBenefitWrapV16a .swiper-wrapper').css('transform','translate3d(0, 0, 0)');
		benefitScroll.onResize();
	});

	$('.gradeListV16a .showHideV16a .tglContV16a').each(function(){
		if ($(this).is(':hidden')==true){
			$(this).parents('.showHideV16a').find('.tglBtnV16a').addClass('showToggle');
		} else {
			$(this).parents('.showHideV16a').find('.tglBtnV16a').removeClass('showToggle');
		}
	});
});

function fnGotoVIPLounge() {
	location.href = "/my10x10/viplounge.asp";
}

</script>
<div class="layerPopup" style="background-color:#e7eaea;">
	<div class="popWin">
		<div class="header">
			<h1>10X10 등급혜택</h1>
			<p class="btnPopClose"><button onclick="fnCloseModal();" class="pButton">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content">
			<div class="gradeBenefitWrapV16a">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide">
							<div class="gradeBenefitV16a" id="<%= GetUserLevelCSSClass %>">
								<div class="bxWt1V16a mGrade">
									<div class="fs1-5r ct"><strong class="cBk1V16a"><%=GetLoginUserName%></strong>님은 <span class="grTxtV16a"></span>등급입니다.</div>
								</div>

								<div class="gradeListV16a">
									<dl class="showHideV16a mVVIP">
										<dt class="bxLGy2V16a grpTitV16a tglBtnV16a"><h2 class="hasArrow grTxtV16a"></h2></dt>
										<dd class="bxWt1V16a infoUnitV16a tglContV16a">
											<dl class="infoArrayV16a">
												<dt>선정기준</dt>
												<dd>결제금액 300만원 이상</dd>
											</dl>
											<dl class="infoArrayV16a">
												<dt class="vTop">할인혜택</dt>
												<dd class="vTop">
													<ul class="cartInfoV16a">
														<li><span class="cRd1V16a">10%</span> 쿠폰 2장</li>
														<li><span class="cRd1V16a">3천원</span> 쿠폰 2장</li>
														<li><span class="cRd1V16a">1만원</span> 쿠폰 1장 (10만원이상 구매 시)</li>
														<li><span class="cRd1V16a">3만원</span> 쿠폰 1장 (20만원이상 구매 시)</li>
														<li>3개월 연속 VVIP 유지 시 <span class="cRd1V16a">7천원</span> 쿠폰 2장 <span>(5만원이상 구매 시)</span></li>
													</ul>
												</dd>
											</dl>
											<dl class="infoArrayV16a">
												<dt class="vTop">등급혜택</dt>
												<dd class="vTop">
													<ul class="cartInfoV16a">
														<li>텐바이텐 배송상품 무료배송</li>
														<li>구매금액 적립비율 1%+0.3%</li>
														<!-- li>더핑거스 강좌 15% 쿠폰 1장</li -->
														<li>히치하이커 무료지급 (신청기간 내 주소확인 시)</li>
														<li>VIP GIFT 연2회 신청가능</li>
														<li>최초 VVIP 등급 달성 시 special gift 증정 <span>(신청기간 내 주소확인 시)</span></li>
														<li>VIP LOUNGE 이용가능</li>
													</ul>
												</dd>
											</dl>
											<div class="btnAreaV16a">
												<p><button type="button" class="btnV16a btnRed1V16a" onclick="fnGotoVIPLounge();">VIP LOUNGE 바로가기</button></p>
											</div>
										</dd>
									</dl>
									<dl class="showHideV16a mVIPGOLD">
										<dt class="bxLGy2V16a grpTitV16a tglBtnV16a"><h2 class="hasArrow grTxtV16a"></h2></dt>
										<dd class="bxWt1V16a infoUnitV16a tglContV16a">
											<dl class="infoArrayV16a">
												<dt>선정기준</dt>
												<dd>주문 12회 이상 또는 결제금액 100만원 이상</dd>
											</dl>
											<dl class="infoArrayV16a">
												<dt class="vTop">할인혜택</dt>
												<dd class="vTop">
													<ul class="cartInfoV16a">
														<li><span class="cRd1V16a">10%</span> 쿠폰 2장</li>
														<li><span class="cRd1V16a">3천원</span> 쿠폰 2장</li>
														<li><span class="cRd1V16a">1만원</span> 쿠폰 1장 (10만원이상 구매 시)</li>
														<li>3개월 연속 VIP GOLD 유지 시 <span class="cRd1V16a">7천원</span>  쿠폰 1장 <span>(5만원이상 구매 시)</span></li>
													</ul>
												</dd>
											</dl>
											<dl class="infoArrayV16a">
												<dt class="vTop">등급혜택</dt>
												<dd class="vTop">
													<ul class="cartInfoV16a">
														<li>텐바이텐 배송상품 무료배송</li>
														<li>구매금액 적립비율 1%+0.3%</li>
														<!-- li>더핑거스 강좌 10% 쿠폰 1장</li -->
														<li>히치하이커 무료지급 (신청기간 내 주소확인 시)</li>
														<li>VIP GIFT 연2회 신청가능</li>
														<li>VIP LOUNGE 이용가능</li>
													</ul>
												</dd>
											</dl>
											<div class="btnAreaV16a">
												<p><button type="button" class="btnV16a btnRed1V16a" onclick="fnGotoVIPLounge();">VIP LOUNGE 바로가기</button></p>
											</div>
										</dd>
									</dl>
									<dl class="showHideV16a mVIPSILVER">
										<dt class="bxLGy2V16a grpTitV16a tglBtnV16a"><h2 class="hasArrow grTxtV16a"></h2></dt>
										<dd class="bxWt1V16a infoUnitV16a tglContV16a">
											<dl class="infoArrayV16a">
												<dt>선정기준</dt>
												<dd>주문 6회 이상 또는 결제금액 50만원 이상</dd>
											</dl>
											<dl class="infoArrayV16a">
												<dt class="vTop">할인혜택</dt>
												<dd class="vTop">
													<ul class="cartInfoV16a">
														<li><span class="cRd1V16a">10%</span> 쿠폰 2장</li>
														<li><span class="cRd1V16a">3천원</span> 쿠폰 2장</li>
														<li><span class="cRd1V16a">텐바이텐 배송상품 무료배송</span> 쿠폰 3장</li>
														<li>3개월 연속 VIP SILVER 유지 시 <span class="cRd1V16a">5천원</span> 쿠폰 1장 <span>(4만원이상 구매 시)</span></li>
													</ul>
												</dd>
											</dl>
											<dl class="infoArrayV16a">
												<dt class="vTop">등급혜택</dt>
												<dd class="vTop">
													<ul class="cartInfoV16a">
														<li>텐바이텐 배송상품 무료배송</li>
														<li>구매금액 적립비율 1%+0.3%</li>
														<!-- li>더핑거스 강좌 7% 쿠폰 1장</li -->
														<li>히치하이커 무료지급 (신청기간 내 주소확인 시)</li>
														<li>VIP GIFT 연2회 신청가능</li>
														<li>최초 VVIP 등급 달성 시 special gift 증정 <span>(신청기간 내 주소확인 시)</span></li>
														<li>VIP LOUNGE 이용가능</li>
													</ul>
												</dd>
											</dl>
											<div class="btnAreaV16a">
												<p><button type="button" class="btnV16a btnRed1V16a" onclick="fnGotoVIPLounge();">VIP LOUNGE 바로가기</button></p>
											</div>
										</dd>
									</dl>
									<dl class="showHideV16a mBLUE">
										<dt class="bxLGy2V16a grpTitV16a tglBtnV16a"><h2 class="hasArrow grTxtV16a"></h2></dt>
										<dd class="bxWt1V16a infoUnitV16a tglContV16a">
											<dl class="infoArrayV16a">
												<dt>선정기준</dt>
												<dd>주문 4회 이상 또는 결제금액 30만원 이상</dd>
											</dl>
											<dl class="infoArrayV16a">
												<dt class="vTop">할인혜택</dt>
												<dd class="vTop">
													<ul class="cartInfoV16a">
														<li><span class="cRd1V16a">10%</span> 쿠폰 1장</li>
														<li><span class="cRd1V16a">텐바이텐 배송상품 무료배송</span> 쿠폰 2장</li>
													</ul>
												</dd>
											</dl>
											<dl class="infoArrayV16a">
												<dt class="vTop">등급혜택</dt>
												<dd class="vTop">
													<ul class="cartInfoV16a">
														<li>텐바이텐 배송상품 2만원이상 무료배송</li>
														<li>구매금액 적립비율 1%</li>
														<!-- li>더핑거스 강좌 5% 쿠폰 1장</li -->
													</ul>
												</dd>
											</dl>
										</dd>
									</dl>
									<dl class="showHideV16a mGREEN">
										<dt class="bxLGy2V16a grpTitV16a tglBtnV16a"><h2 class="hasArrow grTxtV16a"></h2></dt>
										<dd class="bxWt1V16a infoUnitV16a tglContV16a">
											<dl class="infoArrayV16a">
												<dt>선정기준</dt>
												<dd>주문 1회 이상 또는 결제금액 10만원 이상</dd>
											</dl>
											<dl class="infoArrayV16a">
												<dt class="vTop">할인혜택</dt>
												<dd class="vTop">
													<ul class="cartInfoV16a">
														<li><span class="cRd1V16a">5%</span> 쿠폰 2장</li>
														<li><span class="cRd1V16a">텐바이텐 배송상품 2만원이상 무료배송</span> 쿠폰 1장</li>
													</ul>
												</dd>
											</dl>
											<dl class="infoArrayV16a">
												<dt class="vTop">등급혜택</dt>
												<dd class="vTop">
													<ul class="cartInfoV16a">
														<li>텐바이텐 배송상품 3만원이상 무료배송</li>
														<li>구매금액 적립비율 1%</li>
													</ul>
												</dd>
											</dl>
										</dd>
									</dl>
									<dl class="showHideV16a mYELLOW">
										<dt class="bxLGy2V16a grpTitV16a tglBtnV16a"><h2 class="hasArrow grTxtV16a"></h2></dt>
										<dd class="bxWt1V16a infoUnitV16a tglContV16a">
											<dl class="infoArrayV16a">
												<dt>선정기준</dt>
												<dd>5개월 이내 구매경험이 없는 고객</dd>
											</dl>
											<dl class="infoArrayV16a">
												<dt class="vTop">할인혜택</dt>
												<dd class="vTop">
													<ul class="cartInfoV16a">
														<li><span class="cRd1V16a">5%</span> 쿠폰 1장</li>
														<li><span class="cRd1V16a">텐바이텐 배송상품 2만원이상 무료배송</span> 쿠폰 1장</li>
													</ul>
												</dd>
											</dl>
											<dl class="infoArrayV16a">
												<dt class="vTop">등급혜택</dt>
												<dd class="vTop">
													<ul class="cartInfoV16a">
														<li>텐바이텐 배송상품 3만원이상 무료배송</li>
														<li>구매금액 적립비율 1%</li>
													</ul>
												</dd>
											</dl>
										</dd>
									</dl>
									<dl class="showHideV16a mORANGE">
										<dt class="bxLGy2V16a grpTitV16a tglBtnV16a"><h2 class="hasArrow grTxtV16a"></h2></dt>
										<dd class="bxWt1V16a infoUnitV16a tglContV16a">
											<dl class="infoArrayV16a">
												<dt>선정기준</dt>
												<dd>신규가입회원, 구매경험이 없는 고객</dd>
											</dl>
											<dl class="infoArrayV16a">
												<dt class="vTop">할인혜택</dt>
												<dd class="vTop">
													<ul class="cartInfoV16a">
														<li><span class="cRd1V16a">2천원</span> 쿠폰 1장 (5만원이상 구매 시)</li>
														<li><span class="cRd1V16a">텐바이텐 배송상품 2만원이상 무료배송</span> 쿠폰 1장</li>
													</ul>
												</dd>
											</dl>
											<dl class="infoArrayV16a">
												<dt class="vTop">등급혜택</dt>
												<dd class="vTop">
													<ul class="cartInfoV16a">
														<li>텐바이텐 배송상품 3만원이상 무료배송</li>
														<li>구매금액 적립비율 1%</li>
													</ul>
												</dd>
											</dl>
										</dd>
									</dl>
								</div>
								<div class="bxLGy1V16a cartNotiV16a">
									<ul>
										<li>최근 5개월간의 이용내역을 반영하여 매월 1일 새로운 회원등급이 부여됩니다.</li>
										<li>1만원 미만의 구매내역은 구매횟수로 계산되는 선정기준에서는 제외됩니다. (산정기준 = 실결제액 + 마일리지사용액)</li>
										<li>무료배송 쿠폰은 텐바이텐 배송상품 구매 시 사용가능 합니다.</li>
										<li>할인쿠폰 중 % 할인쿠폰은 이미 할인을 하는 상품, 일부 상품에 대해서 중복 적용이 되지 않습니다.</li>
									</ul>
								</div>
							</div>
						</div>
					</div>
					<div class="swiper-scrollbar"></div>
				</div>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->