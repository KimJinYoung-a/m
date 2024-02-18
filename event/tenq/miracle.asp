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
' Description : 2018 텐큐베리감사 - 100원의 기적
' History : 2018-03-26 이종화
'####################################################

Dim ecode : eCode = "85145"
Dim actdate : actdate = Date()

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg , appfblink
snpTitle	= Server.URLEncode("[텐바이텐] 텐큐-100원의 기적")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=85145")
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/eventIMG/2018/85145/etcitemban20180327095902.JPEG")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid=85145"


''head.asp에서 출력
strOGMeta = strOGMeta & "<meta property=""og:title"" content=""[텐바이텐] 100원의 기적"">" & vbCrLf
strOGMeta = strOGMeta & "<meta property=""og:type"" content=""website"" />" & vbCrLf
strOGMeta = strOGMeta & "<meta property=""og:url"" content=""http://m.10x10.co.kr/event/eventmain.asp?eventid=85145"" />" & vbCrLf
strOGMeta = strOGMeta & "<meta property=""og:image"" content=""http://webimage.10x10.co.kr/eventIMG/2018/85145/etcitemban20180327095902.JPEG"">" & vbCrLf
strOGMeta = strOGMeta & "<meta property=""og:description"" content=""4/2 ~ 16, 총 15일간 매일 다른 상품들을 100원에 만나보세요!"">" & vbCrLf

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐] 100원의 기적"
Dim kakaodescription : kakaodescription = "100원으로 엄청난 상품들을 구매할 수 있는 기적에 도전하세요! 4/2~16 총 15일간 매일 새로운 상품이 당신을 기다립니다. 지금 도전해보세요! 오직 텐바이텐에서!"
Dim kakaooldver : kakaooldver = "[텐바이텐] 100원의 기적\n\n100원으로 엄청난 상품들을\n구매할 수 있는\n기적에 도전하세요!\n\n4/2~16 총 15일간 매일 새로운 상품이 당신을 기다립니다.\n\n지금 도전해보세요!\n오직 텐바이텐에서!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2018/85145/etcitemban20180327095902.JPEG"
Dim kakaolink_url 
If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=85145"
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid=85145"
End If

Dim vUserID
vUserID		= GetEncLoginUserID

Dim vQuery , myevtdaycnt
If vUserID <> "" Then 
	vQuery = ""
	vQuery = vQuery & " select top 1 sub_opt1 From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" and userid='"& vUserID &"' and datediff(day,regdate,getdate()) = 0 "
	rsget.Open vQuery, dbget, 1
	IF Not rsget.Eof Then
		myevtdaycnt = rsget(0)
	End If 
	rsget.close
End If 

'#################################################################################################
'// 당첨자 리스트
'#################################################################################################
Dim sqlStr
Dim win1 , win2 , win3 , win4 , win5 , win6 , win7 , win8 , win9 , win10
Dim win11 , win12 , win13 , win14 , win15
sqlStr = ""
sqlStr = sqlStr & " SELECT isnull([2018-04-02],'') as win1 , isnull([2018-04-03],'') as win2 , isnull([2018-04-04],'') as win3 , isnull([2018-04-05],'') as win4 , isnull([2018-04-06],'') as win5 , isnull([2018-04-07],'') as win6 , isnull([2018-04-08],'') as win7 , isnull([2018-04-09],'') as win8 " & vbCrlf
sqlStr = sqlStr & " , isnull([2018-04-10],'') as win9 , isnull([2018-04-11],'') as win10 , isnull([2018-04-12],'') as win11 , isnull([2018-04-13],'') as win12 , isnull([2018-04-14],'') as win13 , isnull([2018-04-15],'') as win14 , isnull([2018-04-16],'') as win15 " & vbCrlf
sqlStr = sqlStr & " FROM " & vbCrlf
sqlStr = sqlStr & " ( " & vbCrlf
sqlStr = sqlStr & " 	SELECT convert(varchar(10),regdate,120) as rgt , userid " & vbCrlf
sqlStr = sqlStr & " 	FROM db_event.[dbo].[tbl_event_subscript] WITH(NOLOCK) " & vbCrlf
sqlStr = sqlStr & " 	WHERE evt_code = "& ecode &" and sub_opt2 = 1 " & vbCrlf
sqlStr = sqlStr & " 	GROUP BY userid , convert(varchar(10),regdate,120) " & vbCrlf
sqlStr = sqlStr & " ) AS A " & vbCrlf
sqlStr = sqlStr & " PIVOT " & vbCrlf
sqlStr = sqlStr & " ( " & vbCrlf
sqlStr = sqlStr & " 	MIN(userid) " & vbCrlf
sqlStr = sqlStr & " 	FOR rgt IN ([2018-04-02] , [2018-04-03] , [2018-04-04] , [2018-04-05] , [2018-04-06] , [2018-04-07] ,[2018-04-08] ,[2018-04-09] ,[2018-04-10] , [2018-04-11] ,[2018-04-12]  ,[2018-04-13] ,[2018-04-14] ,[2018-04-15] ,[2018-04-16]) " & vbCrlf
sqlStr = sqlStr & " ) A "


