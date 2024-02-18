/*
+---------------------------------------------------------------------------------------------------------+
|                                       공통 Script 함수 Index                                            |
+------------------------------------------+--------------------------------------------------------------+
|                함 수 명                  |                          기    능                            |
+------------------------------------------+--------------------------------------------------------------+
| moveTopScroll()                          | 화면을 최상단으로 강제 스크롤링                              |
+------------------------------------------+--------------------------------------------------------------+
| cfmLoginout()                            | 로그아웃 페이지 이동                                         |
+------------------------------------------+--------------------------------------------------------------+
| viewSearchLayer()                        | 상단 검색창 On/Off                                           |
+------------------------------------------+--------------------------------------------------------------+
| fnTopSearch()                            | 검색 실행                                                    |
+------------------------------------------+--------------------------------------------------------------+
| jsChkNull(type,obj,msg)                  | 지정 오브젝트의 값 검사                                      |
+------------------------------------------+--------jsChklogin------------------------------------------------------+
| jsChkBlank(str)                          | 문자열 공백 여부 검사                                        |
+------------------------------------------+--------------------------------------------------------------+
| IsDigit(v)                               | 숫자여부 확인                                                |
+------------------------------------------+--------------------------------------------------------------+
| GetByteLength(val)                       | 문자열의 Byte 길이 반환                                      |
+------------------------------------------+--------------------------------------------------------------+
| TnFindZip(frmname)                       | 우편번호 검색창 호출                                         |
+------------------------------------------+--------------------------------------------------------------+
| validField(obj, msg, len)                | 폼관련 필수 오프젝트 검사                                    |
+------------------------------------------+--------------------------------------------------------------+
| Trim(v)                                  | 문자열 앞뒤공백 제거                                         |
+------------------------------------------+--------------------------------------------------------------+
| checkAsc(val)                            | 문자형식 확인                                                |
+------------------------------------------+--------------------------------------------------------------+
| validEmail(obj)                          | 이메일 형식 검사                                             |
+------------------------------------------+--------------------------------------------------------------+
| AddEval(OrdSr,itID,OptCd)                | 상품후기 쓰기 이동                                           |
+------------------------------------------+--------------------------------------------------------------+
| jsChkRealname(cRNCheck)                  | 실명확인 여부확인 및 실명확인 페이지 이동                    |
+------------------------------------------+--------------------------------------------------------------+
| getValue(obj)                            | 필드값 리턴, type이나 length에 따라 달라짐                   |
+------------------------------------------+--------------------------------------------------------------+
| islogin()                                | 로그인여부 확인                                              |
+------------------------------------------+--------------------------------------------------------------+
| getCookie(name)                          | 지정 쿠키값 반환                                             |
+------------------------------------------+--------------------------------------------------------------+
| getCheckedIndex(comp)                    | 선택 라디오버튼 번호 반환                                    |
+------------------------------------------+--------------------------------------------------------------+
| setValue(obj,val)                        | 필드값 세팅                                                  |
+------------------------------------------+--------------------------------------------------------------+
| loadXML(strFile)                         | XML파일 읽어오기 : (파일명)                                  |
+------------------------------------------+--------------------------------------------------------------+
| handleProcessIE()                        | loadXML내에서 IE 관련 출력 프로세스                          |
+------------------------------------------+--------------------------------------------------------------+
| handleProcessETC()                       | loadXML내에서 Mozila, safari 관련 출력 프로세스              |
+------------------------------------------+--------------------------------------------------------------+
| XMLsubProcess()                          | loadXML에서 읽은 내용을 출력 (XMLDiv값에 따라 출력방법 변경  |
+------------------------------------------+--------------------------------------------------------------+
| fileDownload(fileNo)                     | 파일다운로드 팝업                                            |
+------------------------------------------+--------------------------------------------------------------+
| popSNSShare(tit,link,pre,img)            | 쇼셜네트워크로 글보내기 모달 선택창 오픈                     |
+------------------------------------------+--------------------------------------------------------------+
| popSNSPost(svc,tit,link)                 | 쇼셜네트워크로 글보내기 팝업                                 |
+------------------------------------------+--------------------------------------------------------------+
| TnCheckCompDate(Dt1,cmpMt,Dt2)           | 날짜크기 비교 (Return 크거나같다:0, 작거나같다:-1)           |
+------------------------------------------+--------------------------------------------------------------+
| TnGotoEventMain(v)                       | 이벤트 페이지로 이동                                         |
+------------------------------------------+--------------------------------------------------------------+
| goBack(url)                              | History Back, Back이 없으면 지정한 URL로 이동                |
+------------------------------------------+--------------------------------------------------------------+
| fnOpenModal(sUrl)                        | 모달 레이어 팝업 오픈                                        |
+------------------------------------------+--------------------------------------------------------------+
| fnCloseModal()                           | 모달 레이어 팝업 닫기                                        |
+------------------------------------------+--------------------------------------------------------------+
| wishAppLink(vUrl)						   | 앱 호출후 지정된 URL 페이지로 이동                           |
+------------------------------------------+--------------------------------------------------------------+
| TnAddPlaymywish                          | Play담기                                                     |
+------------------------------------------+--------------------------------------------------------------+
| openHalfModal(sUrl, sDir, sDisp, sType)                   | 하프모달 팝업 열기                                                     |
+------------------------------------------+--------------------------------------------------------------+
| fnCloseHalfModal()                       | 하프모달 레이어 팝업 닫기                                        |
+------------------------------------------+--------------------------------------------------------------+
| imagesLoaded()                       | ajax 사용시 이미지 로딩 완료 시점 판단                                   |
+------------------------------------------+--------------------------------------------------------------+
| chktext(str,limit)         		       | 연속된 text 체크									          |
+------------------------------------------+--------------------------------------------------------------+
*/



//Play 관심 품목 담기	'2013-09-11 이종화
function TnAddPlaymywish(playcode, idx, subidx){
	var id = $("#mywish"+idx);
	// playwish
	$("#tempdiv").empty();
	$.ajax({
		url: "/play/playMyWish.asp?playcode="+playcode+"&codeidx="+idx+"&subcodeidx="+subidx,
		cache: false,
		success: function(message) {
			//alert( message );
			$("#tempdiv").empty().append(message);
				var state = $("#result").attr("rel");
				var count = $("#result").attr("rel2");

				if (state == "Y")
				{
					id.addClass("wishActive");
					//id.html("<strong>"+count+"</strong>");
				}else{
					id.removeClass("wishActive");
					//id.html("<strong>"+count+"</strong>");
				}
			$("#tempdiv").empty();
		}
		,error: function(err) {
			alert(err.responseText);
		}
	});
}

