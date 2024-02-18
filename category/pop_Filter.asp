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
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<%
Dim vDisp
vDisp =  getNumeric(request("disp"))

dim ReSearchText : ReSearchText=requestCheckVar(request("rstxt"),100) '결과내 재검색용
Dim isShowSumamry : isShowSumamry = true  ''탭별 검색 갯수 표시 여부 : 느릴경우 FALSE 로
Dim SortMet		: SortMet = requestCheckVar(request("srm"),2)
Dim SearchFlag : SearchFlag = requestCheckVar(request("sflag"),2)
Dim ListDiv : ListDiv = requestCheckVar(request("lstDiv"),6) '카테고리/검색 구분용 
	if ListDiv="" then ListDiv="list"
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
dim SearchItemDiv : SearchItemDiv="n"	'기본 카테고리만
dim SearchCateDep : SearchCateDep= "T"	'하위카테고리 모두 검색
dim ExceptText : ExceptText=requestCheckVar(request("extxt"),100) '결과내 제외어
dim SellScope 	: SellScope=requestCheckVar(request("sscp"),1)			'품절상품 제외여부
	if SellScope = "" then SellScope = "Y"
dim PrevSearchText : PrevSearchText = requestCheckVar(request("prvtxt"),100) '이전 검색어
dim SearchText : SearchText = requestCheckVar(request("rect"),100) '현재 입력된 검색어
Dim tmpPrevSearchKeyword, tmpCurrSearchKeyword
Dim isSaveSearchKeyword : isSaveSearchKeyword = False  ''검색어 DB에 저장 여부
dim IsRealTypedKeyword : IsRealTypedKeyword = True
Dim lp, LicdL,LicdM,LicdS
Dim GRScope, pLicdL, pLicdM, vImgSize, i
	vImgSize = getNumeric(requestCheckVar(request("imgsize"),3))
	if vImgSize = "" Then vImgSize = 290
		
	If vImgSize <> "200" AND vImgSize <> "290" Then
		vImgSize = "290"
	End If

'// 검색어 관련 처리
	if CheckExcept="undefined" then CheckExcept=""
	if len(CheckExcept)>5 then CheckExcept=""
	IF CheckExcept="" then CheckExcept=false

	SearchText = RepWord(SearchText,"[^가-힣a-zA-Z0-9.&%\-\s]","")
	ExceptText = RepWord(ExceptText,"[^가-힣a-zA-Z0-9.&%\-\s]","")

	ReSearchText = Trim(Replace(ReSearchText,SearchText,""))

	if CheckExcept then
		ReSearchText  =	ReSearchText
		SearchText = ExceptText
	end if
'// 검색어 관련 처리 끗.

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
<script>
//초기화
function goReload(){
	//검색어초기화
	$("form[name=sFrmPop] > input[name=rstxt]").val("");
	$(".filterListupV15 input[name='sMtxt']").val("");

	//가격초기화
	$("form[name=sFrmPop] > input[name=minPrc]").val("");
	$("form[name=sFrmPop] > input[name=maxPrc]").val("");
	priceDefault();
	
	//컬러초기화
	$("form[name=sFrmPop] > input[name=iccd]").val("");
	$(".schOptColorV15 li").find("em").hide();
	
	//배송초기화
	$("form[name=sFrmPop] > input[name=deliType]").val("");
	$("input:radio[name='dlvTp']").attr("checked",false);
}

