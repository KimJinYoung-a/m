<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/itemOptionCls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/JSON2.asp" -->
<%
	'// 카테고리 코드, 브랜드코드 받아옴
	Dim vDisp, vMakerid, vSItemid, vRuid, tLp, tmv
	vDisp = requestCheckVar(request("disp"),18)
	vMakerid = requestCheckVar(request("makerid"),128)
	vSItemid = requestCheckVar(request("itemid"),128)
	vRuid = requestCheckVar(request("ruid"),128)
	tLp = 0
	tmv = 1
%>


<%
	dim oDoc,iLp
	set oDoc = new SearchItemCls
		oDoc.FRectSearchTxt = ""
		oDoc.FRectPrevSearchTxt = ""
		oDoc.FRectExceptText = ""
		oDoc.FRectSortMethod	= "be"		'인기상품
		oDoc.FRectSearchFlag = "n"			'일반상품
		oDoc.FRectSearchItemDiv = "n"		'기본 카테고리만
		oDoc.FRectSearchCateDep = "T"		'하위 카테고리 포함
		oDoc.FRectCateCode	= vDisp
		oDoc.FminPrice	= ""
		oDoc.FmaxPrice	= ""
		oDoc.FdeliType	= ""
		oDoc.FCurrPage = 1
		oDoc.FPageSize = 10					'10개 접수
		oDoc.FScrollCount = 5
		oDoc.FListDiv = "list"				'상품목록
		oDoc.FLogsAccept = False			'로그 기록안함
		oDoc.FAddLogRemove = true			'추가로그 기록안함
		oDoc.FcolorCode = "0"				'전체컬러
		oDoc.FSellScope= "Y"				'판매중인 상품만
		oDoc.getSearchList

	If oDoc.FResultCount > 0 Then
%>
<div class="ctgyPopularList">
	<h2 class="tit02 tMar30"><span>카테고리 인기상품</span></h2>
	<span class="moreBtn"><a href="/category/category_list.asp?srm=be&disp=<%=vDisp%>">카테고리 리스트로 이동</a></span>
	<div class="swiper-container swiper4">
		<div class="swiper-wrapper">
			<ul class="simpleList swiper-slide">
<%
			For iLp=0 To oDoc.FResultCount-1
				If Not(vSItemid = oDoc.FItemList(iLp).Fitemid) Then
%>
				<li>
					<a href="https://api.recopick.com/1/banner/131/pick?source=<%=vSItemid%>&pick=<%=oDoc.FItemList(iLp).Fitemid%>&uid=<%=vRuid%>&method=20&channel=10x10_itemprd&reco_type=item-item">
						<p><img src="<%=getStonThumbImgURL(oDoc.FItemList(iLp).FImageBasic,200,200,"true","false")%>" alt="<%=oDoc.FItemList(iLp).FitemName%>" /></p>
						<span><%=oDoc.FItemList(iLp).FitemName%></span>
						<span class="price">
							<% = FormatNumber(oDoc.FItemList(iLp).getRealPrice,0) %>원
							<% If oDoc.FItemList(iLp).IsSaleItem Then %>
							<em class="cRd1">[<% = oDoc.FItemList(iLp).getSalePro %>]</em>
							<% end if %>
						</span>
					</a>
				</li>
<%
				Else
					tmv = tmv + 1
				End If

				if (tLp mod 3)=2 and iLp<oDoc.FResultCount-tmv then Response.Write "</ul><ul class=""simpleList swiper-slide"">"
				
				If Not(vSItemid = oDoc.FItemList(iLp).Fitemid) Then
					tLp = tLp + 1
				End If

			Next
%>
			</ul>
		</div>
	</div>
	<div class="pagination"></div>
</div>
<%
	End if

	set oDoc = Nothing
%>

<script>
	// category best
	mySwiper4 = new Swiper('.swiper4',{
		pagination:'.ctgyPopularList .pagination',
		paginationClickable:true,
		loop:true,
		resizeReInit:true,
		calculateHeight:true
	});
</script>