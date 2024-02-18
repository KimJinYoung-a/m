<%
	Dim sCurrUrl, sCurrFile, sGnbNum
	sCurrUrl = Request.ServerVariables("url")
	sCurrFile = right(sCurrUrl,len(sCurrUrl)-inStrRev(sCurrUrl,"/"))
	sCurrUrl = left(sCurrUrl,inStrRev(sCurrUrl,"/"))

	'// GNB 메뉴에 따른 슬라이드 번호
	IF inStr(sCurrUrl,"/today/")>0 or sCurrUrl="/" then
		sGnbNum=0
	ElseIF inStr(sCurrUrl,"/award/")>0 then
		sGnbNum=2
'	ElseIF inStr(sCurrUrl,"/sale/")>0 or sCurrFile="shoppingchance_saleitem.asp" then
'		sGnbNum=4
	ElseIF inStr(sCurrUrl,"/event/")>0 or sCurrFile="shoppingchance_allevent.asp" then
		sGnbNum=5
	ElseIF inStr(sCurrUrl,"/wish/")>0 then
		sGnbNum=6
	ElseIF inStr(sCurrUrl,"/gift/")>0 then
		sGnbNum=7
	ElseIF inStr(sCurrUrl,"/diarystory2015/")>0 then
		sGnbNum=1
	'ElseIF inStr(sCurrUrl,"/pick/")>0 then
	'	sGnbNum=3
	ElseIF inStr(sCurrUrl,"/play/")>0 then
		sGnbNum=8
	Else
		sGnbNum=-1
	end if
%>
<div class="header">
	<header>
		<p class="btnLnbGo"><img src="http://fiximage.10x10.co.kr/m/2014/common/btn_lnb.png" alt="메뉴 열기" /></p>
		<h1><a href="/"><img src="http://fiximage.10x10.co.kr/m/2014/common/logo.png" alt="10x10 텐바이텐" /></a></h1>
		<p class="btnSearchGo"><a href="/search/"><img src="http://fiximage.10x10.co.kr/m/2014/common/btn_search_white.png" alt="검색창 열기" /></a></p>
		<p class="btnCartGo">
			<a href="<%=wwwUrl%>/inipay/ShoppingBag.asp">
				<span><dfn><%= GetCartCount %></dfn></span>
				<img src="http://fiximage.10x10.co.kr/m/2014/common/btn_cart.png" alt="장바구니" />
			</a>
		</p>
	</header>
	<nav class="gnbWrap swiper-container">
		<ul class="gnb swiper-wrapper">
			<li class="swiper-slide <%=chkIIF(sGnbNum=0,"current","")%>"><span link="<%=wwwUrl%>/">TODAY</span></li>
			<li class="swiper-slide <%=chkIIF(sGnbNum=1,"current","")%>"><span link="<%=wwwUrl%>/diarystory2015/">DIARY</span></li>
			<li class="swiper-slide <%=chkIIF(sGnbNum=2,"current","")%>"><span link="<%=wwwUrl%>/award/awarditem.asp">BEST</span></li>
			<!--<li class="swiper-slide <%=chkIIF(sGnbNum=3,"current","")%>"><span link="<%=wwwUrl%>/pick/">PICK</span></li>//-->
			<!--<li class="swiper-slide <%=chkIIF(sGnbNum=4,"current","")%>"><span link="<%=wwwUrl%>/shoppingtoday/shoppingchance_saleitem.asp">SALE</span></li>//-->
			<li class="swiper-slide <%=chkIIF(sGnbNum=5,"current","")%>"><span link="<%=wwwUrl%>/shoppingtoday/shoppingchance_allevent.asp">EVENT</span></li>
			<li class="swiper-slide <%=chkIIF(sGnbNum=6,"current","")%>"><span link="<%=wwwUrl%>/wish/index.asp">WISH</span></li>
			<li class="swiper-slide <%=chkIIF(sGnbNum=7,"current","")%>"><span link="<%=wwwUrl%>/gift/gifttalk/">GIFT</span></li>
			<li class="swiper-slide <%=chkIIF(sGnbNum=8,"current","")%>"><span link="<%=wwwUrl%>/play/">PLAY</span></li>
		</ul>
	</nav>
</div>
<script type="text/javascript">
$(function(){
	//Nav(GNB)
	var navSwiper = $('.gnbWrap').swiper({
		visibilityFullFit:true,
		slidesPerView:'auto',
		initialSlide:<%=sGnbNum%>,
		onSlideClick:function(gns){
			var vLnk = $(gns.getSlide(gns.clickedSlideIndex)).find("span").attr("link");
			if(!(vLnk==""||!vLnk)) {
				top.location.href=vLnk;
			} else {
				alert("No Link!");
			}
		}
	});
});
</script>