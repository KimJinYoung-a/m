<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.Charset="UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/mainCls.asp" -->
<%
Dim cMainItem, vSort, vPage, vTopCount, vPage2
vSort = requestCheckVar(Request("vSort"),100)
If vSort = "" Then vSort = "N"
vPage	= 1
vPage2	= 1
vTopCount = 10
%>
<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
<script>
$(function() {
	$("#bestbtn").hide();
	var mySwiper = new Swiper('.bnrExhibit .swiper-container',{
		pagination:'.pagination',
		paginationClickable:true,
		loop:true,
		resizeReInit:true,
		calculateHeight:true
	});
	$('.listWrap .pdtList').hide();
	$('.listWrap .pdtList:first').show();

	$('.tab h2').click(function() {
		//$('.tab h2').removeClass('current');
		//$(this).addClass('current');
		var tabView = $(this).attr('name');
		if(tabView == 'newList'){
			jsProjectItemList2('N',$("#pagecnt").val(),$("#pagecnt2").val());
			
			//jsProjectItemList('N', 'N');
			//$("#newbtn").show();
			//$("#bestbtn").hide();
			//if($("#pagecnt").val() >= 3){
			//	$("#newbtn").hide();
			//}

		}else if(tabView == 'bestList'){
			jsProjectItemList2('B',$("#pagecnt").val(),$("#pagecnt2").val());

			//jsProjectItemList('B', 'N');
			//$("#bestbtn").show();
			//$("#newbtn").hide();
			//if($("#pagecnt2").val() >= 3){
			//	$("#bestbtn").hide();
			//}
		}
		//$(".listWrap .pdtList").hide();
		//$(".listWrap div[id|='"+ tabView +"']").show();
	});

	// 첫페이지 로딩
	if(!$("#newitem").is("li")) {
		$("#pagecnt").val(1);
		$("#pagecnt2").val(1);
		$("#firstok").val('N');
		jsProjectItemList2($("#lastView").val(),0,0);
	}
});
</script>
<script type="text/javascript">
function jsProjectItemList(tp, pageyn){
	var pcnt = $("#pagecnt").val();
	var pcnt2 = $("#pagecnt2").val();
	var firok = $("#firstok").val();
	$("#lastView").val(tp);

	if(pageyn == 'Y' && tp == 'N'){
		pcnt = parseInt(pcnt)+1;
	}else if(pageyn == 'Y' && tp == 'B'){
		pcnt2 = parseInt(pcnt2)+1;
	}

	$.ajax({
		url: "mainItem_ajax.asp?sort="+tp+"&page="+pcnt+"&page2="+pcnt2,
		cache: false,
		success: function(message)
		{
			if(tp == 'N'){
				if(pageyn=='Y'){
					if(parseInt(pcnt) > 1){
						$("#newitem").append(message);
						$("#pagecnt").val(pcnt);
					}
				}
			}else{
				if (firok == 'N'){
					$("#firstok").val('Y');
					$("#bestitem").append(message);
					$("#pagecnt2").val(pcnt2);
				}
				if(pageyn=='Y'){
					if(firok == 'Y' && pcnt2 > 1 ){
						$("#bestitem").append(message);
						$("#pagecnt2").val(pcnt2);
					}
				}
			}
		}
	});
}

function jsProjectItemList2(tp, pg1, pg2){
	var pcnt = pg1+1;
	var pcnt2 = pg2+1;

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
				//$("#bestbtn").hide();
				//$("#newbtn").show();
				$("#newList").show();
				if(pcnt>=3) $("#newbtn").hide();
			}else{
				$("#bestitem").append(message);
				$('.tab h2').eq(1).addClass('current');
				//$("#newbtn").hide();
				$("#bestList").show();
				if(pcnt2>=3) {
					$("#bestbtn").hide();
				} else {
					$("#bestbtn").show();
				}
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
				<% server.Execute("/apps/appCom/between/chtml/loader/maintopbanner.asp") %>
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
						<% server.Execute("/apps/appCom/between/chtml/loader/main3mdpick.asp") %>
					</ul>
					<span class="moreBtn"><a href="/apps/appCom/between/project/?pjt_code=<%= Chkiif(fnGetUserInfo("sex") = "M", "3", "5") %>">더보기</a></span>
				</div>
			</div>
			<div class="listWrap boxMdl">
				<div class="tab">
					<h2 class="col2 current" name="newList">NEW</h2>
					<h2 class="col2" name="bestList">BEST</h2>
				</div>
				<div class="pdtList" id="newList">
					<ul class="list02 newList" id="newitem">
						<% ''sbMainNewItemList %>
					</ul>
					<div class="listAddBtn" id="newbtn">
						<input type="hidden" name="pagecnt" id="pagecnt" value="1">
						<a href="javascript:" onClick="jsProjectItemList('N', 'Y');">상품 더 보기</a>
					</div>
				</div>
				<div class="pdtList" id="bestList">
					<ul class="list02 bestList" id="bestitem">
					</ul>
					<div class="listAddBtn" id="bestbtn">
						<input type="hidden" name="pagecnt2" id="pagecnt2" value="1">
						<input type="hidden" name="firstok" id="firstok" value="N">
						<input type="hidden" id="lastView" value="N">
						<a href="javascript:" onClick="jsProjectItemList('B', 'Y');">상품 더 보기</a>
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
<!-- #include virtual="/lib/db/dbclose.asp" -->