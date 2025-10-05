export interface User {
  id: string;
  email: string;
  name: string;
  phone?: string;
  is_student: boolean;
  grade_or_subject?: string;
  created_at: Date;
  updated_at: Date;
}

export interface Team {
  id: number;
  name: string;
  description?: string;
  created_at: Date;
}

export interface TeamMember {
  id: number;
  team_id: number;
  user_id: string;
  role: string;
  joined_at: Date;
}

export interface Game {
  id: number;
  title: string;
  home_team_id: number;
  away_team_id: number;
  game_date: Date;
  venue?: string;
  status: 'scheduled' | 'in_progress' | 'completed' | 'cancelled';
  home_score: number;
  away_score: number;
  created_at: Date;
}

export interface GameStats {
  id: number;
  game_id: number;
  user_id: string;
  goals: number;
  assists: number;
  yellow_cards: number;
  red_cards: number;
  minutes_played: number;
  created_at: Date;
}

export interface Announcement {
  id: number;
  title: string;
  content: string;
  tag: string;
  author_id: string;
  view_count: number;
  created_at: Date;
  updated_at: Date;
}

export interface Attachment {
  id: number;
  announcement_id: number;
  file_name: string;
  file_path: string;
  file_size: number;
  file_type?: string;
  created_at: Date;
}

export interface Notification {
  id: number;
  user_id: string;
  title: string;
  message: string;
  type: string;
  is_read: boolean;
  created_at: Date;
}

export interface AuthRequest extends Request {
  user?: {
    uid: string;
    email: string;
    name?: string;
  };
} 