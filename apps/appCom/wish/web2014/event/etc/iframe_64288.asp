<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description : 그것이 알고 싶다 for App
' History : 2015-06-30 원승현 생성
'####################################################
	Dim vUserID, eCode, cMil, vMileValue, vMileArr, userSel

	vUserID = GetLoginUserID
	IF application("Svr_Info") = "Dev" THEN
		eCode = "63806"
	Else
		eCode = "64288"
	End If

	Dim strSql , totcnt
	'// 응모여부
	strSql = "select count(*), sub_opt1 from db_event.dbo.tbl_event_subscript where userid = '"& vUserID &"' and evt_code = '"& ecode &"' group by sub_opt1 " 
	rsget.Open strSql,dbget,1
	IF Not rsget.Eof Then
		totcnt = rsget(0)
		userSel = rsget(1)
	End IF
	rsget.close()

%>
<html lang="ko">
<head>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<title></title>
<style type="text/css">
img {vertical-align:top;}
.mEvt64288 {position:relative;}
.interview {position:relative;}
.interview .interviewee {position:absolute; top:0; width:50%; height:100%; background-position:0 0; background-repeat:no-repeat; background-size:200% 100%; cursor:pointer;}
.interview .typeA {left:0; background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64288/btn_a.gif);}
.interview .typeB {right:0; background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64288/btn_b.gif);}
.interview .interviewee span {display:none;}
.interview .current {background-position:100% 0;}
.evtNoti {padding:13px 20px 26px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/64288/bg_notice.gif) 0 0 repeat-y; background-size:100% auto; box-shadow:0 0 5px 2px rgba(0,0,0,.4);}
.evtNoti h3 span {display:inline-block; padding:5px 8px 3px; color:#177ecb; font-size:12px; font-weight:bold; border:2px solid #177ecb; border-radius:15px;}
.evtNoti ul {padding:12px 5px 0;}
.evtNoti li {position:relative; font-size:11px; line-height:1.3; color:#666; padding:0 0 4px 12px; letter-spacing:-0.025em;}
.evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:2.5px; width:2px; height:2px; border:2px solid #177ecb; border-radius:50%;}
@media all and (min-width:480px){
	.evtNoti {padding:20px 30px 39px;}
	.evtNoti h3 span {padding:7px 12px 4px; font-size:18px; border:3px solid #177ecb; border-radius:23px;}
	.evtNoti ul {padding:18px 7px 0;}
	.evtNoti li {font-size:17px; padding:0 0 6px 18px;}
	.evtNoti li:after {top:4px; width:3px; height:3px; border:3px solid #177ecb;}
}
</style>
<script type="text/javascript">

$(function(){
	$('.interviewee').click(function(){

		<% If vUserID = "" Then %>
			if ("<%=IsUserLoginOK%>"=="False") {
				parent.calllogin();
				return false;
			}
		<% End If %>

		<% If totcnt >= 1 then %>
			alert("이미 투표하셨습니다.");
			return false;
		<% end if %>

		if (document.frmcom.usS.value=='Y')
		{
			alert("이미 투표하셨습니다.");
			return false;
		}

		$('.interviewee').removeClass('current');
		$(this).addClass('current');

		if ($(this).attr('class')=="interviewee typeA current")
		{
			userSelValue = 1;
		}

		if ($(this).attr('class')=="interviewee typeB current")
		{
			userSelValue = 2;
		}

		if ($(this).attr('class')=="")
		{
			alert("잘못된 접근 입니다.");
			return false;
		}

		<% If vUserID <> "" Then %>
			<% If totcnt >= 1 then %>
				alert("이미 투표하셨습니다.");
				return false;
			<% Else %>
				var result;
				$.ajax({
					type:"GET",
					url:"/apps/appcom/wish/web2014/event/etc/doEventSubscript64288.asp?usv="+userSelValue,
					dataType: "text",
					async:false,
					cache:true,
					success : function(Data){
						result = jQuery.parseJSON(Data);

						if (result.resultcode=="11")
						{
							alert('이미 투표하셨습니다.');
							return;
						}
						else if (result.resultcode=="22")
						{
							alert('이미 투표하셨습니다.');
							return;
						}
						else if (result.resultcode=="44")
						{
							alert('로그인을 해야 이벤트에 참여할 수 있어요.');
							return;
						}
						else if (result.resultcode=="99")
						{
							document.frmcom.usS.value='Y';
							alert('선택해 주셔서 감사합니다!');
							return;
						}
					}
				});
			 <% End If %>
		<% End If %>

	});

	<% if userSel = 1 then %>
		$('.interviewee').removeClass('current');
		$('.typeA').addClass('current');
	<% elseif userSel = 2 then %>
		$('.interviewee').removeClass('current');
		$('.typeB').addClass('current');
	<% end if %>

});

var userAgent = navigator.userAgent.toLowerCase();
function gotoDownload(){
	// 모바일 홈페이지 바로가기 링크 생성
	if(userAgent.match('iphone')) { //아이폰
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('ipad')) { //아이패드
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('ipod')) { //아이팟
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('android')) { //안드로이드 기기
		window.parent.top.document.location= 'market://details?id=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401<%=request("ref")%>';
	} else { //그 외
		window.parent.top.document.location= 'https://play.google.com/store/apps/details?id=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401<%=request("ref")%>';
	}
};

</script>
</head>
<body>
<div class="evtCont">
<form name="frmcom" id="frmcom" method="post">
	<input type="hidden" name="usS">
</form>
	<!--그것이 알고싶다(APP) -->
	<div class="mEvt64288">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/64288/tit_wonder.gif" alt="7월 1일 앱쿠폰의 진실, 그것이 알고싶다 - 앱쿠폰을 사용하지 못한 이유는 무엇일까요? 참여하시면 추첨을 통해 선물을 드립니다.(일시:7월 2일 오늘하루, 당첨자 발표:7월 4일)" /></h2>
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/64288/tit_interview.gif" alt="제보자 인터뷰(앱 쿠폰을 사용하지 못한 이유를 선택 해 주세요)" /></h3>
		<div class="interview">
			<!-- 클릭시 해당 항목에 current 클래스 생성됩니다 -->
			<p class="interviewee typeA">
				<span>A군:나중에 사려고 했는데..앱쿠폰이 벌써 사라졌어요!</span>
			</p>
			<p class="interviewee typeB">
				<span>B양:무엇을 사야할지.. 잘 모르겠어요!</span>
			</p>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/64288/bg_blank.png" alt="" /></div>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64288/txt_gift.gif" alt="용감한 선택을 한 당신에게 드리는 선물! 텐바이텐 기프트카드 만원권(10명 추첨)" /></p>
		<div class="evtNoti">
			<h3><span>이벤트 안내</span></h3>
			<ul>
				<li>본 이벤트는 로그인 후에 참여가 가능합니다.</li>
				<li>본 이벤트는 전날 앱 쿠폰을 사용하지 않은 고객을 대상으로 한<br />시크릿 이벤트 입니다.</li>
				<li>기프트카드는 당첨자 발표날 일괄 지급 예정입니다.</li>
			</ul>
		</div>
	</div>
	<!--// 그것이 알고싶다(APP) -->
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->