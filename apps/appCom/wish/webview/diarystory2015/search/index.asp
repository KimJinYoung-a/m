<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
'####################################################
' Description : (M)다이어리스토리2015 검색페이지
' History : 2014-10-13 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/diarystory2015/lib/worker_only_view.asp" -->
<!-- #include virtual="/diarystory2015/lib/classes/diary_class.asp" -->


<%
	Dim ArrDesign , tmp , iTmp , ctmp, ktmp, arrcontents ,arrkeyword , userid, arrColorCode
	dim cate , PageSize , ttpgsz , CurrPage, vGubun, vMDPick, vParaMeter
	dim SortMet	,page
	
	Dim ListDiv

	ListDiv	= requestcheckvar(request("ListDiv"),4)
	If ListDiv = "" Then ListDiv = "item"

	If ListDiv = "list" Then
		PageSize = 15
	Else
		PageSize = 16
	End If

	IF SortMet = "" Then SortMet = "newitem"

	ArrDesign = request("arrds")
	arrcontents = request("arrcont")
	arrkeyword = request("arrkey")
	arrColorCode = request("iccd")


	page 		= requestcheckvar(request("page"),2)
	SortMet 	= requestCheckVar(request("srm"),9)
	CurrPage 	= requestCheckVar(request("cpg"),9)
	userid		= getEncLoginUserID

	IF CurrPage = "" then CurrPage = 1
	IF SortMet = "" Then SortMet = "newitem"
	if page = "" then page = 1

	ArrDesign = request("arrds")
	arrcontents = request("arrcont")
	arrkeyword = request("arrkey")

	ArrDesign = split(ArrDesign,",")
	arrcontents = split(arrcontents,",")
	arrkeyword = split(arrkeyword,",")
	arrColorCode = Split(arrColorCode,",")

	For iTmp =0 to Ubound(ArrDesign)-1
		IF ArrDesign(iTmp)<>"" Then
			tmp  = tmp & requestcheckvar(ArrDesign(iTmp),2) &","
		End IF
	Next
	ArrDesign = tmp

	tmp = ""
	For cTmp =0 to Ubound(arrcontents)-1
		IF arrcontents(cTmp)<>"" Then
			tmp  = tmp & "'" & requestcheckvar(arrcontents(cTmp),10) & "'" &","
		End IF
	Next
	arrcontents = tmp

	tmp = ""
	For ktmp =0 to Ubound(arrkeyword)-1
		IF arrkeyword(ktmp)<>"" Then
			tmp  = tmp & requestcheckvar(arrkeyword(ktmp),2) &","
		End IF
	Next
	arrkeyword = tmp

	tmp = ""
	For ktmp =0 to Ubound(arrColorCode)-1
		IF arrColorCode(ktmp)<>"" Then
			tmp  = tmp & requestcheckvar(arrColorCode(ktmp),2) &","
		End IF
	Next
	arrColorCode = tmp

	Dim sArrDesign,sarrcontents,sarrkeyword,sarrColorCode
	sArrDesign =""
	sarrcontents =""
	sarrkeyword =""
	sarrColorCode =""
	IF ArrDesign <> "" THEN sArrDesign =  left(ArrDesign,(len(ArrDesign)-1))
	IF arrcontents <> "" THEN sarrcontents =  left(arrcontents,(len(arrcontents)-1))
	IF arrkeyword <> "" THEN
		If arrColorCode = "" then
		sarrkeyword =  left(arrkeyword,(len(arrkeyword)-1))
		else
		sarrkeyword =  arrkeyword & left(arrColorCode,(len(arrColorCode)-1))
		End If
	else
		If arrColorCode <> "" then
		sarrkeyword =  left(arrColorCode,(len(arrColorCode)-1))
		End If
	End If

	vParaMeter = "&arrds="&ArrDesign&"&arrcont="&arrcontents&"&arrkey="&arrkeyword&"&iccd="&arrColorCode&"&ListDiv="&ListDiv&""


	Dim PrdBrandList, i

	set PrdBrandList = new cdiary_list
		PrdBrandList.FPageSize = PageSize
		PrdBrandList.FCurrPage = CurrPage
		PrdBrandList.frectdesign = sArrDesign
		PrdBrandList.frectcontents = arrcontents
		PrdBrandList.frectkeyword = sarrkeyword
		PrdBrandList.fmdpick = vMDPick
		PrdBrandList.ftectSortMet = SortMet
		PrdBrandList.fuserid = userid
		PrdBrandList.getDiaryItemLIst

	'// 검색결과 내위시 표시정보 접수
	if IsUserLoginOK then
		'// 검색결과 상품목록 작성
		dim rstArrItemid: rstArrItemid=""
		IF PrdBrandList.FResultCount >0 then
			For i=0 To PrdBrandList.FResultCount -1
				rstArrItemid = rstArrItemid & chkIIF(rstArrItemid="","",",") & PrdBrandList.FItemList(i).FItemid
			Next
		End if
		'// 위시결과 상품목록 작성
		dim rstWishItem: rstWishItem=""
		dim rstWishCnt: rstWishCnt=""
		if rstArrItemid<>"" then
			Call getMyFavItemList(getLoginUserid(),rstArrItemid,rstWishItem, rstWishCnt)
		end if
	end if

	'dim oMainContents
	'set oMainContents = new cdiary_list
	'oMainContents.FRectIdx = idx
	'oMainContents.fcontents_oneitem