// 스크롤 최상으로 이동
function moveTopScroll() {
	setTimeout(function(){window.scrollTo(0, 1);}, 100);
}

//로그아웃
function cfmLoginout(isBiz) {
	if(confirm("로그아웃하시겠습니까?")) {
		if( isBiz ) {
			top.location="/login/dologout.asp?isBiz=Y";
		} else {
			top.location="/login/dologout.asp";
		}
	}
}

//검색창 On/Off
function viewSearchLayer() {
	if($("#top_search").attr('style')=="display:block") {
		$("#top_search").attr('style','display:none');
	} else {
		$("#top_search").attr('style','display:block');
	}
}

// 검색 실행
function fnTopSearch(){
	var frm = document.searchForm;

	frm.cpg.value=1;
	if (frm.rect.value.length<=0){
		alert('검색어를 입력해 주세요');
		frm.rect.focus();
		return false;
	} else {
		fnAmplitudeEventMultiPropertiesAction('click_search','action|keyword|searchkeyword|view','keyword|'+frm.rect.value+'|'+frm.rect.value+'|'+frm.ampsearchtype.value);
		return true;
	}
}

//INPUT태그 BOX의 Value값 체크,CHECKBOX의 체크여부,RADIOBUTTON의 선택여부,SELECT태그 BOX의 선택여부 체크
function jsChkNull(type,obj,msg)
{

     switch (type) {
        // text, password, textarea, hidden
        case "text" :
        case "password" :
        case "textarea" :
        case "hidden" :
                if (jsChkBlank(obj.value)) {
					alert(msg);
					//obj.focus();
                    return false;
                }
                else {
                    return true;
                }
                break;
        // checkbox
        case "checkbox" :
                if (!obj.checked) {
					alert(msg);
                    return false;
                }
                else {
                    return true;
                }
                break;
        // radiobutton
        case "radio" :
                var objlen = obj.length;

                for (i=0; i < objlen; i++) {
                    if (obj[i].checked == true)
                        return true;
				}
                if (i == objlen) {
					alert(msg);
                    return false;
                }else{
					return true;
                }
                break;
        }

        // select list
        if (obj.type.indexOf("select") != -1) {
            if (obj.options[obj.selectedIndex].value == 0 || obj.options[obj.selectedIndex].value == ""){
				alert(msg);
                return false;
            }else{
                return true;
			}
        }

        return true;

}

//문자열의 공백여부 체크
function jsChkBlank(str)
{
    if (str == "" || str.split(" ").join("") == ""){
        return true;
	}
    else{
        return false;
	}
}


function IsDigit(v){
	for (var j=0; j < v.length; j++){
		if ((v.charAt(j) * 0 == 0) == false){
			return false;
		}
	}
	return true;
}


// 2byte문자열 계산 (EUC식)
function GetByteLength(val){
 	var real_byte = val.length;
 	for (var ii=0; ii<val.length; ii++) {
  		var temp = val.substr(ii,1).charCodeAt(0);
  		if (temp > 127) { real_byte++; }
 	}

   return real_byte;
}

// 문자열 Byte 계산 (UTF식)
function GetRealByteLength(s,b,i,c){
    for(b=i=0;c=s.charCodeAt(i++);b+=c>>11?3:c>>7?2:1);
    return b;
}


function TnFindZip(frmname){
    fnOpenModal('/lib/pop_searchzip.asp?target=' + frmname);
}

function TnFindZipNew(frmname){
    fnOpenModal('/lib/pop_searchzipNew.asp?target=' + frmname);
}

function TnFindZipKa(frmname){
	var popwin = window.open("/lib/pop_searchzip_ka.asp?target=" + frmname);
	popwin.focus();
}

// 폼 필수 필드 유효성 체크
function validField(obj, msg, len)
{
	if (obj.length > 1)
	{
		if (obj[0].type == "radio" || obj[0].type == "checkbox")
		{
			var chk = 0;
			for (var i = 0; i < obj.length; i++)
				if (obj[i].checked)
					chk++;

			if (chk==0)
			{
				if (obj[0].type == "checkbox")
					alert("" + msg + " 하나 이상 체크해주세요.");
				else
					alert("" + msg + " 체크해주세요.");

				obj[0].focus();
				return false;
			}
		}
		else if (obj.type == "select-one")
		{
			if(obj.value=="")
			{
				alert("" + msg + " 선택해주세요.");
				obj.focus();
				return false;
			}
		}
	}
	else if (obj.type == "radio" || obj.type == "checkbox")
	{
		if (obj.checked==false)
		{
			alert("" + msg + " 체크해주세요.");
			obj.focus();
			return false;
		}
	}
	else
	{
		if(Trim(obj.value) == "")
		{
			alert("" + msg + " 입력해주세요.");
			obj.focus();
			return false;
		}
		if (len)
		{
			if (returnByte(obj.value) > len)
			{
				alert("" + msg + " 한글기준 "+parseInt(len/2)+"자, 영문기준 "+len+"자 이내로 해주세요.");
				obj.focus();
				return false;
			}
		}
	}

	return true;
}


// Trim
function Trim(v)
{
	return v.replace(/^(\s+)|(\s+)$/g, "");
}

