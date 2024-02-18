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
dim midx
	midx = getNumeric(requestcheckvar(request("midx"),10))

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

if midx="" or isnull(midx) then
	response.write "<script type='text/javascript'>alert('일렬번호가 없습니다.');</script>"
	dbget.close()	:	response.end
end if

'//선물포장 임시 패킹 리스트
dim opackmaster
set opackmaster = new Cpack
	opackmaster.FRectUserID = userid
	opackmaster.FRectSessionID = guestSessionID
	opackmaster.frectmidx = midx
	opackmaster.Getpojangtemp_master()

if opackmaster.FResultCount < 1 then
	response.write "<script type='text/javascript'>alert('해당 선물 포장 내역이 없습니다.');</script>"
	dbget.close()	:	response.end
end if

dim message, title
	message = opackmaster.FItemList(0).Fmessage
	title = opackmaster.FItemList(0).Ftitle

dim opackdetail
set opackdetail = new Cpack
	opackdetail.FRectUserID = userid
	opackdetail.FRectSessionID = guestSessionID
	opackdetail.frectmidx = midx
	opackdetail.frectpojangok = "Y"

'	if (IsForeignDlv) then
'	    if (countryCode<>"") then
'	        opackdetail.FcountryCode = countryCode
'	    else
'	        opackdetail.FcountryCode = "AA"
'	    end if
'	elseif (IsArmyDlv) then
'	    opackdetail.FcountryCode = "ZZ"
'	else
		opackdetail.FcountryCode = "TT"
'	end if

	opackdetail.Getpojangtemp_detail(true)

Dim IsRsvSiteOrder, IsPresentOrder
	IsRsvSiteOrder = opackdetail.IsRsvSiteSangpumExists
	IsPresentOrder = opackdetail.IsPresentSangpumExists

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

dim vShoppingBag_checkset
	vShoppingBag_checkset=0

vShoppingBag_checkset = getShoppingBag_checkset("TT")		'실제 장바구니 수량		TT:텐배

%>

<!-- #include virtual="/lib/inc/head.asp" -->
<script type="text/javascript">
$(function() {
//    $(document).keydown(function(event) {
//        if (event.ctrlKey==true && (event.which == '118' || event.which == '86')) {
//            event.preventDefault();
//         }
//    });

	// 하단 플로팅바 표시
	var winH = $(window).height();
	var contH = $(".container").outerHeight();
	if (winH > contH) {
		$(".packFloatBarV16a").css('display','none');
	}
	$(window).scroll(function(){
		var vSpos = $(window).scrollTop() + $(window).height();
		var docuH = $(".orderListV16a .btnAreaV16a").offset().top;

		if (vSpos < docuH){
			if($(".packFloatBarV16a").css("display")=="none"){
				$(".packFloatBarV16a").show();
			}
		} else {
			$(".packFloatBarV16a").fadeOut("fast");
		}
	});

	<% if opackmaster.FItemList(0).Fpackitemcnt>0 then %>
		lengthcheck(pojangfrm.message);
	<% end if %>
});

function gostep1reset(midx){
	if (midx==''){
		alert('일렬번호가 없습니다.');
		return;
	}

	pojangfrm.mode.value='reset_step1';
	pojangfrm.midx.value=midx;
	pojangfrm.action = "/inipay/pack/pack_process.asp";
	pojangfrm.submit();
	return;
}

function lengthcheck(val){
	var len = val.value.length;
	if (len >= 101) {
		val.value = val.value.substring(0, 100);
	} else {
		$("#messagecnt").text(len);
	}
}
function lengthcheck2(val){
	var len = val.value.length;
	if (len >= 61) {
		val.value = val.value.substring(0, 60);
	}
}

//라인수체크		'//2015.12.11 한용민 생성
function fn_TextAreaLineLimit() {
    var tempText = $("textarea[name='message']").val();
    var lineSplit = tempText.split("\n");                //

    // 최대라인수 제어
    if(lineSplit.length >= 10 && event.keyCode == 13) {
        alert("선물 메세지는 10줄까지만 작성이 가능 합니다.");
        //event.returnValue = false;		//웹표준이 아님
        event.preventDefault(); 		//웹표준이긴한데.. 구형 브라우져에서 고장남.
    }
    return false;
}

