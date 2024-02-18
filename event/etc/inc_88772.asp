<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 2018 추석기획전
' History : 2018.09-04 최종원
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<%
Dim baseDt: baseDt = date & " " & Num2Str(Hour(now),2,"0","R") & ":" & Num2Str(Minute(now),2,"0","R") & ":" & Num2Str(Second(now),2,"0","R")
%>
<style type="text/css">
.thanksgiving {font-family:"malgun Gothic","맑은고딕", Dotum, "돋움", sans-serif;}
.thanksgiving .todayGift {text-align:center;}
.thanksgiving .todayGift h3 {display:none; visibility:hidden; font-size:0; line-height:0;}
.thanksgiving .todayGift a {display:block; position:relative;}
.thanksgiving .todayGift .item {position: absolute; top: 12%; left: 50%; width:62%; margin-left: -31%; }
.thanksgiving .todayGift .name {overflow:hidden; padding:1.7rem 0 0.9rem; text-overflow:ellipsis; white-space:nowrap; font-family:'AppleSDGothicNeo-Bold'; font-weight:bold; font-size:1.37rem; color:#000;}
.thanksgiving .todayGift .price s {font-size:1.19rem; color: #868274; margin-right:0.4rem;}
.thanksgiving .todayGift .price strong {font-family:'AppleSDGothicNeo-Bold'; font-weight:bold; font-size:1.54rem; color:#ff0000;}
.thanksgiving .todayGift .time {position: absolute; top: 1.7%; right: 3.5%; width: 25.9%; z-index: 10;}
.thanksgiving .todayGift .time span {display: block; position: absolute; width: 100%; left:0; bottom: 1.6rem; font-weight: bold; font-size: 0.94rem; color: #fff;}
.thanksgiving .todayGift .time span em {padding:0 0.3rem;}

.thanksgiving .rolling {position:relative; padding: 0 6.7%; background-position:50% 0; background-repeat:no-repeat; background-size: 100% auto;}
.thanksgiving .rolling1 {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/s1_bg.jpg);}
.thanksgiving .rolling2 {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/s2_bg.jpg);}
.thanksgiving .rolling3 {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/s3_bg.jpg);}
.thanksgiving .rolling4 {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/s4_bg.jpg);}
.thanksgiving .rolling .slideNav {position:absolute; top:10%;z-index:10; width:13.7%; background:none; text-indent:0;}
.thanksgiving .rolling .btnPrev {left:0%;}
.thanksgiving .rolling .btnNext {right:0%;}
.thanksgiving .rolling .pagination {width: 100%; height: auto; padding-top: 1.2rem;}
.thanksgiving .rolling .pagination span {width:3rem; height:2px; margin:0; background:#ccc; border-radius:0; -webkit-border-radius:0; vertical-align:middle;}
.thanksgiving .rolling .pagination .swiper-active-switch {height:0.34rem;}
.thanksgiving .rolling1 .pagination .swiper-active-switch {background:#d54f2c;}
.thanksgiving .rolling2 .pagination .swiper-active-switch {background:#727630;}
.thanksgiving .rolling3 .pagination .swiper-active-switch {background:#2a6972;}
.thanksgiving .rolling4 .pagination .swiper-active-switch {background:#8e6b1f;}

.thanksgiving .section1 {background:#ffefe7;}
.thanksgiving .section2 {background:#f8f7e3;}
.thanksgiving .section3 {background:#def0ef;}
.thanksgiving .section4 {background:#fbf3df;}
.thanksgiving .section .btn-more {display:block;}
.thanksgiving .item-list {position:relative; overflow: hidden;}
.item-list ul {position:absolute; top:0; width: 100%; padding:11% 3%;}
.item-list li {width:50%; float:left; margin-bottom:8%;}
.item-list li a {display:block; text-align: center; padding-top: 103%; position: relative;}
.item-list li .desc {padding: 0 1rem; font-family:'AppleSDGothicNeo-Regular'; font-weight: normal;}
.item-list li .name {overflow:hidden; font-size:1.28rem; color: #333; margin-bottom: 0.5rem; text-overflow:ellipsis; white-space:nowrap;}
.item-list li .price {font-size:1.19rem; color: #333;}
.section1 .item-list li .price strong {color:#d54f2c;}
.section2 .item-list li .price strong {color:#7d8145;}
.section3 .item-list li .price strong {color:#2a6972;}
.section4 .item-list li .price strong {color:#8e6b1f;}
.item-list li .price s {margin-right:0.5rem;}
.item-list li .price .rate {position:absolute; right:6%; top:5%; display:block; width:3.97rem; height:3.93rem; font-family:verdana, sans-serif; color:#fff; font-weight:600; text-align:center; line-height:3.93rem; background-position:50% 50%; background-repeat:no-repeat; background-size:3.97rem auto;}
.section1 .item-list li .price .rate {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/bg_sale1.png);}
.section2 .item-list li .price .rate {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/bg_sale2.png);}
.section3 .item-list li .price .rate {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/bg_sale3.png);}
.section4 .item-list li .price .rate {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/bg_sale4.png);}

.thanksgiving .bnr-area {position:relative;}
.thanksgiving .bnr-area a {display:block;}
.thanksgiving .bnr-area .bnr1 {width:100%; float:none;}
.thanksgiving .bnr-area .bnr2 {width:50%; float:left;}
.thanksgiving .bnr-area .bnr3 {width:50%; float:right;}
.thanksgiving .bnr-area .bnr4 {width:100%; float:none;}
</style>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>
<script>
$(function(){
	slideTemplate = new Swiper('.rolling1 .swiper-container',{
		loop:true,
		autoplay:1800,
		autoplayDisableOnInteraction:false,
		speed:800,
		pagination:".rolling1 .pagination",
		paginationClickable:true,
		nextButton:'.rolling1 .btnNext',
		prevButton:'.rolling1 .btnPrev'
	});
	slideTemplate = new Swiper('.rolling2 .swiper-container',{
		loop:true,
		autoplay:1800,
		autoplayDisableOnInteraction:false,
		speed:800,
		pagination:".rolling2 .pagination",
		paginationClickable:true,
		nextButton:'.rolling2 .btnNext',
		prevButton:'.rolling2 .btnPrev'
	});
	slideTemplate = new Swiper('.rolling3 .swiper-container',{
		loop:true,
		autoplay:1800,
		autoplayDisableOnInteraction:false,
		speed:800,
		pagination:".rolling3 .pagination",
		paginationClickable:true,
		nextButton:'.rolling3 .btnNext',
		prevButton:'.rolling3 .btnPrev'
	});
	slideTemplate = new Swiper('.rolling4 .swiper-container',{
		loop:true,
		autoplay:1800,
		autoplayDisableOnInteraction:false,
		speed:800,
		pagination:".rolling4 .pagination",
		paginationClickable:true,
		nextButton:'.rolling4 .btnNext',
		prevButton:'.rolling4 .btnPrev'
	});
});
</script>
<script type="text/javascript">
var nowDt;
var montharray=new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
var minus_second = 0;
var vPageDiv = "m";

$(function(){
	$.ajax({
		type: "get",
		url: "/event/etc/json/act_88772_thgv.asp",
		data: "pdv="+vPageDiv,
		cache: false,
		success: function(message) {
			console.log(message);
			if(typeof(message)=="object") {
				// 오늘의 특가 상품 출력
				if(typeof(message.today)=="object") {
					var imgurl = "";
					var imgurlarr;
					if(message.today.itemdiv == 21){
						imgurlarr = message.today.imgurl.split('/');
						imgurlarr.forEach(function(v, i){					
						if(v !== imgurlarr[imgurlarr.length-3]){
							imgurl = imgurl+ "/"+ v
						}						
					});		
					imgurl = imgurl.substr(1, imgurl.length);				
					}else{
						imgurl = message.today.imgurl;
					}		
					console.log(imgurl);			
                    $("#lyrTodayGift .thumbnail img").attr("src",imgurl).attr("alt",message.today.itemname);
                    <%if isApp=1 then%>
                    // <a href="" onclick="TnGotoProduct('2077214');return false;">                    
                    $("#lyrTodayGift a").click(function(){
                        TnGotoProduct(message.today.itemid);return false;
                    })
                    <%else%>
                    $("#lyrTodayGift a").attr("href","/category/category_itemPrd.asp?itemid="+message.today.itemid);
                    <%end if%>                    					
					$("#lyrTodayGift .name").html(message.today.itemname);
					if(message.today.saleper!="") {
						$("#lyrTodayGift .price").html("<s>"+message.today.orgprice+"</s> "+"<strong>"+message.today.sellprice+" ["+message.today.saleper+"]"+"</strong>");
					} else {
						$("#lyrTodayGift .price").html(message.today.orgprice);
					}
					if(message.today.date!=""){
						nowDt = new Date(message.today.date);
						countdown();
					}
				}
			
				// 선물편 상품 목록 가격 표시
				if(typeof(message.giftlist)=="object") {
					var i=0;
					$(message.giftlist).each(function(){
						$(".item-list li .name").eq(i).html(this.itemname);
						if(this.saleper!="") {
							$(".item-list li .price").eq(i).html("<s>"+this.orgprice+"</s> "+"<strong>"+this.sellprice+"</strong>"+"<span class='rate'>"+this.saleper+"</span>");
						} else {
							$(".item-list li .price").eq(i).html(this.orgprice);
						}																	
						i++;
					});
					$("#lyrItemList li").each(function(){
					});
				}
			}
		},
		error: function(err) {
			console.log(err.responseText);
		}
	});
});

// 오늘의 특가 타이머
function countdown(){
	var usrDt=new Date();	// 현재 브라우저 시간
	var vTerm = parseInt(usrDt.getTime()/1000)-parseInt(nowDt.getTime()/1000);	// 시작시 시간과의 차이(초)
	minus_second = vTerm;	// 증가시간에 차이 반영

	var cntDt = new Date(Date.parse(nowDt) + (1000*minus_second));	//서버시간에 변화값(1초) 증가
	var todayy=cntDt.getYear()

	if(todayy < 1000) todayy+=1900;
		
	var todaym=cntDt.getMonth();
	var todayd=cntDt.getDate();
	var todayh=cntDt.getHours();
	var todaymin=cntDt.getMinutes();
	var todaysec=cntDt.getSeconds();
	var todaystring=montharray[todaym]+" "+todayd+", "+todayy+" "+todayh+":"+todaymin+":"+todaysec;
	var futurestring=montharray[todaym]+" "+(todayd+1)+", "+todayy+" 00:00:00";

	dd=Date.parse(futurestring)-Date.parse(todaystring);
	dday=Math.floor(dd/(60*60*1000*24)*1);
	dhour=Math.floor((dd%(60*60*1000*24))/(60*60*1000)*1);
	dmin=Math.floor(((dd%(60*60*1000*24))%(60*60*1000))/(60*1000)*1);
	dsec=Math.floor((((dd%(60*60*1000*24))%(60*60*1000))%(60*1000))/1000*1);

	//console.log(futurestring);

	if(dday < 0) {
		$("#countdown").html("00 : 00 : 00");
		return;
	}

	if(dhour < 10) dhour = "0" + dhour;
	if(dmin < 10) dmin = "0" + dmin;
	if(dsec < 10) dsec = "0" + dsec;
	dhour = dhour+'';
	dmin = dmin+'';
	dsec = dsec+'';

	// Print Time
    $(".time em").html(
		dhour.substr(0,1)+dhour.substr(1,1) +" : "+ 
		dmin.substr(0,1)+dmin.substr(1,1) +" : "+ 
		dsec.substr(0,1)+dsec.substr(1,1)
		);
	setTimeout("countdown()",500);
}
</script>
            <!-- 2018 추석기획전 -->
			<div class="mEvt88772 thanksgiving">
				<h2><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/tit_thanksgiving.jpg" alt="소확선" /></h2>

                <!-- 오늘의 특가선물 -->
                <div class="todayGift" id="lyrTodayGift">
                    <h3>오늘의 특가선물</h3>
                    <a href="">                                
                        <img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/bg_today.jpg" alt="">
                        <div class="time">
                            <img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/bg_time.png" alt="">
                            <span><em></em></span>
                        </div>
                        <div class="item">
                            <div class="thumbnail"><img src="" alt=""></div>
                            <p class="name">구름이가 추천하는 꿀 선물, 하루벌꿀 단 하루 특가!</p>
                            <p class="price"><s>9,900원</s><strong>8,000원[19%]</strong></p>
                        </div>
                    </a>
                </div>                
                <!-- // 오늘의 특가선물 -->                
				<div class="givingContainer">
                    <div class="section section1">
                        <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/s1_tit.jpg" alt="" /></p>
                        <div class="rolling rolling1">
                            <div class="swiper-container">
                                <div class="swiper-wrapper">
                                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/img_slide1_1.jpg" alt="" /></div>
                                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/img_slide1_2.jpg" alt="" /></div>
                                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/img_slide1_3.jpg" alt="" /></div>
                                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/img_slide1_4.jpg" alt="" /></div>
                                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/img_slide1_5.jpg" alt="" /></div>
                                </div>
                            </div>
                            <div class="pagination"></div>
                            <button type="button" class="slideNav btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87026/m/btn_prev.png" alt="이전" /></button>
                            <button type="button" class="slideNav btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87026/m/btn_next.png" alt="다음" /></button>
                        </div>
                        <div class="item-list" id="itemList1">
                            <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/s1_item.jpg" alt="" /></p>
                            <ul>
                                <li>
                                    <%if isApp=1 then%>
                                    <a href="" onclick="TnGotoProduct('2069160');return false;">           
                                    <%else%>
                                    <a href="/category/category_itemPrd.asp?itemid=2069160&pEtr=88772" >
                                    <%end if%>                                                                       
                                        <div class="desc">
                                            <p class="name">커스텀 케이크</p>
                                            <p class="price"><strong>35,000원</strong><span class="rate">5%</span></p>
                                        </div>
                                    </a>
                                </li>
                                <li>
                                    <%if isApp=1 then%>
                                    <a href="" onclick="TnGotoProduct('1781962');return false;">           
                                    <%else%>
                                    <a href="/category/category_itemPrd.asp?itemid=1781962&pEtr=88772">
                                    <%end if%>                                                                       
                                        <div class="desc">
                                            <p class="name">달콤 고소 화과자</p>
                                            <p class="price"><s>43,000원</s><strong>40,850원</strong><span class="rate">5%</span></p>
                                        </div>
                                    </a>
                                </li>
                                <li>
                                    <%if isApp=1 then%>
                                    <a href="" onclick="TnGotoProduct('1638559');return false;">           
                                    <%else%>
                                    <a href="/category/category_itemPrd.asp?itemid=1638559&pEtr=88772">
                                    <%end if%>                                                                       
                                        <div class="desc">
                                            <p class="name">어반약과</p>
                                            <p class="price"><s>14,900원</s><strong>9,900원</strong><span class="rate">5%</span></p>
                                        </div>
                                    </a>
                                </li>
                                <li>
                                    <%if isApp=1 then%>
                                    <a href="" onclick="TnGotoProduct('1549037');return false;">           
                                    <%else%>
                                    <a href="/category/category_itemPrd.asp?itemid=1549037&pEtr=88772" >
                                    <%end if%>                                                                       
                                        <div class="desc">
                                            <p class="name">수제한과 문볼 6종</p>
                                            <p class="price"><strong>20,000원</strong><span class="rate">5%</span></p>
                                        </div>
                                    </a>
                                </li>
                                <li>
                                    <%if isApp=1 then%>
                                    <a href="" onclick="TnGotoProduct('1544880');return false;">           
                                    <%else%>
                                    <a href="/category/category_itemPrd.asp?itemid=1544880&pEtr=88772" >
                                    <%end if%>                                                                     
                                        <div class="desc">
                                            <p class="name">현미 연강정&amp;정과&amp;편강</p>
                                            <p class="price"><strong>55,000원</strong><span class="rate">5%</span></p>
                                        </div>
                                    </a>
                                </li>
                                <li>
                                    <%if isApp=1 then%>
                                    <a href="" onclick="TnGotoProduct('2049907');return false;">           
                                    <%else%>
                                    <a href="/category/category_itemPrd.asp?itemid=2049907&pEtr=88772" >
                                    <%end if%>                                                                         
                                        <div class="desc">
                                            <p class="name">2018 알디프 트라이앵글 티백</p>
                                            <p class="price"><strong>24,000원</strong></p>
                                        </div>
                                    </a>
                                </li>										
                            </ul>
                        </div>
                        <%if isApp=1 then%>
                        <a href="" onclick="fnAPPpopupBrowserURL('기획전','<%= wwwUrl %>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88773'); return false;" class="btn-more"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/s1_btn.jpg" alt="더 많은 상품 보기" /></a>    
                        <%else%>
                        <a href="/event/eventmain.asp?eventid=88773"  class="btn-more"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/s1_btn.jpg" alt="더 많은 상품 보기" /></a>
                        <%end if%>                                                          
                    </div>

                    <div class="section section2">
                        <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/s2_tit.jpg" alt="" /></p>
                        <div class="rolling rolling2">
                            <div class="swiper-container">
                                <div class="swiper-wrapper">
                                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/img_slide2_1.jpg" alt="" /></div>
                                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/img_slide2_2.jpg" alt="" /></div>
                                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/img_slide2_3.jpg" alt="" /></div>
                                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/img_slide2_4.jpg" alt="" /></div>
                                </div>
                            </div>
                            <div class="pagination"></div>
                            <button type="button" class="slideNav btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87026/m/btn_prev.png" alt="이전" /></button>
                            <button type="button" class="slideNav btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87026/m/btn_next.png" alt="다음" /></button>
                        </div>
                        <div class="item-list" id="itemList2">
                            <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/s2_item.jpg" alt="" /></p>
                            <ul>
                                <li>
                                    <%if isApp=1 then%>
                                    <a href="" onclick="TnGotoProduct('2073519');return false;">           
                                    <%else%>
                                    <a href="/category/category_itemPrd.asp?itemid=2073519&pEtr=88772" >
                                    <%end if%>                                                                     
                                        <div class="desc">
                                            <p class="name">살룻 담금주</p>
                                            <p class="price"><strong>35,000원</strong><span class="rate">5%</span></p>
                                        </div>
                                    </a>
                                </li>
                                <li>
                                    <%if isApp=1 then%>
                                    <a href="" onclick="TnGotoProduct('1285004');return false;">           
                                    <%else%>
                                    <a href="/category/category_itemPrd.asp?itemid=1285004&pEtr=88772" >
                                    <%end if%>                                   
                                        <div class="desc">
                                            <p class="name">인테이크 견과류</p>
                                            <p class="price"><s>43,000원</s><strong>40,850원</strong><span class="rate">5%</span></p>
                                        </div>
                                    </a>
                                </li>
                                <li>
                                    <%if isApp=1 then%>
                                    <a href="" onclick="TnGotoProduct('2065379');return false;">           
                                    <%else%>
                                    <a href="/category/category_itemPrd.asp?itemid=2065379&pEtr=88772" >
                                    <%end if%>                                                                       
                                        <div class="desc">
                                            <p class="name">복순도가</p>
                                            <p class="price"><s>14,900원</s><strong>9,900원</strong><span class="rate">5%</span></p>
                                        </div>
                                    </a>
                                </li>
                                <li>
                                    <%if isApp=1 then%>
                                    <a href="" onclick="TnGotoProduct('1515948');return false;">           
                                    <%else%>
                                    <a href="/category/category_itemPrd.asp?itemid=1515948&pEtr=88772" >
                                    <%end if%>                                                                       
                                        <div class="desc">
                                            <p class="name">달지않은과자</p>
                                            <p class="price"><strong>20,000원</strong><span class="rate">5%</span></p>
                                        </div>
                                    </a>
                                </li>
                                <li>
                                    <%if isApp=1 then%>
                                    <a href="" onclick="TnGotoProduct('1943802');return false;">           
                                    <%else%>
                                    <a href="/category/category_itemPrd.asp?itemid=1943802&pEtr=88772" >
                                    <%end if%>                                                                       
                                        <div class="desc">
                                            <p class="name">오란다</p>
                                            <p class="price"><strong>55,000원</strong><span class="rate">5%</span></p>
                                        </div>
                                    </a>
                                </li>
                                <li>
                                    <%if isApp=1 then%>
                                    <a href="" onclick="TnGotoProduct('2076005');return false;">           
                                    <%else%>
                                    <a href="/category/category_itemPrd.asp?itemid=2076005&pEtr=88772" >
                                    <%end if%>                                                                       
                                        <div class="desc">
                                            <p class="name">배도가</p>
                                            <p class="price"><strong>24,000원</strong></p>
                                        </div>
                                    </a>
                                </li>										
                            </ul>
                        </div>
                        <%if isApp=1 then%>
                            <a href="" onclick="fnAPPpopupBrowserURL('기획전','<%= wwwUrl %>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88774'); return false;" class="btn-more"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/s2_btn.jpg" alt="더 많은 상품 보기" /></a>    
                        <%else%>
                            <a href="/event/eventmain.asp?eventid=88774"  class="btn-more"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/s2_btn.jpg" alt="더 많은 상품 보기" /></a>
                        <%end if%>  
                    </div>

                    <div class="section section3">
                        <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/s3_tit.jpg" alt="" /></p>
                        <div class="rolling rolling3">
                            <div class="swiper-container">
                                <div class="swiper-wrapper">
                                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/img_slide3_1.jpg" alt="" /></div>
                                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/img_slide3_2.jpg" alt="" /></div>
                                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/img_slide3_3.jpg" alt="" /></div>
                                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/img_slide3_4.jpg" alt="" /></div>
                                </div>
                            </div>
                            <div class="pagination"></div>
                            <button type="button" class="slideNav btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87026/m/btn_prev.png" alt="이전" /></button>
                            <button type="button" class="slideNav btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87026/m/btn_next.png" alt="다음" /></button>
                        </div>
                        <div class="item-list" id="itemList3">
                            <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/s3_item.jpg" alt="" /></p>
                            <ul>
                                <li>
                                    <%if isApp=1 then%>
                                    <a href="" onclick="TnGotoProduct('2076011');return false;">           
                                    <%else%>
                                    <a href="/category/category_itemPrd.asp?itemid=2076011&pEtr=88772" >
                                    <%end if%>                                
                                    
                                        <div class="desc">
                                            <p class="name">삼근삼근</p>
                                            <p class="price"><strong>35,000원</strong><span class="rate">5%</span></p>
                                        </div>
                                    </a>
                                </li>
                                <li>
                                    <%if isApp=1 then%>
                                    <a href="" onclick="TnGotoProduct('1792350');return false;">           
                                    <%else%>
                                    <a href="/category/category_itemPrd.asp?itemid=1792350&pEtr=88772" >
                                    <%end if%>                                
                                    
                                        <div class="desc">
                                            <p class="name">인시즌</p>
                                            <p class="price"><s>43,000원</s><strong>40,850원</strong><span class="rate">5%</span></p>
                                        </div>
                                    </a>
                                </li>
                                <li>
                                    <%if isApp=1 then%>
                                    <a href="" onclick="TnGotoProduct('1468740');return false;">           
                                    <%else%>
                                    <a href="/category/category_itemPrd.asp?itemid=1468740&pEtr=88772" >
                                    <%end if%>                                

                                        <div class="desc">
                                            <p class="name">당산나무 꿀</p>
                                            <p class="price"><s>14,900원</s><strong>9,900원</strong><span class="rate">5%</span></p>
                                        </div>
                                    </a>
                                </li>
                                <li>
                                    <%if isApp=1 then%>
                                    <a href="" onclick="TnGotoProduct('2068534');return false;">           
                                    <%else%>
                                    <a href="/category/category_itemPrd.asp?itemid=2068534&pEtr=88772" >
                                    <%end if%>                                

                                        <div class="desc">
                                            <p class="name">마이팬트리</p>
                                            <p class="price"><strong>20,000원</strong><span class="rate">5%</span></p>
                                        </div>
                                    </a>
                                </li>
                                <li>
                                    <%if isApp=1 then%>
                                    <a href="" onclick="TnGotoProduct('2063632');return false;">           
                                    <%else%>
                                    <a href="/category/category_itemPrd.asp?itemid=2063632&pEtr=88772" >
                                    <%end if%>                                

                                        <div class="desc">
                                            <p class="name">쌍화청</p>
                                            <p class="price"><strong>55,000원</strong><span class="rate">5%</span></p>
                                        </div>
                                    </a>
                                </li>
                                <li>
                                    <%if isApp=1 then%>
                                    <a href="" onclick="TnGotoProduct('1549045');return false;">           
                                    <%else%>
                                    <a href="/category/category_itemPrd.asp?itemid=1549045&pEtr=88772" >
                                    <%end if%>                                

                                        <div class="desc">
                                            <p class="name">꿀건달</p>
                                            <p class="price"><strong>24,000원</strong></p>
                                        </div>
                                    </a>
                                </li>										
                            </ul>
                        </div>
                        <%if isApp=1 then%>
                        <a href="" onclick="fnAPPpopupBrowserURL('기획전','<%= wwwUrl %>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88775'); return false;" class="btn-more"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/s3_btn.jpg" alt="더 많은 상품 보기" /></a>    
                        <%else%>
                        <a href="/event/eventmain.asp?eventid=88775" class="btn-more"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/s3_btn.jpg" alt="더 많은 상품 보기" /></a>
                        <%end if%>                          
                        
                    </div>

                    <div class="section section4">
                        <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/s4_tit.jpg" alt="" /></p>
                        <div class="rolling rolling4">
                            <div class="swiper-container">
                                <div class="swiper-wrapper">
                                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/img_slide4_1.jpg" alt="" /></div>
                                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/img_slide4_2.jpg" alt="" /></div>
                                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/img_slide4_3.jpg" alt="" /></div>
                                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/img_slide4_4.jpg" alt="" /></div>
                                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/img_slide4_5.jpg" alt="" /></div>
                                </div>
                            </div>
                            <div class="pagination"></div>
                            <button type="button" class="slideNav btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87026/m/btn_prev.png" alt="이전" /></button>
                            <button type="button" class="slideNav btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87026/m/btn_next.png" alt="다음" /></button>
                        </div>
                        <div class="item-list" id="itemList4">
                            <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/s4_item.jpg" alt="" /></p>
                            <ul>
                                <li>
                                    <%if isApp=1 then%>
                                    <a href="" onclick="TnGotoProduct('2032482');return false;">           
                                    <%else%>
                                    <a href="/category/category_itemPrd.asp?itemid=2032482&pEtr=88772" >
                                    <%end if%>                                

                                        <div class="desc">
                                            <p class="name">쌀 선물</p>
                                            <p class="price"><strong>35,000원</strong><span class="rate">5%</span></p>
                                        </div>
                                    </a>
                                </li>
                                <li>
                                    <%if isApp=1 then%>
                                    <a href="" onclick="TnGotoProduct('2071652');return false;">           
                                    <%else%>
                                    <a href="/category/category_itemPrd.asp?itemid=2071652&pEtr=88772" >
                                    <%end if%>                                

                                        <div class="desc">
                                            <p class="name">부엉이곳간</p>
                                            <p class="price"><s>43,000원</s><strong>40,850원</strong><span class="rate">5%</span></p>
                                        </div>
                                    </a>
                                </li>
                                <li>
                                    <%if isApp=1 then%>
                                    <a href="" onclick="TnGotoProduct('1199665');return false;">           
                                    <%else%>
                                    <a href="/category/category_itemPrd.asp?itemid=1199665&pEtr=88772" >
                                    <%end if%>                                

                                        <div class="desc">
                                            <p class="name">인테이크 향신료</p>
                                            <p class="price"><s>14,900원</s><strong>9,900원</strong><span class="rate">5%</span></p>
                                        </div>
                                    </a>
                                </li>
                                <li>
                                    <%if isApp=1 then%>
                                    <a href="" onclick="TnGotoProduct('2066844');return false;">           
                                    <%else%>
                                    <a href="/category/category_itemPrd.asp?itemid=2066844&pEtr=88772" >
                                    <%end if%>                                

                                        <div class="desc">
                                            <p class="name">존쿡</p>
                                            <p class="price"><strong>20,000원</strong><span class="rate">5%</span></p>
                                        </div>
                                    </a>
                                </li>
                                <li>
                                    <%if isApp=1 then%>
                                    <a href="" onclick="TnGotoProduct('1780968');return false;">           
                                    <%else%>
                                    <a href="/category/category_itemPrd.asp?itemid=1780968&pEtr=88772">
                                    <%end if%>                                

                                        <div class="desc">
                                            <p class="name">인테이크 모닝죽</p>
                                            <p class="price"><strong>55,000원</strong><span class="rate">5%</span></p>
                                        </div>
                                    </a>
                                </li>
                                <li>
                                    <%if isApp=1 then%>
                                    <a href="" onclick="TnGotoProduct('1421167');return false;">           
                                    <%else%>
                                    <a href="/category/category_itemPrd.asp?itemid=1421167&pEtr=88772" >
                                    <%end if%>                                

                                        <div class="desc">
                                            <p class="name">며느리 참기름</p>
                                            <p class="price"><strong>24,000원</strong></p>
                                        </div>
                                    </a>
                                </li>										
                            </ul>
                        </div>
                        <%if isApp=1 then%>
                        <a href="" onclick="fnAPPpopupBrowserURL('기획전','<%= wwwUrl %>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88776'); return false;" class="btn-more"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/s4_btn.jpg" alt="더 많은 상품 보기" /></a>    
                        <%else%>
                        <a href="/event/eventmain.asp?eventid=88776"  class="btn-more"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/s4_btn.jpg" alt="더 많은 상품 보기" /></a>
                        <%end if%>          
                    </div>
                </div><!-- // givingContainer -->

                <div class="bnr-area">
                        <%if isApp=1 then%>
                        <a href="" onclick="fnAPPpopupBrowserURL('기획전','<%= wwwUrl %>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88779'); return false;" class="bnr1"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/bnr1.jpg" alt="명절 요리가 쉬워지는 전지적 요리 시점"></a>
                        <a href="" onclick="fnAPPpopupBrowserURL('기획전','<%= wwwUrl %>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88897'); return false;" class="bnr2"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/bnr2.jpg" alt="부모님도 춤추게 하는 용돈 봉투"></a>
                        <a href="" onclick="fnAPPpopupBrowserURL('기획전','<%= wwwUrl %>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88849'); return false;" class="bnr3"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/bnr3.jpg" alt="양 손은 무겁지만 마음은 가벼운 추석 선물"></a>
                        <a href="" onclick="fnAPPpopupBrowserURL('기획전','<%= wwwUrl %>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88835'); return false;" class="bnr4"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/bnr4.jpg" alt="온 가족이 모여 앉아 즐거운 놀이 한 판"></a>
                        
                        <%else%>
                        <a href="/event/eventmain.asp?eventid=88779" class="bnr1"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/bnr1.jpg" alt="명절 요리가 쉬워지는 전지적 요리 시점"></a>
                        <a href="/event/eventmain.asp?eventid=88897" class="bnr2"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/bnr2.jpg" alt="부모님도 춤추게 하는 용돈 봉투"></a>
                        <a href="/event/eventmain.asp?eventid=88849" class="bnr3"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/bnr3.jpg" alt="양 손은 무겁지만 마음은 가벼운 추석 선물"></a>
                        <a href="/event/eventmain.asp?eventid=88835" class="bnr4"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/88772/m/bnr4.jpg" alt="온 가족이 모여 앉아 즐거운 놀이 한 판"></a>
                        <%end if%>                   
                </div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->            