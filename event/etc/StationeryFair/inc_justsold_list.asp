				<section class="section-justsold">
					<h3><img src="//webimage.10x10.co.kr/fixevent/event/2021/109789/m/tit_justsold.png" alt="방금 판매된 문구페어 상품은"></h3>
					<div id="app"></div>
				</section>
<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.auto.min.js"></script>
<% IF application("Svr_Info") = "Dev" THEN %>
<script src="/vue/vue_dev.js"></script>
<% Else %>
<script src="/vue/vue.min.js"></script>
<% End If %>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>
<script src="/vue/exhibition/main/StationeryFair/itemlist.js?v=1.00"></script>
<script src="/vue/item/main/justsold/filter.js?v=1.00"></script>
<script src="/vue/exhibition/main/StationeryFair/store.js?v=1.00"></script>
<script src="/vue/exhibition/main/StationeryFair/index.js?v=1.00"></script>