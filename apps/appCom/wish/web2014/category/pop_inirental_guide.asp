<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/web2014/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
</head>
<script>
$("document").ready(function() {
  /* float 버튼 제어 */
  var product = false;
  window.addEventListener("scroll", function(){
    var top = $(this).scrollTop();
    var top_roll = $(".rental-section01").offset().top +300;
    var bottom_roll = $(".rental-section02").offset().top -600;
    var btn = $(".btn-rental-float");
    if (top > top_roll) {
      btn.addClass("show");
    }
    if(top > bottom_roll) {
      btn.removeClass("show");
    }
  }, true)
});
</script>
</head>
<body class="default-font body-popup">
    <% If isApp<>"1" Then %>
        <header class="tenten-header header-popup">
            <div class="title-wrap">
                <h1>이니렌탈 안내</h1>
                <button type="button" class="btn-close">닫기</button>
            </div>
        </header>
    <% End If %>
	<!-- contents -->
	<div id="content" class="content">
		<div class="pop-rental-wrap">
			<div class="rental-section01">
				<img src="//fiximage.10x10.co.kr/m/2020/category/img_pop_rental.png?v=2" alt="tenbyten X KG 이니시스">
			</div>
			<div class="rental-section02">
				<ul>
					<li>렌탈료 완납 시 소유권은 구매자에게 이전됩니다</li>
					<li>선택하신 약정 기간에 따라 렌탈료가 가감됩니다</li>
					<li>프로모션 및 기타 조건에 의해 렌탈 약정 기간이 상품별로
						상이할 수 있습니다.</li>
					<li>렌탈에 관련된 문의(약정기간, 중도납부 등)는 KG이니시스
						렌탈 고객센터를 이용해주세요</li>
				</ul>
			</div>
			<div class="service-tell type02">
				<a href="tel:1800-1739"><span class="number">1800-1739</span><p class="txt">서비스 문의 KG 이니시스 렌탈 고객센터</p></a>
			</div>
			<div class="btn-rental-float">
				<div class="service-tell type02">
					<a href="tel:1800-1739"><span class="number">1800-1739</span><p class="txt">서비스 문의 KG 이니시스 렌탈 고객센터</p></a>
				</div>
			</div>
		</div>
	</div>
	<!-- //contents -->
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incfooter.asp" -->
</body>

</html>