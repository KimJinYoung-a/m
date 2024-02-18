<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 발렌타임세일 moweb
' History : 2020-02-04 김송이
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim currentdate
dim eCode
    currentdate = date()
    'currentdate = "2020-02-06"
    'response.write currentdate

    IF application("Svr_Info") = "Dev" THEN
        eCode = "90463"	
    Else
        eCode = "100415"
    End If
%>
<style type="text/css">
.time-teaser {background-color:#d0378f;}
.time-teaser h2  {position:relative;}
.time-teaser .btn-app {display:inline-block; position:absolute; top:0; left:0; width:100%; height:100%; text-indent:-999em;}
.related-evt {background-color:#ff76a0;}
</style>
<%' 발렌타임(M) %>
<div class="mEvt100415 time-sale">
    <div class="time-teaser">
        <h2>
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/100414/m/tit_teaser_app.png?v=1.01" alt="발렌 타임 세일 APP 전용">
            <% if currentdate < "2020-02-06" then %>
            <a href="https://tenten.app.link/XnWMGw1UL3" class="btn-app">APP 설치하기</a>
            <% Else %>
            <a href="https://tenten.app.link/givwID5UL3" class="btn-app">APP 설치하기</a>
            <% End If %>
        </h2>
        <div class="teaser-item"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100414/m/img_items.jpg?v=1.02" alt="타임세일 상품 리스트"></div>
    </div>
    <a href="/deal/deal.asp?itemid=2706487&pEtr=100415"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100414/m/bnr_peng.jpg" alt="펭수의 옷장을 공개합니다!"></a>
    <div class="related-evt">
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/100414/m/tit_evt.png" alt="잠깐 찬스, 하나더 아니, 세개 더"></p>
        <ul>
            <li><a href="/event/eventmain.asp?eventid=100067" onclick="jsEventlinkURL(100067);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100414/m/img_evt1.jpg" alt="직접 만드는 초콜릿  인기DIY 세트! ~54%"></a></li>
            <li><a href="/event/eventmain.asp?eventid=100148" onclick="jsEventlinkURL(100148);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100414/m/img_evt2.jpg" alt="초콜릿 대신  달달한 향수는 어때요? ~70%"></a></li>
            <li><a href="/event/eventmain.asp?eventid=100228" onclick="jsEventlinkURL(100228);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100414/m/img_evt3.jpg" alt="발렌타인 꽃다발 에디션 특가!"></a></li>
        </ul>
    </div>
    <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/100414/m/txt_noti.png" alt="이벤트 유의사항"></div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->