<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/web2014/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->
<!-- #include virtual="/lib/classes/item/sp_evaluatesearchercls.asp" -->
<!-- #include virtual="/lib/classes/item/PlusSaleItemCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/gift/gifttalkCls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<!-- #include Virtual="/lib/util/functions.asp" -->
<%
	dim itemid	:  itemid = requestCheckVar(request("itemid"),9)

	if itemid="" then
		Call Alert_AppClose("상품번호가 없습니다.")
		response.End
	elseif Not(isNumeric(itemid)) then
		Call Alert_AppClose("잘못된 상품번호입니다.")
		response.End
	else
		'정수형태로 변환
		itemid=CLng(itemid)
	end if

	dim LoginUserid
	LoginUserid = getLoginUserid()

    '// 테스터 후기 총 갯수 및 후기총점
    Dim oTesterEvalCount, testerEvalAvgPoints
        set oTesterEvalCount = new CEvaluateSearcher
        oTesterEvalCount.FRectItemID = itemid
        oTesterEvalCount.getItemTesterEvalListReDesignUICount()

    '// 구매자 전체 평점
    testerEvalAvgPoints = FormatNumber(oTesterEvalCount.FItemList(0).FTesterEvalTotalPoints/oTesterEvalCount.FItemList(0).FTesterEvalTotalCount, 5)
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/temp_a.css?v=1.16" />
<script type="text/javascript">
$(function() {
	// 옵션
	function reviewOption(){
		var dropdownScrollLayer = new Swiper('.lyDropdownOption .swiper-container', {
			scrollbar:'.lyDropdownOption .swiper-scrollbar',
			direction:'vertical',
			slidesPerView:'auto',
			mousewheelControl:true,
			freeMode:true
		});
	}
	$( ".option-right button" ).click(function() {
		$( ".lyDropdownOption" ).slideToggle("slow");
		$( ".sortingbar .option-right button" ).toggleClass("on");
		reviewOption();
	});
	// 더많은후기보기
	$( ".btnAreaV16a" ).click(function() {
		$(this).toggleClass("on");
	});

    <%'정렬 변경%>
    $("#evalSearchOrderBy").children().click(function() {
        $("#evalSearchOrderBy").children().removeClass("current");
        $(this).addClass("current");
        $("#evalsortmethod").val($(this).attr("val"));
        $("#evalpage").val("1");
        $("#testerReviewPostContentsArea").empty();						
        getTesterEvalListNew(false);						
    });
    getTesterEvalListNew(false);    
});

