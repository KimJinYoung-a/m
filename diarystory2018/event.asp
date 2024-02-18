<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : (M)다이어리스토리2018 이벤트페이지
' History : 2017-10-12 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/diarystory2018/lib/worker_only_view.asp" -->
<!-- #include virtual="/diarystory2018/lib/classes/diary_class_B.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->

<%
dim odibest, i, selOp , scType, CurrPage, PageSize,gnbflag
	gnbflag 	= RequestCheckVar(request("gnbflag"),1)
	selOp		= requestCheckVar(Request("sop"),1) '정렬
	scType 		= requestCheckVar(Request("scT"),4) '쇼핑찬스 분류
	CurrPage 	= requestCheckVar(request("cpg"),9)

	If gnbflag = "" Then '//gnb 숨김 여부
		gnbflag = true 
	Else 
		gnbflag = False
		strHeadTitleName = "2018 다이어리"
	End if

	IF CurrPage = "" then CurrPage = 1
	If selOp = "" then selOp = "0"

	PageSize = 10

	set odibest = new cdiary_list
		odibest.FPageSize = PageSize
		odibest.FCurrPage = CurrPage
		odibest.FselOp	 	= selOp			'이벤트정렬
		odibest.FSCType 	= scType    	'이벤트구분(전체,세일,사은품,상품후기, 신규,마감임박)
		odibest.FEScope = 2
		odibest.FEvttype = "1"
'		odibest.FEvttype = "19,26"
		odibest.Fisweb	 	= "0"
		odibest.Fismobile	= "1"
		odibest.Fisapp	 	= "1"
		odibest.fnGetdievent
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/diary2018.css" />
<script type="text/javascript">
$(function() {
	$(window).scroll(sticky_sortingbar);
});
function sticky_sortingbar() {
	var window_top = $(window).scrollTop();
	var div_top = $("#exhibitionList").offset().top;
	if (window_top >= div_top) {
		$("#exhibitionList").addClass('sticky');
	} else {
		$("#exhibitionList").removeClass('sticky');
	}
}

function jsGoUrl(sop){
	document.sFrm.sop.value = sop;
	document.sFrm.cpg.value = 1;
	document.sFrm.submit();
}

function jsGoPage(iP){
	document.sFrm.cpg.value = iP;
	document.sFrm.submit();
}

// 이벤트 이동
function goEventLink(evt) {
	<% if isApp then %>
		fnAPPpopupEvent(evt);
	<% else %>
		parent.location.href='/event/eventmain.asp?eventid='+evt;
	<% end if %>
	return false;
}

var isloading=true;
$(function(){
	//첫페이지 로딩
	getList();
	var totalpg = "<%=odibest.FTotalPage%>";
	//스크롤 이벤트 시작
//	$(window).unbind("scroll");
	$(window).scroll(function() {
		if ($(window).scrollTop() >= $(document).height() - $(window).height() - 350){
			if (isloading==false){
				isloading=true;
				var pg = $("#sFrm input[name='cpg']").val();
				pg++;
				$("#sFrm input[name='cpg']").val(pg);
				if(pg<=totalpg){
					setTimeout("getList()",300);
				}
			}
		}
    });
});

//리스트 아작스 호출
function getList() {
	var str = $.ajax({
			type: "GET",
	        url: "/diarystory2018/event_act.asp",
	        data: $("#sFrm").serialize(),
	        dataType: "text",
	        async: false
	}).responseText;

	if(str!="") {
    	if($("#sFrm input[name='cpg']").val()=="1") {
        	$('#diarylist').html(str);
        } else {
       		$str = $(str)
       		$('#diarylist').append($str);
        }
        isloading=false;
    } else {
//    	$(window).unbind("scroll");
    }
}
	
</script>
</head>
<body class="default-font body-<%=chkiif(gnbflag,"main","sub")%>">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->

	<!-- contents -->
	<div id="content" class="content">
		<!-- exhibition/event list -->
		<section id="exhibitionList" class="exhibition-list">
			<h2 class="hidden">다이어리 기획전</h2>

			<form name="sFrm" id="sFrm" method="get" action="/diarystory2018/event.asp">
			<input type="hidden" name="cpg" value="1"/>
			<input type="hidden" name="sop" value="<%= sElop %>"/>
			
			<!-- 건수 및 정렬 옵션 셀렉트박스 -->
			<div class="sortingbar">
				<div class="option-left">
					<p class="total"><b><%=odibest.FTotalCount%></b>건</p>
				</div>

				<div class="option-right">
					<div class="styled-selectbox styled-selectbox-default">
						<select class="select" title="정렬 선택옵션" onchange="jsGoUrl(this.value);" >
							<option <%=chkIIF(sElop="0","selected='selected'","")%> value="0">신규순</option>
							<option <%=chkIIF(sElop="2","selected='selected'","")%> value="2">인기순</option>
							<!--<button type="button" class="<%'=chkIIF(sElop="1","selected='selected'","")%>" onclick="jsGoUrl('1'); return false;" >마감임박순</button>-->
						</select>
					</div>
				</div>
			</div>

			<%' If odibest.FResultCount > 0 Then %>
				<div class="list-card type-align-left" id="diarylist" >
					
				</div>
			<%' end if %>
		</section>
	</div>
	<!-- //contents -->

	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<% set odibest = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->