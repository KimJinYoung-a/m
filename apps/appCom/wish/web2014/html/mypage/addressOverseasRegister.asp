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
				<div class="well type-b">
				<ul class="txt-list">
					<li><strong class="red">해외 배송지의 모든 정보는 꼭 영문 작성이 필요합니다.<br />(배송지명은 한글 가능) </strong></li>
				</ul>
			</div>
				<div class="inner">
					<div class="diff"></div>
					<div class="main-title">
						<h1 class="title"><span class="label">나의 해외 주소록  등록</span></h1>
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
						<label for="email" class="input-label">이메일</label>
						<div class="input-controls">
							<input type="email" id="email" class="form full-size">
						</div>
					</div>

					<div class="input-block">
						<label for="country" class="input-label red">Country</label>
						<div class="input-controls country">
							<div>
								<select name="country" id="country1" class="form full-size">
									<option value="">국가선택</option>
									<option value="">KOREA</option>
								</select>
							</div>
							<div><input type="text" id="country2" class="form full-size" disabled="disabled"></div>
							<div><input type="text" id="country3" class="form full-size" disabled="disabled"></div>
							
						</div>
					</div>
					<div class="input-block">
						<label for="telNo" class="input-label red">Tel.No</label>
						<div class="input-controls telno">
							<div><input type="tel" id="phone1" class="form full-size"></div>
							<div><input type="tel" id="phone2" class="form full-size"></div>
							<div><input type="tel" id="phone3" class="form full-size"></div>
							<div><input type="tel" id="phone4" class="form full-size"></div>
						</div>
					</div>
					<em class="em">* 국가번호 – 지역번호 – 국번 - 전화번호</em>
					<div class="input-block">
						<label for="zipcode" class="input-label red">Zip code</label>
						<div class="input-controls">
							<input type="text" class="form full-size" id="zipcode">
						</div>
					</div>
					<div class="input-block">
						<label for="addresds" class="input-label red">Address</label>
						<div class="input-controls">
							<input type="text" class="form full-size" id="addresds">
						</div>
					</div>
					<div class="input-block">
						<label for="city" class="input-label red">City / State</label>
						<div class="input-controls">
							<input type="text" class="form full-size" id="city">
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