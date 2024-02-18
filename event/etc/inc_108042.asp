<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'#################################################################
' Description : 삼양 이벤트 - 세상에 없던 매운맛이 왔다옹
' History : 2020-12-08 이전도
'#################################################################
%>
<%
Dim userid, currentDate, eventStartDate, eventEndDate
currentDate =  now()
userid = GetEncLoginUserID()

if userid="ley330" or userid="greenteenz" or userid="rnldusgpfla" or userid="kobula" or userid="thensi7" or userid = "motions" or userid = "jj999a" or userid = "phsman1" or userid = "jjia94" or userid = "seojb1983" or userid = "kny9480" or userid = "bestksy0527" or userid = "mame234" or userid = "corpse2" or userid = "starsun726" or userid="dlwjseh" then
	currentDate = #12/11/2020 09:00:00#
end if

Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  104276
Else
	eCode   =  108042
End If

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("세상에 없던 매운맛이 왔다옹")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/105778/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "세상에 없던 매운맛이 왔다옹"
Dim kakaodescription : kakaodescription = "火르륵~ 삼양의 매콤함, 드.디.어 텐바이텐에 상륙!"
Dim kakaooldver : kakaooldver = "火르륵~ 삼양의 매콤함, 드.디.어 텐바이텐에 상륙!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/105778/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode
%>
<style>
.mEvt108042 h2 {position:relative;}
.mEvt108042 h2 .badge {display:inline-block; position:absolute; top:67.17vw; right:2.67%; width:29.2%; animation:bounce 1s 30;}
.mEvt108042 .smayang-evt .evt-cont {position:relative;}
.mEvt108042 .smayang-evt .evt-cont .input-box {display:flex; position:absolute; top:71.22%; left:0; width:100%; height:15.96vw; padding:0 6.67%;}
.mEvt108042 .smayang-evt .evt-cont .input-box input {width:100%; height:100%; padding:0 5.32vw; border:0; background-color:transparent; font-size:1.28rem; color:#999;}
.mEvt108042 .smayang-evt .evt-cont .input-box .btn-submit {flex-shrink:0; width:20.22vw; background-color:transparent; color:transparent;}
@keyframes bounce {
	from, to {transform:translateY(0); animation-timing-function:ease-in;}
	50% {transform:translateY(-10px); animation-timing-function:ease-out;}
}
</style>
<div class="mEvt108042">
    <h2>
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/108042/m/tit_event.jpg" alt="세상에 없던 매운맛이 왔다옹">
        <span class="badge"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108042/m/img_badge.png" alt=""></span>
    </h2>
    <div class="intro"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108042/m/img_intro.jpg" alt="2020년 힘들었던 한 해를 보낸 분들을 위해 텐바이텐과 삼양이 세상에 없던 불타는 매운맛을 위해 뭉쳤어요!"></div>
    <div class="evt-item">
        <a href="/category/category_itemPrd.asp?itemid=3493198&pEtr=107880" onclick="TnGotoProduct('3493198');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108042/m/img_item_v2.jpg" alt="하이, 페퍼스 키친 1인 식기세트"></a>
    </div>
    <div class="smayang-evt">
        <div class="evt-cont">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/108042/m/txt_event_v2.jpg" alt="힘들었던 2020년, 귀엽게 이겨낼 수 있도록 초성 힌트를 보고 페퍼밀 리빙 신상 굿즈의 이름을 맞춰주세요!">
            <div class="input-box">
                <input id="txtAnswer" type="text" placeholder="텍스트를 입력해주세요.">
                <button id="btnAnswer" class="btn-submit">등록</button>
            </div>
        </div>
        <div class="evt-prize"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108042/m/img_prize_v2.jpg" alt="이벤트 당첨상품"></div>
    </div>
    <div class="detail">
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/108042/m/tit_detail.jpg" alt="detail"></p>
        <div class="vod" style="padding:0 13.6%; background-color:#ff6e1f;">
            <video src="http://webimage.10x10.co.kr/video/vid1049.mp4" preload="auto" autoplay="true" muted="muted" volume="0" playsinline style="width:100%"></video>
        </div>
        <div class="character">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/108042/m/txt_detail.jpg?v=1.01" alt="">
            <a href="#group351116"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108042/m/bnr_1.jpg" alt="세상에 없던 불타게 매운맛 더보기!"></a>
            <a href="#group351136"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108042/m/bnr_2.jpg" alt="한국인의 맵부심의 원조 붉닭시리즈 더보기!"></a>
        </div>
    </div>
    <div class="thumbs"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108042/m/img_thumbs_v2.jpg" alt=""></div>
    <div class="noti"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108042/m/txt_noti.jpg" alt="유의사항"></div>
</div>
<script src="/vue/components/common/functions/common.js"></script>
<script>
    document.getElementById('btnAnswer').addEventListener('click', function() {
        const ans = document.getElementById('txtAnswer').value.trim();
        if( ans === '' )
            return false;

        <% If Not(IsUserLoginOK) Then %>
            <% If isApp="1" or isApp="2" Then %>
                calllogin();
                return false;
            <% else %>
                jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid="&eCode&"")%>');
                return false;
            <% end if %>
        <% else %>
            <% If not( left(currentDate,10) >= "2020-12-10" and left(currentDate,10) <= "2021-01-08" ) Then %>
                alert("이벤트 응모 기간이 아닙니다.");
                return;
            <% else %>
                const subscription_apiurl = apiurl + '/event/common/subscription';

                const post_data = {
                    event_code: '<%=eCode%>',
                    event_option1: ans,
                    check_option1: false
                };
                $.ajax({
                    type: "POST",
                    url: subscription_apiurl,
                    data: post_data,
                    ContentType: "json",
                    crossDomain: true,
                    xhrFields: {
                        withCredentials: true
                    },
                    success: function (data) {
                        if( data.result ) {
                            document.getElementById('txtAnswer').value = '';
                            alert(data.message);
                            fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode', post_data.event_code);
                        } else {
                            alert('데이타를 저장하는 도중에 에러가 발생하였습니다. 관리자 문의 요망. (에러코드 : 001)');
                        }
                    },
                    error: function (xhr) {
                        console.log(xhr.responseText);
                        try {
                            const err_obj = JSON.parse(xhr.responseText);
                            console.log(err_obj);
                            switch (err_obj.code) {
                                case -10: alert('이벤트에 응모를 하려면 로그인이 필요합니다.'); return false;
                                default: alert(err_obj.message); return false;
                            }
                        }catch(error) {
                            console.log(error);
                            alert('데이타를 저장하는 도중에 에러가 발생하였습니다. 관리자 문의 요망. (에러코드 : 002)');
                        }
                    }
                });
            <% end if %>
        <% End IF %>
    });
</script>