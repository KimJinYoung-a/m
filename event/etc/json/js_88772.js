var nowDt;
var montharray=new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
var minus_second = 0;

$(function(){
	$.ajax({
		type: "get",
		url: "/event/etc/json/act_88772_thgv.asp",
		data: "",
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
					$("#lyrTodayGift a").attr("href","/shopping/category_prd.asp?itemid="+message.today.itemid);
					$("#lyrTodayGift .name").html(message.today.itemname);
					if(message.today.saleper!="") {
						$("#lyrTodayGift .price").html("<s>"+message.today.orgprice+"</s> "+message.today.sellprice+" ["+message.today.saleper+"]");
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



