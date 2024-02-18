<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/jquery.masonry.min.js"></script>
<script>
$(function() {
	$('.wishCollectList li:nth-child(9)').addClass('big');
	$('.wishCollectList li:nth-child(2)').addClass('big');
	$('.wishCollectList li:nth-child(10n+2)').addClass('big');
	$('.wishCollectList li:nth-child(10n+9)').addClass('big');

	setTimeout(function(){
		var container = document.querySelector('.wishCollectList');
		$(".myWishList img").load(function(){
			var thumbH = $('.wishCollectList li:nth-child(3)').height();
			$('.wishCollectList li.big').css('height', thumbH*2+'px');

			var thumb2H = $('.wishFolderList li:nth-child(2)').height();
			$('.wishFolderList li.subTit').css('height', thumb2H+'px');

			var msnry = new Masonry( container, {
				columnWidth: container.querySelector('.grid-sizer')
			});
		});

		var thumbH = $('.wishCollectList li:nth-child(3)').height();
		$('.wishCollectList li.big').css('height', thumbH*2+'px');

		var thumb2H = $('.wishFolderList li:nth-child(2)').height();
		$('.wishFolderList li.subTit').css('height', thumb2H+'px');

		var msnry = new Masonry( container, {
			columnWidth: container.querySelector('.grid-sizer')
		});
	}, 300)

	$('.wishCollectList li').click(function(){
		$(this).addClass('selected');
	});

	$('.wishEditBtn').click(function(e){
		e.preventDefault();
		$('.wishCollectList li').prepend('<span></span>');
	});
});
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="myWish">
				<div class="myBox">
					<p class="pvtId">skyblue1014</p>
					<div class="pvtImgWrap">
						<div class="pvtImg"><img src="http://fiximage.10x10.co.kr/m/2014/common/thumb_member01.png" alt="" /></div><!-- 로그인 후엔 고객이 지정한 이미지 불려집니다(thumb_member01.png~thumb_member30.png) -->
						<p class="circleBtn mateView">
							<a href="">
								<span>5</span>
								<span>메이트</span>
							</a>
						</p>
						<p class="circleBtn followView">
							<a href="">
								<span>+</span>
								<span>팔로우</span>
							</a>
						</p>
						<ul class="myBadgeView">
							<li><div><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_white_badge01.png" alt="" /></div></li>
							<li><div><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_white_badge02.png" alt="" /></div></li>
							<li><div><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_white_badge03.png" alt="" /></div></li>
							<li><div><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_white_badge04.png" alt="" /></div></li>
							<li><div>+12</div></li>
						</ul>
					</div>
					<ul class="myWishFollow">
						<li>
							<a href="">
								<p>1,852</p> <span>위시</span>
							</a>
						</li>
						<li>
							<a href="">
								<p>852</p> <span>팔로워</span>
							</a>
						</li>
						<li>
							<a href="">
								<p>1,852</p> <span>팔로잉</span>
							</a>
						</li>
					</ul>
				</div>
				<div class="inner10">
					<!-- 나의 위시 컬렉션 -->
					<ul class="myWishList wishCollectList">
						<li class="grid-sizer"></li><!--고정 -->
						<li class="subTit">
							<h2>WISH<br />COLLECTION</h2>
							<p><a href="">폴더 리스트 보기</a></p>
						</li>
						<li>
							<a href="http://www.naver.com"><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></a><!-- for dev msg : 상품명 alt 속성에 넣어주세요 / 포토서버 이용해서 사이즈 정사각형으로 맞춰주세요 -->
						</li>
						<li>
							<a href="http://www.daum.net"><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></a>
						</li>
						<li>
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></a>
						</li>
						<li>
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></a>
						</li>
						<li>
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></a>
						</li>
						<li>
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></a>
						</li>
						<li>
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></a>
						</li>
						<li>
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></a>
						</li>
						<li>
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></a>
						</li>
						<li>
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></a>
						</li>
						<li>
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></a>
						</li>
						<li>
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></a>
						</li>
						<li>
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></a>
						</li>
						<li>
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></a>
						</li>
						<li>
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></a>
						</li>
						<li>
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></a>
						</li>
						<li>
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></a>
						</li>
						<li>
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></a>
						</li>
						<li>
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></a>
						</li>
						<li>
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></a>
						</li>
						<li>
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></a>
						</li>
						<li>
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></a>
						</li>
						<li>
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></a>
						</li>
						<li>
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></a>
						</li>
						<li>
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></a>
						</li>
						<li>
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></a>
						</li>
						<li>
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></a>
						</li>
						<li>
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></a>
						</li>
						<li>
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></a>
						</li>
						<li>
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></a>
						</li>
					</ul>
					<!-- //나의 위시 컬렉션 -->

					<!-- 폴더 리스트 -->
					<ul class="myWishList wishFolderList">
						<li class="subTit">
							<h2>WISH<br />COLLECTION</h2>
							<p><a href="">전체 위시보기</a></p>
						</li>
						<li>
							<a href="">
								<p class="folderInfo">
									<span class="folderName">기본폴더</span>
									<span>3</span>
								</p>
								<img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /><!-- for dev msg : 상품명 alt 속성에 넣어주세요 -->
							</a>
						</li>
						<li>
							<a href="">
								<p class="folderInfo">
									<span class="folderName">인테리어</span>
									<span>13</span>
								</p>
								<img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" />
							</a>
						</li>
						<li>
							<a href="">
								<p class="folderInfo">
									<span class="folderName">이거! 내꺼!</span>
									<span>13</span>
								</p>
								<img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" />
							</a>
						</li>
						<li>
							<a href="">
								<p class="folderInfo">
									<span class="folderName">센스쟁이</span>
									<span>13</span>
								</p>
								<img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" />
							</a>
						</li>
						<li>
							<a href="">
								<p class="folderInfo">
									<span class="folderName">사고야만다!</span>
									<span>13</span>
								</p>
								<img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" />
							</a>
						</li>
					</ul>
					<!-- //폴더 리스트 -->
				</div>
			</div>
		</div>

		<div class="floatingBar">
			<div class="btnWrap myWishBtn">
				<div><span class="button btB1 btRed cWh1 wishEditBtn"><a href="">수정</a></span></div>
				<!-- 수정 버튼 클릭시 변경
				<div><span class="button btB1 btRed cWh1"><a href="">삭제</a></span></div>
				<div><span class="button btB1 btRedBdr cRd1"><a href="">폴더이동</a></span></div>
				<div><span class="button btB1 btGryBdr cGy1"><a href="">취소</a></span></div>
				-->
			</div>
		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/incFooter.asp" -->
</div>
</body>
</html>