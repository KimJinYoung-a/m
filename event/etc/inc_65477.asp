<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<%
'####################################################
' Description : 비밀의방 초대권
' History : 2015.08.14 원승현 생성
'####################################################
	Dim vUserID, eCode, nowdate
	Dim strSql, totcnt, dvalue, altvalue, procdate, chasu

	vUserID = GetLoginUserID

	IF application("Svr_Info") = "Dev" THEN
		eCode = "64854"
	Else
		eCode = "65477"
	End If


	'// 일자별 값 셋팅
	select case Trim(Left(now(), 10))

		Case "2015-08-14", "2015-08-15", "2015-08-16"
			dvalue = "txt_date_0817"
			altvalue= "8월 17일"
			procdate = "2015-08-17"
			chasu = 1

		Case "2015-08-17"
			dvalue = "txt_date_0818"
			altvalue= "8월 18일"
			procdate = "2015-08-18"
			chasu = 2

		Case "2015-08-18"
			dvalue = "txt_date_0819"
			altvalue= "8월 19일"
			procdate = "2015-08-19"
			chasu = 3

		Case "2015-08-19"
			dvalue = "txt_date_0820"
			altvalue= "8월 20일"
			procdate = "2015-08-20"
			chasu = 4

		Case "2015-08-20"
			dvalue = "txt_date_0821"
			altvalue= "8월 21일"
			procdate = "2015-08-21"
			chasu = 5

		Case "2015-08-21", "2015-08-22", "2015-08-23"
			dvalue = "txt_date_0824"
			altvalue= "8월 24일"
			procdate = "2015-08-24"
			chasu = 6

		Case "2015-08-24"
			dvalue = "txt_date_0825"
			altvalue= "8월 25일"
			procdate = "2015-08-25"
			chasu = 7

		Case "2015-08-25"
			dvalue = "txt_date_0826"
			altvalue= "8월 26일"
			procdate = "2015-08-26"
			chasu = 8

		Case "2015-08-26"
			dvalue = "txt_date_0827"
			altvalue= "8월 27일"
			procdate = "2015-08-27"
			chasu = 9

		Case "2015-08-27"
			dvalue = "txt_date_0828"
			altvalue= "8월 28일"
			procdate = "2015-08-28"
			chasu = 10

		Case "2015-08-28"
			dvalue = "txt_date_0828"
			altvalue= "8월 28일"
			procdate = "2015-08-28"
			chasu = 10

		Case  Else
			dvalue = "txt_date_0817"
			altvalue= "8월 17일"
			procdate = "2015-08-17"
			chasu = 1

	End Select
%>
<style type="text/css">
img {vertical-align:top;}

.invite {position:relative; padding-bottom:28%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/65477/bg_doors.png) no-repeat 50% 0; background-size:100% auto;}
.invite .btnKnock {position:absolute; top:21%; left:50%; z-index:10; width:40.78%; margin-left:-20.39%; background-color:transparent;}
.invite .btnKnock .time {position:absolute; top:17%; left:50%; width:79.69%; margin-left:-39.84%;}
.invite .btnKnock .time img {animation-name:swing; -webkit-animation-name:swing; animation-iteration-count:3; -webkit-animation-iteration-count:3; animation-duration:8s; -webkit-animation-duration:8s; animation-fill-mode:both;-webkit-animation-fill-mode:both;  transform-origin:50% 0%; -webkit-transform-origin:50% 0%;}
@keyframes swing {
	0% {transform:rotateZ(0deg);}
	30% {transform:rotateZ(-10deg);}
	60% {transform:rotateZ(10deg);}
	100% {transform:rotateZ(0deg);}
}
@-webkit-keyframes swing {
	0% {-webkit-transform:rotateZ(0deg);}
	30% {-webkit-transform:rotateZ(-10deg);}
	60% {-webkit-transform:rotateZ(10deg);}
	100% {-webkit-transform:rotateZ(0deg);}
}

.invite .shine {position:absolute; top:13.6%; left:50%; width:62%; margin-left:-31%;}

