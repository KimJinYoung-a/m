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
' Description : [valentine’s day] HOW TO SAY LOVE
' History : 2018-01-29 정태훈
'####################################################
Dim eCode, userid, gmid

IF application("Svr_Info") = "Dev" THEN
	eCode   =  67503
Else
	eCode   =  83586
End If
gmid=request("mid")
If gmid="" Then gmid="1"
userid = GetEncLoginUserID()

Dim vQuery, UserAppearChk
vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' And userid='"&userid&"'"
rsget.CursorLocation = adUseClient
rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
IF Not rsget.Eof Then
	UserAppearChk = rsget(0)
End IF
rsget.close

%>
<style>
.mEvt83586 .items {position:relative;}
.mEvt83586 .items ul {overflow:hidden; position:absolute; top:0; left:0; width:100%; height:100%;}
.mEvt83586 .items ul li{float:left; width:50%; height:33.333%;}
.mEvt83586 .items ul li a{display:inline-block; width:100%; height:100%; text-indent:-999rem;}
.gift-evt {position:relative;}
.gift-evt > span,
.gift-evt button,
.gift-evt p{position:absolute; bottom:15.2rem; left:0; margin:0 16.13%; z-index:20; background-color:transparent;}
.gift-evt button {animation:bounce .8s .9s 100;}
.gift-evt button,
.gift-evt p{bottom:10.67rem; margin:0 11.73%; z-index:10;}
.for-someone {position:relative; z-index:20;}
.for-someone a {display:inline-block; position:absolute; top:0; width:50%; height:100%;}
.for-someone .him {left:0;}
.for-someone .her {right:0;}
.for-someone a span {position:absolute; bottom:3.2rem; right:2.6rem; display:inline-block; height:1.71rem; padding:0 .6rem; background-color:#007984; color:#fff; line-height:1.9rem; font-size:.94rem; border-radius:.85rem; font-weight:600;}
.for-someone .her span {right:2.2rem; background-color:#f44663;}
.sweet-gift ul {overflow:hidden; padding:0 .54rem 3.84rem; background-color:#5d331c;}
.sweet-gift ul li {position:relative; float:left; width:25%; padding:0 .54rem;}
.sweet-gift ul li span {display:inline-block; position:absolute; top:0; left:.54rem; width:calc(100% - 1.08rem); height:100%;}
.sweet-gift ul li span img{opacity:0;}
.sweet-gift ul li a > img {padding:0 .21rem;}
.sweet-gift ul li.on a > img {opacity:0;}
.sweet-gift ul li.on span img{opacity:1;}
.sweet-gift1 ul li.on span:after {content:' '; display:inline-block; width:100%; height:.73rem; position:absolute; bottom:-1.88rem; left:0; background:url(http://webimage.10x10.co.kr/eventIMG/2018/83586/m/img_on.png); background-size:100%;}
.sweet-gift2 {padding-top:.8rem; background-color:#fff;}
.sweet-gift2 ul{padding-bottom:2.65rem;}
@keyframes bounce {
	from, to {transform:translateX(0); animation-timing-function:ease-out;}
	50% {transform:translateX(-8px); animation-timing-function:ease-in;}
}
</style>
<script type="text/javascript">
<!--
$(function(){
	<% if request("mid") <>"" then %>
	var position = $('.sweet-gift').offset(); // 위치값
	$('html,body').animate({ scrollTop : position.top },0); // 이동
	<% end if %>
});
	function fnGoEnter(){
<% If IsUserLoginOK Then %>
	<% If now() > #01/29/2018 00:00:00# and now() < #02/14/2018 23:59:59# then %>
		var str = $.ajax({
			type: "POST",
			url: "/event/etc/doEventSubscript83586.asp",
			data: "mode=add&eCode=<%=eCode%>",
			dataType: "text",
			async: false
		}).responseText;
		var str1 = str.split("|")
		if (str1[0] == "11"){
			alert('응모가 완료되었습니다.');
			$("#btn1").css("display","none");
			$("#btn2").css("display","");
			return false;
		}else if (str1[0] == "12"){
			alert('이벤트 기간이 아닙니다.');
			return false;
		}else if (str1[0] == "13"){
			alert('이미 응모하셨습니다.');
			return false;
		}else if (str1[0] == "02"){
			alert('로그인 후 참여 가능합니다.');
			return false;
		}else if (str1[0] == "03"){
			alert('이벤트 대상 카테고리 구매 내역이 없습니다.');
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
	<% Else %>
		alert("이벤트 기간이 아닙니다.");
		return;
	<% End If %>

<% Else %>
	<% if isApp=1 then %>
		parent.calllogin();
		return false;
	<% else %>
		parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
		return false;
	<% end if %>
<% End If %>
	}
//-->
</script>
		<div class="evtContV15">
			<div class="mEvt83586">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/tit_love.gif" alt="how to love" /></h2>
				<div class="items">
					<img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/img_items.jpg" alt="" />
					<ul>
						<li><a href="/category/category_itemPrd.asp?itemid=1877156&pEtr=84101" onclick="TnGotoProduct('1877156');return false;">딸기 앤 파베 DIY SET</a></li>
						<li><a href="/category/category_itemPrd.asp?itemid=1878643&pEtr=84101" onclick="TnGotoProduct('1878643');return false;">커스텀 화과자 세트</a></li>
						<li><a href="/category/category_itemPrd.asp?itemid=1878644&pEtr=84101" onclick="TnGotoProduct('1878644');return false;">사랑가득 하트 화과자</a></li>
						<li><a href="/category/category_itemPrd.asp?itemid=1881035&pEtr=84101" onclick="TnGotoProduct('1881035');return false;">어반약과 핑크 에디션</a></li>
						<li><a href="/category/category_itemPrd.asp?itemid=1876029&pEtr=84101" onclick="TnGotoProduct('1876029');return false;">스윗파크 DIY SET</a></li>
						<li><a href="/category/category_itemPrd.asp?itemid=1827940&pEtr=84101" onclick="TnGotoProduct('1827940');return false;">주문 제작 마카롱</a></li>
					</ul>
				</div>
				<div class="gift-evt">
					<img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/txt_evt.jpg" alt="참여 이벤트 스낵/견과 & 베이커리/베이킹 카테고리 상품을 구매하신 분 중 2분께 닌텐도 스위치를 드립니다! 응모기간 01.17 (수) ~ 02.14 (수) 당첨발표  02.22 (목) 고객에 한해, ID당 한번만 응모가능  ※ 제세공과금은 텐바이텐 부담이며 세무신고를 위해 개인정보를 취합 후 경품 증정 " />
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/img_gift.png" alt="" /></span>
					<div id="btn1" style="display:<% If UserAppearChk>"0" Then %>none<% Else %><% End if %>"><button onclick="fnGoEnter();"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/btn_submit.png" alt="응모하기" /></button></div>
					<p id="btn2" style="display:<% If UserAppearChk>"0" Then %><% Else %>none<% End if %>"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/btn_submit_done.png" alt="응모완료" /></p>
				</div>
				<div class="for-someone">
					<img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/img_for_someone_v3.jpg" alt="함께하면 좋은 선물 감동을 더해줄 선물" />
					<a href="#" onclick="jsEventlinkURL(83598);return false;" class="him"><span>~68%</span></a>
					<a href="#" onclick="jsEventlinkURL(83599);return false;" class="her"><span>~63%</span></a>
				</div>
				<div class="sweet-gift sweet-gift1">
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/tit_bottom_nav_v2.gif" alt="sweet gift" /></h3>
					<ul>
						<% if isApp=1 then %>
						<li class="<% If gmid="1" Then Response.write "on"%>"><a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=84249&eGc=235400&mid=1"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/img_nav_1.png" alt="DIY" /><span><img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/img_nav_1_on.png" alt="선택" /></span></a></li>
						<li class="<% If gmid="2" Then Response.write "on"%>"><a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=84249&eGc=235401&mid=2"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/img_nav_2.png" alt="초콜렛" /><span><img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/img_nav_2_on.png" alt="선택" /></span></a></li>
						<li class="<% If gmid="3" Then Response.write "on"%>"><a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=84249&eGc=235402&mid=3"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/img_nav_3.png" alt="스낵류" /><span><img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/img_nav_3_on.png" alt="선택" /></span></a></li>
						<li class="<% If gmid="4" Then Response.write "on"%>"><a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=84249&eGc=235403&mid=4"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/img_nav_4.png" alt="클래스" /><span><img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/img_nav_4_on.png" alt="선택" /></span></a></li>
						<% Else %>
						<li class="<% If gmid="1" Then Response.write "on"%>"><a href="/event/eventmain.asp?eventid=84249&eGc=235400&mid=1"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/img_nav_1.png" alt="DIY" /><span><img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/img_nav_1_on.png" alt="선택" /></span></a></li>
						<li class="<% If gmid="2" Then Response.write "on"%>"><a href="/event/eventmain.asp?eventid=84249&eGc=235401&mid=2"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/img_nav_2.png" alt="초콜렛" /><span><img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/img_nav_2_on.png" alt="선택" /></span></a></li>
						<li class="<% If gmid="3" Then Response.write "on"%>"><a href="/event/eventmain.asp?eventid=84249&eGc=235402&mid=3"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/img_nav_3.png" alt="스낵류" /><span><img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/img_nav_3_on.png" alt="선택" /></span></a></li>
						<li class="<% If gmid="4" Then Response.write "on"%>"><a href="/event/eventmain.asp?eventid=84249&eGc=235403&mid=4"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/img_nav_4.png" alt="클래스" /><span><img src="http://webimage.10x10.co.kr/eventIMG/2018/83586/m/img_nav_4_on.png" alt="선택" /></span></a></li>
						<% End If %>
					</ul>
				</div>
			</div>
		</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->