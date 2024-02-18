<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim iscouponeDown, eventCoupons, vQuery, pagereload, snpLink2

pagereload	= requestCheckVar(request("pagereload"),2)
snpLink2 = "http://www.10x10.co.kr/event/17th/index.asp"

IF application("Svr_Info") = "Dev" THEN
	eventCoupons = "21094,21092,21090,21085,21062"	
Else
	eventCoupons = "21621,21620,21619,21618,21617"	
End If

iscouponeDown = false

vQuery = "select count(1) from [db_item].[dbo].[tbl_user_item_coupon] where userid = '" & getencLoginUserid() & "'"
vQuery = vQuery + " and itemcouponidx in ("&eventCoupons&") "
vQuery = vQuery + " and usedyn = 'N' "
rsget.CursorLocation = adUseClient
rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
If rsget(0) = 5 Then	' 
	iscouponeDown = true
End IF
rsget.close
%>
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<style type="text/css">
.body-sub .content, .body-popup .content {padding-bottom:0 !important;}
#gotop {display:none !important;}
.life-main {position:relative; min-height:221rem; background:#6847eb url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/bg_main_full_v9.jpg) no-repeat 0 0; background-size:100%;}
.life-main button {background-color:transparent;}

.dc-group {display:inline-block; position:absolute; top:18.99rem; right:0;}
.dc-group span {display:inline-block; position:absolute; top:0; right:3.66rem; width:3.33rem; height:3.33rem; background:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_star.png) no-repeat 0 0; background-size:100%; color:transparent;}
.dc-group .dc2 {top:.76rem; right:1.92rem;}
.dc-group .dc3 {top:2.34rem; right:.85rem;}

.intro {width:100%; height:221rem; position:absolute; top:0; left:0; z-index:50; background:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/bg_main_full_v9.jpg) no-repeat 0 0; background-size:100%;}
.intro h2 {padding-top:13.06rem;}

.layer {position:absolute; top:0; left:0; z-index:15; width:100vw; height:100vh; background-color:rgba(0,0,0,.55);}
.layer .inner {position:absolute; top:5.86rem; left:50%; width:32rem; margin-left:-16rem;}.layer button {position:absolute; top:15.14rem; left:50%; width:12.28rem; margin-left:-6.14rem;}
.layer-coupon .btn-go {display:inline-block; position:absolute; top:22.7rem; left:50%; width:14.42rem; margin-left:-7.21rem;}
.layer-coupon .btn-close {top:1.6rem; width:1.28rem; margin-left:9.5rem;}

.main-cont {position:relative; padding-top:9.73rem;}
.main-cont h2 {width:12.2rem; position:absolute; top:2.56rem; left:1.7rem; z-index:10;}
.main-cont .btn-wrapper,
.main-cont .btn-wrapper .btn-cmt {display:inline-block; position:absolute; top:4.78rem; right:0;width:8.02rem;}
.main-cont .btn-wrapper .btn-cmt {top:0; z-index:10; }
.main-cont .btn-wrapper i {display:inline-block; position:absolute; top:-3.4rem; right:0; z-index:5; width:7.51rem; height:3.84rem; background:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_cmt_boy_v3.gif) no-repeat 0 0; background-size:100%; content:' ';}
.main-cont .share {position:relative; width:100%; height:7.936rem; padding:0 .85rem 0 1.71rem; background-color:#ff6bda;}
.main-cont .share p {position:absolute; top:50%; left:1.71rem; margin-top:-.77rem; width:10.2rem;}
.main-cont .share ul {display:flex; height:100%; justify-content:flex-end; align-items:center;}
.main-cont .share ul li {width:3.93rem; height:3.93rem; margin-right:.64rem;}

.section {position:relative; overflow:hidden; width:32rem; height:29.01rem !important; margin:0 auto;}
.section .tit {position:absolute; bottom:0; left:0;}

.coupon-slide {right:1.17rem; background:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_planet.png) no-repeat 0 100%; background-size:100%;}
.coupon-slide .txt {position:relative; z-index:13; text-align:center;}
.coupon-slide .txt span {display:inline-block; width:18.22rem;}
.coupon-slide .txt .coupon {position:relative; z-index:5; margin-top:12.03rem}
.coupon-slide .txt .discount {width:13.82rem;}
.coupon-slide .txt .boy {position:absolute; top:2.39rem; left:50%; z-index:3; width:8.23rem; margin-left:-3.72rem;}
.coupon-slide .txt .boy i {position:absolute; top:6.53rem; left:-1.02rem; width:2.6rem;}
.coupon-slide .gage-bar {position:absolute; top:2.88rem; left:50%; width:11.65rem; height:24.11rem; margin-left:4.2rem; background:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_gage_0.png) no-repeat 0 0; background-size:100%;}
.coupon-slide .gage-bar .bg-gage {display:none; width:11.65rem; height:24.11rem; position:absolute; top:0; left:0; background:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_gage_1.png) no-repeat 0 0; background-size:100%;}
.coupon-slide .gage-bar .gage2 {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_gage_2.png);}
.coupon-slide .gage-bar .gage3 {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_gage_3.png);}
.coupon-slide .gage-bar .gage4 {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_gage_4.png);}
.coupon-slide .gage-bar .gage5 {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_gage_5.png);}
.coupon-slide .rocket {display:inline-block; position:absolute; top:1rem; left:1.7rem;  z-index:7; width:6.74rem; height:6.66rem; transform-origin:-5.71rem 11.86rem; transform:rotate(65deg);}
.coupon-slide .btn-coupon {position:absolute; top:19.2rem; left:20.65rem; z-index:10; width:10.62rem; cursor:pointer;}
.coupon-slide .btn-coupon i {display:none; position:absolute; top:-.6rem; right:0; z-index:10; width:6.22rem;}
.coupon-slide .dc-group {top:0; left:0;}
.coupon-slide .dc1 {width:7.46rem; height:7.12rem; top:3.2rem; left:4rem; z-index:5; background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/txt_last_day.png);}
.coupon-slide .dc2 {width:2.6rem; top:5.71rem; left:10.5rem; background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_spark.png);}