function NextSelected(midx){
	if (midx==''){
		alert('일렬번호가 없습니다.');
		return;
	}
	if (pojangfrm.title.value == ''){
		alert("선물포장명을 입력해주세요.");
		pojangfrm.title.focus();
		return;
	}
//	if (GetByteLength(pojangfrm.title.value) > 60){
//		alert("선물 포장명이 제한길이를 초과하였습니다. 60자 까지 작성 가능합니다.");
//		pojangfrm.title.focus();
//		return;
//	}
//	if (pojangfrm.message.value != '' && GetByteLength(pojangfrm.title.value) > 100){
//		alert("선물 메세지가 제한길이를 초과하였습니다. 100자 까지 작성 가능합니다.");
//		pojangfrm.message.focus();
//		return;
//	}

	pojangfrm.mode.value='add_step2';
	pojangfrm.midx.value=midx;
	pojangfrm.action = "/inipay/pack/pack_process.asp";
	pojangfrm.submit();
	return;
}

function NextSelectedgostep1(midx, returnurl){
	if (midx==''){
		alert('일렬번호가 없습니다.');
		return;
	}
	if (pojangfrm.title.value == ''){
		alert("선물포장명을 입력해주세요.");
		pojangfrm.title.focus();
		return;
	}
//	if (GetByteLength(pojangfrm.title.value) > 60){
//		alert("선물 포장명이 제한길이를 초과하였습니다. 60자 까지 작성 가능합니다.");
//		pojangfrm.title.focus();
//		return;
//	}
//	if (pojangfrm.message.value != '' && GetByteLength(pojangfrm.title.value) > 100){
//		alert("선물 메세지가 제한길이를 초과하였습니다. 100자 까지 작성 가능합니다.");
//		pojangfrm.message.focus();
//		return;
//	}
	if(confirm("수정하시겠습니까?")){	
		pojangfrm.mode.value='add_step2';
		pojangfrm.midx.value=midx;
		pojangfrm.returnurl.value=returnurl;
		pojangfrm.action = "/inipay/pack/pack_process.asp";
		pojangfrm.submit();
	}
	return;
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
			<div class="pkgWrapV16a">
				<% '<!-- for dev msg : 단품 포장일 경우 노출 안됩니다. --> %>
				<%' if not(opackmaster.FItemList(0).Fpackitemcnt>0 or vShoppingBag_checkset=0) then %>
				<div class="pkgStepV16a">
					<ul>
						<li class="step1 "><p><span>상품선택</span></p></li>
						<li class="step2 current"><p><span>메시지입력</span></p></li>
						<li class="step3 "><p><span>포장완료</span></p></li>
					</ul>
				</div>
				<%' end if %>
				<form name="pojangfrm" method="post" action="" style="margin:0px;" onsubmit="return false;">
				<input type="hidden" name="mode">
				<input type="hidden" name="midx">
				<input type="hidden" name="returnurl">
				<div class="pkgMsgInputV16a">
					<% '<!-- for dev msg : 단품 포장일 경우만 노출 --> %>
					<% if vShoppingBag_checkset=0 then %>
						<!--<p class="ct bPad15 fs12">포장안에 들어갈 <span class="cRd1">메시지를 입력</span>해주세요.</p>-->
					<% end if %>

					<% '<!-- for dev msg : 묶음포장 메세지 입력 경우만 노출됩니다. --> %>
					<% if vShoppingBag_checkset=1 then %>
						<ul class="spcNotiV16a">
							<li>선물포장명은 포장을 구분하기 위한 이름입니다.</li>
						</ul>
					<% end if %>

					<% '<!-- for dev msg : 묶음 포장일 경우만 노출 --> %>
					<% if vShoppingBag_checkset=1 then %>
						<p><input type="text" name="title" value="<%= title %>" onkeyup="lengthcheck2(this);" placeholder="<% if title="" then %>선물포장명을 입력해주세요.<% end if %>" style="width:100%;" /></p>
					<%
					'/장바구니단 에서 레알 단품 인것은 제목 입력창이 없어서 박아넣음
					else
					%>
						<input type="hidden" name="title" value="선물포장" />
					<% end if %>

					<div>
						<p><textarea name="message" onkeyup="lengthcheck(this);" onkeydown="fn_TextAreaLineLimit();" style="width:100%;" rows="6" placeholder="<% if message="" then %>선물과 함께 보낼 메시지를 입력해주세요.<% end if %>"><%= message %></textarea></p>
						<p class="rt"><span id="messagecnt">1</span>/100</p>
					</div>
				</div>
				<% if opackdetail.FShoppingBagItemCount > 0 then %>
				<div class="orderListV16a ">
					<div class="bxWt1V16a">
						<ul class="cartListV16a">
							<% for i=0 to opackdetail.FShoppingBagItemCount - 1 %>
							<li class="bxWt1V16a">
								<div class="pdtWrapV16a">
									<p class="pdtPicV16a">
										<img src="<%= opackdetail.FItemList(i).FImageList %>" alt="<%= opackdetail.FItemList(i).FItemName %>" />
									</p>
									<div class="pdtInfoV16a">
										<div class="pdtNameV16a">
											<h3><%= opackdetail.FItemList(i).FItemName %></h3>
										</div>
										<% if opackdetail.FItemList(i).getOptionNameFormat<>"" then %>
										<p class="pdtOptionV16a">
											<span class="fs1-1r cLGy1V16a"><%= opackdetail.FItemList(i).getOptionNameFormat %></span>
										</p>
										<% end if %>
										<p class="pkgNumChkV16a">수량 : <span class="cBk1V16a"><%= opackdetail.FItemList(i).fpojangitemno %></span>개</p>
									</div>
								</div>
							</li>
							<% next %>
						</ul>
					</div>
					<div class="btnAreaV16a">
						<% If vShoppingBag_checkset <> 0 Then %>
						<p style="width:50%; padding-right:0.5rem;"><button type="button" class="btnV16a btnRed1V16a" onclick="gostep1reset('<%= midx %>'); return false;">상품 다시 선택하기</button></p>
						<% End If %>
						<p style="width:50%;"><button type="button" class="btnV16a btnRed2V16a" onclick="NextSelected('<%= midx %>'); return false;">입력 완료</button></p>
					</div>
				</div>
				<% end if %>
				</form>
			</div>
		</div>

		<div class="packFloatBarV16a">
			<div class="btnAreaV16a">
				<%' <!-- for dev msg : 메세지 수정하러 왔을때 아래 버튼 하나만 노출됩니다.--> %>
				<% if opackmaster.FItemList(0).Fpackitemcnt>0 then %>
					<p><button type="button" class="btnV16a btnRed2V16a" onclick="NextSelectedgostep1('<%= midx %>','STEP1'); return false;">입력 완료</button></p>
				<% '<!-- for dev msg : 단품 포장 메세지 입력의 경우 아래 버튼 하나만 노출됩니다.--> %>
				<% elseif vShoppingBag_checkset=0 then %>
					<p><button type="button" class="btnV16a btnRed2V16a" onclick="NextSelected('<%= midx %>'); return false;">입력 완료</button></p>
				<% Else %>
					<p style="width:50%; padding-right:0.5rem;"><button type="button" class="btnV16a btnRed1V16a" onclick="gostep1reset('<%= midx %>'); return false;">상품 다시 선택하기</button></p>
					<p style="width:50%;"><button type="button" class="btnV16a btnRed2V16a" onclick="NextSelected('<%= midx %>'); return false;">입력 완료</button></p>
				<% end if %>
			</div>
		</div>
	</div>
</div>
</body>
</html>
<%
set opackdetail=nothing
set oSailCoupon=nothing
set opackmaster=nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->