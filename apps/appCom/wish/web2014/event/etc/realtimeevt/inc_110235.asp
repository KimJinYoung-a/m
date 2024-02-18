<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/realtimeevent/RealtimeEventCls.asp" -->
<%
'####################################################
' Description : 2021 언박싱 이벤트 (4월 정기세일)
' History : 2021-03-19 정태훈
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent
dim mktTest

mktTest = False

IF application("Svr_Info") = "Dev" THEN
	eCode = "104331"
	moECode = "104330"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "110235"
	moECode = "110234"
    mktTest = True
Else
	eCode = "110235"
	moECode = "110234"
    mktTest = False
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isapp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2021-03-29")		'이벤트 시작일
eventEndDate 	= cdate("2021-04-07")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if mktTest then
    currentDate = cdate("2021-03-29")
else
    currentDate = date()
end if

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("[돌아온 랜덤박스 이벤트!]")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2021/110235/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[돌아온 랜덤박스 이벤트!]"
Dim kakaodescription : kakaodescription = "배송비 2,500원만 내면, 랜덤박스가 갑니다. 박스 안에는 역대급 랜덤 선물이 가득!"
Dim kakaooldver : kakaooldver = "배송비 2,500원만 내면, 랜덤박스가 갑니다. 박스 안에는 역대급 랜덤 선물이 가득!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2021/110235/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& moECode

dim isSecondTried
dim isFirstTried
dim triedNum : triedNum = 0
dim isShared : isShared = False
isSecondTried = false

if LoginUserid <> "" then
	set pwdEvent = new RealtimeEventCls
	pwdEvent.evtCode = eCode
	pwdEvent.userid = LoginUserid
	isSecondTried = pwdEvent.isParticipationDayBase(2)
	isFirstTried = pwdEvent.isParticipationDayBase(1)
	isShared = pwdEvent.isSnsShared
end if

