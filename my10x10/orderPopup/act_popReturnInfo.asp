<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	Description : 반품안내
'	History	:  2018.09.10 원승현 생성
'#######################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<script type='text/javascript'>
	$(function() {
		/* show-hide */
		$('.showHideV16a .tglBtnV16a').click(function(){
			if($(this).parent().parent().hasClass('freebieSltV16a')) {
				$('.freebieSltV16a .showHideV16a .tglContV16a').hide();
				$('.freebieSltV16a .showHideV16a .tglBtnV16a').addClass('showToggle');
			}
			if ($(this).hasClass('showToggle')) {
				$(this).removeClass('showToggle');
				$(this).parents('.showHideV16a').find('.tglContV16a').show();
			} else {
				$(this).addClass('showToggle');
				$(this).parents('.showHideV16a').find('.tglContV16a').hide();
			}
		});
	});
</script>
<div class="layerPopup" style="background-color:#e7eaea;">
	<div class="popWin">
		<div class="header">
			<h1>반품 안내</h1>
			<p class="btnPopClose"><button onclick="fnCloseModal();" class="pButton">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content cardGuide" id="layerScroll">
			<div id="scrollarea">
				<div class="returnWrap">
					<div class="returnNoti2" style="padding-bottom:0;">
						<ul>
							<li>상품 출고일 기준 7일 이내 (평일 기준)에 반품 및 환불이 가능합니다.</li>
							<li>상품 배송 구분에 따라 반품 방식이 다르니, 이 점 유의하시기 바랍니다.</li>
							<li>주문 제작 및 마일리지 상품 등 일부 상품은 반품이 불가합니다.</li>
							<li>입점몰 주문은 1:1 상담 또는 고객센터를 통해 반품 접수하실 수 있습니다.</li>
							<li>보너스 쿠폰 중 금액 할인쿠폰을 사용하여 복수의 상품을 구매하시는 경우, 상품별 판매가에 따라 쿠폰 할인 금액이 분할되어 적용됩니다.</li>
							<li>새 상품 교환은 고객센터로 문의해주시기 바랍니다.</li>
						</ul>
					</div>

					<div class="returnGrp showHideV16a">
						<div class="grpTitV16a tglBtnV16a">
							<h2 class="hasArrow">텐바이텐 배송상품 안내</h2>
						</div>
						<div class="tglContV16a" style="display:block;">
							<div class="returnNoti2">
								<ul>
									<li>반품 접수를 하시면, <span class="cRd1V16a">택배 기사님이 2~3일 후 방문</span> 드립니다.</li>
								</ul>
							</div>
							<div class="grpCont">
								<dl class="infoArray">
									<dt>1) 반품 접수</dt>
									<dd>반품 신청 후, 반품하실 상품을 받으신 상태로 포장해주세요.</dd>
								</dl>
								<dl class="infoArray">
									<dt>2) 기사 방문</dt>
									<dd>반품 접수 후 2~3일 내에 택배 기사님이 방문하여 상품을 회수합니다.</dd>
								</dl>
								<dl class="infoArray">
									<dt>3) 반품 완료</dt>
									<dd>반품된 상품을 확인 후 결제 취소 또는 환불을 해드립니다.</dd>
								</dl>
							</div>
						</div>
					</div><!-- //returnGrp -->

					<div class="returnGrp showHideV16a">
						<div class="grpTitV16a tglBtnV16a">
							<h2 class="hasArrow">업체 배송상품 안내 <span class="ftRt fs1r cRd1V16a" style="padding-right:0.5rem;">*직접 반품 필요</span></h2>
						</div>
						<div class="tglContV16a" style="display:block;">
							<div class="returnNoti2">
								<ul>
									<li>반품하실 상품은 <span class="cRd1V16a">[업체 개별 배송]</span> 상품으로, 반품 접수 후, <span class="cRd1V16a">직접 반품</span>을 해주셔야 합니다.</li>
									<li>택배 접수는 착불 반송으로 접수하시면 됩니다.</li>
								</ul>
							</div>
							<div class="grpCont">
								<dl class="infoArray">
									<dt>1) 반품 접수</dt>
									<dd>반품 신청 후, 반품하실 상품을 받으신 상태로 포장해주세요.</dd>
								</dl>
								<dl class="infoArray">
									<dt>2) 택배 발송</dt>
									<dd>해당 택배사로 직접 연락 후 업체로 상품을 보내주세요.</dd>
								</dl>
								<dl class="infoArray">
									<dt>3) 반품 진행</dt>
									<dd>택배 발송 후 [내가 신청한 서비스]에 보내신 송장번호를 입력하세요.</dd>
								</dl>
								<dl class="infoArray">
									<dt>4) 반품 완료</dt>
									<dd>반품된 상품을 확인 후 결제 취소 또는 환불을 해드립니다.</dd>
								</dl>
							</div>
						</div>
					</div><!-- //returnGrp -->
				</div>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->