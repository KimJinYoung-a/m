<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 말할 수 없는 비밀번호 
' History : 2016-11-21 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
	Dim vUserID, eCode, cMil, vMileValue, vMileArr
	Dim sKey , sDays , totalbonuscouponcount , couponidx

	sDays = Left(Now(), 10)

'sDays="2015-06-30"

	vUserID = GetEncLoginUserID
	IF application("Svr_Info") = "Dev" THEN
		eCode = "66241"
		couponidx = "2724"
	Else
		eCode = "74504"
		couponidx = "931"
	End If

	Dim strSql , totcnt
	'// 응모여부
	strSql = "select count(*) from db_event.dbo.tbl_event_subscript where userid = '"& vUserID &"' and evt_code = '"& ecode &"' " 
	rsget.Open strSql,dbget,1
	IF Not rsget.Eof Then
		totcnt = rsget(0)
	End IF
	rsget.close()

	'//오늘의 시크릿 넘버
	Select Case sDays
		Case "2016-11-22"
			sKey = "당신의 비밀번호는 [1122] 입니다."
		Case Else
			sKey = "이벤트 기간이 아닙니다."
	End Select

	totalbonuscouponcount = getbonuscoupontotalcount(couponidx, "", "", Date())
%>

<style type="text/css">
button {outline:none; background-color:transparent;}
.secretNumber {position:relative;}
.secretNumber .inpNum {position:absolute; left:50%; top:37%; width:60%; height:3.5rem; margin-left:-30%; color:#000; text-align:center; letter-spacing:1rem; font:bold 2.3rem/3.7rem arial; border:0;}
.secretNumber .inpNum::-webkit-input-placeholder {color:#aaa; text-align:center; letter-spacing:1rem; font:bold 2.3rem/4.5rem arial;}
.secretNumber .btnEnter {position:absolute; left:50%; bottom:18%; width:50%; margin-left:-25%;}
.secretNumber .soldout {position:absolute; left:0; top:0; width:100%;}
.forget {cursor:pointer;}
.evtNoti {color:#fff; padding:2rem 3.43%;}
.evtNoti h3 {padding:0 0 1.4rem 1rem; color:#ff860f;}
.evtNoti h3 strong {display:inline-block; font-size:1.4rem; line-height:1; padding-bottom:0.2rem; border-bottom:0.2rem solid #ff860f;}
.evtNoti li {position:relative; padding:0 0 0.5rem 1rem; font-size:1.1rem; line-height:1; color:#444;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.3rem; z-index:30; width:0.3rem; height:0.3rem; background:#ff860f; border-radius:50%;}
.couponLayer {display:none; position:absolute; left:0; top:0; z-index:50; width:100%; height:100%; background:rgba(0,0,0,.7);}
.couponLayer .layerCont {position:absolute; left:4%; top:24%; width:92%;}
.couponLayer .layerCont .btnConfirm {position:absolute; left:24%; bottom:7.2%; width:52%; z-index:100;}
</style>
<script type="text/javascript">

$(function(){
	$('.btnConfirm').click(function(){
		$('.couponLayer').fadeOut();
	});
});

function checkform(){
	var frm = document.frmcom;
	<% If vUserID = "" Then %>
		calllogin();
		return false;
	<% End If %>

	if(!frm.secretkey.value||frm.secretkey.value=="****"){
		alert("비밀번호를 입력해주세요.");
		frm.secretkey.value="";
		frm.secretkey.focus();
		return false;
	}

	<% If vUserID <> "" Then %>
		<% If totcnt > 1 then %>
			alert("이미 다운받으셨습니다.");
		<% Else %>
			var result;
			$.ajax({
				type:"GET",
				url:"/apps/appcom/wish/web2014/event/etc/doEventSubscript74504.asp",
				data: $("#frmcom").serialize(),
				dataType: "text",
				async:false,
				cache:true,
				success : function(Data){
					result = jQuery.parseJSON(Data);
					if (result.resultcode=="00")
					{
						alert("앗, 비밀 쿠폰이 모두 소진되었어요!");
						frm.secretkey.value="";
						return;
					}
					else if (result.resultcode=="11")
					{
						alert('이미 다운받으셨습니다.');
						frm.secretkey.value="";
						return;
					}
					else if (result.resultcode=="22")
					{
						alert('이벤트는 ID당 1회만 참여할 수 있습니다.');
						frm.secretkey.value="";
						return;
					}
					else if (result.resultcode=="33")
					{
						alert('비밀번호를 확인 해주세요.');
						frm.secretkey.value="";
						return;
					}
					else if (result.resultcode=="44")
					{
						alert('잘못된 접근입니다');
						frm.secretkey.value="";
						return;
					}
					else if (result.resultcode=="99")
					{
						$('.couponLayer').fadeIn();
						window.parent.$('html,body').animate({scrollTop:150}, 300);
						frm.secretkey.value="";
						return;
					}
				}
			});
		 <% End If %>
	<% End If %>
}

function maxLengthCheck(object)
{
if (object.value.length > object.maxLength)
  object.value = object.value.slice(0, object.maxLength)
}

</script>


<%' 말할 수 없는 비밀번호 %>
<div class="mEvt74504">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/74504/m/tit_secret.png" alt="말할 수 없는 비밀번호 - 비밀번호를 입력한 분들께 놀라운 할인을!" /></h2>
	<div class="secretNumber">
		<form name="frmcom" id="frmcom" method="get" style="margin:0px;">
		<input type="hidden" name="mode" value="coupon"/>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/74504/m/txt_number.png" alt="SECRET NUMBER" /></p>
		<div class="enterNum">
			<input type="number" class="inpNum" placeholder="****" name="secretkey" oninput="maxLengthCheck(this)" maxlength = "4" autocomplete="off"  />
			<button type="button" class="btnEnter" onclick="checkform(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74504/m/btn_enter.png" alt="비밀번호 입력하기" /></button>
		</div>
		</form>
		<% If totalbonuscouponcount >= 20000 Then %>
			<div class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74504/m/txt_soldout.png" alt="앗, 비밀 쿠폰이 모두 소진되었어요!" /></div>
		<% End If %>
	</div>
	<%' 쿠폰발급 레이어 %>
	<div class="couponLayer">
		<div class="layerCont">
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/74504/m/img_coupon.png" alt="쿠폰 발급 완료!" /></div>
			<button class="btnConfirm"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74504/m/btn_confirm.png" alt="확인" /></button>
		</div>
	</div>
	<%'// 쿠폰발급 레이어 %>
	<div class="forget" onclick="alert('<%=sKey%>')"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74504/m/btn_forget.png" alt="혹시 비밀번호를 잊으셨나요?" /></div>
	<div class="evtNoti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<li>본 이벤트는 로그인 후에 참여가 가능합니다.</li>
			<li>비밀쿠폰은 한정수량으로 조기 소진될 수도 있습니다.</li>
			<li>ID 당 1회만 쿠폰 다운이 가능합니다.</li>
			<li>지급된 쿠폰은 11/22(화) 23시59분 59초에 종료됩니다.</li> 
			<li>다른 쿠폰과 함께 사용할 수 없습니다.</li>
			<li>이벤트는 조기 마감될 수 있습니다.</li>
		</ul>
	</div>
</div>
<%'// 말할 수 없는 비밀번호 %>


<!-- #include virtual="/lib/db/dbclose.asp" -->