<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, vIsEnd
	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "66186"
	Else
		eCode 		= "72616"
	End If
	
	
If Now() > #09/06/2016 00:00:00# Then
	vIsEnd = True
Else
	vIsEnd = False
End IF
%>
<style type="text/css">
img {vertical-align:top;}
.btnApply button {width:100%; background:transparent; vertical-align:top;}
.preview {padding:0 6%; background-color:#fff5e5;}
.preview .video .youtube {overflow:hidden; position:relative; height:0; padding-bottom:62.35%; background:#000;}
.preview .video .youtube iframe {position:absolute; top:0; left:0; width:100%; height:100%}
.rolling .swiper {position:relative;}
.rolling .swiper .swiper-container {width:100%;}
.rolling button {position:absolute; top:38%; z-index:20; width:9.6%; padding:5% 0; background-color:transparent;}
.rolling .swiper .btn-prev {left:0;}
.rolling .swiper .btn-next {right:0;}
.rolling .swiper .pagination {position:absolute; bottom:-11%; left:0; width:100%; height:auto; z-index:50; padding-top:0; text-align:center;}
.rolling .swiper .pagination .swiper-pagination-switch {width:0.8rem; height:0.8rem; margin:0 0.5rem; border:0; background-color:#dbc6a3;}
.rolling .swiper .pagination .swiper-active-switch {background-color:#ec80ca;}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper("#rolling .swiper-container",{
		loop:true,
		autoplay:2500,
		speed:800,
		pagination:"#rolling .pagination",
		paginationClickable:true,
		prevButton:'#rolling .btn-prev',
		nextButton:'#rolling .btn-next'
	});
});

function jsSaveTicket(){

<% If vIsEnd Then %>
	alert("이벤트가 종료되었습니다.");
	return false;
<% End If %>

<% If IsUserLoginOK() Then %>
	$.ajax({
		type: "GET",
		url: "/event/etc/doeventsubscript/doEventSubscript72616.asp",
		data: "mode=G",
		cache: false,
		success: function(str) {
			str = str.replace("undefined","");
			res = str.split("|");
			if (res[0]=="OK") {
				alert(res[1]);
				$('html, body').animate({scrollTop: $("#group186937").offset().top}, 'fast')
				return false;
			} else {
				errorMsg = res[1].replace(">?n", "\n");
				alert(errorMsg );
				$('html, body').animate({scrollTop: $("#group186937").offset().top}, 'fast')
				return false;
			}
		}
		,error: function(err) {
			console.log(err.responseText);
			alert("통신중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
		}
	});
<% else %>
		if ("<%=IsUserLoginOK%>"=="False") {
			<% If isapp="1" Then %>
				parent.calllogin();
				return;
			<% else %>
				parent.jsevtlogin();
				return;
			<% End If %>
		}
<% end if %>
}
</script>
<form name="frm1" id="frm1" action="doEventSubscript72616.asp" method="post" style="margin:0px;">
</form>
<div class="mEvt72616">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/72616/m/tit_alice.jpg" alt="거울나라의 앨리스 IN 텐바이텐" /></h2>
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/72616/m/img_poster.jpg" alt="" /></div>
	<div class="btnApply"><button type="button" class="btnApply" onClick="jsSaveTicket();"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72616/m/btn_apply.jpg" alt="예매권 응모하기" /></button></div>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72616/m/txt_info.jpg" alt="MOVIE INFO" /></p>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72616/m/txt_story.jpg" alt="이제 이상한 나라로 돌아갈 시간! 모자 장수를 구하기 위한 앨리스의 스펙타클한 시간여행이 시작된다! " /></p>
	<div class="preview">
		<div id="rolling" class="rolling">
			<div class="swiper">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide">
							<div class="video">
								<div class="youtube">
									<iframe src="https://www.youtube.com/embed/M6u7BN2FO54" title="거울나라의 앨리스 메인 예고편" frameborder="0" allowfullscreen></iframe>
								</div>
							</div>
						</div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72616/m/img_slide_01.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72616/m/img_slide_02.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72616/m/img_slide_03.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72616/m/img_slide_04.jpg" alt="거친 바다를 항해하며 배의 선장으로 지내온 ‘앨리스’는 런던에 돌아와 참석한 연회에서 나비가 된 ‘압솔렘’을 만나게 되고, 거울을 통해 이상한 나라로 돌아가게 된다. 그 곳에서 앨리스는 ‘하얀 여왕’을 만나 위기에 처한 ‘모자 장수’의 얘기를 듣게 되고 ‘시간’의 크로노스피어를 훔쳐 과거로 돌아가 ‘모자 장수’를 구하려고 한다. 한편, 하얀 여왕에 의해 아웃랜드로 추방되었던 ‘붉은 여왕’ 또한 크로노스피어를 호시탐탐 노리고, 앨리스는 ‘붉은 여왕’과 ‘시간’으로부터 벗어나 모자 장수를 구하기 위한 스펙타클한 시간여행을 시작하게 되는데…" /></div>
					</div>
				</div>
				<div class="pagination"></div>
				<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72616/m/btn_prev.png" alt="이전" /></button>
				<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72616/m/btn_next.png" alt="다음" /></button>
			</div>
		</div>
	</div>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72616/m/txt_disney.jpg" alt="" /></p>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->