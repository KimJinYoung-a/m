<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 아이커피 1차
' History : 2015.06.18 원승현 생성
'			2015.06.19 한용민 수정(카카오톡 클릭 카운트 추가, 앱다운르도 클릭 카운트 추가)
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
Dim eCode, vDisp, sqlstr, mycouponkey, mygienee, totalcnt, evtImgFName
Dim userid
Dim nowdate
	nowdate = date()
	'nowdate = #06/26/2015 09:00:00#

dim LoginUserid
LoginUserid = getLoginUserid()

IF application("Svr_Info") = "Dev" THEN
	eCode = "63795"
Else
	eCode = "64010"
End If

If nowdate >= "2015-06-18" And nowdate < "2015-06-23" Then
	evtImgFName = "coffee"
End If

If nowdate >= "2015-06-23" And nowdate < "2015-06-26" Then
	evtImgFName = "chicken"
End If

If nowdate >= "2015-06-26" Then
	evtImgFName = "tteokbokki"
End If

dim tmpval
if nowdate>="2015-06-23" then
	tmpval = "2"
elseif nowdate>="2015-06-26" then
	tmpval = "3"
else
	tmpval = "1"
end if
%>
<style type="text/css">
.mEvt63739 img, .mEvt63739 button {width:100%; vertical-align:top;}

.topic {position:relative;}
.topic p {visibility:hidden; width:0; height:0;}

.make {padding-bottom:6.5%;}

