<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid , strSql, vArr
Dim lastusercnt '앱마지막 로그인 카운트
Dim logusercnt '로그인내역 카운트
Dim evt_pass : evt_pass = False '이벤트 응모 여부 chkflag

	IF application("Svr_Info") = "Dev" THEN
		eCode = "66173"
	Else
		eCode = "72088"
	End If

userid = getEncLoginUserID

strSql = "select top 5 userid, regdate, sub_opt2 from [db_event].[dbo].[tbl_event_subscript] where evt_code = '" & eCode & "' order by sub_idx desc"
rsget.CursorLocation = adUseClient
rsget.Open strSql,dbget,adOpenForwardOnly,adLockReadOnly
if not rsget.eof then
	vArr = rsget.getRows()
end if
rsget.close


'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
dim snpTitle, snpLink, snpImg
snpTitle = Server.URLEncode("[텐바이텐] 오벤져스")
snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=72088")
snpImg = Server.URLEncode("http://webimage.10x10.co.kr/eventIMG/2016/70686/etcitemban20160512185825.jpeg")

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐] 봉.투.맨2\n\n당신의 휴가를 도와 줄\n올 여름 보너스를 결정한다!\n\n최대 10만원의 보너스 쿠폰이\n당신을 기다립니다.\n\n지금 도전하세요!\n오직 텐바이텐에서!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/72088/m/img_kakao.jpg"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url
If isapp then
	kakaolink_url = "http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid="&eCode
else
	kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
end if
%>
<style type="text/css">
img {vertical-align:top;}

.evtDetailV15 .anotherV15 {margin-top:20px;}
@media (min-width: 480px){
	.evtDetailV15 .anotherV15 {margin-top:40px;}
}

.envelopeMan {position:relative;}
.envelopeMan button {background-color:transparent;}

.selectEnvelope {overflow:hidden; position:relative;}
.selectEnvelope .openDrawer {position:absolute; left:0; top:0; width:100%;}
.selectEnvelope .openDrawer .touch {position:absolute; top:37.83%; left:50%; z-index:5; width:22.5%; margin-left:-11.25%;}
.selectEnvelope .openDrawer .touch {
	animation-name:flash; animation-duration:2s; animation-fill-mode:both; animation-iteration-count:3; animation-delay:3s;
	-webkit-animation-name:flash; -webkit-animation-duration:2s; -webkit-animation-fill-mode:both; -webkit-animation-iteration-count:3; -webkit-animation-delay:3s;
}
@keyframes flash {
	0%, 50%, 100% {opacity:1;}
	25%, 75% {opacity:0;}
}
@-webkit-keyframes flash {
	0%, 50%, 100% {opacity:1;}
	25%, 75% {opacity:0;}
}
.selectEnvelope .openDrawer .btnEnvelope {position:absolute;}
.selectEnvelope .openDrawer .btnEnvelope1 {top:13.67%; left:20%; width:32.18%;}
.selectEnvelope .openDrawer .btnEnvelope2 {top:24.16%; left:52.18%; width:26.56%;}
.selectEnvelope .openDrawer .coin {position:absolute; top:44.51%; right:21.875%; width:5.6%;}

