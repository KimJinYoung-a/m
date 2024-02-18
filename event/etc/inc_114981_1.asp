<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
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
	eCode = "114981"
    mktTest = True
Else
	eCode = "114981"
    mktTest = False
End If

eventStartDate  = cdate("2021-11-01")		'이벤트 시작일
eventEndDate 	= cdate("2021-12-05")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if mktTest then
    currentDate = cdate("2021-09-14")
else
    currentDate = date()
end if

IF application("Svr_Info") = "Dev" THEN
%>
<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js"></script>
<% END IF %>

<style>
.mEvt114981 .section-link {position:relative;}
.mEvt114981 .section-link .link-wrap {display:flex; justify-content:space-between; flex-wrap:wrap; width:88%; position:absolute; margin:0 6%; left:0; top:0; height:90%;  }
.mEvt114981 .section-link .link-wrap div { width:49%; height:47%; }
.mEvt114981 .section-link .link-wrap div a { position:relative; display:inline-block; width:100%; height:100%; }

.mEvt114981 .push-wrap { position:relative; }
.mEvt114981 .push-wrap .push-dim { display:none; position:absolute; bottom:0; left:50%; margin-left:-45.4%; width:90.8%; height:90%; background-color:rgba(0, 0, 0,0.6); z-index:10;}
.mEvt114981 .push-wrap .event-btn {position:absolute; bottom:0; left:50%; margin-left:19%; width:22.5vw; height:120%; background:url(//webimage.10x10.co.kr/fixevent/event/2021/114981/m/btn_start.png?v=4) no-repeat 0 70%; background-size:100%; text-indent:-9999px; }
.mEvt114981 .push-wrap .event-btn.end {width:28%;height:90%;margin-left:17%;background:url(//webimage.10x10.co.kr/fixevent/event/2021/114981/m/btn_end.png?v=2) no-repeat 2vw 75%; background-size:100%;}

.mEvt114981 .pop-container { display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(0, 0, 0,0.6); z-index:150;}
.mEvt114981 .pop-container .pop-inner { width:100%; height:100%; padding:8.47rem 1.7rem 4.17rem; overflow-y: scroll;}
.mEvt114981 .pop-contents {position:relative;}
.mEvt114981 .pop-contents .btn-close {width:16%; height:28%; position:absolute; top:0; left:50%; margin-left:34%; text-indent:-9999px; background:transparent;}
.mEvt114981 .pop-contents .btn-push {width:70%; height:24%; position:absolute; bottom:15%; left:50%; margin-left:-35%;  text-indent:-9999px; background:transparent;}
</style>
<script>
$(function() {
    // 팝업 닫기
    $('.mEvt114981 .btn-close').on('click', function () {
        $(".pop-container").fadeOut();
    });
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
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>

<div class="mEvt114981">
    <img src="//webimage.10x10.co.kr/fixevent/event/2021/114981/m/bg_main.jpg?v=3" alt="">
    <!-- push 알림 영역 -->
    <div class="push-wrap">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114981/m/push_winner.jpg" alt="">
        <div class="push-dim"></div>
    </div>
    <div class="push-wrap">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114981/m/push_up.jpg" alt="">
        <div class="push-dim"></div>
    </div>
    <div class="push-wrap">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114981/m/push_rain.jpg?v=2" alt="">
        <div class="push-dim"></div>
        <% if currentDate >= #2021-11-21  00:00:00# then %>
            <button type="button" class="event-btn end" onclick="goPushScript('<%=eCode%>', 0);">종료알림</button>
        <% elseif %>
            <button type="button" class="event-btn end" onclick="goPushScript('<%=eCode%>', '2021-11-21');">종료알림</button>
        <% end if %>
    </div>
    <div class="push-wrap">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114981/m/push_play.jpg" alt="">
        <div class="push-dim"></div>
        <% If currentDate >= #2021-11-01 00:00:00# and currentDate < #2021-11-28 00:00:00# Then %>
            <button type="button" class="event-btn" onclick="goPushScript('<%=eCode%>', '2021-11-22');">시작알림</button>
        <% elseif currentDate >= #2021-11-28  00:00:00# then %>
            <button type="button" class="event-btn end" onclick="goPushScript('<%=eCode%>', 0);">종료알림</button>
        <% else %>
            <button type="button" class="event-btn end" onclick="goPushScript('<%=eCode%>', '2021-11-28');">종료알림</button>
        <% end if %>
    </div>
    <div class="push-wrap">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114981/m/push_imae.jpg" alt="">
        <div class="push-dim"></div>
        <% If currentDate >= #2021-11-01 00:00:00# and currentDate < #2021-11-29 00:00:00# Then %>
            <button type="button" class="event-btn" onclick="goPushScript('<%=eCode%>', '2021-11-22');">시작알림</button>
        <% elseif currentDate >= #2021-11-29  00:00:00# then %>
            <button type="button" class="event-btn end" onclick="goPushScript('<%=eCode%>', 0);">종료알림</button>
        <% else %>
            <button type="button" class="event-btn end" onclick="goPushScript('<%=eCode%>', '2021-11-28');">종료알림</button>
        <% end if %>
    </div>
     <!-- 팝업 -->
    <div class="pop-container">
        <div class="pop-inner">
            <div class="pop-contents">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/114981/m/bg_popup.png" alt="포인트로 스티커 사러 가자">
                <button type="button" class="btn-close">닫기</button>
                <button type="button" class="btn-push">푸쉬 설정 확인하기</button>
            </div>
        </div>
    </div>

    <img src="//webimage.10x10.co.kr/fixevent/event/2021/114981/m/bg_sub.jpg" alt="">
    <a href="/category/category_itemprd.asp?itemid=4200400&petr=114981"  onclick="fnAPPpopupProduct('4200400&pEtr=114981'); return false;">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114981/m/img_item01.jpg" alt="">
    </a>
    <div class="section-link">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114981/m/img_list01.jpg" alt="">
        <div class="link-wrap">
            <div>
                <a href="/category/category_itemprd.asp?itemid=4200402&petr=114981"  onclick="fnAPPpopupProduct('4200402&pEtr=114981'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=4200401&petr=114981"  onclick="fnAPPpopupProduct('4200401&pEtr=114981'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=4140507&petr=114981"  onclick="fnAPPpopupProduct('4140507&pEtr=114981'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=4108482&petr=114981"  onclick="fnAPPpopupProduct('4108482&pEtr=114981'); return false;"></a>
            </div>
        </div>
    </div>

    <a href="/category/category_itemprd.asp?itemid=4200492&petr=114981"  onclick="fnAPPpopupProduct('4200492&pEtr=114981'); return false;">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114981/m/img_item02.jpg" alt="">
    </a>
    <div class="section-link">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114981/m/img_list02.jpg" alt="">
        <div class="link-wrap">
            <div>
                <a href="/category/category_itemprd.asp?itemid=3811313&petr=114981"  onclick="fnAPPpopupProduct('3811313&pEtr=114981'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=2852218&petr=114981"  onclick="fnAPPpopupProduct('2852218&pEtr=114981'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=1890391&petr=114981"  onclick="fnAPPpopupProduct('1890391&pEtr=114981'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=2800413&petr=114981"  onclick="fnAPPpopupProduct('2800413&pEtr=114981'); return false;"></a>
            </div>
        </div>
    </div>

    <a href="/category/category_itemprd.asp?itemid=2682613&petr=114981"  onclick="fnAPPpopupProduct('2682613&pEtr=114981'); return false;">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114981/m/img_item03.jpg" alt="">
    </a>
    <div class="section-link">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114981/m/img_list03.jpg" alt="">
        <div class="link-wrap">
            <div>
                <a href="/category/category_itemprd.asp?itemid=3711315&petr=114981"  onclick="fnAPPpopupProduct('3711315&pEtr=114981'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=3666165&petr=114981"  onclick="fnAPPpopupProduct('3666165&pEtr=114981'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=4108481&petr=114981"  onclick="fnAPPpopupProduct('4108481&pEtr=114981'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=2813917&petr=114981"  onclick="fnAPPpopupProduct('2813917&pEtr=114981'); return false;"></a>
            </div>
        </div>
    </div>

    <a href="/category/category_itemprd.asp?itemid=4200403&petr=114981"  onclick="fnAPPpopupProduct('4200403&pEtr=114981'); return false;">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114981/m/img_item04.jpg" alt="">
    </a>
    <div class="section-link">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114981/m/img_list04.jpg" alt="">
        <div class="link-wrap">
            <div>
                <a href="/category/category_itemprd.asp?itemid=3538962&petr=114981"  onclick="fnAPPpopupProduct('3538962&pEtr=114981'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=2933939&petr=114981"  onclick="fnAPPpopupProduct('2933939&pEtr=114981'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=2933943&petr=114981"  onclick="fnAPPpopupProduct('2933943&pEtr=114981'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=2932767&petr=114981"  onclick="fnAPPpopupProduct('2932767&pEtr=114981'); return false;"></a>
            </div>
        </div>
    </div>

    <p class="special"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114981/m/bg_special.jpg?v=2" alt=""></p>
    <a href="/brand/brand_detail2020.asp?brandid=artholic1 " class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114981/m/bg_coupon.jpg" alt="artholic1"></a>
    <a href="#" onclick="fnAPPpopupBrand('artholic1'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114981/m/bg_coupon.jpg" alt="artholic1"></a>
</div>