<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description :  sale List
' History : 2015-10-01 이종화 생성
' History : 2016-01-28 유태욱 수정(정렬방법 수정)
' History		: 2017 리뉴얼 : 
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
Dim sortName
Dim vDisp : vDisp = getNumeric(requestCheckVar(request("disp"),15))
Dim vDepth, i,TotalCnt , vSaleFreeDeliv
	vDepth = "1"

dim sPercent, flo1, flo2
	sPercent = getNumeric(requestCheckVar(Request("sp"),2))
	flo1 = requestCheckVar(Request("flo1"),5) '// 무료배송
	flo2 = requestCheckVar(Request("flo2"),5) '// 한정판매

dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),9))
dim searchFlag 	: searchFlag = "sale"
dim CurrPage 	: CurrPage = getNumeric(requestCheckVar(request("cpg"),9))
dim SortMet		: SortMet = requestCheckVar(request("srm"),2)
dim classStr, adultChkFlag, adultPopupLink, linkUrl

dim ListDiv,ScrollCount
ListDiv="salelist"
ScrollCount = 5

if CurrPage="" then CurrPage=1
PageSize =20

If SortMet = "" Then SortMet = "be"	'정렬 기본값 : 인기순

dim oDoc,iLp, vWishArr
set oDoc = new SearchItemCls
	oDoc.FListDiv 			= ListDiv
	oDoc.FRectSortMethod	= SortMet
	oDoc.FRectSearchFlag 	= searchFlag
	oDoc.FPageSize 			= PageSize
	oDoc.FRectCateCode		= vDisp
	oDoc.FisFreeBeasong		= flo1	'// 무료배송
	oDoc.FisLimit			= flo2	'// 한정판매

	oDoc.FCurrPage 			= CurrPage
	oDoc.FSellScope 		= "Y"
	oDoc.FScrollCount 		= ScrollCount

	'할인률 적용
	Select Case sPercent
		Case "99"
			oDoc.FSalePercentLow = "0"
			oDoc.FSalePercentHigh = "0.3"
		Case "70"
			oDoc.FSalePercentLow = "0.3"
			oDoc.FSalePercentHigh = "0.5"
		Case "50"
			oDoc.FSalePercentLow = "0.5"
			oDoc.FSalePercentHigh = "0.8"
		Case "20"
			oDoc.FSalePercentLow = "0.8"
			oDoc.FSalePercentHigh = "1"
	end Select

	oDoc.getSearchList
	
TotalCnt = oDoc.FTotalCount

if IsUserLoginOK then
	'// 검색결과 상품목록 작성
	dim rstArrItemid: rstArrItemid=""
	IF oDoc.FResultCount >0 then
		For iLp=0 To oDoc.FResultCount -1
			rstArrItemid = rstArrItemid & chkIIF(rstArrItemid="","",",") & oDoc.FItemList(iLp).FItemID
		Next
	End if
	'// 위시결과 상품목록 작성
	if rstArrItemid<>"" then
		Call getMyFavItemList(getLoginUserid(),rstArrItemid,vWishArr)
	end if
end if

function swiperInitialNumber(sPercent)
	select case sPercent
		case "99"
			swiperInitialNumber = 1
		case "70"
			swiperInitialNumber = 2
		case "50"
			swiperInitialNumber = 3
		case "20"
			swiperInitialNumber = 4
		case else
			swiperInitialNumber = 0
	end select
end function
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script type="text/javascript">
$(function() {
	var swiper = new Swiper('.topicV19 .tabwrap', {
		slidesPerView :'auto',
		<% if swiperInitialNumber(sPercent) > 2 then %>
		initialSlide : <%=swiperInitialNumber(sPercent)%>,
		<% end if %>
	})
});

function changeCate(a){
	document.sFrm.cpg.value = 1;
	document.sFrm.disp.value = a;
	document.sFrm.submit();
}

function jsSortMet(a){
	document.sFrm.cpg.value = 1;
	document.sFrm.srm.value = a;
	document.sFrm.submit();
}

function goWishPop(i,ecd){
<% If IsUserLoginOK() Then ''ErBValue.value -> 공통파일의 구분값 (cate는 1) %>
	var wishpop = window.open('/common/popWishFolder.asp?ErBValue=6&ecode='+ecd+'&gb=search2017&itemid='+i+'','wishpop','')
<% Else %>
	top.location.href = "/login/login.asp?backpath=<%=fnBackPathURLChange(CurrURLQ())%>";
<% End If %>
}

