<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : (M)다이어리스토리2017 검색레이어
' History : 2016-09-20 유태욱 생성
'####################################################
response.end
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/diarystory2017/lib/worker_only_view.asp" -->
<!-- #include virtual="/diarystory2017/lib/classes/diary_class_B.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%

	Dim ArrDesign , tmp , iTmp , ctmp, ktmp, arrcontents ,arrkeyword , userid, limited
	dim cate , PageSize , ttpgsz , CurrPage, vGubun, vMDPick, vParaMeter
	dim SortMet	,page
	Dim ListDiv, arrColorCode, vCurrPage, vSrm

	ArrDesign = request("arrds")
	arrcontents = request("arrcont")
	arrkeyword = request("arrkey")
	arrColorCode = request("iccd")
	vCurrPage = request("cpg")
	vSrm = request("srm")

	limited = request("limited")
	if limited = "" then limited = "x"

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

	vParaMeter = "&arrds="&ArrDesign&"&arrcont="&arrcontents&"&arrkey="&arrkeyword&"&iccd="&arrColorCode&"&ListDiv="&ListDiv&"&limited="&limited&""

%>
<link rel="stylesheet" type="text/css" href="/lib/css/diary2017.css" />
<script type="text/javascript">
//$(function(){
//	// 컬러별 검색
//	$('.schOptColorV15 li').click(function(){
//		$(this).find('em').toggle();
//	});
//});

