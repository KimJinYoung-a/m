<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 설문조사
' History : 2017-01-20 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/event/etc/evtyouCls.asp" -->
<% If not(IsUserLoginOK()) Then %>
<script>
<% if isApp=1 then %>
parent.calllogin();
<% else %>
parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=79281")%>');
<% end if %>
</script>
<%
Response.end
End If
%>
<%
dim eCode, userid, lp
Dim intI, oHTBCItem, getbonuscoupon

IF application("Svr_Info") = "Dev" THEN
	eCode = "66401"
	getbonuscoupon = 2854
Else
	eCode = "79281"
	getbonuscoupon = 1000
End If
Dim logparam : logparam = "&pEtr="&eCode
userid = GetEncLoginUserID()

dim couponexistscount
	couponexistscount = getbonuscouponexistscount(userid, getbonuscoupon, "", "", "")

'//클래스 선언
set oHTBCItem = New CEvtYou
oHTBCItem.FRectUserID = userid
'// 텐바이텐 해피투게더 상품 목록
oHTBCItem.GetCateRightHappyTogetherList
%>
<style type="text/css">
.mEvt79281 {background-color:#fff;}
.rcmBox p {padding:0 9.5rem; font-size:1.3rem; line-height:2.5rem; text-align:center; font-weight:bold;}
.rcmBox .userId span{display:inline-block; padding:0 .3rem; font-size:2rem; line-height:2rem; border-bottom:0.2rem solid #000;}
.prdList {padding: 0 6.25%;}
.prdList li {padding:4.5rem 1.5rem; border-bottom:1px solid #e6e6e6;}
.prdList li:nth-child(1) {padding-top:4rem;}
.prdList li:nth-child(9) {border-bottom:none;}
.prdList li .prdImg {width:25rem; height:25rem;}
.prdList li .prdImg img{width:100%; height:100%;}
.prdList li .prdInfo {text-align:center; font-weight:bold;}
.prdList li .prdInfo .brand {padding:3rem 0 1.1rem;font-size:1.2rem; line-height:1.2rem; text-decoration:underline; color:#666666; font-weight:normal;}
.prdList li .prdInfo .name a{display:-webkit-box; overflow:hidden; width:cal(100%-4rem); height:4.2rem; padding:0 2rem; margin:0 auto; font-size:1.6rem; line-height:2.2rem; word-wrap:break-word; text-overflow:ellipsis; -webkit-line-clamp:2; -webkit-box-orient:vertical; white-space:normal;}
.prdList li .prdInfo .price {padding-top:1.1rem; font-size:1.3rem; color:#df4b4b;}
</style>
<script type="text/javascript">
function jsevtDownCoupon(stype,idx){
	<% If IsUserLoginOK() Then %>
		<% If now() > #09/30/2017 23:59:59# then %>
			alert("쿠폰 다운로드 기간이 지났습니다.");
			return;
		<% elseif couponexistscount <> 0 then %>
			alert("이미 쿠폰을 다운받으셨습니다.");
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
				alert('쿠폰이 발급 되었습니다.\n오늘 하루 텐바이텐에서 사용하세요!');
				return false;
			}else if (str1[0] == "12"){
				alert('기간이 종료되었거나 유효하지 않은 쿠폰입니다.');
				return false;
			}else if (str1[0] == "13"){
				alert('이미 다운로드 받으셨습니다.');
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
</script>
<div class="evtContV15">
	<div class="mEvt79281">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/79281/m/tit_you.jpg" alt="You" /></h2>
	<a href="#coupon"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79281/m/btn_go_coupnon.jpg" alt="쿠폰을 확인해 보세요" /></a>
	<div class="rcmBox">
		<img src="http://webimage.10x10.co.kr/eventIMG/2017/79281/m/img_heart.jpg" alt="" />
		<p class="userId"><span><%=GetLoginUserName()%></span>님</p>
		<p>이런 상품은 어떠세요?</p>
	</div>
	<% IF oHTBCItem.FResultCount > 0 Then %>
	<ul class="prdList">
		<% For lp =0 To oHTBCItem.FResultCount-1 %>
		<% if isApp=1 then %>
		<li>
			<div class="prdImg"><a href="javascript:fnAPPpopupProduct(<%=oHTBCItem.FItemList(lp).FItemID %>);"><img src="<%=oHTBCItem.FItemList(lp).Ftentenimage400%>" alt="" /></a></div>
			<div class="prdInfo">
				<p class="brand"><a href="javascript:fnAPPpopupAutoUrl('/street/street_brand.asp?makerid=<%=oHTBCItem.FItemList(lp).FMakerId %><%=logparam%>');"><%=oHTBCItem.FItemList(lp).FBrandName %></a></p>
				<p class="name"><a href="javascript:fnAPPpopupProduct(<%=oHTBCItem.FItemList(lp).FItemID %>);"><%=oHTBCItem.FItemList(lp).FItemName%></a></p>
				<p class="price"><% = FormatNumber(oHTBCItem.FItemList(lp).getRealPrice,0) %>원<% IF oHTBCItem.FItemList(lp).IsSaleItem Then %> <span class="sale">[<% = oHTBCItem.FItemList(lp).getSalePro %>]</span><% End If %></p>
			</div>
		</li>
		<% Else %>
		<li>
			<div class="prdImg"><a href="/category/category_itemPrd.asp?itemid=<%=oHTBCItem.FItemList(lp).FItemID %><%=logparam%>"><img src="<%=oHTBCItem.FItemList(lp).Ftentenimage400%>" alt="" /></a></div>
			<div class="prdInfo">
				<p class="brand"><a href="/street/street_brand.asp?makerid=<%=oHTBCItem.FItemList(lp).FMakerId %>"><%=oHTBCItem.FItemList(lp).FBrandName %></a></p>
				<p class="name"><a href="/category/category_itemPrd.asp?itemid=<%=oHTBCItem.FItemList(lp).FItemID %><%=logparam%>"><%=oHTBCItem.FItemList(lp).FItemName%></a></p>
				<p class="price"><% = FormatNumber(oHTBCItem.FItemList(lp).getRealPrice,0) %>원<% IF oHTBCItem.FItemList(lp).IsSaleItem Then %> <span class="sale">[<% = oHTBCItem.FItemList(lp).getSalePro %>]</span><% End If %></p>
			</div>
		</li>
		<% End If %>
		<% Next %>
	</ul>
	<% End If %>
	<a href="" onclick="jsevtDownCoupon('evttosel','<%= getbonuscoupon %>'); return false;" class="coupon" id="coupon"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79281/m/img_coupon.jpg" alt="쿠폰 다운받기" /></a>
	</div>
</div>
<%
Set oHTBCItem = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->