%>

<!-- #include virtual="/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/diary2015.css">
<script type="text/javascript">
$(function(){
	// 컬러별 검색
	$('.colorType li').click(function(){
		$(this).find('em').toggle();
	});
});

function goSearchDiary()
{
	var nm  = document.getElementsByName('design');
	var cm  = document.getElementsByName('contents');
	var km  = document.getElementsByName('keyword');

	document.frm_search1.arrds.value = "";
	document.frm_search1.arrcont.value = "";
	document.frm_search1.arrkey.value = "";

	for (var i=0;i<nm.length;i++){

		if (nm[i].checked){
			document.frm_search1.arrds.value = document.frm_search1.arrds.value  + nm[i].value + ",";
		}
	}

	for (var i=0;i<cm.length;i++){

		if (cm[i].checked){
			document.frm_search1.arrcont.value = document.frm_search1.arrcont.value  + cm[i].value + ",";
		}
	}

	for (var i=0;i<km.length;i++){

		if (km[i].checked){
			document.frm_search1.arrkey.value = document.frm_search1.arrkey.value  + km[i].value + ",";
		}
	}

	document.frm_search1.action = "/<%=g_HomeFolder%>/list.asp";
	document.frm_search1.submit();
}

//체크박스 전체선택 해제
$( document ).ready( function() {
	$( '.check-all' ).click( function() {
	  $( '.check' ).prop( 'checked', false );
		var tmp1;
		for(var i=0;i<document.frm_search1.chkIcd.length;i++) {
			tmp1 = document.frm_search1.chkIcd[i].value;
			$("#barCLChp" + tmp1).removeClass("selected");
			$("#barCLChp" + tmp1).attr("summary","N");
		}
		document.frm_search1.iccd.value="0";
		$("#barCLChp0").addClass("selected");
	} );
} );

