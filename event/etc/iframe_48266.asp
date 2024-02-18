<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  웬만하면 참석해라, 송년회
' History : 2013.12.21 한용민 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/enjoy/event48266Cls.asp" -->
<%
dim eCode
	eCode   =  getevt_code

dim subscriptexistscount, subscriptexistscount1, subscriptexistscount2, mileageexistscount
dim badgeexistscount10, badgeexistscount11, badgeexistscount12, badgecount
	subscriptexistscount=0
	subscriptexistscount1=0
	subscriptexistscount2=0
	mileageexistscount=0
	badgeexistscount10=0
	badgeexistscount11=0
	badgeexistscount12=0
	badgecount=0
	
if IsUserLoginOK then
	'/응모여부
	subscriptexistscount = getevent_subscriptexistscount(eCode, GetLoginUserID(), "", "", "")
	
	'/마일리지 발급여부
	mileageexistscount = getmileageexistscount(GetLoginUserID(), "1000", "스폐셜 뱃지 있는 사람 손들어 1000 마일리지 적립", "+1000", "")
	
	if subscriptexistscount>0 or mileageexistscount>0 then
		'//10월뱃지획득
		badgeexistscount10=getbadgeexistscount(GetLoginUserID(), "13", "", "", "")
		'//11월뱃지획득
		badgeexistscount11=getbadgeexistscount(GetLoginUserID(), "14", "", "", "")
		'//12월뱃지획득
		badgeexistscount12=getbadgeexistscount(GetLoginUserID(), "15", "", "", "")

		'//10월 응모 일경우
		if badgeexistscount10>0 then
			badgecount=badgecount+1
		end if
		'//11월 응모 일경우
		if badgeexistscount11>0 then
			badgecount=badgecount+1
		end if
		'//12월 응모 일경우
		if badgeexistscount12>0 then
			badgecount=badgecount+1
		end if		
	end if
end if
%>

<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 스폐셜 뱃지 있는 사람 손들어</title>
<style type="text/css">
.mEvt48267 {}
.specialBadgeHead {padding-bottom:7.61750%; background:#83dbd7 url(http://webimage.10x10.co.kr/eventIMG/2013/48267/bg_content_top.gif) left top no-repeat; background-size:100% 100%; text-align:center;}
.specialBadgeHead h2 {padding:4.53808% 0 7.29335%;}
.specialBadgeCheck {padding:0 7px; background:#83dbd7 url(http://webimage.10x10.co.kr/eventIMG/2013/48267/bg_content_middle.gif) left top no-repeat; background-size:100% 100%;}
.specialBadgeCheck .myspecialBadge {border-radius:3px; background-color:#fff; background:url(http://webimage.10x10.co.kr/eventIMG/2013/48267/bg_pattern.gif) left top repeat; text-align:center;}
.specialBadgeCheck .myspecialBadge .myCollection {position:relative; margin:0 1.90274% 4.76190%; padding:4.76190% 0 15%; border-bottom:1px solid #e6e6e6;}
.specialBadgeCheck .myspecialBadge .myCollection ul {overflow:hidden; padding:0 0 2.37099% 0; /*background:url(http://webimage.10x10.co.kr/eventIMG/2013/48267/bg_operator.png) left top no-repeat; background-size:100% 100%;*/}
.specialBadgeCheck .myspecialBadge .myCollection ul li {float:left; width:33.33333%; /*padding:0 4%;*/}
.specialBadgeCheck .myspecialBadge .myCollection ul li img {width:100%;}
.specialBadgeCheck .myspecialBadge .myCollection p {margin:0 -1.90274%; padding:0 0 5%;}
.specialBadgeCheck .myspecialBadge .myCollection p img {width:100%;}
.myspecialBadge .myCollection button {position:absolute; left:50%; bottom:10%; width:232px; height:42px; margin:0 0 0 -116px; padding:0; border:0; background-color:transparent; background-position:left top; background-repeat:no-repeat; background-size:100% 100%; text-indent:-999em; cursor:pointer;}
@media all and (max-width:480px){
	.myspecialBadge .myCollection button {width:154px; height:28px; margin:0 0 0 -77px;}
}
.myspecialBadge .myCollection .btnBadge01 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/48267/btn_special_badge_01.gif);}
.myspecialBadge .myCollection .btnBadge02 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/48267/btn_special_badge_02.gif);}
.myspecialBadge .myCollection .btnBadge03 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/48267/btn_special_badge_03.gif);}
.myspecialBadge .giftGuide {padding:0 2.85412%; text-align:left;}
.myspecialBadge .giftGuide dl {padding:0 0 3.55648% 5.81395%;}
.myspecialBadge .giftGuide dl dt {padding:2.85913% 0 1.04602%;}
</style>
<script type="text/javascript">

