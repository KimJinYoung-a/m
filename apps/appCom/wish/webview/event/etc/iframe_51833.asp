<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  구매금액별 사은 이벤트(어른들은 갖고 싶다!)
' History : 2014.05.15 원승현 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/2014openevent/cls2014openevent.asp" -->
<%
dim eCode, subscriptcount, userid, murl
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  21172
	Else
		eCode   =  51833
	End If

userid=getloginuserid()
subscriptcount=0
subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")

dim cEvent, cEventItem, arrItem, arrGroup, intI, intG, rdmNo
dim arrRecent, intR
dim bidx
dim ekind, emanager, escope, ename, esdate, eedate, estate, eregdate, epdate
dim ecategory, ecateMid, blnsale, blngift, blncoupon, blncomment, blnbbs, blnitemps, blnapply
dim etemplate, emimg, ehtml, eitemsort, ebrand,gimg,blnFull,blnItemifno,blnBlogURL, bimg, edispcate, vDisp, vIsWide, j
dim itemid : itemid = ""
dim egCode, itemlimitcnt,iTotCnt, strBrandListURL
dim com_egCode : com_egCode = 0
Dim blnitempriceyn, clsEvt, isMyFavEvent, favCnt, vDateView, voteContent, strQuery, voteContentCode, locationEventUrl

	'이벤트 개요 가져오기
	set cEvent = new ClsEvtCont
		cEvent.FECode = eCode

		cEvent.fnGetEvent

		eCode		= cEvent.FECode
		ekind		= cEvent.FEKind
		emanager	= cEvent.FEManager
		escope		= cEvent.FEScope
		ename		= cEvent.FEName
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
		vDisp		= edispcate
		vDateView	= cEvent.FDateViewYN
	set cEvent = Nothing
	


	If Not(GetLoginUserID()="" or isNull(GetLoginUserID())) Then
		strQuery = " Select top 1 evt_code, userid, sub_opt1, sub_opt3, convert(varchar(10), regdate, 120) as regdate "&_
				" FROM  "&_
				" [db_event].[dbo].tbl_event_subscript  "&_
				" WHERE evt_code ='"&eCode&"' And userid='"&userid&"' "
		'response.write sqlstr
		rsget.Open strQuery,dbget,1
		if Not(rsget.EOF or rsget.BOF) Then
			voteContent = rsget("sub_opt3")
			voteContentCode = rsget("sub_opt1")
		End If
		rsget.Close
	End If

	Select Case Trim(voteContentCode)
		Case "1023970"
			locationEventUrl = "51947"
		Case "971073"
			locationEventUrl = "51948"
		Case "635571"
			locationEventUrl = "51949"
	End Select


