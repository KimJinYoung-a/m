<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 소품전 메인
' History : 2017-03-31 이종화
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim nowdate , eCode
nowdate = now()

IF application("Svr_Info") = "Dev" THEN
	eCode = "66298"
Else
	eCode = "77059"
End If

Dim vCouponMaxCount , vIsEnd , vState , vQuery , vNowTime
	vCouponMaxCount = 10 '// 일별 한정수량

'####### 쿠폰
' vState = "0" ### 이벤트 종료됨.
' vState = "1" ### 쿠폰다운가능.
' vState = "2" ### 다운 가능 시간 아님.
' vState = "3" ### 이미 받음.
' vState = "4" ### 한정수량 오버됨.
' vState = "5" ### 로그인안됨.
If IsUserLoginOK() Then
	If Now() > #04/17/2017 23:59:59# Then
		vIsEnd = True
		vState = "0"	'### 이벤트 종료됨. 0
	Else
		vIsEnd = False
	End If
	
	If Not vIsEnd Then	'### 이벤트 종료안됨.
		vQuery = "select convert(int,replace(convert(char(8),getdate(),8),':',''))"
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
		vNowTime = rsget(0)	'### DB시간받아옴.
		rsget.close

		'If vNowTime > 100000 AND vNowTime < 235959 Then	'### 10시에서 24시 사이 다운가능. 1
		If vNowTime > 100000 AND vNowTime < 235959 Then	'### 10시에서 24시 사이 다운가능. 1
			vQuery = "select count(sub_idx) from [db_event].[dbo].[tbl_event_subscript] where userid = '" & getencLoginUserid() & "' and evt_code = '77059'"
			rsget.CursorLocation = adUseClient
			rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
			If rsget(0) > 0 Then	' ### 이미 받음. 3
				vState = "3"
			End IF
			rsget.close
			
			If vState <> "3" Then	'### 한정수량 계산
				vQuery = "select count(sub_idx) from [db_event].[dbo].[tbl_event_subscript] where evt_code = '77059' and sub_opt1 = convert(varchar(10),getdate(),120)"
				rsget.CursorLocation = adUseClient
				rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
				If rsget(0) >= vCouponMaxCount Then	' 한정수량 10 오버됨. 4
					vState = "4"
				Else
					vState = "1"	'### 쿠폰다운가능.
				End IF
				rsget.close
			End IF
		Else	' ### 다운 가능 시간 아님. 2
			vState = "2"
		End IF
	End IF
Else
	vState = "5"	'### 로그인안됨.
End If	
%>
<!-- #include virtual="/event/props/sns.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.content {padding-bottom:0;}
.sopum {position:relative;}
.sopum button {background-color:transparent;}
.sopum .bnr .coupon {position:absolute; top:11%; left:50%; width:75%; margin-left:-37.5%;}
.sopum .bnr li {position:relative;}
.sopum .bnr .ani {position:absolute; width:50%;}
.sopum .bnr .land .ani {top:0.6%; right:0;}
.sopum .bnr .friend .ani {top:11.51%; left:0;}
.sopum .bnr .treasure .ani {top:8.75%; right:0;}
.sopum .bnr .gift .ani {top:8.64%; left:0;}
.sopum .bnr .sticker .ani {top:6.93%; right:0;}

.sns {position:relative;}
.sns ul {width:33.75%; position:absolute; top:31%; right:3.43%;}

.lyContent {display:none; position:absolute; top:0; left:0; z-index:25; width:100%; padding-top:20%;}
.lyContent .btnClose {position:absolute; top:15%; right:14.5%; width:12.18%;}
.lyContent .inner {position:absolute; top:20%; left:50%; width:47.65%; margin-left:-23.82%;}
.lyContent .inner div {position:relative; padding-bottom:32%;}
.lyContent .inner button {position:absolute; bottom:20%; left:0; width:100%; height:80%; color:transparent;}
.lyContent .time {height:86%;}
.lyContent .time div {position:absolute; left:0;}
.lyContent .time div:last-child {top:3%;}
.lyContent .time div:first-child {bottom:5%;}
.lyContent .btnClose img {transition:transform .7s ease; -webkit-transition:transform .7s ease;}
.lyContent .btnClose:active img {transform:rotate(-180deg); -webkit-transform:rotate(-180deg);}
#dimmed {display:none; position:absolute; top:0; left:0; z-index:20; width:100%; height:100%; background:rgba(0,0,0, 0.8);}

