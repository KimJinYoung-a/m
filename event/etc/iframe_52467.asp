<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'###########################################################
' Description : 내가 꿈꾸던 로망이 있는 집
' History : 2014.06.09 원승현 생성
'###########################################################

	dim eCode, cnt, sqlStr

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  21198
	Else
		eCode   =  52467
	End If

	If IsUserLoginOK Then
		'하루 1회 중복 응모 확인
		sqlStr="Select count(sub_idx) " &_
				" From db_event.dbo.tbl_event_subscript " &_
				" WHERE evt_code='" & eCode & "'" &_
				" and userid='" & GetLoginUserID() & "' and convert(varchar(10),regdate,120) = '" &  Left(now(),10) & "'"
		rsget.Open sqlStr,dbget,1
		cnt=rsget(0)
		rsget.Close
	End If
%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > [텐바이텐x직방 제휴 프로모션] 내가 꿈꾸던 로망이 있는 집</title>
<style type="text/css">
.mEvt52467 img {vertical-align:top; width:100%;}
.mEvt52467 p {max-width:100%;}
.dreamHome .section {padding:0;}
.dreamHome .section h3, .dreamHome .section h4 {margin:0; padding:0;}
.dreamHome .section2 ul {overflow:hidden;}
.dreamHome .section2 ul li {float:left; width:50%;}
.dreamHome .section3 {background-color:#02afff;}
.dreamHome .section3 legend {overflow:hidden; visibility:hidden; position:absolute; top:-1000%; width:0; height:0; line-height:0;}
.dreamHome .section3 .group ul {overflow:hidden; padding:0 2%; box-sizing:border-box; -webkit-box-sizing:border-box; -moz-box-sizing:border-box;}
.dreamHome .section3 .group ul li {float:left; width:33.33333%; padding:0 1%; box-sizing:border-box; -webkit-box-sizing:border-box; -moz-box-sizing:border-box; text-align:center;}
.dreamHome .section3 .group ul li a {display:block;}
.dreamHome .section3 .group ul li label {display:block; margin-top:8px; margin-bottom:10px; color:#000; font-size:16px;}
.dreamHome .section3 .group ul li input {border-radius:10px;}
@media all and (max-width:480px){
	.dreamHome .section3 .group ul li label {font-size:12px;}
}
.dreamHome .section3 .btnSubmit {padding:28px 0; text-align:center;}
.dreamHome .section3 .btnSubmit input {width:54%; vertical-align:top;}
.dreamHome .section4 {overflow:hidden;}
.dreamHome .section4 p {float:left; width:63.75%;}
.dreamHome .section4 .btnDown {float:left; width:36.25%;}
</style>
<script src="/lib/js/swiper-1.8.min.js"></script>
<script language="javascript">
<!--
	function checkformM(){

		var frm=document.frmcomm;

		<% If IsUserLoginOK() Then %>
			<% if cnt > 0 then %>
				alert("투표는 1일 1회만 가능합니다.");
				return;
			<% else %>
				<% If datediff("d",date(),"2014-06-18")>=0 Then %>
					if(typeof($('input:radio[name=votecode]:checked').val()) == "undefined"){
						alert("꼭 갖고 싶은 인테리어 상품 하나를 선택해 주세요!");
						return false;
					}
					frm.mode.value="vote";
					frm.action="/event/etc/doEventSubscript52467.asp";
	//				frm.target="evtFrmProc";
					frm.submit();
				<% Else %>
					alert("이벤트 응모 기간이 아닙니다.");
					return;
				<% End If %>

			<% end if %>
		<% Else %>
			parent.jsevtlogin();
		<% End IF %>
	}
	
//-->
</script>
<script type="text/javascript">
	/*var userAgent = navigator.userAgent.toLowerCase();
	function gotoDownload(){
		// 모바일 홈페이지 바로가기 링크 생성
		if(userAgent.match('iphone')) { //아이폰
			parent.document.location="http://itunes.apple.com/kr/app/jigbang-jiggeorae-joheun-bang/id503098735"
		} else if(userAgent.match('ipad')) { //아이패드
			parent.document.location="http://itunes.apple.com/kr/app/jigbang-jiggeorae-joheun-bang/id503098735"
		} else if(userAgent.match('ipod')) { //아이팟
			parent.document.location="http://itunes.apple.com/kr/app/jigbang-jiggeorae-joheun-bang/id503098735"
		} else if(userAgent.match('android')) { //안드로이드 기기
			parent.document.location="market://details?id=com.chbreeze.jikbang4a"
		} else { //그 외
			parent.document.location="market://details?id=com.chbreeze.jikbang4a"
		}
	};*/
</script>
</head>
<body>
	<div class="mEvt52467">
		<div class="dreamHome">
			<div class="section section1">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52467/txt_dream_home.jpg" alt="[텐바이텐X직방] 혼자 사는 내 모습, 그려본 적 있나요? 내가 꿈꾸던 로망의 집" /></p>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52467/txt_dream_home_gift.jpg" alt="텐바이텐이 추천하는 1인 가구 인테리어를 확인한 분들 중 추첨을 통해, 텐바이텐이 추천하는 리빙상품을 선물로 드립니다! 이벤트 기간 : 2014.06.11–6.17 | 당첨자 발표 : 6.23" /></p>
			</div>

			<div class="section section2">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/52467/tit_dream_home_find.jpg" alt="STEP 1. 직방에서 살고 싶은 방 구하기!" /></h3>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52467/txt_dream_home_find.gif" alt="내 방을 바꾸는 스마트한 방법! 직방을 소개해드려요!" /></p>
				<ul>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/52467/txt_find_step_01.jpg" alt="직방app에서 원하는 지역을 찾으세요" /></li>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/52467/txt_find_step_02.jpg" alt="원하는 매물정보를 확인하세요" /></li>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/52467/txt_find_step_03.jpg" alt="다양한 방 이미지와 정보를 확인하세요" /></li>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/52467/txt_find_step_04.jpg" alt="" /></li>
				</ul>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52467/txt_find_step_noti.gif" alt="상기 이미지는 직방 APP상에서 보여지는 정보입니다. 상세 정보는 직방 APP에서 확인하실 수 있습니다." /></p>
			</div>

			<!-- 응모 -->
			<div class="section section3">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/52467/tit_dream_home_goods.jpg" alt="STEP 2. 텐바이텐에서 인테리어 상품 담기" /></h3>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52467/txt_dream_home_goods.gif" alt="텐바이텐이 추천하는 인테리어 상품을 보고, 9개의 상품 중 꼭 갖고 싶은 상품 하나를 선택해 주세요. 이벤트 기간 동안 한 ID로 하루에 한 번씩 참여 가능합니다." /></p>

				<form name="frmcomm" action="" onsubmit="return checkformM();" method="post" style="margin:0px;">
				<input type="hidden" name="mode" value=""/>
					<fieldset>
					<legend>갖고 싶은 인테리어 상품 응모하기</legend>
						<div class="group">
							<h4><img src="http://webimage.10x10.co.kr/eventIMG/2014/52467/tit_dream_home_goods_01.gif" alt="소소한 포인트 하나로 집 분위기를 색다르게!" /></h4>
							<ul>
								<li>
									<a href="/category/category_itemPrd.asp?itemid=311343" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52467/img_goods_01.jpg" alt="" /></a>
									<label for="goods01">자작나무숲2</label>
									<input type="radio" id="goods01" name="votecode" value="311343"/>
								</li>
								<li>
									<a href="/category/category_itemPrd.asp?itemid=558283" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52467/img_goods_02.jpg" alt="" /></a>
									<label for="goods02">환상의달빛</label>
									<input type="radio" id="goods02" name="votecode" value="558283"/>
								</li>
								<li>
									<a href="/category/category_itemPrd.asp?itemid=782102" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52467/img_goods_03.jpg" alt="" /></a>
									<label for="goods03">런던트립 가랜드</label>
									<input type="radio" id="goods03" name="votecode" value="782102"/>
								</li>
							</ul>

							<h4><img src="http://webimage.10x10.co.kr/eventIMG/2014/52467/tit_dream_home_goods_02.gif" alt="작은집 워너비 인테리어 소품" /></h4>
							<ul>
								<li>
									<a href="/category/category_itemPrd.asp?itemid=587856" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52467/img_goods_04.jpg" alt="" /></a>
									<label for="goods04">심플리 펜던트</label>
									<input type="radio" id="goods04" name="votecode" value="587856"/>
								</li>
								<li>
									<a href="/category/category_itemPrd.asp?itemid=420853" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52467/img_goods_05.jpg" alt="" /></a>
									<label for="goods05">LED 우든클락</label>
									<input type="radio" id="goods05" name="votecode" value="420853"/>
								</li>
								<li>
									<a href="/category/category_itemPrd.asp?itemid=319713" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52467/img_goods_06.jpg" alt="" /></a>
									<label for="goods06">노엘컬러 4단선반</label>
									<input type="radio" id="goods06" name="votecode" value="319713"/>
								</li>
							</ul>

							<h4><img src="http://webimage.10x10.co.kr/eventIMG/2014/52467/tit_dream_home_goods_03.gif" alt="좁지만 나만의 아늑한 공간 만들기" /></h4>
							<ul>
								<li>
									<a href="/category/category_itemPrd.asp?itemid=1073599" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52467/img_goods_07.jpg" alt="" /></a>
									<label for="goods07">바람꽃 인견카페트</label>
									<input type="radio" id="goods07" name="votecode" value="1073599"/>
								</li>
								<li>
									<a href="/category/category_itemPrd.asp?itemid=570780" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52467/img_goods_08.jpg" alt="" /></a>
									<label for="goods08">스윙 테이블</label>
									<input type="radio" id="goods08" name="votecode" value="570780"/>
								</li>
								<li>
									<a href="/category/category_itemPrd.asp?itemid=1065338" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52467/img_goods_09.jpg" alt="" /></a>
									<label for="goods09">사다리 선반 행거</label>
									<input type="radio" id="goods09" name="votecode" value="1065338"/>
								</li>
							</ul>
						</div>
						<div class="btnSubmit"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/52467/btn_submit.gif" alt="응모하기" /></div>
					</fieldset>
				</form>
			</div>
			<!-- //응모 -->

			<div class="section section4">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52467/txt_zigbang.gif" alt="내 방을 구하는 스마트한 방법 직방 : 직방을 이용하면 맘에 드는 방을 발품 팔지 않고도 구할 수 있습니다. 이제 직방에서 방의 위치를 확인하고, 내부 실사진도 보면서 손 쉽게 방을 찾으세요!" /></p>
				<div class="btnDown"><a href="http://api.ad-brix.com/v1/referrallink?ak=696464619&amp;ck=4563781" target="_blank" title="새창"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52467/btn_down.jpg" alt="DOWNLOAD" /></a></div>
			</div>

			<div class="section section5">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52467/txt_noti.gif" alt="이벤트 유의사항 : 본 이벤트는 각 ID당 하루에 한 번만 참여 할 수 있습니다. 응모 횟수가 많을수록 당첨 확률이 높아집니다. 이벤트에 당첨되신 고객은 주소 확인 및 간단한 개인정보 취합 후 상품이 발송 됩니다." /></p>
			</div>
		</div>
	</div>
	<!--iframe id="linkProc" name="linkProc" src="about:blank" frameborder="0" width=0 height=0></iframe-->
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->