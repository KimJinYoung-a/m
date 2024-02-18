<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  비트윈 카테고리 뷰
' History : 2014.04.18 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
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

<%
dim itemid	: itemid = requestCheckVar(request("itemid"),9)
Dim page, vDisp, btvDisp
	btvDisp = requestCheckVar(request("dispCate"),15)


'// 카테고리 코드가 없으면 itemid값을 기준으로 카테고리값 가져옴
If Trim(btvDisp)="" Or Len(btvDisp)=0 Then
	btvDisp = getCategoryVal(itemid)
End If 



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
end If

Dim LoginUserid
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
dim ioptionLayerBoxHtml '//레이어용 추가 2014-04-21 이종화
IF (oitem.Prd.FOptionCnt>0) then
	if (IsReceiveSiteItem) or (IsPresentItem) or (IsTicketItem) then
		ioptionLayerBoxHtml = GetOptionBoxDpLimitHTML(itemid, oitem.Prd.IsSoldOut,Not(IsReceiveSiteItem) and Not(IsPresentItem and oItem.Prd.FRemainCount>200) and Not(IsTicketItem and oItem.Prd.FRemainCount>100 ))
	else
	    ioptionLayerBoxHtml = GetBetweenLayerBoxHTML(itemid, oitem.Prd.IsSoldOut)
	end if
End If


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
SET cTalk = New CGiftTalk
cTalk.FPageSize = 5
cTalk.FCurrpage = 1
cTalk.FRectItemId = itemid
cTalk.FRectUseYN = "y"
cTalk.FRectOnlyCount = "o"
'cTalk.sbGiftTalkList
'vTalkCount = cTalk.FTotalCount

If IsUserLoginOK Then
	cTalk.FPageSize = 2
	cTalk.FRectUserId = GetLoginUserID()
	'cTalk.fnGiftTalkMyItemList
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


'// 비트윈 전용 itemid로 상품 카테고리값 가져오기
Function getCategoryVal(itemid)
	Dim sqlStr
	sqlStr = "Select top 1 catecode From  "
	sqlStr = sqlStr + " [db_etcmall].[dbo].tbl_between_cate_item"
	sqlStr = sqlStr + " where itemid='" + Trim(CStr(itemid)) + "' "

	rsget.Open sqlStr,dbget,1
	if Not rsget.Eof then
		getCategoryVal = rsget(0)
	Else
		getCategoryVal = "101"
	End If
	rsget.Close
End Function

