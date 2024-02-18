<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 연말 쇼핑 대상
' History : 2019-12-20 이종화 
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim eCode, userid, currentDate , subscriptcount , eventStartDate , eventEndDate
IF application("Svr_Info") = "Dev" THEN
	eCode = "90448"
Else
	eCode = "99611"
End If

userid = GetEncLoginUserID()
dim objCmd , shoppingawardlist , loopInt
dim myordercount , myselectcategoryorderitemscount , myevaluatecount , mygifttalkactioncount

Set objCmd = Server.CreateObject("ADODB.COMMAND")
    With objCmd
        .ActiveConnection = dbget
        .CommandType = adCmdText
        .CommandText = "SELECT userid , summarycount , ranknumber ,gubuncode , startdate , enddate from db_temp.dbo.tbl_event_tenbytenhistory"
        .Prepared = true
        rsget.Open objCmd
        if not rsget.eof then
            shoppingawardlist = rsget.getRows
        end if
        rsget.Close
    End With
Set objCmd = Nothing


if userid <> "" then
    Set objCmd = Server.CreateObject("ADODB.COMMAND")
		With objCmd
			.ActiveConnection = dbget
			.CommandType = adCmdStoredProc
			.CommandText = "[db_log].[dbo].[usp_WWW_MYHistory_List_Get]"
			.Parameters.Append .CreateParameter("@vUserId", adVarChar, adParamInput, Len(userid), userid)
            .Parameters.Append .CreateParameter("@vStartdate", adVarChar, adParamInput, 10, "2019-01-01")
            .Parameters.Append .CreateParameter("@VEnddate", adVarChar, adParamInput, 10, "2019-12-31")
            rsget.Open objCmd
            if not rsget.eof then
                myordercount = rsget(1)
                myselectcategoryorderitemscount = rsget(2)
                myevaluatecount = rsget(3)
                mygifttalkactioncount = rsget(4)
            end if
            rsget.Close
		End With
	Set objCmd = Nothing