function jsGoUrl(sP, catecode, flo1, flo2){
      location.href = "/shoppingtoday/shoppingchance_saleitem.asp?disp="+catecode+"&sP="+sP+"&flo1="+flo1+"&flo2="+flo2;
}

function jsAfterWishBtn(i){
	if($("#wish"+i+"").hasClass("on")){
		
	}else{
		$("#wish"+i+"").addClass("on");
		
		var cnt = $("#cnt"+i+"").text();

		if(cnt == ""){
			$("#wish"+i+"").empty();
			$("#cnt"+i+"").empty().text("1");
		}else{
			cnt = parseInt(cnt) + 1;
			if(cnt > 999){
				$("#cnt"+i+"").empty().text("999+");
			}else{
				$("#cnt"+i+"").empty().text(cnt);
			}
		}
	}
}

var vPg=1, vScrl=true;
$(function(){
	var conT = $(".sortingbarV19").offset().top;

	// 스크롤시 추가페이지 접수
	$(window).scroll(function() {
		if ($(window).scrollTop() >= ($(document).height()-$(window).height())-512){
			if(vScrl) {
				vScrl = false;
				vPg++;
				document.sFrm.cpg.value = vPg;
				$.ajax({
					url: "act_shoppingchance_saleitem.asp",
					data: $("#sFrm").serialize(),
					cache: false,
					success: function(message) {
						if(message!="") {
							$("#lyrSaleList").append(message);
							vScrl=true;
						} else {
							$(window).unbind("scroll");
						}
					}
					,error: function(err) {
						alert(err.responseText);
						$(window).unbind("scroll");
					}
				});
			}
		}

		var y = $(window).scrollTop();
		if ( conT < y ) {
			$(".topicV19").addClass("is-fixed");
		} else {
			$(".topicV19").removeClass("is-fixed");
		}
	});

	// 로딩중 표시
	$("#lyLoading").ajaxStart(function(){
		$(this).show();
	}).ajaxStop(function(){
		$(this).hide();
	});
});
function confirmAdultAuth(cPath){
	if(confirm('이 상품은 성인 인증이 필요한 상품입니다. 성인 확인을 위해 성인 인증을 진행합니다.')){
		var url = '/login/login_adult.asp?backpath='+ cPath;
		location.href = url;
	}
}

//무배
function chkfree(flo1,flo2){
	if(document.all.chksearchfree.checked==true){
		location.href = "/shoppingtoday/shoppingchance_saleitem.asp?disp=<%=vDisp%>&sP=<%=sPercent%>&flo1="+flo1+"&flo2="+flo2;
	}
	if(document.all.chksearchfree.checked==false){
		location.href = "/shoppingtoday/shoppingchance_saleitem.asp?disp=<%=vDisp%>&sP=<%=sPercent%>&flo1=&flo2="+flo2;
	}
}

