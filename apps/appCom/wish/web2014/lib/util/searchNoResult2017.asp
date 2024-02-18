<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
dim DocSearchText : DocSearchText = requestCheckVar(request("rect"),32)
%>
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<script type='text/javascript'>
function researchApp(irect){
    location.href='tenwishapp://App_search?rect='+encodeURIComponent(irect);
    //location.href='tenwishapp://App_search?rect='+(irect);
}
</script>
</head>
<body class="default-font">

<%
	Dim vSScrnGubun, vSScrnMasking
	vSScrnMasking = fnMaskingImage()
	vSScrnGubun = Split(vSScrnMasking,"$$")(0)
	vSScrnMasking = Split(vSScrnMasking,"$$")(1)
	If vSScrnGubun = "i" Then
		vSScrnMasking = "style=""background-image:url(" & vSScrnMasking & ");"""
	ElseIf vSScrnGubun = "c" Then
		vSScrnMasking = "style=""background-color:" & vSScrnMasking & ";"""
	End If
	
	'### 
	dim Docruzer, seed_str, vResultWord
	'검색어 접수	
	seed_str = DocSearchText
	
	'독크루저 컨퍼넌트 선언
	SET Docruzer = Server.CreateObject("ATLKSearch.Client")
	
	if Docruzer.BeginSession()<0 then
		'에러시 메세지 표시
		Response.Write "BeginSession: " & Docruzer.GetErrorMessage()
	else
	    IF NOT DocSetOption(Docruzer) THEN
			Response.Write "SetOption: " & Docruzer.GetErrorMessage()
		ELSE
    		'실행
    		Call doMain(seed_str, vResultWord)
    		Call Docruzer.EndSession()
    	End if
	end if
	
	'독크루저 종료
	Set Docruzer = Nothing
    
    public function DocSetOption(iDocruzer)
        dim ret 
        ret = iDocruzer.SetOption(iDocruzer.OPTION_REQUEST_CHARSET_UTF8,1)
        DocSetOption = (ret>=0)
    end function
    
	'메인실행 함수
	Sub doMain(seed_str, vResultWord)
		Dim SvrAddr, SvrPort
		Dim ret, i, nFlag, cnv_str, max_count
		Dim kwd_count, result_word
		Dim objXML, objXMLv

		IF application("Svr_Info")	= "Dev" THEN
		    ''SvrAddr = "110.93.128.108"''2차실서버
			SvrAddr = "192.168.50.10"'DocSvrAddr(테섭)
			'SvrAddr = "110.93.128.106"
		ELSE
			''SvrAddr = "192.168.0.109"'DocSvrAddr(실섭)
			SvrAddr = "192.168.0.206"
			'SvrAddr = "110.93.128.106"
		END IF

		if (Application("G_ORGSCH_ADDR")="") then
			Application("G_ORGSCH_ADDR")=SvrAddr
		end if

		SvrAddr = Application("G_ORGSCH_ADDR")
		
		SvrPort = "6167"			'DocSvrPort

		max_count = 1	'최대 검색 수

		'대체 검색
		ret = Docruzer.SpellCheck( _
					SvrAddr & ":" & SvrPort _
					,kwd_count, result_word, max_count, seed_str)
'Response.Write "check: " & kwd_count
		'에러 출력
		if(ret<0) then
			Response.Write "Error: " & Docruzer.GetErrorMessage()
			exit Sub
		end if

			'-----프로세스 시작
			for i=0 to kwd_count-1
				vResultWord = result_word(i)
			next
	end Sub
	
If vResultWord <> "" Then
%>
<div class="search-replace">
	<div class="bg" <%=vSScrnMasking%>></div>
	<div class="inner">
		<p>혹시 <strong><%=vResultWord%></strong> 찾으셨나요?</p>
		<div class="btn-group">
			<a href="" onClick="researchApp('<%=DocSearchText%>'); return false;" class="btn-flat"><%=vResultWord%> 검색결과 보기</a>
		</div>
	</div>
</div>
<% End If %>

	<!-- contents -->
	<div class="content search-content">
		<div class="nodata nodata-search">
			<p><b>아쉽게도 일치하는 내용이 없습니다</b></p>
			<p>품절 또는 종료된 경우에는 검색되지 않습니다</p>
		</div>

		<section class="searching-keyword">
			<h2>혹시 이런건 어떠세요?</h2>
			<div class="list-roundbox">
