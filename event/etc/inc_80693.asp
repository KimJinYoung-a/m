<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#############################################################
' Description : 모바일 APP 유입 이벤트
' History : 2017-09-22 허진원 생성
'#############################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
	Dim eCode, mycnt
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  66434
	Else
		eCode   =  80693
	End If

	dim userid, i, UserAppearChk, nowdate
		userid = GetEncLoginUserID()

	nowdate = date
	'nowdate = "2017-09-25"

	'// 이벤트 참여 응모현황
	if userid <> "" then 
		UserAppearChk = getevent_subscriptexistscount(eCode,userid,"","","")
	else
		UserAppearChk=1
	end if

%>
<style type="text/css">
.mEvt80693 {background-color:#2b4388;}
.evtNoti {padding:4.27rem 2.3rem; text-align:center;  background-color:#efefef}
.evtNoti h3 {display:inline-block; padding-bottom:0.43rem; margin-bottom:1.71rem; border-bottom:solid 2px #3d5392; font-size:1.54rem; font-weight:bold; color:#3d5392;}
.evtNoti ul {text-align:left;}
.evtNoti li {position:relative; padding:0 0 0.3rem 1.7rem; font-size:1.2rem; line-height:1.88rem;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.85rem; width:0.5rem; height:0.15rem; background:#000;}
.evtNoti li a {display:inline-block; height:2.2rem; line-height:2.4rem; margin:0.3rem 0 0.6rem; padding:0 1.25rem; background:#a81a2a;}
</style>
<% if isApp=1 then %>
<script type="text/javascript">
var vPid="",vUuid="";

$(function(){
    // PushId접수
    setTimeout(function(){
	    callNativeFunction('getDeviceInfo', {"callback": function(deviceInfo) {
	       	vPid = deviceInfo.psid;
	       	vUuid = deviceInfo.uuid;
			}
		});
    },300);
});


function fnSubmit(){
	<% If IsUserLoginOK() Then %>
		<% If not( nowdate>="2017-09-25" and nowdate<"2017-10-01" ) Then %>
			alert("응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if UserAppearChk > 0 then %>
				alert("이미 응모하셨습니다.\n당첨자 발표일을 기다려주세요.");
				return false;
			<% else %>
				$.ajax({
					type:"POST",
					url:"/event/etc/doeventsubscript/doEventSubscript80693.asp",
					data:"pid="+vPid+"&uid="+vUuid,
					success : function(Data){
						if(Data!="") {
							res = Data.split("|");
							if (res[0]=="OK")
							{
								alert("응모가 완료 되었습니다.\n당첨자 발표일을 기다려주세요.");
								parent.location.reload();
								return false;
							}
							else
							{
								errorMsg = res[1].replace(">?n", "\n");
								alert(errorMsg);
								return false;
							}
						} else {
							alert("잘못된 접근 입니다.[E01]");
							parent.location.reload();
							return false;
						}
					},
					error:function(err){
						console.log(err.responseText);
						return false;
					}
				});
			<% end if %>
		<% end if %>
	<% else %>
		parent.calllogin();
		return false;
	<% end if %>
}
</script>
<% end if %>
<!-- 띵동! 알림이오 -->
<div class="mEvt80693">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/80693/m/tit_coupon.jpg" alt="띵동 알람이요 지금 앱 알림 수신동의하고 다양한 혜택까지 받아가세요 2017.09.25 - 10.01" /></h2>
	<div class="coupon">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/80693/m/img_gift.jpg" alt="앱 푸시 알림에 동의하면? 갤럭시 노트8 (미드나잇 블랙 컬러 64G) 1명 추첨 할인쿠폰 (비정기적 푸시 알림을 통해 쿠폰 전달 예정) 전원 증정" /></p>
	<% if isApp=1 then %>
		<a href="" class="mApp" onclick="fnSubmit(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80693/m/btn_go.jpg" alt="응모하기" /></a>
	<% else %>
		<a href="/event/appdown/" class="btnAppDown mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80693/m/btn_app_down.jpg" alt="앱다운받기 (앱에서만 참여 가능)" /></a>
	<% end if %>
	</div>
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/80693/m/txt_how_to.jpg" alt="나의 수신여부를 확인하려면? STEP 01 APP 화면 하단바에 있는 마이텐바이텐 클릭 STEP 02 마이텐바이텐 오른쪽에 있는 설정 아이콘 클릭 STEP 03 광고성 알림 설정에 빨갛게 표시되면 수신 동의" /></div>
	<div class="evtNoti">
		<h3>이벤트 유의사항</h3>
		<ul>
			<li>본 이벤트는 ID당 한 번씩만 응모하실 수 있습니다.</li>
			<li>텐바이텐 앱 내에서의 알림과 더불어 고객님의 기기 <br/ >자체의 알림 설정 여부도 꼭 확인 부탁드립니다.</li>
			<li>당첨자 발표는 10월 2일(월) 공지사항에 게시될 <br/ >예정입니다.</li>
			<li>갤럭시의 제세공과금은 텐바이텐 부담이며, <br/ >세무신고를 위해 개인정보를 취합한 뒤에 경품이<br/ >증정됩니다.</li>
		</ul>
	</div>
</div>
<!--// 띵동! 알림이오 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->