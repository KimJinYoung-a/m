<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
response.charset = "utf-8"
%>
<%
'####################################################
' Description :  카테고리 리스트
' History : 2013.12.13 한용민 생성
' History : 2014.02.13 이종화 추가 수정
' History : 2014.09.03 이종화 renewal
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/MyCategoryCls.asp" -->
<!-- #include virtual="/lib/classes/award/newawardcls_B.asp" -->
<!-- #include virtual="/lib/classes/search/search43cls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CateMdPickCls_B.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
Dim oGrCat, vDepth, lp, vDisp, currentDisplayCateName, currentDisplayCateisnew , currentDisplayCateishot
	vDisp =  getNumeric(request("disp"))

if vDisp = "" then
	response.write "<script type='text/javascript'>"
	response.write "	alert('정상적인 경로가 아닙니다.');"
	response.write "	history.back()"
	response.write "</script>"
	dbget.close() : response.end
end if

vDepth = (Len(vDisp)/3)

Set oGrCat = new MyCategoryCls
	oGrCat.FDepth = vDepth+1
	oGrCat.FDisp = vDisp
	if	vDepth="1" then
	oGrCat.fnDisplayCategoryList
	End If 

dim cateinfocurr , catetag
set cateinfocurr = new MyCategoryCls
	oGrCat.FDisp = vDisp
	oGrCat.fnDisplayCategoryone

	if oGrCat.ftotalcount > 0 then
		currentDisplayCateName=oGrCat.foneitem.Fcatename
		currentDisplayCateisnew=oGrCat.foneitem.fisnew
		currentDisplayCateishot=oGrCat.foneitem.fishot
	end If

set catetag = new MyCategoryCls
	catetag.FDisp = vDisp
	catetag.fnDispCateTag '인기 태그

'// 카테고리 총상품수 산출 함수
function getCateListCount(srcFlag,sDiv,sDep,dspCd,arrCt,mkrid,ccd,stcd,atcd,deliT,lDiv,sRect,sExc)
	dim oTotalCnt
	set oTotalCnt = new SearchItemCls
		oTotalCnt.FRectSearchFlag = srcFlag
		oTotalCnt.FRectSearchItemDiv = sDiv
		oTotalCnt.FRectSearchCateDep = sDep
		oTotalCnt.FRectCateCode	= dspCd
		oTotalCnt.FarrCate=arrCt
		oTotalCnt.FRectMakerid	= mkrid
		oTotalCnt.FcolorCode= ccd
		oTotalCnt.FstyleCd= stcd
		oTotalCnt.FattribCd = atcd
		oTotalCnt.FdeliType	= deliT
		oTotalCnt.FListDiv = lDiv
		oTotalCnt.FRectSearchTxt = sRect
		oTotalCnt.FRectExceptText = sExc
		oTotalCnt.FSellScope="Y"
		oTotalCnt.getTotalCount
		getCateListCount = oTotalCnt.FTotalCount

	set oTotalCnt = Nothing
end Function

	dim vCateItemCount
	vCateItemCount = FormatNumber(getCateListCount("n","n","T",vDisp,"","","0","","","","list","",""),0)
%>
	<!-- #include virtual="/lib/inc/head.asp" -->
	<script type="text/javascript" src="/lib/js/category_brand.js"></script>
	<script type="text/javascript" src="/lib/js/swiper-2.1.min.js"></script>
	<title>10x10: <%= currentDisplayCateName %></title>
	<script>
	<%
	'//2depth 일때만
	if vDepth="1" then
	%>	
	$(function(){
		$(".categoryListup li:has(em)").addClass("hotCtgy");
		$(".tabList li").append('<span></span>');

		var tabsSwiper = new Swiper('.tabArea .swiper-container',{
			speed:500,
			onSlideChangeStart: function(){
				$(".tabArea .swiper-nav .active-nav").removeClass('active-nav')
				$(".tabArea .swiper-nav li").eq(tabsSwiper.activeIndex).addClass('active-nav')
			}
		})
		$(".tabArea .swiper-nav li").on('touchstart mousedown',function(e){
			e.preventDefault()
			$(".tabArea .swiper-nav .active-nav").removeClass('active-nav')
			$(this).addClass('active-nav')
			tabsSwiper.swipeTo( $(this).index() )
		})
		$(".tabArea .swiper-nav li").click(function(e){
			e.preventDefault()
		})
	});
	<% end if %>
	</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container bgGry">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content ctgyMain" id="contentArea">
				<div class="inner5">
					<h1 class="tMar15"><%= currentDisplayCateName %></h1>
					<div class="tMar10 box1 w100">
						<ul class="categoryListup">
							<% If oGrCat.FResultCount>0 Then %>
							<li class="allView"><a href="#" onclick="moveCategoryList('<%=vDisp%>','1','',''); return false;"><span class="cRd1">전체상품 (<%=vCateItemCount%>)</span>
							<% if currentDisplayCateisnew="o" then %>
								<em class="icoHot">HOT</em>
							<% end if %>
							<% if currentDisplayCateishot="o" then %>
								<em class="icoNew">NEW</em>
							<% end if %></a></li>
							
							<% FOR lp = 0 to oGrCat.FResultCount-1 %>				
								<li><a href="" onclick="moveCategoryList('<%= oGrCat.FItemList(lp).Fcatecode %>','1','',''); return false;"><span><%= oGrCat.FItemList(lp).Fcatename %></span> <% if oGrCat.FItemList(lp).fisnew ="o" then %><em class="icoNew">NEW</em><% End If %> <% if oGrCat.FItemList(lp).fishot ="o" then %><em class="icoHot">HOT</em><% End If %></a>
								</li><% Next %>
							<% end if %>
						</ul>
					</div>
				</div>
				
				<%
				'/2depth 일때만
					if vDepth="1" then
				%>
				<% If catetag.FResultCount>0 Then %>
				<div class="inner10">
					<h2 class="tit02 tMar30"><span>인기태그</span></h2>
					<ul class="tagList">
						<% FOR lp = 0 to catetag.FResultCount-1 %>
						<li><a href="<%= catetag.FItemList(lp).Fkwordurl1 %>"><%= catetag.FItemList(lp).Fkword1 %></a></li>
						<% Next %>						
					</ul>
				</div>
				<% End If %>
				<% 
					End If 
				%>
				<!-- #include virtual="/category/inc_category_tabs.asp" -->
				<%
					'On Error Resume Next
					'server.Execute "/chtml/dispcate/2014main/catemain_eventbanner_"&vDisp&".html"
					'On Error Goto 0
				%>
			</div>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>

<% set oGrCat = nothing %>
<% set catetag = nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->