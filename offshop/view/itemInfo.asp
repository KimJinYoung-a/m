<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'#######################################################
'	Description : 상품상세
'	History	:  2015.06.02 한용민 생성
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->
<!-- #include virtual="/lib/classes/item/sp_evaluatesearchercls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
dim itemid	: itemid = requestCheckVar(request("itemid"),9)
Dim page, vDisp, cpid, vDepth, vMakerid

if page="" then page=1

if itemid="" or itemid="0" then
	Call Alert_Return("상품번호가 없습니다.")
	response.End
elseif Not(isNumeric(itemid)) then
	Call Alert_Return("잘못된 상품번호입니다.")
	response.End
else
	'정수형태로 변환
	itemid=CLng(getNumeric(itemid))
end if

dim LoginUserid
LoginUserid = getLoginUserid()

dim flag : flag = request("flag")

dim oItem, ItemContent
set oItem = new CatePrdCls
oItem.GetItemData itemid

if oItem.FResultCount=0 then
	Call Alert_Return("존재하지 않는 상품입니다.")
	response.End
end if

if oItem.Prd.Fisusing="N" then
	Call Alert_Return("판매가 종료되었거나 삭제된 상품입니다.")
	response.End
end if

'// 파라메터 접수
vDisp = requestCheckVar(getNumeric(Request("disp")),18)
if vDisp="" or (len(vDisp) mod 3)<>0 then vDisp = oItem.Prd.FcateCode

'// 브랜드ID 접수
vMakerid = oItem.Prd.Fmakerid

'// 추가 이미지
dim oADD
set oADD = new CatePrdCls
oADD.getAddImage itemid

'//상품 후기
dim oEval,i,j,ix
set oEval = new CEvaluateSearcher
oEval.FPageSize = 8
oEval.FScrollCount = 5
oEval.FCurrpage = page
oEval.FRectItemID = itemid

	'상품 후기가 있을때만 쿼리.
	if oItem.Prd.FEvalCnt>0 then
		oEval.getItemEvalList
	end if

'// 티켓팅
Dim IsTicketItem, oTicket
IsTicketItem = (oItem.Prd.FItemDiv = "08")
If IsTicketItem Then
	set oTicket = new CTicketItem
	oTicket.FRectItemID = itemid
	oTicket.GetOneTicketItem
End if

'// Present상품
Dim IsPresentItem
IsPresentItem = (oItem.Prd.FItemDiv = "09")

'2015 APP전용 상품 안내
if IsPresentItem or oItem.Prd.FOrgMakerid="10x10present" or itemid=1250336 then
	Call Alert_Move("본 상품은 텐바이텐 APP에서만 보실 수 있습니다.","/")
	dbget.Close: Response.End
end if

