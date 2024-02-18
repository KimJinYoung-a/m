<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#############################################################
'	Description : 클리어런스 세일 M
'	History		: 2016.01.18 유태욱 생성
'	History		: 2017 리뉴얼 : 
'#############################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/clearancesale/clearancesaleCls.asp"-->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->

<%
''dim soldoutyn	''품절상품 포함,제외
dim i
dim catecode, SortMet , TotalCnt , vSaleFreeDeliv
dim PageSize, CurrPage
dim classStr, adultChkFlag, adultPopupLink, linkUrl
dim flo1, flo2, flo3
dim Price, minPrice, maxPrice
dim swiperInitialNumber

	SortMet = requestCheckVar(request("atype"),7)
	catecode = getNumeric(requestCheckVar(Request("disp"),3))
	PageSize = getNumeric(requestCheckVar(request("psz"),9))
	CurrPage = getNumeric(requestCheckVar(request("cpg"),9))

	price =	requestCheckVar(Request("price"),3)
	flo1 =	requestCheckVar(Request("flo1"),4) '// 무료배송
	flo2 =	requestCheckVar(Request("flo2"),6) '// 텐바이텐 배송
	flo3 =	requestCheckVar(Request("flo3"),8) '// 포장상품여부

	if CurrPage = "" then CurrPage=1
	if PageSize = "" then PageSize =20
	
	If isNumeric(CurrPage) = False Then
		Response.Write "<script>alert('잘못된 경로입니다.');location.href='/';</script>"
		dbget.close()
		Response.End
	End If
	
	if SortMet="" then SortMet="be"		''기본 인기순 정렬
	if price = "" then price = "all"	''가격대별 정렬

	'가격대별
	Select Case price
		Case "0"
			minPrice = "1"
			maxPrice = "9999"
			swiperInitialNumber = 1
		Case "1"
			minPrice = "10000"
			maxPrice = "29999"
			swiperInitialNumber = 2
		Case "3"
			minPrice = "30000"
			maxPrice = "49999"
			swiperInitialNumber = 3
		Case "5"
			minPrice = "50000"
			maxPrice = "99999"
			swiperInitialNumber = 4
		Case "10"
			minPrice = "100000"
			maxPrice = "10000000"
			swiperInitialNumber = 5
		Case Else
			swiperInitialNumber = 0
	end Select
	
	''클리어런스 상품 리스트
	dim oclearancelist,iLp, vWishArr
	set oclearancelist = new CClearancesalelist
		oclearancelist.FPageSize = PageSize
		oclearancelist.FCurrPage = CurrPage
		oclearancelist.FdeliType1 = flo1
		oclearancelist.FdeliType2 = flo2
		oclearancelist.Fpojangok  = flo3
		oclearancelist.FRectSortMethod=SortMet	''정렬기준
		oclearancelist.FRectCateCode = catecode	''카테고리
		oclearancelist.FminPrice = minPrice	''최소금액
		oclearancelist.FmaxPrice = maxPrice	''최대금액
		oclearancelist.fnGetClearancesaleList

		TotalCnt = oclearancelist.FTotalCount

	if IsUserLoginOK then
		'// 검색결과 상품목록 작성
		dim rstArrItemid: rstArrItemid=""
		IF oclearancelist.FResultCount >0 then
			For iLp=0 To oclearancelist.FResultCount -1
				rstArrItemid = rstArrItemid & chkIIF(rstArrItemid="","",",") & oclearancelist.FItemList(iLp).FItemID
			Next
		End if
		'// 위시결과 상품목록 작성
		if rstArrItemid<>"" then
			Call getMyFavItemList(getLoginUserid(),rstArrItemid,vWishArr)
		end if
	end if	
%>

