<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : 신한 체크카드 프로모션
' History : 2020-10-22 원승현
'####################################################
Dim eCode, userid
Dim sqlstr, vQuery, shinhanCheckCount, receiveUserKey
Dim userKeyIssuedMileageCheck

receiveUserKey = requestcheckvar(request("userkey"),2048)

IF application("Svr_Info") = "Dev" THEN
	eCode   =  103246
Else
	eCode   =  106761
End If

userid = GetEncLoginUserID()
userKeyIssuedMileageCheck = False

'// receiveUserKey값이 있을경우엔 신한에서 체크카드 신청완료 후 넘어온 회원
'// 해당 값이 있을경우 실제 회원 DB 체크하여 동일한 아이디가 있는지 확인
If Trim(receiveUserKey) <> "" Then
    vQuery = "SELECT count(*) FROM [db_user].[dbo].[tbl_user_n] WHERE userid='"&tenDec(URLDecodeUTF8(receiveUserKey))&"' "
    rsget.CursorLocation = adUseClient
    rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
    If rsget(0) > 0 Then
        '// userKeyIssuedMileageCheck값이 true일 경우만 마일리지 발급 ajax 작동시킴
        userKeyIssuedMileageCheck = True
    End IF
    rsget.close
End If

' 카드 신청을 완료하고 마일리지를 발급 받았는지 확인
vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' And userid='"&userid&"' And sub_opt2=1 "
rsget.CursorLocation = adUseClient
rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
IF Not rsget.Eof Then
	shinhanCheckCount = rsget(0)
End IF
rsget.close

