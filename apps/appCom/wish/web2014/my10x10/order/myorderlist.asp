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
	        url: "myorderlist_act.asp",
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
		<% response.write fnTestLoginLabel() '//  app 쿠키 테스트용 %>
		<div class="nav nav-stripe nav-stripe-default nav-stripe-red">
			<ul class="grid2">
				<li><a href="#" class="on">온라인 주문</a></li>
				<li><a href="/apps/appCom/wish/web2014/my10x10/order/myshoporderlist.asp">매장 주문</a></li>
			</ul>
		</div>
		<div class="myOrderMain">
			<form id="frmsearch" name="frmsearch" method="get" style="margin:0px;">
			<input type="hidden" name="page" value="1">
			<input type="hidden" name="pflag" value="<%=pflag%>">
			<input type="hidden" name="aflag" value="<%=aflag%>">
			</form>
			<div class="myTenNoti">
			<!--<h2 class="tit01">주문배송조회</h2> -->
				<ul>
					<li>최근 6개월간 고객님의 주문내역입니다. 6개월 이전 내역은 PC에서 조회하실 수 있습니다.</li>
					<li>상품 교환이나 일부 취소는 1:1 상담으로 문의해주시기 바랍니다.</li>
				</ul>
				<span class="button btS1 btnRed1V16a cRd1V16a btn-qna"><a href="#" onclick="fnAPPpopupBrowserURL('<%=CHKIIF(IsVIPUser()=True,"VIP ","")%>1:1 상담','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/qna/myqnawrite.asp'); return false;">1:1 상담 작성하기</a></span>
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
			<div class="nodata-list online" id="myordernodata" style="display:none;">
				<span class="icon icon-no-data"></span>
				<p>주문내역이 없습니다.</p>
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