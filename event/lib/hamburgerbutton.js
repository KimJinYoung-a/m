
$(function(){
    $("#navFashion").hide();
    $("#hamburger").click(function(){
        if ($(this).hasClass("open")){
            $("#navFashion").hide();
            $("#dimmed").hide();
            $(this).removeClass("open");
        } else {
            $("#navFashion").show();
            $("#dimmed").show();
            $(this).addClass("open");
        }
        return false;
    });

    $("#dimmed").click(function(){
        $("#navFashion").hide();
        $("#dimmed").hide();
        $("#hamburger").removeClass("open");
    });
});

function fnGetListHeader(pg , ecode , evtkind) {
	var str = $.ajax({
		type: "GET",
		url: "/event/lib/hamburgerbutton.asp",
		data: "eventid="+ ecode +"&page="+pg+"&evt_kind="+evtkind,
		dataType: "text",
		async: false
	}).responseText;
	if(str!="") {
		$("#FMHeaderNew").empty().html(str);
	}
}

function goLayerPage(pg , ecode , evtkind) {
	var str = $.ajax({
		type: "GET",
		url: "/event/lib/hamburgerbutton.asp",
		data: "eventid="+ ecode +"&page="+pg+"&evt_kind="+evtkind,
		dataType: "text",
		async: false
	}).responseText;
	if(str!="") {
		$("#FMHeaderNew").empty().html(str);
		$("#navFashion").show();
		$("#dimmed").show();
		$(this).addClass("open");
	}
}
