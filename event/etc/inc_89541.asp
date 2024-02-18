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
dim eCode
Dim gaParam, testdate, gaparam1

testdate = request("testdate")
gaparam1 = "main_just1day17th_1"
gaparam = "main_just1day17th_"


IF application("Svr_Info") = "Dev" THEN
	eCode = "89178"
Else
	eCode = "89541"
End If
%>
<style type="text/css">
.mEvt89541{background-color:#e53fac; min-width:260px}
.mEvt89541 .rate {position:relative;}
.mEvt89541 .rate p {font-family: 'AppleSDGothic-Bold','malgun gothic'; font-weight: bold; font-size: 2.3rem; color: #fff; position: absolute; left: 68.8%; top: 11%; width: 19%; text-align: center;  letter-spacing: -0.14rem; text-shadow: -1px 0 #000, 0 1px #000, 1px 0 #000, 0 -1px #000, 2px 2px #000;}
.mEvt89541 .today {position:relative;}
.mEvt89541 .today ul{position:absolute; top:0; width:100%; text-align:center;}
.mEvt89541 .today ul li{font-family: 'appleSDGothicBold','malgun gothic',sans-serif;font-weight:bold;color:#000;line-height: 1.4em; text-align:center;    line-height: 1.3em;}
/* .mEvt89541 .today ul li.day {letter-spacing:1px; font-size: 1.2rem; line-height:1.8rem;} */
.mEvt89541 .today ul li.day span{width: 100%; display: block; margin-top: -5%;}
.mEvt89541 .today ul li.name {font-size:1.3rem; margin-top:1em;}
.mEvt89541 .today ul li.ex-price {font-size:1.2rem; font-weight:normal; display:inline-block; position:relative; padding:0 5px; margin-right:0.5rem;}
.mEvt89541 .today ul li.ex-price:after{content:'';position:absolute;width:100%;background-color:#000;height:1px; top:50%; left:0;}
.mEvt89541 .today ul li.price {font-size:1.4rem; display:inline-block;}
.mEvt89541 .today ol {position: absolute; bottom: 4.5rem; width:100%;}
.mEvt89541 .today ol li a{width:69%; display:block; margin:auto;}               
.mEvt89541 .brand {position:relative; background-color: #52d9ae; margin-top: -1px}
.mEvt89541 .brand .inner{position:absolute;top:10rem;width:100%;}
.mEvt89541 .brand .inner a{display:block; width:90%; margin:0 auto 1rem; position:relative;}
.mEvt89541 .brand .inner span{position:absolute; top:50%; left:1rem; background-color:#eb1d1d; color:#fff; font-family: 'appleSDGothicBold','malgun gothic',sans-serif;font-weight:bold;font-size: 1.3rem; padding: 0.3rem 0.7rem 0.4rem 0.5rem; border-radius: 20px;}
#lyrSch .layer {top:2rem; min-width:207px}
.mEvt89541 .layer-popup {display:none; position:absolute; left:0; top:0; z-index:9997; width:100%; height:100%;}
.mEvt89541 .layer-popup .layer {overflow:hidden; position:absolute; left:7%; top:0; z-index:99999; width:86%; background:#f6f3f5; border-radius:1.3rem;}
.mEvt89541 .layer-popup .layer .btn-close {position:absolute; right:0; top:0; width:16%; background-color:transparent;}
.mEvt89541 .layer-popup .mask {display:block; position:absolute; left:0; top:0; z-index:9998; width:100%; height:100%; background:rgba(0,0,0,.6);}
.mEvt89541 .layer-popup .scroll{height: 35rem;overflow-y: scroll;}
.mEvt89541 .layer-popup h3{padding:4rem 0 1.8rem}
.mEvt89541 .layer-popup .calendar{padding-top:1rem;}
.mEvt89541 .layer-popup ul{padding:0 3% 0 5%;}
.mEvt89541 .layer-popup li{width:32%;display:inline-block;margin:0 0 1rem; position:relative;}
.mEvt89541 .layer-popup li p{display: none;}
.mEvt89541 .layer-popup li span{overflow: hidden; display: inline-block;}
.mEvt89541 .layer-popup li span img{width: 200%;}
.mEvt89541 .layer-popup li.soldout:after {position:absolute; top:0; left:0; content:''; background-image:url('http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/img_pop_cal_end.png'); background-size:cover; width:100%; height:100%;}
.mEvt89541 .layer-popup li.now span img{transform: translateX(-50%);}
.mEvt89541 .layer-popup li.comming {opacity:0.5;}
</style>
<script type="text/javascript">
$(function(){
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
</script>
<script>

var nowDt;
var customDate
var montharray=new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
var minus_second = 0;
var today = new Date();
var dd = today.getDate();			
var testparam = getQuerystring("testdate");		
var link = document.location.href;
var vDate = dd.toString();

if(dd == 27 || dd == 28){	
	var vDate = 29
}

if(testparam){	
	vDate = testparam.substring(testparam.length - 2, testparam.length);	
}
function getQuerystring(paramName){
	var _tempUrl = window.location.search.substring(1); 		
	if(_tempUrl != ""){
		var _tempArray = _tempUrl.split('&');		

		for(var i = 0; i < _tempArray.length; i++){
			var _keyValuePair = _tempArray[i].split('='); 			
			if(_keyValuePair[0] == paramName){
		 	return _tempUrl;
		   } 
	    } 
	}
} 

var link = document.location.href;

$(function(){
	$.ajax({
		type: "get",
		url: "/event/etc/json/act_89541_thgv.asp?testdate=<%=testdate%>",
		data: "",
		cache: false,
		success: function(message) {			
			if(typeof(message)=="object") {
				console.log(message)
				//===========================================이벤트 영역 랜더링===============================================
				// 오늘의 특가 상품 출력
				if(message.today.date!=""){
					nowDt = new Date(message.today.date);									
					customDate = nowDt.format('MM')+"월"+nowDt.format('dd')+"일"+nowDt.format('(KS)');												
				}
				if(typeof(message.today)=="object") {
					//랜딩										
					$("#bg-img img").attr("src", "http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/img_main_10"+vDate+"_v01.png").attr("alt",message.today.itemname);					
					$("#today .name").html(message.today.itemname);
					<% if isApp = 1 then %>						
						$("#todayLink").click(function(){
							if(dd == 20 || dd == 21 || dd == 27 || dd == 28){
								return false;
							}else{
								fnAmplitudeEventMultiPropertiesAction('click_17th_todayspecial_event_item','itemname|itemcode',message.today.itemname+"|"+message.today.specialItemCode, function(bool){if(bool) {fnAPPpopupProduct_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid='+message.today.specialItemCode+'&gaparam=<%=gaparam1%>');}});
							}							
						})									
					<% else %>
						$("#todayLink").attr("href","http://m.10x10.co.kr/category/category_itemPrd.asp?itemid="+message.today.specialItemCode+"&gaparam=<%=gaparam1%>");	//랜딩url			
						$("#todayLink").click(function(){
							fnAmplitudeEventMultiPropertiesAction("click_17th_todayspecial_main_item","itemname|itemcode",message.today.itemname+"|"+message.today.specialItemCode);
						})												
					<% end if %>	
					if(message.today.itemdiv == 21){
						// $("#today .ex-price").html("~"+message.today.specialItemDealsellPrice);
						$("#today .price").html(message.today.specialItemDealSalePrice+"~");
						$("#specialItemSalePer").html(message.today.specialItemDealSalePer);						
						$("#today .ex-price").css("display","none");						
						// $("#today .price").html(message.today.sellprice);
						// $("#specialItemSalePer").html(message.today.saleper);						
					}else{
						$("#today .ex-price").html(message.today.orgprice.replace("원",""));
						if(message.today.isSoldOut != "Y"){ $("#bg-img img").attr("src","http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/img_main_1015_v01_soldout.png").attr("alt","솔드아웃"); }    //품절상품 
						$("#today .price").html(message.today.sellprice);
						$("#specialItemSalePer").html(message.today.saleper);						
					}										
				}
			
				// 브랜드 리스트
				if(typeof(message.brandList)=="object") {
					var i=0;
						$(message.brandList).each(function(){							
							var fullurl = '';
							if (this.linktype == "1"){
								fullurl = '<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid='+this.evtcode+'&gaparam=<%=gaparam%>'+parseInt(i+2);
							}else{
								fullurl = '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid='+this.evtcode+'&gaparam=<%=gaparam%>'+parseInt(i+2);
							}

							var brname = this.brandName;
							$("#brandList a img").eq(i).attr('src', "http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/img_brand_10"+vDate+"_0"+parseInt(i+1)+".png?v=1.01");		//이미지	
							$("#brandList a span").eq(i).html(this.brandSalePer);		//할인율	
							<% if isApp = 1 then %>
								if (this.linktype == "1"){																										
									$("#brandList a").eq(i).click(function(){	
										fnAmplitudeEventMultiPropertiesAction('click_17th_todayspecial_event_brandlist','brandname',brname, function(bool){if(bool) {fnAPPpopupProduct_URL(fullurl);}});																									
									})
								}else{
									$("#brandList a").eq(i).click(function(){	
										fnAmplitudeEventMultiPropertiesAction('click_17th_todayspecial_event_brandlist','brandname',brname, function(bool){if(bool) {fnAPPpopupBrowserURL('기획전', fullurl);}});																									
									})
								}
							<% else %>
								if (this.linktype == "1"){
									$("#brandList a").eq(i).attr('href', "http://m.10x10.co.kr/category/category_itemPrd.asp?itemid=" + this.evtcode+'&gaparam=<%=gaparam%>'+parseInt(i+2));
								}else{
									$("#brandList a").eq(i).attr('href', "http://m.10x10.co.kr/event/eventmain.asp?eventid=" + this.evtcode+'&gaparam=<%=gaparam%>'+parseInt(i+2));
								}
								//랜딩url								
								$("#brandList a").eq(i).click(function(){
									fnAmplitudeEventMultiPropertiesAction("click_17th_todayspecial_event_brandlist","brandname",brname);									
								})											
							<% end if %>							                                         
							i++;
						});					
				}
				// 특가상품 리스트
				if(typeof(message.itemImgList)=="object") {
					var i=0;
					// dd = 29						//날짜 테스트												
					//주말동안
					if(dd == 20 || dd == 21){
						$("#today ul li span img").attr("src", "http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/img_main_date_1022.png?v=0.01")
						$("#todayLink img").attr("src", "http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/btn_soon.png")
						$("#today .ex-price").css("display","none");
						$("#todayLink").click(function(){return false;})
						$("#brand").css("display","none");
						$("#todayLink").click(function(){return false;})
					}else if(dd == 27 || dd == 28){
						$("#today ul li span img").attr("src", "http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/img_main_date_1029.png?v=0.01")
						$("#todayLink img").attr("src", "http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/btn_soon.png")
						$("#today .ex-price").css("display","none");
						$("#todayLink").click(function(){return false;})
						$("#brand").css("display","none");
						$("#todayLink").click(function(){return false;})
					}else{
						$("#today ul li span img").attr("src", "http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/img_main_date_today.png?v=0.01")
					}
					
					$(message.itemImgList).each(function(){						
						var htmlDateValue = $("#itemImgList li").eq(i).val();
						//now, soldout, comming
						if(htmlDateValue == dd){
							$("#itemImgList li").eq(i).attr('class', 'now');	//오늘
						}else if(htmlDateValue < dd){
							$("#itemImgList li").eq(i).attr('class', 'soldout');	//지난날
						}else{
							$("#itemImgList li").eq(i).attr('class', 'comming');	//이미지 없을때
						}						
						i++;
					});					
				}				
				
			}
		},
		error: function(err) {
			console.log(err.responseText);
		}
	});
});

Date.prototype.format = function (f) {

    if (!this.valueOf()) return " ";

    var weekKorName = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
    var weekKorShortName = ["일", "월", "화", "수", "목", "금", "토"];
    var weekEngName = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
    var weekEngShortName = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    var d = this;

    return f.replace(/(yyyy|yy|MM|dd|KS|KL|ES|EL|HH|hh|mm|ss|a\/p)/gi, function ($1) {
        switch ($1) {
            case "yyyy": return d.getFullYear(); // 년 (4자리)
            case "yy": return (d.getFullYear() % 1000).zf(2); // 년 (2자리)
            case "MM": return (d.getMonth() + 1).zf(2); // 월 (2자리)
            case "dd": return d.getDate().zf(2); // 일 (2자리)
            case "KS": return weekKorShortName[d.getDay()]; // 요일 (짧은 한글)
            case "KL": return weekKorName[d.getDay()]; // 요일 (긴 한글)
            case "ES": return weekEngShortName[d.getDay()]; // 요일 (짧은 영어)
            case "EL": return weekEngName[d.getDay()]; // 요일 (긴 영어)
            case "HH": return d.getHours().zf(2); // 시간 (24시간 기준, 2자리)
            case "hh": return ((h = d.getHours() % 12) ? h : 12).zf(2); // 시간 (12시간 기준, 2자리)
            case "mm": return d.getMinutes().zf(2); // 분 (2자리)
            case "ss": return d.getSeconds().zf(2); // 초 (2자리)
            case "a/p": return d.getHours() < 12 ? "오전" : "오후"; // 오전/오후 구분
            default: return $1;
        }
    });
};

String.prototype.string = function (len) { var s = '', i = 0; while (i++ < len) { s += this; } return s; };
String.prototype.zf = function (len) { return "0".string(len - this.length) + this; };
Number.prototype.zf = function (len) { return this.toString().zf(len); };

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
	$("#time").html(dhour+":"+dmin+":"+dsec);
	
	setTimeout("countdown()",500);
}
</script>
			<div class="mEvt89541">
				<h2><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/tit_today.png" alt="오늘의 특가" /></h2>
				<div class="rate">
					<span class="bg-img" id="bg-img"><!-- 투데이 상품 이미지 : 파일명 날짜만 변경--><img src="" alt="오늘의 상품" /></span>
					<p id="specialItemSalePer"><!-- 할인률 --></p>
				</div>
				<div class="today" id="today">
					<span class="bg-img"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/bg_today_v01.png" alt="" /></span>
					<ul>
						<li class="day">
						<span><img src="" alt="today"></span>							
						</li>
						<li class="name"></li><%'<!-- 상품명 -->%>
						<li class="ex-price"></li><%'<!-- 원 가격 -->%>
						<li class="price"></li><%'<!-- 가격 -->%>
					</ul>
					<ol>
						<li>
						<!--
							<a href="#"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/btn_soon.png" alt="comming soon" /></a>
							-->							
							<a href="#" id="todayLink"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/btn_buy.png" alt="구매하러 가기" /></a>							 
						 </li>
						 <li><a href="#" class="btn-schedule"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/btn_taday.png" alt="특가 일정 확인하기" /></a></li>
					</ol>
				</div>
				<div class="brand" id="brand">
					<span class="bg-img"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/bg_brand.png?v=1.01" alt="" /></span>
					<div class="inner" id="brandList">					
						<a href="#">
							<!-- 브랜드 이미지 --><img src="" alt="" />
							<span><!-- 할인률 --></span>	
						</a>
						<a href="#">
							<!-- 브랜드 이미지 --><img src="" alt="" />
							<span><!-- 할인률 --></span>	
						</a>
						<a href="#">
							<!-- 브랜드 이미지 --><img src="" alt="" />
							<span><!-- 할인률 --></span>	
						</a>
					</div>
				</div>
				<!--  for dev msg : 일정 보기 레이어 : 주말동안 비노출-->
				<div id="lyrSch" class="layer-popup">
					<div class="layer">
						<h3><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/tit_pop.png" alt="오늘의 특가 일정표" /></h3>
						<button type="button" class="btn-close" onclick="ClosePopLayer()"><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85145/m/btn_close.png" alt="닫기"></button>
						<div class="calendar scroll">
							<ul id="itemImgList">
								<li class="" value="15">
									<span><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/img_pop_cal_1015.png?v=0.05" alt="" /></span>
								</li>
								<li class="" value="16">
									<span><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/img_pop_cal_1016.png?v=0.05" alt="" /></span>
								</li>
								<li class="" value="17">
									<span><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/img_pop_cal_1017.png?v=0.05" alt="" /></span>
								</li>
								<li class="" value="18">
									<span><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/img_pop_cal_1018.png?v=0.05" alt="" /></span>
								</li>
								<li class="" value="19">
									<span><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/img_pop_cal_1019.png?v=0.05" alt="" /></span>
								</li>
								<li class="" value="22">
									<span><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/img_pop_cal_1022.png?v=0.05" alt="" /></span>
								</li>
								<li class="" value="23">
									<span><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/img_pop_cal_1023.png?v=0.05" alt="" /></span>
								</li>
								<li class="" value="24">
									<span><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/img_pop_cal_1024.png?v=0.05" alt="" /></span>
								</li>
								<li class="" value="25">
									<span><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/img_pop_cal_1025.png?v=0.05" alt="" /></span>
								</li>
								<li class="" value="26">
									<span><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/img_pop_cal_1026.png?v=0.05" alt="" /></span>
								</li>
								<li class="" value="29">
									<span><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/img_pop_cal_1029.png?v=0.05" alt="" /></span>
								</li>
								<li class="" value="30">
									<span><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/img_pop_cal_1030.png?v=0.05" alt="" /></span>
								</li>
								<li class="" value="31">
									<span><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/89541/m/img_pop_cal_1031.png?v=0.05" alt="" /></span>
								</li>
							</ul>
						</div>
					</div>
					<div class="mask"></div>
				</div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->            