rsget.Open sqlStr,dbget,1
If not rsget.EOF Then
	win1 = rsget("win1")
	win2 = rsget("win2")
	win3 = rsget("win3")
	win4 = rsget("win4")
	win5 = rsget("win5")
	win6 = rsget("win6")
	win7 = rsget("win7")
	win8 = rsget("win8")
	win9 = rsget("win9")
	win10 = rsget("win10")
	win11 = rsget("win11")
	win12 = rsget("win12")
	win13 = rsget("win13")
	win14 = rsget("win14")
	win15 = rsget("win15")
End If
rsget.close
'#################################################################################################
'// 상품 당첨 여부 onoff
Function onoffimg(v)
	Select Case CStr(v)
		Case "2018-04-02"
			onoffimg = chkiif(win1<>"","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_soldout_0402.jpg?v=1' alt='' />","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_0402.jpg?v=1' alt='' />")
		Case "2018-04-03"
			onoffimg = chkiif(win2<>"","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_soldout_0403.jpg?v=1' alt='' />","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_0403.jpg?v=1' alt='' />")
		Case "2018-04-04"
			onoffimg = chkiif(win3<>"","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_soldout_0404.jpg?v=1' alt='' />","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_0404.jpg?v=1' alt='' />")
		Case "2018-04-05"
			onoffimg = chkiif(win4<>"","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_soldout_0405.jpg?v=1' alt='' />","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_0405.jpg?v=1' alt='' />")
		Case "2018-04-06"
			onoffimg = chkiif(win5<>"","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_soldout_0406.jpg?v=1' alt='' />","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_0406.jpg?v=1' alt='' />")
		Case "2018-04-07"
			onoffimg = chkiif(win6<>"","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_soldout_0407.jpg?v=1' alt='' />","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_0407.jpg?v=1' alt='' />")
		Case "2018-04-08"
			onoffimg = chkiif(win7<>"","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_soldout_0408.jpg?v=1' alt='' />","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_0408.jpg?v=1' alt='' />")
		Case "2018-04-09"
			onoffimg = chkiif(win8<>"","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_soldout_0409.jpg?v=1' alt='' />","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_0409.jpg?v=1' alt='' />")
		Case "2018-04-10"
			onoffimg = chkiif(win9<>"","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_soldout_0410.jpg?v=1' alt='' />","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_0410.jpg?v=1' alt='' />")
		Case "2018-04-11"
			onoffimg = chkiif(win10<>"","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_soldout_0411.jpg?v=1' alt='' />","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_0411.jpg?v=1' alt='' />")
		Case "2018-04-12"
			onoffimg = chkiif(win11<>"","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_soldout_0412.jpg?v=1' alt='' />","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_0412.jpg?v=1' alt='' />")
		Case "2018-04-13"
			onoffimg = chkiif(win12<>"","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_soldout_0413.jpg?v=1' alt='' />","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_0413.jpg?v=1' alt='' />")
		Case "2018-04-14"
			onoffimg = chkiif(win13<>"","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_soldout_0414.jpg?v=1' alt='' />","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_0414.jpg?v=1' alt='' />")
		Case "2018-04-15"
			onoffimg = chkiif(win14<>"","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_soldout_0415.jpg?v=1' alt='' />","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_0415.jpg?v=1' alt='' />")
		Case "2018-04-16"
			onoffimg = chkiif(win15<>"","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_soldout_0416.jpg?v=1' alt='' />","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_0416.jpg?v=1' alt='' />")
		Case Else
			onoffimg = chkiif(win1<>"","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_soldout_0402.jpg?v=1' alt='' />","<img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/today_0402.jpg?v=1' alt='' />")
	end Select
End function

