<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
'	History	:  2015.11.09 한용민 생성
'	History	:  2016-04-08 이종화 디자인 리뉴얼
'	Description : 포장 서비스
'#######################################################
%>
<!-- #include virtual="/login/checkBaguniLogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_couponcls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->

<%
dim idx
idx=0

Dim oTicketItem, TicketDlvType
Dim TicketBookingExired : TicketBookingExired=FALSE

dim userid, guestSessionID, i, j, isBaguniUserLoginOK
If IsUserLoginOK() Then
	userid = getEncLoginUserID ''GetLoginUserID
	isBaguniUserLoginOK = true
Else
	userid = GetLoginUserID
	isBaguniUserLoginOK = false
End If
guestSessionID = GetGuestSessionKey

'if not(isBaguniUserLoginOK) then
'	response.write "<script type='text/javascript'>alert('회원전용 서비스 입니다. 로그인을 해주세요.');</script>"
'	dbget.close()	:	response.end
'end if

dim oshoppingbag
set oshoppingbag = new Cpack
	oshoppingbag.FRectUserID = userid
	oshoppingbag.FRectSessionID = guestSessionID
	oshoppingbag.frectpojangok = "Y"

'	if (IsForeignDlv) then
'	    if (countryCode<>"") then
'	        oshoppingbag.FcountryCode = countryCode
'	    else
'	        oshoppingbag.FcountryCode = "AA"
'	    end if
'	elseif (IsArmyDlv) then
'	    oshoppingbag.FcountryCode = "ZZ"
'	else
		oshoppingbag.FcountryCode = "TT"
'	end if

	oshoppingbag.GetShoppingBag_pojangtemp_Checked(true)

dim vShoppingBag_pojang_checkValidItem, pojangcompleteyn
	vShoppingBag_pojang_checkValidItem=0
	pojangcompleteyn="N"

'/장바구니 상품과 선물포장 임시 상품이 유효한 상품인지 체크
vShoppingBag_pojang_checkValidItem = getShoppingBag_temppojang_checkValidItem("TT","Y")
if vShoppingBag_pojang_checkValidItem=1 then
	'//선물포장서비스 임시 테이블 비움
	call getpojangtemptabledel("")
	response.write "<script type='text/javascript'>alert('장바구니에 담긴 상품 수량 보다 선물포장이 된 상품 수량이 더많습니다.\n\n다시 포장해 주세요.');</script>"
	'dbget.close()	:	response.end
elseif vShoppingBag_pojang_checkValidItem=2 then
	response.write "<script type='text/javascript'>alert('장바구니에 담긴 상품이 없습니다.'); self.close();</script>"
	dbget.close()	:	response.end
elseif vShoppingBag_pojang_checkValidItem=3 then
	pojangcompleteyn="Y"
	'response.write "<script type='text/javascript'>alert('더이상 선물포장이 가능한 상품이 없습니다.');</script>"
	'dbget.close()	:	response.end
end if

Dim IsRsvSiteOrder, IsPresentOrder
	IsRsvSiteOrder = oshoppingbag.IsRsvSiteSangpumExists
	IsPresentOrder = oshoppingbag.IsPresentSangpumExists

dim oSailCoupon
set oSailCoupon = new CCoupon
oSailCoupon.FRectUserID = userid
oSailCoupon.FPageSize=100

if (userid<>"") and (Not IsRsvSiteOrder) and (Not IsPresentOrder) then   ''현장수령/Present 상품 쿠폰 사용 불가
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

'//선물포장 임시 패킹 리스트
dim opackmaster
set opackmaster = new Cpack
	opackmaster.FRectUserID = userid
	opackmaster.FRectSessionID = guestSessionID
	opackmaster.frectchkpojang = "Y"
	opackmaster.Getpojangtemp_master()

dim vShoppingBag_checkset
	vShoppingBag_checkset=0

vShoppingBag_checkset = getShoppingBag_checkset("TT")		'실제 장바구니 수량		TT:텐배
%>

