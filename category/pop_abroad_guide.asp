<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<div class="layerPopup">
	<div class="popWin">
		<header class="tenten-header header-popup">
			<div class="title-wrap">
				<h1>해외직구 안내</h1>
				<button type="button" class="btn-close" onclick="fnCloseModal();">닫기</button>
			</div>
		</header>
		<div id="layerScroll" class="content" style="top:0;">
			<div id="scrollarea">
				<div class="abroad-guide">
					<ol class="process">
						<li class="step1">
							<span>STEP 01</span>
							<strong>주문/결제</strong>
							<p class="bMar0-5r">배송받으실 국내 주소와 통관을 위한 개인통관 고유부호(필수) 입력 후 결제를 완료해주세요.</p>
							<a href="https://unipass.customs.go.kr/csp/persIndex.do" class="txtLine cBk1" target="_blank">개인통관 고유부호 발급안내 &gt;</a>
						</li>
						<li class="step2">
							<span>STEP 02</span>
							<strong>한국으로 국제 배송</strong>
							<p>판매자 상품 확인 후, 한국으로 보내는 국제 배송이 시작됩니다. <em class="color-red">현지 상황에 따라 평균 7일~21일 정도의 배송기간이 소요</em>됩니다.</p>
						</li>
						<li class="step3">
							<span>STEP 03</span>
							<strong>통관 진행</strong>
							<p>상품이 국내에 도착하는 대로 통관 절차를 거치게 됩니다. 통관 시 전체 주문/결제금액이 $150을(를) 초과할 경우 관/부가세가 발생할 수 있습니다.</p>
						</li>
						<li class="step4">
							<span>STEP 04</span>
							<strong>국내 배송</strong>
							<p>통관이 완료된 상품들은 국내 배송업체를 통해 도착지로 안전하게 배송됩니다.</p>
						</li>
					</ol>
					<div class="noti">
						<h3>유의사항</h3>
						<ul>
							<li>직접 주문 취소는 [주문통보] 단계까지만 가능하며 [상품준비중] 단계부터는 고객행복센터를 이용해주세요.</li>
							<li>상품준비중 단계 이후 단순 변심에 의한 취소를 요청하시거나 배송완료 후 구매자 귀책에 의한 반품/교환 신청 시 일반 배송 상품보다 많은 비용이 발생될 수 있습니다.<br />(구매 전 반드시 상품에 관한 자세한 내용 및 취소/교환/환불 안내 내용을 숙지하시기 바랍니다.)</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>