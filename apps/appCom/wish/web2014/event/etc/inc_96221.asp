<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 100원 마일리지 발급 페이지
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
dim eCode, issueCode
'// 현재 페이지의 코드는 96221 이지만 실제 마일리지 신청을 받은 event_subscript의 코드는 96219이며 푸시가 발송될때도 96219 기준으로 보냄
IF application("Svr_Info") = "Dev" THEN
	eCode = "90356"
    issueCode = "90355"
Else
	eCode = "96221"
    issueCode = "96219"
End If
%>
<style type="text/css">
.mEvt96221 {background-color:#ff52a3;}
.mEvt96221 button {background-color:transparent;}

.btn-group {position:relative;}
.btn-group button {position:absolute; top:2.4%; left:13.3%; width:74.26%;}
.btn-group .btn-get {animation:moveX .8s 300;}
.btn-group .btn-anymore {top:50%; left:9.3%; width:80.26%;}
@keyframes moveX {from, to{transform:translateX(-5px);} 50%{transform:translateX(10px)}}

.lyr-pop {position:fixed; top:0; left:0; z-index:100; width:100vw; height:100vh; background-color:rgba(0,0,0,.6);}
.lyr-pop .lyr {position:absolute; top:50%; left:50%; width:28.22rem; margin-top:-17.38rem; margin-left:-14.11rem;}
.lyr-pop .lyr a {display:inline-block; position:absolute; bottom:2.14rem; left:50%; width:19.74rem; margin-left:-9.87rem;}

.noti {background-color:#31253f;}
.noti ul {padding:0 1rem 3.85rem 3rem;}
.noti ul li {position:relative; padding:.8rem 0; color:#fff; font-size:1.2rem; line-height:1.7rem; word-break:keep-all;}
.noti ul li:before {display:inline-block; position:absolute; top:1.3rem; left:-.86rem; width:.43rem; height:2px; background-color:#fff; content:'';}
</style>
<script type="text/javascript">
    $(function(){
        $(".lyr a").on("click", function (e) {
            e.preventDefault();
            $('.lyr-pop').hide();
        });
    });

    // 마일리지 발급 및 푸시 알림 그만받기 신청
    function regAlram(act) {
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
            var alramAction = act
            //if(autoPush){
            isAutoPush = true
            //}	

            var str = $.ajax({
                type: "post",
                url:"/apps/appCom/wish/web2014/event/etc/doeventsubscript/doEventSubscript96219.asp",
                data: {
                    eCode: <%=issueCode%>,
                    isAutoPush: isAutoPush,
                    alramAction: alramAction
                },
                dataType: "text",
                async: false
            }).responseText;	
            
            if(!str){alert("시스템 오류입니다."); return false;}

            var reStr = str.split("|");

            if(reStr[0]=="OK"){		
                if(reStr[1] == "mileageok"){	//마일리지 발급
                    $('.lyr-pop').show();
                } else if(reStr[1] == "nopush"){			
                    alert("마일리지 알림 신청이 취소되었습니다.");
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
<body>
    <%' 96221 마일리지이벤트(신청) %>
    <div class="mEvt96221">
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/96221/m/tit_mileage.png" alt="마일리지 이벤트" /></h2>
        <div class="btn-group">
            <button class="btn-get" onclick="regAlram('action');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96221/m/btn_get.png" alt="마일리지받기" /></button>
            <button class="btn-anymore" onclick="regAlram('nopush');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96221/m/btn_anymore.png" alt="마일리지 알림 그만 받기"></button>
            <img src="//webimage.10x10.co.kr/fixevent/event/2019/96221/m/bg_btn.png" alt="">
        </div>

        <%' 팝업 레이어 %>
        <div class="lyr-pop" style="display:none;">
            <div class="lyr lyr-cont1">
                <img src="//webimage.10x10.co.kr/fixevent/event/2019/96221/m/txt_completed.png" alt="오늘의 마일리가 발급되었습니다." />
                <a href="" onclick="callgotoday();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96219/m/btn_confirm_1.png" alt="확인" /></a>
            </div>
        </div>
        <%'// 팝업 레이어 %>

        <a href="" onclick="jsEventlinkURL(96219);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96221/m/bnr_evt.jpg" alt="이벤트 신청 페이지로 가기" /></a>

        <div class="noti">
            <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/96221/m/tit_noti.png" alt="이벤트 유의사항" /></h3>
            <ul>
                <li>ID 당 하루에 1번씩 100 마일리지를 받을 수 있습니다</li>
                <li>도중에 푸시 수신을 해지하는 경우 알림을 받으실 수 없습니다.</li>
            </ul>
        </div>
    </div>
    <%'// 96221 마일리지이벤트(신청) %>
<!-- #include virtual="/lib/db/dbclose.asp" -->