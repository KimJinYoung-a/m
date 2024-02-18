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

			<!-- wrapper -->
			<div class="wrapper myinfo">
					<!-- #header -->
					<header id="header">
							<div class="tabs type-c">
									<a href="" class="active">나의 정보 관리</a>
									<a href="">비밀번호 변경</a>
							</div>
					</header><!-- #header -->

					<!-- #content -->
					<div id="content">
							<div class="inner">
									<!-- form -->
									<form action="">

											<div class="main-title">
													<h1 class="title"><span class="label">회원 기본 정보</span></h1>
											</div>

											<div class="input-block">
													<label for="name" class="input-label">이름</label>
													<div class="input-controls disabled">
															<input type="text" id="name" value="이한나" class="form full-size" disabled="disabled">
													</div>
											</div>

											<div class="input-block">
													<label for="birth" class="input-label">생년월일</label>
													<div class="input-controls birth">
															<div><span><input type="number" id="year" class="form" maxlength="4" value="1979"></span>년</div>
															<div><span><input type="number" id="month" class="form" maxlength="2" value="01"></span>월</div>
															<div><span><input type="number" id="day" class="form" maxlength="2" value="01"></span>일</div>
													</div>
											</div>

											<div class="toggle form small">
													<button value="sun" class="active"><span class="label">양력</span></button>
													<button value="moon"><span class="label">음력</span></button>
													<input type="hidden" name="birthType" id="birthType" value="sun">
											</div>
											<div class="clear"></div>
											<em class="em">* 등록된 생일 1주일 전 생일 축하쿠폰을 선물로 드립니다.</em>
											
											<div class="input-block">
													<label for="zipcode" class="input-label">주소</label>
													<div class="input-controls zipcode">
															<div><input type="text" id="zipcode1" class="form full-size" maxlength="3" value="123"></div>
															<div><input type="text" id="zipcode2" class="form full-size" maxlength="3" value="123"></div>
															<button class="btn type-c btn-findzipcode side-btn">우편번호검색</button>
													</div>
											</div>
											<div class="input-block no-label">
													<label for="address1" class="input-label">주소2</label>
													<div class="input-controls">
															<input type="text" id="address1" class="form full-size" value="서울특별시 강남구 신사동">
													</div>
											</div>
											<div class="input-block no-label">
													<label for="address2" class="input-label">주소3</label>
													<div class="input-controls">
															<input type="text" id="address2" class="form full-size" value="561-16 국제빌딩 4층">
													</div>
											</div>
											<em class="em">* 기본배송시 주소는 상품배송이나 이벤트경품 등의 배송에 사용되므로 정확히 입력해 주세요.</em>

											<div class="main-title">
													<h2 class="title"><span class="label">이메일/휴대폰</span></h2>
											</div>

											<p>이메일 주소 및 휴대폰 번호는 본인인증 및 아이디 찾기, 비밀번호 재발급시 이용되는 정보이므로 정확하게 입력하여 주세요. 아직 인증대기상태이신 경우 이메일 또는 휴대폰으로 사용자 인증을 해주세요. 본인확인 용도로 사용됩니다. </p>
											<div class="diff-10"></div>
											<div class="input-block email-block">
													<label for="email1" class="input-label">이메일</label>
													<div class="input-controls email-type-b">
															
															<input type="text" id="email1" name="buyemail_Pre" maxlength="40" value="" class="form">
															@
															<input type="text" name="buyemail_Tx" id="buyemail_Tx" value="" class="form" style="display:none;">
															
															<select name="buyemail_Bx" id="select3" onChange="jsShowMailBox('document.frmorder','buyemail_Bx','buyemail_Tx');" class="form bordered">
																	<option value="gmail.com">gmail.com</option>
																	<option value="daum.net">daum.net</option>
																	<option value="naver.com">naver.com</option>
																	<option value="etc">직접입력</option>
															</select>
															<!-- "중복확이 버튼"은 사용하지 않으시면 지우세요. 혹시나 다른 페이지에서 이와 같은 형식의 이메일폼이 있을 경우 필요할 수도 있기 때문에 넣었습니다. -->
															<button class="btn type-a small">중복확인</button>
													</div>
											</div> 
											<div class="auth-area">
													<span class="pull-left">[인증대기상태]</span>
													<button class="btn type-e pull-right">이메일 인증하기</button>
											</div>
											<div class="clear"></div>
											<div class="input-block">
													<label for="phone" class="input-label">휴대폰</label>
													<div class="input-controls phone">
															<div><input type="tel" id="phone1" class="form" maxlength="3" value="010"></div>
															<div><input type="tel" id="phone2" class="form" maxlength="4" value="1234"></div>
															<div><input type="tel" id="phone3" class="form" maxlength="4" value="5678"></div>
													</div>
											</div>
											<div class="auth-area">
													<span class="pull-left">[인증대기상태]</span>
													<button class="btn type-e pull-right">휴대폰 인증하기</button>
											</div>
											<div class="clear"></div>
											<div class="diff"></div>
											<div class="main-title">
													<h2 class="title"><span class="label">수신동의</span></h2>
											</div>
											<div class="radio-block">
													<span class="label">이메일 수신동의</span>
													<span class="radios">
															<label for="10x10">
																	<input type="checkbox" class="form" value="10x10" id="10x10"> 텐바이텐
															</label>
															<label for="fingers">
																	<input type="checkbox" class="form" value="fingers" id="fingers"> 핑거스 아카데미
															</label>
													</span>
											</div>
											<div class="well">이메일 수신동의를 하시면 텐바이텐 및 핑거스 아카데미에서 제공하는 다양한 할인혜택과 이벤트/신상품 등의 정보를 빠르게 만나실 수 있습니다.</div>
											
											<div class="radio-block">
													<span class="label">SMS 수신동의</span>
													<span class="radios">
															<label for="sms10x10">
																	<input type="checkbox" class="form" value="10x10" id="sms10x10"> 텐바이텐
															</label>
															<label for="smsfingers">
																	<input type="checkbox" class="form" value="fingers" id="smsfingers"> 핑거스 아카데미
															</label>
													</span>
											</div>

											<div class="well">SMS 수신동의를 하시면 텐바이텐 및 핑거스 아카데미에서 제공하는 다양한 할인혜택과 이벤트/신상품 등의 정보를 빠르게 만나실 수 있습니다. 주문 및 배송관련 SMS는 수신동의 여부와 상관없이 자동으로 발송됩니다.</div>

											<div class="radio-block">
													<span class="label">카카오톡 맞춤정보 수신동의</span>
													<button class="btn type-c btn-kakao-auth full-size">카카오톡 인증하기</button>
											
											</div>
											<div class="well">카카오톡 맞춤정보 서비스는 주문 및 배송 관련 메시지 및 다양한 혜택과 이벤트에 대한 정보를 SMS 대신 카카오톡으로 발송 드리는서비스입니다. 본 서비스는 스마트폰에 카카오톡이 설치되어 있어야 이용이 가능합니다. 카카오톡이 설치 되어 있지 않다면 설치 후 이용해 주시기 바랍니다.</div>

											<div class="diff"></div>
											<div class="main-title">
													<h2 class="title"><span class="label">이용 사이트 관리</span></h2>
											</div>
											<div class="t-c">
													<p style="margin:8px; font-size:14px;">핑거스 아카데미 www.thefingers.co.kr</p>
													<div class="toggle form small no-pull full-size" style="width:280px; margin:0 auto;">
															<button value="yes" class="active"><span class="label">이용함</span></button>
															<button value="no"><span class="label">이용하지 않음</span></button>
															<input type="hidden" name="theFingers" id="theFingers" value="yes">
													</div>
											</div>
											
											<div class="form-actions highlight">
													<div class="two-btns">
															<div class="col">
																	<button class="btn type-b full-size">수정</button>
															</div>
															<div class="col">
																	<button class="btn type-a full-size">취소</button>
															</div>
													</div>
													<div class="clear"></div>
											</div>

									</form><!-- form -->
							</div>
					</div><!-- #content -->

					<!-- #footer -->
					<footer id="footer">
							
					</footer><!-- #footer -->
			</div>
			<!-- wrapper -->

		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/incFooter.asp" -->
</div>
</body>
</html>