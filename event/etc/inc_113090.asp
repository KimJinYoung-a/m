<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 카카오 브랜드위크
' History : 2021-08-02 정태훈
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
	eCode = "113090"
    mktTest = True
Else
	eCode = "113090"
    mktTest = False
End If

eventStartDate  = cdate("2021-08-02")		'이벤트 시작일
eventEndDate 	= cdate("2021-08-29")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if mktTest then
    currentDate = cdate("2021-08-02")
else
    currentDate = date()
end if

%>
<style>
.mEvt113090 .section-link {position:relative;}
.mEvt113090 .section-link .link-wrap {display:flex; justify-content:space-between; flex-wrap:wrap; width:88%; position:absolute; margin:0 6%; left:0; top:0; height:90%;  }
.mEvt113090 .section-link .link-wrap div { width:49%; height:47%; }
.mEvt113090 .section-link .link-wrap div a { position:relative; display:inline-block; width:100%; height:100%; }

.mEvt113090 .push-wrap { position:relative; }
.mEvt113090 .push-wrap .push-dim { display:none; position:absolute; bottom:0; left:50%; margin-left:-45.4%; width:90.8%; height:90%; background-color:rgba(0, 0, 0,0.6); z-index:10;}
.mEvt113090 .push-wrap .event-btn {position:absolute; bottom:0; left:50%; margin-left:17%; width:28%; height:90%; background:url(//webimage.10x10.co.kr/fixevent/event/2021/113090/m/btn_start.png) no-repeat 0 0; background-size:100%; text-indent:-9999px; }
.mEvt113090 .push-wrap .event-btn.end {background:url(//webimage.10x10.co.kr/fixevent/event/2021/113090/m/btn_end.png) no-repeat 0 0; background-size:100%;}

.mEvt113090 .pop-container { display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(0, 0, 0,0.6); z-index:150;}
.mEvt113090 .pop-container .pop-inner { width:100%; height:100%; padding:8.47rem 1.7rem 4.17rem; overflow-y: scroll;}
.mEvt113090 .pop-contents {position:relative;}
.mEvt113090 .pop-contents .btn-close {width:16%; height:28%; position:absolute; top:0; left:50%; margin-left:34%; text-indent:-9999px; background:transparent;}
.mEvt113090 .pop-contents .btn-push {width:70%; height:24%; position:absolute; bottom:15%; left:50%; margin-left:-35%;  text-indent:-9999px; background:transparent;}
</style>
<script>
$(function() {
    // 팝업 닫기
    $('.mEvt113090 .btn-close').on('click', function () {
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
            <div class="mEvt113090">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113090/m/bg_main.jpg" alt="">
                <div class="push-wrap">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113090/m/push_kakao.jpg" alt="">
                    <div class="push-dim"></div>
                    <% If currentDate >= #2021-08-02 00:00:00# and currentDate < #2021-08-08 00:00:00# Then %>
                    <button type="button" class="event-btn end" onclick="jsPickingUpPushSubmit(2);">종료알림</button>
                    <% elseif currentDate >= #2021-08-08 00:00:00# then %>
                    <button type="button" class="event-btn end" onclick="jsPickingUpPushSubmit(0);">종료알림</button>
                    <% end if %>
                </div>
                <div class="push-wrap">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113090/m/push_wiggle.jpg" alt="">
                    <div class="push-dim"></div>
                    <% If currentDate >= #2021-08-02 00:00:00# and currentDate < #2021-08-09 00:00:00# Then %>
                    <button type="button" class="event-btn" onclick="jsPickingUpPushSubmit(3);">시작알림</button>
                    <% elseif currentDate >= #2021-08-15 00:00:00# then %>
                    <button type="button" class="event-btn end" onclick="jsPickingUpPushSubmit(0);">종료알림</button>
                    <% else %>
                    <button type="button" class="event-btn end" onclick="jsPickingUpPushSubmit(4);">종료알림</button>
                    <% end if %>
                </div>
                <div class="push-wrap">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113090/m/pus_hobby.jpg" alt="">
                    <div class="push-dim"></div>
                    <% If currentDate >= #2021-08-02 00:00:00# and currentDate < #2021-08-16 00:00:00# Then %>
                    <button type="button" class="event-btn" onclick="jsPickingUpPushSubmit(5);">시작알림</button>
                    <% elseif currentDate >= #2021-08-22 00:00:00# then %>
                    <button type="button" class="event-btn end" onclick="jsPickingUpPushSubmit(0);">종료알림</button>
                    <% else %>
                    <button type="button" class="event-btn end" onclick="jsPickingUpPushSubmit(6);"></button>
                    <% end if %>
                </div>
                <div class="push-wrap">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113090/m/push_mote.jpg" alt="">
                    <div class="push-dim"></div>
                    <% If currentDate >= #2021-08-02 00:00:00# and currentDate < #2021-08-23 00:00:00# Then %>
                    <button type="button" class="event-btn" onclick="jsPickingUpPushSubmit(7);">시작알림</button>
                    <% elseif currentDate >= #2021-08-29 00:00:00# then %>
                    <button type="button" class="event-btn end" onclick="jsPickingUpPushSubmit(0);">종료알림</button>
                    <% else %>
                    <button type="button" class="event-btn end" onclick="jsPickingUpPushSubmit(8);"></button>
                    <% end if %>
                </div>
                <div class="pop-container">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/113090/m/bg_popup.png" alt="포인트로 스티커 사러 가자">
                            <button type="button" class="btn-close">닫기</button>
                            <button type="button" class="btn-push" onclick="fnAPPpopupSetting();">푸쉬 설정 확인하기</button>
                        </div>
                    </div>
                </div>

                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113090/m/bg_sub.jpg" alt="">
                <a href="/category/category_itemprd.asp?itemid=3132568&petr=113090"  onclick="fnAPPpopupProduct('3132568&pEtr=113090'); return false;">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113090/m/img_item01.jpg" alt="">
                </a>
                <div class="section-link">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113090/m/img_list01.jpg" alt="">
                    <div class="link-wrap">
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3747619&petr=113090"  onclick="fnAPPpopupProduct('3747619&pEtr=113090'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3784999&petr=113090"  onclick="fnAPPpopupProduct('3784999&pEtr=113090'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3499091&petr=113090"  onclick="fnAPPpopupProduct('3499091&pEtr=113090'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3608355&petr=113090"  onclick="fnAPPpopupProduct('3608355&pEtr=113090'); return false;"></a>
                        </div>
                    </div>
                </div>

                <a href="/category/category_itemprd.asp?itemid=3958412&petr=113090"  onclick="fnAPPpopupProduct('3958412&pEtr=113090'); return false;">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113090/m/img_item02.jpg" alt="">
                </a>
                <div class="section-link">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113090/m/img_list02.jpg" alt="">
                    <div class="link-wrap">
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3784998&petr=113090"  onclick="fnAPPpopupProduct('3784998&pEtr=113090'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3132575&petr=113090"  onclick="fnAPPpopupProduct('3132575&pEtr=113090'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=2503440&petr=113090"  onclick="fnAPPpopupProduct('2503440&pEtr=113090'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=2503448&petr=113090"  onclick="fnAPPpopupProduct('2503448&pEtr=113090'); return false;"></a>
                        </div>
                    </div>
                </div>

                <a href="/category/category_itemprd.asp?itemid=3935851&petr=113090"  onclick="fnAPPpopupProduct('3935851&pEtr=113090'); return false;">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113090/m/img_item03.jpg" alt="">
                </a>
                <div class="section-link">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113090/m/img_list03.jpg" alt="">
                    <div class="link-wrap">
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3910242&petr=113090"  onclick="fnAPPpopupProduct('3910242&pEtr=113090'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3796624&petr=113090"  onclick="fnAPPpopupProduct('3796624&pEtr=113090'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3747616&petr=113090"  onclick="fnAPPpopupProduct('3747616&pEtr=113090'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=2967384&petr=113090"  onclick="fnAPPpopupProduct('2967384&pEtr=113090'); return false;"></a>
                        </div>
                    </div>
                </div>

                <a href="/brand/brand_detail2020.asp?brandid=kakaofriends1010 " class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113090/m/bg_kakao.jpg" alt="kakao friends"></a>
                <a href="#" onclick="fnAPPpopupBrand('kakaofriends1010 '); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113090/m/bg_kakao.jpg" alt="kakao friends"></a>
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->