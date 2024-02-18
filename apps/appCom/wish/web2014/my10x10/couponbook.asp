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
<!-- #include virtual="/apps/appCom/wish/web2014/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_couponcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_itemcouponcls.asp" -->
<%
dim vtempbounscouponyn : vtempbounscouponyn="N"
dim userid, selTabs
userid = getEncLoginUserID

dim osailcoupon
set osailcoupon = new CCoupon
osailcoupon.FRectUserID = userid
osailcoupon.FPageSize=100
osailcoupon.FGubun = "mweb" '모바일웹용 쿠폰(일반+모바일) / monly:모바일+app,mweb:모바일웹용,mapp:APP쿠폰만

selTabs = RequestCheckVar(Request("tab"),2)

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
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
	<script>
		function PopItemCouponAssginList(iidx){
			fnAPPpopupBrowserURL('쿠폰 적용상품','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/Pop_CouponItemList.asp?itemcouponidx=' + iidx);
	//		location.href = "/apps/appCom/wish/web2014/my10x10/Pop_CouponItemList.asp?itemcouponidx=" + iidx + "";
		}

		$(function(){
			$(".tabContent").hide();
			$(".tabContainer").find(".tabContent:first").show();
			 
			$(".tabNav li").click(function() {
				$(this).siblings("li").removeClass("current");
				$(this).addClass("current");
				$(this).closest(".tabNav").nextAll(".tabContainer:first").find(".tabContent").hide();
				var activeTab = $(this).find("a").attr("href");
				$(activeTab).show();
				return false;
			});

			// 쿠폰수 재 세팅
			fnAPPsetMyCouponNum(<%=osailcoupon.FTotalCount + oitemcoupon.FTotalCount + osailcoupon_app.FTotalCount%>);

			fnAPPchangPopCaption('쿠폰북');
			<% If selTabs="2" then %>
				$(".tabNav.tNum3 li:nth-child(1)").removeClass("current");
				$(".tabNav.tNum3 li:nth-child(2)").addClass("current");
				$(".tabContainer").find(".tabContent").eq(1).show();
				$(".tabContainer").find(".tabContent:first").hide();
			<% ElseIf selTabs="3" then %>
				$(".tabNav.tNum3 li:nth-child(1)").removeClass("current");
				$(".tabNav.tNum3 li:nth-child(3)").addClass("current");
				$(".tabContainer").find(".tabContent:last").show();
				$(".tabContainer").find(".tabContent:first").hide();
			<% end if %>

		});
	</script>
</head>
<body class="default-font body-sub">
<% 	'// 전면 배너 5월 가정의달 쿠폰
	If now() > #06/04/2018 00:00:00# And now() < #06/05/2018 23:59:59# then
%>
<% server.Execute("/event/etc/layerbanner/mkt_coupon_banner.asp") %>
<% End If %>
	<!-- contents -->
	<div id="content" class="content couponBook">
