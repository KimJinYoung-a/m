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
<script type="application/x-javascript" src="/lib/js/iui_clickEffect.js"></script>
<script type="application/x-javascript" src="/lib/js/itemPrdDetail.js"></script>

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


	vQuery = "SELECT couponno, itemoption, optionname, isNull(requiredetail,'') AS requiredetail From [db_order].[dbo].[tbl_mobile_gift] Where idx = '" & vIdx & "' AND gubun = 'giftting'"
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
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
<div class="toolbar">
	<!--- 로그인시 아이디 노출 ---->
	<!--<% if IsUserLoginOK then %><div id="top_login"><%=GetLoginUserID %>님, 즐거운 하루되세요!</div><% end if %> -->
</div>
	<div class="content" id="contentArea">
		<div id="kakao_gifting">
			<h2>배송지 정보입력</h2>
			<div class="gifting_product">
				<ul>
					<li class="cNum">
						<table width="95%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th class="lt" width="70px"><label for="couponno">쿠폰 번호</label></th>
							<td><input name="couponno" id="couponno" type="text" class="text cc91314" value="<%=vCouponNO%>" style="width:95%;" /></td>
						</tr>
						</table>
					</li>
					<li>
						<div class="gifting_pd">
							<div>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td class="pd_image">
									<% if ImageExists(oitem.Prd.FImageList) then %>
										<p><img src="<%= oitem.Prd.FImageList %>" width="90" height="90"></p>
									<% end if %>
									</td>
									<td>
										<div class="pd_info">
											<p class="brand">[<%= UCase(oItem.Prd.FBrandName) %>]</p>
											<p class="name"><%= oItem.Prd.FItemName %></p>
											<!--옵션 적용 후-->
											<% If vItemOption <> "" Then %>
												<p class="option_apply">선택옵션 : <span class="select"><%=vOptionname%></span></p>
											<% End If %>
										</div>
									</td>
								</tr>
								</table>
							</div>
							<div class="option">
							<form name="frm1" method="post" action="option_select_proc.asp">
							<input type="hidden" name="idx" value="<%=vIdx%>">
							<input type="hidden" name="itemid" value="<%=vItemID%>">
							<input type="hidden" name="itemoption" value="">
								<p class="tit">해당상품은 옵션이 있는 상품입니다.<br/>옵션을 선택해주세요.</p>
								<div class="apply">
									<dl>
										<dt><label for="kakao_option">옵션선택</label></dt>
										<dd><%=ioptionBoxHtml%></dd>
										<dd>
										<% if oItem.Prd.FItemDiv = "06" then %>
										<!--주문메세지의 경우-->
										<textarea name="requiredetail" cols="" rows="" class="pd_option" style="height:70px; padding:5px 0 0 0;"><%=vRequiredetail%></textarea>
										<% End If %>
										</dd>
									</dl>
									<div class="btn_apply"><span class="btn btn4 redB w40B"><a href="javascript:optionsave();">적용</a></span></div>
								</div>
							</form>
							</div>
						</div>
					</li>
				</ul>
			</div>
		</div>
		<div style="clear:both"></div>
	</div>

		</div>
		<!-- #include virtual="/lib/inc/incFooter.asp" -->
	</div>
	 <!-- #include virtual="/category/incCategory.asp" -->
</div>
<% Set oItem = Nothing %>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->