function checkAsc(val)
{
	var regexp = /^[#.,~)(/\'\"_A-Za-z0-9 @-]*$/i;

	if(!regexp.test(val))
		return false;
	else
		return true;
}


// 이메일 형식 체크
function validEmail(obj)
{
	var regExp =/^[A-Za-z0-9_\.\-]+@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;

	if(! regExp.test(obj.value) )
	{
		alert("이메일 형식이 맞지 않습니다.");
		obj.focus();
		return false;
	}
	else
		return true;
}

//상품후기 쓰기
function AddEval(OrdSr,itID,OptCd,OrderIDX){
	location.href = '/my10x10/goodsUsingWrite.asp?orderserial=' + OrdSr + '&itemid=' + itID + '&optionCD=' + OptCd + '&OrderIDX=' + OrderIDX + '';
}

//실명확인 여부확인 및 실명확인 페이지 이동
function jsChkRealname(cRNCheck) {
	if(cRNCheck=='Y') {
		return true;
	} else {
		if(confirm("실명확인을 하셔야 글을 남기실 수 있습니다.\n\n실명확인을 하시겠습니까?")) {
			location.href = '/login/PopCheckName.asp';
		}
	}
	return false;
}

// 필드값 리턴, type이나 length에 따라 달라짐
function getValue(obj)
{
	var ret = "";
	if (obj.length > 1)
	{
		if (obj[0].type == "radio" || obj[0].type == "checkbox")
		{
			for (var i = 0; i < obj.length; i++)
				if (obj[i].checked)
					if (ret=="")
						ret = obj[i].value;
					else
						ret += "," + obj[i].value;
		}
		else if (obj.type == "select-one")
			ret = obj.value;
	}
	else
		ret = obj.value;

	return ret;
}

//로그인 여부 확인(쿠키)
function islogin() {
	if(getCookie('uinfo')) {
		return "True";
	} else {
		return "False";
	}
}

// 쿠키를 가져온다
function getCookie(name){
 var nameOfCookie = name + "=";
 var x = 0;

 while ( x <= document.cookie.length )
 {
  var y = (x+nameOfCookie.length);
  if ( document.cookie.substring( x, y ) == nameOfCookie ) {
   if ( (endOfCookie=document.cookie.indexOf( ";", y )) == -1 )
   endOfCookie = document.cookie.length;
   return unescape( document.cookie.substring( y, endOfCookie ) );
  }

  x = document.cookie.indexOf( " ", x ) + 1;

  if ( x == 0 )
   break;
 }
 return "";
}

// for radio button checked Index
function getCheckedIndex(comp){
    var i =0;
    for( var i = 0 ; i <comp.length;  i++){
        if(comp[i].checked) return i;
    }
    return -1;
}


// 필드값 세팅
function setValue(obj,val)
{
	if (obj.length > 1)
	{
		if (obj[0].type == "radio" || obj[0].type == "checkbox")
		{
			for (i=0;i<obj.length;i++)
				if (obj[i].value == val)	// 밸류값과 동일하면 checked
					obj[i].checked = true;
		}
		else if (obj.type == "select-one")
			obj.value = val;
		else
			alert("필드 중복!!");
	}
	else
		obj.value = val;
}

// XML로딩
var xmlDoc, xmlHttp;
function loadXML(strFile)
{
	// code for IE
	if (window.ActiveXObject) {
		xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
		xmlDoc.async=false;
		xmlDoc.load(strFile);
		handleProcessIE();
	}
	// code for Mozilla, Firefox, Opera, etc.
	else if (window.XMLHttpRequest) {
		xmlHttp = new XMLHttpRequest();
		 xmlHttp.open("GET",strFile,true);
		 xmlHttp.overrideMimeType('text/xml');
		 xmlHttp.onreadystatechange = handleProcessETC;
		 xmlHttp.send(null);
	} else {
		//alert('XML을 지원하지 않는 브라우져 입니다.');
	}
}

// XML핸들링(for IE)
function handleProcessIE(){
	XMLsubProcess();
}

// XML핸들링(for Mozilla)
function handleProcessETC(){
 if(xmlHttp.readyState == 4){
   if(xmlHttp.status==200) {
		xmlDoc = xmlHttp.responseXML;
		XMLsubProcess();
	}
 }
}

// Email comboBox 관련
function jsShowMailBox(frm,selVal,strVal) {

	if (eval(frm+"."+selVal).value == 'etc') {
		eval(frm+"."+strVal).style.display = '';
		eval(frm+"."+strVal).value = '';
		eval(frm+"."+strVal).readOnly = false;
		eval(frm+"."+strVal).focus();
	}
	else
	{
		eval(frm+"."+strVal).style.display = 'none';
		eval(frm+"."+strVal).value = eval(frm+"."+selVal).value;
	}
}


function setComma(str)
{
	str = ""+str+"";
	var retValue = "";

	for(i=0; i<str.length; i++)
	{
		if(i > 0 && (i%3)==0) {
			retValue = str.charAt(str.length - i -1) + "," + retValue;
		} else {
			retValue = str.charAt(str.length - i -1) + retValue;
		}
	}
	return retValue;
}


//로그인 후 로그인 페이지 팝업처리
function jsChklogin(blnLogin){
	if (blnLogin == "True"){
		return true;
	}
	else
	{
		alert("로그인을 해주세요.");
	}
	return false;

}

function jsChklogin_mobile(blnLogin, backurl){
	if (blnLogin == "True"){
		return true;
	}
	else
	{
		if(confirm("로그인 하시겠습니까?") == true) {
			top.location.href = "/login/login.asp?backpath="+backurl;
		 }
		return  ;
	}
	return false;
}

// logparam (이벤트 , 브랜드 수기 상품용)
function getParameter(paramName) {
  var searchString = window.location.search.substring(1),
      i, val, params = searchString.split("&");

  for (i=0;i<params.length;i++) {
    val = params[i].split("=");
    if (val[0] == paramName) {
      return val[1];
    }
  }
  return null;
}

function TnGotoProduct(v){
	var tmpparam
	if (getParameter("eventid")){
		tmpparam = "&pEtr="+getParameter("eventid");
	}else if (getParameter("makerid")){
		tmpparam = "&pBtr="+getParameter("makerid");
	}else{
		tmpparam = "";
	}
	top.location.href = '/category/category_itemPrd.asp?itemid='+v+tmpparam;
}

// 파일 다운로드
function fileDownload(fileNo) {
    //alert('죄송합니다. 잠시 점검중입니다.');
    //return;
	if(jsChklogin(islogin())) {
	    var popwin = window.open("http://upload.10x10.co.kr/linkweb/download/fileDownload.asp?fn=" + fileNo,'popFileDown');
	    popwin.focus();
	}
}
function fileDownload2(fileNo, url) { //call login
    //alert('죄송합니다. 잠시 점검중입니다.');
    //return;
	if(jsChklogin_mobile(islogin(),url)) {
	    var popwin = window.open("http://upload.10x10.co.kr/linkweb/download/fileDownload.asp?fn=" + fileNo,'popFileDown');
	    popwin.focus();
	}
}
// 쇼셜네트워크로 글보내기 모달팝업
function popSNSShare(tit,link,pre,img) {
	fnOpenModal('/common/popShare.asp?snstitle='+encodeURIComponent(tit)+'&snslink='+encodeURIComponent(link)+'&snspre='+encodeURIComponent(pre)+'&snsimg='+encodeURIComponent(img));
}

// 쇼셜네트워크로 글보내기
function popSNSPost(svc,tit,link,pre,tag) {
    // tit 및 link는 반드시 UTF8로 변환하여 호출요망!
    var popwin = window.open("/apps/snsPost/goSNSposts.asp?svc=" + svc + "&link="+link + "&tit="+tit + "&pre="+pre + "&tag="+tag,'popSNSpost');
    popwin.focus();
}
// 카카오톡 링크공유
function kakaoLink(chk,code) {
    var kaka = window.open("/apps/snsPost/kakoLink.asp?chk="+chk+"&code="+code+"");
    kaka.focus();
}

// 핀터레스트 공유
function pinit(link,img) {
    var pinit = window.open("http://pinterest.com/pin/create/button/?url="+link+"&media="+img);
    pinit.focus();
}
// 날짜 크기 비교
function TnCheckCompDate(Dt1,cmpMt,Dt2) {
	Dt1 = new Date(Dt1.substring(0,4),Dt1.substring(5,7)-1,Dt1.substring(8,10))
	Dt2 = new Date(Dt2.substring(0,4),Dt2.substring(5,7)-1,Dt2.substring(8,10))
	switch(cmpMt) {
		case "<":
			return (Dt1<Dt2);
			break;
		case "<=":
			return (Dt1<=Dt2);
			break;
		case "=":
			return (Dt1=Dt2);
			break;
		case ">":
			return (Dt1>Dt2);
			break;
		case ">=":
			return (Dt1>=Dt2);
			break;
		default:
			return false;
			break;
	}
}
// 오늘날짜 접수
function fnGetNowDate() {
	var now = new Date();
	var year = now.getFullYear();
	var month = now.getMonth()+1;
		if((month+"").length<2) month="0"+month;
	var day = now.getDate();
		if((day+"").length<2) day="0"+day;
	return year+"-"+month+"-"+day;
}


function TnGotoEventMain(v){
	if (v==""){
	document.location = '/shoppingtoday/shoppingchance_allevent.asp';
	}else{
	document.location = '/event/eventmain.asp?eventid=' + v;
	}
}

// iframe 길이 자동
function resizeIfr(obj, minHeight) {
	minHeight = minHeight || 10;

	try {
		var getHeightByElement = function(body) {
			var last = body.lastChild;
			try {
				while (last && last.nodeType != 1 || !last.offsetTop) last = last.previousSibling;
				return last.offsetTop+last.offsetHeight;
			} catch(e) {
				return 0;
			}

		}

		var doc = obj.contentDocument || obj.contentWindow.document;
		if (doc.location.href == 'about:blank') {
			obj.style.height = minHeight+'px';
			return;
		}

		//var h = Math.max(doc.body.scrollHeight,getHeightByElement(doc.body));
		//var h = doc.body.scrollHeight;
		if (/MSIE/.test(navigator.userAgent)) {
			var h = doc.body.scrollHeight;
		} else {
			var s = doc.body.appendChild(document.createElement('DIV'))
			s.style.clear = 'both';

			var h = s.offsetTop;
			s.parentNode.removeChild(s);
		}

		//if (/MSIE/.test(navigator.userAgent)) h += doc.body.offsetHeight - doc.body.clientHeight;
		if (h < minHeight) h = minHeight;

		obj.style.height = h + 'px';
		if (typeof resizeIfr.check == 'undefined') resizeIfr.check = 0;
		if (typeof obj._check == 'undefined') obj._check = 0;

//		if (obj._check < 5) {
//			obj._check++;
			setTimeout(function(){ resizeIfr(obj,minHeight) }, 200); // check 5 times for IE bug
//		} else {
			//obj._check = 0;
//		}
	} catch (e) {
		//alert(e);
	}

}

function jsChkNumber(value) {
	var temp = new String(value)

	if(temp.search(/\D/) != -1) {
		return false;
	}
		return true;
}

// 숫자인지 체크
function isNumeric( value ) {
	//	end home arrow (35~40), backspace 8, tab 9, enter 13, delete 46,  num lock 144
	if ((value >= 48 && value <= 57) || (value >= 96 && value <= 105) || (value >= 35 && value <= 40) || value == 8 || value == 9 || value == 13 || value == 46 || value == 144)
		return true;
	else
		return false;
}

// 숫자만 입력받기 IE, FF	onkeydown="onlyNumber(this,event);"
function onlyNumber(obj,evt) {
	var evCode = (!window.netscape) ? event.keyCode : evt.which;
	if (isNumeric(evCode)==false) {
		alert("숫자만 입력이 가능합니다.");
		if (!window.netscape)
			event.returnValue=false;
		else
			obj.value = obj.value.substr(0,obj.value.length-1);
	}
}

// 패스워드 복잡도 검사
function fnChkComplexPassword(pwd) {
    var aAlpha = /[a-z]|[A-Z]/;
    var aNumber = /[0-9]/;
    var aSpecial = /[!|@|#|$|%|^|&|*|(|)|-|_]/;
    var sRst = true;

    if(pwd.length < 8){
        sRst=false;
        return sRst;
    }

    var numAlpha = 0;
    var numNums = 0;
    var numSpecials = 0;
    for(var i=0; i<pwd.length; i++){
        if(aAlpha.test(pwd.substr(i,1)))
            numAlpha++;
        else if(aNumber.test(pwd.substr(i,1)))
            numNums++;
        else if(aSpecial.test(pwd.substr(i,1)))
            numSpecials++;
    }

    if((numAlpha>0&&numNums>0)||(numAlpha>0&&numSpecials>0)||(numNums>0&&numSpecials>0)) {
    	sRst=true;
    } else {
    	sRst=false;
    }
    return sRst;
}

// History Back 처리
function goBack(url) {
	var chkHistory, sRef;
	sRef = document.referrer;

	if(sRef=="" || sRef.substring(sRef.length,sRef.length-12)=="10x10.co.kr/") {
		chkHistory = false;
	} else {
		chkHistory = true;
	}

	if(chkHistory) {
		history.back();
	} else {
		if(!url) url="/";
		location.replace(url);
	}
}

var fEvt = function(e){ e.preventDefault(); };
var myScroll;

// 모달 레이어 오픈
function fnOpenModal(sUrl) {
	if(sUrl==""||sUrl=="undefind") return;

	$.ajax({
		url: sUrl,
		cache: false,
		success: function(message) {
			$("#modalLayer").empty().html(message);
			$("#modalLayer").show();
			if($(message).find("#scrollarea").length>0) {
				setTimeout(function(){
					myScroll = new iScroll('scrollarea',{
						onBeforeScrollStart: function (e) {
							var target = e.target;
							while (target.nodeType != 1) target = target.parentNode;
							if (target.tagName != 'SELECT' && target.tagName != 'INPUT' && target.tagName != 'TEXTAREA')
								e.preventDefault();
						}
					});
				},250);
			}
			//document.addEventListener('touchmove', fEvt, false);
		}
		,error: function(err) {
			alert(err.responseText);
		}
	});

	$("#modalLayer").show();
}

// 모달 레이어 닫기
function fnCloseModal() {
	$("#modalLayer").hide(0,function(){
		myScroll = null;
		$(this).empty();
	});
	//document.removeEventListener('touchmove', fEvt, false);
}

//전역 변수 선언
var iHdH = 78;
var iFtH = 273;

$(function(){
	//$(".heightGrid").css("height", "760px");

	//top button control
	$('#gotop').hide();
	$(window).scroll(function(){
		var vSpos = $(window).scrollTop();
		var docuH = $(document).height() - $(window).height();
		if (vSpos > 100){
			if($('#gotop').css("display")=="none"){
				$('#gotop').fadeIn();
			}
		} else {
			$('#gotop').hide();
		}
	});

	$('.lnbCtgyList ul li.selected').next().children().children().css('border-top','none');

	$('#gotop').click(function(){
		$('html, body').animate({scrollTop:0}, 'fast');
	});

	//2016 UX
	function slideControl() {
		if($(".asideSectionV16a").is(":hidden")){
			$(".asideSectionV16a").addClass('asideActive');
			$(".heightGrid").css("overflow", "hidden");
			$("#mainBlankCover").show();
			lnbScroll.update();
		} else {
			$(".asideSectionV16a").removeClass('asideActive');
			$(".heightGrid").css("overflow", "visible");
			$("#mainBlankCover").hide();
		}
	}

	$("#mainBlankCover, .btnLnbGo, .lnbClose").click(function(){
		slideControl();
		slideControl_old();
	});

	function slideControl_old() {
		if($(".asideSection").is(":hidden")){
			$(".asideSection").show();
			$(".asideSection").css('left','0');
			$(".heightGrid").css("overflow", "hidden");
			$("#mainBlankCover").show();
			myCatScroll.refresh();
		} else {
			$(".asideSection").css('left','0');
			$(".asideSection").hide();
			//$(".heightGrid").css("overflow", "visible");
			//$("#mainBlankCover").hide();
		}
	}

//	$('.btnLnbGo').click(function(){
//		slideControl();
//	});
//	$("#mainBlankCover").click(function(){
//		slideControl();
//	});

	//LNB category list layer control
//	$('.asideTab li div').click(function(){
//		$('.asideTab li').removeClass('selected');
//		$(this).parent().addClass('selected');
//		if ($(this).hasClass('tabCtgy')) {
//			if ($('.pvtAreaWrap .lnbCtgyList').is(':hidden')) {
//				$('.pvtAreaWrap .lnbCtgyList').show();
//			} else {
//				$('.pvtAreaWrap .lnbCtgyList').hide();
//				$('.asideTab li').removeClass('selected');
//			}
//		} else {
//			$('.pvtAreaWrap .lnbCtgyList').hide();
//			slideControl();
//			$('.asideTab li').removeClass('selected');
//		}
//	});

	//LNB private layer close
//	$('.pvtNoti .notiClose').click(function(){
//		$(this).parent().hide();
//	});

	// Tab
	$(".tabContent").hide();
	$(".tabContainer").find(".tabContent:first").show();
	 
	$(".tabNav li").click(function() {
		$(this).siblings("li").removeClass("current");
		$(this).addClass("current");
		$(this).closest(".tabNav").nextAll(".tabContainer:first").find(".tabContent").hide();
		var activeTab = $(this).find("a").attr("href");
		$(activeTab).show();
		return false;
	});
	$(".noMove li").unbind('click');

	$('#layerScroll').height( $('body').height() - 40 );

	// check app,web
	var chkapp = navigator.userAgent.match("tenapp");
	if ( chkapp ){
		$(".mApp").show();
		$(".mWeb").hide();
	}else{
		$(".mApp").hide();
		$(".mWeb").show();
	}

});

//로딩 완료시 실행
//window.onload=function(){
//	aside(LNB) slide control
//	var contHeight = $('#contentArea').outerHeight(true);
//	$(".mainSection").css("min-height", contHeight+iHdH+iFtH);
//	$(".heightGrid").css("height", "580px");
//}

// 앱 호출 + 지정 URL로 앱실행후 지정 URL로 점핑 앱이 설치가 안됐을 경우 각각의 다운로드경로로 치환
function wishAppLink(vUrl) {
	var isiOS = navigator.userAgent.match('iPad') || navigator.userAgent.match('iPhone') || navigator.userAgent.match('iPod'),
		isAndroid = navigator.userAgent.match('Android');

	if ( isiOS ) {
		document.getElementById('loader').src = "tenwishapp://" + vUrl;
		var fallbackLink = isAndroid ? 'market://details?id=kr.tenbyten.shopping' :
									 'https://itunes.apple.com/kr/app/id864817011' ;
		window.setTimeout(function (){ window.location.replace(fallbackLink); }, 25);

	} else if ( isAndroid ){
		
		var tmpurl = 'intent://' + vUrl + '#Intent;scheme=tenwishapp;package=kr.tenbyten.shopping;end';
	    parent.top.document.location.href = tmpurl;

	} else {
		alert("안드로이드 또는 IOS 기기만 지원합니다.");
	}
}

//url에 있는 파라메타값받기 getUrlParameter('para')
function getUrlParameter(sParam)
{
    var sPageURL = window.location.search.substring(1);
    var sURLVariables = sPageURL.split('&');
    for (var i = 0; i < sURLVariables.length; i++) 
    {
        var sParameterName = sURLVariables[i].split('=');
        if (sParameterName[0] == sParam) 
        {
            return sParameterName[1];
        }
    }
}

//하프모달 팝업 열기
function openHalfModal(sUrl, sDir, sDisp, sType) {
	if(sUrl==""||sUrl=="undefind") return;

	$.ajax({
		type:"GET",
		url: sUrl,
		data: "sDir="+sDir+"&sDisp="+sDisp+"&sType="+sType,
		cache: false,
		success: function(message) {
			$("#modalLayer2Contents").empty().html(message);
			$("#modalLayer2").show();
			$('.layerPopup').animate({top:"42.5%"}, 150);
			$("#dimed").click(function(){
				fnCloseHalfModal();
			});

			setTimeout(function(){
				var myScroll = new iScroll('scrollarea2');
			}, 200);

			document.addEventListener('touchmove', fEvt, false);
		}
		,error: function(err) {
			alert(err.responseText);
		}
	});
}


// 하프모달 레이어 닫기
function fnCloseHalfModal() {
	$('.layerPopup').animate({top:"100%"}, 150, function(){
		$("#modalLayer2").hide(0,function(){
			myScroll = null;
			$("#modalLayer2Contents").empty();
		});
	});
	document.removeEventListener('touchmove', fEvt, false);
}

// ajax 사용시 이미지 로딩 완료 시점 판단
$.fn.imagesLoaded = function () {
    // get all the images (excluding those with no src attribute)
    var $imgs = this.find('img[src!=""]');
    // if there's no images, just return an already resolved promise
    if (!$imgs.length) {return $.Deferred().resolve().promise();}

    // for each image, add a deferred object to the array which resolves when the image is loaded (or if loading fails)
    var dfds = [];  
    $imgs.each(function(){

        var dfd = $.Deferred();
        dfds.push(dfd);
        var img = new Image();
        img.onload = function(){dfd.resolve();}
        img.onerror = function(){dfd.resolve();}
        img.src = this.src;
    });
    return $.when.apply($,dfds);
}

//연속된 문자열 체크(문자열,최소체크길이)
function chktext(str, limit){ 
	var o, d, p, n = 0, l = limit==null ? 5 : limit; 
	for(var i=0; i<str.length; i++){ 
		var c = str.charCodeAt(i); 
		if(i > 0 && (p = o - c) >-2 && p < 2 && (n = p == d ? n+1 : 0) > l-3) return false; 
		d = p, o = c; 
		}
	return true; 
}

//태깅&로깅 공용 스크립트
function tagScriptSend(act, val, data, gn)
{
	if (gn=="mixpanel")
	{
		mixpanel.track(val);
	}
	else if (gn=="amplitude")
	{
		amplitude.getInstance().init('fd52aea3710592a696baae5447a6630d');
		amplitude.getInstance().logEvent(val);
	}
	else if (gn=="amplitudeProperties")
	{
		var amplitudeProperties = {
			key : val
		};
		amplitude.getInstance().init('fd52aea3710592a696baae5447a6630d');
		amplitude.getInstance().logEvent(act, amplitudeProperties);
	}
}

function AmplitudeEventSend(act, propertiesvalue, gubun)
{
	if (gubun=="event")
	{
		amplitude.getInstance().init('3e5d96e41fc92b60c3a28f9fb4ae7620');
		amplitude.getInstance().logEvent(act);

	}
	if (gubun=="eventProperties")
	{
		amplitude.getInstance().init('3e5d96e41fc92b60c3a28f9fb4ae7620');
		amplitude.getInstance().logEvent(act, propertiesvalue);
	}
}

function fnAmplitudeEventAction(EvtAction, KeyJson, ValueJson) {
	var vji;
	if (ValueJson!="")
	{
		vji = '{"'+KeyJson+'":"'+ValueJson+'"}';
		vji = JSON.parse(vji);
		amplitude.getInstance().init('3e5d96e41fc92b60c3a28f9fb4ae7620');
		amplitude.getInstance().logEvent(EvtAction, vji);
	}
	else
	{
		amplitude.getInstance().init('3e5d96e41fc92b60c3a28f9fb4ae7620');
		amplitude.getInstance().logEvent(EvtAction);
	}
}

function fnAmplitudeEventObjectAction(EvtAction, object) {
	if (EvtAction != null && EvtAction !== '' && object != null) {
		console.log(EvtAction, object);
		amplitude.getInstance().init('3e5d96e41fc92b60c3a28f9fb4ae7620');
		amplitude.getInstance().logEvent(EvtAction, object);
	}
}

function fnAmplitudeEventMultiPropertiesAction(EvtAction, KeyJson, ValueJson) {
	var vji;
	var i;
	var tmpKey;
	var tmpValue;
	if (ValueJson!="")
	{
		tmpKey = KeyJson.split("|");
		tmpValue = ValueJson.split("|");

		if (tmpKey.length == tmpValue.length)
		{
			vji = '{';
			for (i=0; i < tmpKey.length; i++ )
			{
				if ((tmpKey.length-1) == i)
				{
					vji += '"'+tmpKey[i]+'":"'+decodeURIComponent(tmpValue[i])+'"';
				}
				else
				{
					vji += '"'+tmpKey[i]+'":"'+decodeURIComponent(tmpValue[i])+'",';
				}
			}
			vji += '}';
			vji = JSON.parse(vji);
			amplitude.getInstance().init('3e5d96e41fc92b60c3a28f9fb4ae7620');
			amplitude.getInstance().logEvent(EvtAction, vji);
		}
	}
	else
	{
		amplitude.getInstance().init('3e5d96e41fc92b60c3a28f9fb4ae7620');
		amplitude.getInstance().logEvent(EvtAction);
	}
}

function fnAmplitudeEventActionJsonData(EvtAction, ValueJson) {
	var vji;
	if (ValueJson!="")
	{
		vji = JSON.parse(ValueJson);
		amplitude.getInstance().init('3e5d96e41fc92b60c3a28f9fb4ae7620');
		amplitude.getInstance().logEvent(EvtAction, vji);
	}
	else
	{
		amplitude.getInstance().init('3e5d96e41fc92b60c3a28f9fb4ae7620');
		amplitude.getInstance().logEvent(EvtAction);
	}
}

function searchZipKakao(ele, tp) {

    // 우편번호 찾기 찾기 화면을 넣을 element
	var element_wrap = document.getElementById(""+ele+"");
	
	// 현재 scroll 위치를 저장해놓는다.
	var currentScroll = Math.max(document.body.scrollTop, document.documentElement.scrollTop);
	daum.postcode.load(function(){    
		new daum.Postcode({
			oncomplete: function(data) {
				var addr = ''; // 주소 변수
				var extraAddr = ''; // 참고항목 변수

				//사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
				if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
					addr = data.roadAddress;
				} else { // 사용자가 지번 주소를 선택했을 경우(J)
					addr = data.jibunAddress;
				}

				// 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
				if(data.userSelectedType === 'R'){
					// 법정동명이 있을 경우 추가한다. (법정리는 제외)
					// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
					if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
						extraAddr += data.bname;
					}
					// 건물명이 있고, 공동주택일 경우 추가한다.
					if(data.buildingName !== '' && data.apartment === 'Y'){
						extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
					}
					// 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
					if(extraAddr !== ''){
						extraAddr = ' (' + extraAddr + ')';
					}
					// 조합된 참고항목을 해당 필드에 넣는다.
					$("#extraAddr").val(extraAddr);
				} else {
					$("#extraAddr").val("");
				}

				// 우편번호와 주소 정보를 해당 필드에 넣는다.
				$("#tzip").val(data.zonecode);
				$("#taddr1").val(addr);

				// iframe을 넣은 element를 안보이게 한다.
				// (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)
				element_wrap.style.display = 'none';

				// 우편번호 찾기 화면이 보이기 이전으로 scroll 위치를 되돌린다.
				//$(element_wrap).scrollTop = currentScroll;
				$(window).scrollTop($(element_wrap).offset().top-150);
			},
			// 사용자가 주소를 클릭했을때
			onclose : function(state) {
				if(state === 'COMPLETE_CLOSE'){
					alert("나머지 주소를 입력해주세요");
					CopyZipKakao(tp);
				}
			},
			onresize : function(size) {
				//alert(size.height);
				//alert(this);
				//for (var key in this) {
				//	console.log("attributes : " + key + ", value : " + this[key]);
				//}
				//this.style.height = size.height.value;
				//alert("bb");
				//alert($("#__daum__layer_"+this.viewerNo).html());
				//document.getElementById("__daum__layer_"+this.viewerNo).style.scrollHeight = size.height+"px";
				//setTimeout(function () {
				//	myScroll.refresh();
				//}, 200);
				//alert("ee");
				//alert(element_wrap);
				element_wrap.style.height = size.height+'px';
				$(window).scrollTop($(element_wrap).offset().top-150);
			},
			width : '100%',
			height : '100%',
			hideMapBtn : true,
			hideEngBtn : true,
			shorthand : false,
			maxSuggestItems : 5
		}).embed(element_wrap);
	});
	// iframe을 넣은 element를 보이게 한다.
	element_wrap.style.display = 'block';
}