triedNum = chkIIF(isFirstTried, 1, 0)
triedNum = chkIIF(isSecondTried, 2, triedNum)
%>
<style>
.bnr-anniv18 {display:none;}
.unboxing {position:relative; overflow:hidden;}
.unboxing button {background:none;}
.unboxing .topic {position:relative;}
.unboxing .swiper-slide {width:100%;}
.unboxing .tit-unboxing {position:absolute; top:16.7vw; left:0; z-index:10; width:100%;}
.unboxing .tit-unboxing img {animation:titAni .5s both ease-in-out;}
.unboxing .tit-unboxing img:nth-of-type(2) {margin:-4.7% 0; animation-delay:.2s;}
.unboxing .tit-unboxing img:nth-of-type(3) {animation-delay:.5s;}
@keyframes titAni {
	0% {opacity:0; transform:translate3d(20%,-10%,0);}
	100% {opacity:1; transform:translate3d(0,0,0);}
}
.unboxing .topic .txt-sale {position:absolute; top:0; right:0; left:0; z-index:10; width:50%; margin:auto;}
.unboxing .floating {position:absolute; left:0; bottom:30.5vw; z-index:10; display:-webkit-box; display:-ms-flexbox; display:flex; width:100%; height:25.3vw; background:url(//webimage.10x10.co.kr/fixevent/event/2021/110235/m/btn_floating.png) no-repeat center / auto 100%;}
.unboxing .floating button {font-size:0; color:transparent;}
.unboxing .floating .btn-try {-webkit-box-flex:1; -ms-flex-positive:1; flex-grow:1;}
.unboxing .floating .btn-share {-ms-flex-negative:0; flex-shrink:0; width:20%;}
.unboxing .list {position:relative; overflow:hidden; height:71.8rem; background-color:#4799ff;}
.unboxing .list .img {max-width:32rem; margin:0 auto;}
.unboxing .list .btn-more {position:absolute; left:0; bottom:0; width:100%; height:7.6rem; background-color:#4799ff;}
.unboxing .list .btn-more img {width:auto; height:100%;}
.unboxing .btn-push {display:block; width:100%;}
.unboxing .popup {display:none; overflow:hidden auto; position:fixed; top:0; right:0; bottom:0; left:0; z-index:30; background-color:#4750ff;}
.unboxing .popup .inner {position:relative; max-width:32rem; margin:0 auto;}
.unboxing .popup button {display:block; width:100%;}
.unboxing .popup .btn-close {position:absolute; top:0; right:0; width:5.3rem; height:5.3rem; font-size:0; color:transparent;}
</style>
<script>
var numOfTry = "<%=triedNum%>";
var isShared = "<%=isShared%>"
$(function() {
	// 타이틀 이미지 전환
	var swiper = new Swiper('.unboxing .swiper-container',{
		autoplay:1000,
		speed:1,
		effect:'fade',
		loop:true
	});
	// 상품 목록
	$('.unboxing .list .btn-more').on('click', function(e) {
		$(this).hide();
		$('.unboxing .list').css('height', 'auto');
	});
	// 팝업 닫기
	$('.unboxing .popup').on('click', function(e) {
		if ($(e.target).is('.btn-close')) {
			$(e.currentTarget).fadeOut();
		}
	});
});

function eventTry(){
	<% If Not(IsUserLoginOK) Then %>
		calllogin();
		return false;
	<% else %>
		<% If (currentDate >= eventStartDate And currentDate <= eventEndDate) or mktTest Then %>
		if(numOfTry == '1' && isShared != "True"){
			// 한번 시도
			$("#secondTry").eq(0).delay(500).fadeIn();
			return false;
		}
		if(numOfTry == '2'){
			<% If (currentDate >= #04/07/2021 00:00:00#) Then %>
			$('#resultover2').eq(0).delay(500).fadeIn();
			<% else %>
			$('#resultover').eq(0).delay(500).fadeIn();
			<% end if %>
			return false;
		}
		var returnCode, itemid, data
		var data={
			mode: "add"
		}
		$.ajax({
			type:"POST",
			url:"/event/etc/realtimeevent/realtimeEvent110235Proc.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
				fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|option1','<%=eCode%>|')
					if(res!="") {
						// console.log(res)
						if(res.response == "ok"){
							popResult(res.returnCode, res.winItemid, res.selectedPdt);
							return false;
						}else{
							alert(res.faildesc);
							return false;
						}
					} else {
						alert("잘못된 접근 입니다.");
						document.location.reload();
						return false;
					}
			},
			error:function(err){
				console.log(err)
				alert("잘못된 접근 입니다.");
				return false;
			}
		});
		<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% End If %>
	<% End If %>
}

function popResult(returnCode, itemid, selectedPdt){
	numOfTry++
	if(returnCode[0] == "B"){		
		if(numOfTry >= 2){
			<% If (currentDate >= #04/07/2021 00:00:00#) Then %>
			$('#fail3').eq(0).delay(500).fadeIn();
			<% else %>
			$('#fail2').eq(0).delay(500).fadeIn();
			<% end if %>
			return false;
		}
		$("#fail1").eq(0).delay(500).fadeIn();
	}else if(returnCode[0] == "C"){		
		$("#itemid").val(itemid);	
		$("#winnerPopup").eq(0).delay(500).fadeIn();
	}else if(returnCode == "A02"){
		numOfTry = 2
		$('#resultover').eq(0).delay(500).fadeIn();
	}else if(returnCode == "A03"){
		alert("오픈된 상품이 아닙니다.");
	}
}

function sharesns(snsnum) {		
		$.ajax({
			type: "GET",
			url:"/event/etc/realtimeevent/realtimeEvent110235Proc.asp",
			data: "mode=snschk&snsnum="+snsnum,
			dataType: "JSON",			
			success: function(res){
				isShared = "True"
				if(snsnum=="fb"){
					<% if isapp then %>
					fnAPPShareSNS('fb','<%=appfblink%>');
					return false;
					<% else %>
					popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
					<% end if %>
				}else{
					<% if isapp then %>
						fnAPPshareKakao('etc','<%=kakaotitle%>','<%=kakaoWebLink%>','<%=kakaoMobileLink%>','<%="url="&kakaoAppLink%>','<%=kakaoimage%>','','','','<%=kakaodescription%>');
						return false;
					<% else %>
						event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaoMobileLink%>' );
					<% end if %>
				}					
			},
			error: function(err){
				alert('잘못된 접근입니다.')
			}
		})
}

function goDirOrdItem(){
<% If IsUserLoginOK() Then %>
	<% If (currentDate >= eventStartDate And currentDate <= eventEndDate) or mktTest Then %>		
		document.directOrd.submit();
	<% else %>
		alert("이벤트 응모 기간이 아닙니다.");
		return;
	<% end if %>
<% End IF %>
}

function jsPickingUpPushSubmit(){

    fnAmplitudeEventMultiPropertiesAction('click_event_apply','eventcode|actype','<%=ecode%>|alarm','');

    <% If not(IsUserLoginOK) Then %>
        parent.calllogin();
        return false;
    <% end if %>

    $.ajax({
        type:"GET",
        url:"/event/etc/realtimeevent/realtimeEvent110235Proc.asp?mode=pushadd",
        dataType: "json",
        success : function(result){
            if(result.response == "ok"){
                $('#lyrPush').fadeIn();
                return false;
            }else{
                alert(result.faildesc);
                return false;
            }
        },
        error:function(err){
            console.log(err);
            return false;
        }
    });
}
</script>
			<div class="mEvt110235 unboxing">
				<div class="topic">
					<h2 class="tit-unboxing">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/110235/m/tit_unboxing_01.png" alt="배송비만 내면">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/110235/m/tit_unboxing_02.png" alt="언박싱이 간다!">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/110235/m/subtit.png" alt="배송비 2,500원만 내면 집에서 랜덤박스를 언박싱할 수 있는 기회!">
					</h2>
					<span class="txt-sale"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110235/m/txt_sale.png" alt="지금 텐텐은 세일중"></span>
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110235/m/img_slide_01.jpg" alt=""></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110235/m/img_slide_02.jpg" alt=""></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110235/m/img_slide_03.jpg" alt=""></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110235/m/img_slide_04.jpg" alt=""></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110235/m/img_slide_05.jpg" alt=""></div>
						</div>
					</div>
					<div class="floating">
						<button class="btn-try" onclick="eventTry();">응모하기</button>
						<button class="btn-share" onclick="sharesns('ka');">공유하기</button>
					</div>
				</div>
				<div class="list">
					<p class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110235/m/img_list.jpg" alt="상품 목록"></p>
					<button class="btn-more"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110235/m/btn_more.png" alt="상품 더 보기"></button>
				</div>
				<p><img src="//webimage.10x10.co.kr/fixevent/event/2021/110235/m/bnr_winner.jpg" alt="SNS 해시태그"></p>
				<% If (currentDate < #04/07/2021 00:00:00#) Then %>
				<button class="btn-push" onclick="jsPickingUpPushSubmit();"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110235/m/bnr_push.jpg" alt="알림 신청하기"></button>
                <% end if %>
				<a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110211');return false;">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/110235/m/bnr_sale.jpg" alt="2021 봄 정기세일">
				</a>
				<p><img src="//webimage.10x10.co.kr/fixevent/event/2021/110235/m/txt_notice.jpg" alt="유의사항"></p>
				
				<%'<!-- 응모하기 당첨시 팝업 -->%>
				<div id="winnerPopup" class="popup" style="display:none;">
					<div class="inner">
						<button onclick="goDirOrdItem();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110235/m/pop_win.png" alt="언박싱 당첨 구매하러 가기"></button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'<!-- 꽝 팝업 - 첫 번째 응모 시 -->%>
				<div id="fail1" class="popup" style="display:none;">
					<div class="inner">
						<button onclick="sharesns('ka')"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110235/m/pop_fail1.png" alt="공유하고 한 번 더"></button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'<!--꽝 팝업 - 공유 하지 않고 응모 시 -->%>
				<div id="secondTry" class="popup" style="display:none;">
					<div class="inner">
						<button onclick="sharesns('ka')"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110235/m/pop_already.png" alt="공유하고 한 번 더"></button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'<!--꽝 팝업 - 공유 후 두번째 응모 시(기본) -->%>
				<div id="fail2" class="popup" style="display:none;">
					<div class="inner">
						<button onclick="fnAPPpopupBrowserURL('쿠폰함','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp');">
							<img src="//webimage.10x10.co.kr/fixevent/event/2021/110235/m/pop_fail2.png" alt="쿠폰함 가기">
						</button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'<!--꽝 팝업 - 공유 후 두번째 응모 시(이벤트 마지막 날) -->%>
				<div id="fail3" class="popup" style="display:none;">
					<div class="inner">
						<button onclick="fnAPPpopupBrowserURL('쿠폰함','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp');">
							<img src="//webimage.10x10.co.kr/fixevent/event/2021/110235/m/pop_fail2_last.png" alt="쿠폰함 가기">
						</button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'<!-- 팝업 - 이미 2번 응모후 세번째 응모 시(기본) -->%>
				<div id="resultover" class="popup" style="display:none;">
					<div class="inner">
						<button onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110211');return false;">
							<img src="//webimage.10x10.co.kr/fixevent/event/2021/110235/m/pop_fin.png" alt="2021 봄 정기세일">
						</button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'<!-- 팝업 - 이미 2번 응모후 세번째 응모 시(이벤트 마지막 날) -->%>
				<div id="resultover2" class="popup" style="display:none;">
					<div class="inner">
						<button onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110211');return false;">
							<img src="//webimage.10x10.co.kr/fixevent/event/2021/110235/m/pop_fin_last.png" alt="2021 봄 정기세일">
						</button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'<!-- 팝업 - 알람신청 -->%>
				<div id="lyrPush" class="popup" style="display:none;">
					<div class="inner">
						<button onclick="fnAPPpopupSetting();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110235/m/pop_push.png" alt="푸시 설정 확인하기"></button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<!-- //팝업 -->
			</div>
<% If IsUserLoginOK() Then %>
    <form method="post" name="directOrd" action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp">
        <input type="hidden" name="itemid" id="itemid" value="">
        <input type="hidden" name="itemoption" value="0000">
        <input type="hidden" name="itemea" readonly value="1">
        <input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
        <input type="hidden" name="isPresentItem" value="" />
        <input type="hidden" name="mode" value="DO3">
    </form>
<% end if %>



<%
'당첨 아이템 체크 (스텝계정)
if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="thensi7" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" or LoginUserid = "starsun726" then
	dim vQuery 
	vQuery = "SELECT convert(varchar(10),s.regdate,21) as regdate, o.option1, count(s.sub_opt2) as cnt" & vbCrLf
	vQuery = vQuery & " FROM [db_event].[dbo].[tbl_event_subscript] as S with(nolock)" & vbCrLf
	vQuery = vQuery & " left join [db_event].[dbo].[tbl_realtime_event_obj] as O with(nolock)" & vbCrLf
    vQuery = vQuery & " on s.evt_code=o.evt_code and s.sub_opt2=o.option5" & vbCrLf
    vQuery = vQuery & " where s.evt_code=" & eCode & vbCrLf
    vQuery = vQuery & " and s.sub_opt1='1'" & vbCrLf
	vQuery = vQuery & " group by s.sub_opt2, convert(varchar(10),s.regdate,21), o.option1" & vbCrLf
    vQuery = vQuery & " order by convert(varchar(10),s.regdate,21) asc, s.sub_opt2 asc" & vbCrLf
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		Do Until rsget.EOF
			response.write rsget(0) & " " & rsget(1) & "(" & rsget(2) & ")" & "<br>"
			rsget.MoveNext
		loop
	End IF
	rsget.close
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->