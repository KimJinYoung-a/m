<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : [오프라인 이벤트] 할인 나우 
' History : 2016-03-15 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" --> 

<%
Dim eCode , userid, strSql , usecp , getcp

	userid = GetEncLoginUserID()

IF application("Svr_Info") = "Dev" THEN
	eCode   =  66065
Else
	eCode   =  69703
End If

If IsUserLoginOK Then
	'// 출석 여부
	strSql = "select sub_opt1, sub_opt2"
	strSql = strSql & " from db_event.dbo.tbl_event_subscript "
	strSql = strSql & "	where userid = '"& userid &"' and evt_code = '"& eCode &"' " 
	rsget.Open strSql,dbget,1
	IF Not rsget.Eof Then
		getcp = rsget("sub_opt1")	''//쿠폰 발급 내역
		usecp = rsget("sub_opt2")		'// 쿠폰 사용 내역
	End IF
	rsget.close()
End If 
%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

img {vertical-align:top;}

.mEvt69703 {overflow:hidden;}
.mEvt69703 button {background-color:transparent;}

.topic {position:relative;}
.topic h2 {position:absolute; top:17.2%; left:0; width:100%;}
.topic h2 {animation-name:lightSpeedIn; animation-timing-function:ease-out; animation-duration:2s; animation-fill-mode:both; animation-iteration-count:1;}
.topic h2 {-webkit-animation-name:lightSpeedIn; -webkit-animation-timing-function:ease-out; -webkit-animation-duration:2s; -webkit-animation-fill-mode:both; -webkit-animation-iteration-count:1;}
@keyframes lightSpeedIn {
	0% {transform:translateX(20%); opacity:0;}
	60% {transform:translateX(-10%); opacity:1;}
	80% {transform:translateX(10%); opacity:1;}
	100% {transform:translateX(0%); opacity:1;}
}
@-webkit-keyframes lightSpeedIn {
	0% {-webkit-transform:translateX(20%); opacity:0;}
	60% {-webkit-transform:translateX(-10%); opacity:1;}
	80% {-webkit-transform:translateX(10%); opacity:1;}
	100% {-webkit-transform:translateX(0%); opacity:1;}
}

