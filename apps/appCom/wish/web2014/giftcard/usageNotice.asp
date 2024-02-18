<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/newV15a.css" />
<script>
$(function() {
	$('.orderSummary').click(function(){
		$(this).parent().toggleClass('closeToggle');
		$(this).parent().children('.pdtListWrap').toggle();
	});
});
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="useNotiWrap">
				<ul class="suppCont">
					<li>
						<strong>발행자</strong>
						<p>텐바이텐</p>
					</li>
					<li>
						<strong>유효기간</strong>
						<p>구매일로부터 5년</p>
					</li>
					<li>
						<strong>전송방법</strong>
						<p>모바일 메시지 전송</p>
					</li>
					<li>
						<strong>이용매장</strong>
						<p>온라인, 오프라인샵 ㅣ <a href="" onclick="fnAPPpopupBrowserURL('매장정보','<%=wwwUrl%>/apps/appCom/wish/web2014/offshop/','right','','sc'); return false;"><span class="cRd1">매장정보</span></a></p>
					</li>
					<li>
						<strong>전액환급조건</strong>
						<p>기프트카드 금액이 1만원 초과일 경우<br />100분의 60 이상, 1만원 이하일 경우<br />100분의 80 이상 사용한 경우, 잔액 환급 가능</p>
					</li>
				</ul>

				<div class="box4 listBox">
					<ul>
						<li>기프트카드는 다른 일반 상품과 함께 구매가 되지 않는 단독 구매 상품으로, 한 주문에 하나의 카드만 구매 가능합니다.</li>
						<li>기프트카드 구매는 무기명 선불카드를 구매하는 것이므로 모든 결제수단이 비과세로 구분됩니다. 현금영수증, 세금계산서 증빙서류는 발급이 불가하며, 선물 받은 사람이 카드를 사용할 때 현금영수증 발행이 가능 합니다.</li>
						<li>기프트카드는 신용카드, 무통장입금, 실시간 계좌이체와 같은 기존의 결제 수단으로 구매가 가능하나 쿠폰, 마일리지, 예치금등의 사용은 제한되어 있습니다.</li>
						<li>인(人)당 월 구매한도는 100만원입니다.</li>
					</ul>
				</div>

				<div class="orderList closeToggle">
					<p class="orderSummary box5 lt">기프트카드 사용방법</p>
					<div class="pdtListWrap">
						<div class="listBox">
							<strong>온라인 사용</strong>
							<div class="cardUseStep">
								<div class="onlineSt"><p>기프트카드<br />메시지 수신</p></div>
								<div class="nextStep"></div>
								<div class="onlineSt"><p>로그인 후<br />카드 등록</p></div>
								<div class="nextStep"></div>
								<div class="onlineSt"><p>상품결제시<br />사용</p></div>
							</div>
							<ul>
								<li>기프트카드 등록 후 상품 구매시 결제 페이지에서 기프트카드 금액을 현금처럼 사용할 수 있으며, 다른 결제 수단과 중복으로 사용 가능합니다.</li>
								<li>횟수에 관계없이 금액을 여러 번 나누어서 사용할 수 있으며 여러 개의 기프트카드를 등록하신 경우, 등록 순서에 따라 순차적으로 사용됩니다.</li>
							</ul>
							<strong class="tMar20">오프라인 사용</strong>
							<div class="cardUseStep">
								<div class="offlineSt"><p>기프트카드<br />메시지 수신</p></div>
								<div class="nextStep"></div>
								<div class="offlineSt"><p>로그인 후<br />카드 등록</p></div>
								<div class="nextStep"></div>
								<div class="offlineSt"><p>오프라인 <br />결제시 <br />인증번호 제시</p></div>
							</div>
							<ul>
								<li>전송 받은 기프트카드 메시지를 통해 온라인 로그인 후 카드를 등록합니다.</li>
								<li>온라인 등록 후 오프라인 매장에서 결제 시, 인증번호를 제시 하시면 간단한 본인확인 절차를 거친 후 사용 가능합니다.</li>
								<li>횟수에 관계없이 금액을 여러 번 나누어서 사용할 수 있으며 다른 결제수단과 중복으로 사용 가능합니다.</li>
							</ul>
						</div>
					</div>
				</div>

				<div class="orderList">
					<p class="orderSummary box5 lt">유의사항</p>
					<div class="pdtListWrap" style="display:none;">
						<div class="listBox">
							<ul>
								<li>받는 분의 정보를 잘못 입력한 경우 또는 받는 분이 메시지를 받지 못했을 경우 카드 사용 등록 전, 마이텐바이텐 > 기프트카드 > 카드 주문내역에서 2회까지 재전송이 가능합니다.</li>
								<li>메시지 재전송시 이전에 전송된 기프트카드 메시지의 인증번호는 무효처리 됩니다.</li>
								<li>온라인 쇼핑몰 사용 후 남은 금액을 오프라인 매장에서 사용 가능하며, 오프라인 매장에서 사용 후 남은 금액을 온라인 쇼핑몰에서도 사용 가능합니다.</li>
							</ul>
						</div>
					</div>
				</div>

				<div class="orderList">
					<p class="orderSummary box5 lt">환불규정</p>
					<div class="pdtListWrap" style="display:none;">
						<div class="listBox">
							<ul>
								<li>사용 유효기간이 지난 경우 환불 처리가 불가 합니다. (유효기간 : 구매일로부터 5년)</li>
								<li>환불은 구매일로부터 7일 이내에 가능하며, 받는 사람이 카드 사용 등록이 완료되었거나 오프라인매장에서 일부 금액을 사용한 경우 환불이 되지 않습니다.</li>
								<li>받는 분의 정보를 잘못 입력하여 타 사용자가 카드 사용 등록을 하였거나 오프라인 매장에서 사용한 경우 환불이 불가하며 텐바이텐은 책임을 지지 않습니다.</li>
							</ul>
						</div>
					</div>
				</div>

			</div>
		</div>
		<span id="gotop" class="goTop">TOP</span>
		<!-- //content area -->
	</div>
</div>
</body>
</html>