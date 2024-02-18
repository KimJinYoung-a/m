<!-- #include virtual="/lib/inc/incLogScript.asp" -->
<% if strHeadTitleName="" or strHeadTitleName="상품정보" or strHeadTitleName="개인정보처리방침" or strHeadTitleName="이용약관" then %>
<footer class="tenten-footer">
	<div class="footer-content">
		<div class="footer-nav">
			<%
				If instr(nowViewPage,"login")<=0 Then
					if Not(IsUserLoginOK) and Not(IsGuestLoginOK) then
			%>
				<a href="<%=M_SSLUrl%>/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>">로그인</a>
			<%		Else %>
				<a href="javascript:cfmLoginout();">로그아웃</a>
			<%
					End If
				End If
			%>			
			<a href="<%=wwwUrl%>/common/news/index.asp">공지사항</a>
			<a href="<%=wwwUrl%>/cscenter/">고객행복센터</a>
			<a href="<%=wwwUrl%>/offshop/">매장안내</a>
			<a href="http://company.10x10.co.kr/" target="_blank">회사소개</a>
		</div>

		<address>
			<div class="tenten"><a href="#moretenten" title="더보기">(주) 텐바이텐 사업자정보</a></div>
			<div id="moretenten" class="desc">
				<p class="info">대표이사 : 최은희<br /> <a href="http://www.ftc.go.kr/bizCommPop.do?wrkr_no=2118700620" target="_blank" title="공정거래위원회 사업자등록현황 통신판매사업자 정보 페이지로 이동">사업자등록번호 : <u>211-87-00620</u> <br />통신판매업 신고번호 : <u>제 01-1968호</u></a></p>
				<%'// 대표님 지시로 인한 cs 전화번호 임시 비노출 2020-10-16 %>
				<% If left(now(),10)>="2022-01-01" Then %>
					<p class="cs"><!-- <a href="tel:1644-6030">고객센터 1644-6030</a> --> <a href="mailto:customer@10x10.co.kr">이메일보내기</a></p>
				<% Else %>
					<p class="cs"><a href="mailto:customer@10x10.co.kr">이메일보내기</a></p>
				<% End If %>
			</div>
		</address>

		<div class="footer-link">
			<a href="" onclick="fnOpenModal('/member/pop_viewUsageTerms.asp'); return false;">이용약관</a>
			<a href="" onclick="fnOpenModal('/common/pop_private.asp'); return false;" style="font-weight:bold;">개인정보처리방침</a>
			<a href="" onclick="fnOpenModal('/common/youth.asp'); return false;">청소년보호정책</a>
		</div>

		<ul class="tenten-sns">
			<li><a href="http://facebook.com/your10x10" target="_blank" class="facebook">텐바이텐 페이스북으로 이동</a></li>
			<li><a href="http://instagram.com/your10x10" target="_blank" class="instagram">텐바이텐 공식 인스타그램계정으로 이동</a></li>
			<!-- li><a href="http://www.10x10shop.com/Mobile" target="_blank" class="china">텐바이텐 차이나 쇼핑몰로 이동</a></li -->
		</ul>
		<p class="copyright">&copy; Tenbyten inc.</p>
	</div>
	<div class="platform-nav">
		<a href="http://www.10x10.co.kr?mfg=pc" target="_blank">PC 버전</a>
		<a href="<%=wwwUrl%>/event/appdown/">APP 다운</a>
	</div>
	<!-- for dev msg : 다음 탭으로 이동하는 부분 -->
	<% If InStr(Request.ServerVariables("url"),"/trend/") > 0 Then %>
	<div class="btn-next-tab">
		<a href="/award/awarditem.asp?gaparam=before_footer_trend">여기를 터치하면<br /><b>'베스트'</b>로 이동합니다</a>
	</div>
	<% End If %>
	<% If InStr(Request.ServerVariables("url"),"/award/awarditem.asp") > 0 Then %>
	<div class="btn-next-tab">
		<a href="/gnbevent/shoppingchance_allevent.asp?gaparam=before_footer_best">여기를 터치하면<br /><b>'기획전'</b>로 이동합니다</a>
	</div>
	<% End If %>
</footer>
<% End If %>
<%' 전면배너(2018/07/05) %>
<% If IsUserLoginOK Then %>
	<% If now() > #07/09/2018 10:00:00# And Now() < #07/16/2018 00:00:00# then %>
		<% 	If request.cookies("appcoupon1060")<>"Y" Then %>
			<script>
				$.ajax({
					type:"POST",
					url:"/common/appCouponIssued.asp",
					//data: $("#boxTapeVoteFrm").serialize(),
					dataType: "text",
					async:false,
					cache:true,
					success : function(Data){
						if(Data!="") {
							if (Data==1)
							{
								$(function(){
									$('#mask').click(function(){
										$(".front-Bnr-appCouponBanner").hide();
										$('#mask').hide();
									});
									$('.front-Bnr-appCouponBanner .btnClose').click(function(){
										$(".front-Bnr-appCouponBanner").hide();
										$('#mask').hide();
									});

									// 전면배너
									var maskWappCouponBanner = $(document).width();
									var maskHappCouponBanner = $(document).height();
									$('#mask').css({'width':maskWappCouponBanner,'height':maskHappCouponBanner});
									$('#boxes').show();
									$('#mask').show();
									// 팝업숨김
									//$('.front-Bnr-appCouponBanner').hide();
									$(".front-Bnr-appCouponBanner").show();
								});
							}
						}
					}
				});
			</script>

			<style>
			.mask {z-index:150; background-color:rgba(0,0,0,.85);}
			.front-Bnr-appCouponBanner {position:fixed; left:50%; top:50%; z-index:99999; width:100%; margin:-22.75rem 0 0 -50%;}
			.front-Bnr-appCouponBanner a {display:block; width:100%;}
			.front-Bnr-appCouponBanner .btnClose {position:absolute; top:-1.5rem; right:.8rem; width:3.2rem; height:3.2rem;}
			.front-Bnr-appCouponBanner .btnClose button{width:100%; height:100%; border:0; background-color:transparent; background-repeat:no-repeat; background-size:100%; text-indent:-999em;}
			</style>
			<div class="front-Bnr-appCouponBanner" style="display:none;">
				<a href="/my10x10/couponbook.asp" class="mWeb">
					<img src="http://webimage.10x10.co.kr/eventIMG/2018/mkt/0709/m/bnr_front.png" alt="첫 구매 쿠폰이 발급되었습니다 App Coupon 5000원 24시간 이내 쿠폰함으로 가기" />
				</a>
				<div class="btnClose ftRt"><button type="button" onclick="window.close();" style="background-image:url(http://webimage.10x10.co.kr/eventIMG/2018/mkt/0709/m/btn_close.png)">닫기</button></div>
			</div>
			<div class="mask" id="mask"></div>
		<% End If %>
	<% End If %>
<% End If %>
<%'// 전면배너(2018/07/05) %>

<div id="gotop" class="btn-top"><button type="button">맨위로</button></div>
<div id="modalLayer" style="display:none;"></div>
<div id="modalLayer2" style="display:none;"><div id="modalLayer2Contents"></div><div id="dimed"></div></div>