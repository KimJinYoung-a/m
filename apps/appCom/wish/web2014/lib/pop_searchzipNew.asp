<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.charset = "utf-8"
%>
<%
'###########################################################
' Description :  app 우편번호 찾기
' History : 2016.06.16 원승현 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbEVTopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
	Dim strTarget
	Dim strMode, protocolAddr
	Dim gubun

	strTarget	= requestCheckVar(Request("target"),32)
	strMode     = requestCheckVar(Request("strMode"),32)
	gubun		= requestCheckVar(Request("gb"),10)

	dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),5))
	dim CurrPage : CurrPage = getNumeric(requestCheckVar(request("cpg"),8))
	if CurrPage="" then CurrPage=1
	if PageSize="" then PageSize=8

%>
<script>
	$(function(){
		/* tab onoff */
		$(".tabonoff .tabcontainer .tabcont").css("display", "none");
		$(".tabonoff .tabcontainer .tabcont:first-child").css("display", "block");
		$(".tabonoff .tabs li:first-child a").addClass("on");
		$(".tabonoff").delegate(".tabs li", "click", function() {
			var index = $(this).parent().children().index(this);
			$(this).siblings().children().removeClass();
			$(this).children().addClass("on");
			$(this).parent().next(".tabcontainer").children().hide().eq(index).show();
			return false;
		});

		$(".finder .btnReset").hide();
		$(".finder input[type=search]" ).focus(function() {
			$(".finder .btnReset").show();
		});
	});

	<%'// 검색 %>
	function SubmitForm(stype) {

		<%'// 통합검색일 경우 %>
		if (stype=="jibun")
		{
			if ($("#tJibundong").val().length < 2) { alert("검색어를 두 글자 이상 입력하세요."); return; }
			$("#sGubun").val(stype);
			$("#sJibundong").val($("#tJibundong").val());
			$("#cpg").val(1);
			$("#keyword").val("");
		}

		$.ajax({
			type:"get",
			url:"/lib/pop_searchzipNewProc.asp",
		   data: $("#searchProcFrm").serialize(),
		   dataType: "text",
			async:false,
			cache:true,
			success : function(Data, textStatus, jqXHR){
				if (jqXHR.readyState == 4) {
					if (jqXHR.status == 200) {
						if(Data!="") {
							var str;
							for(var i in Data)
							{
								 if(Data.hasOwnProperty(i))
								{
									str += Data[i];
								}
							}
							str = str.replace("undefined","");
							res = str.split("|");
							if (res[0]=="OK")
							{
								if (stype=="jibun")
								{
									if (res[1]=="<p>검색된 주소가 없습니다</p>")
									{
										SubmitFormAPI();
									}
									else
									{
										document.activeElement.blur();
										$("#resultJibun").show();
										$("#guideTxtVal").hide();
										$("#noResultData").hide();
										$("#tipTxtVal").hide();
										setTimeout(function () {
											window.$('html,body').animate({scrollTop:$("#resultJibun").offset().top}, 0);
										}, 10);
										$("#jibunaddrList").empty().html(res[1]);
										if (res[3]!="")
										{
											$("#addrpaging").empty().html(res[3]);
										}
										$("#jibuntotalcntView").empty().html("총 <em>"+numberWithCommas(res[2])+"</em> 건");
									}
								}
							}
							else
							{
								errorMsg = res[1].replace(">?n", "\n");
								alert(errorMsg );
								return false;
							}
						} else {
							alert("잘못된 접근 입니다.");
							return false;
						}
					}
				}
			},
			error:function(jqXHR, textStatus, errorThrown){
				alert("잘못된 접근 입니다!");
				return false;
			}
		});
	}


	<%'// 시군구 리스트 가져옴 %>
	function getgunguList(v, stype) {

		$("#sGubun").val("gungureturn");
		$("#sSidoGubun").val(v);

		if (v=="")
		{
			alert("시/도를 선택해 주세요.");
			return false;
		}

		<%'// 세종특별자치시는 시군구가 없으므로 안타도됨 %>
		if (v=="세종특별자치시")
		{
			$("#"+stype).empty().html("<option value=''>시/군/구 없음</option>");
		}
		else
		{
			$.ajax({
				type:"POST",
				url:"/lib/pop_searchzipNewProc.asp",
			   data: $("#searchProcFrm").serialize(),
			   dataType: "text",
				async:false,
				cache:true,
				success : function(Data, textStatus, jqXHR){
					if (jqXHR.readyState == 4) {
						if (jqXHR.status == 200) {
							if(Data!="") {
								var str;
								for(var i in Data)
								{
									 if(Data.hasOwnProperty(i))
									{
										str += Data[i];
									}
								}
								str = str.replace("undefined","");
								res = str.split("|");
								if (res[0]=="OK")
								{
									$("#"+stype).empty().html(res[1]);
								}
								else
								{
									errorMsg = res[1].replace(">?n", "\n");
									alert(errorMsg );
									return false;
								}
							} else {
								alert("잘못된 접근 입니다.");
								return false;
							}
						}
					}
				},
				error:function(jqXHR, textStatus, errorThrown){
					alert("잘못된 접근 입니다!");
					return false;
				}
			});
		}
	}

	function numberWithCommas(x) {
		return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}

	function setBackAction(x, y, z) {
		$("#"+x).hide();
		$("#"+y).show();
		$("#"+z).show();
	}

	<%'// form에 각 값들 넣고 기본, 상세 주소 입력값 만듦 %>
	function setAddr(zip, sido, gungu, dong, eupmyun, ri, official_bld, jibun, road, building_no, type, wp, uwp) {

		var basicAddr; // 기본주소
		var basicAddr2; // 상세주소
		var roadbasicAddr; // 도로명으로 검색할시 표시할 지번주소

		$("#zip").val(zip);
		$("#sido").val(sido);
		$("#gungu").val(gungu);
		$("#dong").val(dong);
		$("#eupmyun").val(eupmyun);
		$("#ri").val(ri);
		$("#official_bld").val(official_bld);
		$("#jibun").val(jibun);
		$("#road").val(road);
		$("#building_no").val(building_no);
		$("#gubun").val(type);

		if (type=="jibun")
		{
			<%'// 기본주소 입력값을 만든다.%>
			basicAddr = "["+zip+"] "+sido+" "+gungu;
			if (dong=="")
			{
				basicAddr = basicAddr + " "+eupmyun;
			}
			else
			{
				basicAddr = basicAddr + " "+dong;
			}
			if (ri!="")
			{
				basicAddr = basicAddr + " "+ri;
			}
			<%'// 상세주소 입력값을 만든다.%>
			if (official_bld!="")
			{
				basicAddr = basicAddr + " "+jibun+" "+official_bld;
			}
			else
			{
				basicAddr = basicAddr + " "+jibun;
			}
			$("#Jibunfinder").hide();
			$("#resultJibun").hide();
			$("#jibunDetail").show();
			$("#jibunDetailAddr").val(basicAddr);
		}

		if (type=="road")
		{
			<%'// 기본주소 입력값을 만든다.%>
			basicAddr = "["+zip+"] "+sido+" "+gungu;
			if (eupmyun!="")
			{
				basicAddr = basicAddr + " "+eupmyun+" "+road;
			}
			else
			{
				basicAddr = basicAddr + " "+road;
			}
			if (building_no!="")
			{
				basicAddr = basicAddr + " "+building_no;
			}
			<%'// 상세주소 입력값을 만든다.%>
			if (official_bld!="")
			{
				basicAddr2 = ""+official_bld+"";
			}

			$("#Jibunfinder").hide();
			$("#resultJibun").hide();
			$("#jibunDetail").show();
			$("#jibunDetailAddr").val(basicAddr);
		}

		$("#"+wp).empty().html(basicAddr);
		if (basicAddr2!="")
		{
			$("#"+uwp).val(basicAddr2);
		}
		$("#"+uwp).focus();

	}


	<%'// 모창에 값 던져줌 %>
	function CopyZip(x)	{

		<%'// api로 검색시에는 CopyZipAPI로 던져줌 %>
		if ($("#keyword").val()!="")
		{
			CopyZipAPI(x);
			return false;
		}

		var frm = document.<%=strTarget%>;
		var basicAddr;
		var basicAddr2;

		<%'// 기본주소 입력값을 만든다.%>
		basicAddr = $("#sido").val()+" "+$("#gungu").val();

		if ($("#gubun").val()=="jibun")
		{
			<%'// 상세주소 입력값을 만든다.%>
			if ($("#dong").val()=="")
			{
				basicAddr2 = $("#eupmyun").val();;
			}
			else
			{
				basicAddr2 = $("#dong").val();
			}
			if ($("#ri").val()!="")
			{
				basicAddr2 = basicAddr2 + " "+$("#ri").val();
			}
			if ($("#official_bld").val()!="")
			{
				basicAddr2 = basicAddr2 + " "+$("#jibun").val()+" "+$("#official_bld").val();
			}
			else
			{
				basicAddr2 = basicAddr2 + " "+$("#jibun").val();
			}
			if ($("#"+x).val()!="")
			{
				basicAddr2 = basicAddr2 + " "+$("#"+x).val();
			}
		}
		if ($("#gubun").val()=="road")
		{
			if ($("#eupmyun").val()!="")
			{
				basicAddr2 = $("#eupmyun").val()+" "+$("#road").val();
			}
			else
			{
				basicAddr2 = $("#road").val();
			}
			if ($("#building_no").val()!="")
			{
				basicAddr2 = basicAddr2 + " "+$("#building_no").val();
			}
			if ($("#"+x).val()!="")
			{
				basicAddr2 = basicAddr2 + " "+$("#"+x).val();
			}
		}

		// 부모창에 스크립트 전달 후 APP창 닫기
		fnAPPopenerJsCallClose("FnInputZipAddrNew('<%=strTarget%>','"+$("#zip").val()+"','"+basicAddr+"','"+basicAddr2+"','<%=gubun%>')");
	}

	function removeChar() {
		if ($("#zipcode").val().length > 7)
		{
			alert("우편번호는 7자리까지 입력가능합니다.");
			$("#zipcode").val($("#zipcode").val().substr(0, 7));
			$("#zipcode").focus();
			return false;
		}
		else
		{
			return; 
		}
	}

	<%' 직접입력용 %>
	function CopyZipUserInput()
	{

		var frm = document.<%=strTarget%>;

		if ($("#zipcode").val()=="")
		{
			alert("우편번호를 입력해주세요.");
			$("#zipcode").focus();
			return false;
		}

		if(!(/^\d{3}-?\d{3}$/.test($("#zipcode").val()) || /^\d{5}/.test($("#zipcode").val()))){
			alert("우편번호 형식이 아닙니다. 우편번호를 확인해주세요.");
			$("#zipcode").focus();
			return false;
		}

		if ($("#city1").val()=="")
		{
			alert("시/도를 선택해주세요.");
			$("#city1").focus()
			return false;
		}
		if ($("#city1").val()!="세종특별자치시")
		{
			if ($("#city2").val()=="")
			{
				alert("시/군/구를 선택해주세요.");
				$("#city2").focus()
				return false;
			}
		}
		if ($("#DetailAddr").val()=="")
		{
			alert("도로명/지번을 입력해주세요.");
			$("#DetailAddr").focus()
			return false;
		}

		// 부모창에 스크립트 전달 후 APP창 닫기
		fnAPPopenerJsCallClose("FnInputZipAddrNew('<%=strTarget%>','"+$("#zipcode").val()+"','"+$("#city1").val()+" "+$("#city2").val()+"','"+$("#DetailAddr").val()+" "+$("#DetailAddr2").val()+"','<%=gubun%>')");
	}


	function jsPageGo(icpg){
		var frm = document.searchProcFrm;
		frm.cpg.value=icpg;

		$.ajax({
			type:"get",
			url:"/lib/pop_searchzipnewProc.asp",
			data: $("#searchProcFrm").serialize(),
			dataType: "text",
			async:false,
			cache:true,
			success : function(Data, textStatus, jqXHR){
				if (jqXHR.readyState == 4) {
					if (jqXHR.status == 200) {
						if(Data!="") {
							var str;
							for(var i in Data)
							{
								 if(Data.hasOwnProperty(i))
								{
									str += Data[i];
								}
							}
							str = str.replace("undefined","");
							res = str.split("|");
							if (res[0]=="OK")
							{
								$("#resultJibun").show();
								$("#jibunaddrList").empty().html(res[1]);
								if (res[3]!="")
								{
									$("#addrpaging").empty().html(res[3]);
								}
							}
							else
							{
								errorMsg = res[1].replace(">?n", "\n");
								alert(errorMsg );
								return false;
							}
						} else {
							alert("잘못된 접근 입니다.");
							return false;
						}
					}
				}
			},
			error:function(jqXHR, textStatus, errorThrown){
				alert("잘못된 접근 입니다!");
				return false;
			}
		});

	}


	<%' 검색 juso.go.kr api 사용영역 %>
	function SubmitFormAPI()
	{
		if ($("#tJibundong").val().length < 2) { alert("검색어를 두 글자 이상 입력하세요."); return; }
		$("#keyword").val($("#tJibundong").val());
		$("#currentPage").val(1);
		$.ajax({
/*
		     url :"http://www.juso.go.kr/addrlink/addrLinkApiJsonp.do"
			,type:"post"
			,data:$("#searchProcApi").serialize()
			,dataType:"jsonp"
			,cache:true
			,crossDomain:true
*/
			 url : "/lib/sz_gate.asp" 
			,type:"get"
			,data:$("#searchProcApi").serialize()
			,dataType:"jsonp"
			,cache:true
			,success:function(xmlStr){
				if(navigator.appName.indexOf("Microsoft") > -1){
					var xmlData = new ActiveXObject("Microsoft.XMLDOM");
					xmlData.loadXML(xmlStr.returnXml)
				}else{
					var xmlData = xmlStr.returnXml;
				}
				$("#jibunaddrList").html("");
				var errCode = $(xmlData).find("errorCode").text();
				var errDesc = $(xmlData).find("errorMessage").text();
				if(errCode != "0"){
					alert(errCode+"="+errDesc);
				}else{
					if ($(xmlData).find("totalCount").text()=="0")
					{
						$("#Jibunfinder").show();
						$("#guideTxtVal").hide();
						$("#tipTxtVal").show();
						$("#noResultData").show();
						$("#noResultData").empty().html("<p>검색된 주소가 없습니다</p>");
						$("#resultJibun").hide();
					}
					else
					{
						if(xmlStr != null){

							$("#resultJibun").show();
							$("#guideTxtVal").hide();
							$("#noResultData").hide();
							$("#tipTxtVal").hide();
							$("#jibuntotalcntView").empty().html("총 <em>"+$(xmlData).find("totalCount").text()+"</em> 건");
							fnDisplayPaging_New_nottextboxdirectJS($("#currentPage").val(),$(xmlData).find("totalCount").text(),$("#countPerPage").val(),4,'jsPageGoAPI');
							makeList(xmlData);
						}
					}
				}
			}
		});
	}

	<%'// 페이징 자바스크립트 버전 %>
	function fnDisplayPaging_New_nottextboxdirectJS(strCurrentPage, intTotalRecord, intRecordPerPage, intBlockPerPage, strJsFuncName) {
		var intCurrentPage;
		var strCurrentPath;
		var vPageBody;
		var intStartBlock;
		var intEndBlock;
		var intTotalPage;
		var strParamName;
		var intLoop;

		<%'// 현재 페이지 설정 %>
		intCurrentPage = strCurrentPage;

		<%'// 해당 페이지에 표시되는 시작페이지와 마지막페이지 설정 %>
		intStartBlock = parseInt((intCurrentPage - 1) / intBlockPerPage) * intBlockPerPage + 1;
		intEndBlock = parseInt((intCurrentPage - 1) / intBlockPerPage) * intBlockPerPage + intBlockPerPage;

		<%'// 총 페이지 수 설정 %>
		intTotalPage = parseInt((intTotalRecord - 1)/intRecordPerPage) + 1

		if (intTotalPage < 1)
		{
			intTotalPage = 1;
		}

		vPageBody = "";
		vPageBody = vPageBody + "<div class='paging pagingV15a'>";

		<%'// 이전 페이지 %>
		if (intStartBlock > 1)
		{
			vPageBody = vPageBody + "<span class='arrow prevBtn'><a href='#' onclick='"+strJsFuncName+"("+(intStartBlock-1)+");'>prev</a></span>";
		}
		else
		{
			vPageBody = vPageBody + "<span class='arrow prevBtn'><a href='#' onclick='return false;'>prev</a></span>";
		}

		<%'// 현재 페이지 %>
		if (intTotalPage > 1)
		{
			for (intLoop = intStartBlock; intLoop<(intEndBlock+1); intLoop++)
			{
				if (intLoop > intTotalPage)
				{
					break;
				}
				if (intLoop == intCurrentPage) 
				{
					vPageBody = vPageBody + "	<span class='current'><a href='#' onclick='"+strJsFuncName+"("+(intLoop)+");'>"+intLoop+"</a></span>";
				}
				else
				{
					vPageBody = vPageBody + "	<span><a href='#' onclick='"+strJsFuncName+"("+(intLoop)+");'>"+intLoop+"</a></span>";
				}

			}
		}
		else
		{
			vPageBody = vPageBody + "	<span class='current'><a href='#' onclick='"+strJsFuncName+"(1);'>1</a></span>";
		}
		<%'// 다음 페이지 %>
		if (intEndBlock < intTotalPage)
		{
			vPageBody = vPageBody + "	<span class='arrow nextBtn'><a href='#' onclick='"+strJsFuncName+"("+(intEndBlock+1)+");'>next</a></span>";
		}
		else
		{
			vPageBody = vPageBody + "	<span class='arrow nextBtn'><a href='#' onclick='return false;'>next</a></span>";
		}

		vPageBody = vPageBody + "</div>";

		$("#addrpaging").empty().html(vPageBody);

	}

	function jsPageGoAPI(icomp)
	{
		$("#currentPage").val(icomp);
		$.ajax({
/*
		     url :"http://www.juso.go.kr/addrlink/addrLinkApiJsonp.do"
			,type:"post"
			,data:$("#searchProcApi").serialize()
			,dataType:"jsonp"
			,crossDomain:true
			,cache:true
*/
			 url : "/lib/sz_gate.asp" 
			,type:"get"
			,data:$("#searchProcApi").serialize()
			,dataType:"jsonp"
			,cache:true
			,success:function(xmlStr){
				if(navigator.appName.indexOf("Microsoft") > -1){
					var xmlData = new ActiveXObject("Microsoft.XMLDOM");
					xmlData.loadXML(xmlStr.returnXml)
				}else{
					var xmlData = xmlStr.returnXml;
				}
				$("#jibunaddrList").html("");
				var errCode = $(xmlData).find("errorCode").text();
				var errDesc = $(xmlData).find("errorMessage").text();
				if(errCode != "0"){
					alert(errCode+"="+errDesc);
				}else{
					if ($(xmlData).find("totalCount").text()=="0")
					{
						$("#Jibunfinder").show();
						$("#guideTxtVal").hide();
						$("#tipTxtVal").show();
						$("#noResultData").show();
						$("#noResultData").empty().html("<p>검색된 주소가 없습니다</p>");
					}
					else
					{
						if(xmlStr != null){
							$("#Jibunfinder").show();
							$("#resultJibun").show();
							$("#JibunHelp").show();
							$("#jibuntotalcntView").empty().html("총 <em>"+$(xmlData).find("totalCount").text()+"</em> 건");
							fnDisplayPaging_New_nottextboxdirectJS($("#currentPage").val(),$(xmlData).find("totalCount").text(),$("#countPerPage").val(),4,'jsPageGoAPI');
							makeList(xmlData);
						}
					}
				}
			}
		});

	}

	function makeList(xmlStr){
		var htmlStr = "";
		$(xmlStr).find("juso").each(function(){
			var r = "'"+$(this).find('zipNo').text()+"','"+$(this).find('roadAddr').text()+"','jibunDetailAddr','jibunDetailAddr2'";
			var s = "'"+$(this).find('zipNo').text()+"','"+$(this).find('jibunAddr').text()+"','jibunDetailAddr','jibunDetailAddr2'";
			htmlStr += '<li><span class="postcode">'+$(this).find('zipNo').text()+'</span>';
			htmlStr += '<a href="" onclick="setAddrAPI('+r+');return false;"><em>도로</em><div>'+$(this).find('roadAddr').text()+'</div></a>';
			htmlStr += '<a href="" onclick="setAddrAPI('+s+');return false;"><em>지번</em><div>'+$(this).find('jibunAddr').text();
			htmlStr += '</div></a></li>';
		});
		$("#jibunaddrList").empty().html(htmlStr);

	}

	function setAddrAPI(zip, addr, wp, uwp)
	{
		var basicAddr; // 기본주소

		basicAddr = "["+zip+"] "+addr;

		basicAddr = basicAddr.replace("  "," ");
		addr = addr.replace("  "," ");

		$("#tzip").val(zip);
		$("#taddr1").val(addr);

		$("#"+wp).val(basicAddr);
		$("#"+uwp).focus();

		$("#Jibunfinder").hide();
		$("#resultJibun").hide();
		$("#jibunDetail").show();

	}

	<%'// 모창에 값 던져줌 %>
	function CopyZipAPI(x)	{
		var frm = eval("document.<%=strTarget%>");
		var basicAddr;
		var basicAddr2;
		var chkAddr;
		var tmpaddr;
		basicAddr = "";
		basicAddr2 = "";

		<%'// 기본주소 입력값을 만든다.%>
		tmpaddr = $("#taddr1").val().split(" ");

		if (tmpaddr.length >= 3)
		{
			if (tmpaddr[2].substring(tmpaddr[2].length-1, tmpaddr[2].length)=="구")
			{
				basicAddr = tmpaddr[0]+" "+tmpaddr[1]+" "+tmpaddr[2];
				chkAddr = "2";
			}
			else
			{
				basicAddr = tmpaddr[0]+" "+tmpaddr[1];
				chkAddr = "1";
			}
		}
		else
		{
			basicAddr = tmpaddr[0]+" "+tmpaddr[1];
			chkAddr = "1";
		}

		<%'// 상세주소 입력값을 만든다.%>
		for (var iadd=parseInt(chkAddr)+1;iadd < parseInt(tmpaddr.length);iadd++)
		{
			basicAddr2 += tmpaddr[iadd]+" ";
		}
		if ($("#"+x).val()!="")
		{
			basicAddr2 = basicAddr2 + $("#"+x).val();
		}

		// 부모창에 스크립트 전달 후 APP창 닫기
		fnAPPopenerJsCallClose("FnInputZipAddrNew('<%=strTarget%>','"+$("#tzip").val()+"','"+basicAddr+"','"+basicAddr2+"','<%=gubun%>')");
	}

	function setResetVal()
	{
		$("#zipcode").val("");	
		$("#city1").val("");
		$("#city2").empty().html("<option value=''>시/군/구 선택</option>");
		$("#DetailAddr").val("");
		$("#DetailAddr2").val("");
	}


