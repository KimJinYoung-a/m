<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : [2016 S/S 웨딩] 2016 S/S 웨딩 메인 
' History : 2016-03-23 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
dim currenttime, eCode, itemlimitcnt
dim eitemsort, eItemListType, cEventItem
dim mkteCode, livingeCode, homecafeeCode, bedroomeCode, dresseCode
dim egCode, justEcode, itemid
dim userid, i, intI, iTotCnt, itemnum
	userid = GetEncLoginUserID()

currenttime = now()
'currenttime = #01/18/2016 10:05:00#
''left(currenttime,10)

intI =0

IF application("Svr_Info") = "Dev" THEN
	eCode			= 66084
	mkteCode		= 66067
	livingeCode	= 66089
	homecafeeCode = 66091
	bedroomeCode	= 66092
	dresseCode		= 66093

	if left(currenttime,10) < "2016-04-04" then
		justEcode = 66085
		egCode		= 136862
	elseif left(currenttime,10) >= "2016-04-04" and left(currenttime,10) < "2016-04-11" then
		justEcode = 66086
		egCode		= 136863
	elseif left(currenttime,10) >= "2016-04-11" and left(currenttime,10) < "2016-04-18" then
		justEcode = 66087
		egCode		= 136864
	elseif left(currenttime,10) >= "2016-04-18" then
		justEcode = 66088
		egCode		= 136865
	end if
Else
	eCode			= 69755
	mkteCode		= 69768
	livingeCode	= 69763
	homecafeeCode	= 69765
	bedroomeCode	= 69764
	dresseCode		= 69766

	if left(currenttime,10) < "2016-04-04" then
		justEcode = 69757
		egCode		= 175328
	elseif left(currenttime,10) >= "2016-04-04" and left(currenttime,10) < "2016-04-11" then
		justEcode = 69758
		egCode		= 176178		''추후 수정
	elseif left(currenttime,10) >= "2016-04-11" and left(currenttime,10) < "2016-04-18" then
		justEcode = 69759
		egCode		= 176716		''추후 수정
	elseif left(currenttime,10) >= "2016-04-18" then
		justEcode = 69760
		egCode		= 177185		''추후 수정
	end if
End If

IF egCode = "" THEN egCode = 0

itemlimitcnt = 30	'상품최대갯수
eitemsort = 3		'정렬방법
eItemListType = "1"	'격자형

set cEventItem = new ClsEvtItem
cEventItem.FECode 	= justEcode
cEventItem.FEGCode 	= egCode
cEventItem.FEItemCnt= itemlimitcnt
cEventItem.FItemsort= eitemsort
cEventItem.fnGetEventItem_v2
iTotCnt = cEventItem.FTotCnt

IF itemid = "" THEN
	itemid = cEventItem.FItemArr
ELSE
	itemid = itemid&","&cEventItem.FItemArr
END IF

'Randomize
'Dim N(18), k, tmp, x, y
'k=0
'	DO while k < (ubound(N)+1) '0-9까지 반복
'	
'	tmp = Int ((19-1+1)*Rnd+1) '난수뽑기
'	x = true '처음에 중복이 안됨다고 가정
'	
'	for y=0 to ubound(N) '기존 배열에서 중복체크
'		if tmp= N(y) then '중복시
'			x=false '아래에서 배열에 저장하지 않기 위해 
'		end if
'	next
'	
'	if x=true then '중복이 안되는 경우
'		N(k)=tmp '배열에 저장
'		k=k+1 '다음 난수뽑기로 (한번 반복을 시킨다)
'	end if
'	
'	
'	LOOP

%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

img {vertical-align:top;}

.hidden {visibility:hidden; width:0; height:0;}

.justOneWeek h3 {position:relative;}
.justOneWeek h3 span {position:absolute; top:27%; right:14%; width:22.5%;}

.bounce {animation-name:bounce; animation-duration:3s; animation-fill-mode:both; animation-iteration-count:5;}
.bounce {-webkit-animation-name:bounce; -webkit-animation-duration:3s; -webkit-animation-fill-mode:both; -webkit-animation-iteration-count:5;}
@keyframes bounce {
	0%, 20%, 50%, 80%, 100% {transform:translateY(0);}
	40% {transform:translateY(-10px);}
	60% {transform:translateY(-5px);}
}
@-webkit-keyframes bounce {
	0%, 20%, 50%, 80%, 100% {-webkit-transform:translateY(0);}
	40% {-webkit-transform:translateY(-10px);}
	60% {-webkit-transform:translateY(-5px);}
}

