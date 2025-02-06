import React from 'react';

function Schedule() {
  return (
    <div className="space-y-6">
      <div className="bg-white shadow rounded-lg p-6">
        <h2 className="text-2xl font-bold text-gray-900 mb-4">Schedule</h2>
        <p className="text-gray-600">
          Manage your availability and view scheduled sessions.
        </p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-white shadow rounded-lg p-6">
          <h3 className="text-lg font-semibold text-gray-900 mb-2">Your Availability</h3>
          <p className="text-gray-600">No availability set</p>
        </div>

        <div className="bg-white shadow rounded-lg p-6">
          <h3 className="text-lg font-semibold text-gray-900 mb-2">Upcoming Sessions</h3>
          <p className="text-gray-600">No upcoming sessions</p>
        </div>
      </div>
    </div>
  );
}

export default Schedule;