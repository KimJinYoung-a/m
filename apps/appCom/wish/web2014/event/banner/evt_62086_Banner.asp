<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
	dim evt_code, vMiracleGiftItemId, vToday, sqlStr, nowdate, dailyProductItemid, eMLinkCode, dailyProductLinkUrl, dailyProductImgName, dailyProductNextImgName, eCode
	dim aJaxEvtUrl

	nowdate = Date()

	IF application("Svr_Info") = "Dev" THEN
		eCode = "61785"
	Else
		eCode = "62086"
	End If


	'// 일자별 상품셋팅
	Select Case Trim(nowDate)
		Case "2015-05-13"
			dailyProductItemid = "1274421"
			dailyProductLinkUrl = "http://m.10x10.co.kr/apps/appcom/wish/web2014/category/category_itemprd.asp?itemid=1274421&ldv=MTAyMjkg"
			dailyProductImgName = "img_item_leather_satchel"
			dailyProductNextImgName = "img_item_mybeans_next"

		Case "2015-05-14"
			dailyProductItemid = "1274422"
			dailyProductLinkUrl = "http://m.10x10.co.kr/apps/appcom/wish/web2014/category/category_itemprd.asp?itemid=1274422&ldv=MTAyMzEg"
			dailyProductImgName = "img_item_mybeans"
			dailyProductNextImgName = "img_item_pooh_next"

		Case "2015-05-15"
			dailyProductItemid = "1274423"
			dailyProductLinkUrl = "http://m.10x10.co.kr/apps/appcom/wish/web2014/category/category_itemprd.asp?itemid=1274423&ldv=MTAyMzIg"
			dailyProductImgName = "img_item_pooh_v1"
			dailyProductNextImgName = "img_item_mooas_next_v1"

		Case "2015-05-16" '//주말
			dailyProductItemid = "1274423"
			dailyProductLinkUrl = "http://m.10x10.co.kr/apps/appcom/wish/web2014/category/category_itemprd.asp?itemid=1274423&ldv=MTAyMzIg"
			dailyProductImgName = "img_item_pooh_v1"
			dailyProductNextImgName = "img_item_mooas_next_v1"

		Case "2015-05-17" '//주말
			dailyProductItemid = "1274423"
			dailyProductLinkUrl = "http://m.10x10.co.kr/apps/appcom/wish/web2014/category/category_itemprd.asp?itemid=1274423&ldv=MTAyMzIg"
			dailyProductImgName = "img_item_pooh_v1"
			dailyProductNextImgName = "img_item_mooas_next_v1"

		Case "2015-05-18"
			dailyProductItemid = "1274424"
			dailyProductLinkUrl = "http://m.10x10.co.kr/apps/appcom/wish/web2014/category/category_itemprd.asp?itemid=1274424&ldv=MTAyMzMg"
			dailyProductImgName = "img_item_mooas_v1"
			dailyProductNextImgName = "img_item_bsw_next_v1"

		Case "2015-05-19"
			dailyProductItemid = "1274425"
			dailyProductLinkUrl = "http://m.10x10.co.kr/apps/appcom/wish/web2014/category/category_itemprd.asp?itemid=1274425&ldv=MTAyMzQg"
			dailyProductImgName = "img_item_bsw"
			dailyProductNextImgName = "img_item_trou_de_lapin_next"

		Case "2015-05-20"
			dailyProductItemid = "1274426"
			dailyProductLinkUrl = "http://m.10x10.co.kr/apps/appcom/wish/web2014/category/category_itemprd.asp?itemid=1274426&ldv=MTAyNDcg"
			dailyProductImgName = "img_item_trou_de_lapin"
			dailyProductNextImgName = "img_self_camera_net"

		Case "2015-05-21"
			dailyProductItemid = "1274427"
			dailyProductLinkUrl = "http://m.10x10.co.kr/apps/appcom/wish/web2014/category/category_itemprd.asp?itemid=1274427&ldv=MTAyNDgg"
			dailyProductImgName = "img_item_self_camera"
			dailyProductNextImgName = "img_item_oohlala_next"

		Case "2015-05-22"
			dailyProductItemid = "1274420"
			dailyProductLinkUrl = "http://m.10x10.co.kr/apps/appcom/wish/web2014/category/category_itemprd.asp?itemid=1274420&ldv=MTAyNTMg"
			dailyProductImgName = "img_item_oohlala"
			dailyProductNextImgName = "img_item_triplets_next"

		Case "2015-05-23" '//주말
			dailyProductItemid = "1274428"
			dailyProductLinkUrl = "http://m.10x10.co.kr/apps/appcom/wish/web2014/category/category_itemprd.asp?itemid=1274428&ldv=MTAyNjIg"
			dailyProductImgName = "img_item_triplets"
			dailyProductNextImgName = "img_item_playmobil_next_v1"

		Case "2015-05-24" '//주말
			dailyProductItemid = "1274419"
			dailyProductLinkUrl = "http://m.10x10.co.kr/apps/appcom/wish/web2014/category/category_itemprd.asp?itemid=1274419&ldv=MTAyNjMg"
			dailyProductImgName = "img_item_playmobil_v1"
			dailyProductNextImgName = "img_item_xiaomi_next"

		Case "2015-05-25"
			dailyProductItemid = "1274429"
			dailyProductLinkUrl = "http://m.10x10.co.kr/apps/appcom/wish/web2014/category/category_itemprd.asp?itemid=1274429&ldv=MTAyNjQg"
			dailyProductImgName = "img_item_xiaomi"
			dailyProductNextImgName = "img_item_picnic_next"

		Case "2015-05-26"
			dailyProductItemid = "1274430"
			dailyProductLinkUrl = "http://m.10x10.co.kr/apps/appcom/wish/web2014/category/category_itemprd.asp?itemid=1274430&ldv=MTAyNjUg"
			dailyProductImgName = "img_item_picnic"
			dailyProductNextImgName = "img_item_fashionbox_next"

		Case "2015-05-27"
			dailyProductItemid = "1274431"
			dailyProductLinkUrl = "http://m.10x10.co.kr/apps/appcom/wish/web2014/category/category_itemprd.asp?itemid=1274431&ldv=MTAyNzYg"
			dailyProductImgName = "img_item_fashionbox"
			dailyProductNextImgName = "img_item_ice_next"

		Case "2015-05-28"
			dailyProductItemid = "1274432"
			dailyProductLinkUrl = "http://m.10x10.co.kr/apps/appcom/wish/web2014/category/category_itemprd.asp?itemid=1274432&ldv=MTAyNzcg"
			dailyProductImgName = "img_item_ice_v1"
			dailyProductNextImgName = "img_item_baby_next"

		Case "2015-05-29"
			dailyProductItemid = "1274434"
			dailyProductLinkUrl = "http://m.10x10.co.kr/apps/appcom/wish/web2014/category/category_itemprd.asp?itemid=1274434&ldv=MTAyODAg"
			dailyProductImgName = "img_item_baby"
			dailyProductNextImgName = ""

		Case Else
			dailyProductItemid = "1274434"
			dailyProductLinkUrl = "img_item_baby"
			dailyProductImgName = ""
			dailyProductNextImgName = ""

	End Select