function searchZipKakaoForVuejs(ele, tp, data) {
	// 우편번호 찾기 찾기 화면을 넣을 element
	var element_wrap = document.getElementById(""+ele+"");

	// 현재 scroll 위치를 저장해놓는다.
	var currentScroll = Math.max(document.body.scrollTop, document.documentElement.scrollTop);
	daum.postcode.load(function(){
		new daum.Postcode({
			oncomplete: function(data) {
				var addr = ''; // 주소 변수
				var extraAddr = ''; // 참고항목 변수

				//사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
				if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
					addr = data.roadAddress;
				} else { // 사용자가 지번 주소를 선택했을 경우(J)
					addr = data.jibunAddress;
				}

				// 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
				if(data.userSelectedType === 'R'){
					// 법정동명이 있을 경우 추가한다. (법정리는 제외)
					// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
					if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
						extraAddr += data.bname;
					}
					// 건물명이 있고, 공동주택일 경우 추가한다.
					if(data.buildingName !== '' && data.apartment === 'Y'){
						extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
					}
					// 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
					if(extraAddr !== ''){
						extraAddr = ' (' + extraAddr + ')';
					}
					// 조합된 참고항목을 해당 필드에 넣는다.
					$("#extraAddr").val(extraAddr);
				} else {
					$("#extraAddr").val("");
				}

				// 우편번호와 주소 정보를 해당 필드에 넣는다.
				$("#tzip").val(data.zonecode);
				$("#taddr1").val(addr);

				// iframe을 넣은 element를 안보이게 한다.
				// (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)
				element_wrap.style.display = 'none';

				// 우편번호 찾기 화면이 보이기 이전으로 scroll 위치를 되돌린다.
				//$(element_wrap).scrollTop = currentScroll;
				$(window).scrollTop($(element_wrap).offset().top-150);
			},
			// 사용자가 주소를 클릭했을때
			onclose : function(state) {
				if(state === 'COMPLETE_CLOSE'){
					alert("나머지 주소를 입력해주세요");
					CopyZipKakaoForVuejs(tp, data);
				}
			},
			onresize : function(size) {
				//alert(size.height);
				//alert(this);
				//for (var key in this) {
				//	console.log("attributes : " + key + ", value : " + this[key]);
				//}
				//this.style.height = size.height.value;
				//alert("bb");
				//alert($("#__daum__layer_"+this.viewerNo).html());
				//document.getElementById("__daum__layer_"+this.viewerNo).style.scrollHeight = size.height+"px";
				//setTimeout(function () {
				//	myScroll.refresh();
				//}, 200);
				//alert("ee");
				//alert(element_wrap);
				element_wrap.style.height = size.height+'px';
				$(window).scrollTop($(element_wrap).offset().top-150);
			},
			width : '100%',
			height : '100%',
			hideMapBtn : true,
			hideEngBtn : true,
			shorthand : false,
			maxSuggestItems : 5
		}).embed(element_wrap);
	});
	// iframe을 넣은 element를 보이게 한다.
	element_wrap.style.display = 'block';
}

