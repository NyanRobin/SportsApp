// Mock user data for development
const mockUsers = {
  'user1': {
    user_id: 'user1',
    email: 'kim.minseok@school.edu',
    name: 'Kim Minseok',
    phone_number: '010-1234-5678',
    profile_image_url: null,
    position: 'Forward',
    team_id: 'team1',
    team_name: 'Daehan High School',
    is_student: true,
    grade_or_subject: '3학년',
    student_id: '2023-001',
    department: null,
    role: 'player',
    is_active: true,
    created_at: '2023-03-01T00:00:00Z',
    updated_at: '2025-01-15T00:00:00Z',
    permissions: ['edit_profile', 'player'],
    stats: {
      games_played: 15,
      total_goals: 12,
      total_assists: 8,
      total_yellow_cards: 2,
      total_red_cards: 0,
      total_minutes_played: 1350,
      avg_goals_per_game: 0.8,
      avg_assists_per_game: 0.53
    }
  },
  'user2': {
    user_id: 'user2',
    email: 'park.jisung@school.edu',
    name: 'Park Jisung',
    phone_number: '010-2345-6789',
    profile_image_url: null,
    position: 'Midfielder',
    team_id: 'team2',
    team_name: 'Gangbuk High School',
    is_student: true,
    grade_or_subject: '2학년',
    student_id: '2024-002',
    department: null,
    role: 'player',
    is_active: true,
    created_at: '2024-03-01T00:00:00Z',
    updated_at: '2025-01-15T00:00:00Z',
    permissions: ['edit_profile', 'player'],
    stats: {
      games_played: 12,
      total_goals: 8,
      total_assists: 15,
      total_yellow_cards: 1,
      total_red_cards: 0,
      total_minutes_played: 1080,
      avg_goals_per_game: 0.67,
      avg_assists_per_game: 1.25
    }
  },
  'coach1': {
    user_id: 'coach1',
    email: 'lee.coach@school.edu',
    name: 'Lee Junho',
    phone_number: '010-3456-7890',
    profile_image_url: null,
    position: null,
    team_id: 'team1',
    team_name: 'Daehan High School',
    is_student: false,
    grade_or_subject: null,
    student_id: null,
    department: 'Physical Education',
    role: 'coach',
    is_active: true,
    created_at: '2020-03-01T00:00:00Z',
    updated_at: '2025-01-15T00:00:00Z',
    permissions: ['edit_profile', 'coach', 'manage_team'],
    stats: null
  }
};

class UserService {
  async getUserProfile(userId) {
    // Return mock user if exists, otherwise return a default profile
    if (mockUsers[userId]) {
      return mockUsers[userId];
    }
    
    // Return default profile for any unknown userId
    return {
      user_id: userId,
      email: 'user@fieldsync.app',
      name: '김민수',
      phone_number: '010-1234-5678',
      profile_image_url: null,
      position: 'Forward',
      team_id: 'team1',
      team_name: 'FieldSync FC',
      is_student: true,
      grade_or_subject: '3학년 A반',
      student_id: '2025-001',
      department: null,
      role: 'player',
      is_active: true,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
      permissions: ['edit_profile', 'player'],
      stats: {
        games_played: 15,
        total_goals: 12,
        total_assists: 8,
        total_yellow_cards: 2,
        total_red_cards: 0,
        total_minutes_played: 1350,
        avg_goals_per_game: 0.8,
        avg_assists_per_game: 0.53
      }
    };
  }

  async getCurrentUserProfile(userId) {
    // Use the same logic as getUserProfile
    return this.getUserProfile(userId);
  }

  async updateUserProfile(userId, updateData) {
    if (!mockUsers[userId]) {
      throw new Error('User not found');
    }

    // Update user data
    mockUsers[userId] = {
      ...mockUsers[userId],
      ...updateData,
      updated_at: new Date().toISOString()
    };

    return mockUsers[userId];
  }

  async getAllUsers(filters = {}) {
    let users = Object.values(mockUsers);

    // Apply filters
    if (filters.search) {
      const searchTerm = filters.search.toLowerCase();
      users = users.filter(user => 
        user.name.toLowerCase().includes(searchTerm) ||
        user.email.toLowerCase().includes(searchTerm) ||
        (user.department && user.department.toLowerCase().includes(searchTerm))
      );
    }

    if (filters.role) {
      users = users.filter(user => user.role === filters.role);
    }

    if (filters.department) {
      users = users.filter(user => user.department === filters.department);
    }

    if (filters.isActive !== undefined) {
      users = users.filter(user => user.is_active === filters.isActive);
    }

    // Apply pagination
    const page = filters.page || 1;
    const limit = filters.limit || 10;
    const startIndex = (page - 1) * limit;
    const endIndex = startIndex + limit;

    return {
      users: users.slice(startIndex, endIndex),
      total: users.length,
      page: page,
      limit: limit,
      totalPages: Math.ceil(users.length / limit)
    };
  }

  async updateUserRole(userId, role) {
    if (!mockUsers[userId]) {
      throw new Error('User not found');
    }

    mockUsers[userId].role = role;
    mockUsers[userId].updated_at = new Date().toISOString();

    return mockUsers[userId];
  }

  async updateUserStatus(userId, isActive) {
    if (!mockUsers[userId]) {
      throw new Error('User not found');
    }

    mockUsers[userId].is_active = isActive;
    mockUsers[userId].updated_at = new Date().toISOString();

    return mockUsers[userId];
  }

  async deleteUser(userId) {
    if (!mockUsers[userId]) {
      throw new Error('User not found');
    }

    delete mockUsers[userId];
    return { message: 'User deleted successfully' };
  }

  async getTeamMembers(teamId) {
    return Object.values(mockUsers).filter(user => user.team_id === teamId);
  }

  async addUserToTeam(userId, teamId) {
    if (!mockUsers[userId]) {
      throw new Error('User not found');
    }

    mockUsers[userId].team_id = teamId;
    mockUsers[userId].updated_at = new Date().toISOString();

    return mockUsers[userId];
  }

  async removeUserFromTeam(userId, teamId) {
    if (!mockUsers[userId]) {
      throw new Error('User not found');
    }

    mockUsers[userId].team_id = null;
    mockUsers[userId].team_name = null;
    mockUsers[userId].updated_at = new Date().toISOString();

    return mockUsers[userId];
  }

  async getUserPermissions(userId) {
    if (!mockUsers[userId]) {
      throw new Error('User not found');
    }

    return mockUsers[userId].permissions || [];
  }

  async updateUserPermissions(userId, permissions) {
    if (!mockUsers[userId]) {
      throw new Error('User not found');
    }

    mockUsers[userId].permissions = permissions;
    mockUsers[userId].updated_at = new Date().toISOString();

    return mockUsers[userId].permissions;
  }

  async changePassword(userId, currentPassword, newPassword) {
    // In a real implementation, you would verify the current password
    // and hash the new password before storing it
    return { message: 'Password changed successfully' };
  }

  async requestAccountDeletion(userId, reason) {
    // In a real implementation, you would create a deletion request
    // and notify administrators
    return { message: 'Account deletion request submitted' };
  }
}

module.exports = new UserService(); 