<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 플레이, 첫 구매! MA
' History : 2016-06-16 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
Dim eCode, userid, currenttime, i, couponidx, selectitemid
currenttime	= now()
userid		= GetEncLoginUserID()

If application("Svr_Info") = "Dev" Then
	eCode			= "66154"
	couponidx		= "10104"
	selectitemid	= "1210578"
Else
	eCode			= "71255"
	'couponidx		= "11715"
	couponidx = "11848"
	selectitemid	= "1510805"
End If

dim subscriptcount, itemcouponcount , totcnt
subscriptcount=0
itemcouponcount=0
totcnt = 0

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount11(eCode, userid, "", "", "")
	itemcouponcount = getitemcouponexistscount(userid, couponidx, "", "")
end if
totcnt = getitemcouponexistscount("", couponidx, "", "")

dim administrator
	administrator=FALSE

if userid="greenteenz" or userid="djjung" or userid="okkang77" or userid="kyungae13" or userid="tozzinet" or userid="thensi7" or userid="baboytw" Or userid="motions" then
	administrator=TRUE
end If

%>
<style type="text/css">
img {vertical-align:top;}
.mEvt71225 {overflow:hidden; position:relative;}
.swiper {position:relative; background:#f8c53a;}
.swiper button {position:absolute; top:44%; z-index:40; width:12.5%; background:transparent;}
.swiper .prev {left:0;}
.swiper .next {right:0;}
.getCoupon {position:relative; }
.getCoupon .goBuy {position:absolute; left:13%; top:73.6%; width:70%;}
.evtNoti {color:#fff; padding:1.9rem 4.7% 0; background:#075177;}
.evtNoti h3 {padding-bottom:0.8rem;}
.evtNoti h3 strong {display:inline-block; font-size:1.4rem; line-height:2.1rem; padding-left:2.5rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/71225/m/ico_mark.png) no-repeat 0 0; background-size:1.9rem 1.9rem;}
.evtNoti li {position:relative; padding-left:10px; font-size:1.1rem; line-height:1.4; letter-spacing:-0.012em;}
.evtNoti li a {display:block; width:10.5rem; margin:0.3rem 0 0.8rem;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.55rem; width:0.4rem; height:1px; background:#fff;}
.couponLayer {position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.6); z-index:50;}
.couponLayer .layerCont {position:absolute; left:6%; top:8%; width:88%;}
.couponLayer .btnClose {position:absolute; right:5.5%; top:4.5%; z-index:55; width:10%; background:transparent;}

/* animation */
.move {animation:move 0.3s ease-in-out 2s 40 alternate;}
@keyframes move {from {transform:translate(0,-6px);} to {transform:translate(0,0);}}
</style>
<script type="text/javascript">
$(function(){
	showSwiper= new Swiper('.swiper1',{
		loop:true,
		pagination:false,
		speed:400,
		autoplay:2500,
		nextButton:'.next',
		prevButton:'.prev',
		effect:'fade'
	});

	$(".btnClose").click(function(){
		$("#couponLayer").fadeOut(300);
	});
});

function jscoupondown(){
	<% If IsUserLoginOK() Then %>
		<% If Now() > #08/15/2016 23:59:59# Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if GetLoginUserLevel<>"5" and not(administrator) then %>
				alert("고객님은 쿠폰발급 대상이 아닙니다.");
				return;
			<% else %>
				<% if administrator then %>
					alert("[관리자] 특별히 관리자님이니까 오렌지 등급이 아니여도 다음 단계로 진행 시켜 드릴께요!");
				<% end if %>
				var str = $.ajax({
					type: "POST",
					url: "/event/etc/doeventsubscript/doEventSubscript71255.asp",
					data: "mode=coupondown&isapp=<%= isapp %>",
					dataType: "text",
					async: false
				}).responseText;
				var str1 = str.split("||")
				if (str1[0] == "11"){
					$("#couponLayer").empty().html(str1[1]);
					$("#couponLayer").fadeIn(300);
					$('html,body').animate({scrollTop: $("#title").offset().top},'slow');
					return false;
				}else if (str1[0] == "10"){
					alert('데이터 처리에 예외 상황이 발생하였습니다. 관리자에게 문의해주십시오.');
					return false;
				}else if (str1[0] == "09"){
					$("#couponLayer").empty().html(str1[1]);
					$("#couponLayer").show();
					$('html,body').animate({scrollTop: $("#title").offset().top},'slow');
					return false;
				}else if (str1[0] == "08"){
					alert('기간이 종료되었거나 유효하지 않은 쿠폰입니다.');
					return false;
				}else if (str1[0] == "07"){
					alert('데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해주십시오.');
					return false;
				}else if (str1[0] == "06"){
					alert('쿠폰은 오전 10시부터 다운 받으실수 있습니다.');
					return false;
				}else if (str1[0] == "05"){
					alert('고객님은 쿠폰발급 대상이 아닙니다.');
					return false;
				}else if (str1[0] == "04"){
					$("#couponLayer").empty().html(str1[1]);
					$("#couponLayer").fadeIn();
					$('html,body').animate({scrollTop: $("#title").offset().top},'slow');
					return false;
				}else if (str1[0] == "03"){
					alert('이벤트 응모 기간이 아닙니다.');
					return false;
				}else if (str1[0] == "03"){
					alert('이벤트 응모 기간이 아닙니다.');
					return false;
				}else if (str1[0] == "02"){
					alert('로그인을 해주세요.');
					return false;
				}else if (str1[0] == "01"){
					alert('잘못된 접속입니다.');
					return false;
				}else if (str1[0] == "00"){
					alert('정상적인 경로가 아닙니다.');
					return false;
				}else if (str1[0] == "12"){
					alert('오전 10시부터 응모하실 수 있습니다.');
					return false;
				}else{
					alert('오류가 발생했습니다.');
					return false;
				}
			<% end if %>
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

function goDirOrdItem()
{
	<% if isapp="1" then %>
        document.directOrd.target = "iiBagWin";
	<% end if %>
	document.directOrd.submit();
}

function poplayerclose()
{
	$("#couponLayer").hide();
	location.reload();
}
</script>
<% If administrator Then %>
<div>현재 수량 :  <%=totcnt%> /// 제한 수량 : 1910</div>
<% End If %>
<div class="mEvt71225">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/71225/m/tit_play.png" alt="플레이 첫 구매" /></h2>
	<div class="swiper">
		<div class="swiper-container swiper1">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71225/m/img_item_01.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71225/m/img_item_02.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71225/m/img_item_03.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71225/m/img_item_04.jpg" alt="" /></div>
			</div>
		</div>
		<button type="button" class="prev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71225/m/btn_prev.png" alt="이전" /></button>
		<button type="button" class="next"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71225/m/btn_next.png" alt="다음" /></button>
	</div>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/71225/m/txt_price.png" alt="플레이모빌 미스터리 피규어 시리즈9(랜덤발송) - 3000원(쿠폰할인가)" /></p>
	<% '-- 쿠폰다운 %>
	<div class="getCoupon">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/71225/m/txt_first_buy.png" alt="오늘 당신만을 위한 엄청난 쿠폰으로 첫 구매에 도전하세요!" /></p>
		<a href="#couponLayer" class="goBuy move" <% If totcnt < 1910 Then %>onclick="jscoupondown(); return false;"<% End If %>>
			<% If totcnt < 1910 Then %>
			<img src="http://webimage.10x10.co.kr/eventIMG/2016/71225/m/btn_buy.png" alt="쿠폰 받고 구매하러 가기" />
			<% Else %>
			<img src="http://webimage.10x10.co.kr/eventIMG/2016/71225/m/btn_soldout.png" alt="SOLD OUT" />
			<% End If %>
		</a>
	</div>

	<% '-- 구매하러가기 레이어 %>
	<div id="couponLayer" class="couponLayer" style="display:none;"></div>

	<div class="evtNoti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<li>
				텐바이텐에서 한번도 구매이력이 없는 오렌지등급 고객님을 위한 이벤트입니다.
				<% If isapp="1" Then %>
					<p><a href="" onclick="fnAPPpopupBrowserURL('10X10 등급혜택','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/userinfo/pop_Benefit.asp');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71225/m/btn_grade.png" alt="회원등급 보러가기" /></a></p>
				<% Else %>
					<p><a href="" onclick="window.open('/my10x10/userinfo/pop_Benefit.asp','addreg','width=400,height=400,scrollbars=yes,resizable=yes');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71225/m/btn_grade.png" alt="회원등급 보러가기" /></a></p>
				<% End If %>
			</li>
			<li>본 이벤트는 로그인 후에 참여가 가능합니다.</li>
			<li>ID 당 1회만 구매가 가능합니다.</li>
			<li>이벤트는 조기 마감 될 수 있습니다.</li>
			<li>이벤트는 즉시결제로만 구매가 가능하며, 배송 후 반품/교환/구매취소가 불가능합니다.</li>
		</ul>
	</div>
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/71225/m/img_ex.png" alt="" /></div>
</div>
<% If isapp="1" Then %>
	<form method="post" name="directOrd" action="/apps/appCom/wish/web2014/inipay/shoppingbag_process.asp">
<% Else %>
	<form method="post" name="directOrd" action="/inipay/shoppingbag_process.asp">
<% End If %>
	<input type="hidden" name="itemid" value="<%=selectitemid%>">
	<input type="hidden" name="itemoption" value="0000">
	<input type="hidden" name="itemea" value="1">
<% If isapp="1" Then %>
	<input type="hidden" name="mode" value="DO3">
<% Else %>
	<input type="hidden" name="mode" value="DO1">
<% End If %>
</form>
<iframe src="" name="iiBagWin" frameborder="0" width="0" height="0"></iframe>
<%
function getevent_subscriptexistscount11(evt_code, userid, sub_opt1, sub_opt2, sub_opt3)
	dim sqlstr, tmevent_subscriptexistscount
	
	if evt_code="" or userid="" then
		getevent_subscriptexistscount11=99999
		exit function
	end if
	
	sqlstr = "select count(*) as cnt"
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript] sc"
	sqlstr = sqlstr & " where sc.sub_idx > '8003642' and sc.evt_code="& evt_code &""
	sqlstr = sqlstr & " and sc.userid='"& userid &"'"
	
	if sub_opt1<>"" then
		sqlstr = sqlstr & " and isnull(sc.sub_opt1,'') = '"& sub_opt1 &"'"
	end if
	if sub_opt2<>"" then
		sqlstr = sqlstr & " and isnull(sc.sub_opt2,'') = '"& sub_opt2 &"'"
	end if
	if sub_opt3<>"" then
		sqlstr = sqlstr & " and isnull(sc.sub_opt3,'') = '"& sub_opt3 &"'"
	end if
	
	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		tmevent_subscriptexistscount = rsget("cnt")
	END IF
	rsget.close
	
	getevent_subscriptexistscount11 = tmevent_subscriptexistscount
end function
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->