import { serve } from 'https://deno.land/std@0.208.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.38.4'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, accept, user-agent, x-supabase-auth',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
}

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    console.log('🚀 Starting users function...')

    // Initialize Supabase client
    const supabaseUrl = Deno.env.get('SUPABASE_URL') || 'https://ayqcfpldgsfntwlurkca.supabase.co'
    const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') || ''
    
    const supabaseClient = createClient(supabaseUrl, serviceRoleKey, {
      auth: {
        autoRefreshToken: false,
        persistSession: false
      }
    })

    const url = new URL(req.url)
    const pathname = url.pathname
    const method = req.method

    console.log(`👤 Users API: ${method} ${pathname}`)

    // Route: GET /users/profile - Get current user profile
    if (method === 'GET' && pathname === '/users/profile') {
      const authHeader = req.headers.get('Authorization')
      
      if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return new Response(
          JSON.stringify({ message: 'Authentication required' }),
          { 
            status: 401, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      // Get user from auth token
      const token = authHeader.replace('Bearer ', '')
      const { data: { user }, error: authError } = await supabaseClient.auth.getUser(token)

      if (authError || !user) {
        return new Response(
          JSON.stringify({ message: 'Invalid token' }),
          { 
            status: 401, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      // Get user profile
      const { data: profile, error } = await supabaseClient
        .from('user_profiles')
        .select(`
          id,
          name,
          email,
          position,
          jersey_number,
          is_student,
          grade_or_subject,
          avatar_url,
          phone,
          birthdate,
          height_cm,
          weight_kg,
          team:teams(id, name, logo_url)
        `)
        .eq('user_id', user.id)
        .single()

      if (error) {
        console.error('❌ Error fetching profile:', error)
        return new Response(
          JSON.stringify({ 
            message: 'Profile not found',
            error: error.message
          }),
          { 
            status: 404, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      // Get user statistics
      const { data: stats } = await supabaseClient
        .from('user_statistics')
        .select(`
          games_played,
          total_goals,
          total_assists,
          total_shots,
          total_shots_on_target,
          total_passes,
          total_passes_completed,
          total_tackles,
          total_minutes_played,
          average_rating,
          goals_per_game,
          assists_per_game,
          pass_accuracy
        `)
        .eq('user_id', profile.id)
        .eq('season', '2025')
        .single()

      const formattedProfile = {
        id: profile.id,
        name: profile.name,
        email: profile.email,
        position: profile.position,
        jerseyNumber: profile.jersey_number,
        isStudent: profile.is_student,
        gradeOrSubject: profile.grade_or_subject,
        avatarUrl: profile.avatar_url,
        phone: profile.phone,
        birthdate: profile.birthdate,
        heightCm: profile.height_cm,
        weightKg: profile.weight_kg,
        team: profile.team ? {
          id: profile.team.id,
          name: profile.team.name,
          logoUrl: profile.team.logo_url
        } : null,
        statistics: stats ? {
          gamesPlayed: stats.games_played,
          totalGoals: stats.total_goals,
          totalAssists: stats.total_assists,
          totalShots: stats.total_shots,
          totalShotsOnTarget: stats.total_shots_on_target,
          totalPasses: stats.total_passes,
          totalPassesCompleted: stats.total_passes_completed,
          totalTackles: stats.total_tackles,
          totalMinutesPlayed: stats.total_minutes_played,
          averageRating: stats.average_rating,
          goalsPerGame: stats.goals_per_game,
          assistsPerGame: stats.assists_per_game,
          passAccuracy: stats.pass_accuracy
        } : null
      }

      return new Response(
        JSON.stringify({ 
          message: 'Profile retrieved successfully',
          profile: formattedProfile
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Route: PUT /users/profile - Update user profile
    if (method === 'PUT' && pathname === '/users/profile') {
      const authHeader = req.headers.get('Authorization')
      
      if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return new Response(
          JSON.stringify({ message: 'Authentication required' }),
          { 
            status: 401, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      const token = authHeader.replace('Bearer ', '')
      const { data: { user }, error: authError } = await supabaseClient.auth.getUser(token)

      if (authError || !user) {
        return new Response(
          JSON.stringify({ message: 'Invalid token' }),
          { 
            status: 401, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      const updateData = await req.json()

      const { data: updatedProfile, error } = await supabaseClient
        .from('user_profiles')
        .update({
          name: updateData.name,
          position: updateData.position,
          jersey_number: updateData.jerseyNumber,
          phone: updateData.phone,
          height_cm: updateData.heightCm,
          weight_kg: updateData.weightKg,
          avatar_url: updateData.avatarUrl
        })
        .eq('user_id', user.id)
        .select()
        .single()

      if (error) {
        console.error('❌ Error updating profile:', error)
        return new Response(
          JSON.stringify({ 
            message: 'Error updating profile',
            error: error.message
          }),
          { 
            status: 500, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      return new Response(
        JSON.stringify({ 
          message: 'Profile updated successfully',
          profile: updatedProfile
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Route: GET /users/:id - Get user by ID
    if (method === 'GET' && pathname.startsWith('/users/') && pathname !== '/users/profile' && pathname !== '/users/search') {
      const userId = pathname.split('/')[2]
      
      const { data: profile, error } = await supabaseClient
        .from('user_profiles')
        .select(`
          id,
          name,
          position,
          jersey_number,
          is_student,
          grade_or_subject,
          avatar_url,
          team:teams(id, name, logo_url)
        `)
        .eq('id', userId)
        .single()

      if (error) {
        console.error('❌ Error fetching user:', error)
        return new Response(
          JSON.stringify({ 
            message: 'User not found',
            error: error.message
          }),
          { 
            status: 404, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      const { data: stats } = await supabaseClient
        .from('user_statistics')
        .select('games_played, total_goals, total_assists, average_rating')
        .eq('user_id', userId)
        .eq('season', '2025')
        .single()

      const formattedProfile = {
        id: profile.id,
        name: profile.name,
        position: profile.position,
        jerseyNumber: profile.jersey_number,
        isStudent: profile.is_student,
        gradeOrSubject: profile.grade_or_subject,
        avatarUrl: profile.avatar_url,
        team: profile.team ? {
          id: profile.team.id,
          name: profile.team.name,
          logoUrl: profile.team.logo_url
        } : null,
        statistics: stats ? {
          gamesPlayed: stats.games_played,
          totalGoals: stats.total_goals,
          totalAssists: stats.total_assists,
          averageRating: stats.average_rating
        } : null
      }

      return new Response(
        JSON.stringify({ 
          message: 'User retrieved successfully',
          user: formattedProfile
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Route: GET /users/search - Search users
    if (method === 'GET' && pathname === '/users/search') {
      const query = url.searchParams.get('q') || ''
      const teamId = url.searchParams.get('team_id')
      const position = url.searchParams.get('position')
      const limit = parseInt(url.searchParams.get('limit') || '20')
      
      let searchQuery = supabaseClient
        .from('user_profiles')
        .select(`
          id,
          name,
          position,
          jersey_number,
          avatar_url,
          team:teams(id, name)
        `)
        .limit(limit)

      if (query) {
        searchQuery = searchQuery.ilike('name', `%${query}%`)
      }

      if (teamId) {
        searchQuery = searchQuery.eq('team_id', teamId)
      }

      if (position) {
        searchQuery = searchQuery.eq('position', position)
      }

      const { data: users, error } = await searchQuery

      if (error) {
        console.error('❌ Error searching users:', error)
        return new Response(
          JSON.stringify({ 
            message: 'Error searching users',
            error: error.message
          }),
          { 
            status: 500, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      const formattedUsers = users?.map(user => ({
        id: user.id,
        name: user.name,
        position: user.position,
        jerseyNumber: user.jersey_number,
        avatarUrl: user.avatar_url,
        team: user.team ? {
          id: user.team.id,
          name: user.team.name
        } : null
      })) || []

      return new Response(
        JSON.stringify({ 
          message: 'Users retrieved successfully',
          users: formattedUsers
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Route: GET /users/:id/activities - Get user's recent activities
    if (method === 'GET' && pathname.includes('/activities')) {
      const userId = pathname.split('/')[2]
      const limit = parseInt(url.searchParams.get('limit') || '10')
      
      const { data: activities, error } = await supabaseClient
        .from('recent_activities')
        .select(`
          id,
          activity_type,
          title,
          description,
          status,
          activity_data,
          activity_date
        `)
        .eq('user_id', userId)
        .order('activity_date', { ascending: false })
        .limit(limit)

      if (error) {
        console.error('❌ Error fetching activities:', error)
        return new Response(
          JSON.stringify({ 
            message: 'Error fetching activities',
            error: error.message
          }),
          { 
            status: 500, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      const formattedActivities = activities?.map(activity => ({
        id: activity.id,
        type: activity.activity_type,
        title: activity.title,
        subtitle: activity.description,
        status: activity.status,
        timestamp: activity.activity_date,
        metadata: activity.activity_data
      })) || []

      return new Response(
        JSON.stringify({ 
          message: 'Activities retrieved successfully',
          data: formattedActivities
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Route: GET /users/:id/notifications - Get user's notifications
    if (method === 'GET' && pathname.includes('/notifications')) {
      const userId = pathname.split('/')[2]
      const limit = parseInt(url.searchParams.get('limit') || '20')
      const unreadOnly = url.searchParams.get('unread_only') === 'true'
      
      let query = supabaseClient
        .from('notifications')
        .select(`
          id,
          title,
          body,
          notification_type,
          data,
          is_read,
          sent_at
        `)
        .eq('user_id', userId)
        .order('sent_at', { ascending: false })
        .limit(limit)

      if (unreadOnly) {
        query = query.eq('is_read', false)
      }

      const { data: notifications, error } = await query

      if (error) {
        console.error('❌ Error fetching notifications:', error)
        return new Response(
          JSON.stringify({ 
            message: 'Error fetching notifications',
            error: error.message
          }),
          { 
            status: 500, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      const formattedNotifications = notifications?.map(notification => ({
        id: notification.id,
        title: notification.title,
        body: notification.body,
        type: notification.notification_type,
        data: notification.data,
        isRead: notification.is_read,
        sentAt: notification.sent_at
      })) || []

      return new Response(
        JSON.stringify({ 
          message: 'Notifications retrieved successfully',
          notifications: formattedNotifications
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Route: PUT /users/:id/notifications/:notificationId - Mark notification as read
    if (method === 'PUT' && pathname.includes('/notifications/')) {
      const pathParts = pathname.split('/')
      const userId = pathParts[2]
      const notificationId = pathParts[4]
      
      const { error } = await supabaseClient
        .from('notifications')
        .update({ is_read: true })
        .eq('id', notificationId)
        .eq('user_id', userId)

      if (error) {
        console.error('❌ Error updating notification:', error)
        return new Response(
          JSON.stringify({ 
            message: 'Error updating notification',
            error: error.message
          }),
          { 
            status: 500, 
            headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
          }
        )
      }

      return new Response(
        JSON.stringify({ 
          message: 'Notification marked as read'
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Route not found
    return new Response(
      JSON.stringify({ message: 'Route not found' }),
      { 
        status: 404, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    )

  } catch (error) {
    console.error('❌ Function error:', error)
    return new Response(
      JSON.stringify({ 
        message: 'Internal server error',
        error: error.message
      }),
      { 
        status: 500, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    )
  }
})