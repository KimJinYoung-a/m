<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 2019 마일리지
' History : 2019-01-30 최종원
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, currenttime
IF application("Svr_Info") = "Dev" THEN
	eCode = "90223"
Else
	eCode = "92309"
End If

currenttime = now()
'currenttime = #02/04/2019 09:00:00#

userid = GetEncLoginUserID()

dim eventEndDate, currentDate, eventStartDate

eventStartDate = cdate("2019-01-31")
eventEndDate = cdate("2019-02-07")
currentDate = date()
'currentDate = Cdate("2019-02-04")

dim subscriptcount, totalsubscriptcount
subscriptcount=0
totalsubscriptcount=0

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", 3000, "")
end if

'//전체 참여수
totalsubscriptcount = getevent_subscripttotalcount(eCode, left(currenttime,10), 3000, "")

dim limitcnt, currentcnt
limitcnt = 2019
currentcnt = limitcnt - totalsubscriptcount
if currentcnt < 1 then currentcnt = 0
%>
<%
'// SNS 공유용
    Dim vTitle, vLink, vPre, vImg
    Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

    snpTitle    = Server.URLEncode("[선착순 2019 마일리지!]")
    snpLink        = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=92309")
    snpPre        = Server.URLEncode("10x10 이벤트")
    snpImg        = Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2019/92309/bnr_kakao.jpg")
    appfblink     = "http://m.10x10.co.kr/event/eventmain.asp?eventid=92309"

    '// 카카오링크 변수
    Dim kakaotitle : kakaotitle = " [선착순 2019 마일리지!]"
    Dim kakaodescription : kakaodescription = "매일 오전 10시! 2,019명에게만 쇼핑지원금을 드려요"
    Dim kakaooldver : kakaooldver = "매일 오전 10시! 2,019명에게만 쇼핑지원금을 드려요"
    Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2019/92309/bnr_kakao.jpg"
    Dim kakaolink_url 
    If isapp = "1" Then '앱일경우
        kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=92309"
    Else '앱이 아닐경우
        kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid=92309"
    End If	    
