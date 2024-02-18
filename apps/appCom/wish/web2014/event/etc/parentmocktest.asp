<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/util/tenSessionLib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
'####################################################
' Description :  제 2회 부모님 모의고사
' History : 2019-04-29 원승현 
'          2020-04-22 정태훈
'####################################################

dim eCode, userid, currenttime, several
IF application("Svr_Info") = "Dev" THEN
	eCode = "102151"
    several=2 '회차 정보
Else
	eCode = "102078"
    several=2
End If

currenttime = now()
userid = GetEncLoginUserID()

Dim vQuery, examCheck, masterIdx
Dim userNm, parentNm, parentAge, sltvalue, sltyear, sltmonth, sltday, blood, clothsize, footsize, fafood, fadrama, facolor, fahobby, faentertainer
examCheck = FALSE
'// 해당 이벤트를 참여했는지 확인한다.
vQuery = "SELECT idx, userid, userName, parentName FROM [db_temp].[dbo].[tbl_event_parentdayexam_master] WITH (NOLOCK) WHERE several=" & several & " and userid = '" & userid & "' "
rsget.CursorLocation = adUseClient
rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
IF Not rsget.Eof Then
    examCheck = TRUE
    userNm = rsget("userName")
    parentNm = rsget("parentName")
    masterIdx = rsget("idx")
End If
rsget.close
Dim c1Result, c2Result, c3Result, c4Result, c5Result, c6Result, c7Result, c8Result, c9Result, c10Result
If examCheck Then
    vQuery = "SELECT idx, masterIdx, userid, questionNumber, Answer, ISNULL(marking,'') as marking FROM [db_temp].[dbo].[tbl_event_parentdayexam_detail] WITH (NOLOCK) WHERE userid = '" & userid & "' And masterIdx ='"&masterIdx&"' "
    rsget.CursorLocation = adUseClient
    rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
    IF Not rsget.Eof Then
        do until rsget.Eof
            If Trim(rsget("questionNumber")) = 1 Then
                parentAge = rsget("answer")
                c1Result = rsget("marking")
            End If
            If Trim(rsget("questionNumber")) = 2 Then
                sltvalue = split(rsget("answer"),"-")(0)
                sltyear = split(rsget("answer"),"-")(1)
                sltmonth = split(rsget("answer"),"-")(2)
                sltday = split(rsget("answer"),"-")(3)
                c2Result = rsget("marking")
            End If
            If Trim(rsget("questionNumber")) = 3 Then
                blood = rsget("answer")
                c3Result = rsget("marking")
            End If
            If Trim(rsget("questionNumber")) = 4 Then
                clothsize = rsget("answer")
                c4Result = rsget("marking")
            End If
            If Trim(rsget("questionNumber")) = 5 Then
                footsize = rsget("answer")
                c5Result = rsget("marking")
            End If
            If Trim(rsget("questionNumber")) = 6 Then
                fafood = rsget("answer")
                c6Result = rsget("marking")
            End If
            If Trim(rsget("questionNumber")) = 7 Then
                fadrama = rsget("answer")
                c7Result = rsget("marking")
            End If
            If Trim(rsget("questionNumber")) = 8 Then
                facolor = rsget("answer")
                c8Result = rsget("marking")
            End If
            If Trim(rsget("questionNumber")) = 9 Then
                fahobby = rsget("answer")
                c9Result = rsget("marking")
            End If
            If Trim(rsget("questionNumber")) = 10 Then
                faentertainer = rsget("answer")
                c10Result = rsget("marking")
            End If
        rsget.movenext
        loop
    End If
    rsget.close
End If

'// 전체 채점이 됐다면 result 페이지로 이동 시킨다.
If Trim(c1Result) <> "" And Trim(c2Result) <> "" And Trim(c3Result) <> "" And Trim(c4Result) <> "" And Trim(c5Result) <> "" And Trim(c6Result) <> "" And Trim(c7Result) <> "" And Trim(c8Result) <> "" And Trim(c9Result) <> "" And Trim(c10Result) <> "" Then
    Response.redirect "/apps/appCom/wish/web2014/event/etc/parentgraderesult.asp?userid="&Server.URLEncode(tenEnc(userid))
    response.end
