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
	eCode = "113136"
    mktTest = True
Else
	eCode = "113136"
    mktTest = False
End If

eventStartDate  = cdate("2021-08-16")		'이벤트 시작일
eventEndDate 	= cdate("2021-08-22")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if mktTest then
    currentDate = cdate("2021-08-16")
else
    currentDate = date()
end if
%>
<style>
.mEvt113136 .section-link {position:relative;}
.mEvt113136 .section-link .link-wrap {display:flex; justify-content:space-between; flex-wrap:wrap; width:88%; position:absolute; margin:0 6%; left:0; top:0; height:90%;  }
.mEvt113136 .section-link .link-wrap div { width:49%; height:47%; }
.mEvt113136 .section-link .link-wrap div a { position:relative; display:inline-block; width:100%; height:100%; }

.mEvt113136 .push-wrap { position:relative; }
.mEvt113136 .push-wrap .push-dim { position:absolute; bottom:0; left:50%; margin-left:-45.4%; width:90.8%; height:90%; background-color:rgba(0, 0, 0,0.3); z-index:10;}
.mEvt113136 .push-wrap .event-btn {position:absolute; bottom:0; left:50%; margin-left:17%; width:28%; height:90%; background:url(//webimage.10x10.co.kr/fixevent/event/2021/113136/m/btn_start.png) no-repeat 0 0; background-size:100%; text-indent:-9999px; }
.mEvt113136 .push-wrap .event-btn.end {background:url(//webimage.10x10.co.kr/fixevent/event/2021/113136/m/btn_end.png) no-repeat 0 0; background-size:100%;}

.mEvt113136 .pop-container { display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(0, 0, 0,0.6); z-index:150;}
.mEvt113136 .pop-container .pop-inner { width:100%; height:100%; padding:8.47rem 1.7rem 4.17rem; overflow-y: scroll;}
.mEvt113136 .pop-contents {position:relative;}
.mEvt113136 .pop-contents .btn-close {width:16%; height:28%; position:absolute; top:0; left:50%; margin-left:34%; text-indent:-9999px; background:transparent;}
.mEvt113136 .pop-contents .btn-push {width:70%; height:24%; position:absolute; bottom:15%; left:50%; margin-left:-35%;  text-indent:-9999px; background:transparent;}
</style>
<script>
$(function() {
    // 팝업 닫기
    $('.mEvt113136 .btn-close').on('click', function () {
        $(".pop-container").fadeOut();
    });
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
            <div class="mEvt113136">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113136/m/bg_main.jpg" alt="디자인 위크">
                <div class="push-wrap">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113136/m/push_kakao.jpg?v=2.1" alt="">
                    <div class="push-dim"></div>
                    <% If currentDate >= #2021-08-02 00:00:00# and currentDate < #2021-08-08 00:00:00# Then %>
                    <button type="button" class="event-btn end" onclick="jsPickingUpPushSubmit(2);">종료알림</button>
                    <% elseif currentDate >= #2021-08-08 00:00:00# then %>
                    <button type="button" class="event-btn end" onclick="jsPickingUpPushSubmit(0);">종료알림</button>
                    <% end if %>
                </div>
                <div class="push-wrap">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113136/m/push_wiggle.jpg?v=2.1" alt="">
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
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113136/m/push_hobby.jpg?v=2.1" alt="">
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
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113136/m/push_mote.jpg?v=2.1" alt="">
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
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/113136/m/bg_popup.png?v=2" alt="알림신청이 완료되었습니다.">
                            <button type="button" class="btn-close">닫기</button>
                            <button type="button" class="btn-push">푸쉬 설정 확인하기</button>
                        </div>
                    </div>
                </div>

                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113136/m/bg_brand.jpg" alt="hobbyful">
                <a href="/category/category_itemprd.asp?itemid=3887618&petr=113136"  onclick="fnAPPpopupProduct('3887618&pEtr=113136'); return false;">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113136/m/img_item01.jpg" alt="상품리스트">
                </a>
                <div class="section-link">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113136/m/img_list01.jpg" alt="상품리스트">
                    <div class="link-wrap">
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3981294&petr=113136"  onclick="fnAPPpopupProduct('3981294&pEtr=113136'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3778782&petr=113136"  onclick="fnAPPpopupProduct('3778782&pEtr=113136'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3914636&petr=113136"  onclick="fnAPPpopupProduct('3914636&pEtr=113136'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3887619&petr=113136"  onclick="fnAPPpopupProduct('3887619&pEtr=113136'); return false;"></a>
                        </div>
                    </div>
                </div>
                <a href="/category/category_itemprd.asp?itemid=3677828&petr=113136"  onclick="fnAPPpopupProduct('3677828&pEtr=113136'); return false;">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113136/m/img_item02.jpg" alt="상품리스트">
                </a>
                <div class="section-link">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113136/m/img_list02.jpg" alt="상품리스트">
                    <div class="link-wrap">
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3701430&petr=113136"  onclick="fnAPPpopupProduct('3701430&pEtr=113136'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3631708&petr=113136"  onclick="fnAPPpopupProduct('3631708&pEtr=113136'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=2854622&petr=113136"  onclick="fnAPPpopupProduct('2854622&pEtr=113136'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3981293&petr=113136"  onclick="fnAPPpopupProduct('3981293&pEtr=113136'); return false;"></a>
                        </div>
                    </div>
                </div>
                
                <a href="/category/category_itemprd.asp?itemid=3017209&petr=113136"  onclick="fnAPPpopupProduct('3017209&pEtr=113136'); return false;">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113136/m/img_item03.jpg" alt="상품리스트">
                </a>
                <div class="section-link">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113136/m/img_list03.jpg" alt="상품리스트">
                    <div class="link-wrap">
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3000753&petr=113136"  onclick="fnAPPpopupProduct('3000753&pEtr=113136'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3368997&petr=113136"  onclick="fnAPPpopupProduct('3368997&pEtr=113136'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=2975876&petr=113136"  onclick="fnAPPpopupProduct('2975876&pEtr=113136'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3887620&petr=113136"  onclick="fnAPPpopupProduct('3887620&pEtr=113136'); return false;"></a>
                        </div>
                    </div>
                </div>
                <a href="/brand/brand_detail2020.asp?brandid=hobbyful1 " class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113136/m/bg_hobby.jpg" alt="hobbyful"></a>
                <a href="#" onclick="fnAPPpopupBrand('hobbyful1'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113136/m/bg_hobby.jpg" alt="hobbyful"></a>
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->