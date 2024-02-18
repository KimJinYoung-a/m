<% If giftCheck Then %>
<section class="sect_bnf">
	<h2>텐바이텐이 준비한 <strong>특별한 선물</strong></h2>
	<div class="bnf bnf1">
		<div class="tip"><span><i class="badge_gift"></i>스티커 </span>상품을 포함해 구매하시면<br>텐텐메이드 다꾸템을 선물로 드려요!</div>
		<ul>
			<li>
				<figure class="bnf_img"><img src="//fiximage.10x10.co.kr/m/2020/diary2021/img_gift1.png" alt=""></figure>
				<div class="bnf_info">15,000원 이상<div class="bnf-name">다꾸파우치</div></div>
			</li>
			<li>
				<figure class="bnf_img"><img src="//fiximage.10x10.co.kr/m/2020/diary2021/img_gift2.png" alt=""></figure>
				<div class="bnf_info">30,000원 이상<div class="bnf-name">스티커북</div></div>
			</li>
			<li>
				<figure class="bnf_img"><img src="//fiximage.10x10.co.kr/m/2020/diary2021/img_gift3.png" alt=""></figure>
				<div class="bnf_info">60,000원 이상<div class="bnf-name">다꾸라벨기</div></div>
			</li>
		</ul>
	</div>
	<%if isapp = 1 then%>
	<a href="javascript:fnAPPpopupBrowserURL('다이어리 스토리','http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2021/special_benefit.asp');" class="btn_type1 btn_gry">이벤트 자세히 보기</a>
	<%else%>
	<a href="/diarystory2021/special_benefit.asp" class="btn_type1 btn_gry" style="margin-bottom:0;">이벤트 자세히 보기</a>
	<% end if %>
	<% If Date<="2020-12-31" Then %>
	<div class="bnf bnf2" style="margin-top:7rem;">
		<figure class="bnf_img"><img src="//fiximage.10x10.co.kr/m/2020/diary2021/img_delivery.png" alt=""></figure>
		<div class="tip"><span><i class="badge_delivery"></i>무료배송 스티커</span>가 붙은 상품을 <br>구매하시면 빠르고 안전하게 무료 배송 해드려요!</div>
	</div>
	<% End If %>
</section>
<% End If %>