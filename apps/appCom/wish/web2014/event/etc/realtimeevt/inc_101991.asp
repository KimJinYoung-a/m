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
' History : 2020-04-06 원승현
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, emCode
dim drawEvt, isParticipation
dim numOfParticipantsPerDay, i
dim prd1, prd2, prd3, prd4, prd5, prd6, prd7, prd8, prd9, prd10
dim testParameter

IF application("Svr_Info") = "Dev" THEN
	eCode = "101600"
    emCode = "101601"
Else
	eCode = "101991"
    emCode = "101990"
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30) 

IF application("Svr_Info") <> "Dev" THEN
    IF isapp <> "1" THEN
        Response.redirect "/event/eventmain.asp?eventid="&emCode&"&gaparam="&gaparamChkVal
        Response.End
    END IF
END IF

eventStartDate  = cdate("2020-04-09")		'이벤트 시작일 
eventEndDate 	= cdate("2020-04-17")		'이벤트 종료일
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
    sqlStr = sqlStr & " select  (SELECT 1 - count(1) as pdt1 FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2807104)) as '조말론캔들' "
    sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt2 FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2807100)) as '마샬스피커' "
    sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt3 FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2807105)) as '이솝핸드크림' "
    sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt4 FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2807099)) as '에어팟프로' "
    sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt5 FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2807131)) as '버즈리얼피규어' "
    sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt6 FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2806992)) as '갤럭시Z플립' "
    sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt7 FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2807098)) as '애플iMac' "
    sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt7 FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2807126)) as '뱅크스탠드' "    
    sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt7 FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2807108)) as '이솝핸드워시' "    

    rsget.CursorLocation = adUseClient
    rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
        prd1 = rsget("조말론캔들") ' 조말론 라임 바질 앤 만다린 홈 캔들
        prd2 = rsget("마샬스피커") ' 마샬 액톤2 스피커 - 화이트
        prd3 = rsget("이솝핸드크림") ' 이솝 레저렉션 아로마틱 핸드 밤 75ml
        prd4 = rsget("에어팟프로") ' 에어팟 프로
        prd5 = rsget("버즈리얼피규어") ' 토이스토리4 리얼피규어 버즈라이트이어
        prd6 = rsget("갤럭시Z플립") ' 삼성전자 갤럭시 Z 플립 미러 퍼플
        prd7 = rsget("애플iMac") ' iMac 21.5형
        prd8 = rsget("뱅크스탠드") ' 뱅크 스탠드 - 그린
        prd9 = rsget("이솝핸드워시") ' 이솝 레저렉션 아로마틱 핸드 워시 500ml
    rsget.close

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg , appfblink
snpTitle	= Server.URLEncode("[100원 자판기]")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&emCode)
snpPre		= Server.URLEncode("에어팟 프로를 뽑으면 100원? 엄청난 자판기가 나타났다. 지금 바로 도전하세요!")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="&emCode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[100원 자판기]"
Dim kakaodescription : kakaodescription = "에어팟 프로를 뽑으면 100원? 엄청난 자판기가 나타났다. 지금 바로 도전하세요!"
Dim kakaooldver : kakaooldver = "[100원 자판기] 에어팟 프로를 뽑으면 100원? 엄청난 자판기가 나타났다. 지금 바로 도전하세요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_kakao.jpg"
Dim kakaolink_url 
If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&emCode
End If

