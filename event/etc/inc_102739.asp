<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 카카오 싱크 이벤트
' History : 2020-05-20 원승현
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<%
    dim eCode, userid
    IF application("Svr_Info") = "Dev" THEN
        eCode = "102172"
    Else
        eCode = "102739"
    End If

    userid = GetEncLoginUserID()

    dim eventEndDate, currentDate, eventStartDate
    dim subscriptcount  
    dim evtinfo : evtinfo = getEventDate(eCode)

    if not isArray(evtinfo) then
        Call Alert_Return("잘못된 이벤트번호입니다.")
        dbget.close()	:	response.End
    end if

    '변수 초기화
    eventStartDate = cdate(evtinfo(0,0))
    eventEndDate = cdate(evtinfo(1,0))
    currentDate = date()
%>
<style type="text/css">
.mEvt102887 {position:relative;}
.mEvt102887 .topic {position:relative; background:#fbe300;}
.mEvt102887 .topic:after {content:' '; position:absolute; left:0; bottom:0; width:100%; padding-top:53.5%; background:url(//webimage.10x10.co.kr/fixevent/event/2020/102739/m/bg_coin.jpg) 50% 100% no-repeat; background-size:100% auto; animation:3s coin steps(1) 10;}
@keyframes coin {
	0% {background-position:0 0;}
	10% {background-position:0 20%;}
	20% {background-position:0 40%;}
	30% {background-position:0 60%;}
	40% {background-position:0 80%;}
	50%,100% {background-position:0 100%;}
}
.mEvt102887 .step1, .mEvt102887 .step2 {position:relative;}
.mEvt102887 .step1 a {position:absolute; left:0; top:0; width:100%; height:40%; font-size:0; color:transparent;}
.mEvt102887 .step2 .input {position:absolute; left:10%; bottom:20%; width:80%; height:8%; padding:0 5%; font-size:3.7vw; border:0; background:none;}
.mEvt102887 .step2 .input::placeholder {color:#aaaaaa;}
.mEvt102887 .step2 .btn-get {position:absolute; left:0; bottom:0; width:100%; height:20%; font-size:0; color:transparent; background:none;}
.mEvt102887 .lyr {overflow-y:scroll; display:none; position:fixed; top:0; left:0; z-index:10; width:100vw; height:100vh; padding:10vh 0; background:rgba(0,0,0,0.75);}
.mEvt102887 .lyr .inner {position:relative; width:26.88rem; margin:0 auto;}
.mEvt102887 .lyr .inner a {position:absolute; left:0; width:100%; font-size:0; color:transparent;}
.mEvt102887 .lyr .inner .go-my {bottom:17%; height:14%;}
.mEvt102887 .lyr .inner .go-evt {bottom:0; height:17%;}
.mEvt102887 .lyr .btn-close {position:absolute; top:0; right:0; width:18vw; height:13vw; font-size:0; color:transparent; background:none;}
</style>
<script>
    $(function(){
        // 팝업레이어 닫기
        $('.lyr .btn-close').click(function(){
                $(this).closest('.lyr').fadeOut();
        });
    });
    function getMileage() {
        <% if not (currentDate >= eventStartDate and currentDate <= eventEndDate) then %>	
            alert("이벤트 참여기간이 아닙니다.");
            return false;
        <% end if %>

        <% If Not(IsUserLoginOK) Then %>
            <% if isApp=1 then %>
                calllogin();
                return false;
            <% else %>
                jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
                return false;
            <% end if %>
            return false;
        <% else %>
            if ($("#mileageCode").val()=="") {
                alert("쿠폰 번호를 입력해주세요!");
                return false;
            }
            $.ajax({
                type: "post",
                url: "/event/etc/doEvenSubscript102739.asp",		
                data: {
                    mileageCode: $("#mileageCode").val()
                },
                cache: false,
                success: function(resultData) {
                    fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|mileageCode','<%=eCode%>|'+$("#mileageCode").val())
                    var reStr = resultData.split("|");				
                    
                    if(reStr[0]=="OK"){		
                        $('.lyr').fadeIn();
                    }else{
                        var errorMsg = reStr[1].replace(">?n", "\n");
                        alert(errorMsg);					
                    }			
                },
                error: function(err) {
                    console.log(err.responseText);
                }
            });
        <% End If %>
    }

    //Kakao.init('523d793577f1c5116aacc1452942a0e5')
    function fnKakaoChannelAdd() {
        Kakao.Channel.addChannel({
            channelPublicId: '_mGnYh',
        })
    }

    function fnKakaoPlusFriendAdd() {
        fnAmplitudeEventMultiPropertiesAction('click_kakaofriend_link','evtcode','<%=eCode%>');
        <% If isapp="1" Then %>
            setTimeout(function () {
				fnAPPpopupExternalBrowser('http://pf.kakao.com/_mGnYh');
		    }, 200);
        <% Else %>
            setTimeout(function () {        
                window.open('http://pf.kakao.com/_mGnYh');
            }, 200);
        <% End IF %>
    }
</script>
<div class="mEvt102887">
    <div class="topic">
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/102739/m/tit_kakao_v2.png" alt="카카오톡 채널 이벤트"></h2>
    </div>
    <div class="step1">
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/102739/m/txt_step_01.jpg" alt="">
        <a href="" onclick="fnKakaoPlusFriendAdd();return false;">카카오톡 채널</a>
        <!--a href="" onclick="fnAPPpopupExternalBrowser('http://pf.kakao.com/_mGnYh');return false;" class="mApp">카카오톡 채널</a-->
    </div>
    <div class="step2">
        <img src="//webimage.10x10.co.kr/eventIMG/2020/102739/txt_step_02.jpg" alt="">
        <input type="text" name="mileageCode" id="mileageCode" placeholder="쿠폰 번호 입력" class="input">
        <button type="button" onclick="getMileage()" class="btn-get">마일리지 받기</button>
    </div>
    <div class="lyr">
        <div class="inner">
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102739/m/popup.png" alt="지급 완료"></p>
            <a href="/my10x10/mymain.asp" class="go-my mWeb">마이텐바이텐</a>
            <a href="" onclick="fnAPPpopupBrowserURL('마이텐바이텐','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/mymain.asp');return false;" class="go-my mApp">마이텐바이텐</a>
            <a href="/event/eventmain.asp?eventid=102468" target="_blank" class="go-evt mWeb">후기 베스트상품</a>
            <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=102468');return false;" target="_blank" class="go-evt mApp">후기 베스트상품</a>
            <button type="button" class="btn-close">닫기</button>
        </div>
    </div>
    <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102739/m/txt_noti_v2.jpg" alt="유의사항"></p>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->