function fnSelColorChip(iccd) {
	var tmp;
	var chkCnt = 0;
		if(iccd==0) {
		//전체 선택-리셋
		for(var i=0;i<document.frm_search1.chkIcd.length;i++) {
			tmp = document.frm_search1.chkIcd[i].value;
			$("#barCLChp" + tmp).removeClass("selected");
			$("#barCLChp" + tmp).attr("summary","N");
		}
		document.frm_search1.iccd.value="0";
		$("#barCLChp0").addClass("selected");
	} else {
		// 지정색 On/Off
		$("#barCLChp0").removeClass("selected");
		if ($("#barCLChp" + iccd).attr("summary") == "Y"){
			$("#barCLChp" + iccd).removeClass("selected");
			$("#barCLChp" + iccd).attr("summary","N");
		} else {
			$("#barCLChp" + iccd).addClass("selected");
			$("#barCLChp" + iccd).attr("summary","Y");
		}

		//컬러 마지막 선택 빠질경우 없음으로 되돌아가기
		$(".colorChip li:not('#barCLChp0')").each(function(){
			if($(this).hasClass("selected")) {
				chkCnt++;
			}
		});
		if(chkCnt<=0) {
			document.frm_search1.iccd.value="0";
			$("#barCLChp0").attr("class","selected");
		} else {
			$("#barCLChp0").removeClass("selected");
		}

		document.frm_search1.iccd.value="";
		for(var i=0;i<document.frm_search1.chkIcd.length;i++) {
			tmp = document.frm_search1.chkIcd[i].value;
			if($("#barCLChp" + tmp).attr("summary") =="Y") {
				if(document.frm_search1.iccd.value!="") {
					document.frm_search1.iccd.value = document.frm_search1.iccd.value + tmp + ",";
				} else {
					document.frm_search1.iccd.value = tmp+ ",";
				}
			}
		}
	}
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<form name="frm_search1" method="post" style="margin:0px;" action="?">
		<input type="hidden" name="arrds" value="">
		<input type="hidden" name="arrcont" value="">
		<input type="hidden" name="arrkey" value="">
		<input type="hidden" name="arrds_temp" value="<%= request("arrds") %>">
		<input type="hidden" name="arrcont_temp" value="<%= request("arrcont") %>">
		<input type="hidden" name="arrkey_temp" value="<%= request("arrkey") %>">
		<input type="hidden" name="iccd" value="<%= request("iccd") %>">
		<input type="hidden" name="ListDiv" value="<%=ListDiv%>"/>
		<input type="hidden" name="cpg" value="<%=PrdBrandList.FCurrPage %>"/>
		<input type="hidden" name="page" value="<%= PrdBrandList.FPageSize %>"/>
		<input type="hidden" name="srm" value="<%= PrdBrandList.ftectSortMet %>"/>
		<div class="header">
			<h1>다이어리 검색</h1>
			<p class="btnPopClose"><button class="pButton" onclick="#">닫기</button></p>
			<p class="btnPopRefresh"><button  class="pButton" onclick="#">새로고침</button></p>
		</div>
		<!-- content area -->
		<div class="content" id="contentArea">
			<!-- 다이어리 검색 -->
			<div class="filterListup">
				<!-- DESIGN -->
				<h2>DESIGN</h2>
				<section class="checkType">
					<ul>
						<li><input type="checkbox" class="check" id="optD01" name="design" value="10" <%= getchecked(ArrDesign,10) %> /> <label for="optD01">Simple</label></li>
						<li><input type="checkbox" class="check" id="optD02" name="design" value="20" <%= getchecked(ArrDesign,20) %> /> <label for="optD02">Illust</label></li>
						<li><input type="checkbox" class="check" id="optD03" name="design" value="30" <%= getchecked(ArrDesign,30) %> /> <label for="optD03">Pattern</label></li>
						<li><input type="checkbox" class="check" id="optD04" name="design" value="40" <%= getchecked(ArrDesign,40) %> /> <label for="optD04">Photo</label></li>
					</ul>
				</section>
				<!--// DESIGN -->

				<!-- CONTENTS -->
				<h2>CONTENTS</h2>
				<section class="checkType col-three">
					<ul>
						<li><input type="checkbox" class="check" id="optCt01" name="contents" value="'only 2015'" <%= getchecked(arrcontents,"'only 2015'") %> /> <label for="optCt01">Only 2015</label></li>
						<li><input type="checkbox" class="check" id="optCt02" name="contents" value="'만년'" <%= getchecked(arrcontents,"'만년'") %> /> <label for="optCt02">만년 diary</label></li>
						<li><input type="checkbox" class="check" id="optCt03" name="contents" value="'half diary'" <%= getchecked(arrcontents,"'half diary'") %> /> <label for="optCt03">Half diary</label></li>
						<li><input type="checkbox" class="check" id="optCt04" name="contents" value="'yearly'" <%= getchecked(arrcontents,"'yearly'") %> /> <label for="optCt04">Yearly</label></li>
						<li><input type="checkbox" class="check" id="optCt05" name="contents" value="'monthly'" <%= getchecked(arrcontents,"'monthly'") %> /> <label for="optCt05">Monthly</label></li>
						<li><input type="checkbox" class="check" id="optCt06" name="contents" value="'weekly'" <%= getchecked(arrcontents,"'weekly'") %> /> <label for="optCt06">Weekly</label></li>
						<li><input type="checkbox" class="check" id="optCt07" name="contents" value="'daily'" <%= getchecked(arrcontents,"'daily'") %> /> <label for="optCt07">Daily</label></li>
						<li><input type="checkbox" class="check" id="optCt08" name="contents" value="'cash'" <%= getchecked(arrcontents,"'cash'") %> /> <label for="optCt08">Cash</label></li>
						<li><input type="checkbox" class="check" id="optCt09" name="contents" value="'pocket'" <%= getchecked(arrcontents,"'pocket'") %> /> <label for="optCt09">Pocket</label></li>
						<li><input type="checkbox" class="check" id="optCt10" name="contents" value="'band'" <%= getchecked(arrcontents,"'band'") %> /> <label for="optCt10">Band</label></li>
						<li><input type="checkbox" class="check" id="optCt11" name="contents" value="'pen holder'" <%= getchecked(arrcontents,"'pen holder'") %> /> <label for="optCt11">Pen holder</label></li>
					</ul>
				</section>
				<!--// CONTENTS -->

				<!-- COVER -->
				<h2>COVER</h2>
				<h3><span>MATERIAL</span></h3>
				<section class="checkType">
					<ul>
						<li><input type="checkbox" class="check" id="optCv01" name="keyword" value="37" <%= getchecked(arrkeyword,"37") %> /> <label for="optCv01">Paper soft</label></li>
						<li><input type="checkbox" class="check" id="optCv02" name="keyword" value="38" <%= getchecked(arrkeyword,"38") %> /> <label for="optCv02">Paper hard</label></li>
						<li><input type="checkbox" class="check" id="optCv03" name="keyword" value="39" <%= getchecked(arrkeyword,"39") %> /> <label for="optCv03">Leather style</label></li>
						<li><input type="checkbox" class="check" id="optCv04" name="keyword" value="40" <%= getchecked(arrkeyword,"40") %> /> <label for="optCv04">PVC</label></li>
						<li><input type="checkbox" class="check" id="optCv05" name="keyword" value="42" <%= getchecked(arrkeyword,"42") %> /> <label for="optCv05">Fabric</label></li>
					</ul>
				</section>

				<h3><span>COLOR</span></h3>
				<section class="colorType">
					<ul>
						<li onclick="fnSelColorChip(28)" id="barCLChp28" summary="<%=getcheckediccd(arrColorCode,"28")%>"><input type="hidden" name="chkIcd" id="chkIcd" value="28" class="check">
							<p class="wine <%= getcheckedcolorclass(arrColorCode,"28") %>"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="wine" /></p>
							<span>wine</span>
						</li>
						<li onclick="fnSelColorChip(2)"  id="barCLChp2"  summary="<%=getcheckediccd(arrColorCode,"2")%>"><input type="hidden" name="chkIcd" id="chkIcd" value="2"  class="check">
							<p class="red <%= getcheckedcolorclass(arrColorCode,"2") %>"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="red" /></p>
							<span>red</span>
						</li>
						<li onclick="fnSelColorChip(16)" id="barCLChp16" summary="<%=getcheckediccd(arrColorCode,"16")%>"><input type="hidden" name="chkIcd" id="chkIcd" value="16" class="check">
							<p class="orange <%= getcheckedcolorclass(arrColorCode,"16") %>"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="orange" /></p>
							<span>orange</span>
						</li>
						<li onclick="fnSelColorChip(24)" id="barCLChp24" summary="<%=getcheckediccd(arrColorCode,"24")%>"><input type="hidden" name="chkIcd" id="chkIcd" value="24" class="check">
							<p class="brown <%= getcheckedcolorclass(arrColorCode,"24") %>"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="brown" /></p>
							<span>brown</span>
						</li>
						<li onclick="fnSelColorChip(29)" id="barCLChp29" summary="<%=getcheckediccd(arrColorCode,"29")%>"><input type="hidden" name="chkIcd" id="chkIcd" value="29" class="check">
							<p class="camel <%= getcheckedcolorclass(arrColorCode,"29") %>"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="camel" /></p>
							<span>camel</span>
						</li>
						<li onclick="fnSelColorChip(17)" id="barCLChp17" summary="<%=getcheckediccd(arrColorCode,"17")%>"><input type="hidden" name="chkIcd" id="chkIcd" value="17" class="check">
							<p class="yellow <%= getcheckedcolorclass(arrColorCode,"17") %>"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="yellow" /></p>
							<span>yellow</span>
						</li>
						<li onclick="fnSelColorChip(18)" id="barCLChp18" summary="<%=getcheckediccd(arrColorCode,"18")%>"><input type="hidden" name="chkIcd" id="chkIcd" value="18" class="check">
							<p class="beige <%= getcheckedcolorclass(arrColorCode,"18") %>"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="beige" /></p>
							<span>beige</span>
						</li>
						<li onclick="fnSelColorChip(30)" id="barCLChp30" summary="<%=getcheckediccd(arrColorCode,"30")%>"><input type="hidden" name="chkIcd" id="chkIcd" value="30" class="check">
							<p class="ivory <%= getcheckedcolorclass(arrColorCode,"30") %>"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="ivory" /></p>
							<span>ivory</span>
						</li>
						<li onclick="fnSelColorChip(31)" id="barCLChp31" summary="<%=getcheckediccd(arrColorCode,"31")%>"><input type="hidden" name="chkIcd" id="chkIcd" value="31" class="check">
							<p class="khaki <%= getcheckedcolorclass(arrColorCode,"31") %>"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="khaki" /></p>
							<span>khaki</span>
						</li>
						<li onclick="fnSelColorChip(19)" id="barCLChp19" summary="<%=getcheckediccd(arrColorCode,"19")%>"><input type="hidden" name="chkIcd" id="chkIcd" value="19" class="check">
							<p class="green <%= getcheckedcolorclass(arrColorCode,"19") %>"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="green" /></p>
							<span>green</span>
						</li>
						<li onclick="fnSelColorChip(32)" id="barCLChp32" summary="<%=getcheckediccd(arrColorCode,"32")%>"><input type="hidden" name="chkIcd" id="chkIcd" value="32" class="check">
							<p class="mint <%= getcheckedcolorclass(arrColorCode,"32") %>"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="mint" /></p>
							<span>mint</span>
						</li>
						<li onclick="fnSelColorChip(20)" id="barCLChp20" summary="<%=getcheckediccd(arrColorCode,"20")%>"><input type="hidden" name="chkIcd" id="chkIcd" value="20" class="check">
							<p class="skyblue <%= getcheckedcolorclass(arrColorCode,"20") %>"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="skyblue" /></p>
							<span>skyblue</span>
						</li>
						<li onclick="fnSelColorChip(21)" id="barCLChp21" summary="<%=getcheckediccd(arrColorCode,"21")%>"><input type="hidden" name="chkIcd" id="chkIcd" value="21" class="check">
							<p class="blue <%= getcheckedcolorclass(arrColorCode,"21") %>"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="blue" /></p>
							<span>blue</span>
						</li>
						<li onclick="fnSelColorChip(33)" id="barCLChp33" summary="<%=getcheckediccd(arrColorCode,"33")%>"><input type="hidden" name="chkIcd" id="chkIcd" value="33" class="check">
							<p class="navy <%= getcheckedcolorclass(arrColorCode,"33") %>"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="navy" /></p>
							<span>navy</span>
						</li>
						<li onclick="fnSelColorChip(22)" id="barCLChp22" summary="<%=getcheckediccd(arrColorCode,"22")%>"><input type="hidden" name="chkIcd" id="chkIcd" value="22" class="check">
							<p class="violet <%= getcheckedcolorclass(arrColorCode,"22") %>"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="violet" /></p>
							<span>violet</span>
						</li>
						<li onclick="fnSelColorChip(34)" id="barCLChp34" summary="<%=getcheckediccd(arrColorCode,"34")%>"><input type="hidden" name="chkIcd" id="chkIcd" value="34" class="check">
							<p class="lilac <%= getcheckedcolorclass(arrColorCode,"34") %>"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="lilac" /></p>
							<span>lilac</span>
						</li>
						<li onclick="fnSelColorChip(35)" id="barCLChp35" summary="<%=getcheckediccd(arrColorCode,"35")%>"><input type="hidden" name="chkIcd" id="chkIcd" value="35" class="check">
							<p class="babypink <%= getcheckedcolorclass(arrColorCode,"35") %>"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="babypink" /></p>
							<span>babypink</span>
						</li>
						<li onclick="fnSelColorChip(23)" id="barCLChp23" summary="<%=getcheckediccd(arrColorCode,"23")%>"><input type="hidden" name="chkIcd" id="chkIcd" value="23" class="check">
							<p class="pink <%= getcheckedcolorclass(arrColorCode,"23") %>"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="pink" /></p>
							<span>pink</span>
						</li>
						<li onclick="fnSelColorChip(7)"  id="barCLChp7"  summary="<%=getcheckediccd(arrColorCode,"7")%>"><input type="hidden" name="chkIcd" id="chkIcd" value="7"  class="check">
							<p class="white <%= getcheckedcolorclass(arrColorCode,"7") %>"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="white" /></p>
							<span>white</span>
						</li>
						<li onclick="fnSelColorChip(25)" id="barCLChp25" summary="<%=getcheckediccd(arrColorCode,"25")%>"><input type="hidden" name="chkIcd" id="chkIcd" value="25" class="check">
							<p class="grey <%= getcheckedcolorclass(arrColorCode,"25") %>"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="gray" /></p>
							<span>grey</span>
						</li>
						<li onclick="fnSelColorChip(36)" id="barCLChp36" summary="<%=getcheckediccd(arrColorCode,"36")%>"><input type="hidden" name="chkIcd" id="chkIcd" value="36" class="check">
							<p class="charcoal <%= getcheckedcolorclass(arrColorCode,"36") %>"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="charcoal" /></p>
							<span>charcoal</span>
						</li>
						<li onclick="fnSelColorChip(8)"  id="barCLChp8"  summary="<%=getcheckediccd(arrColorCode,"8")%>"><input type="hidden" name="chkIcd" id="chkIcd" value="8"  class="check">
							<p class="black <%= getcheckedcolorclass(arrColorCode,"8") %>"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="black" /></p>
							<span>black</span>
						</li>
						<li onclick="fnSelColorChip(26)" id="barCLChp26" summary="<%=getcheckediccd(arrColorCode,"26")%>"><input type="hidden" name="chkIcd" id="chkIcd" value="26" class="check">
							<p class="silver <%= getcheckedcolorclass(arrColorCode,"26") %>"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="silver" /></p>
							<span>silver</span>
						</li>
						<li onclick="fnSelColorChip(27)" id="barCLChp27" summary="<%=getcheckediccd(arrColorCode,"27")%>"><input type="hidden" name="chkIcd" id="chkIcd" value="27" class="check">
							<p class="gold <%= getcheckedcolorclass(arrColorCode,"27") %>"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="gold" /></p>
							<span>gold</span>
						</li>
						<li onclick="fnSelColorChip(43)" id="barCLChp43" summary="<%=getcheckediccd(arrColorCode,"43")%>"><input type="hidden" name="chkIcd" id="chkIcd" value="43" class="check">
							<p class="check <%= getcheckedcolorclass(arrColorCode,"43") %>"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="check" /></p>
							<span>check</span>
						</li>
						<li onclick="fnSelColorChip(44)" id="barCLChp44" summary="<%=getcheckediccd(arrColorCode,"44")%>"><input type="hidden" name="chkIcd" id="chkIcd" value="44" class="check">
							<p class="stripe <%= getcheckedcolorclass(arrColorCode,"44") %>"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="stripe" /></p>
							<span>stripe</span>
						</li>
						<li onclick="fnSelColorChip(45)" id="barCLChp45" summary="<%=getcheckediccd(arrColorCode,"45")%>"><input type="hidden" name="chkIcd" id="chkIcd" value="45" class="check">
							<p class="dot <%= getcheckedcolorclass(arrColorCode,"45") %>"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="dot" /></p>
							<span>dot</span>
						</li>
						<li onclick="fnSelColorChip(48)" id="barCLChp48" summary="<%=getcheckediccd(arrColorCode,"48")%>"><input type="hidden" name="chkIcd" id="chkIcd" value="48" class="check">
							<p class="flower <%= getcheckedcolorclass(arrColorCode,"48") %>"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="flower" /></p>
							<span>flower</span>
						</li>
						<li onclick="fnSelColorChip(46)" id="barCLChp46" summary="<%=getcheckediccd(arrColorCode,"46")%>"><input type="hidden" name="chkIcd" id="chkIcd" value="46" class="check">
							<p class="drawing <%= getcheckedcolorclass(arrColorCode,"46") %>"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="drawing" /></p>
							<span>drawing</span>
						</li>
						<li onclick="fnSelColorChip(47)" id="barCLChp47" summary="<%=getcheckediccd(arrColorCode,"47")%>"><input type="hidden" name="chkIcd" id="chkIcd" value="47" class="check">
							<p class="animal <%= getcheckedcolorclass(arrColorCode,"47") %>"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="animal" /></p>
							<span>animal</span>
						</li>
						<li onclick="fnSelColorChip(49)" id="barCLChp49" summary="<%=getcheckediccd(arrColorCode,"49")%>"><input type="hidden" name="chkIcd" id="chkIcd" value="49" class="check">
							<p class="geometric <%= getcheckedcolorclass(arrColorCode,"49")%>"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="geometric" /></p>
							<span>geometric</span>
						</li>
					</ul>
				</section>
				<!--// COVER -->
				

			</div>
			<!--// 다이어리 검색 -->
		</div>
		</form>
		<div class="floatingBar">
			<div class="btnWrap">
				<div class="ftBtn"><span class="button btB1 btRed cWh1 w100p"><input type="submit" onclick="goSearchDiary();" value="검색필터 적용하기" /></span></div>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
<%
	Set PrdBrandList = Nothing
	'Set oMainContents = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->