<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : (M)다이어리스토리2017 아이템 리스트
' History : 2017-09-26 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/diarystory2018/lib/worker_only_view.asp" -->
<!-- #include virtual="/diarystory2018/lib/classes/diary_class_B.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%

	Dim ArrDesign , tmp , iTmp , ctmp, ktmp, arrcontents ,arrkeyword , userid, limited, rdsearch
	dim cate , PageSize , ttpgsz , CurrPage, vGubun, vMDPick, vParaMeter, vParaMeterCG
	dim SortMet	,page, cDiary
	Dim ListDiv, arrColorCode, GiftSu, PrdBrandList, i
	dim vWishArr
	''li 클래스 on용
	dim realarrcontents, realarrkeyword, realarrColorCode, gnbflag

	gnbflag = RequestCheckVar(request("gnbflag"),1)
	If gnbflag = "" Then '//gnb 숨김 여부
		gnbflag = true 
	Else 
		gnbflag = False
		strHeadTitleName = "2018 다이어리"
	End if

	ListDiv	= requestcheckvar(request("ListDiv"),4)
	If ListDiv = "" Then ListDiv = "list"

	PageSize = 30

	userid		= getLoginUserID
	rdsearch = request("rdsearch")
	ArrDesign = request("arrds")
	arrcontents = request("arrcont")
	arrkeyword = request("arrkey")
	arrColorCode = request("iccd")
	limited = request("limited")
	page 		= requestcheckvar(request("page"),2)
	SortMet 	= requestCheckVar(request("srm"),9)
	CurrPage 	= requestCheckVar(request("cpg"),9)
	
	realarrcontents = arrcontents
	realarrkeyword = arrkeyword
	realarrColorCode = arrColorCode

	IF SortMet = "" Then SortMet = "newitem"
	IF CurrPage = "" then CurrPage = 1
	if page = "" then page = 1
	If limited = "" then limited = "x"

	ArrDesign = split(ArrDesign,",")
	arrcontents = split(arrcontents,",")
	arrkeyword = split(arrkeyword,",")
	arrColorCode = Split(arrColorCode,",")

	For iTmp =0 to Ubound(ArrDesign)-1
		IF ArrDesign(iTmp)<>"" Then
			tmp  = tmp & requestcheckvar(ArrDesign(iTmp),2) &","
		End IF
	Next
	ArrDesign = tmp

	tmp = ""
	For cTmp =0 to Ubound(arrcontents)-1
		IF arrcontents(cTmp)<>"" Then
			tmp  = tmp & "" & requestcheckvar(arrcontents(cTmp),20) & "" &","
		End IF
	Next
	arrcontents = tmp

	tmp = ""
	For ktmp =0 to Ubound(arrkeyword)-1
		IF arrkeyword(ktmp)<>"" Then
			tmp  = tmp & requestcheckvar(arrkeyword(ktmp),2) &","
		End IF
	Next
	arrkeyword = tmp

	tmp = ""
	For ktmp =0 to Ubound(arrColorCode)-1
		IF arrColorCode(ktmp)<>"" Then
			tmp  = tmp & requestcheckvar(arrColorCode(ktmp),2) &","
		End IF
	Next
	arrColorCode = tmp

	Dim sArrDesign,sarrcontents,sarrkeyword,sarrColorCode
	sArrDesign =""
	sarrcontents =""
	sarrkeyword =""
	sarrColorCode =""
	IF ArrDesign <> "" THEN sArrDesign =  left(ArrDesign,(len(ArrDesign)-1))
	IF arrcontents <> "" THEN sarrcontents =  left(arrcontents,(len(arrcontents)-1))
	IF arrkeyword <> "" THEN
		If arrColorCode = "" then
		sarrkeyword =  left(arrkeyword,(len(arrkeyword)-1))
		else
		sarrkeyword =  arrkeyword & left(arrColorCode,(len(arrColorCode)-1))
		End If
	else
		If arrColorCode <> "" then
		sarrkeyword =  left(arrColorCode,(len(arrColorCode)-1))
		End If
	End If

	vParaMeter = "&arrds="&ArrDesign&"&arrcont="&arrcontents&"&arrkey="&arrkeyword&"&iccd="&arrColorCode&"&ListDiv="&ListDiv&"&limited="&limited&""
	vParaMeterCG = "&arrcont="&arrcontents&"&arrkey="&arrkeyword&"&iccd="&arrColorCode&"&ListDiv="&ListDiv&"&limited="&limited&""

	dim cDiarycnt
	Set cDiarycnt = new cdiary_list
		cDiarycnt.getDiaryCateCnt '상태바 count
		
	'1+1
	Set cDiary = new cdiary_list
		cDiary.getOneplusOneDaily '1+1
		cDiary.getDiaryCateCnt '상태바 count
