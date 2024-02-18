<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appcom/wish/web2014/lib/head.asp" -->
<style>[v-cloak] { display: none; }</style>
</head>
<body class="default-font body-sub">
	<%'contents%>
	<div id="content" class="content">
		<div class="keyword-list" id="keylist" v-cloak>
			
			<section class="broadcast" v-for="item in items" :item="item" :key="item.id" v-if="item.search1">
				<h2><a @click="fnAPPpopupAutoUrl(item.klink1);">#{{item.keyword1}}</a></h2>
				<div class="type-photowall">
					<ul>
						<search-list v-for="sub in item.search1" :sub="sub" :key="sub.gubun" :isapp="1"></search-list>
					</ul>
				</div>
				<div class="btn-group"><a @click="fnAPPpopupAutoUrl(item.klink1);" class="btn-plus color-blue"><span class="icon icon-plus icon-plus-blue"></span> {{item.keyword1}} 더보기</a></div>
			</section>

			<section class="broadcast" v-for="item in items" :item="item" :key="item.id" v-if="item.search2">
				<h2><a @click="fnAPPpopupAutoUrl(item.klink2);">#{{item.keyword2}}</a></h2>
				<div class="type-photowall">
					<ul>
						<search-list v-for="sub in item.search2" :sub="sub" :key="sub.gubun" :isapp="1"></search-list>
					</ul>
				</div>
				<div class="btn-group"><a @click="fnAPPpopupAutoUrl(item.klink2);" class="btn-plus color-blue"><span class="icon icon-plus icon-plus-blue"></span> {{item.keyword2}} 더보기</a></div>
			</section>

			<section class="broadcast" v-for="item in items" :item="item" :key="item.id" v-if="item.search3">
				<h2><a @click="fnAPPpopupAutoUrl(item.klink3);">#{{item.keyword3}}</a></h2>
				<div class="type-photowall">
					<ul>
						<search-list v-for="sub in item.search3" :sub="sub" :key="sub.gubun" :isapp="1"></search-list>
					</ul>
				</div>
				<div class="btn-group"><a @click="fnAPPpopupAutoUrl(item.klink3);" class="btn-plus color-blue"><span class="icon icon-plus icon-plus-blue"></span> {{item.keyword3}} 더보기</a></div>
			</section>

			<section class="broadcast" v-for="item in items" :item="item" :key="item.id" v-if="item.search4">
				<h2><a @click="fnAPPpopupAutoUrl(item.klink4);">#{{item.keyword4}}</a></h2>
				<div class="type-photowall">
					<ul>
						<search-list v-for="sub in item.search4" :sub="sub" :key="sub.gubun" :isapp="1"></search-list>
					</ul>
				</div>
				<div class="btn-group"><a @click="fnAPPpopupAutoUrl(item.klink4);" class="btn-plus color-blue"><span class="icon icon-plus icon-plus-blue"></span> {{item.keyword4}} 더보기</a></div>
			</section>

			<section class="broadcast" v-for="item in items" :item="item" :key="item.id" v-if="item.search5">
				<h2><a @click="fnAPPpopupAutoUrl(item.klink5);">#{{item.keyword5}}</a></h2>
				<div class="type-photowall">
					<ul>
						<search-list v-for="sub in item.search5" :sub="sub" :key="sub.gubun" :isapp="1"></search-list>
					</ul>
				</div>
				<div class="btn-group"><a @click="fnAPPpopupAutoUrl(item.klink5);" class="btn-plus color-blue"><span class="icon icon-plus icon-plus-blue"></span> {{item.keyword5}} 더보기</a></div>
			</section>

			<section class="broadcast" v-for="item in items" :item="item" :key="item.id" v-if="item.search6">
				<h2><a @click="fnAPPpopupAutoUrl(item.klink6);">#{{item.keyword6}}</a></h2>
				<div class="type-photowall">
					<ul>
						<search-list v-for="sub in item.search6" :sub="sub" :key="sub.gubun" :isapp="1"></search-list>
					</ul>
				</div>
				<div class="btn-group"><a @click="fnAPPpopupAutoUrl(item.klink6);" class="btn-plus color-blue"><span class="icon icon-plus icon-plus-blue"></span> {{item.keyword6}} 더보기</a></div>
			</section>

			<section class="broadcast" v-for="item in items" :item="item" :key="item.id" v-if="item.search7">
				<h2><a @click="fnAPPpopupAutoUrl(item.klink7);">#{{item.keyword7}}</a></h2>
				<div class="type-photowall">
					<ul>
						<search-list v-for="sub in item.search7" :sub="sub" :key="sub.gubun" :isapp="1"></search-list>
					</ul>
				</div>
				<div class="btn-group"><a @click="fnAPPpopupAutoUrl(item.klink7);" class="btn-plus color-blue"><span class="icon icon-plus icon-plus-blue"></span> {{item.keyword7}} 더보기</a></div>
			</section>

			<section class="broadcast" v-for="item in items" :item="item" :key="item.id" v-if="item.search8">
				<h2><a @click="fnAPPpopupAutoUrl(item.klink8);">#{{item.keyword8}}</a></h2>
				<div class="type-photowall">
					<ul>
						<search-list v-for="sub in item.search8" :sub="sub" :key="sub.gubun" :isapp="1"></search-list>
					</ul>
				</div>
				<div class="btn-group"><a @click="fnAPPpopupAutoUrl(item.klink8);" class="btn-plus color-blue"><span class="icon icon-plus icon-plus-blue"></span> {{item.keyword8}} 더보기</a></div>
			</section>

			<section class="broadcast" v-for="item in items" :item="item" :key="item.id" v-if="item.search9">
				<h2><a @click="fnAPPpopupAutoUrl(item.klink9);">#{{item.keyword9}}</a></h2>
				<div class="type-photowall">
					<ul>
						<search-list v-for="sub in item.search9" :sub="sub" :key="sub.gubun" :isapp="1"></search-list>
					</ul>
				</div>
				<div class="btn-group"><a @click="fnAPPpopupAutoUrl(item.klink9);" class="btn-plus color-blue"><span class="icon icon-plus icon-plus-blue"></span> {{item.keyword9}} 더보기</a></div>
			</section>

			<section class="broadcast" v-for="item in items" :item="item" :key="item.id" v-if="item.search10">
				<h2><a @click="fnAPPpopupAutoUrl(item.klink10);">#{{item.keyword10}}</a></h2>
				<div class="type-photowall">
					<ul>
						<search-list v-for="sub in item.search10" :sub="sub" :key="sub.gubun" :isapp="1"></search-list>
					</ul>
				</div>
				<div class="btn-group"><a @click="fnAPPpopupAutoUrl(item.klink10);" class="btn-plus color-blue"><span class="icon icon-plus icon-plus-blue"></span> {{item.keyword10}} 더보기</a></div>
			</section>

		</div>
	</div>
	<%'contents%>
<script src="/vue/vue.min.js"></script>
<script src="/vue/keywordmore.js"></script>
</body>
</html>