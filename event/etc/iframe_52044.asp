<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  10x10 오감충족 이벤트 2탄 혹시 자리 있으세요?
' History : 2014.05.20 원승현 생성
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
dim eCode, subscriptcount, userid, oleCode
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  21177
		oleCode = 21176
	Else
		eCode   =  52044
		oleCode = 52043
	End If

userid=getloginuserid()
subscriptcount=0
subscriptcount = getevent_subscriptexistscount(oleCode, userid, "", "", "")

dim cEvent, cEventItem, arrItem, arrGroup, intI, intG
dim arrRecent, intR
dim bidx
dim ekind, emanager, escope, eName, esdate, eedate, estate, eregdate, epdate
dim ecategory, ecateMid, blnsale, blngift, blncoupon, blncomment, blnbbs, blnitemps, blnapply
dim etemplate, emimg, ehtml, eitemsort, ebrand,gimg,blnFull,blnItemifno,blnitempriceyn, LinkEvtCode, blnBlogURL
dim itemid : itemid = ""
dim egCode, itemlimitcnt,iTotCnt
dim cdl_e, cdm_e, cds_e
dim com_egCode : com_egCode = 0
Dim emimgAlt , bimgAlt
Dim j

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
	set cEvent = nothing

	'// 위시리스트 유저별 등록된 폴더갯수 가져오기
	Dim strSqlE, folderUserCnt
	strSqlE = "Select count(fidx) From db_my10x10.dbo.tbl_myfavorite_folder Where viewisusing='Y' And userid='"&userid&"' "
	rsget.Open strSqlE,dbget,1
		folderUserCnt = rsget(0)
	rsget.close


%>

