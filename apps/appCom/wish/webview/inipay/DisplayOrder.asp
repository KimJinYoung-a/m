<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbhelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_itemcouponcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_couponcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/apps/nateon/lib/nateon_alarmClass.asp"-->
<!-- #INCLUDE Virtual="/apps/kakaotalk/lib/kakaotalk_sendFunc.asp" -->
<!-- #include virtual="/apps/maxmovie/lib/maxmovie_Class.asp"-->
<!-- #include virtual="/lib/classes/ordercls/frontGiftCls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<%
'' 사이트 구분
Const sitename = "10x10"

Dim ArrOrderitemid, ArrOrderPrice, ArrOrderEa ''logger Tracking

dim userid,guestSessionID, userlevel
dim orderserial, IsSuccess

userid          = GetLoginUserID
userlevel       = GetLoginUserLevel
guestSessionID  = GetGuestSessionKey

orderserial = request.cookies("shoppingbag")("before_orderserial")
IsSuccess   = request.cookies("shoppingbag")("before_issuccess")

'' cookie is String
if LCase(CStr(IsSuccess))="true" then
    IsSuccess=true
else
    IsSuccess = false
end if


dim oorderMaster
set oorderMaster = new CMyOrder
oorderMaster.FRectOrderserial = orderserial
oorderMaster.GetOneOrder

dim oSailCoupon
set oSailCoupon = new CCoupon
oSailCoupon.FRectUserID = userid
oSailCoupon.FPageSize=100

if (userid<>"") then
	oSailCoupon.getValidCouponList
end if

dim oItemCoupon
set oItemCoupon = new CUserItemCoupon
oItemCoupon.FRectUserID = userid
oItemCoupon.FPageSize=100

if (userid<>"") then
	oItemCoupon.getValidCouponList
end if

dim oshoppingbag
set oshoppingbag = new CShoppingBag
oshoppingbag.FRectUserID = userid
oshoppingbag.FRectSessionID = guestSessionID
oShoppingBag.FRectSiteName  = sitename

dim oMileage, availtotalMile
set oMileage = new TenPoint
oMileage.FRectUserID = userid
if (userid<>"") then
    oMileage.getTotalMileage

    availtotalMile = oMileage.FTotalMileage
end if

if availtotalMile<1 then availtotalMile=0

if (userid<>"") then
    ''쿠폰 갯수/ 마일리지 쿠키 재 세팅
    Call SetLoginCouponCount(oSailCoupon.FTotalCount + oItemCoupon.FTotalCount)
    Call SetLoginCurrentMileage(availtotalMile)
end if

''비회원 주문 / 현장수령 주문인경우
if (IsSuccess) and (userid="") then
    if (oorderMaster.FOneItem.IsReceiveSiteOrder) then
        ''비회원 로그인.
        session("userid") = ""
        session("userdiv") = ""
        session("userlevel") = ""
        session("userorderserial") = orderserial
        session("username") = oorderMaster.FOneItem.Fbuyname
        session("useremail") = oorderMaster.FOneItem.Fbuyemail
    end if
end if

dim i
dim CheckRequireDetailMsg
CheckRequireDetailMsg = False

''//주문리스트 확인------신규
dim oorderDetail
set oorderDetail = new CMyOrder
oorderDetail.FRectOrderserial = orderserial
oorderDetail.GetOrderDetail

''구매금액별 선택 사은품
Dim oOpenGift
Set oOpenGift = new CopenGift
oOpenGift.FRectOrderserial = orderserial

if (IsSuccess) and (userid<>"") then
    oOpenGift.getOpenGiftInOrder
end if

'// 티켓상품정보 접수
if oorderMaster.FOneItem.IsTicketOrder then
	IF oorderDetail.FResultCount>0 then
    	Dim oticketItem, TicketDlvType, ticketPlaceName, ticketPlaceIdx

		Set oticketItem = new CTicketItem
		oticketItem.FRectItemID = oorderDetail.FItemList(0).FItemID
		oticketItem.GetOneTicketItem
		TicketDlvType = oticketItem.FOneItem.FticketDlvType			'티켓수령방법
		ticketPlaceName = oticketItem.FOneItem.FticketPlaceName		'공연장소
		ticketPlaceIdx = oticketItem.FOneItem.FticketPlaceIdx		'약도일련번호
		Set oticketItem = Nothing
	end if
end if

