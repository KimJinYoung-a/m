<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 나만 아는 쿠폰
' History : 2016-11-02 유태욱
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
dim getbonuscoupon1, getbonuscoupon2, getbonuscoupon3
dim totalbonuscouponcountusingy1, totalbonuscouponcountusingy2, totalbonuscouponcountusingy3

IF application("Svr_Info") = "Dev" THEN
	eCode = 66227
	getbonuscoupon1 = 2824
	getbonuscoupon2 = 2825
'	getbonuscoupon3 = 2798
Else
	eCode = 74058
	getbonuscoupon1 = 925	'10000/60000
	getbonuscoupon2 = 926	'200000/30000
'	getbonuscoupon3 = 879
End If

userid = getencloginuserid()

couponcnt=0
totalbonuscouponcountusingy1=0
totalbonuscouponcountusingy2=0
'totalbonuscouponcountusingy3=0

couponcnt = getbonuscoupontotalcount(getbonuscoupon1, "", "", "")

if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" then
	totalbonuscouponcountusingy1 = getbonuscoupontotalcount(getbonuscoupon1, "", "Y","")
	totalbonuscouponcountusingy2 = getbonuscoupontotalcount(getbonuscoupon2, "", "Y","")
'	totalbonuscouponcountusingy3 = getbonuscoupontotalcount(getbonuscoupon3, "", "Y","")
end if

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle	= Server.URLEncode("[텐바이텐] 나만 아는 쿠폰")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode)
snpPre		= Server.URLEncode("10x10 이벤트")
%>
<style type="text/css">
img {vertical-align:top;}

.couponDownload {position:relative;}
.couponDownload .soldOut {position:absolute; width:15.93%; bottom:14.28%; left:5.9%;animation:bounce 1s infinite;}
@keyframes bounce {
	from to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(-10px); animation-timing-function:ease-in;}
}
.shareSns {position:relative;}
.shareSns a {display:block; position:absolute; top:0; width:50%; height:100%; text-indent:-999em;}
.shareSns .fb{left:0;}
.shareSns .kakao{right:0;}

