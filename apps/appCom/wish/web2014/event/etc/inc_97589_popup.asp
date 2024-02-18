<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 18주년 사은품이벤트 팝업페이지
' History : 2019-09-30 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
	strHeadTitleName = "머그컵"
%>
<style>
.gift-pop .slide1 .swiper-slide {width: 100%;}
.gift-pop .slide1 .pagination {position: absolute; display: flex; z-index: 99; top: 10.3%; left: 0; width: 100%;}
.gift-pop .slide1 .pagination .swiper-pagination-switch {display: block; width: 50%; padding-bottom: 10%; margin: 0; border-radius: 0; background: none;}
</style>
<script type="text/javascript">
$(function(){
    //레이어 슬라이드
    swiper = new Swiper('.slide1', {
        pagination:'.slide1 .pagination',
        paginationClickable:true,
        effect:'fade'
    })
});
</script>
</head>
<body class="default-font body-sub">
    
	<!-- contents -->
	<div id="content" class="content">
		<!-- <div class="section-event event-head">
			<p class="date">2018.10.10~10.17</p>
		</div> -->
		<!-- 이벤트 배너 등록 영역 -->
		<div class="evtContV15">

            <!-- 스누피의선물 팝업 -->
            <div class="gift-pop">
                <h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/tit_shape.jpg" alt="18th 10x10 edition peanuts hug mug"></h2>
                <div class="slide1">
                    <div class="swiper-wrapper">
                        <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/img_shape_frt.jpg" alt="front"></div>
                        <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/img_shape_bk.jpg" alt="back"></div>
                    </div>
                    <div class="pagination"></div>
                </div>
            </div>
            <!-- // 스누피의선물 팝업 -->

		</div>
		<!--// 이벤트 배너 등록 영역 -->

	</div>
	<!-- //contents -->

	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->