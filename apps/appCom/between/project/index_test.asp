<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
'History : 2014.06.09 김진영 생성
'Description :  비트윈 및 어드민에 등록한 기획전을 토큰 통신하지 않고 보기.
'index.asp에선 토큰통신 후에 기획전페이지를 오픈함으로써 웹브라우저에서 볼 수 없음..
%>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.Charset="UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/projectCls.asp" -->
<%
	Dim cProj, vUserID, vIdx, vGender, vSort, vGroupCode, vPage
	vIdx	= requestCheckVar(Request("pjt_code"),10)
	vPage	= 1
	
	'vUserID = "okkang777"
	'vIdx = "3"	'### MD PICK, 남자 텝여러개
	'vIdx = "4"	'### 결혼기념일, 여자 텝한개
	'vIdx = "6"	'### ETC 기획, 전체 탭없음
	'vIdx = "7"	'### ETC 기획, 전체 텝여러개
	
	If vIdx = "" Then
		Response.Write "<script>alert('잘못된 경로입니다.');</script>"
		dbget.close()
		Response.End
	Else
		If isNumeric(vIdx) = False Then
			Response.Write "<script>alert('잘못된 경로입니다.');</script>"
			dbget.close()
			Response.End
		End If
	End If
	
	vGroupCode = requestCheckVar(Request("pGC"),10)
	IF vGroupCode = "" THEN vGroupCode = 0
	
	Dim vPrjGender, vPrjImg, vPrjName, vArrGroup, intG, vPrjKind, vTopCount, vNoTab
	vNoTab = "x"
	SET cProj = New CProject
		cProj.FRectPCode = vIdx
		cProj.getOneProject
		
		vPrjGender	= cProj.FOneItem.FPGender
		vPrjImg		= cProj.FOneItem.FPTopImg
		vPrjName	= cProj.FOneItem.FPName
		vSort		= cProj.FOneItem.FPSortType
		vPrjKind	= cProj.FOneItem.FPKind
		
		'cProj.FRectPGCode = 
		vArrGroup = cProj.getProjectGroupList
		
		If UBound(vArrGroup,2) = 0 Then	'### 전체이고 텝없음 인경우 는 상품리스트만 나오므로 더보기가 나와야함.
			vNoTab = "o"
		End If
	SET cProj = Nothing

	'기획전에 엠디픽이면 배경이 회색으로 나와야함..2014-04-30 김진영 추가
	Dim isMdPick
	If vPrjKind = "I" Then
		isMdPick = true
	Else
		isMdPick = false
	End If
%>
<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
<script type="text/javascript">
function jsProjectItemList(){
	var pcnt = $("#pagecnt").val();
	pcnt = parseInt(pcnt)+1;
	$.ajax({
			url: "itemlist_ajax.asp?idx=<%=vIdx%>&sort=<%=vSort%>&gen=<%=vPrjGender%>&page="+pcnt+"",
			cache: false,
			success: function(message)
			{
				$("#betweenprojectitem").append(message);
				$("#pagecnt").val(pcnt);
			}
	});
}
</script>
</head>
<body>
<div class="wrapper" id="btwRcmd">
	<div id="content">
		<h1 class="noView">비트윈추천</h1>
		<div class="cont">
		<% If isMdPick  Then %>
			<div class="<%=CHKIIF(vPrjGender="M","targetM","targetF")%>">
		<% Else %>
			<div class="">
		<% End If %>
				<div class="bnrForTheme">
					<h2><img src="<%=vPrjImg%>" alt="<%=Replace(vPrjName,"""","")%>" /></h2>
				</div>

				<div class="pdtListWrap">
				<%
				IF isArray(vArrGroup) THEN
					vTopCount = 100
					'### 0:pjtgroup_code, 1:pjtgroup_desc, 2:pjtgroup_sort, 3:pjtgroup_BGColor, 4:pjtgroup_FontColor, 5:pjtgroup_pcode, 6:pjtgroup_depth, 7:pjtgroup_using, 8:regdate
					For intG = 1 To UBound(vArrGroup,2)
						vGroupCode = vArrGroup(0,intG)
				%>
					<h3 style="background-color:<%=vArrGroup(3,intG)%>; color:<%=vArrGroup(4,intG)%>;"><%=db2html(vArrGroup(1,intG))%></h3>
					<ul class="pdtList list03 boxMdl">
						<% sbEvtItemList %>
					</ul>
				<%
					Next
				End If

				If vNoTab = "o" Then
					vTopCount = 10
				%>
					<ul class="pdtList list03 boxMdl" id="betweenprojectitem">
						<% sbEvtItemList %>
					</ul>
					<div id="btnMoreList" class="listAddBtn">
						<input type="hidden" name="pagecnt" id="pagecnt" value="1">
						<a href="" onClick="jsProjectItemList(); return false;">상품 더 보기</a>
					</div>
				<%
				End If
				%>
				</div>
			</div>
		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->