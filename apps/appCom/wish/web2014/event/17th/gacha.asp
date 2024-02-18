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
' Description : [텐바이텐 17주년] - 100원으로 인생역전!
' History : 2018-09-19 이종화
'####################################################

Dim eCode : eCode = "89305"
Dim actdate : actdate = Date()

'actdate = "2018-10-10"

if isapp = 0 then
 	response.redirect("/event/eventmain.asp?eventid=89309")
end if 

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg , appfblink
snpTitle	= Server.URLEncode("[텐바이텐 17주년] - 100원으로 인생역전!")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=89309")
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/eventIMG/2018/89308/etcitemban20180917180913.JPEG")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid=89309"

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐 17주년]\n100원으로 인생역전!"
Dim kakaodescription : kakaodescription = "엄청난 상품들을 100원에 구매할 수 있는 기회가 당신을 기다립니다.\n\n 10/10~31 , 총 10 가지의 새로운 상품을 얻을 수 있는 100원으로 인생역전에 도전 해보세요!"
Dim kakaooldver : kakaooldver = "[텐바이텐 17주년]\n100원으로 인생역전!\n\n엄청난 상품들을 100원에 구매할 수 있는 기회가 당신을 기다립니다.\n\n 10/10~31 , 총 10 가지의 새로운 상품을 얻을 수 있는 100원으로 인생역전에 도전 해보세요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2018/89308/etcitemban20180917180913.JPEG"
Dim kakaolink_url 
If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=89305"
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid=89309"
End If

Dim vUserID
vUserID		= GetEncLoginUserID