'네이버 스크립트 incFooter에서 출력	2013-09-09 허진원 네이버 추가
if (IsSuccess) then
	''네이버 웹로그 스크립트 생성 (cnv - 1:구매완료, 2:회원가입)
	NaverSCRIPT = "<script type='text/javascript'> " & vbCrLf &_
		"var _nasa={};" & vbCrLf &_
		"_nasa['cnv'] = wcs.cnv('1','10');" & vbCrLf &_
		"</script>"
end if
'네이버 스크립트 incFooter에서 출력 끝

'GSShop WCS 스크립트 incFooter.asp에서 출력; 2014.08.26 허진원 추가
Dim r, gswscItem
if (IsSuccess) then
    if (oorderMaster.FResultCount>0) then
        If oorderDetail.FResultCount > 0 Then
        	For r = 0 to oorderDetail.FResultCount - 1
				'GSShop WCS용
				gswscItem = gswscItem & chkIIF(gswscItem="","",", ") & "{itemId: """ & oorderDetail.FItemList(r).FItemID & """, quantity: " & oorderDetail.FItemList(r).FItemNo & ", price: " & oorderDetail.FItemList(r).FItemCost & "}"
        	Next
        End If

		if gswscItem<>"" then
			GSShopSCRIPT = "	var _wcsq = {" & vbCrLf &_
							"		pageType: ""ORDER""," & vbCrLf &_
							"		orderNum: """ & orderserial & """," & vbCrLf &_
							"		orderItemList : [" & gswscItem & "]," & vbCrLf &_
							"		totalPay: " & oorderMaster.FOneItem.FsubtotalPrice & vbCrLf &_
							"	};"
		end if
	end if
end if

%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
</head>
<body class="shop">
    <div class="wrapper order">

        <!-- #header -->
        <header id="header">
            <h1 class="page-title">주문완료</h1>
        </header><!-- #header -->

        <!-- #content -->
        <div id="content">
        <% if Not (IsSuccess) then %>
            <form action="">
            <div class="inner">
                <div class="order-finish t-c">
                    <img src="../img/img-sorry.png" alt="" width="50">
                    <div class="diff-10"></div>
                    <p class="x-large quotation" style="width:180px;">
                        <strong><span class="red">결제실패</span> 하였습니다.</strong>
                    </p>
                    <p class="diff-10"></p>
                    <p class="small t-c">
                        실패 사유를 확인하신 후, 다시 결재해 주세요.
                    </p>
                </div>
                <div class="diff"></div>
                
                <div class="main-title">
                    <h1 class="title"><span class="label">결제정보 확인</span></h1>
                </div>
                <table class="plain">
                    <tr>
                        <th>실패사유</th>
                        <td><%= oorderMaster.FOneItem.FResultmsg %></td>
                    </tr>
                </table>
            </div>
            <div class="form-actions highlight">
                <button class="btn type-a full-size" onClick="location.href='/apps/appCom/wish/webview/inipay/ShoppingBag.asp'">다시 결제하기</button>
            </div>
            </form>
        <% else %>
            <form action="">
            <div class="inner">
                <div class="order-finish t-c">
                    <img src="../img/icon-large-love.png" alt="" width="80">
                    <div class="diff-10"></div>
                    <p class="x-large"><strong class="red">감사합니다.</strong></p>
                    <div class="diff-10"></div>
                    <p>주문이 정상적으로 완료되었습니다.<br>다른상품도 좀더 보고 가세요~ ^^<br>
                    <strong class="red">주문번호 : <%= orderserial %></strong></p>
                </div>
                <!--
                <div class="diff"></div>
                <button type="button" onClick="" class="btn type-a full-size">쇼핑 계속하기</button>
                //-->
                <div class="diff"></div>
                <div class="main-title">
                    <h1 class="title"><span class="label">결제정보 확인</span></h1>
                </div>
                <table class="plain">
                    <tr>
                        <th>결제방법</th>
                        <td><%= oorderMaster.FOneItem.GetAccountdivName %></td>
                    </tr>
                    <tr>
                        <th>주문일시</th>
                        <td><%= oorderMaster.FOneItem.FRegDate %></td>
                    </tr>
                    <tr>
                        <th>총 결제금액</th>
                        <td><%= FormatNumber(oorderMaster.FOneItem.FsubtotalPrice,0) %>원</td>
                    </tr>
                </table>
                <a href="#" class="bordered-title show-toggle-box" target="#orderedProductList">주문리스트 확인 <small class="red">총 <%=oorderDetail.FResultCount%>개 / <%= FormatNumber(oorderMaster.FOneItem.FsubtotalPrice,0) %>원</small> <i class="icon-arrow-up-down absolute-right"></i></a>
                <div class="diff-10"></div>
                <!-- ordered-product-list -->
                <ul class="ordered-product-list" id="orderedProductList">
					<% for i=0 to oorderDetail.FResultCount - 1 %>
					<%
					ArrOrderitemid = ArrOrderitemid & oorderDetail.FItemList(i).FItemID & ";"
					ArrOrderPrice  = ArrOrderPrice & oorderDetail.FItemList(i).FItemCost & ";"
					ArrOrderEa     = ArrOrderEa & oorderDetail.FItemList(i).FItemNo & ";"

					%>
                    <li class="bordered-box filled">
                        <div class="product-info gutter">
                            <div class="product-img">
                                <img src="<%= oorderDetail.FItemList(i).FImageList %>" alt="<%= oorderDetail.FItemList(i).FItemName %>">
                            </div>
                            <div class="product-spec">
                                <p class="product-brand">[<%= oorderDetail.FItemList(i).Fbrandname %>] </p>
                                <p class="product-name"><%= oorderDetail.FItemList(i).FItemName %></p>
                                <p class="product-option">
								<% if oorderDetail.FItemList(i).FItemOptionName<>"" then %>
		                        옵션 : <%= oorderDetail.FItemList(i).FItemOptionName %>
		                        <% end if %>
                                </p>
                            </div>
                            <div class="price">
                                <strong><%= FormatNumber(oorderDetail.FItemList(i).FItemCost*oorderDetail.FItemList(i).FItemNo,0) %> <%= CHKIIF(oorderDetail.FItemList(i).IsMileShopSangpum,"Pt","원") %></strong>원
                            </div>
                        </div>
                    </li>
					<% next %>
                </ul><!-- ordered-product-list -->                    

                <div class="diff"></div>

                <!-- client info -->
                <div class="main-title">
                    <h1 class="title"><span class="label">주문고객 정보 확인</span></h1>
                </div>
                <table class="plain">
                    <tr>
                        <th>주문자명</th>
                        <td><%= oorderMaster.FOneItem.FBuyName %></td>
                    </tr>
                    <tr>
                        <th>이메일</th>
                        <td><%= oorderMaster.FOneItem.FBuyEmail %></td>
                    </tr>
                    <tr>
                        <th>휴대전화</th>
                        <td><%= oorderMaster.FOneItem.FBuyhp %></td>
                    </tr>
                    <tr>
                        <th>전화번호</th>
                        <td><%= oorderMaster.FOneItem.FBuyPhone %></td>
                    </tr>
                </table><!-- client info -->
                
                <div class="diff"></div>

                <!-- receiver info -->
                <% if (oorderMaster.FOneItem.IsForeignDeliver) then %>
                <div class="main-title">
                    <h1 class="title"><span class="label">해외 배송지 정보 확인</span></h1>
                </div>
                <table class="plain">
                    <tr>
                        <th>국가선택</th>
                        <td><%= oorderMaster.FOneItem.FDlvcountryName %></td>
                    </tr>                        
                    <tr>
                        <th>Name</th>
                        <td><%= oorderMaster.FOneItem.FReqName %></td>
                    </tr>
                    <tr>
                        <th>E-Mail</th>
                        <td><%= oorderMaster.FOneItem.FReqEmail %></td>
                    </tr>
                    <tr>
                        <th>Tel.No</th>
                        <td><%= oorderMaster.FOneItem.FReqPhone %></td>
                    </tr>
                    <tr>
                        <th>Zip code</th>
                        <td><%= oorderMaster.FOneItem.FemsZipCode %></td>
                    </tr>
                    <tr>
                        <th>AddRess</th>
                        <td><%= oorderMaster.FOneItem.Freqaddress %></td>
                    </tr>
                    <tr>
                        <th>City/State</th>
                        <td><%= oorderMaster.FOneItem.Freqzipaddr %></td>
                    </tr>
                </table>
                <% elseif oorderMaster.FOneItem.IsReceiveSiteOrder or (oorderMaster.FOneItem.IsTicketOrder and TicketDlvType="1") then %>
                <div class="main-title">
                    <h1 class="title"><span class="label">수령 정보 확인</span></h1>
                </div>
                <table class="plain">
                    <tr>
                        <th>수령인 성함</th>
                        <td><%= oorderMaster.FOneItem.FReqName %></td>
                    </tr>                        
                    <tr>
                        <th>휴대전화</th>
                        <td><%= oorderMaster.FOneItem.FReqHp %></td>
                    </tr>
                    <tr>
                        <th>전화번호</th>
                        <td><%= oorderMaster.FOneItem.FReqPhone %></td>
                    </tr>

					<% if oorderMaster.FOneItem.IsReceiveSiteOrder then %>
						<tr>
							<th>수령방법</th>
							<td>현장 수령</td>
						</tr>
					<% end if %>
                </table>
                <% else %>
                <div class="main-title">
                    <h1 class="title"><span class="label">배송지 정보 확인</span></h1>
                </div>
                <table class="plain">
                    <tr>
                        <th>수령인 성함</th>
                        <td><%= oorderMaster.FOneItem.FReqName %></td>
                    </tr>                        
                    <tr>
                        <th>휴대전화</th>
                        <td><%= oorderMaster.FOneItem.FReqHp %></td>
                    </tr>
                    <tr>
                        <th>전화번호</th>
                        <td><%= oorderMaster.FOneItem.FReqPhone %></td>
                    </tr>
                    <tr>
                        <th>주소</th>
                        <td>[<%= oorderMaster.FOneItem.FreqzipCode %>]<br><%= oorderMaster.FOneItem.Freqzipaddr %> <%= oorderMaster.FOneItem.Freqaddress %></td>
                    </tr>
                    <tr>
                        <th>배송유의사항</th>
                        <td><%
							If nl2Br(oorderMaster.FOneItem.Fcomment) = "" Then
								Response.Write "&nbsp;"
							Else
								Response.Write nl2Br(oorderMaster.FOneItem.Fcomment)
							End If
						%></td>
                    </tr>
                </table>
                <% end if %>
                
            </div>
			<div class="form-actions highlight"> 
                <button type="button" class="btn type-a full-size" onclick="return callgotoday()" style="margin-left:0;width:300px;">쇼핑 계속하기</button>
            </div>
            </form>
		<%
		end if
		%>
		
		<%
		'//이벤트 배너 '/2014-09-05 한용민 추가
		if date>="2014-09-10" and date<"2014-10-01" then
		%>
			<div class="tMar40">
				<p><a href="/event/eventmain.asp?eventid=54792"><img src="http://imgstatic.10x10.co.kr/offshop/temp/2014/201409/order_after_m.jpg" alt="" style="width:100%;" /></a></p>
			</div>
		<% end if %>

        </div><!-- #content -->
		<%
		if (IsSuccess) then
			oshoppingbag.ClearShoppingbag
			dim CartCnt : CartCnt = getDBCartCount
			SetCartCount(CartCnt)

			if CheckRequireDetailMsg then
				response.write "<script>alert('주문제작 문구가 정확히 입력되셨는지 다시한번 확인해 주시기 바랍니다.\n문구를 수정하시려면 내용수정 버튼을 클릭하신후 수정 가능합니다.');</script>"
			end if
		end if

		'//네이트온 결제알림(166) 확인 및 발송(입금확인시에만 발송)
		if (IsSuccess) and (oorderMaster.FOneItem.IsPayed) then
			on error resume next
			Call NateonAlarmCheckMsgSend(userid,166,orderserial)
			on error goto 0
		end if

		'//카카오톡 결제알림 확인 및 발송(발송 DB에 있는경우만 발송)
		if (IsSuccess) then
			on error resume next
			Call fnKakaoChkSendMsg(orderserial)
			on error goto 0
		end if

		'//맥스무비 정보 저장(이벤트 기간: 2009-09-25~2009-11-25)
		'if (IsSuccess) and (request.cookies("rdsite")="maxmovie") then
		'	on error resume next
		'	Call MaxmovieSavePara(userid,orderserial,request.cookies("rddata"))
		'	on error goto 0
		'end if
		%>
		
        <footer id="footer">
        </footer>
    </div>

	<!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>
			
<%
set oorderDetail   = nothing
Set oOpenGift = Nothing

set oMileage    = Nothing
set oSailCoupon = Nothing
set oItemCoupon = Nothing
set oshoppingbag = Nothing
set oorderMaster = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->