<section class="pie">
	<div class="hgroup">
		<h2 class="headline"><%=nl2br(oPi.FItemList(i).Fshorttext)%></h2>
		<div class="writer"><a href="" onclick="fnAPPpopupPiece('조각모음','http://m.10x10.co.kr/apps/appcom/wish/web2014/piece/?adminid=<%=oPi.FItemList(i).Fadminid%>&piecepop=on','right');return false;"><span class="iam">By.</span> <span class="nickname"><%=oPi.FItemList(i).Fnickname%></span></a></div>
	</div>
	<div class="swiper-container">
		<div class="swiper-wrapper">
			<div class="swiper-slide">
				<div class="textarea">
					<a href="javascript:void(0);">
						<h3 class="headline"><%=oPi.FItemList(i).Flisttitle%></h3>
						<p><%=nl2br(oPi.FItemList(i).Flisttext)%></p>
					</a>
				</div>
			</div>
			<%
				Dim ii 
				set oPie = new Cgetpiece
				oPie.FRectPieceIdx = oPi.FItemList(i).FPieceidx
				oPie.GetPieList()
				
				For ii = 0 To oPie.FResultCount-1
			%>
			<div class="swiper-slide">
				<a href="" onclick="fnAPPpopupPiece('조각','http://m.10x10.co.kr/apps/appcom/wish/web2014/piece/share_result.asp?idx=<%=oPie.FPieceList(ii).Fidx%>&piecepop=on','right','share');return false;">
				<div class="thumbnail">
					<img src="<%=oPie.FPieceList(ii).Flistimg%>" alt="" />
					<h3 class="headline"><%=nl2br(oPie.FPieceList(ii).Fshorttext)%></h3>
				</div>
				</a>
			</div>
			<%
				Next 
			%>
		</div>
	</div>
</section>