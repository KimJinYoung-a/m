<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 쿠폰으로 카트탈출
' History : 2017-08-09 유태욱
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim eCode, userid, couponcnt
dim getbonuscoupon1, couponcnt1
dim totalbonuscouponcountusingy1

IF application("Svr_Info") = "Dev" THEN
	eCode = 66419
	getbonuscoupon1 = 2852
Else
	eCode = 80133
	getbonuscoupon1 = 12788
End If

userid = getencloginuserid()

couponcnt=0
totalbonuscouponcountusingy1=0

couponcnt = getbonuscoupontotalcount(getbonuscoupon1, "", "", "")

if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" then
	totalbonuscouponcountusingy1 = getbonuscoupontotalcount(getbonuscoupon1, "", "Y","")
end if

%>
<style type="text/css">
.mEvt80133,
.mEvt80133 h2{position:relative;}
.coupon {position:relative;}
.coupon .soldout {position:absolute; top:0; left:0;}
.coupon .lastday {position:absolute; top:-15.18%; right:5%; width:22.65%;}
.coupon .hurry {position:absolute; top:64.18%; right:5%; width:18.43%; animation:bounce 1s 20;}
.cpLayer {display:none; position:absolute; left:0; top:0; z-index:100; width:100%; height:100%; background-color:rgba(13, 13, 13, 0.6);}
.cpLayer .layerCont {position:relative; width:80.46%; margin:7.2rem auto 0;}
.cpLayer .layerCont .btnClose {position:absolute; right:0; top:0; width:5rem; height:5rem; background-color:transparent; text-indent:-999em;}
.evtNoti {padding-top:3.6rem; background:#394f86 url(http://webimage.10x10.co.kr/eventIMG/2017/80133/m/bg_blue.jpg) 0 0 repeat; background-size:100%;}
.evtNoti h3 {padding-bottom:2.6rem; font-size:1.6rem; font-weight:bold; color:#fff; text-align:center;}
.evtNoti h3 span {border-bottom:0.15rem solid #fff;}
.evtNoti ul {padding:0 7.8%;}
.evtNoti li {position:relative; font-size:1rem; color:#fff; padding:0.4rem 0 0.4rem 1.6rem;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.65rem; width:0.6rem; height:0.15rem; background-color:#fff;}
@keyframes bounce {
	from to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(-8px); animation-timing-function:ease-in;}
}
</style>
<script type="text/javascript">
$(function(){
	//$(".cpLayer").hide();
	$(".btnDownload").click(function(event){

	});
	$(".btnClose").click(function(){
		$(".cpLayer").hide();
	});
});

function jsevtDownCoupon(stype,idx){
	<% If IsUserLoginOK() Then %>
		<% If now() > #08/30/2017 23:59:59# then %>
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
				$(".cpLayer").fadeIn();
				event.preventDefault();
				window.parent.$('html,body').animate({scrollTop:$('.cpLayer').offset().top},300);
				return false;
			}else if (str1[0] == "12"){
				alert('기간이 종료되었거나 유효하지 않은 쿠폰입니다.');
				return false;
			}else if (str1[0] == "13"){
				alert('이미 쿠폰이 발급되었습니다.\n8월 30일 자정까지 사용해주세요.');
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
					<div class="mEvt80133">
						<h2>
							<img src="http://webimage.10x10.co.kr/eventIMG/2017/80133/m/tit_coupon_v2.jpg" alt="발뮤다 쿠폰" />
							
						</h2>
						<div class="coupon">
							<a href="/street/street_brand.asp?makerid=itspace" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80133/m/img_prd.png" alt="사용기간은 8월 29일 부터 30일 까지 입니다." /></a>
							<a href="/street/street_brand.asp?makerid=itspace" onclick="fnAPPpopupBrand('itspace'); return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80133/m/img_prd.png" alt="사용기간은 8월 29일 부터 30일 까지 입니다." /></a>
							<a href="" class="btnDownload"  onclick="jsevtDownCoupon('prd,','<%= getbonuscoupon1 %>,'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80133/m/btn_coupon.png" alt="BALMUDA 전상품 10% 할인 사용기간은 8월 29일 부터 8월 30일입니다 쿠폰다운 받기" /></a>
							<% If now() > #08/29/2017 23:59:59# And now() < #08/30/2017 23:59:59# then %><span class="lastday"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80133/m/txt_last_day.png" alt="오늘이 마지막날" /></span><% End If %>
							<% If couponcnt >= 10000 Then %>
							<!-- 마감 임박 --><p class="hurry"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80133/m/txt_soon.png" alt="마감 임박" /></p>
							<% End If %>
						</div>
						<!-- 팝업 -->
						<div class="cpLayer">
							<div class="layerCont">
								<a href="/street/street_brand.asp?makerid=itspace" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80133/img_pop_up.png" alt="쿠폰이 발급되었습니다! 8/30일 까지 사용해주세요. 발뮤다 제품 보러가기" /></a>
								<a href="/street/street_brand.asp?makerid=itspace" onclick="fnAPPpopupBrand('itspace'); return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80133/img_pop_up.png" alt="쿠폰이 발급되었습니다! 8/30일 까지 사용해주세요. 발뮤다 제품 보러가기" /></a>
								<button type="button" class="btnClose">닫기</button>
							</div>
						</div>
						<a href="#group217405"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80133/m/txt_more_prd.jpg" alt="발뮤다상품보러가기 >" /></a>
						<div class="withTenten">
						<% if Not(IsUserLoginOK) then %>
							<% if isApp=1 then %>
								<a href="" onClick="parent.fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80133/m/btn_join.jpg" alt="텐바이텐에 처음 오셨나요? 회원가입하러가기" /></a>
							<% else %>
								<a href="/event/appdown/" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80133/m/btn_app.jpg" alt="텐바이텐 APP 아직인가요? 텐바이텐 APP 다운받기" /></a>
								<a href="/member/join.asp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80133/m/btn_join.jpg" alt="텐바이텐에 처음 오셨나요? 회원가입하러가기" /></a>
							<% end if %>
						<% else %>
							<% if isApp=1 then %>
							<% else %>
								<a href="/event/appdown/" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80133/m/btn_app.jpg" alt="텐바이텐 APP 아직인가요? 텐바이텐 APP 다운받기" /></a>
							<% end if %>
						<% end if %>
						</div>
						<div class="evtNoti">
							<h3><span>이벤트 유의사항</span></h3>
							<ul>
								<li>이벤트는 ID 당 1회만 참여할 수 있습니다.</li>
								<li>쿠폰은 8/30 23시59분59초에 종료됩니다.</li>
								<li>주문한 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
								<li>해당 브랜드 상품 소진 시 이벤트가 조기 종료될 수 있습니다.</li>
							</ul>
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/80133/m/img_ex.jpg" alt="" /></div>
						</div>
					</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->