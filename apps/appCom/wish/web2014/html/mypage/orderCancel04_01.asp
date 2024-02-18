<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/mypage2013.css">
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content mypage" id="contentArea">

			<!-- #content -->
			<div id="content">
				<div class="inner">
					<div class="diff"></div>
					<div class="main-title">
						<h1 class="title"><span class="label">주문 취소 신청</span></h1>
					</div>
				</div>
				<div class="well type-b">
					<ul class="txt-list">
						<li>상품 일부만 취소하고자 하는 경우 1:1 상담 또는 고객센터로 문의 주시기 바랍니다.</li>
						<li>상품 준비중인 상품의 경우 1:1 상담 또는 고객센터를 통해 취소가 가능하며, 고객센터에서 출고 여부를 확인후에 취소여부를 안내해 드립니다. </li>
						<li>이미 출고된 상품이 있는 경우 주문 취소를 할 수 없습니다. </li>
						<li>PC 에서 반품 메뉴를 이용하시기 바랍니다.  </li>
						<li>사용하신 예치금, 마일리지 및 할인권은 취소 즉시 복원 됩니다. </li>
					</ul>
				</div>
				<div class="inner">
					<div class="bordered-box">
						<div class="box-meta">
							<span class="date">2013.12.12</span>
							<span class="box-title">주문번호(1234123)</span>
						</div>
					</div>
					<div class="diff"></div>
					<em class="em">*현재 주문건은 전월에 <span class="red">핸드폰 결제된 주문</span>이므로 즉시 취소가 불가능하므로 <span class="red">고객님의 계좌로 환불</span> 됩니다. </em>
					<div class="tabs type-c four">
						<a href="#">주문상품</a>
						<a href="#">구매자</a>
						<a href="#">결제</a>
						<a href="#" class="active">환불</a>
					</div>
					<div class="diff-10"></div>
					<table class="filled">
						<colgroup>
							<col width="140"/>
							<col/>
						</colgroup>
						<tr class="highlight">
							<th>환불금액</th>
							<td>14,400<span class="unit">원</span></td>
						</tr>
						<tr>
							<td colspan="2" class="t-l">
								<form action="">
									<div class="input-block no-bg no-label">
										<div class="input-controls">
											<span class="small" style="margin:0 20px;">환불방법</span>
											<label for="way1" style="margin-right:10px;">
												<input type="radio" id="way1" name="way" class="form type-c" checked="checked">
												계좌환불
											</label>
											<label for="way2" style="margin-right:10px;">
												<input type="radio" id="way2" name="way" class="form type-c">
												예치금전환
											</label>
										</div>
									</div>
									<div class="input-block">
										<label for="bank" class="input-label">환불 계좌은행</label>
										<div class="input-controls">
											<select name="bank" id="bank" class="form full-size">
												<option value="">선택하세요</option>
											</select>
										</div>
									</div>
									<div class="input-block">
										<label for="acount" class="input-label">환불 계좌번호</label>
										<div class="input-controls">
											<input type="text" id="acount" class="form full-size">
										</div>
									</div>
									<div class="input-block">
										<label for="bankName" class="input-label">환불계좌 예금주</label>
										<div class="input-controls">
											<input type="text" id="bankName" class="form full-size">
										</div>
									</div>
								</form>
							</td>
						</tr>
					</table>

					<div class="diff-10"></div>
					<div class="well">
						<ul class="txt-list">
							<li>계좌번호 등록 시에는 대시(-)를 제외한 숫자만 입력이 가능 합니다.</li>
							<li>계좌번호 및 예금주 명이 정확하지 않으면 입금이 지연될 수 있습니다. </li>
							<li>접수 후, 1~2일내에(영업일 기준) 등록하신 계좌(마일리지)로 환불되며, </li>
							<li>환불시 문제메시지로 안내 해 드립니다. </li>
						</ul>
					</div>
					<div class="diff"></div>
					<div class="order-total-box">
						<h1>총결제금액</h1>
						<table class="filled">
							<tr>
								<th>주문상품수</th>
								<td>2<span class="unit">종(2개)</span></td>
							</tr>
							<tr>
								<th>적립마일리지</th>
								<td>144<span class="unit">Point</span></td>
							</tr>
							<tr>
								<th>총 배송비</th>
								<td>2,500<span class="unit">원</span></td>
							</tr>
							<tr>
								<th>상품 총금액</th>
								<td>14,400<span class="unit">원</span></td>
							</tr>
							<tr>
								<th>총 합계금액</th>
								<td><strong>16,900<span class="unit">원</span></strong></td>
							</tr>
						</table>
					</div>
					<div class="diff-10"></div>
					<p class="well">주문 제작상품의 특성상 제작이 들어간 경우, 취소가 불가능할 수 있습니다. </p>
				</div>
				<div class="form-actions highlight">
					<button class="btn type-a full-size">전체취소</button>
				</div>
			</div><!-- #content -->

		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/incFooter.asp" -->
</div>
</body>
</html>