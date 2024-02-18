<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/MyCategoryCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
	'// 페이지 타이틀
	strPageTitle = ""
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->

<%
'' 앱과 통신에서만 사용됨. 인클루드 부분 바뀌어야 함.

Class cColorChipsItem
    public FcolorCode
    public FcolorName
    Private SUB Class_initialize()

    End SUB
    
    Private SUB Class_Terminate()

	End SUB
End Class

Class cColorChipsCls
    public FItemList()
    
	dim FPageSize
	dim FCurrPage
	dim FScrollCount
	dim FResultCount
	dim FTotalCount
	dim FTotalPage
	
    Private SUB Class_initialize()
        redim preserve FItemList(0)
        
        FResultCount = 0
		FTotalCount = 0
		FPageSize = 10
		FCurrPage = 1
		FPageSize = 30
    End SUB
    
    Private SUB Class_Terminate()

	End SUB
	
    function getValidColorChipsDB()
        dim sqlStr
        sqlstr = " select top 100 colorCode,colorName from db_item.dbo.tbl_colorChips"
        sqlstr = sqlstr & " where isusing='Y'"
        sqlstr = sqlstr & " order by sortno"
        
        rsget.Open sqlStr,dbget,1
        FResultCount = rsget.RecordCount

		redim preserve FItemList(FResultCount)

		if Not(rsget.EOF or rsget.BOF) then
			i=0
			Do until rsget.EOF
				set FItemList(i)          = new cColorChipsItem
				FItemList(i).FcolorCode        = rsget("colorCode")
				FItemList(i).FcolorName        = rsget("colorName")

				i=i+1
				rsget.MoveNext
			loop
		end if
        rsget.close
    end function
End Class

dim filter : filter = request("filter")
dim oJsonResult

Dim vDisp : vDisp =  getNumeric(request("disp"))
Dim makerid : makerid = requestCheckVar(request("brandid"),32)
dim DocSearchText : DocSearchText = requestCheckVar(request("rect"),32)
Dim minPrice : minPrice = getNumeric(requestCheckVar(request("minPrc"),8))
Dim maxPrice : maxPrice = getNumeric(requestCheckVar(request("maxPrc"),8))
Dim colorCD : colorCD = requestCheckVar(request("iccd"),128)
Dim deliType : deliType = requestCheckVar(request("deliType"),2)

Dim ReSearchText : ReSearchText = requestCheckVar(request("rstxt"),2)

''선물포장등(SearchFlag)
Dim SearchFlag : SearchFlag = requestCheckVar(request("sflag"),2)
''품절상품제외
Dim SellScope : SellScope = requestCheckVar(request("sscp"),1)

	

	    
CONST DFT_MinPrc = 0
CONST DFT_MaxPrc = 1000000

''기존 필터를 통으로 받음.
''"filter":filter":{"displaytype":"new","pricelimitlow":"","pricelimithigh":"","color":[],"categoryid":"101101","keyword":"","brandid":"","delitp":""}
dim sortMtd
if (filter<>"") then
    set oJsonResult = JSON.parse(filter)
    ''call getParseFilterPop(oJsonResult, minPrice, maxPrice, colorCD, deliType)
    ''call getParseFilterV3(oJsonResult,sortMtd, minPrice, maxPrice, colorCD, vDisp, DocSearchText, makerid, deliType, ReSearchText)
    call getParseFilterV31(oJsonResult,sortMtd, minPrice, maxPrice, colorCD, vDisp, DocSearchText, makerid, deliType, ReSearchText,SearchFlag,SellScope)
	set oJsonResult = Nothing
end if


Dim ListDiv : ListDiv = "list" '카테고리/검색 구분용 
if (makerid<>"") then ListDiv="brand"
if (DocSearchText<>"") then ListDiv="search"


Dim isShowSumamry : isShowSumamry = true  ''탭별 검색 갯수 표시 여부 : 느릴경우 FALSE 로
Dim SortMet		: SortMet = requestCheckVar(request("srm"),2)


dim arrCate : arrCate = ReplaceRequestSpecialChar(request("arrCate"))
dim styleCD : styleCD = ReplaceRequestSpecialChar(request("styleCd"))
dim attribCd : attribCd = ReplaceRequestSpecialChar(request("attribCd"))
Dim CurrPage : CurrPage = getNumeric(requestCheckVar(request("cpg"),6))
Dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),5))
Dim LogsAccept : LogsAccept = true

