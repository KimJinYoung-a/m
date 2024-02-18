<%@ codepage="65001" language="VBScript" %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
response.charset = "utf-8"

const C_DIMX = 15
redim protocolNM(C_DIMX)
redim protocolJson(C_DIMX)
redim protocolURL(C_DIMX)
redim protocolComment(C_DIMX)
redim protocolFix(C_DIMX)

dim protocolVersion : protocolVersion="2"

dim DFTProto : DFTProto = "'OS':'android','versioncode':'49','versionname':'1.48','version':'"&protocolVersion&"'"
protocolNM(0) = "firstconnection"
protocolJson(0) = protocolJson(0) + "'type':'firstconnection'"
protocolJson(0) = protocolJson(0) + ",'pushid':'3422342342312349045290423424'"
protocolJson(0) = protocolJson(0) + ",'uuid':'ADFDSAF32AFDA4ADFDADSFDSAFS3FS'"
protocolURL(0) = "/apps/appCom/wish/protoV2/startupProc.asp"
protocolComment(0) = "response에 topmenu array 추가"
protocolFix(0) = 1

protocolNM(1) = "login protocol"
protocolJson(1) = protocolJson(1) + "'type':'login'"
protocolJson(1) = protocolJson(1) + ",'id':'test001'"
protocolJson(1) = protocolJson(1) + ",'password':'1942ABF3045858E6F9C4D28B22F69790'"
'protocolJson(1) = protocolJson(1) + ",'id':'icommang'"
'protocolJson(1) = protocolJson(1) + ",'password':'F4130130170ADBACE54B1AD041443CD1'"
protocolJson(1) = protocolJson(1) + ",'pushid':'3422342342312349045290423424'"
protocolJson(1) = protocolJson(1) + ",'uuid':'ADFDSAF32AFDA4ADFDADSFDSAFS3FS'"
protocolURL(1) = "/apps/appCom/wish/protoV2/loginProc.asp"
protocolComment(1) = "response myiconid 추가 / 회원등급, 쿠폰, 마일리지 는 쿠키값으로 처리 or 필요시 넘길 수 있음"
protocolFix(1) = 1

protocolNM(2) = "push id protocol"
protocolJson(2) = protocolJson(2) + "'type':'reg'"
protocolJson(2) = protocolJson(2) + ",'pushid':'3422342342312349045290423424'"
protocolJson(2) = protocolJson(2) + ",'uuid':'ADFDSAF32AFDA4ADFDADSFDSAFS3FS'"
protocolURL(2) = "/apps/appCom/wish/protoV2/deviceProc.asp"
protocolComment(2) = "기존 동일"
protocolFix(2) = 1

protocolNM(3) = "category list protocol"
protocolJson(3) = protocolJson(3) + "'type':'categorylist'"
protocolJson(3) = protocolJson(3) + ",'categoryid':''"
protocolURL(3) = "/apps/appCom/wish/protoV2/categoryListProc.asp"
protocolComment(3) = "기존 동일 - categoryid 빈값인경우 대카테고리, 값이있을경우 그 하위카테고리"
protocolFix(3) = 1

protocolNM(4) = "search item protocol - 카테고리 상품검색"
protocolJson(4) = protocolJson(4) + "'type':'searchlist'"
protocolJson(4) = protocolJson(4) + ",'offset':'0'"
protocolJson(4) = protocolJson(4) + ",'size':'50'"
protocolJson(4) = protocolJson(4) + ",'filter':{"
protocolJson(4) = protocolJson(4) + "'displaytype':'new'"
protocolJson(4) = protocolJson(4) + ",'pricelimitlow':''"
protocolJson(4) = protocolJson(4) + ",'pricelimithigh':''"
protocolJson(4) = protocolJson(4) + ",'color':["
'protocolJson(4) = protocolJson(4) + "{'colorindex':'1'},{'colorindex':'4'}"
protocolJson(4) = protocolJson(4) + "]"
protocolJson(4) = protocolJson(4) + ",'categoryid':'101101'"
protocolJson(4) = protocolJson(4) + ",'keyword':''"
protocolJson(4) = protocolJson(4) + ",'brandid':''"
protocolJson(4) = protocolJson(4) + ",'delitp':''"
protocolJson(4) = protocolJson(4) + "}"
protocolURL(4) = "/apps/appCom/wish/protoV2/searchItemProc.asp"
protocolComment(4) = "기존 동일"
protocolFix(4) = 1