'		GiftSu = cDiary.getGiftDiaryExists(cDiary.FOneItem.Fitemid) '사은품 수

	Set PrdBrandList = new cdiary_list
		'아이템 리스트
		PrdBrandList.FPageSize = PageSize
		PrdBrandList.FCurrPage = CurrPage
		PrdBrandList.frectdesign = sArrDesign
		PrdBrandList.frectcontents = arrcontents
		PrdBrandList.frectkeyword = sarrkeyword
		PrdBrandList.fmdpick = vMDPick
		PrdBrandList.frectlimited = limited
		PrdBrandList.ftectSortMet = SortMet
		''PrdBrandList.fuserid = userid		'위시용인데 분리 > 안씀
		PrdBrandList.getDiaryItemLIst

	'// 검색결과 내위시 표시정보 접수
	dim iLp
	dim rstArrItemid: rstArrItemid=""
	if IsUserLoginOK then
		'// 검색결과 상품목록 작성
		IF PrdBrandList.FResultCount >0 then
			For iLp=0 To PrdBrandList.FResultCount -1
				rstArrItemid = rstArrItemid & chkIIF(rstArrItemid="","",",") & PrdBrandList.FItemList(iLp).FItemID
			Next
		End if
		'// 위시결과 상품목록 작성
		if rstArrItemid<>"" then
			Call getMyFavItemList(getLoginUserid(),rstArrItemid,vWishArr)
		end if
	end if
	
%>
<link rel="stylesheet" type="text/css" href="/lib/css/diary2018.css" />
<script type="text/javascript">
var isloading=true;
$(function(){
	//첫페이지 로딩
	getList();

	//스크롤 이벤트 시작
	$(window).unbind("scroll");
	$(window).scroll(function() {
		var currentPercentage = ($(window).scrollTop() / ($(document).outerHeight() - $(window).height())) * 100;
//			if ($(window).scrollTop() >= $(document).height() - $(window).height() - 350){
		if(currentPercentage>70){
			if (isloading==false){
				isloading=true;
				var pg = $("#sFrm input[name='cpg']").val();
				pg++;
				$("#sFrm input[name='cpg']").val(pg);
				setTimeout("getList()",500);
			}
		}
    });
});

function getList() {
	var str = $.ajax({
			type: "GET",
	        url: "/diarystory2018/act_list.asp",
	        data: $("#sFrm").serialize(),
	        dataType: "text",
	        async: false
	}).responseText;

	if(str!="") {
    	if($("#sFrm input[name='cpg']").val()=="1") {
        	$('#diaryList').html(str);
        } else {
       		$str = $(str)
       		$('#diaryList').append($str);
        }
        isloading=false;
    } else {
//	    	$(window).unbind("scroll");
    }
}

$(function() {
	/* floating button control */
	var didScroll;
	var lastScrollTop = 0;
	var delta = 5;
	var floatingbuttonHeight = $(".btn-floating").outerHeight();

	$(window).scroll(function(event){
		didScroll = true;
	});

	setInterval(function() {
		if (didScroll) {
			hasScrolled();
			didScroll = false;
		}
	}, 250);

	function hasScrolled() {
		var st = $(this).scrollTop();

		// Make sure they scroll more than delta
		if(Math.abs(lastScrollTop - st) <= delta)
			return;

		// If they scrolled down and are past the navbar, add class .nav-up.
		// This is necessary so you never see what is "behind" the navbar.
		if (st > lastScrollTop && st > floatingbuttonHeight){
			// Scroll Down
			$(".btn-floating").removeClass('nav-down').addClass('nav-up');
		} else {
			// Scroll Up
			if(st + $(window).height() < $(document).height()) {
				$(".btn-floating").removeClass('nav-up').addClass('nav-down');
			}
		}
		lastScrollTop = st;
	}

	/* sub contents show, hide */
//	$("#searchFilter .panel .hgroup a").on("click", function(){
//		$(".panel .panelcont").hide();
//		$(this).parent().next().toggle();
//	});

	/* multi select */
//	$(".depth1.multi-select a").on("click", function(){
//		$(this).toggleClass("on");
//		return false;
//	});

//	$(".panel .hgroup a").on("keyup", function(){
//		var position = $("#"+v+"").offset();
//		$('html, body').animate({scrollTop : position.top}, 500);
//	});

	$("#mask, #searchFilter .ly-header").on('scroll touchmove mousewheel', function(event) {
		event.preventDefault();
		event.stopPropagation();
		return false;
	});
});

/* layer popup */
function showLayer(v) {
	var $layer = $("#"+v+"");
	$layer.show();
	$layer.find(".btn-close, .btn-close-down").one("click",function () {
		$layer.hide();
		$("#mask").hide().css({"z-index":"10"});
		if(v == "searchFilter"){
			$("body").css({"overflow":"auto"});
		}
	});

	$("#mask").on("click",function () {
		$layer.hide();
		$(this).hide().css({"z-index":"10"});
		if(v == "searchFilter"){
			$("body").css({"overflow":"auto"});
		}
	});

	if(v == "searchFilter"){
		$("#mask").show().css({"z-index":"25"});
		$("body").css({"overflow":"hidden"});
	}
}

///////////////////////////////////
function searchlink(v){
	if (v == "")
	{
		document.location = "/<%=g_HomeFolder%>/list.asp";
	}else{
		var frm = document.sFrm;
		frm.arrds.value=v+",";
		frm.submit();
	}
}

function jsGoPage(iP){
	document.sFrm.cpg.value = iP;
	document.sFrm.submit();
}
///////////////////////////////////