End If

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = " [부모님 모의고사]"
Dim kakaodescription : kakaodescription = "안녕하세요 부모님! 지금 자녀분께서 [부모님 모의고사]를 풀었습니다. 알맞게 잘 풀었는지 채점해주세요!"
Dim kakaooldver : kakaooldver = "안녕하세요 부모님! 지금 자녀분께서 [부모님 모의고사]를 풀었습니다. 알맞게 잘 풀었는지 채점해주세요!"
Dim kakaoimage : kakaoimage = "https://webimage.10x10.co.kr/fixevent/event/2020/102078/m/img_kakao.jpg"
Dim kakaolink_url 
If isapp = "1" Then '앱일경우
    kakaolink_url = "https://m.10x10.co.kr/event/etc/parentgrade.asp?userid="&Server.URLEncode(tenEnc(userid))
Else '앱이 아닐경우
    kakaolink_url = "https://m.10x10.co.kr/event/etc/parentgrade.asp?userid="&Server.URLEncode(tenEnc(userid))
End IF
%>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/1.7.1/clipboard.min.js"></script>
<script>
    $(function(){
        fnAPPchangPopCaption('이벤트');
        // select
        $(".mEvt102078 select").on({
            'click, focus' : function(){
                $(this).addClass('on');
            }
        });
        // 약관 popup
        $(".btn-terms").click(function(){
            $(".lyr-terms").show();
            return false;
        });
        $(".lyr-terms .btn-close").click(function(){
            $(".lyr-terms").hide();
        });

        <% If examCheck Then %>
            $(".lyr-ing").show();
        <% Else %>
            $(".lyr-ing").hide();
        <% End If %>        
    });
    function saveAnswerParent() {
	    <% If IsUserLoginOK() Then %>
            if ($("#userNm").val()=="") {
                alert("작성자 이름을 입력해주세요.");
                $("#userNm").focus();
                return false;
            }
            if ($("#parentNm").val()=="") {
                alert("부모님 성함을 입력해주세요.");
                $("#parentNm").focus();
                return false;
            }
            if ($("#parentAge").val()=="") {
                alert("부모님 연세를 입력해주세요.");
                $("#parentAge").focus();
                return false;
            }
            if ($("#sltvalue").val()=="") {
                alert("부모님 생년월일을 입력해주세요.");
                return false;
            }
            if ($("#sltyear").val()=="") {
                alert("부모님 생년월일을 입력해주세요.");
                $("#sltyear").focus();
                return false;
            }
            if ($("#sltmonth").val()=="") {
                alert("부모님 생년월일을 입력해주세요.");
                $("#sltmonth").focus();
                return false;
            }
            if ($("#sltday").val()=="") {
                alert("부모님 생년월일을 입력해주세요.");
                $("#sltday").focus();
                return false;
            }
            if ($("#clothsize").val()=="") {
                alert("부모님 옷 사이즈를 입력해주세요.");
                $("#clothsize").focus();
                return false;
            }
            if ($("#footsize").val()=="") {
                alert("부모님 발 사이즈를 입력해주세요.");
                $("#footsize").focus();
                return false;
            }
            if ($("#fafood").val()=="") {
                alert("부모님이 가장 좋아하시는 음식을 입력해주세요.");
                $("#fafood").focus();
                return false;
            }
            if ($("#fadrama").val()=="") {
                alert("부모님이 가장 좋아하시는 드라마를 입력해주세요.");
                $("#fadrama").focus();
                return false;
            }
            if ($("#facolor").val()=="") {
                alert("부모님이 좋아하시는 색상을 입력해주세요.");
                $("#facolor").focus();
                return false;
            }
            if ($("#fahobby").val()=="") {
                alert("부모님이 즐겨하시는 취미를 입력해주세요.");
                $("#fahobby").focus();
                return false;
            }
            if ($("#faentertainer").val()=="") {
                alert("부모님이 좋아하시는 연예인을 입력해주세요.");
                $("#faentertainer").focus();
                return false;
            }
            if (!$("input:checkbox[name='agree']").is(":checked")) {
                alert("개인정보수집에 동의해 주세요.");
                return false;
            }
            if(confirm("답변을 저장하시면 수정이 불가합니다.\n저장하시겠습니까?")){
                $.ajax({
                    type:"POST",
                    url:"/event/etc/doparentmocktest.asp",
                    data: $("#frmparent").serialize(),
                    dataType: "text",
                    async:false,
                    cache:true,
                    success : function(Data, textStatus, jqXHR){
                        if (jqXHR.readyState == 4) {
                            if (jqXHR.status == 200) {
                                if(Data!="") {
                                    res = Data.split("|");
                                    if (res[0]=="OK")
                                    {
                                        $('.btn-save').hide();
                                        //$(".lyr-ing").show();
                                        $(".lyr-save").show();
                                        $(".step2").show();
                                        return false;
                                    }
                                    else
                                    {
                                        errorMsg = res[1].replace(">?n", "\n");
                                        alert(errorMsg);
                                        return false;
                                    }
                                } else {
                                    alert("잘못된 접근 입니다.");
                                    parent.location.reload();
                                    return false;
                                }
                            }
                        }
                    },
                    error:function(jqXHR, textStatus, errorThrown){
                        alert("잘못된 접근 입니다.");
                        <% if false then %>
                            //var str;
                            //for(var i in jqXHR)
                            //{
                            //	 if(jqXHR.hasOwnProperty(i))
                            //	{
                            //		str += jqXHR[i];
                            //	}
                            //}
                            //alert(str);
                        <% end if %>
                        return false;
                    }
                });
            }
            else {
                return false;
            }    
        <% Else %>
            <% if isApp=1 then %>
                parent.calllogin();
                return false;
            <% else %>
                parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
                return false;
            <% end if %>
        <% End If %>
    }
    function copyUrlSend(gb) {
        <% If IsUserLoginOK() Then %>
            $.ajax({
                type:"GET",
                url:"/event/etc/doparentmocktest.asp?mode=urlcopycheck",
                dataType: "text",
                async:false,
                cache:true,
                success : function(Data, textStatus, jqXHR){
                    if (jqXHR.readyState == 4) {
                        if (jqXHR.status == 200) {
                            if(Data!="") {
                                res = Data.split("|");
                                if (res[0]=="OK")
                                {
                                    if (gb=="kakao") {
                                        <% if isapp then %>
                                            event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaolink_url%>' );
                                        <% else %>
                                            event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaolink_url%>' );
                                        <% end if %>
                                    } else {
                                        var clipboard = new Clipboard('.urlcopyclip');
                                        clipboard.on('success', function(e) {
                                            alert('링크 복사가 완료되었습니다.');
                                            console.log(e);
                                        });
                                        clipboard.on('error', function(e) {
                                            console.log(e);
                                        });
                                    }
                                }
                                else
                                {
                                    errorMsg = res[1].replace(">?n", "\n");
                                    alert(errorMsg);
                                    return false;
                                }
                            } else {
                                alert("잘못된 접근 입니다.");
                                parent.location.reload();
                                return false;
                            }
                        }
                    }
                },
                error:function(jqXHR, textStatus, errorThrown){
                    alert("잘못된 접근 입니다.");
                    <% if false then %>
                        //var str;
                        //for(var i in jqXHR)
                        //{
                        //	 if(jqXHR.hasOwnProperty(i))
                        //	{
                        //		str += jqXHR[i];
                        //	}
                        //}
                        //alert(str);
                    <% end if %>
                    return false;
                }
            });
        <% Else %>
            <% if isApp=1 then %>
                parent.calllogin();
                return false;
            <% else %>
                parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
                return false;
            <% end if %>
        <% End If %>
    }

	//카카오 SNS 공유 v2.0
	function event_sendkakao(label , description , imageurl , linkurl){	
        Kakao.init('c967f6e67b0492478080bcf386390fdd');
		Kakao.Link.sendDefault({
			objectType: 'feed',
			content: {
				title: label,
				description : description,
				imageUrl: imageurl,
				link: {
				mobileWebUrl: linkurl
				}
			},
			buttons: [
				{
				title: '웹으로 보기',
				link: {
					mobileWebUrl: linkurl
				}
				}
			]
		});
    }
    
    function parentMockTestLoginCheck() {
        <% If Not(IsUserLoginOK()) Then %>
            <% if isApp=1 then %>
                parent.calllogin();
                return false;
            <% else %>
                parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
                return false;
            <% end if %>
        <% End If %>
    }