/* css3 animation */
.bounce {animation:bounce 1.2s 10 alternate; -webkit-animation:bounce 1.2s 10 alternate;}
@keyframes bounce {
	0% {transform:translateY(30px);}
	100% {transform:translateY(0);}
}
@-webkit-keyframes bounce {
	0% {-webkit-transform:translateY(30px);}
	100% {-webkit-transform:translateY(0);}
}
</style>
<script type="text/javascript">
$(function(){
	/* layer */
	$(".bnr .coupon a").click(function(){
		$("#lyCoupon").show();
		$("#dimmed").show();
		$("#dimmed").show();
	});

	$("#lyCoupon .btnClose, #dimmed").click(function(){
		$("#lyCoupon").hide();
		$("#dimmed").fadeOut();
	});

	window.$('html,body').animate({scrollTop:$("#toparticle").offset().top}, 0);
});

function propsCoupon(stype,idx){
	<% If IsUserLoginOK() Then %>
		<% If not( left(nowdate,10)>="2017-04-03" and left(nowdate,10)<"2017-04-18" ) Then %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% else %>
			var str = $.ajax({
				type: "POST",
				url: "/event/props/coupon_process.asp",
				data: "mode=cpok&stype="+stype+"&idx="+idx,
				dataType: "text",
				async: false
			}).responseText;
			var str1 = str.split("||")
			if (str1[0] == "11"){
				alert('쿠폰이 발급 되었습니다.\n금일 자정 까지 사용 하실 수 있습니다.');
				$("#lyCoupon").hide();
				$("#dimmed").fadeOut();
				return false;
			}else if (str1[0] == "12"){
				alert('기간이 종료되었거나 유효하지 않은 쿠폰입니다.');
				return false;
			}else if (str1[0] == "13"){
				alert('이미 다운로드 받으셨습니다.');
				return false;
			}else if (str1[0] == "14"){
				alert('오늘의 한정수량이 모두 소진 되었습니다.');
				return false;
			}else if (str1[0] == "03"){
				alert('이벤트 응모 기간이 아닙니다.');
				return false;
			}else if (str1[0] == "02"){
				alert('로그인을 해주세요.');
				return false;
			}else if (str1[0] == "01"){
				alert('잘못된 접속입니다.');
				return false;
			}else if (str1[0] == "00"){
				alert('정상적인 경로가 아닙니다.');
				return false;
			}else{
				alert('오류가 발생했습니다.');
				return false;
			}
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End IF %>
}
</script>
<div class="sopum" id="toparticle">
	<div class="bnr">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77059/m/tit_sopum_v1.gif" alt="여러분의 일상을 채워드립니다! 소품전" /></h2>
		<img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77059/m/img_sopum.jpg" alt="" />
		<ul>
			<li class="coupon bounce">
				<a href="#lyCoupon">
					<img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77059/m/img_sopum_coupon.png" alt="쿠폰 최대 30% 타임쿠폰 매일 아침 10시 쿠폰 다운받기" />
				</a>
			</li>
			<li class="land">
				<a href="<%=chkiif(isapp="1","/apps/appcom/wish/web2014/event/","/event/")%>eventmain.asp?eventid=77060">
					<img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77059/m/img_sopum_land.png" alt="웰컴투 소품랜드 15개 테마별 상품을 매일매일 만나보세요!" />
					<span class="ani"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77059/m/img_ani_sopumland.gif" alt="" /></span>
				</a>
			</li>
			<li class="friend">
				<a href="<%=chkiif(isapp="1","/apps/appcom/wish/web2014/event/","/event/")%>eventmain.asp?eventid=77061">
					<img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77059/m/img_sopum_friend.png" alt="내 친구를 소개합니다 하루에 한번 카드를 확인하면 피규어 친구가 찾아갑니다!" />
					<span class="ani"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77059/m/img_ani_friend.gif" alt="" /></span>
				</a>
			</li>
			<li class="treasure">
				<a href="<%=chkiif(isapp="1","/apps/appcom/wish/web2014/event/","/event/")%>eventmain.asp?eventid=77062">
					<img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77059/m/img_sopum_treasure.png" alt="숨은 보물 찾기 숨어있는 보물을 찾고 기프트카드 1만원권에 도전하세요!" />
					<span class="ani"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77059/m/img_ani_treasure.gif" alt="" /></span>
				</a>
			</li>
			<li class="gift">
				<a href="<%=chkiif(isapp="1","/apps/appcom/wish/web2014/event/","/event/")%>eventmain.asp?eventid=77063">
					<img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77059/m/img_sopum_gift.png" alt="완전 소중한 사은품 선착순 한정수량! 쇼핑하고 사은품 받으세요" />
					<span class="ani"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77059/m/img_ani_gift.gif" alt="" /></span>
				</a>
			</li>
			<li class="sticker">
				<a href="<%=chkiif(isapp="1","/apps/appcom/wish/web2014/event/","/event/")%>eventmain.asp?eventid=77064">
					<img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77059/m/img_sopum_sticker.png" alt="반짝반짝 스티커 일상 속에 반짝반짝 스티커를 붙여 주세요!" />
					<span class="ani"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77059/m/img_ani_sticker.gif" alt="" /></span>
				</a>
			</li>
		</ul>
	</div>

	<%'!-- for dev msg : 쿠폰 레이어 팝업 --%>
	<div id="lyCoupon" class="lyContent">
		<img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77059/m/bg_layer.png" alt="" />
		<%'!-- for dev msg : 아침 10시에 클래스명 time 붙여주세요! 타임쿠폰 솔드아웃 되면 빼주세요! --%>
		<div class="inner">
			<div>
				<%'!-- for dev msg : 발급 받기 후 _done.png 붙여주세요 <button type="button">받급받기</button>은 숨겨주세요  --%>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77059/m/img_coupon_01.png?v=1" alt="다양한 할인이 가득한 상품 쿠폰 최대 30%" /></p>
				<button type="button" onclick="propsCoupon('prd,prd,prd,prd,prd','12456,12457,12458,12459,12460');">받급받기</button>
			</div>
			<div>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77059/m/img_coupon_02<% If vIsEnd Or vState = "2" Or vState = "3" Or vState = "4" Then %>_done<% End If %>.png" alt="1일 한정수량 10장 매일 아침 10시에 찾아오는 타임 쿠폰 (2만원 이상 구매 시 만원 할인 사용기한 금일 자정까지)" /></p>
				<% If vIsEnd Or vState = "2" Or vState = "3" Or vState = "4" Then %>
					<% If vState = "2" Then %>
				<button type="button" onclick="alert('오전 10시부터 다운로드 가능합니다.');">발급받기</button>
					<% ElseIf vState = "3" Then %>
				<button type="button" onclick="alert('이미 다운로드 하셨습니다.');">발급받기</button>
					<% ElseIf vState = "4" Then %>
				<button type="button" onclick="alert('오늘의 한정수량이 모두 소진 되었습니다.');">발급받기</button>
					<% Else %>
				<button type="button" onclick="alert('이벤트 기간이 아닙니다.');">발급받기</button>
					<% End If %>
				<% Else %>
				<button type="button" onclick="propsCoupon('evtseltoday','<%=chkiif(application("Svr_Info") = "Dev","2840","968")%>');">발급받기</button>
				<% End If %>
			</div>
		</div>
		<button type="button" class="btnClose"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77059/m/btn_close.png" alt="확인" /></button>
	</div>

	<p class="festival"><img src="http://webimage.10x10.co.kr/eventIMG/2017/sopum/77059//m/txt_sopum_festival.gif" alt="Sopum Festival Characters Illustration by 더푸리빌리지" /></p>

	<%'!-- for dev msg : sns --%>
	<div class="sns"><%=snsHtml%></div>
	<div id="dimmed"></div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->				