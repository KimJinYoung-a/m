<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<script>
$(function(){
	$('.agrReceive .agree').click(function(){
		$('.agrCont').slideToggle();
		$(this).toggleClass('on')
	});
});
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin bgGry">
		<div class="header">
			<h1>회원가입</h1>
			<p class="btnPopClose"><button class="pButton" onclick="#">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content" id="contentArea">
			<!-- 회원가입 - 2.정보입력 -->
			<div class="join inner5">
				<div class="joinStep">
					<ol>
						<li class="on"><span>1</span>약관동의</li>
						<li class="on"><span>2</span>정보입력</li>
						<li><span>3</span>본인인증</li>
						<li><span>4</span>약관동의</li>
					</ol>
				</div>
				<div class="writeInfo box1">
					<section>
						<table class="writeTbl01">
							<colgroup>
								<col width="25%" />
								<col width="" />
							</colgroup>
							<tbody>
								<tr>
									<th>아이디</th>
									<td>
										<input type="text" class="w60p" title="아이디 입력" /><span class="button btB2 btGry cBk1 lMar05"><a href="">중복확인</a></span>
										<p class="tMar05">3~15자의 영문/숫자를 조합하여 입력</p>
									</td>
								</tr>
								<tr>
									<th>비밀번호</th>
									<td><input type="password" class="w100p" title="비밀번호 입력" /></td>
								</tr>
								<tr>
									<th>비밀번호 확인</th>
									<td>
										<input type="password" class="w100p" title="비밀번호 확인" />
										<p class="cRd1 tMar05">8~16자의 영문/숫자를 조합하여 입력</p>
									</td>
								</tr>
							</tbody>
						</table>
					</section>
					<section>
						<table class="writeTbl01">
							<colgroup>
								<col width="25%" />
								<col width="" />
							</colgroup>
							<tbody>
								<tr>
									<th>이름</th>
									<td><input type="text" class="w100p" title="이름 입력" /></td>
								</tr>
								<tr>
									<th>성별</th>
									<td>
										<span><input type="radio" id="male" /> <label for="male" class="lMar05">남자</label></span>
										<span class="lMar30"><input type="radio" id="female" /> <label for="female" class="lMar05">여자</label></span>
									</td>
								</tr>
								<tr>
									<th>생일</th>
									<td>
										<select title="태어난 년도 선택" class="w30p">
											<option value="1997">1997</option>
										</select>
										<select title="태어난 월 선택" class="w30p lMar05">
											<option value="01">01월</option>
										</select>
										<select title="태어난 일 선택" class="w30p lMar05">
											<option value="01">01일</option>
										</select>
										<p class="cRd1 tMar05">★ 생일 쿠폰을 선물로 드립니다.</p>
									</td>
								</tr>
							</tbody>
						</table>
					</section>
					<section>
						<table class="writeTbl01">
							<colgroup>
								<col width="25%" />
								<col width="" />
							</colgroup>
							<tbody>
								<tr>
									<th>이메일</th>
									<td><input type="email" class="w60p" /><span class="button btB2 btGry cBk1 lMar05"><a href="">중복확인</a></span></td>
								</tr>
								<tr>
									<th>휴대폰</th>
									<td>
										<select title="휴대전화 앞자리 선택" class="w30p">
											<option value="010">010</option>
										</select>
										<input type="tel" class="w30p lMar05" />
										<input type="tel" class="w30p lMar05" />
										<p class="tMar05 lh12">이메일 및 휴대폰 정보는 보안 인증 및 아이디 찾기, 비밀번호 재발급시 이용됩니다.</p>
									</td>
								</tr>
							</tbody>
						</table>
					</section>
				</div>
				<div class="box1 inner5 agrReceive">
					<p class="agree"><input type="checkbox" /> <em class="lMar05">이메일/SMS 수신에 동의합니다.</em></p>
					<div class="agrCont">
						<dl>
							<dt>이메일 수신동의</dt>
							<dd>
								<p><input type="checkbox" id="mTenten" /> <label for="mTenten">텐바이텐</label></p>
								<p><input type="checkbox" id="mFingers" /> <label for="mFingers">핑거스 아카데미</label></p>
							</dd>
						</dl>
						<dl>
							<dt>SMS 수신동의</dt>
							<dd>
								<p><input type="checkbox" id="sTenten" /> <label for="sTenten">텐바이텐</label></p>
								<p><input type="checkbox" id="sFingers" /> <label for="sFingers">핑거스 아카데미</label></p>
							</dd>
						</dl>
						<p class="lh14">수신동의를 하시면 텐바이텐 및 핑거스 아카데미에서 제공하는 다양한 할인 혜택과 이벤트/신상품 등의 정보를 만나실 수 있습니다. <br /><em class="cRd1">주문 및 배송관련 SMS는 수신동의와 상관없이 자동 발송합니다.</em></p>
					</div>
				</div>
				<p class="tMar20"><span class="button btB1 btRed cWh1 w100p"><a href="">다음</a></span></p>
			</div>
			<!--// 회원가입 - 2.정보입력 -->
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>