%>
<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
<script type="application/x-javascript" src="/apps/appCom/between/lib/js/itemPrdDetail.js"></script>
<script type="application/x-javascript" src="/apps/appCom/between/lib/js/shoppingbag_script.js?v=1.1"></script>
<script>

	function optHCtrl(){
		var optH = $('.pdtOptBox').height();
		$('.floatingBar .inner').css('padding-top',optH+24);
	}

	function jsClearArea(){
		sbagfrm.requiredetail.value = "";
	}


	function jsItemea(plusminus)
	{
		var v = parseInt(sbagfrm.itemea.value);
		var v2 = parseInt($("#itemea2").text());

		if(plusminus == "+")
		{
			v = v + 1;
			v2 = v2 + 1;
		}
		else if(plusminus == "-")
		{
			if(v > 1)
			{
				v = v - 1;
				v2 = v2 - 1;
			}
			else
			{
				v = 1;
				v2 = 1;
			}
		}
		sbagfrm.itemea.value = v;
//			parseInt($("#itemea2").text(v2));
	}



	function goItemOptionChg(itindex)
	{
		alert(itindex);
	}

	$(function() {

		//상품 고시정보 더 보기 버튼 컨트롤
		$('.productSpec .extendBtn').click(function(){
			$('.productSpec > ul').toggleClass('extend');
			$(this).toggleClass('cut');
			if ($(this).hasClass('cut')) {
				$(this).html('상품 고시정보 닫기');
			} else {
				$(this).html('상품 고시정보 더보기');
			}
		});

		//상품 이미지 롤링
		var mySwiper = new Swiper('.pdtBigImg .swiper-container',{
			<% if Not(isNull(oItem.Prd.FImageMask) or oItem.Prd.FImageMask="") Or oAdd.FResultCount > 0  Then %>
				pagination:'.pagination',
			<% else %>
				pagination:'',
			<% end if %>
			paginationClickable:true,
			loop:true,
			resizeReInit:true,
			calculateHeight:true
		});

		//상품 상세 탭 컨트롤
		$('.detailCont').hide();
		$('#detail01').show();
		$('.detailTab li').click(function() {
			$('.detailTab li').removeClass('selected');
			$(this).addClass('selected');
			$('.detailTab li').children('p').css('border-right','1px solid #fff');
			$(this).prev().children('p').css('border-right','0');
			var tabView = $(this).attr('name');
			$(".detailCont").hide();
			$("[class|='detailCont'][id|='"+ tabView +"']").show();
		});

		//하단 플로팅바 컨트롤
		$(".floatingHandler").click(function(){
			if ($('.pdtOptBox').is(":hidden")) {
				$('.pdtOptBox').show();
				var optH = $('.pdtOptBox').outerHeight();
				$('.floatingBar .inner').css('padding-top',optH);
				$('.floatingWrap').show();
			} else {
				$('.floatingBar .inner').css('padding-top',0);
				$('.pdtOptBox').hide();
				$('.floatingWrap').hide();
			}
			//옵션닫기
			$(".floatingWrap").click(function(){
				$('.floatingBar .inner').css('padding-top',0);
				$('.pdtOptBox').hide();
				$('.floatingWrap').hide();
				$(".optForm dd").hide();
				$(".optForm dt").removeClass("over");
			});
		});

		var vSpos, vChk;
		$(window).on({
			'touchstart': function(e) {
				vSpos = $(window).scrollTop()
				vChk = false;
			}, 'touchmove': function(e) {
				if(vSpos!=$(window).scrollTop()) {
					$('.floatingBar').css('display','none');
					vChk = true;
				}
			}, 'touchend': function(e) {
				if(vChk) $('.floatingBar').fadeIn("fast");
			}
		});

		$(".optForm dt").click(function(){
			if($(this).parent().children('dd').is(":hidden")){
				$(".optForm dd").hide();
				$(".optForm dt").removeClass("over");
				$(this).parent().children('dd').show();
				$(this).addClass("over");
				//옵션선택
				$(".optForm dd li").click(function(e){
					$(this).className="selected";
					e.preventDefault();
					var evtName = $(this).text();
					$(".optForm dt").removeClass("over");
					$(this).parent().parent().hide();
					$(this).parent().parent().parent().children('dt').text(evtName);
				});
			} else {
				$(this).parent().children('dd').hide();
				$(this).removeClass("over");
			};
			$(".oderNum").click(function(){
				if($(".optForm dd").is(":visible")){
					$(".optForm dd").hide();
					$(".optForm dt").removeClass("over");
				};
			});
		});


		$(".optForm dd li").click(function(e){

			var Sid;
			var Svalue;
			Sid = $(this).attr('value');
			Svalue = $(this).attr('value2');
			$(this).className="selected";
			alert($(this).text());
//			alert(e.form);
//			$("#"+Sid+"").val(Svalue);

//			CheckMultiLi(Sid,"","");

			CheckMultiLi(Sid, Svalue, "item_option", e);


		});


	});


	function fnMoreItemDesc(elm) {
		document.getElementById("detail_list").contentWindow.location.replace("/apps/appcom/wish/webview/category/incItemDetail.asp?itemid=<%=itemid%>");
		$("#lyLoading").delay(1500).fadeOut();
		//상품 상세정보 보기 버튼 컨트롤
		$('.detailView > div').toggleClass('extend');
		$(elm).toggleClass('cut');
		if ($(elm).hasClass('cut')) {
			$(elm).html('상품 상세정보 닫기');
		} else {
			$(elm).html('상품 상세정보 보기');
		}
	}
	
