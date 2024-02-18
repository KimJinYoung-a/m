<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/realtimeevent/templateRealtimeCls.asp" -->
<%
'####################################################
' Description : 줍줍 이벤트 - 마샬
' History : 2020.07.22 정태훈
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent
dim isParticipation
dim numOfParticipantsPerDay, i

IF application("Svr_Info") = "Dev" THEN
	eCode = "102198"
	moECode = "102197"
Else
	eCode = "104374"
	moECode = "104373"
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isapp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2020-07-27")		'이벤트 시작일
eventEndDate 	= cdate("2020-08-02")		'이벤트 종료일
currentDate 	= date()
LoginUserid		= getencLoginUserid()

if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" then
	currentDate = #07/27/2020 09:00:00#
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
	isSecondTried = pwdEvent.isParticipationDayBase(2)
	isFirstTried = pwdEvent.isParticipationDayBase(1)
	isShared = pwdEvent.isSnsShared
end if

triedNum = chkIIF(isFirstTried, 1, 0)
triedNum = chkIIF(isSecondTried, 2, triedNum)

function WeekKor(weeknum)
    if weeknum="1" then
        WeekKor="일"
    elseif weeknum="2" then
        WeekKor="월"
    elseif weeknum="3" then
        WeekKor="화"
    elseif weeknum="4" then
        WeekKor="수"
    elseif weeknum="5" then
        WeekKor="목"
    elseif weeknum="6" then
        WeekKor="금"
    elseif weeknum="7" then
        WeekKor="토"
    end if
end function

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("[줍줍이벤트]")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/104374/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[줍줍이벤트]"
Dim kakaodescription : kakaodescription = "모두의 로망 마샬 스피커를 100원에 판매 중! 지금 1초만에 도전해보세요."
Dim kakaooldver : kakaooldver = "모두의 로망 마샬 스피커를 100원에 판매 중! 지금 1초만에 도전해보세요."
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/104374/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& moECode
%>
<style>
.bnr-anniv18 {display:none;}

