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
' Description : 2020 텐텐 연간이용권
' History : 2020-01-07 이종화
'####################################################
dim eCode , shareEventCode
dim currentDate , userId
dim eventStartDate , eventEndDate
Dim isTest , testParam , testParameter

IF application("Svr_Info") = "Dev" THEN
	eCode = "90454"
    shareEventCode = "90362"
Else
	eCode = "99885"
    shareEventCode = "99884"
End If

Dim gaParam : gaParam = requestCheckVar(request("gaparam"),30)

IF application("Svr_Info") <> "Dev" THEN
    If isapp <> "1" Then
        Response.redirect "/event/eventmain.asp?eventid="& shareEventCode &"&gaparam="&gaParam
        Response.End
    End If
END IF

eventStartDate  = cdate("2020-01-13")		'이벤트 시작일
eventEndDate 	= cdate("2020-01-23")		'이벤트 종료일
currentDate = date()
userId      = getencLoginUserid()

if userId="ley330" or userId="greenteenz" or userId="rnldusgpfla" or userId="cjw0515" or userId="thensi7" or userId = "motions" or userId = "jj999a" or userId = "phsman1" or userId = "jjia94" or userId = "seojb1983" or userId = "kny9480" or userId = "bestksy0527" or userId = "mame234" then
    dim adminWinPercent : adminWinPercent = requestCheckVar(request("adminWinPercent"),4) '// 확률
    dim adminCurrentDate : adminCurrentDate = requestCheckVar(request("adminCurrentDate"),10) '// 당첨일 선정
    dim adminPrizeId : adminPrizeId = requestCheckVar(request("adminPrizeId"),4) '// 당첨 상품

    isTest = chkiif(requestCheckVar(request("isTest"),1) = "1" , true , false)
    testParameter = "&adminCurrentDate="&adminCurrentDate&"&adminWinPercent="&adminWinPercent&"&adminPrizeId="&adminPrizeId
END IF

IF isTest THEN 
    IF currentDate < eventStartDate THEN
        eventStartDate = currentDate
    END IF
END IF

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("[텐텐 월간이용권의 주인공을 찾습니다]")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& shareEventCode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2019/99885/img_kakao_v2.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& shareEventCode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐텐 월간이용권의 주인공을 찾습니다]"
Dim kakaodescription : kakaodescription = "3개월간 마음껏 쇼핑할 수 있는 기회!\n서둘러 도전하세요"
Dim kakaooldver : kakaooldver = "3개월간 마음껏 쇼핑할 수 있는 기회!\n서둘러 도전하세요"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2019/99885/img_kakao_v2.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& shareEventCode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& shareEventCode

'// 응모
dim drwEvt
dim isSecondTried
dim isFirstTried
dim triedNum : triedNum = 0
dim isShared : isShared = False
isSecondTried = false

if userId <> "" then
    set drwEvt = new DrawEventCls
    drwEvt.evtCode = eCode
    drwEvt.userid = userId
    isSecondTried = drwEvt.isParticipationDayBase(2)
    isFirstTried = drwEvt.isParticipationDayBase(1)
    isShared = drwEvt.isSnsShared
end if