'#################################################################################################
'// 당첨자 리스트
'#################################################################################################
Dim sqlStr
Dim win1 , win2 , win3 , win4 , win5 , win6 , win7 , win8 , win9 , win10
sqlStr = ""
sqlStr = sqlStr & " SELECT isnull([2018-10-10],'') as win1 , isnull([2018-10-11],'') as win2 , isnull([2018-10-15],'') as win3 , isnull([2018-10-16],'') as win4 , isnull([2018-10-18],'') as win5 , isnull([2018-10-22],'') as win6 , isnull([2018-10-23],'') as win7 , isnull([2018-10-25],'') as win8 , isnull([2018-10-29],'') as win9 , isnull([2018-10-31],'') as win10 " & vbCrlf
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
sqlStr = sqlStr & " 	FOR rgt IN ([2018-10-10] , [2018-10-11] , [2018-10-15] , [2018-10-16] , [2018-10-18] , [2018-10-22] ,[2018-10-23] ,[2018-10-25] ,[2018-10-29] , [2018-10-31]) " & vbCrlf
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
End If
rsget.close
'#################################################################################################
'// 상품 당첨 여부 onoff
Function onoffimg(v)
	Select Case CStr(v)
		Case "2018-10-10"
			onoffimg = chkiif(win1<>"","<img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/today_soldout_1010.jpg?v=1.0' alt='' />","<img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/today_1010.jpg?v=1.0' alt='' />")
		Case "2018-10-11"
			onoffimg = chkiif(win2<>"","<img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/today_soldout_1011.jpg?v=1.0' alt='' />","<img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/today_1011.jpg?v=1.0' alt='' />")
		Case "2018-10-12" , "2018-10-13" , "2018-10-14" 
			onoffimg = "<img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/today_next_1015.jpg?v=1.0' alt='' />"
		Case "2018-10-15"
			onoffimg = "<a href='' onclick=""fnAPPpopupProduct('1865049');return false;"">" & chkiif(win3<>"","<img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/today_soldout_1015.jpg?v=1.0' alt='' /></a>","<img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/today_1015.jpg?v=1.0' alt='' />") & "</a>"
		Case "2018-10-16"
			onoffimg = chkiif(win4<>"","<img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/today_soldout_1016.jpg?v=1.0' alt='' />","<img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/today_1016.jpg?v=1.0' alt='' />")
		Case "2018-10-17" 
			onoffimg = "<img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/today_next_1018.jpg?v=1.0' alt='' />"
		Case "2018-10-18"
			onoffimg = "<a href='' onclick=""fnAPPpopupProduct('1804105');return false;"">" & chkiif(win5<>"","<img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/today_soldout_1018.jpg?v=1.0' alt='' /></a>","<img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/today_1018.jpg?v=1.0' alt='' />") & "</a>"
		Case "2018-10-19" , "2018-10-20" , "2018-10-21" 
			onoffimg = "<img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/today_next_1022.jpg?v=1.0' alt='' />"
		Case "2018-10-22"
			onoffimg = chkiif(win6<>"","<img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/today_soldout_1022.jpg?v=1.0' alt='' />","<img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/today_1022.jpg?v=1.0' alt='' />")
		Case "2018-10-23"
			onoffimg = "<a href='' onclick=""fnAPPpopupProduct('1796388');return false;"">" & chkiif(win7<>"","<img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/today_soldout_1023.jpg?v=1.0' alt='' /></a>","<img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/today_1023.jpg?v=1.0' alt='' />") & "</a>"
		Case "2018-10-24"
			onoffimg = "<img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/today_next_1025.jpg?v=1.0' alt='' />"
		Case "2018-10-25"
			onoffimg = "<a href='' onclick=""fnAPPpopupProduct('2056598');return false;"">" & chkiif(win8<>"","<img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/today_soldout_1025.jpg?v=1.0' alt='' /></a>","<img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/today_1025.jpg?v=1.0' alt='' />") & "</a>"
		Case "2018-10-26" , "2018-10-27" , "2018-10-28" 
			onoffimg = "<img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/today_next_1029.jpg?v=1.0' alt='' />"
		Case "2018-10-29"
			onoffimg = "<a href='' onclick=""fnAPPpopupProduct('1596055');return false;"">" & chkiif(win9<>"","<img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/today_soldout_1029.jpg?v=1.0' alt='' />","<img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/today_1029.jpg?v=1.0' alt='' />") & "</a>"
		Case "2018-10-30"
			onoffimg = "<img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/today_next_1031.jpg?v=1.0' alt='' />"
		Case "2018-10-31"
			onoffimg = "<a href='' onclick=""fnAPPpopupProduct('1555093');return false;"">" & chkiif(win10<>"","<img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/today_soldout_1031.jpg?v=1.0' alt='' />","<img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/today_1031.jpg?v=1.0' alt='' />") & "</a>"
		Case Else
			onoffimg = "<img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/today_next_1010.jpg?v=1.0' alt='' />"

	end Select
End function