//검색필터 적용하기
function goCategorySearch(){
	var rect		= document.sFrmPop.rect.value;
	var rstxt		= $(".filterListupV15 input[name='sMtxt']").val();
	//if(rstxt.length>0) {rect = rect + ' ' + rstxt;}
	var disp		= document.sFrmPop.disp.value;
	var mkr			= document.sFrmPop.mkr.value;
	var iccd		= document.sFrmPop.iccd.value;
	var styleCd		= document.sFrmPop.styleCd.value;
	var attribCd	= document.sFrmPop.attribCd.value;
	var deliType	= document.sFrmPop.deliType.value;
	//var minPrc		= $("#minprice").text().replace(/,/g,'');
	//var maxPrc		= $("#maxprice").text().replace(/,/g,'');
	var minPrc		= $(".schOptPriceV15 input[name='minprice']").val();
	var maxPrc		= $(".schOptPriceV15 input[name='maxprice']").val();
	var sflag		= document.sFrmPop.sflag.value;
	var sscp		= document.sFrmPop.sscp.value;

	fnCloseModal();
	goFilterSearch(rect,disp,mkr,iccd,styleCd,attribCd,deliType,minPrc,maxPrc,rstxt,sflag,sscp);
}

//배송별
function jsDeliverSet(a){
	$("form[name=sFrmPop] > input[name=deliType]").val(a);
}

//선물포장
function jsPojangSet(a){
	if($("#pdeView02").is(":checked")){
		$("form[name=sFrmPop] > input[name=sflag]").val(a);
	}else{
		$("form[name=sFrmPop] > input[name=sflag]").val("");
	}
}

//품절상품제외
function jsSoldOutSet(){
	if($("#pdeView01").is(":checked")){
		$("form[name=sFrmPop] > input[name=sscp]").val("Y");
	}else{
		$("form[name=sFrmPop] > input[name=sscp]").val("N");
	}
}

//컬러별
function setColorSearch(a) {
	$("#color"+a+"").toggle();
	
	var aa = $("form[name=sFrmPop] > input[name=iccd]").val();
	if(aa=="0") aa="";

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

	$("form[name=sFrmPop] > input[name=iccd]").val(aa);
}

//컬러별 - 선택 or 해지시 value값 체크
function fFindText(strText,writeText)
{
	var arrText = strText.split(",");
	var trueorfalse = false;

	for(var i=0; i<arrText.length; i++) {
		if(writeText == arrText[i]) {
			trueorfalse = true;
		}
	}

	return trueorfalse;
}

//가격 초기화
function priceDefault(){
	$(".schOptPriceV15 input[name='minprice']").val($(".schOptPriceV15 input[name='minprice']").attr("org"));
	$(".schOptPriceV15 input[name='maxprice']").val($(".schOptPriceV15 input[name='maxprice']").attr("org"));
}

$(function(){
	// 컬러별 검색 셋팅
	<%=vColorScriptSetting%>
});
</script>

