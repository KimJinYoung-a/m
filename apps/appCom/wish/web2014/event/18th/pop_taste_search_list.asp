<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 18주년 메인 취향 이벤트 취향 선택 팝업
' History : 2019-09-24 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/lib/classes/award/newawardcls_B.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
	Dim isShowSumamry : isShowSumamry = FALSE  ''탭별 검색 갯수 표시 여부 : 느릴경우 FALSE 로
	dim SearchItemDiv : SearchItemDiv="y"	'기본 카테고리만
	dim SearchCateDep : SearchCateDep= "T"	'하위카테고리 모두 검색
	dim SearchText : SearchText = requestCheckVar(request("rect"),100) '현재 입력된 검색어
	dim SortMet		: SortMet = requestCheckVar(request("srm"),2)
	dim SearchFlag : SearchFlag = NullfillWith(requestCheckVar(request("sflag"),2),"n")
	dim ListDiv : ListDiv = "search"
	dim SubShopCd : SubShopCd = requestCheckVar(request("subshopcd"),3)		' 서브샵코드  100:다이어리스토리(여기선 사용안함)
	dim giftdiv 	: giftdiv=requestCheckVar(request("giftdiv"),1)			'사은품 (R: 다이어리스토리 사은품 )(여기선 사용안함)
	dim minPrice : minPrice = getNumeric(requestCheckVar(Replace(request("minPrc"),",",""),8))'(여기선 사용안함)
	dim maxPrice : maxPrice = getNumeric(requestCheckVar(Replace(request("maxPrc"),",",""),8))'(여기선 사용안함)
	dim deliType : deliType = requestCheckVar(request("deliType"),2)
	dim colorCD : colorCD = requestCheckVar(request("iccd"),128)
	dim CurrPage : CurrPage = getNumeric(requestCheckVar(request("cpg"),6))
	dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),5))
	dim LogsAccept : LogsAccept = true
	dim dispCate : dispCate = getNumeric(requestCheckVar(request("dispCate"),18))
	dim makerid : makerid = ReplaceRequestSpecialChar(request("mkr"))
	dim lp, i
	Dim mode : mode = requestCheckVar(request("mode"),1) ''리스트형 썸네일형
	Dim retUrl : retUrl = requestCheckVar(request("burl"),256)
    dim pojangok : pojangok = requestCheckVar(request("pojangok"),1)
	If retUrl = "" Then retUrl = wwwUrl End If

	dim SellScope 	: SellScope=requestCheckVar(request("sscp"),1)			'품절상품 제외여부
	if SellScope = "" then SellScope = "Y"
	dim arrCate : arrCate = ReplaceRequestSpecialChar(request("arrCate"))
	dim styleCD : styleCD = ReplaceRequestSpecialChar(request("styleCd"))
	dim attribCd : attribCd = ReplaceRequestSpecialChar(request("attribCd"))

	dim CheckResearch : CheckResearch= request("chkr")
	dim CheckExcept : CheckExcept= request("chke")
	dim ReSearchText : ReSearchText=requestCheckVar(request("rstxt"),100) '결과내 재검색용
	dim ExceptText : ExceptText=requestCheckVar(request("extxt"),100) '결과내 제외어
    dim fnumber : fnumber=requestCheckVar(request("fnumber"),100) '상단에 표시할 숫자값
    dim fviewText : fviewText=requestCheckVar(request("fviewText"),200) '상단에 표시할 메인 키워드값
	dim DocSearchText
	Dim tmpPrevSearchKeyword , tmpCurrSearchKeyword

	Dim vCateDepth, vWishArr, search_on, vListOption, vRealResearch
	dim classStr, adultChkFlag, adultPopupLink, linkUrl

    dim oDoc, iLp, objCmd, returnValue, vTotalCount, vItemTotalCount, vItemResultCount

	search_on = requestCheckVar(request("search_on"),2)

    vListOption = "item"

    '// 18주년 특정 키워드는 카테고리 제한
    If Trim(SearchText)="스웨트셔츠" Then
        dispCate = "117"
    End If
    If Trim(SearchText)="카드지갑" Then
        dispCate = "116"
    End If
    If Trim(SearchText)="시계" Then
        dispCate = "122"
    End If
    If Trim(SearchText)="담요" Then
        dispCate = "120"
    End If
    If Trim(SearchText)="조명" Then
        dispCate = "122"
    End If
    If Trim(SearchText)="양말" Then
        dispCate = "117"
    End If
    If Trim(SearchText)="텀블러" Then
        dispCate = "112"
    End If
    If Trim(SearchText)="달력" Then
        dispCate = "101"
    End If
    If Trim(SearchText)="러그" Then
        dispCate = "120"
    End If
    If Trim(SearchText)="필통" Then
        dispCate = "101"
    End If
    If Trim(SearchText)="가습기" Then
        dispCate = "124"
    End If
    If Trim(SearchText)="카드" Then
        dispCate = "101"
    End If
    If Trim(SearchText)="슬리퍼" Then
        dispCate = "116"
    End If
    If Trim(SearchText)="잠옷" Then
        dispCate = "117"
    End If
    If Trim(SearchText)="접시" Then
        dispCate = "112"
    End If
    If Trim(SearchText)="커튼" Then
        dispCate = "120"
    End If

	if dispCate<>"" then
		vCateDepth = cStr(len(dispCate)\3)+1			'하위 뎁스
	else
		vCateDepth = "1"
	end if
	if vCateDepth>3 then vCateDepth=3

	If mode = "" Then mode = "L"

	dim ScrollCount : ScrollCount = 4
	if CurrPage="" then CurrPage=1
    PageSize=24

	'if colorCD="" then colorCD="0"
	if SortMet="" then SortMet="be"		'인기순
	if ListDiv="" then ListDiv="search"

	if CheckResearch="undefined" then CheckResearch=""
	if len(CheckResearch)>5 then CheckResearch=""
	IF CheckResearch="" then CheckResearch=false
	if CheckExcept="undefined" then CheckExcept=""
	if len(CheckExcept)>5 then CheckExcept=""
	IF CheckExcept="" then CheckExcept=false

	''SearchText = RepWord(SearchText,"[^가-힣a-zA-Z0-9.&%\-\_\s]","")
	''ExceptText = RepWord(ExceptText,"[^가-힣a-zA-Z0-9.&%\-\_\s]","")

    SearchText = RepWord(SearchText,"[^ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9.&%+\-\_\s]","")
    ExceptText = RepWord(ExceptText,"[^ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9.&%+\-\_\s]","")

	IF CheckReSearch Then
		''ReSearchText = ReSearchText & " " & SearchText

		ReSearchText = RepWord(ReSearchText,SearchText,"")
		ReSearchText = RepWord(ReSearchText,"[\s]{2,}"," ")
		ReSearchText = RepWord(ReSearchText,"^[+\s]","")
		vRealResearch = ReSearchText
		ReSearchText = ReSearchText & " " & SearchText
		DocSearchText = ReSearchText
	Else
		'ReSearchText  =	SearchText
		DocSearchText = SearchText
	End if

	if CheckExcept then
		ReSearchText  =	ReSearchText
		DocSearchText = ReSearchText
		SearchText = ExceptText
	end if

	'### 실제 입력한 결과내검색어
	ReSearchText = vRealResearch

	'특정 단어 삭제
	DocSearchText = Trim(Replace(DocSearchText,"상품",""))

	IF Len(DocSearchText)<>0 and isNumeric(DocSearchText) THEN
		If Left(DocSearchText,1) <> "0" Then
			DocSearchText = Cdbl(DocSearchText)
		End If
	'	DocSearchText = Cdbl(DocSearchText)
	END IF

    '// 상품검색
    set oDoc = new SearchItemCls
    oDoc.FRectSearchTxt = DocSearchText
    oDoc.FRectSortMethod	= SortMet

    oDoc.FRectSearchFlag = fnSalePojang(searchFlag,pojangok)
    oDoc.FRectSearchItemDiv = SearchItemDiv
    oDoc.FRectCateCode	= dispCate
    oDoc.FRectSearchCateDep = SearchCateDep
    oDoc.FRectMakerid	= fnCleanSearchValue(makerid)
    oDoc.FminPrice	= minPrice
    oDoc.FmaxPrice	= maxPrice
    oDoc.FdeliType	= deliType
    oDoc.FCurrPage = CurrPage
    oDoc.FPageSize = PageSize
    oDoc.FScrollCount = ScrollCount
    oDoc.FListDiv = ListDiv
    oDoc.FLogsAccept = LogsAccept
    oDoc.FRectColsSize = 6
    oDoc.FcolorCode = fnCleanSearchValue(colorCD)
    oDoc.FSellScope=SellScope
    oDoc.FstyleCd = fnCleanSearchValue(styleCd)
    oDoc.FRectNoDealItem = "Y"
    oDoc.getSearchList

    vTotalCount = oDoc.FTotalCount
    vItemResultCount = oDoc.FResultCount
    vItemTotalCount = vTotalCount
    '// 숫자만 입력될경우 체크후 상품페이지로 넘기기
    IF oDoc.FTotalCount=1 and isNumeric(SearchText) Then
        on Error Resume Next

        '// 존재하는 상품인지 검사
        Set objCmd = Server.CreateObject("ADODB.Command")

        objCmd.ActiveConnection = dbget
        objCmd.CommandType = adCmdStoredProc
        objCmd.CommandText = "[db_item].[dbo].sp_Ten_PrdExists"

        objCmd.Parameters.Append objCmd.CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
        objCmd.Parameters.Append objCmd.CreateParameter("@@vItemID",adVarWChar,adParamInput,10,CLng(DocSearchText))

        objCmd.Execute

        returnValue = objCmd("RETURN_VALUE").value

        Set objCmd = Nothing
        IF returnValue=1 Then
            response.redirect "/category/category_itemprd.asp?itemid=" & CLng(DocSearchText)
            dbget.close()	:	response.End
        End IF

        on Error Goto 0

    End if

