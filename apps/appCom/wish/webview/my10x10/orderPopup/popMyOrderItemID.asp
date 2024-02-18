<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<% const MenuSelect = "03" %>
<!-- #include virtual="/apps/appcom/wish/webview/login/checkUserGuestLogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/webview/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/lib/util/pageformlib.asp" -->
<%
dim i

''로그인 한 경우만 가능 ( 주문번호 로그인은 불가)
dim userid
userid = GetLoginUserID()

dim frmname, targetname
frmname     = request("frmname")
targetname  = request("targetname")

Dim page	: page = req("page",1)

Dim orderSerial
if IsUserLoginOK() then
	orderSerial	= req("orderSerial","")
elseif IsGuestLoginOK() then
	orderSerial	= GetGuestLoginOrderserial()
end if

dim myorderdetail
set myorderdetail = new CMyOrder

If orderSerial <> "" Then 
	myorderdetail.FRectOrderserial = orderserial
	myorderdetail.GetOrderDetail
ElseIf GetLoginUserID() <> "" Then 
	myorderdetail.FPageSize = 5
	myorderdetail.FCurrpage = page
	myorderdetail.GetMyOrderItemList
Else 
	response.write "<script>" & vbCrLf
	response.write "alert('잘못된 호출입니다.');" & vbCrLf
	response.write "window.close();" & vbCrLf
	response.write "</script>" & vbCrLf
	Set myorderdetail	= Nothing 
	dbget.close()	:	response.End 
End If 
%>
<script>
function jsGoPage(iP){ //페이지 이동
	$.ajax({
		url: "/apps/appcom/wish/webview/my10x10/orderPopup/popMyOrderItemID.asp?frmname=<%=frmname%>&targetname=<%=targetname%>&orderserial=<%=orderSerial%>&page="+iP,
		cache: false,
		success: function(message) {
			var vList = $(message).find(".inner").html();
			$("#orderList").empty().html(vList);
			$(".iscroll-area").css("-webkit-transform","translate(0px, 0px)");
		}
	});
	return false;
}

function RetItemID(orderSerial, itemid) {
	var comp = eval('<%= frmname %>.<%= targetname %>');
	var frm = eval('<%= frmname %>');
	frm.orderserial.value = orderSerial;
	comp.value = itemid;

	$("#modalCont").fadeOut(function(){
		$(this).empty();
	});
	$('body').css({'overflow':'auto'});
	clearInterval(loop);
	loop = null;
}
</script>
<div class="modal">
    <div class="box no-footer">
        <header class="modal-header">
            <h1 class="modal-title">상품내역</h1>
            <a href="#" class="btn-close">&times;</a>
        </header>
        <div class="modal-body">
            <div class="iscroll-area">
                <div class="well type-b">
                    최근 2개월간 고객님의 주문내역입니다. <br>상담을 원하시는 주문번호/상품명을 선택해 주세요. 
                </div>
                
                <div id="orderList" class="inner">
                    <ul class="product-list">
						<% if myorderdetail.FResultCount < 1 then %>
                        <li class="bordered-box">주문한 상품내역이 없습니다.</li>
						<% Else %>
						<% for i = 0 to (myorderdetail.FResultCount - 1) %>
						<li class="bordered-box"  onclick="RetItemID('<%= myorderdetail.FItemList(i).ForderSerial %>', '<%= myorderdetail.FItemList(i).FItemid %>');"> 
                            <div class="product-info gutter">
                                <div class="product-img">
                                    <img src="<%=myorderdetail.FItemList(i).FImageList%>" alt="<%= myorderdetail.FItemList(i).FItemName %>">
                                </div>
                                <strong class="order-info red">주문번호  <%= myorderdetail.FItemList(i).ForderSerial %><br>상품코드  <%= myorderdetail.FItemList(i).FItemid %> </strong>                        
                                <div class="product-spec">
                                    <p class="product-name"><%= myorderdetail.FItemList(i).FItemName %></p>
                                </div>
                                <div class="price">
                                    <strong><%= FormatNumber(myorderdetail.FItemList(i).FItemCost,0) %></strong>원
                                </div>
                            </div>
                        </li>
						<% next %>
						<% End If %>
                    </ul>
	                <div class="clear"></div>
					<%= fnDisplayPaging_New(page, myorderdetail.FtotalCount, myorderdetail.FPageSize, 5,"jsGoPage") %>
	                <div class="diff"></div>
                </div>
			</div>
        </div>
    </div>
</div>
<%
	set myorderdetail = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->