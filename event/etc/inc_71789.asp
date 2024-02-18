<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 마이펫의 이중생활
' History : 2016.07.13 김진영 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
Dim eCode, vUserID
vUserID		= GetEncLoginUserID

IF application("Svr_Info") = "Dev" THEN
	eCode = "66170"
Else
	eCode = "71789"
end if
%>
<style type="text/css">
img {vertical-align:top;}

.mypet {background-color:#f5f6f8;}
.mypet button {background-color:transparent;}

.pets {position:relative}
.pets p {position:absolute; top:5.72%; left:50%; width:78.75%; margin-left:-39.375%;}
.pets .btnEnter,
.pets .btnApp {position:absolute; top:63.48%; left:50%; width:48.28%; margin-left:-24.14%;}
.pets .btnApp img,
.pets .btnEnter img {
	animation-name:pulse; animation-duration:1.2s; animation-delay:2s; animation-iteration-count:3; animation-delay:3s;
	-webkit-animation-name:pulse; -webkit-animation-duration:1s; -webkit-animation-iteration-count:3; -webkit-animation-delay:3s;
}
@keyframes pulse {
	0% {transform:scale(1);}
	50% {transform:scale(0.8);}
	100% {transform:scale(1);}
}
@-webkit-keyframes pulse {
	0% {-webkit-transform:scale(1);}
	50% {-webkit-transform:scale(0.8);}
	100% {-webkit-transform:scale(1);}
}
.pets ul li {position:absolute; width:21%; height:20%;}
.pets ul li button {width:100%; height:100%; /*background-color:rgba(0,0,0, 0.5);*/ color:transparent;}
.pets ul li.pops {top:39.5%; left:0;}
.pets ul li.gidget {top:40%; left:25.5%;}
.pets ul li.max {top:30%; left:46%; width:14%; height:30%;}
.pets ul li.snowball {top:36%; left:61%; width:14.5%; height:25%;}
.pets ul li.duke {top:34%; right:0; width:24.5%; height:27%;}
.pets ul li.mel {top:61.2%; right:0; width:27%; height:30%;}
.pets ul li.chloe {top:60%; left:0; width:27%; height:30%;}
.pets .bg1 {position:absolute; top:0; left:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/71789/m/img_pops.jpg) no-repeat 50%; background-size:100% auto;}
.pets .bg2 {position:absolute; top:0; left:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/71789/m/img_gidget.jpg) no-repeat 50%; background-size:100% auto;}
.pets .bg3 {position:absolute; top:0; left:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/71789/m/img_max.jpg) no-repeat 50%; background-size:100% auto;}
.pets .bg4 {position:absolute; top:0; left:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/71789/m/img_snowball.jpg) no-repeat 50%; background-size:100% auto;}
.pets .bg5 {position:absolute; top:0; left:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/71789/m/img_duke.jpg) no-repeat 50%; background-size:100% auto;}
.pets .bg6 {position:absolute; top:0; left:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/71789/m/img_mel.jpg) no-repeat 50%; background-size:100% auto;}
.pets .bg7 {position:absolute; top:0; left:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/71789/m/img_chloe.jpg) no-repeat 50%; background-size:100% auto;}

.lyView {display:none; position:absolute; top:9%; left:50%; z-index:30; width:73.6%; margin-left:-36.8%;}
.lyView .btnClose {position:absolute; top:0.7%; right:2%; width:16.13%;}
#dimmed {display:none; position:absolute; top:0; left:0; z-index:20; width:100%; height:100%; background:rgba(0,0,0,.6);}

