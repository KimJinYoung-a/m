<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/util/tenSessionLib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
'####################################################
' Description :  부모님 모의고사
' History : 2019-04-29 원승현 
'          2020-04-22 정태훈
'####################################################

dim eCode, userid, currenttime, questionNumber, several
IF application("Svr_Info") = "Dev" THEN
	eCode = "102151"
    several=2 '회차 정보
Else
	eCode = "102078"
    several=2
End If

currenttime = now()
userid = requestcheckvar(request("userid"),1000)
questionNumber = requestcheckvar(request("qn"),500)


on error resume next

Dim vQuery, examCheck, userNm, parentNm, masterIdx
'// 해당 이벤트를 참여했는지 확인한다.
vQuery = "SELECT idx, userid, userName, parentName FROM [db_temp].[dbo].[tbl_event_parentdayexam_master] WITH (NOLOCK) WHERE several=" & several & " and userid = '" & Server.URLEncode(tenDec(userid)) & "' "
rsget.CursorLocation = adUseClient
rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
IF Not rsget.Eof Then
    examCheck = TRUE
    userNm = rsget("userName")
    parentNm = rsget("parentName")
    masterIdx = rsget("idx")
Else
    response.write "<script>alert('모의고사 참여 정보가 없습니다.');location.href='https://m.10x10.co.kr/apps/appCom/wish/web2014/event/etc/parentmocktest.asp';</script>"
    response.end
End If
rsget.close

If Err.Number <> 0 then 
    response.write "<script>alert('모의고사 참여 정보가 없습니다.');location.href='https://m.10x10.co.kr/apps/appCom/wish/web2014/event/etc/parentmocktest.asp';</script>"
    response.end
End If
On Error Goto 0


Dim parentAge, sltvalue, sltyear, sltmonth, sltday, blood, clothsize, footsize, fafood, fadrama, facolor, fahobby, faentertainer
Dim c1Result, c2Result, c3Result, c4Result, c5Result, c6Result, c7Result, c8Result, c9Result, c10Result, c11Result
If examCheck Then
    vQuery = "SELECT idx, masterIdx, userid, questionNumber, Answer, ISNULL(marking,'') as marking FROM [db_temp].[dbo].[tbl_event_parentdayexam_detail] WITH (NOLOCK) WHERE userid = '" & Server.URLEncode(tenDec(userid)) & "' And masterIdx ='"&masterIdx&"' "
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
            If Trim(rsget("questionNumber")) = 11 Then
                c11Result = rsget("marking")
            End If
        rsget.movenext
        loop
    End If
    rsget.close
End If

'// 전체 채점을 했다면 result 페이지로 이동 시킨다.
If Trim(c1Result) <> "" And Trim(c2Result) <> "" And Trim(c3Result) <> "" And Trim(c4Result) <> "" And Trim(c5Result) <> "" And Trim(c6Result) <> "" And Trim(c7Result) <> "" And Trim(c8Result) <> "" And Trim(c9Result) <> "" And Trim(c10Result) <> "" And Trim(c11Result) <> "" Then
    Response.redirect "/apps/appCom/wish/web2014/event/etc/parentgraderesult.asp?userid="&Server.URLEncode(userid)
    response.end
End If

If Trim(questionNumber)="" Then
    questionNumber = 1
