<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 다이어리 스토리2017 브랜드 스페셜
' History : 2015.10.21 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/diarystory2017/lib/classes/specialbrandCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->

<%
', SortMet  , userid , GiftSu , vParaMeter, PrdBrandList, research, isusing, 
Dim i , imglink, PageSize , CurrPage
CurrPage 	= requestCheckVar(request("cpg"),9)
PageSize = 4
if CurrPage="" or CurrPage="0" then CurrPage=1

''스페셜 브랜드 테스트
dim oSpecialBrand
set oSpecialBrand = new DiaryCls
	oSpecialBrand.FPageSize = PageSize
	oSpecialBrand.FCurrPage = CurrPage
	oSpecialBrand.fcontents_list
%>
	<% if oSpecialBrand.FResultCount > 0 then %>
		<% for i=0 to oSpecialBrand.FResultCount - 1 %>
			<li class="box">
				<div class="pic"><img src="<%=staticImgUpUrl%>/diary/specialbrand/<%= oSpecialBrand.FItemList(i).fmomainbrandimg %>" alt="<%= oSpecialBrand.FItemList(i).Fbrandid %>" /><!-- for dev msg : alt 값에 브랜드명 넣어주세요 --></div>
				<div class="brandInfo">
					<% if oSpecialBrand.FItemList(i).fbrandmovieurl <> "" then %>
						<button type="button" class="btnPlay" id="mvurlid<%= oSpecialBrand.FItemList(i).fidx %>" onclick="mvclick('mvurlid<%= oSpecialBrand.FItemList(i).fidx %>'); return false;" ><span>동영상보기</span></button>
						<div class="videoWrap">
							<div class="video">
								<iframe src="<%= oSpecialBrand.FItemList(i).fbrandmovieurl %>" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
							</div>
						</div>
					<% end if %>
					<p class="name"><%= getbrandname(oSpecialBrand.FItemList(i).Fbrandid) %></p>
					<p class="desc"><%= oSpecialBrand.FItemList(i).fbrandtext %></p>
				</div>
				<div class="swiper-container diaryList">
					<ul class="swiper-wrapper">
					<%
					dim itemarr, imgarr, itemcnt, j, itembasicimg, itembasicid
					if isarray(split(oSpecialBrand.FItemList(i).fitemimgid,",")) then
						itemarr = split(oSpecialBrand.FItemList(i).fitemimgid,",")
						'imgarr = split(itemarr,"/!/")
						itemcnt = UBound(itemarr)+1
						for j = 0 to itemcnt-1
							itembasicimg	= split(itemarr(j),"/!/")(0)
							itembasicid	= split(itemarr(j),"/!/")(1)
					'		response.write itembasicimg &"........"&itembasicid&"<Br>"
					'		response.write itemarr(j) & "....."
					%>
						<% IF application("Svr_Info") = "Dev" THEN %>
							<li class="swiper-slide"><a href="" onclick="fnAPPpopupProduct('<%= itembasicid %>'); return false;"><img src="http://testwebimage.10x10.co.kr/image/tenten200/<%= GetImageSubFolderByItemid(trim(itembasicid)) %>/<%= trim(itembasicimg) %>" alt=""></a></li>
						<% else %>
							<li class="swiper-slide"><a href="" onclick="fnAPPpopupProduct('<%= itembasicid %>'); return false;"><img src="http://webimage.10x10.co.kr/image/tenten200/<%= GetImageSubFolderByItemid(trim(itembasicid)) %>/<%= trim(itembasicimg) %>" alt=""></a></li>
						<% end if %>
					<%
						next
					end if
					%>
					</ul>
				</div>
				<a href="" onclick="fnAPPpopupBrand('<%= oSpecialBrand.FItemList(i).Fbrandid %>'); return false;" class="btnFind"><span>브랜드 전체상품 보기</span></a>
			</li>
		<% next %>
	<% end if %>
<%
SET oSpecialBrand = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->