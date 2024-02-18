<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/street/sp_ZZimBrandCls.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'해더 타이틀
strHeadTitleName = "찜브랜드"

'####################################################
' Description : 마이텐바이텐 - 찜브랜드
' History : 2014-11-17 이종화 
'####################################################
dim  page, vDisp, pagesize, OrderType, chgtype
	page        = requestCheckVar(request("page"),9)
	vDisp         = requestCheckVar(request("disp"),3)
	pagesize    = requestCheckVar(request("pagesize"),9)
	OrderType   = requestCheckVar(request("OrderType"),2)

	if page="" then page=1
	if OrderType="" then OrderType="rg"

'// 정렬방법 통일로 인한 코드 변환
Select Case OrderType
	Case "rg": chgtype = "recent"		'등록순
	Case "nm": chgtype = "brandname"		'이름순
	Case Else: chgtype = "recent"		'기본값(등록순)
End Select

dim omyZzimbrand
	set omyZzimbrand = new CMyZZimBrand
	omyZzimbrand.FRectUserid = getEncLoginUserID
	omyZzimbrand.FCurrPage  = page
	omyZzimbrand.FPageSize  = 12
	omyZzimbrand.FRectDisp   = vDisp
	omyZzimbrand.FRectOrder = chgtype

	'// 로그인상태일경우에만 처리
	if getEncLoginUserID<>"" then
	    omyZzimbrand.GetMyZZimBrand
	end if

dim i, lp

%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script type="text/javascript">
	function goPage(page){
		top.location.href = "/my10x10/myzzimbrand.asp?page="+page+"&disp=<%=vDisp%>&OrderType=<%=OrderType%>";
	}
	
	function changeImgsize(imgsize){
		top.location.href = "/my10x10/myzzimbrand.asp?page=<%=page%>&disp=<%=vDisp%>&OrderType=<%=OrderType%>";
	}
	
	function fnSearchCat(cdl){
		top.location.href = "/my10x10/myzzimbrand.asp?page=1&disp="+cdl+"&OrderType=<%=OrderType%>";
	}
	
	function fnSearchSort(srm){
		top.location.href = "/my10x10/myzzimbrand.asp?page=1&disp=<%=vDisp%>&OrderType="+srm+"";
	}
	
	function TnMyBrandZZim(){
		<% If IsUserLoginOK() Then %>
			jjimfrm.action = "/street/domybrandjjim.asp";
			jjimfrm.submit();
		<% Else %>
			alert("찜브랜드 추가는 로그인이 필요한 서비스입니다.\로그인 하시겠습니까?");
			top.location.href = "<%=M_SSLUrl%>/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>";
		<% End If %>
	}
	
	function DelFavBrand(id){
		zzfrm.mode.value = "del";
		zzfrm.makerid.value = id;
		zzfrm.action = "/my10x10/myzzimbrand_process.asp";
		zzfrm.submit();
	}

$(function() {
	//content area height calculate
	function contHCalc() {
		var contH = $('.content').outerHeight();
		$('.contBlankCover').css('height',contH+'px');
	}

	//Open option Nani control
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

	//Close option Nani control
	$(".contBlankCover").click(function(){
		$(".contBlankCover").fadeOut();
		$(".viewSortV16a div").removeClass('current');
	});
});
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container" style="background-color:#f4f4f4;">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content zzimBrand" id="contentArea">
				<div class="viewSortV16a brandSortV16a">
					<div class="sortV16a">
						<div class="sortGrp category">
						<%
							'정렬상자 호출; sDisp:전시카테고리, sType:확장여부, sCallback:콜백함수명 (via functions.asp)
							Call fnPrntDispCateNaviV16(vDisp,"F","fnSearchCat")
						%>
						</div>
						<div class="sortGrp array">
						<%
							'정렬상자 호출; sType:정렬방법, sUse:사용처 구분, sCallback:콜백함수명 (via functions.asp)
							Call fnPrntSortNaviV16(OrderType,"ij", "fnSearchSort")
						%>
						</div>
					</div>
					<div id="contBlankCover" class="contBlankCover"></div>
				</div>

				<div class="zzimListWrap">
					<ul class="zzimList">
						<% If (omyZzimbrand.FResultCount < 1) Then %>
						<li class="noContents"><p>등록하신 찜브랜드가 없습니다.</p></li>
						<% Else %>
							<% for i=0 to omyZzimbrand.FResultCount -1 %>
							<li>
							    <a href="/brand/brand_detail2020.asp?brandid=<%= omyZzimbrand.FItemList(i).FMakerid %>">
									<div class="box1">
										<div class="pdtInfo">
											<p class="pBrand"><%= omyZzimbrand.FItemList(i).Fsocname %></p>
											<p class="pName"><%= omyZzimbrand.FItemList(i).Fsocname_Kor %></p>
										</div>
										<div class="pic"><img src="<%= omyZzimbrand.FItemList(i).fbasicimage %>" /></div>
										<button class="btnDel" onclick="DelFavBrand('<%= omyZzimbrand.FItemList(i).FMakerid %>');return false;">찜브랜드 삭제</button>
									</div>
								</a>
							</li>
							<% next %>
						<% end if %>
					</ul>
				</div>
				<%= fnDisplayPaging_New(omyZzimbrand.FcurrPage, omyZzimbrand.FtotalCount, omyZzimbrand.FPageSize, 4, "goPage") %>
			</div>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
<form name="zzfrm" method="post" style="margin:0px;" target="zzimbrandiframe">
<input type="hidden" name="mode" value="">
<input type="hidden" name="makerid" value="">
</form>
<iframe name="zzimbrandiframe" frameborder="0" width="0" height="0"></iframe>
</body>
</html>
<%
set omyZzimbrand = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->