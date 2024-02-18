<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
'	Description : 주소찾기 공용페이지
'	History	:  2014.01.08 한용민 생성
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
Dim strTarget, strQuery, strMode, stype, lp
	strTarget	= requestCheckVar(Request("target"),32)
	strQuery	= requestCheckVar(Request("query"),32)
	strMode     = requestCheckVar(Request("strMode"),32)
	stype		= requestCheckVar(Request("stype"),4)

if stype="" then stype="addr"

Dim strSql, nRowCount, strAddress, strAddress1, strAddress2, useraddr01, useraddr02, FRecultCount

	strSql = " [db_zipcode].[dbo].[usp_Ten_GetZipcodeList] '" + CStr(strQuery) + "', '" + CStr(stype) + "' "

    if (strQuery<>"") then
		FRecultCount = 0
    	'response.write strSQL &"<Br>"
        rsget.Open strSQL,dbget,1
		if Not rsget.Eof then
			FRecultCount = 1
		end if
    end if
%>

<script type="text/javascript">

function chgTab(dv) {
	if(dv=="a") {
		$("#kTab1").html('찾고 싶으신 주소의 동, 읍, 리, 면을 입력하세요. <br>(예 : 대치동, 곡성읍, 오곡면)');
		$("#kTab2").html('읍면동리');
		$("#tabroad").removeClass("active");
		$("#tabaddr").addClass("active");
		$("#stype").val("addr")
	} else {
		$("#kTab1").html('찾고 싶으신 주소의 도로명을 입력하세요. <br>(예 : 동숭1길, 세종대로)');
		$("#kTab2").html('도로명');
		$("#tabaddr").removeClass("active");
		$("#tabroad").addClass("active");
		$("#stype").val("road")
	}
}

function CopyZip(){
	var frm = eval("parent.<%= strTarget %>");
	var post1 = document.tranFrm.zip1.value;
	var post2 = document.tranFrm.zip2.value;
	var add = document.tranFrm.addr1.value;
	var dong = document.tranFrm.addr2.value;
	var detail = $("input[name='detail']").val();

	if (!$("input[name='zipcode']").is(":checked")){
		alert('주소를 선택해 주세요');
		return;
	}

	if (detail==""||!$("input[name='detail']").is(":visible")) {
		alert("상세주소를 입력해주세요.");
		//$("input[name='detail']").focus();
		return;
	}
	dong = dong +' '+ detail;

	<%
	Select Case strMode
		Case "userinfo"
	%>
		//주소입력
		frm.txZip1.value		= post1;
		frm.txZip2.value		= post2;
		frm.txAddr1.value		= add;
		frm.txAddr2.value		= dong;
	<%
		CASE  "MyAddress"
	%>
		frm.zip1.value		= post1;
		frm.zip2.value		= post2;
		frm.reqZipaddr.value		= add;
		frm.reqAddress.value		= dong;
	<% Case "appcheck1" %>
		frm.buyZip1.value		= post1;
		frm.buyZip2.value		= post2;
		frm.buyAddr1.value		= add;
		frm.buyAddr2.value		= dong;
	<% Case "appcheck2" %>
		frm.txZip1.value		= post1;
		frm.txZip2.value		= post2;
		frm.txAddr1.value		= add;
		frm.txAddr2.value		= dong;
	<% Case Else %>
		frm.txZip1.value		= post1;
		frm.txZip2.value		= post2;
		frm.txAddr1.value		= add;
		frm.txAddr2.value		= dong;
	<% End Select %>

	// 모달 Close;
	$("#modalCont").fadeOut(function(){
		$(this).empty();
	});
	$('body').css({'overflow':'auto'});
	clearInterval(loop);
	loop = null;
}

// 2nd 상세정보 입력폼 표시
function DetailPost(elm) {
	$(".addDetail").remove();
	$(elm).parent().parent().find('input[name="zipcode"]').attr('checked',true);
	document.tranFrm.zip1.value=$("input[name='zipcode']:checked").attr("selZip1");
	document.tranFrm.zip2.value=$("input[name='zipcode']:checked").attr("selZip2");
	document.tranFrm.addr1.value=$("input[name='zipcode']:checked").attr("selAdr1");
	document.tranFrm.addr2.value=$("input[name='zipcode']:checked").attr("selAdr2");
	$(elm).parent().parent().after('<li class="addDetail" style="padding-left:50px;background:#F4F4F4"><table width="90%" style="height:40px;font-size:12px;"><tr><td width="60">상세주소</td><td><input type="text" name="detail" class="form alone" style="width:100%;" /></td></tr></table></li>');
	//$("input[name='detail']").focus();
}

function SubmitForm(frm){
	var tmpquery = frm.query.value;
	var tmpstype = $("#stype").val()

	if (tmpquery.length < 2) {
		alert("동 이름을 두글자 이상 입력하세요.");
		return;
	}

	//결과 레이어 재호출
	searchzipBuyer('/apps/appcom/wish/webview/lib/layer_searchzipNew.asp?strMode=<%= strMode %>&target=<%= strTarget %>&stype='+tmpstype+'&query='+encodeURI(tmpquery));
}
</SCRIPT>

