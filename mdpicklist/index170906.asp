<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/main/main_Pick.asp" -->
<%
'#######################################################
' Discription : mobile_mdpicklist 
' History : 2015-05-11 이종화 생성
'#######################################################
	Dim cPk , page , pagesize , intI
	page = requestCheckvar(request("page"),9)

	if (page="") then page = 1

	pagesize = "8"

	'Response.write page

	SET cPk = New CPick
		cPk.FPageSize = pagesize
		cPk.FCurrPage = page
		cPk.fnGetMdPickList()
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script>
var vPg=1, vScrl=true;
$(function(){
	// 스크롤시 추가페이지 접수
	$(window).scroll(function() {
		if ($(window).scrollTop() >= ($(document).height()-$(window).height())-512){
			if(vScrl) {
				vScrl = false;
				vPg++;
				$.ajax({
					url: "act_index.asp?page="+vPg,
					cache: false,
					success: function(message) {
						if(message!="") {
							$("#lyrEvtList").append(message);
							vScrl=true;
						} else {
							$(window).unbind("scroll");
						}
					}
					,error: function(err) {
						alert(err.responseText);
						$(window).unbind("scroll");
					}
				});
			}
		}
	});

	// 로딩중 표시
	$("#lyLoading").ajaxStart(function(){
		$(this).show();
	}).ajaxStop(function(){
		$(this).hide();
	});
});
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container bgGry">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<section class="todayMdPickV15">
					<h2 class="listPopTit">MD'S PICK</h2>
					<div class="mdDesc">최근 일주일간 MD'S PICK에 소개된 상품입니다.</div>
					<% If cPk.FResultCount > 0 Then %>
						<div class="pdtListWrap">
							<ul class="pdtList" id="lyrEvtList">
							<% For intI =0 To cPk.FResultCount-1 %>
								<li onclick="javascript:location.href='/category/category_itemPrd.asp?itemid=<%=cPk.FItemList(intI).Fitemid%>'" class="<%=chkiif(cPk.FItemList(intI).FLimitYn="Y" And cPk.FItemList(intI).Flimitno <= 10 And cPk.FItemList(intI).Flimitdispyn = "Y" ,"hurryUp","")%>">
									<div class="pPhoto"><p><span><em><%=chkiif(cPk.FItemList(intI).FLimitYn="Y" And cPk.FItemList(intI).Flimitno <= 10 And cPk.FItemList(intI).Flimitdispyn = "Y" ,"HURRY UP!","")%></em></span></p><img src="<%= getThumbImgFromURL(cPk.FItemList(intI).Fimage,400,400,"true","false") %>" alt="" /></div>
									<div class="pdtCont">
										<p class="pBrand"><%=UCase(cPk.FItemList(intI).Fbrandname)%></p>
										<p class="pName"><%=cPk.FItemList(intI).Fitemname%></p>
										<% If cPk.FItemList(intI).FsailYN = "N" and cPk.FItemList(intI).FcouponYn = "N" then %>
										<p class="pPrice"><%=formatNumber(cPk.FItemList(intI).ForgPrice,0)%>원 </p>
										<% End If 
											 If cPk.FItemList(intI).FsailYN = "Y" and cPk.FItemList(intI).FcouponYn = "N" Then %>
										<p class="pPrice"><%=formatNumber(cPk.FItemList(intI).FsellCash,0)%>원 <span class="cRd1"><% If CLng((cPk.FItemList(intI).ForgPrice-cPk.FItemList(intI).FsellCash)/cPk.FItemList(intI).ForgPrice*100)> 0 Then  %>[<%=CLng((cPk.FItemList(intI).ForgPrice-cPk.FItemList(intI).FsellCash)/cPk.FItemList(intI).ForgPrice*100)%>%]<% End If %></span></p>							
										<% End If 
											if cPk.FItemList(intI).FcouponYn = "Y" And cPk.FItemList(intI).Fcouponvalue>0 then%>
										<p class="pPrice">
											<%If cPk.FItemList(intI).Fcoupontype = "1" Then
												response.write formatNumber(cPk.FItemList(intI).FsellCash - CLng(cPk.FItemList(intI).Fcouponvalue*cPk.FItemList(intI).FsellCash/100),0)
											ElseIf cPk.FItemList(intI).Fcoupontype = "2" Then
												response.write formatNumber(cPk.FItemList(intI).FsellCash - cPk.FItemList(intI).Fcouponvalue,0)
											ElseIf cPk.FItemList(intI).Fcoupontype = "3" Then
												response.write formatNumber(cPk.FItemList(intI).FsellCash,0)
											Else
												response.write formatNumber(cPk.FItemList(intI).FsellCash,0)
											End If%>원 <span class="cGr1">[<%If cPk.FItemList(intI).Fcoupontype = "1" Then
												response.write CStr(cPk.FItemList(intI).Fcouponvalue) & "%"
											ElseIf cPk.FItemList(intI).Fcoupontype = "2" Then
												response.write formatNumber(cPk.FItemList(intI).Fcouponvalue,0) & "원 할인"
											ElseIf cPk.FItemList(intI).Fcoupontype = "3" Then
												response.write "무료배송"
											Else
												response.write cPk.FItemList(intI).Fcouponvalue
											End If %>]</span>
										</p>
										<% End If %>
									</div>
								</li>
							<% Next %>
							</ul>
						</div>
					<% End If %>
				</section>
			</div>
			<div id="lyLoading" style="display:none;position:relative;text-align:center; padding:20px 0;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>
<% SET cPk = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->