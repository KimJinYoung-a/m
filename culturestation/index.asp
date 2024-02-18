<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/culturestation/culture_stationcls.asp" -->
<%
	'// 이벤트 목록 접수
	dim oevent, oeventtop, i, chkBig, bnrImg
	dim page, etype, sortMtd, viewlist, mylist
	page = getNumeric(requestCheckVar(request("page"),10))
	etype = getNumeric(requestCheckVar(request("etype"),1))
	sortMtd = requestCheckVar(request("sort"),3)
	viewlist = requestCheckVar(request("viewlist"),1)
	mylist = requestCheckVar(request("mylist"),1)
	if page="" then page=1
	'if etype="" then etype="0"
	if sortMtd="" then sortMtd="dl"
	If viewlist="" Then viewlist="L"
	
	set oevent = new cevent_list
	oevent.FCurrPage = page
	oevent.FPageSize = 10		'한페이지 16개 (추가 접수는 18개)
	oevent.frectevt_type = etype
	oevent.frectSrotMtd = sortMtd
	If mylist="Y" Then
	oevent.frectUserid = GetEncLoginUserID()
	End If
	oevent.fevent_list()

	set oeventtop = new cevent_list
	oeventtop.fevent_top5_list()
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>텐바이텐 10X10 : Culture Station</title>
<script>
<!--

function TnSortChange(objval){
	location.href="?etype=<%=etype%>&sort="+objval;
}

function TnSelectGridView(objval){
	var linkurl;
	if($("#more").val()=="Y"){
		linkurl="act_culturestation_event_list_more.asp";
	}else{
		linkurl="act_culturestation_event_list.asp";
	}

	if(objval=="G"){
		objval="L";
		$(".sortingbar").addClass(" grid");
	}else{
		objval="G";
		$(".sortingbar").removeClass(" grid");
	}
	$.ajax({
		url: linkurl+"?page="+$("#page").val()+ "&page2=" + $("#page2").val()  + "&etype="+$("#etype").val()+"&sort="+$("#sortview").val()+"&viewlist="+objval,
		cache: false,
		async: false,
		success: function(message) {
			
			if(message!="") {
				$str = $(message)
				// 박스 내용 추가
				$("#listview").empty();
				$('#listview').append($str);
				$("#viewlist").val(objval);
				$("#cnt").html($("#tcount").val());
			} else {
									
			}
		}
	});
}

function TnSelectSortView(){
	var linkurl;
	if($("#more").val()=="Y"){
		linkurl="act_culturestation_event_list_more.asp";
	}else{
		linkurl="act_culturestation_event_list.asp";
	}

	$.ajax({
		url: linkurl+"?page=" + $("#page").val() + "&page2=" + $("#page2").val() + "&etype="+$("#etype").val()+"&sort="+$("#sortview").val()+"&viewlist="+$("#viewlist").val(),
		cache: false,
		async: false,
		success: function(message) {
			if(message!="") {
				$str = $(message)
				// 박스 내용 추가
				$("#listview").empty();
				$('#listview').append($str);
				$("#cnt").html($("#tcount").val());
				//alert(message); 
			} else {
									
			}
		}
	});
}
function TnSortView(objval){
	if(objval==""){
		$("#etype1").addClass("on");
		$("#etype2").removeClass("on");
		$("#etype3").removeClass("on");
		$("#etype").val(objval);
	}else if(objval=="0"){
		$("#etype1").removeClass("on");
		$("#etype2").addClass("on");
		$("#etype3").removeClass("on");
		$("#etype").val(objval);
	}else if(objval=="1"){
		$("#etype1").removeClass("on");
		$("#etype2").removeClass("on");
		$("#etype3").addClass("on");
		$("#etype").val(objval);
	}
	//alert("act_culturestation_event_list.asp?etype=" + objval + "&sort=" + $("#sortview").val() + "&viewlist="+$("#viewlist").val());
	
	$.ajax({
		url: "act_culturestation_event_list.asp?etype=" + objval + "&sort=" + $("#sortview").val() + "&viewlist="+$("#viewlist").val(),
		cache: false,
		async: false,
		success: function(message) {
			if(message!="") {
				//추가 내용 Import!
				//$('.cultureList .box').last().after(message);
				$str = $(message)
				// 박스 내용 추가
				$("#listview").empty();
				$('#listview').append($str);
				$("#cnt").html($("#tcount").val());
				//alert(message); 
			} else {
									
			}
		},error: function(err) {
			alert(err.responseText);
		}
	});
}
//-->
</script>
</head>

