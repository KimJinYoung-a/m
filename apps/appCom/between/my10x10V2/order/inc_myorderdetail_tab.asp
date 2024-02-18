<%
'###########################################################
' Description :  비트윈 주문/배송조회
' History : 2014.04.23 한용민 생성
'###########################################################
%>
<div class="hWrap hrBlk">
	<h1 class="headingA">주문/배송 상세내역</h1>
	<div class="option">
		<strong class="orderNo">[주문번호 <%= orderserial %>]</strong>
	</div>
</div>
<ul class="orderTab">
	<li class="order01 <% if GetFileName()="myorderdetail" then response.write "current" %>"><a href="/apps/appCom/between/my10x10V2/order/myorderdetail.asp?idx=<%=orderserial%>">주문상품</a></li>
	<li class="order02 <% if GetFileName()="myorderdetail_info" then response.write "current" %>"><a href="/apps/appCom/between/my10x10V2/order/myorderdetail_info.asp?idx=<%=orderserial%>">구매자</a></li>
	<li class="order03 <% if GetFileName()="myorderdetail_mtd" then response.write "current" %>"><a href="/apps/appCom/between/my10x10V2/order/myorderdetail_mtd.asp?idx=<%=orderserial%>">결제</a></li>
	<li class="order04 <% if GetFileName()="myorderdetail_addr" then response.write "current" %>"><a href="/apps/appCom/between/my10x10V2/order/myorderdetail_addr.asp?idx=<%=orderserial%>">배송지</a></li>
</ul>