triedNum = chkIIF(isFirstTried, 1, 0)
triedNum = chkIIF(isSecondTried, 2, triedNum)
%>
<style type="text/css">
.mEvt99885 {position:relative;}
.mEvt99885 button {background:none;}
.mEvt99885 .topic {position:relative; padding-bottom:11.3vw; background:#ff9f58;}
.mEvt99885 .topic button {position:relative; display:block; width:100%; z-index:1;}
.mEvt99885 .topic .share {position:relative;}
.mEvt99885 .topic .share button {position:absolute; top:0; height:100%; width:19%; font-size:0; color:transparent;}
.mEvt99885 .topic .share .btn-fb {right:29%;}
.mEvt99885 .topic .share .btn-ka {right:10%;}
.mEvt99885 .winner {position:relative; padding-bottom:18vw; background:#ffddc3;}
.mEvt99885 .winner .slider {overflow:visible;}
.mEvt99885 .winner .box {display:flex; flex-direction:column; justify-content:center; align-items:center; width:76%; height:83vw; margin:0 auto; background:#fff; border:0.5vw solid #222;}
.mEvt99885 .winner .box dt {width:56vw; margin:0 auto;}
.mEvt99885 .winner .winner-list {display:inline-block; vertical-align:top; width:62vw; padding-left:8vw; margin-top:5vw;}
.mEvt99885 .winner .winner-list li {position:relative; float:left; width:50%; height:2rem; line-height:2rem; padding:0 1vw;}
.mEvt99885 .winner li::before {position:absolute; top:1px; right:100%; font-size:0.85rem; color:#000;}
.mEvt99885 .winner li:nth-child(1)::before {content:'1.';}
.mEvt99885 .winner li:nth-child(2)::before {content:'2.';}
.mEvt99885 .winner li:nth-child(3)::before {content:'3.';}
.mEvt99885 .winner li:nth-child(4)::before {content:'4.';}
.mEvt99885 .winner li:nth-child(5)::before {content:'5.';}
.mEvt99885 .winner li:nth-child(6)::before {content:'6.';}
.mEvt99885 .winner li:nth-child(7)::before {content:'7.';}
.mEvt99885 .winner li:nth-child(8)::before {content:'8.';}
.mEvt99885 .winner li:nth-child(9)::before {content:'9.';}
.mEvt99885 .winner li:nth-child(10)::before {content:'10.';}
.mEvt99885 .winner .slider .swiper-slide:nth-child(4) li:nth-child(1)::before {content:'11.';}
.mEvt99885 .winner .slider .swiper-slide:nth-child(4) li:nth-child(2)::before {content:'12.';}
.mEvt99885 .winner .slider .swiper-slide:nth-child(4) li:nth-child(3)::before {content:'13.';}
.mEvt99885 .winner .slider .swiper-slide:nth-child(4) li:nth-child(4)::before {content:'14.';}
.mEvt99885 .winner .slider .swiper-slide:nth-child(4) li:nth-child(5)::before {content:'15.';}
.mEvt99885 .winner .slider .swiper-slide:nth-child(4) li:nth-child(6)::before {content:'16.';}
.mEvt99885 .winner .slider .swiper-slide:nth-child(4) li:nth-child(7)::before {content:'17.';}
.mEvt99885 .winner .slider .swiper-slide:nth-child(4) li:nth-child(8)::before {content:'18.';}
.mEvt99885 .winner .slider .swiper-slide:nth-child(4) li:nth-child(9)::before {content:'19.';}
.mEvt99885 .winner .slider .swiper-slide:nth-child(4) li:nth-child(10)::before {content:'20.';}
.mEvt99885 .winner .box .txt-winner {display:inline-block; overflow:hidden; max-width:80%; text-overflow:ellipsis; font-size:1.1rem; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; color: #222;}
.mEvt99885 .winner .box .txt-blank {display:inline-block; width:6rem; height:1.28rem; background:#dfdfdf; vertical-align:text-top;}
.mEvt99885 .winner .slider .swiper-slide:nth-child(1) dd {font-size:0.94rem; text-align:center; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.mEvt99885 .winner .slider .swiper-slide:nth-child(1) dd p {margin:9vw 0 4vw; font-size:1.1rem;}
.mEvt99885 .winner .slider .swiper-slide:nth-child(1) dd .txt-winner {margin-left:0.5rem;}
.mEvt99885 .winner .slider .swiper-slide:nth-child(1) dd strong {color:#ff3232; font-weight:inherit;}
.mEvt99885 .winner .slider .btn-nav {position:absolute; top:0; width:12%; height:100%; z-index:5; font-size:0; color:transparent; background:url(//webimage.10x10.co.kr/fixevent/event/2019/99885/m/ico_slider.png) no-repeat 50% / 3vw auto;}
.mEvt99885 .winner .slider .btn-prev {left:0; transform:scaleX(-1);}
.mEvt99885 .winner .slider .btn-next {right:0;}
.mEvt99885 .winner .swiper-button-disabled {opacity:0.4;}
.mEvt99885 .winner .swiper-pagination {position:absolute; top:106%; left:0; width:100%; font-size:0; text-align:center;}
.mEvt99885 .winner .swiper-pagination-switch {display:inline-block; width:8px; height:8px; margin:0 3px; border-radius:50%; -webkit-border-radius:50%; background:#393939; opacity:0.5;}
.mEvt99885 .winner .swiper-active-switch {opacity:1;}
.mEvt99885 .dc {position:absolute; left:0; width:100%; animation:fade 5s 10 both;}
.mEvt99885 .topic .dc1 {top:0; animation-delay:1s;}
.mEvt99885 .topic .dc2 {top:0;}
.mEvt99885 .topic .dc3 {top:0; animation-delay:2s;}
.mEvt99885 .topic .dc4 {bottom:35vw; animation-delay:1s;}
.mEvt99885 .topic .dc5 {bottom:35vw;}
.mEvt99885 .winner .dc1 {top:0;}
.mEvt99885 .winner .dc2 {top:0; animation-delay:1s;}
.mEvt99885 .winner .dc3 {bottom:0; animation-delay:2s;}
.mEvt99885 .winner .dc4 {bottom:0;}
@keyframes fade {
	0%,100% {opacity:1;}
	50% {opacity:0;}
}
.mEvt99885 .popup {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background:rgba(0,0,0,0.6); z-index:10;}
.mEvt99885 .popup .lyr {position:absolute; left:7%; width:86%; top:50%; transform:translateY(-50%);}
.mEvt99885 .popup .btn-close {position:absolute; right:0; top:0; width:16vw; height:16vw; font-size:0; color:transparent; background:url(//webimage.10x10.co.kr/fixevent/event/2019/99885/m/ico_close.png) no-repeat 50% / 100%;}
.mEvt99885 .popup .share {position:absolute; left:0; top:34%; width:100%; text-align:center; font-size:0;}
.mEvt99885 .popup .share button {width:28vw; height:28vw; font-size:0; color:transparent;}
.mEvt99885 .popup .code {overflow:hidden; position:absolute; top:90%; width:100%; text-align:center; color:#cacaca; word-break:break-all;}
</style>
<script type="text/javascript">
$(function(){
    getWinner();

	$(".mEvt99885 .popup").hide();
	$(".mEvt99885 .btn-dtl").click(function(){
		$("#popDtl").show();
	});
	$("#popDtl, #popWin").click(function(){
		$(this).hide();
	});
	$(".mEvt99885 .btn-close").click(function(){
		$(".mEvt99885 .popup").hide();
    });
});

var numOfTry = "<%=triedNum%>"
var isShared = "<%=isShared%>"

function checkmyprize(){
	<% If Not(IsUserLoginOK) Then %>
        calllogin();
        return false;
	<% else %>
        <% If currentDate >= eventStartDate And currentDate <= eventEndDate Then %>		
        	var returnCode, md5value, itemid
			$.ajax({
				type:"POST",
				url:"/event/etc/drawevent/drawEventProc.asp",
				data: "mode=add<%=testParameter%>",
				dataType: "JSON",
				async:false,
				cache:true,
                success : function(data){
                    fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode','<%=eCode%>')
                    if (data.response == "err") {
                        alert(data.faildesc);
                        return false;
                    }
                    returnCode = data.result;
                    itemid = data.winItemid;
                    md5value = data.md5userid;
                    popResult(returnCode, md5value, itemid);
                    getWinner();
                    return false;
				},
				error:function(data){
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
		if(numOfTry >= 2){
            $("#fail2").show();
			return false;
        }
        $("#fail1").show();
	}else if(returnCode[0] == "A"){
		if(returnCode == "A02"){
            $("#done").show();
		}else{
            $("#share").show();
		}
	}else if(returnCode[0] == "C"){
        $("#winImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2019/99885/m/txt_win_"+getItemInfo(parseInt(itemid)).imgCode+"_v2.png");
        $("#renCode").text(md5value);
		$("#itemid").val(itemid);
		$("#popWin").show();
		numOfTry++
		if(numOfTry == 2) numOfTry = 0
    }
}

function printUserName(name, num, replaceStr){	
	return name.substr(0,name.length - num) + replaceStr.repeat(num)
}

function getItemInfo(itemid){
	var imgCode;
    var itemName;
	switch (itemid) {
		case 150 : 
			imgCode = "1"
            itemName = "150만원"
			break;
		case 15 : 
			imgCode = "2"
            itemName = "15만원"
			break;					
		case 3 : 
			imgCode = "3"
            itemName = "3만원"
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
        $.ajax({
            type: "POST",
            url:"/event/etc/drawevent/drawEventProc.asp",
            data: {
                mode: 'snschk',
                snsnum: snsnum
            },
            dataType: "JSON"
        })
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
            <% else %>
                event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaoMobileLink%>' );
            <% end if %>
        }
        
        $('.popup').hide();
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
        dataType: "JSON",
        async: false
    }).responseText;

    var resultData = JSON.parse(str).data;
    var winnerLength = resultData.length;
    var $rootEl = $("#winners")

    var itemElType1 = "" , elLength1 = 0 ;
    var itemElType2 = "" , elLength2 = 0 ;
    var itemElType3 = "" , elLength3 = 0 ;
    var itemElType4 = "" ;
    $.each(resultData,function(key,value) {
        var itemid = value.sub_opt2;
        switch (itemid) {
            case 150 :
                <% if GetLoginUserLevel = "7" then %>
                itemElType1 = itemElType1 + '<b class="txt-winner">' + value.userid + '</b>'
                <% else %>
                itemElType1 = itemElType1 + '<b class="txt-winner">' + printUserName(value.userid, 2, "*") + '</b>'
                <% end if %>
                elLength1 += 1
                break;
            case 15 :
                <% if GetLoginUserLevel = "7" then %>
                itemElType2 = itemElType2 + '<li><b class="txt-winner">' + value.userid + '</b></li>'
                <% else %>
                itemElType2 = itemElType2 + '<li><b class="txt-winner">' + printUserName(value.userid, 2, "*") + '</b></li>'
                <% end if %>
                elLength2 += 1
                break;
            case 3 : 
                elLength3 += 1
                <% if GetLoginUserLevel = "7" then %>
                if (elLength3 > 10) {
                    itemElType4 = itemElType4 + '<li><b class="txt-winner">' + value.userid + '</b></li>' 
                } else {
                    itemElType3 = itemElType3 + '<li><b class="txt-winner">' + value.userid + '</b></li>'
                }
                <% else %>
                if (elLength3 > 10) {
                    itemElType4 = itemElType4 + '<li><b class="txt-winner">' + printUserName(value.userid, 2, "*") + '</b></li>'
                } else {
                    itemElType3 = itemElType3 + '<li><b class="txt-winner">' + printUserName(value.userid, 2, "*") + '</b></li>'
                }
                <% end if %>
                break;
            default :
        }
    })

    var emptyEl = '<li><span class="txt-blank"></span></li>'

    var elType1 = function() {
        return (elLength1 == 0) ? '<span class="txt-blank"></span>' : itemElType1;
    }

    var elType2 = function() {
        var tempVal = "";
   
        for(var i = 0 ; i < 10 - elLength2; i++) { 
            tempVal += emptyEl 
        } 

        return itemElType2 + tempVal;
    }

    var elType3_A = function() {
        var tempVal = "";
        if (elLength3 < 10) {
            for(var i = 0 ; i < 10 - elLength3; i++) 
            { 
                tempVal += emptyEl
            } 

            return itemElType3 + tempVal;
        } else {
            return itemElType3
        }
    }

    var elType3_B = function() {
        var tempVal = "";

        if (elLength3 < 10) {
            for(var i = 0 ; i < 10; i++) {
                tempVal += emptyEl
            }

            return tempVal;
        } else {
            for(var i = 0 ; i < 20 - elLength3; i++) 
            { 
                tempVal += emptyEl
            }

            return itemElType4 + tempVal;
        }
    }

    var tempHtml1 ='<div class="swiper-slide">\
                        <dl class="box">\
                            <dt><img src="//webimage.10x10.co.kr/fixevent/event/2019/99885/m/txt_benefit_1_v2.png" alt="150만원"></dt>\
                            <dd>\
                                <p>행운의 주인공 :\
                                    '+ elType1() + '\
                                </p>\
                                <strong>당첨</strong>을 축하 드립니다!\
                            </dd>\
                        </dl>\
                    </div>';
    
    var tempHtml2 ='<div class="swiper-slide">\
                        <dl class="box">\
                            <dt><img src="//webimage.10x10.co.kr/fixevent/event/2019/99885/m/txt_benefit_2_v2.png" alt="15만원"></dt>\
                            <dd>\
                                <ol class="winner-list">\
                                    '+ elType2() +'\
                                </ol>\
                            </dd>\
                        </dl>\
                    </div>';

    var tempHtml3 ='<div class="swiper-slide">\
                        <dl class="box">\
                            <dt><img src="//webimage.10x10.co.kr/fixevent/event/2019/99885/m/txt_benefit_3_v2.png" alt="3만원"></dt>\
                            <dd>\
                                <ol class="winner-list">\
                                    '+ elType3_A() +'\
                                </ol>\
                            </dd>\
                        </dl>\
                    </div>';

    var tempHtml4 ='<div class="swiper-slide">\
                        <dl class="box">\
                            <dt><img src="//webimage.10x10.co.kr/fixevent/event/2019/99885/m/txt_benefit_3_v2.png" alt="3만원"></dt>\
                            <dd>\
                                <ol class="winner-list">\
                                    '+ elType3_B() +'\
                                </ol>\
                            </dd>\
                        </dl>\
                    </div>';
    
    $rootEl.empty().append(tempHtml1 + tempHtml2 + tempHtml3 + tempHtml4);

    var swiper = new Swiper(".slider", {
		speed: 500,
		prevButton: '.slider .btn-prev',
		nextButton: '.slider .btn-next',
		pagination: '.slider .swiper-pagination'
	});
}

</script>
<div class="mEvt99885">
    <div class="topic">
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/99885/m/tit_yearly_v2.png" alt="연간 이용권"></h2>
        <button type="button" class="btn-dtl"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99885/m/btn_detail_v2.png" alt="자세히 보기"></button>
        <button type="button" class="btn-try" onclick="checkmyprize()"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99885/m/btn_try.png" alt="도전하기"></button>
        <div class="share">
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99885/m/bnr_share.png" alt="공유하고 한번 더 도전하기"></p>
            <button type="button" class="btn-fb" onclick="sharesns('fb')">페이스북 공유하기</button>
            <button type="button" class="btn-ka" onclick="sharesns('ka')">카카오톡 공유하기</button>
        </div>
        <i class="dc dc1"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99885/m/img_deco1_1.png" alt=""></i>
        <i class="dc dc2"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99885/m/img_deco1_2.png" alt=""></i>
        <i class="dc dc3"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99885/m/img_deco1_3.png" alt=""></i>
        <i class="dc dc4"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99885/m/img_deco1_4.png" alt=""></i>
        <i class="dc dc5"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99885/m/img_deco1_5.png" alt=""></i>
    </div>
    <div class="winner">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/99885/m/tit_winner.png" alt="당첨자 리스트"></h3>
        <div class="swiper-container slider">
            <div class="swiper-wrapper" id="winners"></div>
            <button type="button" class="btn-nav btn-prev">이전</button>
            <button type="button" class="btn-nav btn-next">다음</button>
            <div class="swiper-pagination"></div>
        </div>
        <i class="dc dc1"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99885/m/img_deco2_1.png" alt=""></i>
        <i class="dc dc2"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99885/m/img_deco2_2.png" alt=""></i>
        <i class="dc dc3"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99885/m/img_deco2_3.png" alt=""></i>
        <i class="dc dc4"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99885/m/img_deco2_4.png" alt=""></i>
    </div>
    <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99885/m/txt_noti_v2.png" alt="유의사항"></p>
    <%'!-- 자세히보기 팝업 --%>
    <div class="popup" id="popDtl">
        <div class="lyr"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99885/m/txt_detail_v2.png" alt="텐텐 연간 이용권"></div>
    </div>
    <%'!-- for dev msg : 도전하기 팝업 1. 당첨 --%>
    <div class="popup" id="popWin">
        <div class="lyr">
            <img src="" alt="" id="winImg">
            <p class="code" id="renCode"></p>
        </div>
    </div>
    <%'!-- 응모 버튼 클릭 시 2-1) 꽝 팝업 1) 첫 번째 응모 시 --%>
    <div class="popup" id="fail1">
        <div class="lyr">
            <img src="//webimage.10x10.co.kr/fixevent/event/2019/99885/m/txt_fail.png" alt="아쉽게도 당첨되지 않았습니다">
            <button type="button" class="btn-close">팝업 닫기</button>
            <div class="share">
                <button type="button" class="btn-fb" onclick="sharesns('fb')">페이스북 공유하기</button>
                <button type="button" class="btn-ka" onclick="sharesns('ka')">카카오톡 공유하기</button>
            </div>
        </div>
    </div>
    <%'!-- for dev msg : 도전하기 팝업 3. 공유 안하고 재응모 --%>
    <div class="popup" id="share">
        <div class="lyr">
            <img src="//webimage.10x10.co.kr/fixevent/event/2019/99885/m/txt_already.png" alt="이미 1회 응모하였습니다">
            <button type="button" class="btn-close">팝업 닫기</button>
            <div class="share">
                <button type="button" class="btn-fb" onclick="sharesns('fb')">페이스북 공유하기</button>
                <button type="button" class="btn-ka" onclick="sharesns('ka')">카카오톡 공유하기</button>
            </div>
        </div>
    </div>
    <%'!-- 응모 버튼 클릭 시 3) 꽝 팝업 2) 공유 후 두번째 응모 시) 기본 --%>
    <div class="popup" id="fail2">
        <div class="lyr">
            <img src="//webimage.10x10.co.kr/fixevent/event/2019/99885/m/txt_fail2<%=chkiif(currentDate = eventEndDate,"_last","")%>.png" alt="내일 다시 도전해보세요">
            <button type="button" class="btn-close">팝업 닫기</button>
        </div>
    </div>
    <%'!-- 응모 버튼 클릭 시 4) 이미 공유까지 해서 2번 응모 완료한 경우) 기본 --%>
    <div class="popup" id="done">
        <div class="lyr">
            <img src="//webimage.10x10.co.kr/fixevent/event/2019/99885/m/txt_end<%=chkiif(currentDate = eventEndDate,"_last","")%>.png" alt="내일 또 도전해 주세요">
            <button type="button" class="btn-close">팝업 닫기</button>
        </div>
    </div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->