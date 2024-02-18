var countDownTimer = function(yr,mo,da,hr,mi,ss,dfd) {
    var defaultYear = yr;
    var defaultMonth = mo;
    var defaultDay = da;
    var defaultHour = hr; 
    var defaultMinute = mi;
    var defaultSecond = ss;
    var defaultToday = dfd;

    var montharray = new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
        
    var minus_second = 0;		// 변경될 증가시간(초)
    var defaultNowDate=new Date();		// 시작시 브라우저 시간
    
    function countdown(){
        var cntDt = new Date(Date.parse(defaultToday) + (1000*minus_second));	//서버시간에 변화값(1초) 증가
        var todayy=cntDt.getYear()
    
        if(todayy < 1000) todayy+=1900;
    
        var todaym = cntDt.getMonth();
        var todayd = cntDt.getDate();
        var todayh = cntDt.getHours();
        var todaymin = cntDt.getMinutes();
        var todaysec = cntDt.getSeconds();
        var todaystring = montharray[todaym]+" "+todayd+", "+todayy+" "+todayh+":"+todaymin+":"+todaysec;
        var futurestring = montharray[defaultMonth-1]+" "+defaultDay+", "+defaultYear+" "+defaultHour+":"+defaultMinute+":"+defaultSecond;
    
        dd=Date.parse(futurestring)-Date.parse(todaystring);
        dday=Math.floor(dd/(60*60*1000*24)*1);
        dhour=Math.floor((dd%(60*60*1000*24))/(60*60*1000)*1);
        dmin=Math.floor(((dd%(60*60*1000*24))%(60*60*1000))/(60*1000)*1);
        dsec=Math.floor((((dd%(60*60*1000*24))%(60*60*1000))%(60*1000))/1000*1);
    
        if(dday < 0) {
            $("#countdown").html("00:00:00");
            return;
        }
        if (dday > 0){
            dhour = parseInt(dhour+(24*dday));
        }
        if(dhour < 10) dhour = "0" + dhour;
        if(dmin < 10) dmin = "0" + dmin;
        if(dsec < 10) dsec = "0" + dsec;
        dhour = dhour+'';
        dmin = dmin+'';
        dsec = dsec+'';

        // Print Time
        if(dhour > 99){
            $("#countdown").html(
                dhour.substr(0,1)+dhour.substr(1,1)+dhour.substr(2,1)
                +":"+
                dmin.substr(0,1)+dmin.substr(1,1)
                +":"+
                dsec.substr(0,1)+dsec.substr(1,1)
                );
        }else{
            $("#countdown").html(
                dhour.substr(0,1)+dhour.substr(1,1)
                +":"+
                dmin.substr(0,1)+dmin.substr(1,1)
                +":"+
                dsec.substr(0,1)+dsec.substr(1,1)
                );
        }

    
        var usrDt=new Date();	// 현재 브라우저 시간
        var vTerm = parseInt(usrDt.getTime()/1000)-parseInt(defaultNowDate.getTime()/1000);	// 시작시 시간과의 차이(초)
        minus_second = vTerm;	// 증가시간에 차이 반영

        if (dd == 0) {
            window.location.reload();
            return;
        }
    
        setTimeout(function() {
            countdown()
        },500);
    }

    return countdown();

};