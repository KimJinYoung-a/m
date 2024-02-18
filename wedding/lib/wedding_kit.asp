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
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'#######################################################
' Discription : wedding_md_pick // cache DB경유
' History : 2018-04-18 정태훈 생성
'#######################################################
Dim poscode , icnt ,jcnt, totalsaleper, totalprice
Dim sqlStr , rsMem, arrList, intI, arrItemID

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime , dummyName
If timer > 10 And Cint(timer/60) < 6 Then
	cTime = 60*1
	dummyName = "WeddingKitMo_"&Cint(timer/60)
Else
	cTime = 60*5
	dummyName = "WeddingKitMo"
End If

'// foryou
sqlStr = "EXEC [db_sitemaster].[dbo].[usp_WWW_Wedding_Kit_Mobile_Get]"
set rsMem = getDBCacheSQL(dbget, rsget, dummyName, sqlStr, cTime)
IF Not (rsMem.EOF OR rsMem.BOF) THEN
	arrList = rsMem.GetRows
END IF
rsMem.close

on Error Resume Next

If IsArray(arrList) Then
%>
<script type="text/javascript">
<!--
function TnGotoProduct(itemid){
<% If isApp=1 Then %>
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '상품상세', [BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid='+itemid);
<% Else %>
	location.href='/category/category_itemPrd.asp?itemid='+itemid;
<% End If %>	
}
//-->
</script>
		<div class="kit">
			<div class="kit-head">
				<p>오직 텐텐에서만 만날 수 있는</p>
				<h3>Wedding Set</h3>
				<i></i>
			</div>
			<ul id="kit-list">
				<% For intI = 0 To ubound(arrlist,2) %>
				<li>
					<a href="" onclick="TnGotoProduct('<%=arrList(0,intI)%>');return false;">
						<div class="info">
							<p class="tag"><%=stripHTML(arrList(2,intI))%></p>
							<p class="name"><%=stripHTML(arrList(1,intI))%></p>
							<p class="price">할인가<span>할인율</span></p>
						</div>
						<div class="tumb"><img src="<%=arrList(3,intI)%>" alt="" /></div>
					</a>
				</li>
				<%arrItemID = arrItemID+Cstr(arrList(0,intI))+","%>
				<% Next %>
			</ul>
			<div class="more"><a href="" onclick="jsEventlinkURL(85324);return false;" class="">심플 웨딩 세트 전체 보기</a></div>
		</div>
<%
End If
on Error Goto 0
%>
<script type="text/javascript">
$(function(){
	fnApplyItemInfoList({
		items:"<%=left(arrItemID,Cint(Len(arrItemID)-1))%>",
		target:"kit-list",
		fields:["sale","price"],
		unit:"ew"
	});
});
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->