<template>
    <SideNavLayout>
        <div class="container-fluid">

            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h3 class="card-title">Permissions Management</h3>
                            <div v-if="canCreatePermission">
                                <Link href="/permissions/create" class="btn btn-dark create-btn">
                                    <i class="fa fa-plus me-2"></i>Create Permission
                                </Link>
                            </div>
                        </div>
                        <div class="card-body">
                            <div v-if="permissionsData && permissionsData.length > 0">
                                <div class="table-responsive">
                                    <table class="table table-striped table-hover">
                                        <thead>
                                            <tr>
                                                <th scope="col">#</th>
                                                <th scope="col">Name</th>
                                                <th scope="col">Roles Count</th>
                                                <th scope="col">Created</th>
                                                <th scope="col" class="text-center">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr v-for="(permission, index) in permissionsData" :key="permission.id">
                                                <th scope="row">{{ getItemNumber(index) }}</th>
                                                <td>
                                                    <code class="permission-name">{{ permission.name }}</code>
                                                </td>
                                                <td>
                                                    <span class="badge bg-info">
                                                        {{ permission.roles_count || 0 }} role(s)
                                                    </span>
                                                </td>
                                                <td>
                                                    <small class="text-muted">{{ formatDate(permission.created_at) }}</small>
                                                </td>
                                                <td class="text-center">
                                                    <div class="btn-group" role="group">
                                                        <Link 
                                                            v-if="canEditPermission"
                                                            :href="`/permissions/${permission.id}/edit`" 
                                                            class="btn btn-sm btn-outline-primary"
                                                            title="Edit Permission"
                                                        >
                                                            <i class="fa fa-edit"></i>
                                                        </Link>
                                                        <button 
                                                            v-if="canDeletePermission"
                                                            @click="deletePermission(permission)" 
                                                            class="btn btn-sm btn-outline-danger"
                                                            title="Delete Permission"
                                                            :disabled="permission.roles_count > 0"
                                                        >
                                                            <i class="fa fa-trash"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>

                <!-- Pagination -->
                <div v-if="shouldShowPagination" class="d-flex justify-content-between align-items-center mt-4">
                    <div class="pagination-info">
                        <small class="text-muted">{{ paginationInfo.showing }}</small>
                    </div>
                    <nav aria-label="Page navigation">
                        <ul class="pagination">
                            <!-- First Page -->
                            <li class="page-item" :class="{ disabled: isFirstPage }">
                                <button class="page-link" @click="goToPage(1)" :disabled="isFirstPage">
                                    <i class="fa fa-angle-double-left"></i>
                                </button>
                            </li>
                            
                            <!-- Previous Page -->
                            <li class="page-item" :class="{ disabled: !canGoPrev }">
                                <button class="page-link" @click="goToPage(paginationData.current_page - 1)" :disabled="!canGoPrev">
                                    <i class="fa fa-angle-left"></i>
                                </button>
                            </li>
                            
                            <!-- Page Numbers -->
                            <li v-for="page in visiblePages" :key="page" class="page-item" 
                                :class="{ 
                                    active: page === paginationData.current_page,
                                    disabled: page === '...'
                                }">
                                <button v-if="page !== '...'" class="page-link" @click="goToPage(page)">
                                    {{ page }}
                                </button>
                                <span v-else class="page-link">{{ page }}</span>
                            </li>
                            
                            <!-- Next Page -->
                            <li class="page-item" :class="{ disabled: !canGoNext }">
                                <button class="page-link" @click="goToPage(paginationData.current_page + 1)" :disabled="!canGoNext">
                                    <i class="fa fa-angle-right"></i>
                                </button>
                            </li>
                            
                            <!-- Last Page -->
                            <li class="page-item" :class="{ disabled: isLastPage }">
                                <button class="page-link" @click="goToPage(paginationData.last_page)" :disabled="isLastPage">
                                    <i class="fa fa-angle-double-right"></i>
                                </button>
                            </li>
                        </ul>
                    </nav>
                </div>
                            </div>

                            <div v-else class="text-center py-5">
                                <div class="empty-state">
                                    <i class="fa fa-key fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">No Permissions Found</h5>
                                    <p class="text-muted">There are no permissions in the system yet.</p>
                                    <Link v-if="canCreatePermission" href="/permissions/create" class="btn btn-primary">
                                        <i class="fa fa-plus me-2"></i>Create First Permission
                                    </Link>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    <!-- Confirm Dialog Component -->
    <ConfirmDelete :isOpen="showDeleteModal"
                   :title="resourceTitle"
                   message="Are you sure you want to delete this permission?"
                   @close="showDeleteModal = false"
                   @confirm="confirmDelete"/>           
    </SideNavLayout>