<body class="default-font body-sub">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<!-- contents -->
	<div id="content" class="content cult-station">
		<div class="cult-main">
			<div class="swiper">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<% if oeventtop.FResultCount>0 Then %>
						<% for i=0 to oeventtop.FResultCount-1 %>
						<div class="swiper-slide" onclick="location.href='culturestation_event.asp?evt_code=<%=oeventtop.FItemList(i).fevt_code%>'">
							<div class="thumbnail"><img src="<%=oeventtop.FItemList(i).fimage_barner2%>" alt="" /><span class="mask"></span></div>
							<div class="des">
								<% If oeventtop.FItemList(i).fevt_kind="3" Then %>
								<span class="label musical">
								<% ElseIf oeventtop.FItemList(i).fevt_kind="4" Then %>
								<span class="label book">
								<% Else %>
								<span class="label">
								<% End If %><%=oeventtop.FItemList(i).GetEvtKindName%></span>
								<span class="tit"><%=oeventtop.FItemList(i).fevt_name%></span>
								<p class="present"><%=oeventtop.FItemList(i).fevt_comment%></p>
								<span class="date"><%="~" & formatDate(oeventtop.FItemList(i).fenddate,"0000.00.00")%></span>
								<% If oeventtop.FItemList(i).fdcount > 0 Then %>
									<span class="numCmt"><span class="icon icon-cmt"><%=oeventtop.FItemList(i).fdcount%></span></span>
								<% End If %>
							</div>
						</div>
						<% Next %>
						<% End If %>
					</div>
				</div>
			</div>
		</div>
		<div class="bnr-wrap">
			<div class="bnr bnr-thank"><a href="/cscenter/thanks10x10.asp">고마워, 텐바이텐!<em>텐바이텐을 칭찬해주세요</em><span class="icon"></span></a></div>
		</div>
		<input type="hidden" id="etype">
		<input type="hidden" id="page" value="1">
		<div class="cult-conts nav-wrap">
			<ul class="nav">
				<li class="<% If etype="" Then Response.write "on" %>" id="etype1"><a href="javascript:TnSortView('')">전체</a></li>
				<li class="<% If etype="0" Then Response.write "on" %>" id="etype2"><a href="javascript:TnSortView('0')"><span class="icon icon-video">느껴봐</span></a></li>
				<li class="<% If etype="1" Then Response.write "on" %>" id="etype3"><a href="javascript:TnSortView('1')"><span class="icon icon-book">읽어봐</span></a></li>
			</ul>
			<div class="sortingbar<% If viewlist<>"G" Then Response.write " grid"%>"> 
				<div class="option-left"> <!-- for dev msg <div class="option-left"> ... </div> -->
					<p class="total">총 <b id="cnt"><%=oevent.FTotalCount%></b>건</p>
				</div>
				<div class="option-right"> <!-- for dev msg option을 option-right로 변경-->
					<div class="styled-selectbox-default styled-selectbox">
						<select class="select" title="검색결과 리스트 정렬 선택옵션" id="sortview" onChange="TnSelectSortView()">
							<option value="new"<% If sortMtd="new" Then Response.write " selected"%>>최신순</option>
							<option value="fav"<% If sortMtd="fav" Then Response.write " selected"%>>인기순</option>
							<option value="dl"<% If sortMtd="dl" Then Response.write " selected"%>>마감임박순</option>
						</select>
					</div>
					<div class="view-option"> 
						<button class="icon icon-list" id="viewlist" name="viewlist" value="<%=viewlist%>" onClick="TnSelectGridView(this.value)"></button>
					</div>
				</div>
			</div>
			<div id="listview">
			<% if oevent.FResultCount>0 Then %>
			<div class="cult-list list">
				<ul>
					<% for i=0 to oevent.FResultCount-1 %>
					<li>
						<a href="culturestation_event.asp?evt_code=<%=oevent.FItemList(i).fevt_code%>">
							<div class="inner">
								<div class="thumbnail">
									<img src="<%=oevent.FItemList(i).fimage_barner2%>" alt="" />
									<div class="bg" style="background-image:url(<%=oevent.FItemList(i).fimage_barner2%>);"></div>
								</div>
								<div class="des">
									<% If oevent.FItemList(i).fevt_kind="3" Then %>
									<span class="label musical">
									<% ElseIf oevent.FItemList(i).fevt_kind="4" Then %>
									<span class="label book">
									<% Else %>
									<span class="label">
									<% End If %><%=oevent.FItemList(i).GetEvtKindName%></span>
									<p class="tit"><%=oevent.FItemList(i).fevt_name%></p>
									<p class="present"><%=oevent.FItemList(i).fevt_comment%></p>
									<p class="date"><%= formatDate(oevent.FItemList(i).fstartdate,"0000.00.00") & "~" & formatDate(oevent.FItemList(i).fenddate,"0000.00.00")%></p>
									<% If oevent.FItemList(i).fdcount > 0 Then %>
										<span class="numCmt"><span class="icon icon-cmt"><%=oevent.FItemList(i).fdcount%></span></span>
									<% End If %>
								</div>
							</div>
						</a>
					</li>
				<% If i=3 And oevent.FResultCount>4 Then %>
				</ul>
				<% If not(IsUserLoginOK()) Then %>
				<div class="bnr-myhistory"><a href="javascript:parent.jsChklogin_mobile('','<%=Server.URLencode("/culturestation/")%>');">내가 응모한 컬쳐스테이션이 궁금하다면? 〉</a></div>
				<% else %>
				<div class="bnr-myhistory"><a href="/my10x10/myeventmaster.asp?pagegubun=j">내가 응모한 컬쳐스테이션이 궁금하다면? 〉</a></div>
				<% End IF %>
				<ul>
				<% End If %>
					<% Next %>
				</ul>
				<% If oevent.FResultCount<=4 Then %>
					<% If not(IsUserLoginOK()) Then %>
				<div class="bnr-myhistory"><a href="javascript:parent.jsChklogin_mobile('','<%=Server.URLencode("/culturestation/")%>');">내가 응모한 컬쳐스테이션이 궁금하다면? 〉</a></div>
					<% else %>
				<div class="bnr-myhistory"><a href="/my10x10/myeventmaster.asp?pagegubun=j">내가 응모한 컬쳐스테이션이 궁금하다면? 〉</a></div>
					<% End IF %>
				<% End If %>
			</div>
			<% End If %>
			</div>
		</div>
	</div>
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
	<script type="text/javascript">
	$(function(){
		mySwiper = new Swiper('.swiper .swiper-container',{
			slidesPerView:"auto",
			centeredSlides:true,
			loop:true,
			speed:1000
		});

		/* fixed nav*/
		var nav = $(".nav").offset().top;
		$(window).scroll(function() {
			var y = $(window).scrollTop();
			if (y > nav) {
				$(".nav-wrap").addClass("sticky");
			} else {
				$(".nav-wrap").removeClass("sticky");
			}
		});
	});
	</script>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->