function foldDaumPostcode(ele) {
    // 우편번호 찾기 찾기 화면을 넣을 element
	var element_wrap = document.getElementById(""+ele+"");

	// iframe을 넣은 element를 안보이게 한다.
	element_wrap.style.display = 'none';
}

function CopyZipKakao(tp)	{
	var frm = eval("document."+tp);
	var basicAddr;
	basicAddr = "";
	basicAddr = $("#taddr1").val()+$("#taddr2").val()+$("#extraAddr").val();
	basicAddr  = basicAddr.replace(/・/g,"/");		 

	// copy
	if (tp=="frmWrite") {
		//frm.zip1.value			= post1;
		//frm.zip2.value			= post2;
		frm.zip.value		= $("#tzip").val();
		frm.reqZipaddr.value	= basicAddr;
		frm.reqAddress.value	= "";
		frm.reqAddress.focus();
	}
	else if (tp=="buyer") {
		frm.buyZip.value		= $("#tzip").val();
		frm.buyAddr1.value		= basicAddr;
		frm.buyAddr2.value		= "";
		frm.buyAddr2.focus();
	}
	else if (tp=="userinfo") {
		frm.txZip.value		= $("#tzip").val();
		frm.txAddr1.value		= basicAddr;
		frm.txAddr2.value		= "";
		frm.txAddr2.focus();
	}
	else {
		frm.txZip.value		= $("#tzip").val();
		frm.txAddr1.value		= basicAddr;
		frm.txAddr2.value		= "";
		frm.txAddr2.focus();
	}
}
function CopyZipKakaoForVuejs(tp, data) {
	const frm = eval("document."+tp);
	let basicAddr = $("#taddr1").val()+$("#taddr2").val()+$("#extraAddr").val();
	basicAddr  = basicAddr.replace(/・/g,"/");

	data.address.zipcode = $("#tzip").val();
	data.address.basic = basicAddr;
	data.address.detail = '';
	data.is_show_zipcode = false;
	frm.txAddr2.value = "";
	frm.txAddr2.focus();
}

