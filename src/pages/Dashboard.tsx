import React from 'react';
import { useAuthStore } from '../stores/auth';

function Dashboard() {
  const { profile } = useAuthStore();

  return (
    <div className="space-y-6">
      <div className="bg-white shadow rounded-lg p-6">
        <h2 className="text-2xl font-bold text-gray-900 mb-4">Welcome, {profile?.full_name}</h2>
        <p className="text-gray-600">
          This is your personal dashboard where you can manage your courses and schedule.
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <div className="bg-white shadow rounded-lg p-6">
          <h3 className="text-lg font-semibold text-gray-900 mb-2">Quick Actions</h3>
          <ul className="space-y-2">
            <li>
              <a href="/courses" className="text-indigo-600 hover:text-indigo-800">
                Browse Courses
              </a>
            </li>
            <li>
              <a href="/schedule" className="text-indigo-600 hover:text-indigo-800">
                View Schedule
              </a>
            </li>
          </ul>
        </div>

        <div className="bg-white shadow rounded-lg p-6">
          <h3 className="text-lg font-semibold text-gray-900 mb-2">Upcoming Sessions</h3>
          <p className="text-gray-600">No upcoming sessions</p>
        </div>

        <div className="bg-white shadow rounded-lg p-6">
          <h3 className="text-lg font-semibold text-gray-900 mb-2">Recent Activity</h3>
          <p className="text-gray-600">No recent activity</p>
        </div>
      </div>
    </div>
  );
}

export default Dashboard;