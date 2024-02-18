<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 기승전쇼핑_이날만을 기다려왔다. 더블일리지!(M)
' History : 2014.09.01 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/etc/event54592Cls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim eCode
eCode=getevt_code
%>

<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 기승전쇼핑_이날만을 기다려왔다. 더블일리지!</title>
<style type="text/css">
.mEvt54593 {border-bottom:2px solid #9e2020;}
.mEvt54593 img {vertical-align:top; width:100%;}
.mEvt54593 p {max-width:100%;}
.doublemileage .section, .doublemileage .section h3 {margin:0; padding:0;}
.doublemileage .heading {position:relative;}
.doublemileage .heading .double {position:absolute; top:25.5%; left:16%; width:19.375%;}
.doublemileage .bad-review {position:relative;}
.doublemileage .bad-review .btnGo {position:absolute; bottom:5.8%; left:0; width:100%; padding:0 10%; box-sizing:border-box; -webkit-box-sizing:border-box; -moz-box-sizing:border-box;}
.doublemileage .noti {background-color:#fff5dd; text-align:left;}
.doublemileage .noti ul {padding:0 5.41666% 8%;}
.doublemileage .noti ul li {margin-top:7px; padding-left:15px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/54591/blt_hypen.gif); background-repeat:no-repeat; background-position:0 10px; background-size:9px auto; color:#444 font-size:16px; line-height:1.5em;}
.doublemileage .noti ul li em {color:#d50c0c; font-style:normal;}
@media all and (max-width:480px){
	.doublemileage .noti ul li {margin-top:2px; padding-left:10px; font-size:11px; background-position:0 6px; background-size:6px auto;}
}
.doublemileage .tab-area {position:relative; padding:15% 0 4%; border-bottom:1px solid #f05a5a; background-color:#d50c0c;}
.doublemileage .tab-area strong {display:block; position:absolute; top:8%; left:0; width:100%;}
.doublemileage .tab-area .tab-nav {overflow:hidden; padding:5% 1.5% 0;}
.doublemileage .tab-area .tab-nav li {float:left; width:25%; padding:0 0.625%; box-sizing:border-box; -webkit-box-sizing:border-box; -moz-box-sizing:border-box;}
.animated {-webkit-animation-duration:5s; animation-duration:5s; -webkit-animation-fill-mode:both; animation-fill-mode:both;}
/* Flash animation */
@-webkit-keyframes flash {
	0%, 50%, 100% {opacity:1;}
	25%, 75% {opacity:0;}
}
@keyframes flash {
	0%, 50%, 100% {opacity: 1;}
	25%, 75% {opacity:0;}
}
.flash {-webkit-animation-name:flash; animation-name:flash; -webkit-animation-duration:3s; animation-duration:3s; -webkit-animation-iteration-count:infinite; animation-iteration-count:infinite;}
/* Bounce animation */
@-webkit-keyframes bounce {
	0%, 20%, 50%, 80%, 100% {-webkit-transform: translateY(0);}
	40% {-webkit-transform: translateY(-7px);}
	60% {-webkit-transform: translateY(-4px);}
}
@keyframes bounce {
	0%, 20%, 50%, 80%, 100% {transform: translateY(0);}
	40% {transform: translateY(-7px);}
	60% {transform: translateY(-4px);}
}
.bounce {-webkit-animation-name:bounce; animation-name:bounce; -webkit-animation-iteration-count:infinite; animation-iteration-count:infinite;}
</style>
</head>
<body>
	<!-- 기승전쇼핑 더블일리지! -->
	<div class="mEvt54593">
		<div class="doublemileage">
			<div class="section heading">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54593/txt_double_mileage.gif" alt="기렸던 상품후기를 작성하여 마일리지로 바꾸다 이날만을 기다려 왔다 더블마일리지!" /></p>
				<span class="double animated flash"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54593/ico_double.png" alt="" /></span>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54593/txt_event.gif" alt="이벤트 기간 내에 상품후기를 작성하시면, 더블 마일리지로 적립해 드립니다! 이벤트 기간은 9월 2일부터 9월 9일까지며, 마일리지는 9월 11일 일괄 지급해드립니다." /></p>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54593/txt_mileage.gif" alt="상품후기를 쓰시면 100포인트의 2배인 200포인트를, 첫 상품후기를 쓰시면 200포인트의 2배인 400포인트를 드려요." /></p>
			</div>

			<div class="section good-review">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54593/tit_good_review.gif" alt="이런 상품후기 좋아요!" /></h3>
				<!--<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54593/txt_good_review.gif" alt="포토후기가 후기이벤트에 당첨 될 확률이 높아요" /></p>-->
				<div class="example">
					<img src="http://webimage.10x10.co.kr/eventIMG/2014/54593/img_good_review_example_01.jpg" alt="좋은 상품후기 예" />
					<img src="http://webimage.10x10.co.kr/eventIMG/2014/54593/img_good_review_example_02.jpg" alt="" />
				</div>
			</div>

			<div class="section bad-review">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54593/tit_bad_review.gif" alt="이런 상품후기 나빠요!" /></h3>
				<div class="example">
					<img src="http://webimage.10x10.co.kr/eventIMG/2014/54593/img_good_bad_example_01.jpg" alt="좋아요 조음 같은 단답형 후기" />
					<img src="http://webimage.10x10.co.kr/eventIMG/2014/54593/img_good_bad_example_02.jpg" alt="" />
				</div>
				<div class="btnGo">
					<a href="/my10x10/goodsusing.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54593/btn_go.png" alt="더블 마일리지 받으러 가기" /></a>
				</div>
			</div>

			<div class="section noti">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/tit_noti.gif" alt="이벤트 유의사항" /></h3>
				<ul>
					<li>이벤트 기간 내에 새롭게 작성하신 상품후기에 한해서만 더블 마일리지가 적용됩니다.</li>
					<li>기존에 작성했던 상품후기 수정은 적용되지 않습니다.</li>
					<li>상품후기가 삭제된 경우에는 마일리지 지급이 되지 않습니다.</li>
					<li>상품후기는 배송정보 [출고완료] 이후부터 작성 하실 수 있습니다.</li>
					<li>상품과 관련 없는 내용이나 이미지를 올리거나, 직접 찍은 사진이 아닐 경우 삭제 및 마일리지 지급이 취소 될 수 있습니다.</li>
				</ul>
			</div>

			<!-- tab -->
			<div class="section tab-area">
				<strong class="animated bounce"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/txt_wellorganized_shopping.png" alt="아침 드라마보다 더 극적인 기승전 쇼핑" /></strong>
				<ul class="tab-nav">
					<!-- #include virtual="/event/etc/iframe_54469_topmenu.asp" -->
				</ul>
			</div>
		</div>
	</div>
	<!-- //기승전쇼핑 더블일리지! -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->