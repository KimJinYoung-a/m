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
If isApp = "1" Then
	Response.redirect "/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode &"&gaparam="&gaparamChkVal
	Response.End
End If


eventStartDate      = cdate("2021-09-20")		'이벤트 시작일
eventEndDate 	    = cdate("2021-03-24")		'이벤트 종료일(소진시 종료)
LoginUserid		    = getencLoginUserid()
if mktTest then
    '// 테스트용
    currentDate = cdate("2021-09-20")
else
    currentDate = date()
end if

%>
<style>
.mEvt114298 section{position:relative;}

.mEvt114298 .section01 .float{position:absolute;width:72.3vw;top:10rem;left:50%;margin-left:-36.15vw;animation:updown 1s ease-in-out alternate infinite;}
.mEvt114298 .section01 .app_link{width:84vw;height:6rem;position:absolute;bottom:5.5rem;left:50%;margin-left:-42vw;}

.mEvt114298 .item .badge{width:12.8vw;position:absolute;top:0;left:8vw;height:5rem;}
.mEvt114298 .item .badge.limit{background:url(//webimage.10x10.co.kr/fixevent/event/2021/114298/badge_limit.png)no-repeat 0 0;background-size:100%;}
.mEvt114298 .item .badge.soldout{background:url(//webimage.10x10.co.kr/fixevent/event/2021/114298/badge_soldout.png)no-repeat 0 0;background-size:100%;}

@keyframes updown {
    0% {transform: translateY(-1rem);}
    100% {transform: translateY(1rem);}
}
</style>
			<div class="mEvt114298">
				<section class="section01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/114298/top.jpg?v=2" alt="">
					<p class="float"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114298/float.png" alt=""></p>
					<a href="https://tenten.app.link/amn4Uw3pAjb?%24deeplink_no_attribution=true" class="app_link"></a>
                </section>
				<section class="section02 item">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/114298/item01.jpg?v=2.7" alt="">
                    <% If getitemlimitcnt(itemid(0)) < 1 Then %>
					<p class="badge soldout"></p>
                    <% else %>
                    <p class="badge limit"></p>
                    <% end if %>
				</section> 
				<section class="section03 item">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/114298/item02.jpg?v=2.7" alt="">
					<% If getitemlimitcnt(itemid(1)) < 1 Then %>
					<p class="badge soldout"></p>
                    <% else %>
                    <p class="badge limit"></p>
                    <% end if %>
				</section>
                <section class="section04 item">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/114298/item03.jpg?v=2.7" alt="">
					<% If getitemlimitcnt(itemid(2)) < 1 Then %>
					<p class="badge soldout"></p>
                    <% else %>
                    <p class="badge limit"></p>
                    <% end if %>
				</section>
				<section class="section02">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/114298/notice.jpg?v=2.1" alt="">
				</section>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->