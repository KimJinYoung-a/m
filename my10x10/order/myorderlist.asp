<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"

'####################################################
' Description : 마이텐바이텐 - 주문배송조회
' History : 2014-08-29 이종화 생성
'####################################################
%>
<!-- #include virtual="/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/cscenter/cancelOrderLib.asp" -->
<%
'해더 타이틀
strHeadTitleName = "주문배송조회"

dim i, j, lp
dim page
dim pflag, aflag
dim iniRentalInfoData, tmpRentalInfoData, iniRentalMonthLength, iniRentalMonthPrice '// 이니렌탈 관련 변수
pflag = requestCheckvar(request("pflag"),10)
aflag = requestCheckvar(request("aflag"),2)
page = requestCheckvar(request("page"),9)
if (page="") then page = 1

dim userid
userid = getEncLoginUserID()


dim myorder
set myorder = new CMyOrder

myorder.FPageSize = 10
myorder.FCurrpage = page
myorder.FRectUserID = userid
myorder.FRectSiteName = "10x10"
myorder.FRectOldjumun = pflag

If aflag = "XX" Then
	if IsUserLoginOK() then
	    myorder.GetMyCancelOrderList
	elseif IsGuestLoginOK() then
	    myorder.FRectOrderserial = GetGuestLoginOrderserial()
	    myorder.GetMyCancelOrderList
	end if
Else
	myorder.FRectArea = aflag

	if IsUserLoginOK() then
	    myorder.GetMyOrderList
	elseif IsGuestLoginOK() then
	    myorder.FRectOrderserial = GetGuestLoginOrderserial()
	    myorder.GetMyOrderList
	end if