$( document ).ready( function() {
	$( '#refChkBox' ).click( function() {
	  $( '.check' ).prop( 'checked', false );
		var tmp1;
		for(var i=0;i<document.frm_search1.chkIcd.length;i++) {
			tmp1 = document.frm_search1.chkIcd[i].value;
			$("#barCLChp" + tmp1).attr("style", "");
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
			$("#barCLChp" + tmp).attr("style", "");
			$("#barCLChp" + tmp).attr("summary","N");
		}
		document.frm_search1.iccd.value="0";
		$("#barCLChp0").addClass("selected");
	} else {
		// 지정색 On/Off

		$("#barCLChp0").removeClass("selected");

		if ($("#barCLChp" + iccd).attr("summary") == "Y"){
			$("#barCLChp" + iccd).attr("style", "");
			$("#barCLChp" + iccd).attr("summary","N");
		} else {
			$("#barCLChp" + iccd).attr("style", "display:inline");
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
	
	document.frm_search1.cpg.value = "1";
	document.frm_search1.limited.value = document.frm_search1.limited.value;
	document.frm_search1.action = "/<%=g_HomeFolder%>/list.asp";
	document.frm_search1.submit();
}
</script>
</head>
<body>
<div class="layerPopup">
	<div class="container popWin">
		<div class="header">
			<h1>나만의 다이어리 찾기</h1>
			<p class="btnPopClose"><button class="pButton" onclick="fnCloseModal();">닫기</button></p>
		</div>

		<form name="frm_search1" method="post" style="margin:0px;" action="?">
		<input type="hidden" name="arrds" value="<%=ArrDesign%>">
		<input type="hidden" name="arrcont" value="<%=arrcontents%>">
		<input type="hidden" name="arrkey" value="<%=arrkeyword%>">
		<input type="hidden" name="arrds_temp" value="">
		<input type="hidden" name="arrcont_temp" value="">
		<input type="hidden" name="arrkey_temp" value="">
		<input type="hidden" name="iccd" value="<%=arrColorCode%>">
		<input type="hidden" name="ListDiv" value="item"/>
		<input type="hidden" name="cpg" value="<%=vCurrPage%>"/>
		<input type="hidden" name="page" value=""/>
		<input type="hidden" name="srm" value="<%=vSrm%>"/>
		<input type="hidden" name="rdsearch" value="rdsearch"/>
		<!-- content area -->
		<div class="content diarySearch" id="layerScroll">
			
			<div id="scrollarea">
				<div class="filterListup">
					<p class="txt"><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/txt_check_type.png" alt="원하는 타입에 체크해 주세요 (중복 가능)" /></p>
					<!-- DESIGN -->
					<section>
						<h2>DESIGN</h2>
						<ul>
							<li><input type="checkbox" id="design01" name="design" value="10" <%= getchecked(ArrDesign,10) %> class="check" /> <label for="design01">Simple</label></li>
							<li><input type="checkbox" id="design02" name="design" value="20" <%= getchecked(ArrDesign,20) %> class="check" /> <label for="design02">Illust</label></li>
							<li><input type="checkbox" id="design03" name="design" value="30" <%= getchecked(ArrDesign,30) %> class="check" /> <label for="design03">Pattern</label></li>
							<li><input type="checkbox" id="design04" name="design" value="40" <%= getchecked(ArrDesign,40) %> class="check" /> <label for="design04">Photo</label></li>
						</ul>
					</section>
					<!--// DESIGN -->
	
					<!-- CONTENTS -->
					<section>
						<h2>CONTENTS</h2>
						<h3>+ DATE TYPE</h3>
						<ul>
							<li><input type="checkbox" id="contents01" name="contents" value="'only 2017'" <%= getchecked(arrcontents,"'only 2017'") %> class="check" /> <label for="contents01">Only 2017</label></li>
							<li><input type="checkbox" id="contents02" name="contents" value="'만년'" <%= getchecked(arrcontents,"'만년'") %> class="check" /> <label for="contents02">만년 Diary</label></li>
						</ul>
	
						<h3>+ PAGE LAYOUT</h3>
						<ul>
							<li><input type="checkbox" id="contents03" name="contents" value="'half diary'" <%= getchecked(arrcontents,"'half diary'") %> class="check" /> <label for="contents03">Half diary</label></li>
							<li><input type="checkbox" id="contents04" name="contents" value="'yearly'" <%= getchecked(arrcontents,"'yearly'") %> class="check" /> <label for="contents04">Yearly</label></li>
							<li><input type="checkbox" id="contents05" name="contents" value="'monthly'" <%= getchecked(arrcontents,"'monthly'") %> class="check" /> <label for="contents05">Monthly</label></li>
							<li><input type="checkbox" id="contents06" name="contents" value="'weekly'" <%= getchecked(arrcontents,"'weekly'") %> class="check" /> <label for="contents06">Weekly</label></li>
							<li><input type="checkbox" id="contents07" name="contents" value="'daily'" <%= getchecked(arrcontents,"'daily'") %> class="check" /> <label for="contents07">Daily</label></li>
						</ul>
						<h3>+ OPTION</h3>
						<ul>
							<li><input type="checkbox" id="contents08" name="contents" value="'cash'" <%= getchecked(arrcontents,"'cash'") %> class="check" /> <label for="contents08">Cash</label></li>
							<li><input type="checkbox" id="contents09" name="contents" value="'pocket'" <%= getchecked(arrcontents,"'pocket'") %> class="check" /> <label for="contents09">Pocket</label></li>
							<li><input type="checkbox" id="contents10" name="contents" value="'band'" <%= getchecked(arrcontents,"'band'") %> class="check" /> <label for="contents10">Band</label></li>
							<li><input type="checkbox" id="contents11" name="contents" value="'pen holder'" <%= getchecked(arrcontents,"'pen holder'") %> class="check" /> <label for="contents11">Pen holder</label></li>
						</ul>
					</section>
					<!--// CONTENTS -->
	
					<!-- COVER -->
					<section>
						<h2>COVER</h2>
						<h3>+ MATERIAL</h3>
						<ul>
							<li><input type="checkbox" id="material01" name="keyword" value="37" <%= getchecked(arrkeyword,"37") %> class="check" /> <label for="material01">Paper soft</label></li>
							<li><input type="checkbox" id="material02" name="keyword" value="38" <%= getchecked(arrkeyword,"38") %>  class="check"/> <label for="material02">Paper hard</label></li>
							<li><input type="checkbox" id="material03" name="keyword" value="39" <%= getchecked(arrkeyword,"39") %> class="check" /> <label for="material03">Leather</label></li>
							<li><input type="checkbox" id="material04" name="keyword" value="40" <%= getchecked(arrkeyword,"40") %> class="check" /> <label for="material04">PVC</label></li>
						</ul>
	
						<h3>+ COLOR</h3>
						<div class="schOptColorV15">
							<ul>
								<li>
									<p class="wine" onclick="fnSelColorChip(28)"><em <%= getcheckedcolorclass(arrColorCode,"28") %>  id="barCLChp28" summary="<%=getcheckediccd(arrColorCode,"28")%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="wine" /><input type="hidden" name="chkIcd" id="chkIcd" value="28" class="check"></p>
									<span>wine</span>
								</li>
								<li>
									<p class="red" onclick="fnSelColorChip(2)" ><em <%= getcheckedcolorclass(arrColorCode,"2") %>  id="barCLChp2"  summary="<%=getcheckediccd(arrColorCode,"2")%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="red" /><input type="hidden" name="chkIcd" id="chkIcd" value="2"  class="check"></p>
									<span>red</span>
								</li>
								<li>
									<p class="orange" onclick="fnSelColorChip(16)"><em <%= getcheckedcolorclass(arrColorCode,"16") %>  id="barCLChp16" summary="<%=getcheckediccd(arrColorCode,"16")%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="orange" /><input type="hidden" name="chkIcd" id="chkIcd" value="16" class="check"></p>
									<span>orange</span>
								</li>
								<li>
									<p class="brown" onclick="fnSelColorChip(24)"><em <%= getcheckedcolorclass(arrColorCode,"24") %>  id="barCLChp24" summary="<%=getcheckediccd(arrColorCode,"24")%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="brown" /><input type="hidden" name="chkIcd" id="chkIcd" value="24" class="check"></p>
									<span>brown</span>
								</li>
								<li>
									<p class="camel" onclick="fnSelColorChip(29)"><em <%= getcheckedcolorclass(arrColorCode,"29") %>  id="barCLChp29" summary="<%=getcheckediccd(arrColorCode,"29")%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="camel" /><input type="hidden" name="chkIcd" id="chkIcd" value="29" class="check"></p>
									<span>camel</span>
								</li>
		
								<li>
									<p class="yellow" onclick="fnSelColorChip(17)" ><em <%= getcheckedcolorclass(arrColorCode,"17") %> id="barCLChp17" summary="<%=getcheckediccd(arrColorCode,"17")%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="yellow" /><input type="hidden" name="chkIcd" id="chkIcd" value="17" class="check"></p>
									<span>yellow</span>
								</li>
								<li>
									<p class="beige" onclick="fnSelColorChip(18)"><em <%= getcheckedcolorclass(arrColorCode,"18") %>"	 id="barCLChp18" summary="<%=getcheckediccd(arrColorCode,"18")%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="beige" /><input type="hidden" name="chkIcd" id="chkIcd" value="18" class="check"></p>
									<span>beige</span>
								</li>
								<li>
									<p class="ivory" onclick="fnSelColorChip(30)"><em <%= getcheckedcolorclass(arrColorCode,"30") %>"	 id="barCLChp30" summary="<%=getcheckediccd(arrColorCode,"30")%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="ivory" /><input type="hidden" name="chkIcd" id="chkIcd" value="30" class="check"></p>
									<span>ivory</span>
								</li>
								<li>
									<p class="khaki" onclick="fnSelColorChip(31)"><em <%= getcheckedcolorclass(arrColorCode,"31") %>"	 id="barCLChp31" summary="<%=getcheckediccd(arrColorCode,"31")%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="khaki" /><input type="hidden" name="chkIcd" id="chkIcd" value="31" class="check"></p>
									<span>khaki</span>
								</li>
								<li>
									<p class="green" onclick="fnSelColorChip(19)"><em <%= getcheckedcolorclass(arrColorCode,"19") %>"	 id="barCLChp19" summary="<%=getcheckediccd(arrColorCode,"19")%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="green" /><input type="hidden" name="chkIcd" id="chkIcd" value="19" class="check"></p>
									<span>green</span>
								</li>
								<li>
									<p class="mint" onclick="fnSelColorChip(32)"><em <%= getcheckedcolorclass(arrColorCode,"32") %>" id="barCLChp32" summary="<%=getcheckediccd(arrColorCode,"32")%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="mint" /><input type="hidden" name="chkIcd" id="chkIcd" value="32" class="check"></p>
									<span>mint</span>
								</li>
								<li>
									<p class="skyblue" onclick="fnSelColorChip(20)"><em <%= getcheckedcolorclass(arrColorCode,"20") %>"	 id="barCLChp20" summary="<%=getcheckediccd(arrColorCode,"20")%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="skyblue" /><input type="hidden" name="chkIcd" id="chkIcd" value="20" class="check"></p>
									<span>skyblue</span>
								</li>
								<li>
									<p class="blue" onclick="fnSelColorChip(21)"><em <%= getcheckedcolorclass(arrColorCode,"21") %>" id="barCLChp21" summary="<%=getcheckediccd(arrColorCode,"21")%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="blue" /><input type="hidden" name="chkIcd" id="chkIcd" value="21" class="check"></p>
									<span>blue</span>
								</li>
								<li>
									<p class="navy" onclick="fnSelColorChip(33)"><em <%= getcheckedcolorclass(arrColorCode,"33") %>" id="barCLChp33" summary="<%=getcheckediccd(arrColorCode,"33")%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="navy" /><input type="hidden" name="chkIcd" id="chkIcd" value="33" class="check"></p>
									<span>navy</span>
								</li>
								<li>
									<p class="violet" onclick="fnSelColorChip(22)"><em <%= getcheckedcolorclass(arrColorCode,"22") %>" id="barCLChp22" summary="<%=getcheckediccd(arrColorCode,"22")%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="violet" /><input type="hidden" name="chkIcd" id="chkIcd" value="22" class="check"></p>
									<span>violet</span>
								</li>
		
								<li>
									<p class="lilac" onclick="fnSelColorChip(34)"><em <%= getcheckedcolorclass(arrColorCode,"34") %>"	 id="barCLChp34" summary="<%=getcheckediccd(arrColorCode,"34")%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="lilac" /><input type="hidden" name="chkIcd" id="chkIcd" value="34" class="check"></p>
									<span>lilac</span>
								</li>
								<li>
									<p class="pink" onclick="fnSelColorChip(23)"><em <%= getcheckedcolorclass(arrColorCode,"23") %>" id="barCLChp23" summary="<%=getcheckediccd(arrColorCode,"23")%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="pink" /><input type="hidden" name="chkIcd" id="chkIcd" value="23" class="check"></p>
									<span>pink</span>
								</li>
								<li>
									<p class="babypink" onclick="fnSelColorChip(35)"><em <%= getcheckedcolorclass(arrColorCode,"35") %>"  id="barCLChp35" summary="<%=getcheckediccd(arrColorCode,"35")%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="babypink" /><input type="hidden" name="chkIcd" id="chkIcd" value="35" class="check"></p>
									<span>babypink</span>
								</li>
								<li>
									<p class="white" onclick="fnSelColorChip(7)" ><em <%= getcheckedcolorclass(arrColorCode,"7") %>"		 id="barCLChp7"  summary="<%=getcheckediccd(arrColorCode,"7")%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="white" /><input type="hidden" name="chkIcd" id="chkIcd" value="7"  class="check"></p>
									<span>white</span>
								</li>
								<li>
									<p class="grey" onclick="fnSelColorChip(25)"><em <%= getcheckedcolorclass(arrColorCode,"25") %>" id="barCLChp25" summary="<%=getcheckediccd(arrColorCode,"25")%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="gray" /><input type="hidden" name="chkIcd" id="chkIcd" value="25" class="check"></p>
									<span>grey</span>
								</li>
								<li>
									<p class="charcoal" onclick="fnSelColorChip(36)"><em <%= getcheckedcolorclass(arrColorCode,"36") %>"  id="barCLChp36" summary="<%=getcheckediccd(arrColorCode,"36")%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="charcoal" /><input type="hidden" name="chkIcd" id="chkIcd" value="36" class="check"></p>
									<span>charcoal</span>
								</li>
								<li>
									<p class="black" onclick="fnSelColorChip(8)"><em <%= getcheckedcolorclass(arrColorCode,"8") %>"  id="barCLChp8"  summary="<%=getcheckediccd(arrColorCode,"8")%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="black" /><input type="hidden" name="chkIcd" id="chkIcd" value="8"  class="check"></p>
									<span>black</span>
								</li>
								<li>
									<p class="silver" onclick="fnSelColorChip(26)"><em <%= getcheckedcolorclass(arrColorCode,"26") %>"	 id="barCLChp26" summary="<%=getcheckediccd(arrColorCode,"26")%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="silver" /><input type="hidden" name="chkIcd" id="chkIcd" value="26" class="check"></p>
									<span>silver</span>
								</li>
								<li>
									<p class="gold" onclick="fnSelColorChip(27)"><em <%= getcheckedcolorclass(arrColorCode,"27") %>" id="barCLChp27" summary="<%=getcheckediccd(arrColorCode,"27")%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="gold" /><input type="hidden" name="chkIcd" id="chkIcd" value="27" class="check"></p>
									<span>gold</span>
								</li>
								<li>
									<p class="check" onclick="fnSelColorChip(43)"><em <%= getcheckedcolorclass(arrColorCode,"43") %>"	 id="barCLChp43" summary="<%=getcheckediccd(arrColorCode,"43")%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="check" /><input type="hidden" name="chkIcd" id="chkIcd" value="43" class="check"></p>
									<span>check</span>
								</li>
								<li>
									<p class="stripe" onclick="fnSelColorChip(44)"><em <%= getcheckedcolorclass(arrColorCode,"44") %>"	 id="barCLChp44" summary="<%=getcheckediccd(arrColorCode,"44")%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="stripe" /><input type="hidden" name="chkIcd" id="chkIcd" value="44" class="check"></p>
									<span>stripe</span>
								</li>
								<li>
									<p class="dot" onclick="fnSelColorChip(45)"><em <%= getcheckedcolorclass(arrColorCode,"45") %>" id="barCLChp45" summary="<%=getcheckediccd(arrColorCode,"45")%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="dot" /><input type="hidden" name="chkIcd" id="chkIcd" value="45" class="check"></p>
									<span>dot</span>
								</li>
								<li>
									<p class="flower" onclick="fnSelColorChip(48)"><em <%= getcheckedcolorclass(arrColorCode,"48") %>"	 id="barCLChp48" summary="<%=getcheckediccd(arrColorCode,"48")%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="flower" /><input type="hidden" name="chkIcd" id="chkIcd" value="48" class="check"></p>
									<span>flower</span>
								</li>
								<li>
									<p class="drawing" onclick="fnSelColorChip(46)"><em <%= getcheckedcolorclass(arrColorCode,"46") %>"	 id="barCLChp46" summary="<%=getcheckediccd(arrColorCode,"46")%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="drawing" /><input type="hidden" name="chkIcd" id="chkIcd" value="46" class="check"></p>
									<span>drawing</span>
								</li>
								<li>
									<p class="animal" onclick="fnSelColorChip(47)"><em <%= getcheckedcolorclass(arrColorCode,"47") %>" id="barCLChp47" summary="<%=getcheckediccd(arrColorCode,"47")%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="animal" /><input type="hidden" name="chkIcd" id="chkIcd" value="47" class="check"></p>
									<span>animal</span>
								</li>
								<li>
									<p class="geometric" onclick="fnSelColorChip(49)"><em <%= getcheckedcolorclass(arrColorCode,"49")%>" id="barCLChp49" summary="<%=getcheckediccd(arrColorCode,"49")%>"></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="geometric" /><input type="hidden" name="chkIcd" id="chkIcd" value="49" class="check"></p>
									<span>geometric</span>
								</li>
							</ul>
						</div>
					</section>
					<!--// COVER -->
				</div>
				<div class="floatingBar">
					<div class="btnWrap">
						<div class="ftBtn"><span class="button btRed cWh1 w100p btnFind"><input type="submit" onclick="goSearchDiary();" value="찾기" /></span></div>
						<div class="ftBtn rt"><button type="button"  id="refChkBox" class="btnRefresh"><span>전체 선택 해제</span></button></div>
					</div>
				</div>
			</div>
		</div>
		<!-- //content area -->
		</form>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
