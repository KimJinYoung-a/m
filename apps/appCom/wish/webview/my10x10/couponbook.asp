<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/apps/appcom/wish/webview/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_couponcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_itemcouponcls.asp" -->
<%
dim userid
Dim tab
userid = GetLoginUserID

tab = requestCheckVar(request("tab"),1)

If tab = "" Then tab = "i"

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
    
    '' 쿠키(쿠폰 갯수) 재 세팅.
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

strPageTitle = "생활감성채널, 텐바이텐 > 쿠폰/보너스쿠폰"
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<script type='text/javascript'>
	function PopItemCouponAssginList(iidx){
		location.href = "Pop_CouponItemList.asp?itemcouponidx=" + iidx + "";
	}
	</script>
</head>
<body class="mypage">
    <!-- wrapper -->
    <div class="wrapper myinfo">
        <!-- #content -->
        <div id="content">
            <div class="inner">
                <div class="diff"></div>
                <div class="main-title">
                    <h1 class="title"><span class="label">쿠폰</span></h1>
                </div>
            </div>
            <div class="well type-b type-cp">
                <ul class="txt-list">
                    <li>오프라인 및 텐바이텐 제휴사에서 받은 쿠폰번호를 입력하시면 사용쿠폰을 알려드립니다.</li>
                    <li>쿠폰 사용기준과 기간을 반드시 확인하여 주세요. (사용된 쿠폰은 주문 취소 후 재발급 불가)</li>
                </ul>
                <a href="/apps/appcom/wish/webview/my10x10/changecoupon.asp" class="btn-down-all"><span>쿠폰<br>발급받기</span></a>
            </div>
            <div class="diff"></div>

            <div class="inner">
                <div class="tabs type-c three">
                    <a href="couponbook.asp?tab=i" class="<%=chkiif(tab="i","active","")%>">상품쿠폰 (<%= oitemcoupon.FTotalCount %>)</a>
                    <a href="couponbook.asp?tab=b" class="<%=chkiif(tab="b","active","")%>">보너스쿠폰 (<%= osailcoupon.FTotalCount %>)</a>
                    <a href="couponbook.asp?tab=a" class="<%=chkiif(tab="a","active","")%>">모바일쿠폰 (<%= osailcoupon_app.FTotalCount %>)</a>
                </div>
                <div class="diff"></div>
				<% If tab = "i" Then %>      
				<% If (oitemcoupon.FResultCount < 1) Then %>
				<div class="coupon-list" style="display:<%=chkiif(tab="i","block","none")%>;">
					<p class="t-c" style="padding:30px 0">사용가능한 쿠폰이 없습니다.</p>
				</div>
				<% Else %>
				<ul class="coupon-list" style="display:<%=chkiif(tab="i","block","none")%>;">
				<% For i=0 To oitemcoupon.FResultCount-1 %>
					<li class="coupon-box">
						<div class="gutter">
							<p class="amount green">
								<strong class="green"><%= oitemcoupon.FItemList(i).GetDiscountStr %></strong>
							</p>
							<p class="desc">
								<%= oitemcoupon.FItemList(i).Fitemcouponname %>
							</p>
							<p class="period">
								유효기간 : <%= oitemcoupon.FItemList(i).getAvailDateStr %>
							</p>
						</div>
						<div class="condition">
								<button class="btn type-e small" style="width:120px;" onclick="PopItemCouponAssginList('<%= oitemcoupon.FItemList(i).FitemcouponIdx %>');">적용상품보기</button>
						</div>
					</li>
				<% Next %>
				</ul>
				<% End If %>
				<% End If %>
				<% If tab = "b" Then %>
				<% If (osailcoupon.FResultCount < 1) Then %>
				<div class="coupon-list" style="display:<%=chkiif(tab="b","block","none")%>;"> 
					<p class="t-c" style="padding:30px 0">사용가능한 보너스쿠폰이 없습니다.</p>
				</div>
				<% Else %>
				<ul class="coupon-list" style="display:<%=chkiif(tab="b","block","none")%>;"> 
				<% For i=0 To osailcoupon.FResultCount-1 %>
					<li class="coupon-box">
                        <div class="gutter">
                            <p class="amount">
                                <strong><%= osailcoupon.FItemList(i).getCouponTypeStr %></strong>
                            </p>
                            <p class="desc">
                                <%= osailcoupon.FItemList(i).Fcouponname %>
                            </p>
                            <p class="period">
                                유효기간 : <%= osailcoupon.FItemList(i).getAvailDateStr %>
                            </p>
                        </div>
                        <div class="condition">
                            사용조건 : <%= chkIIF(osailcoupon.FItemList(i).getMiniumBuyPriceStr="","",osailcoupon.FItemList(i).getMiniumBuyPriceStr & "<br>") & osailcoupon.FItemList(i).getValidTargetStr %>
                        </div>
                    </li>
				<% Next %>
				</ul>
				<% End If %>
				<% End If %>
				<% If tab = "a" Then %>
				<% If (osailcoupon_app.FResultCount < 1) Then %>
				<div class="coupon-list" style="display:<%=chkiif(tab="a","block","none")%>;"> 
					<p class="t-c" style="padding:30px 0">사용가능한 모바일쿠폰이 없습니다.</p>
				</div>
				<% Else %>
				<ul class="coupon-list" style="display:<%=chkiif(tab="a","block","none")%>;"> 
				<% For i=0 To osailcoupon_app.FResultCount-1 %>
					<li class="coupon-box">
                        <div class="gutter">
                            <p class="amount">
                                <strong><%= osailcoupon_app.FItemList(i).getCouponTypeStr %></strong>
                            </p>
                            <p class="desc">
                                <%= osailcoupon_app.FItemList(i).Fcouponname %>
                            </p>
                            <p class="period">
                                유효기간 : <%= osailcoupon_app.FItemList(i).getAvailDateStr %>
                            </p>
                        </div>
                        <div class="condition">
                            사용조건 : <%= chkIIF(osailcoupon_app.FItemList(i).getMiniumBuyPriceStr="","",osailcoupon_app.FItemList(i).getMiniumBuyPriceStr & "<br>") & osailcoupon_app.FItemList(i).getValidTargetStr %>
                        </div>
                    </li>
				<% Next %>
				</ul>
				<% End If %>
				<% End If %>
            </div>
			
        </div><!-- #content -->

        <!-- #footer -->
        <footer id="footer">
            
        </footer><!-- #footer -->
        
    </div><!-- wrapper -->

	<!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>
<%
set osailcoupon = Nothing
set osailcoupon_app = Nothing
set oitemcoupon = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->