<!-- #include virtual="/lib/inc/head.asp" -->
<script type='text/javascript'>
$(function() {
	// Top버튼 위치 이동
	$(".goTop").addClass("topHigh");

	var swiper = new Swiper('.topicV19 .tabwrap', {
		slidesPerView:'auto',
		<% if swiperInitialNumber > 2 then %>
		initialSlide : <%=swiperInitialNumber%>,
		<% end if %>
	})
});

var vPg=1, vScrl=true;
$(function(){
	var conT = $(".sortingbarV19").offset().top;

	// 스크롤시 추가페이지 접수
	$(window).scroll(function() {
		var maxHeight = $(document).height();
		var currentScroll = $(window).scrollTop() + $(window).height();
		if (maxHeight *0.80 <= currentScroll) {
			if(vScrl) {
				vScrl = false;
				vPg++;
				$.ajax({
					url: "act_index.asp?atype=<%=trim(SortMet)%>&disp=<%=catecode%>&price=<%=price%>&flo1=<%=flo1%>&flo2=<%=flo2%>&flo3=<%=flo3%>&cpg="+vPg,
					cache: false,
					success: function(message) {
						if(message!="") {
							if (vPg == 2) {
								$("#lyrBestList").append(message);
								vScrl=true;
								$('body,html').animate({scrollTop:currentScroll},0);
							}else{
								$("#lyrBestList").append(message);
								vScrl=true;
							}
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

	// Top버튼 위치 이동
//	$(".goTop").addClass("topHigh");

});

function changeCate(a){
	document.sFrm.cpg.value = 1;
	document.sFrm.disp.value = a;
	document.sFrm.submit();
}

function jsSortMet(a){
	document.sFrm.cpg.value = 1;
	document.sFrm.atype.value = a;
	document.sFrm.submit();
}

function goWishPop(i,ecd){
<% If IsUserLoginOK() Then ''ErBValue.value -> 공통파일의 구분값 (cate는 1) %>
	var wishpop = window.open('/common/popWishFolder.asp?ErBValue=14&ecode='+ecd+'&gb=search2017&itemid='+i+'','wishpop','')
<% Else %>
	top.location.href = "/login/login.asp?backpath=<%=fnBackPathURLChange(CurrURLQ())%>";
<% End If %>
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
function confirmAdultAuth(cPath){
	if(confirm('이 상품은 성인 인증이 필요한 상품입니다. 성인 확인을 위해 성인 인증을 진행합니다.')){
		var url = '/login/login_adult.asp?backpath='+ cPath;
		location.href = url;
	}
}

//가격대별 정렬
function jsGoUrl(catecode, price){
      location.href = "/clearancesale/index.asp?disp="+catecode+"&price="+price+"&srm=<%=SortMet%>&flo1=<%=flo1%>&flo2=<%=flo2%>&flo3=<%=flo3%>";
}

//무배 flo1
function chkfree(flo1,flo2,flo3){
	if(document.all.chksearchfree.checked==true){
		location.href = "/clearancesale/index.asp?disp=<%=catecode%>&price=<%=price%>&srm=<%=SortMet%>&flo1="+flo1+"&flo2="+flo2+"&flo3="+flo3;
	}
	if(document.all.chksearchfree.checked==false){
		location.href = "/clearancesale/index.asp?disp=<%=catecode%>&price=<%=price%>&srm=<%=SortMet%>&flo1=&flo2="+flo2+"&flo3="+flo3;
	}
}

//텐바이텐배송 flo2
function chktenbae(flo1,flo2,flo3){
	if(document.all.chksearchtenbae.checked==true){
		location.href = "/clearancesale/index.asp?disp=<%=catecode%>&price=<%=price%>&srm=<%=SortMet%>&flo1="+flo1+"&flo2="+flo2+"&flo3="+flo3;
	}
	if(document.all.chksearchtenbae.checked==false){
		location.href = "/clearancesale/index.asp?disp=<%=catecode%>&price=<%=price%>&srm=<%=SortMet%>&flo1="+flo1+"&flo2=&flo3="+flo3;
	}
}

//포장상품여부 flo3
function chkpojangok(flo1,flo2,flo3){
	if(document.all.chksearchpojangok.checked==true){
		location.href = "/clearancesale/index.asp?disp=<%=catecode%>&price=<%=price%>&srm=<%=SortMet%>&flo1="+flo1+"&flo2="+flo2+"&flo3="+flo3;
	}
	if(document.all.chksearchpojangok.checked==false){
		location.href = "/clearancesale/index.asp?disp=<%=catecode%>&price=<%=price%>&srm=<%=SortMet%>&flo1="+flo1+"&flo2="+flo2+"&flo3=";
	}
}
</script>
<style>
.topicV19 .sortingbarV19 .option-filter li input[type="checkbox"] + label:after {height: 1.3rem;}
</style>
</head>
<body class="default-font body-sub">
<!-- #include virtual="/lib/inc/incHeader.asp" -->
<div id="content" class="content">
	<div class="topicV19">
		<div class="titwrap bg-orange">
			<div class="tit-area">
				<div class="nav nav-stripe">
					<ul class="grid2">
						<li><a href="/shoppingtoday/shoppingchance_saleitem.asp">세일</a></li>
						<li><a href="/clearancesale/" class="on">클리어런스</a></li>
					</ul>
				</div>
				<h2>CLEARLANCE</h2>
			</div>
			<div class="tabwrap">
				<ul class="swiper-wrapper">
					<li class="swiper-slide <%=CHKIIF(price="all","on","")%>"><a href="" onClick="jsGoUrl('<%=catecode%>','all'); return false;">All</a></li>
					<li class="swiper-slide <%=CHKIIF(price="0","on","")%>"><a href="" onClick="jsGoUrl('<%=catecode%>','0'); return false;">1만원 미만</a></li>
					<li class="swiper-slide <%=CHKIIF(price="1","on","")%>"><a href="" onClick="jsGoUrl('<%=catecode%>','1'); return false;">1~3만원</a></li>
					<li class="swiper-slide <%=CHKIIF(price="3","on","")%>"><a href="" onClick="jsGoUrl('<%=catecode%>','3'); return false;">3~5만원</a></li>
					<li class="swiper-slide <%=CHKIIF(price="5","on","")%>"><a href="" onClick="jsGoUrl('<%=catecode%>','5'); return false;">5~10만원</a></li>
					<li class="swiper-slide <%=CHKIIF(price="10","on","")%>"><a href="" onClick="jsGoUrl('<%=catecode%>','10'); return false;">10만원 이상</a></li>
				</ul>
			</div>
		</div>
		<div class="sortingbarV19">
			<div class="option-slt">
				<div class="option-left">
					<div class="styled-selectbox styled-selectbox-default">
						<%
							'정렬상자 호출; sDisp:전시카테고리, sType:확장여부, sCallback:콜백함수명 (via functions.asp)
							Call fnPrntDispCateNaviV17BEST(catecode,"F","changeCate")
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
					<li><input type="checkbox" id="chksearchfree" name="chksearchfree" onclick="chkfree('free','<%= flo2 %>','<%= flo3 %>');" <% if flo1 = "free" then response.write "checked" %>><label for="chksearchfree">무료배송</label></li>
					<li><input type="checkbox" id="chksearchtenbae" name="chksearchtenbae" onclick="chktenbae('<%= flo1 %>','tenbae','<%= flo3 %>');" <% if flo2 = "tenbae" then response.write "checked" %>><label for="chksearchtenbae">텐바이텐 배송</label></li>
					<li><input type="checkbox" id="chksearchpojangok" name="chksearchpojangok" onclick="chkpojangok('<%= flo1 %>','<%= flo2 %>','pojangok');" <% if flo3 = "pojangok" then response.write "checked" %>><label for="chksearchpojangok">선물포장 상품</label></li>					
				</ul>
			</div>
		</div>
	</div>

	<div id="saleItems" class="new-items-list">
		<%'!-- item list :격자형 (클래스명 : type-grid)--%>
		<div class="items type-grid">
			<% IF oclearancelist.FResultCount >0 Then %>
			<ul id="lyrBestList">
				<% 
					For i=0 To oclearancelist.FResultCount-1 
						classStr = ""
						linkUrl = "/category/category_itemPrd.asp?itemid="& oclearancelist.FItemList(i).FItemID 
						adultChkFlag = session("isAdult") <> true and oclearancelist.FItemList(i).FadultType = 1																	
						
						if adultChkFlag then
							classStr = addClassStr(classStr,"adult-item")								
						end if															
				%>
				<li class="<%=classStr%>" <%=chkIIF(adultChkFlag, "onclick=""confirmAdultAuth('"&linkUrl&"');""","")%>>
					<a href="/category/category_itemPrd.asp?itemid=<%= oclearancelist.FItemList(i).FItemID %>">
						<%'// 해외직구배송작업추가 %>
						<% If oclearancelist.FItemList(i).IsDirectPurchase Then %>
							<span class="abroad-badge">해외직구</span>
						<% End If %>
						<div class="thumbnail">
							<img src="<%= getThumbImgFromURL(oclearancelist.FItemList(i).FImageBasic,286,286,"true","false") %>" alt="" />
							<% if adultChkFlag then %>									
							<div class="adult-hide">
								<p>19세 이상만 <br />구매 가능한 상품입니다</p>
							</div>
							<% end if %>							
							<%=CHKIIF(oclearancelist.FItemList(i).isSoldOut,"<b class='soldout'>일시 품절</b>","")%>
						</div>
						<div class="desc">
							<span class="brand"><% = oclearancelist.FItemList(i).FBrandName %></span>
							<p class="name"><% = oclearancelist.FItemList(i).FItemName %></p>
							<div class="price">
								<%
'									IF oclearancelist.FItemList(i).IsFreeBeasongCoupon() AND oclearancelist.FItemList(i).IsSaleItem then
'										vSaleFreeDeliv = "<div class=""tag shipping""><span class=""icon icon-shipping""><i>무료배송</i></span> FREE</div>"
'									End IF

									If oclearancelist.FItemList(i).IsSaleItem AND oclearancelist.FItemList(i).isCouponItem Then	'### 쿠폰 O 세일 O
										Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oclearancelist.FItemList(i).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
										Response.Write "&nbsp;<b class=""discount color-red"">" & oclearancelist.FItemList(i).getSalePro & "</b>"
										If oclearancelist.FItemList(i).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
											If InStr(oclearancelist.FItemList(i).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
												Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
											Else
												Response.Write "&nbsp;<b class=""discount color-green"">" & oclearancelist.FItemList(i).GetCouponDiscountStr & "<small>쿠폰</small></b>"
											End If
										End If
										Response.Write "</div>" &  vbCrLf
									ElseIf oclearancelist.FItemList(i).IsSaleItem AND (Not oclearancelist.FItemList(i).isCouponItem) Then	'### 쿠폰 X 세일 O
										Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oclearancelist.FItemList(i).getRealPrice,0) & "<span class=""won"">원</span></b>"
										Response.Write "&nbsp;<b class=""discount color-red"">" & oclearancelist.FItemList(i).getSalePro & "</b>"
										Response.Write "</div>" &  vbCrLf
									ElseIf oclearancelist.FItemList(i).isCouponItem AND (NOT oclearancelist.FItemList(i).IsSaleItem) Then	'### 쿠폰 O 세일 X
										Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oclearancelist.FItemList(i).GetCouponAssignPrice,0) & "<span class=""won"">원</span></b>"
										If oclearancelist.FItemList(i).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
											If InStr(oclearancelist.FItemList(i).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
												Response.Write "&nbsp;<b class=""discount color-green""><small>쿠폰</small></b>"
											Else
												Response.Write "&nbsp;<b class=""discount color-green"">" & oclearancelist.FItemList(i).GetCouponDiscountStr & "<small>쿠폰</small></b>"
											End If
										End If
										Response.Write "</div>" &  vbCrLf
									Else
										Response.Write "<div class=""unit""><b class=""sum"">" & FormatNumber(oclearancelist.FItemList(i).getRealPrice,0) & "<span class=""won"">" & CHKIIF(oclearancelist.FItemList(i).IsMileShopitem," Point","원") & "</span></b></div>" &  vbCrLf
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
						<% if oclearancelist.FItemList(i).FEvalcnt > 0 then %>
							<div class="tag review"><span class="icon icon-rating"><i style="width:<%=fnEvalTotalPointAVG(oclearancelist.FItemList(i).FPoints,"search")%>%;">리뷰 종합 별점</i></span><span class="counting" title="리뷰 갯수"><%=chkIIF(oclearancelist.FItemList(i).FEvalcnt>999,"999+",oclearancelist.FItemList(i).FEvalcnt)%></span></div>
						<% end if %>
						<button class="tag wish btn-wish" onclick="goWishPop('<%=oclearancelist.FItemList(i).FItemid%>','');">
						<%
						If oclearancelist.FItemList(i).FFavCount > 0 Then
							If fnIsMyFavItem(vWishArr,oclearancelist.FItemList(i).FItemID) Then
								Response.Write "<span class=""icon icon-wish on"" id=""wish"&oclearancelist.FItemList(i).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&oclearancelist.FItemList(i).FItemID&""">"
								Response.Write CHKIIF(oclearancelist.FItemList(i).FFavCount>999,"999+",formatNumber(oclearancelist.FItemList(i).FFavCount,0)) & "</span>"
							Else
								Response.Write "<span class=""icon icon-wish"" id=""wish"&oclearancelist.FItemList(i).FItemID&"""><i class=""hidden""> wish</i></span><span class=""counting"" id=""cnt"&oclearancelist.FItemList(i).FItemID&""">"
								Response.Write CHKIIF(oclearancelist.FItemList(i).FFavCount>999,"999+",formatNumber(oclearancelist.FItemList(i).FFavCount,0)) & "</span>"
							End If
						Else
							Response.Write "<span class=""icon icon-wish"" id=""wish"&oclearancelist.FItemList(i).FItemID&"""><i> wish</i></span><span class=""counting"" id=""cnt"&oclearancelist.FItemList(i).FItemID&"""></span>"
						End If
						%>
						</button>
						<% IF oclearancelist.FItemList(i).IsCouponItem AND oclearancelist.FItemList(i).GetCouponDiscountStr = "무료배송" Then %>
							<div class="tag shipping"><span class="icon icon-shipping"><i>무료배송</i></span> FREE</div>
						<% End If %>
					</div>
				</li>
				<% Next %>
			</ul>
			<% Else %>
			<div class="noClearData" style="display:none1;">
				<p>세일중인 <span class="cRd1">상품이 없습니다.</span></p>
			</div>
			<% End If %>
		</div>
	</div>
	<form name="sFrm" method="get" action="/clearancesale/index.asp" style="margin:0px;">
		<input type="hidden" name="cpg" value="<%=oclearancelist.FCurrPage %>">
		<input type="hidden" name="disp" value="<%= oclearancelist.FRectcatecode %>">
		<input type="hidden" name="atype" value="<%= oclearancelist.FRectSortMethod %>">
		<input type="hidden" name="price" value="<%= price %>">
		<input type="hidden" name="flo1" value="<%= flo1 %>">
		<input type="hidden" name="flo2" value="<%= flo2 %>">
		<input type="hidden" name="flo3" value="<%= flo3 %>">
	</form>
</div>
<div id="lyLoading" style="display:none;position:relative;text-align:center; padding:0; margin-top:-20px;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<%
set oclearancelist = nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->