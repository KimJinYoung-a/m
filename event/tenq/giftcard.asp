<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
'####################################################
' Description : 텐큐베리감사 : 천백만원
' History : 2018-03-30 정태훈
'####################################################
Dim eCode, userid

IF application("Svr_Info") = "Dev" THEN
	eCode   =  67498
Else
	eCode   =  85148
End If

userid = GetEncLoginUserID()

%>
<style type="text/css">
.process {position:relative;}
.process .btn-go {position:absolute; left:13%; bottom:7%; width:74%; animation:bounce .5s 50 alternate;}
.noti {background:#f49090;}
.noti ul {padding:0 6% 4.1rem;}
.noti li {padding:1rem 0 0 0.65rem; color:#fff; font-size:rem; line-height:1.45rem; text-indent:-0.65rem;}
.noti li:first-child {padding-top:0;}
.tenq-navigation {background-color:#fff;}
.tenq-navigation li {padding-top:0.85rem;}
.tenq-navigation li:first-child {padding-top:0;}
@keyframes bounce {
	0% {transform:translateY(0);}
	100% {transform:translateY(-10px);}
}
</style>
			<!-- 텐큐베리감사 : 천백만원 -->
			<div class="mEvt85145 tenq miracle">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85148/m/tit_1100.png" alt="당첨자 총 1,001명에게 드려요 천백만원!" /></h2>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85148/m/txt_giftcard.png" alt="당첨자 1명 100만원, 당첨자 1000명 1만원" /></p>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85148/m/txt_random_1100.png" alt="기프트카드는 전원 증정이 아닌, 이벤트 기간 동안 구매한 텐바이텐 배송 상품에 무작위로 담겨 발송될 예정입니다!" /></p>
				<div class="process">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85148/m/txt_process.png" alt="참여방법:텐바이텐 배송상품 포함 6만원 이상 구매하고 텐바이텐 배송박스를 뜯어 카드 확인" /></p>
					<a href="/event/eventmain.asp?eventid=85321" class="btn-go mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85148/m/btn_go.png" alt="텐텐배송 상품 보러가기" /></a>
					<a href="#" onclick="fnAPPpopupEvent('85321'); return false;" class="btn-go mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85148/m/btn_go.png" alt="텐텐배송 상품 보러가기" /></a>
				</div>
				<!-- 유의사항 -->
				<div class="noti">
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85148/m/tit_noti.png" alt="유의사항" /></h3>
					<ul>
						<li>- 본 이벤트는 텐바이텐 회원님을 위한 혜택입니다.(비회원 구매 시, 증정 불가)</li>
						<li>- 기프트카드는 이벤트 기간 동안 구매한 텐텐배송 상품 중 무작위로 선출하여 발송 됩니다.</li>
						<li>- 텐바이텐 배송상품을 포함해서 구매 확정액이 6만원 이상이어야 이벤트 참여가 가능합니다.</li>
						<li>- 구매 확정액은 상품 쿠폰, 보너스 쿠폰 적용 후 결제한 금액이 6만원 이상이어야 합니다.(단일 주문건 구매 확정액)</li>
						<li>- 텐바이텐 Gift카드를 구매하신 경우에는 이벤트참여 조건이 되지 않습니다.</li>
						<li>- 구매자에게는 상품에 따라 세무신고에 필요한 개인정보를 요청할 수 있습니다. 제세공과금은 텐바이텐 부담입니다. </li>
						<li>- 환불이나 교환 시, 최종 구매가격이 6만원 미만일 경우 기프트카드와 함께 반품해야 합니다.</li>
					</ul>
				</div>
				<div class="tenq-navigation">
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/m/txt_event.png" alt="이벤트 더보기" /></h3>
					<ul>
						<li><a href="<%=chkiif(isapp="1","/apps/appcom/wish/web2014/event/","/event/")%>eventmain.asp?eventid=85144"><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/m/bnr_main.png" alt="텐큐베리감사 다양한 혜택의 쿠폰받기" /></a></li>
						<li><% If isapp="1" Then %><a href="/apps/appcom/wish/web2014/event/eventmain.asp?eventid=85146"><% Else %><a href="/event/eventmain.asp?eventid=85634"><% End If %><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/m/bnr_mileage.png" alt="매일받자 마일리지" /></a></li>
						<li><a href="<%=chkiif(isapp="1","/apps/appcom/wish/web2014/event/","/event/")%>eventmain.asp?eventid=85147"><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/m/bnr_giftbox.png" alt="두근두근 선물박스" /></a></li>
					</ul>
				</div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->