//한정
function chklimit(flo1,flo2){
	if(document.all.chksearchlimit.checked==true){
		location.href = "/shoppingtoday/shoppingchance_saleitem.asp?disp=<%=vDisp%>&sP=<%=sPercent%>&flo1="+flo1+"&flo2="+flo2;
	}
	if(document.all.chksearchlimit.checked==false){
		location.href = "/shoppingtoday/shoppingchance_saleitem.asp?disp=<%=vDisp%>&sP=<%=sPercent%>&flo1="+flo1+"&flo2=";
	}
}
</script>
</head>
<body class="default-font body-sub">
<!-- #include virtual="/lib/inc/incHeader.asp" -->
<div id="content" class="content">
	<div class="topicV19">
		<div class="titwrap">
			<div class="tit-area">
				<div class="nav nav-stripe">
					<ul class="grid2">
						<li><a href="/shoppingtoday/shoppingchance_saleitem.asp" class="on">세일</a></li>
						<li><a href="/clearancesale/">클리어런스</a></li>
					</ul>
				</div>
				<h2>NOW ON SALE</h2>
			</div>
			<div class="tabwrap">
				<ul class="swiper-wrapper">
					<li class="swiper-slide <%=CHKIIF(sPercent="","on","")%>"><a href="javascript:jsGoUrl('','<%=vDisp%>','<%=flo1%>','<%=flo2%>');">ALL</a></li>
					<li class="swiper-slide <%=CHKIIF(sPercent="99","on","")%>"><a href="javascript:jsGoUrl('99','<%=vDisp%>','<%=flo1%>','<%=flo2%>');">70% 이상</a></li>
					<li class="swiper-slide <%=CHKIIF(sPercent="70","on","")%>"><a href="javascript:jsGoUrl('70','<%=vDisp%>','<%=flo1%>','<%=flo2%>');">50% ~ 70%</a></li>
					<li class="swiper-slide <%=CHKIIF(sPercent="50","on","")%>"><a href="javascript:jsGoUrl('50','<%=vDisp%>','<%=flo1%>','<%=flo2%>');">20% ~ 50%</a></li>
					<li class="swiper-slide <%=CHKIIF(sPercent="20","on","")%>"><a href="javascript:jsGoUrl('20','<%=vDisp%>','<%=flo1%>','<%=flo2%>');">20% 이하</a></li>
				</ul>
			</div>
		</div>
		<div class="sortingbarV19">
			<div class="option-slt">
				<div class="option-left">
					<div class="styled-selectbox styled-selectbox-default">
					<%
						'정렬상자 호출; sDisp:전시카테고리, sType:확장여부, sCallback:콜백함수명 (via functions.asp)
						Call fnPrntDispCateNaviV17BEST(vDisp,"F","changeCate")
					%>
					</div>
				</div>
				<div class="option-right">
					<div class="styled-selectbox styled-selectbox-default">
						<%
							'정렬상자 호출; sType:정렬방법, sUse:사용처 구분, sCallback:콜백함수명 (via functions.asp)
							Call fnPrntSortNaviver17(SortMet, "jsSortMet")
						%>
					</div>
				</div>
			</div>
			<div class="option-filter">
				<ul>
					<li><input type="checkbox" id="checkFree" name="chksearchfree" onclick="chkfree('free','<%= flo2 %>');" <% if flo1 = "free" then response.write "checked" %>><label for="checkFree">무료배송</label></li>
					<li><input type="checkbox" id="checkLimited" name="chksearchlimit" onclick="chklimit('<%= flo1 %>','limit');" <% if flo2 = "limit" then response.write "checked" %>><label for="checkLimited">한정판매</label></li>
				</ul>
			</div>
		</div>
	</div>

	<div id="saleItems" class="new-items-list">
		<%'!-- item list :격자형 (클래스명 : type-grid)--%>
		<div class="items type-grid">
			<% IF oDoc.FResultCount >0 Then %>
			<ul id="lyrSaleList">
				<% 
					For i=0 To oDoc.FResultCount-1 
						classStr = ""
						linkUrl = "/category/category_itemPrd.asp?itemid="& oDoc.FItemList(i).FItemID & "&disp=" & oDoc.FItemList(i).FCateCode
						adultChkFlag = session("isAdult") <> true and oDoc.FItemList(i).FadultType = 1																	
						
						If oDoc.FItemList(i).FItemDiv="21" Then
							classStr = addClassStr(classStr,"deal-item")								
						end if
						if adultChkFlag then
							classStr = addClassStr(classStr,"adult-item")								
						end if					
				%>
				<% If oDoc.FItemList(i).FItemDiv="21" Then %>
				<li class="<%=classStr%>" <%=chkIIF(adultChkFlag, "onclick=""confirmAdultAuth('"&linkUrl&"');""","")%>>
					<a href="/deal/deal.asp?itemid=<%= oDoc.FItemList(i).FItemID %>&disp=<%= oDoc.FItemList(i).FCateCode %>">
					<span class="deal-badge">텐텐<i>DEAL</i></span>
						<div class="thumbnail">
							<img src="<%= getThumbImgFromURL(oDoc.FItemList(i).FImageBasic,286,286,"true","false") %>" alt="" />
							<% if adultChkFlag then %>									
							<div class="adult-hide">
								<p>19세 이상만 <br />구매 가능한 상품입니다</p>
							</div>
							<% end if %>															
							<%=CHKIIF(oDoc.FItemList(i).isSoldOut,"<b class='soldout'>일시 품절</b>","")%>
						</div>
						<div class="desc">
							<span class="brand"><% = oDoc.FItemList(i).FBrandName %></span>
							<p class="name"><% = oDoc.FItemList(i).FItemName %></p>
							<div class="price">
								<%
									If oDoc.FItemList(i).FOptionCnt="" Or oDoc.FItemList(i).FOptionCnt="0" Then	'### 쿠폰 X 세일 O
										Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oDoc.FItemList(i).getOrgPrice,0) & "<span class=""won"">" & CHKIIF(oDoc.FItemList(i).IsMileShopitem," Point","원") & "</span></b></div>" &  vbCrLf
									Else
										Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oDoc.FItemList(i).getOrgPrice,0) & "<span class=""won"">원</span></b>"
										Response.Write "&nbsp;<b class=""discount color-red"">" & oDoc.FItemList(i).FOptionCnt & "%</b>"
										Response.Write "</div>" &  vbCrLf
									End If
								%>
							</div>
						</div>
					</a>
					<div class="etc">
						<% IF oDoc.FItemList(i).IsCouponItem AND oDoc.FItemList(i).GetCouponDiscountStr = "무료배송" Then %>
							<div class="tag shipping"><span class="icon icon-shipping"><i>무료배송</i></span> FREE</div>
						<% End If %>
					</div>
				</li>
				<% Else %>
				<li class="<%=classStr%>" <%=chkIIF(adultChkFlag, "onclick=""confirmAdultAuth('"&linkUrl&"');""","")%>>
					<a href="/category/category_itemPrd.asp?itemid=<%= oDoc.FItemList(i).FItemID %>&disp=<%= oDoc.FItemList(i).FCateCode %>">
						<%'// 해외직구배송작업추가 %>
						<% If oDoc.FItemList(i).IsDirectPurchase Then %>
							<span class="abroad-badge">해외직구</span>
						<% End If %>
						<div class="thumbnail">
							<img src="<%= getThumbImgFromURL(oDoc.FItemList(i).FImageBasic,286,286,"true","false") %>" alt="" />
							<% if adultChkFlag then %>									
							<div class="adult-hide">
								<p>19세 이상만 <br />구매 가능한 상품입니다</p>
							</div>
							<% end if %>								
							<%=CHKIIF(oDoc.FItemList(i).isSoldOut,"<b class='soldout'>일시 품절</b>","")%>
						</div>
						<div class="desc">
							<span class="brand"><% = oDoc.FItemList(i).FBrandName %></span>
							<p class="name"><% = oDoc.FItemList(i).FItemName %></p>
							<div class="price">
								<%
