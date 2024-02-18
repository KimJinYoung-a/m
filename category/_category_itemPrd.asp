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
<!-- #include virtual="/lib/util/functions.asp" -->
<%
	dim itemid	: itemid = requestCheckVar(request("itemid"),9)
	Dim page, vDisp, cpid, vDepth, vMakerid, GiftNotice
	Dim oItemOptionMultiple, oItemOption, isAlarmOptionPushChk, oItemOptionMultipleType, strSql, multiOptionValue

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

	if itemid=0 then
		Call Alert_Return("상품번호가 없습니다.")
		response.End
	end if

	dim LoginUserid
	LoginUserid = getLoginUserid()

	dim flag : flag = request("flag")

	'// 에코마케팅용 레코벨 스크립트 용(2016.12.21)
	Dim vPrtr
	vPrtr = requestCheckVar(request("pRtr"),200)

	dim oItem, ItemContent
	set oItem = new CatePrdCls
	oItem.GetItemData itemid

	if oItem.FResultCount=0 then
		Call Alert_Return("존재하지 않는 상품입니다.")
		response.End
	end If
	
	'// amplitude를 통한 데이터 확인을 위해 gaparam으로 넘어오는값 체크
	Dim gaparamChkVal
	gaparamChkVal = requestCheckVar(request("gaparam"),30)

	if (oItem.Prd.FItemDiv = "21") Then
		'딜상품 딜 페이지로 이동
		Response.redirect("/deal/deal.asp?itemid="&Cstr(itemid)&"&gaparam="&gaparamChkVal)
	End If

	'// 100원의 기적 상품 노출x
	If itemid = "1930624" or itemid = "1930622" or itemid = "1930621" or itemid = "1930738" or itemid = "1930623" or itemid = "1930733" or itemid = "1930625" or itemid = "1930742" or itemid = "1930740" or itemid = "1930741" or itemid = "1930735" or itemid = "1930739" or itemid = "1930736" or itemid = "1930737" or itemid = "1930734" Then
		Response.redirect("/category/closedprd.asp?"&request.servervariables("QUERY_STRING"))
	End If 

	if oItem.Prd.Fisusing="N" Then
'		// 수정 2017-03-09 이종화 - 종료 상품일시 - page redirect
'		Call Alert_Return("판매가 종료되었거나 삭제된 상품입니다.")
'		response.End
		Response.redirect("/category/closedprd.asp?"&request.servervariables("QUERY_STRING"))
	end if

	'// 파라메터 접수
	vDisp = requestCheckVar(getNumeric(Request("disp")),18)
	if vDisp="" or (len(vDisp) mod 3)<>0 then vDisp = oItem.Prd.FcateCode

	'// 브랜드ID 접수
	vMakerid = oItem.Prd.Fmakerid

	'### 현재 위치 ###
	Dim vCateNavi, vCateItemCount, vIsLastDepth, vCateCnt
	vIsLastDepth = true
	vCateNavi = printCategoryHistorymultiNew2017(vDisp,vIsLastDepth,false,vCateCnt,false)
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

    if (itemid="1749918") then  ''2018/02/19 테돈요청 TEST
        oEval.FsortMethod = "be"
    end if

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

	'// 스페셜 항공권 상품 (ex 진에어 이벤트)
	Dim IsSpcTravelItem
	IsSpcTravelItem = oitem.Prd.IsTravelItem and oItem.Prd.Fmakerid = "10x10Jinair"

	'// 공유 제한 상품 (프리젠트 상품 또는 특수한 브랜드)
	Dim isSpCtlIem
	isSpCtlIem = (IsPresentItem or oItem.Prd.FMakerid="10x10present")

	'2015 APP전용 상품 안내
	if IsPresentItem or oItem.Prd.FOrgMakerid="10x10present" or itemid=1250336 then
		Call Alert_Move("본 상품은 텐바이텐 APP에서만 보실 수 있습니다.","/")
		dbget.Close: Response.End
	end if

	'판매 매장 정보
	dim arrOffShopList
	arrOffShopList = oItem.GetSellOffShopList(itemid,3)

	'// 현장수령 상품
	Dim IsReceiveSiteItem
	IsReceiveSiteItem = (oItem.Prd.FDeliverytype="6")

	'=============================== 이메일특가 번호 접수 및 특가 계산 (base64사용) =================================
	cpid = requestCheckVar(request("ldv"),12)
	'2017-09-18 김진영 추가
	Dim RequestRdsite
	If requestCheckVar(request("rdsite"),32) <> "" Then
		RequestRdsite = requestCheckVar(request("rdsite"),32)
	End If
	''''''''''''''''''''''''

	if Not(cpid="" or isNull(cpid)) then
		cpid = trim(Base64decode(cpid))
		if isNumeric(cpid) then
			oItem.getTargetCoupon cpid, itemid
		end if
	ElseIf (Left(request.Cookies("rdsite"), 13) = "mobile_nvshop") OR (LEFT(RequestRdsite, 6) = "nvshop") Then
		Dim naverSpecialcpID

		Call oItem.getNaverTargetCoupon(itemid) ''2018/03/09

