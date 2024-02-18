<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 디스카운트 전(모바일 인증페이지)
' History : 2015.05.12 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
	Dim eCode , vQuery , allcnt, eMainCode, vUserID, myuserLevel, nowDate, confirmChk, dailyProductItemid, dailyProductLinkUrl, dailyProductImgName, dailyProductNextImgName, sqlstr, dateitemlimitcnt

	vUserID = GetLoginUserID()
	myuserLevel = GetLoginUserLevel

	nowDate = Left(Now(), 10)
'	nowDate = "2015-05-13"

	confirmChk = False

	IF application("Svr_Info") = "Dev" THEN
		eCode		=  61786
		eMainCode = 61785
	Else
		eCode		=  62087
		eMainCode = 62086
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


	If IsUserLoginOK Then
		'// 본인이 친구 초대수락여부 했는지 확인
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
		response.cookies("etc")("evtcode") = eCode
	End If


	dateitemlimitcnt=getitemlimitcnt(dailyProductItemid)
'	dateitemlimitcnt=1


%>
<style type="text/css">
img {vertical-align:top;}
.topic .item {position:relative;}
.topic .item .soldout {display:none; position:absolute; bottom:0; left:0; width:100%;}
.confirmation {padding-bottom:10%; background:#c3d4ef url(http://webimage.10x10.co.kr/eventIMG/2015/62086/bg_pattern.png) no-repeat 50% 100%; background-size:100% auto;}
.confirmation .field {margin:0 3%; padding:1.5%; border:1px solid #90b3e2; background-color:#abc3e4;}
.confirmation .field legend {visibility:hidden; width:0; height:0;}
.confirmation .field .before, .confirmation .field .after {padding-bottom:25px; background-color:#fdfdfd;}
.confirmation .field .num {position:relative; padding:0 100px 0 15px;}
.confirmation .field .num input[type=number] {width:100%; height:41px; border:1px solid #d8d8d8; border-radius:0; font-size:13px; color:#333;}
.confirmation .field .num input[type=image] {position:absolute; top:0; right:15px; width:83px;}
::-webkit-input-placeholder { color:#d8d8d8; }
::-moz-placeholder { color:#d8d8d8; } /* firefox 19+ */
:-ms-input-placeholder { color:#d8d8d8; } /* ie */
input:-moz-placeholder { color:#d8d8d8; }

.confirmation .field .after a {display:block; padding:0 15px; text-align:center;}
.confirmation .btnwrap {overflow:hidden; padding:3.5% 3.6% 0;}
.confirmation .btnwrap a {float:left; width:50%; padding:0 0.6%;}

.noti {padding:20px 10px; background-color:#f4f7f7;}
.noti h2 {color:#222; font-size:14px;}
.noti h2 strong {padding-bottom:2px; border-bottom:2px solid #000;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; padding-left:10px; color:#444; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:5px; left:0; width:4px; height:4px; border-radius:50%; background-color:#8c9ace;}

@media all and (min-width:480px){
	.confirmation .field .before, .confirmation .field .after {padding-bottom:37px;}
	.confirmation .field .num {position:relative; padding:0 152px 0 22px;}
	.confirmation .field .num input[type=number] {height:61px; font-size:20px;}
	.confirmation .field .num input[type=image] {right:22px; width:124px;}
	.noti {padding:25px 15px;}
	.noti ul {margin-top:16px;}
	.noti h2 {font-size:17px;}
	.noti ul li {margin-top:2px; font-size:13px;}
}
@media all and (min-width:768px){
	.noti h2 {font-size:20px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:4px; font-size:16px;}
}
</style>
<script>
	function goDisConfirmUser()
	{
		<% If IsUserLoginOK Then %>
			<% If left(nowdate,10)>="2015-05-13" and left(nowdate,10)<"2015-05-30" Then %>
				if (document.frmEvt.userinputNumber.value=="")
				{
					alert("인증번호 7자리를 입력 해주세요.");
					document.frmEvt.userinputNumber.focus();
					return false;
				}
				document.frmEvt.submit();
			<% else %>
				alert("이벤트 기간이 아닙니다.");
				return;
			<% end if %>
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
	}

	function gotoDownload(){
		alert("앱 미설치 고객은 스토어로 이동됩니다.\n설치 후에 [디스전 상품 구매하기]를 다시 클릭해 주세요.");
		parent.top.location.href='http://m.10x10.co.kr/apps/link/?7120150512';
		return false;
	}

</script>
</head>
<body>

<div class="evtCont">
	<%' [모바일 전용] 인증 디스카운트 전(戰) %>
	<div class="mEvt62087">
		<div class="topic">
			<h1><img src="http://webimage.10x10.co.kr/eventIMG/2015/62087/tit_discount.jpg" alt="미션에 성공하면 최대 할인을! 스카운트 전" /></h1>
			<div class="item">
				<div class="goods"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62087/<%=dailyProductImgName%>.jpg" alt="" /></div>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/62086/txt_discount_02.jpg" alt="미션에 성공하고 최대의 할인을 누리세요. 매일 한가지 상품, 선착순 판매의 기회를 잡으세요!" /></p>
				<%' for dev msg : 솔드아웃일 경우 style="display:block;" %>
				<strong class="soldout" <% If dateitemlimitcnt < 1 Then %> style="display:block;" <% End If %>><img src="http://webimage.10x10.co.kr/eventIMG/2015/62086/txt_soldout_04.png" alt="솔드아웃" /></strong>
			</div>
		</div>

		<%' 인증 %>
		<div class="confirmation">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/62086/tit_confirmation.png" alt="디스전 인증하기" /></h2>
			<div class="field">
				<form name="frmEvt" action="doEventSubscript62087.asp" method="post">
					<fieldset>
					<legend>인증번호 입력하기</legend>
						<% If confirmChk Then %>
							<div class="after">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/62087/txt_thanks.png" alt="수락해주셔서 감사합니다. APP다운로드 후, 로그인을 하시면 고객님에게도 디스전 특별가가 적용됩니다. 선착순 한정수량이니 서둘러 주세요." /></p>
								<a href="" onclick="gotoDownload();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62087/btn_get.png" alt="텐바이텐 앱 바로가기" /></a>
							</div>
						<% Else %>
							<div class="before">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/62087/txt_fill.png" alt="인증번호를 입력해주세요. 친구에게는 특별한 할인의 기회를, 당신에게는 쇼핑의 즐거움을 선물합니다!" /></p>
								<div class="num">
									<input type="number" name="userinputNumber" id="userinputNumber" title="인증번호 7자리 입력" placeholder="인증번호 7자리를 입력해 주세요" maxlength="7"/>
									<input type="image" onclick="goDisConfirmUser();return false;" src="http://webimage.10x10.co.kr/eventIMG/2015/62087/btn_accept.png" alt=" 수락하기" />
								</div>
							</div>
						<% End If %>
					</fieldset>
				</form>
			</div>
			<% If Not(IsUserLoginOK) Then %>
				<div class="btnwrap">
					<a href="" onclick="parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62087/btn_login.png" alt="로그인 하기" /></a>
					<a href="/member/join.asp" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62087/btn_join.png" alt="회원가입 하기" /></a>
				</div>
			<% End If %>
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
	</div>
	<!-- //디스카운트 전 -->
</div>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->