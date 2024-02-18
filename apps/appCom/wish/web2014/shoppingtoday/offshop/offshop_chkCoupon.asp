<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	Dim sNid, sPsId, sUuid, sEvtNo, sqlStr, isList, sStat
	Dim dataExists : dataExists=false
	
	Dim evtStartDT : evtStartDT = "2021-11-22"
	Dim evtEndDT : evtEndDT		= "2021-12-31"
	if (application("Svr_Info")="Dev") then evtStartDT= "2019-07-30"
	    
	sNid = requestCheckVar(request("nid"),40)
	sPsId = requestCheckVar(request("pid"),512)
	sUuid = requestCheckVar(request("uid"),40)
	sEvtNo = requestCheckVar(request("eno"),8)

	isList = false 		'쿠폰 대상자 여부
	sStat = 0			'현재 쿠폰 상태 (1: 대기중, 2:사용완료, 3:만료)


	'// 파라메터 정보가 없으면 종료
	if sNid="" and sPsId="" and sUuid="" and sEvtNo="" then
		Response.Write "<script>alert('잘못된 접근입니다. 다시 시도해주세요.');fnAPPclosePopup();</script>"
		dbget.close: Response.End
	end if

	
	'// Step 2 - Nid에 대해서 설치 이력이 있는지 확인
	if sNid="00000000-0000-0000-0000-000000000000" then
	    sqlStr = "select min(regdate) as rdt from db_contents.dbo.tbl_app_NidInfo_CHK"
		sqlStr = sqlStr & "	where Nid='"&sNid&"'"
		sqlStr = sqlStr & " and uuid='" & sUuid & "'"
	else
	    sqlStr = "select min(regdate) as rdt from db_contents.dbo.tbl_app_NidInfo"
		sqlStr = sqlStr & "	where Nid='"&sNid&"'"
	end if
	
		rsget.CursorLocation = adUseClient
        rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly

		if not(isNull(rsget("rdt"))) then
		    dataExists = TRUE
		    
		    Select Case sEvtNo
	    	Case "1","3"
	    		'오프샾
				if datediff("h",rsget("rdt"),date)<=48 then isList = true
				if datediff("h",rsget("rdt"),now)<=24 then
					sStat = 1
				else
					sStat = 3
				end if
			Case "5"
				'BML 기간
				if datediff("D",evtStartDT,rsget("rdt"))>=0 and datediff("D",rsget("rdt"),evtEndDT)>=0 then
					isList = true
					sStat = 1
				else
					sStat = 3
				end if
			End Select
		end if
		rsget.Close	

    '// Step 1 - PushId에 대해 앱 설치 이력이 있는지 확인
	if not(isList) and (sPsId<>"") and not(dataExists) then
		sqlStr = "select min(regdate) as rdt from db_contents.dbo.tbl_app_regInfo"
		sqlStr = sqlStr & "	where  deviceid='"&sPsId&"'"

		rsget.CursorLocation = adUseClient
	    rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly
		if not(isNull(rsget("rdt"))) then
		    Select Case sEvtNo
	    	Case "1","3"
	    		'오프샾
				if datediff("h",rsget("rdt"),date)<=48 then isList = true
				if datediff("h",rsget("rdt"),now)<=24 then
					sStat = 1
				else
					sStat = 3
				end if
			Case "5"
				'BML 기간
				if datediff("D",evtStartDT,rsget("rdt"))>=0 and datediff("D",rsget("rdt"),evtEndDT)>=0 then
					isList = true
					sStat = 1
				else
					sStat = 3
				end if
			End Select
		end if
		rsget.Close
	end if


	'// Step 3 - 대상자일경우 쿠폰 유효성 확인
	sqlStr = "select min(regdate) as rdt from db_contents.dbo.tbl_app_offshop_inflow"
	sqlStr = sqlStr & "	where eventNo=" & sEvtNo & " and ("
	if sNid<>"" then sqlStr = sqlStr & " Nid='"&sNid&"' or"
	if sUuid<>"" then sqlStr = sqlStr & " uuid='"&sUuid&"' or"
	if sPsId<>"" then sqlStr = sqlStr & " deviceid='"&sPsId&"' or"
    sqlStr = LEFT(sqlStr,LEN(sqlStr)-3)
	sqlStr = sqlStr & ")"

	rsget.CursorLocation = adUseClient
    rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly
	if not(isNull(rsget("rdt"))) then
		if datediff("d",rsget("rdt"),date)>=7 then
			isList = false		'// 7일 이후에는 표시안함
		else
			isList = true		'// 7일 이내 등록한 쿠폰이 있는 경우 출력
			sStat = 2			'// 등록된 쿠폰정보가 있으므로 사용 완료
		end if
	end if
	rsget.Close	

