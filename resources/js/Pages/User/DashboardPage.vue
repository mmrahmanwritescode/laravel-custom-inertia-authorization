<template>
    <SideNavLayout>
       Dashboard Page Content goes here
    </SideNavLayout>
</template>

<script setup>

import SideNavLayout from "@/Layout/SideNavLayout.vue";


import { usePage } from '@inertiajs/vue3';
import { createToaster } from "@meforma/vue-toaster";

const page = usePage();

const toaster = createToaster({
    position: "bottom",
});

if (page.props.flash.error) {
    toaster.error(page.props.flash.error);
}
</script>