.coupon {padding-bottom:10%; background-color:#ffe461;}
.coupon button, .coupon .btnGet {display:block; width:84.375%; margin:0 auto;}

.staffOnly .btnGet {margin-top:7%;}
.staffOnly p {background-color:#302f2f;}
.staffOnly p img {animation-name:flash; animation-timing-function:ease-out; animation-duration:3s; animation-fill-mode:both; animation-iteration-count:4;}
.staffOnly p img {-webkit-animation-name:flash; -webkit-animation-timing-function:ease-out; -webkit-animation-duration:3s; -webkit-animation-fill-mode:both; -webkit-animation-iteration-count:4;}
@keyframes flash {
	0%, 50%, 100% {opacity:1;}
	25%, 75% {opacity:0;}
}
@-webkit-keyframes flash {
	0%, 50%, 100% {opacity:1;}
	25%, 75% {opacity:0;}
}
.btnDone {cursor:default;}

.lyThanku {display:none; position:absolute; top:12%; left:50%; z-index:60; width:94.06%; margin-left:-47.03%;}
.lyThanku p {padding-top:10%;}
.lyThanku button, .lyThanku a {display:block; /*background-color:#000; opacity:0.3;*/ text-indent:-9999em;}
.lyThanku .btnApp {position:absolute; bottom:14%; left:50%; width:86%; height:12%; margin-left:-43%;}
.lyThanku .btnClose {position:absolute; top:10%; right:2%; width:12%; height:9%;}

#mask {display:none; position:absolute; top:0; left:0; z-index:55; width:100%; height:100%; background:rgba(0,0,0,.6);}

.noti {padding:7% 0 8%; background:#c6ae39 url(http://webimage.10x10.co.kr/eventIMG/2016/69703/bg_pattern.png) repeat-y 50% 0; background-size:100% auto;}
.noti ul {padding:5% 5% 0;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#fff; font-size:1.1rem; line-height:1.5em;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.5rem; left:0; width:0.4rem; height:0.1rem; background-color:#fff;}
</style>
<script type="text/javascript">
$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt69703").offset().top}, 0);

	$("#lyThanku .btnClose, #mask").click(function(){
		location.reload();
	});
});

function jscpcom(md){
<% If IsUserLoginOK() Then %>
	<% If date() > "2016-12-31"  Then %>
		alert('이벤트 기간이 아닙니다.');
		return;
	<% else %>
		if (md=="useoffcoupon"){
			if(confirm("이 버튼은 매장 직원이 결제 시\n확인하는 버튼입니다.\n확인 후에는 할인이 적용 되지 않습니다.\n진행하시겠습니까?")){
				var result;
				$.ajax({
					type:"GET",
					url:"/event/etc/doeventsubscript/doEventSubscript69703.asp",
					data: "mode="+md,
					dataType: "text",
					async:false,
					cache:false,
					success : function(Data){
						result = jQuery.parseJSON(Data);
						if (result.resultcode=="22")
						{
							alert('이미 쿠폰을 발급 받으셨습니다.');
							location.reload();
							return;
						}
						else if (result.resultcode=="44")
						{
							alert('로그인이 필요한 서비스 입니다.');
							parent.jsevtlogin();
							return;
						}
						else if (result.resultcode=="88")
						{
							alert('이벤트 기간이 아닙니다.');
							return;
						}
						else if (result.resultcode=="33")
						{
							alert('이미 쿠폰을 사용 하셨습니다.');
							location.reload();
							return;
						}
						else if (result.resultcode=="66")
						{
							alert('잘못된 접속 입니다.');
							return;
						}
						else if (result.resultcode=="11")
						{
							alert('쿠폰을 발급 받으셨습니다.\n\n금일 매장에서 꼭 사용하세요');
							location.reload();
							return;
						}
						else if (result.resultcode=="77")
						{
							$("#lyThanku").show();
							$("#mask").show();
							var val = $("#lyThanku").offset();
							$("html,body").animate({scrollTop:val.top},100);
						}
					}
				});
			}
		}else{
			var result;
			$.ajax({
				type:"GET",
				url:"/event/etc/doeventsubscript/doEventSubscript69703.asp",
				data: "mode="+md,
				dataType: "text",
				async:false,
				cache:false,
				success : function(Data){
					result = jQuery.parseJSON(Data);
					if (result.resultcode=="22")
					{
						alert('이미 쿠폰을 발급 받으셨습니다.');
						location.reload();
						return;
					}
					else if (result.resultcode=="44")
					{
						alert('로그인이 필요한 서비스 입니다.');
						parent.jsevtlogin();
						return;
					}
					else if (result.resultcode=="88")
					{
						alert('이벤트 기간이 아닙니다.');
						return;
					}
					else if (result.resultcode=="33")
					{
						alert('이미 쿠폰을 사용 하셨습니다.');
						location.reload();
						return;
					}
					else if (result.resultcode=="66")
					{
						alert('잘못된 접속 입니다.');
						return;
					}
					else if (result.resultcode=="11")
					{
						alert('쿠폰을 발급 받으셨습니다.\n\n금일 매장에서 꼭 사용하세요');
						location.reload();
						return;
					}
					else if (result.resultcode=="77")
					{
						$("#lyThanku").show();
						$("#mask").show();
						var val = $("#lyThanku").offset();
						$("html,body").animate({scrollTop:val.top},100);
					}
				}
			});
		}
	<% end if %>
<% Else %>
	parent.jsevtlogin();
	return;
<% End IF %>
}
</script>
	<div class="mEvt69703">
		<article>
			<div class="topic">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/69703/tit_discount_now_v1.png" alt="쿠폰 다운받고 매장에서 할인 받자 할인나우" /></h2>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69703/txt_offline.png" alt="지금 매장을 방문하신 고객님께 로그인만 하시면 즉시 할인이 가능한 쿠폰을 드립니다." /></p>
			</div>

			<div class="coupon">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69703/img_coupon.png" alt="만원 이상 구매시 천원 할인 쿠폰 사용기간은 발급 당일이며 매장에서 즉시 할인 가능합니다." /></p>

				<% If IsUserLoginOK() Then %>
					<% if usecp = "1" then %>
						<% ''//for dev msg : 쿠폰 사용완료 후 %>
						<button type="button" class="btnDone"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69703/btn_done.png" alt="구매 완료" /></button>
					<% else %>
						<% if getcp = "1" then %>
							<%''// for dev msg :쿠폰받급받기 후 %>
							<div class="staffOnly">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69703/txt_staff_only.png" alt="이 버튼은 매장직원이 누르는 버튼입니다. 계산 시 직원에게 이 화면을 보여주세요." /></p>
								<% ''//for dev msg : id="btnGet"로 레이어팝업 스크립트 제어했어요. %>
								<a href="" id="btnGet" onclick="jscpcom('useoffcoupon'); return false;" class="btnGet"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69703/btn_get.png" alt="구매 완료하기" /></a>
							</div>
						<% else %>
							<% ''// for dev msg : 쿠폰받급받기 전 %>
							<button type="button" onclick="jscpcom('getoffcoupon'); return false;" class="btnDown"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69703/btn_down.png" alt="쿠폰받급받기" /></button>											
						<% end if %>
					<% end if %>
				<% else %>
					<% ''// for dev msg : 쿠폰받급받기 전 %>
					<button type="button" onclick="jscpcom('getoffcoupon'); return false;" class="btnDown"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69703/btn_down.png" alt="쿠폰받급받기" /></button>				
				<% end if %>
			</div>

			<%''// for dev msg : 구매 완료하기 버튼 클릭시 나오는 팝업 %>
			<div id="lyThanku" class="lyThanku">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69703/txt_thank_u.png" alt="고객님 구매해주셔서 감사합니다 지금 텐바이텐 앱을 설치하시면 3천원 할인쿠폰도 드립니다. 더 많은 이벤트와 다양한 할인혜택을 앱에서 만나보세요!" /></p>
				<%''// for dev msg : 앱 다운로드 페이지로 링크 %>
				<a href="/event/appdown/" class="btnApp">앱 설치하러 가기</a>
				<button type="button" class="btnClose">닫기</button>
			</div>

			<section class="noti">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/69703/tit_noti.png" alt="이벤트 유의사항" /></h3>
				<ul>
					<li>본 이벤트는 로그인 후에 참여가 가능합니다.</li>
					<li>ID 당 1회만 구매가 가능합니다.</li>
					<li>발급받은 쿠폰은 매장에서 발급 당일 사용 가능합니다.</li>
				</ul>
			</section>

			<div id="mask"></div>
		</article>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->