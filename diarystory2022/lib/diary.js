function TnGotoAPPDiaryProduct(v){
	setTimeout(fnAPPpopupProduct(v),1000);
}

function TnGotoDiaryProduct(v){
    setTimeout(location.href = '/category/category_itemPrd.asp?itemid='+v,1000);
}

function TnGotoAPPDiaryEvent(v){
	setTimeout(fnAPPpopupEvent(v),1000);
}

function TnGotoDiaryEvent(v){
    setTimeout(location.href = '/event/eventmain.asp?eventid='+v,1000);
}

function TnGotoAPPDiaryAutoUrl(v){
	setTimeout(fnAPPpopupAutoUrl(v),1000);
}

function TnGotoDiaryLinkUrl(v){
    setTimeout(location.href = v,1000);
}