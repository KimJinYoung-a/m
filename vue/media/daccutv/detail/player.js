Vue.component('media-player', {
    template: '\
    <div class="player">        \
        <div class="thm" \
            v-bind:style="{\'background-image\': \'url(\'+ mainImage +\')\'}">\
            <span class="badge"\
                v-if="isNew"\
            >NEW</span>\
        </div>\
        <div class="vod">\
            <iframe :src="videoUrl" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen=""></iframe>\
        </div>\
    </div>   \
    ',
    props: {
        videoUrl: {
            type: String,
            default: ""
        },
        isNew: {
            type: Boolean,
            default: false
        },
        mainImage: {
            type: String,
            default: ""
        }
    }
})