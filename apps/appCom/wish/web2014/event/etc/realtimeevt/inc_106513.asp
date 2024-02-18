<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/realtimeevent/RealtimeEventCls106513.asp" -->
<%
'####################################################
' Description : 19주년 이벤트 - 비밀의 책
' History : 2020.10.20 이종화
'####################################################
dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent , currentDateTime
dim isParticipation
dim numOfParticipantsPerDay, i
dim mktTest : mktTest = false

IF application("Svr_Info") = "Dev" THEN
	eCode = "103243"
	moECode = "103244"
Else
	eCode = "106513"
	moECode = "106512"
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isapp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2020-10-21")		'이벤트 시작일
eventEndDate 	= cdate("2020-10-29")		'이벤트 종료일
currentDate 	= date()
LoginUserid		= getencLoginUserid()

'// 테스트용 셋팅
if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" or LoginUserid = "bora2116" or LoginUserid = "tozzinet" then
	'// 테스트용 파라메터 
    if requestCheckVar(request("testCheckDate"),40) = "" then 
        currentDate = date()
    else
        currentDate = requestCheckVar(request("testCheckDate"),40)
        currentDateTime = right(currentDate,5)
        currentDate = Cdate(left(currentDate,10))
    end if 
    mktTest = true
end if

dim isSecondTried
dim isFirstTried
dim triedNum : triedNum = 0
dim isShared : isShared = False
isSecondTried = false

if LoginUserid <> "" then
	set pwdEvent = new RealtimeEventCls
	pwdEvent.evtCode = eCode
	pwdEvent.userid = LoginUserid
	isSecondTried = pwdEvent.isParticipationDayBase(2)  '당일 응모 내역 체크
	isFirstTried = pwdEvent.isParticipationDayBase(1)   '당일 응모 내역 체크
	isShared = pwdEvent.isSnsShared     '이벤트 공유여부 확인
end if

