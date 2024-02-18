<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 200원 마일리지 발급 페이지
' History : 2020-08-18 정태훈
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, issueCode, moECode
'// 현재 페이지의 코드는 101393 이지만 실제 마일리지 신청을 받은 event_subscript의 코드는 101392이며 푸시가 발송될때도 101392 기준으로 보냄
IF application("Svr_Info") = "Dev" THEN
	eCode = "102215"
    issueCode = "102214"
    moECode = "102213"
Else
	eCode = "105236"
    issueCode = "105235"
    moECode = "105234"
End If
%>
<style>
.mEvt105236 {background-color:#2c7bff;}
.mEvt105236 button {display:block; width:100%; background-color:transparent;}
.mEvt105236 .lyr-pop {display:flex; flex-direction:column; align-items:center; justify-content:center; position:fixed; top:0; left:0; z-index:100; width:100vw; height:100vh; background-color:rgba(0,0,0,.6);}
.mEvt105236 .lyr-pop button {width:auto;}
</style>
<script type="text/javascript">
    $(function(){
        $(".lyr-pop button").on("click", function (e) {
            $('.lyr-pop').hide();
        });

        setTimeout(function(){fnAmplitudeEventMultiPropertiesAction('view_event_105236','loginstatus','<%=IsUserLoginOK%>');}, 100);
    });

    // 마일리지 발급 및 푸시 알림 그만받기 신청
    function regAlram(act) {
        setTimeout(function(){fnAmplitudeEventMultiPropertiesAction('click_event_submit_105236','loginstatus','<%=IsUserLoginOK%>');}, 100);
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
                url:"/apps/appCom/wish/web2014/event/etc/doeventsubscript/doEventSubscript105235.asp",
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
                    setTimeout(function(){fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|actype','<%=eCode%>|mileageok');}, 100);
                } else if(reStr[1] == "nopush"){			
                    alert("마일리지 알림 신청이 취소되었습니다.");
                    setTimeout(function(){fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|actype','<%=eCode%>|nopush');}, 100);
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
    <%' 105236 마일리지 발급 %>
            <div class="mEvt105236">
                <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/105235/m/tit_get.png" alt="반가워요 오늘도 마일리지 200p 받아가세요!" /></h2>
                <button class="btn-get" onclick="regAlram('action');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105235/m/btn_get.png" alt="마일리지받기" /></button>
                <button class="btn-anymore" onclick="regAlram('nopush');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105235/m/btn_quit.png" alt="마일리지 알림 그만 받기"></button>

                <!-- 팝업 -->
                <div class="lyr-pop" style="display:none;">
                <button onclick="callgotoday();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105235/m/txt_succ.png" alt="오늘의 마일리가 발급되었습니다." /></button>
                </div>

                <div class="noti"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105235/m/txt_noti2.png" alt="이벤트 유의사항" /></div>
            </div>
    <%'// 105236 마일리지이벤트(신청) %>
<!-- #include virtual="/lib/db/dbclose.asp" -->