'		if (application("Svr_Info")<>"Dev") then
'			naverSpecialcpID = 13523
'		Else
'			naverSpecialcpID = 11151
'		End If
'
'		if isNumeric(naverSpecialcpID) then
'			oItem.getTargetCoupon naverSpecialcpID, itemid
'		end if
	end if

	'//옵션 HTML생성
	dim ioptionBoxHtml
	IF (oitem.Prd.FOptionCnt>0) then
		if (IsReceiveSiteItem) or (IsPresentItem) or (IsTicketItem) or (oItem.Prd.Flimitdispyn="N") then
			ioptionBoxHtml = GetOptionBoxDpLimit2017(itemid, oitem.Prd.IsSoldOut,Not(IsReceiveSiteItem) and Not(IsPresentItem and oItem.Prd.FRemainCount>200) and Not(IsTicketItem and oItem.Prd.FRemainCount>100 ) and Not(oItem.Prd.Flimitdispyn="N"))
		else
		    ioptionBoxHtml = GetOptionBox2017(itemid, oitem.Prd.IsSoldOut)
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
	GiftNotice=False '사은품 소진 메세지 출력 유무

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

	'// 페이스북 픽셀 관련 앱링크 메타 추가
	strOGMeta = strOGMeta & "<meta property=""al:ios:url"" content=""tenwishapp://http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid="&itemid&""" /> "
	strOGMeta = strOGMeta & "<meta property=""al:ios:app_store_id"" content=""864817011"" /> "
	strOGMeta = strOGMeta & "<meta property=""al:ios:app_name"" content=""10x10"" /> "
	strOGMeta = strOGMeta & "<meta property=""al:android:url"" content=""tenwishapp://http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid="&itemid&"""> "
	strOGMeta = strOGMeta & "<meta property=""al:android:package"" content=""kr.tenbyten.shopping""> "
	strOGMeta = strOGMeta & "<meta property=""al:android:app_name"" content=""10x10""> "

	'해더 타이틀
	strHeadTitleName = "상품정보"
	if oItem.Prd.isSoldout then
		strPageKeyword = ""
	else
		strPageKeyword = Replace(oItem.Prd.FItemName,"""","") & ", " & Replace(oItem.Prd.FBrandName,"""","") & ", " & Replace(oItem.Prd.FBrandName_kor,"""","")
	end If

	'// 제품상세 facebook 픽셀 스크립트 추가 2016.09.22 원승현
	facebookSCRIPT = "<script>" & vbCrLf &_
					"!function(f,b,e,v,n,t,s){if(f.fbq)return;n=f.fbq=function(){n.callMethod?n.callMethod.apply(n,arguments):n.queue.push(arguments)};if(!f._fbq)f._fbq=n;" & vbCrLf &_
					"n.push=n;n.loaded=!0;n.version='2.0';n.queue=[];t=b.createElement(e);t.async=!0;" & vbCrLf &_
					"t.src=v;s=b.getElementsByTagName(e)[0];s.parentNode.insertBefore(t,s)}(window,document,'script','//connect.facebook.net/en_US/fbevents.js');" & vbCrLf &_
					"fbq('init', '260149955247995');" & vbCrLf &_
					"fbq('track','PageView');" & vbCrLf &_
					"fbq('track', 'ViewContent',{content_ids:['"&itemid&"'],content_type:'product'});</script>" & vbCrLf &_
					"<noscript><img height=""1"" width=""1"" style=""display:none"" src=""https://www.facebook.com/tr?id=260149955247995&ev=PageView&noscript=1"" /></noscript>"

	'// 상품상세 로그 사용여부(2017.01.12)
	Dim LogUsingCustomChk
	If LoginUserId="thensi7" Then
		LogUsingCustomChk = True
	Else
		LogUsingCustomChk = True
	End If

	'// 상품상세 로그저장(2017.01.11 원승현)
	If LogUsingCustomChk Then
		If IsUserLoginOK() Then
			'// 검색을 통해서 들어왔을경우
			If Trim(vPrtr)<>"" Then
				Call fnUserLogCheck("itemrect", LoginUserid, itemid, "", Trim(vPrtr), "mw")
			Else
				Call fnUserLogCheck("item", LoginUserid, itemid, "", "", "mw")
			End If
		End If
	End If

	'// 구글 ADS 스크립트 관련(2017.05.29 원승현 추가)
	googleADSCRIPT = " <script type='text/javascript'> "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & " var google_tag_params = { "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "		ecomm_prodid: '"&itemid&"', "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "		ecomm_pagetype: 'product', "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "		ecomm_totalvalue: "&oItem.Prd.FSellCash&" "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "	}; "&vbCrLf
	googleADSCRIPT = googleADSCRIPT & "	</script> "

	'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
	dim snpTitle, snpLink, snpPre, snpImg, snpTag
	snpTitle = oItem.Prd.FItemName
	'snpLink = "http://m.10x10.co.kr/category/category_itemprd.asp?itemid=" & itemid
	snpLink = "http://10x10.co.kr/" & itemid
	snpPre = "텐바이텐 HOT ITEM!"
	snpImg = oItem.Prd.FImageBasic
	snpTag = "#10x10"

	'// appBoy CustomEvent
	appBoyCustomEvent = "appboy.logCustomEvent('userProductView');"

	'// 옵션이 있는 상품중 단일 또는 복합옵션일 경우 해당 옵션의 품절여부를 가져온다.
	If trim(oItem.Prd.FSellYn) = "Y" Then
		isAlarmOptionPushChk = False
		'// 옵션정보를 가져온다.
		set oItemOption = new CItemOption
		oItemOption.FRectItemID = itemid
		oItemOption.FRectIsUsing = "Y"
		oItemOption.GetOptionList

		If oItemOption.FResultCount>0 Then
			set oItemOptionMultiple = new CItemOption
			oItemOptionMultiple.FRectItemID = itemid
			oItemOptionMultiple.GetOptionMultipleList

			If oItemOptionMultiple.FResultCount>0 Then
				'// 멀티옵션일 경우
				set oItemOptionMultipleType = new CItemOption
				oItemOptionMultipleType.FRectItemId = itemid
				oItemOptionMultipleType.GetOptionMultipleTypeList

				strSql = " Select top 1 "
				strSql = strSql & "	itemid, "
				strSql = strSql & "		stuff( "
				strSql = strSql & "				( "
				strSql = strSql & "					Select ','''+substring(itemoption, 1, "&oItemOptionMultipleType.FResultCount&")+'''' "
				strSql = strSql & "					From db_item.[dbo].[tbl_item_option] "
				strSql = strSql & "					Where itemid = o.itemid And optsellyn='Y' "
				strSql = strSql & "					group by itemid, substring(itemoption, 1, "&oItemOptionMultipleType.FResultCount&")  "
				strSql = strSql & "					FOR XML PATH('') "
				strSql = strSql & "				),1,1,'' "
				strSql = strSql & "			 ) as availableOpt  "
				strSql = strSql & "	From db_item.[dbo].[tbl_item_option] o Where itemid='"&itemid&"' And optsellyn='Y' "
				strSql = strSql & "	group by itemid "
				rsget.Open strSql, dbget, 1
				if Not rsget.Eof Then
					multiOptionValue = rsget("availableOpt")
				End If
				rsget.close

				strSql = " Select * From db_item.dbo.tbl_item_option Where itemid='"&itemid&"' And substring(itemoption, 1, "&oItemOptionMultipleType.FResultCount&") in ("&multiOptionValue&") And "
				strSql = strSql & "		case when optlimityn='N' then  "
				strSql = strSql & "			case when optsellyn='N' then 0 "
				strSql = strSql & "			else 1 end "
				strSql = strSql & "		else (optlimitno-optlimitsold) end < 1 "
				rsget.Open strSql, dbget, 1
				if Not rsget.Eof Then
					Do Until rsget.eof
						isAlarmOptionPushChk = True
					rsget.movenext
					Loop
				End If
				rsget.close
			Else
				'// 단일옵션일 경우
				for i=0 to oItemOption.FResultCount-1
					If ((oitem.Prd.IsSoldOut) or (oItemOption.FItemList(i).IsOptionSoldOut)) Then
						isAlarmOptionPushChk = True
					End If
				Next
			End If

			Set oItemOptionMultiple = Nothing
		End If

		Set oItemOption = Nothing
	End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style>
html,body{
	-webkit-overflow-scrolling : touch !important;
	overflow: auto !important;
	height: 100% !important;
	}
</style>
<link rel="canonical" href="http://m.10x10.co.kr/category/category_itemPrd.asp?itemid=<%= itemid %>" />
<title>10x10: <%= oItem.Prd.FItemName %></title>
	<script type="application/x-javascript" src="/lib/js/itemPrdDetail.js"></script>
	<script type="application/x-javascript" src="/lib/js/shoppingbag_script.js"></script>
	<script type="application/x-javascript" src="/lib/js/jquery.numspinner_m.js"></script>
	<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
	<script>
		$(function() {
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

			/* item swiper */
			if ($("#itemSwiper .swiper-container .swiper-slide").length > 1) {
				var rollingSwiper = new Swiper("#itemSwiper .swiper-container", {
					loop:true,
					speed:1000,
					autoplay: 2000,
					onSlideChangeStart: function (rollingSwiper) {
						var vActIdx = parseInt(rollingSwiper.activeIndex);
						if (vActIdx<=0) {
							vActIdx = rollingSwiper.slides.length-2;
						} else if(vActIdx>(rollingSwiper.slides.length-2)) {
							vActIdx = 1;
						}
						$(".pagination-no b").text(vActIdx);
					}
				});
				$(".pagination-no").show();
				$(".pagination-no b").text(1);
				$(".pagination-no span").text(rollingSwiper.slides.length-2);
			}

			// plus slae swipe
			if ($("#plussaleSwiper .swiper-container .swiper-slide").length > 1) {
				var plussaleSwiper = new Swiper("#plussaleSwiper .swiper-container", {
					//loop:true,
					slidesPerView:"auto"
				});
			}

			$(window).scroll(function() {
				var window_top = $(window).scrollTop();
				var div_top = $(".itemDeatilV16a").offset().top;

				if (window_top >= div_top) {
					$(".commonTabV16a").addClass('sticky');
				} else {
					$(".commonTabV16a").removeClass('sticky');
				}
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
				$('html, body').animate({scrollTop: $(".itemDeatilV16a").offset().top}, 500);
			});

			// 로딩중 표시
			$("#lyLoading").ajaxStart(function(){
				$(this).show();
			}).ajaxStop(function(){
				$(this).hide();
			});

			//제작 문구만 있는 경우
			if (!$('.itemoption #opttag a:first').hasClass('on')){
				$('.txtBoxV16a').addClass('current');
			}

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

			<%' amplitude 이벤트 로깅 %>
				//tagScriptSend('itemprd', '<%=itemid%>', '', 'amplitudeProperties');
				<% if trim(gaparamChkVal)="piece_sub" then %>
					//setTimeout("tagScriptSend('', 'piece_sub', '', 'amplitude')", 100);
				<% end if %>
				<% if trim(gaparamChkVal)="piece_main" then %>
					//setTimeout("tagScriptSend('', 'piece_main', '', 'amplitude')", 150);
				<% end if %>
				//setTimeout("tagScriptSend('', '<%=trim(gaparamChkVal)%>', '', 'amplitude')", 180);
				fnAmplitudeEventAction("view_product","itemid","<%=itemid%>");
			<%'// amplitude 이벤트 로깅 %>

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
			$("#subtot").text(plusComma(parseInt(v * p))+"<%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%>");
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

		function fnsbagly(v) {
			if (v=="x"){
				$("#sbaglayerx").show();
				$("#alertBoxV17a").show();
			}else if(v=="o"){
				$("#sbaglayero").show();
				$("#alertBoxV17a").show();
			}
			setTimeout(function() {
				$("#alertBoxV17a").fadeOut(1000);
			}, 2500);
		}

		//2017-07-05 플로팅 2017ver
		$(function(){
			// floating area option select control
			$('.itemOptV16a select').focus(function(){
				if($(this).hasClass('current')){
					$(this).removeClass('current');
				} else {
					$('.itemOptV16a select').removeClass('current');
					$(this).addClass('current');
				}
			});
			$('.itemOptV16a select').focusout(function(){
				$('.itemOptV16a select').removeClass('current');
			});

			// floating area swipe
			floatScroll = new Swiper('.itemOptV16a .swiper-container', {
				scrollbar:'.itemOptV16a .swiper-scrollbar',
				direction:'vertical',
				slidesPerView:'auto',
				mousewheelControl:true,
				freeMode:true,
				resistanceRatio:0
			});

			// floating area height calculate
			function hCalc() {
				var optH = $('.itemOptV16a').outerHeight();
				$('.itemOptV16a').css('height',optH+'px');
			}

			// floating area control
			$('.controller, .actBuy').click(function(){
				if($('.itemFloatingV16a').hasClass('opening16a')){
					$('.itemFloatingV16a').removeClass('opening16a');
					$('.actBuy').css('display','table-cell');
					$('.actCart, .actNow, .actStock').hide();
				} else {
					$('.itemFloatingV16a').addClass('opening16a');
					hCalc();
					$('.actBuy').hide();
					$('.actCart, .actNow').css('display','table-cell');
					<% if isAlarmOptionPushChk then %>
						$('.actStock').css('display','table-cell');
					<% end if %>
				}

				<% if Not(oItem.Prd.FOptionCnt>0) And Not(IsPresentItem) and Not(IsSpcTravelItem) then %>
					$(".btnAreaV16a .actCart .btnRed1V16a").attr("disabled",false);
					$(".btnAreaV16a .actNow .btnRed2V16a").attr("disabled",false);
				<% end if %>

				floatScroll.update();
			});

			/* layer popup for dropdown */
			$.fn.layerOpen = function(options) {
				return this.each(function() {
					var $this = $(this);
					var $layer = $($this.attr("href") || null);
					$this.click(function() {
						if ($this.attr('disabled') != "disabled"){
							$layer.attr("tabindex",0).show().focus();
							$layer.find(".btnClose, .btnDrop").one("click",function () {
								$layer.hide();
								$this.focus();

								<%'레이어 닫은후 클래스 처리 %>
								var $opttag = $("#opttag a");
								$opttag.each(function(index){
									if ($this.index() == $(this).index()){
										$(this).addClass("on");
									}else{
										$(this).removeClass("on");
									}
								});
								$('.txtBoxV16a').removeClass('current');
							});

							<%'DB에서 받아온 옵션 노출 %>
							var $dropBoxs = $(".dropBox ul");
							$dropBoxs.each(function(index){
								if ($this.index() == $(this).index()-1){
									$(this).show();
								}else{
									$(this).hide();
								}
							});
							dropdownScrollLayer.onResize(); //ul 초기화
							dropdownScrollLayer.update(); //ul update
						}
					});
				});
			}
			$(".layer").layerOpen();

			/* swipe scroll for dropdown layer */
			var dropdownScrollLayer = new Swiper('.lyDropdown .swiper-container', {
				scrollbar:'.lyDropdown .swiper-scrollbar',
				direction:'vertical',
				slidesPerView:'auto',
				mousewheelControl:true,
				freeMode:true
			});
		});
		//2017-07-05 플로팅 2017ver

		//2017 추가
		$(function(){
			/* breadcrumbs */
			var breadcrumbsSwiper = new Swiper("#breadcrumbs .swiper-container",{
				slidesPerView:"auto"
			});

			/* 상품가격 더보기 */
			$(".item-detail .btn-more").on("click", function(){
				var thisCont = $(this).attr("href");
				$(thisCont).slideToggle();
				return false;
			});

		});
	</script>
</head>
<body class="default-font body-sub bg-grey category-item">
<!-- #include virtual="/lib/inc/incHeader.asp" -->
<!-- content area -->
<div id="content" class="content">
	<% '' 2017 정기세일-숨은 보물을 찾아라(4/3~4/17) %>
	<!-- #include virtual="/event/etc/2017props_77062.asp" -->

	<% If vDisp <> "111" and vDisp<>"0" Then %>
	<div id="breadcrumbs" class="breadcrumbs">
		<div class="swiper-container">
			<ol class="swiper-wrapper"><%= vCateNavi %></ol>
		</div>
	</div>
	<% End If %>
	<%' 웨딩 관련 이벤트 상품 배너 노출. %>
	<div style="display:none;" id="weddingbanner"><a href="/wedding/"><img src="http://fiximage.10x10.co.kr/m/2018/wedding2018/bnr_wedding.jpg" class="vTop" alt="all about wedding"></a></div>
	
	<%' 상품상세 광고배너 %>
	<% server.Execute("/chtml/main/loader/banner/exc_itemprd_banner.asp") %>

	<% If clsDiaryPrdCheck.FResultCount > 0 then %>
		<% If Left(Now(), 10) > "2017-10-15" and Left(Now(), 10) < "2018-01-01" Then %>
			<a href="/diarystory2018/?gnbflag=1"><img src="http://fiximage.10x10.co.kr/web2017/diary2018/m/bnr_detail_diary_v3.jpg" class="vTop" alt="DIARY STORY 2018" /></a>
		<% end if %>
	<% end if %>

	<%' 상품이벤트 노출 배너입니다. %>
	<div style="display:none;" id="itemevent"></div>

	<div id="itemSwiper" class="item-detail-swiper">
		<% IF (oItem.Prd.isLimitItem) and (not (oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut)) and (Not IsReceiveSiteItem) and Not(IsPresentItem and oItem.Prd.FRemainCount>200 ) and Not(IsTicketItem and oItem.Prd.FRemainCount>100 ) Then %>
		<span class="label label-box">한정 <% = oItem.Prd.FRemainCount %>개</span>
		<% end if %>
		<%
		Dim vOneAndOne, vOneAndOneSDate
		vOneAndOne = getDiaryoneandonegubun2(itemid)
		If vOneAndOne <> "" Then
			vOneAndOneSDate = Split(vOneAndOne,"||")(1)
			vOneAndOne = Split(vOneAndOne,"||")(0)
		End If

		If GiftSu > 0 Then %>
			<span class="label label-box" style="right:0; left:auto;">
				<%
					if vOneAndOne="" then
						response.write "사은품"
					else
						if vOneAndOne="1" then
							response.write "Gift"	'"1+1"
						elseif vOneAndOne="2" then
							response.write "Gift"	'"1:1"
						else
							response.write "사은품"
						end if
					end if
				%> 남은수량 <% = GiftSu %>개</span>
		<% else %>
			<%
			If date() = CDate(vOneAndOneSDate) Then
				if vOneAndOne <> "" then %>
				<span class="label label-box" style="right:0; left:auto;">
					<%
						if vOneAndOne="" then
							response.write "사은품"
						else
							if vOneAndOne="1" then
								response.write "Gift"	'"1+1"
							elseif vOneAndOne="2" then
								response.write "Gift"	'"1:1"
							else
								response.write "사은품"
							end if
						end if
					%> 남은수량 0개</span>
			<%
				GiftNotice=True '사은품 소진 노티
				end if
			end if
			%>
		<% end if %>
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
		<div class="pagination-no"><b></b>/<span></span></div>
	</div>

	<% if oItem.Prd.FisJust1Day then %>
	<div class="timer" id="lyrjust1day"></div>
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

	<section class="items item-detail">
		<div class="desc">
			<span class="brand"><a href="/street/street_brand.asp?makerid=<%=oItem.Prd.Fmakerid%>&ab=012_a_1"><%=oItem.Prd.FBrandName%><em>브랜드</em></a></span>
			<h2 class="name"><%= oItem.Prd.FItemName %></h2>
			<% '혹시 몰라서주석 처리함 2017-08-10 이종화%>
			<%' IF oItem.Prd.IsSoldOut Then %>
				<!--<span class="fgSoldout">품절</span> -->
			<%' Else %>
				<%' if oItem.Prd.IsTenOnlyitem then %><!--<span class="fgOnly">ONLY</span>--> <%' end if %>
				<%' IF oItem.Prd.isNewItem Then %><!--<span class="fgNew">NEW</span>--> <%' End If %>
				<%' IF oItem.Prd.IsSaleItem THEN %><!--<span class="fgSale">SALE</span>--> <%' End If %>
				<%' if oitem.Prd.isCouponItem Then %><!--<span class="fgCoupon">쿠폰</span>--> <%' End If %>
				<%' IF oItem.Prd.isLimitItem Then %><!--<span class="fgLimit">한정</span>--> <%' End If %>
				<%' if oItem.getGiftExists(itemid) then %><!--<span class="fgPlus">1+1</span>--> <%' end if %>
				<%' IF oItem.Prd.IsFreeBeasong Then %><!--<span class="fgFree">무료배송</span>--> <%' End If %>
				<%' IF oItem.Prd.IsSoldOut Then %><!--<span class="fgSoldout">품절</span>--> <%' End if %>
			<%' End if %>
			<div class="price">
				<h3 class="tenten">텐바이텐가</h3>
				<!-- 할인일 경우 -->
				<div class="unit">
					<% IF ((oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0)) or (oItem.Prd.IsSaleItem and oItem.Prd.IsSpecialUserItem) or (oitem.Prd.isCouponItem) THEN %>
					<s><%=FormatNumber(oItem.Prd.getOrgPrice,0)%></s>
					<b class="sum color-red"><%= FormatNumber(oItem.Prd.GetCouponAssignPrice,0) %><span class="won"><%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></span></b>
					<% Else %>
					    <% if oItem.Prd.FSellCash>oItem.Prd.getOrgPrice then ''이상한 CASE %>
					    <b class="sum"><%=FormatNumber(oItem.Prd.FSellCash,0)%><span class="won"><%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></span></b>    
					    <% else %>
					    <b class="sum"><%=FormatNumber(oItem.Prd.getOrgPrice,0)%><span class="won"><%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></span></b>
					    <% end if %>
					<% End If %>
				</div>
				<% IF ((oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0)) or (oItem.Prd.IsSaleItem and oItem.Prd.IsSpecialUserItem) or (oitem.Prd.isCouponItem) THEN %>
				<a href="#priceList" class="btn-more">상세 가격 정보 보기</a>
				<% End If %>
			</div>
		</div>
		<dl id="priceList" class="price-list">
			<% IF ((oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0)) or (oItem.Prd.IsSaleItem and oItem.Prd.IsSpecialUserItem) or (oitem.Prd.isCouponItem) THEN %>
					<dt><%=chkIIF(Not(IsTicketItem),"판매가","티켓기본가")%></dt>
					<dd><div class="price"><b class="sum"><%=FormatNumber(oItem.Prd.getOrgPrice,0)%><span class="won"><%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></span></b></div></dd>
				<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
					<dt>할인판매가</dt>
					<dd><div class="price"><b class="discount color-red"><%=chkiif(oItem.Prd.FOrgprice = 0,"0",CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100))%>%</b> <b class="sum"><%=FormatNumber(oItem.Prd.FSellCash,0)%><span class="won"><%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></span></b></div></dd>
				<% end if %>
				<% if oItem.Prd.IsSaleItem and oItem.Prd.IsSpecialUserItem then %>
					<dt>우수회원가<span class="icoHot"><a href="/my10x10/special_shop.asp"><em class="rdBtn2">우수회원샵</em></a></span></dt>
					<dd><div class="price"><b class="discount color-red"><% = getSpecialShopPercent() %>%</b><b class="sum"><%=FormatNumber(oItem.Prd.getRealPrice,0)%><span class="won"><%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></span></b></div></dd>
				<% end if %>
				<% if oitem.Prd.isCouponItem Then %>
					<dt>쿠폰적용가</dt>
					<dd><div class="price"><b class="discount color-green"><%= oItem.Prd.GetCouponDiscountStr %></b> <b class="sum"><%=FormatNumber(oItem.Prd.GetCouponAssignPrice,0)%><span class="won"><%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></span></b></div></dd>
				<% end if %>
			<% end if %>
		</dl>
		<% if oitem.Prd.isCouponItem Then %>
		<div class="btn-group">
			<button type="button" onclick="jsDownCoupon('prd','<%= oitem.Prd.FCurrItemCouponIdx %>'); return false;"><%= oItem.Prd.GetCouponDiscountStr %> 쿠폰<span class="icon icon-download"></span></button>
			<form name="frmC" method="get" action="/shoppingtoday/couponshop_process.asp" style="margin:0px;">
			<input type="hidden" name="stype" value="" />
			<input type="hidden" name="idx" value="" />
			</form>
		</div>
		<% end if %>
	</section>

	<div class="item-etc-info">
		<ul>
			<%
				if oItem.Prd.IsAboardBeasong then
					if oItem.Prd.IsFreeBeasong then
						Response.Write "<li><span class=""icon icon-shipping""></span>텐텐 무료배송 + 해외배송</li>"
					else
						Response.Write "<li><span class=""icon icon-shipping""></span>텐텐배송 + 해외배송</li>"
					end if
				else
					Response.Write "<li><span class=""icon icon-shipping""></span>"& oItem.Prd.GetDeliveryName
					if Not(oItem.Prd.IsFreeBeasong) and (oItem.Prd.IsUpcheParticleDeliverItem or oItem.Prd.IsUpcheReceivePayDeliverItem) Then
						Response.write "<a href=""/street/street_brand.asp?makerid="&oItem.Prd.Fmakerid&"&ab=012_b_1"">배송비 절약 상품</a>"
					Else
						response.write 	"</li>"
					End If
				end if
			%>
			<% If G_IsPojangok Then %>
			<% If oItem.Prd.IsPojangitem Then %>
			<li><span class="icon icon-wrapping"></span>선물포장가능 <a href="/category/popPkgIntro.asp?itemid=<%=itemid%>">텐바이텐 선물 포장</a></li>
			<% End If %>
			<% End If %>
			<% If IsUserLoginOK Then %>
			<li><span class="icon icon-gifttalk"></span>선물 골라주세요! <a href="" onclick="writeShoppingTalk('<%=itemid%>'); return false;">기프트톡 쓰기</a></li>
			<% else %>
			<li><span class="icon icon-gifttalk"></span>선물 골라주세요! <a href="" onClick="if(confirm('로그인이 필요한 서비스입니다.\n로그인 하시겠습니까?') == true){location.href = '<%=M_SSLUrl%>/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>';}; return false;">기프트톡 쓰기</a></li>
			<% end if %>
			<% if isArray(arrOffShopList) then %>
			<li><span class="icon icon-offline"></span>
				<%=arrOffShopList(1,0) & chkIIF(ubound(arrOffShopList,2)>0," 외 " & ubound(arrOffShopList,2) & "곳","")%>
				<a href="" onclick="fnOpenModal('pop_SaleStoreList.asp?itemid=<%=itemid%>'); return false;">판매 매장정보</a>
			</li>
			<% end if %>
		</ul>
	</div>

	<!--// Plussale //-->
	<!-- #Include virtual="/category/inc_PlusSaleList.asp" -->

	<!--// Category Best //-->
	<!-- #include virtual="/category/inc_category_best.asp" -->

	<% If (now() >  #09/18/2017 00:00:00# And now() <= #09/19/2017 23:59:59#) then %>
	<!-- 한수위 쿠폰 배너 2017.06.26~ 07.05 -->
	<div class="bnr" style="margin-bottom:1rem;">
		<a href="/event/eventmain.asp?eventid=80384" title="한수위 쿠폰 페이지로 이동"><img src="http://imgstatic.10x10.co.kr/event/eventetc/2017/evt_80384_m2.jpg" alt="한수위 쿠폰" /></a>
	</div>
	<% end if %>
	<%
		'2017년 봄정기세일 안내 배너 노출
		if InStr(request.ServerVariables("HTTP_REFERER"),"10x10.co.kr")<1 and date>="2017-04-03" and date<="2017-04-17" then
	%>
	<div class="bnr" style="margin-bottom:1rem;">
		<a href="/event/eventmain.asp?eventid=77059&gaparam=item_banner_0" title="소품전 메인 페이지로 이동"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77059/m/img_bnr_sopum.png" alt="텐바이텐 봄 정기세일 진행 중! 최대 30% coupon 4월 17일까지" /></a>
	</div>
	<%	end if %>

	<div class="itemPrdV16a itemPrdV17">
		<%' 상품상세설명 영역 %>
		<div class="itemDeatilV16a itemDetailV18a">
			<!-- #include virtual="/category/category_itemprd_detail_new.asp" -->
		</div>
		<%'// 상품상세설명 영역 %>

		<% ''If (Not IsTicketItem) Then '티켓아닌경우 - 일반상품 %>
			<% If False Then %>
				<% ' 레코벨 서비스 오픈 150728 원승현 %>
				<script type="text/javascript">
					//var vIId='<%=itemid%>', vDisp='<%=vDisp%>';
				</script>
				<% if cFlgDBUse then %>
					<!--<script type="text/javascript" src="./inc_happyTogether.js"></script>-->
				<% end if %>
				<!--// 함께구매하면 좋은상품 -->
				<!--<div id="lyrHPTgr"></div>-->

			<% End If %>
			<%'// 2017.06.08 추가 (원승현) %>
			<% if cFlgDBUse then %>
				<script type="text/javascript">
					$.ajax({
						url: "act_happyTogetherNew.asp?itemid=<%=itemid%>&disp=<%=vDisp%>",
						cache: false,
						async: true,
						success: function(vRst) {
							if(vRst!="") {
								$("#lyrHappyTogetherCol").empty().html(vRst);
							}
							else
							{
								$('#lyrHappyTogetherCol').hide();
							}
						}
						,error: function(err) {
							//alert(err.responseText);
							$('#lyrHappyTogetherCol').hide();
						}
					});
				</script>
				<div id="lyrHappyTogetherCol"></div>
			<% End If %>
			<!--// Event Item //-->
			<!-- #Include virtual="/category/_inc_ItemEventList.asp" -->
		<% ''end if %>
	</div>
</div>

<div class="alertBoxV17a" style="display:none" id="alertBoxV17a">
	<div>
		<p class="alertCart" id="sbaglayerx" style="display:none"><span>장바구니에 상품이 담겼습니다.</span></p>
		<p id="sbaglayero" style="display:none"><span>장바구니에 이미 같은 상품이 있습니다.</span></p>
		<p class="tMar1-1r"><button type="button" onClick="location.href='/inipay/ShoppingBag.asp';" class="btnV16a btnRed2V16a">장바구니 가기 <img src="http://fiximage.10x10.co.kr/m/2016/common/blt_arrow_white.png" alt="" /></button></p>
	</div>
</div>

<%' 2017 정기세일 이벤트(4/3~4/17 - 숨은 보물찾기 상품은 주문영역 삭제 - 유태욱 %>
<% if itemid = 1676126 or itemid = 1676180 or itemid = 1676207 or itemid = 1676225 or itemid = 1676272 or itemid = 1676297 or itemid = 1676411 or itemid = 1676426 or itemid = 1676481 or itemid = 1676486 or itemid = 1676503 or itemid = 1676514 or itemid = 1676654 or itemid = 1676596 or itemid = 1676597 then %>
<% else %>
<%' 주문 영역 %>
<div class="itemFloatingV16a itemFloatingV17">
	<form name="sbagfrm" method="post" action="" style="margin:0px;">
	<input type="hidden" name="mode" value="add" />
	<input type="hidden" name="itemid" value="<% = oitem.Prd.FItemid %>" />
	<input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
	<input type="hidden" name="itemoption" value="" />
	<input type="hidden" name="userid" value="<%= LoginUserid %>" />
	<input type="hidden" name="itemPrice" value="<%= oItem.Prd.getRealPrice %>">
	<input type="hidden" name="isPresentItem" value="<%= isPresentItem %>" />
	<input type="hidden" name="IsSpcTravelItem" value="<%= IsSpcTravelItem %>">
	<input type="hidden" name="itemea" readonly value="1" />
	<span class="controller"></span>
	<div class="itemOptWrapV16a">
		<div class="itemOptV16a">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<% IF oItem.Prd.FOptionCnt>0 then %>
							<div class="itemoption">
								<div id="opttag"></div>
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
									<p class="rt" id="subtot"><%=chkiif(Not(oItem.Prd.FOptionCnt>0) And Not(IsPresentItem),FormatNumber(oItem.Prd.getRealPrice,0),"0")%><%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></p>
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
		<% if Not(IsPresentItem) and Not(IsSpcTravelItem) then %>
		<div class="pdtPriceV16a">
			<p>
				<span>상품 합계</span>
			</p>
			<p class="rt"><strong id="spTotalPrc"><%=chkiif(Not(oItem.Prd.FOptionCnt>0) And Not(IsPresentItem),FormatNumber(oItem.Prd.getRealPrice,0),"0")%></strong><%=chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></p>
		</div>
		<% end if %>
	</div>
	</form>
	<form name="BagArrFrm" method="post" action="" onsubmit="return false;" >
	<input type="hidden" name="mode" value="arr">
	<input type="hidden" name="bagarr" value="">
	<input type="hidden" name="giftnotice" value="<%=GiftNotice%>">
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
			elseif IsSpcTravelItem then	'## 스페셜 항공권 상품
				IF Not(oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut) Then
					If IsUserLoginOK() Then		'# 로그인한 경우
		%>
			<p class="actBuy"><button type="button" class="btnV16a btnRed2V16a" onclick="TnAddShoppingBag()">바로구매</button></p>
			<p class="actCart"><button type="button" class="btnV16a btnRed2V16a" onclick="TnAddShoppingBag()">바로구매</button></p>
		<%			else %>
			<p class="actBuy"><button type="button" class="btnV16a btnRed2V16a" onclick="alert('회원 구매만 가능합니다. 로그인 후 구매해 주세요.');">바로구매</button></p>
			<p class="actCart"><button type="button" class="btnV16a btnRed2V16a" onclick="alert('회원 구매만 가능합니다. 로그인 후 구매해 주세요.');">바로구매</button></p>
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
				<% If IsUserLoginOK Then %>
					<p class="actStock"><button type="button" onclick="fnOpenModal('/category/pop_stock.asp?itemid=<%=itemid%>');return false;" class="btnV16a btn-line-blue">입고알림</button></p>
				<% Else %>
					<p class="actStock"><button type="button" onclick="alert('로그인 후 재입고 알림 신청이 가능합니다.');location.href='/login/login.asp?backpath=<%=Server.URLencode(CurrURLQ())%>';" class="btnV16a btn-line-blue">입고알림</button></p>
				<% End If %>
				<% If Not(oItem.Prd.IsReserveItem) then %>
				<p class="actCart"><button type="button" class="btnV16a btnRed1V16a" onclick="<%=chkiif(oItem.Prd.FOptionCnt>0,"FnAddShoppingBag(true)","TnAddShoppingBag(true)")%>;" disabled="disabled">장바구니</button></p>
				<% End If %>
			<% else %>
				<% If IsUserLoginOK Then %>
					<button type="button" onclick="fnOpenModal('/category/pop_stock.asp?itemid=<%=itemid%>');return false;" class="btnV16a btn-line-blue">입고알림</button>
				<% Else %>
					<button type="button" onclick="alert('로그인 후 재입고 알림 신청이 가능합니다.');location.href='/login/login.asp?backpath=<%=Server.URLencode(CurrURLQ())%>';" class="btnV16a btn-line-blue">입고알림</button>
				<% End If %>
				<!--p><button type="button" class="btnV16a btnRed2V16a" disabled="disabled">품절</button></p-->
			<% end if %>
			<% IF Not(oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut or oItem.Prd.IsMileShopitem) Then %>
				<p class="actNow"><button type="button" class="btnV16a btnRed2V16a" onclick="<%=chkiif(oItem.Prd.FOptionCnt>0,"FnAddShoppingBag()","TnAddShoppingBag()")%>;" disabled="disabled">바로구매</button></p>
			<% end if %>
		<% end if %>
	</div>
</div>
<% end if %>
<%' 주문 영역 %>
<!-- #include virtual="/common/LayerShare.asp" -->
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
<a href="/category/pop_category_itemPrd_detail.asp?itemid=<%=itemid%>" class="btn-zoom">상품 확대보기</a>
<!-- #include virtual="/lib/inc/incFooter.asp" -->
<!--button type="button" class="goTop" id="gotop">TOP</button-->
<!-- //content area -->
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

<%' dropdown layer popup 2017-07-05 신규 버전%>
<div id="lyDropdown" class="lyDropdown lyDropdownV17">
	<button type="button" class="btnClose">닫기</button>
	<div class="dropDown">
		<p class="btnDrop on">옵션을 선택하세요.</p>
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide">
					<div class="dropBox">
						<%' DB에서 옵션들 가저올 부분 %>
						<%=ioptionBoxHtml %>
						<%' DB에서 옵션들 가저올 부분 %>
					</div>
				</div>
			</div>
			<div class="swiper-scrollbar"></div>
		</div>
	</div>
</div>
<%' dropdown layer popup 2017-07-05 신규 버전%>
<script language="JavaScript" type="text/javascript" SRC="/lib/js/todayview.js"></script>

<script type="application/ld+json">
{
	"@context": "http://schema.org/",
	"@type": "Product",
	"name": "<%= Replace(oItem.Prd.FItemName,"""","") %>",
	"image": "<%= getThumbImgFromURL(oItem.Prd.FImageBasic,400,400,"true","false") %>",
	"mpn": "<%= itemid %>",
	"brand": {
		"@type": "Brand",
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

<%' 2017서울가요대상 파라메터 저장(2017.12.07) %>
<script type="text/javascript" src="/event/etc/focusm/sma.js"></script>
<script type="text/javascript">
window.onload = function(){
	var oSMA = SMAParam;
	oSMA.setParam();
}
</script>

<%' 에코마케팅용 레코벨 스크립트 삽입(2016.12.21) %>
<script type="text/javascript">
  window._rblq = window._rblq || [];
  _rblq.push(['setVar','cuid','0f8265c6-6457-4b4a-b557-905d58f9f216']);
  _rblq.push(['setVar','device','MW']);
  _rblq.push(['setVar','itemId','<%=itemid%>']);
//  _rblq.push(['setVar','userId','{$userId}']); // optional
  _rblq.push(['setVar','searchTerm','<%=vPrtr%>']);
  _rblq.push(['track','view']);
  (function(s,x){s=document.createElement('script');s.type='text/javascript';
  s.async=true;s.defer=true;s.src=(('https:'==document.location.protocol)?'https':'http')+
  '://assets.recobell.io/rblc/js/rblc-apne1.min.js';
  x=document.getElementsByTagName('script')[0];x.parentNode.insertBefore(s, x);})();
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
