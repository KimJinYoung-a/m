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
	eCode = "113711"
    mktTest = True
Else
	eCode = "113711"
    mktTest = False
End If

eventStartDate  = cdate("2021-09-27")		'이벤트 시작일
eventEndDate 	= cdate("2021-10-03")		'이벤트 종료일

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
.mEvt113711 .section-link {position:relative;}
.mEvt113711 .section-link .link-wrap {display:flex; justify-content:space-between; flex-wrap:wrap; width:88%; position:absolute; margin:0 6%; left:0; top:0; height:90%;  }
.mEvt113711 .section-link .link-wrap div { width:49%; height:47%; }
.mEvt113711 .section-link .link-wrap div a { position:relative; display:inline-block; width:100%; height:100%; }

.mEvt113711 .push-wrap { position:relative; }
.mEvt113711 .push-wrap .push-dim { display:none; position:absolute; bottom:0; left:50%; margin-left:-45.4%; width:90.8%; height:90%; background-color:rgba(0, 0, 0,0.6); z-index:10;}
.mEvt113711 .push-wrap .event-btn {position:absolute; bottom:0; left:50%; margin-left:17%; width:28%; height:90%; background:url(//webimage.10x10.co.kr/fixevent/event/2021/113711/m/btn_start.png) no-repeat 2vw 75%; background-size:100%; text-indent:-9999px; }
.mEvt113711 .push-wrap .event-btn.end {background:url(//webimage.10x10.co.kr/fixevent/event/2021/113711/m/btn_end.png) no-repeat 2vw 75%; background-size:100%;}

.mEvt113711 .pop-container { display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(0, 0, 0,0.6); z-index:150;}
.mEvt113711 .pop-container .pop-inner { width:100%; height:100%; padding:8.47rem 1.7rem 4.17rem; overflow-y: scroll;}
.mEvt113711 .pop-contents {position:relative;}
.mEvt113711 .pop-contents .btn-close {width:16%; height:28%; position:absolute; top:0; left:50%; margin-left:34%; text-indent:-9999px; background:transparent;}
.mEvt113711 .pop-contents .btn-push {width:70%; height:24%; position:absolute; bottom:15%; left:50%; margin-left:-35%;  text-indent:-9999px; background:transparent;}
</style>
<script>
$(function() {
    // 팝업 닫기
    $('.mEvt113711 .btn-close').on('click', function () {
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

<div class="mEvt113711">
    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113711/m/bg_main.jpg?v=3" alt="">
    <!-- push 알림 영역 -->
    <div class="push-wrap">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113711/m/push_macmoc.jpg?v=3" alt="">
        <div class="push-dim"></div>
    </div>
    <div class="push-wrap">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113711/m/push_lune.jpg?v=3" alt="">
        <div class="push-dim"></div>
    </div>
    <div class="push-wrap">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113711/m/push_penec.jpg?v=3" alt="">
        <div class="push-dim"></div>
    </div>
    <div class="push-wrap">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113711/m/push_ulala.jpg?v=3" alt="">
        <div class="push-dim"></div>
    </div>
    <div class="push-wrap">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113711/m/push_amore.jpg?v=3" alt="">
        <div class="push-dim"></div>
        <% If currentDate >= #2021-09-13 00:00:00# and currentDate < #2021-09-27 00:00:00# Then %>
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
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113711/m/bg_popup.png?v=5" alt="포인트로 스티커 사러 가자">
                <button type="button" class="btn-close">닫기</button>
                <button type="button" class="btn-push">푸쉬 설정 확인하기</button>
            </div>
        </div>
    </div>

    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113711/m/bg_sub.jpg??v=3" alt="">
    <a href="/category/category_itemprd.asp?itemid=2998821&petr=113711"  onclick="fnAPPpopupProduct('2998821&pEtr=113711'); return false;">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113711/m/img_item01.jpg?v=3" alt="">
    </a>
    <div class="section-link">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113711/m/img_list01.jpg?v=3" alt="">
        <div class="link-wrap">
            <div>
                <a href="/category/category_itemprd.asp?itemid=3762966&petr=113711"  onclick="fnAPPpopupProduct('3762966&pEtr=113711'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=2994592&petr=113711"  onclick="fnAPPpopupProduct('2994592&pEtr=113711'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=2998834&petr=113711"  onclick="fnAPPpopupProduct('2998834&pEtr=113711'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=3675412&petr=113711"  onclick="fnAPPpopupProduct('3675412&pEtr=113711'); return false;"></a>
            </div>
        </div>
    </div>

    <a href="/category/category_itemprd.asp?itemid=4088982&petr=113711"  onclick="fnAPPpopupProduct('4088982&pEtr=113711'); return false;">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113711/m/img_item02.jpg?v=4" alt="">
    </a>
    <div class="section-link">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113711/m/img_list02.jpg?v=4" alt="">
        <div class="link-wrap">
            <div>
                <a href="/category/category_itemprd.asp?itemid=3397491&petr=113711"  onclick="fnAPPpopupProduct('3397491&pEtr=113711'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=3683306&petr=113711"  onclick="fnAPPpopupProduct('3683306&pEtr=113711'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=3967410&petr=113711"  onclick="fnAPPpopupProduct('3967410&pEtr=113711'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=3068185&petr=113711"  onclick="fnAPPpopupProduct('3068185&pEtr=113711'); return false;"></a>
            </div>
        </div>
    </div>

    <a href="/category/category_itemprd.asp?itemid=3984332&petr=113711"  onclick="fnAPPpopupProduct('3984332&pEtr=113711'); return false;">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113711/m/img_tem003.jpg" alt="">
    </a>
    <div class="section-link">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113711/m/img_list_003.jpg" alt="">
        <div class="link-wrap">
            <div>
                <a href="/category/category_itemprd.asp?itemid=4068121&petr=113711"  onclick="fnAPPpopupProduct('4068121&pEtr=113711'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=3979218&petr=113711"  onclick="fnAPPpopupProduct('3979218&pEtr=113711'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=3126962&petr=113711"  onclick="fnAPPpopupProduct('3126962&pEtr=113711'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=3042641&petr=113711"  onclick="fnAPPpopupProduct('3042641&pEtr=113711'); return false;"></a>
            </div>
        </div>
    </div>

    <a href="/category/category_itemprd.asp?itemid=3005309&petr=113711"  onclick="fnAPPpopupProduct('3005309&pEtr=113711'); return false;">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113711/m/img_item04.jpg?v=3" alt="">
    </a>
    <div class="section-link">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113711/m/img_list04.jpg?v=3" alt="">
        <div class="link-wrap">
            <div>
                <a href="/category/category_itemprd.asp?itemid=3590156&petr=113711"  onclick="fnAPPpopupProduct('3590156&pEtr=113711'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=3762964&petr=113711"  onclick="fnAPPpopupProduct('3762964&pEtr=113711'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=3005323&petr=113711"  onclick="fnAPPpopupProduct('3005323&pEtr=113711'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=3005319&petr=113711"  onclick="fnAPPpopupProduct('3005319&pEtr=113711'); return false;"></a>
            </div>
        </div>
    </div>

    <a href="/category/category_itemprd.asp?itemid=3641454&petr=113711"  onclick="fnAPPpopupProduct('3641454&pEtr=113711'); return false;">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113711/m/img_item05.jpg?v=3" alt="">
    </a>
    <div class="section-link">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113711/m/img_list05.jpg?v=3" alt="">
        <div class="link-wrap">
            <div>
                <a href="/category/category_itemprd.asp?itemid=3206875&petr=113711"  onclick="fnAPPpopupProduct('3206875&pEtr=113711'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=3641455&petr=113711"  onclick="fnAPPpopupProduct('3641455&pEtr=113711'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=2975510&petr=113711"  onclick="fnAPPpopupProduct('2975510&pEtr=113711'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=2975566&petr=113711"  onclick="fnAPPpopupProduct('2975566&pEtr=113711'); return false;"></a>
            </div>
        </div>
    </div>

    <a href="/category/category_itemprd.asp?itemid=3362824&petr=113711"  onclick="fnAPPpopupProduct('3362824&pEtr=113711'); return false;">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113711/m/img_item06.jpg?v=3" alt="">
    </a>
    <div class="section-link">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113711/m/img_list06.jpg?v=3" alt="">
        <div class="link-wrap">
            <div>
                <a href="/category/category_itemprd.asp?itemid=3172957&petr=113711"  onclick="fnAPPpopupProduct('3172957&pEtr=113711'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=3884466&petr=113711"  onclick="fnAPPpopupProduct('3884466&pEtr=113711'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=3165608&petr=113711"  onclick="fnAPPpopupProduct('3165608&pEtr=113711'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=3165594&petr=113711"  onclick="fnAPPpopupProduct('3165594&pEtr=113711'); return false;"></a>
            </div>
        </div>
    </div>

    
    <p class="coupon"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113711/m/bg_coupon.jpg?v=1" alt=""></p>
    <p class="special"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113711/m/bg_special.jpg?v=2" alt=""></p>
    <a href="/brand/brand_detail2020.asp?brandid=AMOREPACIFIC " class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113711/m/bg_amore.jpg" alt="AMOREPACIFIC"></a>
    <a href="#" onclick="fnAPPpopupBrand('AMOREPACIFIC'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113711/m/bg_amore.jpg" alt="AMOREPACIFIC"></a>
</div>