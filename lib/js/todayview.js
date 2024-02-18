// ============================================================================
// 오늘본 상품(쿠키)
function getCookieValTodayView (offset) {
    var endstr = document.cookie.indexOf (";", offset);
    if (endstr == -1) endstr = document.cookie.length;

    return unescape(document.cookie.substring(offset, endstr));
}

function GetCookieTodayView(name) {
    var arg = name + "=";
    var alen = arg.length;
    var clen = document.cookie.length;
    var i = 0;
    while (i < clen) { //while open
        var j = i + alen;
        if (document.cookie.substring(i, j) == arg)
            return getCookieValTodayView (j);
        i = document.cookie.indexOf(" ", i) + 1;
        if (i == 0) break;
    } //while close

    return null;
}

function SetCookieTodayView(name, value) {
    var argv = SetCookieTodayView.arguments;
    var argc = SetCookieTodayView.arguments.length;
    var expires = (2 < argc) ? argv[2] : null;
    var path = (3 < argc) ? argv[3] : null;
    var domain = (4 < argc) ? argv[4] : null;
    var secure = (5 < argc) ? argv[5] : false;

    document.cookie = name + "=" + escape (value) +
    ((expires == null) ? "" :
    ("; expires=" + expires.toGMTString())) +
    ((path == null) ? "" : ("; path=" + path)) +
    ((domain == null) ? "" : ("; domain=" + domain)) +
    ((secure == true) ? "; secure" : "");
}




// ============================================================================
// 오늘본 상품 쿠키 등록
var MAX_TODAYVIEW_ITEMCOUNT = 40;

function GetItemidFromURLTodayView() {
    var indexstart, indexend;
    var searchstring = "category_itemPrd.asp?itemid=";
    // var searchstring = ".asp?itemid=";
    var itemid = 0;

    indexstart = self.location.toString().indexOf(searchstring) + searchstring.length;
    indexend = self.location.toString().indexOf("&");

    if (indexstart == -1) { return -1; }

    if (indexend == -1) {
        itemid = self.location.toString().substring(indexstart);
    } else {
        itemid = self.location.toString().substring(indexstart, indexend);
    }

    if ((itemid * 0) == 0) {
        return parseInt(itemid, 10);
    } else {
        return -1;
    }
}

function RemoveOldSavedItemidTodayView(itemidlist, maxcount) {
    // FIFO
    var index = 0;
    var count = 0;

    for (var i = 0; i < itemidlist.length; i++) {
        if (itemidlist.charAt(i) == '|') {
            count = count + 1;
            if (count > maxcount) {
                totalcounttodayview = maxcount;
                return itemidlist.substring(0, (index + 1));
            }
        }
        index = index + 1;
    }
    totalcounttodayview = count - 1;
    return itemidlist;
}

function AddNewItemidTodayView(itemidlist, itemid) {
    return ("|" + itemid + itemidlist);
}


function SaveItemidToCookieTodayView() {
    var itemid = -1;
    var todayviewitemidlist = "";
    var index = 0;
    var tmp;
    var expiretime;

    itemid = GetItemidFromURLTodayView();
    if ((itemid == -1) || (isNaN(itemid) == true)) {
        return;
    }

    todayviewitemidlist = GetCookieTodayView("todayviewitemidlist");
    if ((todayviewitemidlist == null) || (todayviewitemidlist == "null") || (todayviewitemidlist == "undefined")) {
        todayviewitemidlist = "|";
    }

    if (todayviewitemidlist.indexOf("|" + itemid + "|") == -1) {
        todayviewitemidlist = AddNewItemidTodayView(todayviewitemidlist, itemid);
        todayviewitemidlist = RemoveOldSavedItemidTodayView(todayviewitemidlist, MAX_TODAYVIEW_ITEMCOUNT);

        // expiretime = new Date((new Date()).getTime() + (1000 * 60 * 60 * 8));
        SetCookieTodayView("todayviewitemidlist", todayviewitemidlist, null, "/", "10x10.co.kr");
    }
}

try {
    SaveItemidToCookieTodayView();
} catch(e) { }

