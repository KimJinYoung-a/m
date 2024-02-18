<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
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
<!-- #include virtual="/lib/classes/shoppingtalk/shoppingtalkCls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<%
	dim itemid	: itemid = requestCheckVar(request("itemid"),9)
	Dim page, vDisp

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

	dim PcdL, PcdM, PcdS, lp
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
	If vDisp = "" Then
		vDisp = oItem.Prd.FcateCode
	End If

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

	'//옵션 HTML생성
	dim ioptionBoxHtml
	IF (oitem.Prd.FOptionCnt>0) then
		if (IsReceiveSiteItem) or (IsPresentItem) or (IsTicketItem) then
			ioptionBoxHtml = GetOptionBoxDpLimitHTML(itemid, oitem.Prd.IsSoldOut,Not(IsReceiveSiteItem) and Not(IsPresentItem and oItem.Prd.FRemainCount>200) and Not(IsTicketItem and oItem.Prd.FRemainCount>100 ))
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
	'set clsDiaryPrdCheck = new cdiary_list
	'	clsDiaryPrdCheck.FItemID = itemid
	'	clsDiaryPrdCheck.DiaryStoryProdCheck
	'	If clsDiaryPrdCheck.FResultCount  > 0 then
	'		GiftSu = clsDiaryPrdCheck.getGiftDiaryExists(itemid)	'다이어리 상은품 남은수량
	'	end If

	'//상품설명 추가
	dim addEx
	set addEx = new CatePrdCls
		addEx.getItemAddExplain itemid

	Dim tempsource , tempsize

	tempsource = oItem.Prd.FItemSource
	tempsize = oItem.Prd.FItemSize


	'### 쇼핑톡 카운트.
	Dim cTalk, vTalkCount, vTIItemID1, vTIItemName1, vTIItemID2, vTIItemName2, vTICount
	SET cTalk = New CShoppingTalk
	cTalk.FPageSize = 5
	cTalk.FCurrpage = 1
	cTalk.FRectItemId = itemid
	cTalk.FRectUseYN = "y"
	cTalk.FRectOnlyCount = "o"
	cTalk.fnShoppingTalkList
	vTalkCount = cTalk.FTotalCount

	If IsUserLoginOK Then
		cTalk.FPageSize = 2
		cTalk.FRectUserId = GetLoginUserID()
		cTalk.fnShoppingTalkMyItemList
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
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script src="/lib/js/swiper-2.1.min.js"></script>
<script src="/lib/js/swiper.scrollbar-1.0.js"></script>
<title>10x10: <%= oItem.Prd.FItemName %></title>
<script type="application/x-javascript" src="/lib/js/itemPrdDetail.js"></script>
<script type="application/x-javascript" src="/lib/js/ajax_List.js"></script>
<script type="application/x-javascript" src="/lib/js/shoppingbag_script.js"></script>
	<script>

		function jsCheckLimit() {
			if ("<%=IsUserLoginOK%>"=="False") {
				jsChklogin('<%=IsUserLoginOK%>');
			}
		}

		function onLoadFunc() {
			swiper = new Swiper('.swiper', {
				pagination : '.pagination',
				loop:false
			});

			$('.expMoreView').click(function(){
				$('.productSpec > ul').addClass('extend');
				$(this).addClass('hidden');
				return false;
			});

			$('.imgMoreView').click(function(){
				$('.productImgDetail .imgArea').addClass('extend');
				$(this).addClass('hidden');
				return false;
			});

			$('.qnaList .q').click(function(){
				$(this).toggleClass('extend');
				$(this).next('.a').toggleClass('aView');
				return false;
			});

			pdtSwiper1 = new Swiper('.pdtSwiper1',{
				pagination:false,
				slidesPerView: 'auto'
			});

			pdtSwiper2 = new Swiper('.pdtSwiper2',{
				pagination:false,
				slidesPerView: 'auto'
			});

			$(".bestNsale .tabItem03 li:nth-child(2)").click(function(){
				pdtSwiper3 = new Swiper('.pdtSwiper3',{
					pagination:false,
					slidesPerView: 'auto'
				});
			});

			$('.pdtTabArea').each(function() {
				$(this).find('.morePdtList:first').show();
				$(this).find(".tabItem03 li").click(function(){
					var myWrap = $(this).parents('.pdtTabArea');
					myWrap.find(".morePdtList").hide();
					myWrap.find(".tabItem03 li").removeClass("current");
					$(this).addClass("current");
					var tabView = $(this).attr("name");
					myWrap.find(".morePdtList[id|='"+ tabView +"']").show();
				});
			});
		}

		// tab 호출
		function goTabView(v,t) {
			$(".tabItem li").removeClass("on");
			$("#tabno"+t).addClass("on");

			var gourl = 'category_itemprd_ajax.asp?itemid=<%=itemid%>&tabno='+v;

			$("div#tabcontents").empty();
			$.ajax({
				type: "get",
				url: gourl,
				cache: false,
				success: function(message) {
					$("div#tabcontents").empty().append(message);
					if(t==1) {
						$('div#tabcontents').find("img").css("width","100%");
					}
					onLoadFunc();
				}
			});
		}

		function jsItemea(plusminus)
		{
			var v = parseInt(sbagfrm.itemea.value);
			if(plusminus == "+")
			{
				v = v + 1;
			}
			else if(plusminus == "-")
			{
				if(v > 1)
				{
					v = v - 1;
				}
				else
				{
					v = 1;
				}
			}
			sbagfrm.itemea.value = v;
		}

		function jsClearArea(){
			sbagfrm.requiredetail.value = "";
		}

		// 관심 품목 담기 - 상품 페이지 전용 : 상품 코드로 변경
		function TnAddFavoritePrd(iitemid){
		    //self.location='/my10x10/popMyFavorite.asp?ispop=pop&mode=add&itemid=' + iitemid + '&backurl=<%=Replace(CurrURLQ(),"&","^")%>';

			var popwin = window.open('/my10x10/popMyFavorite.asp?ispop=pop&mode=add&itemid=' + iitemid + '&backurl=<%=Replace(CurrURLQ(),"&","^")%>', 'FavoritePrd', 'width=500,height=500,scrollbars=yes,resizable=yes');
			popwin.focus();
		}

		function writeShoppingTalk()
		{
			var popwin1 = window.open('/shoppingtalk/talk_write.asp', 'popShoppingTalk', 'width=500,height=500,scrollbars=yes,resizable=yes');
			popwin1.focus();
		}

		function showTalkDiv()
		{
			$.ajax({
					url: "/shoppingtalk/category_itemPrd_talk_Ajax.asp",
					cache: false,
					success: function(message)
					{
						$(".talkPop").show();
						$(".talkPop").empty().append(message);
					}
			});
		}

		function closeTalkDiv()
		{
			$.ajax({
					url: "/category/doShoppingTalkProc.asp?gubun=d",
					cache: false,
					success: function(message)
					{
						$(".talkPop").hide();
					}
			});
		}

		// 로딩 후 상세컨텐츠 브랜드명으로 top 이동
		$(document).ready(function(){
			var position = $(".innerH15W10").offset();
			$('html,body').animate({scrollTop: position.top}, 1000);
		});
	</script>
