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
' History : 2019-09-20 이종화
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode
dim drawEvt, isParticipation
dim numOfParticipantsPerDay, i
dim prd1, prd2, prd3, prd4, prd5, prd6, prd7, prd8, prd9, prd10
dim testParameter

IF application("Svr_Info") = "Dev" THEN
	eCode = "90397"	
Else
	eCode = "97448"
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30) 

If isapp <> "1" Then 
	Response.redirect "/event/eventmain.asp?eventid=97449&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2019-10-01")		'이벤트 시작일 
eventEndDate 	= cdate("2019-10-15")		'이벤트 종료일
currentDate 	= date()
LoginUserid		= getencLoginUserid()

' 테스트용
IF LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" Then
    dim adminWinPercent : adminWinPercent = requestCheckVar(request("adminWinPercent"),4) '// 확률
    dim adminCurrentDate : adminCurrentDate = requestCheckVar(request("adminCurrentDate"),10) '// 당첨일 선정
    eventStartDate = date()

    testParameter = "&adminCurrentDate="&adminCurrentDate&"&adminWinPercent="&adminWinPercent
END IF

'// 아이폰11 3대 / 마샬 스피커 2대 / 아이패드 미니 3대 (총 8개)

dim sqlStr
    sqlStr = sqlStr & " select  (SELECT 1 - count(1) as pdt1 FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2521744)) as '아이폰1' "
    sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt2 FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2521751)) as '아이폰2' "
    sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt3 FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2521754)) as '아이폰3' "
    sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt4 FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2521803)) as '마샬스피커1' "
    sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt5 FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2521842)) as '마샬스피커2' "
    sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt6 FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2521860)) as '아이패드1' "
    sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt7 FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2521861)) as '아이패드2' "
    sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt8 FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2521862)) as '아이패드3' "

    rsget.CursorLocation = adUseClient
    rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
        prd1 = rsget("아이폰1") ' 아이폰 11 64GB 퍼플
        prd2 = rsget("아이폰2") ' 아이폰 11 64GB 화이트
        prd3 = rsget("아이폰3") ' 아이폰 11 64GB 그린
        prd4 = rsget("마샬스피커1") ' 마샬 액톤2 스피커 블랙
        prd5 = rsget("마샬스피커2") ' 마샬 액톤2 스피커 화이트
        prd6 = rsget("아이패드1") ' 아이패드 mini 64GB 실버
        prd7 = rsget("아이패드2") ' 아이패드 mini 64GB 스페이스 그레이
        prd8 = rsget("아이패드3") ' 아이패드 mini 64GB 골드
    rsget.close

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg , appfblink
snpTitle	= Server.URLEncode("[돌아온 100원 자판기]")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=97449")
snpPre		= Server.URLEncode("뽑기에 도전해보세요! 성공하면 엄청난 상품이 100원!")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2019/97448/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid=97448"

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[돌아온 100원 자판기]"
Dim kakaodescription : kakaodescription = "뽑기에 도전해보세요! 성공하면 엄청난 상품이 100원!"
Dim kakaooldver : kakaooldver = "[텐바이텐] 뽑기에 도전해보세요! 성공하면 엄청난 상품이 100원!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2019/97448/img_kakao.jpg"
Dim kakaolink_url 
If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=97448"
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid=97449"
End If

