<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : (M)다이어리스토리2016 아이템 리스트
' History : 2016-09-21 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/diarystory2017/lib/worker_only_view.asp" -->
<!-- #include virtual="/diarystory2017/lib/classes/diary_class_B.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%

	Dim ArrDesign , tmp , iTmp , ctmp, ktmp, arrcontents ,arrkeyword , userid, limited, rdsearch
	dim cate , PageSize , ttpgsz , CurrPage, vGubun, vMDPick, vParaMeter, vParaMeterCG
	dim SortMet	,page, cDiary
	Dim ListDiv, arrColorCode, GiftSu, PrdBrandList, i

	ListDiv	= requestcheckvar(request("ListDiv"),4)
	If ListDiv = "" Then ListDiv = "list"

	If ListDiv = "list" Then
		PageSize = 10
	Else
		PageSize = 10
	End If

	IF SortMet = "" Then SortMet = "best"

	rdsearch = request("rdsearch")
	ArrDesign = request("arrds")
	arrcontents = request("arrcont")
	arrkeyword = request("arrkey")
	arrColorCode = request("iccd")

	limited = request("limited")
	if limited = "" then limited = "x"

	page 		= requestcheckvar(request("page"),2)
	SortMet 	= requestCheckVar(request("srm"),9)
	CurrPage 	= requestCheckVar(request("cpg"),9)
	userid		= getLoginUserID

	IF CurrPage = "" then CurrPage = 1
	IF SortMet = "" Then SortMet = "newitem"
	if page = "" then page = 1

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
			tmp  = tmp & "'" & requestcheckvar(arrcontents(cTmp),10) & "'" &","
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
'	if IsUserLoginOK then
'		'// 검색결과 상품목록 작성
'		dim rstArrItemid: rstArrItemid=""
'		IF PrdBrandList.FResultCount >0 then
'			For i=0 To PrdBrandList.FResultCount -1
'				rstArrItemid = rstArrItemid & chkIIF(rstArrItemid="","",",") & PrdBrandList.FItemList(i).FItemid
'			Next
'		End if
'		'// 위시결과 상품목록 작성
'		dim rstWishItem: rstWishItem=""
'		dim rstWishCnt: rstWishCnt=""
'		if rstArrItemid<>"" then
'			Call getMyFavItemList(getLoginUserid(),rstArrItemid,rstWishItem, rstWishCnt)
'		end if
'	end if
%>
<link rel="stylesheet" type="text/css" href="/lib/css/diary2017.css" />
<script type="text/javascript">
$(function(){
	function contHCalc() {
		var contH = $('.content').outerHeight();
		$('.contBlankCover').css('height',contH+'px');
	}

	$(".viewSortV16a button").click(function(){
		if($(this).parent('.sortGrp').hasClass('current')){
			$(".sortGrp").removeClass('current');
			$("#contBlankCover").fadeOut();
		} else {
			$(".sortGrp").removeClass('current');
			$(this).parent('.sortGrp').addClass('current');
			$("#contBlankCover").fadeIn();
			contHCalc();
		}
	});

	$(".contBlankCover").click(function(){
		$(".contBlankCover").fadeOut();
		$(".viewSortV16a div").removeClass('current');
	});

	$(".sortNaviV16a li a").click(function(e){
		e.preventDefault()
		var selectTxt = $(this).text();
		$(this).parents('.sortNaviV16a').find('li').removeClass('selected');
		$(this).parent('li').addClass('selected');
		$(this).parents('.sortGrp').children('button').text(selectTxt);
		$(this).parents('.sortGrp').removeClass('current');
		$(".contBlankCover").fadeOut();
	});

	// breadcrumb
	var mySwiper0 = new Swiper('.breadcrumbV15a .swiper-container',{
		pagination:false,
		freeMode:true,
		freeModeFluid:true,
		visibilityFullFit:true,
		initialSlide:2, //for dev msg : breadcrumb 슬라이드 갯수(-1)만큼 적용되도록 처리해주세요
		slidesPerView: 'auto'
	})
});

