<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/drawevent/DrawEventCls.asp" -->
<%
'####################################################
' Description : 100원 자판기
' History : 2020-02-11 이종화
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode
dim drawEvt, isParticipation
dim numOfParticipantsPerDay, i
dim prd1, prd2, prd3, prd4, prd5, prd6, prd7, prd8, prd9, prd10
dim testParameter

IF application("Svr_Info") = "Dev" THEN
	eCode = "90466"	
Else
	eCode = "100597"
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30) 

IF application("Svr_Info") <> "Dev" THEN
    IF isapp <> "1" THEN
        Response.redirect "/event/eventmain.asp?eventid=100596&gaparam="&gaparamChkVal
        Response.End
    END IF
END IF

eventStartDate  = cdate("2020-02-17")		'이벤트 시작일 
eventEndDate 	= cdate("2020-02-29")		'이벤트 종료일
currentDate 	= date()
LoginUserid		= getencLoginUserid()

' 테스트용
IF LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="thensi7" or LoginUserid = "motions" Then
    dim adminWinPercent : adminWinPercent = requestCheckVar(request("adminWinPercent"),4) '// 확률
    dim adminCurrentDate : adminCurrentDate = requestCheckVar(request("adminCurrentDate"),10) '// 당첨일 선정
    eventStartDate = date()

    testParameter = "&adminCurrentDate="&adminCurrentDate&"&adminWinPercent="&adminWinPercent
END IF

dim sqlStr
    sqlStr = sqlStr & " select  (SELECT 1 - count(1) as pdt1 FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2721350)) as '에어팟' "
    sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt2 FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2721505)) as '아이패드' "
    sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt3 FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2721559)) as '애플워치' "
    sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt4 FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2721570)) as '맥북에어' "
    sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt5 FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2721577)) as '마샬스피커' "
    sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt6 FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2721592)) as '갤럭시버즈' "
    sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt7 FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2721723)) as '카카오미니' "

    rsget.CursorLocation = adUseClient
    rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
        prd1 = rsget("에어팟") ' 에어팟 프로
        prd2 = rsget("아이패드") ' 아이패드 mini 64GB 실버
        prd3 = rsget("애플워치") ' Apple Watch Series 5 스페이스 그레이 알루미늄 케이스, 그리고 스포츠 밴드 40mm
        prd4 = rsget("맥북에어") ' MacBook Air 13형
        prd5 = rsget("마샬스피커") ' 마샬 액톤2 스피커 블랙
        prd6 = rsget("갤럭시버즈") ' 라인프렌즈 빔 프로젝터
        prd7 = rsget("카카오미니") ' 카카오미니 AI 스피커
    rsget.close

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg , appfblink
snpTitle	= Server.URLEncode("[놓치면 후회하는 100원 자판기]")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=100596")
snpPre		= Server.URLEncode("이런 뽑기가 있다구? 뽑기에 성공하면 엄청난 상품이 100원!")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/100597/kakao_v2.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid=100597"

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[놓치면 후회하는 100원 자판기]"
Dim kakaodescription : kakaodescription = "이런 뽑기가 있다구? 뽑기에 성공하면 엄청난 상품이 100원!"
Dim kakaooldver : kakaooldver = "[놓치면 후회하는 100원 자판기] 이런 뽑기가 있다구? 뽑기에 성공하면 엄청난 상품이 100원!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/100597/kakao_v2.jpg"
Dim kakaolink_url 
If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=100597"
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid=100596"
End If