protocolNM(5) = "search item protocol - 브랜드 상품검색"
protocolJson(5) = protocolJson(5) + "'type':'searchlist'"
protocolJson(5) = protocolJson(5) + ",'offset':'0'"
protocolJson(5) = protocolJson(5) + ",'size':'50'"
protocolJson(5) = protocolJson(5) + ",'filter':{"
protocolJson(5) = protocolJson(5) + "'displaytype':'new'"
protocolJson(5) = protocolJson(5) + ",'pricelimitlow':''"
protocolJson(5) = protocolJson(5) + ",'pricelimithigh':''"
protocolJson(5) = protocolJson(5) + ",'color':["
'protocolJson(5) = protocolJson(5) + "{'colorindex':'1'},{'colorindex':'4'}"
protocolJson(5) = protocolJson(5) + "]"
protocolJson(5) = protocolJson(5) + ",'categoryid':''"
protocolJson(5) = protocolJson(5) + ",'keyword':''"
protocolJson(5) = protocolJson(5) + ",'brandid':'mmmg'"
protocolJson(5) = protocolJson(5) + ",'delitp':''"
protocolJson(5) = protocolJson(5) + "}"
protocolURL(5) = "/apps/appCom/wish/protoV2/searchItemProc.asp"
protocolComment(5) = "기존 동일"
protocolFix(5) = 1
 
protocolNM(6) = "search item protocol - 검색어 상품검색"
protocolJson(6) = protocolJson(6) + "'type':'searchlist'"
protocolJson(6) = protocolJson(6) + ",'offset':'0'"
protocolJson(6) = protocolJson(6) + ",'size':'50'"
protocolJson(6) = protocolJson(6) + ",'filter':{"
protocolJson(6) = protocolJson(6) + "'displaytype':'new'"
protocolJson(6) = protocolJson(6) + ",'pricelimitlow':''"
protocolJson(6) = protocolJson(6) + ",'pricelimithigh':''"
protocolJson(6) = protocolJson(6) + ",'color':["
'protocolJson(6) = protocolJson(6) + "{'colorindex':'1'},{'colorindex':'4'}"
protocolJson(6) = protocolJson(6) + "]"
protocolJson(6) = protocolJson(6) + ",'categoryid':''"
protocolJson(6) = protocolJson(6) + ",'keyword':'우산'"
protocolJson(6) = protocolJson(6) + ",'brandid':''"
protocolJson(6) = protocolJson(6) + ",'delitp':''"
protocolJson(6) = protocolJson(6) + "}"
protocolURL(6) = "/apps/appCom/wish/protoV2/searchItemProc.asp"
protocolComment(6) = "연관검색어 추가예정, 해당 브랜드 리스트 추가"
protocolFix(6) = 1


protocolNM(7) = "best keyword protocol"
protocolJson(7) = protocolJson(7) + "'type':'bestkeyword'"
protocolURL(7) = "/apps/appCom/wish/protoV2/keywordProc.asp"
protocolComment(7) = "베스트 키워드 top N - 자주쿼리할 필요 없음 (쿼리 주기 - 1시간 정도)"
protocolFix(7) = 1


