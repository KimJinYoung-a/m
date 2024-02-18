<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 디스카운트 전(초대받은 유저 구매 페이지)
' History : 2015.05.12 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoriteEventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
dim eCode, vUserID, myuserLevel, vLinkECode, usrSelectItemid, sqlStr, nowDate, dateitemlimitcnt, dailyProductItemid, dailyProductLinkUrl, eMLinkCode, eLinkCode, inviteChk, dailyProductImgName, dailyProductNextImgName, vSub_opt2, vSub_opt3
Dim confirmChk, eMainCode
	vUserID = GetLoginUserID()
	myuserLevel = GetLoginUserLevel

	nowDate = Left(Now(), 10)
'	nowDate = "2015-05-13"


	IF application("Svr_Info") = "Dev" THEN
		eCode		=  61787
		eMainCode = 61785
	Else
		eCode		=  62088
		eMainCode = 62086
	End If

	inviteChk = False
	confirmChk = False


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



	If IsUserLoginOK Then

		'// 친구 초대수락한 사람인지 확인(친구 초대 수락한 사람은 이 페이지에서 구매 가능함)
		sqlstr = "select count(*) "
		sqlstr = sqlstr & " from [db_temp].[dbo].[tbl_disEvent]"
		sqlstr = sqlstr & " where evt_code="& eMainCode &""
		sqlstr = sqlstr & " and receiveid='"& vUserID &"' and convert(varchar(10),receivedate,120) = '"& Left(nowdate, 10) &"' "
		rsget.Open sqlstr, dbget, 1
			If rsget(0) > 0 Then
				confirmChk = True
			Else
				confirmChk = False
			End If
		rsget.close
	Else
		'// 회원가입이 안되어 있음 쿠키 굽는다.(추후 가입완료시 이벤트 페이지 이동을 위해)
		response.cookies("etc").domain="10x10.co.kr"
		response.cookies("etc")("evtcode") = 62086
	End If


	dateitemlimitcnt=getitemlimitcnt(dailyProductItemid)
'	dateitemlimitcnt=1



	'// 초대 받은사람이 수락했다면 이 페이지 보이고 아님 기본 이벤트 페이지로 보냄.
	If  confirmChk Then

	Else
		response.write "<script>alert('친구 초대에 수락한 회원만 보실 수 있는 페이지 입니다.');fnAPPpopupEvent('"&eMainCode&"');</script>"
		response.End
	End If