set drawEvt = new DrawEventCls
drawEvt.evtCode = eCode
drawEvt.userid = getencLoginUserid
%>
<style type="text/css">
.mEvt101991 {position:relative; overflow:hidden; background:#0ba3be;}
.mEvt101991 button {background:none;}
.machine {position:relative;}
.machine .item-list {position:absolute; left:6.6%; top:0; overflow:hidden; width:86.8%; height:68.07%;}
.machine .item-list ul {display:flex; height:27.38%; margin-top:7.55%; animation:slide 10s 50 linear both alternate;}
.machine .item-list ul:nth-child(2n) {animation-name:slideReverse;}
.machine .item-list li {position:relative; height:100%;}
.machine .item-list li img {width:auto; height:100%;}
.machine .item-list li.soldout::after {content:''; position:absolute; left:0; top:0; width:100%; height:100%; background:url(//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_01_soldout.png) no-repeat 50% / 100%;}
.machine .item-list li.item2.soldout::after {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_02_soldout.png);}
.machine .item-list li.item3.soldout::after {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_03_soldout.png);}
.machine .item-list li.item4.soldout::after {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_04_soldout.png);}
.machine .item-list li.item5.soldout::after {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_05_soldout.png);}
.machine .item-list li.item6.soldout::after {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_06_soldout.png);}
.machine .item-list li.item7.soldout::after {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_07_soldout.png);}
.machine .item-list li.item8.soldout::after {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_08_soldout.png);}
.machine .item-list li.item9.soldout::after {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_09_soldout.png);}
.machine button,
.machine a {position:absolute; bottom:15%; height:14%; font-size:0; color:transparent;}
.machine .btn-detail {left:0; width:20%;}
.machine .btn-challenge {right:0; width:80%;}
.mEvt101991 .share {position:relative;}
.mEvt101991 .share button {position:absolute; top:0; width:18.5%; height:100%; font-size:0; color:transparent;}
.mEvt101991 .share .btn-fb {right:28%;}
.mEvt101991 .share .btn-ka {right:8.5%;}
.winner {position:relative; font-size:1rem; background:#fff;}
.winner .swiper-container {width:77%; padding:2.3rem 0 1.7rem; text-align:center;}
.winner .name {display:block; padding-bottom:.7rem;  font-family:'CoreSansCRegular', 'NotoSansKRMedium'; line-height:1.1; color:#2975c3; letter-spacing:-.1rem; white-space:nowrap;}
.winner .user {overflow:hidden; white-space:nowrap;}
.winner button {position:absolute; top:38%; width:11.4%; height:25%; background:url(//webimage.10x10.co.kr/fixevent/event/2020/101991/m/btn_nav.png) no-repeat 50% / 30% auto; font-size:0; color:transparent;}
.winner .btn-prev {left:0;}
.winner .btn-next {right:0; transform:rotate(180deg);}
.winner .swiper-button-disabled {opacity:.3;}
.winner .pagination {height:auto; padding-top:2.56rem;}
.winner .pagination span {width:.65rem; height:.65rem; background:#d1d1d1;}
.winner .pagination span.swiper-active-switch {background:#666;}
.mEvt101991 .layer-popup {display:none; position:fixed; top:0; left:0; z-index:10; width:100%; height:100%;}
.mEvt101991 .layer-popup .layer-mask {position:absolute; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.75);}
.mEvt101991 .layer-popup .layer-inner {overflow:hidden; position:absolute; left:6.5%; top:50%; transform:translateY(-50%); width:87%;}
.mEvt101991 .layer-popup .btn-close {position:absolute; right:0; top:0; width:16vw; height:16vw; font-size:0; color:transparent; background:url(//webimage.10x10.co.kr/fixevent/event/2020/100597/m/ico_close.png) no-repeat 50% / 34%;}
.mEvt101991 #detailPopup {position:absolute;}
.mEvt101991 #detailPopup .layer-inner {left:3.75%; width:92.5%;}
.mEvt101991 #winnerPopup .code {position:absolute; left:0; bottom:7%; width:100%; color:#cacaca;}
.mEvt101991 .layer-popup .btn-fb,
.mEvt101991 .layer-popup .btn-ka {position:absolute; top:57%; width:30%; height:30%; font-size:0; color:transparent;}
.mEvt101991 .layer-popup .btn-fb {left:19%;}
.mEvt101991 .layer-popup .btn-ka {left:51%;}
.mEvt101991 .layer-popup .go-evt {display:block; position:absolute; left:0; bottom:0; width:100%; height:38%;}
#winnerPopup .code {position:absolute; left:0; bottom:7%; width:100%; color:#cacaca; text-align:center;}
@keyframes slide {
	0% {transform:translateX(0);}
	100% {transform:translateX(-180%);}
}
@keyframes slideReverse {
	0% {transform:translateX(-180%);}
	100% {transform:translateX(0);}
}
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
        slidesPerView:3,
		pagination:'.winner .pagination',
		nextButton:'.winner .btn-prev',
    	prevButton:'.winner .btn-next'
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
	$(".mEvt101991 .btn-detail").click(function(){
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
			jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&emCode&"")%>');
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
            $('.btn-challenge').attr('disabled', true);
            setTimeout(function() {            
			    $("#firstTryPopup").css("display", "block");
                $('.btn-challenge').attr('disabled', false);
            },800);                                                        
		}else{
            $('.btn-challenge').attr('disabled', true);
            setTimeout(function() {                        
			    $("#secondTryPopup").css("display", "block");
                $('.btn-challenge').attr('disabled', false);
            },800);                                                                    
		}
		if(numOfTry == 2) numOfTry = 0
	}else if(returnCode[0] == "A"){
		if(returnCode == "A02"){
			$("#tryDone").css("display", "block");
		}else{
            $("#noShareTry").css("display", "block");
		}
	}else if(returnCode[0] == "C"){
        $("#winImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_win_"+getItemInfo(parseInt(itemid)).imgCode+".png");
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
		case 2807108 : 
			imgCode = "01"
            itemName = "이솝 핸드워시"
			break;
		case 2807100 : 
			imgCode = "02"
            itemName = "마샬 스피커"
			break;
		case 2807099 : 
			imgCode = "03"
            itemName = "에어팟 프로"
			break;
		case 2807104 : 
			imgCode = "04"
            itemName = "조말론 캔들"
            break;
        case 2807098 : 
			imgCode = "05"
            itemName = "iMac 21.5형"
            break;
        case 2807105 : 
			imgCode = "06"
            itemName = "이솝 핸드크림"
            break;
        case 2807126 : 
			imgCode = "07"
            itemName = "뱅크 스탠드"
			break;
        case 2806992 : 
			imgCode = "08"
            itemName = "갤럭시 Z 플립"
			break;
        case 2807131 : 
			imgCode = "09"
            itemName = "버즈 리얼피규어"
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
        fnAPPshareKakao('etc','<%=kakaotitle%>\n<%=kakaodescription%>','http://www.10x10.co.kr/event/eventmain.asp?eventid=<%=emCode%>','http://m.10x10.co.kr/event/eventmain.asp?eventid=<%=emCode%>','<%="url="&kakaolink_url%>','<%=kakaoimage%>','','','','');
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

    //var emptyEl = '<div class="swiper-slide"><div class="item"><div class="thumb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/수저/m/img_blank.png" alt=""></div></div></div>'

    $.each(resultData,function(key,value) {
        var itemEle = "";	
        var itemid = value.sub_opt2			
        var tmpItemInfo = getItemInfo(itemid)			
        itemEle = '         <div class="swiper-slide">'
        itemEle = itemEle + '   <strong class="name">' + tmpItemInfo.itemName + '</strong>'
        <% if GetLoginUserLevel = "7" then %>
        itemEle = itemEle + '	<span class="user">' + value.userid + '님</span>'
        <% else %>
        itemEle = itemEle + '	<span class="user">' + printUserName(value.userid, 2, "*") + '님</span>'
        <% end if %>	
        itemEle = itemEle + '</div>'	
        $rootEl.append(					
            itemEle
        )
    });

    if ($.isEmptyObject(resultData)) {
        $(".winner").hide();
    }
    /*
    for(var i = 0 ; i < 7 - winnerLength; i++){
        $rootEl.append(emptyEl)
    }
    */
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
<div class="mEvt101991">
    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/tit_100won.png" alt="100원 자판기"></h2>
    <div class="machine">
        <div class="item-list">
            <%'<!-- for dev msg : 품절시 li 에 클래스 soldout(같은상품 3번 반복됨) -->%>
            <ul>
                <li class="item1 <%=chkIIF(prd9 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_01.png" alt="이솝 핸드워시"></li>
                <li class="item2 <%=chkIIF(prd2 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_02.png" alt="마샬 스피커"></li>
                <li class="item3 <%=chkIIF(prd4 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_03.png" alt="에어팟"></li>
                <li class="item4 <%=chkIIF(prd1 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_04.png" alt="조말론"></li>
                <li class="item5 <%=chkIIF(prd7 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_05.png" alt="아이맥"></li>
                <li class="item6 <%=chkIIF(prd3 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_06.png" alt="이솝 핸드크림"></li>
                <li class="item7 <%=chkIIF(prd8 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_07.png" alt="뱅크 스탠드"></li>
                <li class="item8 <%=chkIIF(prd6 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_08.png" alt="갤럭시Z 플립"></li>
                <li class="item9 <%=chkIIF(prd5 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_09.png" alt="버즈 피규어"></li>
            </ul>
            <ul>
                <li class="item5 <%=chkIIF(prd7 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_05.png" alt="아이맥"></li>
                <li class="item4 <%=chkIIF(prd1 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_04.png" alt="조말론"></li>
                <li class="item1 <%=chkIIF(prd9 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_01.png" alt="이솝 핸드워시"></li>
                <li class="item2 <%=chkIIF(prd2 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_02.png" alt="마샬 스피커"></li>
                <li class="item7 <%=chkIIF(prd8 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_07.png" alt="뱅크 스탠드"></li>                
                <li class="item3 <%=chkIIF(prd4 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_03.png" alt="에어팟"></li>
                <li class="item6 <%=chkIIF(prd3 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_06.png" alt="이솝 핸드크림"></li>
                <li class="item8 <%=chkIIF(prd6 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_08.png" alt="갤럭시Z 플립"></li>
                <li class="item9 <%=chkIIF(prd5 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_09.png" alt="버즈 피규어"></li>
            </ul>
            <ul>
                <li class="item5 <%=chkIIF(prd7 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_05.png" alt="아이맥"></li>
                <li class="item7 <%=chkIIF(prd8 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_07.png" alt="뱅크 스탠드"></li>
                <li class="item8 <%=chkIIF(prd6 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_08.png" alt="갤럭시Z 플립"></li>
                <li class="item9 <%=chkIIF(prd5 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_09.png" alt="버즈 피규어"></li>
                <li class="item4 <%=chkIIF(prd1 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_04.png" alt="조말론"></li>
                <li class="item3 <%=chkIIF(prd4 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_03.png" alt="에어팟"></li>
                <li class="item1 <%=chkIIF(prd9 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_01.png" alt="이솝 핸드워시"></li>
                <li class="item6 <%=chkIIF(prd3 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_06.png" alt="이솝 핸드크림"></li>
                <li class="item2 <%=chkIIF(prd2 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_item_02.png" alt="마샬 스피커"></li>
            </ul>
        </div>
        <a href="#detailInner" class="btn-detail">자세히 보기</a>
        <button type="button" class="btn-challenge" onclick="checkmyprize()">상품 뽑기</button>
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_machine2.png" alt="뽑기는 무료! 성공하면 100원에 구매할 수 있습니다."></p>        
    </div>

    <%'!-- SNS 공유 --%>
    <div class="share">
		<img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/txt_share.png" alt="친구에게 공유하고 한 번 더 도전하세요">
        <button type="button" class="btn-fb" onClick="sharesns('fb')">페이스북으로 공유</button>
        <button type="button" class="btn-ka" onClick="sharesns('ka')">카카오톡으로 공유</button>
    </div>

    <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101722');" target="_blank">
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/bnr_evt_1.jpg" alt="텐바이텐 정기세일 바로가기">
    </a>
    <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101392');" target="_blank">
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/bnr_evt_2.jpg" alt="알림 신청하고 1,000p 받기">
    </a>

    <%'!-- 당첨자 --%>
    <div class="winner">
		<h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/txt_introduce.png" alt="뽑기왕을 소개합니다"></h3>
        <div class="swiper-container">
            <div class="swiper-wrapper" id="winners"></div>
            <div class="pagination"></div>
        </div>
        <button class="btn-prev">이전</button>
        <button class="btn-next">다음</button>        
    </div>
    <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/txt_noti.png" alt="이벤트 유의사항"></p>

    <%'!-- 팝업 1. 자세히보기 (개발X) --%>
    <div id="detailPopup" class="layer-popup" style="display:none">
        <div class="layer-mask"></div>
        <div id="detailInner" class="layer-inner">
            <button type="button" class="btn-close">닫기</button>
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_lineup.png" alt="상품 자세히 보기"></p>
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
    <%'<!-- 팝업 3. 꽝 : 첫 번째 응모 시 -->%>
    <div id="firstTryPopup" class="layer-popup" style="display:none">
        <div class="layer-mask"></div>
        <div class="layer-inner">
            <button type="button" class="btn-close">닫기</button>
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_fail1.png" alt="친구에게 공유하면 한 번 더 도전할 수 있습니다"></p>
            <button type="button" class="btn-fb" onclick="sharesns('fb')">페이스북으로 공유</button>
            <button type="button" class="btn-ka" onclick="sharesns('ka')">카카오톡으로 공유</button>
        </div>
    </div>
    <%' 공유하지 않고 두번째 응모 시 %>
    <div id="noShareTry" class="layer-popup" style="display:none">
        <div class="layer-mask"></div>
        <div class="layer-inner">
            <button type="button" class="btn-close">닫기</button>
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_fail1_noshare.png" alt="이미 1회 응모하였습니다"></p>
            <button type="button" class="btn-fb" onclick="sharesns('fb')">페이스북으로 공유</button>
            <button type="button" class="btn-ka" onclick="sharesns('ka')">카카오톡으로 공유</button>
        </div>
    </div>
    <%
        dim failImage , doneImage

        if currentDate < Cdate("2020-04-17") then
            failImage = "//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_fail2.png"
            doneImage = "//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_fin.png"
        else 
            failImage = "//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_fail2_last.png"
            doneImage = "//webimage.10x10.co.kr/fixevent/event/2020/101991/m/img_fin_last.png"
        end if
    %>
    <%' 공유 후 2회 응모 꽝 %>
    <div id="secondTryPopup" class="layer-popup" style="display:none">
        <div class="layer-mask"></div>
        <div class="layer-inner">
            <button type="button" class="btn-close">닫기</button>
            <p onclick="layerPopupFadeout()"><img src="<%=failImage%>" alt="내일 다시 도전해보세요"></p>
            <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101722');" target="_blank" class="go-evt"></a>
        </div>
    </div>
    <%' 2번 모두 응모 완료 %>
    <div id="tryDone" class="layer-popup" style="display:none">
        <div class="layer-mask"></div>
        <div class="layer-inner">
            <button type="button" class="btn-close">닫기</button>
            <p><img src="<%=doneImage%>" alt="응모해주셔서 감사합니다"></p>
            <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101722');" target="_blank" class="go-evt"></a>
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