protocolNM(8) = "LNB protocol"
protocolJson(8) = protocolJson(8) + "'type':'lnbpersonal','pushid':'APA91bHwDG2EQrEkYOTmuiU1zGRgLp-CYRdIBzS5chidg4QJohLaLfsHIljqaURxzFrOc_bEMKaMGS-bNlfr3oQl2LxMs7XB_0-nzJG_bHz6KqSxfajvmSkLQAub9OhBpOi3VMn9_Imv9nqI2R8lcOt2BXlr_Gc3Yw','lastconfirmtime':'2014-03-01 23:55:02'"
protocolURL(8) = "/apps/appCom/wish/protoV2/LNBProc.asp"
protocolComment(8) = "왼쪽 메뉴 개인화 영역 - (쿼리 주기 (자동)로그인 직후, 1시간 단위)"
protocolFix(8) = 1

protocolNM(9) = "Brand info protocol"
protocolJson(9) = protocolJson(9) + "'type':'brandinfo'"
protocolJson(9) = protocolJson(9) + ",'brandid':'mmmg'"
protocolURL(9) = "/apps/appCom/wish/protoV2/brandInfoProc.asp"
protocolComment(9) = "response 수정 wiki 참조"
protocolFix(9) = 1

protocolNM(10) = "Set zzim brand protocol"
protocolJson(10) = protocolJson(10) + "'type':'setzzimbrand'"
protocolJson(10) = protocolJson(10) + ",'brandid':'mmmg'"
protocolJson(10) = protocolJson(10) + ",'kind':'add'"
protocolURL(10) = "/apps/appCom/wish/protoV2/setZzimBrandProc.asp"
protocolComment(10) = "찜브랜드 추가"
protocolFix(10) = 1


protocolNM(11) = "search item protocol - 검색어 상품검색(T)"
protocolJson(11) = protocolJson(11) + "'type':'searchlist'"
protocolJson(11) = protocolJson(11) + ",'offset':'0'"
protocolJson(11) = protocolJson(11) + ",'size':'50'"
protocolJson(11) = protocolJson(11) + ",'filter':{"
protocolJson(11) = protocolJson(11) + "'displaytype':'new'"
protocolJson(11) = protocolJson(11) + ",'pricelimitlow':''"
protocolJson(11) = protocolJson(11) + ",'pricelimithigh':''"
protocolJson(11) = protocolJson(11) + ",'color':["
'protocolJson(11) = protocolJson(11) + "{'colorindex':'1'},{'colorindex':'4'}"
protocolJson(11) = protocolJson(11) + "]"
protocolJson(11) = protocolJson(11) + ",'categoryid':''"
protocolJson(11) = protocolJson(11) + ",'keyword':'우산'"
protocolJson(11) = protocolJson(11) + ",'brandid':''"
protocolJson(11) = protocolJson(11) + ",'delitp':''"
protocolJson(11) = protocolJson(11) + "}"
protocolURL(11) = "/apps/appCom/wish/protoV2/searchItemProc_T.asp"
protocolComment(11) = "TEST"
protocolFix(11) = 0

protocolNM(12) = "autoComplete keyword protocol"
protocolJson(12) = protocolJson(12) + "'type':'autocomplete'"
protocolJson(12) = protocolJson(12) + ",'seedstr':'dn'"
protocolURL(12) = "/apps/appCom/wish/protoV2/keywordProc.asp"
protocolComment(12) = "검색어 자동완성"
protocolFix(12) = 1

protocolNM(13) = "notilist protocol"
protocolJson(13) = protocolJson(13) + "'type':'notilist','pushid':'APA91bHwDG2EQrEkYOTmuiU1zGRgLp-CYRdIBzS5chidg4QJohLaLfsHIljqaURxzFrOc_bEMKaMGS-bNlfr3oQl2LxMs7XB_0-nzJG_bHz6KqSxfajvmSkLQAub9OhBpOi3VMn9_Imv9nqI2R8lcOt2BXlr_Gc3Yw','lastconfirmtime':'2014-03-01 23:55:02'"
protocolURL(13) = "/apps/appCom/wish/protoV2/LNBProc.asp"
protocolComment(13) = "노티 팝업"
protocolFix(13) = 1