function fnNewCouponIssued(eCode, cIdxs) {
	$.ajax({
		type: "post",
		url: "/event/etc/coupon/brandcoupon_process.asp",		
		data: {
			eCode: eCode,
			couponIdxs: cIdxs
		},
		cache: false,
		success: function(resultData) {
			fnAmplitudeEventMultiPropertiesAction('click_coupon_btn','evtcode|couponType',''+eCode+'|'+cIdxs+'')
			var reStr = resultData.split("|");				
			
			if(reStr[0]=="OK"){		
				alert('쿠폰이 발급 되었습니다.\n주문시 사용 가능합니다.');
			}else if(reStr[0]=="LGN") {
				eval(reStr[1]);
				return false;
			}else{
				var errorMsg = reStr[1].replace(">?n", "\n");
				alert(errorMsg);					
			}			
		},
		error: function(err) {
			console.log(err.responseText);
		}
	});
}

function fnNewCouponIssuedWithDate(eCode, cIdxs, msg) {
	$.ajax({
		type: "post",
		url: "/event/etc/coupon/brandcoupon_process.asp",		
		data: {
			eCode: eCode,
			couponIdxs: cIdxs
		},
		cache: false,
		success: function(resultData) {
			fnAmplitudeEventMultiPropertiesAction('click_coupon_btn','evtcode|couponType',''+eCode+'|'+cIdxs+'')
			var reStr = resultData.split("|");				
			
			if(reStr[0]=="OK"){		
				alert('쿠폰이 발급 되었습니다.\n'+msg+'까지 사용 가능합니다.');
			}else if(reStr[0]=="LGN") {
				if(confirm('로그인을 하셔야 쿠폰을 발급 받으실 수 있습니다.')){
					location.href=''+reStr[1]+'';
					return;
				}
			}else{
				var errorMsg = reStr[1].replace(">?n", "\n");
				alert(errorMsg);					
			}			
		},
		error: function(err) {
			console.log(err.responseText);
		}
	});
}

