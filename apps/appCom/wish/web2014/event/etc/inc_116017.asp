<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 연말 선물 100원 이벤트
' History : 2021.12.13 정태훈 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<%
dim eventStartDate, eventEndDate, LoginUserid, mktTest
dim eCode, currentDate, moECode

IF application("Svr_Info") = "Dev" THEN
	eCode = "109433"
    moECode = "109402"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "116017"
    moECode = "116018"
    mktTest = True
Else
	eCode = "116017"
    moECode = "116018"
    mktTest = False
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)
If isApp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2021-12-15")		'이벤트 시작일
eventEndDate 	= cdate("2021-12-28")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if mktTest then
    currentDate = cdate("2021-12-15")
else
    currentDate = date()
end if

%>
<style type="text/css">
.mEvt116017 section{position:relative;}

.mEvt116017 .section{position: relative;}
.mEvt116017 .section01_02 .top img{position:absolute;height: 100%;top:0; left: 50%;transform: translateX(-50%);width: auto;}
.mEvt116017 .section01_05 .scroll img{position:absolute;top: 0; width: 73vw;left: 50%;margin-left: -36.5vw;opacity:0;transform:translateY(20vw);transition:ease-in-out 1s;}
.mEvt116017 .section01_06 .scroll img{position:absolute;top: 0; width: 63vw;left: 50%;margin-left: -31.5vw;opacity:0;transform:translateY(20vw);transition:ease-in-out 1s .5s;}
.mEvt116017 .section .scroll img.on{opacity:1;transform:translateY(0);}

