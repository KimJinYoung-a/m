<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
'####################################################
' Description : 2020 메몽을 드립니다.
' History : 2020-07-30 원승현 생성
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, eMobileCode
dim mktTest, vQuery, i, gaparamChkVal, itemid

IF application("Svr_Info") = "Dev" THEN
	eCode = "102204"
    eMobileCode = "102203"
    mktTest = true
    itemid = "2891188"
ElseIf application("Svr_Info")="staging" Then
	eCode = "104812"
    eMobileCode = "104813"    
    mktTest = true
    itemid = "3054711"    
Else
	eCode = "104812"
    eMobileCode = "104813"
    mktTest = false
    itemid = "3054711"    
End If

'// 해당 이벤트는 앱만 진행함
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isApp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& eMobileCode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate      = cdate("2020-08-03")		'이벤트 시작일
eventEndDate 	    = cdate("2020-08-13")		'이벤트 종료일
LoginUserid		    = getencLoginUserid()
if mktTest then
    '// 테스트용
    currentDate = cdate("2020-08-03")
else
    currentDate = date()
end if

%>
<style type="text/css">
.mEvt104812 button {background-color:transparent;}
.quiz .input-box {position:relative;}
.quiz .input-box .answer {position:absolute; top:0; left:50%; width:74.53%; height:100%; padding:.2rem 5% 0; margin-left:-37.27%; border:0; font-size:4.5vw; color:#222; text-align:center;}
.quiz .input-box .answer::-webkit-input-placeholder {color:#999;}
.quiz .input-box .answer:-ms-input-placeholder {color:#999;}
.quiz .input-box .answer::placeholder {color:#999;}
.memong-slide {padding-bottom:10.37vw; background-color:#fff;}
.memong-slide .swiper-container {padding:0 5.3% 6.25vw;}
.memong-slide li {overflow:hidden; position:relative; width:72.84%; margin-left:2.7vw;}
.memong-slide li:first-child {margin-left:0;}
.memong-slide .pagination {overflow:hidden; position:absolute; bottom:0; left:5.3%; z-index:10; width:89.3%; height:2.13vw; background:#e3e1df; border-radius:.93vw;}
.memong-slide .pagination-fill {position:absolute; left:0; top:0; width:100%; height:100%; font-size:0; color:transparent; transform:scale(0); transform-origin:left top; transition-duration:300ms; background:#ff6357;}
.lyr-winner {position:fixed; top:0; left:0; z-index:100; width:100vw; height:100vh; background-color:rgba(255,255,255,.97);}
.lyr-winner .btn-close {position:absolute; top:1vw; right:1vw; width:11.7vw;}
</style>
<script type="text/javascript">
$(function(){
    // Memong Slide
	var today = $('.memong-slide');
	var progressFill = today.find('.pagination-fill');
	var length = today.find('.swiper-slide').length;
	var init = (1 / length).toFixed(2);
	progressFill.css("transform", "scaleX(" + init + ") scaleY(1)");
	var swiper2 = new Swiper('.memong-slide .swiper-container', {
		slidesPerView: 'auto',
		onSlideChangeStart: function(swiper2) {
			var scale = (swiper2.activeIndex+1) * init;
			progressFill.css("transform", "scaleX(" + scale + ") scaleY(1)");
		},
		onSliderMove: function(swiper2){
			var scale = (swiper2.activeIndex+1) * init;
			var lastprev = swiper2.slides.length-1
			if($('.memong-slide .swiper-slide:nth-child('+ lastprev +')').hasClass('swiper-slide-active')){
				progressFill.css("transform", "scaleX(" + scale + ") scaleY(1)");
			}
		},
		onReachEnd: function(swiper2) {
			progressFill.css("transform", "scaleX(1) scaleY(1)");
		}
	});

	$('.btn-submit').click(function(e){
        <% If Not(IsUserLoginOK) Then %>
            <% if isApp=1 then %>
                calllogin();
                return false;
            <% else %>
                jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
                return false;
            <% end if %>
        <% else %>
            <% If (currentDate >= eventStartDate And currentDate <= eventEndDate) Then %>

                if ($("#answerTextArea").val()=="") {
                    alert("정답을 입력해주세요.");
                    return false;
                }
                var data={
                    mode: "evt",
                    answer: $("#answerTextArea").val()
                }
                $.ajax({
                    type: "GET",
                    url: "/apps/appCom/wish/web2014/event/etc/doEventSubscript104812.asp",				
                    data: data,
                    cache: false,
                    context: this,
                    success: function(resultData) {
                        var reStr = resultData.split("|");
                        if(reStr[0]=="OK"){
                            fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode','<%=eCode%>');
                            $("#winnerLayerArea").empty().html(reStr[1]);
                            $("#winnerLayerArea").show();
                        }else if(reStr[0]=="Err"){
                            var errorMsg = reStr[1].replace(">?n", "\n");
                            alert(errorMsg);
                            return false;
                            e.preventDefault();                            
                        }			
                    },
                    error: function(err) {
                        console.log(err.responseText);
                    }
                });
            <% Else %>
                alert("이벤트 응모 기간이 아닙니다.");
                return;
            <% End If %>
        <% End If %>
	});
});

function fnPopupClose() {
    $('.lyr-winner').hide();
}

function goDirOrdItem() {
    <% If Not(IsUserLoginOK) Then %>
        <% if isApp=1 then %>
            calllogin();
            return false;
        <% else %>
            jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
            return false;
        <% end if %>
    <% else %>
        $.ajax({
            type:"GET",
            url:"/apps/appCom/wish/web2014/event/etc/doEventSubscript104812.asp",
            data: "mode=order",
            dataType: "text",
            async:false,
            cache:true,
            success: function(resultData) {
                var reStr = resultData.split("|");
                if(reStr[0]=="OK"){
                    fnAmplitudeEventMultiPropertiesAction('click_memong_buy','itemid',reStr[1])
                    $("#itemid").val(reStr[1]);
                    setTimeout(function() {
                        document.directOrd.submit();
                    },300);
                    return false;
                }else if(reStr[0]=="Err"){
                    var errorMsg = reStr[1].replace(">?n", "\n");
                    alert(errorMsg);										
                }			
            },
            error: function(err) {
                console.log(err.responseText);
            }
        });   
    <% End IF %>
}
</script>


<%'<!-- 104812 메몽 (A) -->%>
<div class="mEvt104812">
    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/104812/m/tit_event.jpg" alt="메몽을 드립니다"></h2>
    <div class="quiz">
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/104812/m/img_gift.jpg?v=1.01" alt="퀴즈를 맞히신 1,000분께 메몽 실물 세트를 무료로 드리니 지금 도전해 보세요!"></p>
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/104812/m/txt_quiz.jpg" alt="메몽의 친구들 중 최근에 새롭게 합류한 호랑이의 이름은 무엇일까요?"></p>
        <div class="input-box">
            <input type="text" placeholder="정답을 입력해주세요." class="answer" id="answerTextArea">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/104812/m/img_input.jpg" alt="">
        </div>
        <button class="btn-submit" style="display:none;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/104812/m/btn_submit.jpg" alt="입력하기"></button>
        <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/104812/m/btn_soldout.jpg" alt="수량이 모두 소진되었습니다."></div>
    </div>
    <%'<!-- 레이어 : 당첨-->%>
    <div class="lyr-winner" id="winnerLayerArea" style="display:none;"></div>
    <a href="" onclick="fnAPPpopupExternalBrowser('https://promotionpage-1b9a3.web.app'); return false;" class="btn-install"><img src="//webimage.10x10.co.kr/fixevent/event/2020/104812/m/btn_install.jpg" alt="메몽 APP 설치하러 가기"></a>
    <div class="brand">
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/104812/m/txt_brand.jpg" alt="메몽을 소개합니다"></p>
        <div class="memong-slide">
            <div class="swiper-container">
                <ul class="swiper-wrapper">
                    <li class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/104812/m/img_slide1_1.png" alt=""></li>
                    <li class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/104812/m/img_slide1_2.png" alt=""></li>
                    <li class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/104812/m/img_slide1_3.png" alt=""></li>
                    <li class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/104812/m/img_slide1_4.png" alt=""></li>
                    <li class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/104812/m/img_slide1_5.png" alt=""></li>
                    <li class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/104812/m/img_slide1_6.png" alt=""></li>
                    <li class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/104812/m/img_slide1_7.png" alt=""></li>
                    <li class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/104812/m/img_slide1_8.png" alt=""></li>
                </ul>
                <div class="pagination"><span class="pagination-fill"></span></div>
            </div>			
        </div>
    </div>
    <a href="" onclick="fnAPPpopupBrowserURL('2020 다이어리','http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2020/');" target="_blank"><img src="//webimage.10x10.co.kr/fixevent/event/2020/104812/m/bnr_1.jpg" alt="문구템"></a>
    <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=102465');" target="_blank"><img src="//webimage.10x10.co.kr/fixevent/event/2020/104812/m/bnr_2.jpg" alt="입문템"></a>
    <div class="noti"><img src="//webimage.10x10.co.kr/fixevent/event/2020/104812/m/txt_noti_v2.jpg" alt="유의사항"></div>
</div>
<%'<!--// 104812 메몽 (A) -->%>

<form method="post" name="directOrd" action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp">
    <input type="hidden" name="itemid" id="itemid" value="">
    <input type="hidden" name="itemoption" value="0000">
    <input type="hidden" name="itemea" readonly value="1">
    <input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
    <input type="hidden" name="isPresentItem" value="" />
    <input type="hidden" name="mode" value="DO3">
</form>
<!-- #include virtual="/lib/db/dbclose.asp" -->