%>
<script type="text/javascript">

    var isloading=false;

    $(function () {
        // 위시 버튼
        $('.btn-wish').click(function (e) {
            $(this).toggleClass("on");
            return false
        });
    });

    $(window).scroll(function(){
		if ($(window).scrollTop() >= ($(document).height()-$(window).height())-375){
			if (isloading==false){
				isloading=true;

				$("#lyLoading").show();

				var pg = $("#listSFrm input[name='cpg']").val();

				pg++;
				$("#listSFrm input[name='cpg']").val(pg);
				jsSearchListAjax();

				$("#lyLoading").hide();
			}
		}
    });

    function jsSearchListAjax(){
        var formData = $("#listSFrm").serialize().replace(/=(.[^&]*)/g,
            function($0,$1){
            return "="+escape(decodeURIComponent($1)).replace('%26','&').replace('%3D','=')
        });

        var str = $.ajax({
                type: "GET",
                url: "/apps/appCom/wish/web2014/event/18th/act_taste_search_list.asp",
                data: formData,
                dataType: "text",
                async: false
        }).responseText;
        <%'// 실제 컨텐츠 유무 확인을 위한 체크 추가 %>
        if(str!="" && str.indexOf("</li>") > 0) {
            if($("#listSFrm input[name='cpg']").val()=="1") {
                isloading=false;
            } else {
                $str = $(str)
                $('#lyrSrcpdtList').append($str);
            }
            isloading=false;
        } else {
            console.log("contents End...");
            //$(window).unbind("scroll");
        }
    }

    function fnCallParentfnSetTasteArea(iurl, itemid, viewIdx) {
        fnAPPopenerJsCallClose("fnSetTasteArea('"+iurl+"','"+itemid+"','"+viewIdx+"')");
    }
