<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 스파오 이벤트
' History : 2019-10-25
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim currentdate
	currentdate = date()
	'currentdate = "2019-10-31"
	'response.write currentdate

dim testDate
testDate = request("testdate")
if testDate <> "" then
    currentDate = Cdate(testDate)
end if
%>
<style>
.mEvt98151 .top {position:relative;}
.mEvt98151 .top h2, .top .intro, .top .arrow {position:absolute; top:30.3%; left:0; width:100%; margin-top:4rem; opacity:0;}
.mEvt98151 .top.ani h2, .mEvt98151 .top.ani .intro, .mEvt98151 .top.ani .arrow {margin-top:0; opacity:1; transition:all .6s .3s;}
.mEvt98151 .top.ani .intro {transition-delay:.6s;}
.mEvt98151 .top.ani .arrow {transition-delay:.9s;}
.mEvt98151 .top .intro {top:40.17%;}
.mEvt98151 .top .arrow {top:72.89%;}
.mEvt98151 li span {display:none;}
.mEvt98151 .close a, .mEvt98151 .soon a {display:none;}
.mEvt98151 .close span, .mEvt98151 .soon span {display:block;}
</style>
<script type="text/javascript">
$(function(){
    $('.top').addClass('ani');
	$('.close').on('click', function(e){
		e.preventDefault();
		alert("종료된 이벤트 입니다 ㅜㅜ");
	});
	$('.soon').on('click', function(e){
		e.preventDefault();
		alert("오픈예정 이벤트 입니다 :)");
	});
});
</script>
<!-- MKT_98178_SPAO -->
<div class="mEvt98151">
    <div class="top">
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/98178/m/tit_spao1.png" alt="얼마나 좋을까?"></h2>
        <p class="intro"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98178/m/tit_spao2.png" alt="매일 입는 옷이 우리의 체형에 맞는 패턴이라면, 세상에서 가장 좋은 소재라면, 우리 피부에 어울릴 색상이라면, 그리고 모두에게 부담 없는 가격이라면. 이 조건에 대한 해답."></p>
        <span class="arrow"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98178/m/img_arrow.png" alt=""></span>
        <img src="//webimage.10x10.co.kr/fixevent/event/2019/98178/m/bg_top.jpg" alt="">
    </div>
    <ul>
        <li>
            <a href="/event/eventmain.asp?eventid=98192" onclick="jsEventlinkURL(98192);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98178/m/img_item1.jpg" alt="다시 돌아온, New 해리포터 선착순 사은품 증정"></a>
            <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/98178/m/img_item1_2.jpg" alt="다시 돌아온, New 해리포터 선착순 사은품 증정 종료"></span>
        </li>
        <% if currentdate > "2019-10-30" then %>
        <li class="close">
        <% Else %>
        <li>
        <% End If %>
            <a href="/event/eventmain.asp?eventid=98193" onclick="jsEventlinkURL(98193);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98178/m/img_item2.jpg" alt="다시 돌아온, New 해리포터 선착순 사은품 증정 종료"></a>
            <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/98178/m/img_item2_2.jpg" alt="반가운 스파오! 20% Sale 단 3일 동안 전상품 할인 종료"></span>
        </li>
        <li>
            <a href="/event/eventmain.asp?eventid=98194" onclick="jsEventlinkURL(98194);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98178/m/img_item3.jpg" alt="애니메이션 캐릭터 콜라보 라인 귀여운 캐릭터 의류 제품 할인"></a>
        </li>
        <% if currentdate > "2019-10-30" then %>
        <li>
        <% Else %>
        <li class="soon">
        <% End If %>
            <a href="/event/eventmain.asp?eventid=98195" onclick="jsEventlinkURL(98195);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98178/m/img_item4_2.jpg?v=1.01" alt="Double 1+1 item 한 개로는 아쉬운 아이템 하나 더!"></a>
            <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/98178/m/img_item4.jpg?v=1.01" alt="Double 1+1 item 한 개로는 아쉬운 아이템 하나 더!"></span>
        </li>
    </ul>
    <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/98178/m/txt_collabo.png" alt="spao 10x01 콜라보"></p>
</div>
<!--// MKT_98178_SPAO -->
<!-- #include virtual="/lib/db/dbclose.asp" -->