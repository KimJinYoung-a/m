<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/enjoy/shoppingchanceCls.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/award/newawardcls_B.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
Dim flag, atype, vDisp, chkCnt
vDisp = RequestCheckVar(request("disp"),3)
flag = RequestCheckVar(request("flag"),1)
atype = RequestCheckVar(request("atype"),1)
dim CurrPage : CurrPage = getNumeric(request("cpg"))
if CurrPage="" then CurrPage=1
'If atype = "" Then atype = "n"  'n 기본값
If atype = "" Then atype = "f"  'n 기본값
dim minPrice: minPrice=4500		'검색 최저가

Dim oaward, i, iLp, sNo, eNo, tPg

set oaward = new CAWard
	oaward.FPageSize = 90
	oaward.GetBrandItemList

If (oaward.FResultCount < 3) Then
	''oaward.FRectCDL = vDisp  ''??
	''oaward.GetNormalItemList5down
	
	set oaward = Nothing
	set oaward = new SearchItemCls
		oaward.FListDiv 			= "bestlist"
		oaward.FRectSortMethod	    = "be"
		''oaward.FRectSearchFlag 	= "newitem"  ''검색범위
		oaward.FPageSize 			= 50
		oaward.FCurrPage 			= 1
		oaward.FSellScope			= "Y"
		oaward.FScrollCount 		= 1
		oaward.FRectSearchItemDiv   ="D"
		oaward.FRectCateCode		= vDisp
		oaward.FminPrice	= minPrice
		oaward.getSearchList
End if
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: Best Award</title>
<script type='text/javascript'>

function goPage(page) {
	location.replace('awardBrand.asp?cpg='+page);
}


$(function() {
	//급상승 상품
	$(".bestUpV15 .ranking").append("<em>급상승</em>");
	// Top버튼 위치 이동
	$(".goTop").addClass("topHigh");
});

</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin" style="background-color:#e7eaea;">
		<div class="header">
			<h1>PREMIUM BEST</h1>
			<p class="btnPopClose"><button class="pButton" onclick="goBack('/award/awarditem.asp');return false;">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content" id="contentArea">
			<ul class="commonTabV16a">
				<li class="" name="tab01" style="width:25%;" onclick="location.replace('awardVIP.asp');return false;">VIP</li><!--for dev msg : 해당탭에 클래스 current 추가됩니다. -->
				<li class="" name="tab02" style="width:25%;" onclick="location.replace('awardMan.asp');return false;">MAN</li>
				<li class="current" name="tab03" style="width:25%;" onclick="location.replace('awardBrand.asp');return false;">BRAND</li>
				<li class="" name="tab04" style="width:25%;" onclick="location.replace('awardSteady.asp');return false;">STEADY</li>
			</ul>
			<!-- BRAND BEST -->
			<div class="brandBestV15">
				<div class="bestListV15 inner5">
					<ul>
						<%' for dev msg : 1위~3위까지 클래스 topRankV15 붙여주세요 %>

						<%
						if CurrPage=1 then
							sNo=0
							eNo=44
						else
							sNo=(CurrPage-1) * 45
							eNo=(CurrPage * 45)-1
						end if

						if (oaward.FResultCount-1)<eNo then eNo = oaward.FResultCount-1

						tPg = (oaward.FResultCount\45)
						if (tPg<>(oaward.FResultCount/45)) then tPg = tPg +1

						If oaward.FResultCount > sNo Then
					  		If oaward.FResultCount Then
						%>

						<% For i=sNo to eNo %>
							<% If i Mod 3 = 0 Then %>
							<li <% If (i/3)+1 < 4 Then %> class="topRankV15" <% End If %> onclick="location.href='/street/street_brand.asp?makerid=<%=oaward.FItemList(i).FMakerID %>'">
								<div class="brdInfo">
									<p class="ranking"><span><%=(i/3)+1%></span></p>
									<p class="brdName">
										<span class="eng"><%=oaward.FItemList(i).FBrandName %></span>
										<span class="kor"><%=oaward.FItemList(i).FSocName_Kor %></span>
									</p>
								</div>
							<div class="brdPhoto">
							<% End If %>
							<div><span><img src="<%=getThumbImgFromURL(oaward.FItemList(i).FImageBasic,"286","286","true","false") %>" alt="<%=oaward.FItemList(i).FItemName %>" /></span></div>
							<% If i Mod 3 = 2 Then %>
								</div>
							</li>
							<% End If %>

						<% Next %>

						<%
							End If
						End If
						%>
					</ul>
					<%=fnDisplayPaging_New(CurrPage,oaward.FResultCount,45,4,"goPage")%>
				</div>
			</div>
			<!--// BRAND BEST -->
		<!-- //content area -->
	</div>
</div>
<span id="gotop" class="goTop">TOP</span>
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-16971867-10', 'auto');
  ga('require','displayfeatures');
  ga('require', 'linkid', 'linkid.js');
  ga('send', 'pageview');

</script>
</body>
</html>
<%
set oaward = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->