// 장바구니에 상품을 담기 
function TnAddShoppingBag_v2(bool){
    var frm = document.sbagfrm;
    var optCode = "0000";

    var MOptPreFixCode="Z";

    if (!frm.itemea.value){
		alert('장바구니에 넣을 수량을 입력해주세요.');
		frm.itemea.focus();
		return;
	} else {
	    for (var j=0; j < frm.itemea.value.length; j++){
	        if (((frm.itemea.value.charAt(j) * 0 == 0) == false)||(frm.itemea.value==0)){
	    		alert('수량은 숫자만 가능합니다.');
	    		frm.itemea.focus();
	    		return;
	    	}
	    }
	}

    if (!frm.item_option){
        //옵션 없는경우

    }else if (!frm.item_option[0].length){
        //단일 옵션
        if (frm.item_option.value.length<1){
            alert('옵션을 선택 하세요.');
			$('.pdtOptBox').show();
			var optH = $('.pdtOptBox').outerHeight();
			$('.floatingBar .inner').css('padding-top',optH);
			$('.floatingWrap').show();
            frm.item_option.focus();
            return;
        }

        if (frm.item_option.options[frm.item_option.selectedIndex].id=="S"){
            alert('품절된 옵션은 구매하실 수 없습니다.');
            frm.item_option.focus();
            return;
        }

        optCode = frm.item_option.value;
    }else{
        //이중 옵션 경우

        for (var i=0;i<frm.item_option.length;i++){
            if (frm.item_option[i].value.length<1){
                alert('옵션을 선택 하세요.');
				$('.pdtOptBox').show();
				var optH = $('.pdtOptBox').outerHeight();
				$('.floatingBar .inner').css('padding-top',optH);
				$('.floatingWrap').show();
                frm.item_option[i].focus();
                return;
            }

            if (frm.item_option[i].options[frm.item_option[i].selectedIndex].id=="S"){
                alert('품절된 옵션은 구매하실 수 없습니다.');
                frm.item_option[i].focus();
                return;
            }

            if (i==0){
                optCode = MOptPreFixCode + frm.item_option[i].value.substr(1,1);
            }else if (i==1){
                optCode = optCode + frm.item_option[i].value.substr(1,1);
            }else if (i==2){
                optCode = optCode + frm.item_option[i].value.substr(1,1);
            }
        }

        if (optCode.length==2){
            optCode = optCode + "00";
        }

        if (optCode.length==3){
            optCode = optCode + "0";
        }
    }

    frm.itemoption.value = optCode;

    if (frm.requiredetail){
		if (frm.requiredetail.value == "문구를 입력해 주세요."){
			frm.requiredetail.value = "";
		}

		if (frm.requiredetail.value.length<1){
			alert('주문 제작 상품 문구를 작성해 주세요.');
			$('.pdtOptBox').show();
			var optH = $('.pdtOptBox').outerHeight();
			$('.floatingBar .inner').css('padding-top',optH);
			$('.floatingWrap').show();
			frm.requiredetail.focus();
			return;
		}


		if(GetByteLength(frm.requiredetail.value)>255){
			alert('문구 입력은 한글 최대 120자 까지 가능합니다.');
			frm.requiredetail.focus();
			return;
		}
	}

    if (bool==true){
        frm.action = "/apps/appCom/between/inipayV2/shoppingbag_process.asp?tp=pop";
        frm.mode.value="add";
        frm.target = "iiBagWin";
        frm.submit();
    }else{
        frm.target = "_self";
        frm.mode.value="DO1";
    	frm.action="/apps/appCom/between/inipayV2/shoppingbag_process.asp";
    	frm.submit();
    }

}

