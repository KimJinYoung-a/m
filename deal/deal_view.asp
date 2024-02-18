<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/classes/item/dealCls.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchCls.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include Virtual="/lib/util/functions.asp" -->
<%
dim itemid, oItem, itEvtImg, itEvtImgMap, itEvtImgNm, sCatNm, lp, LoginUserid, cpid, addEx, viewnum, preitemid, nextitemid
dim oADD, i, ix, catecode, cTalk, vTalkCnt, makerid, itemVideos, IsTicketItem, vOrderBody, clsDiaryPrdCheck, dealitemid
itemid = requestCheckVar(request("itemid"),9)
viewnum = requestCheckVar(request("viewnum"),2)
dealitemid = requestCheckVar(request("dealitemid"),9)
LoginUserid = getLoginUserid()

'======================================== 상품코드 정확성체크 및 상품관련내용 ====================================
if itemid="" or itemid="0" then
	Call Alert_Return("상품번호가 없습니다.")
	response.End
elseif Not(isNumeric(itemid)) then
	Call Alert_Return("잘못된 상품번호입니다.")
	response.End
else	'정수형태로 변환
	itemid=CLng(getNumeric(itemid))
end if

if itemid=0 then
	Call Alert_Return("잘못된 상품번호입니다.")
	response.End
end if

if dealitemid="" then
	Call Alert_Return("딜 상품 정보가 부족합니다.")
	response.End
end if

set oItem = new CatePrdCls
oItem.GetItemData itemid

if oItem.FResultCount=0 then
	Call Alert_Return("존재하지 않는 상품입니다.")
	response.End
end if
if oItem.Prd.Fisusing="N" then
	if GetLoginUserLevel()=7 then
		'STAFF는 종료상품도 표시
		Response.Write "<script>alert('판매가 종료되었거나 삭제된 상품입니다.');</script>"
	else
		'// 수정 2017-03-09 이종화 - 종료 상품일시 - page redirect
		'Call Alert_Return("판매가 종료되었거나 삭제된 상품입니다.")
		'response.End
		Response.redirect("/shopping/closedprd.asp?"&request.servervariables("QUERY_STRING"))
	end if
end if

itemid = oItem.Prd.FItemid
makerid = oItem.Prd.FMakerid
catecode = requestCheckVar(request("disp"),18)
If catecode <> "" Then
	If IsNumeric(catecode) = False Then
		catecode = ""
	End If
End If

if catecode="" or (len(catecode) mod 3)<>0 then catecode = oItem.Prd.FcateCode

'=============================== 추가 이미지 & 추가 이미지-메인 이미지 ==========================================
set oADD = new CatePrdCls
oADD.getAddImage itemid

