<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 탭 타입1 테스트 페이지
' History : 2020-10-06 이전도 생성
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
    defaultAPIURL = ""

	If gnbflag <> "" Then '//gnb 숨김 여부
		gnbflag = true
	Else 
		gnbflag = False
		strHeadTitleName = "헤더"
	End if
%>

<div id="app"></div>

<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/babel-core/5.8.34/browser.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.auto.min.js"></script>
<% IF application("Svr_Info") = "Dev" or testmode = "1" THEN %>
<script src="https://unpkg.com/vue"></script>
<script src="https://unpkg.com/vuex"></script>
<script src="/vue/vue.lazyimg.min.js"></script>
<% defaultAPIURL = "http://testfapi.10x10.co.kr/" %>
<% Else %>
<script src="/vue/vue.min.js"></script>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>
<% defaultAPIURL = "https://fapi.10x10.co.kr" %>
<% End If %>

<!-- Common Component -->
<script src="../tab_type1.js?v=1.0"></script>
<!-- //Common Component -->

<script>
	var app = new Vue({
		el: '#app',
		template: '\
			<div>\
				<Tab-Type1\
				    :tabs="tabs"\
				></Tab-Type1>\
			</div>\
		',
        data: function () {
            return {
                tabs : [
                    {
                        value : 'best',
                        text : '베스트셀러',
                        is_active: true
                    },
                    {
                        value : 'clearance',
                        text : '클리어런스',
                        is_active: false
                    },
                    {
                        value : 'sale',
                        text : '할인상품',
                        is_active: false
                    },
                    {
                        value : 'steady',
                        text : '스테디셀러',
                        is_active: false
                    },
                    {
                        value : 'new',
                        text : '신상품',
                        is_active: false
                    }
                ]
            }
        }
	});
</script>