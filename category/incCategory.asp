			<%
				Dim cdL, cdM, cdS, mDisp
				mDisp = request("mdisp")
			%>
			<script type="application/x-javascript" src="/lib/js/category_brand.js"></script>
			<div class="unbSection">
				<ul class="unbList">
					<%
						If (Not IsUserLoginOK) Then
							If (IsGuestLoginOK) Then
								'## 주문번호로 로그인시
					%>
					<li class="memHello noMem"><!-- for dev msg : 비회원 noMem 클래스 추가 -->
						<p class="memIco"></p>
						<div>주문번호 : <strong class="cC40"><%=GetGuestLoginOrderserial%></strong></div>
					</li>
					<li class="memInfo">
						<div></div>
					</li>
					<%
							else
								'## 로그인정보 없음
					%>
					<!-- 로그인전 노출 -->
					<li class="memberArea">
						<p class="greeting">텐바이텐에 오신것을 환영합니다!</p>
						<p class="tPad10">
							<span class="btn btn3 gryB w120B arrowBg"><a href="/member/join.asp"><em>회원가입</em></a></span>
							<span class="btn btn3 redB w120B arrowBg lMar05"><a href="<%=M_SSLUrl%>/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>"><em>로그인</em></a></span>
						</p>
					</li>
					<!--// 로그인전 노출 -->
					<%
							end if
						else
							'## 회원 로그인 시
					%>
					<!-- 로그인후 노출 -->
					<li class="memHello <%=GetUserStr(GetLoginUserLevel)%>">
						<p class="memIco"></p>
						<div>Hello, <%= GetLoginUserID %></div>
					</li>
					<li class="memInfo">
						<div><span onclick="document.location='/my10x10/couponbook.asp'">쿠폰 : <%=GetLoginCouponCount%>장</span> <span>|</span><span onclick="document.location='/my10x10/mileage_shop.asp'"> 마일리지 : <%=FormatNumber(getLoginCurrentMileage(),0)%>P</span></div>
					</li>
					<!--// 로그인후 노출 -->
					<%	end if %>
					<li class="unbMyTen">
						<div><a href="/my10x10/mymain.asp">마이텐바이텐</a></div>
					</li>
					<li class="unbCart">
						<div><a href="/inipay/ShoppingBag.asp">장바구니</a></div>
					</li>
					<li class="unbOrder">
						<div><a href="/my10x10/order/myorderlist.asp">주문/배송</a></div>
					</li>
				</ul>

				<p class="unbQuickTit">Quick Menu</p>
				<ul class="unbList unbQuick">
					<li class="unbCtgy">
						<div><a href="/category/category_main.asp">카테고리</a></div>
					</li>
					<li class="unbBrand">
						<div><a href="/street/">브랜드</a></div>
					</li>
				</ul>
				<% If (IsUserLoginOK) Then%>
				<!-- 로그인후 노출 -->
				<div class="unbLogout" onclick="cfmLoginout();">로그아웃</div>
				<!--// 로그인후 노출 -->
				<% End If %>
			</div>