</script>
</head>
<body>
<% 'for dev msg : 원뎁스별 해당 ID 추가(비트윈추천:btwRcmd/카테고리:btwCtgy/마이페이지:btwMypage) %>
<div class="wrapper pdtDetail" id="btwCtgy">
	<div id="content">
		<div class="cont">
			<div class="pdtBigImg">
				<div class="swiper-container pdtBigImg">
					<div class="swiper-wrapper">
						<%
						'//기본 이미지
						Response.Write "<div class=""swiper-slide""><img src=""" & oItem.Prd.FImageBasic & """ alt=""" & oItem.Prd.FItemName & """ style=""width:100%;"" /></div>"
						'//누끼 이미지
						if Not(isNull(oItem.Prd.FImageMask) or oItem.Prd.FImageMask="") then
							Response.Write "<div class=""swiper-slide""><img src=""" & oItem.Prd.FImageMask & """ alt=""" & oItem.Prd.FItemName & """ style=""width:100%;"" /></div>"
						end if
						'//추가 이미지
						IF oAdd.FResultCount > 0 THEN
							FOR i= 0 to oAdd.FResultCount-1
								'If i >= 3 Then Exit For
								IF oAdd.FADD(i).FAddImageType=0 THEN
									Response.Write "<div class=""swiper-slide""><img src=""" & oAdd.FADD(i).FAddimage & """ alt=""" & oItem.Prd.FItemName & """ style=""width:100%;"" /></div>"
								End IF
							NEXT
						END IF
						%>
					</div>
					<div class="pagination"></div>
				</div>
			</div>
			<div class="inPad01">
				<div class="pdtInfo boxMdl">
					<h1><p class="pdtName"><%=oItem.Prd.FItemName %></p></h1>
					<p class="pdtBrand"><%=oItem.Prd.FBrandName%></p>
					<% '2014-11-12 김진영 운영서버에 업데이트시 코딩 확인 %>
					<div class="price">
						<% IF oItem.Prd.IsSaleItem THEN %>						
							<div><del><%= FormatNumber(oItem.Prd.getOrgPrice,0) %><% if oItem.Prd.IsMileShopitem then %> Point<% else %> 원<% end  if %></del></div>
							<div>
								<span class="txtSaleRed"><%= FormatNumber(oItem.Prd.getRealPrice,0) %> 원</span> 
								<p class="pdtTag saleRed"><% = oItem.Prd.getSalePro %></p>
						<% Else %>
							<div>
								<%= FormatNumber(oItem.Prd.getOrgPrice,0) %><% if oItem.Prd.IsMileShopitem then %> Point<% else %> 원<% end  if %>
						<% End If %>
						<% IF oItem.Prd.IsSoldOut Then %>
							<% 'for dev msg : 품절일때 노출 %>
								<p class="pdtTag soldOut">품절</p>
							</div>
						<% Else %>
							</div>
						<% End If %>
						<span class="btnShare"><a href="" onclick="jsOpenPopup('/apps/appCom/between/common/shareItem.asp?itemid=<%=itemid%>&itemname=<%= oItem.Prd.FItemName %>&sendImg=<%=oItem.Prd.FImageBasic%>');return false;">공유하기</a></span>
					<% '2014-11-12 김진영 운영서버에 업데이트시 코딩 확인 %>
					</div>
					<% IF (oItem.Prd.isLimitItem) and (not (oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut)) and (Not IsReceiveSiteItem) and Not(IsPresentItem and oItem.Prd.FRemainCount>200 ) and Not(IsTicketItem and oItem.Prd.FRemainCount>100 ) Then %>
						<p class="pdtLimit">한정수량 <strong class="txtBlk"><% = oItem.Prd.FRemainCount %>개</strong> 남았습니다.</p>
					<% end if %>	
				</div>
				<div class="pdtContWrap">
					<ul class="detailTab boxMdl">
						<li class="detail01 selected" name="detail01"><p>상품설명</p></li>
						<li class="detail02" name="detail02"><p>배송/교환/환불규정</p></li>
						<li class="detail03" name="detail03"><p>고객센터</p></li>
					</ul>
					<div class="detailCont" id="detail01">
						<p class="txtBlk">
							<strong>상품코드 : <%=itemid%></strong>
							<% if oItem.Prd.IsAboardBeasong then %>
								<% if oItem.Prd.IsFreeBeasong then %>
									[텐바이텐 무료배송+해외배송]
								<% Else %>
									[텐바이텐배송+해외배송]
								<% End If %>
							<% elseif IsPresentItem then %>
								[<% = oItem.Prd.GetDeliveryName %>]
							<% else %>
								[<% = oItem.Prd.GetDeliveryName %>]
							<% End If %>
						</p>
						<dl class="detailShort" >
							<dt>상품상세 정보</dt>
							<dd class="detailInfo" >
								<div class="detailView">
									<div id="lyLoading" style="position:relative; text-align:center; margin-left:-8px;">
										<img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px; heigth:16px" />
									</div>
									<div>
										<iframe src="about:blank" id="detail_list" title="detail_list" width="100%" height="100%" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" class="autoheight"></iframe>
									</div>
									<p class="extendBtn" onclick="fnMoreItemDesc(this)">상품 상세정보 보기</p>
								</div>
							</dd>
						</dl>
						<% IF Not(oItem.Prd.FOrderComment="" or isNull(oItem.Prd.FOrderComment)) or Not(oItem.Prd.getDeliverNoticsStr="" or isNull(oItem.Prd.getDeliverNoticsStr)) THEN %>
							<dl class="detailShort">
								<dt>주문시 유의사항</dt>
								<dd>
									<div class="inPad01 gry243">
										<%= oItem.Prd.getDeliverNoticsStr %> <%= nl2br(oItem.Prd.FOrderComment) %>
									</div>
								</dd>
							</dl>
						<% End If %>
						<% If (Not IsTicketItem) Then '// 티켓아닌경우 - 일반상품 %>
							<div class="productSpec">
								<h3>상품 고시정보</h3>
								<ul class="inPad01 gry243">
									<%
										IF addEx.FResultCount > 0 THEN
											FOR i= 0 to addEx.FResultCount-1
												If addEx.FItem(i).FinfoCode = "35005" Then
													If tempsource <> "" then
													response.write "<li><span class=""txtBlk"">재질 | </span>"&tempsource&" </li>"
													End If
													If tempsize <> "" then
													response.write "<li><span class=""txtBlk"">사이즈 | </span>"&tempsize&" </li>"
													End If
												End If
									%>
										<li style="display:<%=chkiif(addEx.FItem(i).FInfoContent="" And addEx.FItem(i).FinfoCode ="02004" ,"none","")%>;"><span class="txtBlk"><%=addEx.FItem(i).FInfoname%> | </span><%=addEx.FItem(i).FInfoContent%></li>
									<%
											Next
										End If
									%>
									<% if oItem.Prd.IsSafetyYN then %>
										<li><span class="txtBlk">안전인증대상 | </span><%=oItem.Prd.FsafetyNum%></li>
									<% End If %>
									<% if oItem.Prd.IsAboardBeasong then %>
										<li><span class="txtBlk">해외배송 기준 중량 | </span><% = formatNumber(oItem.Prd.FitemWeight,0) %> g (1차 포장을 포함한 중량)</li>
									<% End If %>
								</ul>
							<% Else %>
								<div class="productSpec">
									<h3>상품 고시정보</h3>
									<ul class="inPad01 gry243">
										<li><span class="txtBlk">장르 | </span><%=oTicket.FOneItem.FtxGenre%></li>
										<li><span class="txtBlk">일시 | </span><%= FormatDate(oTicket.FOneItem.FstDt,"0000.00.00") %>~<%=	FormatDate(oTicket.FOneItem.FedDt,"0000.00.00") %></li>
										<li><span class="txtBlk">장소 | </span><%=oTicket.FOneItem.FticketPlaceName%></li>
										<li><span class="txtBlk">관람등급 | </span><%=oTicket.FOneItem.FtxGrade%></li>
										<li><span class="txtBlk">관람시간 | </span><%=oTicket.FOneItem.FtxRunTime%></li>
									</ul>
								</div>
							<% End If %>
							<p class="extendBtn">상품 고시정보 더보기</p>
						</div>
					</div>

					<div class="detailCont" id="detail02">
						<dl class="detailShort">
							<dt>배송정보</dt>
							<dd class="inPad01 gry243">
								<ul class="txtList01 txtBlk">
									<li>배송기간은 주문일(무통장입금은 결제완료일)로부터 1일(24시간) ~ 5일정도 걸립니다.</li>
									<li>업체배송 상품은 무료배송 되며, 업체조건배송 상품은 특정 브랜드 배송 기준으로 배송비가 부여되며 업체착불배송은 특정 브랜드 배송기준으로 고객님의 배송지에 따라 배송비가 착불로 부과됩니다.</li>
									<li>제작기간이 별도로 소요되는 상품의 경우에는 상품설명에 있는 제작기간과 배송시기를 숙지해 주시기 바랍니다.</li>
									<li>가구 등의 상품의 경우에는 지역에 따라 추가 배송비용이 발생할 수 있음을 알려드립니다.</li>
								</ul>
							</dd>
						</dl>
						<dl class="detailShort">
							<dt>교환/환불/AS 안내</dt>
							<dd class="inPad01 gry243">
								<ul class="txtList01 txtBlk">
									<li>상품 수령일로부터 7일 이내 반품/환불 가능합니다.</li>
									<li>변심 반품의 경우 왕복배송비를 차감한 금액이 환불되며, 제품 및 포장 상태가 재판매 가능하여야 합니다.</li>
									<li>상품 불량인 경우는 배송비를 포함한 전액이 환불됩니다.</li>
									<li>출고 이후 환불요청 시 상품 회수 후 처리됩니다.</li>
									<li>주문제작(쥬얼리 포함)/카메라/밀봉포장상품/플라워 등은 변심으로 반품/환불 불가합니다.</li>
									<li>완제품으로 수입된 상품의 경우 A/S가 불가합니다.</li>
									<li>특정브랜드의 교환/환불/AS에 대한 개별기준이 상품페이지에 있는 경우 브랜드의 개별기준이 우선 적용 됩니다.</li>
								</ul>
							</dd>
						</dl>
						<dl class="detailShort">
							<dt>기타 기준사항</dt>
							<dd class="inPad01 gry243">
								<ul class="txtList01 txtBlk">
									<li>구매자가 미성년자인 경우에는 상품 구입시 법정대리인이 동의하지 아니하면 미성년자 본인 또는 법정대리인이 구매취소 할 수 있습니다.</li>
								</ul>
							</dd>
						</dl>
					</div>

					<div class="detailCont" id="detail03">
						<div class="tenCs">
							<p><strong>텐바이텐 고객행복센터</strong></p>
							<p class="csTel"><strong><a href="tel:1644-6030">1644-6030</a></strong></p>
							<p class="csMail"><strong><a href="mailto:between@10x10.co.kr">between@10x10.co.kr</a></strong></p>
							<p><strong>AM 09:00 ~ PM 06:00</strong><br />(점심시간 : PM 12:00 ~ 01:00)<br />토, 일, 공휴일 휴무</p>
						</div>
					</div>
				</div>
			</div>

			<div class="ctgyBest">
				<h2><strong>카테고리 베스트</strong></h2>
				<ul class="pdtList list01 boxMdl">
					<%=oItem.getBetweenCateBest(btvDisp, itemid) %>
				</ul>
				<!--<span class="moreBtn"><a href="category_list.asp?disp=<%=btvDisp%>&cv=1">더보기</a></span>-->
			</div>

			<!--<div class="inPad01 ltGry">
				<table class="tbl ctgyList">
					<colgroup>
						<col width="25%" /><col width="25%" /><col width="25%" /><col width="25%" />
					</colgroup>
					<tbody>
						<tr>
							<td <% If btvDisp="" Or btvDisp="101" Then %> class="on"<% End If %>><a href="category_list.asp?disp=101&cv=1">커플</a></td>
							<td <% If btvDisp="102" Then %> class="on"<% End If %>><a href="category_list.asp?disp=102&cv=1">소품/취미</a></td>
							<td <% If btvDisp="103" Then %> class="on"<% End If %>><a href="category_list.asp?disp=103&cv=1">디지털</a></td>
							<td <% If btvDisp="104" Then %> class="on"<% End If %>><a href="category_list.asp?disp=104&cv=1">키친/푸드</a></td>
						</tr>
						<tr>
							<td <% If btvDisp="105" Then %> class="on" <% End If %>><a href="category_list.asp?disp=105&cv=1">패션</a></td>
							<td <% If btvDisp="106" Then %> class="on" <% End If %>><a href="category_list.asp?disp=106&cv=1">뷰티</a></td>
							<td <% If btvDisp="107" Then %> class="on" <% End If %>><a href="category_list.asp?disp=107&cv=1">SALE</a></td>
							<td></td>
						</tr>
					</tbody>
				</table>
			</div>-->
		</div>

		<form name="sbagfrm" method="post" action="" style="margin:0px;" onsubmit="return false;">
		<input type="hidden" name="mode" value="add" />
		<input type="hidden" name="itemid" value="<% = oitem.Prd.FItemid %>" />
		<input type="hidden" name="itemoption" value="" />
		<input type="hidden" name="isPresentItem" value="<%= isPresentItem %>" />

		<div class="floatingBar boxMdl cartIn <% If oItem.Prd.IsSoldOut Then %><% Else %>optIs<% End If %>">
			<div class="inner">
				<div class="btnWrap">
					<% IF oItem.Prd.IsSoldOut Then %>
						<p class="btn01 btnSoldOut"><span class="cnclGry">품절</span></p>
					<% Else %>
						<p class="btn01 btnCart"><a href="javascript:TnAddShoppingBag_v2(true);" class="btw">장바구니<em id="lyrCartCnt" class="newIco tenRed" <%=chkIIF(GetBetweenCartCount>0,"","style=""display:none;""")%>><%=GetBetweenCartCount()%></em></a></p>
						<p class="btn01 btnOrder"><a href="javascript:TnAddShoppingBag_v2(false);" class="edwPk">구매하기</a></p>
					<% End If %>
				</div>
				<% IF oItem.Prd.IsSoldOut Then %>
				<% Else %>
					<div class="pdtOptBox">
						<div class="itemoption">
							<% if oItem.Prd.FItemDiv = "06" then %>
								<p class="copyInput">
									<textarea name="requiredetail" id="requiredetail"  onClick="jsClearArea();" placeholder="문구를 입력해주세요."></textarea>
								</p>
							<% End If %>								
							<% If oItem.Prd.FOptionCnt>0 Then %>								
								<%=ioptionLayerBoxHtml%>
							<% End If %>
						</div>
						<div class="oderNum">
							<% if IsPresentItem then %>
								<span class="down" onClick="alert('한번에 하나씩만 구매가능합니다.');">-</span>
								<span class="up" onclick="alert('한번에 하나씩만 구매가능합니다.');">+</span>
								<input type="text" class="numInput" name="itemea" value="1" />
							<% Else %>
								<span class="down" onClick="jsItemea('-');return false;">-</span>
								<span class="up" onclick="jsItemea('+');return false;">+</span>
								<input type="text" class="numInput" name="itemea" value="1" />
							<% End If %>
						</div>
					</div>
					<!-- //for dev msg : 옵션이 있는 경우 노출 -->
				<% End If %>
			</div>
			<span class="floatingHandler">열기</span>
			<div class="floatingWrap"></div>
		</div>
		</form>
		<iframe src="" name="iiBagWin" frameborder="0" width="0" height="0"></iframe>
	</div>
	<!-- #include virtual="/apps/appCom/between/libV2/inc/incFooter.asp" -->
</div>
<script language="JavaScript" type="text/javascript" SRC="/lib/js/todayview.js"></script>
<script type="text/javascript" src="/lib/js/jquery.iframe-auto-height.js"></script>
<div id="modalCont" class="lyrPopWrap boxMdl midLyr" style="display:none;"></div>
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