'									IF oDoc.FItemList(i).IsFreeBeasongCoupon() AND oDoc.FItemList(i).IsSaleItem then
'										vSaleFreeDeliv = "<div class=""tag shipping""><span class=""icon icon-shipping""><i>무료배송</i></span> FREE</div>"
'									End IF

									If oDoc.FItemList(i).IsSaleItem AND oDoc.FItemList(i).isCouponItem Then	'### 쿠폰 O 세일 O
										Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oDoc.FItemList(i).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
										Response.Write "&nbsp;<b class=""discount color-red"">" & oDoc.FItemList(i).getSalePro & "</b>"
										If oDoc.FItemList(i).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
											If InStr(oDoc.FItemList(i).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
												Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
											Else
												Response.Write "&nbsp;<b class=""discount color-green"">" & oDoc.FItemList(i).GetCouponDiscountStr & "<small>쿠폰</small></b>"
											End If
										End If
										Response.Write "</div>" &  vbCrLf
									ElseIf oDoc.FItemList(i).IsSaleItem AND (Not oDoc.FItemList(i).isCouponItem) Then	'### 쿠폰 X 세일 O
										Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oDoc.FItemList(i).getRealPrice,0) & "<span class=""won"">원</span></b>"
										Response.Write "&nbsp;<b class=""discount color-red"">" & oDoc.FItemList(i).getSalePro & "</b>"
										Response.Write "</div>" &  vbCrLf
									ElseIf oDoc.FItemList(i).isCouponItem AND (NOT oDoc.FItemList(i).IsSaleItem) Then	'### 쿠폰 O 세일 X
										Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oDoc.FItemList(i).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
										If oDoc.FItemList(i).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
											If InStr(oDoc.FItemList(i).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
												Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
											Else
												Response.Write "&nbsp;<b class=""discount color-green"">" & oDoc.FItemList(i).GetCouponDiscountStr & "<small>쿠폰</small></b>"
											End If
										End If
										Response.Write "</div>" &  vbCrLf
									Else
										Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oDoc.FItemList(i).getRealPrice,0) & "<span class=""won"">" & CHKIIF(oDoc.FItemList(i).IsMileShopitem," Point","원") & "</span></b></div>" &  vbCrLf
									End If
								%>
							</div>
						</div>
					</a>
					<div class="etc">
						<!-- for dev msg : 리뷰
							1. 리뷰수와 wish수가 1,000건 이상이면 999+로 표시해주세요
							2. 리뷰는 총 평점으로 퍼센트로 표현해주세요. <i style="width:50%;">...</i>
						--> 
						<% if oDoc.FItemList(i).FEvalcnt > 0 then %>
							<div class="tag review"><span class="icon icon-rating"><i style="width:<%=fnEvalTotalPointAVG(oDoc.FItemList(i).FPoints,"search")%>%;">리뷰 종합 별점</i></span><span class="counting" title="리뷰 갯수"><%=chkIIF(oDoc.FItemList(i).FEvalcnt>999,"999+",oDoc.FItemList(i).FEvalcnt)%></span></div>
						<% end if %>
						<button class="tag wish btn-wish" onclick="goWishPop('<%=oDoc.FItemList(i).FItemid%>','');">
						<%
						If oDoc.FItemList(i).FFavCount > 0 Then
							If fnIsMyFavItem(vWishArr,oDoc.FItemList(i).FItemID) Then
								Response.Write "<span class=""icon icon-wish on"" id=""wish"&oDoc.FItemList(i).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&oDoc.FItemList(i).FItemID&""">"
								Response.Write CHKIIF(oDoc.FItemList(i).FFavCount>999,"999+",formatNumber(oDoc.FItemList(i).FFavCount,0)) & "</span>"
							Else
								Response.Write "<span class=""icon icon-wish"" id=""wish"&oDoc.FItemList(i).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&oDoc.FItemList(i).FItemID&""">"
								Response.Write CHKIIF(oDoc.FItemList(i).FFavCount>999,"999+",formatNumber(oDoc.FItemList(i).FFavCount,0)) & "</span>"
							End If
						Else
							Response.Write "<span class=""icon icon-wish"" id=""wish"&oDoc.FItemList(i).FItemID&"""><i> wish</i></span><span class=""counting"" id=""cnt"&oDoc.FItemList(i).FItemID&"""></span>"
						End If
						%>
						</button>
						<% IF oDoc.FItemList(i).IsCouponItem AND oDoc.FItemList(i).GetCouponDiscountStr = "무료배송" Then %>
							<div class="tag shipping"><span class="icon icon-shipping"><i>무료배송</i></span> FREE</div>
						<% End If %>
					</div>
				</li>
				<% End If %>
				<% Next %>
			</ul>
			<% Else %>
				<div align="center" id="srcnolist"><img src="http://fiximage.10x10.co.kr/m/common/noresult.png"></div>
			<% End If %>
		</div>
	</div>
	<form name="sFrm" id="sFrm" method="get" style="margin:0px;">
	<input type="hidden" name="sflag" value="<%= oDoc.FRectSearchFlag  %>">
	<input type="hidden" name="srm" value="<%= oDoc.FRectSortMethod%>">
	<input type="hidden" name="cpg" value="<%=oDoc.FCurrPage %>">
	<input type="hidden" name="disp" value="<%= vDisp%>">
	<input type="hidden" name="sP" value="<%=sPercent%>">
	<input type="hidden" name="flo1" value="<%=flo1%>">
	<input type="hidden" name="flo2" value="<%=flo2%>">
	<input type="hidden" name="itemid" value="">
	<input type="hidden" name="ErBValue" value="6">
	</form>
</div>
<div id="lyLoading" style="display:none;position:relative;text-align:center; padding:20px 0;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
<!-- //content area -->
<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<% Set oDoc = Nothing %>