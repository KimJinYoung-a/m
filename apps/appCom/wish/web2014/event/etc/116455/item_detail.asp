<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
'####################################################
' Description :
' History :
'####################################################

dim itemid : itemid   = requestCheckVar(Request("itemid"),9) '아이템아이디
dim openDate : openDate   = requestCheckVar(Request("openDate"),8) '상품오픈일자

%>

<!-- #include virtual="/lib/inc/head.asp" -->
<div id="app"></div>

<style>
.item_week h1{width:auto;font-size:1.37rem;line-height:1.37rem;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.item_week .item-detail .desc{padding:0;}
.item_week .deal-item .slide .brand{font-size:1.28rem;font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';color:#818181;letter-spacing:-0.02em;margin:2.99rem 0 2.56rem;}
.item_week .deal-item .item-detail .brand + .name{margin-top:0;width:20rem;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';letter-spacing:-0.01em;padding:0;font-size:1.88rem;line-height:2.8rem;max-height:none;}
.item_week .deal_detail{margin-top:5.12rem}

.item_week .deal_list{margin-top:3.41rem;padding:0 2.77rem;}
.item_week .deal_list ul{display:flex;width:100%;justify-content:space-between;flex-wrap:wrap;}
.item_week .deal_list ul li{width:12.8rem;text-align:center;margin-bottom:3.84rem;}
.item_week .deal_list ul li .prd_img{margin-bottom:1.07rem;}
.item_week .deal_list ul li .prd_num{font-size:0.94rem;letter-spacing:-0.01em;padding:0.34rem 0.94rem;border:1px solid #000;border-radius: 0.85rem;width:fit-content;margin:0 auto;margin-bottom:0.85rem;font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.item_week .deal_list ul li .prd_name{font-size:1.07rem;letter-spacing:-0.01em;width:11.52rem;margin:0 auto;line-height: 1.5rem;}
</style>

<script type="text/javascript">
$(function(){
	/* slide content */
	$(".slideWrap .slide").hide();
	$(".slideWrap .slide:first").show();

	$(".btn-next").on("click", function(e){
		$(".slideWrap .slide:first").appendTo(".slideWrap");
		$(".slideWrap .slide").hide().eq(0).show();
	});

	$(".btn-prev").on("click", function(e){
		$(".slideWrap .slide:last").prependTo(".slideWrap");
		$(".slideWrap .slide").hide().eq(0).show();
	});

	/* price info more */
	$(".item-detail .btn-more").on("click", function(){
		var thisCont = $(this).attr("href");
		$(this).toggleClass("on");
		$(thisCont).slideToggle();
		return false;
	});
});
</script>

<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js" ></script>
<script>
    const itemid = '<%= itemid %>';
    const openDate = '<%= openDate %>';
</script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/1.7.1/clipboard.min.js"></script>
<% IF application("Svr_Info") = "Dev" THEN %>
    <script src="/vue/vue_dev.js"></script>
<% Else %>
    <script src="/vue/2.5/vue.min.js"></script>
<% End If %>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>

<!-- Common Components -->
<script src="/vue/components/common/functions/common.js?v=1.1"></script>
<script src="/vue/components/common/item_module_header.js?v=1.110"></script>
<script src="/vue/components/common/modal2.js?v=1.0"></script>
<script src="/vue/components/common/no_data.js?v=1.0"></script>
<script src="/vue/components/common/functions/item_mixins.js?v=110.0"></script>
<script src="/vue/components/common/functions/modal_mixins.js?v=1.110"></script>
<script src="/vue/components/common/functions/common_mixins.js?v=1.100"></script>
<script src="/vue/components/common/btn_top.js?v=1.0"></script>
<!-- //Common Components -->

<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>

<script src="/vue/event/etc/116455/itemDetail.js?v=1.00"></script>

<!-- #include virtual="/lib/inc/incLogScript.asp" -->