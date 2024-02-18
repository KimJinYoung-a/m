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
						<h1 class="title"><span class="label">1:1 상담 신청</span></h1>
					</div>
				</div>
				<div class="well type-b">
					<ul class="txt-list">
						<li>한번 등록한 상담내용은 수정이 불가능하므로 신중히 입력하여 주시기 바랍니다. </li>
					</ul>
				</div>
				<div class="diff"></div>
				<form action="">
				<div class="inner">
					<div class="categories">
						<h1 class="red">구매관련 문의</h1>
						<ul>
							<li><label for="cat1_1"><input type="radio" class="form type-c" name="cat1" id="cat1_1"> 배송</label></li>
							<li><label for="cat1_2"><input type="radio" class="form type-c" name="cat1" id="cat1_2"> 주문</label></li>
							<li><label for="cat1_3"><input type="radio" class="form type-c" name="cat1" id="cat1_3"> 취소</label></li>
							<li><label for="cat1_4"><input type="radio" class="form type-c" name="cat1" id="cat1_4"> 반품</label></li>
							<li><label for="cat1_5"><input type="radio" class="form type-c" name="cat1" id="cat1_5"> 교환/AS</label></li>
							<li><label for="cat1_6"><input type="radio" class="form type-c" name="cat1" id="cat1_6"> 환불</label></li>
							<li><label for="cat1_7"><input type="radio" class="form type-c" name="cat1" id="cat1_7"> 사은품</label></li>
							<li><label for="cat1_8"><input type="radio" class="form type-c" name="cat1" id="cat1_8"> 입금</label></li>
							<li><label for="cat1_9"><input type="radio" class="form type-c" name="cat1" id="cat1_9"> 증빙서류</label></li>
							<li><label for="cat1_10"><input type="radio" class="form type-c" name="cat1" id="cat1_10"> 이벤트</label></li>
						</ul>
						<div class="clear"></div>
					</div>

					<div class="categories">
						<h1 class="red">일반상담 문의</h1>
						<ul>
							<li><label for="cat2_1"><input type="radio" class="form type-c" name="cat2" id="cat2_1"> 회원정보</label></li>
							<li><label for="cat2_2"><input type="radio" class="form type-c" name="cat2" id="cat2_2"> 회원제도</label></li>
							<li><label for="cat2_3"><input type="radio" class="form type-c" name="cat2" id="cat2_3"> 결제방법</label></li>
							<li><label for="cat2_4"><input type="radio" class="form type-c" name="cat2" id="cat2_4"> 상품</label></li>
							<li><label for="cat2_5"><input type="radio" class="form type-c" name="cat2" id="cat2_5"> 당첨</label></li>
							<li><label for="cat2_6"><input type="radio" class="form type-c" name="cat2" id="cat2_6"> 쿠폰/마일리지</label></li>
						</ul>
						<div class="clear"></div>
					</div>

					<div class="categories">
						<h1 class="red">기타 문의</h1>
						<ul>
							<li><label for="cat3_1"><input type="radio" class="form type-c" name="cat3" id="cat3_1"> 오프라인</label></li>
							<li><label for="cat3_2"><input type="radio" class="form type-c" name="cat3" id="cat3_2"> 아이띵소</label></li>
							<li><label for="cat3_3"><input type="radio" class="form type-c" name="cat3" id="cat3_3"> 시스템</label></li>
							<li><label for="cat3_4"><input type="radio" class="form type-c" name="cat3" id="cat3_4"> 기타</label></li>
						</ul>
						<div class="clear"></div>
					</div>

					<hr class="week">

					<div class="input-block">
						<label for="orderno" class="input-label">주문번호</label>
						<div class="input-controls">
							<input type="text" name="orderno" id="orderno" class="form full-size" >
							<button class="btn side-btn type-a">조회</button>
						</div>
					</div>
					<em class="em red">주문일 2013-12-01 / 총 결제금액 9,700원 (신용카드)</em>
					<div class="input-block">
						<label for="productCode" class="input-label">상품코드</label>
						<div class="input-controls">
							<input type="text" name="productCode" id="productCode" class="form full-size" >
							<button class="btn side-btn type-a">조회</button>
						</div>
					</div>
					<em class="em red">[WOMAN]SLU12-GRAY 4,500 원</em>

					<hr class="week">
					<table class="plain type-b">
						<colgroup>
							<col width="100"/>
							<col/>
							<tr>
								<th>주문자</th>
								<td>홍길동</td>
							</tr>
							<tr>
								<th>아이디</th>
								<td>DAREZ [YELLOW 고객 ]  </td>
							</tr>
						</colgroup>
					</table>
					<div class="input-block">
						<label for="email" class="input-label">이메일</label>
						<div class="input-controls">
							<input type="email" name="email" id="email" class="form full-size" >
						</div>
					</div>

					<div class="input-block no-label">
						<label for="title" class="input-label">제목</label>
						<div class="input-controls">
							<input type="text" name="title" id="title" class="form full-size" placeholder="제목을 입력하세요.">
						</div>
					</div>
					<textarea name="question" id="question" class="form bordered full-size" placeholder="내용을 입력하세요." style="height:150px; margin-bottom:5px;"></textarea>
					<div class="input-block">
						<label for="phone" class="input-label">휴대전화</label>
						<div class="input-controls">
							<input type="tel" name="phone" id="phone" class="form full-size" >
						</div>
					</div>
					<em class="em">* 답변 등록 시 SMS가 발송됩니다.</em>
				</div>
				<div class="form-actions highlight">
					<button class="btn type-b full-size">상담하기</button>
				</div>
				</form>
			</div><!-- #content -->

		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/incFooter.asp" -->
</div>
</body>
</html>