/**
 *
 * @param {String} eCode - 이벤트코드
 * @param {string} dispId - 할인율 노출할 엘리먼트 id
 * @param {Function} cb - 콜백( 존재할때만 실행 )
 * @returns {Object} - return { salePer: 0, dispId: element id }
 */
function getEvtSalePer(eCode, dispId,  cb) {
	$.ajax({
		type: "GET",
		url: "/apps/appCom/wish/webapi/event/saleper.asp",		
		data: {
			eventCode: eCode,
			dispId: dispId
		},
		cache: false,
		success: function(res) {
			try {
				if(dispId && !cb){
					if(!res.salePer) return false
					var tmpText=""
					tmpText = String(res.salePer).indexOf("%") != -1 || String(res.salePer).indexOf("원") != -1 ? res.salePer 
					: res.salePer <= 100 ? "~" + res.salePer + "%"
					: res.salePer + "원"				
					$("#disp").text(tmpText)
				}
				if(cb != undefined && cb instanceof Function) cb(res);				
			} catch (error) {
				console.error(error)
			}
		},
		error: function(err) {
			console.log(err);
		}
	});
}
/**
 *
 * @param {String} eCode - 이벤트코드
 * @param {string} dispId - 할인율 노출할 엘리먼트 id
 * @param {Function} cb - 콜백( 존재할때만 실행 )
 * @returns {Object} - return { salePer: 0, dispId: element id }
 */
