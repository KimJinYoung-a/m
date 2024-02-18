<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/apps/appcom/wish/web2014/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appcom/wish/web2014/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/apps/appCom/wish/protoV2/protoV2Function.asp"-->
<%
dim i, j, lp
dim page
dim pflag, aflag
pflag = requestCheckvar(request("pflag"),10)
aflag = requestCheckvar(request("aflag"),2)
page = requestCheckvar(request("page"),9)
if (page="") then page = 1

dim userid
userid = getEncLoginUserID()

strPageTitle = "생활감성채널, 텐바이텐 > 주문배송조회"
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type="text/javascript">
var isloading=true;
$(function(){
	//첫페이지 접수
	getList();

	//스크롤 이벤트 시작
	$(window).scroll(function() {
      if ($(window).scrollTop() >= $(document).height() - $(window).height() - 350){
          if (isloading==false){
            isloading=true;
			var pg = $("#frmsearch input[name='page']").val();
			pg++;
			$("#frmsearch input[name='page']").val(pg);
            setTimeout("getList()",500);
          }
      }
    });
});

function getList() {
	var str = $.ajax({
			type: "GET",
	        url: "myshoporderlist_act.asp",
	        data: $("#frmsearch").serialize(),
	        dataType: "text",
	        async: false
	}).responseText;

	if(str!="") {
    	if($("#frmsearch input[name='page']").val()=="1") {
        	$('#lySearchResult').html(str);
        } else {
       		$('#lySearchResult').append(str);
        }
        isloading=false;
    } else {
    	//더이상 자료가 없다면 스크롤 이벤트 종료
    	$(window).unbind("scroll");
    }
}

function goMyOrderList(p,a){
	$('input[name="page"]').val("1");
	$('input[name="pflag"]').val(p);
	$('input[name="aflag"]').val(a);
	//frmsearch.submit();
	document.location.replace('?page=1&pflag='+p+'&aflag='+a); // 히스토리 관련
}

$( document ).ready(function() {
<%
response.write "setTimeout(""fnAPPchangPopCaption('주문배송조회')"",200);"

if (request("rsflag")="on") then
    if (IsUserLoginOK) then
        response.write "fnAPPsetOrderNum('"&getRecentOrderCount(getEncLoginUserID)&"');"
    elseif (IsGuestLoginOK) then
        response.write "fnAPPsetOrderNum('"&getRecentOrderCountGuest(GetGuestLoginOrderserial)&"');"
    else
        response.write "fnAPPsetOrderNum('0');"
    end if
    ''2014/12/08
    response.write "setTimeout(""fnAPPhideLeftBtns()"",500);"
end if
%>
});

function goLink(page,pflag,aflag){
	document.location.replace('?page=1&pflag='+pflag+'&aflag='+aflag); // 히스토리 관련
}
</script>
</head>
<body class="default-font body-sub body-1depth">
	<!-- contents -->
	<div id="content" class="content">
		<div class="nav nav-stripe nav-stripe-default nav-stripe-red">
			<ul class="grid2">
				<li><a href="/apps/appCom/wish/web2014/my10x10/order/myorderlist.asp">온라인 주문</a></li>
				<li><a href="#" class="on">매장 주문</a></li>
			</ul>
		</div>
		<div class="myOrderMain">
			<form id="frmsearch" name="frmsearch" method="get" style="margin:0px;">
			<input type="hidden" name="page" value="1">
			<input type="hidden" name="pflag" value="<%=pflag%>">
			<input type="hidden" name="aflag" value="<%=aflag%>">
			</form>
			<div class="myTenNoti">
				<ul>
					<li>최근 6개월간 오프라인 주문건별 구매 내역 정보입니다. 주문번호를 탭하시면 상세조회를 하실 수 있습니다.</li>
					<li>오프라인 주문 정보는 일별로 매장 마감한 상품 기준으로 갱신됩니다.</li>
					<li>오프라인 상품의 할인, 가격 정보는 매장별 정책에 따라 온라인 상품 정보와 상이할 수 있습니다.</li>
					<li>오프라인 구매 상품의 교환 및 환불 신청은 구매 매장에 문의 부탁드립니다.</li>
				</ul>
			</div>
			<div class="nodata-list default-font" id="myordernodata" style="display:none;">
				<div class="nodata">
					<h2>주문내역이 없습니다.</h2>
					<p>매장 결제시 텐바이텐 멤버십카드를 제시하시면<br/><em>구매 금액의 3%를 매장 마일리지로 적립</em>해드립니다.</p>
					<p>※ 멤버십카드는 [마이텐바이텐] 메뉴에서 확인 가능</p>
				</div>
				<div class="thumb"><img src="http://fiximage.10x10.co.kr/m/2018/my10x10/img_my_ten_app.png" alt=""></div>
			</div>

			<ul class="myOdrList">
				<div id="lySearchResult"></div>
			</ul>
		</div>
	</div>
	<!-- contents -->
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->