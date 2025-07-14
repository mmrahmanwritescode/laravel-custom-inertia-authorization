<?php

namespace Database\Seeders;

use App\Models\Role;
use App\Models\Permission;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class RolePermissionSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $adminRole = Role::where('name', 'admin')->first();
        $staffRole = Role::where('name', 'staff')->first();
        
        $permissions = Permission::all();
        
        // Admin gets all permissions
        $adminRole->permissions()->attach($permissions);
        
        // Staff gets only view and limited create/edit permissions
        $staffRole->permissions()->attach(
            Permission::whereIn('name', [
                'view-user', 
                'view-product',
                'create-product',
                'edit-product'
            ])->get()
        );
    }
}
