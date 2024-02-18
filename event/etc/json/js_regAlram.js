function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    return results[2];
}
function isApp(url){		
	return url.indexOf("apps/appcom/wish/") != -1
}
function regAlram(autoPush) {
	var url = window.location.href;		
	var isAutoPush = false
	if(autoPush){
		isAutoPush = true
	}	
	var evtCode = getParameterByName("eventid", url).replace("%20", "");
	if(evtCode == ""){
		return false;
	}	

	var str = $.ajax({
		type: "post",
		url:"/event/etc/doeventsubscript/doEventAlramSubscript.asp",
		data: {
			eCode: evtCode,
			isAutoPush: isAutoPush
		},
		dataType: "text",
		async: false
	}).responseText;	
	
	if(!str){alert("시스템 오류입니다."); return false;}

	var reStr = str.split("|");

	if(reStr[0]=="OK"){		
		if(reStr[1] == "alram"){	//알람신청			
			if(isApp(url)){
				if(reStr[2] == "N"){
					alert("PUSH 알림이 신청되었습니다.\n설정에서 ‘PUSH 수신 동의’를 해주셔야 발송이 가능합니다.");
				}else{
					alert("PUSH 알림이 신청되었습니다.");
				}				
			}else{
				if(reStr[2] == "N"){
					alert("PUSH 알림이 신청되었습니다.\n텐바이텐 앱에서 'PUSH 수신 동의'를 해주세요");
				}else{
					alert("PUSH 알림이 신청되었습니다.");
				}
				
			}			
		}else{			
			alert('오류가 발생했습니다.');
			return false;
		}
	}else{		
		var errorMsg = reStr[1].replace(">?n", "\n");
		alert(errorMsg);
//			document.location.reload();
		return false;
	}		
}
