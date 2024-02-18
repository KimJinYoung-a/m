<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 골든 티켓 이벤트
' History : 2021.10.21 정태훈 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eventStartDate, eventEndDate, LoginUserid, mktTest
dim eCode, currentDate, moECode, sqlStr

IF application("Svr_Info") = "Dev" THEN
	eCode = "109404"
    moECode = "109402"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "114637"
    moECode = "114638"
    mktTest = True
Else
	eCode = "114637"
    moECode = "114638"
    mktTest = False
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)
If isApp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2021-10-25")		'이벤트 시작일
eventEndDate 	= cdate("2021-11-30")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if mktTest then
    currentDate = cdate("2021-10-25")
else
    currentDate = date()
end if
%>
<style>
/* common */
.mEvt114637 .section{position:relative;}

/* section01 */
.mEvt114637 .topic {position:relative;}
.mEvt114637 .tit {width:71.33vw; position:absolute; left:50%; top:8rem; margin-left:-35.66vw; opacity:0; transform:translateY(50%); transition:all 1s;}
.mEvt114637 .txt01 {width:95.47vw; position:absolute; left:50%; top:13rem; margin-left:-45.73vw; opacity:0; transform:translateY(50%); transition:all 1s .5s;}
.mEvt114637 .txt02 {width:76.80vw; position:absolute; left:50%; top:53rem; margin-left:-38.4vw; opacity:0; transform:translateY(50%); transition:all 1s .7s;}
.mEvt114637 .tit.on,
.mEvt114637 .txt01.on,
.mEvt114637 .txt02.on{opacity:1; transform:translateY(0); }
.mEvt114637 .section-01,
.mEvt114637 .section-02,
.mEvt114637 .section-03 {position:relative;}
.mEvt114637 .section-01 a {display:inline-block; width:100%; height:20rem; position:absolute; left:0; bottom:0;}
.mEvt114637 .section-02 .btn-enter {width:100%; height:10rem; position:absolute; left:0; bottom:9rem; background:transparent; text-indent:9999px; font-size:0;}
.mEvt114637 .section-02 .btn-code {width:100%; height:5rem; position:absolute; left:0; bottom:4rem; background:transparent; text-indent:9999px; font-size:0;}
.mEvt114637 .section-02 input {width:100%; height:5.67rem; padding:0 4.69rem; position:absolute; left:0; top:25.8rem; background:transparent; border:0; text-align:center; font-size:2.21rem; color:#000; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt114637 .section-02 input::placeholder {font-size:1.36rem; color:#ababab; font-family:'CoreSansCLight', 'AppleSDGothicNeo-Regular', 'NotoSansKRRegular', sans-serif;}
.mEvt114637 .section-03 a {display:inline-block; width:100%; height:14rem;}
.mEvt114637 .section-03 .link01 {position:absolute; left:0; top:0;}
.mEvt114637 .section-03 .link02 {position:absolute; left:0; top:14rem;}
.mEvt114637 .section-03 .link03 {position:absolute; left:0; bottom:0;}

.mEvt114637 .animate {opacity:0; transform:translateY(50%); transition:all 1s; }
.mEvt114637 .animate.on {opacity:1; transform:translateY(0); }

.mEvt114637 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(0, 0, 0,0.502); z-index:150;}
.mEvt114637 .pop-container .pop-inner {position:absolute; left:0; top:50%; transform:translateY(-50%); padding:0 2.13rem;}
.mEvt114637 .pop-container .pop-contents {position:relative;}
.mEvt114637 .pop-container .pop-inner .btn-close {position:absolute; right:2.93rem; top:1.5rem; width:2.73rem; height:2.73rem; text-indent:-9999px; background:transparent;}

@keyframes updown {
    0% {transform: translateY(-0.5rem);}
    100% {transform: translateY(0.5rem);}
}
</style>

<script>
$(function() {
    $('.tit,.txt01,.txt02').addClass('on');
    /* 팝업 - 코드안내 */
    $('.mEvt114637 .btn-code').click(function(){
        $('.pop-container.third').fadeIn();
    });
    /* 팝업 닫기 */
    $('.mEvt114637 .btn-close').click(function(){
        $(".pop-container").fadeOut();
    })
});

