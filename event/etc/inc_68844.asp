<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 2월 보너스
' History : 2016.01.25 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim eCode, userid, currenttime, i, totalbonuscouponcount, totalbonuscouponcountusingy
	IF application("Svr_Info") = "Dev" THEN
		eCode = "66010"
	Else
		eCode = "68844"
	End If

currenttime = now()
'																		currenttime = #01/25/2016 10:05:00#

userid = GetEncLoginUserID()


dim subscriptcount
subscriptcount=0

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
end if

%>
<style type="text/css">
img {vertical-align:top;}
.mEvt68844 {position:relative;}
.saveDate {position:relative;}
.saveDate .btnSave {display:block; position:absolute; left:0; top:32%; width:100%; background:transparent;}
.selectDate {position:relative;}
.selectDate ul {overflow:hidden; position:absolute; left:2.65%; top:0; width:95.15625%; height:100%;}
.selectDate li {float:left; width:14.28571%; cursor:pointer;}
.selectDate li img {opacity:0;}
.selectDate li:first-child {margin-left:14.28571%;}
.evtNoti {padding:20px 4.6%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/68844/m/bg_notice.png) repeat-y 0 0; background-size:100% auto;}
.evtNoti h3 {margin:0 0 15px -10px; text-align:center;}
.evtNoti h3 strong {display:inline-block; font-size:14px; line-height:20px; color:#fff; padding-left:25px; background:url(http://webimage.10x10.co.kr/eventIMG/2016/68844/m/ico_mark.png) no-repeat 0 0; background-size:19px 19px;}
.evtNoti li {position:relative; padding-left:10px; font-size:11px; line-height:1.4; color:#f1f1f1;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:5px; width:4px; height:1px; background:#fff;}
.saveLayer {position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.6); z-index:40;}
.saveLayer .layerCont {position:absolute; left:0; top:12%; width:100%;}
.saveLayer .btnClose {position:absolute; left:25%; bottom:11%; width:50%; background:transparent;}
@media all and (min-width:480px){
	.evtNoti {padding:30px 4.6%;}
	.evtNoti h3 {margin:0 0 12px -15px;}
	.evtNoti h3 strong {font-size:21px; line-height:30px; padding-left:38px; background-size:29px 29px;}
	.evtNoti li {padding-left:15px; font-size:17px;}
	.evtNoti li:after {left:0; top:7px; width:6px;}
}
</style>
<script type="text/javascript">

$(function(){
	$(".selectDate li").click(function(){
		$(".selectDate li img").css({"opacity":"0"});
		$(this).find("img").css({"opacity":"1"});
	});
	$(".btnClose").click(function(){
		$("#saveLayer").fadeOut(200);
	});
});


function jsSubmit(){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2016-01-25" and left(currenttime,10)<"2016-01-30" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if subscriptcount>0 then %>
				alert("아이디당 한 번만 참여 가능 합니다.");
				return;
			<% else %>

				if (document.febbonus.SelUserDateVal.value=="")
				{
					alert("월급날을 선택해주세요.");
					return false;
				}
				var result;
				$.ajax({
					type:"GET",
					url:"/event/etc/doEventSubscript68844.asp",
					data: "selval="+document.febbonus.SelUserDateVal.value,
					dataType: "text",
					async:false,
					success : function(Data){
						result = jQuery.parseJSON(Data);
						if (result.ytcode=="05")
						{
							alert('잠시 후 다시 시도해 주세요.');
							return;
						}
						else if (result.ytcode=="04")
						{
							alert('한 개의 아이디당 한 번만 참여 가능 합니다.');
							return;
						}
						else if (result.ytcode=="03")
						{
							alert('이벤트 응모 기간이 아닙니다.');
							return;
						}
						else if (result.ytcode=="02")
						{
							alert('로그인을 해주세요.');
							return;
						}
						else if (result.ytcode=="01")
						{
							alert('잘못된 접속입니다.');
							return;
						}
						else if (result.ytcode=="00")
						{
							alert('정상적인 경로가 아닙니다.');
							return;
						}
						else if (result.ytcode=="11")
						{
							$("#saveLayer").fadeIn(200);
							window.parent.$('html,body').animate({scrollTop:$("#saveLayer").offset().top}, 800);
							return false;
						}
						else if (result.ytcode=="999")
						{
							alert('오류가 발생했습니다.');
							return false;
						}
					}
				});
			<% end if %>
		<% end if %>
	<% Else %>
		<% If isApp="1" or isApp="2" Then %>
			calllogin();
			return false;
		<% else %>
			jsevtlogin();
			return;
		<% end if %>	
	<% End IF %>
}

function setFebDateVal(v)
{
	document.febbonus.SelUserDateVal.value=v;
}

</script>
<div class="mEvt68844">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/tit_feb_bonus.png" alt="2월&amp;보너스" /></h2>
	<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/img_calendar_month.png" alt="FEBRUARY" /></h3>
	<!-- 날짜선택, 저장 -->
	<div class="selectDate">
		<ul>
			<li onclick="setFebDateVal('2016-02-01');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/txt_date_01.png" alt="1일" /></li>
			<li onclick="setFebDateVal('2016-02-02');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/txt_date_02.png" alt="2일" /></li>
			<li onclick="setFebDateVal('2016-02-03');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/txt_date_03.png" alt="3일" /></li>
			<li onclick="setFebDateVal('2016-02-04');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/txt_date_04.png" alt="4일" /></li>
			<li onclick="setFebDateVal('2016-02-05');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/txt_date_05.png" alt="5일" /></li>
			<li onclick="setFebDateVal('2016-02-06');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/txt_date_06.png" alt="6일" /></li>
			<li onclick="setFebDateVal('2016-02-07');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/txt_date_07.png" alt="7일" /></li>
			<li onclick="setFebDateVal('2016-02-08');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/txt_date_08.png" alt="8일" /></li>
			<li onclick="setFebDateVal('2016-02-09');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/txt_date_09.png" alt="9일" /></li>
			<li onclick="setFebDateVal('2016-02-10');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/txt_date_10.png" alt="10일" /></li>
			<li onclick="setFebDateVal('2016-02-11');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/txt_date_11.png" alt="11일" /></li>
			<li onclick="setFebDateVal('2016-02-12');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/txt_date_12.png" alt="12일" /></li>
			<li onclick="setFebDateVal('2016-02-13');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/txt_date_13.png" alt="13일" /></li>
			<li onclick="setFebDateVal('2016-02-14');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/txt_date_14.png" alt="14일" /></li>
			<li onclick="setFebDateVal('2016-02-15');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/txt_date_15.png" alt="15일" /></li>
			<li onclick="setFebDateVal('2016-02-16');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/txt_date_16.png" alt="16일" /></li>
			<li onclick="setFebDateVal('2016-02-17');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/txt_date_17.png" alt="17일" /></li>
			<li onclick="setFebDateVal('2016-02-18');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/txt_date_18.png" alt="18일" /></li>
			<li onclick="setFebDateVal('2016-02-19');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/txt_date_19.png" alt="19일" /></li>
			<li onclick="setFebDateVal('2016-02-20');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/txt_date_20.png" alt="20일" /></li>
			<li onclick="setFebDateVal('2016-02-21');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/txt_date_21.png" alt="21일" /></li>
			<li onclick="setFebDateVal('2016-02-22');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/txt_date_22.png" alt="22일" /></li>
			<li onclick="setFebDateVal('2016-02-23');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/txt_date_23.png" alt="23일" /></li>
			<li onclick="setFebDateVal('2016-02-24');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/txt_date_24.png" alt="24일" /></li>
			<li onclick="setFebDateVal('2016-02-25');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/txt_date_25.png" alt="25일" /></li>
			<li onclick="setFebDateVal('2016-02-26');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/txt_date_26.png" alt="26일" /></li>
			<li onclick="setFebDateVal('2016-02-27');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/txt_date_27.png" alt="27일" /></li>
			<li onclick="setFebDateVal('2016-02-28');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/txt_date_28.png" alt="28일" /></li>
			<li onclick="setFebDateVal('2016-02-29');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/txt_date_29.png" alt="29일" /></li>
		</ul>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/img_calendar_date.png" alt="" /></div>
	</div>
	<div class="saveDate">
		<button class="btnSave" onclick="jsSubmit();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/btn_save.png" alt="월급날 저장하기" /></button>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/img_calendar_btm.png" alt="" /></div>
	</div>
	<!--// 날짜선택, 저장 -->

	<!-- 저장완료 레이어 -->
	<div id="saveLayer" class="saveLayer" style="display:none;">
		<div class="layerCont">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/txt_save.png" alt="월급날 저장하기" /></p>
			<button class="btnClose"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68844/m/btn_comfirm.png" alt="확인" /></button>
		</div>
	</div>
	<!--// 저장완료 레이어 -->

	<div class="evtNoti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<li>본 이벤트의 보너스는 추첨을 통해 당첨되신 분들에게 저장해주신 월급날에 마일리지로 지급될 예정입니다.</li>
			<li>당첨자 안내는 2016년 2월 1일에 공지사항을 통해 진행됩니다.</li>
		</ul>
	</div>
</div>
<form name="febbonus" id="febbonus" onSubmit="return false;" method="post">
	<input type="hidden" name="SelUserDateVal" id="SelUserDateVal" value="">
</form>
<!-- #include virtual="/lib/db/dbclose.asp" -->