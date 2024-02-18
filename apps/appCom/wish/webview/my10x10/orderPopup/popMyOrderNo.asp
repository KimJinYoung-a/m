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
''로그인 한 경우만 가능 ( 주문번호 로그인은 불가)
dim userid
userid = GetLoginUserID()

dim frmname, targetname
frmname     = request("frmname")
targetname  = request("targetname")

Dim page	: page = req("page",1)

dim myorderList
set myorderList = new CMyOrder
myorderList.FRectUserID = userid
myorderList.FPageSize = 4
myorderList.FCurrpage = page

if IsUserLoginOK() then
    myorderList.GetMyOrderList
end if

dim i
%>
<script>
function jsGoPage(iP){ //페이지 이동
	$.ajax({
		url: "/apps/appcom/wish/webview/my10x10/orderPopup/popMyOrderNo.asp?frmname=<%=frmname%>&targetname=<%=targetname%>&page="+iP,
		cache: false,
		success: function(message) {
			var vList = $(message).find(".inner").html();
			$("#orderList").empty().html(vList);
			$(".iscroll-area").css("-webkit-transform","translate(0px, 0px)");
		}
	});
	return false;
}

function RetOrderSerial(orderserial){
	var frm = eval('<%= frmname %>');
	frm.orderserial.value = orderserial;
	frm.itemid.value = "";

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
            <h1 class="modal-title">주문내역</h1>
            <a href="#" class="btn-close">&times;</a>
        </header>
        <div class="modal-body">
            <div class="iscroll-area">
                <div class="well type-b">
                    최근 6개월간 고객님의 주문내역입니다. <br>상담을 원하시는 주문번호/상품명을 선택해 주세요. 
                </div>
                
                <div id="orderList" class="inner">
                    <ul class="order-list">
						<% if myorderList.FResultCount < 1 then %>
						<li class="bordered-box">검색된 주문내역이 없습니다.</li>
						<% else %>
						<% for i = 0 to (myorderList.FResultCount - 1) %>
                        <li class="bordered-box">
                            <a href="javascript:RetOrderSerial('<%= myorderList.FItemList(i).FOrderSerial %>');" class="box-meta">
                                <span class="date"><%= formatdate(CStr(myorderList.FItemList(i).Fregdate),"0000.00.00") %></span>
                                <span class="box-title">주문번호(<%= myorderList.FItemList(i).FOrderSerial %>)</span>
                            </a>
                            <div class="product-info gutter">
                                <strong class="order-status red pull-left"><%= myorderList.FItemList(i).GetIpkumDivName %></strong>
                                <div class="clear"></div>                            
                                <div class="product-spec">
                                    <p class="product-name"><%= myorderList.FItemList(i).GetItemNames %></p>
                                </div>
                                <div class="price">
                                    <strong><%= FormatNumber(myorderList.FItemList(i).FSubTotalPrice,0) %></strong>원 
                                </div>
                            </div>
                        </li>
						<% next %>
						<% end if %>
                    </ul>
	                <div class="clear"></div>
					<%= fnDisplayPaging_New(page, myorderList.FtotalCount, myorderList.FPageSize, 4,"jsGoPage") %>
	                <div class="diff"></div>
                </div>
			</div>
        </div>
        
    </div>
</div>
<%
	set myorderList = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->