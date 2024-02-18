<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'###########################################################
' Description :  기프트
' History : 2015.02.02 한용민 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/gift/giftCls.asp" -->
<!-- #include virtual="/gift/Underconstruction_gift.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->

<%
dim chint, i, j, currentdate, itemarr1, itemarr2, themeidx
	themeidx = getNumeric(requestcheckvar(request("themeidx"),10))
%>

<!-- #include virtual="/lib/inc/head.asp" -->
<script language='javascript'>

function searchtheme(themeidx){
	location.replace('/gift/gifthint/index.asp?themeidx='+themeidx)
}

</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container" style="background-color:#e7eaea;">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content giftV15a" id="contentArea">
				<h2 class="hidden">GIFT HINT</h2>
					<!-- #include virtual="/gift/inc_gift_menu.asp" -->
				<div class="giftHint">
					<%
					currentdate = date()

					SET chint = new CGiftTalk
						chint.frectexecutedate = currentdate
						'chint.frectthemeidx = themeidx
						chint.fitemtop = 6
						'chint.getGifthint_notpaging		'메인디비
						chint.getGifthint_notpaging_B		'캐쉬디비
					%>
					<% '<!-- for dev msg : 각 카테고리에 해당하는 him, teen, baby, her, home 클래스명 넣어주세요.ex) <div class="hint him">....</div> --> %>
					<% if chint.FResultCount > 0 then %>
						<% for i = 0 to chint.FResultCount - 1 %>
						<% if dateconvert(now()) > currentdate & " " & chint.FItemList(i).fexecutetime then %>
							<% if chint.FItemList(i).fitemarr<>"" then %>
								<div class="hint <%= Lcase(getthemetype(chint.FItemList(i).Fthemetype)) %>">
									<div class="topic">
										<h3><span><%= getthemetype(chint.FItemList(i).Fthemetype) %></span></h3>
										<span class="time">
											<%= getRegTimeTerm(currentdate & " " & chint.FItemList(i).fexecutetime,1) %>
										</span>
									</div>
									<div class="box1">
										<p class="desc"><%= chint.FItemList(i).Ftitle %></p>
										<ul>
											<%
											itemarr1="" : itemarr2=""
											itemarr1 = split(chint.FItemList(i).fitemarr,"|^|")
	
											if isarray(itemarr1) then
												for j = 0 to ubound(itemarr1)
												itemarr2 = split(replace(itemarr1(j),"^|",""),"|*|")
												
												if isarray(itemarr2) then
											%>
													<li>
														<a href="" onclick="TnGotoProduct('<%= itemarr2(0) %>'); return false;">
															<img src="<%= getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(itemarr2(0))&"/"&itemarr2(1),150,150,"true","false") %>" alt="<%= itemarr2(0) %>" />
															
															<% if IsSaleItem(itemarr2(6), itemarr2(5), itemarr2(4), itemarr2(3)) then %>
																<strong class="red"><span><%= getSalePro(itemarr2(5), itemarr2(4), itemarr2(3)) %></span></strong>
															<% end if %>
														</a>
													</li>
											<%
												end if
												next
											end if
											%>
										</ul>
									</div>
								</div>
							<% end if %>
						<% end if %>
						<% next %>
					<% end if %>
					<% set chint=nothing %>

					<%
					currentdate = dateadd("d",currentdate,-1)

					SET chint = new CGiftTalk
						chint.frectexecutedate = currentdate
						'chint.frectthemeidx = themeidx
						chint.fitemtop = 6
						'chint.getGifthint_notpaging		'메인디비
						chint.getGifthint_notpaging_B		'캐쉬디비
					%>
					<% '<!-- for dev msg : 각 카테고리에 해당하는 him, teen, baby, her, home 클래스명 넣어주세요.ex) <div class="hint him">....</div> --> %>
					<% if chint.FResultCount > 0 then %>
						<% for i = 0 to chint.FResultCount - 1 %>
						<% if chint.FItemList(i).fitemarr<>"" then %>
							<div class="hint <%= Lcase(getthemetype(chint.FItemList(i).Fthemetype)) %>">
								<div class="topic">
									<h3><span><%= getthemetype(chint.FItemList(i).Fthemetype) %></span></h3>
									<span class="time">
										<%= getRegTimeTerm(currentdate & " " & chint.FItemList(i).fexecutetime,1) %>
									</span>
								</div>
								<div class="box1">
									<p class="desc"><%= chint.FItemList(i).Ftitle %></p>
									<ul>
										<%
										itemarr1="" : itemarr2=""
										itemarr1 = split(chint.FItemList(i).fitemarr,"|^|")

										if isarray(itemarr1) then
											for j = 0 to ubound(itemarr1)
											itemarr2 = split(replace(itemarr1(j),"^|",""),"|*|")
											
											if isarray(itemarr2) then
										%>
												<li>
													<a href="" onclick="TnGotoProduct('<%= itemarr2(0) %>'); return false;">
														<img src="<%= getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(itemarr2(0))&"/"&itemarr2(1),150,150,"true","false") %>" alt="<%= itemarr2(0) %>" />
														
														<% if IsSaleItem(itemarr2(6), itemarr2(5), itemarr2(4), itemarr2(3)) then %>
															<strong class="red"><span><%= getSalePro(itemarr2(5), itemarr2(4), itemarr2(3)) %></span></strong>
														<% end if %>
													</a>
												</li>
										<%
											end if
											next
										end if
										%>
									</ul>
								</div>
							</div>
						<% end if %>
						<% next %>
					<% end if %>
					<% set chint=nothing %>

					<%
					currentdate = dateadd("d",currentdate,-1)

					SET chint = new CGiftTalk
						chint.frectexecutedate = currentdate
						'chint.frectthemeidx = themeidx
						chint.fitemtop = 6
						'chint.getGifthint_notpaging		'메인디비
						chint.getGifthint_notpaging_B		'캐쉬디비
					%>
					<% '<!-- for dev msg : 각 카테고리에 해당하는 him, teen, baby, her, home 클래스명 넣어주세요.ex) <div class="hint him">....</div> --> %>
					<% if chint.FResultCount > 0 then %>
						<% for i = 0 to chint.FResultCount - 1 %>
						<% if chint.FItemList(i).fitemarr<>"" then %>
							<div class="hint <%= Lcase(getthemetype(chint.FItemList(i).Fthemetype)) %>">
								<div class="topic">
									<h3><span><%= getthemetype(chint.FItemList(i).Fthemetype) %></span></h3>
									<span class="time">
										<%= getRegTimeTerm(currentdate & " " & chint.FItemList(i).fexecutetime,1) %>
									</span>
								</div>
								<div class="box1">
									<p class="desc"><%= chint.FItemList(i).Ftitle %></p>
									<ul>
										<%
										itemarr1="" : itemarr2=""
										itemarr1 = split(chint.FItemList(i).fitemarr,"|^|")

										if isarray(itemarr1) then
											for j = 0 to ubound(itemarr1)
											itemarr2 = split(replace(itemarr1(j),"^|",""),"|*|")
											
											if isarray(itemarr2) then
										%>
												<li>
													<a href="" onclick="TnGotoProduct('<%= itemarr2(0) %>'); return false;">
														<img src="<%= getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(itemarr2(0))&"/"&itemarr2(1),150,150,"true","false") %>" alt="<%= itemarr2(0) %>" />
														
														<% if IsSaleItem(itemarr2(6), itemarr2(5), itemarr2(4), itemarr2(3)) then %>
															<strong class="red"><span><%= getSalePro(itemarr2(5), itemarr2(4), itemarr2(3)) %></span></strong>
														<% end if %>
													</a>
												</li>
										<%
											end if
											next
										end if
										%>
									</ul>
								</div>
							</div>
						<% end if %>
						<% next %>
					<% end if %>
					<% set chint=nothing %>
				</div>
			</div>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->