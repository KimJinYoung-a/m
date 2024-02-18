<%
'####################################################
' Description : 제휴몰 쿠차(coocha) 타고 들어 올경우 레이어 처리
' History : 2015.09.01 한용민 생성
'####################################################
%>
<div id="boxes">
	<div id="mask"></div>
	<div class="window">
		<div class="lyShopBnr">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/shop/txt_more.png" alt="더 다양한 이벤트와 상품을 보고 싶으시다면!" /></p>
			
			<%
			'/상품페이지 일경우 앱에 해당 상품 페이지로 호출
			if cstr(lcase(nowViewPage))=cstr("/category/category_itemprd.asp") then
			%>
				<a href="/apps/link/goitemprd.asp?itemid=<%= itemid %>" target="_blank" class="goApp"><img src="http://webimage.10x10.co.kr/eventIMG/2015/shop/btn_go_app.gif" alt="텐바이텐 앱으로 가기" /></a>
			<%
			'/기타 모두 앱 메인호출
			else
			%>
				<a href="/apps/link/gomain.asp" target="_blank" class="goApp"><img src="http://webimage.10x10.co.kr/eventIMG/2015/shop/btn_go_app.gif" alt="텐바이텐 앱으로 가기" /></a>
			<% end if %>

			<button type="button" class="lyrClose"><img src="http://webimage.10x10.co.kr/eventIMG/2015/shop/btn_close.png" alt="닫기" /></button>
		</div>
	</div>
</div>
<iframe name="view" id="view" frameborder="0" width="0" height="0"></iframe>
<form name="coochafrm" method="post" style="margin:0px;">
	<input type="hidden" id="mode" name="mode">
	<input type="hidden" id="gourl" name="gourl">
</form>