<div class="layerPopup">
	<div class="popWin">
		<div class="header">
			<h1>상세검색</h1>
			<p class="btnPopClose"><button class="pButton" onclick="fnCloseModal();">닫기</button></p>
		</div>
		<!-- content area -->
		<form name="sFrmPop" method="get" style="margin:0px;">
		<input type="hidden" name="rect" value="<%= SearchText %>">
		<input type="hidden" name="rstxt" value="<%= ReSearchText %>">
		<input type="hidden" name="disp" value="<%= vDisp %>">
		<input type="hidden" name="mkr" value="<%= makerid %>">
		<input type="hidden" name="iccd" value="<%=colorCD%>">
		<input type="hidden" name="styleCd" value="<%=styleCd%>">
		<input type="hidden" name="attribCd" value="<%=attribCd%>">
		<input type="hidden" name="deliType" value="<%=deliType%>">
		<input type="hidden" name="minPrc" value="<%=minPrice%>">
		<input type="hidden" name="maxPrc" value="<%=maxPrice%>">
		<input type="hidden" name="lstDiv" value="<%=ListDiv%>">
		<input type="hidden" name="sflag" value="<%=SearchFlag%>">
		<input type="hidden" name="sscp" value="<%=SellScope%>">
		</form>
		<div class="content" id="layerScroll" style="bottom:52px;">
			<div id="scrollarea">
				<!-- 필터 리스트업 -->
				<div class="filterListupV15">
					<h2>결과 내 검색</h2>
					<section>
						<div><input type="search" name="sMtxt" maxlength="50" value="<%=ReSearchText%>" style="width:100%;" placeholder="검색어를 입력하세요." /></div>
					</section>

					<h2>상품 보기</h2>
					<section>
						<ul class="schOptShipV15">
							<li><input type="checkbox" id="pdeView01" name="pojangok" onClick="jsSoldOutSet();" <%=CHKIIF(SellScope="Y"," checked","")%> /> <label for="pdeView01">품절상품 제외</label></li>
							<% If G_IsPojangok Then %>
							<li><input type="checkbox" id="pdeView02" name="pojangok" onClick="jsPojangSet('pk');" <%=CHKIIF(SearchFlag="pk"," checked","")%> /> <label for="pdeView02"><img src="http://fiximage.10x10.co.kr/m/2015/common/ico_pkg.png" alt="" style="width:12px; margin-top:2px; vertical-align:top;" /> 선물포장가능 상품 보기</label></li>
							<% End if %>
						</ul>
					</section>

					<!-- 가격별 -->
					<%
						'// 결과에 해당되는 가격범위 표시 //
						dim oGrPrc, vMinPrice, vMaxPrice, vMinRange, vMaxRange
						set oGrPrc = new SearchItemCls
						oGrPrc.FRectSearchTxt = SearchText
						oGrPrc.FRectExceptText = ExceptText
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

						set oGrPrc = Nothing
					%>
					<h2>가격 검색</h2>
					<section>
						<div class="schOptPriceV15">
							<span><input type="text" name="minprice" value="<%=vMinPrice%>" org="<%=vMinRange%>" style="width:100%;" /></span>
							<span>원</span>
							<span class="lPad10">~</span>
							<span class="lPad10"><input type="text" name="maxprice" value="<%=vMaxPrice%>" org="<%=vMaxRange%>" style="width:100%;" /></span>
							<span>원</span>
						</div>
					</section>
					<!--// 가격별 -->
	
					<!-- 배송별 -->
					<h2>배송 선택</h2>
					<section>
						<ul class="schOptShipV15">
							<li><input type="radio" id="deliver01" name="dlvTp" value="FD" onClick="jsDeliverSet('FD');" <%=chkIIF(deliType="FD","checked","")%> /> <label for="deliver01">무료배송</label></li>
							<li><input type="radio" id="deliver02" name="dlvTp" value="TN" onClick="jsDeliverSet('TN');" <%=chkIIF(deliType="TN","checked","")%> /> <label for="deliver02">텐바이텐 배송</label></li>
							<li><input type="radio" id="deliver04" name="dlvTp" value="FT" onClick="jsDeliverSet('FT');" <%=chkIIF(deliType="FT","checked","")%> /> <label for="deliver03">무료+텐바이텐 배송</label></li>
							<li><input type="radio" id="deliver05" name="dlvTp" value="WD" onClick="jsDeliverSet('WD');" <%=chkIIF(deliType="WD","checked","")%> /> <label for="deliver04">해외배송</label></li>
						</ul>
					</section>
					<!--// 배송별 -->
	
					<!-- 컬러별 -->
					<%
						set oGrClr = Nothing
					
						'// 결과에 해당되는 컬러칩만 표시 //
						dim oGrClr
						set oGrClr = new SearchItemCls
						'' oGrClr.FRectSortMethod = SortMet		'상품정렬 방법
						oGrClr.FRectSearchTxt = SearchText
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
					<h2>컬러 검색</h2>
					<div class="schOptColorV15" id="fttabColor">
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
				</div>
				<!--// 필터 리스트업 -->
			</div>
		</div>
		<div class="floatingBarV15">
			<div class="schFloatV15 btnWrap">
				<div style="width:50%;"><span class="button"><a href="" onclick="goReload(); return false;">초기화</a></span></div>
				<div style="width:50%;"><span class="button btnRd0V15"><a href="" onclick="goCategorySearch(); return false;">검색</a></span></div>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->