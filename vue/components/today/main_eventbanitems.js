Vue.component('main-eventbanitems',{
    props: ['item','isapp'],
    template : '\
				<div v-if="isapp > 0">\
					<div class="list-card type-align-left">\
						<a @click="fnAPPpopupAutoUrl(item.link);">\
							<div class="thumbnail"><img :src="item.imgsrc" alt=""></div>\
							<p class="desc">\
								<b class="headline"><span class="ellipsis" v-if="item.sale_per">{{item.title1}}</span><span class="ellipsis full" v-else>{{item.title1}}</span> <b class="discount color-red" v-if="item.sale_per">{{item.sale_per}}</b></b>\
								<span class="subcopy"><span class="label label-color" v-if="item.evttag"><em class="color-green" v-if="item.coupon_flag == 1">{{item.evttag}}</em><em class="color-blue" v-if="item.coupon_flag == 0">{{item.evttag}}</em></span>{{item.title2}}</span>\
							</p>\
						</a>\
					</div>\
					<div class="items">\
						<ul>\
							<li>\
								<a @click="fnAPPpopupAutoUrl(item.itemid1url);">\
									<div class="thumbnail"><img :src="item.itemimg1" alt=""></div>\
									<div class="desc">\
										<div class="price">\
											<b class="discount color-red" v-if="item.sale1">{{item.sale1}}</b>\
											<b class="sum">{{item.price1}}<span class="won">원</span></b>\
										</div>\
									</div>\
								</a>\
							</li>\
							<li>\
								<a @click="fnAPPpopupAutoUrl(item.itemid2url);">\
									<div class="thumbnail"><img :src="item.itemimg2" alt=""></div>\
									<div class="desc">\
										<div class="price">\
											<b class="discount color-red" v-if="item.sale2">{{item.sale2}}</b>\
											<b class="sum">{{item.price2}}<span class="won">원</span></b>\
										</div>\
									</div>\
								</a>\
							</li>\
							<li>\
								<a @click="fnAPPpopupAutoUrl(item.itemid3url);">\
									<div class="thumbnail"><img :src="item.itemimg3" alt=""></div>\
									<div class="desc">\
										<div class="price">\
											<b class="discount color-red" v-if="item.sale3">{{item.sale3}}</b>\
											<b class="sum">{{item.price3}}<span class="won">원</span></b>\
										</div>\
									</div>\
								</a>\
							</li>\
						</ul>\
					</div>\
				</div>\
				<div v-else>\
					<div class="list-card type-align-left">\
						<a :href="item.link">\
							<div class="thumbnail"><img :src="item.imgsrc" alt=""></div>\
							<p class="desc">\
								<b class="headline"><span class="ellipsis" v-if="item.sale_per">{{item.title1}}</span><span class="ellipsis full" v-else>{{item.title1}}</span> <b class="discount color-red" v-if="item.sale_per">{{item.sale_per}}</b></b>\
								<span class="subcopy"><span class="label label-color" v-if="item.evttag"><em class="color-green" v-if="item.coupon_flag == 1">{{item.evttag}}</em><em class="color-blue" v-if="item.coupon_flag == 0">{{item.evttag}}</em></span>{{item.title2}}</span>\
							</p>\
						</a>\
					</div>\
					<div class="items">\
						<ul>\
							<li>\
								<a :href="item.itemid1url">\
									<div class="thumbnail"><img :src="item.itemimg1" alt=""></div>\
									<div class="desc">\
										<div class="price">\
											<b class="discount color-red" v-if="item.sale1">{{item.sale1}}</b>\
											<b class="sum">{{item.price1}}<span class="won">원</span></b>\
										</div>\
									</div>\
								</a>\
							</li>\
							<li>\
								<a :href="item.itemid2url">\
									<div class="thumbnail"><img :src="item.itemimg2" alt=""></div>\
									<div class="desc">\
										<div class="price">\
											<b class="discount color-red" v-if="item.sale2">{{item.sale2}}</b>\
											<b class="sum">{{item.price2}}<span class="won">원</span></b>\
										</div>\
									</div>\
								</a>\
							</li>\
							<li>\
								<a :href="item.itemid3url">\
									<div class="thumbnail"><img :src="item.itemimg3" alt=""></div>\
									<div class="desc">\
										<div class="price">\
											<b class="discount color-red" v-if="item.sale3">{{item.sale3}}</b>\
											<b class="sum">{{item.price3}}<span class="won">원</span></b>\
										</div>\
									</div>\
								</a>\
							</li>\
						</ul>\
					</div>\
				</div>\
				'
})