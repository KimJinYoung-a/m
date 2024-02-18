<%
	Dim vCommonScript
	vCommonScript = "$(""#lyUrl"").hide();" & vbCrLf
	vCommonScript = vCommonScript & "$(""#snsPlaying ul li.url a"").click(function(){" & vbCrLf
	vCommonScript = vCommonScript & "	$(""#lyUrl"").show();" & vbCrLf
	vCommonScript = vCommonScript & "	$(""#mask"").show();" & vbCrLf
	vCommonScript = vCommonScript & "});" & vbCrLf
	vCommonScript = vCommonScript & "$(""#lyUrl .btnclose, #mask"").click(function(){" & vbCrLf
	vCommonScript = vCommonScript & "	$(""#lyUrl"").hide();" & vbCrLf
	vCommonScript = vCommonScript & "	$(""#mask"").fadeOut();" & vbCrLf
	vCommonScript = vCommonScript & "});" & vbCrLf
%>
<style type="text/css">
.gnbWrapV16a {display:none;}
</style>
<% If vCate = "1" Then	'### playlist %>
<script type="text/javascript">
$(function(){
	<%=vCommonScript%>
	
	<% If RequestCheckVar(request("iscomm"),1) = "o" Then %>
	setTimeout("jsCa1Down()",500);
	<% End If %>
});

function jsCa1Down(){
	window.$('html,body').animate({scrollTop:$("#licmt1").offset().top}, 0);
}

function jsCa1Page(p){
	frm1com.page.value = p;
	frm1com.submit();
}

function jsCa1ComDel(i){
	frm1comdel.idx.value = i;
	frm1comdel.submit();
}
</script>
<% ElseIf vCate = "3" Then	'### azit %>
<script type="text/javascript">
$(function(){
	<%=vCommonScript%>
	
	function sticky_relocate() {
		var window_top = $(window).scrollTop();
		var div_top = $("#header").offset().top;
		if (window_top > div_top){
			$("#cover").addClass("sticky");
		} else {
			$("#cover").removeClass("sticky");
		}
	}

	$(function() {
		$(window).scroll(sticky_relocate);
	});

	/* swipe */
	var swiper1 = new Swiper("#placeRolling1 .swiper-container", {
		slidesPerView:"auto",
		pagination:"#placeRolling1 .paginationDot",
		paginationClickable:true,
		speed:800
	});

	var swiper2 = new Swiper("#placeRolling2 .swiper-container", {
		slidesPerView:"auto",
		pagination:"#placeRolling2 .paginationDot",
		paginationClickable:true,
		speed:800
	});

	var swiper3 = new Swiper("#placeRolling3 .swiper-container", {
		slidesPerView:"auto",
		pagination:"#placeRolling3 .paginationDot",
		paginationClickable:true,
		speed:800
	});

	var swiper4 = new Swiper("#placeRolling4 .swiper-container", {
		slidesPerView:"auto",
		pagination:"#placeRolling4 .paginationDot",
		paginationClickable:true,
		speed:800
	});

	/* noti */
	$("#noti .noticontents").hide();
	$("#noti h3 a").click(function(){
		$("#noti .noticontents").slideDown();
		$("#noti h3").hide();
		return false;
	});

	$("#noti .btnFold").click(function(){
		$("#noti .noticontents").slideUp();
		$("#noti h3").show();
	});
	
	<% If RequestCheckVar(request("iscomm"),1) = "o" Then %>
	setTimeout("jsCa3Down()",500);
	<% End If %>
});

function jsCa3Down(){
	window.$('html,body').animate({scrollTop:$("#licmt3").offset().top}, 0);
}

function jsCa3Page(p){
	frm3com.page.value = p;
	frm3com.submit();
}

function jsCa3ComDel(i){
	frm3comdel.idx.value = i;
	frm3comdel.submit();
}
</script>
<% ElseIf vCate = "42" Then	'### thingthing %>
<script type="text/javascript">
$(function(){
	<%=vCommonScript%>

	checkWidth();
	function checkWidth() {
		var boxWidth = $(".thingthing .hgroup").width();
		$(".thingthing .hgroup").css({"width":boxWidth, margin:"0 0 0"+"-"+($(".thingthing .hgroup").width() / 2)+"px"});
	}
	
	$(window).resize(function() {
		checkWidth();
	});
	
	/* swiper js rolling */
	if ($("#thingRolling .swiper-container .swiper-slide").length > 1) {
		var swiper1 = new Swiper("#thingRolling .swiper-container", {
			pagination:"#thingRolling .paginationDot",
			paginationClickable:true,
			loop:true,
			speed:800
		});
	} else {
		var swiper1 = new Swiper("#thingRolling .swiper-container", {
			pagination:false,
			noSwipingClass:".noswiping",
			noSwiping:true
		});
	}

	/* noti */
	$("#noti .noticontents").hide();
	$("#noti h3 a").click(function(){
		$("#noti .noticontents").slideDown();
		$("#noti h3").hide();
		return false;
	});

	$("#noti .btnFold").click(function(){
		$("#noti .noticontents").slideUp();
		$("#noti h3").show();
	});
	
	<% If RequestCheckVar(request("iscomm"),1) = "o" Then %>
	setTimeout("jsCa42Down()",500);
	<% End If %>
});

function jsCa42Down(){
	window.$('html,body').animate({scrollTop:$("#licmt42").offset().top}, 0);
}

function jsCa42Page(p){
	frm42ent.page.value = p;
	frm42ent.submit();
}

function chkfrm42(f){
<% If IsUserLoginOK() Then %>
	if(f.entryvalue.value == ""){
		alert("내 이름을 지어주세요!");
		f.entryvalue.focus();
		return false;
	}
	return true;
<% Else %>
	<% if isApp=1 then %>
		parent.calllogin();
		return false;
	<% else %>
		parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
		return false;
	<% end if %>
<% End If %>
}

function jsCa42EntDel(i){
	frm42entdel.idx.value = i;
	frm42entdel.submit();
}

function jsTCommentEnd(){
	alert("응모기간이 마감되었습니다.\n당첨자 발표를 기대 해 주세요!");
	return false;
}
</script>
<% ElseIf vCate = "5" Then	'### comma %>
<script type="text/javascript">
$(function(){
	<%=vCommonScript%>
	
	function sticky_relocate() {
		var window_top = $(window).scrollTop();
		var div_top = $("#header").offset().top;
		if (window_top > div_top){
			$("#cover").addClass("sticky");
		} else {
			$("#cover").removeClass("sticky");
		}
	}

	$(function() {
		$(window).scroll(sticky_relocate);
	});
});
</script>
<% ElseIf vCate = "31" Then	'### AZIT&COMMA %>
<script type="text/javascript">
$(function(){
	<%=vCommonScript%>
	
	function sticky_relocate() {
		var window_top = $(window).scrollTop();
		var div_top = $("#header").offset().top;
		if (window_top > div_top){
			$("#cover").addClass("sticky");
		} else {
			$("#cover").removeClass("sticky");
		}
	}

	$(function() {
		$(window).scroll(sticky_relocate);
	});
});
</script>
<% Else %>
<script type="text/javascript">
$(function(){
	<%=vCommonScript%>
});
</script>
<% End If %>