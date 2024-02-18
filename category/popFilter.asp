<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/MyCategoryCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<%
Dim vDisp
vDisp =  getNumeric(request("disp"))

dim ReSearchText : ReSearchText=requestCheckVar(request("rstxt"),100) '결과내 재검색용
Dim isShowSumamry : isShowSumamry = true  ''탭별 검색 갯수 표시 여부 : 느릴경우 FALSE 로
Dim SortMet		: SortMet = requestCheckVar(request("srm"),2)
Dim SearchFlag : SearchFlag = requestCheckVar(request("sflag"),2)
Dim ListDiv : ListDiv = "list" '카테고리/검색 구분용 
Dim minPrice : minPrice = getNumeric(requestCheckVar(request("minPrc"),8))
Dim maxPrice : maxPrice = getNumeric(requestCheckVar(request("maxPrc"),8))
Dim deliType : deliType = requestCheckVar(request("deliType"),2)
Dim colorCD : colorCD = requestCheckVar(request("iccd"),128)
dim arrCate : arrCate = ReplaceRequestSpecialChar(request("arrCate"))
dim styleCD : styleCD = ReplaceRequestSpecialChar(request("styleCd"))
dim attribCd : attribCd = ReplaceRequestSpecialChar(request("attribCd"))
Dim CurrPage : CurrPage = getNumeric(requestCheckVar(request("cpg"),6))
dim CheckExcept : CheckExcept= request("chke")
Dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),5))
Dim LogsAccept : LogsAccept = true
Dim makerid : makerid = requestCheckVar(request("mkr"),32)
dim DocSearchText
dim SearchItemDiv : SearchItemDiv="n"	'기본 카테고리만
dim SearchCateDep : SearchCateDep= "T"	'하위카테고리 모두 검색
dim ExceptText : ExceptText=requestCheckVar(request("extxt"),100) '결과내 제외어
dim SellScope 	: SellScope=requestCheckVar(request("sscp"),1)			'품절상품 제외여부
	if SellScope = "" then SellScope = "Y"
dim PrevSearchText : PrevSearchText = requestCheckVar(request("prvtxt"),100) '이전 검색어
dim SearchText : SearchText = requestCheckVar(request("rect"),100) '현재 입력된 검색어
Dim tmpPrevSearchKeyword, tmpCurrSearchKeyword
Dim isSaveSearchKeyword : isSaveSearchKeyword = False  ''검색어 DB에 저장 여부
dim CheckResearch : CheckResearch= request("chkr")
dim IsRealTypedKeyword : IsRealTypedKeyword = True
Dim lp, LicdL,LicdM,LicdS
Dim GRScope, pLicdL, pLicdM, vImgSize, i
	vImgSize = getNumeric(requestCheckVar(request("imgsize"),3))
	if vImgSize = "" Then vImgSize = 290
		
	If vImgSize <> "200" AND vImgSize <> "290" Then
		vImgSize = "290"
	End If

Dim ScrollCount : ScrollCount = 5	
	If CurrPage="" Then CurrPage=1
	If PageSize="" Then PageSize=12
	'If colorCD="" Then colorCD="0"
	If SortMet="" Then SortMet="ne"		'베스트:be, 신상:ne
	IF searchFlag="" Then searchFlag= "n"
	
Dim vColorTmp, vColorScriptSetting, k
vColorTmp = Replace(Trim(colorCD)," ","")
For k = LBound(Split(vColorTmp,",")) To UBound(Split(vColorTmp,","))
	If Split(vColorTmp,",")(k) <> "0" Then
		vColorScriptSetting = vColorScriptSetting & "$('#color" & Split(vColorTmp,",")(k) & "').toggle(); "
	End If
Next
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 상품 필터</title>
<script src="/lib/js/jquery.nouislider.min.js"></script>
<script>
//초기화
function goReload(){
	//가격초기화
	$("form[name=sFrm] > input[name=minPrc]").val("");
	$("form[name=sFrm] > input[name=maxPrc]").val("");
	priceDefault();
	
	//컬러초기화
	$("form[name=sFrm] > input[name=iccd]").val("");
	$(".colorType li").find("em").hide();
	
	//배송초기화
	$("form[name=sFrm] > input[name=deliType]").val("");
	$("input:radio[id=dlvTp]").attr("checked",false);
}

//검색필터 적용하기
function goCategorySearch(){
	var minp = $("#minprice").text().replace(/,/g,'');
	var maxp = $("#maxprice").text().replace(/,/g,'');
	$("form[name=sFrm] > input[name=minPrc]").val(minp);
	$("form[name=sFrm] > input[name=maxPrc]").val(maxp);
	
	sFrm.action = "category_list.asp";
	sFrm.submit();
}

//배송별
function jsDeliverSet(a){
	$("form[name=sFrm] > input[name=deliType]").val(a);
}