<!-- #include virtual="/lib/inc/head.asp" -->
<script type="text/javascript">
$(function(){
	// floatingbar control
	$('.controller').click(function(){
		if($('.pkgGroupV16a').hasClass('pkgOpenV16a')){
			$(this).parent().removeClass('pkgOpenV16a');
			$(this).parent().addClass('pkgCloseV16a');
		} else {
			$(this).parent().removeClass('pkgCloseV16a');
			$(this).parent().addClass('pkgOpenV16a');
		}
	});

	var swiper = new Swiper('.swiper-container', {
		pagination:false,
		slidesPerView:'auto',
		spaceBetween:10
	});

	// 하단 플로팅바 표시
	var winH = $(window).height();
	var contH = $(".container").outerHeight();
	<% if opackmaster.FResultCount > 0 then %>
	<% else %>
	if (winH > contH) {
		$(".packFloatBarV16a").css('display','none');
	}
	<% end if %>
	$(window).scroll(function(){
		var vSpos = $(window).scrollTop() + $(window).height();
		var docuH = $(".cartV16a .btnAreaV16a").offset().top;

		if (vSpos < docuH){
			if($(".packFloatBarV16a").css("display")=="none"){
				$(".packFloatBarV16a").show();
			}
		} else if ($('.packFloatBarV16a').hasClass('lyrPkgWrapV16a')) {
			$(".packFloatBarV16a").show();
		} else {
			$(".packFloatBarV16a").fadeOut("fast");
		}
	});

	<%
	'/단품일경우 바로 다음단계 로직을 태움.
	' if vShoppingBag_checkset=0 then
	%>
		//onedirectNextSelected();
	<% ' end if %>
});

<% '단품일경우 다음 단계 프로세스를 강제로 태우기 %>
function onedirectNextSelected(){
    var frm = document.baguniFrm;

	frm.chk_item.checked = true;
	NextSelected();
}

function pojangcomplete(){
    self.close();
}

function fnCheckAll(comp){
    var frm = document.baguniFrm;
    var p = comp.name;

    if (frm.chk_item){
        if (frm.chk_item.length){
            for(var i=0;i<frm.chk_item.length;i++){
				frm.chk_item[i].checked = comp.checked;
            }
        }else{
			frm.chk_item.checked = comp.checked;
        }
    }
}

function chpojangdel(midx){
	if (midx==''){
		alert('일렬번호가 없습니다.');
		return;
	}

	if(confirm("선물포장을 삭제 하시겠습니까?")){	
		pojangfrm.mode.value='pojangdel';
		pojangfrm.midx.value=midx;
		pojangfrm.action = "/inipay/pack/pack_process.asp";
		pojangfrm.submit();
	}
	return;
}

function NextSelected(){
    var frm = document.baguniFrm;
    var chkExists = false;
    var mitemExists = false;
    var oitemExists = false;
    var nitemExists = false;
    var titemCount = 0;        //Ticket
    var rstemCount = 0;        //현장수령상품
    var pitemCount = 0;        //Present상품
    var mitemttl = 0;
    var itemexistscnt=0;
	var limitpackitemcnt=0;
    var limitpackitemnocnt=0;
    pojangfrm.itemidarr.value = "";
	pojangfrm.itemoptionarr.value = "";
	pojangfrm.itemeaarr.value = "";

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
                    if (frm.soldoutflag[i].value == "Y"){
            			alert('품절된 상품은 구매하실 수 없습니다.');
            			frm.itemea[i].focus();
            			return;
            		}

					if (!IsDouble(frm.itemea[i].value)){
						alert('수량은 숫자만 가능합니다.');
						frm.itemea[i].focus();
						return;
					}

					itemexistscnt = parseInt(frm.bagitemea[i].value*1)-parseInt(frm.pojangitemno[i].value*1);
				    if ( frm.itemea[i].value*1 > itemexistscnt ){
				        alert('포장 가능한 수량을 초과 하였습니다.\n수량을 확인해주세요.');
				        return;
				    }

				    pojangfrm.itemidarr.value = pojangfrm.itemidarr.value + frm.itemid[i].value + ","
					pojangfrm.itemoptionarr.value = pojangfrm.itemoptionarr.value + frm.itemoption[i].value + ","
					pojangfrm.itemeaarr.value = pojangfrm.itemeaarr.value + frm.itemea[i].value + ","

					limitpackitemcnt = limitpackitemcnt + 1;
					limitpackitemnocnt = parseInt(limitpackitemnocnt) + parseInt(frm.itemea[i].value*1)
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
        			alert('품절된 상품은 구매하실 수 없습니다.');
        			frm.itemea.focus();
        			return;
        		}

				if (!IsDouble(frm.itemea.value)){
					alert('수량은 숫자만 가능합니다.');
					frm.itemea.focus();
					return;
				}

				itemexistscnt = parseInt(frm.bagitemea.value*1)-parseInt(frm.pojangitemno.value*1);

			    if ( frm.itemea.value*1 > itemexistscnt ){
			        alert('포장 가능한 수량을 초과 하였습니다.\n수량을 확인해주세요.');
			        return;
			    }

			    pojangfrm.itemidarr.value = pojangfrm.itemidarr.value + frm.itemid.value
				pojangfrm.itemoptionarr.value = pojangfrm.itemoptionarr.value + frm.itemoption.value
				pojangfrm.itemeaarr.value = pojangfrm.itemeaarr.value + frm.itemea.value

				limitpackitemcnt = 1;
				limitpackitemnocnt = parseInt(frm.itemea.value*1)
            }
        }
    }

    if (!chkExists){
        alert('선택된 상품이 없습니다.\n포장하실 상품을 선택 후 진행해 주세요.');
		return;
    }

    if (rstemCount>0){
        alert('현장수령 상품은 포장 하실수 없습니다.');
        return;
    }

    if (limitpackitemcnt>10){
        alert('특별하고 예쁜 포장을 위해\n포장 상품 개수는 10개로 제한됩니다.');
        return;
    }
    if (limitpackitemnocnt>10){
        alert('특별하고 예쁜 포장을 위해\n포장 상품 개수는 10개로 제한됩니다.');
        return;
    }

	pojangfrm.mode.value='add_step1';
	pojangfrm.midx.value='';
	pojangfrm.action = "/inipay/pack/pack_process.asp";
	pojangfrm.submit();
	return;
}

