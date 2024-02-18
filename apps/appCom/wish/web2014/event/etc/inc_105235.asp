<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'######################################################
' Description : 푸시 동의 100원 마일리지 신청 페이지 APP 전용
' History : 2020-08-18 정태훈
'######################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, moECode, LoginUserid, currentDate
IF application("Svr_Info") = "Dev" THEN
	eCode = "102214"
    moECode = "102213"
Else
	eCode = "105235"
    moECode = "105234"
End If


Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isapp <> "1" Then 
	Response.redirect "/event/eventmain.asp?eventid="&moECode&"&gaparam="&gaparamChkVal
	Response.End
End If
LoginUserid		= getencLoginUserid()
if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" then
    currentDate = #08/20/2020 09:00:00#
else
    currentDate = now()
end if

'// 오늘일자 기준으로 푸시 발송일자를 표시해준다.
Dim pushStartDate, pushEndDate

pushStartDate = DateAdd("d", 1, currentDate)
pushEndDate = DateAdd("d", 9, pushStartDate)

pushStartDate = mid(pushStartDate, 6, 2)&"월 "&mid(pushStartDate, 9, 2)&"일"
pushEndDate = mid(pushEndDate, 6, 2)&"월 "&mid(pushEndDate, 9, 2)&"일"

'// SNS 공유용
	Dim vTitle, vLink, vPre, vImg
	Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

	snpTitle	= Server.URLEncode("마일리지 2,000p 무료 지급")
	snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
	snpPre		= Server.URLEncode("10x10 이벤트")
	snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/105235/m/img_kakao.jpg")
	appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode 

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "마일리지 2,000p 무료 지급"
	Dim kakaodescription : kakaodescription = "알림 신청만 해도 마일리지를 드려요. 지금 얼른 받아가세요!"
	Dim kakaooldver : kakaooldver = "알림 신청만 해도 마일리지를 드려요. 지금 얼른 받아가세요!"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/105235/m/img_kakao.jpg"
	Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink 
	kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
	kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode
	kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& moECode
%>
<style>
.mEvt105235 {background-color:#2c7bff;}
.mEvt105235 button {display:block; width:100%; background-color:transparent;}
.mEvt105235 .lyr-pop {display:flex; flex-direction:column; align-items:center; justify-content:center; position:fixed; top:0; left:0; z-index:100; width:100vw; height:100vh; background-color:rgba(0,0,0,.6);}
.mEvt105235 .lyr-pop button {width:auto;}
.mEvt105235 .way {position:relative;}
.mEvt105235 .way a {display:block; position:absolute; top:53%; left:0; width:100%; height:8%; color:transparent;}
.mEvt105235 .sns-share {position:relative;}
.mEvt105235 .sns {display:inline-block; position:absolute; top:0; left:56.3%; width:16.3%; height:100%; text-indent:-999em;}
.mEvt105235 .sns.kakao {left:74.6%;}
.lyr-cont1 {position:relative;}
.lyr-cont1 p {position:absolute; left:6%; top:29%; width:88%; color:#ff1313; text-align:center; font-size:1.28rem; font-family:'NotoSansKRMedium'; }
</style>
<script type="text/javascript">
$(function(){
    $(".lyr-pop button").on("click", function (e) {
        $('.lyr-pop').hide();
    });
});

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
            jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&moECode&"")%>');
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
            url:"/apps/appCom/wish/web2014/event/etc/doeventsubscript/doEventSubscript105235.asp",
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
                $('#userPushterm').empty().html('<%=pushStartDate&"부터 "&pushEndDate&"까지"%>');
                setTimeout(function(){fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|actype','<%=eCode%>|alarm');}, 100);
            } else if(reStr[1] == "pushyn"){			
                $('.lyr-pop').show();
                $('.lyr-cont2').show();
                setTimeout(function(){fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|actype','<%=eCode%>|pushyn');}, 100);
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

function fnCheckAlarmPopup() {
    $(".lyr-cont2").hide();
    $(".lyr-pop").hide();
    fnAPPpopupSetting();
    return false;
}
</script>
		<div class="evtContV15">

			<!-- 105235 마일리지이벤트_신청(A) -->
            <div class="mEvt105235">
                <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/105235/m/tit_alarm.png" alt="알림 신청하면 하루에 200p씩 최대 2000p를 드립니다" /></h2>
                <button class="btn-apply" onclick="regAlram();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105235/m/btn_apply.png" alt="마일리지 알림 신청하기" /></button>

                <!-- 팝업 -->
                <div class="lyr-pop" style="display:none;">
                    <!-- 푸시 수신 동의 --> 
                    <div class="lyr-cont1" style="display:none;">
                        <p id="userPushterm"></p>
                        <button><img src="//webimage.10x10.co.kr/eventIMG/2020/101392/txt_comp.png" alt="신청이 완료되었습니다." /></button>
                    </div>
                    <!-- 푸시 수신 비동의 --> 
                    <a href="#" onclick="fnCheckAlarmPopup();return false;" class="lyr-cont2" style="display:none;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101083/m/txt_pop2.png" alt="먼저 푸시 수신 동의를 하셔야 이벤트 신청이 가능합니다." /></a>
                </div>

                <div class="way">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/105235/m/img_way.png" alt="참여방법" />
                    <a href="#" onclick="fnAPPpopupSetting();return false;">PUSH 알림 설정하러 가기</a>
                </div>
                
                <div class="sns-share">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/105235/m/txt_share.png" alt="친구에게도이벤트를 알려주세요!" />
                    <button onclick="snschk('fb');return false;" class="sns fb">페이스북 공유</button>
                    <button onclick="snschk('ka');return false;" class="sns kakao">카카오톡 공유</button>
                </div>

                <div class="noti"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105235/m/txt_noti.png" alt="이벤트 유의사항" /></div>
            </div>
			<!--// 105235 마일리지이벤트_신청(A) -->

		</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->