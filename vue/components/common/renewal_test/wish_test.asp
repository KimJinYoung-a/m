<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 위시 테스트 페이지
' History : 2020-10-07 이전도 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/inc/head.asp" -->
<%
	dim gnbflag , testmode, defaultAPIURL
	gnbflag = RequestCheckVar(request("gnbflag"),1)
	testmode = RequestCheckVar(request("testmode"),1)

	If gnbflag <> "" Then '//gnb 숨김 여부
		gnbflag = true
	Else 
		gnbflag = False
		strHeadTitleName = "헤더"
	End if

    dim apiurl : apiurl = ""
    IF application("Svr_Info") = "Dev" THEN
        apiurl = "//testfapi.10x10.co.kr/api/web/v1"
        //apiurl = "//localhost:8080/api/web/v1"
    ElseIf application("Svr_Info")="staging" Then
        apiurl = "//fapi.10x10.co.kr/api/web/v1"
    Else
        apiurl = "//fapi.10x10.co.kr/api/web/v1"
    End If
%>
<script>
    apiurl = '<%=apiurl%>';
</script>

<div id="app"></div>

<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/babel-core/5.8.34/browser.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.auto.min.js"></script>
<% IF application("Svr_Info") = "Dev" or testmode = "1" THEN %>
<script src="https://unpkg.com/vue"></script>
<script src="https://unpkg.com/vuex"></script>
<script src="/vue/vue.lazyimg.min.js"></script>
<% Else %>
<script src="/vue/vue.min.js"></script>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>
<% End If %>

<!-- Common Component -->
<script src="../wish.js?v=1.0"></script>
<!-- //Common Component -->

<script>
	var app = new Vue({
		el: '#app',
		template: '\
			<div>\
                <section class="prd_list type_basic">\
                    <article class="prd_item">\
                        <WISH\
                            :id="id"\
                            :type="type"\
                            :on_flag="on_flag"\
                        ></WISH>\
                    </article>\
                </section>\
			</div>\
		',
        data: function () {
            return {
                id : 'okfarm',
                type : 'brand',
                on_flag : false
            }
        }
	});
</script>