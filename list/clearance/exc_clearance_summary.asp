<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : CLEARANCE 서머리 페이지 메인
' History : 2020-10-29 이전도 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	dim gnbflag , testmode, defaultAPIURL
	gnbflag = RequestCheckVar(request("gnbflag"),1)
	testmode = RequestCheckVar(request("testmode"),1)

	If gnbflag <> "" Then '//gnb 숨김 여부
		gnbflag = true
	Else
		gnbflag = False
		strHeadTitleName = "헤더"
	End if

%>
<style>[v-cloak] { display: none; }</style>

<div id="app"></div>
<svg xmlns="http://www.w3.org/2000/svg" class="defs">
	<defs>
		<mask id="shape1"><circle cx="375" cy="375" r="375"/></mask>
		<mask id="shape2"><path d="M750 375c-42.453 183.663-191.341 332.547-375 375C191.337 707.547 42.453 558.663 0 375 42.453 191.337 191.337 42.453 375 0c183.659 42.453 332.547 191.337 375 375"/></mask>
		<mask id="shape3"><path d="M508.333 695.001c-73.335 73.332-193.332 73.332-266.667 0L55 508.332C-18.334 435-18.334 315 55.001 241.668l186.665-186.67c73.335-73.33 193.332-73.33 266.667 0l186.668 186.67c73.332 73.332 73.332 193.332 0 266.664l-186.668 186.67z"/></mask>
		<mask id="shape4"><path d="M0 375c0-91.371 112.35-142.897 172.228-202.772C232.103 112.349 283.628 0 375 0c91.371 0 142.897 112.35 202.772 172.228C637.651 232.103 750 283.628 750 375c0 91.371-112.35 142.897-172.228 202.772C517.897 637.651 466.372 750 375 750c-91.371 0-142.897-112.35-202.772-172.228C112.349 517.897 0 466.372 0 375"/></mask>
		<mask id="shape5"><path d="M375 0C167.893 0 0 167.893 0 375v296.533C0 714.869 35.131 750 78.467 750H375c207.107 0 375-167.893 375-375S582.107 0 375 0z"/></mask>
		<mask id="shape6"><path d="M150.84 599.158c-201.12-101.497-201.12-346.818 0-448.319 101.5-201.119 346.821-201.119 448.318 0 201.123 101.5 201.123 346.822 0 448.319-101.497 201.123-346.818 201.123-448.319 0z"/></mask>
		<mask id="shape7"><path d="M750 375c0 28.366-27.8 53.152-33.7 79.677-6.087 27.407 8.3 62.036-3.362 86.758-11.863 25.132-47.425 35.154-64.275 56.731-16.938 21.693-18.638 59.352-39.85 76.673-21.1 17.231-57.363 10.597-81.925 22.715-24.176 11.94-41.638 45.176-68.426 51.401-25.95 6.034-55.724-16.03-83.462-16.03-27.738 0-57.512 22.064-83.462 16.03-26.788-6.225-44.25-39.461-68.425-51.4-24.576-12.119-60.838-5.485-81.938-22.716-21.2-17.321-22.9-54.993-39.838-76.673-16.85-21.59-52.412-31.612-64.275-56.73-11.662-24.723 2.738-59.352-3.362-86.76C27.8 428.153 0 403.367 0 375s27.8-53.152 33.7-79.677c6.087-27.407-8.3-62.036 3.362-86.758 11.863-25.132 47.425-35.154 64.276-56.731 16.937-21.693 18.637-59.352 39.85-76.673 21.1-17.231 57.362-10.597 81.925-22.715 24.174-11.94 41.637-45.176 68.425-51.401 25.95-6.034 55.724 16.03 83.462 16.03 27.738 0 57.512-22.064 83.462-16.03 26.788 6.225 44.25 39.461 68.426 51.4 24.574 12.119 60.837 5.485 81.937 22.716 21.2 17.321 22.9 54.993 39.837 76.673 16.85 21.59 52.413 31.612 64.275 56.73 11.663 24.723-2.737 59.352 3.363 86.76 5.9 26.524 33.7 51.31 33.7 79.676"/></mask>
	</defs>
</svg>

<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.auto.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bodymovin/5.7.4/lottie_svg.min.js"></script>
<% IF application("Svr_Info") = "Dev" or testmode = "1" THEN %>
<script src="/vue/vue_dev.js"></script>
<% Else %>
<script src="/vue/2.5/vue.min.js"></script>
<% End If %>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>

<!-- Common Components -->
<script src="/vue/components/common/functions/common.js?v=1.0"></script>
<script src="/vue/components/common/functions/item_mixins.js?v=1.0"></script>
<script src="/vue/components/common/functions/common_mixins.js?v=1.1"></script>
<script src="/vue/components/common/wish.js?v=1.0"></script>
<script src="/vue/components/common/btn_top.js?v=1.0"></script>
<!-- //Common Components -->

<!-- Category Components -->
<script src="/vue/components/category/ctgr_nav_type2.js?v=1.0"></script>
<!-- //Category Components -->

<!-- Product Components -->
<script src="/vue/components/product/prd_slider_type1.js?v=1.0"></script>
<script src="/vue/components/product/prd_slider_type6.js?v=1.0"></script>
<script src="/vue/components/product/prd_img_svg.js?v=1.0"></script>
<script src="/vue/components/product/prd_img.js?v=1.0"></script>
<script src="/vue/components/product/prd_list_basic.js?v=1.0"></script>
<script src="/vue/components/product/prd_item_basic.js?v=1.0"></script>
<script src="/vue/components/product/prd_time.js?v=1.0"></script>
<script src="/vue/components/product/prd_rank.js?v=1.0"></script>
<script src="/vue/components/product/prd_price.js?v=1.0"></script>
<script src="/vue/components/product/prd_name.js?v=1.0"></script>
<script src="/vue/components/product/prd_brand.js?v=1.0"></script>
<script src="/vue/components/product/prd_badge.js?v=1.0"></script>
<script src="/vue/components/product/prd_evaluate.js?v=1.0"></script>
<script src="/vue/components/product/prd_more_button.js?v=1.0"></script>
<!-- //Product Components -->

<!-- Core -->
<script src="/vue/list/clearance/summary_store.js?v=1.0"></script>
<script src="/vue/list/clearance/summary.js?v=1.3"></script>
<!-- //Core -->