End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<meta name="format-detection" content="telephone=no" />
<title>10x10: 주문배송조회</title>
<script type='text/javascript'>
function goPage(pg){
	var frm = document.frmsearch;
	frm.page.value=pg;
	frm.submit();
}
function goLink(page,pflag,aflag){
    location.href="?page=" + page + "&pflag=" + pflag + "&aflag=" + aflag;
}
</script>
</head>
<body class="default-font body-sub body-1depth">
	<form name="frmsearch" method="post" action="myorderlist.asp" style="margin:0px;">
	<input type="hidden" name="pflag" value="<%=pflag%>">
	<input type="hidden" name="aflag" value="<%=aflag%>">
	<input type="hidden" name="page" value="1">
	</form>
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<div id="content" class="content">
		<div class="nav nav-stripe nav-stripe-default nav-stripe-red">
			<ul class="grid2">
				<li><a href="#" class="on">온라인 주문</a></li>
				<li><a href="/my10x10/order/myshoporderlist.asp">매장 주문</a></li>
			</ul>
		</div>
		<div class="myOrderMain">
			<div class="myTenNoti">
				<!--<h2 class="tit01">주문배송조회</h2>-->
				<ul>
					<li>최근 6개월간 고객님의 주문내역입니다. 6개월 이전 내역은 PC에서 조회하실 수 있습니다.</li>
					<li>상품 교환이나 일부 취소는 1:1 상담으로 문의해주시기 바랍니다.</li>
				</ul>
				<span class="button btS1 btnRed1V16a cRd1V16a btn-qna"><a href="/my10x10/qna/myqnawrite.asp">1:1 상담 작성하기</a></span>
			</div>

			<!-- 배송공지 20181128 -->
			<!--<div class="notiV18 notiDelivery" style="margin:-1.2rem .85rem 1.2rem;">
				<h3>배송지연 안내</h3>
				<div class="textarea">
					<p>
						CJ대한통운의 회사 사정으로 인해<br/>
						일부 지역의 배송이 원활하지 않습니다.<br/>
						배송 불가 또는 지연 시 별도 안내해 드리겠습니다.<br/>
					</p>
					<p><em>배송지연 지역</em><br/>광주, 경남(창원/거제/김해), 울산, 경기, 대구, 경북, 충북 등 일부 지역</p>
				</div>
			</div>-->

			<div class="sortingbar tPad0" style="height:auto;">
				<div class="option-right">
					<div class="styled-selectbox styled-selectbox-default">
						<select class="select" name="aflag" title="카테고리 선택옵션" onChange="goLink(1,'<%=pflag%>',this.value);return false;">
							<option selected="selected" value=""<%=chkIIF(aflag=""," selected","")%>>전체주문</option>
							<option value="KR"<%=chkIIF(aflag="KR"," selected","")%>>일반주문</option>
							<option value="AB"<%=chkIIF(aflag="AB"," selected","")%>>해외배송주문</option>
							<option value="XX"<%=chkIIF(aflag="XX"," selected","")%>>취소주문</option>
						</select>
					</div>
				</div>
			</div>
			<% if myorder.FResultCount > 0 then %>
				<ul class="myOdrList">
					<% for i = 0 to (myorder.FResultCount - 1) %>
						<li>
							<a href="/my10x10/order/myorderdetail.asp?idx=<%= myorder.FItemList(i).FOrderSerial %>&pflag=<%= pflag %>">
								<div class="odrInfo">
									<p><%= formatdate(myorder.FItemList(i).Fregdate,"0000.00.00") %></p>
									<p>주문번호(<%= myorder.FItemList(i).FOrderSerial %>)</p>
								</div>
								<div class="odrCont">
									<p class="type">
										<span class="<%=myorder.FItemList(i).GetIpkumDivColor%>">[<%=chkIIF(myorder.FItemList(i).FCancelyn<>"N","취소주문",myorder.FItemList(i).GetIpkumDivNameNew)%><%=chkIIF(myorder.FItemList(i).IsReceiveSiteOrder,"(현장수령)","")%>]</span>
									</p>
									<p class="item"><%=myorder.FItemList(i).GetItemNames%></p>
									<% If myorder.FItemList(i).Faccountdiv="150" Then %>
										<%
											iniRentalInfoData = fnGetIniRentalOrderInfo(myorder.FItemList(i).FOrderSerial)
											If instr(lcase(iniRentalInfoData),"|") > 0 Then
												tmpRentalInfoData = split(iniRentalInfoData,"|")
												iniRentalMonthLength = tmpRentalInfoData(0)
												iniRentalMonthPrice = tmpRentalInfoData(1)
											Else
												iniRentalMonthLength = ""
												iniRentalMonthPrice = ""
											End If			
										%>
										<p class="price"><%=iniRentalMonthLength%>개월간 월 <strong><%=FormatNumber(iniRentalMonthPrice,0)%></strong>원</p>
									<% Else %>
										<p class="price"><strong><%=FormatNumber(myorder.FItemList(i).FSubTotalPrice,0)%></strong>원</p>
									<% End If %>
								</div>
							</a>
							<%	if (myorder.FItemList(i).FCancelyn="N") and (myorder.FItemList(i).IsWebOrderCancelEnable or myorder.FItemList(i).IsWebStockOutItemCancelEnable) then %>
								<div class="btnCancel">
									<% if myorder.FItemList(i).IsWebStockOutItemCancelEnable and myorder.FItemList(i).FmaystockoutYN = "Y" then %>
										<% if (ChkStockoutItemExist_Proc(myorder.FItemList(i).FOrderSerial)) then %>
											<span class="button btS1 btnRed1V16a cRd1V16a"><a href="/my10x10/order/order_cancel_detail.asp?mode=so&idx=<%= myorder.FItemList(i).FOrderSerial %>">품절상품 취소</a></span>
										<% end if %>
									<% end if %>
									<% if myorder.FItemList(i).IsWebOrderCancelEnable then %>
										<span class="button btS1 btnRed1V16a cRd1V16a"><a href="/my10x10/order/order_cancel_detail.asp?idx=<%= myorder.FItemList(i).FOrderSerial %>">주문취소</a></span>
									<% end if %>
								</div>
							<% else %>
								<% if myorder.FItemList(i).IsWebOrderReturnEnable then %>
									<div class="btnCancel">
										<span class="button btS1 btnRed1V16a cRd1V16a"><a href="/my10x10/order/myorder_return_step2.asp?idx=<%= myorder.FItemList(i).FOrderSerial %>">반품접수</a></span>
										<!--span class="button btS1 btnRed1V16a cRd1V16a"><a href="/my10x10/qna/myqnawrite.asp?orderserial=<%= myorder.FItemList(i).FOrderSerial %>&qadiv=06">교환/AS문의</a></span>
										<span class="button btS1 btnRed1V16a cRd1V16a"><a href="/my10x10/qna/myqnawrite.asp?orderserial=<%= myorder.FItemList(i).FOrderSerial %>&qadiv=14">반품문의</a></span-->
									</div>
								<% end if %>							
							<%	end if %>
						</li>
					<% Next %>
				</ul>
				<%=fnDisplayPaging_New(myorder.FcurrPage,myorder.FtotalCount,myorder.FPageSize,4,"goPage")%>
			<% Else %>
				<div class="nodata-list online">
					<span class="icon icon-no-data"></span>
					<p>주문내역이 없습니다.</p>
				</div>
			<% End If %>
		</div>
	</div>
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<%
set myorder = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