.winnerList {position:relative; background:url(http://webimage.10x10.co.kr/eventIMG/2016/72088/m/bg_pattern.png) repeat-y 0 0; background-size:100% auto;}
.winnerList .hgroup {position:relative;}
.winnerList .btnMore {position:absolute; top:-1%; right:0; width:15.625%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/72088/m/btn_more.png) no-repeat 0 0; background-size:100% auto; color:transparent;}
.winnerList .btnMore.fold {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/72088/m/btn_more_close.png);}
.winnerList li {min-height:5rem; padding:1.5rem 8.75% 1.3rem; color:#000; font-size:1.2rem; line-height:1.5em;}
.winnerList li:nth-child(even) {background-color:rgba(233,245,248, 0.5);}
.winnerList li:nth-child(odd) {background-color:rgba(244,241,244, 0.5);}
.winnerList li:first-child {background-color:transparent;}
.winnerList li b {border-bottom:1px solid #008ff3; color:#008ff3;}
.winnerList li span {display:block; margin-top:0.4rem; font-size:1rem;}

/* layer popup */
.lyWin {display:none; position:absolute; top:0; left:50%; z-index:30; width:90.62%; margin-left:-45.31%;}
.lyWin .btnClose {display:block; position:absolute; z-index:30; top:7%; right:0; width:12%; height:8%; color:transparent;}
.lyWin .btnConfirm {display:block; position:absolute; bottom:7%; left:50%; z-index:30; width:80%; height:9%; margin-left:-40%; color:transparent;}
#dimmed {display:none; position:absolute; top:0; left:0; z-index:20; width:100%; height:100%; background:rgba(0,0,0, 0.75);}

.noti {padding:6% 0; background-color:#f7f7f7;}
.noti h3 {padding:0 7.34%; color:#122b6e; font-size:1.4rem; font-weight:bold;}
.noti h3 span {padding-bottom:1px; border-bottom:2px solid #122b6e;}
.noti ul {margin:1.5rem 0 0 4.68%;}
.noti ul li {position:relative; margin-top:0.3rem; padding-left:1rem; color:#444; font-size:1rem; line-height:1.688em;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.7rem; left:0; width:0.4rem; height:0.1rem; background-color:#444;}
</style>
<script type="text/javascript" src="http://www.10x10.co.kr/lib/js/jquery-ui-1.10.3.custom.min.js"></script>
<script type="text/javascript">
$(function(){
	<% If isapp then %>
	// 캡션 변경
	fnAPPchangPopCaption('이벤트');
	<% end if %>
	
	/* open drawer animation */
	openDrawer();
	$(".selectEnvelope .openDrawer").css({"margin-top":"-77.5%"});
	function openDrawer() {
		$(".selectEnvelope").find(".openDrawer").delay(700).animate({"margin-top":"0"},1200);
		$(".selectEnvelope .btnEnvelope1 img").delay(2000).effect("shake", {direction:"up", times:2, distance:10}, 900);
		$(".selectEnvelope .btnEnvelope2 img").delay(1200).effect("shake", {direction:"up", times:2, distance:10}, 900);
	}

	$.fn.layerOpen = function(options) {
		return this.each(function() {
			var $this = $(this);
			var $layer = $($this.attr("href") || null);
			$this.click(function() {
				$layer.attr("tabindex",0).show().focus();
				$("#dimmed").show();
				window.$('html,body').animate({scrollTop:100}, 500);
				$layer.find(".btnConfirm, .btnClose").one("click",function () {
					$layer.hide();
					$this.focus();
					$("#dimmed").hide();
				});
			});
		});
	}
	$(".layer").layerOpen();

	/* 실시간 당첨자 */
	$(".winnerList ul li").hide();
	$(".winnerList ul li:first").show();
	if ($(".winnerList ul li").length > 1) {
		$(".winnerList .btnMore").click(function(){
			if ($(this).hasClass("fold")){
				$(this).removeClass("fold");
				$(this).text("더보기");
				$(".winnerList li:gt(0)").hide();
			} else {
				$(this).addClass("fold");
				$(this).text("보너스 당첨소식 닫기");
				$(".winnerList li:gt(0)").show();
			}
		});
	} else {
		$(".winnerList .btnMore").hide();
	}
});

function fnClosemask() {
	$("#viewResult").hide();
	document.location.reload();
}

function fnCloseLayer(){
	$("#lyWin").hide();
	$("#dimmed").hide();
}

function fnCheckHero(){
<% If IsUserLoginOK() Then %>
	$.ajax({
		type: "GET",
		url: "/event/etc/doeventsubscript/doEventSubscript72088.asp",
		data: "mode=G",
		cache: false,
		success: function(str) {
			str = str.replace("undefined","");
			res = str.split("|");
			if (res[0]=="OK") {
				$("#dimmed").show();
				$("#btn11, #btn22").addClass("layer");
				$("#lyWin").empty().html(res[1]);
				$("#lyWin").fadeIn();
				window.parent.$('html,body').animate({scrollTop:$("#lyWin").offset().top-0}, 300);
			} else {
				$("#btn11, #btn22").removeClass("layer");
				errorMsg = res[1].replace(">?n", "\n");
				alert(errorMsg );

				<% If isapp="1" Then %>
					//document.location.replace("/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= eCode %>");
				<% else %>
					//document.location.replace("/event/eventmain.asp?eventid=<%= eCode %>");
				<% end if %>
				return false;
			}
		}
		,error: function(err) {
			console.log(err.responseText);
			alert("통신중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
		}
	});
<% else %>
	<% If isapp then %>
		calllogin();
		return false;
	<% else %>
		parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
		return false;
	<% end if %>
<% end if %>
}

// SNS 공유 팝업 (본 이벤트는 비하인드라 APP에서의 연결은 사용안함)
function fnAPPRCVpopSNS(){
    return false;
}
</script>
<div class="mEvt72088 envelopeMan">
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72088/m/txt_envelope_man.jpg" alt="당신의 휴가를 도와줄 보너스를 결정한다 서랍 속 봉투를 확인해 보세요! 최대10만원의 보너스쿠폰이 찾아갑니다!" /></p>
	<div class="selectEnvelope">
		<div class="openDrawer">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72088/m/txt_select.png" alt="아래 봉투 중 하나만 골라주세요!" /></p>
			<p class="touch"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72088/m/txt_touch.png" alt="Touch" /></p>
			<a href="" id="btn11" onClick="fnCheckHero();return false;" class="btnEnvelope btnEnvelope1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72088/m/img_envelope_01.png" alt="첫번째 봉투" /></a>
			<a href="" id="btn22" onClick="fnCheckHero();return false;" class="btnEnvelope btnEnvelope2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72088/m/img_envelope_02.png" alt="두번째 봉투" /></a>
			<span class="coin"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72088/m/img_coin.png" alt="" /></span>
		</div>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/72088//m/bg_bottom.jpg" alt="" /></div>
	</div>
	<div id="lyWin" class="lyWin">
	</div>
	<div class="winnerList">
		<div class="hgroup">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/72088/m/tit_winner.png" alt="보너스 당첨소식" /></h3>
			<button type="button" class="btnMore">더보기</button>
		</div>
		<ul>
		<%
			Dim i
			If isArray(vArr) THEN
				For i =0 To UBound(vArr,2)
					Response.Write "<li><b>" & CHKIIF(Len(vArr(0,i))<3,vArr(0,i),Left(vArr(0,i),3)) & "**</b>님이 " & fnCouponname11(vArr(2,i)) & "의 보너스쿠폰을 받았습니다. <span class=""date"">" & vArr(1,i) & "</span></li>"
				Next
			Else
				Response.Write "<li>아직 보너스 당첨자가 없습니다.</li>"
			End If
		%>
		</ul>
	</div>
	<div class="kakao">
		<a href="" onclick="parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72088/m/btn_kakao.png" alt="친구에게 봉투맨 카카오톡으로 알려주기! 친구에게 이 놀라운 소식을 알려주고 봉투맨에 함께 도전해 보세요!" /></a>
	</div>

	<div class="bnr">
		<a href="eventmain.asp?eventid=72109"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72088/m/img_bnr.jpg" alt="여름에 없으면 서운해~ 즐거운 여름을 위해 꼭 필요한 아이템들 기획전 보러가기" /></a>
	</div>

	<div class="noti">
		<h3><span>이벤트 유의사항</span></h3>
		<ul>
			<li>이벤트는 ID당 1일 1회만 참여할 수 있습니다.</li>
			<li>지급된 쿠폰은 텐바이텐에서만 사용 가능 합니다.</li>
			<li>쿠폰은 지급 당일 23시 59분 59초에 종료됩니다.</li>
			<li>주문한 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
			<li>이벤트는 조기 마감될 수 있습니다.</li>
		</ul>
	</div>
	<div id="dimmed"></div>
</div>

<%
If userid = "okkang777" or userid = "greenteenz" or userid = "helele223" Then
	dim vQuery, vAry, j
	vQuery = "select s.sub_opt1, s.sub_opt2, count(s.sub_idx), (select count(idx) from [db_user].[dbo].tbl_user_coupon where masteridx = s.sub_opt2 and isusing = 'Y' and startdate = s.sub_opt1) as cnt"
	vQuery = vQuery & " from [db_event].[dbo].[tbl_event_subscript] as s where s.evt_code = '"&eCode&"' group by s.sub_opt1, s.sub_opt2 order by s.sub_opt1 asc, s.sub_opt2 asc"
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
	if not rsget.eof then
		vAry = rsget.getRows()
	end if
	rsget.close
	
	If isArray(vAry) THEN
		For j =0 To UBound(vAry,2)
			Response.Write vAry(0,j) & " " & fnCouponname11(vAry(1,j)) & "(" & vAry(1,j) & ") " & vAry(2,j) & "개 발급 " & vAry(3,j) & "개 사용<br />"
		Next
	End If
End If
function fnCouponname11(c)
select case c
	case "885" : fnCouponname11 = "10만원"
	case "886" : fnCouponname11 = "3만원"
	case "887" : fnCouponname11 = "1만원"
	case "888" : fnCouponname11 = "5천원"
end select
end function
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->