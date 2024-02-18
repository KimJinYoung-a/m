<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : (M)다이어리스토리2015 리스트
' History : 2014-10-13 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/diarystory2015/lib/worker_only_view.asp" -->
<!-- #include virtual="/diarystory2015/lib/classes/diary_class.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->

<%

	Dim ArrDesign , tmp , iTmp , ctmp, ktmp, arrcontents ,arrkeyword , userid
	dim cate , PageSize , ttpgsz , CurrPage, vGubun, vMDPick, vParaMeter
	dim SortMet	,page, cDiary
	Dim ListDiv, arrColorCode, GiftSu, PrdBrandList, i

	ListDiv	= requestcheckvar(request("ListDiv"),4)
	If ListDiv = "" Then ListDiv = "list"

	If ListDiv = "list" Then
		PageSize = 10
	Else
		PageSize = 10
	End If

	IF SortMet = "" Then SortMet = "newitem"

	ArrDesign = request("arrds")
	arrcontents = request("arrcont")
	arrkeyword = request("arrkey")
	arrColorCode = request("iccd")


	page 		= requestcheckvar(request("page"),2)
	SortMet 	= requestCheckVar(request("srm"),9)
	CurrPage 	= requestCheckVar(request("cpg"),9)
	userid		= getLoginUserID

	IF CurrPage = "" then CurrPage = 1
	IF SortMet = "" Then SortMet = "newitem"
	if page = "" then page = 1

	ArrDesign = request("arrds")
	arrcontents = request("arrcont")
	arrkeyword = request("arrkey")

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

	vParaMeter = "&arrds="&ArrDesign&"&arrcont="&arrcontents&"&arrkey="&arrkeyword&"&iccd="&arrColorCode&"&ListDiv="&ListDiv&""


	'1+1
	Set cDiary = new cdiary_list
		cDiary.getOneplusOneDaily '1+1
		cDiary.getDiaryCateCnt '상태바 count
		GiftSu = cDiary.getGiftDiaryExists(cDiary.FOneItem.Fitemid) '사은품 수

	Set PrdBrandList = new cdiary_list
		'아이템 리스트
		PrdBrandList.FPageSize = PageSize
		PrdBrandList.FCurrPage = CurrPage
		PrdBrandList.frectdesign = sArrDesign
		PrdBrandList.frectcontents = arrcontents
		PrdBrandList.frectkeyword = sarrkeyword
		PrdBrandList.fmdpick = vMDPick
		PrdBrandList.ftectSortMet = SortMet
		PrdBrandList.fuserid = userid
		PrdBrandList.getDiaryItemLIst

	'// 검색결과 내위시 표시정보 접수
	if IsUserLoginOK then
		'// 검색결과 상품목록 작성
		dim rstArrItemid: rstArrItemid=""
		IF PrdBrandList.FResultCount >0 then
			For i=0 To PrdBrandList.FResultCount -1
				rstArrItemid = rstArrItemid & chkIIF(rstArrItemid="","",",") & PrdBrandList.FItemList(i).FItemid
			Next
		End if
		'// 위시결과 상품목록 작성
		dim rstWishItem: rstWishItem=""
		dim rstWishCnt: rstWishCnt=""
		if rstArrItemid<>"" then
			Call getMyFavItemList(getLoginUserid(),rstArrItemid,rstWishItem, rstWishCnt)
		end if
	end if



