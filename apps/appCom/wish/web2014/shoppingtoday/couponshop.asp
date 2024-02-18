<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
'####################################################
' Description :  쿠폰북
' History : 2014.06.25 한용민 생성
'               2014.11.12 원승현 수정
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/enjoy/couponshopcls.asp" -->


<%
Dim stab, vProdCouponCnt, vEventCouponCnt, vProdfreeCouponCnt, arritemList, cCouponMaster, intLoop, arrItem, intItem, k, stype
dim userid, cbonus_item_coupon_all, arrbonusitemlist,ix, strGubun
	stab = requestCheckVar(Request("stab"),5)
	stype = requestCheckVar(Request("stype"),1)
	userid = GetLoginUserID

vEventCouponCnt = 0
vProdCouponCnt	= 0
vProdfreeCouponCnt = 0

If stab = "" Then
	'stab = "all"
	stab = "sale"
	'stab = "free"
	'stab = "bonus"
End If
If stype = "" Then
	'stype = 1
	stype = 2
	'stype = 3
	'stype = 0
End If

'//상품쿠폰, 보너스쿠폰 한번에 다 가져옴
set cbonus_item_coupon_all = new ClsCouponShop
	arrbonusitemlist = cbonus_item_coupon_all.fnGetCouponList
Set cbonus_item_coupon_all = nothing

'//쿠폰 종류별로 카운트 셈
if isarray(arrbonusitemlist) then
	For intLoop = 0 To UBound(arrbonusitemlist,2)
		'//보너스 쿠폰
		If arrbonusitemlist(0,intLoop) ="event" Then
			vEventCouponCnt = vEventCouponCnt + 1
		
		'//상품 쿠폰
		Else
			'//무료배송 쿠폰
			IF arrbonusitemlist(2,intLoop) = 3 THEN
				vProdfreeCouponCnt = vProdfreeCouponCnt + 1
			
			'//할인쿠폰
			else
				vProdCouponCnt = vProdCouponCnt + 1
			end if		
		End IF
	Next

	if stab="sale" or stab="free" then
		'//상품쿠폰
		set cCouponMaster = new ClsCouponShop
			cCouponMaster.Ftype = stype
			arritemList = cCouponMaster.fnGetCouponTabList
	end if
end If
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->

<script style="text/javascript">
//$(function(){
	// COUPON BOOK TAB
	//$('.cpCont').hide();
	//$('.cpCont:first').show();
	//$('.couponTab li a').click(function(){
	//	$('.couponTab li').removeClass('currrent');
	//	$(this).parent().addClass('currrent');
	//	var currentTab = $(this).attr('href');
	//	$('.cpCont').hide();
	//	$(currentTab).show();
	//	return false;
	//});
//});

function changetab(stab,stype){
   self.location.href = "/apps/appcom/wish/web2014/shoppingtoday/couponshop.asp?stab="+stab+"&stype="+stype;
}

function PopItemCouponAssginList(iidx){
	//var popwin = window.open('/my10x10/Pop_CouponItemList.asp?itemcouponidx=' + iidx + '&tab=Y','PopItemCouponAssginList','width=700,height=800,scrollbars=yes,resizable=yes');
	//popwin.focus();
	fnAPPpopupBrowserURL('쿠폰 적용상품','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/Pop_CouponItemList.asp?itemcouponidx=' + iidx,'right','','sc');
//	top.location.href='/apps/appcom/wish/webview/my10x10/Pop_CouponItemList.asp?itemcouponidx=' + iidx + '&tab=Y'
}

function jsDownCoupon(stype,idx){
	if ("<%=IsUserLoginOK%>"=="False") {
		jsChklogin('<%=IsUserLoginOK%>');
		return;
	}

	var frm;
	frm = document.frmC;
	frm.stype.value = stype;
	frm.idx.value = idx;
	frm.submit();
}

