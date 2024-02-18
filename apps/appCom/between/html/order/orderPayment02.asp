<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
<script>
	$(function() {
		// 현금영수증 발급요청, 전자보증보험 발급요청 더보기
		$(".issueCash .description").hide();
		$(".issueInsurance .description").hide();

		$(".issueCash .requestCheck, .issueCash .requestCheck label").click(function(){
			$(".issueCash .description").toggle();
		});

		$(".issueInsurance .requestCheck, .issueInsurance .requestCheck label").click(function(){
			$(".issueInsurance .description").toggle();
		});
	});
</script>
</head>
<body>
<div class="wrapper" id="btwMypage"><!-- for dev msg : 원뎁스별 해당 ID 추가(비트윈추천:btwRcmd/카테고리:btwCtgy/마이페이지:btwMypage) -->
	<div id="content">
		<div class="cont">
			<div class="hWrap hrBlk">
				<h1 class="headingA">주문결제</h1>
				<div class="option">
					<span class="afterLogin"><strong>ajung611ajung611</strong>님 <a href="">[텐바이텐 로그아웃]</a></span><!-- for dev msg : 회원 -->
				</div>
			</div>

			<form action="">
			<!-- 주문리스트 확인 -->
			<fieldset>
				<div class="hWrap hrBtw">
					<h2 class="headingB first"><span>1</span> 주문리스트 확인 (2종/3개 <strong class="txtBtwDk">182,900</strong>원)</h2>
				</div>
				<div class="orderList">
					<ul class="pdtList list02 boxMdl">
						<li>
							<div>
								<a href="">
									<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/90/B000904599.jpg" alt="상품명" /></p>
									<p class="pdtName">상품명상품명상품명상품명상품명상품명상품명상품명명상품명상품상품명상품상</p>
									<p class="pdtBrand">브랜드명</p>
									<p class="price"><span class="txtSaleRed">69,000원[22%]</span> X 2 = <strong class="txtBtwDk">131,100원</strong></p><!-- for dev msg : 세일가 일때 <span class="txtSaleRed">69,000원[22%]</span> 붙여주세요 -->
								</a>
								<span class="coupon">
									<em class="btn02 cpGreen"><a href="">쿠폰</a></em>
									<strong class="txtCpGreen">[10% 상품쿠폰]</strong>
								</span>
							</div>
						</li>
						<li>
							<div>
								<a href="">
									<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/90/B000904599.jpg" alt="상품명" /></p>
									<p class="pdtName">상품명상품명상품명상품명상품명상품명상품명상품명상품명상품명상품명상품명</p>
									<p class="pdtBrand">브랜드명</p>
									<p class="price"><span>69,000원</span> X 2 = <strong class="txtBtwDk">131,100원</strong></p>
								</a>
								<span class="coupon">
									<strong class="txtCpGreen">[10% 상품쿠폰 적용가] 62,100원</strong>
								</span>
							</div>
						</li>
					</ul>
				</div>
			</fieldset>
			<!-- //주문리스트 확인 -->

			<!-- 주문고객 정보 -->
			<fieldset>
				<div class="hWrap hrBtw">
					<h2 class="headingB"><span>2</span> 주문고객 정보</h2>
				</div>

				<div class="selectOption">
					<span><input type="radio" id="customer01" name="" /> <label for="customer01">최근 주문고객</label></span>
					<span><input type="radio" id="customer02" name="" /> <label for="customer02">새로 입력</label></span>
				</div>

				<div class="section">
					<table class="tableType tableTypeC">
					<caption>주문고객 정보</caption>
					<tbody>
					<tr>
						<th scope="row"><label for="sender">보내시는 분</label></th>
						<td>
							<input type="text" id="sender" name="" />
						</td>
					</tr>
					<tr>
						<th scope="row">이메일</th>
						<td>
							<div class="row emailField">
								<div class="cell"><!-- for dev msg : 직접입력을 선택할 경우 direct 클래스명 추가해주세요. <div class="cell direct">... </div> -->
									<span class="emailAccount"><input type="text" title="이메일 계정" name="" /></span>
									<span class="symbol">@</span>
									<span class="emailService"><input type="text" title="이메일 서비스" name="" /></span>
								</div>
								<div class="optional">
									<select title="이메일 서비스 선택">
										<option>선택</option>
										<option>naver.com</option>
										<option>daum.net</option>
										<option>hanmail.net</option>
										<option>gmail.com</option>
										<option>nate.com</option>
										<option>empal.com</option>
										<option>직접입력</option>
									</select>
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">휴대전화</th>
						<td>
							<input type="text" title="휴대전화 앞자리" name="" style="width:23%;" />
							<span class="symbol">-</span>
							<input type="text" title="휴대전화 가운데자리" name="" style="width:23%;" />
							<span class="symbol">-</span>
							<input type="text" title="휴대전화 뒷자리" name="" style="width:23%;" />
						</td>
					</tr>
					<tr>
						<th scope="row">전화번호</th>
						<td>
							<input type="text" title="전화번호 앞자리" name="" style="width:23%;" />
							<span class="symbol">-</span>
							<input type="text" title="전화번호 가운데자리" name="" style="width:23%;" />
							<span class="symbol">-</span>
							<input type="text" title="전화번호 뒷자리" name="" style="width:23%;" />
						</td>
					</tr>
					</tbody>
					</table>
				</div>
			</fieldset>
			<!-- //주문고객 정보 -->

			<!-- 배송지 정보입력 -->
			<fieldset>
				<div class="hWrap hrBtw">
					<h2 class="headingB"><span>3</span> 배송지 정보입력</h2>
				</div>

				<div class="selectOption">
					<span><input type="radio" id="delivery01" name="" /> <label for="delivery01">주문고객과 동일</label></span>
					<span><input type="radio" id="delivery02" name="" /> <label for="delivery02">나의 주소록</label></span>
					<span><input type="radio" id="delivery03" name="" /> <label for="delivery03">새로운 주소</label></span>
				</div>

				<div class="section">
					<table class="tableType tableTypeC">
					<caption>배송지 정보입력</caption>
					<tbody>
					<tr>
						<th scope="row"><label for="recipient">받으시는 분</label></th>
						<td>
							<input type="text" id="recipient" name="" />
						</td>
					</tr>
					<tr>
						<th scope="row">주소</th>
						<td>
							<!-- for dev msg : 나의 주소록 선택시 숨겨주세요 -->
							<div class="address">
								<div class="row zipcodeField">
									<div class="cell">
										<span class="zipcodeFront"><input type="text" title="우편번호 앞자리" name="" /></span>
										<span class="symbol">-</span>
										<span class="zipcodeBack"><input type="text" title="우편번호 뒷자리" name="" /></span>
									</div>
									<div class="optional">
										<span class="btn02 btw"><a href="">우편번호 찾기</a></span>
									</div>
								</div>
								<div class="basics"><input type="text" title="기본주소" name="" /></div>
								<div class="detailed"><input type="text" title="상세주소" name="" /></div>
							</div>
							<!-- //for dev msg : 나의 주소록 선택시 숨겨주세요 -->

							<!-- for dev msg : 나의 주소록 선택시 보여주세요. -->
							<!--select title="주소 선택">
								<option>주소 선택</option>
							</select-->
							<!-- //for dev msg : 나의 주소록 선택시 보여주세요. -->
						</td>
					</tr>
					<tr>
						<th scope="row">배송시 유의사항</th>
						<td>
							<div class="row deliveryField">
								<div class="cell">
									<select title="배송시 유의사항 메시지 선택">
										<option>선택</option>
										<option>부재 시 경비실에 맡겨주세요</option>
										<option>핸드폰으로 연락바랍니다</option>
										<option>배송 전 연락바랍니다</option>
										<option>직접입력</option>
									</select>
								</div>
								<div class="optional">
									<input type="text" title="배송시 유의사항" name="" />
								</div>
							</div>
						</td>
					</tr>
					</tbody>
					</table>
				</div>
			</fieldset>
			<!-- //배송지 정보입력 -->

			<!-- 할인 정보 -->
			<fieldset>
				<div class="hWrap hrBtw">
					<h2 class="headingB"><span>4</span> 할인 정보</h2>
				</div>

				<div class="section">
					<table class="tableType tableTypeC">
					<caption>할인 정보 입력</caption>
					<tbody>
					<tr>
						<th scope="row"><input type="radio" id="bonusCoupon" name="" /> <label for="bonusCoupon">보너스 쿠폰</label></th>
						<td>
							<select title="보너스 쿠폰 선택">
								<option>쿠폰선택</option>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row"><input type="radio" id="productCoupon" name="" /> <label for="productCoupon">상품 쿠폰</label></th>
						<td>
							<div class="goodsCoupon">
								<strong class="txtCpGreen">상품 쿠폰명1</strong>
								<strong class="txtCpGreen">상품 쿠폰명2</strong>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row"><label for="mileage">마일리지</label></th>
						<td>
							<input type="text" id="mileage" name="" style="width:32%;" /> <span class="unit">P</span> <span>(보유 : <em class="txtSaleRed">10,000,000P</em>)</span>
						</td>
					</tr>
					<tr>
						<th scope="row"><label for="balance">예치금</label></th>
						<td>
							<input type="text" id="balance" name="" style="width:32%;" /> <span class="unit">원</span> <span>(보유 : <em class="txtSaleRed">10,000,000원</em>)</span>
						</td>
					</tr>
					<tr>
						<th scope="row"><label for="giftcard">Gift 카드</label></th>
						<td>
							<input type="text" id="giftcard" name="" style="width:32%;" /> <span class="unit">원</span> <span>(보유 : <em class="txtSaleRed">10,000,000원</em>)</span>
						</td>
					</tr>
					</table>
				</div>
			</fieldset>
			<!-- //할인 정보 -->

			<!-- 결제금액 -->
			<fieldset>
				<div class="hWrap hrBtw">
					<h2 class="headingB"><span>5</span> 결제금액</h2>
				</div>

				<div class="section">
					<table class="tableType tableTypeB">
					<caption>결제금액 정보</caption>
					<tbody>
					<tr>
						<th scope="row">상품 총 금액</th>
						<td>
							<del class="txtBtwDk">182,900 원</del> <em class="txtSaleRed">182,900 원</em>
						</td>
					</tr>
					<tr>
						<th scope="row">배송비</th>
						<td>5,000 원</td>
					</tr>
					<tr>
						<th scope="row">보너스쿠폰 사용</th>
						<td><em class="txtSaleRed">0 원</em></td>
					</tr>
					<tr>
						<th scope="row">상품쿠폰 사용</th>
						<td><em class="txtCpGreen">- 17,400 원</em></td>
					</tr>
					<tr class="sum">
						<th scope="row"><strong class="txtBlk">구매확정액</strong></th>
						<td><strong class="txtBtwDk">151,320 원</strong></td>
					</tr>
					<tr>
						<th scope="row">마일리지 사용</th>
						<td><em class="txtSaleRed">-120 P</em></td>
					</tr>
					<tr>
						<th scope="row">예치금 사용</th>
						<td><em class="txtSaleRed">-100 원</em></td>
					</tr>
					<tr>
						<th scope="row">Gift카드 사용</th>
						<td><em class="txtSaleRed">-100 원</em></td>
					</tr>
					<tr class="sum">
						<th scope="row"><strong class="txtBlk">최종결제액</strong></th>
						<td>
							<div>
								<strong class="txtBtwDk">151,000 원</strong>
								<p class="txtBlk">(총 25,000원 할인되었습니다.)</p>
							</div>
						</td>
					</tr>
					</tbody>
					</table>
				</div>
			</fieldset>
			<!-- //결제금액 -->

			<!-- 결제수단 -->
			<fieldset>
				<div class="hWrap hrBtw">
					<h2 class="headingB"><span>5</span> 결제수단</h2>
				</div>

				<div class="selectOption">
					<span><input type="radio" id="paymentWay01" name="" /> <label for="paymentWay01">신용카드</label></span>
					<span><input type="radio" id="paymentWay02" name="" /> <label for="paymentWay02">모바일 결제</label></span>
					<span><input type="radio" id="paymentWay03" name="" /> <label for="paymentWay03">무통장입금(가상계좌)</label></span>
				</div>

				<!-- for dev msg : 무통장입금일 경우 -->
				<div class="paymentDeposit">
					<div class="section">
						<table class="tableType tableTypeC">
						<caption>결제수단 입력</caption>
						<tbody>
						<tr>
							<th scope="row"><label for="account">입금하실 통장</label></th>
							<td>
								<div class="accountHolder">
									<input type="text" id="account" name="" />
									<p>예금주 : (주)텐바이텐</p>
								</div>
							</td>
						</tr>
						<tr>
							<th scope="row"><label for="depositPerson">입금자명</label></th>
							<td>
								<input type="text" id="depositPerson" name="" />
							</td>
						</tr>
						</tbody>
						</table>
					</div>

					<div class="issueCash">
						<span class="requestCheck"><input type="checkbox" id="cashDoc"> <label for="cashDoc" class="txtBtwDk">현금영수증 발급요청</label></span>
						<div class="description">
							<div class="selectOption">
								<span><input type="radio" id="docUsing01" name="" /> <label for="docUsing01">소득공제용</label></span>
								<span><input type="radio" id="docUsing02" name="" /> <label for="docUsing02">지출증빙용</label></span>
							</div>

							<div class="cashField">
								<label for="docNumber">휴대폰번호/현금영수증카드/사업자번호 (-를 뺀 숫자만 입력)</label>
								<input type="text" id="docNumber" name="" />
								<p><strong class="txtBtwDk">사업자, 현금영수증카드, 휴대폰번호가 유효하지 않으면 발급되지 않습니다.</strong></p>
							</div>
						</div>
					</div>

					<div class="issueInsurance">
						<span class="requestCheck"><input type="checkbox" id="insuranceDoc"> <label for="insuranceDoc" class="txtBtwDk">전자보증보험 발급요청</label></span>
						<div class="description">
							<p>"전자상거래 등에서의 소비자보호에 관한 법률" 에 근거한 전자보증서비스는 서울보증보험㈜이 인터넷 쇼핑몰에서의 상품주문(결제) 시점에 소비자에게 보험증서를 발급하여 인터넷 쇼핑몰 사고로 인한 소비자의 금전적 피해를 100% 보상하는 서비스입니다.</p>
							<ul>
								<li>- 보상대상 : 상품 미배송, 환불거부(환불사유시), 반품거부(반품사유시), 쇼핑몰부도</li>
								<li>- 보험기간 : 주문일로부터 37일간 (37일 보증)</li>
							</ul>

							<table>
							<caption>전자보증보험 발급요청 입력</caption>
							<tbody>
							<tr>
								<th scope="row">주문고객 생년월일</th>
								<td colspan="2">
									<div class="birthdayField">
										<span><input type="text" id="birthYear" name="" /> <label for="birthYear">년</label></span>
										<span><input type="text" id="birthMonth" name="" /> <label for="birthMonth">월</label></span>
										<span><input type="text" id="birthDay" name="" /> <label for="birthDay">일</label></span>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row">성별</th>
								<td><input type="radio" id="genderMale" name="" /> <label for="genderMale">남</label></td>
								<td><input type="radio" id="genderFemale" name="" /> <label for="genderFemale">여</label></td>
							</tr>
							<tr>
								<th scope="row">개인정보 이용동의</th>
								<td><input type="radio" id="agreeYes" name="" /> <label for="agreeYes">동의함</label></td>
								<td><input type="radio" id="agreeNo" name="" /> <label for="agreeNo">동의안함</label></td>
							</tr>
							<tr>
								<th scope="row">이메일 수신동의</th>
								<td><input type="radio" id="emailYes" name="" /> <label for="emailYes">수신</label></td>
								<td><input type="radio" id="emailNo" name="" /> <label for="emailNo">수신안함</label></td>
							</tr>
							<tr>
								<th scope="row">SMS 수신동의</th>
								<td><input type="radio" id="smsYes" name="" /> <label for="smsYes">수신</label></td>
								<td><input type="radio" id="smsNo" name="" /> <label for="smsNo">수신안함</label></td>
							</tr>
							</tbody>
							</table>
							<p><strong class="txtBtwDk">전자보증서 발급에는 별도의 수수료가 부과되지 않습니다. 전자보증서 발급에 필요한 최소한의 개인정보가 서울 보증보험사에 제공되며, 다른 용도로 사용되지 않습니다.</strong></p>
						</div>
					</div>

					<div class="section">
						<ul class="txtList01 txtBlk">
							<li>무통장 입금은 입금후 1시간 이내에 확인되며, 입금확인시 배송이 이루어 집니다.</li>
							<li>무통장 주문후 7일 이내에 입금이 되지 않으면 주문은 자동으로 취소됩니다. 한정 상품 주문시 유의하셔 주시기 바랍니다.</li>
						</ul>
					</div>
				</div>
				<!-- //for dev msg : 무통장입금일 경우 -->

				<div class="note">
					<strong>유의사항</strong>
					<ul class="txtList01 txtBlk">
						<li>마일리지는 상품금액 30,000원 이상 결제시 사용 가능합니다.</li>
						<li>예치금의 적립, 사용 내역 확인 및 무통장입금 신청은 마이텐바이텐에서 가능합니다.</li>
						<li>Gift 카드는 인증번호 등록 후 사용할 수 있으며, 등록 및 사용 내역 확인은 마이텐바이텐에서 가능합니다.</li>
						<li>상품쿠폰과 보너스쿠폰은 중복사용이 불가능합니다.</li>
						<li>무료배송 보너스 쿠폰은 텐바이텐 주문 금액 기준입니다.</li>
						<li>보너스쿠폰 중 %할인쿠폰은 이미 할인을 하는 상 품에 대해서는 중복 적용이 되지 않습니다.</li>
						<li>정상판매가 상품 중 일부 상품은 %할인쿠폰이 적용되지 않습니다.</li>
						<li>보너스쿠폰 중 금액할인쿠폰을 사용하여 여러개의 상품을 구매 하시는 경우, 상품별 판매가에 따라 할인금액이 각각 분할되어 적용됩니다.</li>
					</ul>
				</div>
			</fieldset>
			<!-- //결제수단 -->

			<div class="btnOrderWrap">
				<input type="submit" value="주문하기" class="btn02 edwPk btnBig" />
			</div>
			</form>
		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>