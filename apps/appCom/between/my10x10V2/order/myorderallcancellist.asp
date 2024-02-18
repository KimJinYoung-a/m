<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.Charset="UTF-8"
%>
<%
'###########################################################
' Description :  비트윈 취소 / 교환 / 반품 <pc-web 내가 신청한 서비스 항목>
' History : 2014.04.25 이종화 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/ordercls/cs_aslistcls.asp" -->
<%
	dim i,lp
	dim page

	page = requestCheckvar(request("page"), 32)
	if (page="") then page = 1

	dim userid
	userid = fnGetUserInfo("tenSn")

	dim mycslist
	set mycslist = new CCSASList

	mycslist.FPageSize = 5
	mycslist.FCurrpage = page
	mycslist.FRectUserID = userid

	dim orderSerial	: orderSerial = requestCheckvar(req("orderSerial",""), 11)

	mycslist.FRectOrderserial = orderserial
	mycslist.GetCSASMasterList

	dim currstatecolor
	dim popJsName
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
	if ( $("#frmODSearch input[name='page']").val() > <%= mycslist.FtotalPage %>){
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
	        url: "/apps/appCom/between/my10x10V2/order/myorderallcancellist_ajax.asp",
	        data: "page="+$("#frmODSearch input[name='page']").val(),
	        dataType: "text",
	        async: false
	}).responseText;
	if(str!="") {
		$('#lySearchResult').append(str);
		ppage=$("#frmODSearch input[name='page']").val();
		
		//현재 페이지와 총페이지가 같다면 버튼 숨긴다.
		if ( ppage == <%= mycslist.FtotalPage %>){
			$('.listAddBtn').hide();
		}
		//다음 열릴 페이지 셋팅
		var pg = $("#frmODSearch input[name='page']").val();
		pg++;
		$("#frmODSearch input[name='page']").val(pg);
    }
}

function jsordercanceldetail(idx) {
	var url = "/apps/appCom/between/my10x10V2/order/myorderallcanceldetail.asp?CsAsID="+idx;
	location.href = url;
}

</script>
</head>
<body>
<div class="wrapper" id="btwMypage"><!-- for dev msg : 원뎁스별 해당 ID 추가(비트윈추천:btwRcmd/카테고리:btwCtgy/마이페이지:btwMypage) -->
	<div id="content">
		<!-- include virtual="/apps/appCom/between/lib/inc/incHeader.asp" -->
		<div class="cont">
			<div class="hWrap hrBlk">
				<h1 class="headingA">취소/교환/반품</h1>
			</div>
			<form name="frmODSearch" id="frmODSearch" method="get" onSubmit="return false;" style="margin:0px;">
			<input type="hidden" name="page" value=1>
			</form>
			<div class="cancelList">
				<div id="lySearchResult">
				<%
				if mycslist.FResultCount > 0 then
					for i = 0 to (mycslist.FResultCount - 1)
				%>
					<div class="cancel">
						<a href="javascript:jsordercanceldetail('<%=mycslist.FItemList(i).Fid%>');">
							<div class="orderNo">
								<span>주문번호 <strong class="txtBtwDk"><%= mycslist.FItemList(i).Forderserial %></strong></span>
								<span>접수 : <%= Replace(Left(mycslist.FItemList(i).Fregdate, 10), "-", "/") %></span>
							</div>
							<p class="progress">
								<strong><span><%= mycslist.FItemList(i).FdivcdName %></span> l <% if (mycslist.FItemList(i).Fcurrstate = "B007") and Not IsNull(mycslist.FItemList(i).Ffinishdate) then %><span class="txtSaleRed">완료 (<%= Replace(Left(mycslist.FItemList(i).Ffinishdate, 10), "-", "/") %>)</span><% else %><span class="txtBlk">진행중</span><% End If %></strong>
							</p>
							<p class="demand"><%= mycslist.FItemList(i).Fopentitle %></p>
						</a>
					</div>
				<%
					Next
				%>
				</div>
				<div class="listAddBtn">
					<a href="" onclick="paging_ajax(); return false;">더 보기</a>
				</div>
				<%
				else
				%>
				<div class="noData">
					<p>
						<strong>취소/교환/반품 내역이 없습니다.</strong>
						<% '더 다양한 상품을 만나보세요 :) %>
					</p>

					<% '<div class="btnArea"><span class="btn02 btw btnBig"><a href="/apps/appCom/between/index.asp">비트윈 추천 보러가기</a></span></div> %>
				</div>
				<%
				End If 
				%>
			</div>
		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
<%
	set mycslist = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->