function searchlink(v){
	if (v == "")
	{
		document.location = "/apps/appcom/wish/web2014/diarystory2016/list.asp";
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

//체크박스 전체선택 해제
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

function goModal()
{
	parent.fnAPPpopupBrowserURL("다이어리 검색","<%=wwwUrl%>/apps/appcom/wish/web2014/diarystory2017/search/search.asp?cpg=<%=PrdBrandList.FCurrPage%>&srm=<%=PrdBrandList.ftectSortMet%><%=vParaMeter%>","","diarysearch");return false;
}

function goSearchAppsModal(vpara){
	location.href="/apps/appcom/wish/web2014/diarystory2017/list.asp?"+vpara
}

function fncatesearch(ccd){
	location.href="/apps/appcom/wish/web2014/diarystory2017/list.asp?cpg=1&srm=<%=SortMet%>&arrds="+ccd+"&<%=vParaMeterCG%>";
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container diaryList">
			<!-- content area -->
			<div class="content ctgyListV15a" id="contentArea">
			<form name="sFrm" method="get" action="?" style="margin:0px;">
			<input type="hidden" name="cpg" value="<%=PrdBrandList.FCurrPage %>"/>
			<input type="hidden" name="page" value="<%= PrdBrandList.FPageSize %>"/>
			<input type="hidden" name="srm" value="<%= PrdBrandList.ftectSortMet %>"/>
			<input type="hidden" name="arrds" value="<%= ArrDesign %>"/>
			<input type="hidden" name="ListDiv" value="<%=ListDiv%>"/>
			<input type="hidden" name="arrcont" value="<%=arrcontents%>"/>
			<input type="hidden" name="arrkey" value="<%=arrkeyword%>"/>
			<input type="hidden" name="iccd" value="<%=arrColorCode%>"/>
			<input type="hidden" name="limited" value="<%=limited%>"/>
			<input type="hidden" name="rdsearch" value="<%=rdsearch%>"/>
				<!-- breadcrumb -->
				<div class="breadcrumbV15a">
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<em class="swiper-slide"><a href="/apps/appcom/wish/web2014/diarystory2017/list.asp">다이어리 전체 (<%= cDiarycnt.FItemList(2).Fdiarytotcnt %>)</a></em>
							<% if rdsearch <> "" then %>
								<em class="swiper-slide">검색결과 (<%=PrdBrandList.FTotalCount %>)</em>
							<% else %>
								<% if ArrDesign <> "" then %>
									<em class="swiper-slide">
										<a href="">
											<% if ArrDesign = "" then %>
												카테고리
											<% elseif ArrDesign = "10," then %>
												Simple
												(<%= cDiarycnt.FItemList(2).FdiaryCount1 %>)
											<% elseif ArrDesign = "20," then %>
												illust
												(<%= cDiarycnt.FItemList(2).FdiaryCount2 %>)
											<% elseif ArrDesign = "30," then %>
												Pattern
												(<%= cDiarycnt.FItemList(2).FdiaryCount3 %>)
											<% elseif ArrDesign = "40," then %>
												Photo
												(<%= cDiarycnt.FItemList(2).FdiaryCount4 %>)
											<% elseif ArrDesign = "50," then %>
												카테고리
											<% end if %>
										</a>
									</em>
								<% end if %>
							<% end if %>
						</div>
					</div>
				</div>

				<!-- sorting -->
				<div class="viewSortV16a ctgySortV16a">
					<div class="sortV16a">
						<div class="sortGrp category">
							<button type="button">
							<%
							select case ArrDesign
								case ""
									response.write "전체 카테고리"
								case "10,"
									response.write "Simple"
								case "20,"
									response.write "illust"
								case "30,"
									response.write "Pattern"
								case "40,"
									response.write "Photo"
								case else
									response.write "전체 카테고리"
							end select
							%>
							</button>
							<div class="sortNaviV16a">
								<ul>
									<li <% If Trim(ArrDesign)="arrds=" Then %>class="selected"<% End If %>><a href="" onclick="fncatesearch(); return false;">전체</a></li>
									<li <% If Trim(ArrDesign)="arrds=10," Then %>class="selected"<% End If %>><a href="" onclick="fncatesearch('10,'); return false;">Simple</a></li>
									<li <% If Trim(ArrDesign)="arrds=20," Then %>class="selected"<% End If %>><a href="" onclick="fncatesearch('20,'); return false;">illust</a></li>
									<li <% If Trim(ArrDesign)="arrds=30," Then %>class="selected"<% End If %>><a href="" onclick="fncatesearch('30,'); return false;">Pattern</a></li>
									<li <% If Trim(ArrDesign)="arrds=40," Then %>class="selected"<% End If %>><a href="" onclick="fncatesearch('40,'); return false;">Photo</a></li>
								</ul>
							</div>
						</div>
						<div class="sortGrp array">
							<button type="button">
								<%
								select case SortMet
									case "newitem"
										response.write "신규순"
									case "best"
										response.write "인기순"
									case "eval"
										response.write "리뷰등록순"
									case "hi"
										response.write "높은가격순"
									case "min"
										response.write "낮은가격순"
								end select
								%>
							</button>
							<div class="sortNaviV16a">
								<ul>
									<li <%=CHKIIF(SortMet="newitem","class='selected'","")%>><a href="" onclick="fnSearch(document.sFrm.srm,'newitem'); return false;">신규순</a></li>
									<li <%=CHKIIF(SortMet="best","class='selected'","")%>><a href="" onclick="fnSearch(document.sFrm.srm,'best'); return false;">인기순</a></li>
									<li <%=CHKIIF(SortMet="eval","class='selected'","")%>><a href="" onclick="fnSearch(document.sFrm.srm,'eval'); return false;">리뷰등록순</a></li>
									<li <%=CHKIIF(SortMet="hi","class='selected'","")%>><a href="" onclick="fnSearch(document.sFrm.srm,'hi');return false;">높은가격순</a></li>
									<li <%=CHKIIF(SortMet="min","class='selected'","")%>><a href="" onclick="fnSearch(document.sFrm.srm,'min');return false;">낮은가격순</a></li>
								</ul>
							</div>
						</div>
						<div class="sortGrp linkBtn">
							<p><a href="" onclick="goModal(); return false;" class="findBtn"><span>다이어리 찾기</span></a></p>
						</div>
					</div>
					<div id="contBlankCover" class="contBlankCover"></div>
				</div>

				<!-- list -->
				<section class="itemWrapV15a">
					<div class="pdtListWrapV15a">
						<ul class="pdtListV15a">
						<%
						If PrdBrandList.FResultCount > 0 Then
							For i = 0 To PrdBrandList.FResultCount - 1
	
								Dim tempimg
	
								If ListDiv = "list" Then
									tempimg = PrdBrandList.FItemList(i).FDiaryBasicImg2
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
								<li onclick="fnAPPpopupProduct('<%=PrdBrandList.FItemList(i).FItemID %>');" <% IF PrdBrandList.FItemList(i).isSoldOut Then%>class="soldOut"<% End If %>>
									<div class="pPhoto">
										<% IF PrdBrandList.FItemList(i).isSoldOut Then%><p><span><em>품절</em></span></p><% End If %>
										<img src="<%=PrdBrandList.FItemList(i).FDiaryBasicImg2%>" alt="<%=PrdBrandList.FItemList(i).FItemName%>">
									</div>
									<div class="pdtCont">
										<p class="pBrand"><%=PrdBrandList.FItemList(i).FBrandName%></p>
										<p class="pName"><%=PrdBrandList.FItemList(i).FItemName%></p>
										<% if PrdBrandList.FItemList(i).IsSaleItem or PrdBrandList.FItemList(i).isCouponItem Then %>
											<% IF PrdBrandList.FItemList(i).IsSaleItem then %>
												<p class="price" onclick="fnAPPpopupProduct('<%=PrdBrandList.FItemList(i).FItemID %>');"><%=FormatNumber(PrdBrandList.FItemList(i).getRealPrice,0)%>원 <span class="cRd1">[<%=PrdBrandList.FItemList(i).getSalePro%>]</span></p>
											<% End If %>
											<% IF PrdBrandList.FItemList(i).IsCouponItem Then %>
												<p class="price" onclick="fnAPPpopupProduct('<%=PrdBrandList.FItemList(i).FItemID %>');"><%=FormatNumber(PrdBrandList.FItemList(i).GetCouponAssignPrice,0)%>원 <span class="cGr1">[<%=PrdBrandList.FItemList(i).GetCouponDiscountStr%>]</span></p>
											<% end if %>
										<% else %>
											<p class="price" onclick="fnAPPpopupProduct('<%=PrdBrandList.FItemList(i).FItemID %>');"><%=FormatNumber(PrdBrandList.FItemList(i).getRealPrice,0) & chkIIF(PrdBrandList.FItemList(i).IsMileShopitem,"Point","원")%></p>
										<% end if %>
										<p class="pShare">
											<span class="cmtView" onclick="popEvaluate('<%=PrdBrandList.FItemList(i).FItemid%>');"><%= FormatNumber(PrdBrandList.FItemList(i).FEvalcnt,0) %></span>
											<span class="wishView" onclick="goWishPop('<%= PrdBrandList.FItemList(i).FItemID %>');"><%= FormatNumber(PrdBrandList.FItemList(i).FFavCount,0) %></span>
											<% If G_IsPojangok Then %>
											<% IF PrdBrandList.FItemList(i).IsPojangitem Then %><i class="pkgPossb">선물포장 가능상품</i><% End if %>
											<% End if %>											
										</p>
									</div>
								</li>
						<%
							next
						End If
						%>
						</ul>
					</div>

					<!-- pagination -->
					<div class="pagingV15a">
						<%= fnDisplayPaging_New(CurrPage,PrdBrandList.FTotalCount,PageSize,4,"jsGoPage") %>
					</div>
				</section>

			</div>
			<!-- //content area -->
			<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>
<%
	Set cDiarycnt = Nothing
	Set PrdBrandList = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
