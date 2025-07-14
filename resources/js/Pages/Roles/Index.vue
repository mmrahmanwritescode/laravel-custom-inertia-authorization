<template>
  <SideNavLayout>
    <div class="container-fluid">
      <div class="row">
        <div class="col-md-12">
          <div class="card admin-card">
            <div class="card-header d-flex justify-content-between align-items-center">
              <h3 class="card-title">Roles Management</h3>
              <Link v-if="canCreateRole" :href="route('roles.create')" class="btn btn-dark create-btn">
                <i class="fa fa-plus me-1"></i> Create Role
              </Link>
            </div>
            <div class="card-body">
              <div class="table-responsive admin-table">
                <table class="table table-striped">
                  <thead>
                    <tr>
                      <th>ID</th>
                      <th>Name</th>
                      <th>Permissions</th>
                      <th>Created At</th>
                      <th v-if="canEditRole || canDeleteRole">Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="role in rolesData" :key="role.id">
                      <td>{{ role.id }}</td>
                      <td>
                        <span class="badge bg-primary">{{ role.name }}</span>
                      </td>
                      <td>
                        <span 
                          v-for="permission in role.permissions" 
                          :key="permission.id"
                          class="badge bg-secondary me-1 mb-1"
                          style="font-size: 0.75em;"
                        >
                          {{ permission.name }}
                        </span>
                        <span v-if="role.permissions.length === 0" class="text-muted">No permissions</span>
                      </td>
                      <td>{{ formatDate(role.created_at) }}</td>
                      <td v-if="canEditRole || canDeleteRole" class="edit-delete-container">
                        <Link v-if="canEditRole" :href="`/roles/${role.id}/edit`" class="btn btn-edit btn-sm me-1">
                          Edit
                        </Link>
                        <button v-if="canDeleteRole" @click="deleteResource(role.id)" class="btn btn-delete btn-sm">
                          Delete
                        </button>
                      </td>
                    </tr>
                    <tr v-if="rolesData.length === 0">
                      <td :colspan="canEditRole || canDeleteRole ? 5 : 4" class="text-center text-muted py-4">
                        No roles found.
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
          </div>
        </div>
      </div>
    </div>
    <!-- Confirm Dialog Component -->
    <ConfirmDelete :isOpen="showDeleteModal"
                   :title="resourceTitle"
                   message="Are you sure you want to delete this role?"
                   @close="showDeleteModal = false"
                   @confirm="confirmDelete"/>      
  </SideNavLayout>
</template>

<script setup>
import { ref, defineProps, computed } from 'vue';
import { Link, usePage, router } from '@inertiajs/vue3';
import SideNavLayout from '@/Layout/SideNavLayout.vue';
import ConfirmDelete from "@/Components/Helper/ConfirmDelete.vue";
import { createToaster } from "@meforma/vue-toaster";
import { usePagination } from '@/utilities/pagination.js';


const page = usePage();
const permissions = computed(() => page.props.can || []);
const toaster = createToaster({
  position: "bottom",
  maxToasts: 5,
  duration: 4000
});

const props = defineProps({
  roles: {
    type: [Array, Object],
    default: () => []
  }
});

// Handle both paginated and non-paginated data
const rolesData = computed(() => {
  if (Array.isArray(props.roles)) {
    return props.roles;
  } else if (props.roles?.data) {
    return props.roles.data;
  }
  return [];
});

// Pagination setup
const paginationData = computed(() => props.roles);
const currentFilters = computed(() => ({}));
const {
  goToPage,
  visiblePages,
  shouldShowPagination,
  paginationInfo,
  canGoPrev,
  canGoNext,
  isFirstPage,
  isLastPage
} = usePagination(paginationData, currentFilters, 'roles.index');

// Permission checks
const canCreateRole = computed(() => permissions.value.includes('create-role'));
const canEditRole = computed(() => permissions.value.includes('edit-role'));
const canDeleteRole = computed(() => permissions.value.includes('delete-role'));

const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString();
};

// confirm delete modal
const showDeleteModal = ref(false)
const resourceToDelete = ref(null)
const resourceTitle = ref(null);

const deleteResource = (id) => {
    resourceToDelete.value = id
    showDeleteModal.value = true;
    resourceTitle.value = `Delete role "${rolesData.value.find(item => item.id === id).name}"`

    // Small delay to trigger animation
    setTimeout(() => {
        document.querySelector(".modal-content").classList.add("show");
    }, 10);
};

const confirmDelete = () => {
    router.delete(route('roles.destroy', resourceToDelete.value), {
        onSuccess:()=>{
            if(page.props.flash.status===true){
                toaster.success(page.props.flash.message);
                router.get(route('roles.index'))
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
.card {
  margin-bottom: 20px;
}

.badge {
  font-size: 0.875em;
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

.pagination .page-item.disabled .page-link {
    background-color: #e9ecef;
    color: #6c757d;
}

.pagination-info {
    font-size: 0.875rem;
}
</style>
