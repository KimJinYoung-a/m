<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.Charset ="UTF-8"
%>
<!-- #include virtual="/apps/appcom/wish/web2014/login/checkBaguniLogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbhelper.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_itemcouponcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_couponcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_mileageshopitemcls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/classes/item/itemOptionCls.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/emscls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<%
Const CnPls = 3 ''201712 추가 조건배송 이후에 경우의 수가 더 생기면 늘릴것
Dim ISQuickDlvUsing : ISQuickDlvUsing=False  ''바로배송 사용여부
if (TRUE) or (getLoginUserLevel()="7") then ISQuickDlvUsing=True ''우선 직원만 테스트

'// 바로배송 종료에 따른 처리
If now() > #07/31/2019 12:00:00# Then
	ISQuickDlvUsing = FALSE
End If

''만료된 페이지 관련..

'' 사이트 구분
Const sitename = "10x10"
'' 마일리지샵 가능 여부
Dim IsMileShopEnabled : IsMileShopEnabled = true

'' 레코벨에 보낼 ItemId값
Dim RecoBellSendItemId : RecoBellSendItemId = ""

''계속 쇼핑하기 URL
dim LastShoppingUrl
LastShoppingUrl = getPreShoppingLocation()


dim userid, guestSessionID, isBaguniUserLoginOK
userid = GetLoginUserID
guestSessionID = GetGuestSessionKey
If IsUserLoginOK() Then
	isBaguniUserLoginOK = true
else
	isBaguniUserLoginOK = false
end if

Dim bTp : bTp = request("bTp")  ''장바구니 구분
Dim IsForeignDlv : IsForeignDlv = (bTp="f")           ''해외 배송 여부
Dim IsArmyDlv    : IsArmyDlv = (bTp="a")              ''군부대 배송 여부
Dim IsQuickDlv    : IsQuickDlv = (bTp="q")            ''퀵 배송 여부
Dim IsLocalDlv   : IsLocalDlv = (NOT IsForeignDlv) and (NOT IsArmyDlv) and (NOT IsQuickDlv)

dim chKdp, itemid, itemoption, itemea, requiredetail, sBagCount
chKdp		= requestCheckVar(request.Form("chKdp"),10)
itemid      = requestCheckVar(request.Form("itemid"),9)
itemoption  = requestCheckVar(request.Form("itemoption"),4)
itemea      = requestCheckVar(request.Form("itemea"),9)
requiredetail = request.Form("requiredetail")

if Not(IsLocalDlv) then IsMileShopEnabled = FALSE

dim oShoppingBag
set oShoppingBag = new CShoppingBag
oShoppingBag.FRectUserID    = userid
oshoppingbag.FRectSessionID = guestSessionID
oShoppingBag.FRectSiteName  = sitename

''위치변경 2013/09/12
if (IsForeignDlv) then
    oshoppingbag.FcountryCode = "AA"
elseif (IsArmyDlv) then
    oshoppingbag.FcountryCode = "ZZ"
elseif (IsQuickDlv) then
    oshoppingbag.FcountryCode = "QQ"
end if

''쇼핑백 내용 쿼리
oshoppingbag.GetShoppingBagDataDB

sBagCount = oshoppingbag.FShoppingBagItemCount


''마일리지 및 쿠폰 정보
dim availtotalMile
dim oSailCoupon, oItemCoupon, oMileage

availtotalMile = 0

'// 마일리지 정보
set oMileage = new TenPoint
oMileage.FRectUserID = userid
if (userid<>"") then
    oMileage.getTotalMileage
    availtotalMile = oMileage.FTotalMileage
end if

if availtotalMile<1 then availtotalMile=0


'// 할인권정보
set oSailCoupon = new CCoupon
oSailCoupon.FRectUserID = userid
oSailCoupon.FPageSize=100

if (userid<>"") then
	oSailCoupon.getValidCouponList
end if

'' (%) 보너스쿠폰 존재여부 - %할인쿠폰이 있는경우만 [%할인쿠폰제외상품]표시하기위함
dim intp, IsPercentBonusCouponExists
IsPercentBonusCouponExists = false
for intp=0 to oSailCoupon.FResultCount-1
    if (oSailCoupon.FItemList(intp).FCoupontype=1) then
        IsPercentBonusCouponExists = true
        Exit for
    end if
next

'// 쿠폰 정보
set oItemCoupon = new CUserItemCoupon
oItemCoupon.FRectUserID = userid
oItemCoupon.FPageSize=100

if (userid<>"") then
	oItemCoupon.getValidItemCouponListInBaguni  ''2018/10/22
end if

'' 상품 쿠폰 적용. //201204추가 === 쿠폰 적용가를 구하기 위함.
dim IsItemFreeBeasongCouponExists
IsItemFreeBeasongCouponExists = false
for i=0 to oItemCoupon.FResultCount-1
	if oshoppingbag.IsCouponItemExistsByCouponIdx(oItemCoupon.FItemList(i).Fitemcouponidx) then
		oshoppingbag.AssignItemCoupon(oItemCoupon.FItemList(i).Fitemcouponidx)

		if (oshoppingbag.IsCouponItemExistsByCouponIdx(oItemCoupon.FItemList(i).Fitemcouponidx)) and (oitemcoupon.FItemList(i).IsFreeBeasongCoupon) then
		    IsItemFreeBeasongCouponExists = true
		end if
	end if
next

'// 마일리지 샾 상품
dim oMileageShop

set oMileageShop = new CMileageShop
oMileageShop.FPageSize=30

if (IsMileShopEnabled) and (userid<>"") then
    oMileageShop.GetMileageShopItemList
end if

dim iCols, iRows
iCols=5
iRows = CLng(oMileageShop.FResultCount \ iCols)

if (oMileageShop.FResultCount mod iCols)>0 then
	iRows = iRows + 1
end if

''===EMS 관련============
Dim oems : SET oems = New CEms
Dim oemsPrice : SET oemsPrice = New CEms
if (IsForeignDlv) then
    oems.FRectCurrPage = 1
    oems.FRectPageSize = 200
    oems.FRectisUsing  = "Y"
    oems.GetServiceAreaList

    oemsPrice.FRectWeight = oshoppingbag.getEmsTotalWeight
    oemsPrice.GetWeightPriceListByWeight
end if

''포토북 편집 안한상품 존재
dim NotEditPhotobookExists
NotEditPhotobookExists = False
''주문제작 상품 문구 적지 않은 상품
dim NotWriteRequireDetailExists
dim i, j, idx
i=0
idx=0

dim optionBoxHtml

'' OldType Option Box를 한 콤보로 표시
function getOneTypeOptionBoxHtmlMile(byVal iItemID, byVal isItemSoldOut, byval iOptionBoxStyle)
	dim i, optionHtml, optionTypeStr, optionKindStr, optionSoldOutFlag, optionSubStyle
    dim oItemOption

	set oItemOption = new CItemOption
    oItemOption.FRectItemID = iItemID
    oItemOption.FRectIsUsing = "Y"
    oItemOption.GetOptionList

    if (oItemOption.FResultCount<1) then Exit Function

    optionTypeStr = oItemOption.FItemList(0).FoptionTypeName
    if (Trim(optionTypeStr)="") then
        optionTypeStr = "옵션 선택"
    else
        optionTypeStr = optionTypeStr + " 선택"
    end if

	optionHtml = "<select name='item_option_"&iItemID&"' " + iOptionBoxStyle + ">"
    optionHtml = optionHtml + "<option value='' selected>" & optionTypeStr & "</option>"


    for i=0 to oItemOption.FResultCount-1
	    optionKindStr       = oItemOption.FItemList(i).FOptionName
	    optionSoldOutFlag   = ""

		if (oItemOption.FItemList(i).IsOptionSoldOut) then optionSoldOutFlag="S"

		''품절일경우 한정표시 안함
    	if ((isItemSoldOut) or (oItemOption.FItemList(i).IsOptionSoldOut)) then
    		optionKindStr = optionKindStr + " (품절)"
    		optionSubStyle = "style='color:#DD8888'"
    	else
    	    if (oitemoption.FItemList(i).Foptaddprice>0) then
    	    '' 추가 가격
    	        optionKindStr = optionKindStr + " (" + FormatNumber(oitemoption.FItemList(i).Foptaddprice,0)  + "원 추가)"
    	    end if

    	    if (oitemoption.FItemList(i).IsLimitSell) then
    		''옵션별로 한정수량 표시
    			optionKindStr = optionKindStr + " (한정 " + CStr(oItemOption.FItemList(i).GetOptLimitEa) + " 개)"
        	end if
        	optionSubStyle = ""
        end if

        optionHtml = optionHtml + "<option id='" + optionSoldOutFlag + "' " + optionSubStyle + " value='" + oItemOption.FItemList(i).FitemOption + "'>" + optionKindStr + "</option>"
	next

    optionHtml = optionHtml + "</select>"

	getOneTypeOptionBoxHtmlMile = optionHtml
	set oItemOption = Nothing
end function

Dim iTicketItemCNT : iTicketItemCNT = 0
Dim oTicketItem, TicketBookingExired : TicketBookingExired=FALSE

Dim iPresentItemCNT : iPresentItemCNT = 0

Dim eachCnt : eachCnt = 0 ''//각 개별 카운트

'품절을 제외한 장바구니 전체 상품수
Dim r, iTotalItemCount: iTotalItemCount=0
If oshoppingbag.FShoppingBagItemCount > 0 Then
	For r = 0 to oshoppingbag.FShoppingBagItemCount -1
		if Not(oshoppingbag.FItemList(r).ISsoldOut) then
			iTotalItemCount = iTotalItemCount+1
		end if
	Next
End If

'// 구글 ADS 스크립트 관련(2017.05.29 원승현 추가)
Dim ADSItem
If oshoppingbag.FShoppingBagItemCount > 0 Then
	For r = 0 to oshoppingbag.FShoppingBagItemCount -1
		ADSItem = ADSItem &"'"&oshoppingbag.FItemList(r).FItemID&"',"
	Next
	If ADSItem <> "" Then
		If oshoppingbag.FShoppingBagItemCount > 1 Then
			ADSItem = "["&Left(ADSItem, Len(ADSItem)-1)&"]"
		Else
			ADSItem = Left(ADSItem, Len(ADSItem)-1)
		End If
	End If
End If

''쇼핑백 갯수 처리
if (CStr(GetCartCount)<>CStr(iTotalItemCount)) and not(IsForeignDlv) then
	Call setCartCount(iTotalItemCount)
