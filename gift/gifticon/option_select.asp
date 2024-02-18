<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->
<%
	Dim vQuery, vIdx, vResult, vItemID, vItemOption, vOptionname, vRequiredetail, vCouponNO
	vIdx 	= requestCheckVar(request("idx"),10)
	vItemID = requestCheckVar(request("itemid"),10)

	If vIdx = "" Then
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
		dbget.close()
		Response.End
	End If
	IF IsNumeric(vIdx) = false Then
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
		dbget.close()
		Response.End
	End If
	
	
	vQuery = "SELECT couponno, itemoption, optionname, isNull(requiredetail,'') AS requiredetail From [db_order].[dbo].[tbl_mobile_gift] Where idx = '" & vIdx & "' AND gubun = 'gifticon'"
	rsget.Open vQuery,dbget,1
	IF Not rsget.EOF THEN
		vCouponNO		= rsget("couponno")
		vItemOption 	= rsget("itemoption")
		vOptionname		= rsget("optionname")
		vRequiredetail 	= db2html(rsget("requiredetail"))
	End IF
	rsget.close
	
	
	dim oItem, ItemContent
	set oItem = new CatePrdCls
	oItem.GetItemData vItemID
	
	if oItem.FResultCount=0 then
		Call Alert_Return("존재하지 않는 상품입니다.")
		response.End
	end if

	if oItem.Prd.Fisusing="N" then
		Call Alert_Return("판매가 종료되었거나 삭제된 상품입니다.")
		response.End
	end if
	
	
	'//옵션 HTML생성
	dim ioptionBoxHtml
	IF (oitem.Prd.FOptionCnt>0) then
	    ioptionBoxHtml = GetOptionBoxHTML(vItemID, oitem.Prd.IsSoldOut)
	End IF
	
	function ImageExists(byval iimg)
		if (IsNull(iimg)) or (trim(iimg)="") or (Right(trim(iimg),1)="\") or (Right(trim(iimg),1)="/") then
			ImageExists = false
		else
			ImageExists = true
		end if
	end function
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/oldContent.css">
<title>10x10: 배송지 정보입력</title>
<script type="application/x-javascript" src="/lib/js/iui_clickEffect.js"></script>
<script type="application/x-javascript" src="/lib/js/itemPrdDetail.js"></script>
<script>
$(function(){
	/* layer popup for dropdown */
	$.fn.layerOpen = function(options) {
		return this.each(function() {
			var $this = $(this);
			var $layer = $($this.attr("href") || null);
			$this.click(function() {
				$layer.attr("tabindex",0).show().focus();
				dropdownScrollLayer.update();
				$layer.find(".btnClose, .btnDrop").one("click",function () {
					$layer.hide();
					$this.focus();
				});
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
</script>
<script language="javascript">
// 장바구니에 상품을 담기 
function optionsave(){
    var frm = document.frm1;
    var optCode = "0000";

    var MOptPreFixCode="Z";

    if (!frm.item_option){
        //옵션 없는경우

    }else if (!frm.item_option[0].length){
        //단일 옵션
        if (frm.item_option.value.length<1){
            alert('옵션을 선택 하세요.');
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

		if (frm.requiredetail.value.length<1){
			alert('주문 제작 상품 문구를 작성해 주세요.');
			frm.requiredetail.focus();
			return;
		}

		if(GetByteLength(frm.requiredetail.value)>255){
			alert('문구 입력은 한글 최대 120자 까지 가능합니다.');
			frm.requiredetail.focus();
			return;
		}
	}
	frm.submit();
}
</script>
</head>
<body class="default-font body-sub bg-grey">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<!-- contents -->
	<div id="content" class="content gifticon gifticon-item">
		<div class="gifticon-section">
			<div class="items type-list">
				<div class="thumbnail">
					<% if ImageExists(oitem.Prd.FImageList) then %>
					<img src="<%= oitem.Prd.FImageList %>" alt="<%= oItem.Prd.FItemName %>" />
					<% end if %>
				</div>
				<div class="desc">
					<p class="name">[<%= UCase(oItem.Prd.FBrandName) %>] <%= oItem.Prd.FItemName %></p>
				</div>
			</div>

			<div class="itemFloatingV17">
			<form name="frm1" method="post" action="option_select_proc.asp">
			<input type="hidden" name="idx" value="<%=vIdx%>">
			<input type="hidden" name="itemid" value="<%=vItemID%>">
			<input type="hidden" name="itemoption" value="">
				<div class="itemOptWrapV16a">
					<div class="itemOptV16a">
						<div class="itemoption">
							<%=ioptionBoxHtml%>
						</div>
						<% if oItem.Prd.FItemDiv = "06" then %>
						<div class="rqtxt onlyTxt tPad0-9r">
							<div class="txtBoxV16a current">
								<textarea name="requiredetail" placeholder="[문구입력란] 문구를 입력해 주세요!"><%=vRequiredetail%></textarea>
							</div>
						</div>
						<% End If %>
					</div>
				</div>
			</form>
			</div>
		</div>
		<div class="btn-group">
			<button type="submit" class="btn btn-xlarge btn-red btn-block" onClick="optionsave();">확인</a>
		</div>
	</div>
	<!-- //contents -->
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<% Set oItem = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->