.rolling {position:relative; background-color:#ffcdac;}
.rolling .swiper {position:absolute; top:6.7%; left:0; width:100%;  background:url(http://webimage.10x10.co.kr/eventIMG/2016/69755/m/bg_rolling_left_v2.png) no-repeat 0 0; background-size:100% auto;}
.rolling .swiper .swiper-container {}
.rolling .swiper-slide {width:56.25%; height:56.25%; text-align:center;}
.rolling .swiper-slide a {display:block; position:relative; width:100%; height:100%;}
.rolling .swiper-slide .thumb {padding:2%; border-radius:50%; -webkit-border-radius:50%; background-color:#fff; /*box-shadow:10px 10px 27px -8px rgba(0,0,0,0.3);*/ text-align:center;}
.rolling .swiper-slide .thumb img {overflow:hidden; border-radius:50%; -webkit-border-radius:50%;}
.rolling .swiper-slide .desc {margin-top:1.5rem; text-align:center; line-height:1.5em;}
.rolling .swiper-slide .desc p {overflow:hidden; text-overflow:ellipsis; white-space:nowrap; color:#000; font-size:1.3rem; font-weight:bold;}
.rolling .swiper-slide .desc div {margin-top:0.8rem; color:#7a6256; font-size:1.2rem;}
.rolling .swiper-slide .desc div span {color:#d60000; font-weight:bold;}
.rolling .swiper-slide .desc .discount {position:absolute; top:5%; right:0; width:4rem; height:4rem; border-radius:50%; background-color:#d60000; color:#fff; font-size:1.3rem; font-weight:bold;}
.rolling .swiper-slide .desc .discount span {display:table; width:100%; height:100%;}
.rolling .swiper-slide .desc .discount span i {display:table-cell; vertical-align:middle;}
.rolling .swiper-slide .desc .discount + div {margin-top:0;}
.weddingMembership {position:relative;}
.weddingMembership .btnGo {position:absolute; bottom:15%; left:50%; width:40.62%; margin-left:-20.31%;}

.loveHouse {background-color:#fffff6;}
.loveHouse h3 {width:93.75%; margin:0 auto;}
.loveHouse .pdtListV15a {overflow:visible; padding:0 4.68% 10%;}
.loveHouse .pdtListV15a:after {content:' '; display:block; clear:both;}
.loveHouse .pdtListV15a li {float:left; width:50%; padding-top:1rem; text-align:center;}
.loveHouse .pdtListV15a li a {display:block; position:relative;}
.loveHouse .pdtListV15a li:nth-child(2n) {padding-left:0.7rem;}
.loveHouse .pdtListV15a li:nth-child(2n+1) {padding-right:0.7rem;}
.loveHouse .pdtListV15a li .no {position:absolute; top:0; right:0; z-index:5; width:2.3rem; height:2.3rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/69755/m/bg_label_sky.png) no-repeat 50% 0; background-size:100% 100%; font-weight:500;}
.loveHouse .pdtGroup2 .pdtListV15a li .no {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/69755/m/bg_label_green.png);}
.loveHouse .pdtGroup3 .pdtListV15a li .no {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/69755/m/bg_label_orange.png);}
.loveHouse .pdtGroup4 .pdtListV15a li .no {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/69755/m/bg_label_yellow.png);}

.loveHouse .pdtListV15a li .no span {display:table; width:100%; height:100%; text-align:right;}
.loveHouse .pdtListV15a li .no span i {display:table-cell; padding-right:0.5rem; vertical-align:middle; color:#fff; font-size:1.3rem; text-shadow:0 1px 1px #9b9b9b;}
.loveHouse .pdtListV15a .pdtCont {min-height:0; padding:0.8rem 0.8rem 1.5rem; border-bottom-right-radius:0.9rem; border-bottom-left-radius:0.9rem; background-color:#fff; box-shadow:0 0.1rem 0.1rem -0.1rem #aaa;}
.loveHouse .pdtListV15a li .pName {display:block; height:auto;}
.loveHouse .pdtListV15a li .pName, 
.loveHouse .pdtListV15a li .pPrice {overflow:hidden; text-overflow:ellipsis; white-space:nowrap;}
.loveHouse .pdtListV15a li .pPrice {margin-top:0.5rem;}

.relativeEvt {margin-top:-5%; padding:0 4.687% 12%; background-color:#fffff6;}
.relativeEvt ul li {padding-top:3%;}
.relativeEvt ul li:first-child {padding-top:0;}
</style>
<script type="text/javascript">
$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt69755").offset().top}, 0);
	mySwiper1 = new Swiper('.swiper1',{
		slidesPerView:"auto",
		centeredSlides:true,
		spaceBetween:"10%",
		loop:false,
		resizeReInit:true,
		calculateHeight:true,
		autoplay:false,
		speed:800,
		onSlideChangeStart: function (mySwiper1) {
			$(".swiper").css("background","none");

			if ($(".swiper-slide-active").is(".swiper-slide-01")) {
				$(".swiper").css("background","url(http://webimage.10x10.co.kr/eventIMG/2016/69755/m/bg_rolling_left_v2.png) no-repeat 0 0");
				$(".swiper").css("background-size","100% auto");
			}
		}
	});

	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			mySwiper1.reInit();
			mySwiper2.reInit();
				clearInterval(oTm);
		}, 500);
	});

	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
			$(".mEvt69162 .app").show();
			$(".mEvt69162 .mo").hide();
	}else{
			$(".mEvt69162 .app").hide();
			$(".mEvt69162 .mo").show();
	}
});

//이벤트 이동
function goEventLinktab(evt) {
	<% If isapp="1" Then %>
		document.location.href = "/apps/appCom/wish/web2014/event/eventmain.asp?eventid="+evt;
	<% else %>
		document.location.href = "/event/eventmain.asp?eventid="+evt;
	<% end if %>
}
</script>
	<div class="mEvt69755 wedding">
		<article>
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/69755/m/tit_wedding.jpg" alt="당신의 결혼에 초대해주세요 설레이는 그 날을 위한 특별한 선물" /></h2>

			<%''//  Just One Week %>
			<section class="justOneWeek">
				<h3>
					<img src="http://webimage.10x10.co.kr/eventIMG/2016/69755/m/tit_just_one_week.png" alt="단 일주일의 특가" />
					<%''//  for dev msg : 마지막 날일때 ico_d_day.png / 마지막 전날일 경우에는 ico_d_day_before.png  %>
					<span class="dDay bounce">
						<% if left(currenttime,10) = "2016-04-03" or left(currenttime,10) = "2016-04-10" or left(currenttime,10) = "2016-04-17" or left(currenttime,10) = "2016-04-24" then %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/69755/m/ico_d_day_3.png" alt="오늘이 마지막" />
						<% end if %>
						<% if left(currenttime,10) = "2016-04-02" or left(currenttime,10) = "2016-04-09" or left(currenttime,10) = "2016-04-16" or left(currenttime,10) = "2016-04-23" then %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/69755/m/ico_d_day_2.png" alt="D - 1" >
						<% end if %>
						<% if left(currenttime,10) = "2016-04-01" or left(currenttime,10) = "2016-04-08" or left(currenttime,10) = "2016-04-15" or left(currenttime,10) = "2016-04-22" then %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/69755/m/ico_d_day_1.png" alt="D - 2" >
						<% end if %>
						<%' if left(currenttime,10) = "2016-03-31" or left(currenttime,10) = "2016-04-07" or left(currenttime,10) = "2016-04-15" or left(currenttime,10) = "2016-04-21" then %>
							<!--<img src="http://webimage.10x10.co.kr/eventIMG/2016/69755/m/ico_d_day_3.png" alt="D - 3" >-->
						<%' end if %>
					</span>
				</h3>
				<% IF (iTotCnt >= 0) THEN %>
					<%''//  swiper %>
					<div class="rolling">
						<div class="swiper">
							<div class="swiper-container swiper1">
								<div class="swiper-wrapper">
								<% For intI =0 To 4 %>
									<div class="swiper-slide swiper-slide-0<%= intI+1 %>"> <%'' 01 ~ 05 순차 %>
									<%'' itemnum = cint(N(intI)) %>
									<%'' itemnum = cint(itemnum) %>
									<% if isApp then %>
										<a href="" onclick="fnAPPpopupProduct('<%= cEventItem.FCategoryPrdList(intI).Fitemid %>'); return false;">
									<% else %>
										<a href="/category/category_itemPrd.asp?itemid=<%= cEventItem.FCategoryPrdList(intI).Fitemid %>&amp;pEtr=69755">
									<% end if %>
											<div class="thumb"><img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false") %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
											<div class="desc">
												<p><% = cEventItem.FCategoryPrdList(intI).FItemName %></p>
												<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
													<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem Then %>
														<div><s><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getorgPrice,0) %></s> <span><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %>원</span></div>
														<span class="discount"><span><i><% = cEventItem.FCategoryPrdList(intI).getSalePro %></i></span></span>
													<% End IF %>
													<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem Then %>
														<div><s><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %></s> <span class="cGr1"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %>원</span></div>
													<% End IF %>
												<% Else %>
													<div><span><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %><% if cEventItem.FCategoryPrdList(intI).IsMileShopitem then %> Point<% else %> 원<% end  if %></span></div>
												<% End if %>
											</div>
										</a>
									</div>
								<% next %>
									<div class="swiper-slide swiper-slide-06">
										<a href="" onclick="goEventLinktab('<%= justEcode %>'); return false;">
											<img src="http://webimage.10x10.co.kr/eventIMG/2016/69755/m/img_bnr_just_one_week.png" alt="Just 1 Week 더보러 가기" />
										</a>
									</div>
								</div>
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/eventIMG/2016/69755/m/bg_paper_oragne.png" alt="" />
					</div>
				<% end if %>
			<% set cEventItem = nothing %>
			</section>

			<%''// Wedding Membership -mkt 이벤트%>
			<section class="weddingMembership">
				<h3 class="hidden">Wedding Membership</h3>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69755/m/img_bnr_wedding_membership.jpg" alt="청첩장 등록하고 특별한 혜택을! 구매금액별 할인쿠폰 지급하며, 웨딩쿠폰을 사용한 분들 중에 추첨을 통해 5만원권 기프트 카드를 증정합니다." /></p>
				<a href="" onclick="goEventLinktab('<%= mkteCode %>'); return false;" class="btnGo"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69755/m/btn_go.gif" alt="이벤트 참여하기" /></a>
			</section>

			<%''//  Love House %>
			<section class="loveHouse">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/69755/m/tit_love_house.png" alt="Love House" /></h3>

				<%''//  living room %>
				<%
				itemlimitcnt = 10	'상품최대갯수
				eitemsort = 3		'정렬방법
				eItemListType = "1"	'격자형
				
				set cEventItem = new ClsEvtItem
				cEventItem.FECode 	= livingeCode
				cEventItem.FEGCode 	= 0
				cEventItem.FEItemCnt= itemlimitcnt
				cEventItem.FItemsort= eitemsort
				cEventItem.fnGetEventItem_v2
				iTotCnt = cEventItem.FTotCnt
				%>
				<div class="pdtGroup pdtGroup1">
					<h3>
						<a href="" onclick="goEventLinktab('<%= livingeCode %>'); return false;" title="Living room 상품 더보기"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69755/m/tit_loving_room.png" alt="Living room" /></a></h3>
					<% IF (iTotCnt >= 0) THEN %>
						<ul class="pdtListV15a">
							<%''// for dev msg : 1위에서 10위까지 보여주세요 %>
							<% For intI =0 To iTotCnt %>
								<li <% IF cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut Then %>  class="soldOut"<% end if %>>
									<% if isApp then %>
										<a href="" onclick="fnAPPpopupProduct('<% = cEventItem.FCategoryPrdList(intI).Fitemid %>'); return false;">
									<% else %>
										<a href="/category/category_itemPrd.asp?itemid=<% = cEventItem.FCategoryPrdList(intI).Fitemid %>&amp;pEtr=<%= livingeCode %>">
									<% end if %>
										<b class="no"><span><i><%= intI+1 %></i></span></b>
										<div class="pPhoto">
											<% IF cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut Then %>
												<p><span><em>품절</em></span></p>
											<% end if %>
											<img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false") %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" />
										</div>
										<div class="pdtCont">
											<p class="pName"><% = cEventItem.FCategoryPrdList(intI).FItemName %></p>
											<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
												<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem and cEventItem.FCategoryPrdList(intI).IsCouponItem Then %>
													<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr %>]</span></p>
												<% elseif cEventItem.FCategoryPrdList(intI).IsSaleItem then %>
													<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %>원 <span class="cRd1">[<% = cEventItem.FCategoryPrdList(intI).getSalePro %>]</span></p>
												<% elseif cEventItem.FCategoryPrdList(intI).IsCouponItem then %>
													<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr %>]</span></p>
												<% end if %>
											<% Else %>
												<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %><% if cEventItem.FCategoryPrdList(intI).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
											<% End if %>
										</div>
									</a>
								</li>
							<% next %>
						</ul>
					<% end if %>
				</div>
				<% set cEventItem = nothing %>


				<%''// home cafe %>
				<%
				itemlimitcnt = 10	'상품최대갯수
				eitemsort = 3		'정렬방법
				eItemListType = "1"	'격자형
				
				set cEventItem = new ClsEvtItem
				cEventItem.FECode 	= homecafeeCode
				cEventItem.FEGCode 	= 0
				cEventItem.FEItemCnt= itemlimitcnt
				cEventItem.FItemsort= eitemsort
				cEventItem.fnGetEventItem_v2
				iTotCnt = cEventItem.FTotCnt
				%>
				<div class="pdtGroup pdtGroup2">
					<h3><a href="" onclick="goEventLinktab('<%= homecafeeCode %>'); return false;" title="Home cafe 상품 더보기"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69755/m/tit_home_cafe.png" alt="Home cafe" /></a></h3>
					<% IF (iTotCnt >= 0) THEN %>
						<ul class="pdtListV15a">
							<% For intI =0 To iTotCnt %>
								<li <% IF cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut Then %>  class="soldOut"<% end if %>>
									<% if isApp then %>
										<a href="" onclick="fnAPPpopupProduct('<% = cEventItem.FCategoryPrdList(intI).Fitemid %>'); return false;">
									<% else %>
										<a href="/category/category_itemPrd.asp?itemid=<% = cEventItem.FCategoryPrdList(intI).Fitemid %>&amp;pEtr=<%= homecafeeCode %>">
									<% end if %>
										<b class="no"><span><i><%= intI+1 %></i></span></b>
										<div class="pPhoto">
											<% IF cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut Then %>
												<p><span><em>품절</em></span></p>
											<% end if %>
											<img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false") %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" />
										</div>
										<div class="pdtCont">
											<p class="pName"><% = cEventItem.FCategoryPrdList(intI).FItemName %></p>
											<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
												<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem and cEventItem.FCategoryPrdList(intI).IsCouponItem Then %>
													<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr %>]</span></p>
												<% elseif cEventItem.FCategoryPrdList(intI).IsSaleItem then %>
													<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %>원 <span class="cRd1">[<% = cEventItem.FCategoryPrdList(intI).getSalePro %>]</span></p>
												<% elseif cEventItem.FCategoryPrdList(intI).IsCouponItem then %>
													<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr %>]</span></p>
												<% end if %>
											<% Else %>
												<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %><% if cEventItem.FCategoryPrdList(intI).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
											<% End if %>
										</div>
									</a>
								</li>
							<% next %>
						</ul>
					<% end if %>
				</div>
				<% set cEventItem = nothing %>


				<%''// bed room %>
				<%
				itemlimitcnt = 10	'상품최대갯수
				eitemsort = 3		'정렬방법
				eItemListType = "1"	'격자형
				
				set cEventItem = new ClsEvtItem
				cEventItem.FECode 	= bedroomeCode
				cEventItem.FEGCode 	= 0
				cEventItem.FEItemCnt= itemlimitcnt
				cEventItem.FItemsort= eitemsort
				cEventItem.fnGetEventItem_v2
				iTotCnt = cEventItem.FTotCnt
				%>
				<div class="pdtGroup pdtGroup3">
					<h3><a href="" onclick="goEventLinktab('<%= bedroomeCode %>'); return false;" title="Bed room 상품 더보기"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69755/m/tit_bed_room.png" alt="Bed room" /></a></h3>
					<% IF (iTotCnt >= 0) THEN %>
						<ul class="pdtListV15a">
							<% For intI =0 To iTotCnt %>
								<li <% IF cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut Then %>  class="soldOut"<% end if %>>
									<% if isApp then %>
										<a href="" onclick="fnAPPpopupProduct('<% = cEventItem.FCategoryPrdList(intI).Fitemid %>'); return false;">
									<% else %>
										<a href="/category/category_itemPrd.asp?itemid=<% = cEventItem.FCategoryPrdList(intI).Fitemid %>&amp;pEtr=<%= homecafeeCode %>">
									<% end if %>
										<b class="no"><span><i><%= intI+1 %></i></span></b>
										<div class="pPhoto">
											<% IF cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut Then %>
												<p><span><em>품절</em></span></p>
											<% end if %>
											<img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false") %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" />
										</div>
										<div class="pdtCont">
											<p class="pName"><% = cEventItem.FCategoryPrdList(intI).FItemName %></p>
											<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
												<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem and cEventItem.FCategoryPrdList(intI).IsCouponItem Then %>
													<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr %>]</span></p>
												<% elseif cEventItem.FCategoryPrdList(intI).IsSaleItem then %>
													<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %>원 <span class="cRd1">[<% = cEventItem.FCategoryPrdList(intI).getSalePro %>]</span></p>
												<% elseif cEventItem.FCategoryPrdList(intI).IsCouponItem then %>
													<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr %>]</span></p>
												<% end if %>
											<% Else %>
												<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %><% if cEventItem.FCategoryPrdList(intI).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
											<% End if %>
										</div>
									</a>
								</li>
							<% next %>
						</ul>
					<% end if %>
				</div>
				<% set cEventItem = nothing %>

				<%''// dress room %>
				<%
				itemlimitcnt = 10	'상품최대갯수
				eitemsort = 3		'정렬방법
				eItemListType = "1"	'격자형

				set cEventItem = new ClsEvtItem
				cEventItem.FECode 	= dresseCode
				cEventItem.FEGCode 	= 0
				cEventItem.FEItemCnt= itemlimitcnt
				cEventItem.FItemsort= eitemsort
				cEventItem.fnGetEventItem_v2
				iTotCnt = cEventItem.FTotCnt
				%>
				<div class="pdtGroup pdtGroup4">
					<h3><a href="" onclick="goEventLinktab('<%= dresseCode %>'); return false;" title="Dress room 상품 더보기"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69755/m/tit_dress_room.png" alt="Dress room" /></a></h3>
					<% IF (iTotCnt >= 0) THEN %>
						<ul class="pdtListV15a">
							<% For intI =0 To iTotCnt %>
								<li <% IF cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut Then %>  class="soldOut"<% end if %>>
									<% if isApp then %>
										<a href="" onclick="fnAPPpopupProduct('<% = cEventItem.FCategoryPrdList(intI).Fitemid %>'); return false;">
									<% else %>
										<a href="/category/category_itemPrd.asp?itemid=<% = cEventItem.FCategoryPrdList(intI).Fitemid %>&amp;pEtr=<%= homecafeeCode %>">
									<% end if %>
										<b class="no"><span><i><%= intI+1 %></i></span></b>
										<div class="pPhoto">
											<% IF cEventItem.FCategoryPrdList(intI).IsSoldOut Or cEventItem.FCategoryPrdList(intI).isTempSoldOut Then %>
												<p><span><em>품절</em></span></p>
											<% end if %>
											<img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,400,400,"true","false") %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" />
										</div>
										<div class="pdtCont">
											<p class="pName"><% = cEventItem.FCategoryPrdList(intI).FItemName %></p>
											<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
												<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem and cEventItem.FCategoryPrdList(intI).IsCouponItem Then %>
													<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr %>]</span></p>
												<% elseif cEventItem.FCategoryPrdList(intI).IsSaleItem then %>
													<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %>원 <span class="cRd1">[<% = cEventItem.FCategoryPrdList(intI).getSalePro %>]</span></p>
												<% elseif cEventItem.FCategoryPrdList(intI).IsCouponItem then %>
													<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr %>]</span></p>
												<% end if %>
											<% Else %>
												<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %><% if cEventItem.FCategoryPrdList(intI).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
											<% End if %>
										</div>
									</a>
								</li>
							<% next %>
						</ul>
					<% end if %>
				</div>
				<% set cEventItem = nothing %>
			</section>

			<div class="relativeEvt">
				<ul>
					<li><a href="" onclick="goEventLinktab('69631'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69755/m/img_bnr_relative_01.jpg" alt="세상 어디에도 없는 셀프 웨딩 남들과 똑같은, 그런 결혼식은 싫어요 " /></a></li>
					<li><a href="" onclick="goEventLinktab('69836'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69755/m/img_bnr_relative_02.jpg" alt="두근 두근 설레이는 허니문 한번뿐인 신혼여행, 제대로 준비하세요!" /></a></li>
					<li><a href="eventmain.asp?eventid=69939"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69755/m/img_bnr_relative_03.jpg" alt="첫 인사, 예를 다하다 예단용품 신부의 첫인사를 위한 준비" /></a></li>
				</ul>
			</div>
		</article>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->