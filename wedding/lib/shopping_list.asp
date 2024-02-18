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
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'#######################################################
' Discription : wedding_쇼핑리스트 // cache DB경유
' History : 2018-04-16 정태훈 생성
'#######################################################
Dim poscode , icnt ,jcnt, totalsaleper, totalprice
Dim sqlStr , rsMem, arrList, intI

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime , dummyName
If timer > 10 And Cint(timer/60) < 6 Then
	cTime = 60*1
	dummyName = "WeddingMobileShoppingList_"&Cint(timer/60)
Else
	cTime = 60*5
	dummyName = "WeddingMobileShoppingList"
End If

'// foryou
sqlStr = "EXEC [db_sitemaster].[dbo].[usp_WWW_Wedding_ShoppingList_Mobile_Get]"
set rsMem = getDBCacheSQL(dbget, rsget, dummyName, sqlStr, cTime)
IF Not (rsMem.EOF OR rsMem.BOF) THEN
	arrList = rsMem.GetRows
END IF
rsMem.close

Function GetDDayTitleMo(ByVal WeddingStepID)
	If (WeddingStepID="1") Then
		GetDDayTitleMo =  "상견례"
	ElseIf (WeddingStepID="2") Then
		GetDDayTitleMo =  "혼수 가구 준비"
	ElseIf (WeddingStepID="3") Then
		GetDDayTitleMo =  "혼수 가전 준비"
	ElseIf (WeddingStepID="4") Then
		GetDDayTitleMo =  "웨딩 촬영"
	ElseIf (WeddingStepID="5") Then
		GetDDayTitleMo =  "리빙 아이템 준비"
	ElseIf (WeddingStepID="6") Then
		GetDDayTitleMo =  "브라이덜 샤워"
	ElseIf (WeddingStepID="7") Then
		GetDDayTitleMo =  "신혼여행 짐싸기"
	ElseIf (WeddingStepID="8") Then
		GetDDayTitleMo =  "집들이"
	End If
End Function

Function GetDDayImage(ByVal ItemID, UploadImage, BasicImage)
	If (UploadImage<>"") Then
		GetDDayImage = UploadImage
	Else
		GetDDayImage = "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(ItemID) + "/" + BasicImage
	End If
End Function

On Error Resume Next

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
			<div class="swiper">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<% For intI = 0 To ubound(arrlist,2) %>
						<% If arrList(0,intI)="1" Then %>
						<div class="swiper-slide d100">
						<% ElseIf arrList(0,intI)="2" Then %>
						<div class="swiper-slide d60">
						<% ElseIf arrList(0,intI)="3" Then %>
						<div class="swiper-slide d60">
						<% ElseIf arrList(0,intI)="4" Then %>
						<div class="swiper-slide d60">
						<% ElseIf arrList(0,intI)="5" Then %>
						<div class="swiper-slide d30">
						<% ElseIf arrList(0,intI)="6" Then %>
						<div class="swiper-slide d30">
						<% ElseIf arrList(0,intI)="7" Then %>
						<div class="swiper-slide d15">
						<% ElseIf arrList(0,intI)="8" Then %>
						<div class="swiper-slide d10">
						<% End If %>
							<div class="tumb"><a href="" onclick="TnGotoProduct('<%=arrList(1,intI)%>');return false;"><img src="<%=GetDDayImage(arrList(1,intI),arrList(2,intI),arrList(4,intI))%>" alt="<%=arrList(5,intI)%>" /></a></div>
							<div class="info">
								<p class="step"><%=GetDDayTitleMo(arrList(0,intI))%></p>
								<p><%=nl2br(arrList(3,intI))%></p>
							</div>
							<% If arrList(0,intI)="1" Then %>
							<div class="more"><a href="javascript:fnEvtItemList2(85159,240250,'tab1');">D-100 쇼핑리스트 더보기</a></div>
							<% ElseIf arrList(0,intI)="2" Then %>
							<div class="more"><a href="javascript:fnEvtItemList2(85159,240256,'tab2');">D-60 쇼핑리스트 더보기</a></div>
							<% ElseIf arrList(0,intI)="3" Then %>
							<div class="more"><a href="javascript:fnEvtItemList2(85159,240256,'tab2');">D-60 쇼핑리스트 더보기</a></div>
							<% ElseIf arrList(0,intI)="4" Then %>
							<div class="more"><a href="javascript:fnEvtItemList2(85159,240256,'tab2');">D-60 쇼핑리스트 더보기</a></div>
							<% ElseIf arrList(0,intI)="5" Then %>
							<div class="more"><a href="javascript:fnEvtItemList2(85159,240262,'tab3');">D-30 쇼핑리스트 더보기</a></div>
							<% ElseIf arrList(0,intI)="6" Then %>
							<div class="more"><a href="javascript:fnEvtItemList2(85159,240268,'tab3');">D-30 쇼핑리스트 더보기</a></div>
							<% ElseIf arrList(0,intI)="7" Then %>
							<div class="more"><a href="javascript:fnEvtItemList2(85159,240268,'tab4');">D-15 쇼핑리스트 더보기</a></div>
							<% ElseIf arrList(0,intI)="8" Then %>
							<div class="more"><a href="javascript:fnEvtItemList2(85159,240276,'tab5');">D+10 쇼핑리스트 더보기</a></div>
							<% End If %>
						</div>
						<% Next %>
					</div>
				</div>
			<!-- <div class="pagination"></div> -->
			<button type="button" class="btnNav btnPrev">이전</button>
			<button type="button" class="btnNav btnNext">다음</button>
			</div>
<%
End If
On Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->