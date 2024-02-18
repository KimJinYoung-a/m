<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
'####################################################
' Description : 2021 비밀의 SHOP
' History : 2021-09-17 정태훈 생성
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode
dim mktTest, vQuery, i, itemid(2), soldoutcheck, moECode

IF application("Svr_Info") = "Dev" THEN
    eCode = "109395"
    moECode = "109394"
    mktTest = true
    itemid(0) = "3324406"
    itemid(1) = "3297090"
    itemid(2) = "3218030"
ElseIf application("Svr_Info")="staging" Then
    eCode = "114301"
    moECode = "114298"
    mktTest = true
    itemid(0) = "4408239" '산리오 플래너
    itemid(1) = "4408240" '디즈니 머그컵
    itemid(2) = "4408243" '모나미 펜
Else
    eCode = "114301"
    moECode = "114298"
    mktTest = false
    itemid(0) = "4408239" '산리오 플래너
    itemid(1) = "4408240" '디즈니 머그컵
    itemid(2) = "4408243" '모나미 펜
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)
If isApp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If


eventStartDate      = cdate("2021-09-20")		'이벤트 시작일
eventEndDate 	    = cdate("2022-03-24")		'이벤트 종료일(소진시 종료)
LoginUserid		    = getencLoginUserid()
if mktTest then
    '// 테스트용
    currentDate = cdate("2021-09-21")
else
    currentDate = date()
end if

%>
<style>
.mEvt114301 section{position:relative;}

.mEvt114301 .section01 .float{position:absolute;width:72.3vw;top:10rem;left:50%;margin-left:-36.15vw;animation:updown 1s ease-in-out alternate infinite;}

.mEvt114301 .item .badge{width:12.8vw;position:absolute;top:0;left:8vw;height:5rem;}
.mEvt114301 .item .badge.limit{background:url(//webimage.10x10.co.kr/fixevent/event/2021/114301/badge_limit.png)no-repeat 0 0;background-size:100%;}
.mEvt114301 .item .badge.soldout{background:url(//webimage.10x10.co.kr/fixevent/event/2021/114301/badge_soldout.png)no-repeat 0 0;background-size:100%;}

.mEvt114301 .item button{width:84vw;position:absolute;bottom:5rem;left:50%;margin-left:-42vw;height:6rem;}
.mEvt114301 .item button.purchase{background:url(//webimage.10x10.co.kr/fixevent/event/2021/114301/btn_submit.png?v=3)no-repeat 0 0;background-size:100%;}
.mEvt114301 .item button.soldout{background:url(//webimage.10x10.co.kr/fixevent/event/2021/114301/btn_soldout.png?v=3)no-repeat 0 0;background-size:100%;}

@keyframes updown {
    0% {transform: translateY(-1rem);}
    100% {transform: translateY(1rem);}
}
</style>
<script type="text/javascript">

function goDirOrdItem(ino) {
    <% If Not(IsUserLoginOK) Then %>
        <% if isApp=1 then %>
            calllogin();
            return false;
        <% else %>
            jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
            return false;
        <% end if %>
    <% else %>
        <% If (currentDate >= eventStartDate And currentDate <= eventEndDate) Then %>    
            $.ajax({
                type:"GET",
                url:"/apps/appCom/wish/web2014/event/etc/doEventSubscript114301.asp",
                data: "mode=order&ino="+ino,
                dataType: "text",
                async:false,
                cache:true,
                success: function(resultData) {
                    var reStr = resultData.split("|");
                    if(reStr[0]=="OK"){
                        fnAmplitudeEventMultiPropertiesAction('click_event_buy','itemid',reStr[1])
                        $("#itemid").val(reStr[1]);
                        setTimeout(function() {
                            document.directOrd.submit();
                        },300);
                        return false;
                    }else if(reStr[0]=="Err"){
                        var errorMsg = reStr[1].replace(">?n", "\n");
                        alert(errorMsg);										
                    }			
                },
                error: function(err) {
                    console.log(err.responseText);
                }
            });
        <% Else %>
            alert("이벤트 응모 기간이 아닙니다.");
            return;
        <% End If %>        
    <% End IF %>
}
</script>
			<div class="mEvt114301">
				<section class="section01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/114301/top.jpg?v=2" alt="">
					<p class="float"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114301/float.png" alt=""></p>
                </section>
				<section class="section02 item">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/114301/item01.jpg?v=2.7" alt="">
                    <% If getitemlimitcnt(itemid(0)) < 1 Then %>
					<p class="badge soldout"></p>
					<button class="soldout"></button>
                    <% else %>
                    <p class="badge limit"></p>
					<button class="purchase" onclick="goDirOrdItem(1);"></button>
                    <% end if %>
				</section> 
				<section class="section03 item">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/114301/item02.jpg?v=2.7" alt="">
                    <% If getitemlimitcnt(itemid(1)) < 1 Then %>
					<p class="badge soldout"></p>
					<button class="soldout"></button>
                    <% else %>
					<p class="badge limit"></p>
					<button class="purchase" onclick="goDirOrdItem(2);"></button>
                    <% end if %>
				</section>
                <section class="section04 item">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/114301/item03.jpg?v=2.7" alt="">
                    <% If getitemlimitcnt(itemid(2)) < 1 Then %>
					<p class="badge soldout"></p>
					<button class="soldout"></button>
                    <% else %>
					<p class="badge limit"></p>
					<button class="purchase" onclick="goDirOrdItem(3);"></button>
                    <% end if %>
				</section>
				<section class="section02">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/114301/notice.jpg?v=2.1" alt="">
				</section>
			</div>
<form method="post" name="directOrd" action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp">
    <input type="hidden" name="itemid" id="itemid" value="">
    <input type="hidden" name="itemoption" value="0000">
    <input type="hidden" name="itemea" readonly value="1">
    <input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
    <input type="hidden" name="isPresentItem" value="" />
    <input type="hidden" name="mode" value="DO3">
</form>
<!-- #include virtual="/lib/db/dbclose.asp" -->