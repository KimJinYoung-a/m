<script>
var lnbScroll;
$(function(){
	lnbScroll = new Swiper('.lnbContV16a .swiper-container', {
		scrollbar:'.lnbContV16a .swiper-scrollbar',
		direction:'vertical',
		slidesPerView:'auto',
		mousewheelControl:true,
		freeMode:true
	});
});
</script>
<div class="asideSectionV16a"><%' asideActive(LNB 활성화) / common.js 수정했음 %>
	<div class="asideWrapV16a">
		<div class="pvtBoxV16a">
			<% If (Not IsUserLoginOK) Then %>
				<% If (IsGuestLoginOK) Then %>
					<%' 주문번호로 로그인시 %>
					<div class="noMemChk">
						<p><%= GetGuestLoginOrderserial %></p>
						<a href="<%=M_SSLUrl%>/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>" class="btnV16a btnWht1V16a">로그인</a>
					</div>
				<% Else %>
					<%' 로그인 전 %>
					<div>
						<a href="<%=M_SSLUrl%>/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>" class="btnV16a btnWht1V16a">로그인</a>
						<a href="<%=wwwUrl%>/member/join.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>" class="btnV16a btnBlk1V16a">회원가입</a>
					</div>
					<%'// 로그인 전 %>
				<% End If %>
			<% Else %>
				<%' 로그인 후 %>
				<div>
					<p><%= GetLoginUserID %></p>
				</div>
				<%'// 로그인 후 %>
			<% End If %>
		</div>

		<div class="lnbContV16a">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<ul class="lnbV16a">
							<li class="myTenV16a"><a href="<%=wwwUrl%>/my10x10/mymain.asp">마이텐바이텐</a></li>
							<li class="orderV16a <%=chkIIF(GetOrderCount>0," newActive","")%>"><a href="<%=wwwUrl%>/my10x10/order/myorderlist.asp">주문/배송조회<i>새글있음</i></a></li>
							<li class="recentV16a"><a href="<%=wwwUrl%>/my10x10/myrecentview.asp">최근본컨텐츠</a></li>
						</ul>
						<div class="ctgyGroupV16a bxWt1V16a">
							<dl>
								<dt><a href="<%=wwwUrl%>/catemain/index.asp?gnbcode=400">STATIONERY</a></dt>
								<dd>
									<ul>
										<li class="lnb0101"><a href="<%=wwwUrl%>/category/category_list.asp?disp=101">디자인문구</a></li>
										<!--<li class="lnbDiary"><a href="<%'=wwwUrl%>/diarystory2017/">2017 다이어리</a></li>-->
									</ul>
								</dd>
							</dl>
							<dl>
								<dt><a href="<%=wwwUrl%>/catemain/index.asp?gnbcode=500">DIGITAL</a></dt>
								<dd>
									<ul>
										<li class="lnb0102"><a href="<%=wwwUrl%>/category/category_list.asp?disp=102">디지털/핸드폰</a></li>
										<li class="lnb0124"><a href="<%=wwwUrl%>/category/category_list.asp?disp=124">디자인가전</a></li>
									</ul>
								</dd>
							</dl>
							<dl>
								<dt><a href="<%=wwwUrl%>/catemain/index.asp?gnbcode=100">LIVING</a></dt>
								<dd>
									<ul>
										<% If Date() < "2016-12-23" Then %>
										<li class="lnbXmas16"><a href="<%=wwwUrl%>/event/eventmain.asp?eventid=74315">2016 크리스마스</a></li>
										<% End If %>
										<li class="lnb0121"><a href="<%=wwwUrl%>/category/category_list.asp?disp=121">가구/수납</a></li>
										<li class="lnb0122"><a href="<%=wwwUrl%>/category/category_list.asp?disp=122">데코/조명</a></li>
										<li class="lnb0120"><a href="<%=wwwUrl%>/category/category_list.asp?disp=120">패브릭/생활</a></li>
										<li class="lnb0112"><a href="<%=wwwUrl%>/category/category_list.asp?disp=112">키친</a></li>
										<li class="lnb0119"><a href="<%=wwwUrl%>/category/category_list.asp?disp=119">푸드</a></li>
									</ul>
								</dd>
							</dl>
							<dl>
								<dt><a href="<%=wwwUrl%>/catemain/index.asp?gnbcode=200">FASHION</a></dt>
								<dd>
									<ul>
										<li class="lnb0117"><a href="<%=wwwUrl%>/category/category_list.asp?disp=117">패션의류</a></li>
										<li class="lnb0116"><a href="<%=wwwUrl%>/category/category_list.asp?disp=116">패션잡화</a></li>
										<li class="lnb0125"><a href="<%=wwwUrl%>/category/category_list.asp?disp=125">주얼리/시계</a></li>
										<li class="lnb0118"><a href="<%=wwwUrl%>/category/category_list.asp?disp=118">뷰티</a></li>
									</ul>
								</dd>
							</dl>
							<dl>
								<dt><a href="<%=wwwUrl%>/catemain/index.asp?gnbcode=300">TRAVEL /<br />HOBBY</a></dt>
								<dd>
									<ul>
										<li class="lnb0104"><a href="<%=wwwUrl%>/category/category_list.asp?disp=104">토이/취미</a></li>
										<li class="lnb0110"><a href="<%=wwwUrl%>/category/category_list.asp?disp=110">Cat&amp;Dog</a></li>
									</ul>
								</dd>
							</dl>
							<dl>
								<dt><a href="<%=wwwUrl%>/catemain/index.asp?gnbcode=600">BABY</a></dt>
								<dd>
									<ul>
										<li class="lnb0115"><a href="<%=wwwUrl%>/category/category_list.asp?disp=115">베이비/키즈</a></li>
									</ul>
								</dd>
							</dl>
							<dl>
								<dt>10x10 SPECIAL</dt>
								<dd>
									<ul>
										<li class="lnbGCardV16a"><a href="/giftcard/">GIFT 카드</a></li>
										<li class="lnbMV16a"><a href="/my10x10/mileage_shop.asp">마일리지샵</a></li>
										<li class="lnbCulture17"><a href="/culturestation/index.asp">컬쳐스테이션</a></li>
									</ul>
								</dd>
							</dl>
						</div>
						<div class="spcLinkV16a">
							<p>
								<span class="linkBrdV16a"><a href="<%=wwwUrl%>/street/">BRAND</a></span>
								<span class="linkExhV16a"><a href="<%=wwwUrl%>/shoppingtoday/shoppingchance_allevent.asp?scTgb=planevt">기획전</a></span>
							</p>
							<p>
								<span class="linkEvtV16a"><a href="<%=wwwUrl%>/shoppingtoday/shoppingchance_allevent.asp?scTgb=mktevt">이벤트</a></span>
								<span class="linkChcV16a"><a href="<%=wwwUrl%>/shoppingtoday/10x10choice.asp">텐텐초이스</a></span>
							</p>
						</div>
					</div>
				</div>
				<!-- Add Scroll Bar -->
				<div class="swiper-scrollbar"></div>
			</div>
		</div>
		<div class="directNaV16a">
			<ul>
				<li class="lnbPlayV16a"><a href="<%=wwwUrl%>/play/"><span>PLAY</span></a></li>
				<li class="lnbWishV16a"><a href="<%=wwwUrl%>/wish/"><span>WISH</span></a></li>
				<li class="lnbGiftV16a"><a href="<%=wwwUrl%>/gift/gifttalk/"><span>GIFT</span></a></li>
			</ul>
		</div>
	</div>
	<i class="lnbClose">LNB 레이어 닫기</i>
</div>