<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 혹시 자리 있으세요?</title>
<style type="text/css">
.mEvt52044 {}
.mEvt52044 img {vertical-align:top; width:100%;}
.mEvt52044 p {max-width:100%;}
.mEvt52044 .diyPackage {position:relative; background-image: url(http://webimage.10x10.co.kr/eventIMG/2014/52044/bg_select_diy01.png), url(http://webimage.10x10.co.kr/eventIMG/2014/52044/bg_select_diy02.png); background-position:left top, left 50%; background-repeat: no-repeat; background-size:100% auto; background-color:#f5fbe2;}
.mEvt52044 .diyPackage .selectItem {width:92%; margin:0 auto; padding:20px 20px 0; border:4px solid #c9e2a1; -webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box;}
.mEvt52044 .diyPackage .selectItem ul {overflow:hidden;}
.mEvt52044 .diyPackage .selectItem li {float:left; text-align:center; width:50%; padding:0 13px 20px; -webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box;}
.mEvt52044 .diyPackage .selectItem li label {position:relative; display:block; margin-bottom:10px; cursor:pointer;}
.mEvt52044 .diyPackage .selectItem li label span {display:none; position:absolute; left:0; top:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/52044/bg_select_item.png) left top no-repeat; background-size:100% 100%;}
.mEvt52044 .diyPackage .selectItem li.on label span {display:block;}
.mEvt52044 .diyPackage .applyBtn {padding:23px 0 13px;}
.mEvt52044 .applyBtn {width:75%; margin:0 auto;}
.mEvt52044 .applyBtn input {width:100%;}
.mEvt52044 .giftNoti {overflow:hidden; padding:24px 20px 25px 8px; background:#c1d87a;}
.mEvt52044 .giftNoti dl {text-align:left;}
.mEvt52044 .giftNoti dt {padding:0 0 12px 12px;}
.mEvt52044 .giftNoti li {color:#444; font-size:11px; line-height:15px; padding:0 0 5px 12px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/52044/blt_arrow.png) left 3px no-repeat; background-size:6px 7px;}
.mEvt52044 .giftNoti li strong {color:#d50c0c;}
</style>
<script type="text/javascript">

$(function(){
	$(".selectItem li label, .selectItem li input").click(function(){
		var pItem = $(this).parent('li');
		if (pItem.find('input').is(':checked')){
			pItem.addClass('on');
		} else {
			pItem.removeClass('on');
		}
	});
});

function checkform(){
	var frm=document.frmcomm;
	<% If IsUserLoginOK() Then %>
		<% if subscriptcount<1 then %>
			<% If getnowdate>="2014-05-20" and getnowdate<"2014-05-31" Then %>
				var count=0;
				//선택된것 갯수 체크
				for (i=0; i<frm.productSelect.length; i++ )
				{
					if (frm.productSelect[i].checked==true)
					{
						count++;
					}
				} 

				if (count < 1)
				{
					alert("상품을 선택하여 주세요.");
					return false;
				}
//				else if (count < 5)
//				{
//					alert("갖고 싶은 아이템 5개를 선택하여 주세요.");
//					return;
//				}
				else if (count > 5)
				{
					alert("최대 5개까지 선택 가능합니다.");
					return false;
				}
				if (<%=folderUserCnt%> > 10)
				{
					alert("위시리스트는 최대 10개까지만 생성이 가능합니다.\n이벤트에 참여를 원하시면 위시리스트를 정리해주세요.");
					return;
				}
		   		frm.mode.value="addevent";
				frm.action="/event/etc/doEventSubscript52044.asp";
				frm.target="evtFrmProc";
				frm.submit();
			<% Else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% End If %>
		<% else %>
			alert("1회만 응모가 가능 합니다.");
			return;
		<% end if %>
	<% Else %>
		alert('로그인을 하셔야 참여가 가능 합니다');
		return;
		//if(confirm("로그인을 하셔야 참여가 가능 합니다. 로그인 하시겠습니까?")){
		//	var winLogin = window.open('/login/PopLoginPage.asp','popLogin','width=400,height=300');
		//	winLogin.focus();
		//	return;
		//}
	<% End IF %>
}

</script>
</head>
<body>

<!-- 혹시 자리 있으세요? -->
<div class="mEvt52044">
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52044/tit_sense_ver02.png" alt="10X10 오감충족 사은이벤트 2탄" /></p>
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/52044/tit_seat.png" alt="혹시 자리 있으세요?" /></h2>
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/52044/img_gift.png" alt="선착순 250명에게 콜맨 캠핑체어를!" /></div>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52044/txt_gift.png" alt="20만원 이상 구매 시 Coleman 암 체어, 25만원 이상 구매 시 Coleman 암 체어 또는 Coleman 리조트 체어 중 택1" /></p>
	<div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52044/img_chair01.png" alt="" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52044/img_chair02.png" alt="" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52044/img_chair03.png" alt="" /></p>
	</div>
	<!-- DIY패키지 만들기 -->
	<form name="frmcomm" onsubmit="return checkform();" method="post" style="margin:0px;">
	<input type="hidden" name="mode">
	<p class="tit"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52044/tit_diy_package.png" alt="당신의 자리를 꾸며 줄 DIY패키지를 만드세요!" /></p>
	<div class="diyPackage">
		<div class="selectItem">
			<ul>
				<li>
					<label for="item01"><span></span><img src="http://webimage.10x10.co.kr/eventIMG/2014/52044/img_diy_product01.png" alt="" /></label>
					<input type="checkbox" id="item01" name="productSelect" value="893696"/>
				</li>
				<li>
					<label for="item02"><span></span><img src="http://webimage.10x10.co.kr/eventIMG/2014/52044/img_diy_product02.png" alt="" /></label>
					<input type="checkbox" id="item02" name="productSelect" value="1059323"/>
				</li>
				<li>
					<label for="item03"><span></span><img src="http://webimage.10x10.co.kr/eventIMG/2014/52044/img_diy_product03.png" alt="" /></label>
					<input type="checkbox" id="item03" name="productSelect" value="1047275"/>
				</li>
				<li>
					<label for="item04"><span></span><img src="http://webimage.10x10.co.kr/eventIMG/2014/52044/img_diy_product04.png" alt="" /></label>
					<input type="checkbox" id="item04" name="productSelect" value="1036864"/>
				</li>
				<li>
					<label for="item05"><span></span><img src="http://webimage.10x10.co.kr/eventIMG/2014/52044/img_diy_product05.png" alt="" /></label>
					<input type="checkbox" id="item05" name="productSelect" value="877253"/>
				</li>
				<li>
					<label for="item06"><span></span><img src="http://webimage.10x10.co.kr/eventIMG/2014/52044/img_diy_product06.png" alt="" /></label>
					<input type="checkbox" id="item06" name="productSelect" value="674925"/>
				</li>
				<li>
					<label for="item07"><span></span><img src="http://webimage.10x10.co.kr/eventIMG/2014/52044/img_diy_product07.png" alt="" /></label>
					<input type="checkbox" id="item07" name="productSelect" value="1051116"/>
				</li>
				<li>
					<label for="item08"><span></span><img src="http://webimage.10x10.co.kr/eventIMG/2014/52044/img_diy_product08.png" alt="" /></label>
					<input type="checkbox" id="item08" name="productSelect" value="509868"/>
				</li>
				<li>
					<label for="item09"><span></span><img src="http://webimage.10x10.co.kr/eventIMG/2014/52044/img_diy_product09.png" alt="" /></label>
					<input type="checkbox" id="item09" name="productSelect" value="1576816"/>
				</li>
				<li>
					<label for="item10"><span></span><img src="http://webimage.10x10.co.kr/eventIMG/2014/52044/img_diy_product10.png" alt="" /></label>
					<input type="checkbox" id="item10" name="productSelect" value="886855"/>
				</li>
			</ul>
		</div>
		<p class="applyBtn"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/52044/btn_apply.png" alt="나의 DIY 패키지 응모하기" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52044/txt_cmt.png" alt="선택하신 상품들은 마이위시리스트에 자동 등록 됩니다." /></p>
	</div>
	</form>
	<!--// DIY 패키지 만들기 -->
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52044/bg_select_diy03.png" alt="" /></p>
	<div class="giftNoti">
		<dl>
			<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/52044/tit_noti.png" alt="사은품 선택 시 유의사항" style="width:74px;" /></dt>
			<dd>
				<ul>
					<li>텐바이텐 사은 이벤트는 텐바이텐 회원님을 위한 혜택입니다. (비회원 구매 증정 불가)</li>
					<li>사은품은 한정수량이므로, 수량이 모두 소진될 경우에는 이벤트가 자동 종료됩니다.</li>
					<li>상품 쿠폰, 보너스 쿠폰, 할인카드 등의 사용 후 <strong>구매확정 금액이 20만원/ 25만원</strong> 이어야 합니다.</li>
					<li>20만원/ 25만원 구매 시, 텐바이텐 배송상품을 반드시 포함해야 사은품을 받을 수 있습니다.</li>
					<li>마일리지, 예치금, GIFT 카드를 사용하신 경우는 구매확정금액에 포함되어 사은품을 받으실 수 있습니다.</li>
					<li>한 주문 건이 구매금액 기준 이상일 때 증정하며 다른 주문에 대한 누적적용이 되지 않습니다.</li>
					<li>사은품의 경우 구매하신 텐바이텐 배송 상품과 함께 배송됩니다.</li>
					<li>GIFT 카드를 구매하신 경우는 사은품과 사은 쿠폰이 증정되지 않습니다.</li>
					<li>환불이나 교환 시, 최종 구매 가격이 사은품 수령 가능 금액 미만이 될 경우, 사은품과 함께 반품해야 합니다.</li>
				</ul>
			</dd>
		</dl>
	</div>
</div>
<!--//  혹시 자리 있으세요? -->
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->