<?php

namespace App\Http\Controllers;

use App\Models\Permission;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class PermissionController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): Response
    {
        $permissions = Permission::paginate(10); //dd($permissions);

        return Inertia::render('Permissions/Index', [
            'permissions' => $permissions
        ]);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create(): Response
    {
        return Inertia::render('Permissions/Create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255|unique:permissions'
        ]);

        Permission::create([
            'name' => $request->name
        ]);

        return redirect()->route('permissions.index')->with([
            'message' => 'Permission Created Successfully',
            'status' => true,
            'error' => ''
        ]);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Permission $permission): Response
    {
        return Inertia::render('Permissions/Edit', [
            'permission' => $permission
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Permission $permission)
    {
        $request->validate([
            'name' => 'required|string|max:255|unique:permissions,name,' . $permission->id
        ]);

        $permission->update([
            'name' => $request->name
        ]);

        return redirect()->route('permissions.edit', $permission)->with([
            'message' => 'Permission Updated Successfully',
            'status' => true,
            'error' => ''
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Permission $permission)
    {
        // Prevent deletion if permission is assigned to roles
        if ($permission->roles()->count() > 0) {
            return redirect()->route('permissions.index')
                ->with([
                    'message' => 'Permission cannot be deleted because it is assigned to one or more roles.',
                    'status' => false,
                    'error' => ''
                ]);
        }

        $permission->delete();

        return redirect()->route('permissions.index')->with([
            'message' => 'Permission deleted successfully.',
            'status' => true,
            'error' => ''
        ]);
    }
}
