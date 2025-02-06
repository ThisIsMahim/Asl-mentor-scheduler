import React from 'react';

function Courses() {
  return (
    <div className="space-y-6">
      <div className="bg-white shadow rounded-lg p-6">
        <h2 className="text-2xl font-bold text-gray-900 mb-4">Available Courses</h2>
        <p className="text-gray-600">
          Browse and enroll in available courses.
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <div className="bg-white shadow rounded-lg p-6">
          <h3 className="text-lg font-semibold text-gray-900 mb-2">No courses available</h3>
          <p className="text-gray-600">Check back later for new courses</p>
        </div>
      </div>
    </div>
  );
}

export default Courses;