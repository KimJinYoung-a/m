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
	eCode = "113320"
    mktTest = True
Else
	eCode = "113320"
    mktTest = False
End If

eventStartDate  = cdate("2021-08-23")		'이벤트 시작일
eventEndDate 	= cdate("2021-08-29")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if mktTest then
    currentDate = cdate("2021-08-23")
else
    currentDate = date()
end if
%>
<style>
.mEvt113320 .section-link {position:relative;}
.mEvt113320 .section-link .link-wrap {display:flex; justify-content:space-between; flex-wrap:wrap; width:88%; position:absolute; margin:0 6%; left:0; top:0; height:90%;  }
.mEvt113320 .section-link .link-wrap div { width:49%; height:47%; }
.mEvt113320 .section-link .link-wrap div a { position:relative; display:inline-block; width:100%; height:100%; }

.mEvt113320 .push-wrap { position:relative; }
.mEvt113320 .push-wrap .push-dim { position:absolute; bottom:0; left:50%; margin-left:-45.4%; width:90.8%; height:90%; background-color:rgba(0, 0, 0,0.3); z-index:10;}
.mEvt113320 .push-wrap .event-btn {position:absolute; bottom:0; left:50%; margin-left:17%; width:28%; height:90%; background:url(//webimage.10x10.co.kr/fixevent/event/2021/113136/m/btn_start.png) no-repeat 0 0; background-size:100%; text-indent:-9999px; }
.mEvt113320 .push-wrap .event-btn.end {background:url(//webimage.10x10.co.kr/fixevent/event/2021/113136/m/btn_end.png) no-repeat 0 0; background-size:100%;}

.mEvt113320 .pop-container { display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(0, 0, 0,0.6); z-index:150;}
.mEvt113320 .pop-container .pop-inner { width:100%; height:100%; padding:8.47rem 1.7rem 4.17rem; overflow-y: scroll;}
.mEvt113320 .pop-contents {position:relative;}
.mEvt113320 .pop-contents .btn-close {width:16%; height:28%; position:absolute; top:0; left:50%; margin-left:34%; text-indent:-9999px; background:transparent;}
.mEvt113320 .pop-contents .btn-push {width:70%; height:24%; position:absolute; bottom:15%; left:50%; margin-left:-35%;  text-indent:-9999px; background:transparent;}
</style>
<script>
$(function() {
    // 팝업 닫기
    $('.mEvt113320 .btn-close').on('click', function () {
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
            <div class="mEvt113320">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113320/m/bg_main.jpg" alt="디자인 위크">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113320/m/img_brand.jpg" alt="">
                <div class="push-wrap">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113320/m/img_mote.jpg?v=2" alt="모트모트">
                    <% If currentDate >= #2021-08-23 00:00:00# and currentDate < #2021-08-29 00:00:00# Then %>
                    <button type="button" class="event-btn end" onclick="jsPickingUpPushSubmit(8);">종료알림</button>
                    <% elseif currentDate >= #2021-08-29 00:00:00# then %>
                    <div class="push-dim"></div>
                    <button type="button" class="event-btn end" onclick="jsPickingUpPushSubmit(0);">종료알림</button>
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

                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113320/m/tit_mote.jpg?v=2" alt="motemote">
                <a href="/category/category_itemprd.asp?itemid=4009277&petr=113320"  onclick="fnAPPpopupProduct('4009277&pEtr=113320'); return false;">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113320/m/img_item01.jpg" alt="상품리스트">
                </a>
                <div class="section-link">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113320/m/img_list01.jpg" alt="상품리스트">
                    <div class="link-wrap">
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=4009278&petr=113320"  onclick="fnAPPpopupProduct('4009278&pEtr=113320'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=4009276&petr=113320"  onclick="fnAPPpopupProduct('4009276&pEtr=113320'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=2499978&petr=113320"  onclick="fnAPPpopupProduct('2499978&pEtr=113320'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=2499980&petr=113320"  onclick="fnAPPpopupProduct('2499980&pEtr=113320'); return false;"></a>
                        </div>
                    </div>
                </div>
                <a href="/category/category_itemprd.asp?itemid=4009270&petr=113320"  onclick="fnAPPpopupProduct('4009270&pEtr=113320'); return false;">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113320/m/img_item02.jpg" alt="상품리스트">
                </a>
                <div class="section-link">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113320/m/img_list02.jpg" alt="상품리스트">
                    <div class="link-wrap">
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=4009271&petr=113320"  onclick="fnAPPpopupProduct('4009271&pEtr=113320'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=4009272&petr=113320"  onclick="fnAPPpopupProduct('4009272&pEtr=113320'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=4009273&petr=113320"  onclick="fnAPPpopupProduct('4009273&pEtr=113320'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3477195&petr=113320"  onclick="fnAPPpopupProduct('3477195&pEtr=113320'); return false;"></a>
                        </div>
                    </div>
                </div>
                
                <a href="/category/category_itemprd.asp?itemid=4009275&petr=113320"  onclick="fnAPPpopupProduct('4009275&pEtr=113320'); return false;">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113320/m/img_item03.jpg" alt="상품리스트">
                </a>
                <div class="section-link">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113320/m/img_list03.jpg" alt="상품리스트">
                    <div class="link-wrap">
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=4009274&petr=113320"  onclick="fnAPPpopupProduct('4009274&pEtr=113320'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3724489&petr=113320"  onclick="fnAPPpopupProduct('3724489&pEtr=113320'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3724493&petr=113320"  onclick="fnAPPpopupProduct('3724493&pEtr=113320'); return false;"></a>
                        </div>
                        <div>
                            <a href="/category/category_itemprd.asp?itemid=3388425&petr=113320"  onclick="fnAPPpopupProduct('3388425&pEtr=113320'); return false;"></a>
                        </div>
                    </div>
                </div>
                <a href="/brand/brand_detail2020.asp?brandid=motemote10" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113320/m/bg_mote.jpg" alt="motemote"></a>
                <a href="#" onclick="fnAPPpopupBrand('motemote10'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113320/m/bg_mote.jpg" alt="motemote"></a>
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->