function goWishPop(i){
<% If IsUserLoginOK() Then ''ErBValue.value -> 공통파일의 구분값 (cate는 1) %>
	document.sFrm.itemid.value = i;
	document.sFrm.action = "/common/popWishFolder.asp";
	sFrm.submit();
<% Else %>
	top.location.href = "/login/login.asp?backpath=<%=fnBackPathURLChange(CurrURLQ())%>";
<% End If %>
}

function fnSearch(frmnm,frmval){
	frmnm.value = frmval;
	var frm = document.sFrm;
	frm.cpg.value=1;
	frm.submit();
}

$(function(){
	// 컬러별 검색
	$('.colorType li').click(function(){
		$(this).find('em').toggle();
	});
});

function goSearchDiary()
{
/*
	var nm  = document.getElementsByName('design');
	var cm  = document.getElementsByName('contents');
	var km  = document.getElementsByName('keyword');

	document.frm_search1.arrds.value = "";
	document.frm_search1.arrcont.value = "";
	document.frm_search1.arrkey.value = "";

	for (var i=0;i<nm.length;i++){

		if (nm[i].checked){
			document.frm_search1.arrds.value = document.frm_search1.arrds.value  + nm[i].value + ",";
		}
	}

	for (var i=0;i<cm.length;i++){

		if (cm[i].checked){
			document.frm_search1.arrcont.value = document.frm_search1.arrcont.value  + cm[i].value + ",";
		}
	}

	for (var i=0;i<km.length;i++){

		if (km[i].checked){
			document.frm_search1.arrkey.value = document.frm_search1.arrkey.value  + km[i].value + ",";
		}
	}

	document.frm_search.limited.value = document.frm_search.sublimited.value;
*/
	document.sFrm.action = "/<%=g_HomeFolder%>/list.asp";
	document.sFrm.submit();
}

//초기화-수정예정
$( document ).ready( function() {
	$( '.check-all' ).click( function() {
	  $( '.check' ).prop( 'checked', false );
		var tmp1;
		for(var i=0;i<document.frm_search1.chkIcd.length;i++) {
			tmp1 = document.frm_search1.chkIcd[i].value;
			$("#barCLChp" + tmp1).removeClass("selected");
			$("#barCLChp" + tmp1).attr("summary","N");
		}
		document.frm_search1.iccd.value="0";
		$("#barCLChp0").addClass("selected");
	} );
} );

/*
function fnSelColorChip(iccd) {
	var tmp;
	var chkCnt = 0;
		if(iccd==0) {
		//전체 선택-리셋
		for(var i=0;i<document.frm_search1.chkIcd.length;i++) {
			tmp = document.frm_search1.chkIcd[i].value;
			$("#barCLChp" + tmp).removeClass("selected");
			$("#barCLChp" + tmp).attr("summary","N");
		}
		document.frm_search1.iccd.value="0";
		$("#barCLChp0").addClass("selected");
	} else {
		// 지정색 On/Off
		$("#barCLChp0").removeClass("selected");
		if ($("#barCLChp" + iccd).attr("summary") == "Y"){
			$("#barCLChp" + iccd).removeClass("selected");
			$("#barCLChp" + iccd).attr("summary","N");
		} else {
			$("#barCLChp" + iccd).addClass("selected");
			$("#barCLChp" + iccd).attr("summary","Y");
		}

		//컬러 마지막 선택 빠질경우 없음으로 되돌아가기
		$(".colorChip li:not('#barCLChp0')").each(function(){
			if($(this).hasClass("selected")) {
				chkCnt++;
			}
		});
		if(chkCnt<=0) {
			document.frm_search1.iccd.value="0";
			$("#barCLChp0").attr("class","selected");
		} else {
			$("#barCLChp0").removeClass("selected");
		}

		document.frm_search1.iccd.value="";
		for(var i=0;i<document.frm_search1.chkIcd.length;i++) {
			tmp = document.frm_search1.chkIcd[i].value;
			if($("#barCLChp" + tmp).attr("summary") =="Y") {
				if(document.frm_search1.iccd.value!="") {
					document.frm_search1.iccd.value = document.frm_search1.iccd.value + tmp + ",";
				} else {
					document.frm_search1.iccd.value = tmp+ ",";
				}
			}
		}
	}
}
*/

function fncatesearch(ccd){
	location.href="/diarystory2018/list.asp?cpg=1&gnbflag=1&srm=<%=SortMet%>&arrds="+ccd+"&<%=vParaMeterCG%>";
}

