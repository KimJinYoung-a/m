<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
	Dim sCurrUrl, sGnbNum
	sCurrUrl = ReplaceRequestSpecialChar(request("CurrUrl"))


	sGnbNum = -1
	IF sCurrUrl="/" then sGnbNum = 0
	If sCurrUrl="/piece/" Then  sGnbNum = 1
	If sCurrUrl="/trend/" Then  sGnbNum = 2
	If sCurrUrl="/award/" Then  sGnbNum = 3
	If sCurrUrl="/gnbevent/" Then  sGnbNum = 4
	If sCurrUrl="/playing/" Then  sGnbNum = 5
%>


<div id="navGnb" class="nav-gnb">
	<nav class="swiper-container">
		<ul class="swiper-wrapper">
			<li class="swiper-slide"><a href="http://m.10x10.co.kr/piece/" <% If sGnbNum=1 Then %>class="on"<% End If %>>조각 <span class="badge new">new</span></a></li>
			<li class="swiper-slide"><a href="http://m.10x10.co.kr/" <% If sGnbNum=0 Then %>class="on"<% End If %>>투데이</a></li>
			<li class="swiper-slide"><a href="http://m.10x10.co.kr/trend/" <% If sGnbNum=3 Then %>class="on"<% End If %>>트렌드</a></li>
			<li class="swiper-slide"><a href="http://m.10x10.co.kr/award/awarditem.asp" <% If sGnbNum=4 Then %>class="on"<% End If %>>베스트</a></li>
			<li class="swiper-slide"><a href="http://m.10x10.co.kr/gnbevent/shoppingchance_allevent.asp" <% If sGnbNum=5 Then %>class="on"<% End If %>>기획전</a></li>
			<li class="swiper-slide"><a href="http://m.10x10.co.kr/subgnb/goods/" <% If sGnbNum=6 Then %>class="on"<% End If %>>GOODS</a></li>
		</ul>
	</nav>
</div>
<script type="text/javascript">
$(function(){
	//Nav(GNB)
	var chkTch=false, chkIdx;
	var navSwiper = new Swiper('#navGnb .swiper-container', {
		slidesPerView: 'auto',
		<% if sGnbNum >= 2 then %>
			initialSlide:<%=sGnbNum%>,
		<% end if %>
		onTap:function(gns){
			var vLnk = $(gns.slides[gns.clickedIndex]).find("span").attr("link");
			if(!(vLnk==""||!vLnk)) {
				top.location.href=vLnk;
			}
		}
	});
});
</script>