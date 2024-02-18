/*
#######################################################
	History	:  2008.12.22 허진원 생성
	           2012.03.14 스크립트 수정/이전
	Description : 검색어 자동완성 Java Script
#######################################################
*/

var timer = null;

// 입력창 키처리
function fnKeyInput() {
	var serviceshow = "x";
	if($("#rect").val().length > 1){
		$("#autokeywordad").show();
		serviceshow = "o";
	}else{
		$("#autokeywordad ul").empty();
		$("#autokeywordad").hide();
	}

	if(timer) {
		clearTimeout(timer);
	}
	timer = setTimeout(function() {
		fnAutoCompLayer(serviceshow);
	}, 400);
}

var vBody, strContDisp, strCont, strFoot, strContDispCd, strDiTmp;
vBody = "";
strContDisp = "";
strCont = "";
strContDispCd = "";
strDiTmp = "";


//자동완성 실행
function fnAutoCompLayer(svshow) {	//svshow = serviceshow
	var frm = document.searchForm;
	var rect = $("#rect").val();
	var caresult="";
	var scresult="";
	var brresult="";
	var evresult="";
	var result="";
	var acnt = 0;

	// XML로딩
	$.ajax({
		type: "GET",
		url: "/search/act_autoComplete2017.asp",
		data:"str=" + rect,
		dataType: "xml",
		cache: false,
		async: true,
		timeout: 6000,
		beforeSend: function(x) {
			if(x && x.overrideMimeType) {
				x.overrideMimeType("text/xml;charset=utf-8");
			}
		},
		success: function(xml) {

			if($(xml).find("categoryPage").find("item").length>0) {

				if(svshow == "o"){
					
					//####### [1] 전시카테고리 가져 옴. 베스트가 있으면 베스트 가져옴.
					strDiTmp = jsSearchDispNameList(rect);
					if(strDiTmp != ""){
						strContDispCd = strDiTmp.split("$$")[0];
						strContDisp = strDiTmp.split("$$")[1];
						if(strContDisp != ""){
							$(xml).find("categoryPage").find("item").each(function(idx) {
								if($(this).find("meta2").text().split("$$")[0] == "ca" && $(this).find("meta2").text().split("$$")[1] == "best"){	//카테고리 & 베스트
									caresult+= "<li class='category' onClick=top.location.href='/category/category_list.asp?disp="+strContDispCd+"&pNtr=qc_"+encodeURIComponent(rect)+"';fnAmplitudeEventMultiPropertiesAction('click_search','action|keyword|searchkeyword|view','category|"+rect.replace(/ /gi,'%20')+"|"+rect.replace(/ /gi,'%20')+"|"+$(this).find("searchviewType").text()+"');return false;>";
									caresult+= "<a href='' onClick='return false;'><span class='sum'>카테고리</span> <div class='desc'>";
									//caresult+= strContDisp;
									caresult+= convTxtColor(strContDisp,$(this).find("Seed").text(),$(this).find("Conv").text());
									caresult+= " <span class='label label-line'>BEST</span></div></a></li>";
									return false;
								}
							});
						}
						
						//베스트 없는경우 그냥 한개 가져옴.
						if(caresult == "" && strContDisp != ""){
							$(xml).find("categoryPage").find("item").each(function(idx) {
								if($(this).find("meta2").text().split("$$")[0] == "ca"){	//카테고리
									caresult+= "<li class='category' onClick=top.location.href='/category/category_list.asp?disp="+strContDispCd+"&pNtr=qc_"+encodeURIComponent(rect)+"';fnAmplitudeEventMultiPropertiesAction('click_search','action|keyword|searchkeyword|view','category|"+rect.replace(/ /gi,'%20')+"|"+rect.replace(/ /gi,'%20')+"|"+$(this).find("searchviewType").text()+"');return false;>";
									caresult+= "<a href='' onClick='return false;'><span class='sum'>카테고리</span> <div class='desc'>";
									//caresult+= strContDisp;
									caresult+= convTxtColor(strContDisp,$(this).find("Seed").text(),$(this).find("Conv").text());
									if($(this).find("meta2").text().split("$$")[1] == "jump"){	//급상승
										caresult+= " <span class='label label-line'>급상승</span>";
									}
									caresult+= "</div></a></li>";
									return false;
								}
							});
						}
					}
					//####### [1] 전시카테고리 가져 옴.
					
					
					//####### [2] 바로가기 가져 옴.
					$(xml).find("categoryPage").find("item").each(function(idx) {
						if($(this).find("meta2").text().split("$$")[0] == "sc"){	//바로가기
							scresult+= "<li class='service' onClick=top.location.href='" + jsAddSCUseSearchStatic($(this).find("meta1").text().split("$$")[1]) + encodeURIComponent(rect) + "';fnAmplitudeEventMultiPropertiesAction('click_search','action|keyword|searchkeyword|view','direct|"+rect.replace(/ /gi,'%20')+"|"+rect.replace(/ /gi,'%20')+"|"+$(this).find("searchviewType").text()+"');return false;>";
							scresult+= "<a href='' onClick='return false;'><span class='sum'>바로가기</span> <div class='desc'>";
							scresult+= convTxtColor($(this).find("Word").text(),$(this).find("Seed").text(),$(this).find("Conv").text());
							if($(this).find("meta2").text().split("$$")[1] == "jump"){	//급상승
								scresult+= " <span class='label label-line'>급상승</span>";
							}else if($(this).find("meta2").text().split("$$")[1] == "best"){	//BEST
								scresult+= " <span class='label label-line'>BEST</span>";
							}
							scresult+= "</div></a></li>";
							return false;
						}
					});
					//####### [2] 바로가기 가져 옴.
					
					//####### [3] 브랜드 가져 옴.
					$(xml).find("categoryPage").find("item").each(function(idx) {
						if($(this).find("meta2").text().split("$$")[0] == "br"){	//바로가기
							brresult+= "<li class='brand' onClick=top.location.href='" + $(this).find("meta1").text().split("$$")[1] + "&pNtr=qb_"+encodeURIComponent(rect)+"';fnAmplitudeEventMultiPropertiesAction('click_search','action|keyword|searchkeyword|view','brand|"+rect.replace(/ /gi,'%20')+"|"+rect.replace(/ /gi,'%20')+"|"+$(this).find("searchviewType").text()+"');return false;>";
							brresult+= "<a href='' onClick='return false;'><span class='sum'>브랜드</span> <div class='desc'>";
							brresult+= convTxtColor($(this).find("Word").text(),$(this).find("Seed").text(),$(this).find("Conv").text());
							if($(this).find("meta2").text().split("$$")[1] == "jump"){	//급상승
								brresult+= " <span class='label label-line'>급상승</span>";
							}else if($(this).find("meta2").text().split("$$")[1] == "best"){	//BEST
								brresult+= " <span class='label label-line'>BEST</span>";
							}
							brresult+= "</div></a></li>";
							return false;
						}
					});
					//####### [3] 브랜드 가져 옴.


					//####### [4] 이벤트 가져 옴.
					evresult = jsGetAutoEvent(rect);
					//####### [4] 이벤트 가져 옴.
					
					
					vBody = caresult + scresult + brresult + evresult;

					if(vBody != ""){
						$("#autokeywordad ul").empty().html(vBody);
						$("#autokeywordad").show();
					}
				}
	

				//####### [5] 자동완성어 가져 옴.
				$(xml).find("categoryPage").find("item").each(function(idx) {
					if($(this).find("meta2").text().split("$$")[0] == "ky"){
						result+= "<li onClick=top.location.href='/search/search_item.asp?rect="+$(this).find("Word").text().replace(/ /gi,'%20')+"&pNtr=qk_"+encodeURIComponent(rect)+"';fnAmplitudeEventMultiPropertiesAction('click_search','action|keyword|searchkeyword|view','recommend|"+rect.replace(/ /gi,'%20')+"|"+$(this).find("Word").text().replace(/ /gi,'%20')+"|"+$(this).find("searchviewType").text()+"');return false;>";
						result+= "<a href='' onClick='return false;'>";
						result+= convTxtColor($(this).find("Word").text(),$(this).find("Seed").text(),$(this).find("Conv").text());
						result+= "</a></li>";
						
						acnt = acnt + 1;
						//alert(acnt);
						if(acnt > 9){	//10 개만 가져옴.
							
							return false;
						}
					}
				});
				//####### [5] 자동완성어 가져 옴.
				strCont= result;
				$("#autocompletelist").empty().html(strCont);
			}else{
				evresult = jsGetAutoEvent(rect);
				if(evresult != ""){
					$("#autokeywordad ul").empty().html(evresult);
					$("#autokeywordad").show();
				}
			}
		}
	});
}


