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
' Description :  캣앤 독 이벤트 90662
' History : 2018-11-23 최종원 
'####################################################
dim eCode, couponIdx

IF application("Svr_Info") = "Dev" THEN
	eCode = "89195"
	couponIdx = "2889"
Else
	eCode = "90662"
	couponIdx = "1107"	
End If

%>
 <base href="http://m.10x10.co.kr/">
<style type="text/css">
.mania-day {background-color:#41b1df;}
.topic {position:relative;}
.mania-day .label {position:absolute; top:43%; left:3.46%; z-index:20; width:32.26%;}
.mania-day .slideshow {position:absolute; bottom:0; left:0; width:100%;}
#slideshow div {position:absolute; bottom:0; right:0; z-index:8; width:100%; opacity:0.0;}
#slideshow div.active {z-index:10; opacity:1.0;}
#slideshow div.last-active {z-index:9;}
.bnr-mania-day {background-color:#41b1df;}
.rotate-animation {backface-visibility:visible; animation:rotate-animation 1.5s; animation-fill-mode:both;}
@keyframes rotate-animation {
	0% {transform: scale(0) rotate(-180deg); opacity:0;}
	50% {transform: scale(1) rotate(0deg); opacity:1;}
	70% {transform: scale(0.8) rotate(0deg);}
	100% {transform: scale(1) rotate(0deg);}
}
.bnr-mania-item ul {overflow:hidden; position:absolute; left:7%; top:0; width:86%; height:93%;}
.bnr-mania-item ul li {float:left; width:50%; height:50%; }
.bnr-mania-item ul li a {overflow:hidden; display:block; width:100%; height:100%; text-indent:-990em;}
</style>
<script type="text/javascript">
var isStopped = false;
function slideSwitch() {
	if (!isStopped) {
		var $active = $("#slideshow div.active");
		if ($active.length == 0) $active = $("#slideshow div:last");
		var $next = $active.next().length ? $active.next() : $("#slideshow div:first");

		$active.addClass("last-active");

		$next.css({
		}).addClass("active").animate({
			}, 0, function() {
			$active.removeClass("active last-active");
		});
	}
}
$(function() {
	setInterval(function() {
		slideSwitch();
	}, 800);

	$("#slideshow").hover(function() {
		isStopped = true;
	}, function() {
		isStopped = false;
	});
});
</script>
<script type="text/javascript">
function jsDownCoupon2(stype,idx){						
	<% if Not(IsUserLoginOK) then %>
		jsEventLogin();
	<% else %>
	$.ajax({
		type: "post",
		url: "/shoppingtoday/act_couponshop_process.asp",
		data: "idx="+idx+"&stype="+stype,
		cache: false,
		success: function(message) {
			if(typeof(message)=="object") {				
				alert(message.message);
			} else {
				alert("처리중 오류가 발생했습니다.");
			}
		},
		error: function(err) {
			console.log(err.responseText);
		}
	});
	<% end if %>
}
function jsEventLogin(){
	<% if isApp="1" then %>
		calllogin();
	<% else %>
		jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
	<% end if %>
	return;
}
</script>
            <!-- [카테고리데이] 카테고리 데이 cat and dog : 90662 -->
            <div class="mEvt90662 mania-day">
                <div class="topic">
                    <h2><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90662/m/tit_mania.png" alt="매월 마지막 주는 CAT&DOG DAY" /></h2>
                    <h3 class="label rotate-animation"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90662/m/tit_today.png" alt="오늘의 카테고리 CAT&DOG" /></h3>
                    <div id="slideshow" class="slideshow">
                        <div class="active">
                            <a href="/category/category_itemPrd.asp?itemid=1889071&pEtr=90662" onclick="TnGotoProduct('1889071');return false;">
                                <img src="http://webimage.10x10.co.kr/fixevent/event/2018/90662/m/img_item_01.png" alt="[Disney] PUPPYPADDING (Mickey/Pooh)" />
                            </a>
                        </div>
                        <div>
                            <a href="/category/category_itemPrd.asp?itemid=2117551&pEtr=90662" onclick="TnGotoProduct('2117551');return false;">
                                <img src="http://webimage.10x10.co.kr/fixevent/event/2018/90662/m/img_item_02.png" alt="고양이 반자동 화장실" />
                            </a>
                        </div>
                        <div>
                            <a href="/category/category_itemPrd.asp?itemid=1427197&pEtr=90662" onclick="TnGotoProduct('1427197');return false;">
                                <img src="http://webimage.10x10.co.kr/fixevent/event/2018/90662/m/img_item_03.png" alt="padding - pink" />
                            </a>
                        </div>
                        <div>
                            <a href="/category/category_itemPrd.asp?itemid=1173759&pEtr=90662" onclick="TnGotoProduct('1173759');return false;">
                                <img src="http://webimage.10x10.co.kr/fixevent/event/2018/90662/m/img_item_04.png" alt="와일드와시 센스티브 코트 샴푸" />
                            </a>
                        </div>
                        <div>
                            <a href="/category/category_itemPrd.asp?itemid=1690940&pEtr=90662" onclick="TnGotoProduct('1690940');return false;">
                                <img src="http://webimage.10x10.co.kr/fixevent/event/2018/90662/m/img_item_05.png" alt="울리 베스트 강아지옷/강아지패딩" />
                            </a>
                        </div>
                    </div>
                </div>

                <!-- GNB 보드에 걸릴 경우에만 최대한 스크립트로 링크 걸기! -->
                <div class="bnr bnr-mania-day">
                    <h3><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90662/m/tit_evt.png" alt="매니아를 위한 CAT&DOG 특가 이벤트"  /></h3>
                    <ul>
                        <li><a href="/event/eventmain.asp?eventid=90736" onclick="jsEventlinkURL(90736);return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90662/m/bnr_event_01.png" alt="이번 겨울도 부탁해! SNIFF" /></a></li>
                        <li><a href="/event/eventmain.asp?eventid=89726" onclick="jsEventlinkURL(89726);return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90662/m/bnr_event_02.png" alt="반려견의 마음을 이해하는 Bodeum" /></a></li>
                        <li><a href="/event/eventmain.asp?eventid=90351" onclick="jsEventlinkURL(90351);return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90662/m/bnr_event_03.png" alt="따뜻한 겨울을 준비하는 멋멍" /></a></li>
                        <li><a href="/event/eventmain.asp?eventid=90762" onclick="jsEventlinkURL(90762);return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90662/m/bnr_event_04.png" alt="영양맞춤 사료 로얄캐닌" /></a></li>
                    </ul>
                </div>
                <p><a href="" onclick="jsDownCoupon2('event','<%=couponIdx%>');return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90662/m/img_coupon.png" alt="COUPON EVENT"></a></p>
            </div>
            <!-- // [카테고리데이] 카테고리 데이 cat and dog : 90662 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->