.maeileage-slide.maeileage-slide {margin-top:-1.5rem; right:3rem;}
.maeileage-slide.section .tit {margin-bottom:.43rem;}
.maeileage-slide .girl > img {position:relative; z-index:7;}
.maeileage-slide .girl i {position:absolute;  transition:all .6s;}
.maeileage-slide .girl .left {top:26%; left:26.56%; width:22.8%;}
.maeileage-slide .girl .right {top:21%; left:49%; width:29.86%;}
.maeileage-slide .girl .bg-ground {top:0; left:0; width:100%; height:100%;}
.maeileage-slide .dc-group {top:7.6rem;}
.maeileage-slide .dc1 {width:6.1rem; height:5.76rem; top:2.36rem; right:5.38rem; z-index:5; background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_maeil_star_1.png);}
.maeileage-slide .dc4,
.maeileage-slide .dc2 {width:2.21rem; height:2.21rem; top:.43rem; right:4.29rem; background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_maeil_star_2.png);}
.maeileage-slide .dc3 {width:6.528rem; height:1.33rem; top:-.3rem; right:20rem; transform:rotate(-41deg); background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/txt_maeil_1.png);}
.maeileage-slide .dc4 {top:7.43rem; right:2.29rem; width:1rem; height:1rem; transform:rotate(90deg);}
.maeileage-slide .coming {position:absolute; top:1rem; left:6.5rem; width:7.56rem;}

.backwon-slide {margin-top:2.2rem; left:-1.7rem;}
.backwon-slide.section .tit {bottom:1.7rem;}
.backwon-slide .on {height:100%;}
.backwon-slide .machine {z-index:4;}
.backwon-slide .machine i {position:absolute; top:38.38%; right:17.6%; width:10.8%;}
.backwon-slide .machine i.trigger {top:38.82%; right:40.4%; z-index:5; width:6.5%;}
.backwon-slide .machine,
.backwon-slide .children {position:absolute;}
.backwon-slide .children {width:26.4%; top:20.44%; left:22%;}
.backwon-slide .children > img {position:relative; z-index:3;}
.backwon-slide .children i {display:inline-block; position:absolute; top:-5.4%; left:-12%; z-index:2; width:49.49%;}
.backwon-slide .children i.hand1 {transform-origin:5.2rem 5.33rem;}
.backwon-slide .children i.hand2 {top:28.45%; width:59.59%; transform-origin:5.63rem 5.93rem;}
.backwon-slide .dc-group {height:100%; top:0; left:0;}
.backwon-slide .dc-group .dc {width:14.8%; height:16.17%;}
.backwon-slide .dc-group .dc1 {top:23.82%; right:44%; z-index:5; background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_backwon_circle_1.png);}
.backwon-slide .dc-group .dc2 {top:20.29%; right:28.2%; z-index:4; background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_backwon_circle_2.png);}
.backwon-slide .dc-group .dc3 {top:16.17%; right:36.3%; z-index:3; background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_backwon_circle_3.png);}

.gift-slide {margin-top:1rem; margin-bottom:6.4rem;}
.gift-slide .tit {bottom:.5rem;}
.gift-slide .txt {position:absolute; top:12.5%; left:27.86%; width:12.93%;}
.gift-slide .cup-children {position:relative; height:29.01rem;}
.gift-slide .cup-children span {display:inline-block; position:absolute; top:25.73%; left:15.46%; width:36.26%; }
.gift-slide .cup-children .girl {width:49.06%; top:6.7%; left:41.46%;}
.gift-slide .dc-group {width:100%; height:100%; top:0; right:0;}
.gift-slide .dc-group span {width:2.4%; height:5%; background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_gift_spark.png);}
.gift-slide .dc-group .dc1 {top:20.73%; right:78.7%;}
.gift-slide .dc-group .dc2 {top:24.82%; right:15.2%; transform:scale(.6);}
.gift-slide .dc-group .dc3 {top:30.58%; right:17.6%;}
.gift-slide .dc-group .dc4 {top:35.4%; right:10.6%;  transform:scale(.6);}