<%
		'// 인기검색어
		DIM oPpkDoc, arrPpk, arrTg, arrMyKwd, mykeywordloop
		SET oPpkDoc = New SearchItemCls
			oPpkDoc.FPageSize = 8
			'arrPpk = oPpkDoc.getPopularKeyWords()			'일반형태
			oPpkDoc.getPopularKeyWords2 arrPpk,arrTg		'순위정보 포함
		SET oPpkDoc = NOTHING
		
		If isArray(arrPpk)  THEN
			If Ubound(arrPpk)>0 then
				For mykeywordloop=0 To UBOUND(arrPpk)
					if trim(arrPpk(mykeywordloop))<>"" then
						Response.Write "<a href="""" onClick=""researchApp('" & arrPpk(mykeywordloop) & "'); return false;"">"
						Response.Write arrPpk(mykeywordloop) & "</a>" & vbCrLf
					end if
				Next
			End If
		End If
%>
			</div>
		</section>

<%
'#######################################################
'	History	:  2015.06.15 허진원 생성
'	Description : 베스트셀러
'                 검색결과가 없을때 BEST순(itemscroe) 상품 목록
'#######################################################

	'// 베스트 상품 접수
	Dim oKDoc, lp
	set oKDoc = new SearchItemCls
	oKDoc.FRectSortMethod	= "be"			'Best순
	oKDoc.FRectSearchCateDep = "T"
	oKDoc.FRectSearchItemDiv = "y"
	oKDoc.FCurrPage = 1
	oKDoc.FPageSize = 10
	oKDoc.FScrollCount = 0
	oKDoc.FListDiv = "bestlist"
	oKDoc.FSellScope="Y"
	oKDoc.FRectSearchFlag = "n"
	'oKDoc.FminPrice	= "6000"			'최소 금액제한

	oKDoc.getSearchList

	if oKDoc.FResultCount>0 then
%>
		<section class="suggestion-bestseller">
			<h2>가끔은 베스트셀러도 좋아요!</h2>
			<div class="items type-list">
				<ul>
					<% For lp=0 To (oKDoc.FResultCount-1) %>
					<li>
						<a href="" onClick="fnAPPpopupProduct_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=oKDoc.FItemList(lp).FItemid%>'); return false;">
							<div class="thumbnail"><img src="<%=getThumbImgFromURL(oKDoc.FItemList(lp).FImageBasic,286,286,"true","false")%>" alt="" /></div>
							<div class="desc">
								<b class="no"><%=Num2Str(lp+1,2,"0","R")%></b>
								<span class="brand"><%=oKDoc.FItemList(lp).FBrandName%></span>
								<p class="name"><%=oKDoc.FItemList(lp).FItemName%></p>
								<div class="price">
									<% IF oKDoc.FItemList(lp).IsSaleItem or oKDoc.FItemList(lp).isCouponItem Then %>
										<% IF oKDoc.FItemList(lp).IsSaleItem Then %>
											<div class="unit"><b class="sum"><% = FormatNumber(oKDoc.FItemList(lp).getRealPrice,0) %><span class="won">원</span></b> <b class="discount red"><% = oKDoc.FItemList(lp).getSalePro %></b></div>
										<% End IF %>
										<% IF oKDoc.FItemList(lp).IsCouponItem AND oKDoc.FItemList(lp).GetCouponDiscountStr <> "무료배송" Then %>
											<div class="unit"><b class="sum"><% = FormatNumber(oKDoc.FItemList(lp).GetCouponAssignPrice,0) %><span class="won">원</span></b> <b class="discount green"><% = oKDoc.FItemList(lp).GetCouponDiscountStr %></b></div>
										<% End IF %>
									<% Else %>
										<div class="unit"><b class="sum"><% = FormatNumber(oKDoc.FItemList(lp).getRealPrice,0) %><span class="won"><% if oKDoc.FItemList(lp).IsMileShopitem then %> Point<% else %> 원<% end  if %></span></b></div>
									<% End if %>
								</div>
							</div>
						</a>
					</li>
					<% Next %>
				</ul>
			</div>
			<div class="btn-group">
				<a href="" onClick="fnAPPpopupBest_URL('http://m.10x10.co.kr/apps/appcom/wish/web2014/award/awarditem.asp?gnbflag=1');return false;" class="btn-more"><span>더 보기</span></a>
			</div>
		</section>
<%
	End if

	set oKDoc = Nothing
%>
	</div>
	<!-- //contents -->

	<div id="gotop" class="btn-top"><button type="button">맨위로</button></div>
	<div id="mask" style="overflow:hidden; display:none; position:absolute; top:0; left:0; z-index:10; width:100%; height:100%; background:rgba(0, 0, 0, 0.5);"></div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->