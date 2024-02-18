<style>[v-cloak] { display: none; }</style>
<section class="sect_tv">
    <h2><a href="" onclick="daccutvlink(); return false;">다꾸TV<i class="i_arw_r2"></i></a></h2>
    <div id="app" v-cloak></div>
    <span id="timer" style="display:hidden"></span>
    <div id="userid" rel="<%=getloginuserid%>" style="display:none;"></div>	
    <button class="btn_type2 btn_gry btn_block" onclick="daccutvlink()">다꾸TV 전체보기</button>
    <script>
        function daccutvlink() {
            <% if isapp = 1 then%>
            fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '다꾸TV', [BtnType.SEARCH, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2020/daccutv.asp')
            <% else %>
            window.location.href = '/diarystory2020/daccutv.asp';
            <% end if %>
        }
    </script>
</section>
<% IF application("Svr_Info") = "Dev" THEN %>
<script src="/vue/vue_dev.js"></script>
<% Else %>
<script src="/vue/vue.min.js"></script>
<% End If %>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<script src="/vue/media/daccutv/common/clap/clap-icon.js?v=1.01"></script>
<script src="/vue/media/daccutv/list/video-list.js?v=1.04"></script>
<script src="/vue/media/daccutv/list/diary2021.js?v=1.03"></script> 