function jsDownSelCoupon(sgubun,gubun){
	if ("<%=IsUserLoginOK%>"=="False") {
		jsChklogin('<%=IsUserLoginOK%>');
		return;
	}

	var chkCnt = 0;
	var stype = "";
	var idx = "";
	var frm = document.frmC;

	if(sgubun=="A"){
		if(frm.allidx){
			if (!frm.allidx.length){
				 stype = frm.allidx.stype;
				 idx = frm.allidx.value;
				 chkCnt = 1;
			} else {
				for(i=0;i<frm.allidx.length;i++) {
					if (chkCnt == 0 ) {
						stype = frm.allidx[i].getAttribute("stype");
						idx = frm.allidx[i].value;
					} else {
						stype =stype+"," +frm.allidx[i].getAttribute("stype");
						idx = idx+"," +frm.allidx[i].value;
					}
					chkCnt += 1;
				}
			}
		}else{
			alert("등록된 쿠폰이 없습니다.");
			return;
		}
	 }else{
		 if(frm.chkidx){
				if (!frm.chkidx.length){
					if (frm.chkidx.checked) {
						if(frm.chkidx.stype == gubun){
							stype = frm.chkidx.stype;
							idx = frm.chkidx.value;
							chkCnt = 1;
						}
					}
				}else{
					for(i=0;i<frm.chkidx.length;i++){
						if(frm.chkidx[i].getAttribute("stype") == gubun){
							if (frm.chkidx[i].checked) {
								if ( chkCnt == 0 ){
									stype = frm.chkidx[i].getAttribute("stype");
									idx = frm.chkidx[i].value;
								}else{
									stype =stype+"," +frm.chkidx[i].getAttribute("stype");
									idx = idx+"," +frm.chkidx[i].value;
								}
								chkCnt += 1;
							}
						}
					}
				}
			}else{
				alert("등록된 쿠폰이 없습니다.");
				return;
			}

		if ( chkCnt == 0 ){
			alert("다운받으실 쿠폰을 선택해 주세요.");
			return;
		}
	 }

	frm.stype.value = stype;
	frm.idx.value =idx;
	frm.submit();
}

</script>

