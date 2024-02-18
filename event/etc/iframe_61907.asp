<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description :  상품 후기는 사진으로! 마일리지는 두배로!
' History : 2015.04.27 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_evaluatesearchercls.asp" -->

<%
dim currenttime
	currenttime =  now()
	'currenttime = #04/22/2015 09:00:00#

dim eCode, eCodedisp
IF application("Svr_Info") = "Dev" THEN
	eCode   =  61764
	eCodedisp = 61765
Else
	eCode   =  61907
	eCodedisp = 61908
End If

dim userid, i
	userid = getloginuserid()
%>

<!-- #include virtual="/lib/inc/head.asp" -->

<style type="text/css">
img {vertical-align:top;}
.mEvt61908 h1 {visibility:hidden; width:0; height:0;}
.mEvt61908 .mileage {position:relative;}
.mEvt61908 .mileage .before {position:absolute; top:0; left:0; width:100%;}
.mEvt61908 .mileage .before .btnwrap {overflow:hidden; padding:0 2%;}
.mEvt61908 .mileage .before .btnwrap a {float:left; width:50%; padding:0 1.2%;}

.mEvt61908 .mileage .after {position:absolute; top:0; left:0; width:100%; padding-top:7%; padding-left:5%;}
.mEvt61908 .mileage .after .id {position:relative;}
.mEvt61908 .mileage .after .id img {width:168px;}
.mEvt61908 .mileage .after .id strong {position:absolute; top:0; left:0; padding-left:2px; color:#fff; font-size:16px;}
.mEvt61908 .mileage .after .count img {width:83px;}
.mEvt61908 .mileage .after .unit img {width:12px;}
.mEvt61908 .mileage .after .expectation img {width:104px;}
.mEvt61908 .mileage .after .won img {width:11px;}
.mEvt61908 .mileage .after li {padding-top:3%;}
.mEvt61908 .mileage .after li img {vertical-align:middle;}
.mEvt61908 .mileage .after li strong {border-bottom:1px solid #fff600; color:#fff600; font-size:14px;}
.mEvt61908 .mileage .after .btnreview {position:absolute; top:12%; right:4%; width:31%;}

.photoReview {padding:10% 0 7%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/61908/bg_pattern.png) repeat-y 50% 0; background-size:100% auto;}
.photoReview ul {overflow:hidden; margin:5% 3%; padding:2% 1.5% 0; background-color:#fff;}
.photoReview ul li {float:left; width:33.333%; padding-bottom:3%;}
.photoReview ul li a {display:block; padding:0 1%;}
.photoReview .btnmore {width:73%; margin:0 auto;}

.moreReview .app {padding-bottom:3%; background-color:#f6bbbb;}

.noti {padding:20px 10px;}
.noti h2 {color:#222; font-size:14px;}
.noti h2 strong {padding-bottom:2px; border-bottom:2px solid #000;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; padding-left:10px; color:#444; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:8px; left:0; width:4px; height:1px; background-color:#444;}
@media all and (min-width:480px){
	.mEvt61908 .mileage .after .id img {width:252px;}
	.mEvt61908 .mileage .after .id strong {font-size:24px;}
	.mEvt61908 .mileage .after .count img {width:124px;}
	.mEvt61908 .mileage .after .unit img {width:18px;}
	.mEvt61908 .mileage .after .expectation img {width:156px;}
	.mEvt61908 .mileage .after .won img {width:16px;}
	.mEvt61908 .mileage .after li {padding-top:4%;}
	.mEvt61908 .mileage .after li strong {font-size:21px;}

	.noti {padding:25px 15px;}
	.noti ul {margin-top:16px;}
	.noti h2 {font-size:17px;}
	.noti ul li {margin-top:2px; font-size:13px;}
	.noti ul li:after {top:8px;}
}
@media all and (min-width:768px){
	.mEvt61908 .mileage .after li {padding-top:5%;}

	.noti h2 {font-size:20px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:4px; font-size:16px;}
	.noti ul li:after {top:12px;}
}
</style>
</head>
<body>

<!-- iframe -->
<div class="mEvt61908">
	<div class="topic">
		<h1>상품 후기는 사진으로! 마일리지는 두배로!</h1>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/txt_double.png" alt ="단 일주일 동안만 만나는 더블 마일리지 기회! 이벤트 기간은 2015년 4월 28일부터 5월 5일까지 진행됩니다." /></p>
	</div>

	<!-- 마일리지 확인하기 -->
	<div class="mileage">
		<% If IsUserLoginOK() Then %>
			<%
			dim cMil, vMileArr
				vMileArr = 0

			Set cMil = New CEvaluateSearcher
			cMil.FRectUserID = Userid
			cMil.FRectMileage = 200
			vMileArr = cMil.getEvaluatedTotalMileCnt
			Set cMil = Nothing
			%>
			<!-- for dev msg : 로그인 후 -->
			<div class="after">
				<div class="id"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/txt_title.png" alt ="" /> <strong><%= printUserId(userid,2,"*") %></strong></div>
				<ul>
					<li>
						<span class="count"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/txt_count.png" alt ="상품 후기 갯수" /></span>
						<strong><%=vMileArr(0,0)%></strong>
						<span class="unit"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/txt_unit.png" alt ="개" /></span>
					</li>
					<li>
						<span class="expectation"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/txt_mileage.png" alt ="적립 예상 마일리지" /></span>
						<strong><%=FormatNumber(vMileArr(1,0),0)%></strong>
						<span class="won"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/txt_won.png" alt ="원" /></span>
					</li>
				</ul>
				
				<div class="btnreview">
					<% if isApp=1 then %>
						<a href="" onclick="parent.fnAPPpopupBrowserURL('포토후기','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/goodsusing.asp');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/btn_photo_review.png" alt ="포토후기 남기기" /></a>
					<% else %>
						<a href="/my10x10/goodsusing.asp" target='_top'><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/btn_photo_review.png" alt ="포토후기 남기기" /></a>
					<% end if %>
				</div>
			</div>
		<% else %>
			<!-- for dev msg : 로그인 전 -->
			<div class="before">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/txt_mileage_check.png" alt ="내 예상 적립 마일리지 확인하기" /></p>
				<div class="btnwrap">
					<% if isApp=1 then %>
						<a href="" onclick="parent.calllogin(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/btn_login.png" alt ="로그인 하기" /></a>
						<a href="/member/join.asp" onclick="parent.fnAPPpopupBrowserURL('회원가입','http://m.10x10.co.kr/apps/appCom/wish/web2014/member/join.asp'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/btn_join.png" alt =" 회원가입 하기" /></a>
					<% else %>
						<a href="" onclick="parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCodedisp)%>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/btn_login.png" alt ="로그인 하기" /></a>
						<a href="/member/join.asp" target='_top'><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/btn_join.png" alt =" 회원가입 하기" /></a>
					<% end if %>
				</div>
			</div>
		<% end if %>

		<img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/bg_red.png" alt ="" />
	</div>

	<div class="photoReview">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/tit_ex.png" alt ="바람직한 포토후기를 둘러보세요!" /></h2>
		<ul>
			<% if isApp=1 then %>
				<li><a href="" onclick="parent.fnAPPpopupProduct(1230915);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_item_01.jpg" alt ="토이 유리컵 &amp; 워머" /></a></li>
				<li><a href="" onclick="parent.fnAPPpopupProduct(1237018);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_item_02.jpg" alt ="핑크블라썸 디퓨저" /></a></li>
				<li><a href="" onclick="parent.fnAPPpopupProduct(1213212);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_item_03.jpg" alt ="데꼴 2015 놀고먹고 피규어" /></a></li>
				<li><a href="" onclick="parent.fnAPPpopupProduct(1162302);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_item_04.jpg" alt ="FABRIC TAPE" /></a></li>
				<li><a href="" onclick="parent.fnAPPpopupProduct(1112357);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_item_05.jpg" alt ="로코 블루포인트 접시" /></a></li>
				<li><a href="" onclick="parent.fnAPPpopupProduct(1153367);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_item_06.jpg" alt ="달걀 후라이 케이스" /></a></li>
				<li><a href="" onclick="parent.fnAPPpopupProduct(1114838);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_item_07.jpg" alt ="마음을 담아 조명" /></a></li>
				<li><a href="" onclick="parent.fnAPPpopupProduct(1149913);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_item_08.jpg" alt ="CHAIR PAD" /></a></li>
				<li><a href="" onclick="parent.fnAPPpopupProduct(1044817);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_item_09.jpg" alt ="어크로스 더 유니버스" /></a></li>
				<li><a href="" onclick="parent.fnAPPpopupProduct(1118130);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_item_10.jpg" alt ="MASTE DOTS" /></a></li>
				<li><a href="" onclick="parent.fnAPPpopupProduct(1047285);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_item_11.jpg" alt ="la concorde pouch" /></a></li>
				<li><a href="" onclick="parent.fnAPPpopupProduct(1076947);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_item_12.jpg" alt ="밀라노 벽선반 세트" /></a></li>
				<li><a href="" onclick="parent.fnAPPpopupProduct(1024665);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_item_13.jpg" alt ="Wonder Bear" /></a></li>
				<li><a href="" onclick="parent.fnAPPpopupProduct(1244973);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_item_14.jpg" alt ="PAPER CROSS BAG" /></a></li>
				<li><a href="" onclick="parent.fnAPPpopupProduct(491320);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_item_15.jpg" alt ="슬리퍼꽂이" /></a></li>
			<% else %>
				<li><a href="/category/category_itemPrd.asp?itemid=1230915" target='_top'><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_item_01.jpg" alt ="토이 유리컵 &amp; 워머" /></a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=1237018" target='_top'><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_item_02.jpg" alt ="핑크블라썸 디퓨저" /></a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=1213212" target='_top'><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_item_03.jpg" alt ="데꼴 2015 놀고먹고 피규어" /></a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=1162302" target='_top'><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_item_04.jpg" alt ="FABRIC TAPE" /></a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=1112357" target='_top'><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_item_05.jpg" alt ="로코 블루포인트 접시" /></a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=1153367" target='_top'><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_item_06.jpg" alt ="달걀 후라이 케이스" /></a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=1114838" target='_top'><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_item_07.jpg" alt ="마음을 담아 조명" /></a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=1149913" target='_top'><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_item_08.jpg" alt ="CHAIR PAD" /></a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=1044817" target='_top'><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_item_09.jpg" alt ="어크로스 더 유니버스" /></a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=1118130" target='_top'><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_item_10.jpg" alt ="MASTE DOTS" /></a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=1047285" target='_top'><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_item_11.jpg" alt ="la concorde pouch" /></a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=1076947" target='_top'><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_item_12.jpg" alt ="밀라노 벽선반 세트" /></a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=1024665" target='_top'><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_item_13.jpg" alt ="Wonder Bear" /></a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=1244973" target='_top'><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_item_14.jpg" alt ="PAPER CROSS BAG" /></a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=491320" target='_top'><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_item_15.jpg" alt ="슬리퍼꽂이" /></a></li>
			<% end if %>
		</ul>
	</div>

	<div class="moreReview">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/tit_use.png" alt ="야무진 미일리지 사용법!" /></h2>
		<ul>
			<% if isApp=1 then %>
				<li class="app"><a href="" onclick="parent.fnAPPpopupBrowserURL('마이텐바이텐','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/mymain.asp');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_use_01.png" alt ="3만원 이상 구매시 현금처람 사용가능한 마일리지 현황보기" /></a></li>
			<% else %>
				<li><a href="/my10x10/mymain.asp" target='_top'><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_use_01.png" alt ="3만원 이상 구매시 현금처람 사용가능한 마일리지 현황보기" /></a></li>
				<li><a href="/my10x10/mileage_shop.asp" target='_top'><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/img_use_02.png" alt ="텐바이텐의 또 다른 선물 마일리지샵 가기" /></a></li>
			<% end if %>
		</ul>
	</div>

	<div class="noti">
		<h2><strong>이벤트 안내</strong></h2>
		<ul>
			<li>텐바이텐 회원대상 이벤트 입니다. (비회원 참여 불가)</li>
			<li>포토후기를 남기시면 자동으로 200 마일리지가 적립됩니다.</li>
			<li>타인의 작품을 도용한 경우, 부적절한 후기로 간주될 경우 사전 통보 없이 삭제됩니다.</li>
			<li>포토후기에 대한 더블 마일리지는 이벤트 기간동안만 적용됩니다.</li>
		</ul>
	</div>
</div>
<!--// iframe -->

</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->