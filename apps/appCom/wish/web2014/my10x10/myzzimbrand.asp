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
<!-- #include virtual="/apps/appCom/wish/web2014/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
dim  page, vDisp, pagesize, OrderType , chgtype
	page        = requestCheckVar(request("page"),9)
	vDisp       = requestCheckVar(request("disp"),3)
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
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type="text/javascript">
function goPage(page){
	top.location.replace("/apps/appCom/wish/web2014/my10x10/myzzimbrand.asp?page="+page+"&disp=<%=vDisp%>&OrderType=<%=OrderType%>");
}

function fnSearchCat(cdl){
	top.location.replace("/apps/appCom/wish/web2014/my10x10/myzzimbrand.asp?page=1&disp="+cdl+"&OrderType=<%=OrderType%>");
}

function fnSearchSort(srm){
	top.location.replace("/apps/appCom/wish/web2014/my10x10/myzzimbrand.asp?page=1&disp=<%=vDisp%>&OrderType="+srm);
}

function DelFavBrand(id){
	zzfrm.mode.value = "del";
	zzfrm.makerid.value = id;
	zzfrm.action = "/apps/appCom/wish/web2014/my10x10/myzzimbrand_process.asp";
	zzfrm.submit();
}

var vPg=1, vScrl=true;
$(function(){
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

	// 스크롤시 추가페이지 접수
	$(window).scroll(function() {
		if ($(window).scrollTop() >= ($(document).height()-$(window).height())-512){
			if(vScrl) {
				vScrl = false;
				vPg++;
				$.ajax({
					url: "act_myzzimbrand.asp?disp=<%=vDisp%>&OrderType=<%=OrderType%>&page="+vPg,
					cache: false,
					success: function(message) {
						if(message!="") {
							$("#zzimList").append(message);
							vScrl=true;
						} else {
							$(window).unbind("scroll");
						}
					}
					,error: function(err) {
						alert(err.responseText);
						$(window).unbind("scroll");
					}
				});
			}
		}
	});

	// 로딩중 표시
	$("#lyLoading").ajaxStart(function(){
		$(this).show();
	}).ajaxStop(function(){
		$(this).hide();
	});
});
</script>
</head>
<body>
<div class="heightGrid bgGry">
	<div class="container" style="background-color:#f4f4f4;">
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
				<ul class="zzimList" id="zzimList">
					<% If (omyZzimbrand.FResultCount < 1) Then %>
					<li class="noContents"><p>등록하신 찜브랜드가 없습니다.</p></li>
					<% else %>
					<% for i=0 to omyZzimbrand.FResultCount -1 %>
						<li>
							<a href="" onClick="fnAPPpopupBrand('<%= omyZzimbrand.FItemList(i).FMakerid %>'); return false;">
								<div class="box1">
									<div class="pdtInfo">
										<p class="pBrand"><%= omyZzimbrand.FItemList(i).Fsocname %></p>
										<p class="pName"><%= omyZzimbrand.FItemList(i).Fsocname_Kor %></p>
									</div>
									<div class="pic"><img src="<%= omyZzimbrand.FItemList(i).fbasicimage %>" /></div>
								</div>
							</a>
							<button class="btnDel" onclick="DelFavBrand('<%= omyZzimbrand.FItemList(i).FMakerid %>');return false;">찜브랜드 삭제</button>
						</li>
					<% Next %>
					<% End If %>
				</ul>
			</div>
			<div id="lyLoading" style="display:none;position:relative;text-align:center; padding:20px 0;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
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