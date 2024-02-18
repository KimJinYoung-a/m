<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 2017 Super Cool Festival
' History : 2017-06-23 정태훈
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->

<%
dim eCode, couponcnt1, couponcnt2,  getbonuscoupon1, getbonuscoupon2, getbonuscoupon3

IF application("Svr_Info") = "Dev" THEN
	eCode = 66352
	getbonuscoupon1 = 2847
	getbonuscoupon2 = 2848
'	getbonuscoupon3 = 0000
Else
	eCode = 78705
	getbonuscoupon1 = 12599	'10000/60000
	getbonuscoupon2 = 12598	'15000/100000
'	getbonuscoupon3 = 000
End If

couponcnt1=0
couponcnt2=0

couponcnt1 = getbonuscoupontotalcount(getbonuscoupon1, "", "", "")
couponcnt2 = getbonuscoupontotalcount(getbonuscoupon2, "", "", "")
%>
<style type="text/css">
.coolFestival {position:relative;}
.coolList li {position:relative;}
.coolList li span {position:absolute; animation:move1 1s ease-in-out 50;}
.coolList .coupon span {left:50%; bottom:5%; width:56%; margin-left:-28%; }
.coolList .justCoolday .itemInfo {position:absolute; left:50%; top:17.6%; width:63%; margin-left:-31.5%;}
.coolList .justCoolday .itemInfo .thumb {width:71%; margin:0 auto;}
.coolList .justCoolday .itemInfo .box {height:6.1rem; margin-top:2.4rem; padding-top:1.7rem; font-weight:bold; text-align:center; background:#fff;}
.coolList .justCoolday .itemInfo .name {overflow:hidden; width:100%; padding:0 1rem; font-weight:bold; font-size:1.2rem; color:#000; text-overflow:ellipsis; white-space:nowrap;}
.coolList .justCoolday .itemInfo .price {padding-top:0.7rem; font-size:1.5rem; color:#f52929;}
.coolList .justCoolday .itemInfo .price s {font-size:1.2rem; color:#979797;}
.coolList .justCoolday .itemInfo .btnBuy {display:block; position:absolute; left:0; top:0; width:100%; height:100%; text-indent:-999em;}
.coolList .payco span {left:55%; bottom:17%; width:26.5%;}
.shareSns {position:relative;}
.shareSns a {position:absolute; top:52%; width:17.5%; height:33%; background:transparent; text-indent:-999em;}
.shareSns a.btnKakao {left:22.5%;}
.shareSns a.btnFb {left:41%;}
.shareSns a.btnTw {left:59.5%;}
#couponLayer {overflow:hidden; position:absolute; left:0; top:0; width:100%; height:100%; padding-top:1rem; background-color:rgba(0,0,0,.5);}
#couponLayer .couponCont {position:relative; width:79%; margin:0 auto;}
#couponLayer .btnClose {position:absolute; right:-15%;; top:6%; width:33%; background:transparent;}
@keyframes move1{
	from,to {transform:translateY(0);}
	50% {transform:translateY(5px);}
}
</style>
<script src="/lib/js/kakao.Link.js"></script>
<script type="text/javascript">
$(function(){
	// 쿠폰 다운로드
	$(".coolList li.coupon a").click(function(){
		$("#couponLayer").show();
		window.parent.$('html,body').animate({scrollTop:$("#couponLayer").offset().top}, 800);
	});
	$("#couponLayer .btnClose").click(function(){
		$("#couponLayer").hide();
	});
});

function jsevtDownCoupon(stype,idx){
	<% If IsUserLoginOK() Then %>
		<% If now() > #07/05/2017 23:59:59# then %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% else %>
			var str = $.ajax({
				type: "POST",
				url: "/event/etc/coupon/couponshop_process.asp",
				data: "mode=cpok&stype="+stype+"&idx="+idx,
				dataType: "text",
				async: false
			}).responseText;
			var str1 = str.split("||")
			if (str1[0] == "11"){
				alert('쿠폰이 발급되었습니다.');
				return false;
			}else if (str1[0] == "12"){
				alert('기간이 종료되었거나 유효하지 않은 쿠폰입니다.');
				return false;
			}else if (str1[0] == "13"){
				alert('이미 발급 받으셨습니다. 이벤트는 ID당 1회만 참여 할 수 있습니다.');
				return false;
			}else if (str1[0] == "02"){
				alert('로그인 후 쿠폰을 받을 수 있습니다!');
				return false;
			}else if (str1[0] == "01"){
				alert('잘못된 접속입니다.');
				return false;
			}else if (str1[0] == "00"){
				alert('정상적인 경로가 아닙니다.');
				return false;
			}else{
				alert('오류가 발생했습니다.');
				return false;
			}
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End IF %>
}
function tnKakaoLink(title){
<% if isApp=1 then %>
	parent_kakaolink(title, 'http://webimage.10x10.co.kr/eventIMG/2017/78705/etcitemban20170623213010.JPEG' , '200' , '200' , 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=78705');
	return false;
<% Else %>
	parent_kakaolink(title , 'http://webimage.10x10.co.kr/eventIMG/2017/78705/etcitemban20170623213010.JPEG' , '200' , '200' , 'http://m.10x10.co.kr/event/eventmain.asp?eventid=78705');
	return false;
<% End If %>
}
</script>
<%
Dim ix, dateNum, CountArr, StartDate, ItemCode
Dim arrStartDate, arrItemCode, oItem
dateNum=0
StartDate = "2017-06-26,2017-06-27,2017-06-28,2017-06-29,2017-06-30,2017-07-01,2017-07-02,2017-07-03,2017-07-04,2017-07-05"
ItemCode = "1523832,1141232,1523842,1740217,1523834,1641124,1641124,1516362,1638449,1543558"

arrStartDate = Split(StartDate,",")
arrItemCode = Split(ItemCode,",")
CountArr = ubound(arrStartDate)

For ix=0 To CountArr-1
	If arrStartDate(ix)=left(now(),10) Then
		dateNum=ix
	End If
Next

set oItem = new CatePrdCls
oItem.GetItemData arrItemCode(dateNum)
%>
<!-- COOL FESTIVAL-->
<div class="mEvt78705 coolFestival">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/78705/m/tit_super_cool.png" alt="SUPER COOL" /></h2>
	<ul class="coolList">
		<li class="coupon">
			<a href="#couponLayer">
				<img src="http://webimage.10x10.co.kr/eventIMG/2017/78705/m/img_coupon.jpg" alt="쿠폰 최대 20%" />
				<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78705/m/btn_download.png" alt="쿠폰 다운받기" /></span>
			</a>
		</li>
		<li><a href="eventmain.asp?eventid=78732"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78705/m/img_gift_v2.jpg" alt="구매사은품 - 5만원 이상 구매시 곰손풍기 증정" /></a></li>
		<li class="justCoolday">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/78705/m/txt_cool_price.png" alt="  오늘 하루만 시원한 가격! " /></p>
			<!-- JUST COOL ITEM (10일동안 매일 매일 바뀌는 부분) -->
			<div class="itemInfo">
				<div class="thumb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78705/m/img_cool_item_<%=dateNum+1%>.png" alt="" /></div>
				<div class="box">
					<p class="name"><%=oItem.Prd.Fitemname%></p>
					<p class="price">
					<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN%>
					<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%></s>
					<% Else %>
					<%= FormatNumber(oItem.Prd.getOrgPrice,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","원")%>
					<% End If %>
					<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN
						Response.Write FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","원") & " ["
						If oItem.Prd.FOrgprice = 0 Then
							Response.Write "0%]"
						Else
							Response.Write CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) & "%]"
						End If
					End If %>
					</p>
				</div>
				<% if isApp=1 then %>
				<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=oItem.Prd.FItemid%>&pEtr=78705" onclick="fnAPPpopupProduct('<%=oItem.Prd.FItemid%>&amp;pEtr=78705');return false;" class="btnBuy mApp">구매하러 가기</a>
				<% else %>
				<a href="/category/category_itemPrd.asp?itemid=<%=oItem.Prd.FItemid%>&amp;pEtr=78705" class="btnBuy mWeb">구매하러 가기</a>
				<% end if %>
			</div>
			<!--// JUST COOL ITEM -->
		</li>
		<li><a href="eventmain.asp?eventid=78825"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78705/m/img_event_1_v2.png" alt="전국의 휴가특보 TOP10!" /></a></li>
		<li><a href="eventmain.asp?eventid=78682"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78705/m/img_event_2.png" alt="썸머 컬러픽" /></a></li>
		<li><a href="eventmain.asp?eventid=78728"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78705/m/img_event_3.png" alt="SWIMMING, PLAY, ENJOY!" /></a></li>
		<li class="payco">
			<a href="eventmain.asp?eventid=78681">
				<img src="http://webimage.10x10.co.kr/eventIMG/2017/78705/m/img_payco.png" alt="페이코 할인혜택" />
				<span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78705/m/btn_discount.png" alt="즉시할인" /></span>
			</a>
		</li>
	</ul>
	<!-- 쿠폰 다운로드 -->
	<div id="couponLayer" style="display:none;">
		<div class="couponCont">
			<a href=""><img src="http://webimage.10x10.co.kr/eventIMG/2017/78705/m/img_download.png" alt="쿠폰 다운로드 받기" onclick="jsevtDownCoupon('prd,prd','<%= getbonuscoupon1 %>,<%= getbonuscoupon2 %>'); return false;" /></a>
			<button type="button" class="btnClose" onclick="ClosePopLayer();"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78705/m/btn_close.png" alt="닫기" /></button>
		</div>
	</div>
	<!--// 쿠폰 다운로드 -->
<%
'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
dim snpTitle, snpLink, snpPre, snpTag, snpTag2
snpTitle = Server.URLEncode("SUPER COOL FESTIVAL")
snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=78705")
snpPre = Server.URLEncode("텐바이텐 이벤트")
snpTag = Server.URLEncode("텐바이텐 SUPERCOOLFESTIVAL")
snpTag2 = Server.URLEncode("#10x10")
''snpImg = Server.URLEncode(emimg)	'상단에서 생성
%>
	<div class="shareSns">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/78705/m/txt_share.png" alt="무더워 지는 지금! 텐바이텐을 즐기면 기쁨이 두배" /></p>
		<a href="" class="btnKakao" onclick="tnKakaoLink('<%=snpTitle%>');return false;">카카오톡으로 공유</a>
		<a href="" class="btnFb" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');return false;">페이스북으로 공유</a>
		<a href="" class="btnTw" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');return false;">트위터로 공유</a>
	</div>
</div>
<!--// COOL FESTIVAL-->
<%
Set oItem = nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->