# FieldSync Supabase Deployment Guide

This guide will help you deploy the FieldSync backend to Supabase and configure the Flutter app to use it.

## 🚀 Overview

FieldSync now uses Supabase as the primary backend platform, providing:
- PostgreSQL database with Row Level Security (RLS)
- Edge Functions for API endpoints
- Real-time subscriptions
- Authentication and user management
- File storage
- Built-in security and scalability

## 📋 Prerequisites

Before starting, make sure you have:
- [Supabase CLI](https://supabase.com/docs/guides/cli) installed
- A [Supabase account](https://supabase.com)
- Node.js 18+ installed
- Flutter SDK installed
- Git for version control

## 🛠️ Installation Steps

### 1. Install Supabase CLI

```bash
# Using npm
npm install -g supabase

# Using Homebrew (macOS)
brew install supabase/tap/supabase

# Using Docker
docker pull supabase/cli
```

### 2. Create Supabase Project

1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Click "New Project"
3. Choose your organization
4. Enter project name: `fieldsync`
5. Enter database password (save this!)
6. Select region closest to your users
7. Click "Create new project"

### 3. Get Project Configuration

From your Supabase project dashboard, note:
- **Project URL**: `https://your-project-ref.supabase.co`
- **Anon Key**: Found in Project Settings > API
- **Service Role Key**: Found in Project Settings > API (keep this secret!)

### 4. Configure Environment

1. Navigate to the supabase-functions directory:
```bash
cd supabase-functions
```

2. Copy environment template:
```bash
cp env.example .env
```

3. Edit `.env` with your project details:
```env
SUPABASE_URL=https://your-project-ref.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
```

### 5. Deploy to Supabase

Run the deployment script:
```bash
./deploy.sh
```

The script will:
- Link to your Supabase project
- Deploy database schema and migrations
- Deploy all Edge Functions
- Set up environment variables
- Generate TypeScript types

### 6. Configure Flutter App

1. Update Supabase configuration in `lib/core/config/supabase_config.dart`:
```dart
class SupabaseConfig {
  static const String supabaseUrl = 'https://your-project-ref.supabase.co';
  static const String supabaseAnonKey = 'your-anon-key';
  // ... rest of configuration
}
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 🔧 Manual Deployment (Alternative)

If you prefer manual deployment:

### 1. Link Project
```bash
supabase login
supabase link --project-ref your-project-ref
```

### 2. Deploy Database
```bash
supabase db push
```

### 3. Deploy Functions
```bash
supabase functions deploy users
supabase functions deploy games
supabase functions deploy announcements
supabase functions deploy statistics
supabase functions deploy activities
```

### 4. Set Environment Variables
```bash
supabase secrets set SUPABASE_URL=your-url
supabase secrets set SUPABASE_SERVICE_ROLE_KEY=your-key
```

## 📊 Database Schema

The database includes these main tables:
- `user_profiles` - User information and preferences
- `teams` - Team data and metadata
- `games` - Game schedules and results
- `game_events` - Goals, cards, substitutions
- `player_game_stats` - Individual performance metrics
- `user_statistics` - Aggregated player statistics
- `announcements` - Team and global announcements
- `notifications` - User notifications
- `recent_activities` - Activity feed data
- `chat_messages` - Team communication

## 🔌 API Endpoints

### Edge Functions
All API endpoints are available at `https://your-project-ref.supabase.co/functions/v1/`:

#### Users API (`/users`)
- `GET /users/profile` - Get current user profile
- `PUT /users/profile` - Update user profile
- `GET /users/{id}` - Get user by ID
- `GET /users/search` - Search users
- `GET /users/{id}/activities` - Get user activities
- `GET /users/{id}/notifications` - Get user notifications

#### Games API (`/games`)
- `GET /games` - Get all games
- `POST /games` - Create new game
- `GET /games/{id}` - Get game details
- `PUT /games/{id}` - Update game
- `GET /games/{id}/events` - Get game events
- `POST /games/{id}/events` - Add game event

#### Announcements API (`/announcements`)
- `GET /announcements` - Get announcements
- `POST /announcements` - Create announcement
- `PUT /announcements/{id}` - Update announcement
- `DELETE /announcements/{id}` - Delete announcement

#### Statistics API (`/statistics`)
- `GET /statistics/user/{id}` - Get user statistics
- `GET /statistics/team/{id}` - Get team statistics
- `GET /statistics/game/{id}` - Get game statistics

#### Activities API (`/activities`)
- `GET /activities` - Get recent activities
- `POST /activities` - Create activity
- `GET /activities/{id}` - Get activity details

## 🔐 Authentication

FieldSync uses Supabase Auth with email/password:

```dart
// Sign in
final response = await SupabaseAuth.signInWithEmailAndPassword(email, password);

// Sign up
final response = await SupabaseAuth.signUpWithEmailAndPassword(email, password);

// Sign out
await SupabaseAuth.signOut();
```

## 📱 Real-time Features

Subscribe to real-time updates:

```dart
// Subscribe to game updates
final channel = SupabaseConfig.client.subscribeToTable(
  'games',
  onUpdate: (payload) {
    // Handle game updates
    print('Game updated: ${payload.newRecord}');
  },
);

// Subscribe to notifications
final notificationChannel = SupabaseConfig.client.subscribeToTable(
  'notifications',
  onInsert: (payload) {
    // Handle new notifications
    showNotification(payload.newRecord);
  },
);
```

## 💾 File Storage

Upload and manage files:

```dart
// Upload file
final publicUrl = await SupabaseStorage.uploadFile(
  'avatars',
  'user123/profile.jpg',
  fileBytes,
  contentType: 'image/jpeg',
);

// Get public URL
final url = SupabaseStorage.getPublicUrl('avatars', 'user123/profile.jpg');
```

## 🔒 Security Configuration

### Row Level Security (RLS)

RLS policies are automatically applied:
- Users can only access their own data
- Team members can see team-related data
- Public data (games, announcements) is accessible to all

### Custom Policies

Add custom RLS policies in Supabase Dashboard:

```sql
-- Example: Allow users to read team data they belong to
CREATE POLICY "Users can read own team data" ON teams
FOR SELECT USING (
  id IN (
    SELECT team_id FROM user_profiles 
    WHERE user_id = auth.uid()
  )
);
```

## 🚧 Environment Setup

### Development
```bash
# Start local Supabase
supabase start

# Reset database
supabase db reset
```

### Production
```bash
# Deploy to production
supabase functions deploy --project-ref your-production-ref

# Link to production
supabase link --project-ref your-production-ref
```

## 📈 Monitoring and Analytics

### Supabase Dashboard
Monitor your deployment:
- Database performance
- Function logs and metrics
- Real-time connections
- Storage usage
- Authentication events

### Logs
View function logs:
```bash
supabase functions logs users --project-ref your-project-ref
```

## 🐛 Troubleshooting

### Common Issues

1. **Function deployment fails**
   ```bash
   # Check function syntax
   deno check supabase/functions/users/index.ts
   
   # Redeploy specific function
   supabase functions deploy users --no-verify-jwt
   ```

2. **Database connection errors**
   ```bash
   # Check connection
   supabase db ping
   
   # Reset local database
   supabase db reset
   ```

3. **Authentication issues**
   ```bash
   # Re-login to Supabase
   supabase logout
   supabase login
   ```

4. **RLS policy blocks**
   - Check policies in Supabase Dashboard
   - Test with service role key
   - Review user permissions

### Debug Mode
Enable debug logs in Flutter:
```dart
SupabaseConfig.initialize(debug: true);
```

## 🔄 Updates and Migrations

### Database Updates
```bash
# Generate migration
supabase migration new add_new_column

# Apply migration
supabase db push
```

### Function Updates
```bash
# Redeploy single function
supabase functions deploy users

# Redeploy all functions
supabase functions deploy
```

## 📚 Additional Resources

- [Supabase Documentation](https://supabase.com/docs)
- [Flutter Supabase Package](https://pub.dev/packages/supabase_flutter)
- [Supabase CLI Reference](https://supabase.com/docs/reference/cli)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

## 🎯 Next Steps

After deployment:

1. **Test all endpoints** using the Supabase Dashboard
2. **Configure production environment** variables
3. **Set up monitoring** and alerts
4. **Configure custom domains** if needed
5. **Set up CI/CD** for automated deployments
6. **Review security policies** and adjust as needed
7. **Optimize database** performance with indexes
8. **Set up backups** for production data

## 💡 Tips for Success

- Always test in development before deploying to production
- Use environment variables for all sensitive data
- Monitor function performance and optimize as needed
- Keep your Supabase CLI updated
- Regular backup your database
- Use RLS policies for security
- Monitor usage to stay within plan limits

---

🎉 **Congratulations!** Your FieldSync backend is now running on Supabase with enterprise-grade scalability and security!


