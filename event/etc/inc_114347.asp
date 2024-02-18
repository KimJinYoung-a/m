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
	eCode = "114347"
    mktTest = True
Else
	eCode = "114347"
    mktTest = False
End If

eventStartDate  = cdate("2021-10-18")		'이벤트 시작일
eventEndDate 	= cdate("2021-10-24")		'이벤트 종료일

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
.mEvt114347 .section-link {position:relative;}
.mEvt114347 .section-link .link-wrap {display:flex; justify-content:space-between; flex-wrap:wrap; width:88%; position:absolute; margin:0 6%; left:0; top:0; height:90%;  }
.mEvt114347 .section-link .link-wrap div { width:49%; height:47%; }
.mEvt114347 .section-link .link-wrap div a { position:relative; display:inline-block; width:100%; height:100%; }

.mEvt114347 .push-wrap { position:relative; }
.mEvt114347 .push-wrap .push-dim { display:none; position:absolute; bottom:0; left:50%; margin-left:-45.4%; width:90.8%; height:90%; background-color:rgba(0, 0, 0,0.6); z-index:10;}
.mEvt114347 .push-wrap .event-btn {position:absolute; bottom:0; left:50%; margin-left:17%; width:28%; height:90%; background:url(//webimage.10x10.co.kr/fixevent/event/2021/114347/m/btn_start.png) no-repeat 2vw 75%; background-size:100%; text-indent:-9999px; }
.mEvt114347 .push-wrap .event-btn.end {background:url(//webimage.10x10.co.kr/fixevent/event/2021/114347/m/btn_end.png) no-repeat 2vw 75%; background-size:100%;}

.mEvt114347 .pop-container { display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(0, 0, 0,0.6); z-index:150;}
.mEvt114347 .pop-container .pop-inner { width:100%; height:100%; padding:8.47rem 1.7rem 4.17rem; overflow-y: scroll;}
.mEvt114347 .pop-contents {position:relative;}
.mEvt114347 .pop-contents .btn-close {width:16%; height:28%; position:absolute; top:0; left:50%; margin-left:34%; text-indent:-9999px; background:transparent;}
.mEvt114347 .pop-contents .btn-push {width:70%; height:24%; position:absolute; bottom:15%; left:50%; margin-left:-35%;  text-indent:-9999px; background:transparent;}
</style>
<script>
$(function() {
    // 팝업 닫기
    $('.mEvt114347 .btn-close').on('click', function () {
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

<div class="mEvt114347">
    <img src="//webimage.10x10.co.kr/fixevent/event/2021/114347/m/bg_main.jpg?v=3" alt="">
    <!-- push 알림 영역 -->
    <div class="push-wrap">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114347/m/push_live.jpg?v=2" alt="">
        <div class="push-dim"></div>
    </div>
    <div class="push-wrap">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114347/m/push_daily.jpg?v=2" alt="">
        <div class="push-dim"></div>
    </div>
    <div class="push-wrap">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114347/m/push_oa.jpg?v=2" alt="">
        <div class="push-dim"></div>
        <% If currentDate >= #2021-10-04 00:00:00# and currentDate < #2021-10-17 00:00:00# Then %>
            <button type="button" class="event-btn" onclick="goPushScript('<%=eCode%>', '2021-10-18');">시작알림</button>
        <% elseif currentDate >= #2021-10-25  00:00:00# then %>
            <button type="button" class="event-btn end" onclick="goPushScript('<%=eCode%>', 0);">종료알림</button>
        <% else %>
            <button type="button" class="event-btn end" onclick="goPushScript('<%=eCode%>', '2021-10-24');">종료알림</button>
        <% end if %>
    </div>
    <div class="push-wrap">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114347/m/push_roma.jpg?v=2" alt="">
        <div class="push-dim"></div>
        <% If currentDate >= #2021-10-04 00:00:00# and currentDate < #2021-10-24 00:00:00# Then %>
            <button type="button" class="event-btn" onclick="goPushScript('<%=eCode%>', '2021-10-25');">시작알림</button>
        <% elseif currentDate >= #2021-11-01  00:00:00# then %>
            <button type="button" class="event-btn end" onclick="goPushScript('<%=eCode%>', 0);">종료알림</button>
        <% else %>
            <button type="button" class="event-btn end" onclick="goPushScript('<%=eCode%>', '2021-10-31');">종료알림</button>
        <% end if %>
    </div>
     <!-- 팝업 -->
    <div class="pop-container">
        <div class="pop-inner">
            <div class="pop-contents">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/114347/m/bg_popup.png?v=2" alt="포인트로 스티커 사러 가자">
                <button type="button" class="btn-close">닫기</button>
                <button type="button" class="btn-push">푸쉬 설정 확인하기</button>
            </div>
        </div>
    </div>

    <img src="//webimage.10x10.co.kr/fixevent/event/2021/114347/m/bg_sub.jpg?v=2" alt="">
    <a href="/category/category_itemprd.asp?itemid=1566700&petr=114347"  onclick="fnAPPpopupProduct('1566700&pEtr=114347'); return false;">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114347/m/img_item01.jpg?v=2" alt="">
    </a>
    <div class="section-link">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114347/m/img_list01.jpg?v=2" alt="">
        <div class="link-wrap">
            <div>
                <a href="/category/category_itemprd.asp?itemid=3329933&petr=114347"  onclick="fnAPPpopupProduct('3329933&pEtr=114347'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=2565636&petr=114347"  onclick="fnAPPpopupProduct('2565636&pEtr=114347'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=1815873&petr=114347"  onclick="fnAPPpopupProduct('1815873&pEtr=114347'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=3414265&petr=114347"  onclick="fnAPPpopupProduct('3414265&pEtr=114347'); return false;"></a>
            </div>
        </div>
    </div>

    <a href="/category/category_itemprd.asp?itemid=3931701&petr=114347"  onclick="fnAPPpopupProduct('3931701&pEtr=114347'); return false;">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114347/m/img_item02.jpg?v=2" alt="">
    </a>
    <div class="section-link">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114347/m/img_list02.jpg?v=2" alt="">
        <div class="link-wrap">
            <div>
                <a href="/category/category_itemprd.asp?itemid=3217836&petr=114347"  onclick="fnAPPpopupProduct('3217836&pEtr=114347'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=3525462&petr=114347"  onclick="fnAPPpopupProduct('3525462&pEtr=114347'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=3155597&petr=114347"  onclick="fnAPPpopupProduct('3155597&pEtr=114347'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=3119959&petr=114347"  onclick="fnAPPpopupProduct('3119959&pEtr=114347'); return false;"></a>
            </div>
        </div>
    </div>

    <a href="/category/category_itemprd.asp?itemid=2261745&petr=114347"  onclick="fnAPPpopupProduct('2261745&pEtr=114347'); return false;">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114347/m/img_item03.jpg?v=2" alt="">
    </a>
    <div class="section-link">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114347/m/img_list03.jpg?v=2" alt="">
        <div class="link-wrap">
            <div>
                <a href="/category/category_itemprd.asp?itemid=4021005&petr=114347"  onclick="fnAPPpopupProduct('4021005&pEtr=114347'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=3668188&petr=114347"  onclick="fnAPPpopupProduct('3668188&pEtr=114347'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=4021002&petr=114347"  onclick="fnAPPpopupProduct('4021002&pEtr=114347'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=3508626&petr=114347"  onclick="fnAPPpopupProduct('3508626&pEtr=114347'); return false;"></a>
            </div>
        </div>
    </div>

    <a href="/category/category_itemprd.asp?itemid=3314568&petr=114347"  onclick="fnAPPpopupProduct('3314568&pEtr=114347'); return false;">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114347/m/img_item04.jpg?v=2" alt="">
    </a>
    <div class="section-link">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/114347/m/img_list04.jpg?v=2" alt="">
        <div class="link-wrap">
            <div>
                <a href="/category/category_itemprd.asp?itemid=3540552&petr=114347"  onclick="fnAPPpopupProduct('3540552&pEtr=114347'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=2852379&petr=114347"  onclick="fnAPPpopupProduct('2852379&pEtr=114347'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=2968064&petr=114347"  onclick="fnAPPpopupProduct('2968064&pEtr=114347'); return false;"></a>
            </div>
            <div>
                <a href="/category/category_itemprd.asp?itemid=2741248&petr=114347"  onclick="fnAPPpopupProduct('2741248&pEtr=114347'); return false;"></a>
            </div>
        </div>
    </div>


    <p class="special"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114347/m/bg_special.jpg?v=2" alt=""></p>
    <a href="/street/street_brand_sub06.asp?makerid=oa" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114347/m/bg_live.jpg?v=2" alt="oa"></a>
    <a href="#" onclick="fnAPPpopupBrand('oa'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114347/m/bg_live.jpg?v=2" alt="oa"></a>
</div>