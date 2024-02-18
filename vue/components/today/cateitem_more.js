Vue.component('cateitem-more',{
    props: ['sub','isapp'],
    template : '\
				<div v-if="isapp > 0">\
				<li>\
					<a @click="fnAPPpopupAutoUrl(sub.link);">\
						<div class="thumbnail"><img :src="sub.itemimage" alt="" /></div>\
						<div class="desc">\
							<p class="name">{{sub.itemname}}</p>\
							<div class="price">\
								<b class="discount color-red">{{sub.sale}}</b>\
								<b class="sum">{{sub.price}}<span class="won">원</span></b>\
							</div>\
						</div>\
					</a>\
				</li>\
				</div>\
				<div v-else>\
				<li>\
					<a :href="sub.link">\
						<div class="thumbnail"><img :src="sub.itemimage" alt="" /></div>\
						<div class="desc">\
							<p class="name">{{sub.itemname}}</p>\
							<div class="price">\
								<b class="discount color-red">{{sub.sale}}</b>\
								<b class="sum">{{sub.price}}<span class="won">원</span></b>\
							</div>\
						</div>\
					</a>\
				</li>\
				</div>\
			'
})