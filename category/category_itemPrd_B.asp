<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->
<!-- #include virtual="/lib/classes/item/sp_evaluatesearchercls.asp" -->
<!-- #include virtual="/lib/classes/item/sp_item_qnacls.asp" -->
<!-- #include virtual="/lib/classes/item/PlusSaleItemCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/diarystory/diary_class.asp" -->
<!-- #include virtual="/lib/classes/award/newawardcls.asp" -->
<!-- #include virtual="/lib/classes/gift/gifttalkCls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/wishCls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
	dim itemid	: itemid = requestCheckVar(request("itemid"),9)
	Dim page, vDisp, cpid, vDepth

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
	vDisp = requestCheckVar(Request("disp"),18)
	if vDisp="" or (len(vDisp) mod 3)<>0 then vDisp = oItem.Prd.FcateCode

	'### 현재 위치 ###
	Dim vCateNavi, vCateItemCount, vIsLastDepth, vCateCnt
	vIsLastDepth = true
	vCateNavi = printCategoryHistorymultiNew(vDisp,vIsLastDepth,false,vCateCnt)
	vCateNavi = replace(vCateNavi," ()","")

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

	'//상품 문의
	Dim oQna
	set oQna = new CItemQna

	''스페셜 브랜드일경우 상품 문의 불러오기
	If (oItem.Prd.IsSpecialBrand and oItem.Prd.FQnaCnt>0) Then
		oQna.FRectItemID = itemid
		oQna.FPageSize = 5
		oQna.ItemQnaList
	End If

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

	'// 현장수령 상품
	Dim IsReceiveSiteItem
	IsReceiveSiteItem = (oItem.Prd.FDeliverytype="6")

	'=============================== 이메일특가 번호 접수 및 특가 계산 (base64사용) =================================
	cpid = requestCheckVar(request("ldv"),12)
	if Not(cpid="" or isNull(cpid)) then
		cpid = trim(Base64decode(cpid))
		if isNumeric(cpid) then
			oItem.getTargetCoupon cpid, itemid
		end if
	end if

	'//옵션 HTML생성
	dim ioptionBoxHtml
	IF (oitem.Prd.FOptionCnt>0) then
		if (IsReceiveSiteItem) or (IsPresentItem) or (IsTicketItem) or (oItem.Prd.Flimitdispyn="N") then
			ioptionBoxHtml = GetOptionBoxDpLimitHTML(itemid, oitem.Prd.IsSoldOut,Not(IsReceiveSiteItem) and Not(IsPresentItem and oItem.Prd.FRemainCount>200) and Not(IsTicketItem and oItem.Prd.FRemainCount>100 ) and Not(oItem.Prd.Flimitdispyn="N"))
		else
		    ioptionBoxHtml = GetOptionBoxHTML(itemid, oitem.Prd.IsSoldOut)
		end if
	End IF

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

	'2013 다이어리 상품 체크 유무
	Dim clsDiaryPrdCheck, GiftSu
	set clsDiaryPrdCheck = new cdiary_list
		clsDiaryPrdCheck.FItemID = itemid
		clsDiaryPrdCheck.DiaryStoryProdCheck
		If clsDiaryPrdCheck.FResultCount  > 0 then
			GiftSu = clsDiaryPrdCheck.getGiftDiaryExists(itemid)	'다이어리 상은품 남은수량
		end If

	'//상품설명 추가
	dim addEx
	set addEx = new CatePrdCls
		addEx.getItemAddExplain itemid

	Dim tempsource , tempsize

	tempsource = oItem.Prd.FItemSource
	tempsize = oItem.Prd.FItemSize

	'//내 위시 상품 여부
	dim isMyFavItem: isMyFavItem=false
	if IsUserLoginOK then
		isMyFavItem = getIsMyFavItem(LoginUserid,itemid)
	end if

	'### 쇼핑톡 카운트.
	Dim cTalk, vTalkCount, vTIItemID1, vTIItemName1, vTIItemID2, vTIItemName2, vTICount
	SET cTalk = New CGiftTalk
	cTalk.FPageSize = 5
	cTalk.FCurrpage = 1
	cTalk.FRectItemId = itemid
	cTalk.FRectUseYN = "y"
	cTalk.FRectOnlyCount = "o"
	''cTalk.sbGiftTalkList
	''vTalkCount = cTalk.FTotalCount ''않쓰임? //부하 많음.
	vTICount = 0

	If IsUserLoginOK Then
		cTalk.FPageSize = 2
		cTalk.FRectUserId = GetLoginUserID()
		cTalk.fnGiftTalkMyItemList
		vTICount = cTalk.FTotalCount
		If vTICount > 0 Then
			vTIItemID1		= cTalk.FItemList(0).FItemID
			vTIItemName1	= cTalk.FItemList(0).FItemName
		End If
		If vTICount > 1 Then
			vTIItemID2		= cTalk.FItemList(1).FItemID
			vTIItemName2	= "B. " & cTalk.FItemList(1).FItemName
			vTIItemID1		= cTalk.FItemList(0).FItemID
			vTIItemName1	= "A. " & cTalk.FItemList(0).FItemName
		End If
	End If
	SET cTalk = Nothing

	'RecoPick 스트립트 관련 내용 추가; 2014.02.25 허진원 추가
	'head.asp에서 출력
	strRecoPickMeta = "<meta property=""recopick:price"" content=""" & oItem.Prd.getRealPrice & """>" & vbCrLf
	strRecoPickMeta = strRecoPickMeta & "<meta property=""og:title"" content=""" & Replace(oItem.Prd.FItemName,"""","") & """>" & vbCrLf
	strRecoPickMeta = strRecoPickMeta & "<meta property=""og:image"" content=""" & getFirstAddimage & """>" & vbCrLf
	strRecoPickMeta = strRecoPickMeta & "<meta property=""product:price:amount"" content=""" & oItem.Prd.getRealPrice & """>" & vbCrLf
	strRecoPickMeta = strRecoPickMeta & "<meta property=""product:price:currency"" content=""KRW"">"
	IF oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut Then
		'품절일 경우 품절 태그 추가
		strRecoPickMeta = strRecoPickMeta & vbCrLf & "<meta property=""product:availability"" content=""oos"">"
	end if

	RecoPickSCRIPT = "	recoPick('page', 'view', '" & itemid & "');"										'incFooter.asp 에서 출력

	'GSShop WCS스크립트 관련 내용 추가; 2014.08.12 허진원 추가
	GSShopSCRIPT = "	var _wcsq = {pageType: ""PRD""};"													'incFooter.asp 에서 출력
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: <%= oItem.Prd.FItemName %></title>
	<script type="application/x-javascript" src="/lib/js/itemPrdDetail.js"></script>
	<script type="application/x-javascript" src="/lib/js/shoppingbag_script.js"></script>
	<script>
		$(function() {
			// Top버튼 위치 이동
			$(".goTop").addClass("topHigh");

			mySwiper0 = new Swiper('.location .swiper-container',{
				pagination:false,
				freeMode:true,
				freeModeFluid:true,
				initialSlide:<%=vCateCnt-1%>,
				slidesPerView: 'auto'
			})
		
			mySwiper1 = new Swiper('.swiper', {
				pagination : '.productImg .pagination',
				loop:false
			});
		
			mySwiper4 = new Swiper('.swiper4',{
				pagination:'.ctgyPopularList .pagination',
				paginationClickable:true,
				loop:true,
				resizeReInit:true,
				calculateHeight:true
			});

			// PLUS SALE
			mySwiper5 = new Swiper('.swiper5',{
				pagination:'.ctgyPlusSaleList .pagination',
				paginationClickable:true,
				loop:true,
				resizeReInit:true,
				calculateHeight:true
			});
		
			$(".tabList li").append('<span></span>');
		
			$(".tabArea .tabCont > div:first").show();
			$('.tabArea .tabList li').click(function(){
				$(".tabArea .tabCont > div").hide();
				$('.tabArea .tabList li').removeClass('active-nav');
				$(this).addClass('active-nav');
				var tabView = $(".tabArea .tabCont div[id|='"+ $(this).attr('name') +"']");
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
		
			//화면 회전시 리드로잉(지연 실행)
			$(window).on("orientationchange",function(){
				var oTm = setInterval(function () {
					mySwiper1.reInit();
					mySwiper3.reInit();
					mySwiper4.reInit();
						clearInterval(oTm);
					}, 500);
			});
		});

		function jsItemea(plusminus)
		{
			var vmin = parseInt(<%=chkIIF(oItem.Prd.IsLimitItemReal and oItem.Prd.FRemainCount<=0,"0",oItem.Prd.ForderMinNum)%>);
			var vmax = parseInt(<%=chkIIF(oItem.Prd.IsLimitItemReal,CHKIIF(oItem.Prd.FRemainCount<=oItem.Prd.ForderMaxNum,oItem.Prd.FRemainCount,oItem.Prd.ForderMaxNum),oItem.Prd.ForderMaxNum)%>);
			
			var v = parseInt(sbagfrm.itemea.value);
			if(plusminus == "+") {
				v++;
				if(v > vmax) v--;
			}
			else if(plusminus == "-") {
				if(v > 1) {
					v--;
				} else {
					v = 1;
				}
				if(v < vmin) v++;
			}
			sbagfrm.itemea.value = v;
		}

		// 관심 품목 담기 - 상품 페이지 전용 : 상품 코드로 변경
		function TnAddFavoritePrd(iitemid){
		<% If IsUserLoginOK() Then %>
			top.location.href="/common/popWishFolder.asp?itemid="+iitemid+"&ErBValue=3";
		<% Else %>
			top.location.href = "/login/login.asp?backpath=<%=Server.URLencode(CurrURLQ())%>";
		<% End If %>
		}

		//입력창
		function writeShoppingTalk(v) {
			location.href="/gift/gifttalk/talk_write.asp?itemid="+v;
		}
	</script>
</head>
<body>
<!-- #INCLUDE Virtual="/member/actnvshopLayerCont.asp" -->
<div class="heightGrid">
	<div class="mainSection">
		<div class="container bgGry">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<% If vDisp <> "111" Then %>
				<div class="location">
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<em class="swiper-slide"><a href="/">HOME</a></em>
							<%= vCateNavi %>
						</div>
					</div>
				</div>
				<% End If %>

				<%
					If clsDiaryPrdCheck.FResultCount > 0 then '//다이어리 상품 체크 유무
				%>
				<!-- 2015 다이어리 스토리 : 배너 추가 -->
				<div class="inner10">
					<p><a href="/diarystory2015/"><img src="http://fiximage.10x10.co.kr/m/2014/diarystory2015/img_bnr_diarystory2015.gif" alt="2015 다이어리 스토리 다이어리 구매시 무료배송과 사은품 혜택을 드립니다." /></a></p>
				</div>
				<% 
					End If 
				%>

				<div class="itemPrd inner5">
					<div class="box1">
						<div class="pdtCont">
							<p class="pBrand"><a href="/street/street_brand.asp?makerid=<%=oItem.Prd.Fmakerid%>"><%=oItem.Prd.FBrandName%></a></p>
							<p class="pName"><%= oItem.Prd.FItemName %></p>
							<p class="pFlag">
							<% IF oItem.Prd.IsSoldOut Then %>
							<span class="fgSoldout">품절</span>
							<% Else %>
								<% if oItem.Prd.IsTenOnlyitem then %><span class="fgOnly">ONLY</span> <% end if %>
								<% IF oItem.Prd.isNewItem Then %><span class="fgNew">NEW</span> <% End If %>
								<% IF oItem.Prd.IsSaleItem THEN %><span class="fgSale">SALE</span> <% End If %>
								<% if oitem.Prd.isCouponItem Then %><span class="fgCoupon">쿠폰</span> <% End If %>
								<% IF oItem.Prd.isLimitItem Then %><span class="fgLimit">한정</span> <% End If %>
								<% if oItem.getGiftExists(itemid) then %><span class="fgPlus">1+1</span> <% end if %>
								<% IF oItem.Prd.IsFreeBeasong Then %><span class="fgFree">무료배송</span> <% End If %>
								<% IF oItem.Prd.IsSoldOut Then %><span class="fgSoldout">품절</span> <% End if %>
							<% End if %>
							</p>

							<% If IsUserLoginOK Then %>
							<p class="giftFlag <% IF vTICount > 0 Then response.write "giftFlagOn" End If %>" onclick="writeShoppingTalk('<%=itemid%>'); return false;">
								GIFT<br />TALK<em>+</em>
							</p>
							<% else %>
							<p class="giftFlag" onClick="if(confirm('로그인이 필요한 서비스입니다.\n로그인 하시겠습니까?') == true){location.href = '<%=M_SSLUrl%>/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>';}; return false;">
								GIFT<br />TALK<em>+</em>
							<% end if %>
						</div>

						<div class="productImg">
							<div class="swiper-container swiper">
								<div class="swiper-wrapper">
								<%
								'//기본 이미지
								Response.Write "<div class=""swiper-slide""><img src=""" & oItem.Prd.FImageBasic & """ alt=""" & replace(oItem.Prd.FItemName,"""","") & """ style=""width:100%;"" /></div>"
								'//누끼 이미지
								if Not(isNull(oItem.Prd.FImageMask) or oItem.Prd.FImageMask="") then
									Response.Write "<div class=""swiper-slide""><img src=""" & oItem.Prd.FImageMask & """ alt=""" & replace(oItem.Prd.FItemName,"""","") & """ style=""width:100%;"" /></div>"
								end if
								'//추가 이미지
								IF oAdd.FResultCount > 0 THEN
									FOR i= 0 to oAdd.FResultCount-1
										'If i >= 3 Then Exit For
										IF oAdd.FADD(i).FAddImageType=0 THEN
											Response.Write "<div class=""swiper-slide""><img src=""" & oAdd.FADD(i).FAddimage & """ alt=""" & replace(oItem.Prd.FItemName,"""","") & """ style=""width:100%;"" /></div>"
										End IF
									NEXT
								END IF
								%>
								</div>
							</div>
							<div class="pagination"></div>
							<% IF (oItem.Prd.isLimitItem) and (not (oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut)) and (Not IsReceiveSiteItem) and Not(IsPresentItem and oItem.Prd.FRemainCount>200 ) and Not(IsTicketItem and oItem.Prd.FRemainCount>100 ) Then %>
							<p class="pLimit">한정수량 <strong class="cBk1"><% = oItem.Prd.FRemainCount %>개</strong> 남았습니다.</p>
							<% end if %>
							<% If GiftSu > 0 Then %>
							<p class="pLimit">다이어리 사은품 <strong class="cBk1"><% = GiftSu %>개</strong> 남았습니다.</p>
							<% end if %>
						</div>
						<dl class="pPrice tMar10">
							<dt><%=chkIIF(Not(IsTicketItem),"판매가","티켓기본가")%></dt>
							<dd><%= FormatNumber(oItem.Prd.getOrgPrice,0) %><% if oItem.Prd.IsMileShopitem then %>Point<% else %>원<% end  if %></dd>
						</dl>
						<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
						<dl class="pPrice">
							<dt>할인판매가</dt>
							<dd><span class="cRd1">
							<%
								If oItem.Prd.FOrgprice = 0 Then
									Response.Write "[0%] "
								Else
									Response.Write "[" & CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) & "%] "
								End If
								Response.Write FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","원")
							%>
							</span></dd>
						</dl>
						<% end if %>
						<% if oItem.Prd.IsSaleItem and oItem.Prd.IsSpecialUserItem then %>
						<dl class="pPrice">
							<dt>
								우수회원가
								<span class="icoHot"><a href="/my10x10/special_shop.asp"><em class="rdBtn2">우수회원샵</em></a></span>
							</dt>
							<dd><span class="cRd1">[<% = getSpecialShopPercent() %>%] <%= FormatNumber(oItem.Prd.getRealPrice,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></span></dd>
						</dl>
						<% end if %>
						<% if oitem.Prd.isCouponItem Then %>
						<dl class="pPrice">
							<dt>쿠폰적용가</dt>
							<dd><span class="cGr1">[<%= oItem.Prd.GetCouponDiscountStr %>] <%= FormatNumber(oItem.Prd.GetCouponAssignPrice,0) %>원</span></dd>
						</dl>
						<% end if %>
						<dl class="pPrice">
							<dt>배송구분</dt>
							<dd>
							<%
								if oItem.Prd.IsAboardBeasong then
									if oItem.Prd.IsFreeBeasong then
										Response.Write "텐바이텐 무료배송+해외배송"
									else
										Response.Write "텐바이텐배송+해외배송"
									end if
								else
									Response.Write oItem.Prd.GetDeliveryName
								end if
							%>
							</dd>
						</dl>
						<% if oItem.Prd.FMileage then %>
						<dl class="pPrice">
							<dt>마일리지</dt>
							<dd><% = oItem.Prd.FMileage %> Point</dd>
						</dl>
						<% end if %>

						<% if oitem.Prd.isCouponItem Then %>
						<div class="btnWrap downBtn">
							<span class="button btB2 btGrn cWh1"><a href="" onclick="jsDownCoupon('prd','<%= oitem.Prd.FCurrItemCouponIdx %>'); return false;"><em><%= oItem.Prd.GetCouponDiscountStr %> 쿠폰 받기</em></a></span>
						</div>
						<form name="frmC" method="get" action="/shoppingtoday/couponshop_process.asp" style="margin:0px;">
						<input type="hidden" name="stype" value="" />
						<input type="hidden" name="idx" value="" />
						</form>
						<% end if %>
					</div>

					<form name="sbagfrm" method="post" action="" style="margin:0px;">
					<input type="hidden" name="mode" value="add" />
					<input type="hidden" name="itemid" value="<% = oitem.Prd.FItemid %>" />
					<input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
					<input type="hidden" name="itemoption" value="" />
					<input type="hidden" name="userid" value="<%= LoginUserid %>" />
					<input type="hidden" name="isPresentItem" value="<%= isPresentItem %>" />

					<% IF oItem.Prd.FOptionCnt>0 then %>
					<h2 class="tit02 tMar25"><span>옵션</span></h2>
					<%= ioptionBoxHtml %>
					<% end if %>

					<% if oItem.Prd.FItemDiv = "06" then %>
					<p class="tPad05">
						<textarea name="requiredetail" id="requiredetail" style="width:100%;" rows="4" placeholder="[문구입력란] 문구를 입력해 주세요."></textarea>
					</p>
					<% end if %>

					<% if IsPresentItem then %>
					<div class="tPad20 prdNum">
						<div class="fs11">(한번에 하나씩만 구매가 가능합니다.)</div>
						<input type="hidden" name="itemea" readonly value="1" />
					</div>
					<% else %>
					<div class="prdNum">
						<span class="numMn"><a href="" onClick="jsItemea('-');return false;">갯수 감소</a></span>
						<p><input name="itemea" readonly type="text" value="1" style="width:100%;" /></p>
						<span class="numPl"><a href="" onclick="jsItemea('+');return false;">갯수 증가</a></span>
					</div>
					<% end if %>
					</form>

					<%
						'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
						dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
						snpTitle = Server.URLEncode(oItem.Prd.FItemName)
						snpLink = Server.URLEncode("http://10x10.co.kr/" & itemid)
						snpPre = Server.URLEncode("텐바이텐 HOT ITEM!")
						snpImg = Server.URLEncode(oItem.Prd.FImageBasic)

						'기본 태그
						snpTag = Server.URLEncode("텐바이텐 " & Replace(oItem.Prd.FItemName," ",""))
						snpTag2 = Server.URLEncode("#10x10")
					%>
					<div class="shareListup">
						<ul>
							<li class="twitter"><a href="" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>'); return false;">트위터</a></li>
							<li class="facebook"><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','',''); return false;">페이스북</a></li>
							<li class="pinterest"><a href="" onclick="pinit('<%=snpLink%>','<%=snpImg%>'); return false;">핀터레스트</a></li>
							<li class="kakaotalk"><a href="" id="kakaoa">카카오톡</a></li>
							<!-- #Include virtual="/category/inc_kakaolink.asp" -->
							<li class="line"><a href="" onclick="popSNSPost('ln','<%=snpTitle%>','<%=snpLink%>','',''); return false;">라인</a></li>
						</ul>
					</div>

					<!--// Plussale //-->
					<!-- #Include virtual="/category/inc_PlusSaleList.asp" -->

					<div class="tabArea tMar25">
						<div class="prdDetailTab swiper-nav">
							<ul class="tabList">
							<% If IsPresentItem then 'Present상품 %>
								<li class="active-nav" name="tab01" tno="1">설명</li>
								<li name="tab02" tno="2">후기<%=chkIIF(oEval.FTotalCount>0,"("&oEval.FTotalCount&")","")%></li>
							<% ElseIf IsTicketItem Then '티켓상품 %>
								<li class="active-nav" name="tab01" tno="1">설명</li>
								<li name="tab02" tno="2">관람평<%=chkIIF(oEval.FTotalCount>0,"("&oEval.FTotalCount&")","")%></li>
								<li name="tab03" tno="5">공연장 정보</li>
								<li name="tab04" tno="6">취소환불/수령</li>
							<%
								Else
									'//일반상품
									If oItem.Prd.IsSpecialBrand then
							%>
								<li class="active-nav" name="tab01" tno="1">설명</li>
								<li name="tab02" tno="2">후기<%=chkIIF(oEval.FTotalCount>0,"("&oEval.FTotalCount&")","")%></li>
								<li name="tab03" tno="3">Q&amp;A<%=chkIIF(oQna.FTotalCount>0,"("&oQna.FTotalCount&")","")%></li>
							<%		Else %>
								<li class="active-nav" name="tab01" tno="1">설명</li>
								<li name="tab02" tno="2">후기<%=chkIIF(oEval.FTotalCount>0,"("&oEval.FTotalCount&")","")%></li>
							<%
									end if
								end if
							%>
							</ul>
						</div>
						<div class="prdDetailCont box1 swiper-container">
							<div class="tabCont swiper-wrapper">
								<!-- tab.01: 설명 -->
								<div class="swiper-slide" id="tab01">
									<div class="inner10">
										<p class="fs11 lPad05"><strong>상품코드 : <%=itemid%></strong></p>
										<!-- 상품속성 -->
										<ul class="prdBasicInfo">
										<% If (Not IsTicketItem) Then '// 티켓아닌경우 - 일반상품 %>
											<%
												IF addEx.FResultCount > 0 THEN
													FOR i= 0 to addEx.FResultCount-1
														If addEx.FItem(i).FinfoCode = "35005" Then
															If tempsource <> "" then
															response.write "<li><strong>재질 :</strong> "&tempsource&" </li>"
															End If
															If tempsize <> "" then
															response.write "<li><strong>사이즈 :</strong> "&tempsize&" </li>"
															End If
														End If
											%>
												<li style="display:<%=chkiif(addEx.FItem(i).FInfoContent="" And addEx.FItem(i).FinfoCode ="02004" ,"none","")%>;"><strong><%=addEx.FItem(i).FInfoname%> :</strong> <%=addEx.FItem(i).FInfoContent%></li>
											<%
													Next
												End If
											%>
											<% if oItem.Prd.IsSafetyYN then %>
											<li><strong>안전인증대상 :</strong> <%=oItem.Prd.FsafetyNum%></li>
											<% End If %>
											<% if oItem.Prd.IsAboardBeasong then %>
											<li><strong>해외배송 기준 중량 :</strong> <% = formatNumber(oItem.Prd.FitemWeight,0) %> g (1차 포장을 포함한 중량)</li>
											<% End If %>
										<% else		'// 티켓상품 %>
											<li><strong>장르 :</strong> <%=oTicket.FOneItem.FtxGenre%></li>
											<li><strong>일시 :</strong> <%= FormatDate(oTicket.FOneItem.FstDt,"0000.00.00") %>~<%= FormatDate(oTicket.FOneItem.FedDt,"0000.00.00") %></li>
											<li><strong>장소 :</strong> <%=oTicket.FOneItem.FticketPlaceName%></li>
											<li><strong>관람등급 :</strong> <%=oTicket.FOneItem.FtxGrade%></li>
											<li><strong>관람시간 :</strong> <%=oTicket.FOneItem.FtxRunTime%></li>
										<% end if %>
										</ul>

										<% IF Not(oItem.Prd.FOrderComment="" or isNull(oItem.Prd.FOrderComment)) or Not(oItem.Prd.getDeliverNoticsStr="" or isNull(oItem.Prd.getDeliverNoticsStr)) THEN %>
										<!-- 주의사항 -->
										<dl class="prdDesp">
											<dt>주문 주의사항</dt>
											<dd><%= oItem.Prd.getDeliverNoticsStr %> <%= nl2br(oItem.Prd.FOrderComment) %></dd>
										</dl>
										<% end if %>

										<!-- 상세설명 -->
										<div class="btnWrap detailBtn">
											<span class="button btM1 btRed cWh1"><a href="/category/category_itemPrd_detail.asp?itemid=<%=itemid%>">상품상세 보기</a></span>
										</div>
									</div>
								</div>
								
								<!-- 추가 tab -->
								<div class="swiper-slide" id="tab02" style="display:none;"></div>
								<div class="swiper-slide" id="tab03" style="display:none;"></div>
								<div class="swiper-slide" id="tab04" style="display:none;"></div>
								<!-- //추가 tab -->
							</div>
						</div>
					</div>
					<% If (Not IsTicketItem) Then '티켓아닌경우 - 일반상품 %>
					<!--// Wish Collection //-->
					<div id="lyrWishCol"></div>
					<script type="text/javascript">
						$.ajax({
							type: "get",
							url: "act_wishCollection.asp?itemid=<%=itemid%>",
							cache: false,
							success: function(message) {
								$("#lyrWishCol").empty().html(message);
							}
						});
					</script>
					<!--// Category Best //-->
					<!-- #include virtual="/category/inc_category_best.asp" -->
					<!--// Event Item //-->
					<!-- #Include virtual="/category/inc_ItemEventList_B.asp" -->
					<% end if %>

				</div>
			</div>

			<div class="floatingBar">
				<div class="btnWrap cartBtnWrap">
				<%
					if IsPresentItem then	'## Present상품
						IF Not(oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut) Then
							If IsUserLoginOK() Then		'# 로그인한 경우
				%>
					<div><span class="button btB1 btRed cWh1"><a href="" onclick="TnAddShoppingBag(true);return false;">바로신청</a></span></div>
				<%			else %>
					<div><span class="button btB1 btRed cWh1"><a href="" onclick="alert('회원 구매만 가능합니다. 로그인 후 구매해 주세요.');return false;">바로신청</a></span></div>
				<%
							end if
						else
				%>
					<div><span class="button btB1 btGry2 cWh1"><a href="" onclick="return false;">품절</a></span></div>
				<%
						end if
					else	'## 일반상품
				%>
					<% IF Not(oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut or oItem.Prd.IsMileShopitem) Then %>
					<div><span class="button btB1 btRed cWh1"><a href="" onclick="TnAddShoppingBag();return false;">바로구매</a></span></div>
					<% end if %>
					<% IF Not(oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut) Then %>
					<div><span class="button btB1 btRedBdr cRd1"><a href="" onclick="TnAddShoppingBag(true);return false;">장바구니</a></span></div>
					<% else %>
					<div><span class="button btB1 btGry2 cWh1"><a href="" onclick="return false;">품절</a></span></div>
					<% end if %>
				<% end if %>
					<div class="wishBtn <%=chkIIF(isMyFavItem,"wishOn","")%>" style="width:30%;"><span class="button btB1 btGryBdr cGy1"><a href="" onclick="TnAddFavoritePrd('<% = oItem.Prd.Fitemid %>');return false;"><em><%=FormatNumber(oItem.Prd.FFavCount,0)%></em></a></span></div>
				</div>
			</div>

			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->

			<form name="qnaform" method="post" action="/my10x10/doitemqna.asp" target="iiBagWin" style="margin:0px;">
			<input type="hidden" name="id" value="" />
			<input type="hidden" name="itemid" value="<% = itemid %>" />
			<input type="hidden" name="mode" value="del" />
			<input type="hidden" name="flag" value="fd" />
			</form>
			<iframe src="" name="iiBagWin" frameborder="0" width="0" height="0"></iframe>
		</div>
	</div>
</div>
<script language="JavaScript" type="text/javascript" SRC="/lib/js/todayview.js"></script>
</body>
</html>
<%
	Set oItem = Nothing
	set clsDiaryPrdCheck = Nothing
	Set addEx = Nothing

	If IsTicketItem Then
		set oTicket = Nothing
	end If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->