function jsSelectFilterSomething(gubun,thing,title,realvalue){

	var m = $("#"+realvalue+"").val();
	var t = "";

	if($("#"+thing+"").hasClass("on")){	//이미선택된것
		$("#"+thing+"").removeClass("on");
		t = m.replace(","+title+",", ",");
		
		if(t == ","){
			t = "";
		}
		
		$("#"+realvalue+"").val(t);
	}else{
		$("#"+thing+"").addClass("on");
		if(m == ""){
			$("#"+realvalue+"").val(","+title+",");
		}else{
			$("#"+realvalue+"").val(m+title+",");
		}
	}
	
	var l = $("#filter"+gubun+"list li").length;
	var a = $("#filter"+gubun+"list li a");
	var tit = "";
	var tit2 = "";
	var titcnt = 0;
	for(var i=0; i<l; i++){
		if(a.eq(i).hasClass("on")){
			if(tit == ""){
				tit = $("#filter"+gubun+"list li a").eq(i).text();
			}
			titcnt = titcnt + 1;
		}
	}
	
	if(titcnt > 1){
		tit2 = " 외 " + (titcnt-1) + "건";
	}
	
	tit = tit.replace(" BEST","")
	
	$("#filter"+gubun+"title").text(tit+tit2);
	
}

//필터 펼치기
function jsFilterShow(f){
	if($("#filter"+f+" .panelcont").is(":hidden")){
		$("#filter"+f+" .panelcont").show();
	}else{
		$("#filter"+f+" .panelcont").hide();
	}
	
	if(f != "contents"){
		$("#filtercontents .panelcont").hide();
	}
	if(f != "date"){
		$("#filterdate .panelcont").hide();
	}
	if(f != "schedule"){
		$("#filterschedule .panelcont").hide();
	}
	if(f != "option"){
		$("#filteroption .panelcont").hide();
	}
	if(f != "material"){
		$("#filtermaterial .panelcont").hide();
	}
	if(f != "form"){
		$("#filterform .panelcont").hide();
	}
	if(f != "color"){
		$("#filtercolor .panelcont").hide();
	}

	return false;
}

