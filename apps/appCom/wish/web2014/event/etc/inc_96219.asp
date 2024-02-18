<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 100원 마일리지 신청 페이지 APP 전용
' History : 2019-07-24 원승현
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode = "90355"
Else
	eCode = "96219"
End If
%>
<%
'// SNS 공유용
	Dim vTitle, vLink, vPre, vImg
	Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

	snpTitle	= Server.URLEncode("[마일리지 이벤트]")
	snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
	snpPre		= Server.URLEncode("10x10 이벤트")
	snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2019/96219/m/img_share_kakao.jpg")
	appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode 

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "[마일리지 이벤트]"
	Dim kakaodescription : kakaodescription = "매일매일 100 마일리지를 드리는 이벤트! 이벤트 신청하고 마일리지를 받아보세요."
	Dim kakaooldver : kakaooldver = "매일매일 100 마일리지를 드리는 이벤트! 이벤트 신청하고 마일리지를 받아보세요."
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2019/96219/m/img_share_kakao.jpg"
	Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink 
	kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
	kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
	kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode
%>
<style type="text/css">
.mEvt96219 {background-color:#ff52a3;}
.mEvt96219 button {background-color:transparent;}
.how-to1 {position:relative;}
.how-to1 .btn-evt {position:absolute; top:15%; left:50%; width:71.87%; margin-left:-36%; animation:moveX .8s 300;}
.how-to1 .btn-go {display:inline-block; width:100%; height:3.43rem; position:absolute; top:55.3%; left:0; text-indent:-999em;}
@keyframes moveX {from, to{transform:translateX(-5px);} 50%{transform:translateX(5px)}}

.lyr-pop {display:flex; align-items:center; justify-content:center; position:fixed; top:0; left:0; z-index:100; width:100vw; height:100vh; background-color:rgba(0,0,0,.6);}
.lyr-pop .lyr {position:relative; width:28.22rem;}
.lyr-pop .lyr a {display:inline-block; position:absolute; bottom:2.14rem; left:50%; width:19.74rem; margin-left:-9.87rem;}

.how-rolling {position:relative;}
.how-rolling .swiper-slide {width:100%;}
.how-rolling button {position:absolute; z-index:99; top:55%; padding:0 2.67rem; background:none;}
.how-rolling button.btn-prev {left:0;}
.how-rolling button.btn-next {right:0;}
.how-rolling button svg {transform:scale(.8);}

.sns-share {position:relative;}
.sns {display:inline-block; position:absolute; top:0; left:55.3%; width:15.6%; height:100%; text-indent:-999em;}
.sns.kakao {left:73.5%;}

.noti {background-color:#561d9c;}
.noti ul {padding:2.14rem 3rem 3.85rem;}
.noti ul li {position:relative; padding:.8rem 0; color:#fff; font-size:1.2rem; line-height:1.7rem; word-break:keep-all;}
.noti ul li:before {display:inline-block; position:absolute; top:1.3rem; left:-.86rem; width:.43rem; height:2px; background-color:#fff; content:'';}
</style>
<script type="text/javascript">
$(function(){
    howSwiper = new Swiper(".how-rolling .swiper-container", {
        loop:true,
        nextButton:'.how-rolling .btn-next',
        prevButton:'.how-rolling .btn-prev',
	    effect:'fade'
    });

    $(".lyr a").on("click", function (e) {
        e.preventDefault();
        if ($(this).parent().hasClass('lyr-cont2')){
            var thisTarget = $(this).attr("href");
            $(window).scrollTop($(thisTarget).offset().top);
        }
		$('.lyr-pop').hide();
    });
});
</script>
<script>
//공유용 스크립트
	function snschk(snsnum) {		
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
	}
	function parent_kakaolink(label , imageurl , width , height , linkurl ){
		//카카오 SNS 공유
		Kakao.init('c967f6e67b0492478080bcf386390fdd');

		Kakao.Link.sendTalkLink({
			label: label,
			image: {
			src: imageurl,
			width: width,
			height: height
			},
			webButton: {
				text: '10x10 바로가기',
				url: linkurl
			}
		});
	}

	//카카오 SNS 공유 v2.0
	function event_sendkakao(label , description , imageurl , linkurl){	
		Kakao.Link.sendDefault({
			objectType: 'feed',
			content: {
				title: label,
				description : description,
				imageUrl: imageurl,
				link: {
				mobileWebUrl: linkurl
				}
			},
			buttons: [
				{
					title: '웹으로 보기',
					link: {
						mobileWebUrl: linkurl
					}
				}
			]
		});
    }
    
    // 알람신청
    function regAlram() {
        <% If Not(IsUserLoginOK) Then %>
            <% if isApp=1 then %>
                calllogin();
                return false;
            <% else %>
                jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
                return false;
            <% end if %>
        <% else %>
            var url = window.location.href;		
            var isAutoPush = false
            var alramAction = "request"
            //if(autoPush){
            isAutoPush = true
            //}	
            var evtCode = getParameterByName("eventid", url).replace("%20", "");
            if(evtCode == ""){
                return false;
            }

            var str = $.ajax({
                type: "post",
                url:"/apps/appCom/wish/web2014/event/etc/doeventsubscript/doEventSubscript96219.asp",
                data: {
                    eCode: evtCode,
                    isAutoPush: isAutoPush,
                    alramAction: alramAction
                },
                dataType: "text",
                async: false
            }).responseText;	
            
            if(!str){alert("시스템 오류입니다."); return false;}

            var reStr = str.split("|");

            if(reStr[0]=="OK"){		
                if(reStr[1] == "alram"){	//알람신청
                    $('.lyr-pop').show();
                    $('.lyr-cont1').show();
                } else if(reStr[1] == "pushyn"){			
                    $('.lyr-pop').show();
                    $('.lyr-cont2').show();
                } else {
                    alert('오류가 발생했습니다.');
                    return false;
                }
            }else{		
                var errorMsg = reStr[1].replace(">?n", "\n");
                alert(errorMsg);
                //document.location.reload();
                return false;
            }
        <% End If %>		
    }    
</script>
</head>
<body>
    <%' 96219 마일리지이벤트(신청) %>
    <div class="mEvt96219">
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/96219/m/tit_mileage.jpg" alt="마일리지 이벤트" /></h2>
        <div class="how-to1">
            <img src="//webimage.10x10.co.kr/fixevent/event/2019/96219/m/txt_how_to_1.jpg" alt="이벤트 참여 방법 이벤트 push알림 신청하기, push수신 동의 확인하러 가기, 이벤트 push알림이 오면 클릭하고 마일리지 받기" />
            <a href="" onclick="regAlram();return false;" class="btn-evt"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96219/m/btn_apply.png" alt="이벤트 PUSH 알림 신청하기" /></a>
            <a href="#how-to2" class="btn-go">확인하러가기</a>
        </div>

        <%' 팝업 레이어 %>
        <div class="lyr-pop" style="display:none;">
            <%' 푸시 수신 동의 %>
            <div class="lyr lyr-cont1" style="display:none;">
                <img src="//webimage.10x10.co.kr/fixevent/event/2019/96219/m/txt_pop_conts_1_v2.png" alt="신청이 완료되었습니다." />
                <a href="#"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96219/m/btn_confirm_1.png" alt="확인" /></a>
            </div>
            <%' 푸시 수신 비동의 %>
            <div class="lyr lyr-cont2" style="display:none;">
                <img src="//webimage.10x10.co.kr/fixevent/event/2019/96219/m/txt_pop_conts_2.png" alt="먼저 푸시 수신 동의를 하셔야 이벤트 신청이 가능합니다." />
                <a href="#how-to2"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96219/m/btn_confirm_2.png" alt="방법확인하기" /></a>
            </div>
        </div>
        <%'// 팝업 레이어 %>

        <div id="how-to2" class="how-to2">
            <div class="how-rolling">
                <div class="swiper-container">
                    <div class="swiper-wrapper">
                        <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96219/m/img_how_rolling_1.jpg" alt="APP 화면 하단바에 있는 마이텐바이텐 클릭"></div>
                        <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96219/m/img_how_rolling_2.jpg" alt="마이텐바이텐 오른쪽에 있는 설정 아이콘 클릭"></div>
                        <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96219/m/img_how_rolling_3.jpg" alt="광고성 알림 설정에 빨갛게 표시되면 수신 동의"></div>
                    </div>
                </div>
                <button class="btn-prev"><svg height="30" width="15"><polyline points="15,0,0,15 15,30" style="fill:none;stroke:#fff;stroke-width:2"></polyline></svg></button>
                <button class="btn-next"><svg height="30" width="15"><polyline points="0,0,15,15 0,30" style="fill:none;stroke:#fff;stroke-width:2"></polyline></svg></button>
            </div>
        </div>

        <%' sns공유 %>
        <div class="sns-share">
            <img src="//webimage.10x10.co.kr/fixevent/event/2019/96219/m/img_sns.jpg" alt="친구에게도 100마일리지 이벤트를 알려주세요!" />
            <a href="javascript:snschk('fb')" class="sns fb">페이스북 공유</a>
            <a href="javascript:snschk('ka')" class="sns kakao">카카오톡 공유</a>
        </div>
        <%'// sns공유 %>

        <div class="noti">
            <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/96219/m/tit_noti.jpg" alt="이벤트 유의사항" /></h3>
            <ul>
                <li>ID 당 하루에 1번씩 100 마일리지를 받을 수 있습니다</li>
                <li>이벤트 신청이 되지 않는 경우 &#60;푸시 수신 설정 방법&#62;을 꼭 확인해주세요. 푸시 수신 동의는 APP에서 확인할 수 있습니다.</li>
                <li>도중에 푸시 수신을 해지하는 경우 알림을 받으실 수 없습니다.</li>
                <li>이벤트 PUSH 알림은 신청한 다음 날부터 발송됩니다.</li>
                <li>이벤트는 7월 31일까지만 진행됩니다.</li>
            </ul>
        </div>
    </div>
    <%'// 96219 마일리지이벤트(신청) %>
<!-- #include virtual="/lib/db/dbclose.asp" -->