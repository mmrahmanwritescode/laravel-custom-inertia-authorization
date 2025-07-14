<?php

namespace Database\Seeders;

use App\Models\Permission;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class PermissionSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // User permissions
        Permission::create(['name' => 'view-user']);
        Permission::create(['name' => 'create-user']);
        Permission::create(['name' => 'edit-user']);
        Permission::create(['name' => 'delete-user']);
        
        // Product permissions
        Permission::create(['name' => 'view-product']);
        Permission::create(['name' => 'create-product']);
        Permission::create(['name' => 'edit-product']);
        Permission::create(['name' => 'delete-product']);
        
        // Role permissions (admin only)
        Permission::create(['name' => 'view-role']);
        Permission::create(['name' => 'create-role']);
        Permission::create(['name' => 'edit-role']);
        Permission::create(['name' => 'delete-role']);
        
        // Permission permissions (admin only)
        Permission::create(['name' => 'view-permission']);
        Permission::create(['name' => 'create-permission']);
        Permission::create(['name' => 'edit-permission']);
        Permission::create(['name' => 'delete-permission']);
    }
}