triedNum = chkIIF(isFirstTried, 1, 0)
triedNum = chkIIF(isSecondTried, 2, triedNum)

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("[텐바이텐 비밀의 책 이벤트]")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/19th/106513/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[비밀의 책 이벤트]"
Dim kakaodescription : kakaodescription = "책을 펼쳐서 캐릭터가 가장 많이 나온 분께 아이패드 드려요!"
Dim kakaooldver : kakaooldver = "책을 펼쳐서 캐릭터가 가장 많이 나온 분께 아이패드 드려요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/19th/106513/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& moECode
%>
<style>
.body-sub .content {padding-bottom:0;}
.mEvt106513 .topic,
.mEvt106513 .btn-try {background-color:#ffb841;}

.mEvt106513 .lyr {position:fixed; top:0; left:0; z-index:30; width:100%; height:100%; background:rgba(0,0,0,.8);}
.mEvt106513 .lyr .inner {position:absolute; top:50%; left:50%; width:86%; transform:translate(-50%,-50%);}
.mEvt106513 .lyr .btn-close {position:absolute; right:0; top:0; width:5rem; height:5rem; font-size:0; color:transparent; background-color:transparent;}
.mEvt106513 .lyr-result .inner {width:100%;}
.mEvt106513 .lyr-result .result {position:absolute; top:15.16vw; left:19.2%; width:66.5vw;}
.mEvt106513 .lyr-result .result .char-num {display:flex; justify-content:center; align-items:center; position:absolute; top:45.89vw; right:-11.97vw; width:32.99vw; height:32.19vw; background:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/106513/m/bg_number.png) no-repeat 50% 50%/contain; color:#fff; font-size:1.54rem; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; text-align:center;}
.mEvt106513 .lyr-result .result .char-num span {display:block; margin-top:.3rem; font-size:2.13rem;}
.mEvt106513 .lyr-result .result .char-num span em {font-size:2.69rem;}
.mEvt106513 .lyr-result .result .page-num {margin-top:5.2vw; font-size:1.19rem; color:#444; text-align:center; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.mEvt106513 .lyr-result .result .btn-rank {width:100%; height:3.5rem; margin-top:2rem; background-color:transparent; color:transparent;}
.mEvt106513 .lyr-result .btn-close {right:2rem;}

.mEvt106513 .loadingV19 {position:absolute; top:50%; left:50%; padding:0; background:none; transform:translate(-50%,-50%);}
.mEvt106513 .loadingV19 i {background:rgba(255,255,255,.5);}
.mEvt106513 .loadingV19 i::before {background:rgba(255,255,255,.8);}
.mEvt106513 .loadingV19 p {font-size:1.37rem; color:#fff;}

.mEvt106513 .winner {background-color:#ffe2a7;}
.mEvt106513 .winner .rank-list {position:relative; width:89.33%; margin:0 auto; padding:2.43rem 0; background-color:#fff; border-radius:.85rem;}
.mEvt106513 .winner .rank-list::after {content:''; position:absolute; bottom:2.75rem; left:50%; display:block; width:90.15%; height:2.9rem; margin:0 auto; background-color:#fff586; transform:translateX(-50%); z-index:1;}
.mEvt106513 .winner .rank-list table {position:relative; z-index:2; width:100%; text-align:center;}
.mEvt106513 .winner .rank-list th {padding-bottom:1.28rem; font-size:1.45rem; color:#f3a511; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.mEvt106513 .winner .rank-list td {padding:.85rem 0; font-size:1.45rem; color:#ff601b; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt106513 .winner .rank-list td:first-child {color:#000;}
.mEvt106513 .winner .rank-list .my-rank td:first-child {position:relative;}
.mEvt106513 .winner .rank-list .my-rank td:first-child::before {content:''; display:inline-block; position:absolute; top:-1.54rem; left:-.85rem; width:4.95rem; height:2.65rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/106513/m/txt_my_rank.png) no-repeat 50% 50%/100%;}
</style>
<script>
$(function() {
    $('.mEvt106513 .lyr').hide();
	$('.mEvt106513 .lyr').on('click', function(e) {
		if ($(e.target).hasClass('lyr')) $(e.target).fadeOut();
		$('.loadingV19').remove();
	});
	$('.mEvt106513 .lyr .btn-close').on('click', function(e) {
		$(this).closest('.lyr').fadeOut();
		$('.loadingV19').remove();
	});

	$('.mEvt106513 .btn-rank').on('click', function(e) {
		var val = $('.winner').offset();
		$(this).closest('.lyr').fadeOut();
		$('.loadingV19').remove();
		$('html,body').animate({scrollTop:val.top},200);
	});
    
    getWinners();
    setTimeout( function() {
        getMyWinners();    
    }, 300);
});

function popLoading(lyr) {
	var loading = '<div class="loadingV19"><i></i><p>책 펼치는 중</p></div>';
	lyr.children('.inner').hide();
	lyr.prepend(loading);
	lyr.fadeIn(function() {
		lyr.children('.inner').delay(800).fadeIn();
	});
}

var numOfTry = '<%=triedNum%>';
var isShared = "<%=isShared%>";
var couponClick = 0;

function getWinners(){
	$.ajax({
		type:"GET",
		url:"/event/etc/realtimeevent/RealtimeEvent106513Proc.asp",
		dataType: "JSON",
		data: { mode: "winnerrank" },
		success : function(res){
			renderWinners(res.data)
		},
		error:function(err){
			alert("잘못된 접근 입니다.[0]");
			return false;
		}
	});
}

function getMyWinners(){
	$.ajax({
		type:"GET",
		url:"/event/etc/realtimeevent/RealtimeEvent106513Proc.asp",
		dataType: "JSON",
		data: { mode: "winnermy" },
		success : function(res){
			renderMyWinners(res.data)
		},
		error:function(err){
			alert("잘못된 접근 입니다.[0]");
			return false;
		}
	});
}

function printUserName(name, num, replaceStr){
	<% if GetLoginUserLevel = "7" then %>
		return name
	<% else %>
		return name.substr(0,name.length - num) + replaceStr.repeat(num)
	<% end if %>
}

function renderWinners(data){
    var $rootEl = $("#winners");
    var itemEle = tmpEl = ""
    $rootEl.empty();

    var i = 0;
    data.forEach(function(winner){
        tmpEl = '<tr>\
                    <td>'+ winner.ranking +'</td>\
                    <td>'+ printUserName(winner.userid, 2, "*") +'님' +'</td>\
                    <td>'+ winner.code +'</td>\
                </tr>\
        '
        itemEle += tmpEl
        i += 1
    })

    if ( i < 5 ) {
        for( ii = i ; ii < 5 ; ii++) {
            tmpEl = '<tr>\
                    <td>'+ parseInt(ii+1) +'</td>\
                    <td>-</td>\
                    <td>-</td>\
                </tr>'
            
            itemEle += tmpEl
        }
    }
    
    $rootEl.append(itemEle);
}

function renderMyWinners(data){
    var $rootEl = $("#winners");
    var itemEle = tmpEl = ""

    if (data.length > 0) {
        data.forEach(function(winner){
            tmpEl = '<tr class="my-rank">\
                        <td>'+ winner.ranking +'</td>\
                        <td>'+ printUserName(winner.userid, 2, "*") +'님' +'</td>\
                        <td>'+ winner.code +'</td>\
                    </tr>\
            '
            itemEle += tmpEl
        })    
    } else {
        tmpEl = '<tr class="my-rank">\
                    <td>-</td>\
                    <td>-</td>\
                    <td>-</td>\
                </tr>\
        '
        itemEle += tmpEl
    }
    
    $rootEl.append(itemEle);
}

function eventTry(){
	<% If Not(IsUserLoginOK) Then %>
		calllogin();
		return false;
    <% else %>
        popLoading($('#lyrWin1'));
		<% If (currentDate >= eventStartDate And currentDate <= eventEndDate) Then %>
        var s = 1;
//========\
		if(numOfTry == '1' && isShared != "True"){
			// 한번 시도
			$("#secondTry").show();
			return false;
		}
		if(numOfTry == '2'){
			$('#trylimit').show();
			return false;
		}
//=============		
		var returnCode, itemid, data
		var data = {
			mode : "add",
            selectedPdt : s,
            <% if mktTest then %>
            testCheckDate : "<%=requestCheckVar(request("testCheckDate"),40)%>",
            testPercent : "<%=requestCheckVar(request("testPercent"),3)%>"
            <% end if %>
		}
		$.ajax({
			type:"POST",
			url:"/event/etc/realtimeevent/RealtimeEvent106513Proc.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
				fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|option1','<%=eCode%>|' + s)
					if(res!="") {
						//console.log(res)
						if(res.response == "ok"){
                            $("#resultPopup .thumb").find('img').attr("src","//webimage.10x10.co.kr/fixevent/event/2020/19th/106513/m/img_pg"+res.imageNumber+".png")
                            $("#resultPopup .char-num").find('em').text(res.selectedPdt);
                            $("#resultPopup .page-num").text('- '+res.pageNumber+' -')
                            popResult(res.returnCode, res.winItemid, res.selectedPdt, res.md5userid);

                            getWinners();

                            setTimeout(function() {
                                getMyWinners();    
                            }, 300);
							return false;
						}else{
							alert(res.faildesc);
							return false;
						}
					} else {
						alert("잘못된 접근 입니다[0].");
						document.location.reload();
						return false;
					}
			},
			error:function(err){
				console.log(err)
				alert("잘못된 접근 입니다[1].");
				return false;
			}
		});
		<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% End If %>
	<% End If %>
}

function popResult(returnCode, itemid, selectedPdt, md5userid){
	numOfTry++
	if(returnCode[0] == "B"){		
		popLoading($("#resultPopup"));
	}else if(returnCode[0] == "C"){		
        popLoading($("#resultPopup"));
	}else if(returnCode == "A02"){
		numOfTry = 2
        popLoading($("#trylimit"));
	}else if(returnCode == "A03"){
		alert("오픈된 상품이 아닙니다.");
	}
}

function sharesns(snsnum) {		
	$.ajax({
		type: "GET",
		url:"/event/etc/realtimeevent/RealtimeEvent106513Proc.asp",
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

function jsPickingUpPushSubmit(){

    fnAmplitudeEventMultiPropertiesAction('click_event_apply','eventcode|actype','<%=ecode%>|alarm','');

    <% If not(IsUserLoginOK) Then %>
        parent.calllogin();
        return false;
    <% end if %>

    $.ajax({
        type:"GET",
        url:"/event/etc/realtimeevent/RealtimeEvent106513Proc.asp?mode=pushadd",
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
<div class="mEvt106513">
    <div class="topic">
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106513/m/tit_book.jpg" alt="비밀의 책"></h2>
        <button class="btn-try" onclick="eventTry()"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106513/m/btn_submit.jpg" alt="책펼치기"></button>
        <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106513/m/txt_info_v2.jpg" alt="이벤트 정보"></div>
    </div>

    <%'!-- 팝업 :책펼치기 --%>
    <div id="resultPopup" class="lyr lyr-result" style="display:none">
        <div class="inner">
            <div class="result">
                <div class="thumb"><img src="" alt=""></div>
                <div class="char-num"><p>캐릭터<span><em>0</em>개</span></p></div>
                <div class="page-num">- 233 -</div>
                <button class="btn-rank">내 순위 확인하기</button>
            </div>
            <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106513/m/img_book.png" alt=""></div>
            <button type="button" class="btn-close">닫기</button>
        </div>
    </div>

    <%'1등 당첨 리스트 %>
    <div class="winner">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106513/m/tit_rank.jpg" alt="나의 순위는?"></h3>
        <div class="rank-list">
            <table>
                <colgroup>
                    <col width="33.33%">
                    <col width="*">
                    <col width="33.33%">
                </colgroup>
                <thead>
                    <tr>
                        <th scope="col">순위</th>
                        <th scope="col">아이디</th>
                        <th scope="col">캐릭터 개수</th>
                    </tr>
                </thead>
                <tbody id="winners"></tbody>
            </table>
        </div>
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106513/m/txt_caution.jpg" alt=""></p>
    </div>

    <button type="button" id="btnPush" onclick="jsPickingUpPushSubmit()" class="btn-push">
        <% '<!-- 알림 신청 마지막날 --> %>
        <% If currentDate >= eventEndDate Then %>
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106513/m/btn_alarm2.jpg" alt="알림 신청하기(마지막날)">
        <% '<!-- 알림 신청 --> %>
        <% else %>
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106513/m/btn_alarm1.jpg" alt="알림 신청하기">
        <% end if %>
    </button>

    <div id="winnerPopup1" class="lyr" style="display:none">
        <div class="inner">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106206/m/pop_win_01.png" alt="방구석 영화관 세트 당첨">
            <button type="button" class="btn-close">닫기</button>
        </div>
    </div>
    
    <div id="winnerPopup2" class="lyr" style="display:none">
        <div class="inner">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106206/m/pop_win_02.png" alt="왓챠 이용권 당첨">
            <button type="button" class="btn-close">닫기</button>
        </div>
    </div>

    <div id="secondTry" class="lyr" style="display:none">
        <div class="inner">
            <button type="button" onclick="sharesns('kt');"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106513/m/pop_already.png" alt="이미"></button>
            <button type="button" class="btn-close">닫기</button>
        </div>
    </div>
    
    <div id="trylimit" class="lyr" style="display:none">
        <div class="inner">
            <% If currentDate >= eventEndDate Then %>
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106513/m/pop_fin_last.png?v=1.01" alt="끝">
            <% else %>
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106513/m/pop_fin.png" alt="내일">
            <% end if %>
            <button type="button" class="btn-close">닫기</button>
        </div>
    </div>
    
    <div id="lyrPush" class="lyr" style="display:none">
        <div class="inner">
            <button type="button" onclick="fnAPPpopupSetting();return false;">
                <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106513/m/pop_push.png" alt="푸시 설정 확인하기">
            </button>
            <button type="button" class="btn-close">닫기</button>
        </div>
    </div>

    <div class="notice"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106513/m/txt_noti_v2.jpg" alt="유의사항"></div>
    <a href="" onclick="fnAPPpopupBrowserURL('19주년','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/19th/');return false;">
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106513/m/bnr_19th.jpg" alt="19주년">
    </a>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->