%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 어른들은 갖고싶다</title>
<style type="text/css">
.mEvt51833 {}
.mEvt51833 img {vertical-align:top; width:100%;}
.mEvt51833 p {max-width:100%;}
.mEvt51833 .toySwiperWrap {padding-bottom:55px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/51833/bg_slide.png) left top no-repeat; background-size:100% 100%;}
.mEvt51833 .swiper {position:relative; width:420px; height:255px; margin:0 auto; border:6px solid #f24961; background:#fff;}
.mEvt51833 .swiper .swiper-container {overflow:hidden; width:420px; height:255px; }
.mEvt51833 .swiper .swiper-slide {float:left;}
.mEvt51833 .swiper .swiper-slide a {display:block; width:100%;}
.mEvt51833 .swiper .swiper-slide img {width:100%; vertical-align:top;}
.mEvt51833 .swiper .btnArrow {display:block; position:absolute; bottom:-45px; z-index:10; width:30px; height:30px; text-indent:-9999px; background-repeat:no-repeat; background-position:left top; background-size:100% auto;}
.mEvt51833 .swiper .arrow-left {left:10px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51833/btn_prev.png);}
.mEvt51833 .swiper .arrow-right {right:10px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51833/btn_next.png);}
.mEvt51833 .swiper .pagination {position:absolute; left:0; bottom:-40px; width:100%; text-align:center;}
.mEvt51833 .swiper .pagination span {position:relative; display:inline-block; width:12px; height:12px; margin:0 8px; cursor:pointer; border-radius:12px; background:#fff;}
.mEvt51833 .swiper .pagination .swiper-active-switch {background:#e64554;}
.mEvt51833 .voteEdition {padding-bottom:35px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/51833/bg_vote.png) left top no-repeat; background-size:100% 100%;}
.mEvt51833 .voteEdition dl {width:92%; margin:0 auto;}
.mEvt51833 .voteEdition dt {border-radius:18px 18px 0 0; background:#ffef66;}
.mEvt51833 .voteEdition dd {padding-bottom:30px; background:#fff;}
.mEvt51833 .voteEdition ul {overflow:hidden; width:101%; padding:0 5px 18px;  -webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box;}
.mEvt51833 .voteEdition li {float:left; width:33.33333%; padding:0 5px; text-align:center; -webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box;}
.mEvt51833 .voteEdition li label {display:block; margin-bottom:8px;}
.mEvt51833 .voteBtn {width:55%; margin:0 auto;}
.mEvt51833 .voteBtn input {width:100%;}
.mEvt51833 .giftNoti {overflow:hidden; padding:24px 20px 25px 8px; background:#e4f5f6;}
.mEvt51833 .giftNoti dl {text-align:left;}
.mEvt51833 .giftNoti dt {padding:0 0 12px 12px;}
.mEvt51833 .giftNoti li {color:#444; font-size:11px; line-height:15px; padding:0 0 5px 12px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/51833/blt_arrow.gif) left 2px no-repeat; background-size:6px 8px;}
.mEvt51833 .giftNoti li span {color:#d50c0c;}
.mEvt51833 .giftNoti li em {text-decoration:underline; color:#000;}
@media all and (max-width:480px){
	.mEvt51833 .swiper {width:280px; height:170px;}
	.mEvt51833 .swiper .swiper-container {width:280px; height:170px;}
}
</style>
<script src="/lib/js/swiper-1.8.min.js"></script>
<script language="javascript">
<!--
$(function(){
	showSwiper= new Swiper('.toySwiper',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		pagination:'.pagination',
		paginationClickable:true,
		speed:180
	});
	$('.swiper .arrow-left').on('click', function(e){
		e.preventDefault()
		showSwiper.swipePrev()
	});
	$('.swiper .arrow-right').on('click', function(e){
		e.preventDefault()
		showSwiper.swipeNext()
	});

	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
	var oTm = setInterval(function () {
		showSwiper.reInit();
			clearInterval(oTm);
		}, 1);
	});
});

function checkformM(){

	var frm=document.frmcomm;

	<% If IsUserLoginOK() Then %>
		<% if subscriptcount<1 then %>
			<% If getnowdate>="2014-05-19" and getnowdate<"2014-05-23" Then %>

				if(typeof($('input:radio[name=votecode]:checked').val()) == "undefined"){
					alert("소유하고픈 에디션을 선택 해주세요!");
					return false;
				}


		   		frm.mode.value="vote";
				frm.action="/event/etc/doEventSubscript51833.asp";
//				frm.target="evtFrmProc";
				frm.submit();
			<% Else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% End If %>
		<% else %>
			alert("투표는 1회만 가능합니다.\n이미 <%=voteContent%>에 투표하셨습니다.");parent.location.href='/event/eventmain.asp?eventid=<%=locationEventUrl%>';
			return;
		<% end if %>
	<% Else %>
		//alert('로그인을 하셔야 참여가 가능 합니다');
		//return;
		if(confirm("로그인을 하셔야 참여가 가능 합니다.")){
			return;
		}
	<% End IF %>
}
//-->
</script>
</head>
<body>

<!--  어른들은 갖고싶다! -->
<div class="mEvt51833">
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/51833/txt_sense_ver01.png" alt="어른들은 갖고싶다! 어른도 아이도 누구나 가질 자격이 있어요! 텐바이텐이 당신에게 동심을 선물합니다!" /></p>
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/51833/tit_adult.png" alt="어른들은 갖고싶다! 어른도 아이도 누구나 가질 자격이 있어요! 텐바이텐이 당신에게 동심을 선물합니다!" /></h2>
	<div class="toySwiperWrap">
		<div class="swiper">
			<div class="swiper-container toySwiper">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51833/img_slide01.png" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51833/img_slide02.png" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51833/img_slide03.png" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51833/img_slide04.png" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51833/img_slide05.png" alt="" /></div>
				</div>
				<div class="pagination"></div>
			</div>
			<a class="btnArrow arrow-left" href="">Previous</a>
			<a class="btnArrow arrow-right" href="">Next</a>
		</div>
	</div>
	<dl>
		<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/51833/tit_shopping_gift.png" alt="텐바이텐에서 쇼핑하고 사은품 받으세요! 5만원 이상 구매 시 아래 상품 중 택1" /></dt>
		<dd>
			<ul>
				<li><a href="/category/category_itemPrd.asp?itemid=788067" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51833/img_shopping_gift01.png" alt="소니엔젤" /></a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=787928" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51833/img_shopping_gift02.png" alt="폭스바겐 마이크로 버스" /></a></li>
				<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/51833/img_shopping_gift03.png" alt="어른아이 쿠폰" /></li>
			</ul>
		</dd>
	</dl>
	<!-- 투표하기 -->
	<form name="frmcomm" action="" onsubmit="return checkformM();" method="post" style="margin:0px;">
	<input type="hidden" name="mode">
	<div class="voteEdition">
		<dl>
			<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/51833/tit_collector.png" alt="잠자고 있던 콜렉터의 본능이 꿈틀대나요?" /></dt>
			<dd>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/51833/txt_vote.png" alt="갖고 싶은 에디션에 추표하고, 숨겨진 상품들과 쿠폰 확인하기!" /></p>
				<ul>
					<li class="gift01">
						<label for="lego"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51833/img_gift_lego.png" alt="후보1. 블록&amp;레고" /></label>
						<input type="radio" id="lego" name="votecode" value="1023970" />
					</li>
					<li class="gift02">
						<label for="sylvanian"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51833/img_gift_sylvanian.png" alt="후보2. 귀여운 미니어쳐" /></label>
						<input type="radio" id="sylvanian" name="votecode" value="971073" />
					</li>
					<li class="gift03">
						<label for="play"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51833/img_gift_rcmeca.png" alt="후보3. 생생한R/C 토이" /></label>
						<input type="radio" id="play" name="votecode" value="635571" />
					</li>
				</ul>
				<p class="voteBtn"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/51833/btn_vote.gif" alt="투표하기" /></p>
			</dd>
		</dl>
	</div>
	</form>
	<!--// 투표하기 -->
	<div class="giftNoti">
		<dl>
			<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/51833/tit_noti.png" alt="사은품 선택 시 유의사항" style="width:110px;" /></dt>
			<dd>
				<ul>
					<li>텐바이텐 사은 이벤트는 텐바이텐 회원님을 위한 혜택입니다.(비회원 구매 증정 불가)</li>
					<li>사은품은 한정수량이므로, 수량이 소진되었을 경우에는 원하는 사은품 선택이 어려울 수 있습니다.</li>
					<li>텐바이텐 배송상품을 구매하지 않을 경우, 할인쿠폰만 선택 가능합니다.</li>
					<li>상품 쿠폰, 보너스 쿠폰, 할인카드 등의 사용 후 <span><strong>구매확정 금액</strong>이 5만원</span> 이어야 합니다.</li>
					<li>마일리지, 예치금, GIFT 카드를 사용하신 경우는 구매확정금액에 포함되어 사은품을 받으실 수 있습니다.</li>
					<li>한 주문 건이 구매금액 기준 이상일 때 증정하며 다른 주문에 대한 누적적용이 되지 않습니다.</li>
					<li>사은품의 경우 구매하신 텐바이텐 배송 상품과 함께 배송되며, <em>할인쿠폰은 6월 2일 일괄발급</em>됩니다.</li>
					<li>사은품 할인 쿠폰 사용은 최소구매금액 기준과 사용유효기간이 있습니다. <em>사용유효기간은 6월15일</em>까지 입니다.</li>
					<li>GIFT 카드를 구매하신 경우는 사은품과 사은 쿠폰이 증정되지 않습니다.</li>
					<li>환불이나 교환 시, 최종 구매 가격이 사은품 수령 가능 금액 미만이 될 경우, 사은품과 함께 반품해야 하며, 사은쿠폰은 취소 처리됩니다.</li>
				</ul>
			</dd>
		</dl>
	</div>
</div>
<!--//  어른들은 갖고싶다! -->
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->