.shine {animation-name:shine; -webkit-animation-name:shine; animation-iteration-count:5;  -webkit-animation-iteration-count:5; animation-duration:10s; -webkit-animation-duration:10s; animation-fill-mode:both;-webkit-animation-fill-mode:both;}
@-webkit-keyframes shine {
	0% {opacity:0;}
	50% {opacity:1;}
	100% {opacity:0;}
}
@keyframes shine {
	0% {opacity:0;}
	50% {opacity:1;}
	100% {opacity:0;}
}

.invite .appDown {position:absolute; bottom:5.7%; left:50%; width:87.6%; margin-left:-43.8%;}

/* for dev msg : app일 경우 아래 css 적용되게 해주세요 */
<% if isApp="1" then %>
	.invite {padding-bottom:12%;}
	.invite .btnKnock {top:23.5%;}
	.invite .shine {top:16.6%;}
<% end if %>

.lyLetter {display:none; position:absolute; top:-7%; left:50%; z-index:50; width:77.5%; margin-left:-38.75%;}
.lyLetter .btnclose {position:absolute; bottom:10%; left:50%; width:62.7%; margin-left:-31.35%;}
.mask {display:none; position:absolute; top:0; left:0; z-index:30; width:100%; height:100%; background:rgba(0,0,0,.6);}

