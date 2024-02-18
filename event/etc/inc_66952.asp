<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  [생일은 끝났지만] 더블 마일리지! 
' History : 2015.10.26 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_evaluatesearchercls.asp" -->
<%
dim eCode, vUserID, cMil, vMileValue, vMileArr
	vUserID = GetEncLoginUserID()
	'vUserID = "10x10yellow"
	If Now() > #10/27/2015 00:00:00# AND Now() < #10/31/2015 23:59:59# Then
		vMileValue = 200
	Else
		vMileValue = 100
	End If

	Set cMil = New CEvaluateSearcher
	cMil.FRectUserID = vUserID
	cMil.FRectMileage = vMileValue
	
	If vUserID <> "" Then
		vMileArr = cMil.getEvaluatedTotalMileCnt
	End If
	Set cMil = Nothing
%>
<style type="text/css">
img {vertical-align:top;}

.mEvt66952 #app {display:none;}
.checkMileage {background:#f48b7d url(http://webimage.10x10.co.kr/eventIMG/2015/66952/m/bg_red_pink.png) repeat-y 50% 0; background-size:100% auto;}

.viewMileage {padding:44px 0 55px; text-align:center; color:#fff;}
.viewMileage .mgCont {color:#333334; font-size:12px; line-height:1.6; -webkit-text-size-adjust:100%}
.viewMileage .mgCont strong {display:inline-block; line-height:1.1;}
.viewMileage .mgCont .t01 {border-bottom:1px solid #333; color:#333;}
.viewMileage .mgCont .t02 {border-bottom:1px solid #ffd36a; color:#ffd36a;}
.viewMileage .mgCont .t03 {border-bottom:1px solid #e60000; color:#e60000;}
.viewMileage .mgBtn {width:85.15%; margin:0 auto; padding-top:15px;}

.checkMileage .after {padding:22px 0 25px;}

.viewReview {position:relative;}
.viewReview ul {position:absolute; left:5%; top:8%; width:90%; height:92%;  overflow:hidden;}
.viewReview ul li {float:left; width:50%; height:15%; padding:0 2%; margin-bottom:3.8%;}
.viewReview ul li a {display:block; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55406/blank.png) left top repeat; background-size:100% 100%; color:transparent;}

.evtNoti {padding:30px 20px; background-color:#f1f5fb;}
.evtNoti strong {display:block; padding-bottom:15px; color:#333; font-size:15px; font-weight:bold;}
.evtNoti ul li {position:relative; margin-top:3px; padding-left:13px; color:#7f7f7f; font-size:13px; line-height:1.688em;}
.evtNoti ul li:after {content:' '; position:absolute; left:0; top:7px; width:3px; height:3px; background:#917a70;}

@media all and (min-width:480px){
	.viewMileage {padding:66px 0 82px;}
	.viewMileage .mgCont {font-size:18px;}
	.viewMileage .mgBtn {padding-top:18px;}

	.checkMileage .after {padding:33px 0 37px;}

	.evtNoti {padding:45px 30px;}
	.evtNoti strong {padding-bottom:23px; font-size:22px;}
	.evtNoti ul li {font-size:18px; padding-left:20px;}
	.evtNoti ul li:after {top:9px; width:5px; height:5px;}
}
</style>
<script>
function jsSubmitComment(){
	<% If isapp="1" Then %>
		parent.calllogin();
		return;
	<% else %>
		parent.jsevtlogin();
		return;
	<% End If %>
}
</script>

	<!-- [생일은 끝났지만] 더블 마일리지! -->
	<div class="mEvt66952">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/66952/m/tit_review.png" alt="텐텐 연말정산" /></h2>

		<!-- 마일리지 확인하기 -->
		<div class="checkMileage">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66952/m/txt_point.png" alt="상품후기를 쓰면 200포인트, 첫 상품후기를 쓰면 400포인트를 드립니다." /></p>

			<% If IsUserLoginOK Then %>
				<!-- 로그인 후 -->
				<!-- for dev msg : 로그인 후에는 클래스 after 붙여주세요 <div class="viewMileage after"> -->
				<div class="viewMileage after">
					<div class="mgCont">
						<p><strong class="t01"><%=vUserID%></strong> 고객님,<br /> <strong class="t02"><%=vMileArr(0,0)%></strong> 개의 상품후기를 남길 수 있습니다.</p>
						<p>이벤트 기간 동안 예상 마일리지 적립금은<br /> <strong class="t03"><%=FormatNumber(vMileArr(1,0),0)%></strong> 원 입니다.</p>
					</div>
					<% if isapp = "1" then %>
						<p class="mgBtn"><a href="" onclick="fnAPPpopupBrowserURL('상품후기','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/goodsusing.asp'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66952/m/btn_review.png" alt="상품후기쓰고 더블 마일리지 받기" /></a></p>
					<% else %>
						<p class="mgBtn"><a href="/my10x10/goodsusing.asp" target="_top" ><img src="http://webimage.10x10.co.kr/eventIMG/2015/66952/m/btn_review.png" alt="상품후기쓰고 더블 마일리지 받기" /></a></p>
					<% end if %>
				</div>
			<% else %>
				<!-- 로그인 전 -->
				<div class="viewMileage">
					<div class="mgCont">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66952/m/txt_expect_mileage.png" alt="나의 예상 적립 마일리지를 확인하세요!" /></p>
					</div>
					<p class="mgBtn"><a href="" onClick="jsSubmitComment(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66952/m/btn_login.png" alt="로그인하기" /></a></p>
				</div>
				<!--// 로그인 전 -->
			<% end if %>
		</div>
		<!--// 마일리지 확인하기 -->

		<div class="viewReview">
			<ul id="mo">
				<li><a href="/category/category_itemprd.asp?itemid=1368291">핫뜨거뜨거 핫핫</a></li>
				<li><a href="/category/category_itemprd.asp?itemid=1371252">핸드폰 새로샀니</a></li>
				<li><a href="/category/category_itemprd.asp?itemid=1321501">켈리 그라펜</a></li>
				<li><a href="/category/category_itemprd.asp?itemid=1370180">내방의 구름구름</a></li>
				<li><a href="/category/category_itemprd.asp?itemid=1317089">꽃을 드립니다</a></li>
				<li><a href="/category/category_itemprd.asp?itemid=1071435">꼬인 우리 사이</a></li>
				<li><a href="/category/category_itemprd.asp?itemid=1196780">네가 사는 그 집</a></li>
				<li><a href="/category/category_itemprd.asp?itemid=1160000">울라울라 이쁘다</a></li>
				<li><a href="/category/category_itemprd.asp?itemid=1323283">심심할 땐 파리타임</a></li>
				<li><a href="/category/category_itemprd.asp?itemid=1371651">미리 크리스데꼴</a></li>
				<li><a href="/category/category_itemprd.asp?itemid=1354485">2016년 부탁해</a></li>
				<li><a href="/category/category_itemprd.asp?itemid=1260174">바글바글 바구니</a></li>
			</ul>
			<ul id="app">
				<li><a href="/category/category_itemprd.asp?itemid=1368291" onclick="fnAPPpopupProduct('1368291'); return false;">핫뜨거뜨거 핫핫</a></li>
				<li><a href="/category/category_itemprd.asp?itemid=1371252" onclick="fnAPPpopupProduct('1371252'); return false;">핸드폰 새로샀니</a></li>
				<li><a href="/category/category_itemprd.asp?itemid=1321501" onclick="fnAPPpopupProduct('1321501'); return false;">켈리 그라펜</a></li>
				<li><a href="/category/category_itemprd.asp?itemid=1370180" onclick="fnAPPpopupProduct('1370180'); return false;">내방의 구름구름</a></li>
				<li><a href="/category/category_itemprd.asp?itemid=1317089" onclick="fnAPPpopupProduct('1317089'); return false;">꽃을 드립니다</a></li>
				<li><a href="/category/category_itemprd.asp?itemid=1071435" onclick="fnAPPpopupProduct('1071435'); return false;">꼬인 우리 사이</a></li>
				<li><a href="/category/category_itemprd.asp?itemid=1196780" onclick="fnAPPpopupProduct('1196780'); return false;">네가 사는 그 집</a></li>
				<li><a href="/category/category_itemprd.asp?itemid=1160000" onclick="fnAPPpopupProduct('1160000'); return false;">울라울라 이쁘다</a></li>
				<li><a href="/category/category_itemprd.asp?itemid=1323283" onclick="fnAPPpopupProduct('1323283'); return false;">심심할 땐 파리타임</a></li>
				<li><a href="/category/category_itemprd.asp?itemid=1371651" onclick="fnAPPpopupProduct('1371651'); return false;">미리 크리스데꼴</a></li>
				<li><a href="/category/category_itemprd.asp?itemid=1354485" onclick="fnAPPpopupProduct('1354485'); return false;">2016년 부탁해</a></li>
				<li><a href="/category/category_itemprd.asp?itemid=1260174" onclick="fnAPPpopupProduct('1260174'); return false;">바글바글 바구니</a></li>
			</ul>
			<p>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/66952/m/img_best_review_01.jpg" alt="BEST상품에는 BEST리뷰가 따라온다!" />
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/66952/m/img_best_review_02.jpg" alt="" />
			</p>
		</div>

		<div class="evtNoti">
			<strong>이벤트 유의사항</strong>
			<ul>
				<li>이벤트 기간 내에 새롭게 작성하신 상품후기에 한해서만 더블 마일리지가 적용됩니다.</li>
				<li>기존에 작성했던 상품후기 수정은 적용되지 않습니다.</li>
				<li>상품후기가 삭제된 경우에는 마일리지 지급이 되지 않습니다.</li>
				<li>상품후기는 배송정보 [출고완료] 이후부터 작성 하실 수 있습니다.</li>
				<li>상품과 관련 없는 내용이나 이미지를 올리거나, 직접 찍은 사진이 아닐 경우 삭제 및 마일리지 지급이 취소 될 수 있습니다.</li>
			</ul>
		</div>
	</div>
	<!-- //[생일은 끝났지만] 더블 마일리지! -->

<script type="text/javascript">
$(function(){
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
			$("#app").show();
			$("#mo").hide();
	}else{
			$("#app").hide();
			$("#mo").show();
	}
});
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->