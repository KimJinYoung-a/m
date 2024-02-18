<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 로지텍 스토리 오픈
' History : 2021-10-13 정태훈
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eventStartDate, eventEndDate, LoginUserid, mktTest
dim eCode, currentDate

IF application("Svr_Info") = "Dev" THEN
	eCode = "108384"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "114332"
    mktTest = True
Else
	eCode = "114332"
    mktTest = False
End If

eventStartDate  = cdate("2021-10-14")		'이벤트 시작일
eventEndDate 	= cdate("2021-10-17")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if mktTest then
    currentDate = cdate("2021-10-14")
else
    currentDate = date()
end if
%>
<style>
.section03{background:#fff;}
.section03 .wrap-vod{width:100%;}
.section03 .wrap-vod video{width:100%;}
.section03 .sound{text-align: center;color:#cecba6;font-size:1.31rem;font-weight:bold;margin-top:1rem;}

.section05{position:relative;}
.section05 a.alert{position:absolute;width:74vw;height:6.5rem;bottom:5rem;left:50%;margin-left:-37vw;}
</style>
<script>
$(function() {

	var myImage=document.getElementById("title_img");
	var imageArray=[
		"//webimage.10x10.co.kr/fixevent/event/2021/114332/m/on.png",
		"//webimage.10x10.co.kr/fixevent/event/2021/114332/m/off.png"];
	var imageIndex=0;

	function changeImage(){
	myImage.setAttribute("src",imageArray[imageIndex]);
	imageIndex++;
	if(imageIndex>=imageArray.length){
	imageIndex=0;
	}
	}
	setInterval(changeImage,1500);
});
function goPushScript(evt_code, pushTime){
<% If Not(IsUserLoginOK) Then %>
    <% if isApp="1" then %>
        calllogin();
    <% else %>
        jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
    <% end if %>
    return false;
<% else %>
    <% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>
        alert("이벤트 참여기간이 아닙니다.");
        return false;
    <% end if %>

    if(pushTime == 0){
        alert("푸시 신청 기간이 아닙니다.");
        return false;
    }else{
        $.ajax({
            type:"GET",
            url:"/event/etc/doeventsubscript/doEventSubscript114332.asp?mode=pushadd&evt_code=" + evt_code,
            dataType: "json",
            success : function(result){
                if(result.response == "ok"){
                    alert("푸시 알림 신청이 완료 되었습니다.");
                    return false;
                }else{
                    alert(result.faildesc);
                    return false;
                }
            },
            error:function(err){
                console.log(err);
                return false;
            }
        });
    }
<% end if %>
}
</script>
			<div class="mEvt114332">
				<section class="section01">
					<img id="title_img" src="" alt="">
				</section>
				<section class="section02">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/114332/m/section01.jpg" alt="">
				</section>
				<section class="section03">
					<div class="wrap-vod">
						<video poster="//webimage.10x10.co.kr/fixevent/event/2021/114332/m/poster.jpg" src="//webimage.10x10.co.kr/fixevent/event/2021/114332/logitech_ts.mp4" preload="auto" autoplay="true" loop="loop" muted="muted" volume="0" controls playsinline></video>
					</div>
                    <p class="sound">소리를 켜고 감상해 주세요</p>
				</section>
				<section class="section04">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/114332/m/section02.jpg" alt="">
				</section>
				<section class="section05">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/114332/m/section03.jpg" alt="">
					<a href="" onclick="goPushScript('<%=eCode%>', '2021-10-18');return false;" class="alert"></a>
				</section>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->