<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description :  바로배송 서비스 안내페이지
' History : 2018-06-27 최종원
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
	oDoc.FRectSearchFlag 	= searchFlag
	oDoc.FRectCateCode		= vDisp
	oDoc.FSellScope 		= "Y"
	oDoc.FminPrice 			= 10000
	oDoc.FRectSortMethod	= SortMet
	oDoc.FPageSize 			= 100

	oDoc.getSearchList
	
TotalCnt = oDoc.FTotalCount

'바로배송 전 상품  count
dim quickDlvCntObj
set quickDlvCntObj = new SearchItemCls

quickDlvCntObj.FListDiv 	= ListDiv
quickDlvCntObj.FRectSortMethod	= SortMet
quickDlvCntObj.FRectSearchFlag 	= searchFlag

quickDlvCntObj.FSellScope			= "Y"
quickDlvCntObj.FRectSearchItemDiv ="D"

quickDlvCntObj.getSearchList
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style>
.notice {background-color:#499afd;}
.notice ul {padding:0 8% 8%;}
.notice ul li {position:relative; padding-left:0.8rem; margin:0.5rem 0; text-align:left; color:#fff; font-size:1.11rem; line-height:1.2; letter-spacing:-0.5px; font-family:malgungothic, '맑은고딕', sans-serif;}
.notice ul li:before {content:''; display:block; position:absolute; left:0; top:0.45rem; width:0.3rem; height:0.3rem; border-radius:50%; background-color:#f6fe29;}
.current-view {position:relative; width:100%;}
.current-view .current-txt {position:absolute; width:100%; left:0; top:21%; text-align:center; color:#fff; font-size:2.05rem; letter-spacing:-0.05rem;}
.current-view .current-txt p {padding:0.5rem 0;}
.current-view .current-txt p span {padding:0 0.21rem; color:#bdff20; font-weight:bold;}
.current-view .btn-link {position:absolute; width:50%; left:25%; top:60%;}
.baro-best100 {padding-bottom:5rem; background-color:#fff;}
.baro-best100 .type-grid {border-top:0;}
</style>
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

</script>
</head>
<body class="default-font body-sub bg-grey"><!-- for dev msg : GNB메뉴에서 들어갈때만 body-main클래스가 붙습니다. 그 이외의 페이지에서는 body-sub가 붙습니다. -->
<!-- #include virtual="/lib/inc/incHeader.asp" -->
<%
	'// 바로배송 종료에 따른 처리
	If now() > #07/31/2019 12:00:00# Then
		Response.Write "<script>alert('바로배송 서비스가 종료되었습니다.');location.href='/index.asp';</script>"
		response.end
	Else
%>
	<div id="content" class="content" style="padding-bottom:0;">
		<!-- 이벤트 배너 등록 영역 -->
		<div class="evtContV15">
			<div class="baro-quick">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/baroquick/m/tit_baro.png" alt="주문하고 그날 바로 받는 당일배송 서비스 텐바이텐 바로배송" /></h2>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2018/baroquick/m/img_process_v2.png" alt="바로배송 배송료는 5,000원 이며 오후 1시 이전 결제완료 된 상품에 대해 그날 저녁까지 바로 배송합니다." /></p>
				<div class="notice">
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/baroquick/m/subtit_notice.png" alt="알아두기" /></h3>
					<ul>
						<li>바로배송은 <strong>배송지가 서울 지역</strong>일 경우에만 가능한 배송 서비스입니다.</li>
						<li><strong>주문 당일 오후 1시 전 결제완료된 주문에만 신청 가능</strong>하며, 오후 1시 이후 신청 시 다음날 배송이 시작됩니다.</li>
						<li>더욱 더 빠른 배송 서비스를 위해 주말/공휴일에는 쉽니다.</li>
						<li>상품의 <strong>부피/무게에 따라 배송 유/무 또는 요금이 달라질 수</strong> 있습니다.</li>
						<li>바로배송 서비스에는 <strong>무료배송 쿠폰을 적용할 수 없습니다.</strong></li>
					</ul>
				</div>
				<div class="current-view">
					<div class="current-txt">
						<p>현재<span><%=FormatNumber(quickDlvCntObj.FTotalCount,0)%></span>개의 상품이</p>
						<p>바로배송을 지원합니다.</p>
					</div>
					<p class="btn-link"><a href="/shoppingtoday/quick_list.asp"><img src="http://webimage.10x10.co.kr/eventIMG/2018/baroquick/m/btn_allview.png" alt="전체상품보기" /></a></p>
					<img src="http://webimage.10x10.co.kr/eventIMG/2018/baroquick/m/bg_current.png" alt="" />
				</div>
				<div class="baro-best100">
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/baroquick/m/subtit_best100.png" alt="베스트 상품도 바로바로! 바로배송 베스트 100" /></h3>
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
					<p class="tMar1-8r"><a href="/shoppingtoday/quick_list.asp"><img src="http://webimage.10x10.co.kr/eventIMG/2018/baroquick/m/btn_allview2.png" alt="바로배송 전체상품보기" /></a></p>
				</div>
			</div>
		</div>
		<!--// 이벤트 배너 등록 영역 -->
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