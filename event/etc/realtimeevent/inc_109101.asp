<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 타임세일 티저
' History : 2021-01-20 정태훈 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
dim currentTime '// 현재 시간
dim mktTest '// 테스트 여부
dim LoginUserid : LoginUserid = GetEncLoginUserID()
dim eCode
dim currentDate

mktTest = false

IF application("Svr_Info") = "Dev" THEN
	eCode = "104302"
    mktTest = true
ElseIf application("Svr_Info")="staging" Then
	eCode = "109101"
    mktTest = false    
Else
	eCode = "109101"
    mktTest = false
End If

'// 해당 아이디들은 테스트 할때 mktTest값을 true로 강제로 적용하여 테스트
'// TEST
if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" then
    mktTest = true
end if

if mktTest then
    '// 테스트용
    currentDate = CDate("2021-01-23 01:00:00")
    currentTime = Cdate("01:00:00")
    '// 테스트 끝나면 사고 방지 차원에서 서버 시간으로 변경
    'currentDate = CDate(Date()&" "&Right("0"&hour(time),2) &":"& Right("0"&minute(time),2) &":"& Right("0"&second(time),2))
    'currentTime = time()        
else
    currentDate = CDate(Date()&" "&Right("0"&hour(time),2) &":"& Right("0"&minute(time),2) &":"& Right("0"&second(time),2))
    currentTime = time()    
end if

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

'// 2020년 11월 25일 이후엔 해당 페이지로 접근 하면 실제 이벤트 페이지로 자동으로 redirect 시켜줌
If Left(currentDate,10) >= "2021-01-25" Then
    If isApp="1" Then
        response.redirect "/apps/appCom/wish/web2014/event/eventmain.asp?eventid=109103"
        response.end
    Else
        response.redirect "/event/eventmain.asp?eventid=109102"
        response.end
    End If
End If

