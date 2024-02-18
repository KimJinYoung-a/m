<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 브랜드위크
' History : 2021-08-13 정태훈
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
dim eCode, currentDate

IF application("Svr_Info") = "Dev" THEN
	eCode = "108384"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "113471"
    mktTest = True
Else
	eCode = "113471"
    mktTest = False
End If

eventStartDate  = cdate("2021-08-30")		'이벤트 시작일
eventEndDate 	= cdate("2021-09-05")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if mktTest then
    currentDate = cdate("2021-08-30")
else
    currentDate = date()
end if

IF application("Svr_Info") = "Dev" THEN
%>
<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js"></script>
<% END IF %>
<style>
.mEvt113471 .section-link {position:relative;}
.mEvt113471 .section-link .link-wrap {display:flex; justify-content:space-between; flex-wrap:wrap; width:88%; position:absolute; margin:0 6%; left:0; top:0; height:90%;  }
.mEvt113471 .section-link .link-wrap div { width:49%; height:47%; }
.mEvt113471 .section-link .link-wrap div a { position:relative; display:inline-block; width:100%; height:100%; }

.mEvt113471 .push-wrap { position:relative; }
.mEvt113471 .push-wrap .push-dim { display:none; position:absolute; bottom:0; left:50%; margin-left:-45.4%; width:90.8%; height:90%; background-color:rgba(0, 0, 0,0.6); z-index:10;}
.mEvt113471 .push-wrap .event-btn {position:absolute; bottom:0; left:50%; margin-left:17%; width:28%; height:90%; background:url(//webimage.10x10.co.kr/fixevent/event/2021/113471/m/btn_start.png) no-repeat 0 75%; background-size:100%; text-indent:-9999px; }
.mEvt113471 .push-wrap .event-btn.end {background:url(//webimage.10x10.co.kr/fixevent/event/2021/113471/m/btn_end.png) no-repeat 0 75%; background-size:100%;}

.mEvt113471 .pop-container { display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(0, 0, 0,0.6); z-index:150;}
.mEvt113471 .pop-container .pop-inner { width:100%; height:100%; padding:8.47rem 1.7rem 4.17rem; overflow-y: scroll;}
.mEvt113471 .pop-contents {position:relative;}
.mEvt113471 .pop-contents .btn-close {width:16%; height:28%; position:absolute; top:0; left:50%; margin-left:34%; text-indent:-9999px; background:transparent;}
.mEvt113471 .pop-contents .btn-push {width:70%; height:24%; position:absolute; bottom:15%; left:50%; margin-left:-35%;  text-indent:-9999px; background:transparent;}
</style>
<script>
$(function() {
    // 팝업 닫기
    $('.mEvt113471 .btn-close').on('click', function () {
        $(".pop-container").fadeOut();
    })
});

function goPushScript(evt_code, pushTime){
<% If Not(IsUserLoginOK) Then %>
    <% if isApp="1" then %>
        calllogin();
    <% else %>
        jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
    <% end if %>
    return false;
<% else %>
    <% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>
        alert("이벤트 참여기간이 아닙니다.");
        return false;
    <% end if %>

    if(pushTime == 0){
        alert("푸시 신청 기간이 아닙니다.");
        return false;
    }else{
        $.ajax({
            type:"GET",
            url:"/event/etc/doeventsubscript/doGoPushScript.asp?mode=pushadd&pushTime="+pushTime+"&evt_code=" + evt_code,
            dataType: "json",
            success : function(result){
                if(result.response == "ok"){
                    $('.pop-container').fadeIn();
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
<% end if %>
}

</script>

<div class="mEvt113471">
    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113471/m/bg_main.jpg?v=3" alt="">
    <!-- push 알림 영역 -->
    <div class="push-wrap">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113471/m/push_macmoc.jpg?v=2" alt="">
        <!-- 종료된 기획전 dim 처리 -->
        <div class="push-dim"></div>
       <!-- 종료 알림 push btn 클래스 end 추가 -->
       <% If currentDate >= #2021-08-30 00:00:00# and currentDate < #2021-09-06 00:00:00# Then %>
       <button type="button" class="event-btn end" onclick="goPushScript('<%=eCode%>', '2021-09-06');">종료알림</button>
       <% elseif currentDate >= #2021-09-06 00:00:00# then %>
       <button type="button" class="event-btn end" onclick="goPushScript('<%=eCode%>', 0);">종료알림</button>
       <% end if %>
    </div>
    <div class="push-wrap">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113471/m/push_lune.jpg?v=2" alt="">
        <div class="push-dim"></div>
        <% If currentDate >= #2021-08-30 00:00:00# and currentDate < #2021-09-06 00:00:00# Then %>
            <button type="button" class="event-btn" onclick="goPushScript('<%=eCode%>', '2021-09-06');">시작알림</button>
        <% elseif currentDate >= #2021-09-13  00:00:00# then %>
            <button type="button" class="event-btn end" onclick="goPushScript('<%=eCode%>', 0);">종료알림</button>
        <% else %>
            <button type="button" class="event-btn end" onclick="goPushScript('<%=eCode%>', '2021-09-13');">종료알림</button>
        <% end if %>
    </div>
    <div class="push-wrap">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113471/m/push_penec.jpg?v=2" alt="">
        <div class="push-dim"></div>
        <% If currentDate >= #2021-08-30 00:00:00# and currentDate < #2021-09-13 00:00:00# Then %>
            <button type="button" class="event-btn" onclick="goPushScript('<%=eCode%>', '2021-09-13');">시작알림</button>
        <% elseif currentDate >= #2021-09-19  00:00:00# then %>
            <button type="button" class="event-btn end" onclick="goPushScript('<%=eCode%>', 0);">종료알림</button>
        <% else %>
            <button type="button" class="event-btn end" onclick="goPushScript('<%=eCode%>', '2021-09-19');">종료알림</button>
        <% end if %>
    </div>
    <div class="push-wrap">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113471/m/push_ulala.jpg?v=2" alt="">
        <div class="push-dim"></div>
        <% If currentDate >= #2021-08-30 00:00:00# and currentDate < #2021-09-20 00:00:00# Then %>
            <button type="button" class="event-btn" onclick="goPushScript('<%=eCode%>', '2021-09-20');">시작알림</button>
        <% elseif currentDate >= #2021-09-26  00:00:00# then %>
            <button type="button" class="event-btn end" onclick="goPushScript('<%=eCode%>', 0);">종료알림</button>
        <% else %>
            <button type="button" class="event-btn end" onclick="goPushScript('<%=eCode%>', '2021-09-26');">종료알림</button>
        <% end if %>
    </div>
    <div class="push-wrap">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113471/m/push_amore.jpg?v=2" alt="">
        <div class="push-dim"></div>
        <% If currentDate >= #2021-08-30 00:00:00# and currentDate < #2021-09-27 00:00:00# Then %>
            <button type="button" class="event-btn" onclick="goPushScript('<%=eCode%>', '2021-09-27');">시작알림</button>
        <% elseif currentDate >= #2021-10-03  00:00:00# then %>
            <button type="button" class="event-btn end" onclick="goPushScript('<%=eCode%>', 0);">종료알림</button>
        <% else %>
            <button type="button" class="event-btn end" onclick="goPushScript('<%=eCode%>', '2021-10-03');">종료알림</button>
        <% end if %>
    </div>
     <!-- 팝업 -->
    <div class="pop-container">
        <div class="pop-inner">
            <div class="pop-contents">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113471/m/bg_popup.png?v=2" alt="포인트로 스티커 사러 가자">
                <button type="button" class="btn-close">닫기</button>
                <button onclick="fnAPPpopupSetting();" type="button" class="btn-push">푸쉬 설정 확인하기</button>
            </div>
        </div>
    </div>

    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113471/m/bg_sub.jpg" alt="">

    <a href="/category/category_itemprd.asp?itemid=4023447&petr=113471"  onclick="fnAPPpopupProduct('4023447&pEtr=113471'); return false;">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113471/m/item01.jpg" alt="">
    </a>
    <a href="/category/category_itemprd.asp?itemid=4023446&petr=113471"  onclick="fnAPPpopupProduct('4023446&pEtr=113471'); return false;">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113471/m/item02.jpg" alt="">
    </a>

    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113471/m/gift_event.jpg" alt="">

    <a href="/category/category_itemprd.asp?itemid=3185714&petr=113471"  onclick="fnAPPpopupProduct('3185714&pEtr=113471'); return false;">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113471/m/item03.jpg" alt="">
    </a>
    <a href="/category/category_itemprd.asp?itemid=3650573&petr=113471"  onclick="fnAPPpopupProduct('3650573&pEtr=113471'); return false;">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113471/m/item04.jpg" alt="">
    </a>
    <a href="/category/category_itemprd.asp?itemid=2375621&petr=113471"  onclick="fnAPPpopupProduct('2375621&pEtr=113471'); return false;">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113471/m/item05.jpg" alt="">
    </a>
    <a href="/category/category_itemprd.asp?itemid=3879051&petr=113471"  onclick="fnAPPpopupProduct('3879051&pEtr=113471'); return false;">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113471/m/item06.jpg" alt="">
    </a>
    <a href="/category/category_itemprd.asp?itemid=2944509&petr=113471"  onclick="fnAPPpopupProduct('2944509&pEtr=113471'); return false;">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113471/m/item07.jpg" alt="">
    </a>
    

    <a href="/brand/brand_detail2020.asp?brandid=macmoc " class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113471/m/bg_macmoc.jpg?v=3" alt="macmoc"></a>
    <a href="#" onclick="fnAPPpopupBrand('macmoc'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113471/m/bg_macmoc.jpg?v=3" alt="macmoc"></a>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->