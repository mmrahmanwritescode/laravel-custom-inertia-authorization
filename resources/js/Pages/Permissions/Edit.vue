<template>
    <SideNavLayout>
        <div class="container-fluid">
            <div class="row">
                <div class="col-12">
                    <div class="page-header">
                        <h1 class="page-title">Edit Permission</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><Link :href="route('permissions.index')">Permissions</Link></li>
                                <li class="breadcrumb-item active" aria-current="page">Edit Permission</li>
                            </ol>
                        </nav>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-8">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Permission Information</h5>
                        </div>
                        <div class="card-body">
                            <form @submit.prevent="updatePermission">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group mb-3">
                                            <label for="name" class="form-label">Permission Name *</label>
                                            <input 
                                                type="text" 
                                                id="name"
                                                v-model="form.name" 
                                                class="form-control"
                                                :class="{ 'is-invalid': form.errors.name }"
                                            >
                                            <div v-if="form.errors.name" class="invalid-feedback">
                                                {{ form.errors.name }}
                                            </div>
                                            <small class="form-text text-muted">
                                                Use lowercase with hyphens (kebab-case)
                                            </small>
                                        </div>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-between">
                                    <button type="submit" class="btn btn-edit me-2" :disabled="form.processing">
                                        <i class="fa fa-save me-2"></i>
                                        {{ form.processing ? 'Updating...' : 'Update Permission' }}
                                    </button>                                    
                                    <Link href="/permissions" class="btn btn-secondary">
                                        <i class="fa fa-arrow-left me-2"></i>Back to Permissions
                                    </Link>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Permission Details</h5>
                        </div>
                        <div class="card-body">
                            <div class="permission-info">
                                <p><strong>Created:</strong> {{ formatDate(permission.created_at) }}</p>
                                <p><strong>Last Updated:</strong> {{ formatDate(permission.updated_at) }}</p>
                                <p><strong>Used in Roles:</strong> {{ permission.roles_count || 0 }}</p>
                                
                                <div v-if="permission.roles && permission.roles.length > 0" class="mt-3">
                                    <p><strong>Currently assigned to:</strong></p>
                                    <div class="assigned-roles">
                                        <span v-for="role in permission.roles" :key="role.id" class="badge bg-secondary me-1 mb-1">
                                            {{ role.name }}
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card mt-3">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Permission Preview</h5>
                        </div>
                        <div class="card-body">
                            <div class="permission-preview">
                                <div class="preview-item">
                                    <strong>System Name:</strong><br>
                                    <code class="preview-name">{{ form.name }}</code>
                                </div>
                                <!-- <div class="preview-item mt-2">
                                    <strong>Display Name:</strong><br>
                                    <span class="preview-display">{{ form.display_name || 'No display name' }}</span>
                                </div>
                                <div v-if="form.description" class="preview-item mt-2">
                                    <strong>Description:</strong><br>
                                    <small class="text-muted">{{ form.description }}</small>
                                </div> -->
                            </div>
                        </div>
                    </div>

                    <div v-if="permission.roles_count > 0" class="card mt-3">
                        <div class="card-header bg-warning">
                            <h5 class="card-title mb-0 text-dark">
                                <i class="fa fa-exclamation-triangle me-2"></i>Warning
                            </h5>
                        </div>
                        <div class="card-body">
                            <p class="mb-0 small">
                                This permission is currently assigned to {{ permission.roles_count }} role(s). 
                                Changes will affect all users with those roles.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </SideNavLayout>
</template>

<script setup>
import { Link, useForm, router, usePage } from '@inertiajs/vue3';
import { defineProps, ref, computed, watch } from 'vue';
import SideNavLayout from '@/Layout/SideNavLayout.vue';
import { createToaster } from "@meforma/vue-toaster";
import { route } from 'ziggy-js';

const page = usePage();
const toaster = createToaster({
  duration: 4000
});

// Validation Errors
const errors = ref({});

const props = defineProps({
    permission: Object
});

const form = useForm({
    name: props.permission.name,
    display_name: props.permission.display_name || '',
    description: props.permission.description || ''
});

const updatePermission = () => {
    form.put(route('permissions.update', props.permission.id), {
        onSuccess: () => {
          if (page.props.flash.status === true) {
              toaster.success(page.props.flash.message);
              router.get(route('permissions.edit', props.permission.id));
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

const formatDate = (dateString) => {
    return new Date(dateString).toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    });
};
</script>

<style scoped>
.permission-info p {
    margin-bottom: 0.5rem;
}

.permission-info strong {
    color: #495057;
}

.assigned-roles .badge {
    font-size: 0.75rem;
}

.permission-preview {
    background-color: #f8f9fa;
    padding: 1rem;
    border-radius: 0.25rem;
    border: 1px solid #e9ecef;
}

.preview-item {
    margin-bottom: 0.75rem;
}

.preview-item:last-child {
    margin-bottom: 0;
}

.preview-name {
    background-color: #e9ecef;
    padding: 0.25rem 0.5rem;
    border-radius: 0.25rem;
    font-size: 0.875rem;
    color: #495057;
}

.preview-display {
    font-weight: 500;
    color: #495057;
}

.form-text {
    font-size: 0.875rem;
}
</style>
