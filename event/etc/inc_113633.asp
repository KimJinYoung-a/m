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
	eCode = "113633"
    mktTest = True
Else
	eCode = "113633"
    mktTest = False
End If

eventStartDate  = cdate("2021-09-06")		'이벤트 시작일
eventEndDate 	= cdate("2021-09-12")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if mktTest then
    currentDate = cdate("2021-09-07")
else
    currentDate = date()
end if

IF application("Svr_Info") = "Dev" THEN
%>
<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js"></script>
<% END IF %>

<style>
.mEvt113633 .section-link {position:relative;}
.mEvt113633 .section-link .link-wrap {display:flex; justify-content:space-between; flex-wrap:wrap; width:88%; position:absolute; margin:0 6%; left:0; top:0; height:90%;  }
.mEvt113633 .section-link .link-wrap div { width:49%; height:47%; }
.mEvt113633 .section-link .link-wrap div a { position:relative; display:inline-block; width:100%; height:100%; }

.mEvt113633 .push-wrap { position:relative; }
.mEvt113633 .push-wrap .push-dim { display:none; position:absolute; bottom:0; left:50%; margin-left:-45.4%; width:90.8%; height:90%; background-color:rgba(0, 0, 0,0.6); z-index:10;}
.mEvt113633 .push-wrap .event-btn {position:absolute; bottom:0; left:50%; margin-left:17%; width:28%; height:90%; background:url(//webimage.10x10.co.kr/fixevent/event/2021/113633/m/btn_start.png) no-repeat 2vw 75%; background-size:100%; text-indent:-9999px; }
.mEvt113633 .push-wrap .event-btn.end {background:url(//webimage.10x10.co.kr/fixevent/event/2021/113633/m/btn_end.png) no-repeat 2vw 75%; background-size:100%;}

.mEvt113633 .pop-container { display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(0, 0, 0,0.6); z-index:150;}
.mEvt113633 .pop-container .pop-inner { width:100%; height:100%; padding:8.47rem 1.7rem 4.17rem; overflow-y: scroll;}
.mEvt113633 .pop-contents {position:relative;}
.mEvt113633 .pop-contents .btn-close {width:16%; height:28%; position:absolute; top:0; left:50%; margin-left:34%; text-indent:-9999px; background:transparent;}
.mEvt113633 .pop-contents .btn-push {width:70%; height:24%; position:absolute; bottom:15%; left:50%; margin-left:-35%;  text-indent:-9999px; background:transparent;}
</style>
<script>
$(function() {
    // 팝업 닫기
    $('.mEvt113633 .btn-close').on('click', function () {
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

<div class="mEvt113633">
    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113633/m/bg_main.jpg?v=2" alt="">
    <!-- push 알림 영역 -->
    <div class="push-wrap">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113633/m/push_macmoc.jpg?v=2" alt="">
        <div class="push-dim"></div>
    </div>
    <div class="push-wrap">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113633/m/push_lune.jpg" alt="">
        <div class="push-dim"></div>
        <% If currentDate >= #2021-09-06 00:00:00# and currentDate < #2021-09-12 00:00:00# Then %>
            <button type="button" class="event-btn end" onclick="goPushScript('<%=eCode%>', '2021-09-06');">종료알림</button>
        <% elseif currentDate >= #2021-09-12 00:00:00# then %>
            <button type="button" class="event-btn end" onclick="goPushScript('<%=eCode%>', 0);">종료알림</button>
        <% end if %>
    </div>
    <div class="push-wrap">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113633/m/push_penec.jpg" alt="">
        <div class="push-dim"></div>
        <% If currentDate >= #2021-09-06 00:00:00# and currentDate < #2021-09-13 00:00:00# Then %>
            <button type="button" class="event-btn" onclick="goPushScript('<%=eCode%>', '2021-09-13');">시작알림</button>
        <% elseif currentDate >= #2021-09-19  00:00:00# then %>
            <button type="button" class="event-btn end" onclick="goPushScript('<%=eCode%>', 0);">종료알림</button>
        <% else %>
            <button type="button" class="event-btn end" onclick="goPushScript('<%=eCode%>', '2021-09-19');">종료알림</button>
        <% end if %>
    </div>
    <div class="push-wrap">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113633/m/push_ulala.jpg" alt="">
        <div class="push-dim"></div>
        <% If currentDate >= #2021-09-06 00:00:00# and currentDate < #2021-09-20 00:00:00# Then %>
            <button type="button" class="event-btn" onclick="goPushScript('<%=eCode%>', '2021-09-20');">시작알림</button>
        <% elseif currentDate >= #2021-09-26  00:00:00# then %>
            <button type="button" class="event-btn end" onclick="goPushScript('<%=eCode%>', 0);">종료알림</button>
        <% else %>
            <button type="button" class="event-btn end" onclick="goPushScript('<%=eCode%>', '2021-09-26');">종료알림</button>
        <% end if %>
    </div>
    <div class="push-wrap">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113633/m/push_amore.jpg" alt="">
        <div class="push-dim"></div>
        <% If currentDate >= #2021-09-06 00:00:00# and currentDate < #2021-09-27 00:00:00# Then %>
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
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113633/m/bg_popup.png" alt="포인트로 스티커 사러 가자">
                <button type="button" class="btn-close">닫기</button>
                <button type="button" class="btn-push">푸쉬 설정 확인하기</button>
            </div>
        </div>
    </div>

    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113633/m/bg_sub.jpg?v=2" alt="">
    <a href="/category/category_itemprd.asp?itemid=3844825&petr=113633"  onclick="fnAPPpopupProduct('3844825&pEtr=113633'); return false;">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113633/m/img_item01.jpg" alt="">
    </a>
    <div class="section-link">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113633/m/img_list01.jpg" alt="">
        <div class="link-wrap">
            <div>
                <a href="/category/category_itemprd.asp?itemid=3030843&petr=113633"  onclick="fnAPPpopupProduct('3030843&pEtr=113633'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=3031127&petr=113633"  onclick="fnAPPpopupProduct('3031127&pEtr=113633'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=3065632&petr=113633"  onclick="fnAPPpopupProduct('3065632&pEtr=113633'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=3030841&petr=113633"  onclick="fnAPPpopupProduct('3030841&pEtr=113633'); return false;"></a>
            </div>
        </div>
    </div>

    <a href="/category/category_itemprd.asp?itemid=3867165&petr=113633"  onclick="fnAPPpopupProduct('3867165&pEtr=113633'); return false;">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113633/m/img_item02.jpg" alt="">
    </a>
    <div class="section-link">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113633/m/img_list02.jpg" alt="">
        <div class="link-wrap">
            <div>
                <a href="/category/category_itemprd.asp?itemid=3513482&petr=113633"  onclick="fnAPPpopupProduct('3513482&pEtr=113633'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=3541085&petr=113633"  onclick="fnAPPpopupProduct('3541085&pEtr=113633'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=4040868&petr=113633"  onclick="fnAPPpopupProduct('4040868&pEtr=113633'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=4040866&petr=113633"  onclick="fnAPPpopupProduct('4040866&pEtr=113633'); return false;"></a>
            </div>
        </div>
    </div>

    <a href="/category/category_itemprd.asp?itemid=4040896&petr=113633"  onclick="fnAPPpopupProduct('4040896&pEtr=113633'); return false;">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113633/m/img_item03.jpg" alt="">
    </a>
    <div class="section-link">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113633/m/img_list03.jpg" alt="">
        <div class="link-wrap">
            <div>
                <a href="/category/category_itemprd.asp?itemid=4037314&petr=113633"  onclick="fnAPPpopupProduct('4037314&pEtr=113633'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=4037316&petr=113633"  onclick="fnAPPpopupProduct('4037316&pEtr=113633'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=4040254&petr=113633"  onclick="fnAPPpopupProduct('4040254&pEtr=113633'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=4037313&petr=113633"  onclick="fnAPPpopupProduct('4037313&pEtr=113633'); return false;"></a>
            </div>
        </div>
    </div>
    <p class="coupon"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113633/m/bg_coupon.jpg" alt=""></p>
    <a href="/brand/brand_detail2020.asp?brandid=lunne1 " class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113633/m/bg_lune.jpg" alt="lunne"></a>
    <a href="#" onclick="fnAPPpopupBrand('lunne1'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113633/m/bg_lune.jpg" alt="lunne"></a>
</div>