//자동완성 카테고리 가져오기
function jsSearchDispNameList(v){
	var jscaresult="";
	$.ajax({
		type: "GET",
		url: "/search/dispnamelist_keyword_ajax.asp",
		data:"viewcount=1&str=" + v,
		dataType: "xml",
		cache: false,
		async: true,
		timeout: 3000,
		beforeSend: function(x) {
			if(x && x.overrideMimeType) {
				x.overrideMimeType("text/xml;charset=utf-8");
			}
		},
		success: function(xml) {

			if($(xml).find("categoryPage").find("item").length>0) {

				// item노드 Loop
				$(xml).find("categoryPage").find("item").each(function(idx) {
					if($(this).find("meta1").text() != ""){
						jscaresult+= $(this).find("meta1").text() + "$$" + $(this).find("meta2").text();
					}
				});
				strContDisp = jscaresult;
			}
		}
	});
	return strContDisp;
}


//자동완성 이벤트 가져오기.
function jsGetAutoEvent(v) {
	var r = "";
	if (v.length<2) return r;
	$.ajax({
		url: "/search/act_autoEvent2017.asp?rect="+v,
		cache: false,
		async: false,
		success: function(message) {
			r = message;
		}
	});
	return r;
}


//선택 문자 색전환
function convTxtColor(sO,sS,sC) {
	if(sC=="null") {
		return sO.replace(sS,"<b>"+sS+"</b>");
	} else {
		return sO.replace(sC,"<b>"+sC+"</b>");
	}
}


//검색추적 parameter
function jsAddSCUseSearchStatic(l){
	var newval = "?";
	var conval = l;

	if(conval.indexOf(newval) > -1){
		conval = conval + "&pNtr=ql_";
	}else{
		conval = conval + "?pNtr=ql_";
	}

	return conval
}