'' TEST
'isList = true
'sStat = 1
'sNid = ""
'sPsId = "1ce68cb90201b138d4b6592a72c683b25659cdc51a4cfb14c53cbcb82c8ecd8a"
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type="text/javascript" src="/lib/js/jquery.form.min.js"></script>
<script type="text/javascript">
//저장
function jsConfirm() {
    $('#frmCpn').ajaxSubmit({
        //보내기전 validation check가 필요할경우
        beforeSubmit: function (data, frm, opt) {
            if(frm[0].cpnCd.value.length<5) {
            	alert("쿠폰 코드를 입력해주세요.");
            	return false;
            }
            if(frm[0].cpnCd.value=="10000") {
            	alert("쿠폰 코드가 일치하지 않습니다.(C00)");
            	return false;
            }
        },
        //submit이후의 처리
        success: function(responseText, statusText){
            var resultObj = JSON.parse(responseText)

            if(resultObj.response=="fail") {
                alert(resultObj.faildesc);
            } else if(resultObj.response=="ok") {
				// 처리 성공
				fnAPPopenerJsCallClose("location.reload()");
            } else {
                alert("처리중 오류가 발생했습니다.\n" + responseText);
            }
        },
        //ajax error
        error: function(err){
            alert("ERR: " + err.responseText);
        }
    });
}

//maxlength 체크
function maxLengthCheck(obj){
	if (obj.value.length > obj.maxLength){
		obj.value = obj.value.slice(0, obj.maxLength);
	}    
}

$(function(){
	document.frm.cpnCd.focus();
});
</script>
</head>
<body>
<div class="heightGrid bgGry">
	<div class="container popWin">
		<!-- content area -->
		<div class="content bgGry" id="contentArea">
			<!-- form -->
			<div class="form formCodeV17">
				<form id="frmCpn" name="frm" method="POST" action="act_couponProc.asp">
					<fieldset>
					<input type="hidden" name="nid" value="<%=sNid%>" />
					<input type="hidden" name="pid" value="<%=sPsId%>" />
					<input type="hidden" name="uid" value="<%=sUuid%>" />
					<input type="hidden" name="eno" value="<%=sEvtNo%>" />
					<legend class="hidden">쿠폰 코드 입력 폼</legend>
						<input type="number" name="cpnCd" title="쿠폰코드 다섯자리 입력" pattern="[0-9]*" inputmode="numeric" value="" min="0" max="99999"  maxlength="5" style="-webkit-text-security: disc;" oninput="maxLengthCheck(this)" <%=chkIIF(isList and sStat=1,"","disabled=""disabled""")%> autofocus />
						<% if sStat=1 then %>
						<button type="button" class="button cWh1" onclick="jsConfirm();">쿠폰 사용하기</button>
						<% elseif sStat=2 then %>
						<button type="button" class="button btnRed cWh1" onclick="alert('이미 사용하셨습니다.');">쿠폰 사용하기</button>
						<% else %>
						<button type="button" class="button cWh1 disabled" onclick="alert('기간이 만료되었습니다.');">쿠폰 사용하기</button>
						<% end if %>
					</fieldset>
				</form>
			</div>

			<div class="list listBulletHypen">
				<ul>
				<%
				    Select Case sEvtNo
			    	Case "1"
			    		'오프샾
				%>
					<li>해당 쿠폰은 전국 텐바이텐 오프라인 매장에서만 사용이 가능합니다.</li>
					<li>쿠폰 사용은 계산할 때 매장 직원이 쿠폰 코드를 입력하여 사용하며, 1회만 사용 가능합니다.</li>
					<li>본 이벤트는 쿠폰 사용하고 7일뒤 또는 쿠폰 기간 만료 1일 뒤에 이벤트 목록에서 자동 삭제됩니다.</li>
				<%
					Case "2"
						'아트토이 기간
				%>
					<li>해당 이벤트는 아트토이컬쳐 텐바이텐 부스에서만 사용이 가능합니다. ( 코엑스 Hall B)</li>
					<li>사은품은 사용기간 동안 매일 선착순 300명에게 지급됩니다. (1인 1회 지급)</li>
					<li>본 이벤트는 사은품을 지급하고 7일뒤 또는 이벤트 종료 후 1일 뒤에 이벤트 목록에서 자동 삭제됩니다.</li>
				<%
					Case "3"
						'오프샵 사은품 이벤트
				%>
					<li>해당 쿠폰은 텐바이텐 대학로 매장에서만 사용이 가능합니다.</li>
					<li>쿠폰 사용은 매장 직원이 쿠폰 코드를 입력하여 참여 가능하며, 1회만 사용 가능합니다.</li>
					<li>본 이벤트는 쿠폰 사용하고 7일뒤 또는 쿠폰 기간 만료 1일 뒤에 이벤트 목록에서 자동 삭제됩니다</li>
				<%
					Case "4"
						'신촌 물총축제
				%>
					<li>해당 쿠폰은 신촌물총축제 텐바이텐 부스에서만 사용이 가능합니다.</li>
					<li>쿠폰 사용은 매장 직원이 쿠폰 코드를 입력하여 참여 가능하며, 1회만 사용 가능합니다.</li>
					<li>본 이벤트는 쿠폰 사용하고 7일뒤 또는 쿠폰 기간 만료 1일 뒤에 이벤트 목록에서 자동 삭제됩니다</li>
				<%
					Case "5"
						'2018 BML
				%>
					<li>해당 쿠폰은 BML 텐바이텐 부스에서만 사용이 가능합니다.</li>
					<li>쿠폰 사용은 매장 직원이 쿠폰 코드를 입력하여 참여 가능하며, 1회만 사용 가능합니다.</li>
					<li>본 이벤트는 쿠폰 사용하고 7일뒤 또는 쿠폰 기간 만료 1일 뒤에 이벤트 목록에서 자동 삭제됩니다</li>
				<%
					End Select
				%>
				</ul>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->