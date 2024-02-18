<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 100원 마일리지 신청 페이지 APP 전용
' History : 2020-03-02 원승현
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, moECode
IF application("Svr_Info") = "Dev" THEN
	eCode = "100913"
    moECode = "101082"
Else
	eCode = "101083"
    moECode = "101082"
End If


Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30) 

If isapp <> "1" Then 
	Response.redirect "/event/eventmain.asp?eventid="&moECode&"&gaparam="&gaparamChkVal
	Response.End
End If
%>
<%
'// SNS 공유용
	Dim vTitle, vLink, vPre, vImg
	Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

	snpTitle	= Server.URLEncode("마일리지 1,000p 무료 지급")
	snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
	snpPre		= Server.URLEncode("10x10 이벤트")
	snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/101083/m/img_kakao.jpg")
	appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode 

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "마일리지 1,000p 무료 지급"
	Dim kakaodescription : kakaodescription = "알림 신청만 해도 마일리지를 드려요. 지금 얼른 받아가세요!"
	Dim kakaooldver : kakaooldver = "알림 신청만 해도 마일리지를 드려요. 지금 얼른 받아가세요!"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/101083/m/img_kakao.jpg"
	Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink 
	kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
	kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode
	kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& moECode
%>
<style type="text/css">
.mEvt101083 {background-color:#ff7b2c;}
.mEvt101083 button {display:block; width:100%; background-color:transparent;}
.mEvt101083 .lyr-pop {display:flex; flex-direction:column; align-items:center; justify-content:center; position:fixed; top:0; left:0; z-index:100; width:100vw; height:100vh; background-color:rgba(0,0,0,.6);}
.mEvt101083 .lyr-pop button {width:auto;}
.mEvt101083 .way {position:relative;}
.mEvt101083 .way a {display:block; position:absolute; top:48%; left:0; width:100%; height:10%; color:transparent;}
.mEvt101083 .sns-share {position:relative;}
.mEvt101083 .sns {display:inline-block; position:absolute; top:0; left:56.3%; width:16.3%; height:100%; text-indent:-999em;}
.mEvt101083 .sns.kakao {left:74.6%;}
</style>
<script type="text/javascript">
$(function(){
    $(".lyr-pop button").on("click", function (e) {
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
                url:"/apps/appCom/wish/web2014/event/etc/doeventsubscript/doEventSubscript101083.asp",
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
</head>
<body>
    <%' 101083 마일리지이벤트(신청) %>
    <div class="mEvt101083">
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/101083/m/tit_event1.png" alt="마일리지 이벤트" /></h2>
        <button class="btn-apply" onclick="regAlram();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101083/m/btn_apply.png" alt="마일리지 알림 신청하기" /></button>

        <%' 팝업 레이어 %>
        <div class="lyr-pop" style="display:none;">
            <%' 푸시 수신 동의 %>
            <button class="lyr-cont1" style="display:none;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101083/m/txt_pop1.png" alt="신청이 완료되었습니다." /></button>

            <%' 푸시 수신 비동의 %>
            <a href="#" onclick="fnCheckAlarmPopup();return false;" class="lyr-cont2" style="display:none;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101083/m/txt_pop2.png" alt="먼저 푸시 수신 동의를 하셔야 이벤트 신청이 가능합니다." /></a>
        </div>
        <%'// 팝업 레이어 %>

        <div class="way">
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/101083/m/img_way.png" alt="참여방법" />
        <a href="#" onclick="fnAPPpopupSetting();return false;">PUSH알람 설정하러 가기</a>
        </div>

        <%' sns공유 %>
        <div class="sns-share">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/101083/m/img_sns.png" alt="친구에게도 이벤트를 알려주세요!" />
            <a href="javascript:snschk('fb')" class="sns fb">페이스북 공유</a>
            <a href="javascript:snschk('ka')" class="sns kakao">카카오톡 공유</a>
        </div>
        <%'// sns공유 %>

        <div class="noti"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101083/m/txt_noti1.png" alt="이벤트 유의사항" /></div>
    </div>
    <%'// 101083 마일리지이벤트(신청) %>
<!-- #include virtual="/lib/db/dbclose.asp" -->