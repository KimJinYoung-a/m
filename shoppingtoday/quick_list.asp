<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description :  new List
' History : 2015-10-01 이종화 생성
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
strHeadTitleName ="바로배송"

Dim vDisp : vDisp = getNumeric(requestCheckVar(request("disp"),15))
Dim vDepth, i,TotalCnt, vSaleFreeDeliv
	vDepth = "1"
dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),9))
dim searchFlag 	: searchFlag = "qq"
dim CurrPage 	: CurrPage = getNumeric(requestCheckVar(request("cpg"),9))
dim SortMet		: SortMet = requestCheckVar(request("srm"),2)

dim ListDiv,ScrollCount
ListDiv="fulllist"
ScrollCount = 5

if CurrPage="" then CurrPage=1
PageSize =20

If SortMet = "" Then SortMet = "be"		'정렬 기본값 : 인기순

dim oDoc,iLp, vWishArr
set oDoc = new SearchItemCls
	oDoc.FListDiv 			= ListDiv
	oDoc.FRectSortMethod	= SortMet
	oDoc.FRectSearchFlag 	= searchFlag
	oDoc.FPageSize 			= PageSize
	oDoc.FRectCateCode		= vDisp
	oDoc.FCurrPage 			= CurrPage
	oDoc.FSellScope 		= "Y"
	oDoc.FScrollCount 		= ScrollCount
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
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script type="text/javascript">
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
	var wishpop = window.open('/common/popWishFolder.asp?ErBValue=13&ecode='+ecd+'&gb=search2017&itemid='+i+'','wishpop','')
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

var vPg=1, vScrl=true;
$(function(){
	// 스크롤시 추가페이지 접수
	$(window).scroll(function() {
		if ($(window).scrollTop() >= ($(document).height()-$(window).height())-512){
			if(vScrl) {
				vScrl = false;
				vPg++;
				$.ajax({
					url: "act_quick_list.asp?cpg="+vPg,
					data: $("#sFrm").serialize(),
					cache: false,
					success: function(message) {
						if(message!="") {
							$("#lyrEvtList").append(message);
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
	});

	// 로딩중 표시
	$("#lyLoading").ajaxStart(function(){
		$(this).show();
	}).ajaxStop(function(){
		$(this).hide();
	});
});

$(function() {
	$(window).scroll(sticky_sortingbar);
});

function sticky_sortingbar() {
	var window_top = $(window).scrollTop();
	var div_top = $("#newItems").offset().top;
	if (window_top >= div_top) {
		$("#newItems").addClass('sticky');
	} else {
		$("#newItems").removeClass('sticky');
	}
}
</script>
</head>
<body class="default-font body-sub">
<!-- #include virtual="/lib/inc/incHeader.asp" -->
<%
	'// 바로배송 종료에 따른 처리
	If now() > #07/31/2019 12:00:00# Then
		Response.Write "<script>alert('바로배송 서비스가 종료되었습니다.');location.href='/index.asp';</script>"
		response.end
	Else
%>
	<div id="content" class="content">
			<!-- 바로배송 배너 -->
			<div class="bnr-quick-delivery">
				<a href="#" onclick=fnOpenModal('/category/popQuickGuide.asp');return false;>
					<p>주문하고 바로바로, 바로 배송</p>
					<p>서울 어디라도, 오후 1시 전에 주문하면<br /><span class="color-blue">그날 오후에 바로</span> 받아보실 수 있습니다!</p>
					<p class="btn btn-xsmall color-black btn-radius btn-icon">바로배송 안내<span class="icon icon-arrow"></span></p>
					<span class="icon icon-quick"></span>
				</a>
			</div>
			<% IF (now()<#19/07/2018 00:00:00#) then %>																
				<!-- 바로배송 이벤트 기간에만 노출 -->
				<div class="quick-event">
					<p>오픈기념 배송료 할인 이벤트! <s>5,000</s> <strong>2,500원</strong></p>
					<p class="period">2018년 7월 18일까지</p>
				</div>
			<%End if%>
		<div id="newItems" class="new-items-list">
			<!-- 건수 및 정렬 옵션 셀렉트박스 -->
			<div class="sortingbar">
				<div class="option-left">
					<p class="total"><b><%=FormatNumber(TotalCnt,0)%></b>건</p>
				</div>
				<div class="option-right">
					<div class="styled-selectbox styled-selectbox-default">
						<%
							'정렬상자 호출; sDisp:전시카테고리, sType:확장여부, sCallback:콜백함수명 (via functions.asp)
							Call fnPrntDispCateNaviV17BEST(vDisp,"F","changeCate")
						%>
					</div>
					<div class="styled-selectbox styled-selectbox-default">
						<%
							'정렬상자 호출; sType:정렬방법, sUse:사용처 구분, sCallback:콜백함수명 (via functions.asp)
							Call fnPrntSortNaviver17(SortMet, "jsSortMet")
						%>
					</div>
				</div>
			</div>

			<%'!-- item list :격자형 (클래스명 : type-grid)--%>
			<div class="items type-grid">
				<% IF oDoc.FResultCount >0 Then %>
				<ul id="lyrEvtList">
					<% For i=0 To oDoc.FResultCount-1 %>
					<% If oDoc.FItemList(i).FItemDiv="21" Then %>
					<li class="deal-item">
						<a href="/deal/deal.asp?itemid=<%= oDoc.FItemList(i).FItemID %>&disp=<%= oDoc.FItemList(i).FCateCode %>">
						<span class="deal-badge">텐텐<i>DEAL</i></span>
							<div class="thumbnail"><img src="<%= getThumbImgFromURL(oDoc.FItemList(i).FImageBasic,286,286,"true","false") %>" alt="" /><%=CHKIIF(oDoc.FItemList(i).isSoldOut,"<b class='soldout'>일시 품절</b>","")%></div>
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
					<li <%=CHKIIF(oDoc.FItemList(i).isSoldOut,"class=soldOut","")%>>
						<a href="/category/category_itemPrd.asp?itemid=<%= oDoc.FItemList(i).FItemID %>&disp=<%= oDoc.FItemList(i).FCateCode %>">
							<div class="thumbnail"><img src="<%= getThumbImgFromURL(oDoc.FItemList(i).FImageBasic,286,286,"true","false") %>" alt="" /><%=CHKIIF(oDoc.FItemList(i).isSoldOut,"<b class='soldout'>일시 품절</b>","")%></div>
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
		<input type="hidden" name="itemid" value="">
		<input type="hidden" name="ErBValue" value="6">
		</form>
	</div>
	<div id="lyLoading" style="display:none;position:relative;text-align:center; padding:20px 0;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
<% End If %>
<!-- //content area -->
<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<% Set oDoc = Nothing %>