</script>
</head>
<body class="default-font body-popup" style="padding-top:0;">
    <%' contents %>
    <div id="content" class="content anniversary18th pop-taste" >
        <!-- #include virtual="/event/18th/lib/head18th.asp" -->
        <div class="inner">
            <div class="headline">
                <span class="series-num"><%=fnumber%></span>
                <h2><%=fviewText%></h2>
                <span class="sub">가장 마음에 드는 상품에 하트를 눌러 취향을 등록하세요!</span>
            </div>
        </div>
        <ul class="item-list" id="lyrSrcpdtList">
            <% If vTotalCount > 0 Then %>
                <% For i=0 To oDoc.FResultCount-1 %>
                    <% If Trim(oDoc.FItemList(i).FImageBasic) <> "" Then %>
                        <li class="thumbnail">
                            <img src="<%= getThumbImgFromURL(oDoc.FItemList(i).FImageBasic,300,300,"true","false") %>" alt="">
                            <button class="btn-wish" onclick="fnCallParentfnSetTasteArea('<%=oDoc.FItemList(i).FImageBasic%>','<%=oDoc.FItemList(i).FItemID%>', <%= i + ((CurrPage - 1) * PageSize) %>);return false;"></button>
                        </li>
                    <% End If %>
                <% Next %>
            <% End If %>
        </ul>
    </div>
	<!-- //contents -->

	<form name="sFrm" id="listSFrm" method="get" action="/search/search_item.asp" style="margin:0px;">
        <input type="hidden" name="search_on" value="on">
        <input type="hidden" name="rect" value="<%= SearchText %>">
        <input type="hidden" id="rstxt" name="rstxt" value="<%= ReSearchText %>">
        <input type="hidden" name="extxt" value="<%= ExceptText %>">
        <input type="hidden" id="sflag" name="sflag" value="<%= SearchFlag  %>">
        <input type="hidden" id="dispCate" name="dispCate" value="<%= dispCate %>">
        <input type="hidden" id="cpg" name="cpg" value="<%=CurrPage%>">
        <input type="hidden" id="chkr" name="chkr" value="<%= CheckResearch %>">
        <input type="hidden" name="chke" value="<%= CheckExcept %>">
        <input type="hidden" id="mkr" name="mkr" value="<%= makerid %>">
        <input type="hidden" id="sscp" name="sscp" value="<%= SellScope %>">
        <input type="hidden" name="psz" value="<%= PageSize %>">
        <input type="hidden" name="srm" value="<%= SortMet %>">
        <input type="hidden" id="iccd" name="iccd" value="<%=colorCD%>">
        <input type="hidden" id="styleCd" name="styleCd" value="<%=styleCd%>">
        <input type="hidden" name="attribCd" value="<%=attribCd%>">
        <input type="hidden" name="mode" id="mode" value="<%=mode%>">
        <input type="hidden" name="arrCate" value="<%=arrCate%>">
        <input type="hidden" id="deliType" name="deliType" value="<%=deliType%>">
        <input type="hidden" id="minPrc" name="minPrc" value="<%=minPrice%>">
        <input type="hidden" id="maxPrc" name="maxPrc" value="<%=maxPrice%>">
        <input type="hidden" name="lstDiv" value="<%=ListDiv%>">
        <input type="hidden" name="subshopcd" value="<%=subshopcd%>">
        <input type="hidden" name="giftdiv" value="<%=giftdiv%>">
        <input type="hidden" name="burl" value="<%=retUrl%>">
        <input type="hidden" name="itemid" value="">
        <input type="hidden" name="ErBValue" value="99">
        <input type="hidden" name="listoption" value="<%=vListOption%>">
	    <input type="hidden" id="pojangok" name="pojangok" value="<%= pojangok %>">
	</form>
	<div id="gotop" class="btn-top"><button type="button">맨위로</button></div>
	<div id="lyLoading" style="display:none;position:relative;text-align:center; padding:20px 0;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
</body>
</html>
<%
	set oDoc = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