protocolNM(14) = "inappmsg protocol"
protocolJson(14) = protocolJson(14) + "'type':'evalcpn','ntoken':'TTTTT','nid':'aaaaaaaaaaaaaaaa'"
protocolURL(14) = "/apps/appCom/wish/protoV2/inappMsgProc.asp"
protocolComment(14) = "인앱메세지 쿠폰등 발행"
protocolFix(14) = 0

''기존.
''custom://login.custom                     //로그인창 호출
''custom://cartnum.custom?num="+num;        //장바구니 숫자 변경
''custom://opencategory.custom?"+param;     //카테고리 바로가기
''custom://brandproduct.custom?"+message; //브랜드 페이지 이동
''custom://openbrowser.custom?url="+url;    // 외부브라우저 호출? - 확인
''custom://uuid.custom?callback=jsCallbackUUID      // uuid
''custom://psid.custom?callback=jsCallbackPSID      // psid
''custom://version.custom?callback=jsCallbackVer    // versioninfo
''custom://topmenu.custom?id=               //앱 메뉴이동 (메뉴 아이디 사용하여 이동)

''추가.
''custom://ordercount.custom?cnt="+cnt;        //LNB 주문배송조회 숫자변경
''custom://myicon.custom?id="+id;              //마이 아이콘 변경
''custom://mycoupon.custom?cnt="+cnt;          //마이 쿠폰갯수 변경
''custom://mymileage.custom?mile="+mile;       //마이 마일리지 변경
''custom://todayview.custom?itemid="+itemid;   //오늘본상품 상품번호 추가(상품페이지에서 호출)
''custom://topmenumove.custom?id="+id;         //앱 메뉴이동 (메뉴 아이디 사용하여 이동)
''custom://topmenumoveurl.custom?id="+id+"&url="+url; //앱 메뉴이동 + URL 변경

''삭제.
''custom://gotoday.custom                   //today페이지 이동
''custom://gomain.custom                    //앱 메인페이지로 이동
''custom://goevent.custom                   //앱 이벤트로 이동
''custom://openhiswish.custom?uid="+uid;    //his위시메인
''custom://openevent.custom?url="+url;      //이벤트 링크 이동 ?