<!-- modal#modalFindZipcode -->
<div class="modal" id="modalFindZipcode">
    <div style="position:relative; height:100%;">
    <div class="box find-zipcode">
        <header class="modal-header">
            <h1 class="modal-title">우편번호 찾기</h1>
            <a href="#modalFindZipcode" class="btn-close">&times;</a>
        </header>
        <div class="modal-body">
        	<div class="iscroll-area">
	            <div class="box-white">
	                <div class="tabs type-c">
	                    <a href="" onclick="chgTab('a'); return false;" id="tabaddr" class="<%=chkIIF(stype="addr","active","")%>"><span class="label">지번검색</span></a>
	                    <a href="" onclick="chgTab('r'); return false;" id="tabroad" class="<%=chkIIF(stype="road","active","")%>"><span class="label">도로명검색</span></a>
	                </div>
	            </div>
	            <form action="" method="get" name="gil" onsubmit="return false;">
				<input type="hidden" name="target"	value="<%=strTarget%>">
				<input type="hidden" name="strMode"	value="<%=strMode%>">
				<input type="hidden" name="stype" id="stype" value="<%=stype%>" >
	            <div class="find-zipcode-form">
	                <p id="kTab1" style="padding:5px 0;">
	                	<% if stype="addr" then %>
	                		찾고 싶으신 주소의 동, 읍, 리, 면을 입력하세요. <br>(예 : 대치동, 곡성읍, 오곡면)
	                	<% else %>
	                		찾고 싶으신 주소의 도로명을 입력하세요. <br>(예 : 동숭1길, 세종대로)
	                	<% end if %>
	                </p>
	                <div class="input-block no-label">
	                    <label id="kTab2" for="keyword" class="input-label">
		                	<% if stype="addr" then %>
		                		읍면동리
		                	<% else %>
		                		도로명
		                	<% end if %>
	                    </label>
	                    <div class="input-controls">
	                        <input type="text" class="form full-size" name="query" id="keyword">
	                        <button type="button" class="btn type-a side-btn" style="width:70px;" onclick="SubmitForm(document.gil);return false;">검색</button>
	                    </div>
	                </div>
	            </div>
            	</form>
            	<ul class="list type-a">
					<% if (FRecultCount>0) then %>
						<% if (not rsget.eof) then
						lp = 1
						do while (not rsget.EOF and nRowCount < rsget.PageSize)

							if stype="road" then
								'도로명주소
								strAddress = trim(rsget("ADDR_Fulltext")) & " " & trim( rsget("ADDR_BLDNO1"))
								if Not(rsget("ADDR_BLDNO2")="" or isNull(rsget("ADDR_BLDNO2"))) then
									strAddress = strAddress & " ~ " & trim(rsget("ADDR_BLDNO2"))
								end if

								useraddr01 = trim(rsget("ADDR_SI")) & " " & trim( rsget("ADDR_GU"))
								useraddr02 = trim( rsget("ADDR_ROAD"))
								if Not(rsget("ADDR_ETC")="" or isNull(rsget("ADDR_ETC"))) then
									'다량 배송처가 있는 곳은 단일 건물
									useraddr02 = useraddr02 & " " & trim(rsget("ADDR_BLDNO1")) & " " & trim(rsget("ADDR_ETC"))
								end if
								useraddr02 = trim(Replace(useraddr02,"'","\'"))
							else
								'지번주소
								strAddress = trim(rsget("ADDR_Fulltext"))

								useraddr01 = trim(rsget("ADDR_SI")) & " " & trim( rsget("ADDR_GU"))
								useraddr02 = trim( rsget("ADDR_DONG")) & " " & trim( rsget("ADDR_ETC"))
								useraddr02 = trim(Replace(useraddr02,"'","\'"))
							end if
						%>
			                <li>
			                    <label for="selzip<%=lp%>">
			                        <input type="radio" name="zipcode" id="selzip<%=lp%>" class="form type-c" selZip1="<%=rsget("ADDR_ZIP1")%>" selZip2="<%=rsget("ADDR_ZIP2")%>" selAdr1="<%=useraddr01%>" selAdr2="<%=useraddr02%>" onclick="DetailPost(this);">
			                        <span class="zipcode"><%=rsget("ADDR_zip1")%>-<%=rsget("ADDR_zip2")%></span>
			                        <span class="address"><%=strAddress%></span>
			                    </label>
			                </li>
						<%
							  rsget.MoveNext
							  lp = lp+1
							loop
							end if
							rsget.close
						%>
					<% else %>
						<li>
							<div class="no-data"><%=chkIIF(strQuery="","찾으시려는 검색어를 입력해주세요.","[" & strQuery & "]의 검색 결과가 없습니다.")%></div>
						</li>
					<% end if %>
	            </ul>
            </div>
        </div>
		<form name="tranFrm" style="margin:0px;">
		<input type="hidden" name="zip1" value="">
		<input type="hidden" name="zip2" value="">
		<input type="hidden" name="addr1" value="">
		<input type="hidden" name="addr2" value="">
		</form>
        <footer class="modal-footer">
            <a href="#modalFindZipcode" onclick="CopyZip(); return false;" class="btn type-b full-size">확인</a>
        </footer>
    </div>
    </div>
</div><!-- modal#modalFindZipcode -->

<!-- #include virtual="/lib/db/dbclose.asp" -->
