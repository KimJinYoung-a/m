var vPg=1, vScrl=true;
$(function(){
	/* tag and items */
	var tagitemSwiper = new Swiper(".tag-and-items .swiper-container", {
		slidesPerView:"auto",
		freeMode:true,
		freeModeMomentumRatio:0.5
	});

	/* best keyword */
	var bestkeywordSwiper = new Swiper(".piece-best-keyword .swiper-container", {
		slidesPerView:"auto",
		centeredSlides:true,
		loop:true
	});

	/* pie */
	var pieSwiper = new Swiper(".pie .swiper-container", {
		slidesPerView:"auto"
	});

	// 스크롤시 추가페이지 접수
	$(window).scroll(function() {
		var maxHeight = $(document).height();
		var currentScroll = $(window).scrollTop() + $(window).height();
		var recttext = $("#rect").val();
		if (recttext == "" || !recttext || !recttext == null ){
			recttext = "";
		}

		if ($(window).scrollTop() >= ($(document).height()-$(window).height())-570) {
			if(vScrl) {
				vScrl = false;
				vPg++;
				$.ajax({
					url: "act_index_ajax.asp?cpg="+vPg,
					data: "rect="+ recttext +"&adminid=<%=vAdminID%>&piecepop=<%=piecepop%>&RvSelPiece=<%=RvSelPiece%>&gaparam=piece_page_"+vPg,
					cache: false,
					success: function(message) {
						if(message!="") {
							$("#piecemore").append(message);
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
});

function jsPieceItemWish(i,idname){
	<% If IsUserLoginOK Then %>
	$.ajax({
		url: "/piece/act_piece_item_wish.asp?itemid="+i+"",
		cache: false,
		async: false,
		success: function(message) {
			if (message == "new"){
				alert("Piece에서 위시하신 상품은 \n'마이텐바이텐 > 나의 위시상품 > Piece' 폴더에 저장됩니다.");
			}

			if (message == "on" || message == "new"){
				$("."+idname).addClass("on");
			}else if (message == "off"){
				$("."+idname).removeClass("on");
			}
		}
	});
	<% Else %>
		<% If isapp="1" Then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/piece/")%>');
			return false;
		<% End If %>
	<% End If %>
}

function jsPieceSearch(v){
	var emptyhtml = "<div class='nodata nodata-piece'><p>검색하신 조각이 없습니다.</p></div>"
	$.ajax({
		url: "act_index_ajax.asp?cpg=1",
		data: "adminid=<%=vAdminID%>&piecepop=<%=piecepop%>&rect="+v,
		cache: false,
		success: function(message) {
			if(message!="") {
				$("#piecemore").empty().append(message);
				$("#rect").val(v);
				$('body,html').animate({scrollTop:0},0);
			}else{
				$("#piecemore").empty().append(emptyhtml);
				$("#rect").val(v);
			}
		}
		,error: function(err) {
			alert(err.responseText);
		}
	});
}