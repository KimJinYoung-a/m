/*
    ## 기획전 타이머 플러그인
    ## 2020.07.16; 임보라
    -----------------------------
    * 사용법
    <script type="text/javascript">
    countDownEventTimer({
        eventid: 104412,
        useDay: true
    });
    </script>
*/

// 날짜 변환
Date.prototype.formatDate = function(f) {
    if (!this.valueOf()) return "";

    var d = this;

    return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function($1) {
        switch ($1) {
            case "yyyy": return d.getFullYear();
            case "yy": return (d.getFullYear() % 1000).zf(2);
            case "MM": return (d.getMonth() + 1).zf(2);
            case "dd": return d.getDate().zf(2);
            case "E": return weekName[d.getDay()];
            case "HH": return d.getHours().zf(2);
            case "hh": return ((h = d.getHours() % 12) ? h : 12).zf(2);
            case "mm": return d.getMinutes().zf(2);
            case "ss": return d.getSeconds().zf(2);
            case "a/p": return d.getHours() < 12 ? "오전" : "오후";
            default: return $1;
        }
    });
}
String.prototype.dateString = function(len){var s = '', i = 0; while (i++ < len) { s += this; } return s;};
String.prototype.zf = function(len){return "0".dateString(len - this.length) + this;};
Number.prototype.zf = function(len){return this.toString().zf(len);};

function countDownEventTimer(opts) {
    var eventid = opts.eventid;
    var eventStartdate = '';
    var eventEnddate = '';
    $.ajax({
        type:"GET",
        url:"/event/etc/json/act_eventinfo.asp?eventid="+eventid,
        dataType: "text",
        async:false,
        cache:true,
        success : function(Data, textStatus, jqXHR){
            if (jqXHR.readyState == 4) {
                if (jqXHR.status == 200) {
                    if (Data!="") {
                        var result = JSON.parse(Data);
                        eventStartdate = result.events.startdate;
                        eventEnddate = result.events.enddate;
                    } else {
                        alert("잘못된 접근 입니다.");
                        return false;
                    }
                }
            }
        },
        error : function(jqXHR, textStatus, errorThrown){
            alert("잘못된 접근 입니다.");
            return false;
        }
    });

    var eventStartTime = new Date(eventStartdate);
    var eventEndTime = new Date(eventEnddate);
    var timerID;
    var startTime = new Date();
    var time = Math.floor((eventEndTime.getTime() - startTime.getTime()) / 1000);
    if (startTime < eventEndTime) {
        start_timer();
    } else {
        $("#day, #hour, #min, #sec").text("00");
    }
    function start_timer() {
        decrementTime();
        timerID = setInterval(decrementTime, 1000);
    }
    function decrementTime() {
        if(time > 0) time--;
        else clearInterval(timerID);
        toHourMinSec(time);
    }
    function toHourMinSec(t) {
        var day = 0;
        var hour = Math.floor(t / 3600);
        var min = Math.floor( (t-(hour*3600)) / 60 );
        var sec = t - (hour*3600) - (min*60);
        if (opts.useDay) {
            if (hour > 23) {
                day = Math.floor(hour / 24);
                hour = hour % 24;
            }
            if (day == 0) {
                $("#day").text("DAY");
            } else { 
                $("#day").text(day < 10 ? "0" + day : day);
            }
        }
        $("#hour").text(hour>99 ? 99 : hour < 10 ? "0" + hour : hour);
        $("#min").text(min < 10 ? "0" + min : min);
        $("#sec").text(sec < 10 ? "0" + sec : sec);
    }

    var actionStartDateElement = $("#evtStartDate");
    var actionEndDateElement = $("#evtEndDate");
    if (actionStartDateElement.length > 0) {
        actionStartDateElement.text(new Date(eventStartdate).formatDate("yyyy. MM. dd"));
    }
    if (actionEndDateElement.length > 0) {
        actionEndDateElement.text(new Date(eventEnddate).formatDate("yyyy. MM. dd"));
    }
}