.eventNotice {position:relative;}
.eventNotice .noticeContent {position:absolute; padding:2.6rem 0 0 2.4rem;}
.eventNotice .noticeContent p {color:#ffffff; font-size:1.6rem; font-weight:bold; letter-spacing:0.005rem;}
.eventNotice .noticeContent ul {margin-top:1.5rem;}
.eventNotice .noticeContent ul li {position:relative; margin-top:0.6rem; padding-left:1.6rem; color:#ffffff; font-size:1rem; line-height:1.25rem;}
.eventNotice .noticeContent ul li:after {content:' '; display:block; position:absolute; top:0.6rem; left:0; width:0.6rem; height:0.1rem; background-color:#ffffff;}
</style>
<script type="text/javascript">

$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt74058").offset().top}, 0);
});

function jsevtDownCoupon(stype,idx){
	<% If IsUserLoginOK() Then %>
		<% If now() > #11/08/2016 23:59:59# then %>
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
				alert('쿠폰이 발급 되었습니다.\n11월 8일 자정까지 사용하세요. ');
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

function snschk(snsnum) {
	if(snsnum=="fb"){
		popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
	}else if(snsnum=="ka"){
		<% If isApp = "1" Then %>
			parent_kakaolink('[나만 아는 쿠폰]\n\n텐바이텐이 드리는\n11월의 마지막 할인 찬스!\n\n6만원 이상 구매시\n>10,000원 할인\n\n20만원 이상 구매시\n>30,000원 할인\n\n사용기간 : 11월7일~8일(2일간)\n\n쿠폰 다운받고 알뜰하게\n쇼핑하세요!', 'http://webimage.10x10.co.kr/eventIMG/2016/74058/m/74058_200x200.jpg' , '200' , '200' , 'http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=<%=eCode%>' );
		<% Else %>
			parent_kakaolink('[나만 아는 쿠폰]\n\n텐바이텐이 드리는\n11월의 마지막 할인 찬스!\n\n6만원 이상 구매시\n>10,000원 할인\n\n20만원 이상 구매시\n>30,000원 할인\n\n사용기간 : 11월7일~8일(2일간)\n\n쿠폰 다운받고 알뜰하게\n쇼핑하세요!' ,'http://webimage.10x10.co.kr/eventIMG/2016/74058/m/74058_200x200.jpg' , '200' , '200' , 'http://m.10x10.co.kr/event/eventmain.asp?eventid=<%=eCode%>' );
		<% End If %>
		return false;
	}
}
</script>
	<div class="mEvt74058">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/74058/m/tit_coupon.jpg" alt="나만 아는 쿠폰 11월의 마지막 할인 찬스! 쿠폰 다운 받고 알뜰하게 쇼핑하세요." /></h2>
		<div class="couponDownload">
			<% if couponcnt >= 28000 then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2016/74058/m/txt_sold_out.jpg" alt="쿠폰이 모두 소진되었습니다. 다음기회를 기다려주세요." />
			<% else %>
				<a href="" onclick="jsevtDownCoupon('evtsel,evtsel','<%= getbonuscoupon1 %>,<%= getbonuscoupon2 %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74058/m/txt_go_coupons.jpg" alt="6만원 이상 구매시 10,000원 쿠폰 20만원 이상 구매시 30000원 쿠폰 사용기간 : 11/7~8까지(2일간) 쿠폰 한번에 다운받기" /></a>
			<% end if %>

			<% if couponcnt >= 15000 and couponcnt < 28000 then %>
				<p class="soldOut"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74058/m/img_deadline.png" alt="마감임박" /></p>
			<% end if %>
		</div>
		<div class="appJoin">
			<%'' for dev msg : 모바일웹에서만 보여주세요 / 앱에서는 숨겨주세요 %>
			<% if isApp=1 then %>
			<% else %>
				<a href="/event/appdown/"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74058/m/btn_go_app.jpg" alt="텐바이텐 APP 아직이신가요? 텐바이텐 APP 다운" /></a>
			<% end if %>

			<%'' for dev msg : 로그인시 숨겨주세요 (비로그인시에만 보여주세요) %>
			<% if Not(IsUserLoginOK) then %>
				<% if isApp=1 then %>
					<%'' for dev msg : 로그인시 숨겨주세요 (비로그인시에만 보여주세요) %>
					<a href="" onClick="parent.fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74058/m/btn_go_sign_up.jpg" alt="텐바이텐에 처음 오셨나요? 회원가입하러 가기" /></a>
				<% else %>
					<a href="/member/join.asp"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74058/m/btn_go_sign_up.jpg" alt="텐바이텐에 처음 오셨나요? 회원가입하러 가기" /></a>
				<% end if %>
			<% end if %>
		</div>
		<div class="shareSns">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/74058/m/btn_share_conts_v2.jpg" alt="나만 아는 쿠폰을 소문내주세요 페이스북 트위터" /></p>
			<a href="" onclick="snschk('fb'); return false;"class="fb"><span>페이스북</span></a>
			<a href="" onclick="snschk('ka'); return false;" class="kakao"><span>카카오톡</span></a>
		</div>
		<div class="eventNotice">
			<div class="noticeContent">
				<p>이벤트 유의사항</p>
				<ul>
					<li>이벤트는 ID당 1회만 참여할 수 있습니다.</li>
					<li>지급된 쿠폰은 텐바이텐에서만 사용 가능합니다.</li>
					<li>쿠폰은 11/8(화) 23시59분59초 종료됩니다.</li>
					<li>주문한 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
					<li>이벤트는 조기 마감될 수 있습니다.</li>
				</ul>
			</div>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/74058/m/bg_noti.jpg" alt="주문결제 화면에서 할인정보의 보너스 쿠폰 선택 상자에서 나만 아는 쿠폰을 선택해주세요" /></p>
		</div>
		<%
		if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" then
			response.write couponcnt&"-발행수량<br>"
			response.write totalbonuscouponcountusingy1&"-사용수량(10,000/60,000)<br>"
			response.write totalbonuscouponcountusingy2&"-사용수량(30,000/200,000)<br>"
		end  if
		%>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
