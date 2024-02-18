<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
'####################################################
' Description :  카테고리 리스트
' History : 2014.09.20 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/MyCategoryCls.asp" -->
<!-- #include virtual="/lib/classes/award/newawardcls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CateMdPickCls.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
Dim oGrCat, vDepth, lp, vDisp, currentDisplayCateName, currentDisplayCateisnew , currentDisplayCateishot
	vDisp =  getNumeric(request("disp"))

	'임시
'	vDisp = Replace(param,"disp=","")

if vDisp = "" then
	response.write "<script>"
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
		
		if (oTotalCnt.FTotalCount="") then
		    getCateListCount = 0
		else
		    getCateListCount = oTotalCnt.FTotalCount
        end if
	set oTotalCnt = Nothing
end Function

	dim vCateItemCount
	vCateItemCount = FormatNumber(getCateListCount("n","n","T",vDisp,"","","0","","","","list","",""),0)

%>
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
		tabsSwiper.slideTo( $(this).index() )
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
	<div class="container bgGry">
		<!-- content area -->
		<div class="content ctgyMain" id="contentArea">
			<div class="inner5">
				<h1 class="hide"><%= currentDisplayCateName %></h1>
				<div class="tMar05 box1 w100">
					<ul class="categoryListup">
						<% If oGrCat.FResultCount>0 Then %>
						<li class="allView"><a href="#" onclick="fnAPPpopupCategory('<%=vDisp%>');return false;"><span class="cRd1">전체상품 (<%=vCateItemCount%>)</span><% if currentDisplayCateisnew="o" then %><em class="icoHot">HOT</em><% end if %><!-- <% if currentDisplayCateishot="o" then %><em class="icoNew">NEW</em><% end if %> --></a></li>
						<% FOR lp = 0 to oGrCat.FResultCount-1 %>
						<li onclick="fnAPPpopupCategory('<%=oGrCat.FItemList(lp).Fcatecode%>');"><a href="#" onclick="fnAPPpopupCategory('<%= oGrCat.FItemList(lp).Fcatecode %>');return false;"><span><%= oGrCat.FItemList(lp).Fcatename %></span><!-- <% if oGrCat.FItemList(lp).fisnew ="o" then %><em class="icoNew">NEW</em><% End If %> --> <% if oGrCat.FItemList(lp).fishot ="o" then %><em class="icoHot">HOT</em><% End If %></a></li>
						<% Next %>
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
					<li><a href="#" onclick="<% If  catetag.FItemList(lp).Fappdiv = "4" Then %>fnAPPpopupCategory('<%=catetag.FItemList(lp).Fappcate%>');return false;<% Else %>fnAPPpopupCustomUrl('<%=catetag.FItemList(lp).Fkwordurl2%>','<%=catetag.FItemList(lp).Fappdiv%>');return false;<% End If %>"><%= catetag.FItemList(lp).Fkword1 %></a></li>
					<% Next %>
				</ul>
			</div>
			<% End If %>
			<% 
				End If 
			%>
			<!-- #include virtual="/apps/appCom/wish/web2014/category/inc_category_tabs.asp" -->
			<%
'				On Error Resume Next
'				server.Execute "/chtml/dispcate/appmain/catemain_eventbanner_"&vDisp&".html"
'				On Error Goto 0
			%>
		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</div>
</body>
</html>
<% set oGrCat = nothing %>
<% set catetag = nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->