function getTesterEvalListNew(chk){
    var str;
    if (chk){
        $("#evalpage").val(parseInt($("#evalpage").val())+1);
    }
    $.ajax({
        url: "/apps/appCom/wish/web2014/category/act_TesterEvalListNew.asp",
        cache: false,
        data: $("#evalTesterSearchListValue").serialize(),
        success: function(message) {
            str = message.split("|||||")
            $("#testerReviewPostContentsArea").append(str[0]);
            if (str[1]=="ok"){
                $("#moreTesterEvalListBtn").show();
            }
            else{
                $("#moreTesterEvalListBtn").hide();
            }
        }
        ,error: function(err) {
            //alert(err.responseText);
        }
    });
}
</script>
</head>
<body class="default-font body-popup">
	<%' contents %>
	<div id="content" class="content">
		<div class="tester-reivew">
			<h2><img src="//fiximage.10x10.co.kr/m/2018/common/img_bnr_tester_2.jpg" alt="직접 사용해보고 꼼꼼히 알려드려요!"></h2>
			<%' 후기대쉬보드 %>
			<div class="review-dashboard">
				<div class="total-review ">
					<b class="headline"><strong><%=oTesterEvalCount.FItemList(0).FTesterEvalTotalCount%></strong>개의 후기</b>
					<span class="icon-rating2"><i style="width:<%=fnEvalTotalPointAVG(testerEvalAvgPoints,"")%>%;"><%=fnEvalTotalPointAVG(testerEvalAvgPoints,"")%>점</i></span>
				</div>
				<div class="rate-review overHidden">
                    <%
                        '//해당 상품의 각 별점별 갯수 추출
                        Dim strSql, point4Count, point3Count, point2Count, point1Count
                        point4Count = 0
                        point3Count = 0
                        point2Count = 0
                        point1Count = 0
                        strSql = "SELECT IDX, UserID, ItemID, TotalPoint FROM "
                        strSql = strSql & " ( "
                        strSql = strSql & "		SELECT IDX, UserID, ItemID, TotalPoint FROM [db_event].[dbo].[tbl_tester_item_evaluate] WHERE ItemID='"&itemid&"' AND isusing='Y' "	
                        strSql = strSql & " )POINT "	
                        rsget.CursorLocation = adUseClient
                        rsget.CursorType=adOpenStatic
                        rsget.Locktype=adLockReadOnly
                        rsget.Open strSql, dbget

                        If Not(rsget.bof Or rsget.eof) Then
                            Do until rsget.EOF
                                If rsget("TotalPoint") = 4 Then
                                    point4Count = point4Count + 1
                                End If
                                If rsget("TotalPoint") = 3 Then
                                    point3Count = point3Count + 1
                                End If			
                                If rsget("TotalPoint") = 2 Then
                                    point2Count = point2Count + 1
                                End If
                                If rsget("TotalPoint") = 1 Then
                                    point1Count = point1Count + 1
                                End If			
                                rsget.movenext
                            Loop 
                        End If
                        rsget.close
                    %>                
					<b class="headline ftLt">구매자 평점<br /><strong><%=Formatnumber(Int(testerEvalAvgPoints*100)/100,2)%></strong></b>
					<ul class="ftRt">
						<li><span>적극추천</span><span class="bar"><i style="width:<%=Formatnumber((point4Count/oTesterEvalCount.FItemList(0).FTesterEvalTotalCount)*100,0)%>%"><b><%=Formatnumber((point4Count/oTesterEvalCount.FItemList(0).FTesterEvalTotalCount)*100,0)%>%</b></i></span></li>
						<li><span>추천</span><span class="bar"><i style="width:<%=Formatnumber((point3Count/oTesterEvalCount.FItemList(0).FTesterEvalTotalCount*100),0)%>%"><b><%=Formatnumber((point3Count/oTesterEvalCount.FItemList(0).FTesterEvalTotalCount*100),0)%>%</b></i></span></li>
                        <li><span>보통</span><span class="bar"><i style="width:<%=Formatnumber((point2Count/oTesterEvalCount.FItemList(0).FTesterEvalTotalCount*100),0)%>%"><b><%=Formatnumber((point2Count/oTesterEvalCount.FItemList(0).FTesterEvalTotalCount*100),0)%>%</b></i></span></li>
                        <li><span>추천안함</span><span class="bar"><i style="width:<%=Formatnumber((point1Count/oTesterEvalCount.FItemList(0).FTesterEvalTotalCount*100),0)%>%"><b><%=Formatnumber((point1Count/oTesterEvalCount.FItemList(0).FTesterEvalTotalCount*100),0)%>%</b></i></span></li>
					</ul>
				</div>
			</div>
			<div class="post-txtV18">
				<%' sortingbar %>
				<div class="sortingbar">
					<div class="option-left">
						<ul id="evalSearchOrderBy">
                            <li class="current" val="ne">최신순</li>
                            <li val="hs">높은평점순</li>
                            <li val="rs">낮은평점순</li>
						</ul>
					</div>
				</div>
				<%' 후기 목록 %>
				<div class="postContV16a">
					<ul class="postListV16a" id="testerReviewPostContentsArea"></ul>
					<div class="btnAreaV16a" id="moreTesterEvalListBtn" style="display:none;">
						<button type="button" class="btn-default btn btn-block btn-line-blue" onclick="getTesterEvalListNew(true);return false;">더 많은 후기 보기 <span></span></button>
					</div>
                    <form id="evalTesterSearchListValue" name="evalTesterSearchListValue">
                        <input type="hidden" name="evalitemid" id="evalitemid" value="<%=itemid%>">
                        <input type="hidden" name="evalpage" id="evalpage" value="1">
                        <input type="hidden" name="evalsortmethod" id="evalsortmethod" value="ne">
                    </form>                    
				</div>
			</div>
		</div>
	</div>
	<!-- //contents -->
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>
<%
    Set oTesterEvalCount = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->