%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/webview/css/diary2015.css">
<script language="javascript">
	function searchlink(v){
		if (v == "")
		{
			document.location = "/apps/appCom/wish/webview/diarystory2015/list.asp";
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

function goSearchDiary()
{
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

	document.frm_search1.action = "/<%=g_HomeFolder%>/list.asp";
	document.frm_search1.submit();
}

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
		jsOpenModal("/apps/appCom/wish/webview/diarystory2015/search/search.asp?cpg=<%=PrdBrandList.FCurrPage%>&srm=<%=PrdBrandList.ftectSortMet%><%=vParaMeter%>");
	}
</script>
</head>
<body class="diarystory2015">
<div class="heightGrid">
	<div class="mainSection">
		<div class="container bgGry">
			<!-- content area -->
			<div class="content" id="contentArea">
				<form name="sFrm" method="get" action="?" style="margin:0px;">
				<input type="hidden" name="cpg" value="<%=PrdBrandList.FCurrPage %>"/>
				<input type="hidden" name="page" value="<%= PrdBrandList.FPageSize %>"/>
				<input type="hidden" name="srm" value="<%= PrdBrandList.ftectSortMet %>"/>
				<input type="hidden" name="arrds" value="<%= ArrDesign %>"/>
				<input type="hidden" name="ListDiv" value="<%=ListDiv%>"/>
				<input type="hidden" name="arrcont" value="<%=arrcontents%>"/>
				<input type="hidden" name="arrkey" value="<%=arrkeyword%>"/>
				<input type="hidden" name="iccd" value="<%=arrColorCode%>"/>
				<div class="inner10">
					<div class="sorting">
						<p class="selected">
							<select class="selectBox" title="카테고리 선택" onchange="searchlink(this.value);">
								<option value="" <% If Trim(ArrDesign)="" Then %> selected<% End If %>>전체<!--(<%=cDiary.FItemList(2).Fdiarytotcnt%>)--></option>
								<option value="10" <% If Trim(ArrDesign)="10," Then %> selected<% End If %>>Simple<!--(<%=cDiary.FItemList(2).FdiaryCount1%>)--></option>
								<option value="20" <% If Trim(ArrDesign)="20," Then %> selected<% End If %>>illust<!--(<%=cDiary.FItemList(2).FdiaryCount2%>)--></option>
								<option value="30" <% If Trim(ArrDesign)="30," Then %> selected<% End If %>>Pattern<!--(<%=cDiary.FItemList(2).FdiaryCount3%>)--></option>
								<option value="40" <% If Trim(ArrDesign)="40," Then %> selected<% End If %>>Photo<!--(<%=cDiary.FItemList(2).FdiaryCount4%>)--></option>
							</select>
						</p>
						<p <%=CHKIIF(SortMet="newitem","class='selected'","")%>><span class="button"><a href="" onclick="fnSearch(document.sFrm.srm,'newitem');return false;">신상순</a></span></p><%' for dev msg : 클릭시 selected 클래스 붙여주세요(작업시 퍼블리셔 문의) %>
						<p <%=CHKIIF(SortMet="best","class='selected'","")%>><span class="button "><a href="" onclick="fnSearch(document.sFrm.srm,'best');return false;">인기순</a></span></p>
						<% If SortMet="hi" Then %>
							<p class="selected upSort">
								<span class="button priceBtn">
									<a href="" onclick="fnSearch(document.sFrm.srm,'min');return false;">가격순</a>
								</span>
							</p><%' for dev msg : 클릭시 selected upSort / selected downSort / 아무것도 없음 순으로 클래스 변경되야 합니다. %>
						<% ElseIf SortMet="min" Then %>
							<p class="selected downSort">
								<span class="button priceBtn">
									<a href="" onclick="fnSearch(document.sFrm.srm,'hi');return false;">가격순</a>
								</span>
							</p><%' for dev msg : 클릭시 selected upSort / selected downSort / 아무것도 없음 순으로 클래스 변경되야 합니다. %>
						<% Else %>
							<p>
								<span class="button priceBtn">
									<a href="" onclick="fnSearch(document.sFrm.srm,'hi');return false;">가격순</a>
								</span>
							</p><%' for dev msg : 클릭시 selected upSort / selected downSort / 아무것도 없음 순으로 클래스 변경되야 합니다. %>
						<% End If %>

						<p class="selected"><span class="button filterBtn"><a href="" onclick="goModal(); return false;">검색</a></span></p>
					</div>

					<!-- for dev msg : 한페이지당 총 10개 상품 보여주세요 -->
					<div class="diaryList">
						<div class="pdtListWrap">
							<ul class="pdtList">
							<%
								If PrdBrandList.FResultCount > 0 Then
									For i = 0 To PrdBrandList.FResultCount - 1
			
										Dim tempimg
			
										If ListDiv = "list" Then
											tempimg = PrdBrandList.FItemList(i).FDiaryBasicImg
										End If
										If ListDiv = "item" Then
											tempimg = PrdBrandList.FItemList(i).FDiaryBasicImg2
										End If
							%>
								<li <% IF PrdBrandList.FItemList(i).isSoldOut Then%>class="soldOut"<% End If %>>
									<a href="#" onclick="TnGotoProduct('<%=PrdBrandList.FItemList(i).FItemID %>');">
										<%' for dev msg : 웹 다이어리 스토리 리스트와 동일한 이미지 호출해주세요 %>
										<div class="pPhoto"><% IF PrdBrandList.FItemList(i).isSoldOut Then%><p><span><em>품절</em></span></p><% End If %><img src="<%=PrdBrandList.FItemList(i).FDiaryBasicImg%>" alt="<%=PrdBrandList.FItemList(i).FItemName%>"></div>
										<div class="pdtCont">
											<p class="pBrand"><a href="/street/street_brand.asp?makerid=<%=PrdBrandList.FItemList(i).FMakerId %>">by <%=PrdBrandList.FItemList(i).FBrandName%></a></p>
											<p class="pName"><a href="#" onclick="TnGotoProduct('<%=PrdBrandList.FItemList(i).FItemID %>');"><%=PrdBrandList.FItemList(i).FItemName%></a></p>
											<p class="pPrice">
												<%
														IF PrdBrandList.FItemList(i).IsSaleItem or PrdBrandList.FItemList(i).isCouponItem Then
															If  PrdBrandList.FItemList(i).getRealPrice <> PrdBrandList.FItemList(i).FSellCash then
																IF PrdBrandList.FItemList(i).IsSaleItem then
												%>
																<%=FormatNumber(PrdBrandList.FItemList(i).getRealPrice,0) %>원
												<%
																End If
																IF PrdBrandList.FItemList(i).IsCouponItem then
												%>
																<%= FormatNumber(PrdBrandList.FItemList(i).GetCouponAssignPrice,0)%>원
												<%
																End If
															Else
												%>
																<%= FormatNumber(PrdBrandList.FItemList(i).GetCouponAssignPrice,0)%>원
												<%
															End If
														ELSE
												%>
															<%= FormatNumber(PrdBrandList.FItemList(i).FSellCash,0)%>원
												<%
														End If
												%>

											</p>
											<p class="pShare">
												<span class="cmtView" onclick="popEvaluate('<%=PrdBrandList.FItemList(i).FItemid%>');"><%= FormatNumber(PrdBrandList.FItemList(i).FEvalcnt,0) %></span>
												<span class="wishView" onclick="goWishPop('<%= PrdBrandList.FItemList(i).FItemID %>');"><%= FormatNumber(PrdBrandList.FItemList(i).FFavCount,0) %></span>
											</p>
										</div>
									</a>
								</li>
								<%
										next
									End If
								%>
							</ul>
						</div>
					</div>
					<div class="paging">
						<%= fnDisplayPaging_New(CurrPage,PrdBrandList.FTotalCount,PageSize,4,"jsGoPage") %>
					</div>
					</form>

				</div>

			</div>
			<div id="modalCont" style="display:none;"></div>
			<!-- //content area -->
		</div>
	</div>

</div>
</body>
</html>

<%
	Set PrdBrandList = Nothing
	'Set oMainContents = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->