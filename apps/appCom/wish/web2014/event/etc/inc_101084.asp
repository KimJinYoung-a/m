<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 100원 마일리지 발급 페이지
' History : 2020-03-03 원승현
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
'// 현재 페이지의 코드는 101084 이지만 실제 마일리지 신청을 받은 event_subscript의 코드는 101083이며 푸시가 발송될때도 101083 기준으로 보냄
IF application("Svr_Info") = "Dev" THEN
	eCode = "100914"
    issueCode = "100913"
    moECode = "101082"
Else
	eCode = "101084"
    issueCode = "101083"
    moECode = "101082"
End If
%>
<style type="text/css">
.mEvt101084 {background-color:#ff7b2c;}
.mEvt101084 button {display:block; width:100%; background-color:transparent;}
.mEvt101084 .lyr-pop {display:flex; flex-direction:column; align-items:center; justify-content:center; position:fixed; top:0; left:0; z-index:100; width:100vw; height:100vh; background-color:rgba(0,0,0,.6);}
.mEvt101084 .lyr-pop button {width:auto;}
</style>
<script type="text/javascript">
    $(function(){
        $(".lyr-pop button").on("click", function (e) {
            $('.lyr-pop').hide();
        });

        setTimeout(function(){fnAmplitudeEventMultiPropertiesAction('view_event_101084','loginstatus','<%=IsUserLoginOK%>');}, 100);
    });

    // 마일리지 발급 및 푸시 알림 그만받기 신청
    function regAlram(act) {
        setTimeout(function(){fnAmplitudeEventMultiPropertiesAction('click_event_submit_101084','loginstatus','<%=IsUserLoginOK%>');}, 100);
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
                url:"/apps/appCom/wish/web2014/event/etc/doeventsubscript/doEventSubscript101083.asp",
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
    <%' 101084 마일리지 발급 %>
    <div class="mEvt101084">
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/101083/m/tit_event2.png" alt="마일리지 이벤트" /></h2>
        <button class="btn-get" onclick="regAlram('action');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101083/m/btn_get.png" alt="마일리지받기" /></button>
        <button class="btn-anymore" onclick="regAlram('nopush');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101083/m/btn_quit.png" alt="마일리지 알림 그만 받기"></button>

        <%' 팝업 %>
        <div class="lyr-pop" style="display:none;">
          <button onclick="callgotoday();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101083/m/txt_succ.png" alt="오늘의 마일리가 발급되었습니다." /></button>
        </div>

        <div class="noti"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101083/m/txt_noti2.png" alt="이벤트 유의사항" /></div>
    </div>
    <%'// 101084 마일리지이벤트(신청) %>
<!-- #include virtual="/lib/db/dbclose.asp" -->