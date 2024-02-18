<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 나 홀로 파자마 파티
' History : 2020-12-03 정태훈
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, LoginUserid, currenttime, moECode
IF application("Svr_Info") = "Dev" THEN
	eCode = "103274"
    moECode = "103271"
Else
	eCode = "107990"
    moECode = "107988"    
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)
If isApp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

LoginUserid = GetEncLoginUserID()
dim eventEndDate, currentDate, eventStartDate
dim subscriptcount, totalsubscriptcount

'변수 초기화
eventStartDate = cdate("2020-12-07")
eventEndDate = cdate("2020-12-16")
currentDate = date()

if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" or LoginUserid = "starsun726" or LoginUserid = "bora2116" then
	currentDate = cdate("2020-12-07")
    '//전체 참여수
    totalsubscriptcount = getevent_subscripttotalcount(eCode, "", "", "try")
    response.write " 총 참여자 : " & totalsubscriptcount
end if

if LoginUserid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, LoginUserid, "", "", "try")
end if

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink
snpTitle	= Server.URLEncode("나홀로 집에서 파티 이벤트")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/107990/m/img_kakao_share.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode
'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "나홀로 집에서 파티 이벤트"
Dim kakaodescription : kakaodescription = "9,900원이면 호화로운 나홀로 파티를 즐길 수 있대! 지금 도전해봐!"
Dim kakaooldver : kakaooldver = "9,900원이면 호화로운 나홀로 파티를 즐길 수 있대! 지금 도전해봐!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/107990/m/img_kakao_share.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink 
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& moECode
%>
<style type="text/css">
.mEvt107990 {position: relative;}
.mEvt107990 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(255, 255, 255,0.902); z-index:150;}
.mEvt107990 .pop-container .pop-inner {position:relative; width:100%; padding:2.17rem 1.73rem 4.17rem;}
.mEvt107990 .pop-container .pop-inner a {display:inline-block; width:100%; height:100%;}
.mEvt107990 .pop-container .pop-inner .btn-close {position:absolute; right:2.73rem; top:3rem; width:2.08rem; height:2.08rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/107990/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;} 
.mEvt107990 .pop-container .pop-inner .name {position:absolute; left:50%; top:18%; transform:translate(-50%,0);font-size:2.30rem; color:#191919; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.mEvt107990 .pop-container .pop-inner .link {width:100%; height:7.82rem; position:absolute; left:0; bottom:12%;}
.mEvt107990 .section-01 .item-info-container {position:relative; width:100%; height:100%;}
.mEvt107990 .section-01 .item-info-container .item-kit01 {position:absolute; left:17%; top:8%;}
.mEvt107990 .section-01 .item-info-container .item-kit01 .box {position:absolute; left:-64%; top:-32%; width:9.82rem;}
.mEvt107990 .section-01 .item-info-container .item-kit02 {position:absolute; left:49%; top:-1%;}
.mEvt107990 .section-01 .item-info-container .item-kit02 .box {position:absolute; left:-63%; top:63%; width:9.82rem;}
.mEvt107990 .section-01 .item-info-container .item-kit03 {position:absolute; left:44%; top:24%;}
.mEvt107990 .section-01 .item-info-container .item-kit03 .box {position:absolute; left:-63%; top:-33%; width:9.82rem;}
.mEvt107990 .section-01 .item-info-container .item-kit04 {position:absolute; left:77%; top:17%;}
.mEvt107990 .section-01 .item-info-container .item-kit04 .box {position:absolute; left:-64%; top:66%; width:9.82rem;}
.mEvt107990 .section-01 .item-info-container .item-kit05 {position:absolute; left:23%; top:41%;}
.mEvt107990 .section-01 .item-info-container .item-kit05 .box {position:absolute; left:-64%; top:-33%; width:9.82rem;}
.mEvt107990 .section-01 .item-info-container .item-kit06 {position:absolute; left:19%; top:63%;}
.mEvt107990 .section-01 .item-info-container .item-kit06 .box {position:absolute; left:-64%; top:-32%; width:9.82rem;}
.mEvt107990 .section-01 .item-info-container .item-kit07 {position:absolute; left:45%; top:80%;}
.mEvt107990 .section-01 .item-info-container .item-kit07 .box {position:absolute; left:-63%; top:-33%; width:9.82rem;}
.mEvt107990 .section-01 .item-info-container .item-kit08 {position:absolute; left:79%; top:52%;}
.mEvt107990 .section-01 .item-info-container .item-kit08 .box {position:absolute; left:-64%; top:65%; width:9.82rem;}
.mEvt107990 .section-01 .item-info-container .kit .box {display:none; animation:show .2s cubic-bezier(.13,.36,.85,.13);}
.mEvt107990 .section-01 .item-info-container .kit .box.on {display:block; animation:show .2s cubic-bezier(.13,.36,.85,.13);}
.mEvt107990 .section-01 .item-info-container .btn-circle {padding:3rem;}
.mEvt107990 .section-01 .item-info-container .btn-circle button {position:relative; display:inline-block; width:1.31rem; height:1.31rem; background:rgba(255,255,255,0.3); border-radius:100%; animation:wide 1s alternate infinite;}
.mEvt107990 .section-01 .item-info-container .btn-circle button span {position:absolute; left:50%; top:50%; transform:translate(-50%,-50%); display:inline-block; width:0.60rem; height:0.60rem; background:#fff; border-radius:100%;}
.mEvt107990 .section-02 {position:relative;}
.mEvt107990 .section-02 .btn-apply {width:21.91rem; position:absolute; left:50%; top:45%; transform:translate(-50%,0); background:transparent; animation:shake .6s ease-in-out alternate infinite;}
.mEvt107990 .section-03 .btn-more {position:relative; width:10.91rem; margin-left:5%; margin-right:2rem; padding-bottom: 2.34rem; background:transparent;}
.mEvt107990 .section-03 .btn-more::before {content:""; position:absolute; right:-1.5rem; top:0.3rem; width:1rem; height:0.65rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/107990/m/icon_arrow.png) no-repeat 0 0; background-size:100%; transition: .5s ease;}
.mEvt107990 .section-03 .btn-more.on::before {transform: rotate(180deg); transition: .5s ease;}
.mEvt107990 .section-03 {background:#1f8453;}
.mEvt107990 .item-01 img,
.mEvt107990 .item-02 img,
.mEvt107990 .item-03 img,
.mEvt107990 .item-04 img {height:47.83rem;}
.mEvt107990 .slide-area {position:relative;}
.mEvt107990 .slide-area .float-txt {width:17.65rem; position:absolute; left:2rem; top:2rem; z-index:100;}
@keyframes wide {
    0% { transform: scale(0) }
    100% { transform: scale(1) }
}
@keyframes show {
    0% { transform: scale(0) }
    100% { transform: scale(1) }
}
@keyframes shake {
    0% { left:48%; }
    100% { left:52%; }
}
</style>
<script type="text/javascript">
$(function(){
    /* slide */
    var swiper = new Swiper(".slide-area .swiper-container", {
        autoplay: 1,
        speed: 1000,
        slidesPerView:1,
        loop:true,
        effect:"fade"
    });
    /* 더보기 클릭시 show/hide */
    $('.mEvt107990 .btn-more').click(function(){
        $('.hidden-list').slideToggle(500);
        $('.btn-more').toggleClass("on");
    })
    //팝업
    /* 팝업 닫기 */
    $('.mEvt107990 .btn-close').click(function(){
        $(".pop-container").fadeOut();
    })
    // 키트 말풍선 노출
    $(".kit").on("click",function(){
        $(this).children(".box").toggleClass("on");
        $(this).siblings().find(".box").removeClass("on");
    });
});
</script>
<script>
function eventTry(){
	<% If Not(IsUserLoginOK) Then %>
		calllogin();
		return false;
	<% else %>
        <% If currentDate >= eventStartDate And currentDate <= eventEndDate Then %>
            <% if subscriptcount > 0 then %>
                alert("고객님은 이미 응모되었습니다.\nID당 1회만 응모 가능합니다.");
                return false;
            <% else %>
                var returnCode, itemid, data
                var data={
                    mode: "add"
                }
                $.ajax({
                    type:"POST",
                    url:"/apps/appCom/wish/web2014/event/etc/doEventSubscript107990.asp",
                    data: data,
                    dataType: "JSON",
                    success : function(res){
                        fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|option1','<%=eCode%>|')
                            if(res!="") {
                                // console.log(res)
                                if(res.response == "ok"){
                                    $('.pop-container').fadeIn();
                                    return false;
                                }else{
                                    alert(res.faildesc);
                                    return false;
                                }
                            } else {
                                alert("잘못된 접근 입니다.");
                                document.location.reload();
                                return false;
                            }
                    },
                    error:function(err){
                        console.log(err)
                        alert("잘못된 접근 입니다.");
                        return false;
                    }
                });
            <% End If %>
        <% Else %>
            alert("이벤트 응모 기간이 아닙니다.");
            return;
        <% End If %>
	<% End If %>
}

function sharesns(snsnum) {		
		$.ajax({
			type: "GET",
			url:"/apps/appCom/wish/web2014/event/etc/doEventSubscript107990.asp",
			data: "mode=snschk&snsnum="+snsnum,
			dataType: "JSON",			
			success: function(res){
				isShared = "True"
				if(snsnum=="fb"){
					<% if isapp then %>
					fnAPPShareSNS('fb','<%=appfblink%>');
					return false;
					<% else %>
					popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
					<% end if %>
				}else{
					<% if isapp then %>
						fnAPPshareKakao('etc','<%=kakaotitle%>','<%=kakaoWebLink%>','<%=kakaoMobileLink%>','<%="url="&kakaoAppLink%>','<%=kakaoimage%>','','','','<%=kakaodescription%>');
						return false;
					<% else %>
						event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaoMobileLink%>' );
					<% end if %>
				}					
			},
			error: function(err){
				alert('잘못된 접근입니다.')
			}
		})
}
</script>
            <div class="mEvt107990">
                <div class="topic">
                    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/107990/m/img_tit.jpg" alt="나홀로 집에서 즐기는 파티 키트 9,900원?"></h2>
                </div>
                <div class="section-01">
                    <div class="item-info-container">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/107990/m/img_items.jpg" alt="파티 키트">
                        <div class="item-kit01 kit">
                            <div class="box on"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107990/m/img_item_txt01.png" alt="파티에 빠질 수 없는 마샬 스피커"></div>
                            <div class="btn-circle"><button type="button"><span></span></button></div>
                        </div>
                        <div class="item-kit02 kit">
                            <div class="box"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107990/m/img_item_txt02.png" alt="음식도 예쁘게 해주는 데코픽 세트"></div>
                            <div class="btn-circle"><button type="button"><span></span></button></div>
                        </div>
                        <div class="item-kit03 kit">
                            <div class="box"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107990/m/img_item_txt03.png" alt="1년치 노래 불러보자 노래방 마이크"></div>
                            <div class="btn-circle"><button type="button"><span></span></button></div>
                        </div>
                        <div class="item-kit04 kit">
                            <div class="box"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107990/m/img_item_txt04.png" alt="포토존은 필수 2021 풍선 장식"></div>
                            <div class="btn-circle"><button type="button"><span></span></button></div>
                        </div>
                        <div class="item-kit05 kit">
                            <div class="box"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107990/m/img_item_txt05.png" alt="포근하게 감싸주는 뽀글뽀글 슬리퍼"></div>
                            <div class="btn-circle"><button type="button"><span></span></button></div>
                        </div>
                        <div class="item-kit06 kit">
                            <div class="box"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107990/m/img_item_txt06.png" alt="시간순삭 월리를 찾아서 퍼즐"></div>
                            <div class="btn-circle"><button type="button"><span></span></button></div>
                        </div>
                        <div class="item-kit07 kit">
                            <div class="box"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107990/m/img_item_txt07.png" alt="귀엽고 웃기다 춤추는 트리 모자"></div>
                            <div class="btn-circle"><button type="button"><span></span></button></div>
                        </div>
                        <div class="item-kit08 kit">
                            <div class="box"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107990/m/img_item_txt08.png" alt="집콕 필수템! 체크 패턴 파자마"></div>
                            <div class="btn-circle"><button type="button"><span></span></button></div>
                        </div>
                    </div>
                </div>
                <div class="section-02">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/107990/m/img_sub_tit.jpg" alt="나홀로 집에서 키트 9,900원 당첨 시 위 키트를 9,900원에 구매할 수 있습니다.">
                    <!-- 응모하기 버튼 -->
                    <button type="button" class="btn-apply" onclick="eventTry()"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107990/m/img_btn01.png" alt="응모하기"></button>
                </div>
                <div class="section-03">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/107990/m/img_noti_tit.jpg" alt="응모기간">
                    <button type="button" class="btn-more"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107990/m/img_btn_txt.jpg" alt="유의사항 확인하기"></button>
                    <div class="hidden-list" style="display:none;">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/107990/m/img_noti.jpg" alt="유의 사항">
                    </div>
                </div>
                <div class="section-04">
                    <a href="#" onclick="fnAPPpopupExternalBrowser('https://tenten.app.link/e/LOU1Wkw9Jbb'); return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107990/m/img_insta.jpg" alt="파티 키트를 간절히 원한다면? 지금 인스타그램에서도 당첨자를 뽑고 있어요!"></a>
                </div>
                <!-- slide -->
                <div class="slide-area">
                    <div class="swiper-container">
                        <div class="swiper-wrapper">
                            <div class="swiper-slide">
                                <div class="item-01">
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/107990/m/img_slide01.png" alt="item01">
                                </div>
                            </div>
                            <div class="swiper-slide">
                                <div class="item-02">
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/107990/m/img_slide02.png" alt="item02">
                                </div>
                            </div>
                            <div class="swiper-slide">
                                <div class="item-03">
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/107990/m/img_slide03.png" alt="item03">
                                </div>
                            </div>
                            <div class="swiper-slide">
                                <div class="item-04">
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/107990/m/img_slide04.png" alt="item04">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="float-txt"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107990/m/img_floating.png" alt="이번 연말은 집에서 즐겨보세요!"></div>
                </div>
                <!-- // -->
                <!-- for dev msg : 카카오톡 공유하기 -->
                <div><a href="#" onclick="sharesns('ka')"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107990/m/img_kakao.jpg" alt="친구에게도 이 소식을 알려주세요!"></a></div>
                <!-- 파자마 파티 기획전 -->
                <div><a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=107854');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107988/m/img_banner03.jpg" alt="집콕할떄 필요한 파자마"></a></div>

                <!-- 크리스마스 기획전 -->
                <div><a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/christmas');return false;" ><img src="//webimage.10x10.co.kr/fixevent/event/2020/107990/m/img_chrismas.jpg" alt="이제 크리스마스 준비해볼까?"></a></div>
                
                <!-- <% If currentDate >= "2020-12-07" AND currentDate < "2020-12-10" Then %>
                <div><a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=108141');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107990/m/img_diary.jpg" alt="다이어리 하나 더 받아가세요!"></a></div>
                <% End If %> -->
                
                <!-- 응모하기 팝업 -->
                <div class="pop-container" >
					<div class="pop-inner">
                        <!-- for dev msg : 고객ID 노출 -->
                        <div class="name"><span><%=LoginUserid%></span>님</div>
                        <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/107990/m/img_popup.jpg" alt="응모가 완료되었습니다! 당첨일 12월17일 기다려주세요!"></div>
                        <div class="link"><a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/christmas');return false;" ></a></div>
						<button type="button" class="btn-close">닫기</button>
					</div>
                </div>
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->