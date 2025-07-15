<?php

namespace App\Http\Middleware;

use App\Models\User;
use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

class PermissionMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next, string $permission): Response
    {
        $user_id = $request->session()->get('user_id', 'default');
        // dd($permission);

        $user = User::find($user_id);

        if (!$user || !$user->hasPermission($permission)) {
            $request->session()->flash('error','Unauthorized. You do not have the required permission!');
            return redirect(route('DashboardPage'));
        }

        return $next($request);
    }
}
