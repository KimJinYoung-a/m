<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 다이어리 스토리 2019 다꾸랭킹페이지
' History : 2018-11-20 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/diarystory2019/lib/worker_only_view.asp" -->
<!-- #include virtual="/diarystory2019/lib/classes/diary_class_B.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
Dim vDate, vRankingCount, vCateType, sqlStr, vDateDisplayValue, vDaccuType, i, gnbflag

vDate = RequestCheckVar(request("date"),10)
vDaccuType = RequestCheckVar(request("daccutype"),15)
gnbflag = RequestCheckVar(request("gnbflag"),1)

    gnbflag = False
    strHeadTitleName = "다꾸랭킹"

If Trim(vDate) = "" Then
    sqlStr = "SELECT MAX(rankdate) as maxRankDate " +vbcrlf
    sqlStr = sqlStr & " FROM db_temp.dbo.tbl_DiaryDecoItemRanking " +vbcrlf
    'response.write sqlStr
    rsget.Open sqlStr, dbget, 1
    If Not rsget.EOF Then
        If left(Trim(rsget("maxRankDate")),10) <> Trim(vDate) Then
            vDate = left(Trim(rsget("maxRankDate")),10)
        End If
    End if
    rsget.close
End If

vDateDisplayValue = Left(vDate, 4)&"년 "&Mid(vDate, 6, 2)&"월 "&Right(vDate, 2)&"일"

Dim oDaccuRanking
set oDaccuRanking = new cdiary_list
oDaccuRanking.frecttoplimit = 70
oDaccuRanking.frectcate = Trim(CStr(ucase(vDaccuType)))
oDaccuRanking.FRectRankingDate = vDate
oDaccuRanking.GetDiaryDaccuItemRanking

%>
<!-- #include virtual="/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/diary2019.css?v=1.05" />
<script type="text/javascript">
$(function() {
    /* nav */
    var gnbSwiper = new Swiper("#navDaccu .swiper-container", {
        slidesPerView:"auto"
        <% If Trim(vDaccuType)="sticker" Then %>
            ,initialSlide:3
        <% End If %>
        <% If Trim(vDaccuType)="tape" Or Trim(vDaccuType)="stamp" Then %>
            ,initialSlide:4
        <% End If %>        
    });

    // fixed nav
	var nav1 = $(".daccu-ranking .nav-gnb").offset().top;
	$(window).scroll(function() {
		var y = $(window).scrollTop();
        if (nav1 < y ) {
			$(".daccu-ranking .nav-gnb").addClass("fixed-nav");
        } 
        else {
			$(".daccu-ranking .nav-gnb").removeClass("fixed-nav");
        }
    });
});

function fnChgDaccuRankingDate(v) {
    location.href = '/diaryStory2019/daccu_ranking.asp?date='+v+'&daccutype=<%=vDaccuType%>';
}

function fnDiaryRankingBasketCheck(g, itemid) {
    var frm = document.sbagfrm;    
    if (g=="basket") {
        frm.mode.value = "add";
        frm.itemid.value = itemid;
        frm.action = "/inipay/shoppingbag_process.asp?tp=pop";
        frm.target = "iiBagWin";
        frm.submit();
    }
    if (g=="option") {
        frm.itemid.value = itemid;
        $("#optionBoxV18").show();
    }
}

//장바구니 레이어
function fnsbagly(v) {
    if (v=="x"){
        $("#sbaglayerx").show();
        $("#alertBoxV17a").show();
    }else if(v=="o"){
        $("#sbaglayero").show();
        $("#alertBoxV17a").show();
    }
    setTimeout(function() {
        $("#alertBoxV17a").fadeOut(1000);
    }, 2500);
    setTimeout(function() {    
        $("#sbaglayerx").hide();
        $("#sbaglayero").hide();
    }, 3500);        
}

function fnOptionConfirmShowItemPrd(v) {
    var frm = document.sbagfrm;        
    if (v=="x") {
        $("#optionBoxV18").hide();
    }
    if (v=="o") {
        window.open("/category/category_itemprd.asp?itemid="+frm.itemid.value,"","");
        $("#optionBoxV18").hide();        
    }
}
</script>
</head>
<body class="default-font body-sub diary2019">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<div id="content" class="content daccu-ranking">
	    <!-- #include virtual="/diarystory2019/sub/daccu_ranking.asp" -->        
	</div>
    <form name="sbagfrm" method="post" action="" style="margin:0px;">
        <input type="hidden" name="mode" value="add" />
        <input type="hidden" name="itemid" value="" />
        <input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
        <input type="hidden" name="itemoption" value="0000" />
        <input type="hidden" name="itemea" readonly value="1" />    
    </form>
	<iframe src="" name="iiBagWin" frameborder="0" width="0" height="0" style="display:none"></iframe>    
	<!-- //contents -->
	<!-- #include virtual="/lib/inc/incfooter.asp" -->	
</body>
</html>
<%
    Set oDaccuRanking = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->