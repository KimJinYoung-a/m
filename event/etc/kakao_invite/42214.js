
function teaserCountdown(v){
	today = new Date(Date.parse(today) + (1000+minus_second));	//서버시간에 1초씩 증가
	var todayy=today.getYear()

	if(todayy < 1000)
		todayy+=1900
		
		var todaym=today.getMonth()
		var todayd=today.getDate()
		var todayh=today.getHours()
		var todaymin=today.getMinutes()
		var todaysec=today.getSeconds()
		var todaystring=montharray[todaym]+" "+todayd+", "+todayy+" "+todayh+":"+todaymin+":"+todaysec

		//티져종료일자		
		futurestring = v

		dd=Date.parse(futurestring)-Date.parse(todaystring)
		dday=Math.floor(dd/(60*60*1000*24)*1)
		dhour=Math.floor((dd%(60*60*1000*24))/(60*60*1000)*1)
		dmin=Math.floor(((dd%(60*60*1000*24))%(60*60*1000))/(60*1000)*1)
		dsec=Math.floor((((dd%(60*60*1000*24))%(60*60*1000))%(60*1000))/1000*1)

		if(dd = 0)
		{
			alert(dd);
			location.reload();
		}

		//alert(dhour);

		if(dhour < 10)
		{
			dhour = "0" + dhour;
		}
		if(dmin < 10)
		{
			dmin = "0" + dmin;
		}
		if(dsec < 10)
		{
			dsec = "0" + dsec;
		}
		
		if(tmp_hh != dhour)
		{
			if(String(tmp_hh).substring(0,1) != String(dhour).substring(0,1))
			{
				fnTeaserPutNumImg("hour1",String(dhour).substring(0,1),"h1");
			}
			fnTeaserPutNumImg("hour2",String(dhour).substring(2,1),"h2");
		}
		if(tmp_mm != dmin)
		{
			if(String(tmp_mm).substring(0,1) != String(dmin).substring(0,1))
			{
				fnTeaserPutNumImg("minute1",String(dmin).substring(0,1),"m1");
			}
			fnTeaserPutNumImg("minute2",String(dmin).substring(2,1),"m2");
		}

		if(String(tmp_ss).substring(0,1) != String(dsec).substring(0,1))
		{
			fnTeaserPutNumImg("second1",String(dsec).substring(0,1),"s1");
		}
		fnTeaserPutNumImg("second2",String(dsec).substring(2,1),"s2");
		
		tmp_hh = dhour;
		tmp_mm = dmin;
		tmp_ss = dsec;
		minus_second = minus_second + 1;

	setTimeout("teaserCountdown(futurestring)",1000)
}


function fnTeaserPutNumImg(fitm,no,param) {
	var frm = document.getElementById(fitm);
	frm.src="http://webimage.10x10.co.kr/eventIMG/2013/42214//ddodak_teaser_num" + no + ".gif?t="+param+"";
}


function countdown(v){
	today = new Date(Date.parse(today) + (1000+minus_second));	//서버시간에 1초씩 증가
	var todayy=today.getYear()

	if(todayy < 1000)
		todayy+=1900
		
		var todaym=today.getMonth()
		var todayd=today.getDate()
		var todayh=today.getHours()
		var todaymin=today.getMinutes()
		var todaysec=today.getSeconds()
		var todaystring=montharray[todaym]+" "+todayd+", "+todayy+" "+todayh+":"+todaymin+":"+todaysec
		//futurestring=montharray[mo-1]+" "+da+", "+yr+" 11:59:59";

		//이벤트종료일자
		futurestring = v

		dd=Date.parse(futurestring)-Date.parse(todaystring)
		dday=Math.floor(dd/(60*60*1000*24)*1)
		dhour=Math.floor((dd%(60*60*1000*24))/(60*60*1000)*1)
		dmin=Math.floor(((dd%(60*60*1000*24))%(60*60*1000))/(60*1000)*1)
		dsec=Math.floor((((dd%(60*60*1000*24))%(60*60*1000))%(60*1000))/1000*1)

		//alert(dhour);

		if(dday < 1)
		{
			document.getElementById("limittime").style.display = "none";
			document.getElementById("limittimeend").style.display = "block";
		}

		if(dhour < 10)
		{
			dhour = "0" + dhour;
		}
		if(dmin < 10)
		{
			dmin = "0" + dmin;
		}
		if(dsec < 10)
		{
			dsec = "0" + dsec;
		}
		
		if(tmp_hh != dhour)
		{
			if(String(tmp_hh).substring(0,1) != String(dhour).substring(0,1))
			{
				fnPutNumImg("hour11",String(dhour).substring(0,1),"h11");
			}
			fnPutNumImg("hour22",String(dhour).substring(2,1),"h22");
		}
		if(tmp_mm != dmin)
		{
			if(String(tmp_mm).substring(0,1) != String(dmin).substring(0,1))
			{
				fnPutNumImg("minute11",String(dmin).substring(0,1),"m11");
			}
			fnPutNumImg("minute22",String(dmin).substring(2,1),"m22");
		}

		if(String(tmp_ss).substring(0,1) != String(dsec).substring(0,1))
		{
			fnPutNumImg("second11",String(dsec).substring(0,1),"s11");
		}
		fnPutNumImg("second22",String(dsec).substring(2,1),"s22");
		
		tmp_hh = dhour;
		tmp_mm = dmin;
		tmp_ss = dsec;
		minus_second = minus_second + 1;

	setTimeout("countdown(futurestring)",1000)
}


function fnPutNumImg(fitm,no,param) {
	var frm = document.getElementById(fitm);
	frm.src="http://webimage.10x10.co.kr/eventIMG/2013/42214//ddodak_num" + no + ".gif?t="+param+"";
}