</head>
<body>
<!-- #INCLUDE Virtual="/member/actnvshopLayerCont.asp" -->
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<% If vDisp <> "111" Then %>
				<div class="prevPage btmGyBdr">
					<a href="/">HOME</a> &gt; <% Call printCategoryHistorymulti(vDisp) %>
				</div>
				<% End If %>
				<div class="talkPop" style="display:<%=CHKIIF(vTICount>0,"block","none")%>;">
				<% If vTICount > 0 Then %>
					<dl style="width:80%;">
						<dt class="b ftMid tPad03">상품에 대한 조언이 필요하다면, 쇼핑톡!</dt>
						<dd class="tPad10">
							<p class="ftMidSm3 c888 b textOver lh14"><a href="/category/category_itemPrd.asp?itemid=<%=vTIItemID1%>"><u><%=vTIItemName1%></u></a></p>
							<% If vTICount > 1 Then %>
								<p class="ftMidSm3 c888 b tPad05 textOver lh14"><a href="/category/category_itemPrd.asp?itemid=<%=vTIItemID2%>"><u><%=vTIItemName2%></u></a></p>
							<% End If %>
							<% If vTICount < 2 Then %><p class="ftSmall c888 tPad05">★ “쇼핑톡+” 이용하여 상품추가 선택시 비교 가능</p><% End If %>
						</dd>
					</dl>
					<div class="popBtn">
						<p><span class="btn btn3a gryB w60B"><a href="javascript:" onClick="closeTalkDiv();">취소</a></span></p>
						<p class="tPad05"><span class="btn btn3a redB w60B"><a href="javascript:" onClick="writeShoppingTalk();">질문</a></span></p>
					</div>
				<% End If %>
				</div>

				<div class="innerH15W10">
					<% If oItem.Prd.FBrandUsing = "Y" Then %>
					<p class="c999 ftMid"><a href="/street/street_brand.asp?makerid=<%=oItem.Prd.Fmakerid%>"><u><%=oItem.Prd.FBrandName%></u></a></p>
					<% Else %>
					<p class="c999 ftMid"><u><%=oItem.Prd.FBrandName%></u></p>
					<% End If %>
					<p class="b tMar05"><%= oItem.Prd.FItemName %></p>
				</div>

				<div class="innerW">
					<div class="productImg">
						<div class="swiper-main">
							<div class="swiper-container swiper">
								<div class="swiper-wrapper">
								<%
								'//기본 이미지
								Response.Write "<div class=""swiper-slide""><div class=""line""></div><img src=""" & oItem.Prd.FImageBasic & """ alt=""" & oItem.Prd.FItemName & """ style=""width:100%;"" /></div>"
								'//누끼 이미지
								if Not(isNull(oItem.Prd.FImageMask) or oItem.Prd.FImageMask="") then
									Response.Write "<div class=""swiper-slide""><div class=""line""></div><img src=""" & oItem.Prd.FImageMask & """ alt=""" & oItem.Prd.FItemName & """ style=""width:100%;"" /></div>"
								end if
								'//추가 이미지
								IF oAdd.FResultCount > 0 THEN
									FOR i= 0 to oAdd.FResultCount-1
										If i >= 3 Then Exit For
										IF oAdd.FADD(i).FAddImageType=0 THEN
											Response.Write "<div class=""swiper-slide""><div class=""line""></div><img src=""" & oAdd.FADD(i).FAddimage & """ alt=""" & oItem.Prd.FItemName & """ style=""width:100%;"" /></div>"
										End IF
									NEXT
								END IF
								%>
								</div>
							</div>
						</div>
						<div class="slidePage pagination"></div>
					</div>
				</div>

				<div class="productInfo innerW topGyBdr btmGyBdr bgGry2">
					<div class="bgWt overHidden innerH">
						<dl class="overHidden">
							<dt class="ftLt c999"><%=chkIIF(Not(IsTicketItem),"판매가","티켓기본가")%></dt>
							<dd class="ftRt rt ftMid"><%= FormatNumber(oItem.Prd.getOrgPrice,0) %><% if oItem.Prd.IsMileShopitem then %> Point<% else %> 원<% end  if %></dd>
						</dl>

						<% IF oItem.Prd.IsSaleItem THEN %>
						<dl class="overHidden">
							<dt class="ftLt c999">할인판매가</dt>
							<dd class="ftRt rt ftMid"><span class="cC40">[<% = oItem.Prd.getSalePro %>] <%= FormatNumber(oItem.Prd.getRealPrice,0) %> 원</span></dd>
						</dl>
						<% end if %>
						<% if oitem.Prd.isCouponItem Then %>
						<dl class="overHidden">
							<dt class="ftLt c999">쿠폰적용가</dt>
							<dd class="ftRt rt ftMid"><span class="c2c9336">[<%= oItem.Prd.GetCouponDiscountStr %>] <%= FormatNumber(oItem.Prd.GetCouponAssignPrice,0) %> 원</span></dd>
						</dl>
						<div class="couponBox c555">
							<a href="javascript:jsDownCoupon('prd','<%= oitem.Prd.FCurrItemCouponIdx %>');"><%= oItem.Prd.GetCouponDiscountStr %> 쿠폰받기</a>
						</div>
						<form name="frmC" method="get" action="/shoppingtoday/couponshop_process.asp" style="margin:0px;">
						<input type="hidden" name="stype" value="" />
						<input type="hidden" name="idx" value="" />
						</form>
						<% end if %>
						<% IF (oItem.Prd.isLimitItem) and (not (oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut)) and (Not IsReceiveSiteItem) and Not(IsPresentItem and oItem.Prd.FRemainCount>200 ) and Not(IsTicketItem and oItem.Prd.FRemainCount>100 ) Then %>
						<div class="rt b topDotBdr innerW20 c999 ftMid tMar10 tPad10">
							한정수량 <span class="c555"><% = oItem.Prd.FRemainCount %>개</span> 남았습니다.
						</div>
						<% end if %>
						<% If GiftSu > 0 Then %>
						<div class="rt b topDotBdr innerW20 c999 ftMid tMar10 tPad10">
							다이어리 사은품 <span class="c555"><% = GiftSu %>개</span> 남았습니다.
						</div>
						<% end if %>
						<div class="rt topDotBdr tMar10 innerW20 tPad10">
						<% IF oItem.Prd.IsSoldOut Then %>
						<img src="http://fiximage.10x10.co.kr/m/2012/category/ico_soldout.gif" alt="soldout" style="height:14px;" />
						<% Else %>
							<% if oitem.Prd.isCouponItem Then %><img src="http://fiximage.10x10.co.kr/m/2013/common/tag_coupon.png" alt="쿠폰" style="height:14px;" class="rMar02" /><% End If %>
							<% IF oItem.Prd.IsFreeBeasong Then %><img src="http://fiximage.10x10.co.kr/m/2013/common/tag_free.png" alt="무료배송" style="height:14px;" class="rMar02" /><% End If %>
							<% IF oItem.Prd.isLimitItem Then %><img src="http://fiximage.10x10.co.kr/m/2013/common/tag_limit.png" alt="한정" style="height:14px;" class="rMar02" /><% End If %>
							<% IF oItem.Prd.isNewItem Then %><img src="http://fiximage.10x10.co.kr/m/2013/common/tag_new.png" alt="NEW" style="height:14px;" class="rMar02" /><% End If %>
							<% IF oItem.Prd.IsSaleItem THEN %><img src="http://fiximage.10x10.co.kr/m/2013/common/tag_sale.png" alt="SALE" style="height:14px;" class="rMar02" /><% End If %>
							<% IF oItem.Prd.IsSoldOut Then %><img src="http://fiximage.10x10.co.kr/m/2013/common/tag_soldout.png" alt="soldout" style="height:14px;" /><% End if %>
						<% End if %>
						</div>
					</div>

					<form name="sbagfrm" method="post" action="" style="margin:0px;">
					<input type="hidden" name="mode" value="add" />
					<input type="hidden" name="itemid" value="<% = oitem.Prd.FItemid %>" />
					<input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
					<input type="hidden" name="itemoption" value="" />
					<input type="hidden" name="userid" value="<%= LoginUserid %>" />
					<input type="hidden" name="isPresentItem" value="<%= isPresentItem %>" />
					<% if oItem.Prd.FItemDiv = "06" then %>
					<div class="bdr1">
						<div class="bgWt">
							<textarea name="requiredetail" id="requiredetail" style="width:98%; height:50px;" onClick="jsClearArea();">문구를 입력해 주세요.</textarea>
						</div>
					</div>
					<% End If %>
					<% IF oItem.Prd.FOptionCnt>0 then %>
					<dl class="productOption tMar10">
						<dt class="ftMid">옵션</dt>
						<dd>
							<ul>
								<%= ioptionBoxHtml %>
							</ul>
						</dd>
					</dl>
					<% end if %>

					<div class="productNum tMar10">
					<% if IsPresentItem then %>
						<strong><span class="srcnum">1</span>개</strong> <span style="font-size:0.85em">(한번에 하나씩만 구매가 가능합니다.)</span>
						<input name="itemea" type="hidden" value="1" />
					<% else %>
						<button class="numSub" onClick="jsItemea('-');return false;">-</button>
						<input name="itemea" type="text"  value="1" />
						<button class="numAdd" onclick="jsItemea('+');return false;">+</button>
					<% end if %>
					</div>
					</form>
					<!--
					<div class="bgWt overHidden innerH">
						<dl class="overHidden">
							<dt class="ftLt">총금액</dt>
							<dd class="ftRt rt b">184,000 원</dd>
						</dl>
					</div>
					//-->
					<div class="bgWt"></div>
				</div>
				<%
					'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
					dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
					snpTitle = Server.URLEncode(oItem.Prd.FItemName)
					snpLink = Server.URLEncode("http://10x10.co.kr/" & itemid)
					snpPre = Server.URLEncode("텐바이텐 HOT ITEM!")
					snpImg = Server.URLEncode(oItem.Prd.FImageBasic)
					Select Case itemid
					Case 429052
						'시크릿가든 상품
						snpTag = Server.URLEncode("텐바이텐 시크릿가든 secret garden 하지원 현빈 " & Replace(oItem.Prd.FItemName," ",""))
						snpTag2 = Server.URLEncode("#10x10 #secretgarden #시크릿가든_")
					Case Else
						'기본 태그
						snpTag = Server.URLEncode("텐바이텐 " & Replace(oItem.Prd.FItemName," ",""))
						snpTag2 = Server.URLEncode("#10x10")
					End Select
				%>
				<div class="detailSns">
					<span><a class="snsFacebook elmBg" href="javascript:popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','')">페이스북 공유</a></span>
					<span><a class="snsTwitter elmBg" href="javascript:popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>')">트위터 공유</a></span>
					<span><a class="snsKatalk elmBg" href="javascript:kakaoLink('item','<%=itemid%>')">카카오톡 공유</a></span>
					<span><a class="snsPinter elmBg" href="javascript:pinit('<%=snpLink%>','<%=snpImg%>')">핀터레스트 공유</a></span>
				</div>

				<ul class="tabItem" style="margin-top:65px;">
				<% If IsPresentItem then 'Present상품 %>
					<li class="on" style="width:34%;" id="tabno1"><a href="javascript:goTabView(1,1);" style="height:33px;"><dfn>상품<br />상세설명</dfn><span class="elmBg tMar10 vTop"></span></a></li>
					<li style="width:33%;" id="tabno2"><a href="javascript:goTabView(2,2);" style="height:33px;"><dfn>후기<br />(<%= oEval.FTotalCount %>)</dfn><span class="elmBg tMar10 vTop"></span></a></li>
					<li style="width:33%;" id="tabno4"><a href="javascript:goTabView(4,4);" style="height:33px;"><dfn>쇼핑톡<br />(<%=vTalkCount%>)</dfn><span class="elmBg tMar10 vTop"></span></a></li>
				<% ElseIf IsTicketItem Then '티켓상품 %>
					<li class="on" style="width:25%;" id="tabno1"><a href="javascript:goTabView(1,1);" style="height:33px;"><dfn>상품<br />상세설명</dfn><span class="elmBg tMar10 vTop"></span></a></li>
					<li style="width:25%;" id="tabno2"><a href="javascript:goTabView(2,2);" style="height:33px;"><dfn>관람평<br />(<%= oEval.FTotalCount %>)</dfn><span class="elmBg tMar10 vTop"></span></a></li>
					<li style="width:25%;" id="tabno3"><a href="javascript:goTabView(5,3);" style="height:33px;"><dfn>공영장<br />정보</dfn><span class="elmBg tMar10 vTop"></span></a></li>
					<li style="width:25%;" id="tabno4"><a href="javascript:goTabView(6,4);" style="height:33px;"><dfn>취소환불<br />/수령</dfn><span class="elmBg tMar10 vTop"></span></a></li>
				<%
					Else
						'//일반상품
						If oItem.Prd.IsSpecialBrand then
				%>
					<li class="on" style="width:25%;" id="tabno1"><a href="javascript:goTabView(1,1);" style="height:33px;"><dfn>상품<br />상세설명</dfn><span class="elmBg tMar10 vTop"></span></a></li>
					<li style="width:25%;" id="tabno2"><a href="javascript:goTabView(2,2);" style="height:33px;"><dfn>후기<br />(<%= oEval.FTotalCount %>)</dfn><span class="elmBg tMar10 vTop"></span></a></li>
					<li style="width:25%;" id="tabno3"><a href="javascript:goTabView(3,3);" style="height:33px;"><dfn>Q&A<br />(<%= oQna.FTotalCount%>)</dfn><span class="elmBg tMar10 vTop"></span></a></li>
					<li style="width:25%;" id="tabno4"><a href="javascript:goTabView(4,4);" style="height:33px;"><dfn>쇼핑톡<br />(<%=vTalkCount%>)</dfn><span class="elmBg tMar10 vTop"></span></a></li>
				<%		Else %>
					<li class="on" style="width:34%;" id="tabno1"><a href="javascript:goTabView(1,1);" style="height:33px;"><dfn>상품<br />상세설명</dfn><span class="elmBg tMar10 vTop"></span></a></li>
					<li style="width:33%;" id="tabno2"><a href="javascript:goTabView(2,2);" style="height:33px;"><dfn>후기<br />(<%= oEval.FTotalCount %>)</dfn><span class="elmBg tMar10 vTop"></span></a></li>
					<li style="width:33%;" id="tabno4"><a href="javascript:goTabView(4,4);" style="height:33px;"><dfn>쇼핑톡<br />(<%=vTalkCount%>)</dfn><span class="elmBg tMar10 vTop"></span></a></li>
				<%
						End If
					End If
				%>
				</ul>

				<div id="tabcontents">
					<div class="innerH25">
						<p class="innerW20 c555 ftSmall b">상품코드 : <%=itemid%></p>
						<div class="productSpec bgf7f8fa inner20 tMar20">
						<% If (Not IsTicketItem) Then '// 티켓아닌경우 - 일반상품 %>
							<ul class="list04">
							<%
								IF addEx.FResultCount > 0 THEN
									FOR i= 0 to addEx.FResultCount-1
										If addEx.FItem(i).FinfoCode = "35005" Then
											If tempsource <> "" then
											response.write "<li class=""ftSmall c999""><strong class=""c555"">재질 | </strong>"&tempsource&" </li>"
											End If
											If tempsize <> "" then
											response.write "<li class=""ftSmall c999""><strong class=""c555"">사이즈 | </strong>"&tempsize&" </li>"
											End If
										End If
							%>
								<li class="ftSmall c999" style="display:<%=chkiif(addEx.FItem(i).FInfoContent="" And addEx.FItem(i).FinfoCode ="02004" ,"none","")%>;"><strong class="c555"><%=addEx.FItem(i).FInfoname%> | </strong><%=addEx.FItem(i).FInfoContent%></li>
							<%
									Next
								End If
							%>
							<% if oItem.Prd.IsSafetyYN then %>
							<li class="ftSmall c999"><strong class="c555">안전인증대상 | </strong><%=oItem.Prd.FsafetyNum%></li>
							<% End If %>
							<% if oItem.Prd.IsAboardBeasong then %>
							<li class="ftSmall c999"><strong class="c555">해외배송 기준 중량 | </strong><% = formatNumber(oItem.Prd.FitemWeight,0) %> g (1차 포장을 포함한 중량)</li>
							<% End If %>
							</ul>
							<p class="expMoreView moreBtn"><span>상품고시정보 더보기</span></p>
						<% else		'// 티켓상품 %>
							<ul class="list04">
								<li class="ftSmall c999"><strong class="c555">장르 | </strong><%=oTicket.FOneItem.FtxGenre%></li>
								<li class="ftSmall c999"><strong class="c555">일시 | </strong><%= FormatDate(oTicket.FOneItem.FstDt,"0000.00.00") %>~<%= FormatDate(oTicket.FOneItem.FedDt,"0000.00.00") %></li>
								<li class="ftSmall c999"><strong class="c555">장소 | </strong><%=oTicket.FOneItem.FticketPlaceName%></li>
								<li class="ftSmall c999"><strong class="c555">관람등급 | </strong><%=oTicket.FOneItem.FtxGrade%></li>
								<li class="ftSmall c999"><strong class="c555">관람시간 | </strong><%=oTicket.FOneItem.FtxRunTime%></li>
							</ul>
						<% end if %>
						</div>
						<% IF Not(oItem.Prd.FOrderComment="" or isNull(oItem.Prd.FOrderComment)) or Not(oItem.Prd.getDeliverNoticsStr="" or isNull(oItem.Prd.getDeliverNoticsStr)) THEN %>
							<dl class="innerW20 tMar20">
								<dt class="c555 ftMidSm2 b">주문시 유의사항</dt>
								<dd id="ordAttend" class="c999 tMar05 lh14 ftSmall">
									<%= oItem.Prd.getDeliverNoticsStr %> <%= nl2br(oItem.Prd.FOrderComment) %>
								</dd>
							</dl>
							<script type="text/javascript">
								$(function(){
									$('#ordAttend').find("img").css("width","100%");
								});
							</script>
						<% end if %>
						<dl class="productImgDetail tMar20">
							<dt class="inner20 b ftMidSm2 c555">상품상세정보</dt>
							<dd class="imgArea innerW">
								<iframe src="/category/incItemDetail.asp?itemid=<%=itemid%>" id="detail_list" title="detail_list" width="100%" height="100%" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" class="autoheight"></iframe>
							</dd>
							<dd class="imgMoreView moreBtn"><span>상품상세정보 더보기</span></dd>
						</dl>
					</div>
				</div>

				<% If (Not IsTicketItem) Then '티켓아닌경우 - 일반상품 %>
				<!-- #include virtual="/category/inc_happyTogether.asp" -->
				<!-- include virtual="/category/inc_category_best.asp" -->
				<!-- #Include virtual="/category/inc_ItemEventList.asp" -->
				<% end if %>
			</div>


			<div class="floatingBar">
			<%
				if IsPresentItem then	'## Present상품
					IF Not(oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut) Then
						If IsUserLoginOK() Then		'# 로그인한 경우
			%>
					<a href="javascript:TnAddShoppingBag(true)"><img src="http://fiximage.10x10.co.kr/m/2012/itemdetail/btn_waterball.png" alt="바로 신청하기" /></a>
			<%			else %>
					<img src="http://fiximage.10x10.co.kr/m/2012/itemdetail/btn_waterball.png" alt="바로 신청하기" onClick="alert('회원 구매만 가능합니다. 로그인 후 구매해 주세요.');" style="cursor:pointer" />
			<%
						end if
					else
			%>
					<span class="soldOutBtn"><a href="javascript:"><dfn>품 절</dfn></a></span>
			<%
					end if
				else	'## 일반상품
			%>
				<% IF Not(oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut) Then %>
					<span class="shopingBagBtn"><a href="javascript:TnAddShoppingBag(true)"><dfn class="elmBg">장바구니</dfn></a></span>
				<% else %>
					<span class="soldOutBtn"><a href="javascript:"><dfn>품 절</dfn></a></span>
				<% end if %>
				<span class="wishHitView"><a href="javascript:TnAddFavoritePrd('<% = oItem.Prd.Fitemid %>');"><dfn class="elmBg3"><%=FormatNumber(oItem.Prd.FFavCount,0)%></dfn></a></span>
			<% end if %>
			<% If (Not IsTicketItem) Then '티켓아닌경우 - 일반상품 %>
				<span class="talkBtn"><% If IsUserLoginOK Then %><a href="javascript:" onClick="$('body,html').animate({scrollTop:0}, 'fast');talkfrm.submit();"><% Else %><a href="javascript:if(confirm('로그인이 필요한 서비스입니다.\n로그인 하시겠습니까?') == true){location.href = '<%=M_SSLUrl%>/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>';}"><% End If %>쇼핑톡 +</a></span>
			<% else %>
				<span id="gotop" class="goTop"><em><img src="http://fiximage.10x10.co.kr/m/2013/common/btn_top.png" alt="맨위로 이동" style="height:50px;" /></em></span>
			<% end if %>
			</div>
			<!-- //장바구니/위시/맨위 플로팅 -->
		</div>
		<!-- #include virtual="/lib/inc/incFooter.asp" -->
		<form name="qnaform" method="post" action="/my10x10/doitemqna.asp" target="iiBagWin" style="margin:0px;">
		<input type="hidden" name="id" value="" />
		<input type="hidden" name="itemid" value="<% = itemid %>" />
		<input type="hidden" name="mode" value="del" />
		<input type="hidden" name="flag" value="fd" />
		</form>
		<iframe src="" name="iiBagWin" frameborder="0" width="0" height="0"></iframe>
		<form name="talkfrm" method="post" action="/category/doShoppingTalkProc.asp" target="shoppingtalkframe" style="margin:0px;">
		<input type="hidden" name="itemid" value="<% = itemid %>" />
		</form>
		<iframe src="" id="shoppingtalkframe" name="shoppingtalkframe" frameborder="0" width="0" height="0"></iframe>
	</div>
	<!-- #include virtual="/category/incCategory.asp" -->
</div>
<script>onLoadFunc();</script>
<script language="JavaScript" type="text/javascript" SRC="/lib/js/todayview.js"></script>
<script type="text/javascript" src="/lib/js/jquery.iframe-auto-height.js"></script>
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