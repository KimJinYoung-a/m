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
						<h1 class="title"><span class="label">나의 국내  주소록  등록</span></h1>
					</div>
				</div>      
				<div class="diff"></div>
				<div class="inner">
					<div class="input-block">
						<label for="addressTitle" class="input-label">배송지명</label>
						<div class="input-controls">
							<input type="text" name="addressTitle" id="addressTitle" class="form full-size">
						</div>
					</div>
					<div class="input-block">
						<label for="addressName" class="input-label">수령인명</label>
						<div class="input-controls">
							<input type="text" name="addressName" id="addressName" class="form full-size">
						</div>
					</div>
					<div class="input-block">
						<label for="phone" class="input-label">전화번호</label>
						<div class="input-controls phone">
							<div><input type="tel" id="phone1" class="form" maxlength="3"></div>
							<div><input type="tel" id="phone2" class="form" maxlength="4"></div>
							<div><input type="tel" id="phone3" class="form" maxlength="4"></div>
						</div>
					</div>

					<div class="input-block">
						<label for="hp" class="input-label">휴대폰</label>
						<div class="input-controls phone">
							<div><input type="tel" id="hp1" class="form" maxlength="3"></div>
							<div><input type="tel" id="hp2" class="form" maxlength="4"></div>
							<div><input type="tel" id="hp3" class="form" maxlength="4"></div>
						</div>
					</div>

					<div class="input-block">
						<label for="zipcode" class="input-label">수령인 주소</label>
						<div class="input-controls zipcode">
							<div><input type="text" id="zipcode1" class="form full-size" maxlength="3"></div>
							<div><input type="text" id="zipcode2" class="form full-size" maxlength="3"></div>
							<button class="btn type-c btn-findzipcode side-btn">우편번호검색</button>
						</div>
					</div>
					<div class="input-block no-label">
						<label for="address1" class="input-label">주소2</label>
						<div class="input-controls">
							<input type="text" id="address1" class="form full-size">
						</div>
					</div>
					<div class="input-block no-label">
						<label for="address2" class="input-label">주소3</label>
						<div class="input-controls">
							<input type="text" id="address2" class="form full-size">
						</div>
					</div>
				</div>
				<div class="form-actions highlight tMar20">
					<div class="two-btns">
						<div class="col"><button class="btn type-b full-size">등록</button></div>
						<div class="col"><button class="btn type-c full-size">취소</button></div>
					</div>
					<div class="clear"></div>
				</div>
			</div><!-- #content -->
		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/incFooter.asp" -->
</div>
</body>
</html>