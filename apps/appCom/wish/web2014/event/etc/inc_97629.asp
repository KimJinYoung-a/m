<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 18주년 푸시 알림 받기 페이지
' History : 2019-09-30 원승현
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, issueCode
IF application("Svr_Info") = "Dev" THEN
	eCode = "90401"
Else
	eCode = "97629"
End If
%>
<style type="text/css">
.mEvt97629 button {width:100%; background-color:transparent;}
.mEvt97629 .rolling {position:relative;}
.mEvt97629 .rolling .btn-nav {position:absolute; top:0; z-index:10; width:19.47%; height:100%; background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/97629/m/btn_nav.png); background-repeat:no-repeat; background-position:center; background-size:100%;  text-indent:-999em;}
.mEvt97629 .rolling .btn-prev {left:0;}
.mEvt97629 .rolling .btn-next {right:0; background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/97629/m/btn_next.png);}
</style>
<script type="text/javascript">
    $(function(){
        rolling = new Swiper('#rolling .swiper-container', {
            loop:true,
            speed:800,
            prevButton:'#rolling .btn-prev',
            nextButton:'#rolling .btn-next',
            effect:'fade'
        });
    });

    // 푸시 알림 신청
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
                url:"/apps/appCom/wish/web2014/event/etc/doeventsubscript/doEventSubscript97629.asp",
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
                    alert("APP알림(PUSH) 신청이 완료 되었습니다.");
                    return false;
                } else if(reStr[1] == "pushyn"){			
                    alert("APP 알림 설정이 ON 되어 있어야 합니다.\nAPP->설정->광고성 알림 설정");
                    return false;
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
    <div class="mEvt97629">
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/97629/m/tit_app_push.png" alt="텐바이텐 APP알림 켜고 가장 빠르게 혜택의 주인공이 되세요!"></h2>
        <div class="rolling" id="rolling">
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/97629/m/tit_way.png" alt="푸시 수신 설정 방법"></p>
            <div class="swiper-container">
                <div class="swiper-wrapper">
                    <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97629/m/img_slide_1.png" alt="APP 화면 하단바에 있는 마이텐바이텐 클릭"></div>
                    <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97629/m/img_slide_2.png" alt="마이텐바이텐 오른쪽에 있는 설정 아이콘 클릭"></div>
                    <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97629/m/img_slide_3.png" alt="광고성 알림 설정에 빨갛게 표시되면 수신 동의"></div>
                </div>
                <button class="btn-nav btn-prev">다음</button>
                <button class="btn-nav btn-next">이전</button>
            </div>
            <!--<button onclick="regAlram();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97629/m/btn_alarm.png" alt="APP 알림 받기"></button>-->
        </div>
    </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->