dim SearchItemDiv : SearchItemDiv="n"	'기본 카테고리만
dim SearchCateDep : SearchCateDep= "T"	'하위카테고리 모두 검색

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
	''If colorCD="" Then colorCD="0"
	If SortMet="" Then SortMet="ne"		'베스트:be, 신상:ne
	IF searchFlag="" Then searchFlag= "n"
	
Dim vColorTmp, vColorScriptSetting, k
vColorTmp = Replace(Trim(colorCD)," ","")
For k = LBound(Split(vColorTmp,",")) To UBound(Split(vColorTmp,","))
	If Split(vColorTmp,",")(k) <> "0" Then
		vColorScriptSetting = vColorScriptSetting & "$('#color" & Split(vColorTmp,",")(k) & "').toggle(); "
	End If
Next

''브랜드 기본값 품절포함, 이외 품절 제외.
dim defaultSellScope

if (SellScope="") then
    if (ListDiv="brand") then
    
    else
        SellScope="Y"
        
    end if
end if

if (ListDiv="brand") then
    defaultSellScope = ""
else
    defaultSellScope = "Y"
end if


dim userid : userid=getLoginUserid
dim IS_SHOWDEVMSG : IS_SHOWDEVMSG = false

if (userid="icommang" or userid="fun" or userid="qpark99") then
    IS_SHOWDEVMSG = true
end if

IS_SHOWDEVMSG = FALSE
%>
<script src="/apps/appCom/wish/web2014/lib/js/jquery.nouislider.min.js"></script>
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
	
	document.getElementById("sMtxt").value="";
	
	if (document.getElementById("pdeView02")){
        document.getElementById("pdeView02").checked = false;
    }
    
    if (document.getElementById("pdeView01")){
        <% if (defaultSellScope="Y") then %>
            document.getElementById("pdeView01").checked = true;
        <% else %>
            document.getElementById("pdeView01").checked = false;
        <% end if %>
    }
    
}

