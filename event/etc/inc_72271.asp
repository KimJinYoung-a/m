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
		eCode 		= "66178"
	Else
		eCode 		= "72271"
	End If
	
	
If Now() > #08/11/2016 00:00:00# Then
	vIsEnd = True
Else
	vIsEnd = False
End IF
%>
<style type="text/css">
img {vertical-align:top;}

#item .app {display:none;}

.forMeSwiper {position:relative;}
.forMeSwiper .timeTxt {position:absolute; left:0; top:23%; width:100%; z-index:20;}
.evtIngTxt {display:none;}
.evtEndTxt {display:block;}
.evtIng .evtIngTxt {display:block;}
.evtIng .evtEndTxt {display:none;}
.evtIng .bookSlt {padding-bottom:138%;}
.evtIng .bookSlt ul {height:66.5%;}
.evtIng .bookSlt .btnEnter {display:block;}

.forMeSwiper .swiper-container {width:100%;}
.forMeSwiper button {overflow:hidden; position:absolute; top:57%; z-index:5; width:7.5%; height:10%; background-color:transparent; background-position:50% 50%; background-repeat:no-repeat; background-size:100% auto; text-indent:-999em; outline:none;}
.forMeSwiper .btn-prev {left:7%; background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/72271/m/btn_slide_prev.png);}
.forMeSwiper .btn-next {right:7%; background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/72271/m/btn_slide_next.png);}
.forMeSwiper .pagination {position:absolute; bottom:12%; left:0; z-index:5; width:100%; height:3.3%; z-index:50; padding-top:0; text-align:center;}
.forMeSwiper .pagination .swiper-pagination-switch {display:inline-block; width:8.5%; height:100%; margin:0 1%; background-color:transparent; cursor:pointer;}

.bookSlt {position:relative; padding-bottom:105%; background:#fff url(http://webimage.10x10.co.kr/eventIMG/2016/72271/m/brand.png) no-repeat 50% 100%; background-size:100% auto;}
.bookSlt ul {overflow:hidden; position:absolute; left:0; top:0; width:100%; height:87.4%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/72271/m/img_book_select.png) no-repeat 50% 0; background-size:100% auto;}
.bookSlt ul li {overflow:hidden; float:left; width:33.333%; height:50%; text-indent:-999em;}
.bookSlt ul li.select {background:url(http://webimage.10x10.co.kr/eventIMG/2016/72271/m/img_book_select_on.png) no-repeat 50% 0; background-size:100% auto;}
.bookSlt .btnEnter {display:none; position:absolute; left:0; top:66%; width:100%; outline:none;}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.forMeSwiper .swiper-container',{
		loop:true,
		autoplay:4000,
		speed:800,
		pagination:".forMeSwiper .pagination",
		paginationClickable:true,
		nextButton:".forMeSwiper .btn-next",
		prevButton:".forMeSwiper .btn-prev",
		effect:"fade"
	});

	$('.bookSlt ul li').click(function(){
		$('.bookSlt ul li').removeClass('select');
		$(this).addClass('select');
	});
});

function jsSelectBook(b){
	$("#bookno").val(b);
	return false;
}

function jsSaveBook(){
	if($("#bookno").val() == ""){
		alert("6개의 도서 중 원하는 도서를 선택해주세요.");
		return false;
	}
	
<% If IsUserLoginOK() Then %>
	$.ajax({
		type: "GET",
		url: "/event/etc/doeventsubscript/doEventSubscript72271.asp",
		data: "mode=G&bookno="+$("#bookno").val()+"",
		cache: false,
		success: function(str) {
			str = str.replace("undefined","");
			res = str.split("|");
			if (res[0]=="OK") {
				alert(res[1]);
				return false;
			} else {
				errorMsg = res[1].replace(">?n", "\n");
				alert(errorMsg );
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
<form name="frm1" id="frm1" action="doEventSubscript72271.asp" method="post" style="margin:0px;">
<input type="hidden" name="bookno" id="bookno" value="1">
</form>
<div class="mEvt72271 <%=CHKIIF(vIsEnd,"","evtIng")%>">
	<div class="forMeSwiper">
		<p class="timeTxt evtEndTxt"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72271/m/txt_evt.png" alt="" /></p>
		<p class="timeTxt evtIngTxt"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72271/m/txt_evting.png" alt="" /></p>
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72271/m/tit01.png" alt="그리고, 쓰고, 만들고 - 나를 위한 시간" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72271/m/img01.png" alt="일상 드로잉, 손그림 푸드 일러스트 - 나누고 싶은 맛있는 그림!" /></p>
				</div>
				<div class="swiper-slide">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72271/m/tit02.png" alt="그리고, 쓰고, 만들고 - 나를 위한 시간" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72271/m/img02.png" alt="캘리그라피, 처음이세요? - 손글씨 맨 처음 연습장" /></p>
				</div>
				<div class="swiper-slide">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72271/m/tit03.png" alt="그리고, 쓰고, 만들고 - 나를 위한 시간" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72271/m/img03.png" alt="누가 그려도 예쁜 감성 수채화! - 작고 예쁜 그림 한 장" /></p>
				</div>
				<div class="swiper-slide">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72271/m/tit04.png" alt="그리고, 쓰고, 만들고 - 나를 위한 시간" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72271/m/img04.png" alt="드라이플라워에 대해 알고 싶었던 모든 것 - 꽃보다 드라이 플라워" /></p>
				</div>
				<div class="swiper-slide">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72271/m/tit05.png" alt="그리고, 쓰고, 만들고 - 나를 위한 시간" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72271/m/img05.png" alt="당신의 손글씨는 아직도 ‘흑백’인가요? - 수채 손글씨는 예뻐요" /></p>
				</div>
				<div class="swiper-slide">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72271/m/tit06.png" alt="그리고, 쓰고, 만들고 - 나를 위한 시간" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72271/m/img06.png" alt="따라 쓰고 싶은 손글씨체 66가지 - 손글씨 나혼자 조금씩" /></p>
				</div>
			</div>
		</div>
		<div class="pagination"></div>
		<button type="button" class="btn-prev">이전</button>
		<button type="button" class="btn-next">다음</button>
	</div>
	<div class="bookSlt">
		<ul>
			<li class="no1 select" onClick="jsSelectBook('1');">1 나누고 싶은 맛있는 그림</li>
			<li class="no2" onClick="jsSelectBook('2');">2 손글씨 맨 처음 연습장</li>
			<li class="no3" onClick="jsSelectBook('3');">3 작고 예쁜 그림 한장</li>
			<li class="no4" onClick="jsSelectBook('4');">4 꽃보다 드라이플라워</li>
			<li class="no5" onClick="jsSelectBook('5');">5 수채 손글씨는 예뻐요</li>
			<li class="no6" onClick="jsSelectBook('6');">6 나누고 싶은 맛있는 그림</li>
		</ul>
		<button class="btnEnter"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72271/m/btn_enter.png" alt="응모하기" onClick="jsSaveBook();" /></button>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->