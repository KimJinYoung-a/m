/*
#######################################################
	History	:  2008.12.22 허진원 생성
	           2012.03.14 스크립트 수정/이전
	Description : 검색어 자동완성 Java Script
#######################################################
*/

// 입력창 키처리
function fnKeyInput() {
	fnAutoCompLayer('on');
}

var strCont, strHead, strFoot;

//레이어 머릿글
//strHead = "<p class='kwdType'>추천검색어</p><ul>";
strHead = "<ul>";
//레이어 꼬릿글
strFoot = "</ul>";

//자동완성 실행
function fnAutoCompLayer(key) {
	var frm = document.searchForm;

	// 자동완성 레이어 내용 작성
	if(!frm.rect.value) {
		strCont = strHead + "<li>검색어 자동완성 기능을 <b>사용하고</b> 계십니다.</li>" + strFoot;
	} else {
		// XML로딩
		$.ajax({
			type: "GET",
			url: "/search/inc_autoComplete.asp",
			data:"str=" + frm.rect.value,
			dataType: "xml",
			cache: false,
			async: true,
			timeout: 5000,
			beforeSend: function(x) {
				if(x && x.overrideMimeType) {
					x.overrideMimeType("text/xml;charset=utf-8");
				}
			},
			success: function(xml) {

				if($(xml).find("categoryPage").find("item").length>0) {

					var result="";

					// item노드 Loop
					$(xml).find("categoryPage").find("item").each(function(idx) {
						result+= "<li onClick='selectText(this.innerText);fnSACLayerOnOff(false);' style='cursor:pointer'>";
						result+= convTxtColor($(this).find("Word").text(),$(this).find("Seed").text(),$(this).find("Conv").text());
						result+= "</li>";
					});
					strCont= strHead + result + strFoot;

					//자동완성 레이어 출력
					$("#atl").html(strCont);
					if(strCont!=(strHead+strFoot)) fnSACLayerOnOff(true);
					else fnSACLayerOnOff(false);
				}
			},
			error: function(xhr, status, error) {/*alert(xhr + '\n' + status + '\n' + error);*/}
		});
	}

	//자동완성 레이어 닫기
	if(!(($("#lyrAutoComp").css("display")=="none"||key=="on")&&(frm.rect.value||key=="off"))) {
		$("#atl").empty();
		fnSACLayerOnOff(false);
	}
}

//레이어on/off
function fnSACLayerOnOff(sw) {
	if(sw) {
		 if($("#atl").html()) $("#lyrAutoComp").fadeIn("fast");
	}
	else $("#lyrAutoComp").fadeOut("fast");
}

//시간차 레이어 닫기
var hide_SACLayer_started = false;
function HideSACLayer() {
    hide_SACLayer_started = true;
    setTimeout("DoHideSACLayer()", 200);
}
function DoHideSACLayer() {
    if (hide_SACLayer_started == true) {
	    fnSACLayerOnOff(false);
	}
	hide_SACLayer_started = false;
}
function CancelHideSACLayer() {
    hide_SACLayer_started = false;
}

//결과에서 검색창으로..
function selectText(txt) {
	document.searchForm.rect.value=txt;
	document.searchForm.submit();
}

//선택 문자 색전환
function convTxtColor(sO,sS,sC) {
	if(sC=="null") {
		return sO.replace(sS,"<em class='cRd1'>"+sS+"</em>");
	} else {
		return sO.replace(sC,"<em class='cRd1'>"+sC+"</em>");
	}
}
