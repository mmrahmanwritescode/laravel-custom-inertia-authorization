<template>
    <div>
        <nav id="topNav" class="navbar fixed-top food-blog-navbar" :class="isNavOpen ? 'top-navbar' : 'top-navbar-expand'">
            <div class="container-fluid">
                <div class="d-flex align-items-center">
                    <a id="MenuBar" @click="NavOpenClose" class="icon-nav mx-2 my-1 h5">
                        <i class="fa text-white fa-bars"></i>
                    </a>
                    <span class="navbar-brand font-lobster text-white ms-2 d-none d-md-block">
                        Admin Panel
                    </span>
                </div>
                <div>
                    <Link :href="route('logout')" class="btn-logout">
                        <i class="fa fa-sign-out-alt me-1"></i> Logout
                    </Link>
                </div>
            </div>
        </nav>
        <div id="sideNav" :class="isNavOpen ? 'side-nav-open' : 'side-nav-close'">
            <div class="side-nav-top text-center">
                <h2 class="font-lobster text-white mt-4 mb-2">Admin</h2>
                <p class="sidebar-tagline">Admin Panel</p>
                <div class="sidebar-divider"></div>
            </div>

            <Link :href="route('DashboardPage')" class="side-bar-item" :class="{ active: isActiveRoute('DashboardPage') }" @click="setActiveMenu(route('DashboardPage'))">
                <span class="side-bar-item-icon"><i class="fa fa-tachometer-alt"/></span>
                <span class="side-bar-item-caption">Dashboard</span>
            </Link>
            
            <!-- Role-based Users link -->
            <Link v-if="canViewUsers" :href="route('users.index')" class="side-bar-item" :class="{ active: isActiveRoute('users.index') }" @click="setActiveMenu(route('users.index'))">
                <span class="side-bar-item-icon"><i class="fa fa-users"/></span>
                <span class="side-bar-item-caption">Users</span>
            </Link>

            <!-- Role-based Products link -->
            <Link v-if="canViewProducts" :href="route('products.index')" class="side-bar-item" :class="{ active: isActiveRoute('products.index') }" @click="setActiveMenu(route('products.index'))">
                <span class="side-bar-item-icon"><i class="fa fa-box"/></span>
                <span class="side-bar-item-caption">Products</span>
            </Link>   
            
            <!-- Role & Permission Management (Admin Only) -->
            <div v-if="canViewRoles || canViewPermissions" class="sidebar-divider"></div>
            
            <Link v-if="canViewRoles" :href="route('roles.index')" class="side-bar-item" :class="{ active: isActiveRoute('roles.index') }" @click="setActiveMenu(route('roles.index'))">
                <span class="side-bar-item-icon"><i class="fa fa-user-tag"/></span>
                <span class="side-bar-item-caption">Roles</span>
            </Link>
            
            <Link v-if="canViewPermissions" :href="route('permissions.index')" class="side-bar-item" :class="{ active: isActiveRoute('permissions.index') }" @click="setActiveMenu(route('permissions.index'))">
                <span class="side-bar-item-icon"><i class="fa fa-key"/></span>
                <span class="side-bar-item-caption">Permissions</span>
            </Link>   
                                

        </div>
        <div id="content" :class="isNavOpen ? 'content' : 'content-expand'">
            <div class="container-fluid">
                <main>
                    <slot></slot>
                </main>
            </div>
        </div>
    </div>
</template>


<script setup>
import { ref, watchEffect, computed } from 'vue';
import { Link, usePage } from '@inertiajs/vue3';

const page = usePage();

// Get user data from Inertia shared props
const user = computed(() => page.props.auth?.user || null);
const userRole = computed(() => user.value?.role || 'user');
const permissions = computed(() => page.props.can || []);

// Check if user is admin
const isAdmin = computed(() => userRole.value === 'admin');

// Check permissions
const canViewUsers = computed(() => permissions.value.includes('view-user'));
const canViewProducts = computed(() => permissions.value.includes('view-product'));
const canViewRoles = computed(() => permissions.value.includes('view-role'));
const canViewPermissions = computed(() => permissions.value.includes('view-permission'));

// Get current route name
const currentRouteName = computed(() => page.props.ziggy?.location || '');
console.log(currentRouteName.value);

// Active menu handling
const activeMenu = ref(localStorage.getItem('activeMenu') || currentRouteName.value);

// Check if a route is active
const isActiveRoute = (routeName) => {
    const currentRoute = page.props.route || page.url || window.location.pathname;
    const targetRoute = route(routeName);
    
    // Check if the current URL matches the target route URL
    return currentRoute === targetRoute || 
           currentRoute.startsWith(targetRoute) ||
           activeMenu.value === targetRoute;
};

watchEffect(() => {
    localStorage.setItem('activeMenu', activeMenu.value);
});

const setActiveMenu = (routeUrl) => {
    console.log('Setting active menu:', routeUrl);
    activeMenu.value = routeUrl;
};

// Track sidebar state
const isNavOpen = ref(localStorage.getItem('isNavOpen') === 'true');

const NavOpenClose = () => {
    isNavOpen.value = !isNavOpen.value;
    localStorage.setItem('isNavOpen', isNavOpen.value);
};

</script>

<style scoped>
.active {
    background-color: #000000; /* Black background */
    color: white !important;
}

.food-blog-navbar {
    background: linear-gradient(to right, #000000, #333333) !important;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    padding: 10px 15px;
}

.btn-logout {
    color: white;
    text-decoration: none;
    font-weight: 500;
    padding: 8px 16px;
    border-radius: 40px;
    background-color: rgba(255, 255, 255, 0.1);
    transition: all 0.3s ease;
}

.btn-logout:hover {
    background-color: rgba(255, 255, 255, 0.2);
    transform: translateY(-2px);
}

.sidebar-tagline {
    color: #cccccc;
    font-size: 14px;
    font-style: italic;
    margin-bottom: 15px;
}

.sidebar-divider {
    height: 1px;
    background: linear-gradient(to right, transparent, rgba(255, 255, 255, 0.1), transparent);
    margin: 15px 20px;
}

#sideNav {
    background: linear-gradient(to bottom, #1a1a1a, #272727) !important;
}

.side-bar-item {
    margin: 5px 10px;
    border-radius: 8px !important;
    transition: all 0.3s ease;
}

.side-bar-item:hover {
    background-color: rgba(255, 255, 255, 0.05) !important;
    transform: translateX(5px);
}

.side-bar-item-icon {
    width: 20px;
    text-align: center;
    margin-right: 10px;
}

</style>