function getEvtTotalSalePer(eCode, dispId,  cb) {
	$.ajax({
		type: "GET",
		url: "/apps/appCom/wish/webapi/event/total_saleper.asp",
		data: {
			eventCode: eCode,
			dispId: dispId
		},
		cache: false,
		success: function(res) {
			try {
				if(dispId && !cb){
					if(!res.salePer) return false
					var tmpText=""
					tmpText = String(res.salePer).indexOf("%") != -1 || String(res.salePer).indexOf("원") != -1 ? res.salePer
						: res.salePer <= 100 ? "~" + res.salePer + "%"
							: "~99%"
					$("#disp").text(tmpText)
				}
				if(cb != undefined && cb instanceof Function) cb(res);
			} catch (error) {
				console.error(error)
			}
		},
		error: function(err) {
			console.log(err);
		}
	});
}

// ### 이니시스 렌탈 월 렌탈료 계산
function getIniRentalMonthPriceCalculation(rPrice, rMonth) {
	var returnMonthlyRentalPrice;
	var rentalPee;
	switch (rMonth) {
		case "12" :
			rentalPee = 1.135;
			break;		
		case "24" :
			rentalPee = 1.155;
			break;
		case "36" :
			rentalPee = 1.175;
			break;                
		case "48" :
			rentalPee = 1.195;
			break;
		default:
			rentalPee = 0;                
	}
	
	if (rPrice<200000) {
		return "error|렌탈로 구매할 수 있는 금액은 20만원 이상부터 입니다.";
	}

	if (rentalPee==0) {
		return "error|렌탈 개월수는 24개월, 36개월, 48개월만 선택 가능합니다.";
	}

	if (rPrice != "" && rMonth != "") {
		// 100만원 이하는 최대 36개월 까지만 가능
		if (rPrice < 1000001 && rMonth>36) {
			return "error|렌탈 기간은 최대 36개월 까지만 가능합니다."
		} else {
			// 10원 단위 내림
			returnMonthlyRentalPrice = Math.floor(((rPrice*rentalPee) / rMonth)/100)*100;
			return "ok|"+returnMonthlyRentalPrice;
		}
	} else {
		return "error|상품 금액과 렌탈 기간이 필요합니다.";
	}
}

// ### 이니시스 렌탈 이벤트용 월 렌탈료 계산(2021년 4월 26일~2021년 5월 10일)
function getIniRentalMonthPriceCalculationForEvent(rPrice, rMonth) {
	var returnMonthlyRentalPrice;
	var rentalPee;
	// 12개월 10.5%, 24개월 12.5%, 36개월 14.5%, 48개월 16.5%
	switch (rMonth) {
		case "12" :
			rentalPee = 1.105;
			break;		
		case "24" :
			rentalPee = 1.125;
			break;
		case "36" :
			rentalPee = 1.145;
			break;                
		case "48" :
			rentalPee = 1.165;
			break;
		default:
			rentalPee = 0;                
	}
	
	if (rPrice<200000) {
		return "error|렌탈로 구매할 수 있는 금액은 20만원 이상부터 입니다.";
	}

	if (rentalPee==0) {
		return "error|렌탈 개월수는 12개월, 24개월, 36개월, 48개월만 선택 가능합니다.";
	}

	if (rPrice != "" && rMonth != "") {
		// 해당 이벤트는 특정 가격에 따른 렌탈 개월 수 제한이 없음
		//if (rPrice < 1000001 && rMonth>36) {
		//	return "error|렌탈 기간은 최대 36개월 까지만 가능합니다."
		//} else {
			// 10원 단위 내림
			returnMonthlyRentalPrice = Math.floor(((rPrice*rentalPee) / rMonth)/100)*100;
			return "ok|"+returnMonthlyRentalPrice;
		//}
	} else {
		return "error|상품 금액과 렌탈 기간이 필요합니다.";
	}
}

// DataDive Key
function getDataDiveKey() {
	const url = unescape(location.href);
	if( url.includes('//localhost') || url.includes('//testm') || url.includes('//localm') || url.includes('//stgm') ) {
		return '314893ff84434348b84a86fab5b3e8a9';
	} else {
		return 'aafad9f151234a3981bc8dd46a1a9376';
	}
}