//검색필터 적용하기
function goCategorySearch(){
	var minp = $(".schOptPriceV15 input[name='minprice']").val().trim();
	var maxp = $(".schOptPriceV15 input[name='maxprice']").val().trim();
	
	if (minp.length<1){
	    alert('가격을 입력하세요.');
	    $(".schOptPriceV15 input[name='minprice']").focus();
	    return;
	}
	
	if (maxp.length<1){
	    alert('가격을 입력하세요.');
	    $(".schOptPriceV15 input[name='maxprice']").focus();
	    return;
	}
	
	if (!IsDigit(minp)){
	    alert('가격을 숫자로입력하세요.');
	    $(".schOptPriceV15 input[name='minprice']").focus();
	    return;
	}
	
	if (!IsDigit(maxp)){
	    alert('가격을 숫자로입력하세요.');
	    $(".schOptPriceV15 input[name='maxprice']").focus();
	    return;
	}
	
	$("form[name=sFrm] > input[name=minPrc]").val(minp);
	$("form[name=sFrm] > input[name=maxPrc]").val(maxp);
	
	<%
	''"filter":{"displaytype":"new","pricelimitlow":"","pricelimithigh":"","color":[],"categoryid":"101101","keyword":"","brandid":"","delitp":"","rstxt":""}
	''//{pricelimitlow: 300, pricelimithigh: 400, color[]} 이방식으로 변경
	%>
	var sortMtd = $("form[name=sFrm] > input[name=sortMtd]").val();
	var disp    = $("form[name=sFrm] > input[name=disp]").val();
	var minPrc  = $("form[name=sFrm] > input[name=minPrc]").val();
	var maxPrc  = $("form[name=sFrm] > input[name=maxPrc]").val();
	var makerid = $("form[name=sFrm] > input[name=makerid]").val();
	var rect    = $("form[name=sFrm] > input[name=rect]").val();
	var deliType = $("form[name=sFrm] > input[name=deliType]").val();
	var iccd = $("form[name=sFrm] > input[name=iccd]").val();

	var color = [];
	var iccdsplt = iccd.split(",");
    for (var i in iccdsplt) {
        var a = {};
        a.colorindex =iccdsplt[i];
        if (a.colorindex){
        color.push(a);
        }
    }
    var sMtxt = document.getElementById("sMtxt").value;  //V3추가
    var sflag = "";
    var sscp  = "<%=defaultSellScope%>";
    
    if (document.getElementById("pdeView02")){
        if (document.getElementById("pdeView02").checked) {
            sflag="pk";
        }else{
            sflag="";
        }
    }
    
    if (document.getElementById("pdeView01")){
        if (document.getElementById("pdeView01").checked) {
            sscp="<%=defaultSellScope%>";
        }else{
            sscp="N";
        }
    }
    
    var isreset = "false";
    if ((minPrc*1==_orgminPrice*1)&&(maxPrc*1==_orgmaxPrice*1)&&(iccd=="")&&(deliType=="")&&(sMtxt=="")&&(sflag=="")&&(sscp=="<%=defaultSellScope%>")){
        isreset = "true";
    }
    
    if (isreset=="true") {
        minPrc  = "";
        maxPrc  = "";
        color   = [];
        deliType ="";
        sMtxt = "";
        sflag = "";
        sscp  = "";
    }
    
	var ifilter = {"pricelimitlow":minPrc,"pricelimithigh":maxPrc,"color":color,"delitp":deliType,"sflag":sflag,"sscp":sscp,"rstxt":sMtxt,"reset":isreset};
	<% if (IS_SHOWDEVMSG) then %>
    alert( JSON.stringify(ifilter));
    <% end if %>
    callNativeFunction('setFilter', ifilter);
    setTimeout("fnAPPclosePopup()",500);
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
	    <% if (IS_SHOWDEVMSG) then %>
	    <% response.write "filter:"&filter %>
	    <br>
	    <input type="button" value="필터초기화" onClick="goReload();" />
	    <% end if %>
		<!-- <div class="header"></div> -->
		<!-- content area -->
		<form name="sFrm" id="listSFrm" method="get" action="category_list.asp" style="margin:0px;">
		<input type="hidden" name="sortMtd" value="<%= sortMtd %>">
		<input type="hidden" name="disp" value="<%= vDisp %>">
		<input type="hidden" name="rect" value="<%= SearchText %>">
		
		<input type="hidden" name="minPrc" value="<%=minPrice%>">
		<input type="hidden" name="maxPrc" value="<%=maxPrice%>">
		<input type="hidden" name="iccd" value="<%=colorCD%>">
		<input type="hidden" name="deliType" value="<%=deliType%>">
		
		<input type="hidden" name="cpg" value="">
		<input type="hidden" name="chkr" value="<%= CheckResearch %>">
		<input type="hidden" name="makerid" value="<%= makerid %>">
		
		<input type="hidden" name="psz" value="<%= PageSize %>">
		<input type="hidden" name="srm" value="<%= SortMet %>">
		<input type="hidden" name="styleCd" value="<%=styleCd%>">
		<input type="hidden" name="attribCd" value="<%=attribCd%>">
		<input type="hidden" name="icoSize" value="">
		<input type="hidden" name="arrCate" value="<%=arrCate%>">
		
		<input type="hidden" name="rstxt" value="<%=ReSearchText%>">
		<input type="hidden" name="sflag" value="<%= SearchFlag  %>">
		<input type="hidden" name="sscp" value="<%= SellScope %>">
		</form>
		<div class="content" id="contentArea">
			<!-- 필터 리스트업 -->
			<div class="filterListupV15">
			    <h2>결과 내 검색</h2>
				<section>
					<div><input type="text" name="sMtxt" id="sMtxt" maxlength="50" value="<%=ReSearchText%>" style="width:100%;" placeholder="검색어를 입력하세요." /></div>
				</section>
			    
			    <h2>상품 보기</h2>
				<section>
					<ul class="schOptShipV15">
						<li><input type="checkbox" id="pdeView01" name="pdeView01"  <%=CHKIIF(SellScope="Y"," checked","")%> /> <label for="pdeView01">품절상품 제외</label></li>
						<% If G_IsPojangok Then %>
						<li><input type="checkbox" id="pdeView02" name="pdeView02"  <%=CHKIIF(SearchFlag="pk"," checked","")%> /> <label for="pdeView02"><img src="http://fiximage.10x10.co.kr/m/2015/common/ico_pkg.png" alt="" style="width:12px; margin-top:2px; vertical-align:top;" /> 선물포장가능 상품 보기</label></li>
						<% End if %>
					</ul>
				</section>
				<!-- 가격별 -->
				<%
					'// 결과에 해당되는 컬러칩만 표시 //
					dim oGrPrc, vMinPrice, vMaxPrice, vMinRange, vMaxRange
					set oGrPrc = new SearchItemCls
					'' oGrPrc.FRectSortMethod = SortMet		'상품정렬 방법
					oGrPrc.FRectSearchTxt = DocSearchText
					'oGrPrc.FRectExceptText = ExceptText
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
				    
				    if (vDisp<>"") or (makerid<>"") or (DocSearchText<>"") then
					    oGrPrc.getItemPriceRange
				    end if
				
					If oGrPrc.FResultCount>0 Then
						vMinPrice = chkIIF(minPrice>0,minPrice,oGrPrc.FItemList(0).FminPrice)
						vMaxPrice = chkIIF(maxPrice>0,maxPrice,oGrPrc.FItemList(0).FmaxPrice)
						vMinRange = oGrPrc.FItemList(0).FminPrice
						vMaxRange = oGrPrc.FItemList(0).FmaxPrice
					Else
						vMinPrice = DFT_MinPrc
						vMaxPrice = DFT_MaxPrc
						vMinRange = DFT_MinPrc
						vMaxRange = DFT_MaxPrc
					End If
				%>
				<script>
				var _orgminPrice = <%=vMinRange%>;
				var _orgmaxPrice = <%=vMaxRange%>;
				$(function(){
					// 가격별 검색
					/*
					$("#priceRange").noUiSlider({
						start: [<%=vMinPrice%>, <%=vMaxPrice%>],
						connect: true,
						range: {'min': <%=vMinRange%>, 'max': <%=vMaxRange%>},
						serialization: {
							lower: [$.Link({target:$(".minVal span"),format:{decimals: 0},method: "html"})],
							upper: [$.Link({target:$(".maxVal span"),format:{decimals: 0},method: "html"})]
						}
					});
					$('.minVal').appendTo('.noUi-handle-lower');
					$('.maxVal').appendTo('.noUi-handle-upper');
				    */
					// 컬러별 검색 셋팅
					<%=vColorScriptSetting%>
				});
				
				//가격 초기화
				function priceDefault(){
				    $(".schOptPriceV15 input[name='minprice']").val(<%=vMinRange%>);
				    $(".schOptPriceV15 input[name='maxprice']").val(<%=vMaxRange%>);
				    
				}
				</script>
				<h2>가격 검색</h2>
				<section>
					<div class="schOptPriceV15">
						<span><input type="text" name="minprice" id="minprice" value="<%=vMinPrice%>" org="<%=vMinRange%>" style="width:100%;" /></span>
						<span>원</span>
						<span class="lPad10">~</span>
						<span class="lPad10"><input type="text" name="maxprice" id="maxprice" value="<%=vMaxPrice%>" org="<%=vMaxRange%>" style="width:100%;" /></span>
						<span>원</span>
					</div>
				</section>
				<!--
				<section class="priceType box">
					<div class="rangeWrap">
						<div id="priceRange">
							<p class="minVal"><span id="minprice"></span>원</p>
							<p class="maxVal"><span id="maxprice"></span>원</p>
						</div>
					</div>
				</section>
				-->
				<!--// 가격별 -->
                
                <!-- 배송별 -->
				
				<h2>배송 선택</h2>
				<section class="box deliverType">
					<ul>
						<li><input type="radio" id="dlvTp" name="dlvTp" value="FD" onClick="jsDeliverSet('FD');" <%=chkIIF(deliType="FD","checked","")%> /> <label for="deliver01">무료배송</label></li>
						<li><input type="radio" id="dlvTp" name="dlvTp" value="TN" onClick="jsDeliverSet('TN');" <%=chkIIF(deliType="TN","checked","")%> /> <label for="deliver02">텐바이텐 배송</label></li>
						<li><input type="radio" id="dlvTp" name="dlvTp" value="FT" onClick="jsDeliverSet('FT');" <%=chkIIF(deliType="FT","checked","")%> /> <label for="deliver03">무료+텐바이텐 배송</label></li>
						<li><input type="radio" id="dlvTp" name="dlvTp" value="WD" onClick="jsDeliverSet('WD');" <%=chkIIF(deliType="WD","checked","")%> /> <label for="deliver04">해외배송</label></li>
					</ul>
				</section>
				<!--// 배송별 -->
				<!-- 컬러별 -->
				<%
					set oGrClr = Nothing
				
					'// 결과에 해당되는 컬러칩만 표시 //
					dim oGrClr
					
					if (vDisp<>"") or (makerid<>"") or (DocSearchText<>"") then
    					set oGrClr = new SearchItemCls
    					'' oGrClr.FRectSortMethod = SortMet		'상품정렬 방법
    					oGrClr.FRectSearchTxt = DocSearchText
    					'oGrClr.FRectExceptText = ExceptText
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
					else
					    set oGrClr = new cColorChipsCls
					    oGrClr.getValidColorChipsDB
				    end if
				%>
				<h2>컬러 검색</h2>
				<section class="schOptColorV15" id="fttabColor">
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
		<div class="floatingBar">
			<div class="btnWrap">
				<div class="ftBtn">
				<span class="button btB1 btRed cWh1 w100p"><input type="button" value="검색필터 적용하기" onClick="goCategorySearch();" /></span></div>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->