<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : 2019 4월 정기세일 - 릴레이 공유 이벤트
' History : 2019-03-26 이종화
'####################################################
dim userid , eCode , sqlStr
dim subidx , imageno , snsurl

eCode   = chkiif(application("Svr_Info") = "Dev","90250","93475")
userid  = getEncLoginUserid()

'// 응모 여부 확인
if (IsUserLoginOK) then
	sqlStr = " SELECT TOP 1 sub_idx , sub_opt2 , sub_opt3 FROM [db_event].[dbo].[tbl_event_subscript] WHERE userID = '"& userid &"' and evt_code = '"& eCode &"' ORDER BY sub_idx DESC "
    rsget.Open sqlStr, dbget, 1
	If Not(rsget.bof Or rsget.Eof) Then
		subidx = rsget("sub_idx")
        imageno = rsget("sub_opt2")
        snsurl = rsget("sub_opt3")
	End IF
	rsget.close
end if
%>
<style type="text/css">
button {background:none; outline:none}
.relay {position:relative; background-color:#ffe56c;}
.relay > div {position:relative;}
.topic:after {content:''; position:absolute; bottom:0; display:block; width:1000rem; height:33rem; background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/m/bg_top.png);background-size:auto 100%; animation:emoticon 140s infinite linear;}
.airpot button {position:absolute; top:32%; left:52%; width:29%; animation:bounce .7s infinite;}
.airpot dl {position:absolute; top:8%; left:14%; width:72%; }
.airpot dl dd {position:absolute; top:0; right:0; width:16%;}
.step1 .slide1 .swiper-wrapper {padding-left:2.5rem;}
.step1 .swiper-slide {width:40%; margin-right:1.8rem;}
.step1 .swiper-slide:after {content:''; display:block; height:2.6rem; background-image:url('//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/m/btn_select.jpg?v=1.01'); background-size:100% auto;}
.step1 .swiper-slide.on:after {background-image:url('//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/m/btn_select_on.jpg');}
.step1 .swiper-slide.slide-end {width: 1.5rem; height: 0; opacity: 0;}
.step2 ul {*zoom:1} 
.step2 ul:after {display:block; clear:both; content:'';}
.step2 ul li {width:50%; float:left;}
.step3 input {position:absolute; width:100%; margin-top:5%; padding:0 10%; color:#000; font-size:1.5rem; font-weight:bold; background:none; border:0; }
.step3 input::-webkit-input-placeholder {color:#aaa;}
.step3 input:focus::-webkit-input-placeholder {opacity:0;}
.relay .notice {padding:2.8rem 3.2rem; background-color:#2b5177;}
.relay .notice p {color:#fff; margin-bottom:2.3rem; font-weight:bold; font-size:1.5rem; text-align:center}
.relay .notice li {color:#fff; line-height:1.5rem; margin-bottom:0.5rem; }
.relay .notice li:before {content:'·';display:inline-block; width:0.7rem; margin-left:-0.7rem; font-weight:bold;}
.relay-layer {position:absolute; top:0; left:0; bottom:0; right:0; height:100%; width:100%; background-color:rgba(0, 0, 0, 0.7); z-index:998;}
.relay-layer div{position:absolute; top:0; left:50%; width:32rem; margin-left:-16rem;  z-index:999; }
.relay-layer ul {position:absolute; overflow-y:scroll; top:15.5rem; left:50%; width:22.7rem; height:21.7rem; margin-left:-11rem; *zoom:1} 
.relay-layer ul:after {display:block; clear:both; content:'';} 
.relay-layer ul li {float:left; width:50%; font:1.28rem/1.8 'RobotoRegular', sans-serif; color:#222;}
.relay-layer ul::-webkit-scrollbar {width:17px; height:17px; }
.relay-layer ul::-webkit-scrollbar-track {background:none; -webkit-box-shadow:none}
.relay-layer ul::-webkit-scrollbar-thumb { background:#e2e2e2; border-radius:10px; -webkit-box-shadow:none}
@keyframes emoticon {
	from {transform:translateX(0);}
	to {transform:translateX(-50%);}
}
@keyframes bounce {
	from to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(-10px); animation-timing-function:ease-in;}
}
</style>
<script src="https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/1.7.1/clipboard.min.js"></script>
<script>
$(function(){
    $('.airpot .btn1').click(function(){
        $('.airpot dl').fadeToggle()
    })
    mySwiper = new Swiper(".slide1",{
        slidesPerView:'auto',
    });
    //이미지 다운받기
    $('.step1 .swiper-slide').click(function(){
		var imgSrc=$(this).find('img').attr('href')
		var imgNumber = $(this).find('img').attr("rel");
		$("#imgnumber").val(imgNumber);
		$(this).addClass('on').siblings().removeClass('on')
    })
    // 복사하기
    var clipboard = new Clipboard('.hash');
    clipboard.on('success', function(e) {
		alert('해시태그 복사가 완료 되었습니다.');
        console.log(e);
    });
    clipboard.on('error', function(e) {
        console.log(e);
    });
})

function fnEventAction(mode){
	<% If Not(IsUserLoginOK) Then %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="& eCode &"")%>');
			return false;
		<% end if %>
	<% else %>
		<% If (Now() > #04/01/2019 00:00:00# And Now() < #04/20/2019 23:59:59#) Then %>
			var textdata = (mode == "inputurl" ? "&snsurl="+$("#snsurl").val() : "" );
			var imgnumber = "&imagenumber="+$("#imgnumber").val();
			var sub_idx = ($("#subidx").val() == "" ? "<%=subidx%>" : $("#subidx").val());
			var idxparam = "&eventidx="+sub_idx;

			$.ajax({
				type:"GET",
				url:"/event/salelife/share_proc.asp",
				data: "mode="+mode+textdata+imgnumber+idxparam,
				dataType: "text",
				async:false,
				cache:true,
				success : function(Data, textStatus, jqXHR){
					if (jqXHR.readyState == 4) {
						if (jqXHR.status == 200) {
							//console.log(Data);
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
									if (mode == 'inputurl') {
										alert(res[1].replace(">?n", "\n"));
										document.location.reload();
									} else {
										$("#subidx").val(res[2]);
										<% if isApp=1 then %>
											fnAPPpopupExternalBrowser('http://thumbnail.10x10.co.kr/webimage/fixevent/event/2019/salabal/relay/download/img_0'+$("#imgnumber").val()+'.jpg?cmd=text&font=Malgun+Gothic&fontsize=45&x=750&y=10&w=400&h=200&text='+res[2]);
										<% else %>
											var popwin = window.open('http://thumbnail.10x10.co.kr/webimage/fixevent/event/2019/salabal/relay/download/img_0'+$("#imgnumber").val()+'.jpg?cmd=text&font=Malgun+Gothic&fontsize=45&x=750&y=10&w=400&h=200&text='+res[2],'download');
	    									popwin.focus();
										<% end if %>
									}
									return false;
								} else {
									errorMsg = res[1].replace(">?n", "\n");
									alert(errorMsg);
									document.location.reload();
									return false;
								}
							} else {
								alert("잘못된 접근 입니다..");
								document.location.reload();
								return false;
							}
						}
					}
				},
				error:function(jqXHR, textStatus, errorThrown){
					alert("잘못된 접근 입니다...");
					document.location.reload();
					return false;
				}
			});
		<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;				
		<% End If %>
	<% End If %>
}
</script>
<div class="mEvt93475 relay">
	<div class="topic">
		<h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/m/img_top.jpg?v=1.01" alt="에어팟2 득템"></h2>
	</div>
	<div class="airpot">
		<img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/m/img_airpot.jpg" alt="당첨자 발표 2019.04.22">
		<button class="btn1"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/m/btn_aripot.png" alt="에어팟2"></button>
		<dl style="display:none;">
			<dt><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/m/img_layer_airpot.jpg" alt="안심하고 응모해서 에어팟2의 주인공이 되어보세요"></dt>
			<dd class="btn1"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/m/btn_close.png" alt="닫기"></dd>
		</dl>
	</div>
	<div class="guide">
		<div class="step1">
			<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/m/tit_step1.jpg" alt="참여방법 step1 6개의 캐릭터 중, 원하는 이미지 다운받기"></h3>
			<div class="slide1">
				<div class="swiper-wrapper">
					<div class="swiper-slide on"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/m/img_slide_06.jpg" alt="이미지6" href="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/download/img_06.jpg" rel="6"></div>
					<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/m/img_slide_05.jpg" alt="이미지5" href="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/download/img_05.jpg" rel="5"></div>
					<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/m/img_slide_02.jpg" alt="이미지2" href="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/download/img_02.jpg" rel="2"></div>
					<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/m/img_slide_03.jpg" alt="이미지3" href="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/download/img_03.jpg" rel="3"></div>
					<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/m/img_slide_01.jpg" alt="이미지1" href="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/download/img_01.jpg" rel="1"></div>
					<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/m/img_slide_04.jpg" alt="이미지4" href="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/download/img_04.jpg" rel="4"></div>
					<div class="swiper-slide slide-end"></div>
				</div>
			</div>
			<a href="" onclick="fnEventAction('imgdown');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/m/btn_down.jpg?v=1.02" alt="이미지 다운받기"></a>
		</div>
		<div><input type="hidden" id="imgnumber" value="6"></div>
		<div><input type="hidden" id="subidx" value="<%=subidx%>"></div>
		<div class="step2">
			<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/m/tit_step2.jpg" alt="step2 다운받은 이미지를 아래 해시태그와 함께 sns에 업로드하기"></h3>
			<img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/m/img_hash.jpg" alt="#텐바이텐#에어팟2#세라밸페스티벌">
			<button class="hash" data-clipboard-text="#텐바이텐#10X10#에어팟2#세라밸페스티벌 #4월1일~22일 #봄 #정기세일 #최대20% #SALE"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/m/btn_hash.jpg" alt="#텐바이텐#에어팟2#세라밸페스티벌"></button>
			<ul>
				<li>
					<a href="https://www.facebook.com/your10x10" class="mWeb" target="_blank"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/m/btn_fb.jpg" alt="페이스북으로 이동"></a>
					<a href="" onclick="fnAPPpopupExternalBrowser('https://www.facebook.com/your10x10'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/m/btn_fb.jpg" alt="페이스북으로 이동"></a>
				</li>
				<li>
					<a href="https://www.instagram.com/your10x10/" class="mWeb" target="_blank"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/m/btn_insta.jpg" alt="인스타그램으로 이동"></a>
					<a href="" onclick="fnAPPpopupExternalBrowser('https://www.instagram.com/your10x10/'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/m/btn_insta.jpg" alt="인스타그램으로 이동"></a>
				</li>
			</ul>
			<img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/m/txt_sns.jpg" alt="#텐바이텐#에어팟2#세라밸페스티벌">
		</div>
		<div class="step3">
			<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/m/tit_step3.jpg" alt="step3 업로드한 sns url 입력하고 응모하기"></h3>
			<div>
				<%'!--  for dev msg :유저 입력창 --%>
				<input type="text" id="snsurl" value="" placeholder="SNS URL을 입력해주세요" />
				<img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/m/img_url.jpg" alt="" >
			</div>
			<button class="submit" onclick="fnEventAction('inputurl');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/m/btn_url.jpg" alt="응모하기"></button>
		</div>
		<%'!--  for dev msg :이벤트 종료 후 노출 --%>
		<div class="relay-layer" style="display:<%=chkiif((Now() > #04/21/2019 00:00:00# And Now() < #04/22/2019 17:59:59#),"block","none")%>">
			<img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/m/img_layer_end.png" alt="이벤트 기간이 종료 되었습니다" >
		</div>
		<%'!--  for dev msg :당첨자 발표 --%>
		<div class="relay-layer" style="display:<%=chkiif(Now() > #04/22/2019 17:59:59#,"block","none")%>">
			<div>
				<img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/m/img_layer_winner.png" alt="당첨자발표" >
				<ul class="scroll">
					<li>dayo**</li>
					<li>korea**</li>
					<li>wani52**</li>
					<li>buzzins**</li>
					<li>hmj10**</li>
					<li>1117j**</li>
					<li>inawoni**</li>
					<li>laputaey**</li>
					<li>no1jun**</li>
					<li>94applek**</li>
					<li>unjinc**</li>
					<li>als**</li>
					<li>yaeri10**</li>
					<li>abcd200**</li>
					<li>422inyou**</li>
					<li>tnals84**</li>
					<li>sy86**</li>
					<li>shydp**</li>
					<li>marquee**</li>
					<li>dbwlso**</li>
					<li>lovelylyn13**</li>
					<li>june3ba**</li>
					<li>dudms**</li>
					<li>quswl10**</li>
					<li>shb**</li>
					<li>wlstnrl**</li>
					<li>hwijoo1**</li>
					<li>ysl11**</li>
					<li>spfh**</li>
					<li>rice1**</li>
					<li>bnnk**</li>
					<li>hyunji06**</li>
					<li>skysgot**</li>
					<li>qksgyd**</li>
					<li>futureflow**</li>
					<li>kevin**</li>
					<li>choo99**</li>
					<li>soo**</li>
					<li>ks90js**</li>
					<li>silverdevi**</li>
					<li>tmdfl89**</li>
					<li>nayana99**</li>
					<li>shindaw**</li>
					<li>hongju05**</li>
					<li>rbdhks5**</li>
					<li>jihee04**</li>
					<li>shgpdn1**</li>
					<li>tpgml90**</li>
					<li>ljy8712**</li>
					<li>babyboo6**</li>
				</ul>
			</div>
		</div>
	</div>
	<% if isapp then %>
	<a href="" onclick="javascript:fnAPPpopupExternalBrowser('http://www.instagram.com/explore/tags/%EC%84%B8%EB%9D%BC%EB%B0%B8%ED%8E%98%EC%8A%A4%ED%8B%B0%EB%B2%8C/');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/m/bnr_insta.jpg" alt="실시간 이벤트 현황 보러 가기"></a>
	<% else %>
	<a href="http://www.instagram.com/explore/tags/%EC%84%B8%EB%9D%BC%EB%B0%B8%ED%8E%98%EC%8A%A4%ED%8B%B0%EB%B2%8C/"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/relay/m/bnr_insta.jpg" alt="실시간 이벤트 현황 보러 가기"></a>
	<% end if %>
	<div class="notice">
		<p>유의사항</p>
		<ul>
			<li>본 이벤트는 텐바이텐 회원만 참여할 수 있습니다.</li>
			<li>본 이벤트의 당첨자는 텐바이텐에서 캐릭터 이미지를 다운 받아서 SNS업로드한 고객 중에서 추첨할 예정입니다. 참여방법을 꼭 지켜주세요!</li>
			<li>당첨되신 50분께는 세무 신고에 필요한 개인 정보를 요청할 수 있습니다. (제세공과금은 텐바이텐이 부담합니다.)</li>
			<li>당첨자는 4월 22일(월) 6PM에 이벤트 페이지 및 공지사항에 발표될 예정입니다.</li>
		</ul>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->