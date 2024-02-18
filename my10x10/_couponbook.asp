<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description : 마이텐바이텐 - 마이쿠폰
' History : 2014-09-01 이종화 생성
'               2014-11-12 원승현 수정
'####################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_couponcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_itemcouponcls.asp" -->
<%
dim vtempbounscouponyn : vtempbounscouponyn="N"
dim userid
userid = getEncLoginUserID

strHeadTitleName = "사용가능한 쿠폰"

dim osailcoupon
set osailcoupon = new CCoupon
osailcoupon.FRectUserID = userid
osailcoupon.FPageSize=100
osailcoupon.FGubun = "mweb" '모바일웹용 쿠폰(일반+모바일) / monly:모바일+app,mweb:모바일웹용,mapp:APP쿠폰만

if userid<>"" then
    osailcoupon.getValidCouponList
end If

dim osailcoupon_app
set osailcoupon_app = new CCoupon
osailcoupon_app.FRectUserID = userid
osailcoupon_app.FPageSize=100
osailcoupon_app.FGubun = "mapp"

if userid<>"" then
    osailcoupon_app.getValidCouponList
end If

dim oitemcoupon
set oitemcoupon = new CUserItemCoupon
oitemcoupon.FRectUserID = userid

if userid<>"" then
    oitemcoupon.getValidCouponList
    
    '' 쿠키(쿠폰 갯수) 재 세팅. app 추가
    Call SetLoginCouponCount(osailcoupon.FTotalCount + oitemcoupon.FTotalCount + osailcoupon_app.FTotalCount)
end if


''## 진행중인 보너스쿠폰 이벤트 #######################
'' -> 쿠폰샵 오픈으로 필요없음 : 사용안함..
dim osailcouponmaster, IsAvailThisCoupon, IsAlreadyReceiveCoupon
set osailcouponmaster = new CCouponMaster
osailcouponmaster.FRectUserID = userid

''if userid<>"" then
''    ''전체 지급하는 발급할수 있는쿠폰을 먼저 찾고
''    osailcouponmaster.GetOneAvailCouponMaster
''    if (osailcouponmaster.FResultCount<1) then
''        ''자신에게 지급될 수 있는 쿠폰을 다음으로 찾는다.
''        osailcouponmaster.GetOneAppointmentCouponMaster
''    end if
''end if
''
''
''''FRectIdx의 쿠폰행사가 진행중일때
''if (osailcouponmaster.FResultCount>0) then
''	IsAlreadyReceiveCoupon = osailcouponmaster.CheckAlreadyReceiveCoupon(osailcouponmaster.FOneItem.Fidx, userid)
''end if
''''####################################################

dim i
%>
<!-- #include virtual="/lib/inc/head.asp" -->
	<script>
	function PopItemCouponAssginList(iidx){
		location.href = "/my10x10/Pop_CouponItemList.asp?itemcouponidx=" + iidx + "";
	}


	</script>
</head>
<body class="default-font body-sub">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<!-- contents -->
	<div id="content" class="content couponBook">