%>
<style type="text/css">
img {vertical-align:top;}
.mEvt62086 .item {position:relative;}
.mEvt62086 .item .btnevent {position:absolute; bottom:6%; left:50%; width:76%; margin-left:-38%;}
</style>
<script>
	function app_mainchk(){
		var str = $.ajax({
			type: "GET",
			url: "/apps/appcom/wish/web2014/event/etc/evtClickChk62086.asp",
			data: "mode=app_main",
			dataType: "text",
			async: false
		}).responseText;
		if (str == "OK"){
			fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/event/eventmain.asp?eventid=<%=eCode%>');
			return false;
		}else{
			alert('오류가 발생했습니다.');
			return false;
		}
	}
</script>
</head>
<body>
	<!-- 디스전 전면 배너-->
		<div class="mEvt62086">
			<h1><img src="http://webimage.10x10.co.kr/eventIMG/2015/62086/tit_discount_front.jpg" alt="매일 오전 10시! 놀라운 할인혜택! 디스카운트 전" /></h1>
			<div class="item">
				<!-- 5/13 -->
				<div class="goods"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62086/<%=dailyProductImgName%>_front.jpg" alt="" /></div>
				<div class="btnevent"><a href="" onclick="app_mainchk();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62086/btn_evnet.png" alt="이벤트 참여하기" /></a></div>
			</div>
		</div>
	<!--//디스전 전면 배너 -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->