<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<script>
$(function(){
	$('.label').click(function(){
		$(this).toggleClass('open closed');
		$('.open').text('공개');
		$('.closed').text('비공개');
	});
});
</script>
</head>
<body>
<div class="heightGrid bgGry">
	<div class="container popWin">
		<div class="header">
			<h1>위시폴더</h1>
			<p class="btnPopClose"><button class="pButton" onclick="#">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="wishFolder inner5 tPad20">
				<div class="tab01">
					<ul class="tabNav tNum2 noMove">
						<li><a href="#">폴더목록<span></span></a></li>
						<li class="current"><a href="#">폴더관리<span></span></a></li>
					</ul>
					<div class="box1">
						<div class="makeFolder">
							<div class="fType"><button class="label open">공개</button></div>
							<div class="fCont">
								<p class="box2">
									<input type="text" class="ftLt" placeholder="폴더 만들기(10자 이내)" /> <span class="button btM2 btRed cWh1 ftRt"><input type="submit" value="저장" /></span>
								</p>
								<ul class="tip">
									<li>- 공개 /비공개 아이콘 터치시 설정가능 합니다</li>
									<li>- 기본폴더 포함, 최대 20개 까지 등록 가능 합니다.</li>
								</ul>
							</div>
						</div>
						<!-- 폴더관리 -->
						<div class="manage">
							<ul class="folderList">
								<li>
									<div class="fType"><button class="label closed">비공개</button></div>
									<div class="fCont">
										<p class="tit">기본폴더</p>
										<div class="btnWrap">
											<span class="button btS1 btWht cBk1"><a href="#">수정</a></span>
											<span class="button btS1 btGry2 cWh1"><a href="#">삭제</a></span>
										</div>
									</div>
								</li>
								<li>
									<div class="fType"><button class="label open">공개</button></div>
									<div class="fCont">
										<!-- 수정 버튼 클릭 후 -->
										<p class="tit box2">
											<input type="text" class="w100p" value="나 이거 사줘!" />
											<input type="reset" class="btnDel" />
										</p>
										<div class="btnWrap">
											<span class="button btS1 btRed cWh1"><a href="#">확인</a></span>
											<span class="button btS1 btWht cBk1"><a href="#">취소</a></span>
										</div>
										<!--// 수정 버튼 클릭 후 -->
									</div>
								</li>
								<li>
									<div class="fType"><button class="label closed">비공개</button></div>
									<div class="fCont">
										<p class="tit">나에게 주는 선물</p>
										<div class="btnWrap">
											<span class="button btS1 btWht cBk1"><a href="#">수정</a></span>
											<span class="button btS1 btGry2 cWh1"><a href="#">삭제</a></span>
										</div>
									</div>
								</li>
								<li>
									<div class="fType"><button class="label open">공개</button></div>
									<div class="fCont">
										<p class="tit">하하호호헤헤히히후후</p>
										<div class="btnWrap">
											<span class="button btS1 btWht cBk1"><a href="#">수정</a></span>
											<span class="button btS1 btGry2 cWh1"><a href="#">삭제</a></span>
										</div>
									</div>
								</li>
							</ul>
						</div>
						<!--// 폴더관리 -->
					</div>
				</div>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>