</template>

<script setup>
import { defineProps, computed, ref } from 'vue';
import { Link, usePage, router } from '@inertiajs/vue3';
import SideNavLayout from '@/Layout/SideNavLayout.vue';
import ConfirmDelete from "@/Components/Helper/ConfirmDelete.vue";
import { createToaster } from "@meforma/vue-toaster";
import { usePagination } from '@/utilities/pagination.js';

const toaster = createToaster({
  position: "bottom",
  maxToasts: 5,
  duration: 4000
});

const props = defineProps({
    permissions: Object
});

const page = usePage();

// console.log('page.props.can:', page.props.can);
// console.log('props.permissions:', props.permissions);
// console.log('permissions type:', typeof props.permissions);
// console.log('permissions data:', props.permissions?.data || 'No data property');

// Check permissions
const can = computed(() => page.props.can || []);
const canCreatePermission = computed(() => can.value.includes('create-permission'));
const canEditPermission = computed(() => can.value.includes('edit-permission'));
const canDeletePermission = computed(() => can.value.includes('delete-permission'));

// Handle both paginated and non-paginated data
const permissionsData = computed(() => {
    if (Array.isArray(props.permissions)) {
        // Direct array (from Permission::all())
        return props.permissions;
    } else if (props.permissions?.data) {
        // Paginated data
        return props.permissions.data;
    }
    return [];
});

// Pagination setup
const paginationData = computed(() => props.permissions);
const currentFilters = computed(() => ({})); // Add filters if needed
const {
    goToPage,
    visiblePages,
    shouldShowPagination,
    paginationInfo,
    canGoPrev,
    canGoNext,
    isFirstPage,
    isLastPage
} = usePagination(paginationData, currentFilters, 'permissions.index');

const getItemNumber = (index) => {
    if (Array.isArray(props.permissions)) {
        // Simple array, just return index + 1
        return index + 1;
    } else {
        // Paginated data
        const currentPage = props.permissions.current_page || 1;
        const perPage = props.permissions.per_page || 15;
        return (currentPage - 1) * perPage + index + 1;
    }
};

const formatDate = (dateString) => {
    return new Date(dateString).toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
    });
};

// confirm delete modal
const showDeleteModal = ref(false)
const resourceToDelete = ref(null)
const resourceTitle = ref(null);

const deletePermission = (permission) => {
    if (permission.roles_count > 0) {
        toaster.error('Cannot delete permission that is assigned to roles. Please remove it from all roles first.');
        return;
    }

    resourceToDelete.value = permission.id
    showDeleteModal.value = true;
    resourceTitle.value = `Delete permission "${permissionsData.value.find(item => item.id === permission.id).name}"`   
    
    // Small delay to trigger animation
    setTimeout(() => {
        document.querySelector(".modal-content").classList.add("show");
    }, 10);    

}

const confirmDelete = () => {
    router.delete(route('permissions.destroy', resourceToDelete.value), {
        onSuccess:()=>{
            if(page.props.flash.status===true){
                toaster.success(page.props.flash.message);
                router.get(route('permissions.index'))
            }
            else if(page.props.flash.status===false){
                toaster.error(page.props.flash.message);
            }
            else {
                toaster.error(page.props.flash.message);
            }
        }
    })
    showDeleteModal.value = false
}
</script>

<style scoped>
.permission-name {
    background-color: #f8f9fa;
    padding: 0.25rem 0.5rem;
    border-radius: 0.25rem;
    font-size: 0.875rem;
    color: #495057;
}

.empty-state {
    padding: 2rem;
}

.table th {
    border-top: none;
    font-weight: 600;
    color: #495057;
    background-color: #f8f9fa;
}

.table td {
    vertical-align: middle;
}

.btn-group .btn {
    border-radius: 0.25rem !important;
    margin-right: 0.25rem;
}

.btn-group .btn:last-child {
    margin-right: 0;
}

.badge {
    font-size: 0.75rem;
}

/* Pagination Styles */
.pagination {
    gap: 0.5rem;
}

.pagination .page-item .page-link {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 600;
    color: #333;
    border: none;
    background-color: #f8f9fa;
}

.pagination .page-item.active .page-link {
    background-color: #333;
    color: white;
}
</style>
