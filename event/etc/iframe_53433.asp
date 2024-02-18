<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 텐텐 앱으로 떠나는 나만의 여름휴가
' History : 2014.07.10 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event53433Cls.asp" -->

<%
dim eCode, userid
	eCode=getevt_code
	userid = getloginuserid()

dim subscriptcount, osubscriptgubun, subscriptgubun, subscriptconfirmyn
	subscriptcount=0

If IsUserLoginOK() Then
	set osubscriptgubun = new Cevent_etc_common_list
		osubscriptgubun.frectevt_code=eCode
		osubscriptgubun.frectuserid=userid
		osubscriptgubun.frectsub_opt1=getnowdate
		osubscriptgubun.event_subscript_one
		
		subscriptcount = osubscriptgubun.ftotalcount
		
		if osubscriptgubun.ftotalcount>0 then
			subscriptgubun = osubscriptgubun.FOneItem.fsub_opt2
			subscriptconfirmyn = osubscriptgubun.FOneItem.fsub_opt3
		end if
	set osubscriptgubun=nothing
end if
%>

<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 텐텐앱으로 떠나는 나만의 여름휴가!</title>
<style type="text/css">
.mEvt53435 {position:relative;}
.mEvt53435 img {vertical-align:top; width:100%;}
.mEvt53435 p {max-width:100%;}
.mEvt53435 .goVacation {padding:35px 0; background:#2295f5;}
.mEvt53435 .goVacation h3 {padding-bottom:15px;}
.mEvt53435 .goVacation ul {overflow:hidden; padding:0 10px 8px;}
.mEvt53435 .goVacation li {position:relative; float:left; width:48%; margin:0 0.8%; -webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box;}
.mEvt53435 .goVacation li input {display:inline-block; position:absolute; left:50%; top:10%; margin-left:-11px;}
.mEvt53435 .goVacation p {text-align:center;}
.mEvt53435 .goVacation p input {display:inline-block; width:66%; margin:0 auto;}
.mEvt53435 .goVacation li span {position:absolute; left:0; top:0; width:100%; height:100%; display:inline-block;}
.mEvt53435 .goVacation li.selected span {background:url(http://webimage.10x10.co.kr/eventIMG/2014/53435/bg_selected.png) left top no-repeat; background-size:100% 100%;}
.mEvt53435 .goVacation li.hide span {background:url(http://webimage.10x10.co.kr/eventIMG/2014/53435/bg_hide.png) left top no-repeat; background-size:100% 100%;}
.mEvt53435 .download {width:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/53149/bg_coupon_event.png) left top repeat-y; background-size:100% 5px;}
.mEvt53435 .download .app dt {padding:30px 10px 20px;}
.mEvt53435 .download .app dd {width:52%; padding-bottom:40px; margin:0 auto;}
.mEvt53435 .evtNoti {padding:40px 15px 30px; background:#96eaf0;}
.mEvt53435 .evtNoti dt {padding:0 0 15px 10px; text-align:left;}
.mEvt53435 .evtNoti dt img {width:118px;}
.mEvt53435 .evtNoti dd {text-align:left; padding:0; margin:0;}
.mEvt53435 .evtNoti li {position:relative; padding:0 0 8px 10px; font-size:13px; color:#333; line-height:14px;}
.mEvt53435 .evtNoti li:after {content:''; display:block; position:absolute; top:4px; left:0; width:0; height:0; padding:2px; background:#0091cd; border-radius:10px;}
.mEvt53435 .evtNoti li strong {color:#d50c0c; font-weight:normal;}
@media all and (max-width:480px){
	.mEvt53435 .evtNoti {padding:30px 12px 20px;}
	.mEvt53435 .evtNoti dt {padding:0 0 8px 10px;}
	.mEvt53435 .evtNoti dt img {width:81px;}
	.mEvt53435 .evtNoti li {padding:0 0 5px 12px; font-size:11px; line-height:12px; background-position:left 4px;}
}
</style>
<script type="text/javascript">
var userAgent = navigator.userAgent.toLowerCase();
function gotoDownload(){
	// 모바일 홈페이지 바로가기 링크 생성
	if(userAgent.match('iphone')) { //아이폰
		document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011"
	} else if(userAgent.match('ipad')) { //아이패드
		document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011"
	} else if(userAgent.match('ipod')) { //아이팟
		document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011"
	} else if(userAgent.match('android')) { //안드로이드 기기
		document.location="market://details?id=kr.tenbyten.shopping"
	} else { //그 외
		document.location="https://play.google.com/store/apps/details?id=kr.tenbyten.shopping"
	}
};
$(function(){
	$('.goVacation li.selected').append('<span></span>');
	$('.goVacation li.hide').append('<span></span>');
});

	function jsCheckLimit() {
		if ("<%=IsUserLoginOK%>"=="False") {
			jsChklogin('<%=IsUserLoginOK%>');
		}
	}

	function jsSubmitvacation(frm){
		<% If IsUserLoginOK() Then %>
			<% If getnowdate>="2014-07-14" and getnowdate<"2014-07-21" Then %>
				<% if subscriptcount < 1 then %>
					var vacation;
					var tmpvacationgubun='';
					vacation = document.getElementsByName("vacation")

					for (i=0; i < vacation.length; i++){
						if (vacation[i].checked){
							tmpvacationgubun=vacation[i].value;
						}
					}
					if (tmpvacationgubun==''){
						alert("휴가 계획을 선택해 주세요.");
						return;
					}

					frm.vacationgubun.value=tmpvacationgubun
			   		frm.mode.value="vacationreg";
					frm.action="/event/etc/doEventSubscript53433.asp";
					frm.target="evtFrmProc";
					frm.submit();
					return;
				<% else %>
					alert("참여는 1일 1회 가능 합니다.");
					return;
				<% end if %>
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% end if %>
		<% Else %>
			parent.jsevtlogin();
			return;
		<% End IF %>
	}

</script>
</head>
<body>

<!-- 텐텐앱으로 떠나는 나만의 여름휴가! -->
<div class="mEvt53435">
	<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/53435/tit_vacation.png" alt="텐텐앱으로 떠나는 나만의 여름휴가!" /></h3>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53435/img_gift.png" alt="이번 여름휴가는 어떻게 지낼 계획이신가요? 총10분을 선정하여 신나는 여행준비를 도와줄 텐바이텐 기프트카드를 선물로 드립니다." /></p>
	<div class="goVacation">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/53435/tit_your_plan.png" alt="여러분의 휴가계획은 무엇인가요?" /></h3>
		<ul>
			<% 'for dev msg : 출발 버튼 클릭 후 선택된 li는 클래스 selected, 나머지 세개 li는 클래스 hide 넣어주세요 %>
			<li <% if subscriptcount > 0 then %><% if subscriptgubun="1" then %>class="selected"<% else %>class="hide"<% end if %><% end if %>>
				<label for="vc01"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53435/img_vacation01.png" alt="바닷가 - 여름에는 뭐니뭐니해도 바닷가지" /></label>
				<input type="radio" id="vc01" name="vacation" value="1" />
			</li>
			<li <% if subscriptcount > 0 then %><% if subscriptgubun="2" then %>class="selected"<% else %>class="hide"<% end if %><% end if %>>
				<label for="vc02"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53435/img_vacation02.png" alt="캠핑 - 도심을 떠나 자연에서 자유인되기" /></label>
				<input type="radio" id="vc02" name="vacation" value="2" />
			</li>
			<li <% if subscriptcount > 0 then %><% if subscriptgubun="3" then %>class="selected"<% else %>class="hide"<% end if %><% end if %>>
				<label for="vc03"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53435/img_vacation03.png" alt="해외 휴양지 - 여름에 외쿡물 마시고 와써열" /></label>
				<input type="radio" id="vc03" name="vacation" value="3" />
			</li>
			<li <% if subscriptcount > 0 then %><% if subscriptgubun="4" then %>class="selected"<% else %>class="hide"<% end if %><% end if %>>
				<label for="vc04"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53435/img_vacation04.png" alt="방콕 - 진정한 휴가는 아무것도 하지 않는 것" /></label>
				<input type="radio" id="vc04" name="vacation" value="4" />
			</li>
		</ul>
		<p>
			<% if subscriptcount < 1 then %>
				<input type="image" onclick="jsSubmitvacation(evtFrm1); return false;" src="http://webimage.10x10.co.kr/eventIMG/2014/53435/btn_start.png" alt="출발" />
			<% else %>
				<% if subscriptconfirmyn="N" then %>
					<img src="http://webimage.10x10.co.kr/eventIMG/2014/53435/txt_arrival.png" alt="텐바이텐 APP으로 여행지에 도착하세요" />
				<% else %>
					<img src="http://webimage.10x10.co.kr/eventIMG/2014/53435/btn_end.png" alt="응모완료">
				<% end if %>
			<% end if %>		
		</p>
	</div>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53435/txt_process.png" alt="이벤트 참여방법" /></p>
	<div><a href="#" onclick="gotoDownload()"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53435/btn_app_download.png" alt="10X10 APP 다운받기" /></a></div>
	<dl class="evtNoti">
		<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/53435/tit_notice.png" alt="이벤트 유의사항" /></dt>
		<dd>
			<ul>
				<li>텐바이텐 회원가입 후 이벤트 참여가 가능하며, 한 ID당 1회 참여 가능합니다.</li>
				<li>텐바이텐 APP 설치는 구글플레이스토어 또는 앱스토어에서 가능합니다.</li>
				<li>당첨 시 상품수령 및 세무신고를 위해 개인정보를 요청할 수 있습니다.</li>
				<li>제세공과금은 당첨자 부담이며, 당첨자에게는 7월 22일 개별연락 드립니다.</li>
			</ul>
		</dd>
	</dl>
</div>
<!-- //텐텐앱으로 떠나는 나만의 여름휴가! -->
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
<form name="evtFrm1" action="/event/etc/doEventSubscript53433.asp" method="post" target="evtFrmProc" style="margin:0px;">
	<input type="hidden" name="mode">
	<input type="hidden" name="vacationgubun">
</form>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->