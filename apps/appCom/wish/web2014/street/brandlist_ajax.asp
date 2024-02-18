<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 브랜드
' History : 2014.09.21 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/classes/street/BrandStreetCls.asp" -->
<%
Dim i, cBrandList, vPageSize, vCurrPage, vChar, vChar1, vChar2, vLang, vFlag, vImgSize, lp, vitemarr, vitemarrTemp
	vImgSize = requestCheckVar(request("imgsize"),3)
	vCurrPage = requestCheckVar(request("page"),3)
	vChar = requestcheckvar(Request("chrCd"),4)
	vLang = requestcheckvar(Request("Lang"),4)
	vFlag = requestcheckvar(Request("flag"),10)

'K:한국어, E:영어
if vLang = "" then vLang = "K"
if vChar = "" then vChar = "가"
if vCurrPage = "" then vCurrPage = 1
if vImgSize = "" Then vImgSize = 200

If vFlag <> "" Then
	If vFlag <> "ctab1" AND vFlag <> "ctab2" AND vFlag <> "ctab3" AND vFlag <> "ctab5" AND vFlag <> "ctab7" AND vFlag <> "ctab8" Then
		vFlag = ""
	End IF
End IF

If vImgSize <> "200" AND vImgSize <> "290" Then
	vImgSize = "200"
End If

Call convertChar(vLang, vChar, vChar1, vChar2)

SET cBrandList = new CStreet
	cBrandList.FpageSize = 12
	cBrandList.FCurrPage = vCurrPage
	cBrandList.Frectchar1 = vChar1
	cBrandList.Frectchar2 = vChar2
	cBrandList.FrectchrCd = vChar
	cBrandList.FRectLang = vLang
	cBrandList.FRectFlag = vFlag
	cBrandList.fnstreetBrandList
	
dim snpTitle, snpLink, snpPre, snpImg
snpTitle = Server.URLEncode("텐바이텐 브랜드")
snpLink = Server.URLEncode(wwwUrl&"/apps/appCom/wish/web2014/street/brandlist.asp")
snpPre = Server.URLEncode("10x10 브랜드")
snpImg = Server.URLEncode("http://fiximage.10x10.co.kr/m/2014/brand/img_brand_no_product.png")
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type="text/javascript">

$(function(){
	// Top버튼 위치 이동
	//$(".goTop").addClass("topHigh");
});

function goorder(order){
	ShowBrandList('<%=vChar%>','<%=vLang%>',order,1,'');
	fnCloseModal();
}

function goPage(page){
	ShowBrandList('<%=vChar%>','<%=vLang%>','',page,'');
}

function TnMyBrandZZim(mkr){
	if (mkr==''){
		alert('브랜드가 없습니다.');
		return;
	}

	<% If IsUserLoginOK() Then %>
		jjimfrm.makerid.value = mkr;
		jjimfrm.action = "/apps/appCom/wish/web2014/street/domybrandjjim.asp";
		jjimfrm.submit();
	<% Else %>
		alert("찜브랜드 추가는 로그인이 필요한 서비스입니다.\로그인 하시겠습니까?");
		top.location.href = "<%=M_SSLUrl%>/apps/appCom/wish/web2014/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>";
	<% End If %>
}

// SNS 공유 팝업
function fnAPPRCVpopSNS(){
	fnAPPpopupBrowserURL("공유","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popShare.asp?sTit=<%=snpTitle%>&sLnk=<%=snpLink%>&sPre=<%=snpPre%>&sImg=<%=snpImg%>");
	return false;
}