function jsDayCheck(){
	<% If IsUserLoginOK() Then %>
		<% If Now() > #01/15/2014 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% if subscriptexistscount>0 or mileageexistscount>0 then %>
				alert("이미 응모 하셨습니다.");
				return;
			<% else %>
				//alert("현재 서비스 정검중입니다. 잠시만 기다려주세요.");
				//return;
				evtFrm1.mode.value="badgecheck3";
				evtFrm1.submit();
			<% end if %>
		<% End If %>
	<% Else %>
		alert('로그인을 하셔야 참여가 가능 합니다');
		return;
		//if(confirm("로그인을 하셔야 참여가 가능 합니다. 로그인 하시겠습니까?")){
		//	var winLogin = window.open('/login/PopLoginPage.asp','popLogin','width=400,height=300');
		//	winLogin.focus();
		//	return;
		//}
	<% End IF %>
}

</script>

</head>
<body>

<div class="mEvt48267">
	<div class="specialBadgeHead">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/48267/txt_special_badge_end.png" alt="텐바이텐 스폐셜 뱃지 3종 완결 이벤트" style="width:55.52083%" /></p>
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2013/48267/tit_special_badge.png" alt="스폐셜 뱃지 있는 사람, 손들어!" style="width:82.125%" /></h2>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/48267/txt_special_badge.png" alt="2013년 스폐셜 뱃지 다 모은 사람 손들어 주세요! 지금 갖고 있는 스폐셜 뱃지를 확인하고, 마일리지와 &lt;시크릿박스&gt; 선물 받으세요! 이벤트 기간 : 2014.01.08 ~ 01.15 ★당첨자 발표 : 01.16" style="width:77.0833%" /></p>
	</div>

	<div class="specialBadgeCheck">
		<div class="myspecialBadge">
			<div class="myCollection">
				<% ' for dev msg : 취득하지 않은 뱃지명과 취득한 뱃지명입니다. _off.png / _on.png %>
				<ul>
					<%
					'/응모완료
					if subscriptexistscount>0 or mileageexistscount>0 then
					%>
						<li id="badgeimg10"><img src="http://webimage.10x10.co.kr/eventIMG/2013/48267/img_special_badge_01<% if badgeexistscount10>0 then %>_on<% else %>_off<% end if %>.png" alt="10월 스페셜 뱃지" /></li> 
						<li id="badgeimg11"><img src="http://webimage.10x10.co.kr/eventIMG/2013/48267/img_special_badge_02<% if badgeexistscount11>0 then %>_on<% else %>_off<% end if %>.png" alt="11월 스페셜 뱃지" /></li>
						<li id="badgeimg12"><img src="http://webimage.10x10.co.kr/eventIMG/2013/48267/img_special_badge_03<% if badgeexistscount12>0 then %>_on<% else %>_off<% end if %>.png" alt="12월 스페셜 뱃지" /></li>						
					<% else %>
						<li id="badgeimg10"><img src="http://webimage.10x10.co.kr/eventIMG/2013/48267/img_special_badge_01.png" alt="10월 스페셜 뱃지" /></li> 
						<li id="badgeimg11"><img src="http://webimage.10x10.co.kr/eventIMG/2013/48267/img_special_badge_02.png" alt="11월 스페셜 뱃지" /></li>
						<li id="badgeimg12"><img src="http://webimage.10x10.co.kr/eventIMG/2013/48267/img_special_badge_03.png" alt="12월 스페셜 뱃지" /></li>
					<% end if %>				

				</ul>
				<% ' for dev msg : 스페셜 뱃지 취득 갯수에 따른 버튼입니다. %>
				<% if subscriptexistscount>0 or mileageexistscount>0 then %>
					<div id="badgestats01" style="display:none;"><button type="button" onClick="jsDayCheck();" class="btnBadge01">나의 스페셜 뱃지 확인하기</button></div>
					<div id="badgestats02" style="display:none;"><button type="button" onClick="jsDayCheck();" class="btnBadge02">시크릿 박스 응모하기</button></div>

					<% if badgecount=0 then	%>
						<div id="badgestats03" style="display:;"><button type="button" onClick="alert('획득하신 스폐셜 뱃지가 하나도 없으시네요~ 2014년에는 꼭 도전하세요.'); return;" class="btnBadge03">확인</button></div>
					<% elseif badgecount=1 then	%>
						<div id="badgestats03" style="display:;"><button type="button" onClick="alert('아쉽게도 스폐셜 뱃지 1개만 모으셨네요~ 2014년에 다시 돌아올 스폐셜 뱃지에 도전하세요!'); return;" class="btnBadge03">확인</button></div>
					<% elseif badgecount=2 then	%>
						<div id="badgestats03" style="display:;"><button type="button" onClick="alert('아쉽게도 스폐셜 뱃지 2개만 모으셨네요~ 2014년에 다시 돌아올 스폐셜 뱃지에 도전하세요!'); return;" class="btnBadge03">확인</button></div>
					<% elseif badgecount=3 then	%>
						<div id="badgestats03" style="display:;"><button type="button" onClick="alert('축하합니다! 스폐셜 뱃지 3개를 모두 모으셨네요! 1000마일리지 적립 완료!'); return;" class="btnBadge03">확인</button></div>
					<% end if %>
				<% else %>
					<div id="badgestats01" style="display:;"><button type="button" onClick="jsDayCheck();" class="btnBadge01">나의 스페셜 뱃지 확인하기</button></div>
					<div id="badgestats02" style="display:none;"><button type="button" onClick="jsDayCheck();" class="btnBadge02">시크릿 박스 응모하기</button></div>
					<div id="badgestats03" style="display:none;"><button type="button" onClick="alert('이미 응모하셨습니다.'); return;" class="btnBadge03">확인</button></div>							
				<% end if %>				
				
				<% ' for dev msg : 스페셜 뱃지 취득 갯수에 따른 메시지 입니다. %>
				<%
				'/응모완료
				if subscriptexistscount>0 or mileageexistscount>0 then
				%>
					<p id="badgecomment00" style="display:<% if badgecount=0 then %><% else %>none<% end if %>;">
						<img src="http://webimage.10x10.co.kr/eventIMG/2013/48267/txt_message_04.png" alt="획득하신 스폐셜 뱃지가 하나도 없으시네요~ 2014년에는 꼭 도전하세요!" />
					</p>				
					<p id="badgecomment01" style="display:<% if badgecount=1 then %><% else %>none<% end if %>;">
						<img src="http://webimage.10x10.co.kr/eventIMG/2013/48267/txt_message_03.png" alt="아쉽게도 스폐셜 뱃지 1개만 모으셨네요~ 2014년에 다시 돌아올 스폐셜 뱃지에 도전하세요!" />
					</p>
					<p id="badgecomment02" style="display:<% if badgecount=2 then %><% else %>none<% end if %>;">
						<img src="http://webimage.10x10.co.kr/eventIMG/2013/48267/txt_message_02.png" alt="아쉽게도 스폐셜 뱃지 2개만 모으셨네요~ 2014년에 다시 돌아올 스폐셜 뱃지에 도전하세요!" />
					</p>
					<p id="badgecommentall" style="display:<% if badgecount=3 then %><% else %>none<% end if %>;">
						<img src="http://webimage.10x10.co.kr/eventIMG/2013/48267/txt_message_05.png" alt="축하합니다! 스폐셜 뱃지 3개를 모두 모으셨네요! 1000마일리지 적립 완료!" />
					</p>
				<% else %>
					<p id="badgecomment00" style="display:none;">
						<img src="http://webimage.10x10.co.kr/eventIMG/2013/48267/txt_message_04.png" alt="획득하신 스폐셜 뱃지가 하나도 없으시네요~ 2014년에는 꼭 도전하세요!" />
					</p>				
					<p id="badgecomment01" style="display:none;">
						<img src="http://webimage.10x10.co.kr/eventIMG/2013/48267/txt_message_03.png" alt="아쉽게도 스폐셜 뱃지 1개만 모으셨네요~ 2014년에 다시 돌아올 스폐셜 뱃지에 도전하세요!" />
					</p>
					<p id="badgecomment02" style="display:none;">
						<img src="http://webimage.10x10.co.kr/eventIMG/2013/48267/txt_message_02.png" alt="아쉽게도 스폐셜 뱃지 2개만 모으셨네요~ 2014년에 다시 돌아올 스폐셜 뱃지에 도전하세요!" />
					</p>
					<p id="badgecommentall" style="display:none;">
						<img src="http://webimage.10x10.co.kr/eventIMG/2013/48267/txt_message_01.png" alt="축하합니다! 스폐셜 뱃지 3개를 모두 모으셨네요! 1000마일리지 적립 완료! 이제 시크릿 박스에 응모하세요!" />
					</p>
				<% end if %>	
			</div>
			<div class="giftGuide">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/48267/txt_gift_guide_01.png" alt="시크릿 박스 스페셜 뱃지 3개를 다 모은 고객 중, 20명 추첨! +  1000 마일리지 스페셜 뱃지 3개를 다 모은 고객, 전원 증정!" style="width:100%;" /></p>
				<dl>
					<dt><img src="http://webimage.10x10.co.kr/eventIMG/2013/48267/txt_gift_guide_02.png" alt="스폐셜 뱃지란?" style="width:22.85382%;" /></dt>
					<dd><img src="http://webimage.10x10.co.kr/eventIMG/2013/48267/txt_gift_guide_03.png" alt="특정 이벤트의 미션을 클리어하면 발행되는 스폐셜 뱃지로 2013년 10월 ~ 12월까지 한달에 한 번, 총 3종이 발급 되었으며, 3개의 스폐셜 뱃지를 모두 모으신 고객 중 추첨을 통해 &lt;시크릿 박스&gt;를 보내드립니다." style="width:87.58700%;"/></dd>
					<dt><img src="http://webimage.10x10.co.kr/eventIMG/2013/48267/txt_gift_guide_04.png" alt="시크릿 박스란?" style="width:22.85382%;" /></dt>
					<dd><img src="http://webimage.10x10.co.kr/eventIMG/2013/48267/txt_gift_guide_05.png" alt="텐바이텐이 엄선한 특별한 상품들을 담은 기프트 박스. (당첨자는 세무신고를 위해 개인정보를 요청할 수 있습니다.)" style="width:88.63109%;" /></dd>
				</dl>
			</div>
		</div>
	</div>

	<div class="specialBadgeContinue">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/48267/bg_content_bottom.gif" alt="같이가 이번이 끝이 아니래!! 2014년에도 또 할거래!!" style="width:100%;" /></p>
	</div>
</div>

<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width="0" height="0"></iframe>
<form name="evtFrm1" action="/event/etc/doEventSubscript48266.asp" method="post" target="evtFrmProc" style="margin:0px;">
	<input type="hidden" name="mode">
	<input type="hidden" name="dategubun">
</form>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->