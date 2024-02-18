<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/playing/playingCls.asp" -->
<%
	Dim cPl, i, vStartDate, vState, vPage, vPageSize, vTotalCount, vCate
	vStartDate = "getdate()"
	vState = "7"
	
	vPage = NullFillWith(RequestCheckVar(request("page"),3),"1")
	vCate = NullFillWith(RequestCheckVar(request("cate"),5),"")
	vPageSize = "12"
	'vPageSize = "3"
	
	SET cPl = New CPlay
	cPl.FRectIsMain		= False
	cPl.FCurrPage			= vPage
	cPl.FPageSize			= vPageSize
	cPl.FRectTop			= vPage*vPageSize
	cPl.FRectStartdate 	= vStartDate
	cPl.FRectState 		= vState
	cPl.FRectCate 		= vCate
	
	'### m.midx, m.volnum, m.title, m.mo_bgcolor
	cPl.fnPlayMainCornerList()
	vTotalCount = cPl.FTotalCount
	
	strHeadTitleName = "PLAYing"
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script type="text/javascript">
function jsGoPage(iP){
	document.frmSC.page.value = iP;
	document.frmSC.submit();
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<div class="content playV16" id="contentArea">
				<article class="playListV15">
					<h2><span><i>PLAY ing</i> 당신의 감성을 플레이하다</span></h2>
					<!-- #include file="./headerPlay.asp" -->
					<div class="listPlay list<%=fnClassNameToNewCate(vCate)%>">
						<section>
							<ul>
								<%
								If (cPl.FResultCount < 1) Then
								Else
									For i = 0 To cPl.FResultCount-1
								%>
									<li class="<%=LCase(fnClassNameToCate(cPl.FItemList(i).Fcate))%>">
										<a href="view.asp?didx=<%=cPl.FItemList(i).Fdidx%>">
											<%
											'### 띵41,띵띵41,아지트3 이고 테그노출인경우. 노출기간, 발표일 기간 따로 정해져있음.
											If cPl.FItemList(i).Fcate = "3" OR cPl.FItemList(i).Fcate = "41" OR cPl.FItemList(i).Fcate = "42" Then
												If cPl.FItemList(i).Fistagview Then
													If CDate(cPl.FItemList(i).Ftag_sdate) <= date() AND CDate(cPl.FItemList(i).Ftag_edate) => date() Then
														Response.Write "<span class=""label together""><em>참여</em></span>"
													End If
													If CDate(cPl.FItemList(i).Ftag_announcedate) <= date() Then
														Response.Write "<span class=""label done""><em>당첨<br />발표</em></span>"
													End If
												Else
													If DateDiff("d",cPl.FItemList(i).Fstartdate,Now()) < 4 Then	'### 오픈후 3일동안
														Response.Write "<span class=""label""><em>NEW</em></span>"
													End If
												End If
											Else
												If DateDiff("d",cPl.FItemList(i).Fstartdate,Now()) < 4 Then	'### 오픈후 3일동안
													Response.Write "<span class=""label""><em>NEW</em></span>"
												End If
											End IF
											
											If cPl.FItemList(i).Fcate <> "5" Then	'### comma 제외
												Response.Write "<div class=""figure"">"
												Response.Write "	<img src=""" & cPl.FItemList(i).Fimgurl & """ alt="""" />"
												If cPl.FItemList(i).Fcate = "1" OR cPl.FItemList(i).Fcate = "3" OR cPl.FItemList(i).Fcate = "6" Then
													If cPl.FItemList(i).Fcate = "3" Then
														Response.Write "<span class=""ico""><img src="""&cPl.FItemList(i).Ficonimg&""" alt= """"/></span>"
													Else
														Response.Write "<span class=""ico""><img src=""http://fiximage.10x10.co.kr/m/2016/play/ico_pictogram_00"&cPl.FItemList(i).Fcate&".png"" alt= """"/></span>"
													End If
												End If
												Response.Write "</div>"
											End If
											%>
											<p class="desc">
												<b><%=cPl.FItemList(i).Ftitle%></b>
												<span><%=fnPlayingCateVer2("topname",cPl.FItemList(i).Fcate)%></span>
											</p>
										</a>
									</li>
								<%
									Next
								End If
								%>
							</ul>
						</section>
						<%= fnDisplayPaging_New(vPage, vTotalCount, vPageSize, 4,"jsGoPage") %>
						<form name="frmSC" method="get" style="margin:0px;">
						<input type="hidden" name="page" >
						<input type="hidden" name="cate" value="<%=vCate%>">
						</form>
					</div>
				</article>
			</div>
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>
<% SET cPl = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->