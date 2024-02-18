<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
'	Description : 비트윈 주문/배송조회 API
'	History	:  2015.05.08 한용민 API용으로 변경/생성
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/commFunc_api.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/ordercls/sp_myordercls.asp" -->
<%
dim lp, page, pflag, aflag, cflag, PageSize
	pflag = requestCheckvar(request("pflag"),10)
	aflag = requestCheckvar(request("aflag"),2)
	cflag = requestCheckvar(request("cflag"),2)
	page = getNumeric(requestCheckvar(request("page"),9))

if (page="") then page = 1
PageSize=5

if usersn="" then
	response.write "<script type='text/javascript'>alert('고객번호가 없습니다.');</script>"
	dbget.close()	:	response.end
end if

dim myorder
set myorder = new CMyOrder
	myorder.FPageSize = PageSize
	myorder.FCurrpage = page
	myorder.FRectusersn = usersn
	myorder.FRectSiteName = "10x10"
	myorder.FRectrdsite = "betweenshop"
	myorder.FRectbeadaldiv = 8
	myorder.FRectArea = aflag			'/주문배송조회 옵션 / 배송전체 "" / 배송전체 "KR" / 해외배송 "AB"
	myorder.FRectOldjumun = pflag		'/조회기간 / 15일 H / 1개월 M / 3개월 T / 6개월 "" / 6개월이전 P

	if (pflag="H") then		'15일
		myorder.FRectStartDate = FormatDateTime(DateAdd("d",-15,now()),2)
		myorder.FRectEndDate = FormatDateTime(now(),2)
	elseif (pflag="M") then		'1개월
		myorder.FRectStartDate = FormatDateTime(DateAdd("m",-1,now()),2)
		myorder.FRectEndDate = FormatDateTime(now(),2)
	elseif (pflag="T") then		'3개월
		myorder.FRectStartDate = FormatDateTime(DateAdd("m",-3,now()),2)
		myorder.FRectEndDate = FormatDateTime(now(),2)
	end if
	
	myorder.GetMyOrderListProc

%>

<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
<script type="text/javascript">
var ppage = 1;
var maxpage = 100;
    
function paging_ajax(){
	var chkItem = 0;

    // 1페이지일경우 2페이지로 변경
    if( $("#frmODSearch input[name='page']").val()=="1" ){
    	$("#frmODSearch input[name='page']").val(2);
    }
	//페이지가 같은경우 리턴시킴.. 이중클릭방지
    if ( ppage==$("#frmODSearch input[name='page']").val() ) {
    	return;
    }
	if ( $("#frmODSearch input[name='page']").val() > <%= myorder.FtotalPage %>){
		alert('페이지의 끝입니다');
		return;
	}
	//맥스 페이지값
    if (ppage>maxpage) {
    	alert('END OF PAGE');
    	return;
    }

	var str = $.ajax({
			type: "GET",
	        url: "/apps/appCom/between/my10x10API/order/myorderlist_ajax.asp",
	        data: "page="+$("#frmODSearch input[name='page']").val(),
	        dataType: "text",
	        async: false
	}).responseText;
	//alert( str );
	if(str!="") {
		$('#lySearchResult').append(str);
		ppage=$("#frmODSearch input[name='page']").val();
		
		//현재 페이지와 총페이지가 같다면 버튼 숨긴다.
		if ( ppage == <%= myorder.FtotalPage %>){
			$('.listAddBtn').hide();
		}
		//다음 열릴 페이지 셋팅
		var pg = $("#frmODSearch input[name='page']").val();
		pg++;
		$("#frmODSearch input[name='page']").val(pg);
    }
}

</script>