'// 2배배너 노출 시간
Function doubletime(v)
	Select Case CStr(v)
		Case "2018-04-02"
			doubletime = chkiif(hour(now) < 14,"<span></span><p><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/txt_double_0402.png' alt='' /></p>","")
		Case "2018-04-03"
			doubletime = chkiif(hour(now) < 18,"<span></span><p><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/txt_double_0403.png' alt='' /></p>","")
		Case "2018-04-04"
			doubletime = chkiif(hour(now) < 20,"<span></span><p><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/txt_double_0404.png' alt='' /></p>","")
		Case "2018-04-05"
			doubletime = chkiif(hour(now) < 13,"<span></span><p><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/txt_double_0405.png' alt='' /></p>","")
		Case "2018-04-06"
			doubletime = chkiif(hour(now) < 11,"<span></span><p><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/txt_double_0406.png' alt='' /></p>","")
		Case "2018-04-07"
			doubletime = chkiif(hour(now) < 16,"<span></span><p><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/txt_double_0407.png' alt='' /></p>","")
		Case "2018-04-08"
			doubletime = chkiif(hour(now) < 11,"<span></span><p><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/txt_double_0408.png' alt='' /></p>","")
		Case "2018-04-09"
			doubletime = chkiif(hour(now) < 20,"<span></span><p><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/txt_double_0409.png?v=1' alt='' /></p>","")
		Case "2018-04-10"
			doubletime = chkiif(hour(now) < 16,"<span></span><p><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/txt_double_0410.png?v=1' alt='' /></p>","")
		Case "2018-04-11"
			doubletime = chkiif(hour(now) < 20,"<span></span><p><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/txt_double_0411.png?v=1' alt='' /></p>","")
		Case "2018-04-12"
			doubletime = chkiif(hour(now) < 17,"<span></span><p><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/txt_double_0412.png?v=1' alt='' /></p>","")
		Case "2018-04-13"
			doubletime = chkiif(hour(now) < 19,"<span></span><p><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/txt_double_0413.png?v=1' alt='' /></p>","")
		Case "2018-04-14"
			doubletime = chkiif(hour(now) < 13,"<span></span><p><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/txt_double_0414.png?v=1' alt='' /></p>","")
		Case "2018-04-15"
			doubletime = chkiif(hour(now) < 16,"<span></span><p><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/txt_double_0415.png?v=1' alt='' /></p>","")
		Case "2018-04-16"
			doubletime = chkiif(hour(now) < 19,"<span></span><p><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/txt_double_0416.png?v=1' alt='' /></p>","")
		Case Else
			doubletime = chkiif(hour(now) < 14,"<span></span><p><img src='http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/txt_double_0402.png' alt='' /></p>","")
	end Select
End Function

'// 당첨 여부
Function statewinlose(v)
	Select Case CStr(v)
		Case "2018-04-02"
			statewinlose = chkiif(win1<>"",true,false)
		Case "2018-04-03"
			statewinlose = chkiif(win2<>"",true,false)
		Case "2018-04-04"
			statewinlose = chkiif(win3<>"",true,false)
		Case "2018-04-05"
			statewinlose = chkiif(win4<>"",true,false)
		Case "2018-04-06"
			statewinlose = chkiif(win5<>"",true,false)
		Case "2018-04-07"
			statewinlose = chkiif(win6<>"",true,false)
		Case "2018-04-08"
			statewinlose = chkiif(win7<>"",true,false)
		Case "2018-04-09"
			statewinlose = chkiif(win8<>"",true,false)
		Case "2018-04-10"
			statewinlose = chkiif(win9<>"",true,false)
		Case "2018-04-11"
			statewinlose = chkiif(win10<>"",true,false)
		Case "2018-04-12"
			statewinlose = chkiif(win11<>"",true,false)
		Case "2018-04-13"
			statewinlose = chkiif(win12<>"",true,false)
		Case "2018-04-14"
			statewinlose = chkiif(win13<>"",true,false)
		Case "2018-04-15"
			statewinlose = chkiif(win14<>"",true,false)
		Case "2018-04-16"
			statewinlose = chkiif(win15<>"",true,false)
		Case Else
			statewinlose = chkiif(win1<>"",true,false)
	end Select
End function										


