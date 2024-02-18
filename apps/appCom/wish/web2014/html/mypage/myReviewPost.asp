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
						<h1 class="title"><span class="label">상품 후기 등록</span></h1>
					</div>
				</div>
				<div class="well type-b">
					<ul class="txt-list">
						<li>상품후기를 작성하시면 100point 가 적립되며 배송정보 [출고완료] 이후부터 작성하실 수 있습니다. </li>
					</ul>
				</div>
				<div class="inner">
					<div class="bordered-box filled">
						<div class="product-info gutter">
							<div class="product-img">
								<img src="../../img/_dummy-200x200.png" alt="">
							</div>
							<div class="product-spec">
								<p class="product-brand">[A.MONO FURNITURE STUDIO STUDIO] </p>
								<p class="product-name">처칠머그컵(런던트레블, 크라운실루엣 중 택1) 처칠..</p>
								<p class="product-option">옵션 : gray</p>
							</div>
							<div class="price">
								<strong>23,000</strong>원 
							</div>
						</div>
					</div>
				</div>
				<form action="">
				<div class="inner">
					<textarea name="" id="" cols="30" rows="10" placeholder="상품후기를 입력해주세요. " class="form bordered" style="height:160px;"></textarea>
					<div class="diff"></div>
					<em class="em" style="margin:5px 0;">* 포토후기는 최대 2장의 이미지를 첨부하실 수 있습니다.</em>
					<ul class="files">
						<li><input type="file" class="form bordered full-size"></li>
						<li><input type="file" class="form bordered full-size"></li>
					</ul>
					<div class="diff-10"></div>
					<div class="rating t-c">
						<div class="stars">
							<a href="#">★</a>
							<a href="#">★</a>
							<a href="#">★</a>
							<a href="#">★</a>
						</div>
						<small>별을 터치하여 별점을 매겨주세요. </small>
					</div>
					<script>
						$('.stars a').each(function(index){
							$(this).on('click', function(){
								$('.stars a').addClass('active');
								$('.stars a:gt('+index+')').removeClass('active');
								var rate = index+1;
								console.log(rate);
								//rate값이 최종 별점임
								return false;
							});
						});
					</script>
				</div>
				<div class="form-actions highlight">
					<div class="two-btns">
						<div class="col"><button class="btn type-b">등록</button></div>
						<div class="col"><button class="btn type-a">취소</button></div>
					</div>
					<div class="clear"></div>
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