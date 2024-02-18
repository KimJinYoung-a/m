<section class="pie">
	<div class="hgroup">
		<h2 class="headline"><%=nl2br(oPi.FItemList(i).Fshorttext)%></h2>
		<div class="writer"><a href="?adminid=<%=oPi.FItemList(i).Fadminid%>&piecepop=on"><span class="iam">By.</span> <span class="nickname"><%=oPi.FItemList(i).Fnickname%></span></a></div>
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
				<a href="/piece/share_result.asp?idx=<%=oPie.FPieceList(ii).Fidx%>&piecepop=on">
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