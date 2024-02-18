<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<script>
$(function() {
	mySwiper = new Swiper('.coverFullBnr .swiper-container',{
		pagination:'.pagination',
		paginationClickable: true,
		calculateHeight:true
	})

	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			mySwiper.reInit();
				clearInterval(oTm);
			}, 500);
	});
});
</script>
</head>
<body>
<div class="coverFullBnr">
	<div class="swiper-container">
		<div class="swiper-wrapper">
			<p class="swiper-slide"><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/fullbnr01.png" alt="" /></a></p><!-- for dev msg : alt값 속성에 이벤트명 넣어주세요 -->
			<p class="swiper-slide"><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/fullbnr02.png" alt="" /></a></p>
			<p class="swiper-slide"><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/fullbnr01.png" alt="" /></a></p>
			<p class="swiper-slide"><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/fullbnr02.png" alt="" /></a></p>
		</div>
		<div class="pagination"></div>
	</div>
	<div class="winCloseArea">
		<p class="ftLt">
			<input type="checkbox" id="notReview" /> <label for="notReview">다시 보지않기</label>
		</p>
		<p class="ftRt"><span class="button btM1 btRed cWh1"><a href="">닫기</a></span></p>
	</div>
</div>
</body>
</html>