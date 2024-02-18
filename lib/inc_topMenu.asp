<script type="text/javascript" src="/lib/js/jquery.scrollnews.min.js"></script>
		<div class="header">
			<header role="banner">
				<h1 class="logo"><a href="<%=wwwUrl%>/" title="_webapp"><img src="http://fiximage.10x10.co.kr/m/2013/common/logo.png" alt="10x10" /></a></h1>
				<div>
					<div class="mine">
						<% If (IsUserLoginOK) Then %><!-- <p class="hello"><a href="<%=wwwUrl%>/my10x10/mymain.asp">Hi, <strong><%= GetLoginUserID %>!</strong></a></p>//--><% end if %>
						<div class="ftRt">
							<div class="overHidden">
								<p class="deliver"><a href="<%=wwwUrl%>/my10x10/order/myorderlist.asp">주문/배송</a></p>
								<p class="cart"><a href="<%=wwwUrl%>/inipay/ShoppingBag.asp"><dfn class="elmBg">장바구니</dfn><span id="ibgaCNT"><%= GetCartCount %></span></a> </p>
							</div>
						</div>
					</div>
					<div class="search">
						<div>
							<fieldset>
								<form name="searchForm" method="get" action="<%=wwwUrl%>/search/search_result.asp" onSubmit="return fnTopSearch();">
									<input type="hidden" name="cpg">
									<p><input type="search" name="rect" class="schInput" required placeholder="검색어를 입력하세요" /> <input type="submit" value="" class="schBtn elmBg" /></p>
								</form>
							</fieldset>
						</div>
					</div>
				</div>
			</header>
			<div class="gnbWrap nav">
				<nav role="navigation">
					<ul class="gnb">
						<li class="gnbCateg"><p><span class="elmBg"></span>카테고리</p></li>
						<li class="gnbBest" onclick="self.location='<%=wwwUrl%>/award/awardItem.asp'"><p><span class="elmBg"></span>베스트</p></li>
						<li class="gnbEvent" onclick=""><p><span class="elmBg"></span>이벤트</p></li>
						<li class="gnbWish" onclick="self.location='<%=wwwUrl%>/my10x10/mywishlist.asp'"><p><span class="elmBg"></span>위시</p></li>
					</ul>
				</nav>
			</div>
		</div>