function ImageExists(byval iimg)
	if (IsNull(iimg)) or (trim(iimg)="") or (Right(trim(iimg),1)="\") or (Right(trim(iimg),1)="/") then
		ImageExists = false
	else
		ImageExists = true
	end if
end Function

'## 설명이미지 표시 (1순위:모바일상품설명이미지, 2순위:캡쳐 이미지, 3순위: html이미지+상품설명이미지)
dim itemContImg, tmpExtImgArr, mtmpAddImgChk, vCaptureExist, adjs, isUseCaptureView, VCaptureImgArr, ItemContent

adjs = 0
mtmpAddImgChk = False
isUseCaptureView = False

'추가이미지
IF oAdd.FResultCount > 0 THEN
	FOR i= 0 to oAdd.FResultCount-1
		IF oAdd.FADD(i).FAddImageType=2 Then
			If oAdd.FADD(i).FIsExistAddimg Then
				mtmpAddImgChk = True
				If adjs > 0 Then
					itemContImg = itemContImg & "<img data-original='"&oAdd.FADD(i).FAddimage&"' border='0' style='width:100%;' class='lazy'>"
				Else
					itemContImg = itemContImg & "<img src='"&oAdd.FADD(i).FAddimage&"' border='0' style='width:100%;'>"
				End If
				adjs = adjs + 1
			End If
		End If
	NEXT
end If

'캡쳐이미지
oItem.sbDetailCaptureViewCount itemid
vCaptureExist = oItem.FCaptureExist

If vCaptureExist = "1" Then
	isUseCaptureView = true
	VCaptureImgArr = oItem.sbDetailCaptureViewImages(itemid)
End If

Dim Safety
'//제품 안전 인증 정보
set Safety = new CatePrdCls
Safety.getItemSafetyCert itemid

'// 상품상세설명 동영상 추가
Set itemVideos = New catePrdCls
	itemVideos.fnGetItemVideos itemid, "video1"

'=============================== 딜 추가 정보 ==========================================
Dim oDeal, ArrDealItem, intLoop
Set oDeal = New DealCls
oDeal.GetIDealInfo dealitemid
If oDeal.Prd.FDealCode="" Then
	Response.write "<script>alert('딜 상품 정보가 부족합니다.');history.back();</script>"
	Response.End
End If
ArrDealItem=oDeal.GetDealItemList(oDeal.Prd.FDealCode)
Set oDeal = Nothing
Dim FirstItem, LastItem, Tcnt
If isArray(ArrDealItem) Then
	Tcnt = UBound(ArrDealItem,2)
	For intLoop = 0 To UBound(ArrDealItem,2)
		If intLoop=0 Then
			FirstItem = ArrDealItem(0,intLoop)
		End If
		If intLoop=UBound(ArrDealItem,2) Then
			LastItem=ArrDealItem(0,intLoop)
		End If
	Next
	For intLoop = 0 To UBound(ArrDealItem,2)
		If itemid=ArrDealItem(0,intLoop) Then
			If intLoop=0 Then
				preitemid=LastItem
			Else
				preitemid=ArrDealItem(0,intLoop-1)
			End If
			If intLoop=UBound(ArrDealItem,2) Then
				nextitemid=FirstItem
			Else
				nextitemid=ArrDealItem(0,intLoop+1)
			End If
		End If
	Next
End If

%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script type="text/javascript">
$(function(){
	/* slide content */
	$(".slideWrap .slide").hide();
	$(".slideWrap .slide:first").show();

	$(".btn-next").on("click", function(e){
		$(".slideWrap .slide:first").appendTo(".slideWrap");
		$(".slideWrap .slide").hide().eq(0).show();
	});

	$(".btn-prev").on("click", function(e){
		$(".slideWrap .slide:last").prependTo(".slideWrap");
		$(".slideWrap .slide").hide().eq(0).show();
	});

	/* price info more */
	$(".item-detail .btn-more").on("click", function(){
		var thisCont = $(this).attr("href");
		$(this).toggleClass("on");
		$(thisCont).slideToggle();
		return false;
	});
});
function fnDealOtherItemView(itemid,viewnum){
//alert(itemid);
	location.href="/deal/deal_view.asp?itemid="+itemid+"&viewnum="+viewnum+"&dealitemid=<%=dealitemid%>";
}

// 쿠폰 받기
function jsDownCoupon(stype,idx){
	if (islogin()=="False"){
		alert("로그인을 하셔야 쿠폰을 다운받으실수 있습니다.");
		return;
	 }

	if(confirm('쿠폰을 받으시겠습니까?'))
	{
		var frm;
		frm = document.frmC;
		frm.stype.value = stype;
		frm.idx.value = idx;	
		frm.submit();
	}
}
</script>
<script type="text/javascript" src="/lib/js/jquery.lazyload.min.js"></script>
<script>
	$(function() {
	    $("#imgArea img.lazy").lazyload().removeClass("lazy");
	});
</script>
</head>
<body class="default-font body-popup">
	<header class="tenten-header header-popup">
		<div class="title-wrap">
			<h1>상품 <%=viewnum%></h1>
			<button type="button" class="btn-close" onclick="self.close();">닫기</button>
		</div>
	</header>

	<!-- contents -->
	<div id="content" class="content deal-item">
		<div class="slideWrap">
			<div class="slide">
				<!-- item info -->
				<section class="items item-detail">
					<% If oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut Then %>
					<p class="soldout">일시 품절된 상품입니다.</p>
					<% End If %>
					<div class="desc">
						<!-- for dev msg : 상품 넘버링 값 -->
						<span class="no">상품 <%=viewnum%></span>
						<span class="brand"><a href="/street/street_brand.asp?makerid=<%= oItem.Prd.FMakerid %>&ab=012_a_1" target="_blank"><%= UCase(oItem.Prd.FBrandName) %></a></span>
						<h2 class="name"><%= replace(replace(oItem.Prd.FItemName,"<br>"," "),"<br />"," ") %></h2>
						<div class="price">
							<h3 class="tenten">텐바이텐가</h3>
							<div class="unit">
								<% IF ((oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0)) or (oItem.Prd.IsSaleItem and oItem.Prd.IsSpecialUserItem) or (oitem.Prd.isCouponItem) THEN %>
								<s><%=FormatNumber(oItem.Prd.getOrgPrice,0)%></s>
								<b class="sum color-red"><%= FormatNumber(oItem.Prd.GetCouponAssignPrice,0) %><span class="won">원</span></b>
								<% Else %>
								<b class="sum"><%=FormatNumber(oItem.Prd.getOrgPrice,0)%><span class="won">원</span></b>
								<% End If %>
							</div>
							<% IF ((oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0)) or (oItem.Prd.IsSaleItem and oItem.Prd.IsSpecialUserItem) or (oitem.Prd.isCouponItem) THEN %>
							<a href="#priceList" class="btn-more">상세 가격 정보 보기</a>
							<% End If %>
						</div>
					</div>
					<% IF ((oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0)) or (oItem.Prd.IsSaleItem and oItem.Prd.IsSpecialUserItem) or (oitem.Prd.isCouponItem) THEN %>
					<dl id="priceList" class="price-list">
						<dt>판매가</dt>
						<dd><div class="price"><b class="sum"><%=FormatNumber(oItem.Prd.getOrgPrice,0)%><span class="won">원</span></b></div></dd>
						<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
						<dt>할인판매가</dt>
						<dd><div class="price"><b class="discount color-red"><%=chkiif(oItem.Prd.FOrgprice = 0,"0",CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100))%>%</b> <b class="sum"><%=FormatNumber(oItem.Prd.FSellCash,0)%><span class="won">원</span></b></div></dd>
						<% end if %>
						<% if oItem.Prd.IsSaleItem and oItem.Prd.IsSpecialUserItem then %>
						<dt>우수회원가</dt>
						<dd><div class="price"><b class="sum"><%=FormatNumber(oItem.Prd.getRealPrice,0)%><span class="won">원</span></b></div></dd>
						<% end if %>
						<% if oitem.Prd.isCouponItem Then %>
						<dt>쿠폰적용가</dt>
						<dd><div class="price"><b class="discount color-green"><%= oItem.Prd.GetCouponDiscountStr %></span></b> <b class="sum"><%=FormatNumber(oItem.Prd.GetCouponAssignPrice,0)%><span class="won">원</span></b></div></dd>
						<% end if %>
					
					</dl>
					<% end if %>
					<% if oitem.Prd.isCouponItem Then %>
					<div class="btn-group">
						<button type="button" onclick="jsDownCoupon('prd','<%= oitem.Prd.FCurrItemCouponIdx %>'); return false;"><%= oItem.Prd.GetCouponDiscountStr %> 쿠폰<span class="icon icon-download"></span></button>
						<!-- <button type="button" disabled="disabled" class="disabled">할인쿠폰 다운 완료!<span class="icon icon-download"></span></button> -->
						<form name="frmC" method="get" action="/shoppingtoday/couponshop_process.asp" style="margin:0px;">
						<input type="hidden" name="stype" value="" />
						<input type="hidden" name="idx" value="" />
						</form>
					</div>
					<% end if %>
				</section>

				<!-- item etc info -->
				<div class="item-etc-info">
					<ul>
						<% if Not(oItem.Prd.IsFreeBeasong) and (oItem.Prd.IsUpcheParticleDeliverItem or oItem.Prd.IsUpcheReceivePayDeliverItem) then %>
						<li><span class="icon icon-shipping"></span>업체무료배송 <a href="/street/street_brand.asp?makerid=<%=oItem.Prd.Fmakerid%>">배송비 절약 상품</a></li>
						<% end if %>
						<% If G_IsPojangok Then %>
						<% If oItem.Prd.IsPojangitem Then %>
						<li><span class="icon icon-wrapping"></span>선물포장가능 <a href="/category/popPkgIntro.asp?itemid=<%=itemid%>">텐바이텐 선물 포장</a></li>
						<% end if %>
						<% end if %>
						<!-- <% If IsUserLoginOK Then %>
						<li><span class="icon icon-gifttalk"></span>선물 골라주세요! <a href="" onclick="writeShoppingTalk('<%=itemid%>'); return false;">기프트톡 쓰기</a></li>
						<% else %>
						<li><span class="icon icon-gifttalk"></span>선물 골라주세요! <a href="" onClick="if(confirm('로그인이 필요한 서비스입니다.\n로그인 하시겠습니까?') == true){location.href = '<%=M_SSLUrl%>/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>';}; return false;">기프트톡 쓰기</a></li>
						<% end if %> -->
					</ul>
				</div>

				<%
				''브랜드 공지 2017-02-03 유태욱
				''브랜드 공지(일반,배송) 2017-01-31 유태욱 작업중
					
				dim oBrandNotice
				set oBrandNotice = new CatePrdCls
				oBrandNotice.Frectmakerid=makerid
				oBrandNotice.GetBrandNoticeData
				Dim vBrandNotice

				'if not(oItem.Prd.FDeliverytype = "1" or oItem.Prd.FDeliverytype = "4") then	'텐배가 아닐경우만 출력
					if oBrandNotice.FResultCount > 0 then
						For i= 0 to oBrandNotice.FResultCount-1
							vBrandNotice=""
							vBrandNotice = vBrandNotice & "	<div class="&chkIIF(oBrandNotice.FItem(i).FBrandNoticeGubun = 2,"""notiV17 notiDelivery""","""notiV17 notiGeneral""")&">" & vbCrLf
							vBrandNotice = vBrandNotice & "		<h3>"&oBrandNotice.FItem(i).FBrandNoticeTitle&"</h3>" & vbCrLf
							vBrandNotice = vBrandNotice & "		<div class='texarea'>" & vbCrLf
							vBrandNotice = vBrandNotice & "			<p>" & vbCrLf
							vBrandNotice = vBrandNotice & 				nl2br(oBrandNotice.FItem(i).FBrandNoticeText) & vbCrLf
							vBrandNotice = vBrandNotice & "			</p>" & vbCrLf
							vBrandNotice = vBrandNotice & "		</div>" & vbCrLf
							vBrandNotice = vBrandNotice & "	</div>" & vbCrLf
							Response.Write vBrandNotice
						next
					End If
				'end if

				Set oBrandNotice = Nothing
				%>

				<!-- 상품설명 탭에 들어가는 내용 -->
				<div class="pdtCaptionV16a">
					<p><strong>상품코드 : <%=itemid%></strong></p>
					<% if oItem.Prd.FMileage then %>
					<%'// 2018 회원등급 개편%>
					<p style="margin-top:0.43rem;"><strong>적립 마일리지 : <% = oItem.Prd.FMileage %> Point <% If Not(IsUserLoginOK()) Then %>~<% End If %></strong></p>
					<% end if %>
					<% IF Not(oItem.Prd.FOrderComment="" or isNull(oItem.Prd.FOrderComment)) or Not(oItem.Prd.getDeliverNoticsStr="" or isNull(oItem.Prd.getDeliverNoticsStr)) THEN %>
					<dl class="odrNoteV16a">
						<dt>주문 유의사항</dt>
						<dd><%= oItem.Prd.getDeliverNoticsStr %><br><%= nl2br(oItem.Prd.FOrderComment) %></dd>
					</dl>
					<% end if %>
					<% If Safety.FResultCount > 0  Then %>
					<% If Safety.FItem(0).FSafetyYN <> "N" Then %>
					<% If Safety.FItem(0).FSafetyYN="Y" Then %>
					<div class="safety-mark">
						<strong>제품 안전 인증 정보</strong>
						<% For i= 0 To Safety.FResultCount-1 %>
						<% If Safety.FItem(i).FcertDiv <> "" And  Not IsNull(Safety.FItem(i).FcertDiv) Then %>
						<div>
							<span class="ico"></span>
							<span><em><%=fnSafetyDivCodeName(Safety.FItem(i).FsafetyDiv)%></em><br /><%=Safety.FItem(i).FcertNum%></span>
						</div>
						<% Else %>
						<div>
							<span class="ico"></span>
							<span><em>전기용품 – 공급자 적합성 확인</em><br />공급자 적합성 확인 대상 품목으로 인증번호 없음</span>
						</div>
						<% End If %>
						<% Next %>
					</div>
					<% Else %>
					<div class="safety-mark">
						<strong>제품 안전 인증 정보</strong>
						<div>
							<span>해당 상품 인증 정보는 판매자가 등록한 상품 상세 설명을 참조하시기 바랍니다.</span>
						</div>
					</div>
					<% End If %>
					<% End If %>
					<% End If %>
				</div>

				<!-- 상세 이미지 영역 -->
				<div class="imgArea" id="imgArea">
					<%
						ItemContent = oItem.Prd.FItemContent

						'링크는 새창으로
						ItemContent = Replace(ItemContent,"<a ","<a target='_blank' ")
						ItemContent = Replace(ItemContent,"<A ","<A target='_blank' ")
						'높이태그 제거
						ItemContent = Replace(ItemContent,"height=","h=")
						ItemContent = Replace(ItemContent,"HEIGHT=","h=")
						'너비태그 제거
						ItemContent = Replace(ItemContent,"width=","w=")
						ItemContent = Replace(ItemContent,"WIDTH=","w=")

						IF oItem.Prd.FUsingHTML="Y" THEN
							Response.write ItemContent
						ELSEIF oItem.Prd.FUsingHTML="H" THEN
							Response.write nl2br(ItemContent)
						ELSE
							Response.write nl2br(stripHTML(ItemContent))
						END IF
					%>
					<% IF oAdd.FResultCount > 0 THEN %>
						<% FOR i= 0 to oAdd.FResultCount-1  %>
							<%IF oAdd.FADD(i).FAddImageType=1 AND oAdd.FADD(i).FIsExistAddimg THEN %>
								<img src="<%= oAdd.FADD(i).FAddimage %>" border="0" style="width:100%;" />
							<%End IF %>
						<% NEXT %>
					<% END IF %>
					<% if ImageExists(oItem.Prd.FImageMain) then %>
						<img src="<% = oItem.Prd.FImageMain %>" border="0" style="width:100%;" />
					<% end if %>
					<% if ImageExists(oItem.Prd.FImageMain2) then %>
						<img src="<% = oItem.Prd.FImageMain2 %>" border="0" style="width:100%;" />
					<% end if %>
					<% if ImageExists(oItem.Prd.FImageMain3) then %>
						<img src="<% = oItem.Prd.FImageMain3 %>" border="0" style="width:100%;" />
					<% end if %>
					<%'// 상품상세설명 동영상 추가 %>
					<% If Not(itemVideos.Prd.FvideoFullUrl="") Then %>
						<center>
							<p>&nbsp;</p>
							<iframe class="youtube-player" type="text/html" width="320" height="180" src="<%=itemVideos.Prd.FvideoUrl%>" frameborder="0"></iframe>
						</center>
					<% End If %>
				</div>
				<script>
					(function(){
						var $contents = $("#imgArea");
						$contents.find("table").css("width","100%");
						$contents.find("div").css("width","100%");
						$contents.find("img").css("width","100%");
						$contents.find("img").css("height","auto");
						//console.log($contents.find("img").width());
						//console.log($contents.find("img").height());
					})(jQuery);
				</script>
				<!-- 상세 이미지 영역 -->
			</div>
<%
Dim prevnum, nextnum
If viewnum=1 Then
	prevnum=Tcnt+1
	nextnum=viewnum+1
ElseIf viewnum=Cstr(Tcnt+1) Then
	prevnum=viewnum-1
	nextnum=1
Else
	prevnum=viewnum-1
	nextnum=viewnum+1
End If
%>
			<button type="button" class="btn-nav btn-prev" onClick="fnDealOtherItemView(<%=preitemid%>,<%=prevnum%>)">이전</button>
			<button type="button" class="btn-nav btn-next" onClick="fnDealOtherItemView(<%=nextitemid%>,<%=nextnum%>)">다음</button>
		</div>
	</div>
	<!-- //contents -->
	<!-- #include virtual="/lib/inc/incLogScript.asp" -->
</body>
</html>
<%
	Set oItem = Nothing
	Set oADD = Nothing
	Set itemVideos = Nothing
	Set Safety = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->