' 신한 체크카드 신청완료 후 이 페이지로 접근하면 실행할 ajax와 퍼블리싱 파일 나오면 덮으면 됨.
%>
<style type="text/css">
.mEvt106761 .topic {position:relative;}
.mEvt106761 .section-01 {position:relative;}
.mEvt106761 .section-01 .btn-check {position:absolute; left:50%; top:89%; transform:translate(-50%,0);}
.mEvt106761 .section-01 .btn-check a {display:inline-block;}
.mEvt106761 .section-01 .btn-check img {width:25.43rem;}
.mEvt106761 .section-01 .btn-check.none {pointer-events:none; cursor:default;}
.pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(42,137,210,0.949); z-index:150;}
.pop-container.show {display:block;}
.pop-container .pop-inner {position:relative; width:29.13rem; height:22.3rem; margin:3.47rem auto 0; background:#fff; border-radius:0.65rem;}
.pop-container .pop-inner .tit-01 {width:24.09rem; padding-top:4.52rem; margin:0 auto;}
.pop-container .pop-inner .btn-go {display:block; width:14.3rem; margin:0 auto; padding-top:2.08rem;}
.pop-container .pop-inner .btn-close {position:absolute; right:1.73rem; top:1.73rem; width:1.56rem; height:1.56rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/106761/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;} 
.pop-container.more.active {display:block;}
</style>
<script>
$(function() {
    <% If userKeyIssuedMileageCheck Then %>
        jsSubmitIssueMileage106761();
        return false;
    <% End If %>

    $(".pop-container .btn-close").on("click",function(){
        $(".pop-container").css("display","none");
    });    
});

function popupclose106761() {
    $(".pop-container").css("display","none");
}



function jsSubmit106761(){
	<% If IsUserLoginOK() Then %>
		<% If not(left(now(),10)>="2020-10-19" and left(now(),10)<"2020-12-01") Then %>
			alert("이벤트 신청 기간이 아닙니다.");
			return false;
        <% else %>
            <% if shinhanCheckCount > 0 then '// 신청 후 마일리지 발급 받으면 튕김 %>
                alert("이미 신청하셨습니다.");
                return;
            <% end if %>        
            $.ajax({
                type:"GET",
                url:"/event/etc/doEventSubscript106761.asp?mode=ins",
                dataType: "text",
                async:false,
                cache:true,
                success : function(Data, textStatus, jqXHR){
                    if (jqXHR.readyState == 4) {
                        if (jqXHR.status == 200) {
                            if(Data!="") {
                                var str;
                                for(var i in Data)
                                {
                                        if(Data.hasOwnProperty(i))
                                    {
                                        str += Data[i];
                                    }
                                }
                                str = str.replace("undefined","");
                                res = str.split("|");
                                if (res[0]=="OK")
                                {
                                    <% If isApp="1" Then %>
                                        <% IF application("Svr_Info") = "Dev" THEN %>
                                            openbrowser('http://www.shinhan.maxxcard.co.kr/index.do?media=10by10&pd_cd=13&userkey=<%=Server.URLEncode(tenEnc(userid))%>&returnurl=<%=Server.URLEncode("http://testm.10x10.co.kr/event/etc/doeventSubscript106761.asp?eventid="&eCode&"&mode=sCardComplate&userkey="&tenEnc(userid))%>');
                                            return false;                                        
                                        <% Else %>
                                            openbrowser('http://www.shinhan.maxxcard.co.kr/index.do?media=10by10&pd_cd=13&userkey=<%=Server.URLEncode(tenEnc(userid))%>&returnurl=<%=Server.URLEncode("https://m.10x10.co.kr/event/etc/doeventSubscript106761.asp?eventid="&eCode&"&mode=sCardComplate&userkey="&tenEnc(userid))%>');
                                            return false;
                                        <% End If %>
                                    <% Else %>
                                        <% IF application("Svr_Info") = "Dev" THEN %>
                                            window.open('http://www.shinhan.maxxcard.co.kr/index.do?media=10by10&pd_cd=13&userkey=<%=Server.URLEncode(tenEnc(userid))%>&returnurl=<%=Server.URLEncode("http://testm.10x10.co.kr/event/etc/doeventSubscript106761.asp?eventid="&eCode&"&mode=sCardComplate&userkey="&tenEnc(userid))%>');
                                            return false;
                                        <% Else %>
                                            window.open('http://www.shinhan.maxxcard.co.kr/index.do?media=10by10&pd_cd=13&userkey=<%=Server.URLEncode(tenEnc(userid))%>&returnurl=<%=Server.URLEncode("https://m.10x10.co.kr/event/etc/doeventSubscript106761.asp?eventid="&eCode&"&mode=sCardComplate&userkey="&tenEnc(userid))%>');
                                            return false;
                                        <% End If %>
                                    <% End If %>
                                }
                                else
                                {
                                    errorMsg = res[1].replace(">?n", "\n");
                                    alert(errorMsg );
                                    return false;
                                }
                            } else {
                                alert("잘못된 접근 입니다.");
                                //document.location.reload();
                                return false;
                            }
                        }
                    }
                },
                error:function(jqXHR, textStatus, errorThrown){
                    alert("잘못된 접근 입니다.");
                    var str;
                    for(var i in jqXHR)
                    {
                            if(jqXHR.hasOwnProperty(i))
                        {
                            str += jqXHR[i];
                        }
                    }
                    //alert(str);
                    document.location.reload();
                    return false;
                }
            });
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End IF %>
}

function jsSubmitIssueMileage106761(){
    <% If not(left(now(),10)>="2020-10-19" and left(now(),10)<"2020-12-01") Then %>
        alert("이벤트 기간이 지났습니다.");
        return false;
    <% End If %>
    $.ajax({
        type:"GET",
        url:"/event/etc/doEventSubscript106761.asp?mode=sCardComplate&userkey=<%=receiveUserKey%>",
        dataType: "text",
        async:false,
        cache:true,
        success : function(Data, textStatus, jqXHR){
            if (jqXHR.readyState == 4) {
                if (jqXHR.status == 200) {
                    if(Data!="") {
                        var str;
                        for(var i in Data)
                        {
                                if(Data.hasOwnProperty(i))
                            {
                                str += Data[i];
                            }
                        }
                        str = str.replace("undefined","");
                        res = str.split("|");
                        if (res[0]=="OK")
                        {
                            $(".pop-container").css("display","block");
                        }
                        else
                        {
                            errorMsg = res[1].replace(">?n", "\n");
                            alert(errorMsg );
                            return false;
                        }
                    } else {
                        alert("잘못된 접근 입니다.");
                        //document.location.reload();
                        return false;
                    }
                }
            }
        },
        error:function(jqXHR, textStatus, errorThrown){
            alert("잘못된 접근 입니다.");
            var str;
            for(var i in jqXHR)
            {
                    if(jqXHR.hasOwnProperty(i))
                {
                    str += jqXHR[i];
                }
            }
            //alert(str);
            document.location.reload();
            return false;
        }
    });
}
</script>

<%'<!-- 106761 -->%>
<div class="mEvt106761">
    <div class="topic">
        <div class="section-01">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/106761/m/img_section01.png" alt="신한카드 Deep Dream체크(미니언즈) 신청하고 10,000p 받자!">
            <% If shinhanCheckCount > 0 or userKeyIssuedMileageCheck Then %>
                <%' <!-- for dev msg : 신청 완료시 노출되는 버튼 --> %>
                    <div class="btn-check none">
                        <a href="" onclick="return false;">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2020/106761/m/img_btn02.png" alt="신청 완료! ID당 1회만 참여 가능">
                        </a>
                    </div>
            <% Else %>
                <div class="btn-check">
                    <a href="" onclick="jsSubmit106761();return false;">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/106761/m/img_btn01.png" alt="신한카드 Deep Dream 체크 신청하기">
                    </a>
                </div>
            <% End If %>
        </div>
        <div class="section-02">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/106761/m/img_section02.png" alt="신한카드 Deep Dream체크(미니언즈)의 놓칠 수 없는 혜택">
        </div>
        <div class="section-03">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/106761/m/img_section03.png" alt="이벤트 유의사항">
        </div>
    </div>
    <%' <!-- for dev msg : 마일리지 발급안내 팝업 --> %>
    <div class="pop-container" style="display:none;">
        <div class="pop-inner">
            <div class="tit-01">
                <img src="//webimage.10x10.co.kr/fixevent/event/2020/106761/m/img_pop_txt01.png" alt="신한카드 deep dream 체크 신청이 완료되어 텐바이텐 마일리지 10,000p가 지급되었습니다.">
            </div>
            <% If isapp="1" Then %>
                <a href="" onclick="fnAPPpopupBrowserURL('마일리지 내역', 'http://m.10x10.co.kr/apps/appCom/wish/web2014/offshop/point/mileagelist.asp'); return false;" class="btn-go">
            <% Else %>
                <a href="/offshop/point/mileagelist.asp" class="btn-go">
            <% End If %>
                <img src="//webimage.10x10.co.kr/fixevent/event/2020/106761/m/img_btn03.png" alt="마일리지 확인하러 가기">
            </a>
            <button type="button" onclick="popupclose106761();return false;" class="btn-close">닫기</button>
        </div>
    </div>
</div>
<!--// 106761 -->

<!-- #include virtual="/lib/db/dbclose.asp" -->