</script>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content" id="contentArea" style="background-color:#f4f7f7;">
			<div class="layerCont">

				<%' [주소검색] 우편번호 찾기 %>
				<div class="tabonoff zipcodeV17">
					<ul class="tabs commonTabV16a tNum2">
						<li><a href="#tabcont1">통합 검색</a></li>
						<li><a href="#tabcont2">직접 입력</a></li>
					</ul>

					<div class="tabcontainer">
						<%' tab1 통합 검색 %>
						<div id="tabcont1" class="tabcont">
							<h2 class="hidden">통합 검색</h2>
							<%' 검색 %>
							<div class="searchForm" id="Jibunfinder">
								<div class="finder">
									<form onsubmit="return false">
										<fieldset>
											<legend>주소 검색 폼</legend>
											<div class="inner">
												<input type="search" id="tJibundong" title="검색어 입력" placeholder="예) 동숭동 1-45" class="frmInputV16" onkeydown="javascript: if (event.keyCode == 13) {SubmitForm('jibun');}" />
												<input type="reset" value="초기화" class="btnReset" />
											</div>
											<input type="submit" value="검색" class="btnV16a btnRed2V16a" onclick="SubmitForm('jibun');" />
										</fieldset>
									</form>
								</div>
							</div>

							<div class="guide" id="guideTxtVal">
								<p>도로명, 건물명, 지번을 이용해<br /> 주소를 검색해주세요</p>
							</div>

							<%' for dev msg : 검색된 주소가 없을 경우 %>
							<div class="guide noData" id="noResultData" style="display:none;"></div>

							<div class="tip" id="tipTxtVal">
								<h3><span>Tip</span> 효과적인 우편번호 검색방법</h3>
								<ul>
									<li>도로명 + 건물번호 검색 <span>대학로12길 31 , 사직로 161</span></li>
									<li>지역명(동/리) + 번지 검색 <span>동숭동 1-45 , 세종로 1-91</span></li>
									<li>지역명(동/리) + 건물명(아파트명) 검색 <span>번동 주공</span></li>
								</ul>
							</div>

							<%' 검색결과 %>
							<div class="result" id="resultJibun" style="display:none;">
								<div class="total" id="jibuntotalcntView"></div>
								<ul id="jibunaddrList"></ul>

								<%' pagination %>
								<div class="pagingV16" id="addrpaging"></div>
							</div>

							<%' 상세 주소 입력 %>
							<div class="searchForm" id="jibunDetail" style="display:none;">
								<form onsubmit="return false">
									<fieldset>
									<legend>상세 주소 입력</legend>
										<ul>
											<li>
												<label for="defaultAddress">선택주소</label>
												<input type="text" id="jibunDetailAddr" readonly="readonly" class="frmInputV16" />
											</li>
											<li>
												<label for="detailAddress">상세주소</label>
												<input type="text" id="jibunDetailAddr2" onkeydown="javascript: if (event.keyCode == 13) {CopyZip('jibunDetailAddr2', 'jibun');}" class="frmInputV16" />
											</li>
										</ul>

										<div class="btnAreaV16a">
											<div class="half"><a href="" class="btnV16a btRedBdr cRd1" onclick="setBackAction('jibunDetail','resultJibun','Jibunfinder');return false;">이전</a></div>
											<div class="half"><input type="submit" class="btnV16a btnRed2V16a" value="확인" onclick="CopyZip('jibunDetailAddr2', 'jibun');" id="btnonsubmitSearchaddr"/></div>
										</div>
									</fieldset>
								</form>
							</div>
						</div>
						<%' //tab1 %>

						<%' tab2 직접 입력 %>
						<div id="tabcont2" class="tabcont">
							<h2 class="hidden">직접 입력</h2>

							<%' 검색 %>
							<div class="searchForm">
								<form onsubmit="return false">
									<fieldset>
									<legend>우편번호, 시/도, 시/군/구 및 도로명 또는 지번, 상세주소 입력 폼</legend>
										<ul>
											<li>
												<label for="zipcodeNo">우편번호</label>
												<input type="text" id="zipcode" onkeyup='removeChar()' style='ime-mode:disabled;' class="frmInputV16" maxlength="7"/>
											</li>
											<li>
												<label for="city1">시/도</label>
												<select id="city1" onchange="getgunguList(this.value, 'city2')" class="frmSelectV16">
													<option value="">시/도 선택</option>
													<option value="서울특별시">서울특별시</option>
													<option value="경기도">경기도</option>
													<option value="강원도">강원도</option>
													<option value="인천광역시">인천광역시</option>
													<option value="충청북도">충청북도</option>
													<option value="충청남도">충청남도</option>
													<option value="대전광역시">대전광역시</option>
													<option value="경상북도">경상북도</option>
													<option value="경상남도">경상남도</option>
													<option value="세종특별자치시">세종특별자치시</option>
													<option value="대구광역시">대구광역시</option>
													<option value="부산광역시">부산광역시</option>
													<option value="울산광역시">울산광역시</option>
													<option value="전라북도">전라북도</option>
													<option value="전라남도">전라남도</option>
													<option value="광주광역시">광주광역시</option>
													<option value="제주특별자치도">제주특별자치도</option>
												</select>
											</li>
											<li>
												<label for="city2">시/군/구</label>
												<select id="city2" class="frmSelectV16">
													<option value="">시/군/구 선택</option>
												</select>
											</li>
											<li>
												<label for="town">도로명/지번</label>
												<input type="text" id="DetailAddr" class="frmInputV16" />
											</li>
											<li>
												<label for="address">상세주소</label>
												<input type="text" id="DetailAddr2" class="frmInputV16" />
											</li>
										</ul>

										<div class="btnAreaV16a">
											<div class="half"><input type="reset" value="초기화" class="btnV16a btRedBdr cRd1" onclick="setResetVal();return false;"/></div>
											<div class="half"><input type="submit" value="확인" class="btnV16a btnRed2V16a" onclick="CopyZipUserInput();return false;" /></div>
										</div>
									</fieldset>
								</form>
							</div>
						</div>
						<%' //tab2 %>
					</div>
				</div>

			</div>
		</div>
	</div>
	<form name="searchProcFrm" id="searchProcFrm" method="post">
		<input type="hidden" name="sGubun" id="sGubun">
		<input type="hidden" name="sJibundong" id="sJibundong">
		<input type="hidden" name="sSidoGubun" id="sSidoGubun">
		<input type="hidden" name="sSido" id="sSido">
		<input type="hidden" name="sGungu" id="sGungu">
		<input type="hidden" name="sRoadName" id="sRoadName">
		<input type="hidden" name="sRoadBno" id="sRoadBno">
		<input type="hidden" name="sRoaddong" id="sRoaddong">
		<input type="hidden" name="sRoadjibun" id="sRoadjibun">
		<input type="hidden" name="sRoadBname" id="sRoadBname">
		<input type="hidden" name="cpg" id="cpg" value="<%=currpage%>">
		<input type="hidden" name="psz" id="psz" value="<%=pagesize%>">
	</form>

	<form name="tranFrm" id="tranFrm" method="post">
		<input type="hidden" name="zip" id="zip">
		<input type="hidden" name="sido" id="sido">
		<input type="hidden" name="gungu" id="gungu">
		<input type="hidden" name="dong" id="dong">
		<input type="hidden" name="eupmyun" id="eupmyun">
		<input type="hidden" name="ri" id="ri">
		<input type="hidden" name="official_bld" id="official_bld">
		<input type="hidden" name="jibun" id="jibun">
		<input type="hidden" name="road" id="road">
		<input type="hidden" name="building_no" id="building_no">
		<input type="hidden" name="gubun" id="gubun">
	</form>

	<form name="searchProcApi" id="searchProcApi" method="post">
		<input type="hidden" name="currentPage" id="currentPage" value="1"/>
		<input type="hidden" name="countPerPage" id="countPerPage" value="5"/> 
		<input type="hidden" name="confmKey" id="confmKey" value="U01TX0FVVEgyMDE2MDcwNDIwMjE0NDEzNTk5"/>
		<input type="hidden" name="keyword" id="keyword" value=""/>
	</form>

	<form name="tranFrmApi" id="tranFrmApi" method="post">
		<input type="hidden" name="tzip" id="tzip">
		<input type="hidden" name="taddr1" id="taddr1">
		<input type="hidden" name="taddr2" id="taddr2">
	</form>

</div>
<!-- #include virtual="/lib/db/dbEVTclose.asp" -->