<!-- 		<div class="cpBookBnrV15"> -->
<!-- 			<span class="tit">텐바이텐 쿠폰북</span> -->
<!-- 			<a href="" onclick="fnAPPpopupBrowserURL('쿠폰북','<%=wwwUrl%>/apps/appCom/wish/web2014/shoppingtoday/couponshop.asp');return false;" class="btn-more">더 많은 쿠폰 다운받으러 가기</a> -->
<!-- 		</div> -->
		<div class="cpNoti">
			<ul>
				<li>오프라인 및 텐바이텐 제휴사에서 받은 쿠폰번호를 입력하시면 사용쿠폰을 알려드립니다.</li>
				<li>쿠폰 사용기준과 기간을 반드시 확인하여 주세요. (사용된 쿠폰은 주문 취소 후 재발급 불가)</li>
			</ul>
			<p class="ct tMar15"><span class="button btB1 btRed cWh1 w70p"><a href="" onclick="fnAPPpopupBrowserURL('쿠폰 발급','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/changecoupon.asp');return false;">쿠폰 번호 입력하기</a></span></p>
		</div>

		<% ' 18주년 세일 기간 동안 마이텐바이텐을 통하지 않고 내쿠폰함에 들어온 경우에만 배너 노출
		'If date() > "2019-09-25" AND date() < "2019-10-01" Then 
		If date() > "2019-09-30" AND date() < "2019-10-14" Then
			If Instr(Request.ServerVariables("HTTP_REFERER"), "my10x10") = 0 Then %>
				<div class="bnr18th">
				<% If isapp = "1" Then %>																			
					<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_couponbook_coupon_banner','','', function(bool){if(bool) {fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97448');return false;}});" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bnr_18th_mycp.png" alt="뽑기에 성공하면 아이패드가 100원?!"></a>
				<% Else %>
					<a href="/event/eventmain.asp?eventid=97449"  onclick="fnAmplitudeEventMultiPropertiesAction('click_couponbook_coupon_banner','','',);" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bnr_18th_mycp.png" alt="뽑기에 성공하면 아이패드가 100원?!"></a>
				<% End If %>
				</div>
		<%	End if
		End if %>

		<%If date() > "2019-10-13" AND date() < "2019-11-01" Then
				If Instr(Request.ServerVariables("HTTP_REFERER"), "my10x10") = 0 Then %>
				<div class="bnr18th">
				<% If isapp = "1" Then %>
					<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_couponbook_coupon_banner','','', function(bool){if(bool) {fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97806');return false;}});" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bnr_18th_mycp2.png" alt="비밀번호 풀면 마샬 스피커를 드려요!"></a>
				<% Else %>
					<a href="/event/eventmain.asp?eventid=97805"  onclick="fnAmplitudeEventMultiPropertiesAction('click_couponbook_coupon_banner','','',);" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bnr_18th_mycp2.png" alt="비밀번호 풀면 마샬 스피커를 드려요!"></a>
				<% End If %>
				</div>
		<%	End if
		End if %>


		<div class="bgSlash">
			<div class="cpTab">
				<ul class="tabNav tNum3">					
					<li class="current"><a href="#pdtCoupon">상품쿠폰<span>(<%= oitemcoupon.FTotalCount %>)</span></a></li>
					<li><a href="#bonusCoupon">보너스쿠폰<span>(<%= osailcoupon.FTotalCount %>)</span></a></li>
					<li><a href="#mobileCoupon">APP쿠폰<span>(<%= osailcoupon_app.FTotalCount %>)</span></a></li>
				</ul>
				<div class="tabContainer">
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
											<p><span class="button btM2 btRedBdr cRd1 bgWht w100p"><a href="" onclick="fnAPPpopupBrowserURL('쿠폰 적용상품','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/Pop_CouponItemList.asp?itemcouponidx=<%= oitemcoupon.FItemList(i).FitemcouponIdx %>');return false;">적용상품보기<em class="moreArr"></em></a></span></p>
										</div>
									</li>
								<% Next %>

							<% End If %>
						</ul>
					</div>
					<!--// 상품쿠폰 -->

					<!-- 보너스쿠폰 -->
					<div id="bonusCoupon" class="tabContent">
						<ul class="couponList">
							<% If (osailcoupon.FResultCount < 1) Then %>
								<%' 쿠폰 없을 경우 %>
								<li class="nodata nodata-default"><p>사용 가능한 보너스 쿠폰이 없습니다.</p></li>
								<%'// 쿠폰 없을 경우 %>
							<% Else %>
								<% 
									dim evtCouponStr, isEvtCoupon
									For i=0 To osailcoupon.FResultCount-1 
										evtCouponStr = ""
										isEvtCoupon = false
										if osailcoupon.FItemList(i).fmasteridx = 1147 or osailcoupon.FItemList(i).fmasteridx = 1148 or osailcoupon.FItemList(i).fmasteridx = 1149 or osailcoupon.FItemList(i).fmasteridx = 1150 then
											isEvtCoupon = true
										end if
										if isEvtCoupon then
											evtCouponStr = "<em class=""tag"">이벤트</em>"
										end if					
								%>
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
										<div class="cpWrap <%=CHKIIF(isEvtCoupon,"surprise-cp","")%>">
											<div class="cpCont">
												<p class="t01"><%= osailcoupon.FItemList(i).getCouponTypeStr %></p>
												<p class="t02"><%=evtCouponStr%><%= osailcoupon.FItemList(i).Fcouponname %></p>
												<p class="t03"><%= osailcoupon.FItemList(i).getAvailDateStr %></p>
												<p class="terms">
													<%= chkIIF(osailcoupon.FItemList(i).getMiniumBuyPriceStr="","",osailcoupon.FItemList(i).getMiniumBuyPriceStr & " ") %>

													<% if vtempbounscouponyn="Y" then %>
														앱쇼상품전용
													<% else %>
														<% if osailcoupon.FItemList(i).fmasteridx <> 126 then '// 생일 쿠폰 제외 %>
															<%= osailcoupon.FItemList(i).getValidTargetStr %>
														<% end if %>
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

					<!-- 모바일쿠폰 -->
					<div id="mobileCoupon" class="tabContent">
						<ul class="couponList">
							<% If (osailcoupon_app.FResultCount < 1) Then %>
								<%' 쿠폰 없을 경우 %>
								<li class="nodata nodata-default"><p>사용 가능한 모바일 쿠폰이 없습니다.</p></li>
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
										<!--div class="btnWrap">
											<p><span class="button btM2 btRedBdr cRd1 bgWht w100p"><a href="#">적용상품보기<em class="moreArr"></em></a></span></p>
										</div>-->
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
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
	<script>
		$(function(){
			fnAPPchangPopCaption("쿠폰북");
		});
	</script>
</body>
</html>
<%
set osailcoupon = Nothing
set osailcoupon_app = Nothing
set oitemcoupon = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->