%>
<style type="text/css">
img {vertical-align:top;}
.topic .item {position:relative;}
.topic .item .soldout {display:none; position:absolute; bottom:0; left:0; width:100%;}
.confirmation {padding-bottom:6.5%; background:#c3d4ef url(http://webimage.10x10.co.kr/eventIMG/2015/62086/bg_pattern.png) no-repeat 50% 100%; background-size:100% auto;}
.confirmation .btnnext {width:45.5%; margin:4% auto 0;}
.confirmation .get {margin:0 3%; padding:1.5%; border:1px solid #90b3e2; background-color:#abc3e4;}
.confirmation .get .btnget {display:block; padding:0 15px 25px; background-color:#fdfdfd;}

.lypreview {display:none; position:absolute; top:1.5%; left:50%; z-index:250; width:97%; margin-left:-48.5%;}
.lypreview .inner {padding-top:1.5%; padding-left:1%;}
.lypreview .btnclose {position:absolute; top:0; right:4%; width:13%; background-color:transparent;}

.mask {display:none; position:absolute; top:0; left:0; z-index:200; width:100%; height:100%; background:rgba(0,0,0,.8);}

.noti {padding:20px 10px; background-color:#f4f7f7;}
.noti h2 {color:#222; font-size:14px;}
.noti h2 strong {padding-bottom:2px; border-bottom:2px solid #000;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; padding-left:10px; color:#444; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:5px; left:0; width:4px; height:4px; border-radius:50%; background-color:#8c9ace;}

@media all and (min-width:480px){
	.noti {padding:25px 15px;}
	.noti ul {margin-top:16px;}
	.noti h2 {font-size:17px;}
	.noti ul li {margin-top:2px; font-size:13px;}
}
@media all and (min-width:768px){
	.confirmation .get .btnget {display:block; padding:0 22px 37px;}
	.noti h2 {font-size:20px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:4px; font-size:16px;}
}
</style>
<script type="text/javascript">

</script>
</head>
<body>
<div class="evtCont">
	<%' [APP 전용] 디스카운트 전(戰) 초대받은 사람 구매하러 가기 페이지 %>
	<div class="mEvt62088">
		<div class="topic">
			<h1><img src="http://webimage.10x10.co.kr/eventIMG/2015/62088/tit_discount.jpg" alt="미션에 성공하면 최대 할인을! 스카운트 전 매일 한가지 상품, 한정수량, 선착순 판매의 기회!" /></h1>
			<div class="item">
				<%' 5/13 %>
				<div class="goods"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62086/<%=dailyProductImgName%>.jpg" alt="" /></div>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/62086/txt_discount_01.jpg" alt="한정 수량이므로 구매 가능 조건 충족시 바로 구매하셔야 합니다. 결제 시, 상품 특별 할인 쿠폰을 꼭 적용해 주세요." /></p>
				<%' for dev msg : 솔드아웃일 경우 style="display:block;" %>
				<strong class="soldout" <% If dateitemlimitcnt < 1 Then %> style="display:block;" <% End If %>><img src="http://webimage.10x10.co.kr/eventIMG/2015/62086/txt_soldout_04.png" alt="솔드아웃" /></strong>
			</div>
		</div>

		<%' 인증 %>
		<div class="confirmation">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/62086/tit_confirmation.png" alt="디스전 인증하기" /></h2>
			<div class="get">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/62088/txt_get.png" alt="디스전을 빠르게 구매하세요. 구에게는 특별한 할인의 기회를, 당신에게는 쇼핑의 즐거움을 선물합니다!" /></p>
				<% If dateitemlimitcnt < 1 Then %>
				<% Else %>
					<a href="<%=dailyProductLinkUrl%>" class="btnget" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62088/btn_get.png" alt="디스전 구매하러가기" /></a>
				<% End If %>
			</div>

			<%' for dev msg : 내일의 디스전 보기 %>
			<% If Trim(nowDate) < "2015-05-29" Then %>
				<div class="btnnext"><a href="#lypreview"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62086/btn_next.png" alt="내일의 디스전 보기" /></a></div>
			<% End If %>
		</div>

		<%' for dev msg : 내일의 디스전 보기 layer %>
		<div id="lypreview" class="lypreview">
			<div class="inner">
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/62086/<%=dailyProductNextImgName%>.png" alt="" />
				<button type="button" class="btnclose"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62086/btn_close.png" alt="닫기" /></button>
			</div>
		</div>

		<div class="noti">
			<h2><strong>이벤트 주의사항</strong></h2>
			<ul>
				<li>본 이벤트는 로그인 후에 참여가 가능합니다.</li>
				<li>디스상품은 하루에 ID당 1회만 구매가 가능합니다.</li>
				<li>디스상품은 한정수량이며, 조기에 품절될 수 있습니다.</li>
				<li>오늘의 상품은 친구를 초대 후 인증 완료 시 디스전 특별가로 구매할 수 있습니다.</li>
				<li>친구초대 인증 후 구매하기 버튼을 누르고, 상품 상세페이지에 있는 녹색 할인쿠폰을 다운받아 결제 시 사용하세요.</li>
				<li>다운받은 상품 쿠폰은 자정기준으로 자동 소멸됩니다.</li>
				<li>할인혜택은 디스전 이벤트를 참여한 고객님과 인증완료 한 친구 모두에게 드립니다.</li>
				<li>디스전의 상품들은 본 이벤트 전용으로, 기존의 판매되고 있는 상품들과는 별개입니다.</li>
				<li>디스전은 즉시결제로만 구매가 가능하며, 배송 후 반품/교환/구매취소가 불가능합니다.</li>
			</ul>
		</div>

		<div class="mask"></div>
	</div>
	<%' //디스카운트 전 %>
</div>
<script type="text/javascript">
$(function() {
	$(".btnnext").click(function(){
		$("#lypreview").show();
		$(".mask").show();
	});

	/* layer */
	$(".mask, #lypreview .btnclose").click(function(){
		$("#lypreview").hide();
		$(".mask").hide();
	});
});
</script>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