%>
<style>
.mEvt109101 {position:relative;}
.mEvt109101 .topic {position:relative; background:#ff4343;}
.mEvt109101 .topic .limit {position:absolute; top:37%; right:0; left:0; width:29%; margin:auto; animation:blink 1.5s both;}
.mEvt109101 .btn-push {width:100%;}
.mEvt109101 .lyr {display:none; overflow-y:scroll; position:fixed; top:0; left:0; z-index:30; width:100vw; height:100vh; background:rgba(0,0,0,.9);}
.mEvt109101 .lyr-push .inner {position:relative;}
.mEvt109101 .lyr-push .form {display:flex; position:absolute; top:63%; right:0; left:0; width:70%; margin:auto; border-bottom:2px solid #ffe536;}
.mEvt109101 .lyr-push .form input {flex:1; padding:0; font-size:1.45rem; color:#fff; border:none; background:none;}
.mEvt109101 .lyr-push .form input::placeholder {color:#b1b1b1;}
.mEvt109101 .lyr-push .form .btn-submit {font-size:1.45rem; color:#ffe536; background:none;}
.mEvt109101 .btn-close {position:absolute; top:0; right:0; width:16vw; height:16vw; font-size:0; background:none;}
@keyframes blink {
	0% {opacity:1; transform:scale(1.5);}
	30% {opacity:1; transform:none;}
	50%,70% {opacity:0;}
	60%,80%,100% {opacity:1;}
}
</style>
<script>
$(function() {
	// 사전 알림 신청 팝업
	$('.mEvt109101 .btn-push').on('click', function(e) {
		$('.mEvt109101 .lyr-push').fadeIn();
	});
	$('.mEvt109101 .btn-close').on('click', function(e) {
		$('.mEvt109101 .lyr-push').fadeOut();
	});

    $("#phone").keyup(function(){
        var keyID = event.which;
        if ((keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 9 || keyID == 46 || keyID == 37 || keyID == 39) {
            return;
        }
        else {
            alert("숫자만 입력 가능합니다.");
            this.value = this.value.replace(/[^0-9\.]/g, '');
        }
    });
});

function maxLengthCheck(object){
    if (object.value.length > object.maxLength){
        object.value = object.value.slice(0, object.maxLength);
    }
}

function fnSendToKakaoMessage() {
    <%'// 이벤트 진행일자를 제외하곤 신청안됨 %>
    <% If (left(currentdate, 10) < "2021-01-23" Or left(currentdate, 10) > "2021-01-24") Then %> 
        alert("이벤트 기간에만 신청하실 수 있습니다.");
        return false;
    <% End If %>

    if ($("#phone").val() == '') {
        alert('알림 받으실 전화번호를 정확히 입력해 주세요.');
        $("#phone").focus();
        return;
    }
    var phoneNumber;
    if ($("#phone").val().length > 10) {
        phoneNumber = $("#phone").val().substring(0,3)+ "-" +$("#phone").val().substring(3,7)+ "-" +$("#phone").val().substring(7,11);
    } else {
        phoneNumber = $("#phone").val().substring(0,3)+ "-" +$("#phone").val().substring(3,6)+ "-" +$("#phone").val().substring(6,10);
    }

    $.ajax({
        type:"GET",
        url:"/event/etc/doeventSubscript109101.asp",
        data: "mode=kamsg&phoneNumber="+btoa(phoneNumber),
        dataType: "text",
        async:false,
        cache:true,
        success : function(Data, textStatus, jqXHR){
            if (jqXHR.readyState == 4) {
                if (jqXHR.status == 200) {
                    if(Data!="") {
                        var str;
                        for(var i in Data)
                        {
                                if(Data.hasOwnProperty(i))
                            {
                                str += Data[i];
                            }
                        }
                        str = str.replace("undefined","");
                        res = str.split("|");
                        if (res[0]=="OK") {
                            alert('신청이 완료되었습니다.');
                            $("#phone").val('')
                            $(".pop-container").fadeOut();
                            return false;
                        }else{
                            errorMsg = res[1].replace(">?n", "\n");
                            alert(errorMsg );
                            return false;
                        }
                    } else {
                        alert("잘못된 접근 입니다.");
                        document.location.reload();
                        return false;
                    }
                }
            }
        },
        error:function(jqXHR, textStatus, errorThrown){
            alert("잘못된 접근 입니다.");					
            return false;
        }
    });
}
</script>
			<div class="mEvt109101">
				<div class="topic">
					<h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/109101/m/tit_time_sale.jpg" alt="선착순 타임세일"></h2>
					<span class="limit"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109101/m/txt_limit.png" alt="한정수량"></span>
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2021/109101/m/txt_info.jpg" alt="1월 25일(월) 부터 27일(수) 까지 3일간 매일 10시, 15시, 18시"></p>
				</div>
				<div class="mWeb">
					<a href="https://tenten.app.link/75JTTFOn8cb?%24deeplink_no_attribution=true"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109101/m/btn_down.jpg" alt="앱 다운받기"></a>
				</div>
                <div class="mApp">
					<button type="button" class="btn-push"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109101/m/btn_push.jpg" alt="사전 알림 신청하기"></button>
				</div>
				<div class="lyr lyr-push" style="display:none">
					<div class="inner">
						<button type="button" class="btn-close">닫기</button>
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2021/109101/m/txt_push.png" alt="사전 알림 신청"></p>
						<div class="form">
							<input type="number" name="phone" id="phone" maxlength="11" placeholder="휴대폰 번호를 입력해주세요" oninput="maxLengthCheck(this)">
							<button type="button" class="btn-submit" onclick="fnSendToKakaoMessage()">확인</button>
						</div>
					</div>
				</div>
				<!-- 기획전 링크 -->
				<a href="/event/eventmain.asp?eventid=109136" target="_blank" class="mWeb">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/109101/m/bnr_evt.jpg" alt="">
				</a>
				<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=109136');return false;" class="mApp">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/109101/m/bnr_evt.jpg" alt="">
				</a>
				<p><img src="//webimage.10x10.co.kr/fixevent/event/2021/109101/m/txt_notice.jpg" alt="이벤트 유의사항"></p>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->