</script>
</head>
<body class="default-font body-<%=chkiif(gnbflag,"main","sub")%> bg-grey diary2018">
	<!-- #include virtual="/lib/inc/incheader.asp" -->

	<!-- contents -->
	<div id="content" class="content">
	<form name="sFrm" id="sFrm" method="get" action="?" style="margin:0px;">
	<input type="hidden" name="cpg" value="1"/>
	<input type="hidden" name="page" value="<%= PrdBrandList.FPageSize %>"/>
	<input type="hidden" name="srm" value="<%= PrdBrandList.ftectSortMet %>"/>
	<input type="hidden" name="arrds" value="<%= ArrDesign %>"/>
	<input type="hidden" name="ListDiv" value="<%=ListDiv%>"/>
	<input type="hidden" name="arrcont" id="arrcont" value="<%=arrcontents%>"/>
	<input type="hidden" name="arrkey" id="arrkey" value="<%=arrkeyword%>"/>
	<input type="hidden" name="iccd" id="iccd" value="<%=arrColorCode%>"/>
	<input type="hidden" name="limited" value="<%=limited%>"/>
	<input type="hidden" name="rdsearch" value="<%=rdsearch%>"/>
	<input type="hidden" name="itemid" value=""/>
	<input type="hidden" name="gnbflag" value="<%=gnbflag%>"/>
		<!-- breadcrumbs 
		<div id="breadcrumbs" class="breadcrumbs">
			<div class="swiper-container">
				<ol class="swiper-wrapper">
					<li class="swiper-slide"><a href="">다이어리</a></li>
					<li class="swiper-slide"><a href="">심플</a></li>
				</ol>
			</div>
		</div>
		-->

		<div class="filter-category">
			<ul>
				<li><a href="" <% If Trim(ArrDesign)="" Then %>class="on"<% End If %>  onclick="fncatesearch(); return false;">전체</a></li>
				<li><a href="" <% If Trim(ArrDesign)="10," Then %>class="on"<% End If %> onclick="fncatesearch('10,'); return false;">심플</a></li>
				<li><a href="" <% If Trim(ArrDesign)="20," Then %>class="on"<% End If %> onclick="fncatesearch('20,'); return false;">일러스트</a></li>
				<li><a href="" <% If Trim(ArrDesign)="30," Then %>class="on"<% End If %> onclick="fncatesearch('30,'); return false;">패턴</a></li>
				<li><a href="" <% If Trim(ArrDesign)="40," Then %>class="on"<% End If %> onclick="fncatesearch('40,'); return false;">포토</a></li>
			</ul>
		</div>

		<!-- 검색 결과 건수 및 정렬 옵션 셀렉트박스 -->
		<div class="sortingbar">
			<div class="option-left">
				<p class="total"><b><%=PrdBrandList.FTotalCount %></b>건</p>
			</div>
			<div class="option-right">
				<div class="styled-selectbox styled-selectbox-default">
					<select class="select" onchange="fnSearch(document.sFrm.srm,this.value);" title="검색결과 리스트 정렬 선택옵션">
						<option <%=CHKIIF(SortMet="newitem","selected='selected'","")%> value="newitem">신규순</option><!-- 신규순 : 디폴트 -->
						<option <%=CHKIIF(SortMet="best","selected='selected'","")%> value="best">인기순</option>
						<option <%=CHKIIF(SortMet="eval","selected='selected'","")%> value="eval">리뷰등록순</option>
						<option <%=CHKIIF(SortMet="hi","selected='selected'","")%> value="hi">높은가격순</option>
						<option <%=CHKIIF(SortMet="min","selected='selected'","")%> value="min">낮은가격순</option>
					</select>
				</div>
			</div>
		</div>

		<!-- 필터 버튼 -->
		<div class="fixed-bottom btn-floating btn-roundshadow-single">
			<a href="#searchFilter" class="btn-filter on" onclick="showLayer('searchFilter'); return false;">필터</a>
		</div>

		<!-- item list -->
		<% If PrdBrandList.FResultCount > 0 Then %>
			<div class="items type-grid">
				<ul id="diaryList">
				<%
					For i = 0 To PrdBrandList.FResultCount - 1
	
						Dim tempimg
	
						If ListDiv = "list" Then
							tempimg = PrdBrandList.FItemList(i).FDiaryBasicImg
						End If
						If ListDiv = "item" Then
							tempimg = PrdBrandList.FItemList(i).FDiaryBasicImg2
						End If
						
						IF application("Svr_Info") = "Dev" THEN
							PrdBrandList.FItemList(i).FDiaryBasicImg = left(PrdBrandList.FItemList(i).FDiaryBasicImg,7)&mid(PrdBrandList.FItemList(i).FDiaryBasicImg,12)
							PrdBrandList.FItemList(i).FDiaryBasicImg2 = left(PrdBrandList.FItemList(i).FDiaryBasicImg2,7)&mid(PrdBrandList.FItemList(i).FDiaryBasicImg2,12)
							'response.write PrdBrandList.FItemList(i).FDiaryBasicImg
						end if
				%>
						<li>
							<a href="" onclick="TnGotoProduct('<%=PrdBrandList.FItemList(i).FItemID %>'); return false;" >
								<div class="thumbnail"><img src="<%=PrdBrandList.FItemList(i).FDiaryBasicImg%>" alt="" /><% IF PrdBrandList.FItemList(i).isSoldOut Then%><b class="soldout">일시 품절</b><% end if %></div>
								<div class="desc">
									<span class="brand"><%=PrdBrandList.FItemList(i).FBrandName%></span>
									<p class="name"><%=PrdBrandList.FItemList(i).FItemName%></p>
									<div class="price">
									<%
										If PrdBrandList.FItemList(i).IsSaleItem AND PrdBrandList.FItemList(i).isCouponItem Then	'### 쿠폰 O 세일 O
											Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(PrdBrandList.FItemList(i).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
											Response.Write "&nbsp;<b class=""discount color-red"">" & PrdBrandList.FItemList(i).getSalePro & "</b>"
											If PrdBrandList.FItemList(i).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
												If InStr(PrdBrandList.FItemList(i).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
													Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
												Else
													Response.Write "&nbsp;<b class=""discount color-green"">" & PrdBrandList.FItemList(i).GetCouponDiscountStr & "<small>쿠폰</small></b>"
												End If
											End If
											Response.Write "</div>" &  vbCrLf
										ElseIf PrdBrandList.FItemList(i).IsSaleItem AND (Not PrdBrandList.FItemList(i).isCouponItem) Then	'### 쿠폰 X 세일 O
											Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(PrdBrandList.FItemList(i).getRealPrice,0) & "<span class=""won"">원</span></b>"
											Response.Write "&nbsp;<b class=""discount color-red"">" & PrdBrandList.FItemList(i).getSalePro & "</b>"
											Response.Write "</div>" &  vbCrLf
										ElseIf PrdBrandList.FItemList(i).isCouponItem AND (NOT PrdBrandList.FItemList(i).IsSaleItem) Then	'### 쿠폰 O 세일 X
											Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(PrdBrandList.FItemList(i).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
											If PrdBrandList.FItemList(i).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
												If InStr(PrdBrandList.FItemList(i).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
													Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
												Else
													Response.Write "&nbsp;<b class=""discount color-green"">" & PrdBrandList.FItemList(i).GetCouponDiscountStr & "<small>쿠폰</small></b>"
												End If
											End If
											Response.Write "</div>" &  vbCrLf
										Else
											Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(PrdBrandList.FItemList(i).getRealPrice,0) & "<span class=""won"">" & CHKIIF(PrdBrandList.FItemList(i).IsMileShopitem," Point","원") & "</span></b></div>" &  vbCrLf
										End If
									%>
									</div>
								</div>
							</a>
							<div class="etc">
								<% if PrdBrandList.FItemList(i).FEvalCnt > 0 then %>
									<div class="tag review">
										<span class="icon icon-rating"><i style="width:<%=fnEvalTotalPointAVG(PrdBrandList.FItemList(i).FPoints,"search")%>%;"><%=fnEvalTotalPointAVG(PrdBrandList.FItemList(i).FPoints,"search")%>점</i></span>
										<span class="counting"><%=chkiif(PrdBrandList.FItemList(i).FEvalCnt>999,"999+",PrdBrandList.FItemList(i).FEvalCnt)%></span>
									</div>
								<% end if %>

								<button class="tag wish btn-wish" onclick="goWishPop('<%= PrdBrandList.FItemList(i).FItemID %>');">
									<%
									If PrdBrandList.FItemList(i).FfavCount > 0 Then
										If fnIsMyFavItem(vWishArr,PrdBrandList.FItemList(i).FItemID) Then
											Response.Write "<span class=""icon icon-wish on"" id=""wish"&PrdBrandList.FItemList(i).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&PrdBrandList.FItemList(i).FItemID&""">"
											Response.Write CHKIIF(PrdBrandList.FItemList(i).FfavCount>999,"999+",formatNumber(PrdBrandList.FItemList(i).FfavCount,0)) & "</span>"
										Else
											Response.Write "<span class=""icon icon-wish"" id=""wish"&PrdBrandList.FItemList(i).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&PrdBrandList.FItemList(i).FItemID&""">"
											Response.Write CHKIIF(PrdBrandList.FItemList(i).FfavCount>999,"999+",formatNumber(PrdBrandList.FItemList(i).FfavCount,0)) & "</span>"
										End If
									Else
										Response.Write "<span class=""icon icon-wish"" id=""wish"&PrdBrandList.FItemList(i).FItemID&"""><i> wish</i></span><span class=""counting"" id=""cnt"&PrdBrandList.FItemList(i).FItemID&"""></span>"
									End If
									%>
								</button>

								<% IF PrdBrandList.FItemList(i).IsCouponItem AND PrdBrandList.FItemList(i).GetCouponDiscountStr = "무료배송" Then %>
									<div class="tag shipping"><span class="icon icon-shipping"><i>무료배송</i></span> FREE</div>
								<% End If %>
							</div>
						</li>
					<% next %>
				</ul>
			</div>
		<% else %>
			<!-- for dev msg : 상품없음 -->
			<div class="nodata nodata-category">
				<p><b>해당되는 내용이 없습니다.</b></p>
				<p>품절 또는 종료된 경우에는 노출되지 않을 수 있습니다.</p>
			</div>
		<% end if %>
	</form>
	</div>
	<!-- //contents -->

	<!-- filter for category -->
	<div id="searchFilter" class="search-filter fixed-bottom">
		<div class="ly-header">
			<h2>다이어리 필터</h2>
			<button type="reset" class="btn-reset">초기화</button>
		</div>
		<div class="inner">
			<div class="ly-contents">
				<div class="scrollwrap">

					<!-- 날짜 -->
					<div id="filtercontents" class="panel style">
						<div class="hgroup" onclick="jsFilterShow('contents');">
							<a href="#filtercontents">
								<h3>날짜</h3>
								<div class="option">
									<p class="value" id="filtercontentstitle"></p>
								</div>
							</a>
						</div>
						<div class="panelcont">
							<ul class="depth1 multi-select" id="filtercontentslist" >
								<li><a href="" id="filterstylecon1" <% if chkArrValue(realarrcontents,"2018 날짜형") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('contents','filterstylecon1','2018 날짜형','arrcont'); return false;">2018 날짜형</a></li>
								<li><a href="" id="filterstylecon2" <% if chkArrValue(realarrcontents,"만년형") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('contents','filterstylecon2','만년형','arrcont'); return false;">만년형</a></li>
							</ul>
						</div>
					</div>

					<!-- 기간 -->
					<div id="filterdate" class="panel style">
						<div class="hgroup" onclick="jsFilterShow('date');">
							<a href="#filterdate">
								<h3>기간</h3>
								<div class="option">
									<p class="value" id="filterdatetitle"></p>
								</div>
							</a>
						</div>
						<div class="panelcont">
							<ul class="depth1 multi-select" id="filterdatelist">
								<li><a href="" id="filterstyledate1" <% if chkArrValue(realarrcontents,"1개월") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('date','filterstyledate1','1개월','arrcont'); return false;">1개월</a></li>
								<li><a href="" id="filterstyledate2" <% if chkArrValue(realarrcontents,"분기별") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('date','filterstyledate2','분기별','arrcont'); return false;">분기별</a></li>
								<li><a href="" id="filterstyledate3" <% if chkArrValue(realarrcontents,"6개월") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('date','filterstyledate3','6개월','arrcont'); return false;">6개월</a></li>
								<li><a href="" id="filterstyledate4" <% if chkArrValue(realarrcontents,"1년") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('date','filterstyledate4','1년','arrcont'); return false;">1년</a></li>
								<li><a href="" id="filterstyledate5" <% if chkArrValue(realarrcontents,"1년 이상") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('date','filterstyledate5','1년 이상','arrcont'); return false;">1년 이상</a></li>
							</ul>
						</div>
					</div>

					<!-- 내지 구성 -->
					<div id="filterschedule" class="panel style">
						<div class="hgroup" onclick="jsFilterShow('schedule');">
							<a href="#filterschedule">
								<h3>내지 구성</h3>
								<div class="option">
									<p class="value" id="filterscheduletitle"></p>
								</div>
							</a>
						</div>
						<div class="panelcont">
							<ul class="depth1 multi-select" id="filterschedulelist">
								<li><a href="" id="filterstyleschedule1" <% if chkArrValue(realarrcontents,"연간스케줄") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('schedule','filterstyleschedule1','연간스케줄','arrcont'); return false;">연간스케줄</a></li>
								<li><a href="" id="filterstyleschedule2" <% if chkArrValue(realarrcontents,"월간스케줄") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('schedule','filterstyleschedule2','월간스케줄','arrcont'); return false;">월간스케줄</a></li>
								<li><a href="" id="filterstyleschedule3" <% if chkArrValue(realarrcontents,"주간스케줄") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('schedule','filterstyleschedule3','주간스케줄','arrcont'); return false;">주간스케줄</a></li>
								<li><a href="" id="filterstyleschedule4" <% if chkArrValue(realarrcontents,"일스케줄") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('schedule','filterstyleschedule4','일스케줄','arrcont'); return false;">일스케줄</a></li>
							</ul>
						</div>
					</div>

					<!-- 옵션 -->
					<div id="filteroption" class="panel style">
						<div class="hgroup" onclick="jsFilterShow('option');">
							<a href="#filteroption">
								<h3>옵션</h3>
								<div class="option">
									<p class="value" id="filteroptiontitle"></p>
								</div>
							</a>
						</div>
						<div class="panelcont">
							<ul class="depth1 multi-select" id="filteroptionlist">
								<li><a href="" id="filterstyleoption1" <% if chkArrValue(realarrcontents,"캐시북") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('option','filterstyleoption1','캐시북','arrcont'); return false;">캐시북</a></li>
								<li><a href="" id="filterstyleoption2" <% if chkArrValue(realarrcontents,"포켓") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('option','filterstyleoption2','포켓','arrcont'); return false;">포켓</a></li>
								<li><a href="" id="filterstyleoption3" <% if chkArrValue(realarrcontents,"밴드") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('option','filterstyleoption3','밴드','arrcont'); return false;">밴드</a></li>
								<li><a href="" id="filterstyleoption4" <% if chkArrValue(realarrcontents,"펜홀더") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('option','filterstyleoption4','펜홀더','arrcont'); return false;">펜홀더</a></li>
							</ul>
						</div>
					</div>

					<!-- 재질 -->
					<div id="filtermaterial" class="panel style">
						<div class="hgroup" onclick="jsFilterShow('material');">
							<a href="#filtermaterial">
								<h3>재질</h3>
								<div class="option">
									<p class="value" id="filtermaterialtitle"></p>
								</div>
							</a>
						</div>
						<div class="panelcont"><%= realarrkeyword %>
							<ul class="depth1 multi-select" id="filtermateriallist">
								<li><a href="" id="filterstylematerial1" <% if chkArrValue(realarrkeyword,"50") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('material','filterstylematerial1','50','arrkey'); return false;">소프트커버</a></li>
								<li><a href="" id="filterstylematerial2" <% if chkArrValue(realarrkeyword,"51") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('material','filterstylematerial2','51','arrkey'); return false;">하드커버</a></li>
								<li><a href="" id="filterstylematerial3" <% if chkArrValue(realarrkeyword,"52") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('material','filterstylematerial3','52','arrkey'); return false;">가죽</a></li>
								<li><a href="" id="filterstylematerial4" <% if chkArrValue(realarrkeyword,"53") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('material','filterstylematerial4','53','arrkey'); return false;">PVC</a></li>
								<li><a href="" id="filterstylematerial5" <% if chkArrValue(realarrkeyword,"54") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('material','filterstylematerial5','54','arrkey'); return false;">패브릭</a></li>
							</ul>
						</div>
					</div>

					<!-- 제본 -->
					<div id="filterform" class="panel style">
						<div class="hgroup" onclick="jsFilterShow('form');">
							<a href="#filterform">
								<h3>제본</h3>
								<div class="option">
									<p class="value" id="filterformtitle"></p>
								</div>
							</a>
						</div>
						<div class="panelcont">
							<ul class="depth1 multi-select" id="filterformlist">
								<li><a href="" id="filterstyleform1" <% if chkArrValue(realarrkeyword,"55") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('form','filterstyleform1','55','arrkey'); return false;">양장/무선</a></li>
								<li><a href="" id="filterstyleform2" <% if chkArrValue(realarrkeyword,"56") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('form','filterstyleform2','56','arrkey'); return false;">스프링</a></li>
								<li><a href="" id="filterstyleform3" <% if chkArrValue(realarrkeyword,"57") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('form','filterstyleform3','57','arrkey'); return false;">바인더</a></li>
							</ul>
						</div>
					</div>

					<!-- 컬러 -->
					<div id="filtercolor" class="panel color">
						<div class="hgroup" onclick="jsFilterShow('color');">
							<a href="#filtercolor">
								<h3>컬러</h3>
								<div class="option">
									<p class="value" id="filtercolortitle"></p>
								</div>
							</a>
						</div>
						<div class="panelcont">
							<ul class="depth1 multi-select" id="filtercolorlist">
								<li class="wine"><a href="" id="filterstylecolor1" <% if chkArrValue(realarrColorCode,"28") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('color','filterstylecolor1','28','iccd'); return false;">Wine</a></li>
								<li class="red"><a href="" id="filterstylecolor2" <% if chkArrValue(realarrColorCode,"2") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('color','filterstylecolor1','2','iccd'); return false;">Red</a></li>
								<li class="orange"><a href="" id="filterstylecolor3" <% if chkArrValue(realarrColorCode,"16") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('color','filterstylecolor3','16','iccd'); return false;">Orange</a></li>
								<li class="brown"><a href="" id="filterstylecolor4" <% if chkArrValue(realarrColorCode,"24") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('color','filterstylecolor4','24','iccd'); return false;">Brown</a></li>
								<li class="camel"><a href="" id="filterstylecolor5" <% if chkArrValue(realarrColorCode,"29") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('color','filterstylecolor5','29','iccd'); return false;">Camel</a></li>
								<li class="yellow"><a href="" id="filterstylecolor6" <% if chkArrValue(realarrColorCode,"17") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('color','filterstylecolor6','17','iccd'); return false;">Yellow</a></li>
								<li class="beige"><a href="" id="filterstylecolor7" <% if chkArrValue(realarrColorCode,"18") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('color','filterstylecolor7','18','iccd'); return false;">Beige</a></li>
								<li class="ivory"><a href="" id="filterstylecolor8" <% if chkArrValue(realarrColorCode,"30") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('color','filterstylecolor8','30','iccd'); return false;">Ivory</a></li>
								<li class="khaki"><a href="" id="filterstylecolor9" <% if chkArrValue(realarrColorCode,"31") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('color','filterstylecolor9','31','iccd'); return false;">Khaki</a></li>
								<li class="green"><a href="" id="filterstylecolor10" <% if chkArrValue(realarrColorCode,"19") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('color','filterstylecolor10','19','iccd'); return false;">Green</a></li>
								<li class="mint"><a href="" id="filterstylecolor11" <% if chkArrValue(realarrColorCode,"32") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('color','filterstylecolor11','32','iccd'); return false;">Mint</a></li>
								<li class="skyblue"><a href="" id="filterstylecolor12" <% if chkArrValue(realarrColorCode,"20") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('color','filterstylecolor12','20','iccd'); return false;">SkyBlue</a></li>
								<li class="blue"><a href="" id="filterstylecolor13" <% if chkArrValue(realarrColorCode,"21") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('color','filterstylecolor13','21','iccd'); return false;">Blue</a></li>
								<li class="navy"><a href="" id="filterstylecolor14" <% if chkArrValue(realarrColorCode,"33") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('color','filterstylecolor14','33','iccd'); return false;">Navy</a></li>
								<li class="violet"><a href="" id="filterstylecolor15" <% if chkArrValue(realarrColorCode,"22") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('color','filterstylecolor15','22','iccd'); return false;">Violet</a></li>
								<li class="lilac"><a href="" id="filterstylecolor16" <% if chkArrValue(realarrColorCode,"34") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('color','filterstylecolor16','34','iccd'); return false;">Lilac</a></li>
								<li class="babypink"><a href="" id="filterstylecolor17" <% if chkArrValue(realarrColorCode,"35") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('color','filterstylecolor17','35','iccd'); return false;">BabyPink</a></li>
								<li class="pink"><a href="" id="filterstylecolor18" <% if chkArrValue(realarrColorCode,"23") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('color','filterstylecolor18','23','iccd'); return false;">Pink</a></li>
								<li class="white"><a href="" id="filterstylecolor19" <% if chkArrValue(realarrColorCode,"7") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('color','filterstylecolor19','7','iccd'); return false;">White</a></li>
								<li class="grey"><a href="" id="filterstylecolor20" <% if chkArrValue(realarrColorCode,"25") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('color','filterstylecolor20','25','iccd'); return false;">Grey</a></li>
								<li class="charcoal"><a href="" id="filterstylecolor21" <% if chkArrValue(realarrColorCode,"36") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('color','filterstylecolor21','36','iccd'); return false;">Charcoal</a></li>
								<li class="black"><a href="" id="filterstylecolor22" <% if chkArrValue(realarrColorCode,"8") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('color','filterstylecolor22','8','iccd'); return false;">Black</a></li>
								<li class="silver"><a href="" id="filterstylecolor23" <% if chkArrValue(realarrColorCode,"26") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('color','filterstylecolor23','26','iccd'); return false;">Silver</a></li>
								<li class="gold"><a href="" id="filterstylecolor24" <% if chkArrValue(realarrColorCode,"27") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('color','filterstylecolor24','27','iccd'); return false;">Gold</a></li>
								<li class="hologram"><a href="" id="filterstylecolor25" <% if chkArrValue(realarrColorCode,"58") then response.write " class='on' " %>  onclick="jsSelectFilterSomething('color','filterstylecolor25','58','iccd'); return false;">Hologram</a></li>
							</ul>
						</div>
					</div>

				</div>
			</div>
		</div>
		<div class="ly-footer">
			<button type="button" class="btn-close" onclick="goSearchDiary();">다이어리 상세검색</button>
		</div>
		<button type="button" class="btn-close-down">닫기</button>
	</div>

	<div id="mask" style="overflow:hidden; display:none; position:fixed; top:0; left:0; z-index:10; width:100%; height:100%; background:rgba(0, 0, 0, 0.5);"></div>

	<!-- #include virtual="/lib/inc/incfooter.asp" -->
</body>
</html>
<%
	Set cDiarycnt = Nothing
	Set PrdBrandList = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
