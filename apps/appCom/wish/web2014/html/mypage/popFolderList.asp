<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<script>
$(function(){
	$('.list .folderList .tit').click(function(){
		$('.selected').removeClass('selected');
		$(this).addClass('selected');
	});

	$('.makeFolder .label').click(function(){
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
						<li class="current"><a href="#">폴더목록<span></span></a></li>
						<li><a href="#">폴더관리<span></span></a></li>
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
						<!-- 폴더목록 -->
						<div class="list">
							<ul class="folderList">
								<li>
									<div class="fType"><button class="label closed">비공개</button></div>
									<div class="fCont"><p class="tit" onclick="">기본폴더</p></div>
								</li>
								<li>
									<div class="fType"><button class="label open">공개</button></div>
									<div class="fCont"><p class="tit" onclick="">나 이거 사줘!</p></div>
								</li>
								<li>
									<div class="fType"><button class="label closed">비공개</button></div>
									<div class="fCont"><p class="tit" onclick="">나에게 주는 선물</p></div>
								</li>
								<li>
									<div class="fType"><button class="label open">공개</button></div>
									<div class="fCont"><p class="tit" onclick="">하하호호헤헤히히후후</p></div>
								</li>
							</ul>
						</div>
						<!--// 폴더목록 -->
					</div>
				</div>
			</div>
		</div>
		<div class="floatingBar">
			<div class="btnWrap">
				<div class="ftBtn"><span class="button btB1 btRed cWh1 w100p"><input type="submit" value="확인" /></span></div>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>