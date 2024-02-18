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
+------------------------------------------+--------------------------------------------------------------+
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
| popSNSPost(svc,tit,link)                 | 쇼셜네트워크로 글보내기 팝업                                 |
+------------------------------------------+--------------------------------------------------------------+
| TnCheckCompDate(Dt1,cmpMt,Dt2)           | 날짜크기 비교 (Return 크거나같다:0, 작거나같다:-1)           |
+------------------------------------------+--------------------------------------------------------------+
| TnGotoEventMain(v)                       | 이벤트 페이지로 이동                                         |
+------------------------------------------+--------------------------------------------------------------+

*/
// 스크롤 최상으로 이동
function moveTopScroll() {
	setTimeout(function(){window.scrollTo(0, 1);}, 100);
}

//로그아웃
function cfmLoginout() {
	if(confirm("로그아웃하시겠습니까?")) {
		top.location="/apps/appCom/wish/webview/login/dologout.asp";
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


function GetByteLength(val){
 	var real_byte = val.length;
 	for (var ii=0; ii<val.length; ii++) {
  		var temp = val.substr(ii,1).charCodeAt(0);
  		if (temp > 127) { real_byte++; }
 	}

   return real_byte;
}


function TnFindZip(frmname){
    var popwin = window.open('/apps/appCom/wish/webview/lib/searchzip.asp?target=' + frmname, 'findzipcdode', 'width=460,height=250,left=400,top=200,scrollbars=yes,resizable=yes');
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

// 모달창
function jsOpenModal(sUrl) {
	if(sUrl==""||sUrl=="undefind") return;

	$.ajax({
		url: sUrl,
		cache: false,
		success: function(message) {
			$("#modalCont").empty().html(message);
			$("#modalCont").fadeIn();
			$('body').css({'overflow':'hidden'});

			//close
			$('#modalCont .modal .btn-close').one('click', function(){
				$("#modalCont").fadeOut();
				$('body').css({'overflow':'auto'});
				return false;
			});
		}
		,error: function(err) {
			alert(err.responseText);
		}
	});
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
	var regExp =/^[0-9a-z]([-_\.]?[0-9a-z])*@[0-9a-z]([-_\.]?[0-9a-z])*\.[a-z]{2,3}$/i;

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
function AddEval(OrdSr,itID,OptCd){	
	location.href = '/apps/appCom/wish/webview/my10x10/goodsUsingWrite.asp?orderserial=' + OrdSr + '&itemid=' + itID + '&optionCD=' + OptCd + '';
}

//실명확인 여부확인 및 실명확인 페이지 이동
function jsChkRealname(cRNCheck) {
	if(cRNCheck=='Y') {
		return true;
	} else {
		if(confirm("실명확인을 하셔야 글을 남기실 수 있습니다.\n\n실명확인을 하시겠습니까?")) {
			location.href = '/apps/appCom/wish/webview/login/PopCheckName.asp';
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
		eval(frm+"."+strVal).style.display = 'inline-block';
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
		alert("로그인을 하세요.");
	}
	return false;

}


function TnGotoProduct(v){
	top.location.href = '/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid='+v;
}

// 파일 다운로드
function fileDownload(fileNo) {
    //alert('죄송합니다. 잠시 점검중입니다.');
    //return;
	if(jsChklogin(islogin())) {
	    window.appcallback.openbrowser("http://upload.10x10.co.kr/linkweb/download/fileDownload.asp?fn=" + fileNo);
	}
}

// 쇼셜네트워크로 글보내기
function popSNSPost(svc,tit,link,pre,tag) {
    // tit 및 link는 반드시 UTF8로 변환하여 호출요망!
    window.appcallback.openbrowser("http://m.10x10.co.kr/apps/snsPost/goSNSposts.asp?svc=" + svc + "&link="+link + "&tit="+tit + "&pre="+pre + "&tag="+tag);
}
// 카카오톡 링크공유
function kakaoLink(chk,code) {
    window.appcallback.openbrowser("http://m.10x10.co.kr/apps/snsPost/kakoLink.asp?chk="+chk+"&code="+code+"");
}
// 핀터레스트 공유
function pinit(link,img) {
    window.appcallback.openbrowser("http://pinterest.com/pin/create/button/?url="+link+"&media="+img);
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
	document.location = '/apps/appCom/wish/webview/shoppingtoday/shoppingchance_allevent.asp';
	}else{
	document.location = '/apps/appCom/wish/webview/event/eventmain.asp?eventid=' + v;
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

//브라우저 상단 숨김
if (navigator.userAgent.indexOf('MSIE') == -1) {
	window.addEventListener('load', function(){
		setTimeout(scrollTo, 0, 0, 1);
	}, false);
}
