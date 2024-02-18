<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 링커(20주년) 포럼
' History : 2021-09-24 이전도 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
    Dim forumIndex , onlyMyPosting
    forumIndex = Request("idx")
    If forumIndex = "" Then
        Call Alert_Return("잘못된 접근입니다.")
        response.End
    End If

    '// pc일경우 m -> pc 리다이렉트
    Dim redirect_url : redirect_url = fnRedirectToPc()
    If redirect_url <> "" Then
        Response.redirect redirect_url & "/linker/forum.asp?idx=" & forumIndex
        Response.end
    End If

    Dim place : place = Request("gaparam") '// 유입 장소

    onlyMyPosting = Request("me")
    If onlyMyPosting = "" Then
        onlyMyPosting = "0"
    End If

    dim gnbflag , testmode, defaultAPIURL
    gnbflag = RequestCheckVar(request("gnbflag"),1)
    If gnbflag <> "" Then '//gnb 숨김 여부
        gnbflag = true
        place = "gnb"
    Else
        gnbflag = False
        strHeadTitleName = "헤더"
    End if
%>
<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.auto.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bodymovin/5.7.4/lottie_svg.min.js"></script>
<script src="https://unpkg.com/@lottiefiles/lottie-player@latest/dist/lottie-player.js"></script>
<script src="/lib/js/mobile-detect.js"></script>
<% IF application("Svr_Info") = "Dev" or testmode = "1" THEN %>
<script src="/vue/vue_dev.js"></script>
<% Else %>
<script src="/vue/2.5/vue.min.js"></script>
<% End If %>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>
<script>
    const forumIndex = Number('<%=forumIndex%>');
    const onlyMyPosting = <%=ChkIif(onlyMyPosting="1", "true", "false")%>;
    const staticImgUpUrl = "<%= staticImgUpUrl %>";
    const wwwUrl = "<%=wwwUrl%>";
    let place = '<%=place%>';
    var userAgent = navigator.userAgent.toLowerCase();
</script>
<style>
.fade-enter-active, .fade-leave-active {transition: opacity .4s;}
.fade-enter, .fade-leave-to  {opacity: 0;}
</style>

<div id="app"></div>

<script src="/lib/js/infinitegrid.gridlayout.min.js"></script>

<script src="/vue/components/common/functions/common.js"></script>
<script src="/vue/components/linker/linker_mixins.js?v=1.1"></script>
<script src="/vue/components/common/functions/modal_mixins.js"></script>
<script src="/vue/components/common/modal2.js"></script>
<script src="/vue/components/common/btn_top.js"></script>
<script src="/vue/components/linker/modal_write.js?v=1.8"></script>
<script src="/vue/components/linker/modal_link.js?v=2.8"></script>
<script src="/vue/components/linker/modal_link_item.js?v=1.0"></script>
<script src="/vue/components/linker/modal_posting.js?v=2.94"></script>
<script src="/vue/components/linker/modal_posting_comment.js?v=1.2"></script>
<script src="/vue/components/linker/modal_profile_write.js?v=2.14"></script>
<script src="/vue/components/linker/forum_info.js?v=1.5"></script>
<script src="/vue/components/linker/forum_description.js?v=1.0"></script>
<script src="/vue/components/linker/modal_forum_list.js?v=1.1"></script>
<script src="/vue/components/linker/posting.js"></script>
<script src="/vue/linker/store.js?v=1.04"></script>
<script src="/vue/linker/index.js?v=1.81"></script>