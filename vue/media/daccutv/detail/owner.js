Vue.component('owner-info', {
    template: '\
    <div class="owner">\
        <div class="inner">\
            <div class="thumbnail"><img :src="profileImage" alt=""></div>\
            <div class="desc">\
                <p class="name">{{groupName}}</p>\
                <p>{{profileDescription}}</p>\
            </div>\
        </div>\
    </div>\
    ',
    props: {
        groupName: {
            type: String,
            default: ''
        },
        profileDescription: {
            type: String,
            default: ''
        },
        profileImage: {
            type: String,
            default: ''
        }
    }
})