.noti {padding:5% 3.125%;}
.noti h2 {color:#000; font-size:13px;}
.noti h2 strong {display:inline-block; padding-bottom:1px; border-bottom:2px solid #000; line-height:1.25em;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; margin-top:2px; padding-left:10px; color:#444; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:4px; left:0; width:4px; height:4px; border-radius:50%; background-color:#d20700;}

@media all and (min-width:480px){
	.noti ul {margin-top:16px;}
	.noti h2 {font-size:17px;}
	.noti ul li {margin-top:4px; font-size:13px;}
}

@media all and (min-width:600px){
	.noti h2 {font-size:20px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:6px; padding-left:15px; font-size:16px;}
	.noti ul li:after {top:9px;}
}
</style>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript">

function checkform(){
	<% If vUserID = "" Then %>
		if ("<%=IsUserLoginOK%>"=="False") {
			<% if isApp=1 then %>
				parent.calllogin();
				return false;
			<% else %>
				parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
				return false;
			<% end if %>
			return false;
		}
	<% End If %>
	<% If vUserID <> "" Then %>
		$.ajax({
			type:"GET",
			url:"/event/etc/doEventSubscript65477.asp?mode=invite&procdate=<%=procdate%>&chasu=<%=chasu%>",
			dataType: "text",
			async:false,
			cache:true,
			success : function(Data, textStatus, jqXHR){
				if (jqXHR.readyState == 4) {
					if (jqXHR.status == 200) {
						if(Data!="") {
							var str;
							for(var i in Data)
							{
								 if(Data.hasOwnProperty(i))
								{
									str += Data[i];
								}
							}
							str = str.replace("undefined","");
							res = str.split("|");
							if (res[0]=="OK")
							{
								$("#lyLetter").empty().html(res[1]);
								$(".mask").show();
								$("#lyLetter").show();
							}
							else
							{
								errorMsg = res[1].replace(">?n", "\n");
								$("#lyLetter").hide();
								$(".mask").hide();
								alert(errorMsg );
								document.location.reload();
								return false;
							}
						} else {
							alert("잘못된 접근 입니다.");
							document.location.reload();
							return false;
						}
					}
				}
			},
			error:function(jqXHR, textStatus, errorThrown){
				alert("잘못된 접근 입니다.");
				//var str;
				//for(var i in jqXHR)
				//{
				//	 if(jqXHR.hasOwnProperty(i))
				//	{
				//		str += jqXHR[i];
				//	}
				//}
				//alert(str);
				document.location.reload();
				return false;
			}
		});
	<% End If %>
}

function fnappdowncnt(){
	var userAgent = navigator.userAgent.toLowerCase();
	parent.top.location.href='http://m.10x10.co.kr/apps/link/?7920150814';
	return false;
}

function fnlaclose()
{
	$("#lyLetter").hide();
	$(".mask").fadeOut();
	document.location.reload();
	return false;
}


function fnkakaosendcall()
{
	var str = $.ajax({
		type: "GET",
		url: "/event/etc/doEventSubscript65477.asp",
		data: "mode=kakao",
		dataType: "text",
		async: false
	}).responseText;
	if (str=="99")
	{
		<% if isApp="1" then %>
			parent_kakaolink('[텐바이텐] 비밀의방\n초대장을 받아야만\n들어갈 수 있는 비밀의 방\n\n며느리도 모르는 엄청난 혜택이\n당신을 기다립니다.\n\n지금 도전하세요!\n오직 텐바이텐에서!' , 'http://webimage.10x10.co.kr/eventIMG/2015/65477/img_kakao_push.png' , '200' , '200' , 'http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=65477' );
		<% else %>
			parent_kakaolink('[텐바이텐] 비밀의방\n초대장을 받아야만\n들어갈 수 있는 비밀의 방\n\n며느리도 모르는 엄청난 혜택이\n당신을 기다립니다.\n\n지금 도전하세요!\n오직 텐바이텐에서!' , 'http://webimage.10x10.co.kr/eventIMG/2015/65477/img_kakao_push.png' , '200' , '200' , 'http://m.10x10.co.kr/event/eventmain.asp?eventid=65477' );
		<% end if %>
	}
	else{
		alert('오류가 발생했습니다.');
		return false;
	}	
	return false;	
}
</script>

<div class="mEvt65477">
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65477/txt_invite.png" alt="불이 켜진 비밀의 방으로 당신을 초대합니다. 초대장을 받으신 분들에게만 선물이 찾아갑니다!" /></p>

	<div class="invite">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65477/txt_knock.png" alt="문을 두드려서 초대장을 신청하세요! 초대장은 푸쉬메시지로 발송될 예정입니다." /></p>
		<button type="button" class="btnKnock" onclick="checkform();return false;">
			<%' for dev msg : 초대장 날짜 txt_date_0817 ~ txt_date_0828 %>
			<strong class="time"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65477/<%=dvalue%>.png" alt="<%=altvalue%>" /></strong>
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/65477/img_door.png" alt="초대장 받기" />
		</button>

		<%' for dev msg : layer 초대장 %>
		<div id="lyLetter" class="lyLetter" style="display:hidden"></div>

		<span class="shine"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65477/img_shine.png" alt="" /></span>

		<%' for dev msg : 모바일웹일 경우에만 보입니다. %>
		<% If isApp="1" Then %>
		<% Else %>
			<div class="appDown">
				<a href="" onclick="fnappdowncnt();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65477/btn_app.png" alt="아직 텐바이텐 앱이 없다면 앱 설치하러 가기" /></a>
			</div>
		<% End If %>
	</div>
	
	<!-- for dev msg : 카카오톡 -->
	<div class="kakaka">
		<a href="" onclick="fnkakaosendcall();return false;" title="카카오톡으로 비밀의 방 알려주기"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65477/btn_kakao.png" alt="친구와 함께 비밀의 방 초대장 받기 친구에게 이 놀라운 소식을 알려주고 비밀의 방에 함께 도전해 보세요!" /></a>
	</div>

	<div class="noti">
		<h2><strong>이벤트 안내</strong></h2>
		<ul>
			<li>텐바이텐 고객님을 위한 이벤트 입니다. 비회원이신 경우 회원가입 후 참여해 주세요.</li>
			<li>본 이벤트는 텐바이텐 APP에서만 참여 가능합니다.</li>
			<li>본 이벤트는 ID당 1일 1회만 응모가능 합니다.</li>
			<li>신청하신 날짜의 초대장은 익일 발송될 예정입니다.</li>
			<li>본 초대장은 푸시 메시지로 발송되며, App > 메뉴 > 쇼핑소식에서 다시 확인할 수 있습니다.</li>
		</ul>

		<div class="mask"></div>
	</div>
</div>
<script type="text/javascript">
$(function() {
	/* layer */
	$(".btnKnock").click(function(){
		$("#lyLetter").show();
		$(".mask").fadeIn();
		window.$('html,body').animate({scrollTop:200}, 500);
	});

});
</script>

<!-- #include virtual="/lib/db/dbclose.asp" -->
