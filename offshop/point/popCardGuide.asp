<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
</head>
<div class="layerPopup">
	<div class="popWin">
		<div class="header">
			<h1>이용안내</h1>
			<p class="btnPopClose"><button type="button" class="pButton" onclick="fnCloseModal();">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content" id="layerScroll">
			<div id="scrollarea">
				<div class="inner10 cardGuide">
					<div class="tab02">
						<ul class="tabNav tNum2">
							<li class="current"><a href="#guide01">발급방법</a></li>
							<li><a href="#guide02">적립/사용방법</a></li>
						</ul>
						<div class="tabContainer">
							<div id="guide01" class="tabContent">
								<dl>
									<dt>카드 발급방법</dt>
									<dd>
										<ul class="myTenNoti">
											<li>POINT1010 카드는 텐바이텐 오프라인 매장에서 1,000원 이상 구매 시 발급이 가능합니다.</li>
											<li>별도의 가입신청서 작성없이 발급 가능하시며, 카드 수령 후, POINT1010 홈페이지에서 회원가입 및 카드등록을 하시면 됩니다.</li>
											<li>포인트의 적립은 홈페이지 카드등록과 상관없이 가능하나, 포인트의 사용은 본인확인을 위해 <span class="cRd1">카드등록 및 회원가입 후 가능</span>합니다.</li>
										</ul>
									</dd>
								</dl>
								<dl>
									<dt>재발급</dt>
									<dd>
										<ul class="myTenNoti">
											<li>POINT1010 카드를 분실하시거나, 카드훼손으로 인해 이용이 불가능하실 경우, 각 가맹점에서 신규카드를 발급받으시고 POINT1010 홈페이지에서 카드등록을 하시면 됩니다.</li>
											<li>본인 인증시 기존 카드정보 및 잔여포인트를 확인하실 수 있으며, 신규카드 등록시 <span class="cRd1">기존 카드의 잔여포인트는 신규카드로 이관</span>됩니다.</li>
										</ul>
									</dd>
								</dl>
							</div>
							<div id="guide02" class="tabContent">
								<dl>
									<dt>적립방법 및 적립율</dt>
									<dd>
										<ul class="myTenNoti">
											<li>텐바이텐 오프라인 매장에서 POINT1010 카드를 제시하시면, <span class="cRd1">이용금액의 3%</span>를 적립해드립니다. (단, 할인쿠폰 사용시, 세일기간, 특정상품 구매 시 적립 및 사용이 제한될 수 있습니다.)</li>
											<li>포인트의 적립은 홈페이지 카드등록과 상관없이 가능하나, 포인트의 사용은 본인확인을 위해 <span class="cRd1">카드등록 및 회원가입 후 가능</span>합니다.</li>
										</ul>
									</dd>
								</dl>
								<dl>
									<dt>사용방법</dt>
									<dd>
										<ul class="myTenNoti">
											<li>가용 포인트가 3,000포인트 이상일 경우, 텐바이텐 오프라인 매장에서 상품구매 시 현금과 동일하게 사용 가능합니다. 또한 텐바이텐 온라인 및 핑거스아카데미에서 사용하실 수 있는 마일리지로 전환이 가능합니다. (온라인 회원인 경우)</li>
										</ul>
									</dd>
								</dl>
								<dl>
									<dt>적립유효 기간</dt>
									<dd>
										<ul class="myTenNoti">
											<li>적립된 포인트는 부여된 순서로 사용되며, 부여된 해로부터 5년 이내에 사용하셔야 합니다. 해당기간 내에 사용하지 않은 잔여 포인트는 1년 단위로 매년 12월 31일에 자동 소멸됩니다.</li>
											<li>미적립된 포인트는 1개월 이내 매장방문을 통해 적립하실 수 있습니다.</li>
										</ul>
									</dd>
								</dl>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>