'// 스와이퍼
Dim tempdate
tempdate = datediff("d","2018-04-16",Date()) + 13
If tempdate > 13 Then tempdate = 0
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.miracle {position:relative; background:#2b3fae;}
.miracle button {background:transparent;}
.challenge {position:relative; padding-bottom:4.27rem;}
.challenge .btn-group {width:63%; margin:0 auto;}
.challenge .btn-group button {display:block; margin-bottom:0.85rem;}
.challenge .double {position:absolute; right:4.6%; top:2.7rem; width:33.6%;}
.challenge .double span {display:block; position:absolute; left:0; top:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/bg_line.png) 0 0 no-repeat; background-size:100% 100%; animation:move1 1.2s 30 cubic-bezier(1,.1,.7,.46);}
.share {position:relative;}
.share a {display:block; position:absolute; right:9%; top:14.5%; width:20%; height:35%; text-indent:-999em;}
.share a.btn-fb {top:51.5%;}
.winner {padding-bottom:4.27rem; background:#ffcae5;}
.winner .swiper-slide {width:11.78rem; padding:0 0.7rem; text-align:center;}
.winner .swiper-slide:first-child {margin-left:1.62rem;}
.winner .swiper-slide:last-child {margin-right:1.62rem;}
.winner .swiper-slide .item div {background:url(http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/bg_next.png) 0 0 no-repeat; background-size:100% 100%;}
.winner .swiper-slide .item div img {opacity:0;}
.winner .swiper-slide .item p {width:4.27rem; height:1.71rem; margin:1.2rem auto 0.5rem; color:#fff; font-size:1rem; line-height:1.8rem; font-weight:600; background:#d285ac; border-radius:1rem;}
.winner .swiper-slide .item strong {font-size:1.28rem; line-height:1.6rem; color:#d285ac;}
.winner .swiper-slide .name {display:none; padding-top:0.7rem; font-size:1.02rem; font-weight:600; color:#2b3fae;}
.winner .swiper-slide.finish .item div img {opacity:1;}
.winner .swiper-slide.finish .item p {background:#ff71df;}
.winner .swiper-slide.finish .item strong {color:#000a43;}
.winner .swiper-slide.finish .name {display:block;}
.noti {background:#131a43;}
.noti ul {padding:0 6% 4.1rem;}
.noti li {padding:1rem 0 0 0.65rem; color:#fff; font-size:rem; line-height:1.45rem; text-indent:-0.65rem;}
.noti li:first-child {padding-top:0;}

.layer-popup {display:none; position:absolute; left:0; top:0; z-index:9997; width:100%; height:100%; /*background:rgba(0,0,0,.6);*/}
.layer-popup .layer {overflow:hidden; position:absolute; left:7%; top:0; z-index:99999; width:86%; background:#f4f3f8; border-radius:1.3rem;}
.layer-popup .layer .btn-close {position:absolute; right:0; top:0; width:16%;}
.layer-popup .mask {display:block; position:absolute; left:0; top:0; z-index:9998; width:100%; height:100%; background:rgba(0,0,0,.6);}

#lyrResult .layer {top:5rem; padding-bottom:3.5rem;}
#lyrResult .layer .code {padding-top:1.28rem; text-align:center; color:#b1b1b1; font-size:0.85rem;}
#lyrSch .layer {top:2rem;}
#lyrSch .list {position:relative;}
#lyrSch .list ul {overflow:hidden; position:absolute; left:2%; top:0; width:96%; height:90%;}
#lyrSch .list li {float:left; width:33.33333%; height:100%;}
#lyrSch .list li a {display:block; width:100%; height:100%; text-indent:-999em;}
#lyrSch .list li span {display:block; text-indent:-999em;}
#lyrSch .scroll {overflow-y:scroll; height:35rem; -webkit-overflow-scrolling:touch;}

.tenq-navigation {background-color:#fff;}
.tenq-navigation li {padding-top:0.85rem;}
.tenq-navigation li:first-child {padding-top:0;}

@keyframes move1 {
	from {transform:rotate(0);}
	to {transform:rotate(360deg);}
}
</style>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script style="text/javascript">
$(function(){
	// 지난당첨자
	winnerSwiper = new Swiper('.winner .swiper-container',{
		speed:700,
		freeMode:true,
		initialSlide : "<%=tempdate%>",
		slidesPerView:'auto'
	});

	// 일정보기
	$('.btn-schedule').click(function(){
		$('#lyrSch').fadeIn();
		window.parent.$('html,body').animate({scrollTop:$('#lyrSch').offset().top}, 800);
	});
	// 레이어닫기
	$('.layer-popup .btn-close').click(function(){
		$('.layer-popup').fadeOut();
	});
	$('.layer-popup .mask').click(function(){
		$('.layer-popup').fadeOut();
	});
});

// gogogo
function checkmyprize(){
	<% If Not(IsUserLoginOK) Then %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% else %>
		<% If Now() > #03/25/2018 23:59:59# And Now() < #04/16/2018 23:59:59# Then '테스트용 %>
		<%' If Now() > #04/01/2018 23:59:59# And Now() < #04/16/2018 23:59:59# Then %>
			$.ajax({
				type:"GET",
				url:"/event/tenq/miracle_proc.asp",
				data: "mode=add",
				dataType: "text",
				async:false,
				cache:true,
				success : function(Data, textStatus, jqXHR){
					if (jqXHR.readyState == 4) {
						if (jqXHR.status == 200) {
							//console.log(Data);
							if(Data!="") {
								var str;
								for(var i in Data){
									 if(Data.hasOwnProperty(i)){
										str += Data[i];
									}
								}
								str = str.replace("undefined","");
								res = str.split("|");
								//console.log(res[1]);
								if (res[0]=="OK"){
									$("#resulthtml").empty().html(res[1]);
									$('#lyrResult').fadeIn();
									window.parent.$('html,body').animate({scrollTop:$('#lyrResult').offset().top}, 800);
									return false;
								} else {
									errorMsg = res[1].replace(">?n", "\n");
									alert(errorMsg);
									document.location.reload();
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
					document.location.reload();
					return false;
				}
			});
		<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;				
		<% End If %>
	<% End If %>
}

function sharesns(snsnum) {
	<% If vUserID = "" Then %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End If %>
	<% If vUserID <> "" Then %>
		var reStr;
		var str = $.ajax({
			type: "GET",
			url:"/event/tenq/miracle_proc.asp",
			data: "mode=snschk&snsnum="+snsnum,
			dataType: "text",
			async: false
		}).responseText;
			reStr = str.split("|");
			if(reStr[1] == "tw") {
				popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');
			}else if(reStr[1]=="fb"){
				<% if isapp then %>
				fnAPPShareSNS('fb','<%=replace(appfblink,"m.10x10.co.kr/","m.10x10.co.kr/apps/appcom/wish/web2014/")%>');
				<% else %>
				popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
				<% end if %>
			}else if(reStr[1]=="pt"){
				popSNSPost('pt','<%=snpTitle%>','<%=snpLink%>','','<%=snpImg%>');
			}else if(reStr[1]=="ka"){
				<% if isapp then %>
				fnAPPshareKakao('etc','<%=kakaotitle%>\n<%=kakaodescription%>','<%=kakaolink_url%>','<%=kakaolink_url%>','<%="url="&kakaolink_url%>','<%=kakaoimage%>','','','','');
				<% else %>
				event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaolink_url%>' );
				<% end if %>
				return false;
			}else if(reStr[1] == "none"){
				alert('참여 이력이 없습니다.\n응모후 이용 하세요');
				return false;
			}else if(reStr[1] == "end"){
				alert('공유는 하루에 1회만 가능합니다.');
				return false;
			}else{
				alert('오류가 발생했습니다.');
				return false;
			}
	<% End If %>
}


function goDirOrdItem(tm){
<% If IsUserLoginOK() Then %>
	<%' If Now() > #03/25/2018 23:59:59# And Now() < #04/16/2018 23:59:59# Then '테스트용 %>
	<% If Now() > #04/01/2018 23:59:59# And Now() < #04/16/2018 23:59:59# Then %>
		$("#itemid").val(tm);
		document.directOrd.submit();
	<% else %>
		alert("이벤트 응모 기간이 아닙니다.");
		return;
	<% end if %>
<% Else %>
	if(confirm("로그인을 하셔야 응모할 수 있습니다.")){
		top.location.href="/login/loginpage.asp?vType=G";
		return false;
	}
<% End IF %>
}
</script>
</head>
<body>

<%'!-- 텐큐베리감사 : 100원의 기적 --%>
<div class="mEvt85145 tenq miracle">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/tit_miracle_100.png" alt="100원의 기적" /></h2>
	<%'!-- 응모 --%>
	<div class="challenge">
		<%'!-- 오늘의 상품 : 날짜별로 이미지명 바뀜 (0402~0416) --%>
		<div class="today-item">
			<div>
				<%=onoffimg(actdate)%>
			</div>
		</div>
		<%'!-- 당첨확률 2배 : 날짜별로 이미지명 바뀜 (0402~0416) --%>
		<div class="double">
			<%=doubletime(actdate)%>
		</div>

		<div class="btn-group">
			<% If statewinlose(actdate) Then %>
			<button class="btn-soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/btn_soldout.png" alt="오늘의 당첨자가 나왔습니다" /></button>									
			<% Else %>
			<button class="btn-submit" onclick="checkmyprize();"><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/btn_miracle.png" alt="기적에 도전하기" /></button>
			<% End If %>
			<button class="btn-schedule"><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/btn_schedule.png" alt="일정 보기" /></button>
		</div>
	</div>

	<%'!-- 응모결과 레이어 --%>
	<div id="lyrResult" class="layer-popup" style="display:none;">
		<div class="layer">
			<div id="resulthtml"></div>
			<button type="button" class="btn-close"><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/btn_close.png" alt="닫기" /></button>
		</div>
		<div class="mask"></div>
	</div>

	<%'!-- 일정 보기 레이어 --%>
	<div id="lyrSch" class="layer-popup">
		<div class="layer">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/tit_schedule.png" alt="100원의 기적 상품 일정표" /></h3>
			<div class="scroll">
				<div class="list">
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/item_list_1.png?v=1" alt="" /></div>
					<ul>
						<li>
							<a class="mWeb" href="/category/category_itemPrd.asp?itemid=1913823&pEtr=85145">LG그램 13인치</a>
							<a class="mApp" href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1913823&pEtr=85145" onclick="fnAPPpopupProduct('1913823&amp;pEtr=85145');return false;">LG그램 13인치</a>
						</li>
						<li>
							<a class="mWeb" href="/category/category_itemPrd.asp?itemid=1865049&pEtr=85145">닌텐도 스위치 본체</a>
							<a class="mApp" href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1865049&pEtr=85145" onclick="fnAPPpopupProduct('1865049&amp;pEtr=85145');return false;">닌텐도 스위치 본체</a>
						</li>
						<li><span>아이폰 X</span></li>
					</ul>
				</div>
				<div class="list">
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/item_list_2.png" alt="" /></div>
					<ul>
						<li>
							<a class="mWeb" href="/category/category_itemPrd.asp?itemid=1675624&pEtr=85145">브리츠 멀티플레이어</a>
							<a class="mApp" href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1675624&pEtr=85145" onclick="fnAPPpopupProduct('1675624&amp;pEtr=85145');return false;">브리츠 멀티플레이어</a>
						</li>
						<li>
							<a class="mWeb" href="/category/category_itemPrd.asp?itemid=1551196&pEtr=85145">소니 미러리스 A6000L</a>
							<a class="mApp" href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1551196&pEtr=85145" onclick="fnAPPpopupProduct('1551196&amp;pEtr=85145');return false;">소니 미러리스 A6000L</a>
						</li>
						<li>
							<a class="mWeb" href="/category/category_itemPrd.asp?itemid=1844676&pEtr=85145">다이슨 헤어드라이어</a>
							<a class="mApp" href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1844676&pEtr=85145" onclick="fnAPPpopupProduct('1844676&amp;pEtr=85145');return false;">다이슨 헤어드라이어</a>
						</li>
					</ul>
				</div>
				<div class="list">
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/item_list_3.png" alt="" /></div>
					<ul>
						<li>
							<a class="mWeb" href="/category/category_itemPrd.asp?itemid=1191473&pEtr=85145">발뮤다 공기청정기</a>
							<a class="mApp" href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1191473&pEtr=85145" onclick="fnAPPpopupProduct('1191473&amp;pEtr=85145');return false;">발뮤다 공기청정기</a>
						</li>
						<li><span>아이패드 Pro 10.5</span></li>
						<li>
							<a class="mWeb" href="/category/category_itemPrd.asp?itemid=884073&pEtr=85145">미스터 마리아 미피 램프S</a>
							<a class="mApp" href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=884073&pEtr=85145" onclick="fnAPPpopupProduct('884073&amp;pEtr=85145');return false;">미스터 마리아 미피 램프S</a>
						</li>
					</ul>
				</div>
				<div class="list">
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/item_list_4.png" alt="" /></div>
					<ul>
						<li>
							<a class="mWeb" href="/category/category_itemPrd.asp?itemid=1918634&pEtr=85145">다이슨 V10 앱솔루트</a>
							<a class="mApp" href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1918634&pEtr=85145" onclick="fnAPPpopupProduct('1918634&amp;pEtr=85145');return false;">다이슨 V10 앱솔루트</a>
						</li>
						<li>
							<a class="mWeb" href="/category/category_itemPrd.asp?itemid=1740531&pEtr=85145">드롱기 커피머신</a>
							<a class="mApp" href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1740531&pEtr=85145" onclick="fnAPPpopupProduct('1740531&amp;pEtr=85145');return false;">드롱기 커피머신</a>
						</li>
						<li>
							<a class="mWeb" href="/category/category_itemPrd.asp?itemid=1710848&pEtr=85145">발뮤다 더 팟 전기주전자</a>
							<a class="mApp" href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1710848&pEtr=85145" onclick="fnAPPpopupProduct('1710848&amp;pEtr=85145');return false;">발뮤다 더 팟 전기주전자</a>
						</li>
					</ul>
				</div>
				<div class="list">
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/item_list_5.png" alt="" /></div>
					<ul>
						<li>
							<a class="mWeb" href="/category/category_itemPrd.asp?itemid=1404033&pEtr=85145">폴라로이드 즉석 카메라</a>
							<a class="mApp" href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1404033&pEtr=85145" onclick="fnAPPpopupProduct('1404033&amp;pEtr=85145');return false;">폴라로이드 즉석 카메라</a>
						</li>
						<li>
							<a class="mWeb" href="/category/category_itemPrd.asp?itemid=1485011&pEtr=85145">포켓 빔프로젝터</a>
							<a class="mApp" href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1485011&pEtr=85145" onclick="fnAPPpopupProduct('1485011&amp;pEtr=85145');return false;">포켓 빔프로젝터</a>
						</li>
						<li>
							<a class="mWeb" href="/category/category_itemPrd.asp?itemid=1404416&pEtr=85145">발뮤다 더 토스터</a>
							<a class="mApp" href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1404416&pEtr=85145" onclick="fnAPPpopupProduct('1404416&amp;pEtr=85145');return false;">발뮤다 더 토스터</a>
						</li>
					</ul>
				</div>
			</div>
			<button type="button" class="btn-close"><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/btn_close.png" alt="닫기" /></button>
		</div>
		<div class="mask"></div>
	</div>

	<%'!-- SNS공유 --%>
	<div class="share" id="moreshare" style="display:<%=chkiif(myevtdaycnt = 1 ,"","none")%>;">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/txt_share.png" alt="다시 응모하고 싶을 땐, 친구찬스!" /></p>
		<a href="" onclick="sharesns('ka');return false;" class="btn-kakao">카카오톡으로 공유하기</a>
		<a href="" onclick="sharesns('fb');return false;" class="btn-fb">페이스북으로 공유하기</a>
	</div>

	<%'!-- 지난 당첨자 --%>
	<div class="winner">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/tit_winner.png" alt="지난 당첨자를 소개합니다" /></h3>
		<div class="list">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<%'!-- for dev msg : 당첨자 발표 후에는 클래스 finish 붙여주세요 --%>
					<div class="swiper-slide date0402<%=chkiif(win1<>""," finish","")%>">
						<div class="item">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/winner_0402.jpg" alt="" /></div>
							<p>04.02</p>
							<strong>LG그램<br />13인치</strong>
						</div>
						<%=chkiif(win1<>"","<p class='name'>"& printUserId(win1,2,"*") &"</p>","")%>
					</div>
					<div class="swiper-slide date0403<%=chkiif(win2<>""," finish","")%>">
						<div class="item">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/winner_0403.jpg" alt="" /></div>
							<p>04.03</p>
							<strong>닌텐도<br />스위치 본체</strong>
						</div>
						<%=chkiif(win2<>"","<p class='name'>"& printUserId(win2,2,"*") &"</p>","")%>
					</div>
					<div class="swiper-slide date0404<%=chkiif(win3<>""," finish","")%>">
						<div class="item">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/winner_0404.jpg" alt="" /></div>
							<p>04.04</p>
							<strong>아이폰x<br />256G</strong>
						</div>
						<%=chkiif(win3<>"","<p class='name'>"& printUserId(win3,2,"*") &"</p>","")%>
					</div>
					<div class="swiper-slide date0405<%=chkiif(win4<>""," finish","")%>">
						<div class="item">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/winner_0405.jpg" alt="" /></div>
							<p>04.05</p>
							<strong>브리츠<br />멀티플레이어</strong>
						</div>
						<%=chkiif(win4<>"","<p class='name'>"& printUserId(win4,2,"*") &"</p>","")%>
					</div>
					<div class="swiper-slide date0406<%=chkiif(win5<>""," finish","")%>">
						<div class="item">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/winner_0406.jpg" alt="" /></div>
							<p>04.06</p>
							<strong>소니 미러리스<br />A6000L</strong>
						</div>
						<%=chkiif(win5<>"","<p class='name'>"& printUserId(win5,2,"*") &"</p>","")%>
					</div>
					<div class="swiper-slide date0407<%=chkiif(win6<>""," finish","")%>">
						<div class="item">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/winner_0407.jpg" alt="" /></div>
							<p>04.07</p>
							<strong>다이슨<br />헤어드라이어</strong>
						</div>
						<%=chkiif(win6<>"","<p class='name'>"& printUserId(win6,2,"*") &"</p>","")%>
					</div>
					<div class="swiper-slide date0408<%=chkiif(win7<>""," finish","")%>">
						<div class="item">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/winner_0408.jpg" alt="" /></div>
							<p>04.08</p>
							<strong>발뮤다<br />공기청정기</strong>
						</div>
						<%=chkiif(win7<>"","<p class='name'>"& printUserId(win7,2,"*") &"</p>","")%>
					</div>
					<div class="swiper-slide date0409<%=chkiif(win8<>""," finish","")%>">
						<div class="item">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/winner_0409.jpg" alt="" /></div>
							<p>04.09</p>
							<strong>아이패드<br />Pro 10.5</strong>
						</div>
						<%=chkiif(win8<>"","<p class='name'>"& printUserId(win8,2,"*") &"</p>","")%>
					</div>
					<div class="swiper-slide date0410<%=chkiif(win9<>""," finish","")%>">
						<div class="item">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/winner_0410.jpg" alt="" /></div>
							<p>04.10</p>
							<strong>미스터 마리아<br />미피 램프S</strong>
						</div>
						<%=chkiif(win9<>"","<p class='name'>"& printUserId(win9,2,"*") &"</p>","")%>
					</div>
					<div class="swiper-slide date0411<%=chkiif(win10<>""," finish","")%>">
						<div class="item">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/winner_0411.jpg" alt="" /></div>
							<p>04.11</p>
							<strong>다이슨V10<br />앱솔루트</strong>
						</div>
						<%=chkiif(win10<>"","<p class='name'>"& printUserId(win10,2,"*") &"</p>","")%>
					</div>
					<div class="swiper-slide date0412<%=chkiif(win11<>""," finish","")%>">
						<div class="item">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/winner_0412.jpg" alt="" /></div>
							<p>04.12</p>
							<strong>드롱기<br />커피머신</strong>
						</div>
						<%=chkiif(win11<>"","<p class='name'>"& printUserId(win11,2,"*") &"</p>","")%>
					</div>
					<div class="swiper-slide date0413<%=chkiif(win12<>""," finish","")%>">
						<div class="item">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/winner_0413.jpg" alt="" /></div>
							<p>04.13</p>
							<strong>발뮤다 더 팟<br />전기주전자</strong>
						</div>
						<%=chkiif(win12<>"","<p class='name'>"& printUserId(win12,2,"*") &"</p>","")%>
					</div>
					<div class="swiper-slide date0414<%=chkiif(win13<>""," finish","")%>">
						<div class="item">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/winner_0414.jpg" alt="" /></div>
							<p>04.14</p>
							<strong>폴라로이드<br />즉석 카메라</strong>
						</div>
						<%=chkiif(win13<>"","<p class='name'>"& printUserId(win13,2,"*") &"</p>","")%>
					</div>
					
					<div class="swiper-slide date0415<%=chkiif(win14<>""," finish","")%>">
						<div class="item">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/winner_0415.jpg" alt="" /></div>
							<p>04.15</p>
							<strong>포켓<br />빔프로젝터</strong>
						</div>
						<%=chkiif(win14<>"","<p class='name'>"& printUserId(win14,2,"*") &"</p>","")%>
					</div>
					<div class="swiper-slide date0416<%=chkiif(win15<>""," finish","")%>">
						<div class="item">
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/winner_0416.jpg" alt="" /></div>
							<p>04.16</p>
							<strong>발뮤다<br />더 토스터</strong>
						</div>
						<%=chkiif(win15<>"","<p class='name'>"& printUserId(win15,2,"*") &"</p>","")%>
					</div>
				</div>
			</div>
		</div>
	</div>

	<%'!-- 유의사항 --%>
	<div class="noti">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/tit_noti.png" alt="유의사항" /></h3>
		<ul>
			<li>- 100원의 기적은 매일 다른 상품(총 15개)으로 새롭게 구성됩니다.</li>
			<li>- 구매자에게는 상품에 따라 세무신고에 필요한 개인정보를 요청할 수 있습니다. 제세공과금은 텐바이텐 부담입니다.</li>
			<li>- 본 이벤트의 상품은 즉시 결제로만 구매할 수 있으며 배송 후 반품/교환/구매취소가 불가능합니다.<br />하루에 ID 당 1회 응모만 가능하며 친구 초대 시, 한 번 더 응모 기회가 주어집니다.</li>
			<li>- 무료배송쿠폰은 ID 당 하루에 최대 2회까지 발행되며 발급 당일 자정 기준으로 자동 소멸합니다.<br />(1만 원 이상 구매 시, 텐바이텐 배송상품만 사용 가능)</li>
		</ul>
	</div>

	<div class="tenq-navigation">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/m/txt_event.png" alt="이벤트 더보기" /></h3>
		<ul>
			<li><a href="<%=chkiif(isapp="1","/apps/appcom/wish/web2014/event/","/event/")%>eventmain.asp?eventid=85144"><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/m/bnr_main.png" alt="텐큐베리감사 다양한 혜택의 쿠폰받기" /></a></li>
			<li><a href="<%=chkiif(isapp="1","/apps/appcom/wish/web2014/event/","/event/")%>eventmain.asp?eventid=85146"><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/m/bnr_mileage.png" alt="매일리지에 도전하라" /></a></li>
			<li><a href="<%=chkiif(isapp="1","/apps/appcom/wish/web2014/event/","/event/")%>eventmain.asp?eventid=85148"><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/m/bnr_giftcard.png" alt="텐배사고 선물받자" /></a></li>
		</ul>
	</div>
</div>
<%'!--// 텐큐베리감사 : 100원의 기적 --%>
<% if isapp then %>
	<form method="post" name="directOrd" action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp">
		<input type="hidden" name="itemid" id="itemid" value="">
		<input type="hidden" name="itemoption" value="0000">
		<input type="hidden" name="itemea" readonly value="1">
		<input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
		<input type="hidden" name="isPresentItem" value="" />
	    <input type="hidden" name="mode" value="DO3">
	</form>
<% else %>
	<form method="post" name="directOrd" action="/inipay/shoppingbag_process.asp">
		<input type="hidden" name="itemid" id="itemid" value="">
		<input type="hidden" name="itemoption" value="0000">
		<input type="hidden" name="itemea" readonly value="1">
		<input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
		<input type="hidden" name="isPresentItem" value="" />
		<input type="hidden" name="mode" value="DO1">
	</form>
<% end if %>
<!-- #include virtual="/lib/db/dbclose.asp" -->