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
' Description : 주소검색
' History : 2016.08.11 한용민 생성
'###########################################################
%>
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbEVTopen.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/search/Zipsearchcls.asp" -->
<%
	Dim strTarget
	Dim strMode, protocolAddr
	strTarget	= requestCheckVar(Request("target"),32)
	strMode     = requestCheckVar(Request("strMode"),32)

	dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),5))
	dim CurrPage : CurrPage = getNumeric(requestCheckVar(request("cpg"),8))
	if CurrPage="" then CurrPage=1
	if PageSize="" then PageSize=300	'/300이상 절대 늘리면 안됨 아작스 뻣음. 차후 텐바이텐 처럼 페이징 방식으로 해야함

%>
<script type="text/javascript">

$(function(){
	/* tab onoff */
	$(".tabonoff .tabcontainer .tabcont").css("display", "none");
	$(".tabonoff .tabcontainer .tabcont:nth-child(2)").css("display", "block");
	$(".tabonoff .parentTab li:nth-child(2) a").addClass("on");
	$(".tabonoff").delegate(".tabs li", "click", function() {
		var index = $(this).parent().children().index(this);
		if ( $(this).hasClass("first")) {
			$(".tabonoff .tabcontainer .tabcont").css("display", "none");
			$(".tabonoff .tabcontainer .tabcont:first-child").css("display", "block");
			$(this).siblings().children().removeClass();
			$(".tabonoff .parentTab li:first a").addClass("on");
			$(".childTab li a").removeClass("on");
			$(".childTab li:first-child a").addClass("on");
			myScroll.refresh();
			return false;
		} else {
			$(this).siblings().children().removeClass();
			$(this).children().addClass("on");
			$(this).parent().next(".tabcontainer").children().hide().eq(index).show();
			myScroll.refresh();
			return false;
		}
	});
});

	<%'// 검색 %>
	function SubmitForm(stype) {

		<%'// 지번 일 경우 %>
		if (stype=="jibun")
		{
			if ($("#tJibundong").val().length < 2) { alert("검색어를 두 글자 이상 입력하세요."); return; }
			$("#sGubun").val(stype);
			$("#sJibundong").val($("#tJibundong").val());
			$("#cpg").val(1);
		}

		<%'// 도로명+건물번호 일 경우 %>
		if (stype=="RoadBnumber")
		{
			if ($("#ctiy11").val()=="")
			{
				alert('시/도를 선택해 주세요.');
				return;
			}

			<%'// 세종특별자치시는 시군구가 없어서 체크안함 %>
			if ($("#ctiy11").val()!="세종특별자치시")
			{
				if ($("#ctiy12").val()=="")
				{
					alert('시/군/구를 선택해 주세요.');
					return;
				}
			}
			if ($("#NameRoadBnumber").val()=="")
			{
				alert('도로명을 입력해 주세요.');
				$("#NameRoadBnumber").focus();
				return;	
			}
			if ($("#NumberRoadBnumber").val()=="")
			{
				alert('건물번호를 입력해 주세요.');
				$("#NumberRoadBnumber").focus();
				return;	
			}

			$("#sGubun").val(stype);
			$("#sSido").val($("#ctiy11").val());
			$("#sGungu").val($("#ctiy12").val());
			$("#sRoadName").val($("#NameRoadBnumber").val());
			$("#sRoadBno").val($("#NumberRoadBnumber").val());
		}

		<%'// 도로명에 동(읍/면)+지번 일 경우 %>
		if (stype=="RoadBjibun")
		{
			if ($("#ctiy21").val()=="")
			{
				alert('시/도를 선택해 주세요.');
				return;
			}

			<%'// 세종특별자치시는 시군구가 없어서 체크안함 %>
			if ($("#ctiy21").val()!="세종특별자치시")
			{
				if ($("#ctiy22").val()=="")
				{
					alert('시/군/구를 선택해 주세요.');
					return;
				}
			}
			if ($("#DongRoadBjibun").val()=="")
			{
				alert('동(읍/면)을 입력해 주세요.');
				$("#DongRoadBjibun").focus();
				return;	
			}
			if ($("#JibunRoadBjibun").val()=="")
			{
				alert('지번을 입력해 주세요.');
				$("#JibunRoadBjibun").focus();
				return;	
			}
			$("#sGubun").val(stype);
			$("#sSido").val($("#ctiy21").val());
			$("#sGungu").val($("#ctiy22").val());
			$("#sRoaddong").val($("#DongRoadBjibun").val());
			$("#sRoadjibun").val($("#JibunRoadBjibun").val());
		}

		<%'// 도로명에 건물명 일 경우 %>
		if (stype=="RoadBname")
		{
			if ($("#ctiy31").val()=="")
			{
				alert('시/도를 선택해 주세요.');
				return;
			}

			<%'// 세종특별자치시는 시군구가 없어서 체크안함 %>
			if ($("#ctiy31").val()!="세종특별자치시")
			{
				if ($("#ctiy32").val()=="")
				{
					alert('시/군/구를 선택해 주세요.');
					return;
				}
			}
			if ($("#NameRoadBname").val()=="")
			{
				alert('건물명을 입력해 주세요.');
				$("#NameRoadBname").focus();
				return;	
			}
			$("#sGubun").val(stype);
			$("#sSido").val($("#ctiy31").val());
			$("#sGungu").val($("#ctiy32").val());
			$("#sRoadBname").val($("#NameRoadBname").val());
		}

		$.ajax({
			type:"get",
			<%
			'/용만이 tenUserSn:100432
			'if fnGetUserInfo("TENSN")="100432" then
			%>
				//url:"/apps/appCom/between/lib/pop_searchzipNewProc_test.asp",
			<% 'else %>
				url:"/apps/appCom/between/lib/pop_searchzipNewProc.asp",
			<% 'end if %>
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
									$("#resultJibun").show();
									setTimeout(function () {
										window.$('html,body').animate({scrollTop:$("#resultJibun").offset().top}, 0);
									}, 10);
									if (res[1]=="<li class='nodata'>검색된 주소가 없습니다.</li>")
									{
										$("#JibunHelp").hide();
									}
									else
									{
										$("#JibunHelp").show();
									}
									$("#jibunaddrList").empty().html(res[1]);
//									if (res[3]!="")
//									{
//										$("#addrpaging").empty().html(res[3]);
//									}
									if (res[2] > 100)
									{
										$("#cautionTxtJibun").empty().html("<p></p><p>검색 결과가 많을 경우<br />지번 또는 건물명과 함께 검색해주세요</p><p class='ex'>예) 동숭동 1-45, 동숭동 동숭아트센타</p>");
										$("#cautionTxtJibun").show();
									}
									else
									{
										$("#cautionTxtJibun").empty();
									}
									$("#jibuntotalcntView").empty().html("총 <b>"+numberWithCommas(res[2])+"</b> 건");
								}

								if (stype=="RoadBnumber")
								{
									$("#resultRoadBnumber").show();
									setTimeout(function () {
										window.$('html,body').animate({scrollTop:$("#resultRoadBnumber").offset().top}, 0);
									}, 10);
									if (res[1]=="<li class='nodata'>검색된 주소가 없습니다.</li>")
									{
										$("#RoadBnumberHelp").hide();
									}
									else
									{
										$("#RoadBnumberHelp").show();
									}
									$("#RoadBnumberaddrList").empty().html(res[1]);
								}

								if (stype=="RoadBjibun")
								{
									$("#resultRoadBjibun").show();
									setTimeout(function () {
										window.$('html,body').animate({scrollTop:$("#resultRoadBjibun").offset().top}, 0);
									}, 10);
									if (res[1]=="<li class='nodata'>검색된 주소가 없습니다.</li>")
									{
										$("#RoadBjibunHelp").hide();
									}
									else
									{
										$("#RoadBjibunHelp").show();
									}
									$("#RoadBjibunaddrList").empty().html(res[1]);
								}

								if (stype=="RoadBname")
								{
									$("#resultRoadBname").show();
									setTimeout(function () {
										window.$('html,body').animate({scrollTop:$("#resultRoadBname").offset().top}, 0);
									}, 10);
									if (res[1]=="<li class='nodata'>검색된 주소가 없습니다.</li>")
									{
										$("#RoadBnameHelp").hide();
									}
									else
									{
										$("#RoadBnameHelp").show();
									}
									$("#RoadBnameaddrList").empty().html(res[1]);
								}

								setTimeout(function () {
									myScroll.refresh();
								}, 50);

							}
							else
							{
								errorMsg = res[1].replace(">?n", "\n");
								alert("error : " + errorMsg);
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
				alert("잘못된 접근 입니다[" + jqXHR.status + "]");
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
				url:"/apps/appCom/between/lib/pop_searchzipNewProc.asp",
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
		myScroll.refresh();
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
				basicAddr = basicAddr + " "+official_bld+" "+jibun;
			}
			else
			{
				basicAddr = basicAddr + " "+jibun;
			}
			$("#Jibunfinder").hide();
			$("#resultJibun").hide();
			$("#jibunDetail").show();
		}

		if (type=="RoadBnumber")
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

			<%' // 지번주소 입력값을 만든다.%>
			roadbasicAddr = sido+" "+gungu;
			if (dong=="")
			{
				roadbasicAddr = roadbasicAddr + " "+eupmyun;
			}
			else
			{
				roadbasicAddr = roadbasicAddr + " "+dong;
			}
			if (ri!="")
			{
				roadbasicAddr = roadbasicAddr + " "+ri;
			}
			if (official_bld!="")
			{
				roadbasicAddr = roadbasicAddr + " "+official_bld+" "+jibun;
			}
			else
			{
				roadbasicAddr = roadbasicAddr + " "+jibun;
			}
			$("#RoadBnumberJibunDetail").empty().html("지번 주소 : "+roadbasicAddr);
			$("#RoadBnumberfinder").hide();
			$("#resultRoadBnumber").hide();
			$("#RoadBnumberDetail").show();
		}

		if (type=="RoadBjibun")
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

			<%' // 지번주소 입력값을 만든다.%>
			roadbasicAddr = sido+" "+gungu;
			if (dong=="")
			{
				roadbasicAddr = roadbasicAddr + " "+eupmyun;
			}
			else
			{
				roadbasicAddr = roadbasicAddr + " "+dong;
			}
			if (ri!="")
			{
				roadbasicAddr = roadbasicAddr + " "+ri;
			}
			if (official_bld!="")
			{
				roadbasicAddr = roadbasicAddr + " "+official_bld+" "+jibun;
			}
			else
			{
				roadbasicAddr = roadbasicAddr + " "+jibun;
			}
			$("#RoadBjibunJibunDetail").empty().html("지번 주소 : "+roadbasicAddr);
			$("#RoadBjibunfinder").hide();
			$("#resultRoadBjibun").hide();
			$("#RoadBjibunDetail").show();
		}

		if (type=="RoadBname")
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

			<%' // 지번주소 입력값을 만든다.%>
			roadbasicAddr = sido+" "+gungu;
			if (dong=="")
			{
				roadbasicAddr = roadbasicAddr + " "+eupmyun;
			}
			else
			{
				roadbasicAddr = roadbasicAddr + " "+dong;
			}
			if (ri!="")
			{
				roadbasicAddr = roadbasicAddr + " "+ri;
			}
			if (official_bld!="")
			{
				roadbasicAddr = roadbasicAddr + " "+official_bld+" "+jibun;
			}
			else
			{
				roadbasicAddr = roadbasicAddr + " "+jibun;
			}
			$("#RoadBnameJibunDetail").empty().html("지번 주소 : "+roadbasicAddr);
			$("#RoadBnamefinder").hide();
			$("#resultRoadBname").hide();
			$("#RoadBnameDetail").show();
		}

		$("#"+wp).empty().html(basicAddr);
		if (basicAddr2!="")
		{
			$("#"+uwp).val(basicAddr2);
		}
		$("#"+uwp).focus();

		myScroll.refresh();
	}


	<%'// 모창에 값 던져줌 %>
	function CopyZip(x, y)	{
		var frm = document.<%=strTarget%>;
		var basicAddr;
		var basicAddr2;

		<%'// 기본주소 입력값을 만든다.%>
		basicAddr = $("#sido").val()+" "+$("#gungu").val();

		if (y=="jibun")
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
				basicAddr2 = basicAddr2 + " "+$("#official_bld").val()+" "+$("#jibun").val();
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
		if (y=="RoadBnumber")
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
		if (y=="RoadBjibun")
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
		if (y=="RoadBname")
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


		// copy
		<%
			Select Case strTarget
				Case "frmWrite"		'나의 주소록 Form
		%>
			//frm.zip1.value			= post1;
			//frm.zip2.value			= post2;
			frm.zip.value		= $("#zip").val();
			frm.reqZipaddr.value	= basicAddr;
			frm.reqAddress.value	= basicAddr2;
		<%		Case "buyer" %>
			frm.buyZip1.value		= post1;
			frm.buyZip2.value		= post2;
			frm.buyAddr1.value		= add;
			frm.buyAddr2.value		= dong;
		<%		Case "userinfo" %>
			frm.txZip1.value		= post1;
			frm.txZip2.value		= post2;
			frm.txAddr1.value		= add;
			frm.txAddr2.value		= dong;
		<%		Case "frmorder" %>
			frm.txZip.value		= $("#zip").val();
			frm.txAddr1.value	= basicAddr;
			frm.txAddr2.value	= basicAddr2;
		<%		Case Else %>
			frm.txZip.value		= $("#zip").val();
			frm.txAddr1.value		= basicAddr;
			frm.txAddr2.value		= basicAddr2;
		<%	End Select %>
		jsClosePopup();

	}

	function jsPageGo(icpg){
		var frm = document.searchProcFrm;
		frm.cpg.value=icpg;

		$.ajax({
			type:"get",
			url:"/apps/appCom/between/lib/pop_searchzipnewProc.asp",
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
//								if (res[3]!="")
//								{
//									$("#addrpaging").empty().html(res[3]);
//								}
								if (res[2] > 100)
								{
									$("#cautionTxtJibun").empty().html("<p></p><p>검색 결과가 많을 경우<br />지번 또는 건물명과 함께 검색해주세요</p><p class='ex'>예) 동숭동 1-45, 동숭동 동숭아트센타</p>");
									$("#cautionTxtJibun").show();
								}
								else
								{
									$("#cautionTxtJibun").empty();
								}
								myScroll.refresh();
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

</script>

<div class="lyrPopWrap boxMdl midLyr">
	<div class="lyrPop">
		<div class="lyrPopCont lyrPopZipcodeV16">
			<h1>우편번호 찾기</h1>

			<div class="scrollerWrap">
				<div id="scroller">
					<div class="scroll">
						<div class="tabonoff zipcodeV16">
							<ul class="tabs parentTab">
								<li class="first"><a href="#tabcont1">도로명 주소</a></li>
								<li><a href="#tabcont2">지번 주소</a></li>
							</ul>

							<div class="tabcontainer">
								<%' tab1 도로명 주소 %>
								<div id="tabcont1" class="tabcont">
									<h2 class="hidden">도로명 주소</h2>
									<div class="tabonoff">
										<ul class="tabs childTab">
											<li><a href="#tabcont1-1">도로명 + 건물번호</a></li>
											<li><a href="#tabcont1-2">동(읍/면) + 지번</a></li>
											<li><a href="#tabcont1-3">건물명</a></li>
										</ul>
										<div class="tabcontainer">
											<%' tab1-1 도로명 + 건물번호 %>
											<div id="tabcont1-1" class="tabcont">
												<h3 class="hidden">도로명 + 건물번호</h3>

												<%' 검색 %>
												<div class="finder" id="RoadBnumberfinder">
													<fieldset>
														<legend>도로명 + 건물번호로 우편번호 찾기</legend>
														<div class="help">
															<p>도로명, 건물번호 를 입력 후 검색해주세요</p>
															<p class="ex">예) 대학로12길(도로명) 31 (건물번호)</p>
														</div>

														<ul>
															<li>
																<label for="ctiy11">시/도</label>
																<select id="ctiy11" onchange="getgunguList(this.value, 'ctiy12')" class="frmSelectV16">
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
																<label for="ctiy12">시/군/구</label>
																<select id="ctiy12" class="frmSelectV16">
																	<option>시/군/구 선택</option>
																</select>
															</li>
															<li>
																<label for="road">도로명</label>
																<input type="text" id="NameRoadBnumber" class="frmInputV16" />
															</li>
															<li>
																<label for="buildingno">건물번호</label>
																<input type="number" id="NumberRoadBnumber" onkeydown="javascript: if (event.keyCode == 13) {SubmitForm('RoadBnumber');}" class="frmInputV16" />
															</li>
														</ul>

														<div class="btnAreaV16a">
															<input type="submit" class="btnV16a btnRed2V16a btn02 btw" value="검색" onclick="SubmitForm('RoadBnumber');" />
														</div>
													</fieldset>

													<div class="reference">
														<p>도로명 주소 검색 결과가 없을 경우,<br /> 도로명 주소 안내시스템을 참고해주시길 바랍니다</p>
														<p><a href="http://www.juso.go.kr" target="_blank">http://www.juso.go.kr</a></p>
													</div>
												</div>

												<%' 검색결과 %>
												<div class="result" id="resultRoadBnumber" style="display:none;">
													<div class="help" id="RoadBnumberHelp">
														<p>아래 주소중 해당하는 주소를 선택해주세요</p>
													</div>

													<ul class="list" id="RoadBnumberaddrList"></ul>

													<div class="btnAreaV16a">
														<a href="" class="btnV16a btRedBdr cRd1 btn02 cnclGry">이전</a>
													</div>
												</div>

												<%' 상세주소 입력 %>
												<div class="form" id="RoadBnumberDetail" style="display:none;">
													<fieldset>
														<legend>상세주소 입력</legend>
														<div class="help">
															<p>상세 주소를 입력해주세요</p>
														</div>

														<div class="address">
															<p><span id="RoadBnumberDetailTxt"></span> <span id="RoadBnumberJibunDetail"></span></p>
															<input type="text" title="상세주소 입력" id="RoadBnumberDetailAddr2" placeholder="상세 주소를 입력해주세요" onkeydown="javascript: if (event.keyCode == 13) {CopyZip('RoadBnumberDetailAddr2', 'RoadBnumber');}" class="frmInputV16" />
														</div>

														<div class="btnAreaV16a">
															<div class="half"><a href="" class="btnV16a btRedBdr cRd1 btn02 cnclGry" onclick="setBackAction('RoadBnumberDetail','resultRoadBnumber','RoadBnumberfinder');return false;">이전</a></div>
															<div class="half"><input type="submit" class="btnV16a btnRed2V16a btn02 btw" value="주소입력" onclick="CopyZip('RoadBnumberDetailAddr2', 'RoadBnumber');" /></div>
														</div>
													</fieldset>
												</div>
											</div>
											<%' //tab1-1 %>

											<%' tab1-2 동(읍/면) + 지번 %>
											<div id="tabcont1-2" class="tabcont">
												<h3 class="hidden">동(읍/면) + 지번</h3>

												<%' 검색 %>
												<div class="finder" id="RoadBjibunfinder">
													<fieldset>
														<legend>동(읍/면) + 지번으로 우편번호 찾기</legend>
														<div class="help">
															<p>동(읍/면), 지번 입력 후 검색해주세요</p>
															<p class="ex">예) 동숭동(동) 1-45 (지번)</p>
														</div>

														<ul>
															<li>
																<label for="ctiy21">시/도</label>
																<select id="ctiy21" onchange="getgunguList(this.value, 'ctiy22')" class="frmSelectV16">
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
																<label for="ctiy22">시/군/구</label>
																<select id="ctiy22" class="frmSelectV16">
																	<option>시/군/구 선택</option>
																</select>
															</li>
															<li>
																<label for="town">동(읍/면)</label>
																<input type="text" id="DongRoadBjibun" class="frmInputV16" />
															</li>
															<li>
																<label for="addressno">지번</label>
																<input type="number" id="JibunRoadBjibun" onkeydown="javascript: if (event.keyCode == 13) {SubmitForm('RoadBjibun');}" class="frmInputV16" />
															</li>
														</ul>

														<div class="btnAreaV16a">
															<input type="submit" class="btnV16a btnRed2V16a btn02 btw" value="검색" onclick="SubmitForm('RoadBjibun');" />
														</div>
													</fieldset>

													<div class="reference">
														<p>도로명 주소 검색 결과가 없을 경우,<br /> 도로명 주소 안내시스템을 참고해주시길 바랍니다</p>
														<p><a href="http://www.juso.go.kr" target="_blank">http://www.juso.go.kr</a></p>
													</div>
												</div>

												<%' 검색결과 %>
												<div class="result" id="resultRoadBjibun" style="display:none;">
													<div class="help" id="RoadBjibunHelp">
														<p>아래 주소중 해당하는 주소를 선택해주세요</p>
													</div>

													<ul class="list" id="RoadBjibunaddrList"></ul>

													<!--<div class="btnAreaV16a">
														<a href="" class="btnV16a btRedBdr cRd1 btn02 cnclGry">이전</a>
													</div>-->
												</div>

												<%' 상세주소 입력 %>
												<div class="form" id="RoadBjibunDetail" style="display:none;">
													<fieldset>
														<legend>상세주소 입력</legend>
														<div class="help">
															<p>상세 주소를 입력해주세요</p>
														</div>

														<div class="address">
															<p><span id="RoadBjibunDetailTxt"></span> <span id="RoadBjibunJibunDetail"></span></p>
															<input type="text" title="상세주소 입력" placeholder="상세 주소를 입력해주세요" id="RoadBjibunDetailAddr2" onkeydown="javascript: if (event.keyCode == 13) {CopyZip('RoadBjibunDetailAddr2', 'RoadBjibun');}" class="frmInputV16" />
														</div>

														<div class="btnAreaV16a">
															<div class="half"><a href="" class="btnV16a btRedBdr cRd1 btn02 cnclGry" onclick="setBackAction('RoadBjibunDetail','resultRoadBjibun','RoadBjibunfinder');return false;">이전</a></div>
															<div class="half"><input type="submit" class="btnV16a btnRed2V16a btn02 btw" value="주소입력" onclick="CopyZip('RoadBjibunDetailAddr2', 'RoadBjibun');" /></div>
														</div>
													</fieldset>
												</div>
											</div>
											<%' //tab1-2 %>

											<%' tab1-3 건물명 %>
											<div id="tabcont1-3" class="tabcont">
												<h3 class="hidden">건물명</h3>

												<%' 검색 %>
												<div class="finder" id="RoadBnamefinder">
													<fieldset>
														<legend>건물명으로 우편번호 찾기</legend>
														<div class="help">
															<p>건물명을 입력 후 검색해주세요</p>
															<p class="ex">예) 자유빌딩 (건물번호)</p>
														</div>

														<ul>
															<li>
																<label for="ctiy31">시/도</label>
																<select id="ctiy31" onchange="getgunguList(this.value, 'ctiy32')" class="frmSelectV16">
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
																<label for="ctiy32">시/군/구</label>
																<select id="ctiy32" class="frmSelectV16">
																	<option>시/군/구 선택</option>
																</select>
															</li>
															<li>
																<label for="building">건물명</label>
																<input type="text" id="NameRoadBname" onkeydown="javascript: if (event.keyCode == 13) {SubmitForm('RoadBname');}" class="frmInputV16" />
															</li>
														</ul>

														<div class="btnAreaV16a">
															<input type="submit" class="btnV16a btnRed2V16a btn02 btw" value="검색" onclick="SubmitForm('RoadBname');" />
														</div>
													</fieldset>

													<div class="reference">
														<p>도로명 주소 검색 결과가 없을 경우,<br /> 도로명 주소 안내시스템을 참고해주시길 바랍니다</p>
														<p><a href="http://www.juso.go.kr" target="_blank">http://www.juso.go.kr</a></p>
													</div>
												</div>

												<%' 검색결과 %>
												<div class="result" id="resultRoadBname" style="display:none;">
													<div class="help" id="RoadBnameHelp">
														<p>아래 주소중 해당하는 주소를 선택해주세요</p>
													</div>

													<ul class="list" id="RoadBnameaddrList"></ul>

													<!--<div class="btnAreaV16a">
														<a href="" class="btnV16a btRedBdr cRd1 btn02 cnclGry">이전</a>
													</div>-->
												</div>

												<%' 상세주소 입력 %>
												<div class="form" id="RoadBnameDetail" style="display:none;">
													<fieldset>
														<legend>상세주소 입력</legend>
														<div class="help">
															<p>상세 주소를 입력해주세요</p>
														</div>

														<div class="address">
															<p><span id="RoadBnameDetailTxt"></span> <span id="RoadBnameJibunDetail"></span></p>
															<input type="text" title="상세주소 입력" placeholder="상세 주소를 입력해주세요" id="RoadBnameDetailAddr2" onkeydown="javascript: if (event.keyCode == 13) {CopyZip('RoadBnameDetailAddr2', 'RoadBname');}" class="frmInputV16" />
														</div>

														<div class="btnAreaV16a">
															<div class="half"><a href="" class="btnV16a btRedBdr cRd1 btn02 cnclGry" onclick="setBackAction('RoadBnameDetail','resultRoadBname','RoadBnamefinder');return false;">이전</a></div>
															<div class="half"><input type="submit" class="btnV16a btnRed2V16a btn02 btw" value="주소입력" onclick="CopyZip('RoadBnameDetailAddr2', 'RoadBname');" /></div>
														</div>
													</fieldset>
												</div>
											</div>
											<%' //tab1-3 %>
										</div>
									</div>
								</div>
								<%' //tab1 %>

								<%' tab2 지번 주소 %>
								<div id="tabcont2" class="tabcont">
									<h2 class="hidden">지번 주소</h2>

									<%' 검색 %>
									<div class="finder" id="Jibunfinder">
										<fieldset>
											<legend>동(읍/면)으로 우편번호 찾기</legend>
											<div class="help">
												<p>찾고 싶으신 주소의 동(읍/면)을 입력해주세요</p>
												<p class="ex">예) 동숭동, 역삼1동</p>
											</div>

											<div class="address">
												<div class="row">
													<label for="dong">통합검색</label>
													<input type="text" id="tJibundong" placeholder="종로구 동숭동 1-45" class="frmInputV16" onkeydown="javascript: if (event.keyCode == 13) {SubmitForm('jibun');}" />
												</div>
											</div>

											<div class="btnAreaV16a">
												<input type="submit" class="btnV16a btnRed2V16a btn02 btw" value="검색" onclick="SubmitForm('jibun');" />
											</div>
										</fieldset>
									</div>

									<%' 검색결과 %>
									<div class="result" id="resultJibun" style="display:none;">
										<div class="help">
											<p>아래 주소중 해당하는 주소를 선택해주세요</p>
											<span id="cautionTxtJibun"></span>
										</div>

										<p class="total" id="jibuntotalcntView"></p>

										<ul class="list" id="jibunaddrList"></ul>

										<!--<div class="btnAreaV16a">
											<a href="" class="btnV16a btRedBdr cRd1 btn02 cnclGry">이전</a>
										</div>-->
									</div>

									<%' 상세주소 입력 %>
									<div class="form" id="jibunDetail" style="display:none;">
										<fieldset>
											<legend>상세 주소 입력</legend>
											<div class="help">
												<p>상세 주소를 입력해주세요</p>
											</div>

											<div class="address">
												<p><div id="jibunDetailtxt"></div></p>
												<input type="text" title="상세주소 입력" id="jibunDetailAddr2" value="" placeholder="상세 주소를 입력해주세요" onkeydown="javascript: if (event.keyCode == 13) {CopyZip('jibunDetailAddr2', 'jibun');}" class="frmInputV16" />
											</div>

											<div class="btnAreaV16a">
												<div class="half"><a href="" class="btnV16a btRedBdr cRd1 btn02 cnclGry" onclick="setBackAction('jibunDetail','resultJibun','Jibunfinder');return false;">이전</a></div>
												<div class="half"><input type="submit" class="btnV16a btnRed2V16a btn02 btw" onclick="CopyZip('jibunDetailAddr2', 'jibun');" value="주소입력" /></div>
											</div>
										</fieldset>
									</div>
								</div>
								<!-- //tab2 -->
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<span class="lyrClose">&times;</span>
	</div>
	<div class="dimmed"></div>
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
<!-- //우편번호 찾기 레이어 팝업 -->

<!-- #include virtual="/lib/db/dbEVTclose.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->