dim i
%>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<style type="text/css">
body {font-size: 9pt; font-family: "굴림";color:#000000}
table { border:1px solid gray }
</style>
<script language='javascript'>
function jREQ(i){
    var frm = document.frmjson;
    var iURL = frm.jurl[i].value
    var jsonVal = frm.json[i].value
    
   
    document.smFrm.json.value=jsonVal;
    document.smFrm.action=iURL;
    document.smFrm.target="ifrmtarget";
    
    document.smFrm.submit();
}

function jscustom(src){
    document.location.href=src;
}

function jsCallbackFunc(retval){
    alert(retval);
}

function FnGotoBrand(v){
	$.ajax({
		url: '/apps/appCom/wish/webview/lib/act_getBrandUrl.asp?makerid='+v,
		cache: false,
		success: function(message) {
			if(message!="") {
			    
				window.location.href = "custom://brandproduct.custom?" + message;
			}
		}
	});
}
</script>
<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js"></script>

</head>
<body>
    <table width="100%"  cellspacing="0" cellpadding="4">
    <form name="frmjson">
    <% for i=0 to C_DIMX-1 %>
    <tr ">
        <td >
            <%=CHKIIF(protocolFix(i)=1,"<strong>","")%>
            <%=i+1%>. <%=protocolNM(i)%>  <font color="<%=CHKIIF(protocolFix(i)=1,"#000000","gray")%>">| <%=protocolComment(i)%> </font>
            <%=CHKIIF(protocolFix(i)=1,"</strong>","")%>
        <br>URL : <%=protocolURL(i)%>
        </td>
        <td width="50" align="center"> 
        <input type="button" value="REQ" onClick="jREQ('<%=i%>')"> 
        </td>
    </tr>
    <tr>
        <td colspan="2">
        <input type="hidden" name="jurl" value="<%=protocolURL(i)%>">
        <input type="text" name="json" value='<%="{" + replace(DFTProto&","&protocolJson(i),"'","""")+ "}"%>' size="180">
        </td>
        
    </tr>
    <tr>
    <td colspan="2"></td>
    </tr>
    <% next %>
    </form>
    <tr >
        <td colspan="2" >
    <form name="smFrm" method="post" action="">
    <input type="hidden" name="json" value="">
    </form>
    <iframe id="ifrmtarget" name="ifrmtarget" frameborder="1" style="top:0;left:0;z-index:-1;width:100%;height:100%;border:1"></iframe>
        </td>
    </tr>
    </table>
    <p>
<% if (FALSE) then %>
    <table width="100%"  cellspacing="0" cellpadding="4">
    <tr>
        <td colspan="2"">기존 프로토콜 중 계속 사용 ------------------------------------ </td>
    </tr>


    <tr>
        <td>custom://login.custom</td>
        <td width="300" >로그인창 호출</td>
        <td width="100" ><input type="button" value="login" onClick="jscustom('custom://login.custom');"></td>
    </tr>
    <tr>
        <td>custom://cartnum.custom?num=3</td>
        <td >장바구니 숫자 변경</td>
        <td width="100" ><input type="button" value="cartnum" onClick="jscustom('custom://cartnum.custom?num=3');"></td>
    </tr>
    <tr>
        <td>custom://opencategory.custom?cd1=103&cd2=103108&nm1=캠핑/트래블&nm2=아웃도어</td>
        <td >카테고리 바로가기</td>
        <td width="100" ><input type="button" value="opencategory" onClick="jscustom('custom://opencategory.custom?cd1=103&cd2=103108&nm1=캠핑/트래블&nm2=아웃도어');"></td>
    </tr>
    <tr>
        <td>custom://brandproduct.custom?brandid=&englishname...</td>
        <td >브랜드 페이지 이동</td>
        <td width="100" ><input type="button" value="brandproduct" onClick="FnGotoBrand('mmmg');"></td>
    </tr>
    <tr>
        <td>custom://uuid.custom?callback=jsCallbackFunc</td>
        <td >uuid</td>
        <td width="100" ><input type="button" value="uuid" onClick="jscustom('custom://uuid.custom?callback=jsCallbackFunc');"></td>
    </tr>
    <tr>
        <td>custom://psid.custom?callback=jsCallbackFunc</td>
        <td >psid</td>
        <td width="100" ><input type="button" value="psid" onClick="jscustom('custom://psid.custom?callback=jsCallbackFunc');"></td>
    </tr>
    <tr>
        <td>custom://version.custom?callback=jsCallbackFunc</td>
        <td >versioninfo</td>
        <td width="100" ><input type="button" value="version" onClick="jscustom('custom://version.custom?callback=jsCallbackFunc');"></td>
    </tr>
    <tr>
        <td>custom://topmenu.custom?id=event</td>
        <td>앱 메뉴이동 (메뉴 아이디 사용하여 이동  - firstconnection topmenu.topid 값 )</td>
        <td width="100" ><input type="button" value="topmenu" onClick="jscustom('custom://topmenu.custom?id=event');"></td>
    </tr>
    <tr>
        <td>custom://openbrowser.custom?url=<%=server.Urlencode("http://m.10x10.co.kr/category/category_itemPrd.asp?itemid=1116607")%>  : 확인</td>
        <td >외부브라우저 호출?</td>
        <td width="100" ><input type="button" value="openbrowser" onClick="jscustom('custom://openbrowser.custom?url=<%=server.Urlencode("http://m.10x10.co.kr/category/category_itemPrd.asp?itemid=1116607")%>');"></td>
    </tr>
    
    <tr>
        <td colspan="2">신규 프로토콜 ------------------------------------</td>
    </tr>
    <tr>
        <td>custom://ordercount.custom?cnt=2</td>
        <td>LNB 주문배송조회 숫자변경</td>
        <td width="100" ><input type="button" value="ordercount" onClick="jscustom('custom://ordercount.custom?cnt=2');"></td>
    </tr>
    <tr>
        <td>custom://myicon.custom?id=3</td>
        <td>마이 아이콘 변경</td>
        <td width="100" ><input type="button" value="myicon" onClick="jscustom('custom://myicon.custom?id=3');"></td>
    </tr>
     <tr>
        <td>custom://mycoupon.custom?cnt=9</td>
        <td>마이 쿠폰갯수 변경</td>
        <td width="100" ><input type="button" value="mycoupon" onClick="jscustom('custom://mycoupon.custom?cnt=9');"></td>
    </tr>
    <tr>
        <td>custom://mymileage.custom?mile=345121</td>
        <td>마이 마일리지 변경</td>
        <td width="100" ><input type="button" value="mymileage" onClick="jscustom('custom://mymileage.custom?mile=345121');"></td>
    </tr>
    <tr>
        <td>custom://todayview.custom?itemid=1037099</td>
        <td>오늘본상품 상품번호 추가(상품페이지에서 호출)</td>
        <td width="100" ><input type="button" value="todayview" onClick="jscustom('custom://todayview.custom?itemid=1037099');"></td>
    </tr>
    
    <tr>
        <td>custom://topmenuurl.custom?id=event&url=<%=server.URLEncode("http://m.10x10.co.kr/category/category_itemPrd.asp?itemid=1116607")%></td>
        <td>앱 메뉴이동 (메뉴 아이디 사용하여 이동 및 웹뷰 URL 변경) 필요 여부 검토..?</td>
        <td width="100" ><input type="button" value="topmenuurl" onClick="jscustom('custom://topmenuurl.custom?id=event&url=<%=server.URLEncode("http://m.10x10.co.kr/category/category_itemPrd.asp?itemid=1116607")%>');"></td>
    </tr>
    
    <tr>
        <td colspan="2">기존 프로토콜 삭제 ------------------------------------</td>
    </tr>
    <tr>
        <td>custom://gotoday.custom</td>
        <td>today페이지 이동 =&gt; topmenu 통합</td>
        <td width="100" ><input type="button" value="gotoday" onClick="jscustom('custom://gotoday.custom');"></td>
    </tr>
    <tr>
        <td>custom://gomain.custom</td>
        <td>앱 메인페이지로 이동 =&gt; topmenu 통합</td>
        <td width="100" ><input type="button" value="gomain" onClick="jscustom('custom://gomain.custom');"></td>
    </tr>
     <tr>
        <td>custom://goevent.custom</td>
        <td>앱 이벤트로 이동 =&gt; topmenu 통합</td>
        <td width="100" ><input type="button" value="goevent" onClick="jscustom('custom://goevent.custom');"></td>
    </tr>
    <tr>
        <td>custom://openhiswish.custom?uid=</td>
        <td>his위시메인 =&gt; 웹뷰</td>
        <td width="100" ><input type="button" value="openhiswish" onClick="jscustom('custom://openhiswish.custom?uid=test001');"></td>
    </tr>
    <tr>
        <td>custom://openevent.custom?url=<%=server.urlencode("http://m.10x10.co.kr")%></td>
        <td>이벤트 페이지  링크 이동?</td>
        <td width="100" ><input type="button" value="openevent" onClick="jscustom('custom://openevent.custom?url=<%=server.urlencode("http://m.10x10.co.kr")%>');"></td>
    </tr>
    </table>
<% end if %>
</body>
</html>