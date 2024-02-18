<%
'// 2018 회원등급 개편
%>
<div class="grade-guide">
	<ul class="tabNav tNum3">
		<li class="current">
			<a href="#grade-noti">
				<div class="icon-grade"></div>
				<p>알아두기</p>
			</a>
		</li>
		<li class="g-white">
			<a href="#white">
				<div class="icon-grade"></div>
				<p>WHITE</p>
			</a>
		</li>
		<li class="g-red">
			<a href="#red">
				<div class="icon-grade"></div>
				<p>RED</p>
			</a>
		</li>
		<li class="g-vip">
			<a href="#vip">
				<div class="icon-grade"></div>
				<p>VIP</p>
			</a>
		</li>
		<li class="g-vipgold">
			<a href="#vipgold">
				<div class="icon-grade"></div>
				<p>VIP GOLD</p>
			</a>
		</li>
		<li class="g-vvip">
			<a href="#vvip">
				<div class="icon-grade"></div>
				<p>VVIP</p>
			</a>
		</li>
	</ul>
	<div class="tabContainer">
		<!-- 알아두기 -->
		<div id="grade-noti" class="tabContent grade-noti">
			<p>텐바이텐에는 총 5개의 회원등급이 있으며<br>각 등급마다 다양한 할인과 혜택을 제공하고 있습니다.</p>
			<div>
				<h2>유의사항</h2>
				<ul>
					<li>최근 5개월간의 이용내역을 반영하여 매월 1일 새로운 회원등급이 부여됩니다.</li>
					<li>1만원 미만의 구매내역은 주문횟수로 계산되는 선정기준에서<br>제외됩니다. (쿠폰, 할인카드 등의 사용 후, 실제 결제금액이<br>1만원 기준으로 적용 : 결제금액 산정기준<br>= 실제 결제금액 + 마일리지 사용액 + 예치금 + 기프트카드) </li>
					<li>무료배송 쿠폰은 텐바이텐 배송상품 구매 시 사용가능 합니다.</li>
					<li>할인쿠폰 중 % 할인 쿠폰은 이미 할인을 하는 상품과 일부 상품에 대해서 중복 적용이 되지 않습니다.</li>
					<li>생일축하 쿠폰은 설정하신 생일 일주일 전에 할인쿠폰을 발행됩니다.<br>(1년에 1회만 발급 / 발행일로부터 15일 동안 사용 가능)</li>
				</ul>
			</div>
		</div>
		<!--// 알아두기 -->
		<!-- white -->
		<div id="white" class="tabContent">
			<div class="conditon">
				<h2>선정기준</h2>
				<p>신규가입 회원, 구매 경험이 없는 고객</p>
			</div>
			<div class="benefit">
				<div class="coupon">
					<h2>할인혜택</h2>
					<ul>
						<li>
							<p>5만원 이상 구매 시</p>
							<div><em>2천원</em> 할인쿠폰</div>
						</li>
						<li>
							<p>2만원 이상 구매 시</p>
							<div>텐바이텐 배송상품<br><em>무료배송</em> 쿠폰</div>
						</li>
					</ul>
				</div>
				<div class="more-benefit">
					<h2>등급혜택</h2>
					<ul>
						<li>
							<p>3만원 이상 구매 시</p>
							<div>텐바이텐 배송상품<br><em>무료배송</em></div>
						</li>
						<li>
							<p>상품 주문 금액의</p>
							<div><em>0.5%</em><br>마일리지 적립</div>
						</li>
						<li>
							<p>생일 축하 쿠폰</p>
							<div>4만원 이상 구매 시<br><em>5천원 할인쿠폰</em></div>
						</li>
					</ul>
				</div>
			</div>
		</div>
		<!--// white -->

		<!-- red -->
		<div id="red" class="tabContent">
			<div class="conditon">
				<h2>선정기준</h2>
				<p>주문 1회 이상 또는 결제 금액 10만원 이상</p>
			</div>
			<div class="benefit">
				<div class="coupon">
					<h2>할인혜택</h2>
					<ul>
						<li>
							<p>3만원 이상 구매 시</p>
							<div class="many"><em>5%</em> 할인쿠폰<br>(최대 1만원 할인)<span>2장</span></div>
						</li>
						<li>
							<p>2만원 이상 구매 시</p>
							<div>텐바이텐 배송상품<br><em>무료배송</em> 쿠폰</div>
						</li>
					</ul>
				</div>
				<div class="more-benefit">
					<h2>등급혜택</h2>
					<ul>
						<li>
							<p>3만원 이상 구매 시</p>
							<div>텐바이텐 배송상품<br><em>무료배송</em></div>
						</li>
						<li>
							<p>상품 주문 금액의</p>
							<div><em>0.5%</em><br>마일리지 적립</div>
						</li>
						<li>
							<p>생일 축하 쿠폰</p>
							<div>4만원 이상 구매 시<br><em>5천원 할인쿠폰</em></div>
						</li>
					</ul>
				</div>
			</div>
		</div>
		<!--// red -->

		<!-- vip -->
		<div id="vip" class="tabContent">
			<div class="conditon">
				<h2>선정기준</h2>
				<p>주문 3회 이상 또는 결제 금액 20만원 이상</p>
			</div>
			<div class="benefit">
				<div class="coupon">
					<h2>할인혜택</h2>
					<ul>
						<li>
							<p>3만원 이상 구매 시</p>
							<div><em>5%</em> 할인쿠폰<br/>(최대 1만원 할인)</div>
						</li>
						<li>
							<p>3만원 이상 구매 시</p>
							<div><em>3%</em> 할인쿠폰<br/>(최대 1만원 할인)</div>
						</li>
						<li>
							<p>5만원 이상 구매 시</p>
							<div><em>3천원</em> 할인쿠폰</div>
						</li>
						<li>
							<p>1만원 이상 구매 시</p>
							<div class="many">텐바이텐 배송상품<br><em>무료배송 쿠폰</em><span>2장</span></div>
						</li>
					</ul>
				</div>
				<div class="more-benefit">
					<h2>등급혜택</h2>
					<ul>
						<li>
							<p>2만원 이상 구매 시</p>
							<div>텐바이텐 배송상품<br><em>무료배송</em></div>
						</li>
						<li>
							<p>상품 주문 금액의</p>
							<div><em>1%</em><br>마일리지 적립</div>
						</li>
						<li>
							<p>생일 축하 쿠폰</p>
							<div>4만원 이상 구매 시<br><em>5천원 할인쿠폰</em></div>
						</li>
					</ul>
				</div>
			</div>
		</div>
		<!--// vip -->

		<!-- vip gold -->
		<div id="vipgold" class="tabContent">
			<div class="conditon">
				<h2>선정기준</h2>
				<p>주문 5회 이상 또는 결제 금액 50만원 이상</p>
			</div>
			<div class="benefit">
				<div class="coupon">
					<h2>할인혜택</h2>
					<ul>
						<li>
							<p>3만원 이상 구매 시</p>
							<div><em>10%</em> 할인쿠폰<br/>(최대 2만원 할인)</div>
						</li>
						<li>
							<p>3만원 이상 구매 시</p>
							<div><em>5%</em> 할인쿠폰<br/>(최대 1만원 할인)</div>
						</li>
						<li>
							<p>7만원 이상 구매 시</p>
							<div><em>5천원</em> 할인쿠폰</div>
						</li>
						<li>
							<p>텐텐배송상품 구매 시</p>
							<div class="many"><em>무료배송</em> 쿠폰<span>2장</span></div>
						</li>
					</ul>
				</div>
				<div class="more-benefit">
					<h2>등급혜택</h2>
					<ul>
						<li>
							<p>1만원 이상 구매 시</p>
							<div>텐바이텐 배송상품<br><em>무료배송</em></div>
						</li>
						<li>
							<p>상품 주문 금액의</p>
							<div><em>1%</em><br>마일리지 적립</div>
						</li>
						<li>
							<p>홀수달, 신청/확인시</p>
							<div><em>히치하이커</em> 제공</div>
						</li>
						<li>
							<p>생일 축하 쿠폰</p>
							<div>4만원 이상 구매 시<br><em>5천원 할인쿠폰</em></div>
						</li>
					</ul>
				</div>
			</div>
		</div>
		<!--// vip gold -->

		<!-- vvip -->
		<div id="vvip" class="tabContent">
			<div class="conditon">
				<h2>선정기준</h2>
				<p>결제금액 300만원 이상</p>
			</div>
			<div class="benefit">
				<div class="coupon">
					<h2>할인혜택</h2>
					<ul class="coupon">
						<li>
							<p>3만원 이상 구매 시</p>
							<div class="many"><em>10%</em> 할인쿠폰<br/>(할인금액 제한 없음)<span>2장</span></div>
						</li>
						<li>
							<p>3만원 이상 구매 시</p>
							<div class="many"><em>5%</em> 할인쿠폰<br/>(최대 2만원 할인)<span>2장</span></div>
						</li>
						<li>
							<p>20만원 이상 구매 시</p>
							<div><em>3만원</em> 할인쿠폰</div>
						</li>
						<li>
							<p>10만원 이상 구매 시</p>
							<div><em>1만원</em> 할인쿠폰</div>
						</li>
					</ul>
				</div>
				<div class="more-benefit">
					<h2>등급혜택</h2>
					<ul class="more-benefit">
						<li>
							<p>구매 시</p>
							<div>텐바이텐 배송상품<br/><em>무료배송</em></div>
						</li>
						<li>
							<p>상품 주문 금액의</p>
							<div><em>1.3%</em><br>마일리지 적립</div>
						</li>
						<li>
							<p>홀수달, 신청/확인시</p>
							<div><em>히치하이커</em> 제공</div>
						</li>
						<li>
							<p>생일 축하 쿠폰</p>
							<div>4만원 이상 구매 시<br><em>5천원 할인쿠폰</em></div>
						</li>
					</ul>
				</div>
			</div>
		</div>
		<!--// vvip -->
	</div>
</div>