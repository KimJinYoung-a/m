<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
'####################################################
' Description : 베스트 리뉴얼
' History : 2021.09.15 김형태 생성
'####################################################

dim gnbflag : gnbflag = RequestCheckVar(request("gnbflag"),1)

If gnbflag <> "" Then '//gnb 숨김 여부
	gnbflag = true
    strHeadTitleName = ""
Else
	gnbflag = False
	strHeadTitleName = "베스트셀러"
End if
%>

<body class="default-font body-<%=chkiif(gnbflag,"main","sub")%>">
    <!-- #include virtual="/lib/inc/incHeader.asp" -->
    <div id="app"></div>
</body>

<script src="https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/1.7.1/clipboard.min.js"></script>
<% IF application("Svr_Info") = "Dev" THEN %>
    <script src="/vue/vue_dev.js"></script>
<% Else %>
    <script src="/vue/2.5/vue.min.js"></script>
<% End If %>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>

<script src="/vue/components/common/functions/common.js?v=1.0"></script>
<script src="/vue/components/common/functions/item_mixins.js?v=1.0"></script>
<script src="/vue/components/common/functions/modal_mixins.js?v=1.0"></script>
<script src="/vue/components/common/functions/common_mixins.js?v=1.0"></script>

<script src="/vue/components/common/wish.js?v=1.3"></script>

<script src="/vue/components/product/prd_img.js?v=1.0"></script>
<script src="/vue/components/product/prd_price.js?v=1.0"></script>
<script src="/vue/components/product/prd_name.js?v=1.0"></script>

<script src="/vue/list/best/renewal/prd_item_best.js?v=1.01"></script>
<script src="/vue/list/best/renewal/btn_top_best.js?v=1.01"></script>

<!--<script src="https://cdnjs.cloudflare.com/ajax/libs/Swiper/4.0.7/js/swiper.min.js"></script>-->
<link href="https://cdnjs.cloudflare.com/ajax/libs/Swiper/4.0.7/css/swiper.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/vue-awesome-swiper@4.1.1/dist/vue-awesome-swiper.min.js"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-circle-progress/1.2.2/circle-progress.min.js"></script>
<script src="https://unpkg.com/@lottiefiles/lottie-player@latest/dist/lottie-player.js"></script>

<script src="/vue/list/best/renewal/store.js?v=1.02"></script>
<script src="/vue/list/best/renewal/index.js?v=1.02"></script>