end if

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("[2019 텐텐 쇼핑 대상 발표]")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2019/99611/bnr_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[2019 텐텐 쇼핑 대상 발표]"
Dim kakaodescription : kakaodescription = "총 120만 원의 상금!\n나의 연간 기록을 확인해보세요!"
Dim kakaooldver : kakaooldver = "총 120만 원의 상금!\n나의 연간 기록을 확인해보세요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2019/99611/bnr_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode
%>
<style>
.mEvt99611, .mEvt99611 > div {position: relative;}
.mEvt99611 .ani-bounce {position: absolute; top: 54%; right: 0; width: 26.5%; animation:bounce .7s 20;}
.mEvt99611 .topic:after {content: ''; display: block; position: absolute; bottom: 0; height: 94px; width: 100%; background-image: url(//webimage.10x10.co.kr/fixevent/event/2019/99611/m/bg_top.png);}
.mEvt99611 .section {background-color: #4513c4;}
.mEvt99611 .section.sc2,.mEvt99611 .section.sc4 {background-color: #1c1c1c;}
.mEvt99611 .section .rank {position: relative; width: 32rem; margin: 0 auto;}
.mEvt99611 .section .rank ul {position: absolute; top: 7%; width: 100%;}
.mEvt99611 .section .rank li {height: 6.95rem; padding-left: 30%; color: #fff;}
.mEvt99611 .section .rank li:first-child {color: #fff711;}
.mEvt99611 .section .rank li span {font-size: 1.15rem; line-height: 1.8;}
.mEvt99611 .section .rank li p {font-size: 3.41rem; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; line-height: 3rem;}
.mEvt99611 .section .rank .bottom {display: flex; position: absolute; bottom: 2%; width: 100%; padding: 5% 13%; justify-content: space-between; font-size: 1.49rem; color: #fff;}
.mEvt99611 .section .rank .bottom .score b {font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';	}
.mEvt99611 .section .rank .bottom .score:after {content: ''; display: inline-block; width: .73rem; height: 1.11rem; background-image: url(//webimage.10x10.co.kr/fixevent/event/2019/99611/m/ico_arrow_wh.png); background-size: contain; background-repeat: no-repeat;}
.mEvt99611 .section .rank .bottom.myscore .score {color: #ff3131;}
.mEvt99611 .section .rank .bottom.myscore .score:after {background-image: url(//webimage.10x10.co.kr/fixevent/event/2019/99611/m/ico_arrow_red.png); }
.mEvt99611 .section.sc4 .rank .bottom {bottom: 10.5%;}
.mEvt99611 .sns-area {position:relative;}
.mEvt99611 .sns-area ul {display:flex; position:absolute; right:6%; top:14%; width:40%; height:75%;}
.mEvt99611 .sns-area ul li {flex-basis:50%; height:100%;}
.mEvt99611 .sns-area ul li a {display:inline-block; width:100%; height:100%; text-indent:-999em;}
@keyframes bounce {
	from to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(-10px); animation-timing-function:ease-in;}
}
</style>
<script>
    function snschk(snsnum) {		
        if(snsnum=="fb"){
            <% if isapp then %>
            fnAPPShareSNS('fb','<%=appfblink%>');
            return false;
            <% else %>
            popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
            <% end if %>
        }else{
            <% if isapp then %>		
                fnAPPshareKakao('etc','<%=kakaotitle%>','<%=kakaoWebLink%>','<%=kakaoMobileLink%>','<%="url="&kakaoAppLink%>','<%=kakaoimage%>','','','','<%=kakaodescription%>');
                return false;
            <% else %>
                event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaoMobileLink%>' );	
            <% end if %>
        }		
    }
    function jsEventLogin(){
        <% if isApp="1" then %>
            calllogin();
        <% else %>
            jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=?" & eCode)%>');
        <% end if %>
            return;
    }
</script>
<div class="mEvt99611">
    <div class="topic">
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/99611/m/tit.gif?v=1.02" alt="2019텐텐쇼핑대상"></h2>
        <span class="ani-bounce"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99611/m/ico_bounce.png" alt="12명"></span>
    </div>
    <div class="section sc1">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/99611/m/tit_1.jpg?v=1.01" alt="쇼핑천재"></h3>
        <div class="rank">
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99611/m/bg_1.jpg?v=1.03" alt=""></p>
            <ul>
                <% 
                    for loopInt = 0 to ubound(shoppingawardlist,2) 
                        if shoppingawardlist(3,loopInt) = "order" then 
                %>
                <li>
                    <span><%=printUserId(shoppingawardlist(0,loopInt),2,"*")%></span>
                    <p class="score"><b><%=formatnumber(shoppingawardlist(1,loopInt),0)%></b>회</p>
                </li>
                <%
                        end if 
                    next 
                %>
            </ul>
            <% if IsUserLoginOK then %>
            <% if isapp then %>
                <a href="" onclick="fnAPPpopupBrowserURL('주문/배송조회','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/order/myorderlist.asp'); return false;" class="bottom myscore">
            <% else %>
                <a href="/my10x10/order/myorderlist.asp" class="bottom myscore">
            <% end if %>
                <span><b><%=GetLoginUserName%></b>님의 기록</span>
                <div class="score">
                    <b><%=myordercount%></b>회
                </div>
            </a>
            <% else %>
            <a href="javascript:jsEventLogin()" class="bottom">
                <span>나의 기록은?</span>
                <div class="score">
                    확인하기
                </div>
            </a>
            <% end if %>
        </div>
    </div>
    <div class="section sc2">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/99611/m/tit_2.jpg?v=1.01" alt="문구덕후"></h3>
        <div class="rank">
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99611/m/bg_2.jpg?v=1.01" alt=""></p>
            <ul>
                <% 
                    for loopInt = 0 to ubound(shoppingawardlist,2) 
                        if shoppingawardlist(3,loopInt) = "ordercate" then 
                %>
                <li>
                    <span><%=printUserId(shoppingawardlist(0,loopInt),2,"*")%></span>
                    <p class="score"><b><%=formatnumber(shoppingawardlist(1,loopInt),0)%></b>개</p>
                </li>
                <%
                        end if 
                    next 
                %>
            </ul>
            <% if IsUserLoginOK then %>
                 <% if isapp then %>
                    <a href="" onclick="fnAPPpopupBrowserURL('상품후기','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/goodsusing.asp'); return false;" class="bottom myscore">
                <% else %>
                    <a href="/my10x10/goodsusing.asp" class="bottom myscore">
                <% end if %>
                    <span><b><%=GetLoginUserName%></b>님의 기록</span>
                    <div class="score">
                        <b><%=myselectcategoryorderitemscount%></b>개
                    </div>
                </a>
            <% else %>
            <a href="javascript:jsEventLogin()" class="bottom">
                <span>나의 기록은?</span>
                <div class="score">
                    확인하기
                </div>
            </a>
            <% end if %>
        </div>
    </div>
    <div class="section sc3">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/99611/m/tit_3.jpg?v=1.01" alt="후기왕"></h3>
        <div class="rank">
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99611/m/bg_3.jpg?v=1.01" alt=""></p>
            <ul>
                <% 
                    for loopInt = 0 to ubound(shoppingawardlist,2) 
                        if shoppingawardlist(3,loopInt) = "evaluate" then 
                %>
                <li>
                    <span><%=printUserId(shoppingawardlist(0,loopInt),2,"*")%></span>
                    <p class="score"><b><%=formatnumber(shoppingawardlist(1,loopInt),0)%></b>개</p>
                </li>
                <%
                        end if 
                    next 
                %>
            </ul>
            <% if IsUserLoginOK then %>
                <% if isapp then %>
                    <a href="" onclick="fnAPPpopupBrowserURL('상품후기','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/goodsusing.asp'); return false;" class="bottom myscore">
                <% else %>
                    <a href="/my10x10/goodsusing.asp" class="bottom myscore">
                <% end if %>
                        <span><b><%=GetLoginUserName%></b>님의 기록</span>
                        <div class="score">
                            <b><%=myevaluatecount%></b>개
                        </div>
                    </a>
            <% else %>
            <a href="javascript:jsEventLogin()" class="bottom">
                <span>나의 기록은?</span>
                <div class="score">
                    확인하기
                </div>
            </a>
            <% end if %>
        </div>
    </div>
    <div class="section sc4">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/99611/m/tit_4.jpg?v=1.01" alt="프로선택러"></h3>
        <div class="rank">
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99611/m/bg_4.jpg?v=1.01" alt=""></p>
            <ul>
                <% 
                    for loopInt = 0 to ubound(shoppingawardlist,2) 
                        if shoppingawardlist(3,loopInt) = "gifttalk" then 
                %>
                <li>
                    <span><%=printUserId(shoppingawardlist(0,loopInt),2,"*")%></span>
                    <p class="score"><b><%=formatnumber(shoppingawardlist(1,loopInt),0)%></b>회</p>
                </li>
                <%
                        end if 
                    next 
                %>
            </ul>
            <% if IsUserLoginOK then %>
                <% if isapp then %>
                <a href="" onclick="fnAPPpopupBrowserURL('선물의 참견','<%=wwwUrl%>/apps/appcom/wish/web2014/gift/gifttalk/index.asp'); return false;" class="bottom myscore">
                <% else %>
                <a href="/gift/gifttalk/" class="bottom myscore">
                <% end if %>
                    <span><b><%=GetLoginUserName%></b>님의 기록</span>
                    <div class="score">
                        <b><%=mygifttalkactioncount%></b>회
                    </div>
                </a>
            <% else %>
            <a href="javascript:jsEventLogin()" class="bottom">
                <span>나의 기록은?</span>
                <div class="score">
                    확인하기
                </div>
            </a>
            <% end if %>
        </div>
    </div>
    <div class="sns-area">
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99611/m/btn_sns.jpg" alt="친구에게 이벤트 공유하기"></p>
        <ul>
            <li><a href="javascript:snschk('fb');">페이스북 공유</a></li>
            <li><a href="javascript:snschk('ka');">카카오톡 공유</a></li>
        </ul>
    </div>
    <div class="evt-area">
        <ul>
            <li>
                <a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=99242');return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99611/m/bnr_1.jpg" alt="지금 가장 핫한 텐바이텐 BEST 20"></a>
                <a href="/event/eventmain.asp?eventid=99242" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99611/m/bnr_1.jpg" alt="지금 가장 핫한 텐바이텐 BEST 20"></a>
            </li>
            <li>
                <a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=99222');return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99611/m/bnr_2.jpg" alt="텐바이텐이 처음이세요? 제가 도와드릴게요!"></a>
                <a href="/event/eventmain.asp?eventid=99222" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99611/m/bnr_2.jpg" alt="텐바이텐이 처음이세요? 제가 도와드릴게요!"></a>
            </li>
            <li>
                <a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/christmas/');return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99611/m/bnr_3.jpg" alt="당신이 찾고 있는 크리스마스 소품의 모든 것"></a>
                <a href="/christmas/" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99611/m/bnr_3.jpg" alt="당신이 찾고 있는 크리스마스 소품의 모든 것"></a>
            </li>
        </ul>
    </div>
    <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99611/m/txt_noti.jpg" alt="유의사항"></p>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->