set drawEvt = new DrawEventCls
drawEvt.evtCode = eCode
drawEvt.userid = getencLoginUserid
%>
<style type="text/css">
.mEvt97448 {background-color:#9f9ae4;}
.mEvt97448 button {background:none;}
.mEvt97448 .topic {position:relative;}
.mEvt97448 .topic .coin {position:absolute; right:29%; top:14.25%; width:21.4%; padding:0.1%; animation:coin 2s both;}
@keyframes coin {
    0% {opacity:0; right:0%; transform:scale(1) rotate(170deg);}
    20% {opacity:1;}
	60% {right:29%; transform:scale(1) rotate(0deg);}
	65%, 75%, 85%, 95% {transform:scale(1.1) rotate(3deg);}
	70%, 80%, 90% {transform:scale(1.1) rotate(-3deg);}
	100% {transform:scale(1);}
}
.mEvt97448 .topic h2 {position:relative;}
.mEvt97448 .machine {position:relative;}
.mEvt97448 .machine .marquee {overflow:hidden; position:absolute; top:3.5%; left:14%; width:72%; padding:0 1%;}
.mEvt97448 .machine .marquee p {display:inline-block; padding-right:30%; white-space:nowrap; animation:marquee 7s 0.5s linear 20;}
.mEvt97448 .machine .marquee p img {width:70vw;}
@keyframes marquee {
	0% {transform:translateX(0%);}
	48% {opacity:1;}
	49% {transform:translateX(-100%); opacity:0;}
	51% {transform:translateX(100%); opacity:0;}
	52% {opacity:1;}
	91%,93%,95% {opacity:1;}
	92%,94% {opacity:0;}
	100% {transform:translateX(0%);}
}
.mEvt97448 .item-list {position:absolute; top:10.5%; left:0; padding:0 14%; text-align:center; font-size:0;}
.mEvt97448 .item-list li {position:relative; display:inline-block; width:33.3%;}
.mEvt97448 .item-list li.item04,
.mEvt97448 .item-list li.item05 {width:47.4%;}
.mEvt97448 .item-list li img {animation:swing 10s 20 both;}
@keyframes swing {
	0%,10%,100% {transform: rotate3d(0, 0, 1, 0deg);}
	4% {transform: rotate3d(0, 0, 1, 4deg);}
	8% {transform: rotate3d(0, 0, 1, -3deg);}
}
.mEvt97448 .item-list li:nth-child(2) img {animation-delay:1s;}
.mEvt97448 .item-list li:nth-child(3) img {animation-delay:2s;}
.mEvt97448 .item-list li:nth-child(4) img {animation-delay:3s;}
.mEvt97448 .item-list li:nth-child(5) img {animation-delay:4s;}
.mEvt97448 .item-list li:nth-child(6) img {animation-delay:5s;}
.mEvt97448 .item-list li:nth-child(7) img {animation-delay:6s;}
.mEvt97448 .item-list li:nth-child(8) img {animation-delay:7s;}
.mEvt97448 .item-list li.soldout:after {content:'Soldout'; position:absolute; left:50%; bottom:10%; width:21.8vw; height:21.8vw; transform:translateX(-50%); background:rgba(0,0,0,0.7) url(//webimage.10x10.co.kr/fixevent/event/2019/97448/m/txt_soldout.png) no-repeat 50% / 100%; border-radius:50%;}
.mEvt97448 .item-list li.item04.soldout:after,
.mEvt97448 .item-list li.item05.soldout:after {bottom:5%;}
.mEvt97448 .btn-detail,
.mEvt97448 .btn-challenge {position:absolute; bottom:13.7%; height:11.4%; font-size:0; color:transparent;}
.mEvt97448 .btn-detail {left:10%; width:15%;}
.mEvt97448 .btn-challenge {right:10%; width:63%;}
.mEvt97448 .share {position:relative;}
.mEvt97448 .share button {position:absolute; top:0; width:20%; height:100%; font-size:0; color:transparent;}
.mEvt97448 .btn-fb {right:26.5%;}
.mEvt97448 .btn-ka {right:6.5%;}
.winner {background:#7a94ca; padding-bottom:13.5%;}
.winner .swiper-slide:first-child {margin-left:2.99rem;}
.winner .swiper-slide:last-child {margin-right:2.13rem;}
.winner .item {width:10.24rem; margin-right:1.28rem;}
.winner .blank {width:11.09rem; margin-right:0.85rem;}
.winner .item .thumbnail {overflow:hidden; width:10.24rem; height:10.24rem; -webkit-border-radius:50%; border-radius:50%;}
.winner .desc {padding-top:1.71rem; text-align:center;}
.winner .desc .name {display:block; overflow:hidden; white-space:nowrap; text-overflow:ellipsis; font-family:'AvenirNext-Bold', 'AppleSDGothicNeo-Bold'; font-weight:bold; font-size:1.28rem; color:#000;}
.winner .desc .user {display:block; margin-top:1rem; font-family:'AvenirNext-Medium', 'AppleSDGothicNeo-Medium'; font-size:1.07rem; color:#2b3fae;}
.mEvt97448 .noti {background:#555;}
.mEvt97448 .noti h3 {text-align:center;}
.mEvt97448 .noti ul {padding:8% 6.7% 10%;}
.mEvt97448 .noti li {position:relative; padding-left:1rem; font-size:1.07rem; line-height:1.44; color:#fff; word-break:keep-all;}
.mEvt97448 .noti li + li {margin-top:1.19rem;}
.mEvt97448 .noti ul li:before {position:absolute; top:0; left:0; content:'-'; display:inline-block;}
.mEvt97448 .layer-popup {display:none; position:fixed; top:0; left:0; z-index:10; width:100%; height:100%;}
.mEvt97448 .layer-popup .layer-mask {position:absolute; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.6);}
.mEvt97448 .layer-popup .layer-inner {overflow:hidden; position:absolute; left:6.5%; top:50%; transform:translateY(-50%); width:87%; text-align:center; background:#fff; -webkit-border-radius:0.5rem; border-radius:0.5rem;}
.mEvt97448 .layer-popup .btn-close {position:absolute; right:0; top:0; width:16vw; height:16vw; font-size:0; color:transparent; background:url(//webimage.10x10.co.kr/fixevent/event/2019/97448/m/ico_close.png) no-repeat 50% / 34%;}
#winnerPopup .thumbnail {width:46vw; margin:0 auto; background:none;}
#winnerPopup .desc {margin-top:-5%; line-height:1.4; padding-bottom:5%;}
#winnerPopup .desc .name {font-family:'AvenirNext-Medium', 'AppleSDGothicNeo-Medium'; font-size:1.07rem; color:#222;}
#winnerPopup .desc .price {font-family:'AvenirNext-Bold', 'AppleSDGothicNeo-Bold'; font-weight:bold; font-size:1.71rem; color:#f52e41;}
#winnerPopup .desc .price s {font-family:'AvenirNext-Medium', 'AppleSDGothicNeo-Medium'; font-weight:normal; font-size:1.11rem; color:#888;}
#winnerPopup .code {padding:5% 0 10%; font-size:1.07rem; color:#cacaca;}
#firstTryPopup .btn-fb,
#firstTryPopup .btn-ka {position:absolute; top:31%; width:50%; height:40%; font-size:0; color:transparent;}
#firstTryPopup .btn-fb {right:50%;}
#firstTryPopup .btn-ka {left:50%;}
</style>
<script type="text/javascript">
var numOfTry = 0;
<% if drawEvt.isParticipationDayBase(1) then %>
numOfTry = 1
<% end if %>
$(function(){
	// 팝업
	$(".mEvt97448 .btn-detail").click(function(){
		$('#detailPopup').fadeIn();
	});
    $(".layer-popup .btn-close").click(function(){
		$(".layer-popup").fadeOut();
    });

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
});

function layerPopupFadeout() {
    return $(".layer-popup").fadeOut();
}

function checkmyprize(){
	<% If Not(IsUserLoginOK) Then %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
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
        $("#winImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2019/97448/m/img_win_"+getItemInfo(parseInt(itemid)).imgCode+".png");
        $("#winItemName").text(getItemInfo(parseInt(itemid)).itemName);
        $("#winItemPrice").text(getItemInfo(parseInt(itemid)).itemPrice + '원');
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
    var itemPrice;
	switch (itemid) {
		case 2521744 : 
			imgCode = "01"
            itemName = "아이폰 11 64GB 퍼플"
            itemPrice = "990,000"
			break;
		case 2521751 : 
			imgCode = "02"
            itemName = "아이폰 11 64GB 화이트"
            itemPrice = "990,000"
			break;					
		case 2521754 : 
			imgCode = "03"
            itemName = "아이폰 11 64GB 그린"
            itemPrice = "990,000"
			break;
		case 2521803 : 
			imgCode = "04"
            itemName = "마샬 액톤2 스피커 블랙"
            itemPrice = "400,000"
			break;
		case 2521842 : 
			imgCode = "05"
            itemName = "마샬 액톤2 스피커 화이트"
            itemPrice = "400,000"
			break;
		case 2521860 : 
			imgCode = "06"
            itemName = "아이패드 mini 64GB 실버"
            itemPrice = "499,000"
			break;
		case 2521861 : 
			imgCode = "07"
            itemName = "아이패드 mini 64GB 스페이스 그레이"
            itemPrice = "499,000"
            break;
        case 2521862 : 
			imgCode = "08"
            itemName = "아이패드 mini 64GB 골드"
            itemPrice = "499,000"
			break;
        default: 
	}	
	return {
		imgCode : imgCode,
        itemName : itemName,
        itemPrice : itemPrice
	}
}

function sharesns(snsnum) {		
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
        }else if(reStr[1]=="fb"){
            <% if isapp then %>
            fnAPPShareSNS('fb','<%=appfblink%>');
            <% else %>
            popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
            <% end if %>
        }else if(reStr[1]=="pt"){
            popSNSPost('pt','<%=snpTitle%>','<%=snpLink%>','','<%=snpImg%>');
        }else if(reStr[1]=="ka"){
            <% if isapp then %>
            fnAPPshareKakao('etc','<%=kakaotitle%>\n<%=kakaodescription%>','http://www.10x10.co.kr/event/eventmain.asp?eventid=97448','http://m.10x10.co.kr/event/eventmain.asp?eventid=97448','<%="url="&kakaolink_url%>','<%=kakaoimage%>','','','','');
            <% else %>
            event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaolink_url%>' );
            <% end if %>
            $(".layer-popup").fadeOut();
            return false;
        }else if(reStr[1]=="비로그인"){
        }else{
            alert('오류가 발생했습니다.');
            return false;
        }
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

    var emptyEl = '<div class="swiper-slide"><div class="blank"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97448/m/img_blank.png" alt=""></div></div>'

    $.each(resultData,function(key,value) {			
        var itemEle = "";	
        var itemid = value.sub_opt2			
        var tmpItemInfo = getItemInfo(itemid)			
        itemEle = '<div class="swiper-slide on">'
        itemEle = itemEle + '		<div class="item">'
        itemEle = itemEle + '			<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97448/m/img_win_'+tmpItemInfo.imgCode+'.png" alt=""></div>'
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

    for(var i = 0 ; i < 8 - winnerLength; i++){
        $rootEl.append(emptyEl)
    }
}

function goDirOrdItem(){
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
<div class="mEvt97448">
    <div class="topic">
        <span class="coin"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97448/m/img_coin.png" alt="돌아온"></span>
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/97448/m/tit_100won.png" alt="100원 자판기"></h2>
    </div>
    <div class="machine">
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/97448/m/bg_machine.jpg" alt="뽑기는 무료"></p>
        <div class="marquee">
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/97448/m/txt_machine.png" alt="성공하면 100원"></p>
        </div>
        <ul class="item-list">
            <li class="item01 <%=chkIIF(prd1 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97448/m/img_item_01.png" alt="아이폰 11 퍼플"></li>
            <li class="item02 <%=chkIIF(prd2 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97448/m/img_item_02.png" alt="아이폰 11 화이트"></li>
            <li class="item03 <%=chkIIF(prd3 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97448/m/img_item_03.png" alt="아이폰 11 그린"></li>
            <li class="item04 <%=chkIIF(prd4 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97448/m/img_item_04.png" alt="마샬 스피커 블랙"></li>
            <li class="item05 <%=chkIIF(prd5 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97448/m/img_item_05.png" alt="마샬 스피커 화이트"></li>
            <li class="item06 <%=chkIIF(prd6 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97448/m/img_item_06.png" alt="아이패드 mini 실버"></li>
            <li class="item07 <%=chkIIF(prd7 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97448/m/img_item_07.png" alt="아이패드 mini 스페이스"></li>
            <li class="item08 <%=chkIIF(prd8 < 1, "soldout", "")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97448/m/img_item_08.png" alt="아이패드 mini 골드"></li>
        </ul>
        <button type="button" class="btn-detail">자세히 보기</button>
        <button type="button" class="btn-challenge" onclick="checkmyprize()">상품 뽑기</button>
    </div>
    <%'!-- SNS 공유 --%>
    <div class="share">
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/97448/m/img_share.jpg" alt="친구에게 공유하고 한 번 더 도전하세요"></p>
        <button type="button" class="btn-fb" onClick="sharesns('fb')">페이스북으로 공유</button>
        <button type="button" class="btn-ka" onClick="sharesns('ka')">카카오톡으로 공유</button>
    </div>
    <%'!-- 당첨자 --%>
    <div class="winner">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/97448/m/tit_winner.png" alt="뽑기왕을 소개합니다"></h3>
        <div class="swiper-container">
            <div class="swiper-wrapper" id="winners"></div>
        </div>
    </div>
    <div class="noti">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/97448/m/tit_noti.png" alt="이벤트 유의사항"></h3>
        <ul>
            <li>본 이벤트는 텐바이텐 APP에서 로그인 후 참여 가능합니다.</li>
            <li>ID당 1일 1회만 응모 가능하며, 친구에게 공유 시 한 번 더 응모 기회가 주어집니다. (하루 최대 2번 응모 가능)</li>
            <li>모든 상품의 당첨자가 결정되면 이벤트는 조기 마감될 수 있습니다.</li>
            <li>당첨자에게는 세무신고를 위해 개인 정보를 요청할 예정이며, 제세공과금은 텐바이텐 부담입니다.</li>
            <li>당첨자에게는 상품 수령 후, 인증 사진을 요청할 예정입니다.</li>
            <li>본 이벤트는 애플과 무관한 이벤트임을 알려드립니다.</li>
            <li>‘아이폰 11’은 국내 출시 이후 발송될 예정입니다. (11월 예상)</li>
        </ul>
    </div>

    <%'!-- 팝업 1. 자세히보기 (개발X) --%>
    <div id="detailPopup" class="layer-popup">
        <div class="layer-mask"></div>
        <div class="layer-inner">
            <button type="button" class="btn-close">닫기</button>
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/97448/m/img_detail.jpg" alt="상품 자세히 보기"></p>
        </div>
    </div>
    <%'당첨 (당첨 시 팝업 뜨면서 장바구니 담기) %>
    <div id="winnerPopup" class="layer-popup" style="display:none">
        <div class="layer-mask"></div>
        <div class="layer-inner">
            <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/97448/m/tit_win.png" alt="도전 성공"></h3>
            <div class="thumbnail"><img id="winImg" src="" alt=""></div>
            <div class="desc">
                <p class="name" id="winItemName"></p>
                <p class="price"><s id="winItemPrice"></s> 100원</p>
            </div>
            <button type="button" class="btn-buy" onclick="goDirOrdItem()"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97448/m/btn_buy.png" alt="100원에 구매하러가기"></button>
            <p class="code" id="renCode"></p>
        </div>
    </div>
    <%' 1회응모 꽝 %>
    <div id="firstTryPopup" class="layer-popup" style="display:none">
        <div class="layer-mask"></div>
        <div class="layer-inner">
            <button type="button" class="btn-close">닫기</button>
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/97448/m/img_fail1.png" alt="친구에게 공유하면 한 번 더 도전할 수 있습니다"></p>
            <button type="button" class="btn-fb" onclick="sharesns('fb')">페이스북으로 공유</button>
            <button type="button" class="btn-ka" onclick="sharesns('ka')">카카오톡으로 공유</button>
        </div>
    </div>
    <%
        dim failImage , doneImage

        if currentDate < Cdate("2019-10-15") then
            failImage = "//webimage.10x10.co.kr/fixevent/event/2019/97448/m/img_fail2.png"
            doneImage = "//webimage.10x10.co.kr/fixevent/event/2019/97448/m/img_done.png"
        else 
            failImage = "//webimage.10x10.co.kr/fixevent/event/2019/97448/m/img_fail2_last.png"
            doneImage = "//webimage.10x10.co.kr/fixevent/event/2019/97448/m/img_done_last.png"
        end if
    %>
    <%' 공유 후 2회 응모 꽝 %>
    <div id="secondTryPopup" class="layer-popup" style="display:none">
        <div class="layer-mask"></div>
        <div class="layer-inner">
            <button type="button" class="btn-close">닫기</button>
            <p onclick="layerPopupFadeout()"><img src="<%=failImage%>" alt="내일 다시 도전해보세요"></p>
            <a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_floatingbanner_in_event','eventcode','<%=eCode%>', function() {fnAPPselectGNBMenuWithTop('taste');});return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97448/m/bnr_18th.jpg" alt="오늘의 취향"></a>
        </div>
    </div>
    <%' 2번 모두 응모 완료 %>
    <div id="tryDone" class="layer-popup" style="display:none">
        <div class="layer-mask"></div>
        <div class="layer-inner">
            <button type="button" class="btn-close">닫기</button>
            <p><img src="<%=doneImage%>" alt="응모해주셔서 감사합니다"></p>
            <a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_floatingbanner_in_event','eventcode','<%=eCode%>', function() {fnAPPselectGNBMenuWithTop('taste');});return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97448/m/bnr_18th.jpg" alt="오늘의 취향"></a>
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