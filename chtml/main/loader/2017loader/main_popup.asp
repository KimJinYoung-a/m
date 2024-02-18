<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.charset = "utf-8"
Session.Codepage = 65001
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'#######################################################
' Discription : mobile_main_popup // cache DB경유
' History : 2018-03-14 원승현 생성
'#######################################################
Dim poscode , intI ,intJ
Dim sqlStr , rsMem , arrList
Dim gaParam : gaParam = "&gaparam=today_popupbanner" '//GA 체크 변수
Dim CtrlDate : CtrlDate = now()
Dim limitcnt : limitcnt = 0 '//최대 배너 갯수

poscode = 2086

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime , dummyName
If timer > 10 And Cint(timer/60) < 6 Then
	cTime = 60*1
	dummyName = "MBMAINPOP_"&Cint(timer/60)
Else
	cTime = 60*1
	dummyName = "MBMAINPOP"
End If

IF poscode = "" THEN
	Call Alert_Return("잘못된 접근입니다.")
	response.End
END IF

sqlStr = "SELECT c.imageurl , c.linkurl , c.startdate ,  c.enddate , c.altname , c.maincopy , c.subcopy , c.maincopy2 , c.tag_gift ,  c.tag_plusone"
sqlStr = sqlStr & " , c.tag_launching , c.tag_actively , c.sale_per , c.coupon_per, c.evt_code, c.salediv , c.tag_only "
sqlStr = sqlStr & " FROM [db_sitemaster].[dbo].tbl_mobile_mainCont as c WITH(NOLOCK)"
sqlStr = sqlStr & " WHERE poscode = '"&poscode&"' "
sqlStr = sqlStr & " AND isusing = 'Y' AND isnull(imageurl,'') <> '' "
sqlStr = sqlStr & " AND startdate <= getdate() "
sqlStr = sqlStr & " AND enddate >= getdate() "
sqlStr = sqlStr & " ORDER BY orderidx ASC , idx DESC , poscode ASC"

'Response.write sqlStr

set rsMem = getDBCacheSQL(dbget, rsget, dummyName, sqlStr, cTime)
IF Not (rsMem.EOF OR rsMem.BOF) THEN
	arrList = rsMem.GetRows
END IF
rsMem.close

on Error Resume Next
intJ = 0
Dim img, link ,startdate , enddate , altname , alink , maincopy , maincopy2 ,  subcopy , tag_gift , tag_plusone , tag_launching ,  tag_actively , sale_per , coupon_per, evt_code, salePer, saleCPer, salediv , tag_only
If IsArray(arrList) Then
	img				= staticImgUrl & "/mobile/" + db2Html(arrlist(0,intI))
	link			= arrlist(1,intI)
	startdate		= arrlist(2,intI)
	enddate			= arrlist(3,intI)
	altname			= db2Html(arrlist(4,intI))
	maincopy		= db2Html(arrlist(5,intI))
	maincopy2		= db2Html(arrlist(7,intI))
	subcopy			= db2Html(arrlist(6,intI))
	tag_gift		= arrlist(8,intI)
	tag_plusone		= arrlist(9,intI)
	tag_launching	= arrlist(10,intI)
	tag_actively	= arrlist(11,intI)
	sale_per		= db2Html(arrlist(12,intI))
	coupon_per		= db2Html(arrlist(13,intI))
	evt_code		= arrlist(14,intI)
	salePer			= arrlist(15,intI)
	saleCPer		= arrlist(16,intI)
	salediv			= arrlist(17,intI)
	tag_only		= arrlist(18,intI)

    If instr(link, "?")>0 Then
        alink = db2Html(link) & "&" &gaParam
    Else
        alink = db2Html(link) & "?" &gaParam
    End If
%>
	<style>
	.mask {z-index:100; background-color:rgba(0,0,0,.85);}
	.front-bnr {position:fixed; left:50%; top:50%; z-index:99999; width:28.16rem; -webkit-transform:translate(-50%,-50%); transform:translate(-50%,-50%); display:none}
	.front-bnr button {position:absolute; bottom:-3.5rem; height:3.5rem; background-color:transparent; background-repeat:no-repeat; background-size:1.7rem;}
	.front-bnr .btn-group {border-top:solid 1px #383838; *zoom:1;}
	.front-bnr .btn-group:after {clear:both; display:block; content:' ';}
	.front-bnr a.btn-anymore, .front-bnr a.btn-close {display:block; float:left; position:relative; width:50%; height:3.18rem; background:#fff; color:#333; line-height:3.18rem; text-align:center;}
	.front-bnr a.btn-close:before {position:absolute; width:1px; height:3.18rem; background-color:#383838;left: 0; content:' ';}
	</style>
	<script>
		$(function(){
			var maskW = $(document).width();
			var maskH = $(document).height();
			$('#mask').css({'width':maskW,'height':maskH});		

			mainPopup();
			$('#mask').click(function(){
				$(".front-bnr").hide();
				$('#mask').hide();
			});		
		//setPopupCookie("todayPopupCookie", "done", -1)
		// mainPopUpCloseJustToday();		
		})
		function mainPopup(){//팝업띄우기
			var popCookie = getPopupCookie("todayPopupCookie");	
			var tempCookie = getPopupCookie("tempPopupCookie");		
			if(tempCookie){
				return false;
			}
			if(!popCookie){
				$(".front-bnr").show();
				$('#mask').show();						
			}
		}
		function mainPopUpClose(){
			$(".front-bnr").hide();
			$('#mask').hide();	
		}
		function mainPopUpCloseJustToday(){	//오늘 그만보기
			setPopupCookie("todayPopupCookie", "done", 1)
			$(".front-bnr").hide();
			$('#mask').hide();
		}	
		// 쿠키 가져오기  
		function getPopupCookie( name ) {  
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
		function setTempPopupCookie( name, value, expiredays ) {   
			var todayDate = new Date();   
			todayDate.setTime(todayDate.getTime() + 1*2000);
			document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"   
		}  
		function setPopupCookie( name, value, expiredays ) {   
			var todayDate = new Date();   
			todayDate.setDate( todayDate.getDate() + expiredays );   
			document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"   
		}	
	</script>

	<div class="front-bnr">
		<a href="<%=alink%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_mainlayerpopup', 'type|linkurl', 'click|<%=alink%>');"><img src="<%=img%>" alt="<%=altname%>"></a>
		<div class="btn-group">
			<a href="javascript:mainPopUpCloseJustToday();fnAmplitudeEventMultiPropertiesAction('click_mainlayerpopup', 'type|linkurl', 'neverview|<%=alink%>');" class="btn-anymore" >오늘 그만보기</a>
			<a href="javascript:mainPopUpClose();fnAmplitudeEventMultiPropertiesAction('click_mainlayerpopup', 'type|linkurl', 'close|<%=alink%>');" class="btn-close" >닫기</a>
		</div>
	</div>
	<div class="mask" id="mask"></div>
<% elseif false then %>
	<!-- #INCLUDE Virtual="/event/etc/layerbanner/app_banner.asp" -->
<% end if %>