<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
	<div class="heightGrid">
		<div class="container">
			<!-- content area -->
			<div class="content">
				<ul class="wishDespInfo">
					<li class="followDesp01">
						<p><img src="http://fiximage.10x10.co.kr/m/2014/wish/wish_desp2a.png" alt="팔로우 1단계 - 리스트 페이지 [프로필 이미지] 터치" /></p>
						<dl>
							<dt>팔로우 <span class="cRd1">1단계!</span></dt>
							<dd>리스트 페이지<br /><strong class="cBk1">[프로필 이미지]</strong> 터치!</dd>
						</dl>
					</li>
					<li class="followDesp02">
						<p><img src="http://fiximage.10x10.co.kr/m/2014/wish/wish_desp2b.png" alt="팔로우 2단계 - 프로필 페이지 [팔로우 버튼] 터치" /></p>
						<dl>
							<dt>팔로우 <span class="cRd1">2단계!</span></dt>
							<dd>프로필 페이지 <br /><strong class="cBk1">[팔로우 버튼]</strong> 터치!</dd>
						</dl>
					</li>
					<li class="followDesp03">
						<p><img src="http://fiximage.10x10.co.kr/m/2014/wish/wish_desp2c.png" alt="팔로우 3단계 - 위시 서브메뉴 [팔로우 버튼] 터치" /></p>
						<dl>
							<dt>팔로우 <span class="cRd1">3단계!</span></dt>
							<dd>위시 서브메뉴<br /><strong class="cBk1">[팔로우 버튼]</strong> 터치!</dd>
						</dl>
					</li>
					<li>
						<div class="btnWrap btnAdd">
							<div><span class="button btB1 btRed cWh1"><a href="" onclick='fnAPPopenerJsCallClose("goWishReturn()");return false;'><em>팔로우 추가하러가기</em></a></span></div>
						</div>
					</li>
				</ul>
			</div>
			<!-- //content area -->
		</div>
	</div>
	<script>
		fnAPPopenerJsCall("location.replace('/apps/appCom/wish/web2014/wish/');");
	</script>