.evt-jupjup {position:relative; overflow:hidden; background:#f7f7f7}
.evt-jupjup h2 {position:absolute; font-size:0; color:transparent}
.evt-jupjup button {font:inherit; background:none}

.evt-jupjup .prd-img {position:relative; text-align:center; background:#fff}
.evt-jupjup .prd-img img {width:32rem;}
.evt-jupjup .prd-img a {position:absolute; top:0; left:0; width:100%; height:100%; font-size:0; color:transparent}
.evt-jupjup .limit-bar {height:2em; padding-top:.1em; line-height:2; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; font-size:1.37rem; color:#fff; background:#222; text-align:center; letter-spacing:.05em}
.evt-jupjup .prd-info .prd-name {padding:.9em 1.5rem .6em; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; font-size:1.8rem; line-height:1.3}
.evt-jupjup .prd-info .prd-price {padding:0 1.5rem 2rem; text-align:right}
.evt-jupjup .prd-info .prd-price .o-price {display:block; margin-bottom:.3em; font-size:1.54rem; color:#999}
.evt-jupjup .prd-info .prd-price .o-price dfn {font-size:0; color:transparent}
.evt-jupjup .prd-info .prd-price .set-price {font-family:'CoreSansCBold', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; color:#ff377e}
.evt-jupjup .prd-info .prd-price .set-price dfn {margin-right:0.3em; font-size:1.28rem}
.evt-jupjup .prd-info .prd-price .set-price b {font-size:2.56rem}

.evt-jupjup .btn-area {position:relative; display:flex; justify-content:space-between; height:4.7rem; padding:0 1.7rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; font-size:1.54rem;}
.evt-jupjup .btn-area.fixed {position:fixed; z-index:21;}
.evt-jupjup .btn-area button {color:#fff;}
.evt-jupjup .btn-area .btn-try {flex:1 1 100%; padding-top:.1rem; background:#ff377e; border-radius:.85rem; word-break:keep-all;}
.evt-jupjup .btn-area .btn-try[disabled] {background:#8d8d8d;}
.evt-jupjup .btn-area .btn-share {flex:0 0 4.6rem; margin-left:0.4rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/104374/m/ico_share.png) center no-repeat; background-size:50%; font-size:0; color:transparent;}

.evt-jupjup .evt-info {margin-top:3rem; font-size:1.2rem; color:#444; line-height:1.6;}
.evt-jupjup .evt-info dl {padding:.1rem 0;}
.evt-jupjup .evt-info dt {padding-left:1.5rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.evt-jupjup .evt-info dd {word-break:keep-all;}
.evt-jupjup .evt-info dl.row {display:flex;}
.evt-jupjup .evt-info dl.row dt {flex:0 0 26%;}
.evt-jupjup .evt-info dl.notice {margin:.8rem 0 1rem;}
.evt-jupjup .evt-info .btn-notice {padding:0 .3rem 0 0; line-height:1.2; border-bottom:1px solid #444}
.evt-jupjup .evt-info .btn-notice::after {content:' '; display:inline-block; width:0.4rem; height:0.4rem; margin:0 0 .3rem .5rem; border:solid #444; border-width:0 2px 2px 0; transform:rotate(45deg)}
.evt-jupjup .evt-info .btn-notice.open::after {margin:0 0 0 .5rem; transform:rotate(-135deg)}
.evt-jupjup .evt-info .notice-list {display:none}
.evt-jupjup .evt-info .notice-list ul {padding:.8rem 1.5rem 0}
.evt-jupjup .evt-info .notice-list li {position:relative; padding-left:.8rem}
.evt-jupjup .evt-info .notice-list li::before {content:'-'; position:absolute; top:0; left:0}

.evt-jupjup .winner-list {position:relative; margin-top:.8rem;}
.evt-jupjup .winner-list .no-winner {display:flex; justify-content:center; align-items:center; font-size:1.1rem; color:#999;}
.evt-jupjup .winner-list .winner-slider {padding:0 1.5rem;}
.evt-jupjup .winner-list .swiper-slide {width:5.7rem; margin:0 .5rem;}
.evt-jupjup .winner-list .user-info {text-align:center; font-size:1rem; line-height:1.4;}
.evt-jupjup .winner-list .user-info > span {display:block;}
.evt-jupjup .winner-list .user-info .user-grade {margin-bottom:0.5rem;}
.evt-jupjup .winner-list .user-info .user-id {font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}

.evt-jupjup .title-h3 {font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; font-size:1.7rem; color:#222; line-height:1.3;}
.evt-jupjup .alarm {padding:4rem 1.7rem 3rem;}
.evt-jupjup .alarm .btn-alarm {width:13.65rem; height:3.4rem; padding-top:.3rem; margin-top:1.5rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; font-size:1.28rem; color:#fff; background:#704aff; border-radius:.85rem;}
.evt-jupjup .alarm .btn-alarm span::after {content:' '; display:inline-block; width:0.4rem; height:0.4rem; margin:0 0 .2rem .5rem; border:solid #fff; border-width:0 2px 2px 0; transform:rotate(-45deg);}
.evt-jupjup .guide {padding:3rem 1.7rem 5rem;}
.evt-jupjup .guide .link {display:inline-block; padding:1rem .3rem 0 0; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; font-size:1.28rem; color:#222; line-height:1.2; border-bottom:1px solid #222;}
.evt-jupjup .guide .link::after {content:' '; display:inline-block; width:0.4rem; height:0.4rem; margin:0 0 .2rem .2rem; border:solid #222; border-width:0 2px 2px 0; transform:rotate(-45deg);}

.evt-jupjup .lyr {display:none; position:fixed; top:0; left:0; z-index:50; width:100%; height:100%; background:rgba(222,222,222,0.9);}
.evt-jupjup .lyr .inner {position:absolute; top:50%; left:50%; width:28.6rem; transform:translate(-50%,-50%);}
.evt-jupjup [class*=lyr] .btn-close {position:absolute; right:0; top:0; width:5rem; height:5rem; font-size:0;color:transparent;}
.evt-jupjup .lyr-alarm {display:none; overflow-y:auto; position:fixed; top:0; left:0; z-index:50; width:100%; height:100%; background:rgba(0,0,0,0.9);}
.evt-jupjup .lyr-alarm .inner {position:relative; width:32rem; margin:0 auto; padding:0 1.7rem;}
.evt-jupjup .lyr-alarm .text {padding:9rem 0 0; font-size:2.3rem; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; color:#fff; line-height:1.4;}
.evt-jupjup .lyr-alarm .btn-close {position:fixed; top:2%; background:url(//webimage.10x10.co.kr/fixevent/event/2020/104374/m/ico_close.png) center no-repeat; background-size:40%;}
.evt-jupjup .form {display:flex; align-items:baseline; margin-top:6rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; font-size:2rem; color:#ff377e;}
.evt-jupjup .form input {width:5.4rem; height:3.4rem; padding:0; font-size:1.8rem; color:#cbcbcb; background:none; border:solid #ff377e; border-width:0 0 .17rem; border-radius:0; text-align:center;}
.evt-jupjup .form .btn-submit {margin-left:1rem; padding:0.2rem 1rem 0; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; font-size:1.8rem; color:#ff377e; line-height:normal;}
</style>
<script>
$(function(){
	// notice
	controlArrow();
	$('#btn_notice').click(function() {
		$("#notice_list").toggle();
		controlArrow();
	});
	// alarm popup
	$('#btn_alarm').click(function() {
		$('.lyr-alarm').fadeIn();
	});

	// close popup (mask)
	$('.evt-jupjup .lyr').click(function(e){
		if ($(e.target).hasClass('lyr')) $(e.target).fadeOut();
	});
	// close popup (btn)
	$('.evt-jupjup [class*=lyr] .btn-close').click(function() {
		$(this).parent().parent().fadeOut();
	});
});
function controlArrow() {
	var state = $("#notice_list").is(':visible');
	if (state)	$("#btn_notice").addClass('open');
	else	$("#btn_notice").removeClass('open');
}

var userPwd = "";
var numOfTry = '<%=triedNum%>';
var isShared = "<%=isShared%>";
var couponClick = 0;

$(function(){
	getEvtItemList();
	getWinners();
});

function getEvtItemList(){
	$.ajax({
		type: "GET",
		url:"/event/etc/realtimeevent/tempRealtimeEventProc.asp",
		data: "mode=evtobj",
		dataType: "json",
		success: function(res){
			 //console.log(res.data)
			renderList(res.data)
		}
	})
}

function renderList(itemList){
	var $rootEl = $("#itemList")
	var itemEle = tmpEl = tmpCls = info = ""
    $rootEl.empty();
    <%'// 오픈 리스트 %>
	if(itemList.length > 0){
        //var newArr = itemList.filter(function(el){return el.leftItems != 0}).concat(itemList.filter(function(el){return el.leftItems == 0}))
        var newArr = itemList
		newArr.forEach(function(item){
            tmpCls = item.leftItems <= 0 ? "soldout" : ""
            tmpEl = '\
                <div class="prd-img">\
                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/104374/m/img_item.jpg?v=1.05" alt="'+ item.itemName +'">\
                </div>\
                <div class="limit-bar">' + item.leftItems + '개 남았습니다</div>\
                <dl class="prd-info">\
                    <dt class="prd-name">'+ item.itemName +' '+ item.itemOption +'</dt>\
                    <dd class="prd-price">\
                        <s class="o-price"><dfn>원가</dfn>'+ item.itemPrice +'원</s>\
                        <span class="set-price"><dfn>이벤트가</dfn><b>'+ item.eventPrice +'원</b></span>\
                    </dd>\
                </dl>\
            '
		    itemEle += tmpEl;
            $("#stp").val(item.itemCode);
        });
	}
	<%'// 대기 리스트 %>
	$rootEl.append(itemEle)
}

function getWinners(){
	$.ajax({
		type:"GET",
		url:"/event/etc/realtimeevent/tempRealtimeEventProc.asp",
		dataType: "JSON",
		data: { mode: "winner" },
		success : function(res){		
			renderWinners(res.data)
		},
		error:function(err){
			console.log(err)
			alert("잘못된 접근 입니다.");
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
	var $rootEl = $("#winners")
	var itemEle = tmpEl = ""
	$rootEl.empty();

	data.forEach(function(winner){
		tmpEl = '<li class="swiper-slide">\
                    <div class="user-info">\
                        <span class="user-grade"><img src="//fiximage.10x10.co.kr/m/2018/common/' + winner.userlevelimg + '" alt=""></span>\
                        <span class="user-id">' + printUserName(winner.userid, 2, "*") + '</span>\
                        <span class="user-name">' + printUserName(winner.username, 1, "*") + '</span>\
                    </div>\
		        </li>\
		'
		itemEle += tmpEl
	});
    $rootEl.append(itemEle)

	// winner slider
	if ( $('#winner_slider').find('.swiper-slide').length > 0 ) {
		var swiper = new Swiper('#winner_slider', {
			slidesPerView: 'auto'
		});
	} else {
		$('#winner_list').prepend('<p class="no-winner">당첨자가 없습니다.</p>');
	}
}

function eventTry(){
    
	<% If Not(IsUserLoginOK) Then %>
		calllogin();
		return false;
	<% else %>
		<% If (currentDate >= eventStartDate And currentDate <= eventEndDate) Then %>
        var s;
        s=$("#stp").val();
//========\
		if(numOfTry == '1' && isShared != "True"){
            // 한번 시도
			$("#secondTry").show();            
			return false;
		}
		if(numOfTry == '2'){
			<% If (currentDate >= #08/03/2020 00:00:00#) Then %>
			$('#resultover2').show();
			<% else %>
			$('#trylimit').show();
			<% end if %>
			return false;
		}
        
//=============		
		var returnCode, itemid, data
		var data={
			mode: "add",
			selectedPdt: s
		}
		$.ajax({
			type:"POST",
			url:"/event/etc/realtimeevent/tempRealtimeEventProc.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
				fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|option1','<%=eCode%>|' + s)
					if(res!="") {
						// console.log(res)
						if(res.response == "ok"){
							popResult(res.returnCode, res.winItemid, res.selectedPdt, res.md5userid);
							getEvtItemList();
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

function popResult(returnCode, itemid, selectedPdt, md5userid){
	numOfTry++
	if(returnCode[0] == "B"){		
		if(numOfTry >= 2){
			<% If (currentDate >= #08/03/2020 00:00:00#) Then %>
			$("#result4").show();
			<% else %>
			$("#result3").show();
			<% end if %>
			return false;
		}
		$("#fail1").show();
	}else if(returnCode[0] == "C"){		
        <%'<-- 당첨 -->%>
		$("#itemid").val(itemid);	
        $("#winImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2020/104374/m/pop_win.png?v=1.01")
        $("#useridmd5").empty().html(md5userid)
		$("#winnerPopup").show();
	}else if(returnCode == "A02"){
		numOfTry = 2
        $("#trylimit").show();
	}else if(returnCode == "A03"){
		alert("오픈된 상품이 아닙니다.");
	}
}

function goDirOrdItem(){
<% If IsUserLoginOK() Then %>
	<% If (currentDate >= eventStartDate And currentDate <= eventEndDate) Then %>		
		document.directOrd.submit();
	<% else %>
		alert("이벤트 응모 기간이 아닙니다.");
		return;
	<% end if %>
<% End IF %>
}

function sharesns(snsnum) {		
	$.ajax({
		type: "GET",
		url:"/event/etc/realtimeevent/tempRealtimeEventProc.asp",
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

function fnSendToKakaoMessage() {    
    if ($("#phone1").val() == '') {
        alert('알림 받으실 전화번호를 정확히 입력해 주세요.');
        $("#phone1").focus();
        return;
    }

    if ($("#phone2").val() == '') {
        alert('알림 받으실 전화번호를 정확히 입력해 주세요.');
        $("#phone2").focus();
        return;
    }

    if ($("#phone3").val() == '') {
        alert('알림 받으실 전화번호를 정확히 입력해 주세요.');
        $("#phone3").focus();
        return;
    }
    
    var phoneNumber = $("#phone1").val()+ "-" +$("#phone2").val()+ "-" +$("#phone3").val();
    $.ajax({
        type:"post",
        url:"/event/etc/realtimeevent/tempRealtimeEventProc.asp",
        data: "mode=kamsg&phoneNumber="+btoa(phoneNumber),
        dataType: "json",
        success : function(result){
            if(result.response == "ok"){
                $("#lyrAlarm").fadeOut();
                alert('신청 되었습니다.')
                return false;
            }else{
                alert(result.faildesc);
                $("#lyrAlarm").fadeOut();
                return false;
            }
        },
        error:function(err){
            console.log(err);
            return false;
        }
    })
}

function maxLengthCheck(object){
    if (object.value.length > object.maxLength){
        object.value = object.value.slice(0, object.maxLength);
    }
}
</script>
			<div class="evt-jupjup">
				<h2>줍줍 이벤트</h2>
				<!-- for dev msg : 상품 -->
				<div class="prd-wrap" id="itemList"></div>
				<div class="btn-area">
					<% If currentDate > eventEndDate Then %>
                        <button type="button" class="btn-try" disabled="disabled">기간이 종료되었습니다</button>
					<% else %>
						<button type="button" id="btn_try" class="btn-try" onclick="eventTry();">이벤트 도전하기</button>
                    <% end if %>
					<button type="button" class="btn-share" onclick="sharesns('kt');">공유하기</button>
				</div>
				<div class="evt-info">
					<dl class="row">
						<dt>이벤트 기간</dt>
						<dd><%=formatdate(eventStartDate,"00.00")%>(<%=WeekKor(weekday(eventStartDate))%>) - <%=formatdate(eventEndDate,"00.00")%>(<%=WeekKor(weekday(eventEndDate))%>)</dd>
					</dl>
					<dl class="row">
						<dt>이벤트 내용</dt>
						<dd>하루에 두 번 응모할 수 있으며, 당첨된 고객은<br> 위 상품을 구매할 수 있습니다.</dd>
					</dl>
					<dl class="row">
						<dt>당 첨 인 원</dt>
						<dd>10명<br>당첨자에게는 상품 후기를 요청할 예정입니다.</dd>
					</dl>
					<dl class="notice">
						<dt><button type="button" id="btn_notice" class="btn-notice">유의사항 확인하기</button></dt>
						<dd id="notice_list" class="notice-list">
							<ul>
								<li>본 이벤트는 해당 상품 브랜드와 무관한 이벤트임을 알려드립니다</li>
								<li>ID 당 1일 최대 2회 응모 가능합니다.</li>
								<li>당첨자 선정은 실시간 랜덤 방식으로 진행됩니다.</li>
								<li>당첨되었으나 이벤트 기간 내 구매하지 않을 경우, 이벤트 종료 후에는 품절 처리되어 구매가 불가합니다.</li>
								<li>모든 수량이 소진되면 이벤트는 종료됩니다.</li>
								<li>5만 원 이상 상품의 당첨자에게는 세무 신고를 위해 개인 정보를 요청할 예정이며, 제세공과금은 텐바이텐 부담입니다.</li>
								<li>이벤트 당첨이 아닌 비정상적인 방법으로 상품을 구매할 시 상품 발송이 불가합니다.</li>
							</ul>
						</dd>
					</dl>
					<dl class="winner">
						<dt>당첨자 리스트</dt>
						<dd id="winner_list" class="winner-list">
							<div id="winner_slider" class="winner-slider swiper-container">
								<ul class="swiper-wrapper" id="winners"></ul>
							</div>
						</dd>
					</dl>
				</div>
				<!-- for dev msg : 알림 신청 -->
				<div class="alarm">
				<% If currentDate >= eventEndDate Then %>
                    <h3 class="title-h3">다음 이벤트가 오픈되면<br>알려드립니다!</h3>
                <% else %>
                    <h3 class="title-h3">알림 신청하면<br>내일도 잊지 않게 알려드려요.</h3>
                <% end if %>
                    <button type="button" id="btn_alarm" class="btn-alarm"><span>알림 신청하기</span></button>
				</div>
				<div class="guide">
					<h3 class="title-h3">텐바이텐이 처음이라면?</h3>
					<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=102465');" class="link" target="_blank">입문자용 가이드 보러가기</a>
				</div>

				<div id="lyrAlarm" class="lyr-alarm" style="display:none">
					<div class="inner">
						<p class="text">전화번호를 입력하면<br>다음 날 오전 10시에<br>카카오 알림톡 또는<br>문자메시지로 알려드립니다.</p>
						<!-- for dev msg : 마지막날 (8/2)
							<p class="text">다음 이벤트가 오픈되면<br>카카오 알림톡 또는<br>문자메시지로<br>빠르게 알려드립니다.</p> -->
						<div class="form">
							<input type="number" id="phone1" maxlength="3" placeholder="000" oninput="maxLengthCheck(this)">
							<span>-</span>
							<input type="number" id="phone2" maxlength="4" placeholder="0000" oninput="maxLengthCheck(this)">
							<span>-</span>
							<input type="number" id="phone3" maxlength="4" placeholder="0000" oninput="maxLengthCheck(this)">
							<button type="button" onclick="fnSendToKakaoMessage()" class="btn-submit">확인</button>
						</div>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<!-- 팝업 : 당첨 -->
				<div id="winnerPopup" class="lyr" style="display:none">
					<div class="inner">
						<a href="" onclick="goDirOrdItem();return false;">
							<img id="winImg" alt="당첨을 축하드립니다!">
						</a>
					</div>
				</div>
				<%'<!-- 팝업  꽝 : 첫 번째 응모 시 -->%>
				<div id="fail1" class="lyr" style="display:none">
					<div class="inner">
						<!-- 카카오톡 공유 -->
						<button type="button" onclick="sharesns('kt');">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/104374/m/pop_fail1.png" alt="꽝1">
						</button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'<!-- 팝업 꽝 : 공유 하지않고 두번째 응모 시 -->%>
				<div id="secondTry" class="lyr" style="display:none">
					<div class="inner">
						<!-- 카카오톡 공유 -->
						<button type="button" onclick="sharesns('kt');">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/104374/m/pop_already.png" alt="이미">
						</button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'<!-- 팝업 꽝 : 공유 후 두번째 응모 시 -->%>
				<div id="result3" class="lyr" style="display:none">
					<div class="inner">
						<a href="" onclick="fnAPPpopupBrowserURL('쿠폰함','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp');" target="_blank">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/104374/m/pop_fail2.png" alt="꽝2">
						</a>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'<!-- 결과: 두번째 시도 -> 꽝(마지막날) -->%>
				<div id="result4" class="lyr" style="display:none">
					<div class="inner">
						<a href="" onclick="fnAPPpopupBrowserURL('쿠폰함','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp');" target="_blank">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/104374/m/pop_fail2_last.png" alt="꽝2">
						</a>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'<!-- 팝업 6. 두번 응모 완료 -->%>
				<div id="trylimit" class="lyr" style="display:none">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/104374/m/pop_fin.png" alt="내일">
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'!-- 팝업 : 응모 횟수 초과 마지막날 --%>
				<div id="resultover2" class="lyr" style="display:none">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/104374/m/pop_fin_last.png" alt="끝">
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
			</div>
<% If IsUserLoginOK() Then %>
    <form method="post" name="directOrd" action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp">
        <input type="hidden" name="itemid" id="itemid" value="">
        <input type="hidden" name="itemoption" value="0000">
        <input type="hidden" name="itemea" readonly value="1">
        <input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
        <input type="hidden" name="isPresentItem" value="" />
        <input type="hidden" name="mode" value="DO3">
        <input type="hidden" name="stp" id="stp">
    </form>
<% end if %>
<!-- #include virtual="/lib/db/dbclose.asp" -->