</head>
<body>
<% 'for dev msg : 원뎁스별 해당 ID 추가(비트윈추천:btwRcmd/카테고리:btwCtgy/마이페이지:btwMypage) %>
<div class="wrapper" id="btwMypage">
	<div id="content">
		<% '<!-- #include virtual="/apps/appCom/between/lib/inc/incHeader.asp" --> %>
		<div class="cont">
			<!-- 주문/배송조회 -->
			<div class="hWrap hrBlk">
				<h1 class="headingA">주문/배송조회</h1>
			</div>
			<form name="frmODSearch" id="frmODSearch" method="get" onSubmit="return false;" style="margin:0px;">
			<input type="hidden" name="page" value=1>
			</form>
			<div class="orderDelivery">

				<% if myorder.FResultCount > 0 then %>
					<ul class="refundGuide">
						<li><strong class="txtBtwDk">상품교환 및 반품/환불</strong>을 하고자 하시는 경우, 텐바이텐 고객행복센터(<a href="tel:16446030" class="txtBlk">1644-6030</a>)로 문의 주시기 바랍니다.</li>
						<li><strong class="txtBtwDk">주문제작상품의 특성상 제작이 들어간 경우, 주문 취소 및 반품/환불이 불가능 할 수 있습니다.</strong></li>
					</ul>

					<ul class="myOdrList" id="lySearchResult">
						<% '5개씩 페이징 %>
						<% for i = 0 to (myorder.FResultCount - 1) %>
						<li>
							<div class="odrInfo">
								<a href="/apps/appCom/between/my10x10API/order/myorderdetail.asp?idx=<%= myorder.FItemList(i).FOrderSerial %>&pflag=<%= pflag %>&cflag=<%= cflag %>">
								<p class="date"><%= Left(CStr(myorder.FItemList(i).Fregdate),10) %></p>
								<p>
									주문번호 
									<strong class="odrNum">
										<%= myorder.FItemList(i).FOrderSerial %>
									</strong>
									<span class="bar">|</span>

									<% ' for dev msg : 주문접수,결제완료의 경우 클래스 txtBlk / 주문통보,상품준비중,일부출고,출고완료의 경우 클래스 txtSaleRed %>
	                                <% if (myorder.FItemList(i).FCancelyn<>"N") then %>
                                        취소주문
                                    <% else %>
                                    	<strong class="<%=myorder.FItemList(i).GetIpkumDivCSS%>"><%=myorder.FItemList(i).GetIpkumDivName%></strong>
                                    <% end if %>
								</p>
								<p class="pdtName">
									<%=myorder.FItemList(i).GetItemNames%>
								</p>
								<p class="price"><%=FormatNumber(myorder.FItemList(i).FSubTotalPrice,0)%>원</p>
								</a>
							</div>
							<div class="btnCont">
		                    	<% if (myorder.FItemList(i).IsWebOrderCancelEnable) then %>
		                    		<span class="btn02 cnclGry"><a href="/apps/appCom/between/my10x10API/order/myorderallcancel.asp?idx=<%= myorder.FItemList(i).FOrderSerial %>">주문취소</a></span>
		                    	<% end if %>
                            	<% if (myorder.FItemList(i).IsWebOrderInfoEditEnable) then %>
                            		<span class="btn02 cnclGry"><a href="/apps/appCom/between/my10x10API/order/myorderchangeaddr.asp?orderserial=<%= myorder.FItemList(i).FOrderSerial %>">배송지변경</a></span>
		                    	<% end if %>
								<% if (myorder.FItemList(i).IsWebOrderReturnEnable) then %>
		                    		<!--반품접수-->
		                    	<% end if %>
							</div>
						</li>
						<% next %>
					</ul>
					<% If myorder.FTotalpage > 1 Then  %>
					<div class="listAddBtn">
						<a href="" onclick="paging_ajax(); return false;">더 보기</a>
					</div>
					<% End If %>
				<% else %>
					<div class="noData orderNoData">
						<p>
							<strong>주문내역이 없습니다.</strong>
							<% '더 다양한 상품을 만나보세요 :) %>
						</p>
						<!--<div class="btnArea">
							<span class="btn02 btw btnBig"><a href="/apps/appCom/between/index.asp">비트윈 추천 보러가기</a></span>
						</div>-->
					</div>
				<% end if %>
			</div>
			<!--// 주문/배송조회 -->
		</div>
	</div>
	<% '<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" --> %>
</div>
</body>
</html>
<%
set myorder=nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->