/*.mEvt116017 .section02 .login_bfr{display: none;}*/
.mEvt116017 .section02 .login .txt{font-weight:600; width:100%;position: absolute;top: 0; left: 50%; transform: translateX(-50%);font-family:'CoreSansCBold', 'AppleSDGothicNeo-Regular', 'NotoSansKRRegular';font-size: 1.85rem;text-align: center;}
.mEvt116017 .section02 .login .txt span{text-decoration:underline;text-decoration-color: #8b8b8b;}
.mEvt116017 .section02 .login .txt02{line-height: 2;}
.mEvt116017 .section02 .mission02, .mission03, .mission04{position: relative;}
/*.mEvt116017 .section02 .mission .mission_login_bfr{display: none;}*/
/*.mEvt116017 .section02 .mission .mission_aft{display: none;}*/
.mEvt116017 .section02 .mission a{width: 28vw; height: 9vw; position: absolute;top:8vw;right: 11vw;}

.mEvt116017 .section03 div{position: relative;}    
.mEvt116017 .section03 p{position: absolute;font-family:'CoreSansCLight', 'AppleSDGothicNeo-Light', 'NotoSansKRLight'; color: #8e8e8e;}
.mEvt116017 .section03 button:nth-of-type(1){position: absolute; width: 41.2vw;height:11.8vw;bottom: 0;background: transparent;}
.mEvt116017 .section03 button:nth-of-type(2){position: absolute; width: 41.3vw;bottom: 0;display: none;}
.mEvt116017 .section03 .prd01 p{left:10.9vw;bottom: 16.4vw;}
.mEvt116017 .section03 .prd01 button:nth-of-type(1){width: 86.7vw; height:11.8vw; left: 50%; bottom: 0;transform: translateX(-50%);background: transparent;}
.mEvt116017 .section03 .prd01 button:nth-of-type(2){width: 86.7vw; left: 50%; bottom: 0;transform: translateX(-50%);}
.mEvt116017 .section03 .background{width: 100%; height: 19.8vw;background: #006346;position: relative;font-size: 1.02rem;}
.mEvt116017 .section03 p{left:10.4vw;bottom: 16.4vw;}
.mEvt116017 .section03 div div:nth-of-type(1) button{left:6.6vw;}
.mEvt116017 .section03 div div:nth-of-type(2) button{right:6.6vw;}
.mEvt116017 .section03 div div:nth-of-type(2) p{left:55.8vw;}

.mEvt116017 .section04 .btn-apply{position:absolute;top:39.5%;left:50%;width:86.7vw;height:20.5vw;margin-left:-43.35vw;text-indent: -999999999px;background:transparent;}
.mEvt116017 .section04 .noti_wrap .noti{position:absolute;width: 100%;height:10vw;top:143vw;}
.mEvt116017 .section04 .noti_wrap .noti::after{content:'';display:block;background:url(//webimage.10x10.co.kr/fixevent/event/2021/116017/arrow.png) no-repeat 0 0;transform: rotate(0deg);position:absolute;bottom:1.8vw;left:71.3vw;background-size:100%;width:3.1vw;height:1rem;}
.mEvt116017 .section04 .noti_wrap .noti.on::after{transform: rotate(180deg);top:3vw;}
.mEvt116017 .section04 .noti_wrap .notice{display:none;}

.mEvt116017 .lyr {display:none; overflow-y:scroll; position:fixed; top:0; left:0; z-index:100; width:100vw; height:100vh; background:rgba(0,0,0,.6);}
.mEvt116017 .lyr .inner{width:87%;position:absolute; left:50%; top:50%; transform:translate(-50%, -50%); max-width:32rem;}

.mEvt116017 .lyr .inner a:nth-of-type(1) {display:block; position:absolute; top:0; right:0; width:16vw; height:5rem;}
.mEvt116017 .lyr .inner a:nth-of-type(2) {display:block; position:absolute; bottom:6rem; width:100%; height:6rem;}
.mEvt116017 .lyr .prd_name{position:absolute;width: 100%;text-align: center;font-size: 2.13rem;top:5.3rem;color:#e93e30; font-weight:600;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Regular', 'NotoSansKRRegular'; text-decoration: underline;text-underline-position: under;}

.mEvt116017 .lyr.popup2 {display:block; overflow-y:scroll; position:fixed; top:0; left:0; z-index:100; width:100vw; height:100vh; background:rgba(0,0,0,.6);}
.mEvt116017 .lyr.popup2 .inner{width:87%;position:absolute; left:50%; top:50%; transform:translate(-50%, -50%); max-width:32rem;}
.mEvt116017 .lyr.popup2 .inner a:nth-of-type(1) {display:block; position:absolute; top:0; right:0; width:16vw; height:5rem;}
.mEvt116017 .lyr.popup2 .inner a:nth-of-type(2) {display:block; position:absolute; bottom:3rem; width:100%; height:8rem;}

@keyframes updown {
    0% {transform: translateY(0px);}
    50% {transform: translateY(-0.5rem);}
    100% {transform: translateY(0.5rem);}
}

</style>
<script type="text/javascript">
$(function(){
	// 팝업레이어
	$('.mEvt116017 .lyr .btn_close').click(function(){
        $('.lyr').css('display','none');
        return false;
	})

    // top 이미지 변경
    var i=1;
	setInterval(function(){
		i++;
        if(i>5){i=1;}
		$('.section01_02 .top img').attr('src','//webimage.10x10.co.kr/fixevent/event/2021/116017/top_img0'+ i +'.png?v=3');
	},1000);

    // 스크롤 시 나타나기
    $(window).scroll(function(){
        $('.mEvt116017 .section .scroll img').each(function(){
        var y = $(window).scrollTop() + $(window).height() * 1;
        var imgTop = $(this).offset().top;
        if(y > imgTop) {
            $(this).addClass('on');
        }
        });
    });

    // noti
    $('.noti_wrap .noti').click(function(){
		if($(this).hasClass('on')){
			$(this).removeClass('on');
			$('.notice').css('display','none');
		}else{
			$(this).addClass('on');
			$('.notice').css('display','block');
		}
	});
    <% If IsUserLoginOK() Then %>
    fnMyJoinEvent();
    fnSetEvent();
    <% end if %>
    fnEventItemInfo();
});

function fnMyJoinEvent(){
    $.ajax({
        type: "POST",
        url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript116017.asp",
        data: {
            mode: 'myjoin'
        },
        dataType: "JSON",
        success: function(data){
            if(data.response == "ok"){
                if(data.item1>0){
                    $("#itembtnaft1").show();
                    $("#itembtnbfr1").hide();
                }
                if(data.item2>0){
                    $("#itembtnaft2").show();
                    $("#itembtnbfr2").hide();
                }
                if(data.item3>0){
                    $("#itembtnaft3").show();
                    $("#itembtnbfr3").hide();
                }
                if(data.item4>0){
                    $("#itembtnaft4").show();
                    $("#itembtnbfr4").hide();
                }
                if(data.item5>0){
                    $("#itembtnaft5").show();
                    $("#itembtnbfr5").hide();
                }
                if(data.item6>0){
                    $("#itembtnaft6").show();
                    $("#itembtnbfr6").hide();
                }
                if(data.item7>0){
                    $("#itembtnaft7").show();
                    $("#itembtnbfr7").hide();
                }
                if(data.item8>0){
                    $("#itembtnaft8").show();
                    $("#itembtnbfr8").hide();
                }
                if(data.item9>0){
                    $("#itembtnaft9").show();
                    $("#itembtnbfr9").hide();
                }
            }else if(data.response == "retry"){
                alert('이미 신청하셨습니다.');
            }
        },
        error: function(data){
            alert('시스템 오류입니다.');
        }
    });
}

function fnSetEvent(){
    $.ajax({
        type: "POST",
        url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript116017.asp",
        data: {
            mode: 'set'
        },
        dataType: "JSON",
        success: function(data){
            if(data.response == "ok"){
                $("#nowticket").empty().html(data.NowTicket);
                $("#totalticket").empty().html(data.TotalPoint);
                if(data.ticket2>0){
                    $("#mission2a").show();
                    $("#mission2b").hide();
                }else{
                    $("#mission2b").show();
                    $("#mission2a").hide();
                }
                if(data.ticket3>0){
                    $("#mission3a").show();
                    $("#mission3b").hide();
                }else{
                    $("#mission3b").show();
                    $("#mission3a").hide();
                }
                if(data.ticket4>0){
                    $("#mission4a").show();
                    $("#mission4b").hide();
                }else{
                    $("#mission4b").show();
                    $("#mission4a").hide();
                }
                $("#ticket").val(data.NowTicket);
            }else if(data.response == "retry"){
                alert('이미 신청하셨습니다.');
            }
        },
        error: function(data){
            alert('시스템 오류입니다.');
        }
    });
}

function fnEventItemInfo(){
    $.ajax({
        type: "POST",
        url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript116017.asp",
        data: {
            mode: 'item'
        },
        dataType: "JSON",
        success: function(data){
            if(data.response == "ok"){
                $("#item1").empty().html(comma(data.item1));
                $("#item2").empty().html(comma(data.item2));
                $("#item3").empty().html(comma(data.item3));
                $("#item4").empty().html(comma(data.item4));
                $("#item5").empty().html(comma(data.item5));
                $("#item6").empty().html(comma(data.item6));
                $("#item7").empty().html(comma(data.item7));
                $("#item8").empty().html(comma(data.item8));
                $("#item9").empty().html(comma(data.item9));
            }else if(data.response == "retry"){
                alert('이미 신청하셨습니다.');
            }
        },
        error: function(data){
            alert('시스템 오류입니다.');
        }
    });
}

function doAction(itemnum) {
	<% if not (currentDate >= eventStartDate and currentDate <= eventEndDate) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
    <% If IsUserLoginOK() Then %>
        if($("#ticket").val()<1){
			alert("응모권을 모두 소진 했습니다.");
			return false;
		};
        $.ajax({
            type: "POST",
            url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript116017.asp",
            data: {
                mode: 'add',
                item: itemnum
            },
            dataType: "JSON",
            success: function(data){
                if(data.response == "ok"){
                    $("#eitemname").empty().html(data.prd_name);
                    $('.popup').css('display','block');
                    $("#ticket").val(parseInt($("#ticket").val())-1);
                    $("#nowticket").empty().html($("#ticket").val());
                    fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|item','<%=eCode%>|'+itemnum);
                    $("#item"+itemnum).empty().html(comma(data.itemjoincnt));
                    $('#itembtnbfr'+itemnum).hide();
                    $('#itembtnaft'+itemnum).show();
                }else if(data.response == "retry"){
                    alert('이미 신청하셨습니다.');
                }
                else if(data.response == "noticket"){
                    alert('응모권을 모두 소진 했습니다.');
                }                
            },
            error: function(data){
                alert('시스템 오류입니다.');
            }
        })
    <% else %>
        calllogin();
		return false;
    <% end if %>
}

function doAlarm() {
	<% if not (currentDate >= eventStartDate and currentDate <= eventEndDate) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
    <% If IsUserLoginOK() Then %>
        $.ajax({
            type: "POST",
            url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript116017.asp",
            data: {
                mode: 'alarm'
            },
            dataType: "JSON",
            success: function(data){
                if(data.response == "ok"){
                    alert(data.message);
                }else{
                    alert(data.message);
                }
            },
            error: function(data){
                alert('시스템 오류입니다.');
            }
        })
    <% else %>
        calllogin();
		return false;
    <% end if %>
}

function jsSubmitlogin(){
    calllogin();
    return false;
}

function comma(str) {
    str = String(str);
    return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}
</script>
			<div class="mEvt116017">
				<section class="section01">
                    <div class="section section01_01">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/section01_01.jpg?v=3" alt="">
                    </div>
                    <div class="section section01_02">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/section01_02.jpg?v=2" alt="">
                        <div class="top">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/top_img01.png?v=2" alt="" class="top01">
                        </div>
                    </div>
                    <div class="section section01_04">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/section01_04.jpg?v=2" alt="">
                    </div>
                    <div class="section section01_05">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/section01_05.jpg?v=2" alt="">
                        <div class="scroll">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/scroll_img01.png?v=2" alt="" class="scroll_img01">
                        </div>
                    </div>
                    <div class="section section01_06">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/section01_06.jpg?v=2" alt="">
                        <div class="scroll">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/scroll_img02.png?v=2" alt="" class="scroll_img02">
                        </div>
                    </div>
                </section>

                <section class="section02">
                    <% If IsUserLoginOK() Then %>
                    <div class="login">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/section02_login.jpg?v=2" alt="">
                        <div class="txt">
                            <p class="txt01">현재 나의 응모권 :&nbsp;<span id="nowticket">0</span>개</p>
                            <p class="txt02">내가 받은 누적 응모권 :&nbsp;<span id="totalticket">0</span>개</p>
                        </div> 
                    </div>
                    <% else %>
                    <div class="login_bfr">
                        <a href="" onclick="jsSubmitlogin();return false;">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/section02_login_bfr.jpg?v=2" alt="">
                        </a>
                    </div>
                    <% end if %>
                    <div class="mission">
                        <% If IsUserLoginOK() Then %>
                        <div class="mission_login">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/mission01_01.jpg" alt="">
                            <div class="mission02">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/mission02_01.jpg" id="mission2b" class="mission_bfr">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/mission02_02.jpg" id="mission2a" class="mission_aft">
                                <a href="" onclick="fnAPPpopupBrowserURL('신상품 베스트','https://m.10x10.co.kr/apps/appcom/wish/web2014/list/new/new_summary2020.asp');return false;"></a>
                            </div>
                            <div class="mission03">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/mission03_01.jpg" id="mission3b" class="mission_bfr">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/mission03_02.jpg" id="mission3a" class="mission_aft">
                                <a href="" onclick="fnPopupBest('https://m.10x10.co.kr/apps/appcom/wish/web2014/list/best/best_detail2020.asp');return false;"></a>
                            </div>
                            <div class="mission04">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/mission04_01.jpg" id="mission4b" class="mission_bfr">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/mission04_02.jpg" id="mission4a" class="mission_aft">
                                <a href="" onclick="fnAPPpopupSetting();return false;"></a>
                            </div>    
                        </div>
                        <% else %>
                        <div class="mission_login_bfr">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/mission_login_bfr.jpg" alt="">
                        </div>
                        <% end if %>
                    </div>
                </section>
                
                <section class="section03">
                    <input type="hidden" id="ticket">
                    <div class="prd01">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/section03_01.jpg" alt=""> 
                        <p><span id="item1">00,000</span>명 응모중</p>
                        <button id="itembtnbfr1" onclick="doAction(1);"></button>
                        <button id="itembtnaft1"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/btn_finish02.png" alt=""></button>
                    </div>
                    <div class="prd02">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/section03_02.jpg" alt=""> 
                        <div class="prd02_01">
                            <p><span id="item2">00,000</span>명 응모중</p>
                            <button id="itembtnbfr2" onclick="doAction(2);"></button>
                            <button id="itembtnaft2"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/btn_finish01.png" alt=""></button>
                        </div>
                        <div class="prd02_02">
                            <p><span id="item3">00,000</span>명 응모중</p>
                            <button id="itembtnbfr3" onclick="doAction(3);"></button>
                            <button id="itembtnaft3"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/btn_finish01.png" alt=""></button>
                        </div>
                    </div>
                    <div class="prd03">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/section03_03.jpg" alt=""> 
                        <div class="prd03_01">
                            <p><span id="item4">00,000</span>명 응모중</p>
                            <button id="itembtnbfr4" onclick="doAction(4);"></button>
                            <button id="itembtnaft4"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/btn_finish01.png" alt=""></button>
                        </div>
                        <div class="prd03_02">
                            <p><span id="item5">00,000</span>명 응모중</p>
                            <button id="itembtnbfr5" onclick="doAction(5);"></button>
                            <button id="itembtnaft5"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/btn_finish01.png" alt=""></button>
                        </div>
                    </div>
                    <div class="prd04">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/section03_04.jpg" alt=""> 
                        <div class="prd04_01">
                            <p><span id="item6">00,000</span>명 응모중</p>
                            <button id="itembtnbfr6" onclick="doAction(6);"></button>
                            <button id="itembtnaft6"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/btn_finish01.png" alt=""></button>
                        </div>
                        <div class="prd04_02">
                            <p><span id="item7">00,000</span>명 응모중</p>
                            <button id="itembtnbfr7" onclick="doAction(7);"></button>
                            <button id="itembtnaft7"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/btn_finish01.png" alt=""></button>
                        </div>
                    </div>
                    <div class="prd05">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/section03_05.jpg" alt=""> 
                        <div class="prd05_01">
                            <p><span id="item8">00,000</span>명 응모중</p>
                            <button id="itembtnbfr8" onclick="doAction(8);"></button>
                            <button id="itembtnaft8"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/btn_finish01.png" alt=""></button>
                        </div>
                        <div class="prd05_02">
                            <p><span id="item9">00,000</span>명 응모중</p>
                            <button id="itembtnbfr9" onclick="doAction(9);"></button>
                            <button id="itembtnaft9"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/btn_finish01.png" alt=""></button>
                        </div>
                        <div class="background"></div>
                    </div>
                </section>
                <section class="section04">  
                    <div class="noti_wrap">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/section04.jpg?v=2" alt=""> 
						<p class="noti"></p>
						<p class="notice"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/info.jpg?v=2" alt="" class="info"></p>
					</div>
                </section>
                <section class="section05">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/section05.jpg" alt="">
                    <button onclick="doAlarm();">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/btn_alert.jpg" alt="">
                    </button> 
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/section05_02.jpg" alt=""> 
                </section>
                <section class="section06">
                    <a href="" onclick="fnAPPpopupBrowserURL('이벤트','https://m.10x10.co.kr/apps/appcom/wish/web2014/event/benefit/index.asp');return false;">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/section06.jpg" alt="">
                    </a>
                </section>
                <!-- 팝업레이어 -->
                <div class="lyr popup">
                    <div class="inner">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/popup.png" alt="">
                        <a href="" class="btn_close"></a>
                        <!-- 알림받기 버튼 -->
                        <a href="" class="btn_alert" onclick="doAlarm();return false;"></a>
                        <p class="prd_name" id="eitemname">21SS 톰브라운 맨투맨(w)</p>
                    </div>
                </div>
                <div class="lyr popup2">
                    <div class="inner">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116017/popup02.png" alt="">
                        <a href="" class="btn_close"></a>
                        <!-- 알림받기 버튼 -->
                        <a href="" onclick="fnAPPpopupBrowserURL('당첨자 확인','https://m.10x10.co.kr/common/news/news_view.asp?type=&idx=19260&page=1');return false;"></a>
                    </div>
                </div> 
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->