.movie {position:relative;}
.movie .videoWrap {position:absolute; top:23%; left:50%; width:86.8%; margin-left:-43.4%;}
.video {overflow:hidden; position:relative; width:100%; height:0; padding-bottom:62.45%; background:#000;}
.video iframe {position:absolute; top:0; left:0; width:100%; height:100%}

.bonus {position:relative;}
.bonus a {position:absolute; top:43.35%; left:0; width:32.812%;}

.noti {padding:7% 7% 1%;}
.noti h3 {color:#59afde; font-size:1.2rem; font-weight:bold;}
.noti h3 span {border-bottom:2px solid #59afde;}
.noti ul {margin-top:1rem;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:0.9rem; color:#717171; font-size:1rem; line-height:1.5em;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.4rem; left:0; width:4px; height:4px; border-radius:50%; border:1px solid #5db1df;}

.bounce {
	animation-name:bounce; animation-iteration-count:3; animation-duration:1s; 
	-webkit-animation-name:bounce; -webkit-animation-iteration-count:3; -webkit-animation-duration:1s; 
}
@keyframes bounce {
	from, to{margin-top:5px; animation-timing-function:ease;}
	50% {margin-top:0px; animation-timing-function:ease;}
}
@-webkit-keyframes bounce {
	from, to{margin-top:5px; -webkit-animation-timing-function:ease;}
	50% {margin-top:0px; -webkit-animation-timing-function:ease;}
}
</style>
<script type="text/javascript">
function gotoDownloadapp(){
	parent.top.location.href='http://m.10x10.co.kr/apps/link/?9520160713';
	return false;
};
function checkform(){
	<% If vUserID = "" Then %>
		if ("<%=IsUserLoginOK%>"=="False") {
			<% If isApp = 1 Then %>
				parent.calllogin();
				return false;
			<% End If %>
			return false;
		}
	<% End If %>
	<% If vUserID <> "" Then %>
		// 오픈시 바꿔야됨
		<% If Now() >= #07/14/2016 10:00:00# And now() < #07/28/2016 00:00:00# Then %>
			if ( $("#imypet").val() == '' ){
				alert('마이펫을 먼저 선택해주세요!');
				return false;
			}else{
				$.ajax({
					type:"GET",
					url:"/event/etc/doEventSubscript71789.asp",
					data: "mypet="+$("#imypet").val(),
					dataType: "text",
					async:false,
					cache:false,
					success : function(Data, textStatus, jqXHR){
						if (jqXHR.readyState == 4) {
							if (jqXHR.status == 200) {
								if(Data!="") {
									var str;
									for(var i in Data){
										 if(Data.hasOwnProperty(i)){
											str += Data[i];
										}
									}
									str = str.replace("undefined","");
									res = str.split("|");
									if (res[0]=="OK"){
										$("#lyWin").empty().html(res[1]);
										$("#lyWin").show();
										$("#dimmed").show();
										window.$('html,body').animate({scrollTop:100}, 500);
									} else {
										errorMsg = res[1].replace(">?n", "\n");
										alert(errorMsg);
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
			}
		<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;				
		<% End If %>
	<% End If %>
}
function btnClose(){
	$("#lyWin").hide();
	$("#dimmed").hide();
}
$(function(){
	$("#pets ul li").click(function () {
		if ( $(this).hasClass("pops")) {
			$("#pets > div").removeClass();
			$("#pets > div").addClass("bg1");
			$("#imypet").val("pops");
		}
		if ( $(this).hasClass("gidget")) {
			$("#pets > div").removeClass();
			$("#pets > div").addClass("bg2");
			$("#imypet").val("gidget");
		}
		if ( $(this).hasClass("max")) {
			$("#pets > div").removeClass();
			$("#pets > div").addClass("bg3");
			$("#imypet").val("max");
		}
		if ( $(this).hasClass("snowball")) {
			$("#pets > div").removeClass();
			$("#pets > div").addClass("bg4");
			$("#imypet").val("snowball");
		}
		if ( $(this).hasClass("duke")) {
			$("#pets > div").removeClass();
			$("#pets > div").addClass("bg5");
			$("#imypet").val("duke");
		}
		if ( $(this).hasClass("mel")) {
			$("#pets > div").removeClass();
			$("#pets > div").addClass("bg6");
			$("#imypet").val("mel");
		}
		if ( $(this).hasClass("chloe")) {
			$("#pets > div").removeClass();
			$("#pets > div").addClass("bg7");
			$("#imypet").val("chloe");
		}
	});
});
</script>
<div class="mEvt71789 mypet">
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/71789/m/txt_my_pet.jpg" alt="텐바이텐이 밝혀낸다! 총 1,000명에게 매일매일 선물이 쏟아져요!" /></p>
<% If isapp = 1 Then %>		<%' for dev msg : 앱일 경우 %>
	<div id="pets" class="pets">
		<div class="bg"></div>
		<input type="hidden" name="imypet" id="imypet">
		<p class="bounce"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71789/m/txt_guide.png" alt="마이펫을 터치한 후, 응모버튼을 눌러주세요! ID 당 1일 1회 응모 가능" /></p>
		<ul>
			<li class="pops"><button type="button">Pops</button></li>
			<li class="gidget"><button type="button">Gidget</button></li>
			<li class="max"><button type="button">Max</button></li>
			<li class="snowball"><button type="button">Snowball</button></li>
			<li class="duke"><button type="button">Duke</button></li>
			<li class="mel"><button type="button">Mel</button></li>
			<li class="chloe"><button type="button">Chloe</button></li>
		</ul>
		<a href="#lyView" id="layer" class="btnEnter"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71789/m/btn_enter.png" alt="응모하기" onclick="checkform();return false;" /></a>
		<img src="http://webimage.10x10.co.kr/eventIMG/2016/71789/m/img_pets.jpg" alt="" />
	</div>
	<div id="lyWin" class="lyView" style="display:none"></div>
<% Else %>					<%' for dev msg : 모바일웹일 경우 %>
	<div class="pets">
		<% 'for dev msg : APP 미설치시 /event/appdown/ 'APP 설치 되어있을 때 , 앱 자동 실행 & 이벤트 페이지 연동 (71789) %>
		<a href="/event/appdown/" class="btnApp" onclick="gotoDownloadapp(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71789/m/btn_app.png" alt="텐바이텐 앱에서 참여하기" /></a>
		<img src="http://webimage.10x10.co.kr/eventIMG/2016/71789/m/img_pets.jpg" alt="" />
	</div>
<% End If %>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/71789/m/txt_gift_v1.jpg" alt="총 1,000명에게 드리는 선물! 오리지널 정품 가방, 키링, 모자, 영화 전용 예매권 등 마이펫들의 선물을 매일 드립니다! 실제 상품은 이미지와 상이할 수 있습니다." /></p>
	<div class="movie">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/71789/m/tit_movie_preview.png" alt="예고편 감상하기" /></h3>
		<div class="videoWrap">
			<div class="video">
				<iframe src="https://www.youtube.com/embed/k5EMRySSUWQ" frameborder="0" title="마이펫의 이중생활 2차 예고편" allowfullscreen></iframe>
			</div>
		</div>
	</div>
	<div class="bonus">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/71789/m/txt_bonus.png" alt="보너스 이벤트 배송박스 속 맥스와 함께 일상을 찍어주세요! 추첨을 통해 50분께 기프트카드 1만원 권을 드립니다. 텐바이텐 배송상품 쇼핑 후 박스 속 맥스와 인증샷을 찍은 후 인스타그램에 #텐바이텐 #마이펫의이중생활 해시태그로 업로드 해주세요! 맥스 리플렛은 텐바이텐 배송 상품과 함께 배송됩니다. 선착순 한정수량으로 소진시 미포함 될 수 있습니다." /></p>
	<% If isapp = 1 Then %>
		<a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=65618"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71789/m/btn_tenten_delivery_v1.gif" alt="텐텐배송이 나가신다 길을 비켜라 이벤트 페이지로 이동" /></a>
	<% Else %>
		<a href="/event/eventmain.asp?eventid=65618"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71789/m/btn_tenten_delivery_v1.gif" alt="텐텐배송이 나가신다 길을 비켜라 이벤트 페이지로 이동" /></a>
	<% End If %>
	</div>
	<div class="noti">
		<h3><span>유의사항</span></h3>
		<ul>
			<li>한 ID 당 하루 한 번 참여하실 수 있습니다.</li>
			<li>당첨자는 이벤트 응모 후, 익일 오전 10시에 공지사항과 SMS로 발표될 예정입니다.</li>
			<li>경품은 배송지 입력 후 1주일 안에 출고됩니다.</li>
			<li>영화 예매권의 경우 7월 29일 금요일에 일괄 발송됩니다.</li>
		</ul>
	</div>
	<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/71789/m/tit_item.png" alt="마이펫의 이중생활 굿즈도 둘러 보세요!" /></h3>
	<div id="dimmed"></div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->