end if
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/newV15a.css" />
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/shoppingbag_script.js?v=3.4"></script>
<script type="text/javascript" src="/lib/js/itemPrdDetail.js"></script>
	<script>
	var ChkErrMsg;
	var Totalitemcount = <%= oshoppingbag.FShoppingBagItemCount %>;

	// Ajax Item Delete
	function DelItem(idx){
		var frm = document.baguniFrm;
		var vMode, vIid, vOt, vEa = 0;

		vMode = "del";
		if (!frm.itemkey.length){
			vIid = frm.itemid.value;
			vOt = frm.itemoption.value;
		}else{
			vIid = frm.itemid[idx].value;
			vOt = frm.itemoption[idx].value;
		}

		if (confirm('상품을 장바구니에서 삭제 하시겠습니까?')){
			$.ajax({
				url: "/inipay/act_shoppingbag_process.asp",
				type: "POST",
				data: "mode="+vMode+"&itemid="+vIid+"&itemoption="+vOt+"&itemea="+vEa,
				dataType: "text",
				cache: false,
				async: false,
				success: function(message) {
					if(message.substr(0,2)=="OK") {
					    setTimeout(function (){
					        appierProductRemovedFromCart(idx);
					    }, 100);

						if(message.substr(3,message.length)=="0") {
							location.reload();
						} else {
							$("form[name='baguniFrm'] li").eq(idx).fadeOut(0,function(){
								var vMix = $(this).attr("mix");	//그룹코드 접수
								if(vMix>0) {
									// 선택 상품 삭제
									$(this).remove();
									// 그룹상품 내 상품이 없으면 그룹 삭제
									if($("li[mix='"+vMix+"']").length==0) {
										$("#grpCart"+vMix).remove();
										// 업체조건배송 타이틀 추가
										if(!$(".grpPrtTit").length) {
											$(".lyrPrtGrp").first().prepend('<div class="bxLGy2V16a grpTitV16a grpPrtTit"><h2>업체 조건 배송 상품</h2></div>');
										}
									}
								}

								// chk_item값 재지정
								var idx=0;
								$("form[name='baguniFrm'] li input[name='chk_item']").each(function(){
									$(this).val(idx);
									idx++;
								});

								// 장바구니 수 변경
								fnAPPsetCartNum(message.substr(3,message.length));
								
								// 총계 재계산
								fnSelCalculate();
							});
						}
					} else {
						alert("처리중 오류가 발생했습니다.["+message+"]");
					}
				}
				,error: function(err) {
					alert(err.responseText);
				}
			});
		}
	}

	function delSelected(chk){
		var frm = document.baguniFrm;
		var chkExists = false;

		if (chk=="all") {
			$(".cartV16a li input[name='chk_item']:disabled").addClass("chkSoldout").removeAttr("disabled").prop("checked",true);
		}

		if (frm.chk_item){
			if (frm.chk_item.length){
				for(var i=0;i<frm.chk_item.length;i++){
					if (frm.chk_item[i].checked){
						chkExists = true;
						appierProductToBeRemoved(i);
					}
				}
			}else{
				if (frm.chk_item.checked){
					chkExists = true;
				}
			}
		}

		if (!chkExists){
			alert('선택된 상품이 없습니다.');
			$(".chkSoldout").removeClass("chkSoldout").prop("checked",false).attr("disabled","disabled");
			return;
		}

		if (confirm('선택 상품을 장바구니에서 삭제하시겠습니까?')){
		    appierProductListRemovedFromCart();
            setTimeout(function(){
                frm.mode.value='DLARR';
                frm.submit();
            }, 150);
		} else if (chk=="all") {
			$(".chkSoldout").removeClass("chkSoldout").prop("checked",false).attr("disabled","disabled");
			initAppierProductToBeRemovedList();
		}else{
		    initAppierProductToBeRemovedList();
		}
	}

	// Select Box
	function chgEditItem(idx) {
		var frm = document.baguniFrm;
		if($(frm.selEa).eq(idx).val()=="manual") {
			//직접입력 시
			$(frm.selEa).eq(idx).hide();
			$(frm.itemea).eq(idx).show();
		} else {
			//수량 변경 처리
			$(frm.itemea).eq(idx).val($(frm.selEa).eq(idx).val());
			EditItem(idx);
		}
	}

	// Ajax Item Edit
	function EditItem(idx){
		var frm = document.baguniFrm;
		var itemeacomp;
		var maxnoflag;
		var minnoflag;
		var soldoutflag;
		var vMode, vIid, vOt, vEa

		vMode = "edit";
		if (!frm.itemkey.length){
			vIid = frm.itemid.value;
			vOt = frm.itemoption.value;
			vEa = frm.itemea.value;

			itemeacomp = frm.itemea;
			maxnoflag = frm.maxnoflag;
			minnoflag = frm.minnoflag;
			soldoutflag = frm.soldoutflag;
		}else{
			vIid = frm.itemid[idx].value;
			vOt = frm.itemoption[idx].value;
			vEa = frm.itemea[idx].value;

			itemeacomp          = frm.itemea[idx];
			maxnoflag    = frm.maxnoflag[idx];
			minnoflag    = frm.minnoflag[idx];
			soldoutflag         = frm.soldoutflag[idx];
		}

		if (!IsDigit(itemeacomp.value)||(itemeacomp.value.length<1) ) {
		   alert("구매수량은 숫자로 넣으셔야 됩니다.");
		   itemeacomp.focus();
		   return;
		}

		//최대구매수량 체크
		if (itemeacomp.value*1>maxnoflag.value*1){
			alert('한정수량 또는 최대 구매수량 (' + maxnoflag.value + ')개를 초과하여 주문 하실 수 없습니다.');
			itemeacomp.value=maxnoflag.value;
			itemeacomp.focus();
			return;
		}
        //최소구매수량 체크
    	if (itemeacomp.value*1<minnoflag.value*1){
    		alert('최소 구매수량 (' + minnoflag.value + ')개를 이상 주문 하실 수 있습니다..');
    		itemeacomp.value=minnoflag.value;
    		itemeacomp.focus();
    		return;
    	}

		if (itemeacomp.value == "0"){
			if (!confirm('상품을 장바구니에서 삭제 하시겠습니까?')){
				return;
			}
		}

		$.ajax({
			url: "/inipay/act_shoppingbag_process.asp",
			type: "POST",
			data: "mode="+vMode+"&itemid="+vIid+"&itemoption="+vOt+"&itemea="+vEa,
			dataType: "text",
			cache: false,
			async: false,
			success: function(message) {
				if(message=="OK") {
					fnSelCalculate();
				} else {
					alert("처리중 오류가 발생했습니다.["+message+"]");
				}
			}
			,error: function(err) {
				alert(err.responseText);
			}
		});
	}

	function PayNextSelected(jumundiv){
		var frm = document.baguniFrm;
		var nextfrm = document.NextFrm;
		var chkExists = false;
		var mitemExists = false;
		var oitemExists = false;
		var nitemExists = false;
		var d1typExists = false;
		var d2typExists = false;
		var d3typExists = false;
		var titemCount = 0;        //Ticket
		var rstemCount = 0;        //현장수령상품
		var pitemCount = 0;        //Present상품
		var mitemttl = 0;

		if (frm.chk_item){
			if (frm.chk_item.length){
				for(var i=0;i<frm.chk_item.length;i++){
					if (frm.chk_item[i].checked){
						chkExists = true;
						if (frm.mtypflag[i].value=="m"){
							mitemExists = true;
							mitemttl+=frm.isellprc[i].value*1;
						}else if(frm.mtypflag[i].value=="o"){
							oitemExists = true;
						}else if(frm.mtypflag[i].value=="t"){
							titemCount = titemCount+1;
						}else if(frm.mtypflag[i].value=="r"){
							rstemCount = rstemCount+1;
						}else if(frm.mtypflag[i].value=="p"){
							pitemCount = pitemCount+1;
						}else{
							nitemExists = true;
						}

						if ((frm.dtypflag[i].value=="1")&&(frm.mtypflag[i].value!="m")){
							d1typExists = true;
						}else if(frm.dtypflag[i].value=="2"){
							d2typExists = true;
						}else{
							d3typExists = true;
						}

						if (frm.soldoutflag[i].value == "Y"){
							alert('죄송합니다. 품절된 상품은 구매하실 수 없습니다.');
							frm.itemea[i].focus();
							return;
						}

						if (frm.nophothofileflag[i].value=="1"){
							alert('포토북 상품은 편집후 구매 가능합니다.');
							frm.itemea[i].focus();
							return;
						}

						if (frm.itemea[i].value*1>frm.maxnoflag[i].value*1){
							alert('['+frm.itemname[i].value+'] 상품은 한정수량 또는 최대 구매수량 (' + frm.maxnoflag[i].value + ')개를 초과하여 주문 하실 수 없습니다.');
							frm.itemea[i].focus();
							return;
						}
                        if (frm.itemea[i].value*1<frm.minnoflag[i].value*1){
            				alert('최소 구매수량 (' + frm.minnoflag[i].value + ')개 이상 주문 하실 수 있습니다.');
            				frm.itemea[i].focus();
            				return;
            			}

						if ((jumundiv=="f")&&(frm.foreignflag[i].value!='Y')){
							alert('해외 배송이 불가능한 상품이 포함 되어있습니다.');
							if (frm.itemea[i].type=='text'){
								frm.itemea[i].focus();
							}
							return;
						}

						if ((jumundiv=="a")&&(frm.dtypflag[i].value!='1')){
							alert('군부대 배송이 불가능한 상품이 포함 되어있습니다.\n\n군부대 배송은 텐바이텐 배송상품만 가능합니다.');
							if (frm.itemea[i].type=='text'){
								frm.itemea[i].focus();
							}
							return;
						}

					}
				}
			}else{
				if (frm.chk_item.checked){
					chkExists = true;
					if (frm.mtypflag.value=="m"){
						mitemExists = true;
						mitemttl+=frm.isellprc.value*1;
					}

					if (frm.soldoutflag.value == "Y"){
						alert('죄송합니다. 품절된 상품은 구매하실 수 없습니다.');
						frm.itemea.focus();
						return;
					}

					if (frm.nophothofileflag.value=="1"){
						alert('포토북 상품은 편집후 구매 가능합니다.');
						frm.itemea.focus();
						return;
					}

					if (frm.itemea.value*1>frm.maxnoflag.value*1){
						alert('['+frm.itemname.value+'] 상품은 한정수량 또는 최대 구매수량 (' + frm.maxnoflag.value + ')개를 초과하여 주문 하실 수 없습니다.');
						frm.itemea.focus();
						return;
					}
                    if (frm.itemea.value*1<frm.minnoflag.value*1){
            			alert('최소 구매수량 (' + frm.minnoflag.value + ')개 이상 주문 하실 수 있습니다.');
            			frm.itemea.focus();
            			return;
            		}

					if ((jumundiv=="f")&&(frm.foreignflag.value!='Y')){
						alert('해외 배송이 불가능한 상품이 포함 되어있습니다.');
						if (frm.itemea.type=='text'){
							frm.itemea.focus();
						}
						return;
					}

					if ((jumundiv=="a")&&(frm.dtypflag.value!='1')){
						alert('군부대 배송이 불가능한 상품이 포함 되어있습니다.');
						if (frm.itemea.type=='text'){
							frm.itemea.focus();
						}
						return;
					}
				}
			}
		}

		if (!chkExists){
			alert('선택된 상품이 없습니다.');
			return;
		}

		if ((mitemExists)&&(!d1typExists)){
			alert('마일리지샵 상품은 텐바이텐 배송상품과 함께 주문하셔야 합니다.');
			return;
		}

		if ((oitemExists)&&(nitemExists)){
			alert('단독구매상품이 포함되어 있습니다. 단독구매상품은 다른 상품과 함께 주문이 불가하므로 별도 주문해주시기 바랍니다.');
			return;
		}

		if ((titemCount>0)&&(nitemExists)){
			alert('티켓상품이 포함되어 있습니다. 티켓상품은 다른 상품과 함께 주문이 불가하므로 별도 주문해주시기 바랍니다.');
			$('html, body').scrollTop($("#grpCart0").offset().top-(($(window).height()-$("#grpCart0").outerHeight())/2)-10);
			return;
		}

		if (titemCount>1){
			alert('티켓 상품은 개별상품으로만 주문 가능합니다.\n\티켓 상품은 한번에 한 상품씩 구매 가능합니다.');
			$('html, body').scrollTop($("#grpCart0").offset().top-(($(window).height()-$("#grpCart0").outerHeight())/2)-10);
			return;
		}

		if ((rstemCount>0)&&(nitemExists)){
			alert('현장수령 상품이 포함되어 있습니다. 현장수령 상품은 다른 상품과 함께 주문이 불가하므로 별도 주문해주시기 바랍니다.');
			$('html, body').scrollTop($("#grpCart2").offset().top-(($(window).height()-$("#grpCart2").outerHeight())/2)-10);
			return;
		}

		if ((pitemCount>0)&&(nitemExists)){
			alert('Present상품이 포함되어 있습니다. Present상품은 다른 상품과 함께 주문이 불가하므로 별도 주문해주시기 바랍니다.');
			$('html, body').scrollTop($("#grpCart1").offset().top-(($(window).height()-$("#grpCart1").outerHeight())/2)-10);
			return;
		}

		if (pitemCount>1){
			alert('Present 상품은 개별상품으로만 주문 가능합니다.\n\Present상품은 한번에 한 상품씩 구매 가능합니다.');
			$('html, body').scrollTop($("#grpCart1").offset().top-(($(window).height()-$("#grpCart1").outerHeight())/2)-10);
			return;
		}

		var currmileage = <%= availtotalMile %>;
		nextfrm.mileshopitemprice.value = mitemttl;

		if (nextfrm.mileshopitemprice.value*1>currmileage*1){
			alert('장바구니에 담으신 마일리지샵 상품의 합계가 고객님이 보유하신 마일리지 금액보다 큽니다.\n\n- 보유하신 마일리지 : ' + setComma(currmileage) + 'point\n- 담으신 마일리지샵 상품의 합계 : ' + setComma(nextfrm.mileshopitemprice.value) + 'point');
			return;
		}

		frm.mode.value = "OCK";
		frm.submit();
	}

	function addWishSelected(){
		<% If IsUserLoginOK() Then ''ErBValue.value -> 공통파일의 구분값 (장바구니는 5) %>
		    var frm = document.baguniFrm;
		    var chkExists = false;
		    var ArrayFavItemID='';
		
		    if (frm.chk_item){
		        if (frm.chk_item.length){
		            for(var i=0;i<frm.chk_item.length;i++){
		                if (frm.chk_item[i].checked){
		                    chkExists = true;
		                    ArrayFavItemID=ArrayFavItemID  + ',' + frm.itemid[i].value;
		                }
		            }
		        }else{
		            if (frm.chk_item.checked){
		                chkExists = true;
		                ArrayFavItemID=ArrayFavItemID  + ',' + frm.itemid.value;
		            }
		        }
		    }
		
		    if (!chkExists){
		        alert('선택된 상품이 없습니다.');
				return;
		    }

		    if (confirm('선택 상품을 위시리스트에 추가하시겠습니까?')){
		    	fnAPPpopupBrowserURL("위시폴더","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popWishFolder.asp?ErBValue=5&folderAction=AddFavItems&bagarray="+ArrayFavItemID);
				return false;
		    }
		<% Else %>
			calllogin();
			return false;
		<% End If %>
	}

	function DirectOrder(idx){
		var frm = document.baguniFrm;
		var reloadfrm = document.reloadFrm;

		if (!frm.itemkey.length){
			reloadfrm.mode.value    = "DO4";
			reloadfrm.itemid.value	= frm.itemid.value;
			reloadfrm.itemoption.value = frm.itemoption.value;
			reloadfrm.itemea.value = frm.itemea.value;

			if (frm.soldoutflag.value == "Y"){
				alert('품절된 상품은 구매하실 수 없습니다.');
				frm.itemea.focus();
				return;
			}

			if (frm.nophothofileflag.value == "1"){
				alert('포토북 상품은 편집후 구매 가능합니다.');
				frm.itemea.focus();
				return;
			}

			if (frm.itemea.value*1>frm.maxnoflag.value*1){
				alert('한정수량 또는 최대 구매수량 (' + frm.maxnoflag.value + ')개를 초과하여 주문 하실 수 없습니다.');
				frm.itemea.focus();
				return;
			}
			if (frm.itemea.value*1<frm.minnoflag.value*1){
				alert('최소 구매수량 (' + frm.minnoflag.value + ')개 이상 주문하실 수 있습니다.');
				frm.itemea.focus();
				return;
			}

			<% if (Not IsUserLoginOK) then %>
			if (frm.mtypflag.value == "t"){
				alert('죄송합니다. 티켓 상품은 회원 구매만 가능합니다.');
				frm.itemea.focus();
				return;
			}
		    if (frm.mtypflag.value == "p"){
		        alert('죄송합니다. Present상품은 회원 구매만 가능합니다.');
				return;
		    }
			<% end if %>

		}else{
			reloadfrm.mode.value = "DO4";
			reloadfrm.itemid.value	= frm.itemid[idx].value;
			reloadfrm.itemoption.value = frm.itemoption[idx].value;
			reloadfrm.itemea.value = frm.itemea[idx].value;

			if (frm.soldoutflag[idx].value == "Y"){
				alert('품절된 상품은 구매하실 수 없습니다.');
				frm.itemea[idx].focus();
				return;
			}

			if (frm.nophothofileflag[idx].value == "1"){
				alert('포토북 상품은 편집후 구매 가능합니다.');
				frm.itemea[idx].focus();
				return;
			}

			if (frm.itemea[idx].value*1>frm.maxnoflag[idx].value*1){
				alert('한정수량 또는 최대 구매수량 (' + frm.maxnoflag[idx].value + ')개를 초과하여 주문 하실 수 없습니다.');
				frm.itemea[idx].focus();
				return;
			}
			if (frm.itemea[idx].value*1<frm.minnoflag[idx].value*1){
				alert('최소 구매수량 (' + frm.minnoflag[idx].value + ')개 이상 주문하실 수 있습니다.');
				frm.itemea[idx].focus();
				return;
			}

			<% if (Not IsUserLoginOK) then %>
			if (frm.mtypflag[idx].value == "t"){
				alert('죄송합니다. 티켓 상품은 회원 구매만 가능합니다.');
				frm.itemea[idx].focus();
				return;
			}
		    if (frm.mtypflag[idx].value == "p"){
		        alert('죄송합니다. Present상품은 회원 구매만 가능합니다.');
				return;
		    }
			<% end if %>
		}

		document.reloadFrm.submit();
	}

	function popEmsApplyGoCondition(){
	    var nation = 'GR';
	    if (document.baguniFrm.countryCode.value!='') nation = document.baguniFrm.countryCode.value;
	
	    fnAPPpopupExternalBrowser('http://ems.epost.go.kr:8080/front.EmsApplyGoCondition.postal?nation=' + nation);
	}

	function setEMSPrice(comp){
	    var frm = comp.form;
	    var iMaxWeight = 30000;  //(g)
	    var totalWeight = <%= oshoppingbag.getEmsTotalWeight %>;
	    var contryName = '';
	
	    if (comp.value==''){
			document.getElementById("sp_emsPrice").innerHTML = "-";
			document.getElementById("sp_emsPriceTTL").innerHTML = "0원";
			document.getElementById("iemsPrice").value = 0;
	    }else{
	        var iemsAreaCode = comp[comp.selectedIndex].id.split("|")[0];
	        iMaxWeight = comp[comp.selectedIndex].id.split("|")[1];
	        contryName = comp[comp.selectedIndex].text;
	        iemsPrice  = calcuEmsPrice(iemsAreaCode);
			document.getElementById("iemsPrice").value = iemsPrice;
			document.getElementById("sp_emsPrice").innerHTML = plusComma(iemsPrice);
			document.getElementById("sp_emsPriceTTL").innerHTML = plusComma(iemsPrice)+"원";
		}
		fnSelCalculate();
	
	    //iMaxWeight 체크
	    if (totalWeight>iMaxWeight){
	        alert('죄송합니다. ' + contryName + ' 최대 배송 가능 중량은 ' + iMaxWeight + ' (g)입니다.');
	        comp.value='';
	        return;
	    }
	}

	function calcuEmsPrice(emsAreaCode){
	    //divEmsPrice
	    var emsprice = 0;

	    var _emsAreaCode = new Array(<%= oemsPrice.FResultCount %>);
	    var _emsPrice = new Array(<%= oemsPrice.FResultCount %>);
	
	    <% for i=0 to oemsPrice.FResultCount-1 %>
	        _emsAreaCode[<%= i %>] = '<%= oemsPrice.FItemList(i).FemsAreaCode %>';
	        _emsPrice[<%= i %>] = '<%= oemsPrice.FItemList(i).FemsPrice %>';
	    <% next %>

	    for (var i=0;i<_emsAreaCode.length;i++){
	        if (_emsAreaCode[i]==emsAreaCode){
	            emsprice = _emsPrice[i];
	            break;
	        }
	    }

	    return emsprice;
	}

	function plusComma(num){
		if (num < 0) { num *= -1; var minus = true}
		else var minus = false
	
		var dotPos = (num+"").split(".")
		var dotU = dotPos[0]
		var dotD = dotPos[1]
		var commaFlag = dotU.length%3
	
		if(commaFlag) {
			var out = dotU.substring(0, commaFlag)
			if (dotU.length > 3) out += ","
		}
		else var out = ""
	
		for (var i=commaFlag; i < dotU.length; i+=3) {
			out += dotU.substring(i, i+3)
			if( i < dotU.length-3) out += ","
		}
	
		if(minus) out = "-" + out
		if(dotD) return out + "." + dotD
		else return out
	}

	// 제작문구 수정
    function TnEditItemRequire(iid,ocd,ver,eqno){
        fnAPPpopupBrowserURL("주문제작문구수정","<%=wwwUrl%>/apps/appcom/wish/web2014/inipay/Pop_EditItemRequire.asp?itemid=" + iid + "&itemoption=" + ocd + "&ver=" + ver + "&eqno=" + eqno);
    }

	</script>
	<script>
	$(function(){
		fnAPPchangPopCaption("장바구니");

		<%
		''쇼핑백 갯수 처리
		if not(IsForeignDlv) then
			response.write "setTimeout(function(){fnAPPsetCartNum("&iTotalItemCount&");},100);"
		end if
		%>

		//Top버튼 위치 기본값
		$(".goTop").css("bottom",$(".btnAreaV16a").outerHeight());

		//탭클릭 초기화
		$(".tabNav li").unbind("click");

		$(".pickNav li").click(function() {
			$(this).siblings("li").removeClass("current");
			$(this).addClass("current");
			$(this).closest(".pickNav").nextAll(".tabContainer:first").find(".tabContent").hide();
			var activeTab = $(this).find("a").attr("href");
			$(activeTab).show();
			return false;
		});

		// 하단 플로팅바 표시
		$(window).scroll(function(){
			var vSpos = $(window).scrollTop() + $(window).height();
			var docuH = $(".totalPriceV16a").offset().top;

			if (vSpos < docuH){
				if($(".cartFloatBarV16a").css("display")=="none"){
					$(".cartFloatBarV16a").show(0,function(){
						$(".goTop").css("bottom",$(".btnAreaV16a").outerHeight());
					});
				}
			} else {
				$(".cartFloatBarV16a").fadeOut("fast",function(){
					$(".goTop").css("bottom",30);
				});
			}
		});

		// 상품갯수 직접입력시 플로팅바 컨트롤
		$(document.baguniFrm.itemea).focus(function(){
			var vSpos = $(window).scrollTop() + $(window).height();
			var docuH = $(".totalPriceV16a").offset().top;
			if (vSpos < docuH){
				$(".cartFloatBarV16a").hide();
				$(".goTop").css("bottom",30);
			}
		}).blur(function(){
			var vSpos = $(window).scrollTop() + $(window).height();
			var docuH = $(".totalPriceV16a").offset().top;
			if (vSpos < docuH){
				$(".cartFloatBarV16a").show();
				$(".goTop").css("bottom",$(".btnAreaV16a").outerHeight());
			}
		});

		// 체크박스 변경
		$("input[name='chk_item'],#chkSelItem").click(function(){
			if($(this).attr("id")=="chkSelItem")  $("input[name='chk_item']:enabled").prop("checked",$("#chkSelItem").prop("checked"));
			
			if($("input[name='chk_item']:enabled").length==$("input[name='chk_item']:checked").length) {
				$("#chkSelItem").prop("checked",true);
				$("#btnAllDel").show();
				$("#btnSelDel").hide();
			} else {
				$("#chkSelItem").prop("checked",false);
				$("#btnAllDel").hide();
				$("#btnSelDel").show();
			}

			fnSelCalculate();
		});

		// 해외배송 안내 On/Off
		$('.showHideV16a .tglBtnV16a').click(function(){
			$(this).toggleClass('showToggle');
			$(this).parents('.showHideV16a').children('.tglContV16a').toggle();
		});
        
        // 로딩후 총계 재계산
		fnSelCalculate();
		
		// 업체조건배송 타이틀 추가
		$(".lyrPrtGrp").first().prepend('<div class="bxLGy2V16a grpTitV16a grpPrtTit"><h2>업체 조건 배송 상품</h2></div>');
        <% if Not (application("Svr_Info")= "Dev") then %>
		fnAmplitudeEventAction("view_shoppingbag","","","");
	    <% end if %>
	});

        let appier_shoppingbag_products = new Array();
        let appier_shoppingbag_product = {};
	</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- content area -->
			<form name="frmC" method="get" action="/apps/appcom/wish/web2014/shoppingtoday/couponshop_process.asp" style="margin:0px;">
			<input type="hidden" name="stype" value="" />
			<input type="hidden" name="idx" value="" />
			<input type="hidden" name="reval" value="" />
			</form>
			<div class="content" id="contentArea" style="padding-bottom:0;">
			<% if Not(oshoppingbag.IsShoppingBagVoid) or IsForeignDlv or IsQuickDlv then %>
				<div class="tabV16a">
				    <% if (ISQuickDlvUsing) then %>
				    <span class="grid3 <%=CHKIIF(IsLocalDlv,"current","")%>"><a href="/apps/appcom/wish/web2014/inipay/shoppingbag.asp">국내배송</a></span>
				    <span class="grid3 <%=CHKIIF(IsQuickDlv,"current","")%>"><a href="/apps/appcom/wish/web2014/inipay/shoppingbag.asp?bTp=q">바로배송</a></span>
					<span class="grid3 <%=CHKIIF(IsForeignDlv,"current","")%>"><a href="/apps/appcom/wish/web2014/inipay/shoppingbag.asp?bTp=f">해외배송</a></span>
				    <% else %>
					<span class="grid2 <%=CHKIIF(IsLocalDlv,"current","")%>"><a href="/apps/appcom/wish/web2014/inipay/shoppingbag.asp">국내배송</a></span>
					<span class="grid2 <%=CHKIIF(IsForeignDlv,"current","")%>"><a href="/apps/appcom/wish/web2014/inipay/shoppingbag.asp?bTp=f">해외배송</a></span>
				    <% end if %>
				</div>
			<% end if %>
			<%
				If oshoppingbag.IsShoppingBagVoid Then
				'=== 장바구니 상품 없음
			%>
				<div class="emptyMsgV16a <%=chkIIF(IsForeignDlv or IsQuickDlv,"emptyIntlV16a","emptyDomsV16a")%>">
					<div>
						<p><%=chkIIF(IsForeignDlv,"해외배송이 가능한",CHKIIF(IsQuickDlv,"바로배송이 가능한","장바구니에 담긴"))%> 상품이 없습니다.</p>
						<p><button type="button" class="btnV16a btnRed2V16a" onclick="callgotoday();">쇼핑하러 가기</button></p>
					</div>
				</div>
			<%
				Else
				'=== 장바구니 상품 목록 시작
			%>
				<div class="cartV16a">
					<div class="bxLGy1V16a allOptV16a">
						<p><input type="checkbox" id="chkSelItem" checked="checked" /> <span class="txtAllSltV16a">전체선택(<%=iTotalItemCount & "/" & iTotalItemCount %>)</span></p>
						<button type="button" id="btnAllDel" class="btnV16a btnLGryV16a" onclick="delSelected('all');">전체삭제</button>
						<button type="button" id="btnSelDel" class="btnV16a btnLGryV16a" onclick="delSelected();" style="display:none;">선택삭제</button>
					</div>
					<form name="baguniFrm" method="post" action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp" onSubmit="return false" >
					<input type="hidden" name="mode" value="">
					<input type="hidden" name="jumundiv" value="1">
					<input type="hidden" name="bTp" value="<%=bTp%>">
					<%
						''IDX 0: 티켓, 1:Present상품, 2:현장수령 상품, 3:텐바이텐 배송, 4:업체 배송 5:업체 개별 배송 6:업체 착불배송
						dim Mix, MidxSub
						MidxSub = 0
				
						'구분별 장바구니 상품 목록출력 함수
						function DrawBaguniSubList()
						    Dim doNothing : doNothing=True
						    Dim iDlvTypeStr : iDlvTypeStr = getBaguniConstStringName(Mix)
						    Dim j,k,l : j=0 : k=1
						    Dim pmakerid,pdlvPrice, pdlvDispStr, pitemprice
					        dim i ''2015/10/19
				        
						    if IsForeignDlv then
						        iDlvTypeStr = "해외 배송 상품"
						    elseif IsArmyDlv then
						        iDlvTypeStr = "군부대 배송 상품"
						    elseif IsQuickDlv then
						        iDlvTypeStr = "바로 배송 상품"
						    end if
				
						    if (Mix=5) then ''업체 조건배송
						        oshoppingbag.GetParticleBeasongInfoDB
						        k = oshoppingbag.FParticleBeasongUpcheCount
						    end if
				
						    for j=0 to k-1
						        if (Mix=5) then
						            MidxSub = MidxSub+1
						            pmakerid = oshoppingbag.FParticleBeasongUpcheList(j).FMakerid
						            pdlvPrice = oshoppingbag.getUpcheParticleItemBeasongPrice(pmakerid)
						            pdlvDispStr = oshoppingbag.FParticleBeasongUpcheList(j).getDeliveryPayDispHTML
						            pitemprice  = oshoppingbag.GetCouponNotAssingUpcheParticleItemPrice(pmakerid)
						        end if
						        eachCnt = 0 ''//배송별 수량카운트
				%>
					<div class="cartGrpV16a <%=CHKIIF(Mix=5,"lyrPrtGrp","")%>" id="grpCart<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>">
						<% if Not(Mix=5) then %>
						<div class="bxLGy2V16a grpTitV16a">
							<h2><%= iDlvTypeStr %></h2>
							<% if (Mix=3) then %>
							<% if ((IsLocalDlv and oshoppingbag.IsQuickAvailItemExists) or IsQuickDlv) then %>
								<% If ISQuickDlvUsing Then %>
									<p class="rt"><button type="button" class="btnV16a btnLGryV16a" onclick="fnAPPpopupBrowserURL('바로배송안내','<%=wwwUrl%>/apps/appCom/wish/web2014/category/popQuickGuide.asp');">바로배송 안내</button></p>
								<% End If %>
						    <% end if %>
						    <% end if %>
						</div>
						<% end if %>
						<ul class="cartListV16a">
				<%
							for i=0 to oshoppingbag.FShoppingBagItemCount -1
								doNothing = True
	
								if (Mix=0) then if (oshoppingbag.FItemList(i).IsTicketItem) then doNothing = FALSE
								if (Mix=1) then if (oshoppingbag.FItemList(i).IsPresentItem) then doNothing = FALSE
								if (Mix=2) then if (oshoppingbag.FItemList(i).IsReceiveSite) then doNothing = FALSE
								if (Mix=3) then if ((Not oshoppingbag.FItemList(i).IsReceivePayItem ) and (Not oshoppingbag.FItemList(i).IsUpcheBeasong) and (Not oshoppingbag.FItemList(i).IsUpcheParticleBeasong) and (Not oshoppingbag.FItemList(i).IsTicketItem) and Not(oshoppingbag.FItemList(i).IsReceiveSite) and Not(oshoppingbag.FItemList(i).IsPresentItem) and Not(oshoppingbag.FItemList(i).IsTravelItem) and Not(oshoppingbag.FItemList(i).IsRentalItem)) then doNothing = FALSE
								if (Mix=4) then if (oshoppingbag.FItemList(i).IsUpcheBeasong) and Not(oshoppingbag.FItemList(i).IsTravelItem) and Not(oshoppingbag.FItemList(i).IsRentalItem) then doNothing = FALSE
								if (Mix=5) then if ( oshoppingbag.FItemList(i).IsUpcheParticleBeasong) and (LCase(pMakerid)=LCase(oshoppingbag.FItemList(i).FMakerid)) then doNothing = FALSE
								if (Mix=6) then if (oshoppingbag.FItemList(i).IsReceivePayItem) then doNothing = FALSE
								if (Mix=7) then if (oshoppingbag.FItemList(i).IsTravelItem) then doNothing = FALSE
								if (Mix=8) then if (oshoppingbag.FItemList(i).IsRentalItem) then doNothing = FALSE
	
								if (IsForeignDlv) then
									doNothing = True
									if (oshoppingbag.FItemList(i).IsForeignDeliverValid) then doNothing = FALSE
								end if
	
								TicketBookingExired = FALSE
	
								if (Mix=0) then
									set oTicketItem = new CTicketItem
									oTicketItem.FRectItemID = oshoppingbag.FItemList(i).FItemID
									oTicketItem.GetOneTicketItem
									IF (oTicketItem.FResultCount>0) then TicketBookingExired = oTicketItem.FOneItem.IsExpiredBooking
									set oTicketItem = Nothing
								end if
	
								if Not (doNothing) Then
				%>
				            <script>
                                appier_shoppingbag_product = {};

                                appier_shoppingbag_product.product_id = "<%=oshoppingbag.FItemList(i).FItemID%>";
                                appier_shoppingbag_product.product_name = "<%=oshoppingbag.FItemList(i).FItemName%>";
                                appier_shoppingbag_product.product_image_url = "<%=oshoppingbag.FItemList(i).FImageList%>";
                                appier_shoppingbag_product.product_url = " tenwishapp://http://m.10x10.co.kr/apps/appcom/wish/web2014/category/category_itemPrd.asp?itemid=<%= oshoppingbag.FItemList(i).FItemID %>&gaparam=cart_list";
                                appier_shoppingbag_product.product_price = parseInt("<%=oshoppingbag.FItemList(i).GetCouponAssignPrice%>");
                                appier_shoppingbag_product.category_name_depth1 = "";
                                appier_shoppingbag_product.category_name_depth2 = "";
                                appier_shoppingbag_product.brand_id = "<%=oshoppingbag.FItemList(i).FMakerID%>";
                                appier_shoppingbag_product.brand_name = "<%=oshoppingbag.FItemList(i).FBrandName%>";
                                appier_shoppingbag_product.quantity = parseInt("<%=oshoppingbag.FItemList(i).FItemEa%>");
                <%
                                DIM appier_total_price

                                IF (IsForeignDlv) then
                                    appier_total_price = oshoppingbag.GetCouponAssignTotalItemPrice-oshoppingbag.GetMileageShopItemPrice
                                ELSEIF (IsArmyDlv) then
                                    appier_total_price = oshoppingbag.GetTenDeliverItemPrice
                                ELSEIF (IsQuickDlv) then
                                    appier_total_price = oshoppingbag.GetTenDeliverItemPrice
                                ELSE
                                    appier_total_price = oshoppingbag.GetCouponAssignTotalItemPrice-oshoppingbag.GetMileageShopItemPrice
                                END IF
                %>
                                appier_shoppingbag_product.total_goods_price = parseInt("<%=appier_total_price%>");

                                appier_shoppingbag_products.push(appier_shoppingbag_product);
                            </script>
							<li class="bxWt1V16a <%=chkIIF(oshoppingbag.FItemList(i).ISsoldOut or TicketBookingExired,"soldoutV16a","") & chkIIF(oshoppingbag.FItemList(i).IsMileShopSangpum,"mileageV16a","") %>" mix="<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>">
								<div class="pdtWrapV16a">
									<div class="pdtNameV16a">
										<input type="checkbox" name="chk_item" mix="<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" <%=chkIIF(oshoppingbag.FItemList(i).ISsoldOut or TicketBookingExired,"disabled=""disabled""","checked=""checked""")%> value="<%= idx %>" />
										<h3><%=oshoppingbag.FItemList(i).FItemName%></h3>
									</div>
									<div class="pdtInfoV16a">
										<p class="pdtPicV16a">
											<a href="#" onclick="fnAPPpopupProduct_URL('http://m.10x10.co.kr/apps/appcom/wish/web2014/category/category_itemPrd.asp?itemid=<%=oshoppingbag.FItemList(i).FItemID%>&gaparam=cart_list'); return false;">
											<span>품절</span>
											<img src="<%= oshoppingbag.FItemList(i).FImageList %>" alt="<%= replace(oshoppingbag.FItemList(i).FItemName,"""","") %>" /></a>
										</p>

										<% if oshoppingbag.FItemList(i).Is09Sangpum then %>
										<p class="pdtOptionV16a">
											<span class="cRd1V16a">[단독구매상품]</span>
										</p>
										<% end if %>

						            	<% if (IsPercentBonusCouponExists and (oshoppingbag.FItemList(i).IsUnDiscountedMarginItem and Not oshoppingbag.FItemList(i).IsMileShopSangpum )) then %>
										<p class="pdtOptionV16a">
											<span class="fs1-1r cGr1V16a">퍼센트(%) 보너스쿠폰 적용제외</span>
										</p>
						            	<% end if %>

										<% if oshoppingbag.FItemList(i).getOptionNameFormat<>"" or oshoppingbag.FItemList(i).IsMileShopSangpum then %>
										<p class="pdtOptionV16a">
											<% if oshoppingbag.FItemList(i).getOptionNameFormat<>"" then %><span class="fs1-1r cLGy1V16a"><%= oshoppingbag.FItemList(i).getOptionNameFormat %></span><% end if %>
											<% if oshoppingbag.FItemList(i).IsMileShopSangpum then %><span class="pdtCmtBoxV16a">텐바이텐 배송상품과 함께 주문가능</span><% end if %>
										</p>
										<% end if %>
										<p class="pdtFlagV16a">
										<%
											'선물포장서비스 노출		'/2015.11.11 한용민 생성
											if G_IsPojangok and not(IsForeignDlv) and not(IsArmyDlv) and (oshoppingbag.FItemList(i).FPojangOk="Y") then
										%>
											<i class="icoPV16a">선물포장 가능 상품</i>
										<% end if %>
										<% if oshoppingbag.FItemList(i).IsMileShopSangpum then %><i class="icoMV16a">마일리지 상품</i><% end if %>
										<% if (ISQuickDlvUsing) AND (oshoppingbag.FItemList(i).IsQuickAvailItem) then %><i class="icoQV17a">바로배송 상품</i><% end if %>
										</p>

										<select name="selEa" title="수량변경이 가능합니다" class="pdtNumV16a" onchange="chgEditItem($('select[name=\'selEa\']').index(this));" <%=chkIIF(oshoppingbag.FItemList(i).ISsoldOut or TicketBookingExired,"disabled=""disabled""","")%> <%=chkIIF(Not(oshoppingbag.FItemList(i).ISsoldOut or TicketBookingExired or oshoppingbag.FItemList(i).IsMileShopSangpum) and oshoppingbag.FItemList(i).GetLimitOrderNo>1 and oshoppingbag.FItemList(i).FItemEa<=20 and (oshoppingbag.FItemList(i).FItemEa<=oshoppingbag.FItemList(i).GetLimitOrderNo),"","style=""display:none;""")%>>
										<% for l=oshoppingbag.FItemList(i).GetMinumOrderNo to chkIIF(oshoppingbag.FItemList(i).GetLimitOrderNo>20,20,oshoppingbag.FItemList(i).GetLimitOrderNo) %>
											<option value="<%=l%>" <%=chkIIF(l=oshoppingbag.FItemList(i).FItemEa,"selected","")%>><%=l%></option>
										<% next %>
										<% if oshoppingbag.FItemList(i).GetLimitOrderNo>20 then %>
											<option value="manual">직접입력</option>
										<% end if %>
										</select>

										<% if Not(oshoppingbag.FItemList(i).ISsoldOut or TicketBookingExired or oshoppingbag.FItemList(i).IsMileShopSangpum) then %>
										<input name="itemea" type="number" value="<%= oshoppingbag.FItemList(i).FItemEa %>" pattern="[0-9]*" maxlength="4" min="<%=oshoppingbag.FItemList(i).GetMinumOrderNo%>" max="<%=oshoppingbag.FItemList(i).GetLimitOrderNo%>" class="pdtNumV16a" style="width:5rem;<%=chkIIF(oshoppingbag.FItemList(i).GetLimitOrderNo>1 and oshoppingbag.FItemList(i).FItemEa<=20 and (oshoppingbag.FItemList(i).FItemEa<=oshoppingbag.FItemList(i).GetLimitOrderNo),"display:none;","")%>" onblur="EditItem($('input[name=\'itemea\']').index(this));" />
											<% If oshoppingbag.FItemList(i).IsRentalItem Then %>
												<button type="button" class="btnV16a btnRed1V16a btnUnitOrd" <%=chkIIF(oshoppingbag.FItemList(i).ISsoldOut or TicketBookingExired or oshoppingbag.FItemList(i).IsMileShopSangpum,"disabled=""disabled""","")%> onclick="DirectOrder($(this).parents('li .pdtWrapV16a').find('input[name=chk_item]').val());">렌탈하기</button>
											<% Else %>
												<button type="button" class="btnV16a btnRed1V16a btnUnitOrd" <%=chkIIF(oshoppingbag.FItemList(i).ISsoldOut or TicketBookingExired or oshoppingbag.FItemList(i).IsMileShopSangpum,"disabled=""disabled""","")%> onclick="DirectOrder($(this).parents('li .pdtWrapV16a').find('input[name=chk_item]').val());">바로주문</button>
											<% End If %>
										<% else %>
										<input name="itemea" type="hidden" value="<%= oshoppingbag.FItemList(i).FItemEa %>" />
										<% end if %>
									</div>
									<div class="pdtPriceV16a">
										<p>
											<span>
											<% if (oshoppingbag.FItemList(i).IsSailItem) then %>
												<%=oshoppingbag.FItemList(i).getSalePro%> 할인가
											<% elseif Not(oshoppingbag.FItemList(i).FUserVaildCoupon) then %>
												판매가
											<% end if %>
											<%	if (oshoppingbag.FItemList(i).FUserVaildCoupon) then %>
												<%=chkIIF(oshoppingbag.FItemList(i).IsSailItem,"+ ","")%>
												<%=chkIIF(oshoppingbag.FItemList(i).Fitemcoupontype="3","무료배송쿠폰","쿠폰적용가")%>
											<% end if %>
											</span>
											<% if Not(oshoppingbag.FItemList(i).FUserVaildCoupon or IsNULL(oshoppingbag.FItemList(i).Fcurritemcouponidx)) then %>
											<button type="button" class="btnV16a btnGrnV16a" onclick="jsDownCouponShoppingbag('prd','<%= oshoppingbag.FItemList(i).FCurrItemCouponIdx %>','S');return false;"><span>쿠폰 다운</span></button>
											<% end if %>
										</p>
										<% If oshoppingbag.FItemList(i).IsRentalItem Then %>
											<% If Trim(oshoppingbag.FItemList(i).FRentalMonth) <> "0" Then %>
												<p class="rt"><strong class="itemSubTotPrc" style="display:none"><%=FormatNumber(RentalPriceCalculationData(oshoppingbag.FItemList(i).FRentalMonth,oshoppingbag.FItemList(i).GetCouponAssignPrice * oshoppingbag.FItemList(i).FItemEa),0)%></strong><%=oshoppingbag.FItemList(i).FRentalMonth%>개월간 월 <strong><%=FormatNumber(RentalPriceCalculationData(oshoppingbag.FItemList(i).FRentalMonth,oshoppingbag.FItemList(i).GetCouponAssignPrice * oshoppingbag.FItemList(i).FItemEa),0)%></strong>원</p>
											<% Else %>
												<p class="rt"><strong class="itemSubTotPrc" style="display:none"><%=FormatNumber(RentalPriceCalculationData("12",oshoppingbag.FItemList(i).GetCouponAssignPrice * oshoppingbag.FItemList(i).FItemEa),0)%></strong>12개월간 월 <strong><%=FormatNumber(RentalPriceCalculationData("12",oshoppingbag.FItemList(i).GetCouponAssignPrice * oshoppingbag.FItemList(i).FItemEa),0)%></strong>원</p>
											<% End If %>
										<% Else %>										
											<p class="rt"><strong class="itemSubTotPrc"><%= FormatNumber(oshoppingbag.FItemList(i).GetCouponAssignPrice * oshoppingbag.FItemList(i).FItemEa,0) %></strong><%=chkIIF(oshoppingbag.FItemList(i).IsMileShopSangpum,"P","원")%></p>
										<% End If %>
									</div>
									<% if (oshoppingbag.FItemList(i).IsManufactureSangpum) then %>
									<div class="pdtOdrTxtV16a">
										<dl>
											<dt>
												<span>주문제작문구</span>
												<button type="button" class="btnV16a btnLGryV16a btnReqEditItem" <%=chkIIF(oshoppingbag.FItemList(i).ISsoldOut or TicketBookingExired,"disabled=""disabled""","")%> onclick="TnEditItemRequire('<%= oshoppingbag.FItemList(i).FItemid %>','<%= oshoppingbag.FItemList(i).FItemoption %>','v16',$('.btnReqEditItem').index(this));">수정</button>
											</dt>
											<dd class="reqrText">
											<% if (oshoppingbag.FItemList(i).IsManufactureSangpum) and (oshoppingbag.FItemList(i).getRequireDetail="") then %>
												(! 주문제작문구를 넣어주세요.)
												<% NotWriteRequireDetailExists = True %>
											<% else %>
												<%= oshoppingbag.FItemList(i).getRequireDetailHtml %>
											<% end if %>
											</dd>
										</dl>
									</div>
									<% end if %>
									<button type="button" class="btnUnitDel" onclick="DelItem($('.btnUnitDel').index(this)); return false;"><img src="//fiximage.10x10.co.kr/m/2016/common/btn_delete.png" alt="삭제" /></button>
								</div>
								<input type="hidden" name="itemkey" value="<%=oshoppingbag.FItemList(i).FItemID %>_<%=oshoppingbag.FItemList(i).FItemOption %>">
								<input type="hidden" name="itemname" value="<%=replace(chrbyte(getRealItemname(oshoppingbag.FItemList(i).FItemName),24,"Y")," ","")%>">
								<input type="hidden" name="itemid" value="<%= oshoppingbag.FItemList(i).FItemID %>">
								<input type="hidden" name="itemoption" value="<%= oshoppingbag.FItemList(i).FItemoption %>">
								<input type="hidden" name="soldoutflag" value="<% if (oshoppingbag.FItemList(i).IsSoldOut) or (TicketBookingExired) then response.write "Y" else response.write "N" end if %>">
								<input type="hidden" name="maxnoflag" value="<%= oshoppingbag.FItemList(i).GetLimitOrderNo %>">
								<input type="hidden" name="minnoflag" value="<%= oshoppingbag.FItemList(i).GetMinumOrderNo %>">
								<input type="hidden" name="foreignflag" value="<% if oshoppingbag.FItemList(i).IsForeignDeliverValid then response.write "Y" else response.write "N" end if %>">
								<% if (oshoppingbag.FItemList(i).IsUpcheBeasong) or (oshoppingbag.FItemList(i).IsReceivePayItem) or (oshoppingbag.FItemList(i).Fdeliverytype="2") then %><input type="hidden" name="dtypflag" value="2">
								<% elseif (oshoppingbag.FItemList(i).IsUpcheParticleBeasong) then %><input type="hidden" name="dtypflag" value="3">
								<% elseif (oshoppingbag.FItemList(i).IsTicketItem) or (oshoppingbag.FItemList(i).IsPresentItem) or (oshoppingbag.FItemList(i).IsReceiveSite) then %><input type="hidden" name="dtypflag" value="0">
								<% elseif (oshoppingbag.FItemList(i).IsFreeBeasongItem) then %><input type="hidden" name="dtypflag" value="4">
								<% else %><input type="hidden" name="dtypflag" value="1"><% end if %>
								<% if oshoppingbag.FItemList(i).Is09Sangpum then %><input type="hidden" name="mtypflag" value="o">
								<% elseif oshoppingbag.FItemList(i).IsTicketItem then %><input type="hidden" name="mtypflag" value="t">
								<% elseif oshoppingbag.FItemList(i).IsPresentItem then %><input type="hidden" name="mtypflag" value="p">
								<% elseif oshoppingbag.FItemList(i).IsMileShopSangpum then %><input type="hidden" name="mtypflag" value="m">
								<% elseif oshoppingbag.FItemList(i).IsReceiveSite then %><input type="hidden" name="mtypflag" value="r">
								<% else %><input type="hidden" name="mtypflag" value=""><% end if %>
								<input type="hidden" name="isellprc" value="<%= oshoppingbag.FItemList(i).getRealPrice %>">
								<input type="hidden" name="ifinalprc" value="<%= oshoppingbag.FItemList(i).GetCouponAssignPrice %>">
								<input type="hidden" name="imileage" value="<%=chkIIF(IsUserLoginOK(),oshoppingbag.FItemList(i).FMileage,"0") %>">
								<input type="hidden" name="cPlusale" value="<%=chkIIF(oshoppingbag.FItemList(i).IsPLusSaleItem,"true","false")%>">
								<input type="hidden" name="couponcheck" value="<%=oshoppingbag.GetCouponItemCheck(oshoppingbag.FItemList(i).FItemID)%>">
								<% if (oshoppingbag.FItemList(i).ISFujiPhotobookItem) and (oshoppingbag.FItemList(i).getPhotobookFileName="") then %><input type="hidden" name="nophothofileflag" value="1">
								<% else %><input type="hidden" name="nophothofileflag" value="0"><% end if %>
							</li>
				<%
									if (Mix=0) then iTicketItemCNT = iTicketItemCNT +1
									if (Mix=1) then iPresentItemCNT = iPresentItemCNT +1
									eachCnt = eachCnt + 1
									idx = idx +1
								end if
							next
				%>
						</ul>
						<% if (IsForeignDlv) or (IsArmyDlv) or (IsQuickDlv) then %>
							<% if Not(IsForeignDlv) then %>
							<div class="bxLGy2V16a grpTotalV16a">
								<div id="grpTot<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>">
									<p>상품 <span class="cBk1V16a"><%= FormatNumber(oshoppingbag.GetTenDeliverItemPrice,0) %></span>원
										+ 배송 <span class="cBk1V16a"><%= FormatNumber(oshoppingbag.GetOrgBeasongPrice,0) %></span>원
										= <strong><span class="fs1-9r cRd1V16a"><%= FormatNumber(oshoppingbag.GetTenDeliverItemPrice+oshoppingbag.GetOrgBeasongPrice,0) %></span>원</strong></p>
									<% if (oshoppingbag.IsMileShopSangpumExists) then %>
									<p>마일리지샵 상품합계 <span class="cBk1V16a"><%= FormatNumber(oshoppingbag.GetMileageShopItemPrice,0) %></span>P</p>
									<% end if %>
								</div>
							</div>
							<% end if %>
							<input type="hidden" id="grpDlvLmt<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" name="grpDlvLmt<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" value="<%=oshoppingbag.getFreeBeasongLimit%>">
							<input type="hidden" id="grpDlvPrc<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" name="grpDlvPrc<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" value="<%=oshoppingbag.getTenDeliverItemBeasongPay%>">
						<% else %>
						<div class="bxLGy2V16a grpTotalV16a">
							<% Select Case Mix %>
							<% Case 0 %>
								<div id="grpTot<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>">
									<p>상품 <span class="cBk1V16a"><%= FormatNumber(oshoppingbag.GetCouponNotAssingTicketItemPrice,0) %></span>원 
										+ 배송 <span class="cBk1V16a"><%= FormatNumber(oshoppingbag.GetTicketItemBeasongPrice,0) %></span>원
										= <strong><span class="fs1-9r cRd1V16a"><%= FormatNumber(oshoppingbag.GetCouponNotAssingTicketItemPrice+oshoppingbag.GetTicketItemBeasongPrice,0) %></span>원</strong></p>
								</div>
								<p class="tMar0-5r fs1-1r cMGy1V16a">티켓예매는 일반상품과 함께 구매가 안되며,<br/> 티켓만 단독으로 주문하셔야 합니다.</p>
								<input type="hidden" id="grpDlvLmt<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" name="grpDlvLmt<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" value="0">
								<input type="hidden" id="grpDlvPrc<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" name="grpDlvPrc<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" value="<%=oshoppingbag.GetTicketItemBeasongPrice%>">
							<% Case 1 %>
								<div id="grpTot<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>">
									<p>상품 <span class="cBk1V16a"><%= FormatNumber(oshoppingbag.GetCouponNotAssingPresentItemPrice,0) %></span>원
										+ 배송 <span class="cBk1V16a"><%= FormatNumber(oshoppingbag.GetPresentItemBeasongPrice,0) %></span>원
										= <strong><span class="fs1-9r cRd1V16a"><%= FormatNumber(oshoppingbag.GetCouponNotAssingPresentItemPrice+oshoppingbag.GetPresentItemBeasongPrice,0) %></span>원</strong></p>
								</div>
								<p class="tMar0-5r fs1-1r cMGy1V16a">10X10 Present 상품은 일반상품과 함께 주문되지 않으며,<br/> 단독으로 주문하셔야 합니다.</p>
								<input type="hidden" id="grpDlvLmt<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" name="grpDlvLmt<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" value="-1">
								<input type="hidden" id="grpDlvPrc<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" name="grpDlvPrc<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" value="<%=oshoppingbag.GetPresentItemBeasongPrice%>">
							<% Case 2 %>
								<div id="grpTot<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>">
									<p>상품 <span class="cBk1V16a"><%= FormatNumber(oshoppingbag.GetCouponNotAssingRsvSiteItemPrice,0) %></span>원
										+ 배송 <span class="cBk1V16a"><%= FormatNumber(oshoppingbag.GetRsvSiteItemBeasongPrice,0) %></span>원
										= <strong><span class="fs1-9r cRd1V16a"><%= FormatNumber(oshoppingbag.GetCouponNotAssingRsvSiteItemPrice+oshoppingbag.GetRsvSiteItemBeasongPrice,0) %></span>원</strong></p>
								</div>
								<p class="tMar0-5r fs1-1r cMGy1V16a">배송 없이 지정된 현장에서 직접 수령합니다.<br/> 현장수령상품은 단독으로 주문하셔야 합니다.</p>
								<input type="hidden" id="grpDlvLmt<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" name="grpDlvLmt<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" value="0">
								<input type="hidden" id="grpDlvPrc<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" name="grpDlvPrc<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" value="<%=oshoppingbag.GetRsvSiteItemBeasongPrice%>">
							<% Case 3 %>
								<div id="grpTot<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>">
									<p>상품 <span class="cBk1V16a"><%= FormatNumber(oshoppingbag.GetTenDeliverItemPrice,0) %></span>원
										+ 배송 <span class="cBk1V16a"><%= FormatNumber(oshoppingbag.getTenDeliverItemBeasongPrice,0) %></span>원
										= <strong><span class="fs1-9r cRd1V16a"><%= FormatNumber(oshoppingbag.GetTenDeliverItemPrice+oshoppingbag.getTenDeliverItemBeasongPrice,0) %></span>원</strong></p>
									<% if (oshoppingbag.IsMileShopSangpumExists) then %>
									<p>마일리지샵 상품합계 <span class="cBk1V16a"><%= FormatNumber(oshoppingbag.GetMileageShopItemPrice,0) %></span>P</p>
									<% end if %>
								</div>
								<% if oshoppingbag.getFreeBeasongLimit>1 then %><p class="tMar0-5r fs1-1r cMGy1V16a">텐바이텐배송 <%=FormatNumber(oshoppingbag.getFreeBeasongLimit,0)%>원이상 구매 시 무료배송</p><% end if %>
								<input type="hidden" id="grpDlvLmt<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" name="grpDlvLmt<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" value="<%=oshoppingbag.getFreeBeasongLimit%>">
								<input type="hidden" id="grpDlvPrc<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" name="grpDlvPrc<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" value="<%=oshoppingbag.getTenDeliverItemBeasongPay%>">
							<% Case 4 %>
								<div id="grpTot<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>">
									<p>상품 <span class="cBk1V16a"><%= FormatNumber(oshoppingbag.GetCouponNotAssingUpcheItemPrice,0) %></span>원
										+ 배송 <span class="cBk1V16a"><%= FormatNumber(oshoppingbag.getUpcheBeasongPrice,0) %></span>원
										= <strong><span class="fs1-9r cRd1V16a"><%= FormatNumber(oshoppingbag.GetCouponNotAssingUpcheItemPrice+oshoppingbag.getUpcheBeasongPrice,0) %></span>원</strong></p>
								</div>
								<input type="hidden" id="grpDlvLmt<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" name="grpDlvLmt<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" value="0">
								<input type="hidden" id="grpDlvPrc<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" name="grpDlvPrc<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" value="<%=oshoppingbag.getUpcheBeasongPrice%>">
							<% Case 5 %>
								<div id="grpTot<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>">
									<p>상품 <span class="cBk1V16a"><%= FormatNumber(pitemprice,0) %></span>원
										+ 배송 <span class="cBk1V16a"><%= FormatNumber(pdlvPrice,0) %></span>원
										= <strong><span class="fs1-9r cRd1V16a"><%= FormatNumber(pitemprice+pdlvPrice,0) %></span>원</strong></p>
								</div>
								<p class="tMar0-5r fs1-1r cMGy1V16a"><%=Replace(oshoppingbag.FParticleBeasongUpcheList(j).getDeliveryPayDispHTML,"<strong>"&oshoppingbag.FParticleBeasongUpcheList(j).FSocName_Kor&"</strong>","<strong class=""txtLine"" onClick=""fnAPPpopupBrand('" & pmakerid & "');"">"&oshoppingbag.FParticleBeasongUpcheList(j).FSocName_Kor&"</strong>")%></p>
								<input type="hidden" id="grpDlvLmt<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" name="grpDlvLmt<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" value="<%=oshoppingbag.FParticleBeasongUpcheList(j).FdefaultFreebeasongLimit%>">
								<input type="hidden" id="grpDlvPrc<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" name="grpDlvPrc<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" value="<%=chkIIF(GetLoginUserLevel="7" or GetLoginUserLevel="8",0,oshoppingbag.FParticleBeasongUpcheList(j).FdefaultDeliverPay)%>">
								<%
									'// 조건배송에 상품이 없으면 요소 삭제
									if eachCnt<=0 then
										Response.Write "<script>$('#grpCart" & CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix) & "').remove();</script>"
									end if
								%>
							<% Case 6 %>
								<div id="grpTot<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>">
									<p>상품 <span class="cBk1V16a"><%= FormatNumber(oshoppingbag.GetCouponNotAssingUpcheReceivePayItemPrice,0) %></span>원
										+ 배송비 착불 부과
										= <strong><span class="fs1-9r cRd1V16a"><%= FormatNumber(oshoppingbag.GetCouponNotAssingUpcheReceivePayItemPrice+0,0) %></span>원</strong></p>
								</div>
								<p class="tMar0-5r fs1-1r cMGy1V16a">배송 지역에 따라 배송비가 착불로 부가됩니다.</p>
								<input type="hidden" id="grpDlvLmt<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" name="grpDlvLmt<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" value="0">
								<input type="hidden" id="grpDlvPrc<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" name="grpDlvPrc<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" value="0">
							<% Case 7 %>
								<div id="grpTot<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>">
									<p>상품 <span class="cBk1V16a"><%= FormatNumber(oshoppingbag.GetCouponNotAssingTravelItemPrice,0) %></span>원 
										+ 배송 <span class="cBk1V16a"><%= FormatNumber(oshoppingbag.GetTravelItemBeasongPrice,0) %></span>원
										= <strong><span class="fs1-9r cRd1V16a"><%= FormatNumber(oshoppingbag.GetCouponNotAssingTravelItemPrice+oshoppingbag.GetTravelItemBeasongPrice,0) %></span>원</strong></p>
								</div>
								<input type="hidden" id="grpDlvLmt<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" name="grpDlvLmt<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" value="0">
								<input type="hidden" id="grpDlvPrc<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" name="grpDlvPrc<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" value="<%=oshoppingbag.GetTravelItemBeasongPrice%>">
							<% Case 8 %>
								<div id="grpTot<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" style="display:none;"></div>
								<p class="tMar0-5r fs1-1r cMGy1V16a">이니렌탈 상품은 일반 상품과 함께 구매가 되지 않으며 렌탈 상품만 단독으로 주문하셔야 합니다.</p>
								<p class="tMar0-5r fs1-1r cMGy1V16a">렌탈 개월 수는 결제 페이지에서 변경하실 수 있습니다.</p>
								<input type="hidden" id="grpDlvLmt<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" name="grpDlvLmt<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" value="0">
								<input type="hidden" id="grpDlvPrc<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" name="grpDlvPrc<%=CHKIIF(Mix=5,Mix+CnPls+MidxSub,Mix)%>" value="<%=oshoppingbag.getUpcheBeasongPrice%>">							
							<% End Select %>
						</div>
						<% end if %>
					</div>
				<%
				    	Next
					End function
					Function getRealItemname(strng)
					   strng = replace(strng,"""","")
					   Dim regEx
					   Set regEx = New RegExp
					   regEx.Pattern = "[\[][^\]]*[\]]|[&#]"
					   regEx.IgnoreCase = True
					   regEx.Global = True
					   getRealItemname = regEx.Replace(strng, "")
					   Set regEx = nothing
					End Function
				%>
				<%
					'// 장바구니 상품 목록 출력
					for Mix=0 to 8
				
						'// 티켓상품
						if (Mix=0) and (IsLocalDlv) then
							if (oshoppingbag.IsTicketSangpumExists) then CALL DrawBaguniSubList()
						end if
				
						'// 프리젠트 상품
						if (Mix=1) and (IsLocalDlv) then
							if (oshoppingbag.IsPresentSangpumExists) then CALL DrawBaguniSubList()
						end if
				
						'// 현장수령 상품
						if (Mix=2) and (IsLocalDlv) then
							if (oshoppingbag.IsRsvSiteSangpumExists) then CALL DrawBaguniSubList()
						end if
				
						'// 텐바이텐 & 마일리지샵 상품
						if (Mix=3) then
							if ((oshoppingbag.IsTenBeasongInclude) or (oshoppingbag.IsMileShopSangpumExists)) then CALL DrawBaguniSubList()
						end if
				
						'// 업체배송 상품
						if (Mix=4) and (IsLocalDlv) then
							if ((oshoppingbag.IsUpcheBeasongInclude)) then CALL DrawBaguniSubList() ''and (not oshoppingbag.IsTravelSangpumExists)
						end if
				
						'// 업체조건배송 상품
						if (Mix=5) and (IsLocalDlv) then
							if (oshoppingbag.IsUpcheParticleBeasongInclude) then CALL DrawBaguniSubList()
						end if
				
						'// 업체착불배송 상품
						if (Mix=6) and (IsLocalDlv) then
							if (oshoppingbag.IsReceivePayItemInclude) then CALL DrawBaguniSubList()
						end if
						
						'// 여행 상품
					   if (Mix=7) and (IsLocalDlv) then
					   	if (oshoppingbag.IsTravelSangpumExists) then CALL DrawBaguniSubList()
					   end if

						'// 렌탈 상품
					   if (Mix=8) and (IsLocalDlv) then
					   	if (oshoppingbag.IsRentalSangpumExists) then CALL DrawBaguniSubList()
					   end if						   
					next
			%>
				<%
					'/// 해외배송 선택시 노출
					if IsForeignDlv then
				%>
					<div class="cartGrpV16a intlCostV16a showHideV16a">
						<div class="bxLGy2V16a grpTitV16a tglBtnV16a">
							<h2 class="hasArrow">중량 및 해외 배송비</h2>
						</div>
						<div class="pdtWrapV16a bxWt1V16a tglContV16a">
							<div class="pdtInfoV16a">
								<p class="intlWgtV16a">
									<span class="bxRdGry1V16a">상품 총 중량<br /><%= FormatNumber(oshoppingbag.getEmsTotalWeight-oshoppingbag.getEmsBoxWeight,0) %>g</span>
									<span><strong>+</strong></span>
									<span class="bxRdGry1V16a">포장 총 중량<br /><%= FormatNumber(oshoppingbag.getEmsBoxWeight,0) %>g</span>
									<span><strong>=</strong></span>
									<span class="bxRdGry1V16a"><strong class="cRd1V16a"><%= FormatNumber(oshoppingbag.getEmsTotalWeight,0) %>g</strong></span>
								</p>
								<p class="tMar1-3r">
									<select name="countryCode" title="배송국가를 선택해주세요" onChange="setEMSPrice(this);" style="width:100%;">
										<option value="">배송 국가 선택</option>
										<% for i=0 to oems.FREsultCount-1 %>
										<option value="<%= oems.FItemList(i).FcountryCode %>" id="<%= oems.FItemList(i).FemsAreaCode %>|<%= oems.FItemList(i).FemsMaxWeight %>" iMaxWeight="<%= oems.FItemList(i).FemsMaxWeight %>" iAreaCode="<%= oems.FItemList(i).FemsAreaCode %>"><%= oems.FItemList(i).FcountryNameKr %>(<%= oems.FItemList(i).FcountryNameEn %>)</option>
									    <% next %>
									</select>
									<input type="hidden" name="iemsPrice" id="iemsPrice" value="0">
								</p>
								<p class="tMar0-9r">
									<a href="" onClick="popEmsApplyGoCondition();return false;"><span class="btnLinkBl">EMS 지역 요금보기</span></a>
								</p>
							</div>
							<div class="pdtPriceV16a">
								<p>
									<span>해외 배송비 (전체상품)</span>
								</p>
								<p class="rt"><strong class="cRd1V16a" id="sp_emsPrice">-</strong>원</p>
							</div>
						</div>
					</div>
			    <%
			        elseif (IsQuickDlv) then
			    %>
			            <input type="hidden" name="iquickDlvPrice" id="iquickDlvPrice" value="<%=C_QUICKDLVPRICE%>">
				<%
					end if
				%>
					<div class="bxWt1V16a totalPriceV16a">
						<div class="bxWt1V16a" id="lyrTotalItem">
						<% if (IsForeignDlv) then %>
							<dl class="infoArrayV16a">
								<dt>총 상품금액 (<%= iTotalItemCount %>개)</dt>
								<dd><%= FormatNumber(oshoppingbag.GetCouponAssignTotalItemPrice-oshoppingbag.GetMileageShopItemPrice,0) %>원</dd>
								<input type="hidden" id="totItemPrc" value="<%=oshoppingbag.GetCouponAssignTotalItemPrice-oshoppingbag.GetMileageShopItemPrice%>">
							</dl>
							<dl class="infoArrayV16a">
								<dt>해외 배송비 (전체상품)</dt>
								<dd id="sp_emsPriceTTL"><%= FormatNumber(oshoppingbag.GetOrgBeasongPrice,0) %>원</dd>
							</dl>
						<% elseif (IsArmyDlv) then %>
							<dl class="infoArrayV16a">
								<dt>총 상품금액 (<%= iTotalItemCount %>개)</dt>
								<dd><%= FormatNumber(oshoppingbag.GetTenDeliverItemPrice,0)%>원</dd>
							</dl>
							<dl class="infoArrayV16a">
								<dt>군부대 배송비</dt>
								<dd><%= FormatNumber(oshoppingbag.GetOrgBeasongPrice,0) %>원</dd>
							</dl>
						<% elseif (IsQuickDlv) then %>
							<dl class="infoArrayV16a">
								<dt>총 상품금액 (<%= iTotalItemCount %>개)</dt>
								<dd><%= FormatNumber(oshoppingbag.GetTenDeliverItemPrice,0)%>원</dd>
							</dl>
							<dl class="infoArrayV16a">
								<dt>바로배송 배송비</dt>
								<dd><%= FormatNumber(oshoppingbag.GetOrgBeasongPrice,0) %>원</dd>
							</dl>
						<% else %>
							<dl class="infoArrayV16a">
								<dt>총 상품금액 (<%= iTotalItemCount %>개)</dt>
								<dd><%= FormatNumber(oshoppingbag.GetCouponAssignTotalItemPrice-oshoppingbag.GetMileageShopItemPrice,0) %>원</dd>
							</dl>
							<dl class="infoArrayV16a">
								<dt>총 배송비</dt>
								<dd><%= FormatNumber(oshoppingbag.GetTotalBeasongPrice,0) %>원</dd>
							</dl>
						<% end if %>
						</div>
						<div class="finalPriceV16a" id="lyrTotalOrder">
							<dl class="infoArrayV16a">
								<dt>총 주문금액</dt>
								<dd>
								<% if (IsArmyDlv or IsQuickDlv) then %>
									<%= FormatNumber(oshoppingbag.GetTenDeliverItemPrice+oshoppingbag.GetOrgBeasongPrice,0)%>원
								<% elseif IsForeignDlv then %>
	                            	<%= FormatNumber(oshoppingbag.GetCouponAssignTotalItemPrice-oshoppingbag.GetMileageShopItemPrice+oshoppingbag.GetTotalBeasongPrice,0)%>원
								<% else %>
									<%= FormatNumber(oshoppingbag.getTotalCouponAssignPrice("0000")-oshoppingbag.GetMileageShopItemPrice,0) %>원
								<% end if %>
								</dd>
							</dl>
							<% if (oshoppingbag.GetMileageShopItemPrice<>0) then%>
							<dl class="infoArrayV16a">
								<dt>총 마일리지샵 금액</dt>
								<dd><%= FormatNumber(oshoppingbag.GetMileageShopItemPrice,0) %>P</dd>
							</dl>
							<% end if %>
							<% If IsUserLoginOK() Then %>
							<p class="rt fs1-1r cMGy1V16a">
								<span>(적립 마일리지 <%= FormatNumber(oshoppingbag.getTotalGainmileage,0) %>P)</span>
							</p>
							<% end if %>
						</div>
					</div>

					<div class="bxWt1V16a btnAreaV16a">
						<p style="width:8.75rem; padding-right:0.52rem;"><button type="button" class="btnV16a btnRed1V16a" onclick="addWishSelected();">선택위시</button></p>
						<p><button type="button" class="btnV16a btnRed2V16a" onclick="PayNextSelected('<%=bTp%>');">주문하기</button></p>
					</div>

					<% If IsUserLoginOK() Then %>
					<div class="bxLGy1V16a cartNotiV16a">
						<h2>유의사항</h2>
						<ul>
							<li>장바구니는 마지막 접속 후 14일 동안만 보관됩니다.<br/>더 오래 보관하고 싶은 상품은 위시리스트에 담아주세요.</li>
							<% if (IsForeignDlv) then %><li>해외 배송의 경우 배송 국가는 [주문결제] 단계에서도 선택 및 변경이 가능합니다.</li><% end if %>
						</ul>
					</div>
					<% end if %>

					<% ' 18주년 세일 기간 동안 쿠폰 배너 노출
					'If date() > "2019-09-25" AND date() < "2019-10-01" Then 
					If date() > "2019-09-30" AND date() < "2019-11-01" Then 
					%>
					<style>
					.bnr18th {padding:1.14rem 0 3.41rem; background-color:#e8eaea;}
					</style>
					<div class="bnr18th">
						<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_shoppingbag_coupon_banner','','', function(bool){if(bool) {fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp');return false;}});">
							<img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bnr_18th_shopbag.png" alt="지금 최대 30% 할인쿠폰을 사용해보세요!">
						</a>
					</div>
					<% End if %>

					<%' 다스배너 %>
                    <% If now() >= #2021-12-25 23:59:59# Then %>
                    <!-- <a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '텐텐문구점', [BtnType.SEARCH, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2021/index.asp')" class="bnr_shoppingbag_dr">
						<img src="http://fiximage.10x10.co.kr/m/2021/diary/bnr_diary2022_box.png" alt="diary story 2022">
					</a> -->
                    <% Else %>
                    <!-- <a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '텐텐문구점', [BtnType.SEARCH, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2021/index.asp')" class="bnr_shoppingbag_dr">
						<img src="http://fiximage.10x10.co.kr/m/2021/diary/bnr_big_diary2022_02.png" alt="12월인데 다이어리 구매 안한 사람 있나?">
					</a> -->
                    <% End If %>
					</form>
				</div>
			<%
				'=== 장바구니 상품 목록 끝.
				End IF
			%>
			</div>

			<%
				'// 하단 주문 플로팅바 : 총 주문금액 영역까지 스크롤 내려오면 플로팅 노출X
				If Not(oshoppingbag.IsShoppingBagVoid) Then
			%>
			<div class="cartFloatBarV16a">
				<div>
					<p id="lyrTotalSummary">
						<span class="tMar0-3r fs1-1r">총 <%= iTotalItemCount %>개</span>
						<span class="tMar0-5r">
							<strong><%
								if IsArmyDlv or IsQuickDlv then
									Response.Write FormatNumber(oshoppingbag.GetTenDeliverItemPrice+oshoppingbag.GetOrgBeasongPrice,0)
								elseif IsForeignDlv then
									Response.Write FormatNumber(oshoppingbag.GetCouponAssignTotalItemPrice-oshoppingbag.GetMileageShopItemPrice+oshoppingbag.GetTotalBeasongPrice,0)
								else
									Response.Write FormatNumber(oshoppingbag.getTotalCouponAssignPrice("0000")-oshoppingbag.GetMileageShopItemPrice,0)
								end if
							%></strong>원
							<% if (oshoppingbag.GetMileageShopItemPrice<>0) then %>
							+ <em class="cABl1V16a"><%= FormatNumber(oshoppingbag.GetMileageShopItemPrice,0) %>P</em>
							<% end if %>
						</span>
					</p>
					<p>
						<button type="button" class="btnV16a btnRed2V16a" onclick="PayNextSelected('<%=bTp%>');">주문하기</button>
					</p>
				</div>
			</div>
			<%	end if %>

			<%
				'// 구글 ADS 스크립트 관련(2018.09.21 신규버전 추가)
				googleADSCRIPT = " <script> "&vbCrLf
				googleADSCRIPT = googleADSCRIPT & "   gtag('event', 'page_view', { "&vbCrLf
				googleADSCRIPT = googleADSCRIPT & "     'send_to': 'AW-851282978', "&vbCrLf
				googleADSCRIPT = googleADSCRIPT & "     'ecomm_pagetype': 'cart', "&vbCrLf
				googleADSCRIPT = googleADSCRIPT & "     'ecomm_prodid': "&ADSItem&", "&vbCrLf
				googleADSCRIPT = googleADSCRIPT & "     'ecomm_totalvalue': "&oshoppingbag.getTotalPrice("0000")&" "&vbCrLf
				googleADSCRIPT = googleADSCRIPT & "   }); "&vbCrLf
				googleADSCRIPT = googleADSCRIPT & " </script> "				
			%>

			<!-- 장바구니 끝 -->
			<form name="reloadFrm" method="post" action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp" onsubmit="return false;">
			<input type="hidden" name="mode" value="">
			<input type="hidden" name="sitename" value="10x10">
			<input type="hidden" name="itemid" value="">
			<input type="hidden" name="itemoption" value="">
			<input type="hidden" name="itemea" value="">
			<input type="hidden" name="bTp" value="<%=bTp%>">
			</form>

			<form name="NextFrm" method="post" action="<%= Replace(wwwUrl,"http:","http:") %>/apps/appCom/wish/web2014/inipay/userinfo.asp">
			<input type="hidden" name="sitename" value="10x10">
			<input type="hidden" name="jumundiv" value="1">
			<input type="hidden" name="bTp" value="<%=bTp%>">
			<input type="hidden" name="subtotalprice" value="<%= oshoppingbag.getTotalPrice("0000") %>">
			<input type="hidden" name="itemsubtotal" value="<%= oshoppingbag.GetTotalItemOrgPrice %>">
			<input type="hidden" name="mileshopitemprice" value="<%= oshoppingbag.GetMileageShopItemPrice %>">
			</form>

			<form name="frmWishPop" method="get" action="/apps/appcom/wish/web2014/common/popWishFolder.asp" style="margin:0px;">
			<input type="hidden" name="itemid" value="">
			<input type="hidden" name="ErBValue" value="5">
			<input type="hidden" name="bagarray" value="">
			<input type="hidden" name="folderAction" value="">
			</form>

			<iframe id="wishProc" name="wishProc" src="about:blank" frameborder="0px" width="0px" height="0px" style="display:block;"></iframe>
			<!-- //content area -->
		</div>
		<span id="gotop" class="goTop">TOP</span>
		<div id="modalLayer" style="display:none;"></div>
		<div id="modalLayer2" style="display:none;"><div id="modalLayer2Contents"></div><div id="dimed"></div></div>
	</div>
</div>

    <script>
        setTimeout(function(){fnAppierProductsLogEventProperties("view_shoppingbag", appier_shoppingbag_products);}, 50);

        const appierProductRemovedFromCart = function(idx){
            let appier_product_removed_from_cart_data = appier_shoppingbag_products[idx];
            delete appier_product_removed_from_cart_data.quantity;
            delete appier_product_removed_from_cart_data.total_goods_price;

            let appier_product_removed_from_cart_list = new Array();
            appier_product_removed_from_cart_list.push(appier_product_removed_from_cart_data);
            fnAppierProductsLogEventProperties("product_removed_from_cart", appier_product_removed_from_cart_list);
        }

        let appierProductToBeRemovedList = new Array();
        let appier_product_to_be_removed = new Object();
        const appierProductToBeRemoved = function(idx){
            appier_product_to_be_removed = appier_shoppingbag_products[idx];
            delete appier_product_to_be_removed.quantity;
            delete appier_product_to_be_removed.total_goods_price;

            appierProductToBeRemovedList.push(appier_product_to_be_removed);
        }
        const appierProductListRemovedFromCart = function(idx){
            setTimeout(function (){
                fnAppierProductsLogEventProperties("product_removed_from_cart", appierProductToBeRemovedList);
                initAppierProductToBeRemovedList()
            }, 100);
        }
        const initAppierProductToBeRemovedList = function(){
            appierProductToBeRemovedList = new Array();
        }
    </script>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/incLogScript.asp" -->
</body>
</html>
<%
	set oShoppingBag = Nothing
	set oMileageShop = Nothing
	set oSailCoupon  = Nothing
	set oItemCoupon  = Nothing
	set oems = Nothing
	set oemsPrice = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->