<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description :  쿠폰북
' History : 2014.06.25 한용민 www 이전/생성
' History : 2014-09-01 이종화 renewal
' History : 2014-11-12 원승현 renewal
' History : 2017-10-25 유태욱 페이징변경
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_itemcouponcls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
dim itemcouponidx, ocouponitemlist, page, makerid,sailyn, i, lp
dim vDisp : vDisp = getNumeric(requestCheckVar(request("disp"),15))
	itemcouponidx = requestCheckVar(request("itemcouponidx"),32)
	makerid = requestCheckVar(request("makerid"),32)
	page = requestCheckVar(request("page"),32)
	sailyn = requestCheckVar(request("sailyn"),1)

if itemcouponidx="" then itemcouponidx=0
if page="" then page=1

set ocouponitemlist = new CItemCouponMaster
	ocouponitemlist.FPageSize=20
	ocouponitemlist.FCurrPage=page
	ocouponitemlist.FRectItemCouponIdx = itemcouponidx
	ocouponitemlist.FRectCateCode		= vDisp
	''ocouponitemlist.GetItemCouponItemList
	ocouponitemlist.GetItemCouponItemListCaChe
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script type="text/javascript">
function changeCate(a){
	document.frm.page.value = 1;
	document.frm.disp.value = a;
	document.frm.submit();
}

var vPg=1, vScrl=true;
$(function(){
	// 스크롤시 추가페이지 접수
	$(window).scroll(function() {
		if ($(window).scrollTop() >= ($(document).height()-$(window).height())-512){
			if(vScrl) {
				vScrl = false;
				vPg++;
				$('input[name="page"]').val(vPg);
				$.ajax({
					url: "Pop_CouponItemList_ajax.asp",
					data: $("#frm").serialize(),
					cache: false,
					success: function(message) {
						if(message!="") {
							$("#couponlist").append(message);
							vScrl=true;
						} else {
							$(window).unbind("scroll");
							return;
						}
					}
					,error: function(err) {
						document.write(err.responseText); 
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

function goPage(page){
	frm.page.value=page;
	frm.submit();
}

function goWishPop(i){
<% If IsUserLoginOK() Then ''ErBValue.value -> 공통파일의 구분값 (cate는 1) %>
	document.sFrm.itemid.value = i;
	document.sFrm.action = "/common/popWishFolder.asp";
	sFrm.submit();
<% Else %>
	top.location.href = "/login/login.asp?backpath=<%=fnBackPathURLChange(CurrURLQ())%>";
<% End If %>
}

</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<!--div class="prevPage" style="background-color:#fafafa;">
					<a href="" onclick="location.href='/my10x10/couponbook.asp'; return false;"><em class="elmBg">&lt; 이전으로</em></a>
				</div-->

				<div class="couponItemList inner10" style="padding-top:0;">
					<div class="sortingbar">
						<div class="option-left">
							<p class="total">쿠폰적용상품 : <b class="color-red"><%=FormatNumber(ocouponitemlist.FTotalCount, 0)%></b>개</p>
						</div>
						<div class="option-right">
							<div class="styled-selectbox styled-selectbox-default">
							<%
								'정렬상자 호출; sDisp:전시카테고리, sType:확장여부, sCallback:콜백함수명 (via functions.asp)
								''Call fnPrntDispCateNaviV17CouponList(vDisp,"F","changeCate", itemcouponidx)
								Call fnPrntDispCateNaviV17CouponListCaChe(vDisp,"F","changeCate", itemcouponidx)
							%>
							</div>
						</div>
					</div>

					<div class="pdtListWrap">
						<ul class="pdtList" id="couponlist">
							<% if ocouponitemlist.FResultCount > 0 then %>
								<% for i=0 to ocouponitemlist.FResultCount - 1 %>	
									<li onclick="location.href='/category/category_itemPrd.asp?itemid=<%= ocouponitemlist.FItemList(i).FItemID %>'" class="soldOut">
										<div class="pPhoto"><img src="<%= ocouponitemlist.FitemList(i).FImageIcon1 %>" alt="<%= ocouponitemlist.FitemList(i).FItemName %>" alt="<%= ocouponitemlist.FitemList(i).FItemName %>"></div><%' for dev msg : 상품명 alt값 속성에 넣어주세요 %>
										<div class="pdtCont">
											<p class="pBrand"><%= ocouponitemlist.FitemList(i).FMakerid %></p>
											<p class="pName"><%= ocouponitemlist.FitemList(i).FItemName %></p>
											<p class="pPrice"><%= FormatNumber(ocouponitemlist.FitemList(i).GetCouponSellcash,0) %>원 
												<span class="cGr1">
													<% if ocouponitemlist.FitemList(i).Fitemcoupontype="1" then %>
														[<%=ocouponitemlist.FitemList(i).Fitemcouponvalue%>%]
													<% ElseIf ocouponitemlist.FitemList(i).Fitemcoupontype="3" Then %>
														[무료배송]
													<% else %>
														[<%=ocouponitemlist.FitemList(i).Fitemcouponvalue%>원 할인]
													<% end if %>
												</span>
											</p>
											<p class="pShare">
												<span class="cmtView"><%=formatNumber(ocouponitemlist.FItemList(i).FEvalCnt,0)%></span>
												<span class="wishView"><%=formatNumber(ocouponitemlist.FItemList(i).FfavCount,0)%></span>
											</p>
										</div>
									</li>
								<% Next %>
							<% End If %>
						</ul>
					</div>
					<div id="lyLoading" style="display:none;position:relative;text-align:center; padding:0; margin-top:-20px;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
				</div>
				
			</div>
			<!-- //content area -->
		<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
<form name="frm" method="get" id="frm" action="">
	<input type="hidden" name="page" value="">
	<input type="hidden" name="itemcouponidx" value="<%= itemcouponidx %>">
	<input type="hidden" name="disp" value="<%= vDisp%>">
</form>
</body>
</html>

<%
set ocouponitemlist = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->