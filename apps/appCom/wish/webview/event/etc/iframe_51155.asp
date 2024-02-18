<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  오픈이벤트 쿠폰 다운로드
' History : 2014.04.11 허진원 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appCom/wish/webview/lib/classes/Apps_eventCls.asp" -->
<!-- #include virtual="/event/2014openevent/cls2014openevent.asp" -->

<%
dim eCode
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  21143
	Else
		eCode   =  51155
	End If

dim cEvent, cEventItem, arrItem, arrGroup, intI, intG
dim arrRecent, intR
dim bidx
dim ekind, emanager, escope, eName, esdate, eedate, estate, eregdate, epdate
dim ecategory, ecateMid, blnsale, blngift, blncoupon, blncomment, blnbbs, blnitemps, blnapply
dim etemplate, emimg, ehtml, eitemsort, ebrand,gimg,blnFull,blnItemifno,blnitempriceyn, LinkEvtCode, blnBlogURL, DateViewYN
dim itemid : itemid = ""
dim egCode, itemlimitcnt,iTotCnt
dim cdl_e, cdm_e, cds_e
dim com_egCode : com_egCode = 0
Dim emimgAlt , bimgAlt

IF egCode = "" THEN egCode = 0

	itemlimitcnt = 105	'상품최대갯수
	'이벤트 개요 가져오기
	set cEvent = new ClsEvtCont
		cEvent.FECode = eCode

		cEvent.fnGetEvent

		eCode		= cEvent.FECode
		ekind		= cEvent.FEKind
		emanager	= cEvent.FEManager
		escope		= cEvent.FEScope
		eName		= cEvent.FEName
		esdate		= cEvent.FESDate
		eedate		= cEvent.FEEDate
		estate		= cEvent.FEState
		eregdate	= cEvent.FERegdate
		epdate		= cEvent.FEPDate
		ecategory	= cEvent.FECategory
		ecateMid	= cEvent.FECateMid
		blnsale		= cEvent.FSale
		blngift		= cEvent.FGift
		blncoupon	= cEvent.FCoupon
		blncomment	= cEvent.FComment
		blnbbs		= cEvent.FBBS
		blnitemps	= cEvent.FItemeps
		blnapply	= cEvent.FApply
		etemplate	= cEvent.FTemplate
		emimg		= cEvent.FEMimg
		ehtml		= cEvent.FEHtml
		eitemsort	= cEvent.FItemsort
		ebrand		= cEvent.FBrand
		gimg		= cEvent.FGimg
		blnFull		= cEvent.FFullYN
		blnItemifno = cEvent.FIteminfoYN
		blnitempriceyn = cEvent.FItempriceYN
		LinkEvtCode = cEvent.FLinkEvtCode
		blnBlogURL	= cEvent.FblnBlogURL
		DateViewYN	= cEvent.FDateViewYN

	set cEvent = nothing

	'// 이벤트 링크 보정
	if Not(ehtml="" or isNull(ehtml)) then
		ehtml = replace(ehtml,"href=""/event/eventmain.asp","href=""/apps/appCom/wish/webview/event/eventmain.asp")
	end if

strPageTitle = "생활감성채널, 텐바이텐 > 이벤트 > " & eName
%>

<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 구매 금액별 사은이벤트</title>
<style type="text/css">
.mEvt51155 {}
.mEvt51155 p {max-width:100%;}
.mEvt51155 img {vertical-align:top; width:100%;}
.discoveryTenbyten .explore .couponItem ul {overflow:hidden;}
.discoveryTenbyten .explore .couponItem ul li.item02, .explore .couponItem ul li.item03 {float:left; width:50%;}
</style>
<script type="text/javascript">

function jsDownCoupon(stype,idx){
	if (stype=='' || idx==''){
		alert('쿠폰구분이 없습니다.');
		return;
	}

	<% If IsUserLoginOK() Then %>
		<% If getnowdate>="2014-04-10" and getnowdate<"2014-04-22" Then %>
			if(confirm('쿠폰을 받으시겠습니까?')) {
				var frm;
				frm = document.frmC;
				frm.action="/shoppingtoday/couponshop_process.asp";
				frm.stype.value = stype;
				frm.idx.value = idx;
				frm.submit();
			}
		<% Else %>
			alert("쿠폰 다운로드 기간이 아닙니다.");
			return;
		<% End If %>
	<% Else %>
		alert('로그인을 하셔야 쿠폰을 받으실 수 있습니다.');
		return;
	<% End IF %>
}

</script>
</head>
<body>

<!-- 10x10 Discovery -->
<div class="mEvt51155">
	<div class="mEvt50692">
		<div class="discoveryTenbyten">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/50692/tit_discovery_tenbyten.jpg" alt="2014 리뉴얼 스페셜 이벤트 10X10 DISCOVERY 놀라운 발견! 즐거운 쇼핑! 이벤트기간 : 04.10 - 04.21" /></h2>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50692/txt_discovery_tenbyten.jpg" alt="발견의 즐거움을 선물합니다! 섬 곳곳을 탐험하며 놀라운 할인 혜택과 이벤트를 즐기세요" /></p>
			<div class="explore">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/50692/tit_explore.jpg" alt="텐텐섬 탐험의 필수 아이템 : 본격적으로 섬을 둘러보기 전에, 할인 쿠폰을 꼭 챙기세요!" /></h3>
				<div class="couponItem">
					<ul>
						<li class="item01"><a href="" onclick="jsDownCoupon('prd','<%=get30couponid%>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50692/btn_coupon_download_30.jpg" alt="30% COUPON DOWNLOAD" /></a></li>
						<li class="item02"><a href="" onclick="jsDownCoupon('prd','<%=get25couponid%>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50692/btn_coupon_download_20.jpg" alt="25% COUPON DOWNLOAD" /></a></li>
						<li class="item03"><a href="" onclick="jsDownCoupon('prd','<%=get20couponid%>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50692/btn_coupon_download_10.jpg" alt="20% COUPON DOWNLOAD" /></a></li>
					</ul>
					<div class="btnAll"><a href="" onclick="jsDownCoupon('prd,prd,prd,prd,prd,prd','<%=get5couponid%>,<%=get10couponid%>,<%=get15couponid%>,<%=get20couponid%>,<%=get25couponid%>,<%=get30couponid%>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50692/btn_coupon_download_all2.jpg" alt="쿠폰 전체 다운받기" /></a></div>
				</div>
			</div>
			<p class="couponGuide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50692/txt_coupon_guide2.jpg" alt="할인쿠폰 사용안내 : 쿠폰은 11일 동안 횟수 제한 없이 다운로드 및 사용 가능합니다. 할인쿠폰은 일부 상품이 제외될 수 있습니다. 할인쿠폰과 마일리지 및 예치금은 중복 사용 가능합니다. 쿠폰사용 마감은 4월 21일입니다." /></p>
		</div>
	</div>
</div>
<!--// 10x10 Discovery -->
<form name="frmC" method="get">
  <input type="hidden" name="stype" value="">
  <input type="hidden" name="idx" value="">
</form>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->