'// 2배배너 노출 시간
Function doubletime(v)
	Select Case CStr(v)
		Case "2018-10-10"
			doubletime = chkiif(hour(now) < 18,"<p><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/txt_double_1010.png?v=1.0' alt='' /></p><span></span>","")
		Case "2018-10-11"
			doubletime = chkiif(hour(now) < 21,"<p><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/txt_double_1011.png?v=1.0' alt='' /></p><span></span>","")
		Case "2018-10-12" , "2018-10-13" , "2018-10-14"
			doubletime = "<p><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/txt_next_1011.png' alt='' /></p><span></span>"
		Case "2018-10-15"
			doubletime = chkiif(hour(now) < 19,"<p><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/txt_double_1015.png?v=1.0' alt='' /></p><span></span>","")
		Case "2018-10-16"
			doubletime = chkiif(hour(now) < 20,"<p><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/txt_double_1016.png?v=1.0' alt='' /></p><span></span>","")
		Case "2018-10-17" 
			doubletime = "<p><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/txt_next_1016.png' alt='' /></p><span></span>"
		Case "2018-10-18"
			doubletime = chkiif(hour(now) < 17,"<p><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/txt_double_1018.png?v=1.0' alt='' /></p><span></span>","")
		Case "2018-10-19" , "2018-10-20" , "2018-10-21" 
			doubletime = "<p><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/txt_next_1018.png' alt='' /></p><span></span>"
		Case "2018-10-22"
			doubletime = chkiif(hour(now) < 21,"<p><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/txt_double_1022.png?v=1.0' alt='' /></p><span></span>","")
		Case "2018-10-23"
			doubletime = chkiif(hour(now) < 20,"<p><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/txt_double_1023.png?v=1.0' alt='' /></p><span></span>","")
		Case "2018-10-24"
			doubletime = "<p><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/txt_next_1023.png?v=1.1' alt='' /></p><span></span>"
		Case "2018-10-25"
			doubletime = chkiif(hour(now) < 18,"<p><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/txt_double_1025.png?v=1.0' alt='' /></p><span></span>","")
		Case "2018-10-26" , "2018-10-27" , "2018-10-28" 
			doubletime = "<p><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/txt_next_1025.png?v=1.1' alt='' /></p><span></span>"
		Case "2018-10-29"
			doubletime = chkiif(hour(now) < 19,"<p><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/txt_double_1029.png?v=1.0' alt='' /></p><span></span>","")
		Case "2018-10-30"
			doubletime = "<p><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/txt_next_1029.png?v=1.1' alt='' /></p><span></span>"
		Case "2018-10-31"
			doubletime = chkiif(hour(now) < 18,"<p><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/txt_double_1031.png?v=1.0' alt='' /></p><span></span>","")
		Case Else
			doubletime = "<p><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/txt_next_1010.png?v=1.1' alt='' /></p><span></span>"
	end Select
End Function

'// 당첨 여부
Function statewinlose(v)
	Select Case CStr(v)
		Case "2018-10-10"
			statewinlose = chkiif(win1<>"",true,false)
		Case "2018-10-11"
			statewinlose = chkiif(win2<>"",true,false)
		Case "2018-10-15"
			statewinlose = chkiif(win3<>"",true,false)
		Case "2018-10-16"
			statewinlose = chkiif(win4<>"",true,false)
		Case "2018-10-18"
			statewinlose = chkiif(win5<>"",true,false)
		Case "2018-10-22"
			statewinlose = chkiif(win6<>"",true,false)
		Case "2018-10-23"
			statewinlose = chkiif(win7<>"",true,false)
		Case "2018-10-25"
			statewinlose = chkiif(win8<>"",true,false)
		Case "2018-10-29"
			statewinlose = chkiif(win9<>"",true,false)
		Case "2018-10-31"
			statewinlose = chkiif(win10<>"",true,false)
		Case Else
			statewinlose = false
	end Select
End function

'// 일자별 버튼 구분 응모가능날 , 가능하지 않은날
function noplay(v)
	Select Case CStr(v)
		Case "2018-10-10" , "2018-10-11" , "2018-10-15" , "2018-10-16" , "2018-10-18" , "2018-10-22" , "2018-10-23" , "2018-10-25" , "2018-10-29" , "2018-10-31"
			noplay = "<button class='btn-submit' onclick='checkmyprize();'><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/btn_submit.png' alt='응모하기' /></button>"
		Case "2018-10-12" , "2018-10-13" , "2018-10-14" , "2018-10-17" , "2018-10-19" , "2018-10-20" , "2018-10-21" , "2018-10-22" 
			noplay = "<span><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/btn_no_event.png' alt='COMING SOON' /></span>"
		Case "2018-10-24"
			noplay = "<span class=""no-evt""><img src=""http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/no_event_1023.png"" alt=""10월 25일을 기대해주세요!"" /></span>"
		Case "2018-10-26" , "2018-10-27" , "2018-10-28"
			noplay = "<span class=""no-evt""><img src=""http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/no_event_1025.png"" alt=""10월 29일을 기대해주세요!"" /></span>"
		Case "2018-10-30"
			noplay = "<span class=""no-evt""><img src=""http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/no_event_1029.png"" alt=""10월 31일을 기대해주세요!"" /></span>"
		Case Else
			noplay = "<span><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/btn_event_end.png' alt='이벤트가 종료되었습니다' /></span>"
	end Select