function doAction() {
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
    <% If IsUserLoginOK() Then %>
        if($("#ticketCode").val()==""){
            alert("코드를 입력해주세요.");
            return false;
        }
        $.ajax({
            type: "POST",
            url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript114637.asp",
            data: {
                mode: 'add',
                tcode: $("#ticketCode").val()
            },
            dataType: "JSON",
            success: function(data){
                if(data.response == "ok"){
                    fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode','<%=eCode%>');
                    if(data.resultcode=="0"){
                        $('.pop-container.first').fadeIn();
                    }else{
                        $('.pop-container.second').fadeIn();
                    }
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
</script>
			<div class="mEvt114637">
                <div class="topic">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/114637/m/bg_main.jpg?v=2.1" alt="">
                    <p class="tit"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114637/m/tit01.png?v=2.1" alt="골든티켓"></p>
                    <p class="txt01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114637/m/ticket.png?v=2.1" alt="100만원의 주인공에 도전해보세요!"></p>
                    <p class="txt02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114637/m/txt01.png?v=2.1" alt="행운의 3명에게 주어지는 꿈 같은 기회! 나의 행운을 확인해보세요!"></p>
                </div>
                <div class="section-01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/114637/m/img_sub01_01.jpg?v=2.1" alt="골든 티켓은 어떻게 받을 수 있나요?">
                    <a href="/event/eventmain.asp?eventid=101616" class="mWeb"></a>
                    <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101616');return false;" class="mApp"></a>
                </div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/114637/m/img_sub02.jpg" alt="티켓을 받으면 절대 버리지 마세요!">
                <div class="section-02">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/114637/m/img_sub03.jpg?v=2.2" alt="골든티켓을 받으셨나요?">
                    <input type="text" id="ticketCode" maxlength="8" placeholder="티켓에 적혀있는 코드를 입력해주세요.">
                    <!-- 버튼 - 결과 확인하기 -->
                    <button type="button" class="btn-enter" onclick="doAction();">결과 확인하기</button>
                    <button type="button" class="btn-code"></button>
                </div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/114637/m/noti.jpg" alt="noti">
                <div class="section-03">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/114637/m/link.jpg" alt="링크 보러가기">
                    <a href="/event/eventmain.asp?eventid=101616" class="mWeb link01"></a>
                    <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101616');return false;" class="mApp link01"></a>

                    <a href="https://10x10.co.kr/linker/forum.asp?idx=1" class="mWeb link02"></a>
                    <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/linker/forum.asp?idx=1');return false;" class="mApp link02"></a>

                    <a href="/event/eventmain.asp?eventid=113925" class="mWeb link03"></a>
                    <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=113925');return false;" class="mApp link03"></a>
                </div>
                <!-- 팝업 - 1등 당첨 안내 -->
                <div class="pop-container first">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/114637/m/pop_win.jpg" alt="당첨안내 팝업">
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <!-- 팝업 - 2등 당첨 안내 -->
                <div class="pop-container second">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/114637/m/pop_win02.jpg" alt="당첨안내 팝업">
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <!-- 팝업 - 코드 안내 -->
                <div class="pop-container third">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/114637/m/pop01.png" alt="코드안내 팝업">
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
            </div>
<% if mktTest then %>
<script>
function fnSearchIDLog() {
    if($("#userid").val()==""){
        alert("아이디를 입력해주세요.");
        return false;
    }
    $.ajax({
        type: "POST",
        url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript114637.asp",
        data: {
            mode: 'search',
            userid: $("#userid").val()
        },
        dataType: "JSON",
        success: function(data){
            if(data.response == "ok"){
                $("#loglist").empty().html(data.message);
                if(data.message!=""){
                    $("#resultb").empty().html("<button onclick='fndelSearchLog();'>로그 삭제</button>");
                }
            }else{
                alert(data.message);
            }
        },
        error: function(data){
            alert('시스템 오류입니다.');
        }
    });
}

function fndelSearchLog() {
    if($("#userid").val()==""){
        alert("아이디를 입력해주세요.");
        return false;
    }
    $.ajax({
        type: "POST",
        url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript114637.asp",
        data: {
            mode: 'del',
            userid: $("#userid").val()
        },
        dataType: "JSON",
        success: function(data){
            if(data.response == "ok"){
                alert(data.message);
                $("#loglist").empty();
                $("#resultb").empty();
            }else{
                alert(data.message);
            }
        },
        error: function(data){
            alert('시스템 오류입니다.');
        }
    });
}
</script>
<div>
아이디 로그 조회
<input type="text" id="userid" name="userid"> <button onclick="fnSearchIDLog();">아이디 조회</button>
<ul id="loglist"></ul>
<div id="resultb"></div>
</div>
<% end if %>
<!-- #include virtual="/lib/db/dbclose.asp" -->