set drawEvt = new DrawEventCls
drawEvt.evtCode = eCode
drawEvt.userid = getencLoginUserid
%>
<style type="text/css">
.mEvt100597 {position:relative; overflow:hidden; background:#accdff;}
.mEvt100597 button {background:none;}
.machine {position:relative;}
.machine .item-list {position:absolute; left:0; top:29.8%; width:100%; display:flex; flex-wrap:wrap; justify-content:center; padding:0 10%;}
.machine .item-list li {position:relative; width:25.3vw;}
.machine .item-list li:nth-child(4), .machine .item-list li:nth-child(5) {width:36vw;}
.machine .item-list li:nth-child(6), .machine .item-list li:nth-child(7) {width:32vw;}
.machine .item-list li.soldout::after {content:'Sold out'; font-size:0; line-height:0; position:absolute; bottom:8%; left:50%; width:21.8vw; height:21.8vw; margin-left:-10.9vw; background:rgba(0,0,0,0.7) url(//webimage.10x10.co.kr/fixevent/event/2020/100597/m/txt_soldout.png) no-repeat 50% / 100%; -webkit-border-radius:50%; border-radius:50%;}
.machine button {position:absolute; bottom:10%; height:10%; font-size:0; color:transparent;}
.machine .btn-detail {left:10%; width:16%;}
.machine .btn-challenge {right:10%; width:64%;}
.mEvt100597 .share {position:relative;}
.mEvt100597 .share button {position:absolute; top:0; width:20%; height:100%; font-size:0; color:transparent;}
.mEvt100597 .share .btn-fb {right:26.5%;}
.mEvt100597 .share .btn-ka {right:6.5%;}
.winner {background:#fffdf6; padding-bottom:14%;}
.winner .swiper-slide:first-child {margin-left:2.99rem;}
.winner .swiper-slide:last-child {margin-right:2.13rem;}
.winner .item {width:10.24rem; margin-right:1.28rem;}
.winner .thumb {overflow:hidden; width:10.24rem; height:10.24rem; -webkit-border-radius:50%; border-radius:50%; background:#ffc490;}
.winner .desc {text-align:center;}
.winner .desc .name {display:block; overflow:hidden; white-space:nowrap; text-overflow:ellipsis; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; font-size:1.2rem; color:#000; padding-top:1.71rem;}
.winner .desc .user {display:block; margin-top:1rem; font-size:1.1rem; color:#2b3fae;}
.mEvt100597 .layer-popup {display:none; position:fixed; top:0; left:0; z-index:10; width:100%; height:100%;}
.mEvt100597 .layer-popup .layer-mask {position:absolute; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.6);}
.mEvt100597 .layer-popup .layer-inner {overflow:hidden; position:absolute; left:50%; top:50%; transform:translate(-50%,-50%); width:87%; text-align:center; background:#fff; -webkit-border-radius:0.85rem; border-radius:0.85rem;}
.mEvt100597 .layer-popup .btn-close {position:absolute; right:0; top:0; width:16vw; height:16vw; font-size:0; color:transparent; background:url(//webimage.10x10.co.kr/fixevent/event/2020/100597/m/ico_close.png) no-repeat 50% / 34%;}
#detailPopup .layer-inner {width:92.5%;}
#winnerPopup .code {position:absolute; left:0; bottom:7%; width:100%; color:#cacaca;}
#firstTryPopup .btn-fb, #firstTryPopup .btn-ka {position:absolute; top:50%; width:50%; height:40%; font-size:0; color:transparent;}
#firstTryPopup .btn-fb {right:50%;}
#firstTryPopup .btn-ka {left:50%;}
</style>
<script type="text/javascript">
var numOfTry = 0;
<% if drawEvt.isParticipationDayBase(1) then %>
numOfTry = 1
<% end if %>
$(function(){
    getWinner();

	// 뽑기왕 슬라이드
	var winSwiper = new Swiper('.winner .swiper-container', {
		speed:1200,
		freeMode:true,
		slidesPerView:'auto',
		freeModeMomentumRatio:0.3
	});
	// 뽑기왕 슬라이드 위치 조정
	function slidePos() {
		var ww = $(window).width();
		var openSlideNum = $('.winner .swiper-slide.on').length;
		var posCalc = function (a, b) {
			var wp = $('.winner .swiper-wrapper');
			var sw = $('.winner .swiper-slide').width();
			var x = - (sw * (openSlideNum - a) + b);
			wp.css({"transform": "translate3d(" + x + "px,0,0)"});
		};
		if (ww < 640) {
			if (openSlideNum > 2) {
				posCalc(3, 60);
			}
		} else {
			if (openSlideNum > 4) {
				posCalc(5, 75);
			}
		}
	}
	slidePos();

    // 팝업
	$(".mEvt100597 .btn-detail").click(function(){
		$('#detailPopup').fadeIn();
	});
	$(".layer-popup .btn-close").click(function(){
		$(".layer-popup").fadeOut();
	});
});

function layerPopupFadeout() {
    return $(".layer-popup").fadeOut();
}

function checkmyprize(){
	<% If Not(IsUserLoginOK) Then %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% else %>
        <% If currentDate >= eventStartDate And currentDate <= eventEndDate Then %>		
        fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode','<%=eCode%>')

		var returnCode, md5value, itemid
			$.ajax({
				type:"GET",
				url:"/event/etc/drawevent/drawEventProc.asp",
				data: "mode=add<%=testParameter%>",
				dataType: "text",
				async:false,
				cache:true,
				success : function(Data, textStatus, jqXHR){										
					if (jqXHR.readyState == 4) {
						if (jqXHR.status == 200) {
							if(Data!="") {
                                var result = JSON.parse(Data);
								if(result.response == "ok"){									
									returnCode = result.result
									md5value = result.md5userid
									itemid = result.winItemid	
									popResult(returnCode, md5value, itemid);						
									getWinner();																	
									return false;
								}else{
									alert(result.faildesc);
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
					return false;
				}
			});
		<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;				
		<% End If %>
	<% End If %>
}

function popResult(returnCode, md5value, itemid){
	if(returnCode[0] == "B"){
		numOfTry++		
		if(numOfTry == 1){
			$("#firstTryPopup").css("display", "block");
		}else{
			$("#secondTryPopup").css("display", "block");
		}
		if(numOfTry == 2) numOfTry = 0
	}else if(returnCode[0] == "A"){
		if(returnCode == "A02"){
			$("#tryDone").css("display", "block");
		}else{
			alert("<100원 자판기> 공유하고\n한번 더 응모에 도전하세요!");
		}
	}else if(returnCode[0] == "C"){
        $("#winImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2020/100597/m/img_win_"+getItemInfo(parseInt(itemid)).imgCode+".png");
        $("#winImg").attr("alt", getItemInfo(parseInt(itemid)).itemName);
        $("#renCode").text(md5value);

        $("#itemid").val(itemid);
		$("#winnerPopup").css("display", "block");
		numOfTry++
		if(numOfTry == 2) numOfTry = 0
	}
}

function printUserName(name, num, replaceStr){
	return name.substr(0,name.length - num) + replaceStr.repeat(num)
}

function getItemInfo(itemid){
	var itemInfo = {}
	var imgCode;
    var itemName;
	switch (itemid) {
		case 2721559 : 
			imgCode = "01"
            itemName = "Apple Watch Series 5 스페이스 그레이"
			break;
		case 2721577 : 
			imgCode = "03"
            itemName = "마샬 액톤2 스피커 블랙"
			break;
		case 2721350 : 
			imgCode = "06"
            itemName = "에어팟 프로"
			break;
		case 2721505 : 
			imgCode = "07"
            itemName = "아이패드 mini 64G 실버"
            break;
        case 2721570 : 
			imgCode = "08"
            itemName = "MacBook Air 13형"
            break;
        case 2721723 : 
			imgCode = "09"
            itemName = "카카오 미니 AI 스피커"
            break;
        case 2721592 : 
			imgCode = "10"
            itemName = "갤럭시 버즈"
			break;
        default: 
	}	
	return {
		imgCode : imgCode,
        itemName : itemName,
	}
}

function sharesns(snsnum) {	
    <% If currentDate >= eventStartDate And currentDate <= eventEndDate Then %>	
    var reStr;
    var str = $.ajax({
        type: "GET",
        url:"/event/etc/drawevent/drawEventProc.asp",
        data: "mode=snschk&snsnum="+snsnum,
        dataType: "text",
        async: false
    }).responseText;
    reStr = str.split("|");

    if(reStr[1] == "tw") {
        popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');
    } else if(reStr[1]=="fb") {
        <% if isapp then %>
        fnAPPShareSNS('fb','<%=appfblink%>');
        <% else %>
        popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
        <% end if %>
    } else if(reStr[1]=="pt") {
        popSNSPost('pt','<%=snpTitle%>','<%=snpLink%>','','<%=snpImg%>');
    } else if(reStr[1]=="ka") {
        <% if isapp then %>
        fnAPPshareKakao('etc','<%=kakaotitle%>\n<%=kakaodescription%>','http://www.10x10.co.kr/event/eventmain.asp?eventid=100596','http://m.10x10.co.kr/event/eventmain.asp?eventid=100597','<%="url="&kakaolink_url%>','<%=kakaoimage%>','','','','');
        <% else %>
        event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaolink_url%>' );
        <% end if %>
        $(".layer-popup").fadeOut();
        return false;
    } else if(reStr[1]=="비로그인") {
    } else {
        alert('오류가 발생했습니다.');
        return false;
    }
    <% Else %>
        alert("이벤트 응모 기간이 아닙니다.");
        return;				
    <% End If %>
}

function getWinner() {
    var reStr;
    var str = $.ajax({
        type: "GET",
        url:"/event/etc/drawevent/drawEventProc.asp",
        data: "mode=winner",
        dataType: "text",
        async: false
    }).responseText;

    var resultData = JSON.parse(str).data;
    var winnerLength = resultData.length;
    var $rootEl = $("#winners")
    $rootEl.empty();

    var emptyEl = '<div class="swiper-slide"><div class="item"><div class="thumb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100597/m/img_blank.png" alt=""></div></div></div>'

    $.each(resultData,function(key,value) {
        var itemEle = "";	
        var itemid = value.sub_opt2			
        var tmpItemInfo = getItemInfo(itemid)			
        itemEle = '<div class="swiper-slide on">'
        itemEle = itemEle + '		<div class="item">'
        itemEle = itemEle + '			<div class="thumb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100597/m/img_winner_'+tmpItemInfo.imgCode+'.png" alt=""></div>'
        itemEle = itemEle + '			<div class="desc">'
        itemEle = itemEle + '				<strong class="name">' + tmpItemInfo.itemName + '</strong>'
        <% if GetLoginUserLevel = "7" then %>
        itemEle = itemEle + '				<span class="user">' + value.userid + '님</span>'
        <% else %>
        itemEle = itemEle + '				<span class="user">' + printUserName(value.userid, 2, "*") + '님</span>'
        <% end if %>	
        itemEle = itemEle + '			</div>'
        itemEle = itemEle + '		</div>'
        itemEle = itemEle + '	</div>'	
        $rootEl.append(					
            itemEle
        )
    });

    for(var i = 0 ; i < 7 - winnerLength; i++){
        $rootEl.append(emptyEl)
    }
}

function goDirOrdItem() {
<% If IsUserLoginOK() Then %>
    <% If currentDate >= eventStartDate And currentDate <= eventEndDate Then %>		
        $(".layer-popup").fadeOut().css("display","none");
        setTimeout(function() {
            document.directOrd.submit();
        },300);        
	<% else %>
		alert("이벤트 응모 기간이 아닙니다.");
		return;
	<% end if %>
<% End IF %>
}
</script>
<div class="mEvt100597">
    <div class="machine">
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/100597/m/img_evt.jpg" alt="100원 자판기"></p>
        <ul class="item-list">
            <li class="<%=chkIIF(prd3 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100597/m/img_item_01.png" alt=""></li>
            <li class="<%=chkIIF(prd6 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100597/m/img_item_10.png" alt=""></li>
            <li class="<%=chkIIF(prd2 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100597/m/img_item_03.png" alt=""></li>
            <li class="<%=chkIIF(prd5 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100597/m/img_item_04.png" alt=""></li>
            <li class="<%=chkIIF(prd4 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100597/m/img_item_05.png" alt=""></li>
            <li class="<%=chkIIF(prd1 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100597/m/img_item_06.png?v=1.0" alt=""></li>
            <li class="<%=chkIIF(prd7 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100597/m/img_item_09.png" alt=""></li>
        </ul>
        <button type="button" class="btn-detail">자세히 보기</button>
        <button type="button" class="btn-challenge" onclick="checkmyprize()">상품 뽑기</button>
    </div>

    <%'!-- SNS 공유 --%>
    <div class="share">
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/100597/m/bnr_share.jpg" alt="친구에게 공유하고 한 번 더 도전하세요">
        <button type="button" class="btn-fb" onClick="sharesns('fb')">페이스북으로 공유</button>
        <button type="button" class="btn-ka" onClick="sharesns('ka')">카카오톡으로 공유</button>
    </div>

    <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=100646');" target="_blank">
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/100597/m/bnr_evt_1.jpg" alt="어프어프">
    </a>
    <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=100556');" target="_blank">
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/100597/m/bnr_evt_2.jpg" alt="코코도르">
    </a>
    <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=100566');" target="_blank">
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/100597/m/bnr_evt_3.jpg" alt="홈루덴스">
    </a>

    <%'!-- 당첨자 --%>
    <div class="winner">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/100597/m/tit_winner.jpg" alt="뽑기왕을 소개합니다"></h3>
        <div class="swiper-container">
            <div class="swiper-wrapper" id="winners"></div>
        </div>
    </div>
    <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/100597/m/txt_noti.jpg" alt="이벤트 유의사항"></p>

    <%'!-- 팝업 1. 자세히보기 (개발X) --%>
    <div id="detailPopup" class="layer-popup">
        <div class="layer-mask"></div>
        <div class="layer-inner">
            <button type="button" class="btn-close">닫기</button>
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/100597/m/img_detail.png" alt="상품 자세히 보기"></p>
        </div>
    </div>
    <%'당첨 (당첨 시 팝업 뜨면서 장바구니 담기) %>
    <div id="winnerPopup" class="layer-popup" style="display:none">
        <div class="layer-mask"></div>
        <div class="layer-inner">
            <button type="button" onclick="goDirOrdItem()"><img id="winImg" src="" alt="도전 성공"></button>
            <p class="code" id="renCode"></p>
        </div>
    </div>
    <%' 1회응모 꽝 %>
    <div id="firstTryPopup" class="layer-popup" style="display:none">
        <div class="layer-mask"></div>
        <div class="layer-inner">
            <button type="button" class="btn-close">닫기</button>
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/100597/m/img_fail1.png" alt="친구에게 공유하면 한 번 더 도전할 수 있습니다"></p>
            <button type="button" class="btn-fb" onclick="sharesns('fb')">페이스북으로 공유</button>
            <button type="button" class="btn-ka" onclick="sharesns('ka')">카카오톡으로 공유</button>
        </div>
    </div>
    <%
        dim failImage , doneImage

        if currentDate < Cdate("2020-02-29") then
            failImage = "//webimage.10x10.co.kr/fixevent/event/2020/100597/m/img_fail2.png"
            doneImage = "//webimage.10x10.co.kr/fixevent/event/2020/100597/m/img_fin.png"
        else 
            failImage = "//webimage.10x10.co.kr/fixevent/event/2020/100597/m/img_fail2_last.png"
            doneImage = "//webimage.10x10.co.kr/fixevent/event/2020/100597/m/img_fin_last.png"
        end if
    %>
    <%' 공유 후 2회 응모 꽝 %>
    <div id="secondTryPopup" class="layer-popup" style="display:none">
        <div class="layer-mask"></div>
        <div class="layer-inner">
            <button type="button" class="btn-close">닫기</button>
            <p onclick="layerPopupFadeout()"><img src="<%=failImage%>" alt="내일 다시 도전해보세요"></p>
            <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=100483');" target="_blank">
                <img src="//webimage.10x10.co.kr/fixevent/event/2020/100597/m/bnr_evt.png" alt="두근두근 새학기템">
            </a>
        </div>
    </div>
    <%' 2번 모두 응모 완료 %>
    <div id="tryDone" class="layer-popup" style="display:none">
        <div class="layer-mask"></div>
        <div class="layer-inner">
            <button type="button" class="btn-close">닫기</button>
            <p><img src="<%=doneImage%>" alt="응모해주셔서 감사합니다"></p>
            <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=100483');" target="_blank">
                <img src="//webimage.10x10.co.kr/fixevent/event/2020/100597/m/bnr_evt.png" alt="두근두근 새학기템">
            </a>
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
</form>
<% end if %>
<%
set drawEvt = nothing
%>