//브랜드리스트 아작스 호출
function ShowBrandList(chrCd,Lang,flag,page,imgsize){
	$.ajax({
		url: "/apps/appCom/wish/web2014/street/brandlist_ajax.asp?page="+page+"&chrCd="+chrCd+"&Lang="+Lang+"&flag="+flag+"&imgsize="+imgsize+"",
		cache: false,
		success: function(message)
		{
			$("#contentArea").empty().append(message);
			try {
				history.pushState({"html":message},"생활감성채널, 텐바이텐","/apps/appCom/wish/web2014/street/brandlist.asp?page="+page+"&chrCd="+chrCd+"&Lang="+Lang+"&flag="+flag+"&imgsize="+imgsize+"");
			} catch(e){}

			$(".floatingBar").remove();
			jsContentAreaReSize();
			jsCategoryTabClose();
			$('body,html').animate({scrollTop:0}, 'fast');
		}
	});
}
</script>
</head>
<body>

			<div class="location">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<em class="swiper-slide"><a href="" onclick="callgotoday(); return false;">HOME</a></em>
						<em class="swiper-slide"><a href=""><%= replace(vChar,"Σ","etc.") %></a></em>
					</div>
				</div>
			</div>

			<!-- Sorting -->
			<div class="sorting sortingBrand">
				<p class="all">
					<select onChange="ShowBrandList(this.value,'<%=vLang%>','<%=vFlag%>',1,<%=vImgSize%>);" class="selectBox" title="브랜드 정렬 선택 옵션">
						<%=charListBoxall(vLang,vChar)%>
					</select>
				</p>
				<p class="selected">
					<span class="button ctgySort">
					<a href="" onclick="fnAPPpopupBrowserURL('전체','<%=wwwUrl%>/apps/appCom/wish/web2014/street/brand_order.asp'); return false;">
					<%= getbrandstreetorder(vFlag) %></a></span>
				</p>
			</div>
			<!--// Sorting -->

			<div class="brandList">
				<%
				If cBrandList.FResultCount > 0 Then

					Dim isMyFavBrand: isMyFavBrand=False
					Dim LoginUserid
					LoginUserid = getLoginUserid()
				%>
					<%
					For lp=0 To cBrandList.FResultCount-1

					If IsUserLoginOK Then ''찜브랜드
						isMyFavBrand = getIsMyFavBrand(LoginUserid, cBrandList.FItemList(lp).Fmakerid)
					End If
					%>
					<% ' for dev msg : 클래스명 brand로 loop 돌려주세요. %>
					<div class="brand box1">
						<div class="info">
							<a href="" onclick="fnAPPpopupBrand('<%=cBrandList.FItemList(lp).Fmakerid%>'); return false;">
								<em class="brandEng"><%=cBrandList.FItemList(lp).Fsocname%></em>
								<strong class="brandKor"><%=cBrandList.FItemList(lp).Fsocname_kor%></strong>
							</a>
							<% ' for dev msg : 찜하면 클래스 on 넣어주세요 %>
							<button type="button" class="like <%=chkIIF(isMyFavBrand,"on","")%>" onclick="TnMyBrandZZim('<%=cBrandList.FItemList(lp).Fmakerid%>');">
							<span><%= cBrandList.FItemList(lp).Frecommendcount %></span></button>
							
							<p class="pFlag">
								<!--<span class="fgCoupon">쿠폰</span>
								<span class="fgOnly">ONLY</span>
								<span class="fgHot">HOT</span>
								<span class="fgGift">GIFT</span>
								<span class="fgLimit">한정</span>
								<span class="fgPlus">1+1</span>
								<span class="fgSoldout">품절</span>
								<span class="fgFree">무료배송</span>
								<span class="fgJoin">참여</span>
								<span class="fgBest">BEST</span>
								<span class="fgReserv">예약판매</span>-->

								<% if cBrandList.FItemList(lp).Fnewflg="Y" then %>
									<span class="fgNew">NEW</span>
								<% elseif cBrandList.FItemList(lp).Fsaleflg="Y" then %>
									<span class="fgSale">SALE</span>
								<% end if %>
							</p>
						</div>
						<div class="goods">
							<ul>
								<%
								vitemarr="": i=0
								vitemarr = cBrandList.FItemList(lp).fitemarr
								
								if vitemarr<>"" then
									If isarray(Split(vitemarr,",")) Then
								%>
										<%
										For i = LBound(Split(vitemarr,",")) To UBound(Split(vitemarr,","))
										
										vitemarrTemp = Split(vitemarr,",")(i)
										%>
										<li>
											<a href="" onclick="fnAPPpopupProduct(<%= Split(vitemarrTemp,"||")(0) %>); return false;">
											<img src="<%=getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid( Split(vitemarrTemp,"||")(0) )&"/"&db2html( Split(vitemarrTemp,"||")(1) ),"140","140","true","false")%>" alt="<%= Split(vitemarrTemp,"||")(0) %>" />
											
											<% if cBrandList.FItemList(lp).fitemcount>4 and UBound(Split(vitemarr,",")) > 2 then %>
												<%' for dev msg : 마지막 4번째 li에 상품갯수 부분 넣어주세요. %>
												<div class="count"><span><em>+ <%= cBrandList.FItemList(lp).fitemcount-4 %></em></span></div>
											<% end if %>
											</a>
										</li>
										<% next %>
									<% end if %>
								<%
								end if
								
								i = chkIIf(i=0,1,i+1)
								for i=i to 4
									Response.Write "<li style='background-color:#F2F2F2; opacity:0.3; filter:gray; -webkit-filter: grayscale(1);'><img src='http://fiximage.10x10.co.kr/m/2014/brand/img_brand_no_product.png' alt='10X10'></li>"
								next
								%>
							</ul>
						</div>
					</div>
					<% Next %>

					<br />
					<%=fnDisplayPaging_New(vCurrPage,cBrandList.FTotalCount,12,4,"goPage")%>					
				<% else %>
					<!-- 브랜드 검색결과 없을경우 -->
					<div class="noBrandData">
						<p class="result">선택하신 <span class="cRd1">브랜드 색인</span>에<br />브랜드가 없습니다.</p>
						<p class="fs11">브랜드명을 다시 확인하여 주시거나<br />검색으로 찾아주세요 :-)</p>
					</div>
					<!--// 브랜드 검색결과 없을경우 -->
				<% End If %>
			</div>

</body>
</html>

<% SET cBrandList = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->