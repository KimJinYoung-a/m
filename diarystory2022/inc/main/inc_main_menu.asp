	<nav class="diary-menu">
		<h2 class="blind">메뉴</h2>
		<ul class="menu-list">
			<li>
                <a href="" onclick="linkToSearchType('','best','','all');return false;">베스트</a>
            </li>
			<li class="new">
                <% if isapp = 1 then %>
                <a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '다꾸톡톡', [BtnType.SEARCH, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2020/daccu_toktok.asp')">
                <% else %>
                <a href="/diarystory2020/daccu_toktok.asp">
                <% end if %>
                    다꾸톡톡
                </a>
            </li>
			<li class="new">
                <% if isapp = 1 then %>
                <a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [BtnType.SEARCH, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2022/exhibition.asp')">
                <% else %>
                <a href="/diarystory2022/exhibition.asp">
                <% end if %>
                    기획전
                </a>
            </li>
		</ul>
	</nav>