<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	Description : 상품상세
'	History	:  2014.01.08 한용민 생성
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/webview/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/wishCls.asp" -->
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
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<%
	Dim tabno : tabno = requestCheckVar(getNumeric(request("tabno")),2)
	dim itemid	: itemid = requestCheckVar(request("itemid"),9)
	Dim page, vDisp, cpid
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
	dim cdL, cdM, cdS
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
		if (IsReceiveSiteItem) or (IsPresentItem) or (IsTicketItem) then
			ioptionBoxHtml = GetappOptionBoxDpLimitHTML(itemid, oitem.Prd.IsSoldOut,Not(IsReceiveSiteItem) and Not(IsPresentItem and oItem.Prd.FRemainCount>200) and Not(IsTicketItem and oItem.Prd.FRemainCount>100 ))
		else
		    ioptionBoxHtml = GetappOptionBoxHTML(itemid, oitem.Prd.IsSoldOut)
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

'=============================== 추가 정보 ==========================================
dim isMyFavItem: isMyFavItem=false
if IsUserLoginOK then
	isMyFavItem = getIsMyFavItem(LoginUserid,itemid)
end if
'================================================================================================================

strPageTitle = oItem.Prd.FItemName

'================================================================================================================
dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle = Server.URLEncode(oItem.Prd.FItemName)
snpLink = Server.URLEncode("http://10x10.co.kr/" & itemid)
snpPre = Server.URLEncode("텐바이텐 HOT ITEM!")
snpImg = Server.URLEncode(oItem.Prd.FImageBasic)

'기본 태그
snpTag = Server.URLEncode("텐바이텐 " & Replace(oItem.Prd.FItemName," ",""))
snpTag2 = Server.URLEncode("#10x10")
'================================================================================================================

	'GSShop WCS스크립트 관련 내용 추가; 2014.08.12 허진원 추가
	GSShopSCRIPT = "	var _wcsq = {pageType: ""PRD""};"													'incFooter.asp 에서 출력
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<script src="/lib/js/swiper-2.1.min.js"></script>
<script language="javascript">

	function jsClearArea(){
		sbagfrm.requiredetail.value = "";
	}

	// 관심 품목 담기 - 상품 페이지 전용 : 상품 코드로 변경
	function TnAddFavoritePrd(iitemid){
		<% if IsUserLoginOK then %>
		if($("#btnFav").hasClass("red")) {
			alert('이미 위시한 상품입니다.');
		} else {
			jsOpenModal('/apps/appcom/wish/webview/my10x10/ajax_MyFavorite.asp?ispop=ajax&mode=add&itemid=' + iitemid + '&backurl=<%=Replace(CurrURLQ(),"&","^")%>')
		}
		<% else %>
		calllogin();
		//location.href='/apps/appCom/wish/webview/login/login.asp?backpath=<%=server.URLEncode(CurrURLQ())%>';
		<% end if %>
		return;
	}

	// tab 호출
	function goTabView(v,t) {
		$("#tabItem li").removeClass("active");
		$("#tabno"+t).addClass("active");

		var gourl = 'category_itemprd_ajax.asp?itemid=<%=itemid%>&tabno='+v;

		$("div#tabcontents").empty();
		$.ajax({
			type: "get",
			url: gourl,
			cache: false,
			success: function(message) {
				$("div#tabcontents").empty().append(message);
				top.location.href = "#tabcontentslink";

				if(t==1) {
					$('div#tabcontents').find("img").css("width","100%");
				}
				onLoadFunc();
			}
		});
	}

	function onLoadFunc() {
		swiper = new Swiper('.swiper1', {
			pagination:'.pagination',
			paginationClickable:true,
			resizeReInit:true,
			calculateHeight:true,
			loop:false
		});
	}

	function fnMoreItemDesc(elm) {
		document.location.href="/apps/appcom/wish/webview/category/category_itemPrd_detail.asp?itemid=<%=itemid%>";
		return false;
	}

	function jsItemea(plusminus)
	{
		var vmin = parseInt(<%=chkIIF(oItem.Prd.isLimitItem and oItem.Prd.FRemainCount<=0,"0",oItem.Prd.ForderMinNum)%>);
		var vmax = parseInt(<%=chkIIF(oItem.Prd.isLimitItem,CHKIIF(oItem.Prd.FRemainCount<=oItem.Prd.ForderMaxNum,oItem.Prd.FRemainCount,oItem.Prd.ForderMaxNum),oItem.Prd.ForderMaxNum)%>);
		
		var v = parseInt(sbagfrm.itemea.value);
		if(plusminus == "+")
		{
			v++;
			if(v > vmax){
				v--;
			}
		}
		else if(plusminus == "-")
		{
			if(v > 1)
			{
				v--;
			}
			else
			{
				v = 1;
			}
			if(v < vmin){
				v++;
			}
		}
		sbagfrm.itemea.value = v;
	}
