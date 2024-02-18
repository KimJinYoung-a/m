<nav class="sect_menu" style="margin-bottom:5.12rem;">
    <h2 class="blind">메뉴</h2>
    <ul class="dr_menu">
        <li>
            <% if isapp = 1 then %>
            <a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [BtnType.SEARCH, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2021/exhibition.asp')">
            <% else %>
            <a href="/diarystory2021/exhibition.asp">
            <% end if %>
                <p>기획전</p>
            </a>
        </li>
        <li>
            <% if isapp = 1 then %>
            <a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '다꾸톡톡', [BtnType.SEARCH, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2020/daccu_toktok.asp')">
            <% else %>
            <a href="/diarystory2020/daccu_toktok.asp">
            <% end if %>
                <p>다꾸톡톡</p>
            </a>
        </li>
        <li>
            <% if isapp = 1 then %>
            <a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '다꾸TV', [BtnType.SEARCH, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2020/daccutv.asp')">
            <% else %>
            <a href="/diarystory2020/daccutv.asp">
            <% end if %>
                <p>다꾸TV</p>
            </a>
        </li>
    </ul>
    <button class="btn_dr_srch" onclick="linkToSearchType('100101','cate');">검색 <i class="i_magnify"></i></button>
</nav>