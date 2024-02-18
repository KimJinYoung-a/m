<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
'Response.AddHeader "Cache-Control","no-cache"
'Response.AddHeader "Expires","0"
'Response.AddHeader "Pragma","no-cache"
response.Charset="UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbCTopen.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/mainCls.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/noticefaqCls.asp" -->
<%
Dim cMainItem, vSort, vPage, vTopCount2, vPage2
vSort = requestCheckVar(Request("vSort"),100)
If vSort = "" Then vSort = "N"
vPage	= 1
vPage2	= 1
vTopCount2 = 10

'// 공지사항 신규갯수 파악
Dim cNoti
if session("WeekNotiCnt")="" then
	SET cNoti = New CNoticeFaq
		session("WeekNotiCnt") = cNoti.getNoticeCnt
	SET cNoti = nothing
end if
%>
<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
<script>
$(function() {
	var mySwiper = new Swiper('.bnrExhibit .swiper-container',{
		//initialSlide:Math.floor((Math.random()*3)+1),
		pagination:'.pagination',
		paginationClickable:true,
		loop:true,
		resizeReInit:true,
		calculateHeight:true
	});
	$('.listWrap .pdtList').hide();
	$('.listWrap .pdtList:first').show();

	// 탭클릭
	$('.tab h2').click(function() {
		var tabView = $(this).attr('name');
		if(tabView == 'newList'){
			$("#lastView").val('N');
			if($("#newitem li").length==0) {
				jsProjectItemList('N');
			} else {
				$('.tab h2').removeClass('current');
				$(".listWrap .pdtList").hide();
				$('.tab h2').eq(0).addClass('current');
				$("#newList").show();
			}
		}else if(tabView == 'bestList'){
			$("#lastView").val('B');
			if($("#bestitem li").length==0) {
				jsProjectItemList('B');
			} else {
				$('.tab h2').removeClass('current');
				$(".listWrap .pdtList").hide();
				$('.tab h2').eq(1).addClass('current');
				$("#bestList").show();
			}
		}
	});

	// 첫페이지 로딩
	jsProjectItemList($("#lastView").val());
});
</script>
<script type="text/javascript">
var tabPg1=0, tabPg2=0

function jsProjectItemList(tp){
	if(tp=="N") {
		tabPg1++;
	} else {
		tabPg2++;
	}
	var pcnt = tabPg1;
	var pcnt2 = tabPg2;

	$.ajax({
		url: "mainItem_ajax.asp?sort="+tp+"&page="+pcnt+"&page2="+pcnt2,
		cache: false,
		success: function(message)
		{
			$('.tab h2').removeClass('current');
			$(".listWrap .pdtList").hide();

			if(tp == 'N'){
				$("#newitem").append(message);
				$('.tab h2').eq(0).addClass('current');
				$("#newList").show();
				if(pcnt>=3) $("#newbtn").hide();
			}else{
				if(pcnt2>1) {
					$("#bestitem").append(message);
				}
				$('.tab h2').eq(1).addClass('current');
				$("#bestList").show();
				if(pcnt2>=3) $("#bestbtn").hide();
			}
		}
	});
}
</script>
</head>
<body>
<div class="wrapper" id="btwRcmd">
	<div id="content">
		<h1 class="noView">비트윈추천</h1>
		<!-- #include virtual="/apps/appCom/between/lib/inc/incHeader.asp" -->
		<div class="cont">
			<div class="target<%= Chkiif(fnGetUserInfo("sex") = "M", "M", "F") %> typeA">
				<%
					if date>="2014-05-12" then
						server.Execute("/apps/appCom/between/chtml/loader/maintopbanner.asp")
					end if
				%>
				<div class="bnrExhibit">
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<% server.Execute("/apps/appCom/between/chtml/loader/main3banner.asp") %>
						</div>
						<div class="pagination"></div>
					</div>
				</div>
				<div class="mdPick">
					<h2><strong><%= Chkiif(fnGetUserInfo("sex") <> "M", "남자", "여자") %>마음</strong>을 잘 아는 <strong>MD’s Pick!</strong></h2>
					<ul class="pdtList list01 boxMdl">
						<%
							server.Execute("/apps/appCom/between/chtml/loader/inc_Newmain3mdpick.asp")
						%>
					</ul>
					<span class="moreBtn"><a href="/apps/appCom/between/project/?pjt_code=<%= Chkiif(fnGetUserInfo("sex") = "M", "7", "8") %>">더보기</a></span>
				</div>
			</div>
			<div class="listWrap boxMdl">
				<div class="tab">
					<h2 class="col2" name="newList">NEW</h2>
					<h2 class="col2 current" name="bestList">BEST</h2>
				</div>
				<div class="pdtList" id="newList">
					<ul class="list02 newList" id="newitem"></ul>
					<div class="listAddBtn" id="newbtn">
						<input type="hidden" name="pagecnt" id="pagecnt" value="1">
						<a href="javascript:" onClick="jsProjectItemList('N');">상품 더 보기</a>
					</div>
				</div>
				<div class="pdtList" id="bestList">
					<ul class="list02 bestList" id="bestitem"><% sbMainBestItemList %></ul>
					<div class="listAddBtn" id="bestbtn">
						<% If (Now() > #02/02/2015 00:00:00# AND Now() < #02/13/2015 23:59:59#) Then %>
						<input type="hidden" id="lastView" value="N">
						<% Else %>
						<input type="hidden" id="lastView" value="B">
						<% End If %>
						<a href="javascript:" onClick="jsProjectItemList('B');">상품 더 보기</a>
					</div>
				</div>
			</div>
			<p class="svcNoti">비트윈의 기프트샵(이하 기프트샵)은 "텐바이텐"의 상품 판매를 중개하는 서비스 입니다. 기프트샵을 통한 "텐바이텐"의 상품판매와 관련하여 비트윈은 통신판매 중개자로서 통신판매의 당사자가 아니며, 상품주문, 배송 및 환불의 의무와 책임은 "텐바이텐"에게 있습니다.</p>
		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbCTclose.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->