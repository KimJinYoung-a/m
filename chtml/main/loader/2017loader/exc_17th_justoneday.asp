<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/main/main_just1day.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
response.charset = "utf-8"
'#######################################################
' Discription : 주년 just1day
' History : 2018-10-12 최종원
'#######################################################
Dim gaParam, testdate, gaparam1
gaparam1 = "main_just1day17th_1"
gaparam = "main_just1day17th_"
testdate = request("testdate")
%>
			<% if not ((date() = "2018-10-20") or (date() = "2018-10-21") or (date() = "2018-10-27") or (date() = "2018-10-28")) then %>
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
				//===========================================메인 영역 랜더링===============================================
				if(typeof(message.today)=="object") {
					var fullurl = "http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid="+message.today.specialItemCode+"&gaparam=<%=gaparam1%>"
					//날짜 렌더링				
					if(message.today.date!=""){
						nowDt = new Date(message.today.date);									
						customDate = nowDt.format('MM')+"월 "+nowDt.format('dd')+"일";												
						countdown();
					}
					//오늘의 특가 렌더링									
					$("#todaySpecialItemInfo .thumbnail img").attr("src","http://webimage.10x10.co.kr/fixevent/event/2018/today/10"+vDate+"/m/img_item.jpg?v=2.0").attr("alt",message.today.itemname); //이미지
					$("#todaySpecialItemInfo .name").html(message.today.itemname);		//이름
					$("#17thSpecialItems .multi-head .date").html(customDate); // 날짜
					
					<% If isapp = "1" Then %>
						$("#todaySpecialItemLink").click(function(){																					
							fnAmplitudeEventMultiPropertiesAction('click_17th_todayspecial_main_item','itemname|itemcode',message.today.itemname+"|"+message.today.specialItemCode, function(bool){if(bool) {fnAPPpopupProduct_URL(fullurl);}});							
						})						
					<% else %>
						$("#todaySpecialItemLink").attr("href","/category/category_itemPrd.asp?itemid="+message.today.specialItemCode+"&gaparam=<%=gaparam1%>");	//랜딩url
						$("#todaySpecialItemLink").click(function(){
							fnAmplitudeEventMultiPropertiesAction("click_17th_todayspecial_main_item","itemname|itemcode",message.today.itemname+"|"+message.today.specialItemCode);
						})						
					<% end if %>
					

					if(message.today.itemdiv == 21){
						$("#todaySpecialItemInfo .sum").html(message.today.specialItemDealSalePrice+"~");
						$("#todaySpecialItemSaleper").html(message.today.specialItemDealSalePer);							
					}else{
						$("#todaySpecialItemInfo .sum").html(message.today.sellprice);
						$("#todaySpecialItemSaleper").html(message.today.saleper);	
					}
					
					
				}
			
				// 브랜드 리스트 렌더링
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
							$("#17thBrnadEventList li .thumbnail img").eq(i).attr('src', "http://webimage.10x10.co.kr/fixevent/event/2018/today/10"+vDate+"/m/img_brand_0"+parseInt(i+1)+".jpg?v=2.0");	//이미지
							$("#17thBrnadEventList li .name").eq(i).html(this.brandKoreanName);			//이름
							$("#17thBrnadEventList li .eng").eq(i).html(this.brandCopy);			//이름
							$("#17thBrnadEventList li .17brand-discount").eq(i).html(this.brandSalePer);			//이름
							<% If isapp = "1" Then %>
								if (this.linktype == "1"){																										
									$("#17thBrnadEventList li a").eq(i).click(function(){	
										fnAmplitudeEventMultiPropertiesAction('click_17th_todayspecial_main_brandlist','brandname',brname, function(bool){if(bool) {fnAPPpopupProduct_URL(fullurl);}});																									
									})
								}else{
									$("#17thBrnadEventList li a").eq(i).click(function(){	
										fnAmplitudeEventMultiPropertiesAction('click_17th_todayspecial_main_brandlist','brandname',brname, function(bool){if(bool) {fnAPPpopupBrowserURL('기획전', fullurl);}});																									
									})
								}
							<% else %>
								if (this.linktype == "1"){
									$("#17thBrnadEventList li a").eq(i).attr('href', "http://m.10x10.co.kr/category/category_itemPrd.asp?itemid=" + this.evtcode+'&gaparam=<%=gaparam%>'+parseInt(i+2));
								}else{
									$("#17thBrnadEventList li a").eq(i).attr('href', "http://m.10x10.co.kr/event/eventmain.asp?eventid=" + this.evtcode+'&gaparam=<%=gaparam%>'+parseInt(i+2));
								}
								//랜딩url
								$("#17thBrnadEventList li a").eq(i).click(function(){
									fnAmplitudeEventMultiPropertiesAction("click_17th_todayspecial_main_brandlist","brandname",brname);									
								})									
							<% end if %>							
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
	//var futurestring=montharray[todaym]+" "+(todayd+1)+", "+todayy+" 00:00:00";
	var futurestring="Nov 01, 2018 00:00:00"

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
	$("#time").html(dhour+":"+dmin+":"+dsec+"&nbsp;<s>남음</s>");
	
	setTimeout("countdown()",500);
}
</script>
			<!-- just one day 17th (10/15~31) -->
			<section class="time-sale-17th" id="17thSpecialItems">
				<div class="multi-head">
					<em class="date"></em>
					<h2 class="headline ftLt">오늘의 특가</h2>
					<span class="time ftLt" id="time"></span>
				</div>

				<div class="weekday items" id="todaySpecialItemInfo">
					<div class="thumbnail"><img src="" alt="" /></div><%'<div class="soldout">SOLD OUT</div>%>
					<div class="desc">
						<b class="discount color-red" id="todaySpecialItemSaleper"></b>
						<p class="name"></p>
						<div class="price"><b class="sum"><span class="won">원</span></b></div>
					</div>
					<a id="todaySpecialItemLink" ></a>
				</div>

				<div class="weekend">
					<ul class="items" id="17thBrnadEventList">
						<li>
							<a href="#" class="">
								<div class="thumbnail"><img src="" alt="" /></div>
								<div class="desc">
									<p class="name"></p>
									<p class="eng"></p>
									<b class="discount color-red 17brand-discount"></b>
								</div>
							</a>							
						</li>
						<li>
							<a href="#" class="">
								<div class="thumbnail"><img src="" alt="" /></div>
								<div class="desc">
									<p class="name"></p>
									<p class="eng"></p>
									<b class="discount color-red 17brand-discount"></b>
								</div>
							</a>
						</li>
						<li>
							<a href="#" class="">
								<div class="thumbnail"><img src="" alt="" /></div>
								<div class="desc">
									<p class="name"></p>
									<p class="eng"></p>
									<b class="discount color-red 17brand-discount"></b>
								</div>
							</a>							
						</li>
					</ul>
				</div>
			</section>
			<% end if %>
<!-- #include virtual="/lib/db/dbclose.asp" -->