<% If nowdate >= "2015-06-26" Then %>
	/* 6/26 tteokbokki */
	.make {background:#ffd674 url(http://webimage.10x10.co.kr/eventIMG/2015/63739/tteokbokki/bg_pattern.png) repeat-y 50% 0; background-size:100% auto;}
<% elseIf nowdate >= "2015-06-23" Then %>
	/* 6/23~6/25 chicken */
	.make {background:#b6ecea url(http://webimage.10x10.co.kr/eventIMG/2015/63739/chicken/bg_pattern.png) repeat-y 50% 0; background-size:100% auto;}
<% else %>
	.make {padding-bottom:6.5%; background:#f7eeca url(http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/bg_pattern.png) repeat-y 50% 0; background-size:100% auto;}
<% end if %>

.make .inner {width:93.75%; margin:0 auto; padding-bottom:6%; background-color:#fff;}
.make .inner {-webkit-box-shadow: 10px 10px 26px -12px rgba(75,75,75,0.55);
-moz-box-shadow: 10px 10px 26px -12px rgba(75,75,75,0.55);
box-shadow: 10px 10px 26px -12px rgba(75,75,75,0.55);}
.make .btnapp {display:block; width:72%; margin:5% auto 0;}

.gift {position:relative;}
.gift .linkarea {overflow:hidden; display:block; position:absolute; bottom:0; left:33%; width:33.333%; height:0; padding-bottom:48.25%; font-size:11px; line-height:11px; text-align:center; text-indent:-999em;}
.gift .linkarea span {position:absolute; top:0; left:0; width:100%; height:100%; /*background-color:black; opacity:0.3;*/}

.noti {padding:22px 16px; }
.noti h2 {color:#222; font-size:14px;}
.noti h2 strong {display:inline-block; padding:5px 12px 2px; border-radius:20px; background-color:#dee6e6; line-height:1.25em;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; margin-top:2px; padding-left:8px; color:#444; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:4px; left:0; width:4px; height:4px; border-radius:50%; background-color:#8c9ace;}

@media all and (min-width:480px){
	.noti {padding:40px 35px;}
	.noti ul {margin-top:16px;}
	.noti h2 {font-size:17px;}
	.noti ul li {margin-top:4px; font-size:13px;}
}

@media all and (min-width:600px){
	.noti h2 {font-size:20px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:6px; padding-left:20px; font-size:16px;}
	.noti ul li:after {top:9px;}
}
</style>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script language="javascript">

var userAgent = navigator.userAgent.toLowerCase();
function gotoDownload(){
	parent.top.location.href='http://m.10x10.co.kr/apps/link/?7420150618';
	return false;
};

$(function(){
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		$("#mo").hide();
	}else{
		$("#mo").show();
	}
});

//카카오 친구 초대
function kakaosendcall(){
	<% if not( nowdate>="2015-06-19" and nowdate<"2015-06-29" ) then %>
		alert("이벤트 응모 기간이 아닙니다.");
		return;
	<% else %>
		var rstStr = $.ajax({
			type: "POST",
			url: "/apps/appCom/wish/web2014/event/etc/doEventSubscript63739_<%= tmpval %>.asp",
			data: "mode=KAKAO",
			dataType: "text",
			async: false
		}).responseText;
		//alert(rstStr);
		if (rstStr == "OK"){
			<% if nowdate>="2015-06-26" then %>
				parent.parent_kakaolink('[ 텐바이텐 ] 아이 러브 떡볶이 ♥\n\n나만의 떡볶이를 만들고,\n맛있는 선물도 받자 :)\n\n매일 총 500명에게는\n죠스떡볶이 떡볶이가 공짜!\n오직 텐바이텐 APP에서만 !' , 'http://webimage.10x10.co.kr/eventIMG/2015/63739/img_kakao_tteokbokki.png' , '200' , '200' , 'http://m.10x10.co.kr/apps/link/?7420150618' );
				return false;
			<% elseif nowdate>="2015-06-23" then %>
				parent.parent_kakaolink('[텐바이텐]아이 러브 치킨!\n\n나만의 치킨 스타일을 선택하고,\n맛있는 선물도 받자:)\n\n매일 총 300명에게는\nBBQ 치킨이 공짜!\n오직 텐바이텐 APP에서만!' , 'http://webimage.10x10.co.kr/eventIMG/2015/63739/img_kakao_chicken.png' , '200' , '200' , 'http://m.10x10.co.kr/apps/link/?7420150618' );
				return false;
			<% else %>
				parent.parent_kakaolink('[텐바이텐]아이 러브 커피!\n\n나만의 커피를 만들고\n맛있는 선물도 받자:)\n\n매일 총1,000명에게는\n스타벅스 아메리카노가 공짜!\n오직 텐바이텐 APP에서만!' , 'http://webimage.10x10.co.kr/eventIMG/2015/63739/img_kakao_coffee.png' , '200' , '200' , 'http://m.10x10.co.kr/apps/link/?7420150618' );
				return false;
			<% end if %>
		}else if (rstStr == "DATENOT"){
			alert('이벤트 응모 기간이 아닙니다.');
			return false;
		}else{
			alert('관리자에게 문의');
			return false;
		}
	<% end if %>
}

function applink10x10(){
	var str = $.ajax({
		type: "GET",
		url: "/apps/appCom/wish/web2014/event/etc/doEventSubscript63739_<%= tmpval %>.asp",
		data: "mode=mo_main",
		dataType: "text",
		async: false
	}).responseText;

	if (str == "OK"){
		gotoDownload();
	}else{
		alert('오류가 발생했습니다.');
		return false;
	}
}

function goAlertApp(){
	alert("텐바이텐 앱에서 참여 가능합니다.");
}

</script>
</head>
<body>
<%' [모바일] 텐바이텐 심심타파 이벤트 %>
<div class="mEvt63739">
	<%' for dev msg : coffee에서 6/23~6/25 : chicken, 6/26부터는 tteokbokki 폴더로 바꿔주세요 %>
	<section>
		<div class="topic">
			<h1><img src="http://webimage.10x10.co.kr/eventIMG/2015/63739/<%=evtImgFName%>/tit_i_love.png" alt="" /></h1>
		</div>

		<div class="make">
			<div class="inner">
				<div class="step">
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/64010/<%=evtImgFName%>/img_step.jpg" alt="" />
				</div>

				<%' for dev msg : 앱 바로가기 %>
				<a href="" onclick="applink10x10(); return false;" class="btnapp"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64010/<%=evtImgFName%>/btn_app.png" alt="텐바이텐 앱으로 가기" /></a>
			</div>
		</div>

		<div class="gift">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64010/<%=evtImgFName%>/img_gift.jpg" alt="" /></p>
		</div>

		<%' for dev msg : 카카오톡 %>
		<div class="kakao">
			<a href="" onclick="kakaosendcall(); return false;" title="카카오톡으로 친구에게 소문내기"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63739/<%=evtImgFName%>/btn_kakao.png" alt="" /></a>
		</div>

		<div class="noti">
			<h2><strong>이벤트 유의사항</strong></h2>
			<ul>
				<li>텐바이텐 회원 대상 이벤트 입니다.</li>
				<li>한 ID당 하루 한 번만 참여하실 수 있습니다.</li>
				<li>본 이벤트는 모바일APP에서만 참여할수 있습니다.</li>
				<li>모바일 상품권은 익일 오후 4시이후에 순차적으로 발급됩니다.</li>
				<li>경품으로 지급된 상품은 주소 입력 후 일주일 이내에 발송됩니다.</li>
				<li>추천상품 할인쿠폰은 랜덤으로 자동 발급되며, 사용기한은 6월 30일까지입니다.</li>
			</ul>
		</div>
	</section>
</div>
<%'// [모바일] 텐바이텐 심심타파 이벤트 %>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->