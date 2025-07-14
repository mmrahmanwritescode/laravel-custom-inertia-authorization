<template>
    <SideNavLayout>
        <div class="container-fluid">
            <div class="row">
                <div class="col-12">
                    <div class="page-header">
                        <h1 class="page-title">Create Role</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><Link :href="route('roles.index')">Roles</Link></li>
                                <li class="breadcrumb-item active" aria-current="page">Create Role</li>
                            </ol>
                        </nav>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-8">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Role Information</h5>
                        </div>
                        <div class="card-body">
                            <form @submit.prevent="createRole">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group mb-3">
                                            <label for="name" class="form-label">Role Name *</label>
                                            <input 
                                                type="text" 
                                                id="name"
                                                v-model="form.name" 
                                                class="form-control"
                                                :class="{ 'is-invalid': form.errors.name }"
                                                placeholder="Enter role name"
                                            >
                                            <div v-if="form.errors.name" class="invalid-feedback">
                                                {{ form.errors.name }}
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group mb-3">
                                            <label for="display_name" class="form-label">Display Name</label>
                                            <input 
                                                type="text" 
                                                id="display_name"
                                                v-model="form.display_name" 
                                                class="form-control"
                                                :class="{ 'is-invalid': form.errors.display_name }"
                                                placeholder="Enter display name"
                                            >
                                            <div v-if="form.errors.display_name" class="invalid-feedback">
                                                {{ form.errors.display_name }}
                                            </div>
                                            <small class="form-text text-muted">
                                                Human-readable name for this role
                                            </small>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group mb-4">
                                    <label for="description" class="form-label">Description</label>
                                    <textarea 
                                        id="description"
                                        v-model="form.description" 
                                        class="form-control"
                                        :class="{ 'is-invalid': form.errors.description }"
                                        rows="3"
                                        placeholder="Describe the role's purpose and responsibilities"
                                    ></textarea>
                                    <div v-if="form.errors.description" class="invalid-feedback">
                                        {{ form.errors.description }}
                                    </div>
                                </div>

                                <div class="form-group mb-4">
                                    <label class="form-label">Permissions</label>
                                    <div v-if="permissions.length > 0" class="permissions-grid">
                                        <div v-for="permission in permissions" :key="permission.id" class="permission-item">
                                            <div class="form-check">
                                                <input 
                                                    type="checkbox" 
                                                    :id="`permission_${permission.id}`"
                                                    :value="permission.id"
                                                    v-model="form.permissions"
                                                    class="form-check-input"
                                                >
                                                <label :for="`permission_${permission.id}`" class="form-check-label">
                                                    <strong>{{ permission.name }}</strong>
                                                    <div v-if="permission.description" class="permission-description">
                                                        {{ permission.description }}
                                                    </div>
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                    <div v-else class="text-muted">
                                        No permissions available
                                    </div>
                                    <div v-if="form.errors.permissions" class="text-danger mt-2">
                                        {{ form.errors.permissions }}
                                    </div>
                                </div>

                                <div class="">
                                    <button type="submit" class="btn btn-edit me-2" :disabled="form.processing">
                                        <i class="fa fa-plus me-2"></i>
                                        {{ form.processing ? 'Creating...' : 'Create Role' }}
                                    </button>                                    
                                    <Link href="/roles" class="btn btn-secondary me-2">
                                        <i class="fa fa-arrow-left me-2"></i>Back to Roles
                                    </Link>
                                    <button type="button" @click="selectAllPermissions" class="btn btn-outline-primary me-2">
                                        <i class="fa fa-check-double me-2"></i>Select All
                                    </button>
                                    <button type="button" @click="clearAllPermissions" class="btn btn-outline-secondary me-2">
                                        <i class="fa fa-times me-2"></i>Clear All
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Role Guidelines</h5>
                        </div>
                        <div class="card-body">
                            <div class="guidelines">
                                <h6><i class="fa fa-info-circle text-info me-2"></i>Role Creation Tips</h6>
                                <ul class="list-unstyled">
                                    <li><i class="fa fa-check text-success me-2"></i>Use lowercase, kebab-case for role names</li>
                                    <li><i class="fa fa-check text-success me-2"></i>Make display names user-friendly</li>
                                    <li><i class="fa fa-check text-success me-2"></i>Assign relevant permissions only</li>
                                    <li><i class="fa fa-check text-success me-2"></i>Write clear descriptions</li>
                                </ul>

                                <h6 class="mt-3"><i class="fa fa-lightbulb text-warning me-2"></i>Examples</h6>
                                <div class="example-roles">
                                    <small class="text-muted">
                                        <strong>admin</strong> → Admin<br>
                                        <strong>manager</strong> → Manager<br>
                                        <strong>staff</strong> → Staff Member<br>
                                        <strong>customer</strong> → Customer
                                    </small>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card mt-3">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Selected Permissions</h5>
                        </div>
                        <div class="card-body">
                            <div v-if="selectedPermissions.length > 0" class="selected-permissions">
                                <span v-for="permission in selectedPermissions" :key="permission.id" class="badge bg-primary me-1 mb-1">
                                    {{ permission.name }}
                                </span>
                            </div>
                            <div v-else class="text-muted">
                                No permissions selected
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </SideNavLayout>
</template>

<script setup>
import { defineProps, ref, computed, watch } from 'vue';
import { router, Link, useForm, usePage } from '@inertiajs/vue3';
import SideNavLayout from '@/Layout/SideNavLayout.vue';
import { createToaster } from "@meforma/vue-toaster";

const page = usePage();
const toaster = createToaster({
  duration: 4000
});

// Validation Errors
const errors = ref({});

const props = defineProps({
    permissions: Array
});

const form = useForm({
    name: '',
    display_name: '',
    description: '',
    permissions: []
});

const selectedPermissions = computed(() => {
    return props.permissions.filter(permission => 
        form.permissions.includes(permission.id)
    );
});

const createRole = () => {

  form.post(route('roles.store'), {
    onSuccess: () => {
      if (page.props.flash.status === true) {
        toaster.success(page.props.flash.message);
        router.get(route('roles.index'));
      } else {
        toaster.error(page.props.flash.message);
      }
    },
    onError: (errors) => {
      Object.keys(errors).forEach(key => {
        if (errors[key]) {
          toaster.error(errors[key]);
        }
      });
    }
  });
};

const selectAllPermissions = () => {
    form.permissions = props.permissions.map(p => p.id);
};

const clearAllPermissions = () => {
    form.permissions = [];
};
</script>

<style scoped>
.permissions-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 1rem;
    max-height: 300px;
    overflow-y: auto;
    border: 1px solid #dee2e6;
    border-radius: 0.375rem;
    padding: 1rem;
    background-color: #f8f9fa;
}

.permission-item {
    padding: 0.5rem;
    border: 1px solid #e9ecef;
    border-radius: 0.25rem;
    background-color: white;
}

.permission-description {
    font-size: 0.75rem;
    color: #6c757d;
    margin-top: 0.25rem;
}

.guidelines h6 {
    font-size: 0.9rem;
    font-weight: 600;
    color: #495057;
}

.guidelines ul li {
    font-size: 0.875rem;
    margin-bottom: 0.25rem;
    color: #6c757d;
}

.example-roles {
    background-color: #f8f9fa;
    padding: 0.75rem;
    border-radius: 0.25rem;
    margin-top: 0.5rem;
}

.selected-permissions .badge {
    font-size: 0.75rem;
}
</style>