End If
%>
<title>10x10: 부모님 모의고사</title>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script>
$(function(){
    fnAPPchangPopCaption('이벤트');
	// score
    $(".card-list li").hide();
    $(".card-list li:first").show();
	//$(".card-list .c<%=questionNumber%>").show();

	// 다시채점
	$(".btn-again").click(function(){
		$(".lyr-again").show();
	});
	$(".lyr-again .btn-no").click(function(){
		$(".lyr-again").hide();
	});
});
function gradeStartShow() {
    $(".card-list li").hide();
    $(".card-list .c<%=questionNumber%>").show();
}
function gradeFirstMove(){
    $(".card-list li").hide();
    $(".card-list li:first").show();
    $(".lyr-again").hide();
}
function gradeCheck(qn, chk) {
    var marking = $(':radio[name="c'+qn+'"]:checked').val();
    if (marking=="" || typeof marking=="undefined") {
        if (qn=="11") {
            alert("받고 싶은 선물을 선택하신 후 채점완료 버튼을 클릭 해주세요.");
        } else {
            alert("O/X를 선택하신 후 다음버튼을 클릭 해주세요.");
        }
        return false;
    } else {
        $.ajax({
            type:"GET",
            url:"/event/etc/doparentmocktest.asp?mode=grade&qnuserid=<%=Server.URLEncode(userid)%>&qnmasteridx=<%=masterIdx%>&qn="+qn+"&marking="+marking,
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
                                if ($(chk).closest("li").hasClass("c11")){
                                    location.href='/apps/appCom/wish/web2014/event/etc/parentgraderesult.asp?userid=<%=server.URLEncode(userid)%>'
                                    return false;
                                } else {
                                    $(".card-list li").hide();
                                    $(chk).closest("li").next().show();
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
    }
}
</script>
<style type="text/css">
.mEvt102078 button {font-size:0; color:transparent; background:transparent;}
.card-list li {display:none; position:relative; line-height:1.1; font-family:'CoreSansCBold','NotoSansKRBold';}
.card-list .btn-next {position:absolute; left:10%; bottom:17.5%; width:80%; height:18%;}
.card-list .name {overflow:hidden; position:absolute; right:61.5%; top:22.7%; width:31%; padding-top:.2rem; text-align:right; font-size:6.3vw; color:#001011; text-overflow:ellipsis; white-space:nowrap; letter-spacing:-.04rem; word-spacing:-.3rem;}
.card-list .answer {position:absolute; left:0; top:36.5%; width:100%; text-align:center; font-size:7.2vw; color:#ff9000;}
.card-list .ox {position:absolute; left:20.5%; top:45.7%; width:56.8%; height:15.23%;}
.card-list .ox label {display:block; position:relative; float:left; width:39.68%; height:100%;}
.card-list .ox label input[type=radio] {position:absolute; left:0; top:0; width:0; height:0; border:0;}
.card-list .ox label i {display:block; width:100%; height:100%; background:url(//webimage.10x10.co.kr/fixevent/event/2020/102078/m/bg_o.png?v=2) no-repeat 0 0; background-size:auto 100%;}
.card-list .ox label:last-child {float:right;}
.card-list .ox label:last-child i {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/102078/m/bg_x.png);}
.card-list .ox label input[type=radio]:checked + i {background-position-x:100%;}
.card-list .start .name {top:40.5%; right:63.2%; font-size:4vw; }
.card-list .start .btn-next {bottom:20.5%;}
.card-list .c1 .name {right:55%;}
.card-list .c1 .answer {left:30%; top:32%; width:20%; text-align:right; font-size:8.2vw;}
.card-list .c2 .name {right:55%; top:21.8%;}
.card-list .c2 .answer {top:29.5%; height:12%;}
.card-list .c2 .answer span {display:block; position:absolute; top:58.5%; width:13%; text-align:right;}
.card-list .c2 .answer span:nth-child(1) {right:0; top:0; width:100%; text-align:center;}
.card-list .c2 .answer span:nth-child(2) {left:16%; width:20%;}
.card-list .c2 .answer span:nth-child(3) {left:42%;}
.card-list .c2 .answer span:nth-child(4) {left:60%;}
.card-list .c3 .name {right:57.5%;}
.card-list .c3 .answer {left:28%; top:32.3%; width:20%; text-align:right; font-size:8.2vw;}
.card-list .c4 .answer {top:32.3%; font-size:8.5vw;}
.card-list .c5 .answer {left:29%; top:32%; width:20%; text-align:right; font-size:8.5vw;}
.card-list .c6 .name,
.card-list .c7 .name,
.card-list .c8 .name {right:59.5%;}
.card-list .c9 .name,
.card-list .c10 .name {right:60.2%;}
.card-list .c11 .name {right:48.2%; top:19.1%;}
.card-list .c11 .answer {left:20.8%; top:36.3%; width:46.7%; height:23%; text-align:left;}
.card-list .c11 .answer label {display:block; height:25%;}
.card-list .c11 .answer input[type=radio] {position:relative; width:12.2%; border:0; background:transparent;}
.card-list .c11 .answer input[type=radio]:checked:after {content:''; position:absolute; left:8%; top:13%; width:100%; height:150%; background:url(//webimage.10x10.co.kr/fixevent/event/2020/102078/m/ico_check.png) no-repeat 0 0 / 100% auto; }
.card-list .c11 .btn-next {bottom:25%; height:12.5%; }
.card-list .c11 .btn-again {position:absolute; left:10%; bottom:14%; width:80%; height:10%;}
.card-list .c11 .lyr-again {display:none; position:fixed; left:0; top:0; z-index:30; width:100vw; height:100vh; padding:0 6%; background:rgba(0,0,0,.6);}
.card-list .c11 .lyr-inner {position:relative; top:50%; transform:translateY(-55%);}
.card-list .c11 .lyr-again button {position:absolute; left:5%; bottom:32%; width:90%; height:20%;}
.card-list .c11 .lyr-again button.btn-no {bottom:10%;}
.card-list .finish .score {position:absolute; left:0; top:50%; width:100%; font-size:16vw; text-align:center; color:#ff2424;}
.card-list .finish .score img {width:8.9%; vertical-align:middle; margin-left:.5rem;}
</style>
</head>
<body class="default-font body-sub bg-grey">
	<!-- contents -->
	<div id="content" class="content">
		<div class="evtContV15">

			<%' mEvt94152 부모님 모의고사 %>
			<div class="mEvt102078">
				<ol class="card-list">
					<li class="start">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_card0.png" alt="부모님 모의고사"></p>
						<div class="name"><%=userNm%></div>
						<button class="btn-next" onclick="gradeStartShow();">채점시작</button>
					</li>
					<li class="c1">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_card1.png" alt="연세는?"></p>
						<div class="name">① <%=parentNm%></div>
						<div class="answer"><%=parentAge%></div>
						<div class="ox">
							<label for="c1_o"><input type="radio" name="c1" id="c1_o" value="O"><i></i></label>
							<label for="c1_x"><input type="radio" name="c1" id="c1_x" value="X"><i></i></label>
						</div>
						<button class="btn-next" onclick="gradeCheck('1', this);">다음</button>
					</li>
					<li class="c2">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_card2.png?v=2" alt="생신은?"></p>
						<div class="name">② <%=parentNm%></div>
						<div class="answer">
							<span><%=sltvalue%></span>
							<span><%=sltyear%></span>
							<span><%=sltmonth%></span>
							<span><%=sltday%></span>
						</div>
						<div class="ox">
							<label for="c2_o"><input type="radio" name="c2" id="c2_o" value="O"><i></i></label>
							<label for="c2_x"><input type="radio" name="c2" id="c2_x" value="X"><i></i></label>
						</div>
						<button class="btn-next" onclick="gradeCheck('2', this);">다음</button>
					</li>
					<li class="c3">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_card3.png" alt="혈액형은?"></p>
						<div class="name">③ <%=parentNm%></div>
						<div class="answer"><%=blood%></div>
						<div class="ox">
							<label for="c3_o"><input type="radio" name="c3" id="c3_o" value="O"><i></i></label>
							<label for="c3_x"><input type="radio" name="c3" id="c3_x" value="X"><i></i></label>
						</div>
						<button class="btn-next" onclick="gradeCheck('3', this);">다음</button>
					</li>
					<li class="c4">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_card4.png" alt="옷 사이즈는?"></p>
						<div class="name">④ <%=parentNm%></div>
						<div class="answer"><%=clothsize%></div>
						<div class="ox">
							<label for="c4_o"><input type="radio" name="c4" id="c4_o" value="O"><i></i></label>
							<label for="c4_x"><input type="radio" name="c4" id="c4_x" value="X"><i></i></label>
						</div>
						<button class="btn-next" onclick="gradeCheck('4', this);">다음</button>
					</li>
					<li class="c5">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_card5.png" alt="발 사이즈는?"></p>
						<div class="name">⑤ <%=parentNm%></div>
						<div class="answer"><%=footsize%></div>
						<div class="ox">
							<label for="c5_o"><input type="radio" name="c5" id="c5_o" value="O"><i></i></label>
							<label for="c5_x"><input type="radio" name="c5" id="c5_x" value="X"><i></i></label>
						</div>
						<button class="btn-next" onclick="gradeCheck('5', this);">다음</button>
					</li>
					<li class="c6">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_card6.png" alt="좋아하시는 음식은?"></p>
						<div class="name">⑥ <%=parentNm%></div>
						<div class="answer"><%=fafood%></div>
						<div class="ox">
							<label for="c6_o"><input type="radio" name="c6" id="c6_o" value="O"><i></i></label>
							<label for="c6_x"><input type="radio" name="c6" id="c6_x" value="X"><i></i></label>
						</div>
						<button class="btn-next" onclick="gradeCheck('6', this);">다음</button>
					</li>
					<li class="c7">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_card7.png?v=3" alt="즐겨보시는 드라마는?"></p>
						<div class="name">⑦ <%=parentNm%></div>
						<div class="answer"><%=fadrama%></div>
						<div class="ox">
							<label for="c7_o"><input type="radio" name="c7" id="c7_o" value="O"><i></i></label>
							<label for="c7_x"><input type="radio" name="c7" id="c7_x" value="X"><i></i></label>
						</div>
						<button class="btn-next" onclick="gradeCheck('7', this);">다음</button>
					</li>
					<li class="c8">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_card8.png?v=3" alt="좋아하시는 색상은?"></p>
						<div class="name">⑧ <%=parentNm%></div>
						<div class="answer"><%=facolor%></div>
						<div class="ox">
							<label for="c8_o"><input type="radio" name="c8" id="c8_o" value="O"><i></i></label>
							<label for="c8_x"><input type="radio" name="c8" id="c8_x" value="X"><i></i></label>
						</div>
						<button class="btn-next" onclick="gradeCheck('8', this);">다음</button>
					</li>
					<li class="c9">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_card9.png" alt="즐겨하시는 취미는?"></p>
						<div class="name">⑨ <%=parentNm%></div>
						<div class="answer"><%=fahobby%></div>
						<div class="ox">
							<label for="c9_o"><input type="radio" name="c9" id="c9_o" value="O"><i></i></label>
							<label for="c9_x"><input type="radio" name="c9" id="c9_x" value="X"><i></i></label>
						</div>
						<button class="btn-next" onclick="gradeCheck('9', this);">다음</button>
					</li>
					<li class="c10">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_card10.png" alt="좋아하시는 연예인은?"></p>
						<div class="name">⑩ <%=parentNm%></div>
						<div class="answer"><%=faentertainer%></div>
						<div class="ox">
							<label for="c10_o"><input type="radio" name="c10" id="c10_o" value="O"><i></i></label>
							<label for="c10_x"><input type="radio" name="c10" id="c10_x" value="X"><i></i></label>
						</div>
						<button class="btn-next" onclick="gradeCheck('10', this);">다음</button>
					</li>
					<li class="c11">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_card11.png" alt="이번 어버이날에 받고 싶은 선물은 무엇인가요?"></p>
						<div class="name"><%=parentNm%></div>
						<div class="answer">
							<label for="c11_1"><input type="radio" name="c11" id="c11_1" value="1"></label>
							<label for="c11_2"><input type="radio" name="c11" id="c11_2" value="2"></label>
							<label for="c11_3"><input type="radio" name="c11" id="c11_3" value="3"></label>
							<label for="c11_4"><input type="radio" name="c11" id="c11_4" value="4"></label>
						</div>
						<button class="btn-next" onclick="gradeCheck('11', this);">다음</button>
						<button class="btn-again">다시 채점하기</button>
						<!-- 다시채점 한다/안한다 -->
						<div class="lyr-again">
							<div class="lyr-inner">
								<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_finish.png" alt="다시 채점할 경우, 기존에 채점한 내용은 모두 사라집니다. 처음부터 채점하시겠습니까?"></p>
								<button class="btn-yes" onClick="gradeFirstMove();">네, 다시 채점하겠습니다</button>
								<button class="btn-no">아니요 괜찮습니다</button>
							</div>
						</div>
					</li>
					<li class="finish">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_card12.png" alt="채점완료!"></p>
						<div class="score">90<img src="//webimage.10x10.co.kr/fixevent/event/2020/102078/m/txt_score.png" alt="점"></div>
					</li>
				</ol>
			</div>
			<!-- //mEvt94152 부모님 모의고사 -->
		</div>
    </div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->