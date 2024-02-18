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
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
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
		if oItem.Prd.FEvalCnt>0 and cFlgDBUse then
			oEval.getItemEvalList
		end if

	'//상품 문의
	Dim oQna
	set oQna = new CItemQna

	''스페셜 브랜드일경우 상품 문의 불러오기
	If (oItem.Prd.IsSpecialBrand and oItem.Prd.FQnaCnt>0 and cFlgDBUse) Then
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

	'// 공유 제한 상품 (프리젠트 상품 또는 특수한 브랜드)
	Dim isSpCtlIem
	isSpCtlIem = (IsPresentItem or oItem.Prd.FMakerid="10x10present")

	'2015 APP전용 상품 안내
	if IsPresentItem or oItem.Prd.FOrgMakerid="10x10present" or itemid=1250336 then
		Call Alert_Move("본 상품은 텐바이텐 APP에서만 보실 수 있습니다.","/")
		dbget.Close: Response.End
	end if

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
			ioptionBoxHtml = GetOptionBoxDpLimit2016(itemid, oitem.Prd.IsSoldOut,Not(IsReceiveSiteItem) and Not(IsPresentItem and oItem.Prd.FRemainCount>200) and Not(IsTicketItem and oItem.Prd.FRemainCount>100 ) and Not(oItem.Prd.Flimitdispyn="N"))
		else
		    ioptionBoxHtml = GetOptionBox2016(itemid, oitem.Prd.IsSoldOut)
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

	If IsUserLoginOK and cFlgDBUse Then
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

	'head.asp에서 출력
	strOGMeta = strOGMeta & "<meta property=""og:title"" content=""" & Replace(oItem.Prd.FItemName,"""","") & """>" & vbCrLf
	strOGMeta = strOGMeta & "<meta property=""og:type"" content=""website"" />" & vbCrLf
	strOGMeta = strOGMeta & "<meta property=""og:url"" content=""http://m.10x10.co.kr/category/category_itemPrd.asp?itemid=" & itemid & """ />" & vbCrLf
	strOGMeta = strOGMeta & "<meta property=""og:image"" content=""" & getFirstAddimage & """>" & vbCrLf
	if trim(oItem.Prd.FDesignerComment)<>"" then
		strOGMeta = strOGMeta & "<meta property=""og:description"" content=""생활감성채널 텐바이텐- " & Replace(Trim(oItem.Prd.FDesignerComment),"""","") & """>" & vbCrLf
	end if

	'해더 타이틀
	strHeadTitleName = "상품정보"
	if oItem.Prd.isSoldout then
		strPageKeyword = ""
	else
		strPageKeyword = Replace(oItem.Prd.FItemName,"""","") & ", " & Replace(oItem.Prd.FBrandName,"""","") & ", " & Replace(oItem.Prd.FBrandName_kor,"""","")
	end if

%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: <%= oItem.Prd.FItemName %></title>
	<script type="application/x-javascript" src="/lib/js/itemPrdDetail.js"></script>
	<script type="application/x-javascript" src="/lib/js/shoppingbag_script.js"></script>
	<script type="application/x-javascript" src="/lib/js/jquery.numspinner_m.js"></script>
	<script>
		$(function() {
			<% if (flgDevice="I") then %>
//			var saveh = 0;
//			$('.itemoption select[name="item_option"] , #requiredetail').focus(function() {
//				saveh = $(document).scrollTop();
//				var userH = document.documentElement.clientHeight;
//				$(".itemFloatingV16a").css('position','absolute');
//				$(".container").css('height', userH+'px');
//			}).blur(function(){
//				$(document).scrollTop(saveh);
//				$(".itemFloatingV16a").css('position','fixed');
//				$(".container").css('height', 'auto');
//			});
			<% end if %>

			// Top버튼 위치 이동
			$(".goTop").addClass("topHigh");

			// 로딩후 스크롤 다운
//			setTimeout(function(){
//				$('html, body').animate({scrollTop:$(".itemPrdV16a").offset().top}, 'fast');
//			}, 300);

			var mySwiper0;
			var mySwiper1;
			var mySwiper2;
			var mySwiper3;
			var mySwiper4;
			var mySwiper6;
			var mySwiper7;

			// navgator
			mySwiper0 = new Swiper('.locationV16a .swiper-container',{
				pagination:false,
				freeMode:true,
				initialSlide:<%=vCateCnt-1%>,
				slidesPerView:'auto'
			})

			// product Image swipe
			if($('.pdtImgV16a .swiper-wrapper div').length>1) {
				mySwiper1 = new Swiper('.pdtImgV16a .swiper-container', {
					resizeReInit:true,
					calculateHeight:true,
					pagination:'.pdtImgV16a .paginationDot',
					paginationClickable:true,
					simulateTouch:false
				});
			}

			// floating area swipe
			floatScroll = new Swiper('.itemOptV16a .swiper-container', {
				scrollbar:'.itemOptV16a .swiper-scrollbar',
				direction:'vertical',
				slidesPerView:'auto',
				mousewheelControl:true,
				freeMode:true,
				resistanceRatio:0
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

			// floating area control
			$('.controller, .actBuy').click(function(){
				if($('.itemFloatingV16a').hasClass('opening16a')){
					$('.itemFloatingV16a').removeClass('opening16a');
					$('.actBuy').css('display','table-cell');
					$('.actCart, .actNow').hide();
				} else {
					$('.itemFloatingV16a').addClass('opening16a');
					$('.actBuy').hide();
					$('.actCart, .actNow').css('display','table-cell');
				}

				<% if Not(oItem.Prd.FOptionCnt>0) And Not(IsPresentItem) then %>
					$(".btnAreaV16a .actCart .btnRed1V16a").attr("disabled",false);
					$(".btnAreaV16a .actNow .btnRed2V16a").attr("disabled",false);
				<% end if %>
			});

			//기본 첫번째 focus
			$('.itemoption select:first').addClass('current');

			//제작 문구만 있는 경우
			if (!$('.itemoption select:first').hasClass('current')){
				$('.txtBoxV16a').addClass('current');
			}

			// floating area option select control
			$('.itemOptV16a select').focus(function(){
				$('.itemOptV16a select').removeClass('current');
				$(this).addClass('current');

				if($(".requiredetail").has("#requiredetail").length){//문구있을경우 플로팅삭제
					$('.txtBoxV16a').removeClass('current');
				}
			}).blur(function(){ //선택후 자동적으로 값 체크 포커스 이동
				var optCnt = $('.itemoption select[name="item_option"]').length;
				var selopt = 0;
				$('.itemoption select[name="item_option"]').each(function () { //select 수만큼 돌려서
					if ($(this).val()!=""&&$(this).val()!="0000") selopt++;

					if (selopt == optCnt){
						$('.itemOptV16a select').removeClass('current'); //전부 초기화
						if($(".requiredetail").has("#requiredetail").length){
							$('.txtBoxV16a').addClass('current');
							//return false;
						}
					}else{
						$('.itemOptV16a select').removeClass('current'); //전부 초기화
						$('#'+selopt).addClass('current');
						//return false;
					}
				});
			});

			// product detail tab control
			$(".qnaListV16a li .a").hide();
			$(".qnaListV16a li").each(function(){
				if ($(this).children(".a").length > 0) {
					$(this).children('.q').addClass("hasA");
				}
			});

			$(".qnaListV16a li .q").click(function(){
				$(".qnaListV16a li .a").hide();
				if($(this).next().is(":hidden")){
					$(this).parent().children('.a').show();
				}else{
					$(this).parent().children('.a').hide();
				};
			});

			$(".postContV16a:first").show();
			$('.postTxtV16a .btnBarV16a li').click(function(){
				$(".postContV16a").hide();
				$('.postTxtV16a .btnBarV16a li').removeClass('current');
				$(this).addClass('current');
				var postTabView = $(this).attr('name');
				$("div[class|='postContV16a'][id|='"+ postTabView +"']").show();
			});

			//상품 추가정보 표시처리
			$('.pdtDetailList li').find('dd').hide();
			//$('.pdtDetailList li:first-child').find('dd').show();
			//$('.pdtDetailList li:first-child').find('dt').addClass('selected');
			$('.pdtDetailList li .accordTab > dt').click(function(){
				var isSlf = $(this).hasClass('selected');
				$('.pdtDetailList li .accordTab > dd:visible').hide();
				$('.pdtDetailList li .accordTab > dt').removeClass('selected');
				if(!isSlf) {
					$(this).parents("dl").parents("li").find('dd').show();
					$(this).addClass('selected');
					// 클릭 위치가 가려질경우 스크롤 이동
					if($(window).scrollTop()>$(this).parents("dl").parents("li").offset().top) {
						$('html, body').animate({scrollTop:$(this).parents("dl").parents("li").offset().top-10}, 'fast');
					}
				}
			});

			// 관련기획전 글자수 control
			$('.evtIsuV16a .listArrowV16a li').each(function(){
				if ($(this).children('a').find("em").length == 3) {
					$(this).find('span').css('max-width','60%');
				} else if ($(this).children('a').find("em").length == 2) {
					$(this).find('span').css('max-width','71%');
				} else if ($(this).children('a').find("em").length == 1) {
					$(this).find('span').css('max-width','84%');
				}
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
			sbagfrm.optItemEa.value = v;

			var p = parseInt(sbagfrm.itemPrice.value);

			$("#spTotalPrc").text(plusComma(parseInt(v * p)));
			$("#subtot").text(plusComma(parseInt(v * p))+"원");
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
<% If isNaverOpen AND Left(request.Cookies("rdsite"), 13) = "mobile_nvshop" Then %>
<!-- #INCLUDE Virtual="/member/actnvshopLayerCont.asp" -->
<% ElseIf isDaumOpen AND Left(request.Cookies("rdsite"), 15) = "mobile_daumshop" Then %> Then %>
<!-- #INCLUDE Virtual="/member/actdaumshopLayerCont.asp" -->
<% End If %>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container" style="background-color:#e7eaea;">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea" style="padding-bottom:6rem;">
				<% If vDisp <> "111" Then %>
				<div class="locationV16a">
					<div class="swiper-container">
						<div class="swiper-wrapper"><%= vCateNavi %></div>
					</div>
				</div>
				<% End If %>

				<div class="itemPrdV16a">
					<div class="itemInfoBoxV16a">
						<div class="bnrAreaV16a">
							<% If clsDiaryPrdCheck.FResultCount > 0 then %>
								<% If Left(Now(), 10) < "2016-01-01" Then %>
									<%'다이어리 배너 추가(10/01)%>
									<div class="bPad10"><a href="/diarystory2016/"><img src="http://fiximage.10x10.co.kr/m/2015/diarystory2016/bnr_detail_diary.gif" alt="2016 DIARY STORY" /></a></div>
								<% end if %>
							<% end if %>

							<%' 상품이벤트영역 %>
							<div style="display:none;" id="itemevent"></div>

							<% if oItem.Prd.FisJust1Day then %>
							<div id="lyrjust1day"></div>
							<script type="text/javascript">
								$.ajax({
									type: "get",
									url: "act_just1day.asp?itemid=<%=itemid%>",
									success: function(message) {
										if(message) {
											$("#lyrjust1day").empty().html(message);
										}
									}
								});
							</script>
							<% end if %>
						</div>
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
									<p class="pDetailView"><a href="/category/pop_category_itemPrd_detail.asp?itemid=<%=itemid%>"><img src="http://fiximage.10x10.co.kr/m/2014/common/btn_detail.png" alt="상품 상세보기" style="width:100%;" /></a></p>
								</div>
								<div class="paginationDot"></div>
							</div>
							<% IF (oItem.Prd.isLimitItem) and (not (oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut)) and (Not IsReceiveSiteItem) and Not(IsPresentItem and oItem.Prd.FRemainCount>200 ) and Not(IsTicketItem and oItem.Prd.FRemainCount>100 ) Then %>
							<p class="pLimit"><span>한정수량 <strong><% = oItem.Prd.FRemainCount %></strong>개</span></p>
							<% end if %>
							<%
							Dim vOneAndOne, vOneAndOneSDate
							vOneAndOne = getDiaryoneandonegubun2(itemid)
							If vOneAndOne <> "" Then
								vOneAndOneSDate = Split(vOneAndOne,"||")(1)
								vOneAndOne = Split(vOneAndOne,"||")(0)
							End If

							If GiftSu > 0 Then %>
								<p class="pLimit">
									<span>
									<%
										if vOneAndOne="" then
											response.write "사은품"
										else
											if vOneAndOne="1" then
												response.write "1+1"
											elseif vOneAndOne="2" then
												response.write "1:1"
											else
												response.write "사은품"
											end if
										end if
									%> 남은수량
									 <strong><% = GiftSu %></strong>개</span></p>
							<% else %>
								<%
								If date() = CDate(vOneAndOneSDate) Then
									if vOneAndOne <> "" then %>
									<p class="pLimit limitEnd">
										<span>
										<%
											if vOneAndOne="" then
												response.write "사은품"
											else
												if vOneAndOne="1" then
													response.write "1+1"
												elseif vOneAndOne="2" then
													response.write "1:1"
												else
													response.write "사은품"
												end if
											end if
										%> 남은수량
										 <strong>0</strong>개</span></p>
								<% end if
								end if
								%>
							<% end if %>
						</div>

						<div class="itemInfoV16a">
							<div class="pdtCont">
								<p class="pBrand"><a href="/street/street_brand.asp?makerid=<%=oItem.Prd.Fmakerid%>"><%=oItem.Prd.FBrandName%></a></p>
								<p class="pName"><%= oItem.Prd.FItemName %></p>
								<p class="pFlagV16a">
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
								<p class="giftFlagV16a <% IF vTICount > 0 Then response.write "giftFlagOn" End If %>" onclick="writeShoppingTalk('<%=itemid%>'); return false;"><span>TALK</span></p>
								<% else %>
								<p class="giftFlagV16a" onClick="if(confirm('로그인이 필요한 서비스입니다.\n로그인 하시겠습니까?') == true){location.href = '<%=M_SSLUrl%>/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>';}; return false;"><span>TALK</span></p>
								<% end if %>
							</div>

							<dl class="pPrice lastPrice">
								<dt>최종판매가</dt>
								<dd><strong><%= FormatNumber(oItem.Prd.GetCouponAssignPrice,0) %></strong><em><%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></em></dd>
							</dl>
							<% IF ((oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0)) or (oItem.Prd.IsSaleItem and oItem.Prd.IsSpecialUserItem) or (oitem.Prd.isCouponItem) THEN %>
							<div class="priceBox">
								<dl class="pPrice">
									<dt><%=chkIIF(Not(IsTicketItem),"판매가","티켓기본가")%></dt>
									<dd><%= FormatNumber(oItem.Prd.getOrgPrice,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></dd>
								</dl>
								<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
								<dl class="pPrice">
									<dt>할인판매가</dt>
									<dd>
									<%
										If oItem.Prd.FOrgprice = 0 Then
											Response.Write "<span class=""cRd1"">[0%]</span> "
										Else
											Response.Write "<span class=""cRd1"">[" & CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) & "%]</span> "
										End If
										Response.Write FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","원")
									%>
									</dd>
								</dl>
								<% end if %>
								<% if oItem.Prd.IsSaleItem and oItem.Prd.IsSpecialUserItem then %>
								<dl class="pPrice">
									<dt>
										우수회원가
										<span class="icoHot"><a href="/my10x10/special_shop.asp"><em class="rdBtn2">우수회원샵</em></a></span>
									</dt>
									<dd><span class="cRd1">[<% = getSpecialShopPercent() %>%]</span> <%= FormatNumber(oItem.Prd.getRealPrice,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></dd>
								</dl>
								<% end if %>
								<% if oitem.Prd.isCouponItem Then %>
								<dl class="pPrice">
									<dt>쿠폰적용가</dt>
									<dd><span class="cGr1">[<%= oItem.Prd.GetCouponDiscountStr %>]</span> <%= FormatNumber(oItem.Prd.GetCouponAssignPrice,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","원") %></dd>
								</dl>
								<% end if %>
							</div>
							<% end if %>

							<% if oItem.Prd.FMileage then %>
							<dl class="pPrice tMar05">
								<dt>마일리지</dt>
								<dd><% = oItem.Prd.FMileage %> Point</dd>
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
								<% if Not(oItem.Prd.IsFreeBeasong) and (oItem.Prd.IsUpcheParticleDeliverItem or oItem.Prd.IsUpcheReceivePayDeliverItem) then %>
									<button type="button" class="btnV16a btnMGryV16a" onClick="location.href='/street/street_brand.asp?makerid=<%=oItem.Prd.Fmakerid%>';">배송비 절약상품<img src="http://fiximage.10x10.co.kr/m/2016/common/blt_arrow_white.png" alt="" /></button>
								<% end if %>
								</dd>
							</dl>
							<% If G_IsPojangok Then %>
							<% If oItem.Prd.FPojangOk = "Y" Then %>
							<dl class="pPrice">
								<dt>선물포장</dt>
								<dd><img src="http://fiximage.10x10.co.kr/m/2015/common/ico_pkg.png" alt="" style="width:12px; margin-top:1px; vertical-align:top;" /> 포장가능 <button type="button" class="btnV16a btnMGryV16a" onClick="location.href='/category/popPkgIntro.asp?itemid=<%=itemid%>';">선물포장 안내<img src="http://fiximage.10x10.co.kr/m/2016/common/blt_arrow_white.png" alt="" /></button></dd>
							</dl>
							<% End If %>
							<% End If %>
						</div>


						<% if oitem.Prd.isCouponItem Then %>
						<div class="btnAreaV16a">
							<p><button type="button" class="btnV16a btnGrnV16a"><a href="" onclick="jsDownCoupon('prd','<%= oitem.Prd.FCurrItemCouponIdx %>'); return false;"><%= oItem.Prd.GetCouponDiscountStr %> 할인쿠폰 받기<img src="http://fiximage.10x10.co.kr/m/2016/common/ico_down.png" alt="" /></a></button></p>
						</div>
						<form name="frmC" method="get" action="/shoppingtoday/couponshop_process.asp" style="margin:0px;">
						<input type="hidden" name="stype" value="" />
						<input type="hidden" name="idx" value="" />
						</form>
						<% end if %>
					</div>


					<%' 상품상세설명 영역 %>
					<div class="itemDeatilV16a">
						<!-- #include virtual="/category/category_itemprd_detail_new.asp" -->
					</div>
					<%'// 상품상세설명 영역 %>

					<% If (Not IsTicketItem) Then '티켓아닌경우 - 일반상품 %>
						<% ' 레코벨 서비스 오픈 150728 원승현 %>
						<script type="text/javascript">
							var vIId='<%=itemid%>', vDisp='<%=vDisp%>';
						</script>
						<% if cFlgDBUse then %><script type="text/javascript" src="./inc_happyTogether.js"></script><% end if %>
						<!--// 함께구매하면 좋은상품 -->
						<div id="lyrHPTgr"></div>

						<!--// Category Best //-->
						<!-- #include virtual="/category/inc_category_best.asp" -->

						<!--// Event Item //-->
						<!-- #Include virtual="/category/inc_ItemEventList.asp" -->
					<% end if %>
				</div>
			</div>

			<%' 주문 영역 %>
			<div class="itemFloatingV16a">
				<form name="sbagfrm" method="post" action="" style="margin:0px;">
				<input type="hidden" name="mode" value="add" />
				<input type="hidden" name="itemid" value="<% = oitem.Prd.FItemid %>" />
				<input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
				<input type="hidden" name="itemoption" value="" />
				<input type="hidden" name="userid" value="<%= LoginUserid %>" />
				<input type="hidden" name="itemPrice" value="<%= oItem.Prd.getRealPrice %>">
				<input type="hidden" name="isPresentItem" value="<%= isPresentItem %>" />
				<input type="hidden" name="itemea" readonly value="1" />
				<span class="controller"></span>
				<div class="itemOptWrapV16a">
					<div class="itemOptV16a">
						<div class="swiper-container">
							<div class="swiper-wrapper">
								<div class="swiper-slide">
									<% IF oItem.Prd.FOptionCnt>0 then %>
										<div class="itemoption">
											<%= ioptionBoxHtml %>
										</div>
									<% end if %>
									<% if oItem.Prd.FItemDiv = "06" then %>
										<div class="rqtxt <%=chkiif(oItem.Prd.FOptionCnt>0," tPad0-9r"," onlyTxt")%>">
											<div class="txtBoxV16a requiredetail">
												<textarea name="requiredetail" id="requiredetail" placeholder="[문구입력란] 문구를 입력해 주세요!" onclick="chkopt();"></textarea>
												<% If oItem.Prd.FOptionCnt > 0 Then %>
												<button type="button" class="btnV16a btnMGryV16a" onclick="requireTxt();">완료</button>
												<% End If %>
											</div>
										</div>
									<% end if %>
									<%'간이 장바구니%>
									<ul id="lySpBagList" class="optContListV16a">
										<% If Not(oItem.Prd.FOptionCnt>0) And Not(IsPresentItem) Then %>
										<li>
											<div class="optQuantityV16a tMar0-5r">
												<p class="odrNumV16a">
													<button type="button" class="btnV16a minusQty" onclick="jsItemea('-');">감소</button>
													<input type="text" value="1" id='optItemEa' name='optItemEa' readonly/>
													<button type="button" class="btnV16a plusQty" onclick="jsItemea('+');">증가</button>
												</p>
												<p class="rt" id="subtot"><%=chkiif(Not(oItem.Prd.FOptionCnt>0) And Not(IsPresentItem),FormatNumber(oItem.Prd.getRealPrice,0),"0")%>원</p>
											</div>
										</li>
										<% End If %>
									</ul>
									<%'간이 장바구니%>
								</div>
							</div>
							<div class="swiper-scrollbar"></div>
						</div>
					</div>
					<div class="pdtPriceV16a">
						<p>
							<span>상품 합계</span>
						</p>
						<p class="rt"><strong id="spTotalPrc"><%=chkiif(Not(oItem.Prd.FOptionCnt>0) And Not(IsPresentItem),FormatNumber(oItem.Prd.getRealPrice,0),"0")%></strong>원</p>
					</div>
				</div>
				</form>
				<form name="BagArrFrm" method="post" action="" onsubmit="return false;" >
				<input type="hidden" name="mode" value="arr">
				<input type="hidden" name="bagarr" value="">
				</form>
				<div class="btnAreaV16a">
					<% if Not(isSpCtlIem) then%>
					<p><button type="button" class="btnV16a btnWishV16a <%=chkIIF(isMyFavItem,"actWish","")%>" onclick="TnAddFavoritePrd('<% = oItem.Prd.Fitemid %>');return false;"><%=FormatNumber(oItem.Prd.FFavCount,0)%></button></p>
					<% end if %>
					<%
						if IsPresentItem then	'## Present상품
							IF Not(oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut) Then
								If IsUserLoginOK() Then		'# 로그인한 경우
					%>
						<p class="actBuy"><button type="button" class="btnV16a btnRed2V16a" onclick="<%=chkiif(oItem.Prd.FOptionCnt>0 or oItem.Prd.FItemDiv = "06","FnAddShoppingBag(true)","TnAddShoppingBag(true)")%>;">바로신청</button></p>
					<%			else %>
						<p class="actBuy"><button type="button" class="btnV16a btnRed2V16a" onclick="alert('회원 구매만 가능합니다. 로그인 후 구매해 주세요.');">바로신청</button></p>
					<%
								end if
							else
					%>
						<p><button type="button" class="btnV16a btnRed2V16a" disabled="disabled">품절</button></p>
					<%
							end if
						else	'## 일반상품
					%>
						<% IF Not(oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut) Then %>
							<p class="actBuy"><button type="button" class="btnV16a btnRed2V16a">구매하기</button></p>
							<% If Not(oItem.Prd.IsReserveItem) then %>
							<p class="actCart"><button type="button" class="btnV16a btnRed1V16a" onclick="<%=chkiif(oItem.Prd.FOptionCnt>0,"FnAddShoppingBag(true)","TnAddShoppingBag(true)")%>;" disabled="disabled">장바구니</button></p>
							<% End If %>
						<% else %>
							<p><button type="button" class="btnV16a btnRed2V16a" disabled="disabled">품절</button></p>
						<% end if %>
						<% IF Not(oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut or oItem.Prd.IsMileShopitem) Then %>
							<p class="actNow"><button type="button" class="btnV16a btnRed2V16a" onclick="<%=chkiif(oItem.Prd.FOptionCnt>0,"FnAddShoppingBag()","TnAddShoppingBag()")%>;" disabled="disabled">바로구매</button></p>
						<% end if %>
					<% end if %>
					<!--<p class="actBuy"><button type="button" class="btnV16a btnRed2V16a">구매하기</button></p> -->
					<!--<p class="actCart"><button type="button" class="btnV16a btnRed1V16a" disabled="disabled">장바구니</button></p> for dev msg : 구매하기옵션 선택후 disabled 해제 / 옵션 없는 경우 처음부터 disabled 아님 -->
					<!--<p class="actNow"><button type="button" class="btnV16a btnRed2V16a" disabled="disabled">바로구매</button></p> -->
				</div>
			</div>
			<%' 주문 영역 %>
			<script>
			$(function(){
				$('.btnZoomV16a').hide();
				$(window).scroll(function(){
					var s_position = $(".itemInfoV16a").outerHeight();
					var e_position1 = $(".itemDeatilV16a").outerHeight();
					var e_position2 = $("#lyrHPTgr").outerHeight();
					var position = $(window).scrollTop();
					if (position > s_position && position < parseInt(e_position1+e_position2)){
						if($('.btnZoomV16a').css("display")=="none"){
							$('.btnZoomV16a').fadeIn();
						}
					} else {
						$('.btnZoomV16a').hide();
					}
				});
			});
			</script>
			<a href="/category/pop_category_itemPrd_detail.asp?itemid=<%=itemid%>" class="btnZoomV16a">상품 확대보기</a>
			<button type="button" class="goTop" id="gotop">TOP</button>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incLogScript.asp" -->
			<div id="modalLayer" style="display:none;"></div>
			<div id="modalLayer2" style="display:none;"><div id="modalLayer2Contents"></div><div id="dimed"></div></div>

			<form name="qnaform" method="post" action="/my10x10/doitemqna.asp" target="iiBagWin" style="margin:0px;">
			<input type="hidden" name="id" value="" />
			<input type="hidden" name="itemid" value="<% = itemid %>" />
			<input type="hidden" name="mode" value="del" />
			<input type="hidden" name="flag" value="fd" />
			</form>
			<iframe src="" name="iiBagWin" frameborder="0" width="0" height="0"></iframe>
			<div id="tmpopt" style="display:none;"></div>
			<div id="tmpopLimit" style="display:none;"></div>
			<div id="tmpitemCnt" style="display:none;"></div>
		</div>
	</div>
</div>
<script language="JavaScript" type="text/javascript" SRC="/lib/js/todayview.js"></script>

<script type="application/ld+json">
{
	"@context": "http://schema.org/",
	"@type": "Product",
	"name": "<%= Replace(oItem.Prd.FItemName,"""","") %>",
	"image": "<%= getThumbImgFromURL(oItem.Prd.FImageBasic,400,400,"true","false") %>",
	"mpn": "<%= itemid %>",
	"brand": {
		"@type": "Thing",
    	"name": "<%= Replace(UCase(oItem.Prd.FBrandName),"""","") %>"
	}<%
	 if (oItem.Prd.FEvalCnt > 0) then
		 dim avgEvalPoint : avgEvalPoint = getEvaluateAvgPoint(itemid)
		 if (avgEvalPoint > 0) then
	 %>,
	"aggregateRating": {
		"@type": "AggregateRating",
		"ratingValue": "<%= avgEvalPoint %>",
		"reviewCount": "<%= oItem.Prd.FEvalCnt %>"
	}<%
	 	end if
	 end if
	 %>
}
</script>

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