end function

'// 스와이퍼 기준점 
'// 2배배너 노출 시간
Function swiperinit(v)
	Select Case CStr(v)
		Case "2018-10-10"
			swiperinit = 0
		Case "2018-10-11"
			swiperinit = 1
		Case "2018-10-12" , "2018-10-13" , "2018-10-14"
			swiperinit = 1
		Case "2018-10-15"
			swiperinit = 2
		Case "2018-10-16"
			swiperinit = 3
		Case "2018-10-17" 
			swiperinit = 3
		Case "2018-10-18"
			swiperinit = 4
		Case "2018-10-19" , "2018-10-20" , "2018-10-21" 
			swiperinit = 4
		Case "2018-10-22"
			swiperinit = 5
		Case "2018-10-23"
			swiperinit = 6
		Case "2018-10-24"
			swiperinit = 6
		Case "2018-10-25"
			swiperinit = 7
		Case "2018-10-26" , "2018-10-27" , "2018-10-28" 
			swiperinit = 7
		Case "2018-10-29"
			swiperinit = 8
		Case "2018-10-30"
			swiperinit = 8
		Case "2018-10-31"
			swiperinit = 9
		Case Else
			swiperinit = 0
	end Select
End Function
%>
<style type="text/css">
/* 공통 */
.sns-share {position:relative; background-color:#4753c9;}
.sns-share ul {display:flex; position:absolute; top:0; right:0; height:100%;justify-content:flex-end; align-items:center; margin-right:2.21rem; }
.sns-share li {width:4.05rem; margin-left:.77rem;}

.lottery-head {position:relative; overflow:hidden;}
.lottery-head span {display:block; position:absolute;}
.lottery-head .star1 {width:4.8%; top:32.5%; left:8.4%; opacity:0; animation:twinkle1 3s 1s 100;}
.lottery-head .star2 {width:8%; top:16%; right:21.47%; opacity:0; animation:twinkle1 3s 2s 100;}
.lottery-head .star3 {width:100%; top:0; left:0; animation:twinkle3 3s 2s infinite;}
@keyframes twinkle1 {0% {opacity:0;} 30%,80% {opacity:1;} 100% {opacity:0;}}
@keyframes twinkle3 {0% {opacity:1;} 30% {opacity:0;} 50% {opacity:1;}}
.challenge {position:relative;}
.challenge .today-item a {display:block;}
.challenge .round {position:absolute; right:4.7%; top:-1.4%; width:31.6%;}
.challenge .round span {display:block; position:absolute; left:0; top:0; width:100%; height:0; padding-top:100%; background:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/bg_line.png) 0 0 no-repeat; background-size:100%; animation:move1 1.2s 30 cubic-bezier(1,.1,.7,.46);}
@keyframes move1 {from {transform:rotate(0);} to {transform:rotate(360deg);}}
.twinkle {position:relative; overflow:hidden;}
.twinkle span {display:block; position:absolute; top:50%; left:50%; width:64%; transform:translate(-50%,-50%);}
/* 참여없는날 문구 수정 - 20181024 */
.challenge .btn-area {position:relative; overflow:hidden;}
.challenge .btn-area button {display:inline-block; background-color:transparent;}
.challenge .btn-area .btns {position:absolute; top:8.3%; left:0; width:100%; text-align:center; animation:shake 1s 50;}
.challenge .btn-area .btn-submit {width:56.5%;}
.challenge .btn-area span {display:inline-block; width:55.5%;}
.challenge .btn-area .no-evt {width:64.13%;}
.challenge .btn-area .btn-schedule {position:absolute; top:33.86%; left:24%; width:33%;}
@keyframes shake {from, to {transform:translateX(-3px); animation-timing-function:ease-out;} 50% {transform:translateX(3px); animation-timing-function:ease-in;}}
.winner {padding-bottom:4.27rem; background:#afedff;}
.winner .swiper-slide {width:12rem; padding:0 1rem; text-align:center;}
.winner .swiper-slide:first-child {margin-left:1.62rem;}
.winner .swiper-slide:last-child {margin-right:1.62rem;}
.winner .swiper-slide .item div {background:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/bg_next.jpg) 0 0 no-repeat; background-size:100%;}
.winner .swiper-slide .item div img {opacity:0;}
.winner .swiper-slide .item p {width:4.27rem; height:1.71rem; margin:1.2rem auto 0.5rem; color:#fff; font-size:1rem; line-height:1.8rem; font-weight:600; font-family:'RobotoRegular'; background:#ed9cca; border-radius:1rem;}
.winner .swiper-slide .item strong {font-family:'AppleSDGothicNeo-Regular'; font-size:1.28rem; line-height:1.6rem; color:#a17dc0; word-break:keep-all;}
.winner .swiper-slide .name {display:none; padding-top:0.7rem; font-size:1.02rem; font-weight:600; font-family:'RobotoRegular'; color:#222;}
.winner .swiper-slide.finish .item div img {opacity:1;}
.winner .swiper-slide.finish .item p {background:#ff3f90;}
.winner .swiper-slide.finish .item strong {color:#6f0bc3;}
.winner .swiper-slide.finish .name {display:block;}
.noti {background:#232341;}
.noti ul {padding:0 9% 4.2rem;}
.noti li {padding:0.5rem 0 0 0.65rem; color:#fff; font-family:'AppleSDGothicNeo-Regular'; font-size:1.06rem; line-height:1.8rem; text-indent:-0.65rem; word-break:keep-all;}
.noti li:first-child {padding-top:0;}
.noti li strong {font-weight:normal; text-decoration:underline;}
.layer-popup {display:none; position:absolute; left:0; top:0; z-index:9997; width:100%; height:100%;}
.layer-popup .layer {overflow:hidden; position:absolute; left:7%; top:0; z-index:99999; width:86%;}
.layer-popup .layer .btn-close {position:absolute; right:0; top:0; width:16%; background:transparent;}
.layer-popup .mask {display:block; position:absolute; left:0; top:0; z-index:9998; width:100%; height:100%; background:rgba(0,0,0,.7);}
#lyrResult .layer {top:11.4rem; left:11%; width:78%;}
#lyrResult h3 {position:absolute; text-indent:-999em;}
#lyrResult .layer .btn-close {top:0.34rem;}
#lyrResult .case1 {position:relative;}
#lyrResult .case1 a {display:block;}
#lyrResult .case1 .code {position:absolute; left:0; bottom:2.3rem; width:100%; padding:0 6%; text-align:center; font-weight:bold; color:#5961ee; letter-spacing:0.1rem; word-break:break-all;}
#lyrResult .case2 {position:relative;}
#lyrResult .case2 a {display:block; position:absolute; top:33.4%; width:26%; padding-top:26%; font-size:0; text-indent:-999em;}
#lyrResult .btn-kakaotalk {left: 23.8%;}
#lyrResult .btn-facebook {left:50.8%;}
#lyrSch .layer {top:10rem; left:6%; width:88%; background:#aff7ff; border:0.3rem solid #0db3e3; border-radius:2rem;}
#lyrSch .list {position:relative;}
#lyrSch .list ul {overflow:hidden; position:absolute; left:2%; top:0; width:96%; height:90%;}
#lyrSch .list li {float:left; width:33.33333%; height:100%;}
#lyrSch .list a {display:block; width:100%; height:100%; text-indent:-999em;}
#lyrSch .list li span {display:block; text-indent:-999em;}
#lyrSch .scroll {overflow-y:scroll; height:33rem; -webkit-overflow-scrolling:touch;}
#lyrSch .layer .btn-close {top:0.5rem; right:0.25rem; width:14.3%;}
</style>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script style="text/javascript">
$(function(){
	// amplitude init
	fnAmplitudeEventMultiPropertiesAction('view_17th_100won_app','','');

	// 지난당첨자
	winnerSwiper = new Swiper('.winner .swiper-container',{
		//loop:true,
		speed:700,
		freeMode:true,
		loopedSlides: 0,
		initialSlide : <%=swiperinit(actdate)%>,
		slidesPerView:'auto'
	});

	// 일정보기
	$('.btn-schedule').click(function(){
		fnAmplitudeEventMultiPropertiesAction('click_17th_100won_schedule','','');
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
	fnAmplitudeEventMultiPropertiesAction('click_17th_100won_action','','');
	<% If Not(IsUserLoginOK) Then %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% else %>
		<%' If Now() > #10/01/2018 00:00:00# And Now() < #10/08/2018 23:59:59# Then '테스트용 %>
		<% If Now() > #10/09/2018 23:59:59# And Now() < #10/31/2018 23:59:59# Then %>
			$.ajax({
				type: "POST",
				url: "/apps/appcom/wish/web2014/event/17th/gacha_proc.asp",
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
	fnAmplitudeEventMultiPropertiesAction('click_17th_100won_sns','','');
	<% If vUserID = "" Then %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% else %>
		var reStr;
		var str = $.ajax({
			type: "POST",
			url:"/event/17th/gacha_proc.asp",
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
	<%' If Now() > #10/01/2018 23:59:59# And Now() < #10/08/2018 23:59:59# Then '테스트용 %>
	<% If Now() > #10/09/2018 23:59:59# And Now() < #10/31/2018 23:59:59# Then %>
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

function itemview(itemid){
	setTimeout(function() {
		fnAmplitudeEventMultiPropertiesAction('click_17th_100won_items', 'itemid', itemid,'' );	
	}, 100);
	fnAPPpopupProduct(itemid);
	return false;
}
</script>
</head>
<body>
<%'!-- 17주년 100원으로 인생역전 --%>
<div class="mEvt88940 lottery">
	<div class="lottery-head">
		<h2><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/tit_lottery_app.jpg" alt="100원으로 인생역전" /></h2>
		<span class="star1"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_star1.png" alt="" /></span>
		<span class="star2"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_star2.png" alt="" /></span>
		<span class="star3"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_star3.png" alt="" /></span>
	</div>
	<%'!-- 응모 --%>
	<div class="challenge">
		<%'!-- 오늘의 상품 : 날짜별로 이미지명 바뀜 (1010~1031) --%>
		<div class="today-item">
			<div>
				<%=onoffimg(actdate)%>
			</div>
		</div>
		<%'!-- 당첨확률 2배 : 날짜별로 이미지명 바뀜 (1010~1031) -- 당첨자가 없을때 노출%>
		<% If not statewinlose(actdate) Then %>
		<div class="round">
			<%=doubletime(actdate)%>
		</div>
		<% end if %>

		<div class="twinkle">
			<p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_neck_app.gif" alt="" /></p>
			<span><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_twinkle.gif" alt="" /></span>
		</div>

		<div class="btn-area">
			<p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_btn_area_app.jpg" alt="뽑기는 무료이며, 상품 당첨 시 100원으로 구매 가능합니다." /></p>
			<div class="btns">
				<% If statewinlose(actdate) Then %>
					<% if actdate = "2018-10-31" then '// 마지막날 당첨자 있을경우%>
						<span><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/btn_event_end.png" alt="이벤트가 종료되었습니다" /></span>
					<% else %>
						<span><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/btn_soldout.png" alt="당첨자가 나왔습니다" /></span>
					<% end if %>
				<% Else %>
					<%=noplay(actdate)%>
				<% End If %>
			</div>
			<button class="btn-schedule"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/btn_schedule.png" alt="일정 보기" /></button>
		</div>
	</div>

	<%'!-- 응모결과 레이어 --%>
	<div id="lyrResult" class="layer-popup" style="display:none;">
		<div class="layer">
			<div id="resulthtml"></div>
			<button type="button" class="btn-close"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/btn_close_2.png" alt="닫기" /></button>
		</div>
		<div class="mask"></div>
	</div>

	<%'!-- 일정 보기 레이어 --%>
	<div id="lyrSch" class="layer-popup">
		<div class="layer">
			<h3><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/tit_schedule.png" alt="100원으로 인생역전 상품 일정표" /></h3>
			<div class="scroll">
				<div class="list">
					<div><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_item_1.png" alt="" /></div>
					<ul>
						<li><span>애플 에어팟</span></li>
						<li><span>아이패드 프로 256GB</span></li>
						<li onclick="itemview('1865049');"><span>닌텐도 스위치</span></li>
					</ul>
				</div>
				<div class="list">
					<div><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_item_2.png?v=1.0" alt="" /></div>
					<ul>
						<li><span>아이폰XS (5.8) 골드 256GB</span></li>
						<li onclick="itemview('1804105');"><span>LG전자 시네빔</span></li>
						<li><span>애플워치 시리즈4</span></li>
					</ul>
				</div>
				<div class="list">
					<div><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_item_3.png" alt="" /></div>
					<ul>
						<li onclick="itemview('1796388');"><span>다이슨 V8 카본 파이버</span></li>
						<li style="color:transparent"><span>치후 360 로봇 청소기</span></li>
						<li onclick="itemview('1596055');"><span>즉석카메라 인화기</span></li>
					</ul>
				</div>
				<div class="list">
					<div><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_item_4.png" alt="" /></div>
					<ul>
						<li></li>
						<li onclick="itemview('1555093');"><span>다이슨 헤어드라이어</span></li>
						<li></li>
					</ul>
				</div>
			</div>
			<button type="button" class="btn-close"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/btn_close.png" alt="닫기" /></button>
		</div>
		<div class="mask"></div>
	</div>

	<%'!-- 지난 당첨자 --%>
	<div class="winner">
		<h3><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/tit_winner.jpg" alt="지난 당첨자를 소개합니다" /></h3>
		<div class="list">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<%'!-- for dev msg : 당첨자 발표 후에는 클래스 finish 붙여주세요 --%>
					<div class="swiper-slide date1010<%=chkiif(win1<>""," finish","")%>">
						<div class="item">
							<div><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_winner_1010.jpg" alt="" /></div>
							<p>10.10</p>
							<strong>애플<br>에어팟</strong>
						</div>
						<%=chkiif(win1<>"","<p class='name'>"& printUserId(win1,2,"*") &"</p>","")%>
					</div>
					<div class="swiper-slide date1011<%=chkiif(win2<>""," finish","")%>">
						<div class="item">
							<div><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_winner_1011.jpg" alt="" /></div>
							<p>10.11</p>
							<strong>아이패드 프로 10.5 256GB</strong>
						</div>
						<%=chkiif(win2<>"","<p class='name'>"& printUserId(win2,2,"*") &"</p>","")%>
					</div>
					<div class="swiper-slide date1015<%=chkiif(win3<>""," finish","")%>">
						<div class="item">
							<div><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_winner_1015.jpg" alt="" /></div>
							<p>10.15</p>
							<strong>닌텐도<br>스위치</strong>
						</div>
						<%=chkiif(win3<>"","<p class='name'>"& printUserId(win3,2,"*") &"</p>","")%>
					</div>
					<div class="swiper-slide date1016<%=chkiif(win4<>""," finish","")%>">
						<div class="item">
							<div><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_winner_1016.jpg" alt="" /></div>
							<p>10.16</p>
							<strong>아이폰 XS(5.8) 골드 256GB</strong>
						</div>
						<%=chkiif(win4<>"","<p class='name'>"& printUserId(win4,2,"*") &"</p>","")%>
					</div>
					<div class="swiper-slide date1018<%=chkiif(win5<>""," finish","")%>">
						<div class="item">
							<div><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_winner_1018.jpg" alt="" /></div>
							<p>10.18</p>
							<strong>LG전자<br>시네빔</strong>
						</div>
						<%=chkiif(win5<>"","<p class='name'>"& printUserId(win5,2,"*") &"</p>","")%>
					</div>
					<div class="swiper-slide date1022<%=chkiif(win6<>""," finish","")%>">
						<div class="item">
							<div><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_winner_1022.jpg" alt="" /></div>
							<p>10.22</p>
							<strong>애플워치<br>시리즈4</strong>
						</div>
						<%=chkiif(win6<>"","<p class='name'>"& printUserId(win6,2,"*") &"</p>","")%>
					</div>
					<div class="swiper-slide date1023<%=chkiif(win7<>""," finish","")%>">
						<div class="item">
							<div><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_winner_1023.jpg" alt="" /></div>
							<p>10.23</p>
							<strong>다이슨 V8<br>카본 파이버</strong>
						</div>
						<%=chkiif(win7<>"","<p class='name'>"& printUserId(win7,2,"*") &"</p>","")%>
					</div>
					<div class="swiper-slide date1025<%=chkiif(win8<>""," finish","")%>">
						<div class="item">
							<div><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_winner_1025.jpg" alt="" /></div>
							<p>10.25</p>
							<strong>치후 360<br>로봇 청소기</strong>
						</div>
						<%=chkiif(win8<>"","<p class='name'>"& printUserId(win8,2,"*") &"</p>","")%>
					</div>
					<div class="swiper-slide date1029<%=chkiif(win9<>""," finish","")%>">
						<div class="item">
							<div><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_winner_1029.jpg" alt="" /></div>
							<p>10.29</p>
							<strong>즉석카메라<br>인화기</strong>
						</div>
						<%=chkiif(win9<>"","<p class='name'>"& printUserId(win9,2,"*") &"</p>","")%>
					</div>
					<div class="swiper-slide date1031<%=chkiif(win10<>""," finish","")%>">
						<div class="item">
							<div><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_winner_1031.jpg" alt="" /></div>
							<p>10.31</p>
							<strong>다이슨 헤어드라이어</strong>
						</div>
						<%=chkiif(win10<>"","<p class='name'>"& printUserId(win10,2,"*") &"</p>","")%>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%'!--// winner --%>

	<%'!-- 유의사항 --%>
	<div class="noti">
		<h3><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/tit_noti.jpg" alt="유의사항" /></h3>
		<ul>
			<li>- &lt;100원으로 인생역전&gt;은 매번 다른 상품으로 구성 됩니다. (총 10개) </li>
			<li>- 당첨자에게는 상품에 따라 세무신고에 필요한 개인정보를 요청할 수 있습니다. (제세공과금은 텐바이텐 부담입니다.)</li>
			<li>- 본 이벤트의 상품은 즉시 결제로만 구매할 수 있으며, 배송 후 반품/교환/구매취소가 불가합니다.</li>
			<li>- 본 이벤트는 ID당 하루에 최대 2회 응모 가능합니다.</li>
			<li>- 본 이벤트는 APP전용 이벤트 입니다.</li>
			<li>- <strong>아이폰XS 5.8형 골드(256GB), 애플워치 시리즈4(40mm)상품은 국내 출시 이후에 배송 될 예정입니다.</strong></li>
		</ul>
	</div>
</div>
		<% If Now() > #10/10/2018 00:00:00# AND Now() < #10/31/2018 23:59:59# Then %>		
			<% if isApp = 1 then %>		
			<a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/17th/');"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_bnr_main.jpg" alt="텐텐 슬기로운 생활 17주년 메인으로 이동" /></a>				
			<% else %>
			<a href="/event/17th/index.asp"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_bnr_main.jpg" alt="텐텐 슬기로운 생활 17주년 메인으로 이동" /></a>				
			<% end if %>				
		<% end if %>
<%'!-- 17주년 100원으로 인생역전 --%>
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