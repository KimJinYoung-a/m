<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
<script style="text/javascript">
	// 수정 2014.04.30
	var myTerms;
	function loaded() {
		myTerms = new iScroll('termsScroll');
	}
	document.addEventListener('DOMContentLoaded', function () { setTimeout(loaded, 200); }, false);

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
					<a href="" class="beforeLogin"><strong>텐바이텐</strong> ID가 있으시다면?</a><!-- for dev msg : 일반(비회원/로그인전) -->
				</div>
			</div>

			<form action="" name="tempfrm">
			<!-- 개인정보 수집 및 이용 동의 -->
			<fieldset>
				<div class="hWrap hrBtw">
					<h2 class="headingB first"><span>1</span> 개인정보 수집 및 이용 동의</h2>
				</div>

				<div class="privacy">
					<p>상품 주문, 배송을 위해 다음의 개인정보 수집 및 이용에 동의 후 서비스 이용이 가능합니다.</p>
					<div class="terms">
						<!-- 수정 2014.04.30 -->
						<div class="scrollerWrap">
							<div id="termsScroll">
								<div class="scroll">
									<div class="group">
										<h3>1. 수집하는 개인정보 항목</h3>
										<p>- e-mail, 전화번호, 성명, 주소, 대금 결제에 관한 정보<br /> (단 주문자와 수령인이 다른 경우 수령자의 이름, 주소, 연락처)</p>
										<h3>2. 수집 목적</h3>
										<ul>
											<li>① e-mail, 전화번호: 고지의 전달. 불만처리나 주문/배송정보 안내 등 원활한 의사소통 경로의 확보</li>
											<li>② 성명, 주소: 고지의 전달, 청구서, 정확한 상품 배송지의 확보</li>
											<li>③ 대금 결제에 관한 정보: 구매상품에 대한 환불시 확보</li>
										</ul>
										<h3>3. 개인정보 보유기간</h3> 
										<ul>
											<li>① 계약 또는 청약철회 등에 관한 기록 : 5년</li>
											<li>② 대금결제 및 재화 등의 공급에 관한 기록 : 5년</li>
											<li>③ 소비자의 불만 또는 분쟁처리에 관한 기록 : 3년</li>
										</ul>
										<p><strong>4. 비회원 주문 시 제공하신 모든 정보는 상기 목적에 필요한 용도 이외로는 사용되지 않습니다. 기타 자세한 사항은 '개인정보취급방침'을 참고하여주시기 바랍니다.</strong></p>
									</div>
								</div>
							</div>
						</div>
						<!-- //수정 2014.04.30 -->
					</div>
					<p><input type="checkbox" id="agreeCheck" /> <label for="agreeCheck"><strong class="txtBtwDk">개인정보 수집 및 이용에 대한 내용을 확인하였으며 만 14세 구매자임에 동의 합니다.</strong></label></p>
				</div>
			</fieldset>
			<!-- //개인정보 수집 및 이용 동의 -->

			<!-- 주문리스트 확인 -->
			<fieldset>
				<div class="hWrap hrBtw">
					<h2 class="headingB"><span>2</span> 주문리스트 확인 (2종/3개 <strong class="txtBtwDk">182,900</strong>원)</h2>
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
							</div>
						</li>
					</ul>
				</div>
			</fieldset>
			<!-- //주문리스트 확인 -->

			<!-- 주문고객 정보 -->
			<fieldset>
				<div class="hWrap hrBtw">
					<h2 class="headingB"><span>3</span> 주문고객 정보</h2>
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
					<h2 class="headingB"><span>4</span> 배송지 정보입력</h2>
				</div>

				<div class="selectOption">
					<span><input type="radio" id="delivery01" name="" /> <label for="delivery01">최근 배송지</label></span>
					<span><input type="radio" id="delivery02" name="" /> <label for="delivery02">새로운 주소</label></span>
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
							<div class="address">
								<div class="row zipcodeField">
									<div class="cell">
										<span class="zipcodeFront"><input type="text" title="우편번호 앞자리" name="txZip1" /></span>
										<span class="symbol">-</span>
										<span class="zipcodeBack"><input type="text" title="우편번호 뒷자리" name="txZip2" /></span>
									</div>
									<div class="optional">
										<span class="btn02 btw"><a href="#" onclick="jsOpenPopup('/apps/appCom/between/common/myaddrchange.asp?target=tempfrm');">우편번호 찾기</a></span>
									</div>
								</div>
								<div class="basics"><input type="text" title="기본주소" name="txAddr1" /></div>
								<div class="detailed"><input type="text" title="상세주소" name="txAddr2" /></div>
							</div>
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
			<div id="modalCont" class="lyrPopWrap boxMdl midLyr" style="display:none;"></div>
			<!-- //배송지 정보입력 -->

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
								<td><input type="radio" id="agreeYes" name="" checked="checked" /> <label for="agreeYes">동의함</label></td>
								<td><input type="radio" id="agreeNo" name="" /> <label for="agreeNo">동의안함</label></td>
							</tr>
							<tr>
								<th scope="row">이메일 수신동의</th>
								<td><input type="radio" id="emailYes" name="" checked="checked" /> <label for="emailYes">수신</label></td>
								<td><input type="radio" id="emailNo" name="" /> <label for="emailNo">수신안함</label></td>
							</tr>
							<tr>
								<th scope="row">SMS 수신동의</th>
								<td><input type="radio" id="smsYes" name="" checked="checked" /> <label for="smsYes">수신</label></td>
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