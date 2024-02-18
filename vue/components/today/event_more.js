Vue.component('event-more',{
    props: ['sub','isapp'],
    template : '\
				<div v-if="isapp > 0">\
				<li>\
					<a @click="fnAPPpopupAutoUrl(sub.link);">\
						<div class="thumbnail"><img :src="sub.eventimage" alt=""></div>\
						<p class="desc">\
							<b class="headline"><span class="ellipsis" v-if="sub.sale">{{sub.maincopy}}</span><span class="ellipsis full" v-else>{{sub.maincopy}}</span> <b class="discount color-red" v-if="sub.sale">{{sub.sale}}</b></b>\
							<span class="subcopy" v-html="sub.subcopy"></span>\
						</p>\
					</a>\
				</li>\
				</div>\
				<div v-else>\
				<li>\
					<a :href="sub.link">\
						<div class="thumbnail"><img :src="sub.eventimage" alt=""></div>\
						<p class="desc">\
							<b class="headline"><span class="ellipsis" v-if="sub.sale">{{sub.maincopy}}</span><span class="ellipsis full" v-else>{{sub.maincopy}}</span> <b class="discount color-red" v-if="sub.sale">{{sub.sale}}</b></b>\
							<span class="subcopy" v-html="sub.subcopy"></span>\
						</p>\
					</a>\
				</li>\
				</div>\
			'
})