%>
<style type="text/css">
.mEvt92309 {background-color: #fcbc59;}
.topic {position: relative;}
.topic ul {position: absolute; top: 4.26rem; left: 0; width: 100%; }
.topic ul li {animation:slowDown 1s ease-out both; opacity: 1;}
.topic ul li:nth-child(2) {margin-top: 1.92rem; animation-delay: .5s;}
.topic ul li:nth-child(3) {margin-top: 1.49rem; animation-delay: 1s;}
.coupon-area {position: relative;}
.coupon-area p.ani {position: absolute; right: 3rem; top: 5rem; width: 17%; animation:bounce .7s 20;}
.coupon-area div {position: relative;}
.coupon-area div span {position: absolute; top:4.4rem; left: 50%; width: 16rem; height: 3.95rem; margin-left: -8rem; padding-top: .81rem; background: url(//webimage.10x10.co.kr/fixevent/event/2019/92309/img_amount.png) no-repeat; background-size: contain; color: #fff; font-size: 2.3rem; font-family: roboto; font-weight: 500; text-indent: 1.3rem; text-align: right; letter-spacing: 2.71rem;}
.coupon-end {position: absolute; display: flex; align-items: center; top: 40%; width: 95%; margin: 0 2.5% ; height: 32.3rem; background-color: #000000cc; border-radius: .8rem; z-index: 99;}
.coupon-end.member {height: 46rem;}
.coupon-end.daily {top: unset; bottom: 1rem; height: 13rem;}
.mileage-area {padding: 3.7rem 0; line-height: 2.2rem; letter-spacing: -.07rem; background-color: #ec8e14; color: #fff; font-family:  'malgun Gothic'; font-weight: 600; font-size: 1.5rem; text-align: center;}
.mileage-area em {font-size: 1.67rem;}
.mileage-area b {position: relative; color: #680000;font-size: 1.6rem;}
.mileage-area b.mileage {font-size: 1.9rem; font-family: roboto; font-weight: 600; }
.mileage-area b:after {content: ''; position: absolute; bottom: 0; left: 0; height: 1px; width: 100%; background-color: #ffffffa1;}
.mileage-area dd { margin-top: .8rem;}
.notice {padding:2.8rem 3.2rem; background-color:#3b4658;}
.notice p {color: #fff; margin: .6rem auto 2.3rem; font-weight: bold; font-size: 1.5rem; text-align: center}
.notice li {color: #fff; line-height: 1.5rem; margin-bottom: 0.5rem; }
.notice li:before {content:'-';display:inline-block; width:0.7rem; margin-left:-0.7rem; font-weight: bold;}
.notice li b {font-weight: bold;}
.layer-popup {display:none; position:absolute; left:0; top:0; z-index:9997; width:100%; height:100%;} 
.layer-popup .layer {overflow:hidden; position:fixed; top:5rem;  z-index:99999;} 
.layer-popup .layer > div {position: relative;}
.layer-popup .layer dl {position: relative; margin-top: -0.04rem;}
.layer-popup .layer dl dd {position: absolute; top:1.6rem; width: 100%; text-align: center; font-family:  'malgun Gothic'; font-weight: 600;  color: #000;font-size: 1.8rem;}
.layer-popup .mask {display: block; background: rgba(0, 0, 0, 0.8);}
.layer-popup button {background-color: transparent;}
@keyframes bounce {
	from to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(-.9rem); animation-timing-function:ease-in;}
}
@keyframes slowDown{from{transform:translateY(-2rem); opacity: 0;}}
</style>
<script>
$(function(){
    $('.layer-popup .btn-close,.layer-popup .mask').click(function(){
        $('.layer-popup').fadeOut();
        $('body').css({'overflow':'auto'})
    });
})
</script>
<script type="text/javascript">
function doAction() {	
	<% If IsUserLoginOK() Then %>			
		<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
			alert("이벤트 참여기간이 아닙니다.");
			return false;
		<% end if %>		
		<% if subscriptcount > 0 then %>
			alert("이미 마일리지를 받으셨습니다.");
			return;
		<% else %>	
			<% if currentcnt < 1 then %>
				alert("오늘의 마일리지가 모두 소진 되었습니다!.");
				return;
			<% else %>		
				<% if Hour(currenttime) < 10 then %>
					alert("마일리지는 오전 10시부터 받으실수 있습니다.");
					return;
				<% else %>
					var str = $.ajax({
						type: "post",
						url:"/event/etc/doeventsubscript/doEventSubscript92309.asp",
						data: '',
						dataType: "text",
						async: false
					}).responseText;	
					
					if(!str){alert("시스템 오류입니다."); return false;}

					var resultData = JSON.parse(str);

					var reStr = resultData.data[0].result.split("|");
					var currentcnt = resultData.data[0].currentcnt;
					var userMileage = resultData.data[0].mileage;		

					if(reStr[0]=="OK"){		
						showPopup();		
					}else{
						var errorMsg = reStr[1].replace(">?n", "\n");
						alert(errorMsg);
				//			document.location.reload();
					}					
					$("#dispCnt").html(currentcnt)
					$("#dispMileage").html(setComma(userMileage))
					return false;
				<% end if %>	
			<% end if %>		
		<% end if %>				
	<% else %>
			<% if isApp=1 then %>
				parent.calllogin();
				return false;
			<% else %>
				parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
				return false;
			<% end if %>
	<% End If %>
}
function showPopup(){
	$('#lyrSch1').fadeIn();
	$('body').css({'overflow':'hidden'})
}
</script>
<script>
//공유용 스크립트
	function snschk() {		
		<% if isapp then %>
		fnAPPshareKakao('etc','<%=kakaotitle%>\n<%=kakaodescription%>','<%=kakaolink_url%>','<%=kakaolink_url%>','<%="url="&kakaolink_url%>','<%=kakaoimage%>','','','','');
		return false;
		<% else %>
		event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaolink_url%>' );	
		<% end if %>
	}
	function parent_kakaolink(label , imageurl , width , height , linkurl ){
		//카카오 SNS 공유
		Kakao.init('c967f6e67b0492478080bcf386390fdd');

		Kakao.Link.sendTalkLink({
			label: label,
			image: {
			src: imageurl,
			width: width,
			height: height
			},
			webButton: {
				text: '10x10 바로가기',
				url: linkurl
			}
		});
	}

	//카카오 SNS 공유 v2.0
	function event_sendkakao(label , description , imageurl , linkurl){	
		Kakao.Link.sendDefault({
			objectType: 'feed',
			content: {
				title: label,
				description : description,
				imageUrl: imageurl,
				link: {
				mobileWebUrl: linkurl
				}
			},
			buttons: [
				{
				title: '웹으로 보기',
				link: {
					mobileWebUrl: linkurl
				}
				}
			]
		});
	}
</script>
</head>
<body>            
			<div class="mEvt92309">
                <div class="topic">
                    <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/92309/bg_top.png" alt=""></p>
                    <ul>
                        <li><img src="//webimage.10x10.co.kr/fixevent/event/2019/92309/tit_01.png" alt="매일 오전 10시"></li>
                        <li><img src="//webimage.10x10.co.kr/fixevent/event/2019/92309/tit_02.png" alt="2019 마일리지"></li>
                        <li><img src="//webimage.10x10.co.kr/fixevent/event/2019/92309/tit_03.png?v=1.01" alt="2019명에게만 쇼핑지원금을 드려요!  새해에는 망설임없이 쇼핑하세요!"></li>
                    </ul>
                </div>
                <div class="coupon-area">
                    <p class="ani"><img src="//webimage.10x10.co.kr/fixevent/event/2019/92309/ico_ani.png" alt="선착순"></p>
                    <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/92309/img_coupon.png" alt="오늘의 마일리지"></p>
                    <div>
                        <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/92309/bg_amount.png" alt="발급 기간 : 2. 4(월) ~ 2. 7(목)  매일 오전 10시부터 소진 시까지, 사용 기간: 2. 7(목) 오후 11:59:59까지 이후 사전통보 없이 자동소멸"></p>
                        <%'<!--  for dev msg : 잔여 마일리지 수량 카운트 -->%>
                        <span id="dispCnt"><%= Format00(4,currentcnt) %></span>
                    </div>
                    <button id="layer1" onclick="doAction();"><img src="//webimage.10x10.co.kr/fixevent/event/2019/92309/btn.png" alt="마일리지 받기"></button>                    
					<% if currentcnt < 1 then %> 
						<% if currentDate <= Cdate("2019-02-06") then '<!-- 쿠폰 소진_월~수 노출 -->%>
							<p class="coupon-end daily"><img src="//webimage.10x10.co.kr/fixevent/event/2019/92309/txt_layer_01.png" alt="오늘의 마일리지가  모두 소진되었습니다!  내일 아침 10시를 기다려주세요~!"></p>
						<% else %>
							<% if IsUserLoginOK() then'<!-- 쿠폰 소진_목(로그인시) 노출--> %>
								<p class="coupon-end member"><img src="//webimage.10x10.co.kr/fixevent/event/2019/92309/txt_layer_02.png" alt="오늘의 마일리지가  모두 소진되었습니다!  감사합니다"></p>
							<% else '<!-- 쿠폰 소진_목(비로그인시) 노출-->%>
								<p class="coupon-end"><img src="//webimage.10x10.co.kr/fixevent/event/2019/92309/txt_layer_02.png" alt="오늘의 마일리지가  모두 소진되었습니다!  감사합니다"></p>							
							<% end if %>
						<% end if %>					
					<% end if %>
                </div>
                <%'<!-- 로그인 시에만 노출 -->%>
				<% if userid <> "" then %>
                <dl class="mileage-area">
                    <dt>                        
                        <b><%= get10x10onlineusername(userid) %></b> 님의 현재 마일리지는<br />
                    </dt>
                    <dd>                        
                        <b class="mileage" id="dispMileage"><%=FormatNumber(getUserCurrentMileage(userid),0)%>M</b> 입니다.
                    </dd>
                </dl>
				<% end if %>
                <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/92309/img_giude.png" alt="마일리지는 결제 시,  현금처럼 사용할 수 있습니다."></p>
                <div class="notice">
                    <p>이벤트 유의사항</p>
                    <ul>
                        <li>본 이벤트는 로그인 후에 참여할 수 있습니다.</li>
                        <li>이벤트는 진행기간 내 ID당 1회만 선착순으로 참여할 수 있습니다.</li>
                        <li>주문하시는 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
                        <li>지급된 마일리지는 <b>3만원 이상 구매 시 현금처럼 사용 가능합니다.</b></li>
                        <li>기간 내에 사용하지 않은 마일리지는 <b>2월 7일 목요일 오후 11:59:59에 자동 소멸됩니다.</b></li>
                        <li>이벤트는 조기 마감될 수 있습니다. </li>
                    </ul>
                </div>
                <a href="/event/eventmain.asp?eventid=92385" onclick="jsEventlinkURL(92385);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/92309/bnr_01.png?v=1.01" alt="최저가 최저가 최최최저가"></a>
                <a href="javascript:snschk();" ><img src="//webimage.10x10.co.kr/fixevent/event/2019/92309/bnr_02.png?v=1.01" alt="친구에게 공유하기"></a>
                
                <div class="layer-popup" id="lyrSch1"> 
                    <div class="layer"> 
                        <button class="btn-close"><img src="//webimage.10x10.co.kr/fixevent/event/2019/92309/btn_layer.png?v=1.01" alt="닫기"></button>
                        <dl>
                            <dt><img src="http://webimage.10x10.co.kr/fixevent/event/2019/92309/img_layer.png?v=1.02" alt="3000마일리지 지급완료"></dt>
                            <dd>
                                <span><%= get10x10onlineusername(userid) %></span>
                                님의
                            </dd>
                        </dl>
                        <a href="/event/eventmain.asp?eventid=92385" onclick="jsEventlinkURL(92385);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/92309/bnr_layer.png" alt="최저가 최저가 최최최저가"></a>
                    </div> 
                    <div class="mask"></div> 
                </div>
            </div>            
<!-- #include virtual="/lib/db/dbclose.asp" -->