.tenquiz-slide {margin-top:2.6rem;}
.tenquiz-slide .tit {bottom:1.7rem;}
.tenquiz-slide .txt {position:absolute; top:11.76%; left:64.66%; width:28.8%;}
.tenquiz-slide .coin span {position:absolute; top:9.7%; left:24.8%; width:20.13%;}
.tenquiz-slide .dc-group {top:59.70%; left:67.73%; width:16.4%;}
.tenquiz-slide .dc-group .dc {left:0; width:100%; height:1.02rem; background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_tenquiz_coin.png);}
.tenquiz-slide .dc-group .dc1 {top:0; animation-delay:.7s;}
.tenquiz-slide .dc-group .dc2 {top:1.02rem; animation-delay:.5s;}
.tenquiz-slide .dc-group .dc3 {left:1rem; top:2.03rem; animation-delay:.3s;}
.tenquiz-slide .dc-group .dc4 {top:3.05rem;}

.md-slide {top:1.16rem; right:-1.3rem; margin-bottom:5.26rem;}
.md-slide .tit {bottom:1.5rem;}
.md-slide .txt ,
.md-slide .monster .leg {position:absolute; top:16.17%; left:70%; width:14.53%;}
.md-slide .monster .leg {top:49.14%; left:17.26%; width:37.87%; transform-origin:10.24rem 4.36rem;}

.diary-slide {margin-top:1.73rem; right:1.5rem;}
.diary-slide.section .tit {bottom:4.5rem;}
.diary-slide .txt {display:inline-block; position:absolute; top:8%; left:67.46%; width:8%;}
.diary-slide .planet .dc {position:absolute;}
.diary-slide .planet .satllite {width:19.87%; top:14.53%; left:18.66%; transform-origin:10.92rem 8.15rem}
.diary-slide .planet .sm-planet {width:21.47%; top:43.38%; left:69%;}
.diary-slide .dc-group {width:100%; height:100%; top:0; left:0;}
.diary-slide .dc-group span {width:5.8%; height:6.4%; background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_diary_drop.png)}
.diary-slide .dc-group .dc1 {top:16.76%; right:13.86%;}
.diary-slide .dc-group .dc2 {display:none; top:66.17%; right:73.73%;}
.diary-slide .dc-group .dc3 {display:none; top:70%; right:70.93%;}

.ten-comment {padding-top:2rem; background-color:#a82ccd;}
.comment-write legend {visibility:hidden; width:0; height:0;}
.comment-write .inner {margin:1rem 1.54rem 0;}
.comment-write .choice {display:flex; justify-content:space-evenly; position:relative; z-index:5; padding:0 1rem;}
.comment-write .choice li {overflow:hidden; position:relative;}
.comment-write .choice li button {width:100%; height:100%; color:inherit; font:inherit; outline:none; -webkit-tap-highlight-color:transparent;}
.comment-write .field {height:13.22rem; padding:2.01rem; margin-top:2.26rem; background-color:#fff; border-radius:.47rem .47rem 0 0; border:solid 2px #332017;}
.comment-write .field textarea {width:100%; padding:0; color:#333; font-size:1.13rem; border:0;}
.comment-write .field:after,
.comment-write button {display:inline-block; position:absolute; top:0; left:0; width:100%; height:100%;}
.comment-write button {position:relative; top:-.5rem; width:100%; height:4.56rem; border-radius:.47rem .47rem 0 0; border-radius:0 0 .47rem .47rem; border:solid 2px #332017; background-color:#cfff71;}
.comment-write button img {width:6.53rem;}
.comment-write .caution {padding:.5rem 9.6% 0;}
.comment-write .ico {width:6.36rem; height:16.434rem; background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/ico_celebrate_1.png); background-repeat:no-repeat; background-position:0 0; background-size:100% 100%; text-indent:-999em;}
.comment-write .on {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/ico_celebrate_1_on.png);}
.comment-write .ico2 {width:8.19rem; height:16.47rem; background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/ico_celebrate_2.png);}
.comment-write .ico2.on {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/ico_celebrate_2_on.png);}
.comment-write .ico3 {width:6.01rem; background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/ico_celebrate_3.png);}
.comment-write .ico3.on {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/ico_celebrate_3_on.png);}