</script>
<style type="text/css">
.mEvt102078 button {width:100%; background:transparent;}
.mEvt102078 input[type=text],
.mEvt102078 input[type=number],
.mEvt102078 select {display:block; padding:0 .8rem; height:4.5vh; font-size:4.2vw;  font-family:'CoreSansCRegular','NotoSansKRRegular'; letter-spacing:-0.02rem; border:0; background-color:transparent; border-radius:0;}
.mEvt102078 select.on {color:#000;}
.mEvt102078 input::placeholder {line-height:1.6;}
.mEvt102078 .lyr-inner {position:relative; top:50%; transform:translateY(-60%);}
.topic {position:relative;}	
.topic h2 img {position:absolute; left:0; width:100%; top:21.12%; animation:ani1 1.2s both;}
.topic h2 img:nth-child(2) {top:29%; animation-delay:.4s;}
.topic h2 img:nth-child(3) {top:45.57%; animation-delay:.6s;}
.mock-test {position:relative; padding-bottom:5.12rem; background:#ffdb73 url(//webimage.10x10.co.kr/fixevent/event/2020/102078/m/bg_base.png?v=2) repeat-x 0 0 / 3.6% auto;}
.test-inner {width:88%; margin:0 auto; background:url(//webimage.10x10.co.kr/fixevent/event/2020/102078/m/bg_paper.png?v=2) repeat 0 0 / 100% auto; box-shadow:0 1.32rem 2.176rem rgba(144,79,47,.2);}
.deco div {position:absolute;}
.deco .d1 {right:0; top:14%; width:18.4%;}
.deco .d2 {right:0; top:39%; width:16.53%;}
.deco .d3 {left:0; top:57%; width:11.33%;}
.deco .d4 {left:0; top:87%; width:11.2%;}
.deco .d5 {right:0; top:85%; width:12.4%;}
.deco .d6 {width:12.93%;}
.step {width:85.8%; margin:0 auto; padding-bottom:4.7rem;}
.step1 .name {position:relative;}
.step1 .name input {position:absolute; left:35%; top:27%; width:61%; height:45%; padding:0; color:#000;}
.step1 li {padding-bottom:5vh;}
.step1 li > img {display:inline-block; margin-bottom:1vh;}
.step1 li input[type=text],
.step1 li input[type=number]  {width:65%; color:#000; border-bottom:1px solid #767676;}
.step1 input[type=radio] {position:relative; border-color:#a5a4a0; background-image:none; background:#fff; border-radius:50%;}
.step1 input[type=radio]:checked {border:0; background:#e04a4a;}
.step1 input[type=radio]:checked:after {content:''; position:absolute; left:50%; top:50%; width:44%; height:44%; margin:-22% 0 0 -22%; background:#fff; border-radius:50%;}
.step1 li .flex {display:flex; margin-top:1vh;}
.step1 li .flex label {width:25%;}
.step1 li .flex label img {width:46%; margin-left:.5rem; vertical-align:middle;}
.step1 li .flex input:nth-child(2) {margin:0 1.1rem;}
.step1 li.q1 input[type=text] {padding-right:12%; background:url(//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q1_1.png) no-repeat 95% 50% / auto 50%; }
.step1 li.q2 img {width:34%; margin-bottom:0; vertical-align:middle;}
.step1 li.q2 select {display:inline-block; width:29.8%; border-bottom:1px solid #767676; background:transparent url(//webimage.10x10.co.kr/fixevent/event/2019/94152/m/ico_arr.png) 95% 50% no-repeat; background-size:0.64rem;}
.step1 li.q3 .flex {padding:0 .8rem;}
.step1 li.q5 input[type=text] {padding-right:12%; background:url(//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q5_1.png) no-repeat 95% 50% / auto 50%; }
.step1 .terms {position:relative; width:108%; margin-left:-4%;}
.step1 .terms .btn-terms {display:block; position:absolute; left:5%; bottom:30%; width:90%; height:20%; font-size:0; color:transparent;}
.step1 .terms .lyr-terms {position:fixed; left:0; top:0; z-index:30; width:100vw; height:100vh; padding:0 6%; background:rgba(0,0,0,.6);}
.step1 .terms .btn-detail {position:absolute; right:14%; bottom:5%; width:21%; height:5%; font-size:0; color:transparent;}
.step1 .terms .btn-close {position:absolute; right:1%; top:-12%; width:10.15%;}
.step1 .terms label {position:absolute; left:30.16%; bottom:9%; width:39.16%; height:15%; font-size:0; color:transparent;}
.step1 .terms input[type=checkbox] {position:relative; width:20.3%; height:100%; border:0; background:transparent;}
.step1 .terms input[type=checkbox]:checked:after {content:''; position:absolute; left:8%; top:13%; width:100%; height:150%; background:url(//webimage.10x10.co.kr/fixevent/event/2020/102078/m/ico_check.png) no-repeat 0 0 / 100% auto; }
.step1 .lyr-save {position:fixed; left:0; top:0; z-index:30; width:100vw; height:100vh; padding:0 6%; background:rgba(0,0,0,.6);}
.step2 button:last-child {margin-top:.85rem;}
.lyr-save  button {position:absolute; font-size:0; color:transparent;}
.lyr-save .share button {left:5%; bottom:38%; width:90%; height:22%;}
.lyr-save .share button:last-child {bottom:12.5%;}
.lyr-save .btn-close {right:0; top:0; width:20%; height:16%;}
.lyr-ing {position:fixed; left:0; top:0; z-index:30; width:100vw; height:100vh; padding:0 6%; background:rgba(0,0,0,.6);}
.step2,
.lyr-ing,
.step1 .terms .lyr-terms,
.step1 .lyr-save {display:none;}
@media all and (min-width:480px){
	.mEvt102078 .lyr-inner {transform:translateY(-50%);}
	.step1 .terms .lyr-terms {padding:0 12%;}
}	
@keyframes ani1 {
	from {transform:translateY(.8rem); opacity:0;}
	to {transform:translateY(0); opacity:1;}
}
</style>
			<%' mEvt102078 부모님 모의고사 %>
			<div class="mEvt102078">
				<div class="topic">
					<h2>
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/tit1.png" alt="제 2회 부모님 모의고사">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/tit2.png" alt="">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/tit3.png" alt="">
					</h2>
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_copy.png" alt="내가 좋아하는 음식까지 알고 계시는 부모님. 나는 부모님에 대해 얼마나 알고 있나요? 문제를 풀고 부모님께 채점을 받아보세요!"></p>
				</div>
				<div class="mock-test">
					<div class="deco">
						<div class="d1"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/bg_deco1.png" alt=""></div>
						<div class="d2"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/bg_deco2.png" alt=""></div>
						<div class="d3"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/bg_deco3.png" alt=""></div>
						<div class="d4"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/bg_deco4.png" alt=""></div>
						<div class="d5"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/bg_deco5.png" alt=""></div>
					</div>
					<div class="test-inner">
						<form method="post" name="frmparent" id="frmparent">
                        <input type="hidden" name="mode" value="mocktest">
						<!-- STEP1. 문제풀이 -->
						<div class="step step1">
							<div class="quiz">
								<div class="name">
									<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_name.png" alt="작성자">
									<input type="text" name="userNm" id="userNm" value="<%=userNm%>" placeholder="본인 이름을 작성해주세요" onclick="parentMockTestLoginCheck();">
								</div>
								<h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/tit_step1.png" alt="부모님에 대해 얼마큼 알고 있나요?"></h3>
								<ol>
									<li class="q0">
										<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q0.png" alt="부모님 성함">
										<input type="text" name="parentNm" id="parentNm" value="<%=parentNm%>" placeholder="부모님 성함 작성">
									</li>
									<li class="q1">
										<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q1.png" alt="연세">
										<input type="number" name="parentAge" id="parentAge" value="<%=parentAge%>" placeholder="숫자만 입력">
									</li>
									<li class="q2">
										<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q2.png" alt="생년월일">
										<select name="sltvalue" id="sltvalue">
											<option>양력</option>
											<option>음력</option>
										</select>
										<div class="flex">
											<input type="number" name="sltyear" id="sltyear" value="<%=sltyear%>" placeholder="YYYY">
											<input type="number" name="sltmonth" id="sltmonth"  value="<%=sltmonth%>" placeholder="MM">
											<input type="number" name="sltday" id="sltday"  value="<%=sltday%>" placeholder="DD">
										</div>
									</li>
									<li class="q3">
										<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q3.png" alt="혈액형">
										<div class="flex">
											<label for="typeA"><input type="radio" name="blood" id="blood-a" value="A" <% If blood="" or blood="A" Then %>checked<% End If %>><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q3_1.png" alt="A형"></label>
											<label for="typeB"><input type="radio" name="blood" id="blood-b" value="B" <% If blood="B" Then %>checked<% End If %>><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q3_2.png" alt="B형"></label>
											<label for="typeO"><input type="radio" name="blood" id="blood-o" value="O" <% If blood="O" Then %>checked<% End If %>><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q3_3.png" alt="O형"></label>
											<label for="typeAB"><input type="radio" name="blood" id="blood-ab" value="AB" <% If blood="AB" Then %>checked<% End If %>><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q3_4.png" alt="AB형"></label>
										</div>
									</li>
									<li class="q4">
										<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q4.png" alt="옷 사이즈">
										<input type="text" name="clothsize" id="clothsize" value="<%=clothsize%>" placeholder="사이즈 입력">
									</li>
									<li class="q5">
										<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q5.png" alt="발 사이즈">
										<input type="number" name="footsize" id="footsize" value="<%=footsize%>" placeholder="숫자만 입력">
									</li>
									<li class="q6">
										<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q6.png" alt="가장 좋아하는 음식">
										<input type="text" name="fafood" id="fafood" value="<%=fafood%>" placeholder="좋아하시는 음식 입력">
									</li>
									<li class="q7">
										<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q7.png" alt="요새 즐겨보시는 드라마">
										<input type="text" name="fadrama" id="fadrama" value="<%=fadrama%>" placeholder="즐겨보시는 드라마 입력">
									</li>
									<li class="q8">
										<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q8.png" alt="좋아하시는 색상">
										<input type="text" name="facolor" id="facolor" value="<%=facolor%>" placeholder="좋아하시는 색상 입력">
									</li>
									<li class="q9">
										<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q9.png" alt="즐겨하시는 취미">
										<input type="text" name="fahobby" id="fahobby" value="<%=fahobby%>" placeholder="즐겨하시는 취미 입력">
									</li>
									<li class="q10">
										<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_q10.png" alt="좋아하시는 연예인">
										<input type="text" name="faentertainer" id="faentertainer" value="<%=faentertainer%>" placeholder="좋아하시는 연예인 입력">
									</li>
								</ol>
								<!-- 개인정보수집 동의 -->
								<div class="terms">
									<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_agree.png?v=2" alt=""></p>
									<button class="btn-terms">정보수집 항목 확인</button>
									<div class="lyr-terms">
										<div class="lyr-inner">
											<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/94152/m/txt_terms.png" alt="개인정보약관"></p>
											<a href="#" class="btn-detail mWeb" onclick="fnOpenModal('/common/pop_private.asp');return false;">자세히보기</a>
											<a href="#" class="btn-detail mApp" onclick="fnAPPpopupBrowserURL('개인정보처리방침','http://m.10x10.co.kr/apps/appcom/wish/web2014//member/pop_viewPrivateTerms.asp','right','','sc');return false;">자세히보기</a>
											<button class="btn-close"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/btn_close.png" alt="닫기"></button>
										</div>
									</div>
									<label for="agree"><input type="checkbox" name="agree" id="agree">예, 동의합니다</label>
								</div>

								<button class="btn-save" onclick="saveAnswerParent();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/btn_save.png?v=2" alt="답변 저장하기"></button>
								<div class="lyr-save">
									<div class="lyr-inner">
										<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_save.png" alt="답변 저장 완료! 부모님께 답안지를 공유해주세요"></p>
										<button class="btn-close">닫기</button>
										<div class="share">
											<button onclick="copyUrlSend('kakao');return false;">카카오톡으로 보내기</button>
											<button onclick="copyUrlSend('urlcopy');return false;" class="urlcopyclip" data-clipboard-text="https://m.10x10.co.kr/event/etc/parentgrade.asp?userid=<%=Server.URLEncode(tenEnc(userid))%>">링크 복사해서 보내기</button>
										</div>
									</div>
								</div>
							</div>
						</div>
                        </form>
						<%' STEP2. 공유하고 채점받기(답변 저장 후 노출) %>
						<div class="step step2">
							<h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/tit_step2.png" alt="부모님에게 페이지를 공유해서 채점을 받아보세요!"></h3>
							<button onclick="copyUrlSend('kakao');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/btn_send_kakao.png" alt="카카오톡으로 보내기"></button>
							<button onclick="copyUrlSend('urlcopy');return false;" class="urlcopyclip" data-clipboard-text="https://m.10x10.co.kr/event/etc/parentgrade.asp?userid=<%=Server.URLEncode(tenEnc(userid))%>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/btn_send_url.png" alt="링크 복사해서 보내기"></button>
						</div>
						<%' 채점중(부모님 채점 완료전 노출) %>
						<style>
						.lyr-ing  button {position:absolute; font-size:0; color:transparent;}
						.lyr-ing .share button {left:5%; bottom:32%; width:90%; height:18%;}
						.lyr-ing .share button:last-child {bottom:10.5%;}
						</style>
						<div class="lyr-ing">
							<div class="lyr-inner">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_ing_2.png" alt="채점중 입니다! 부모님께서 채점을 완료하실때까지 기다려주세요">
								<div class="share">
									<button onclick="copyUrlSend('kakao');return false;">카카오톡으로 보내기</button>
									<button onclick="copyUrlSend('urlcopy');return false;" class="urlcopyclip" data-clipboard-text="https://m.10x10.co.kr/event/etc/parentgrade.asp?userid=<%=Server.URLEncode(tenEnc(userid))%>">링크 복사해서 보내기</button>
								</div>
                            </div>
						</div>
					</div>
				</div>
			</div>
			<%' mEvt102078 부모님 모의고사 %>
<!-- #include virtual="/lib/db/dbclose.asp" -->