</script>
<style type="text/css">
.productImg {position:relative; margin:0 auto; padding:0 20px 35px 20px; min-height:280px; overflow:hidden;}
.productImg .swiper-container {width:280px; height:280px; overflow:hidden; border:1px solid #eee; margin:0 auto;}
.productImg .swiper-wrapper {overflow:hidden;}
.productImg .swiper-slide {float:left;}
.productImg .swiper-slide img {width:100%; vertical-align:top;}

@media all and (min-width:480px){
	.productImg .swiper-container {width:440px; height:440px;}
}

.slidePage {position:absolute; left:0; width:100%; bottom:12px; text-align:center;}
.slidePage span {width:7px; height:7px; display:inline-block; text-align:center; text-indent:-9999px; background-image:url(http://fiximage.10x10.co.kr/m/2013/common/element_dotpage.png); background-size:17px 7px; background-position:-10px top; background-repeat:no-repeat; margin:0 2px;}
.slidePage span.swiper-active-switch {background-position:left top;}
</style>
</head>

<body class="shop">
    <!-- wrapper -->
    <div class="wrapper product-detail">
        <!-- #content -->
        <div id="content">

			<%
				If clsDiaryPrdCheck.FResultCount  > 0 then '//다이어리 상품 체크 유무
			%>
			
			<!-- 2015 다이어리 스토리 : 배너 추가 -->
			<div class="inner10" style="padding:15px 10px 0;">
				<p><a href="<%=wwwUrl%>/apps/appCom/wish/webview/diarystory2015/index.asp" ><img src="http://fiximage.10x10.co.kr/m/2014/diarystory2015/img_bnr_diarystory2015.png" alt="2015 다이어리 스토리 다이어리 구매시 무료배송과 사은품 혜택을 드립니다." style="width:100%;"/></a></p>
			</div>
			<%
				End If 
			%>


            <div class="product-detail-header">
                <a href="#" class="product-brand" style="font-size:14px;line-height:16px;" onclick="FnGotoBrand('<%=oItem.Prd.Fmakerid%>')"><%=oItem.Prd.FBrandName%></a>
                <h1 class="product-name" style="font-size:16px;line-height:20px;overflow:visible;white-space:normal;"><%= oItem.Prd.FItemName %></h1>
            </div>
            <div class="productImg">

					<div class="swiper-container swiper1">
						<div class="swiper-wrapper">
						<%
						'//기본 이미지
						Response.Write "<div class=""swiper-slide""><img src=""" & getThumbImgFromURL(oItem.Prd.FImageBasic,400,400,"true","false") & """ alt=""" & oItem.Prd.FItemName & """ /></div>"
						'//누끼 이미지
						if Not(isNull(oItem.Prd.FImageMask) or oItem.Prd.FImageMask="") then
							Response.Write "<div class=""swiper-slide""><img src=""" & getThumbImgFromURL(oItem.Prd.FImageMask,400,400,"true","false") & """ alt=""" & oItem.Prd.FItemName & """ /></div>"
						end if
						'//추가 이미지
						IF oAdd.FResultCount > 0 THEN
							FOR i= 0 to oAdd.FResultCount-1
								'If i >= 3 Then Exit For
								IF oAdd.FADD(i).FAddImageType=0 THEN
									Response.Write "<div class=""swiper-slide""><img src=""" & getThumbImgFromURL(oAdd.FADD(i).FAddimage,400,400,"true","false") & """ alt=""" & oItem.Prd.FItemName & """ /></div>"
								End IF
							NEXT
						END IF
						%>
						</div>
					</div>

				<div class="slidePage pagination"></div>
            </div>

            <div class="product-spec">
                <dl>
                    <dt><%=chkIIF(Not(IsTicketItem),"판매가","티켓기본가")%></dt>
                    <dd>
                    	<% if oItem.Prd.IsSaleItem or oitem.Prd.isCouponItem then %>
                    		<del><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></del>
                    	<% else %>
                    		<strong><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></strong>
                    	<% end if %>
                    	<% if oItem.Prd.IsMileShopitem then %> Point<% else %> 원<% end  if %>
                    </dd>
                </dl>

                <% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
	                <dl>
	                    <dt>할인판매가</dt>
	                    <dd><span class="red">
							<%
								If oItem.Prd.FOrgprice = 0 Then
									Response.Write "[0%] "
								Else
									Response.Write "[" & CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) & "%] "
								End If
								Response.Write FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem," Point"," 원")
							%>
						</span></dd>
	                </dl>
				<% end if %>
				<% if oItem.Prd.IsSaleItem and oItem.Prd.IsSpecialUserItem then %>
                <dl>
                    <dt>우수회원가 <a href="/apps/appcom/wish/webview/my10x10/special_shop.asp" class="btn type-b left-cursor btn-vip-shop"><span>우수회원샵</span></a></dt>
                    <dd><span class="red">[<% = getSpecialShopPercent() %>%] <%= FormatNumber(oItem.Prd.getRealPrice,0) %><%=chkIIF(oItem.Prd.IsMileShopitem," Point"," 원")%></span></dd>
                </dl>
				<% end if %>
				<% if oitem.Prd.isCouponItem Then %>
					<form name="frmC" method="get" action="/apps/appcom/wish/webview/shoppingtoday/couponshop_process.asp" style="margin:0px;" onsubmit="return false;">
						<input type="hidden" name="stype" value="" />
						<input type="hidden" name="idx" value="" />
					</form>
	                <dl>
	                    <dt>쿠폰적용가</dt>
	                    <dd>
	                    	<span class="green">[<%= oItem.Prd.GetCouponDiscountStr %>] <%= FormatNumber(oItem.Prd.GetCouponAssignPrice,0) %> 원</span>
	                    </dd>
	                </dl>
				<% end if %>

					<dl>
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
					<dl>
						<dt>마일리지</dt>
						<dd><% = oItem.Prd.FMileage %>Point</dd>
					</dl>
				<% end if %>

				<form name="sbagfrm" method="post" action="" style="margin:0px;" onsubmit="return false;">
				<input type="hidden" name="mode" value="add" />
				<input type="hidden" name="itemid" value="<% = oitem.Prd.FItemid %>" />
				<input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
				<input type="hidden" name="itemoption" value="" />
				<input type="hidden" name="userid" value="<%= LoginUserid %>" />
				<input type="hidden" name="isPresentItem" value="<%= isPresentItem %>" />

				<% if oItem.Prd.FItemDiv = "06" then %>
                	<textarea name="requiredetail" onClick="jsClearArea();" id="" cols="30" rows="10" class="form bordered full-size" style="height:80px;" placeholder="문구를 입력해주세요."></textarea>
                	<div class="diff-10"></div>
                <% end if %>

                <% if oitem.Prd.isCouponItem Then %>
					<button onclick="jsDownCoupon('prd','<%= oitem.Prd.FCurrItemCouponIdx %>');" class="btn type-d full-size btn-download couponDown">
					<!-- i class="icon-download"></i --> <%= oItem.Prd.GetCouponDiscountStr %> 쿠폰받기</button>
					<div class="diff-10"></div>
				<% end if %>

				<% IF (oItem.Prd.isLimitItem) and (not (oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut)) and (Not IsReceiveSiteItem) and Not(IsPresentItem and oItem.Prd.FRemainCount>200 ) and Not(IsTicketItem and oItem.Prd.FRemainCount>100 ) Then %>
	                <p class="t-r">
	                    한정수량 <span class="red"><% = oItem.Prd.FRemainCount %>개</span> 남았습니다.
	                </p>
				<% end if %>

				<% If GiftSu > 0 Then %>
	                <p class="t-r">
	                    다이어리 사은품 <span class="red"><% = GiftSu %>개</span> 남았습니다.
	                </p>
				<% end if %>

                <hr class="hr">
                <div class="featured t-r">
					<% IF oItem.Prd.IsSoldOut Then %>
						<span class="only">품절</span>
					<% Else %>
						<% if oitem.Prd.isCouponItem Then %><span class="coupon">쿠폰</span><% End If %>
						<% IF oItem.Prd.IsFreeBeasong Then %><span class="gift">무료배송</span><% End If %>
						<% IF oItem.Prd.isLimitItem Then %><span class="limited">한정</span><% End If %>
						<% IF oItem.Prd.isNewItem Then %><span class="new">NEW</span><% End If %>
						<% IF oItem.Prd.IsSaleItem THEN %><span class="sale">SALE</span><% End If %>
						<% IF oItem.Prd.IsSoldOut Then %><span class="only">품절</span><% End If %>
					<% End if %>
                </div>
                <div class="diff"></div>

                <% IF oItem.Prd.FOptionCnt>0 then %>
					<%= ioptionBoxHtml %>
				<% end if %>

				<% if IsPresentItem then %>
		            <div class="well">
						<strong>1개</strong> <span style="font-size:0.85em">(한번에 하나씩만 구매가 가능합니다.)</span>
						<input name="itemea" type="hidden" value="1" />
					</div>
				<% else %>
					<div class="amount-selector">
	                    <input type="text" readonly value="1" name="itemea" id="amount" class="amount">
	                    <button onClick="jsItemea('-');return false;" class="btn-minus">-</button>
	                    <button onclick="jsItemea('+');return false;" class="btn-plus">+</button>
	                </div>
                <% end if %>
                </form>
				<div class="detailSns">
					<span><a class="snsFacebook" href="#" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');" >페이스북 공유</a></span>
					<span><a class="snsTwitter" href="#" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');" >트위터 공유</a></span>
					<span><a class="snsKatalk" id="kakaoa" href="javascript:;">카카오톡 공유</a></span>
					<!-- #Include virtual="/apps/appcom/wish/webview/category/inc_kakaolink.asp" -->
					<span><a class="snsPinter" href="#" onclick="pinit('<%=snpLink%>','<%=snpImg%>');" >핀터레스트 공유</a></span>
				</div>
            </div>
            <div class="product-content">
                <ul class="tabs type-a" id="tabItem">
					<% If IsPresentItem then 'Present상품 %>
						<li class="active" id="tabno1" style="width:50%;"><a href="javascript:goTabView(1,1);">상품 상세설명</a></li>
						<li id="tabno2" style="width:50%;"><a href="javascript:goTabView(2,2);">후기 (<%= oEval.FTotalCount %>)</a></li>
					<% ElseIf IsTicketItem Then '티켓상품 %>
						<li class="active" id="tabno1" style="width:20%;"><a href="javascript:goTabView(1,1);">상품 상세설명</a></li>
						<li id="tabno2" style="width:23%;"><a href="javascript:goTabView(2,2);">관람평 (<%= oEval.FTotalCount %>)</a></li>
						<li id="tabno5" style="width:24%;"><a href="javascript:goTabView(5,5);">공연장 정보</a></li>
						<li id="tabno6" style="width:33%;"><a href="javascript:goTabView(6,6);">취소 및 환불수령</a></li>
					<%
						Else
							'//일반상품
							If oItem.Prd.IsSpecialBrand then
					%>
			                    <li class="active" id="tabno1" style="width:33%;"><a href="javascript:goTabView(1,1);">상품 상세설명</a></li>
			                    <li id="tabno2" style="width:33%;"><a href="javascript:goTabView(2,2);">후기 (<%= oEval.FTotalCount %>)</a></li>
			                    <li id="tabno3" style="width:33%;"><a href="javascript:goTabView(3,3);">상품 Q&amp;A (<%= oQna.FTotalCount%>)</a></li>
					<%		Else %>
								<li class="active" id="tabno1" style="width:50%;"><a href="javascript:goTabView(1,1);">상품 상세설명</a></li>
								<li id="tabno2" style="width:50%;"><a href="javascript:goTabView(2,2);">후기 (<%= oEval.FTotalCount %>)</a></li>
					<%
							End If
						End If
					%>
                </ul>
                <a name="tabcontentslink" />
                <div id="tabcontents">
	                <div class="tab-content inner" id="productDetail">
	                    <h4>상품코드 : <%=itemid%></h4>
	                    <div class="detail-box">
	                        <div class="inner extend">
	                    		<% If (Not IsTicketItem) Then '// 티켓아닌경우 - 일반상품 %>
									<%
									IF addEx.FResultCount > 0 THEN
										FOR i= 0 to addEx.FResultCount-1
											If addEx.FItem(i).FinfoCode = "35005" Then
												If tempsource <> "" then
									%>
													<dl><dt>재질</dt><dd><%= tempsource %></dd></dl>
									<%
												End If
												If tempsize <> "" then
									%>
													<dl><dt>사이즈</dt><dd><%= tempsize %></dd></dl>
									<%
												End If
											End If
									%>
										<dl style="display:<%=chkiif(addEx.FItem(i).FInfoContent="" And addEx.FItem(i).FinfoCode ="02004" ,"none","")%>;"><dt><%=addEx.FItem(i).FInfoname%></dt><dd><%=addEx.FItem(i).FInfoContent%></dd></dl>
									<%
										Next
									End If
									%>
									<%
									if oItem.Prd.IsSafetyYN then
									%>
										<dl><dt>안전인증대상</dt><dd><%=oItem.Prd.FsafetyNum%></dd></dl>
									<%
									End If
									%>
									<%
									if oItem.Prd.IsAboardBeasong then
									%>
										<dl><dt>해외배송 기준 중량</dt><dd><%= formatNumber(oItem.Prd.FitemWeight,0) %> g (1차 포장을 포함한 중량)</dd></dl>
									<%
									End If
									%>
								<% else		'// 티켓상품 %>
									<dl><dt>장르</dt><dd><%=oTicket.FOneItem.FtxGenre%></dd></dl>
									<dl><dt>일시</dt><dd><%= FormatDate(oTicket.FOneItem.FstDt,"0000.00.00") %>~<%= FormatDate(oTicket.FOneItem.FedDt,"0000.00.00") %></dd></dl>
									<dl><dt>장소</dt><dd><%=oTicket.FOneItem.FticketPlaceName%></dd></dl>
									<dl><dt>관람등급</dt><dd><%=oTicket.FOneItem.FtxGrade%></dd></dl>
								<% end if %>
	                        </div>
	                        <!--<button class="btn type-c btn-more full-size">상품고시정보 더보기</button>//-->
	                    </div>

	                    <% IF Not(oItem.Prd.FOrderComment="" or isNull(oItem.Prd.FOrderComment)) or Not(oItem.Prd.getDeliverNoticsStr="" or isNull(oItem.Prd.getDeliverNoticsStr)) THEN %>
		                    <h4>주문시 유의사항</h4>
		                    <div class="well type-c" id="ordAttend">
								<%= oItem.Prd.getDeliverNoticsStr %> <%= nl2br(oItem.Prd.FOrderComment) %>
		                    </div>
							<script type="text/javascript">
								$(function(){
									$('#ordAttend').find("img").css("width","100%");
								});
							</script>
						<% end if %>

	                    <h4>상품상세정보</h4>
	                    <div class="detail-box product-spec-info">
	                        <div class="inner" style="display:none;">
	                            <div id="lyLoading" style="position:absolute;text-align:center; left:50%; margin-left:-8px;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="height:16px;" /></div>
	                            <iframe src="about:blank" id="detail_list" title="detail_list" width="100%" height="100%" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" class="autoheight"></iframe>
	                        </div>
	                        <button class="btn type-c btn-more full-size" style="background:#a6a9ac;" onclick="fnMoreItemDesc(this)">상품설명 보기</button>
	                    </div>

						<% If (Not IsTicketItem) Then '티켓아닌경우 - 일반상품 %>
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
							<!-- #include virtual="/apps/appcom/wish/webview/category/inc_happyTogether.asp" -->
						<% end if %>

	                    <div class="clear"></div>
	                </div>
				</div>
            </div>
            <div class="btn-actions fixed">
                <% if flgDevice="I" then %>
                <div class="history-btns">
                    <button class="btn-back" onclick="history.back();return false;">&lt;</button>
                </div>
                <% end if %>
                <div class="three-btns">
					<%
					if IsPresentItem then	'## Present상품
					%>
						<div class="col" style="width:40%;">
							<%
							IF Not(oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut) Then
								If IsUserLoginOK() Then		'# 로그인한 경우
							%>
									<button onclick="TnAddShoppingBag(true);" class="btn type-b"><i class="icon-cart"></i>바로 신청하기</button>
								<% else %>
									<button onclick="alert('회원 구매만 가능합니다. 로그인 후 구매해 주세요.');" class="btn type-b"><i class="icon-cart"></i>바로 신청하기</button>
							<%
								end if
							else
							%>
								<button class="btn type-e"><i class="icon-cart-white"></i>품절</button>
							<% end if %>
		                </div>
	                    <div class="col" style="width:30%;">
	                        <button id="btnFav" onclick="TnAddFavoritePrd('<% = oItem.Prd.Fitemid %>');" class="btn type-f <%=chkIIF(isMyFavItem,"red","")%>">
	                        <i class="icon-love"></i><%=FormatNumber(oItem.Prd.FFavCount,0)%></button>
	                    </div>
					<%
					else	'## 일반상품
					%>
						<% IF Not(oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut or oItem.Prd.IsMileShopitem) Then %>
						<div class="col" style="width:36%;">
								<button onclick="TnAddShoppingBag();" class="btn type-b"><i class="icon-box"></i>바로구매</button>
						</div>
						<% end if %>
						<div class="col" style="width:<%=chkiif(oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut or oItem.Prd.IsMileShopitem,"72%","36%")%>;">
							<% IF Not(oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut) Then %>
								<button onclick="TnAddShoppingBag(true);" class="btn type-cart"><i class="icon-cart"></i>장바구니</button>
							<% else %>
								<button class="btn type-e"><i class="icon-cart-white"></i>품절</button>
							<% end if %>
		                </div>
						 <div class="col" style="width:28%;">
							<button id="btnFav" onclick="TnAddFavoritePrd('<% = oItem.Prd.Fitemid %>');" class="btn type-f <%=chkIIF(isMyFavItem,"red","")%>"><i class="icon-love"></i><%=oItem.Prd.FFavCount%></button>
						 </div>
					<% end if %>

                    <!-- <div class="col" style="width:30%;">
                        <button onclick="jsOpenModal('/apps/appcom/wish/webview/lib/pop_itemSNSPost.asp?itemid=<%= oItem.Prd.fitemid %>');" class="btn type-e">
                        <i class="icon-share"></i>공유</button>
                    </div> -->
                </div>
                <div class="clear"></div>
            </div>
        </div><!-- #content -->

		<!-- #footer -->
		<footer id="footer">
			<a href="#" class="btn-top">top</a>
		</footer><!-- #footer -->
    </div><!-- wrapper -->
	<div id="modalCont" style="display:none;"></div>
	<iframe src="" name="iiBagWin" frameborder="0" width="0" height="0" style="position:fixed; top:-100px;"></iframe>
    <script type="text/javascript">
	    onLoadFunc();

	    <%
	    '//탭을 파라메타로 타고 들어올경우, 아작스 호출
	    if tabno<>"" then
	    %>
	    	goTabView('<%= tabno %>','<%= tabno %>')
	    <% end if %>
    </script>
    <script language="JavaScript" type="text/javascript" SRC="/lib/js/todayview.js"></script>
    <script type="text/javascript" src="/lib/js/jquery.iframe-auto-height.js"></script>

    <!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
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