function ImageExists(byval iimg)
	if (IsNull(iimg)) or (trim(iimg)="") or (Right(trim(iimg),1)="\") or (Right(trim(iimg),1)="/") then
		ImageExists = false
	else
		ImageExists = true
	end if
end function

'// 추가 이미지-메인 이미지
Function getFirstAddimage()
	if ImageExists(oitem.Prd.FImageBasic) then
		getFirstAddimage= oitem.Prd.FImageBasic
	elseif ImageExists(oitem.Prd.FImageMask) then
		getFirstAddimage= oitem.Prd.FImageMask
	elseif (oAdd.FResultCount>0) then
		if ImageExists(oAdd.FADD(0).FAddimage) then
			getFirstAddimage= oAdd.FADD(0).FAddimage
		end if
	else
		getFirstAddimage= oitem.Prd.FImageMain
	end if
end Function

'//상품설명 추가
dim addEx
set addEx = new CatePrdCls
	addEx.getItemAddExplain itemid

Dim tempsource , tempsize

tempsource = oItem.Prd.FItemSource
tempsize = oItem.Prd.FItemSize

'RecoPick 스트립트 관련 내용 추가; 2014.02.25 허진원 추가
'head.asp에서 출력
strOGMeta = "<meta property=""recopick:price"" content=""" & oItem.Prd.getRealPrice & """>" & vbCrLf
strOGMeta = strOGMeta & "<meta property=""og:title"" content=""" & Replace(oItem.Prd.FItemName,"""","") & """>" & vbCrLf
strOGMeta = strOGMeta & "<meta property=""og:image"" content=""" & getFirstAddimage & """>" & vbCrLf
strOGMeta = strOGMeta & "<meta property=""product:price:amount"" content=""" & oItem.Prd.getRealPrice & """>" & vbCrLf
strOGMeta = strOGMeta & "<meta property=""product:price:currency"" content=""KRW"">"
IF oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut Then
	'품절일 경우 품절 태그 추가
	strOGMeta = strOGMeta & vbCrLf & "<meta property=""product:availability"" content=""oos"">"
end if
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: <%= oItem.Prd.FItemName %></title>
<script type="text/javascript">

$(function() {
	// product Image swipe
	mySwiper1 = new Swiper('.pdtImgV16a .swiper-container', {
		resizeReInit:true,
		calculateHeight:true,
		pagination:'.pdtImgV16a .paginationDot',
		paginationClickable:true,
		simulateTouch:false
	});

	// product detail tab control
	$(".itemDeatilV16a .tabCont > div:first").show();
	$('.itemDeatilV16a .commonTabV16a li').click(function(){
		$(".itemDeatilV16a .tabCont > div").hide();
		$('.itemDeatilV16a .commonTabV16a li').removeClass('current');
		$(this).addClass('current');
		var tabView = $(".itemDeatilV16a .tabCont div[id|='"+ $(this).attr('name') +"']");
		var tabNum = $(this).attr('tno');
		//탭내용 넣기
		if($(tabView).html()=="") {
			var tabFile = "category_itemprd_ajax.asp?itemid=<%=itemid%>&tabno="+tabNum+"&tnm="+$(this).attr('name');
			if(tabFile!="") {
				$.ajax({
					type: "get",
					url: tabFile,
					cache: false,
					success: function(message) {
						$(tabView).empty().html(message);
					}
				});
			}
		}
		$(tabView).show();
	});

	// 로딩중 표시
	$("#lyLoading").ajaxStart(function(){
		$(this).show();
	}).ajaxStop(function(){
		$(this).hide();
	});
});

</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container" style="background-color:#e7eaea;">
			<div class="headerV16a">
				<header>
					<h1 class="logoOn"><a href="#">텐바이텐</a></h1>
				</header>
			</div>
			<!-- content area -->
			<div class="content" id="contentArea" style="padding-bottom:0;">
				<div class="itemPrdV16a">
					<div class="itemInfoBoxV16a">
						<div class="pdtImgV16a">
							<div class="swiper">
								<div class="swiper-container">
									<div class="swiper-wrapper">
									<%
										'//기본 이미지
										Response.Write "<div class=""swiper-slide""><img src=""" & getThumbImgFromURL(oItem.Prd.FImageBasic,400,400,"true","false") & """ alt=""" & replace(oItem.Prd.FItemName,"""","") & """ style=""width:100%;"" /></div>"
										'//누끼 이미지
										if Not(isNull(oItem.Prd.FImageMask) or oItem.Prd.FImageMask="") then
											Response.Write "<div class=""swiper-slide""><img src=""" & getThumbImgFromURL(oItem.Prd.FImageMask,400,400,"true","false") & """ alt=""" & replace(oItem.Prd.FItemName,"""","") & """ style=""width:100%;"" /></div>"
										end If
										'//추가 이미지
										IF oAdd.FResultCount > 0 THEN
											FOR i= 0 to oAdd.FResultCount-1
												'If i >= 3 Then Exit For
												IF oAdd.FADD(i).FAddImageType=0 THEN
													Response.Write "<div class=""swiper-slide""><img src=""" & getThumbImgFromURL(oAdd.FADD(i).FAddimage,400,400,"true","false") & """ alt=""" & replace(oItem.Prd.FItemName,"""","") & """ style=""width:100%;"" /></div>"
												End IF
											NEXT
										END If

										'// 텐바이텐 기본이미지 추가(이미지 올렸을시 생성되는 50*50사이즈 이미지 추가노출)
										If Not(isNull(oitem.Prd.Ftentenimage) Or oitem.Prd.Ftentenimage = "") Then
											Dim viTentenimg, viTententmb
											if ImageExists(oitem.Prd.Ftentenimage1000) Then
												viTentenimg = oitem.Prd.Ftentenimage1000
											ElseIf ImageExists(oitem.Prd.Ftentenimage600) Then
												viTentenimg = oitem.Prd.Ftentenimage600
											ElseIf ImageExists(oitem.Prd.Ftentenimage) Then
												viTentenimg = oitem.Prd.Ftentenimage
											End If

											If viTentenimg<>"" Then
												viTententmb = oitem.Prd.Ftentenimage50
											End If
											Response.Write "<div class=""swiper-slide""><img src=""" & viTentenimg & """ alt=""" & replace(oItem.Prd.FItemName,"""","") & """ style=""width:100%;"" /></div>"
										End If
									%>
									</div>
								</div>
								<div class="paginationDot"></div>
							</div>
						</div>
						<div class="itemInfoV16a tMar1-3r">
							<p class="pBrand"><a href="#" click="return false;"><%=oItem.Prd.FBrandName%></a></p>
							<h2><p class="pName"><%= oItem.Prd.FItemName %></p></h2>
						</div>
					</div>

					<%' 상품상세설명 영역 %>
					<div class="itemDeatilV16a">
						<!-- #include virtual="/offshop/view/category_itemprd_detail.asp" -->
					</div>
					<%'// 상품상세설명 영역 %>
				</div>
			</div>
			<!-- //content area -->
			<div class="footer">
				<footer>
					<p class="tPad10">(주) 텐바이텐 <span>l</span> 대표이사 : 최은희 <span>l</span> 서울시 종로구 대학로 57 홍익대학교 대학로캠퍼스 교육동 14층</p>
				</footer>
				<p class="footerSns">
					<a href="http://facebook.com/your10x10" target="_blank" class="snsF">facebook</a>
					<a href="http://twitter.com/your10x10" target="_blank" class="snsT">twitter</a>
					<a href="http://pinterest.com/your10x10/" target="_blank" class="snsP">pinterest</a>
					<a href="http://instagram.com/your10x10" target="_blank" class="snsI">instagram</a>
				</p>
				<p class="copyright">Copyright &copy; Tenbyten inc.</p>
				<span id="gotop" class="goTop">TOP</span>
			</div>
		</div>
	</div>
</div>
</body>
</html>

<%
Set oItem = Nothing
Set addEx = Nothing

If IsTicketItem Then
	set oTicket = Nothing
end If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->