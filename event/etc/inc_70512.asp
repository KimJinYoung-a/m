<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  더블 마일리지! 
' History : 2016.05.02 원승현 생성
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
	If Now() > #05/04/2016 00:00:00# AND Now() < #05/11/2016 23:59:59# Then
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
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

img {vertical-align:top;}

.doubleMileage .check {padding:8% 0 7.5%; background:#e16f0b url(http://webimage.10x10.co.kr/eventIMG/2016/70512/m/bg_pattern_dot_orange.png) repeat-y 50% 0; background-size:100% auto; text-align:center;}
.doubleMileage .check ul {padding:0 18.125%;}
.doubleMileage .check ul li {position:relative; margin-top:1.5rem; color:#fff; font-weight:bold; text-align:center;}
.doubleMileage .check ul li:first-child {margin-top:0;}
.doubleMileage .check ul li b {position:absolute; top:0; right:9%; color:#ffdb35; font-size:1.6rem;}
.doubleMileage .check .btnGroup {margin-top:7%;}
.doubleMileage .check .btnGroup a {display:block; width:63.4375%; margin:0 auto;}

.best {position:relative;}
.best .item {position:relative;}
.best .item ul {overflow:hidden; position:absolute; top:0; left:0; width:100%; padding:0 5.2%;}
.best .item ul li {float:left; width:50%; margin-bottom:3%;}
.best .item ul li a {display:block; margin:0 2.6%; /*background-color:#000; opacity:0.2;*/}
.best .btnMore {position:absolute; bottom:0; left:0; width:100%;}

.noti {padding:8% 5.78% 10%;background-color:#efe9cf;}
.noti h3 {color:#54321d; font-size:1.3rem; font-weight:bold;}
.noti ul {margin-top:1.5rem;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#9c8577; font-size:1rem; line-height:1.5em;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.5rem; left:0; width:0.4rem; height:0.1rem; background-color:#9c8577;}
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


<div class="mEvt70512 doubleMileage">
	<div class="topic">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/tit_double_mileage_v1.gif" alt="더블 마일리지" /></h2>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/txt_double_mileage.png" alt="지금 5월 11일까지 상품후기를 쓰면 마일리지가 두배! 후기 작성시 100마일리지의 두배인 200마일리지를, 해당 상품의 첫 후기를 작성시 200마일리지의 두배인 400마일리지를 드립니다. 마이텐바이텐의 MY 쇼핑활동의상품후기, 각 상품 별 하단에 기입되어있음" /></p>
	</div>

	<% If IsUserLoginOK Then %>
		<%' for dev msg : 로그인 후 %>
		<div class="check">
			<ul>
				<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/txt_review_count.png" alt="상품 후기 개수" /><b><%=vMileArr(0,0)%></b></li>
				<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/txt_expect_mileage.png" alt="예상 마일리지" /><b><%=FormatNumber(vMileArr(1,0),0)%></b></li>
			</ul>

			<div class="btnGroup">
				<% If isApp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('상품후기','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/goodsusing.asp'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/btn_write_review.png" alt="상품 후기 쓰러가기" /></a>
				<% Else %>
					<a href="/my10x10/goodsusing.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/btn_write_review.png" alt="상품 후기 쓰러가기" /></a>
				<% End If %>
			</div>
		</div>
	<% Else %>
		<%' for dev msg : 로그인 전 %>
		<div class="check">
			<ul>
				<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/txt_review_count.png" alt="상품 후기 개수" /><b>*</b></li>
				<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/txt_expect_mileage.png" alt="예상 마일리지" /><b>*</b></li>
			</ul>
			<div class="btnGroup">
				<a href="" onClick="jsSubmitComment(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/btn_login.png" alt="로그인 하기" /></a>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/txt_need_login.png" alt="예상 마일리지는 로그인 후 확인 할 수 있습니다" /></p>
			</div>
		</div>

	<% End If %>

	<div class="best">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/tit_best_reivew.png" alt="Best 상품에는 Best 리뷰가 따라온다!" /></h3>
		<div class="item">
			<% If isapp = "1" Then %>
				<ul>
					<li><a href="" onclick="fnAPPpopupProduct(1226544);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/img_item_white.png" alt="공기가 상큼 Air 가정용 소형 공기청정기 에어비타 큐" /></a></li>
					<li><a href="" onclick="fnAPPpopupProduct(1395662);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/img_item_white.png" alt="쉴 때도 예쁘게 the band pink" /></a></li>
					<li><a href="" onclick="fnAPPpopupProduct(749271);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/img_item_white.png" alt="화분 자리 원목 사각 스툴" /></a></li>
					<li><a href="" onclick="fnAPPpopupProduct(1313570);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/img_item_white.png" alt="향기 on 메모리 래인 캔들 워머 화이트" /></a></li>
					<li><a href="" onclick="fnAPPpopupProduct(1194365);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/img_item_white.png" alt="넌 너무 가벼워 슬림팩 리모와 디자인 휴대용 보조배터리 6,000mAh" /></a></li>
					<li><a href="" onclick="fnAPPpopupProduct(1149977);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/img_item_white.png" alt="넌 너무 가벼워 tobe 원데이레코드북 오늘을 기록해" /></a></li>
					<li><a href="" onclick="fnAPPpopupProduct(1460978);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/img_item_white.png" alt="그랜드 부다페스트" /></a></li>
					<li><a href="" onclick="fnAPPpopupProduct(1146524);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/img_item_white.png" alt="매일매일 신고 싶어 Excelsior Low Cut W3166R" /></a></li>
					<li><a href="" onclick="fnAPPpopupProduct(879996);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/img_item_white.png" alt="비를 막아주세요 lifestudio 자동장우산" /></a></li>
					<li><a href="" onclick="fnAPPpopupProduct(1350646);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/img_item_white.png" alt="든든한 백 아이띵소 neat bag ash" /></a></li>
					<li><a href="" onclick="fnAPPpopupProduct(243393);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/img_item_white.png" alt="굿 모닝 모닝 Retro 모닝세트 컵과 트레이" /></a></li>
					<li><a href="" onclick="fnAPPpopupProduct(1112223);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/img_item_white.png" alt="내 방 속 작은 정원 건강한 인테리어를 위한 모던화분 시리즈" /></a></li>
				</ul>
			<% Else %>
				<ul>
					<li><a href="/category/category_itemPrd.asp?itemid=1226544&amp;pEtr=70512"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/img_item_white.png" alt="공기가 상큼 Air 가정용 소형 공기청정기 에어비타 큐" /></a></li>
					<li><a href="/category/category_itemPrd.asp?itemid=1395662&amp;pEtr=70512"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/img_item_white.png" alt="쉴 때도 예쁘게 the band pink" /></a></li>
					<li><a href="/category/category_itemPrd.asp?itemid=749271&amp;pEtr=70512"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/img_item_white.png" alt="화분 자리 원목 사각 스툴" /></a></li>
					<li><a href="/category/category_itemPrd.asp?itemid=1313570&amp;pEtr=70512"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/img_item_white.png" alt="향기 on 메모리 래인 캔들 워머 화이트" /></a></li>
					<li><a href="/category/category_itemPrd.asp?itemid=1194365&amp;pEtr=70512"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/img_item_white.png" alt="넌 너무 가벼워 슬림팩 리모와 디자인 휴대용 보조배터리 6,000mAh" /></a></li>
					<li><a href="/category/category_itemPrd.asp?itemid=1149977&amp;pEtr=70512"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/img_item_white.png" alt="넌 너무 가벼워 tobe 원데이레코드북 오늘을 기록해" /></a></li>
					<li><a href="/category/category_itemPrd.asp?itemid=1460978&amp;pEtr=70512"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/img_item_white.png" alt="그랜드 부다페스트" /></a></li>
					<li><a href="/category/category_itemPrd.asp?itemid=1146524&amp;pEtr=70512"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/img_item_white.png" alt="매일매일 신고 싶어 Excelsior Low Cut W3166R" /></a></li>
					<li><a href="/category/category_itemPrd.asp?itemid=879996&amp;pEtr=70512"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/img_item_white.png" alt="비를 막아주세요 lifestudio 자동장우산" /></a></li>
					<li><a href="/category/category_itemPrd.asp?itemid=1350646&amp;pEtr=70512"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/img_item_white.png" alt="든든한 백 아이띵소 neat bag ash" /></a></li>
					<li><a href="/category/category_itemPrd.asp?itemid=243393&amp;pEtr=70512"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/img_item_white.png" alt="굿 모닝 모닝 Retro 모닝세트 컵과 트레이" /></a></li>
					<li><a href="/category/category_itemPrd.asp?itemid=1112223&amp;pEtr=70512"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/img_item_white.png" alt="내 방 속 작은 정원 건강한 인테리어를 위한 모던화분 시리즈" /></a></li>
				</ul>
			<% End If %>
			<img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/img_item_01.jpg" alt="" />
			<img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/img_item_02.jpg" alt="" />
		</div>
		<!--a href="/bestreview/bestreview_main.asp?disp=" title="베스트 리뷰 페이지로 이동" class="btnMore"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70512/m/btn_more_review.gif" alt="더 많은 상품후기 보기 " /></a-->
	</div>

	<div class="noti">
		<h3>이벤트 유의사항</h3>
		<ul>
			<li>이벤트 기간 내에 작성하신 상품후기에 한해서만 더블 마일리지가 적용됩니다.</li>
			<li>기존에 작성했던 상품후기 수정은 적용되지 않습니다.</li>
			<li>상품후기가 삭제된 경우에는 마일리지 지급이 되지 않습니다.</li>
			<li>상품후기는 배송정보 [출고완료] 이후부터 작성 하실 수 있습니다.</li>
			<li>상품과 관련 없는 내용이나 이미지를 올리거나, 직접 찍은 사진이 아닐 경우 삭제 및 마일리지 지급이 취소 될 수 있습니다.</li>
		</ul>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->