function gostep2edit(midx){
	if (midx==''){
		alert('일렬번호가 없습니다.');
		return;
	}

	pojangfrm.midx.value=midx;
	pojangfrm.action = "/inipay/pack/pack_step2.asp";
	pojangfrm.submit();
	return;
}

function IsDouble(v){
	if (v.length<1) return false;

	for (var j=0; j < v.length; j++){
		if ("0123456789.".indexOf(v.charAt(j)) < 0) {
			return false;
		}
	}
	return true;
}

//마우스 오른쪽 클릭 막음		//2015.12.15 한용민 생성
window.document.oncontextmenu = new Function("return false");
//새창 띄우기 막음		//2015.12.15 한용민 생성
window.document.onkeydown = function(e){    	//Crtl + n 막음
    if(typeof(e) != "undefined"){
        if((e.ctrlKey) && (e.keyCode == 78)) return false;
    }else{
        if((event.ctrlKey) && (event.keyCode == 78)) return false;
    }
}
//드레그 막음		//2015.12.15 한용민 생성
window.document.ondragstart = new Function("return false");

</script>
</head>
<body>
<div class="heightGrid" style="background-color:#e7eaea;">
	<div class="container popWin pkgV16a02">
		<div class="header">
			<h1>선물포장</h1>
			<p class="btnPopClose"><button class="pButton" onclick="window.close();">닫기</button></p>
		</div>
		<div class="content" id="contentArea">
			<%
			'/<!-- for dev msg : 포장할 상품 있을때 -->
			if pojangcompleteyn="N" then
			%>
			<div class="pkgWrapV16a">
				<div class="pkgStepV16a">
					<ul>
						<li class="step1 current"><p><span>상품선택</span></p></li>
						<li class="step2 "><p><span>메시지입력</span></p></li>
						<li class="step3 "><p><span>포장완료</span></p></li>
					</ul>
				</div>
				<div class="cartV16a">
				<form name="baguniFrm" method="post" onSubmit="return false" style="margin:0px;" >
				<input type="hidden" name="mode">

					
					<div class="cartGroup">
						<div class="bxLGy2V16a allOptV16a">
							<p><input type="checkbox" name="chk_all" onClick="fnCheckAll(this);" /> <span class="txtAllSltV16a">전체선택</span></p>
						</div>
						<% if oshoppingbag.FShoppingBagItemCount > 0 then %>
						<div class="cartGrpV16a">
							<ul class="cartListV16a">
									<%
									for i=0 to oshoppingbag.FShoppingBagItemCount - 1
									
									if oshoppingbag.FItemList(i).FItemEa > oshoppingbag.FItemList(i).fpojangitemno Then
									%>
										<%
										TicketBookingExired = FALSE
										IF (oshoppingbag.FItemList(i).IsTicketItem) then
												set oTicketItem = new CTicketItem
												oTicketItem.FRectItemID = oshoppingbag.FItemList(0).FItemID
												oTicketItem.GetOneTicketItem
												IF (oTicketItem.FResultCount>0) then
														TicketBookingExired = oTicketItem.FOneItem.IsExpiredBooking
														TicketDlvType = oTicketItem.FOneItem.FticketDlvType
												END IF
												set oTicketItem = Nothing
										end if
										%>
										<li class="bxWt1V16a <% if (oshoppingbag.FItemList(i).IsSoldOut or TicketBookingExired) then response.write " soldOut" end if %>">
											<div class="pdtWrapV16a">
												<div class="pdtNameV16a">
													<input type="checkbox" name="chk_item" id="<%= oshoppingbag.FItemList(i).FItemID & oshoppingbag.FItemList(i).FItemoption %>" value="ON" />
													<h3><%= oshoppingbag.FItemList(i).FItemName %></h3>
												</div>
												<div class="pdtInfoV16a">
													<p class="pdtPicV16a">
														<img src="<%= oshoppingbag.FItemList(i).FImageList %>" alt="<%= oshoppingbag.FItemList(i).FItemName %>" />
													</p>
													<% if oshoppingbag.FItemList(i).getOptionNameFormat<>"" then %>
													<div class="pdtOptionV16a">
														<span class="fs1-1r cLGy1V16a"><%= oshoppingbag.FItemList(i).getOptionNameFormat %></span>
													</div>
													<% end if %>
													<div class="pdtNumV16a">
														<select name="itemea" style="min-width:5.75rem" title="수량변경이 가능합니다">
															<% for j=0 to (oshoppingbag.FItemList(i).FItemEa-oshoppingbag.FItemList(i).fpojangitemno) -1 %>
															<option><%= j+1 %></option>
															<% next %>
														</select>/ <%= oshoppingbag.FItemList(i).FItemEa-oshoppingbag.FItemList(i).fpojangitemno %>
													</div>
													<input type="hidden" name="bagitemea" value="<%= oshoppingbag.FItemList(i).FItemEa %>" />
													<input type="hidden" name="pojangitemno" value="<%= oshoppingbag.FItemList(i).fpojangitemno %>" />
												</div>
											</div>
										</li>
										<input type="hidden" name="distinctkey" value="<%= i %>">
										<input type="hidden" name="itemkey" value="<%=oshoppingbag.FItemList(i).FItemID %>_<%=oshoppingbag.FItemList(i).FItemOption %>">
										<input type="hidden" name="itemid" value="<%= oshoppingbag.FItemList(i).FItemID %>">
										<input type="hidden" name="itemoption" value="<%= oshoppingbag.FItemList(i).FItemoption %>">
										<input type="hidden" name="soldoutflag" value="<% if (oshoppingbag.FItemList(i).IsSoldOut or TicketBookingExired) then response.write "Y" else response.write "N" end if %>">
										<input type="hidden" name="foreignflag" value="<% if oshoppingbag.FItemList(i).IsForeignDeliverValid then response.write "Y" else response.write "N" end if %>">
										<input type="hidden" name="itemcouponsellpriceflag" value="<%= oshoppingbag.FItemList(i).GetCouponAssignPrice %>">
										<input type="hidden" name="curritemcouponidxflag" value="<%= oshoppingbag.FItemList(i).Fcurritemcouponidx %>">
										<input type="hidden" name="itemsubtotalflag" value="<%= oshoppingbag.FItemList(i).GetCouponAssignPrice * oshoppingbag.FItemList(i).FItemEa %>">
										<input type="hidden" name="couponsailpriceflag" value="<%= (oshoppingbag.FItemList(i).getRealPrice-oshoppingbag.FItemList(i).GetCouponAssignPrice) * oshoppingbag.FItemList(i).FItemEa %>">
										<input type="hidden" name="dtypflag" value="<%=oshoppingbag.FItemList(i).Fdeliverytype%>">

										<% if oshoppingbag.FItemList(i).Is09Sangpum then %>
											<input type="hidden" name="mtypflag" value="o">
										<% elseif oshoppingbag.FItemList(i).IsTicketItem then %>
											<input type="hidden" name="mtypflag" value="t">
										<% elseif oshoppingbag.FItemList(i).IsPresentItem then %>
											<input type="hidden" name="mtypflag" value="p">
										<% elseif oshoppingbag.FItemList(i).IsMileShopSangpum then %>
											<input type="hidden" name="mtypflag" value="m">
										<% elseif oshoppingbag.FItemList(i).IsReceiveSite then %>
											<input type="hidden" name="mtypflag" value="r">
										<% else %>
											<input type="hidden" name="mtypflag" value="">
										<% end if %>

										<input type="hidden" name="isellprc" value="<%= oshoppingbag.FItemList(i).getRealPrice %>">
										<% idx = idx +1 %>
									<% end if %>
									<% next %>
							</ul>
						</div>
						<% If (idx > 0 Or vShoppingBag_checkset=0) And opackmaster.FResultCount < 1 then '상품이 1개 이상 혹은 단품일떄만 노출 %>
						<div class="btnAreaV16a" >
							<p><button type="button" class="btnV16a btnRed2V16a" onclick="NextSelected(); return false;">선택상품 포장하기</button></p>
						</div>
						<% End If %>
						<% end if %>
					</div>
				</form>
				</div>
				<% else %>
				<% '<!-- for dev msg : 포장할 상품 없을때 --> %>
				<div class="pkgPdtNoneV16a">
					<p><strong>모든 상품이 선물포장 되었습니다.</strong></p>
					<p class="tPad10 lh14">포장 내역 확인 또는 메시지 수정 시<br />아래 선물상자 아이콘을 선택해주세요.</p>
				</div>
				<% end if %>
			</div>
		</div>
		<% '<!-- for dev msg : 포장그룹생성후에 클래스 lyrPkgWrapV16a 붙여주세요(처음 포장상품 선택시에는 클래스 빼주세요) --> %>
		<div class="packFloatBarV16a <% if opackmaster.FResultCount > 0 then %>lyrPkgWrapV16a<% end if %>">
			<div class="pkgGroupV16a pkgOpenV16a">
				<div class="controller"><span>완성된 선물상자 (<%= opackmaster.FResultCount %>)</span></div>
				<div class="groupViewV16a">
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<% if opackmaster.FResultCount > 0 then %>
							<% for i=0 to opackmaster.FResultCount - 1 %>
							<div class="swiper-slide" midx="<%= opackmaster.FItemList(i).Fmidx %>">
								<% '<!-- for dev msg : 포장에 메세지 입력된경우 msgHaveV16a 클래스 추가해주세요 --> %>
								<div class="pkgBoxV16a <% if opackmaster.FItemList(i).Fmessage<>"" then response.write " msgHaveV16a" %>" onclick="gostep2edit('<%= opackmaster.FItemList(i).Fmidx %>'); return false;">
									<%= opackmaster.FItemList(i).Fpackitemcnt %><i>포장메세지</i>
								</div>
								<p><%= opackmaster.FItemList(i).Ftitle %></p>
								<span class="button btnV16a"><a href="" onclick="chpojangdel('<%= opackmaster.FItemList(i).Fmidx %>'); return false;">삭제</a></span>
							</div>
							<% next %>
							<% end if %>
						</div>
					</div>
				</div>
			</div>
			<div class="btnAreaV16a">
				<%
				'/포장한 내역이 있을경우
				if opackmaster.FResultCount < 1 then
				%>
					<p><button type="button" class="btnV16a btnRed2V16a" onclick="NextSelected(); return false;">선택상품 포장하기</button></p>
				<% else %>
					<%
					'/<!-- for dev msg : 포장할 상품 있을때 -->
					if pojangcompleteyn="N" then
					%>
						<p><button type="button" class="btnV16a btnRed2V16a" onclick="NextSelected(); return false;">선택상품 포장하기</button></p>
					<% else %>
						<p><button type="button" class="btnV16a btnRed2V16a" onclick="pojangcomplete(); return false;">포장완료</button></p>
					<% end if %>
				<% end if %>
			</div>
		</div>
	</div>
</div>
<form name="pojangfrm" method="post" action="" style="margin:0px;">
<input type="hidden" name="mode">
<input type="hidden" name="midx">
<input type="hidden" name="itemidarr">
<input type="hidden" name="itemoptionarr">
<input type="hidden" name="itemeaarr">
</form>
</body>
</html>

<%
set oshoppingbag=nothing
set oSailCoupon=nothing
set opackmaster=nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->