//컬러별
function setColorSearch(a) {
	$("#color"+a+"").toggle();
	
	var aa = $("form[name=sFrm] > input[name=iccd]").val();

	if(!(fFindText(aa,a))){
		if(aa == ""){
			aa = a;
		}else{
			aa = aa + "," + a;
		}
	}else{
		aa = aa.replace(a,"");
		aa = aa.replace(",,",",");
		
		if(aa.substring(0,1) == ","){
			aa = aa.substring(1,aa.length);
		}
		
		if(aa.substring(aa.length-1,aa.length) == ","){
			aa = aa.substring(0,aa.length-1);
		}
	}

	
	$("form[name=sFrm] > input[name=iccd]").val(aa);
	//alert($("form[name=sFrm] > input[name=iccd]").val());
}

//컬러별 - 선택 or 해지시 value값 체크
function fFindText(strText,writeText)
{
	var arrText = strText.split(",");
	var trueorfalse = false;

	for(var i=0; i<arrText.length; i++)
	{
		if(writeText == arrText[i])
		{
			trueorfalse = true;
		}
	}

	return trueorfalse;
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<div class="header">
			<h1>필터</h1>
			<p class="btnPopClose"><button class="pButton" onclick="goBack('<%=wwwUrl%>/category/category_list.asp?disp=101'); return false;">닫기</button></p>
			<p class="btnPopRefresh"><button  class="pButton" onclick="goReload()">새로고침</button></p>
		</div>
		<!-- content area -->
		<form name="sFrm" id="listSFrm" method="get" action="category_list.asp" style="margin:0px;">
		<input type="hidden" name="rect" value="<%= SearchText %>">
		<input type="hidden" name="prvtxt" value="<%= PrevSearchText %>">
		<input type="hidden" name="rstxt" value="<%= ReSearchText %>">
		<input type="hidden" name="extxt" value="<%= ExceptText %>">
		<input type="hidden" name="sflag" value="<%= SearchFlag  %>">
		<input type="hidden" name="disp" value="<%= vDisp %>">
		<input type="hidden" name="cpg" value="">
		<input type="hidden" name="chkr" value="<%= CheckResearch %>">
		<input type="hidden" name="chke" value="<%= CheckExcept %>">
		<input type="hidden" name="mkr" value="<%= makerid %>">
		<input type="hidden" name="sscp" value="<%= SellScope %>">
		<input type="hidden" name="psz" value="<%= PageSize %>">
		<input type="hidden" name="srm" value="<%= SortMet %>">
		<input type="hidden" name="iccd" value="<%=colorCD%>">
		<input type="hidden" name="styleCd" value="<%=styleCd%>">
		<input type="hidden" name="attribCd" value="<%=attribCd%>">
		<input type="hidden" name="icoSize" value="">
		<input type="hidden" name="arrCate" value="<%=arrCate%>">
		<input type="hidden" name="deliType" value="<%=deliType%>">
		<input type="hidden" name="minPrc" value="<%=minPrice%>">
		<input type="hidden" name="maxPrc" value="<%=maxPrice%>">
		<input type="hidden" name="lstDiv" value="<%=ListDiv%>">
		</form>
		<div class="content" id="contentArea">
			<!-- 필터 리스트업 -->
			<div class="filterListup">
				<!-- 가격별 -->
				<%
					'// 결과에 해당되는 컬러칩만 표시 //
					dim oGrPrc, vMinPrice, vMaxPrice, vMinRange, vMaxRange
					set oGrPrc = new SearchItemCls
					'' oGrPrc.FRectSortMethod = SortMet		'상품정렬 방법
					oGrPrc.FRectSearchTxt = DocSearchText
					oGrPrc.FRectExceptText = ExceptText
					'' oGrPrc.FminPrice	= minPrice		'가격범위(최소)
					'' oGrPrc.FmaxPrice	= maxPrice		'가격범위(최대)
					'' oGrPrc.FdeliType	= deliType		'배송방법
					oGrPrc.FRectMakerid = makerid
					oGrPrc.FRectSearchCateDep = SearchCateDep
					oGrPrc.FRectCateCode = vDisp
					oGrPrc.FarrCate=arrCate
					oGrPrc.FCurrPage = 1
					oGrPrc.FPageSize = 1
					oGrPrc.FScrollCount =10
					oGrPrc.FListDiv = ListDiv
					oGrPrc.FSellScope=SellScope			'판매/품절상품 포함 여부
					oGrPrc.FLogsAccept = False
				
					oGrPrc.getItemPriceRange
					
					If oGrPrc.FResultCount>0 Then
						vMinPrice = chkIIF(minPrice>0,minPrice,oGrPrc.FItemList(0).FminPrice)
						vMaxPrice = chkIIF(maxPrice>0,maxPrice,oGrPrc.FItemList(0).FmaxPrice)
						vMinRange = oGrPrc.FItemList(0).FminPrice
						vMaxRange = oGrPrc.FItemList(0).FmaxPrice
					Else
						vMinPrice = 10000
						vMaxPrice = 300000
						vMinRange = 10000
						vMaxRange = 300000
					End If
				%>
				<script>
				$(function(){
					// 가격별 검색
					$("#priceRange").noUiSlider({
						start: [<%=vMinPrice%>, <%=vMaxPrice%>],
						connect: true,
						range: {'min': <%=vMinRange%>, 'max': <%=vMaxRange%>},
						serialization: {
							lower: [$.Link({target:$(".minVal span"),format:{decimals: 0, thousand:','},method: "html"})],
							upper: [$.Link({target:$(".maxVal span"),format:{decimals: 0, thousand:','},method: "html"})]
						}
					});
					$('.minVal').appendTo('.noUi-handle-lower');
					$('.maxVal').appendTo('.noUi-handle-upper');
				
					// 컬러별 검색 셋팅
					<%=vColorScriptSetting%>
				});
				
				//컬러 초기화
				function priceDefault(){
					$("#priceRange").val([ <%=vMinRange%>, <%=vMaxRange%> ]);
				}
				</script>
				<h2>가격별</h2>
				<section class="priceType box">
					<div class="rangeWrap">
						<div id="priceRange">
							<p class="minVal"><span id="minprice"></span>원</p>
							<p class="maxVal"><span id="maxprice"></span>원</p>
						</div>
					</div>
				</section>
				<!--// 가격별 -->

				<!-- 컬러별 -->
				<%
					set oGrClr = Nothing
				
					'// 결과에 해당되는 컬러칩만 표시 //
					dim oGrClr
					set oGrClr = new SearchItemCls
					'' oGrClr.FRectSortMethod = SortMet		'상품정렬 방법
					oGrClr.FRectSearchTxt = DocSearchText
					oGrClr.FRectExceptText = ExceptText
					'' oGrClr.FminPrice	= minPrice		'가격범위(최소)
					'' oGrClr.FmaxPrice	= maxPrice		'가격범위(최대)
					'' oGrClr.FdeliType	= deliType		'배송방법
					oGrClr.FRectMakerid = makerid
					oGrClr.FRectSearchCateDep = SearchCateDep
					oGrClr.FRectCateCode = vDisp
					oGrClr.FarrCate=arrCate
					oGrClr.FCurrPage = 1
					oGrClr.FPageSize = 31
					oGrClr.FScrollCount =10
					oGrClr.FListDiv = ListDiv
					oGrClr.FSellScope=SellScope			'판매/품절상품 포함 여부
					oGrClr.FLogsAccept = False
				
					oGrClr.getTotalItemColorCount
				%>
				<h2>컬러별</h2>
				<section class="colorType" id="fttabColor">
					<ul>
					<%
						If oGrClr.FResultCount>0 Then
							FOR lp=0 to oGrClr.FResultCount-1
					%>
						<li onClick="setColorSearch('<%=oGrClr.FItemList(lp).FcolorCode%>')">
							<p class="<%=getColorEng(oGrClr.FItemList(lp).FcolorCode)%>"><em id="color<%=oGrClr.FItemList(lp).FcolorCode%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="<%=getColorEng(oGrClr.FItemList(lp).FcolorCode)%>" /></p>
							<span><%=getColorEng(oGrClr.FItemList(lp).FcolorCode)%></span>
						</li>
					<%
							Next
						end if
					%>
					</ul>
				</section>
				<%
					set oGrClr = Nothing
				
					function getColorEng(ccd)
						dim arrCnm
						if isNumeric(ccd) then
							if cInt(ccd)>31 then 
								getColorEng = "all"
								exit function
							end if
				
							'컬러명 배열로 세팅 (코드순으로 나열)
							arrCnm = split("red,orange,yellow,beige,green,skyblue,blue,violet,pink,brown,white,grey,black,silver,gold,mint,babypink,lilac,khaki,navy,camel,charcoal,wine,ivory,check,stripe,dot,flower,drawing,animal,geometric",",")
				
							'반환
							getColorEng = arrCnm(cInt(ccd)-1)
						else
							getColorEng = "all"
						end if
					end function
				%>
				<!--// 컬러별 -->
				
				<!-- 배송별 -->
				
				<h2>배송별</h2>
				<section class="box deliverType">
					<ul>
						<li><input type="radio" id="dlvTp" name="dlvTp" value="FD" onClick="jsDeliverSet('FD');" <%=chkIIF(deliType="FD","checked","")%> /> <label for="deliver01">무료배송</label></li>
						<li><input type="radio" id="dlvTp" name="dlvTp" value="TN" onClick="jsDeliverSet('TN');" <%=chkIIF(deliType="TN","checked","")%> /> <label for="deliver02">텐바이텐 배송</label></li>
						<li><input type="radio" id="dlvTp" name="dlvTp" value="FT" onClick="jsDeliverSet('FT');" <%=chkIIF(deliType="FT","checked","")%> /> <label for="deliver03">무료+텐바이텐 배송</label></li>
						<li><input type="radio" id="dlvTp" name="dlvTp" value="WD" onClick="jsDeliverSet('WD');" <%=chkIIF(deliType="WD","checked","")%> /> <label for="deliver04">해외배송</label></li>
					</ul>
				</section>
				<!--// 배송별 -->
			</div>
			<!--// 필터 리스트업 -->
		</div>
		<div class="floatingBar">
			<div class="btnWrap">
				<div class="ftBtn"><span class="button btB1 btRed cWh1 w100p"><input type="button" value="검색필터 적용하기" onClick="goCategorySearch();" /></span></div>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->