.comment-list ul {margin:10rem 1.54rem 0;}
.comment-list li {position:relative; min-height:20.31rem; margin-top:7.25rem; background-color:#ffcaf2; border:solid 0.26rem #fb94e1; border-radius:4.26rem;}
.comment-list li .ico {position:absolute; top:-5.46rem; left:1.7rem; z-index:5; width:9.8rem; height:11.65rem; background-size:100%; background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/ico_cmt_1.png); background-repeat:no-repeat; text-indent:-999em;}
.comment-list li .ico strong {display:table-cell; vertical-align:middle;}
.comment-list li .info {position:relative; height:7.13rem; color:#34251c; font-family:'roboto';}
.comment-list li .info .num {position:absolute; top:0.85rem; right:-.6rem; height:2.47rem; padding:0 .98rem; background-color:#ff80df; font-size:1rem; line-height:2.7rem; font-weight:600; border-radius:.17rem;}
.comment-list li .info .writer {padding-top:4.27rem; padding-right:1.8rem; font-size:1.12rem; font-weight:bold; text-align:right;}
.comment-list li .info .mob {display:inline-block; position:relative; top:.1rem; width:0.64rem; height:.98rem; margin-right:.38rem; background:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/ico_mobile.png)no-repeat 0 0; background-size:100%;}
.comment-list li .txt {overflow-y:auto; height:8.27rem; padding-right:1.28rem; margin:0 1.71rem; font-size:1rem; line-height:1.72;}
.comment-list li .date {margin-top:1.28rem; padding-right:2.04rem; color:#898989; font-size:1rem; text-align:right;}
.comment-list li .delete {display:inline-block; position:absolute; top:-2.56rem; right:0; width:1.79rem; height:1.79rem; background:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/btn_delete.png)no-repeat 0 0; background-size:100%;}
.comment-list ::-webkit-scrollbar {width:.9rem;}
.comment-list ::-webkit-scrollbar-track {border-radius:.34rem;  background-color:#fff;}
.comment-list ::-webkit-scrollbar-thumb {background:#f97dda; border-radius:.34rem;}

.comment-list li.cmt2 {background:#a9ffda; border-color:#47e39f; border-radius:.43rem;}
.comment-list li.cmt2 .ico {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/ico_cmt_2.png);}
.comment-list li.cmt2 .info .num {background-color:#27ffa1;}
.comment-list li.cmt2 ::-webkit-scrollbar-thumb {background-color:#00fc8e;}
.comment-list li.cmt3 {background:#fffbca; border-color:#edda01; border-radius:.43rem 4.26rem;}
.comment-list li.cmt3 .ico {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/ico_cmt_3.png);}
.comment-list li.cmt3 .info .num {background-color:#ffea00;}
.comment-list li.cmt3 ::-webkit-scrollbar-thumb {background-color:#f6e100;}
.comment-list .et1:before {display:inline-block; position:absolute; top:-4.52rem; left:13.62rem; width:3.62rem; height:4.82rem; background:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_et.png) no-repeat 0 0; background-size:100%; content:' '; animation:moveX .8s 100 ease-in-out;}
.comment-list .et1 .dc-group {position:absolute; top:0; left:0;}
.comment-list .et1 .dc {display:inline-block; position:absolute; top:-4.6rem; left:.3rem; z-index:7; width:13.1rem; height:9.26rem; background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_round.png); background-size:100%;}
.comment-list .et1 .dc2 {top:-3.84rem; left:.9rem; width:4.14rem; height:4.14rem; background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_earth.png);  animation:bounce2 .8s linear infinite alternate;}

.comment-list .pagingV15a {padding-bottom:3.22rem}
.comment-list .pagingV15a span {min-width:2.98rem; height:2.98rem; margin:0 0.55rem; color:#fff; font-size:1.1rem; line-height:3rem; font-weight:bold; border-radius:50%;}
.comment-list .pagingV15a .current {background-color:#d3ff7e; color:#000;}
.comment-list .pagingV15a .arrow a:after {width:.77rem; height:.77rem; margin-top:-.4rem; margin-left:-.4rem; background:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/btn_cmt_next.png)no-repeat 50% 50%; background-size:100%;}
.comment-list .pagingV15a .prevBtn a:after {transform:rotateY(180deg); -webkit-transform:rotateY(180deg);}

.spin1 {animation:spin 1.3s forwards; transform-origin:-5.71rem 11.86rem;}
.spin2 {animation-name:spin2;}
.spin3 {animation-name:spin3;}
.spin4 {animation-name:spin4;}
.spin5 {animation-name:spin5;}
.spin6 {animation-name:spin6; animation-duration:.8s; animation-iteration-count:1; animation-timing-function:linear;}
.spinWhole {animation-name:spinWhole; animation-duration:.8s; animation-iteration-count:1; animation-timing-function:linear;}
.bounce1 {animation:bounce1 .9s 200 ease-in-out;}
.bounce2 {animation:bounce2 1.3s 200 ease-in-out;}
.bounce3 {animation:bounce1 .8s 200 ease-in-out;}
.bounce4 {animation:bounce2 1s .4s 200 ease-in;}
.twinkle {animation:twinkle .9s 300;}
.twinkle2 {animation:twinkle 1.7s 300;}
.twinkle3 {animation:twinkle 2s 300;}
.twinkle4 {animation:twinkle 1.1s 300;}
.fadeIn {animation:fadeIn 1s 1 forwards}
.shake1 {animation:shake .6s .5s 300 alternate ease-in;}
.shake2 {animation:shake .6s 300 alternate ease-in;}
.drop {animation:drop 1.5s 1 ease-in forwards;}
.legSwing {animation:legSwing .5s 300 alternate ease-in;}
.orbit {animation:orbit 6.5s 200 alternate ease-in;}

@keyframes spin {from {transform: rotate(62deg);}to{transform: rotate(37deg);}}
@keyframes spin2 {from {transform: rotate(37deg);}to{transform: rotate(17deg);}}
@keyframes spin3 {from {transform: rotate(17deg);}to{transform: rotate(-3deg);}}
@keyframes spin4 {from {transform: rotate(-3deg);}to{transform: rotate(-17deg);}}
@keyframes spin5 {from {transform: rotate(-17deg);}to{transform: rotate(-26deg);}}
@keyframes spin6 {from {transform: rotate(-26deg);}to{transform: rotate(-295deg);}}
@keyframes spinWhole {from {transform: rotate(62deg);}to{transform: rotate(-295deg);}}
@keyframes bounce1 {from {transform:translateY(-5px);} 30%{transform:translateY(0);}	to {transform:translateY(-5px);}}
@keyframes bounce2 {from, to{transform:translateY(0);} 50%{transform:translateY(5px);}}
@keyframes twinkle {from, to{opacity:1;} 50%{opacity:0;}}
@keyframes fadeIn {0% {opacity:0;}100% {opacity:1; transition-timing-function:ease-out;}}
@keyframes shake {from {transform: rotate(-9deg);}to{transform: rotate(-1deg);}}
@keyframes drop {from {opacity:0; transform:translateY(-50px);} 50% {opacity:1; transform:translateY(0)} to {opacity:1;}}
@keyframes legSwing {from {transform: rotate(0deg);}to{transform: rotate(5deg);}}
@keyframes orbit {from {transform: rotate(-60deg);}to{transform: rotate(60deg);}}
@keyframes moveX {from, to{transform:translateX(0);}	50%{transform:translateX(10px)}}
</style>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>			
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js?v=2.4370"></script>
<script type="text/javascript">
$(function(){
	var position = $('.ten-life').offset(); // 위치값
	$('html,body').animate({ scrollTop : position.top }, 100); // 이동

	fnAmplitudeEventMultiPropertiesAction('view_17th_main','','');
	//intro layer aniamation
		
	<% if pagereload <> "" then %>
		$('.intro').hide();
	<% else %>	
		$('.main-cont').hide();
		setTimeout(function(){$('.intro').fadeOut(500);}, 1000);
		setTimeout(function(){$('.main-cont').fadeIn();}, 1000);	
	<% end if %>
	// animation
	$('.coupon-slide .dc1').addClass('twinkle');
	$('.coupon-slide .boy i').addClass('bounce1');
	$('.maeileage-slide .dc1').addClass('twinkle');
	$('.maeileage-slide .dc2').addClass('twinkle2');
	$('.maeileage-slide .dc4').addClass('twinkle4');
	$('.backwon-slide .hand1').addClass('shake1');
	$('.backwon-slide .hand2').addClass('shake2');
	$('.backwon-slide .dc1').addClass('bounce1');
	$('.backwon-slide .dc2').addClass('bounce2');
	$('.backwon-slide .dc3').addClass('bounce3');
	$('.gift-slide .boy').addClass('bounce1');
	$('.gift-slide .girl').addClass('bounce4');
	$('.gift-slide .dc1').addClass('twinkle');
	$('.gift-slide .dc2').addClass('twinkle');
	$('.gift-slide .dc3').addClass('twinkle2');
	$('.gift-slide .dc4').addClass('twinkle3');
	$('.tenquiz-slide .txt').addClass('bounce3');
	$('.tenquiz-slide .coin span').addClass('twinkle');
	$('.md-slide .leg').addClass('legSwing');
	$('.md-slide .txt').addClass('bounce3');
	$('.diary-slide .txt').addClass('twinkle');
	$('.diary-slide .sm-planet').addClass('bounce1');
	$('.diary-slide .satllite').addClass('orbit');
	$('.diary-slide .dc1').addClass('bounce4');

	// control layer
	$('.layer').hide();
	$('.layer').click(function (e){e.preventDefault()});
	$('.layer-how').click(function (e){$(this).fadeOut();});
	$('.layer-how button').click(function (e){e.preventDefault()});
	$('.layer-coupon .btn-close').click(function (e){$('.layer-coupon').fadeOut();	});

// count click
	var count = 0;
	$('.btn-coupon').click(function (e) {				
		<% if Not(IsUserLoginOK) then %>
			jsEventLogin();
			return false;
		<% end if %>       		
		<% if iscouponeDown then %>
		return false;
		<% end if %>
		e.preventDefault()
		$('.rocket').addClass('spinWhole');
		setTimeout(function(){$('.gage5').css({'display':'block'});}, 100);
		setTimeout(function(){$('.layer-coupon').fadeIn();}, 800);
		<% if isApp = 1 then %>
		fnAmplitudeEventMultiPropertiesAction('click_ten17th_getcouponbtn','','', function(bool){if(bool) {jsDownCoupon('prd,prd,prd,prd,prd','<%=eventCoupons%>');}});        									
		<% else %>
		fnAmplitudeEventMultiPropertiesAction('click_ten17th_getcouponbtn','','');				
		jsDownCoupon('prd,prd,prd,prd,prd','<%=eventCoupons%>');return false;	
		<% end if %>
	});
});
function jsDownCoupon(stype,idx){
	<% if Not(IsUserLoginOK) then %>
		jsEventLogin();
		return false;
	<% else %>
	$.ajax({
		type: "post",
		url: "/shoppingtoday/act_couponshop_process.asp",
		data: "idx="+idx+"&stype="+stype,
		cache: false,
		success: function(message) {
			if(typeof(message)=="object") {
				if(message.response=="Ok") {
					setTimeout(function(){$('.layer-coupon').fadeIn();}, 1500);					
					$("#couponBtn").attr("src","http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/btn_coupon_comp.png");
				} else {
					alert(message.message);
				}
			} else {
				alert("처리중 오류가 발생했습니다.");
			}
		},
		error: function(err) {
			console.log(err.responseText);
		}
	});
	<% end if %>
}
function jsEventLogin(){
<% if isApp="1" then %>
	calllogin();
<% else %>
	jsChklogin_mobile('','<%=Server.URLencode("/event/17th/")%>');
<% end if %>
	return;
}

function linkMycoupon(){
	<% if isApp="1" then %>
		fnAPPpopupBrowserURL('마이텐바이텐','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/couponbook.asp');
	<% else %>
		location.href='/my10x10/couponbook.asp'
	<% end if %>
	return false;
}
</script>
			<div class="ten-life life-main">
				<!-- INTRO -->
				<div class="intro">
					<h2><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/tit_ten_life_v3.png" alt="슬기로운텐텐생활" /></h2>
				</div>

				<!-- MAIN -->
				<div class="main-cont">
					<h2><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/tit_ten_life_sm.png" alt="17th Anniversary" /></h2>
					<p class="btn-wrapper">	
						<a href="#ten-comment" class="btn-cmt">
							<img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/btn_go_cmt.png?v=1.03" alt="코멘트이벤트로 이동" />							
						</a>
						<i></i>
					</p>

					<!-- ROLLING -->
						<div id="swiper-wrap">							
								<!-- COUPON -->
								<div class="section coupon-slide" id="coupon">
									<div class="on">
										<div class="txt">
											<span class="boy">
												<img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_coupon_boy.png" alt="" />
												<i><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_coupon_arm.png" alt="" /></i>
											</span>
											<span class="coupon"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/txt_get_coupon_v2.png?v=1.01" alt="꾹 누르고, 쿠폰 받기!" /></span>
											<span class="discount"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/txt_discount.png" alt="쿠폰 최대 25%" /></span>
										</div>
										<div class="gage-bar">
											<span class="bg-gage gage1"></span>
											<span class="bg-gage gage2"></span>
											<span class="bg-gage gage3"></span>
											<span class="bg-gage gage4"></span>
											<span class="bg-gage gage5"></span>
											<span class="rocket"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_rocket.png" alt="" /></span>
										</div>
										<button class="btn-coupon">											
										<% if iscouponeDown then %>
										<img id="couponBtn" src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/btn_coupon_comp.png" alt="쿠폰발급완료"/><%'<!-- 쿠폰발급 완료 -->%>
										<% else %>
										<img id="couponBtn" src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/btn_coupon.png" alt="쿠폰받기"/><%'<!-- 쿠폰발급 전 -->%>
										<% end if %>											
											<i><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/txt_coupon_click.png" alt="클릭"/></i>
										</button>
										<div class="dc-group">
											<% if date() = "2018-10-29" then %>
												<span class="dc dc1" style="background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/txt_day_2.png)" >d-2 남았어요</span>
											<% end if %>
											<% if date() = "2018-10-30" then %>
												<span class="dc dc1" style="background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/txt_day_1.png)" >d-1 남았어요</span>
											<% end if %>
											<% if date() = "2018-10-31" then %>
												<span class="dc dc1" style="background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/txt_last_day.png)" >서두르세요! 오늘이 마지막</span>
											<% end if %>
											<span class="dc dc2">스파크</span>
										</div>
									</div>
								</div>

								<!-- 100원의기적 -->
								<div class="section backwon-slide">
								<% If isApp = 1 Then %>
									<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_17th_main_gacha','','', function(bool){if(bool) {fnAPPpopupBrowserURL('100원의기적','<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=89305'); return false;}});">
									<!--<a href="javascript:fnAPPpopupBrowserURL('100원의기적','<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=89305');">-->
								<% Else %>
									<a href="http://m.10x10.co.kr/event/eventmain.asp?eventid=89309" onclick="fnAmplitudeEventMultiPropertiesAction('click_17th_main_gacha','','');">
								<% End if %>	
										<div class="on">
											<p class="tit"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/tit_backwon.png?v=1.00" alt="100원으로 인생역전" /></p>											
											<div class="machine">
												<img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_backwon.png?v=1.01" alt="" />
												<div class="dc-group">
													<span class="dc dc1"></span>
													<span class="dc dc2"></span>
													<span class="dc dc3"></span>
												</div>
											</div>
											<div class="children">
												<img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_backwon_children.png" alt="" />
												<i class="hand1"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_backwon_arm_1.png" alt="" /></i>
												<i class="hand2"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_backwon_arm_2.png" alt="" /></i>
											</div>
										</div>										
									</a>
								</div>

								<!-- mdpick -->	
								<div class="section md-slide">
									<% if now() > #10/14/2018 23:59:59# then %>																												
									<% If isApp = 1 Then %>
										<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_17th_main_MDspick','','', function(bool){if(bool) {fnAPPpopupBrowserURL('오늘의특가','<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=89541'); return false;}});">										
									<% Else %>
										<a href="http://m.10x10.co.kr/event/eventmain.asp?eventid=89541" onclick="fnAmplitudeEventMultiPropertiesAction('click_17th_main_MDspick','','');">
									<% End if %>																			
										<div class="on">
											<p class="tit"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/ti_md_evt.png" alt="할인 이벤트 오늘의 특가!" /></p>
											<span class="txt"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/txt_md.png" alt="가을 주역의 아이템!" /></span>
											<div class="monster">
												<img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_md_evt_on.png?v=1.03" alt="" />
												<span class="leg"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_md_leg.png?v=1.00" alt="" /></span>
											</div>
										</div>																	
									<% else %>
									<a href="javascript:void(0)">
										<div class="coming">
											<img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_md_evt_v2.png" alt="10월 15일 특가가 시작됩니다! " />
											<p class="tit"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/ti_md_evt.png" alt="할인 이벤트 오늘의 특가!" /></p>
										</div>													
									<% end if %>
									</a>
								</div>

								<!-- 매일리지 -->
								<div class="section maeileage-slide" id="maeileage"> 
								<% if isApp = 1 then '10/10 ~ 17 1차             24 ~ 31 2차%>
									<% if now() < #10/17/2018 23:59:59# then %>									
										<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_17th_main_maeliage','','', function(bool){if(bool) {fnAPPpopupBrowserURL('매일리지', 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88939'); return false;}});">
										<!--<a href="javascript:fnAPPpopupBrowserURL('매일리지', 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88939');">-->
									<% elseif now() > #10/17/2018 23:59:59# and now() < #10/31/2018 23:59:59# then %>
										<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_17th_main_maeliage','','', function(bool){if(bool) {fnAPPpopupBrowserURL('매일리지', 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=89076'); return false;}});">
										<!--<a href="javascript:fnAPPpopupBrowserURL('매일리지', 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=89076');">-->
									<% end if %>								
								<% else %>
								<a href="/event/eventmain.asp?eventid=89073" onclick="fnAmplitudeEventMultiPropertiesAction('click_17th_main_maeliage','','');">
								<% end if %>									
									<div class="on">
										<p class="tit"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/tit_maeileage.png?v=1.00" alt="출석체크 이벤트 매일매일 매일리지" /></p>
										<div class="girl">
											<img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_maeil_girl.png?v=1.00" alt="" />
											<i class="bg-ground"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_maeileage_ground.png" alt=""></i>
										</div>
										<div class="dc-group">
											<span class="dc dc1">큰별</span>
											<span class="dc dc2">별</span>
										</div>										
									</div>									
									</a>
								</div>

								<!-- 텐퀴즈 -->
								<%' if now() < #10/24/2018 23:59:59# then %>
								<div class="section tenquiz-slide">
								<% if isApp = 1 then %>
								<!--<a href="javascript:fnAPPpopupBrowserURL('텐퀴즈','<%=wwwUrl%>/apps/appcom/wish/web2014/tenquiz/quizmain.asp');">								-->
								<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_17th_main_tenquiz','','', function(bool){if(bool) {fnAPPpopupBrowserURL('텐퀴즈','<%=wwwUrl%>/apps/appcom/wish/web2014/tenquiz/quizmain.asp'); return false;}});">								
								<% else %>
								<a href="/tenquiz/index.asp" onclick="fnAmplitudeEventMultiPropertiesAction('click_17th_main_tenquiz','','');">
								<% end if %>
										<div class="on">
											<p class="tit"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/tit_tenquiz.png" alt="도전! 텐텐벨" /></p>
											<span class="txt">
												<img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/txt_tenquix_coming.png?v=1.01" alt="coming Soon" />
											</span>
											<div class="coin">
												<img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_tenquiz.png?v=1.01" alt="텐퀴이즈">
												<span><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/txt_tenquiz.png" alt="상금이 100만원?" /></span>
											</div>
											<div class="dc-group">
												<span class="dc dc1"></span>
												<span class="dc dc2"></span>
												<span class="dc dc3"></span>
												<span class="dc dc4"></span>
											</div>
										</div>
									</a>
								</div>
								<%' end if %>
								<!-- 다이어리 -->								
								<div class="section diary-slide">
								<% if isApp = 1 then %>				
								<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_17th_main_diary','','', function(bool){if(bool) {fnAPPpopupBrowserURL('다이어리스토리','http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2019/index.asp'); return false;}});">												
								<!--<a href="javascript:void(0);" onclick="fnAPPpopupBrowserURL('다이어리스토리','http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2019/index.asp'); return false;">																-->
								<% else %>
								<a href="/diarystory2019/index.asp" onclick="fnAmplitudeEventMultiPropertiesAction('click_17th_main_diary','','');">
								<% end if %>
										<div class="on">
											<p class="tit"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/tit_diary.png" alt="다이어리 이벤트" /></p>
											<span class="txt"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/txt_diary_click.png" alt="click" /></span>
											<div class="planet">
												<img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_diary_v3.png?v=1.02" alt="" />
												<span class="dc satllite"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_diary_satellite.png" alt="" /></span>
												<span class="dc sm-planet"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_diary_planet.png" alt="" /></span>
											</div>
											<div class="dc-group">
												<span class="dc dc1"></span>
											</div>
										</div>
									</a>
								</div>

								<!-- 구매사은 -->
								<div class="section gift-slide">
								<% if isApp = 1 then %>
									<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_17th_main_gift','','', function(bool){if(bool) {fnAPPpopupBrowserURL('잘사고 잘받자','<%=wwwUrl%>/apps/appcom/wish/web2014/event/17th/gift.asp'); return false;}});">								
									<!--<a href="javascript:fnAPPpopupBrowserURL('잘사고 잘받자','<%=wwwUrl%>/apps/appcom/wish/web2014/event/17th/gift.asp');">-->
								<% else %>
									<a href="/event/17th/gift.asp" onclick="fnAmplitudeEventMultiPropertiesAction('click_17th_main_gift','','');">
								<% end if %>								 	
										<div class="on">
											<p class="tit"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/tit_gift.png?v=1.00" alt="구매사은품 이벤트" /></p>
											<div class="sold-out"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_cup_soldout.png" alt="" /></div>
											<!-- <span class="txt"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/txt_gift_1.png" alt="사은품이 예술이야!" /></span>
											<div class="cup-children">
												<span class="boy"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_gift_boy.png" alt="" /></span>
												<span class="girl"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_gift_girl.png" alt="" /></span>
											</div>
											<div class="dc-group">
												<span class="dc dc1">반짝</span>
												<span class="dc dc2">반짝</span>
												<span class="dc dc3">반짝</span>
												<span class="dc dc4">반짝</span>
											</div> -->
										</div>
									</a>
								</div>							
					</div>
					<!-- 쿠폰 받는 방법 레이어-->
					<div class="layer layer-how">
						<div class="inner">
							<img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/txt_pop_how_to_02.png" alt="쿠폰받기 버튼을 계속 클릭해서 게이지를 채워야 쿠폰을 다운받을 수 있어요!" />
							<button><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/btn_start.png" alt="쿠폰받으러 가기" /></button>
						</div>
					</div>

					<!-- 쿠폰 발급 완료 레이어 -->
					<div class="layer layer-coupon">
						<div class="inner">
							<img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/txt_pop_cupon.png" alt="쿠폰이 발급 되었습니다!" />
							<a href="#" onclick="linkMycoupon();" class="btn-go"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/btn_go_coupon.png?v=1.01" alt="쿠폰함으로 가기" /></a>
							<button class="btn-close"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/btn_close_pop.png" alt="닫기" /></button>
						</div>
					</div>

					<!-- SHARE -->
					<div class="share">
						<p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/tit_share.png" alt="즐거운공유생활" /></p>
						<ul>
							<li>
								<a href="#" onclick="snschk('fb'); return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_fb.png" alt="페이스북공유" /></a>
							</li>
							<li>
								<a href="#" onclick="snschk('ka'); return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_kakao.png" alt="카카오공유" /></a>
							</li>
							<% if isApp then %>
							<li>
								<a href="" onclick="callNativeFunction('copyurltoclipboard', {'url':'<%=snpLink2%>','message':'링크가 복사되었습니다. 원하시는 곳에 붙여넣기 하세요.'}); return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_url_v2.png" alt="url공유" /></a>
							</li>
							<% end if %>
						</ul>
					</div>

				</div>
			</div>
			<!--// 17주년 메인 -->
			<!-- #include virtual="/event/17th/inc_comment.asp" -->
</div>
<!--// 16주년 이벤트 : 메인 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->