<!-- 		<div class="cpBookBnrV15"> -->
<!-- 			<span class="tit">텐바이텐 쿠폰북</span> -->
<!-- 			<a href="/shoppingtoday/couponshop.asp" class="btn-more">더 많은 쿠폰 다운받으러 가기</a> -->
<!-- 		</div> -->
		<div class="cpNoti">
			<h2 class="tit01">나의 쿠폰</h2>
			<ul>
				<li>오프라인 및 텐바이텐 제휴사에서 받은 쿠폰번호를 입력하시면 사용쿠폰을 알려드립니다.</li>
				<li>쿠폰 사용기준과 기간을 반드시 확인하여 주세요. (사용된 쿠폰은 주문 취소 후 재발급 불가)</li>
			</ul>
			<p class="ct tMar15"><span class="button btB1 btRed cWh1 w70p"><a href="/my10x10/changecoupon.asp">쿠폰 번호 입력하기</a></span></p>
		</div>
		<div class="bgSlash">
			<div class="cpTab">
				<ul class="tabNav tNum3">
					<li class="current"><a href="#bonusCoupon">보너스쿠폰<span>(<%= osailcoupon.FTotalCount %>)</span></a></li>
					<li><a href="#pdtCoupon">상품쿠폰<span>(<%= oitemcoupon.FTotalCount %>)</span></a></li>
					<li><a href="#mobileCoupon">모바일쿠폰<span>(<%= osailcoupon_app.FTotalCount %>)</span></a></li>
				</ul>
				<div class="tabContainer">

					<!-- 보너스쿠폰 -->
					<div id="bonusCoupon" class="tabContent">
						<ul class="couponList">
							<% If (osailcoupon.FResultCount < 1) Then %>
								<%' 쿠폰 없을 경우 %>
								<li class="nodata nodata-default"><p>사용 가능한 보너스쿠폰이 없습니다.</p></li>
								<%'// 쿠폰 없을 경우 %>
							<% Else %>
								<% For i=0 To osailcoupon.FResultCount-1 %>
								<%
								'//특정 쿠폰 쿠폰설명 고정		'/2014.10.07 한용민 생성
								vtempbounscouponyn="N"
								IF application("Svr_Info")="Dev" THEN
									if osailcoupon.FItemList(i).fmasteridx=357 or osailcoupon.FItemList(i).fmasteridx=358 or osailcoupon.FItemList(i).fmasteridx=359 or osailcoupon.FItemList(i).fmasteridx=360 or osailcoupon.FItemList(i).fmasteridx=361 or osailcoupon.FItemList(i).fmasteridx=362 or osailcoupon.FItemList(i).fmasteridx=363 or osailcoupon.FItemList(i).fmasteridx=364 or osailcoupon.FItemList(i).fmasteridx=365 or osailcoupon.FItemList(i).fmasteridx=366 or osailcoupon.FItemList(i).fmasteridx=367 then
										vtempbounscouponyn="Y"
									end if
								ELSE
									if osailcoupon.FItemList(i).fmasteridx=644 or osailcoupon.FItemList(i).fmasteridx=645 or osailcoupon.FItemList(i).fmasteridx=646 or osailcoupon.FItemList(i).fmasteridx=647 or osailcoupon.FItemList(i).fmasteridx=648 or osailcoupon.FItemList(i).fmasteridx=649 or osailcoupon.FItemList(i).fmasteridx=650 or osailcoupon.FItemList(i).fmasteridx=651 or osailcoupon.FItemList(i).fmasteridx=652 or osailcoupon.FItemList(i).fmasteridx=653 or osailcoupon.FItemList(i).fmasteridx=654 then
										vtempbounscouponyn="Y"
									end if
								END IF
								%>
									<li>
										<div class="cpWrap">
											<div class="cpCont">
												<p class="t01"><%= osailcoupon.FItemList(i).getCouponTypeStr %></p>
												<p class="t02"><%= osailcoupon.FItemList(i).Fcouponname %></p>
												<p class="t03"><%= osailcoupon.FItemList(i).getAvailDateStr %></p>
												<p class="terms">
													<%= chkIIF(osailcoupon.FItemList(i).getMiniumBuyPriceStr="","",osailcoupon.FItemList(i).getMiniumBuyPriceStr & " ") %>

													<% if vtempbounscouponyn="Y" then %>
														앱쇼상품전용
													<% else %>
														<%= osailcoupon.FItemList(i).getValidTargetStr %>
													<% end if %>
												</p>
											</div>
										</div>
									</li>
								<% Next %>
							<% End If %>
						</ul>
					</div>
					<!--// 보너스쿠폰 -->

					<!-- 상품쿠폰 -->
					<div id="pdtCoupon" class="tabContent">
						<ul class="couponList">
							<% If (oitemcoupon.FResultCount < 1) Then %>
								<%' 쿠폰 없을 경우 %>
								<li class="nodata nodata-default"><p>사용 가능한 보너스쿠폰이 없습니다.</p></li>
								<%'// 쿠폰 없을 경우 %>
							<% Else %>
								<% For i=0 To oitemcoupon.FResultCount-1 %>
									<li>
										<div class="cpWrap">
											<div class="cpCont">
												<p class="t01"><%=oitemcoupon.FItemList(i).GetDiscountStr %></p>
												<p class="t02"><%=oitemcoupon.FItemList(i).Fitemcouponname %></p>
												<p class="t03"><%=oitemcoupon.FItemList(i).getAvailDateStr %></p>
											</div>
										</div>
										<div class="btnWrap">
											<p><span class="button btM2 btRedBdr cRd1 bgWht w100p"><a href="#" onclick="PopItemCouponAssginList('<%= oitemcoupon.FItemList(i).FitemcouponIdx %>');">적용상품보기<em class="moreArr"></em></a></span></p>
										</div>
									</li>
								<% Next %>

							<% End If %>
						</ul>
					</div>
					<!--// 상품쿠폰 -->



					<!-- 모바일쿠폰 -->
					<div id="mobileCoupon" class="tabContent">
						<ul class="couponList">
							<% If (osailcoupon_app.FResultCount < 1) Then %>
								<%' 쿠폰 없을 경우 %>
								<li class="nodata nodata-default"><p>사용 가능한 보너스쿠폰이 없습니다.</p></li>
								<%'// 쿠폰 없을 경우 %>
							<% Else %>
								<% For i=0 To osailcoupon_app.FResultCount-1 %>
									<li>
										<div class="cpWrap">
											<div class="cpCont">
												<p class="t01"><%= osailcoupon_app.FItemList(i).getCouponTypeStr %></p>
												<p class="t02"><%= osailcoupon_app.FItemList(i).Fcouponname %></p>
												<p class="t03"><%= osailcoupon_app.FItemList(i).getAvailDateStr %></p>
												<p class="terms"><%= chkIIF(osailcoupon_app.FItemList(i).getMiniumBuyPriceStr="","",osailcoupon_app.FItemList(i).getMiniumBuyPriceStr & "<br>") & osailcoupon_app.FItemList(i).getValidTargetStr %></p>
											</div>
										</div>
										<div class="btnWrap">
											<p><span class="button btM2 btRedBdr cRd1 bgWht w100p"><a href="#">적용상품보기<em class="moreArr"></em></a></span></p>
										</div>
									</li>
								<% Next %>
							<% End If %>
						</ul>
					</div>
					<!--// 모바일쿠폰 -->
				</div>
			</div>
		</div>
	</div>
	<!-- //contents -->
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<%
set osailcoupon = Nothing
set osailcoupon_app = Nothing
set oitemcoupon = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->