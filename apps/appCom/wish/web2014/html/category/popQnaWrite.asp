<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<div class="header">
			<h1>상품문의</h1>
			<p class="btnPopClose"><button class="pButton" onclick="#">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="qnaPdt">
				<div class="pPhoto"><p><span><em>품절</em></span></p><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_286x286.jpg" alt="" /></div><!-- for dev msg : 상품명 alt값 속성에 넣어주세요 -->
				<div class="pdtCont">
					<p class="pBrand">MINI BUS</p>
					<p class="pName">소니엔젤 아티스트 컬렉션</p>
					<p class="pPrice tMar10">8,000원 <span class="cRd1">[20%]</span></p>
				</div>
			</div>
			<div class="qnaWrite">
				<div class="overHidden">
					<p class="ftLt w30p tMar10"><input type="checkbox" id="receiveMail" /> <label for="receiveMail"><strong class="fs12">답변메일 받기</strong></label></p>
					<p class="ftLt w70p lPad10"><input type="email" class="w100p" value="tenbyten@naver.com" /></p>
				</div>
				<textarea class="w100p tMar10" cols="30" rows="8" title="문의내용 작성"></textarea>
			</div>
		</div>
		<div class="floatingBar">
			<div class="btnWrap">
				<div class="ftBtn"><span class="button btB1 btRed cWh1 w100p"><input type="submit" value="등록" /></span></div>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>