<body class="default-font body-sub">
	<!-- contents -->
	<div id="content" class="content couponBook">
		<div class="cpNoti">
			<!--h2 class="tit01 tMar15">쿠폰북</h2-->
			<ul>
				<li>텐바이텐 회원을 위해 준비된 할인 쿠폰입니다. (비회원 적용 불가)</li>
				<li>발행된 모든 쿠폰은 [마이텐바이텐]에서 확인하실 수 있습니다.</li>
			</ul>
			<div class="btn-group">
				<span class="button btB1 btRed cWh1 w70p"><a href="" onclick="jsDownSelCoupon('A','event'); return false;">쿠폰 전체 다운받기<span class="icon icon-download"></span></a></span>
			</div>
		</div>
		<form name="frmC" method="post" action="/apps/appcom/wish/web2014/shoppingtoday/couponshop_process.asp" style="margin:0px;">
		<input type="hidden" name="stype" value="">
		<input type="hidden" name="idx" value="">

		<div class="bgSlash">
			<div class="cpTab">
				<ul class="tabNav tNum3">
					<li <% if stab="sale" then response.write " class='current'" %>><a href="#pdtCoupon" onclick="changetab('sale','2'); return false;">상품쿠폰<span>(<%=vProdCouponCnt%>)</span></a></li>
					<li <% if stab="bouns" then response.write " class='current'" %>><a href="#bonusCoupon" onclick="changetab('bouns','0'); return false;">보너스쿠폰<span>(<%=vEventCouponCnt%>)</span></a></li>
					<li <% if stab="free" then response.write " class='current'" %>><a href="#freeCoupon" onclick="changetab('free','3'); return false;">무료배송쿠폰<span>(<%=vProdfreeCouponCnt%>)</span></a></li>
				</ul>
				<%
				'//쿠폰 전체 다운받기
				If vProdCouponCnt > 0 or vEventCouponCnt >0  or vProdfreeCouponCnt>0 Then
				%>
					<% if isarray(arrbonusitemlist) then %>
						<% For intLoop = 0 To UBound(arrbonusitemlist,2) %>
							<input name="allidx" type="hidden" value="<%=arrbonusitemlist(1,intLoop)%>" stype="<%=arrbonusitemlist(0,intLoop)%>">
						<% Next %>
					<% end if %>
				<%	End If	%>


				<div class="tabContainer">
					<% if stab="sale" then %>
							<!-- 상품쿠폰 -->
							<div id="pdtCoupon" class="tabContent">
								<ul class="couponList">
									<%' If isarray(arritemList) Then %>
									<% If vProdCouponCnt > 0 Then %>
										<% For intLoop = 0 To UBound(arritemList,2) %>
											<% If arritemList(0,intLoop) <> "event" Then %>
												<li>
													<%
													cCouponMaster.Fitemcouponidx = arritemList(1,intLoop)
										
													arrItem = cCouponMaster.fnGetCouponItemList
								

													%>
													<div class="cpWrap">
														<% IF isArray(arrItem)	Then %>
															<div class="pic"><img src="<%=getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic/" & GetImageSubFolderByItemid(arrItem(0,intItem)) & "/" & arrItem(12,intItem),200,200,"true","false")%>" alt="<%=arrItem(4,intItem)%>" /></div>
														<% End If %>
														<div class="cpCont">
															<p class="t01">
																<% if arritemList(2,intLoop)="1" then %>
																	<%= arritemList(3,intLoop) %>%
																<% else %>
																	<%= arritemList(3,intLoop) %>원
																<% end if %>
															할인</p>
															<p class="t02"><%=chrbyte(db2html(arritemList(4,intLoop)),30,"Y")%></p>
															<p class="t03"><%=FormatDate(arritemList(7,intLoop),"0000/00/00")%> ~ <%=FormatDate(arritemList(8,intLoop),"0000/00/00")%></p>
														</div>
													</div>
													<div class="btnWrap">
														<p><span class="button btM2 btRed cWh1 w100p"><a href="" onclick="jsDownCoupon('<%=arritemList(0,IntLoop)%>','<%=arritemList(1,IntLoop)%>'); return false;">쿠폰다운받기<em class="downArr"></em></a></span></p>
														<p><span class="button btM2 btRedBdr cRd1 bgWht w100p"><a href="" onclick="PopItemCouponAssginList('<%=arritemList(1,intLoop)%>'); return false;">적용상품보기<em class="moreArr"></em></a></span></p>
													</div>
												</li>
											<% End If %>
										<% Next %>
									<% Else %>
										<!--  쿠폰 없을 경우 -->
										<li class="nodata nodata-default"><p>사용 가능한 상품쿠폰이 없습니다.</p></li>
										<!--// 쿠폰 없을 경우 -->
									<% End If %>
								</ul>
							</div>
							<!--// 상품쿠폰 -->
					<% end if %>

					<% if stab="bouns" then %>
						<!-- 보너스쿠폰 -->
						<div id="bonusCoupon" class="tabContent">
							<ul class="couponList">
								<%' If isarray(arrbonusitemlist) Then %>
								<% If vEventCouponCnt > 0 Then %>
									<% For intLoop = 0 To UBound(arrbonusitemlist,2) %>
										<% If arrbonusitemlist(0,intLoop) = "event" Then %>
										<li>
											<div class="cpWrap">
												<div class="cpCont">
													<p class="t01">
														<% if arrbonusitemlist(2,intLoop)="1" then %>
															<%= arrbonusitemlist(3,intLoop) %>%
														<% else %>
															<%= arrbonusitemlist(3,intLoop) %>원
														<% end if %>
													</p>
													<p class="t02"><%=chrbyte(db2html(arrbonusitemlist(4,intLoop)),30,"Y")%></p>
													<p class="t03"><%=FormatDate(arrbonusitemlist(7,intLoop),"0000/00/00")%> ~ <%=FormatDate(arrbonusitemlist(8,intLoop),"0000/00/00")%></p>
													<p class="terms">※ 사용조건 : <%= CHKIIF(arrbonusitemlist(15,intLoop)="C","해당카테고리 ",CHKIIF(arrbonusitemlist(15,intLoop)="B","해당브랜드 ","")) %> <%= FormatNumber(arrbonusitemlist(9,intLoop),0) %>원 이상 구매시 (일부상품제외)</p>
												</div>
											</div>
											<div class="btnWrap">
												<p><span class="button btM2 btRed cWh1 w100p"><a href="" onclick="jsDownCoupon('<%=arrbonusitemlist(0,IntLoop)%>','<%=arrbonusitemlist(1,IntLoop)%>'); return false;">쿠폰다운받기<em class="downArr"></em></a></span></p>
											</div>
										</li>
										<% End If %>
									<% Next %>
								<% Else %>
									<!--  쿠폰 없을 경우 -->
									<li class="nodata nodata-default"><p>사용 가능한 보너스쿠폰이 없습니다.</p></li>
									<!--// 쿠폰 없을 경우 -->
								<% End If %>
							</ul>
						</div>
						<!--// 보너스쿠폰 -->
					<% End If %>

					<% if stab="free" then %>
					<!-- 무료배송쿠폰 -->
					<div id="freeCoupon" class="tabContent">
						<ul class="couponList">
							<%' If isarray(arritemList) Then %>
							<% If vProdfreeCouponCnt >0 Then %>
								<% For intLoop = 0 To UBound(arritemList,2) %>
									<% If arritemList(0,intLoop) <> "event" Then %>								
										<li>
											<div class="cpWrap">
													<%
													cCouponMaster.Fitemcouponidx = arritemList(1,intLoop)
										
													arrItem = cCouponMaster.fnGetCouponItemList
										
													IF isArray(arrItem)	THEN
													%>
														<div class="pic"><img src="<%=getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic/" & GetImageSubFolderByItemid(arrItem(0,intItem)) & "/" & arrItem(12,intItem),200,200,"true","false")%>" alt="<%=arrItem(4,intItem)%>" /></div>
													<% End If %>
												<div class="cpCont">
													<p class="t01">무료배송</p>
													<p class="t02"><%=chrbyte(db2html(arritemList(4,intLoop)),30,"Y")%></p>
													<p class="t03"><%=FormatDate(arritemList(7,intLoop),"0000/00/00")%> ~ <%=FormatDate(arritemList(8,intLoop),"0000/00/00")%></p>
												</div>
											</div>
											<div class="btnWrap">
												<p><span class="button btM2 btRed cWh1 w100p"><a href="" onclick="jsDownCoupon('<%=arritemList(0,IntLoop)%>','<%=arritemList(1,IntLoop)%>'); return false;">쿠폰다운받기<em class="downArr"></em></a></span></p>
												<p><span class="button btM2 btRedBdr cRd1 bgWht w100p"><a href="" onclick="PopItemCouponAssginList('<%=arritemList(1,intLoop)%>'); return false;">적용상품보기<em class="moreArr"></em></a></span></p>
											</div>
										</li>
									<% End If %>
								<% Next %>										
							<% Else %>
								<!--  쿠폰 없을 경우 -->
								<li class="nodata nodata-default"><p>사용 가능한 무료배송쿠폰이 없습니다</p></li>
								<!--// 쿠폰 없을 경우 -->
							<% End If %>
						</ul>
					</div>
					<!--// 무료배송쿠폰 -->
				<% end if %>
				</div>
			</div>
		</div>
	</div>
	<!-- //contents -->
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->