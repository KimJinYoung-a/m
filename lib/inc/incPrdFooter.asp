<!-- #include virtual="/lib/inc/incLogScript.asp" -->
<% if strHeadTitleName="" or strHeadTitleName="상품정보" then %>
<script>
	$(function(){
		/* category footer contents show hide */
		$(".category-footer .tenten a").on("click", function(e){
			$(this).toggleClass("on");
			$(".category-footer address .desc").toggle();
			return false;
		});			
	})
</script>
<footer class="category-footer">
	<div class="footer-content">
		<div class="footer-nav">
			<a href="<%=wwwUrl%>/common/news.asp?type=A">공지사항</a>
			<a href="<%=wwwUrl%>/cscenter/">고객행복센터</a>
			<a href="<%=wwwUrl%>/offshop/">매장안내</a>
			<a href="http://company.10x10.co.kr/" target="_blank">회사소개</a>
		</div>

		<address>
			<div class="tenten"><a href="#moretenten" title="더보기">(주) 텐바이텐 사업자정보</a></div>
			<div id="moretenten" class="desc">
				<p class="info">대표이사 : 최은희<br /> <a href="http://www.ftc.go.kr/bizCommPop.do?wrkr_no=2118700620" target="_blank" title="공정거래위원회 사업자등록현황 통신판매사업자 정보 페이지로 이동">사업자등록번호 : <u>211-87-00620</u> <br />통신판매업 신고번호 : <u>제 01-1968호</u></a></p>
				<p class="cs"><!-- <a href="tel:1644-6030">고객센터 1644-6030</a> --> <a href="mailto:customer@10x10.co.kr">이메일보내기</a></p>
			</div>
		</address>

		<div class="footer-link">
			<a href="" onclick="fnOpenModal('/member/pop_viewUsageTerms.asp'); return false;">이용약관</a>
			<a href="" onclick="fnOpenModal('/common/pop_private.asp'); return false;">개인정보처리방침</a>
			<a href="" onclick="fnOpenModal('/common/youth.asp'); return false;">청소년보호정책</a>
		</div>

		<ul class="tenten-sns">		
			<li><a href="http://facebook.com/your10x10" target="_blank" class="facebook" title="텐바이텐 페이스북"></a></li>
			<li><a href="http://instagram.com/your10x10" target="_blank" class="instagram" title="텐바이텐 인스타그램"></a></li>
			<li><a href="/my10x10/qna/myqnalist.asp" class="counsel">1:1 상담 신청</a></li>			
		</ul>
		<p class="copyright">&copy; Tenbyten inc.</p>
	</div>	
	<div class="bot-nav">
		<a href="/member/join.asp">회원가입</a>
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
		<a href="http://www.10x10.co.kr?mfg=pc" target="_blank">PC 버전</a>
		<a href="<%=wwwUrl%>/event/appdown/">APP 다운</a>
	</div>	
	<% if not IsUserLoginOK then %>
	<div class="footer-bnr">
		<a href="/event/benefit/">신규회원 혜택 확인하러 가기</a>
	</div>	
	<% end if %>
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
<div id="gotop" class="btn-top"><button type="button">맨위로</button></div>
<div id="modalLayer" style="display:none;"></div>
<div id="modalLayer2" style="display:none;"><div id="modalLayer2Contents"></div><div id="dimed"></div></div>