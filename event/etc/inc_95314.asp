<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 100원 자판기
' History : 2019-06-17 최종원 생성
' 주의사항
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<%
	'// tbl_event_subscript에 마일리지 신청내역 저장 후 실제 보너스 마일리지로 지급
	'// 해당 이벤트는 진행기간중 무조건 1회까지만 참여가능(중복참여불가)	

	If isApp = "1" Then 
		Response.redirect "/apps/appCom/wish/web2014/event/eventmain.asp?eventid=95316"
		Response.End
	End If
%>
<style type="text/css">
.mEvt95314 {position:relative; background-color:#ffc2ca;}
.mEvt95314 .machine {position:relative;}
.machine .item-list {position:absolute; top:5%; left:12%; width:76%;}
.machine li {position:relative; float:left; width:50%;}
.machine li a, .machine li span {display:block; height:0; font-size:0;}
.machine .item01 a, .machine .item02 a {padding-top:98.95%;}
.machine .item03, .machine .item04, .machine .item05 {width:33.3%;}
.machine .item03 a, .machine .item04 a, .machine .item05 a {padding-top:155%;}
.machine .item06 a, .machine .item07 span {padding-top:91.58%;}
.machine .btn-down {position:absolute; right:0; bottom:12%; width:75%; height:17%; font-size:0; background:none;}
.machine li:before {content:' '; position:absolute; left:50%; bottom:4.5%; width:2rem; height:0.52rem; margin-left:-1rem; border-radius:0.26rem; background-color:#fff; box-shadow:0 0 0.3rem rgb(245, 247, 175);}
.machine li.on:before {background-color:#5dff7b;}
.mEvt95314 .noti {background:#6543fa;}
.mEvt95314 .noti h3 {text-align:center;}
.mEvt95314 .noti ul {padding:2rem 6.7% 3.6rem;}
.mEvt95314 .noti li {position:relative; padding-left:1rem; font-size:1.11rem; line-height:1.38; color:#fff; word-break:keep-all;}
.mEvt95314 .noti li + li {margin-top:1.19rem;}
.mEvt95314 .noti ul li:before {position:absolute; top:0; left:0; content:'-'; display:inline-block;}
</style>
<script type="text/javascript">
$(function(){
	function pickNow(){
		var numbers = [];
		var pickNumbers = 3;
		for(insertCur = 0; insertCur < pickNumbers ; insertCur++){
			numbers[insertCur] = Math.floor(Math.random() * 6) + 1;
			for(searchCur = 0; searchCur < insertCur; searchCur ++){
				if(numbers[insertCur] == numbers[searchCur]){
					insertCur--;
					break;
				}
			}
		}
		var result = "";
		for(i = 0; i < pickNumbers; i ++){
			if(i > 0){
				result += ",";
			}
			result += numbers[i];
		}
		$('.item-list li').removeClass('on');
		$('.item-list li').eq(result[0]).addClass('on');
		$('.item-list li').eq(result[2]).addClass('on');
		$('.item-list li').eq(result[4]).addClass('on');
	}
	var pushBtn=setInterval(pickNow,1000);
});
</script>
	<!-- 100원 자판기 (M) 95314 -->
			<div class="mEvt95314">
				<h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/95314/m/tit_100won.jpg" alt="100원 자판기"></h2>
				<div class="machine">
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/95314/m/img_machine.jpg" alt=""></p>
					<ul class="item-list">
						<li class="item01"><a href="/category/category_itemprd.asp?itemid=2230980&pEtr=95314">맥북</a></li>
						<li class="item02"><a href="/category/category_itemprd.asp?itemid=2211392&pEtr=95314">아이패드</a></li>
						<li class="item03"><a href="/category/category_itemprd.asp?itemid=2389237&pEtr=95314">에어팟</a></li>
						<li class="item04"><a href="/category/category_itemprd.asp?itemid=2336252&pEtr=95314">아이폰</a></li>
						<li class="item05 "><a href="/category/category_itemprd.asp?itemid=2024516&pEtr=95314">프라엘마스크</a></li>
						<li class="item06"><a href="/category/category_itemprd.asp?itemid=2368857&pEtr=95314">네스프레소</a></li>
						<li class="item07"><span>마샬스피커</span></li>
					</ul>
					<!-- 앱 다운로드 버튼 -->
					<a href="http://m.10x10.co.kr/apps/link/?13720190612" class="btn-down" target="_blank">앱 다운받고 응모하기</a>					
				</div>

				<!-- 유의사항 -->
				<div class="noti">
					<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/95314/m/tit_noti.png" alt="이벤트 유의사항"></h3>
					<ul>
						<li>본 이벤트는 텐바이텐 APP에서 로그인 후 참여 가능합니다.</li>
						<li>ID당 1일 1회만 응모 가능하며, 친구에게 공유 시 한 번 더 응모 기회가 주어집니다. (하루 최대 2번 응모 가능)</li>
						<li>모든 상품의 당첨자가 결정되면 이벤트는 조기 마감될 수 있습니다.</li>
						<li>5만원 이상의 상품을 받으신 분께는 세무신고를 위해 개인정보를 요청할 수 있습니다.</li>
						<li>제세공과금은 텐바이텐 부담입니다.</li>
						<li>당첨자에게는 상품 수령 후, 인증 사진을 요청드릴 예정입니다.</li>
					</ul>
				</div>
			</div>
			<!--// 100원 자판기 (M) 95314 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->