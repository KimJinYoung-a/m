<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 브랜드위크
' History : 2021-08-07 정태훈
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
	eCode = "113060"
    mktTest = True
Else
	eCode = "113060"
    mktTest = False
End If

eventStartDate  = cdate("2021-08-09")		'이벤트 시작일
eventEndDate 	= cdate("2021-08-29")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if mktTest then
    currentDate = cdate("2021-08-09")
else
    currentDate = date()
end if
%>
<style>
.mEvt113060 .section-link {position:relative;}
.mEvt113060 .section-link .link-wrap {display:flex; justify-content:space-between; flex-wrap:wrap; width:88%; position:absolute; margin:0 6%; left:0; top:0; height:90%;  }
.mEvt113060 .section-link .link-wrap div { width:49%; height:47%; }
.mEvt113060 .section-link .link-wrap div a { position:relative; display:inline-block; width:100%; height:100%; }

.mEvt113060 .push-wrap { position:relative; }
.mEvt113060 .push-wrap .push-dim { position:absolute; bottom:0; left:50%; margin-left:-45.4%; width:90.8%; height:90%; background-color:rgba(0, 0, 0,0.6); z-index:10;}
.mEvt113060 .push-wrap .event-btn {position:absolute; bottom:0; left:50%; margin-left:17%; width:28%; height:90%; background:url(//webimage.10x10.co.kr/fixevent/event/2021/113060/m/btn_start.png) no-repeat 0 0; background-size:100%; text-indent:-9999px; }
.mEvt113060 .push-wrap .event-btn.end {background:url(//webimage.10x10.co.kr/fixevent/event/2021/113060/m/btn_end.png) no-repeat 0 0; background-size:100%;}

.mEvt113060 .pop-container { display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(0, 0, 0,0.6); z-index:150;}
.mEvt113060 .pop-container .pop-inner { width:100%; height:100%; padding:8.47rem 1.7rem 4.17rem; overflow-y: scroll;}
.mEvt113060 .pop-contents {position:relative;}
.mEvt113060 .pop-contents .btn-close {width:16%; height:28%; position:absolute; top:0; left:50%; margin-left:34%; text-indent:-9999px; background:transparent;}
.mEvt113060 .pop-contents .btn-push {width:70%; height:24%; position:absolute; bottom:15%; left:50%; margin-left:-35%;  text-indent:-9999px; background:transparent;}
</style>
<script>
$(function() {
    // 팝업 닫기
    $('.mEvt113060 .btn-close').on('click', function () {
        $(".pop-container").fadeOut();
    })
});

function jsPickingUpPushSubmit(pushdiv){
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
    if(pushdiv<1){
        alert("푸시 신청 기간이 아닙니다.");
        return false;
    }else{
        $.ajax({
            type:"GET",
            url:"/event/etc/doeventsubscript/doEventSubscript113090.asp?mode=pushadd&pushdiv="+pushdiv,
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
            <div class="mEvt113060">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113060/m/bg_main.jpg?v=2.1" alt="디자인 위크">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113060/m/bg_sub.jpg?v=2.1" alt="브랜드위크 알림 설정">
                <!-- push 알림 영역 -->
                <div class="push-wrap">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113060/m/push_kakao.jpg?v=2.1" alt="">
                    <div class="push-dim"></div>
                    <% If currentDate >= #2021-08-02 00:00:00# and currentDate < #2021-08-08 00:00:00# Then %>
                    <button type="button" class="event-btn end" onclick="jsPickingUpPushSubmit(2);">종료알림</button>
                    <% elseif currentDate >= #2021-08-08 00:00:00# then %>
                    <button type="button" class="event-btn end" onclick="jsPickingUpPushSubmit(0);">종료알림</button>
                    <% end if %>
                </div>
                <div class="push-wrap">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113060/m/push_wiggle.jpg?v=2.1" alt="">
                    <% If currentDate >= #2021-08-02 00:00:00# and currentDate < #2021-08-09 00:00:00# Then %>
                    <button type="button" class="event-btn" onclick="jsPickingUpPushSubmit(3);">시작알림</button>
                    <% elseif currentDate >= #2021-08-15 00:00:00# then %>
                    <div class="push-dim"></div>
                    <button type="button" class="event-btn end" onclick="jsPickingUpPushSubmit(0);">종료알림</button>
                    <% else %>
                    <button type="button" class="event-btn end" onclick="jsPickingUpPushSubmit(4);">종료알림</button>
                    <% end if %>
                </div>
                <div class="push-wrap">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113060/m/pus_hobby.jpg?v=2.1" alt="">
                    <% If currentDate >= #2021-08-02 00:00:00# and currentDate < #2021-08-16 00:00:00# Then %>
                    <button type="button" class="event-btn" onclick="jsPickingUpPushSubmit(5);">시작알림</button>
                    <% elseif currentDate >= #2021-08-22 00:00:00# then %>
                    <div class="push-dim"></div>
                    <button type="button" class="event-btn end" onclick="jsPickingUpPushSubmit(0);">종료알림</button>
                    <% else %>
                    <button type="button" class="event-btn end" onclick="jsPickingUpPushSubmit(6);"></button>
                    <% end if %>
                </div>
                <div class="push-wrap">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113060/m/push_mote.jpg?v=2.1" alt="">
                    <% If currentDate >= #2021-08-02 00:00:00# and currentDate < #2021-08-23 00:00:00# Then %>
                    <button type="button" class="event-btn" onclick="jsPickingUpPushSubmit(7);">시작알림</button>
                    <% elseif currentDate >= #2021-08-29 00:00:00# then %>
                    <div class="push-dim"></div>
                    <button type="button" class="event-btn end" onclick="jsPickingUpPushSubmit(0);">종료알림</button>
                    <% else %>
                    <button type="button" class="event-btn end" onclick="jsPickingUpPushSubmit(8);"></button>
                    <% end if %>
                </div>
                <!-- 팝업 -->
                <div class="pop-container">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/113060/m/bg_popup.png" alt="알림신청이 완료되었습니다.">
                            <button type="button" class="btn-close">닫기</button>
                            <button type="button" class="btn-push" onclick="fnAPPpopupSetting();">푸쉬 설정 확인하기</button>
                        </div>
                    </div>
                </div>

                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113060/m/bg_brand.jpg" alt="위글위글 브랜드">
                <a href="/category/category_itemprd.asp?itemid=3926551&petr=113060"  onclick="fnAPPpopupProduct('3926551&pEtr=113060'); return false;">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113060/m/img_item01.jpg" alt="상품리스트">
                </a>
                <div class="section-link">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113060/m/img_list01.jpg" alt="상품리스트">
                    <div class="link-wrap">
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3493646&petr=113060"  onclick="fnAPPpopupProduct('3493646&pEtr=113060'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3549069&petr=113060"  onclick="fnAPPpopupProduct('3549069&pEtr=113060'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3505943&petr=113060"  onclick="fnAPPpopupProduct('3505943&pEtr=113060'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=1892597&petr=113060"  onclick="fnAPPpopupProduct('1892597&pEtr=113060'); return false;"></a>
                        </div>
                    </div>
                </div>

                <a href="/category/category_itemprd.asp?itemid=3878982&petr=113060"  onclick="fnAPPpopupProduct('3878982&pEtr=113060'); return false;">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113060/m/img_item02.jpg" alt="상품리스트">
                </a>
                <div class="section-link">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113060/m/img_list02.jpg" alt="상품리스트">
                    <div class="link-wrap">
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3936962&petr=113060"  onclick="fnAPPpopupProduct('3936962&pEtr=113060'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3915021&petr=113060"  onclick="fnAPPpopupProduct('3915021&pEtr=113060'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3538455&petr=113060"  onclick="fnAPPpopupProduct('3538455&pEtr=113060'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=2235577&petr=113060"  onclick="fnAPPpopupProduct('2235577&pEtr=113060'); return false;"></a>
                        </div>
                    </div>
                </div>

                <a href="/category/category_itemprd.asp?itemid=3793702&petr=113060"  onclick="fnAPPpopupProduct('3793702&pEtr=113060'); return false;">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113060/m/img_item03.jpg" alt="상품리스트">
                </a>
                <div class="section-link">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113060/m/img_list03.jpg" alt="상품리스트">
                    <div class="link-wrap">
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3899704&petr=113060"  onclick="fnAPPpopupProduct('3899704&pEtr=113060'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3672621&petr=113060"  onclick="fnAPPpopupProduct('3672621&pEtr=113060'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3478148&petr=113060"  onclick="fnAPPpopupProduct('3478148&pEtr=113060'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3876522&petr=113060"  onclick="fnAPPpopupProduct('3876522&pEtr=113060'); return false;"></a>
                        </div>
                    </div>
                </div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113060/m/bg_coupon.jpg" alt="브랜드 쿠폰">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113060/m/bg_gift.jpg" alt="사은품 증정">
                <a href="/brand/brand_detail2020.asp?brandid=wigglewiggle " class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113060/m/bg_wiggle.jpg" alt="wigglewiggle friends"></a>
                <a href="#" onclick="fnAPPpopupBrand('wigglewiggle'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113060/m/bg_wiggle.jpg" alt="wigglewiggle"></a>
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->